; RUN: llc < %s -march=colossus -mattr=+ipu1 -verify-machineinstrs | FileCheck %s
; RUN: llc < %s -march=colossus -mattr=+ipu2 -verify-machineinstrs | FileCheck %s

; CHECK-LABEL: stack_frame_of_signed_sixteen_bits:
; CHECK:       # %bb
; CHECK:       add $m11, $m11, -32768
; CHECK:       add $m11, $m11, 32768
; CHECK:       br $m10
define void @stack_frame_of_signed_sixteen_bits() {
  %1 = alloca [8192 x i32], align 4
  ret void
}

; CHECK-LABEL: stack_frame_of_unsigned_sixteen_bits:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $m6, 32776
; CHECK-NEXT:  sub $m11, $m11, $m6
; CHECK:       add $m11, $m11, 32776
; CHECK:       br $m10
define void @stack_frame_of_unsigned_sixteen_bits() {
  %1 = alloca [8193 x i32], align 4
  ret void
}

; CHECK-LABEL: stack_frame_of_seventeen_bits:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $m6, 65536
; CHECK-NEXT:  sub $m11, $m11, $m6
; CHECK:       setzi $m6, 65536
; CHECK-NEXT:  add $m11, $m11, $m6
; CHECK:       br $m10
define void @stack_frame_of_seventeen_bits() {
  %1 = alloca [16384 x i32], align 4
  ret void
}

; CHECK-LABEL: small_stack_frame_with_dynamic_size:
; CHECK:       # %bb
; CHECK-NEXT:  add $m11, $m11, -8
; CHECK-NEXT:  st32 $m9, $m11, $m15, 1
; CHECK-NEXT:  mov $m9, $m11
; CHECK:       shl $m0, $m0, 3
; CHECK-NEXT:  sub $m11, $m11, $m0
; CHECK-NEXT:  add $m11, $m9, 8
; CHECK:       ld32 $m9, $m9, $m15, 1
; CHECK:       br $m10
define void @small_stack_frame_with_dynamic_size(i32 %n)
{
  %n8 = mul i32 %n, 2
  %d = alloca i32, i32 %n8
  ret void
}

; CHECK-LABEL: large_stack_frame_with_dynamic_size:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $m6, 65544
; CHECK-NEXT:  sub $m11, $m11, $m6
; CHECK-NEXT:  st32 $m9, $m11, $m15, 1
; CHECK-NEXT:  mov $m9, $m11
; CHECK:       shl $m0, $m0, 3
; CHECK-NEXT:  sub $m11, $m11, $m0
; CHECK-NEXT:  setzi $m6, 65544
; CHECK-NEXT:  add $m11, $m9, $m6
; CHECK:       ld32 $m9, $m9, $m15, 1
; CHECK:       br $m10
define void @large_stack_frame_with_dynamic_size(i32 %n)
{
  %s = alloca [16384 x i32], align 4
  %n8 = mul i32 %n, 2
  %d = alloca i32, i32 %n8
  ret void
}

; CHECK-LABEL: stack_frame_aligned_twelve_bits:
; CHECK:       # %bb
; CHECK-NEXT:  add $m11, $m11, -8
; CHECK-NEXT:  st32 $m8, $m11, $m15, 0
; CHECK-NEXT:  add $m8, $m11, 8
; CHECK-NEXT:  add $m11, $m11, -4096
; CHECK-NEXT:  andc $m11, $m11, 4095
; CHECK:       mov $m11, $m8
; CHECK-NEXT:  add $m8, $m8, -8
; CHECK:       ld32 $m8, $m8, $m15, 0
; CHECK:       br $m10
define void @stack_frame_aligned_twelve_bits() {
  %1 = alloca i32, align 4096
  ret void
}

; CHECK-LABEL: stack_frame_aligned_thirteen_bits:
; CHECK:       # %bb
; CHECK-NEXT:  add $m11, $m11, -8
; CHECK-NEXT:  st32 $m8, $m11, $m15, 0
; CHECK-NEXT:  add $m8, $m11, 8
; CHECK-NEXT:  add $m11, $m11, -8192
; CHECK-NEXT:  setzi $m6, 8191
; CHECK-NEXT:  andc $m11, $m11, $m6
; CHECK:       mov $m11, $m8
; CHECK-NEXT:  add $m8, $m8, -8
; CHECK:       ld32 $m8, $m8, $m15, 0
; CHECK:       br $m10
define void @stack_frame_aligned_thirteen_bits() {
  %1 = alloca i32, align 8192
  ret void
}
