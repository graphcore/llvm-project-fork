#RUN: llvm-mc -mattr=+ipu1 -filetype=obj -triple colossus-graphcore-elf -assemble %s -o - \
#RUN:   | llvm-objdump --no-show-raw-insn --triple colossus-graphcore-elf --disassemble - \
#RUN:   | FileCheck %s

// Test to make sure we can disable the errors on invalid `rpt` sequences.
// Note do not modify this without also updating the rpt_invalid_sequences.s file
// Checking for errors are a bit redundant here but it helps match with
// rpt_invalid_sequences.s. Some assembly checks have been added to check that
// bundled rpt instructions have not been relaxed when they might have been if
// .allow_optimizations had been specified
.allow_invalid_repeat

.align 8
InvalidRepeatWithSoloInsn:
  { rpt 10, ((2f - 1f) / 8) - 1	; fnop }
1:
  { add $m1, $m0, 5		; fnop }

  // CHECK-NOT: error: repeat blocks must only contain instruction bundles
  nop
  nop
2:

.align 8
InvalidRepeatMisalignedBody:
  // CHECK-NOT: code following repeat instruction is misaligned
  rpt 10, ((2f - 1f) / 8) - 1
1:
  { add $m1, $m0, 5		; fnop }

.align 8
InvalidRepeatMisalignedBodyRptBundleWithFnop:
nop
// CHECK-NOT: error: code following repeat instruction is misaligned
  // CHECK: <InvalidRepeatMisalignedBodyRptBundleWithFnop>:
  // CHECK-NEXT: nop
  // CHECK-NEXT: {
  // CHECK-NEXT: rpt 10, 0
  // CHECK-NEXT: fnop
  // CHECK-NEXT: }
  { rpt 10, ((2f - 1f) / 8) - 1 ; fnop }
1:
  { add $m1, $m0, 5   ; fnop }
2:

.align 8
InvalidRepeatWithControlInsn:
  { rpt 10, ((2f - 1f) / 8) - 1	; fnop }
1:
  // CHECK-NOT: error: repeat blocks cannot contain control instructions
  { bri 0x40000 ; fnop }
2:

.align 8
InvalidRepeatWithSystemInsn:
  { rpt 10, ((2f - 1f) / 8) - 1	; fnop }
1:
  // CHECK-NOT: error: repeat blocks cannot contain system instructions
  { get $m1, 0		; fnop }
2:

.align 8
InvalidRepeatWithSoloInsnImmLength:
  { rpt 10, 1 ; fnop }
1:
  { add $m1, $m0, 5   ; fnop }

  // CHECK-NOT: error: repeat blocks must only contain instruction bundles
  nop
  nop
2:

.align 8
InvalidRepeatMisalignedBodyImmLength:
  // CHECK-NOT: error: code following repeat instruction is misaligned
  rpt 10, 0
1:
  { add $m1, $m0, 5   ; fnop }
2:

.align 8
InvalidRepeatMisalignedBodyImmLengthRptBundleWithFnop:
  // CHECK-NOT:: error: code following repeat instruction is misaligned
  // CHECK: <InvalidRepeatMisalignedBodyImmLengthRptBundleWithFnop>:
  // CHECK-NEXT: nop
  // CHECK-NEXT: {
  // CHECK-NEXT: rpt 10, 0
  // CHECK-NEXT: fnop
  // CHECK-NEXT: }
  nop
  { rpt 10, 0 ; fnop }
1:
  { add $m1, $m0, 5   ; fnop }
2:

.align 8
InvalidRepeatWithControlInsnImmLength:
  { rpt 10, 0 ; fnop }
1:
  // CHECK-NOT: error: repeat blocks cannot contain control instructions
  { bri 0x40000 ; fnop }
2:

.align 8
InvalidRepeatWithSystemInsnImmLength:
  { rpt 10, 0 ; fnop }
1:
  // CHECK-NOT: error: repeat blocks cannot contain system instructions
  { get $m1, 0    ; fnop }
2:
