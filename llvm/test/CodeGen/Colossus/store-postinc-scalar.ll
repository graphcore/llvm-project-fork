; RUN: llc < %s -march=colossus -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -march=colossus -mattr=+ipu2 | FileCheck %s

; Test post incrementing stores of scalar types.

;===-----------------------------------------------------------------------===;
; ST32STEP
;===-----------------------------------------------------------------------===;

; CHECK-LABEL: st32step:
; CHECK:       st32step $m{{[0-9]+}}, $m15, $m{{[0-9]+}}+=, 1
define void @st32step(i32* %a, i32 %len) {
entry:
  br label %for.body

for.body:
  %i.06 = phi i32 [ %inc, %for.body ], [ 0, %entry ]
  %arrayidx = getelementptr inbounds i32, i32* %a, i32 %i.06
  store i32 %i.06, i32* %arrayidx, align 4
  %inc = add nuw i32 %i.06, 1
  %exitcond = icmp eq i32 %inc, %len
  br i1 %exitcond, label %loopexit, label %for.body

loopexit:
  ret void
}

;===-----------------------------------------------------------------------===;
; ST32STEP (float)
;===-----------------------------------------------------------------------===;

; CHECK-LABEL: ststep_f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  [[LABEL:\.L[A-Z0-9_]+]]:
; CHECK:       st32step $a0, $m15, $m{{[0-9]+}}+=, 1
; CHECK-NEXT:  bri [[LABEL]]
define void @ststep_f32(float* %a, float %c) {
entry:
  br label %for.body
for.body:
  %ind = phi i32 [ %inc, %for.body ], [ 0, %entry ]
  %arrayidx = getelementptr inbounds float, float* %a, i32 %ind
  store float %c, float* %arrayidx, align 4
  %inc = add nuw i32 %ind, 1
  br label %for.body
}

;===-----------------------------------------------------------------------===;
; ST32STEP (with two base addresses)
;===-----------------------------------------------------------------------===;

; CHECK-LABEL: st32step_two_addrs:
; CHECK:       st32step $m{{[0-9]+}}, $m{{[0-9]}}, $m{{[0-9]+}}+=, 1
define void @st32step_two_addrs(i32 %a, i32 %b, i32 %len) {
entry:
  br label %for.body

for.body:
  %i.06 = phi i32 [ %inc, %for.body ], [ 0, %entry ]
  %c = add nuw i32 %a, %b
  %addr = inttoptr i32 %c to i32*
  %arrayidx = getelementptr inbounds i32, i32* %addr, i32 %i.06
  store i32 %i.06, i32* %arrayidx, align 4
  %inc = add nuw i32 %i.06, 1
  %exitcond = icmp eq i32 %inc, %len
  br i1 %exitcond, label %loopexit, label %for.body

loopexit:
  ret void
}

;===-----------------------------------------------------------------------===;
; ST32STEP (max positive immediate)
;===-----------------------------------------------------------------------===;

; CHECK-LABEL: st32step_max_pos_imm:
; CHECK:       st32step $m{{[0-9]+}}, $m15, $m{{[0-9]+}}+=, 127
define void @st32step_max_pos_imm(i32* %a, i32 %len) {
entry:
  br label %for.body

for.body:
  %i.06 = phi i32 [ %inc, %for.body ], [ 0, %entry ]
  %arrayidx = getelementptr inbounds i32, i32* %a, i32 %i.06
  store i32 %i.06, i32* %arrayidx, align 4
  %inc = add nuw i32 %i.06, 127
  %exitcond = icmp eq i32 %inc, %len
  br i1 %exitcond, label %loopexit, label %for.body

loopexit:
  ret void
}

;===-----------------------------------------------------------------------===;
; ST32STEP (float with max positive immediate)
;===-----------------------------------------------------------------------===;

; CHECK-LABEL: st32step_f32_max_pos_imm:
; CHECK:       # %bb.0:
; CHECK-NEXT:  [[LABEL:\.L[A-Z0-9_]+]]:
; CHECK:       st32step $a0, $m15, $m{{[0-9]+}}+=, 127
; CHECK-NEXT:  bri [[LABEL]]
define void @st32step_f32_max_pos_imm(float* %a, float %c) {
entry:
  br label %for.body
for.body:
  %ind = phi i32 [ %inc, %for.body ], [ 0, %entry ]
  %arrayidx = getelementptr inbounds float, float* %a, i32 %ind
  store float %c, float* %arrayidx, align 4
  %inc = add nuw i32 %ind, 127
  br label %for.body
}

;===-----------------------------------------------------------------------===;
; ST32STEP (max negative immediate)
;===-----------------------------------------------------------------------===;

; CHECK-LABEL: st32step_max_neg_imm:
; CHECK:       st32step $m{{[0-9]+}}, $m15, $m{{[0-9]+}}+=, -128
define void @st32step_max_neg_imm(i32* %a, i32 %len) {
entry:
  br label %for.body

for.body:
  %i.06 = phi i32 [ %inc, %for.body ], [ 0, %entry ]
  %arrayidx = getelementptr inbounds i32, i32* %a, i32 %i.06
  store i32 %i.06, i32* %arrayidx, align 4
  %inc = add nsw i32 %i.06, -128
  %exitcond = icmp eq i32 %inc, %len
  br i1 %exitcond, label %loopexit, label %for.body

loopexit:
  ret void
}

;===-----------------------------------------------------------------------===;
; ST32STEP (float with max negative immediate)
;===-----------------------------------------------------------------------===;

; CHECK-LABEL: st32step_f32_max_neg_imm:
; CHECK:       # %bb.0:
; CHECK-NEXT:  [[LABEL:\.L[A-Z0-9_]+]]:
; CHECK:       st32step $a0, $m15, $m{{[0-9]+}}+=, -128
; CHECK-NEXT:  bri [[LABEL]]
define void @st32step_f32_max_neg_imm(float* %a, float %c) {
entry:
  br label %for.body
for.body:
  %ind = phi i32 [ %inc, %for.body ], [ 0, %entry ]
  %arrayidx = getelementptr inbounds float, float* %a, i32 %ind
  store float %c, float* %arrayidx, align 4
  %inc = add nuw i32 %ind, -128
  br label %for.body
}

;===-----------------------------------------------------------------------===;
; ST32STEP (out of range positive immediate)
;===-----------------------------------------------------------------------===;

; CHECK-LABEL: st32step_oor_pos_imm:
; CHECK:       st32 $m{{[0-9]+}}, $m[[addr:[0-9]+]], $m15, 0
; CHECK-DAG:   add $m[[addr]]
; CHECK-DAG:   add
define void @st32step_oor_pos_imm(i32* %a, i32 %len) {
entry:
  br label %for.body

for.body:
  %i.06 = phi i32 [ %inc, %for.body ], [ 0, %entry ]
  %arrayidx = getelementptr inbounds i32, i32* %a, i32 %i.06
  store i32 %i.06, i32* %arrayidx, align 4
  %inc = add nuw i32 %i.06, 128
  %exitcond = icmp eq i32 %inc, %len
  br i1 %exitcond, label %loopexit, label %for.body

loopexit:
  ret void
}

;===-----------------------------------------------------------------------===;
; ST32STEP (float out of range positive immediate)
;===-----------------------------------------------------------------------===;

; CHECK-LABEL: st32step_f32_oor_pos_imm:
; CHECK:       # %bb.0:
; CHECK-NEXT:  [[LABEL:\.L[A-Z0-9_]+]]:
; CHECK:       st32 $a0, $m{{[0-9]+}}, $m15, 0
; CHECK:       add
; CHECK-NEXT:  bri [[LABEL]]
define void @st32step_f32_oor_pos_imm(float* %a, float %c) {
entry:
  br label %for.body
for.body:
  %ind = phi i32 [ %inc, %for.body ], [ 0, %entry ]
  %arrayidx = getelementptr inbounds float, float* %a, i32 %ind
  store float %c, float* %arrayidx, align 4
  %inc = add nuw i32 %ind, 128
  br label %for.body
}

;===-----------------------------------------------------------------------===;
; ST32STEP (out of range negative immediate)
;===-----------------------------------------------------------------------===;

; CHECK-LABEL: st32step_oor_neg_imm:
; CHECK:       st32 $m{{[0-9]+}}, $m{{[0-9]+}}, $m15, 0
; CHECK-DAG:   add $m[[addr]]
; CHECK-DAG:   add
define void @st32step_oor_neg_imm(i32* %a, i32 %len) {
entry:
  br label %for.body

for.body:
  %i.06 = phi i32 [ %inc, %for.body ], [ 0, %entry ]
  %arrayidx = getelementptr inbounds i32, i32* %a, i32 %i.06
  store i32 %i.06, i32* %arrayidx, align 4
  %inc = add nsw i32 %i.06, -129
  %exitcond = icmp eq i32 %inc, %len
  br i1 %exitcond, label %loopexit, label %for.body

loopexit:
  ret void
}

;===-----------------------------------------------------------------------===;
; ST32STEP (float with out of range negative immediate)
;===-----------------------------------------------------------------------===;

; CHECK-LABEL: st32step_f32_oor_neg_imm:
; CHECK:       # %bb.0:
; CHECK-NEXT:  [[LABEL:\.L[A-Z0-9_]+]]:
; CHECK:       st32 $a0, $m{{[0-9]+}}, $m15, 0
; CHECK:       add
; CHECK-NEXT:  bri [[LABEL]]
define void @st32step_f32_oor_neg_imm(float* %a, float %c) {
entry:
  br label %for.body
for.body:
  %ind = phi i32 [ %inc, %for.body ], [ 0, %entry ]
  %arrayidx = getelementptr inbounds float, float* %a, i32 %ind
  store float %c, float* %arrayidx, align 4
  %inc = add nuw i32 %ind, -129
  br label %for.body
}

;===-----------------------------------------------------------------------===;
; ST32STEP (with two base addresses) + use of new index
;===-----------------------------------------------------------------------===;

%structA = type { [102400 x i8], %structB }
%structB = type { %structA*, i8 }

; CHECK-LABEL: st32step_two_addrs_idx_use:
; CHECK:      add $m11, $m11, -8
; CHECK:      st32 $m10, $m11, $m15, 1
; CHECK-NEXT: st32 $m7, $m11, $m15, 0
; CHECK-NEXT: mov     $m7, $m0
; CHECK-NEXT: setzi $m0, 102400
; CHECK-NEXT: st32step $m7, $m7, $m0+=, 1
; CHECK-NEXT: add $m0, $m7, $m0
; CHECK-NEXT: mov     $m1, $m15
; CHECK-NEXT: call $m10, __st8
; CHECK-NEXT: mov     $m0, $m7
; CHECK-NEXT: ld32 $m7, $m11, $m15, 0
; CHECK-NEXT: ld32 $m10, $m11, $m15, 1
; CHECK-NEXT: add $m11, $m11, 8
; CHECK:      br $m10
define %structA* @st32step_two_addrs_idx_use(%structA* %0) {
  %2 = getelementptr inbounds %structA, %structA* %0, i32 0, i32 1, i32 0
  store %structA* %0, %structA** %2, align 4
  %3 = getelementptr inbounds %structA, %structA* %0, i32 0, i32 1, i32 1
  store i8 0, i8* %3, align 4
  ret %structA* %0
}
