//===-- ColossusCoissueUtil.h - Utilities for coissue -----------*- C++ -*-===//
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

#include "MCTargetDesc/ColossusMCInstrInfo.h"
#include "llvm/CodeGen/MachineBasicBlock.h"
#include "llvm/CodeGen/MachineFunction.h"

namespace llvm {
namespace Colossus {

// Two instructions can be coissued when:
// (TSFlags >> 25) & 1 is true on both
// The two instructions are on different lanes
// There is no overlap in destination registers
// The M side is first, or they can be swapped without semantic change

class CoissueUtil {
  std::unique_ptr<MCInstrInfo> MII;
  int getLaneWithSigil(MachineInstr *) const;

public:
  CoissueUtil();
  bool isControl(MachineInstr *) const;
  bool isSystem(MachineInstr *) const;
  bool canCoissue(MachineInstr *) const;

  bool canBundleWithNextInstr(MachineFunction::iterator,
                              MachineBasicBlock::instr_iterator) const;

  MachineBasicBlock::instr_iterator
      findNextNonMetaInstr(MachineFunction::iterator MFI,
                           MachineBasicBlock::instr_iterator first) const;

  MachineBasicBlock::instr_iterator
  findNextNonMetaInstr(MachineBasicBlock::instr_iterator first,
                       MachineBasicBlock::instr_iterator last) const;

  MachineBasicBlock::instr_iterator
      bundleWithNop(MachineFunction::iterator,
                    MachineBasicBlock::instr_iterator) const;

  MachineBasicBlock::instr_iterator
      bundleWithNextInstr(MachineFunction::iterator,
                          MachineBasicBlock::instr_iterator) const;

  Optional<MachineBasicBlock::instr_iterator>
      queryNextInstrToBundle(MachineFunction::iterator MFI,
                             MachineBasicBlock::instr_iterator first) const;

  Optional<MachineBasicBlock::instr_iterator>
      queryNextInstrToBundle(MachineBasicBlock::instr_iterator first,
                             MachineBasicBlock::instr_iterator last) const;
};

} // namespace Colossus
} // namespace llvm
