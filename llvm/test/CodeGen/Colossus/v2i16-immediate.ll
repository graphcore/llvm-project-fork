; RUN: llvm-link %isdopc %s | opt -instcombine -always-inline -mattr=+ipu1 | llc -march=colossus -colossus-coissue=false -mattr=+ipu1 | FileCheck %s
; RUN: llvm-link %isdopc %s | opt -instcombine -always-inline -mattr=+ipu2 | llc -march=colossus -colossus-coissue=false -mattr=+ipu2 | FileCheck %s
target triple = "colossus-graphcore--elf"

@ISD_AND = external constant i32
@ISD_OR = external constant i32
@ColossusISD_ANDC = external constant i32

declare <2 x i16> @llvm.colossus.SDAG.binary.v2i16.v2i16.v2i16(i32, <2 x i16>, <2 x i16>)

define <2 x i16> @AND(<2 x i16> %x, i32 %imm) #0 {
  %y = bitcast i32 %imm to <2 x i16>
  %id = load i32, i32* @ISD_AND
  %res = call <2 x i16> @llvm.colossus.SDAG.binary.v2i16.v2i16.v2i16(i32 %id, <2 x i16> %x, <2 x i16> %y)
  ret <2 x i16> %res
}
define <2 x i16> @OR(<2 x i16> %x, i32 %imm) #0 {
  %y = bitcast i32 %imm to <2 x i16>
  %id = load i32, i32* @ISD_OR
  %res = call <2 x i16> @llvm.colossus.SDAG.binary.v2i16.v2i16.v2i16(i32 %id, <2 x i16> %x, <2 x i16> %y)
  ret <2 x i16> %res
}
define <2 x i16> @ANDC(<2 x i16> %x, i32 %imm) #0 {
  %y = bitcast i32 %imm to <2 x i16>
  %id = load i32, i32* @ColossusISD_ANDC
  %res = call <2 x i16> @llvm.colossus.SDAG.binary.v2i16.v2i16.v2i16(i32 %id, <2 x i16> %x, <2 x i16> %y)
  ret <2 x i16> %res
}
attributes #0 = {alwaysinline}

; CHECK-LABEL: and_a_zi12:
; CHECK:       # %bb
; CHECK-NEXT:  and $m0, $m0, 4095
; CHECK:       br $m10
define <2 x i16> @and_a_zi12(<2 x i16> %x) {
  %res = call <2 x i16> @AND(<2 x i16> %x, i32 4095) ; cst = 0xFFF
  ret <2 x i16> %res
}

; CHECK-LABEL: and_a_zi12_over:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $m1, 4096
; CHECK-NEXT:  and $m0, $m0, $m1
; CHECK:       br $m10
define <2 x i16> @and_a_zi12_over(<2 x i16> %x) {
  %res = call <2 x i16> @AND(<2 x i16> %x, i32 4096) ; cst = 0x1000
  ret <2 x i16> %res
}

; CHECK-LABEL: or_a_zi12:
; CHECK:       # %bb
; CHECK-NEXT:  or $m0, $m0, 4095
; CHECK:       br $m10
define <2 x i16> @or_a_zi12(<2 x i16> %x) {
  %res = call <2 x i16> @OR(<2 x i16> %x, i32 4095) ; cst = 0xFFF
  ret <2 x i16> %res
}

; CHECK-LABEL: or_a_zi12_over:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $m1, 4096
; CHECK-NEXT:  or $m0, $m0, $m1
; CHECK:       br $m10
define <2 x i16> @or_a_zi12_over(<2 x i16> %x) {
  %res = call <2 x i16> @OR(<2 x i16> %x, i32 4096) ; cst = 0x1000
  ret <2 x i16> %res
}

; CHECK-LABEL: or_a_iz12:
; CHECK:       # %bb
; CHECK-NEXT:  or $m0, $m0, 4293918720
; CHECK:       br $m10
define <2 x i16> @or_a_iz12(<2 x i16> %x) {
  %res = call <2 x i16> @OR(<2 x i16> %x, i32 4293918720) ; cst = 0xFFF00000
  ret <2 x i16> %res
}

; CHECK-LABEL: or_a_iz12_over:
; CHECK:       # %bb
; CHECK-NEXT:  setzi [[SETREG:\$m[1-6]]], 524288
; CHECK-NEXT:  or $m1, [[SETREG]], 4293918720
; CHECK-NEXT:  or $m0, $m0, $m1
; CHECK:       br $m10
define <2 x i16> @or_a_iz12_over(<2 x i16> %x) {
  %res = call <2 x i16> @OR(<2 x i16> %x, i32 4294443008) ; cst = 0xFFF80000
  ret <2 x i16> %res
}

; CHECK-LABEL: andc_a_zi12:
; CHECK:       # %bb
; CHECK-NEXT:  andc $m0, $m0, 4095
; CHECK:       br $m10
define <2 x i16> @andc_a_zi12(<2 x i16> %x) {
  %res = call <2 x i16> @ANDC(<2 x i16> %x, i32 4095) ; cst = 0xFFF
  ret <2 x i16> %res
}

; CHECK-LABEL: andc_a_zi12_over:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $m1, 4096
; CHECK-NEXT:  andc $m0, $m0, $m1
; CHECK:       br $m10
define <2 x i16> @andc_a_zi12_over(<2 x i16> %x) {
  %res = call <2 x i16> @ANDC(<2 x i16> %x, i32 4096) ; cst = 0x1000
  ret <2 x i16> %res
}
