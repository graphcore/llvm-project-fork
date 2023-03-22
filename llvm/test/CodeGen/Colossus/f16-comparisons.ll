; RUN: llc < %s -march=colossus -colossus-coissue=false -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -march=colossus -colossus-coissue=false -mattr=+ipu2 | FileCheck %s

; RUN: llc < %s -march=colossus -colossus-coissue=false -enable-no-infs-fp-math | FileCheck %s
; RUN: llc < %s -march=colossus -colossus-coissue=false -enable-no-signed-zeros-fp-math | FileCheck %s
target triple = "colossus-graphcore--elf"

declare i1 @llvm.experimental.constrained.fcmps.f16(half, half, metadata, metadata)

; CHECK-LABEL: fcmp_false_f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m15
; CHECK:       br $m10
define i1 @fcmp_false_f16(half %lhs, half %rhs) {
  %retval = fcmp false half %lhs, %rhs
  ret i1 %retval
}

; CHECK-LABEL: fcmp_oeq_f16:
; CHECK:       # %bb.0:
; CHECK-DAG:   f16tof32 $a0, $a0
; CHECK-DAG:   f16tof32 $a1, $a1
; CHECK-NEXT:  f32cmpeq [[REGA:\$a[0-9]+]], $a0, $a1
; CHECK-NEXT:  mov $m0, [[REGA]]
; CHECK:       br $m10
define i1 @fcmp_oeq_f16(half %lhs, half %rhs) {
  %retval = fcmp oeq half %lhs, %rhs
  ret i1 %retval
}

; CHECK-LABEL: constrained_fcmps_oeq_f16:
; CHECK:       # %bb.0:
; CHECK-DAG:   f16tof32 $a0, $a0
; CHECK-DAG:   f16tof32 $a1, $a1
; CHECK-NEXT:  f32cmpeq [[REGA:\$a[0-9]+]], $a0, $a1
; CHECK-NEXT:  mov $m0, [[REGA]]
; CHECK:       br $m10
define i1 @constrained_fcmps_oeq_f16(half %lhs, half %rhs) {
  %retval = tail call i1 @llvm.experimental.constrained.fcmps.f16(half %lhs, half %rhs, metadata !"oeq", metadata !"fpexcept.strict")
  ret i1 %retval
}

; CHECK-LABEL: fcmp_ogt_f16:
; CHECK:       # %bb.0:
; CHECK-DAG:   f16tof32 $a0, $a0
; CHECK-DAG:   f16tof32 $a1, $a1
; CHECK-NEXT:  f32cmpgt [[REGA:\$a[0-9]+]], $a0, $a1
; CHECK-NEXT:  mov $m0, [[REGA]]
; CHECK:       br $m10
define i1 @fcmp_ogt_f16(half %lhs, half %rhs) {
  %retval = fcmp ogt half %lhs, %rhs
  ret i1 %retval
}

; CHECK-LABEL: constrained_fcmps_ogt_f16:
; CHECK:       # %bb.0:
; CHECK-DAG:   f16tof32 $a0, $a0
; CHECK-DAG:   f16tof32 $a1, $a1
; CHECK-NEXT:  f32cmpgt [[REGA:\$a[0-9]+]], $a0, $a1
; CHECK-NEXT:  mov $m0, [[REGA]]
; CHECK:       br $m10
define i1 @constrained_fcmps_ogt_f16(half %lhs, half %rhs) {
  %retval = tail call i1 @llvm.experimental.constrained.fcmps.f16(half %lhs, half %rhs, metadata !"ogt", metadata !"fpexcept.strict")
  ret i1 %retval
}

; CHECK-LABEL: fcmp_oge_f16:
; CHECK:       # %bb.0:
; CHECK-DAG:   f16tof32 $a0, $a0
; CHECK-DAG:   f16tof32 $a1, $a1
; CHECK-NEXT:  f32cmpge [[REGA:\$a[0-9]+]], $a0, $a1
; CHECK-NEXT:  mov $m0, [[REGA]]
; CHECK:       br $m10
define i1 @fcmp_oge_f16(half %lhs, half %rhs) {
  %retval = fcmp oge half %lhs, %rhs
  ret i1 %retval
}

; CHECK-LABEL: constrained_fcmps_oge_f16:
; CHECK:       # %bb.0:
; CHECK-DAG:   f16tof32 $a0, $a0
; CHECK-DAG:   f16tof32 $a1, $a1
; CHECK-NEXT:  f32cmpge [[REGA:\$a[0-9]+]], $a0, $a1
; CHECK-NEXT:  mov $m0, [[REGA]]
; CHECK:       br $m10
define i1 @constrained_fcmps_oge_f16(half %lhs, half %rhs) {
  %retval = tail call i1 @llvm.experimental.constrained.fcmps.f16(half %lhs, half %rhs, metadata !"oge", metadata !"fpexcept.strict")
  ret i1 %retval
}

; CHECK-LABEL: fcmp_olt_f16:
; CHECK:       # %bb.0:
; CHECK-DAG:   f16tof32 $a0, $a0
; CHECK-DAG:   f16tof32 $a1, $a1
; CHECK-NEXT:  f32cmplt [[REGA:\$a[0-9]+]], $a0, $a1
; CHECK-NEXT:  mov $m0, [[REGA]]
; CHECK:       br $m10
define i1 @fcmp_olt_f16(half %lhs, half %rhs) {
  %retval = fcmp olt half %lhs, %rhs
  ret i1 %retval
}

; CHECK-LABEL: constrained_fcmps_olt_f16:
; CHECK:       # %bb.0:
; CHECK-DAG:   f16tof32 $a0, $a0
; CHECK-DAG:   f16tof32 $a1, $a1
; CHECK-NEXT:  f32cmplt [[REGA:\$a[0-9]+]], $a0, $a1
; CHECK-NEXT:  mov $m0, [[REGA]]
; CHECK:       br $m10
define i1 @constrained_fcmps_olt_f16(half %lhs, half %rhs) {
  %retval = tail call i1 @llvm.experimental.constrained.fcmps.f16(half %lhs, half %rhs, metadata !"olt", metadata !"fpexcept.strict")
  ret i1 %retval
}

; CHECK-LABEL: fcmp_ole_f16:
; CHECK:       # %bb.0:
; CHECK-DAG:   f16tof32 $a0, $a0
; CHECK-DAG:   f16tof32 $a1, $a1
; CHECK-NEXT:  f32cmple [[REGA:\$a[0-9]+]], $a0, $a1
; CHECK-NEXT:  mov $m0, [[REGA]]
; CHECK:       br $m10
define i1 @fcmp_ole_f16(half %lhs, half %rhs) {
  %retval = fcmp ole half %lhs, %rhs
  ret i1 %retval
}

; CHECK-LABEL: constrained_fcmps_ole_f16:
; CHECK:       # %bb.0:
; CHECK-DAG:   f16tof32 $a0, $a0
; CHECK-DAG:   f16tof32 $a1, $a1
; CHECK-NEXT:  f32cmple [[REGA:\$a[0-9]+]], $a0, $a1
; CHECK-NEXT:  mov $m0, [[REGA]]
; CHECK:       br $m10
define i1 @constrained_fcmps_ole_f16(half %lhs, half %rhs) {
  %retval = tail call i1 @llvm.experimental.constrained.fcmps.f16(half %lhs, half %rhs, metadata !"ole", metadata !"fpexcept.strict")
  ret i1 %retval
}

; CHECK-LABEL: fcmp_one_f16:
; CHECK:       # %bb.0:
; CHECK-DAG:   f16tof32 $a0, $a0
; CHECK-DAG:   f16tof32 $a1, $a1
; CHECK-NEXT:  f32cmpgt [[REGA:\$a[0-9]+]], $a0, $a1
; CHECK-NEXT:  f32cmplt [[REGB:\$a[0-9]+]], $a0, $a1
; CHECK-NEXT:  or [[REGC:\$a[0-9]+]], [[REGB]], [[REGA]]
; CHECK-NEXT:  mov $m0, [[REGC]]
; CHECK:       br $m10
define i1 @fcmp_one_f16(half %lhs, half %rhs) {
  %retval = fcmp one half %lhs, %rhs
  ret i1 %retval
}

; CHECK-LABEL: constrained_fcmps_one_f16:
; CHECK:       # %bb.0:
; CHECK-DAG:   f16tof32 $a0, $a0
; CHECK-DAG:   f16tof32 $a1, $a1
; CHECK-NEXT:  f32cmpgt [[REGA:\$a[0-9]+]], $a0, $a1
; CHECK-NEXT:  f32cmplt [[REGB:\$a[0-9]+]], $a0, $a1
; CHECK-NEXT:  or [[REGC:\$a[0-9]+]], [[REGB]], [[REGA]]
; CHECK-NEXT:  mov $m0, [[REGC]]
; CHECK:       br $m10
define i1 @constrained_fcmps_one_f16(half %lhs, half %rhs) {
  %retval = tail call i1 @llvm.experimental.constrained.fcmps.f16(half %lhs, half %rhs, metadata !"one", metadata !"fpexcept.strict")
  ret i1 %retval
}

; CHECK-LABEL: fcmp_ord_f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f16tof32 $a1, $a1
; CHECK-NEXT:  f32cmpeq $a1, $a1, $a1
; CHECK-NEXT:  f16tof32 $a0, $a0
; CHECK-NEXT:  f32cmpeq $a0, $a0, $a0
; CHECK-NEXT:  and $a0, $a0, $a1
; CHECK-NEXT:  mov $m0, $a0
; CHECK:       br $m10
define i1 @fcmp_ord_f16(half %lhs, half %rhs) {
  %retval = fcmp ord half %lhs, %rhs
  ret i1 %retval
}

; CHECK-LABEL: constrained_fcmps_ord_f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f16tof32 $a0, $a0
; CHECK-NEXT:  f16tof32 $a1, $a1
; CHECK-NEXT:  f32cmpeq $a1, $a1, $a1
; CHECK-NEXT:  f32cmpeq $a0, $a0, $a0
; CHECK-NEXT:  and $a0, $a0, $a1
; CHECK-NEXT:  mov $m0, $a0
; CHECK:       br $m10
define i1 @constrained_fcmps_ord_f16(half %lhs, half %rhs) {
  %retval = tail call i1 @llvm.experimental.constrained.fcmps.f16(half %lhs, half %rhs, metadata !"ord", metadata !"fpexcept.strict")
  ret i1 %retval
}

; CHECK-LABEL: fcmp_ueq_f16:
; CHECK:       # %bb.0:
; CHECK-DAG:   f16tof32 $a0, $a0
; CHECK-DAG:   f16tof32 $a1, $a1
; CHECK-NEXT:  f32cmpgt [[REGA:\$a[0-9]+]], $a0, $a1
; CHECK-NEXT:  f32cmplt [[REGB:\$a[0-9]+]], $a0, $a1
; CHECK-NEXT:  or [[REGC:\$a[0-9]+]], [[REGB]], [[REGA]]
; CHECK-NEXT:  not [[REGD:\$a[0-9]+]], [[REGC]]
; CHECK-NEXT:  mov $m0, [[REGD]]
; CHECK:       br $m10
define i1 @fcmp_ueq_f16(half %lhs, half %rhs) {
  %retval = fcmp ueq half %lhs, %rhs
  ret i1 %retval
}

; CHECK-LABEL: constrained_fcmps_ueq_f16:
; CHECK:       # %bb.0:
; CHECK-DAG:   f16tof32 $a0, $a0
; CHECK-DAG:   f16tof32 $a1, $a1
; CHECK-NEXT:  f32cmpgt [[REGA:\$a[0-9]+]], $a0, $a1
; CHECK-NEXT:  f32cmplt [[REGB:\$a[0-9]+]], $a0, $a1
; CHECK-NEXT:  or [[REGC:\$a[0-9]+]], [[REGB]], [[REGA]]
; CHECK-NEXT:  not [[REGD:\$a[0-9]+]], [[REGC]]
; CHECK-NEXT:  mov $m0, [[REGD]]
; CHECK:       br $m10
define i1 @constrained_fcmps_ueq_f16(half %lhs, half %rhs) {
  %retval = tail call i1 @llvm.experimental.constrained.fcmps.f16(half %lhs, half %rhs, metadata !"ueq", metadata !"fpexcept.strict")
  ret i1 %retval
}

; CHECK-LABEL: fcmp_ugt_f16:
; CHECK:       # %bb.0:
; CHECK-DAG:   f16tof32 $a0, $a0
; CHECK-DAG:   f16tof32 $a1, $a1
; CHECK-NEXT:  f32cmple [[REGA:\$a[0-9]+]], $a0, $a1
; CHECK-NEXT:  not [[REGB:\$a[0-9]+]], [[REGA]]
; CHECK-NEXT:  mov $m0, [[REGB]]
; CHECK:       br $m10
define i1 @fcmp_ugt_f16(half %lhs, half %rhs) {
  %retval = fcmp ugt half %lhs, %rhs
  ret i1 %retval
}

; CHECK-LABEL: constrained_fcmps_ugt_f16:
; CHECK:       # %bb.0:
; CHECK-DAG:   f16tof32 $a0, $a0
; CHECK-DAG:   f16tof32 $a1, $a1
; CHECK-NEXT:  f32cmple [[REGA:\$a[0-9]+]], $a0, $a1
; CHECK-NEXT:  not [[REGB:\$a[0-9]+]], [[REGA]]
; CHECK-NEXT:  mov $m0, [[REGB]]
; CHECK:       br $m10
define i1 @constrained_fcmps_ugt_f16(half %lhs, half %rhs) {
  %retval = tail call i1 @llvm.experimental.constrained.fcmps.f16(half %lhs, half %rhs, metadata !"ugt", metadata !"fpexcept.strict")
  ret i1 %retval
}

; CHECK-LABEL: fcmp_uge_f16:
; CHECK:       # %bb.0:
; CHECK-DAG:   f16tof32 $a0, $a0
; CHECK-DAG:   f16tof32 $a1, $a1
; CHECK-NEXT:  f32cmplt [[REGA:\$a[0-9]+]], $a0, $a1
; CHECK-NEXT:  not [[REGB:\$a[0-9]+]], [[REGA]]
; CHECK-NEXT:  mov $m0, [[REGB]]
; CHECK:       br $m10
define i1 @fcmp_uge_f16(half %lhs, half %rhs) {
  %retval = fcmp uge half %lhs, %rhs
  ret i1 %retval
}

; CHECK-LABEL: constrained_fcmps_uge_f16:
; CHECK:       # %bb.0:
; CHECK-DAG:   f16tof32 $a0, $a0
; CHECK-DAG:   f16tof32 $a1, $a1
; CHECK-NEXT:  f32cmplt [[REGA:\$a[0-9]+]], $a0, $a1
; CHECK-NEXT:  not [[REGB:\$a[0-9]+]], [[REGA]]
; CHECK-NEXT:  mov $m0, [[REGB]]
; CHECK:       br $m10
define i1 @constrained_fcmps_uge_f16(half %lhs, half %rhs) {
  %retval = tail call i1 @llvm.experimental.constrained.fcmps.f16(half %lhs, half %rhs, metadata !"uge", metadata !"fpexcept.strict")
  ret i1 %retval
}

; CHECK-LABEL: fcmp_ult_f16:
; CHECK:       # %bb.0:
; CHECK-DAG:   f16tof32 $a0, $a0
; CHECK-DAG:   f16tof32 $a1, $a1
; CHECK-NEXT:  f32cmpge [[REGA:\$a[0-9]+]], $a0, $a1
; CHECK-NEXT:  not [[REGB:\$a[0-9]+]], [[REGA]]
; CHECK-NEXT:  mov $m0, [[REGB]]
; CHECK:       br $m10
define i1 @fcmp_ult_f16(half %lhs, half %rhs) {
  %retval = fcmp ult half %lhs, %rhs
  ret i1 %retval
}

; CHECK-LABEL: constrained_fcmps_ult_f16:
; CHECK:       # %bb.0:
; CHECK-DAG:   f16tof32 $a0, $a0
; CHECK-DAG:   f16tof32 $a1, $a1
; CHECK-NEXT:  f32cmpge [[REGA:\$a[0-9]+]], $a0, $a1
; CHECK-NEXT:  not [[REGB:\$a[0-9]+]], [[REGA]]
; CHECK-NEXT:  mov $m0, [[REGB]]
; CHECK:       br $m10
define i1 @constrained_fcmps_ult_f16(half %lhs, half %rhs) {
  %retval = tail call i1 @llvm.experimental.constrained.fcmps.f16(half %lhs, half %rhs, metadata !"ult", metadata !"fpexcept.strict")
  ret i1 %retval
}

; CHECK-LABEL: fcmp_ule_f16:
; CHECK:       # %bb.0:
; CHECK-DAG:   f16tof32 $a0, $a0
; CHECK-DAG:   f16tof32 $a1, $a1
; CHECK-NEXT:  f32cmpgt [[REGA:\$a[0-9]+]], $a0, $a1
; CHECK-NEXT:  not [[REGB:\$a[0-9]+]], [[REGA]]
; CHECK-NEXT:  mov $m0, [[REGB]]
; CHECK:       br $m10
define i1 @fcmp_ule_f16(half %lhs, half %rhs) {
  %retval = fcmp ule half %lhs, %rhs
  ret i1 %retval
}

; CHECK-LABEL: constrained_fcmps_ule_f16:
; CHECK:       # %bb.0:
; CHECK-DAG:   f16tof32 $a0, $a0
; CHECK-DAG:   f16tof32 $a1, $a1
; CHECK-NEXT:  f32cmpgt [[REGA:\$a[0-9]+]], $a0, $a1
; CHECK-NEXT:  not [[REGB:\$a[0-9]+]], [[REGA]]
; CHECK-NEXT:  mov $m0, [[REGB]]
; CHECK:       br $m10
define i1 @constrained_fcmps_ule_f16(half %lhs, half %rhs) {
  %retval = tail call i1 @llvm.experimental.constrained.fcmps.f16(half %lhs, half %rhs, metadata !"ule", metadata !"fpexcept.strict")
  ret i1 %retval
}

; CHECK-LABEL: fcmp_une_f16:
; CHECK:       # %bb.0:
; CHECK-DAG:   f16tof32 $a0, $a0
; CHECK-DAG:   f16tof32 $a1, $a1
; CHECK-NEXT:  f32cmpne [[REG:\$a[0-9]+]], $a0, $a1
; CHECK-NEXT:  mov $m0, [[REG]]
; CHECK:       br $m10
define i1 @fcmp_une_f16(half %lhs, half %rhs) {
  %retval = fcmp une half %lhs, %rhs
  ret i1 %retval
}

; CHECK-LABEL: constrained_fcmps_une_f16:
; CHECK:       # %bb.0:
; CHECK-DAG:   f16tof32 $a0, $a0
; CHECK-DAG:   f16tof32 $a1, $a1
; CHECK-NEXT:  f32cmpne [[REG:\$a[0-9]+]], $a0, $a1
; CHECK-NEXT:  mov $m0, [[REG]]
; CHECK:       br $m10
define i1 @constrained_fcmps_une_f16(half %lhs, half %rhs) {
  %retval = tail call i1 @llvm.experimental.constrained.fcmps.f16(half %lhs, half %rhs, metadata !"une", metadata !"fpexcept.strict")
  ret i1 %retval
}

; CHECK-LABEL: fcmp_uno_f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f16tof32 $a1, $a1
; CHECK-NEXT:  f32cmpne $a1, $a1, $a1
; CHECK-NEXT:  f16tof32 $a0, $a0
; CHECK-NEXT:  f32cmpne $a0, $a0, $a0
; CHECK-NEXT:  or $a0, $a0, $a1
; CHECK-NEXT:  mov $m0, $a0
; CHECK:       br $m10
define i1 @fcmp_uno_f16(half %lhs, half %rhs) {
  %retval = fcmp uno half %lhs, %rhs
  ret i1 %retval
}

; CHECK-LABEL: constrained_fcmps_uno_f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f16tof32 $a0, $a0
; CHECK-NEXT:  f16tof32 $a1, $a1
; CHECK-NEXT:  f32cmpne $a1, $a1, $a1
; CHECK-NEXT:  f32cmpne $a0, $a0, $a0
; CHECK-NEXT:  or $a0, $a0, $a1
; CHECK-NEXT:  mov $m0, $a0
; CHECK:       br $m10
define i1 @constrained_fcmps_uno_f16(half %lhs, half %rhs) {
  %retval = tail call i1 @llvm.experimental.constrained.fcmps.f16(half %lhs, half %rhs, metadata !"uno", metadata !"fpexcept.strict")
  ret i1 %retval
}

; CHECK-LABEL: fcmp_true_f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  setzi $m0, 1
; CHECK:       br $m10
define i1 @fcmp_true_f16(half %lhs, half %rhs) {
  %retval = fcmp true half %lhs, %rhs
  ret i1 %retval
}
