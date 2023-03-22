//===----- ColossusMachineFunctionInfo.cpp - Colossus machine fn info -----===//
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
// This file contains state and logic for its manangment that is associated with
// functions.
//
//===----------------------------------------------------------------------===//

#include "ColossusMachineFunctionInfo.h"
#include "ColossusInstrInfo.h"
#include "llvm/CodeGen/TargetSubtargetInfo.h"
#include "llvm/IR/Function.h"
#include "llvm/Support/raw_ostream.h"

using namespace llvm;

// Pin the vtable to this file.
void ColossusFunctionInfo::anchor() { }

void ColossusFunctionInfo::createFPSpillSlot(MachineFunction &MF) {
  assert(!FPSpillSlotSet && "FP spill slot already set");
  MachineFrameInfo &MFI = MF.getFrameInfo();
  const TargetRegisterClass *RC = &Colossus::MRRegClass;
  const TargetRegisterInfo *RegInfo = MF.getSubtarget().getRegisterInfo();
  FPSpillSlot = MFI.CreateSpillStackObject(RegInfo->getSpillSize(*RC),
                                           RegInfo->getSpillAlign(*RC));
  FPSpillSlotSet = true;
}

void ColossusFunctionInfo::
createScratchSlot(MachineFunction &MF, const TargetRegisterClass *RC) {
  MachineFrameInfo &MFI = MF.getFrameInfo();
  const TargetRegisterInfo *RegInfo = MF.getSubtarget().getRegisterInfo();
  if (RegInfo->getSpillSize(*RC) <= ScratchSize) {
    // There is already a stack object of the correct size allocated.
    return;
  }
  if (ScratchSize > 0 && RegInfo->getSpillSize(*RC) > ScratchSize) {
    // If there is a stack object but it is too small, resize it.
    MFI.setObjectSize(ScratchFrameIndex, RegInfo->getSpillSize(*RC));
    ScratchSize = RegInfo->getSpillSize(*RC);
    return;
  }
  // Otherwise, create a new stack object.
  ScratchFrameIndex = MFI.CreateStackObject(RegInfo->getSpillSize(*RC),
                                            RegInfo->getSpillAlign(*RC), false);
  ScratchSize = RegInfo->getSpillSize(*RC);
}
