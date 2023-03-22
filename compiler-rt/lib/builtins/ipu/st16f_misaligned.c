// ===-- st16f_misaligned.c - Implements __st16f_misaligned ---------------===//
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

#include "colossus_memory_builtins.h"
#include "colossus_types.h"

void __st16f_misaligned(unsigned address, __fp16 fvalue) {
  unsigned short value;
  __builtin_memcpy(&value, &fvalue, 2);
  unsigned byteIndex = address & 0x3;
  unsigned wordAddr = address & ~0x3;
  if (byteIndex == 3) {
    uint2 loadValue;
    __builtin_memcpy(&loadValue, (const char *) wordAddr, sizeof(loadValue));

    loadValue[0] &= 0x00FFFFFF;
    loadValue[0] |= (value & 0xFF) << 24;
    loadValue[1] &= 0xFFFFFF00;
    loadValue[1] |= (value >> 8) & 0xFF;

    __builtin_memcpy((char *) wordAddr, &loadValue, sizeof(loadValue));
  } else if (byteIndex == 1) {
    unsigned loadValue;
    __builtin_memcpy(&loadValue, (const char *) wordAddr, sizeof(unsigned));

    loadValue &= ~0xFFFF00;
    loadValue |= (value & 0xFFFF) << 8;

    __builtin_memcpy((char *) wordAddr, &loadValue, sizeof(unsigned));
  } else {
    // Aligned byte indices 0 and 2.
    __st16f(address, fvalue);
  }
}
