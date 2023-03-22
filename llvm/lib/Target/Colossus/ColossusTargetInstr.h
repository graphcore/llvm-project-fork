//===-- ColossusTargetInstr.h - Colossus DAG Lowering ----------*- C++ -*-===//
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
// This file defines target specific information and operations for
// instructions.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_COLOSSUS_COLOSSUSTARGETINSTR_H
#define LLVM_LIB_TARGET_COLOSSUS_COLOSSUSTARGETINSTR_H

#include "ColossusSubtarget.h"
#include "llvm/ADT/Optional.h"

namespace llvm {


LLVM_ATTRIBUTE_ALWAYS_INLINE
unsigned ColossusST32_ZI(ColossusSubtarget const &) {
  return Colossus::ST32_ZI;
}
LLVM_ATTRIBUTE_ALWAYS_INLINE
unsigned ColossusATOM(ColossusSubtarget const &) { return Colossus::ATOM; }
LLVM_ATTRIBUTE_ALWAYS_INLINE
unsigned ColossusRPT_ZI(ColossusSubtarget const &) { return Colossus::RPT_ZI; }
LLVM_ATTRIBUTE_ALWAYS_INLINE
unsigned ColossusRPT(ColossusSubtarget const &) { return Colossus::RPT; }

LLVM_ATTRIBUTE_ALWAYS_INLINE
bool isPut(unsigned Opcode) {
  switch (Opcode) {
    // Not scheduling barriers but we don't want them to be reordered with
    // anything.
  case Colossus::PUT:
  case Colossus::UPUT:
    return true;
  default:
    return false;
  }
}

LLVM_ATTRIBUTE_ALWAYS_INLINE
bool isRPT(unsigned Opcode) {
  return Opcode == Colossus::RPT || Opcode == Colossus::RPT_ZI;
}

LLVM_ATTRIBUTE_ALWAYS_INLINE
unsigned XshrImmBitWidth(ColossusSubtarget const &, unsigned) { return 12; }

LLVM_ATTRIBUTE_ALWAYS_INLINE
Optional<unsigned> getST64(ColossusSubtarget const &) {
  return llvm::None;
  ;
}

LLVM_ATTRIBUTE_ALWAYS_INLINE
Optional<unsigned> getST128(ColossusSubtarget const &) {
  return llvm::None;
  ;
}

LLVM_ATTRIBUTE_ALWAYS_INLINE
Optional<unsigned> getLD128(ColossusSubtarget const &) { return llvm::None; }

LLVM_ATTRIBUTE_ALWAYS_INLINE
Optional<unsigned> getLD128_ZI(ColossusSubtarget const &) { return llvm::None; }

LLVM_ATTRIBUTE_ALWAYS_INLINE
Optional<unsigned> getLD64(ColossusSubtarget const &) { return llvm::None; }

LLVM_ATTRIBUTE_ALWAYS_INLINE
Optional<unsigned> getLD64_ZI(ColossusSubtarget const &) { return llvm::None; }

LLVM_ATTRIBUTE_ALWAYS_INLINE
Optional<unsigned> getBRZDEC(ColossusSubtarget const &) { return llvm::None; }

LLVM_ATTRIBUTE_ALWAYS_INLINE
Optional<unsigned> getST64M(ColossusSubtarget const &CST) { return llvm::None; }

} // namespace llvm
#endif // LLVM_LIB_TARGET_COLOSSUS_COLOSSUSTARGETINSTR_H