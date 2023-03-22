; Check Colossus load store vectorizer does not crash
; RUN: opt -colossus-load-store-vectorizer %s -o /dev/null

; Function Attrs: alwaysinline mustprogress nounwind
define void @foo(ptr %out, ptr %in, i32 %i) {
entry:
  br label %for.body.i.i

for.body.i.i:                                     ; preds = %entry, %for.body.i.i
  %lsr.iv = phi i32 [ %i, %entry ], [ %lsr.iv.next, %for.body.i.i ]
  %outPtr8.09.i.i = phi ptr [ %add.ptr1.i.i, %for.body.i.i ], [ %out, %entry ]
  %inPtr8.08.i.i = phi ptr [ %uglygep1, %for.body.i.i ], [ %in, %entry ]
  %vecext.i5.i.i = load float, ptr %inPtr8.08.i.i, align 8
  %uglygep = getelementptr i8, ptr %inPtr8.08.i.i, i32 4
  %vecext1.i6.i.i = load float, ptr %uglygep, align 4
  %tmpvec = insertelement <2 x float> zeroinitializer, float %vecext.i5.i.i, i32 0
  %0 = insertelement <2 x float> %tmpvec, float %vecext1.i6.i.i, i32 1
  store <2 x float> %0, ptr %outPtr8.09.i.i, align 8
  %add.ptr1.i.i = getelementptr inbounds <2 x float>, ptr %outPtr8.09.i.i, i32 1
  %lsr.iv.next = add nsw i32 %lsr.iv, -1
  %exitcond.not.i.i = icmp eq i32 %lsr.iv.next, 0
  %uglygep1 = getelementptr i8, ptr %inPtr8.08.i.i, i32 8
  br i1 %exitcond.not.i.i, label %exit, label %for.body.i.i

exit: ; preds = %for.body.i.i
  ret void
}
