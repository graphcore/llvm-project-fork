; RUN: llc < %s -march=colossus -colossus-coissue=false -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -march=colossus -colossus-coissue=false -mattr=+ipu2 | FileCheck %s

target triple = "colossus-graphcore--elf"

; CHECK-LABEL: icmp_eq_i16:
; CHECK:       # %bb.0:
; CHECK-DAG:   sort4x16lo $m1, $m1, $m15
; CHECK-DAG:   sort4x16lo $m0, $m0, $m15
; CHECK-NEXT:  cmpeq $m0, $m0, $m1
; CHECK:       br $m10
define i1 @icmp_eq_i16(i16 %lhs, i16 %rhs) {
  %retval = icmp eq i16 %lhs, %rhs
  ret i1 %retval
}

; CHECK-LABEL: icmp_ne_i16:
; CHECK:       # %bb.0:
; CHECK-DAG:   sort4x16lo $m1, $m1, $m15
; CHECK-DAG:   sort4x16lo $m0, $m0, $m15
; CHECK-NEXT:  cmpne $m0, $m0, $m1
; CHECK:       br $m10
define i1 @icmp_ne_i16(i16 %lhs, i16 %rhs) {
  %retval = icmp ne i16 %lhs, %rhs
  ret i1 %retval
}

; CHECK-LABEL: icmp_ugt_i16:
; CHECK:       # %bb.0:
; CHECK-DAG:   sort4x16lo $m1, $m1, $m15
; CHECK-DAG:   sort4x16lo $m0, $m0, $m15
; CHECK-NEXT:  cmpult $m0, $m1, $m0
; CHECK:       br $m10
define i1 @icmp_ugt_i16(i16 %lhs, i16 %rhs) {
  %retval = icmp ugt i16 %lhs, %rhs
  ret i1 %retval
}

; CHECK-LABEL: icmp_uge_i16:
; CHECK:       # %bb.0:
; CHECK-DAG:   sort4x16lo $m1, $m1, $m15
; CHECK-DAG:   sort4x16lo $m0, $m0, $m15
; CHECK-NEXT:  cmpult [[TMP:\$m[0-9]+]], $m0, $m1{{[[:space:]]+}}cmpeq $m0, [[TMP]], 0
; CHECK:       br $m10
define i1 @icmp_uge_i16(i16 %lhs, i16 %rhs) {
  %retval = icmp uge i16 %lhs, %rhs
  ret i1 %retval
}

; CHECK-LABEL: icmp_ult_i16:
; CHECK:       # %bb.0:
; CHECK-DAG:   sort4x16lo $m1, $m1, $m15
; CHECK-DAG:   sort4x16lo $m0, $m0, $m15
; CHECK-NEXT:  cmpult $m0, $m0, $m1
; CHECK:       br $m10
define i1 @icmp_ult_i16(i16 %lhs, i16 %rhs) {
  %retval = icmp ult i16 %lhs, %rhs
  ret i1 %retval
}

; CHECK-LABEL: icmp_ule_i16:
; CHECK:       # %bb.0:
; CHECK-DAG:   sort4x16lo $m1, $m1, $m15
; CHECK-DAG:   sort4x16lo $m0, $m0, $m15
; CHECK-NEXT:  cmpult [[TMP:\$m[0-9]+]], $m1, $m0{{[[:space:]]+}}cmpeq $m0, [[TMP]], 0
; CHECK:       br $m10
define i1 @icmp_ule_i16(i16 %lhs, i16 %rhs) {
  %retval = icmp ule i16 %lhs, %rhs
  ret i1 %retval
}

; CHECK-LABEL: icmp_sgt_i16:
; CHECK:       # %bb.0:
; CHECK-DAG:   shl $m0, $m0, 16{{[[:space:]]+}}shrs $m0, $m0, 16
; CHECK-DAG:   shl $m1, $m1, 16{{[[:space:]]+}}shrs $m1, $m1, 16
; CHECK-NEXT:  cmpslt $m0, $m1, $m0
; CHECK:       br $m10
define i1 @icmp_sgt_i16(i16 %lhs, i16 %rhs) {
  %retval = icmp sgt i16 %lhs, %rhs
  ret i1 %retval
}

; CHECK-LABEL: icmp_sge_i16:
; CHECK:       # %bb.0:
; CHECK-DAG:   shl $m0, $m0, 16{{[[:space:]]+}}shrs $m0, $m0, 16
; CHECK-DAG:   shl $m1, $m1, 16{{[[:space:]]+}}shrs $m1, $m1, 16
; CHECK-NEXT:  cmpslt [[TMP:\$m[0-9]+]], $m0, $m1{{[[:space:]]+}}cmpeq $m0, [[TMP]], 0
; CHECK:       br $m10
define i1 @icmp_sge_i16(i16 %lhs, i16 %rhs) {
  %retval = icmp sge i16 %lhs, %rhs
  ret i1 %retval
}

; CHECK-LABEL: icmp_slt_i16:
; CHECK:       # %bb.0:
; CHECK-DAG:   shl $m0, $m0, 16{{[[:space:]]+}}shrs $m0, $m0, 16
; CHECK-DAG:   shl $m1, $m1, 16{{[[:space:]]+}}shrs $m1, $m1, 16
; CHECK-NEXT:  cmpslt $m0, $m0, $m1
; CHECK:       br $m10
define i1 @icmp_slt_i16(i16 %lhs, i16 %rhs) {
  %retval = icmp slt i16 %lhs, %rhs
  ret i1 %retval
}

; CHECK-LABEL: icmp_sle_i16:
; CHECK:       # %bb.0:
; CHECK-DAG:   shl $m0, $m0, 16{{[[:space:]]+}}shrs $m0, $m0, 16
; CHECK-DAG:   shl $m1, $m1, 16{{[[:space:]]+}}shrs $m1, $m1, 16
; CHECK-NEXT:  cmpslt [[TMP:\$m[0-9]+]], $m1, $m0{{[[:space:]]+}}cmpeq $m0, [[TMP]], 0
; CHECK:       br $m10
define i1 @icmp_sle_i16(i16 %lhs, i16 %rhs) {
  %retval = icmp sle i16 %lhs, %rhs
  ret i1 %retval
}
