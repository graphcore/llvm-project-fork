; RUN: llc -march=colossus -O3 --max-nops-in-rpt=10 %s -o - | FileCheck %s -check-prefix=CHECK

declare void @llvm.assume(i1 noundef)

; CHECK-LABEL: Loop_65b_builtin_small:
; CHECK-NOT:   rpt
; CHECK-NOT:   brnzdec
; CHECK-NOT:   rpt
; CHECK:       br $m10

define dso_local i32 @Loop_65b_builtin_small(i65* nocapture readonly byval(i65) align 8 %0, i32* nocapture readonly %arr) {
entry:
  %inc = load i65, i65* %0, align 8
  %cmp = icmp ult i65 %inc, 2000
  tail call void @llvm.assume(i1 %cmp)
  %cmp127.not = icmp eq i65 %inc, 0
  br i1 %cmp127.not, label %for.cond.cleanup, label %for.body

for.cond.cleanup:                                 ; preds = %for.body, %entry
  %z.0.lcssa = phi i32 [ 0, %entry ], [ %add, %for.body ]
  ret i32 %z.0.lcssa

for.body:                                         ; preds = %entry, %for.body
  %z.029 = phi i32 [ %add, %for.body ], [ 0, %entry ]
  %storemerge28 = phi i65 [ %inc2, %for.body ], [ 0, %entry ]
  %conv = trunc i65 %storemerge28 to i32
  %arrayidx = getelementptr inbounds i32, i32* %arr, i32 %conv
  %1 = load i32, i32* %arrayidx, align 4
  %add = add i32 %1, %z.029
  %inc2 = add nuw nsw i65 %storemerge28, 1
  %cmp1 = icmp ult i65 %inc2, %inc
  br i1 %cmp1, label %for.body, label %for.cond.cleanup
}

; CHECK-LABEL: Loop_63b_builtin_small:
; CHECK:   rpt {{\$m[0-9]+}}, {{[0-9]}}
; CHECK:   br $m10

; Function Attrs: nofree nounwind optsize
define dso_local i32 @Loop_63b_builtin_small(i63 %inc, i32* nocapture readonly %arr) {
entry:
  %cmp = icmp ult i63 %inc, 2000
  tail call void @llvm.assume(i1 %cmp)
  %cmp19.not = icmp eq i63 %inc, 0
  br i1 %cmp19.not, label %for.cond.cleanup, label %for.body

for.cond.cleanup:                                 ; preds = %for.body, %entry
  %z.0.lcssa = phi i32 [ 0, %entry ], [ %add, %for.body ]
  ret i32 %z.0.lcssa

for.body:                                         ; preds = %entry, %for.body
  %i.011 = phi i63 [ %inc2, %for.body ], [ 0, %entry ]
  %z.010 = phi i32 [ %add, %for.body ], [ 0, %entry ]
  %conv = trunc i63 %i.011 to i32
  %arrayidx = getelementptr inbounds i32, i32* %arr, i32 %conv
  %0 = load i32, i32* %arrayidx, align 4
  %add = add i32 %0, %z.010
  %inc2 = add nuw i63 %i.011, 1
  %cmp1 = icmp ult i63 %inc2, %inc
  br i1 %cmp1, label %for.body, label %for.cond.cleanup
}


