; RUN: llc < %s -march=colossus -colossus-coissue=false -enable-no-nans-fp-math -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -march=colossus -colossus-coissue=false -enable-no-nans-fp-math -mattr=+ipu2 | FileCheck %s
target triple = "colossus-graphcore--elf"

declare <4 x i1> @llvm.experimental.constrained.fcmps.v4f16(<4 x half>, <4 x half>, metadata, metadata)

; CHECK-LABEL: fcmp_no_nans_false_v4f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m15
; CHECK-NEXT:  mov $m1, $m15
; CHECK:       br $m10
define <4 x i1> @fcmp_no_nans_false_v4f16(<4 x half> %lhs, <4 x half> %rhs) {
  %retval = fcmp false <4 x half> %lhs, %rhs
  ret <4 x i1> %retval
}

; CHECK-LABEL: fcmp_no_nans_oeq_v4f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f16v4cmpeq $a0:1, $a0:1, $a2:3
; CHECK-DAG:   mov [[REGLO:\$m[0-9]+]], $a0
; CHECK-DAG:   mov [[REGHI:\$m[0-9]+]], $a1
; CHECK:       br $m10
define <4 x i1> @fcmp_no_nans_oeq_v4f16(<4 x half> %lhs, <4 x half> %rhs) {
  %retval = fcmp oeq <4 x half> %lhs, %rhs
  ret <4 x i1> %retval
}

; CHECK-LABEL: constrained_fcmps_no_nans_oeq_v4f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f16v4cmpeq $a0:1, $a0:1, $a2:3
; CHECK-DAG:   mov [[REGLO:\$m[0-9]+]], $a0
; CHECK-DAG:   mov [[REGHI:\$m[0-9]+]], $a1
; CHECK:       br $m10
define <4 x i1> @constrained_fcmps_no_nans_oeq_v4f16(<4 x half> %lhs, <4 x half> %rhs) {
  %retval = tail call <4 x i1> @llvm.experimental.constrained.fcmps.v4f16(<4 x half> %lhs, <4 x half> %rhs, metadata !"oeq", metadata !"fpexcept.strict")
  ret <4 x i1> %retval
}

; CHECK-LABEL: fcmp_no_nans_ogt_v4f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f16v4cmpgt $a0:1, $a0:1, $a2:3
; CHECK-DAG:   mov [[REGLO:\$m[0-9]+]], $a0
; CHECK-DAG:   mov [[REGHI:\$m[0-9]+]], $a1
; CHECK:       br $m10
define <4 x i1> @fcmp_no_nans_ogt_v4f16(<4 x half> %lhs, <4 x half> %rhs) {
  %retval = fcmp ogt <4 x half> %lhs, %rhs
  ret <4 x i1> %retval
}

; CHECK-LABEL: constrained_fcmps_no_nans_ogt_v4f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f16v4cmpgt $a0:1, $a0:1, $a2:3
; CHECK-DAG:   mov [[REGLO:\$m[0-9]+]], $a0
; CHECK-DAG:   mov [[REGHI:\$m[0-9]+]], $a1
; CHECK:       br $m10
define <4 x i1> @constrained_fcmps_no_nans_ogt_v4f16(<4 x half> %lhs, <4 x half> %rhs) {
  %retval = tail call <4 x i1> @llvm.experimental.constrained.fcmps.v4f16(<4 x half> %lhs, <4 x half> %rhs, metadata !"ogt", metadata !"fpexcept.strict")
  ret <4 x i1> %retval
}

; CHECK-LABEL: fcmp_no_nans_oge_v4f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f16v4cmpge $a0:1, $a0:1, $a2:3
; CHECK-DAG:   mov [[REGLO:\$m[0-9]+]], $a0
; CHECK-DAG:   mov [[REGHI:\$m[0-9]+]], $a1
; CHECK:       br $m10
define <4 x i1> @fcmp_no_nans_oge_v4f16(<4 x half> %lhs, <4 x half> %rhs) {
  %retval = fcmp oge <4 x half> %lhs, %rhs
  ret <4 x i1> %retval
}

; CHECK-LABEL: constrained_fcmps_no_nans_oge_v4f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f16v4cmpge $a0:1, $a0:1, $a2:3
; CHECK-DAG:   mov [[REGLO:\$m[0-9]+]], $a0
; CHECK-DAG:   mov [[REGHI:\$m[0-9]+]], $a1
; CHECK:       br $m10
define <4 x i1> @constrained_fcmps_no_nans_oge_v4f16(<4 x half> %lhs, <4 x half> %rhs) {
  %retval = tail call <4 x i1> @llvm.experimental.constrained.fcmps.v4f16(<4 x half> %lhs, <4 x half> %rhs, metadata !"oge", metadata !"fpexcept.strict")
  ret <4 x i1> %retval
}

; CHECK-LABEL: fcmp_no_nans_olt_v4f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f16v4cmplt $a0:1, $a0:1, $a2:3
; CHECK-DAG:   mov [[REGLO:\$m[0-9]+]], $a0
; CHECK-DAG:   mov [[REGHI:\$m[0-9]+]], $a1
; CHECK:       br $m10
define <4 x i1> @fcmp_no_nans_olt_v4f16(<4 x half> %lhs, <4 x half> %rhs) {
  %retval = fcmp olt <4 x half> %lhs, %rhs
  ret <4 x i1> %retval
}

; CHECK-LABEL: constrained_fcmps_no_nans_olt_v4f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f16v4cmplt $a0:1, $a0:1, $a2:3
; CHECK-DAG:   mov [[REGLO:\$m[0-9]+]], $a0
; CHECK-DAG:   mov [[REGHI:\$m[0-9]+]], $a1
; CHECK:       br $m10
define <4 x i1> @constrained_fcmps_no_nans_olt_v4f16(<4 x half> %lhs, <4 x half> %rhs) {
  %retval = tail call <4 x i1> @llvm.experimental.constrained.fcmps.v4f16(<4 x half> %lhs, <4 x half> %rhs, metadata !"olt", metadata !"fpexcept.strict")
  ret <4 x i1> %retval
}

; CHECK-LABEL: fcmp_no_nans_ole_v4f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f16v4cmple $a0:1, $a0:1, $a2:3
; CHECK-DAG:   mov [[REGLO:\$m[0-9]+]], $a0
; CHECK-DAG:   mov [[REGHI:\$m[0-9]+]], $a1
; CHECK:       br $m10
define <4 x i1> @fcmp_no_nans_ole_v4f16(<4 x half> %lhs, <4 x half> %rhs) {
  %retval = fcmp ole <4 x half> %lhs, %rhs
  ret <4 x i1> %retval
}

; CHECK-LABEL: constrained_fcmps_no_nans_ole_v4f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f16v4cmple $a0:1, $a0:1, $a2:3
; CHECK-DAG:   mov [[REGLO:\$m[0-9]+]], $a0
; CHECK-DAG:   mov [[REGHI:\$m[0-9]+]], $a1
; CHECK:       br $m10
define <4 x i1> @constrained_fcmps_no_nans_ole_v4f16(<4 x half> %lhs, <4 x half> %rhs) {
  %retval = tail call <4 x i1> @llvm.experimental.constrained.fcmps.v4f16(<4 x half> %lhs, <4 x half> %rhs, metadata !"ole", metadata !"fpexcept.strict")
  ret <4 x i1> %retval
}

; CHECK-LABEL: fcmp_no_nans_one_v4f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f16v4cmpne $a0:1, $a0:1, $a2:3
; CHECK-DAG:   mov [[REGLO:\$m[0-9]+]], $a0
; CHECK-DAG:   mov [[REGHI:\$m[0-9]+]], $a1
; CHECK:       br $m10
define <4 x i1> @fcmp_no_nans_one_v4f16(<4 x half> %lhs, <4 x half> %rhs) {
  %retval = fcmp one <4 x half> %lhs, %rhs
  ret <4 x i1> %retval
}

; CHECK-LABEL: constrained_fcmps_no_nans_one_v4f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f16v4cmpne $a0:1, $a0:1, $a2:3
; CHECK-DAG:   mov [[REGLO:\$m[0-9]+]], $a0
; CHECK-DAG:   mov [[REGHI:\$m[0-9]+]], $a1
; CHECK:       br $m10
define <4 x i1> @constrained_fcmps_no_nans_one_v4f16(<4 x half> %lhs, <4 x half> %rhs) {
  %retval = tail call <4 x i1> @llvm.experimental.constrained.fcmps.v4f16(<4 x half> %lhs, <4 x half> %rhs, metadata !"one", metadata !"fpexcept.strict")
  ret <4 x i1> %retval
}

; CHECK-LABEL: fcmp_no_nans_ord_v4f16:
; CHECK:       # %bb.0:
; CHECK-DAG:   f16v4cmpeq $a0:1, $a0:1, $a0:1
; CHECK-DAG:   f16v4cmpeq $a2:3, $a2:3, $a2:3
; CHECK-NEXT:  and64 $a0:1, $a0:1, $a2:3
; CHECK-DAG:   mov [[TMPLO:\$m[0-9]+]], $a0
; CHECK-DAG:   mov [[TMPHI:\$m[0-9]+]], $a1
; CHECK:       br $m10
define <4 x i1> @fcmp_no_nans_ord_v4f16(<4 x half> %lhs, <4 x half> %rhs) {
  %retval = fcmp ord <4 x half> %lhs, %rhs
  ret <4 x i1> %retval
}

; CHECK-LABEL: constrained_fcmps_no_nans_ord_v4f16:
; CHECK:       # %bb.0:
; CHECK-DAG:   f16v4cmpeq $a0:1, $a0:1, $a0:1
; CHECK-DAG:   f16v4cmpeq $a2:3, $a2:3, $a2:3
; CHECK-NEXT:  and64 $a0:1, $a0:1, $a2:3
; CHECK-DAG:   mov [[TMPLO:\$m[0-9]+]], $a0
; CHECK-DAG:   mov [[TMPHI:\$m[0-9]+]], $a1
; CHECK:       br $m10
define <4 x i1> @constrained_fcmps_no_nans_ord_v4f16(<4 x half> %lhs, <4 x half> %rhs) {
  %retval = tail call <4 x i1> @llvm.experimental.constrained.fcmps.v4f16(<4 x half> %lhs, <4 x half> %rhs, metadata !"ord", metadata !"fpexcept.strict")
  ret <4 x i1> %retval
}

; CHECK-LABEL: fcmp_no_nans_ueq_v4f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f16v4cmpeq $a0:1, $a0:1, $a2:3
; CHECK-DAG:   mov [[REGLO:\$m[0-9]+]], $a0
; CHECK-DAG:   mov [[REGHI:\$m[0-9]+]], $a1
; CHECK:       br $m10
define <4 x i1> @fcmp_no_nans_ueq_v4f16(<4 x half> %lhs, <4 x half> %rhs) {
  %retval = fcmp ueq <4 x half> %lhs, %rhs
  ret <4 x i1> %retval
}

; CHECK-LABEL: constrained_fcmps_no_nans_ueq_v4f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f16v4cmpeq $a0:1, $a0:1, $a2:3
; CHECK-DAG:   mov [[REGLO:\$m[0-9]+]], $a0
; CHECK-DAG:   mov [[REGHI:\$m[0-9]+]], $a1
; CHECK:       br $m10
define <4 x i1> @constrained_fcmps_no_nans_ueq_v4f16(<4 x half> %lhs, <4 x half> %rhs) {
  %retval = tail call <4 x i1> @llvm.experimental.constrained.fcmps.v4f16(<4 x half> %lhs, <4 x half> %rhs, metadata !"ueq", metadata !"fpexcept.strict")
  ret <4 x i1> %retval
}

; CHECK-LABEL: fcmp_no_nans_ugt_v4f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f16v4cmpgt $a0:1, $a0:1, $a2:3
; CHECK-DAG:   mov [[REGLO:\$m[0-9]+]], $a0
; CHECK-DAG:   mov [[REGHI:\$m[0-9]+]], $a1
; CHECK:       br $m10
define <4 x i1> @fcmp_no_nans_ugt_v4f16(<4 x half> %lhs, <4 x half> %rhs) {
  %retval = fcmp ugt <4 x half> %lhs, %rhs
  ret <4 x i1> %retval
}

; CHECK-LABEL: constrained_fcmps_no_nans_ugt_v4f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f16v4cmpgt $a0:1, $a0:1, $a2:3
; CHECK-DAG:   mov [[REGLO:\$m[0-9]+]], $a0
; CHECK-DAG:   mov [[REGHI:\$m[0-9]+]], $a1
; CHECK:       br $m10
define <4 x i1> @constrained_fcmps_no_nans_ugt_v4f16(<4 x half> %lhs, <4 x half> %rhs) {
  %retval = tail call <4 x i1> @llvm.experimental.constrained.fcmps.v4f16(<4 x half> %lhs, <4 x half> %rhs, metadata !"ugt", metadata !"fpexcept.strict")
  ret <4 x i1> %retval
}

; CHECK-LABEL: fcmp_no_nans_uge_v4f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f16v4cmpge $a0:1, $a0:1, $a2:3
; CHECK-DAG:   mov [[REGLO:\$m[0-9]+]], $a0
; CHECK-DAG:   mov [[REGHI:\$m[0-9]+]], $a1
; CHECK:       br $m10
define <4 x i1> @fcmp_no_nans_uge_v4f16(<4 x half> %lhs, <4 x half> %rhs) {
  %retval = fcmp uge <4 x half> %lhs, %rhs
  ret <4 x i1> %retval
}

; CHECK-LABEL: constrained_fcmps_no_nans_uge_v4f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f16v4cmpge $a0:1, $a0:1, $a2:3
; CHECK-DAG:   mov [[REGLO:\$m[0-9]+]], $a0
; CHECK-DAG:   mov [[REGHI:\$m[0-9]+]], $a1
; CHECK:       br $m10
define <4 x i1> @constrained_fcmps_no_nans_uge_v4f16(<4 x half> %lhs, <4 x half> %rhs) {
  %retval = tail call <4 x i1> @llvm.experimental.constrained.fcmps.v4f16(<4 x half> %lhs, <4 x half> %rhs, metadata !"uge", metadata !"fpexcept.strict")
  ret <4 x i1> %retval
}

; CHECK-LABEL: fcmp_no_nans_ult_v4f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f16v4cmplt $a0:1, $a0:1, $a2:3
; CHECK-DAG:   mov [[REGLO:\$m[0-9]+]], $a0
; CHECK-DAG:   mov [[REGHI:\$m[0-9]+]], $a1
; CHECK:       br $m10
define <4 x i1> @fcmp_no_nans_ult_v4f16(<4 x half> %lhs, <4 x half> %rhs) {
  %retval = fcmp ult <4 x half> %lhs, %rhs
  ret <4 x i1> %retval
}

; CHECK-LABEL: constrained_fcmps_no_nans_ult_v4f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f16v4cmplt $a0:1, $a0:1, $a2:3
; CHECK-DAG:   mov [[REGLO:\$m[0-9]+]], $a0
; CHECK-DAG:   mov [[REGHI:\$m[0-9]+]], $a1
; CHECK:       br $m10
define <4 x i1> @constrained_fcmps_no_nans_ult_v4f16(<4 x half> %lhs, <4 x half> %rhs) {
  %retval = tail call <4 x i1> @llvm.experimental.constrained.fcmps.v4f16(<4 x half> %lhs, <4 x half> %rhs, metadata !"ult", metadata !"fpexcept.strict")
  ret <4 x i1> %retval
}

; CHECK-LABEL: fcmp_no_nans_ule_v4f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f16v4cmple $a0:1, $a0:1, $a2:3
; CHECK-DAG:   mov [[REGLO:\$m[0-9]+]], $a0
; CHECK-DAG:   mov [[REGHI:\$m[0-9]+]], $a1
; CHECK:       br $m10
define <4 x i1> @fcmp_no_nans_ule_v4f16(<4 x half> %lhs, <4 x half> %rhs) {
  %retval = fcmp ule <4 x half> %lhs, %rhs
  ret <4 x i1> %retval
}

; CHECK-LABEL: constrained_fcmps_no_nans_ule_v4f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f16v4cmple $a0:1, $a0:1, $a2:3
; CHECK-DAG:   mov [[REGLO:\$m[0-9]+]], $a0
; CHECK-DAG:   mov [[REGHI:\$m[0-9]+]], $a1
; CHECK:       br $m10
define <4 x i1> @constrained_fcmps_no_nans_ule_v4f16(<4 x half> %lhs, <4 x half> %rhs) {
  %retval = tail call <4 x i1> @llvm.experimental.constrained.fcmps.v4f16(<4 x half> %lhs, <4 x half> %rhs, metadata !"ule", metadata !"fpexcept.strict")
  ret <4 x i1> %retval
}

; CHECK-LABEL: fcmp_no_nans_une_v4f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f16v4cmpne $a0:1, $a0:1, $a2:3
; CHECK-DAG:   mov [[REGLO:\$m[0-9]+]], $a0
; CHECK-DAG:   mov [[REGHI:\$m[0-9]+]], $a1
; CHECK:       br $m10
define <4 x i1> @fcmp_no_nans_une_v4f16(<4 x half> %lhs, <4 x half> %rhs) {
  %retval = fcmp une <4 x half> %lhs, %rhs
  ret <4 x i1> %retval
}

; CHECK-LABEL: constrained_fcmps_no_nans_une_v4f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f16v4cmpne $a0:1, $a0:1, $a2:3
; CHECK-DAG:   mov [[REGLO:\$m[0-9]+]], $a0
; CHECK-DAG:   mov [[REGHI:\$m[0-9]+]], $a1
; CHECK:       br $m10
define <4 x i1> @constrained_fcmps_no_nans_une_v4f16(<4 x half> %lhs, <4 x half> %rhs) {
  %retval = tail call <4 x i1> @llvm.experimental.constrained.fcmps.v4f16(<4 x half> %lhs, <4 x half> %rhs, metadata !"une", metadata !"fpexcept.strict")
  ret <4 x i1> %retval
}

; CHECK-LABEL: fcmp_no_nans_uno_v4f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:   f16v4cmpne $a2:3, $a2:3, $a2:3
; CHECK-NEXT:   f16v4cmpne $a0:1, $a0:1, $a0:1
; CHECK-NEXT:   or64 $a0:1, $a0:1, $a2:3
; CHECK-DAG:    mov [[TMPLO:\$m[0-9]+]], $a0
; CHECK-DAG:    mov [[TMPHI:\$m[0-9]+]], $a1
; CHECK:       br $m10
define <4 x i1> @fcmp_no_nans_uno_v4f16(<4 x half> %lhs, <4 x half> %rhs) {
  %retval = fcmp uno <4 x half> %lhs, %rhs
  ret <4 x i1> %retval
}

; CHECK-LABEL: constrained_fcmps_no_nans_uno_v4f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:   f16v4cmpne $a2:3, $a2:3, $a2:3
; CHECK-NEXT:   f16v4cmpne $a0:1, $a0:1, $a0:1
; CHECK-NEXT:   or64 $a0:1, $a0:1, $a2:3
; CHECK-DAG:    mov [[TMPLO:\$m[0-9]+]], $a0
; CHECK-DAG:    mov [[TMPHI:\$m[0-9]+]], $a1
; CHECK:       br $m10
define <4 x i1> @constrained_fcmps_no_nans_uno_v4f16(<4 x half> %lhs, <4 x half> %rhs) {
  %retval = tail call <4 x i1> @llvm.experimental.constrained.fcmps.v4f16(<4 x half> %lhs, <4 x half> %rhs, metadata !"uno", metadata !"fpexcept.strict")
  ret <4 x i1> %retval
}

; CHECK-LABEL: fcmp_no_nans_true_v4f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:   setzi $m0, 65537
; CHECK-NEXT:   mov $m1, $m0
; CHECK:       br $m10
define <4 x i1> @fcmp_no_nans_true_v4f16(<4 x half> %lhs, <4 x half> %rhs) {
  %retval = fcmp true <4 x half> %lhs, %rhs
  ret <4 x i1> %retval
}
