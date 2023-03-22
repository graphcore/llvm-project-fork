#REQUIRES: colossus
// RUN: llvm-mc -filetype=obj -triple=colossus-graphcore--elf %s -o %t
// RUN: ld.lld %t -o %t2 -defsym=foo=0x40000
// RUN: llvm-objdump -d %t2 | FileCheck %s


// CHECK:                         00 00 00 14 run $m0, $m0, 0
// CHECK-NEXT: {{[a-zA-Z0-9_]+}}: 01 00 00 14 run $m0, $m0, 1
// CHECK-NEXT: {{[a-zA-Z0-9_]+}}: 00 00 01 14 run $m0, $m0, 4096
// CHECK-NEXT: {{[a-zA-Z0-9_]+}}: 34 02 01 14 run $m0, $m0, 4660
// CHECK-NEXT: {{[a-zA-Z0-9_]+}}: f0 00 0f 14 run $m0, $m0, 61680
// CHECK-NEXT: {{[a-zA-Z0-9_]+}}: ff 0f 0f 14 run $m0, $m0, 65535

.globl foo

.globl _start
_start:
.supervisor
run $m0, $m0, foo + 0
run $m0, $m0, foo + 0x4
run $m0, $m0, foo + 0x4000
run $m0, $m0, foo + 0x48d0
run $m0, $m0, foo + 0x3c3c0
run $m0, $m0, foo + 0x3fffc
