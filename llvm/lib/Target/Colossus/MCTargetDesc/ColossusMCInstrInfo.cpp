//===------- ColossusMCInstrInfo.cpp - Colossus sub-class of MCInst -------===//
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
// This class extends MCInstrInfo to allow Colossus specific MCInstr queries
//
//===----------------------------------------------------------------------===//

#include "ColossusMCInstrInfo.h"

#include "Colossus.h"
#include "ColossusTargetInstr.h"

namespace llvm {
  // These match the TSFlags bits defined by EncodedI in
  // ColossusInstrFormats.td
  namespace EncodedIFlags {
    enum : uint64_t {
      LaneNumber         = 1 << 22,
      ControlInstruction = 1 << 23,
      SystemInstruction  = 1 << 24,
      CanCoIssue         = 1 << 25,
    };
  }

bool ColossusMCInstrInfo::isCoIssue(MCInst &Instr, uint32_t Insn) {

  // If we have the instruction encoding then use the top bit.
  if (Insn) {
    return (Insn >> 31) & 1;
  }

  if (Instr.getNumOperands() == 0)
    return false;

  MCOperand &CoIssueOp = Instr.getOperand(Instr.getNumOperands() - 1);
  assert(CoIssueOp.isImm() && "expected final insn operand to be coissue bit");
  return CoIssueOp.getImm();
}

bool ColossusMCInstrInfo::canCoIssue(const MCInstrInfo &MII, unsigned opcode) {
  uint64_t TSFlags = MII.get(opcode).TSFlags;
  return (TSFlags & EncodedIFlags::CanCoIssue) != 0;
}

void ColossusMCInstrInfo::SetCoIssue(MCInst &Instr, int Set) {
  assert(Instr.getNumOperands() > 0 &&
         "expect insn to have > 0 operands when setting coissue");

  MCOperand &CoIssueOp = Instr.getOperand(Instr.getNumOperands()-1);
  assert(CoIssueOp.isImm() && "expected final insn operand to be coissue bit");
  CoIssueOp.setImm(Set);
}

unsigned ColossusMCInstrInfo::getLane(const MCInstrInfo &MII, unsigned opcode) {
  uint64_t TSFlags = MII.get(opcode).TSFlags;
  return (TSFlags & EncodedIFlags::LaneNumber) != 0;
}

bool ColossusMCInstrInfo::isControl(const MCInstrInfo &MII, unsigned opcode) {
  uint64_t TSFlags = MII.get(opcode).TSFlags;
  return (TSFlags & EncodedIFlags::ControlInstruction) != 0;
}

bool ColossusMCInstrInfo::isSystem(const MCInstrInfo &MII, unsigned opcode) {
  uint64_t TSFlags = MII.get(opcode).TSFlags;
  return (TSFlags & EncodedIFlags::SystemInstruction) != 0;
}

bool ColossusMCInstrInfo::isRepeat(const MCInst &Inst) {
  auto Opcode = Inst.getOpcode();
  if (Opcode == TargetOpcode::BUNDLE) {
    Opcode = Inst.getOperand(0).getInst()->getOpcode();
  }
  return isRPT(Opcode);
}

bool ColossusMCInstrInfo::isFnop(const MCSubtargetInfo &STI, const MCInst &Inst) {
  if (Inst.getOpcode() != Colossus::SETZI_A)
    return false;
  return (Inst.getOperand(0).getReg() == Colossus::A13);
}

bool ColossusMCInstrInfo::isBarrier(const MCInst &Inst) {
  return Inst.getOpcode() == Colossus::MEM_BARRIER;
}

ColossusMCInstrInfo::OperandModifier
ColossusMCInstrInfo::getOperandModifier(const MCInstrInfo &MII,
                                        const MCInst &Instr, unsigned OpNo) {
  const int bitsPerOperandEncoding = 3;
  uint64_t TSFlags = MII.get(Instr.getOpcode()).TSFlags;
  unsigned OperandPostIncFlags = (TSFlags >> (OpNo * bitsPerOperandEncoding))
                                 & ((1 << bitsPerOperandEncoding) - 1);

  return static_cast<ColossusMCInstrInfo::OperandModifier>(OperandPostIncFlags);
}
}
