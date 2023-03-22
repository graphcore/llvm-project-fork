; RUN: llc < %s -mtriple=colossus -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -mtriple=colossus -mattr=+ipu2 | FileCheck %s

; Regression test for bug T798. Stack spill code was generating ld64 for
; m register which is not supported.

; CHECK-LABEL: foo:
; CHECK:       add $m11, $m11, -16
; CHECK:       st32
; CHECK:       st32
; CHECK:       st32
; CHECK:       call $m10, bar
; CHECK-NOT:   ld64
; CHECK:       call $m10, bar
; CHECK:       ld32
; CHECK:       ld32
; CHECK:       ld32
; CHECK:       add $m11, $m11, 16
; CHECK:       br
define void @foo(<4 x i16> %x) {
  call void @bar(<4 x i16> %x)
  call void @bar(<4 x i16> %x)
  ret void
}

declare void @bar(<4 x i16>)
