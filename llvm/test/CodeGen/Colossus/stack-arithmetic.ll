; RUN: llc < %s -march=colossus -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -march=colossus -mattr=+ipu2 | FileCheck %s

declare void @sink(i32)
declare void @sinkptr(i8*)

; Base case - no stack alignment, no variable size stack objects
; CHECK-LABEL: return_0_stack_arg:
; CHECK:       # %bb.0:
; CHECK-NEXT:  ld32 $m0, $m11, $m15, 0
; CHECK:       br $m10
define i32 @return_0_stack_arg(i32 %r0, i32 %r1, i32 %r2, i32 %r3,
                               i32 %s0, i32 %s1) {
 ret i32 %s0
}

; CHECK-LABEL: return_1_stack_arg:
; CHECK:       # %bb.0:
; CHECK-NEXT:  ld32 $m0, $m11, $m15, 1
; CHECK:       br $m10
define i32 @return_1_stack_arg(i32 %r0, i32 %r1, i32 %r2, i32 %r3,
                               i32 %s0, i32 %s1) {
 ret i32 %s1
}

; Check the stack alignment is applied, even when the stack size is zero
; TargetRegisterInfo::needsStackRealignment is very explicit about this:
; "if hasFnAttribute("stackrealign") || requiresRealignment"
; CHECK-LABEL: return_0_aligned_stack_arg:
; CHECK:       # %bb.0:
; CHECK-NEXT:  ld32 $m0, $m11, $m15, 0
; CHECK:       br $m10
define i32 @return_0_aligned_stack_arg(i32 %r0, i32 %r1, i32 %r2, i32 %r3,
                                       i32 %s0, i32 %s1) #32 {
 ret i32 %s0
}

; CHECK-LABEL: return_1_aligned_stack_arg:
; CHECK:       # %bb.0:
; CHECK-NEXT:  ld32 $m0, $m11, $m15, 1
; CHECK:       br $m10
define i32 @return_1_aligned_stack_arg(i32 %r0, i32 %r1, i32 %r2, i32 %r3,
                                       i32 %s0, i32 %s1) #32 {
 ret i32 %s1
}

; CHECK-LABEL: sink_0_stack_arg:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m10, $m11, $m15, 1
; CHECK-NEXT:  ld32 $m0, $m11, $m15, 2
; CHECK-NEXT:  call $m10, sink
; CHECK-NEXT:  ld32 $m10, $m11, $m15, 1
; CHECK:       add $m11, $m11, 8
; CHECK:       br $m10
define void @sink_0_stack_arg(i32 %r0, i32 %r1, i32 %r2, i32 %r3,
                              i32 %s0, i32 %s1) {
 call void @sink(i32 %s0)
 ret void
}

; CHECK-LABEL: sink_1_stack_arg:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m10, $m11, $m15, 1
; CHECK-NEXT:  ld32 $m0, $m11, $m15, 3
; CHECK-NEXT:  call $m10, sink
; CHECK-NEXT:  ld32 $m10, $m11, $m15, 1
; CHECK:       add $m11, $m11, 8
; CHECK:       br $m10
define void @sink_1_stack_arg(i32 %r0, i32 %r1, i32 %r2, i32 %r3,
                              i32 %s0, i32 %s1) {
 call void @sink(i32 %s1)
 ret void
}

; CHECK-LABEL: sink_0_aligned_stack_arg:
; CHECK:       # %bb.0:
; CHECK-NEXT:  add $m11, $m11, -8
; CHECK-NEXT:  st32 $m8, $m11, $m15, 0
; CHECK-NEXT:  add $m8, $m11, 8
; CHECK-NEXT:  add $m11, $m11, -32
; CHECK-NEXT:  andc $m11, $m11, 31
; CHECK:       st32 $m10, $m11, $m15, [[LRSpill:[0-9]+]]
; CHECK-NEXT:  ld32 $m0, $m8, $m15, 0
; CHECK-NEXT:  call $m10, sink
; CHECK-NEXT:  ld32 $m10, $m11, $m15, [[LRSpill]]
; CHECK-NEXT:  mov $m11, $m8
; CHECK:       add $m8, $m8, -8
; CHECK:       ld32 $m8, $m8, $m15, 0
; CHECK:       br $m10
define void @sink_0_aligned_stack_arg(i32 %r0, i32 %r1, i32 %r2, i32 %r3,
                                      i32 %s0, i32 %s1) #32 {
 call void @sink(i32 %s0)
 ret void
}

; CHECK-LABEL: sink_1_aligned_stack_arg:
; CHECK:       # %bb.0:
; CHECK-NEXT:  add $m11, $m11, -8
; CHECK-NEXT:  st32 $m8, $m11, $m15, 0
; CHECK-NEXT:  add $m8, $m11, 8
; CHECK-NEXT:  add $m11, $m11, -32
; CHECK-NEXT:  andc $m11, $m11, 31
; CHECK:       st32 $m10, $m11, $m15, [[LRSpill:[0-9]+]]
; CHECK-NEXT:  ld32 $m0, $m8, $m15, 1
; CHECK-NEXT:  call $m10, sink
; CHECK-NEXT:  ld32 $m10, $m11, $m15, [[LRSpill]]
; CHECK-NEXT:  mov $m11, $m8
; CHECK:       add $m8, $m8, -8
; CHECK:       ld32 $m8, $m8, $m15, 0
; CHECK:       br $m10
define void @sink_1_aligned_stack_arg(i32 %r0, i32 %r1, i32 %r2, i32 %r3,
                                      i32 %s0, i32 %s1) #32 {
 call void @sink(i32 %s1)
 ret void
}

; CHECK-LABEL: sink_0_alloc:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m9, $m11, $m15, 0
; CHECK:       mov $m9, $m11
; CHECK:       st32 $m10, $m9, $m15, 1
; CHECK-NEXT:  ld32 $m0, $m9, $m15, 2
; CHECK-NEXT:  add $m0, $m0, 7
; CHECK-NEXT:  andc $m0, $m0, 7
; CHECK-NEXT:  sub $m0, $m11, $m0
; CHECK-NEXT:  mov $m11, $m0
; CHECK-NEXT:  call $m10, sinkptr
; CHECK-NEXT:  ld32 $m10, $m9, $m15, 1
; CHECK-NEXT:  add $m11, $m9, 8
; CHECK-NEXT:  ld32 $m9, $m9, $m15, 0
; CHECK:       br $m10
define void @sink_0_alloc(i32 %r0, i32 %r1, i32 %r2, i32 %r3,
                          i32 %s0, i32 %s1) {
  %p = alloca i8, i32 %s0, align 8
  call void @sinkptr(i8* nonnull %p)
  ret void
}

; CHECK-LABEL: sink_1_alloc:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m9, $m11, $m15, 0
; CHECK:       mov $m9, $m11
; CHECK:       st32 $m10, $m9, $m15, 1
; CHECK-NEXT:  ld32 $m0, $m9, $m15, 3
; CHECK-NEXT:  add $m0, $m0, 7
; CHECK-NEXT:  andc $m0, $m0, 7
; CHECK-NEXT:  sub $m0, $m11, $m0
; CHECK-NEXT:  mov $m11, $m0
; CHECK-NEXT:  call $m10, sinkptr
; CHECK-NEXT:  ld32 $m10, $m9, $m15, 1
; CHECK-NEXT:  add $m11, $m9, 8
; CHECK-NEXT:  ld32 $m9, $m9, $m15, 0
; CHECK:       br $m10
define void @sink_1_alloc(i32 %r0, i32 %r1, i32 %r2, i32 %r3,
                          i32 %s0, i32 %s1) {
  %p = alloca i8, i32 %s1, align 8
  call void @sinkptr(i8* nonnull %p)
  ret void
}

; CHECK-LABEL: sink_0_aligned_alloc:
; CHECK:       # %bb.0:
; CHECK-NEXT:  add $m11, $m11, -8
; CHECK-NEXT:  st32 $m8, $m11, $m15, 0
; CHECK-NEXT:  add $m8, $m11, 8
; CHECK-NEXT:  add $m11, $m11, -32
; CHECK-NEXT:  andc $m11, $m11, 31
; CHECK-NEXT:  st32 $m9, $m11, $m15, [[LRSpill:[0-9]+]]
; CHECK-NEXT:  mov $m9, $m11
; CHECK:       st32 $m10, $m9, $m15, 7
; CHECK-NEXT:  ld32 $m0, $m8, $m15, 0
; CHECK-NEXT:  add $m0, $m0, 7
; CHECK-NEXT:  andc $m0, $m0, 7
; CHECK-NEXT:  sub $m0, $m11, $m0
; CHECK-NEXT:  andc $m0, $m0, 31
; CHECK-NEXT:  mov $m11, $m0
; CHECK-NEXT:  call $m10, sinkptr
; CHECK-NEXT:  ld32 $m10, $m9, $m15, 7
; CHECK-NEXT:  mov $m11, $m8
; CHECK-NEXT:  ld32 $m9, $m9, $m15, [[LRSpill]]
; CHECK:       add $m8, $m8, -8
; CHECK:       ld32 $m8, $m8, $m15, 0
; CHECK:       br $m10
define void @sink_0_aligned_alloc(i32 %r0, i32 %r1, i32 %r2, i32 %r3,
                                  i32 %s0, i32 %s1) {
  %p = alloca i8, i32 %s0, align 32
  call void @sinkptr(i8* nonnull %p)
  ret void
}

; CHECK-LABEL: sink_1_aligned_alloc:
; CHECK:       # %bb.0:
; CHECK-NEXT:  add $m11, $m11, -8
; CHECK-NEXT:  st32 $m8, $m11, $m15, 0
; CHECK-NEXT:  add $m8, $m11, 8
; CHECK-NEXT:  add $m11, $m11, -32
; CHECK-NEXT:  andc $m11, $m11, 31
; CHECK-NEXT:  st32 $m9, $m11, $m15, [[LRSpill:[0-9]+]]
; CHECK-NEXT:  mov $m9, $m11
; CHECK:       st32 $m10, $m9, $m15, 7
; CHECK-NEXT:  ld32 $m0, $m8, $m15, 1
; CHECK-NEXT:  add $m0, $m0, 7
; CHECK-NEXT:  andc $m0, $m0, 7
; CHECK-NEXT:  sub $m0, $m11, $m0
; CHECK-NEXT:  andc $m0, $m0, 31
; CHECK-NEXT:  mov $m11, $m0
; CHECK-NEXT:  call $m10, sinkptr
; CHECK-NEXT:  ld32 $m10, $m9, $m15, 7
; CHECK-NEXT:  mov $m11, $m8
; CHECK-NEXT:  ld32 $m9, $m9, $m15, [[LRSpill]]
; CHECK:       add $m8, $m8, -8
; CHECK:       ld32 $m8, $m8, $m15, 0
; CHECK:       br $m10
define void @sink_1_aligned_alloc(i32 %r0, i32 %r1, i32 %r2, i32 %r3,
                                  i32 %s0, i32 %s1) {
  %p = alloca i8, i32 %s1, align 32
  call void @sinkptr(i8* nonnull %p)
  ret void
}

attributes #32 = {alignstack=32}
