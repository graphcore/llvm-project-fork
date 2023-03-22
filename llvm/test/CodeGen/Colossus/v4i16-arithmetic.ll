; RUN: llc < %s -mtriple=colossus -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -mtriple=colossus -mattr=+ipu2 | FileCheck %s

; CHECK-LABEL: test_add_v4i16:
; CHECK:       # %bb.0:
; High half of v4i16
; CHECK-NEXT:  swap16 [[HiM3:\$m[0-9]+]], $m3
; CHECK-NEXT:  swap16 [[HiM1:\$m[0-9]+]], $m1
; CHECK-NEXT:  add [[LoM1M3:\$m[0-9]+]], $m1, $m3
; CHECK-NEXT:  add [[HiM1M3:\$m[0-9]+]], [[HiM1]], [[HiM3]]
; Low half of v4i16
; CHECK-NEXT:  swap16 [[HiM2:\$m[0-9]+]], $m2
; High half of v4i16
; CHECK-NEXT:  sort4x16lo $m1, [[LoM1M3]], [[HiM1M3]]
; Low half of v4i16
; CHECK-NEXT:  add [[LoM0M2:\$m[0-9]+]], $m0, $m2
; CHECK-NEXT:  swap16 [[HiM0:\$m[0-9]+]], $m0
; CHECK-NEXT:  add [[HiM0M2:\$m[0-9]+]], [[HiM0]], [[HiM2]]
; CHECK-NEXT:  sort4x16lo $m0, [[LoM0M2]], [[HiM0M2]]
; CHECK-NEXT:  br $m10
define <4 x i16> @test_add_v4i16(<4 x i16> %a, <4 x i16> %b) {
  %res = add <4 x i16> %a, %b
  ret <4 x i16> %res
}

; CHECK-LABEL: test_sub_v4i16:
; CHECK:       # %bb.0:
; High half of v4i16
; CHECK-NEXT:   swap16 [[HiM1:\$m[0-9]+]], $m1
; CHECK-NEXT:   swap16 [[HiM3:\$m[0-9]+]], $m3
; CHECK-NEXT:   sub [[LoM1M3:\$m[0-9]+]], $m1, $m3
; CHECK-NEXT:   sub [[HiM1M3:\$m[0-9]+]], [[HiM1]], [[HiM3]]
; Low half of v4i16
; CHECK-NEXT:   swap16 [[HiM0:\$m[0-9]+]], $m0
; High half of v4i16
; CHECK-NEXT:   sort4x16lo $m1, [[LoM1M3]], [[HiM1M3]]
; Low half of v4i16
; CHECK-NEXT:   sub [[LoM0M2:\$m[0-9]+]], $m0, $m2
; CHECK-NEXT:   swap16 [[HiM2:\$m[0-9]+]], $m2
; CHECK-NEXT:   sub [[HiM0M2:\$m[0-9]+]], [[HiM0]], [[HiM2]]
; CHECK-NEXT:   sort4x16lo $m0, [[LoM0M2]], [[HiM0M2]]
; CHECK-NEXT:   br $m10
define <4 x i16> @test_sub_v4i16(<4 x i16> %a, <4 x i16> %b) {
  %res = sub <4 x i16> %a, %b
  ret <4 x i16> %res
}

; CHECK-LABEL: test_mul_v4i16:
; CHECK:       # %bb.0:
; High half of v4i16
; CHECK-NEXT:  swap16 [[HiM3:\$m[0-9]+]], $m3
; CHECK-NEXT:  swap16 [[HiM1:\$m[0-9]+]], $m1
; CHECK-NEXT:  mul [[LoM1M3:\$m[0-9]+]], $m1, $m3
; CHECK-NEXT:  mul [[HiM1M3:\$m[0-9]+]], [[HiM1]], [[HiM3]]
; Low half of v4i16
; CHECK-NEXT:  swap16 [[HiM2:\$m[0-9]+]], $m2
; High half of v4i16
; CHECK-NEXT:  sort4x16lo $m1, [[LoM1M3]], [[HiM1M3]]
; Low half of v4i16
; CHECK-NEXT:  mul [[LoM0M2:\$m[0-9]+]], $m0, $m2
; CHECK-NEXT:  swap16 [[HiM0:\$m[0-9]+]], $m0
; CHECK-NEXT:  mul [[HiM0M2:\$m[0-9]+]], [[HiM0]], [[HiM2]]
; CHECK-NEXT:  sort4x16lo $m0, [[LoM0M2]], [[HiM0M2]]
; CHECK-NEXT:  br $m10
define <4 x i16> @test_mul_v4i16(<4 x i16> %a, <4 x i16> %b) {
  %res = mul <4 x i16> %a, %b
  ret <4 x i16> %res
}

; CHECK-LABEL: test_or_v4i16:
; CHECK:       # %bb.0:
; CHECK-DAG:   or $m0, $m0, $m2
; CHECK-DAG:   or $m1, $m1, $m3
; CHECK-NEXT:  br $m10
define <4 x i16> @test_or_v4i16(<4 x i16> %a, <4 x i16> %b) {
  %res = or <4 x i16> %a, %b
  ret <4 x i16> %res
}

; CHECK-LABEL: test_and_v4i16:
; CHECK:       # %bb.0:
; CHECK-DAG:   and $m0, $m0, $m2
; CHECK-DAG:   and $m1, $m1, $m3
; CHECK-NEXT:  br $m10
define <4 x i16> @test_and_v4i16(<4 x i16> %a, <4 x i16> %b) {
  %res = and <4 x i16> %a, %b
  ret <4 x i16> %res
}

; CHECK-LABEL: test_xor_v4i16:
; CHECK:       # %bb.0:
; CHECK-DAG:   xor $m0, $m0, $m2
; CHECK-DAG:   xor $m1, $m1, $m3
; CHECK-NEXT:  br $m10
define <4 x i16> @test_xor_v4i16(<4 x i16> %a, <4 x i16> %b) {
  %res = xor <4 x i16> %a, %b
  ret <4 x i16> %res
}

; CHECK-LABEL: test_not_v4i16:
; CHECK:       # %bb.0:
; CHECK-DAG:   xnor $m0, $m0, $m15
; CHECK-DAG:   xnor $m1, $m1, $m15
; CHECK-NEXT:  br $m10
define <4 x i16> @test_not_v4i16(<4 x i16> %a) {
  %res = xor <4 x i16> %a, <i16 -1, i16 -1, i16 -1, i16 -1>
  ret <4 x i16> %res
}

; CHECK-LABEL: test_andc_v4i16:
; CHECK:       # %bb.0:
; CHECK-DAG:   andc $m0, $m0, $m2
; CHECK-DAG:   andc $m1, $m1, $m3
; CHECK-NEXT:  br $m10
define <4 x i16> @test_andc_v4i16(<4 x i16> %a, <4 x i16> %b) {
  %notb = xor <4 x i16> %b, <i16 -1, i16 -1, i16 -1, i16 -1>
  %res = and <4 x i16> %a, %notb
  ret <4 x i16> %res
}

; CHECK-LABEL: test_andcr_v4i16:
; CHECK:       # %bb.0:
; CHECK-DAG:   andc $m0, $m2, $m0
; CHECK-DAG:   andc $m1, $m3, $m1
; CHECK-NEXT:  br $m10
define <4 x i16> @test_andcr_v4i16(<4 x i16> %a, <4 x i16> %b) {
  %nota = xor <4 x i16> %a, <i16 -1, i16 -1, i16 -1, i16 -1>
  %res = and <4 x i16> %nota, %b
  ret <4 x i16> %res
}
