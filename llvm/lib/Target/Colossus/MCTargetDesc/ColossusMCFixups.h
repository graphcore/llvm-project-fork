//===-- ColossusMCFixups.h - Colossus-specific fixup entries ----*- C++ -*-===//
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

#ifndef LLVM_LIB_TARGET_COLOSSUS_MCTARGETDESC_COLOSSUSMCFIXUPS_H
#define LLVM_LIB_TARGET_COLOSSUS_MCTARGETDESC_COLOSSUSMCFIXUPS_H

#include "llvm/MC/MCFixup.h"

namespace llvm {
namespace Colossus {
enum Fixups {
  // These correspond directly to R_COLOSSUS_* relocations.
  fixup_colossus_8 = FirstTargetFixupKind,
  fixup_colossus_16,
  fixup_colossus_20,
  fixup_colossus_21,
  fixup_colossus_18_s2,
  fixup_colossus_19_s2,
  fixup_colossus_run,
  // This fixup does not emit a relocation. It is used by the assembler to
  // fixup misaligned rpt instructions by relaxing them.
  fixup_colossus_rpt,

  // Indicates location of a control/system instruction in a fragment
  fixup_colossus_control,
  fixup_colossus_system,

  // Indicates the location in a fragment of a single instruction
  fixup_colossus_single,

  // Marker
  LastTargetFixupKind,
  NumTargetFixupKinds = LastTargetFixupKind - FirstTargetFixupKind
};
} // end namespace Colossus
} // end namespace llvm

#endif
