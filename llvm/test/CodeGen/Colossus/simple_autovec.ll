; RUN: opt -passes='default<O2>,slp-vectorizer' -mattr=+ipu1 < %s -o - | llc  -mattr=+ipu1 -o - | FileCheck %s
; RUN: opt -passes='default<O2>,slp-vectorizer' -mattr=+ipu2 < %s -o - | llc  -mattr=+ipu2 -o - | FileCheck %s
target triple = "colossus-graphcore--elf"

; Codegen doesn't need to be perfect for this test - only check that the
; arithmetic and load/stores are extended to 64 bits at a time.

; CHECK-LABEL: autovec_known_bound:
; CHECK-NOT:   f32mul
; CHECK:       ld64
; CHECK:       ld64
; CHECK:       f16v4mul
; CHECK:       st64
; for (int i = 0; i < 1024; i++) *z++ = (*x++) * (*y++);
define void @autovec_known_bound(half* noalias align 8 %x,
                                 half* noalias align 8 %y,
                                 half* noalias align 8 %z) {
entry:
  br label %for.body

for.cond.cleanup:
  ret void

for.body:
  %i.011 = phi i32 [ 0, %entry ], [ %inc, %for.body ]
  %z.addr = phi half* [ %z, %entry ], [ %incdec.ptr2, %for.body ]
  %y.addr = phi half* [ %y, %entry ], [ %incdec.ptr1, %for.body ]
  %x.addr = phi half* [ %x, %entry ], [ %incdec.ptr, %for.body ]
  %0 = load half, half* %x.addr, align 2
  %1 = load half, half* %y.addr, align 2
  %mul = fmul half %0, %1
  store half %mul, half* %z.addr, align 2
  %incdec.ptr = getelementptr inbounds half, half* %x.addr, i32 1
  %incdec.ptr1 = getelementptr inbounds half, half* %y.addr, i32 1
  %incdec.ptr2 = getelementptr inbounds half, half* %z.addr, i32 1
  %inc = add nuw nsw i32 %i.011, 1
  %exitcond = icmp eq i32 %inc, 1024
  br i1 %exitcond, label %for.cond.cleanup, label %for.body
}

; CHECK-LABEL: autovec_known_bound_libm_call:
; CHECK-NOT:   f32max
; CHECK:       ld64
; CHECK:       ld64
; CHECK:       f32v2max
; CHECK:       st64
; for (int i = 0; i < n i++) *z++ = half_fmax(*x++, *y++);
declare float @fmaxf(float %x, float %y)
define void @autovec_known_bound_libm_call(float* noalias align 8 %x,
                                           float* noalias align 8 %y,
                                           float* noalias align 8 %z) {
entry:
  br label %for.body

for.cond.cleanup:
  ret void

for.body:
  %i.011 = phi i32 [ 0, %entry ], [ %inc, %for.body ]
  %z.addr = phi float* [ %z, %entry ], [ %incdec.ptr2, %for.body ]
  %y.addr = phi float* [ %y, %entry ], [ %incdec.ptr1, %for.body ]
  %x.addr = phi float* [ %x, %entry ], [ %incdec.ptr, %for.body ]
  %0 = load float, float* %x.addr, align 2
  %1 = load float, float* %y.addr, align 2
  %res = call float @fmaxf (float %0, float %1)
  store float %res, float* %z.addr, align 2
  %incdec.ptr = getelementptr inbounds float, float* %x.addr, i32 1
  %incdec.ptr1 = getelementptr inbounds float, float* %y.addr, i32 1
  %incdec.ptr2 = getelementptr inbounds float, float* %z.addr, i32 1
  %inc = add nuw nsw i32 %i.011, 1
  %exitcond = icmp eq i32 %inc, 1024
  br i1 %exitcond, label %for.cond.cleanup, label %for.body
}

; CHECK-LABEL: autovec_unknown_bound_dual_libm_call:
; CHECK:       ld64
; CHECK:       f16v2exp
; CHECK:       f16v2exp
; CHECK:       st64
declare half @half_exp(half %x)
define void @autovec_unknown_bound_dual_libm_call(i32 %n,
                                                  half* noalias align 8 %x,
                                                  half* noalias align 8 %z) {
entry:
  %cmp4 = icmp eq i32 %n, 0
  br i1 %cmp4, label %for.cond.cleanup, label %for.body

for.cond.cleanup:
  ret void

for.body:
  %i.07 = phi i32 [ %inc, %for.body ], [ 0, %entry ]
  %z.addr.06 = phi half* [ %incdec.ptr1, %for.body ], [ %z, %entry ]
  %x.addr.05 = phi half* [ %incdec.ptr, %for.body ], [ %x, %entry ]
  %incdec.ptr = getelementptr inbounds half, half* %x.addr.05, i32 1
  %0 = load half, half* %x.addr.05, align 2
  %call = call half @half_exp(half %0)
  %incdec.ptr1 = getelementptr inbounds half, half* %z.addr.06, i32 1
  store half %call, half* %z.addr.06, align 2
  %inc = add nuw nsw i32 %i.07, 1
  %exitcond = icmp eq i32 %inc, %n
  br i1 %exitcond, label %for.cond.cleanup, label %for.body
}
