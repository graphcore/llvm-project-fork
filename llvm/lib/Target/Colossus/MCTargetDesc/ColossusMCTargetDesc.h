//===-- ColossusMCTargetDesc.h - Colossus Target Descriptions ---*- C++ -*-===//
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
// This file provides Colossus specific target descriptions.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_COLOSSUS_MCTARGETDESC_COLOSSUSMCTARGETDESC_H
#define LLVM_LIB_TARGET_COLOSSUS_MCTARGETDESC_COLOSSUSMCTARGETDESC_H

#include <memory>

namespace llvm {
class MCAsmBackend;
class MCCodeEmitter;
class MCContext;
class MCInstrInfo;
class MCObjectTargetWriter;
class MCRegisterInfo;
class MCSubtargetInfo;
class MCTargetOptions;
class StringRef;
class Target;
class raw_ostream;

MCCodeEmitter *createColossusMCCodeEmitter(const MCInstrInfo &MCII,
                                           MCContext &Ctx);
MCAsmBackend *createColossusMCAsmBackend(const Target &T,
                                         const MCSubtargetInfo &STI,
                                         const MCRegisterInfo &MRI,
                                         const MCTargetOptions &Options);

std::unique_ptr <MCObjectTargetWriter> createColossusMCObjectWriter();

} // End llvm namespace

// Defines symbolic names for Colossus registers.  This defines a mapping from
// register name to register number.
//
#define GET_REGINFO_ENUM
#include "ColossusGenRegisterInfo.inc"

// Defines symbolic names for the Colossus instructions.
//
#define GET_INSTRINFO_ENUM
#include "ColossusGenInstrInfo.inc"

#define GET_SUBTARGETINFO_ENUM
#include "ColossusGenSubtargetInfo.inc"

#endif
