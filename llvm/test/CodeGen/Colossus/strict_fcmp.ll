; RUN: llc <%s -march=colossus | FileCheck %s

declare i1 @llvm.experimental.constrained.fcmp.f32(float, float, metadata, metadata)

; CHECK-LABEL: strict_f32cmp_ord:
; CHECK:       call $m10, __strict_f32cmp_ord
define i32 @strict_f32cmp_ord(float %lhs, float %rhs) {
  %comp = tail call i1 @llvm.experimental.constrained.fcmp.f32(float %lhs, float %rhs, metadata !"ord", metadata !"fpexcept.strict")
  %retval = zext i1 %comp to i32
  ret i32 %retval
}

; CHECK-LABEL: strict_f32cmp_oeq:
; CHECK:       call $m10, __strict_f32cmp_oeq
define i32 @strict_f32cmp_oeq(float %lhs, float %rhs) {
  %comp = tail call i1 @llvm.experimental.constrained.fcmp.f32(float %lhs, float %rhs, metadata !"oeq", metadata !"fpexcept.strict")
  %retval = zext i1 %comp to i32
  ret i32 %retval
}

; CHECK-LABEL: strict_f32cmp_one:
; CHECK:       call $m10, __strict_f32cmp_one
define i32 @strict_f32cmp_one(float %lhs, float %rhs) {
  %comp = tail call i1 @llvm.experimental.constrained.fcmp.f32(float %lhs, float %rhs, metadata !"one", metadata !"fpexcept.strict")
  %retval = zext i1 %comp to i32
  ret i32 %retval
}

; CHECK-LABEL: strict_f32cmp_olt:
; CHECK:       call $m10, __strict_f32cmp_olt
define i32 @strict_f32cmp_olt(float %lhs, float %rhs) {
  %comp = tail call i1 @llvm.experimental.constrained.fcmp.f32(float %lhs, float %rhs, metadata !"olt", metadata !"fpexcept.strict")
  %retval = zext i1 %comp to i32
  ret i32 %retval
}

; CHECK-LABEL: strict_f32cmp_ole:
; CHECK:       call $m10, __strict_f32cmp_ole
define i32 @strict_f32cmp_ole(float %lhs, float %rhs) {
  %comp = tail call i1 @llvm.experimental.constrained.fcmp.f32(float %lhs, float %rhs, metadata !"ole", metadata !"fpexcept.strict")
  %retval = zext i1 %comp to i32
  ret i32 %retval
}

; CHECK-LABEL: strict_f32cmp_ogt:
; CHECK:       call $m10, __strict_f32cmp_ogt
define i32 @strict_f32cmp_ogt(float %lhs, float %rhs) {
  %comp = tail call i1 @llvm.experimental.constrained.fcmp.f32(float %lhs, float %rhs, metadata !"ogt", metadata !"fpexcept.strict")
  %retval = zext i1 %comp to i32
  ret i32 %retval
}

; CHECK-LABEL: strict_f32cmp_oge:
; CHECK:       call $m10, __strict_f32cmp_oge
define i32 @strict_f32cmp_oge(float %lhs, float %rhs) {
  %comp = tail call i1 @llvm.experimental.constrained.fcmp.f32(float %lhs, float %rhs, metadata !"oge", metadata !"fpexcept.strict")
  %retval = zext i1 %comp to i32
  ret i32 %retval
}

; CHECK-LABEL: strict_f32cmp_uno:
; CHECK:       call $m10, __strict_f32cmp_uno
define i32 @strict_f32cmp_uno(float %lhs, float %rhs) {
  %comp = tail call i1 @llvm.experimental.constrained.fcmp.f32(float %lhs, float %rhs, metadata !"uno", metadata !"fpexcept.strict")
  %retval = zext i1 %comp to i32
  ret i32 %retval
}

; CHECK-LABEL: strict_f32cmp_ueq:
; CHECK:       call $m10, __strict_f32cmp_ueq
define i32 @strict_f32cmp_ueq(float %lhs, float %rhs) {
  %comp = tail call i1 @llvm.experimental.constrained.fcmp.f32(float %lhs, float %rhs, metadata !"ueq", metadata !"fpexcept.strict")
  %retval = zext i1 %comp to i32
  ret i32 %retval
}

; CHECK-LABEL: strict_f32cmp_une:
; CHECK:       call $m10, __strict_f32cmp_une
define i32 @strict_f32cmp_une(float %lhs, float %rhs) {
  %comp = tail call i1 @llvm.experimental.constrained.fcmp.f32(float %lhs, float %rhs, metadata !"une", metadata !"fpexcept.strict")
  %retval = zext i1 %comp to i32
  ret i32 %retval
}

; CHECK-LABEL: strict_f32cmp_ult:
; CHECK:       call $m10, __strict_f32cmp_ult
define i32 @strict_f32cmp_ult(float %lhs, float %rhs) {
  %comp = tail call i1 @llvm.experimental.constrained.fcmp.f32(float %lhs, float %rhs, metadata !"ult", metadata !"fpexcept.strict")
  %retval = zext i1 %comp to i32
  ret i32 %retval
}

; CHECK-LABEL: strict_f32cmp_ule:
; CHECK:       call $m10, __strict_f32cmp_ule
define i32 @strict_f32cmp_ule(float %lhs, float %rhs) {
  %comp = tail call i1 @llvm.experimental.constrained.fcmp.f32(float %lhs, float %rhs, metadata !"ule", metadata !"fpexcept.strict")
  %retval = zext i1 %comp to i32
  ret i32 %retval
}

; CHECK-LABEL: strict_f32cmp_ugt:
; CHECK:       call $m10, __strict_f32cmp_ugt
define i32 @strict_f32cmp_ugt(float %lhs, float %rhs) {
  %comp = tail call i1 @llvm.experimental.constrained.fcmp.f32(float %lhs, float %rhs, metadata !"ugt", metadata !"fpexcept.strict")
  %retval = zext i1 %comp to i32
  ret i32 %retval
}

; CHECK-LABEL: strict_f32cmp_uge:
; CHECK:       call $m10, __strict_f32cmp_uge
define i32 @strict_f32cmp_uge(float %lhs, float %rhs) {
  %comp = tail call i1 @llvm.experimental.constrained.fcmp.f32(float %lhs, float %rhs, metadata !"uge", metadata !"fpexcept.strict")
  %retval = zext i1 %comp to i32
  ret i32 %retval
}

declare i1 @llvm.experimental.constrained.fcmp.f16(half, half, metadata, metadata)

; CHECK-LABEL: strict_f16cmp_ord:
; CHECK:       f16tof32
; CHECK:       f16tof32
; CHECK:       call $m10, __strict_f32cmp_ord
define i32 @strict_f16cmp_ord(half %lhs, half %rhs) {
  %comp = tail call i1 @llvm.experimental.constrained.fcmp.f16(half %lhs, half %rhs, metadata !"ord", metadata !"fpexcept.strict")
  %retval = zext i1 %comp to i32
  ret i32 %retval
}

; CHECK-LABEL: strict_f16cmp_oeq:
; CHECK:       f16tof32
; CHECK:       f16tof32
; CHECK:       call $m10, __strict_f32cmp_oeq
define i32 @strict_f16cmp_oeq(half %lhs, half %rhs) {
  %comp = tail call i1 @llvm.experimental.constrained.fcmp.f16(half %lhs, half %rhs, metadata !"oeq", metadata !"fpexcept.strict")
  %retval = zext i1 %comp to i32
  ret i32 %retval
}

; CHECK-LABEL: strict_f16cmp_one:
; CHECK:       f16tof32
; CHECK:       f16tof32
; CHECK:       call $m10, __strict_f32cmp_one
define i32 @strict_f16cmp_one(half %lhs, half %rhs) {
  %comp = tail call i1 @llvm.experimental.constrained.fcmp.f16(half %lhs, half %rhs, metadata !"one", metadata !"fpexcept.strict")
  %retval = zext i1 %comp to i32
  ret i32 %retval
}

; CHECK-LABEL: strict_f16cmp_olt:
; CHECK:       f16tof32
; CHECK:       f16tof32
; CHECK:       call $m10, __strict_f32cmp_olt
define i32 @strict_f16cmp_olt(half %lhs, half %rhs) {
  %comp = tail call i1 @llvm.experimental.constrained.fcmp.f16(half %lhs, half %rhs, metadata !"olt", metadata !"fpexcept.strict")
  %retval = zext i1 %comp to i32
  ret i32 %retval
}

; CHECK-LABEL: strict_f16cmp_ole:
; CHECK:       f16tof32
; CHECK:       f16tof32
; CHECK:       call $m10, __strict_f32cmp_ole
define i32 @strict_f16cmp_ole(half %lhs, half %rhs) {
  %comp = tail call i1 @llvm.experimental.constrained.fcmp.f16(half %lhs, half %rhs, metadata !"ole", metadata !"fpexcept.strict")
  %retval = zext i1 %comp to i32
  ret i32 %retval
}

; CHECK-LABEL: strict_f16cmp_ogt:
; CHECK:       f16tof32
; CHECK:       f16tof32
; CHECK:       call $m10, __strict_f32cmp_ogt
define i32 @strict_f16cmp_ogt(half %lhs, half %rhs) {
  %comp = tail call i1 @llvm.experimental.constrained.fcmp.f16(half %lhs, half %rhs, metadata !"ogt", metadata !"fpexcept.strict")
  %retval = zext i1 %comp to i32
  ret i32 %retval
}

; CHECK-LABEL: strict_f16cmp_oge:
; CHECK:       f16tof32
; CHECK:       f16tof32
; CHECK:       call $m10, __strict_f32cmp_oge
define i32 @strict_f16cmp_oge(half %lhs, half %rhs) {
  %comp = tail call i1 @llvm.experimental.constrained.fcmp.f16(half %lhs, half %rhs, metadata !"oge", metadata !"fpexcept.strict")
  %retval = zext i1 %comp to i32
  ret i32 %retval
}

; CHECK-LABEL: strict_f16cmp_uno:
; CHECK:       f16tof32
; CHECK:       f16tof32
; CHECK:       call $m10, __strict_f32cmp_uno
define i32 @strict_f16cmp_uno(half %lhs, half %rhs) {
  %comp = tail call i1 @llvm.experimental.constrained.fcmp.f16(half %lhs, half %rhs, metadata !"uno", metadata !"fpexcept.strict")
  %retval = zext i1 %comp to i32
  ret i32 %retval
}

; CHECK-LABEL: strict_f16cmp_ueq:
; CHECK:       f16tof32
; CHECK:       f16tof32
; CHECK:       call $m10, __strict_f32cmp_ueq
define i32 @strict_f16cmp_ueq(half %lhs, half %rhs) {
  %comp = tail call i1 @llvm.experimental.constrained.fcmp.f16(half %lhs, half %rhs, metadata !"ueq", metadata !"fpexcept.strict")
  %retval = zext i1 %comp to i32
  ret i32 %retval
}

; CHECK-LABEL: strict_f16cmp_une:
; CHECK:       f16tof32
; CHECK:       f16tof32
; CHECK:       call $m10, __strict_f32cmp_une
define i32 @strict_f16cmp_une(half %lhs, half %rhs) {
  %comp = tail call i1 @llvm.experimental.constrained.fcmp.f16(half %lhs, half %rhs, metadata !"une", metadata !"fpexcept.strict")
  %retval = zext i1 %comp to i32
  ret i32 %retval
}

; CHECK-LABEL: strict_f16cmp_ult:
; CHECK:       f16tof32
; CHECK:       f16tof32
; CHECK:       call $m10, __strict_f32cmp_ult
define i32 @strict_f16cmp_ult(half %lhs, half %rhs) {
  %comp = tail call i1 @llvm.experimental.constrained.fcmp.f16(half %lhs, half %rhs, metadata !"ult", metadata !"fpexcept.strict")
  %retval = zext i1 %comp to i32
  ret i32 %retval
}

; CHECK-LABEL: strict_f16cmp_ule:
; CHECK:       f16tof32
; CHECK:       f16tof32
; CHECK:       call $m10, __strict_f32cmp_ule
define i32 @strict_f16cmp_ule(half %lhs, half %rhs) {
  %comp = tail call i1 @llvm.experimental.constrained.fcmp.f16(half %lhs, half %rhs, metadata !"ule", metadata !"fpexcept.strict")
  %retval = zext i1 %comp to i32
  ret i32 %retval
}

; CHECK-LABEL: strict_f16cmp_ugt:
; CHECK:       f16tof32
; CHECK:       f16tof32
; CHECK:       call $m10, __strict_f32cmp_ugt
define i32 @strict_f16cmp_ugt(half %lhs, half %rhs) {
  %comp = tail call i1 @llvm.experimental.constrained.fcmp.f16(half %lhs, half %rhs, metadata !"ugt", metadata !"fpexcept.strict")
  %retval = zext i1 %comp to i32
  ret i32 %retval
}

; CHECK-LABEL: strict_f16cmp_uge:
; CHECK:       f16tof32
; CHECK:       f16tof32
; CHECK:       call $m10, __strict_f32cmp_uge
define i32 @strict_f16cmp_uge(half %lhs, half %rhs) {
  %comp = tail call i1 @llvm.experimental.constrained.fcmp.f16(half %lhs, half %rhs, metadata !"uge", metadata !"fpexcept.strict")
  %retval = zext i1 %comp to i32
  ret i32 %retval
}
