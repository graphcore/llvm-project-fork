# RUN: not llvm-mc -filetype=obj -triple=colossus-graphcore--elf %s -o %t < %s 2>&1 | FileCheck %s

# CHECK: error: invalid operand for instruction
# CHECK-NEXT: cmpult $m0, $m0, -1
cmpult $m0, $m0, -1


# CHECK: error: invalid operand for instruction
# CHECK-NEXT: cmpult $m0, $m0, 65535 + 1
cmpult $m0, $m0, 65535 + 1

# CHECK: error: invalid operand for instruction
# CHECK-NEXT: cmpult $m0, $m0, 65536
cmpult $m0, $m0, 65536
