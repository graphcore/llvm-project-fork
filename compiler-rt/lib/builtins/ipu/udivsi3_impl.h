//===-- udivsi3_impl.h ----------------------------------------------------===//
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
// This file implements core logic of udivsi3 routines for the compiler_rt
// library.
//
//===----------------------------------------------------------------------===//

#ifndef _COLOSSUS_UDIVSI3_IMPL_H
#define _COLOSSUS_UDIVSI3_IMPL_H

#ifndef TARGET
#error "TARGET not defined"
#endif

#include "../int_lib.h"

// Returns: a / b
// Translated from Figure 3-40 of The PowerPC Compiler Writer's Guide
__attribute__((target(TARGET)))
static inline su_int udivsi3_impl(su_int n, su_int d) {
  const unsigned n_uword_bits = sizeof(su_int) * CHAR_BIT;
  su_int q;
  su_int r;
  unsigned sr;
  if (d == 0)
    return 0;
  if (n == 0)
    return 0;
  sr = __builtin_clz(d) - __builtin_clz(n);
  if (sr > n_uword_bits - 1)
    return 0;
  if (sr == n_uword_bits - 1)
    return n;
  ++sr;
  q = n << (n_uword_bits - sr);
  r = n >> sr;
  su_int carry = 0;
  for (; sr > 0; --sr) {
    r = (r << 1) | (q >> (n_uword_bits - 1));
    q = (q << 1) | carry;
    const si_int s = (si_int)(d - r - 1) >> (n_uword_bits - 1);
    carry = s & 1;
    r -= d & s;
  }
  q = (q << 1) | carry;
  return q;
}

#undef TARGET

#endif // _COLOSSUS_UDIVSI3_IMPL_H
