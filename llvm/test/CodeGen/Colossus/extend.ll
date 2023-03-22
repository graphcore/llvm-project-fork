; RUN: llc < %s -march=colossus -colossus-coissue=false -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -march=colossus -colossus-coissue=false -mattr=+ipu2 | FileCheck %s

target triple = "colossus-graphcore--elf"

; CHECK-LABEL: sext_i16_to_i32:
; CHECK:       # %bb.0:
; Conversion by caller induced by the ABI
; CHECK:       br $m10
define signext i32 @sext_i16_to_i32(i16 signext %src) {
  %retval = sext i16 %src to i32
  ret i32 %retval
}

; CHECK-LABEL: zext_i16_to_u32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  sort4x16lo $m0, $m0, $m15
; CHECK:       br $m10
define zeroext i32 @zext_i16_to_u32(i16 signext %src) {
  %retval = zext i16 %src to i32
  ret i32 %retval
}

; CHECK-LABEL: sext_u16_to_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shl $m0, $m0, 16
; CHECK-NEXT:  shrs $m0, $m0, 16
; CHECK:       br $m10
define signext i32 @sext_u16_to_i32(i16 zeroext %src) {
  %retval = sext i16 %src to i32
  ret i32 %retval
}

; CHECK-LABEL: zext_u16_to_u32:
; CHECK:       # %bb.0:
; Conversion by caller induced by the ABI
; CHECK:       br $m10
define zeroext i32 @zext_u16_to_u32(i16 zeroext %src) {
  %retval = zext i16 %src to i32
  ret i32 %retval
}

; CHECK-LABEL: fpext_f16_to_f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f16tof32 $a0, $a0
; CHECK:       br $m10
define float @fpext_f16_to_f32(half %src) {
  %retval = fpext half %src to float
  ret float %retval
}

declare float @llvm.experimental.constrained.fpext.f32.f16(half %src, metadata)

; CHECK-LABEL: strict_fpext_f16_to_f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f16tof32 $a0, $a0
; CHECK:       br $m10
define float @strict_fpext_f16_to_f32(half %src) {
  %retval = tail call float @llvm.experimental.constrained.fpext.f32.f16(half %src, metadata !"fpexcept.strict")
  ret float %retval
}

; CHECK-LABEL: sext_v2i16_to_v2i32:
; CHECK:       # %bb.0:
; Intentionally fragile, hoping to clean up with a MI pass
; CHECK-NEXT:  shl $m1, $m0, 16
; CHECK-NEXT:  shrs $m2, $m1, 16
; CHECK-NEXT:  shrs $m3, $m0, 16
; CHECK-NOT:   split-up-check-dags
; CHECK-DAG:   mov $m0, $m2
; CHECK-DAG:   mov $m1, $m3
; CHECK:       br $m10
define <2 x i32> @sext_v2i16_to_v2i32(<2 x i16> %src) {
  %retval = sext <2 x i16> %src to <2 x i32>
  ret <2 x i32> %retval
}

; CHECK-LABEL: zext_v2i16_to_v2u32:
; CHECK:       # %bb.0:
; Intentionally fragile, hoping to clean up with a MI pass
; CHECK-DAG:   sort4x16lo $m2, $m0, $m15
; CHECK-DAG:   shr $m3, $m0, 16
; CHECK-NOT:   split-up-check-dags
; CHECK-DAG:   mov $m0, $m2
; CHECK-DAG:   mov $m1, $m3
; CHECK:       br $m10
define <2 x i32> @zext_v2i16_to_v2u32(<2 x i16> %src) {
  %retval = zext <2 x i16> %src to <2 x i32>
  ret <2 x i32> %retval
}

; CHECK-LABEL: sext_v2u16_to_v2i32:
; CHECK:       # %bb.0:
; Intentionally fragile, hoping to clean up with a MI pass
; CHECK-NEXT:  shl $m1, $m0, 16
; CHECK-NEXT:  shrs $m2, $m1, 16
; CHECK-NEXT:  shrs $m3, $m0, 16
; CHECK-NOT:   split-up-check-dags
; CHECK-DAG:   mov $m0, $m2
; CHECK-DAG:   mov $m1, $m3
; CHECK:       br $m10
define <2 x i32> @sext_v2u16_to_v2i32(<2 x i16> %src) {
  %retval = sext <2 x i16> %src to <2 x i32>
  ret <2 x i32> %retval
}

; CHECK-LABEL: zext_v2u16_to_v2u32:
; CHECK:       # %bb.0:
; Intentionally fragile, hoping to clean up with a MI pass
; CHECK-DAG:   sort4x16lo $m2, $m0, $m15
; CHECK-DAG:   shr $m3, $m0, 16
; CHECK-NOT:   split-up-check-dags
; CHECK-DAG:   mov $m0, $m2
; CHECK-DAG:   mov $m1, $m3
; CHECK:       br $m10
define <2 x i32> @zext_v2u16_to_v2u32(<2 x i16> %src) {
  %retval = zext <2 x i16> %src to <2 x i32>
  ret <2 x i32> %retval
}

; CHECK-LABEL: fpext_v2f16_to_v2f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f16v2tof32 $a0:1, $a0
; CHECK:       br $m10
define <2 x float> @fpext_v2f16_to_v2f32(<2 x half> %src) {
  %retval = fpext <2 x half> %src to <2 x float>
  ret <2 x float> %retval
}

declare <2 x float> @llvm.experimental.constrained.fpext.v2f32.v2f16(<2 x half> %src, metadata)

; CHECK-LABEL: strict_fpext_v2f16_to_v2f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f16v2tof32 $a0:1, $a0
; CHECK:       br $m10
define <2 x float> @strict_fpext_v2f16_to_v2f32(<2 x half> %src) {
  %retval = tail call <2 x float> @llvm.experimental.constrained.fpext.v2f32.v2f16(<2 x half> %src, metadata !"fpexcept.strict")
  ret <2 x float> %retval
}
