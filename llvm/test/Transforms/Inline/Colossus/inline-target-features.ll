; RUN: opt -mtriple=colossus -inline -S < %s | FileCheck %s

; Check that functions are inlined regardless of target features
; Unless the caller is either both or supervisor execution mode
; and the callee is in worker mode due to potential of float types

define i32 @func_worker() #0 {
  ret i32 0
}

define i32 @func_supervisor() #1 {
  ret i32 1
}

define i32 @func_both() #2 {
  ret i32 2
}

define float @float_return() #0 {
  ret float 0.000000e+00
}

define void @float_args(float* %a) #0 {
  %1 = load float, float* %a
  %add = fadd float %1, 1.000000e+00
  store float %add, float* %a
  ret void
}

@a = external global float

define void @float_ops() #0 {
   %1 = load float, float* @a
  %add = fadd float %1, 1.000000e+00
  store float %add, float* @a
  ret void
}

; CHECK-LABEL: @worker_call_worker(
; CHECK-NEXT: ret i32 0
define i32 @worker_call_worker() #0 {
  %call = call i32 @func_worker()
  ret i32 %call
}

; CHECK-LABEL: @worker_call_supervisor(
; CHECK-NEXT: ret i32 1
define i32 @worker_call_supervisor() #0 {
  %call = call i32 @func_supervisor()
  ret i32 %call
}

; CHECK-LABEL: @worker_call_both(
; CHECK-NEXT: ret i32 2
define i32 @worker_call_both() #0 {
  %call = call i32 @func_both()
  ret i32 %call
}

; CHECK-LABEL: @worker_call_float_return(
; CHECK-NEXT: ret float 0.000000e+00
define float @worker_call_float_return() #0 {
  %call = call float @float_return()
  ret float %call
}

; CHECK-LABEL: @worker_call_float_args(
; CHECK-NEXT: %b = alloca float
; CHECK-NEXT: store float 1.000000e+00, float* %b
; CHECK-NEXT: %1 = load float, float* %b
; CHECK-NEXT: %add.i = fadd float %1, 1.000000e+00
; CHECK-NEXT: store float %add.i, float* %b
; CHECK-NEXT: %2 = load float, float* %b
; CHECK-NEXT: ret float %2
define float @worker_call_float_args() #0 {
  %b = alloca float
  store float 1.000000e+00, float* %b
  call void @float_args(float* %b)
  %1 = load float, float* %b
  ret float %1
}

; CHECK-LABEL: @worker_call_float_ops(
; CHECK-NEXT: %1 = load float, float* @a, align 4
; CHECK-NEXT: %add.i = fadd float %1, 1.000000e+00
; CHECK-NEXT: store float %add.i, float* @a, align 4
; CHECK-NEXT: ret void
define void @worker_call_float_ops() #0 {
  call void @float_ops()
  ret void
}

; CHECK-LABEL: @supervisor_call_worker(
; CHECK-NEXT: ret i32 0
define i32 @supervisor_call_worker() #1 {
  %call = call i32 @func_worker()
  ret i32 %call
}

; CHECK-LABEL: @supervisor_call_supervisor(
; CHECK-NEXT: ret i32 1
define i32 @supervisor_call_supervisor() #1 {
  %call = call i32 @func_supervisor()
  ret i32 %call
}

; CHECK-LABEL: @supervisor_call_both(
; CHECK-NEXT: ret i32 2
define i32 @supervisor_call_both() #1 {
  %call = call i32 @func_both()
  ret i32 %call
}

; CHECK-LABEL: @supervisor_call_float_return(
; CHECK: %call = call float @float_return()
define float @supervisor_call_float_return() #1 {
  %call = call float @float_return()
  ret float %call
}

; CHECK-LABEL: @supervisor_call_float_args(
; CHECK:call void @float_args(float* %b)
define float @supervisor_call_float_args() #1 {
  %b = alloca float
  store float 1.000000e+00, float* %b
  call void @float_args(float* %b)
  %1 = load float, float* %b
  ret float %1
}

; CHECK-LABEL: @supervisor_call_float_ops(
; CHECK: call void @float_ops()
define void @supervisor_call_float_ops() #1 {
  call void @float_ops()
  ret void
}

; CHECK-LABEL: @both_call_worker(
; CHECK-NEXT: ret i32 0
define i32 @both_call_worker() #2 {
  %call = call i32 @func_worker()
  ret i32 %call
}

; CHECK-LABEL: @both_call_supervisor(
; CHECK-NEXT: ret i32 1
define i32 @both_call_supervisor() #2 {
  %call = call i32 @func_supervisor()
  ret i32 %call
}

; CHECK-LABEL: @both_call_both(
; CHECK-NEXT: ret i32 2
define i32 @both_call_both() #2 {
  %call = call i32 @func_both()
  ret i32 %call
}

; CHECK-LABEL: @both_call_float_return(
; CHECK: %call = call float @float_return()
define float @both_call_float_return() #2 {
  %call = call float @float_return()
  ret float %call
}

; CHECK-LABEL: @both_call_float_args(
; CHECK:call void @float_args(float* %b)
define float @both_call_float_args() #2 {
  %b = alloca float
  store float 1.000000e+00, float* %b
  call void @float_args(float* %b)
  %1 = load float, float* %b
  ret float %1
}

; CHECK-LABEL: @both_call_float_ops(
; CHECK: call void @float_ops()
define void @both_call_float_ops() #2 {
  call void @float_ops()
  ret void
}


attributes #0 = { "target-features"="+worker" }
attributes #1 = { "target-features"="+supervisor" }
attributes #2 = { "target-features"="+both" }

