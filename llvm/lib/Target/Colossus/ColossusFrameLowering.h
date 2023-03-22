//===-- ColossusFrameLowering.h - Frame info for Colossus -------*- C++ -*-===//
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
// cleanly...
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_COLOSSUS_COLOSSUSFRAMELOWERING_H
#define LLVM_LIB_TARGET_COLOSSUS_COLOSSUSFRAMELOWERING_H

#include "llvm/CodeGen/TargetFrameLowering.h"
#include "llvm/Target/TargetMachine.h"

namespace llvm {
  class ColossusSubtarget;

  class ColossusFrameLowering: public TargetFrameLowering {
  public:
    ColossusFrameLowering(const ColossusSubtarget &CST,
                          unsigned StackAlignment);

    /// Return true if the specified function should have a dedicated frame
    /// pointer register. For most targets this is true only if the function has
    /// variable sized allocas or if frame pointer elimination is disabled.
    bool hasFP(const MachineFunction &MF) const override;

    /// Return true if the specified function should have a dedicated base
    /// pointer register.
    bool hasBP(const MachineFunction &MF) const;

    // Number of bytes above $MWORKER_BASE that can be used for the vertex frame
    uint16_t redZoneSize() const;
    
    /// Returns true if the call frame is included as part of the stack frame.
    bool hasReservedCallFrame(const MachineFunction &MF) const override;

    /// This method is called immediately before the function's frame layout is
    /// finalized.
    virtual void processFunctionBeforeFrameFinalized(
        MachineFunction &MF, RegScavenger *RS = nullptr) const override;

    /// These methods insert prolog and epilog code into the function.
    void emitPrologue(MachineFunction &MF,
                      MachineBasicBlock &MBB) const override;
    void emitEpilogue(MachineFunction &MF,
                      MachineBasicBlock &MBB) const override;

    /// Override spill slot assignment logic. Assign frame slots contiguously to
    /// all CSI entries and ensure the first is 64-bit aligned.
    virtual bool
    assignCalleeSavedSpillSlots(MachineFunction &MF,
                              const TargetRegisterInfo *TRI,
                              std::vector<CalleeSavedInfo> &CSI) const override;

    /// Override default implementation in order to mark stores as frame setup.
    bool
    spillCalleeSavedRegisters(MachineBasicBlock &MBB,
                              MachineBasicBlock::iterator MI,
                              ArrayRef<CalleeSavedInfo> CSI,
                              const TargetRegisterInfo *TRI) const override;

    /// This method is called during prolog/epilog code insertion to eliminate
    /// call frame setup and destroy pseudo instructions (but only if the Target
    /// is using them).  It is responsible for eliminating these instructions,
    /// replacing them with concrete instructions. This method need only be
    /// implemented if using call frame setup/destroy pseudo instructions.
    virtual MachineBasicBlock::iterator
    eliminateCallFramePseudoInstr(MachineFunction &MF,
                                  MachineBasicBlock &MBB,
                                  MachineBasicBlock::iterator I) const override;
  };
}

#endif
