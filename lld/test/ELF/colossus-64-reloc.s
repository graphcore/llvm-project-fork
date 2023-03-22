#REQUIRES: colossus
// RUN: llvm-mc -filetype=obj -triple=colossus-graphcore--elf %s -o %t
// RUN: ld.lld %t -o %t2 -defsym=foo=0
// RUN: llvm-objdump -s %t2 | FileCheck %s

// CHECK: Contents of section .data:
// CHECK-NEXT: {{[a-zA-Z0-9_]+}} 00000000 00000000 01000000 00000000
// CHECK-NEXT: {{[a-zA-Z0-9_]+}} 45000000 00000000 18180100 00000000
// CHECK-NEXT: {{[a-zA-Z0-9_]+}} 78563412 00000000 f0debc9a ffffffff
// CHECK-NEXT: {{[a-zA-Z0-9_]+}} ffffffff ffffffff

.globl _start
_start:
.data
.quad foo
.quad foo + 1
.quad foo + 0x45
.quad foo + 0x11818
.quad foo + 0x12345678
.quad foo + 0x123456789abcdef0
.quad foo + 0xffffffffFFFFFFFF
