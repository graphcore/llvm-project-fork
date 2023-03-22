; RUN: llc < %s -march=colossus -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -march=colossus -mattr=+ipu2 | FileCheck %s

; NOTE: Most CFI-related tests are done in stack frame tests. Other CFI-specific
; tests should be added here.

declare void @dummy()
; CHECK-LABEL: cfi_LR:
; CHECK-NEXT:  .cfi_startproc
; CHECK-NEXT:  # %bb.0:
; CHECK-NEXT:  add $m11, $m11, -8
; CHECK-NEXT:  .cfi_def_cfa_offset 8
; LR was saved at `CFA - 4`.
; CHECK-NEXT:  .cfi_offset $m10, -4
; CHECK-NEXT:  st32 $m10, $m11, $m15, 1
; CHECK:       .cfi_endproc
define void @cfi_LR() {
  call void @dummy()
  ret void
}
