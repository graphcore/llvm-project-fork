; RUN: llvm-link %isdopc %s | opt -instcombine -always-inline -mattr=+ipu1 | llc -march=colossus -colossus-coissue=false -mattr=+ipu1 | FileCheck %s
; RUN: llvm-link %isdopc %s | opt -instcombine -always-inline -mattr=+ipu2 | llc -march=colossus -colossus-coissue=false -mattr=+ipu2 | FileCheck %s

; Declare the intrinsics with whatever legal types are desired
; Illegal types would need the type legaliser to understand the intrinsics
declare <2 x i32> @llvm.colossus.SDAG.unary.v2i32.v2i16(i32, <2 x i16>)
declare float @llvm.colossus.SDAG.unary.f32.f32(i32, float)

declare i16 @llvm.colossus.SDAG.binary.i16.i16.i16(i32, i16, i16)
declare i32 @llvm.colossus.SDAG.binary.i32.i32.i32(i32, i32, i32)
declare float @llvm.colossus.SDAG.binary.f32.f32.f32(i32, float, float)

; Pull in the magic numbers from isd_opcode_constants.ll (from ISDOpcodes)
@ColossusISD_FNOT = external constant i32
@ColossusISD_FAND = external constant i32
@ISD_AND = external constant i32
@ISD_ADD = external constant i32
@ISD_SDIV = external constant i32
@ISD_ANY_EXTEND = external constant i32

; Check we can lower a unary function
; CHECK-LABEL:  sdag_fnot:
; CHECK:        # %bb.0:
; CHECK-NEXT:   not $a0, $a0
; CHECK-NEXT:   br $m10
define float @sdag_fnot(float %x) {
 %id = load i32, i32* @ColossusISD_FNOT
 %res = call float @llvm.colossus.SDAG.unary.f32.f32(i32 %id, float %x)
 ret float %res
}

; Check we can lower a binary function
; CHECK-LABEL:  sdag_and:
; CHECK:        # %bb.0:
; CHECK-NEXT:   and $m0, $m0, $m1
; CHECK-NEXT:   br $m10
define i32 @sdag_and(i32 %x, i32 %y) {
 %id = load i32, i32* @ISD_AND
 %res = call i32 @llvm.colossus.SDAG.binary.i32.i32.i32(i32 %id, i32 %x, i32 %y)
 ret i32 %res
}

; Example of factoring out the constant loading without making more intrinsics
define internal float @FANDF32(float %x, float %y) #0
{
 %id = load i32, i32* @ColossusISD_FAND
 %res = call float @llvm.colossus.SDAG.binary.f32.f32.f32(i32 %id, float %x, float %y)
 ret float %res
}
attributes #0 = {alwaysinline}

; CHECK-LABEL:  sdag_fand:
; CHECK:        # %bb.0:
; CHECK-NEXT:   and $a0, $a0, $a1
; CHECK-NEXT:   br $m10
define float @sdag_fand(float %x, float %y) {
  %res = call float @FANDF32(float %x, float %y)
  ret float %res
}

; Example of creating non-register class typed node
; CHECK-LABEL: add_i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  add $m0, $m0, $m1
; CHECK-NEXT:  br $m10
define i16 @add_i16(i16 %x, i16 %y) {
  %id = load i32, i32* @ISD_ADD
  %res = call i16 @llvm.colossus.SDAG.binary.i16.i16.i16(i32 %id, i16 %x, i16 %y)
  ret i16 %res
}

; Example of creating an illegal operation node
; CHECK-LABEL: sdiv_i32:
; CHECK:       call $m10, __divsi3
; CHECK:       br $m10
define i32 @sdiv_i32(i32 %x, i32 %y) {
    %id = load i32, i32* @ISD_SDIV
    %res = call i32 @llvm.colossus.SDAG.binary.i32.i32.i32(i32 %id, i32 %x, i32 %y)
    ret i32 %res
}

; Example of testing an operation that was previously untestable (see T1767)
; CHECK-LABEL: anyext_v2i16_to_v2i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK-NEXT:  shr $m1, $m0, 16
; CHECK-NEXT:  br $m10
define <2 x i32> @anyext_v2i16_to_v2i32(i32 %ignore, <2 x i16> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND
  %res = call <2 x i32>  @llvm.colossus.SDAG.unary.v2i32.v2i16(i32 %id, <2 x i16> %x)
  ret <2 x i32> %res
}
