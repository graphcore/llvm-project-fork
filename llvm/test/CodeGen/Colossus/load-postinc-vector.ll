; RUN: llc < %s -march=colossus -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -march=colossus -mattr=+ipu2 | FileCheck %s

; Test lowering of post-incrementing loads of vector types.

; These tests only check for the appropriate postinc instruction
; The IR is minimised - a simple infinite loop for each case

; CHECK-LABEL: ldstep_v4f16_inc_p1:
; CHECK:       [[LABEL:\.L[A-Z0-9_]+]]:
; CHECK:       ld64step $a0:1, $m15, $m{{[0-9]+}}+=, 1
; CHECK-NEXT:  st64step $a0:1, $m15, $m{{[0-9]+}}+=, 1
; CHECK-NEXT:  bri [[LABEL]]
define void @ldstep_v4f16_inc_p1(<4 x half>* %a, <4 x half>* %b) {
entry:
  br label %for.body
for.body:
  %ind = phi i32 [ %inc, %for.body ], [0, %entry ]
  %aidx = getelementptr inbounds <4 x half>, <4 x half>* %a, i32 %ind
  %bidx = getelementptr inbounds <4 x half>, <4 x half>* %b, i32 %ind
  %tmp = load <4 x half>, <4 x half>* %aidx, align 8
  store <4 x half> %tmp, <4 x half>* %bidx, align 8
  %inc = add nuw i32 %ind, 1
  br label %for.body
}

; CHECK-LABEL: ldstep_v4f16_inc_p127:
; CHECK:       [[LABEL:\.L[A-Z0-9_]+]]:
; CHECK:       ld64step $a0:1, $m15, $m{{[0-9]+}}+=, 127
; CHECK-NEXT:  st64step $a0:1, $m15, $m{{[0-9]+}}+=, 127
; CHECK-NEXT:  bri [[LABEL]]
define void @ldstep_v4f16_inc_p127(<4 x half>* %a, <4 x half>* %b) {
entry:
  br label %for.body
for.body:
  %ind = phi i32 [ %inc, %for.body ], [0, %entry ]
  %aidx = getelementptr inbounds <4 x half>, <4 x half>* %a, i32 %ind
  %bidx = getelementptr inbounds <4 x half>, <4 x half>* %b, i32 %ind
  %tmp = load <4 x half>, <4 x half>* %aidx, align 8
  store <4 x half> %tmp, <4 x half>* %bidx, align 8
  %inc = add nuw i32 %ind, 127
  br label %for.body
}

; CHECK-LABEL: ldstep_v4f16_inc_n128:
; CHECK:       [[LABEL:\.L[A-Z0-9_]+]]:
; CHECK:       ld64step $a0:1, $m15, $m{{[0-9]+}}+=, -128
; CHECK-NEXT:  st64step $a0:1, $m15, $m{{[0-9]+}}+=, -128
; CHECK-NEXT:  bri [[LABEL]]
define void @ldstep_v4f16_inc_n128(<4 x half>* %a, <4 x half>* %b) {
entry:
  br label %for.body
for.body:
  %ind = phi i32 [ %inc, %for.body ], [0, %entry ]
  %aidx = getelementptr inbounds <4 x half>, <4 x half>* %a, i32 %ind
  %bidx = getelementptr inbounds <4 x half>, <4 x half>* %b, i32 %ind
  %tmp = load <4 x half>, <4 x half>* %aidx, align 8
  store <4 x half> %tmp, <4 x half>* %bidx, align 8
  %inc = add nuw i32 %ind, -128
  br label %for.body
}

; CHECK-LABEL: ldstep_v4f16_inc_p128:
; CHECK:       [[LABEL:\.L[A-Z0-9_]+]]:
; CHECK:       ld64 $a0:1, $m{{[0-9]+}}, $m15, 0
; CHECK:       add
; CHECK:       add
; CHECK-NEXT:  bri [[LABEL]]
define void @ldstep_v4f16_inc_p128(<4 x half>* %a, <4 x half>* %b) {
entry:
  br label %for.body
for.body:
  %ind = phi i32 [ %inc, %for.body ], [0, %entry ]
  %aidx = getelementptr inbounds <4 x half>, <4 x half>* %a, i32 %ind
  %bidx = getelementptr inbounds <4 x half>, <4 x half>* %b, i32 %ind
  %tmp = load <4 x half>, <4 x half>* %aidx, align 8
  store <4 x half> %tmp, <4 x half>* %bidx, align 8
  %inc = add nuw i32 %ind, 128
  br label %for.body
}

; CHECK-LABEL: ldstep_v4f16_inc_n129:
; CHECK:       [[LABEL:\.L[A-Z0-9_]+]]:
; CHECK:       ld64 $a0:1, $m{{[0-9]+}}, $m15, 0
; CHECK:       add
; CHECK:       add
; CHECK-NEXT:  bri [[LABEL]]
define void @ldstep_v4f16_inc_n129(<4 x half>* %a, <4 x half>* %b) {
entry:
  br label %for.body
for.body:
  %ind = phi i32 [ %inc, %for.body ], [0, %entry ]
  %aidx = getelementptr inbounds <4 x half>, <4 x half>* %a, i32 %ind
  %bidx = getelementptr inbounds <4 x half>, <4 x half>* %b, i32 %ind
  %tmp = load <4 x half>, <4 x half>* %aidx, align 8
  store <4 x half> %tmp, <4 x half>* %bidx, align 8
  %inc = add nuw i32 %ind, -129
  br label %for.body
}

; CHECK-LABEL: ldstep_v2f32_inc_p1:
; CHECK:       [[LABEL:\.L[A-Z0-9_]+]]:
; CHECK:       ld64step $a0:1, $m15, $m{{[0-9]+}}+=, 1
; CHECK-NEXT:  st64step $a0:1, $m15, $m{{[0-9]+}}+=, 1
; CHECK-NEXT:  bri [[LABEL]]
define void @ldstep_v2f32_inc_p1(<2 x float>* %a, <2 x float>* %b) {
entry:
  br label %for.body
for.body:
  %ind = phi i32 [ %inc, %for.body ], [0, %entry ]
  %aidx = getelementptr inbounds <2 x float>, <2 x float>* %a, i32 %ind
  %bidx = getelementptr inbounds <2 x float>, <2 x float>* %b, i32 %ind
  %tmp = load <2 x float>, <2 x float>* %aidx, align 8
  store <2 x float> %tmp, <2 x float>* %bidx, align 8
  %inc = add nuw i32 %ind, 1
  br label %for.body
}

; CHECK-LABEL: ldstep_v2f32_inc_p127:
; CHECK:       [[LABEL:\.L[A-Z0-9_]+]]:
; CHECK:       ld64step $a0:1, $m15, $m{{[0-9]+}}+=, 127
; CHECK-NEXT:  st64step $a0:1, $m15, $m{{[0-9]+}}+=, 127
; CHECK-NEXT:  bri [[LABEL]]
define void @ldstep_v2f32_inc_p127(<2 x float>* %a, <2 x float>* %b) {
entry:
  br label %for.body
for.body:
  %ind = phi i32 [ %inc, %for.body ], [0, %entry ]
  %aidx = getelementptr inbounds <2 x float>, <2 x float>* %a, i32 %ind
  %bidx = getelementptr inbounds <2 x float>, <2 x float>* %b, i32 %ind
  %tmp = load <2 x float>, <2 x float>* %aidx, align 8
  store <2 x float> %tmp, <2 x float>* %bidx, align 8
  %inc = add nuw i32 %ind, 127
  br label %for.body
}

; CHECK-LABEL: ldstep_v2f32_inc_n128:
; CHECK:       [[LABEL:\.L[A-Z0-9_]+]]:
; CHECK:       ld64step $a0:1, $m15, $m{{[0-9]+}}+=, -128
; CHECK-NEXT:  st64step $a0:1, $m15, $m{{[0-9]+}}+=, -128
; CHECK-NEXT:  bri [[LABEL]]
define void @ldstep_v2f32_inc_n128(<2 x float>* %a, <2 x float>* %b) {
entry:
  br label %for.body
for.body:
  %ind = phi i32 [ %inc, %for.body ], [0, %entry ]
  %aidx = getelementptr inbounds <2 x float>, <2 x float>* %a, i32 %ind
  %bidx = getelementptr inbounds <2 x float>, <2 x float>* %b, i32 %ind
  %tmp = load <2 x float>, <2 x float>* %aidx, align 8
  store <2 x float> %tmp, <2 x float>* %bidx, align 8
  %inc = add nuw i32 %ind, -128
  br label %for.body
}

; CHECK-LABEL: ldstep_v2f32_inc_p128:
; CHECK:       [[LABEL:\.L[A-Z0-9_]+]]:
; CHECK:       ld64 $a0:1, $m{{[0-9]+}}, $m15, 0
; CHECK:       add
; CHECK:       add
; CHECK-NEXT:  bri [[LABEL]]
define void @ldstep_v2f32_inc_p128(<2 x float>* %a, <2 x float>* %b) {
entry:
  br label %for.body
for.body:
  %ind = phi i32 [ %inc, %for.body ], [0, %entry ]
  %aidx = getelementptr inbounds <2 x float>, <2 x float>* %a, i32 %ind
  %bidx = getelementptr inbounds <2 x float>, <2 x float>* %b, i32 %ind
  %tmp = load <2 x float>, <2 x float>* %aidx, align 8
  store <2 x float> %tmp, <2 x float>* %bidx, align 8
  %inc = add nuw i32 %ind, 128
  br label %for.body
}

; CHECK-LABEL: ldstep_v2f32_inc_n129:
; CHECK:       [[LABEL:\.L[A-Z0-9_]+]]:
; CHECK:       ld64 $a0:1, $m{{[0-9]+}}, $m15, 0
; CHECK:       add
; CHECK:       add
; CHECK-NEXT:  bri [[LABEL]]
define void @ldstep_v2f32_inc_n129(<2 x float>* %a, <2 x float>* %b) {
entry:
  br label %for.body
for.body:
  %ind = phi i32 [ %inc, %for.body ], [0, %entry ]
  %aidx = getelementptr inbounds <2 x float>, <2 x float>* %a, i32 %ind
  %bidx = getelementptr inbounds <2 x float>, <2 x float>* %b, i32 %ind
  %tmp = load <2 x float>, <2 x float>* %aidx, align 8
  store <2 x float> %tmp, <2 x float>* %bidx, align 8
  %inc = add nuw i32 %ind, -129
  br label %for.body
}

; CHECK-LABEL: ldstep_v2f16_inc_p1:
; CHECK:       [[LABEL:\.L[A-Z0-9_]+]]:
; CHECK:       ld32step $a0, $m15, $m{{[0-9]+}}+=, 1
; CHECK-NEXT:  st32step $a0, $m15, $m{{[0-9]+}}+=, 1
; CHECK-NEXT:  bri [[LABEL]]
define void @ldstep_v2f16_inc_p1(<2 x half>* %a, <2 x half>* %b) {
entry:
  br label %for.body
for.body:
  %ind = phi i32 [ %inc, %for.body ], [0, %entry ]
  %aidx = getelementptr inbounds <2 x half>, <2 x half>* %a, i32 %ind
  %bidx = getelementptr inbounds <2 x half>, <2 x half>* %b, i32 %ind
  %tmp = load <2 x half>, <2 x half>* %aidx, align 4
  store <2 x half> %tmp, <2 x half>* %bidx, align 4
  %inc = add nuw i32 %ind, 1
  br label %for.body
}

; CHECK-LABEL: ldstep_v2f16_inc_p127:
; CHECK:       [[LABEL:\.L[A-Z0-9_]+]]:
; CHECK:       ld32step $a0, $m15, $m{{[0-9]+}}+=, 127
; CHECK-NEXT:  st32step $a0, $m15, $m{{[0-9]+}}+=, 127
; CHECK-NEXT:  bri [[LABEL]]
define void @ldstep_v2f16_inc_p127(<2 x half>* %a, <2 x half>* %b) {
entry:
  br label %for.body
for.body:
  %ind = phi i32 [ %inc, %for.body ], [0, %entry ]
  %aidx = getelementptr inbounds <2 x half>, <2 x half>* %a, i32 %ind
  %bidx = getelementptr inbounds <2 x half>, <2 x half>* %b, i32 %ind
  %tmp = load <2 x half>, <2 x half>* %aidx, align 4
  store <2 x half> %tmp, <2 x half>* %bidx, align 4
  %inc = add nuw i32 %ind, 127
  br label %for.body
}

; CHECK-LABEL: ldstep_v2f16_inc_n128:
; CHECK:       [[LABEL:\.L[A-Z0-9_]+]]:
; CHECK:       ld32step $a0, $m15, $m{{[0-9]+}}+=, -128
; CHECK-NEXT:  st32step $a0, $m15, $m{{[0-9]+}}+=, -128
; CHECK-NEXT:  bri [[LABEL]]
define void @ldstep_v2f16_inc_n128(<2 x half>* %a, <2 x half>* %b) {
entry:
  br label %for.body
for.body:
  %ind = phi i32 [ %inc, %for.body ], [0, %entry ]
  %aidx = getelementptr inbounds <2 x half>, <2 x half>* %a, i32 %ind
  %bidx = getelementptr inbounds <2 x half>, <2 x half>* %b, i32 %ind
  %tmp = load <2 x half>, <2 x half>* %aidx, align 4
  store <2 x half> %tmp, <2 x half>* %bidx, align 4
  %inc = add nuw i32 %ind, -128
  br label %for.body
}

; CHECK-LABEL: ldstep_v2f16_inc_p128:
; CHECK:       [[LABEL:\.L[A-Z0-9_]+]]:
; CHECK:      ld32 $a0, $m{{[0-9]+}}, $m15, 0
; CHECK-NEXT: st32 $a0, $m{{[0-9]+}}, $m15, 0
; CHECK:      add
; CHECK:      add
; CHECK-NEXT:  bri [[LABEL]]
define void @ldstep_v2f16_inc_p128(<2 x half>* %a, <2 x half>* %b) {
entry:
  br label %for.body
for.body:
  %ind = phi i32 [ %inc, %for.body ], [0, %entry ]
  %aidx = getelementptr inbounds <2 x half>, <2 x half>* %a, i32 %ind
  %bidx = getelementptr inbounds <2 x half>, <2 x half>* %b, i32 %ind
  %tmp = load <2 x half>, <2 x half>* %aidx, align 4
  store <2 x half> %tmp, <2 x half>* %bidx, align 4
  %inc = add nuw i32 %ind, 128
  br label %for.body
}

; CHECK-LABEL: ldstep_v2f16_inc_n129:
; CHECK:       [[LABEL:\.L[A-Z0-9_]+]]:
; CHECK:      ld32 $a0, $m{{[0-9]+}}, $m15, 0
; CHECK-NEXT: st32 $a0, $m{{[0-9]+}}, $m15, 0
; CHECK:      add
; CHECK:      add
; CHECK-NEXT:  bri [[LABEL]]
define void @ldstep_v2f16_inc_n129(<2 x half>* %a, <2 x half>* %b) {
entry:
  br label %for.body
for.body:
  %ind = phi i32 [ %inc, %for.body ], [0, %entry ]
  %aidx = getelementptr inbounds <2 x half>, <2 x half>* %a, i32 %ind
  %bidx = getelementptr inbounds <2 x half>, <2 x half>* %b, i32 %ind
  %tmp = load <2 x half>, <2 x half>* %aidx, align 4
  store <2 x half> %tmp, <2 x half>* %bidx, align 4
  %inc = add nuw i32 %ind, -129
  br label %for.body
}

; CHECK-LABEL: ldstep_v2i16_inc_p1:
; CHECK:       [[LABEL:\.L[A-Z0-9_]+]]:
; CHECK:      ld32step $m2, $m15, $m{{[0-1]|[3-9]+}}+=, 1
; CHECK-NEXT: st32step $m2, $m15, $m{{[0-1]|[3-9]+}}+=, 1
; CHECK-NEXT:  bri [[LABEL]]
define void @ldstep_v2i16_inc_p1(<2 x i16>* %a, <2 x i16>* %b) {
entry:
  br label %for.body
for.body:
  %ind = phi i32 [ %inc, %for.body ], [0, %entry ]
  %aidx = getelementptr inbounds <2 x i16>, <2 x i16>* %a, i32 %ind
  %bidx = getelementptr inbounds <2 x i16>, <2 x i16>* %b, i32 %ind
  %tmp = load <2 x i16>, <2 x i16>* %aidx, align 4
  store <2 x i16> %tmp, <2 x i16>* %bidx, align 4
  %inc = add nuw i32 %ind, 1
  br label %for.body
}

; CHECK-LABEL: ldstep_v2i16_inc_p127:
; CHECK:       [[LABEL:\.L[A-Z0-9_]+]]:
; CHECK:      ld32step $m2, $m15, $m{{[0-1]|[3-9]+}}+=, 127
; CHECK-NEXT: st32step $m2, $m15, $m{{[0-1]|[3-9]+}}+=, 127
; CHECK-NEXT:  bri [[LABEL]]
define void @ldstep_v2i16_inc_p127(<2 x i16>* %a, <2 x i16>* %b) {
entry:
  br label %for.body
for.body:
  %ind = phi i32 [ %inc, %for.body ], [0, %entry ]
  %aidx = getelementptr inbounds <2 x i16>, <2 x i16>* %a, i32 %ind
  %bidx = getelementptr inbounds <2 x i16>, <2 x i16>* %b, i32 %ind
  %tmp = load <2 x i16>, <2 x i16>* %aidx, align 4
  store <2 x i16> %tmp, <2 x i16>* %bidx, align 4
  %inc = add nuw i32 %ind, 127
  br label %for.body
}

; CHECK-LABEL: ldstep_v2i16_inc_n128:
; CHECK:       [[LABEL:\.L[A-Z0-9_]+]]:
; CHECK:      ld32step $m2, $m15, $m{{[0-1]|[3-9]+}}+=, -128
; CHECK-NEXT: st32step $m2, $m15, $m{{[0-1]|[3-9]+}}+=, -128
; CHECK-NEXT:  bri [[LABEL]]
define void @ldstep_v2i16_inc_n128(<2 x i16>* %a, <2 x i16>* %b) {
entry:
  br label %for.body
for.body:
  %ind = phi i32 [ %inc, %for.body ], [0, %entry ]
  %aidx = getelementptr inbounds <2 x i16>, <2 x i16>* %a, i32 %ind
  %bidx = getelementptr inbounds <2 x i16>, <2 x i16>* %b, i32 %ind
  %tmp = load <2 x i16>, <2 x i16>* %aidx, align 4
  store <2 x i16> %tmp, <2 x i16>* %bidx, align 4
  %inc = add nuw i32 %ind, -128
  br label %for.body
}

; CHECK-LABEL: ldstep_v2i16_inc_p128:
; CHECK:       [[LABEL:\.L[A-Z0-9_]+]]:
; CHECK:      ld32 $m2, $m{{[0-1]|[3-9]+}}, $m15, 0
; CHECK-NEXT: st32 $m2, $m{{[0-1]|[3-9]+}}, $m15, 0
; CHECK:      add
; CHECK:      add
; CHECK-NEXT:  bri [[LABEL]]
define void @ldstep_v2i16_inc_p128(<2 x i16>* %a, <2 x i16>* %b) {
entry:
  br label %for.body
for.body:
  %ind = phi i32 [ %inc, %for.body ], [0, %entry ]
  %aidx = getelementptr inbounds <2 x i16>, <2 x i16>* %a, i32 %ind
  %bidx = getelementptr inbounds <2 x i16>, <2 x i16>* %b, i32 %ind
  %tmp = load <2 x i16>, <2 x i16>* %aidx, align 4
  store <2 x i16> %tmp, <2 x i16>* %bidx, align 4
  %inc = add nuw i32 %ind, 128
  br label %for.body
}

; CHECK-LABEL: ldstep_v2i16_inc_n129:
; CHECK:       [[LABEL:\.L[A-Z0-9_]+]]:
; CHECK:      ld32 $m2, $m{{[0-1]|[3-9]+}}, $m15, 0
; CHECK-NEXT: st32 $m2, $m{{[0-1]|[3-9]+}}, $m15, 0
; CHECK:      add
; CHECK:      add
; CHECK-NEXT:  bri [[LABEL]]
define void @ldstep_v2i16_inc_n129(<2 x i16>* %a, <2 x i16>* %b) {
entry:
  br label %for.body
for.body:
  %ind = phi i32 [ %inc, %for.body ], [0, %entry ]
  %aidx = getelementptr inbounds <2 x i16>, <2 x i16>* %a, i32 %ind
  %bidx = getelementptr inbounds <2 x i16>, <2 x i16>* %b, i32 %ind
  %tmp = load <2 x i16>, <2 x i16>* %aidx, align 4
  store <2 x i16> %tmp, <2 x i16>* %bidx, align 4
  %inc = add nuw i32 %ind, -129
  br label %for.body
}
