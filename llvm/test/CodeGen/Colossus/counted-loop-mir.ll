; CFG Simplification merges the cleanup into the entry block in
; begin_without_end which leads the intrinsics to be removed altogether in isel
; and the test to fail. We prevent this by starting the optimization pipeline
; after CFG simplification has run. Ideally we would want to use
; -start-after=loop-simplifycfg but this segfaults so we start before the Safe
; Stack instrumentation pass which is shortly after it.
; RUN: llc < %s -march=colossus -mattr=+ipu1 -start-before=safe-stack | FileCheck %s
; RUN: llc < %s -march=colossus -mattr=+ipu1 -start-before=safe-stack -colossus-cloop-enable-mir=false | FileCheck %s -check-prefix=NOMIR
; RUN: llc < %s -march=colossus -mattr=+ipu1 -colossus-cloop-enable-brnzdec=false -colossus-cloop-enable-rpt=false | FileCheck %s -check-prefix=FALLBACK
; RUN: llc < %s -march=colossus -mattr=+ipu1 -colossus-cloop-enable-brnzdec=true -colossus-cloop-enable-rpt=false | FileCheck %s -check-prefix=BRNZDEC
; RUN: llc < %s -march=colossus -mattr=+ipu1 -colossus-cloop-enable-brnzdec=false -colossus-cloop-enable-rpt=true | FileCheck %s -check-prefix=RPT

declare i32 @llvm.colossus.cloop.begin(i32, i32)
declare {i32, i32} @llvm.colossus.cloop.end(i32, i32)

; CHECK-LABEL: begin_without_end:
; CHECK:       # %bb
; CHECK-NEXT:  mov $m1, $m0
; CHECK-NEXT:  [[LABEL:\.L[A-Z0-9_]+]]:
; NOMIR-LABEL: begin_without_end:
; NOMIR:       # %bb
; NOMIR-NEXT:  # CLOOP_BEGIN_VALUE $m0, $m0, 0
; NOMIR-NEXT:  mov $m1, $m0
; NOMIR-NEXT:  # CLOOP_BEGIN_TERMINATOR $m0, 0
define i32 @begin_without_end(i32 %N) {
entry:
  %cloop_begin = call i32 @llvm.colossus.cloop.begin(i32 %N, i32 0)
  br label %body
body:
  %iv = phi i32 [%updated, %body], [%cloop_begin, %entry]
  %updated = sub i32 %iv, 1
  %cc = icmp sgt i32 %updated, 0
  br i1 %cc, label %body, label %cleanup
cleanup:
  ret i32 %cloop_begin
}

; CHECK-LABEL: end_without_begin:
; CHECK:       # %bb
; CHECK-NEXT:  [[LABEL:\.L[A-Z0-9_]+]]:
; CHECK:       add $m0, $m0, -1
; CHECK-NEXT:  brnz $m0, [[LABEL]]
; CHECK-NEXT:  # %bb
; CHECK-NEXT:  br $m10
; NOMIR-LABEL: end_without_begin:
; NOMIR:       # %bb
; NOMIR-NEXT:  [[LABEL:\.L[A-Z0-9_]+]]:
; NOMIR:       # CLOOP_END_VALUE $m0, $m0, 0
; NOMIR-NEXT:  # CLOOP_END_BRANCH $m0, [[LABEL]], 0
; NOMIR-NEXT:  # %bb
; NOMIR-NEXT:  br $m10
define void @end_without_begin(i32 %N) {
entry:
  br label %body
body:  
  %cloop.phi = phi i32 [ %cloop.end.iv, %body ], [ %N, %entry ]
  %cloop.end = call { i32, i32 } @llvm.colossus.cloop.end(i32 %cloop.phi, i32 0)
  %cloop.end.iv = extractvalue { i32, i32 } %cloop.end, 0
  %cloop.end.cc = extractvalue { i32, i32 } %cloop.end, 1   
  %t = trunc i32 %cloop.end.cc to i1
  br i1 %t, label %body, label %cleanup
cleanup:
  ret void
}

; NOMIR-LABEL: simple_loop:
; NOMIR:       # %bb
; NOMIR-NEXT:  cmpslt $m3, $m0, 1
; NOMIR-NEXT:  brnz $m3, [[LABEL_END:\.L[A-Z0-9_]+]]
; NOMIR-NEXT:  # %bb
; NOMIR-NEXT:  # CLOOP_BEGIN_VALUE $m0, $m0, 0
; NOMIR-NEXT:  # CLOOP_BEGIN_TERMINATOR $m0, 0
; NOMIR-NEXT:  [[LABEL_LOOP:\.L[A-Z0-9_]+]]:
; NOMIR:       ld64 $a0:1, $m1, $m15, 0
; NOMIR-NEXT:  # CLOOP_END_VALUE $m0, $m0, 0
; NOMIR-NEXT:  st64 $a0:1, $m2, $m15, 0
; NOMIR-NEXT:  # CLOOP_END_BRANCH $m0, [[LABEL_LOOP]], 0
; NOMIR-NEXT:  [[LABEL_END]]:
; NOMIR-NEXT:  br $m10
; FALLBACK-LABEL: simple_loop:
; FALLBACK:       # %bb
; FALLBACK-NEXT:  cmpslt $m3, $m0, 1
; FALLBACK-NEXT:  brnz $m3, [[LABEL_END:\.L[A-Z0-9_]+]]
; FALLBACK-NEXT:  # %bb
; FALLBACK-NEXT:  [[LABEL_LOOP:\.L[A-Z0-9_]+]]:
; FALLBACK:       ld64 $a0:1, $m1, $m15, 0
; FALLBACK-NEXT:  add $m0, $m0, -1
; FALLBACK-NEXT:  st64 $a0:1, $m2, $m15, 0
; FALLBACK-NEXT:  brnz $m0, [[LABEL_LOOP]]
; FALLBACK-NEXT:  [[LABEL_END]]:
; FALLBACK-NEXT:  br $m10
; BRNZDEC-LABEL: simple_loop:
; BRNZDEC:       # %bb
; BRNZDEC-NEXT:  cmpslt $m3, $m0, 1
; BRNZDEC-NEXT:  brnz $m3, [[LABEL_END:\.L[A-Z0-9_]+]]
; BRNZDEC-NEXT:  # %bb
; BRNZDEC-NEXT:  add $m0, $m0, -1
; BRNZDEC-NEXT:  [[LABEL_LOOP:\.L[A-Z0-9_]+]]:
; BRNZDEC:       ld64 $a0:1, $m1, $m15, 0
; BRNZDEC-NEXT:  st64 $a0:1, $m2, $m15, 0
; BRNZDEC-NEXT:  brnzdec $m0, [[LABEL_LOOP]]
; BRNZDEC-NEXT:  [[LABEL_END]]:
; BRNZDEC-NEXT:  br $m10
define void @simple_loop(i32 %N, <2 x float>* %x, <2 x float>* %y) {
entry:
  %cmp3 = icmp sgt i32 %N, 0
  br i1 %cmp3, label %for.body.preheader, label %for.cond.cleanup
for.body.preheader:
  %cloop.begin = call i32 @llvm.colossus.cloop.begin(i32 %N, i32 0)
  br label %for.body
for.body:
  %cloop.phi = phi i32 [ %cloop.end.iv, %for.body ], [ %cloop.begin, %for.body.preheader ]
  %0 = load <2 x float>, <2 x float>* %x
  store <2 x float> %0, <2 x float>* %y
  %cloop.end = call { i32, i32 } @llvm.colossus.cloop.end(i32 %cloop.phi, i32 0)
  %cloop.end.iv = extractvalue { i32, i32 } %cloop.end, 0
  %cloop.end.cc = extractvalue { i32, i32 } %cloop.end, 1
  %cloop.end.cc.trunc = trunc i32 %cloop.end.cc to i1
  br i1 %cloop.end.cc.trunc, label %for.body, label %for.cond.cleanup
for.cond.cleanup:
  ret void
}

; This tests the execution path where setzi is removed and inserted back with
; the previous operand value - 1 while doing brnzdec optimisation.
;
; NOMIR-LABEL: simple_loop_setzi:
; NOMIR:       # %bb
; NOMIR-NEXT:  setzi $m2, 128
; NOMIR-NEXT:  # CLOOP_BEGIN_VALUE $m2, $m2, 0
; NOMIR-NEXT:  # CLOOP_BEGIN_TERMINATOR $m2, 0
; NOMIR-NEXT:  [[LABEL_LOOP:\.L[A-Z0-9_]+]]:
; NOMIR:       ld64 $a0:1, $m0, $m15, 0
; NOMIR-NEXT:  # CLOOP_END_VALUE $m2, $m2, 0
; NOMIR-NEXT:  st64 $a0:1, $m1, $m15, 0
; NOMIR-NEXT:  # CLOOP_END_BRANCH $m2, [[LABEL_LOOP]], 0
; NOMIR-NEXT:  # %bb
; NOMIR-NEXT:  br $m10
; FALLBACK-LABEL: simple_loop_setzi:
; FALLBACK:       # %bb
; FALLBACK-NEXT:  setzi $m2, 128
; FALLBACK-NEXT:  [[LABEL_LOOP:\.L[A-Z0-9_]+]]:
; FALLBACK:       ld64 $a0:1, $m0, $m15, 0
; FALLBACK-NEXT:  add $m2, $m2, -1
; FALLBACK-NEXT:  st64 $a0:1, $m1, $m15, 0
; FALLBACK-NEXT:  brnz $m2, [[LABEL_LOOP]]
; FALLBACK-NEXT:  # %bb
; FALLBACK-NEXT:  br $m10
; BRNZDEC-LABEL: simple_loop_setzi:
; BRNZDEC:       # %bb
; BRNZDEC-NEXT:  setzi $m2, 127
; BRNZDEC-NEXT:  [[LABEL_LOOP:\.L[A-Z0-9_]+]]:
; BRNZDEC:       ld64 $a0:1, $m0, $m15, 0
; BRNZDEC-NEXT:  st64 $a0:1, $m1, $m15, 0
; BRNZDEC-NEXT:  brnzdec $m2, [[LABEL_LOOP]]
; BRNZDEC-NEXT:  # %bb
; BRNZDEC-NEXT:  br $m10
define void @simple_loop_setzi(<2 x float>* %x, <2 x float>* %y) {
entry:
  %cloop.begin = call i32 @llvm.colossus.cloop.begin(i32 128, i32 0)
  br label %for.body
for.body:
  %cloop.phi = phi i32 [ %cloop.end.iv, %for.body ], [ %cloop.begin, %entry ]
  %0 = load <2 x float>, <2 x float>* %x
  store <2 x float> %0, <2 x float>* %y
  %cloop.end = call { i32, i32 } @llvm.colossus.cloop.end(i32 %cloop.phi, i32 0)
  %cloop.end.iv = extractvalue { i32, i32 } %cloop.end, 0
  %cloop.end.cc = extractvalue { i32, i32 } %cloop.end, 1
  %cloop.end.cc.trunc = trunc i32 %cloop.end.cc to i1
  br i1 %cloop.end.cc.trunc, label %for.body, label %for.cond.cleanup
for.cond.cleanup:
  ret void
}

; RPT-LABEL: simple_rpt_loop:
; RPT:       # %bb
; RPT-NEXT:  cmpslt $m3, $m0, 1
; RPT-NEXT:  brnz $m3, [[LABEL_END:\.L[A-Z0-9_]+]]
; RPT-NEXT:  # %bb
; RPT-NEXT:  # %bb
; RPT-NEXT:  {
; RPT-NEXT:  rpt $m0, 1
; RPT-NEXT:  fnop
; RPT-NEXT:  }
; RPT-NEXT:  {
; RPT-NEXT:  ld64 $a0:1, $m1, $m15, 0
; RPT-NEXT:  fnop
; RPT-NEXT:  }
; RPT-NEXT:  {
; RPT-NEXT:  st64 $a0:1, $m2, $m15, 0
; RPT-NEXT:  fnop
; RPT-NEXT:  }
; RPT-NEXT:  [[LABEL_END]]:
; RPT-NEXT:  br $m10
define void @simple_rpt_loop(i32 %N, <2 x float>* %x, <2 x float>* %y) {
entry:
  %cmp3 = icmp sgt i32 %N, 0
  br i1 %cmp3, label %for.body.preheader, label %for.cond.cleanup
for.body.preheader:
  %cloop.begin = call i32 @llvm.colossus.cloop.begin(i32 %N, i32 1)
  br label %for.body
for.body:
  %cloop.phi = phi i32 [ %cloop.end.iv, %for.body ], [ %cloop.begin, %for.body.preheader ]
  %0 = load <2 x float>, <2 x float>* %x
  store <2 x float> %0, <2 x float>* %y
  %cloop.end = call { i32, i32 } @llvm.colossus.cloop.end(i32 %cloop.phi, i32 1)
  %cloop.end.iv = extractvalue { i32, i32 } %cloop.end, 0
  %cloop.end.cc = extractvalue { i32, i32 } %cloop.end, 1
  %cloop.end.cc.trunc = trunc i32 %cloop.end.cc to i1
  br i1 %cloop.end.cc.trunc, label %for.body, label %for.cond.cleanup
for.cond.cleanup:
  ret void
}

; CHECK-LABEL: non_unary_metadata_prevents_repeat:
; CHECK-NOT:   rpt
; CHECK:       br $m10
define void @non_unary_metadata_prevents_repeat(i32 %N, <2 x float>* %x, <2 x float>* %y) {
entry:
  %cmp3 = icmp sgt i32 %N, 0
  br i1 %cmp3, label %for.body.preheader, label %for.cond.cleanup
for.body.preheader:
  %cloop.begin = call i32 @llvm.colossus.cloop.begin(i32 %N, i32 2)
  br label %for.body
for.body:
  %cloop.phi = phi i32 [ %cloop.end.iv, %for.body ], [ %cloop.begin, %for.body.preheader ]
  %cloop.end = call { i32, i32 } @llvm.colossus.cloop.end(i32 %cloop.phi, i32 2)
  %cloop.end.iv = extractvalue { i32, i32 } %cloop.end, 0
  %cloop.end.cc = extractvalue { i32, i32 } %cloop.end, 1
  %cloop.end.cc.trunc = trunc i32 %cloop.end.cc to i1
  br i1 %cloop.end.cc.trunc, label %for.body, label %for.cond.cleanup
for.cond.cleanup:
  ret void
}

; CHECK-LABEL: mismatched_metadata_prevents_repeat:
; CHECK-NOT:   rpt
; CHECK:       br $m10
define void @mismatched_metadata_prevents_repeat(i32 %N, <2 x float>* %x, <2 x float>* %y) {
entry:
  %cmp3 = icmp sgt i32 %N, 0
  br i1 %cmp3, label %for.body.preheader, label %for.cond.cleanup
for.body.preheader:
  %cloop.begin = call i32 @llvm.colossus.cloop.begin(i32 %N, i32 1)
  br label %for.body
for.body:
  %cloop.phi = phi i32 [ %cloop.end.iv, %for.body ], [ %cloop.begin, %for.body.preheader ]
  %cloop.end = call { i32, i32 } @llvm.colossus.cloop.end(i32 %cloop.phi, i32 0)
  %cloop.end.iv = extractvalue { i32, i32 } %cloop.end, 0
  %cloop.end.cc = extractvalue { i32, i32 } %cloop.end, 1
  %cloop.end.cc.trunc = trunc i32 %cloop.end.cc to i1
  br i1 %cloop.end.cc.trunc, label %for.body, label %for.cond.cleanup
for.cond.cleanup:
  ret void
}

; Known limitation of current codegen
; BRNZDEC-LABEL: redundant_addition:
; BRNZDEC:       # %bb
; BRNZDEC-NEXT:  cmpslt $m3, $m0, 1
; BRNZDEC-NEXT:  brnz $m3, [[LABEL_END:\.L[A-Z0-9_]+]]
; BRNZDEC-NEXT:  # %bb
; BRNZDEC-NEXT:  [[LABEL_LOOP:\.L[A-Z0-9_]+]]:
; BRNZDEC:       ld64 $a0:1, $m1, $m15, 0
; BRNZDEC-NEXT:  st64 $a0:1, $m2, $m15, 0
; BRNZDEC-NEXT:  brnzdec $m0, [[LABEL_LOOP]]
; BRNZDEC-NEXT:  [[LABEL_END]]:
; BRNZDEC-NEXT:  br $m10
define void @redundant_addition(i32 %argN, <2 x float>* %x, <2 x float>* %y) {
entry:
  %cmp3 = icmp sgt i32 %argN, 0
  br i1 %cmp3, label %for.body.preheader, label %for.cond.cleanup
for.body.preheader:
  %N = add i32 %argN, 1
  %cloop.begin = call i32 @llvm.colossus.cloop.begin(i32 %N, i32 0)
  br label %for.body
for.body:
  %cloop.phi = phi i32 [ %cloop.end.iv, %for.body ], [ %cloop.begin, %for.body.preheader ]
  %0 = load <2 x float>, <2 x float>* %x
  store <2 x float> %0, <2 x float>* %y
  %cloop.end = call { i32, i32 } @llvm.colossus.cloop.end(i32 %cloop.phi, i32 0)
  %cloop.end.iv = extractvalue { i32, i32 } %cloop.end, 0
  %cloop.end.cc = extractvalue { i32, i32 } %cloop.end, 1
  %cloop.end.cc.trunc = trunc i32 %cloop.end.cc to i1
  br i1 %cloop.end.cc.trunc, label %for.body, label %for.cond.cleanup
for.cond.cleanup:
  ret void
}

; CHECK-LABEL: invalid_repeat_loop_call:
; CHECK-NOT:   rpt
; CHECK:       [[LABEL_LOOP:\.L[A-Z0-9_]+]]:
; CHECK:       ld64 $a0:1, {{\$m[0-9]+}}, $m15, 0
; CHECK-NEXT:  call $m10, irreducible_call
; CHECK-NEXT:  st64 $a0:1, {{\$m[0-9]+}}, $m15, 0
; CHECK-NEXT:  brnzdec {{\$m[0-9]+}}, [[LABEL_LOOP]]
; CHECK-NOT:   rpt
; CHECK:       br $m10
declare <2 x float> @irreducible_call(<2 x float>)
define void @invalid_repeat_loop_call(i32 %N, <2 x float>* %x, <2 x float>* %y) {
entry:
  %cmp3 = icmp sgt i32 %N, 0
  br i1 %cmp3, label %for.body.preheader, label %for.cond.cleanup
for.body.preheader:
  %cloop.begin = call i32 @llvm.colossus.cloop.begin(i32 %N, i32 1)
  br label %for.body
for.body:
  %cloop.phi = phi i32 [ %cloop.end.iv, %for.body ], [ %cloop.begin, %for.body.preheader ]
  %0 = load <2 x float>, <2 x float>* %x
  %1 = call <2 x float> @irreducible_call(<2 x float> %0)
  store <2 x float> %1, <2 x float>* %y
  %cloop.end = call { i32, i32 } @llvm.colossus.cloop.end(i32 %cloop.phi, i32 1)
  %cloop.end.iv = extractvalue { i32, i32 } %cloop.end, 0
  %cloop.end.cc = extractvalue { i32, i32 } %cloop.end, 1
  %cloop.end.cc.trunc = trunc i32 %cloop.end.cc to i1
  br i1 %cloop.end.cc.trunc, label %for.body, label %for.cond.cleanup
for.cond.cleanup:
  ret void
}

; CHECK-LABEL: invalid_repeat_loop_inline_asm:
; CHECK-NOT:   rpt
; CHECK:       [[LABEL_LOOP:\.L[A-Z0-9_]+]]:
; CHECK:       # Doesn't parse this
; CHECK:       brnzdec {{\$m[0-9]+}}, [[LABEL_LOOP]]
; CHECK-NOT:   rpt
; CHECK:       br $m10
define void @invalid_repeat_loop_inline_asm(i32 %N, <2 x float>* %x, <2 x float>* %y) {
entry:
  %cmp3 = icmp sgt i32 %N, 0
  br i1 %cmp3, label %for.body.preheader, label %for.cond.cleanup
for.body.preheader:
  %cloop.begin = call i32 @llvm.colossus.cloop.begin(i32 %N, i32 1)
  br label %for.body
for.body:
  %cloop.phi = phi i32 [ %cloop.end.iv, %for.body ], [ %cloop.begin, %for.body.preheader ]
  call void asm  "# Doesn't parse this", "~{memory}"()
  %cloop.end = call { i32, i32 } @llvm.colossus.cloop.end(i32 %cloop.phi, i32 1)
  %cloop.end.iv = extractvalue { i32, i32 } %cloop.end, 0
  %cloop.end.cc = extractvalue { i32, i32 } %cloop.end, 1
  %cloop.end.cc.trunc = trunc i32 %cloop.end.cc to i1
  br i1 %cloop.end.cc.trunc, label %for.body, label %for.cond.cleanup
for.cond.cleanup:
  ret void
}

; CHECK-LABEL: invalid_repeat_loop:
; CHECK-NOT:   rpt
; CHECK:       [[LABEL_LOOP:\.L[A-Z0-9_]+]]: {{.*}}
; CHECK-NOT:   rpt
; CHECK:       brz {{\$m[0-9]+}}, [[LABEL_LOOP]]
; CHECK-NOT:   rpt
; CHECK:       br $m10
define void @invalid_repeat_loop(i64* readonly %in, i64* %out, i32 %len) {
entry:
  %and = and i32 %len, 4095
  %cmp27 = icmp eq i32 %and, 0
  br i1 %cmp27, label %for.cond.cleanup, label %for.body

for.cond.cleanup:
  ret void

for.body:
  %in.addr.030 = phi i64* [ %incdec.ptr, %for.body ], [ %in, %entry ]
  %out.addr.029 = phi i64* [ %incdec.ptr9, %for.body ], [ %out, %entry ]
  %i.028 = phi i32 [ %inc, %for.body ], [ 0, %entry ]
  %incdec.ptr = getelementptr inbounds i64, i64* %in.addr.030, i32 1
  %0 = bitcast i64* %in.addr.030 to i8*
  %loads.sroa.0.0..sroa_cast17 = bitcast i64* %in.addr.030 to float*
  %loads.sroa.0.0.copyload = load float, float* %loads.sroa.0.0..sroa_cast17, align 8
  %loads.sroa.5.0..sroa_idx = getelementptr inbounds i8, i8* %0, i32 4
  %loads.sroa.5.0..sroa_cast19 = bitcast i8* %loads.sroa.5.0..sroa_idx to float*
  %loads.sroa.5.0.copyload = load float, float* %loads.sroa.5.0..sroa_cast19, align 4
  %div = fdiv float 1.0, %loads.sroa.0.0.copyload
  %div2 = fdiv float 1.0, %loads.sroa.5.0.copyload
  %conv = fptoui float %div to i32
  %conv3 = fptoui float %div2 to i32
  %and4 = shl i32 %conv, 4
  %1 = and i32 %and4, 983040
  %and826 = and i32 %1, %conv3
  %and8 = zext i32 %and826 to i64
  %incdec.ptr9 = getelementptr inbounds i64, i64* %out.addr.029, i32 1
  store i64 %and8, i64* %out.addr.029, align 8
  %inc = add nuw nsw i32 %i.028, 1
  %exitcond = icmp eq i32 %inc, %and
  br i1 %exitcond, label %for.cond.cleanup, label %for.body
}
