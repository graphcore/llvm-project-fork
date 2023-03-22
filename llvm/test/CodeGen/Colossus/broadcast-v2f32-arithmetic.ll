; RUN: llc < %s -mtriple=colossus -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -mtriple=colossus -mattr=+ipu2 | FileCheck %s

; CHECK-LABEL: add_vector_vector:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f32v2add $a0:1, $a0:1, $a2:3
; CHECK-NEXT:  }
define <2 x float> @add_vector_vector(<2 x float> %a, <2 x float> %b) {
  %res = fadd <2 x float> %a, %b
  ret <2 x float> %res
}

declare <2 x float> @llvm.experimental.constrained.fadd.v2f32(<2 x float>, <2 x float>, metadata, metadata)

; CHECK-LABEL: strict_add_vector_vector:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f32v2add $a0:1, $a0:1, $a2:3
; CHECK-NEXT:  }
define <2 x float> @strict_add_vector_vector(<2 x float> %a, <2 x float> %b) {
  %res = call <2 x float> @llvm.experimental.constrained.fadd.v2f32(<2 x float> %a, <2 x float> %b, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <2 x float> %res
}

; CHECK-LABEL: add_vector_scalar:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f32v2add $a0:1, $a2:B, $a0:1
; CHECK-NEXT:  }
define <2 x float> @add_vector_scalar(<2 x float> %a, float %b) {
  %s0 = insertelement <2 x float> undef, float %b, i32 0
  %s1 = insertelement <2 x float> %s0, float %b, i32 1
  %res = fadd <2 x float> %a, %s1
  ret <2 x float> %res
}

; CHECK-LABEL: strict_add_vector_scalar:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f32v2add $a0:1, $a2:B, $a0:1
; CHECK-NEXT:  }
define <2 x float> @strict_add_vector_scalar(<2 x float> %a, float %b) {
  %s0 = insertelement <2 x float> undef, float %b, i32 0
  %s1 = insertelement <2 x float> %s0, float %b, i32 1
  %res = call <2 x float> @llvm.experimental.constrained.fadd.v2f32(<2 x float> %a, <2 x float> %s1, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <2 x float> %res
}

; CHECK-LABEL: add_scalar_vector:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f32v2add $a0:1, $a0:B, $a2:3
; CHECK-NEXT:  }
define <2 x float> @add_scalar_vector(float %a, <2 x float> %b) {
  %s0 = insertelement <2 x float> undef, float %a, i32 0
  %s1 = insertelement <2 x float> %s0, float %a, i32 1
  %res = fadd <2 x float> %s1, %b
  ret <2 x float> %res
}

; CHECK-LABEL: strict_add_scalar_vector:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f32v2add $a0:1, $a0:B, $a2:3
; CHECK-NEXT:  }
define <2 x float> @strict_add_scalar_vector(float %a, <2 x float> %b) {
  %s0 = insertelement <2 x float> undef, float %a, i32 0
  %s1 = insertelement <2 x float> %s0, float %a, i32 1
  %res = call <2 x float> @llvm.experimental.constrained.fadd.v2f32(<2 x float> %s1, <2 x float> %b, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <2 x float> %res
}

; CHECK-LABEL: add_vector_zero:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f32v2add $a0:1, $a0:1, $a14:15
; CHECK-NEXT:  }
define <2 x float> @add_vector_zero(<2 x float> %a) {
    %res = fadd <2 x float> %a, <float 0.0, float 0.0>
    ret <2 x float> %res
}

; CHECK-LABEL: strict_add_vector_zero:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f32v2add $a0:1, $a0:1, $a14:15
; CHECK-NEXT:  }
define <2 x float> @strict_add_vector_zero(<2 x float> %a) {
  %res = call <2 x float> @llvm.experimental.constrained.fadd.v2f32(<2 x float> %a, <2 x float> <float 0.0, float 0.0>, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <2 x float> %res
}

; CHECK-LABEL: add_zero_vector:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f32v2add $a0:1, $a0:1, $a14:15
; CHECK-NEXT:  }
define <2 x float> @add_zero_vector(<2 x float> %a) {
    %res = fadd <2 x float> <float 0.0, float 0.0>, %a
    ret <2 x float> %res
}

; CHECK-LABEL: strict_add_zero_vector:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f32v2add $a0:1, $a14:15, $a0:1
; CHECK-NEXT:  }
define <2 x float> @strict_add_zero_vector(<2 x float> %a) {
  %res = call <2 x float> @llvm.experimental.constrained.fadd.v2f32(<2 x float> <float 0.0, float 0.0>, <2 x float> %a, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <2 x float> %res
}

; CHECK-LABEL: sub_vector_vector:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f32v2sub $a0:1, $a0:1, $a2:3
; CHECK-NEXT:  }
define <2 x float> @sub_vector_vector(<2 x float> %a, <2 x float> %b) {
  %res = fsub <2 x float> %a, %b
  ret <2 x float> %res
}

declare <2 x float> @llvm.experimental.constrained.fsub.v2f32(<2 x float>, <2 x float>, metadata, metadata)

; CHECK-LABEL: strict_sub_vector_vector:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f32v2sub $a0:1, $a0:1, $a2:3
; CHECK-NEXT:  }
define <2 x float> @strict_sub_vector_vector(<2 x float> %a, <2 x float> %b) {
  %res = call <2 x float> @llvm.experimental.constrained.fsub.v2f32(<2 x float> %a, <2 x float> %b, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <2 x float> %res
}

; CHECK-LABEL: sub_vector_scalar:
; CHECK:       # %bb
; CHECK:       mov $a3, $a2
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f32v2sub $a0:1, $a0:1, $a2:3
; CHECK-NEXT:  }
define <2 x float> @sub_vector_scalar(<2 x float> %a, float %b) {
  %s0 = insertelement <2 x float> undef, float %b, i32 0
  %s1 = insertelement <2 x float> %s0, float %b, i32 1
  %res = fsub <2 x float> %a, %s1
  ret <2 x float> %res
}

; CHECK-LABEL: strict_sub_vector_scalar:
; CHECK:       # %bb
; CHECK:       mov $a3, $a2
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f32v2sub $a0:1, $a0:1, $a2:3
; CHECK-NEXT:  }
define <2 x float> @strict_sub_vector_scalar(<2 x float> %a, float %b) {
  %s0 = insertelement <2 x float> undef, float %b, i32 0
  %s1 = insertelement <2 x float> %s0, float %b, i32 1
  %res = call <2 x float> @llvm.experimental.constrained.fsub.v2f32(<2 x float> %a, <2 x float> %s1, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <2 x float> %res
}

; CHECK-LABEL: sub_scalar_vector:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f32v2sub $a0:1, $a0:B, $a2:3
; CHECK-NEXT:  }
define <2 x float> @sub_scalar_vector(float %a, <2 x float> %b) {
  %s0 = insertelement <2 x float> undef, float %a, i32 0
  %s1 = insertelement <2 x float> %s0, float %a, i32 1
  %res = fsub <2 x float> %s1, %b
  ret <2 x float> %res
}

; CHECK-LABEL: strict_sub_scalar_vector:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f32v2sub $a0:1, $a0:B, $a2:3
; CHECK-NEXT:  }
define <2 x float> @strict_sub_scalar_vector(float %a, <2 x float> %b) {
  %s0 = insertelement <2 x float> undef, float %a, i32 0
  %s1 = insertelement <2 x float> %s0, float %a, i32 1
  %res = call <2 x float> @llvm.experimental.constrained.fsub.v2f32(<2 x float> %s1, <2 x float> %b, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <2 x float> %res
}

; CHECK-LABEL: sub_vector_zero:
; CHECK:       # %bb
; CHECK-NEXT:  br $m10
define <2 x float> @sub_vector_zero(<2 x float> %a) {
    %res = fsub <2 x float> %a, <float 0.0, float 0.0>
    ret <2 x float> %res
}

; T29761 tracks the useless f32v2sub
; CHECK-LABEL: strict_sub_vector_zero:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:    br $m10
; CHECK-NEXT:    f32v2sub $a0:1, $a0:1, $a14:15
; CHECK-NEXT:  }
define <2 x float> @strict_sub_vector_zero(<2 x float> %a) {
  %res = call <2 x float> @llvm.experimental.constrained.fsub.v2f32(<2 x float> %a, <2 x float> <float 0.0, float 0.0>, metadata !"round.tonearest", metadata !"fpexcept.strict")
    ret <2 x float> %res
}

; CHECK-LABEL: sub_zero_vector:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f32v2sub $a0:1, $a14:15, $a0:1
; CHECK-NEXT:  }
define <2 x float> @sub_zero_vector(<2 x float> %a) {
    %res = fsub <2 x float> <float 0.0, float 0.0>, %a
    ret <2 x float> %res
}

; CHECK-LABEL: struct_sub_zero_vector:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f32v2sub $a0:1, $a14:15, $a0:1
; CHECK-NEXT:  }
define <2 x float> @struct_sub_zero_vector(<2 x float> %a) {
  %res = call <2 x float> @llvm.experimental.constrained.fsub.v2f32(<2 x float> <float 0.0, float 0.0>, <2 x float> %a, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <2 x float> %res
}

; CHECK-LABEL: mul_vector_vector:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f32v2mul $a0:1, $a0:1, $a2:3
; CHECK-NEXT:  }
define <2 x float> @mul_vector_vector(<2 x float> %a, <2 x float> %b) {
  %res = fmul <2 x float> %a, %b
  ret <2 x float> %res
}

declare <2 x float> @llvm.experimental.constrained.fmul.v2f32(<2 x float>, <2 x float>, metadata, metadata)

; CHECK-LABEL: struct_mul_vector_vector:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f32v2mul $a0:1, $a0:1, $a2:3
; CHECK-NEXT:  }
define <2 x float> @struct_mul_vector_vector(<2 x float> %a, <2 x float> %b) {
  %res = call <2 x float> @llvm.experimental.constrained.fmul.v2f32(<2 x float> %a, <2 x float> %b, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <2 x float> %res
}

; CHECK-LABEL: mul_vector_scalar:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f32v2mul $a0:1, $a2:B, $a0:1
; CHECK-NEXT:  }
define <2 x float> @mul_vector_scalar(<2 x float> %a, float %b) {
  %s0 = insertelement <2 x float> undef, float %b, i32 0
  %s1 = insertelement <2 x float> %s0, float %b, i32 1
  %res = fmul <2 x float> %a, %s1
  ret <2 x float> %res
}

; CHECK-LABEL: strict_mul_vector_scalar:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f32v2mul $a0:1, $a2:B, $a0:1
; CHECK-NEXT:  }
define <2 x float> @strict_mul_vector_scalar(<2 x float> %a, float %b) {
  %s0 = insertelement <2 x float> undef, float %b, i32 0
  %s1 = insertelement <2 x float> %s0, float %b, i32 1
  %res = call <2 x float> @llvm.experimental.constrained.fmul.v2f32(<2 x float> %a, <2 x float> %s1, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <2 x float> %res
}

; CHECK-LABEL: mul_scalar_vector:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f32v2mul $a0:1, $a0:B, $a2:3
; CHECK-NEXT:  }
define <2 x float> @mul_scalar_vector(float %a, <2 x float> %b) {
  %s0 = insertelement <2 x float> undef, float %a, i32 0
  %s1 = insertelement <2 x float> %s0, float %a, i32 1
  %res = fmul <2 x float> %s1, %b
  ret <2 x float> %res
}

; CHECK-LABEL: strict_mul_scalar_vector:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f32v2mul $a0:1, $a0:B, $a2:3
; CHECK-NEXT:  }
define <2 x float> @strict_mul_scalar_vector(float %a, <2 x float> %b) {
  %s0 = insertelement <2 x float> undef, float %a, i32 0
  %s1 = insertelement <2 x float> %s0, float %a, i32 1
  %res = call <2 x float> @llvm.experimental.constrained.fmul.v2f32(<2 x float> %s1, <2 x float> %b, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <2 x float> %res
}

; CHECK-LABEL: mul_vector_zero:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f32v2mul $a0:1, $a0:1, $a14:15
; CHECK-NEXT:  }
define <2 x float> @mul_vector_zero(<2 x float> %a) {
    %res = fmul <2 x float> %a, <float 0.0, float 0.0>
    ret <2 x float> %res
}

; CHECK-LABEL: strict_mul_vector_zero:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f32v2mul $a0:1, $a0:1, $a14:15
; CHECK-NEXT:  }
define <2 x float> @strict_mul_vector_zero(<2 x float> %a) {
  %res = call <2 x float> @llvm.experimental.constrained.fmul.v2f32(<2 x float> %a, <2 x float> <float 0.0, float 0.0>, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <2 x float> %res
}

; CHECK-LABEL: mul_zero_vector:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f32v2mul $a0:1, $a0:1, $a14:15
; CHECK-NEXT:  }
define <2 x float> @mul_zero_vector(<2 x float> %a) {
    %res = fmul <2 x float> <float 0.0, float 0.0>, %a
    ret <2 x float> %res
}

; CHECK-LABEL: strict_mul_zero_vector:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f32v2mul $a0:1, $a14:15, $a0:1
; CHECK-NEXT:  }
define <2 x float> @strict_mul_zero_vector(<2 x float> %a) {
  %res = call <2 x float> @llvm.experimental.constrained.fmul.v2f32(<2 x float> <float 0.0, float 0.0>, <2 x float> %a, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <2 x float> %res
}
