; RUN: llc < %s -march=colossus -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -march=colossus -mattr=+ipu2 | FileCheck %s

declare void @g()
declare i8* @llvm.stacksave() nounwind
declare void @llvm.stackrestore(i8*) nounwind

; CHECK-LABEL: foo:
; CHECK:       add $m11, $m11, -16
; CHECK:       st32 $m9, $m11, $m15, [[FPSpill:[0-9]+]]
; Set the FP from the SP.
; CHECK:       mov $m9, $m11
; CHECK-DAG:   st32 $m10, $m9, $m15, [[LRSpill:[0-9]+]]
; CHECK-DAG:   st32 $m7, $m9, $m15, [[M7Spill:[0-9]+]]
; ### Scale size to bytes & round down to 8-bytes.
; CHECK-NEXT:  mov $m7, $m11
; CHECK-DAG:   shl $m1, $m1, 2
; CHECK-DAG:   add $m1, $m1, 7
; CHECK-DAG:   andc $m1, $m1, 7
; ### Extend the stack.
; CHECK:       sub $m1, $m11, $m1
; CHECK:       mov $m11, $m1
; ### Do the store.
; CHECK:       st32 $m1, $m0, $m15, 0
; ### Do the call.
; CHECK:       call $m10, g
; CHECK-NEXT:  mov $m11, $m7
; CHECK-DAG:   ld32 $m10, $m9, $m15, [[LRSpill]]
; CHECK-DAG:   ld32 $m7, $m9, $m15, [[M7Spill]]
; ### Restore SP.
; CHECK:       add $m11, $m9, 16
; ### Restore FP
; CHECK:      ld32 $m9, $m9, $m15, [[FPSpill]]
; CHECK:      br $m10
define void @foo(i32** %p, i32 %size) {
  %1 = call i8* @llvm.stacksave()
  %a = alloca i32, i32 %size
  store i32* %a, i32** %p
  call void @g()
  call void @llvm.stackrestore(i8* %1)
  ret void
}
