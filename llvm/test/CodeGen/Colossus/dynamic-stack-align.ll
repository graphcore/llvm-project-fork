; RUN: llc < %s -march=colossus -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -march=colossus -mattr=+ipu2 | FileCheck %s

declare void @sink(i8*)

; Realign, but no variable sized objects

; CHECK-LABEL: stack_align_greater_than_frame_align:
; CHECK:       # %bb.0:
; Spill BP
; CHECK-NEXT:  add $m11, $m11, -8
; CHECK-NEXT:  st32 $m8, $m11, $m15, 0
; CHECK-NEXT:  add $m8, $m11, 8
; Set up frame
; CHECK-NEXT:  add $m11, $m11, -32
; CHECK-NEXT:  andc $m11, $m11, 31
; CHECK:       st32 $m10, $m11, $m15, [[LRSpill:[0-9]+]]
; CHECK-NEXT:  add $m0, $m11, 16
; CHECK-NEXT:  call $m10, sink
; CHECK-NEXT:  ld32 $m10, $m11, $m15, [[LRSpill]]
; CHECK-NEXT:  mov $m11, $m8
; Restore BP
; CHECK-NEXT:  add $m8, $m8, -8
; CHECK:       ld32 $m8, $m8, $m15, 0
; CHECK:       br $m10
define void @stack_align_greater_than_frame_align() #32
{
 %a = alloca i8, i32 4, align 16
 call void @sink(i8* %a)
 ret void
}

; CHECK-LABEL: frame_align_greater_than_stack_align:
; CHECK:       # %bb.0:
; Spill BP
; CHECK-NEXT:  add $m11, $m11, -8
; CHECK-NEXT:  st32 $m8, $m11, $m15, 0
; CHECK-NEXT:  add $m8, $m11, 8
; Set up frame
; CHECK-NEXT:  add $m11, $m11, -64
; CHECK-NEXT:  andc $m11, $m11, 31
; CHECK:       st32 $m10, $m11, $m15, [[LRSpill:[0-9]+]]
; CHECK-NEXT:  add $m0, $m11, 32
; CHECK-NEXT:  call $m10, sink
; CHECK-NEXT:  ld32 $m10, $m11, $m15, [[LRSpill]]
; CHECK-NEXT:  mov $m11, $m8
; Restore BP
; CHECK-NEXT:  add $m8, $m8, -8
; CHECK:       ld32 $m8, $m8, $m15, 0
; CHECK:       br $m10
define void @frame_align_greater_than_stack_align() #16
{
 %a = alloca i8, i32 4, align 32
 call void @sink(i8* %a)
 ret void
}

attributes #16 = {alignstack=16}
attributes #32 = {alignstack=32}
