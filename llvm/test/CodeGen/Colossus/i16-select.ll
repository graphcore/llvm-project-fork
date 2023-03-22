; RUN: llc < %s -march=colossus -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -march=colossus -mattr=+ipu2 | FileCheck %s

; CHECK-LABEL: select_reg:
; CHECK:       and [[REGA:\$m[0-9]+]], $m0, 1
; CHECK-NEXT:  movnz [[REGB:\$m[0-9]+]], [[REGA]], $m1
; CHECK-NEXT:  mov $m0, [[REGB]]
; CHECK-NEXT:  br
define i16 @select_reg(i1 %cond, i16 %t, i16 %f) {
  %1 = select i1 %cond, i16 %t, i16 %f
  ret i16 %1
}
