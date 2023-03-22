; RUN: llc < %s -mtriple=colossus -colossus-coissue=false -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -mtriple=colossus -colossus-coissue=false -mattr=+ipu2 | FileCheck %s



; CHECK-LABEL: test_shuffle_00:
; CHECK:       # %bb.0:
; CHECK-NEXT:  sort4x16lo $a0, $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_shuffle_00(<2 x half> %a, <2 x half> %b) {
  %retval = shufflevector <2 x half> %a, <2 x half> %b,
                     <2 x i32> <i32 0, i32 0>
  ret <2 x half> %retval
}

; CHECK-LABEL: test_shuffle_01:
; CHECK:       # %bb.0:
; CHECK-NEXT:  br $m10
define <2 x half> @test_shuffle_01(<2 x half> %a, <2 x half> %b) {
  %retval = shufflevector <2 x half> %a, <2 x half> %b,
                     <2 x i32> <i32 0, i32 1>
  ret <2 x half> %retval
}

; CHECK-LABEL: test_shuffle_02:
; CHECK:       # %bb.0:
; CHECK-NEXT:  sort4x16lo $a0, $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_shuffle_02(<2 x half> %a, <2 x half> %b) {
  %retval = shufflevector <2 x half> %a, <2 x half> %b,
                     <2 x i32> <i32 0, i32 2>
  ret <2 x half> %retval
}

; CHECK-LABEL: test_shuffle_03:
; CHECK:       # %bb.0:
; CHECK-NEXT:  roll16 [[REG:\$a[0-9]+]], $a1, $a0
; CHECK-NEXT:  swap16 $a0, [[REG]]
; CHECK-NEXT:  br $m10
define <2 x half> @test_shuffle_03(<2 x half> %a, <2 x half> %b) {
  %retval = shufflevector <2 x half> %a, <2 x half> %b,
                     <2 x i32> <i32 0, i32 3>
  ret <2 x half> %retval
}

; CHECK-LABEL: test_shuffle_10:
; CHECK:       # %bb.0:
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_shuffle_10(<2 x half> %a, <2 x half> %b) {
  %retval = shufflevector <2 x half> %a, <2 x half> %b,
                     <2 x i32> <i32 1, i32 0>
  ret <2 x half> %retval
}

; CHECK-LABEL: test_shuffle_11:
; CHECK:       # %bb.0:
; CHECK-NEXT:  sort4x16hi $a0, $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_shuffle_11(<2 x half> %a, <2 x half> %b) {
  %retval = shufflevector <2 x half> %a, <2 x half> %b,
                     <2 x i32> <i32 1, i32 1>
  ret <2 x half> %retval
}

; CHECK-LABEL: test_shuffle_12:
; CHECK:       # %bb.0:
; CHECK-NEXT:  roll16 $a0, $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_shuffle_12(<2 x half> %a, <2 x half> %b) {
  %retval = shufflevector <2 x half> %a, <2 x half> %b,
                     <2 x i32> <i32 1, i32 2>
  ret <2 x half> %retval
}

; CHECK-LABEL: test_shuffle_13:
; CHECK:       # %bb.0:
; CHECK-NEXT:  sort4x16hi $a0, $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_shuffle_13(<2 x half> %a, <2 x half> %b) {
  %retval = shufflevector <2 x half> %a, <2 x half> %b,
                     <2 x i32> <i32 1, i32 3>
  ret <2 x half> %retval
}

; CHECK-LABEL: test_shuffle_20:
; CHECK:       # %bb.0:
; CHECK-NEXT:  sort4x16lo $a0, $a1, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_shuffle_20(<2 x half> %a, <2 x half> %b) {
  %retval = shufflevector <2 x half> %a, <2 x half> %b,
                     <2 x i32> <i32 2, i32 0>
  ret <2 x half> %retval
}

; CHECK-LABEL: test_shuffle_21:
; CHECK:       # %bb.0:
; CHECK-NEXT:  roll16 [[REG:\$a[0-9]+]], $a0, $a1
; CHECK-NEXT:  swap16 $a0, [[REG]]
; CHECK-NEXT:  br $m10
define <2 x half> @test_shuffle_21(<2 x half> %a, <2 x half> %b) {
  %retval = shufflevector <2 x half> %a, <2 x half> %b,
                     <2 x i32> <i32 2, i32 1>
  ret <2 x half> %retval
}

; CHECK-LABEL: test_shuffle_22:
; CHECK:       # %bb.0:
; CHECK-NEXT:  sort4x16lo $a0, $a1, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_shuffle_22(<2 x half> %a, <2 x half> %b) {
  %retval = shufflevector <2 x half> %a, <2 x half> %b,
                     <2 x i32> <i32 2, i32 2>
  ret <2 x half> %retval
}

; CHECK-LABEL: test_shuffle_23:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_shuffle_23(<2 x half> %a, <2 x half> %b) {
  %retval = shufflevector <2 x half> %a, <2 x half> %b,
                     <2 x i32> <i32 2, i32 3>
  ret <2 x half> %retval
}

; CHECK-LABEL: test_shuffle_30:
; CHECK:       # %bb.0:
; CHECK-NEXT:  roll16 $a0, $a1, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_shuffle_30(<2 x half> %a, <2 x half> %b) {
  %retval = shufflevector <2 x half> %a, <2 x half> %b,
                     <2 x i32> <i32 3, i32 0>
  ret <2 x half> %retval
}

; CHECK-LABEL: test_shuffle_31:
; CHECK:       # %bb.0:
; CHECK-NEXT:  sort4x16hi $a0, $a1, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_shuffle_31(<2 x half> %a, <2 x half> %b) {
  %retval = shufflevector <2 x half> %a, <2 x half> %b,
                     <2 x i32> <i32 3, i32 1>
  ret <2 x half> %retval
}

; CHECK-LABEL: test_shuffle_32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_shuffle_32(<2 x half> %a, <2 x half> %b) {
  %retval = shufflevector <2 x half> %a, <2 x half> %b,
                     <2 x i32> <i32 3, i32 2>
  ret <2 x half> %retval
}

; CHECK-LABEL: test_shuffle_33:
; CHECK:       # %bb.0:
; CHECK-NEXT:  sort4x16hi $a0, $a1, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_shuffle_33(<2 x half> %a, <2 x half> %b) {
  %retval = shufflevector <2 x half> %a, <2 x half> %b,
                     <2 x i32> <i32 3, i32 3>
  ret <2 x half> %retval
}

;;; Partially undefined cases. Order of preference is no op, copy, swap, other

; CHECK-LABEL: test_shuffle_uu:
; CHECK:       # %bb.0:
; CHECK-NEXT:  br $m10
define <2 x half> @test_shuffle_uu(<2 x half> %a, <2 x half> %b) {
  %retval = shufflevector <2 x half> %a, <2 x half> %b,
                     <2 x i32> <i32 undef, i32 undef>
  ret <2 x half> %retval
}

; CHECK-LABEL: test_shuffle_0u:
; CHECK:       # %bb.0:
; CHECK-NEXT:  br $m10
define <2 x half> @test_shuffle_0u(<2 x half> %a, <2 x half> %b) {
  %retval = shufflevector <2 x half> %a, <2 x half> %b,
                     <2 x i32> <i32 0, i32 undef>
  ret <2 x half> %retval
}

; CHECK-LABEL: test_shuffle_1u:
; CHECK:       # %bb.0:
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_shuffle_1u(<2 x half> %a, <2 x half> %b) {
  %retval = shufflevector <2 x half> %a, <2 x half> %b,
                     <2 x i32> <i32 1, i32 undef>
  ret <2 x half> %retval
}

; CHECK-LABEL: test_shuffle_2u:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_shuffle_2u(<2 x half> %a, <2 x half> %b) {
  %retval = shufflevector <2 x half> %a, <2 x half> %b,
                     <2 x i32> <i32 2, i32 undef>
  ret <2 x half> %retval
}

; CHECK-LABEL: test_shuffle_3u:
; CHECK:       # %bb.0:
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_shuffle_3u(<2 x half> %a, <2 x half> %b) {
  %retval = shufflevector <2 x half> %a, <2 x half> %b,
                     <2 x i32> <i32 3, i32 undef>
  ret <2 x half> %retval
}

; CHECK-LABEL: test_shuffle_u0:
; CHECK:       # %bb.0:
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_shuffle_u0(<2 x half> %a, <2 x half> %b) {
  %retval = shufflevector <2 x half> %a, <2 x half> %b,
                     <2 x i32> <i32 undef, i32 0>
  ret <2 x half> %retval
}

; CHECK-LABEL: test_shuffle_u1:
; CHECK:       # %bb.0:
; CHECK-NEXT:  br $m10
define <2 x half> @test_shuffle_u1(<2 x half> %a, <2 x half> %b) {
  %retval = shufflevector <2 x half> %a, <2 x half> %b,
                     <2 x i32> <i32 undef, i32 1>
  ret <2 x half> %retval
}

; CHECK-LABEL: test_shuffle_u2:
; CHECK:       # %bb.0:
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_shuffle_u2(<2 x half> %a, <2 x half> %b) {
  %retval = shufflevector <2 x half> %a, <2 x half> %b,
                     <2 x i32> <i32 undef, i32 2>
  ret <2 x half> %retval
}

; CHECK-LABEL: test_shuffle_u3:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_shuffle_u3(<2 x half> %a, <2 x half> %b) {
  %retval = shufflevector <2 x half> %a, <2 x half> %b,
                     <2 x i32> <i32 undef, i32 3>
  ret <2 x half> %retval
}
