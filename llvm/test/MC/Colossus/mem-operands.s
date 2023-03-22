# RUN: llvm-mc -triple colossus-graphcore-elf -assemble -filetype=obj %s -o - | \
# RUN:   llvm-objdump -d - | FileCheck %s
# RUN: not llvm-mc -triple colossus-graphcore-elf -assemble -mattr=+supervisor \
# RUN:   < %s 2>&1 >/dev/null | FileCheck %s -check-prefix=CHECK-SUPERVISOR

# Test MEMrr and MEMri operands are encoded and decoded correctly.
# This tests AsmPrinter, MCCodeEmitter, Disassembler and AsmPrinter.

# stm32 (no delta offset operand).

# CHECK:      stm32 $m0, $m0, $m0
stm32 $m0, $m0, $m0

# Base + offset.

# CHECK-NEXT: ld32 $m1, $m2, $m15, $m3
# CHECK-NEXT: ld32 $m1, $m2, $m15, $m4
# CHECK-NEXT: ld32 $m1, $m2, $m15, $m5
ld32 $m1, $m2, $m3
ld32 $m1, $m2, $m4
ld32 $m1, $m2, $m5

# CHECK-NEXT: ld32 $m1, $m2, $m15, 0
# CHECK-NEXT: ld32 $m1, $m2, $m15, 1
# CHECK-NEXT: ld32 $m1, $m2, $m15, 4095
ld32 $m1, $m2, 0
ld32 $m1, $m2, 1
ld32 $m1, $m2, 4095

# CHECK-NEXT: st32 $a1, $m2, $m15, $m3
# CHECK-NEXT: st32 $a1, $m2, $m15, $m4
# CHECK-NEXT: st32 $a1, $m2, $m15, $m5
# CHECK-SUPERVISOR: error: instruction requires: Worker mode
st32 $a1, $m2, $m3
st32 $a1, $m2, $m4
st32 $a1, $m2, $m5

# CHECK-NEXT: st32 $m1, $m2, $m15, 0
# CHECK-NEXT: st32 $m1, $m2, $m15, 1
# CHECK-NEXT: st32 $m1, $m2, $m15, 4095
# CHECK-SUPERVISOR: error: instruction requires: Worker mode
st32 $m1, $m2, 0
st32 $m1, $m2, 1
st32 $m1, $m2, 4095

# Base + delta + offset.

# CHECK-NEXT: ld32 $m1, $m2, $m3, $m4
# CHECK-NEXT: ld32 $m1, $m2, $m4, $m5
# CHECK-NEXT: ld32 $m1, $m2, $m5, $m6
ld32 $m1, $m2, $m3, $m4
ld32 $m1, $m2, $m4, $m5
ld32 $m1, $m2, $m5, $m6

# CHECK-NEXT: ld32 $m1, $m2, $m3, 0
# CHECK-NEXT: ld32 $m1, $m2, $m3, 1
# CHECK-NEXT: ld32 $m1, $m2, $m3, 4095
ld32 $m1, $m2, $m3, 0
ld32 $m1, $m2, $m3, 1
ld32 $m1, $m2, $m3, 4095

# CHECK-NEXT: st32 $a1, $m2, $m3, $m4
# CHECK-NEXT: st32 $a1, $m2, $m4, $m5
# CHECK-NEXT: st32 $a1, $m2, $m5, $m6
# CHECK-SUPERVISOR: error: instruction requires: Worker mode
st32 $a1, $m2, $m3, $m4
st32 $a1, $m2, $m4, $m5
st32 $a1, $m2, $m5, $m6

# CHECK-NEXT: st32 $m1, $m2, $m3, 0
# CHECK-NEXT: st32 $m1, $m2, $m3, 1
# CHECK-NEXT: st32 $m1, $m2, $m3, 4095
# CHECK-SUPERVISOR: error: instruction requires: Worker mode
st32 $m1, $m2, $m3, 0
st32 $m1, $m2, $m3, 1
st32 $m1, $m2, $m3, 4095
