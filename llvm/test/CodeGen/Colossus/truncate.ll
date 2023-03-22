; RUN: llc < %s -march=colossus -colossus-coissue=false -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -march=colossus -colossus-coissue=false -mattr=+ipu2 | FileCheck %s

target triple = "colossus-graphcore--elf"

; CHECK-LABEL: trunc_i32_to_i16:
; CHECK:       # %bb.0:
; Conversion induced by the ABI

; CHECK-NEXT:  shl $m0, $m0, 16
; CHECK-NEXT:  shrs $m0, $m0, 16
; CHECK:       br $m10
define signext i16 @trunc_i32_to_i16(i32 signext %src) {
  %retval = trunc i32 %src to i16
  ret i16 %retval
}

; CHECK-LABEL: trunc_i32_to_u16:
; CHECK:       # %bb.0:
; Conversion induced by the ABI
; CHECK-NEXT:  sort4x16lo $m0, $m0, $m15
; CHECK:       br $m10
define zeroext i16 @trunc_i32_to_u16(i32 signext %src) {
  %retval = trunc i32 %src to i16
  ret i16 %retval
}

; CHECK-LABEL: trunc_u32_to_i16:
; CHECK:       # %bb.0:
; Conversion induced by the ABI

; CHECK-NEXT:  shl $m0, $m0, 16
; CHECK-NEXT:  shrs $m0, $m0, 16
; CHECK:       br $m10
define signext i16 @trunc_u32_to_i16(i32 zeroext %src) {
  %retval = trunc i32 %src to i16
  ret i16 %retval
}

; CHECK-LABEL: trunc_u32_to_u16:
; CHECK:       # %bb.0:
; Conversion induced by the ABI
; CHECK-NEXT:  sort4x16lo $m0, $m0, $m15
; CHECK:       br $m10
define zeroext i16 @trunc_u32_to_u16(i32 zeroext %src) {
  %retval = trunc i32 %src to i16
  ret i16 %retval
}

; CHECK-LABEL: fptrunc_f32_to_f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f32tof16 $a0, $a0
; CHECK:       br $m10
define half @fptrunc_f32_to_f16(float %src) {
  %retval = fptrunc float %src to half
  ret half %retval
}

declare half @llvm.experimental.constrained.fptrunc.f16.f32(float %src, metadata, metadata)

; CHECK-LABEL: strict_fptrunc_f32_to_f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f32tof16 $a0, $a0
; CHECK:       br $m10
define half @strict_fptrunc_f32_to_f16(float %src) {
  %retval = tail call half @llvm.experimental.constrained.fptrunc.f16.f32(float %src, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret half %retval
}

; CHECK-LABEL: trunc_v2i32_to_v2i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  sort4x16lo $m0, $m0, $m1
; CHECK:       br $m10
define <2 x i16> @trunc_v2i32_to_v2i16(<2 x i32> %src) {
  %retval = trunc <2 x i32> %src to <2 x i16>
  ret <2 x i16> %retval
}

; CHECK-LABEL: trunc_v2i32_to_v2u16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  sort4x16lo $m0, $m0, $m1
; CHECK:       br $m10
define <2 x i16> @trunc_v2i32_to_v2u16(<2 x i32> %src) {
  %retval = trunc <2 x i32> %src to <2 x i16>
  ret <2 x i16> %retval
}

; CHECK-LABEL: trunc_v2u32_to_v2i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  sort4x16lo $m0, $m0, $m1
; CHECK:       br $m10
define <2 x i16> @trunc_v2u32_to_v2i16(<2 x i32> %src) {
  %retval = trunc <2 x i32> %src to <2 x i16>
  ret <2 x i16> %retval
}

; CHECK-LABEL: trunc_v2u32_to_v2u16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  sort4x16lo $m0, $m0, $m1
; CHECK:       br $m10
define <2 x i16> @trunc_v2u32_to_v2u16(<2 x i32> %src) {
  %retval = trunc <2 x i32> %src to <2 x i16>
  ret <2 x i16> %retval
}

; CHECK-LABEL: fptrunc_v2f32_to_v2f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f32v2tof16 $a0, $a0:1
; CHECK:       br $m10
define <2 x half> @fptrunc_v2f32_to_v2f16(<2 x float> %src) {
  %retval = fptrunc <2 x float> %src to <2 x half>
  ret <2 x half> %retval
}

declare <2 x half> @llvm.experimental.constrained.fptrunc.v2f16.v2f32(<2 x float> %src, metadata, metadata)

; CHECK-LABEL: strict_fptrunc_v2f32_to_v2f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f32v2tof16 $a0, $a0:1
; CHECK:       br $m10
define <2 x half> @strict_fptrunc_v2f32_to_v2f16(<2 x float> %src) {
  %retval = tail call <2 x half> @llvm.experimental.constrained.fptrunc.v2f16.v2f32(<2 x float> %src, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <2 x half> %retval
}
