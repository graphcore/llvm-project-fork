; RUN: llc < %s -march=colossus | grep -v '^\s*#' | FileCheck %s

; Check post-increment combine happens if there's more than one store
; CHECK-LABEL: two_consecutive_store_postinc:
; CHECK:       st32 $m1, $m0, $m15, 1
; CHECK-NEXT:  st32step $m1, $m15, $m0+=, 2
; CHECK-NEXT:  br $m10
define i32* @two_consecutive_store_postinc(i32* %dst, i32 %v) {
entry:
  %incdec.ptr = getelementptr inbounds i32, i32* %dst, i32 1
  store i32 %v, i32* %dst, align 4
  %incdec.ptr1 = getelementptr inbounds i32, i32* %dst, i32 2
  store i32 %v, i32* %incdec.ptr, align 4
  ret i32* %incdec.ptr1
}

; RUN: llc < %s -march=colossus | grep -v '^\s*#' | FileCheck -check-prefixes LOAD,LOAD1 %s
; RUN: llc < %s -march=colossus | grep -v '^\s*#' | FileCheck -check-prefixes LOAD,LOAD2 %s

; Check post-increment combine happens if there's more than one load
; LOAD-LABEL: two_consecutive_load_postinc:
; LOAD:       ld32 $m[[SUMREG:[0-9]+]], $m0, $m15, 1
; LOAD-NEXT:  ld32step $m[[TMPREG:[0-9]+]], $m15, $m0+=, 2
; LOAD1-NEXT:  add $m[[SUMREG]], {{.*}}$m[[TMPREG]]
; LOAD2-NEXT:  add $m[[SUMREG]], {{.*}}$m[[SUMREG]]
; LOAD-NEXT:  st32 $m[[SUMREG]], $m1, $m15, 0
; LOAD-NEXT:  br $m10
define i32* @two_consecutive_load_postinc(i32* %src, i32* %sum_p) {
entry:
  %incdec.ptr = getelementptr inbounds i32, i32* %src, i32 1
  %0 = load i32, i32* %src, align 4
  %incdec.ptr1 = getelementptr inbounds i32, i32* %src, i32 2
  %1 = load i32, i32* %incdec.ptr, align 4
  %add = add nsw i32 %1, %0
  store i32 %add, i32* %sum_p, align 4
  ret i32* %incdec.ptr1
}

; Check post-increment combine happens if there's a mix of load and store
; CHECK-LABEL: vector_copy:
; CHECK:       ld32 $m[[REG2:[0-9]+]], $m1, $m15, 1
; CHECK-NEXT:  ld32step $m[[REG1:[0-9]+]], $m15, $m1+=, 2
; CHECK-NEXT:  st32 $m[[REG2]], $m0, $m15, 1
; CHECK-NEXT:  st32step $m[[REG1]], $m15, $m0+=, 2
; CHECK-NEXT:  brnzdec  $m{{[0-9]+}}, {{[[:alnum:]._]+}}
define void @vector_copy(i32* %dst, i32* %src, i32 %n) {
entry:
  %cmp4 = icmp sgt i32 %n, 0
  br i1 %cmp4, label %for.body.preheader, label %for.cond.cleanup

for.body.preheader:
  %min.iters.check = icmp eq i32 %n, 1
  br i1 %min.iters.check, label %for.body.preheader13, label %vector.ph

for.body.preheader13:
  %i.07.ph = phi i32 [ 0, %for.body.preheader ], [ %n.vec, %middle.block ]
  %dst.addr.06.ph = phi i32* [ %dst, %for.body.preheader ], [ %ind.end, %middle.block ]
  %src.addr.05.ph = phi i32* [ %src, %for.body.preheader ], [ %ind.end11, %middle.block ]
  br label %for.body

vector.ph:
  %n.vec = and i32 %n, -2
  %ind.end = getelementptr i32, i32* %dst, i32 %n.vec
  %ind.end11 = getelementptr i32, i32* %src, i32 %n.vec
  br label %vector.body

vector.body:
  %index = phi i32 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %next.gep = getelementptr i32, i32* %dst, i32 %index
  %next.gep12 = getelementptr i32, i32* %src, i32 %index
  %0 = bitcast i32* %next.gep12 to <2 x i32>*
  %wide.load = load <2 x i32>, <2 x i32>* %0, align 4
  %1 = bitcast i32* %next.gep to <2 x i32>*
  store <2 x i32> %wide.load, <2 x i32>* %1, align 4
  %index.next = add i32 %index, 2
  %2 = icmp eq i32 %index.next, %n.vec
  br i1 %2, label %middle.block, label %vector.body

middle.block:
  %cmp.n = icmp eq i32 %n.vec, %n
  br i1 %cmp.n, label %for.cond.cleanup, label %for.body.preheader13

for.cond.cleanup:
  ret void

for.body:
  %i.07 = phi i32 [ %inc, %for.body ], [ %i.07.ph, %for.body.preheader13 ]
  %dst.addr.06 = phi i32* [ %incdec.ptr1, %for.body ], [ %dst.addr.06.ph, %for.body.preheader13 ]
  %src.addr.05 = phi i32* [ %incdec.ptr, %for.body ], [ %src.addr.05.ph, %for.body.preheader13 ]
  %incdec.ptr = getelementptr inbounds i32, i32* %src.addr.05, i32 1
  %3 = load i32, i32* %src.addr.05, align 4
  %incdec.ptr1 = getelementptr inbounds i32, i32* %dst.addr.06, i32 1
  store i32 %3, i32* %dst.addr.06, align 4
  %inc = add nuw nsw i32 %i.07, 1
  %exitcond = icmp eq i32 %inc, %n
  br i1 %exitcond, label %for.cond.cleanup, label %for.body
}

; RUN: llc < %s -march=colossus | grep -v '^\s*#' | FileCheck -check-prefixes VADD,VADD-INSTS %s
; RUN: llc < %s -march=colossus | grep -v '^\s*#' | FileCheck -check-prefixes VADD,VADD-LDSTREG,VADD-DEP1 %s
; RUN: llc < %s -march=colossus | grep -v '^\s*#' | FileCheck -check-prefixes VADD,VADD-LDSTREG,VADD-DEP2 %s
; RUN: llc < %s -march=colossus | grep -v '^\s*#' | FileCheck -check-prefixes VADD-LDDEP %s

; Check post-increment combine happens if there's a mix of load and store with
; some dependency between them
; VADD-LABEL: vector_add:
; VADD-INSTS: ld32
; VADD-INSTS-NEXT: ld32
; VADD-INSTS-NEXT: ld32
; VADD-INSTS-NEXT: ld32
; VADD-INSTS-NEXT: f32v2add
; VADD-INSTS-NEXT: st32
; VADD-INSTS-NEXT: st32step
; VADD-LDSTREG-DAG:   ld32     $a[[DSTREG1:[0-9]+]], $m0, $m15, 0
; VADD-LDSTREG-DAG:   ld32     $a[[DSTREG2:[0-9]+]], $m0, $m15, 1
; VADD-LDSTREG-DAG:   ld32     $a[[SRCREG2:[0-9]+]], $m1, $m15, 1
; VADD-LDSTREG-DAG:   ld32step $a[[SRCREG1:[0-9]+]], $m15, $m1+=, 2
; VADD-LDDEP:  ld32     $a{{[0-9]+}}, $m1, $m15, 1
; VADD-LDDEP:  ld32step $a{{[0-9]+}}, $m15, $m1+=, 2
; VADD-DEP1:   f32v2add  $a[[DSTREG3:[0-9]+]]:[[DSTREG4:[0-9]+]], {{.*}}$a[[DSTREG1]]:[[DSTREG2]]
; VADD-DEP2:   f32v2add  $a[[DSTREG3:[0-9]+]]:[[DSTREG4:[0-9]+]], {{.*}}$a[[SRCREG1]]:[[SRCREG2]]
; VADD-LDSTREG-NEXT:  st32     $a[[DSTREG4]], $m0, $m15, 1
; VADD-LDSTREG-NEXT:  st32step $a[[DSTREG3]], $m15, $m0+=, 2
; VADD-NEXT:  brnzdec  $m{{[0-9]+}}, {{[[:alnum:]._]+}}
define void @vector_add(float* %dst, float* %src, i32 %n) {
entry:
  %cmp4 = icmp sgt i32 %n, 0
  br i1 %cmp4, label %for.body.preheader, label %for.cond.cleanup

for.body.preheader:
  %min.iters.check = icmp eq i32 %n, 1
  br i1 %min.iters.check, label %for.body.preheader13, label %vector.ph

for.body.preheader13:
  %i.07.ph = phi i32 [ 0, %for.body.preheader ], [ %n.vec, %middle.block ]
  %dst.addr.06.ph = phi float* [ %dst, %for.body.preheader ], [ %ind.end, %middle.block ]
  %src.addr.05.ph = phi float* [ %src, %for.body.preheader ], [ %ind.end11, %middle.block ]
  br label %for.body

vector.ph:
  %n.vec = and i32 %n, -2
  %ind.end = getelementptr float, float* %dst, i32 %n.vec
  %ind.end11 = getelementptr float, float* %src, i32 %n.vec
  br label %vector.body

vector.body:
  %index = phi i32 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %next.gep = getelementptr float, float* %dst, i32 %index
  %next.gep12 = getelementptr float, float* %src, i32 %index
  %0 = bitcast float* %next.gep12 to <2 x float>*
  %wide.load = load <2 x float>, <2 x float>* %0, align 4
  %1 = bitcast float* %next.gep to <2 x float>*
  %wide.load1 = load <2 x float>, <2 x float>* %1, align 4
  %2 = fadd <2 x float> %wide.load, %wide.load1
  store <2 x float> %2, <2 x float>* %1, align 4
  %index.next = add i32 %index, 2
  %3 = icmp eq i32 %index.next, %n.vec
  br i1 %3, label %middle.block, label %vector.body

middle.block:
  %cmp.n = icmp eq i32 %n.vec, %n
  br i1 %cmp.n, label %for.cond.cleanup, label %for.body.preheader13

for.cond.cleanup:
  ret void

for.body:
  %i.07 = phi i32 [ %inc, %for.body ], [ %i.07.ph, %for.body.preheader13 ]
  %dst.addr.06 = phi float* [ %incdec.ptr1, %for.body ], [ %dst.addr.06.ph, %for.body.preheader13 ]
  %src.addr.05 = phi float* [ %incdec.ptr, %for.body ], [ %src.addr.05.ph, %for.body.preheader13 ]
  %incdec.ptr = getelementptr inbounds float, float* %src.addr.05, i32 1
  %4 = load float, float* %src.addr.05, align 4
  %incdec.ptr1 = getelementptr inbounds float, float* %dst.addr.06, i32 1
  %5 = load float, float* %dst.addr.06, align 4
  %6 = fadd float %4, %5
  store float %6, float* %dst.addr.06, align 4
  %inc = add nuw nsw i32 %i.07, 1
  %exitcond = icmp eq i32 %inc, %n
  br i1 %exitcond, label %for.cond.cleanup, label %for.body
}

; Check that no store happen before a load for any given location, i.e. all
; loads read the initial values of a and b vectors.
; RUN: llc < %s -march=colossus | grep -v '^\s*#' | FileCheck -check-prefixes SWAP,SWAP-INSTS1 %s
; RUN: llc < %s -march=colossus | grep -v '^\s*#' | FileCheck -check-prefixes SWAP,SWAP-INSTS2 %s
; RUN: llc < %s -march=colossus | grep -v '^\s*#' | FileCheck -check-prefixes SWAP,SWAP-INSTS3 %s
; RUN: llc < %s -march=colossus | grep -v '^\s*#' | FileCheck -check-prefixes SWAP,SWAP-INSTS4 %s

; SWAP-LABEL: swap_kernel:
; SWAP-INSTS1-NOT: st32 $m{{[0-9]+}}, $m0, $m15, 1
; SWAP-INSTS1: ld32 $m[[AREG1:[0-9]+]], $m0, $m15, 1
; SWAP-INSTS1: st32 $m[[AREG1]], $m1, $m15, 1
; SWAP-INSTS2-NOT: st32step $m{{[0-9]+}}, $m15, $m0+=, 2
; SWAP-INSTS2: ld32 $m[[AREG0:[0-9]+]], $m0, $m15, 0
; SWAP-INSTS2: st32step $m[[AREG0]], $m15, $m1+=, 2
; SWAP-INSTS3-NOT: st32 $m{{[0-9]+}}, $m1, $m15, 1
; SWAP-INSTS3: ld32 $m[[BREG1:[0-9]+]], $m1, $m15, 1
; SWAP-INSTS3: st32 $m[[BREG1]], $m0, $m15, 1
; SWAP-INSTS4-NOT: st32step $m{{[0-9]+}}, $m15, $m1+=, 2
; SWAP-INSTS4: ld32 $m[[BREG0:[0-9]+]], $m1, $m15, 0
; SWAP-INSTS4: st32step $m[[BREG0]], $m15, $m0+=, 2

define void @swap_kernel(i32* %a, i32* %b, i32 %n) {
entry:
  br label %vector.body

vector.body:
  %index = phi i32 [ 0, %entry ], [ %index.next, %vector.body ]
  %0 = getelementptr inbounds i32, i32* %a, i32 %index
  %1 = bitcast i32* %0 to <2 x i32>*
  %wide.load = load <2 x i32>, <2 x i32>* %1, align 4
  %2 = getelementptr inbounds i32, i32* %b, i32 %index
  %3 = bitcast i32* %2 to <2 x i32>*
  %wide.load4 = load <2 x i32>, <2 x i32>* %3, align 4
  %4 = bitcast i32* %0 to <2 x i32>*
  store <2 x i32> %wide.load4, <2 x i32>* %4, align 4
  %5 = bitcast i32* %2 to <2 x i32>*
  store <2 x i32> %wide.load, <2 x i32>* %5, align 4
  %index.next = add i32 %index, 2
  %6 = icmp eq i32 %index.next, %n
  br i1 %6, label %exit, label %vector.body

exit:
  ret void
}
