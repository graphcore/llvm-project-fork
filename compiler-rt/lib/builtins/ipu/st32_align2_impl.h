// ===-- st32_align2_impl.h -----------------------------------------------===//
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
// This file implements byte-aligned 32-bit store common code.
//
//===----------------------------------------------------------------------===//

#ifndef _COLOSSUS_ST32_ALIGN2_IMPL_H
#define _COLOSSUS_ST32_ALIGN2_IMPL_H

#ifndef TARGET
#error "TARGET not defined"
#endif

#include "colossus_memory_builtins.h"
#include "colossus_types.h"

__attribute__((target(TARGET)))
static inline void st32_align2_impl(unsigned address, unsigned value) {
  unsigned byteIndex = address & 0x3;
  if (byteIndex == 0) {
    unsigned *fa = (unsigned *)address;
    *fa = value;
  } else {
    ushort2 v;
    __builtin_memcpy(&v, &value, 4);

    address -= 2;
    ushort2 *loAddr = (ushort2 *)address;
    ushort2 lo = *loAddr;
    lo[1] = v[0];
    *loAddr = lo;

    ushort2 *hiAddr = (ushort2 *)(address + 4);
    ushort2 hi = *hiAddr;
    hi[0] = v[1];
    *hiAddr = hi;
  }
}

#undef TARGET

#endif // _COLOSSUS_ST32_ALIGN2_IMPL_H
