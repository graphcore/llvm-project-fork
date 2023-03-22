//===-- ColossusInstrInfo.cpp - Colossus Instruction Information ----------===//
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
// This file contains the Colossus implementation of the TargetInstrInfo class.
//
//===----------------------------------------------------------------------===//

#include "ColossusInstrInfo.h"
#include "Colossus.h"
#include "ColossusMachineFunctionInfo.h"
#include "ColossusSubtarget.h"
#include "ColossusTargetInstr.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/CodeGen/MachineConstantPool.h"
#include "llvm/CodeGen/MachineFrameInfo.h"
#include "llvm/CodeGen/MachineInstrBuilder.h"
#include "llvm/CodeGen/MachineInstrBundle.h"
#include "llvm/CodeGen/MachineMemOperand.h"
#include "llvm/CodeGen/MachineModuleInfo.h"
#include "llvm/CodeGen/MachineRegisterInfo.h"
#include "llvm/IR/Constants.h"
#include "llvm/IR/Function.h"
#include "llvm/MC/MCContext.h"
#include "llvm/MC/TargetRegistry.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/ErrorHandling.h"
#include <optional>

using namespace llvm;

#define DEBUG_TYPE "colossus-instr-info"

#define GET_INSTRINFO_CTOR_DTOR
#include "ColossusGenInstrInfo.inc"

namespace llvm {
namespace Colossus {
  // Condition codes.
  enum CondCode {
    COND_TRUE,
    COND_FALSE,
    COND_NEG,
    COND_POS,
    COND_CLOOP_END_BRANCH,
    COND_CLOOP_GUARD_BRANCH,
  };
}
}

// Pin the vtable to this file.
void ColossusInstrInfo::anchor() {}

ColossusInstrInfo::ColossusInstrInfo()
  : ColossusGenInstrInfo(Colossus::ADJCALLSTACKDOWN,
                         Colossus::ADJCALLSTACKUP),
    RI() {
}

void ColossusInstrInfo::
copyPhysReg(MachineBasicBlock &MBB,
            MachineBasicBlock::iterator I,
            const DebugLoc &DL,
            MCRegister DestReg,
            MCRegister SrcReg,
            bool KillSrc) const {
  auto MtoM = [&](unsigned src, unsigned dst,
                  unsigned super = Colossus::NoRegister) {
    auto MIB =
    BuildMI(MBB, I, DL, get(Colossus::OR_ZI), dst)
        .addReg(src, getKillRegState(KillSrc))
        .addImm(0)
        .addImm(0 /* Coissue bit */);
    if (super != Colossus::NoRegister) {
      MIB.addReg(super, RegState::Implicit);
    }
  };
  auto AtoM = [&](unsigned src, unsigned dst,
                  unsigned super = Colossus::NoRegister) {
    MachineFunction &MF = *MBB.getParent();
    auto &CST = static_cast<const ColossusSubtarget &>(MF.getSubtarget());
    static_cast<void>(CST);
    auto MIB = BuildMI(MBB, I, DL, get(ColossusATOM(CST)), dst)
                   .addReg(src, getKillRegState(KillSrc))
                   .addImm(0 /* Coissue bit */);
    if (super != Colossus::NoRegister) {
      MIB.addReg(super, RegState::Implicit);
    }
  };
  // M -> M
  if (Colossus::MRRegClass.contains(DestReg, SrcReg)) {
    MtoM(SrcReg,DestReg);
  // A -> A
  } else if (Colossus::ARRegClass.contains(DestReg, SrcReg)){
    // OR $aDst, $aSrc, 0
    BuildMI(MBB, I, DL, get(Colossus::OR_ZI_A), DestReg)
        .addReg(SrcReg, getKillRegState(KillSrc))
        .addImm(0)
        .addImm(0 /* Coissue bit */);
  // M -> A
  } else if (Colossus::MRRegClass.contains(SrcReg) &&
             Colossus::ARRegClass.contains(DestReg)) {
    // Move via memory, using the scratch stack slot.
    MachineFunction &MF = *MBB.getParent();
    ColossusFunctionInfo &CFI = *MF.getInfo<ColossusFunctionInfo>();
    auto &CST = static_cast<const ColossusSubtarget &>(MF.getSubtarget());
    static_cast<void>(CST);
    const TargetRegisterInfo *TRI = MF.getSubtarget().getRegisterInfo();
    const MachineFrameInfo &MFI = MF.getFrameInfo();
    unsigned FrameReg = TRI->getFrameRegister(MF);
    int FrameIndex = CFI.getScratchSlot();
    int Offset = MFI.getObjectOffset(FrameIndex);
    int StackSize = MF.getFrameInfo().getStackSize();
    Offset += StackSize;
    if (Offset >= 0 && isShiftedUInt<12, 2>(Offset)) {
      // Store.
      BuildMI(MBB, I, DL, get(ColossusST32_ZI(CST)))
          .addReg(SrcReg, getKillRegState(KillSrc))
          .addReg(FrameReg)
          .addReg(Colossus::MZERO)
          .addImm(Offset / 4)
          .addImm(0 /* Coissue bit */);
      // Load.
      BuildMI(MBB, I, DL, get(Colossus::LD32_ZI_A), DestReg)
          .addReg(FrameReg)
          .addReg(Colossus::MZERO)
          .addImm(Offset / 4)
          .addImm(0 /* Coissue bit */);
    } else {
      // TODO: implement register-offset store & load for this case.
      report_fatal_error("Frame offset out of range for M -> A");
    }
    LLVM_DEBUG(dbgs() << "Created A -> M phys reg copy via memory.\n");
    // A -> M
  } else if (Colossus::ARRegClass.contains(SrcReg) &&
             Colossus::MRRegClass.contains(DestReg)) {
    AtoM(SrcReg, DestReg);
  // MM -> AA
  } else if (Colossus::MRPairRegClass.contains(SrcReg) &&
             Colossus::ARPairRegClass.contains(DestReg)) {
    // Move via memory, using the scratch stack slot.
    MachineFunction &MF = *MBB.getParent();
    ColossusFunctionInfo &CFI = *MF.getInfo<ColossusFunctionInfo>();
    auto &CST = static_cast<const ColossusSubtarget &>(MF.getSubtarget());
    static_cast<void>(CST);
    const TargetRegisterInfo *TRI = MF.getSubtarget().getRegisterInfo();
    const MachineFrameInfo &MFI = MF.getFrameInfo();
    unsigned FrameReg = TRI->getFrameRegister(MF);
    int FrameIndex = CFI.getScratchSlot();
    assert(MFI.getObjectSize(FrameIndex) == 8 && "Frame object not 8 bytes");
    int Offset = MFI.getObjectOffset(FrameIndex);
    int StackSize = MF.getFrameInfo().getStackSize();
    Offset += StackSize;
    // Store.
    unsigned SrcRegLo = RI.getSubReg(SrcReg, Colossus::SubRegLo);
    unsigned SrcRegHi = RI.getSubReg(SrcReg, Colossus::SubRegHi);
    if (Offset >= 0 && isShiftedUInt<12, 2>(Offset + 4)) {
      BuildMI(MBB, I, DL, get(ColossusST32_ZI(CST)))
          .addReg(SrcRegLo, getKillRegState(KillSrc))
          .addReg(FrameReg)
          .addReg(Colossus::MZERO)
          .addImm(Offset / 4)
          .addImm(0 /* Coissue bit */)
          .addReg(SrcReg, RegState::Implicit);
      BuildMI(MBB, I, DL, get(ColossusST32_ZI(CST)))
          .addReg(SrcRegHi, getKillRegState(KillSrc))
          .addReg(FrameReg)
          .addReg(Colossus::MZERO)
          .addImm((Offset / 4) + 1)
          .addImm(0 /* Coissue bit */)
          .addReg(SrcReg, RegState::Implicit);
      // Load.
      BuildMI(MBB, I, DL, get(Colossus::LD64_ZI_A), DestReg)
          .addReg(FrameReg)
          .addReg(Colossus::MZERO)
          .addImm(Offset / 8)
          .addImm(0 /* Coissue bit */);
    } else {
      // TODO: implement register-offset store & load for this case.
      report_fatal_error("Frame offset out of range for MM -> AA");
    }
    LLVM_DEBUG(dbgs() << "Created AA -> MM phys reg copy via memory.\n");
    // AA -> AA
  } else if (Colossus::ARPairRegClass.contains(DestReg, SrcReg)) {
    // OR64 $aDst:+1, $aSrc+1, $azeros
    BuildMI(MBB, I, DL, get(Colossus::OR64), DestReg)
        .addReg(SrcReg, getKillRegState(KillSrc))
        .addReg(Colossus::AZEROS)
        .addImm(0 /* Coissue bit */);
  // AA -> MM
  } else if ((Colossus::ARPairRegClass.contains(SrcReg) &&
              Colossus::MRPairRegClass.contains(DestReg))) {
    for (auto subreg : {Colossus::SubRegLo, Colossus::SubRegHi}) {
      AtoM(RI.getSubReg(SrcReg, subreg), RI.getSubReg(DestReg, subreg), SrcReg);
    }
  // MM -> MM
  } else if (Colossus::MRPairRegClass.contains(DestReg, SrcReg)) {
    for (auto subreg : {Colossus::SubRegLo, Colossus::SubRegHi}) {
      MtoM(RI.getSubReg(SrcReg, subreg), RI.getSubReg(DestReg, subreg), SrcReg);
    }
  }

  else {
    LLVM_DEBUG(dbgs() << "Physreg: Attempting to copy from "
                      << ColossusRegisterInfo::getRegisterName(SrcReg) << " to "
                      << ColossusRegisterInfo::getRegisterName(DestReg)
                      << ".\n");
    llvm_unreachable("Invalid reg-to-reg copy");
  }
}

void ColossusInstrInfo::
storeRegToStackSlot(MachineBasicBlock &MBB,
                    MachineBasicBlock::iterator I,
                    Register SrcReg,
                    bool isKill,
                    int FrameIndex,
                    const TargetRegisterClass *RC,
                    const TargetRegisterInfo *TRI) const {
  DebugLoc dl = getDL(MBB, I);
  switch (RC->getID()) {
  default:
    LLVM_DEBUG(dbgs() << "Invalid reg class " << RC->getID());
    llvm_unreachable("Unexpected register class in storeRegToStackSlot");
  // Single MR.
  case Colossus::MRRegClassID:
    BuildMI(MBB, I, dl, get(Colossus::ST32_FI))
      .addReg(SrcReg, getKillRegState(isKill))
      .addFrameIndex(FrameIndex)
      .addImm(0)
      .addMemOperand(getFrameIndexMMO(MBB, FrameIndex,
                                      MachineMemOperand::MOStore));
    break;
  // Single AR.
  case Colossus::ARRegClassID:
    BuildMI(MBB, I, dl, get(Colossus::ST32_A_FI))
      .addReg(SrcReg, getKillRegState(isKill))
      .addFrameIndex(FrameIndex)
      .addImm(0)
      .addMemOperand(getFrameIndexMMO(MBB, FrameIndex,
                                      MachineMemOperand::MOStore));
    break;
  // MR pair.
  case Colossus::MRPairRegClassID:
    BuildMI(MBB, I, dl, get(Colossus::ST64_FI))
      .addReg(SrcReg, getKillRegState(isKill))
      .addFrameIndex(FrameIndex)
      .addImm(0)
      .addMemOperand(getFrameIndexMMO(MBB, FrameIndex,
                                      MachineMemOperand::MOStore));
    break;
  // AR pair.
  case Colossus::ARPairRegClassID:
  case Colossus::ARPair_with_SubRegHiRegClassID:
    BuildMI(MBB, I, dl, get(Colossus::ST64_A_FI))
      .addReg(SrcReg, getKillRegState(isKill))
      .addFrameIndex(FrameIndex)
      .addImm(0)
      .addMemOperand(getFrameIndexMMO(MBB, FrameIndex,
                                      MachineMemOperand::MOStore));
    break;
  }
}

void ColossusInstrInfo::
loadRegFromStackSlot(MachineBasicBlock &MBB,
                     MachineBasicBlock::iterator I,
                     Register DestReg,
                     int FrameIndex,
                     const TargetRegisterClass *RC,
                     const TargetRegisterInfo *TRI) const {
  DebugLoc dl = getDL(MBB, I);
  switch (RC->getID()) {
  default:
    LLVM_DEBUG(dbgs() << "Invalid reg class " << RC->getID());
    llvm_unreachable("Unexpected register class in loadRegFromStackSlot");
  // Single MR.
  case Colossus::MRRegClassID:
    BuildMI(MBB, I, dl, get(Colossus::LD32_FI), DestReg)
      .addFrameIndex(FrameIndex)
      .addImm(0)
      .addMemOperand(getFrameIndexMMO(MBB, FrameIndex,
                                      MachineMemOperand::MOLoad));
    break;
  // Single AR.
  case Colossus::ARRegClassID:
    BuildMI(MBB, I, dl, get(Colossus::LD32_A_FI), DestReg)
      .addFrameIndex(FrameIndex)
      .addImm(0)
      .addMemOperand(getFrameIndexMMO(MBB, FrameIndex,
                                      MachineMemOperand::MOLoad));
    break;
  // MR pair.
  case Colossus::MRPairRegClassID:
    BuildMI(MBB, I, dl, get(Colossus::LD64_FI), DestReg)
      .addFrameIndex(FrameIndex)
      .addImm(0)
      .addMemOperand(getFrameIndexMMO(MBB, FrameIndex,
                                      MachineMemOperand::MOLoad));
    break;
  // AR pair.
  case Colossus::ARPairRegClassID:
  case Colossus::ARPair_with_SubRegHiRegClassID:
    BuildMI(MBB, I, dl, get(Colossus::LD64_A_FI), DestReg)
      .addFrameIndex(FrameIndex)
      .addImm(0)
      .addMemOperand(getFrameIndexMMO(MBB, FrameIndex,
                                      MachineMemOperand::MOLoad));
    break;
  }
}

bool ColossusInstrInfo::
expandPostRAPseudo(MachineInstr &MI) const {
  LLVM_DEBUG(dbgs() << "Expanding pseudo instructions\n");
  MachineBasicBlock &MBB = *MI.getParent();
  DebugLoc dl = MI.getDebugLoc();

  switch (MI.getOpcode()) {
    default: {
      return false;
    }
    // Replace a CALL pseudo with a call $lr, <TargetAddr>.
    case Colossus::CALL_PSEUDO: {
      if (MI.getOperand(0).isGlobal()) {
        // Global address.
        auto MIB = BuildMI(MBB, MI, dl, get(Colossus::CALL), Colossus::LR)
          .addGlobalAddress(MI.getOperand(0).getGlobal())
          .addImm(0 /* Coissue bit */);
        MIB.copyImplicitOps(MI);
        // Remove the original pseudo instruction.
        MBB.erase(MI);
        return true;
      }
      if (MI.getOperand(0).isSymbol()) {
        // External symbol.
        auto MIB = BuildMI(MBB, MI, dl, get(Colossus::CALL), Colossus::LR)
          .addExternalSymbol(MI.getOperand(0).getSymbolName())
          .addImm(0 /* Coissue bit */);
        MIB.copyImplicitOps(MI);
        // Remove the original pseudo instruction.
        MBB.erase(MI);
        return true;
      }
      return false;
    }
    // Replace a SETLR pseudo with:
    //     setzi $lr, link-address
    case Colossus::SETLR: {
      MCSymbol *Label = MI.getOperand(0).getMCSymbol();
      BuildMI(MBB, MI, dl, get(Colossus::SETZI), Colossus::LR)
        .addSym(Label)
        .addImm(0 /* Coissue bit */);
      // Remove the original pseudo instruction.
      MBB.erase(MI);
      return true;
    }
    // Replace an ICALL pseudo (indirect call) with:
    //     br $address
    //   link-address:
    //     ...
    case Colossus::ICALL: {
      MCSymbol *Label = MI.getOperand(0).getMCSymbol();
      unsigned AddrReg = MI.getOperand(1).getReg();
      assert(AddrReg != Colossus::LR && "ICALL will clobber LR");
      BuildMI(MBB, MI, dl, get(Colossus::CALLIND))
        .addReg(AddrReg, getRegState(MI.getOperand(1)))
        .addImm(0 /* Coissue bit */);
      BuildMI(MBB, MI, dl, get(Colossus::LABEL))
        .addSym(Label);
      // Remove the original pseudo instruction.
      MBB.erase(MI);
      return true;
    }
    // Replace FRAME_TO_ARGS_OFFSET with the offset from the SP/FP to the first
    // incoming argument on the stack.
    case Colossus::FRAME_TO_ARGS_OFFSET: {
      const MachineFrameInfo &MFI = MBB.getParent()->getFrameInfo();
      unsigned Offset = MFI.getStackSize();
      const unsigned Reg = MI.getOperand(0).getReg();
      loadConstant32(MBB, MI, Reg, Offset);
      // Remove the original pseudo instruction.
      MBB.erase(MI);
      return true;
    }
    case Colossus::RTN_PSEUDO: {
      BuildMI(MBB, MI, dl, get(Colossus::RTN))
        .addReg(Colossus::LR)
        .addImm(0 /* Coissue bit */);
      MBB.erase(MI);
      return true;
    }
    // Remove the RETURN_REG_HOLDER instruction since it is no longer required.
    case Colossus::RTN_REG_HOLDER: {
      MBB.erase(MI);
      return true;
    }
  }
}

namespace {
bool isUncondBr(unsigned Opcode) {
  return Opcode == Colossus::BR;
}

bool isCondBr(unsigned Opcode) {
  return Opcode == Colossus::BRNEG ||
         Opcode == Colossus::BRNZ ||
         Opcode == Colossus::BRPOS ||
         Opcode == Colossus::BRZ ||
         Opcode == Colossus::CLOOP_END_BRANCH ||
         Opcode == Colossus::CLOOP_GUARD_BRANCH;
}

Colossus::CondCode getCondFromBrOpc(unsigned Opcode) {
  switch (Opcode) {
  default:
    llvm_unreachable("Invalid conditional branch");
  case Colossus::BRNZ:   return Colossus::CondCode::COND_TRUE;
  case Colossus::BRZ:    return Colossus::CondCode::COND_FALSE;
  case Colossus::BRNEG:  return Colossus::CondCode::COND_NEG;
  case Colossus::BRPOS:  return Colossus::CondCode::COND_POS;
  case Colossus::CLOOP_END_BRANCH:
    return Colossus::CondCode::COND_CLOOP_END_BRANCH;
  case Colossus::CLOOP_GUARD_BRANCH:
    return Colossus::CondCode::COND_CLOOP_GUARD_BRANCH;
  }
}

bool branchHasCoissueOperand(unsigned Opcode) {
  return (Opcode != Colossus::CLOOP_END_BRANCH) &&
         (Opcode != Colossus::CLOOP_GUARD_BRANCH);
}

bool branchHasMetadataOperand(unsigned Opcode) {
  assert(isCondBr(Opcode)); // otherwise can't store metadata in Cond vector
  return (Opcode == Colossus::CLOOP_END_BRANCH) ||
         (Opcode == Colossus::CLOOP_GUARD_BRANCH);
}

unsigned getBrOpcFromCond(Colossus::CondCode CC) {
  switch (CC) {
  case Colossus::CondCode::COND_TRUE:  return Colossus::BRNZ;
  case Colossus::CondCode::COND_FALSE: return Colossus::BRZ;
  case Colossus::CondCode::COND_NEG:   return Colossus::BRNEG;
  case Colossus::CondCode::COND_POS:   return Colossus::BRPOS;
  case Colossus::CondCode::COND_CLOOP_END_BRANCH:
    return Colossus::CLOOP_END_BRANCH;
  case Colossus::CondCode::COND_CLOOP_GUARD_BRANCH:
    return Colossus::CLOOP_GUARD_BRANCH;
  }
  llvm_unreachable("Invalid Colossus::CondCode");
}

bool hasOppositeCondCode(Colossus::CondCode CC) {
  switch (CC) {
  default: { return false; }
  case Colossus::CondCode::COND_TRUE:
  case Colossus::CondCode::COND_FALSE:
  case Colossus::CondCode::COND_NEG:
  case Colossus::CondCode::COND_POS: {
    return true;
  }
  }
}

Colossus::CondCode getOppositeCondCode(Colossus::CondCode CC) {
  assert(hasOppositeCondCode(CC));
  switch (CC) {
  case Colossus::CondCode::COND_TRUE:  return Colossus::CondCode::COND_FALSE;
  case Colossus::CondCode::COND_FALSE: return Colossus::CondCode::COND_TRUE;
  case Colossus::CondCode::COND_NEG:   return Colossus::CondCode::COND_POS;
  case Colossus::CondCode::COND_POS:   return Colossus::CondCode::COND_NEG;
  case Colossus::CondCode::COND_CLOOP_END_BRANCH:
  case Colossus::CondCode::COND_CLOOP_GUARD_BRANCH:
    break;
  }
  llvm_unreachable("Invalid Colossus::CondCode");
}

MachineBasicBlock *getBranchTarget(MachineInstr *Br) {
  unsigned opc = Br->getOpcode();
  assert(isCondBr(opc) || isUncondBr(opc));
  unsigned idx = isUncondBr(opc) ? 0 : 1;
  return Br->getOperand(idx).getMBB();
}
}

/// Analyze the branching code at the end of MBB, returning true if it cannot
/// be understood (e.g. it's a switch dispatch or isn't implemented for a
/// target).  Upon success, this returns false and returns with the following
/// information in various cases:
///
/// 1. If this block ends with no branches (it just falls through to its succ)
///    just return false, leaving TBB/FBB null.
/// 2. If this block ends with only an unconditional branch, it sets TBB to be
///    the destination block.
/// 3. If this block ends with a conditional branch and it falls through to a
///    successor block, it sets TBB to be the branch destination block and a
///    list of operands that evaluate the condition. These operands can be
///    passed to other TargetInstrInfo methods to create new branches.
/// 4. If this block ends with a conditional branch followed by an
///    unconditional branch, it returns the 'true' destination in TBB, the
///    'false' destination in FBB, and a list of operands that evaluate the
///    condition.  These operands can be passed to other TargetInstrInfo
///    methods to create new branches.
///
/// Note that removeBranch and insertBranch must be implemented to support
/// cases where this method returns success.
///
/// If AllowModify is true, then this routine is allowed to modify the basic
/// block (e.g. delete instructions after the unconditional branch).
bool ColossusInstrInfo::
analyzeBranch(MachineBasicBlock &MBB,
              MachineBasicBlock *&TBB,
              MachineBasicBlock *&FBB,
              SmallVectorImpl<MachineOperand> &Cond,
              bool AllowModify) const {
  LLVM_DEBUG(dbgs() << "Analyzing branches in BB#" << MBB.getNumber() << '\n');
  LLVM_DEBUG(MBB.dump());

  auto pushCondInfo = [&](MachineInstr *Br) {
    unsigned opc = Br->getOpcode();
    assert(isCondBr(opc));
    Colossus::CondCode BrCode = getCondFromBrOpc(opc);
    Cond.push_back(MachineOperand::CreateImm(BrCode));
    Cond.push_back(Br->getOperand(0));

    if (branchHasMetadataOperand(opc)) {
      assert(Br->getNumOperands() == 3);
      auto meta = Br->getOperand(2);
      assert(meta.isImm());
      Cond.push_back(meta);
    }
  };

  MachineInstr *LastBr = nullptr;
  MachineInstr *SecondBr = nullptr;
  MachineBasicBlock::iterator I = MBB.end();
  while (I != MBB.begin()) {
    --I;

    // Skip debug values.
    if (I->isDebugValue()) {
      continue;
    }

    // If we see a non-terminator, we are done.
    if (!isUnpredicatedTerminator(*I)) {
      break;
    }

    if (!I->isBranch()) {
      // Check for a cloop_begin_terminator node followed by an uncond branch
      // in order to encourage sequencing basic blocks such that cloop header
      // falls through to the cloop body block.
      if (LastBr && !SecondBr) {
        if (I->getOpcode() == Colossus::CLOOP_BEGIN_TERMINATOR) {
          if (isUncondBr(LastBr->getOpcode())) {
            TBB = getBranchTarget(LastBr);
            LLVM_DEBUG(dbgs() << "Block ends cloop, unconditional branch.\n");
            return false;
          }
        }
      }

      // Terminator is not a branch. Can't handle this.
      LLVM_DEBUG(dbgs() << "Can't analyze BB#" << MBB.getNumber()
                        << " with non-branch terminator.\n");
      LLVM_DEBUG(I->dump());
      return true;
    }

    // Record the first (last) branch.
    if (!LastBr) {
      LastBr = &*I;
      LLVM_DEBUG(dbgs() << "Got last branch\n");
      continue;
    }

    // Three branches are unexpected.
    if (SecondBr) {
      LLVM_DEBUG(dbgs() << "Can't analyze BB#" << MBB.getNumber()
                        << " with three terminating branches.\n");
      return true;
    }

    // Record the second (penultimate) branch.
    SecondBr = &*I;
    LLVM_DEBUG(dbgs() << "Got penultimate branch\n");
  }

  // Check the three cases.
  if (LastBr && SecondBr) {
    if (isCondBr(SecondBr->getOpcode()) && isUncondBr(LastBr->getOpcode())) {
      // Case 4: block ends with cond br followed by an uncond one.
      TBB = getBranchTarget(SecondBr);
      FBB = getBranchTarget(LastBr);
      pushCondInfo(SecondBr);
      LLVM_DEBUG(dbgs() << "Block ends conditional, unconditional branch.\n");
      return false;
    }
    if (isUncondBr(SecondBr->getOpcode())) {
      // Block ends with two unconditional branches (Case 2).
      TBB = getBranchTarget(SecondBr);
      if (AllowModify) {
        // Delete the second.
        LLVM_DEBUG(dbgs() << "Erasing second unconditional branch.\n");
        LastBr->eraseFromParent();
      }
      return false;
    }
  } else if (LastBr) {
    if (isCondBr(LastBr->getOpcode())) {
      // Case 3: block ends with fall-through conditional branch.
      TBB = getBranchTarget(LastBr);
      pushCondInfo(LastBr);
      LLVM_DEBUG(dbgs() << "Block ends conditional branch.\n");
      return false;
    }
    if (isUncondBr(LastBr->getOpcode())) {
      // Case 2: block ends with an unconditional branch.
      assert(isUncondBr(LastBr->getOpcode()) && "Branch not unconditional");
      TBB = getBranchTarget(LastBr);
      LLVM_DEBUG(dbgs() << "Block ends unconditional branch.\n");
      return false;
    }
  } else {
    // Case 1: block ends with no branches.
    LLVM_DEBUG(dbgs() << "Block ends with no branches.\n");
    return false;
  }

  LLVM_DEBUG(dbgs() << "Could not analyse BB# " << MBB.getNumber() << '\n');
  return true;
}

/// insertBranch - Insert branch code into the end of the specified
/// MachineBasicBlock.  The operands to this method are the same as those
/// returned by AnalyzeBranch.  This is only invoked in cases where
/// AnalyzeBranch returns success. It returns the number of instructions
/// inserted.
///
/// It is also invoked by tail merging to add unconditional branches in
/// cases where AnalyzeBranch doesn't apply because there was no original
/// branch to analyze.  At least this much must be implemented, else tail
/// merging needs to be disabled.
unsigned ColossusInstrInfo::
insertBranch(MachineBasicBlock &MBB,
             MachineBasicBlock *TBB,
             MachineBasicBlock *FBB,
             ArrayRef<MachineOperand> Cond,
             const DebugLoc &DL,
             int *BytesAdded) const {
  LLVM_DEBUG(dbgs() << "Inserting branch(es) in BB#" << MBB.getNumber()
                    << '\n');

  // Shouldn't be a fall through.
  assert(TBB && "InsertBranch must not be told to insert a fallthrough");
  assert(!BytesAdded && "code size not handled");
  assert(Cond.size() <= 3 && "Unexpected number of components");

  auto insertUncondBranch = [&](MachineBasicBlock *dst) {
    unsigned Opcode = Colossus::BR;
    assert(branchHasCoissueOperand(Opcode));
    BuildMI(&MBB, DL, get(Opcode)).addMBB(dst).addImm(0 /* Coissue bit */);
  };

  auto insertCondBranch = [&](MachineBasicBlock *dst) {
    assert(Cond.size() >= 2 && "Too few components for conditional branch");
    unsigned Opcode =
        getBrOpcFromCond(static_cast<Colossus::CondCode>(Cond[0].getImm()));
    auto MIB =
        BuildMI(&MBB, DL, get(Opcode)).addReg(Cond[1].getReg()).addMBB(dst);

    if (branchHasMetadataOperand(Opcode)) {
      assert(Cond.size() == 3 && "Missing metadata component");
      MIB.add(Cond[2]);
    }
    if (branchHasCoissueOperand(Opcode)) {
      MIB.addImm(0 /* Coissue bit */);
    }
  };

  if (!FBB) {
    // One-way branch.
    if (Cond.empty()) {
      insertUncondBranch(TBB);
      LLVM_DEBUG(dbgs() << "Inserted unconditional branch.\n");
    } else {
      insertCondBranch(TBB);
      LLVM_DEBUG(dbgs() << "Inserted conditional branch.\n");
    }
    return 1;
  } else {
    // Two-way conditional branch.
    assert((Cond.size() == 2 || Cond.size() == 3) &&
           "Unexpected number of components");
    insertCondBranch(TBB);
    insertUncondBranch(FBB);
    LLVM_DEBUG(dbgs() << "Inserted two-way conditional branch.\n");
    return 2;
  }
}

/// Remove the branching code at the end of the specific MBB. This is only
/// invoked in cases where AnalyzeBranch returns success. It returns the number
/// of instructions that were removed.
unsigned ColossusInstrInfo::
removeBranch(MachineBasicBlock &MBB, int *BytesRemoved) const {
  assert(!BytesRemoved && "code size not handled");
  LLVM_DEBUG(dbgs() << "Removing branches from BB#" << MBB.getNumber() << '\n');
  MachineBasicBlock::iterator I = MBB.end();
  unsigned Count = 0;
  while (I != MBB.begin()) {
    --I;

    if (I->isDebugValue()) {
      continue;
    }

    // Not a branch.
    if (!isUncondBr(I->getOpcode()) &&
        !isCondBr(I->getOpcode())) {
      break;
    }

    LLVM_DEBUG(dbgs() << "Removed: "; I->dump(); errs() << '\n');
    I->eraseFromParent();
    I = MBB.end();
    ++Count;
  }
  return Count;
}

/// Reverse the branch condition of the specified condition list, returning
/// false on success and true if it cannot be reversed. Condition list should
/// contain the branch code as an immediate and the register condition value.
bool ColossusInstrInfo::
reverseBranchCondition(SmallVectorImpl<MachineOperand> &Cond) const {
  assert(Cond.size() > 1 && "Invalid branch condition list");
  auto cc = static_cast<Colossus::CondCode>(Cond[0].getImm());
  if (!hasOppositeCondCode(cc)) {
    return true;
  }
  assert(Cond.size() == 2 && "Reversible branch cond needs two components");
  Cond[0].setImm(getOppositeCondCode(cc));
  return false;
}

bool ColossusInstrInfo::isSchedulingBoundary(const MachineInstr &MI,
                                             const MachineBasicBlock *MBB,
                                             const MachineFunction &MF) const {
  if (TargetInstrInfo::isSchedulingBoundary(MI, MBB, MF))
    return true;
  return isPut(MI.getOpcode());
}

// Prevent CSE'ing of counted loop instructions.
bool ColossusInstrInfo::canBeCSECandidate(const MachineInstr &MI) const {
  switch (MI.getOpcode()) {
  default:
    return true;
  case Colossus::CLOOP_BEGIN_VALUE:
  case Colossus::CLOOP_BEGIN_TERMINATOR:
  case Colossus::CLOOP_END_VALUE:
  case Colossus::CLOOP_END_BRANCH:
  case Colossus::CLOOP_GUARD_BRANCH:
    return false;
  }
}

namespace {

using CloopInstrIter = Optional<MachineBasicBlock::instr_iterator>;
CloopInstrIter findOpcodeFromTerminator(MachineBasicBlock *BB,
                                        unsigned opcode) {
  auto I = BB->getFirstInstrTerminator();
  if (I == BB->instr_end())
    return {};

  while (true) {
    if (I->getOpcode() == opcode)
      return I;
    if (I == BB->instr_begin())
      break;
    --I;
  }

  return {};
}

struct ColossusLoopInstrs {
  SmallVector<MachineInstr *, 1> LoopGuards; // Loop guard.
  MachineInstr *BeginValue;                  // IV init.
  MachineInstr *BeginTerminator;             // Preheader terminator.
};

bool FindColossusLoopInstrs(ColossusLoopInstrs &CloopInstrs,
                            MachineBasicBlock *LoopBB) {
  MachineBasicBlock *Preheader = *LoopBB->pred_begin();

  // As it loops onto itself, one of its predecessors will be itself.
  if (Preheader == LoopBB)
    Preheader = *std::next(LoopBB->pred_begin());

  if (!Preheader)
    return false;

  auto endBranch = LoopBB->getFirstInstrTerminator();
  if (endBranch == LoopBB->instr_end() ||
      endBranch->getOpcode() != Colossus::CLOOP_END_BRANCH)
    return false;

  CloopInstrIter endVal =
      findOpcodeFromTerminator(LoopBB, Colossus::CLOOP_END_VALUE);
  if (!endVal)
    return false;

  auto beginTerm = Preheader->getFirstInstrTerminator();
  if (beginTerm == Preheader->instr_end() ||
      beginTerm->getOpcode() != Colossus::CLOOP_BEGIN_TERMINATOR)
    return false;
  CloopInstrs.BeginTerminator = &*beginTerm;

  CloopInstrIter beginVal =
      findOpcodeFromTerminator(Preheader, Colossus::CLOOP_BEGIN_VALUE);
  if (!beginVal)
    return false;
  CloopInstrs.BeginValue = &*(*beginVal);

  for (auto Pred : Preheader->predecessors()) {
    CloopInstrIter loopGuard =
        findOpcodeFromTerminator(Pred, Colossus::CLOOP_GUARD_BRANCH);
    if (loopGuard)
      CloopInstrs.LoopGuards.push_back(&*(*loopGuard));
  }

  return true;
}

class ColossusPipelinerLoopInfo : public TargetInstrInfo::PipelinerLoopInfo {
  // The below fields refer to the original loop structure, they are not
  // updated to match the new loop structure.
  int64_t TripCount;
  SmallVector<MachineInstr *, 1> OrigLoopGuards;
  MachineInstr *OrigBeginValue, *OrigBeginTerminator, *SetKernelTripCount{};
  Register PrologueEndValueDstReg{};

public:
  ColossusPipelinerLoopInfo(const ColossusLoopInstrs &CloopInstrs)
      : OrigLoopGuards(CloopInstrs.LoopGuards),
        OrigBeginValue(CloopInstrs.BeginValue),
        OrigBeginTerminator(CloopInstrs.BeginTerminator) {

    TripCount = -1;
    SetKernelTripCount = nullptr;

    // Find the nearest setzi to see if the cloop_begin_value pseudo value is
    // set using an immediate. If not, TripCount is left to -1.
    MachineBasicBlock *Preheader = OrigBeginValue->getParent();
    for (auto I = Preheader->getFirstInstrTerminator();; --I) {
      // Are there more ways of setting imms?
      if (I->getOpcode() == Colossus::SETZI) {
        if (I->getOperand(0).getReg() ==
            OrigBeginValue->getOperand(1).getReg()) {
          TripCount = I->getOperand(1).getImm();
          SetKernelTripCount = &*I;
          break;
        }
      }
      if (I == Preheader->getFirstNonPHI())
        break;
    }
  }

  bool shouldIgnoreForPipelining(const MachineInstr *MI) const override {
    switch (MI->getOpcode()) {
    default:
      return false;
    case Colossus::CLOOP_BEGIN_VALUE:
    case Colossus::CLOOP_BEGIN_TERMINATOR:
    case Colossus::CLOOP_END_VALUE:
    case Colossus::CLOOP_END_BRANCH:
      return true;
    }
  }

  Optional<bool> createTripCountGreaterCondition(
      int TC, MachineBasicBlock &MBB,
      SmallVectorImpl<MachineOperand> &Cond) override {

    MachineInstr *endVal = nullptr;
    for (auto I = MBB.instr_rbegin(); I != MBB.instr_rend(); ++I) {
      if (I->getOpcode() == Colossus::CLOOP_END_VALUE) {
        endVal = &*I;
        break;
      }
    }
    assert(endVal && "No cloop_end_value found in machine pipelined prolog.");

    DebugLoc dl = getDL(MBB, endVal);
    MachineFunction *MF = MBB.getParent();
    const ColossusSubtarget &ST = MF->getSubtarget<ColossusSubtarget>();
    const ColossusInstrInfo *TII = ST.getInstrInfo();
    bool IsInnermostPrologue = false;

    if (!PrologueEndValueDstReg.isValid()) {
      // Set the PrologueEndValueDstReg for the innermost prologue. This will be
      // used by the kernel as initial trip count.
      PrologueEndValueDstReg = endVal->getOperand(0).getReg();
      IsInnermostPrologue = true;
    }

    MachineRegisterInfo &MRI = MF->getRegInfo();
    // Avoid updating TripCount if it is used by several instructions (because
    // other uses could feed into CLOOP_BEGIN_VALUE of other loops) or if
    // PrologueEndValDstReg has been set (meaning we only run this `if` for the
    // innermost prologue).
    if ((TripCount == -1 ||
         !MRI.hasOneUse(SetKernelTripCount->getOperand(0).getReg())) &&
        IsInnermostPrologue) {
      // Add a decrement of the initial CLOOP_BEGIN_VALUE use operand. The
      // function setPreheader() will hook the output of the decrement in the
      // last prologue to the new CLOOP_BEGIN_VALUE and the decrements in all
      // other prologues will be garbage collected as unused. Note that the
      // decrement value does not matter because it is set in
      // adjustTripCount(). The CLOOP_BEGIN_VALUE replaced by the decrement
      // is deleted further below.
      auto LoopCountInitReg = OrigBeginValue->getOperand(1).getReg();
      SetKernelTripCount = BuildMI(MBB, endVal, dl, TII->get(Colossus::ADD_SI),
                                   PrologueEndValueDstReg)
                               .addReg(LoopCountInitReg)
                               .addImm(-1)
                               .addImm(0 /*coissue*/);
    }

    // Treat cases where TripCount <= TC similar to not knowing the TripCount
    // during compilation (i.e. when Tripcount == -1). See the disposed hook for
    // more information.
    if (TripCount == -1 || TripCount <= TC) {
      // Branch over kernel and potential further prologues and corresponding
      // epilogues if all loop iterations have already happened.
      uint32_t uTC = static_cast<uint32_t>(TC);
      unsigned Mat = MRI.createVirtualRegister(&Colossus::MRRegClass);
      unsigned CmpRes = MRI.createVirtualRegister(&Colossus::MRRegClass);
      TII->loadConstant32(MBB, endVal, Mat, uTC);
      endVal->eraseFromParent();
      MachineInstr *cmp = BuildMI(&MBB, dl, TII->get(Colossus::CMPSLT), CmpRes)
                              .addReg(Mat)
                              .addReg(OrigBeginValue->getOperand(0).getReg())
                              .addImm(0 /* coissue */);
      Cond.push_back(MachineOperand::CreateImm(Colossus::CondCode::COND_FALSE));
      Cond.push_back(cmp->getOperand(0));

      return {};
    }

    assert(TripCount > TC &&
           "TripCount must be greater than TC for pipeliner!");
    // Either the trip count can be updated and there is no need for a
    // decrement or it cannot and new decrement was created above. Either way
    // the CLOOP_END_VALUE must go.
    endVal->eraseFromParent();
    return true;
  }

  void setPreheader(MachineBasicBlock *LastPrologue) override {
    // Iterations from the original loop that are handled by prologue(s) and
    // epilogue(s) are not executed inside a loop. The loop kernel therefore
    // becomes the new hardware loop and CLOOP_* pseudos must be rewritten
    // accordingly.

    MachineFunction *MF = LastPrologue->getParent();
    const ColossusSubtarget &ST = MF->getSubtarget<ColossusSubtarget>();
    const ColossusInstrInfo *TII = ST.getInstrInfo();
    MachineRegisterInfo &MRI = MF->getRegInfo();
    MachineBasicBlock *OrigPreheader = OrigBeginTerminator->getParent();

    // First replace all old loop guards by plain BRZ instructions instead
    // since they branch to the prologue(s) instead of the kernel.
    DebugLoc dl;
    for (size_t i = 0; i < OrigLoopGuards.size(); ++i) {
      auto OrigLoopGuard = OrigLoopGuards.pop_back_val();
      auto OrigLoopGuardMBB = OrigLoopGuard->getParent();
      dl = getDL(*OrigLoopGuardMBB, OrigLoopGuard);
      BuildMI(*OrigLoopGuardMBB, OrigLoopGuard, dl, TII->get(Colossus::BRZ))
          .add(OrigLoopGuard->getOperand(0))
          .addMBB(OrigLoopGuard->getOperand(1).getMBB())
          .addImm(0 /*coissue*/);
      OrigLoopGuard->eraseFromParent();
    }

    // Remove CLOOP_BEGIN_VALUE and CLOOP_BEGIN_TERMINATOR from the old
    // preheader and update uses of the CLOOP_BEGIN_VALUE output to use its
    // input operand.
    auto LoopCountInitReg = OrigBeginValue->getOperand(1).getReg();
    auto BeginValueDefReg = OrigBeginValue->getOperand(0).getReg();
    DebugLoc OrigBeginValueDL = getDL(*OrigPreheader, OrigBeginValue);
    auto OrigBeginValueMD = OrigBeginValue->getOperand(2).getImm();
    auto OrigBeginTerminatorMD = OrigBeginTerminator->getOperand(1).getImm();
    OrigBeginTerminator->eraseFromParent();
    OrigBeginTerminator = nullptr;
    OrigBeginValue->eraseFromParent();
    OrigBeginValue = nullptr;
    MRI.replaceRegWith(BeginValueDefReg, LoopCountInitReg);

    // If the prologue has a conditional branch to skip the kernel, create a
    // new preheader for the kernel and replace the conditional branch by a
    // hardware loop guard.
    auto PrologueFirstTerminator = LastPrologue->getFirstInstrTerminator();
    // If there is no conditional branch, we can use the last prologue as new
    // preheader.
    auto NewPreheader = LastPrologue;
    MachineBasicBlock::iterator PreheaderTerminator = PrologueFirstTerminator;
    if (LastPrologue->succ_size() > 1) {
      BuildMI(*LastPrologue, PrologueFirstTerminator, dl,
              TII->get(Colossus::CLOOP_GUARD_BRANCH))
          .add(PrologueFirstTerminator->getOperand(0))
          .addMBB(PrologueFirstTerminator->getOperand(1).getMBB())
          .addImm(0 /*coissue*/);
      auto PrologueLastTerminator = std::next(PrologueFirstTerminator);
      PrologueFirstTerminator->eraseFromParent();

      NewPreheader = MF->CreateMachineBasicBlock(LastPrologue->getBasicBlock());

      // Find kernel MBB. If the conditional branch is followed by an
      // unconditional branch, that is its target. Otherwise it is where the
      // prologue falls through to.
      auto KernelMBB = LastPrologue->getFallThrough();
      if (PrologueLastTerminator != LastPrologue->instr_end()) {
        assert(PrologueLastTerminator->isUnconditionalBranch());
        KernelMBB = PrologueLastTerminator->getOperand(0).getMBB();
      }

      // Insert the preheader just before the kernel so that it falls through
      // to it without the need for a branch. Rewire the last prologue and the
      // kernel accordingly.
      MF->insert(KernelMBB->getIterator(), NewPreheader);
      NewPreheader->addSuccessor(KernelMBB, BranchProbability::getOne());
      PreheaderTerminator = NewPreheader->instr_end();
      if (PrologueLastTerminator != LastPrologue->instr_end()) {
        PrologueLastTerminator->getOperand(0).setMBB(NewPreheader);
      }
      KernelMBB->replacePhiUsesWith(LastPrologue, NewPreheader);
      LastPrologue->replaceSuccessor(KernelMBB, NewPreheader);
    }

    // Create CLOOP_BEGIN_VALUE and CLOOP_BEGIN_TERMINATOR in the new preheader
    // and set the IV initial value to the result of the last decrement in the
    // case of a dynamic trip count or to the result of the setzi otherwise.
    // The CLOOP_BEGIN_VALUE pseudo uses the same destination register as the
    // deleted CLOOP_END_VALUE to avoid updating the uses in the loop kernel.
    auto KernelTripCountReg = SetKernelTripCount->getOperand(0).getReg();
    if (KernelTripCountReg == PrologueEndValueDstReg) {
      KernelTripCountReg = MRI.createVirtualRegister(&Colossus::MRRegClass);
      SetKernelTripCount->getOperand(0).setReg(KernelTripCountReg);
    }
    BuildMI(*NewPreheader, PreheaderTerminator, OrigBeginValueDL,
            TII->get(Colossus::CLOOP_BEGIN_VALUE), PrologueEndValueDstReg)
        .addReg(KernelTripCountReg)
        .addImm(OrigBeginValueMD);
    BuildMI(*NewPreheader, PreheaderTerminator, OrigBeginValueDL,
            TII->get(Colossus::CLOOP_BEGIN_TERMINATOR))
        .addReg(PrologueEndValueDstReg)
        .addImm(OrigBeginTerminatorMD);
  }

  void adjustTripCount(int TripCountAdjust) override {
    assert(SetKernelTripCount && "No insn setting trip count for hwloop");
    if (SetKernelTripCount->getOpcode() == Colossus::SETZI) {
      // Trip count is set statically so we update it to match the kernel trip
      // count.
      int64_t TripCountNew =
          SetKernelTripCount->getOperand(1).getImm() + TripCountAdjust;
      SetKernelTripCount->getOperand(1).setImm(TripCountNew);
    } else
      // Trip count is not set statically so there is an ADD_SI instruction in
      // the last prologue to do a cumulative update of the trip count to
      // account for all the prologues and epilogues whose immediate we set
      // below.
      SetKernelTripCount->getOperand(2).setImm(TripCountAdjust);
  }

  // Normally called when the kernel BB can be removed due to a statically known
  // IV that can be covered by the prolog and epilog BBs. But as it's rare for
  // Colossus' 2 issue slots to ever result in this case, the
  // createTripCountGreaterCondition is made to explicitly not return false and
  // we depend on dynamic (runtime) analysis.
  void disposed() override {}
};

} // namespace

std::unique_ptr<TargetInstrInfo::PipelinerLoopInfo>
ColossusInstrInfo::analyzeLoopForPipelining(MachineBasicBlock *LoopBB) const {
  // We really "analyze" only hardware loops right now.
  ColossusLoopInstrs CloopInstrs;

  if (FindColossusLoopInstrs(CloopInstrs, LoopBB))
    return std::make_unique<ColossusPipelinerLoopInfo>(CloopInstrs);

  return nullptr;
}

/// Load a 32-bit constant into a register.
void ColossusInstrInfo::
loadConstant32(MachineBasicBlock &MBB,
               MachineBasicBlock::iterator MI,
               unsigned Reg,
               uint32_t Value,
               bool IsRegDead) const {
  Register R(Reg);
  assert(Colossus::ARRegClass.contains(Reg) == false);
  assert(Colossus::MRRegClass.contains(Reg) == true || R.isVirtual());

  DebugLoc dl = getDL(MBB, MI);

  auto const &setziInsn = get(Colossus::SETZI);
  auto const &orizInsn = get(Colossus::OR_IZ);
  const uint32_t Hi12 = Value & 0xFFF00000;
  const uint32_t Lo20 = Value & 0x000FFFFF;

  if (isUInt<20>(Value)) {
    BuildMI(MBB, MI, dl, setziInsn, Reg)
      .addImm(Value)
      .addImm(0 /* Coissue bit */);
    return;
  }

  if (Lo20 == 0) {
    BuildMI(MBB, MI, dl, orizInsn, Reg)
      .addReg(Colossus::MZERO)
      .addImm(Hi12)
      .addImm(0 /* Coissue bit */);
    return;
  }

  auto asSigned = int32_t{};
  std::memcpy(&asSigned, &Value, 4);
  if (isInt<16>(asSigned)) {
    BuildMI(MBB, MI, dl, get(Colossus::ADD_SI), Reg)
      .addReg(Colossus::MZERO)
      .addImm(asSigned)
      .addImm(0 /* Coissue bit */);
    return;
  }

  // Load with setzi (low 20 bits).
  BuildMI(MBB, MI, dl, setziInsn, Reg)
    .addImm(Lo20)
    .addImm(0 /* Coissue bit */);

  // and or(iz) (high 12 bits).
  BuildMI(MBB, MI, dl, orizInsn, Reg)
    .addReg(Reg, getDeadRegState(IsRegDead))
    .addImm(Hi12)
    .addImm(0 /* Coissue bit */);
}

MachineMemOperand *ColossusInstrInfo::
getFrameIndexMMO(MachineBasicBlock &MBB, int FrameIndex,
                 MachineMemOperand::Flags flags) const {
  MachineFunction *MF = MBB.getParent();
  const MachineFrameInfo &MFI = MF->getFrameInfo();
  MachineMemOperand *MMO = MF->getMachineMemOperand(
      MachinePointerInfo::getFixedStack(*MF, FrameIndex), flags,
      MFI.getObjectSize(FrameIndex), MFI.getObjectAlign(FrameIndex));

  return MMO;
}
