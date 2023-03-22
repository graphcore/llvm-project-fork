; RUN: llc -march=colossus -mattr=+ipu1 < %s | FileCheck %s
; RUN: llc -march=colossus -mattr=+ipu2 < %s | FileCheck %s

; CHECK: setzi $m10, [[label:.Ltmp[0-9]+]]
; CHECK: br $m0
; CHECK: [[label]]:
; CHECK: br $m10
define void @foo(void ()* %bar) nounwind {
  call void %bar()
  ret void
}
