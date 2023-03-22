; RUN: llc < %s -march=colossus -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -march=colossus -mattr=+ipu2 | FileCheck %s

; Test post incrementing stores of vector types.

; These tests only check for the appropriate postinc instruction
; The IR is minimised - a simple infinite loop for each case

; CHECK-LABEL: ststep_v4f16_inc_p1:
; CHECK:       # %bb.0:
; CHECK-NEXT:  [[LABEL:\.L[A-Z0-9_]+]]:
; CHECK:       st64step $a0:1, $m15, $m{{[0-9]+}}+=, 1
; CHECK-NEXT:  bri [[LABEL]]
define void @ststep_v4f16_inc_p1(<4 x half>* %a, <4 x half> %c) {
entry:
  br label %for.body
for.body:
  %ind = phi i32 [ %inc, %for.body ], [ 0, %entry ]
  %arrayidx = getelementptr inbounds <4 x half>, <4 x half>* %a, i32 %ind
  store <4 x half> %c, <4 x half>* %arrayidx, align 8
  %inc = add nuw i32 %ind, 1
  br label %for.body
}

; CHECK-LABEL: ststep_v4f16_inc_p127:
; CHECK:       # %bb.0:
; CHECK-NEXT:  [[LABEL:\.L[A-Z0-9_]+]]:
; CHECK:       st64step $a0:1, $m15, $m{{[0-9]+}}+=, 127
; CHECK-NEXT:  bri [[LABEL]]
define void @ststep_v4f16_inc_p127(<4 x half>* %a, <4 x half> %c) {
entry:
  br label %for.body
for.body:
  %ind = phi i32 [ %inc, %for.body ], [ 0, %entry ]
  %arrayidx = getelementptr inbounds <4 x half>, <4 x half>* %a, i32 %ind
  store <4 x half> %c, <4 x half>* %arrayidx, align 8
  %inc = add nuw i32 %ind, 127
  br label %for.body
}

; CHECK-LABEL: ststep_v4f16_inc_n128:
; CHECK:       # %bb.0:
; CHECK-NEXT:  [[LABEL:\.L[A-Z0-9_]+]]:
; CHECK:       st64step $a0:1, $m15, $m{{[0-9]+}}+=, -128
; CHECK-NEXT:  bri [[LABEL]]
define void @ststep_v4f16_inc_n128(<4 x half>* %a, <4 x half> %c) {
entry:
  br label %for.body
for.body:
  %ind = phi i32 [ %inc, %for.body ], [ 0, %entry ]
  %arrayidx = getelementptr inbounds <4 x half>, <4 x half>* %a, i32 %ind
  store <4 x half> %c, <4 x half>* %arrayidx, align 8
  %inc = add nuw i32 %ind, -128
  br label %for.body
}

; CHECK-LABEL: ststep_v4f16_inc_p128:
; CHECK:       # %bb.0:
; CHECK-NEXT:  [[LABEL:\.L[A-Z0-9_]+]]:
; CHECK:       st64 $a0:1, $m{{[0-9]+}}, $m15, 0
; CHECK:       add
; CHECK-NEXT:  bri [[LABEL]]
define void @ststep_v4f16_inc_p128(<4 x half>* %a, <4 x half> %c) {
entry:
  br label %for.body
for.body:
  %ind = phi i32 [ %inc, %for.body ], [ 0, %entry ]
  %arrayidx = getelementptr inbounds <4 x half>, <4 x half>* %a, i32 %ind
  store <4 x half> %c, <4 x half>* %arrayidx, align 8
  %inc = add nuw i32 %ind, 128
  br label %for.body
}

; CHECK-LABEL: ststep_v4f16_inc_n129:
; CHECK:       # %bb.0:
; CHECK-NEXT:  [[LABEL:\.L[A-Z0-9_]+]]:
; CHECK:       st64 $a0:1, $m{{[0-9]+}}, $m15, 0
; CHECK:       add
; CHECK-NEXT:  bri [[LABEL]]
define void @ststep_v4f16_inc_n129(<4 x half>* %a, <4 x half> %c) {
entry:
  br label %for.body
for.body:
  %ind = phi i32 [ %inc, %for.body ], [ 0, %entry ]
  %arrayidx = getelementptr inbounds <4 x half>, <4 x half>* %a, i32 %ind
  store <4 x half> %c, <4 x half>* %arrayidx, align 8
  %inc = add nuw i32 %ind, -129
  br label %for.body
}

; CHECK-LABEL: ststep_v2f32_inc_p1:
; CHECK:       # %bb.0:
; CHECK-NEXT:  [[LABEL:\.L[A-Z0-9_]+]]:
; CHECK:       st64step $a0:1, $m15, $m{{[0-9]+}}+=, 1
; CHECK-NEXT:  bri [[LABEL]]
define void @ststep_v2f32_inc_p1(<2 x float>* %a, <2 x float> %c) {
entry:
  br label %for.body
for.body:
  %ind = phi i32 [ %inc, %for.body ], [ 0, %entry ]
  %arrayidx = getelementptr inbounds <2 x float>, <2 x float>* %a, i32 %ind
  store <2 x float> %c, <2 x float>* %arrayidx, align 8
  %inc = add nuw i32 %ind, 1
  br label %for.body
}

; CHECK-LABEL: ststep_v2f32_inc_p127:
; CHECK:       # %bb.0:
; CHECK-NEXT:  [[LABEL:\.L[A-Z0-9_]+]]:
; CHECK:       st64step $a0:1, $m15, $m{{[0-9]+}}+=, 127
; CHECK-NEXT:  bri [[LABEL]]
define void @ststep_v2f32_inc_p127(<2 x float>* %a, <2 x float> %c) {
entry:
  br label %for.body
for.body:
  %ind = phi i32 [ %inc, %for.body ], [ 0, %entry ]
  %arrayidx = getelementptr inbounds <2 x float>, <2 x float>* %a, i32 %ind
  store <2 x float> %c, <2 x float>* %arrayidx, align 8
  %inc = add nuw i32 %ind, 127
  br label %for.body
}

; CHECK-LABEL: ststep_v2f32_inc_n128:
; CHECK:       # %bb.0:
; CHECK-NEXT:  [[LABEL:\.L[A-Z0-9_]+]]:
; CHECK:       st64step $a0:1, $m15, $m{{[0-9]+}}+=, -128
; CHECK-NEXT:  bri [[LABEL]]
define void @ststep_v2f32_inc_n128(<2 x float>* %a, <2 x float> %c) {
entry:
  br label %for.body
for.body:
  %ind = phi i32 [ %inc, %for.body ], [ 0, %entry ]
  %arrayidx = getelementptr inbounds <2 x float>, <2 x float>* %a, i32 %ind
  store <2 x float> %c, <2 x float>* %arrayidx, align 8
  %inc = add nuw i32 %ind, -128
  br label %for.body
}

; CHECK-LABEL: ststep_v2f32_inc_p128:
; CHECK:       # %bb.0:
; CHECK-NEXT:  [[LABEL:\.L[A-Z0-9_]+]]:
; CHECK:       st64 $a0:1, $m{{[0-9]+}}, $m15, 0
; CHECK:       add
; CHECK-NEXT:  bri [[LABEL]]
define void @ststep_v2f32_inc_p128(<2 x float>* %a, <2 x float> %c) {
entry:
  br label %for.body
for.body:
  %ind = phi i32 [ %inc, %for.body ], [ 0, %entry ]
  %arrayidx = getelementptr inbounds <2 x float>, <2 x float>* %a, i32 %ind
  store <2 x float> %c, <2 x float>* %arrayidx, align 8
  %inc = add nuw i32 %ind, 128
  br label %for.body
}

; CHECK-LABEL: ststep_v2f32_inc_n129:
; CHECK:       # %bb.0:
; CHECK-NEXT:  [[LABEL:\.L[A-Z0-9_]+]]:
; CHECK:       st64 $a0:1, $m{{[0-9]+}}, $m15, 0
; CHECK:       add
; CHECK-NEXT:  bri [[LABEL]]
define void @ststep_v2f32_inc_n129(<2 x float>* %a, <2 x float> %c) {
entry:
  br label %for.body
for.body:
  %ind = phi i32 [ %inc, %for.body ], [ 0, %entry ]
  %arrayidx = getelementptr inbounds <2 x float>, <2 x float>* %a, i32 %ind
  store <2 x float> %c, <2 x float>* %arrayidx, align 8
  %inc = add nuw i32 %ind, -129
  br label %for.body
}

; CHECK-LABEL: ststep_v2f16_inc_p1:
; CHECK:       # %bb.0:
; CHECK-NEXT:  [[LABEL:\.L[A-Z0-9_]+]]:
; CHECK:       st32step $a0, $m15, $m{{[0-9]+}}+=, 1
; CHECK-NEXT:  bri [[LABEL]]
define void @ststep_v2f16_inc_p1(<2 x half>* %a, <2 x half> %c) {
entry:
  br label %for.body
for.body:
  %ind = phi i32 [ %inc, %for.body ], [ 0, %entry ]
  %arrayidx = getelementptr inbounds <2 x half>, <2 x half>* %a, i32 %ind
  store <2 x half> %c, <2 x half>* %arrayidx, align 4
  %inc = add nuw i32 %ind, 1
  br label %for.body
}

; CHECK-LABEL: ststep_v2f16_inc_p127:
; CHECK:       # %bb.0:
; CHECK-NEXT:  [[LABEL:\.L[A-Z0-9_]+]]:
; CHECK:       st32step $a0, $m15, $m{{[0-9]+}}+=, 127
; CHECK-NEXT:  bri [[LABEL]]
define void @ststep_v2f16_inc_p127(<2 x half>* %a, <2 x half> %c) {
entry:
  br label %for.body
for.body:
  %ind = phi i32 [ %inc, %for.body ], [ 0, %entry ]
  %arrayidx = getelementptr inbounds <2 x half>, <2 x half>* %a, i32 %ind
  store <2 x half> %c, <2 x half>* %arrayidx, align 4
  %inc = add nuw i32 %ind, 127
  br label %for.body
}

; CHECK-LABEL: ststep_v2f16_inc_n128:
; CHECK:       # %bb.0:
; CHECK-NEXT:  [[LABEL:\.L[A-Z0-9_]+]]:
; CHECK:       st32step $a0, $m15, $m{{[0-9]+}}+=, -128
; CHECK-NEXT:  bri [[LABEL]]
define void @ststep_v2f16_inc_n128(<2 x half>* %a, <2 x half> %c) {
entry:
  br label %for.body
for.body:
  %ind = phi i32 [ %inc, %for.body ], [ 0, %entry ]
  %arrayidx = getelementptr inbounds <2 x half>, <2 x half>* %a, i32 %ind
  store <2 x half> %c, <2 x half>* %arrayidx, align 4
  %inc = add nuw i32 %ind, -128
  br label %for.body
}

; CHECK-LABEL: ststep_v2f16_inc_p128:
; CHECK:       # %bb.0:
; CHECK-NEXT:  [[LABEL:\.L[A-Z0-9_]+]]:
; CHECK:       st32 $a0, $m{{[0-9]+}}, $m15, 0
; CHECK:       add
; CHECK-NEXT:  bri [[LABEL]]
define void @ststep_v2f16_inc_p128(<2 x half>* %a, <2 x half> %c) {
entry:
  br label %for.body
for.body:
  %ind = phi i32 [ %inc, %for.body ], [ 0, %entry ]
  %arrayidx = getelementptr inbounds <2 x half>, <2 x half>* %a, i32 %ind
  store <2 x half> %c, <2 x half>* %arrayidx, align 4
  %inc = add nuw i32 %ind, 128
  br label %for.body
}

; CHECK-LABEL: ststep_v2f16_inc_n129:
; CHECK:       # %bb.0:
; CHECK-NEXT:  [[LABEL:\.L[A-Z0-9_]+]]:
; CHECK:       st32 $a0, $m{{[0-9]+}}, $m15, 0
; CHECK:       add
; CHECK-NEXT:  bri [[LABEL]]
define void @ststep_v2f16_inc_n129(<2 x half>* %a, <2 x half> %c) {
entry:
  br label %for.body
for.body:
  %ind = phi i32 [ %inc, %for.body ], [ 0, %entry ]
  %arrayidx = getelementptr inbounds <2 x half>, <2 x half>* %a, i32 %ind
  store <2 x half> %c, <2 x half>* %arrayidx, align 4
  %inc = add nuw i32 %ind, -129
  br label %for.body
}

; CHECK-LABEL: ststep_v2i16_inc_p1:
; CHECK:       # %bb.0:
; CHECK-NEXT:  [[LABEL:\.L[A-Z0-9_]+]]:
; CHECK:       st32step $m1, $m15, $m{{0|[2-9]+}}+=, 1
; CHECK-NEXT:  bri [[LABEL]]
define void @ststep_v2i16_inc_p1(<2 x i16>* %a, <2 x i16> %c) {
entry:
  br label %for.body
for.body:
  %ind = phi i32 [ %inc, %for.body ], [ 0, %entry ]
  %arrayidx = getelementptr inbounds <2 x i16>, <2 x i16>* %a, i32 %ind
  store <2 x i16> %c, <2 x i16>* %arrayidx, align 4
  %inc = add nuw i32 %ind, 1
  br label %for.body
}

; CHECK-LABEL: ststep_v2i16_inc_p127:
; CHECK:       # %bb.0:
; CHECK-NEXT:  [[LABEL:\.L[A-Z0-9_]+]]:
; CHECK:       st32step $m1, $m15, $m{{0|[2-9]+}}+=, 127
; CHECK-NEXT:  bri [[LABEL]]
define void @ststep_v2i16_inc_p127(<2 x i16>* %a, <2 x i16> %c) {
entry:
  br label %for.body
for.body:
  %ind = phi i32 [ %inc, %for.body ], [ 0, %entry ]
  %arrayidx = getelementptr inbounds <2 x i16>, <2 x i16>* %a, i32 %ind
  store <2 x i16> %c, <2 x i16>* %arrayidx, align 4
  %inc = add nuw i32 %ind, 127
  br label %for.body
}

; CHECK-LABEL: ststep_v2i16_inc_n128:
; CHECK:       # %bb.0:
; CHECK-NEXT:  [[LABEL:\.L[A-Z0-9_]+]]:
; CHECK:       st32step $m1, $m15, $m{{0|[2-9]+}}+=, -128
; CHECK-NEXT:  bri [[LABEL]]
define void @ststep_v2i16_inc_n128(<2 x i16>* %a, <2 x i16> %c) {
entry:
  br label %for.body
for.body:
  %ind = phi i32 [ %inc, %for.body ], [ 0, %entry ]
  %arrayidx = getelementptr inbounds <2 x i16>, <2 x i16>* %a, i32 %ind
  store <2 x i16> %c, <2 x i16>* %arrayidx, align 4
  %inc = add nuw i32 %ind, -128
  br label %for.body
}

; CHECK-LABEL: ststep_v2i16_inc_p128:
; CHECK:       # %bb.0:
; CHECK-NEXT:  [[LABEL:\.L[A-Z0-9_]+]]:
; CHECK:       st32 $m1, $m{{0|[2-9]+}}, $m15, 0
; CHECK:       add
; CHECK-NEXT:  bri [[LABEL]]
define void @ststep_v2i16_inc_p128(<2 x i16>* %a, <2 x i16> %c) {
entry:
  br label %for.body
for.body:
  %ind = phi i32 [ %inc, %for.body ], [ 0, %entry ]
  %arrayidx = getelementptr inbounds <2 x i16>, <2 x i16>* %a, i32 %ind
  store <2 x i16> %c, <2 x i16>* %arrayidx, align 4
  %inc = add nuw i32 %ind, 128
  br label %for.body
}

; CHECK-LABEL: ststep_v2i16_inc_n129:
; CHECK:       # %bb.0:
; CHECK-NEXT:  [[LABEL:\.L[A-Z0-9_]+]]:
; CHECK:       st32 $m1, $m{{0|[2-9]+}}, $m15, 0
; CHECK:       add
; CHECK-NEXT:  bri [[LABEL]]
define void @ststep_v2i16_inc_n129(<2 x i16>* %a, <2 x i16> %c) {
entry:
  br label %for.body
for.body:
  %ind = phi i32 [ %inc, %for.body ], [ 0, %entry ]
  %arrayidx = getelementptr inbounds <2 x i16>, <2 x i16>* %a, i32 %ind
  store <2 x i16> %c, <2 x i16>* %arrayidx, align 4
  %inc = add nuw i32 %ind, -129
  br label %for.body
}
