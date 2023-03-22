//===-- umodsi3_worker.c - Implement __umodsi3 ----------------------------===//
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
// This file implements __umodsi3 for the compiler_rt library.
//
//===----------------------------------------------------------------------===//

#include "../int_lib.h"

// Returns: a % b

// Defined in udivsi3_worker.c
__attribute__((target("worker")))
su_int __udivsi3(su_int n, su_int d);

// Defined in udivsi3_supervisor.c
__attribute__((target("supervisor")))
su_int __supervisor_udivsi3(su_int n, su_int d);

__attribute__((target("worker")))
su_int __umodsi3(su_int a, su_int b) {
  return a - __udivsi3(a, b) * b;
}

__attribute__((target("supervisor")))
su_int __supervisor_umodsi3(su_int a, su_int b) {
  return a - __supervisor_udivsi3(a, b) * b;
}
