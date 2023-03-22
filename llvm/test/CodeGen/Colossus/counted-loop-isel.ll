; CFG Simplification merges the cleanup into the entry block in many of the
; functions below which leads the intrinsics to be removed altogether in isel
; and the tests to fail. We prevent this by starting the optimization pipeline
; after CFG simplification has run. Ideally we would want to use
; -start-after=loop-simplifycfg but this segfaults so we start before the Safe
; Stack instrumentation pass which is shortly after it.
; RUN: llc < %s -march=colossus -start-before=safe-stack -colossus-cloop-enable-mir=false | FileCheck %s
; RUN: llc < %s -march=colossus -start-before=safe-stack -colossus-cloop-enable-mir=false -colossus-cloop-enable-isel=false | FileCheck %s -check-prefix=NOISEL

declare i32 @llvm.colossus.cloop.begin(i32, i32)
declare {i32, i32} @llvm.colossus.cloop.end(i32, i32)

; cloop.begin is expected to be in a basic block that ends with an unconditional
; branch. This may be elided during IR=>ISel, in which case the basic block
; will end with a tokenfactor combining the chain from the intrinsic and the
; chain from a copytoreg copying the value into the next block

; the fallback for cloop.begin is to delete the intrinsic, leaving the copytoreg
; to propagate the counter unchanged into the next basic block

; cloop.end is expected to be in a basic block that ends with a conditional
; branch based on the second return value of the intrinsic (truncated to i1)
; where the argument to cloop.end is a phi node taking either the loop count
; or the first return value of cloop.end

; the fallback is to replace the intrinsic with a subtract one and setcc ne,
; which combined with the trailing brcond will provide the correct number of
; loop iterations

; CHECK-LABEL: simple_loop:
; CHECK:       # %bb
; CHECK-NEXT:  cmpslt $m3, $m0, 1
; CHECK-NEXT:  brnz $m3, [[LABEL_END:\.L[A-Z0-9_]+]]
; CHECK-NEXT:  # %bb
; CHECK-NEXT:  # CLOOP_BEGIN_VALUE $m0, $m0, 0
; CHECK-NEXT:  # CLOOP_BEGIN_TERMINATOR $m0, 0
; CHECK-NEXT:  [[LABEL_LOOP:\.L[A-Z0-9_]+]]:
; CHECK:       ld64 $a0:1, $m1, $m15, 0
; CHECK-NEXT:  # CLOOP_END_VALUE $m0, $m0, 0
; CHECK-NEXT:  st64 $a0:1, $m2, $m15, 0
; CHECK-NEXT:  # CLOOP_END_BRANCH $m0, [[LABEL_LOOP]], 0
; CHECK-NEXT:  [[LABEL_END]]:
; CHECK-NEXT:  br $m10
; NOISEL-LABEL: simple_loop:
; NOISEL:       # %bb
; NOISEL-NEXT:  cmpslt $m3, $m0, 1
; NOISEL-NEXT:  brnz $m3, [[LABEL_END:\.L[A-Z0-9_]+]]
; NOISEL-NEXT:  [[LABEL_LOOP:\.L[A-Z0-9_]+]]:
; NOISEL:       ld64 $a0:1, $m1, $m15, 0
; NOISEL-NEXT:  add $m0, $m0, -1
; NOISEL-NEXT:  st64 $a0:1, $m2, $m15, 0
; NOISEL-NEXT:  brnz $m0, [[LABEL_LOOP]]
; NOISEL-NEXT:  [[LABEL_END]]:
; NOISEL-NEXT:  br $m10
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

; CHECK-LABEL: valid_begin_bb_ending_with_tokenfactor:
; CHECK:       # %bb
; CHECK-NEXT:  # CLOOP_BEGIN_VALUE $m0, $m0, 0
; CHECK-NEXT:  # CLOOP_BEGIN_TERMINATOR $m0, 0
; CHECK-NEXT:  [[LABEL:\.L[A-Z0-9_]+]]:
; CHECK-NEXT:  br $m10
define i32 @valid_begin_bb_ending_with_tokenfactor(i32 %N) {
entry:
  %cloop_begin = call i32 @llvm.colossus.cloop.begin(i32 %N, i32 0)
  br label %cleanup
cleanup:
  ret i32 %cloop_begin
}

; CHECK-LABEL: valid_begin_bb_ending_with_tokenfactor_one_livevar:
; CHECK:       # %bb
; CHECK-NEXT:  f32add $a0, $a0, $a0
; CHECK-NEXT:  # CLOOP_BEGIN_VALUE $m0, $m0, 0
; CHECK-NEXT:  # CLOOP_BEGIN_TERMINATOR $m0, 0
; CHECK-NEXT:  [[LABEL:\.L[A-Z0-9_]+]]:
; CHECK-NEXT:  #APP
; CHECK-NEXT:  # sink
; CHECK-NEXT:  #NO_APP
; CHECK-NEXT:  br $m10
define i32 @valid_begin_bb_ending_with_tokenfactor_one_livevar(i32 %N, float %x) {
entry:
  %add = fadd float %x, %x
  %cloop_begin = call i32 @llvm.colossus.cloop.begin(i32 %N, i32 0)
  br label %cleanup
cleanup:
  call void asm "# sink","r"(float %add)
  ret i32 %cloop_begin
}

; CHECK-LABEL: valid_begin_bb_ending_with_tokenfactor_two_livevar:
; CHECK:       # %bb
; CHECK-NEXT:  f32add $a0, $a0, $a0
; CHECK-NEXT:  # CLOOP_BEGIN_VALUE $m0, $m0, 0
; CHECK-NEXT:  f32mul $a1, $a1, $a1
; CHECK-NEXT:  # CLOOP_BEGIN_TERMINATOR $m0, 0
; CHECK-NEXT:  [[LABEL:\.L[A-Z0-9_]+]]:
; CHECK-NEXT:  #APP
; CHECK-NEXT:  # sink
; CHECK-NEXT:  #NO_APP
; CHECK-NEXT:  br $m10
define i32 @valid_begin_bb_ending_with_tokenfactor_two_livevar(i32 %N, float %x, float %y) {
entry:
  %add = fadd float %x, %x
  %cloop_begin = call i32 @llvm.colossus.cloop.begin(i32 %N, i32 0)
  %mul = fmul float %y, %y
  br label %cleanup
cleanup:
  call void asm "# sink","r,r"(float %add, float %mul)
  ret i32 %cloop_begin
}

; CHECK-LABEL: valid_begin_bb_ending_with_tokenfactor_store_before_the_intrinsic:
; CHECK:       # %bb
; CHECK-NEXT:  st32 $m0, $m1, $m15, 0
; CHECK-NEXT:  # CLOOP_BEGIN_VALUE $m0, $m0, 0
; CHECK-NEXT:  # CLOOP_BEGIN_TERMINATOR $m0, 0
; CHECK-NEXT:  [[LABEL:\.L[A-Z0-9_]+]]:
; CHECK-NEXT:  br $m10
define i32 @valid_begin_bb_ending_with_tokenfactor_store_before_the_intrinsic(i32 %N, i32* %p) {
entry:
  store i32 %N, i32* %p
  %cloop_begin = call i32 @llvm.colossus.cloop.begin(i32 %N, i32 0)
  br label %cleanup
cleanup:
  ret i32 %cloop_begin
}

; CHECK-LABEL: valid_begin_bb_ending_with_tokenfactor_store_after_the_intrinsic:
; CHECK:       # %bb
; CHECK-NEXT:  st32 $m0, $m1, $m15, 0
; CHECK-NEXT:  # CLOOP_BEGIN_VALUE $m0, $m0, 0
; CHECK-NEXT:  # CLOOP_BEGIN_TERMINATOR $m0, 0
; CHECK-NEXT:  [[LABEL:\.L[A-Z0-9_]+]]:
; CHECK-NEXT:  br $m10
define i32 @valid_begin_bb_ending_with_tokenfactor_store_after_the_intrinsic(i32 %N, i32* %p) {
entry:
  %cloop_begin = call i32 @llvm.colossus.cloop.begin(i32 %N, i32 0)
  store i32 %N, i32* %p
  br label %cleanup
cleanup:
  ret i32 %cloop_begin
}

; CHECK-LABEL: valid_begin_bb_ending_with_branch:
; CHECK:       # %bb
; CHECK-NEXT:  # CLOOP_BEGIN_VALUE $m0, $m0, 0
; CHECK-NEXT:  # CLOOP_BEGIN_TERMINATOR $m0, 0
; CHECK-NEXT:  #APP
; CHECK-NEXT:  # indir
; CHECK-NEXT:  #NO_APP
; CHECK-NEXT:  #APP
; CHECK-NEXT:  # exitbr
; CHECK-NEXT:  #NO_APP
; CHECK-NEXT:  br $m10
define i32 @valid_begin_bb_ending_with_branch(i32 %N) {
entry:
  %cloop_begin = call i32 @llvm.colossus.cloop.begin(i32 %N, i32 0)
  br label %indir
exit:
  call void asm "# exitbr",""()
  ret i32 %cloop_begin
indir:
  call void asm "# indir",""()
  br label %exit
}

; CHECK-LABEL: valid_begin_bb_ending_with_branch_one_livevar:
; CHECK:       # %bb
; CHECK-NEXT:  f32add $a0, $a0, $a0
; CHECK-NEXT:  # CLOOP_BEGIN_VALUE $m0, $m0, 0
; CHECK-NEXT:  # CLOOP_BEGIN_TERMINATOR $m0, 0
; CHECK-NEXT:  [[LABEL:\.L[A-Z0-9_]+]]
; CHECK-NEXT:  #APP
; CHECK-NEXT:  # indir
; CHECK-NEXT:  #NO_APP
; CHECK-NEXT:  #APP
; CHECK-NEXT:  # exitbr
; CHECK-NEXT:  #NO_APP
; CHECK-NEXT:  br $m10
define i32 @valid_begin_bb_ending_with_branch_one_livevar(i32 %N, float %x) {
entry:
  %add = fadd float %x, %x
  %cloop_begin = call i32 @llvm.colossus.cloop.begin(i32 %N, i32 0)
  br label %indir
exit:
  call void asm "# exitbr",""()
  ret i32 %cloop_begin
indir:
  call void asm "# indir","r"(float %add)
  br label %exit
}

; CHECK-LABEL: valid_begin_bb_ending_with_branch_two_livevar:
; CHECK:       # %bb
; CHECK-NEXT:  f32add $a0, $a0, $a0
; CHECK-NEXT:  # CLOOP_BEGIN_VALUE $m0, $m0, 0
; CHECK-NEXT:  f32mul $a1, $a1, $a1
; CHECK-NEXT:  # CLOOP_BEGIN_TERMINATOR $m0, 0
; CHECK-NEXT:  [[LABEL:\.L[A-Z0-9_]+]]
; CHECK-NEXT:  #APP
; CHECK-NEXT:  # indir
; CHECK-NEXT:  #NO_APP
; CHECK-NEXT:  #APP
; CHECK-NEXT:  # exitbr
; CHECK-NEXT:  #NO_APP
; CHECK-NEXT:  br $m10
define i32 @valid_begin_bb_ending_with_branch_two_livevar(i32 %N, float %x, float %y) {
entry:
  %add = fadd float %x, %x
  %cloop_begin = call i32 @llvm.colossus.cloop.begin(i32 %N, i32 0)
  %mul = fmul float %y, %y
  br label %indir
exit:
  call void asm "# exitbr",""()
  ret i32 %cloop_begin
indir:
  call void asm "# indir","r,r"(float %add, float %mul)
  br label %exit
}

; CHECK-LABEL: valid_begin_bb_ending_with_branch_store_before_the_intrinsic:
; CHECK:       # %bb
; CHECK-NEXT:  st32 $m0, $m1, $m15, 0
; CHECK-NEXT:  # CLOOP_BEGIN_VALUE $m0, $m0, 0
; CHECK-NEXT:  # CLOOP_BEGIN_TERMINATOR $m0, 0
; CHECK-NEXT:  #APP
; CHECK-NEXT:  # indir
; CHECK-NEXT:  #NO_APP
; CHECK-NEXT:  #APP
; CHECK-NEXT:  # exitbr
; CHECK-NEXT:  #NO_APP
; CHECK-NEXT:  br $m10
define i32 @valid_begin_bb_ending_with_branch_store_before_the_intrinsic(i32 %N, i32* %p) {
entry:
  store i32 %N, i32* %p
  %cloop_begin = call i32 @llvm.colossus.cloop.begin(i32 %N, i32 0)
  br label %indir
exit:
  call void asm "# exitbr",""()
  ret i32 %cloop_begin
indir:
  call void asm "# indir",""()
  br label %exit
}

; CHECK-LABEL: valid_begin_bb_ending_with_branch_store_after_the_intrinsic:
; CHECK:       # %bb
; CHECK-NEXT:  st32 $m0, $m1, $m15, 0
; CHECK-NEXT:  # CLOOP_BEGIN_VALUE $m0, $m0, 0
; CHECK-NEXT:  # CLOOP_BEGIN_TERMINATOR $m0, 0
; CHECK-NEXT:  #APP
; CHECK-NEXT:  # indir
; CHECK-NEXT:  #NO_APP
; CHECK-NEXT:  #APP
; CHECK-NEXT:  # exitbr
; CHECK-NEXT:  #NO_APP
; CHECK-NEXT:  br $m10
define i32 @valid_begin_bb_ending_with_branch_store_after_the_intrinsic(i32 %N, i32* %p) {
entry:
  %cloop_begin = call i32 @llvm.colossus.cloop.begin(i32 %N, i32 0)
  store i32 %N, i32* %p
  br label %indir
exit:
  call void asm "# exitbr",""()
  ret i32 %cloop_begin
indir:
  call void asm "# indir",""()
  br label %exit
}

; CHECK-LABEL: invalid_begin_bb_ending_with_return:
; CHECK:       # %bb
; CHECK-NEXT:  br $m10
define i32 @invalid_begin_bb_ending_with_return(i32 %N) {
entry:
  %cloop_begin = call i32 @llvm.colossus.cloop.begin(i32 %N, i32 0)
  ret i32 %cloop_begin
}

; CHECK-LABEL: invalid_begin_bb_ending_with_brcond:
; CHECK:       # %bb
; CHECK-NEXT:  and $m1, $m1, 1
; CHECK-NEXT:  [[LABEL:\.L[A-Z0-9_]+]]:
; CHECK:       brz $m1, [[LABEL]]
; CHECK-NEXT:  # %bb
; CHECK-NEXT:  br $m10
define i32 @invalid_begin_bb_ending_with_brcond(i32 %N, i1 %C) {
entry:
  br label %begin
begin:
  %cloop_begin = call i32 @llvm.colossus.cloop.begin(i32 %N, i32 0)
  br i1 %C, label %cleanup, label %begin
cleanup:
  ret i32 %cloop_begin
}

; CHECK-LABEL: valid_begin_bb_small_metadata:
; CHECK:       # %bb
; CHECK-NEXT:  # CLOOP_BEGIN_VALUE $m0, $m0, 1
; CHECK-NEXT:  # CLOOP_BEGIN_TERMINATOR $m0, 1
; CHECK-NEXT:  [[LABEL:\.L[A-Z0-9_]+]]:
; CHECK-NEXT:  br $m10
define i32 @valid_begin_bb_small_metadata(i32 %N) {
entry:
  %cloop_begin = call i32 @llvm.colossus.cloop.begin(i32 %N, i32 1)
  br label %cleanup
cleanup:
  ret i32 %cloop_begin
}

; CHECK-LABEL: valid_begin_bb_large_metadata:
; CHECK:       # %bb
; CHECK-NEXT:  # CLOOP_BEGIN_VALUE $m0, $m0, 65535
; CHECK-NEXT:  # CLOOP_BEGIN_TERMINATOR $m0, 65535
; CHECK-NEXT:  [[LABEL:\.L[A-Z0-9_]+]]:
; CHECK-NEXT:  br $m10
define i32 @valid_begin_bb_large_metadata(i32 %N) {
entry:
  %cloop_begin = call i32 @llvm.colossus.cloop.begin(i32 %N, i32 65535)
  br label %cleanup
cleanup:
  ret i32 %cloop_begin
}

; CHECK-LABEL: invalid_begin_bb_too_large_metadata:
; CHECK:       # %bb
; CHECK-NEXT:  br $m10
define i32 @invalid_begin_bb_too_large_metadata(i32 %N) {
entry:
  %cloop_begin = call i32 @llvm.colossus.cloop.begin(i32 %N, i32 65536)
  br label %cleanup
cleanup:
  ret i32 %cloop_begin
}

; CHECK-LABEL: invalid_begin_bb_variable_metadata:
; CHECK:       # %bb
; CHECK-NEXT:  br $m10
define i32 @invalid_begin_bb_variable_metadata(i32 %N, i32 %meta) {
entry:
  %cloop_begin = call i32 @llvm.colossus.cloop.begin(i32 %N, i32 %meta)
  br label %cleanup
cleanup:
  ret i32 %cloop_begin
}

; CHECK-LABEL: valid_end_bb:
; CHECK:       # %bb
; CHECK-NEXT:  [[LABEL:\.L[A-Z0-9_]+]]:
; CHECK:       # CLOOP_END_VALUE $m0, $m0, 0
; CHECK-NEXT:  # CLOOP_END_BRANCH $m0, [[LABEL]], 0
; CHECK-NEXT:  # %bb
; CHECK-NEXT:  br $m10
 define void @valid_end_bb(i32 %N) {
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

; CHECK-LABEL: valid_end_bb_code_before_intrinsic:
; CHECK:       # %bb
; CHECK-NEXT:  [[LABEL:\.L[A-Z0-9_]+]]:
; CHECK:       st32 $m0, $m1, $m15, 0
; CHECK-NEXT:  # CLOOP_END_VALUE $m0, $m0, 0
; CHECK-NEXT:  # CLOOP_END_BRANCH $m0, [[LABEL]], 0
; CHECK-NEXT:  # %bb
; CHECK-NEXT:  br $m10
 define void @valid_end_bb_code_before_intrinsic(i32 %N, i32* %p) {
 entry:
   br label %body
 body:
   %cloop.phi = phi i32 [ %cloop.end.iv, %body ], [ %N, %entry ]
   store i32 %cloop.phi, i32* %p
   %cloop.end = call { i32, i32 } @llvm.colossus.cloop.end(i32 %cloop.phi, i32 0)
   %cloop.end.iv = extractvalue { i32, i32 } %cloop.end, 0
   %cloop.end.cc = extractvalue { i32, i32 } %cloop.end, 1
   %t = trunc i32 %cloop.end.cc to i1
   br i1 %t, label %body, label %cleanup
 cleanup:
   ret void
 }

; CHECK-LABEL: valid_end_bb_code_after_intrinsic:
; CHECK:       # %bb
; CHECK-NEXT:  [[LABEL:\.L[A-Z0-9_]+]]:
; CHECK:       # CLOOP_END_VALUE $m0, $m0, 0
; CHECK-NEXT:  st32 $m0, $m1, $m15, 0
; CHECK-NEXT:  # CLOOP_END_BRANCH $m0, [[LABEL]], 0
; CHECK-NEXT:  # %bb
; CHECK-NEXT:  br $m10
define void @valid_end_bb_code_after_intrinsic(i32 %N, i32* %p) {
entry:
  br label %body
body:
  %cloop.phi = phi i32 [ %cloop.end.iv, %body ], [ %N, %entry ]
  %cloop.end = call { i32, i32 } @llvm.colossus.cloop.end(i32 %cloop.phi, i32 0)
  %cloop.end.iv = extractvalue { i32, i32 } %cloop.end, 0
  %cloop.end.cc = extractvalue { i32, i32 } %cloop.end, 1
  store i32 %cloop.end.iv, i32* %p
  %t = trunc i32 %cloop.end.cc to i1
  br i1 %t, label %body, label %cleanup
cleanup:
  ret void
}

; CHECK-LABEL: valid_end_bb_code_uses_result_of_intrinsic:
; CHECK:       # %bb
; CHECK-NEXT:  [[LABEL:\.L[A-Z0-9_]+]]:
; CHECK:       # CLOOP_END_VALUE $m0, $m0, 0
; CHECK-NEXT:  st32 $m0, $m1, $m15, 0
; CHECK-NEXT:  # CLOOP_END_BRANCH $m0, [[LABEL]], 0
; CHECK-NEXT:  # %bb
; CHECK-NEXT:  br $m10
define void @valid_end_bb_code_uses_result_of_intrinsic(i32 %N, i32* %p) {
entry:
  br label %body
body:
  %cloop.phi = phi i32 [ %cloop.end.iv, %body ], [ %N, %entry ]
  %cloop.end = call { i32, i32 } @llvm.colossus.cloop.end(i32 %cloop.phi, i32 0)
  %cloop.end.iv = extractvalue { i32, i32 } %cloop.end, 0
  %cloop.end.cc = extractvalue { i32, i32 } %cloop.end, 1
  store i32 %cloop.end.iv, i32* %p
  %t = trunc i32 %cloop.end.cc to i1
  br i1 %t, label %body, label %cleanup
cleanup:
  ret void
}

; CHECK-LABEL: valid_end_bb_branch_condition_inverted:
; CHECK:       # %bb
; CHECK-NEXT:  [[LABEL:\.L[A-Z0-9_]+]]:
; CHECK:       # CLOOP_END_VALUE $m0, $m0, 0
; CHECK-NEXT:  st32 $m0, $m1, $m15, 0
; CHECK-NEXT:  # CLOOP_END_BRANCH $m0, [[LABEL]], 0
; CHECK-NEXT:  # %bb
; CHECK-NEXT:  br $m10
define void @valid_end_bb_branch_condition_inverted(i32 %N, i32* %p) {
entry:
  br label %body
body:
  %cloop.phi = phi i32 [ %cloop.end.iv, %body ], [ %N, %entry ]
  %cloop.end = call { i32, i32 } @llvm.colossus.cloop.end(i32 %cloop.phi, i32 0)
  %cloop.end.iv = extractvalue { i32, i32 } %cloop.end, 0
  %cloop.end.cc = extractvalue { i32, i32 } %cloop.end, 1
  store i32 %cloop.end.iv, i32* %p
  %not = xor i32 %cloop.end.cc, -1
  %t = trunc i32 %not to i1
  br i1 %t, label %cleanup, label %body
cleanup:
  ret void
}

; CHECK-LABEL: invalid_end_bb_branch_swapped_ill_formed:
; CHECK:       # %bb
; CHECK-NEXT:  [[LABEL:\.L[A-Z0-9_]+]]:
; CHECK:       add $m0, $m0, -1
; CHECK-NEXT:  st32 $m0, $m1, $m15, 0
; CHECK-NEXT:  brz $m0, [[LABEL]]
; CHECK-NEXT:  # %bb
; CHECK-NEXT:  br $m10
define void @invalid_end_bb_branch_swapped_ill_formed(i32 %N, i32* %p) {
entry:
  br label %body
body:
  %cloop.phi = phi i32 [ %cloop.end.iv, %body ], [ %N, %entry ]
  %cloop.end = call { i32, i32 } @llvm.colossus.cloop.end(i32 %cloop.phi, i32 0)
  %cloop.end.iv = extractvalue { i32, i32 } %cloop.end, 0
  %cloop.end.cc = extractvalue { i32, i32 } %cloop.end, 1
  store i32 %cloop.end.iv, i32* %p
  %t = trunc i32 %cloop.end.cc to i1
  br i1 %t, label %cleanup, label %body
cleanup:
  ret void
}

; CHECK-LABEL: invalid_end_bb_intermediate_value_after_cc:
; CHECK:       # %bb
; CHECK-NEXT:  [[LABEL:\.L[A-Z0-9_]+]]:
; CHECK:       add $m0, $m0, -1
; CHECK-NEXT:  cmpne $m2, $m0, $m15
; CHECK-NEXT:  and $m2, $m2, $m1
; CHECK-NEXT:  brnz $m2, [[LABEL]]
; CHECK-NEXT:  # %bb
; CHECK-NEXT:  br $m10
define void @invalid_end_bb_intermediate_value_after_cc(i32 %N, i32 %V) {
entry:
  br label %body
body:
  %cloop.phi = phi i32 [ %cloop.end.iv, %body ], [ %N, %entry ]
  %cloop.end = call { i32, i32 } @llvm.colossus.cloop.end(i32 %cloop.phi, i32 0)
  %cloop.end.iv = extractvalue { i32, i32 } %cloop.end, 0
  %cloop.end.cc = extractvalue { i32, i32 } %cloop.end, 1
  %cc.mod = and i32 %cloop.end.cc, %V
  %t = trunc i32 %cc.mod to i1
  br i1 %t, label %body, label %cleanup
cleanup:
  ret void
}

; CHECK-LABEL: valid_end_bb_intermediate_value_after_indvar:
; CHECK:       # %bb
; CHECK-NEXT:  [[LABEL:\.L[A-Z0-9_]+]]:
; CHECK:       mov $m2, $m0
; CHECK-NEXT:  # CLOOP_END_VALUE $m2, $m2, 0
; CHECK-NEXT:  and $m0, $m2, $m1
; CHECK-NEXT:  # CLOOP_END_BRANCH $m2, [[LABEL]], 0
; CHECK-NEXT:  # %bb
; CHECK-NEXT:  br $m10
define void @valid_end_bb_intermediate_value_after_indvar(i32 %N, i32 %V) {
entry:
  br label %body
body:
  %cloop.phi = phi i32 [ %inv.mod, %body ], [ %N, %entry ]
  %cloop.end = call { i32, i32 } @llvm.colossus.cloop.end(i32 %cloop.phi, i32 0)
  %cloop.end.iv = extractvalue { i32, i32 } %cloop.end, 0
  %inv.mod = and i32 %cloop.end.iv, %V
  %cloop.end.cc = extractvalue { i32, i32 } %cloop.end, 1
  %t = trunc i32 %cloop.end.cc to i1
  br i1 %t, label %body, label %cleanup
cleanup:
  ret void
}

; CHECK-LABEL: invalid_end_bb_ending_with_return_iv:
; CHECK:       # %bb
; CHECK-NEXT:  add $m0, $m0, -1
; CHECK-NEXT:  br $m10
define i32 @invalid_end_bb_ending_with_return_iv(i32 %N) {
entry:
  %cloop.end = call { i32, i32 } @llvm.colossus.cloop.end(i32 %N, i32 0)
  %cloop.end.iv = extractvalue { i32, i32 } %cloop.end, 0
  ret i32 %cloop.end.iv
}

; CHECK-LABEL: invalid_end_bb_ending_with_return_cc:
; CHECK:       # %bb
; CHECK-NEXT:  cmpeq $m0, $m0, 1
; CHECK-NEXT:  cmpeq $m0, $m0, 0
; CHECK-NEXT:  br $m10
define i32 @invalid_end_bb_ending_with_return_cc(i32 %N) {
entry:
  %cloop.end = call { i32, i32 } @llvm.colossus.cloop.end(i32 %N, i32 0)
  %cloop.end.cc = extractvalue { i32, i32 } %cloop.end, 1
  ret i32 %cloop.end.cc
}

; CHECK-LABEL: invalid_end_bb_unconditional_loop:
; CHECK:       # %bb
; CHECK-NEXT:  [[LABEL:\.L[A-Z0-9_]+]]:
; CHECK:       add $m0, $m0, -1
; CHECK-NEXT:  bri [[LABEL]]
; CHECK-NOT:   br $m10
define void @invalid_end_bb_unconditional_loop(i32 %N) {
entry:
  br label %body
body:
  %cloop.phi = phi i32 [ %cloop.end.iv, %body ], [ %N, %entry ]
  %cloop.end = call { i32, i32 } @llvm.colossus.cloop.end(i32 %cloop.phi, i32 0)
  %cloop.end.iv = extractvalue { i32, i32 } %cloop.end, 0
  br label %body
}

; CHECK-LABEL: invalid_end_bb_unconditional_fallthrough_ret_iv:
; CHECK:       # %bb
; CHECK-NEXT:  add $m0, $m0, -1
; CHECK-NEXT:  #APP
; CHECK-NEXT:  # indir
; CHECK-NEXT:  #NO_APP
; CHECK-NEXT:  #APP
; CHECK-NEXT:  # exitbr
; CHECK-NEXT:  #NO_APP
; CHECK-NEXT:  br $m10
define i32 @invalid_end_bb_unconditional_fallthrough_ret_iv(i32 %N) {
entry:
   %cloop.end = call { i32, i32 } @llvm.colossus.cloop.end(i32 %N, i32 0)
   %cloop.end.iv = extractvalue { i32, i32 } %cloop.end, 0
   br label %indir
exit:
  call void asm "# exitbr",""()
  ret i32 %cloop.end.iv
indir:
  call void asm "# indir",""()
  br label %exit
}

; CHECK-LABEL: invalid_end_bb_unconditional_fallthrough_ret_cc:
; CHECK:       # %bb
; CHECK-NEXT:  cmpeq $m0, $m0, 1
; CHECK-NEXT:  #APP
; CHECK-NEXT:  # indir
; CHECK-NEXT:  #NO_APP
; CHECK-NEXT:  cmpeq $m0, $m0, 0
; CHECK-NEXT:  #APP
; CHECK-NEXT:  # exitbr
; CHECK-NEXT:  #NO_APP
; CHECK-NEXT:  br $m10
define i32 @invalid_end_bb_unconditional_fallthrough_ret_cc(i32 %N) {
entry:
   %cloop.end = call { i32, i32 } @llvm.colossus.cloop.end(i32 %N, i32 0)
   %cloop.end.cc = extractvalue { i32, i32 } %cloop.end, 1
   br label %indir
exit:
  call void asm "# exitbr",""()
  ret i32 %cloop.end.cc
indir:
  call void asm "# indir",""()
  br label %exit
}

; CHECK-LABEL: valid_end_bb_small_metadata:
; CHECK:       # %bb
; CHECK-NEXT:  [[LABEL:\.L[A-Z0-9_]+]]:
; CHECK:       # CLOOP_END_VALUE $m0, $m0, 1
; CHECK-NEXT:  # CLOOP_END_BRANCH $m0, [[LABEL]], 1
; CHECK-NEXT:  # %bb
; CHECK-NEXT:  br $m10
define void @valid_end_bb_small_metadata(i32 %N) {
entry:
  br label %body
body:
  %cloop.phi = phi i32 [ %cloop.end.iv, %body ], [ %N, %entry ]
  %cloop.end = call { i32, i32 } @llvm.colossus.cloop.end(i32 %cloop.phi, i32 1)
  %cloop.end.iv = extractvalue { i32, i32 } %cloop.end, 0
  %cloop.end.cc = extractvalue { i32, i32 } %cloop.end, 1
  %t = trunc i32 %cloop.end.cc to i1
  br i1 %t, label %body, label %cleanup
cleanup:
  ret void
}

; CHECK-LABEL: valid_end_bb_large_metadata:
; CHECK:       # %bb
; CHECK-NEXT:  [[LABEL:\.L[A-Z0-9_]+]]:
; CHECK:       # CLOOP_END_VALUE $m0, $m0, 65535
; CHECK-NEXT:  # CLOOP_END_BRANCH $m0, [[LABEL]], 65535
; CHECK-NEXT:  # %bb
; CHECK-NEXT:  br $m10
define void @valid_end_bb_large_metadata(i32 %N) {
entry:
  br label %body
body:
  %cloop.phi = phi i32 [ %cloop.end.iv, %body ], [ %N, %entry ]
  %cloop.end = call { i32, i32 } @llvm.colossus.cloop.end(i32 %cloop.phi, i32 65535)
  %cloop.end.iv = extractvalue { i32, i32 } %cloop.end, 0
  %cloop.end.cc = extractvalue { i32, i32 } %cloop.end, 1
  %t = trunc i32 %cloop.end.cc to i1
  br i1 %t, label %body, label %cleanup
cleanup:
  ret void
}

; CHECK-LABEL: invalid_end_bb_too_large_metadata:
; CHECK:       # %bb
; CHECK-NEXT:  [[LABEL:\.L[A-Z0-9_]+]]:
; CHECK:       add $m0, $m0, -1
; CHECK-NEXT:  brnz $m0, [[LABEL]]
; CHECK-NEXT:  # %bb
; CHECK-NEXT:  br $m10
define void @invalid_end_bb_too_large_metadata(i32 %N) {
entry:
  br label %body
body:
  %cloop.phi = phi i32 [ %cloop.end.iv, %body ], [ %N, %entry ]
  %cloop.end = call { i32, i32 } @llvm.colossus.cloop.end(i32 %cloop.phi, i32 65536)
  %cloop.end.iv = extractvalue { i32, i32 } %cloop.end, 0
  %cloop.end.cc = extractvalue { i32, i32 } %cloop.end, 1
  %t = trunc i32 %cloop.end.cc to i1
  br i1 %t, label %body, label %cleanup
cleanup:
  ret void
}

; CHECK-LABEL: invalid_end_bb_variable_metadata:
; CHECK:       # %bb
; CHECK-NEXT:  [[LABEL:\.L[A-Z0-9_]+]]:
; CHECK:       add $m0, $m0, -1
; CHECK-NEXT:  brnz $m0, [[LABEL]]
; CHECK-NEXT:  # %bb
; CHECK-NEXT:  br $m10
define void @invalid_end_bb_variable_metadata(i32 %N, i32 %meta) {
entry:
  br label %body
body:
  %cloop.phi = phi i32 [ %cloop.end.iv, %body ], [ %N, %entry ]
  %cloop.end = call { i32, i32 } @llvm.colossus.cloop.end(i32 %cloop.phi, i32 %meta)
  %cloop.end.iv = extractvalue { i32, i32 } %cloop.end, 0
  %cloop.end.cc = extractvalue { i32, i32 } %cloop.end, 1
  %t = trunc i32 %cloop.end.cc to i1
  br i1 %t, label %body, label %cleanup
cleanup:
  ret void
}
