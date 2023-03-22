// ===-- colossus_memory_builtins.h - Store builtins ----------------------===//
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
// This file declares the IPU store builtins defined in the library to allow
// cross calls.
//
// This file is not part of the interface of this library.
//
//===----------------------------------------------------------------------===//

#ifndef _COLOSSUS_MEMORY_BUILTINS_H
#define _COLOSSUS_MEMORY_BUILTINS_H

#include "colossus_types.h"

#define FOREACH_TARGET_DECLARE(RET_TY, FN_NAME, ...)                           \
  __attribute__((target("worker")))                                            \
  RET_TY __##FN_NAME(__VA_ARGS__);                                             \
  __attribute__((target("supervisor")))                                        \
  RET_TY __supervisor_##FN_NAME(__VA_ARGS__)

/**
 * Perform a store of an 8-bit value using read-modify-write 32-bit accesses.
 */
__attribute__((target("both")))
void __st8(unsigned address, unsigned value);

/**
 * Perform a store of a 16-bit value into a 16-bit aligned address using
 * read-modify-write 32-bit accesses. Note that this routine handles the
 * case where the address starts at the first byte of a word.
 */
__attribute__((target("both")))
void __st16(unsigned address, unsigned value);

/**
 * Perform a store of a 16-bit value into a region of memory spanning
 * two words using read-modify-write 32-bit accesses.
 */
FOREACH_TARGET_DECLARE(void, st16_misaligned, unsigned address, unsigned value);
FOREACH_TARGET_DECLARE(void, st32_align1, unsigned address, unsigned value);
FOREACH_TARGET_DECLARE(void, st32_align2, unsigned address, unsigned value);

/// \brief Perform a store of a 16-bit floating-point value into a 16-bit
/// aligned address using read-modify-write 32-bit accesses. Note that this
/// routine handles the case where the address starts at the first byte of a
/// word.
void __st16f(unsigned address, __fp16 value);

/// \brief Perform a store of a 16-bit floating-point value into a region of
/// memory spanning two words using read-modify-write 32-bit accesses.
void __st16f_misaligned(unsigned address, __fp16 value);

void __st32f_align1(unsigned address, float value);
void __st32f_align2(unsigned address, float value);

#endif // _COLOSSUS_MEMORY_BUILTINS_H
