; RUN: llc < %s -mtriple=colossus -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -mtriple=colossus -mattr=+ipu2 | FileCheck %s

; CHECK-LABEL: test_ld_r_i64:
; CHECK:       ld32 $m2, $m0, $m15, 0
; CHECK-NEXT:  ld32 $m1, $m0, $m15, 1
; CHECK-NEXT:  mov $m0, $m2
; CHECK-NEXT:  br $m10
define i64 @test_ld_r_i64(i64* %ptr) {
  %res = load i64, i64* %ptr, align 8
  ret i64 %res
}
