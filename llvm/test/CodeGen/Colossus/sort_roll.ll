; RUN: llvm-link %isdopc %s | opt -instcombine -always-inline -mattr=+ipu1 | llc -march=colossus -colossus-coissue=false -mattr=+ipu1 | FileCheck %s
; RUN: llvm-link %isdopc %s | opt -instcombine -always-inline -mattr=+ipu2 | llc -march=colossus -colossus-coissue=false -mattr=+ipu2 | FileCheck %s

@ColossusISD_SORT4X16LO = external constant i32
@ColossusISD_SORT4X16HI = external constant i32
@ColossusISD_ROLL16 = external constant i32

declare float @llvm.colossus.SDAG.binary.f32(i32, float, float)
declare <2 x half> @llvm.colossus.SDAG.binary.v2f16(i32, <2 x half>, <2 x half>)
declare i32 @llvm.colossus.SDAG.binary.i32(i32, i32, i32)
declare <2 x i16> @llvm.colossus.SDAG.binary.v2i16(i32, <2 x i16>, <2 x i16>)

; CHECK-LABEL: sort4x16lo_f32:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a0, $a1
; CHECK-NEXT:  br $m10
define float @sort4x16lo_f32(float %x, float %y) {
   %id = load i32, i32* @ColossusISD_SORT4X16LO
   %res = call float @llvm.colossus.SDAG.binary.f32(i32 %id, float %x, float %y)
   ret float %res
}

; CHECK-LABEL: sort4x16lo_v2f16:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @sort4x16lo_v2f16(<2 x half> %x, <2 x half> %y) {
   %id = load i32, i32* @ColossusISD_SORT4X16LO
   %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(i32 %id, <2 x half> %x, <2 x half> %y)
   ret <2 x half> %res
}

; CHECK-LABEL: sort4x16lo_i32:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $m0, $m0, $m1
; CHECK-NEXT:  br $m10
define i32 @sort4x16lo_i32(i32 %x, i32 %y) {
   %id = load i32, i32* @ColossusISD_SORT4X16LO
   %res = call i32 @llvm.colossus.SDAG.binary.i32(i32 %id, i32 %x, i32 %y)
   ret i32 %res
}

; CHECK-LABEL: sort4x16lo_v2i16:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $m0, $m0, $m1
; CHECK-NEXT:  br $m10
define <2 x i16> @sort4x16lo_v2i16(<2 x i16> %x, <2 x i16> %y) {
   %id = load i32, i32* @ColossusISD_SORT4X16LO
   %res = call <2 x i16> @llvm.colossus.SDAG.binary.v2i16(i32 %id, <2 x i16> %x, <2 x i16> %y)
   ret <2 x i16> %res
}

; CHECK-LABEL: sort4x16hi_f32:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a0, $a1
; CHECK-NEXT:  br $m10
define float @sort4x16hi_f32(float %x, float %y) {
   %id = load i32, i32* @ColossusISD_SORT4X16HI
   %res = call float @llvm.colossus.SDAG.binary.f32(i32 %id, float %x, float %y)
   ret float %res
}

; CHECK-LABEL: sort4x16hi_v2f16:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @sort4x16hi_v2f16(<2 x half> %x, <2 x half> %y) {
   %id = load i32, i32* @ColossusISD_SORT4X16HI
   %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(i32 %id, <2 x half> %x, <2 x half> %y)
   ret <2 x half> %res
}

; CHECK-LABEL: sort4x16hi_i32:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $m0, $m0, $m1
; CHECK-NEXT:  br $m10
define i32 @sort4x16hi_i32(i32 %x, i32 %y) {
   %id = load i32, i32* @ColossusISD_SORT4X16HI
   %res = call i32 @llvm.colossus.SDAG.binary.i32(i32 %id, i32 %x, i32 %y)
   ret i32 %res
}

; CHECK-LABEL: sort4x16hi_v2i16:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $m0, $m0, $m1
; CHECK-NEXT:  br $m10
define <2 x i16> @sort4x16hi_v2i16(<2 x i16> %x, <2 x i16> %y) {
   %id = load i32, i32* @ColossusISD_SORT4X16HI
   %res = call <2 x i16> @llvm.colossus.SDAG.binary.v2i16(i32 %id, <2 x i16> %x, <2 x i16> %y)
   ret <2 x i16> %res
}

; CHECK-LABEL: roll16_f32:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a0, $a1
; CHECK-NEXT:  br $m10
define float @roll16_f32(float %x, float %y) {
   %id = load i32, i32* @ColossusISD_ROLL16
   %res = call float @llvm.colossus.SDAG.binary.f32(i32 %id, float %x, float %y)
   ret float %res
}

; CHECK-LABEL: roll16_v2f16:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @roll16_v2f16(<2 x half> %x, <2 x half> %y) {
   %id = load i32, i32* @ColossusISD_ROLL16
   %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(i32 %id, <2 x half> %x, <2 x half> %y)
   ret <2 x half> %res
}

; CHECK-LABEL: roll16_i32:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $m0, $m0, $m1
; CHECK-NEXT:  br $m10
define i32 @roll16_i32(i32 %x, i32 %y) {
   %id = load i32, i32* @ColossusISD_ROLL16
   %res = call i32 @llvm.colossus.SDAG.binary.i32(i32 %id, i32 %x, i32 %y)
   ret i32 %res
}

; CHECK-LABEL: roll16_v2i16:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $m0, $m0, $m1
; CHECK-NEXT:  br $m10
define <2 x i16> @roll16_v2i16(<2 x i16> %x, <2 x i16> %y) {
   %id = load i32, i32* @ColossusISD_ROLL16
   %res = call <2 x i16> @llvm.colossus.SDAG.binary.v2i16(i32 %id, <2 x i16> %x, <2 x i16> %y)
   ret <2 x i16> %res
}
