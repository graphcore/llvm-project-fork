; RUN: llc < %s -mtriple=colossus -colossus-coissue=false -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -mtriple=colossus -colossus-coissue=false -mattr=+ipu2 | FileCheck %s
target triple = "colossus-graphcore--elf"

; CHECK-LABEL: test_abs_f16:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a1, 32768
; CHECK-NEXT:  or $a1, $a1, 2147483648
; CHECK-NEXT:  andc $a0, $a0, $a1
; CHECK-NEXT:  br $m10
declare half @llvm.fabs.f16(half %x)
define half @test_abs_f16(half %x) {
  %res = call half @llvm.fabs.f16(half %x)
  ret half %res
}

; CHECK-LABEL: test_abs_f32:
; CHECK:       # %bb
; CHECK-NEXT:  andc $a0, $a0, 2147483648
; CHECK-NEXT:  br $m10
declare float @llvm.fabs.f32(float %x)
define float @test_abs_f32(float %x) {
  %res = call float @llvm.fabs.f32(float %x)
  ret float %res
}

; CHECK-LABEL: test_abs_v2f16:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a1, 32768
; CHECK-NEXT:  or $a1, $a1, {{-?2147483648}}
; CHECK-NEXT:  andc $a0, $a0, $a1
; CHECK-NEXT:  br $m10
declare <2 x half> @llvm.fabs.v2f16(<2 x half> %x)
define <2 x half> @test_abs_v2f16(<2 x half> %x) {
  %res = call <2 x half> @llvm.fabs.v2f16(<2 x half> %x)
  ret <2 x half> %res
}

; CHECK-LABEL: test_abs_v2f32:
; CHECK:       # %bb
; CHECK-NEXT:  or $a2, $a15, {{-?2147483648}}
; CHECK-NEXT:  mov $a3, $a2
; CHECK-NEXT:  andc64 $a0:1, $a0:1, $a2:3
; CHECK-NEXT:  br $m10
declare <2 x float> @llvm.fabs.v2f32(<2 x float> %x)
define <2 x float> @test_abs_v2f32(<2 x float> %x) {
  %res = call <2 x float> @llvm.fabs.v2f32(<2 x float> %x)
  ret <2 x float> %res
}

; CHECK-LABEL: test_abs_v4f16:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a2, 32768
; CHECK-NEXT:  or $a2, $a2, {{-?2147483648}}
; CHECK-NEXT:  mov $a3, $a2
; CHECK-NEXT:  andc64 $a0:1, $a0:1, $a2:3
; CHECK-NEXT:  br $m10
declare <4 x half> @llvm.fabs.v4f16(<4 x half> %x)
define <4 x half> @test_abs_v4f16(<4 x half> %x) {
  %res = call <4 x half> @llvm.fabs.v4f16(<4 x half> %x)
  ret <4 x half> %res
}

; CHECK-LABEL: test_copysign_f16:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a2, 32768
; CHECK-NEXT:  or $a2, $a2, {{-?2147483648}}
; CHECK-NEXT:  andc $a0, $a0, $a2
; CHECK-NEXT:  sort4x16lo $a1, $a1, $a1
; CHECK-NEXT:  and $a1, $a1, $a2
; CHECK-NEXT:  or $a0, $a1, $a0
; CHECK-NEXT:  br $m10
declare half @llvm.copysign.f16(half %x, half %y)
define half @test_copysign_f16(half %x, half %y) {
  %res = call half @llvm.copysign.f16(half %x, half %y)
  ret half %res
}

; CHECK-LABEL: test_copysign_f32:
; CHECK:       # %bb
; CHECK-NEXT:  andc $a0, $a0, 2147483648
; CHECK-NEXT:  and $a1, $a1, 2147483648
; CHECK-NEXT:  or $a0, $a1, $a0
; CHECK-NEXT:  br $m10
declare float @llvm.copysign.f32(float %x, float %y)
define float @test_copysign_f32(float %x, float %y) {
  %res = call float @llvm.copysign.f32(float %x, float %y)
  ret float %res
}

; CHECK-LABEL: test_copysign_v2f16:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a2, 32768
; CHECK-NEXT:  or $a2, $a2, 2147483648
; CHECK-NEXT:  andc $a0, $a0, $a2
; CHECK-NEXT:  and $a1, $a1, $a2
; CHECK-NEXT:  or $a0, $a1, $a0
; CHECK-NEXT:  br $m10
declare <2 x half> @llvm.copysign.v2f16(<2 x half> %x, <2 x half> %y)
define <2 x half> @test_copysign_v2f16(<2 x half> %x, <2 x half> %y) {
  %res = call <2 x half> @llvm.copysign.v2f16(<2 x half> %x, <2 x half> %y)
  ret <2 x half> %res
}

; CHECK-LABEL: test_copysign_v2f32:
; CHECK:       # %bb
; CHECK-NEXT:  or $a4, $a15, 2147483648
; CHECK-NEXT:  mov $a5, $a4
; CHECK-NEXT:  andc64 $a0:1, $a0:1, $a4:5
; CHECK-NEXT:  and64 $a2:3, $a2:3, $a4:5
; CHECK-NEXT:  or64 $a0:1, $a2:3, $a0:1
; CHECK-NEXT:  br $m10
declare <2 x float> @llvm.copysign.v2f32(<2 x float> %x, <2 x float> %y)
define <2 x float> @test_copysign_v2f32(<2 x float> %x, <2 x float> %y) {
  %res = call <2 x float> @llvm.copysign.v2f32(<2 x float> %x, <2 x float> %y)
  ret <2 x float> %res
}

; CHECK-LABEL: test_copysign_v4f16:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a4, 32768
; CHECK-NEXT:  or $a4, $a4, 2147483648
; CHECK-NEXT:  mov $a5, $a4
; CHECK-NEXT:  andc64 $a0:1, $a0:1, $a4:5
; CHECK-NEXT:  and64 $a2:3, $a2:3, $a4:5
; CHECK-NEXT:  or64 $a0:1, $a2:3, $a0:1
; CHECK-NEXT:  br $m10
declare <4 x half> @llvm.copysign.v4f16(<4 x half> %x, <4 x half> %y)
define <4 x half> @test_copysign_v4f16(<4 x half> %x, <4 x half> %y) {
  %res = call <4 x half> @llvm.copysign.v4f16(<4 x half> %x, <4 x half> %y)
  ret <4 x half> %res
}
