; RUN: llc < %s -mtriple=colossus -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -mtriple=colossus -mattr=+ipu2 | FileCheck %s

; CHECK-LABEL: test_add_v2i16:
; CHECK:       # %bb.0:
; CHECK-DAG:   swap16 [[REG1:\$m[0-9]+]], $m1
; CHECK-DAG:   add [[REG:\$m[0-9]+]], $m0, $m1
; CHECK-DAG:   swap16 [[REG0:\$m[0-9]+]], $m0
; CHECK:       add [[REG2:\$m[0-9]+]], [[REG0]], [[REG1]]
; CHECK-NEXT:  sort4x16lo $m0, [[REG]], [[REG2]]
; CHECK-NEXT:  br $m10
define <2 x i16> @test_add_v2i16(<2 x i16> %a, <2 x i16> %b) {
  %res = add <2 x i16> %a, %b
  ret <2 x i16> %res
}

; CHECK-LABEL: test_sub_v2i16:
; CHECK:       # %bb.0:
; CHECK-DAG:   swap16 [[REG1:\$m[0-9]+]], $m1
; CHECK-DAG:   sub [[REG:\$m[0-9]+]], $m0, $m1
; CHECK-DAG:   swap16 [[REG0:\$m[0-9]+]], $m0
; CHECK:       sub [[REG2:\$m[0-9]+]], [[REG0]], [[REG1]]
; CHECK-NEXT:  sort4x16lo $m0, [[REG]], [[REG2]]
; CHECK-NEXT:  br $m10
define <2 x i16> @test_sub_v2i16(<2 x i16> %a, <2 x i16> %b) {
  %res = sub <2 x i16> %a, %b
  ret <2 x i16> %res
}

; CHECK-LABEL: test_mul_v2i16:
; CHECK:       # %bb.0:
; CHECK-DAG:   swap16 [[REG1:\$m[0-9]+]], $m1
; CHECK-DAG:   mul [[REG:\$m[0-9]+]], $m0, $m1
; CHECK-DAG:   swap16 [[REG0:\$m[0-9]+]], $m0
; CHECK:       mul [[REG2:\$m[0-9]+]], [[REG0]], [[REG1]]
; CHECK-NEXT:  sort4x16lo $m0, [[REG]], [[REG2]]
; CHECK-NEXT:  br $m10
define <2 x i16> @test_mul_v2i16(<2 x i16> %a, <2 x i16> %b) {
  %res = mul <2 x i16> %a, %b
  ret <2 x i16> %res
}

; CHECK-LABEL: test_or_v2i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  or $m0, $m0, $m1
; CHECK-NEXT:  br $m10
define <2 x i16> @test_or_v2i16(<2 x i16> %a, <2 x i16> %b) {
  %res = or <2 x i16> %a, %b
  ret <2 x i16> %res
}

; CHECK-LABEL: test_and_v2i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  and $m0, $m0, $m1
; CHECK-NEXT:  br $m10
define <2 x i16> @test_and_v2i16(<2 x i16> %a, <2 x i16> %b) {
  %res = and <2 x i16> %a, %b
  ret <2 x i16> %res
}

; CHECK-LABEL: test_xor_v2i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  xor $m0, $m0, $m1
; CHECK-NEXT:  br $m10
define <2 x i16> @test_xor_v2i16(<2 x i16> %a, <2 x i16> %b) {
  %res = xor <2 x i16> %a, %b
  ret <2 x i16> %res
}

; CHECK-LABEL: test_not_v2i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  xnor $m0, $m0, $m15
; CHECK-NEXT:  br $m10
define <2 x i16> @test_not_v2i16(<2 x i16> %a) {
  %res = xor <2 x i16> %a, <i16 -1, i16 -1>
  ret <2 x i16> %res
}

; CHECK-LABEL: test_andc_v2i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  andc $m0, $m0, $m1
; CHECK-NEXT:  br $m10
define <2 x i16> @test_andc_v2i16(<2 x i16> %a, <2 x i16> %b) {
  %notb = xor <2 x i16> %b, <i16 -1, i16 -1>
  %res = and <2 x i16> %a, %notb
  ret <2 x i16> %res
}

; CHECK-LABEL: test_andcr_v2i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  andc $m0, $m1, $m0
; CHECK-NEXT:  br $m10
define <2 x i16> @test_andcr_v2i16(<2 x i16> %a, <2 x i16> %b) {
  %nota = xor <2 x i16> %a, <i16 -1, i16 -1>
  %res = and <2 x i16> %nota, %b
  ret <2 x i16> %res
}
