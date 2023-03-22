//===- ColossusCountedLoopMIRPass - MIR level targeting of hardware loops -===//
//    Copyright (c) 2023 Graphcore Ltd. All Rights Reserved.
//     Licensed under the Apache License, Version 2.0 (the "License");
//     you may not use this file except in compliance with the License.
//     You may obtain a copy of the License at
//
//        http://www.apache.org/licenses/LICENSE-2.0
//
//     Unless required by applicable law or agreed to in writing, software
//     distributed under the License is distributed on an "AS IS" BASIS,
//     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//     See the License for the specific language governing permissions and
//     limitations under the License.
// --- LLVM Exceptions to the Apache 2.0 License ----
//
// As an exception, if, as a result of your compiling your source code, portions
// of this Software are embedded into an Object form of such source code, you
// may redistribute such embedded portions in such Object form without complying
// with the conditions of Sections 4(a), 4(b) and 4(d) of the License.
//
// In addition, if you combine or link compiled forms of this Software with
// software that is licensed under the GPLv2 ("Combined Software") and if a
// court of competent jurisdiction determines that the patent provision (Section
// 3), the indemnity provision (Section 9) or other Section of the License
// conflicts with the conditions of the GPLv2, you may retroactively and
// prospectively choose to deem waived or otherwise exclude such Section(s) of
// the License, but only in their entirety and only with respect to the Combined
// Software.
//
//===----------------------------------------------------------------------===//
//
// This pass translates counted loop pseudo instructions into real instructions
// See HardwareLoops + ColossusLoopConversion for the IR passes that introduces
// the intrinsics that ColossusISelLowering lowers to ISD nodes that
// ColossusInstrInfo.td lowers to these pseudo instructions.
//
//===----------------------------------------------------------------------===//

#include <algorithm>
#include <iterator>

#include "Colossus.h"
#include "ColossusCoissueUtil.h"
#include "ColossusCountedLoopOptions.h"
#include "ColossusSubtarget.h"
#include "ColossusTargetInstr.h"
#include "MCTargetDesc/ColossusMCInstrInfo.h"

#include "llvm/CodeGen/MachineBasicBlock.h"
#include "llvm/CodeGen/MachineDominators.h"
#include "llvm/CodeGen/MachineFunctionPass.h"
#include "llvm/CodeGen/MachineInstrBuilder.h"
#include "llvm/CodeGen/MachineLoopInfo.h"
#include "llvm/CodeGen/TargetInstrInfo.h"
#include "llvm/InitializePasses.h"
#include "llvm/MC/TargetRegistry.h"
#include "llvm/Support/Error.h"
#include "llvm/Support/GenericDomTreeConstruction.h"

using namespace llvm;
#define DEBUG_TYPE "colossus-counted-loop-mir"
#define PASS_NAME "Colossus Counted Loop MIR Pass"

static cl::opt<unsigned> MaxNopCount(
    "max-nops-in-rpt", cl::Hidden, cl::init(4),
    cl::desc("Set the Colossus maximum number of co-issued nop/fnop "
             "instructions in a rpt body."));
static cl::opt<float> NopThreshold(
    "nop-threshold-in-rpt", cl::Hidden, cl::init(0.5),
    cl::desc("Set the Colossus maximum ratio of nop/fnop instructions "
             " in a rpt body."));
namespace {
class ColossusCountedLoopMIR : public MachineFunctionPass {
private:
  const MachineDominatorTree *MDT = nullptr;
  const MachineLoopInfo *MLI = nullptr;
  const TargetInstrInfo *TII = nullptr;

  // After software pipelining, it's hard to retrieve the original
  // pre-pipelining preheader required to lower the cloops (guard is added to
  // preheader invalidating the 'preheader'ness of the basic block). Add to that
  // the possibility that only half of the cloop pseudo instructions got emitted
  // due to failure to emit the other half in isellowering and it becomes really
  // hard to find the original preheader. We'll try to do an initial traversal
  // of the loops and populate the map if the original preheader with cloop
  // pseudos can be found.
  DenseMap<MachineLoop *, MachineBasicBlock *> PreheaderMap;

public:
  static char ID;
  explicit ColossusCountedLoopMIR() : MachineFunctionPass(ID) {}

  bool runOnMachineFunction(MachineFunction &F) override;
  void gatherPreheaders(MachineLoop &L, MachineBasicBlock *ParentPreheader);
  MachineBasicBlock *getPreheader(MachineLoop &L, bool &isPipelined);
  bool traverseLoop(MachineLoop &L);
  bool cleanPrologs(MachineBasicBlock *Preheader,
                    MachineBasicBlock *EndValueBB);

  StringRef getPassName() const override { return PASS_NAME; }

  void getAnalysisUsage(AnalysisUsage &AU) const override {
    AU.addRequired<MachineDominatorTree>();
    AU.addRequired<MachineLoopInfo>();
    MachineFunctionPass::getAnalysisUsage(AU);
  }
};
} // namespace
char ColossusCountedLoopMIR::ID = 0;
INITIALIZE_PASS_BEGIN(ColossusCountedLoopMIR, DEBUG_TYPE, PASS_NAME, false,
                      false)
INITIALIZE_PASS_DEPENDENCY(MachineDominatorTree)
INITIALIZE_PASS_DEPENDENCY(MachineLoopInfo)
INITIALIZE_PASS_END(ColossusCountedLoopMIR, DEBUG_TYPE, PASS_NAME, false, false)
FunctionPass *llvm::createColossusCountedLoopMIRPass() {
  return new ColossusCountedLoopMIR();
}

// This parse transforms counted loops expressed in terms of CLOOP_* pseudos
// into real instructions. This pass runs after register allocation in order to
// determine an accurate instruction count for rpt.

// A generalised input, removing coissue operands for clarity:
// bb.0.entry:
//   successors: %bb.1, %bb.X, ...
//   InstrG
//   CLOOP_GUARD_BRANCH $mi, %bb.X
//   InstrH
//   br %bb.1 # may be elided
//
// bb.1.for.body.preheader:
//   successors: %bb.2
//   InstrA
//   $mi = CLOOP_BEGIN_VALUE killed $mi, m # out reg == in reg
//   InstrB
//   CLOOP_BEGIN_TERMINATOR $mi, m
//   InstrC
//   br %bb.2 # may be elided
//
// bb.2.for.body:
// ; predecessors: %bb.1, %bb.2
//   successors: %bb.2, %bb.3
//   liveins: $mi, others
//   InstrD
//   $mi = CLOOP_END_VALUE killed $mi, m # out reg == in reg
//   InstrE
//   CLOOP_END_BRANCH $mi, %bb.2, m
//   InstrF
//   br %bb.3 # may be elided
//
// The unconditional branches at the end of the blocks may have been removed
// by analyzeBranch.
// InstrA represents whatever comes before this loop. It shouldn't contain
// another counted loop, as each body gets its own basic block.
// InstrB will generally not be empty.
// InstrC is ideally empty, but can contain copies introduced by phi elimination
// InstrD is the first part of the loop body. InstrE the second part.
// InstrF is ideally empty, but can contain copies introduced by phi
// elimination.
//
// InstrG represents whatever comes before the loop guard.
// InstrH should be empty, but the passes assume there could be instructions.
// CLOOP_GUARD_BRANCH may not always be present, such as hinting on
// brnzdec or if loop entry required a different comparison, eg `while (x < y)`.
// In this case a BRZ instruction may be present instead. This ideally should
// branch to loop exit (bb.3 above), but might be different. bb.0 ideally has 2
// successors, but could have 1 if no loop guard (known nonzero trip count) or
// more for complex cases. Any possible branch in InstrH would be considered a
// terminator instruction.

// The fallback transform, used when nothing better is available, transforms to:
// bb.0.entry:
//   successors: %bb.1
//   InstrG
//   brz $mi, %bb.X
//   InstrH
//   br %bb.1 # may be elided
//
// bb.1.for.body.preheader:
//   successors: %bb.2
//   InstrA
//   InstrB
//   InstrC
//   br %bb.2 # may be elided
//
// bb.2.for.body:
// ; predecessors: %bb.1, %bb.2
//   successors: %bb.2, %bb.3
//   liveins: $mi, others
//   InstrD
//   $mi = add $mi, -1
//   InstrE # InstrE may clobber $mi, as long as it is restored before the brnz
//   brnz $mi, %bb.2
//   InstrF
//   br %bb.3 # may be elided
//
// Note that this deletes both pseudos from the header and transformed both in
// the body. This means that it can be applied to reliably lower the pseudos,
// even when the basic blocks have become separated and each is lowered
// individually.
// This also applies to the loop guard pseudo, which is simply lowered to brz.

// The next most commonly applicable transform uses brnzdec. Unfortunately this
// requires a sub 1 in the header to provide the right trip count, so requires
// both blocks to be available without an intermediate block inserted inbetween.
// Loop guard converted to brz, similar to above.
// bb.1.for.body.preheader:
//   successors: %bb.2
//   InstrA
//   $mi = add $mi, -1
//   InstrB
//   CLOOP_BEGIN_TERMINATOR $mi, m
//   InstrC
//   br %bb.2 # may be elided
//
// bb.2.for.body:
// ; predecessors: %bb.1, %bb.2
//   successors: %bb.2, %bb.3
//   liveins: $mi, others
//   InstrD
//   InstrE
//   brnzdec $mi, %bb.2
//   InstrF # requires none of InstrF to clobber $mi
//   br %bb.3 # may be elided

// The simple rpt lowering is only valid if the maximum trip count < 4095
// This is indicated by metadata m == tripCountOKForRpt. There are also various
// constraints on the instructions in the InstrX sequences, e.g. InstrC must be
// empty at present. Some contraints may be relaxed with further testing.
//
// If the loop guard pseudo is safe to remove - loop guard branches to loop exit
// and InstrA, InstrB, InstrH dont modify any of the live registers in loop
// exit, as well as dont have side effects - then the loop pseudo is removed.
//
// bb.0.entry:
//   successors: %bb.1
//   InstrG
//   brz $mi, %bb.X
//   InstrH
//   br %bb.1 # may be elided
//
// bb.1.for.body.preheader:
//   successors: %bb.2
//   InstrA
//   InstrB
//   br %bb.2 # may be elided
//
// bb.2.for.body:
// ; predecessors: %bb.1, %bb.2
//   successors: %bb.2, %bb.3
//   liveins: $mi, others
//   rpt $mi, size_field
//   InstrD
//   InstrE
//   # end of rpt body
//   InstrF
//   br %bb.3 # may be elided

// Loop Guard Removal
// Lets assume we had the following code
// {
//   int sum = 42;
//
//   if (N == 0)
//       return 10;
//
//   for (int i=0; i<N; ++i)
//       arr[i] += something
//
//   return sum;
// }
//
// One way of expressing this in assembly, assuming a pass takes advantage of
// the loop guard:
//
// Entry:
// $m0 = 10;
// CLOOP_GUARD_BRANCH $m5, LoopExit
// $m0 = 42                           # $m0 is modified
// RPT
// { ...
// }
//
// LoopExit:                          # $m0 is live
// RTN
//
// In this case there is an instruction between CLOOP_GUARD_BRANCH and RPT
// (formerly CLOOP_BEGIN_TERMINATOR). This would not have been a problem, had it
// not mmodified $m0, which is live just after the loop. Hence
// CLOOP_GUARD_BRANCH cannot be safely removed as this could change the
// behaviour of the program. The same would apply had this been an instruction
// with a side effect such as a call or store.

// Software Pipelining
// Some exotic basic block orders/structures may occur when a loop is software
// pipelined by the MachinePipeliner pass.
// Originally a loop body basic block would be preceeded by a preheader basic
// block where the body has CLOOP_END_* instructions and the preheader has
// CLOOP_BEGIN_* instructions.
// To illustrate:
//
// Preheader -> loop body -> exit
//              ^        |
//              |        |
//               --------
//
// Now, in addition to the orignal loop basic blocks structure, the loop body
// may be split up in multiple basic blocks. Particularly, the loop body basic
// block may now be converted into 1 or more prologs basic blocks, 1 loop kernel
// basic block, and 1 or more epilog basic blocks. Within these additional
// blocks the amount and type of CLOOP_* instructions may differ.
// Prologs may have CLOOP_END_VALUE instructions which are transformed into a
// subtraction of 1.
// Kernels should be equivalent to the (previous) loop body in terms of
// CLOOP_END_* instructions.
// Epilogs should not have any of the CLOOP_* pseudo instructions.
// Additionally, the previous preheader may now not be a preheader llvm defines
// a preheader.
// To illustrate:
//
// "Preheader" -> Prolog -> Kernel -> Epilog -> exit
//            |         |  ^      |  ^         ^
//            |         |  |      |  |         |
//            |         |   -----    |         |
//            |          ------------          |
//             --------------------------------
//
// The "Preheader" and Kernel pair will be treated similar to the preheader and
// loop body before (to determine rpt/brnzdec/brnz).

namespace {
bool eliminatePseudos(MachineBasicBlock *BB, const TargetInstrInfo &TII) {
  DebugLoc dl;
  if (!BB)
    return false;

  // The fallback is to remove nodes from the header and
  // replace those in the footer with a subtract and a brnz
  bool changed = false;
  for (auto BBI = BB->instr_begin(), E = BB->instr_end(); BBI != E;) {
    unsigned opc = BBI->getOpcode();
    switch (opc) {
    default: {
      ++BBI;
      break;
    }
    case Colossus::CLOOP_BEGIN_VALUE: {
      assert(BBI->getOperand(0).getReg() == BBI->getOperand(1).getReg());
      BBI = BB->erase(BBI);
      changed = true;
      break;
    }
    case Colossus::CLOOP_BEGIN_TERMINATOR: {
      BBI = BB->erase(BBI);
      changed = true;
      break;
    }
    case Colossus::CLOOP_END_VALUE: {
      unsigned r = BBI->getOperand(0).getReg();
      assert(r == BBI->getOperand(1).getReg());

      // This add could sometimes be eliminated by modifying existing
      // instructions, e.g. if the def is an add +1
      BuildMI(*BB, BBI, dl, TII.get(Colossus::ADD_SI), r)
          .addReg(r)
          .addImm(-1)
          .addImm(0 /* coissue */);
      BBI = BB->erase(BBI);
      changed = true;
      break;
    }
    case Colossus::CLOOP_END_BRANCH: {
      BuildMI(*BB, BBI, dl, TII.get(Colossus::BRNZ))
          .add(BBI->getOperand(0))
          .add(BBI->getOperand(1))
          .addImm(0 /* coissue */);
      BBI = BB->erase(BBI);
      changed = true;
      break;
    }
    case Colossus::CLOOP_GUARD_BRANCH: {
      BuildMI(*BB, BBI, dl, TII.get(Colossus::BRZ))
          .add(BBI->getOperand(0))
          .add(BBI->getOperand(1))
          .addImm(0 /* coissue */);
      BBI = BB->erase(BBI);
      changed = true;
      break;
    }
  }
  }
  return changed;
}

/// Lower CLOOP_GUARD_BRANCH into a fallback brz instruction.
bool eliminateLoopGuardPseudo(SmallVectorImpl<MachineInstr *> &loopGuards,
                              const TargetInstrInfo &TII) {
  bool changed = false;
  for (auto loopGuard : loopGuards) {
    if (eliminatePseudos(loopGuard->getParent(), TII))
      changed = true;
  }
  return changed;
}

MachineBasicBlock::instr_iterator
findBySearchingFromTerminator(MachineBasicBlock *BB, unsigned opcode) {
  MachineBasicBlock::instr_iterator fail = BB->instr_end();
  auto TI = BB->getFirstInstrTerminator();
  if (TI == fail) {
    return fail;
  }

  for (;; --TI) {
    if (TI->getOpcode() == opcode) {
      return TI;
    }
    if (TI == BB->instr_begin()) {
      return fail;
    }
  }
}

bool containsPseudos(MachineBasicBlock *BB, std::vector<unsigned> Pseudos,
                     bool ContainsAll = true) {
  if (!BB || Pseudos.empty())
    return false;

  enum PseudoType {
    BEGIN_VAL = 0x1,
    BEGIN_TERM = 0x2,
    END_VAL = 0x4,
    END_BR = 0x8,
    GUARD_BR = 0x16
  };

  auto MappedPseudo = [](unsigned opcode) -> unsigned {
    switch (opcode) {
    default:
      return 0;
    case Colossus::CLOOP_BEGIN_VALUE:
      return PseudoType::BEGIN_VAL;
    case Colossus::CLOOP_BEGIN_TERMINATOR:
      return PseudoType::BEGIN_TERM;
    case Colossus::CLOOP_END_VALUE:
      return PseudoType::END_VAL;
    case Colossus::CLOOP_END_BRANCH:
      return PseudoType::END_BR;
    case Colossus::CLOOP_GUARD_BRANCH:
      return PseudoType::GUARD_BR;
    }
  };

  unsigned AllPseudosInBB = 0;
  for (auto &I : *BB) {
    unsigned MP = MappedPseudo(I.getOpcode());
    if (AllPseudosInBB & MP)
      return false;
    AllPseudosInBB |= MP;
  }

  unsigned AllPseudosInArg = 0;
  for (auto &I : Pseudos) {
    unsigned MP = MappedPseudo(I);
    if (AllPseudosInArg & MP)
      return false;
    AllPseudosInArg |= MP;
  }

  AllPseudosInBB &= AllPseudosInArg;

  if (ContainsAll)
    return AllPseudosInBB == AllPseudosInArg;
  else
    return !!(AllPseudosInBB);
}

void findLoopGuardPseudos(MachineBasicBlock *header,
                          SmallVectorImpl<MachineInstr *> &loopGuards) {
  if (!header)
    return;

  // Search header's predecessors BB for loop guard pseudo.
  for (auto BBI = header->pred_begin(), BBE = header->pred_end(); BBI != BBE;
       ++BBI) {
    MachineBasicBlock *PredBB = *BBI;
    MachineBasicBlock::instr_iterator Inst;
    if ((Inst = findBySearchingFromTerminator(
             PredBB, Colossus::CLOOP_GUARD_BRANCH)) != PredBB->instr_end()) {
      loopGuards.push_back(&*Inst);
    }
  }
}

bool isSafeToRemoveLoopGuard(MachineBasicBlock *header, MachineBasicBlock *body,
                             MachineInstr *loopGuard) {

  MachineBasicBlock *loopGuardDest = loopGuard->getOperand(1).getMBB();

  auto succI = body->succ_begin();
  MachineBasicBlock *loopBodyDest = *succI != body ? *succI : (++succI, *succI);
  if ((body->succ_size() != 2) || (loopBodyDest != loopGuardDest)) {
    LLVM_DEBUG(dbgs() << "Cannot remove loop guard as it does not branch to "
                         "exit block\n");
    return false;
  }

  assert(header->succ_size() == 1 && "Header has multiple successors");

  // Look at the live registers in loopGuardDest, and see if any of them were
  // modified in the header (instructions from just after loop guard to start of
  // rpt loop). Also ensure that these instructions do not have side effects.

  auto instrSafeToRun = [&](MachineBasicBlock::instr_iterator &BBI) {
    // These checks are the same ones from MachineInstr::isSafeToMove,
    // except that we do not need to check for whether its an invariant load
    // as any store will immediately return false.
    // debug instr, positions, atomic loads and phis are not checked.
    if (BBI->mayStore() || BBI->isCall() || BBI->isTerminator() ||
        BBI->mayRaiseFPException() || BBI->hasUnmodeledSideEffects()) {
      LLVM_DEBUG(dbgs() << "Cannot remove loop guard due to side effects\n");
      return false;
    }

    for (MachineBasicBlock::livein_iterator liveinI =
             loopGuardDest->livein_begin();
         liveinI != loopGuardDest->livein_end(); ++liveinI) {

      MachineBasicBlock::RegisterMaskPair liveReg = *liveinI;
      if (BBI->modifiesRegister(liveReg.PhysReg)) {
        LLVM_DEBUG(
            dbgs() << "Cannot remove loop guard due to modified register\n");
        return false;
      }
    }

    return true;
  };

  // Check instr from the one after CLOOP_GUARD_PSEUDO to the end of its BB.
  for (auto BBI = ++loopGuard->getIterator(),
            E = loopGuard->getParent()->instr_end();
       BBI != E; ++BBI) {
    if (!instrSafeToRun(BBI)) {
      return false;
    }
  }

  // Check all instr in loop header.
  for (auto BBI = header->instr_begin(), E = header->instr_end(); BBI != E;
       ++BBI) {
    if (!instrSafeToRun(BBI)) {
      return false;
    }
  }

  return true;
}

Error bodyInstrsCanLowerToRpt(MachineBasicBlock *body) {
  Colossus::CoissueUtil util;
  for (auto &i : body->instrs()) {
    if (i.isMetaInstruction())
      continue;

    unsigned opc = i.getOpcode();

    if (opc == Colossus::CLOOP_BEGIN_VALUE ||
        opc == Colossus::CLOOP_BEGIN_TERMINATOR) {
      // Can't contain a nested cloop
      return createStringError(std::errc::operation_not_permitted,
                               "has nested counted loop");
    }

    if (opc == Colossus::CLOOP_END_VALUE) {
      // end_value is expected
      continue;
    }

    if (opc == Colossus::CLOOP_END_BRANCH) {
      // Reached the end of the rpt body without problems
      break;
    }

    std::string InstStr;
    raw_string_ostream InstStrStream(InstStr);
    i.print(InstStrStream, /*IsStandalone=*/true, /*SkipOpers=*/false,
            /*SkipDebugLoc=*/false, /*AddNewLine=*/false);
    (void)InstStrStream.str();

    // Shouldn't be any bundles at this stage. Rejecting any here
    // means the rpt lowering code can assume there are none.
    if (i.isBundled()) {
      return createStringError(std::errc::operation_not_permitted,
                               ("has a bundle:\n" + InstStr).c_str());
    }

    if (util.isControl(&i) || util.isSystem(&i)) {
      return createStringError(
          std::errc::operation_not_permitted,
          ("has a control or system instruction:\n" + InstStr).c_str());
    }

    if (!util.canCoissue(&i)) {
      return createStringError(
          std::errc::operation_not_permitted,
          ("has an instruction that cannot be coissued:\n" + InstStr).c_str());
    }
  }
  return Error::success();
}

// Calculate metrics for RPT lowering, or an empty `Optional` if lowering is
// not possible.
//
struct RptMetrics {
  uint64_t bundleCount;
  uint64_t nopCount;
};

Expected<RptMetrics> getMetricsForRpt(MachineBasicBlock *header,
                                      MachineBasicBlock *body) {

  if (!Colossus::CountedLoop::EnableRpt) {
    return createStringError(std::errc::operation_not_permitted,
                             "rpt not enabled");
  }

  auto headerBeginValue =
      findBySearchingFromTerminator(header, Colossus::CLOOP_BEGIN_VALUE);
  auto headerBeginTerminator = header->getFirstInstrTerminator();
  auto bodyEndValue =
      findBySearchingFromTerminator(body, Colossus::CLOOP_END_VALUE);
  auto bodyEndBranch = body->getFirstInstrTerminator();

  // If the metadata is inconsistent, give up on rpt
  auto metadata = headerBeginValue->getOperand(2).getImm();
  if ((headerBeginTerminator->getOperand(1).getImm() != metadata) ||
      (bodyEndValue->getOperand(2).getImm() != metadata) ||
      (bodyEndBranch->getOperand(2).getImm() != metadata)) {
    return createStringError(std::errc::operation_not_permitted,
                             "inconsistant cloop metadata");
  }

  using CLMetadata = Colossus::CountedLoop::metadata;
  if (metadata != static_cast<int64_t>(CLMetadata::tripCountOKForRpt)) {
    return createStringError(std::errc::operation_not_permitted,
                             "trip count not suitable");
  }

  // Check the loop body is simple enough for rpt
  auto bodyTerminator = bodyEndBranch;
  if (bodyTerminator->getOperand(1).getMBB() != body) {
    return createStringError(std::errc::operation_not_permitted,
                             "loop latch do not branch to loop body");
  }
  ++bodyTerminator;
  if (bodyTerminator != body->instr_end() &&
      bodyTerminator->getOpcode() != Colossus::BR) {
    return createStringError(std::errc::operation_not_permitted,
                             "loop latch do not use BR");
  }

  // A BR after the begin_terminator can be ignored when lowering
  // Phi elimination copies after the terminator currently block rpt
  auto headerTerminator = std::next(headerBeginTerminator);
  if (headerTerminator != header->instr_end() &&
      headerTerminator->getOpcode() != Colossus::BR) {
    return createStringError(std::errc::operation_not_permitted,
                             "unexpected instruction after header terminator");
  }

  if (Error RptLoweringErr = bodyInstrsCanLowerToRpt(body)) {
    return std::move(RptLoweringErr);
  }

  // Estimate the number of (f)nops that would result from putting every
  // instruction between `body->begin_instrs()` and `CLOOP_END_BRANCH` into a
  // bundle.
  auto util = Colossus::CoissueUtil();
  auto metrics = RptMetrics();

  auto bodyBegin = body->instr_begin();
  while (bodyBegin != bodyEndBranch) {
    if (bodyBegin->isMetaInstruction() ||
        bodyBegin->getOpcode() == Colossus::CLOOP_END_VALUE) {
      ++bodyBegin;
      continue;
    }
    assert(!bodyBegin->isBundled());
    assert(util.canCoissue(&*bodyBegin));
    auto maybeBodyNext = util.queryNextInstrToBundle(bodyBegin, bodyEndBranch);
    if (maybeBodyNext) {
      bodyBegin = *maybeBodyNext;
    } else {
      // Can't bundle with next instruction. Requires (f)nop to bundle.
      ++metrics.nopCount;
    }
    ++metrics.bundleCount;
    ++bodyBegin;
  }

  if (metrics.bundleCount == 0 || metrics.bundleCount > 256) {
    return createStringError(std::errc::operation_not_permitted,
                             "unsuitable number of instructions in loop");
  }

  // 8 byte alignment of the first bundle is handled by the assembler
  return metrics;
}

/// Remove an instruction without replacement.
void removeAnyInstancesOfOpcode(MachineBasicBlock *BB, unsigned opcode) {
  for (auto BBI = BB->instr_begin(), E = BB->instr_end(); BBI != E;) {
    unsigned opc = BBI->getOpcode();
    if (opc == opcode) {
      BBI = BB->erase(BBI);
    } else {
      ++BBI;
    }
  }
}

unsigned
bundleEverythingInRange(MachineBasicBlock *body,
                        MachineBasicBlock::instr_iterator BBI,
                        MachineBasicBlock::instr_iterator end) {
  assert(BBI != end);
  Colossus::CoissueUtil util;
  MachineFunction::iterator MFI(body);
  unsigned numberBundles = 0;

  while (BBI != end) {
    if (BBI->isMetaInstruction()) {
      ++BBI;
      continue;
    }

    assert(!BBI->isBundled());
    assert(util.canCoissue(&*BBI));
    if (util.canBundleWithNextInstr(MFI, BBI)) {
      BBI = util.bundleWithNextInstr(MFI, BBI);
    } else {
      BBI = util.bundleWithNop(MFI, BBI);
    }
    numberBundles++;
  }

  return numberBundles;
}

// Build a rpt instruction that takes an immediate as op0.
// If op0 is a register, but we can work out the immediate value
// of that register, and it is unused by anything else, fold it.
bool makeRptWithImm(MachineBasicBlock *header, MachineBasicBlock *body,
                    const TargetInstrInfo &TII, DebugLoc &dl,
                    MachineBasicBlock::instr_iterator &rptPseudo,
                    unsigned numberBundles) {

  assert(rptPseudo->getOpcode() == Colossus::CLOOP_BEGIN_TERMINATOR);
  MachineFunction &mf = *header->getParent();
  auto &CST = static_cast<const ColossusSubtarget &>(mf.getSubtarget());
  auto ImmRptInst = ColossusRPT_ZI(CST);

  // Obtain the SETZI machine instruction that is used as part of the rpt
  // if it is a valid candidate for folding, otherwise return nullptr
  auto GetRegImm = [&]() -> llvm::MachineInstr * {
    if (!rptPseudo->getOperand(0).isReg()) {
      return nullptr;
    }

    auto rptImmReg = rptPseudo->getOperand(0).getReg();
    auto SETZIInstr = std::find_if(
        header->instr_begin(), header->instr_end(), [&rptImmReg](auto &instr) {
          return instr.getOpcode() == Colossus::SETZI &&
                 instr.getOperand(0).isReg() &&
                 instr.getOperand(0).getReg() == rptImmReg;
        });

    if (SETZIInstr == header->instr_end())
      return nullptr;

    // Search all of the basic blocks in the function to ensure it has no
    // additional uses, and is therefore a candidate for folding into the rpt
    auto ImmediateHasOtherUses = [&]() {
      auto const bb_end = mf.end();
      for (auto bb = mf.begin(); bb != bb_end; ++bb) {
        for (auto &instr : bb->instrs()) {
          static auto const IgnoreVRegDefs = MachineInstr::IgnoreVRegDefs;
          if (!instr.isIdenticalTo(*SETZIInstr, IgnoreVRegDefs)) {
            for (const auto &op : instr.uses()) {
              if (op.isReg() && op.getReg() == rptImmReg &&
                  instr.getOpcode() != Colossus::CLOOP_END_BRANCH &&
                  instr.getOpcode() != Colossus::CLOOP_BEGIN_TERMINATOR) {
                return true;
              }
            }
          }
        }
      }
      return false;
    };

    bool HasOtherUses = ImmediateHasOtherUses();
    return HasOtherUses ? nullptr : &(*SETZIInstr);
  };

  auto SETZIInstr = GetRegImm();

  if (!SETZIInstr)
    return false;

  int64_t tripCount = SETZIInstr->getOperand(1).getImm();

  // For all architectures the maximum width of the immediate encoded in op0
  // is zimm12. When the known immediate is larger than this, we must fallback
  // to using a register (See T62636)
  unsigned const Op0Width = 0xfffu;

  if (tripCount > Op0Width)
    return false;

  BuildMI(*body, rptPseudo, dl, TII.get(ImmRptInst))
      .addImm(tripCount)
      .addImm(numberBundles - 1)
      .addImm(0 /*coissue*/);

  SETZIInstr->eraseFromParent();

  return true;
}

void lowerToSimpleRpt(MachineBasicBlock *header, MachineBasicBlock *body,
                      SmallVectorImpl<MachineInstr *> &loopGuards,
                      const TargetInstrInfo &TII) {
  DebugLoc dl;
  assert(!bool(getMetricsForRpt(header, body).takeError()));

  // Remove the value placeholders as they aren't used by rpt
  removeAnyInstancesOfOpcode(header, Colossus::CLOOP_BEGIN_VALUE);
  removeAnyInstancesOfOpcode(body, Colossus::CLOOP_END_VALUE);

  // Move the cloop begin pseudo to the start of the body bb
  {
    auto headerBeginTerminator = header->getFirstInstrTerminator();
    auto rptReg = headerBeginTerminator->getOperand(0);
    auto rptMeta = headerBeginTerminator->getOperand(1);
    BuildMI(*body, body->instr_begin(), dl,
            TII.get(Colossus::CLOOP_BEGIN_TERMINATOR))
        .add(rptReg)
        .add(rptMeta);
    headerBeginTerminator = header->erase(headerBeginTerminator);
  }

  // Lower the instructions between begin_terminator/end_branch to a rpt block
  {
    MachineFunction &mf = *header->getParent();
    static_cast<void>(mf);
    MachineBasicBlock::instr_iterator BBI = body->instr_begin();
    assert(BBI->getOpcode() == Colossus::CLOOP_BEGIN_TERMINATOR);
    BBI++;

    auto bodyEndBranch = body->getFirstInstrTerminator();
    assert(bodyEndBranch->getOpcode() == Colossus::CLOOP_END_BRANCH);
    unsigned numberBundles = bundleEverythingInRange(body, BBI, bodyEndBranch);
    assert(numberBundles > 0u && numberBundles <= 256u);

    // Replace the cloop_begin_terminator with a rpt instruction
    auto rptPseudo = body->instr_begin();
    assert(rptPseudo->getOpcode() == Colossus::CLOOP_BEGIN_TERMINATOR);
    if (!makeRptWithImm(header, body, TII, dl, rptPseudo, numberBundles)) {
      BuildMI(*body, rptPseudo, dl,
              TII.get(ColossusRPT(mf.getSubtarget<ColossusSubtarget>())))
          .add(rptPseudo->getOperand(0))
          .addImm(numberBundles - 1)
          .addImm(0 /*coissue*/);
    }

    body->erase(rptPseudo);
    MachineFunction::iterator MFI(body);
    Colossus::CoissueUtil util;
    util.bundleWithNop(MFI, body->instr_begin());

    // Erase the cloop_end_branch
    body->erase(bodyEndBranch);
  }

  // Remove cloop_guard_branch
  for (auto loopGuard : loopGuards) {
    if (isSafeToRemoveLoopGuard(header, body, loopGuard)) {
      LLVM_DEBUG(dbgs() << "Removing loop guard pseudo\n");

      MachineBasicBlock *loopGuardDest = loopGuard->getOperand(1).getMBB();
      loopGuard->getParent()->removeSuccessor(loopGuardDest, true);

      // Remove CLOOP_GUARD_BRANCH without replacement.
      removeAnyInstancesOfOpcode(loopGuard->getParent(),
                                 Colossus::CLOOP_GUARD_BRANCH);
    } else {
      // Lower CLOOP_GUARD_BRANCH to brz as fallback
      eliminatePseudos(loopGuard->getParent(), TII);
    }
  }

  // Fix up pred/succ block information
  assert(body->isPredecessor(body));
  assert(body->isSuccessor(body));
  body->removeSuccessor(body, true);
}

Error canLowerToBrnzdec(MachineBasicBlock *header, MachineBasicBlock *body) {
  // Assumes that header contains begin pseudos that
  // arrange for the correct register to be live on entry
  if (!Colossus::CountedLoop::EnableBrnzdec) {
    return createStringError(std::errc::operation_not_permitted,
                             "brnzdec not enabled");
  }

  auto bodyEndBranch = body->getFirstInstrTerminator();
  assert(bodyEndBranch->getOpcode() == Colossus::CLOOP_END_BRANCH);
  const unsigned reg = bodyEndBranch->getOperand(0).getReg();

  // Instructions inserted between CLOOP_END_VALUE and CLOOP_END_BRANCH
  // prevents the use of brnzdec if they use the brnzdec register because they
  // assume decrement has happened but not the branch. That assumption is
  // invalid once brnzdec is inserted in place of CLOOP_END_BRANCH. Such
  // instructions can be inserted by phi elimination for instance.

  auto MI = bodyEndBranch;
  for (--MI; MI->getOpcode() != Colossus::CLOOP_END_VALUE; --MI) {
    for (auto &MO : MI->operands()) {
      if (MO.isReg() && MO.getReg() == reg) {
        std::string OrStr;
        raw_string_ostream OrStrStream(OrStr);
        MI->print(OrStrStream, /*IsStandalone=*/true, /*SkipOpers=*/false,
                  /*SkipDebugLoc=*/false, /*AddNewLine=*/false);
        return createStringError(
            std::errc::operation_not_permitted,
            ("brnzdec register referred to between decrement and branch by\n" +
             OrStrStream.str())
                .c_str());
      }
    }
    assert(MI != body->instr_begin() && "loop does not have CLOOP_END_VALUE");
  }

  assert(MI->getOperand(0).getReg() == reg);
  return Error::success();
}

void lowerToBrnzdec(MachineBasicBlock *header, MachineBasicBlock *body,
                    const TargetInstrInfo &TII) {
  DebugLoc dl;
  assert(!bool(canLowerToBrnzdec(header, body)));

  auto headerBeginValue =
      findBySearchingFromTerminator(header, Colossus::CLOOP_BEGIN_VALUE);
  auto headerBeginTerminator = header->getFirstInstrTerminator();
  auto bodyEndValue =
      findBySearchingFromTerminator(body, Colossus::CLOOP_END_VALUE);
  auto bodyEndBranch = body->getFirstInstrTerminator();

  Register reg = headerBeginValue->getOperand(0).getReg();
  MachineInstr *InstrBeforeCLoopBegin = headerBeginValue->getPrevNode();

  // Check for instruction preceding CLOOP_BEGIN_VALUE that modifies the
  // induction counter and fold the decrement into it.
  auto foldDecrementIntoInstr = [&]() {
    if (headerBeginValue == header->begin())
      return false;

    if (InstrBeforeCLoopBegin->getNumOperands() < 1u ||
        !(InstrBeforeCLoopBegin->getOperand(0).isReg() &&
          InstrBeforeCLoopBegin->getOperand(0).getReg() == reg))
      return false;

    unsigned opcode = InstrBeforeCLoopBegin->getOpcode();

    if (opcode == Colossus::SETZI) {
      auto val = InstrBeforeCLoopBegin->getOperand(1).getImm();
      assert(val != 0);
      BuildMI(*header, headerBeginValue, dl, TII.get(opcode), reg)
          .addImm(val - 1)
          .addImm(0 /*coissue*/);
      InstrBeforeCLoopBegin->eraseFromParent();
      return true;
    }

    if (opcode != Colossus::ADD_SI && opcode != Colossus::ADD_ZI)
      return false;

    if (!(InstrBeforeCLoopBegin->getOperand(1).isReg() &&
          InstrBeforeCLoopBegin->getOperand(1).getReg() == reg))
      return false;

    if (!InstrBeforeCLoopBegin->getOperand(2).isImm())
      return false;

    int64_t val = InstrBeforeCLoopBegin->getOperand(2).getImm();
    assert(val != 0);
    if (val != 1)
      BuildMI(*header, headerBeginValue, dl, TII.get(opcode), reg)
          .add(InstrBeforeCLoopBegin->getOperand(1))
          .addImm(val - 1)
          .addImm(0 /*coissue*/);

    InstrBeforeCLoopBegin->eraseFromParent();
    return true;
  };

  // Prefer folding the decrement into existing instructions.
  if (!foldDecrementIntoInstr())
      BuildMI(*header, headerBeginValue, dl, TII.get(Colossus::ADD_SI), reg)
          .add(headerBeginValue->getOperand(1))
          .addImm(-1)
          .addImm(0 /*coissue*/);

  headerBeginValue->eraseFromParent();
  headerBeginTerminator->eraseFromParent();
  bodyEndValue->eraseFromParent();

  BuildMI(*body, bodyEndBranch, dl, TII.get(Colossus::BRNZDEC),
          bodyEndBranch->getOperand(0).getReg())
      .add(bodyEndBranch->getOperand(0))
      .add(bodyEndBranch->getOperand(1))
      .addImm(0 /*coissue*/);
  bodyEndBranch->removeFromParent();
}

// Walks up the MDT to find the matching CLOOP_BEGIN_VALUE machineinstr (and its
// MBB).
MachineBasicBlock *findMatchingEndVal(MachineInstr *BeginTerm,
                                      const MachineDominatorTree *MDT) {
  assert(BeginTerm &&
         BeginTerm->getOpcode() == Colossus::CLOOP_BEGIN_TERMINATOR &&
         "Arg can only be a cloop begin terminator");
  assert(MDT && "MachineDominatorTree must be populated");

  MachineDomTreeNode *BeginValDN = MDT->getNode(BeginTerm->getParent());
  for (; BeginValDN; BeginValDN = BeginValDN->getIDom()) {
    if (!containsPseudos(BeginValDN->getBlock(), {Colossus::CLOOP_BEGIN_VALUE}))
      continue;
    auto BeginValI = findBySearchingFromTerminator(BeginValDN->getBlock(),
                                                   Colossus::CLOOP_BEGIN_VALUE);
    // Confirm the def register in begin_val is the same as the use register of
    // begin_term.
    if (BeginValI->getOperand(0).getReg() ==
        BeginTerm->getOperand(0).getReg()) {
      return BeginValDN->getBlock();
    }
  }
  return nullptr;
}
} // namespace

// Clean up all prologs that occur between the Preheader and EndValueBB.
bool ColossusCountedLoopMIR::cleanPrologs(MachineBasicBlock *Preheader,
                                          MachineBasicBlock *EndValueBB) {
  // If Preheader dominates EndValueBB, we should find Preheader on the path
  // from EndValueBB to entry.
  if (!MDT->properlyDominates(Preheader, EndValueBB))
    return false;
  bool changed = false;
  // Walk all the immediate dominators between EndValueBB and Preheader
  // (exclusive).
  MachineDomTreeNode *prolog = MDT->getNode(EndValueBB)->getIDom();
  while (prolog != MDT->getRootNode() && prolog->getBlock() != Preheader) {
    changed |= eliminatePseudos(prolog->getBlock(), *TII);
    prolog = prolog->getIDom();
  }
  return changed;
}

// Gather the "original" preheaders which may differ from the current preheaders
// depending on software pipelining. Note that this runs recursively through all
// loops much like traverseLoop (even if by processing the outer loops prior to
// the inner loops unlike traverseLoop).
void ColossusCountedLoopMIR::gatherPreheaders(
    MachineLoop &L, MachineBasicBlock *ParentPreheader) {
  MachineBasicBlock *Preheader = L.getLoopPreheader();
  if (!containsPseudos(Preheader, {Colossus::CLOOP_BEGIN_TERMINATOR})) {
    Preheader = nullptr;
    if (L.getLoopPredecessor()) {
      MachineDomTreeNode *DomTreePreheader =
          MDT->getNode(L.getLoopPredecessor());
      while (DomTreePreheader &&
             DomTreePreheader->getBlock() != ParentPreheader &&
             !containsPseudos(DomTreePreheader->getBlock(),
                              {Colossus::CLOOP_BEGIN_TERMINATOR})) {
        DomTreePreheader = DomTreePreheader->getIDom();
      }
      Preheader =
          DomTreePreheader && DomTreePreheader->getBlock() != ParentPreheader
              ? DomTreePreheader->getBlock()
              : nullptr;
    }
  }

  if (Preheader)
    PreheaderMap.insert(std::make_pair(&L, Preheader));

  // Take care of the inner loops after the current loop has found its
  // preheader.
  for (auto &InnerLoop : L)
    gatherPreheaders(*InnerLoop, Preheader ? Preheader : MDT->getRoot());
}

// Retrieve the gathered original preheaders using the current loop as key for
// the map populated by gatherPreheaders.
MachineBasicBlock *ColossusCountedLoopMIR::getPreheader(MachineLoop &L,
                                                        bool &isPipelined) {
  MachineBasicBlock *preheader = L.getLoopPreheader();
  if (!containsPseudos(preheader, {Colossus::CLOOP_BEGIN_TERMINATOR}))
    isPipelined = true;

  if (PreheaderMap.find(&L) == PreheaderMap.end())
    return nullptr;

  return PreheaderMap.find(&L)->second;
}

bool ColossusCountedLoopMIR::traverseLoop(MachineLoop &L) {
  bool changed = false;
  bool isPipelined = false;

  // Innermost loop first.
  for (auto &InnerLoop : L)
    changed |= traverseLoop(*InnerLoop);

  LLVM_DEBUG(dbgs() << "Traversing loop: "; L.dump(););

  // Critical edge splitting can result in cloned instructions. In that case
  // there may be multiple backedges (i.e. loop latch basic blocks) with the
  // Colossus pseudos.
  MachineBasicBlock *EndBranchBB = nullptr;
  SmallVector<MachineBasicBlock *> Latches;
  L.getLoopLatches(Latches);
  unsigned numFoundBranchPseudos = 0;
  for (MachineBasicBlock *MBB : Latches) {
    if (containsPseudos(MBB, {Colossus::CLOOP_END_BRANCH})) {
      EndBranchBB = MBB;
      numFoundBranchPseudos++;
    }
  }

  // If there's no preheader present, there's a good possibility the loop is
  // software pipelined. We will have to manually find the MBB preceeding the
  // {prolog*,kernel,epilog} pipeline MBBs (even if it is technically not a
  // preheader in strict terms).
  MachineBasicBlock *Preheader = getPreheader(L, isPipelined);
  SmallVector<MachineInstr *, 4> loopGuards;
  findLoopGuardPseudos(Preheader, loopGuards);

  // If there are more CLOOP_END_BRANCH instructions found within the same
  // loop, bail out.
  if (numFoundBranchPseudos > 1) {
    // Bail out.
    changed |= eliminateLoopGuardPseudo(loopGuards, *TII);
    for (MachineBasicBlock *MBB : Latches) {
      changed |= eliminatePseudos(MBB, *TII);
    }
    changed |= eliminatePseudos(Preheader, *TII);
    return changed;
  }

  // Some pass(es) may cause the branch to exist in the header. If that's the
  // case, bail out.
  if (!EndBranchBB) {
    EndBranchBB = L.getHeader();
    if (!containsPseudos(EndBranchBB, {Colossus::CLOOP_END_VALUE,
                                       Colossus::CLOOP_END_BRANCH})) {
      changed |= eliminateLoopGuardPseudo(loopGuards, *TII);
      changed |= eliminatePseudos(Preheader, *TII);
      changed |= eliminatePseudos(EndBranchBB, *TII);
      return changed;
    }
  }

  // If preheader doesn't exists, bail out.
  if (!Preheader) {
    changed |= eliminateLoopGuardPseudo(loopGuards, *TII);
    changed |= eliminatePseudos(EndBranchBB, *TII);
    return changed;
  }

  auto bodyEndValue =
      findBySearchingFromTerminator(EndBranchBB, Colossus::CLOOP_END_VALUE);

  if (!containsPseudos(Preheader, {Colossus::CLOOP_BEGIN_TERMINATOR,
                                   Colossus::CLOOP_BEGIN_VALUE}) ||
      Preheader->getFirstInstrTerminator() == Preheader->instr_end()) {
    // Some pass(es) may have split BEGIN_VALUE and BEGIN_TERMINATOR so find the
    // associated BEGIN_VALUE if we know BEGIN_TERMINATOR in Preheader and
    // delete the BEGIN_VALUE.
    auto BeginTerm = findBySearchingFromTerminator(
        Preheader, Colossus::CLOOP_BEGIN_TERMINATOR);
    if (BeginTerm != Preheader->instr_end())
      changed |= eliminatePseudos(findMatchingEndVal(&*BeginTerm, MDT), *TII);
    changed |= eliminateLoopGuardPseudo(loopGuards, *TII);
    changed |= eliminatePseudos(Preheader, *TII);
    changed |= eliminatePseudos(EndBranchBB, *TII);
    return changed;
  }

  assert(MDT->dominates(Preheader, EndBranchBB) &&
         "Preheader should dominate all parts of the loop.");

  auto headerBeginValue =
      findBySearchingFromTerminator(Preheader, Colossus::CLOOP_BEGIN_VALUE);
  if (headerBeginValue == Preheader->instr_end() ||
      bodyEndValue == EndBranchBB->instr_end()) {
    report_fatal_error("Malformed MIR. Missing pseudo for counted loop");
  }

  auto cloopValueRegistersMatch = [](MachineBasicBlock::instr_iterator i) {
    assert(i->getOpcode() == Colossus::CLOOP_BEGIN_VALUE ||
           i->getOpcode() == Colossus::CLOOP_END_VALUE);
    return i->getOperand(0).getReg() == i->getOperand(1).getReg();
  };

  if (!cloopValueRegistersMatch(headerBeginValue) ||
      !cloopValueRegistersMatch(bodyEndValue)) {
    report_fatal_error("Malformed MIR. Cloop value registers must match");
  }

  LLVM_DEBUG(dbgs() << "Analysing counted loop with body "
                    << EndBranchBB->getName() << "\n";);
  if (auto metrics = getMetricsForRpt(Preheader, EndBranchBB)) {
    auto &nopCount = metrics->nopCount;
    auto &bundleCount = metrics->bundleCount;

    auto printMetrics = [&]() {
      LLVM_DEBUG(dbgs() << "  nopCount = " << nopCount << "\n"
                        << "  bundleCount = " << bundleCount << "\n"
                        << "  maximumNops = " << MaxNopCount << "\n"
                        << "  nopThreshold = " << NopThreshold << "\n";);
    };

    if (nopCount <= MaxNopCount || nopCount <= (bundleCount * NopThreshold)) {
      lowerToSimpleRpt(Preheader, EndBranchBB, loopGuards, *TII);
      if (isPipelined) {
        cleanPrologs(Preheader, EndBranchBB);
      }
      LLVM_DEBUG(dbgs() << "Lowered to RPT:\n"; printMetrics(););
      LLVM_DEBUG(dbgs() << "New loop body:\n"; EndBranchBB->dump();
                 dbgs() << "\n";);
      return true;
    }
    LLVM_DEBUG(dbgs() << "Did not lower to RPT:\n"; printMetrics(););
    (void)printMetrics;
  } else {
    Error RptLoweringError = metrics.takeError();
    LLVM_DEBUG(dbgs() << "Cannot use rpt: " << RptLoweringError << "\n";);
    consumeError(std::move(RptLoweringError));
  }

  // TODO: Maybe we can remove the guard for brnzdec case if we know the trip
  // count.
  changed |= eliminateLoopGuardPseudo(loopGuards, *TII);

  if (Error BrnzdecLoweringError = canLowerToBrnzdec(Preheader, EndBranchBB)) {
    LLVM_DEBUG(dbgs() << "Cannot use brnzdec: " << BrnzdecLoweringError
                      << "\n";);
    consumeError(std::move(BrnzdecLoweringError));
  } else {
    lowerToBrnzdec(Preheader, EndBranchBB, *TII);
    if (isPipelined)
      cleanPrologs(Preheader, EndBranchBB);
    LLVM_DEBUG(dbgs() << "Lowered to brnzdec. New loop body:\n";
               EndBranchBB->dump(); dbgs() << "\n";);
    return true;
  }

  LLVM_DEBUG(dbgs() << "Eliminating counted loop pseudos\n";);
  changed |= eliminatePseudos(EndBranchBB, *TII);
  changed |= eliminatePseudos(Preheader, *TII);
  if (L.getLoopPredecessor())
    changed |= eliminatePseudos(L.getLoopPredecessor(), *TII);
  LLVM_DEBUG(dbgs() << "Cleaned up loop body:\n"; EndBranchBB->dump();
             dbgs() << "\n";);

  return changed;
}

bool ColossusCountedLoopMIR::runOnMachineFunction(MachineFunction &mf) {
  auto &ST = mf.getSubtarget<ColossusSubtarget>();
  TII = ST.getInstrInfo();

  if (!Colossus::CountedLoop::EnableMIR)
    return false;

  LLVM_DEBUG(dbgs() << "Colossus counted loop mir on function " << mf.getName()
                    << "\n";);

  bool changed = false;
  PreheaderMap.clear();
  MDT = &getAnalysis<MachineDominatorTree>();
  MLI = &getAnalysis<MachineLoopInfo>();

  // Cache the "original" preheaders if found.
  for (auto &L : *MLI)
    gatherPreheaders(*L, nullptr);

  for (auto &L : *MLI)
    changed |= traverseLoop(*L);

  return changed;
}
