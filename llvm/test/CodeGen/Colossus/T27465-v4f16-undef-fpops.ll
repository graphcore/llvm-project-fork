; RUN: llc < %s -mtriple=colossus -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -mtriple=colossus -mattr=+ipu2 | FileCheck %s

; Check that if SelectionDAG input contains a vector floating-point operation
; involving undefined entries the resulting code does not use undefined
; register in the computation.

; CHECK-LABEL: partially_undef_fadd:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f16v2add $a0, $a0, $a2
; CHECK-NEXT:  sort4x16lo $a0, $a0, $a0
; CHECK-NEXT:  {
; CHECK-NEXT:    br $m10
; CHECK-NEXT:    mov     $a1, $a0
; CHECK-NEXT:  }
define <4 x half> @partially_undef_fadd(half %a, half %gap, half %b) {
  %vecinita = insertelement <4 x half> undef, half %a, i32 0
  %vecinitb = insertelement <4 x half> undef, half %b, i32 0
  %add = fadd <4 x half> %vecinita, %vecinitb
  %res = shufflevector <4 x half> %add, <4 x half> undef, <4 x i32> zeroinitializer
  ret <4 x half> %res
}

; CHECK-LABEL: partially_undef_fsub:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f16v2sub $a0, $a0, $a2
; CHECK-NEXT:  sort4x16lo $a0, $a0, $a0
; CHECK-NEXT:  {
; CHECK-NEXT:    br $m10
; CHECK-NEXT:    mov     $a1, $a0
; CHECK-NEXT:  }
define <4 x half> @partially_undef_fsub(half %a, half %gap, half %b) {
  %vecinita = insertelement <4 x half> undef, half %a, i32 0
  %vecinitb = insertelement <4 x half> undef, half %b, i32 0
  %sub = fsub <4 x half> %vecinita, %vecinitb
  %res = shufflevector <4 x half> %sub, <4 x half> undef, <4 x i32> zeroinitializer
  ret <4 x half> %res
}

; CHECK-LABEL: partially_undef_fmul:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f16v2mul $a0, $a0, $a2
; CHECK-NEXT:  sort4x16lo $a0, $a0, $a0
; CHECK-NEXT:  {
; CHECK-NEXT:    br $m10
; CHECK-NEXT:    mov     $a1, $a0
; CHECK-NEXT:  }
define <4 x half> @partially_undef_fmul(half %a, half %gap, half %b) {
  %vecinita = insertelement <4 x half> undef, half %a, i32 0
  %vecinitb = insertelement <4 x half> undef, half %b, i32 0
  %mul = fmul <4 x half> %vecinita, %vecinitb
  %res = shufflevector <4 x half> %mul, <4 x half> undef, <4 x i32> zeroinitializer
  ret <4 x half> %res
}
