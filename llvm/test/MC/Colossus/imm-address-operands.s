# RUN: not llvm-mc -triple colossus-graphcore-elf < %s 2>&1 \
# RUN: | FileCheck --strict-whitespace %s

# Check that valid and invalid immediate address opoerands are parsed
# correctly.

.quad foo@abs19@s2
.set foo, 524288
# CHECK:           error: invalid operand for instruction
# CHECK-NEXT:      bri foo
# CHECK-NEXT: {{^}}    ^
bri foo

# CHECK:           error: invalid operand
# CHECK-NEXT:      bri $m0
# CHECK-NEXT: {{^}}       ^
bri $m0

# CHECK:            error: invalid operand
call $m0, $m0

# CHECK:           error: invalid operand for instruction
# CHECK-NEXT:      call $m0, (1 << 20)
# CHECK-NEXT: {{^}}          ^
call $m0, (1 << 20)

# CHECK:           error: invalid operand
# CHECK-NEXT:      brz $m0, $m0
# CHECK-NEXT: {{^}}            ^
brz $m0, $m0

# CHECK:           error: invalid operand
# CHECK-NEXT:      bri -4
# CHECK-NEXT: {{^}}    ^
bri -4

# CHECK:           error: invalid operand for instruction
# CHECK-NEXT:      brneg $m0, (1 << 19)
# CHECK-NEXT: {{^}}           ^
brneg $m0, (1 << 19)

# CHECK:           error: invalid operand for instruction
# CHECK-NEXT:      brneg $a0, (1 << 18)
# CHECK-NEXT: {{^}}      ^
brneg $a0, (1 << 18)

# CHECK:           error: invalid operand for instruction
# CHECK-NEXT:      brnz $m0, (1 << 19)
# CHECK-NEXT: {{^}}          ^
brnz $m0, (1 << 19)

# CHECK:           error: invalid operand for instruction
# CHECK-NEXT:      brz $m0, foo
# CHECK-NEXT: {{^}}         ^
brz $m0, foo

# CHECK:           call $m0, 0x200000
call $m0, (1 << 19)

# CHECK:           bri ($abc)
bri $abc

# CHECK:           bri 0x0
bri 0

# CHECK:           bri label
bri label

# CHECK:           bri label

bri label1 - label2

brz $m0, label1 + label2 + label3

label1:
	nop
label2:
	nop
label3:
  nop

# CHECK:      brz $m0, 0x200000
.allow_invalid_operands
brz $m0, (1 << 19)
