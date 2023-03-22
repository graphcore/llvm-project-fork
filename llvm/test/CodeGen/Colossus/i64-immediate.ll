; RUN: llvm-link %isdopc %s | opt -instcombine -always-inline -mattr=+ipu1 | llc -march=colossus -colossus-coissue=false -mattr=+ipu1 | FileCheck %s
; RUN: llvm-link %isdopc %s | opt -instcombine -always-inline -mattr=+ipu2 | llc -march=colossus -colossus-coissue=false -mattr=+ipu2 | FileCheck %s
target triple = "colossus-graphcore--elf"

; CHECK-LABEL: and_a_zi12:
; CHECK:       # %bb
; CHECK-DAG:   and $m0, $m0, 4095
; CHECK-DAG:   and $m1, $m1, 4095
; CHECK:       br $m10
define i64 @and_a_zi12(i64 %x) {
  %res = and i64 %x, 17587891081215 ; cst = 0xFFF00000FFF
  ret i64 %res
}

; CHECK-LABEL: and_a_zi12_over:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $m2, 4096
; CHECK-DAG:   and $m0, $m0, $m2
; CHECK-DAG:   and $m1, $m1, 4095
; CHECK:       br $m10
define i64 @and_a_zi12_over(i64 %x) {
  %res = and i64 %x, 17587891081216 ; cst = 0xFFF00001000
  ret i64 %res
}

; CHECK-LABEL: and_a_zi12_over_2:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $m2, 4096
; CHECK-DAG:   and $m0, $m0, 4095
; CHECK-DAG:   and $m1, $m1, $m2
; CHECK:       br $m10
define i64 @and_a_zi12_over_2(i64 %x) {
  %res = and i64 %x, 17592186048511 ; cst = 0x100000000FFF
  ret i64 %res
}

; CHECK-LABEL: and_a_zi12_over_3:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $m2, 4096
; CHECK-DAG:   and $m0, $m0, $m2
; CHECK-DAG:   and $m1, $m1, $m2
; CHECK:       br $m10
define i64 @and_a_zi12_over_3(i64 %x) {
  %res = and i64 %x, 17592186048512 ; cst = 0x100000001000
  ret i64 %res
}

; CHECK-LABEL: or_a_zi12:
; CHECK:       # %bb
; CHECK-DAG:   or $m0, $m0, 4095
; CHECK-DAG:   or $m1, $m1, 4095
; CHECK:       br $m10
define i64 @or_a_zi12(i64 %x) {
  %res = or i64 %x, 17587891081215 ; cst = 0xFFF00000FFF
  ret i64 %res
}

; CHECK-LABEL: or_a_zi12_over:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $m2, 4096
; CHECK-DAG:   or $m0, $m0, $m2
; CHECK-DAG:   or $m1, $m1, 4095
; CHECK:       br $m10
define i64 @or_a_zi12_over(i64 %x) {
  %res = or i64 %x, 17587891081216 ; cst = 0xFFF00001000
  ret i64 %res
}

; CHECK-LABEL: or_a_zi12_over_2:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $m2, 4096
; CHECK-DAG:   or $m0, $m0, 4095
; CHECK-DAG:   or $m1, $m1, $m2
; CHECK:       br $m10
define i64 @or_a_zi12_over_2(i64 %x) {
  %res = or i64 %x, 17592186048511 ; cst = 0x100000000FFF
  ret i64 %res
}

; CHECK-LABEL: or_a_zi12_over_3:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $m2, 4096
; CHECK-DAG:   or $m0, $m0, $m2
; CHECK-DAG:   or $m1, $m1, $m2
; CHECK:       br $m10
define i64 @or_a_zi12_over_3(i64 %x) {
  %res = or i64 %x, 17592186048512 ; cst = 0x100000001000
  ret i64 %res
}

; CHECK-LABEL: or_a_iz12:
; CHECK:       # %bb
; CHECK-DAG:   or $m0, $m0, 4293918720
; CHECK-DAG:   or $m1, $m1, 4293918720
; CHECK:       br $m10
define i64 @or_a_iz12(i64 %x) {
  %res = or i64 %x, 18442240478376099840 ; cst = 0xFFF00000FFF00000
  ret i64 %res
}

; CHECK-LABEL: or_a_iz12_over:
; CHECK:       # %bb
; CHECK-NEXT:  setzi [[SETREG:\$m[2-6]]], 524288
; CHECK-NEXT:  or $m2, [[SETREG]], 4293918720
; CHECK-DAG:   or $m0, $m0, $m2
; CHECK-DAG:   or $m1, $m1, 4293918720
; CHECK:       br $m10
define i64 @or_a_iz12_over(i64 %x) {
  %res = or i64 %x, 18442240478376624128 ; cst = 0xFFF00000FFF80000
  ret i64 %res
}

; CHECK-LABEL: or_a_iz12_over_2:
; CHECK:       # %bb
; CHECK-NEXT:  setzi [[SETREG:\$m[2-6]]], 524288
; CHECK-NEXT:  or $m2, [[SETREG]], 4293918720
; CHECK-DAG:   or $m0, $m0, 4293918720
; CHECK-DAG:   or $m1, $m1, $m2
; CHECK:       br $m10
define i64 @or_a_iz12_over_2(i64 %x) {
  %res = or i64 %x, 18444492278189785088 ; cst = 0xFFF80000FFF00000
  ret i64 %res
}

; CHECK-LABEL: or_a_iz12_over_3:
; CHECK:       # %bb
; CHECK-NEXT:  setzi [[SETREG:\$m[2-6]]], 524288
; CHECK-NEXT:  or $m2, [[SETREG]], 4293918720
; CHECK-DAG:   or $m0, $m0, $m2
; CHECK-DAG:   or $m1, $m1, $m2
; CHECK:       br $m10
define i64 @or_a_iz12_over_3(i64 %x) {
  %res = or i64 %x, 18444492278190309376 ; cst = 0xFFF80000FFF80000
  ret i64 %res
}
