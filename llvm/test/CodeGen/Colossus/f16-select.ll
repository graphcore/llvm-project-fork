; RUN: llc < %s -march=colossus -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -march=colossus -mattr=+ipu2 | FileCheck %s

; Test lowering of SELECT_F16 pseudo with custom inserter.
; This could be optimised by eliminating the and

; CHECK-LABEL: select_reg:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shl $m0, $m0, 31
; CHECK-NEXT:  shrs $m0, $m0, 31
; CHECK-NEXT:  brnz $m0, [[LABELA:\.L[A-Z0-9_]+]]
; CHECK-NEXT:  # %bb.1:
; CHECK-NEXT:  mov $a0, $a1
; CHECK-NEXT:  [[LABELA]]:
; CHECK-NEXT:  br $m10
define half @select_reg(i1 %cond, half %t, half %f) {
  %1 = select i1 %cond, half %t, half %f
  ret half %1
}
