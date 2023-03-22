//===-- ColossusFrameLowering.cpp - Frame info for Colossus Target --------===//
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
// This file contains Colossus frame information that doesn't fit anywhere else
// cleanly.
//
//===----------------------------------------------------------------------===//

#include "ColossusFrameLowering.h"
#include "Colossus.h"
#include "ColossusISelLowering.h"
#include "ColossusInstrInfo.h"
#include "ColossusMachineFunctionInfo.h"
#include "ColossusRegisterInfo.h"
#include "ColossusSubtarget.h"
#include "ColossusTargetInstr.h"
#include "llvm/CodeGen/MachineFrameInfo.h"
#include "llvm/CodeGen/MachineFunction.h"
#include "llvm/CodeGen/MachineInstrBuilder.h"
#include "llvm/CodeGen/MachineModuleInfo.h"
#include "llvm/CodeGen/MachineRegisterInfo.h"
#include "llvm/CodeGen/RegisterScavenging.h"
#include "llvm/CodeGen/TargetLowering.h"
#include "llvm/IR/DataLayout.h"
#include "llvm/IR/Function.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Target/TargetOptions.h"

#include <algorithm>

using namespace llvm;

#define DEBUG_TYPE "colossus-frame-lowering"

// The optimal value for the stack limit symbol is the worker stack size + 1
static cl::opt<std::string> WorkerStackLimitSymbol(
    "colossus-stack-limit",
    cl::desc("Branch to stack-overflow-handler if stack-used >= stack-limit"),
    cl::init(""), cl::Hidden);

// The optimal value for the stack limit symbol is the supervisor stack size + 1
static cl::opt<std::string> SupervisorStackLimitSymbol(
    "colossus-supervisor-stack-limit",
    cl::desc("Branch to stack-overflow-handler if stack-used >= stack-limit"),
    cl::init(""), cl::Hidden);

static cl::opt<std::string>
    StackOverflowHandler("colossus-stack-overflow-handler",
                         cl::desc("Label to branch to on stack overflow"),
                         cl::init("abort"), cl::Hidden);

static cl::opt<int>
    RedZoneSize("colossus-vertex-red-zone-size",
                cl::desc("Number of bytes available above $MWORKER_BASE"),
                cl::init(0), cl::Hidden);

//===----------------------------------------------------------------------===//
// Colossus frame lowering.
//===----------------------------------------------------------------------===//

/// Note that this class is constructed during the construction of
/// ColossusSubtarget so the subtarget cannot be accessed.
ColossusFrameLowering::ColossusFrameLowering(const ColossusSubtarget &CST,
                                             unsigned StackAlignment)
    : TargetFrameLowering(TargetFrameLowering::StackGrowsDown,
                          Align(StackAlignment), 0 /* Local area offset */) {
  // Do nothing
}

static void computeFrameSize(MachineFunction &MF) {
  MachineFrameInfo &MFI = MF.getFrameInfo();
  uint64_t FrameSize = MFI.getStackSize();
  LLVM_DEBUG(dbgs() << "Frame size " << FrameSize << " bytes.\n");
  const TargetFrameLowering *TFL = MF.getSubtarget().getFrameLowering();
  unsigned StackAlign = TFL->getStackAlignment();
  if (StackAlign > 0) {
    FrameSize = alignTo(FrameSize, StackAlign);
  }
  MFI.setStackSize(FrameSize);
  LLVM_DEBUG(dbgs() << "Set frame size to " << FrameSize << " bytes.\n");
}

// If the stack has been realigned, we need BP to retrieve any incoming args
// If there are variable size locals, we need FP to retrieve local slots

bool ColossusFrameLowering::hasFP(const MachineFunction &MF) const {
  if (MF.getTarget().Options.DisableFramePointerElim(MF)) {
    return true;
  }
  const MachineFrameInfo &MFI = MF.getFrameInfo();
  return MFI.isFrameAddressTaken() || MFI.hasVarSizedObjects();
}

static bool isVertexCC(const MachineFunction &MF) {
  return MF.getFunction().getCallingConv() == CallingConv::Colossus_Vertex;
}

bool ColossusFrameLowering::hasBP(const MachineFunction &MF) const {
  // Might be reasonable to return true for DisableFramePointerElim
  if (isVertexCC(MF)) {
    // cc vertex takes no arguments so can never need a base pointer
    return false;
  }

  const TargetRegisterInfo *TRI = MF.getSubtarget().getRegisterInfo();

  // C calling convention function that takes no stack arguments also never
  // needs a base pointer. This optimisation is not yet implemented.
  return TRI->hasStackRealignment(MF);
}

uint16_t ColossusFrameLowering::redZoneSize() const {
  if (RedZoneSize < 0) {
    return 0;
  } else {
    uint64_t res = RedZoneSize;

    // limit to uint16_max
    res = std::min<uint64_t>(res, std::numeric_limits<uint16_t>::max());

    // round down to a multiple of minimum stack alignment
    uint64_t a = 8;
    res = a * (res / a);

    return res;
  }
}

bool ColossusFrameLowering::
hasReservedCallFrame(const MachineFunction &MF) const {
  // Reserve call frame if there are no variable sized objects on the stack.
  return !MF.getFrameInfo().hasVarSizedObjects();
}

/// Scan a MachineFunction MF to find the largest stack slot required for an
/// M-to-A copy. Return the corresponding RegisterClass or nullptr otherwise.
static const TargetRegisterClass *RequiresStackSlot(MachineFunction &MF) {
  const TargetRegisterClass *RC = nullptr;
  const TargetRegisterInfo *RegInfo = MF.getSubtarget().getRegisterInfo();
  for (auto &MBB : MF) {
    for (auto &MI : MBB) {
      // COPY
      if (MI.getOpcode() == Colossus::COPY) {
        unsigned RegDest = MI.getOperand(0).getReg();
        unsigned RegSrc = MI.getOperand(1).getReg();
        // M -> A
        if (Colossus::MRRegClass.contains(RegSrc) &&
            Colossus::ARRegClass.contains(RegDest)) {
          if (!RC ||
              RegInfo->getSpillSize(Colossus::MRRegClass) >
                  RegInfo->getSpillSize(*RC)) {
            RC = &Colossus::MRRegClass;
          }
        }
        // MM -> AA
        if (Colossus::MRPairRegClass.contains(RegSrc) &&
            Colossus::ARPairRegClass.contains(RegDest)) {
          if (!RC ||
              RegInfo->getSpillSize(Colossus::MRPairRegClass) >
                  RegInfo->getSpillSize(*RC)) {
            RC = &Colossus::MRPairRegClass;
          }
        }
      }
    }
  }
  return RC;
}

void ColossusFrameLowering::
processFunctionBeforeFrameFinalized(MachineFunction &MF,
                                    RegScavenger *RS) const {
  ColossusFunctionInfo *CFI = MF.getInfo<ColossusFunctionInfo>();

  LLVM_DEBUG(dbgs() << "Process function before frame layout\n");

  // If the function uses the frame pointer, then allocate space to spill it.
  if (hasFP(MF) && !isVertexCC(MF)) {
    CFI->createFPSpillSlot(MF);
    LLVM_DEBUG(
        dbgs() << "  Spilling FP ("
               << ColossusRegisterInfo::getRegisterName(
                      MF.getSubtarget().getRegisterInfo()->getFrameRegister(MF))
               << ") to frame index " << CFI->getFPSpillSlot() << '\n');
  }

  // If the function uses the base pointer then space used to spill it
  // will be manually allocated from just below the stack pointer.
  // The fixed spill slot mechanism treats negative offsets as requiring
  // a maximum stack alignment of zero causing problems elsewhere.

  // Allocate a stack slot for copying between MRF and ARF if necessary.
  if (const TargetRegisterClass *RC = RequiresStackSlot(MF)) {
    LLVM_DEBUG(dbgs() << "Allocated stack slot for M-to-A move");
    CFI->createScratchSlot(MF, RC);
  }
}
namespace {
unsigned scratchRegister() { return Colossus::M6; }

void buildSubImm(const ColossusInstrInfo *CII, MachineBasicBlock &MBB,
                 MachineBasicBlock::iterator MI, unsigned dst, unsigned src,
                 uint64_t imm) {
  // dst = src - imm
  DebugLoc dl;
  if (isInt<16>(-imm)) {
    BuildMI(MBB, MI, dl, CII->get(Colossus::ADD_SI), dst)
        .addReg(src)
        .addImm(-imm)
        .addImm(0 /* Coissue bit */)
        .setMIFlag(MachineInstr::FrameSetup);

  } else {
    assert(src != scratchRegister());
    assert(isUInt<32>(imm));
    CII->loadConstant32(MBB, MI, scratchRegister(), imm);
    BuildMI(MBB, MI, dl, CII->get(Colossus::SUB), dst)
        .addReg(scratchRegister(), RegState::Kill)
        .addReg(src)
        .addImm(0 /* Coissue bit */)
        .setMIFlag(MachineInstr::FrameSetup);
  }
}

void buildAddImm(const ColossusInstrInfo *CII, MachineBasicBlock &MBB,
                 MachineBasicBlock::iterator MI, unsigned dst, unsigned src,
                 uint64_t imm) {
  // dst = src + imm
  DebugLoc dl;
  if (isUInt<16>(imm)) {
    BuildMI(MBB, MI, dl, CII->get(Colossus::ADD_ZI), dst)
        .addReg(src)
        .addImm(imm)
        .addImm(0 /* Coissue bit */)
        .setMIFlag(MachineInstr::FrameSetup);
  } else {
    assert(src != scratchRegister());
    assert(isUInt<32>(imm));
    CII->loadConstant32(MBB, MI, scratchRegister(), imm);
    BuildMI(MBB, MI, dl, CII->get(Colossus::ADD), dst)
        .addReg(src)
        .addReg(scratchRegister(), RegState::Kill)
        .addImm(0 /* Coissue bit */)
        .setMIFlag(MachineInstr::FrameSetup);
  }
}

void buildAndcImm(const ColossusInstrInfo *CII, MachineBasicBlock &MBB,
                  MachineBasicBlock::iterator MI, unsigned dst, unsigned src,
                  uint64_t imm) {
  // dst = src & ~imm
  DebugLoc dl;
  if (isUInt<12>(imm)) {
    BuildMI(MBB, MI, dl, CII->get(Colossus::ANDC_ZI), dst)
        .addReg(src)
        .addImm(imm)
        .addImm(0 /* Coissue bit */)
        .setMIFlag(MachineInstr::FrameSetup);
  } else {
    assert(src != scratchRegister());
    assert(isUInt<32>(imm));
    CII->loadConstant32(MBB, MI, scratchRegister(), imm);
    BuildMI(MBB, MI, dl, CII->get(Colossus::ANDC), dst)
        .addReg(src)
        .addReg(scratchRegister(), RegState::Kill)
        .addImm(0 /* Coissue bit */)
        .setMIFlag(MachineInstr::FrameSetup);
  }
}

void buildCopyReg(const ColossusInstrInfo *CII, MachineBasicBlock &MBB,
                  MachineBasicBlock::iterator MI, unsigned dst, unsigned src) {
  DebugLoc dl;
  BuildMI(MBB, MI, dl, CII->get(TargetOpcode::COPY), dst).addReg(src);
}

bool shouldEmitStackOverflowCheck(uint64_t FrameSize,
                                  const ColossusSubtarget &CST) {
  if (FrameSize == 0)
    return false;

  // Mixed mode requires both stack limit symbols to be defined.
  if (CST.isBothMode())
    return !WorkerStackLimitSymbol.empty() &&
           !SupervisorStackLimitSymbol.empty();

  // Otherwise, we require either the worker or supervisor symbol depending on
  // the function mode.
  const auto &SelectedStackLimitSymbol =
      CST.isWorkerMode() ? WorkerStackLimitSymbol : SupervisorStackLimitSymbol;
  return !SelectedStackLimitSymbol.empty();
}

/// Builds a CFI machine instruction from the CFI instruction \p CFIInst.
void buildCFI(MachineBasicBlock &MBB, MachineBasicBlock::iterator MBBI,
              const DebugLoc &DL, const MCCFIInstruction &CFIInstr) {
  MachineFunction &MF = *MBB.getParent();
  const TargetInstrInfo &TII = *MF.getSubtarget().getInstrInfo();
  const unsigned CFIIndex = MF.addFrameInst(CFIInstr);
  BuildMI(MBB, MBBI, DL, TII.get(TargetOpcode::CFI_INSTRUCTION))
      .addCFIIndex(CFIIndex);
}

} // namespace

void ColossusFrameLowering::emitPrologue(MachineFunction &MF,
                                         MachineBasicBlock &MBB) const {
  const MachineFrameInfo &MFI = MF.getFrameInfo();
  const TargetInstrInfo &TII = *MF.getSubtarget().getInstrInfo();
  auto &CST = static_cast<const ColossusSubtarget &>(MF.getSubtarget());
  auto &CRI = *static_cast<const ColossusRegisterInfo *>(
      CST.getRegisterInfo());
  auto CII = static_cast<const ColossusInstrInfo *>(&TII);
  const ColossusFunctionInfo &CFI = *MF.getInfo<ColossusFunctionInfo>();
  MachineBasicBlock::iterator MI = MBB.begin();

  // Debug location must be unknown since the first debug location is used
  // to determine the end of the prologue.
  DebugLoc dl;

  LLVM_DEBUG(dbgs() << "Emit prologue\n");
  // Compute the stack size, to determine if we need a prologue at all.
  computeFrameSize(MF);
  const uint64_t FrameSize = MFI.getStackSize();
  assert(FrameSize % getStackAlignment() == 0);
  if (!isUInt<32>(FrameSize)) {
    report_fatal_error("Frame size > UINT32_MAX unsupported");
  }

  bool WithStackCheck = shouldEmitStackOverflowCheck(FrameSize, CST);
  const bool overAlign = MFI.getMaxAlign() > getStackAlign();
  const uint64_t alignOverhead =
      overAlign ? (MFI.getMaxAlign().value() - 1) : 0;

  const bool NeedsDwarfCFI = !isVertexCC(MF) && MF.needsFrameMoves();

  auto decrementSP = [&](MachineBasicBlock &TargetMBB,
                         MachineBasicBlock::iterator MBBI, unsigned initialSP,
                         uint64_t by) {
    assert(by > 0);
    LLVM_DEBUG(dbgs() << "Emit prologue decrement SP by " << by << "\n");
    buildSubImm(CII, TargetMBB, MBBI, Colossus::SP, initialSP, by);
  };

  // BP offset from the incoming SP.
  int BPOffset = 0;
  auto spillAndSetupBP = [&](MachineBasicBlock &TargetMBB,
                             MachineBasicBlock::iterator MBBI,
                             ColossusSubtarget const &CST) {
    assert(hasBP(MF));
    assert(!isVertexCC(MF));
    LLVM_DEBUG(dbgs() << "Emit prologue spill BP \n");
    unsigned BP = Colossus::BP;
    assert(BP == CRI.getBaseRegister(MF));

    // Base pointer is spilled at stack pointer - 8.
    // Incoming stack pointer is saved in base pointer.
    // Stack pointer is left eight bytes down.
    // The stack pointer decrement could be combined with that for the
    // frame setup. This implementation is preferred for simplicity.

    // st32 takes an unsigned immediate
    buildSubImm(CII, TargetMBB, MBBI, Colossus::SP, Colossus::SP, 8u);

    // Spill at $sp - 8
    BuildMI(TargetMBB, MBBI, dl, TII.get(ColossusST32_ZI(CST)))
        .addReg(BP, RegState::Kill)
        .addReg(Colossus::SP)
        .addReg(Colossus::MZERO)
        .addImm(0)
        .addImm(0 /* Coissue bit */)
        .setMIFlag(MachineInstr::FrameSetup);

    // Then write the SP (as it was on entry) to BP
    buildAddImm(CII, TargetMBB, MBBI, Colossus::BP, Colossus::SP, 8u);

    TargetMBB.addLiveIn(BP);

    BPOffset = -8;
  };

  auto alignSP = [&](MachineBasicBlock &TargetMBB,
                     MachineBasicBlock::iterator MBBI, unsigned initialSP) {
    assert(getStackAlignment() == 8);
    assert(overAlign);
    // About to clobber SP, will need a way to retrieve it unless in cc vertex
    assert(hasBP(MF) || isVertexCC(MF));
    unsigned MaxAlign = MFI.getMaxAlign().value() - 1;
    LLVM_DEBUG(dbgs() << "Dynamic frame realignment to " << MaxAlign << "\n");
    buildAndcImm(CII, TargetMBB, MBBI, Colossus::SP, initialSP, MaxAlign);
  };

  // FP offset from the incoming SP.
  int FPOffset = 0;
  auto spillFP = [&](MachineBasicBlock &TargetMBB,
                     MachineBasicBlock::iterator MBBI,
                     ColossusSubtarget const &CST) {
    assert(hasFP(MF));
    assert(!isVertexCC(MF));
    LLVM_DEBUG(dbgs() << "Emit prologue spill FP \n");
    assert(CFI.hasFPSpillSlot() && "No FP spill slot allocated");
    unsigned FP = CRI.getFrameRegister(MF);
    int FPSpillSlot = CFI.getFPSpillSlot();
    FPOffset = MFI.getObjectOffset(FPSpillSlot);
    const int ScaledOffset = (FrameSize + FPOffset) / 4;
    if ((ScaledOffset < 0) || !isUInt<12>(ScaledOffset)) {
      report_fatal_error("FP spill out of range for store");
    }
    BuildMI(TargetMBB, MBBI, dl, TII.get(ColossusST32_ZI(CST)))
        .addReg(FP, RegState::Kill)
        .addReg(Colossus::SP) // Store from SP as FP is not set up yet
        .addReg(Colossus::MZERO)
        .addImm(ScaledOffset)
        .addImm(0 /* Coissue bit */)
        .addMemOperand(CII->getFrameIndexMMO(TargetMBB, FPSpillSlot,
                                             MachineMemOperand::MOStore))
        .setMIFlag(MachineInstr::FrameSetup);
    TargetMBB.addLiveIn(FP);
  };

  // Emits a branch instruction that will jump to a stack-overflow handler
  // if the stack usage test result (passed in register `DestReg`) is zero.
  auto emitStackOverflowCheckBranch = [&](MachineBasicBlock &TargetMBB,
                                          MachineBasicBlock::iterator MBBI,
                                          unsigned DestReg) {
    assert(WithStackCheck);

    // if !ok, branch to overflow handler
    BuildMI(TargetMBB, MBBI, dl, TII.get(Colossus::BRZ), DestReg)
        .addExternalSymbol(StackOverflowHandler.c_str())
        .addImm(0 /* Coissue bit */)
        .setMIFlag(MachineInstr::FrameSetup);
  };
  
  auto emitStackUsageTest = [&](MachineBasicBlock &TargetMBB,
                                MachineBasicBlock::iterator MBBI,
                                unsigned DestReg, bool IsWorkerMode) {
    assert(WithStackCheck);

    const auto &Symbol = IsWorkerMode ? WorkerStackLimitSymbol
                                      : SupervisorStackLimitSymbol;
    // Checking for stack usage <= (worker or supervisor) stack size
    // where `Symbol` is expected to contain 1 + (worker or supervisor)
    // stack size in order to allow ok = stack usage < `Symbol`.
    BuildMI(TargetMBB, MBBI, dl, TII.get(Colossus::CMPULT_ZI), DestReg)
        .addReg(DestReg, RegState::Kill)
        .addExternalSymbol(Symbol.c_str())
        .addImm(0 /* Coissue bit */)
        .setMIFlag(MachineInstr::FrameSetup);
  };

  // Emits code to test if there is a stack-overflow by checking if the current
  // stack usage (passed in register `DestReg`) is above the limit, which is
  // defined as a symbol selected based on the compilation mode (worker or
  // supervisor). The test result is set on `DestReg`.
  auto emitStackUsage = [&](MachineBasicBlock &TargetMBB,
                            MachineBasicBlock::iterator MBBI,
                            unsigned DestReg, bool IsWorkerMode) {
    assert(WithStackCheck);

    unsigned Base;
    if (IsWorkerMode) {
      Base = Colossus::MWORKER_BASE;
    } else {
      // Load supervisor base address into the scratch register.
      BuildMI(TargetMBB, MBBI, dl, TII.get(Colossus::SETZI), DestReg)
          .addExternalSymbol("__supervisor_base")
          .addImm(0 /* Coissue bit */)
          .setMIFlag(MachineInstr::FrameSetup);
      Base = DestReg;
    }
    // stack usage = base (worker or supervisor) - sp
    BuildMI(TargetMBB, MBBI, dl, TII.get(Colossus::SUB), DestReg)
        // Arguments to sub instruction are swapped relative to reading order
        .addReg(Colossus::SP)
        .addReg(Base)
        .addImm(0 /* Coissue bit */)
        .setMIFlag(MachineInstr::FrameSetup);

    // Increment stack usage by the worst case bytes used to realign.
    if (overAlign) {
      uint64_t MaxAlign = alignOverhead + 8; // Take the BP spill into account
      if (!isUInt<16>(MaxAlign)) {
        report_fatal_error("Stack overflow check unimplemented for alignment "
                            "adjustment > 64k");
      }
      BuildMI(TargetMBB, MBBI, dl, TII.get(Colossus::ADD_ZI), DestReg)
          .addReg(DestReg, RegState::Kill)
          .addImm(MaxAlign)
          .addImm(0 /* Coissue bit */)
          .setMIFlag(MachineInstr::FrameSetup);
    }

    emitStackUsageTest(TargetMBB, MBBI, DestReg, IsWorkerMode);
  };

  auto emitStackOverflowCheck = [&]() {
    assert(WithStackCheck);

    bool stackPointerAlreadyDecremented = false;

    const unsigned s = scratchRegister();

    // sp = sp - frame_size
    if (!isInt<16>(-FrameSize)) {
      report_fatal_error(
          "Stack overflow check unimplemented for FrameSize > 32k");
    }
    decrementSP(MBB, MI, Colossus::SP, FrameSize);
    stackPointerAlreadyDecremented = true;

    MachineBasicBlock *ContinueMBB = &MBB;
    MachineBasicBlock::iterator ContinueMBBI = MI;
    // In mixed mode we split the function BB in order to emit both worker and
    // supervisor stack-overflow check code. We assume we are in worker mode if
    // $MWORKER_BASE is set (has non-zero address value), otherwise we assume
    // supervisor mode as reading from this register always returns 0 while in
    // supervisor.
    //
    // MBB:
    //   [allocation]
    //   if $MWORKER_BASE != 0 goto WorkerMBB
    //   [fall-through]
    // SupervisorMBB:
    //   $m6 = supervisor_base
    //   $m6 = $m6 - $SP
    //  *[align $m6]
    //   $m6 = $m6 < supervisor_size
    //   goto ContinueMBB
    // WorkerMBB:
    //   $m6 = worker_base
    //   $m6 = $MWORKER_BASE - $SP
    //  *[align $m6]
    //   $m6 = $m6 < worker_size
    //   [fall-through]
    // ContinueMBB:
    //   if !$m6 goto stackoverflow
    //   [rest of function code]
    //   [epilogue code]
    if (CST.isBothMode()) {
      const BasicBlock *BB = MBB.getBasicBlock();

      MachineBasicBlock *WorkerMBB = MF.CreateMachineBasicBlock(BB);
      MachineBasicBlock *SupervisorMBB = MF.CreateMachineBasicBlock(BB);
      ContinueMBB = MF.CreateMachineBasicBlock(BB);

      MachineFunction::iterator Where = std::next(MBB.getIterator());
      MF.insert(Where, SupervisorMBB);
      MF.insert(Where, WorkerMBB);
      MF.insert(Where, ContinueMBB);

      // if $MWORKER_BASE != 0 goto WorkerMBB
      BuildMI(MBB, MI, dl, TII.get(Colossus::BRNZ))
          .addReg(Colossus::MWORKER_BASE)
          .addMBB(WorkerMBB)
          .addImm(0 /* Coissue bit */)
          .setMIFlag(MachineInstr::FrameSetup);
      
      ContinueMBB->splice(ContinueMBB->begin(), &MBB, MI, MBB.end());
      ContinueMBB->transferSuccessorsAndUpdatePHIs(&MBB);

      // SupervisorMBB:
      //   ...
      emitStackUsage(*SupervisorMBB, SupervisorMBB->end(), s,
                     /*IsWorkerMode=*/false);
      BuildMI(*SupervisorMBB, SupervisorMBB->end(), dl, TII.get(Colossus::BR))
          .addMBB(ContinueMBB)
          .addImm(0 /* Coissue bit */)
          .setMIFlag(MachineInstr::FrameSetup);

      // WorkerMBB:
      //   ...
      emitStackUsage(*WorkerMBB, WorkerMBB->end(), s, /*IsWorkerMode=*/true);

      // Add control flow edges. Make sure the new MBB successors are only added
      // after transferring previous ones from the original MBB to ContinueMBB.
      WorkerMBB->addSuccessor(ContinueMBB);
      SupervisorMBB->addSuccessor(ContinueMBB);
      MBB.addSuccessor(WorkerMBB);
      MBB.addSuccessor(SupervisorMBB);

      ContinueMBBI = ContinueMBB->getFirstNonPHI();
    } else {
      emitStackUsage(*ContinueMBB, ContinueMBBI, s, CST.isWorkerMode());
    }

    emitStackOverflowCheckBranch(*ContinueMBB, ContinueMBBI, s);

    // The common case is no base pointer and no frame pointer
    // When this is true, the previous stack pointer decrement is
    // sufficient. Otherwise, restore the sp to before the overflow check
    if (hasBP(MF) || hasFP(MF)) {
      // sp = sp + sz
      buildAddImm(CII, *ContinueMBB, ContinueMBBI, Colossus::SP, Colossus::SP,
                  FrameSize);
      stackPointerAlreadyDecremented = false;
    }

    LLVM_DEBUG(dbgs() << "After emitting stack overflow check:\n"; MF.dump());

    return std::make_tuple(stackPointerAlreadyDecremented, ContinueMBB,
                           ContinueMBBI);
  };

  MachineBasicBlock *CFIMBB = &MBB;
  MachineBasicBlock::iterator CFIMI = MI;
  if (isVertexCC(MF)) {
    assert(!hasBP(MF)); // Takes no arguments, needs no base pointer

    // In the vertex CC, there are (usually) some number of bytes available
    // above $MWORKER_BASE. This means that vertex functions that use little
    // stack space can use $MWORKER_BASE as the frame pointer and can elide
    // the initial decrement, while also keeping $sp available for other uses
    // A minimum size for this space may be specified in the ABI, but until then
    // it is available as a command line argument with a conservative default.

    //    [] <- out of bounds
    //    [] |
    //    [] |
    //    [] |
    //    [] | red zone bytes
    //    [] |
    //    [] | <- $fp if frame size < red zone size
    //    [] |
    //    [] | <- $MWORKER_BASE (== $fp if frame size == red zone size)
    //    []
    //    []
    //    []   <- $fp if frame size > red zone size
    //    []
    if (WithStackCheck) {
      if ((FrameSize + alignOverhead) > redZoneSize()) {
      // Then we might overflow. Insert check against available stack.
        uint64_t excess = FrameSize + alignOverhead - redZoneSize();
        if (!isUInt<32>(excess)) {
          report_fatal_error("Stack size exceeds address space");
        }

        const unsigned s = scratchRegister();
        CII->loadConstant32(MBB, MI, s, excess);
        assert(CST.isWorkerMode() && "colossus_vertex is for worker mode");
        emitStackUsageTest(MBB, MI, s, /*IsWorkerMode=*/true);
        emitStackOverflowCheckBranch(MBB, MI, s);
      }
    }

    // Use MWORKER_BASE as the stack pointer until it needs to be
    // mutated or passed to a C calling convention function as Colossus::SP.
    unsigned effectiveSP = Colossus::MWORKER_BASE;

    // Allocate frame, using SP as the frame pointer and using the red zone

    if (FrameSize > redZoneSize()) {
      // fp is below wb
      uint64_t reducedFrameSize = FrameSize - redZoneSize();
      assert(reducedFrameSize % getStackAlignment() == 0 || overAlign);
      decrementSP(MBB, MI, Colossus::MWORKER_BASE, reducedFrameSize);
      effectiveSP = Colossus::SP;
    }

    if (FrameSize < redZoneSize()) {
      assert(isUInt<16>(redZoneSize()));
      uint16_t baseOffset = static_cast<uint16_t>(redZoneSize() - FrameSize);

      // fp is above wb
      // The minimum non-zero stack that can be allocated by a worker is 8 bytes
      // If more than 8 bytes of the red zone is provided to a worker context which
      // only allocates eight bytes, the worker stack overflow check subtraction will
      // itself overflow and spuriously claim to have run out of stack.
      // This is not necessary if there are no calls, but in that situation it is
      // better to use the entire red zone for the vertex frame.
      baseOffset = std::min<uint16_t>(baseOffset, 8);

      BuildMI(MBB, MI, dl, TII.get(Colossus::ADD_ZI), Colossus::SP)
            .addReg(Colossus::MWORKER_BASE)
            .addImm(baseOffset)
            .addImm(0 /* Coissue bit */)
            .setMIFlag(MachineInstr::FrameSetup);
      effectiveSP = Colossus::SP;
    }

    // Adjust downward to provide required alignment
    if (overAlign) {
      alignSP(MBB, MI, effectiveSP);
      effectiveSP = Colossus::SP;
    }

    // Calls expect a stack pointer
    // getFrameRegister currently returns FP or SP to access slots. This will be
    // improved to use $MWORKER_BASE directly in a subsequent patch.
    const bool requireInitialisedSP = CFI.hasCall() || MFI.hasStackObjects();

    if (effectiveSP == Colossus::MWORKER_BASE && requireInitialisedSP) {
      assert(!overAlign);
      assert(FrameSize == redZoneSize()); // else allocated above
      buildCopyReg(CII, MBB, MI, Colossus::SP, Colossus::MWORKER_BASE);
      effectiveSP = Colossus::SP;
    }

    if (hasFP(MF)) {
      // Finally set up the frame pointer if one is in use
      unsigned FP = CRI.getFrameRegister(MF);
      if (FP != effectiveSP) {
        buildCopyReg(CII, MBB, MI, FP, effectiveSP);
      }
    }
  } else {
    // No need to adjust the stack pointer if the frame size is zero.
    if (!FrameSize) {
      // Overaligned frames require a BP which means the frame size is +ve
      return;
    }

    bool stackPointerAlreadyDecremented = false;

    MachineBasicBlock *PrologueMBB = &MBB;
    MachineBasicBlock::iterator MBBI = MI;
    if (WithStackCheck) {
      std::tie(stackPointerAlreadyDecremented, PrologueMBB, MBBI) =
          emitStackOverflowCheck();
    }

    // Spills BP at incoming SP - 8. Leaves SP decremented by 8.
    if (hasBP(MF)) {
      assert(!stackPointerAlreadyDecremented);
      spillAndSetupBP(*PrologueMBB, MBBI, CST);
    }

    // Move SP by size of frame
    if (!stackPointerAlreadyDecremented) {
      assert(FrameSize > 0);
      decrementSP(*PrologueMBB, MBBI, Colossus::SP, FrameSize);
    }

    // Align SP to requirements of frame
    if (overAlign) {
      assert(!stackPointerAlreadyDecremented);
      alignSP(*PrologueMBB, MBBI, Colossus::SP);
    }

    // Spill FP into frame using SP as the current frame pointer, then FP = SP.
    if (hasFP(MF)) {
      spillFP(*PrologueMBB, MBBI, CST);
      unsigned FP = CRI.getFrameRegister(MF);
      assert(FP != Colossus::SP);
      buildCopyReg(CII, *PrologueMBB, MBBI, FP, Colossus::SP);
    }

    CFIMBB = PrologueMBB;
    CFIMI = MBBI;
  }

  // Add call frame information if needed.
  if (NeedsDwarfCFI) {
    assert(FrameSize);

    const bool HasBP = hasBP(MF);
    const bool HasFP = hasFP(MF);

    assert((!HasBP || BPOffset) && "BP was not spilled?");
    assert((!HasFP || FPOffset) && "FP was not spilled?");

    // If the stack was realigned or there are variable-sized locals, BP or FP
    // are used to define CFA, otherwise, CFA is adjusted to take into account
    // the change in SP (i.e. CFA = SP + FrameSize).
    if (HasBP) {
      const unsigned DwarfBPReg = CRI.getDwarfRegNum(Colossus::BP,
                                                     /*isEH=*/true);
      buildCFI(*CFIMBB, CFIMI, dl,
               MCCFIInstruction::createDefCfaRegister(nullptr, DwarfBPReg));
    } else if (HasFP) {
      const unsigned DwarfFPReg = CRI.getDwarfRegNum(Colossus::FP,
                                                     /*isEH=*/true);
      buildCFI(*CFIMBB, CFIMI, dl,
               MCCFIInstruction::cfiDefCfa(nullptr, DwarfFPReg, FrameSize));
    } else
      buildCFI(*CFIMBB, CFIMI, dl,
               MCCFIInstruction::cfiDefCfaOffset(nullptr, FrameSize));

    // Describe where BP was saved as a fixed offset from CFA.
    if (HasBP) {
      const unsigned DwarfBPReg = CRI.getDwarfRegNum(Colossus::BP,
                                                     /*isEH=*/true);
      buildCFI(*CFIMBB, CFIMI, dl,
               MCCFIInstruction::createOffset(nullptr, DwarfBPReg, BPOffset));
    }

    // Describe where FP was saved as a fixed offset from CFA.
    if (HasFP) {
      const unsigned DwarfFPReg = CRI.getDwarfRegNum(Colossus::FP,
                                                     /*isEH=*/true);
      buildCFI(*CFIMBB, CFIMI, dl,
               MCCFIInstruction::createOffset(nullptr, DwarfFPReg, FPOffset));
    }

    // Describe where each callee-saved register was saved, as a fixed offset
    // from CFA.
    for (const auto &CSI : MFI.getCalleeSavedInfo()) {
      assert(CSI.isRestored() && !CSI.isSpilledToReg());

      const int RegOffset = MFI.getObjectOffset(CSI.getFrameIdx());
      const unsigned DwarfReg = CRI.getDwarfRegNum(CSI.getReg(), /*isEH=*/true);
      buildCFI(*CFIMBB, CFIMI, dl,
               MCCFIInstruction::createOffset(nullptr, DwarfReg, RegOffset));
    }
  }
}

void ColossusFrameLowering::emitEpilogue(MachineFunction &MF,
                                         MachineBasicBlock &MBB) const {

  LLVM_DEBUG(dbgs() << "Emit epilogue\n");

  const MachineFrameInfo &MFI = MF.getFrameInfo();
  const TargetInstrInfo &TII = *MF.getSubtarget().getInstrInfo();
  auto &CRI = *static_cast<const ColossusRegisterInfo *>(
      MF.getSubtarget().getRegisterInfo());
  auto CII = static_cast<const ColossusInstrInfo *>(&TII);
  ColossusFunctionInfo &CFI = *MF.getInfo<ColossusFunctionInfo>();
  auto &CST = static_cast<const ColossusSubtarget &>(MF.getSubtarget());

  // Compute the stack size to determine if we need a epilogue at all.
  uint64_t FrameSize = MFI.getStackSize();
  if (!FrameSize) {
    return;
  }

  // The vertex calling convention has no callee-save registers to restore.
  if (isVertexCC(MF)) {
    return;
  }

  MachineBasicBlock *EpilogueMBB = &MBB;
  // In "both" mode, if the original code we splitted on the prologue had no
  // branches, then we need to find the successor BB where the body with the
  // return instr (found by PrologEpilogInserter) was moved to. 
  if (CST.isBothMode() && shouldEmitStackOverflowCheck(FrameSize, CST) &&
      !MBB.isReturnBlock()) {
    auto I = MBB.getLastNonDebugInstr();
    assert(I->getOpcode() == Colossus::BRZ || I->getOpcode() == Colossus::BRNZ);
    (void)I;

    // Find the ContinueMBB which has return instr.
    MachineBasicBlock *Succ = *MBB.succ_begin();
    EpilogueMBB = *Succ->succ_begin();

    assert(EpilogueMBB != &MBB && "ContinueMBB must not be the entry block");
    assert(EpilogueMBB->isReturnBlock() &&
           "ContinueMBB must be the return block");
  }
  MachineBasicBlock::iterator MI = EpilogueMBB->getLastNonDebugInstr();

  DebugLoc dl = getDL(*EpilogueMBB, MI);

  // Ignore the Colossus::RTN_REG_HOLDER pseudo instruction following 'ret'.
  if (MI->getOpcode() == Colossus::RTN_REG_HOLDER) {
    --MI;
  }
  assert(MI->isReturn() && "should only emit epilogue before return inst");

  const bool HasBP = hasBP(MF);
  const bool HasFP = hasFP(MF);

  // First restore the SP to its value on entry to the function
  if (HasBP) {
    buildCopyReg(CII, *EpilogueMBB, MI, Colossus::SP, Colossus::BP);
  } else {
    const unsigned FrameReg = CRI.getFrameRegister(MF);
    buildAddImm(CII, *EpilogueMBB, MI, Colossus::SP, FrameReg, FrameSize);

    // Adjust CFA at offset 0 if CFA was defined in terms of an offset from SP.
    if (FrameReg == Colossus::SP) {
      assert(!HasBP && !HasFP);
      buildCFI(*EpilogueMBB, MI, dl,
               MCCFIInstruction::cfiDefCfaOffset(nullptr, 0));
    }
  }

  // Helper to define CFA as SP after a change in BP or FP if these are used to
  // define CFA.
  auto emitCfaUpdate = [&]() {
    assert(HasBP || HasFP);
    const unsigned DwarfSPReg = CRI.getDwarfRegNum(Colossus::SP, /*isEH=*/true);
    buildCFI(*EpilogueMBB, MI, dl,
             MCCFIInstruction::createDefCfaRegister(nullptr, DwarfSPReg));
  };

  // Restore FP from spill slot using FP as the reference
  if (HasFP) {
    assert(CFI.hasFPSpillSlot() && "No FP spill slot allocated");
    const int FPSpillSlot = CFI.getFPSpillSlot();
    const int Offset = (FrameSize + MFI.getObjectOffset(FPSpillSlot)) / 4;
    LLVM_DEBUG(dbgs() << "Retrieve FP using offset = " << Offset << "\n");
    // Restore the FP.
    if (Offset >= 0 && isUInt<12>(Offset)) {
      // Load from FP because SP has already been restored
      BuildMI(*EpilogueMBB, MI, dl, TII.get(Colossus::LD32_ZI), Colossus::FP)
          .addReg(Colossus::FP)
          .addReg(Colossus::MZERO)
          .addImm(Offset)
          .addImm(0 /* Coissue bit */)
          .addMemOperand(CII->getFrameIndexMMO(*EpilogueMBB, FPSpillSlot,
                                               MachineMemOperand::MOLoad))
          .setMIFlag(MachineInstr::FrameSetup);
      // If there is both a BP and FP, then BP takes precedence in defining CFA.
      if (!HasBP) {
        emitCfaUpdate();
      }
    } else {
      // TODO: provide a register-offset load for this case.
      report_fatal_error("Stack offset out of range");
    }
  }

  // Restore BP from spill. At this point SP == BP, using BP to restore itself.
  if (HasBP) {
    LLVM_DEBUG(dbgs() << "Retrieve BP using offset = -8\n");
    buildSubImm(CII, *EpilogueMBB, MI, Colossus::BP, Colossus::BP, 8);
    emitCfaUpdate();
    BuildMI(*EpilogueMBB, MI, dl, TII.get(Colossus::LD32_ZI), Colossus::BP)
      .addReg(Colossus::BP)
      .addReg(Colossus::MZERO)
      .addImm(0)
      .addImm(0 /* Coissue bit */)
      .setMIFlag(MachineInstr::FrameSetup);
  }
}

/// Assign each callee-saved register a spill slot. This modified data structure
/// is passed to the spill and restore methods below. Aligned pairs of registers
/// are allocated 64-bit aligned stack slots (from the top of the spill area)
/// and the remaining registers are allocated to slots below that.
bool ColossusFrameLowering::
assignCalleeSavedSpillSlots(MachineFunction &MF,
                            const TargetRegisterInfo *TRI,
                            std::vector<CalleeSavedInfo> &CSI) const {
  // Do nothing if no registers need to be spilt.
  if (CSI.empty()) {
    return false;
  }

  LLVM_DEBUG(dbgs() << "Assign callee-saved spill slots for " << MF.getName()
                    << '\n');

  auto &CRI = *static_cast<const ColossusRegisterInfo *>(TRI);
  MachineFrameInfo &MFI = MF.getFrameInfo();

  // Sort the CSI vector by register identifiers in ascending order. This
  // separates M registers from A ones and register pairs will be consective.
  std::sort(CSI.begin(), CSI.end(),
            [] (CalleeSavedInfo const &A, CalleeSavedInfo const &B) {
                 return A.getReg() < B.getReg();
               });

  // Determine register pairs.
  SmallVector<unsigned, 8> Regs;
  bool GotReg = false;
  unsigned PrevReg, CurrReg;
  for (auto I = CSI.begin(), E = CSI.end(); I != E; ++I) {
    CurrReg = I->getReg();
    LLVM_DEBUG(dbgs() << "   * "
                      << ColossusRegisterInfo::getRegisterName(CurrReg)
                      << "\n");
    if (GotReg) {
      if ((Colossus::ARRegClass.contains(PrevReg) &&
           Colossus::ARRegClass.contains(CurrReg)) &&
          CRI.regsArePair(PrevReg, CurrReg)) {
        CurrReg = TRI->getMatchingSuperReg(PrevReg, Colossus::SubRegLo,
                                           &Colossus::ARPairRegClass);
        Regs.push_back(CurrReg);
        GotReg = false;
      } else {
        Regs.push_back(PrevReg);
        PrevReg = CurrReg;
      }
    } else {
      PrevReg = CurrReg;
      GotReg = true;
    }
  }
  if (GotReg) {
    Regs.push_back(PrevReg);
  }
  LLVM_DEBUG(dbgs() << "  > Callee-save registers:\n"; for (auto Reg
                                                            : Regs) {
    errs() << "    - " << ColossusRegisterInfo::getRegisterName(Reg) << '\n';
  });

  std::vector<CalleeSavedInfo> NewCSI;

  // Assign 64-bit aligned stack locations to each register pair.
  for (auto Reg : Regs) {
    const TargetRegisterClass *RC;
    if (Colossus::MRRegClass.contains(Reg)) {
       RC = &Colossus::MRRegClass;
    } else if (Colossus::ARRegClass.contains(Reg)) {
       RC = &Colossus::ARRegClass;
    } else if (Colossus::MRPairRegClass.contains(Reg)) {
       RC = &Colossus::MRPairRegClass;
    } else if (Colossus::ARPairRegClass.contains(Reg)) {
       RC = &Colossus::ARPairRegClass;
    } else {
      report_fatal_error("Unexpected register class");
    }
    const TargetRegisterInfo *RegInfo = MF.getSubtarget().getRegisterInfo();
    unsigned Size = RegInfo->getSpillSize(*RC);
    Align Alignment = RegInfo->getSpillAlign(*RC);
    int FrameIndex = MFI.CreateSpillStackObject(Size, Alignment);
    NewCSI.push_back(CalleeSavedInfo(Reg, FrameIndex));
    LLVM_DEBUG(dbgs() << "  > Allocated "
                      << ColossusRegisterInfo::getRegisterName(Reg)
                      << " to frame index " << FrameIndex << '\n');
  }

  // Update the CSI vector.
  CSI.clear();
  CSI.assign(NewCSI.begin(), NewCSI.end());

  return true;
}

bool ColossusFrameLowering::spillCalleeSavedRegisters(
    MachineBasicBlock &MBB, MachineBasicBlock::iterator MI,
    ArrayRef<CalleeSavedInfo> CSI, const TargetRegisterInfo *TRI) const {
  MachineFunction &MF = *MBB.getParent();
  const TargetInstrInfo &TII = *MF.getSubtarget().getInstrInfo();

  for (const CalleeSavedInfo &CS : CSI) {
    const unsigned Reg = CS.getReg();

    if (CS.isSpilledToReg()) {
      BuildMI(MBB, MI, DebugLoc(), TII.get(TargetOpcode::COPY), CS.getDstReg())
          .addReg(Reg, getKillRegState(true))
          .setMIFlag(MachineInstr::FrameSetup);
    } else {
      const TargetRegisterClass *RC = TRI->getMinimalPhysRegClass(Reg);
      TII.storeRegToStackSlot(MBB, MI, Reg, true, CS.getFrameIdx(), RC, TRI);
      auto PrevMI = std::prev(MI);
      PrevMI->setFlag(MachineInstr::FrameSetup);
    }
  }

  return true;
}

// Eliminate ADJCALLSTACKDOWN and ADJCALLSTACKUP pseudo instructions.
MachineBasicBlock::iterator  ColossusFrameLowering::
eliminateCallFramePseudoInstr(MachineFunction &MF,
                              MachineBasicBlock &MBB,
                              MachineBasicBlock::iterator MI) const {

  LLVM_DEBUG(dbgs() << "Eliminate call-frame pseudo instruction\n");

  // If the adjustment is not dealt with in the prologue and epilogue.
  if (!hasReservedCallFrame(MF)) {

    assert((MI->getOpcode() == Colossus::ADJCALLSTACKUP ||
            MI->getOpcode() == Colossus::ADJCALLSTACKDOWN) &&
           "Expecting ADJCALLSTACKUP/DOWN");

    MachineInstr *Old = &*MI;
    uint64_t Amount = Old->getOperand(0).getImm();
    if (Amount != 0) {

      unsigned StackAlign = getStackAlignment();
      Amount = alignTo(Amount, StackAlign);

      unsigned SP = Colossus::SP;
      const TargetInstrInfo *TII = MF.getSubtarget().getInstrInfo();
      auto CII = static_cast<const ColossusInstrInfo *>(TII);
      DebugLoc dl = Old->getDebugLoc();
      if (Old->getOpcode() == Colossus::ADJCALLSTACKDOWN) {
        // Range checks because there is no scratch register available
        // Could relax this once a register scavenger is implemented
        if (!isInt<16>(-Amount)) {
          report_fatal_error("ADJCALLSTACKDOWN out of range");
        }
        // Replace ADJCALLSTACKDOWN with 'add SP, SP, -<Amount>'.
        buildSubImm(CII, MBB, MI, SP, SP, Amount);
      } else if (Old->getOpcode() == Colossus::ADJCALLSTACKUP) {
        if (!isUInt<16>(Amount)) {
          report_fatal_error("ADJCALLSTACKUP out of range");
        }
        // Replace ADJCALLSTACKUP with 'add SP, SP, <Amount>'.
        buildAddImm(CII, MBB, MI, SP, SP, Amount);
      }
    }
  }

  // Remove the pseudo instruction.
  return MBB.erase(MI);
}
