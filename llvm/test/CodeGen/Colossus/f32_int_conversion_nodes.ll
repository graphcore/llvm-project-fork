; RUN: llvm-link %isdopc %s | opt -instcombine -always-inline -mattr=+ipu1 | llc -march=colossus -colossus-coissue=false -mattr=+ipu1 | FileCheck %s
; RUN: llvm-link %isdopc %s | opt -instcombine -always-inline -mattr=+ipu2 | llc -march=colossus -colossus-coissue=false -mattr=+ipu2 | FileCheck %s

declare float @llvm.colossus.SDAG.unary.f32(i32, float)
declare float @llvm.colossus.SDAG.chained.unary.f32(i32, float)

; These nodes are only defined on f32
@ColossusISD_F32_TO_SINT = external constant i32
@ColossusISD_F32_TO_UINT = external constant i32
@ColossusISD_STRICT_F32_TO_SINT = external constant i32
@ColossusISD_STRICT_F32_TO_UINT = external constant i32
@ColossusISD_SINT_TO_F32 = external constant i32
@ColossusISD_UINT_TO_F32 = external constant i32

; CHECK-LABEL: f32_to_sint:
; CHECK:       # %bb
; CHECK-NEXT:  f32int $a0, $a0, 3
; CHECK-NEXT:  f32toi32 $a0, $a0
; CHECK-NEXT:  br $m10
define float @f32_to_sint(float %x) {
  %id = load i32, i32* @ColossusISD_F32_TO_SINT
  %res = call float @llvm.colossus.SDAG.unary.f32(i32 %id, float %x)
  ret float %res
}

; CHECK-LABEL: f32_to_uint:
; CHECK:       # %bb
; CHECK-NEXT:  f32int $a0, $a0, 3
; CHECK-NEXT:  f32toui32 $a0, $a0
; CHECK-NEXT:  br $m10
define float @f32_to_uint(float %x) {
  %id = load i32, i32* @ColossusISD_F32_TO_UINT
  %res = call float @llvm.colossus.SDAG.unary.f32(i32 %id, float %x)
  ret float %res
}

; CHECK-LABEL: strict_f32_to_sint:
; CHECK:       # %bb
; CHECK-NEXT:  f32int $a0, $a0, 3
; CHECK-NEXT:  f32toi32 $a0, $a0
; CHECK-NEXT:  br $m10
define float @strict_f32_to_sint(float %x) {
  %id = load i32, i32* @ColossusISD_STRICT_F32_TO_SINT
  %res = call float @llvm.colossus.SDAG.chained.unary.f32(i32 %id, float %x)
  ret float %res
}

; CHECK-LABEL: strict_f32_to_uint:
; CHECK:       # %bb
; CHECK-NEXT:  f32int $a0, $a0, 3
; CHECK-NEXT:  f32toui32 $a0, $a0
; CHECK-NEXT:  br $m10
define float @strict_f32_to_uint(float %x) {
  %id = load i32, i32* @ColossusISD_STRICT_F32_TO_UINT
  %res = call float @llvm.colossus.SDAG.chained.unary.f32(i32 %id, float %x)
  ret float %res
}

; CHECK-LABEL: sint_to_f32:
; CHECK:       # %bb
; CHECK-NEXT:  f32fromi32 $a0, $a0
; CHECK-NEXT:  br $m10
define float @sint_to_f32(float %x) {
  %id = load i32, i32* @ColossusISD_SINT_TO_F32
  %res = call float @llvm.colossus.SDAG.unary.f32(i32 %id, float %x)
  ret float %res
}

; CHECK-LABEL: uint_to_f32:
; CHECK:       # %bb
; CHECK-NEXT:  f32fromui32 $a0, $a0
; CHECK-NEXT:  br $m10
define float @uint_to_f32(float %x) {
  %id = load i32, i32* @ColossusISD_UINT_TO_F32
  %res = call float @llvm.colossus.SDAG.unary.f32(i32 %id, float %x)
  ret float %res
}
