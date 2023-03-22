# RUN: llvm-mc -triple colossus-graphcore-elf -assemble %s | FileCheck %s

.set $test_symbol, 50
#CHECK: .set $test_symbol, 50
get $m1, $test_symbol
#CHECK-NEXT: get $m1, 50
get $m1, 12
#CHECK-NEXT:  get $m1, 12
get $m1, $PC
#CHECK-NEXT:  get $m1, 0


