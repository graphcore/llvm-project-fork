//===-- ColossusCoissueUtil.cpp - Utilities for coissue -----------------*-===//
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

#include "ColossusCoissueUtil.h"
#include "TargetInfo/ColossusTargetInfo.h"

#include "llvm/CodeGen/MachineInstrBuilder.h"
#include "llvm/CodeGen/TargetInstrInfo.h"
#include "llvm/MC/TargetRegistry.h"

#define DEBUG_TYPE "colossus-coissue-util"

namespace llvm {
namespace Colossus {

namespace {
// This is similar to a local function of the same name in ColossusAsmParser
// The difference is that between MachineOperand and MCOperand
// Refactoring to share a function causes a dependency between the archives
bool OperandsClash(const MCRegisterInfo *MCRI, const MachineOperand &Op1,
                   const MachineOperand &Op2) {
  if (!Op1.isReg() || !Op2.isReg()) {
    return false;
  }
  auto Reg1 = Op1.getReg();
  auto Reg2 = Op2.getReg();

  return Reg1 == Reg2 || MCRI->isSubRegister(Reg1, Reg2) ||
         MCRI->isSubRegister(Reg2, Reg1);
}
} // namespace

CoissueUtil::CoissueUtil() : MII(getTheColossusTarget().createMCInstrInfo()) {}

bool CoissueUtil::isControl(MachineInstr *MI) const {
  return ColossusMCInstrInfo::isControl(*MII, MI->getOpcode());
}

bool CoissueUtil::isSystem(MachineInstr *MI) const {
  return ColossusMCInstrInfo::isSystem(*MII, MI->getOpcode());
}

bool CoissueUtil::canCoissue(MachineInstr *MI) const {
  unsigned Opc = MI->getOpcode();
  return ColossusMCInstrInfo::canCoIssue(*MII, Opc);
}

int CoissueUtil::getLaneWithSigil(MachineInstr *MI) const {
  if (!canCoissue(MI)) {
    return -1;
  }

  unsigned MILane = ColossusMCInstrInfo::getLane(*MII, MI->getOpcode());
  assert(MILane == 0 || MILane == 1);
  return MILane;
}

/// Returns an iterator to next non-meta instruction after `first` or an
/// iterator to the end of the basic block if not found.
MachineBasicBlock::instr_iterator CoissueUtil::findNextNonMetaInstr(
  MachineFunction::iterator MFI,
  MachineBasicBlock::instr_iterator first) const {

  return findNextNonMetaInstr(first, MFI->instr_end());
}

MachineBasicBlock::instr_iterator CoissueUtil::findNextNonMetaInstr(
  MachineBasicBlock::instr_iterator first,
  MachineBasicBlock::instr_iterator last) const {

  assert(first != last);
  ++first;
  while (first != last && first->isMetaInstruction()) {
    ++first;
  }
  return first;
}

Optional<MachineBasicBlock::instr_iterator> CoissueUtil::queryNextInstrToBundle(
  MachineFunction::iterator MFI,
  MachineBasicBlock::instr_iterator first) const {

  return queryNextInstrToBundle(first, MFI->instr_end());
}

Optional<MachineBasicBlock::instr_iterator> CoissueUtil::queryNextInstrToBundle(
  MachineBasicBlock::instr_iterator first,
  MachineBasicBlock::instr_iterator last) const {

  assert(first != last);

  auto second = findNextNonMetaInstr(first, last);
  if (second == last) {
    return {};
  }

  if (first->isBundled() || second->isBundled()) {
    return {};
  }

  auto const lanes = std::array<int, 2u>{
    getLaneWithSigil(&*first),
    getLaneWithSigil(&*second)
  };
  if (lanes[0] == -1 || lanes[1] == -1 || lanes[0] == lanes[1]) {
    return {};
  }

  // Unsafe if both instructions write to the same register.
  // Unsafe if the second instruction reads from any registers that have been
  // modified by the first instruction.
  // This is over-cautious for CALL instructions since several registers will
  // not be modified until the CALL instruction has finished, e.g. function
  // arguments passed in registers.
  {
    auto MF = first->getParent()->getParent();
    auto MCRI = (MCRegisterInfo const *)(MF->getSubtarget().getRegisterInfo());
    auto Instr0OutOps = MII->get(first->getOpcode()).getNumDefs();
    auto Instr1AnyOps = second->getNumOperands();

    for (auto i = 0u; i < Instr0OutOps; ++i) {
      auto & Instr0OutOp = first->getOperand(i);
      for (auto j = 0u; j < Instr1AnyOps; ++j) {
        auto & Instr1AnyOp = second->getOperand(j);
        if (OperandsClash(MCRI, Instr0OutOp, Instr1AnyOp)) {
          LLVM_DEBUG(
            dbgs() << "  Operands clash, cannot dual issue\n";
            first->dump();
            second->dump();
          );
          return {};
        }
      }
    }
  }

  return {second};
}

bool CoissueUtil::canBundleWithNextInstr(
    MachineFunction::iterator MFI,
    MachineBasicBlock::instr_iterator first) const {

  return bool(queryNextInstrToBundle(MFI, first));
}

MachineBasicBlock::instr_iterator CoissueUtil::bundleWithNop(
  MachineFunction::iterator MFI,
  MachineBasicBlock::instr_iterator first) const {

  assert(canCoissue(&*first));
  DebugLoc dl;
  auto &CST = static_cast<const ColossusSubtarget &>(
                                              MFI->getParent()->getSubtarget());
  const TargetInstrInfo &TII = *(CST.getInstrInfo());
  auto buildNop = [&](MachineFunction::iterator MFI,
                      MachineBasicBlock::instr_iterator BBI, int lane) {
    if (lane == 0) {
      return BuildMI(*MFI, BBI, dl, TII.get(Colossus::SETZI), Colossus::M14)
          .addImm(0)
          .addImm(0 /*coissue*/);
    } else {
      return BuildMI(*MFI, BBI, dl, TII.get(Colossus::SETZI_A),
                     Colossus::A13)
          .addImm(0)
          .addImm(0 /*coissue*/);
    }
  };

  int lane = getLaneWithSigil(&*first);
  assert(lane != -1);

  if (lane == 1) {
    // instruction on arf, insert nop before it
    buildNop(MFI, first, 0);
    first--;
  } else {
    // instruction on mrf, insert nop after it
    assert(lane == 0);
    auto tmp = first;
    tmp++;
    buildNop(MFI, tmp, 1);
  }

  assert(canBundleWithNextInstr(MFI, first));
  return bundleWithNextInstr(MFI, first);
}

// Returns an iterator to just after the created bundle. Meta instructions
// between the bundle are moved below the last instruction in the bundle.
MachineBasicBlock::instr_iterator CoissueUtil::bundleWithNextInstr(
  MachineFunction::iterator MFI,
  MachineBasicBlock::instr_iterator first) const {

  assert(canBundleWithNextInstr(MFI, first));

  auto second = findNextNonMetaInstr(MFI, first);
  assert(second != MFI->instr_end() && "Next instr must bundle with previous!");

  int Lane[2] = {
      getLaneWithSigil(&*first),
      getLaneWithSigil(&*second),
  };
  assert((Lane[0] == 0 && Lane[1] == 1) || (Lane[0] == 1 && Lane[1] == 0));

  // Write the M side first, so swap if Lane(Instr[0]) != 0 since M side == 0
  if (Lane[0] != 0) {
    MachineBasicBlock &MBB = *MFI;

    // Move the second instruction before the first one
    auto tmp = &*second;
    MBB.remove(tmp);
    MBB.insert(first, tmp);

    // Restore the iterators
    second = first;
    first = std::prev(first);
  }

  // Set the coissue bit on both instructions
  auto setCoissueBit = [&](MachineBasicBlock::iterator i) {
    MachineOperand &coissue = i->getOperand(i->getNumExplicitOperands() - 1);
    assert(coissue.getImm() == 0);
    coissue.setImm(1);
  };
  setCoissueBit(first);
  setCoissueBit(second);

  // Move meta instructions between the two non meta instructions in the bundle.
  for (auto I = std::next(first); I != second;) {
    assert(I->isMetaInstruction() && "Only meta expected in between!");

    auto MI = &*I;
    ++I;

    MFI->remove(MI);
    MFI->insertAfterBundle(second, MI);
  }

  assert(!std::prev(second)->isMetaInstruction() && "Can't bundle with meta!");
  // Create the bundle.
  second->bundleWithPred();

  LLVM_DEBUG(dbgs() << "bundleTheseInstructions exit:\n"; first->dump();
        second->dump(););

  return std::next(second);
}

} // namespace Colossus
} // namespace llvm
