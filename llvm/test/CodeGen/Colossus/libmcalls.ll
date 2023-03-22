; RUN: opt < %s -colossus-libmcalls -S | FileCheck %s

; Transform calls to libm runtime functions into IR intrinsics
; Checks every function in libm that has a corresponding LLVM intrinsic

declare float @ceilf(float %x0)
; CHECK-LABEL: define float @call_ceilf(float %x0) {
; CHECK:         %call = call float @llvm.ceil.f32(float %x0)
; CHECK:         ret float %call
; CHECK:       }
define float @call_ceilf(float %x0) {
  %call = call float @ceilf(float %x0)
  ret float %call
}

; CHECK-LABEL: define float @constrained_call_ceilf(float %x0) #0 {
; CHECK:         %call = call float @llvm.experimental.constrained.ceil.f32(float %x0, metadata !"fpexcept.maytrap")
; CHECK:         ret float %call
; CHECK:       }
define float @constrained_call_ceilf(float %x0) #0 {
  %call = call float @ceilf(float %x0)
  ret float %call
}

declare float @copysignf(float %x0, float %x1)
; CHECK-LABEL: define float @call_copysignf(float %x0, float %x1) {
; CHECK:         %call = call float @llvm.copysign.f32(float %x0, float %x1)
; CHECK:         ret float %call
; CHECK:       }
define float @call_copysignf(float %x0, float %x1) {
  %call = call float @copysignf(float %x0, float %x1)
  ret float %call
}

; CHECK-LABEL: define float @constrained_call_copysignf(float %x0, float %x1) #0 {
; CHECK:         %call = call float @llvm.copysign.f32(float %x0, float %x1)
; CHECK:         ret float %call
; CHECK:       }
define float @constrained_call_copysignf(float %x0, float %x1) #0 {
  %call = call float @copysignf(float %x0, float %x1)
  ret float %call
}

declare float @cosf(float %x0)
; CHECK-LABEL: define float @call_cosf(float %x0) {
; CHECK:         %call = call float @llvm.cos.f32(float %x0)
; CHECK:         ret float %call
; CHECK:       }
define float @call_cosf(float %x0) {
  %call = call float @cosf(float %x0)
  ret float %call
}

; CHECK-LABEL: define float @constrained_call_cosf(float %x0) #0 {
; CHECK:         %call = call float @llvm.experimental.constrained.cos.f32(float %x0, metadata !"round.tonearest", metadata !"fpexcept.maytrap")
; CHECK:         ret float %call
; CHECK:       }
define float @constrained_call_cosf(float %x0) #0 {
  %call = call float @cosf(float %x0)
  ret float %call
}

declare float @expf(float %x0)
; CHECK-LABEL: define float @call_expf(float %x0) {
; CHECK:         %call = call float @llvm.exp.f32(float %x0)
; CHECK:         ret float %call
; CHECK:       }
define float @call_expf(float %x0) {
  %call = call float @expf(float %x0)
  ret float %call
}

; CHECK-LABEL: define float @constrained_call_expf(float %x0) #0 {
; CHECK:         %call = call float @llvm.experimental.constrained.exp.f32(float %x0, metadata !"round.tonearest", metadata !"fpexcept.maytrap")
; CHECK:         ret float %call
; CHECK:       }
define float @constrained_call_expf(float %x0) #0 {
  %call = call float @expf(float %x0)
  ret float %call
}

declare float @exp2f(float %x0)
; CHECK-LABEL: define float @call_exp2f(float %x0) {
; CHECK:         %call = call float @llvm.exp2.f32(float %x0)
; CHECK:         ret float %call
; CHECK:       }
define float @call_exp2f(float %x0) {
  %call = call float @exp2f(float %x0)
  ret float %call
}

; CHECK-LABEL: define float @constrained_call_exp2f(float %x0) #0 {
; CHECK:         %call = call float @llvm.experimental.constrained.exp2.f32(float %x0, metadata !"round.tonearest", metadata !"fpexcept.maytrap")
; CHECK:         ret float %call
; CHECK:       }
define float @constrained_call_exp2f(float %x0) #0 {
  %call = call float @exp2f(float %x0)
  ret float %call
}

declare float @fabsf(float %x0)
; CHECK-LABEL: define float @call_fabsf(float %x0) {
; CHECK:         %call = call float @llvm.fabs.f32(float %x0)
; CHECK:         ret float %call
; CHECK:       }
define float @call_fabsf(float %x0) {
  %call = call float @fabsf(float %x0)
  ret float %call
}

; CHECK-LABEL: define float @constrained_call_fabsf(float %x0) #0 {
; CHECK:         %call = call float @llvm.fabs.f32(float %x0)
; CHECK:         ret float %call
; CHECK:       }
define float @constrained_call_fabsf(float %x0) #0 {
  %call = call float @fabsf(float %x0)
  ret float %call
}

declare float @floorf(float %x0)
; CHECK-LABEL: define float @call_floorf(float %x0) {
; CHECK:         %call = call float @llvm.floor.f32(float %x0)
; CHECK:         ret float %call
; CHECK:       }
define float @call_floorf(float %x0) {
  %call = call float @floorf(float %x0)
  ret float %call
}

; CHECK-LABEL: define float @constrained_call_floorf(float %x0) #0 {
; CHECK:         %call = call float @llvm.experimental.constrained.floor.f32(float %x0, metadata !"fpexcept.maytrap")
; CHECK:         ret float %call
; CHECK:       }
define float @constrained_call_floorf(float %x0) #0 {
  %call = call float @floorf(float %x0)
  ret float %call
}

declare float @fmaf(float %x0, float %x1, float %x2)
; CHECK-LABEL: define float @call_fmaf(float %x0, float %x1, float %x2) {
; CHECK:         %call = call float @llvm.fma.f32(float %x0, float %x1, float %x2)
; CHECK:         ret float %call
; CHECK:       }
define float @call_fmaf(float %x0, float %x1, float %x2) {
  %call = call float @fmaf(float %x0, float %x1, float %x2)
  ret float %call
}

; CHECK-LABEL: define float @constrained_call_fmaf(float %x0, float %x1, float %x2) #0 {
; CHECK:         %call = call float @llvm.experimental.constrained.fma.f32(float %x0, float %x1, float %x2, metadata !"round.tonearest", metadata !"fpexcept.maytrap")
; CHECK:         ret float %call
; CHECK:       }
define float @constrained_call_fmaf(float %x0, float %x1, float %x2) #0 {
  %call = call float @fmaf(float %x0, float %x1, float %x2)
  ret float %call
}

declare float @logf(float %x0)
; CHECK-LABEL: define float @call_logf(float %x0) {
; CHECK:         %call = call float @llvm.log.f32(float %x0)
; CHECK:         ret float %call
; CHECK:       }
define float @call_logf(float %x0) {
  %call = call float @logf(float %x0)
  ret float %call
}

; CHECK-LABEL: define float @constrained_call_logf(float %x0) #0 {
; CHECK:         %call = call float @llvm.experimental.constrained.log.f32(float %x0, metadata !"round.tonearest", metadata !"fpexcept.maytrap")
; CHECK:         ret float %call
; CHECK:       }
define float @constrained_call_logf(float %x0) #0 {
  %call = call float @logf(float %x0)
  ret float %call
}

declare float @log10f(float %x0)
; CHECK-LABEL: define float @call_log10f(float %x0) {
; CHECK:         %call = call float @llvm.log10.f32(float %x0)
; CHECK:         ret float %call
; CHECK:       }
define float @call_log10f(float %x0) {
  %call = call float @log10f(float %x0)
  ret float %call
}

; CHECK-LABEL: define float @constrained_call_log10f(float %x0) #0 {
; CHECK:         %call = call float @llvm.experimental.constrained.log10.f32(float %x0, metadata !"round.tonearest", metadata !"fpexcept.maytrap")
; CHECK:         ret float %call
; CHECK:       }
define float @constrained_call_log10f(float %x0) #0 {
  %call = call float @log10f(float %x0)
  ret float %call
}

declare float @log2f(float %x0)
; CHECK-LABEL: define float @call_log2f(float %x0) {
; CHECK:         %call = call float @llvm.log2.f32(float %x0)
; CHECK:         ret float %call
; CHECK:       }
define float @call_log2f(float %x0) {
  %call = call float @log2f(float %x0)
  ret float %call
}

; CHECK-LABEL: define float @constrained_call_log2f(float %x0) #0 {
; CHECK:         %call = call float @llvm.experimental.constrained.log2.f32(float %x0, metadata !"round.tonearest", metadata !"fpexcept.maytrap")
; CHECK:         ret float %call
; CHECK:       }
define float @constrained_call_log2f(float %x0) #0 {
  %call = call float @log2f(float %x0)
  ret float %call
}

declare float @fmaxf(float %x0, float %x1)
; CHECK-LABEL: define float @call_fmaxf(float %x0, float %x1) {
; CHECK:         %call = call float @llvm.maxnum.f32(float %x0, float %x1)
; CHECK:         ret float %call
; CHECK:       }
define float @call_fmaxf(float %x0, float %x1) {
  %call = call float @fmaxf(float %x0, float %x1)
  ret float %call
}

; CHECK-LABEL: define float @constrained_call_fmaxf(float %x0, float %x1) #0 {
; CHECK:         %call = call float @llvm.experimental.constrained.maxnum.f32(float %x0, float %x1, metadata !"fpexcept.maytrap")
; CHECK:         ret float %call
; CHECK:       }
define float @constrained_call_fmaxf(float %x0, float %x1) #0 {
  %call = call float @fmaxf(float %x0, float %x1)
  ret float %call
}

declare float @fminf(float %x0, float %x1)
; CHECK-LABEL: define float @call_fminf(float %x0, float %x1) {
; CHECK:         %call = call float @llvm.minnum.f32(float %x0, float %x1)
; CHECK:         ret float %call
; CHECK:       }
define float @call_fminf(float %x0, float %x1) {
  %call = call float @fminf(float %x0, float %x1)
  ret float %call
}

; CHECK-LABEL: define float @constrained_call_fminf(float %x0, float %x1) #0 {
; CHECK:         %call = call float @llvm.experimental.constrained.minnum.f32(float %x0, float %x1, metadata !"fpexcept.maytrap")
; CHECK:         ret float %call
; CHECK:       }
define float @constrained_call_fminf(float %x0, float %x1) #0 {
  %call = call float @fminf(float %x0, float %x1)
  ret float %call
}

declare float @nearbyintf(float %x0)
; CHECK-LABEL: define float @call_nearbyintf(float %x0) {
; CHECK:         %call = call float @llvm.nearbyint.f32(float %x0)
; CHECK:         ret float %call
; CHECK:       }
define float @call_nearbyintf(float %x0) {
  %call = call float @nearbyintf(float %x0)
  ret float %call
}

; CHECK-LABEL: define float @constrained_call_nearbyintf(float %x0) #0 {
; CHECK:         %call = call float @llvm.experimental.constrained.nearbyint.f32(float %x0, metadata !"round.tonearest", metadata !"fpexcept.maytrap")
; CHECK:         ret float %call
; CHECK:       }
define float @constrained_call_nearbyintf(float %x0) #0 {
  %call = call float @nearbyintf(float %x0)
  ret float %call
}

declare float @powf(float %x0, float %x1)
; CHECK-LABEL: define float @call_powf(float %x0, float %x1) {
; CHECK:         %call = call float @llvm.pow.f32(float %x0, float %x1)
; CHECK:         ret float %call
; CHECK:       }
define float @call_powf(float %x0, float %x1) {
  %call = call float @powf(float %x0, float %x1)
  ret float %call
}

; CHECK-LABEL: define float @constrained_call_powf(float %x0, float %x1) #0 {
; CHECK:         %call = call float @llvm.experimental.constrained.pow.f32(float %x0, float %x1, metadata !"round.tonearest", metadata !"fpexcept.maytrap")
; CHECK:         ret float %call
; CHECK:       }
define float @constrained_call_powf(float %x0, float %x1) #0 {
  %call = call float @powf(float %x0, float %x1)
  ret float %call
}

declare float @rintf(float %x0)
; CHECK-LABEL: define float @call_rintf(float %x0) {
; CHECK:         %call = call float @llvm.rint.f32(float %x0)
; CHECK:         ret float %call
; CHECK:       }
define float @call_rintf(float %x0) {
  %call = call float @rintf(float %x0)
  ret float %call
}

; CHECK-LABEL: define float @constrained_call_rintf(float %x0) #0 {
; CHECK:         %call = call float @llvm.experimental.constrained.rint.f32(float %x0, metadata !"round.tonearest", metadata !"fpexcept.maytrap")
; CHECK:         ret float %call
; CHECK:       }
define float @constrained_call_rintf(float %x0) #0 {
  %call = call float @rintf(float %x0)
  ret float %call
}

declare float @roundf(float %x0)
; CHECK-LABEL: define float @call_roundf(float %x0) {
; CHECK:         %call = call float @llvm.round.f32(float %x0)
; CHECK:         ret float %call
; CHECK:       }
define float @call_roundf(float %x0) {
  %call = call float @roundf(float %x0)
  ret float %call
}

; CHECK-LABEL: define float @constrained_call_roundf(float %x0) #0 {
; CHECK:         %call = call float @llvm.experimental.constrained.round.f32(float %x0, metadata !"fpexcept.maytrap")
; CHECK:         ret float %call
; CHECK:       }
define float @constrained_call_roundf(float %x0) #0 {
  %call = call float @roundf(float %x0)
  ret float %call
}

declare float @sinf(float %x0)
; CHECK-LABEL: define float @call_sinf(float %x0) {
; CHECK:         %call = call float @llvm.sin.f32(float %x0)
; CHECK:         ret float %call
; CHECK:       }
define float @call_sinf(float %x0) {
  %call = call float @sinf(float %x0)
  ret float %call
}

; CHECK-LABEL: define float @constrained_call_sinf(float %x0) #0 {
; CHECK:         %call = call float @llvm.experimental.constrained.sin.f32(float %x0, metadata !"round.tonearest", metadata !"fpexcept.maytrap")
; CHECK:         ret float %call
; CHECK:       }
define float @constrained_call_sinf(float %x0) #0 {
  %call = call float @sinf(float %x0)
  ret float %call
}

declare float @sqrtf(float %x0)
; CHECK-LABEL: define float @call_sqrtf(float %x0) {
; CHECK:         %call = call float @llvm.sqrt.f32(float %x0)
; CHECK:         ret float %call
; CHECK:       }
define float @call_sqrtf(float %x0) {
  %call = call float @sqrtf(float %x0)
  ret float %call
}

; CHECK-LABEL: define float @constrained_call_sqrtf(float %x0) #0 {
; CHECK:         %call = call float @llvm.experimental.constrained.sqrt.f32(float %x0, metadata !"round.tonearest", metadata !"fpexcept.maytrap")
; CHECK:         ret float %call
; CHECK:       }
define float @constrained_call_sqrtf(float %x0) #0 {
  %call = call float @sqrtf(float %x0)
  ret float %call
}

declare float @tanhf(float %x0)
; CHECK-LABEL: define float @call_tanhf(float %x0) {
; CHECK:         %call = call float @llvm.colossus.tanh.f32(float %x0)
; CHECK:         ret float %call
; CHECK:       }
define float @call_tanhf(float %x0) {
  %call = call float @tanhf(float %x0)
  ret float %call
}

; CHECK-LABEL: define float @constrained_call_tanhf(float %x0) #0 {
; CHECK:         %call = call float @llvm.colossus.tanh.f32(float %x0)
; CHECK:         ret float %call
; CHECK:       }
define float @constrained_call_tanhf(float %x0) #0 {
  %call = call float @tanhf(float %x0)
  ret float %call
}

declare float @rsqrtf(float %x0)
; CHECK-LABEL: define float @call_rsqrtf(float %x0) {
; CHECK:         %call = call float @llvm.colossus.rsqrt.f32(float %x0)
; CHECK:         ret float %call
; CHECK:       }
define float @call_rsqrtf(float %x0) {
  %call = call float @rsqrtf(float %x0)
  ret float %call
}

; CHECK-LABEL: define float @constrained_call_rsqrtf(float %x0) #0 {
; CHECK:         %call = call float @llvm.colossus.rsqrt.f32(float %x0)
; CHECK:         ret float %call
; CHECK:       }
define float @constrained_call_rsqrtf(float %x0) #0 {
  %call = call float @rsqrtf(float %x0)
  ret float %call
}

declare float @sigmoidf(float %x0)
; CHECK-LABEL: define float @call_sigmoidf(float %x0) {
; CHECK:         %call = call float @llvm.colossus.sigmoid.f32(float %x0)
; CHECK:         ret float %call
; CHECK:       }
define float @call_sigmoidf(float %x0) {
  %call = call float @sigmoidf(float %x0)
  ret float %call
}

; CHECK-LABEL: define float @constrained_call_sigmoidf(float %x0) #0 {
; CHECK:         %call = call float @llvm.colossus.sigmoid.f32(float %x0)
; CHECK:         ret float %call
; CHECK:       }
define float @constrained_call_sigmoidf(float %x0) #0 {
  %call = call float @sigmoidf(float %x0)
  ret float %call
}

declare float @truncf(float %x0)
; CHECK-LABEL: define float @call_truncf(float %x0) {
; CHECK:         %call = call float @llvm.trunc.f32(float %x0)
; CHECK:         ret float %call
; CHECK:       }
define float @call_truncf(float %x0) {
  %call = call float @truncf(float %x0)
  ret float %call
}

; CHECK-LABEL: define float @constrained_call_truncf(float %x0) #0 {
; CHECK:         %call = call float @llvm.experimental.constrained.trunc.f32(float %x0, metadata !"fpexcept.maytrap")
; CHECK:         ret float %call
; CHECK:       }
define float @constrained_call_truncf(float %x0) #0 {
  %call = call float @truncf(float %x0)
  ret float %call
}

declare <2 x float> @float2_ceil(<2 x float> %x0)
; CHECK-LABEL: define <2 x float> @call_float2_ceil(<2 x float> %x0) {
; CHECK:         %call = call <2 x float> @llvm.ceil.v2f32(<2 x float> %x0)
; CHECK:         ret <2 x float> %call
; CHECK:       }
define <2 x float> @call_float2_ceil(<2 x float> %x0) {
  %call = call <2 x float> @float2_ceil(<2 x float> %x0)
  ret <2 x float> %call
}

; CHECK-LABEL: define <2 x float> @constrained_call_float2_ceil(<2 x float> %x0) #0 {
; CHECK:         %call = call <2 x float> @llvm.experimental.constrained.ceil.v2f32(<2 x float> %x0, metadata !"fpexcept.maytrap")
; CHECK:         ret <2 x float> %call
; CHECK:       }
define <2 x float> @constrained_call_float2_ceil(<2 x float> %x0) #0 {
  %call = call <2 x float> @float2_ceil(<2 x float> %x0)
  ret <2 x float> %call
}

declare <2 x float> @float2_copysign(<2 x float> %x0, <2 x float> %x1)
; CHECK-LABEL: define <2 x float> @call_float2_copysign(<2 x float> %x0, <2 x float> %x1) {
; CHECK:         %call = call <2 x float> @llvm.copysign.v2f32(<2 x float> %x0, <2 x float> %x1)
; CHECK:         ret <2 x float> %call
; CHECK:       }
define <2 x float> @call_float2_copysign(<2 x float> %x0, <2 x float> %x1) {
  %call = call <2 x float> @float2_copysign(<2 x float> %x0, <2 x float> %x1)
  ret <2 x float> %call
}

; CHECK-LABEL: define <2 x float> @constrained_call_float2_copysign(<2 x float> %x0, <2 x float> %x1) #0 {
; CHECK:         %call = call <2 x float> @llvm.copysign.v2f32(<2 x float> %x0, <2 x float> %x1)
; CHECK:         ret <2 x float> %call
; CHECK:       }
define <2 x float> @constrained_call_float2_copysign(<2 x float> %x0, <2 x float> %x1) #0 {
  %call = call <2 x float> @float2_copysign(<2 x float> %x0, <2 x float> %x1)
  ret <2 x float> %call
}

declare <2 x float> @float2_cos(<2 x float> %x0)
; CHECK-LABEL: define <2 x float> @call_float2_cos(<2 x float> %x0) {
; CHECK:         %call = call <2 x float> @llvm.cos.v2f32(<2 x float> %x0)
; CHECK:         ret <2 x float> %call
; CHECK:       }
define <2 x float> @call_float2_cos(<2 x float> %x0) {
  %call = call <2 x float> @float2_cos(<2 x float> %x0)
  ret <2 x float> %call
}

; CHECK-LABEL: define <2 x float> @constrained_call_float2_cos(<2 x float> %x0) #0 {
; CHECK:         %call = call <2 x float> @llvm.experimental.constrained.cos.v2f32(<2 x float> %x0, metadata !"round.tonearest", metadata !"fpexcept.maytrap")
; CHECK:         ret <2 x float> %call
; CHECK:       }
define <2 x float> @constrained_call_float2_cos(<2 x float> %x0) #0 {
  %call = call <2 x float> @float2_cos(<2 x float> %x0)
  ret <2 x float> %call
}

declare <2 x float> @float2_exp(<2 x float> %x0)
; CHECK-LABEL: define <2 x float> @call_float2_exp(<2 x float> %x0) {
; CHECK:         %call = call <2 x float> @llvm.exp.v2f32(<2 x float> %x0)
; CHECK:         ret <2 x float> %call
; CHECK:       }
define <2 x float> @call_float2_exp(<2 x float> %x0) {
  %call = call <2 x float> @float2_exp(<2 x float> %x0)
  ret <2 x float> %call
}

; CHECK-LABEL: define <2 x float> @constrained_call_float2_exp(<2 x float> %x0) #0 {
; CHECK:         %call = call <2 x float> @llvm.experimental.constrained.exp.v2f32(<2 x float> %x0, metadata !"round.tonearest", metadata !"fpexcept.maytrap")
; CHECK:         ret <2 x float> %call
; CHECK:       }
define <2 x float> @constrained_call_float2_exp(<2 x float> %x0) #0 {
  %call = call <2 x float> @float2_exp(<2 x float> %x0)
  ret <2 x float> %call
}

declare <2 x float> @float2_exp2(<2 x float> %x0)
; CHECK-LABEL: define <2 x float> @call_float2_exp2(<2 x float> %x0) {
; CHECK:         %call = call <2 x float> @llvm.exp2.v2f32(<2 x float> %x0)
; CHECK:         ret <2 x float> %call
; CHECK:       }
define <2 x float> @call_float2_exp2(<2 x float> %x0) {
  %call = call <2 x float> @float2_exp2(<2 x float> %x0)
  ret <2 x float> %call
}

; CHECK-LABEL: define <2 x float> @constrained_call_float2_exp2(<2 x float> %x0) #0 {
; CHECK:         %call = call <2 x float> @llvm.experimental.constrained.exp2.v2f32(<2 x float> %x0, metadata !"round.tonearest", metadata !"fpexcept.maytrap")
; CHECK:         ret <2 x float> %call
; CHECK:       }
define <2 x float> @constrained_call_float2_exp2(<2 x float> %x0) #0 {
  %call = call <2 x float> @float2_exp2(<2 x float> %x0)
  ret <2 x float> %call
}

declare <2 x float> @float2_fabs(<2 x float> %x0)
; CHECK-LABEL: define <2 x float> @call_float2_fabs(<2 x float> %x0) {
; CHECK:         %call = call <2 x float> @llvm.fabs.v2f32(<2 x float> %x0)
; CHECK:         ret <2 x float> %call
; CHECK:       }
define <2 x float> @call_float2_fabs(<2 x float> %x0) {
  %call = call <2 x float> @float2_fabs(<2 x float> %x0)
  ret <2 x float> %call
}

; CHECK-LABEL: define <2 x float> @constrained_call_float2_fabs(<2 x float> %x0) #0 {
; CHECK:         %call = call <2 x float> @llvm.fabs.v2f32(<2 x float> %x0)
; CHECK:         ret <2 x float> %call
; CHECK:       }
define <2 x float> @constrained_call_float2_fabs(<2 x float> %x0) #0 {
  %call = call <2 x float> @float2_fabs(<2 x float> %x0)
  ret <2 x float> %call
}

declare <2 x float> @float2_floor(<2 x float> %x0)
; CHECK-LABEL: define <2 x float> @call_float2_floor(<2 x float> %x0) {
; CHECK:         %call = call <2 x float> @llvm.floor.v2f32(<2 x float> %x0)
; CHECK:         ret <2 x float> %call
; CHECK:       }
define <2 x float> @call_float2_floor(<2 x float> %x0) {
  %call = call <2 x float> @float2_floor(<2 x float> %x0)
  ret <2 x float> %call
}

; CHECK-LABEL: define <2 x float> @constrained_call_float2_floor(<2 x float> %x0) #0 {
; CHECK:         %call = call <2 x float> @llvm.experimental.constrained.floor.v2f32(<2 x float> %x0, metadata !"fpexcept.maytrap")
; CHECK:         ret <2 x float> %call
; CHECK:       }
define <2 x float> @constrained_call_float2_floor(<2 x float> %x0) #0 {
  %call = call <2 x float> @float2_floor(<2 x float> %x0)
  ret <2 x float> %call
}

declare <2 x float> @float2_fma(<2 x float> %x0, <2 x float> %x1, <2 x float> %x2)
; CHECK-LABEL: define <2 x float> @call_float2_fma(<2 x float> %x0, <2 x float> %x1, <2 x float> %x2) {
; CHECK:         %call = call <2 x float> @llvm.fma.v2f32(<2 x float> %x0, <2 x float> %x1, <2 x float> %x2)
; CHECK:         ret <2 x float> %call
; CHECK:       }
define <2 x float> @call_float2_fma(<2 x float> %x0, <2 x float> %x1, <2 x float> %x2) {
  %call = call <2 x float> @float2_fma(<2 x float> %x0, <2 x float> %x1, <2 x float> %x2)
  ret <2 x float> %call
}

; CHECK-LABEL: define <2 x float> @constrained_call_float2_fma(<2 x float> %x0, <2 x float> %x1, <2 x float> %x2) #0 {
; CHECK:         %call = call <2 x float> @llvm.experimental.constrained.fma.v2f32(<2 x float> %x0, <2 x float> %x1, <2 x float> %x2, metadata !"round.tonearest", metadata !"fpexcept.maytrap")
; CHECK:         ret <2 x float> %call
; CHECK:       }
define <2 x float> @constrained_call_float2_fma(<2 x float> %x0, <2 x float> %x1, <2 x float> %x2) #0 {
  %call = call <2 x float> @float2_fma(<2 x float> %x0, <2 x float> %x1, <2 x float> %x2)
  ret <2 x float> %call
}

declare <2 x float> @float2_log(<2 x float> %x0)
; CHECK-LABEL: define <2 x float> @call_float2_log(<2 x float> %x0) {
; CHECK:         %call = call <2 x float> @llvm.log.v2f32(<2 x float> %x0)
; CHECK:         ret <2 x float> %call
; CHECK:       }
define <2 x float> @call_float2_log(<2 x float> %x0) {
  %call = call <2 x float> @float2_log(<2 x float> %x0)
  ret <2 x float> %call
}

; CHECK-LABEL: define <2 x float> @constrained_call_float2_log(<2 x float> %x0) #0 {
; CHECK:         %call = call <2 x float> @llvm.experimental.constrained.log.v2f32(<2 x float> %x0, metadata !"round.tonearest", metadata !"fpexcept.maytrap")
; CHECK:         ret <2 x float> %call
; CHECK:       }
define <2 x float> @constrained_call_float2_log(<2 x float> %x0) #0 {
  %call = call <2 x float> @float2_log(<2 x float> %x0)
  ret <2 x float> %call
}

declare <2 x float> @float2_log10(<2 x float> %x0)
; CHECK-LABEL: define <2 x float> @call_float2_log10(<2 x float> %x0) {
; CHECK:         %call = call <2 x float> @llvm.log10.v2f32(<2 x float> %x0)
; CHECK:         ret <2 x float> %call
; CHECK:       }
define <2 x float> @call_float2_log10(<2 x float> %x0) {
  %call = call <2 x float> @float2_log10(<2 x float> %x0)
  ret <2 x float> %call
}

; CHECK-LABEL: define <2 x float> @constrained_call_float2_log10(<2 x float> %x0) #0 {
; CHECK:         %call = call <2 x float> @llvm.experimental.constrained.log10.v2f32(<2 x float> %x0, metadata !"round.tonearest", metadata !"fpexcept.maytrap")
; CHECK:         ret <2 x float> %call
; CHECK:       }
define <2 x float> @constrained_call_float2_log10(<2 x float> %x0) #0 {
  %call = call <2 x float> @float2_log10(<2 x float> %x0)
  ret <2 x float> %call
}

declare <2 x float> @float2_log2(<2 x float> %x0)
; CHECK-LABEL: define <2 x float> @call_float2_log2(<2 x float> %x0) {
; CHECK:         %call = call <2 x float> @llvm.log2.v2f32(<2 x float> %x0)
; CHECK:         ret <2 x float> %call
; CHECK:       }
define <2 x float> @call_float2_log2(<2 x float> %x0) {
  %call = call <2 x float> @float2_log2(<2 x float> %x0)
  ret <2 x float> %call
}

; CHECK-LABEL: define <2 x float> @constrained_call_float2_log2(<2 x float> %x0) #0 {
; CHECK:         %call = call <2 x float> @llvm.experimental.constrained.log2.v2f32(<2 x float> %x0, metadata !"round.tonearest", metadata !"fpexcept.maytrap")
; CHECK:         ret <2 x float> %call
; CHECK:       }
define <2 x float> @constrained_call_float2_log2(<2 x float> %x0) #0 {
  %call = call <2 x float> @float2_log2(<2 x float> %x0)
  ret <2 x float> %call
}

declare <2 x float> @float2_fmax(<2 x float> %x0, <2 x float> %x1)
; CHECK-LABEL: define <2 x float> @call_float2_fmax(<2 x float> %x0, <2 x float> %x1) {
; CHECK:         %call = call <2 x float> @llvm.maxnum.v2f32(<2 x float> %x0, <2 x float> %x1)
; CHECK:         ret <2 x float> %call
; CHECK:       }
define <2 x float> @call_float2_fmax(<2 x float> %x0, <2 x float> %x1) {
  %call = call <2 x float> @float2_fmax(<2 x float> %x0, <2 x float> %x1)
  ret <2 x float> %call
}

; CHECK-LABEL: define <2 x float> @constrained_call_float2_fmax(<2 x float> %x0, <2 x float> %x1) #0 {
; CHECK:         %call = call <2 x float> @llvm.experimental.constrained.maxnum.v2f32(<2 x float> %x0, <2 x float> %x1, metadata !"fpexcept.maytrap")
; CHECK:         ret <2 x float> %call
; CHECK:       }
define <2 x float> @constrained_call_float2_fmax(<2 x float> %x0, <2 x float> %x1) #0 {
  %call = call <2 x float> @float2_fmax(<2 x float> %x0, <2 x float> %x1)
  ret <2 x float> %call
}

declare <2 x float> @float2_fmin(<2 x float> %x0, <2 x float> %x1)
; CHECK-LABEL: define <2 x float> @call_float2_fmin(<2 x float> %x0, <2 x float> %x1) {
; CHECK:         %call = call <2 x float> @llvm.minnum.v2f32(<2 x float> %x0, <2 x float> %x1)
; CHECK:         ret <2 x float> %call
; CHECK:       }
define <2 x float> @call_float2_fmin(<2 x float> %x0, <2 x float> %x1) {
  %call = call <2 x float> @float2_fmin(<2 x float> %x0, <2 x float> %x1)
  ret <2 x float> %call
}

; CHECK-LABEL: define <2 x float> @constrained_call_float2_fmin(<2 x float> %x0, <2 x float> %x1) #0 {
; CHECK:         %call = call <2 x float> @llvm.experimental.constrained.minnum.v2f32(<2 x float> %x0, <2 x float> %x1, metadata !"fpexcept.maytrap")
; CHECK:         ret <2 x float> %call
; CHECK:       }
define <2 x float> @constrained_call_float2_fmin(<2 x float> %x0, <2 x float> %x1) #0 {
  %call = call <2 x float> @float2_fmin(<2 x float> %x0, <2 x float> %x1)
  ret <2 x float> %call
}

declare <2 x float> @float2_nearbyint(<2 x float> %x0)
; CHECK-LABEL: define <2 x float> @call_float2_nearbyint(<2 x float> %x0) {
; CHECK:         %call = call <2 x float> @llvm.nearbyint.v2f32(<2 x float> %x0)
; CHECK:         ret <2 x float> %call
; CHECK:       }
define <2 x float> @call_float2_nearbyint(<2 x float> %x0) {
  %call = call <2 x float> @float2_nearbyint(<2 x float> %x0)
  ret <2 x float> %call
}

; CHECK-LABEL: define <2 x float> @constrained_call_float2_nearbyint(<2 x float> %x0) #0 {
; CHECK:         %call = call <2 x float> @llvm.experimental.constrained.nearbyint.v2f32(<2 x float> %x0, metadata !"round.tonearest", metadata !"fpexcept.maytrap")
; CHECK:         ret <2 x float> %call
; CHECK:       }
define <2 x float> @constrained_call_float2_nearbyint(<2 x float> %x0) #0 {
  %call = call <2 x float> @float2_nearbyint(<2 x float> %x0)
  ret <2 x float> %call
}

declare <2 x float> @float2_pow(<2 x float> %x0, <2 x float> %x1)
; CHECK-LABEL: define <2 x float> @call_float2_pow(<2 x float> %x0, <2 x float> %x1) {
; CHECK:         %call = call <2 x float> @llvm.pow.v2f32(<2 x float> %x0, <2 x float> %x1)
; CHECK:         ret <2 x float> %call
; CHECK:       }
define <2 x float> @call_float2_pow(<2 x float> %x0, <2 x float> %x1) {
  %call = call <2 x float> @float2_pow(<2 x float> %x0, <2 x float> %x1)
  ret <2 x float> %call
}

; CHECK-LABEL: define <2 x float> @constrained_call_float2_pow(<2 x float> %x0, <2 x float> %x1) #0 {
; CHECK:         %call = call <2 x float> @llvm.experimental.constrained.pow.v2f32(<2 x float> %x0, <2 x float> %x1, metadata !"round.tonearest", metadata !"fpexcept.maytrap")
; CHECK:         ret <2 x float> %call
; CHECK:       }
define <2 x float> @constrained_call_float2_pow(<2 x float> %x0, <2 x float> %x1) #0 {
  %call = call <2 x float> @float2_pow(<2 x float> %x0, <2 x float> %x1)
  ret <2 x float> %call
}

declare <2 x float> @float2_rint(<2 x float> %x0)
; CHECK-LABEL: define <2 x float> @call_float2_rint(<2 x float> %x0) {
; CHECK:         %call = call <2 x float> @llvm.rint.v2f32(<2 x float> %x0)
; CHECK:         ret <2 x float> %call
; CHECK:       }
define <2 x float> @call_float2_rint(<2 x float> %x0) {
  %call = call <2 x float> @float2_rint(<2 x float> %x0)
  ret <2 x float> %call
}

; CHECK-LABEL: define <2 x float> @constrained_call_float2_rint(<2 x float> %x0) #0 {
; CHECK:         %call = call <2 x float> @llvm.experimental.constrained.rint.v2f32(<2 x float> %x0, metadata !"round.tonearest", metadata !"fpexcept.maytrap")
; CHECK:         ret <2 x float> %call
; CHECK:       }
define <2 x float> @constrained_call_float2_rint(<2 x float> %x0) #0 {
  %call = call <2 x float> @float2_rint(<2 x float> %x0)
  ret <2 x float> %call
}

declare <2 x float> @float2_round(<2 x float> %x0)
; CHECK-LABEL: define <2 x float> @call_float2_round(<2 x float> %x0) {
; CHECK:         %call = call <2 x float> @llvm.round.v2f32(<2 x float> %x0)
; CHECK:         ret <2 x float> %call
; CHECK:       }
define <2 x float> @call_float2_round(<2 x float> %x0) {
  %call = call <2 x float> @float2_round(<2 x float> %x0)
  ret <2 x float> %call
}

; CHECK-LABEL: define <2 x float> @constrained_call_float2_round(<2 x float> %x0) #0 {
; CHECK:         %call = call <2 x float> @llvm.experimental.constrained.round.v2f32(<2 x float> %x0, metadata !"fpexcept.maytrap")
; CHECK:         ret <2 x float> %call
; CHECK:       }
define <2 x float> @constrained_call_float2_round(<2 x float> %x0) #0 {
  %call = call <2 x float> @float2_round(<2 x float> %x0)
  ret <2 x float> %call
}

declare <2 x float> @float2_sin(<2 x float> %x0)
; CHECK-LABEL: define <2 x float> @call_float2_sin(<2 x float> %x0) {
; CHECK:         %call = call <2 x float> @llvm.sin.v2f32(<2 x float> %x0)
; CHECK:         ret <2 x float> %call
; CHECK:       }
define <2 x float> @call_float2_sin(<2 x float> %x0) {
  %call = call <2 x float> @float2_sin(<2 x float> %x0)
  ret <2 x float> %call
}

; CHECK-LABEL: define <2 x float> @constrained_call_float2_sin(<2 x float> %x0) #0 {
; CHECK:         %call = call <2 x float> @llvm.experimental.constrained.sin.v2f32(<2 x float> %x0, metadata !"round.tonearest", metadata !"fpexcept.maytrap")
; CHECK:         ret <2 x float> %call
; CHECK:       }
define <2 x float> @constrained_call_float2_sin(<2 x float> %x0) #0 {
  %call = call <2 x float> @float2_sin(<2 x float> %x0)
  ret <2 x float> %call
}

declare <2 x float> @float2_sqrt(<2 x float> %x0)
; CHECK-LABEL: define <2 x float> @call_float2_sqrt(<2 x float> %x0) {
; CHECK:         %call = call <2 x float> @llvm.sqrt.v2f32(<2 x float> %x0)
; CHECK:         ret <2 x float> %call
; CHECK:       }
define <2 x float> @call_float2_sqrt(<2 x float> %x0) {
  %call = call <2 x float> @float2_sqrt(<2 x float> %x0)
  ret <2 x float> %call
}

; CHECK-LABEL: define <2 x float> @constrained_call_float2_sqrt(<2 x float> %x0) #0 {
; CHECK:         %call = call <2 x float> @llvm.experimental.constrained.sqrt.v2f32(<2 x float> %x0, metadata !"round.tonearest", metadata !"fpexcept.maytrap")
; CHECK:         ret <2 x float> %call
; CHECK:       }
define <2 x float> @constrained_call_float2_sqrt(<2 x float> %x0) #0 {
  %call = call <2 x float> @float2_sqrt(<2 x float> %x0)
  ret <2 x float> %call
}

declare <2 x float> @float2_tanh(<2 x float> %x0)
; CHECK-LABEL: define <2 x float> @call_float2_tanh(<2 x float> %x0) {
; CHECK:         %call = call <2 x float> @llvm.colossus.tanh.v2f32(<2 x float> %x0)
; CHECK:         ret <2 x float> %call
; CHECK:       }
define <2 x float> @call_float2_tanh(<2 x float> %x0) {
  %call = call <2 x float> @float2_tanh(<2 x float> %x0)
  ret <2 x float> %call
}

; CHECK-LABEL: define <2 x float> @constrained_call_float2_tanh(<2 x float> %x0) #0 {
; CHECK:         %call = call <2 x float> @llvm.colossus.tanh.v2f32(<2 x float> %x0)
; CHECK:         ret <2 x float> %call
; CHECK:       }
define <2 x float> @constrained_call_float2_tanh(<2 x float> %x0) #0 {
  %call = call <2 x float> @float2_tanh(<2 x float> %x0)
  ret <2 x float> %call
}

declare <2 x float> @float2_rsqrt(<2 x float> %x0)
; CHECK-LABEL: define <2 x float> @call_float2_rsqrt(<2 x float> %x0) {
; CHECK:         %call = call <2 x float> @llvm.colossus.rsqrt.v2f32(<2 x float> %x0)
; CHECK:         ret <2 x float> %call
; CHECK:       }
define <2 x float> @call_float2_rsqrt(<2 x float> %x0) {
  %call = call <2 x float> @float2_rsqrt(<2 x float> %x0)
  ret <2 x float> %call
}

; CHECK-LABEL: define <2 x float> @constrained_call_float2_rsqrt(<2 x float> %x0) #0 {
; CHECK:         %call = call <2 x float> @llvm.colossus.rsqrt.v2f32(<2 x float> %x0)
; CHECK:         ret <2 x float> %call
; CHECK:       }
define <2 x float> @constrained_call_float2_rsqrt(<2 x float> %x0) #0 {
  %call = call <2 x float> @float2_rsqrt(<2 x float> %x0)
  ret <2 x float> %call
}

declare <2 x float> @float2_sigmoid(<2 x float> %x0)
; CHECK-LABEL: define <2 x float> @call_float2_sigmoid(<2 x float> %x0) {
; CHECK:         %call = call <2 x float> @llvm.colossus.sigmoid.v2f32(<2 x float> %x0)
; CHECK:         ret <2 x float> %call
; CHECK:       }
define <2 x float> @call_float2_sigmoid(<2 x float> %x0) {
  %call = call <2 x float> @float2_sigmoid(<2 x float> %x0)
  ret <2 x float> %call
}

; CHECK-LABEL: define <2 x float> @constrained_call_float2_sigmoid(<2 x float> %x0) #0 {
; CHECK:         %call = call <2 x float> @llvm.colossus.sigmoid.v2f32(<2 x float> %x0)
; CHECK:         ret <2 x float> %call
; CHECK:       }
define <2 x float> @constrained_call_float2_sigmoid(<2 x float> %x0) #0 {
  %call = call <2 x float> @float2_sigmoid(<2 x float> %x0)
  ret <2 x float> %call
}

declare <2 x float> @float2_trunc(<2 x float> %x0)
; CHECK-LABEL: define <2 x float> @call_float2_trunc(<2 x float> %x0) {
; CHECK:         %call = call <2 x float> @llvm.trunc.v2f32(<2 x float> %x0)
; CHECK:         ret <2 x float> %call
; CHECK:       }
define <2 x float> @call_float2_trunc(<2 x float> %x0) {
  %call = call <2 x float> @float2_trunc(<2 x float> %x0)
  ret <2 x float> %call
}

; CHECK-LABEL: define <2 x float> @constrained_call_float2_trunc(<2 x float> %x0) #0 {
; CHECK:         %call = call <2 x float> @llvm.experimental.constrained.trunc.v2f32(<2 x float> %x0, metadata !"fpexcept.maytrap")
; CHECK:         ret <2 x float> %call
; CHECK:       }
define <2 x float> @constrained_call_float2_trunc(<2 x float> %x0) #0 {
  %call = call <2 x float> @float2_trunc(<2 x float> %x0)
  ret <2 x float> %call
}

declare half @half_ceil(half %x0)
; CHECK-LABEL: define half @call_half_ceil(half %x0) {
; CHECK:         %call = call half @llvm.ceil.f16(half %x0)
; CHECK:         ret half %call
; CHECK:       }
define half @call_half_ceil(half %x0) {
  %call = call half @half_ceil(half %x0)
  ret half %call
}

; CHECK-LABEL: define half @constrained_call_half_ceil(half %x0) #0 {
; CHECK:         %call = call half @llvm.experimental.constrained.ceil.f16(half %x0, metadata !"fpexcept.maytrap")
; CHECK:         ret half %call
; CHECK:       }
define half @constrained_call_half_ceil(half %x0) #0 {
  %call = call half @half_ceil(half %x0)
  ret half %call
}

declare half @half_copysign(half %x0, half %x1)
; CHECK-LABEL: define half @call_half_copysign(half %x0, half %x1) {
; CHECK:         %call = call half @llvm.copysign.f16(half %x0, half %x1)
; CHECK:         ret half %call
; CHECK:       }
define half @call_half_copysign(half %x0, half %x1) {
  %call = call half @half_copysign(half %x0, half %x1)
  ret half %call
}

; CHECK-LABEL: define half @constrained_call_half_copysign(half %x0, half %x1) #0 {
; CHECK:         %call = call half @llvm.copysign.f16(half %x0, half %x1)
; CHECK:         ret half %call
; CHECK:       }
define half @constrained_call_half_copysign(half %x0, half %x1) #0 {
  %call = call half @half_copysign(half %x0, half %x1)
  ret half %call
}

declare half @half_cos(half %x0)
; CHECK-LABEL: define half @call_half_cos(half %x0) {
; CHECK:         %call = call half @llvm.cos.f16(half %x0)
; CHECK:         ret half %call
; CHECK:       }
define half @call_half_cos(half %x0) {
  %call = call half @half_cos(half %x0)
  ret half %call
}

; CHECK-LABEL: define half @constrained_call_half_cos(half %x0) #0 {
; CHECK:         %call = call half @llvm.experimental.constrained.cos.f16(half %x0, metadata !"round.tonearest", metadata !"fpexcept.maytrap")
; CHECK:         ret half %call
; CHECK:       }
define half @constrained_call_half_cos(half %x0) #0 {
  %call = call half @half_cos(half %x0)
  ret half %call
}

declare half @half_exp(half %x0)
; CHECK-LABEL: define half @call_half_exp(half %x0) {
; CHECK:         %call = call half @llvm.exp.f16(half %x0)
; CHECK:         ret half %call
; CHECK:       }
define half @call_half_exp(half %x0) {
  %call = call half @half_exp(half %x0)
  ret half %call
}

; CHECK-LABEL: define half @constrained_call_half_exp(half %x0) #0 {
; CHECK:         %call = call half @llvm.experimental.constrained.exp.f16(half %x0, metadata !"round.tonearest", metadata !"fpexcept.maytrap")
; CHECK:         ret half %call
; CHECK:       }
define half @constrained_call_half_exp(half %x0) #0 {
  %call = call half @half_exp(half %x0)
  ret half %call
}

declare half @half_exp2(half %x0)
; CHECK-LABEL: define half @call_half_exp2(half %x0) {
; CHECK:         %call = call half @llvm.exp2.f16(half %x0)
; CHECK:         ret half %call
; CHECK:       }
define half @call_half_exp2(half %x0) {
  %call = call half @half_exp2(half %x0)
  ret half %call
}

; CHECK-LABEL: define half @constrained_call_half_exp2(half %x0) #0 {
; CHECK:         %call = call half @llvm.experimental.constrained.exp2.f16(half %x0, metadata !"round.tonearest", metadata !"fpexcept.maytrap")
; CHECK:         ret half %call
; CHECK:       }
define half @constrained_call_half_exp2(half %x0) #0 {
  %call = call half @half_exp2(half %x0)
  ret half %call
}

declare half @half_fabs(half %x0)
; CHECK-LABEL: define half @call_half_fabs(half %x0) {
; CHECK:         %call = call half @llvm.fabs.f16(half %x0)
; CHECK:         ret half %call
; CHECK:       }
define half @call_half_fabs(half %x0) {
  %call = call half @half_fabs(half %x0)
  ret half %call
}

; CHECK-LABEL: define half @constrained_call_half_fabs(half %x0) #0 {
; CHECK:         %call = call half @llvm.fabs.f16(half %x0)
; CHECK:         ret half %call
; CHECK:       }
define half @constrained_call_half_fabs(half %x0) #0 {
  %call = call half @half_fabs(half %x0)
  ret half %call
}

declare half @half_floor(half %x0)
; CHECK-LABEL: define half @call_half_floor(half %x0) {
; CHECK:         %call = call half @llvm.floor.f16(half %x0)
; CHECK:         ret half %call
; CHECK:       }
define half @call_half_floor(half %x0) {
  %call = call half @half_floor(half %x0)
  ret half %call
}

; CHECK-LABEL: define half @constrained_call_half_floor(half %x0) #0 {
; CHECK:         %call = call half @llvm.experimental.constrained.floor.f16(half %x0, metadata !"fpexcept.maytrap")
; CHECK:         ret half %call
; CHECK:       }
define half @constrained_call_half_floor(half %x0) #0 {
  %call = call half @half_floor(half %x0)
  ret half %call
}

declare half @half_fma(half %x0, half %x1, half %x2)
; CHECK-LABEL: define half @call_half_fma(half %x0, half %x1, half %x2) {
; CHECK:         %call = call half @llvm.fma.f16(half %x0, half %x1, half %x2)
; CHECK:         ret half %call
; CHECK:       }
define half @call_half_fma(half %x0, half %x1, half %x2) {
  %call = call half @half_fma(half %x0, half %x1, half %x2)
  ret half %call
}

; CHECK-LABEL: define half @constrained_call_half_fma(half %x0, half %x1, half %x2) #0 {
; CHECK:         %call = call half @llvm.experimental.constrained.fma.f16(half %x0, half %x1, half %x2, metadata !"round.tonearest", metadata !"fpexcept.maytrap")
; CHECK:         ret half %call
; CHECK:       }
define half @constrained_call_half_fma(half %x0, half %x1, half %x2) #0 {
  %call = call half @half_fma(half %x0, half %x1, half %x2)
  ret half %call
}

declare half @half_log(half %x0)
; CHECK-LABEL: define half @call_half_log(half %x0) {
; CHECK:         %call = call half @llvm.log.f16(half %x0)
; CHECK:         ret half %call
; CHECK:       }
define half @call_half_log(half %x0) {
  %call = call half @half_log(half %x0)
  ret half %call
}

; CHECK-LABEL: define half @constrained_call_half_log(half %x0) #0 {
; CHECK:         %call = call half @llvm.experimental.constrained.log.f16(half %x0, metadata !"round.tonearest", metadata !"fpexcept.maytrap")
; CHECK:         ret half %call
; CHECK:       }
define half @constrained_call_half_log(half %x0) #0 {
  %call = call half @half_log(half %x0)
  ret half %call
}

declare half @half_log10(half %x0)
; CHECK-LABEL: define half @call_half_log10(half %x0) {
; CHECK:         %call = call half @llvm.log10.f16(half %x0)
; CHECK:         ret half %call
; CHECK:       }
define half @call_half_log10(half %x0) {
  %call = call half @half_log10(half %x0)
  ret half %call
}

; CHECK-LABEL: define half @constrained_call_half_log10(half %x0) #0 {
; CHECK:         %call = call half @llvm.experimental.constrained.log10.f16(half %x0, metadata !"round.tonearest", metadata !"fpexcept.maytrap")
; CHECK:         ret half %call
; CHECK:       }
define half @constrained_call_half_log10(half %x0) #0 {
  %call = call half @half_log10(half %x0)
  ret half %call
}

declare half @half_log2(half %x0)
; CHECK-LABEL: define half @call_half_log2(half %x0) {
; CHECK:         %call = call half @llvm.log2.f16(half %x0)
; CHECK:         ret half %call
; CHECK:       }
define half @call_half_log2(half %x0) {
  %call = call half @half_log2(half %x0)
  ret half %call
}

; CHECK-LABEL: define half @constrained_call_half_log2(half %x0) #0 {
; CHECK:         %call = call half @llvm.experimental.constrained.log2.f16(half %x0, metadata !"round.tonearest", metadata !"fpexcept.maytrap")
; CHECK:         ret half %call
; CHECK:       }
define half @constrained_call_half_log2(half %x0) #0 {
  %call = call half @half_log2(half %x0)
  ret half %call
}

declare half @half_fmax(half %x0, half %x1)
; CHECK-LABEL: define half @call_half_fmax(half %x0, half %x1) {
; CHECK:         %call = call half @llvm.maxnum.f16(half %x0, half %x1)
; CHECK:         ret half %call
; CHECK:       }
define half @call_half_fmax(half %x0, half %x1) {
  %call = call half @half_fmax(half %x0, half %x1)
  ret half %call
}

; CHECK-LABEL: define half @constrained_call_half_fmax(half %x0, half %x1) #0 {
; CHECK:         %call = call half @llvm.experimental.constrained.maxnum.f16(half %x0, half %x1, metadata !"fpexcept.maytrap")
; CHECK:         ret half %call
; CHECK:       }
define half @constrained_call_half_fmax(half %x0, half %x1) #0 {
  %call = call half @half_fmax(half %x0, half %x1)
  ret half %call
}

declare half @half_fmin(half %x0, half %x1)
; CHECK-LABEL: define half @call_half_fmin(half %x0, half %x1) {
; CHECK:         %call = call half @llvm.minnum.f16(half %x0, half %x1)
; CHECK:         ret half %call
; CHECK:       }
define half @call_half_fmin(half %x0, half %x1) {
  %call = call half @half_fmin(half %x0, half %x1)
  ret half %call
}

; CHECK-LABEL: define half @constrained_call_half_fmin(half %x0, half %x1) #0 {
; CHECK:         %call = call half @llvm.experimental.constrained.minnum.f16(half %x0, half %x1, metadata !"fpexcept.maytrap")
; CHECK:         ret half %call
; CHECK:       }
define half @constrained_call_half_fmin(half %x0, half %x1) #0 {
  %call = call half @half_fmin(half %x0, half %x1)
  ret half %call
}

declare half @half_nearbyint(half %x0)
; CHECK-LABEL: define half @call_half_nearbyint(half %x0) {
; CHECK:         %call = call half @llvm.nearbyint.f16(half %x0)
; CHECK:         ret half %call
; CHECK:       }
define half @call_half_nearbyint(half %x0) {
  %call = call half @half_nearbyint(half %x0)
  ret half %call
}

; CHECK-LABEL: define half @constrained_call_half_nearbyint(half %x0) #0 {
; CHECK:         %call = call half @llvm.experimental.constrained.nearbyint.f16(half %x0, metadata !"round.tonearest", metadata !"fpexcept.maytrap")
; CHECK:         ret half %call
; CHECK:       }
define half @constrained_call_half_nearbyint(half %x0) #0 {
  %call = call half @half_nearbyint(half %x0)
  ret half %call
}

declare half @half_pow(half %x0, half %x1)
; CHECK-LABEL: define half @call_half_pow(half %x0, half %x1) {
; CHECK:         %call = call half @llvm.pow.f16(half %x0, half %x1)
; CHECK:         ret half %call
; CHECK:       }
define half @call_half_pow(half %x0, half %x1) {
  %call = call half @half_pow(half %x0, half %x1)
  ret half %call
}

; CHECK-LABEL: define half @constrained_call_half_pow(half %x0, half %x1) #0 {
; CHECK:         %call = call half @llvm.experimental.constrained.pow.f16(half %x0, half %x1, metadata !"round.tonearest", metadata !"fpexcept.maytrap")
; CHECK:         ret half %call
; CHECK:       }
define half @constrained_call_half_pow(half %x0, half %x1) #0 {
  %call = call half @half_pow(half %x0, half %x1)
  ret half %call
}

declare half @half_rint(half %x0)
; CHECK-LABEL: define half @call_half_rint(half %x0) {
; CHECK:         %call = call half @llvm.rint.f16(half %x0)
; CHECK:         ret half %call
; CHECK:       }
define half @call_half_rint(half %x0) {
  %call = call half @half_rint(half %x0)
  ret half %call
}

; CHECK-LABEL: define half @constrained_call_half_rint(half %x0) #0 {
; CHECK:         %call = call half @llvm.experimental.constrained.rint.f16(half %x0, metadata !"round.tonearest", metadata !"fpexcept.maytrap")
; CHECK:         ret half %call
; CHECK:       }
define half @constrained_call_half_rint(half %x0) #0 {
  %call = call half @half_rint(half %x0)
  ret half %call
}

declare half @half_round(half %x0)
; CHECK-LABEL: define half @call_half_round(half %x0) {
; CHECK:         %call = call half @llvm.round.f16(half %x0)
; CHECK:         ret half %call
; CHECK:       }
define half @call_half_round(half %x0) {
  %call = call half @half_round(half %x0)
  ret half %call
}

; CHECK-LABEL: define half @constrained_call_half_round(half %x0) #0 {
; CHECK:         %call = call half @llvm.experimental.constrained.round.f16(half %x0, metadata !"fpexcept.maytrap")
; CHECK:         ret half %call
; CHECK:       }
define half @constrained_call_half_round(half %x0) #0 {
  %call = call half @half_round(half %x0)
  ret half %call
}

declare half @half_sin(half %x0)
; CHECK-LABEL: define half @call_half_sin(half %x0) {
; CHECK:         %call = call half @llvm.sin.f16(half %x0)
; CHECK:         ret half %call
; CHECK:       }
define half @call_half_sin(half %x0) {
  %call = call half @half_sin(half %x0)
  ret half %call
}

; CHECK-LABEL: define half @constrained_call_half_sin(half %x0) #0 {
; CHECK:         %call = call half @llvm.experimental.constrained.sin.f16(half %x0, metadata !"round.tonearest", metadata !"fpexcept.maytrap")
; CHECK:         ret half %call
; CHECK:       }
define half @constrained_call_half_sin(half %x0) #0 {
  %call = call half @half_sin(half %x0)
  ret half %call
}

declare half @half_sqrt(half %x0)
; CHECK-LABEL: define half @call_half_sqrt(half %x0) {
; CHECK:         %call = call half @llvm.sqrt.f16(half %x0)
; CHECK:         ret half %call
; CHECK:       }
define half @call_half_sqrt(half %x0) {
  %call = call half @half_sqrt(half %x0)
  ret half %call
}

; CHECK-LABEL: define half @constrained_call_half_sqrt(half %x0) #0 {
; CHECK:         %call = call half @llvm.experimental.constrained.sqrt.f16(half %x0, metadata !"round.tonearest", metadata !"fpexcept.maytrap")
; CHECK:         ret half %call
; CHECK:       }
define half @constrained_call_half_sqrt(half %x0) #0 {
  %call = call half @half_sqrt(half %x0)
  ret half %call
}

declare half @half_tanh(half %x0)
; CHECK-LABEL: define half @call_half_tanh(half %x0) {
; CHECK:         %call = call half @llvm.colossus.tanh.f16(half %x0)
; CHECK:         ret half %call
; CHECK:       }
define half @call_half_tanh(half %x0) {
  %call = call half @half_tanh(half %x0)
  ret half %call
}

; CHECK-LABEL: define half @constrained_call_half_tanh(half %x0) #0 {
; CHECK:         %call = call half @llvm.colossus.tanh.f16(half %x0)
; CHECK:         ret half %call
; CHECK:       }
define half @constrained_call_half_tanh(half %x0) #0 {
  %call = call half @half_tanh(half %x0)
  ret half %call
}

declare half @half_rsqrt(half %x0)
; CHECK-LABEL: define half @call_half_rsqrt(half %x0) {
; CHECK:         %call = call half @llvm.colossus.rsqrt.f16(half %x0)
; CHECK:         ret half %call
; CHECK:       }
define half @call_half_rsqrt(half %x0) {
  %call = call half @half_rsqrt(half %x0)
  ret half %call
}

; CHECK-LABEL: define half @constrained_call_half_rsqrt(half %x0) #0 {
; CHECK:         %call = call half @llvm.colossus.rsqrt.f16(half %x0)
; CHECK:         ret half %call
; CHECK:       }
define half @constrained_call_half_rsqrt(half %x0) #0 {
  %call = call half @half_rsqrt(half %x0)
  ret half %call
}
declare half @half_sigmoid(half %x0)
; CHECK-LABEL: define half @call_half_sigmoid(half %x0) {
; CHECK:         %call = call half @llvm.colossus.sigmoid.f16(half %x0)
; CHECK:         ret half %call
; CHECK:       }
define half @call_half_sigmoid(half %x0) {
  %call = call half @half_sigmoid(half %x0)
  ret half %call
}

; CHECK-LABEL: define half @constrained_call_half_sigmoid(half %x0) #0 {
; CHECK:         %call = call half @llvm.colossus.sigmoid.f16(half %x0)
; CHECK:         ret half %call
; CHECK:       }
define half @constrained_call_half_sigmoid(half %x0) #0 {
  %call = call half @half_sigmoid(half %x0)
  ret half %call
}

declare half @half_trunc(half %x0)
; CHECK-LABEL: define half @call_half_trunc(half %x0) {
; CHECK:         %call = call half @llvm.trunc.f16(half %x0)
; CHECK:         ret half %call
; CHECK:       }
define half @call_half_trunc(half %x0) {
  %call = call half @half_trunc(half %x0)
  ret half %call
}

; CHECK-LABEL: define half @constrained_call_half_trunc(half %x0) #0 {
; CHECK:         %call = call half @llvm.experimental.constrained.trunc.f16(half %x0, metadata !"fpexcept.maytrap")
; CHECK:         ret half %call
; CHECK:       }
define half @constrained_call_half_trunc(half %x0) #0 {
  %call = call half @half_trunc(half %x0)
  ret half %call
}

declare <2 x half> @half2_ceil(<2 x half> %x0)
; CHECK-LABEL: define <2 x half> @call_half2_ceil(<2 x half> %x0) {
; CHECK:         %call = call <2 x half> @llvm.ceil.v2f16(<2 x half> %x0)
; CHECK:         ret <2 x half> %call
; CHECK:       }
define <2 x half> @call_half2_ceil(<2 x half> %x0) {
  %call = call <2 x half> @half2_ceil(<2 x half> %x0)
  ret <2 x half> %call
}

; CHECK-LABEL: define <2 x half> @constrained_call_half2_ceil(<2 x half> %x0) #0 {
; CHECK:         %call = call <2 x half> @llvm.experimental.constrained.ceil.v2f16(<2 x half> %x0, metadata !"fpexcept.maytrap")
; CHECK:         ret <2 x half> %call
; CHECK:       }
define <2 x half> @constrained_call_half2_ceil(<2 x half> %x0) #0 {
  %call = call <2 x half> @half2_ceil(<2 x half> %x0)
  ret <2 x half> %call
}

declare <2 x half> @half2_copysign(<2 x half> %x0, <2 x half> %x1)
; CHECK-LABEL: define <2 x half> @call_half2_copysign(<2 x half> %x0, <2 x half> %x1) {
; CHECK:         %call = call <2 x half> @llvm.copysign.v2f16(<2 x half> %x0, <2 x half> %x1)
; CHECK:         ret <2 x half> %call
; CHECK:       }
define <2 x half> @call_half2_copysign(<2 x half> %x0, <2 x half> %x1) {
  %call = call <2 x half> @half2_copysign(<2 x half> %x0, <2 x half> %x1)
  ret <2 x half> %call
}

; CHECK-LABEL: define <2 x half> @constrained_call_half2_copysign(<2 x half> %x0, <2 x half> %x1) #0 {
; CHECK:         %call = call <2 x half> @llvm.copysign.v2f16(<2 x half> %x0, <2 x half> %x1)
; CHECK:         ret <2 x half> %call
; CHECK:       }
define <2 x half> @constrained_call_half2_copysign(<2 x half> %x0, <2 x half> %x1) #0 {
  %call = call <2 x half> @half2_copysign(<2 x half> %x0, <2 x half> %x1)
  ret <2 x half> %call
}

declare <2 x half> @half2_cos(<2 x half> %x0)
; CHECK-LABEL: define <2 x half> @call_half2_cos(<2 x half> %x0) {
; CHECK:         %call = call <2 x half> @llvm.cos.v2f16(<2 x half> %x0)
; CHECK:         ret <2 x half> %call
; CHECK:       }
define <2 x half> @call_half2_cos(<2 x half> %x0) {
  %call = call <2 x half> @half2_cos(<2 x half> %x0)
  ret <2 x half> %call
}

; CHECK-LABEL: define <2 x half> @constrained_call_half2_cos(<2 x half> %x0) #0 {
; CHECK:         %call = call <2 x half> @llvm.experimental.constrained.cos.v2f16(<2 x half> %x0, metadata !"round.tonearest", metadata !"fpexcept.maytrap")
; CHECK:         ret <2 x half> %call
; CHECK:       }
define <2 x half> @constrained_call_half2_cos(<2 x half> %x0) #0 {
  %call = call <2 x half> @half2_cos(<2 x half> %x0)
  ret <2 x half> %call
}

declare <2 x half> @half2_exp(<2 x half> %x0)
; CHECK-LABEL: define <2 x half> @call_half2_exp(<2 x half> %x0) {
; CHECK:         %call = call <2 x half> @llvm.exp.v2f16(<2 x half> %x0)
; CHECK:         ret <2 x half> %call
; CHECK:       }
define <2 x half> @call_half2_exp(<2 x half> %x0) {
  %call = call <2 x half> @half2_exp(<2 x half> %x0)
  ret <2 x half> %call
}

; CHECK-LABEL: define <2 x half> @constrained_call_half2_exp(<2 x half> %x0) #0 {
; CHECK:         %call = call <2 x half> @llvm.experimental.constrained.exp.v2f16(<2 x half> %x0, metadata !"round.tonearest", metadata !"fpexcept.maytrap")
; CHECK:         ret <2 x half> %call
; CHECK:       }
define <2 x half> @constrained_call_half2_exp(<2 x half> %x0) #0 {
  %call = call <2 x half> @half2_exp(<2 x half> %x0)
  ret <2 x half> %call
}

declare <2 x half> @half2_exp2(<2 x half> %x0)
; CHECK-LABEL: define <2 x half> @call_half2_exp2(<2 x half> %x0) {
; CHECK:         %call = call <2 x half> @llvm.exp2.v2f16(<2 x half> %x0)
; CHECK:         ret <2 x half> %call
; CHECK:       }
define <2 x half> @call_half2_exp2(<2 x half> %x0) {
  %call = call <2 x half> @half2_exp2(<2 x half> %x0)
  ret <2 x half> %call
}

; CHECK-LABEL: define <2 x half> @constrained_call_half2_exp2(<2 x half> %x0) #0 {
; CHECK:         %call = call <2 x half> @llvm.experimental.constrained.exp2.v2f16(<2 x half> %x0, metadata !"round.tonearest", metadata !"fpexcept.maytrap")
; CHECK:         ret <2 x half> %call
; CHECK:       }
define <2 x half> @constrained_call_half2_exp2(<2 x half> %x0) #0 {
  %call = call <2 x half> @half2_exp2(<2 x half> %x0)
  ret <2 x half> %call
}

declare <2 x half> @half2_fabs(<2 x half> %x0)
; CHECK-LABEL: define <2 x half> @call_half2_fabs(<2 x half> %x0) {
; CHECK:         %call = call <2 x half> @llvm.fabs.v2f16(<2 x half> %x0)
; CHECK:         ret <2 x half> %call
; CHECK:       }
define <2 x half> @call_half2_fabs(<2 x half> %x0) {
  %call = call <2 x half> @half2_fabs(<2 x half> %x0)
  ret <2 x half> %call
}

; CHECK-LABEL: define <2 x half> @constrained_call_half2_fabs(<2 x half> %x0) #0 {
; CHECK:         %call = call <2 x half> @llvm.fabs.v2f16(<2 x half> %x0)
; CHECK:         ret <2 x half> %call
; CHECK:       }
define <2 x half> @constrained_call_half2_fabs(<2 x half> %x0) #0 {
  %call = call <2 x half> @half2_fabs(<2 x half> %x0)
  ret <2 x half> %call
}

declare <2 x half> @half2_floor(<2 x half> %x0)
; CHECK-LABEL: define <2 x half> @call_half2_floor(<2 x half> %x0) {
; CHECK:         %call = call <2 x half> @llvm.floor.v2f16(<2 x half> %x0)
; CHECK:         ret <2 x half> %call
; CHECK:       }
define <2 x half> @call_half2_floor(<2 x half> %x0) {
  %call = call <2 x half> @half2_floor(<2 x half> %x0)
  ret <2 x half> %call
}

; CHECK-LABEL: define <2 x half> @constrained_call_half2_floor(<2 x half> %x0) #0 {
; CHECK:         %call = call <2 x half> @llvm.experimental.constrained.floor.v2f16(<2 x half> %x0, metadata !"fpexcept.maytrap")
; CHECK:         ret <2 x half> %call
; CHECK:       }
define <2 x half> @constrained_call_half2_floor(<2 x half> %x0) #0 {
  %call = call <2 x half> @half2_floor(<2 x half> %x0)
  ret <2 x half> %call
}

declare <2 x half> @half2_fma(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2)
; CHECK-LABEL: define <2 x half> @call_half2_fma(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
; CHECK:         %call = call <2 x half> @llvm.fma.v2f16(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2)
; CHECK:         ret <2 x half> %call
; CHECK:       }
define <2 x half> @call_half2_fma(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %call = call <2 x half> @half2_fma(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2)
  ret <2 x half> %call
}

; CHECK-LABEL: define <2 x half> @constrained_call_half2_fma(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) #0 {
; CHECK:         %call = call <2 x half> @llvm.experimental.constrained.fma.v2f16(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2, metadata !"round.tonearest", metadata !"fpexcept.maytrap")
; CHECK:         ret <2 x half> %call
; CHECK:       }
define <2 x half> @constrained_call_half2_fma(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) #0 {
  %call = call <2 x half> @half2_fma(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2)
  ret <2 x half> %call
}

declare <2 x half> @half2_log(<2 x half> %x0)
; CHECK-LABEL: define <2 x half> @call_half2_log(<2 x half> %x0) {
; CHECK:         %call = call <2 x half> @llvm.log.v2f16(<2 x half> %x0)
; CHECK:         ret <2 x half> %call
; CHECK:       }
define <2 x half> @call_half2_log(<2 x half> %x0) {
  %call = call <2 x half> @half2_log(<2 x half> %x0)
  ret <2 x half> %call
}

; CHECK-LABEL: define <2 x half> @constrained_call_half2_log(<2 x half> %x0) #0 {
; CHECK:         %call = call <2 x half> @llvm.experimental.constrained.log.v2f16(<2 x half> %x0, metadata !"round.tonearest", metadata !"fpexcept.maytrap")
; CHECK:         ret <2 x half> %call
; CHECK:       }
define <2 x half> @constrained_call_half2_log(<2 x half> %x0) #0 {
  %call = call <2 x half> @half2_log(<2 x half> %x0)
  ret <2 x half> %call
}

declare <2 x half> @half2_log10(<2 x half> %x0)
; CHECK-LABEL: define <2 x half> @call_half2_log10(<2 x half> %x0) {
; CHECK:         %call = call <2 x half> @llvm.log10.v2f16(<2 x half> %x0)
; CHECK:         ret <2 x half> %call
; CHECK:       }
define <2 x half> @call_half2_log10(<2 x half> %x0) {
  %call = call <2 x half> @half2_log10(<2 x half> %x0)
  ret <2 x half> %call
}

; CHECK-LABEL: define <2 x half> @constrained_call_half2_log10(<2 x half> %x0) #0 {
; CHECK:         %call = call <2 x half> @llvm.experimental.constrained.log10.v2f16(<2 x half> %x0, metadata !"round.tonearest", metadata !"fpexcept.maytrap")
; CHECK:         ret <2 x half> %call
; CHECK:       }
define <2 x half> @constrained_call_half2_log10(<2 x half> %x0) #0 {
  %call = call <2 x half> @half2_log10(<2 x half> %x0)
  ret <2 x half> %call
}

declare <2 x half> @half2_log2(<2 x half> %x0)
; CHECK-LABEL: define <2 x half> @call_half2_log2(<2 x half> %x0) {
; CHECK:         %call = call <2 x half> @llvm.log2.v2f16(<2 x half> %x0)
; CHECK:         ret <2 x half> %call
; CHECK:       }
define <2 x half> @call_half2_log2(<2 x half> %x0) {
  %call = call <2 x half> @half2_log2(<2 x half> %x0)
  ret <2 x half> %call
}

; CHECK-LABEL: define <2 x half> @constrained_call_half2_log2(<2 x half> %x0) #0 {
; CHECK:         %call = call <2 x half> @llvm.experimental.constrained.log2.v2f16(<2 x half> %x0, metadata !"round.tonearest", metadata !"fpexcept.maytrap")
; CHECK:         ret <2 x half> %call
; CHECK:       }
define <2 x half> @constrained_call_half2_log2(<2 x half> %x0) #0 {
  %call = call <2 x half> @half2_log2(<2 x half> %x0)
  ret <2 x half> %call
}

declare <2 x half> @half2_fmax(<2 x half> %x0, <2 x half> %x1)
; CHECK-LABEL: define <2 x half> @call_half2_fmax(<2 x half> %x0, <2 x half> %x1) {
; CHECK:         %call = call <2 x half> @llvm.maxnum.v2f16(<2 x half> %x0, <2 x half> %x1)
; CHECK:         ret <2 x half> %call
; CHECK:       }
define <2 x half> @call_half2_fmax(<2 x half> %x0, <2 x half> %x1) {
  %call = call <2 x half> @half2_fmax(<2 x half> %x0, <2 x half> %x1)
  ret <2 x half> %call
}

; CHECK-LABEL: define <2 x half> @constrained_call_half2_fmax(<2 x half> %x0, <2 x half> %x1) #0 {
; CHECK:         %call = call <2 x half> @llvm.experimental.constrained.maxnum.v2f16(<2 x half> %x0, <2 x half> %x1, metadata !"fpexcept.maytrap")
; CHECK:         ret <2 x half> %call
; CHECK:       }
define <2 x half> @constrained_call_half2_fmax(<2 x half> %x0, <2 x half> %x1) #0 {
  %call = call <2 x half> @half2_fmax(<2 x half> %x0, <2 x half> %x1)
  ret <2 x half> %call
}

declare <2 x half> @half2_fmin(<2 x half> %x0, <2 x half> %x1)
; CHECK-LABEL: define <2 x half> @call_half2_fmin(<2 x half> %x0, <2 x half> %x1) {
; CHECK:         %call = call <2 x half> @llvm.minnum.v2f16(<2 x half> %x0, <2 x half> %x1)
; CHECK:         ret <2 x half> %call
; CHECK:       }
define <2 x half> @call_half2_fmin(<2 x half> %x0, <2 x half> %x1) {
  %call = call <2 x half> @half2_fmin(<2 x half> %x0, <2 x half> %x1)
  ret <2 x half> %call
}

; CHECK-LABEL: define <2 x half> @constrained_call_half2_fmin(<2 x half> %x0, <2 x half> %x1) #0 {
; CHECK:         %call = call <2 x half> @llvm.experimental.constrained.minnum.v2f16(<2 x half> %x0, <2 x half> %x1, metadata !"fpexcept.maytrap")
; CHECK:         ret <2 x half> %call
; CHECK:       }
define <2 x half> @constrained_call_half2_fmin(<2 x half> %x0, <2 x half> %x1) #0 {
  %call = call <2 x half> @half2_fmin(<2 x half> %x0, <2 x half> %x1)
  ret <2 x half> %call
}

declare <2 x half> @half2_nearbyint(<2 x half> %x0)
; CHECK-LABEL: define <2 x half> @call_half2_nearbyint(<2 x half> %x0) {
; CHECK:         %call = call <2 x half> @llvm.nearbyint.v2f16(<2 x half> %x0)
; CHECK:         ret <2 x half> %call
; CHECK:       }
define <2 x half> @call_half2_nearbyint(<2 x half> %x0) {
  %call = call <2 x half> @half2_nearbyint(<2 x half> %x0)
  ret <2 x half> %call
}

; CHECK-LABEL: define <2 x half> @constrained_call_half2_nearbyint(<2 x half> %x0) #0 {
; CHECK:         %call = call <2 x half> @llvm.experimental.constrained.nearbyint.v2f16(<2 x half> %x0, metadata !"round.tonearest", metadata !"fpexcept.maytrap")
; CHECK:         ret <2 x half> %call
; CHECK:       }
define <2 x half> @constrained_call_half2_nearbyint(<2 x half> %x0) #0 {
  %call = call <2 x half> @half2_nearbyint(<2 x half> %x0)
  ret <2 x half> %call
}

declare <2 x half> @half2_pow(<2 x half> %x0, <2 x half> %x1)
; CHECK-LABEL: define <2 x half> @call_half2_pow(<2 x half> %x0, <2 x half> %x1) {
; CHECK:         %call = call <2 x half> @llvm.pow.v2f16(<2 x half> %x0, <2 x half> %x1)
; CHECK:         ret <2 x half> %call
; CHECK:       }
define <2 x half> @call_half2_pow(<2 x half> %x0, <2 x half> %x1) {
  %call = call <2 x half> @half2_pow(<2 x half> %x0, <2 x half> %x1)
  ret <2 x half> %call
}

; CHECK-LABEL: define <2 x half> @constrained_call_half2_pow(<2 x half> %x0, <2 x half> %x1) #0 {
; CHECK:         %call = call <2 x half> @llvm.experimental.constrained.pow.v2f16(<2 x half> %x0, <2 x half> %x1, metadata !"round.tonearest", metadata !"fpexcept.maytrap")
; CHECK:         ret <2 x half> %call
; CHECK:       }
define <2 x half> @constrained_call_half2_pow(<2 x half> %x0, <2 x half> %x1) #0 {
  %call = call <2 x half> @half2_pow(<2 x half> %x0, <2 x half> %x1)
  ret <2 x half> %call
}

declare <2 x half> @half2_rint(<2 x half> %x0)
; CHECK-LABEL: define <2 x half> @call_half2_rint(<2 x half> %x0) {
; CHECK:         %call = call <2 x half> @llvm.rint.v2f16(<2 x half> %x0)
; CHECK:         ret <2 x half> %call
; CHECK:       }
define <2 x half> @call_half2_rint(<2 x half> %x0) {
  %call = call <2 x half> @half2_rint(<2 x half> %x0)
  ret <2 x half> %call
}

; CHECK-LABEL: define <2 x half> @constrained_call_half2_rint(<2 x half> %x0) #0 {
; CHECK:         %call = call <2 x half> @llvm.experimental.constrained.rint.v2f16(<2 x half> %x0, metadata !"round.tonearest", metadata !"fpexcept.maytrap")
; CHECK:         ret <2 x half> %call
; CHECK:       }
define <2 x half> @constrained_call_half2_rint(<2 x half> %x0) #0 {
  %call = call <2 x half> @half2_rint(<2 x half> %x0)
  ret <2 x half> %call
}

declare <2 x half> @half2_round(<2 x half> %x0)
; CHECK-LABEL: define <2 x half> @call_half2_round(<2 x half> %x0) {
; CHECK:         %call = call <2 x half> @llvm.round.v2f16(<2 x half> %x0)
; CHECK:         ret <2 x half> %call
; CHECK:       }
define <2 x half> @call_half2_round(<2 x half> %x0) {
  %call = call <2 x half> @half2_round(<2 x half> %x0)
  ret <2 x half> %call
}

; CHECK-LABEL: define <2 x half> @constrained_call_half2_round(<2 x half> %x0) #0 {
; CHECK:         %call = call <2 x half> @llvm.experimental.constrained.round.v2f16(<2 x half> %x0, metadata !"fpexcept.maytrap")
; CHECK:         ret <2 x half> %call
; CHECK:       }
define <2 x half> @constrained_call_half2_round(<2 x half> %x0) #0 {
  %call = call <2 x half> @half2_round(<2 x half> %x0)
  ret <2 x half> %call
}

declare <2 x half> @half2_sin(<2 x half> %x0)
; CHECK-LABEL: define <2 x half> @call_half2_sin(<2 x half> %x0) {
; CHECK:         %call = call <2 x half> @llvm.sin.v2f16(<2 x half> %x0)
; CHECK:         ret <2 x half> %call
; CHECK:       }
define <2 x half> @call_half2_sin(<2 x half> %x0) {
  %call = call <2 x half> @half2_sin(<2 x half> %x0)
  ret <2 x half> %call
}

; CHECK-LABEL: define <2 x half> @constrained_call_half2_sin(<2 x half> %x0) #0 {
; CHECK:         %call = call <2 x half> @llvm.experimental.constrained.sin.v2f16(<2 x half> %x0, metadata !"round.tonearest", metadata !"fpexcept.maytrap")
; CHECK:         ret <2 x half> %call
; CHECK:       }
define <2 x half> @constrained_call_half2_sin(<2 x half> %x0) #0 {
  %call = call <2 x half> @half2_sin(<2 x half> %x0)
  ret <2 x half> %call
}

declare <2 x half> @half2_sqrt(<2 x half> %x0)
; CHECK-LABEL: define <2 x half> @call_half2_sqrt(<2 x half> %x0) {
; CHECK:         %call = call <2 x half> @llvm.sqrt.v2f16(<2 x half> %x0)
; CHECK:         ret <2 x half> %call
; CHECK:       }
define <2 x half> @call_half2_sqrt(<2 x half> %x0) {
  %call = call <2 x half> @half2_sqrt(<2 x half> %x0)
  ret <2 x half> %call
}

; CHECK-LABEL: define <2 x half> @constrained_call_half2_sqrt(<2 x half> %x0) #0 {
; CHECK:         %call = call <2 x half> @llvm.experimental.constrained.sqrt.v2f16(<2 x half> %x0, metadata !"round.tonearest", metadata !"fpexcept.maytrap")
; CHECK:         ret <2 x half> %call
; CHECK:       }
define <2 x half> @constrained_call_half2_sqrt(<2 x half> %x0) #0 {
  %call = call <2 x half> @half2_sqrt(<2 x half> %x0)
  ret <2 x half> %call
}

declare <2 x half> @half2_tanh(<2 x half> %x0)
; CHECK-LABEL: define <2 x half> @call_half2_tanh(<2 x half> %x0) {
; CHECK:         %call = call <2 x half> @llvm.colossus.tanh.v2f16(<2 x half> %x0)
; CHECK:         ret <2 x half> %call
; CHECK:       }
define <2 x half> @call_half2_tanh(<2 x half> %x0) {
  %call = call <2 x half> @half2_tanh(<2 x half> %x0)
  ret <2 x half> %call
}

; CHECK-LABEL: define <2 x half> @constrained_call_half2_tanh(<2 x half> %x0) #0 {
; CHECK:         %call = call <2 x half> @llvm.colossus.tanh.v2f16(<2 x half> %x0)
; CHECK:         ret <2 x half> %call
; CHECK:       }
define <2 x half> @constrained_call_half2_tanh(<2 x half> %x0) #0 {
  %call = call <2 x half> @half2_tanh(<2 x half> %x0)
  ret <2 x half> %call
}

declare <2 x half> @half2_rsqrt(<2 x half> %x0)
; CHECK-LABEL: define <2 x half> @call_half2_rsqrt(<2 x half> %x0) {
; CHECK:         %call = call <2 x half> @llvm.colossus.rsqrt.v2f16(<2 x half> %x0)
; CHECK:         ret <2 x half> %call
; CHECK:       }
define <2 x half> @call_half2_rsqrt(<2 x half> %x0) {
  %call = call <2 x half> @half2_rsqrt(<2 x half> %x0)
  ret <2 x half> %call
}

; CHECK-LABEL: define <2 x half> @constrained_call_half2_rsqrt(<2 x half> %x0) #0 {
; CHECK:         %call = call <2 x half> @llvm.colossus.rsqrt.v2f16(<2 x half> %x0)
; CHECK:         ret <2 x half> %call
; CHECK:       }
define <2 x half> @constrained_call_half2_rsqrt(<2 x half> %x0) #0 {
  %call = call <2 x half> @half2_rsqrt(<2 x half> %x0)
  ret <2 x half> %call
}

declare <2 x half> @half2_sigmoid(<2 x half> %x0)
; CHECK-LABEL: define <2 x half> @call_half2_sigmoid(<2 x half> %x0) {
; CHECK:         %call = call <2 x half> @llvm.colossus.sigmoid.v2f16(<2 x half> %x0)
; CHECK:         ret <2 x half> %call
; CHECK:       }
define <2 x half> @call_half2_sigmoid(<2 x half> %x0) {
  %call = call <2 x half> @half2_sigmoid(<2 x half> %x0)
  ret <2 x half> %call
}

; CHECK-LABEL: define <2 x half> @constrained_call_half2_sigmoid(<2 x half> %x0) #0 {
; CHECK:         %call = call <2 x half> @llvm.colossus.sigmoid.v2f16(<2 x half> %x0)
; CHECK:         ret <2 x half> %call
; CHECK:       }
define <2 x half> @constrained_call_half2_sigmoid(<2 x half> %x0) #0 {
  %call = call <2 x half> @half2_sigmoid(<2 x half> %x0)
  ret <2 x half> %call
}

declare <2 x half> @half2_trunc(<2 x half> %x0)
; CHECK-LABEL: define <2 x half> @call_half2_trunc(<2 x half> %x0) {
; CHECK:         %call = call <2 x half> @llvm.trunc.v2f16(<2 x half> %x0)
; CHECK:         ret <2 x half> %call
; CHECK:       }
define <2 x half> @call_half2_trunc(<2 x half> %x0) {
  %call = call <2 x half> @half2_trunc(<2 x half> %x0)
  ret <2 x half> %call
}

; CHECK-LABEL: define <2 x half> @constrained_call_half2_trunc(<2 x half> %x0) #0 {
; CHECK:         %call = call <2 x half> @llvm.experimental.constrained.trunc.v2f16(<2 x half> %x0, metadata !"fpexcept.maytrap")
; CHECK:         ret <2 x half> %call
; CHECK:       }
define <2 x half> @constrained_call_half2_trunc(<2 x half> %x0) #0 {
  %call = call <2 x half> @half2_trunc(<2 x half> %x0)
  ret <2 x half> %call
}

declare <4 x half> @half4_ceil(<4 x half> %x0)
; CHECK-LABEL: define <4 x half> @call_half4_ceil(<4 x half> %x0) {
; CHECK:         %call = call <4 x half> @llvm.ceil.v4f16(<4 x half> %x0)
; CHECK:         ret <4 x half> %call
; CHECK:       }
define <4 x half> @call_half4_ceil(<4 x half> %x0) {
  %call = call <4 x half> @half4_ceil(<4 x half> %x0)
  ret <4 x half> %call
}

; CHECK-LABEL: define <4 x half> @constrained_call_half4_ceil(<4 x half> %x0) #0 {
; CHECK:         %call = call <4 x half> @llvm.experimental.constrained.ceil.v4f16(<4 x half> %x0, metadata !"fpexcept.maytrap")
; CHECK:         ret <4 x half> %call
; CHECK:       }
define <4 x half> @constrained_call_half4_ceil(<4 x half> %x0) #0 {
  %call = call <4 x half> @half4_ceil(<4 x half> %x0)
  ret <4 x half> %call
}

declare <4 x half> @half4_copysign(<4 x half> %x0, <4 x half> %x1)
; CHECK-LABEL: define <4 x half> @call_half4_copysign(<4 x half> %x0, <4 x half> %x1) {
; CHECK:         %call = call <4 x half> @llvm.copysign.v4f16(<4 x half> %x0, <4 x half> %x1)
; CHECK:         ret <4 x half> %call
; CHECK:       }
define <4 x half> @call_half4_copysign(<4 x half> %x0, <4 x half> %x1) {
  %call = call <4 x half> @half4_copysign(<4 x half> %x0, <4 x half> %x1)
  ret <4 x half> %call
}

; CHECK-LABEL: define <4 x half> @constrained_call_half4_copysign(<4 x half> %x0, <4 x half> %x1) #0 {
; CHECK:         %call = call <4 x half> @llvm.copysign.v4f16(<4 x half> %x0, <4 x half> %x1)
; CHECK:         ret <4 x half> %call
; CHECK:       }
define <4 x half> @constrained_call_half4_copysign(<4 x half> %x0, <4 x half> %x1) #0 {
  %call = call <4 x half> @half4_copysign(<4 x half> %x0, <4 x half> %x1)
  ret <4 x half> %call
}

declare <4 x half> @half4_cos(<4 x half> %x0)
; CHECK-LABEL: define <4 x half> @call_half4_cos(<4 x half> %x0) {
; CHECK:         %call = call <4 x half> @llvm.cos.v4f16(<4 x half> %x0)
; CHECK:         ret <4 x half> %call
; CHECK:       }
define <4 x half> @call_half4_cos(<4 x half> %x0) {
  %call = call <4 x half> @half4_cos(<4 x half> %x0)
  ret <4 x half> %call
}

; CHECK-LABEL: define <4 x half> @constrained_call_half4_cos(<4 x half> %x0) #0 {
; CHECK:         %call = call <4 x half> @llvm.experimental.constrained.cos.v4f16(<4 x half> %x0, metadata !"round.tonearest", metadata !"fpexcept.maytrap")
; CHECK:         ret <4 x half> %call
; CHECK:       }
define <4 x half> @constrained_call_half4_cos(<4 x half> %x0) #0 {
  %call = call <4 x half> @half4_cos(<4 x half> %x0)
  ret <4 x half> %call
}

declare <4 x half> @half4_exp(<4 x half> %x0)
; CHECK-LABEL: define <4 x half> @call_half4_exp(<4 x half> %x0) {
; CHECK:         %call = call <4 x half> @llvm.exp.v4f16(<4 x half> %x0)
; CHECK:         ret <4 x half> %call
; CHECK:       }
define <4 x half> @call_half4_exp(<4 x half> %x0) {
  %call = call <4 x half> @half4_exp(<4 x half> %x0)
  ret <4 x half> %call
}

; CHECK-LABEL: define <4 x half> @constrained_call_half4_exp(<4 x half> %x0) #0 {
; CHECK:         %call = call <4 x half> @llvm.experimental.constrained.exp.v4f16(<4 x half> %x0, metadata !"round.tonearest", metadata !"fpexcept.maytrap")
; CHECK:         ret <4 x half> %call
; CHECK:       }
define <4 x half> @constrained_call_half4_exp(<4 x half> %x0) #0 {
  %call = call <4 x half> @half4_exp(<4 x half> %x0)
  ret <4 x half> %call
}

declare <4 x half> @half4_exp2(<4 x half> %x0)
; CHECK-LABEL: define <4 x half> @call_half4_exp2(<4 x half> %x0) {
; CHECK:         %call = call <4 x half> @llvm.exp2.v4f16(<4 x half> %x0)
; CHECK:         ret <4 x half> %call
; CHECK:       }
define <4 x half> @call_half4_exp2(<4 x half> %x0) {
  %call = call <4 x half> @half4_exp2(<4 x half> %x0)
  ret <4 x half> %call
}

; CHECK-LABEL: define <4 x half> @constrained_call_half4_exp2(<4 x half> %x0) #0 {
; CHECK:         %call = call <4 x half> @llvm.experimental.constrained.exp2.v4f16(<4 x half> %x0, metadata !"round.tonearest", metadata !"fpexcept.maytrap")
; CHECK:         ret <4 x half> %call
; CHECK:       }
define <4 x half> @constrained_call_half4_exp2(<4 x half> %x0) #0 {
  %call = call <4 x half> @half4_exp2(<4 x half> %x0)
  ret <4 x half> %call
}

declare <4 x half> @half4_fabs(<4 x half> %x0)
; CHECK-LABEL: define <4 x half> @call_half4_fabs(<4 x half> %x0) {
; CHECK:         %call = call <4 x half> @llvm.fabs.v4f16(<4 x half> %x0)
; CHECK:         ret <4 x half> %call
; CHECK:       }
define <4 x half> @call_half4_fabs(<4 x half> %x0) {
  %call = call <4 x half> @half4_fabs(<4 x half> %x0)
  ret <4 x half> %call
}

; CHECK-LABEL: define <4 x half> @constrained_call_half4_fabs(<4 x half> %x0) #0 {
; CHECK:         %call = call <4 x half> @llvm.fabs.v4f16(<4 x half> %x0)
; CHECK:         ret <4 x half> %call
; CHECK:       }
define <4 x half> @constrained_call_half4_fabs(<4 x half> %x0) #0 {
  %call = call <4 x half> @half4_fabs(<4 x half> %x0)
  ret <4 x half> %call
}

declare <4 x half> @half4_floor(<4 x half> %x0)
; CHECK-LABEL: define <4 x half> @call_half4_floor(<4 x half> %x0) {
; CHECK:         %call = call <4 x half> @llvm.floor.v4f16(<4 x half> %x0)
; CHECK:         ret <4 x half> %call
; CHECK:       }
define <4 x half> @call_half4_floor(<4 x half> %x0) {
  %call = call <4 x half> @half4_floor(<4 x half> %x0)
  ret <4 x half> %call
}

; CHECK-LABEL: define <4 x half> @constrained_call_half4_floor(<4 x half> %x0) #0 {
; CHECK:         %call = call <4 x half> @llvm.experimental.constrained.floor.v4f16(<4 x half> %x0, metadata !"fpexcept.maytrap")
; CHECK:         ret <4 x half> %call
; CHECK:       }
define <4 x half> @constrained_call_half4_floor(<4 x half> %x0) #0 {
  %call = call <4 x half> @half4_floor(<4 x half> %x0)
  ret <4 x half> %call
}

declare <4 x half> @half4_fma(<4 x half> %x0, <4 x half> %x1, <4 x half> %x2)
; CHECK-LABEL: define <4 x half> @call_half4_fma(<4 x half> %x0, <4 x half> %x1, <4 x half> %x2) {
; CHECK:         %call = call <4 x half> @llvm.fma.v4f16(<4 x half> %x0, <4 x half> %x1, <4 x half> %x2)
; CHECK:         ret <4 x half> %call
; CHECK:       }
define <4 x half> @call_half4_fma(<4 x half> %x0, <4 x half> %x1, <4 x half> %x2) {
  %call = call <4 x half> @half4_fma(<4 x half> %x0, <4 x half> %x1, <4 x half> %x2)
  ret <4 x half> %call
}

; CHECK-LABEL: define <4 x half> @constrained_call_half4_fma(<4 x half> %x0, <4 x half> %x1, <4 x half> %x2) #0 {
; CHECK:         %call = call <4 x half> @llvm.experimental.constrained.fma.v4f16(<4 x half> %x0, <4 x half> %x1, <4 x half> %x2, metadata !"round.tonearest", metadata !"fpexcept.maytrap")
; CHECK:         ret <4 x half> %call
; CHECK:       }
define <4 x half> @constrained_call_half4_fma(<4 x half> %x0, <4 x half> %x1, <4 x half> %x2) #0 {
  %call = call <4 x half> @half4_fma(<4 x half> %x0, <4 x half> %x1, <4 x half> %x2)
  ret <4 x half> %call
}

declare <4 x half> @half4_log(<4 x half> %x0)
; CHECK-LABEL: define <4 x half> @call_half4_log(<4 x half> %x0) {
; CHECK:         %call = call <4 x half> @llvm.log.v4f16(<4 x half> %x0)
; CHECK:         ret <4 x half> %call
; CHECK:       }
define <4 x half> @call_half4_log(<4 x half> %x0) {
  %call = call <4 x half> @half4_log(<4 x half> %x0)
  ret <4 x half> %call
}

; CHECK-LABEL: define <4 x half> @constrained_call_half4_log(<4 x half> %x0) #0 {
; CHECK:         %call = call <4 x half> @llvm.experimental.constrained.log.v4f16(<4 x half> %x0, metadata !"round.tonearest", metadata !"fpexcept.maytrap")
; CHECK:         ret <4 x half> %call
; CHECK:       }
define <4 x half> @constrained_call_half4_log(<4 x half> %x0) #0 {
  %call = call <4 x half> @half4_log(<4 x half> %x0)
  ret <4 x half> %call
}

declare <4 x half> @half4_log10(<4 x half> %x0)
; CHECK-LABEL: define <4 x half> @call_half4_log10(<4 x half> %x0) {
; CHECK:         %call = call <4 x half> @llvm.log10.v4f16(<4 x half> %x0)
; CHECK:         ret <4 x half> %call
; CHECK:       }
define <4 x half> @call_half4_log10(<4 x half> %x0) {
  %call = call <4 x half> @half4_log10(<4 x half> %x0)
  ret <4 x half> %call
}

; CHECK-LABEL: define <4 x half> @constrained_call_half4_log10(<4 x half> %x0) #0 {
; CHECK:         %call = call <4 x half> @llvm.experimental.constrained.log10.v4f16(<4 x half> %x0, metadata !"round.tonearest", metadata !"fpexcept.maytrap")
; CHECK:         ret <4 x half> %call
; CHECK:       }
define <4 x half> @constrained_call_half4_log10(<4 x half> %x0) #0 {
  %call = call <4 x half> @half4_log10(<4 x half> %x0)
  ret <4 x half> %call
}

declare <4 x half> @half4_log2(<4 x half> %x0)
; CHECK-LABEL: define <4 x half> @call_half4_log2(<4 x half> %x0) {
; CHECK:         %call = call <4 x half> @llvm.log2.v4f16(<4 x half> %x0)
; CHECK:         ret <4 x half> %call
; CHECK:       }
define <4 x half> @call_half4_log2(<4 x half> %x0) {
  %call = call <4 x half> @half4_log2(<4 x half> %x0)
  ret <4 x half> %call
}

; CHECK-LABEL: define <4 x half> @constrained_call_half4_log2(<4 x half> %x0) #0 {
; CHECK:         %call = call <4 x half> @llvm.experimental.constrained.log2.v4f16(<4 x half> %x0, metadata !"round.tonearest", metadata !"fpexcept.maytrap")
; CHECK:         ret <4 x half> %call
; CHECK:       }
define <4 x half> @constrained_call_half4_log2(<4 x half> %x0) #0 {
  %call = call <4 x half> @half4_log2(<4 x half> %x0)
  ret <4 x half> %call
}

declare <4 x half> @half4_fmax(<4 x half> %x0, <4 x half> %x1)
; CHECK-LABEL: define <4 x half> @call_half4_fmax(<4 x half> %x0, <4 x half> %x1) {
; CHECK:         %call = call <4 x half> @llvm.maxnum.v4f16(<4 x half> %x0, <4 x half> %x1)
; CHECK:         ret <4 x half> %call
; CHECK:       }
define <4 x half> @call_half4_fmax(<4 x half> %x0, <4 x half> %x1) {
  %call = call <4 x half> @half4_fmax(<4 x half> %x0, <4 x half> %x1)
  ret <4 x half> %call
}

; CHECK-LABEL: define <4 x half> @constrained_call_half4_fmax(<4 x half> %x0, <4 x half> %x1) #0 {
; CHECK:         %call = call <4 x half> @llvm.experimental.constrained.maxnum.v4f16(<4 x half> %x0, <4 x half> %x1, metadata !"fpexcept.maytrap")
; CHECK:         ret <4 x half> %call
; CHECK:       }
define <4 x half> @constrained_call_half4_fmax(<4 x half> %x0, <4 x half> %x1) #0 {
  %call = call <4 x half> @half4_fmax(<4 x half> %x0, <4 x half> %x1)
  ret <4 x half> %call
}

declare <4 x half> @half4_fmin(<4 x half> %x0, <4 x half> %x1)
; CHECK-LABEL: define <4 x half> @call_half4_fmin(<4 x half> %x0, <4 x half> %x1) {
; CHECK:         %call = call <4 x half> @llvm.minnum.v4f16(<4 x half> %x0, <4 x half> %x1)
; CHECK:         ret <4 x half> %call
; CHECK:       }
define <4 x half> @call_half4_fmin(<4 x half> %x0, <4 x half> %x1) {
  %call = call <4 x half> @half4_fmin(<4 x half> %x0, <4 x half> %x1)
  ret <4 x half> %call
}

; CHECK-LABEL: define <4 x half> @constrained_call_half4_fmin(<4 x half> %x0, <4 x half> %x1) #0 {
; CHECK:         %call = call <4 x half> @llvm.experimental.constrained.minnum.v4f16(<4 x half> %x0, <4 x half> %x1, metadata !"fpexcept.maytrap")
; CHECK:         ret <4 x half> %call
; CHECK:       }
define <4 x half> @constrained_call_half4_fmin(<4 x half> %x0, <4 x half> %x1) #0 {
  %call = call <4 x half> @half4_fmin(<4 x half> %x0, <4 x half> %x1)
  ret <4 x half> %call
}

declare <4 x half> @half4_nearbyint(<4 x half> %x0)
; CHECK-LABEL: define <4 x half> @call_half4_nearbyint(<4 x half> %x0) {
; CHECK:         %call = call <4 x half> @llvm.nearbyint.v4f16(<4 x half> %x0)
; CHECK:         ret <4 x half> %call
; CHECK:       }
define <4 x half> @call_half4_nearbyint(<4 x half> %x0) {
  %call = call <4 x half> @half4_nearbyint(<4 x half> %x0)
  ret <4 x half> %call
}

; CHECK-LABEL: define <4 x half> @constrained_call_half4_nearbyint(<4 x half> %x0) #0 {
; CHECK:         %call = call <4 x half> @llvm.experimental.constrained.nearbyint.v4f16(<4 x half> %x0, metadata !"round.tonearest", metadata !"fpexcept.maytrap")
; CHECK:         ret <4 x half> %call
; CHECK:       }
define <4 x half> @constrained_call_half4_nearbyint(<4 x half> %x0) #0 {
  %call = call <4 x half> @half4_nearbyint(<4 x half> %x0)
  ret <4 x half> %call
}

declare <4 x half> @half4_pow(<4 x half> %x0, <4 x half> %x1)
; CHECK-LABEL: define <4 x half> @call_half4_pow(<4 x half> %x0, <4 x half> %x1) {
; CHECK:         %call = call <4 x half> @llvm.pow.v4f16(<4 x half> %x0, <4 x half> %x1)
; CHECK:         ret <4 x half> %call
; CHECK:       }
define <4 x half> @call_half4_pow(<4 x half> %x0, <4 x half> %x1) {
  %call = call <4 x half> @half4_pow(<4 x half> %x0, <4 x half> %x1)
  ret <4 x half> %call
}

; CHECK-LABEL: define <4 x half> @constrained_call_half4_pow(<4 x half> %x0, <4 x half> %x1) #0 {
; CHECK:         %call = call <4 x half> @llvm.experimental.constrained.pow.v4f16(<4 x half> %x0, <4 x half> %x1, metadata !"round.tonearest", metadata !"fpexcept.maytrap")
; CHECK:         ret <4 x half> %call
; CHECK:       }
define <4 x half> @constrained_call_half4_pow(<4 x half> %x0, <4 x half> %x1) #0 {
  %call = call <4 x half> @half4_pow(<4 x half> %x0, <4 x half> %x1)
  ret <4 x half> %call
}

declare <4 x half> @half4_rint(<4 x half> %x0)
; CHECK-LABEL: define <4 x half> @call_half4_rint(<4 x half> %x0) {
; CHECK:         %call = call <4 x half> @llvm.rint.v4f16(<4 x half> %x0)
; CHECK:         ret <4 x half> %call
; CHECK:       }
define <4 x half> @call_half4_rint(<4 x half> %x0) {
  %call = call <4 x half> @half4_rint(<4 x half> %x0)
  ret <4 x half> %call
}

; CHECK-LABEL: define <4 x half> @constrained_call_half4_rint(<4 x half> %x0) #0 {
; CHECK:         %call = call <4 x half> @llvm.experimental.constrained.rint.v4f16(<4 x half> %x0, metadata !"round.tonearest", metadata !"fpexcept.maytrap")
; CHECK:         ret <4 x half> %call
; CHECK:       }
define <4 x half> @constrained_call_half4_rint(<4 x half> %x0) #0 {
  %call = call <4 x half> @half4_rint(<4 x half> %x0)
  ret <4 x half> %call
}

declare <4 x half> @half4_round(<4 x half> %x0)
; CHECK-LABEL: define <4 x half> @call_half4_round(<4 x half> %x0) {
; CHECK:         %call = call <4 x half> @llvm.round.v4f16(<4 x half> %x0)
; CHECK:         ret <4 x half> %call
; CHECK:       }
define <4 x half> @call_half4_round(<4 x half> %x0) {
  %call = call <4 x half> @half4_round(<4 x half> %x0)
  ret <4 x half> %call
}

; CHECK-LABEL: define <4 x half> @constrained_call_half4_round(<4 x half> %x0) #0 {
; CHECK:         %call = call <4 x half> @llvm.experimental.constrained.round.v4f16(<4 x half> %x0, metadata !"fpexcept.maytrap")
; CHECK:         ret <4 x half> %call
; CHECK:       }
define <4 x half> @constrained_call_half4_round(<4 x half> %x0) #0 {
  %call = call <4 x half> @half4_round(<4 x half> %x0)
  ret <4 x half> %call
}

declare <4 x half> @half4_sin(<4 x half> %x0)
; CHECK-LABEL: define <4 x half> @call_half4_sin(<4 x half> %x0) {
; CHECK:         %call = call <4 x half> @llvm.sin.v4f16(<4 x half> %x0)
; CHECK:         ret <4 x half> %call
; CHECK:       }
define <4 x half> @call_half4_sin(<4 x half> %x0) {
  %call = call <4 x half> @half4_sin(<4 x half> %x0)
  ret <4 x half> %call
}

; CHECK-LABEL: define <4 x half> @constrained_call_half4_sin(<4 x half> %x0) #0 {
; CHECK:         %call = call <4 x half> @llvm.experimental.constrained.sin.v4f16(<4 x half> %x0, metadata !"round.tonearest", metadata !"fpexcept.maytrap")
; CHECK:         ret <4 x half> %call
; CHECK:       }
define <4 x half> @constrained_call_half4_sin(<4 x half> %x0) #0 {
  %call = call <4 x half> @half4_sin(<4 x half> %x0)
  ret <4 x half> %call
}

declare <4 x half> @half4_sqrt(<4 x half> %x0)
; CHECK-LABEL: define <4 x half> @call_half4_sqrt(<4 x half> %x0) {
; CHECK:         %call = call <4 x half> @llvm.sqrt.v4f16(<4 x half> %x0)
; CHECK:         ret <4 x half> %call
; CHECK:       }
define <4 x half> @call_half4_sqrt(<4 x half> %x0) {
  %call = call <4 x half> @half4_sqrt(<4 x half> %x0)
  ret <4 x half> %call
}

; CHECK-LABEL: define <4 x half> @constrained_call_half4_sqrt(<4 x half> %x0) #0 {
; CHECK:         %call = call <4 x half> @llvm.experimental.constrained.sqrt.v4f16(<4 x half> %x0, metadata !"round.tonearest", metadata !"fpexcept.maytrap")
; CHECK:         ret <4 x half> %call
; CHECK:       }
define <4 x half> @constrained_call_half4_sqrt(<4 x half> %x0) #0 {
  %call = call <4 x half> @half4_sqrt(<4 x half> %x0)
  ret <4 x half> %call
}

declare <4 x half> @half4_tanh(<4 x half> %x0)
; CHECK-LABEL: define <4 x half> @call_half4_tanh(<4 x half> %x0) {
; CHECK:         %call = call <4 x half> @llvm.colossus.tanh.v4f16(<4 x half> %x0)
; CHECK:         ret <4 x half> %call
; CHECK:       }
define <4 x half> @call_half4_tanh(<4 x half> %x0) {
  %call = call <4 x half> @half4_tanh(<4 x half> %x0)
  ret <4 x half> %call
}

; CHECK-LABEL: define <4 x half> @constrained_call_half4_tanh(<4 x half> %x0) #0 {
; CHECK:         %call = call <4 x half> @llvm.colossus.tanh.v4f16(<4 x half> %x0)
; CHECK:         ret <4 x half> %call
; CHECK:       }
define <4 x half> @constrained_call_half4_tanh(<4 x half> %x0) #0 {
  %call = call <4 x half> @half4_tanh(<4 x half> %x0)
  ret <4 x half> %call
}

declare <4 x half> @half4_rsqrt(<4 x half> %x0)
; CHECK-LABEL: define <4 x half> @call_half4_rsqrt(<4 x half> %x0) {
; CHECK:         %call = call <4 x half> @llvm.colossus.rsqrt.v4f16(<4 x half> %x0)
; CHECK:         ret <4 x half> %call
; CHECK:       }
define <4 x half> @call_half4_rsqrt(<4 x half> %x0) {
  %call = call <4 x half> @half4_rsqrt(<4 x half> %x0)
  ret <4 x half> %call
}

; CHECK-LABEL: define <4 x half> @constrained_call_half4_rsqrt(<4 x half> %x0) #0 {
; CHECK:         %call = call <4 x half> @llvm.colossus.rsqrt.v4f16(<4 x half> %x0)
; CHECK:         ret <4 x half> %call
; CHECK:       }
define <4 x half> @constrained_call_half4_rsqrt(<4 x half> %x0) #0 {
  %call = call <4 x half> @half4_rsqrt(<4 x half> %x0)
  ret <4 x half> %call
}
declare <4 x half> @half4_sigmoid(<4 x half> %x0)
; CHECK-LABEL: define <4 x half> @call_half4_sigmoid(<4 x half> %x0) {
; CHECK:         %call = call <4 x half> @llvm.colossus.sigmoid.v4f16(<4 x half> %x0)
; CHECK:         ret <4 x half> %call
; CHECK:       }
define <4 x half> @call_half4_sigmoid(<4 x half> %x0) {
  %call = call <4 x half> @half4_sigmoid(<4 x half> %x0)
  ret <4 x half> %call
}

; CHECK-LABEL: define <4 x half> @constrained_call_half4_sigmoid(<4 x half> %x0) #0 {
; CHECK:         %call = call <4 x half> @llvm.colossus.sigmoid.v4f16(<4 x half> %x0)
; CHECK:         ret <4 x half> %call
; CHECK:       }
define <4 x half> @constrained_call_half4_sigmoid(<4 x half> %x0) #0 {
  %call = call <4 x half> @half4_sigmoid(<4 x half> %x0)
  ret <4 x half> %call
}

declare <4 x half> @half4_trunc(<4 x half> %x0)
; CHECK-LABEL: define <4 x half> @call_half4_trunc(<4 x half> %x0) {
; CHECK:         %call = call <4 x half> @llvm.trunc.v4f16(<4 x half> %x0)
; CHECK:         ret <4 x half> %call
; CHECK:       }
define <4 x half> @call_half4_trunc(<4 x half> %x0) {
  %call = call <4 x half> @half4_trunc(<4 x half> %x0)
  ret <4 x half> %call
}

; CHECK-LABEL: define <4 x half> @constrained_call_half4_trunc(<4 x half> %x0) #0 {
; CHECK:         %call = call <4 x half> @llvm.experimental.constrained.trunc.v4f16(<4 x half> %x0, metadata !"fpexcept.maytrap")
; CHECK:         ret <4 x half> %call
; CHECK:       }
define <4 x half> @constrained_call_half4_trunc(<4 x half> %x0) #0 {
  %call = call <4 x half> @half4_trunc(<4 x half> %x0)
  ret <4 x half> %call
}

attributes #0 = { strictfp }
