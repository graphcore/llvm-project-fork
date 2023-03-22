; RUN: llc < %s -march=colossus -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -march=colossus -mattr=+ipu2 | FileCheck %s

; CHECK-LABEL: select_reg
; CHECK:       movnz $m2, $m0, $m1
; CHECK:       br $m10
define i32 @select_reg(i1 %cond, i32 %t, i32 %f) {
  %1 = select i1 %cond, i32 %t, i32 %f
  ret i32 %1
}

; CHECK-LABEL: select_seteq
; CHECK:       cmpeq $m0, $m0, $m1
; CHECK-NEXT:  movnz $m3, $m0, $m2
; CHECK:       br $m10
define i32 @select_seteq(i32 %lhs, i32 %rhs, i32 %t, i32 %f) {
  %1 = icmp eq i32 %lhs, %rhs
  %2 = select i1 %1, i32 %t, i32 %f
  ret i32 %2
}

; CHECK-LABEL: select_setne
; CHECK:       cmpne $m0, $m0, $m1
; CHECK-NEXT:  movnz $m3, $m0, $m2
; CHECK:       br $m10
define i32 @select_setne(i32 %lhs, i32 %rhs, i32 %t, i32 %f) {
  %1 = icmp ne i32 %lhs, %rhs
  %2 = select i1 %1, i32 %t, i32 %f
  ret i32 %2
}

; CHECK-LABEL: select_setlt
; CHECK:       cmpslt $m0, $m0, $m1
; CHECK-NEXT:  movnz $m3, $m0, $m2
; CHECK:       br $m10
define i32 @select_setlt(i32 %lhs, i32 %rhs, i32 %t, i32 %f) {
  %1 = icmp slt i32 %lhs, %rhs
  %2 = select i1 %1, i32 %t, i32 %f
  ret i32 %2
}

; CHECK-LABEL: select_setult
; CHECK:       cmpult $m0, $m0, $m1
; CHECK-NEXT:  movnz $m3, $m0, $m2
; CHECK:       br $m10
define i32 @select_setult(i32 %lhs, i32 %rhs, i32 %t, i32 %f) {
  %1 = icmp ult i32 %lhs, %rhs
  %2 = select i1 %1, i32 %t, i32 %f
  ret i32 %2
}

; Note: cmpsgt and cmpugt canonicalised into cmpslt and cmpult respectively
; with swapped lhs and rhs.
