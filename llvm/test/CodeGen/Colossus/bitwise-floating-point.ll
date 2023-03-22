; RUN: llvm-link %isdopc %s | opt -instcombine -always-inline -mattr=+ipu1 | llc -march=colossus -colossus-coissue=false -mattr=+ipu1 | FileCheck %s
; RUN: llvm-link %isdopc %s | opt -instcombine -always-inline -mattr=+ipu2 | llc -march=colossus -colossus-coissue=false -mattr=+ipu2 | FileCheck %s

; There is test coverage in xxx-arithmetic to check that integers that are
; bitcast to floats are successfully matched to ColossusISD nodes.
; These tests check that the floating point nodes themselves all have patterns

@ColossusISD_FNOT = external constant i32
@ColossusISD_FAND = external constant i32
@ColossusISD_FOR = external constant i32
@ColossusISD_ANDC = external constant i32

declare half @llvm.colossus.SDAG.unary.f16.f16(i32, half)
declare half @llvm.colossus.SDAG.binary.f16.f16.f16(i32, half, half)
declare <2 x half> @llvm.colossus.SDAG.unary.v2f16.v2f16(i32, <2 x half>)
declare <2 x half> @llvm.colossus.SDAG.binary.v2f16.v2f16.v2f16(i32, <2 x half>, <2 x half>)
declare <4 x half> @llvm.colossus.SDAG.unary.v4f16.v4f16(i32, <4 x half>)
declare <4 x half> @llvm.colossus.SDAG.binary.v4f16.v4f16.v4f16(i32, <4 x half>, <4 x half>)

declare float @llvm.colossus.SDAG.unary.f32.f32(i32, float)
declare float @llvm.colossus.SDAG.binary.f32.f32.f32(i32, float, float)
declare <2 x float> @llvm.colossus.SDAG.unary.v2f32.v2f32(i32, <2 x float>)
declare <2 x float> @llvm.colossus.SDAG.binary.v2f32.v2f32.v2f32(i32, <2 x float>, <2 x float>)

; CHECK-LABEL: fnot_f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  not $a0, $a0
; CHECK-NEXT:  br $m10
define half @fnot_f16(half %x) {
  %id = load i32, i32* @ColossusISD_FNOT
  %res = call half @llvm.colossus.SDAG.unary.f16.f16(i32 %id, half %x)
  ret half %res
}

; CHECK-LABEL: fnot_v2f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  not $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @fnot_v2f16(<2 x half> %x) {
  %id = load i32, i32* @ColossusISD_FNOT
  %res = call <2 x half> @llvm.colossus.SDAG.unary.v2f16.v2f16(i32 %id, <2 x half> %x)
  ret <2 x half> %res
}

; CHECK-LABEL: fnot_v4f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  not64 $a0:1, $a0:1
; CHECK-NEXT:  br $m10
define <4 x half> @fnot_v4f16(<4 x half> %x) {
  %id = load i32, i32* @ColossusISD_FNOT
  %res = call <4 x half> @llvm.colossus.SDAG.unary.v4f16.v4f16(i32 %id, <4 x half> %x)
  ret <4 x half> %res
}

; CHECK-LABEL: fnot_f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  not $a0, $a0
; CHECK-NEXT:  br $m10
define float @fnot_f32(float %x) {
  %id = load i32, i32* @ColossusISD_FNOT
  %res = call float @llvm.colossus.SDAG.unary.f32.f32(i32 %id, float %x)
  ret float %res
}

; CHECK-LABEL: fnot_v2f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  not64 $a0:1, $a0:1
; CHECK-NEXT:  br $m10
define <2 x float> @fnot_v2f32(<2 x float> %x) {
  %id = load i32, i32* @ColossusISD_FNOT
  %res = call <2 x float> @llvm.colossus.SDAG.unary.v2f32.v2f32(i32 %id, <2 x float> %x)
  ret <2 x float> %res
}

; CHECK-LABEL: fand_f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  and $a0, $a0, $a1
; CHECK-NEXT:  br $m10
define half @fand_f16(half %x, half %y) {
  %id = load i32, i32* @ColossusISD_FAND
  %res = call half @llvm.colossus.SDAG.binary.f16.f16.f16(i32 %id, half %x, half %y)
  ret half %res
}

; CHECK-LABEL: fand_v2f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  and $a0, $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @fand_v2f16(<2 x half> %x, <2 x half> %y) {
  %id = load i32, i32* @ColossusISD_FAND
  %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16.v2f16.v2f16(i32 %id, <2 x half> %x, <2 x half> %y)
  ret <2 x half> %res
}

; CHECK-LABEL: fand_v4f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  and64 $a0:1, $a0:1, $a2:3
; CHECK-NEXT:  br $m10
define <4 x half> @fand_v4f16(<4 x half> %x, <4 x half> %y) {
  %id = load i32, i32* @ColossusISD_FAND
  %res = call <4 x half> @llvm.colossus.SDAG.binary.v4f16.v4f16.v4f16(i32 %id, <4 x half> %x, <4 x half> %y)
  ret <4 x half> %res
}

; CHECK-LABEL: fand_f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  and $a0, $a0, $a1
; CHECK-NEXT:  br $m10
define float @fand_f32(float %x, float %y) {
  %id = load i32, i32* @ColossusISD_FAND
  %res = call float @llvm.colossus.SDAG.binary.f32.f32.f32(i32 %id, float %x, float %y)
  ret float %res
}

; CHECK-LABEL: fand_v2f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  and64 $a0:1, $a0:1, $a2:3
; CHECK-NEXT:  br $m10
define <2 x float> @fand_v2f32(<2 x float> %x, <2 x float> %y) {
  %id = load i32, i32* @ColossusISD_FAND
  %res = call <2 x float> @llvm.colossus.SDAG.binary.v2f32.v2f32.v2f32(i32 %id, <2 x float> %x, <2 x float> %y)
  ret <2 x float> %res
}

; CHECK-LABEL: for_f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  or $a0, $a0, $a1
; CHECK-NEXT:  br $m10
define half @for_f16(half %x, half %y) {
  %id = load i32, i32* @ColossusISD_FOR
  %res = call half @llvm.colossus.SDAG.binary.f16.f16.f16(i32 %id, half %x, half %y)
  ret half %res
}

; CHECK-LABEL: for_v2f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  or $a0, $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @for_v2f16(<2 x half> %x, <2 x half> %y) {
  %id = load i32, i32* @ColossusISD_FOR
  %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16.v2f16.v2f16(i32 %id, <2 x half> %x, <2 x half> %y)
  ret <2 x half> %res
}

; CHECK-LABEL: for_v4f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  or64 $a0:1, $a0:1, $a2:3
; CHECK-NEXT:  br $m10
define <4 x half> @for_v4f16(<4 x half> %x, <4 x half> %y) {
  %id = load i32, i32* @ColossusISD_FOR
  %res = call <4 x half> @llvm.colossus.SDAG.binary.v4f16.v4f16.v4f16(i32 %id, <4 x half> %x, <4 x half> %y)
  ret <4 x half> %res
}

; CHECK-LABEL: for_f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  or $a0, $a0, $a1
; CHECK-NEXT:  br $m10
define float @for_f32(float %x, float %y) {
  %id = load i32, i32* @ColossusISD_FOR
  %res = call float @llvm.colossus.SDAG.binary.f32.f32.f32(i32 %id, float %x, float %y)
  ret float %res
}

; CHECK-LABEL: for_v2f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  or64 $a0:1, $a0:1, $a2:3
; CHECK-NEXT:  br $m10
define <2 x float> @for_v2f32(<2 x float> %x, <2 x float> %y) {
  %id = load i32, i32* @ColossusISD_FOR
  %res = call <2 x float> @llvm.colossus.SDAG.binary.v2f32.v2f32.v2f32(i32 %id, <2 x float> %x, <2 x float> %y)
  ret <2 x float> %res
}

; CHECK-LABEL: andc_f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  andc $a0, $a0, $a1
; CHECK-NEXT:  br $m10
define half @andc_f16(half %x, half %y) {
  %id = load i32, i32* @ColossusISD_ANDC
  %res = call half @llvm.colossus.SDAG.binary.f16.f16.f16(i32 %id, half %x, half %y)
  ret half %res
}

; CHECK-LABEL: andc_v2f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  andc $a0, $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @andc_v2f16(<2 x half> %x, <2 x half> %y) {
  %id = load i32, i32* @ColossusISD_ANDC
  %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16.v2f16.v2f16(i32 %id, <2 x half> %x, <2 x half> %y)
  ret <2 x half> %res
}

; CHECK-LABEL: andc_v4f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  andc64 $a0:1, $a0:1, $a2:3
; CHECK-NEXT:  br $m10
define <4 x half> @andc_v4f16(<4 x half> %x, <4 x half> %y) {
  %id = load i32, i32* @ColossusISD_ANDC
  %res = call <4 x half> @llvm.colossus.SDAG.binary.v4f16.v4f16.v4f16(i32 %id, <4 x half> %x, <4 x half> %y)
  ret <4 x half> %res
}

; CHECK-LABEL: andc_f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  andc $a0, $a0, $a1
; CHECK-NEXT:  br $m10
define float @andc_f32(float %x, float %y) {
  %id = load i32, i32* @ColossusISD_ANDC
  %res = call float @llvm.colossus.SDAG.binary.f32.f32.f32(i32 %id, float %x, float %y)
  ret float %res
}

; CHECK-LABEL: andc_v2f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  andc64 $a0:1, $a0:1, $a2:3
; CHECK-NEXT:  br $m10
define <2 x float> @andc_v2f32(<2 x float> %x, <2 x float> %y) {
  %id = load i32, i32* @ColossusISD_ANDC
  %res = call <2 x float> @llvm.colossus.SDAG.binary.v2f32.v2f32.v2f32(i32 %id, <2 x float> %x, <2 x float> %y)
  ret <2 x float> %res
}
