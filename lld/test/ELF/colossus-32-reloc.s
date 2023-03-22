#REQUIRES: colossus
// RUN: llvm-mc -filetype=obj -triple=colossus-graphcore--elf %s -o %t
// RUN: ld.lld %t -o %t2 -defsym=foo=0
// RUN: llvm-objdump -s %t2 | FileCheck %s

// CHECK: Contents of section .data:
// CHECK-NEXT: {{[a-zA-Z0-9_]+}} 00000000 01000000 45000000 78563412

.globl _start
_start:
.data
.long foo
.long foo + 1
.long foo + 0x45
.long foo + 0x12345678
