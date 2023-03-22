; RUN: llc < %s -march=colossus -colossus-coissue=false -enable-no-nans-fp-math -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -march=colossus -colossus-coissue=false -enable-no-nans-fp-math -mattr=+ipu2 | FileCheck %s
target triple = "colossus-graphcore--elf"

declare i1 @llvm.experimental.constrained.fcmps.f16(half, half, metadata, metadata)

; CHECK-LABEL: fcmp_no_nans_false_f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m15
; CHECK:       br $m10
define i1 @fcmp_no_nans_false_f16(half %lhs, half %rhs) {
  %retval = fcmp false half %lhs, %rhs
  ret i1 %retval
}

; CHECK-LABEL: fcmp_no_nans_oeq_f16:
; CHECK:       # %bb.0:
; CHECK-DAG:   f16tof32 $a0, $a0
; CHECK-DAG:   f16tof32 $a1, $a1
; CHECK-NEXT:  f32cmpeq [[REGA:\$a[0-9]+]], $a0, $a1
; CHECK-NEXT:  mov $m0, [[REGA]]
; CHECK:       br $m10
define i1 @fcmp_no_nans_oeq_f16(half %lhs, half %rhs) {
  %retval = fcmp oeq half %lhs, %rhs
  ret i1 %retval
}

; CHECK-LABEL: constrained_fcmps_no_nans_oeq_f16:
; CHECK:       # %bb.0:
; CHECK-DAG:   f16tof32 $a0, $a0
; CHECK-DAG:   f16tof32 $a1, $a1
; CHECK-NEXT:  f32cmpeq [[REGA:\$a[0-9]+]], $a0, $a1
; CHECK-NEXT:  mov $m0, [[REGA]]
; CHECK:       br $m10
define i1 @constrained_fcmps_no_nans_oeq_f16(half %lhs, half %rhs) {
  %retval = tail call i1 @llvm.experimental.constrained.fcmps.f16(half %lhs, half %rhs, metadata !"oeq", metadata !"fpexcept.strict")
  ret i1 %retval
}

; CHECK-LABEL: fcmp_no_nans_ogt_f16:
; CHECK:       # %bb.0:
; CHECK-DAG:   f16tof32 $a0, $a0
; CHECK-DAG:   f16tof32 $a1, $a1
; CHECK-NEXT:  f32cmpgt [[REGA:\$a[0-9]+]], $a0, $a1
; CHECK-NEXT:  mov $m0, [[REGA]]
; CHECK:       br $m10
define i1 @fcmp_no_nans_ogt_f16(half %lhs, half %rhs) {
  %retval = fcmp ogt half %lhs, %rhs
  ret i1 %retval
}

; CHECK-LABEL: constrained_fcmps_no_nans_ogt_f16:
; CHECK:       # %bb.0:
; CHECK-DAG:   f16tof32 $a0, $a0
; CHECK-DAG:   f16tof32 $a1, $a1
; CHECK-NEXT:  f32cmpgt [[REGA:\$a[0-9]+]], $a0, $a1
; CHECK-NEXT:  mov $m0, [[REGA]]
; CHECK:       br $m10
define i1 @constrained_fcmps_no_nans_ogt_f16(half %lhs, half %rhs) {
  %retval = tail call i1 @llvm.experimental.constrained.fcmps.f16(half %lhs, half %rhs, metadata !"ogt", metadata !"fpexcept.strict")
  ret i1 %retval
}

; CHECK-LABEL: fcmp_no_nans_oge_f16:
; CHECK:       # %bb.0:
; CHECK-DAG:   f16tof32 $a0, $a0
; CHECK-DAG:   f16tof32 $a1, $a1
; CHECK-NEXT:  f32cmpge [[REGA:\$a[0-9]+]], $a0, $a1
; CHECK-NEXT:  mov $m0, [[REGA]]
; CHECK:       br $m10
define i1 @fcmp_no_nans_oge_f16(half %lhs, half %rhs) {
  %retval = fcmp oge half %lhs, %rhs
  ret i1 %retval
}

; CHECK-LABEL: constrained_fcmps_no_nans_oge_f16:
; CHECK:       # %bb.0:
; CHECK-DAG:   f16tof32 $a0, $a0
; CHECK-DAG:   f16tof32 $a1, $a1
; CHECK-NEXT:  f32cmpge [[REGA:\$a[0-9]+]], $a0, $a1
; CHECK-NEXT:  mov $m0, [[REGA]]
; CHECK:       br $m10
define i1 @constrained_fcmps_no_nans_oge_f16(half %lhs, half %rhs) {
  %retval = tail call i1 @llvm.experimental.constrained.fcmps.f16(half %lhs, half %rhs, metadata !"oge", metadata !"fpexcept.strict")
  ret i1 %retval
}

; CHECK-LABEL: fcmp_no_nans_olt_f16:
; CHECK:       # %bb.0:
; CHECK-DAG:   f16tof32 $a0, $a0
; CHECK-DAG:   f16tof32 $a1, $a1
; CHECK-NEXT:  f32cmplt [[REGA:\$a[0-9]+]], $a0, $a1
; CHECK-NEXT:  mov $m0, [[REGA]]
; CHECK:       br $m10
define i1 @fcmp_no_nans_olt_f16(half %lhs, half %rhs) {
  %retval = fcmp olt half %lhs, %rhs
  ret i1 %retval
}

; CHECK-LABEL: constrained_fcmps_no_nans_olt_f16:
; CHECK:       # %bb.0:
; CHECK-DAG:   f16tof32 $a0, $a0
; CHECK-DAG:   f16tof32 $a1, $a1
; CHECK-NEXT:  f32cmplt [[REGA:\$a[0-9]+]], $a0, $a1
; CHECK-NEXT:  mov $m0, [[REGA]]
; CHECK:       br $m10
define i1 @constrained_fcmps_no_nans_olt_f16(half %lhs, half %rhs) {
  %retval = tail call i1 @llvm.experimental.constrained.fcmps.f16(half %lhs, half %rhs, metadata !"olt", metadata !"fpexcept.strict")
  ret i1 %retval
}

; CHECK-LABEL: fcmp_no_nans_ole_f16:
; CHECK:       # %bb.0:
; CHECK-DAG:   f16tof32 $a0, $a0
; CHECK-DAG:   f16tof32 $a1, $a1
; CHECK-NEXT:  f32cmple [[REGA:\$a[0-9]+]], $a0, $a1
; CHECK-NEXT:  mov $m0, [[REGA]]
; CHECK:       br $m10
define i1 @fcmp_no_nans_ole_f16(half %lhs, half %rhs) {
  %retval = fcmp ole half %lhs, %rhs
  ret i1 %retval
}

; CHECK-LABEL: constrained_fcmps_no_nans_ole_f16:
; CHECK:       # %bb.0:
; CHECK-DAG:   f16tof32 $a0, $a0
; CHECK-DAG:   f16tof32 $a1, $a1
; CHECK-NEXT:  f32cmple [[REGA:\$a[0-9]+]], $a0, $a1
; CHECK-NEXT:  mov $m0, [[REGA]]
; CHECK:       br $m10
define i1 @constrained_fcmps_no_nans_ole_f16(half %lhs, half %rhs) {
  %retval = tail call i1 @llvm.experimental.constrained.fcmps.f16(half %lhs, half %rhs, metadata !"ole", metadata !"fpexcept.strict")
  ret i1 %retval
}

; CHECK-LABEL: fcmp_no_nans_one_f16:
; CHECK:       # %bb.0:
; CHECK-DAG:   f16tof32 $a0, $a0
; CHECK-DAG:   f16tof32 $a1, $a1
; CHECK-NEXT:  f32cmpne [[REGA:\$a[0-9]+]], $a0, $a1
; CHECK-NEXT:  mov $m0, [[REGA]]
; CHECK:       br $m10
define i1 @fcmp_no_nans_one_f16(half %lhs, half %rhs) {
  %retval = fcmp one half %lhs, %rhs
  ret i1 %retval
}

; CHECK-LABEL: constrained_fcmps_no_nans_one_f16:
; CHECK:       # %bb.0:
; CHECK-DAG:   f16tof32 $a0, $a0
; CHECK-DAG:   f16tof32 $a1, $a1
; CHECK-NEXT:  f32cmpne [[REGA:\$a[0-9]+]], $a0, $a1
; CHECK-NEXT:  mov $m0, [[REGA]]
; CHECK:       br $m10
define i1 @constrained_fcmps_no_nans_one_f16(half %lhs, half %rhs) {
  %retval = tail call i1 @llvm.experimental.constrained.fcmps.f16(half %lhs, half %rhs, metadata !"one", metadata !"fpexcept.strict")
  ret i1 %retval
}

; CHECK-LABEL: fcmp_no_nans_ord_f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f16tof32 $a1, $a1
; CHECK-NEXT:  f32cmpeq $a1, $a1, $a1
; CHECK-NEXT:  f16tof32 $a0, $a0
; CHECK-NEXT:  f32cmpeq $a0, $a0, $a0
; CHECK-NEXT:  and $a0, $a0, $a1
; CHECK-NEXT:  mov $m0, $a0
; CHECK:       br $m10
define i1 @fcmp_no_nans_ord_f16(half %lhs, half %rhs) {
  %retval = fcmp ord half %lhs, %rhs
  ret i1 %retval
}

; CHECK-LABEL: constrained_fcmps_no_nans_ord_f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f16tof32 $a0, $a0
; CHECK-NEXT:  f16tof32 $a1, $a1
; CHECK-NEXT:  f32cmpeq $a1, $a1, $a1
; CHECK-NEXT:  f32cmpeq $a0, $a0, $a0
; CHECK-NEXT:  and $a0, $a0, $a1
; CHECK-NEXT:  mov $m0, $a0
; CHECK:       br $m10
define i1 @constrained_fcmps_no_nans_ord_f16(half %lhs, half %rhs) {
  %retval = tail call i1 @llvm.experimental.constrained.fcmps.f16(half %lhs, half %rhs, metadata !"ord", metadata !"fpexcept.strict")
  ret i1 %retval
}

; CHECK-LABEL: fcmp_no_nans_ueq_f16:
; CHECK:       # %bb.0:
; CHECK-DAG:   f16tof32 $a0, $a0
; CHECK-DAG:   f16tof32 $a1, $a1
; CHECK-NEXT:  f32cmpeq [[REGA:\$a[0-9]+]], $a0, $a1
; CHECK-NEXT:  mov $m0, [[REGA]]
; CHECK:       br $m10
define i1 @fcmp_no_nans_ueq_f16(half %lhs, half %rhs) {
  %retval = fcmp ueq half %lhs, %rhs
  ret i1 %retval
}

; CHECK-LABEL: constrained_fcmps_no_nans_ueq_f16:
; CHECK:       # %bb.0:
; CHECK-DAG:   f16tof32 $a0, $a0
; CHECK-DAG:   f16tof32 $a1, $a1
; CHECK-NEXT:  f32cmpeq [[REGA:\$a[0-9]+]], $a0, $a1
; CHECK-NEXT:  mov $m0, [[REGA]]
; CHECK:       br $m10
define i1 @constrained_fcmps_no_nans_ueq_f16(half %lhs, half %rhs) {
  %retval = tail call i1 @llvm.experimental.constrained.fcmps.f16(half %lhs, half %rhs, metadata !"ueq", metadata !"fpexcept.strict")
  ret i1 %retval
}

; CHECK-LABEL: fcmp_no_nans_ugt_f16:
; CHECK:       # %bb.0:
; CHECK-DAG:   f16tof32 $a0, $a0
; CHECK-DAG:   f16tof32 $a1, $a1
; CHECK-NEXT:  f32cmpgt [[REGA:\$a[0-9]+]], $a0, $a1
; CHECK-NEXT:  mov $m0, [[REGA]]
; CHECK:       br $m10
define i1 @fcmp_no_nans_ugt_f16(half %lhs, half %rhs) {
  %retval = fcmp ugt half %lhs, %rhs
  ret i1 %retval
}

; CHECK-LABEL: constrained_fcmps_no_nans_ugt_f16:
; CHECK:       # %bb.0:
; CHECK-DAG:   f16tof32 $a0, $a0
; CHECK-DAG:   f16tof32 $a1, $a1
; CHECK-NEXT:  f32cmpgt [[REGA:\$a[0-9]+]], $a0, $a1
; CHECK-NEXT:  mov $m0, [[REGA]]
; CHECK:       br $m10
define i1 @constrained_fcmps_no_nans_ugt_f16(half %lhs, half %rhs) {
  %retval = tail call i1 @llvm.experimental.constrained.fcmps.f16(half %lhs, half %rhs, metadata !"ugt", metadata !"fpexcept.strict")
  ret i1 %retval
}

; CHECK-LABEL: fcmp_no_nans_uge_f16:
; CHECK:       # %bb.0:
; CHECK-DAG:   f16tof32 $a0, $a0
; CHECK-DAG:   f16tof32 $a1, $a1
; CHECK-NEXT:  f32cmpge [[REGA:\$a[0-9]+]], $a0, $a1
; CHECK-NEXT:  mov $m0, [[REGA]]
; CHECK:       br $m10
define i1 @fcmp_no_nans_uge_f16(half %lhs, half %rhs) {
  %retval = fcmp uge half %lhs, %rhs
  ret i1 %retval
}

; CHECK-LABEL: constrained_fcmps_no_nans_uge_f16:
; CHECK:       # %bb.0:
; CHECK-DAG:   f16tof32 $a0, $a0
; CHECK-DAG:   f16tof32 $a1, $a1
; CHECK-NEXT:  f32cmpge [[REGA:\$a[0-9]+]], $a0, $a1
; CHECK-NEXT:  mov $m0, [[REGA]]
; CHECK:       br $m10
define i1 @constrained_fcmps_no_nans_uge_f16(half %lhs, half %rhs) {
  %retval = tail call i1 @llvm.experimental.constrained.fcmps.f16(half %lhs, half %rhs, metadata !"uge", metadata !"fpexcept.strict")
  ret i1 %retval
}

; CHECK-LABEL: fcmp_no_nans_ult_f16:
; CHECK:       # %bb.0:
; CHECK-DAG:   f16tof32 $a0, $a0
; CHECK-DAG:   f16tof32 $a1, $a1
; CHECK-NEXT:  f32cmplt [[REGA:\$a[0-9]+]], $a0, $a1
; CHECK-NEXT:  mov $m0, [[REGA]]
; CHECK:       br $m10
define i1 @fcmp_no_nans_ult_f16(half %lhs, half %rhs) {
  %retval = fcmp ult half %lhs, %rhs
  ret i1 %retval
}

; CHECK-LABEL: constrained_fcmps_no_nans_ult_f16:
; CHECK:       # %bb.0:
; CHECK-DAG:   f16tof32 $a0, $a0
; CHECK-DAG:   f16tof32 $a1, $a1
; CHECK-NEXT:  f32cmplt [[REGA:\$a[0-9]+]], $a0, $a1
; CHECK-NEXT:  mov $m0, [[REGA]]
; CHECK:       br $m10
define i1 @constrained_fcmps_no_nans_ult_f16(half %lhs, half %rhs) {
  %retval = tail call i1 @llvm.experimental.constrained.fcmps.f16(half %lhs, half %rhs, metadata !"ult", metadata !"fpexcept.strict")
  ret i1 %retval
}

; CHECK-LABEL: fcmp_no_nans_ule_f16:
; CHECK:       # %bb.0:
; CHECK-DAG:   f16tof32 $a0, $a0
; CHECK-DAG:   f16tof32 $a1, $a1
; CHECK-NEXT:  f32cmple [[REGA:\$a[0-9]+]], $a0, $a1
; CHECK-NEXT:  mov $m0, [[REGA]]
; CHECK:       br $m10
define i1 @fcmp_no_nans_ule_f16(half %lhs, half %rhs) {
  %retval = fcmp ule half %lhs, %rhs
  ret i1 %retval
}

; CHECK-LABEL: constrained_fcmps_no_nans_ule_f16:
; CHECK:       # %bb.0:
; CHECK-DAG:   f16tof32 $a0, $a0
; CHECK-DAG:   f16tof32 $a1, $a1
; CHECK-NEXT:  f32cmple [[REGA:\$a[0-9]+]], $a0, $a1
; CHECK-NEXT:  mov $m0, [[REGA]]
; CHECK:       br $m10
define i1 @constrained_fcmps_no_nans_ule_f16(half %lhs, half %rhs) {
  %retval = tail call i1 @llvm.experimental.constrained.fcmps.f16(half %lhs, half %rhs, metadata !"ule", metadata !"fpexcept.strict")
  ret i1 %retval
}

; CHECK-LABEL: fcmp_no_nans_une_f16:
; CHECK:       # %bb.0:
; CHECK-DAG:   f16tof32 $a0, $a0
; CHECK-DAG:   f16tof32 $a1, $a1
; CHECK-NEXT:  f32cmpne [[REGA:\$a[0-9]+]], $a0, $a1
; CHECK-NEXT:  mov $m0, [[REGA]]
; CHECK:       br $m10
define i1 @fcmp_no_nans_une_f16(half %lhs, half %rhs) {
  %retval = fcmp une half %lhs, %rhs
  ret i1 %retval
}

; CHECK-LABEL: constrained_fcmps_no_nans_une_f16:
; CHECK:       # %bb.0:
; CHECK-DAG:   f16tof32 $a0, $a0
; CHECK-DAG:   f16tof32 $a1, $a1
; CHECK-NEXT:  f32cmpne [[REGA:\$a[0-9]+]], $a0, $a1
; CHECK-NEXT:  mov $m0, [[REGA]]
; CHECK:       br $m10
define i1 @constrained_fcmps_no_nans_une_f16(half %lhs, half %rhs) {
  %retval = tail call i1 @llvm.experimental.constrained.fcmps.f16(half %lhs, half %rhs, metadata !"une", metadata !"fpexcept.strict")
  ret i1 %retval
}

; CHECK-LABEL: fcmp_no_nans_uno_f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f16tof32 $a1, $a1
; CHECK-NEXT:  f32cmpne $a1, $a1, $a1
; CHECK-NEXT:  f16tof32 $a0, $a0
; CHECK-NEXT:  f32cmpne $a0, $a0, $a0
; CHECK-NEXT:  or $a0, $a0, $a1
; CHECK-NEXT:  mov $m0, $a0
; CHECK:       br $m10
define i1 @fcmp_no_nans_uno_f16(half %lhs, half %rhs) {
  %retval = fcmp uno half %lhs, %rhs
  ret i1 %retval
}

; CHECK-LABEL: constrained_fcmps_no_nans_uno_f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f16tof32 $a0, $a0
; CHECK-NEXT:  f16tof32 $a1, $a1
; CHECK-NEXT:  f32cmpne $a1, $a1, $a1
; CHECK-NEXT:  f32cmpne $a0, $a0, $a0
; CHECK-NEXT:  or $a0, $a0, $a1
; CHECK-NEXT:  mov $m0, $a0
; CHECK:       br $m10
define i1 @constrained_fcmps_no_nans_uno_f16(half %lhs, half %rhs) {
  %retval = tail call i1 @llvm.experimental.constrained.fcmps.f16(half %lhs, half %rhs, metadata !"uno", metadata !"fpexcept.strict")
  ret i1 %retval
}

; CHECK-LABEL: fcmp_no_nans_true_f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  setzi $m0, 1
; CHECK:       br $m10
define i1 @fcmp_no_nans_true_f16(half %lhs, half %rhs) {
  %retval = fcmp true half %lhs, %rhs
  ret i1 %retval
}
