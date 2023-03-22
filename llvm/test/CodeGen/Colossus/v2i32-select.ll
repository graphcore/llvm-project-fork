; RUN: llc < %s -mtriple=colossus -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -mtriple=colossus -mattr=+ipu2 | FileCheck %s

; CHECK-LABEL: test_select_reg:
; CHECK:       mov $m1, $m0
; Load %f from stack
; CHECK-DAG:   ld32 $m0, $m11, $m15, 0
; CHECK-DAG:   ld32 $m1, $m11, $m15, 1
; CHECK-DAG:   and $m4, $m1, 1
; CHECK-NOT:   break-check-dag-groups
; CHECK-DAG:   movnz $m1, $m4, $m3
; CHECK-DAG:   movnz $m0, $m4, $m2
; CHECK-NEXT:  br
define <2 x i32> @test_select_reg(i1 %cond, <2 x i32> %t, <2 x i32> %f) {
  %1 = select i1 %cond, <2 x i32> %t, <2 x i32> %f
  ret <2 x i32> %1
}

; CHECK-LABEL: test_select_reg_true:
; CHECK:       mov $m1, $m0
; CHECK-DAG:   and $m4, $m1, 1
; CHECK-DAG:   setzi $m0, 42
; CHECK-DAG:   setzi $m1, 81
; CHECK-NOT:   break-check-dag-groups
; CHECK-DAG:   movnz $m1, $m4, $m3
; CHECK-DAG:   movnz $m0, $m4, $m2
; CHECK-NEXT:  br
define <2 x i32> @test_select_reg_true(i1 %cond, <2 x i32> %t) {
  %tmp = insertelement <2 x i32> undef, i32 42, i32 0
  %local = insertelement <2 x i32> %tmp, i32 81, i32 1
  %1 = select i1 %cond, <2 x i32> %t, <2 x i32> %local
  ret <2 x i32> %1
}

; CHECK-LABEL: test_select_reg_false:
; CHECK-DAG:   setzi [[REGM0:\$m[0-9]+]], 42
; CHECK-DAG:   setzi [[REGM1:\$m[0-9]+]], 81
; CHECK-DAG:   and [[REGCOND:\$m[0-9]+]], $m0, 1
; CHECK-NOT:   break-check-dag-groups
; CHECK-DAG:   movnz [[REGM2:\$m[0-9]+]], [[REGCOND]], [[REGM1]]
; CHECK-DAG:   movnz [[REGM3:\$m[0-9]+]], [[REGCOND]], [[REGM0]]
; CHECK-NOT:   break-check-dag-groups
; CHECK-DAG:   mov $m0, [[REGM3]]
; CHECK-DAG:   mov $m1, [[REGM2]]
; CHECK-NEXT:  br
define <2 x i32> @test_select_reg_false(i1 %cond, <2 x i32> %f) {
  %tmp = insertelement <2 x i32> undef, i32 42, i32 0
  %local = insertelement <2 x i32> %tmp, i32 81, i32 1
  %1 = select i1 %cond, <2 x i32> %local, <2 x i32> %f
  ret <2 x i32> %1
}
