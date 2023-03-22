# RUN: not llvm-mc -triple colossus-graphcore-elf < %s 2> %t
# RUN: FileCheck < %t %s

#CHECK: error: invalid instruction
	foo
#CHECK: error: invalid operand
        add $m16, $m1, $m2
#CHECK: error: too few operands for instruction
        add $m1, $m2
#CHECK: error: invalid operand for instruction
        add $m1, $m2, $m3, $m4
#CHECK: error: invalid operand for instruction
        add 1, 2, 3
#CHECK: error: invalid operand for instruction
        add r1, r2, r3

# ZI imm out of range.
#CHECK: error: invalid operand for instruction
        add $m1, $m2, 4294967296

# ZI imm out of range.
#CHECK: error: invalid operand for instruction
        add $m1, $m2, -4294967296
