// ===-- st32_align1_impl.h ------------------------------------------------===//
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

#ifndef _COLOSSUS_ST32_ALIGN1_IMPL_H
#define _COLOSSUS_ST32_ALIGN1_IMPL_H

#ifndef TARGET
#error "TARGET not defined"
#endif

#include "colossus_memory_builtins.h"
#include "colossus_types.h"

// The C version is slower than asm as tail call optimisation
// isn't yet implemented. The roll8l/roll8r via inline asm also
// argues for writing this in assembly instead. See also T6911

__attribute__((target(TARGET)))
static inline unsigned roll8l(unsigned src0, unsigned src1) {
  // res = ($mSrc1 << 8) | ($mSrc0 >> 24);
  unsigned res;
  asm("roll8l %0, %1, %2" : "=r"(res) : "r"(src0), "r"(src1) :);
  return res;
}

__attribute__((target(TARGET)))
static inline unsigned roll8r(unsigned src0, unsigned src1) {
  // res = = ($mSrc1 << 24) | ($mSrc0 >> 8);
  unsigned res;
  asm("roll8r %0, %1, %2" : "=r"(res) : "r"(src0), "r"(src1) :);
  return res;
}

__attribute__((target(TARGET)))
static inline void st32_align1_unaligned(unsigned address, unsigned value) {
  uint2 *aligned_address = (uint2 *)(address & ~0x3);
  uint2 m = *aligned_address;
  if (address & 0x2) {
    m[0] = roll8l(m[0], m[0]);
    m[0] = roll8r(m[0], value);
    m[1] = roll8l(m[1], m[1]);
    m[1] = roll8r(value, m[1]);
  } else {
    m[0] = roll8r(m[0], m[0]);
    m[0] = roll8l(m[0], value);
    m[1] = roll8r(m[1], m[1]);
    m[1] = roll8l(value, m[1]);
  }
  *aligned_address = m;
}

#undef TARGET

#endif // _COLOSSUS_ST32_ALIGN1_IMPL_H
