; For ipu1 and ipu2 this erroneously gets pipelined as there is no profit to it
; (then again the original C code got erroneously vectorised). One day
; pipelining may recognise it's not profitable and this test will change. For
; now we'll use it as part of the pipelining tests to determine correct codegen.
; Some named regex labels aren't used elsewhere but added to explicitly
; distinguish between all the different software pipelined basic blocks.

; RUN: llc -march=colossus -enable-pipeliner < %s | FileCheck %s

declare i32 @llvm.vector.reduce.or.v2i32(<2 x i32>)

; CHECK-LABEL: bar:
; CHECK:       [[PROLOG:\.LBB[0-9_]+]]:
; CHECK:         st32 $m0, $m11, $m15, 5
; CHECK:         mov   $m6, $m15
; CHECK:         mov   $m5, $m15
; CHECK:         st32 $m4, $m11, $m15, 6
; CHECK:         st32 $m5, $m11, $m15, 7
; CHECK:         andc $m0, $m10, 1
; CHECK:         add $m5, $m0, -2
; CHECK:         shl $m8, $m2, 2
; CHECK:         shr $m5, $m5, 1
; CHECK:         st32 $m0, $m11, $m15, 9
; CHECK:         add $m0, $m0, $m2
; CHECK:         st32 $m0, $m11, $m15, 4
; CHECK:         add $m8, $m1, $m8
; CHECK:         add $m9, $m5, 1
; CHECK:         setzi $m5, 1
; CHECK:         ld32 $m7, $m8, $m15, 1
; CHECK:         ld32step $m0, $m15, $m8+=, 2
; CHECK:         cmpslt $m2, $m5, $m9
; CHECK:         ld32 $m4, $m11, $m15, 6
; CHECK:         ld32 $m5, $m11, $m15, 7
; CHECK:         or $m7, $m7, $m5
; CHECK:         or $m6, $m0, $m6
; CHECK:         add $m9, $m9, -1
; CHECK:         brz $m2, [[EPILOG:\.LBB[0-9_]+]]
; CHECK:       # [[PREHEADER:\%bb\.[0-9_]+]]:
; CHECK:         add $m9, $m9, -1
; CHECK:       [[KERNEL:\.LBB[0-9_]+]]:
; CHECK:         # =>This Inner Loop Header: Depth=1
; CHECK:         ld32 $m5, $m8, $m15, 1
; CHECK:         ld32step $m0, $m15, $m8+=, 2
; CHECK:         or $m6, $m0, $m6
; CHECK:         or $m7, $m5, $m7
; CHECK:         brnzdec $m9, [[KERNEL]]
; CHECK:       [[EPILOG]]:
; CHECK:         ld32 $m0, $m11, $m15, 9
; CHECK:         cmpeq $m2, $m10, $m0
; CHECK:         mov $m4, $m7
; CHECK:         or $m5, $m7, $m0
; CHECK:         or $m4, $m6, $m4
; CHECK:         ld32 $m0, $m11, $m15, 5
; CHECK:         brnz $m2, [[EXIT:\.LBB[0-9_]+]]
; CHECK:       [[EXIT]]:
define void @bar(i32* nocapture %output, i32* nocapture readonly %input, i32 %i, i32 %j) {
entry:
  %cmp6 = icmp sgt i32 %j, %i
  br i1 %cmp6, label %for.body.preheader, label %for.end

for.body.preheader:
  %0 = sub i32 %j, %i
  %min.iters.check = icmp ult i32 %0, 2
  br i1 %min.iters.check, label %for.body.preheader9, label %vector.ph

vector.ph:
  %n.vec = and i32 %0, -2
  %ind.end = add i32 %n.vec, %i
  br label %vector.body

vector.body:
  %index = phi i32 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %vec.phi = phi <2 x i32> [ zeroinitializer, %vector.ph ], [ %3, %vector.body ]
  %offset.idx = add i32 %index, %i
  %1 = getelementptr inbounds i32, i32* %input, i32 %offset.idx
  %2 = bitcast i32* %1 to <2 x i32>*
  %wide.load = load <2 x i32>, <2 x i32>* %2, align 4
  %3 = or <2 x i32> %wide.load, %vec.phi
  %index.next = add nuw i32 %index, 2
  %4 = icmp eq i32 %index.next, %n.vec
  br i1 %4, label %middle.block, label %vector.body

middle.block:
  %5 = call i32 @llvm.vector.reduce.or.v2i32(<2 x i32> %3)
  %cmp.n = icmp eq i32 %0, %n.vec
  br i1 %cmp.n, label %for.end, label %for.body.preheader9

for.body.preheader9:
  %b.08.ph = phi i32 [ %i, %for.body.preheader ], [ %ind.end, %middle.block ]
  %shouldbe.07.ph = phi i32 [ 0, %for.body.preheader ], [ %5, %middle.block ]
  br label %for.body

for.body:
  %b.08 = phi i32 [ %inc, %for.body ], [ %b.08.ph, %for.body.preheader9 ]
  %shouldbe.07 = phi i32 [ %or, %for.body ], [ %shouldbe.07.ph, %for.body.preheader9 ]
  %arrayidx = getelementptr inbounds i32, i32* %input, i32 %b.08
  %6 = load i32, i32* %arrayidx, align 4
  %or = or i32 %6, %shouldbe.07
  %inc = add nsw i32 %b.08, 1
  %exitcond.not = icmp eq i32 %inc, %j
  br i1 %exitcond.not, label %for.end, label %for.body

for.end:
  %shouldbe.0.lcssa = phi i32 [ 0, %entry ], [ %5, %middle.block ], [ %or, %for.body ]
  store i32 %shouldbe.0.lcssa, i32* %output, align 4
  ret void
}
