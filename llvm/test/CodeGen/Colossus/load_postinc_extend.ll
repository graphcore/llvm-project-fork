; RUN: llc < %s -mtriple=colossus -colossus-coissue=false -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -mtriple=colossus -colossus-coissue=false -mattr=+ipu2 | FileCheck %s


target triple = "colossus-graphcore--elf"
; These tests only check for the appropriate postinc instruction
; Similar to generated load_postinc.ll

; CHECK-LABEL: ldstep_f16_to_f32_inc_p1:
; CHECK:       [[LABEL:\.L[A-Z0-9_]+]]:
; CHECK:       ldb16step $a0, $m15, $m{{[0-9]+}}+=, 1
; CHECK-NEXT:  f16tof32 $a0, $a0
; CHECK-NEXT:  st32step $a0, $m15, $m{{[0-9]+}}+=, 1
; CHECK:       bri [[LABEL]]
define void @ldstep_f16_to_f32_inc_p1(half* %a, float* %b) {
entry:
  br label %for.body
for.body:
  %ind = phi i32 [ %inc, %for.body ], [0, %entry ]
  %aidx = getelementptr inbounds half, half* %a, i32 %ind
  %bidx = getelementptr inbounds float, float* %b, i32 %ind
  %tmp = load half, half* %aidx, align 2
  %tmp2 = fpext half %tmp to float
  store float %tmp2, float* %bidx, align 4
  %inc = add nuw i32 %ind, 1
  br label %for.body
}

declare float @llvm.experimental.constrained.fpext.f32.f16(half %src, metadata)

; CHECK-LABEL: ldstep_strict_f16_to_f32_inc_p1:
; CHECK:       [[LABEL:\.L[A-Z0-9_]+]]:
; CHECK:       ldb16step $a0, $m15, $m{{[0-9]+}}+=, 1
; CHECK-NEXT:  f16tof32 $a0, $a0
; CHECK-NEXT:  st32step $a0, $m15, $m{{[0-9]+}}+=, 1
; CHECK:       bri [[LABEL]]
define void @ldstep_strict_f16_to_f32_inc_p1(half* %a, float* %b) {
entry:
  br label %for.body
for.body:
  %ind = phi i32 [ %inc, %for.body ], [0, %entry ]
  %aidx = getelementptr inbounds half, half* %a, i32 %ind
  %bidx = getelementptr inbounds float, float* %b, i32 %ind
  %tmp = load half, half* %aidx, align 2
  %tmp2 = tail call float @llvm.experimental.constrained.fpext.f32.f16(half %tmp, metadata !"fpexcept.strict")
  store float %tmp2, float* %bidx, align 4
  %inc = add nuw i32 %ind, 1
  br label %for.body
}

; CHECK-LABEL: ldstep_i16_to_i32_zext_inc_p1:
; CHECK:       [[LABEL:\.L[A-Z0-9_]+]]:
; CHECK:       ldz16step [[REG:\$m[0-9]+]], $m15, $m{{[0-9]+}}+=, 1
; CHECK-NEXT:  st32step [[REG]], $m15, $m{{[0-9]+}}+=, 1
; CHECK:       bri [[LABEL]]
define void @ldstep_i16_to_i32_zext_inc_p1(i16* %a, i32* %b) {
entry:
  br label %for.body
for.body:
  %ind = phi i32 [ %inc, %for.body ], [0, %entry ]
  %aidx = getelementptr inbounds i16, i16* %a, i32 %ind
  %bidx = getelementptr inbounds i32, i32* %b, i32 %ind
  %tmp = load i16, i16* %aidx, align 2
  %tmp2 = zext i16 %tmp to i32
  store i32 %tmp2, i32* %bidx, align 4
  %inc = add nuw i32 %ind, 1
  br label %for.body
}

; CHECK-LABEL: ldstep_i16_to_i32_sext_inc_p1:
; CHECK:       [[LABEL:\.L[A-Z0-9_]+]]:
; CHECK:       lds16step [[REG:\$m[0-9]+]], $m15, $m{{[0-9]+}}+=, 1
; CHECK-NEXT:  st32step [[REG]], $m15, $m{{[0-9]+}}+=, 1
; CHECK:       bri [[LABEL]]
define void @ldstep_i16_to_i32_sext_inc_p1(i16* %a, i32* %b) {
entry:
  br label %for.body
for.body:
  %ind = phi i32 [ %inc, %for.body ], [0, %entry ]
  %aidx = getelementptr inbounds i16, i16* %a, i32 %ind
  %bidx = getelementptr inbounds i32, i32* %b, i32 %ind
  %tmp = load i16, i16* %aidx, align 2
  %tmp2 = sext i16 %tmp to i32
  store i32 %tmp2, i32* %bidx, align 4
  %inc = add nuw i32 %ind, 1
  br label %for.body
}

; CHECK-LABEL: ldstep_i8_to_i32_zext_inc_p1:
; CHECK:       [[LABEL:\.L[A-Z0-9_]+]]:
; CHECK:       ldz8step [[REG:\$m[0-9]+]], $m15, $m{{[0-9]+}}+=, 1
; CHECK-NEXT:  st32step [[REG]], $m15, $m{{[0-9]+}}+=, 1
; CHECK:       bri [[LABEL]]
define void @ldstep_i8_to_i32_zext_inc_p1(i8* %a, i32* %b) {
entry:
  br label %for.body
for.body:
  %ind = phi i32 [ %inc, %for.body ], [0, %entry ]
  %aidx = getelementptr inbounds i8, i8* %a, i32 %ind
  %bidx = getelementptr inbounds i32, i32* %b, i32 %ind
  %tmp = load i8, i8* %aidx, align 1
  %tmp2 = zext i8 %tmp to i32
  store i32 %tmp2, i32* %bidx, align 4
  %inc = add nuw i32 %ind, 1
  br label %for.body
}

; CHECK-LABEL: ldstep_i8_to_i32_sext_inc_p1:
; CHECK:       [[LABEL:\.L[A-Z0-9_]+]]:
; CHECK:       lds8step [[REG:\$m[0-9]+]], $m15, $m{{[0-9]+}}+=, 1
; CHECK-NEXT:  st32step [[REG]], $m15, $m{{[0-9]+}}+=, 1
; CHECK:       bri [[LABEL]]
define void @ldstep_i8_to_i32_sext_inc_p1(i8* %a, i32* %b) {
entry:
  br label %for.body
for.body:
  %ind = phi i32 [ %inc, %for.body ], [0, %entry ]
  %aidx = getelementptr inbounds i8, i8* %a, i32 %ind
  %bidx = getelementptr inbounds i32, i32* %b, i32 %ind
  %tmp = load i8, i8* %aidx, align 1
  %tmp2 = sext i8 %tmp to i32
  store i32 %tmp2, i32* %bidx, align 4
  %inc = add nuw i32 %ind, 1
  br label %for.body
}

; CHECK-LABEL: ldstep_i8_to_i16_zext_inc_p1:
; CHECK:       [[LABEL:\.L[A-Z0-9_]+]]:
; CHECK:       ldz8step [[REG:\$m[0-9]+]], $m15, $m{{[0-9]+}}+=, 1
; CHECK:       call $m10, __st16
; CHECK:       bri [[LABEL]]
define void @ldstep_i8_to_i16_zext_inc_p1(i8* %a, i16* %b) {
entry:
  br label %for.body
for.body:
  %ind = phi i32 [ %inc, %for.body ], [0, %entry ]
  %aidx = getelementptr inbounds i8, i8* %a, i32 %ind
  %bidx = getelementptr inbounds i16, i16* %b, i32 %ind
  %tmp = load i8, i8* %aidx, align 1
  %tmp2 = zext i8 %tmp to i16
  store i16 %tmp2, i16* %bidx, align 4
  %inc = add nuw i32 %ind, 1
  br label %for.body
}

; CHECK-LABEL: ldstep_i8_to_i16_sext_inc_p1:
; CHECK:       [[LABEL:\.L[A-Z0-9_]+]]:
; CHECK:       lds8step [[REG:\$m[0-9]+]], $m15, $m{{[0-9]+}}+=, 1
; CHECK:       call $m10, __st16
; CHECK:       bri [[LABEL]]
define void @ldstep_i8_to_i16_sext_inc_p1(i8* %a, i16* %b) {
entry:
  br label %for.body
for.body:
  %ind = phi i32 [ %inc, %for.body ], [0, %entry ]
  %aidx = getelementptr inbounds i8, i8* %a, i32 %ind
  %bidx = getelementptr inbounds i16, i16* %b, i32 %ind
  %tmp = load i8, i8* %aidx, align 1
  %tmp2 = sext i8 %tmp to i16
  store i16 %tmp2, i16* %bidx, align 4
  %inc = add nuw i32 %ind, 1
  br label %for.body
}

