; RUN: llc < %s -march=colossus -mattr=\+supervisor,+ipu1 | FileCheck %s
; RUN: llc < %s -march=colossus -mattr=\+supervisor,+ipu2 | FileCheck %s
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

; CHECK-LABEL: fcmp_oeq_f32:                           # @fcmp_oeq_f32
; CHECK:          # %bb.0:
; CHECK:          add $m11, $m11, -8
; CHECK:          st32 $m10, $m11, $m15, 1        # 4-byte Folded Spill
; CHECK-NEXT:     call $m10, __eqsf2
; CHECK-NEXT:     cmpeq $m0, $m0, 0
; CHECK-NEXT:     ld32 $m10, $m11, $m15, 1        # 4-byte Folded Reload
; CHECK-NEXT:     add $m11, $m11, 8
; CHECK:          br $m10
define i1 @fcmp_oeq_f32(float %lhs, float %rhs) {
  %retval = fcmp oeq float %lhs, %rhs
  ret i1 %retval
}

; CHECK-LABEL: constrained_fcmps_oeq_f32:
; CHECK:          # %bb.0:
; CHECK:          add $m11, $m11, -8
; CHECK:          st32 $m10, $m11, $m15, 1        # 4-byte Folded Spill
; CHECK-NEXT:     call $m10, __eqsf2
; CHECK-NEXT:     cmpeq $m0, $m0, 0
; CHECK-NEXT:     ld32 $m10, $m11, $m15, 1        # 4-byte Folded Reload
; CHECK-NEXT:     add $m11, $m11, 8
; CHECK:          br $m10
define i1 @constrained_fcmps_oeq_f32(float %lhs, float %rhs) {
  %retval = tail call i1 @llvm.experimental.constrained.fcmps.f32(float %lhs, float %rhs, metadata !"oeq", metadata !"fpexcept.strict")
  ret i1 %retval
}

; CHECK-LABEL: fcmp_ogt_f32:                           # @fcmp_ogt_f32
; CHECK:          # %bb.0:
; CHECK:          add $m11, $m11, -8
; CHECK:          st32 $m10, $m11, $m15, 1        # 4-byte Folded Spill
; CHECK-NEXT:     call $m10, __gtsf2
; CHECK-NEXT:     cmpslt $m0, $m15, $m0
; CHECK-NEXT:     ld32 $m10, $m11, $m15, 1        # 4-byte Folded Reload
; CHECK-NEXT:     add $m11, $m11, 8
; CHECK:          br $m10
define i1 @fcmp_ogt_f32(float %lhs, float %rhs) {
  %retval = fcmp ogt float %lhs, %rhs
  ret i1 %retval
}

; CHECK-LABEL: constrained_fcmps_ogt_f32:
; CHECK:          # %bb.0:
; CHECK:          add $m11, $m11, -8
; CHECK:          st32 $m10, $m11, $m15, 1        # 4-byte Folded Spill
; CHECK-NEXT:     call $m10, __gtsf2
; CHECK-NEXT:     cmpslt $m0, $m15, $m0
; CHECK-NEXT:     ld32 $m10, $m11, $m15, 1        # 4-byte Folded Reload
; CHECK-NEXT:     add $m11, $m11, 8
; CHECK:          br $m10
define i1 @constrained_fcmps_ogt_f32(float %lhs, float %rhs) {
  %retval = tail call i1 @llvm.experimental.constrained.fcmps.f32(float %lhs, float %rhs, metadata !"ogt", metadata !"fpexcept.strict")
  ret i1 %retval
}

; CHECK-LABEL: fcmp_oge_f32:                           # @fcmp_oge_f32
; CHECK:          # %bb.0:
; CHECK:          add $m11, $m11, -8
; CHECK:          st32 $m10, $m11, $m15, 1        # 4-byte Folded Spill
; CHECK-NEXT:     call $m10, __gesf2
; CHECK-NEXT:     add $m1, $m15, -1
; CHECK-NEXT:     cmpslt $m0, $m1, $m0
; CHECK-NEXT:     ld32 $m10, $m11, $m15, 1        # 4-byte Folded Reload
; CHECK-NEXT:     add $m11, $m11, 8
; CHECK:          br $m10
define i1 @fcmp_oge_f32(float %lhs, float %rhs) {
  %retval = fcmp oge float %lhs, %rhs
  ret i1 %retval
}

; CHECK-LABEL: constrained_fcmps_oge_f32:
; CHECK:          # %bb.0:
; CHECK:          add $m11, $m11, -8
; CHECK:          st32 $m10, $m11, $m15, 1        # 4-byte Folded Spill
; CHECK-NEXT:     call $m10, __gesf2
; CHECK-NEXT:     add $m1, $m15, -1
; CHECK-NEXT:     cmpslt $m0, $m1, $m0
; CHECK-NEXT:     ld32 $m10, $m11, $m15, 1        # 4-byte Folded Reload
; CHECK-NEXT:     add $m11, $m11, 8
; CHECK:          br $m10
define i1 @constrained_fcmps_oge_f32(float %lhs, float %rhs) {
  %retval = tail call i1 @llvm.experimental.constrained.fcmps.f32(float %lhs, float %rhs, metadata !"oge", metadata !"fpexcept.strict")
  ret i1 %retval
}

; CHECK-LABEL: fcmp_olt_f32:                           # @fcmp_olt_f32
; CHECK:          # %bb.0:
; CHECK:          add $m11, $m11, -8
; CHECK:          st32 $m10, $m11, $m15, 1        # 4-byte Folded Spill
; CHECK-NEXT:     call $m10, __ltsf2
; CHECK-NEXT:     cmpslt $m0, $m0, 0
; CHECK-NEXT:     ld32 $m10, $m11, $m15, 1        # 4-byte Folded Reload
; CHECK-NEXT:     add $m11, $m11, 8
; CHECK:          br $m10
define i1 @fcmp_olt_f32(float %lhs, float %rhs) {
  %retval = fcmp olt float %lhs, %rhs
  ret i1 %retval
}

; CHECK-LABEL: constrained_fcmps_olt_f32:
; CHECK:          # %bb.0:
; CHECK:          add $m11, $m11, -8
; CHECK:          st32 $m10, $m11, $m15, 1        # 4-byte Folded Spill
; CHECK-NEXT:     call $m10, __ltsf2
; CHECK-NEXT:     cmpslt $m0, $m0, 0
; CHECK-NEXT:     ld32 $m10, $m11, $m15, 1        # 4-byte Folded Reload
; CHECK-NEXT:     add $m11, $m11, 8
; CHECK:          br $m10
define i1 @constrained_fcmps_olt_f32(float %lhs, float %rhs) {
  %retval = tail call i1 @llvm.experimental.constrained.fcmps.f32(float %lhs, float %rhs, metadata !"olt", metadata !"fpexcept.strict")
  ret i1 %retval
}

; CHECK-LABEL: fcmp_ole_f32:                           # @fcmp_ole_f32
; CHECK:          # %bb.0:
; CHECK:          add $m11, $m11, -8
; CHECK:          st32 $m10, $m11, $m15, 1        # 4-byte Folded Spill
; CHECK-NEXT:     call $m10, __lesf2
; CHECK-NEXT:     cmpslt $m0, $m0, 1
; CHECK-NEXT:     ld32 $m10, $m11, $m15, 1        # 4-byte Folded Reload
; CHECK-NEXT:     add $m11, $m11, 8
; CHECK:          br $m10
define i1 @fcmp_ole_f32(float %lhs, float %rhs) {
  %retval = fcmp ole float %lhs, %rhs
  ret i1 %retval
}

; CHECK-LABEL: constrained_fcmps_ole_f32:
; CHECK:          # %bb.0:
; CHECK:          add $m11, $m11, -8
; CHECK:          st32 $m10, $m11, $m15, 1        # 4-byte Folded Spill
; CHECK-NEXT:     call $m10, __lesf2
; CHECK-NEXT:     cmpslt $m0, $m0, 1
; CHECK-NEXT:     ld32 $m10, $m11, $m15, 1        # 4-byte Folded Reload
; CHECK-NEXT:     add $m11, $m11, 8
; CHECK:          br $m10
define i1 @constrained_fcmps_ole_f32(float %lhs, float %rhs) {
  %retval = tail call i1 @llvm.experimental.constrained.fcmps.f32(float %lhs, float %rhs, metadata !"ole", metadata !"fpexcept.strict")
  ret i1 %retval
}

; CHECK-LABEL:fcmp_one_f32:                           # @fcmp_one_f32
; CHECK:         # %bb.0:
; CHECK:         add $m11, $m11, -16
; CHECK:         st32 $m8, $m11, $m15, 3         # 4-byte Folded Spill
; CHECK-NEXT:    st32 $m9, $m11, $m15, 2         # 4-byte Folded Spill
; CHECK-NEXT:    st32 $m10, $m11, $m15, 1        # 4-byte Folded Spill
; CHECK-NEXT:    st32 $m7, $m11, $m15, 0         # 4-byte Folded Spill
; CHECK-NEXT:    mov $m7, $m1
; CHECK-NEXT:    mov $m8, $m0
; CHECK-NEXT:    call $m10, __eqsf2
; CHECK-NEXT:    cmpne $m9, $m0, $m15
; CHECK-NEXT:    mov $m0, $m8
; CHECK-NEXT:    mov $m1, $m7
; CHECK-NEXT:    call $m10, __unordsf2
; CHECK-NEXT:    cmpeq $m0, $m0, 0
; CHECK-NEXT:    and $m0, $m0, $m9
; CHECK-NEXT:    ld32 $m7, $m11, $m15, 0         # 4-byte Folded Reload
; CHECK-NEXT:    ld32 $m10, $m11, $m15, 1        # 4-byte Folded Reload
; CHECK-NEXT:    ld32 $m9, $m11, $m15, 2         # 4-byte Folded Reload
; CHECK-NEXT:    ld32 $m8, $m11, $m15, 3         # 4-byte Folded Reload
; CHECK-NEXT:    add $m11, $m11, 16
; CHECK:         br $m10
define i1 @fcmp_one_f32(float %lhs, float %rhs) {
  %retval = fcmp one float %lhs, %rhs
  ret i1 %retval
}

; CHECK-LABEL:constrained_fcmps_one_f32:
; CHECK:         # %bb.0:
; CHECK:         add $m11, $m11, -16
; CHECK:         st32 $m8, $m11, $m15, 3         # 4-byte Folded Spill
; CHECK-NEXT:    st32 $m9, $m11, $m15, 2         # 4-byte Folded Spill
; CHECK-NEXT:    st32 $m10, $m11, $m15, 1        # 4-byte Folded Spill
; CHECK-NEXT:    st32 $m7, $m11, $m15, 0         # 4-byte Folded Spill
; CHECK-NEXT:    mov $m7, $m1
; CHECK-NEXT:    mov $m8, $m0
; CHECK-NEXT:    call $m10, __eqsf2
; CHECK-NEXT:    cmpne $m9, $m0, $m15
; CHECK-NEXT:    mov $m0, $m8
; CHECK-NEXT:    mov $m1, $m7
; CHECK-NEXT:    call $m10, __unordsf2
; CHECK-NEXT:    cmpeq $m0, $m0, 0
; CHECK-NEXT:    and $m0, $m0, $m9
; CHECK-NEXT:    ld32 $m7, $m11, $m15, 0         # 4-byte Folded Reload
; CHECK-NEXT:    ld32 $m10, $m11, $m15, 1        # 4-byte Folded Reload
; CHECK-NEXT:    ld32 $m9, $m11, $m15, 2         # 4-byte Folded Reload
; CHECK-NEXT:    ld32 $m8, $m11, $m15, 3         # 4-byte Folded Reload
; CHECK-NEXT:    add $m11, $m11, 16
; CHECK:         br $m10
define i1 @constrained_fcmps_one_f32(float %lhs, float %rhs) {
  %retval = tail call i1 @llvm.experimental.constrained.fcmps.f32(float %lhs, float %rhs, metadata !"one", metadata !"fpexcept.strict")
  ret i1 %retval
}

; CHECK-LABEL: fcmp_ord_f32:                           # @fcmp_ord_f32
; CHECK:          # %bb.0:
; CHECK:          add $m11, $m11, -8
; CHECK:          st32 $m10, $m11, $m15, 1        # 4-byte Folded Spill
; CHECK-NEXT:     call $m10, __unordsf2
; CHECK-NEXT:     cmpeq $m0, $m0, 0
; CHECK-NEXT:     ld32 $m10, $m11, $m15, 1        # 4-byte Folded Reload
; CHECK-NEXT:     add $m11, $m11, 8
; CHECK:          br $m10
define i1 @fcmp_ord_f32(float %lhs, float %rhs) {
  %retval = fcmp ord float %lhs, %rhs
  ret i1 %retval
}

; CHECK-LABEL: constrained_fcmps_ord_f32:
; CHECK:          # %bb.0:
; CHECK:          add $m11, $m11, -8
; CHECK:          st32 $m10, $m11, $m15, 1        # 4-byte Folded Spill
; CHECK-NEXT:     call $m10, __unordsf2
; CHECK-NEXT:     cmpeq $m0, $m0, 0
; CHECK-NEXT:     ld32 $m10, $m11, $m15, 1        # 4-byte Folded Reload
; CHECK-NEXT:     add $m11, $m11, 8
; CHECK:          br $m10
define i1 @constrained_fcmps_ord_f32(float %lhs, float %rhs) {
  %retval = tail call i1 @llvm.experimental.constrained.fcmps.f32(float %lhs, float %rhs, metadata !"ord", metadata !"fpexcept.strict")
  ret i1 %retval
}

; CHECK-LABEL: fcmp_ueq_f32:                           # @fcmp_ueq_f32
; CHECK:          # %bb.0:
; CHECK:          add $m11, $m11, -16
; CHECK:          st32 $m8, $m11, $m15, 3         # 4-byte Folded Spill
; CHECK-NEXT:     st32 $m9, $m11, $m15, 2         # 4-byte Folded Spill
; CHECK-NEXT:     st32 $m10, $m11, $m15, 1        # 4-byte Folded Spill
; CHECK-NEXT:     st32 $m7, $m11, $m15, 0         # 4-byte Folded Spill
; CHECK-NEXT:     mov $m7, $m1
; CHECK-NEXT:     mov $m8, $m0
; CHECK-NEXT:     call $m10, __unordsf2
; CHECK-NEXT:     cmpne $m9, $m0, $m15
; CHECK-NEXT:     mov $m0, $m8
; CHECK-NEXT:     mov $m1, $m7
; CHECK-NEXT:     call $m10, __eqsf2
; CHECK-NEXT:     cmpeq $m0, $m0, 0
; CHECK-NEXT:     or $m0, $m9, $m0
; CHECK-NEXT:     ld32 $m7, $m11, $m15, 0         # 4-byte Folded Reload
; CHECK-NEXT:     ld32 $m10, $m11, $m15, 1        # 4-byte Folded Reload
; CHECK-NEXT:     ld32 $m9, $m11, $m15, 2         # 4-byte Folded Reload
; CHECK-NEXT:     ld32 $m8, $m11, $m15, 3         # 4-byte Folded Reload
; CHECK-NEXT:     add $m11, $m11, 16
; CHECK:          br $m10
define i1 @fcmp_ueq_f32(float %lhs, float %rhs) {
  %retval = fcmp ueq float %lhs, %rhs
  ret i1 %retval
}

; CHECK-LABEL: constrained_fcmps_ueq_f32:
; CHECK:          # %bb.0:
; CHECK:          add $m11, $m11, -16
; CHECK:          st32 $m8, $m11, $m15, 3         # 4-byte Folded Spill
; CHECK-NEXT:     st32 $m9, $m11, $m15, 2         # 4-byte Folded Spill
; CHECK-NEXT:     st32 $m10, $m11, $m15, 1        # 4-byte Folded Spill
; CHECK-NEXT:     st32 $m7, $m11, $m15, 0         # 4-byte Folded Spill
; CHECK-NEXT:     mov $m7, $m1
; CHECK-NEXT:     mov $m8, $m0
; CHECK-NEXT:     call $m10, __unordsf2
; CHECK-NEXT:     cmpne $m9, $m0, $m15
; CHECK-NEXT:     mov $m0, $m8
; CHECK-NEXT:     mov $m1, $m7
; CHECK-NEXT:     call $m10, __eqsf2
; CHECK-NEXT:     cmpeq $m0, $m0, 0
; CHECK-NEXT:     or $m0, $m9, $m0
; CHECK-NEXT:     ld32 $m7, $m11, $m15, 0         # 4-byte Folded Reload
; CHECK-NEXT:     ld32 $m10, $m11, $m15, 1        # 4-byte Folded Reload
; CHECK-NEXT:     ld32 $m9, $m11, $m15, 2         # 4-byte Folded Reload
; CHECK-NEXT:     ld32 $m8, $m11, $m15, 3         # 4-byte Folded Reload
; CHECK-NEXT:     add $m11, $m11, 16
; CHECK:          br $m10
define i1 @constrained_fcmps_ueq_f32(float %lhs, float %rhs) {
  %retval = tail call i1 @llvm.experimental.constrained.fcmps.f32(float %lhs, float %rhs, metadata !"ueq", metadata !"fpexcept.strict")
  ret i1 %retval
}

; CHECK-LABEL: fcmp_ugt_f32:                           # @fcmp_ugt_f32
; CHECK:          # %bb.0:
; CHECK:          add $m11, $m11, -8
; CHECK:          st32 $m10, $m11, $m15, 1        # 4-byte Folded Spill
; CHECK-NEXT:     call $m10, __lesf2
; CHECK-NEXT:     cmpslt $m0, $m15, $m0
; CHECK-NEXT:     ld32 $m10, $m11, $m15, 1        # 4-byte Folded Reload
; CHECK-NEXT:     add $m11, $m11, 8
; CHECK:          br $m10
define i1 @fcmp_ugt_f32(float %lhs, float %rhs) {
  %retval = fcmp ugt float %lhs, %rhs
  ret i1 %retval
}

; CHECK-LABEL: constrained_fcmps_ugt_f32:
; CHECK:          # %bb.0:
; CHECK:          add $m11, $m11, -8
; CHECK:          st32 $m10, $m11, $m15, 1        # 4-byte Folded Spill
; CHECK-NEXT:     call $m10, __lesf2
; CHECK-NEXT:     cmpslt $m0, $m15, $m0
; CHECK-NEXT:     ld32 $m10, $m11, $m15, 1        # 4-byte Folded Reload
; CHECK-NEXT:     add $m11, $m11, 8
; CHECK:          br $m10
define i1 @constrained_fcmps_ugt_f32(float %lhs, float %rhs) {
  %retval = tail call i1 @llvm.experimental.constrained.fcmps.f32(float %lhs, float %rhs, metadata !"ugt", metadata !"fpexcept.strict")
  ret i1 %retval
}

; CHECK-LABEL: fcmp_uge_f32:                           # @fcmp_uge_f32
; CHECK:          # %bb.0:
; CHECK:          add $m11, $m11, -8
; CHECK:          st32 $m10, $m11, $m15, 1        # 4-byte Folded Spill
; CHECK-NEXT:     call $m10, __ltsf2
; CHECK-NEXT:     add $m1, $m15, -1
; CHECK-NEXT:     cmpslt $m0, $m1, $m0
; CHECK-NEXT:     ld32 $m10, $m11, $m15, 1        # 4-byte Folded Reload
; CHECK-NEXT:     add $m11, $m11, 8
; CHECK:          br $m10
define i1 @fcmp_uge_f32(float %lhs, float %rhs) {
  %retval = fcmp uge float %lhs, %rhs
  ret i1 %retval
}

; CHECK-LABEL: constrained_fcmps_uge_f32:
; CHECK:          # %bb.0:
; CHECK:          add $m11, $m11, -8
; CHECK:          st32 $m10, $m11, $m15, 1        # 4-byte Folded Spill
; CHECK-NEXT:     call $m10, __ltsf2
; CHECK-NEXT:     add $m1, $m15, -1
; CHECK-NEXT:     cmpslt $m0, $m1, $m0
; CHECK-NEXT:     ld32 $m10, $m11, $m15, 1        # 4-byte Folded Reload
; CHECK-NEXT:     add $m11, $m11, 8
; CHECK:          br $m10
define i1 @constrained_fcmps_uge_f32(float %lhs, float %rhs) {
  %retval = tail call i1 @llvm.experimental.constrained.fcmps.f32(float %lhs, float %rhs, metadata !"uge", metadata !"fpexcept.strict")
  ret i1 %retval
}

; CHECK-LABEL: fcmp_ult_f32:                           # @fcmp_ult_f32
; CHECK:          # %bb.0:
; CHECK:          add $m11, $m11, -8
; CHECK:          st32 $m10, $m11, $m15, 1        # 4-byte Folded Spill
; CHECK-NEXT:     call $m10, __gesf2
; CHECK-NEXT:     cmpslt $m0, $m0, 0
; CHECK-NEXT:     ld32 $m10, $m11, $m15, 1        # 4-byte Folded Reload
; CHECK-NEXT:     add $m11, $m11, 8
; CHECK:          br $m10
define i1 @fcmp_ult_f32(float %lhs, float %rhs) {
  %retval = fcmp ult float %lhs, %rhs
  ret i1 %retval
}

; CHECK-LABEL: constrained_fcmps_ult_f32:
; CHECK:          # %bb.0:
; CHECK:          add $m11, $m11, -8
; CHECK:          st32 $m10, $m11, $m15, 1        # 4-byte Folded Spill
; CHECK-NEXT:     call $m10, __gesf2
; CHECK-NEXT:     cmpslt $m0, $m0, 0
; CHECK-NEXT:     ld32 $m10, $m11, $m15, 1        # 4-byte Folded Reload
; CHECK-NEXT:     add $m11, $m11, 8
; CHECK:          br $m10
define i1 @constrained_fcmps_ult_f32(float %lhs, float %rhs) {
  %retval = tail call i1 @llvm.experimental.constrained.fcmps.f32(float %lhs, float %rhs, metadata !"ult", metadata !"fpexcept.strict")
  ret i1 %retval
}

; CHECK-LABEL: fcmp_ule_f32:                           # @fcmp_ule_f32
; CHECK:          # %bb.0:
; CHECK:          add $m11, $m11, -8
; CHECK:          st32 $m10, $m11, $m15, 1        # 4-byte Folded Spill
; CHECK-NEXT:     call $m10, __gtsf2
; CHECK-NEXT:     cmpslt $m0, $m0, 1
; CHECK-NEXT:     ld32 $m10, $m11, $m15, 1        # 4-byte Folded Reload
; CHECK-NEXT:     add $m11, $m11, 8
; CHECK:          br $m10
define i1 @fcmp_ule_f32(float %lhs, float %rhs) {
  %retval = fcmp ule float %lhs, %rhs
  ret i1 %retval
}

; CHECK-LABEL: constrained_fcmps_ule_f32:
; CHECK:          # %bb.0:
; CHECK:          add $m11, $m11, -8
; CHECK:          st32 $m10, $m11, $m15, 1        # 4-byte Folded Spill
; CHECK-NEXT:     call $m10, __gtsf2
; CHECK-NEXT:     cmpslt $m0, $m0, 1
; CHECK-NEXT:     ld32 $m10, $m11, $m15, 1        # 4-byte Folded Reload
; CHECK-NEXT:     add $m11, $m11, 8
; CHECK:          br $m10
define i1 @constrained_fcmps_ule_f32(float %lhs, float %rhs) {
  %retval = tail call i1 @llvm.experimental.constrained.fcmps.f32(float %lhs, float %rhs, metadata !"ule", metadata !"fpexcept.strict")
  ret i1 %retval
}

; CHECK-LABEL: fcmp_une_f32:                           # @fcmp_une_f32
; CHECK:          # %bb.0:
; CHECK:          add $m11, $m11, -8
; CHECK:          st32 $m10, $m11, $m15, 1        # 4-byte Folded Spill
; CHECK-NEXT:     call $m10, __nesf2
; CHECK-NEXT:     cmpne $m0, $m0, $m15
; CHECK-NEXT:     ld32 $m10, $m11, $m15, 1        # 4-byte Folded Reload
; CHECK-NEXT:     add $m11, $m11, 8
; CHECK:          br $m10
define i1 @fcmp_une_f32(float %lhs, float %rhs) {
  %retval = fcmp une float %lhs, %rhs
  ret i1 %retval
}

; CHECK-LABEL: constrained_fcmps_une_f32:
; CHECK:          # %bb.0:
; CHECK:          add $m11, $m11, -8
; CHECK:          st32 $m10, $m11, $m15, 1        # 4-byte Folded Spill
; CHECK-NEXT:     call $m10, __nesf2
; CHECK-NEXT:     cmpne $m0, $m0, $m15
; CHECK-NEXT:     ld32 $m10, $m11, $m15, 1        # 4-byte Folded Reload
; CHECK-NEXT:     add $m11, $m11, 8
; CHECK:          br $m10
define i1 @constrained_fcmps_une_f32(float %lhs, float %rhs) {
  %retval = tail call i1 @llvm.experimental.constrained.fcmps.f32(float %lhs, float %rhs, metadata !"une", metadata !"fpexcept.strict")
  ret i1 %retval
}

; CHECK-LABEL: fcmp_uno_f32:                           # @fcmp_uno_f32
; CHECK:          # %bb.0:
; CHECK:          add $m11, $m11, -8
; CHECK:          st32 $m10, $m11, $m15, 1        # 4-byte Folded Spill
; CHECK-NEXT:     call $m10, __unordsf2
; CHECK-NEXT:     cmpne $m0, $m0, $m15
; CHECK-NEXT:     ld32 $m10, $m11, $m15, 1        # 4-byte Folded Reload
; CHECK-NEXT:     add $m11, $m11, 8
; CHECK:          br $m10
define i1 @fcmp_uno_f32(float %lhs, float %rhs) {
  %retval = fcmp uno float %lhs, %rhs
  ret i1 %retval
}

; CHECK-LABEL: constrained_fcmps_uno_f32:
; CHECK:          # %bb.0:
; CHECK:          add $m11, $m11, -8
; CHECK:          st32 $m10, $m11, $m15, 1        # 4-byte Folded Spill
; CHECK-NEXT:     call $m10, __unordsf2
; CHECK-NEXT:     cmpne $m0, $m0, $m15
; CHECK-NEXT:     ld32 $m10, $m11, $m15, 1        # 4-byte Folded Reload
; CHECK-NEXT:     add $m11, $m11, 8
; CHECK:          br $m10
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
