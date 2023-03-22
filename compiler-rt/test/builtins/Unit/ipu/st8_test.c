// RUN: %clang_builtins %s %librt -o %t && %run %t
// REQUIRES: ipu-target-arch
// REQUIRES: librt_has_st8

//===-- st8_test.c - Test store builtins-----------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file tests __st8 for the compiler_rt library.
//
//===----------------------------------------------------------------------===//

#include <string.h>
#include "colossus_memory_builtins.h"

#define N (32)

char mem[N];

int main() {
  memset(mem, 0, N);
  // Populate the array using __st8.
  for (unsigned i = 0; i < N; ++i) {
    __st8((unsigned) &mem[i], i);
  }
  // Check each value.
  for (unsigned i = 0; i < N; ++i) {
    if (mem[i] != i) {
      // Fail.
      return 1;
    }
  }
  return 0;
}

