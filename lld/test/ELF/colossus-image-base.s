#REQUIRES: colossus
// RUN: llvm-mc -filetype=obj -triple=colossus-graphcore--elf %s -o %t
// RUN: ld.lld %t -mllvm --mcpu=ipu1 -o %t3 -defsym=foo=0x40000
// RUN: llvm-objdump -d %t3 | FileCheck %s
// RUN: ld.lld %t -mllvm --mcpu=ipu2 -o %t4 -defsym=foo=0x4c000
// RUN: llvm-objdump -d %t4 | FileCheck %s

// Test that we obtain the right image base for each IPU by checking the
// result of applying a relocation to R_COLOSSUS_RUN, which produces the same
// offset for every case as `foo` matches the IPU image base.
// CHECK:                          00 00 00 14 run $m0, $m0, 0

.globl foo

.globl _start
_start:
.supervisor
run $m0, $m0, foo + 0
