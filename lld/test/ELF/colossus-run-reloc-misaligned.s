#REQUIRES: colossus
// RUN: llvm-mc -filetype=obj -triple=colossus-graphcore--elf %s -o %t
// RUN: not ld.lld %t -o %t2 -defsym=foo=0x40000 2>&1 | FileCheck %s
// CHECK: {{.*}}: improper alignment for relocation {{R_COLOSSUS_RUN}}: 0x40003 is not aligned to 4 bytes

.globl foo

.globl _start
_start:
.supervisor
run $m0, $m0, foo + 0x3

