; RUN: llc < %s -march=colossus -mattr=\+supervisor,+ipu1 | FileCheck %s
; RUN: llc < %s -march=colossus -mattr=\+supervisor,+ipu2 | FileCheck %s

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
declare float @llvm.experimental.constrained.sqrt.f32(float, metadata, metadata)
declare float @llvm.experimental.constrained.pow.f32(float, float, metadata, metadata)
declare float @llvm.experimental.constrained.minnum.f32(float, float, metadata)
declare float @llvm.experimental.constrained.maxnum.f32(float, float, metadata)

;===------------------------------------------------------------------------===;
; Supported operations.
;===------------------------------------------------------------------------===;

; CHECK-LABEL: f32_add:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m10, $m11, $m15, 1
; CHECK-NEXT:  call $m10, __addsf3
; CHECK-NEXT:  ld32 $m10, $m11, $m15, 1
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10
define float @f32_add(float %x, float %y) {
  %a = fadd float %x, %y
  ret float %a
}

; CHECK-LABEL: strict_f32_add:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m10, $m11, $m15, 1
; CHECK-NEXT:  call $m10, __addsf3
; CHECK-NEXT:  ld32 $m10, $m11, $m15, 1
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10
define float @strict_f32_add(float %x, float %y) {
  %a = call float @llvm.experimental.constrained.fadd.f32(float %x, float %y, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret float %a
}

; CHECK-LABEL:f32_sub:
; CHECK:        # %bb.0:
; CHECK:        add $m11, $m11, -8
; CHECK:        st32 $m10, $m11, $m15, 1
; CHECK-NEXT:   call $m10, __subsf3
; CHECK-NEXT:   ld32 $m10, $m11, $m15, 1
; CHECK-NEXT:   add $m11, $m11, 8
; CHECK:        br $m10
define float @f32_sub(float %x, float %y) {
  %a = fsub float %x, %y
  ret float %a
}

; CHECK-LABEL:strict_f32_sub:
; CHECK:        # %bb.0:
; CHECK:        add $m11, $m11, -8
; CHECK:        st32 $m10, $m11, $m15, 1
; CHECK-NEXT:   call $m10, __subsf3
; CHECK-NEXT:   ld32 $m10, $m11, $m15, 1
; CHECK-NEXT:   add $m11, $m11, 8
; CHECK:        br $m10
define float @strict_f32_sub(float %x, float %y) {
  %a = call float @llvm.experimental.constrained.fsub.f32(float %x, float %y, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret float %a
}

; CHECK-LABEL: f32_mul:
; CHECK:        # %bb.0:
; CHECK:        add $m11, $m11, -8
; CHECK:        st32 $m10, $m11, $m15, 1
; CHECK-NEXT:   call $m10, __mulsf3
; CHECK-NEXT:   ld32 $m10, $m11, $m15, 1
; CHECK-NEXT:   add $m11, $m11, 8
; CHECK:        br $m10
define float @f32_mul(float %x, float %y) {
  %a = fmul float %x, %y
  ret float %a
}

; CHECK-LABEL: strict_f32_mul:
; CHECK:        # %bb.0:
; CHECK:        add $m11, $m11, -8
; CHECK:        st32 $m10, $m11, $m15, 1
; CHECK-NEXT:   call $m10, __mulsf3
; CHECK-NEXT:   ld32 $m10, $m11, $m15, 1
; CHECK-NEXT:   add $m11, $m11, 8
; CHECK:        br $m10
define float @strict_f32_mul(float %x, float %y) {
  %a = call float @llvm.experimental.constrained.fmul.f32(float %x, float %y, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret float %a
}

; CHECK-LABEL: f32_div:
; CHECK:        # %bb.0:
; CHECK:        add $m11, $m11, -8
; CHECK:        st32 $m10, $m11, $m15, 1
; CHECK-NEXT:   call $m10, __divsf3
; CHECK-NEXT:   ld32 $m10, $m11, $m15, 1
; CHECK-NEXT:   add $m11, $m11, 8
; CHECK:        br $m10
define float @f32_div(float %x, float %y) {
  %a = fdiv float %x, %y
  ret float %a
  ret float %a
}

; CHECK-LABEL: strict_f32_div:
; CHECK:        # %bb.0:
; CHECK:        add $m11, $m11, -8
; CHECK:        st32 $m10, $m11, $m15, 1
; CHECK-NEXT:   call $m10, __divsf3
; CHECK-NEXT:   ld32 $m10, $m11, $m15, 1
; CHECK-NEXT:   add $m11, $m11, 8
; CHECK:        br $m10
define float @strict_f32_div(float %x, float %y) {
  %a = call float @llvm.experimental.constrained.fdiv.f32(float %x, float %y, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret float %a
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

declare float @llvm.experimental.constrained.frem.f32(float, float, metadata, metadata)

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

; CHECK-LABEL: f32_exp:
; CHECK:        # %bb.0:
; CHECK:        add $m11, $m11, -8
; CHECK:        st32 $m10, $m11, $m15, 1
; CHECK-NEXT:   call $m10, expf
; CHECK-NEXT:   ld32 $m10, $m11, $m15, 1
; CHECK-NEXT:   add $m11, $m11, 8
; CHECK:        br $m10
define float @f32_exp(float %x) {
  %a = call float @llvm.exp.f32(float %x)
  ret float %a
}

; CHECK-LABEL: strict_f32_exp:
; CHECK:        # %bb.0:
; CHECK:        add $m11, $m11, -8
; CHECK:        st32 $m10, $m11, $m15, 1
; CHECK-NEXT:   call $m10, expf
; CHECK-NEXT:   ld32 $m10, $m11, $m15, 1
; CHECK-NEXT:   add $m11, $m11, 8
; CHECK:        br $m10
define float @strict_f32_exp(float %x) {
  %a = call float @llvm.experimental.constrained.exp.f32(float %x, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret float %a
}

; CHECK-LABEL: f32_exp2:
; CHECK:        # %bb.0:
; CHECK:        add $m11, $m11, -8
; CHECK:        st32 $m10, $m11, $m15, 1
; CHECK-NEXT:   call $m10, exp2f
; CHECK-NEXT:   ld32 $m10, $m11, $m15, 1
; CHECK-NEXT:   add $m11, $m11, 8
; CHECK:        br $m10
define float @f32_exp2(float %x) {
  %a = call float @llvm.exp2.f32(float %x)
  ret float %a
}

; CHECK-LABEL: strict_f32_exp2:
; CHECK:        # %bb.0:
; CHECK:        add $m11, $m11, -8
; CHECK:        st32 $m10, $m11, $m15, 1
; CHECK-NEXT:   call $m10, exp2f
; CHECK-NEXT:   ld32 $m10, $m11, $m15, 1
; CHECK-NEXT:   add $m11, $m11, 8
; CHECK:        br $m10
define float @strict_f32_exp2(float %x) {
  %a = call float @llvm.experimental.constrained.exp2.f32(float %x, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret float %a
}

; CHECK-LABEL: f32_log:
; CHECK:        # %bb.0:
; CHECK:        add $m11, $m11, -8
; CHECK:        st32 $m10, $m11, $m15, 1
; CHECK-NEXT:   call $m10, logf
; CHECK-NEXT:   ld32 $m10, $m11, $m15, 1
; CHECK-NEXT:   add $m11, $m11, 8
; CHECK:        br $m10
define float @f32_log(float %x) {
  %a = call float @llvm.log.f32(float %x)
  ret float %a
}

; CHECK-LABEL: strict_f32_log:
; CHECK:        # %bb.0:
; CHECK:        add $m11, $m11, -8
; CHECK:        st32 $m10, $m11, $m15, 1
; CHECK-NEXT:   call $m10, logf
; CHECK-NEXT:   ld32 $m10, $m11, $m15, 1
; CHECK-NEXT:   add $m11, $m11, 8
; CHECK:        br $m10
define float @strict_f32_log(float %x) {
  %a = call float @llvm.experimental.constrained.log.f32(float %x, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret float %a
}

; CHECK-LABEL: call_log10_f32:
; CHECK:        # %bb.0:
; CHECK:        add $m11, $m11, -8
; CHECK:        st32 $m10, $m11, $m15, 1
; CHECK-NEXT:   call $m10, log10f
; CHECK-NEXT:   ld32 $m10, $m11, $m15, 1
; CHECK-NEXT:   add $m11, $m11, 8
; CHECK:        br $m10
define float @call_log10_f32(float %x) {
  %res = call float @llvm.log10.f32(float %x)
  ret float %res
}

; CHECK-LABEL: call_constrained_log10_f32:
; CHECK:        # %bb.0:
; CHECK:        add $m11, $m11, -8
; CHECK:        st32 $m10, $m11, $m15, 1
; CHECK-NEXT:   call $m10, log10f
; CHECK-NEXT:   ld32 $m10, $m11, $m15, 1
; CHECK-NEXT:   add $m11, $m11, 8
; CHECK:        br $m10
define float @call_constrained_log10_f32(float %x) {
  %res = call float @llvm.experimental.constrained.log10.f32(float %x, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret float %res
}

; CHECK-LABEL: call_log2_f32:
; CHECK:        # %bb.0:
; CHECK:        add $m11, $m11, -8
; CHECK:        st32 $m10, $m11, $m15, 1
; CHECK-NEXT:   call $m10, log2f
; CHECK-NEXT:   ld32 $m10, $m11, $m15, 1
; CHECK-NEXT:   add $m11, $m11, 8
; CHECK:        br $m10
define float @call_log2_f32(float %x) {
  %res = call float @llvm.log2.f32(float %x)
  ret float %res
}

; CHECK-LABEL: call_constrained_log2_f32:
; CHECK:        # %bb.0:
; CHECK:        add $m11, $m11, -8
; CHECK:        st32 $m10, $m11, $m15, 1
; CHECK-NEXT:   call $m10, log2f
; CHECK-NEXT:   ld32 $m10, $m11, $m15, 1
; CHECK-NEXT:   add $m11, $m11, 8
; CHECK:        br $m10
define float @call_constrained_log2_f32(float %x) {
  %res = call float @llvm.experimental.constrained.log2.f32(float %x, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret float %res
}

; CHECK-LABEL: f32_sqrt:
; CHECK:        # %bb.0:
; CHECK:        add $m11, $m11, -8
; CHECK:        st32 $m10, $m11, $m15, 1
; CHECK-NEXT:   call $m10, sqrtf
; CHECK-NEXT:   ld32 $m10, $m11, $m15, 1
; CHECK-NEXT:   add $m11, $m11, 8
; CHECK:        br $m10
define float @f32_sqrt(float %x) {
  %a = call float @llvm.sqrt.f32(float %x)
  ret float %a
}

; CHECK-LABEL: strict_f32_sqrt:
; CHECK:        # %bb.0:
; CHECK:        add $m11, $m11, -8
; CHECK:        st32 $m10, $m11, $m15, 1
; CHECK-NEXT:   call $m10, sqrtf
; CHECK-NEXT:   ld32 $m10, $m11, $m15, 1
; CHECK-NEXT:   add $m11, $m11, 8
; CHECK:        br $m10
define float @strict_f32_sqrt(float %x) {
  %a = call float @llvm.experimental.constrained.sqrt.f32(float %x, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret float %a
}

; CHECK-LABEL: call_sin_f32:
; CHECK:        # %bb.0:
; CHECK:        add $m11, $m11, -8
; CHECK:        st32 $m10, $m11, $m15, 1
; CHECK-NEXT:   call $m10, sinf
; CHECK-NEXT:   ld32 $m10, $m11, $m15, 1
; CHECK-NEXT:   add $m11, $m11, 8
; CHECK:        br $m10
define float @call_sin_f32(float %x) {
  %res = call float @llvm.sin.f32(float %x)
  ret float %res
}

; CHECK-LABEL: call_constrained_sin_f32:
; CHECK:        # %bb.0:
; CHECK:        add $m11, $m11, -8
; CHECK:        st32 $m10, $m11, $m15, 1
; CHECK-NEXT:   call $m10, sinf
; CHECK-NEXT:   ld32 $m10, $m11, $m15, 1
; CHECK-NEXT:   add $m11, $m11, 8
; CHECK:        br $m10
define float @call_constrained_sin_f32(float %x) {
  %res = call float @llvm.experimental.constrained.sin.f32(float %x, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret float %res
}

; CHECK-LABEL: call_cos_f32:
; CHECK:        # %bb.0:
; CHECK:        add $m11, $m11, -8
; CHECK:        st32 $m10, $m11, $m15, 1
; CHECK-NEXT:   call $m10, cosf
; CHECK-NEXT:   ld32 $m10, $m11, $m15, 1
; CHECK-NEXT:   add $m11, $m11, 8
; CHECK:        br $m10
define float @call_cos_f32(float %x) {
  %res = call float @llvm.cos.f32(float %x)
  ret float %res
}

; CHECK-LABEL: call_constrained_cos_f32:
; CHECK:        # %bb.0:
; CHECK:        add $m11, $m11, -8
; CHECK:        st32 $m10, $m11, $m15, 1
; CHECK-NEXT:   call $m10, cosf
; CHECK-NEXT:   ld32 $m10, $m11, $m15, 1
; CHECK-NEXT:   add $m11, $m11, 8
; CHECK:        br $m10
define float @call_constrained_cos_f32(float %x) {
  %res = call float @llvm.experimental.constrained.cos.f32(float %x, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret float %res
}

; CHECK-LABEL: f32_min:
; CHECK:        # %bb.0:
; CHECK:        add $m11, $m11, -8
; CHECK:        st32 $m10, $m11, $m15, 1
; CHECK-NEXT:   call $m10, fminf
; CHECK-NEXT:   ld32 $m10, $m11, $m15, 1
; CHECK-NEXT:   add $m11, $m11, 8
; CHECK:        br $m10
define float @f32_min(float %x, float %y) {
  %a = call float @llvm.minnum.f32(float %x, float %y)
  ret float %a
}

; CHECK-LABEL: constrained_f32_min:
; CHECK:        # %bb.0:
; CHECK:        add $m11, $m11, -8
; CHECK:        st32 $m10, $m11, $m15, 1
; CHECK-NEXT:   call $m10, fminf
; CHECK-NEXT:   ld32 $m10, $m11, $m15, 1
; CHECK-NEXT:   add $m11, $m11, 8
; CHECK:        br $m10
define float @constrained_f32_min(float %x, float %y) {
  %a = call float @llvm.experimental.constrained.minnum.f32(float %x, float %y, metadata !"fpexcept.strict")
  ret float %a
}

; CHECK-LABEL: f32_max:
; CHECK:        # %bb.0:
; CHECK:        add $m11, $m11, -8
; CHECK:        st32 $m10, $m11, $m15, 1
; CHECK-NEXT:   call $m10, fmaxf
; CHECK-NEXT:   ld32 $m10, $m11, $m15, 1
; CHECK-NEXT:   add $m11, $m11, 8
; CHECK:        br $m10
define float @f32_max(float %x, float %y) {
  %a = call float @llvm.maxnum.f32(float %x, float %y)
  ret float %a
}

; CHECK-LABEL: constrained_f32_max:
; CHECK:        # %bb.0:
; CHECK:        add $m11, $m11, -8
; CHECK:        st32 $m10, $m11, $m15, 1
; CHECK-NEXT:   call $m10, fmaxf
; CHECK-NEXT:   ld32 $m10, $m11, $m15, 1
; CHECK-NEXT:   add $m11, $m11, 8
; CHECK:        br $m10
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
; CHECK:          # %bb.0:
; CHECK-NEXT:     xnor $m0, $m0, $m15
; CHECK:          br $m10
define float @f32_not_a(float %x) {
  %xi = bitcast float %x to i32
  %res = xor i32 %xi, -1
  %resf = bitcast i32 %res to float
  ret float %resf
}

; CHECK-LABEL: f32_not_b:
; CHECK:          # %bb.0:
; CHECK-NEXT:     xnor $m0, $m0, $m15
; CHECK:          br $m10
define float @f32_not_b(float %x) {
  %xi = bitcast float %x to i32
  %res = xor i32 -1, %xi
  %resf = bitcast i32 %res to float
  ret float %resf
}

; CHECK-LABEL: f32_and_both_cast:
; CHECK:          # %bb.0:
; CHECK-NEXT:     and $m0, $m0, $m1
; CHECK:          br $m10
define float @f32_and_both_cast(float %x, float %y) {
  %xi = bitcast float %x to i32
  %yi = bitcast float %y to i32
  %res = and i32 %xi, %yi
  %resf = bitcast i32 %res to float
  ret float %resf
}

; CHECK-LABEL: f32_and_left_cast:
; CHECK:          # %bb.0:
; CHECK-NEXT:     and $m0, $m0, $m1
; CHECK:          br $m10
define float @f32_and_left_cast(float %x, i32 %y) {
  %xi = bitcast float %x to i32
  %res = and i32 %xi, %y
  %resf = bitcast i32 %res to float
  ret float %resf
}

; CHECK-LABEL: f32_and_right_cast:
; CHECK:          # %bb.0:
; CHECK-NEXT:     and $m0, $m0, $m1
; CHECK:          br $m10
define float @f32_and_right_cast(i32 %x, float %y) {
  %yi = bitcast float %y to i32
  %res = and i32 %x, %yi
  %resf = bitcast i32 %res to float
  ret float %resf
}

; CHECK-LABEL: f32_or_both_cast:
; CHECK:          # %bb.0:
; CHECK-NEXT:     or $m0, $m0, $m1
; CHECK:          br $m10
define float @f32_or_both_cast(float %x, float %y) {
  %xi = bitcast float %x to i32
  %yi = bitcast float %y to i32
  %res = or i32 %xi, %yi
  %resf = bitcast i32 %res to float
  ret float %resf
}

; CHECK-LABEL: f32_or_left_cast:
; CHECK:          # %bb.0:
; CHECK-NEXT:     or $m0, $m0, $m1
; CHECK:          br $m10
define float @f32_or_left_cast(float %x, i32 %y) {
  %xi = bitcast float %x to i32
  %res = or i32 %xi, %y
  %resf = bitcast i32 %res to float
  ret float %resf
}

; CHECK-LABEL: f32_or_right_cast:
; CHECK:          # %bb.0:
; CHECK-NEXT:     or $m0, $m0, $m1
; CHECK:          br $m10
define float @f32_or_right_cast(i32 %x, float %y) {
  %yi = bitcast float %y to i32
  %res = or i32 %x, %yi
  %resf = bitcast i32 %res to float
  ret float %resf
}
