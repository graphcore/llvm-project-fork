#REQUIRES: colossus
// RUN: llvm-mc -filetype=obj -triple=colossus-graphcore--elf %s -o %t
// RUN: ld.lld %t -o %t2 -defsym=foo=0
// RUN: llvm-objdump -d %t2 | FileCheck %s


// CHECK: 					      00 00 80 40 bri 0x0
// CHECK-NEXT: {{[a-zA-Z0-9_]+}}: 01 00 80 40 bri 0x4
// CHECK-NEXT: {{[a-zA-Z0-9_]+}}: 00 08 81 40 bri 0x42000
// CHECK-NEXT: {{[a-zA-Z0-9_]+}}: fd ff 83 40 bri 0xffff4
// CHECK-NEXT: {{[a-zA-Z0-9_]+}}: ff ff 87 40 bri 0x1ffffc
.globl foo

.globl _start
_start:
bri foo + 0
bri foo + 4
bri foo + 0x42000
bri foo + 0xffff4
bri foo + 0x1ffffc
