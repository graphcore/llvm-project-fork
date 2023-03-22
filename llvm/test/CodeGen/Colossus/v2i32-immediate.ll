; RUN: llvm-link %isdopc %s | opt -instcombine -always-inline -mattr=+ipu1 | llc -march=colossus -colossus-coissue=false -mattr=+ipu1 | FileCheck %s
; RUN: llvm-link %isdopc %s | opt -instcombine -always-inline -mattr=+ipu2 | llc -march=colossus -colossus-coissue=false -mattr=+ipu2 | FileCheck %s
target triple = "colossus-graphcore--elf"

@ISD_AND = external constant i32
@ISD_OR = external constant i32
@ColossusISD_ANDC = external constant i32

declare <2 x i32> @llvm.colossus.SDAG.binary.v2i32.v2i32.v2i32(i32, <2 x i32>, <2 x i32>)

define <2 x i32> @AND(<2 x i32> %x, i64 %imm) #0 {
  %y = bitcast i64 %imm to <2 x i32>
  %id = load i32, i32* @ISD_AND
  %res = call <2 x i32> @llvm.colossus.SDAG.binary.v2i32.v2i32.v2i32(i32 %id, <2 x i32> %x, <2 x i32> %y)
  ret <2 x i32> %res
}
define <2 x i32> @OR(<2 x i32> %x, i64 %imm) #0 {
  %y = bitcast i64 %imm to <2 x i32>
  %id = load i32, i32* @ISD_OR
  %res = call <2 x i32> @llvm.colossus.SDAG.binary.v2i32.v2i32.v2i32(i32 %id, <2 x i32> %x, <2 x i32> %y)
  ret <2 x i32> %res
}
define <2 x i32> @ANDC(<2 x i32> %x, i64 %imm) #0 {
  %y = bitcast i64 %imm to <2 x i32>
  %id = load i32, i32* @ColossusISD_ANDC
  %res = call <2 x i32> @llvm.colossus.SDAG.binary.v2i32.v2i32.v2i32(i32 %id, <2 x i32> %x, <2 x i32> %y)
  ret <2 x i32> %res
}
attributes #0 = {alwaysinline}

; CHECK-LABEL: and_a_zi12:
; CHECK:       # %bb
; CHECK-DAG:   and $m0, $m0, 4095
; CHECK-DAG:   and $m1, $m1, 4095
; CHECK:       br $m10
define <2 x i32> @and_a_zi12(<2 x i32> %x) {
  %res = call <2 x i32> @AND(<2 x i32> %x, i64 17587891081215) ; cst = 0xFFF00000FFF
  ret <2 x i32> %res
}

; CHECK-LABEL: and_a_zi12_over:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $m2, 4096
; CHECK-DAG:   and $m0, $m0, $m2
; CHECK-DAG:   and $m1, $m1, 4095
; CHECK:       br $m10
define <2 x i32> @and_a_zi12_over(<2 x i32> %x) {
  %res = call <2 x i32> @AND(<2 x i32> %x, i64 17587891081216) ; cst = 0xFFF00001000
  ret <2 x i32> %res
}

; CHECK-LABEL: and_a_zi12_over_2:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $m2, 4096
; CHECK-DAG:   and $m0, $m0, 4095
; CHECK-DAG:   and $m1, $m1, $m2
; CHECK:       br $m10
define <2 x i32> @and_a_zi12_over_2(<2 x i32> %x) {
  %res = call <2 x i32> @AND(<2 x i32> %x, i64 17592186048511) ; cst = 0x100000000FFF
  ret <2 x i32> %res
}

; CHECK-LABEL: and_a_zi12_over_3:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $m2, 4096
; CHECK-DAG:   and $m0, $m0, $m2
; CHECK-DAG:   and $m1, $m1, $m2
; CHECK:       br $m10
define <2 x i32> @and_a_zi12_over_3(<2 x i32> %x) {
  %res = call <2 x i32> @AND(<2 x i32> %x, i64 17592186048512) ; cst = 0x100000001000
  ret <2 x i32> %res
}

; CHECK-LABEL: or_a_zi12:
; CHECK:       # %bb
; CHECK-DAG:   or $m0, $m0, 4095
; CHECK-DAG:   or $m1, $m1, 4095
; CHECK:       br $m10
define <2 x i32> @or_a_zi12(<2 x i32> %x) {
  %res = call <2 x i32> @OR(<2 x i32> %x, i64 17587891081215) ; cst = 0xFFF00000FFF
  ret <2 x i32> %res
}

; CHECK-LABEL: or_a_zi12_over:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $m2, 4096
; CHECK-DAG:   or $m0, $m0, $m2
; CHECK-DAG:   or $m1, $m1, 4095
; CHECK:       br $m10
define <2 x i32> @or_a_zi12_over(<2 x i32> %x) {
  %res = call <2 x i32> @OR(<2 x i32> %x, i64 17587891081216) ; cst = 0xFFF00001000
  ret <2 x i32> %res
}

; CHECK-LABEL: or_a_zi12_over_2:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $m2, 4096
; CHECK-DAG:   or $m0, $m0, 4095
; CHECK-DAG:   or $m1, $m1, $m2
; CHECK:       br $m10
define <2 x i32> @or_a_zi12_over_2(<2 x i32> %x) {
  %res = call <2 x i32> @OR(<2 x i32> %x, i64 17592186048511) ; cst = 0x100000000FFF
  ret <2 x i32> %res
}

; CHECK-LABEL: or_a_zi12_over_3:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $m2, 4096
; CHECK-DAG:   or $m0, $m0, $m2
; CHECK-DAG:   or $m1, $m1, $m2
; CHECK:       br $m10
define <2 x i32> @or_a_zi12_over_3(<2 x i32> %x) {
  %res = call <2 x i32> @OR(<2 x i32> %x, i64 17592186048512) ; cst = 0x100000001000
  ret <2 x i32> %res
}

; CHECK-LABEL: or_a_iz12:
; CHECK:       # %bb
; CHECK-DAG:   or $m0, $m0, 4293918720
; CHECK-DAG:   or $m1, $m1, 4293918720
; CHECK:       br $m10
define <2 x i32> @or_a_iz12(<2 x i32> %x) {
  %res = call <2 x i32> @OR(<2 x i32> %x, i64 18442240478376099840) ; cst = 0xFFF00000FFF00000
  ret <2 x i32> %res
}

; CHECK-LABEL: or_a_iz12_over:
; CHECK:       # %bb
; CHECK-NEXT:  setzi [[SETREG:\$m[2-6]]], 524288
; CHECK-NEXT:  or $m2, [[SETREG]], 4293918720
; CHECK-DAG:   or $m0, $m0, $m2
; CHECK-DAG:   or $m1, $m1, 4293918720
; CHECK:       br $m10
define <2 x i32> @or_a_iz12_over(<2 x i32> %x) {
  %res = call <2 x i32> @OR(<2 x i32> %x, i64 18442240478376624128) ; cst = 0xFFF00000FFF80000
  ret <2 x i32> %res
}

; CHECK-LABEL: or_a_iz12_over_2:
; CHECK:       # %bb
; CHECK-NEXT:  setzi [[SETREG:\$m[2-6]]], 524288
; CHECK-NEXT:  or $m2, [[SETREG]], 4293918720
; CHECK-DAG:   or $m0, $m0, 4293918720
; CHECK-DAG:   or $m1, $m1, $m2
; CHECK:       br $m10
define <2 x i32> @or_a_iz12_over_2(<2 x i32> %x) {
  %res = call <2 x i32> @OR(<2 x i32> %x, i64 18444492278189785088) ; cst = 0xFFF80000FFF00000
  ret <2 x i32> %res
}

; CHECK-LABEL: or_a_iz12_over_3:
; CHECK:       # %bb
; CHECK-NEXT:  setzi [[SETREG:\$m[2-6]]], 524288
; CHECK-NEXT:  or $m2, [[SETREG]], 4293918720
; CHECK-DAG:   or $m0, $m0, $m2
; CHECK-DAG:   or $m1, $m1, $m2
; CHECK:       br $m10
define <2 x i32> @or_a_iz12_over_3(<2 x i32> %x) {
  %res = call <2 x i32> @OR(<2 x i32> %x, i64 18444492278190309376) ; cst = 0xFFF80000FFF80000
  ret <2 x i32> %res
}

; CHECK-LABEL: andc_a_zi12:
; CHECK:       # %bb
; CHECK-DAG:   andc $m0, $m0, 4095
; CHECK-DAG:   andc $m1, $m1, 4095
; CHECK:       br $m10
define <2 x i32> @andc_a_zi12(<2 x i32> %x) {
  %res = call <2 x i32> @ANDC(<2 x i32> %x, i64 17587891081215) ; cst = 0xFFF00000FFF
  ret <2 x i32> %res
}

; CHECK-LABEL: andc_a_zi12_over:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $m2, 4096
; CHECK-DAG:   andc $m0, $m0, $m2
; CHECK-DAG:   andc $m1, $m1, 4095
; CHECK:       br $m10
define <2 x i32> @andc_a_zi12_over(<2 x i32> %x) {
  %res = call <2 x i32> @ANDC(<2 x i32> %x, i64 17587891081216) ; cst = 0xFFF00001000
  ret <2 x i32> %res
}

; CHECK-LABEL: andc_a_zi12_over_2:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $m2, 4096
; CHECK-DAG:   andc $m0, $m0, 4095
; CHECK-DAG:   andc $m1, $m1, $m2
; CHECK:       br $m10
define <2 x i32> @andc_a_zi12_over_2(<2 x i32> %x) {
  %res = call <2 x i32> @ANDC(<2 x i32> %x, i64 17592186048511) ; cst = 0x100000000FFF
  ret <2 x i32> %res
}

; CHECK-LABEL: andc_a_zi12_over_3:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $m2, 4096
; CHECK-DAG:   andc $m0, $m0, $m2
; CHECK-DAG:   andc $m1, $m1, $m2
; CHECK:       br $m10
define <2 x i32> @andc_a_zi12_over_3(<2 x i32> %x) {
  %res = call <2 x i32> @ANDC(<2 x i32> %x, i64 17592186048512) ; cst = 0x100000001000
  ret <2 x i32> %res
}
