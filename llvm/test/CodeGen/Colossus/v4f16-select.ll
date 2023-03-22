; RUN: llc < %s -mtriple=colossus -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -mtriple=colossus -mattr=+ipu2 | FileCheck %s

declare i1 @llvm.experimental.constrained.fcmps.f32(float, float, metadata, metadata)

; CHECK-LABEL: test_select_reg:
; CHECK:       brnz
; CHECK:       mov $a0:1
define <4 x half> @test_select_reg(i1 %cond, <4 x half> %t, <4 x half> %f) {
  %1 = select i1 %cond, <4 x half> %t, <4 x half> %f
  ret <4 x half> %1
}

; CHECK-LABEL: test_select_fcmp:
; CHECK:       mov
; CHECK:       mov
; CHECK:       f32cmpeq
; CHECK:       mov
; CHECK:       brnz
define float @test_select_fcmp(float %lhs, float %rhs, float %t, float %f) {
  %1 = fcmp oeq float %lhs, %rhs
  %2 = select i1 %1, float %t, float %f
  ret float %2
}

; CHECK-LABEL: test_constrained_select_fcmp:
; CHECK:       mov
; CHECK:       mov
; CHECK:       f32cmpeq
; CHECK:       mov
; CHECK:       brnz
; CHECK:       mov
define float @test_constrained_select_fcmp(float %lhs, float %rhs, float %t, float %f) {
  %1 = tail call i1 @llvm.experimental.constrained.fcmps.f32(float %lhs, float %rhs, metadata !"oeq", metadata !"fpexcept.strict")
  %2 = select i1 %1, float %t, float %f
  ret float %2
}

; CHECK-LABEL: test_vselect_reg:
; CHECK-DAG:   sort4x16lo
; CHECK-DAG:   sort4x16lo
; CHECK:       andc64
; CHECK:       and64
; CHECK:       or64
define <4 x half>
@test_vselect_reg(<4 x i1> %cond, <4 x half> %t, <4 x half> %f) {
  %1 = select <4 x i1> %cond, <4 x half> %t, <4 x half> %f
  ret <4 x half> %1
}
