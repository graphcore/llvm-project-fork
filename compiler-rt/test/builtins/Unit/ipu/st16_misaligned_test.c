// RUN: %clang_builtins %s %librt -o %t && %run %t
// REQUIRES: ipu-target-arch
// REQUIRES: librt_has_st16_misaligned

//===-- st16_misaligned_test.c - Test store builtins-----------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file tests __st16_misaligned for the compiler_rt library.
//
//===----------------------------------------------------------------------===//

#include <stdio.h>
#include <string.h>
#include "colossus_memory_builtins.h"

// Enough space to store two 32-bit integers.
#define N (sizeof(unsigned) * 2)

int check(unsigned offset, unsigned first, unsigned second) {
  char mem[N] __attribute__((aligned(2)));

  // Fill the memory with a value that acts like a stack smash sentinel.
  memset(&mem[0], 0xab, N);

  // Write data to the offset.
  __st16_misaligned((unsigned) &mem[offset], 0x1234);

  // Check the first 32-bit number is correct.
  unsigned value = *((unsigned *) &mem[0]);
  if (value != first) {
    printstr("First word, expected ");
    printhex(first);
    printstr(", got ");
    printhexln(value);

    return 1;
  }

  // Check the second 32-bit number is correct.
  value = *((unsigned *) &mem[N/2]);
  if (value != second) {
    printstr("Second word, expected ");
    printhex(second);
    printstr(", got ");
    printhexln(value);

    return 1;
  }

  return 0;
}

int main() {
  if (check(0, 0xabab1234, 0xabababab) != 0) return 1;
  if (check(1, 0xab1234ab, 0xabababab) != 0) return 1;
  if (check(2, 0x1234abab, 0xabababab) != 0) return 1;
  if (check(3, 0x34ababab, 0xababab12) != 0) return 1;
  if (check(4, 0xabababab, 0xabab1234) != 0) return 1;

  return 0;
}

