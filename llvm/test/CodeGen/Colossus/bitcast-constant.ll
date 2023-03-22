; RUN: llvm-link %isdopc %s | opt -instcombine -always-inline -mattr=+ipu1 | llc -march=colossus -colossus-coissue=false -mattr=+ipu1 | FileCheck %s
; RUN: llvm-link %isdopc %s | opt -instcombine -always-inline -mattr=+ipu2 | llc -march=colossus -colossus-coissue=false -mattr=+ipu2 | FileCheck %s
target triple = "colossus-graphcore--elf"

; Check that DAG combines exist that eliminate bitcasts that cross register files.

@ISD_BITCAST = external constant i32

declare i32 @llvm.colossus.SDAG.unary.i32.f32(i32, float)
declare i32 @llvm.colossus.SDAG.unary.i32.v2f16(i32, <2 x half>)
declare <2 x i16> @llvm.colossus.SDAG.unary.v2i16.f32(i32, float)
declare <2 x i16> @llvm.colossus.SDAG.unary.v2i16.v2f16(i32, <2 x half>)
declare float @llvm.colossus.SDAG.unary.f32.i32(i32, i32)
declare float @llvm.colossus.SDAG.unary.f32.v2i16(i32, <2 x i16>)
declare <2 x half> @llvm.colossus.SDAG.unary.v2f16.i32(i32, i32)
declare <2 x half> @llvm.colossus.SDAG.unary.v2f16.v2i16(i32, <2 x i16>)
declare <2 x i32> @llvm.colossus.SDAG.unary.v2i32.v2f32(i32, <2 x float>)
declare <2 x i32> @llvm.colossus.SDAG.unary.v2i32.v4f16(i32, <4 x half>)
declare <4 x i16> @llvm.colossus.SDAG.unary.v4i16.v2f32(i32, <2 x float>)
declare <4 x i16> @llvm.colossus.SDAG.unary.v4i16.v4f16(i32, <4 x half>)
declare <2 x float> @llvm.colossus.SDAG.unary.v2f32.v2i32(i32, <2 x i32>)
declare <2 x float> @llvm.colossus.SDAG.unary.v2f32.v4i16(i32, <4 x i16>)
declare <4 x half> @llvm.colossus.SDAG.unary.v4f16.v2i32(i32, <2 x i32>)
declare <4 x half> @llvm.colossus.SDAG.unary.v4f16.v4i16(i32, <4 x i16>)

; CHECK-LABEL: bitcast_f32_to_i32:
; CHECK:       # %bb
; CHECK-NEXT:  or $m0, $m15, 1073741824
; CHECK-NEXT:  br $m10
define i32 @bitcast_f32_to_i32() {
  %id = load i32, i32* @ISD_BITCAST
  %res = call i32 @llvm.colossus.SDAG.unary.i32.f32(i32 %id, float 2.0)
  ret i32 %res
}

; CHECK-LABEL: bitcast_i32_to_f32:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 42
; CHECK-NEXT:  br $m10
define float @bitcast_i32_to_f32() {
  %id = load i32, i32* @ISD_BITCAST
  %res= call float @llvm.colossus.SDAG.unary.f32.i32(i32 %id, i32 42)
  ret float %res
}

; CHECK-LABEL: bitcast_f32_to_v2i16:
; CHECK:       # %bb
; CHECK-NEXT:  or $m0, $m15, 1073741824
; CHECK-NEXT:  br $m10
define <2 x i16> @bitcast_f32_to_v2i16() {
  %id = load i32, i32* @ISD_BITCAST
  %res= call <2 x i16> @llvm.colossus.SDAG.unary.v2i16.f32(i32 %id, float 2.0)
  ret <2 x i16> %res
}

; CHECK-LABEL: bitcast_v2i16_to_f32:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 983055
; CHECK-NEXT:  br $m10
define float @bitcast_v2i16_to_f32() {
  %id = load i32, i32* @ISD_BITCAST
  %res= call float @llvm.colossus.SDAG.unary.f32.v2i16(i32 %id, <2 x i16> <i16 15, i16 15>)
  ret float %res
}

; CHECK-LABEL: bitcast_v2f16_to_i32:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $m0, 131073
; CHECK-NEXT:  br $m10
define i32 @bitcast_v2f16_to_i32() {
  %id = load i32, i32* @ISD_BITCAST
  %res= call i32 @llvm.colossus.SDAG.unary.i32.v2f16(i32 %id, <2 x half> <half 0xH1, half 0xH2>)
  ret i32 %res
}

; CHECK-LABEL: bitcast_i32_to_v2f16:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 42
; CHECK-NEXT:  br $m10
define <2 x half> @bitcast_i32_to_v2f16() {
  %id = load i32, i32* @ISD_BITCAST
  %res= call <2 x half> @llvm.colossus.SDAG.unary.v2f16.i32(i32 %id, i32 42)
  ret <2 x half> %res
}

; CHECK-LABEL: bitcast_v2f16_to_v2i16:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $m0, 131073
; CHECK-NEXT:  br $m10
define <2 x i16> @bitcast_v2f16_to_v2i16() {
  %id = load i32, i32* @ISD_BITCAST
  %res= call <2 x i16> @llvm.colossus.SDAG.unary.v2i16.v2f16(i32 %id, <2 x half> <half 0xH1, half 0xH2>)
  ret <2 x i16> %res
}

; CHECK-LABEL: bitcast_v2i16_to_v2f16:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 983055
; CHECK-NEXT:  br $m10
define <2 x half> @bitcast_v2i16_to_v2f16() {
  %id = load i32, i32* @ISD_BITCAST
  %res= call <2 x half> @llvm.colossus.SDAG.unary.v2f16.v2i16(i32 %id, <2 x i16> <i16 15, i16 15>)
  ret <2 x half> %res
}

; CHECK-LABEL: bitcast_v2f32_to_v2i32:
; CHECK:       # %bb
; CHECK-DAG:   or $m0, $m15, 1073741824
; CHECK-DAG:   or $m1, $m15, 1082130432
; CHECK-NEXT:  br $m10
define <2 x i32> @bitcast_v2f32_to_v2i32() {
  %id = load i32, i32* @ISD_BITCAST
  %res= call <2 x i32> @llvm.colossus.SDAG.unary.v2i32.v2f32(i32 %id, <2 x float> <float 2.0, float 4.0>)
  ret <2 x i32> %res
}

; CHECK-LABEL: bitcast_v2i32_to_v2f32:
; CHECK:       # %bb
; CHECK-DAG:   setzi $a0, 42
; CHECK-DAG:   setzi $a1, 43
; CHECK-NEXT:  br $m10
define <2 x float> @bitcast_v2i32_to_v2f32() {
  %id = load i32, i32* @ISD_BITCAST
  %res= call <2 x float> @llvm.colossus.SDAG.unary.v2f32.v2i32(i32 %id, <2 x i32> <i32 42, i32 43>)
  ret <2 x float> %res
}

; CHECK-LABEL: bitcast_v2f32_to_v4i16:
; CHECK:       # %bb
; CHECK-DAG:   or $m0, $m15, 1073741824
; CHECK-DAG:   or $m1, $m15, 1082130432
; CHECK-NEXT:  br $m10
define <4 x i16> @bitcast_v2f32_to_v4i16() {
  %id = load i32, i32* @ISD_BITCAST
  %res= call <4 x i16> @llvm.colossus.SDAG.unary.v4i16.v2f32(i32 %id, <2 x float> <float 2.0, float 4.0>)
  ret <4 x i16> %res
}

; CHECK-LABEL: bitcast_v4i16_to_v2f32:
; CHECK:       # %bb
; CHECK-DAG:   setzi $a0, 983055
; CHECK-DAG:   setzi $a1, 851981
; CHECK-NEXT:  br $m10
define <2 x float> @bitcast_v4i16_to_v2f32() {
  %id = load i32, i32* @ISD_BITCAST
  %res= call <2 x float> @llvm.colossus.SDAG.unary.v2f32.v4i16(i32 %id, <4 x i16> <i16 15, i16 15, i16 13, i16 13>)
  ret <2 x float> %res
}

; CHECK-LABEL: bitcast_v4f16_to_v2i32:
; CHECK:       # %bb
; CHECK-DAG:   setzi $m0, 131073
; CHECK-DAG:   setzi $m1, 262147
; CHECK-NEXT:  br $m10
define <2 x i32> @bitcast_v4f16_to_v2i32() {
  %id = load i32, i32* @ISD_BITCAST
  %res= call <2 x i32> @llvm.colossus.SDAG.unary.v2i32.v4f16(i32 %id, <4 x half> <half 0xH1, half 0xH2, half 0xH3, half 0xH4>)
  ret <2 x i32> %res
}

; CHECK-LABEL: bitcast_v2i32_to_v4f16:
; CHECK:       # %bb
; CHECK-DAG:   setzi $a0, 42
; CHECK-DAG:   setzi $a1, 43
; CHECK-NEXT:  br $m10
define <4 x half> @bitcast_v2i32_to_v4f16() {
  %id = load i32, i32* @ISD_BITCAST
  %res= call <4 x half> @llvm.colossus.SDAG.unary.v4f16.v2i32(i32 %id, <2 x i32> <i32 42, i32 43>)
  ret <4 x half> %res
}

; CHECK-LABEL: bitcast_v4f16_to_v4i16:
; CHECK:       # %bb
; CHECK-DAG:   setzi $m0, 131073
; CHECK-DAG:   setzi $m1, 262147
; CHECK-NEXT:  br $m10
define <4 x i16> @bitcast_v4f16_to_v4i16() {
  %id = load i32, i32* @ISD_BITCAST
  %res= call <4 x i16> @llvm.colossus.SDAG.unary.v4i16.v4f16(i32 %id, <4 x half> <half 0xH1, half 0xH2, half 0xH3, half 0xH4>)
  ret <4 x i16> %res
}

; CHECK-LABEL: bitcast_v4i16_to_v4f16:
; CHECK:       # %bb
; CHECK-DAG:   setzi $a0, 131073
; CHECK-DAG:   setzi $a1, 262147
; CHECK-NEXT:  br $m10
define <4 x half> @bitcast_v4i16_to_v4f16() {
  %id = load i32, i32* @ISD_BITCAST
  %res= call <4 x half> @llvm.colossus.SDAG.unary.v4f16.v4i16(i32 %id, <4 x i16> <i16 1, i16 2, i16 3, i16 4>)
  ret <4 x half> %res
}
