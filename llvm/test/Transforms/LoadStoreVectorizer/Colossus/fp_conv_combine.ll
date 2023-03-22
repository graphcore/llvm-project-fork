; RUN: opt -slp-vectorizer --colossus-load-store-vectorizer < %s | \
; RUN: llc -o - | FileCheck %s
target triple = "colossus-graphcore--elf"

; CHECK-LABEL: conv_v2f16_to_v2f32:
; CHECK:       # %bb
; CHECK-NEXT:  ld32 $a0, $m0, $m15, 0
; CHECK-NEXT:  f16v2tof32 $a0:1, $a0
; CHECK-NEXT:  st64 $a0:1, $m1, $m15, 0
; CHECK-NEXT:  br $m10

define void @conv_v2f16_to_v2f32(half* noalias align 8 %x, float* noalias align 8 %z) {
entry:
  %0 = load half, half* %x, align 8
  %conv = fpext half %0 to float
  store float %conv, float* %z, align 8
  %arrayidx2 = getelementptr inbounds half, half* %x, i32 1
  %1 = load half, half* %arrayidx2, align 2
  %conv3 = fpext half %1 to float
  %arrayidx4 = getelementptr inbounds float, float* %z, i32 1
  store float %conv3, float* %arrayidx4, align 4
  ret void
}

; CHECK-LABEL: strict_conv_v2f16_to_v2f32:
; CHECK:       # %bb
; CHECK-NEXT:  ld32 $a0, $m0, $m15, 0
; CHECK-NEXT:  swap16  $a1, $a0
; CHECK-NEXT:  f16tof32 $a0, $a0
; CHECK-NEXT:  f16tof32 $a1, $a1
; CHECK-NEXT:  st64 $a0:1, $m1, $m15, 0
; CHECK-NEXT:  br $m10

declare float @llvm.experimental.constrained.fpext.f32.f16(half, metadata)

define void @strict_conv_v2f16_to_v2f32(half* noalias align 8 %x, float* noalias align 8 %z) {
entry:
  %0 = load half, half* %x, align 8
  %conv = tail call float @llvm.experimental.constrained.fpext.f32.f16(half %0, metadata !"fpexcept.strict")
  store float %conv, float* %z, align 8
  %arrayidx2 = getelementptr inbounds half, half* %x, i32 1
  %1 = load half, half* %arrayidx2, align 2
  %conv3 = tail call float @llvm.experimental.constrained.fpext.f32.f16(half %1, metadata !"fpexcept.strict")
  %arrayidx4 = getelementptr inbounds float, float* %z, i32 1
  store float %conv3, float* %arrayidx4, align 4
  ret void
}
