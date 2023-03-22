// RUN: llvm-mc -filetype=obj -triple=colossus-graphcore--elf %s -o %t
// RUN: llvm-objdump -d -r %t | FileCheck %s

// CHECK:                         00 01 00 2a cmpult $m0, $m0, 256
cmpult $m0, $m0, 256

// CHECK:                         00 00 00 2a cmpult $m0, $m0, 0
cmpult $m0, $m0, 0

// CHECK:                        63 00 00 2a cmpult $m0, $m0, 99
cmpult $m0, $m0, 1 + 100 - 2

// CHECK:                         ff ff 00 2a cmpult $m0, $m0, 65535
cmpult $m0, $m0, 65535


// CHECK:                         00 00 00 2a cmpult $m0, $m0, 0
// CHECK-NEXT: {{[0-9a-f]+}}:  R_COLOSSUS_16 foo
cmpult $m0, $m0, foo
