//===------ ColossusMachineFunctionInfo.h - Colossus machine fn info ------===//
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
// This file provides Colossus-specific per-machine-function information.
//
// Stack layout:
//                                                         Higher memory address
//                                +------------------+
//                                | Incoming args    |
//                                | (caller writes)  |
// Current frame:                 +==================+ <- BP
//                                | BP spill area.   |
//                                | 8 bytes in size  | <- BP spill (at BP - 8) 
//                                +------------------+
//                                | Frame alignment  | <- unknown size
//                                +------------------+
//                                | Local objects    |
//                                | & spills incl.   | <- FP spill (at FP + x)
//                                | FP spill slot    |
//                                +------------------+ <- FP
//                                | Variably-sized   |
//                                | local objects    |
//                                +------------------+
//                                | Outgoing args    |
//                                | (current writes) |
//                                +==================+ <- SP
//                                ...
//                                                          Stack grows down vvv
//                                                          Lower memory address
//
// The stack is 64-bit aligned on entry to the function.
// FP and BP can often be elided, in which case the layout is:
//
//                                +------------------+
//                                | Incoming args    |
//                                | (caller writes)  |
//                                +==================+
//                                | Locals & spills  |
//                                +------------------+
//                                | Outgoing args    |
//                                | (current writes) |
//                                +==================+ <- FP == SP
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_COLOSSUS_COLOSSUSMACHINEFUNCTIONINFO_H
#define LLVM_LIB_TARGET_COLOSSUS_COLOSSUSMACHINEFUNCTIONINFO_H

#include "llvm/CodeGen/MachineFrameInfo.h"
#include "llvm/CodeGen/MachineFunction.h"
#include "llvm/ADT/SmallVector.h"

namespace llvm {

// Forward declarations
class Function;

inline DebugLoc getDL(MachineBasicBlock &MBB,
                      MachineBasicBlock::iterator MI) {
  if (MI != MBB.end() && !MI->isDebugValue()) {
    return MI->getDebugLoc();
  } else {
    return DebugLoc();
  }
}

/// This class is derived from MachineFunctionInfo to provide Colossus
/// target-specific information for each MachineFunction.
class ColossusFunctionInfo : public MachineFunctionInfo {

  virtual void anchor();

  bool HasCall;

  bool FPSpillSlotSet;
  int FPSpillSlot;

  int VarArgsFrameIndex;

  // The scratch slot is used to perform M-to-A register file moves.
  unsigned ScratchSize;
  int ScratchFrameIndex;

  // This is the (negative) offset in bytes from the beginning of the stack
  // frame to the next available word of local storage. This is where callee
  // spill slots are allocated from.
  int64_t LocalAreaOffset;

public:
  ColossusFunctionInfo() :
    HasCall(false),
    FPSpillSlotSet(false),
    ScratchSize(0),
    LocalAreaOffset(0) {}

  explicit ColossusFunctionInfo(MachineFunction &MF) : ColossusFunctionInfo() {}

  ~ColossusFunctionInfo() {}

  void setHasCall() { HasCall = true; }
  bool hasCall() const { return HasCall; }

  void createFPSpillSlot(MachineFunction &MF);
  void createBPSpillSlot(MachineFunction &MF);
  void createScratchSlot(MachineFunction &MF, const TargetRegisterClass *RC);

  bool hasFPSpillSlot() const {
    return FPSpillSlotSet;
  }

  int getFPSpillSlot() const {
    assert(FPSpillSlotSet && "FP spill slot not set");
    return FPSpillSlot;
  }

  int getScratchSlot() const {
    assert(ScratchSize != 0 && "Reg file move slot not set");
    return ScratchFrameIndex;
  }

  void setLocalAreaOffset(int64_t Offset) {
    LocalAreaOffset = Offset;
  }

  int64_t getLocalAreaOffset() const {
    return LocalAreaOffset;
  }

  void setVarArgsFrameIndex(int FrameIndex) {
    VarArgsFrameIndex = FrameIndex;
  }

  int getVarArgsFrameIndex() const {
    return VarArgsFrameIndex;
  }
};
} // End llvm namespace

#endif
