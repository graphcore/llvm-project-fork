; RUN: llvm-link %isdopc %s | opt -instcombine -always-inline -mattr=+ipu1 | llc -march=colossus -colossus-coissue=false -mattr=+ipu1 | FileCheck %s
; RUN: llvm-link %isdopc %s | opt -instcombine -always-inline -mattr=+ipu2 | llc -march=colossus -colossus-coissue=false -mattr=+ipu2 | FileCheck %s
target triple = "colossus-graphcore--elf"

;; Test lowering of FP_TO_FP16, FP16_TO_FP and strict counterpart SelectionDAG
;; nodes.

@ISD_FP_TO_FP16 = external constant i32
@ISD_FP16_TO_FP = external constant i32
@ISD_STRICT_FP_TO_FP16 = external constant i32
@ISD_STRICT_FP16_TO_FP = external constant i32

declare i16 @llvm.colossus.SDAG.unary.i16.f32(i32, float)
declare float @llvm.colossus.SDAG.unary.f32.i16(i32, i16)
declare i16 @llvm.colossus.SDAG.chained.unary.i16.f32(i32, float)
declare float @llvm.colossus.SDAG.chained.unary.f32.i16(i32, i16)

; CHECK-LABEL: fp_to_f16:
; CHECK:       # %bb
; CHECK-NEXT:  f32tof16 $a0, $a0
; CHECK-NEXT:  mov $m0, $a0
; CHECK-NEXT:  br $m10
define i16 @fp_to_f16(float %x) {
  %id = load i32, i32* @ISD_FP_TO_FP16
  %res = call i16 @llvm.colossus.SDAG.unary.i16.f32(i32 %id, float %x)
  ret i16 %res
}

; CHECK-LABEL: strict_fp_to_f16:
; CHECK:       # %bb
; CHECK-NEXT:  f32tof16 $a0, $a0
; CHECK-NEXT:  mov $m0, $a0
; CHECK-NEXT:  br $m10
define i16 @strict_fp_to_f16(float %x) {
  %id = load i32, i32* @ISD_STRICT_FP_TO_FP16
  %res = call i16 @llvm.colossus.SDAG.chained.unary.i16.f32(i32 %id, float %x)
  ret i16 %res
}

; CHECK-LABEL: f16_to_fp:
; CHECK:       # %bb
; CHECK-NEXT:  add $m11, $m11, -8
; CHECK:       st32 $m0, $m11, $m15
; CHECK-NEXT:  ld32 $a0, $m11, $m15
; CHECK-NEXT:  f16tof32 $a0, $a0
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:  br $m10
define float @f16_to_fp(i16  %x) {
  %id = load i32, i32* @ISD_FP16_TO_FP
  %res = call float @llvm.colossus.SDAG.unary.f32.i16(i32 %id, i16 %x)
  ret float %res
}

; CHECK-LABEL: strict_f16_to_fp:
; CHECK:       # %bb
; CHECK-NEXT:  add $m11, $m11, -8
; CHECK:       st32 $m0, $m11, $m15
; CHECK-NEXT:  ld32 $a0, $m11, $m15
; CHECK-NEXT:  f16tof32 $a0, $a0
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:  br $m10
define float @strict_f16_to_fp(i16  %x) {
  %id = load i32, i32* @ISD_STRICT_FP16_TO_FP
  %res = call float @llvm.colossus.SDAG.chained.unary.f32.i16(i32 %id, i16 %x)
  ret float %res
}
