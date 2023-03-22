#REQUIRES: colossus
// RUN: llvm-mc -filetype=obj -triple=colossus-graphcore--elf %s -o %t
// RUN: ld.lld %t -o %t2 -defsym=foo=0
// RUN: llvm-objdump -s %t2 | FileCheck %s

// CHECK: Contents of section .data:
// CHECK-NEXT: {{[a-zA-Z0-9_]+}} 000110cc ff

.globl _start
_start:
.data
.byte foo
.byte foo + 1
.byte foo + 0x10
.byte foo + 0xcc
.byte foo + 0xff