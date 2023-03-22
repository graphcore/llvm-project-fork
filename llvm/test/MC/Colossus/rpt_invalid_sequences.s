# RUN: not llvm-mc -mattr=+ipu1 -triple colossus-graphcore-elf  -assemble -show-encoding -o %t -filetype=obj  < %s 2>&1 | FileCheck %s

// Test to make sure we report errors on invalid `rpt` sequences.
// Note do not modify this without also updating the rpt_invalid_sequences_allow.s file
.align 8
InvalidRepeatWithSoloInsn:
  { rpt 10, ((2f - 1f) / 8) - 1	; fnop }
1:
  { add $m1, $m0, 5		; fnop }

  // CHECK: error: repeat blocks must only contain instruction bundles
  nop
  nop
2:

.align 8
InvalidRepeatMisalignedBody:
  // CHECK: error: code following rpt instruction is misaligned. Please bundle the rpt instruction with fnop to ensure the rpt body is 8 byte aligned
  rpt 10, ((2f - 1f) / 8) - 1
1:
  { add $m1, $m0, 5		; fnop }
2:

.align 8
InvalidRepeatMisalignedBodyRptBundleWithFnop:
nop
// CHECK: error: code following rpt instruction is misaligned. Please add a nop before the bundled rpt instruction to ensure the rpt body is 8 byte aligned
  { rpt 10, ((2f - 1f) / 8) - 1 ; fnop }
1:
  { add $m1, $m0, 5   ; fnop }
2:

.align 8
InvalidRepeatWithControlInsn:
  { rpt 10, ((2f - 1f) / 8) - 1	; fnop }
1:
  // CHECK: error: repeat blocks cannot contain control instructions
  { bri 0x40000 ; fnop }
2:

.align 8
InvalidRepeatWithSystemInsn:
  { rpt 10, ((2f - 1f) / 8) - 1	; fnop }
1:
  // CHECK: error: repeat blocks cannot contain system instructions
  { get $m1, 0		; fnop }
2:

.align 8
InvalidRepeatWithSoloInsnImmLength:
  { rpt 10, 1 ; fnop }
1:
  { add $m1, $m0, 5   ; fnop }

  // CHECK: error: repeat blocks must only contain instruction bundles
  nop
  nop
2:

.align 8
InvalidRepeatMisalignedBodyImmLength:
  // CHECK: error: code following rpt instruction is misaligned. Please bundle the rpt instruction with fnop to ensure the rpt body is 8 byte aligned
  rpt 10, 0
1:
  { add $m1, $m0, 5   ; fnop }
2:

.align 8
InvalidRepeatMisalignedBodyImmLengthRptBundleWithFnop:
  // CHECK: error: code following rpt instruction is misaligned. Please add a nop before the bundled rpt instruction to ensure the rpt body is 8 byte aligned
  nop
  { rpt 10, 0 ; fnop }
1:
  { add $m1, $m0, 5   ; fnop }
2:

.align 8
InvalidRepeatWithControlInsnImmLength:
  { rpt 10, 0 ; fnop }
1:
  // CHECK: error: repeat blocks cannot contain control instructions
  { bri 0x40000 ; fnop }
2:

.align 8
InvalidRepeatWithSystemInsnImmLength:
  { rpt 10, 0 ; fnop }
1:
  // CHECK: error: repeat blocks cannot contain system instructions
  { get $m1, 0    ; fnop }
2:

.align 8