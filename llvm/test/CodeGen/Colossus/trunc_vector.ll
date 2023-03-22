; RUN: llc < %s -march=colossus -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -march=colossus -mattr=+ipu2 | FileCheck %s

; CHECK-LABEL: i64_to_i32_v2:
; CHECK: 	     mov	$m1, $m2
; CHECK-NEXT:  br $m10
define <2 x i32> @i64_to_i32_v2(<2 x i64> %x) {
  %y = trunc <2 x i64> %x to <2 x i32>
  ret <2 x i32> %y
}

; CHECK-LABEL: i64_to_i32_v4:
; CHECK: 	     mov	$m1, $m2
; CHECK-NEXT:  ld32 $m3, $m11, $m15, 2
; CHECK-NEXT:  ld32 $m2, $m11, $m15, 0
; CHECK-NEXT:  br $m10
define <4 x i32> @i64_to_i32_v4(<4 x i64> %x) {
  %y = trunc <4 x i64> %x to <4 x i32>
  ret <4 x i32> %y
}

; CHECK-LABEL: i64_to_i16_v2:
; CHECK: 	     sort4x16lo $m0, $m0, $m2
; CHECK-NEXT:  br $m10
define <2 x i16> @i64_to_i16_v2(<2 x i64> %x) {
  %y = trunc <2 x i64> %x to <2 x i16>
  ret <2 x i16> %y
}

; CHECK-LABEL: i64_to_i16_v4:
; CHECK: 	     ld32 $m1, $m11, $m15, 2
; CHECK-NEXT:  ld32 $m3, $m11, $m15, 0
; CHECK-NEXT:  sort4x16lo $m1, $m3, $m1
; CHECK-NEXT:  sort4x16lo $m0, $m0, $m2
; CHECK-NEXT:  br $m10
define <4 x i16> @i64_to_i16_v4(<4 x i64> %x) {
  %y = trunc <4 x i64> %x to <4 x i16>
  ret <4 x i16> %y
}

; CHECK-LABEL: i64_to_i8_v2:
; CHECK: 	     sort4x16lo $m0, $m0, $m2
; CHECK-NEXT:  br $m10
define <2 x i8> @i64_to_i8_v2(<2 x i64> %x) {
  %y = trunc <2 x i64> %x to <2 x i8>
  ret <2 x i8> %y
}

; CHECK-LABEL: i64_to_i8_v4:
; CHECK: 	     ld32 $m1, $m11, $m15, 2
; CHECK-NEXT:  ld32 $m3, $m11, $m15, 0
; CHECK-NEXT:  sort4x16lo $m1, $m3, $m1
; CHECK-NEXT:  sort4x16lo $m0, $m0, $m2
; CHECK-NEXT:  br $m10
define <4 x i8> @i64_to_i8_v4(<4 x i64> %x) {
  %y = trunc <4 x i64> %x to <4 x i8>
  ret <4 x i8> %y
}

; CHECK-LABEL: i32_to_i16_v2:
; CHECK: 	     sort4x16lo $m0, $m0, $m1
; CHECK-NEXT:  br $m10
define <2 x i16> @i32_to_i16_v2(<2 x i32> %x) {
  %y = trunc <2 x i32> %x to <2 x i16>
  ret <2 x i16> %y
}

; CHECK-LABEL: i32_to_i16_v4:
; CHECK: 	     sort4x16lo $m3, $m2, $m3
; CHECK-NEXT:  sort4x16lo $m2, $m0, $m1
; CHECK-NEXT:  mov	$m0, $m2
; CHECK-NEXT:  mov	$m1, $m3
; CHECK-NEXT:  br $m10
define <4 x i16> @i32_to_i16_v4(<4 x i32> %x) {
  %y = trunc <4 x i32> %x to <4 x i16>
  ret <4 x i16> %y
}

; CHECK-LABEL: i32_to_i8_v2:
; CHECK: 	     sort4x16lo $m0, $m0, $m1
; CHECK-NEXT:  br $m10
define <2 x i8> @i32_to_i8_v2(<2 x i32> %x) {
  %y = trunc <2 x i32> %x to <2 x i8>
  ret <2 x i8> %y
}

; CHECK-LABEL: i32_to_i8_v4:
; CHECK: 	     sort4x16lo $m3, $m2, $m3
; CHECK-NEXT:  sort4x16lo $m2, $m0, $m1
; CHECK-NEXT:  mov	$m0, $m2
; CHECK-NEXT:  mov	$m1, $m3
; CHECK-NEXT:  br $m10
define <4 x i8> @i32_to_i8_v4(<4 x i32> %x) {
  %y = trunc <4 x i32> %x to <4 x i8>
  ret <4 x i8> %y
}

; CHECK-LABEL: float_to_half_v2:
; CHECK: 	     {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f32v2tof16 $a0, $a0:1
; CHECK-NEXT:  }
define <2 x half> @float_to_half_v2(<2 x float> %x) {
  %y = fptrunc <2 x float> %x to <2 x half>
  ret <2 x half> %y
}

; CHECK-LABEL: float_to_half_v4:
; CHECK: 	     f32v2tof16 $a0, $a0:1
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f32v2tof16 $a1, $a2:3
; CHECK-NEXT:  }
define <4 x half> @float_to_half_v4(<4 x float> %x) {
  %y = fptrunc <4 x float> %x to <4 x half>
  ret <4 x half> %y
}

; CHECK-LABEL: i16_to_i8_v2:
; CHECK: 	     br $m10
define <2 x i8> @i16_to_i8_v2(<2 x i16> %x) {
  %y = trunc <2 x i16> %x to <2 x i8>
  ret <2 x i8> %y
}

; CHECK-LABEL: i16_to_i8_v4:
; CHECK: 	     br $m10
define <4 x i8> @i16_to_i8_v4(<4 x i16> %x) {
  %y = trunc <4 x i16> %x to <4 x i8>
  ret <4 x i8> %y
}

