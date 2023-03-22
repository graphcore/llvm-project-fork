; RUN: llc < %s -march=colossus -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -march=colossus -mattr=+ipu2 | FileCheck %s

declare i1 @llvm.experimental.constrained.fcmps.f32(float, float, metadata, metadata)

; Test lowering of SELECT_F32 pseudo with custom inserter.

; CHECK-LABEL: select_reg:
; CHECK:       brnz $m0, [[LABEL:\.L[A-Z0-9_]+]]
; CHECK-NEXT:  #
; CHECK-NEXT:  mov $a0, $a1
; CHECK-NEXT:  [[LABEL]]:
; CHECK-NEXT:  br $m10
define float @select_reg(i1 %cond, float %t, float %f) {
  %1 = select i1 %cond, float %t, float %f
  ret float %1
}

; CHECK-LABEL: select_fcmp:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov [[REG0:\$a[0-9]+]], $a0
; CHECK-NEXT:  mov $a0, $a2
; CHECK-NEXT:  f32cmpeq [[REG1:\$a[0-9]+]], [[REG0]], $a1
; CHECK-NEXT:  mov $m0, [[REG1]]
; CHECK-NEXT:  brnz $m0, [[LABEL:\.L[A-Z0-9_]+]]
; CHECK-NEXT:  # %bb.1:
; CHECK-NEXT:  mov $a0, $a3
; CHECK-NEXT:  [[LABEL]]:
; CHECK-NEXT:  br $m10
define float @select_fcmp(float %lhs, float %rhs, float %t, float %f) {
  %1 = fcmp oeq float %lhs, %rhs
  %2 = select i1 %1, float %t, float %f
  ret float %2
}

; CHECK-LABEL: constrained_select_fcmp:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov [[REG0:\$a[0-9]+]], $a0
; CHECK-NEXT:  mov $a0, $a2
; CHECK-NEXT:  f32cmpeq [[REG1:\$a[0-9]+]], [[REG0]], $a1
; CHECK-NEXT:  mov $m0, [[REG1]]
; CHECK-NEXT:  brnz $m0, [[LABEL:\.L[A-Z0-9_]+]]
; CHECK-NEXT:  # %bb.1:
; CHECK-NEXT:  mov $a0, $a3
; CHECK-NEXT:  [[LABEL]]:
; CHECK-NEXT:  br $m10
define float @constrained_select_fcmp(float %lhs, float %rhs, float %t, float %f) {
  %1 = tail call i1 @llvm.experimental.constrained.fcmps.f32(float %lhs, float %rhs, metadata !"oeq", metadata !"fpexcept.strict")
  %2 = select i1 %1, float %t, float %f
  ret float %2
}

; See fp-comparisons for other comparisons, olt, ogt, ult, ugt etc.
