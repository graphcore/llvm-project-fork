; RUN: llvm-link %isdopc %s | opt -instcombine -always-inline -mattr=+ipu1 | llc -march=colossus -colossus-coissue=false -mattr=+ipu1 | FileCheck %s
; RUN: llvm-link %isdopc %s | opt -instcombine -always-inline -mattr=+ipu2 | llc -march=colossus -colossus-coissue=false -mattr=+ipu2 | FileCheck %s

@ISD_SCALAR_TO_VECTOR = external constant i32

declare <2 x i16> @llvm.colossus.SDAG.unary.v2i16.i16(i32, i16)
declare <2 x i32> @llvm.colossus.SDAG.unary.v2i32.i32(i32, i32)
declare <4 x i16> @llvm.colossus.SDAG.unary.v4i16.i16(i32, i16)
declare <2 x half> @llvm.colossus.SDAG.unary.v2f16.f16(i32, half)
declare <2 x float> @llvm.colossus.SDAG.unary.v2f32.f32(i32, float)
declare <4 x half> @llvm.colossus.SDAG.unary.v4f16.f16(i32, half)

; CHECK-LABEL: stv_v2i16:
; CHECK:       # %bb
; CHECK-NEXT:  mov $m0, $m1
; CHECK-NEXT:  br $m10
define <2 x i16> @stv_v2i16(i32 %unused, i16 %x0) {
  %id = load i32, i32* @ISD_SCALAR_TO_VECTOR
  %res = call <2 x i16> @llvm.colossus.SDAG.unary.v2i16.i16(i32 %id, i16 %x0)
  ret <2 x i16> %res
}

; CHECK-LABEL: stv_v2i32:
; CHECK:       # %bb
; CHECK-NEXT:  mov $m0, $m1
; CHECK-NEXT:  br $m10
define <2 x i32> @stv_v2i32(i32 %unused, i32 %x0) {
  %id = load i32, i32* @ISD_SCALAR_TO_VECTOR
  %res = call <2 x i32> @llvm.colossus.SDAG.unary.v2i32.i32(i32 %id, i32 %x0)
  ret <2 x i32> %res
}

; CHECK-LABEL: stv_v4i16:
; CHECK:       # %bb
; CHECK-NEXT:  mov $m0, $m1
; CHECK-NEXT:  br $m10
define <4 x i16> @stv_v4i16(i32 %unused, i16 %x0) {
  %id = load i32, i32* @ISD_SCALAR_TO_VECTOR
  %res = call <4 x i16> @llvm.colossus.SDAG.unary.v4i16.i16(i32 %id, i16 %x0)
  ret <4 x i16> %res
}

; CHECK-LABEL: stv_v2f16:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @stv_v2f16(float %unused, half %x0) {
  %id = load i32, i32* @ISD_SCALAR_TO_VECTOR
  %res = call <2 x half> @llvm.colossus.SDAG.unary.v2f16.f16(i32 %id, half %x0)
  ret <2 x half> %res
}

; CHECK-LABEL: stv_v2f32:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x float> @stv_v2f32(float %unused, float %x0) {
  %id = load i32, i32* @ISD_SCALAR_TO_VECTOR
  %res = call <2 x float> @llvm.colossus.SDAG.unary.v2f32.f32(i32 %id, float %x0)
  ret <2 x float> %res
}

; CHECK-LABEL: stv_v4f16:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a1
; CHECK-NEXT:  br $m10
define <4 x half> @stv_v4f16(float %unused, half %x0) {
  %id = load i32, i32* @ISD_SCALAR_TO_VECTOR
  %res = call <4 x half> @llvm.colossus.SDAG.unary.v4f16.f16(i32 %id, half %x0)
  ret <4 x half> %res
}
