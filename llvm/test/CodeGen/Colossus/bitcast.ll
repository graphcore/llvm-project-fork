; RUN: llc < %s -march=colossus -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -march=colossus -mattr=+ipu2 | FileCheck %s
target triple = "colossus-graphcore--elf"

; CHECK-LABEL: bitcast_i16_to_i16:
; CHECK:       # %bb.0:
; CHECK:       br $m10
define signext i16 @bitcast_i16_to_i16(i16 signext %src) {
  %retval = bitcast i16 %src to i16
  ret i16 %retval
}

; CHECK-LABEL: bitcast_i16_to_u16:
; CHECK:       # %bb.0:
; Conversion induced by the ABI
; CHECK-NEXT:  sort4x16lo $m0, $m0, $m15
; CHECK:       br $m10
define zeroext i16 @bitcast_i16_to_u16(i16 signext %src) {
  %retval = bitcast i16 %src to i16
  ret i16 %retval
}

; CHECK-LABEL: bitcast_i16_to_f16:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m0, $m11, $m15, 1
; CHECK-NEXT:  ld32 $a0, $m11, $m15, 1
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10
define half @bitcast_i16_to_f16(i16 signext %src) {
  %retval = bitcast i16 %src to half
  ret half %retval
}

; CHECK-LABEL: bitcast_i32_to_i32:
; CHECK:       # %bb.0:
; CHECK:       br $m10
define signext i32 @bitcast_i32_to_i32(i32 signext %src) {
  %retval = bitcast i32 %src to i32
  ret i32 %retval
}

; CHECK-LABEL: bitcast_i32_to_u32:
; CHECK:       # %bb.0:
; CHECK:       br $m10
define zeroext i32 @bitcast_i32_to_u32(i32 signext %src) {
  %retval = bitcast i32 %src to i32
  ret i32 %retval
}

; CHECK-LABEL: bitcast_i32_to_f32:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m0, $m11, $m15, 1
; CHECK-NEXT:  ld32 $a0, $m11, $m15, 1
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10
define float @bitcast_i32_to_f32(i32 signext %src) {
  %retval = bitcast i32 %src to float
  ret float %retval
}

; CHECK-LABEL: bitcast_i32_to_v2i16:
; CHECK:       # %bb.0:
; CHECK:       br $m10
define <2 x i16> @bitcast_i32_to_v2i16(i32 signext %src) {
  %retval = bitcast i32 %src to <2 x i16>
  ret <2 x i16> %retval
}

; CHECK-LABEL: bitcast_i32_to_v2u16:
; CHECK:       # %bb.0:
; CHECK:       br $m10
define <2 x i16> @bitcast_i32_to_v2u16(i32 signext %src) {
  %retval = bitcast i32 %src to <2 x i16>
  ret <2 x i16> %retval
}

; CHECK-LABEL: bitcast_i32_to_v2f16:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m0, $m11, $m15, 1
; CHECK-NEXT:  ld32 $a0, $m11, $m15, 1
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10
define <2 x half> @bitcast_i32_to_v2f16(i32 signext %src) {
  %retval = bitcast i32 %src to <2 x half>
  ret <2 x half> %retval
}

; CHECK-LABEL: bitcast_u16_to_i16:
; CHECK:       # %bb.0:
; Conversion induced by the ABI

; CHECK-NEXT:  shl $m0, $m0, 16
; CHECK-NEXT:  shrs $m0, $m0, 16
; CHECK:       br $m10
define signext i16 @bitcast_u16_to_i16(i16 zeroext %src) {
  %retval = bitcast i16 %src to i16
  ret i16 %retval
}

; CHECK-LABEL: bitcast_u16_to_u16:
; CHECK:       # %bb.0:
; CHECK:       br $m10
define zeroext i16 @bitcast_u16_to_u16(i16 zeroext %src) {
  %retval = bitcast i16 %src to i16
  ret i16 %retval
}

; CHECK-LABEL: bitcast_u16_to_f16:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m0, $m11, $m15, 1
; CHECK-NEXT:  ld32 $a0, $m11, $m15, 1
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10
define half @bitcast_u16_to_f16(i16 zeroext %src) {
  %retval = bitcast i16 %src to half
  ret half %retval
}

; CHECK-LABEL: bitcast_u32_to_i32:
; CHECK:       # %bb.0:
; CHECK:       br $m10
define signext i32 @bitcast_u32_to_i32(i32 zeroext %src) {
  %retval = bitcast i32 %src to i32
  ret i32 %retval
}

; CHECK-LABEL: bitcast_u32_to_u32:
; CHECK:       # %bb.0:
; CHECK:       br $m10
define zeroext i32 @bitcast_u32_to_u32(i32 zeroext %src) {
  %retval = bitcast i32 %src to i32
  ret i32 %retval
}

; CHECK-LABEL: bitcast_u32_to_f32:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m0, $m11, $m15, 1
; CHECK-NEXT:  ld32 $a0, $m11, $m15, 1
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10
define float @bitcast_u32_to_f32(i32 zeroext %src) {
  %retval = bitcast i32 %src to float
  ret float %retval
}

; CHECK-LABEL: bitcast_u32_to_v2i16:
; CHECK:       # %bb.0:
; CHECK:       br $m10
define <2 x i16> @bitcast_u32_to_v2i16(i32 zeroext %src) {
  %retval = bitcast i32 %src to <2 x i16>
  ret <2 x i16> %retval
}

; CHECK-LABEL: bitcast_u32_to_v2u16:
; CHECK:       # %bb.0:
; CHECK:       br $m10
define <2 x i16> @bitcast_u32_to_v2u16(i32 zeroext %src) {
  %retval = bitcast i32 %src to <2 x i16>
  ret <2 x i16> %retval
}

; CHECK-LABEL: bitcast_u32_to_v2f16:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m0, $m11, $m15, 1
; CHECK-NEXT:  ld32 $a0, $m11, $m15, 1
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10
define <2 x half> @bitcast_u32_to_v2f16(i32 zeroext %src) {
  %retval = bitcast i32 %src to <2 x half>
  ret <2 x half> %retval
}

; CHECK-LABEL: bitcast_f16_to_i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $a0
; CHECK-NEXT:  shl $m0, $m0, 16
; CHECK-NEXT:  shrs $m0, $m0, 16
; CHECK:       br $m10
define signext i16 @bitcast_f16_to_i16(half %src) {
  %retval = bitcast half %src to i16
  ret i16 %retval
}

; CHECK-LABEL: bitcast_f16_to_u16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  sort4x16lo $a0, $a0, $a15
; CHECK-NEXT:  mov $m0, $a0
; CHECK:       br $m10
define zeroext i16 @bitcast_f16_to_u16(half %src) {
  %retval = bitcast half %src to i16
  ret i16 %retval
}

; CHECK-LABEL: bitcast_f16_to_f16:
; CHECK:       # %bb.0:
; CHECK:       br $m10
define half @bitcast_f16_to_f16(half %src) {
  %retval = bitcast half %src to half
  ret half %retval
}

; CHECK-LABEL: bitcast_f32_to_i32:
; CHECK:       # %bb.0:
; CHECK:       mov      $m0, $a0
; CHECK:       br $m10
define signext i32 @bitcast_f32_to_i32(float %src) {
  %retval = bitcast float %src to i32
  ret i32 %retval
}

; CHECK-LABEL: bitcast_f32_to_u32:
; CHECK:       # %bb.0:
; CHECK:       mov      $m0, $a0
; CHECK:       br $m10
define zeroext i32 @bitcast_f32_to_u32(float %src) {
  %retval = bitcast float %src to i32
  ret i32 %retval
}

; CHECK-LABEL: bitcast_f32_to_f32:
; CHECK:       # %bb.0:
; CHECK:       br $m10
define float @bitcast_f32_to_f32(float %src) {
  %retval = bitcast float %src to float
  ret float %retval
}

; CHECK-LABEL: bitcast_f32_to_v2i16:
; CHECK:       # %bb.0:
; CHECK:       mov      $m0, $a0
; CHECK:       br $m10
define <2 x i16> @bitcast_f32_to_v2i16(float %src) {
  %retval = bitcast float %src to <2 x i16>
  ret <2 x i16> %retval
}

; CHECK-LABEL: bitcast_f32_to_v2u16:
; CHECK:       # %bb.0:
; CHECK:       mov      $m0, $a0
; CHECK:       br $m10
define <2 x i16> @bitcast_f32_to_v2u16(float %src) {
  %retval = bitcast float %src to <2 x i16>
  ret <2 x i16> %retval
}

; CHECK-LABEL: bitcast_f32_to_v2f16:
; CHECK:       # %bb.0:
; CHECK:       br $m10
define <2 x half> @bitcast_f32_to_v2f16(float %src) {
  %retval = bitcast float %src to <2 x half>
  ret <2 x half> %retval
}

; CHECK-LABEL: bitcast_v2i16_to_i32:
; CHECK:       # %bb.0:
; CHECK:       br $m10
define signext i32 @bitcast_v2i16_to_i32(<2 x i16> %src) {
  %retval = bitcast <2 x i16> %src to i32
  ret i32 %retval
}

; CHECK-LABEL: bitcast_v2i16_to_u32:
; CHECK:       # %bb.0:
; CHECK:       br $m10
define zeroext i32 @bitcast_v2i16_to_u32(<2 x i16> %src) {
  %retval = bitcast <2 x i16> %src to i32
  ret i32 %retval
}

; CHECK-LABEL: bitcast_v2i16_to_f32:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m0, $m11, $m15, 1
; CHECK-NEXT:  ld32 $a0, $m11, $m15, 1
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10
define float @bitcast_v2i16_to_f32(<2 x i16> %src) {
  %retval = bitcast <2 x i16> %src to float
  ret float %retval
}

; CHECK-LABEL: bitcast_v2i16_to_v2i16:
; CHECK:       # %bb.0:
; CHECK:       br $m10
define <2 x i16> @bitcast_v2i16_to_v2i16(<2 x i16> %src) {
  %retval = bitcast <2 x i16> %src to <2 x i16>
  ret <2 x i16> %retval
}

; CHECK-LABEL: bitcast_v2i16_to_v2u16:
; CHECK:       # %bb.0:
; CHECK:       br $m10
define <2 x i16> @bitcast_v2i16_to_v2u16(<2 x i16> %src) {
  %retval = bitcast <2 x i16> %src to <2 x i16>
  ret <2 x i16> %retval
}

; CHECK-LABEL: bitcast_v2i16_to_v2f16:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m0, $m11, $m15, 1
; CHECK-NEXT:  ld32 $a0, $m11, $m15, 1
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10
define <2 x half> @bitcast_v2i16_to_v2f16(<2 x i16> %src) {
  %retval = bitcast <2 x i16> %src to <2 x half>
  ret <2 x half> %retval
}

; CHECK-LABEL: bitcast_v2i32_to_v2i32:
; CHECK:       # %bb.0:
; CHECK:       br $m10
define <2 x i32> @bitcast_v2i32_to_v2i32(<2 x i32> %src) {
  %retval = bitcast <2 x i32> %src to <2 x i32>
  ret <2 x i32> %retval
}

; CHECK-LABEL: bitcast_v2i32_to_v2u32:
; CHECK:       # %bb.0:
; CHECK:       br $m10
define <2 x i32> @bitcast_v2i32_to_v2u32(<2 x i32> %src) {
  %retval = bitcast <2 x i32> %src to <2 x i32>
  ret <2 x i32> %retval
}

; CHECK-LABEL: bitcast_v2i32_to_v2f32:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; CHECK-DAG:   st32 $m0, $m11, $m15, 0
; CHECK-DAG:   st32 $m1, $m11, $m15, 1
; CHECK-NEXT:  ld64 $a0:1, $m11, $m15, 0
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10
define <2 x float> @bitcast_v2i32_to_v2f32(<2 x i32> %src) {
  %retval = bitcast <2 x i32> %src to <2 x float>
  ret <2 x float> %retval
}

; CHECK-LABEL: bitcast_v2i32_to_v4i16:
; CHECK:       # %bb.0:
; CHECK:       br $m10
define <4 x i16> @bitcast_v2i32_to_v4i16(<2 x i32> %src) {
  %retval = bitcast <2 x i32> %src to <4 x i16>
  ret <4 x i16> %retval
}

; CHECK-LABEL: bitcast_v2i32_to_v4u16:
; CHECK:       # %bb.0:
; CHECK:       br $m10
define <4 x i16> @bitcast_v2i32_to_v4u16(<2 x i32> %src) {
  %retval = bitcast <2 x i32> %src to <4 x i16>
  ret <4 x i16> %retval
}

; CHECK-LABEL: bitcast_v2i32_to_v4f16:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; CHECK-DAG:   st32 $m0, $m11, $m15, 0
; CHECK-DAG:   st32 $m1, $m11, $m15, 1
; CHECK-NEXT:  ld64 $a0:1, $m11, $m15, 0
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10
define <4 x half> @bitcast_v2i32_to_v4f16(<2 x i32> %src) {
  %retval = bitcast <2 x i32> %src to <4 x half>
  ret <4 x half> %retval
}

; CHECK-LABEL: bitcast_v2u16_to_i32:
; CHECK:       # %bb.0:
; CHECK:       br $m10
define signext i32 @bitcast_v2u16_to_i32(<2 x i16> %src) {
  %retval = bitcast <2 x i16> %src to i32
  ret i32 %retval
}

; CHECK-LABEL: bitcast_v2u16_to_u32:
; CHECK:       # %bb.0:
; CHECK:       br $m10
define zeroext i32 @bitcast_v2u16_to_u32(<2 x i16> %src) {
  %retval = bitcast <2 x i16> %src to i32
  ret i32 %retval
}

; CHECK-LABEL: bitcast_v2u16_to_f32:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m0, $m11, $m15, 1
; CHECK-NEXT:  ld32 $a0, $m11, $m15, 1
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10
define float @bitcast_v2u16_to_f32(<2 x i16> %src) {
  %retval = bitcast <2 x i16> %src to float
  ret float %retval
}

; CHECK-LABEL: bitcast_v2u16_to_v2i16:
; CHECK:       # %bb.0:
; CHECK:       br $m10
define <2 x i16> @bitcast_v2u16_to_v2i16(<2 x i16> %src) {
  %retval = bitcast <2 x i16> %src to <2 x i16>
  ret <2 x i16> %retval
}

; CHECK-LABEL: bitcast_v2u16_to_v2u16:
; CHECK:       # %bb.0:
; CHECK:       br $m10
define <2 x i16> @bitcast_v2u16_to_v2u16(<2 x i16> %src) {
  %retval = bitcast <2 x i16> %src to <2 x i16>
  ret <2 x i16> %retval
}

; CHECK-LABEL: bitcast_v2u16_to_v2f16:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m0, $m11, $m15, 1
; CHECK-NEXT:  ld32 $a0, $m11, $m15, 1
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10
define <2 x half> @bitcast_v2u16_to_v2f16(<2 x i16> %src) {
  %retval = bitcast <2 x i16> %src to <2 x half>
  ret <2 x half> %retval
}

; CHECK-LABEL: bitcast_v2u32_to_v2i32:
; CHECK:       # %bb.0:
; CHECK:       br $m10
define <2 x i32> @bitcast_v2u32_to_v2i32(<2 x i32> %src) {
  %retval = bitcast <2 x i32> %src to <2 x i32>
  ret <2 x i32> %retval
}

; CHECK-LABEL: bitcast_v2u32_to_v2u32:
; CHECK:       # %bb.0:
; CHECK:       br $m10
define <2 x i32> @bitcast_v2u32_to_v2u32(<2 x i32> %src) {
  %retval = bitcast <2 x i32> %src to <2 x i32>
  ret <2 x i32> %retval
}

; CHECK-LABEL: bitcast_v2u32_to_v2f32:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; CHECK-DAG:   st32 $m0, $m11, $m15, 0
; CHECK-DAG:   st32 $m1, $m11, $m15, 1
; CHECK-NEXT:  ld64 $a0:1, $m11, $m15, 0
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10
define <2 x float> @bitcast_v2u32_to_v2f32(<2 x i32> %src) {
  %retval = bitcast <2 x i32> %src to <2 x float>
  ret <2 x float> %retval
}

; CHECK-LABEL: bitcast_v2u32_to_v4i16:
; CHECK:       # %bb.0:
; CHECK:       br $m10
define <4 x i16> @bitcast_v2u32_to_v4i16(<2 x i32> %src) {
  %retval = bitcast <2 x i32> %src to <4 x i16>
  ret <4 x i16> %retval
}

; CHECK-LABEL: bitcast_v2u32_to_v4u16:
; CHECK:       # %bb.0:
; CHECK:       br $m10
define <4 x i16> @bitcast_v2u32_to_v4u16(<2 x i32> %src) {
  %retval = bitcast <2 x i32> %src to <4 x i16>
  ret <4 x i16> %retval
}

; CHECK-LABEL: bitcast_v2u32_to_v4f16:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; CHECK-DAG:   st32 $m0, $m11, $m15, 0
; CHECK-DAG:   st32 $m1, $m11, $m15, 1
; CHECK-NEXT:  ld64 $a0:1, $m11, $m15, 0
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10
define <4 x half> @bitcast_v2u32_to_v4f16(<2 x i32> %src) {
  %retval = bitcast <2 x i32> %src to <4 x half>
  ret <4 x half> %retval
}

; CHECK-LABEL: bitcast_v2f16_to_i32:
; CHECK:       # %bb.0:
; CHECK:       mov      $m0, $a0
; CHECK:       br $m10
define signext i32 @bitcast_v2f16_to_i32(<2 x half> %src) {
  %retval = bitcast <2 x half> %src to i32
  ret i32 %retval
}

; CHECK-LABEL: bitcast_v2f16_to_u32:
; CHECK:       # %bb.0:
; CHECK:       mov      $m0, $a0
; CHECK:       br $m10
define zeroext i32 @bitcast_v2f16_to_u32(<2 x half> %src) {
  %retval = bitcast <2 x half> %src to i32
  ret i32 %retval
}

; CHECK-LABEL: bitcast_v2f16_to_f32:
; CHECK:       # %bb.0:
; CHECK:       br $m10
define float @bitcast_v2f16_to_f32(<2 x half> %src) {
  %retval = bitcast <2 x half> %src to float
  ret float %retval
}

; CHECK-LABEL: bitcast_v2f16_to_v2i16:
; CHECK:       # %bb.0:
; CHECK:       mov      $m0, $a0
; CHECK:       br $m10
define <2 x i16> @bitcast_v2f16_to_v2i16(<2 x half> %src) {
  %retval = bitcast <2 x half> %src to <2 x i16>
  ret <2 x i16> %retval
}

; CHECK-LABEL: bitcast_v2f16_to_v2u16:
; CHECK:       # %bb.0:
; CHECK:       mov      $m0, $a0
; CHECK:       br $m10
define <2 x i16> @bitcast_v2f16_to_v2u16(<2 x half> %src) {
  %retval = bitcast <2 x half> %src to <2 x i16>
  ret <2 x i16> %retval
}

; CHECK-LABEL: bitcast_v2f16_to_v2f16:
; CHECK:       # %bb.0:
; CHECK:       br $m10
define <2 x half> @bitcast_v2f16_to_v2f16(<2 x half> %src) {
  %retval = bitcast <2 x half> %src to <2 x half>
  ret <2 x half> %retval
}

; CHECK-LABEL: bitcast_v2f32_to_v2i32:
; CHECK:       # %bb.0:
; CHECK-DAG:   mov      $m0, $a0
; CHECK-DAG:   mov      $m1, $a1
; CHECK:       br $m10
define <2 x i32> @bitcast_v2f32_to_v2i32(<2 x float> %src) {
  %retval = bitcast <2 x float> %src to <2 x i32>
  ret <2 x i32> %retval
}

; CHECK-LABEL: bitcast_v2f32_to_v2u32:
; CHECK:       # %bb.0:
; CHECK-DAG:   mov      $m0, $a0
; CHECK-DAG:   mov      $m1, $a1
; CHECK:       br $m10
define <2 x i32> @bitcast_v2f32_to_v2u32(<2 x float> %src) {
  %retval = bitcast <2 x float> %src to <2 x i32>
  ret <2 x i32> %retval
}

; CHECK-LABEL: bitcast_v2f32_to_v2f32:
; CHECK:       # %bb.0:
; CHECK:       br $m10
define <2 x float> @bitcast_v2f32_to_v2f32(<2 x float> %src) {
  %retval = bitcast <2 x float> %src to <2 x float>
  ret <2 x float> %retval
}

; CHECK-LABEL: bitcast_v2f32_to_v4i16:
; CHECK:       # %bb.0:
; CHECK-DAG:   mov      $m0, $a0
; CHECK-DAG:   mov      $m1, $a1
; CHECK:       br $m10
define <4 x i16> @bitcast_v2f32_to_v4i16(<2 x float> %src) {
  %retval = bitcast <2 x float> %src to <4 x i16>
  ret <4 x i16> %retval
}

; CHECK-LABEL: bitcast_v2f32_to_v4u16:
; CHECK:       # %bb.0:
; CHECK-DAG:   mov      $m0, $a0
; CHECK-DAG:   mov      $m1, $a1
; CHECK:       br $m10
define <4 x i16> @bitcast_v2f32_to_v4u16(<2 x float> %src) {
  %retval = bitcast <2 x float> %src to <4 x i16>
  ret <4 x i16> %retval
}

; CHECK-LABEL: bitcast_v2f32_to_v4f16:
; CHECK:       # %bb.0:
; CHECK:       br $m10
define <4 x half> @bitcast_v2f32_to_v4f16(<2 x float> %src) {
  %retval = bitcast <2 x float> %src to <4 x half>
  ret <4 x half> %retval
}

; CHECK-LABEL: bitcast_v4i16_to_v2i32:
; CHECK:       # %bb.0:
; CHECK:       br $m10
define <2 x i32> @bitcast_v4i16_to_v2i32(<4 x i16> %src) {
  %retval = bitcast <4 x i16> %src to <2 x i32>
  ret <2 x i32> %retval
}

; CHECK-LABEL: bitcast_v4i16_to_v2u32:
; CHECK:       # %bb.0:
; CHECK:       br $m10
define <2 x i32> @bitcast_v4i16_to_v2u32(<4 x i16> %src) {
  %retval = bitcast <4 x i16> %src to <2 x i32>
  ret <2 x i32> %retval
}

; CHECK-LABEL: bitcast_v4i16_to_v2f32:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; CHECK-DAG:   st32 $m0, $m11, $m15, 0
; CHECK-DAG:   st32 $m1, $m11, $m15, 1
; CHECK-NEXT:  ld64 $a0:1, $m11, $m15, 0
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10
define <2 x float> @bitcast_v4i16_to_v2f32(<4 x i16> %src) {
  %retval = bitcast <4 x i16> %src to <2 x float>
  ret <2 x float> %retval
}

; CHECK-LABEL: bitcast_v4i16_to_v4i16:
; CHECK:       # %bb.0:
; CHECK:       br $m10
define <4 x i16> @bitcast_v4i16_to_v4i16(<4 x i16> %src) {
  %retval = bitcast <4 x i16> %src to <4 x i16>
  ret <4 x i16> %retval
}

; CHECK-LABEL: bitcast_v4i16_to_v4u16:
; CHECK:       # %bb.0:
; CHECK:       br $m10
define <4 x i16> @bitcast_v4i16_to_v4u16(<4 x i16> %src) {
  %retval = bitcast <4 x i16> %src to <4 x i16>
  ret <4 x i16> %retval
}

; CHECK-LABEL: bitcast_v4i16_to_v4f16:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; CHECK-DAG:   st32 $m0, $m11, $m15, 0
; CHECK-DAG:   st32 $m1, $m11, $m15, 1
; CHECK-NEXT:  ld64 $a0:1, $m11, $m15, 0
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10
define <4 x half> @bitcast_v4i16_to_v4f16(<4 x i16> %src) {
  %retval = bitcast <4 x i16> %src to <4 x half>
  ret <4 x half> %retval
}

; CHECK-LABEL: bitcast_v4u16_to_v2i32:
; CHECK:       # %bb.0:
; CHECK:       br $m10
define <2 x i32> @bitcast_v4u16_to_v2i32(<4 x i16> %src) {
  %retval = bitcast <4 x i16> %src to <2 x i32>
  ret <2 x i32> %retval
}

; CHECK-LABEL: bitcast_v4u16_to_v2u32:
; CHECK:       # %bb.0:
; CHECK:       br $m10
define <2 x i32> @bitcast_v4u16_to_v2u32(<4 x i16> %src) {
  %retval = bitcast <4 x i16> %src to <2 x i32>
  ret <2 x i32> %retval
}

; CHECK-LABEL: bitcast_v4u16_to_v2f32:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; CHECK-DAG:   st32 $m0, $m11, $m15, 0
; CHECK-DAG:   st32 $m1, $m11, $m15, 1
; CHECK-NEXT:  ld64 $a0:1, $m11, $m15, 0
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10
define <2 x float> @bitcast_v4u16_to_v2f32(<4 x i16> %src) {
  %retval = bitcast <4 x i16> %src to <2 x float>
  ret <2 x float> %retval
}

; CHECK-LABEL: bitcast_v4u16_to_v4i16:
; CHECK:       # %bb.0:
; CHECK:       br $m10
define <4 x i16> @bitcast_v4u16_to_v4i16(<4 x i16> %src) {
  %retval = bitcast <4 x i16> %src to <4 x i16>
  ret <4 x i16> %retval
}

; CHECK-LABEL: bitcast_v4u16_to_v4u16:
; CHECK:       # %bb.0:
; CHECK:       br $m10
define <4 x i16> @bitcast_v4u16_to_v4u16(<4 x i16> %src) {
  %retval = bitcast <4 x i16> %src to <4 x i16>
  ret <4 x i16> %retval
}

; CHECK-LABEL: bitcast_v4u16_to_v4f16:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; CHECK-DAG:   st32 $m0, $m11, $m15, 0
; CHECK-DAG:   st32 $m1, $m11, $m15, 1
; CHECK-NEXT:  ld64 $a0:1, $m11, $m15, 0
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10
define <4 x half> @bitcast_v4u16_to_v4f16(<4 x i16> %src) {
  %retval = bitcast <4 x i16> %src to <4 x half>
  ret <4 x half> %retval
}

; CHECK-LABEL: bitcast_v4f16_to_v2i32:
; CHECK:       # %bb.0:
; CHECK-DAG:   mov      $m0, $a0
; CHECK-DAG:   mov      $m1, $a1
; CHECK:       br $m10
define <2 x i32> @bitcast_v4f16_to_v2i32(<4 x half> %src) {
  %retval = bitcast <4 x half> %src to <2 x i32>
  ret <2 x i32> %retval
}

; CHECK-LABEL: bitcast_v4f16_to_v2u32:
; CHECK:       # %bb.0:
; CHECK-DAG:   mov      $m0, $a0
; CHECK-DAG:   mov      $m1, $a1
; CHECK:       br $m10
define <2 x i32> @bitcast_v4f16_to_v2u32(<4 x half> %src) {
  %retval = bitcast <4 x half> %src to <2 x i32>
  ret <2 x i32> %retval
}

; CHECK-LABEL: bitcast_v4f16_to_v2f32:
; CHECK:       # %bb.0:
; CHECK:       br $m10
define <2 x float> @bitcast_v4f16_to_v2f32(<4 x half> %src) {
  %retval = bitcast <4 x half> %src to <2 x float>
  ret <2 x float> %retval
}

; CHECK-LABEL: bitcast_v4f16_to_v4i16:
; CHECK:       # %bb.0:
; CHECK-DAG:   mov      $m0, $a0
; CHECK-DAG:   mov      $m1, $a1
; CHECK:       br $m10
define <4 x i16> @bitcast_v4f16_to_v4i16(<4 x half> %src) {
  %retval = bitcast <4 x half> %src to <4 x i16>
  ret <4 x i16> %retval
}

; CHECK-LABEL: bitcast_v4f16_to_v4u16:
; CHECK:       # %bb.0:
; CHECK-DAG:   mov      $m0, $a0
; CHECK-DAG:   mov      $m1, $a1
; CHECK:       br $m10
define <4 x i16> @bitcast_v4f16_to_v4u16(<4 x half> %src) {
  %retval = bitcast <4 x half> %src to <4 x i16>
  ret <4 x i16> %retval
}

; CHECK-LABEL: bitcast_v4f16_to_v4f16:
; CHECK:       # %bb.0:
; CHECK:       br $m10
define <4 x half> @bitcast_v4f16_to_v4f16(<4 x half> %src) {
  %retval = bitcast <4 x half> %src to <4 x half>
  ret <4 x half> %retval
}
