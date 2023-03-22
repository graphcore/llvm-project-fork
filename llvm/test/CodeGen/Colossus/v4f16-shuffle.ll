; RUN: llc < %s -mtriple=colossus -colossus-coissue=false -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -mtriple=colossus -colossus-coissue=false -mattr=+ipu2 | FileCheck %s


; Select %a
; CHECK-LABEL: test_shuffle_select_a:
; CHECK-NOT:   or
; CHECK-NOT:   mov
define <4 x half> @test_shuffle_select_a(<4 x half> %a, <4 x half> %b) {
  %1 = shufflevector <4 x half> %a, <4 x half> %b,
                     <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  ret <4 x half> %1
}

; Select %b
; CHECK-LABEL: test_shuffle_select_b:
; CHECK:       mov $a0:1, $a2:3
; CHECK-NEXT:  br $m10
define <4 x half> @test_shuffle_select_b(<4 x half> %a, <4 x half> %b) {
  %1 = shufflevector <4 x half> %a, <4 x half> %b,
                     <4 x i32> <i32 4, i32 5, i32 6, i32 7>
  ret <4 x half> %1
}

; Pick [3, 2] [1, 0]
; CHECK-LABEL: test_shuffle_select_regs_a:
; CHECK-DAG:   mov $a2, $a1
; CHECK-DAG:   mov $a3, $a0
; CHECK-NEXT:  mov $a0:1, $a2:3
; CHECK-NEXT:  br $m10
define <4 x half> @test_shuffle_select_regs_a(<4 x half> %a, <4 x half> %b) {
  %1 = shufflevector <4 x half> %a, <4 x half> %b,
                     <4 x i32> <i32 2, i32 3, i32 0, i32 1>
  ret <4 x half> %1
}

; Pick [7, 6] [5, 4]
; CHECK-LABEL: test_shuffle_select_regs_b:
; CHECK:       mov
; CHECK-NEXT:  mov
; CHECK-NEXT:  br $m10
define <4 x half> @test_shuffle_select_regs_b(<4 x half> %a, <4 x half> %b) {
  %1 = shufflevector <4 x half> %a, <4 x half> %b,
                     <4 x i32> <i32 6, i32 7, i32 4, i32 5>
  ret <4 x half> %1
}

; Pick [0, 1] [2, 3]
; CHECK-LABEL: test_shuffle_swaps:
; CHECK-DAG:   swap16 $a0, $a0
; CHECK-DAG:   swap16 $a1, $a1
; CHECK-NEXT:  br $m10
define <4 x half> @test_shuffle_swaps(<4 x half> %a, <4 x half> %b) {
  %1 = shufflevector <4 x half> %a, <4 x half> %b,
                     <4 x i32> <i32 1, i32 0, i32 3, i32 2>
  ret <4 x half> %1
}

; Pick [2, 0] [0, 2]
; CHECK-LABEL: test_shuffle_lows:
; CHECK:       sort4x16lo
; CHECK-NEXT:  swap16
; CHECK-NEXT:  br $m10
define <4 x half> @test_shuffle_lows(<4 x half> %a, <4 x half> %b) {
  %1 = shufflevector <4 x half> %a, <4 x half> %b,
                     <4 x i32> <i32 2, i32 0, i32 0, i32 2>
  ret <4 x half> %1
}

; Pick [0, 0] [2, 2]
; CHECK-LABEL: test_shuffle_lows_dup:
; CHECK:       sort4x16lo
; CHECK-NEXT:  sort4x16hi
; CHECK-NEXT:  br $m10
define <4 x half> @test_shuffle_lows_dup(<4 x half> %a, <4 x half> %b) {
  %1 = shufflevector <4 x half> %a, <4 x half> %b,
                     <4 x i32> <i32 0, i32 0, i32 3, i32 3>
  ret <4 x half> %1
}

; Pick [3, 1] [1, 3]
; CHECK-LABEL: test_shuffle_highs:
; CHECK:       sort4x16hi
; CHECK-NEXT:  swap16
; CHECK-NEXT:  br $m10
define <4 x half> @test_shuffle_highs(<4 x half> %a, <4 x half> %b) {
  %1 = shufflevector <4 x half> %a, <4 x half> %b,
                     <4 x i32> <i32 3, i32 1, i32 1, i32 3>
  ret <4 x half> %1
}

; Pick [1, 1] [3, 3]
; CHECK-LABEL: test_shuffle_highs_dup:
; CHECK:       sort4x16hi
; CHECK-NEXT:  sort4x16hi
; CHECK-NEXT:  br $m10
define <4 x half> @test_shuffle_highs_dup(<4 x half> %a, <4 x half> %b) {
  %1 = shufflevector <4 x half> %a, <4 x half> %b,
                     <4 x i32> <i32 1, i32 1, i32 3, i32 3>
  ret <4 x half> %1
}

; Pick [2, 1] [3, 0]
; CHECK-LABEL: test_shuffle_inners:
; CHECK:       roll16
; CHECK-NEXT:  roll16
; CHECK-NEXT:  mov
; CHECK-NEXT:  br $m10
define <4 x half> @test_shuffle_inners(<4 x half> %a, <4 x half> %b) {
  %1 = shufflevector <4 x half> %a, <4 x half> %b,
                     <4 x i32> <i32 1, i32 2, i32 3, i32 0>
  ret <4 x half> %1
}

; Pick [3, 0] [1, 2]
; CHECK-LABEL: test_shuffle_outers:
; CHECK:       roll16
; CHECK-NEXT:  swap16
; CHECK-NEXT:  roll16
; CHECK-NEXT:  swap16
; CHECK-NEXT:  mov
; CHECK-NEXT:  br $m10
define <4 x half> @test_shuffle_outers(<4 x half> %a, <4 x half> %b) {
  %1 = shufflevector <4 x half> %a, <4 x half> %b,
                     <4 x i32> <i32 2, i32 1, i32 0, i32 3>
  ret <4 x half> %1
}

; CHECK-LABEL: test_shuffle_reverse:
; CHECK:       swap16
; CHECK-NEXT:  swap16
; CHECK-NEXT:  mov
; CHECK-NEXT:  br $m10
define <4 x half> @test_shuffle_reverse(<4 x half> %a, <4 x half> %b) {
  %1 = shufflevector <4 x half> %a, <4 x half> %b,
                     <4 x i32> <i32 3, i32 2, i32 1, i32 0>
  ret <4 x half> %1
}

; Shuffling from both input vectors.

; CHECK-LABEL: test_shuffle_both_lows:
; CHECK:       sort4x16lo
; CHECK-NEXT:  swap16
; CHECK-NEXT:  br $m10
define <4 x half> @test_shuffle_both_lows(<4 x half> %a, <4 x half> %b) {
  %1 = shufflevector <4 x half> %a, <4 x half> %b,
                     <4 x i32> <i32 6, i32 0, i32 0, i32 6>
  ret <4 x half> %1
}

; CHECK-LABEL: test_shuffle_both_highs:
; CHECK:       sort4x16hi
; CHECK-NEXT:  swap16
; CHECK-NEXT:  br $m10
define <4 x half> @test_shuffle_both_highs(<4 x half> %a, <4 x half> %b) {
  %1 = shufflevector <4 x half> %a, <4 x half> %b,
                     <4 x i32> <i32 7, i32 1, i32 1, i32 7>
  ret <4 x half> %1
}

; CHECK-LABEL: test_shuffle_both_inners:
; CHECK:       roll16
; CHECK-NEXT:  roll16
; CHECK-NEXT:  br $m10
define <4 x half> @test_shuffle_both_inners(<4 x half> %a, <4 x half> %b) {
  %1 = shufflevector <4 x half> %a, <4 x half> %b,
                     <4 x i32> <i32 1, i32 4, i32 3, i32 6>
  ret <4 x half> %1
}

; CHECK-LABEL: test_shuffle_both_outers:
; CHECK:       roll16
; CHECK-NEXT:  swap16
; CHECK-NEXT:  roll16
; CHECK-NEXT:  swap16
; CHECK-NEXT:  mov
; CHECK-NEXT:  br $m10
define <4 x half> @test_shuffle_both_outers(<4 x half> %a, <4 x half> %b) {
  %1 = shufflevector <4 x half> %a, <4 x half> %b,
                     <4 x i32> <i32 2, i32 5, i32 0, i32 7>
  ret <4 x half> %1
}

; CHECK-LABEL: test_shuffle_both_reverse:
; CHECK:       swap16
; CHECK-NEXT:  swap16
; CHECK-NEXT:  br $m10
define <4 x half> @test_shuffle_both_reverse(<4 x half> %a, <4 x half> %b) {
  %1 = shufflevector <4 x half> %a, <4 x half> %b,
                     <4 x i32> <i32 7, i32 6, i32 5, i32 4>
  ret <4 x half> %1
}

; Undefs

; CHECK-LABEL: test_shuffle_undef:
; CHECK-NOT:   sort4x16
; CHECK-NOT:   or
; CHECK:       br $m10
define <4 x half> @test_shuffle_undef(<4 x half> %a, <4 x half> %b) {
  %1 = shufflevector <4 x half> %a, <4 x half> %b,
                     <4 x i32> <i32 undef, i32 undef, i32 undef, i32 undef>
  ret <4 x half> %1
}

; CHECK-LABEL: test_shuffle_undef_swap:
; CHECK-DAG:   swap16 $a0, $a0
; CHECK-DAG:   swap16 $a1, $a1
; CHECK-NEXT:  br $m10
define <4 x half> @test_shuffle_undef_swap(<4 x half> %a, <4 x half> %b) {
  %1 = shufflevector <4 x half> %a, <4 x half> %b,
                     <4 x i32> <i32 1, i32 undef, i32 undef, i32 2>
  ret <4 x half> %1
}

; These produce the same sequences.

; CHECK-LABEL: test_shuffle_splat:
; CHECK:       sort4x16hi $a0, $a3, $a3
; CHECK-NEXT:  mov $a1, $a0
; CHECK-NEXT:  br $m10
define <4 x half> @test_shuffle_splat(<4 x half> %a, <4 x half> %b) {
  %1 = shufflevector <4 x half> %a, <4 x half> %b,
                     <4 x i32> <i32 7, i32 7, i32 7, i32 7>
  ret <4 x half> %1
}

; CHECK-LABEL: test_shuffle_1undef:
; CHECK:       sort4x16hi $a0, $a3, $a3
; CHECK-NEXT:  mov $a1, $a0
; CHECK-NEXT:  br $m10
define <4 x half> @test_shuffle_1undef(<4 x half> %a, <4 x half> %b) {
  %1 = shufflevector <4 x half> %a, <4 x half> %b,
                     <4 x i32> <i32 undef, i32 7, i32 7, i32 7>
  ret <4 x half> %1
}

; CHECK-LABEL: test_shuffle_3undefs:
; CHECK-NOT:   sort4x16
; CHECK:       mov $a0:1, $a2:3
; CHECK-NEXT:  mov $a0, $a1
; CHECK-NEXT:  br $m10
define <4 x half> @test_shuffle_3undefs(<4 x half> %a, <4 x half> %b) {
  %1 = shufflevector <4 x half> %a, <4 x half> %b,
                     <4 x i32> <i32 undef, i32 7, i32 undef, i32 undef>
  ret <4 x half> %1
}
