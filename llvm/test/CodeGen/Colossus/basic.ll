; RUN: llc < %s -march=colossus -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -march=colossus -mattr=+ipu2 | FileCheck %s
; RUN: llc < %s -march=colossus -mattr=+supervisor,+ipu1 | \
; RUN: FileCheck %s --check-prefix=CHECK-SUPERVISOR
; RUN: llc < %s -march=colossus -mattr=+supervisor,+ipu2 | \
; RUN: FileCheck %s --check-prefix=CHECK-SUPERVISOR

; CHECK-LABEL: f:
; CHECK:      mov $m0, $m15
; CHECK-NEXT: br $m10
; CHECK-SUPERVISOR:      mov $m0, $m15
; CHECK-NEXT-SUPERVISOR: br $m10
define i32 @f() {
  ret i32 0
}

; CHECK-LABEL: g:
; CHECK:      {
; CHECK-NEXT: br $m10
; CHECK-NEXT: mov $a0, $a15
; CHECK:      }
; CHECK-SUPERVISOR:      mov $m0, $m15
; CHECK-NEXT-SUPERVISOR: br $m10
define float @g() {
  ret float 0.0
}
