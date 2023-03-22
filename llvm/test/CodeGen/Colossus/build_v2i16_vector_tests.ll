; RUN: llc < %s -march=colossus -colossus-coissue=false -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -march=colossus -colossus-coissue=false -mattr=+ipu2 | FileCheck %s


; CHECK-LABEL: test_i16_i16:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $m0, $m0, $m2
; CHECK-NEXT:  br $m10
define <2 x i16> @test_i16_i16(i16 %lhs_arg, i16 %lhs_pad, i16 %rhs_arg, i16 %rhs_pad) {
  %vec0 = insertelement <2 x i16> undef, i16 %lhs_arg, i32 0
  %vec1 = insertelement <2 x i16> %vec0, i16 %rhs_arg, i32 1
  ret <2 x i16> %vec1
}

; CHECK-LABEL: test_i16_v2ie0:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $m0, $m0, $m2
; CHECK-NEXT:  br $m10
define <2 x i16> @test_i16_v2ie0(i16 %lhs_arg, i16 %lhs_pad, <2 x i16> %rhs_arg, <2 x i16> %rhs_pad) {
  %rhs_elt = extractelement <2 x i16> %rhs_arg, i32 0
  %vec0 = insertelement <2 x i16> undef, i16 %lhs_arg, i32 0
  %vec1 = insertelement <2 x i16> %vec0, i16 %rhs_elt, i32 1
  ret <2 x i16> %vec1
}

; CHECK-LABEL: test_i16_v2ie1:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $m0, $m2, $m0
; CHECK-NEXT:  swap16 $m0, $m0
; CHECK-NEXT:  br $m10
define <2 x i16> @test_i16_v2ie1(i16 %lhs_arg, i16 %lhs_pad, <2 x i16> %rhs_arg, <2 x i16> %rhs_pad) {
  %rhs_elt = extractelement <2 x i16> %rhs_arg, i32 1
  %vec0 = insertelement <2 x i16> undef, i16 %lhs_arg, i32 0
  %vec1 = insertelement <2 x i16> %vec0, i16 %rhs_elt, i32 1
  ret <2 x i16> %vec1
}

; CHECK-LABEL: test_i16_v4ie0:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $m0, $m0, $m2
; CHECK-NEXT:  br $m10
define <2 x i16> @test_i16_v4ie0(i16 %lhs_arg, i16 %lhs_pad, <4 x i16> %rhs_arg) {
  %rhs_elt = extractelement <4 x i16> %rhs_arg, i32 0
  %vec0 = insertelement <2 x i16> undef, i16 %lhs_arg, i32 0
  %vec1 = insertelement <2 x i16> %vec0, i16 %rhs_elt, i32 1
  ret <2 x i16> %vec1
}

; CHECK-LABEL: test_i16_v4ie1:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $m0, $m2, $m0
; CHECK-NEXT:  swap16 $m0, $m0
; CHECK-NEXT:  br $m10
define <2 x i16> @test_i16_v4ie1(i16 %lhs_arg, i16 %lhs_pad, <4 x i16> %rhs_arg) {
  %rhs_elt = extractelement <4 x i16> %rhs_arg, i32 1
  %vec0 = insertelement <2 x i16> undef, i16 %lhs_arg, i32 0
  %vec1 = insertelement <2 x i16> %vec0, i16 %rhs_elt, i32 1
  ret <2 x i16> %vec1
}

; CHECK-LABEL: test_i16_v4ie2:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $m0, $m0, $m3
; CHECK-NEXT:  br $m10
define <2 x i16> @test_i16_v4ie2(i16 %lhs_arg, i16 %lhs_pad, <4 x i16> %rhs_arg) {
  %rhs_elt = extractelement <4 x i16> %rhs_arg, i32 2
  %vec0 = insertelement <2 x i16> undef, i16 %lhs_arg, i32 0
  %vec1 = insertelement <2 x i16> %vec0, i16 %rhs_elt, i32 1
  ret <2 x i16> %vec1
}

; CHECK-LABEL: test_i16_v4ie3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $m0, $m3, $m0
; CHECK-NEXT:  swap16 $m0, $m0
; CHECK-NEXT:  br $m10
define <2 x i16> @test_i16_v4ie3(i16 %lhs_arg, i16 %lhs_pad, <4 x i16> %rhs_arg) {
  %rhs_elt = extractelement <4 x i16> %rhs_arg, i32 3
  %vec0 = insertelement <2 x i16> undef, i16 %lhs_arg, i32 0
  %vec1 = insertelement <2 x i16> %vec0, i16 %rhs_elt, i32 1
  ret <2 x i16> %vec1
}

; CHECK-LABEL: test_v2ie0_i16:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $m0, $m0, $m2
; CHECK-NEXT:  br $m10
define <2 x i16> @test_v2ie0_i16(<2 x i16> %lhs_arg, <2 x i16> %lhs_pad, i16 %rhs_arg, i16 %rhs_pad) {
  %lhs_elt = extractelement <2 x i16> %lhs_arg, i32 0
  %vec0 = insertelement <2 x i16> undef, i16 %lhs_elt, i32 0
  %vec1 = insertelement <2 x i16> %vec0, i16 %rhs_arg, i32 1
  ret <2 x i16> %vec1
}

; CHECK-LABEL: test_v2ie0_v2ie0:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $m0, $m0, $m2
; CHECK-NEXT:  br $m10
define <2 x i16> @test_v2ie0_v2ie0(<2 x i16> %lhs_arg, <2 x i16> %lhs_pad, <2 x i16> %rhs_arg, <2 x i16> %rhs_pad) {
  %lhs_elt = extractelement <2 x i16> %lhs_arg, i32 0
  %rhs_elt = extractelement <2 x i16> %rhs_arg, i32 0
  %vec0 = insertelement <2 x i16> undef, i16 %lhs_elt, i32 0
  %vec1 = insertelement <2 x i16> %vec0, i16 %rhs_elt, i32 1
  ret <2 x i16> %vec1
}

; CHECK-LABEL: test_v2ie0_v2ie1:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $m0, $m2, $m0
; CHECK-NEXT:  swap16 $m0, $m0
; CHECK-NEXT:  br $m10
define <2 x i16> @test_v2ie0_v2ie1(<2 x i16> %lhs_arg, <2 x i16> %lhs_pad, <2 x i16> %rhs_arg, <2 x i16> %rhs_pad) {
  %lhs_elt = extractelement <2 x i16> %lhs_arg, i32 0
  %rhs_elt = extractelement <2 x i16> %rhs_arg, i32 1
  %vec0 = insertelement <2 x i16> undef, i16 %lhs_elt, i32 0
  %vec1 = insertelement <2 x i16> %vec0, i16 %rhs_elt, i32 1
  ret <2 x i16> %vec1
}

; CHECK-LABEL: test_v2ie0_v4ie0:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $m0, $m0, $m2
; CHECK-NEXT:  br $m10
define <2 x i16> @test_v2ie0_v4ie0(<2 x i16> %lhs_arg, <2 x i16> %lhs_pad, <4 x i16> %rhs_arg) {
  %lhs_elt = extractelement <2 x i16> %lhs_arg, i32 0
  %rhs_elt = extractelement <4 x i16> %rhs_arg, i32 0
  %vec0 = insertelement <2 x i16> undef, i16 %lhs_elt, i32 0
  %vec1 = insertelement <2 x i16> %vec0, i16 %rhs_elt, i32 1
  ret <2 x i16> %vec1
}

; CHECK-LABEL: test_v2ie0_v4ie1:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $m0, $m2, $m0
; CHECK-NEXT:  swap16 $m0, $m0
; CHECK-NEXT:  br $m10
define <2 x i16> @test_v2ie0_v4ie1(<2 x i16> %lhs_arg, <2 x i16> %lhs_pad, <4 x i16> %rhs_arg) {
  %lhs_elt = extractelement <2 x i16> %lhs_arg, i32 0
  %rhs_elt = extractelement <4 x i16> %rhs_arg, i32 1
  %vec0 = insertelement <2 x i16> undef, i16 %lhs_elt, i32 0
  %vec1 = insertelement <2 x i16> %vec0, i16 %rhs_elt, i32 1
  ret <2 x i16> %vec1
}

; CHECK-LABEL: test_v2ie0_v4ie2:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $m0, $m0, $m3
; CHECK-NEXT:  br $m10
define <2 x i16> @test_v2ie0_v4ie2(<2 x i16> %lhs_arg, <2 x i16> %lhs_pad, <4 x i16> %rhs_arg) {
  %lhs_elt = extractelement <2 x i16> %lhs_arg, i32 0
  %rhs_elt = extractelement <4 x i16> %rhs_arg, i32 2
  %vec0 = insertelement <2 x i16> undef, i16 %lhs_elt, i32 0
  %vec1 = insertelement <2 x i16> %vec0, i16 %rhs_elt, i32 1
  ret <2 x i16> %vec1
}

; CHECK-LABEL: test_v2ie0_v4ie3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $m0, $m3, $m0
; CHECK-NEXT:  swap16 $m0, $m0
; CHECK-NEXT:  br $m10
define <2 x i16> @test_v2ie0_v4ie3(<2 x i16> %lhs_arg, <2 x i16> %lhs_pad, <4 x i16> %rhs_arg) {
  %lhs_elt = extractelement <2 x i16> %lhs_arg, i32 0
  %rhs_elt = extractelement <4 x i16> %rhs_arg, i32 3
  %vec0 = insertelement <2 x i16> undef, i16 %lhs_elt, i32 0
  %vec1 = insertelement <2 x i16> %vec0, i16 %rhs_elt, i32 1
  ret <2 x i16> %vec1
}

; CHECK-LABEL: test_v2ie1_i16:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $m0, $m0, $m2
; CHECK-NEXT:  br $m10
define <2 x i16> @test_v2ie1_i16(<2 x i16> %lhs_arg, <2 x i16> %lhs_pad, i16 %rhs_arg, i16 %rhs_pad) {
  %lhs_elt = extractelement <2 x i16> %lhs_arg, i32 1
  %vec0 = insertelement <2 x i16> undef, i16 %lhs_elt, i32 0
  %vec1 = insertelement <2 x i16> %vec0, i16 %rhs_arg, i32 1
  ret <2 x i16> %vec1
}

; CHECK-LABEL: test_v2ie1_v2ie0:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $m0, $m0, $m2
; CHECK-NEXT:  br $m10
define <2 x i16> @test_v2ie1_v2ie0(<2 x i16> %lhs_arg, <2 x i16> %lhs_pad, <2 x i16> %rhs_arg, <2 x i16> %rhs_pad) {
  %lhs_elt = extractelement <2 x i16> %lhs_arg, i32 1
  %rhs_elt = extractelement <2 x i16> %rhs_arg, i32 0
  %vec0 = insertelement <2 x i16> undef, i16 %lhs_elt, i32 0
  %vec1 = insertelement <2 x i16> %vec0, i16 %rhs_elt, i32 1
  ret <2 x i16> %vec1
}

; CHECK-LABEL: test_v2ie1_v2ie1:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $m0, $m0, $m2
; CHECK-NEXT:  br $m10
define <2 x i16> @test_v2ie1_v2ie1(<2 x i16> %lhs_arg, <2 x i16> %lhs_pad, <2 x i16> %rhs_arg, <2 x i16> %rhs_pad) {
  %lhs_elt = extractelement <2 x i16> %lhs_arg, i32 1
  %rhs_elt = extractelement <2 x i16> %rhs_arg, i32 1
  %vec0 = insertelement <2 x i16> undef, i16 %lhs_elt, i32 0
  %vec1 = insertelement <2 x i16> %vec0, i16 %rhs_elt, i32 1
  ret <2 x i16> %vec1
}

; CHECK-LABEL: test_v2ie1_v4ie0:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $m0, $m0, $m2
; CHECK-NEXT:  br $m10
define <2 x i16> @test_v2ie1_v4ie0(<2 x i16> %lhs_arg, <2 x i16> %lhs_pad, <4 x i16> %rhs_arg) {
  %lhs_elt = extractelement <2 x i16> %lhs_arg, i32 1
  %rhs_elt = extractelement <4 x i16> %rhs_arg, i32 0
  %vec0 = insertelement <2 x i16> undef, i16 %lhs_elt, i32 0
  %vec1 = insertelement <2 x i16> %vec0, i16 %rhs_elt, i32 1
  ret <2 x i16> %vec1
}

; CHECK-LABEL: test_v2ie1_v4ie1:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $m0, $m0, $m2
; CHECK-NEXT:  br $m10
define <2 x i16> @test_v2ie1_v4ie1(<2 x i16> %lhs_arg, <2 x i16> %lhs_pad, <4 x i16> %rhs_arg) {
  %lhs_elt = extractelement <2 x i16> %lhs_arg, i32 1
  %rhs_elt = extractelement <4 x i16> %rhs_arg, i32 1
  %vec0 = insertelement <2 x i16> undef, i16 %lhs_elt, i32 0
  %vec1 = insertelement <2 x i16> %vec0, i16 %rhs_elt, i32 1
  ret <2 x i16> %vec1
}

; CHECK-LABEL: test_v2ie1_v4ie2:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $m0, $m0, $m3
; CHECK-NEXT:  br $m10
define <2 x i16> @test_v2ie1_v4ie2(<2 x i16> %lhs_arg, <2 x i16> %lhs_pad, <4 x i16> %rhs_arg) {
  %lhs_elt = extractelement <2 x i16> %lhs_arg, i32 1
  %rhs_elt = extractelement <4 x i16> %rhs_arg, i32 2
  %vec0 = insertelement <2 x i16> undef, i16 %lhs_elt, i32 0
  %vec1 = insertelement <2 x i16> %vec0, i16 %rhs_elt, i32 1
  ret <2 x i16> %vec1
}

; CHECK-LABEL: test_v2ie1_v4ie3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $m0, $m0, $m3
; CHECK-NEXT:  br $m10
define <2 x i16> @test_v2ie1_v4ie3(<2 x i16> %lhs_arg, <2 x i16> %lhs_pad, <4 x i16> %rhs_arg) {
  %lhs_elt = extractelement <2 x i16> %lhs_arg, i32 1
  %rhs_elt = extractelement <4 x i16> %rhs_arg, i32 3
  %vec0 = insertelement <2 x i16> undef, i16 %lhs_elt, i32 0
  %vec1 = insertelement <2 x i16> %vec0, i16 %rhs_elt, i32 1
  ret <2 x i16> %vec1
}

; CHECK-LABEL: test_v4ie0_i16:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $m0, $m0, $m2
; CHECK-NEXT:  br $m10
define <2 x i16> @test_v4ie0_i16(<4 x i16> %lhs_arg, i16 %rhs_arg, i16 %rhs_pad) {
  %lhs_elt = extractelement <4 x i16> %lhs_arg, i32 0
  %vec0 = insertelement <2 x i16> undef, i16 %lhs_elt, i32 0
  %vec1 = insertelement <2 x i16> %vec0, i16 %rhs_arg, i32 1
  ret <2 x i16> %vec1
}

; CHECK-LABEL: test_v4ie0_v2ie0:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $m0, $m0, $m2
; CHECK-NEXT:  br $m10
define <2 x i16> @test_v4ie0_v2ie0(<4 x i16> %lhs_arg, <2 x i16> %rhs_arg, <2 x i16> %rhs_pad) {
  %lhs_elt = extractelement <4 x i16> %lhs_arg, i32 0
  %rhs_elt = extractelement <2 x i16> %rhs_arg, i32 0
  %vec0 = insertelement <2 x i16> undef, i16 %lhs_elt, i32 0
  %vec1 = insertelement <2 x i16> %vec0, i16 %rhs_elt, i32 1
  ret <2 x i16> %vec1
}

; CHECK-LABEL: test_v4ie0_v2ie1:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $m0, $m2, $m0
; CHECK-NEXT:  swap16 $m0, $m0
; CHECK-NEXT:  br $m10
define <2 x i16> @test_v4ie0_v2ie1(<4 x i16> %lhs_arg, <2 x i16> %rhs_arg, <2 x i16> %rhs_pad) {
  %lhs_elt = extractelement <4 x i16> %lhs_arg, i32 0
  %rhs_elt = extractelement <2 x i16> %rhs_arg, i32 1
  %vec0 = insertelement <2 x i16> undef, i16 %lhs_elt, i32 0
  %vec1 = insertelement <2 x i16> %vec0, i16 %rhs_elt, i32 1
  ret <2 x i16> %vec1
}

; CHECK-LABEL: test_v4ie0_v4ie0:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $m0, $m0, $m2
; CHECK-NEXT:  br $m10
define <2 x i16> @test_v4ie0_v4ie0(<4 x i16> %lhs_arg, <4 x i16> %rhs_arg) {
  %lhs_elt = extractelement <4 x i16> %lhs_arg, i32 0
  %rhs_elt = extractelement <4 x i16> %rhs_arg, i32 0
  %vec0 = insertelement <2 x i16> undef, i16 %lhs_elt, i32 0
  %vec1 = insertelement <2 x i16> %vec0, i16 %rhs_elt, i32 1
  ret <2 x i16> %vec1
}

; CHECK-LABEL: test_v4ie0_v4ie1:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $m0, $m2, $m0
; CHECK-NEXT:  swap16 $m0, $m0
; CHECK-NEXT:  br $m10
define <2 x i16> @test_v4ie0_v4ie1(<4 x i16> %lhs_arg, <4 x i16> %rhs_arg) {
  %lhs_elt = extractelement <4 x i16> %lhs_arg, i32 0
  %rhs_elt = extractelement <4 x i16> %rhs_arg, i32 1
  %vec0 = insertelement <2 x i16> undef, i16 %lhs_elt, i32 0
  %vec1 = insertelement <2 x i16> %vec0, i16 %rhs_elt, i32 1
  ret <2 x i16> %vec1
}

; CHECK-LABEL: test_v4ie0_v4ie2:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $m0, $m0, $m3
; CHECK-NEXT:  br $m10
define <2 x i16> @test_v4ie0_v4ie2(<4 x i16> %lhs_arg, <4 x i16> %rhs_arg) {
  %lhs_elt = extractelement <4 x i16> %lhs_arg, i32 0
  %rhs_elt = extractelement <4 x i16> %rhs_arg, i32 2
  %vec0 = insertelement <2 x i16> undef, i16 %lhs_elt, i32 0
  %vec1 = insertelement <2 x i16> %vec0, i16 %rhs_elt, i32 1
  ret <2 x i16> %vec1
}

; CHECK-LABEL: test_v4ie0_v4ie3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $m0, $m3, $m0
; CHECK-NEXT:  swap16 $m0, $m0
; CHECK-NEXT:  br $m10
define <2 x i16> @test_v4ie0_v4ie3(<4 x i16> %lhs_arg, <4 x i16> %rhs_arg) {
  %lhs_elt = extractelement <4 x i16> %lhs_arg, i32 0
  %rhs_elt = extractelement <4 x i16> %rhs_arg, i32 3
  %vec0 = insertelement <2 x i16> undef, i16 %lhs_elt, i32 0
  %vec1 = insertelement <2 x i16> %vec0, i16 %rhs_elt, i32 1
  ret <2 x i16> %vec1
}

; CHECK-LABEL: test_v4ie1_i16:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $m0, $m0, $m2
; CHECK-NEXT:  br $m10
define <2 x i16> @test_v4ie1_i16(<4 x i16> %lhs_arg, i16 %rhs_arg, i16 %rhs_pad) {
  %lhs_elt = extractelement <4 x i16> %lhs_arg, i32 1
  %vec0 = insertelement <2 x i16> undef, i16 %lhs_elt, i32 0
  %vec1 = insertelement <2 x i16> %vec0, i16 %rhs_arg, i32 1
  ret <2 x i16> %vec1
}

; CHECK-LABEL: test_v4ie1_v2ie0:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $m0, $m0, $m2
; CHECK-NEXT:  br $m10
define <2 x i16> @test_v4ie1_v2ie0(<4 x i16> %lhs_arg, <2 x i16> %rhs_arg, <2 x i16> %rhs_pad) {
  %lhs_elt = extractelement <4 x i16> %lhs_arg, i32 1
  %rhs_elt = extractelement <2 x i16> %rhs_arg, i32 0
  %vec0 = insertelement <2 x i16> undef, i16 %lhs_elt, i32 0
  %vec1 = insertelement <2 x i16> %vec0, i16 %rhs_elt, i32 1
  ret <2 x i16> %vec1
}

; CHECK-LABEL: test_v4ie1_v2ie1:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $m0, $m0, $m2
; CHECK-NEXT:  br $m10
define <2 x i16> @test_v4ie1_v2ie1(<4 x i16> %lhs_arg, <2 x i16> %rhs_arg, <2 x i16> %rhs_pad) {
  %lhs_elt = extractelement <4 x i16> %lhs_arg, i32 1
  %rhs_elt = extractelement <2 x i16> %rhs_arg, i32 1
  %vec0 = insertelement <2 x i16> undef, i16 %lhs_elt, i32 0
  %vec1 = insertelement <2 x i16> %vec0, i16 %rhs_elt, i32 1
  ret <2 x i16> %vec1
}

; CHECK-LABEL: test_v4ie1_v4ie0:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $m0, $m0, $m2
; CHECK-NEXT:  br $m10
define <2 x i16> @test_v4ie1_v4ie0(<4 x i16> %lhs_arg, <4 x i16> %rhs_arg) {
  %lhs_elt = extractelement <4 x i16> %lhs_arg, i32 1
  %rhs_elt = extractelement <4 x i16> %rhs_arg, i32 0
  %vec0 = insertelement <2 x i16> undef, i16 %lhs_elt, i32 0
  %vec1 = insertelement <2 x i16> %vec0, i16 %rhs_elt, i32 1
  ret <2 x i16> %vec1
}

; CHECK-LABEL: test_v4ie1_v4ie1:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $m0, $m0, $m2
; CHECK-NEXT:  br $m10
define <2 x i16> @test_v4ie1_v4ie1(<4 x i16> %lhs_arg, <4 x i16> %rhs_arg) {
  %lhs_elt = extractelement <4 x i16> %lhs_arg, i32 1
  %rhs_elt = extractelement <4 x i16> %rhs_arg, i32 1
  %vec0 = insertelement <2 x i16> undef, i16 %lhs_elt, i32 0
  %vec1 = insertelement <2 x i16> %vec0, i16 %rhs_elt, i32 1
  ret <2 x i16> %vec1
}

; CHECK-LABEL: test_v4ie1_v4ie2:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $m0, $m0, $m3
; CHECK-NEXT:  br $m10
define <2 x i16> @test_v4ie1_v4ie2(<4 x i16> %lhs_arg, <4 x i16> %rhs_arg) {
  %lhs_elt = extractelement <4 x i16> %lhs_arg, i32 1
  %rhs_elt = extractelement <4 x i16> %rhs_arg, i32 2
  %vec0 = insertelement <2 x i16> undef, i16 %lhs_elt, i32 0
  %vec1 = insertelement <2 x i16> %vec0, i16 %rhs_elt, i32 1
  ret <2 x i16> %vec1
}

; CHECK-LABEL: test_v4ie1_v4ie3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $m0, $m0, $m3
; CHECK-NEXT:  br $m10
define <2 x i16> @test_v4ie1_v4ie3(<4 x i16> %lhs_arg, <4 x i16> %rhs_arg) {
  %lhs_elt = extractelement <4 x i16> %lhs_arg, i32 1
  %rhs_elt = extractelement <4 x i16> %rhs_arg, i32 3
  %vec0 = insertelement <2 x i16> undef, i16 %lhs_elt, i32 0
  %vec1 = insertelement <2 x i16> %vec0, i16 %rhs_elt, i32 1
  ret <2 x i16> %vec1
}

; CHECK-LABEL: test_v4ie2_i16:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $m0, $m1, $m2
; CHECK-NEXT:  br $m10
define <2 x i16> @test_v4ie2_i16(<4 x i16> %lhs_arg, i16 %rhs_arg, i16 %rhs_pad) {
  %lhs_elt = extractelement <4 x i16> %lhs_arg, i32 2
  %vec0 = insertelement <2 x i16> undef, i16 %lhs_elt, i32 0
  %vec1 = insertelement <2 x i16> %vec0, i16 %rhs_arg, i32 1
  ret <2 x i16> %vec1
}

; CHECK-LABEL: test_v4ie2_v2ie0:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $m0, $m1, $m2
; CHECK-NEXT:  br $m10
define <2 x i16> @test_v4ie2_v2ie0(<4 x i16> %lhs_arg, <2 x i16> %rhs_arg, <2 x i16> %rhs_pad) {
  %lhs_elt = extractelement <4 x i16> %lhs_arg, i32 2
  %rhs_elt = extractelement <2 x i16> %rhs_arg, i32 0
  %vec0 = insertelement <2 x i16> undef, i16 %lhs_elt, i32 0
  %vec1 = insertelement <2 x i16> %vec0, i16 %rhs_elt, i32 1
  ret <2 x i16> %vec1
}

; CHECK-LABEL: test_v4ie2_v2ie1:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $m0, $m2, $m1
; CHECK-NEXT:  swap16 $m0, $m0
; CHECK-NEXT:  br $m10
define <2 x i16> @test_v4ie2_v2ie1(<4 x i16> %lhs_arg, <2 x i16> %rhs_arg, <2 x i16> %rhs_pad) {
  %lhs_elt = extractelement <4 x i16> %lhs_arg, i32 2
  %rhs_elt = extractelement <2 x i16> %rhs_arg, i32 1
  %vec0 = insertelement <2 x i16> undef, i16 %lhs_elt, i32 0
  %vec1 = insertelement <2 x i16> %vec0, i16 %rhs_elt, i32 1
  ret <2 x i16> %vec1
}

; CHECK-LABEL: test_v4ie2_v4ie0:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $m0, $m1, $m2
; CHECK-NEXT:  br $m10
define <2 x i16> @test_v4ie2_v4ie0(<4 x i16> %lhs_arg, <4 x i16> %rhs_arg) {
  %lhs_elt = extractelement <4 x i16> %lhs_arg, i32 2
  %rhs_elt = extractelement <4 x i16> %rhs_arg, i32 0
  %vec0 = insertelement <2 x i16> undef, i16 %lhs_elt, i32 0
  %vec1 = insertelement <2 x i16> %vec0, i16 %rhs_elt, i32 1
  ret <2 x i16> %vec1
}

; CHECK-LABEL: test_v4ie2_v4ie1:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $m0, $m2, $m1
; CHECK-NEXT:  swap16 $m0, $m0
; CHECK-NEXT:  br $m10
define <2 x i16> @test_v4ie2_v4ie1(<4 x i16> %lhs_arg, <4 x i16> %rhs_arg) {
  %lhs_elt = extractelement <4 x i16> %lhs_arg, i32 2
  %rhs_elt = extractelement <4 x i16> %rhs_arg, i32 1
  %vec0 = insertelement <2 x i16> undef, i16 %lhs_elt, i32 0
  %vec1 = insertelement <2 x i16> %vec0, i16 %rhs_elt, i32 1
  ret <2 x i16> %vec1
}

; CHECK-LABEL: test_v4ie2_v4ie2:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $m0, $m1, $m3
; CHECK-NEXT:  br $m10
define <2 x i16> @test_v4ie2_v4ie2(<4 x i16> %lhs_arg, <4 x i16> %rhs_arg) {
  %lhs_elt = extractelement <4 x i16> %lhs_arg, i32 2
  %rhs_elt = extractelement <4 x i16> %rhs_arg, i32 2
  %vec0 = insertelement <2 x i16> undef, i16 %lhs_elt, i32 0
  %vec1 = insertelement <2 x i16> %vec0, i16 %rhs_elt, i32 1
  ret <2 x i16> %vec1
}

; CHECK-LABEL: test_v4ie2_v4ie3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $m0, $m3, $m1
; CHECK-NEXT:  swap16 $m0, $m0
; CHECK-NEXT:  br $m10
define <2 x i16> @test_v4ie2_v4ie3(<4 x i16> %lhs_arg, <4 x i16> %rhs_arg) {
  %lhs_elt = extractelement <4 x i16> %lhs_arg, i32 2
  %rhs_elt = extractelement <4 x i16> %rhs_arg, i32 3
  %vec0 = insertelement <2 x i16> undef, i16 %lhs_elt, i32 0
  %vec1 = insertelement <2 x i16> %vec0, i16 %rhs_elt, i32 1
  ret <2 x i16> %vec1
}

; CHECK-LABEL: test_v4ie3_i16:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $m0, $m1, $m2
; CHECK-NEXT:  br $m10
define <2 x i16> @test_v4ie3_i16(<4 x i16> %lhs_arg, i16 %rhs_arg, i16 %rhs_pad) {
  %lhs_elt = extractelement <4 x i16> %lhs_arg, i32 3
  %vec0 = insertelement <2 x i16> undef, i16 %lhs_elt, i32 0
  %vec1 = insertelement <2 x i16> %vec0, i16 %rhs_arg, i32 1
  ret <2 x i16> %vec1
}

; CHECK-LABEL: test_v4ie3_v2ie0:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $m0, $m1, $m2
; CHECK-NEXT:  br $m10
define <2 x i16> @test_v4ie3_v2ie0(<4 x i16> %lhs_arg, <2 x i16> %rhs_arg, <2 x i16> %rhs_pad) {
  %lhs_elt = extractelement <4 x i16> %lhs_arg, i32 3
  %rhs_elt = extractelement <2 x i16> %rhs_arg, i32 0
  %vec0 = insertelement <2 x i16> undef, i16 %lhs_elt, i32 0
  %vec1 = insertelement <2 x i16> %vec0, i16 %rhs_elt, i32 1
  ret <2 x i16> %vec1
}

; CHECK-LABEL: test_v4ie3_v2ie1:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $m0, $m1, $m2
; CHECK-NEXT:  br $m10
define <2 x i16> @test_v4ie3_v2ie1(<4 x i16> %lhs_arg, <2 x i16> %rhs_arg, <2 x i16> %rhs_pad) {
  %lhs_elt = extractelement <4 x i16> %lhs_arg, i32 3
  %rhs_elt = extractelement <2 x i16> %rhs_arg, i32 1
  %vec0 = insertelement <2 x i16> undef, i16 %lhs_elt, i32 0
  %vec1 = insertelement <2 x i16> %vec0, i16 %rhs_elt, i32 1
  ret <2 x i16> %vec1
}

; CHECK-LABEL: test_v4ie3_v4ie0:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $m0, $m1, $m2
; CHECK-NEXT:  br $m10
define <2 x i16> @test_v4ie3_v4ie0(<4 x i16> %lhs_arg, <4 x i16> %rhs_arg) {
  %lhs_elt = extractelement <4 x i16> %lhs_arg, i32 3
  %rhs_elt = extractelement <4 x i16> %rhs_arg, i32 0
  %vec0 = insertelement <2 x i16> undef, i16 %lhs_elt, i32 0
  %vec1 = insertelement <2 x i16> %vec0, i16 %rhs_elt, i32 1
  ret <2 x i16> %vec1
}

; CHECK-LABEL: test_v4ie3_v4ie1:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $m0, $m1, $m2
; CHECK-NEXT:  br $m10
define <2 x i16> @test_v4ie3_v4ie1(<4 x i16> %lhs_arg, <4 x i16> %rhs_arg) {
  %lhs_elt = extractelement <4 x i16> %lhs_arg, i32 3
  %rhs_elt = extractelement <4 x i16> %rhs_arg, i32 1
  %vec0 = insertelement <2 x i16> undef, i16 %lhs_elt, i32 0
  %vec1 = insertelement <2 x i16> %vec0, i16 %rhs_elt, i32 1
  ret <2 x i16> %vec1
}

; CHECK-LABEL: test_v4ie3_v4ie2:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $m0, $m1, $m3
; CHECK-NEXT:  br $m10
define <2 x i16> @test_v4ie3_v4ie2(<4 x i16> %lhs_arg, <4 x i16> %rhs_arg) {
  %lhs_elt = extractelement <4 x i16> %lhs_arg, i32 3
  %rhs_elt = extractelement <4 x i16> %rhs_arg, i32 2
  %vec0 = insertelement <2 x i16> undef, i16 %lhs_elt, i32 0
  %vec1 = insertelement <2 x i16> %vec0, i16 %rhs_elt, i32 1
  ret <2 x i16> %vec1
}

; CHECK-LABEL: test_v4ie3_v4ie3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $m0, $m1, $m3
; CHECK-NEXT:  br $m10
define <2 x i16> @test_v4ie3_v4ie3(<4 x i16> %lhs_arg, <4 x i16> %rhs_arg) {
  %lhs_elt = extractelement <4 x i16> %lhs_arg, i32 3
  %rhs_elt = extractelement <4 x i16> %rhs_arg, i32 3
  %vec0 = insertelement <2 x i16> undef, i16 %lhs_elt, i32 0
  %vec1 = insertelement <2 x i16> %vec0, i16 %rhs_elt, i32 1
  ret <2 x i16> %vec1
}
