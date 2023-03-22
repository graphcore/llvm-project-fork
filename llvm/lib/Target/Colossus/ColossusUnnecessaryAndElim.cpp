//===-- ColossusUnnecessaryAndElim.cpp - Remove unnecessary 'and' insts ---===//
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
// This pass removes unnecessary 'and' instructions in BBs based on
// zero extended loads. Most are combined during target independent phases
// of the compiler. However, few remain after RA which this pass will
// eliminate if possible.
//
// Example:
//
// strcmp:
// 	    ldz8 $m2, $m0, $m15, 0     # <-- loads zero extended i8 value in $m2
// 	    brz $m2, .LBB0_4
// 	    add $m0, $m0, 1
// .LBB0_2:
// 	    ldz8 $m3, $m1, $m15, 0
// 	    and $m4, $m2, 255          # <-- unnecessarily mask $m2
// 	    cmpne $m3, $m4, $m3
// 	    brnz $m3, .LBB0_5
// 	    ldz8step $m2, $m15, $m0+=, 1
// 	    add $m1, $m1, 1
// 	    brnz $m2, .LBB0_2
// .LBB0_4:
// 	    mov	$m2, $m15
// .LBB0_5:
// 	    and $m0, $m2, 255          # <-- unnecessarily mask $m2
// 	    ldz8 $m1, $m1, $m15, 0
// 	    sub $m0, $m0, $m1
// 	    br $m10
//
//===----------------------------------------------------------------------===//

#include "Colossus.h"
#include "llvm/ADT/MapVector.h"
#include "llvm/ADT/SmallPtrSet.h"
#include "llvm/ADT/Statistic.h"
#include "llvm/ADT/UniqueVector.h"
#include "llvm/CodeGen/MachineBasicBlock.h"
#include "llvm/CodeGen/MachineDominators.h"
#include "llvm/CodeGen/MachineFunction.h"
#include "llvm/CodeGen/MachineFunctionPass.h"
#include "llvm/CodeGen/MachineRegisterInfo.h"
#include "llvm/InitializePasses.h"
#include "llvm/Support/Debug.h"
#include <type_traits>

using namespace llvm;

#define DEBUG_TYPE "colossus-and-elim"

STATISTIC(NumAndsRemoved, "Number of and instructions removed.");

// Test whether MachineOperand MO is a mask value for one of the Colossus
// supported loads < 32-bits.
static bool isLoadImmMask(const MachineOperand &MO) {
  return MO.isImm() && (MO.getImm() == 0xff || MO.getImm() == 0xffff);
}

// Verify MachineInstr to be a 16-bit load so the resulting value can be
// interpretted as a ZExt value.
static bool is16bitZExtInstr(const Register &AndReg, const MachineInstr *MI) {
  switch (MI->getOpcode()) {
  default:
    return false;
  case Colossus::LDZ16:
  case Colossus::LDZ16_ZI:
    return true;
  case Colossus::LDZ16STEP:
  case Colossus::LDZ16STEP_SI: {
    // Strided loads have multiple register defs, hence this requires some
    // additional checking to ensure the correct def is the register used by
    // the `And` instruction.
    return MI->getOperand(1).getReg() == AndReg;
  }
  case TargetOpcode::COPY: {
    const MachineOperand &MO = MI->getOperand(1);
    return MO.isReg() && MO.getReg() == Colossus::MZERO;
  }
  }
}

// Verify MachineInstr to be a 8-bit load so the resulting value can be
// interpretted as a ZExt value.
static bool is8bitZExtInstr(const Register &AndReg, const MachineInstr *MI) {
  switch (MI->getOpcode()) {
  default:
    return false;
  case Colossus::LDZ8:
  case Colossus::LDZ8_ZI:
    return true;
  case Colossus::LDZ8STEP:
  case Colossus::LDZ8STEP_SI: {
    return MI->getOperand(1).getReg() == AndReg;
  }
  case TargetOpcode::COPY: {
    const MachineOperand &MO = MI->getOperand(1);
    return MO.isReg() && MO.getReg() == Colossus::MZERO;
  }
  }
}

namespace {
// Each vector index denotes a MachineInstr's operand info of the same
// place. For example:
//              $m0 = AND_ZI $m1, 255, 0
//               ^            ^    ^   ^
//              [0]          [1]  [2] [3]
//
// Each vector idx associated with an operand contains the collection of
// MachineInstr pointers that are either the uses or defs of said operand.
using OpAccesses = std::vector<SmallVector<MachineInstr *, 4>>;

// First OpAccesses is for defs, second one is for uses.
using MIUseDefs = MapVector<MachineInstr *, std::pair<OpAccesses, OpAccesses>>;

using MIOpAccesses = std::pair<MachineInstr *, OpAccesses>;

// Queue-like structure that prevents, by default, elements from being inserted
// twice, even at disjoint time. Used to traverse all MBBs only once, even if a
// MBB was already added and removed from the queue.
template <typename ElemTy, typename InfoTy> class RemembranceQueue {
  using StorageTy = std::pair<ElemTy, InfoTy>;
  static_assert(std::is_pointer<ElemTy>::value,
                "Element type must be a raw pointer.");

private:
  std::vector<StorageTy> Elems;
  SmallPtrSet<ElemTy, 16> Ptrs;

public:
  void try_push_back(ElemTy value, InfoTy info, bool remember = true) {
    if (Ptrs.count(value) == 0) {
      Elems.emplace_back(value, info);
      if (remember)
        Ptrs.insert(value);
    }
  }

  StorageTy retrieve_first() {
    StorageTy firstElement = std::move(Elems.front());
    Elems.erase(Elems.begin());
    return firstElement;
  }

  bool empty() { return Elems.empty(); }
};

class ColossusUnnecessaryAndElim : public MachineFunctionPass {
private:
  MachineDominatorTree *MDT;
  const TargetRegisterInfo *TRI;
  void scanAndInstrs(MachineFunction &MF,
                     SmallVectorImpl<MachineInstr *> &Ands);
  MIUseDefs CollectUseDefInfo(const SmallVectorImpl<MachineInstr *> &Ands);
  void FindValidTransformations(const MIUseDefs &MIInfo,
                                SmallVectorImpl<MIOpAccesses> &ValidAnds);
  bool RemoveAnds(const SmallVectorImpl<MIOpAccesses> &ValidAnds);
  bool isValid(MachineInstr *AndInstr, OpAccesses &Uses, OpAccesses &Defs);

public:
  static char ID;
  ColossusUnnecessaryAndElim() : MachineFunctionPass(ID) {
    initializeColossusUnnecessaryAndElimPass(*PassRegistry::getPassRegistry());
  }

  bool runOnMachineFunction(MachineFunction &MF) override;
  MachineFunctionProperties getRequiredProperties() const override {
    return MachineFunctionProperties().set(
        MachineFunctionProperties::Property::NoVRegs);
  }

  void getAnalysisUsage(AnalysisUsage &AU) const override {
    AU.addRequired<MachineDominatorTree>();
    MachineFunctionPass::getAnalysisUsage(AU);
  }

  StringRef getPassName() const override {
    return "Colossus Unnecessary And Instruction Elimination";
  }
};

char ColossusUnnecessaryAndElim::ID = 0;

static SmallVector<MachineInstr *, 4> DefsOf(const TargetRegisterInfo *TRI,
                                             MachineInstr *MI,
                                             const MachineOperand &MOP) {
  SmallVector<MachineInstr *, 4> OperandDefs;
  if (MOP.isReg()) {
    RemembranceQueue<MachineBasicBlock *, MachineBasicBlock::reverse_iterator>
        BFSQueue;
    BFSQueue.try_push_back(MI->getParent(), ++MI->getReverseIterator(),
                           /*remember=*/false);

    while (!BFSQueue.empty()) {
      auto QueueElem = BFSQueue.retrieve_first();
      MachineBasicBlock *CurMBB = QueueElem.first;
      auto It = QueueElem.second;
      auto end = CurMBB->rend();

      auto MII = std::find_if(It, end, [&](const auto &MI) -> bool {
        return MI.modifiesRegister(MOP.getReg(), TRI);
      });

      if (MII != end) {
        OperandDefs.push_back(&(*MII));
      } else {
        for (MachineBasicBlock *MBB : CurMBB->predecessors())
          BFSQueue.try_push_back(MBB, MBB->rbegin());
      }
    }
  }
  return OperandDefs;
}

// Find nearest defs for every operand in MI.
static OpAccesses DefsOf(const TargetRegisterInfo *TRI, MachineInstr *MI) {
  assert(MI->getNumExplicitDefs() == 1 &&
         "Only supports MachineInstrs that explicitly define 1 def register");

  OpAccesses Defs;
  for (unsigned OpNum = 0; OpNum < MI->getNumOperands(); ++OpNum) {
    SmallVector<MachineInstr *, 4> OperandDefs =
        DefsOf(TRI, MI, MI->getOperand(OpNum));
    Defs.push_back(OperandDefs);
  }
  return Defs;
}

// Find uses for every operand in MI until the register is killed.
static OpAccesses UsesOf(MachineInstr *MI) {
  assert(MI->getNumExplicitDefs() == 1 &&
         "Only supports MachineInstrs that explicitly define 1 def register");

  OpAccesses Uses;
  for (unsigned OpNum = 0; OpNum < MI->getNumOperands(); ++OpNum) {
    SmallVector<MachineInstr *, 4> OperandUses;
    const auto &MOP = MI->getOperand(OpNum);
    if (MOP.isReg()) {
      RemembranceQueue<MachineBasicBlock *, MachineBasicBlock::iterator>
          BFSQueue;
      BFSQueue.try_push_back(MI->getParent(), ++MI->getIterator(),
                             /*remember=*/false);

      while (!BFSQueue.empty()) {
        auto QueueElem = BFSQueue.retrieve_first();
        MachineBasicBlock *CurMBB = QueueElem.first;
        auto It = QueueElem.second;
        auto end = CurMBB->end();

        for (; It != end; ++It) {
          if (It->readsRegister(MOP.getReg())) {
            OperandUses.push_back(&(*It));
            if (It->killsRegister(MOP.getReg()))
              break;
          }
        }

        if (It == end) {
          for (MachineBasicBlock *MBB : CurMBB->successors())
            BFSQueue.try_push_back(MBB, MBB->begin());
        }
      }
    }
    Uses.push_back(std::move(OperandUses));
  }
  return Uses;
}

// Collect the use/defs of AND_ZI instructions' operands later used to
// validate whether the transformation can be done.
MIUseDefs ColossusUnnecessaryAndElim::CollectUseDefInfo(
    const SmallVectorImpl<MachineInstr *> &Ands) {
  MIUseDefs MIs;
  for (auto *MI : Ands) {
    OpAccesses RegDefs = DefsOf(TRI, MI);
    OpAccesses RegUses = UsesOf(MI);
    auto RegPair = std::make_pair(RegDefs, RegUses);
    MIs.insert(std::make_pair(MI, RegPair));
  }
  return MIs;
}

// Populate ValidAnds with the AND_ZI instruction capable of doing the
// transformation.
void ColossusUnnecessaryAndElim::FindValidTransformations(
    const MIUseDefs &MIInfo, SmallVectorImpl<MIOpAccesses> &ValidAnds) {

  for (auto It = MIInfo.begin(); It != MIInfo.end(); ++It) {
    MachineInstr *And = It->first;
    std::pair<OpAccesses, OpAccesses> DefUse = It->second;
    OpAccesses Defs = DefUse.first;
    OpAccesses Uses = DefUse.second;
    const MachineOperand &LHS = And->getOperand(1);
    const MachineOperand &RHS = And->getOperand(2);
    const Register &LHSReg = LHS.getReg();

    // Verify that all `And` instruction's parent instructions allow the `And`
    // to be removed.
    auto ParentInstrsMatches = [&]() -> bool {
      if (Defs[1].empty())
        return false;

      for (auto *API : Defs[1]) {
        if ((RHS.getImm() != 0xffff || !is16bitZExtInstr(LHSReg, API)) &&
            (RHS.getImm() != 0xff || !is8bitZExtInstr(LHSReg, API))) {
          return false;
        }
      }
      return true;
    };

    // Test whether AND_ZI's expression tree matches an expresson tree that
    // allows the removal of said AND_ZI.
    // &&
    // Test whether the all users of AND_ZI's operands are valid for removal
    // of said AND_ZI.
    if (ParentInstrsMatches() && isValid(And, Uses, Defs)) {
      ValidAnds.push_back(make_pair(And, Uses));
    } else {
      LLVM_DEBUG(dbgs() << "CUAE: And instruction could not be removed: "
                        << *And);
    }
  }
}

// Validate uses of the operands found in AND_ZI.
bool ColossusUnnecessaryAndElim::isValid(MachineInstr *AndInstr,
                                         OpAccesses &Uses,
                                         OpAccesses &Defs) {

  MachineOperand &DefMOP = AndInstr->getOperand(0);
  MachineOperand &LhsMOP = AndInstr->getOperand(1);

  for (auto *AndDefUse : Uses[0]) {
    SmallVector<MachineInstr *, 4> Redefs = DefsOf(TRI, AndDefUse, LhsMOP);

    // Defs of AND_ZI's lhs register starting from AndDefUse (i.e. Redefs) must
    // contain the same instructions as AND_ZI's lhs register starting from
    // AND_ZI (i.e. Defs[1]). If this is not the case, then changing
    // AndDefUse's use register is not allowed.

    // Uses of AND_ZI's result can only be transformed to use its LHS (source)
    // register if that register is not redefined between AND_ZI and the use.
    // This is detected by looking at whether the definitions of the register
    // before the use are the same of those before the AND_ZI.
    // For example:
    //              1: $m5 = ...
    //              2: ...
    //              3: $m4 = AND_ZI $m5, 255, <bundling flag>
    //              4: ...
    //              5: $m5 = ...
    //              6: ...
    //              7: $m4 used
    //
    // In the example DefsOf(3, $m5) = Defs[1] = {1} while
    // DefsOf(7, $m5) = Redefs = {5}, therefore removing the AND_ZI is not
    // allowed.
    if (Redefs.size() != Defs[1].size())
      return false;
    for (const auto *Redef : Redefs) {
      if (std::find(Defs[1].begin(), Defs[1].end(), Redef) == Defs[1].end())
        return false;
    }

    // Make sure that AND_ZI's def register isn't implicitly used. Implicit
    // uses can't be transformed, hence the AND_ZI can't be removed.
    for (const auto &AndUseMop : AndDefUse->operands()) {
      if (AndUseMop.isReg() && AndUseMop.getReg() == DefMOP.getReg() &&
          AndUseMop.isImplicit())
        return false;
    }
  }

  // Make sure that AND_ZI's lhs register isn't redefined/killed during the
  // lifetime of AND_ZI's def register.
  // For example:
  //              $m4 = AND_ZI $m5, 255, <bundling flag>
  //              ...
  //              $m5 killed
  //              ...
  //              $m4 used
  //
  // In the case of the aforementioned example, $m4 can't be transformed
  // into $m5 since the value in $m5 may not be legal for use after it's
  // killed.
  for (auto *LhsUse : Uses[1]) {
    for (auto *AndUse : Uses[0]) {
      if (MDT->dominates(LhsUse, AndUse)) {
        for (const auto &AndUsemop : LhsUse->operands()) {
          if (AndUsemop.isReg() && AndUsemop.getReg() == LhsMOP.getReg() &&
              AndUsemop.isKill())
            return false;
        }
      }
    }
  }
  return true;
}

// ValidAnds have already been validated, all that's left is to remove all
// AND_ZIs that can be removed.
bool ColossusUnnecessaryAndElim::RemoveAnds(
    const SmallVectorImpl<MIOpAccesses> &ValidAnds) {
  for (auto &It : ValidAnds) {
    MachineInstr *And = It.first;
    const OpAccesses Uses = It.second;
    const MachineOperand &Dest = And->getOperand(0);
    const MachineOperand &LHS = And->getOperand(1);
    const Register &DestReg = Dest.getReg();
    const Register &LHSReg = LHS.getReg();

    for (auto *use : Uses[0]) {
      for (auto &mop : use->uses()) {
        if (mop.isReg() && mop.getReg() == DestReg) {
          LLVM_DEBUG(dbgs() << "CUAE: Replacing " << mop << " in " << *use);
          mop.setReg(LHSReg);
        }
      }
    }
    LLVM_DEBUG(dbgs() << "CUAE: Removing " << *And);
    And->eraseFromParent();
    NumAndsRemoved++;
  }
  return !ValidAnds.empty();
}
} // namespace

INITIALIZE_PASS_BEGIN(ColossusUnnecessaryAndElim, DEBUG_TYPE,
                      "Colossus unnecessary and instruction elimination", false,
                      false)
INITIALIZE_PASS_DEPENDENCY(MachineDominatorTree)
INITIALIZE_PASS_END(ColossusUnnecessaryAndElim, DEBUG_TYPE,
                    "Colossus unnecessary and instruction elimination", false,
                    false)

// Scan machine function for potential unnecessary `AND_ZI` instructions.
void ColossusUnnecessaryAndElim::scanAndInstrs(
    MachineFunction &MF, SmallVectorImpl<MachineInstr *> &Ands) {
  auto MIFilter = [](const MachineInstr &MI) {
    return MI.getOpcode() == Colossus::AND_ZI &&
           isLoadImmMask(MI.getOperand(2));
  };

  for (auto &MBB : MF) {
    for (auto &MI : make_filter_range(MBB, MIFilter)) {
      LLVM_DEBUG(
          dbgs() << "CUAE: Found possibly unnecessary AND_ZI instruction: "
                 << MI);
      Ands.push_back(&MI);
    }
  }
}

bool ColossusUnnecessaryAndElim::runOnMachineFunction(MachineFunction &MF) {
  if (skipFunction(MF.getFunction()))
    return false;

  TRI = MF.getSubtarget().getRegisterInfo();
  MDT = &getAnalysis<MachineDominatorTree>();

  SmallVector<MachineInstr *, 4> Ands;
  SmallVector<MIOpAccesses, 4> ValidAnds;

  scanAndInstrs(MF, Ands);
  MIUseDefs MIInfo = CollectUseDefInfo(Ands);
  FindValidTransformations(MIInfo, ValidAnds);
  return RemoveAnds(ValidAnds);
}

FunctionPass *llvm::createColossusUnnecessaryAndElimPass() {
  return new ColossusUnnecessaryAndElim();
}
