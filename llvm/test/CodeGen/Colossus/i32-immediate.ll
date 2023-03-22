; RUN: llvm-link %isdopc %s | opt -instcombine -always-inline -mattr=+ipu1 | llc -march=colossus -colossus-coissue=false -mattr=+ipu1 | FileCheck %s
; RUN: llvm-link %isdopc %s | opt -instcombine -always-inline -mattr=+ipu2 | llc -march=colossus -colossus-coissue=false -mattr=+ipu2 | FileCheck %s
target triple = "colossus-graphcore--elf"

@ColossusISD_ANDC = external constant i32

declare i32 @llvm.colossus.SDAG.binary.i32.i32.i32(i32, i32, i32)

define i32 @ANDC(i32 %x, i32 %imm) #0 {
  %y = bitcast i32 %imm to i32
  %id = load i32, i32* @ColossusISD_ANDC
  %res = call i32 @llvm.colossus.SDAG.binary.i32.i32.i32(i32 %id, i32 %x, i32 %y)
  ret i32 %res
}
attributes #0 = {alwaysinline}

; CHECK-LABEL: and_a_zi12:
; CHECK:       # %bb
; CHECK-NEXT:  and $m0, $m0, 4095
; CHECK:       br $m10
define i32 @and_a_zi12(i32 %x) {
  %res = and i32 %x, 4095 ; cst = 0xFFF
  ret i32 %res
}

; CHECK-LABEL: and_a_zi12_over:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $m1, 4096
; CHECK-NEXT:  and $m0, $m0, $m1
; CHECK:       br $m10
define i32 @and_a_zi12_over(i32 %x) {
  %res = and i32 %x, 4096 ; cst = 0x1000
  ret i32 %res
}

; CHECK-LABEL: or_a_zi12:
; CHECK:       # %bb
; CHECK-NEXT:  or $m0, $m0, 4095
; CHECK:       br $m10
define i32 @or_a_zi12(i32 %x) {
  %res = or i32 %x, 4095 ; cst = 0xFFF
  ret i32 %res
}

; CHECK-LABEL: or_a_zi12_over:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $m1, 4096
; CHECK-NEXT:  or $m0, $m0, $m1
; CHECK:       br $m10
define i32 @or_a_zi12_over(i32 %x) {
  %res = or i32 %x, 4096 ; cst = 0x1000
  ret i32 %res
}

; CHECK-LABEL: or_a_iz12:
; CHECK:       # %bb
; CHECK-NEXT:  or $m0, $m0, 4293918720
; CHECK:       br $m10
define i32 @or_a_iz12(i32 %x) {
  %res = or i32 %x, 4293918720 ; cst = 0xFFF00000
  ret i32 %res
}

; CHECK-LABEL: or_a_iz12_over:
; CHECK:       # %bb
; CHECK-NEXT:  setzi [[SETREG:\$m[1-6]]], 524288
; CHECK-NEXT:  or $m1, [[SETREG]], 4293918720
; CHECK-NEXT:  or $m0, $m0, $m1
; CHECK:       br $m10
define i32 @or_a_iz12_over(i32 %x) {
  %res = or i32 %x, 4294443008 ; cst = 0xFFF80000
  ret i32 %res
}

; CHECK-LABEL: andc_a_zi12:
; CHECK:       # %bb
; CHECK-NEXT:  andc $m0, $m0, 4095
; CHECK:       br $m10
define i32 @andc_a_zi12(i32 %x) {
  %res = call i32 @ANDC(i32 %x, i32 4095) ; cst = 0xFFF
  ret i32 %res
}

; CHECK-LABEL: andc_a_zi12_over:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $m1, 4096
; CHECK-NEXT:  andc $m0, $m0, $m1
; CHECK:       br $m10
define i32 @andc_a_zi12_over(i32 %x) {
  %res = call i32 @ANDC(i32 %x, i32 4096) ; cst = 0x1000
  ret i32 %res
}
