; RUN: llc < %s -mattr=+ipu1 -march=colossus -colossus-coissue=false -stack-size-section -function-sections | FileCheck %s
; RUN: llc < %s -mattr=+ipu2 -march=colossus -colossus-coissue=false -stack-size-section -function-sections | FileCheck %s

; CHECK: .section .text.foo,"ax",@progbits
; CHECK: .section .stack_sizes
; CHECK: .section .text.bar,"ax",@progbits
; CHECK: .section .stack_sizes

define i32 @foo(i32 %x, i32 %y) {
  %1 = add i32 %x, %y
  ret i32 %1
}

define <2 x i32> @bar(<2 x i32> %x, <2 x i32> %y) {
  %1 = add <2 x i32> %x, %y
  ret <2 x i32> %1
}
