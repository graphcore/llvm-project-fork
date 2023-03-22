; RUN: llc < %s -march=colossus -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -march=colossus -mattr=+ipu2 | FileCheck %s

; Test lowering of post-incrementing loads of scalar types.

;===------------------------------------------------------------------------===;
; LD32STEP
;===------------------------------------------------------------------------===;

; CHECK-LABEL: ld32step:
; CHECK:       ld32step $m{{[0-9]+}}, $m15, $m{{[0-9]+}}+=, 1
define i32 @ld32step(i32* %a, i32 %len) {
entry:
  br label %for.body

for.body:
  %i.08 = phi i32 [ %inc, %for.body ], [0, %entry ]
  %sum.07 = phi i32 [ %add, %for.body ], [0, %entry ]
  %arrayidx = getelementptr inbounds i32, i32* %a, i32 %i.08
  %0 = load i32, i32* %arrayidx, align 4
  %add = add nsw i32 %0, %sum.07
  %inc = add nuw i32 %i.08, 1
  %exitcond = icmp eq i32 %inc, %len
  br i1 %exitcond, label %loopexit, label %for.body

loopexit:
  %sum = phi i32 [ %add, %for.body ]
  ret i32 %sum
}

;===------------------------------------------------------------------------===;
; LD32STEP (float)
;===------------------------------------------------------------------------===;

; CHECK-LABEL: ld32step_f32:
; CHECK:       [[LABEL:\.L[A-Z0-9_]+]]:
; CHECK:       ld32step $a0, $m15, $m{{[0-9]+}}+=, 1
; CHECK-NEXT:  st32step $a0, $m15, $m{{[0-9]+}}+=, 1
; CHECK-NEXT:  bri [[LABEL]]
define void @ld32step_f32(float* %a, float* %b) {
entry:
  br label %for.body
for.body:
  %ind = phi i32 [ %inc, %for.body ], [0, %entry ]
  %aidx = getelementptr inbounds float, float* %a, i32 %ind
  %bidx = getelementptr inbounds float, float* %b, i32 %ind
  %tmp = load float, float* %aidx, align 4
  store float %tmp, float* %bidx, align 4
  %inc = add nuw i32 %ind, 1
  br label %for.body
}

;===------------------------------------------------------------------------===;
; LD32STEP (with two base addresses)
;===------------------------------------------------------------------------===;

; CHECK-LABEL: ld32step_two_addrs:
; CHECK:       ld32step $m{{[0-9]+}}, $m{{[0-9]}}, $m{{[0-9]+}}+=, 1
define i32 @ld32step_two_addrs(i32 %a, i32 %b, i32 %len) {
entry:
  br label %for.body

for.body:
  %i.08 = phi i32 [ %inc, %for.body ], [0, %entry ]
  %sum.07 = phi i32 [ %add, %for.body ], [0, %entry ]
  %c = add nuw i32 %a, %b
  %addr = inttoptr i32 %c to i32*
  %arrayidx = getelementptr inbounds i32, i32* %addr, i32 %i.08
  %0 = load i32, i32* %arrayidx, align 4
  %add = add nsw i32 %0, %sum.07
  %inc = add nuw i32 %i.08, 1
  %exitcond = icmp eq i32 %inc, %len
  br i1 %exitcond, label %loopexit, label %for.body

loopexit:
  %sum = phi i32 [ %add, %for.body ]
  ret i32 %sum
}

;===------------------------------------------------------------------------===;
; LD32STEP (max positive immediate)
;===------------------------------------------------------------------------===;

; CHECK-LABEL: ld32step_max_pos_imm:
; CHECK:       ld32step $m{{[0-9]+}}, $m15, $m{{[0-9]+}}+=, 127
define i32 @ld32step_max_pos_imm(i32* %a, i32 %len) {
entry:
  br label %for.body

for.body:
  %i.08 = phi i32 [ %inc, %for.body ], [0, %entry ]
  %sum.07 = phi i32 [ %add, %for.body ], [0, %entry ]
  %arrayidx = getelementptr inbounds i32, i32* %a, i32 %i.08
  %0 = load i32, i32* %arrayidx, align 4
  %add = add nsw i32 %0, %sum.07
  %inc = add nuw i32 %i.08, 127
  %exitcond = icmp eq i32 %inc, %len
  br i1 %exitcond, label %loopexit, label %for.body

loopexit:
  %sum = phi i32 [ %add, %for.body ]
  ret i32 %sum
}

;===------------------------------------------------------------------------===;
; LD32STEP (float with max positive immediate)
;===------------------------------------------------------------------------===;

; CHECK-LABEL: ld32step_f32_max_pos_imm:
; CHECK:       [[LABEL:\.L[A-Z0-9_]+]]:
; CHECK:       ld32step $a0, $m15, $m{{[0-9]+}}+=, 127
; CHECK-NEXT:  st32step $a0, $m15, $m{{[0-9]+}}+=, 127
; CHECK-NEXT:  bri [[LABEL]]
define void @ld32step_f32_max_pos_imm(float* %a, float* %b) {
entry:
  br label %for.body
for.body:
  %ind = phi i32 [ %inc, %for.body ], [0, %entry ]
  %aidx = getelementptr inbounds float, float* %a, i32 %ind
  %bidx = getelementptr inbounds float, float* %b, i32 %ind
  %tmp = load float, float* %aidx, align 4
  store float %tmp, float* %bidx, align 4
  %inc = add nuw i32 %ind, 127
  br label %for.body
}

;===------------------------------------------------------------------------===;
; LD32STEP (max negative immediate)
;===------------------------------------------------------------------------===;

; CHECK-LABEL: ld32step_max_neg_imm:
; CHECK:       ld32step $m{{[0-9]+}}, $m15, $m{{[0-9]+}}+=, -128
define i32 @ld32step_max_neg_imm(i32* %a, i32 %len) {
entry:
  br label %for.body

for.body:
  %i.08 = phi i32 [ %inc, %for.body ], [0, %entry ]
  %sum.07 = phi i32 [ %add, %for.body ], [0, %entry ]
  %arrayidx = getelementptr inbounds i32, i32* %a, i32 %i.08
  %0 = load i32, i32* %arrayidx, align 4
  %add = add nsw i32 %0, %sum.07
  %inc = add nsw i32 %i.08, -128
  %exitcond = icmp eq i32 %inc, %len
  br i1 %exitcond, label %loopexit, label %for.body

loopexit:
  %sum = phi i32 [ %add, %for.body ]
  ret i32 %sum
}

;===------------------------------------------------------------------------===;
; LD32STEP (float with max negative immediate)
;===------------------------------------------------------------------------===;

; CHECK-LABEL: ld32step_f32_max_neg_imm:
; CHECK:       [[LABEL:\.L[A-Z0-9_]+]]:
; CHECK:       ld32step $a0, $m15, $m{{[0-9]+}}+=, -128
; CHECK-NEXT:  st32step $a0, $m15, $m{{[0-9]+}}+=, -128
; CHECK-NEXT:  bri [[LABEL]]
define void @ld32step_f32_max_neg_imm(float* %a, float* %b) {
entry:
  br label %for.body
for.body:
  %ind = phi i32 [ %inc, %for.body ], [0, %entry ]
  %aidx = getelementptr inbounds float, float* %a, i32 %ind
  %bidx = getelementptr inbounds float, float* %b, i32 %ind
  %tmp = load float, float* %aidx, align 4
  store float %tmp, float* %bidx, align 4
  %inc = add nuw i32 %ind, -128
  br label %for.body
}

;===------------------------------------------------------------------------===;
; LD32STEP (out of range positive immediate)
;===------------------------------------------------------------------------===;

; CHECK-LABEL: ld32step_oor_pos_imm:
; CHECK:       ld32 $m{{[0-9]+}}, $m[[addr:[0-9]+]], $m15, 0
; CHECK-DAG:   add $m[[addr]]
define i32 @ld32step_oor_pos_imm(i32* %a, i32 %len) {
entry:
  br label %for.body

for.body:
  %i.08 = phi i32 [ %inc, %for.body ], [0, %entry ]
  %sum.07 = phi i32 [ %add, %for.body ], [0, %entry ]
  %arrayidx = getelementptr inbounds i32, i32* %a, i32 %i.08
  %0 = load i32, i32* %arrayidx, align 4
  %add = add nsw i32 %0, %sum.07
  %inc = add nuw i32 %i.08, 128
  %exitcond = icmp eq i32 %inc, %len
  br i1 %exitcond, label %loopexit, label %for.body

loopexit:
  %sum = phi i32 [ %add, %for.body ]
  ret i32 %sum
}

;===------------------------------------------------------------------------===;
; LD32STEP (float with out of range positive immediate)
;===------------------------------------------------------------------------===;

; CHECK-LABEL: ld32step_f32_oor_pos_imm:
; CHECK:       [[LABEL:\.L[A-Z0-9_]+]]:
; CHECK:       ld32 $a0, $m{{[0-9]+}}, $m15, 0
; CHECK-NEXT:  st32 $a0, $m{{[0-9]+}}, $m15, 0
; CHECK:       add
; CHECK:       add
; CHECK-NEXT:  bri [[LABEL]]
define void @ld32step_f32_oor_pos_imm(float* %a, float* %b) {
entry:
  br label %for.body
for.body:
  %ind = phi i32 [ %inc, %for.body ], [0, %entry ]
  %aidx = getelementptr inbounds float, float* %a, i32 %ind
  %bidx = getelementptr inbounds float, float* %b, i32 %ind
  %tmp = load float, float* %aidx, align 4
  store float %tmp, float* %bidx, align 4
  %inc = add nuw i32 %ind, 128
  br label %for.body
}

;===------------------------------------------------------------------------===;
; LD32STEP (out of range negative immediate)
;===------------------------------------------------------------------------===;

; CHECK-LABEL: ld32step_oor_neg_imm:
; CHECK:       ld32 $m{{[0-9]+}}, $m[[addr:[0-9]+]], $m15, 0
; CHECK-DAG:   add $m[[addr]]
define i32 @ld32step_oor_neg_imm(i32* %a, i32 %len) {
entry:
  br label %for.body

for.body:
  %i.08 = phi i32 [ %inc, %for.body ], [0, %entry ]
  %sum.07 = phi i32 [ %add, %for.body ], [0, %entry ]
  %arrayidx = getelementptr inbounds i32, i32* %a, i32 %i.08
  %0 = load i32, i32* %arrayidx, align 4
  %add = add nsw i32 %0, %sum.07
  %inc = add nsw i32 %i.08, -129
  %exitcond = icmp eq i32 %inc, %len
  br i1 %exitcond, label %loopexit, label %for.body

loopexit:
  %sum = phi i32 [ %add, %for.body ]
  ret i32 %sum
}

;===------------------------------------------------------------------------===;
; LD32STEP (float with out of range negative immediate)
;===------------------------------------------------------------------------===;

; CHECK-LABEL: ld32step_f32_oor_neg_imm:
; CHECK:       [[LABEL:\.L[A-Z0-9_]+]]:
; CHECK:       ld32 $a0, $m{{[0-9]+}}, $m15, 0
; CHECK-NEXT:  st32 $a0, $m{{[0-9]+}}, $m15, 0
; CHECK:       add
; CHECK:       add
; CHECK-NEXT:  bri [[LABEL]]
define void @ld32step_f32_oor_neg_imm(float* %a, float* %b) {
entry:
  br label %for.body
for.body:
  %ind = phi i32 [ %inc, %for.body ], [0, %entry ]
  %aidx = getelementptr inbounds float, float* %a, i32 %ind
  %bidx = getelementptr inbounds float, float* %b, i32 %ind
  %tmp = load float, float* %aidx, align 4
  store float %tmp, float* %bidx, align 4
  %inc = add nuw i32 %ind, -129
  br label %for.body
}


;===------------------------------------------------------------------------===;
; LDB16STEP
;===------------------------------------------------------------------------===;

; CHECK-LABEL: ldb16step:
; CHECK:       [[LABEL:\.L[A-Z0-9_]+]]:
; CHECK:       ldb16step $a0, $m15, $m{{[0-9]+}}+=, 1
; CHECK:       call $m10, __st16f
; CHECK:       bri [[LABEL]]
define void @ldb16step(half* %a, half* %b) {
entry:
  br label %for.body
for.body:
  %ind = phi i32 [ %inc, %for.body ], [0, %entry ]
  %aidx = getelementptr inbounds half, half* %a, i32 %ind
  %bidx = getelementptr inbounds half, half* %b, i32 %ind
  %tmp = load half, half* %aidx, align 2
  store half %tmp, half* %bidx, align 2
  %inc = add nuw i32 %ind, 1
  br label %for.body
}

;===------------------------------------------------------------------------===;
; LDB16STEP (max positive immediate)
;===------------------------------------------------------------------------===;

; CHECK-LABEL: ldb16step_max_pos_imm:
; CHECK:       [[LABEL:\.L[A-Z0-9_]+]]:
; CHECK:       ldb16step $a0, $m15, $m{{[0-9]+}}+=, 127
; CHECK:       call $m10, __st16f
; CHECK:       bri [[LABEL]]
define void @ldb16step_max_pos_imm(half* %a, half* %b) {
entry:
  br label %for.body
for.body:
  %ind = phi i32 [ %inc, %for.body ], [0, %entry ]
  %aidx = getelementptr inbounds half, half* %a, i32 %ind
  %bidx = getelementptr inbounds half, half* %b, i32 %ind
  %tmp = load half, half* %aidx, align 2
  store half %tmp, half* %bidx, align 2
  %inc = add nuw i32 %ind, 127
  br label %for.body
}

;===------------------------------------------------------------------------===;
; LDB16STEP (max negative immediate)
;===------------------------------------------------------------------------===;

; CHECK-LABEL: ldb16step_max_neg_imm:
; CHECK:       [[LABEL:\.L[A-Z0-9_]+]]:
; CHECK:       ldb16step $a0, $m15, $m{{[0-9]+}}+=, -128
; CHECK:       call $m10, __st16f
; CHECK:       bri [[LABEL]]
define void @ldb16step_max_neg_imm(half* %a, half* %b) {
entry:
  br label %for.body
for.body:
  %ind = phi i32 [ %inc, %for.body ], [0, %entry ]
  %aidx = getelementptr inbounds half, half* %a, i32 %ind
  %bidx = getelementptr inbounds half, half* %b, i32 %ind
  %tmp = load half, half* %aidx, align 2
  store half %tmp, half* %bidx, align 2
  %inc = add nuw i32 %ind, -128
  br label %for.body
}

;===------------------------------------------------------------------------===;
; LDB16STEP (out of range positive immediate)
;===------------------------------------------------------------------------===;

; CHECK-LABEL: ldb16step_oor_pos_imm:
; CHECK:       [[LABEL:\.L[A-Z0-9_]+]]:
; CHECK:       ldb16 $a0, $m{{[0-9]+}}, $m15, 0
; CHECK:       call $m10, __st16f
; CHECK:       add
; CHECK:       add
; CHECK:       bri [[LABEL]]
define void @ldb16step_oor_pos_imm(half* %a, half* %b) {
entry:
  br label %for.body
for.body:
  %ind = phi i32 [ %inc, %for.body ], [0, %entry ]
  %aidx = getelementptr inbounds half, half* %a, i32 %ind
  %bidx = getelementptr inbounds half, half* %b, i32 %ind
  %tmp = load half, half* %aidx, align 2
  store half %tmp, half* %bidx, align 2
  %inc = add nuw i32 %ind, 128
  br label %for.body
}

;===------------------------------------------------------------------------===;
; LDB16STEP (out of range negative immediate)
;===------------------------------------------------------------------------===;

; CHECK-LABEL: ldb16step_oor_neg_imm:
; CHECK:       [[LABEL:\.L[A-Z0-9_]+]]:
; CHECK:       ldb16 $a0, $m{{[0-9]+}}, $m15, 0
; CHECK:       call $m10, __st16f
; CHECK:       add
; CHECK:       add
; CHECK:       bri [[LABEL]]
define void @ldb16step_oor_neg_imm(half* %a, half* %b) {
entry:
  br label %for.body
for.body:
  %ind = phi i32 [ %inc, %for.body ], [0, %entry ]
  %aidx = getelementptr inbounds half, half* %a, i32 %ind
  %bidx = getelementptr inbounds half, half* %b, i32 %ind
  %tmp = load half, half* %aidx, align 2
  store half %tmp, half* %bidx, align 2
  %inc = add nuw i32 %ind, -129
  br label %for.body
}

;===------------------------------------------------------------------------===;
; LDS16STEP
;===------------------------------------------------------------------------===;

; CHECK-LABEL: lds16step:
; CHECK:       lds16step $m{{[0-9]+}}, $m15, $m{{[0-9]+}}+=, 1
define i32 @lds16step(i16* %a, i32 %len) {
entry:
  br label %for.body

for.body:
  %i.08 = phi i32 [ %inc, %for.body ], [ 0, %entry ]
  %sum.07 = phi i32 [ %add, %for.body ], [ 0, %entry ]
  %arrayidx = getelementptr inbounds i16, i16* %a, i32 %i.08
  %0 = load i16, i16* %arrayidx, align 2
  %conv = sext i16 %0 to i32
  %add = add nsw i32 %conv, %sum.07
  %inc = add nuw i32 %i.08, 1
  %exitcond = icmp eq i32 %inc, %len
  br i1 %exitcond, label %loopexit, label %for.body

loopexit:
  %sum = phi i32 [ %add, %for.body ]
  ret i32 %sum
}

;===------------------------------------------------------------------------===;
; LDS16STEP (with two base addresses)
;===------------------------------------------------------------------------===;

; CHECK-LABEL: lds16step_two_addrs:
; CHECK:       lds16step $m{{[0-9]+}}, $m{{[0-9]}}, $m{{[0-9]+}}+=, 1
define i32 @lds16step_two_addrs(i16 %a, i16 %b, i32 %len) {
entry:
  br label %for.body

for.body:
  %i.08 = phi i32 [ %inc, %for.body ], [ 0, %entry ]
  %sum.07 = phi i32 [ %add, %for.body ], [ 0, %entry ]
  %c = add nuw i16 %a, %b
  %addr = inttoptr i16 %c to i16*
  %arrayidx = getelementptr inbounds i16, i16* %addr, i32 %i.08
  %0 = load i16, i16* %arrayidx, align 2
  %conv = sext i16 %0 to i32
  %add = add nsw i32 %conv, %sum.07
  %inc = add nuw i32 %i.08, 1
  %exitcond = icmp eq i32 %inc, %len
  br i1 %exitcond, label %loopexit, label %for.body

loopexit:
  %sum = phi i32 [ %add, %for.body ]
  ret i32 %sum
}

;===------------------------------------------------------------------------===;
; LDS16STEP (max positive immediate)
;===------------------------------------------------------------------------===;

; CHECK-LABEL: lds16step_max_pos_imm:
; CHECK:       lds16step $m{{[0-9]+}}, $m15, $m{{[0-9]+}}+=, 127
define i32 @lds16step_max_pos_imm(i16* %a, i32 %len) {
entry:
  br label %for.body

for.body:
  %i.08 = phi i32 [ %inc, %for.body ], [ 0, %entry ]
  %sum.07 = phi i32 [ %add, %for.body ], [ 0, %entry ]
  %arrayidx = getelementptr inbounds i16, i16* %a, i32 %i.08
  %0 = load i16, i16* %arrayidx, align 2
  %conv = sext i16 %0 to i32
  %add = add nsw i32 %conv, %sum.07
  %inc = add nuw i32 %i.08, 127
  %exitcond = icmp eq i32 %inc, %len
  br i1 %exitcond, label %loopexit, label %for.body

loopexit:
  %sum = phi i32 [ %add, %for.body ]
  ret i32 %sum
}

;===------------------------------------------------------------------------===;
; LDS16STEP (max negative immediate)
;===------------------------------------------------------------------------===;

; CHECK-LABEL: lds16step_max_neg_imm:
; CHECK:       lds16step $m{{[0-9]+}}, $m15, $m{{[0-9]+}}+=, -128
define i32 @lds16step_max_neg_imm(i16* %a, i32 %len) {
entry:
  br label %for.body

for.body:
  %i.08 = phi i32 [ %inc, %for.body ], [ 0, %entry ]
  %sum.07 = phi i32 [ %add, %for.body ], [ 0, %entry ]
  %arrayidx = getelementptr inbounds i16, i16* %a, i32 %i.08
  %0 = load i16, i16* %arrayidx, align 2
  %conv = sext i16 %0 to i32
  %add = add nsw i32 %conv, %sum.07
  %inc = add nuw i32 %i.08, -128
  %exitcond = icmp eq i32 %inc, %len
  br i1 %exitcond, label %loopexit, label %for.body

loopexit:
  %sum = phi i32 [ %add, %for.body ]
  ret i32 %sum
}

;===------------------------------------------------------------------------===;
; LD16STEP (out of range positive immediate)
;===------------------------------------------------------------------------===;

; CHECK-LABEL: ld16step_oor_pos_imm:
; CHECK:       lds16 $m{{[0-9]+}}, $m[[addr:[0-9]+]], $m15, 0
; CHECK-DAG:   add $m[[addr]]
define i32 @ld16step_oor_pos_imm(i16* %a, i32 %len) {
entry:
  br label %for.body

for.body:
  %i.08 = phi i32 [ %inc, %for.body ], [0, %entry ]
  %sum.07 = phi i32 [ %add, %for.body ], [0, %entry ]
  %arrayidx = getelementptr inbounds i16, i16* %a, i32 %i.08
  %0 = load i16, i16* %arrayidx, align 4
  %conv = sext i16 %0 to i32
  %add = add nsw i32 %conv, %sum.07
  %inc = add nuw i32 %i.08, 128
  %exitcond = icmp eq i32 %inc, %len
  br i1 %exitcond, label %loopexit, label %for.body

loopexit:
  %sum = phi i32 [ %add, %for.body ]
  ret i32 %sum
}

;===------------------------------------------------------------------------===;
; LD16STEP (out of range negative immediate)
;===------------------------------------------------------------------------===;

; CHECK-LABEL: ld16step_oor_neg_imm:
; CHECK:       lds16 $m{{[0-9]+}}, $m[[addr:[0-9]+]], $m15, 0
; CHECK-DAG:   add $m[[addr]]
define i32 @ld16step_oor_neg_imm(i16* %a, i32 %len) {
entry:
  br label %for.body

for.body:
  %i.08 = phi i32 [ %inc, %for.body ], [0, %entry ]
  %sum.07 = phi i32 [ %add, %for.body ], [0, %entry ]
  %arrayidx = getelementptr inbounds i16, i16* %a, i32 %i.08
  %0 = load i16, i16* %arrayidx, align 4
  %conv = sext i16 %0 to i32
  %add = add nsw i32 %conv, %sum.07
  %inc = add nsw i32 %i.08, -129
  %exitcond = icmp eq i32 %inc, %len
  br i1 %exitcond, label %loopexit, label %for.body

loopexit:
  %sum = phi i32 [ %add, %for.body ]
  ret i32 %sum
}

;===------------------------------------------------------------------------===;
; LDZ16STEP
;===------------------------------------------------------------------------===;

; CHECK-LABEL: ldz16step:
; CHECK:       ldz16step $m{{[0-9]+}}, $m15, $m{{[0-9]+}}+=, 1
define i32 @ldz16step(i16* %a, i32 %len) {
entry:
  br label %for.body

for.body:
  %i.08 = phi i32 [ %inc, %for.body ], [ 0, %entry ]
  %sum.07 = phi i32 [ %add, %for.body ], [ 0, %entry ]
  %arrayidx = getelementptr inbounds i16, i16* %a, i32 %i.08
  %0 = load i16, i16* %arrayidx, align 2
  %conv = zext i16 %0 to i32
  %add = add i32 %conv, %sum.07
  %inc = add nuw i32 %i.08, 1
  %exitcond = icmp eq i32 %inc, %len
  br i1 %exitcond, label %loopexit, label %for.body

loopexit:
  %sum = phi i32 [ %add, %for.body ]
  ret i32 %sum
}

;===------------------------------------------------------------------------===;
; LDZ16STEP (max positive immediate)
;===------------------------------------------------------------------------===;

; CHECK-LABEL: ldz16step_max_pos_imm:
; CHECK:       [[LABEL:\.L[A-Z0-9_]+]]:
; CHECK:       ldz16step $m1, $m15, $m{{0|[2-9]+}}+=, 127
; CHECK:       $m10, __st16
; CHECK:       bri [[LABEL]]
define void @ldz16step_max_pos_imm(i16* %a, i16* %b) {
entry:
  br label %for.body
for.body:
  %ind = phi i32 [ %inc, %for.body ], [0, %entry ]
  %aidx = getelementptr inbounds i16, i16* %a, i32 %ind
  %bidx = getelementptr inbounds i16, i16* %b, i32 %ind
  %tmp = load i16, i16* %aidx, align 2
  store i16 %tmp, i16* %bidx, align 2
  %inc = add nuw i32 %ind, 127
  br label %for.body
}

;===------------------------------------------------------------------------===;
; LDZ16STEP (max negative immediate)
;===------------------------------------------------------------------------===;

; CHECK-LABEL: ldz16step_max_neg_imm:
; CHECK:       [[LABEL:\.L[A-Z0-9_]+]]:
; CHECK:       ldz16step $m1, $m15, $m{{0|[2-9]+}}+=, -128
; CHECK:       $m10, __st16
; CHECK:       bri [[LABEL]]
define void @ldz16step_max_neg_imm(i16* %a, i16* %b) {
entry:
  br label %for.body
for.body:
  %ind = phi i32 [ %inc, %for.body ], [0, %entry ]
  %aidx = getelementptr inbounds i16, i16* %a, i32 %ind
  %bidx = getelementptr inbounds i16, i16* %b, i32 %ind
  %tmp = load i16, i16* %aidx, align 2
  store i16 %tmp, i16* %bidx, align 2
  %inc = add nuw i32 %ind, -128
  br label %for.body
}

;===------------------------------------------------------------------------===;
; LDS8STEP
;===------------------------------------------------------------------------===;

; CHECK-LABEL: lds8step:
; CHECK:       lds8step $m{{[0-9]+}}, $m15, $m{{[0-9]+}}+=, 1
define i32 @lds8step(i8* %a, i32 %len) {
entry:
  br label %for.body

for.body:
  %i.08 = phi i32 [ %inc, %for.body ], [ 0, %entry ]
  %sum.07 = phi i32 [ %add, %for.body ], [ 0, %entry ]
  %arrayidx = getelementptr inbounds i8, i8* %a, i32 %i.08
  %0 = load i8, i8* %arrayidx, align 1
  %conv = sext i8 %0 to i32
  %add = add nsw i32 %conv, %sum.07
  %inc = add nuw i32 %i.08, 1
  %exitcond = icmp eq i32 %inc, %len
  br i1 %exitcond, label %loopexit, label %for.body

loopexit:
  %sum = phi i32 [ %add, %for.body ]
  ret i32 %sum
}

;===------------------------------------------------------------------------===;
; LDS8STEP (with two base addresses)
;===------------------------------------------------------------------------===;

; CHECK-LABEL: lds8step_two_addrs:
; CHECK:       lds8step $m{{[0-9]+}}, $m{{[0-9]}}, $m{{[0-9]+}}+=, 1
define i32 @lds8step_two_addrs(i8 %a, i8 %b, i32 %len) {
entry:
  br label %for.body

for.body:
  %i.08 = phi i32 [ %inc, %for.body ], [ 0, %entry ]
  %sum.07 = phi i32 [ %add, %for.body ], [ 0, %entry ]
  %c = add nuw i8 %a, %b
  %absaddr = inttoptr i8 %c to i8*
  %arrayidx = getelementptr inbounds i8, i8* %absaddr, i32 %i.08
  %0 = load i8, i8* %arrayidx, align 1
  %conv = sext i8 %0 to i32
  %add = add nsw i32 %conv, %sum.07
  %inc = add nuw i32 %i.08, 1
  %exitcond = icmp eq i32 %inc, %len
  br i1 %exitcond, label %loopexit, label %for.body

loopexit:
  %sum = phi i32 [ %add, %for.body ]
  ret i32 %sum
}

;===------------------------------------------------------------------------===;
; LDZ8STEP
;===------------------------------------------------------------------------===;

; CHECK-LABEL: ldz8step:
; CHECK:       ldz8step $m{{[0-9]+}}, $m15, $m{{[0-9]+}}+=, 1
define i32 @ldz8step(i8* %a, i32 %len) {
entry:
  br label %for.body

for.body:
  %i.08 = phi i32 [ %inc, %for.body ], [ 0, %entry ]
  %sum.07 = phi i32 [ %add, %for.body ], [ 0, %entry ]
  %arrayidx = getelementptr inbounds i8, i8* %a, i32 %i.08
  %0 = load i8, i8* %arrayidx, align 1
  %conv = zext i8 %0 to i32
  %add = add i32 %conv, %sum.07
  %inc = add nuw i32 %i.08, 1
  %exitcond = icmp eq i32 %inc, %len
  br i1 %exitcond, label %loopexit, label %for.body

loopexit:
  %sum = phi i32 [ %add, %for.body ]
  ret i32 %sum
}

;===------------------------------------------------------------------------===;
; LDZ8STEP (with two base addresses)
;===------------------------------------------------------------------------===;

; CHECK-LABEL: ldz8step_two_addrs:
; CHECK:       ldz8step $m{{[0-9]+}}, $m{{[0-9]}}, $m{{[0-9]+}}+=, 1
define i32 @ldz8step_two_addrs(i8 %a, i8 %b, i32 %len) {
entry:
  br label %for.body

for.body:
  %i.08 = phi i32 [ %inc, %for.body ], [ 0, %entry ]
  %sum.07 = phi i32 [ %add, %for.body ], [ 0, %entry ]
  %c = add nuw i8 %a, %b
  %absaddr = inttoptr i8 %c to i8*
  %arrayidx = getelementptr inbounds i8, i8* %absaddr, i32 %i.08
  %0 = load i8, i8* %arrayidx, align 1
  %conv = zext i8 %0 to i32
  %add = add i32 %conv, %sum.07
  %inc = add nuw i32 %i.08, 1
  %exitcond = icmp eq i32 %inc, %len
  br i1 %exitcond, label %loopexit, label %for.body

loopexit:
  %sum = phi i32 [ %add, %for.body ]
  ret i32 %sum
}


;===------------------------------------------------------------------------===;
; LDZ8STEP (max positive immediate)
;===------------------------------------------------------------------------===;

; CHECK-LABEL: ldz8step_max_pos_imm:
; CHECK:       [[LABEL:\.L[A-Z0-9_]+]]:
; CHECK:       ldz8step $m1, $m15, $m{{0|[2-9]+}}+=, 127
; CHECK:       $m10, __st8
; CHECK:       bri [[LABEL]]
define void @ldz8step_max_pos_imm(i8* %a, i8* %b) {
entry:
  br label %for.body
for.body:
  %ind = phi i32 [ %inc, %for.body ], [0, %entry ]
  %aidx = getelementptr inbounds i8, i8* %a, i32 %ind
  %bidx = getelementptr inbounds i8, i8* %b, i32 %ind
  %tmp = load i8, i8* %aidx, align 1
  store i8 %tmp, i8* %bidx, align 1
  %inc = add nuw i32 %ind, 127
  br label %for.body
}

;===------------------------------------------------------------------------===;
; LDZ8STEP (max negative immediate)
;===------------------------------------------------------------------------===;

; CHECK-LABEL: ldz8step_max_neg_imm:
; CHECK:       [[LABEL:\.L[A-Z0-9_]+]]:
; CHECK:       ldz8step $m1, $m15, $m{{0|[2-9]+}}+=, -128
; CHECK:       $m10, __st8
; CHECK:       bri [[LABEL]]
define void @ldz8step_max_neg_imm(i8* %a, i8* %b) {
entry:
  br label %for.body
for.body:
  %ind = phi i32 [ %inc, %for.body ], [0, %entry ]
  %aidx = getelementptr inbounds i8, i8* %a, i32 %ind
  %bidx = getelementptr inbounds i8, i8* %b, i32 %ind
  %tmp = load i8, i8* %aidx, align 1
  store i8 %tmp, i8* %bidx, align 1
  %inc = add nuw i32 %ind, -128
  br label %for.body
}

;===------------------------------------------------------------------------===;
; LDZ8STEP (out of range positive immediate)
;===------------------------------------------------------------------------===;

; CHECK-LABEL: ldz8step_oor_pos_imm:
; CHECK:       [[LABEL:\.L[A-Z0-9_]+]]:
; CHECK:       ldz8 $m{{[0-9]+}}, $m{{[0-9]+}}, $m15, 0
; CHECK:       $m10, __st8
; CHECK:       add
; CHECK:       add
; CHECK:       bri [[LABEL]]
define void @ldz8step_oor_pos_imm(i8* %a, i8* %b) {
entry:
  br label %for.body
for.body:
  %ind = phi i32 [ %inc, %for.body ], [0, %entry ]
  %aidx = getelementptr inbounds i8, i8* %a, i32 %ind
  %bidx = getelementptr inbounds i8, i8* %b, i32 %ind
  %tmp = load i8, i8* %aidx, align 1
  store i8 %tmp, i8* %bidx, align 1
  %inc = add nuw i32 %ind, 128
  br label %for.body
}

;===------------------------------------------------------------------------===;
; LDZ8STEP (out of range negative immediate)
;===------------------------------------------------------------------------===;

; CHECK-LABEL: ldz8step_oor_neg_imm:
; CHECK:       [[LABEL:\.L[A-Z0-9_]+]]:
; CHECK:       ldz8 $m{{[0-9]+}}, $m{{[0-9]+}}, $m15, 0
; CHECK:       $m10, __st8
; CHECK:       add
; CHECK:       add
; CHECK:       bri [[LABEL]]
define void @ldz8step_oor_neg_imm(i8* %a, i8* %b) {
entry:
  br label %for.body
for.body:
  %ind = phi i32 [ %inc, %for.body ], [0, %entry ]
  %aidx = getelementptr inbounds i8, i8* %a, i32 %ind
  %bidx = getelementptr inbounds i8, i8* %b, i32 %ind
  %tmp = load i8, i8* %aidx, align 1
  store i8 %tmp, i8* %bidx, align 1
  %inc = add nuw i32 %ind, -129
  br label %for.body
}

;===-----------------------------------------------------------------------===;
; LD32STEP (with two base addresses) + use of new index
;===-----------------------------------------------------------------------===;

%structA = type { [102400 x i8], %structB }
%structB = type { %structA*, i8 }

; CHECK-LABEL: ld32step_two_addrs_idx_use:
; CHECK:      add $m11, $m11, -8
; CHECK:      st32 $m10, $m11, $m15, 1
; CHECK-NEXT: st32 $m7, $m11, $m15, 0
; CHECK-NEXT: mov     $m7, $m0
; CHECK-NEXT: setzi $m0, 102400
; CHECK-NEXT: ld32step $m1, $m7, $m0+=, 1
; CHECK-NEXT: add $m0, $m7, $m0
; CHECK-NEXT: mov     $m1, $m15
; CHECK-NEXT: call $m10, __st8
; CHECK-NEXT: mov     $m0, $m7
; CHECK-NEXT: ld32 $m7, $m11, $m15, 0
; CHECK-NEXT: ld32 $m10, $m11, $m15, 1
; CHECK-NEXT: add $m11, $m11, 8
; CHECK:      br $m10
define %structA* @ld32step_two_addrs_idx_use(%structA* %0) {
  %2 = getelementptr inbounds %structA, %structA* %0, i32 0, i32 1, i32 0
  %3 = load volatile %structA*, %structA** %2, align 4
  %4 = getelementptr inbounds %structA, %structA* %0, i32 0, i32 1, i32 1
  store i8 0, i8* %4, align 4
  ret %structA* %0
}
