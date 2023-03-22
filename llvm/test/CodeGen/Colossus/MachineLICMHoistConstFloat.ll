; RUN: llc < %s -mtriple=colossus | FileCheck %s

; CHECK-LABEL: foo:
; CHECK: setzi [[AREG:\$a[0-9]+]], 838861
; CHECK: or [[AREG]], [[AREG]], 1077936128
; CHECK: {{\.LBB[0-9_]+}}:
; CHECK-NOT: setzi [[AREG]], 838861
; CHECK-NOT: or [[AREG]], [[AREG]], 1077936128
define void @foo(float* %in, i32 %n) #0 {
entry:
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %i.0 = phi i32 [ 0, %entry ], [ %inc, %for.inc ]
  %cmp = icmp ult i32 %i.0, %n
  br i1 %cmp, label %for.body, label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.cond
  br label %for.end

for.body:                                         ; preds = %for.cond
  %0 = load float, float* %in, align 4
  %add = fadd float %0, 0x40099999A0000000
  store float %add, float* %in, align 4
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %inc = add nsw i32 %i.0, 1
  br label %for.cond

for.end:                                          ; preds = %for.cond.cleanup
  ret void
}

