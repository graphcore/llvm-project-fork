; RUN: llc < %s -march=colossus -mattr=\+supervisor,+ipu1 | FileCheck %s
; RUN: llc < %s -march=colossus -mattr=\+supervisor,+ipu2 | FileCheck %s

; CHECK-LABEL: select_reg:
; CHECK:      and $m0, $m0, 1
; CHECK-NEXT: movnz   $m2, $m0, $m1
; CHECK-NEXT: sort4x16lo $m0, $m2, $m15
; CHECK-NEXT: br $m10
define half @select_reg(i1 %cond, half %t, half %f) {
  %1 = select i1 %cond, half %t, half %f
  ret half %1
}
