#REQUIRES: colossus
// RUN: llvm-mc -filetype=obj -triple=colossus-graphcore--elf %s -o %t
// RUN: ld.lld %t -o %t2 -defsym=foo=0
// RUN: llvm-objdump -d %t2 | FileCheck %s


// CHECK: 					      00 00 00 19 setzi $m0, 0
// CHECK-NEXT: {{[a-zA-Z0-9_]+}}: 00 20 04 19 setzi $m0, 270336
// CHECK-NEXT: {{[a-zA-Z0-9_]+}}: ff ff 0f 19 setzi $m0, 1048575

.globl foo

.globl _start
_start:
setzi $m0, foo + 0
setzi $m0, foo + 0x42000
setzi $m0, foo + 0xFFFFF

