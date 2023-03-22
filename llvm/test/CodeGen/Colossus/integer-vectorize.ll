; RUN: opt -S -loop-vectorize %s | FileCheck -check-prefix=LOOP_VECTORIZE %s
; RUN: opt -S -O3 %s | llc -O3 | FileCheck %s
target triple = "colossus-graphcore-unknown-elf"
target datalayout = "e-m:e-p:32:32-i1:8:32-i8:8:32-i16:16:32-i64:32-i128:64-f64:32-f128:64-v128:64-a:0:32-n32"

; Function Attrs: nounwind willreturn
declare void @llvm.assume(i1)

; Check that loop is vectorized to process 4 elements per loop because it is
; the biggest integer size that can be stored in a single instruction.
; LOOP_VECTORIZE-LABEL: {{^}}define {{(.+ )?}}@vector_not
; LOOP_VECTORIZE: vector.body:
; LOOP_VECTORIZE-NOT: {{[a-zA-Z0-9._]+}}:
; LOOP_VECTORIZE: store <4 x i8>

; CHECK-LABEL: {{^}}vector_not:
; CHECK: st32step {{.*}}+=, 1

; Function Attrs: nounwind
define dso_local void @vector_not(i8* %array_base) local_unnamed_addr {
entry:
  %size_.i.i = getelementptr inbounds i8, i8* %array_base, i32 4
  %0 = bitcast i8* %size_.i.i to i32*
  %1 = load i32, i32* %0, align 4, !tbaa !0
  br label %for.body.lr.ph.i

for.body.lr.ph.i:                                 ; preds = %entry
  %beginPtr.i.i.i1.i = bitcast i8* %array_base to i8**
  %2 = load i8*, i8** %beginPtr.i.i.i1.i, align 4, !tbaa !6
  %ptrint.i.i.i2.i = ptrtoint i8* %2 to i32
  %maskedptr.i.i.i3.i = and i32 %ptrint.i.i.i2.i, 7
  %maskcond.i.i.i4.i = icmp eq i32 %maskedptr.i.i.i3.i, 0
  tail call void @llvm.assume(i1 %maskcond.i.i.i4.i)
  br label %for.body.i

for.body.i:                                       ; preds = %for.body.i, %for.body.lr.ph.i
  %j.07.i = phi i32 [ 0, %for.body.lr.ph.i ], [ %inc.i, %for.body.i ]
  %arrayidx.i5.i = getelementptr inbounds i8, i8* %2, i32 %j.07.i
  %3 = load i8, i8* %arrayidx.i5.i, align 1, !range !7
  %4 = xor i8 %3, 1
  store i8 %4, i8* %arrayidx.i5.i, align 1, !tbaa !8
  %inc.i = add nuw i32 %j.07.i, 1
  %cmp.i = icmp eq i32 %inc.i, %1
  br i1 %cmp.i, label %exit, label %for.body.i

exit: ; preds = %for.body.i
  ret void
}

!0 = !{!1, !5, i64 4}
!1 = !{!"inner_array_base", !2, i64 0, !5, i64 4}
!2 = !{!"any pointer", !3, i64 0}
!3 = !{!"omnipotent char", !4, i64 0}
!4 = !{!"Simple C++ TBAA"}
!5 = !{!"int", !3, i64 0}
!6 = !{!1, !2, i64 0}
!7 = !{i8 0, i8 2}
!8 = !{!9, !9, i64 0}
!9 = !{!"bool", !3, i64 0}
