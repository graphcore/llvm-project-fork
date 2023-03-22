; RUN: llc < %s -march=colossus -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -march=colossus -mattr=+ipu2 | FileCheck %s

declare void @llvm.va_start(i8*) nounwind
declare void @llvm.va_end(i8*) nounwind
declare void @f8(i8) nounwind
declare void @f16(i16) nounwind
declare void @f32(i32) nounwind
declare void @f64(i64) nounwind

; CHECK-LABEL: va_callee:
; CHECK:       add $m11, $m11, -8
; va_start
; CHECK:       st32 $m10, $m11, $m15, 0
; CHECK:       add $m1, $m11, 8
; va_arg i8
; CHECK:       ld32 $m0, $m11, $m15, 2
; CHECK:       or $m1, $m1, 4
; CHECK:       call $m10, f8
; va_arg i16
; CHECK:       ld32 $m0, $m11, $m15, 1
; CHECK:       add $m1, $m0, 4
; CHECK:       st32 $m1, $m11, $m15, 1
; CHECK:       ld32 $m0, $m0, $m15, 0
; CHECK:       call $m10, f16
; va_arg i32
; CHECK:       ld32 $m0, $m11, $m15, 1
; CHECK:       add $m1, $m0, 4
; CHECK:       st32 $m1, $m11, $m15, 1
; CHECK:       ld32 $m0, $m0, $m15, 0
; CHECK:       call $m10, f32
; va_arg i64
; CHECK:       ld32 $m1, $m11, $m15, 1
; CHECK:       add $m0, $m1, 4
; CHECK:       st32 $m0, $m11, $m15, 1
; CHECK:       mov $m2, $m1
; CHECK:       ld32step $m0, $m15, $m2+=, 2
; CHECK:       st32 $m2, $m11, $m15, 1
; CHECK:       ld32 $m1, $m1, $m15, 1
; CHECK:       call $m10, f64
define void @va_callee(...) nounwind {

  %ptr1 = alloca i8*, align 4
  %ptr2 = bitcast i8** %ptr1 to i8*
  call void @llvm.va_start(i8* %ptr2)

  %1 = va_arg i8** %ptr1, i8
  call void @f8(i8 %1)

  %2 = va_arg i8** %ptr1, i16
  call void @f16(i16 %2)

  %3 = va_arg i8** %ptr1, i32
  call void @f32(i32 %3)

  %4 = va_arg i8** %ptr1, i64
  call void @f64(i64 %4)

  call void @llvm.va_end(i8* %ptr2)
  ret void
}

; CHECK-LABEL: va_caller:
; Stack args.
; CHECK:       st32 $m10, $m11, $m15, 5
; CHECK:       setzi $a0, 4
; CHECK:       st32 $a0, $m11, $m15, 4
; CHECK:       setzi $a0, 3
; CHECK:       st32 $a0, $m11, $m15, 3
; CHECK:       setzi $a0, 2
; CHECK:       st32 $a0, $m11, $m15, 2
; CHECK:       setzi $a0, 1
; CHECK:       st32 $a0, $m11, $m15, 1
; CHECK:       st32 $a15, $m11, $m15, 0
; CHECK:       call $m10, va_callee
define void @va_caller() nounwind {
  call void (...) @va_callee(i32 0, i32 1, i32 2, i32 3, i32 4)
  ret void
}
