// RUN: %clang_builtins %s %librt -o %t && %run %t
// REQUIRES: ipu-target-arch
// REQUIRES: librt_has_st8
// REQUIRES: librt_has_st16
// REQUIRES: librt_has_st16_misaligned
// REQUIRES: librt_has_st32_align1
// REQUIRES: librt_has_st32_align2
// REQUIRES: librt_has_st16f
// REQUIRES: librt_has_st16f_misaligned
// REQUIRES: librt_has_st32f_align1
// REQUIRES: librt_has_st32f_align2

//===-- memory_builtins_test.c - Test store builtins-----------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file tests __st8, __st16, __st16_misaligned, __st32_align1,
// __st32_align2, __st16f, __st16f_misaligned, __st32f_align1 and __st32f_align2
// for the compiler_rt library.
//
//===----------------------------------------------------------------------===//

#include <assert.h>
#include <string.h>
#include <stdio.h>
#include "colossus_memory_builtins.h"

// Enough for a single word store and a word sentinel either side
alignas(8) char mem[16];
alignas(8) const char ref[16] = "abcdefghijklmnop";

static void setup(void) {
  // Avoid using compiler generated stores to test the
  // compiler generated stores
  unsigned src;
  unsigned dst;
  asm volatile("ld64 $a0:1, $m15, %0, 0\n\t"
               "st64 $a0:1, $m15, %1, 0\n\t"
               "ld64 $a0:1, $m15, %0, 1\n\t"
               "st64 $a0:1, $m15, %1, 1"
               :
               : "r"(&ref[0]), "r"(&mem[0])
               : "$a0:1", "memory");
}

static unsigned at(unsigned offset) {
  char *p = &mem[offset];
  unsigned res;
  memcpy(&res, &p, 4);
  return res;
}

static int check(const char *func, unsigned offset, const char *expect) {
  int match = memcmp(mem, expect, sizeof(ref)) == 0;
  if (!match) {
    printf("Fail from store to offset %u in %s\n", offset, func);
    printf("expect ?= got\n");
    for (unsigned i = 0; i < 16; i++) {
      const char *cmp = (expect[i] == mem[i]) ? "==" : "!=";
      printf("%u: %c %s %c\n", i, expect[i], cmp, mem[i]);
    }
  }
  return !match;
}

static const char *tab8[16] = {
    "-bcdefghijklmnop", "a-cdefghijklmnop", "ab-defghijklmnop",
    "abc-efghijklmnop", "abcd-fghijklmnop", "abcde-ghijklmnop",
    "abcdef-hijklmnop", "abcdefg-ijklmnop", "abcdefgh-jklmnop",
    "abcdefghi-klmnop", "abcdefghij-lmnop", "abcdefghijk-mnop",
    "abcdefghijkl-nop", "abcdefghijklm-op", "abcdefghijklmn-p",
    "abcdefghijklmno-",
};

int test_st8(void) {
  int rc = 0;
  char v = '-';
  for (unsigned o = 4; o < 12; o++) {
    setup();
    __st8(at(o), v);
    rc |= check(__func__, o, tab8[o]);
  }
  assert(rc == 0);
  return rc;
}

static const char *tab16[15] = {
    "!-cdefghijklmnop", "a!-defghijklmnop", "ab!-efghijklmnop",
    "abc!-fghijklmnop", "abcd!-ghijklmnop", "abcde!-hijklmnop",
    "abcdef!-ijklmnop", "abcdefg!-jklmnop", "abcdefgh!-klmnop",
    "abcdefghi!-lmnop", "abcdefghij!-mnop", "abcdefghijk!-nop",
    "abcdefghijkl!-op", "abcdefghijklm!-p", "abcdefghijklmn!-",
};

int test_st16_a1(void) {
  int rc = 0;
  short v = 256 * '-' + '!';
  for (unsigned o = 4; o < 12; o++) {
    setup();
    __st16_misaligned(at(o), v);
    rc |= check(__func__, o, tab16[o]);
  }
  assert(rc == 0);
  return rc;
}

int test_st16_a2(void) {
  int rc = 0;
  short v = 256 * '-' + '!';
  for (unsigned o = 4; o < 12; o += 2) {
    setup();
    __st16(at(o), v);
    rc |= check(__func__, o, tab16[o]);
  }
  assert(rc == 0);
  return rc;
}

int test_st16f_a1(void) {
  int rc = 0;
  half v = 0.080139f; // "!-" as a half
  for (unsigned o = 4; o < 12; o++) {
    setup();
    __st16f_misaligned(at(o), v);
    rc |= check(__func__, o, tab16[o]);
  }
  assert(rc == 0);
  return rc;
}

int test_st16f_a2(void) {
  int rc = 0;
  half v = 0.080139f; // "!-" as a half
  for (unsigned o = 4; o < 12; o += 2) {
    setup();
    __st16f(at(o), v);
    rc |= check(__func__, o, tab16[o]);
  }
  assert(rc == 0);
  return rc;
}

// @$!H == 165009.0f == 1210131520
static const char *tab32[13] = {
    "@$!Hefghijklmnop", "a@$!Hfghijklmnop", "ab@$!Hghijklmnop",
    "abc@$!Hhijklmnop", "abcd@$!Hijklmnop", "abcde@$!Hjklmnop",
    "abcdef@$!Hklmnop", "abcdefg@$!Hlmnop", "abcdefgh@$!Hmnop",
    "abcdefghi@$!Hnop", "abcdefghij@$!Hop", "abcdefghijk@$!Hp",
    "abcdefghijkl@$!H",
};

int test_st32_a1(void) {
  int rc = 0;
  unsigned v = 1210131520;
  for (unsigned o = 4; o < 8; o++) {
    setup();
    __st32_align1(at(o), v);
    rc |= check(__func__, o, tab32[o]);
  }
  assert(rc == 0);
  return rc;
}

int test_st32_a2(void) {
  int rc = 0;
  unsigned v = 1210131520;
  for (unsigned o = 4; o < 8; o += 2) {
    setup();
    __st32_align2(at(o), v);
    rc |= check(__func__, o, tab32[o]);
  }
  assert(rc == 0);
  return rc;
}

int test_st32f_a1(void) {
  int rc = 0;
  float v = 165009.0f; // @$!H
  for (unsigned o = 4; o < 8; o++) {
    setup();
    __st32f_align1(at(o), v);
    rc |= check(__func__, o, tab32[o]);
  }
  assert(rc == 0);
  return rc;
}

int test_st32f_a2(void) {
  int rc = 0;
  float v = 165009.0f; // @$!H
  for (unsigned o = 4; o < 8; o += 2) {
    setup();
    assert((at(o) & 0x1) == 0);
    __st32f_align2(at(o), v);
    rc |= check(__func__, o, tab32[o]);
  }
  assert(rc == 0);
  return rc;
}

int main(void) {
  int rc = 0;
  rc |= test_st8();
  rc |= test_st16_a1();
  rc |= test_st16_a2();
  rc |= test_st16f_a1();
  rc |= test_st16f_a2();
  rc |= test_st32_a1();
  rc |= test_st32_a2();
  rc |= test_st32f_a1();
  rc |= test_st32f_a2();
  return rc;
}
