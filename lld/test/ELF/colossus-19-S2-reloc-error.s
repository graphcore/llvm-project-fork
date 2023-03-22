// RUN: llvm-mc -filetype=obj -triple=colossus-graphcore--elf %s -o %t
// RUN: not ld.lld %t -o %t2 -defsym=foo=0x200000

// CHECK: relocation R_COLOSSUS_19_S2 out of range: 524288 is not in [0, 524287]; references foo

.globl _start
_start:
bri foo
