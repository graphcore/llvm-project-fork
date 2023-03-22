; RUN: llc < %s -march=colossus -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -march=colossus -mattr=+ipu2 | FileCheck %s

; Check basic supported f32 operations.

declare float @llvm.cos.f32(float)
declare float @llvm.experimental.constrained.cos.f32(float, metadata, metadata)
declare float @llvm.exp.f32(float)
declare float @llvm.experimental.constrained.exp.f32(float, metadata, metadata)
declare float @llvm.exp2.f32(float)
declare float @llvm.experimental.constrained.exp2.f32(float, metadata, metadata)
declare float @llvm.log.f32(float)
declare float @llvm.experimental.constrained.log.f32(float, metadata, metadata)
declare float @llvm.log10.f32(float)
declare float @llvm.experimental.constrained.log10.f32(float, metadata, metadata)
declare float @llvm.log2.f32(float)
declare float @llvm.experimental.constrained.log2.f32(float, metadata, metadata)
declare float @llvm.sin.f32(float)
declare float @llvm.experimental.constrained.sin.f32(float, metadata, metadata)
declare float @llvm.sqrt.f32(float)
declare float @llvm.pow.f32(float, float)
declare float @llvm.minnum.f32(float, float)
declare float @llvm.maxnum.f32(float, float)
declare i32 @llvm.flt.rounds()

declare float @llvm.experimental.constrained.fadd.f32(float, float, metadata, metadata)
declare float @llvm.experimental.constrained.fsub.f32(float, float, metadata, metadata)
declare float @llvm.experimental.constrained.fmul.f32(float, float, metadata, metadata)
declare float @llvm.experimental.constrained.fdiv.f32(float, float, metadata, metadata)
declare float @llvm.experimental.constrained.frem.f32(float, float, metadata, metadata)
declare float @llvm.experimental.constrained.sqrt.f32(float, metadata, metadata)
declare float @llvm.experimental.constrained.pow.f32(float, float, metadata, metadata)
declare float @llvm.experimental.constrained.minnum.f32(float, float, metadata)
declare float @llvm.experimental.constrained.maxnum.f32(float, float, metadata)

declare float @llvm.colossus.rsqrt.f32(float)
declare float @llvm.colossus.constrained.rsqrt.f32(float)

;===------------------------------------------------------------------------===;
; Supported operations.
;===------------------------------------------------------------------------===;

; CHECK-LABEL: f32_add:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f32add $a0, $a0, $a1
; CHECK-NEXT:  }

define float @f32_add(float %x, float %y) {
  %a = fadd float %x, %y
  ret float %a
}

; CHECK-LABEL: strict_f32_add:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f32add $a0, $a0, $a1
; CHECK-NEXT:  }

define float @strict_f32_add(float %x, float %y) {
  %a = call float @llvm.experimental.constrained.fadd.f32(float %x, float %y, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret float %a
}

; CHECK-LABEL: f32_sub:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f32sub $a0, $a0, $a1
; CHECK-NEXT:  }

define float @f32_sub(float %x, float %y) {
  %a = fsub float %x, %y
  ret float %a
}

; CHECK-LABEL: strict_f32_sub:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f32sub $a0, $a0, $a1
; CHECK-NEXT:  }

define float @strict_f32_sub(float %x, float %y) {
  %a = call float @llvm.experimental.constrained.fsub.f32(float %x, float %y, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret float %a
}

; CHECK-LABEL: f32_mul:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f32mul $a0, $a0, $a1
; CHECK-NEXT:  }

define float @f32_mul(float %x, float %y) {
  %a = fmul float %x, %y
  ret float %a
}

; CHECK-LABEL: strict_f32_mul:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f32mul $a0, $a0, $a1
; CHECK-NEXT:  }

define float @strict_f32_mul(float %x, float %y) {
  %a = call float @llvm.experimental.constrained.fmul.f32(float %x, float %y, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret float %a
}

; CHECK-LABEL: f32_div:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f32div $a0, $a0, $a1
; CHECK-NEXT:  }

define float @f32_div(float %x, float %y) {
  %a = fdiv float %x, %y
  ret float %a
}

; CHECK-LABEL: strict_f32_div:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f32div $a0, $a0, $a1
; CHECK-NEXT:  }

define float @strict_f32_div(float %x, float %y) {
  %a = call float @llvm.experimental.constrained.fdiv.f32(float %x, float %y, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret float %a
}

; CHECK-LABEL: f32_frem:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m10, $m11, $m15, 1
; CHECK-NEXT:  call $m10, fmodf
; CHECK-NEXT:  ld32 $m10, $m11, $m15, 1
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10

define float @f32_frem(float %x, float %y) {
  %a = frem float %x, %y
  ret float %a
}

; CHECK-LABEL: strict_f32_frem:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m10, $m11, $m15, 1
; CHECK-NEXT:  call $m10, fmodf
; CHECK-NEXT:  ld32 $m10, $m11, $m15, 1
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10

define float @strict_f32_frem(float %x, float %y) {
  %a = call float @llvm.experimental.constrained.frem.f32(float %x, float %y, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret float %a
}

; CHECK-LABEL: f32_sqrt:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f32sqrt $a0, $a0
; CHECK-NEXT:  }

define float @f32_sqrt(float %x) {
  %a = call float @llvm.sqrt.f32(float %x)
  ret float %a
}

; CHECK-LABEL: strict_f32_sqrt:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f32sqrt $a0, $a0
; CHECK-NEXT:  }

define float @strict_f32_sqrt(float %x) {
  %a = call float @llvm.experimental.constrained.sqrt.f32(float %x, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret float %a
}

; CHECK-LABEL: f32_rsqrt:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f32oorx $a0, $a0
; CHECK-NEXT:  }
define float @f32_rsqrt(float %x) {
  %a = call float @llvm.colossus.rsqrt.f32(float %x)
  ret float %a
}

; CHECK-LABEL: strict_f32_rsqrt:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f32oorx $a0, $a0
; CHECK-NEXT:  }
define float @strict_f32_rsqrt(float %x) {
  %a = call float @llvm.colossus.constrained.rsqrt.f32(float %x)
  ret float %a
}

; CHECK-LABEL: f32_rsqrt_combine:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f32oorx $a0, $a0
; CHECK-NEXT:  }
define float @f32_rsqrt_combine(float %x) {
  %a = call float @llvm.sqrt.f32(float %x)
  %b = fdiv float 1.0, %a
  ret float %b
}

; CHECK-LABEL: strict_f32_rsqrt_combine:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f32oorx $a0, $a0
; CHECK-NEXT:  }
define float @strict_f32_rsqrt_combine(float %x) {
  %a = call float @llvm.experimental.constrained.sqrt.f32(float %x, metadata !"round.tonearest", metadata !"fpexcept.strict")
  %b = call float @llvm.experimental.constrained.fdiv.f32(float 1.0, float %a, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret float %b
}

; CHECK-LABEL: call_sin_f32:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m10, $m11, $m15, 1
; CHECK-NEXT:  call $m10, sinf
; CHECK-NEXT:  ld32 $m10, $m11, $m15, 1
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10

define float @call_sin_f32(float %x) {
  %res = call float @llvm.sin.f32(float %x)
  ret float %res
}

; CHECK-LABEL: call_constrained_sin_f32:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m10, $m11, $m15, 1
; CHECK-NEXT:  call $m10, sinf
; CHECK-NEXT:  ld32 $m10, $m11, $m15, 1
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10

define float @call_constrained_sin_f32(float %x) {
  %res = call float @llvm.experimental.constrained.sin.f32(float %x, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret float %res
}

; CHECK-LABEL: call_cos_f32:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m10, $m11, $m15, 1
; CHECK-NEXT:  call $m10, cosf
; CHECK-NEXT:  ld32 $m10, $m11, $m15, 1
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10

define float @call_cos_f32(float %x) {
  %res = call float @llvm.cos.f32(float %x)
  ret float %res
}

; CHECK-LABEL: call_constrained_cos_f32:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m10, $m11, $m15, 1
; CHECK-NEXT:  call $m10, cosf
; CHECK-NEXT:  ld32 $m10, $m11, $m15, 1
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10

define float @call_constrained_cos_f32(float %x) {
  %res = call float @llvm.experimental.constrained.cos.f32(float %x, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret float %res
}

; CHECK-LABEL: f32_min:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f32min $a0, $a0, $a1
; CHECK-NEXT:  }

define float @f32_min(float %x, float %y) {
  %a = call float @llvm.minnum.f32(float %x, float %y)
  ret float %a
}

; CHECK-LABEL: constrained_f32_min:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f32min $a0, $a0, $a1
; CHECK-NEXT:  }

define float @constrained_f32_min(float %x, float %y) {
  %a = call float @llvm.experimental.constrained.minnum.f32(float %x, float %y, metadata !"fpexcept.strict")
  ret float %a
}

; CHECK-LABEL: f32_max:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f32max $a0, $a0, $a1
; CHECK-NEXT:  }

define float @f32_max(float %x, float %y) {
  %a = call float @llvm.maxnum.f32(float %x, float %y)
  ret float %a
}

; CHECK-LABEL: constrained_f32_max:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f32max $a0, $a0, $a1
; CHECK-NEXT:  }

define float @constrained_f32_max(float %x, float %y) {
  %a = call float @llvm.experimental.constrained.maxnum.f32(float %x, float %y, metadata !"fpexcept.strict")
  ret float %a
}

; CHECK-LABEL: flt_rounds:
; CHECK:       # %bb.0:
; CHECK-NEXT:  setzi $m0, 1
; CHECK:       br $m10

define i32 @flt_rounds() {
  %mode = call i32 @llvm.flt.rounds( )
  ret i32 %mode
}

; CHECK-LABEL: call_pow_f32:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m10, $m11, $m15, 1
; CHECK-NEXT:  call $m10, powf
; CHECK-NEXT:  ld32 $m10, $m11, $m15, 1
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10

define float @call_pow_f32(float %x, float %y) {
  %res = call float @llvm.pow.f32(float %x, float %y)
  ret float %res
}

; CHECK-LABEL: call_constrained_pow_f32:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m10, $m11, $m15, 1
; CHECK-NEXT:  call $m10, powf
; CHECK-NEXT:  ld32 $m10, $m11, $m15, 1
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10

define float @call_constrained_pow_f32(float %x, float %y) {
  %res = call float @llvm.experimental.constrained.pow.f32(float %x, float %y, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret float %res
}

;===------------------------------------------------------------------------===;
; Unsupported operations.
;===------------------------------------------------------------------------===;

; FGETSIGN
; FMAD
; FNEG
; FPOWI
; FMINNAN
; FMAXNAN
; FSINCOS

;===------------------------------------------------------------------------===;
; Bitwise operations.
;===------------------------------------------------------------------------===;

; CHECK-LABEL: f32_not_a:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  not $a0, $a0
; CHECK-NEXT:  }

define float @f32_not_a(float %x) {
  %xi = bitcast float %x to i32
  %res = xor i32 %xi, -1
  %resf = bitcast i32 %res to float
  ret float %resf
}

; CHECK-LABEL: f32_not_b:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  not $a0, $a0
; CHECK-NEXT:  }

define float @f32_not_b(float %x) {
  %xi = bitcast float %x to i32
  %res = xor i32 -1, %xi
  %resf = bitcast i32 %res to float
  ret float %resf
}

; CHECK-LABEL: f32_and_both_cast:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  and $a0, $a0, $a1
; CHECK-NEXT:  }

define float @f32_and_both_cast(float %x, float %y) {
  %xi = bitcast float %x to i32
  %yi = bitcast float %y to i32
  %res = and i32 %xi, %yi
  %resf = bitcast i32 %res to float
  ret float %resf
}

; CHECK-LABEL: f32_and_left_cast:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m0, $m11, $m15, 1
; CHECK-NEXT:  ld32 $a1, $m11, $m15, 1
; CHECK-NEXT:  {
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK-NEXT:  and $a0, $a0, $a1
; CHECK-NEXT:  }
; CHECK:       br $m10

define float @f32_and_left_cast(float %x, i32 %y) {
  %xi = bitcast float %x to i32
  %res = and i32 %xi, %y
  %resf = bitcast i32 %res to float
  ret float %resf
}

; CHECK-LABEL: f32_and_right_cast:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m0, $m11, $m15, 1
; CHECK-NEXT:  ld32 $a1, $m11, $m15, 1
; CHECK-NEXT:  {
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK-NEXT:  and $a0, $a1, $a0
; CHECK-NEXT:  }
; CHECK:       br $m10

define float @f32_and_right_cast(i32 %x, float %y) {
  %yi = bitcast float %y to i32
  %res = and i32 %x, %yi
  %resf = bitcast i32 %res to float
  ret float %resf
}

; CHECK-LABEL: f32_or_both_cast:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  or $a0, $a0, $a1
; CHECK-NEXT:  }

define float @f32_or_both_cast(float %x, float %y) {
  %xi = bitcast float %x to i32
  %yi = bitcast float %y to i32
  %res = or i32 %xi, %yi
  %resf = bitcast i32 %res to float
  ret float %resf
}

; CHECK-LABEL: f32_or_left_cast:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m0, $m11, $m15, 1
; CHECK-NEXT:  ld32 $a1, $m11, $m15, 1
; CHECK-NEXT:  {
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK-NEXT:  or $a0, $a0, $a1
; CHECK-NEXT:  }
; CHECK:       br $m10

define float @f32_or_left_cast(float %x, i32 %y) {
  %xi = bitcast float %x to i32
  %res = or i32 %xi, %y
  %resf = bitcast i32 %res to float
  ret float %resf
}

; CHECK-LABEL: f32_or_right_cast:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m0, $m11, $m15, 1
; CHECK-NEXT:  ld32 $a1, $m11, $m15, 1
; CHECK-NEXT:  {
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK-NEXT:  or $a0, $a1, $a0
; CHECK-NEXT:  }
; CHECK:       br $m10

define float @f32_or_right_cast(i32 %x, float %y) {
  %yi = bitcast float %y to i32
  %res = or i32 %x, %yi
  %resf = bitcast i32 %res to float
  ret float %resf
}
