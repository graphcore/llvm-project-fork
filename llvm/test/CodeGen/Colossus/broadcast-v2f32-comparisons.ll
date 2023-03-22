; RUN: llc < %s -march=colossus -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -march=colossus -mattr=+ipu2 | FileCheck %s
target triple = "colossus-graphcore--elf"

declare <2 x i1> @llvm.experimental.constrained.fcmps.v2f32(<2 x float>, <2 x float>, metadata, metadata)

; CHECK-LABEL: fcmp_oeq_scalar_vector:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f32v2cmpeq $a0:1, $a0:B, $a2:3
; CHECK-NEXT:  }
define <2 x float> @fcmp_oeq_scalar_vector(float %a, <2 x float> %b) {
  %s0 = insertelement <2 x float> undef, float %a, i32 0
  %s1 = insertelement <2 x float> %s0, float %a, i32 1
  %res = fcmp oeq <2 x float> %s1, %b
  %se = sext <2 x i1> %res to <2 x i32>
  %bc = bitcast <2 x i32> %se to <2 x float>
  ret <2 x float> %bc
}

; CHECK-LABEL: constrained_fcmps_oeq_scalar_vector:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f32v2cmpeq $a0:1, $a0:B, $a2:3
; CHECK-NEXT:  }
define <2 x float> @constrained_fcmps_oeq_scalar_vector(float %a, <2 x float> %b) {
  %s0 = insertelement <2 x float> undef, float %a, i32 0
  %s1 = insertelement <2 x float> %s0, float %a, i32 1
  %res = tail call <2 x i1> @llvm.experimental.constrained.fcmps.v2f32(<2 x float> %s1, <2 x float> %b, metadata !"oeq", metadata !"fpexcept.strict")
  %se = sext <2 x i1> %res to <2 x i32>
  %bc = bitcast <2 x i32> %se to <2 x float>
  ret <2 x float> %bc
}

; CHECK-LABEL: fcmp_one_scalar_vector:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f32v2cmpgt $a4:5, $a0:B, $a2:3
; CHECK-NEXT:  f32v2cmplt $a0:1, $a0:B, $a2:3
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  or64 $a0:1, $a0:1, $a4:5
; CHECK-NEXT:  }
define <2 x float> @fcmp_one_scalar_vector(float %a, <2 x float> %b) {
  %s0 = insertelement <2 x float> undef, float %a, i32 0
  %s1 = insertelement <2 x float> %s0, float %a, i32 1
  %res = fcmp one <2 x float> %s1, %b
  %se = sext <2 x i1> %res to <2 x i32>
  %bc = bitcast <2 x i32> %se to <2 x float>
  ret <2 x float> %bc
}

; CHECK-LABEL: constrained_fcmps_one_scalar_vector:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f32v2cmpgt $a4:5, $a0:B, $a2:3
; CHECK-NEXT:  f32v2cmplt $a0:1, $a0:B, $a2:3
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  or64 $a0:1, $a0:1, $a4:5
; CHECK-NEXT:  }
define <2 x float> @constrained_fcmps_one_scalar_vector(float %a, <2 x float> %b) {
  %s0 = insertelement <2 x float> undef, float %a, i32 0
  %s1 = insertelement <2 x float> %s0, float %a, i32 1
  %res = tail call <2 x i1> @llvm.experimental.constrained.fcmps.v2f32(<2 x float> %s1, <2 x float> %b, metadata !"one", metadata !"fpexcept.strict")
  %se = sext <2 x i1> %res to <2 x i32>
  %bc = bitcast <2 x i32> %se to <2 x float>
  ret <2 x float> %bc
}

; CHECK-LABEL: fcmp_oge_scalar_vector:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f32v2cmpge $a0:1, $a0:B, $a2:3
; CHECK-NEXT:  }
define <2 x float> @fcmp_oge_scalar_vector(float %a, <2 x float> %b) {
  %s0 = insertelement <2 x float> undef, float %a, i32 0
  %s1 = insertelement <2 x float> %s0, float %a, i32 1
  %res = fcmp oge <2 x float> %s1, %b
  %se = sext <2 x i1> %res to <2 x i32>
  %bc = bitcast <2 x i32> %se to <2 x float>
  ret <2 x float> %bc
}

; CHECK-LABEL: constrained_fcmps_oge_scalar_vector:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f32v2cmpge $a0:1, $a0:B, $a2:3
; CHECK-NEXT:  }
define <2 x float> @constrained_fcmps_oge_scalar_vector(float %a, <2 x float> %b) {
  %s0 = insertelement <2 x float> undef, float %a, i32 0
  %s1 = insertelement <2 x float> %s0, float %a, i32 1
  %res = tail call <2 x i1> @llvm.experimental.constrained.fcmps.v2f32(<2 x float> %s1, <2 x float> %b, metadata !"oge", metadata !"fpexcept.strict")
  %se = sext <2 x i1> %res to <2 x i32>
  %bc = bitcast <2 x i32> %se to <2 x float>
  ret <2 x float> %bc
}

; CHECK-LABEL: fcmp_ogt_scalar_vector:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f32v2cmpgt $a0:1, $a0:B, $a2:3
; CHECK-NEXT:  }
define <2 x float> @fcmp_ogt_scalar_vector(float %a, <2 x float> %b) {
  %s0 = insertelement <2 x float> undef, float %a, i32 0
  %s1 = insertelement <2 x float> %s0, float %a, i32 1
  %res = fcmp ogt <2 x float> %s1, %b
  %se = sext <2 x i1> %res to <2 x i32>
  %bc = bitcast <2 x i32> %se to <2 x float>
  ret <2 x float> %bc
}

; CHECK-LABEL: constrained_fcmps_ogt_scalar_vector:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f32v2cmpgt $a0:1, $a0:B, $a2:3
; CHECK-NEXT:  }
define <2 x float> @constrained_fcmps_ogt_scalar_vector(float %a, <2 x float> %b) {
  %s0 = insertelement <2 x float> undef, float %a, i32 0
  %s1 = insertelement <2 x float> %s0, float %a, i32 1
  %res = tail call <2 x i1> @llvm.experimental.constrained.fcmps.v2f32(<2 x float> %s1, <2 x float> %b, metadata !"ogt", metadata !"fpexcept.strict")
  %se = sext <2 x i1> %res to <2 x i32>
  %bc = bitcast <2 x i32> %se to <2 x float>
  ret <2 x float> %bc
}

; CHECK-LABEL: fcmp_ole_scalar_vector:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f32v2cmple $a0:1, $a0:B, $a2:3
; CHECK-NEXT:  }
define <2 x float> @fcmp_ole_scalar_vector(float %a, <2 x float> %b) {
  %s0 = insertelement <2 x float> undef, float %a, i32 0
  %s1 = insertelement <2 x float> %s0, float %a, i32 1
  %res = fcmp ole <2 x float> %s1, %b
  %se = sext <2 x i1> %res to <2 x i32>
  %bc = bitcast <2 x i32> %se to <2 x float>
  ret <2 x float> %bc
}

; CHECK-LABEL: constrained_fcmps_ole_scalar_vector:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f32v2cmple $a0:1, $a0:B, $a2:3
; CHECK-NEXT:  }
define <2 x float> @constrained_fcmps_ole_scalar_vector(float %a, <2 x float> %b) {
  %s0 = insertelement <2 x float> undef, float %a, i32 0
  %s1 = insertelement <2 x float> %s0, float %a, i32 1
  %res = tail call <2 x i1> @llvm.experimental.constrained.fcmps.v2f32(<2 x float> %s1, <2 x float> %b, metadata !"ole", metadata !"fpexcept.strict")
  %se = sext <2 x i1> %res to <2 x i32>
  %bc = bitcast <2 x i32> %se to <2 x float>
  ret <2 x float> %bc
}

; CHECK-LABEL: fcmp_olt_scalar_vector:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f32v2cmplt $a0:1, $a0:B, $a2:3
; CHECK-NEXT:  }
define <2 x float> @fcmp_olt_scalar_vector(float %a, <2 x float> %b) {
  %s0 = insertelement <2 x float> undef, float %a, i32 0
  %s1 = insertelement <2 x float> %s0, float %a, i32 1
  %res = fcmp olt <2 x float> %s1, %b
  %se = sext <2 x i1> %res to <2 x i32>
  %bc = bitcast <2 x i32> %se to <2 x float>
  ret <2 x float> %bc
}

; CHECK-LABEL: constrained_fcmps_olt_scalar_vector:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f32v2cmplt $a0:1, $a0:B, $a2:3
; CHECK-NEXT:  }
define <2 x float> @constrained_fcmps_olt_scalar_vector(float %a, <2 x float> %b) {
  %s0 = insertelement <2 x float> undef, float %a, i32 0
  %s1 = insertelement <2 x float> %s0, float %a, i32 1
  %res = tail call <2 x i1> @llvm.experimental.constrained.fcmps.v2f32(<2 x float> %s1, <2 x float> %b, metadata !"olt", metadata !"fpexcept.strict")
  %se = sext <2 x i1> %res to <2 x i32>
  %bc = bitcast <2 x i32> %se to <2 x float>
  ret <2 x float> %bc
}
