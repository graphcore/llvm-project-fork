; RUN: llc < %s -march=colossus -mattr=+supervisor -colossus-coissue=false -enable-no-nans-fp-math | FileCheck %s
target triple = "colossus-graphcore--elf"

declare i1 @llvm.experimental.constrained.fcmps.f32(float, float, metadata, metadata)

; CHECK-LABEL: fcmp_no_nans_false_f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m15
; CHECK-NEXT:  br $m10
define i1 @fcmp_no_nans_false_f32(float %lhs, float %rhs) {
  %retval = fcmp false float %lhs, %rhs
  ret i1 %retval
}

; CHECK-LABEL: fcmp_no_nans_oeq_f32:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m10, $m11, $m15, 1        # 4-byte Folded Spill
; CHECK-NEXT:  call $m10, __eqsf2
; CHECK-NEXT:  cmpeq $m0, $m0, 0
; CHECK-NEXT:  ld32 $m10, $m11, $m15, 1        # 4-byte Folded Reload
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10
define i1 @fcmp_no_nans_oeq_f32(float %lhs, float %rhs) {
  %retval = fcmp oeq float %lhs, %rhs
  ret i1 %retval
}

; CHECK-LABEL: constrained_fcmps_no_nans_oeq_f32:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m10, $m11, $m15, 1        # 4-byte Folded Spill
; CHECK-NEXT:  call $m10, __eqsf2
; CHECK-NEXT:  cmpeq $m0, $m0, 0
; CHECK-NEXT:  ld32 $m10, $m11, $m15, 1        # 4-byte Folded Reload
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10
define i1 @constrained_fcmps_no_nans_oeq_f32(float %lhs, float %rhs) {
  %retval = tail call i1 @llvm.experimental.constrained.fcmps.f32(float %lhs, float %rhs, metadata !"oeq", metadata !"fpexcept.strict")
  ret i1 %retval
}

; CHECK-LABEL: fcmp_no_nans_ogt_f32:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m10, $m11, $m15, 1        # 4-byte Folded Spill
; CHECK-NEXT:  call $m10, __gtsf2
; CHECK-NEXT:  cmpslt $m0, $m15, $m0
; CHECK-NEXT:  ld32 $m10, $m11, $m15, 1        # 4-byte Folded Reload
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10
define i1 @fcmp_no_nans_ogt_f32(float %lhs, float %rhs) {
  %retval = fcmp ogt float %lhs, %rhs
  ret i1 %retval
}

; CHECK-LABEL: constrained_fcmps_no_nans_ogt_f32:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m10, $m11, $m15, 1        # 4-byte Folded Spill
; CHECK-NEXT:  call $m10, __gtsf2
; CHECK-NEXT:  cmpslt $m0, $m15, $m0
; CHECK-NEXT:  ld32 $m10, $m11, $m15, 1        # 4-byte Folded Reload
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10
define i1 @constrained_fcmps_no_nans_ogt_f32(float %lhs, float %rhs) {
  %retval = tail call i1 @llvm.experimental.constrained.fcmps.f32(float %lhs, float %rhs, metadata !"ogt", metadata !"fpexcept.strict")
  ret i1 %retval
}

; CHECK-LABEL: fcmp_no_nans_oge_f32:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m10, $m11, $m15, 1        # 4-byte Folded Spill
; CHECK-NEXT:  call $m10, __gesf2
; CHECK-NEXT:  add $m1, $m15, -1
; CHECK-NEXT:  cmpslt $m0, $m1, $m0
; CHECK-NEXT:  ld32 $m10, $m11, $m15, 1        # 4-byte Folded Reload
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10
define i1 @fcmp_no_nans_oge_f32(float %lhs, float %rhs) {
  %retval = fcmp oge float %lhs, %rhs
  ret i1 %retval
}

; CHECK-LABEL: constrained_fcmps_no_nans_oge_f32:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m10, $m11, $m15, 1        # 4-byte Folded Spill
; CHECK-NEXT:  call $m10, __gesf2
; CHECK-NEXT:  add $m1, $m15, -1
; CHECK-NEXT:  cmpslt $m0, $m1, $m0
; CHECK-NEXT:  ld32 $m10, $m11, $m15, 1        # 4-byte Folded Reload
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10
define i1 @constrained_fcmps_no_nans_oge_f32(float %lhs, float %rhs) {
  %retval = tail call i1 @llvm.experimental.constrained.fcmps.f32(float %lhs, float %rhs, metadata !"oge", metadata !"fpexcept.strict")
  ret i1 %retval
}

; CHECK-LABEL: fcmp_no_nans_olt_f32:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m10, $m11, $m15, 1        # 4-byte Folded Spill
; CHECK-NEXT:  call $m10, __ltsf2
; CHECK-NEXT:  cmpslt $m0, $m0, 0
; CHECK-NEXT:  ld32 $m10, $m11, $m15, 1        # 4-byte Folded Reload
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10
define i1 @fcmp_no_nans_olt_f32(float %lhs, float %rhs) {
  %retval = fcmp olt float %lhs, %rhs
  ret i1 %retval
}

; CHECK-LABEL: constrained_fcmps_no_nans_olt_f32:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m10, $m11, $m15, 1        # 4-byte Folded Spill
; CHECK-NEXT:  call $m10, __ltsf2
; CHECK-NEXT:  cmpslt $m0, $m0, 0
; CHECK-NEXT:  ld32 $m10, $m11, $m15, 1        # 4-byte Folded Reload
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10
define i1 @constrained_fcmps_no_nans_olt_f32(float %lhs, float %rhs) {
  %retval = tail call i1 @llvm.experimental.constrained.fcmps.f32(float %lhs, float %rhs, metadata !"olt", metadata !"fpexcept.strict")
  ret i1 %retval
}

; CHECK-LABEL: fcmp_no_nans_ole_f32:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m10, $m11, $m15, 1        # 4-byte Folded Spill
; CHECK-NEXT:  call $m10, __lesf2
; CHECK-NEXT:  cmpslt $m0, $m0, 1
; CHECK-NEXT:  ld32 $m10, $m11, $m15, 1        # 4-byte Folded Reload
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10
define i1 @fcmp_no_nans_ole_f32(float %lhs, float %rhs) {
  %retval = fcmp ole float %lhs, %rhs
  ret i1 %retval
}

; CHECK-LABEL: constrained_fcmps_no_nans_ole_f32:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m10, $m11, $m15, 1        # 4-byte Folded Spill
; CHECK-NEXT:  call $m10, __lesf2
; CHECK-NEXT:  cmpslt $m0, $m0, 1
; CHECK-NEXT:  ld32 $m10, $m11, $m15, 1        # 4-byte Folded Reload
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10
define i1 @constrained_fcmps_no_nans_ole_f32(float %lhs, float %rhs) {
  %retval = tail call i1 @llvm.experimental.constrained.fcmps.f32(float %lhs, float %rhs, metadata !"ole", metadata !"fpexcept.strict")
  ret i1 %retval
}

; CHECK-LABEL: fcmp_no_nans_one_f32:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m10, $m11, $m15, 1        # 4-byte Folded Spill
; CHECK-NEXT:  call $m10, __nesf2
; CHECK-NEXT:  cmpne $m0, $m0, $m15
; CHECK-NEXT:  ld32 $m10, $m11, $m15, 1        # 4-byte Folded Reload
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10
define i1 @fcmp_no_nans_one_f32(float %lhs, float %rhs) {
  %retval = fcmp one float %lhs, %rhs
  ret i1 %retval
}

; CHECK-LABEL: constrained_fcmps_no_nans_one_f32:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m10, $m11, $m15, 1        # 4-byte Folded Spill
; CHECK-NEXT:  call $m10, __nesf2
; CHECK-NEXT:  cmpne $m0, $m0, $m15
; CHECK-NEXT:  ld32 $m10, $m11, $m15, 1        # 4-byte Folded Reload
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10
define i1 @constrained_fcmps_no_nans_one_f32(float %lhs, float %rhs) {
  %retval = tail call i1 @llvm.experimental.constrained.fcmps.f32(float %lhs, float %rhs, metadata !"one", metadata !"fpexcept.strict")
  ret i1 %retval
}

; CHECK-LABEL: fcmp_no_nans_ord_f32:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m10, $m11, $m15, 1        # 4-byte Folded Spill
; CHECK-NEXT:  call $m10, __unordsf2
; CHECK-NEXT:  cmpeq $m0, $m0, 0
; CHECK-NEXT:  ld32 $m10, $m11, $m15, 1        # 4-byte Folded Reload
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10
define i1 @fcmp_no_nans_ord_f32(float %lhs, float %rhs) {
  %retval = fcmp ord float %lhs, %rhs
  ret i1 %retval
}

; CHECK-LABEL: constrained_fcmps_no_nans_ord_f32:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m10, $m11, $m15, 1        # 4-byte Folded Spill
; CHECK-NEXT:  call $m10, __unordsf2
; CHECK-NEXT:  cmpeq $m0, $m0, 0
; CHECK-NEXT:  ld32 $m10, $m11, $m15, 1        # 4-byte Folded Reload
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10
define i1 @constrained_fcmps_no_nans_ord_f32(float %lhs, float %rhs) {
  %retval = tail call i1 @llvm.experimental.constrained.fcmps.f32(float %lhs, float %rhs, metadata !"ord", metadata !"fpexcept.strict")
  ret i1 %retval
}

; CHECK-LABEL: fcmp_no_nans_ueq_f32:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m10, $m11, $m15, 1        # 4-byte Folded Spill
; CHECK-NEXT:  call $m10, __eqsf2
; CHECK-NEXT:  cmpeq $m0, $m0, 0
; CHECK-NEXT:  ld32 $m10, $m11, $m15, 1        # 4-byte Folded Reload
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10
define i1 @fcmp_no_nans_ueq_f32(float %lhs, float %rhs) {
  %retval = fcmp ueq float %lhs, %rhs
  ret i1 %retval
}

; CHECK-LABEL: constrained_fcmps_no_nans_ueq_f32:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m10, $m11, $m15, 1        # 4-byte Folded Spill
; CHECK-NEXT:  call $m10, __eqsf2
; CHECK-NEXT:  cmpeq $m0, $m0, 0
; CHECK-NEXT:  ld32 $m10, $m11, $m15, 1        # 4-byte Folded Reload
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10
define i1 @constrained_fcmps_no_nans_ueq_f32(float %lhs, float %rhs) {
  %retval = tail call i1 @llvm.experimental.constrained.fcmps.f32(float %lhs, float %rhs, metadata !"ueq", metadata !"fpexcept.strict")
  ret i1 %retval
}

; CHECK-LABEL: fcmp_no_nans_ugt_f32:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m10, $m11, $m15, 1        # 4-byte Folded Spill
; CHECK-NEXT:  call $m10, __gtsf2
; CHECK-NEXT:  cmpslt $m0, $m15, $m0
; CHECK-NEXT:  ld32 $m10, $m11, $m15, 1        # 4-byte Folded Reload
; CHECK-NEXT:  add $m11, $m11, 8
define i1 @fcmp_no_nans_ugt_f32(float %lhs, float %rhs) {
  %retval = fcmp ugt float %lhs, %rhs
  ret i1 %retval
}

; CHECK-LABEL: constrained_fcmps_no_nans_ugt_f32:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m10, $m11, $m15, 1        # 4-byte Folded Spill
; CHECK-NEXT:  call $m10, __gtsf2
; CHECK-NEXT:  cmpslt $m0, $m15, $m0
; CHECK-NEXT:  ld32 $m10, $m11, $m15, 1        # 4-byte Folded Reload
; CHECK-NEXT:  add $m11, $m11, 8
define i1 @constrained_fcmps_no_nans_ugt_f32(float %lhs, float %rhs) {
  %retval = tail call i1 @llvm.experimental.constrained.fcmps.f32(float %lhs, float %rhs, metadata !"ugt", metadata !"fpexcept.strict")
  ret i1 %retval
}

; CHECK-LABEL: fcmp_no_nans_uge_f32:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m10, $m11, $m15, 1        # 4-byte Folded Spill
; CHECK-NEXT:  call $m10, __gesf2
; CHECK-NEXT:  add $m1, $m15, -1
; CHECK-NEXT:  cmpslt $m0, $m1, $m0
; CHECK-NEXT:  ld32 $m10, $m11, $m15, 1        # 4-byte Folded Reload
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10
define i1 @fcmp_no_nans_uge_f32(float %lhs, float %rhs) {
  %retval = fcmp uge float %lhs, %rhs
  ret i1 %retval
}

; CHECK-LABEL: constrained_fcmps_no_nans_uge_f32:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m10, $m11, $m15, 1        # 4-byte Folded Spill
; CHECK-NEXT:  call $m10, __gesf2
; CHECK-NEXT:  add $m1, $m15, -1
; CHECK-NEXT:  cmpslt $m0, $m1, $m0
; CHECK-NEXT:  ld32 $m10, $m11, $m15, 1        # 4-byte Folded Reload
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10
define i1 @constrained_fcmps_no_nans_uge_f32(float %lhs, float %rhs) {
  %retval = tail call i1 @llvm.experimental.constrained.fcmps.f32(float %lhs, float %rhs, metadata !"uge", metadata !"fpexcept.strict")
  ret i1 %retval
}

; CHECK-LABEL: fcmp_no_nans_ult_f32:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m10, $m11, $m15, 1        # 4-byte Folded Spill
; CHECK-NEXT:  call $m10, __ltsf2
; CHECK-NEXT:  cmpslt $m0, $m0, 0
; CHECK-NEXT:  ld32 $m10, $m11, $m15, 1        # 4-byte Folded Reload
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10
define i1 @fcmp_no_nans_ult_f32(float %lhs, float %rhs) {
  %retval = fcmp ult float %lhs, %rhs
  ret i1 %retval
}

; CHECK-LABEL: constrained_fcmps_no_nans_ult_f32:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m10, $m11, $m15, 1        # 4-byte Folded Spill
; CHECK-NEXT:  call $m10, __ltsf2
; CHECK-NEXT:  cmpslt $m0, $m0, 0
; CHECK-NEXT:  ld32 $m10, $m11, $m15, 1        # 4-byte Folded Reload
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10
define i1 @constrained_fcmps_no_nans_ult_f32(float %lhs, float %rhs) {
  %retval = tail call i1 @llvm.experimental.constrained.fcmps.f32(float %lhs, float %rhs, metadata !"ult", metadata !"fpexcept.strict")
  ret i1 %retval
}

; CHECK-LABEL: fcmp_no_nans_ule_f32:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m10, $m11, $m15, 1        # 4-byte Folded Spill
; CHECK-NEXT:  call $m10, __lesf2
; CHECK-NEXT:  cmpslt $m0, $m0, 1
; CHECK-NEXT:  ld32 $m10, $m11, $m15, 1        # 4-byte Folded Reload
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10
define i1 @fcmp_no_nans_ule_f32(float %lhs, float %rhs) {
  %retval = fcmp ule float %lhs, %rhs
  ret i1 %retval
}

; CHECK-LABEL: constrained_fcmps_no_nans_ule_f32:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m10, $m11, $m15, 1        # 4-byte Folded Spill
; CHECK-NEXT:  call $m10, __lesf2
; CHECK-NEXT:  cmpslt $m0, $m0, 1
; CHECK-NEXT:  ld32 $m10, $m11, $m15, 1        # 4-byte Folded Reload
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10
define i1 @constrained_fcmps_no_nans_ule_f32(float %lhs, float %rhs) {
  %retval = tail call i1 @llvm.experimental.constrained.fcmps.f32(float %lhs, float %rhs, metadata !"ule", metadata !"fpexcept.strict")
  ret i1 %retval
}

; CHECK-LABEL: fcmp_no_nans_une_f32:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m10, $m11, $m15, 1        # 4-byte Folded Spill
; CHECK-NEXT:  call $m10, __nesf2
; CHECK-NEXT:  cmpne $m0, $m0, $m15
; CHECK-NEXT:  ld32 $m10, $m11, $m15, 1        # 4-byte Folded Reload
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10
define i1 @fcmp_no_nans_une_f32(float %lhs, float %rhs) {
  %retval = fcmp une float %lhs, %rhs
  ret i1 %retval
}

; CHECK-LABEL: constrained_fcmps_no_nans_une_f32:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m10, $m11, $m15, 1        # 4-byte Folded Spill
; CHECK-NEXT:  call $m10, __nesf2
; CHECK-NEXT:  cmpne $m0, $m0, $m15
; CHECK-NEXT:  ld32 $m10, $m11, $m15, 1        # 4-byte Folded Reload
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10
define i1 @constrained_fcmps_no_nans_une_f32(float %lhs, float %rhs) {
  %retval = tail call i1 @llvm.experimental.constrained.fcmps.f32(float %lhs, float %rhs, metadata !"une", metadata !"fpexcept.strict")
  ret i1 %retval
}

; CHECK-LABEL: fcmp_no_nans_uno_f32:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m10, $m11, $m15, 1        # 4-byte Folded Spill
; CHECK-NEXT:  call $m10, __unordsf2
; CHECK-NEXT:  cmpne $m0, $m0, $m15
; CHECK-NEXT:  ld32 $m10, $m11, $m15, 1        # 4-byte Folded Reload
; CHECK:       add $m11, $m11, 8
; CHECK:       br $m10
define i1 @fcmp_no_nans_uno_f32(float %lhs, float %rhs) {
  %retval = fcmp uno float %lhs, %rhs
  ret i1 %retval
}

; CHECK-LABEL: constrained_fcmps_no_nans_uno_f32:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m10, $m11, $m15, 1        # 4-byte Folded Spill
; CHECK-NEXT:  call $m10, __unordsf2
; CHECK-NEXT:  cmpne $m0, $m0, $m15
; CHECK-NEXT:  ld32 $m10, $m11, $m15, 1        # 4-byte Folded Reload
; CHECK:       add $m11, $m11, 8
; CHECK:       br $m10
define i1 @constrained_fcmps_no_nans_uno_f32(float %lhs, float %rhs) {
  %retval = tail call i1 @llvm.experimental.constrained.fcmps.f32(float %lhs, float %rhs, metadata !"uno", metadata !"fpexcept.strict")
  ret i1 %retval
}

; CHECK-LABEL: fcmp_no_nans_true_f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  setzi $m0, 1
; CHECK:       br $m10
define i1 @fcmp_no_nans_true_f32(float %lhs, float %rhs) {
  %retval = fcmp true float %lhs, %rhs
  ret i1 %retval
}
