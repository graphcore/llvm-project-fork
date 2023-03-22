#REQUIRES: colossus
// RUN: llvm-mc -filetype=obj -triple=colossus-graphcore--elf %s -o %t
// RUN: ld.lld %t -o %t2 -defsym=foo=0
// RUN: llvm-objdump -s %t2 | FileCheck %s

// CHECK: Contents of section .data:
// CHECK-NEXT: {{[a-zA-Z0-9_]+}} 00000100 45003412 ffff

.globl _start
_start:
.data
.half foo
.half foo + 1
.half foo + 0x45
.half foo + 0x1234
.half foo + 0xffff