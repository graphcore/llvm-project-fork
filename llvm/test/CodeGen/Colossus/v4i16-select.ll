; RUN: llc < %s -mtriple=colossus -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -mtriple=colossus -mattr=+ipu2 | FileCheck %s

; CHECK-LABEL: test_select_reg:
; CHECK-DAG:   mov $m1, $m0
; CHECK-DAG:   ld32 $m1, $m11, $m15, 1
; CHECK-DAG:   ld32 $m0, $m11, $m15, 0
; CHECK-DAG:   and $m4, $m1, 1
; CHECK-DAG:   movnz $m1, $m4, $m3
; CHECK-DAG:   movnz $m0, $m4, $m2
; CHECK-NEXT:  br
define <4 x i16> @test_select_reg(i1 %cond, <4 x i16> %t, <4 x i16> %f) {
  %1 = select i1 %cond, <4 x i16> %t, <4 x i16> %f
  ret <4 x i16> %1
}
