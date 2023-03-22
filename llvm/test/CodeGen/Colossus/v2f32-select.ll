; RUN: llc < %s -mtriple=colossus -colossus-coissue=false -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -mtriple=colossus -colossus-coissue=false -mattr=+ipu2 | FileCheck %s



; CHECK-LABEL: test_select_reg:
; CHECK:       shl $m0, $m0, 31
; CHECK:       shrs $m0, $m0, 31
; CHECK:       brnz $m0, [[LABEL:\.L[A-Z0-9_]+]]
; CHECK:       mov $a0:1, $a2:3
; CHECK:       [[LABEL]]:
; CHECK-NEXT:  br
define <2 x float> @test_select_reg(i1 %cond, <2 x float> %t, <2 x float> %f) {
  %1 = select i1 %cond, <2 x float> %t, <2 x float> %f
  ret <2 x float> %1
}

; CHECK-LABEL: test_select_reg_true:
; CHECK:       shl $m0, $m0, 31
; CHECK:       shrs $m0, $m0, 31
; CHECK:       brnz $m0, [[LABEL:\.L[A-Z0-9_]+]]
; Construct local directly into return registers
; CHECK:       or $a0, $a15, 1073741824
; CHECK:       or $a1, $a15, 1077936128
; CHECK:       [[LABEL]]:
; CHECK-NEXT:  br
define <2 x float> @test_select_reg_true(i1 %cond, <2 x float> %t) {
  %tmp = insertelement <2 x float> undef, float 2.0, i32 0
  %local = insertelement <2 x float> %tmp, float 3.0, i32 1
  %1 = select i1 %cond, <2 x float> %t, <2 x float> %local
  ret <2 x float> %1
}

; CHECK-LABEL: test_select_reg_true_regmove:
; CHECK:       shl $m0, $m0, 31
; CHECK:       shrs $m0, $m0, 31
; CHECK:       brnz $m0, [[LABEL:\.L[A-Z0-9_]+]]
; CHECK:       or $a0, $a15, 1073741824
; CHECK:       or $a1, $a15, 1077936128
; CHECK:       [[LABEL]]:
; CHECK-NEXT:  br $m10
define <2 x float> @test_select_reg_true_regmove(i1 %cond, float %ignore, <2 x float> %t) {
  %tmp = insertelement <2 x float> undef, float 2.0, i32 0
  %local = insertelement <2 x float> %tmp, float 3.0, i32 1
  %1 = select i1 %cond, <2 x float> %t, <2 x float> %local
  ret <2 x float> %1
}

; CHECK-LABEL: test_select_reg_false:
; CHECK:       shl $m0, $m0, 31
; CHECK:       shrs $m0, $m0, 31
; CHECK:       brz $m0, [[LABEL:\.L[A-Z0-9_]+]]
; Construct local directly into return registers
; CHECK:       or $a0, $a15, 1073741824
; CHECK:       or $a1, $a15, 1077936128
; CHECK:       [[LABEL]]:
; CHECK-NEXT:  br
define <2 x float> @test_select_reg_false(i1 %cond, <2 x float> %f) {
  %tmp = insertelement <2 x float> undef, float 2.0, i32 0
  %local = insertelement <2 x float> %tmp, float 3.0, i32 1
  %1 = select i1 %cond, <2 x float> %local, <2 x float> %f
  ret <2 x float> %1
}

; CHECK-LABEL: test_select_reg_false_regmove:
; CHECK:       shl $m0, $m0, 31
; CHECK:       shrs $m0, $m0, 31
; CHECK:       brz $m0, [[LABEL:\.L[A-Z0-9_]+]]
; Construct local directly into input vector's registers
; CHECK:       or $a0, $a15, 1073741824
; CHECK:       or $a1, $a15, 1077936128
; CHECK:       [[LABEL]]:
; Copy into output registers
; CHECK-NEXT:  br
define <2 x float> @test_select_reg_false_regmove(i1 %cond, float %ignore, <2 x float> %f) {
  %tmp = insertelement <2 x float> undef, float 2.0, i32 0
  %local = insertelement <2 x float> %tmp, float 3.0, i32 1
  %1 = select i1 %cond, <2 x float> %local, <2 x float> %f
  ret <2 x float> %1
}
