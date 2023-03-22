# RUN: not llvm-mc -triple colossus-graphcore-elf < %s 2> %t
# RUN: FileCheck < %t %s

# Invalid high register number.
# CHECK: error: invalid operand for instruction
	ld64 $a0:x, $m0, 0

# Invalid register range.
# CHECK: error: invalid operand for instruction
  ld64 $a0:5, $m0, 0

# Invalid register class.
# CHECK: error: invalid operand for instruction
  ld2x64pace $a0:1, $m4:7, $m0:1+=, $m4, 0x10
