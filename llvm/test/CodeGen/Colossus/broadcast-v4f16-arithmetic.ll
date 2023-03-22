
; RUN: llc < %s -mtriple=colossus -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -mtriple=colossus -mattr=+ipu2 | FileCheck %s

;;; Broadcast from a scalar

; CHECK-LABEL: add_vector_vector:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4add $a0:1, $a0:1, $a2:3
; CHECK-NEXT:  }
define <4 x half> @add_vector_vector(<4 x half> %a, <4 x half> %b) {
  %res = fadd <4 x half> %a, %b
  ret <4 x half> %res
}

declare <4 x half> @llvm.experimental.constrained.fadd.v4f16(<4 x half>, <4 x half>, metadata, metadata)

; CHECK-LABEL: strict_add_vector_vector:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4add $a0:1, $a0:1, $a2:3
; CHECK-NEXT:  }
define <4 x half> @strict_add_vector_vector(<4 x half> %a, <4 x half> %b) {
  %res = call <4 x half> @llvm.experimental.constrained.fadd.v4f16(<4 x half> %a, <4 x half> %b, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <4 x half> %res
}

; CHECK-LABEL: add_vector_scalar:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4add $a0:1, $a2:BL, $a0:1
; CHECK-NEXT:  }
define <4 x half> @add_vector_scalar(<4 x half> %a, half %b) {
  %s0 = insertelement <4 x half> undef, half %b, i32 0
  %s1 = insertelement <4 x half> %s0, half %b, i32 1
  %s2 = insertelement <4 x half> %s1, half %b, i32 2
  %s3 = insertelement <4 x half> %s2, half %b, i32 3
  %res = fadd <4 x half> %a, %s3
  ret <4 x half> %res
}

; CHECK-LABEL: strict_add_vector_scalar:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4add $a0:1, $a2:BL, $a0:1
; CHECK-NEXT:  }
define <4 x half> @strict_add_vector_scalar(<4 x half> %a, half %b) {
  %s0 = insertelement <4 x half> undef, half %b, i32 0
  %s1 = insertelement <4 x half> %s0, half %b, i32 1
  %s2 = insertelement <4 x half> %s1, half %b, i32 2
  %s3 = insertelement <4 x half> %s2, half %b, i32 3
  %res = call <4 x half> @llvm.experimental.constrained.fadd.v4f16(<4 x half> %a, <4 x half> %s3, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <4 x half> %res
}

; CHECK-LABEL: add_scalar_vector:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4add $a0:1, $a0:BL, $a2:3
; CHECK-NEXT:  }
define <4 x half> @add_scalar_vector(half %a, <4 x half> %b) {
  %s0 = insertelement <4 x half> undef, half %a, i32 0
  %s1 = insertelement <4 x half> %s0, half %a, i32 1
  %s2 = insertelement <4 x half> %s1, half %a, i32 2
  %s3 = insertelement <4 x half> %s2, half %a, i32 3
  %res = fadd <4 x half> %s3, %b
  ret <4 x half> %res
}

; CHECK-LABEL: strict_add_scalar_vector:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4add $a0:1, $a0:BL, $a2:3
; CHECK-NEXT:  }
define <4 x half> @strict_add_scalar_vector(half %a, <4 x half> %b) {
  %s0 = insertelement <4 x half> undef, half %a, i32 0
  %s1 = insertelement <4 x half> %s0, half %a, i32 1
  %s2 = insertelement <4 x half> %s1, half %a, i32 2
  %s3 = insertelement <4 x half> %s2, half %a, i32 3
  %res = call <4 x half> @llvm.experimental.constrained.fadd.v4f16(<4 x half> %s3, <4 x half> %b, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <4 x half> %res
}

; CHECK-LABEL: add_vector_zero:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4add $a0:1, $a0:1, $a14:15
; CHECK-NEXT:  }
define <4 x half> @add_vector_zero(<4 x half> %a) {
    %res = fadd <4 x half> %a, <half 0xH0, half 0xH0, half 0xH0, half 0xH0>
    ret <4 x half> %res
}

; CHECK-LABEL: strict_add_vector_zero:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4add $a0:1, $a0:1, $a14:15
; CHECK-NEXT:  }
define <4 x half> @strict_add_vector_zero(<4 x half> %a) {
  %res = call <4 x half> @llvm.experimental.constrained.fadd.v4f16(<4 x half> %a, <4 x half> <half 0xH0, half 0xH0, half 0xH0, half 0xH0>, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <4 x half> %res
}

; CHECK-LABEL: sub_vector_vector:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4sub $a0:1, $a0:1, $a2:3
; CHECK-NEXT:  }
define <4 x half> @sub_vector_vector(<4 x half> %a, <4 x half> %b) {
  %res = fsub <4 x half> %a, %b
  ret <4 x half> %res
}

declare <4 x half> @llvm.experimental.constrained.fsub.v4f16(<4 x half>, <4 x half>, metadata, metadata)

; CHECK-LABEL: strict_sub_vector_vector:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4sub $a0:1, $a0:1, $a2:3
; CHECK-NEXT:  }
define <4 x half> @strict_sub_vector_vector(<4 x half> %a, <4 x half> %b) {
  %res = call <4 x half> @llvm.experimental.constrained.fsub.v4f16(<4 x half> %a, <4 x half> %b, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <4 x half> %res
}

; CHECK-LABEL: sub_vector_scalar:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a2, $a2, $a2
; CHECK-NEXT:  mov $a3, $a2
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4sub $a0:1, $a0:1, $a2:3
; CHECK-NEXT:  }
define <4 x half> @sub_vector_scalar(<4 x half> %a, half %b) {
  %s0 = insertelement <4 x half> undef, half %b, i32 0
  %s1 = insertelement <4 x half> %s0, half %b, i32 1
  %s2 = insertelement <4 x half> %s1, half %b, i32 2
  %s3 = insertelement <4 x half> %s2, half %b, i32 3
  %res = fsub <4 x half> %a, %s3
  ret <4 x half> %res
}

; CHECK-LABEL: strict_sub_vector_scalar:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a2, $a2, $a2
; CHECK-NEXT:  mov $a3, $a2
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4sub $a0:1, $a0:1, $a2:3
; CHECK-NEXT:  }
define <4 x half> @strict_sub_vector_scalar(<4 x half> %a, half %b) {
  %s0 = insertelement <4 x half> undef, half %b, i32 0
  %s1 = insertelement <4 x half> %s0, half %b, i32 1
  %s2 = insertelement <4 x half> %s1, half %b, i32 2
  %s3 = insertelement <4 x half> %s2, half %b, i32 3
  %res = call <4 x half> @llvm.experimental.constrained.fsub.v4f16(<4 x half> %a, <4 x half> %s3, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <4 x half> %res
}

; CHECK-LABEL: sub_scalar_vector:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4sub $a0:1, $a0:BL, $a2:3
; CHECK-NEXT:  }
define <4 x half> @sub_scalar_vector(half %a, <4 x half> %b) {
  %s0 = insertelement <4 x half> undef, half %a, i32 0
  %s1 = insertelement <4 x half> %s0, half %a, i32 1
  %s2 = insertelement <4 x half> %s1, half %a, i32 2
  %s3 = insertelement <4 x half> %s2, half %a, i32 3
  %res = fsub <4 x half> %s3, %b
  ret <4 x half> %res
}

; CHECK-LABEL: strict_sub_scalar_vector:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4sub $a0:1, $a0:BL, $a2:3
; CHECK-NEXT:  }
define <4 x half> @strict_sub_scalar_vector(half %a, <4 x half> %b) {
  %s0 = insertelement <4 x half> undef, half %a, i32 0
  %s1 = insertelement <4 x half> %s0, half %a, i32 1
  %s2 = insertelement <4 x half> %s1, half %a, i32 2
  %s3 = insertelement <4 x half> %s2, half %a, i32 3
  %res = call <4 x half> @llvm.experimental.constrained.fsub.v4f16(<4 x half> %s3, <4 x half> %b, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <4 x half> %res
}

; CHECK-LABEL: sub_vector_zero:
; CHECK:       # %bb
; CHECK-NEXT:  br $m10
define <4 x half> @sub_vector_zero(<4 x half> %a) {
    %res = fsub <4 x half> %a, <half 0xH0, half 0xH0, half 0xH0, half 0xH0>
    ret <4 x half> %res
}

; T29761 tracks the useless f16v4sub
; CHECK-LABEL: strict_sub_vector_zero:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:    br $m10
; CHECK-NEXT:    f16v4sub $a0:1, $a0:1, $a14:15
; CHECK-NEXT:  }
define <4 x half> @strict_sub_vector_zero(<4 x half> %a) {
  %res = call <4 x half> @llvm.experimental.constrained.fsub.v4f16(<4 x half> %a, <4 x half> <half 0xH0, half 0xH0, half 0xH0, half 0xH0>, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <4 x half> %res
}

; CHECK-LABEL: mul_vector_vector:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4mul $a0:1, $a0:1, $a2:3
; CHECK-NEXT:  }
define <4 x half> @mul_vector_vector(<4 x half> %a, <4 x half> %b) {
  %res = fmul <4 x half> %a, %b
  ret <4 x half> %res
}

declare <4 x half> @llvm.experimental.constrained.fmul.v4f16(<4 x half>, <4 x half>, metadata, metadata)

; CHECK-LABEL: strict_mul_vector_vector:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4mul $a0:1, $a0:1, $a2:3
; CHECK-NEXT:  }
define <4 x half> @strict_mul_vector_vector(<4 x half> %a, <4 x half> %b) {
  %res = call <4 x half> @llvm.experimental.constrained.fmul.v4f16(<4 x half> %a, <4 x half> %b, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <4 x half> %res
}

; CHECK-LABEL: mul_vector_scalar:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4mul $a0:1, $a2:BL, $a0:1
; CHECK-NEXT:  }
define <4 x half> @mul_vector_scalar(<4 x half> %a, half %b) {
  %s0 = insertelement <4 x half> undef, half %b, i32 0
  %s1 = insertelement <4 x half> %s0, half %b, i32 1
  %s2 = insertelement <4 x half> %s1, half %b, i32 2
  %s3 = insertelement <4 x half> %s2, half %b, i32 3
  %res = fmul <4 x half> %a, %s3
  ret <4 x half> %res
}

; CHECK-LABEL: strict_mul_vector_scalar:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4mul $a0:1, $a2:BL, $a0:1
; CHECK-NEXT:  }
define <4 x half> @strict_mul_vector_scalar(<4 x half> %a, half %b) {
  %s0 = insertelement <4 x half> undef, half %b, i32 0
  %s1 = insertelement <4 x half> %s0, half %b, i32 1
  %s2 = insertelement <4 x half> %s1, half %b, i32 2
  %s3 = insertelement <4 x half> %s2, half %b, i32 3
  %res = call <4 x half> @llvm.experimental.constrained.fmul.v4f16(<4 x half> %a, <4 x half> %s3, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <4 x half> %res
}

; CHECK-LABEL: mul_scalar_vector:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4mul $a0:1, $a0:BL, $a2:3
; CHECK-NEXT:  }
define <4 x half> @mul_scalar_vector(half %a, <4 x half> %b) {
  %s0 = insertelement <4 x half> undef, half %a, i32 0
  %s1 = insertelement <4 x half> %s0, half %a, i32 1
  %s2 = insertelement <4 x half> %s1, half %a, i32 2
  %s3 = insertelement <4 x half> %s2, half %a, i32 3
  %res = fmul <4 x half> %s3, %b
  ret <4 x half> %res
}

; CHECK-LABEL: strict_mul_scalar_vector:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4mul $a0:1, $a0:BL, $a2:3
; CHECK-NEXT:  }
define <4 x half> @strict_mul_scalar_vector(half %a, <4 x half> %b) {
  %s0 = insertelement <4 x half> undef, half %a, i32 0
  %s1 = insertelement <4 x half> %s0, half %a, i32 1
  %s2 = insertelement <4 x half> %s1, half %a, i32 2
  %s3 = insertelement <4 x half> %s2, half %a, i32 3
  %res = call <4 x half> @llvm.experimental.constrained.fmul.v4f16(<4 x half> %s3, <4 x half> %b, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <4 x half> %res
}

; CHECK-LABEL: mul_vector_zero:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4mul $a0:1, $a0:1, $a14:15
; CHECK-NEXT:  }
define <4 x half> @mul_vector_zero(<4 x half> %a) {
    %res = fmul <4 x half> %a, <half 0xH0, half 0xH0, half 0xH0, half 0xH0>
    ret <4 x half> %res
}

; CHECK-LABEL: strict_mul_vector_zero:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4mul $a0:1, $a0:1, $a14:15
; CHECK-NEXT:  }
define <4 x half> @strict_mul_vector_zero(<4 x half> %a) {
  %res = call <4 x half> @llvm.experimental.constrained.fmul.v4f16(<4 x half> %a, <4 x half> <half 0xH0, half 0xH0, half 0xH0, half 0xH0>, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <4 x half> %res
}

;;; Broadcast element of a vector of length 2

; CHECK-LABEL: add_v2e0:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4add $a0:1, $a0:BL, $a2:3
; CHECK-NEXT:  }
define <4 x half> @add_v2e0(<2 x half> %a, <4 x half> %b) {
   %e = extractelement <2 x half> %a, i32 0
   %s0 = insertelement <4 x half> undef, half %e, i32 0
   %s1 = insertelement <4 x half> %s0, half %e, i32 1
   %s2 = insertelement <4 x half> %s1, half %e, i32 2
   %s3 = insertelement <4 x half> %s2, half %e, i32 3
   %res = fadd <4 x half> %s3, %b
   ret <4 x half> %res
}

; CHECK-LABEL: strict_add_v2e0:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4add $a0:1, $a0:BL, $a2:3
; CHECK-NEXT:  }
define <4 x half> @strict_add_v2e0(<2 x half> %a, <4 x half> %b) {
  %e = extractelement <2 x half> %a, i32 0
  %s0 = insertelement <4 x half> undef, half %e, i32 0
  %s1 = insertelement <4 x half> %s0, half %e, i32 1
  %s2 = insertelement <4 x half> %s1, half %e, i32 2
  %s3 = insertelement <4 x half> %s2, half %e, i32 3
  %res = call <4 x half> @llvm.experimental.constrained.fadd.v4f16(<4 x half> %s3, <4 x half> %b, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <4 x half> %res
}

; CHECK-LABEL: add_v2e0c:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4add $a0:1, $a2:BL, $a0:1
; CHECK-NEXT:  }
define <4 x half> @add_v2e0c(<4 x half> %a, <2 x half> %b) {
   %e = extractelement <2 x half> %b, i32 0
   %s0 = insertelement <4 x half> undef, half %e, i32 0
   %s1 = insertelement <4 x half> %s0, half %e, i32 1
   %s2 = insertelement <4 x half> %s1, half %e, i32 2
   %s3 = insertelement <4 x half> %s2, half %e, i32 3
   %res = fadd <4 x half> %a, %s3
   ret <4 x half> %res
}

; CHECK-LABEL: strict_add_v2e0c:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4add $a0:1, $a2:BL, $a0:1
; CHECK-NEXT:  }
define <4 x half> @strict_add_v2e0c(<4 x half> %a, <2 x half> %b) {
  %e = extractelement <2 x half> %b, i32 0
  %s0 = insertelement <4 x half> undef, half %e, i32 0
  %s1 = insertelement <4 x half> %s0, half %e, i32 1
  %s2 = insertelement <4 x half> %s1, half %e, i32 2
  %s3 = insertelement <4 x half> %s2, half %e, i32 3
  %res = call <4 x half> @llvm.experimental.constrained.fadd.v4f16(<4 x half> %a, <4 x half> %s3, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <4 x half> %res
}

; CHECK-LABEL: add_v2e1:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4add $a0:1, $a0:BU, $a2:3
; CHECK-NEXT:  }
define <4 x half> @add_v2e1(<2 x half> %a, <4 x half> %b) {
   %e = extractelement <2 x half> %a, i32 1
   %s0 = insertelement <4 x half> undef, half %e, i32 0
   %s1 = insertelement <4 x half> %s0, half %e, i32 1
   %s2 = insertelement <4 x half> %s1, half %e, i32 2
   %s3 = insertelement <4 x half> %s2, half %e, i32 3
   %res = fadd <4 x half> %s3, %b
   ret <4 x half> %res
}

; CHECK-LABEL: strict_add_v2e1:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4add $a0:1, $a0:BU, $a2:3
; CHECK-NEXT:  }
define <4 x half> @strict_add_v2e1(<2 x half> %a, <4 x half> %b) {
  %e = extractelement <2 x half> %a, i32 1
  %s0 = insertelement <4 x half> undef, half %e, i32 0
  %s1 = insertelement <4 x half> %s0, half %e, i32 1
  %s2 = insertelement <4 x half> %s1, half %e, i32 2
  %s3 = insertelement <4 x half> %s2, half %e, i32 3
  %res = call <4 x half> @llvm.experimental.constrained.fadd.v4f16(<4 x half> %s3, <4 x half> %b, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <4 x half> %res
}

; CHECK-LABEL: add_v2e1c:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4add $a0:1, $a2:BU, $a0:1
; CHECK-NEXT:  }
define <4 x half> @add_v2e1c(<4 x half> %a, <2 x half> %b) {
   %e = extractelement <2 x half> %b, i32 1
   %s0 = insertelement <4 x half> undef, half %e, i32 0
   %s1 = insertelement <4 x half> %s0, half %e, i32 1
   %s2 = insertelement <4 x half> %s1, half %e, i32 2
   %s3 = insertelement <4 x half> %s2, half %e, i32 3
   %res = fadd <4 x half> %a, %s3
   ret <4 x half> %res
}

; CHECK-LABEL: strict_add_v2e1c:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4add $a0:1, $a2:BU, $a0:1
; CHECK-NEXT:  }
define <4 x half> @strict_add_v2e1c(<4 x half> %a, <2 x half> %b) {
  %e = extractelement <2 x half> %b, i32 1
  %s0 = insertelement <4 x half> undef, half %e, i32 0
  %s1 = insertelement <4 x half> %s0, half %e, i32 1
  %s2 = insertelement <4 x half> %s1, half %e, i32 2
  %s3 = insertelement <4 x half> %s2, half %e, i32 3
  %res = call <4 x half> @llvm.experimental.constrained.fadd.v4f16(<4 x half> %a, <4 x half> %s3, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <4 x half> %res
}

; CHECK-LABEL: sub_v2e0:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4sub $a0:1, $a0:BL, $a2:3
; CHECK-NEXT:  }
define <4 x half> @sub_v2e0(<2 x half> %a, <4 x half> %b) {
   %e = extractelement <2 x half> %a, i32 0
   %s0 = insertelement <4 x half> undef, half %e, i32 0
   %s1 = insertelement <4 x half> %s0, half %e, i32 1
   %s2 = insertelement <4 x half> %s1, half %e, i32 2
   %s3 = insertelement <4 x half> %s2, half %e, i32 3
   %res = fsub <4 x half> %s3, %b
   ret <4 x half> %res
}

; CHECK-LABEL: strict_sub_v2e0:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4sub $a0:1, $a0:BL, $a2:3
; CHECK-NEXT:  }
define <4 x half> @strict_sub_v2e0(<2 x half> %a, <4 x half> %b) {
  %e = extractelement <2 x half> %a, i32 0
  %s0 = insertelement <4 x half> undef, half %e, i32 0
  %s1 = insertelement <4 x half> %s0, half %e, i32 1
  %s2 = insertelement <4 x half> %s1, half %e, i32 2
  %s3 = insertelement <4 x half> %s2, half %e, i32 3
  %res = call <4 x half> @llvm.experimental.constrained.fsub.v4f16(<4 x half> %s3, <4 x half> %b, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <4 x half> %res
}

; CHECK-LABEL: sub_v2e0c:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a2, $a2, $a2
; CHECK-NEXT:  mov $a3, $a2
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4sub $a0:1, $a0:1, $a2:3
; CHECK-NEXT:  }
define <4 x half> @sub_v2e0c(<4 x half> %a, <2 x half> %b) {
   %e = extractelement <2 x half> %b, i32 0
   %s0 = insertelement <4 x half> undef, half %e, i32 0
   %s1 = insertelement <4 x half> %s0, half %e, i32 1
   %s2 = insertelement <4 x half> %s1, half %e, i32 2
   %s3 = insertelement <4 x half> %s2, half %e, i32 3
   %res = fsub <4 x half> %a, %s3
   ret <4 x half> %res
}

; CHECK-LABEL: strict_sub_v2e0c:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a2, $a2, $a2
; CHECK-NEXT:  mov $a3, $a2
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4sub $a0:1, $a0:1, $a2:3
; CHECK-NEXT:  }
define <4 x half> @strict_sub_v2e0c(<4 x half> %a, <2 x half> %b) {
  %e = extractelement <2 x half> %b, i32 0
  %s0 = insertelement <4 x half> undef, half %e, i32 0
  %s1 = insertelement <4 x half> %s0, half %e, i32 1
  %s2 = insertelement <4 x half> %s1, half %e, i32 2
  %s3 = insertelement <4 x half> %s2, half %e, i32 3
  %res = call <4 x half> @llvm.experimental.constrained.fsub.v4f16(<4 x half> %a, <4 x half> %s3, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <4 x half> %res
}

; CHECK-LABEL: sub_v2e1:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4sub $a0:1, $a0:BU, $a2:3
; CHECK-NEXT:  }
define <4 x half> @sub_v2e1(<2 x half> %a, <4 x half> %b) {
   %e = extractelement <2 x half> %a, i32 1
   %s0 = insertelement <4 x half> undef, half %e, i32 0
   %s1 = insertelement <4 x half> %s0, half %e, i32 1
   %s2 = insertelement <4 x half> %s1, half %e, i32 2
   %s3 = insertelement <4 x half> %s2, half %e, i32 3
   %res = fsub <4 x half> %s3, %b
   ret <4 x half> %res
}

; CHECK-LABEL: strict_sub_v2e1:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4sub $a0:1, $a0:BU, $a2:3
; CHECK-NEXT:  }
define <4 x half> @strict_sub_v2e1(<2 x half> %a, <4 x half> %b) {
  %e = extractelement <2 x half> %a, i32 1
  %s0 = insertelement <4 x half> undef, half %e, i32 0
  %s1 = insertelement <4 x half> %s0, half %e, i32 1
  %s2 = insertelement <4 x half> %s1, half %e, i32 2
  %s3 = insertelement <4 x half> %s2, half %e, i32 3
  %res = call <4 x half> @llvm.experimental.constrained.fsub.v4f16(<4 x half> %s3, <4 x half> %b, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <4 x half> %res
}

; CHECK-LABEL: sub_v2e1c:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a2, $a2, $a2
; CHECK-NEXT:  mov $a3, $a2
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4sub $a0:1, $a0:1, $a2:3
; CHECK-NEXT:  }
define <4 x half> @sub_v2e1c(<4 x half> %a, <2 x half> %b) {
   %e = extractelement <2 x half> %b, i32 1
   %s0 = insertelement <4 x half> undef, half %e, i32 0
   %s1 = insertelement <4 x half> %s0, half %e, i32 1
   %s2 = insertelement <4 x half> %s1, half %e, i32 2
   %s3 = insertelement <4 x half> %s2, half %e, i32 3
   %res = fsub <4 x half> %a, %s3
   ret <4 x half> %res
}

; CHECK-LABEL: strict_sub_v2e1c:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a2, $a2, $a2
; CHECK-NEXT:  mov $a3, $a2
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4sub $a0:1, $a0:1, $a2:3
; CHECK-NEXT:  }
define <4 x half> @strict_sub_v2e1c(<4 x half> %a, <2 x half> %b) {
  %e = extractelement <2 x half> %b, i32 1
  %s0 = insertelement <4 x half> undef, half %e, i32 0
  %s1 = insertelement <4 x half> %s0, half %e, i32 1
  %s2 = insertelement <4 x half> %s1, half %e, i32 2
  %s3 = insertelement <4 x half> %s2, half %e, i32 3
  %res = call <4 x half> @llvm.experimental.constrained.fsub.v4f16(<4 x half> %a, <4 x half> %s3, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <4 x half> %res
}

; CHECK-LABEL: mul_v2e0:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4mul $a0:1, $a0:BL, $a2:3
; CHECK-NEXT:  }
define <4 x half> @mul_v2e0(<2 x half> %a, <4 x half> %b) {
   %e = extractelement <2 x half> %a, i32 0
   %s0 = insertelement <4 x half> undef, half %e, i32 0
   %s1 = insertelement <4 x half> %s0, half %e, i32 1
   %s2 = insertelement <4 x half> %s1, half %e, i32 2
   %s3 = insertelement <4 x half> %s2, half %e, i32 3
   %res = fmul <4 x half> %s3, %b
   ret <4 x half> %res
}

; CHECK-LABEL: strict_mul_v2e0:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4mul $a0:1, $a0:BL, $a2:3
; CHECK-NEXT:  }
define <4 x half> @strict_mul_v2e0(<2 x half> %a, <4 x half> %b) {
  %e = extractelement <2 x half> %a, i32 0
  %s0 = insertelement <4 x half> undef, half %e, i32 0
  %s1 = insertelement <4 x half> %s0, half %e, i32 1
  %s2 = insertelement <4 x half> %s1, half %e, i32 2
  %s3 = insertelement <4 x half> %s2, half %e, i32 3
  %res = call <4 x half> @llvm.experimental.constrained.fmul.v4f16(<4 x half> %s3, <4 x half> %b, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <4 x half> %res
}

; CHECK-LABEL: mul_v2e0c:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4mul $a0:1, $a2:BL, $a0:1
; CHECK-NEXT:  }
define <4 x half> @mul_v2e0c(<4 x half> %a, <2 x half> %b) {
   %e = extractelement <2 x half> %b, i32 0
   %s0 = insertelement <4 x half> undef, half %e, i32 0
   %s1 = insertelement <4 x half> %s0, half %e, i32 1
   %s2 = insertelement <4 x half> %s1, half %e, i32 2
   %s3 = insertelement <4 x half> %s2, half %e, i32 3
   %res = fmul <4 x half> %a, %s3
   ret <4 x half> %res
}

; CHECK-LABEL: strict_mul_v2e0c:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4mul $a0:1, $a2:BL, $a0:1
; CHECK-NEXT:  }
define <4 x half> @strict_mul_v2e0c(<4 x half> %a, <2 x half> %b) {
  %e = extractelement <2 x half> %b, i32 0
  %s0 = insertelement <4 x half> undef, half %e, i32 0
  %s1 = insertelement <4 x half> %s0, half %e, i32 1
  %s2 = insertelement <4 x half> %s1, half %e, i32 2
  %s3 = insertelement <4 x half> %s2, half %e, i32 3
  %res = call <4 x half> @llvm.experimental.constrained.fmul.v4f16(<4 x half> %a, <4 x half> %s3, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <4 x half> %res
}

; CHECK-LABEL: mul_v2e1:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4mul $a0:1, $a0:BU, $a2:3
; CHECK-NEXT:  }
define <4 x half> @mul_v2e1(<2 x half> %a, <4 x half> %b) {
   %e = extractelement <2 x half> %a, i32 1
   %s0 = insertelement <4 x half> undef, half %e, i32 0
   %s1 = insertelement <4 x half> %s0, half %e, i32 1
   %s2 = insertelement <4 x half> %s1, half %e, i32 2
   %s3 = insertelement <4 x half> %s2, half %e, i32 3
   %res = fmul <4 x half> %s3, %b
   ret <4 x half> %res
}

; CHECK-LABEL: strict_mul_v2e1:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4mul $a0:1, $a0:BU, $a2:3
; CHECK-NEXT:  }
define <4 x half> @strict_mul_v2e1(<2 x half> %a, <4 x half> %b) {
  %e = extractelement <2 x half> %a, i32 1
  %s0 = insertelement <4 x half> undef, half %e, i32 0
  %s1 = insertelement <4 x half> %s0, half %e, i32 1
  %s2 = insertelement <4 x half> %s1, half %e, i32 2
  %s3 = insertelement <4 x half> %s2, half %e, i32 3
  %res = call <4 x half> @llvm.experimental.constrained.fmul.v4f16(<4 x half> %s3, <4 x half> %b, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <4 x half> %res
}

; CHECK-LABEL: mul_v2e1c:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4mul $a0:1, $a2:BU, $a0:1
; CHECK-NEXT:  }
define <4 x half> @mul_v2e1c(<4 x half> %a, <2 x half> %b) {
   %e = extractelement <2 x half> %b, i32 1
   %s0 = insertelement <4 x half> undef, half %e, i32 0
   %s1 = insertelement <4 x half> %s0, half %e, i32 1
   %s2 = insertelement <4 x half> %s1, half %e, i32 2
   %s3 = insertelement <4 x half> %s2, half %e, i32 3
   %res = fmul <4 x half> %a, %s3
   ret <4 x half> %res
}

; CHECK-LABEL: strict_mul_v2e1c:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4mul $a0:1, $a2:BU, $a0:1
; CHECK-NEXT:  }
define <4 x half> @strict_mul_v2e1c(<4 x half> %a, <2 x half> %b) {
  %e = extractelement <2 x half> %b, i32 1
  %s0 = insertelement <4 x half> undef, half %e, i32 0
  %s1 = insertelement <4 x half> %s0, half %e, i32 1
  %s2 = insertelement <4 x half> %s1, half %e, i32 2
  %s3 = insertelement <4 x half> %s2, half %e, i32 3
  %res = call <4 x half> @llvm.experimental.constrained.fmul.v4f16(<4 x half> %a, <4 x half> %s3, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <4 x half> %res
}

;;; Broadcast element of a vector of length 4

; CHECK-LABEL: add_v4e0:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4add $a0:1, $a0:BL, $a2:3
; CHECK-NEXT:  }
define <4 x half> @add_v4e0(<4 x half> %a, <4 x half> %b) {
   %e = extractelement <4 x half> %a, i32 0
   %s0 = insertelement <4 x half> undef, half %e, i32 0
   %s1 = insertelement <4 x half> %s0, half %e, i32 1
   %s2 = insertelement <4 x half> %s1, half %e, i32 2
   %s3 = insertelement <4 x half> %s2, half %e, i32 3
   %res = fadd <4 x half> %s3, %b
   ret <4 x half> %res
}

; CHECK-LABEL: strict_add_v4e0:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4add $a0:1, $a0:BL, $a2:3
; CHECK-NEXT:  }
define <4 x half> @strict_add_v4e0(<4 x half> %a, <4 x half> %b) {
  %e = extractelement <4 x half> %a, i32 0
  %s0 = insertelement <4 x half> undef, half %e, i32 0
  %s1 = insertelement <4 x half> %s0, half %e, i32 1
  %s2 = insertelement <4 x half> %s1, half %e, i32 2
  %s3 = insertelement <4 x half> %s2, half %e, i32 3
  %res = call <4 x half> @llvm.experimental.constrained.fadd.v4f16(<4 x half> %s3, <4 x half> %b, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <4 x half> %res
}

; CHECK-LABEL: add_v4e0c:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4add $a0:1, $a2:BL, $a0:1
; CHECK-NEXT:  }
define <4 x half> @add_v4e0c(<4 x half> %a, <4 x half> %b) {
   %e = extractelement <4 x half> %b, i32 0
   %s0 = insertelement <4 x half> undef, half %e, i32 0
   %s1 = insertelement <4 x half> %s0, half %e, i32 1
   %s2 = insertelement <4 x half> %s1, half %e, i32 2
   %s3 = insertelement <4 x half> %s2, half %e, i32 3
   %res = fadd <4 x half> %a, %s3
   ret <4 x half> %res
}

; CHECK-LABEL: strict_add_v4e0c:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4add $a0:1, $a2:BL, $a0:1
; CHECK-NEXT:  }
define <4 x half> @strict_add_v4e0c(<4 x half> %a, <4 x half> %b) {
  %e = extractelement <4 x half> %b, i32 0
  %s0 = insertelement <4 x half> undef, half %e, i32 0
  %s1 = insertelement <4 x half> %s0, half %e, i32 1
  %s2 = insertelement <4 x half> %s1, half %e, i32 2
  %s3 = insertelement <4 x half> %s2, half %e, i32 3
  %res = call <4 x half> @llvm.experimental.constrained.fadd.v4f16(<4 x half> %a, <4 x half> %s3, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <4 x half> %res
}

; CHECK-LABEL: add_v4e1:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4add $a0:1, $a0:BU, $a2:3
; CHECK-NEXT:  }
define <4 x half> @add_v4e1(<4 x half> %a, <4 x half> %b) {
   %e = extractelement <4 x half> %a, i32 1
   %s0 = insertelement <4 x half> undef, half %e, i32 0
   %s1 = insertelement <4 x half> %s0, half %e, i32 1
   %s2 = insertelement <4 x half> %s1, half %e, i32 2
   %s3 = insertelement <4 x half> %s2, half %e, i32 3
   %res = fadd <4 x half> %s3, %b
   ret <4 x half> %res
}

; CHECK-LABEL: strict_add_v4e1:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4add $a0:1, $a0:BU, $a2:3
; CHECK-NEXT:  }
define <4 x half> @strict_add_v4e1(<4 x half> %a, <4 x half> %b) {
  %e = extractelement <4 x half> %a, i32 1
  %s0 = insertelement <4 x half> undef, half %e, i32 0
  %s1 = insertelement <4 x half> %s0, half %e, i32 1
  %s2 = insertelement <4 x half> %s1, half %e, i32 2
  %s3 = insertelement <4 x half> %s2, half %e, i32 3
  %res = call <4 x half> @llvm.experimental.constrained.fadd.v4f16(<4 x half> %s3, <4 x half> %b, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <4 x half> %res
}

; CHECK-LABEL: add_v4e1c:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4add $a0:1, $a2:BU, $a0:1
; CHECK-NEXT:  }
define <4 x half> @add_v4e1c(<4 x half> %a, <4 x half> %b) {
   %e = extractelement <4 x half> %b, i32 1
   %s0 = insertelement <4 x half> undef, half %e, i32 0
   %s1 = insertelement <4 x half> %s0, half %e, i32 1
   %s2 = insertelement <4 x half> %s1, half %e, i32 2
   %s3 = insertelement <4 x half> %s2, half %e, i32 3
   %res = fadd <4 x half> %a, %s3
   ret <4 x half> %res
}

; CHECK-LABEL: strict_add_v4e1c:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4add $a0:1, $a2:BU, $a0:1
; CHECK-NEXT:  }
define <4 x half> @strict_add_v4e1c(<4 x half> %a, <4 x half> %b) {
  %e = extractelement <4 x half> %b, i32 1
  %s0 = insertelement <4 x half> undef, half %e, i32 0
  %s1 = insertelement <4 x half> %s0, half %e, i32 1
  %s2 = insertelement <4 x half> %s1, half %e, i32 2
  %s3 = insertelement <4 x half> %s2, half %e, i32 3
  %res = call <4 x half> @llvm.experimental.constrained.fadd.v4f16(<4 x half> %a, <4 x half> %s3, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <4 x half> %res
}

; CHECK-LABEL: add_v4e2:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4add $a0:1, $a1:BL, $a2:3
; CHECK-NEXT:  }
define <4 x half> @add_v4e2(<4 x half> %a, <4 x half> %b) {
   %e = extractelement <4 x half> %a, i32 2
   %s0 = insertelement <4 x half> undef, half %e, i32 0
   %s1 = insertelement <4 x half> %s0, half %e, i32 1
   %s2 = insertelement <4 x half> %s1, half %e, i32 2
   %s3 = insertelement <4 x half> %s2, half %e, i32 3
   %res = fadd <4 x half> %s3, %b
   ret <4 x half> %res
}

; CHECK-LABEL: strict_add_v4e2:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4add $a0:1, $a1:BL, $a2:3
; CHECK-NEXT:  }
define <4 x half> @strict_add_v4e2(<4 x half> %a, <4 x half> %b) {
  %e = extractelement <4 x half> %a, i32 2
  %s0 = insertelement <4 x half> undef, half %e, i32 0
  %s1 = insertelement <4 x half> %s0, half %e, i32 1
  %s2 = insertelement <4 x half> %s1, half %e, i32 2
  %s3 = insertelement <4 x half> %s2, half %e, i32 3
  %res = call <4 x half> @llvm.experimental.constrained.fadd.v4f16(<4 x half> %s3, <4 x half> %b, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <4 x half> %res
}

; CHECK-LABEL: add_v4e2c:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4add $a0:1, $a3:BL, $a0:1
; CHECK-NEXT:  }
define <4 x half> @add_v4e2c(<4 x half> %a, <4 x half> %b) {
   %e = extractelement <4 x half> %b, i32 2
   %s0 = insertelement <4 x half> undef, half %e, i32 0
   %s1 = insertelement <4 x half> %s0, half %e, i32 1
   %s2 = insertelement <4 x half> %s1, half %e, i32 2
   %s3 = insertelement <4 x half> %s2, half %e, i32 3
   %res = fadd <4 x half> %a, %s3
   ret <4 x half> %res
}

; CHECK-LABEL: strict_add_v4e2c:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4add $a0:1, $a3:BL, $a0:1
; CHECK-NEXT:  }
define <4 x half> @strict_add_v4e2c(<4 x half> %a, <4 x half> %b) {
  %e = extractelement <4 x half> %b, i32 2
  %s0 = insertelement <4 x half> undef, half %e, i32 0
  %s1 = insertelement <4 x half> %s0, half %e, i32 1
  %s2 = insertelement <4 x half> %s1, half %e, i32 2
  %s3 = insertelement <4 x half> %s2, half %e, i32 3
  %res = call <4 x half> @llvm.experimental.constrained.fadd.v4f16(<4 x half> %a, <4 x half> %s3, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <4 x half> %res
}

; CHECK-LABEL: add_v4e3:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4add $a0:1, $a1:BU, $a2:3
; CHECK-NEXT:  }
define <4 x half> @add_v4e3(<4 x half> %a, <4 x half> %b) {
   %e = extractelement <4 x half> %a, i32 3
   %s0 = insertelement <4 x half> undef, half %e, i32 0
   %s1 = insertelement <4 x half> %s0, half %e, i32 1
   %s2 = insertelement <4 x half> %s1, half %e, i32 2
   %s3 = insertelement <4 x half> %s2, half %e, i32 3
   %res = fadd <4 x half> %s3, %b
   ret <4 x half> %res
}

; CHECK-LABEL: strict_add_v4e3:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4add $a0:1, $a1:BU, $a2:3
; CHECK-NEXT:  }
define <4 x half> @strict_add_v4e3(<4 x half> %a, <4 x half> %b) {
  %e = extractelement <4 x half> %a, i32 3
  %s0 = insertelement <4 x half> undef, half %e, i32 0
  %s1 = insertelement <4 x half> %s0, half %e, i32 1
  %s2 = insertelement <4 x half> %s1, half %e, i32 2
  %s3 = insertelement <4 x half> %s2, half %e, i32 3
  %res = call <4 x half> @llvm.experimental.constrained.fadd.v4f16(<4 x half> %s3, <4 x half> %b, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <4 x half> %res
}

; CHECK-LABEL: add_v4e3c:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4add $a0:1, $a3:BU, $a0:1
; CHECK-NEXT:  }
define <4 x half> @add_v4e3c(<4 x half> %a, <4 x half> %b) {
   %e = extractelement <4 x half> %b, i32 3
   %s0 = insertelement <4 x half> undef, half %e, i32 0
   %s1 = insertelement <4 x half> %s0, half %e, i32 1
   %s2 = insertelement <4 x half> %s1, half %e, i32 2
   %s3 = insertelement <4 x half> %s2, half %e, i32 3
   %res = fadd <4 x half> %a, %s3
   ret <4 x half> %res
}

; CHECK-LABEL: strict_add_v4e3c:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4add $a0:1, $a3:BU, $a0:1
; CHECK-NEXT:  }
define <4 x half> @strict_add_v4e3c(<4 x half> %a, <4 x half> %b) {
  %e = extractelement <4 x half> %b, i32 3
  %s0 = insertelement <4 x half> undef, half %e, i32 0
  %s1 = insertelement <4 x half> %s0, half %e, i32 1
  %s2 = insertelement <4 x half> %s1, half %e, i32 2
  %s3 = insertelement <4 x half> %s2, half %e, i32 3
  %res = call <4 x half> @llvm.experimental.constrained.fadd.v4f16(<4 x half> %a, <4 x half> %s3, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <4 x half> %res
}

; CHECK-LABEL: sub_v4e0:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4sub $a0:1, $a0:BL, $a2:3
; CHECK-NEXT:  }
define <4 x half> @sub_v4e0(<4 x half> %a, <4 x half> %b) {
   %e = extractelement <4 x half> %a, i32 0
   %s0 = insertelement <4 x half> undef, half %e, i32 0
   %s1 = insertelement <4 x half> %s0, half %e, i32 1
   %s2 = insertelement <4 x half> %s1, half %e, i32 2
   %s3 = insertelement <4 x half> %s2, half %e, i32 3
   %res = fsub <4 x half> %s3, %b
   ret <4 x half> %res
}

; CHECK-LABEL: strict_sub_v4e0:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4sub $a0:1, $a0:BL, $a2:3
; CHECK-NEXT:  }
define <4 x half> @strict_sub_v4e0(<4 x half> %a, <4 x half> %b) {
  %e = extractelement <4 x half> %a, i32 0
  %s0 = insertelement <4 x half> undef, half %e, i32 0
  %s1 = insertelement <4 x half> %s0, half %e, i32 1
  %s2 = insertelement <4 x half> %s1, half %e, i32 2
  %s3 = insertelement <4 x half> %s2, half %e, i32 3
  %res = call <4 x half> @llvm.experimental.constrained.fsub.v4f16(<4 x half> %s3, <4 x half> %b, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <4 x half> %res
}

; CHECK-LABEL: sub_v4e0c:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a2, $a2, $a2
; CHECK-NEXT:  mov $a3, $a2
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4sub $a0:1, $a0:1, $a2:3
; CHECK-NEXT:  }
define <4 x half> @sub_v4e0c(<4 x half> %a, <4 x half> %b) {
   %e = extractelement <4 x half> %b, i32 0
   %s0 = insertelement <4 x half> undef, half %e, i32 0
   %s1 = insertelement <4 x half> %s0, half %e, i32 1
   %s2 = insertelement <4 x half> %s1, half %e, i32 2
   %s3 = insertelement <4 x half> %s2, half %e, i32 3
   %res = fsub <4 x half> %a, %s3
   ret <4 x half> %res
}

; CHECK-LABEL: strict_sub_v4e0c:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a2, $a2, $a2
; CHECK-NEXT:  mov $a3, $a2
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4sub $a0:1, $a0:1, $a2:3
; CHECK-NEXT:  }
define <4 x half> @strict_sub_v4e0c(<4 x half> %a, <4 x half> %b) {
  %e = extractelement <4 x half> %b, i32 0
  %s0 = insertelement <4 x half> undef, half %e, i32 0
  %s1 = insertelement <4 x half> %s0, half %e, i32 1
  %s2 = insertelement <4 x half> %s1, half %e, i32 2
  %s3 = insertelement <4 x half> %s2, half %e, i32 3
  %res = call <4 x half> @llvm.experimental.constrained.fsub.v4f16(<4 x half> %a, <4 x half> %s3, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <4 x half> %res
}

; CHECK-LABEL: sub_v4e1:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4sub $a0:1, $a0:BU, $a2:3
; CHECK-NEXT:  }
define <4 x half> @sub_v4e1(<4 x half> %a, <4 x half> %b) {
   %e = extractelement <4 x half> %a, i32 1
   %s0 = insertelement <4 x half> undef, half %e, i32 0
   %s1 = insertelement <4 x half> %s0, half %e, i32 1
   %s2 = insertelement <4 x half> %s1, half %e, i32 2
   %s3 = insertelement <4 x half> %s2, half %e, i32 3
   %res = fsub <4 x half> %s3, %b
   ret <4 x half> %res
}

; CHECK-LABEL: strict_sub_v4e1:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4sub $a0:1, $a0:BU, $a2:3
; CHECK-NEXT:  }
define <4 x half> @strict_sub_v4e1(<4 x half> %a, <4 x half> %b) {
  %e = extractelement <4 x half> %a, i32 1
  %s0 = insertelement <4 x half> undef, half %e, i32 0
  %s1 = insertelement <4 x half> %s0, half %e, i32 1
  %s2 = insertelement <4 x half> %s1, half %e, i32 2
  %s3 = insertelement <4 x half> %s2, half %e, i32 3
  %res = call <4 x half> @llvm.experimental.constrained.fsub.v4f16(<4 x half> %s3, <4 x half> %b, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <4 x half> %res
}

; CHECK-LABEL: sub_v4e1c:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a2, $a2, $a2
; CHECK-NEXT:  mov $a3, $a2
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4sub $a0:1, $a0:1, $a2:3
; CHECK-NEXT:  }
define <4 x half> @sub_v4e1c(<4 x half> %a, <4 x half> %b) {
   %e = extractelement <4 x half> %b, i32 1
   %s0 = insertelement <4 x half> undef, half %e, i32 0
   %s1 = insertelement <4 x half> %s0, half %e, i32 1
   %s2 = insertelement <4 x half> %s1, half %e, i32 2
   %s3 = insertelement <4 x half> %s2, half %e, i32 3
   %res = fsub <4 x half> %a, %s3
   ret <4 x half> %res
}

; CHECK-LABEL: strict_sub_v4e1c:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a2, $a2, $a2
; CHECK-NEXT:  mov $a3, $a2
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4sub $a0:1, $a0:1, $a2:3
; CHECK-NEXT:  }
define <4 x half> @strict_sub_v4e1c(<4 x half> %a, <4 x half> %b) {
  %e = extractelement <4 x half> %b, i32 1
  %s0 = insertelement <4 x half> undef, half %e, i32 0
  %s1 = insertelement <4 x half> %s0, half %e, i32 1
  %s2 = insertelement <4 x half> %s1, half %e, i32 2
  %s3 = insertelement <4 x half> %s2, half %e, i32 3
  %res = call <4 x half> @llvm.experimental.constrained.fsub.v4f16(<4 x half> %a, <4 x half> %s3, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <4 x half> %res
}

; CHECK-LABEL: sub_v4e2:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4sub $a0:1, $a1:BL, $a2:3
; CHECK-NEXT:  }
define <4 x half> @sub_v4e2(<4 x half> %a, <4 x half> %b) {
   %e = extractelement <4 x half> %a, i32 2
   %s0 = insertelement <4 x half> undef, half %e, i32 0
   %s1 = insertelement <4 x half> %s0, half %e, i32 1
   %s2 = insertelement <4 x half> %s1, half %e, i32 2
   %s3 = insertelement <4 x half> %s2, half %e, i32 3
   %res = fsub <4 x half> %s3, %b
   ret <4 x half> %res
}

; CHECK-LABEL: strict_sub_v4e2:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4sub $a0:1, $a1:BL, $a2:3
; CHECK-NEXT:  }
define <4 x half> @strict_sub_v4e2(<4 x half> %a, <4 x half> %b) {
  %e = extractelement <4 x half> %a, i32 2
  %s0 = insertelement <4 x half> undef, half %e, i32 0
  %s1 = insertelement <4 x half> %s0, half %e, i32 1
  %s2 = insertelement <4 x half> %s1, half %e, i32 2
  %s3 = insertelement <4 x half> %s2, half %e, i32 3
  %res = call <4 x half> @llvm.experimental.constrained.fsub.v4f16(<4 x half> %s3, <4 x half> %b, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <4 x half> %res
}

; CHECK-LABEL: sub_v4e2c:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a2, $a3, $a3
; CHECK-NEXT:  mov $a3, $a2
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4sub $a0:1, $a0:1, $a2:3
; CHECK-NEXT:  }
define <4 x half> @sub_v4e2c(<4 x half> %a, <4 x half> %b) {
   %e = extractelement <4 x half> %b, i32 2
   %s0 = insertelement <4 x half> undef, half %e, i32 0
   %s1 = insertelement <4 x half> %s0, half %e, i32 1
   %s2 = insertelement <4 x half> %s1, half %e, i32 2
   %s3 = insertelement <4 x half> %s2, half %e, i32 3
   %res = fsub <4 x half> %a, %s3
   ret <4 x half> %res
}

; CHECK-LABEL: strict_sub_v4e2c:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a2, $a3, $a3
; CHECK-NEXT:  mov $a3, $a2
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4sub $a0:1, $a0:1, $a2:3
; CHECK-NEXT:  }
define <4 x half> @strict_sub_v4e2c(<4 x half> %a, <4 x half> %b) {
  %e = extractelement <4 x half> %b, i32 2
  %s0 = insertelement <4 x half> undef, half %e, i32 0
  %s1 = insertelement <4 x half> %s0, half %e, i32 1
  %s2 = insertelement <4 x half> %s1, half %e, i32 2
  %s3 = insertelement <4 x half> %s2, half %e, i32 3
  %res = call <4 x half> @llvm.experimental.constrained.fsub.v4f16(<4 x half> %a, <4 x half> %s3, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <4 x half> %res
}

; CHECK-LABEL: sub_v4e3:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4sub $a0:1, $a1:BU, $a2:3
; CHECK-NEXT:  }
define <4 x half> @sub_v4e3(<4 x half> %a, <4 x half> %b) {
   %e = extractelement <4 x half> %a, i32 3
   %s0 = insertelement <4 x half> undef, half %e, i32 0
   %s1 = insertelement <4 x half> %s0, half %e, i32 1
   %s2 = insertelement <4 x half> %s1, half %e, i32 2
   %s3 = insertelement <4 x half> %s2, half %e, i32 3
   %res = fsub <4 x half> %s3, %b
   ret <4 x half> %res
}

; CHECK-LABEL: strict_sub_v4e3:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4sub $a0:1, $a1:BU, $a2:3
; CHECK-NEXT:  }
define <4 x half> @strict_sub_v4e3(<4 x half> %a, <4 x half> %b) {
  %e = extractelement <4 x half> %a, i32 3
  %s0 = insertelement <4 x half> undef, half %e, i32 0
  %s1 = insertelement <4 x half> %s0, half %e, i32 1
  %s2 = insertelement <4 x half> %s1, half %e, i32 2
  %s3 = insertelement <4 x half> %s2, half %e, i32 3
  %res = call <4 x half> @llvm.experimental.constrained.fsub.v4f16(<4 x half> %s3, <4 x half> %b, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <4 x half> %res
}

; CHECK-LABEL: sub_v4e3c:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a2, $a3, $a3
; CHECK-NEXT:  mov $a3, $a2
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4sub $a0:1, $a0:1, $a2:3
; CHECK-NEXT:  }
define <4 x half> @sub_v4e3c(<4 x half> %a, <4 x half> %b) {
   %e = extractelement <4 x half> %b, i32 3
   %s0 = insertelement <4 x half> undef, half %e, i32 0
   %s1 = insertelement <4 x half> %s0, half %e, i32 1
   %s2 = insertelement <4 x half> %s1, half %e, i32 2
   %s3 = insertelement <4 x half> %s2, half %e, i32 3
   %res = fsub <4 x half> %a, %s3
   ret <4 x half> %res
}

; CHECK-LABEL: strict_sub_v4e3c:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a2, $a3, $a3
; CHECK-NEXT:  mov $a3, $a2
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4sub $a0:1, $a0:1, $a2:3
; CHECK-NEXT:  }
define <4 x half> @strict_sub_v4e3c(<4 x half> %a, <4 x half> %b) {
  %e = extractelement <4 x half> %b, i32 3
  %s0 = insertelement <4 x half> undef, half %e, i32 0
  %s1 = insertelement <4 x half> %s0, half %e, i32 1
  %s2 = insertelement <4 x half> %s1, half %e, i32 2
  %s3 = insertelement <4 x half> %s2, half %e, i32 3
  %res = call <4 x half> @llvm.experimental.constrained.fsub.v4f16(<4 x half> %a, <4 x half> %s3, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <4 x half> %res
}

; CHECK-LABEL: mul_v4e0:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4mul $a0:1, $a0:BL, $a2:3
; CHECK-NEXT:  }
define <4 x half> @mul_v4e0(<4 x half> %a, <4 x half> %b) {
   %e = extractelement <4 x half> %a, i32 0
   %s0 = insertelement <4 x half> undef, half %e, i32 0
   %s1 = insertelement <4 x half> %s0, half %e, i32 1
   %s2 = insertelement <4 x half> %s1, half %e, i32 2
   %s3 = insertelement <4 x half> %s2, half %e, i32 3
   %res = fmul <4 x half> %s3, %b
   ret <4 x half> %res
}

; CHECK-LABEL: strict_mul_v4e0:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4mul $a0:1, $a0:BL, $a2:3
; CHECK-NEXT:  }
define <4 x half> @strict_mul_v4e0(<4 x half> %a, <4 x half> %b) {
  %e = extractelement <4 x half> %a, i32 0
  %s0 = insertelement <4 x half> undef, half %e, i32 0
  %s1 = insertelement <4 x half> %s0, half %e, i32 1
  %s2 = insertelement <4 x half> %s1, half %e, i32 2
  %s3 = insertelement <4 x half> %s2, half %e, i32 3
  %res = call <4 x half> @llvm.experimental.constrained.fmul.v4f16(<4 x half> %s3, <4 x half> %b, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <4 x half> %res
}

; CHECK-LABEL: mul_v4e0c:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4mul $a0:1, $a2:BL, $a0:1
; CHECK-NEXT:  }
define <4 x half> @mul_v4e0c(<4 x half> %a, <4 x half> %b) {
   %e = extractelement <4 x half> %b, i32 0
   %s0 = insertelement <4 x half> undef, half %e, i32 0
   %s1 = insertelement <4 x half> %s0, half %e, i32 1
   %s2 = insertelement <4 x half> %s1, half %e, i32 2
   %s3 = insertelement <4 x half> %s2, half %e, i32 3
   %res = fmul <4 x half> %a, %s3
   ret <4 x half> %res
}

; CHECK-LABEL: strict_mul_v4e0c:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4mul $a0:1, $a2:BL, $a0:1
; CHECK-NEXT:  }
define <4 x half> @strict_mul_v4e0c(<4 x half> %a, <4 x half> %b) {
  %e = extractelement <4 x half> %b, i32 0
  %s0 = insertelement <4 x half> undef, half %e, i32 0
  %s1 = insertelement <4 x half> %s0, half %e, i32 1
  %s2 = insertelement <4 x half> %s1, half %e, i32 2
  %s3 = insertelement <4 x half> %s2, half %e, i32 3
  %res = call <4 x half> @llvm.experimental.constrained.fmul.v4f16(<4 x half> %a, <4 x half> %s3, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <4 x half> %res
}

; CHECK-LABEL: mul_v4e1:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4mul $a0:1, $a0:BU, $a2:3
; CHECK-NEXT:  }
define <4 x half> @mul_v4e1(<4 x half> %a, <4 x half> %b) {
   %e = extractelement <4 x half> %a, i32 1
   %s0 = insertelement <4 x half> undef, half %e, i32 0
   %s1 = insertelement <4 x half> %s0, half %e, i32 1
   %s2 = insertelement <4 x half> %s1, half %e, i32 2
   %s3 = insertelement <4 x half> %s2, half %e, i32 3
   %res = fmul <4 x half> %s3, %b
   ret <4 x half> %res
}

; CHECK-LABEL: strict_mul_v4e1:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4mul $a0:1, $a0:BU, $a2:3
; CHECK-NEXT:  }
define <4 x half> @strict_mul_v4e1(<4 x half> %a, <4 x half> %b) {
  %e = extractelement <4 x half> %a, i32 1
  %s0 = insertelement <4 x half> undef, half %e, i32 0
  %s1 = insertelement <4 x half> %s0, half %e, i32 1
  %s2 = insertelement <4 x half> %s1, half %e, i32 2
  %s3 = insertelement <4 x half> %s2, half %e, i32 3
  %res = call <4 x half> @llvm.experimental.constrained.fmul.v4f16(<4 x half> %s3, <4 x half> %b, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <4 x half> %res
}

; CHECK-LABEL: mul_v4e1c:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4mul $a0:1, $a2:BU, $a0:1
; CHECK-NEXT:  }
define <4 x half> @mul_v4e1c(<4 x half> %a, <4 x half> %b) {
   %e = extractelement <4 x half> %b, i32 1
   %s0 = insertelement <4 x half> undef, half %e, i32 0
   %s1 = insertelement <4 x half> %s0, half %e, i32 1
   %s2 = insertelement <4 x half> %s1, half %e, i32 2
   %s3 = insertelement <4 x half> %s2, half %e, i32 3
   %res = fmul <4 x half> %a, %s3
   ret <4 x half> %res
}

; CHECK-LABEL: strict_mul_v4e1c:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4mul $a0:1, $a2:BU, $a0:1
; CHECK-NEXT:  }
define <4 x half> @strict_mul_v4e1c(<4 x half> %a, <4 x half> %b) {
  %e = extractelement <4 x half> %b, i32 1
  %s0 = insertelement <4 x half> undef, half %e, i32 0
  %s1 = insertelement <4 x half> %s0, half %e, i32 1
  %s2 = insertelement <4 x half> %s1, half %e, i32 2
  %s3 = insertelement <4 x half> %s2, half %e, i32 3
  %res = call <4 x half> @llvm.experimental.constrained.fmul.v4f16(<4 x half> %a, <4 x half> %s3, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <4 x half> %res
}

; CHECK-LABEL: mul_v4e2:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4mul $a0:1, $a1:BL, $a2:3
; CHECK-NEXT:  }
define <4 x half> @mul_v4e2(<4 x half> %a, <4 x half> %b) {
   %e = extractelement <4 x half> %a, i32 2
   %s0 = insertelement <4 x half> undef, half %e, i32 0
   %s1 = insertelement <4 x half> %s0, half %e, i32 1
   %s2 = insertelement <4 x half> %s1, half %e, i32 2
   %s3 = insertelement <4 x half> %s2, half %e, i32 3
   %res = fmul <4 x half> %s3, %b
   ret <4 x half> %res
}

; CHECK-LABEL: strict_mul_v4e2:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4mul $a0:1, $a1:BL, $a2:3
; CHECK-NEXT:  }
define <4 x half> @strict_mul_v4e2(<4 x half> %a, <4 x half> %b) {
  %e = extractelement <4 x half> %a, i32 2
  %s0 = insertelement <4 x half> undef, half %e, i32 0
  %s1 = insertelement <4 x half> %s0, half %e, i32 1
  %s2 = insertelement <4 x half> %s1, half %e, i32 2
  %s3 = insertelement <4 x half> %s2, half %e, i32 3
  %res = call <4 x half> @llvm.experimental.constrained.fmul.v4f16(<4 x half> %s3, <4 x half> %b, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <4 x half> %res
}

; CHECK-LABEL: mul_v4e2c:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4mul $a0:1, $a3:BL, $a0:1
; CHECK-NEXT:  }
define <4 x half> @mul_v4e2c(<4 x half> %a, <4 x half> %b) {
   %e = extractelement <4 x half> %b, i32 2
   %s0 = insertelement <4 x half> undef, half %e, i32 0
   %s1 = insertelement <4 x half> %s0, half %e, i32 1
   %s2 = insertelement <4 x half> %s1, half %e, i32 2
   %s3 = insertelement <4 x half> %s2, half %e, i32 3
   %res = fmul <4 x half> %a, %s3
   ret <4 x half> %res
}

; CHECK-LABEL: strict_mul_v4e2c:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4mul $a0:1, $a3:BL, $a0:1
; CHECK-NEXT:  }
define <4 x half> @strict_mul_v4e2c(<4 x half> %a, <4 x half> %b) {
  %e = extractelement <4 x half> %b, i32 2
  %s0 = insertelement <4 x half> undef, half %e, i32 0
  %s1 = insertelement <4 x half> %s0, half %e, i32 1
  %s2 = insertelement <4 x half> %s1, half %e, i32 2
  %s3 = insertelement <4 x half> %s2, half %e, i32 3
  %res = call <4 x half> @llvm.experimental.constrained.fmul.v4f16(<4 x half> %a, <4 x half> %s3, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <4 x half> %res
}

; CHECK-LABEL: mul_v4e3:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4mul $a0:1, $a1:BU, $a2:3
; CHECK-NEXT:  }
define <4 x half> @mul_v4e3(<4 x half> %a, <4 x half> %b) {
   %e = extractelement <4 x half> %a, i32 3
   %s0 = insertelement <4 x half> undef, half %e, i32 0
   %s1 = insertelement <4 x half> %s0, half %e, i32 1
   %s2 = insertelement <4 x half> %s1, half %e, i32 2
   %s3 = insertelement <4 x half> %s2, half %e, i32 3
   %res = fmul <4 x half> %s3, %b
   ret <4 x half> %res
}

; CHECK-LABEL: strict_mul_v4e3:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4mul $a0:1, $a1:BU, $a2:3
; CHECK-NEXT:  }
define <4 x half> @strict_mul_v4e3(<4 x half> %a, <4 x half> %b) {
  %e = extractelement <4 x half> %a, i32 3
  %s0 = insertelement <4 x half> undef, half %e, i32 0
  %s1 = insertelement <4 x half> %s0, half %e, i32 1
  %s2 = insertelement <4 x half> %s1, half %e, i32 2
  %s3 = insertelement <4 x half> %s2, half %e, i32 3
  %res = call <4 x half> @llvm.experimental.constrained.fmul.v4f16(<4 x half> %s3, <4 x half> %b, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <4 x half> %res
}

; CHECK-LABEL: mul_v4e3c:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4mul $a0:1, $a3:BU, $a0:1
; CHECK-NEXT:  }
define <4 x half> @mul_v4e3c(<4 x half> %a, <4 x half> %b) {
   %e = extractelement <4 x half> %b, i32 3
   %s0 = insertelement <4 x half> undef, half %e, i32 0
   %s1 = insertelement <4 x half> %s0, half %e, i32 1
   %s2 = insertelement <4 x half> %s1, half %e, i32 2
   %s3 = insertelement <4 x half> %s2, half %e, i32 3
   %res = fmul <4 x half> %a, %s3
   ret <4 x half> %res
}

; CHECK-LABEL: strict_mul_v4e3c:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4mul $a0:1, $a3:BU, $a0:1
; CHECK-NEXT:  }
define <4 x half> @strict_mul_v4e3c(<4 x half> %a, <4 x half> %b) {
  %e = extractelement <4 x half> %b, i32 3
  %s0 = insertelement <4 x half> undef, half %e, i32 0
  %s1 = insertelement <4 x half> %s0, half %e, i32 1
  %s2 = insertelement <4 x half> %s1, half %e, i32 2
  %s3 = insertelement <4 x half> %s2, half %e, i32 3
  %res = call <4 x half> @llvm.experimental.constrained.fmul.v4f16(<4 x half> %a, <4 x half> %s3, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <4 x half> %res
}
