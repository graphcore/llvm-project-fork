# RUN: llvm-mc -mattr=+ipu1 -triple colossus-graphcore-elf -o %t -filetype=obj  < %s 2>&1 | FileCheck -allow-empty %s
# RUN: not llvm-mc -mattr=+ipu1 -triple colossus-graphcore-elf -mattr=+supervisor -o %t -filetype=obj  < %s 2>&1 >/dev/null | FileCheck -allow-empty %s -check-prefix=CHECK-SUPERVISOR

// Test to make sure we dont issue erroneous errors for valid rpt sequences.

ValidRepeat:
  // CHECK-SUPERVISOR: error: instruction requires: Worker mode
  { rpt 10, ((2f - 1f) / 8) - 1	; fnop }

1:
  .align 8
  { add $m1, $m0, 5		; fnop }

2:

ValidRepeatImmediate:
  // CHECK-SUPERVISOR: error: instruction requires: Worker mode
  { rpt 10, 0 ; fnop }

1:
  { add $m1, $m0, 5   ; fnop }

2:

ValidRepeatIsNotInBundle:
  // CHECK-SUPERVISOR: error: instruction requires: Worker mode
 fnop
 rpt 10, 0
1:
  { add $m1, $m0, 5   ; fnop }
2:

ValidRepeatWithSoloInsnAfterwards:
  // CHECK-SUPERVISOR: error: instruction requires: Worker mode
  { rpt 10, ((2f - 1f) / 8) - 1	; fnop }

1:
  { add $m1, $m0, 5		; fnop }

  // CHECK-NOT: error: repeat blocks must only contain instruction bundles
2:
  nop
  nop

ValidRepeatWithControlInsnAfterwards:
  // CHECK-SUPERVISOR: error: instruction requires: Worker mode
  { rpt 10, ((2f - 1f) / 8) - 1	; fnop }

1:
  { add $m1, $m0, 5   ; fnop }
2:
  // CHECK-NOT: error: repeat blocks cannot contain control instructions
  { bri 0x40000 ; fnop }

ValidRepeatWithSystemInsnAfterwards:
  // CHECK-SUPERVISOR: error: instruction requires: Worker mode
  { rpt 10, ((2f - 1f) / 8) - 1	; fnop }

1:
  { add $m1, $m0, 5   ; fnop }
2:
  // CHECK-NOT error: repeat blocks cannot contain system instructions
  { get $m1, 0    ; fnop }
