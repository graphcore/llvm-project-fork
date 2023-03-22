; RUN: llvm-link %isdopc %s | opt -instcombine -always-inline -mattr=+ipu1 | llc -march=colossus -colossus-coissue=false -mattr=+ipu1 | FileCheck %s
; RUN: llvm-link %isdopc %s | opt -instcombine -always-inline -mattr=+ipu2 | llc -march=colossus -colossus-coissue=false -mattr=+ipu2 | FileCheck %s
target triple = "colossus-graphcore--elf"

@ColossusISD_FAND = external constant i32
@ColossusISD_FOR = external constant i32
@ColossusISD_ANDC = external constant i32

declare float @llvm.colossus.SDAG.binary.f32.f32.f32(i32, float, float)

define float @AND(float %x, i32 %imm) #0 {
  %y = bitcast i32 %imm to float
  %id = load i32, i32* @ColossusISD_FAND
  %res = call float @llvm.colossus.SDAG.binary.f32.f32.f32(i32 %id, float %x, float %y)
  ret float %res
}
define float @OR(float %x, i32 %imm) #0 {
  %y = bitcast i32 %imm to float
  %id = load i32, i32* @ColossusISD_FOR
  %res = call float @llvm.colossus.SDAG.binary.f32.f32.f32(i32 %id, float %x, float %y)
  ret float %res
}
define float @ANDC(float %x, i32 %imm) #0 {
  %y = bitcast i32 %imm to float
  %id = load i32, i32* @ColossusISD_ANDC
  %res = call float @llvm.colossus.SDAG.binary.f32.f32.f32(i32 %id, float %x, float %y)
  ret float %res
}
attributes #0 = {alwaysinline}

; CHECK-LABEL: and_a_zi12:
; CHECK:       # %bb
; CHECK-NEXT:  and $a0, $a0, 4095
; CHECK:       br $m10
define float @and_a_zi12(float %x) {
  %res = call float @AND(float %x, i32 4095) ; cst = 0xFFF
  ret float %res
}

; CHECK-LABEL: and_a_zi12_over:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a1, 4096
; CHECK-NEXT:  and $a0, $a0, $a1
; CHECK:       br $m10
define float @and_a_zi12_over(float %x) {
  %res = call float @AND(float %x, i32 4096) ; cst = 0x1000
  ret float %res
}

; CHECK-LABEL: and_a_iz12:
; CHECK:       # %bb
; CHECK-NEXT:  and $a0, $a0, 4293918720
; CHECK:       br $m10
define float @and_a_iz12(float %x) {
  %res = call float @AND(float %x, i32 4293918720) ; cst = 0xFFF00000
  ret float %res
}

; CHECK-LABEL: and_a_iz12_over:
; CHECK:       # %bb
; CHECK-NEXT:  setzi [[SETREG:\$a[1-5]]], 524288
; CHECK-NEXT:  or $a1, [[SETREG]], 4293918720
; CHECK-NEXT:  and $a0, $a0, $a1
; CHECK:       br $m10
define float @and_a_iz12_over(float %x) {
  %res = call float @AND(float %x, i32 4294443008) ; cst = 0xFFF80000
  ret float %res
}

; CHECK-LABEL: or_a_zi12:
; CHECK:       # %bb
; CHECK-NEXT:  or $a0, $a0, 4095
; CHECK:       br $m10
define float @or_a_zi12(float %x) {
  %res = call float @OR(float %x, i32 4095) ; cst = 0xFFF
  ret float %res
}

; CHECK-LABEL: or_a_zi12_over:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a1, 4096
; CHECK-NEXT:  or $a0, $a0, $a1
; CHECK:       br $m10
define float @or_a_zi12_over(float %x) {
  %res = call float @OR(float %x, i32 4096) ; cst = 0x1000
  ret float %res
}

; CHECK-LABEL: or_a_iz12:
; CHECK:       # %bb
; CHECK-NEXT:  or $a0, $a0, 4293918720
; CHECK:       br $m10
define float @or_a_iz12(float %x) {
  %res = call float @OR(float %x, i32 4293918720) ; cst = 0xFFF00000
  ret float %res
}

; CHECK-LABEL: or_a_iz12_over:
; CHECK:       # %bb
; CHECK-NEXT:  setzi [[SETREG:\$a[1-5]]], 524288
; CHECK-NEXT:  or $a1, [[SETREG]], 4293918720
; CHECK-NEXT:  or $a0, $a0, $a1
; CHECK:       br $m10
define float @or_a_iz12_over(float %x) {
  %res = call float @OR(float %x, i32 4294443008) ; cst = 0xFFF80000
  ret float %res
}

; CHECK-LABEL: andc_a_zi12:
; CHECK:       # %bb
; CHECK-NEXT:  andc $a0, $a0, 4095
; CHECK:       br $m10
define float @andc_a_zi12(float %x) {
  %res = call float @ANDC(float %x, i32 4095) ; cst = 0xFFF
  ret float %res
}

; CHECK-LABEL: andc_a_zi12_over:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a1, 4096
; CHECK-NEXT:  andc $a0, $a0, $a1
; CHECK:       br $m10
define float @andc_a_zi12_over(float %x) {
  %res = call float @ANDC(float %x, i32 4096) ; cst = 0x1000
  ret float %res
}

; CHECK-LABEL: andc_a_iz12:
; CHECK:       # %bb
; CHECK-NEXT:  andc $a0, $a0, 4293918720
; CHECK:       br $m10
define float @andc_a_iz12(float %x) {
  %res = call float @ANDC(float %x, i32 4293918720) ; cst = 0xFFF00000
  ret float %res
}

; CHECK-LABEL: andc_a_iz12_over:
; CHECK:       # %bb
; CHECK-NEXT:  setzi [[SETREG:\$a[1-5]]], 524288
; CHECK-NEXT:  or $a1, [[SETREG]], 4293918720
; CHECK-NEXT:  andc $a0, $a0, $a1
; CHECK:       br $m10
define float @andc_a_iz12_over(float %x) {
  %res = call float @ANDC(float %x, i32 4294443008) ; cst = 0xFFF80000
  ret float %res
}
