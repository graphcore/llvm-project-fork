; RUN: llc < %s -mtriple=colossus -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -mtriple=colossus -mattr=+ipu2 | FileCheck %s

; CHECK-LABEL: test_select_reg:
; CHECK:       movnz $m2, $m0, $m1
; CHECK-NEXT:  mov $m0, $m2
; CHECK-NEXT:  br
define <2 x i16> @test_select_reg(i1 %cond, <2 x i16> %t, <2 x i16> %f) {
  %1 = select i1 %cond, <2 x i16> %t, <2 x i16> %f
  ret <2 x i16> %1
}
