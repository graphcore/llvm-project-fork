; RUN: llc < %s -mtriple=colossus -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -mtriple=colossus -mattr=+ipu2 | FileCheck %s

; CHECK: .text
; CHECK: .allow_optimizations
; CHECK: .globl func
; CHECK: func:
define void @func() {
  ret void
}
