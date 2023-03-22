; RUN: llvm-link %isdopc %s | opt -instcombine -always-inline -mattr=+ipu1 | llc -march=colossus -colossus-coissue=false -mattr=+ipu1 | FileCheck %s
; RUN: llvm-link %isdopc %s | opt -instcombine -always-inline -mattr=+ipu2 | llc -march=colossus -colossus-coissue=false -mattr=+ipu2 | FileCheck %s

@ISD_AND = external constant i32
@ISD_OR = external constant i32
@ISD_XOR = external constant i32
@ColossusISD_FAND = external constant i32
@ColossusISD_FOR = external constant i32
@ColossusISD_ANDC = external constant i32
@ColossusISD_FNOT = external constant i32

declare i32 @llvm.colossus.SDAG.binary.i32.i32.i32(i32, i32, i32)
declare float @llvm.colossus.SDAG.binary.f32.f32.f32(i32, float, float)
declare <2 x float> @llvm.colossus.SDAG.binary.v2f32.v2f32.v2f32(i32, <2 x float>, <2 x float>)
declare float @llvm.colossus.SDAG.unary.f32.f32(i32, float)

; CHECK-LABEL: and_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK-NEXT:  br $m10
define i32 @and_i32(i32 %ignore, i32 %x) {
  %id = load i32, i32* @ISD_AND
  %res = call i32 @llvm.colossus.SDAG.binary.i32.i32.i32(i32 %id, i32 %x, i32 %x)
  ret i32 %res
}

; CHECK-LABEL: and_i32_undef:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m15
; CHECK-NEXT:  br $m10
define i32 @and_i32_undef(i32 %ignore) {
  %id = load i32, i32* @ISD_AND
  %res = call i32 @llvm.colossus.SDAG.binary.i32.i32.i32(i32 %id, i32 undef, i32 undef)
  ret i32 %res
}

; CHECK-LABEL: or_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK-NEXT:  br $m10
define i32 @or_i32(i32 %ignore, i32 %x) {
  %id = load i32, i32* @ISD_OR
  %res = call i32 @llvm.colossus.SDAG.binary.i32.i32.i32(i32 %id, i32 %x, i32 %x)
  ret i32 %res
}

; CHECK-LABEL: or_i32_undef:
; CHECK:       # %bb.0:
; CHECK-NEXT:  add $m0, $m15, -1
; CHECK-NEXT:  br $m10
define i32 @or_i32_undef(i32 %ignore) {
  %id = load i32, i32* @ISD_OR
  %res = call i32 @llvm.colossus.SDAG.binary.i32.i32.i32(i32 %id, i32 undef, i32 undef)
  ret i32 %res
}

; CHECK-LABEL: xor_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m15
; CHECK-NEXT:  br $m10
define i32 @xor_i32(i32 %ignore, i32 %x) {
  %id = load i32, i32* @ISD_XOR
  %res = call i32 @llvm.colossus.SDAG.binary.i32.i32.i32(i32 %id, i32 %x, i32 %x)
  ret i32 %res
}

; CHECK-LABEL: xor_i32_undef:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m15
; CHECK-NEXT:  br $m10
define i32 @xor_i32_undef(i32 %ignore) {
  %id = load i32, i32* @ISD_XOR
  %res = call i32 @llvm.colossus.SDAG.binary.i32.i32.i32(i32 %id, i32 undef, i32 undef)
  ret i32 %res
}

; CHECK-LABEL: andc_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m15
; CHECK-NEXT:  br $m10
define i32 @andc_i32(i32 %ignore, i32 %x) {
  %id = load i32, i32* @ColossusISD_ANDC
  %res = call i32 @llvm.colossus.SDAG.binary.i32.i32.i32(i32 %id, i32 %x, i32 %x)
  ret i32 %res
}

; CHECK-LABEL: andc_i32_undef:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m15
; CHECK-NEXT:  br $m10
define i32 @andc_i32_undef(i32 %ignore) {
  %id = load i32, i32* @ColossusISD_ANDC
  %res = call i32 @llvm.colossus.SDAG.binary.i32.i32.i32(i32 %id, i32 undef, i32 undef)
  ret i32 %res
}

; CHECK-LABEL: and_f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $a0, $a1
; CHECK-NEXT:  br $m10
define float @and_f32(float %ignore, float %x) {
  %id = load i32, i32* @ColossusISD_FAND
  %res = call float @llvm.colossus.SDAG.binary.f32.f32.f32(i32 %id, float %x, float %x)
  ret float %res
}

; CHECK-LABEL: and_f32_undef:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $a0, $a15
; CHECK-NEXT:  br $m10
define float @and_f32_undef(float %ignore) {
  %id = load i32, i32* @ColossusISD_FAND
  %res = call float @llvm.colossus.SDAG.binary.f32.f32.f32(i32 %id, float undef, float undef)
  ret float %res
}

; CHECK-LABEL: or_f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $a0, $a1
; CHECK-NEXT:  br $m10
define float @or_f32(float %ignore, float %x) {
  %id = load i32, i32* @ColossusISD_FOR
  %res = call float @llvm.colossus.SDAG.binary.f32.f32.f32(i32 %id, float %x, float %x)
  ret float %res
}

; CHECK-LABEL: or_f32_undef:
; CHECK:       # %bb.0:
; CHECK-NEXT:  not $a0, $a15
; CHECK-NEXT:  br $m10
define float @or_f32_undef(float %ignore) {
  %id = load i32, i32* @ColossusISD_FOR
  %res = call float @llvm.colossus.SDAG.binary.f32.f32.f32(i32 %id, float undef, float undef)
  ret float %res
}

; CHECK-LABEL: andc_f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $a0, $a15
; CHECK-NEXT:  br $m10
define float @andc_f32(float %ignore, float %x) {
  %id = load i32, i32* @ColossusISD_ANDC
  %res = call float @llvm.colossus.SDAG.binary.f32.f32.f32(i32 %id, float %x, float %x)
  ret float %res
}

; CHECK-LABEL: andc_f32_undef:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $a0, $a15
; CHECK-NEXT:  br $m10
define float @andc_f32_undef(float %ignore) {
  %id = load i32, i32* @ColossusISD_ANDC
  %res = call float @llvm.colossus.SDAG.binary.f32.f32.f32(i32 %id, float undef, float undef)
  ret float %res
}

; Whitebox. FOR is the only case the checks the size of the type
; CHECK-LABEL: or_v2f32_undef:
; CHECK:       # %bb.0:
; CHECK-NEXT:  not64 $a0:1, $a14:15
; CHECK-NEXT:  br $m10
define <2 x float> @or_v2f32_undef(<2 x float> %ignore) {
  %id = load i32, i32* @ColossusISD_FOR
  %res = call <2 x float> @llvm.colossus.SDAG.binary.v2f32.v2f32.v2f32(i32 %id, <2 x float> undef, <2 x float> undef)
  ret <2 x float> %res
}

; This is a convenient place to check the handling of undef for the only unary biwise op

; CHECK-LABEL: not_i32_undef:
; CHECK:       # %bb.0:
; CHECK-NEXT:  br $m10
define i32 @not_i32_undef(i32 %ignore) {
  %id = load i32, i32* @ISD_XOR
  %res = call i32 @llvm.colossus.SDAG.binary.i32.i32.i32(i32 %id, i32 undef, i32 -1)
  ret i32 %res
}

; CHECK-LABEL: not_f32_undef:
; CHECK:       # %bb.0:
; CHECK-NEXT:  br $m10
define float @not_f32_undef(float %ignore) {
  %id = load i32, i32* @ColossusISD_FNOT
  %res = call float @llvm.colossus.SDAG.unary.f32.f32(i32 %id, float undef)
  ret float %res
}
