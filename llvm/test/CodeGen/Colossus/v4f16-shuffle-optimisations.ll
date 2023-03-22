; RUN: llc < %s -march=colossus -colossus-coissue=false -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -march=colossus -colossus-coissue=false -mattr=+ipu2 | FileCheck %s


;;; Four v4 identity shuffle generates no code (it does write #kill in the asm)
; CHECK-LABEL: test_shuffle_0123:
; CHECK:       # %bb.0:
; CHECK-NOT:   or
; CHECK-NOT:   swap
; CHECK-NOT:   sort
; CHECK-NOT:   roll
; CHECK-NEXT:  br $m10
define <4 x half> @test_shuffle_0123(<4 x half> %a, <4 x half> %b) {
  %retval = shufflevector <4 x half> %a, <4 x half> %b,
                     <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  ret <4 x half> %retval
}

;;; Whole words of undef generate no code

; CHECK-LABEL: test_shuffle_uuuu:
; CHECK:       # %bb.0:
; CHECK-NEXT:  br $m10
define <4 x half> @test_shuffle_uuuu(<4 x half> %a, <4 x half> %b) {
  %retval = shufflevector <4 x half> %a, <4 x half> %b,
                     <4 x i32> <i32 undef, i32 undef, i32 undef, i32 undef>
  ret <4 x half> %retval
}

; CHECK-LABEL: test_shuffle_10uu:
; CHECK:       # %bb.0:
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  mov $a1, $a0
; CHECK-NEXT:  br $m10
define <4 x half> @test_shuffle_10uu(<4 x half> %a, <4 x half> %b) {
  %retval = shufflevector <4 x half> %a, <4 x half> %b,
                     <4 x i32> <i32 1, i32 0, i32 undef, i32 undef>
  ret <4 x half> %retval
}

; CHECK-LABEL: test_shuffle_uu32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  mov $a1, $a0
; CHECK-NEXT:  br $m10
define <4 x half> @test_shuffle_uu32(<4 x half> %a, <4 x half> %b) {
  %retval = shufflevector <4 x half> %a, <4 x half> %b,
                     <4 x i32> <i32 undef, i32 undef, i32 3, i32 2>
  ret <4 x half> %retval
}

;;; High block is copied from low block when they match
; CHECK-LABEL: test_shuffle_3737:
; CHECK:       # %bb.0:
; CHECK-NEXT:  sort4x16hi $a0, $a1, $a3
; CHECK-NEXT:  mov $a1, $a0
; CHECK-NEXT:  br $m10
define <4 x half> @test_shuffle_3737(<4 x half> %a, <4 x half> %b) {
  %retval = shufflevector <4 x half> %a, <4 x half> %b,
                     <4 x i32> <i32 3, i32 7, i32 3, i32 7>
  ret <4 x half> %retval
}

; CHECK-LABEL: test_shuffle_373u:
; CHECK:       # %bb.0:
; CHECK-NEXT:  sort4x16hi $a0, $a1, $a3
; CHECK-NEXT:  mov $a1, $a0
; CHECK-NEXT:  br $m10
define <4 x half> @test_shuffle_373u(<4 x half> %a, <4 x half> %b) {
  %retval = shufflevector <4 x half> %a, <4 x half> %b,
                     <4 x i32> <i32 3, i32 7, i32 3, i32 7>
  ret <4 x half> %retval
}

; CHECK-LABEL: test_shuffle_37u7:
; CHECK:       # %bb.0:
; CHECK-NEXT:  sort4x16hi $a0, $a1, $a3
; CHECK-NEXT:  mov $a1, $a0
; CHECK-NEXT:  br $m10
define <4 x half> @test_shuffle_37u7(<4 x half> %a, <4 x half> %b) {
  %retval = shufflevector <4 x half> %a, <4 x half> %b,
                     <4 x i32> <i32 3, i32 7, i32 3, i32 7>
  ret <4 x half> %retval
}

; CHECK-LABEL: test_shuffle_3u37:
; CHECK:       # %bb.0:
; CHECK-NEXT:  sort4x16hi $a0, $a1, $a3
; CHECK-NEXT:  mov $a1, $a0
; CHECK-NEXT:  br $m10
define <4 x half> @test_shuffle_3u37(<4 x half> %a, <4 x half> %b) {
  %retval = shufflevector <4 x half> %a, <4 x half> %b,
                     <4 x i32> <i32 3, i32 undef, i32 3, i32 7>
  ret <4 x half> %retval
}

; CHECK-LABEL: test_shuffle_u737:
; CHECK:       # %bb.0:
; CHECK-NEXT:  sort4x16hi $a0, $a1, $a3
; CHECK-NEXT:  mov $a1, $a0
; CHECK-NEXT:  br $m10
define <4 x half> @test_shuffle_u737(<4 x half> %a, <4 x half> %b) {
  %retval = shufflevector <4 x half> %a, <4 x half> %b,
                     <4 x i32> <i32 undef, i32 7, i32 3, i32 7>
  ret <4 x half> %retval
}

;;; High block is swapped from low block when this would match
; CHECK-LABEL: test_shuffle_4224:
; CHECK:       # %bb.0:
; CHECK-NEXT:  sort4x16lo $a0, $a2, $a1
; CHECK-NEXT:  swap16 $a1, $a0
; CHECK-NEXT:  br $m10
define <4 x half> @test_shuffle_4224(<4 x half> %a, <4 x half> %b) {
  %retval = shufflevector <4 x half> %a, <4 x half> %b,
                     <4 x i32> <i32 4, i32 2, i32 2, i32 4>
  ret <4 x half> %retval
}

; CHECK-LABEL: test_shuffle_422u:
; CHECK:       # %bb.0:
; CHECK-NEXT:  sort4x16lo $a0, $a2, $a1
; CHECK-NEXT:  swap16 $a1, $a0
; CHECK-NEXT:  br $m10
define <4 x half> @test_shuffle_422u(<4 x half> %a, <4 x half> %b) {
  %retval = shufflevector <4 x half> %a, <4 x half> %b,
                     <4 x i32> <i32 4, i32 2, i32 2, i32 undef>
  ret <4 x half> %retval
}

; CHECK-LABEL: test_shuffle_42u4:
; CHECK:       # %bb.0:
; CHECK-NEXT:  sort4x16lo $a0, $a2, $a1
; CHECK-NEXT:  swap16 $a1, $a0
; CHECK-NEXT:  br $m10
define <4 x half> @test_shuffle_42u4(<4 x half> %a, <4 x half> %b) {
  %retval = shufflevector <4 x half> %a, <4 x half> %b,
                     <4 x i32> <i32 4, i32 2, i32 undef, i32 4>
  ret <4 x half> %retval
}

; CHECK-LABEL: test_shuffle_4u24:
; CHECK:       # %bb.0:
; CHECK-NEXT:  sort4x16lo $a0, $a2, $a1
; CHECK-NEXT:  swap16 $a1, $a0
; CHECK-NEXT:  br $m10
define <4 x half> @test_shuffle_4u24(<4 x half> %a, <4 x half> %b) {
  %retval = shufflevector <4 x half> %a, <4 x half> %b,
                     <4 x i32> <i32 4, i32 undef, i32 2, i32 4>
  ret <4 x half> %retval
}

; CHECK-LABEL: test_shuffle_u224:
; CHECK:       # %bb.0:
; CHECK-NEXT:  sort4x16lo $a0, $a2, $a1
; CHECK-NEXT:  swap16 $a1, $a0
; CHECK-NEXT:  br $m10
define <4 x half> @test_shuffle_u224(<4 x half> %a, <4 x half> %b) {
  %retval = shufflevector <4 x half> %a, <4 x half> %b,
                     <4 x i32> <i32 undef, i32 2, i32 2, i32 4>
  ret <4 x half> %retval
}

;;; The worst case looks like <0, 3, 0, 5>
;;; This is when both halves need the roll16, swap16 sequence.
;;; An instruction can be elided when there is symmetry
; CHECK-LABEL: test_shuffle_0305:
; CHECK-DAG:   roll16
; CHECK-DAG:   swap16
; CHECK-DAG:   roll16
; CHECK-DAG:   swap16
; CHECK:       br $m10
define <4 x half> @test_shuffle_0305(<4 x half> %lhs, <4 x half> %rhs) {
  %retval = shufflevector <4 x half> %lhs,
                          <4 x half> %rhs,
                          <4 x i32> <i32 0, i32 3, i32 0, i32 5>
  ret <4 x half> %retval
}

; CHECK-LABEL: test_shuffle_2552:
; CHECK:       # %bb.0:
; CHECK-NEXT:  roll16 $a1, $a2, $a1
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <4 x half> @test_shuffle_2552(<4 x half> %lhs, <4 x half> %rhs) {
  %retval = shufflevector <4 x half> %lhs,
                          <4 x half> %rhs,
                          <4 x i32> <i32 2, i32 5, i32 5, i32 2>
  ret <4 x half> %retval
}

; CHECK-LABEL: test_shuffle_255u:
; CHECK:       # %bb.0:
; CHECK-NEXT:  roll16 $a1, $a2, $a1
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <4 x half> @test_shuffle_255u(<4 x half> %lhs, <4 x half> %rhs) {
  %retval = shufflevector <4 x half> %lhs,
                          <4 x half> %rhs,
                          <4 x i32> <i32 2, i32 5, i32 5, i32 undef>
  ret <4 x half> %retval
}

; CHECK-LABEL: test_shuffle_25u2:
; CHECK:       # %bb.0:
; CHECK-NEXT:  roll16 $a1, $a2, $a1
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <4 x half> @test_shuffle_25u2(<4 x half> %lhs, <4 x half> %rhs) {
  %retval = shufflevector <4 x half> %lhs,
                          <4 x half> %rhs,
                          <4 x i32> <i32 2, i32 5, i32 undef, i32 2>
  ret <4 x half> %retval
}

; CHECK-LABEL: test_shuffle_2u52:
; CHECK:       # %bb.0:
; CHECK-NEXT:  roll16 $a1, $a2, $a1
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <4 x half> @test_shuffle_2u52(<4 x half> %lhs, <4 x half> %rhs) {
  %retval = shufflevector <4 x half> %lhs,
                          <4 x half> %rhs,
                          <4 x i32> <i32 2, i32 undef, i32 5, i32 2>
  ret <4 x half> %retval
}

; CHECK-LABEL: test_shuffle_u552:
; CHECK:       # %bb.0:
; CHECK-NEXT:  roll16 $a1, $a2, $a1
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <4 x half> @test_shuffle_u552(<4 x half> %lhs, <4 x half> %rhs) {
  %retval = shufflevector <4 x half> %lhs,
                          <4 x half> %rhs,
                          <4 x i32> <i32 undef, i32 5, i32 5, i32 2>
  ret <4 x half> %retval
}

; CHECK-LABEL: test_shuffle_5225:
; CHECK:       # %bb.0:
; CHECK-NEXT:  roll16 $a0, $a2, $a1
; CHECK-NEXT:  swap16 $a1, $a0
; CHECK-NEXT:  br $m10
define <4 x half> @test_shuffle_5225(<4 x half> %lhs, <4 x half> %rhs) {
  %retval = shufflevector <4 x half> %lhs,
                          <4 x half> %rhs,
                          <4 x i32> <i32 5, i32 2, i32 2, i32 5>
  ret <4 x half> %retval
}

; CHECK-LABEL: test_shuffle_522u:
; CHECK:       # %bb.0:
; CHECK-NEXT:  roll16 $a0, $a2, $a1
; CHECK-NEXT:  swap16 $a1, $a0
; CHECK-NEXT:  br $m10
define <4 x half> @test_shuffle_522u(<4 x half> %lhs, <4 x half> %rhs) {
  %retval = shufflevector <4 x half> %lhs,
                          <4 x half> %rhs,
                          <4 x i32> <i32 5, i32 2, i32 2, i32 undef>
  ret <4 x half> %retval
}

; CHECK-LABEL: test_shuffle_52u5:
; CHECK:       # %bb.0:
; CHECK-NEXT:  roll16 $a0, $a2, $a1
; CHECK-NEXT:  swap16 $a1, $a0
; CHECK-NEXT:  br $m10
define <4 x half> @test_shuffle_52u5(<4 x half> %lhs, <4 x half> %rhs) {
  %retval = shufflevector <4 x half> %lhs,
                          <4 x half> %rhs,
                          <4 x i32> <i32 5, i32 2, i32 undef, i32 5>
  ret <4 x half> %retval
}

; CHECK-LABEL: test_shuffle_5u25:
; CHECK:       # %bb.0:
; CHECK-NEXT:  roll16 $a0, $a2, $a1
; CHECK-NEXT:  swap16 $a1, $a0
; CHECK-NEXT:  br $m10
define <4 x half> @test_shuffle_5u25(<4 x half> %lhs, <4 x half> %rhs) {
  %retval = shufflevector <4 x half> %lhs,
                          <4 x half> %rhs,
                          <4 x i32> <i32 5, i32 undef, i32 2, i32 5>
  ret <4 x half> %retval
}

; CHECK-LABEL: test_shuffle_u225:
; CHECK:       # %bb.0:
; CHECK-NEXT:  roll16 $a0, $a2, $a1
; CHECK-NEXT:  swap16 $a1, $a0
; CHECK-NEXT:  br $m10
define <4 x half> @test_shuffle_u225(<4 x half> %lhs, <4 x half> %rhs) {
  %retval = shufflevector <4 x half> %lhs,
                          <4 x half> %rhs,
                          <4 x i32> <i32 undef, i32 2, i32 2, i32 5>
  ret <4 x half> %retval
}

;;; One roll and one mov is chosen over two swaps
; CHECK-LABEL: test_shuffle_1212:
; CHECK:       # %bb.0:
; CHECK-NEXT:  roll16 $a0, $a0, $a1
; CHECK-NEXT:  mov $a1, $a0
; CHECK-NEXT:  br $m10
define <4 x half> @test_shuffle_1212(<4 x half> %lhs, <4 x half> %rhs) {
  %retval = shufflevector <4 x half> %lhs,
                          <4 x half> %rhs,
                          <4 x i32> <i32 1, i32 2, i32 1, i32 2>
  ret <4 x half> %retval
}

; CHECK-LABEL: test_shuffle_121u:
; CHECK:       # %bb.0:
; CHECK-NEXT:  roll16 $a0, $a0, $a1
; CHECK-NEXT:  mov $a1, $a0
; CHECK-NEXT:  br $m10
define <4 x half> @test_shuffle_121u(<4 x half> %lhs, <4 x half> %rhs) {
  %retval = shufflevector <4 x half> %lhs,
                          <4 x half> %rhs,
                          <4 x i32> <i32 1, i32 2, i32 1, i32 undef>
  ret <4 x half> %retval
}

; CHECK-LABEL: test_shuffle_12u2:
; CHECK:       # %bb.0:
; CHECK-NEXT:  roll16 $a0, $a0, $a1
; CHECK-NEXT:  mov $a1, $a0
; CHECK-NEXT:  br $m10
define <4 x half> @test_shuffle_12u2(<4 x half> %lhs, <4 x half> %rhs) {
  %retval = shufflevector <4 x half> %lhs,
                          <4 x half> %rhs,
                          <4 x i32> <i32 1, i32 2, i32 undef, i32 2>
  ret <4 x half> %retval
}

; CHECK-LABEL: test_shuffle_1u12:
; CHECK:       # %bb.0:
; CHECK-NEXT:  roll16 $a0, $a0, $a1
; CHECK-NEXT:  mov $a1, $a0
; CHECK-NEXT:  br $m10
define <4 x half> @test_shuffle_1u12(<4 x half> %lhs, <4 x half> %rhs) {
  %retval = shufflevector <4 x half> %lhs,
                          <4 x half> %rhs,
                          <4 x i32> <i32 1, i32 undef, i32 1, i32 2>
  ret <4 x half> %retval
}

; CHECK-LABEL: test_shuffle_u212:
; CHECK:       # %bb.0:
; CHECK-NEXT:  roll16 $a0, $a0, $a1
; CHECK-NEXT:  mov $a1, $a0
; CHECK-NEXT:  br $m10
define <4 x half> @test_shuffle_u212(<4 x half> %lhs, <4 x half> %rhs) {
  %retval = shufflevector <4 x half> %lhs,
                          <4 x half> %rhs,
                          <4 x i32> <i32 undef, i32 2, i32 1, i32 2>
  ret <4 x half> %retval
}

