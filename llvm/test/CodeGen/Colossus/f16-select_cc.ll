; RUN: llc < %s -march=colossus -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -march=colossus -mattr=+ipu2 | FileCheck %s

target triple = "colossus-graphcore--elf"

declare i1 @llvm.experimental.constrained.fcmps.f32(float, float, metadata, metadata)

; The test case does not obviously trigger select_cc for f16.
; It is derived from a real world test case (see T981) and has
; proven difficult to simplify further while still hitting the
; select_cc f16 code path. The main benefit of this test is that
; it detects 'Cannot select: f16 = select_cc ....

; CHECK-LABEL: select_cc:
; CHECK:       f32cmpgt
; CHECK:       brz
define half @select_cc(float %in)  {
  %cmp8 = fcmp ogt float %in, 0.000000e+00
  %cond10 = select i1 %cmp8, i32 1, i32 0
  %conv11 = sitofp i32 %cond10 to half
  ret half %conv11
}

; Code generation difference with non strict version is tracked with T30877.
; CHECK-LABEL: constrained_select_cc:
; CHECK:       f32cmpgt
; CHECK:       and
; CHECK:       f32fromi32
; CHECK:       f32tof16
define half @constrained_select_cc(float %in)  {
  %cmp8 = tail call i1 @llvm.experimental.constrained.fcmps.f32(float %in, float 0.000000e+00, metadata !"ogt", metadata !"fpexcept.strict")
  %cond10 = select i1 %cmp8, i32 1, i32 0
  %conv11 = sitofp i32 %cond10 to half
  ret half %conv11
}
