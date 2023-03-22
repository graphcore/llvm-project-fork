; RUN: llc < %s -mtriple=colossus -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -mtriple=colossus -mattr=+ipu2 | FileCheck %s

; CHECK-LABEL: test_select_reg:
; CHECK:       shl $m0, $m0, 31
; CHECK:       shrs $m0, $m0, 31
; CHECK:       brnz $m0, [[LABEL:\.L[A-Z0-9_]+]]
; CHECK:       mov $a0, $a1
; CHECK:       [[LABEL]]:
; CHECK-NEXT:  br $m10
define <2 x half> @test_select_reg(i1 %cond, <2 x half> %t, <2 x half> %f) {
  %1 = select i1 %cond, <2 x half> %t, <2 x half> %f
  ret <2 x half> %1
}

; CHECK-LABEL: test_select_reg_true:
; CHECK:       shl $m0, $m0, 31
; CHECK:       shrs $m0, $m0, 31
; CHECK:       brnz $m0, [[LABEL:\.L[A-Z0-9_]+]]
; CHECK:       setzi [[AREG:\$a[0-9]+]], 16384
; CHECK:       or $a0, [[AREG]], 1107296256
; CHECK:       [[LABEL]]:
; CHECK:       br $m10
define <2 x half> @test_select_reg_true(i1 %cond, <2 x half> %t) {
  %tmp = insertelement <2 x half> undef, half 2.0, i32 0
  %local = insertelement <2 x half> %tmp, half 3.0, i32 1
  %1 = select i1 %cond, <2 x half> %t, <2 x half> %local
  ret <2 x half> %1
}

; CHECK-LABEL: test_select_reg_true_regmove:
; CHECK:       {
; CHECK:       shl $m0, $m0, 31
; CHECK:       mov $a0, $a1
; CHECK:       }
; CHECK:       shrs $m0, $m0, 31
; CHECK:       brnz $m0, [[LABEL:\.L[A-Z0-9_]+]]
; CHECK:       setzi [[AREG:\$a[0-9]+]], 16384
; CHECK:       or $a0, [[AREG]], 1107296256
; CHECK:       [[LABEL]]:
; CHECK:       br $m10
define <2 x half> @test_select_reg_true_regmove(i1 %cond, half %ignore, <2 x half> %t) {
  %tmp = insertelement <2 x half> undef, half 2.0, i32 0
  %local = insertelement <2 x half> %tmp, half 3.0, i32 1
  %1 = select i1 %cond, <2 x half> %t, <2 x half> %local
  ret <2 x half> %1
}

; CHECK-LABEL: test_select_reg_false:
; CHECK:       shl $m0, $m0, 31
; CHECK:       shrs $m0, $m0, 31
; CHECK:       brz $m0, [[LABEL:\.L[A-Z0-9_]+]]
; CHECK:       setzi [[AREG:\$a[0-9]+]], 16384
; CHECK:       or $a0, [[AREG]], 1107296256
; CHECK:       [[LABEL]]:
; CHECK:       br $m10
define <2 x half> @test_select_reg_false(i1 %cond, <2 x half> %f) {
  %tmp = insertelement <2 x half> undef, half 2.0, i32 0
  %local = insertelement <2 x half> %tmp, half 3.0, i32 1
  %1 = select i1 %cond, <2 x half> %local, <2 x half> %f
  ret <2 x half> %1
}

; CHECK-LABEL: test_select_reg_false_regmove:
; CHECK:       {
; CHECK:       shl $m0, $m0, 31
; CHECK:       mov $a0, $a1
; CHECK:       }
; CHECK:       shrs $m0, $m0, 31
; CHECK:       brz $m0, [[LABEL:\.L[A-Z0-9_]+]]
; CHECK:       setzi [[AREG:\$a[0-9]+]], 16384
; CHECK:       or $a0, [[AREG]], 1107296256
; CHECK:       [[LABEL]]:
; CHECK:       br $m10
define <2 x half> @test_select_reg_false_regmove(i1 %cond, half %ignore, <2 x half> %f) {
  %tmp = insertelement <2 x half> undef, half 2.0, i32 0
  %local = insertelement <2 x half> %tmp, half 3.0, i32 1
  %1 = select i1 %cond, <2 x half> %local, <2 x half> %f
  ret <2 x half> %1
}
