; RUN: llc < %s -mtriple=colossus -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -mtriple=colossus -mattr=+ipu2 | FileCheck %s

;;; Broadcast from a scalar

; CHECK-LABEL: add_vector_vector:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2add $a0, $a0, $a1
; CHECK-NEXT:  }
define <2 x half> @add_vector_vector(<2 x half> %a, <2 x half> %b) {
  %res = fadd <2 x half> %a, %b
  ret <2 x half> %res
}

declare <2 x half> @llvm.experimental.constrained.fadd.v2f16(<2 x half>, <2 x half>, metadata, metadata)

; CHECK-LABEL: strict_add_vector_vector:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2add $a0, $a0, $a1
; CHECK-NEXT:  }
define <2 x half> @strict_add_vector_vector(<2 x half> %a, <2 x half> %b) {
  %res = call <2 x half> @llvm.experimental.constrained.fadd.v2f16(<2 x half> %a, <2 x half> %b, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <2 x half> %res
}

; CHECK-LABEL: add_vector_scalar:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2add $a0, $a1:BL, $a0
; CHECK-NEXT:  }
define <2 x half> @add_vector_scalar(<2 x half> %a, half %b) {
  %s0 = insertelement <2 x half> undef, half %b, i32 0
  %s1 = insertelement <2 x half> %s0, half %b, i32 1
  %res = fadd <2 x half> %a, %s1
  ret <2 x half> %res
}

; CHECK-LABEL: strict_add_vector_scalar:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2add $a0, $a1:BL, $a0
; CHECK-NEXT:  }
define <2 x half> @strict_add_vector_scalar(<2 x half> %a, half %b) {
  %s0 = insertelement <2 x half> undef, half %b, i32 0
  %s1 = insertelement <2 x half> %s0, half %b, i32 1
  %res = call <2 x half> @llvm.experimental.constrained.fadd.v2f16(<2 x half> %a, <2 x half> %s1, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <2 x half> %res
}

; CHECK-LABEL: add_scalar_vector:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2add $a0, $a0:BL, $a1
; CHECK-NEXT:  }
define <2 x half> @add_scalar_vector(half %a, <2 x half> %b) {
  %s0 = insertelement <2 x half> undef, half %a, i32 0
  %s1 = insertelement <2 x half> %s0, half %a, i32 1
  %res = fadd <2 x half> %s1, %b
  ret <2 x half> %res
}

; CHECK-LABEL: strict_add_scalar_vector:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2add $a0, $a0:BL, $a1
; CHECK-NEXT:  }
define <2 x half> @strict_add_scalar_vector(half %a, <2 x half> %b) {
  %s0 = insertelement <2 x half> undef, half %a, i32 0
  %s1 = insertelement <2 x half> %s0, half %a, i32 1
  %res = call <2 x half> @llvm.experimental.constrained.fadd.v2f16(<2 x half> %s1, <2 x half> %b, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <2 x half> %res
}

; CHECK-LABEL: add_vector_zero:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2add $a0, $a0, $a15
; CHECK-NEXT:  }
define <2 x half> @add_vector_zero(<2 x half> %a) {
    %res = fadd <2 x half> %a, <half 0xH0, half 0xH0>
    ret <2 x half> %res
}

; CHECK-LABEL: strict_add_vector_zero:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2add $a0, $a0, $a15
; CHECK-NEXT:  }
define <2 x half> @strict_add_vector_zero(<2 x half> %a) {
  %res = call <2 x half> @llvm.experimental.constrained.fadd.v2f16(<2 x half> %a, <2 x half> <half 0xH0, half 0xH0>, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <2 x half> %res
}

; CHECK-LABEL: sub_vector_vector:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2sub $a0, $a0, $a1
; CHECK-NEXT:  }
define <2 x half> @sub_vector_vector(<2 x half> %a, <2 x half> %b) {
  %res = fsub <2 x half> %a, %b
  ret <2 x half> %res
}

declare <2 x half> @llvm.experimental.constrained.fsub.v2f16(<2 x half>, <2 x half>, metadata, metadata)

; CHECK-LABEL: strict_sub_vector_vector:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2sub $a0, $a0, $a1
; CHECK-NEXT:  }
define <2 x half> @strict_sub_vector_vector(<2 x half> %a, <2 x half> %b) {
  %res = call <2 x half> @llvm.experimental.constrained.fsub.v2f16(<2 x half> %a, <2 x half> %b, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <2 x half> %res
}

; CHECK-LABEL: sub_vector_scalar:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a1, $a1, $a1
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2sub $a0, $a0, $a1
; CHECK-NEXT:  }
define <2 x half> @sub_vector_scalar(<2 x half> %a, half %b) {
  %s0 = insertelement <2 x half> undef, half %b, i32 0
  %s1 = insertelement <2 x half> %s0, half %b, i32 1
  %res = fsub <2 x half> %a, %s1
  ret <2 x half> %res
}

; CHECK-LABEL: strict_sub_vector_scalar:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a1, $a1, $a1
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2sub $a0, $a0, $a1
; CHECK-NEXT:  }
define <2 x half> @strict_sub_vector_scalar(<2 x half> %a, half %b) {
  %s0 = insertelement <2 x half> undef, half %b, i32 0
  %s1 = insertelement <2 x half> %s0, half %b, i32 1
  %res = call <2 x half> @llvm.experimental.constrained.fsub.v2f16(<2 x half> %a, <2 x half> %s1, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <2 x half> %res
}

; CHECK-LABEL: sub_scalar_vector:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2sub $a0, $a0:BL, $a1
; CHECK-NEXT:  }
define <2 x half> @sub_scalar_vector(half %a, <2 x half> %b) {
  %s0 = insertelement <2 x half> undef, half %a, i32 0
  %s1 = insertelement <2 x half> %s0, half %a, i32 1
  %res = fsub <2 x half> %s1, %b
  ret <2 x half> %res
}

; CHECK-LABEL: strict_sub_scalar_vector:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2sub $a0, $a0:BL, $a1
; CHECK-NEXT:  }
define <2 x half> @strict_sub_scalar_vector(half %a, <2 x half> %b) {
  %s0 = insertelement <2 x half> undef, half %a, i32 0
  %s1 = insertelement <2 x half> %s0, half %a, i32 1
  %res = call <2 x half> @llvm.experimental.constrained.fsub.v2f16(<2 x half> %s1, <2 x half> %b, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <2 x half> %res
}

; CHECK-LABEL: sub_vector_zero:
; CHECK:       # %bb
; CHECK-NEXT:  br $m10
define <2 x half> @sub_vector_zero(<2 x half> %a) {
    %res = fsub <2 x half> %a, <half 0xH0, half 0xH0>
    ret <2 x half> %res
}

; T29761 tracks the useless f16v2sub
; CHECK-LABEL: strict_sub_vector_zero:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:    br $m10
; CHECK-NEXT:    f16v2sub $a0, $a0, $a15
; CHECK-NEXT:  }
define <2 x half> @strict_sub_vector_zero(<2 x half> %a) {
  %res = call <2 x half> @llvm.experimental.constrained.fsub.v2f16(<2 x half> %a, <2 x half> <half 0xH0, half 0xH0>, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <2 x half> %res
}

; CHECK-LABEL: mul_vector_vector:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2mul $a0, $a0, $a1
; CHECK-NEXT:  }
define <2 x half> @mul_vector_vector(<2 x half> %a, <2 x half> %b) {
  %res = fmul <2 x half> %a, %b
  ret <2 x half> %res
}

declare <2 x half> @llvm.experimental.constrained.fmul.v2f16(<2 x half>, <2 x half>, metadata, metadata)

; CHECK-LABEL: strict_mul_vector_vector:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2mul $a0, $a0, $a1
; CHECK-NEXT:  }
define <2 x half> @strict_mul_vector_vector(<2 x half> %a, <2 x half> %b) {
  %res = call <2 x half> @llvm.experimental.constrained.fmul.v2f16(<2 x half> %a, <2 x half> %b, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <2 x half> %res
}

; CHECK-LABEL: mul_vector_scalar:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2mul $a0, $a1:BL, $a0
; CHECK-NEXT:  }
define <2 x half> @mul_vector_scalar(<2 x half> %a, half %b) {
  %s0 = insertelement <2 x half> undef, half %b, i32 0
  %s1 = insertelement <2 x half> %s0, half %b, i32 1
  %res = fmul <2 x half> %a, %s1
  ret <2 x half> %res
}

; CHECK-LABEL: strict_mul_vector_scalar:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2mul $a0, $a1:BL, $a0
; CHECK-NEXT:  }
define <2 x half> @strict_mul_vector_scalar(<2 x half> %a, half %b) {
  %s0 = insertelement <2 x half> undef, half %b, i32 0
  %s1 = insertelement <2 x half> %s0, half %b, i32 1
  %res = call <2 x half> @llvm.experimental.constrained.fmul.v2f16(<2 x half> %a, <2 x half> %s1, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <2 x half> %res
}

; CHECK-LABEL: mul_scalar_vector:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2mul $a0, $a0:BL, $a1
; CHECK-NEXT:  }
define <2 x half> @mul_scalar_vector(half %a, <2 x half> %b) {
  %s0 = insertelement <2 x half> undef, half %a, i32 0
  %s1 = insertelement <2 x half> %s0, half %a, i32 1
  %res = fmul <2 x half> %s1, %b
  ret <2 x half> %res
}

; CHECK-LABEL: strict_mul_scalar_vector:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2mul $a0, $a0:BL, $a1
; CHECK-NEXT:  }
define <2 x half> @strict_mul_scalar_vector(half %a, <2 x half> %b) {
  %s0 = insertelement <2 x half> undef, half %a, i32 0
  %s1 = insertelement <2 x half> %s0, half %a, i32 1
  %res = call <2 x half> @llvm.experimental.constrained.fmul.v2f16(<2 x half> %s1, <2 x half> %b, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <2 x half> %res
}

; CHECK-LABEL: mul_vector_zero:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2mul $a0, $a0, $a15
; CHECK-NEXT:  }
define <2 x half> @mul_vector_zero(<2 x half> %a) {
    %res = fmul <2 x half> %a, <half 0xH0, half 0xH0>
    ret <2 x half> %res
}

; CHECK-LABEL: strict_mul_vector_zero:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2mul $a0, $a0, $a15
; CHECK-NEXT:  }
define <2 x half> @strict_mul_vector_zero(<2 x half> %a) {
  %res = call <2 x half> @llvm.experimental.constrained.fmul.v2f16(<2 x half> %a, <2 x half> <half 0xH0, half 0xH0>, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <2 x half> %res
}

;;; Broadcast element of a vector of length 2

; CHECK-LABEL: add_v2e0:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2add $a0, $a0:BL, $a1
; CHECK-NEXT:  }
define <2 x half> @add_v2e0(<2 x half> %a, <2 x half> %b) {
   %e = extractelement <2 x half> %a, i32 0
   %s0 = insertelement <2 x half> undef, half %e, i32 0
   %s1 = insertelement <2 x half> %s0, half %e, i32 1
   %res = fadd <2 x half> %s1, %b
   ret <2 x half> %res
}

; CHECK-LABEL: strict_add_v2e0:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2add $a0, $a0:BL, $a1
; CHECK-NEXT:  }
define <2 x half> @strict_add_v2e0(<2 x half> %a, <2 x half> %b) {
  %e = extractelement <2 x half> %a, i32 0
  %s0 = insertelement <2 x half> undef, half %e, i32 0
  %s1 = insertelement <2 x half> %s0, half %e, i32 1
  %res = call <2 x half> @llvm.experimental.constrained.fadd.v2f16(<2 x half> %s1, <2 x half> %b, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <2 x half> %res
}

; CHECK-LABEL: add_v2e0c:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2add $a0, $a1:BL, $a0
; CHECK-NEXT:  }
define <2 x half> @add_v2e0c(<2 x half> %a, <2 x half> %b) {
   %e = extractelement <2 x half> %b, i32 0
   %s0 = insertelement <2 x half> undef, half %e, i32 0
   %s1 = insertelement <2 x half> %s0, half %e, i32 1
   %res = fadd <2 x half> %a, %s1
   ret <2 x half> %res
}

; CHECK-LABEL: strict_add_v2e0c:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2add $a0, $a1:BL, $a0
; CHECK-NEXT:  }
define <2 x half> @strict_add_v2e0c(<2 x half> %a, <2 x half> %b) {
  %e = extractelement <2 x half> %b, i32 0
  %s0 = insertelement <2 x half> undef, half %e, i32 0
  %s1 = insertelement <2 x half> %s0, half %e, i32 1
  %res = call <2 x half> @llvm.experimental.constrained.fadd.v2f16(<2 x half> %a, <2 x half> %s1, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <2 x half> %res
}

; CHECK-LABEL: add_v2e1:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2add $a0, $a0:BU, $a1
; CHECK-NEXT:  }
define <2 x half> @add_v2e1(<2 x half> %a, <2 x half> %b) {
   %e = extractelement <2 x half> %a, i32 1
   %s0 = insertelement <2 x half> undef, half %e, i32 0
   %s1 = insertelement <2 x half> %s0, half %e, i32 1
   %res = fadd <2 x half> %s1, %b
   ret <2 x half> %res
}

; CHECK-LABEL: strict_add_v2e1:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2add $a0, $a0:BU, $a1
; CHECK-NEXT:  }
define <2 x half> @strict_add_v2e1(<2 x half> %a, <2 x half> %b) {
  %e = extractelement <2 x half> %a, i32 1
  %s0 = insertelement <2 x half> undef, half %e, i32 0
  %s1 = insertelement <2 x half> %s0, half %e, i32 1
  %res = call <2 x half> @llvm.experimental.constrained.fadd.v2f16(<2 x half> %s1, <2 x half> %b, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <2 x half> %res
}

; CHECK-LABEL: add_v2e1c:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2add $a0, $a1:BU, $a0
; CHECK-NEXT:  }
define <2 x half> @add_v2e1c(<2 x half> %a, <2 x half> %b) {
   %e = extractelement <2 x half> %b, i32 1
   %s0 = insertelement <2 x half> undef, half %e, i32 0
   %s1 = insertelement <2 x half> %s0, half %e, i32 1
   %res = fadd <2 x half> %a, %s1
   ret <2 x half> %res
}

; CHECK-LABEL: strict_add_v2e1c:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2add $a0, $a1:BU, $a0
; CHECK-NEXT:  }
define <2 x half> @strict_add_v2e1c(<2 x half> %a, <2 x half> %b) {
  %e = extractelement <2 x half> %b, i32 1
  %s0 = insertelement <2 x half> undef, half %e, i32 0
  %s1 = insertelement <2 x half> %s0, half %e, i32 1
  %res = call <2 x half> @llvm.experimental.constrained.fadd.v2f16(<2 x half> %a, <2 x half> %s1, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <2 x half> %res
}

; CHECK-LABEL: sub_v2e0:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2sub $a0, $a0:BL, $a1
; CHECK-NEXT:  }
define <2 x half> @sub_v2e0(<2 x half> %a, <2 x half> %b) {
   %e = extractelement <2 x half> %a, i32 0
   %s0 = insertelement <2 x half> undef, half %e, i32 0
   %s1 = insertelement <2 x half> %s0, half %e, i32 1
   %res = fsub <2 x half> %s1, %b
   ret <2 x half> %res
}

; CHECK-LABEL: strict_sub_v2e0:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2sub $a0, $a0:BL, $a1
; CHECK-NEXT:  }
define <2 x half> @strict_sub_v2e0(<2 x half> %a, <2 x half> %b) {
  %e = extractelement <2 x half> %a, i32 0
  %s0 = insertelement <2 x half> undef, half %e, i32 0
  %s1 = insertelement <2 x half> %s0, half %e, i32 1
  %res = call <2 x half> @llvm.experimental.constrained.fsub.v2f16(<2 x half> %s1, <2 x half> %b, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <2 x half> %res
}

; CHECK-LABEL: sub_v2e0c:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a1, $a1, $a1
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2sub $a0, $a0, $a1
; CHECK-NEXT:  }
define <2 x half> @sub_v2e0c(<2 x half> %a, <2 x half> %b) {
   %e = extractelement <2 x half> %b, i32 0
   %s0 = insertelement <2 x half> undef, half %e, i32 0
   %s1 = insertelement <2 x half> %s0, half %e, i32 1
   %res = fsub <2 x half> %a, %s1
   ret <2 x half> %res
}

; CHECK-LABEL: strict_sub_v2e0c:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a1, $a1, $a1
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2sub $a0, $a0, $a1
; CHECK-NEXT:  }
define <2 x half> @strict_sub_v2e0c(<2 x half> %a, <2 x half> %b) {
  %e = extractelement <2 x half> %b, i32 0
  %s0 = insertelement <2 x half> undef, half %e, i32 0
  %s1 = insertelement <2 x half> %s0, half %e, i32 1
  %res = call <2 x half> @llvm.experimental.constrained.fsub.v2f16(<2 x half> %a, <2 x half> %s1, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <2 x half> %res
}

; CHECK-LABEL: sub_v2e1:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2sub $a0, $a0:BU, $a1
; CHECK-NEXT:  }
define <2 x half> @sub_v2e1(<2 x half> %a, <2 x half> %b) {
   %e = extractelement <2 x half> %a, i32 1
   %s0 = insertelement <2 x half> undef, half %e, i32 0
   %s1 = insertelement <2 x half> %s0, half %e, i32 1
   %res = fsub <2 x half> %s1, %b
   ret <2 x half> %res
}

; CHECK-LABEL: strict_sub_v2e1:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2sub $a0, $a0:BU, $a1
; CHECK-NEXT:  }
define <2 x half> @strict_sub_v2e1(<2 x half> %a, <2 x half> %b) {
  %e = extractelement <2 x half> %a, i32 1
  %s0 = insertelement <2 x half> undef, half %e, i32 0
  %s1 = insertelement <2 x half> %s0, half %e, i32 1
  %res = call <2 x half> @llvm.experimental.constrained.fsub.v2f16(<2 x half> %s1, <2 x half> %b, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <2 x half> %res
}

; CHECK-LABEL: sub_v2e1c:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a1, $a1, $a1
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2sub $a0, $a0, $a1
; CHECK-NEXT:  }
define <2 x half> @sub_v2e1c(<2 x half> %a, <2 x half> %b) {
   %e = extractelement <2 x half> %b, i32 1
   %s0 = insertelement <2 x half> undef, half %e, i32 0
   %s1 = insertelement <2 x half> %s0, half %e, i32 1
   %res = fsub <2 x half> %a, %s1
   ret <2 x half> %res
}

; CHECK-LABEL: strict_sub_v2e1c:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a1, $a1, $a1
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2sub $a0, $a0, $a1
; CHECK-NEXT:  }
define <2 x half> @strict_sub_v2e1c(<2 x half> %a, <2 x half> %b) {
  %e = extractelement <2 x half> %b, i32 1
  %s0 = insertelement <2 x half> undef, half %e, i32 0
  %s1 = insertelement <2 x half> %s0, half %e, i32 1
  %res = call <2 x half> @llvm.experimental.constrained.fsub.v2f16(<2 x half> %a, <2 x half> %s1, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <2 x half> %res
}

; CHECK-LABEL: mul_v2e0:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2mul $a0, $a0:BL, $a1
; CHECK-NEXT:  }
define <2 x half> @mul_v2e0(<2 x half> %a, <2 x half> %b) {
   %e = extractelement <2 x half> %a, i32 0
   %s0 = insertelement <2 x half> undef, half %e, i32 0
   %s1 = insertelement <2 x half> %s0, half %e, i32 1
   %res = fmul <2 x half> %s1, %b
   ret <2 x half> %res
}

; CHECK-LABEL: strict_mul_v2e0:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2mul $a0, $a0:BL, $a1
; CHECK-NEXT:  }
define <2 x half> @strict_mul_v2e0(<2 x half> %a, <2 x half> %b) {
  %e = extractelement <2 x half> %a, i32 0
  %s0 = insertelement <2 x half> undef, half %e, i32 0
  %s1 = insertelement <2 x half> %s0, half %e, i32 1
  %res = call <2 x half> @llvm.experimental.constrained.fmul.v2f16(<2 x half> %s1, <2 x half> %b, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <2 x half> %res
}

; CHECK-LABEL: mul_v2e0c:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2mul $a0, $a1:BL, $a0
; CHECK-NEXT:  }
define <2 x half> @mul_v2e0c(<2 x half> %a, <2 x half> %b) {
   %e = extractelement <2 x half> %b, i32 0
   %s0 = insertelement <2 x half> undef, half %e, i32 0
   %s1 = insertelement <2 x half> %s0, half %e, i32 1
   %res = fmul <2 x half> %a, %s1
   ret <2 x half> %res
}

; CHECK-LABEL: strict_mul_v2e0c:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2mul $a0, $a1:BL, $a0
; CHECK-NEXT:  }
define <2 x half> @strict_mul_v2e0c(<2 x half> %a, <2 x half> %b) {
  %e = extractelement <2 x half> %b, i32 0
  %s0 = insertelement <2 x half> undef, half %e, i32 0
  %s1 = insertelement <2 x half> %s0, half %e, i32 1
  %res = call <2 x half> @llvm.experimental.constrained.fmul.v2f16(<2 x half> %a, <2 x half> %s1, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <2 x half> %res
}

; CHECK-LABEL: mul_v2e1:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2mul $a0, $a0:BU, $a1
; CHECK-NEXT:  }
define <2 x half> @mul_v2e1(<2 x half> %a, <2 x half> %b) {
   %e = extractelement <2 x half> %a, i32 1
   %s0 = insertelement <2 x half> undef, half %e, i32 0
   %s1 = insertelement <2 x half> %s0, half %e, i32 1
   %res = fmul <2 x half> %s1, %b
   ret <2 x half> %res
}

; CHECK-LABEL: strict_mul_v2e1:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2mul $a0, $a0:BU, $a1
; CHECK-NEXT:  }
define <2 x half> @strict_mul_v2e1(<2 x half> %a, <2 x half> %b) {
  %e = extractelement <2 x half> %a, i32 1
  %s0 = insertelement <2 x half> undef, half %e, i32 0
  %s1 = insertelement <2 x half> %s0, half %e, i32 1
  %res = call <2 x half> @llvm.experimental.constrained.fmul.v2f16(<2 x half> %s1, <2 x half> %b, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <2 x half> %res
}

; CHECK-LABEL: mul_v2e1c:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2mul $a0, $a1:BU, $a0
; CHECK-NEXT:  }
define <2 x half> @mul_v2e1c(<2 x half> %a, <2 x half> %b) {
   %e = extractelement <2 x half> %b, i32 1
   %s0 = insertelement <2 x half> undef, half %e, i32 0
   %s1 = insertelement <2 x half> %s0, half %e, i32 1
   %res = fmul <2 x half> %a, %s1
   ret <2 x half> %res
}

; CHECK-LABEL: strict_mul_v2e1c:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2mul $a0, $a1:BU, $a0
; CHECK-NEXT:  }
define <2 x half> @strict_mul_v2e1c(<2 x half> %a, <2 x half> %b) {
  %e = extractelement <2 x half> %b, i32 1
  %s0 = insertelement <2 x half> undef, half %e, i32 0
  %s1 = insertelement <2 x half> %s0, half %e, i32 1
  %res = call <2 x half> @llvm.experimental.constrained.fmul.v2f16(<2 x half> %a, <2 x half> %s1, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <2 x half> %res
}

;;; Broadcast element of a vector of length 4

; CHECK-LABEL: add_v4e0:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2add $a0, $a0:BL, $a2
; CHECK-NEXT:  }
define <2 x half> @add_v4e0(<4 x half> %a, <2 x half> %b) {
   %e = extractelement <4 x half> %a, i32 0
   %s0 = insertelement <2 x half> undef, half %e, i32 0
   %s1 = insertelement <2 x half> %s0, half %e, i32 1
   %res = fadd <2 x half> %s1, %b
   ret <2 x half> %res
}

; CHECK-LABEL: strict_add_v4e0:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2add $a0, $a0:BL, $a2
; CHECK-NEXT:  }
define <2 x half> @strict_add_v4e0(<4 x half> %a, <2 x half> %b) {
  %e = extractelement <4 x half> %a, i32 0
  %s0 = insertelement <2 x half> undef, half %e, i32 0
  %s1 = insertelement <2 x half> %s0, half %e, i32 1
  %res = call <2 x half> @llvm.experimental.constrained.fadd.v2f16(<2 x half> %s1, <2 x half> %b, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <2 x half> %res
}

; CHECK-LABEL: add_v4e0c:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2add $a0, $a2:BL, $a0
; CHECK-NEXT:  }
define <2 x half> @add_v4e0c(<2 x half> %a, <4 x half> %b) {
   %e = extractelement <4 x half> %b, i32 0
   %s0 = insertelement <2 x half> undef, half %e, i32 0
   %s1 = insertelement <2 x half> %s0, half %e, i32 1
   %res = fadd <2 x half> %a, %s1
   ret <2 x half> %res
}

; CHECK-LABEL: strict_add_v4e0c:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2add $a0, $a2:BL, $a0
; CHECK-NEXT:  }
define <2 x half> @strict_add_v4e0c(<2 x half> %a, <4 x half> %b) {
  %e = extractelement <4 x half> %b, i32 0
  %s0 = insertelement <2 x half> undef, half %e, i32 0
  %s1 = insertelement <2 x half> %s0, half %e, i32 1
  %res = call <2 x half> @llvm.experimental.constrained.fadd.v2f16(<2 x half> %a, <2 x half> %s1, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <2 x half> %res
}

; CHECK-LABEL: add_v4e1:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2add $a0, $a0:BU, $a2
; CHECK-NEXT:  }
define <2 x half> @add_v4e1(<4 x half> %a, <2 x half> %b) {
   %e = extractelement <4 x half> %a, i32 1
   %s0 = insertelement <2 x half> undef, half %e, i32 0
   %s1 = insertelement <2 x half> %s0, half %e, i32 1
   %res = fadd <2 x half> %s1, %b
   ret <2 x half> %res
}

; CHECK-LABEL: strict_add_v4e1:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2add $a0, $a0:BU, $a2
; CHECK-NEXT:  }
define <2 x half> @strict_add_v4e1(<4 x half> %a, <2 x half> %b) {
  %e = extractelement <4 x half> %a, i32 1
  %s0 = insertelement <2 x half> undef, half %e, i32 0
  %s1 = insertelement <2 x half> %s0, half %e, i32 1
  %res = call <2 x half> @llvm.experimental.constrained.fadd.v2f16(<2 x half> %s1, <2 x half> %b, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <2 x half> %res
}

; CHECK-LABEL: add_v4e1c:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2add $a0, $a2:BU, $a0
; CHECK-NEXT:  }
define <2 x half> @add_v4e1c(<2 x half> %a, <4 x half> %b) {
   %e = extractelement <4 x half> %b, i32 1
   %s0 = insertelement <2 x half> undef, half %e, i32 0
   %s1 = insertelement <2 x half> %s0, half %e, i32 1
   %res = fadd <2 x half> %a, %s1
   ret <2 x half> %res
}

; CHECK-LABEL: strict_add_v4e1c:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2add $a0, $a2:BU, $a0
; CHECK-NEXT:  }
define <2 x half> @strict_add_v4e1c(<2 x half> %a, <4 x half> %b) {
  %e = extractelement <4 x half> %b, i32 1
  %s0 = insertelement <2 x half> undef, half %e, i32 0
  %s1 = insertelement <2 x half> %s0, half %e, i32 1
  %res = call <2 x half> @llvm.experimental.constrained.fadd.v2f16(<2 x half> %a, <2 x half> %s1, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <2 x half> %res
}

; CHECK-LABEL: add_v4e2:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2add $a0, $a1:BL, $a2
; CHECK-NEXT:  }
define <2 x half> @add_v4e2(<4 x half> %a, <2 x half> %b) {
   %e = extractelement <4 x half> %a, i32 2
   %s0 = insertelement <2 x half> undef, half %e, i32 0
   %s1 = insertelement <2 x half> %s0, half %e, i32 1
   %res = fadd <2 x half> %s1, %b
   ret <2 x half> %res
}

; CHECK-LABEL: strict_add_v4e2:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2add $a0, $a1:BL, $a2
; CHECK-NEXT:  }
define <2 x half> @strict_add_v4e2(<4 x half> %a, <2 x half> %b) {
  %e = extractelement <4 x half> %a, i32 2
  %s0 = insertelement <2 x half> undef, half %e, i32 0
  %s1 = insertelement <2 x half> %s0, half %e, i32 1
  %res = call <2 x half> @llvm.experimental.constrained.fadd.v2f16(<2 x half> %s1, <2 x half> %b, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <2 x half> %res
}

; CHECK-LABEL: add_v4e2c:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2add $a0, $a3:BL, $a0
; CHECK-NEXT:  }
define <2 x half> @add_v4e2c(<2 x half> %a, <4 x half> %b) {
   %e = extractelement <4 x half> %b, i32 2
   %s0 = insertelement <2 x half> undef, half %e, i32 0
   %s1 = insertelement <2 x half> %s0, half %e, i32 1
   %res = fadd <2 x half> %a, %s1
   ret <2 x half> %res
}

; CHECK-LABEL: strict_add_v4e2c:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2add $a0, $a3:BL, $a0
; CHECK-NEXT:  }
define <2 x half> @strict_add_v4e2c(<2 x half> %a, <4 x half> %b) {
  %e = extractelement <4 x half> %b, i32 2
  %s0 = insertelement <2 x half> undef, half %e, i32 0
  %s1 = insertelement <2 x half> %s0, half %e, i32 1
  %res = call <2 x half> @llvm.experimental.constrained.fadd.v2f16(<2 x half> %a, <2 x half> %s1, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <2 x half> %res
}

; CHECK-LABEL: add_v4e3:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2add $a0, $a1:BU, $a2
; CHECK-NEXT:  }
define <2 x half> @add_v4e3(<4 x half> %a, <2 x half> %b) {
   %e = extractelement <4 x half> %a, i32 3
   %s0 = insertelement <2 x half> undef, half %e, i32 0
   %s1 = insertelement <2 x half> %s0, half %e, i32 1
   %res = fadd <2 x half> %s1, %b
   ret <2 x half> %res
}

; CHECK-LABEL: strict_add_v4e3:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2add $a0, $a1:BU, $a2
; CHECK-NEXT:  }
define <2 x half> @strict_add_v4e3(<4 x half> %a, <2 x half> %b) {
  %e = extractelement <4 x half> %a, i32 3
  %s0 = insertelement <2 x half> undef, half %e, i32 0
  %s1 = insertelement <2 x half> %s0, half %e, i32 1
  %res = call <2 x half> @llvm.experimental.constrained.fadd.v2f16(<2 x half> %s1, <2 x half> %b, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <2 x half> %res
}

; CHECK-LABEL: add_v4e3c:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2add $a0, $a3:BU, $a0
; CHECK-NEXT:  }
define <2 x half> @add_v4e3c(<2 x half> %a, <4 x half> %b) {
   %e = extractelement <4 x half> %b, i32 3
   %s0 = insertelement <2 x half> undef, half %e, i32 0
   %s1 = insertelement <2 x half> %s0, half %e, i32 1
   %res = fadd <2 x half> %a, %s1
   ret <2 x half> %res
}

; CHECK-LABEL: strict_add_v4e3c:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2add $a0, $a3:BU, $a0
; CHECK-NEXT:  }
define <2 x half> @strict_add_v4e3c(<2 x half> %a, <4 x half> %b) {
  %e = extractelement <4 x half> %b, i32 3
  %s0 = insertelement <2 x half> undef, half %e, i32 0
  %s1 = insertelement <2 x half> %s0, half %e, i32 1
  %res = call <2 x half> @llvm.experimental.constrained.fadd.v2f16(<2 x half> %a, <2 x half> %s1, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <2 x half> %res
}

; CHECK-LABEL: sub_v4e0:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2sub $a0, $a0:BL, $a2
; CHECK-NEXT:  }
define <2 x half> @sub_v4e0(<4 x half> %a, <2 x half> %b) {
   %e = extractelement <4 x half> %a, i32 0
   %s0 = insertelement <2 x half> undef, half %e, i32 0
   %s1 = insertelement <2 x half> %s0, half %e, i32 1
   %res = fsub <2 x half> %s1, %b
   ret <2 x half> %res
}

; CHECK-LABEL: strict_sub_v4e0:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2sub $a0, $a0:BL, $a2
; CHECK-NEXT:  }
define <2 x half> @strict_sub_v4e0(<4 x half> %a, <2 x half> %b) {
  %e = extractelement <4 x half> %a, i32 0
  %s0 = insertelement <2 x half> undef, half %e, i32 0
  %s1 = insertelement <2 x half> %s0, half %e, i32 1
  %res = call <2 x half> @llvm.experimental.constrained.fsub.v2f16(<2 x half> %s1, <2 x half> %b, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <2 x half> %res
}

; CHECK-LABEL: sub_v4e0c:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a1, $a2, $a2
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2sub $a0, $a0, $a1
; CHECK-NEXT:  }
define <2 x half> @sub_v4e0c(<2 x half> %a, <4 x half> %b) {
   %e = extractelement <4 x half> %b, i32 0
   %s0 = insertelement <2 x half> undef, half %e, i32 0
   %s1 = insertelement <2 x half> %s0, half %e, i32 1
   %res = fsub <2 x half> %a, %s1
   ret <2 x half> %res
}

; CHECK-LABEL: strict_sub_v4e0c:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a1, $a2, $a2
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2sub $a0, $a0, $a1
; CHECK-NEXT:  }
define <2 x half> @strict_sub_v4e0c(<2 x half> %a, <4 x half> %b) {
  %e = extractelement <4 x half> %b, i32 0
  %s0 = insertelement <2 x half> undef, half %e, i32 0
  %s1 = insertelement <2 x half> %s0, half %e, i32 1
  %res = call <2 x half> @llvm.experimental.constrained.fsub.v2f16(<2 x half> %a, <2 x half> %s1, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <2 x half> %res
}

; CHECK-LABEL: sub_v4e1:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2sub $a0, $a0:BU, $a2
; CHECK-NEXT:  }
define <2 x half> @sub_v4e1(<4 x half> %a, <2 x half> %b) {
   %e = extractelement <4 x half> %a, i32 1
   %s0 = insertelement <2 x half> undef, half %e, i32 0
   %s1 = insertelement <2 x half> %s0, half %e, i32 1
   %res = fsub <2 x half> %s1, %b
   ret <2 x half> %res
}

; CHECK-LABEL: strict_sub_v4e1:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2sub $a0, $a0:BU, $a2
; CHECK-NEXT:  }
define <2 x half> @strict_sub_v4e1(<4 x half> %a, <2 x half> %b) {
  %e = extractelement <4 x half> %a, i32 1
  %s0 = insertelement <2 x half> undef, half %e, i32 0
  %s1 = insertelement <2 x half> %s0, half %e, i32 1
  %res = call <2 x half> @llvm.experimental.constrained.fsub.v2f16(<2 x half> %s1, <2 x half> %b, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <2 x half> %res
}

; CHECK-LABEL: sub_v4e1c:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a1, $a2, $a2
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2sub $a0, $a0, $a1
; CHECK-NEXT:  }
define <2 x half> @sub_v4e1c(<2 x half> %a, <4 x half> %b) {
   %e = extractelement <4 x half> %b, i32 1
   %s0 = insertelement <2 x half> undef, half %e, i32 0
   %s1 = insertelement <2 x half> %s0, half %e, i32 1
   %res = fsub <2 x half> %a, %s1
   ret <2 x half> %res
}

; CHECK-LABEL: strict_sub_v4e1c:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a1, $a2, $a2
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2sub $a0, $a0, $a1
; CHECK-NEXT:  }
define <2 x half> @strict_sub_v4e1c(<2 x half> %a, <4 x half> %b) {
  %e = extractelement <4 x half> %b, i32 1
  %s0 = insertelement <2 x half> undef, half %e, i32 0
  %s1 = insertelement <2 x half> %s0, half %e, i32 1
  %res = call <2 x half> @llvm.experimental.constrained.fsub.v2f16(<2 x half> %a, <2 x half> %s1, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <2 x half> %res
}

; CHECK-LABEL: sub_v4e2:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2sub $a0, $a1:BL, $a2
; CHECK-NEXT:  }
define <2 x half> @sub_v4e2(<4 x half> %a, <2 x half> %b) {
   %e = extractelement <4 x half> %a, i32 2
   %s0 = insertelement <2 x half> undef, half %e, i32 0
   %s1 = insertelement <2 x half> %s0, half %e, i32 1
   %res = fsub <2 x half> %s1, %b
   ret <2 x half> %res
}

; CHECK-LABEL: strict_sub_v4e2:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2sub $a0, $a1:BL, $a2
; CHECK-NEXT:  }
define <2 x half> @strict_sub_v4e2(<4 x half> %a, <2 x half> %b) {
  %e = extractelement <4 x half> %a, i32 2
  %s0 = insertelement <2 x half> undef, half %e, i32 0
  %s1 = insertelement <2 x half> %s0, half %e, i32 1
  %res = call <2 x half> @llvm.experimental.constrained.fsub.v2f16(<2 x half> %s1, <2 x half> %b, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <2 x half> %res
}

; CHECK-LABEL: sub_v4e2c:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a1, $a3, $a3
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2sub $a0, $a0, $a1
; CHECK-NEXT:  }
define <2 x half> @sub_v4e2c(<2 x half> %a, <4 x half> %b) {
   %e = extractelement <4 x half> %b, i32 2
   %s0 = insertelement <2 x half> undef, half %e, i32 0
   %s1 = insertelement <2 x half> %s0, half %e, i32 1
   %res = fsub <2 x half> %a, %s1
   ret <2 x half> %res
}

; CHECK-LABEL: strict_sub_v4e2c:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a1, $a3, $a3
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2sub $a0, $a0, $a1
; CHECK-NEXT:  }
define <2 x half> @strict_sub_v4e2c(<2 x half> %a, <4 x half> %b) {
  %e = extractelement <4 x half> %b, i32 2
  %s0 = insertelement <2 x half> undef, half %e, i32 0
  %s1 = insertelement <2 x half> %s0, half %e, i32 1
  %res = call <2 x half> @llvm.experimental.constrained.fsub.v2f16(<2 x half> %a, <2 x half> %s1, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <2 x half> %res
}

; CHECK-LABEL: sub_v4e3:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2sub $a0, $a1:BU, $a2
; CHECK-NEXT:  }
define <2 x half> @sub_v4e3(<4 x half> %a, <2 x half> %b) {
   %e = extractelement <4 x half> %a, i32 3
   %s0 = insertelement <2 x half> undef, half %e, i32 0
   %s1 = insertelement <2 x half> %s0, half %e, i32 1
   %res = fsub <2 x half> %s1, %b
   ret <2 x half> %res
}

; CHECK-LABEL: strict_sub_v4e3:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2sub $a0, $a1:BU, $a2
; CHECK-NEXT:  }
define <2 x half> @strict_sub_v4e3(<4 x half> %a, <2 x half> %b) {
  %e = extractelement <4 x half> %a, i32 3
  %s0 = insertelement <2 x half> undef, half %e, i32 0
  %s1 = insertelement <2 x half> %s0, half %e, i32 1
  %res = call <2 x half> @llvm.experimental.constrained.fsub.v2f16(<2 x half> %s1, <2 x half> %b, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <2 x half> %res
}

; CHECK-LABEL: sub_v4e3c:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a1, $a3, $a3
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2sub $a0, $a0, $a1
; CHECK-NEXT:  }
define <2 x half> @sub_v4e3c(<2 x half> %a, <4 x half> %b) {
   %e = extractelement <4 x half> %b, i32 3
   %s0 = insertelement <2 x half> undef, half %e, i32 0
   %s1 = insertelement <2 x half> %s0, half %e, i32 1
   %res = fsub <2 x half> %a, %s1
   ret <2 x half> %res
}

; CHECK-LABEL: strict_sub_v4e3c:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a1, $a3, $a3
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2sub $a0, $a0, $a1
; CHECK-NEXT:  }
define <2 x half> @strict_sub_v4e3c(<2 x half> %a, <4 x half> %b) {
  %e = extractelement <4 x half> %b, i32 3
  %s0 = insertelement <2 x half> undef, half %e, i32 0
  %s1 = insertelement <2 x half> %s0, half %e, i32 1
  %res = call <2 x half> @llvm.experimental.constrained.fsub.v2f16(<2 x half> %a, <2 x half> %s1, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <2 x half> %res
}

; CHECK-LABEL: mul_v4e0:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2mul $a0, $a0:BL, $a2
; CHECK-NEXT:  }
define <2 x half> @mul_v4e0(<4 x half> %a, <2 x half> %b) {
   %e = extractelement <4 x half> %a, i32 0
   %s0 = insertelement <2 x half> undef, half %e, i32 0
   %s1 = insertelement <2 x half> %s0, half %e, i32 1
   %res = fmul <2 x half> %s1, %b
   ret <2 x half> %res
}

; CHECK-LABEL: strict_mul_v4e0:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2mul $a0, $a0:BL, $a2
; CHECK-NEXT:  }
define <2 x half> @strict_mul_v4e0(<4 x half> %a, <2 x half> %b) {
  %e = extractelement <4 x half> %a, i32 0
  %s0 = insertelement <2 x half> undef, half %e, i32 0
  %s1 = insertelement <2 x half> %s0, half %e, i32 1
  %res = call <2 x half> @llvm.experimental.constrained.fmul.v2f16(<2 x half> %s1, <2 x half> %b, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <2 x half> %res
}

; CHECK-LABEL: mul_v4e0c:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2mul $a0, $a2:BL, $a0
; CHECK-NEXT:  }
define <2 x half> @mul_v4e0c(<2 x half> %a, <4 x half> %b) {
   %e = extractelement <4 x half> %b, i32 0
   %s0 = insertelement <2 x half> undef, half %e, i32 0
   %s1 = insertelement <2 x half> %s0, half %e, i32 1
   %res = fmul <2 x half> %a, %s1
   ret <2 x half> %res
}

; CHECK-LABEL: strict_mul_v4e0c:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2mul $a0, $a2:BL, $a0
; CHECK-NEXT:  }
define <2 x half> @strict_mul_v4e0c(<2 x half> %a, <4 x half> %b) {
  %e = extractelement <4 x half> %b, i32 0
  %s0 = insertelement <2 x half> undef, half %e, i32 0
  %s1 = insertelement <2 x half> %s0, half %e, i32 1
  %res = call <2 x half> @llvm.experimental.constrained.fmul.v2f16(<2 x half> %a, <2 x half> %s1, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <2 x half> %res
}

; CHECK-LABEL: mul_v4e1:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2mul $a0, $a0:BU, $a2
; CHECK-NEXT:  }
define <2 x half> @mul_v4e1(<4 x half> %a, <2 x half> %b) {
   %e = extractelement <4 x half> %a, i32 1
   %s0 = insertelement <2 x half> undef, half %e, i32 0
   %s1 = insertelement <2 x half> %s0, half %e, i32 1
   %res = fmul <2 x half> %s1, %b
   ret <2 x half> %res
}

; CHECK-LABEL: strict_mul_v4e1:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2mul $a0, $a0:BU, $a2
; CHECK-NEXT:  }
define <2 x half> @strict_mul_v4e1(<4 x half> %a, <2 x half> %b) {
  %e = extractelement <4 x half> %a, i32 1
  %s0 = insertelement <2 x half> undef, half %e, i32 0
  %s1 = insertelement <2 x half> %s0, half %e, i32 1
  %res = call <2 x half> @llvm.experimental.constrained.fmul.v2f16(<2 x half> %s1, <2 x half> %b, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <2 x half> %res
}

; CHECK-LABEL: mul_v4e1c:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2mul $a0, $a2:BU, $a0
; CHECK-NEXT:  }
define <2 x half> @mul_v4e1c(<2 x half> %a, <4 x half> %b) {
   %e = extractelement <4 x half> %b, i32 1
   %s0 = insertelement <2 x half> undef, half %e, i32 0
   %s1 = insertelement <2 x half> %s0, half %e, i32 1
   %res = fmul <2 x half> %a, %s1
   ret <2 x half> %res
}

; CHECK-LABEL: strict_mul_v4e1c:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2mul $a0, $a2:BU, $a0
; CHECK-NEXT:  }
define <2 x half> @strict_mul_v4e1c(<2 x half> %a, <4 x half> %b) {
  %e = extractelement <4 x half> %b, i32 1
  %s0 = insertelement <2 x half> undef, half %e, i32 0
  %s1 = insertelement <2 x half> %s0, half %e, i32 1
  %res = call <2 x half> @llvm.experimental.constrained.fmul.v2f16(<2 x half> %a, <2 x half> %s1, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <2 x half> %res
}

; CHECK-LABEL: mul_v4e2:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2mul $a0, $a1:BL, $a2
; CHECK-NEXT:  }
define <2 x half> @mul_v4e2(<4 x half> %a, <2 x half> %b) {
   %e = extractelement <4 x half> %a, i32 2
   %s0 = insertelement <2 x half> undef, half %e, i32 0
   %s1 = insertelement <2 x half> %s0, half %e, i32 1
   %res = fmul <2 x half> %s1, %b
   ret <2 x half> %res
}

; CHECK-LABEL: strict_mul_v4e2:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2mul $a0, $a1:BL, $a2
; CHECK-NEXT:  }
define <2 x half> @strict_mul_v4e2(<4 x half> %a, <2 x half> %b) {
  %e = extractelement <4 x half> %a, i32 2
  %s0 = insertelement <2 x half> undef, half %e, i32 0
  %s1 = insertelement <2 x half> %s0, half %e, i32 1
  %res = call <2 x half> @llvm.experimental.constrained.fmul.v2f16(<2 x half> %s1, <2 x half> %b, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <2 x half> %res
}

; CHECK-LABEL: mul_v4e2c:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2mul $a0, $a3:BL, $a0
; CHECK-NEXT:  }
define <2 x half> @mul_v4e2c(<2 x half> %a, <4 x half> %b) {
   %e = extractelement <4 x half> %b, i32 2
   %s0 = insertelement <2 x half> undef, half %e, i32 0
   %s1 = insertelement <2 x half> %s0, half %e, i32 1
   %res = fmul <2 x half> %a, %s1
   ret <2 x half> %res
}

; CHECK-LABEL: strict_mul_v4e2c:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2mul $a0, $a3:BL, $a0
; CHECK-NEXT:  }
define <2 x half> @strict_mul_v4e2c(<2 x half> %a, <4 x half> %b) {
  %e = extractelement <4 x half> %b, i32 2
  %s0 = insertelement <2 x half> undef, half %e, i32 0
  %s1 = insertelement <2 x half> %s0, half %e, i32 1
  %res = call <2 x half> @llvm.experimental.constrained.fmul.v2f16(<2 x half> %a, <2 x half> %s1, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <2 x half> %res
}

; CHECK-LABEL: mul_v4e3:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2mul $a0, $a1:BU, $a2
; CHECK-NEXT:  }
define <2 x half> @mul_v4e3(<4 x half> %a, <2 x half> %b) {
   %e = extractelement <4 x half> %a, i32 3
   %s0 = insertelement <2 x half> undef, half %e, i32 0
   %s1 = insertelement <2 x half> %s0, half %e, i32 1
   %res = fmul <2 x half> %s1, %b
   ret <2 x half> %res
}

; CHECK-LABEL: strict_mul_v4e3:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2mul $a0, $a1:BU, $a2
; CHECK-NEXT:  }
define <2 x half> @strict_mul_v4e3(<4 x half> %a, <2 x half> %b) {
  %e = extractelement <4 x half> %a, i32 3
  %s0 = insertelement <2 x half> undef, half %e, i32 0
  %s1 = insertelement <2 x half> %s0, half %e, i32 1
  %res = call <2 x half> @llvm.experimental.constrained.fmul.v2f16(<2 x half> %s1, <2 x half> %b, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <2 x half> %res
}

; CHECK-LABEL: mul_v4e3c:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2mul $a0, $a3:BU, $a0
; CHECK-NEXT:  }
define <2 x half> @mul_v4e3c(<2 x half> %a, <4 x half> %b) {
   %e = extractelement <4 x half> %b, i32 3
   %s0 = insertelement <2 x half> undef, half %e, i32 0
   %s1 = insertelement <2 x half> %s0, half %e, i32 1
   %res = fmul <2 x half> %a, %s1
   ret <2 x half> %res
}

; CHECK-LABEL: strict_mul_v4e3c:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2mul $a0, $a3:BU, $a0
; CHECK-NEXT:  }
define <2 x half> @strict_mul_v4e3c(<2 x half> %a, <4 x half> %b) {
  %e = extractelement <4 x half> %b, i32 3
  %s0 = insertelement <2 x half> undef, half %e, i32 0
  %s1 = insertelement <2 x half> %s0, half %e, i32 1
  %res = call <2 x half> @llvm.experimental.constrained.fmul.v2f16(<2 x half> %a, <2 x half> %s1, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <2 x half> %res
}
