; RUN: llc < %s -mtriple=colossus -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -mtriple=colossus -mattr=+ipu2 | FileCheck %s

;divideWork:                             # @divideWork
;# %bb.0:
; CHECK: shr $m0, $m0, $m1
; CHECK: sub $m0, $m0, $m2
; CHECK: setzi $m1, 43691
; CHECK: mul $m0, $m0, $m1
; CHECK: setzi $m1, 218455
; CHECK: add $m0, $m0, $m1
; CHECK: shr $m0, $m0, 18
; CHECK: br $m10

define dso_local i32 @divideWork(i32 %0, i32 %1, i32 %2) {
  %4 = lshr i32 %0, %1
  %5 = add i32 %4, 5
  %6 = sub i32 %5, %2
  %7 = mul i32 %6, 43691
  %8 = lshr i32 %7, 18
  ret i32 %8
}
