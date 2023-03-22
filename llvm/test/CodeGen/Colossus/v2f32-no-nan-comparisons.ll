; RUN: llc < %s -march=colossus -colossus-coissue=false -enable-no-nans-fp-math -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -march=colossus -colossus-coissue=false -enable-no-nans-fp-math -mattr=+ipu2 | FileCheck %s
target triple = "colossus-graphcore--elf"

declare <2 x i1> @llvm.experimental.constrained.fcmps.v2f32(<2 x float>, <2 x float>, metadata, metadata)

; CHECK-LABEL: fcmp_no_nans_false_v2f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m15
; CHECK:       br $m10
define <2 x i1> @fcmp_no_nans_false_v2f32(<2 x float> %lhs, <2 x float> %rhs) {
  %retval = fcmp false <2 x float> %lhs, %rhs
  ret <2 x i1> %retval
}

; CHECK-LABEL: fcmp_no_nans_oeq_v2f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f32v2cmpeq $a0:1, $a0:1, $a2:3
; CHECK-DAG:   mov [[REGLO:\$m[0-9]+]], $a0
; CHECK-DAG:   mov [[REGHI:\$m[0-9]+]], $a1
; CHECK-NEXT:  sort4x16lo $m0, [[REGLO]], [[REGHI]]
; CHECK:       br $m10
define <2 x i1> @fcmp_no_nans_oeq_v2f32(<2 x float> %lhs, <2 x float> %rhs) {
  %retval = fcmp oeq <2 x float> %lhs, %rhs
  ret <2 x i1> %retval
}

; CHECK-LABEL: constrained_fcmps_no_nans_oeq_v2f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f32v2cmpeq $a0:1, $a0:1, $a2:3
; CHECK-DAG:   mov [[REGLO:\$m[0-9]+]], $a0
; CHECK-DAG:   mov [[REGHI:\$m[0-9]+]], $a1
; CHECK-NEXT:  sort4x16lo $m0, [[REGLO]], [[REGHI]]
; CHECK:       br $m10
define <2 x i1> @constrained_fcmps_no_nans_oeq_v2f32(<2 x float> %lhs, <2 x float> %rhs) {
  %retval = tail call <2 x i1> @llvm.experimental.constrained.fcmps.v2f32(<2 x float> %lhs, <2 x float> %rhs, metadata !"oeq", metadata !"fpexcept.strict")
  ret <2 x i1> %retval
}

; CHECK-LABEL: fcmp_no_nans_ogt_v2f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f32v2cmpgt $a0:1, $a0:1, $a2:3
; CHECK-DAG:   mov [[REGLO:\$m[0-9]+]], $a0
; CHECK-DAG:   mov [[REGHI:\$m[0-9]+]], $a1
; CHECK-NEXT:  sort4x16lo $m0, [[REGLO]], [[REGHI]]
; CHECK:       br $m10
define <2 x i1> @fcmp_no_nans_ogt_v2f32(<2 x float> %lhs, <2 x float> %rhs) {
  %retval = fcmp ogt <2 x float> %lhs, %rhs
  ret <2 x i1> %retval
}

; CHECK-LABEL: constrained_fcmps_no_nans_ogt_v2f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f32v2cmpgt $a0:1, $a0:1, $a2:3
; CHECK-DAG:   mov [[REGLO:\$m[0-9]+]], $a0
; CHECK-DAG:   mov [[REGHI:\$m[0-9]+]], $a1
; CHECK-NEXT:  sort4x16lo $m0, [[REGLO]], [[REGHI]]
; CHECK:       br $m10
define <2 x i1> @constrained_fcmps_no_nans_ogt_v2f32(<2 x float> %lhs, <2 x float> %rhs) {
  %retval = tail call <2 x i1> @llvm.experimental.constrained.fcmps.v2f32(<2 x float> %lhs, <2 x float> %rhs, metadata !"ogt", metadata !"fpexcept.strict")
  ret <2 x i1> %retval
}

; CHECK-LABEL: fcmp_no_nans_oge_v2f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f32v2cmpge $a0:1, $a0:1, $a2:3
; CHECK-DAG:   mov [[REGLO:\$m[0-9]+]], $a0
; CHECK-DAG:   mov [[REGHI:\$m[0-9]+]], $a1
; CHECK-NEXT:  sort4x16lo $m0, [[REGLO]], [[REGHI]]
; CHECK:       br $m10
define <2 x i1> @fcmp_no_nans_oge_v2f32(<2 x float> %lhs, <2 x float> %rhs) {
  %retval = fcmp oge <2 x float> %lhs, %rhs
  ret <2 x i1> %retval
}

; CHECK-LABEL: constrained_fcmps_no_nans_oge_v2f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f32v2cmpge $a0:1, $a0:1, $a2:3
; CHECK-DAG:   mov [[REGLO:\$m[0-9]+]], $a0
; CHECK-DAG:   mov [[REGHI:\$m[0-9]+]], $a1
; CHECK-NEXT:  sort4x16lo $m0, [[REGLO]], [[REGHI]]
; CHECK:       br $m10
define <2 x i1> @constrained_fcmps_no_nans_oge_v2f32(<2 x float> %lhs, <2 x float> %rhs) {
  %retval = tail call <2 x i1> @llvm.experimental.constrained.fcmps.v2f32(<2 x float> %lhs, <2 x float> %rhs, metadata !"oge", metadata !"fpexcept.strict")
  ret <2 x i1> %retval
}

; CHECK-LABEL: fcmp_no_nans_olt_v2f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f32v2cmplt $a0:1, $a0:1, $a2:3
; CHECK-DAG:   mov [[REGLO:\$m[0-9]+]], $a0
; CHECK-DAG:   mov [[REGHI:\$m[0-9]+]], $a1
; CHECK-NEXT:  sort4x16lo $m0, [[REGLO]], [[REGHI]]
; CHECK:       br $m10
define <2 x i1> @fcmp_no_nans_olt_v2f32(<2 x float> %lhs, <2 x float> %rhs) {
  %retval = fcmp olt <2 x float> %lhs, %rhs
  ret <2 x i1> %retval
}

; CHECK-LABEL: constrained_fcmps_no_nans_olt_v2f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f32v2cmplt $a0:1, $a0:1, $a2:3
; CHECK-DAG:   mov [[REGLO:\$m[0-9]+]], $a0
; CHECK-DAG:   mov [[REGHI:\$m[0-9]+]], $a1
; CHECK-NEXT:  sort4x16lo $m0, [[REGLO]], [[REGHI]]
; CHECK:       br $m10
define <2 x i1> @constrained_fcmps_no_nans_olt_v2f32(<2 x float> %lhs, <2 x float> %rhs) {
  %retval = tail call <2 x i1> @llvm.experimental.constrained.fcmps.v2f32(<2 x float> %lhs, <2 x float> %rhs, metadata !"olt", metadata !"fpexcept.strict")
  ret <2 x i1> %retval
}

; CHECK-LABEL: fcmp_no_nans_ole_v2f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f32v2cmple $a0:1, $a0:1, $a2:3
; CHECK-DAG:   mov [[REGLO:\$m[0-9]+]], $a0
; CHECK-DAG:   mov [[REGHI:\$m[0-9]+]], $a1
; CHECK-NEXT:  sort4x16lo $m0, [[REGLO]], [[REGHI]]
; CHECK:       br $m10
define <2 x i1> @fcmp_no_nans_ole_v2f32(<2 x float> %lhs, <2 x float> %rhs) {
  %retval = fcmp ole <2 x float> %lhs, %rhs
  ret <2 x i1> %retval
}

; CHECK-LABEL: constrained_fcmps_no_nans_ole_v2f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f32v2cmple $a0:1, $a0:1, $a2:3
; CHECK-DAG:   mov [[REGLO:\$m[0-9]+]], $a0
; CHECK-DAG:   mov [[REGHI:\$m[0-9]+]], $a1
; CHECK-NEXT:  sort4x16lo $m0, [[REGLO]], [[REGHI]]
; CHECK:       br $m10
define <2 x i1> @constrained_fcmps_no_nans_ole_v2f32(<2 x float> %lhs, <2 x float> %rhs) {
  %retval = tail call <2 x i1> @llvm.experimental.constrained.fcmps.v2f32(<2 x float> %lhs, <2 x float> %rhs, metadata !"ole", metadata !"fpexcept.strict")
  ret <2 x i1> %retval
}

; CHECK-LABEL: fcmp_no_nans_one_v2f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f32v2cmpne $a0:1, $a0:1, $a2:3
; CHECK-DAG:   mov [[REGLO:\$m[0-9]+]], $a0
; CHECK-DAG:   mov [[REGHI:\$m[0-9]+]], $a1
; CHECK-NEXT:  sort4x16lo $m0, [[REGLO]], [[REGHI]]
; CHECK:       br $m10
define <2 x i1> @fcmp_no_nans_one_v2f32(<2 x float> %lhs, <2 x float> %rhs) {
  %retval = fcmp one <2 x float> %lhs, %rhs
  ret <2 x i1> %retval
}

; CHECK-LABEL: constrained_fcmps_no_nans_one_v2f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f32v2cmpne $a0:1, $a0:1, $a2:3
; CHECK-DAG:   mov [[REGLO:\$m[0-9]+]], $a0
; CHECK-DAG:   mov [[REGHI:\$m[0-9]+]], $a1
; CHECK-NEXT:  sort4x16lo $m0, [[REGLO]], [[REGHI]]
; CHECK:       br $m10
define <2 x i1> @constrained_fcmps_no_nans_one_v2f32(<2 x float> %lhs, <2 x float> %rhs) {
  %retval = tail call <2 x i1> @llvm.experimental.constrained.fcmps.v2f32(<2 x float> %lhs, <2 x float> %rhs, metadata !"one", metadata !"fpexcept.strict")
  ret <2 x i1> %retval
}

; CHECK-LABEL: fcmp_no_nans_ord_v2f32:
; CHECK:       # %bb.0:
; CHECK-DAG:   f32v2cmpeq $a0:1, $a0:1, $a0:1
; CHECK-DAG:   f32v2cmpeq $a2:3, $a2:3, $a2:3
; CHECK-NEXT:  and64 $a0:1, $a0:1, $a2:3
; CHECK-DAG:   mov [[TMPLO:\$m[0-9]+]], $a0
; CHECK-DAG:   mov [[TMPHI:\$m[0-9]+]], $a1
; CHECK-NEXT:  sort4x16lo $m0, [[TMPLO]], [[TMPHI]]
; CHECK:       br $m10
define <2 x i1> @fcmp_no_nans_ord_v2f32(<2 x float> %lhs, <2 x float> %rhs) {
  %retval = fcmp ord <2 x float> %lhs, %rhs
  ret <2 x i1> %retval
}

; CHECK-LABEL: constrained_fcmps_no_nans_ord_v2f32:
; CHECK:       # %bb.0:
; CHECK-DAG:   f32v2cmpeq $a0:1, $a0:1, $a0:1
; CHECK-DAG:   f32v2cmpeq $a2:3, $a2:3, $a2:3
; CHECK-NEXT:  and64 $a0:1, $a0:1, $a2:3
; CHECK-DAG:   mov [[TMPLO:\$m[0-9]+]], $a0
; CHECK-DAG:   mov [[TMPHI:\$m[0-9]+]], $a1
; CHECK-NEXT:  sort4x16lo $m0, [[TMPLO]], [[TMPHI]]
; CHECK:       br $m10
define <2 x i1> @constrained_fcmps_no_nans_ord_v2f32(<2 x float> %lhs, <2 x float> %rhs) {
  %retval = tail call <2 x i1> @llvm.experimental.constrained.fcmps.v2f32(<2 x float> %lhs, <2 x float> %rhs, metadata !"ord", metadata !"fpexcept.strict")
  ret <2 x i1> %retval
}

; CHECK-LABEL: fcmp_no_nans_ueq_v2f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f32v2cmpeq $a0:1, $a0:1, $a2:3
; CHECK-DAG:   mov [[REGLO:\$m[0-9]+]], $a0
; CHECK-DAG:   mov [[REGHI:\$m[0-9]+]], $a1
; CHECK-NEXT:  sort4x16lo $m0, [[REGLO]], [[REGHI]]
; CHECK:       br $m10
define <2 x i1> @fcmp_no_nans_ueq_v2f32(<2 x float> %lhs, <2 x float> %rhs) {
  %retval = fcmp ueq <2 x float> %lhs, %rhs
  ret <2 x i1> %retval
}

; CHECK-LABEL: constrained_fcmps_no_nans_ueq_v2f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f32v2cmpeq $a0:1, $a0:1, $a2:3
; CHECK-DAG:   mov [[REGLO:\$m[0-9]+]], $a0
; CHECK-DAG:   mov [[REGHI:\$m[0-9]+]], $a1
; CHECK-NEXT:  sort4x16lo $m0, [[REGLO]], [[REGHI]]
; CHECK:       br $m10
define <2 x i1> @constrained_fcmps_no_nans_ueq_v2f32(<2 x float> %lhs, <2 x float> %rhs) {
  %retval = tail call <2 x i1> @llvm.experimental.constrained.fcmps.v2f32(<2 x float> %lhs, <2 x float> %rhs, metadata !"ueq", metadata !"fpexcept.strict")
  ret <2 x i1> %retval
}

; CHECK-LABEL: fcmp_no_nans_ugt_v2f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f32v2cmpgt $a0:1, $a0:1, $a2:3
; CHECK-DAG:   mov [[REGLO:\$m[0-9]+]], $a0
; CHECK-DAG:   mov [[REGHI:\$m[0-9]+]], $a1
; CHECK-NEXT:  sort4x16lo $m0, [[REGLO]], [[REGHI]]
; CHECK:       br $m10
define <2 x i1> @fcmp_no_nans_ugt_v2f32(<2 x float> %lhs, <2 x float> %rhs) {
  %retval = fcmp ugt <2 x float> %lhs, %rhs
  ret <2 x i1> %retval
}

; CHECK-LABEL: constrained_fcmps_no_nans_ugt_v2f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f32v2cmpgt $a0:1, $a0:1, $a2:3
; CHECK-DAG:   mov [[REGLO:\$m[0-9]+]], $a0
; CHECK-DAG:   mov [[REGHI:\$m[0-9]+]], $a1
; CHECK-NEXT:  sort4x16lo $m0, [[REGLO]], [[REGHI]]
; CHECK:       br $m10
define <2 x i1> @constrained_fcmps_no_nans_ugt_v2f32(<2 x float> %lhs, <2 x float> %rhs) {
  %retval = tail call <2 x i1> @llvm.experimental.constrained.fcmps.v2f32(<2 x float> %lhs, <2 x float> %rhs, metadata !"ugt", metadata !"fpexcept.strict")
  ret <2 x i1> %retval
}

; CHECK-LABEL: fcmp_no_nans_uge_v2f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f32v2cmpge $a0:1, $a0:1, $a2:3
; CHECK-DAG:   mov [[REGLO:\$m[0-9]+]], $a0
; CHECK-DAG:   mov [[REGHI:\$m[0-9]+]], $a1
; CHECK-NEXT:  sort4x16lo $m0, [[REGLO]], [[REGHI]]
; CHECK:       br $m10
define <2 x i1> @fcmp_no_nans_uge_v2f32(<2 x float> %lhs, <2 x float> %rhs) {
  %retval = fcmp uge <2 x float> %lhs, %rhs
  ret <2 x i1> %retval
}

; CHECK-LABEL: constrained_fcmps_no_nans_uge_v2f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f32v2cmpge $a0:1, $a0:1, $a2:3
; CHECK-DAG:   mov [[REGLO:\$m[0-9]+]], $a0
; CHECK-DAG:   mov [[REGHI:\$m[0-9]+]], $a1
; CHECK-NEXT:  sort4x16lo $m0, [[REGLO]], [[REGHI]]
; CHECK:       br $m10
define <2 x i1> @constrained_fcmps_no_nans_uge_v2f32(<2 x float> %lhs, <2 x float> %rhs) {
  %retval = tail call <2 x i1> @llvm.experimental.constrained.fcmps.v2f32(<2 x float> %lhs, <2 x float> %rhs, metadata !"uge", metadata !"fpexcept.strict")
  ret <2 x i1> %retval
}

; CHECK-LABEL: fcmp_no_nans_ult_v2f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f32v2cmplt $a0:1, $a0:1, $a2:3
; CHECK-DAG:   mov [[REGLO:\$m[0-9]+]], $a0
; CHECK-DAG:   mov [[REGHI:\$m[0-9]+]], $a1
; CHECK-NEXT:  sort4x16lo $m0, [[REGLO]], [[REGHI]]
; CHECK:       br $m10
define <2 x i1> @fcmp_no_nans_ult_v2f32(<2 x float> %lhs, <2 x float> %rhs) {
  %retval = fcmp ult <2 x float> %lhs, %rhs
  ret <2 x i1> %retval
}

; CHECK-LABEL: constrained_fcmps_no_nans_ult_v2f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f32v2cmplt $a0:1, $a0:1, $a2:3
; CHECK-DAG:   mov [[REGLO:\$m[0-9]+]], $a0
; CHECK-DAG:   mov [[REGHI:\$m[0-9]+]], $a1
; CHECK-NEXT:  sort4x16lo $m0, [[REGLO]], [[REGHI]]
; CHECK:       br $m10
define <2 x i1> @constrained_fcmps_no_nans_ult_v2f32(<2 x float> %lhs, <2 x float> %rhs) {
  %retval = tail call <2 x i1> @llvm.experimental.constrained.fcmps.v2f32(<2 x float> %lhs, <2 x float> %rhs, metadata !"ult", metadata !"fpexcept.strict")
  ret <2 x i1> %retval
}

; CHECK-LABEL: fcmp_no_nans_ule_v2f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f32v2cmple $a0:1, $a0:1, $a2:3
; CHECK-DAG:   mov [[REGLO:\$m[0-9]+]], $a0
; CHECK-DAG:   mov [[REGHI:\$m[0-9]+]], $a1
; CHECK-NEXT:  sort4x16lo $m0, [[REGLO]], [[REGHI]]
; CHECK:       br $m10
define <2 x i1> @fcmp_no_nans_ule_v2f32(<2 x float> %lhs, <2 x float> %rhs) {
  %retval = fcmp ule <2 x float> %lhs, %rhs
  ret <2 x i1> %retval
}

; CHECK-LABEL: constrained_fcmps_no_nans_ule_v2f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f32v2cmple $a0:1, $a0:1, $a2:3
; CHECK-DAG:   mov [[REGLO:\$m[0-9]+]], $a0
; CHECK-DAG:   mov [[REGHI:\$m[0-9]+]], $a1
; CHECK-NEXT:  sort4x16lo $m0, [[REGLO]], [[REGHI]]
; CHECK:       br $m10
define <2 x i1> @constrained_fcmps_no_nans_ule_v2f32(<2 x float> %lhs, <2 x float> %rhs) {
  %retval = tail call <2 x i1> @llvm.experimental.constrained.fcmps.v2f32(<2 x float> %lhs, <2 x float> %rhs, metadata !"ule", metadata !"fpexcept.strict")
  ret <2 x i1> %retval
}

; CHECK-LABEL: fcmp_no_nans_une_v2f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f32v2cmpne $a0:1, $a0:1, $a2:3
; CHECK-DAG:   mov [[REGLO:\$m[0-9]+]], $a0
; CHECK-DAG:   mov [[REGHI:\$m[0-9]+]], $a1
; CHECK-NEXT:  sort4x16lo $m0, [[REGLO]], [[REGHI]]
; CHECK:       br $m10
define <2 x i1> @fcmp_no_nans_une_v2f32(<2 x float> %lhs, <2 x float> %rhs) {
  %retval = fcmp une <2 x float> %lhs, %rhs
  ret <2 x i1> %retval
}

; CHECK-LABEL: constrained_fcmps_no_nans_une_v2f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f32v2cmpne $a0:1, $a0:1, $a2:3
; CHECK-DAG:   mov [[REGLO:\$m[0-9]+]], $a0
; CHECK-DAG:   mov [[REGHI:\$m[0-9]+]], $a1
; CHECK-NEXT:  sort4x16lo $m0, [[REGLO]], [[REGHI]]
; CHECK:       br $m10
define <2 x i1> @constrained_fcmps_no_nans_une_v2f32(<2 x float> %lhs, <2 x float> %rhs) {
  %retval = tail call <2 x i1> @llvm.experimental.constrained.fcmps.v2f32(<2 x float> %lhs, <2 x float> %rhs, metadata !"une", metadata !"fpexcept.strict")
  ret <2 x i1> %retval
}

; CHECK-LABEL: fcmp_no_nans_uno_v2f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:   f32v2cmpne $a2:3, $a2:3, $a2:3
; CHECK-NEXT:   f32v2cmpne $a0:1, $a0:1, $a0:1
; CHECK-NEXT:   or64 $a0:1, $a0:1, $a2:3
; CHECK-DAG:    mov [[TMPLO:\$m[0-9]+]], $a0
; CHECK-DAG:    mov [[TMPHI:\$m[0-9]+]], $a1
; CHECK-NEXT:  sort4x16lo $m0, [[TMPLO]], [[TMPHI]]
; CHECK:       br $m10
define <2 x i1> @fcmp_no_nans_uno_v2f32(<2 x float> %lhs, <2 x float> %rhs) {
  %retval = fcmp uno <2 x float> %lhs, %rhs
  ret <2 x i1> %retval
}

; CHECK-LABEL: constrained_fcmps_no_nans_uno_v2f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:   f32v2cmpne $a2:3, $a2:3, $a2:3
; CHECK-NEXT:   f32v2cmpne $a0:1, $a0:1, $a0:1
; CHECK-NEXT:   or64 $a0:1, $a0:1, $a2:3
; CHECK-DAG:    mov [[TMPLO:\$m[0-9]+]], $a0
; CHECK-DAG:    mov [[TMPHI:\$m[0-9]+]], $a1
; CHECK-NEXT:  sort4x16lo $m0, [[TMPLO]], [[TMPHI]]
; CHECK:       br $m10
define <2 x i1> @constrained_fcmps_no_nans_uno_v2f32(<2 x float> %lhs, <2 x float> %rhs) {
  %retval = tail call <2 x i1> @llvm.experimental.constrained.fcmps.v2f32(<2 x float> %lhs, <2 x float> %rhs, metadata !"uno", metadata !"fpexcept.strict")
  ret <2 x i1> %retval
}

; CHECK-LABEL: fcmp_no_nans_true_v2f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  setzi $m0, 65537
; CHECK:       br $m10
define <2 x i1> @fcmp_no_nans_true_v2f32(<2 x float> %lhs, <2 x float> %rhs) {
  %retval = fcmp true <2 x float> %lhs, %rhs
  ret <2 x i1> %retval
}
