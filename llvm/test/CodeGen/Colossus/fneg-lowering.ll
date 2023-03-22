; RUN: llc -O3 < %s -mtriple=colossus -mattr=+ipu1 | FileCheck %s
; RUN: llc -O3 < %s -mtriple=colossus -mattr=+ipu2 | FileCheck %s

; CHECK-LABEL: fneg_half4:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4sub $a0:1, $a14:15, $a0:1
; CHECK-NEXT:  }
define <4 x half> @fneg_half4(<4 x half> %a) {
entry:
  %fneg = fneg <4 x half> %a
  ret <4 x half> %fneg
}

; CHECK-LABEL: fneg_half2:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2sub $a0, $a15, $a0
; CHECK-NEXT:  }
define <2 x half> @fneg_half2(<2 x half> %a) {
entry:
  %fneg = fneg <2 x half> %a
  ret <2 x half> %fneg
}

; CHECK-LABEL: fneg_half:
; CHECK:       # %bb.0:
; CHECK-NEXT:  sort4x16lo $a0, $a0, $a0
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2sub $a0, $a15, $a0
; CHECK-NEXT:  }
define half @fneg_half(half %a) {
entry:
  %fneg = fneg half %a
  ret half %fneg
}

; CHECK-LABEL: fneg_float:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f32sub $a0, $a15, $a0
; CHECK-NEXT:  }
define float @fneg_float(float %a) {
entry:
  %fneg = fneg float %a
  ret float %fneg
}

; CHECK-LABEL: fneg_float2:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f32v2sub $a0:1, $a14:15, $a0:1
; CHECK-NEXT:  }
define <2 x float> @fneg_float2(<2 x float> %a) {
entry:
  %fneg = fneg <2 x float> %a
  ret <2 x float> %fneg
}

