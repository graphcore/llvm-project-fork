#REQUIRES: colossus
// RUN: llvm-mc -filetype=obj -triple=colossus-graphcore--elf %s -o %t
// RUN: ld.lld %t -o %t2 -defsym=foo=0x7ae40 -defsym=bar=0x512f8
// RUN: llvm-objdump -s --section=.text %t2 | FileCheck %s

// CHECK: 40ae0700 f8120500 
.globl _start
_start:
.long foo@abs@21
.long bar@abs@21
