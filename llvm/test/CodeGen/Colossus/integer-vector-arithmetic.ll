; RUN: llc < %s -march=colossus -colossus-coissue=false -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -march=colossus -colossus-coissue=false -mattr=+ipu2 | FileCheck %s


; CHECK-LABEL: v2i16_or:
; CHECK:       # %bb.0:
; CHECK-NEXT:  or $m0, $m0, $m1
; CHECK-NEXT:  br $m10
define <2 x i16> @v2i16_or(<2 x i16> %a, <2 x i16> %b) {
  %1 = or <2 x i16> %a, %b
  ret <2 x i16> %1
}

; CHECK-LABEL: v2i32_or:
; CHECK:       # %bb.0:
; CHECK-DAG:   or $m0, $m0, $m2
; CHECK-DAG:   or $m1, $m1, $m3
; CHECK-NEXT:  br $m10
define <2 x i32> @v2i32_or(<2 x i32> %a, <2 x i32> %b) {
  %1 = or <2 x i32> %a, %b
  ret <2 x i32> %1
}

; CHECK-LABEL: v4i16_or:
; CHECK:       # %bb.0:
; CHECK-DAG:   or $m0, $m0, $m2
; CHECK-DAG:   or $m1, $m1, $m3
; CHECK-NEXT:  br $m10
define <4 x i16> @v4i16_or(<4 x i16> %a, <4 x i16> %b) {
  %1 = or <4 x i16> %a, %b
  ret <4 x i16> %1
}

; CHECK-LABEL: v2i16_and:
; CHECK:       # %bb.0:
; CHECK-NEXT:  and $m0, $m0, $m1
; CHECK-NEXT:  br $m10
define <2 x i16> @v2i16_and(<2 x i16> %a, <2 x i16> %b) {
  %1 = and <2 x i16> %a, %b
  ret <2 x i16> %1
}

; CHECK-LABEL: v2i32_and:
; CHECK:       # %bb.0:
; CHECK-DAG:   and $m0, $m0, $m2
; CHECK-DAG:   and $m1, $m1, $m3
; CHECK-NEXT:  br $m10
define <2 x i32> @v2i32_and(<2 x i32> %a, <2 x i32> %b) {
  %1 = and <2 x i32> %a, %b
  ret <2 x i32> %1
}

; CHECK-LABEL: v4i16_and:
; CHECK:       # %bb.0:
; CHECK-DAG:   and $m0, $m0, $m2
; CHECK-DAG:   and $m1, $m1, $m3
; CHECK-NEXT:  br $m10
define <4 x i16> @v4i16_and(<4 x i16> %a, <4 x i16> %b) {
  %1 = and  <4 x i16> %a, %b
  ret <4 x i16> %1
}

; CHECK-LABEL: v2i16_xor:
; CHECK:       # %bb.0:
; CHECK-NEXT:  xor $m0, $m0, $m1
; CHECK-NEXT:  br $m10
define <2 x i16> @v2i16_xor(<2 x i16> %a, <2 x i16> %b) {
  %1 = xor <2 x i16> %a, %b
  ret <2 x i16> %1
}

; CHECK-LABEL: v2i32_xor:
; CHECK:       # %bb.0:
; CHECK-DAG:   xor $m0, $m0, $m2
; CHECK-DAG:   xor $m1, $m1, $m3
; CHECK-NEXT:  br $m10
define <2 x i32> @v2i32_xor(<2 x i32> %a, <2 x i32> %b) {
  %1 = xor <2 x i32> %a, %b
  ret <2 x i32> %1
}

; CHECK-LABEL: v4i16_xor:
; CHECK:       # %bb.0:
; CHECK-DAG:   xor $m0, $m0, $m2
; CHECK-DAG:   xor $m1, $m1, $m3
; CHECK-NEXT:  br $m10
define <4 x i16> @v4i16_xor(<4 x i16> %a, <4 x i16> %b) {
  %1 = xor  <4 x i16> %a, %b
  ret <4 x i16> %1
}

; CHECK-LABEL: v2i16_not:
; CHECK:       # %bb.0:
; CHECK-NEXT:  xnor $m0, $m0, $m15
; CHECK-NEXT:  br $m10
define <2 x i16> @v2i16_not(<2 x i16> %a) {
  %1 = xor <2 x i16> %a, <i16 -1, i16 -1>
  ret <2 x i16> %1
}

; CHECK-LABEL: v2i32_not:
; CHECK:       # %bb.0:
; CHECK-DAG:   xnor $m0, $m0, $m15
; CHECK-DAG:   xnor $m1, $m1, $m15
; CHECK-NEXT:  br $m10
define <2 x i32> @v2i32_not(<2 x i32> %a) {
  %1 = xor <2 x i32> %a, <i32 -1, i32 -1>
  ret <2 x i32> %1
}

; CHECK-LABEL: v4i16_not:
; CHECK:       # %bb.0:
; CHECK-DAG:   xnor $m0, $m0, $m15
; CHECK-DAG:   xnor $m1, $m1, $m15
; CHECK-NEXT:  br $m10
define <4 x i16> @v4i16_not(<4 x i16> %a) {
  %1 = xor <4 x i16> %a, <i16 -1, i16 -1, i16 -1, i16 -1>
  ret <4 x i16> %1
}
