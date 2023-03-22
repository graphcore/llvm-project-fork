// RUN: %clang_builtins %s %librt -o %t && %run %t
// REQUIRES: ipu-target-arch
// REQUIRES: librt_has_st16f

//===-- st16f_test.c - Test store builtins---------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file tests __st16f for the compiler_rt library.
//
//===----------------------------------------------------------------------===//

#include "colossus_memory_builtins.h"
#include <stdio.h>
#include <string.h>

#define N (32)

char mem[N] __attribute__((aligned(2)));

typedef union {
  half h;
  short s;
} U;

int main() {
  memset(mem, 0, N);
  // Populate the array using __st16.
  for (unsigned i = 0; i < N; i += 2) {
    U val;
    val.s = (i + 1) << 8 | i;
    __st16f((unsigned) &mem[i], val.h);
  }
  // Check each byte.
  for (unsigned i = 0; i < N; ++i) {
    if (mem[i] != i) {
      // Fail.
      return 1;
    }
  }
  return 0;
}

