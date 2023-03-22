# RUN: not llvm-mc -triple colossus-graphcore-elf < %s 2> %t
# RUN: FileCheck < %t %s

# CHECK: invalid operand for instruction
# CHECK-NEXT: sub $m0, $m0, 32768
sub $m0, $m0, 32768

# CHECK: error: immediate is out of range
# CHECK-NEXT: sub $m0, $m0, -32768
sub $m0, $m0, -32768

