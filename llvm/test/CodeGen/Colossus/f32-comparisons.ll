; RUN: llc < %s -march=colossus -colossus-coissue=false -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -march=colossus -colossus-coissue=false -mattr=+ipu2 | FileCheck %s

; RUN: llc < %s -march=colossus -colossus-coissue=false -enable-no-infs-fp-math | FileCheck %s
; RUN: llc < %s -march=colossus -colossus-coissue=false -enable-no-signed-zeros-fp-math | FileCheck %s
target triple = "colossus-graphcore--elf"

declare i1 @llvm.experimental.constrained.fcmps.f32(float, float, metadata, metadata)

; CHECK-LABEL: fcmp_false_f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m15
; CHECK:       br $m10
define i1 @fcmp_false_f32(float %lhs, float %rhs) {
  %retval = fcmp false float %lhs, %rhs
  ret i1 %retval
}

; CHECK-LABEL: fcmp_oeq_f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f32cmpeq [[REGA:\$a[0-9]+]], $a0, $a1
; CHECK-NEXT:  mov $m0, [[REGA]]
; CHECK:       br $m10
define i1 @fcmp_oeq_f32(float %lhs, float %rhs) {
  %retval = fcmp oeq float %lhs, %rhs
  ret i1 %retval
}

; CHECK-LABEL: constrained_fcmps_oeq_f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f32cmpeq [[REGA:\$a[0-9]+]], $a0, $a1
; CHECK-NEXT:  mov $m0, [[REGA]]
; CHECK:       br $m10
define i1 @constrained_fcmps_oeq_f32(float %lhs, float %rhs) {
  %retval = tail call i1 @llvm.experimental.constrained.fcmps.f32(float %lhs, float %rhs, metadata !"oeq", metadata !"fpexcept.strict")
  ret i1 %retval
}

; CHECK-LABEL: fcmp_ogt_f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f32cmpgt [[REGA:\$a[0-9]+]], $a0, $a1
; CHECK-NEXT:  mov $m0, [[REGA]]
; CHECK:       br $m10
define i1 @fcmp_ogt_f32(float %lhs, float %rhs) {
  %retval = fcmp ogt float %lhs, %rhs
  ret i1 %retval
}

; CHECK-LABEL: constrained_fcmps_ogt_f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f32cmpgt [[REGA:\$a[0-9]+]], $a0, $a1
; CHECK-NEXT:  mov $m0, [[REGA]]
; CHECK:       br $m10
define i1 @constrained_fcmps_ogt_f32(float %lhs, float %rhs) {
  %retval = tail call i1 @llvm.experimental.constrained.fcmps.f32(float %lhs, float %rhs, metadata !"ogt", metadata !"fpexcept.strict")
  ret i1 %retval
}

; CHECK-LABEL: fcmp_oge_f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f32cmpge [[REGA:\$a[0-9]+]], $a0, $a1
; CHECK-NEXT:  mov $m0, [[REGA]]
; CHECK:       br $m10
define i1 @fcmp_oge_f32(float %lhs, float %rhs) {
  %retval = fcmp oge float %lhs, %rhs
  ret i1 %retval
}

; CHECK-LABEL: constrained_fcmps_oge_f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f32cmpge [[REGA:\$a[0-9]+]], $a0, $a1
; CHECK-NEXT:  mov $m0, [[REGA]]
; CHECK:       br $m10
define i1 @constrained_fcmps_oge_f32(float %lhs, float %rhs) {
  %retval = tail call i1 @llvm.experimental.constrained.fcmps.f32(float %lhs, float %rhs, metadata !"oge", metadata !"fpexcept.strict")
  ret i1 %retval
}

; CHECK-LABEL: fcmp_olt_f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f32cmplt [[REGA:\$a[0-9]+]], $a0, $a1
; CHECK-NEXT:  mov $m0, [[REGA]]
; CHECK:       br $m10
define i1 @fcmp_olt_f32(float %lhs, float %rhs) {
  %retval = fcmp olt float %lhs, %rhs
  ret i1 %retval
}

; CHECK-LABEL: constrained_fcmps_olt_f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f32cmplt [[REGA:\$a[0-9]+]], $a0, $a1
; CHECK-NEXT:  mov $m0, [[REGA]]
; CHECK:       br $m10
define i1 @constrained_fcmps_olt_f32(float %lhs, float %rhs) {
  %retval = tail call i1 @llvm.experimental.constrained.fcmps.f32(float %lhs, float %rhs, metadata !"olt", metadata !"fpexcept.strict")
  ret i1 %retval
}

; CHECK-LABEL: fcmp_ole_f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f32cmple [[REGA:\$a[0-9]+]], $a0, $a1
; CHECK-NEXT:  mov $m0, [[REGA]]
; CHECK:       br $m10
define i1 @fcmp_ole_f32(float %lhs, float %rhs) {
  %retval = fcmp ole float %lhs, %rhs
  ret i1 %retval
}

; CHECK-LABEL: constrained_fcmps_ole_f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f32cmple [[REGA:\$a[0-9]+]], $a0, $a1
; CHECK-NEXT:  mov $m0, [[REGA]]
; CHECK:       br $m10
define i1 @constrained_fcmps_ole_f32(float %lhs, float %rhs) {
  %retval = tail call i1 @llvm.experimental.constrained.fcmps.f32(float %lhs, float %rhs, metadata !"ole", metadata !"fpexcept.strict")
  ret i1 %retval
}

; CHECK-LABEL: fcmp_one_f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f32cmpgt [[REGA:\$a[0-9]+]], $a0, $a1
; CHECK-NEXT:  f32cmplt [[REGB:\$a[0-9]+]], $a0, $a1
; CHECK-NEXT:  or [[REGC:\$a[0-9]+]], [[REGB]], [[REGA]]
; CHECK-NEXT:  mov $m0, [[REGC]]
; CHECK:       br $m10
define i1 @fcmp_one_f32(float %lhs, float %rhs) {
  %retval = fcmp one float %lhs, %rhs
  ret i1 %retval
}

; CHECK-LABEL: constrained_fcmps_one_f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f32cmpgt [[REGA:\$a[0-9]+]], $a0, $a1
; CHECK-NEXT:  f32cmplt [[REGB:\$a[0-9]+]], $a0, $a1
; CHECK-NEXT:  or [[REGC:\$a[0-9]+]], [[REGB]], [[REGA]]
; CHECK-NEXT:  mov $m0, [[REGC]]
; CHECK:       br $m10
define i1 @constrained_fcmps_one_f32(float %lhs, float %rhs) {
  %retval = tail call i1 @llvm.experimental.constrained.fcmps.f32(float %lhs, float %rhs, metadata !"one", metadata !"fpexcept.strict")
  ret i1 %retval
}

; CHECK-LABEL: fcmp_ord_f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f32cmpeq $a1, $a1, $a1
; CHECK-NEXT:  f32cmpeq $a0, $a0, $a0
; CHECK-NEXT:  and $a0, $a0, $a1
; CHECK-NEXT:  mov $m0, $a0
; CHECK:       br $m10
define i1 @fcmp_ord_f32(float %lhs, float %rhs) {
  %retval = fcmp ord float %lhs, %rhs
  ret i1 %retval
}

; CHECK-LABEL: constrained_fcmps_ord_f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f32cmpeq $a1, $a1, $a1
; CHECK-NEXT:  f32cmpeq $a0, $a0, $a0
; CHECK-NEXT:  and $a0, $a0, $a1
; CHECK-NEXT:  mov $m0, $a0
; CHECK:       br $m10
define i1 @constrained_fcmps_ord_f32(float %lhs, float %rhs) {
  %retval = tail call i1 @llvm.experimental.constrained.fcmps.f32(float %lhs, float %rhs, metadata !"ord", metadata !"fpexcept.strict")
  ret i1 %retval
}

; CHECK-LABEL: fcmp_ueq_f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f32cmpgt [[REGA:\$a[0-9]+]], $a0, $a1
; CHECK-NEXT:  f32cmplt [[REGB:\$a[0-9]+]], $a0, $a1
; CHECK-NEXT:  or [[REGC:\$a[0-9]+]], [[REGB]], [[REGA]]
; CHECK-NEXT:  not [[REGD:\$a[0-9]+]], [[REGC]]
; CHECK-NEXT:  mov $m0, [[REGD]]
; CHECK:       br $m10
define i1 @fcmp_ueq_f32(float %lhs, float %rhs) {
  %retval = fcmp ueq float %lhs, %rhs
  ret i1 %retval
}

; CHECK-LABEL: constrained_fcmps_ueq_f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f32cmpgt [[REGA:\$a[0-9]+]], $a0, $a1
; CHECK-NEXT:  f32cmplt [[REGB:\$a[0-9]+]], $a0, $a1
; CHECK-NEXT:  or [[REGC:\$a[0-9]+]], [[REGB]], [[REGA]]
; CHECK-NEXT:  not [[REGD:\$a[0-9]+]], [[REGC]]
; CHECK-NEXT:  mov $m0, [[REGD]]
; CHECK:       br $m10
define i1 @constrained_fcmps_ueq_f32(float %lhs, float %rhs) {
  %retval = tail call i1 @llvm.experimental.constrained.fcmps.f32(float %lhs, float %rhs, metadata !"ueq", metadata !"fpexcept.strict")
  ret i1 %retval
}

; CHECK-LABEL: fcmp_ugt_f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f32cmple [[REGA:\$a[0-9]+]], $a0, $a1
; CHECK-NEXT:  not [[REGB:\$a[0-9]+]], [[REGA]]
; CHECK-NEXT:  mov $m0, [[REGB]]
; CHECK:       br $m10
define i1 @fcmp_ugt_f32(float %lhs, float %rhs) {
  %retval = fcmp ugt float %lhs, %rhs
  ret i1 %retval
}

; CHECK-LABEL: constrained_fcmps_ugt_f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f32cmple [[REGA:\$a[0-9]+]], $a0, $a1
; CHECK-NEXT:  not [[REGB:\$a[0-9]+]], [[REGA]]
; CHECK-NEXT:  mov $m0, [[REGB]]
; CHECK:       br $m10
define i1 @constrained_fcmps_ugt_f32(float %lhs, float %rhs) {
  %retval = tail call i1 @llvm.experimental.constrained.fcmps.f32(float %lhs, float %rhs, metadata !"ugt", metadata !"fpexcept.strict")
  ret i1 %retval
}

; CHECK-LABEL: fcmp_uge_f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f32cmplt [[REGA:\$a[0-9]+]], $a0, $a1
; CHECK-NEXT:  not [[REGB:\$a[0-9]+]], [[REGA]]
; CHECK-NEXT:  mov $m0, [[REGB]]
; CHECK:       br $m10
define i1 @fcmp_uge_f32(float %lhs, float %rhs) {
  %retval = fcmp uge float %lhs, %rhs
  ret i1 %retval
}

; CHECK-LABEL: constrained_fcmps_uge_f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f32cmplt [[REGA:\$a[0-9]+]], $a0, $a1
; CHECK-NEXT:  not [[REGB:\$a[0-9]+]], [[REGA]]
; CHECK-NEXT:  mov $m0, [[REGB]]
; CHECK:       br $m10
define i1 @constrained_fcmps_uge_f32(float %lhs, float %rhs) {
  %retval = tail call i1 @llvm.experimental.constrained.fcmps.f32(float %lhs, float %rhs, metadata !"uge", metadata !"fpexcept.strict")
  ret i1 %retval
}

; CHECK-LABEL: fcmp_ult_f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f32cmpge [[REGA:\$a[0-9]+]], $a0, $a1
; CHECK-NEXT:  not [[REGB:\$a[0-9]+]], [[REGA]]
; CHECK-NEXT:  mov $m0, [[REGB]]
; CHECK:       br $m10
define i1 @fcmp_ult_f32(float %lhs, float %rhs) {
  %retval = fcmp ult float %lhs, %rhs
  ret i1 %retval
}

; CHECK-LABEL: constrained_fcmps_ult_f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f32cmpge [[REGA:\$a[0-9]+]], $a0, $a1
; CHECK-NEXT:  not [[REGB:\$a[0-9]+]], [[REGA]]
; CHECK-NEXT:  mov $m0, [[REGB]]
; CHECK:       br $m10
define i1 @constrained_fcmps_ult_f32(float %lhs, float %rhs) {
  %retval = tail call i1 @llvm.experimental.constrained.fcmps.f32(float %lhs, float %rhs, metadata !"ult", metadata !"fpexcept.strict")
  ret i1 %retval
}

; CHECK-LABEL: fcmp_ule_f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f32cmpgt [[REGA:\$a[0-9]+]], $a0, $a1
; CHECK-NEXT:  not [[REGB:\$a[0-9]+]], [[REGA]]
; CHECK-NEXT:  mov $m0, [[REGB]]
; CHECK:       br $m10
define i1 @fcmp_ule_f32(float %lhs, float %rhs) {
  %retval = fcmp ule float %lhs, %rhs
  ret i1 %retval
}

; CHECK-LABEL: constrained_fcmps_ule_f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f32cmpgt [[REGA:\$a[0-9]+]], $a0, $a1
; CHECK-NEXT:  not [[REGB:\$a[0-9]+]], [[REGA]]
; CHECK-NEXT:  mov $m0, [[REGB]]
; CHECK:       br $m10
define i1 @constrained_fcmps_ule_f32(float %lhs, float %rhs) {
  %retval = tail call i1 @llvm.experimental.constrained.fcmps.f32(float %lhs, float %rhs, metadata !"ule", metadata !"fpexcept.strict")
  ret i1 %retval
}

; CHECK-LABEL: fcmp_une_f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f32cmpne [[REG:\$a[0-9]+]], $a0, $a1
; CHECK-NEXT:  mov $m0, [[REG]]
; CHECK:       br $m10
define i1 @fcmp_une_f32(float %lhs, float %rhs) {
  %retval = fcmp une float %lhs, %rhs
  ret i1 %retval
}

; CHECK-LABEL: constrained_fcmps_une_f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f32cmpne [[REG:\$a[0-9]+]], $a0, $a1
; CHECK-NEXT:  mov $m0, [[REG]]
; CHECK:       br $m10
define i1 @constrained_fcmps_une_f32(float %lhs, float %rhs) {
  %retval = tail call i1 @llvm.experimental.constrained.fcmps.f32(float %lhs, float %rhs, metadata !"une", metadata !"fpexcept.strict")
  ret i1 %retval
}

; CHECK-LABEL: fcmp_uno_f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f32cmpne $a1, $a1, $a1
; CHECK-NEXT:  f32cmpne $a0, $a0, $a0
; CHECK-NEXT:  or $a0, $a0, $a1
; CHECK-NEXT:  mov $m0, $a0
; CHECK:       br $m10
define i1 @fcmp_uno_f32(float %lhs, float %rhs) {
  %retval = fcmp uno float %lhs, %rhs
  ret i1 %retval
}

; CHECK-LABEL: constrained_fcmps_uno_f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f32cmpne $a1, $a1, $a1
; CHECK-NEXT:  f32cmpne $a0, $a0, $a0
; CHECK-NEXT:  or $a0, $a0, $a1
; CHECK-NEXT:  mov $m0, $a0
; CHECK:       br $m10
define i1 @constrained_fcmps_uno_f32(float %lhs, float %rhs) {
  %retval = tail call i1 @llvm.experimental.constrained.fcmps.f32(float %lhs, float %rhs, metadata !"uno", metadata !"fpexcept.strict")
  ret i1 %retval
}

; CHECK-LABEL: fcmp_true_f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  setzi $m0, 1
; CHECK:       br $m10
define i1 @fcmp_true_f32(float %lhs, float %rhs) {
  %retval = fcmp true float %lhs, %rhs
  ret i1 %retval
}
