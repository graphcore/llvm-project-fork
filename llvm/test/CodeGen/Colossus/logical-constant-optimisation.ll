; RUN: llvm-link %isdopc %s | opt -instcombine -always-inline -mattr=+ipu1 | llc -march=colossus -colossus-coissue=false -mattr=+ipu1 | FileCheck %s
; RUN: llvm-link %isdopc %s | opt -instcombine -always-inline -mattr=+ipu2 | llc -march=colossus -colossus-coissue=false -mattr=+ipu2 | FileCheck %s
target triple = "colossus-graphcore--elf"

; Simplify fand/for/fandc with zero or minus one arguments

declare float @llvm.colossus.SDAG.binary.f32.f32.f32(i32, float, float)

@ColossusISD_FAND = external constant i32
@ColossusISD_FOR = external constant i32
@ColossusISD_ANDC = external constant i32

define internal float @fand(float %x, float %y) #0 {
   %id = load i32, i32* @ColossusISD_FAND
   %res = call float @llvm.colossus.SDAG.binary.f32.f32.f32(i32 %id, float %x, float %y)
   ret float %res
}
define internal float @for(float %x, float %y) #0 {
   %id = load i32, i32* @ColossusISD_FOR
   %res = call float @llvm.colossus.SDAG.binary.f32.f32.f32(i32 %id, float %x, float %y)
   ret float %res
}
define internal float @fandc(float %x, float %y) #0 {
   %id = load i32, i32* @ColossusISD_ANDC
   %res = call float @llvm.colossus.SDAG.binary.f32.f32.f32(i32 %id, float %x, float %y)
   ret float %res
}

; CHECK-LABEL: fand_x_0:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a15
; CHECK-NEXT:  br $m10
define float @fand_x_0(float %unused, float %x) {
  %res = call float @fand(float %x, float 0.0)
  ret float %res
}

; CHECK-LABEL: fand_0_x:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a15
; CHECK-NEXT:  br $m10
define float @fand_0_x(float %unused, float %x) {
  %res = call float @fand(float 0.0, float %x)
  ret float %res
}

; CHECK-LABEL: fand_x_m1:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a1
; CHECK-NEXT:  br $m10
define float @fand_x_m1(float %unused, float %x) {
  %m1 = bitcast i32 -1 to float
  %res = call float @fand(float %x, float %m1)
  ret float %res
}

; CHECK-LABEL: fand_m1_x:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a1
; CHECK-NEXT:  br $m10
define float @fand_m1_x(float %unused, float %x) {
  %m1 = bitcast i32 -1 to float
  %res = call float @fand(float %m1, float %x)
  ret float %res
}

; CHECK-LABEL: for_x_0:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a1
; CHECK-NEXT:  br $m10
define float @for_x_0(float %unused, float %x) {
  %res = call float @for(float %x, float 0.0)
  ret float %res
}

; CHECK-LABEL: for_0_x:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a1
; CHECK-NEXT:  br $m10
define float @for_0_x(float %unused, float %x) {
  %res = call float @for(float 0.0, float %x)
  ret float %res
}

; CHECK-LABEL: for_x_m1:
; CHECK:       # %bb
; CHECK-NEXT:  not $a0, $a15
; CHECK-NEXT:  br $m10
define float @for_x_m1(float %unused, float %x) {
  %m1 = bitcast i32 -1 to float
  %res = call float @for(float %x, float %m1)
  ret float %res
}

; CHECK-LABEL: for_m1_x:
; CHECK:       # %bb
; CHECK-NEXT:  not $a0, $a15
; CHECK-NEXT:  br $m10
define float @for_m1_x(float %unused, float %x) {
  %m1 = bitcast i32 -1 to float
  %res = call float @for(float %m1, float %x)
  ret float %res
}

; CHECK-LABEL: fandc_x_0:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a1
; CHECK-NEXT:  br $m10
define float @fandc_x_0(float %unused, float %x) {
  %res = call float @fandc(float %x, float 0.0)
  ret float %res
}

; CHECK-LABEL: fandc_0_x:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a15
; CHECK-NEXT:  br $m10
define float @fandc_0_x(float %unused, float %x) {
  %res = call float @fandc(float 0.0, float %x)
  ret float %res
}

; CHECK-LABEL: fandc_x_m1:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a15
; CHECK-NEXT:  br $m10
define float @fandc_x_m1(float %unused, float %x) {
  %m1 = bitcast i32 -1 to float
  %res = call float @fandc(float %x, float %m1)
  ret float %res
}

; CHECK-LABEL: fandc_m1_x:
; CHECK:       # %bb
; CHECK-NEXT:  not $a0, $a1
; CHECK-NEXT:  br $m10
define float @fandc_m1_x(float %unused, float %x) {
  %m1 = bitcast i32 -1 to float
  %res = call float @fandc(float %m1, float %x)
  ret float %res
}

attributes #0 = {alwaysinline}
