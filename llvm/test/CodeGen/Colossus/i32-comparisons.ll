; RUN: llc < %s -march=colossus -colossus-coissue=false -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -march=colossus -colossus-coissue=false -mattr=+ipu2 | FileCheck %s

target triple = "colossus-graphcore--elf"

; CHECK-LABEL: icmp_eq_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  cmpeq $m0, $m0, $m1
; CHECK:       br $m10
define i1 @icmp_eq_i32(i32 %lhs, i32 %rhs) {
  %retval = icmp eq i32 %lhs, %rhs
  ret i1 %retval
}

; CHECK-LABEL: icmp_ne_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  cmpne $m0, $m0, $m1
; CHECK:       br $m10
define i1 @icmp_ne_i32(i32 %lhs, i32 %rhs) {
  %retval = icmp ne i32 %lhs, %rhs
  ret i1 %retval
}

; CHECK-LABEL: icmp_ugt_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  cmpult $m0, $m1, $m0
; CHECK:       br $m10
define i1 @icmp_ugt_i32(i32 %lhs, i32 %rhs) {
  %retval = icmp ugt i32 %lhs, %rhs
  ret i1 %retval
}

; CHECK-LABEL: icmp_uge_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  cmpult [[TMP:\$m[0-9]+]], $m0, $m1{{[[:space:]]+}}cmpeq $m0, [[TMP]], 0
; CHECK:       br $m10
define i1 @icmp_uge_i32(i32 %lhs, i32 %rhs) {
  %retval = icmp uge i32 %lhs, %rhs
  ret i1 %retval
}

; CHECK-LABEL: icmp_ult_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  cmpult $m0, $m0, $m1
; CHECK:       br $m10
define i1 @icmp_ult_i32(i32 %lhs, i32 %rhs) {
  %retval = icmp ult i32 %lhs, %rhs
  ret i1 %retval
}

; CHECK-LABEL: icmp_ule_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  cmpult [[TMP:\$m[0-9]+]], $m1, $m0{{[[:space:]]+}}cmpeq $m0, [[TMP]], 0
; CHECK:       br $m10
define i1 @icmp_ule_i32(i32 %lhs, i32 %rhs) {
  %retval = icmp ule i32 %lhs, %rhs
  ret i1 %retval
}

; CHECK-LABEL: icmp_sgt_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  cmpslt $m0, $m1, $m0
; CHECK:       br $m10
define i1 @icmp_sgt_i32(i32 %lhs, i32 %rhs) {
  %retval = icmp sgt i32 %lhs, %rhs
  ret i1 %retval
}

; CHECK-LABEL: icmp_sge_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  cmpslt [[TMP:\$m[0-9]+]], $m0, $m1{{[[:space:]]+}}cmpeq $m0, [[TMP]], 0
; CHECK:       br $m10
define i1 @icmp_sge_i32(i32 %lhs, i32 %rhs) {
  %retval = icmp sge i32 %lhs, %rhs
  ret i1 %retval
}

; CHECK-LABEL: icmp_slt_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  cmpslt $m0, $m0, $m1
; CHECK:       br $m10
define i1 @icmp_slt_i32(i32 %lhs, i32 %rhs) {
  %retval = icmp slt i32 %lhs, %rhs
  ret i1 %retval
}

; CHECK-LABEL: icmp_sle_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  cmpslt [[TMP:\$m[0-9]+]], $m1, $m0{{[[:space:]]+}}cmpeq $m0, [[TMP]], 0
; CHECK:       br $m10
define i1 @icmp_sle_i32(i32 %lhs, i32 %rhs) {
  %retval = icmp sle i32 %lhs, %rhs
  ret i1 %retval
}
