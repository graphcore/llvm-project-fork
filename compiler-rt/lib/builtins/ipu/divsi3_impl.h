//===-- divsi3_impl.h -----------------------------------------------------===//
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

#ifndef _COLOSSUS_DIVSI3_IMPL_H
#define _COLOSSUS_DIVSI3_IMPL_H

#ifndef TARGET
#error "TARGET not defined"
#endif

#include "../int_lib.h"

__attribute__((target(TARGET)))
static inline si_int divsi3_impl(si_int a, si_int b) {
  const int bits_in_word_m1 = (int)(sizeof(si_int) * CHAR_BIT) - 1;
  si_int s_a = a >> bits_in_word_m1; // s_a = a < 0 ? -1 : 0
  si_int s_b = b >> bits_in_word_m1; // s_b = b < 0 ? -1 : 0

  su_int a_u = (su_int)(a ^ s_a) + (-s_a); // negate if s_a == -1
  su_int b_u = (su_int)(b ^ s_b) + (-s_b); // negate if s_b == -1
  s_a ^= s_b;                        // sign of quotient
  //
  // On CPUs without unsigned hardware division support,
  //  this calls __udivsi3 (notice the cast to su_int).
  // On CPUs with unsigned hardware division support,
  //  this uses the unsigned division instruction.
  //
  return (a_u / b_u ^ s_a) + (-s_a); // negate if s_a == -1
}

#endif // _COLOSSUS_DIVSI3_IMPL_H
