//===-- ColossusRegisterInfo.cpp - Colossus Register Information ----------===//
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
// This file contains the Colossus implementation of the TargetRegisterInfo
//  class.
//
//===----------------------------------------------------------------------===//

#include "ColossusRegisterInfo.h"
#include "Colossus.h"
#include "ColossusFrameLowering.h"
#include "ColossusInstrInfo.h"
#include "ColossusSubtarget.h"
#include "ColossusTargetInstr.h"
#include "ColossusTargetMachine.h"
#include "MCTargetDesc/ColossusInstPrinter.h"
#include "llvm/ADT/BitVector.h"
#include "llvm/CodeGen/MachineFrameInfo.h"
#include "llvm/CodeGen/MachineFunction.h"
#include "llvm/CodeGen/MachineInstrBuilder.h"
#include "llvm/CodeGen/RegisterScavenging.h"
#include "llvm/CodeGen/TargetFrameLowering.h"
#include "llvm/CodeGen/TargetSubtargetInfo.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Support/raw_ostream.h"

using namespace llvm;

#define DEBUG_TYPE "colossus-reg-info"

#define GET_REGINFO_TARGET_DESC
#include "ColossusGenRegisterInfo.inc"

ColossusRegisterInfo::ColossusRegisterInfo()
  : ColossusGenRegisterInfo(Colossus::LR) {
}

const MCPhysReg* ColossusRegisterInfo::
getCalleeSavedRegs(const MachineFunction *MF) const {
  if (MF->getFunction().getCallingConv() == CallingConv::Colossus_Vertex) {
    return CC_Save_Vertex_SaveList;
  }

  auto CFI = static_cast<const ColossusFrameLowering *>(
      MF->getSubtarget().getFrameLowering());

  bool frameHasBP = CFI->hasBP(*MF);
  bool frameHasFP = CFI->hasFP(*MF);

  if (frameHasBP && frameHasFP) {
    return CC_Save_BP_AND_FP_SaveList;
  }
  if (frameHasBP) {
    return CC_Save_BP_SaveList;
  }
  if (frameHasFP) {
    return CC_Save_FP_SaveList;
  }
  return CC_Save_SaveList;
}

BitVector ColossusRegisterInfo::
getReservedRegs(const MachineFunction &MF) const {
  BitVector Reserved(getNumRegs());
  const auto &CST = static_cast<const ColossusSubtarget &> (MF.getSubtarget());
  auto CFI = static_cast<const ColossusFrameLowering *>(
      CST.getFrameLowering());

  // FP
  if (CFI->hasFP(MF)) {
    Reserved.set(Colossus::FP);
    // MD4 is [BP, FP]
    Reserved.set(Colossus::MD4);
  }
  // BP
  if (CFI->hasBP(MF)) {
    Reserved.set(Colossus::BP);
    // MD4 is [BP, FP]
    Reserved.set(Colossus::MD4);
  }

  for (unsigned Reg : {
    Colossus::SP,
    Colossus::MD5, // MD5 is [LR, SP]
    // Read only registers.
    Colossus::MWORKER_BASE,
    Colossus::MVERTEX_BASE,
    // Unimplemented registers cannot be allocated.
    Colossus::M14,
    Colossus::MD6, 
    Colossus::MD7,
    Colossus::MZERO,
    Colossus::AZERO,
    Colossus::AZEROS,
    Colossus::AQZERO,
    }) {
    Reserved.set(Reg);
  }

  if (CST.getIPUArchInfo().ARF_GP_REGISTERS == 8) {
    for (unsigned Reg : {Colossus::A8,  Colossus::A9,   Colossus::A10,
                         Colossus::A11, Colossus::A12,  Colossus::A13,
                         Colossus::A14,
                         Colossus::AD4, Colossus::AD5,  Colossus::AD6,
                         Colossus::AD7,
                         Colossus::AQ0, Colossus::AQ1,  Colossus::AQ2,
                         Colossus::AQ3,

         }) {
      Reserved.set(Reg);
    }
  }
  
  for (unsigned Reg : {Colossus::AD8,  Colossus::AD9, Colossus::AD10, 
                       Colossus::AD11, Colossus::AD12, Colossus::AD13, 
                       Colossus::AD14,
                       Colossus::AQ4,  Colossus::AQ5, Colossus::AQ6,
                       Colossus::AQ7,  Colossus::AQ8, Colossus::AQ9,
                       Colossus::AQ10, Colossus::AQ11,Colossus::AQ12,
                       Colossus::AQ13, Colossus::AQ14,  

         }) {
      Reserved.set(Reg);
    }

  return Reserved;
}

const uint32_t *ColossusRegisterInfo::
getCallPreservedMask(const MachineFunction &MF,
                     CallingConv::ID) const {
  return CC_Save_RegMask;
}

unsigned ColossusRegisterInfo::getStackRegister() {
  return Colossus::SP;
}

// If the stack is not realigned, (FP,framesize) can be used to retrieve
// incoming args. If there are no variable size locals, but there is
// realignment, the SP can access local slots.

Register ColossusRegisterInfo::
getFrameRegister(const MachineFunction &MF) const {
  const TargetFrameLowering *TFI = MF.getSubtarget().getFrameLowering();
  uint64_t FrameSize = MF.getFrameInfo().getStackSize();
  return (TFI->hasFP(MF) && FrameSize) ? Colossus::FP : Colossus::SP;
}

Register ColossusRegisterInfo::
getBaseRegister(const MachineFunction &MF) const {
  auto CFI = static_cast<const ColossusFrameLowering *>(
      MF.getSubtarget().getFrameLowering());
  uint64_t FrameSize = MF.getFrameInfo().getStackSize();
  return (CFI->hasBP(MF) && FrameSize) ? Colossus::BP : getFrameRegister(MF);
}

const char *ColossusRegisterInfo::
getRegisterName(unsigned Reg) {
  return ColossusInstPrinter::getRegisterName(Reg);
}

/// Given two physical registers, return a Boolean indicating if they are
/// contained in a register pair.
bool ColossusRegisterInfo::regsArePair(Register RegLo, Register RegHi) const {
  assert(Register::isPhysicalRegister(RegLo) && "Expecting physical register");
  assert(Register::isPhysicalRegister(RegHi) && "Expecting physical register");
  assert(getEncodingValue(RegLo) < getEncodingValue(RegHi)
         && "Lo reg number >= hi reg number");

  switch (RegLo) {
  case Colossus::M0:  return RegHi == Colossus::M1;
  case Colossus::M2:  return RegHi == Colossus::M3;
  case Colossus::M4:  return RegHi == Colossus::M5;
  case Colossus::M6:  return RegHi == Colossus::M7;
  case Colossus::BP:  return RegHi == Colossus::FP;
  case Colossus::LR:  return RegHi == Colossus::SP;
  case Colossus::MWORKER_BASE: return RegHi == Colossus::MVERTEX_BASE;
  case Colossus::M14: return RegHi == Colossus::MZERO;
  case Colossus::A0:  return RegHi == Colossus::A1;
  case Colossus::A2:  return RegHi == Colossus::A3;
  case Colossus::A4:  return RegHi == Colossus::A5;
  case Colossus::A6:  return RegHi == Colossus::A7;
  case Colossus::A8:  return RegHi == Colossus::A9;
  case Colossus::A10: return RegHi == Colossus::A11;
  case Colossus::A12: return RegHi == Colossus::A13;
  case Colossus::A14: return RegHi == Colossus::AZERO;
  default:
    return false;
  }
}

static void buildLoad(MachineBasicBlock &MBB,
                      MachineBasicBlock::iterator &II,
                      MachineInstr &MI,
                      const ColossusInstrInfo &CII,
                      unsigned OpcodeReg,
                      unsigned OpcodeImm,
                      int Offset,
                      unsigned DstReg,
                      unsigned FrameReg) {
  DebugLoc dl = MI.getDebugLoc();
  if (Offset >= 0 && isUIntN(12, Offset)) {
    // Load word with immediate offset.
    BuildMI(MBB, II, dl, CII.get(OpcodeImm), DstReg)
        .addReg(FrameReg)
        .addReg(Colossus::MZERO)
        .addImm(Offset)
        .addImm(0 /* Coissue bit */)
        .addMemOperand(*MI.memoperands_begin());
  } else {
    // Load word with register offset.
    CII.loadConstant32(MBB, II, DstReg, Offset);
    BuildMI(MBB, II, dl, CII.get(OpcodeReg), DstReg)
        .addReg(FrameReg)
        .addReg(Colossus::MZERO)
        .addReg(DstReg)
        .addImm(0 /* Coissue bit */)
        .addMemOperand(*MI.memoperands_begin());
  }
}

static void buildStore(MachineBasicBlock &MBB, MachineBasicBlock::iterator &II,
                       MachineInstr &MI, const ColossusInstrInfo &CII,
                       unsigned OpcodeImm, int Offset, unsigned SrcReg,
                       bool KillSrc, unsigned FrameReg, bool FrameSetup,
                       unsigned implicitSuper = Colossus::NoRegister) {
  DebugLoc dl = MI.getDebugLoc();
  if (Offset >= 0 && isUIntN(12, Offset)) {
    // Store word with immediate offset.
    auto MIB = BuildMI(MBB, II, dl, CII.get(OpcodeImm))
                   .addReg(SrcReg, getKillRegState(KillSrc))
                   .addReg(FrameReg)
                   .addReg(Colossus::MZERO)
                   .addImm(Offset)
                   .addImm(0 /* Coissue bit */)
                   .addMemOperand(*MI.memoperands_begin());
    if (implicitSuper != Colossus::NoRegister) {
      MIB.addReg(implicitSuper, RegState::Implicit);
    }
    if (FrameSetup) {
      MIB->setFlag(MachineInstr::FrameSetup);
    }
  } else {
    report_fatal_error("Frame index is out of range for store");
    // TODO: scavenge register for offset.
  }
}

bool ColossusRegisterInfo::
requiresRegisterScavenging(const MachineFunction &MF) const {
  return false;
}

/// Register scavenging is used during lowering of pseudo instructions.
bool ColossusRegisterInfo::
trackLivenessAfterRegAlloc(const MachineFunction &MF) const {
  return true;
}

void ColossusRegisterInfo::eliminateFrameIndex(MachineBasicBlock::iterator II,
                                               int, unsigned FIOperandNum,
                                               RegScavenger *) const {
  LLVM_DEBUG(dbgs() << "Eliminate frame index\n");
  MachineInstr &MI = *II;
  const MachineFunction &MF = *MI.getParent()->getParent();
  const MachineFrameInfo &MFI = MF.getFrameInfo();

  MachineOperand &FrameOp = MI.getOperand(FIOperandNum);
  int FrameIndex = FrameOp.getIndex();
  unsigned FrameReg =
      FrameIndex < 0 ? getBaseRegister(MF) : getFrameRegister(MF);
  bool FrameSetup = MI.getFlag(MachineInstr::FrameSetup);

  // Negative indices are used for fixed stack objects, e.g. argument stack
  // slots at the top of the frame. Non-negative indices are used for objects
  // that may be reordered. These are allocated offsets from the SP on entry to
  // a function. The FP is set to the position of the SP after creating the
  // frame so that all offsets are positive. Both must have the StackSize added
  // to reference indices from the bottom of the frame.
  // The BP, if any, is set to the position of the stack pointer on entry to
  // to the function and needs no such adjustment.

  int64_t Offset = MFI.getObjectOffset(FrameIndex);
  uint64_t StackSize = MF.getFrameInfo().getStackSize();

  if (FrameReg != Colossus::BP) {
    Offset += StackSize;
  }

  // Handle DBG_VALUE and INLINEASM instructions.
  if (MI.isDebugValue() || MI.isInlineAsm()) {
    MI.getOperand(FIOperandNum).ChangeToRegister(FrameReg, false /*isDef*/);
    MI.getOperand(FIOperandNum + 1).ChangeToImmediate(Offset);
    return;
  }

  MachineBasicBlock &MBB = *MI.getParent();
  DebugLoc dl = MI.getDebugLoc();

  MachineOperand &OffsetOperand = MI.getOperand(FIOperandNum + 1);
  if (OffsetOperand.isImm()) {
    // Fold immediate offset to FrameIndex into Offset.
    Offset += OffsetOperand.getImm();
    MI.getOperand(FIOperandNum + 1).ChangeToImmediate(0);
  }

  const TargetInstrInfo *TII = MF.getSubtarget().getInstrInfo();
  auto &CST = static_cast<ColossusSubtarget const &>(MF.getSubtarget());
  static_cast <void>(CST);
  auto &CII = *static_cast<const ColossusInstrInfo*>(TII);
  const TargetRegisterInfo *RI = MF.getSubtarget().getRegisterInfo();
  unsigned SrcDstReg = MI.getOperand(0).getReg();

  // Transform specific pseduo instructions with frame index operands into
  // corresponding sequences of machine instructions.
  switch (MI.getOpcode()) {
  default: {
    LLVM_DEBUG(MI.dump());
    llvm_unreachable("Frame index elimination not implemented for operation");
  }
  // A raw frame index.
  case Colossus::FRAME_INDEX: {
    assert(Colossus::MRRegClass.contains(SrcDstReg) &&
           "Unexpected register class");
    if (isUInt<16>(Offset)) {
      BuildMI(MBB, II, dl, CII.get(Colossus::ADD_ZI), SrcDstReg)
          .addReg(FrameReg)
          .addImm(Offset)
          .addImm(0 /* Coissue bit */);
    } else {
      report_fatal_error("Frame index is out of SETZI range");
    }
    break;
  }
  // LD64
  case Colossus::LD64_FI: {
      assert(Colossus::MRPairRegClass.contains(SrcDstReg) &&
             "Unexpected register class");
      auto op = getLD64(CST);

      if (op.has_value()) {
        buildLoad(MBB, II, MI, CII, op.value(), getLD64_ZI(CST).value(),
                  Offset / 8, SrcDstReg, FrameReg);
      } else {
        unsigned SrcDstRegLo = RI->getSubReg(SrcDstReg, Colossus::SubRegLo);
        unsigned SrcDstRegHi = RI->getSubReg(SrcDstReg, Colossus::SubRegHi);
        buildLoad(MBB, II, MI, CII, Colossus::LD32, Colossus::LD32_ZI,
                  Offset / 4, SrcDstRegLo, FrameReg);
        buildLoad(MBB, II, MI, CII, Colossus::LD32, Colossus::LD32_ZI,
                  (Offset / 4) + 1, SrcDstRegHi, FrameReg);
      }
      break;
  }
  case Colossus::LD64_A_FI: {
    assert(Colossus::ARPairRegClass.contains(SrcDstReg) &&
           "Unexpected register class");
    buildLoad(MBB, II, MI, CII,
              Colossus::LD64_A, Colossus::LD64_ZI_A,
              Offset / 8, SrcDstReg, FrameReg);
    break;
  }
  // LD32
  case Colossus::LD32_FI: {
    assert(Colossus::MRRegClass.contains(SrcDstReg) &&
           "Unexpected register class");
    buildLoad(MBB, II, MI, CII,
              Colossus::LD32, Colossus::LD32_ZI,
              Offset / 4, SrcDstReg, FrameReg);
    break;
  }
  case Colossus::LD32_A_FI: {
    assert(Colossus::ARRegClass.contains(SrcDstReg) &&
           "Unexpected register class");
    buildLoad(MBB, II, MI, CII,
              Colossus::LD32_A, Colossus::LD32_ZI_A,
              Offset / 4, SrcDstReg, FrameReg);
    break;
  }
  // LD16
  case Colossus::LDS16_FI: {
    assert(Colossus::MRRegClass.contains(SrcDstReg) &&
           "Unexpected register class");
    buildLoad(MBB, II, MI, CII,
              Colossus::LDS16, Colossus::LDS16_ZI,
              Offset / 2, SrcDstReg, FrameReg);
    break;
  }
  case Colossus::LDZ16_FI: {
    assert(Colossus::MRRegClass.contains(SrcDstReg) &&
           "Unexpected register class");
    buildLoad(MBB, II, MI, CII,
              Colossus::LDZ16, Colossus::LDZ16_ZI,
              Offset / 2, SrcDstReg, FrameReg);
    break;
  }
  case Colossus::LDZ16_A_FI: {
    assert(Colossus::ARRegClass.contains(SrcDstReg) &&
           "Unexpected register class");
    buildLoad(MBB, II, MI, CII,
              Colossus::LDB16, Colossus::LDB16_ZI,
              Offset / 2, SrcDstReg, FrameReg);
    break;
  }
  // LD8
  case Colossus::LDS8_FI: {
    assert(Colossus::MRRegClass.contains(SrcDstReg) &&
           "Unexpected register class");
    buildLoad(MBB, II, MI, CII,
              Colossus::LDS8, Colossus::LDS8_ZI,
              Offset, SrcDstReg, FrameReg);
    break;
  }
  case Colossus::LDZ8_FI: {
    assert(Colossus::MRRegClass.contains(SrcDstReg) &&
           "Unexpected register class");
    buildLoad(MBB, II, MI, CII,
              Colossus::LDZ8, Colossus::LDZ8_ZI,
              Offset, SrcDstReg, FrameReg);
    break;
  }
  // ST64
  case Colossus::ST64_FI: {
      assert(Colossus::MRPairRegClass.contains(SrcDstReg) &&
             "Unexpected register class");
      bool KillSrc = MI.getOperand(0).isKill();
      auto op = getST64(CST);

      if (op.has_value()) {
        buildStore(MBB, II, MI, CII, op.value(), Offset / 8, SrcDstReg, KillSrc,
                   FrameReg, FrameSetup);
      } else {
        unsigned SrcDstRegLo = RI->getSubReg(SrcDstReg, Colossus::SubRegLo);
        unsigned SrcDstRegHi = RI->getSubReg(SrcDstReg, Colossus::SubRegHi);
        buildStore(MBB, II, MI, CII, ColossusST32_ZI(CST), Offset / 4, SrcDstRegLo,
                  KillSrc, FrameReg, FrameSetup, SrcDstReg);
        buildStore(MBB, II, MI, CII, ColossusST32_ZI(CST), (Offset / 4) + 1,
                  SrcDstRegHi, KillSrc, FrameReg, FrameSetup, SrcDstReg);
      }
      break;
  }
  case Colossus::ST64_A_FI: {
    bool KillSrc = MI.getOperand(0).isKill();
    assert(Colossus::ARPairRegClass.contains(SrcDstReg) &&
           "Unexpected register class");
    buildStore(MBB, II, MI, CII, Colossus::ST64_ZI_A, Offset / 8, SrcDstReg,
               KillSrc, FrameReg, FrameSetup);
    break;
  }
  // ST32
  case Colossus::ST32_FI: {
    bool KillSrc = MI.getOperand(0).isKill();
    assert(Colossus::MRRegClass.contains(SrcDstReg) &&
           "Unexpected register class");
    buildStore(MBB, II, MI, CII, ColossusST32_ZI(CST), Offset / 4, SrcDstReg,
               KillSrc, FrameReg, FrameSetup);
    break;
  }
  case Colossus::ST32_A_FI: {
    bool KillSrc = MI.getOperand(0).isKill();
    assert(Colossus::ARRegClass.contains(SrcDstReg) &&
           "Unexpected register class");
    buildStore(MBB, II, MI, CII, Colossus::ST32_ZI_A, Offset / 4, SrcDstReg,
               KillSrc, FrameReg, FrameSetup);
    break;
  }
  }
  // Erase the old instruction.
  MBB.erase(II);
}

bool ColossusRegisterInfo::isConstantPhysReg(MCRegister PhysReg) const {
  return PhysReg == Colossus::AZERO || PhysReg == Colossus::MZERO ||
         PhysReg == Colossus::AZEROS || PhysReg == Colossus::AQZERO;
}
