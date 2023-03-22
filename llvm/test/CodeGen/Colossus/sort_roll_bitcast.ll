; RUN: llvm-link %isdopc %s | opt -instcombine -always-inline -mattr=+ipu1 | llc -march=colossus -colossus-coissue=false -mattr=+ipu1 | FileCheck %s
; RUN: llvm-link %isdopc %s | opt -instcombine -always-inline -mattr=+ipu2 | llc -march=colossus -colossus-coissue=false -mattr=+ipu2 | FileCheck %s

declare float @llvm.colossus.SDAG.binary.f32(i32, float, float)
declare i32 @llvm.colossus.SDAG.binary.i32(i32, i32, i32)
declare <2 x half> @llvm.colossus.SDAG.binary.v2f16(i32, <2 x half>, <2 x half>)
@ColossusISD_SORT4X16LO = external constant i32
@ColossusISD_SORT4X16HI = external constant i32
@ColossusISD_ROLL16 = external constant i32

; CHECK-LABEL: all_values_cast:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $m0, $m0, $m1
; CHECK-NEXT:  br $m10
define i32 @all_values_cast(i32 %x, i32 %y) {
  %id = load i32, i32* @ColossusISD_SORT4X16LO
  %xf = bitcast i32 %x to float
  %yf = bitcast i32 %y to float
  %rf = call float @llvm.colossus.SDAG.binary.f32(i32 %id, float %xf, float %yf)
  %ri = bitcast float %rf to i32
  ret i32 %ri
}

; CHECK-LABEL: both_args_cast:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a0, $a1
; CHECK-NEXT:  mov $m0, $a0
; CHECK-NEXT:  br $m10
define i32 @both_args_cast(float %x, <2 x half> %y) {
  %id = load i32, i32* @ColossusISD_SORT4X16HI
  %xi = bitcast float %x to i32
  %yi = bitcast <2 x half> %y to i32
  %ri = call i32 @llvm.colossus.SDAG.binary.i32(i32 %id, i32 %xi, i32 %yi)
  ret i32 %ri
}

; CHECK-LABEL: arg_and_result_cast:
; CHECK:       # %bb
; CHECK-NEXT:  mov $m1, $a0
; CHECK-NEXT:  roll16 $m0, $m0, $m1
; CHECK-NEXT:  br $m10
define i32 @arg_and_result_cast(i32 %x, float %y) {
  %id = load i32, i32* @ColossusISD_ROLL16
  %xf = bitcast i32 %x to float
  %rf = call float @llvm.colossus.SDAG.binary.f32(i32 %id, float %xf, float %y)
  %ri = bitcast float %rf to i32
  ret i32 %ri
}

; CHECK-LABEL: combine_through_bitcast_within_regfile:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @combine_through_bitcast_within_regfile(float %x0, float %x1, <2 x half> %x2) {
  %rollid = load i32, i32* @ColossusISD_ROLL16
  %sortid = load i32, i32* @ColossusISD_SORT4X16LO 
  %x3 = call float @llvm.colossus.SDAG.binary.f32(i32 %rollid, float %x1, float %x0)
  %x4 = bitcast float %x3 to <2 x half> 
  %x5 = bitcast float %x1 to <2 x half>
  %x6 = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(i32 %sortid, <2 x half> %x4, <2 x half> %x5)
  ret <2 x half> %x6
}
