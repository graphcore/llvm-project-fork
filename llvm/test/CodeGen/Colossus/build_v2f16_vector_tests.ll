; RUN: llc < %s -march=colossus -colossus-coissue=false -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -march=colossus -colossus-coissue=false -mattr=+ipu2 | FileCheck %s

; CHECK-LABEL: test_f16_f16:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_f16_f16(half %lhs_arg, half %lhs_pad, half %rhs_arg, half %rhs_pad) {
  %vec0 = insertelement <2 x half> undef, half %lhs_arg, i32 0
  %vec1 = insertelement <2 x half> %vec0, half %rhs_arg, i32 1
  ret <2 x half> %vec1
}

; CHECK-LABEL: test_f16_v2fe0:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_f16_v2fe0(half %lhs_arg, half %lhs_pad, <2 x half> %rhs_arg, <2 x half> %rhs_pad) {
  %rhs_elt = extractelement <2 x half> %rhs_arg, i32 0
  %vec0 = insertelement <2 x half> undef, half %lhs_arg, i32 0
  %vec1 = insertelement <2 x half> %vec0, half %rhs_elt, i32 1
  ret <2 x half> %vec1
}

; CHECK-LABEL: test_f16_v2fe1:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a2, $a0
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_f16_v2fe1(half %lhs_arg, half %lhs_pad, <2 x half> %rhs_arg, <2 x half> %rhs_pad) {
  %rhs_elt = extractelement <2 x half> %rhs_arg, i32 1
  %vec0 = insertelement <2 x half> undef, half %lhs_arg, i32 0
  %vec1 = insertelement <2 x half> %vec0, half %rhs_elt, i32 1
  ret <2 x half> %vec1
}

; CHECK-LABEL: test_f16_v4fe0:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_f16_v4fe0(half %lhs_arg, half %lhs_pad, <4 x half> %rhs_arg) {
  %rhs_elt = extractelement <4 x half> %rhs_arg, i32 0
  %vec0 = insertelement <2 x half> undef, half %lhs_arg, i32 0
  %vec1 = insertelement <2 x half> %vec0, half %rhs_elt, i32 1
  ret <2 x half> %vec1
}

; CHECK-LABEL: test_f16_v4fe1:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a2, $a0
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_f16_v4fe1(half %lhs_arg, half %lhs_pad, <4 x half> %rhs_arg) {
  %rhs_elt = extractelement <4 x half> %rhs_arg, i32 1
  %vec0 = insertelement <2 x half> undef, half %lhs_arg, i32 0
  %vec1 = insertelement <2 x half> %vec0, half %rhs_elt, i32 1
  ret <2 x half> %vec1
}

; CHECK-LABEL: test_f16_v4fe2:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a0, $a3
; CHECK-NEXT:  br $m10
define <2 x half> @test_f16_v4fe2(half %lhs_arg, half %lhs_pad, <4 x half> %rhs_arg) {
  %rhs_elt = extractelement <4 x half> %rhs_arg, i32 2
  %vec0 = insertelement <2 x half> undef, half %lhs_arg, i32 0
  %vec1 = insertelement <2 x half> %vec0, half %rhs_elt, i32 1
  ret <2 x half> %vec1
}

; CHECK-LABEL: test_f16_v4fe3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a3, $a0
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_f16_v4fe3(half %lhs_arg, half %lhs_pad, <4 x half> %rhs_arg) {
  %rhs_elt = extractelement <4 x half> %rhs_arg, i32 3
  %vec0 = insertelement <2 x half> undef, half %lhs_arg, i32 0
  %vec1 = insertelement <2 x half> %vec0, half %rhs_elt, i32 1
  ret <2 x half> %vec1
}

; CHECK-LABEL: test_v2fe0_f16:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_v2fe0_f16(<2 x half> %lhs_arg, <2 x half> %lhs_pad, half %rhs_arg, half %rhs_pad) {
  %lhs_elt = extractelement <2 x half> %lhs_arg, i32 0
  %vec0 = insertelement <2 x half> undef, half %lhs_elt, i32 0
  %vec1 = insertelement <2 x half> %vec0, half %rhs_arg, i32 1
  ret <2 x half> %vec1
}

; CHECK-LABEL: test_v2fe0_v2fe0:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_v2fe0_v2fe0(<2 x half> %lhs_arg, <2 x half> %lhs_pad, <2 x half> %rhs_arg, <2 x half> %rhs_pad) {
  %lhs_elt = extractelement <2 x half> %lhs_arg, i32 0
  %rhs_elt = extractelement <2 x half> %rhs_arg, i32 0
  %vec0 = insertelement <2 x half> undef, half %lhs_elt, i32 0
  %vec1 = insertelement <2 x half> %vec0, half %rhs_elt, i32 1
  ret <2 x half> %vec1
}

; CHECK-LABEL: test_v2fe0_v2fe1:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a2, $a0
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_v2fe0_v2fe1(<2 x half> %lhs_arg, <2 x half> %lhs_pad, <2 x half> %rhs_arg, <2 x half> %rhs_pad) {
  %lhs_elt = extractelement <2 x half> %lhs_arg, i32 0
  %rhs_elt = extractelement <2 x half> %rhs_arg, i32 1
  %vec0 = insertelement <2 x half> undef, half %lhs_elt, i32 0
  %vec1 = insertelement <2 x half> %vec0, half %rhs_elt, i32 1
  ret <2 x half> %vec1
}

; CHECK-LABEL: test_v2fe0_v4fe0:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_v2fe0_v4fe0(<2 x half> %lhs_arg, <2 x half> %lhs_pad, <4 x half> %rhs_arg) {
  %lhs_elt = extractelement <2 x half> %lhs_arg, i32 0
  %rhs_elt = extractelement <4 x half> %rhs_arg, i32 0
  %vec0 = insertelement <2 x half> undef, half %lhs_elt, i32 0
  %vec1 = insertelement <2 x half> %vec0, half %rhs_elt, i32 1
  ret <2 x half> %vec1
}

; CHECK-LABEL: test_v2fe0_v4fe1:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a2, $a0
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_v2fe0_v4fe1(<2 x half> %lhs_arg, <2 x half> %lhs_pad, <4 x half> %rhs_arg) {
  %lhs_elt = extractelement <2 x half> %lhs_arg, i32 0
  %rhs_elt = extractelement <4 x half> %rhs_arg, i32 1
  %vec0 = insertelement <2 x half> undef, half %lhs_elt, i32 0
  %vec1 = insertelement <2 x half> %vec0, half %rhs_elt, i32 1
  ret <2 x half> %vec1
}

; CHECK-LABEL: test_v2fe0_v4fe2:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a0, $a3
; CHECK-NEXT:  br $m10
define <2 x half> @test_v2fe0_v4fe2(<2 x half> %lhs_arg, <2 x half> %lhs_pad, <4 x half> %rhs_arg) {
  %lhs_elt = extractelement <2 x half> %lhs_arg, i32 0
  %rhs_elt = extractelement <4 x half> %rhs_arg, i32 2
  %vec0 = insertelement <2 x half> undef, half %lhs_elt, i32 0
  %vec1 = insertelement <2 x half> %vec0, half %rhs_elt, i32 1
  ret <2 x half> %vec1
}

; CHECK-LABEL: test_v2fe0_v4fe3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a3, $a0
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_v2fe0_v4fe3(<2 x half> %lhs_arg, <2 x half> %lhs_pad, <4 x half> %rhs_arg) {
  %lhs_elt = extractelement <2 x half> %lhs_arg, i32 0
  %rhs_elt = extractelement <4 x half> %rhs_arg, i32 3
  %vec0 = insertelement <2 x half> undef, half %lhs_elt, i32 0
  %vec1 = insertelement <2 x half> %vec0, half %rhs_elt, i32 1
  ret <2 x half> %vec1
}

; CHECK-LABEL: test_v2fe1_f16:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_v2fe1_f16(<2 x half> %lhs_arg, <2 x half> %lhs_pad, half %rhs_arg, half %rhs_pad) {
  %lhs_elt = extractelement <2 x half> %lhs_arg, i32 1
  %vec0 = insertelement <2 x half> undef, half %lhs_elt, i32 0
  %vec1 = insertelement <2 x half> %vec0, half %rhs_arg, i32 1
  ret <2 x half> %vec1
}

; CHECK-LABEL: test_v2fe1_v2fe0:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_v2fe1_v2fe0(<2 x half> %lhs_arg, <2 x half> %lhs_pad, <2 x half> %rhs_arg, <2 x half> %rhs_pad) {
  %lhs_elt = extractelement <2 x half> %lhs_arg, i32 1
  %rhs_elt = extractelement <2 x half> %rhs_arg, i32 0
  %vec0 = insertelement <2 x half> undef, half %lhs_elt, i32 0
  %vec1 = insertelement <2 x half> %vec0, half %rhs_elt, i32 1
  ret <2 x half> %vec1
}

; CHECK-LABEL: test_v2fe1_v2fe1:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_v2fe1_v2fe1(<2 x half> %lhs_arg, <2 x half> %lhs_pad, <2 x half> %rhs_arg, <2 x half> %rhs_pad) {
  %lhs_elt = extractelement <2 x half> %lhs_arg, i32 1
  %rhs_elt = extractelement <2 x half> %rhs_arg, i32 1
  %vec0 = insertelement <2 x half> undef, half %lhs_elt, i32 0
  %vec1 = insertelement <2 x half> %vec0, half %rhs_elt, i32 1
  ret <2 x half> %vec1
}

; CHECK-LABEL: test_v2fe1_v4fe0:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_v2fe1_v4fe0(<2 x half> %lhs_arg, <2 x half> %lhs_pad, <4 x half> %rhs_arg) {
  %lhs_elt = extractelement <2 x half> %lhs_arg, i32 1
  %rhs_elt = extractelement <4 x half> %rhs_arg, i32 0
  %vec0 = insertelement <2 x half> undef, half %lhs_elt, i32 0
  %vec1 = insertelement <2 x half> %vec0, half %rhs_elt, i32 1
  ret <2 x half> %vec1
}

; CHECK-LABEL: test_v2fe1_v4fe1:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_v2fe1_v4fe1(<2 x half> %lhs_arg, <2 x half> %lhs_pad, <4 x half> %rhs_arg) {
  %lhs_elt = extractelement <2 x half> %lhs_arg, i32 1
  %rhs_elt = extractelement <4 x half> %rhs_arg, i32 1
  %vec0 = insertelement <2 x half> undef, half %lhs_elt, i32 0
  %vec1 = insertelement <2 x half> %vec0, half %rhs_elt, i32 1
  ret <2 x half> %vec1
}

; CHECK-LABEL: test_v2fe1_v4fe2:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a0, $a3
; CHECK-NEXT:  br $m10
define <2 x half> @test_v2fe1_v4fe2(<2 x half> %lhs_arg, <2 x half> %lhs_pad, <4 x half> %rhs_arg) {
  %lhs_elt = extractelement <2 x half> %lhs_arg, i32 1
  %rhs_elt = extractelement <4 x half> %rhs_arg, i32 2
  %vec0 = insertelement <2 x half> undef, half %lhs_elt, i32 0
  %vec1 = insertelement <2 x half> %vec0, half %rhs_elt, i32 1
  ret <2 x half> %vec1
}

; CHECK-LABEL: test_v2fe1_v4fe3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a0, $a3
; CHECK-NEXT:  br $m10
define <2 x half> @test_v2fe1_v4fe3(<2 x half> %lhs_arg, <2 x half> %lhs_pad, <4 x half> %rhs_arg) {
  %lhs_elt = extractelement <2 x half> %lhs_arg, i32 1
  %rhs_elt = extractelement <4 x half> %rhs_arg, i32 3
  %vec0 = insertelement <2 x half> undef, half %lhs_elt, i32 0
  %vec1 = insertelement <2 x half> %vec0, half %rhs_elt, i32 1
  ret <2 x half> %vec1
}

; CHECK-LABEL: test_v4fe0_f16:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_v4fe0_f16(<4 x half> %lhs_arg, half %rhs_arg, half %rhs_pad) {
  %lhs_elt = extractelement <4 x half> %lhs_arg, i32 0
  %vec0 = insertelement <2 x half> undef, half %lhs_elt, i32 0
  %vec1 = insertelement <2 x half> %vec0, half %rhs_arg, i32 1
  ret <2 x half> %vec1
}

; CHECK-LABEL: test_v4fe0_v2fe0:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_v4fe0_v2fe0(<4 x half> %lhs_arg, <2 x half> %rhs_arg, <2 x half> %rhs_pad) {
  %lhs_elt = extractelement <4 x half> %lhs_arg, i32 0
  %rhs_elt = extractelement <2 x half> %rhs_arg, i32 0
  %vec0 = insertelement <2 x half> undef, half %lhs_elt, i32 0
  %vec1 = insertelement <2 x half> %vec0, half %rhs_elt, i32 1
  ret <2 x half> %vec1
}

; CHECK-LABEL: test_v4fe0_v2fe1:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a2, $a0
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_v4fe0_v2fe1(<4 x half> %lhs_arg, <2 x half> %rhs_arg, <2 x half> %rhs_pad) {
  %lhs_elt = extractelement <4 x half> %lhs_arg, i32 0
  %rhs_elt = extractelement <2 x half> %rhs_arg, i32 1
  %vec0 = insertelement <2 x half> undef, half %lhs_elt, i32 0
  %vec1 = insertelement <2 x half> %vec0, half %rhs_elt, i32 1
  ret <2 x half> %vec1
}

; CHECK-LABEL: test_v4fe0_v4fe0:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_v4fe0_v4fe0(<4 x half> %lhs_arg, <4 x half> %rhs_arg) {
  %lhs_elt = extractelement <4 x half> %lhs_arg, i32 0
  %rhs_elt = extractelement <4 x half> %rhs_arg, i32 0
  %vec0 = insertelement <2 x half> undef, half %lhs_elt, i32 0
  %vec1 = insertelement <2 x half> %vec0, half %rhs_elt, i32 1
  ret <2 x half> %vec1
}

; CHECK-LABEL: test_v4fe0_v4fe1:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a2, $a0
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_v4fe0_v4fe1(<4 x half> %lhs_arg, <4 x half> %rhs_arg) {
  %lhs_elt = extractelement <4 x half> %lhs_arg, i32 0
  %rhs_elt = extractelement <4 x half> %rhs_arg, i32 1
  %vec0 = insertelement <2 x half> undef, half %lhs_elt, i32 0
  %vec1 = insertelement <2 x half> %vec0, half %rhs_elt, i32 1
  ret <2 x half> %vec1
}

; CHECK-LABEL: test_v4fe0_v4fe2:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a0, $a3
; CHECK-NEXT:  br $m10
define <2 x half> @test_v4fe0_v4fe2(<4 x half> %lhs_arg, <4 x half> %rhs_arg) {
  %lhs_elt = extractelement <4 x half> %lhs_arg, i32 0
  %rhs_elt = extractelement <4 x half> %rhs_arg, i32 2
  %vec0 = insertelement <2 x half> undef, half %lhs_elt, i32 0
  %vec1 = insertelement <2 x half> %vec0, half %rhs_elt, i32 1
  ret <2 x half> %vec1
}

; CHECK-LABEL: test_v4fe0_v4fe3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a3, $a0
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_v4fe0_v4fe3(<4 x half> %lhs_arg, <4 x half> %rhs_arg) {
  %lhs_elt = extractelement <4 x half> %lhs_arg, i32 0
  %rhs_elt = extractelement <4 x half> %rhs_arg, i32 3
  %vec0 = insertelement <2 x half> undef, half %lhs_elt, i32 0
  %vec1 = insertelement <2 x half> %vec0, half %rhs_elt, i32 1
  ret <2 x half> %vec1
}

; CHECK-LABEL: test_v4fe1_f16:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_v4fe1_f16(<4 x half> %lhs_arg, half %rhs_arg, half %rhs_pad) {
  %lhs_elt = extractelement <4 x half> %lhs_arg, i32 1
  %vec0 = insertelement <2 x half> undef, half %lhs_elt, i32 0
  %vec1 = insertelement <2 x half> %vec0, half %rhs_arg, i32 1
  ret <2 x half> %vec1
}

; CHECK-LABEL: test_v4fe1_v2fe0:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_v4fe1_v2fe0(<4 x half> %lhs_arg, <2 x half> %rhs_arg, <2 x half> %rhs_pad) {
  %lhs_elt = extractelement <4 x half> %lhs_arg, i32 1
  %rhs_elt = extractelement <2 x half> %rhs_arg, i32 0
  %vec0 = insertelement <2 x half> undef, half %lhs_elt, i32 0
  %vec1 = insertelement <2 x half> %vec0, half %rhs_elt, i32 1
  ret <2 x half> %vec1
}

; CHECK-LABEL: test_v4fe1_v2fe1:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_v4fe1_v2fe1(<4 x half> %lhs_arg, <2 x half> %rhs_arg, <2 x half> %rhs_pad) {
  %lhs_elt = extractelement <4 x half> %lhs_arg, i32 1
  %rhs_elt = extractelement <2 x half> %rhs_arg, i32 1
  %vec0 = insertelement <2 x half> undef, half %lhs_elt, i32 0
  %vec1 = insertelement <2 x half> %vec0, half %rhs_elt, i32 1
  ret <2 x half> %vec1
}

; CHECK-LABEL: test_v4fe1_v4fe0:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_v4fe1_v4fe0(<4 x half> %lhs_arg, <4 x half> %rhs_arg) {
  %lhs_elt = extractelement <4 x half> %lhs_arg, i32 1
  %rhs_elt = extractelement <4 x half> %rhs_arg, i32 0
  %vec0 = insertelement <2 x half> undef, half %lhs_elt, i32 0
  %vec1 = insertelement <2 x half> %vec0, half %rhs_elt, i32 1
  ret <2 x half> %vec1
}

; CHECK-LABEL: test_v4fe1_v4fe1:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_v4fe1_v4fe1(<4 x half> %lhs_arg, <4 x half> %rhs_arg) {
  %lhs_elt = extractelement <4 x half> %lhs_arg, i32 1
  %rhs_elt = extractelement <4 x half> %rhs_arg, i32 1
  %vec0 = insertelement <2 x half> undef, half %lhs_elt, i32 0
  %vec1 = insertelement <2 x half> %vec0, half %rhs_elt, i32 1
  ret <2 x half> %vec1
}

; CHECK-LABEL: test_v4fe1_v4fe2:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a0, $a3
; CHECK-NEXT:  br $m10
define <2 x half> @test_v4fe1_v4fe2(<4 x half> %lhs_arg, <4 x half> %rhs_arg) {
  %lhs_elt = extractelement <4 x half> %lhs_arg, i32 1
  %rhs_elt = extractelement <4 x half> %rhs_arg, i32 2
  %vec0 = insertelement <2 x half> undef, half %lhs_elt, i32 0
  %vec1 = insertelement <2 x half> %vec0, half %rhs_elt, i32 1
  ret <2 x half> %vec1
}

; CHECK-LABEL: test_v4fe1_v4fe3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a0, $a3
; CHECK-NEXT:  br $m10
define <2 x half> @test_v4fe1_v4fe3(<4 x half> %lhs_arg, <4 x half> %rhs_arg) {
  %lhs_elt = extractelement <4 x half> %lhs_arg, i32 1
  %rhs_elt = extractelement <4 x half> %rhs_arg, i32 3
  %vec0 = insertelement <2 x half> undef, half %lhs_elt, i32 0
  %vec1 = insertelement <2 x half> %vec0, half %rhs_elt, i32 1
  ret <2 x half> %vec1
}

; CHECK-LABEL: test_v4fe2_f16:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a1, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_v4fe2_f16(<4 x half> %lhs_arg, half %rhs_arg, half %rhs_pad) {
  %lhs_elt = extractelement <4 x half> %lhs_arg, i32 2
  %vec0 = insertelement <2 x half> undef, half %lhs_elt, i32 0
  %vec1 = insertelement <2 x half> %vec0, half %rhs_arg, i32 1
  ret <2 x half> %vec1
}

; CHECK-LABEL: test_v4fe2_v2fe0:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a1, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_v4fe2_v2fe0(<4 x half> %lhs_arg, <2 x half> %rhs_arg, <2 x half> %rhs_pad) {
  %lhs_elt = extractelement <4 x half> %lhs_arg, i32 2
  %rhs_elt = extractelement <2 x half> %rhs_arg, i32 0
  %vec0 = insertelement <2 x half> undef, half %lhs_elt, i32 0
  %vec1 = insertelement <2 x half> %vec0, half %rhs_elt, i32 1
  ret <2 x half> %vec1
}

; CHECK-LABEL: test_v4fe2_v2fe1:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a2, $a1
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_v4fe2_v2fe1(<4 x half> %lhs_arg, <2 x half> %rhs_arg, <2 x half> %rhs_pad) {
  %lhs_elt = extractelement <4 x half> %lhs_arg, i32 2
  %rhs_elt = extractelement <2 x half> %rhs_arg, i32 1
  %vec0 = insertelement <2 x half> undef, half %lhs_elt, i32 0
  %vec1 = insertelement <2 x half> %vec0, half %rhs_elt, i32 1
  ret <2 x half> %vec1
}

; CHECK-LABEL: test_v4fe2_v4fe0:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a1, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_v4fe2_v4fe0(<4 x half> %lhs_arg, <4 x half> %rhs_arg) {
  %lhs_elt = extractelement <4 x half> %lhs_arg, i32 2
  %rhs_elt = extractelement <4 x half> %rhs_arg, i32 0
  %vec0 = insertelement <2 x half> undef, half %lhs_elt, i32 0
  %vec1 = insertelement <2 x half> %vec0, half %rhs_elt, i32 1
  ret <2 x half> %vec1
}

; CHECK-LABEL: test_v4fe2_v4fe1:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a2, $a1
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_v4fe2_v4fe1(<4 x half> %lhs_arg, <4 x half> %rhs_arg) {
  %lhs_elt = extractelement <4 x half> %lhs_arg, i32 2
  %rhs_elt = extractelement <4 x half> %rhs_arg, i32 1
  %vec0 = insertelement <2 x half> undef, half %lhs_elt, i32 0
  %vec1 = insertelement <2 x half> %vec0, half %rhs_elt, i32 1
  ret <2 x half> %vec1
}

; CHECK-LABEL: test_v4fe2_v4fe2:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a1, $a3
; CHECK-NEXT:  br $m10
define <2 x half> @test_v4fe2_v4fe2(<4 x half> %lhs_arg, <4 x half> %rhs_arg) {
  %lhs_elt = extractelement <4 x half> %lhs_arg, i32 2
  %rhs_elt = extractelement <4 x half> %rhs_arg, i32 2
  %vec0 = insertelement <2 x half> undef, half %lhs_elt, i32 0
  %vec1 = insertelement <2 x half> %vec0, half %rhs_elt, i32 1
  ret <2 x half> %vec1
}

; CHECK-LABEL: test_v4fe2_v4fe3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a3, $a1
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_v4fe2_v4fe3(<4 x half> %lhs_arg, <4 x half> %rhs_arg) {
  %lhs_elt = extractelement <4 x half> %lhs_arg, i32 2
  %rhs_elt = extractelement <4 x half> %rhs_arg, i32 3
  %vec0 = insertelement <2 x half> undef, half %lhs_elt, i32 0
  %vec1 = insertelement <2 x half> %vec0, half %rhs_elt, i32 1
  ret <2 x half> %vec1
}

; CHECK-LABEL: test_v4fe3_f16:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a1, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_v4fe3_f16(<4 x half> %lhs_arg, half %rhs_arg, half %rhs_pad) {
  %lhs_elt = extractelement <4 x half> %lhs_arg, i32 3
  %vec0 = insertelement <2 x half> undef, half %lhs_elt, i32 0
  %vec1 = insertelement <2 x half> %vec0, half %rhs_arg, i32 1
  ret <2 x half> %vec1
}

; CHECK-LABEL: test_v4fe3_v2fe0:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a1, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_v4fe3_v2fe0(<4 x half> %lhs_arg, <2 x half> %rhs_arg, <2 x half> %rhs_pad) {
  %lhs_elt = extractelement <4 x half> %lhs_arg, i32 3
  %rhs_elt = extractelement <2 x half> %rhs_arg, i32 0
  %vec0 = insertelement <2 x half> undef, half %lhs_elt, i32 0
  %vec1 = insertelement <2 x half> %vec0, half %rhs_elt, i32 1
  ret <2 x half> %vec1
}

; CHECK-LABEL: test_v4fe3_v2fe1:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a1, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_v4fe3_v2fe1(<4 x half> %lhs_arg, <2 x half> %rhs_arg, <2 x half> %rhs_pad) {
  %lhs_elt = extractelement <4 x half> %lhs_arg, i32 3
  %rhs_elt = extractelement <2 x half> %rhs_arg, i32 1
  %vec0 = insertelement <2 x half> undef, half %lhs_elt, i32 0
  %vec1 = insertelement <2 x half> %vec0, half %rhs_elt, i32 1
  ret <2 x half> %vec1
}

; CHECK-LABEL: test_v4fe3_v4fe0:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a1, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_v4fe3_v4fe0(<4 x half> %lhs_arg, <4 x half> %rhs_arg) {
  %lhs_elt = extractelement <4 x half> %lhs_arg, i32 3
  %rhs_elt = extractelement <4 x half> %rhs_arg, i32 0
  %vec0 = insertelement <2 x half> undef, half %lhs_elt, i32 0
  %vec1 = insertelement <2 x half> %vec0, half %rhs_elt, i32 1
  ret <2 x half> %vec1
}

; CHECK-LABEL: test_v4fe3_v4fe1:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a1, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_v4fe3_v4fe1(<4 x half> %lhs_arg, <4 x half> %rhs_arg) {
  %lhs_elt = extractelement <4 x half> %lhs_arg, i32 3
  %rhs_elt = extractelement <4 x half> %rhs_arg, i32 1
  %vec0 = insertelement <2 x half> undef, half %lhs_elt, i32 0
  %vec1 = insertelement <2 x half> %vec0, half %rhs_elt, i32 1
  ret <2 x half> %vec1
}

; CHECK-LABEL: test_v4fe3_v4fe2:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a1, $a3
; CHECK-NEXT:  br $m10
define <2 x half> @test_v4fe3_v4fe2(<4 x half> %lhs_arg, <4 x half> %rhs_arg) {
  %lhs_elt = extractelement <4 x half> %lhs_arg, i32 3
  %rhs_elt = extractelement <4 x half> %rhs_arg, i32 2
  %vec0 = insertelement <2 x half> undef, half %lhs_elt, i32 0
  %vec1 = insertelement <2 x half> %vec0, half %rhs_elt, i32 1
  ret <2 x half> %vec1
}

; CHECK-LABEL: test_v4fe3_v4fe3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a1, $a3
; CHECK-NEXT:  br $m10
define <2 x half> @test_v4fe3_v4fe3(<4 x half> %lhs_arg, <4 x half> %rhs_arg) {
  %lhs_elt = extractelement <4 x half> %lhs_arg, i32 3
  %rhs_elt = extractelement <4 x half> %rhs_arg, i32 3
  %vec0 = insertelement <2 x half> undef, half %lhs_elt, i32 0
  %vec1 = insertelement <2 x half> %vec0, half %rhs_elt, i32 1
  ret <2 x half> %vec1
}
