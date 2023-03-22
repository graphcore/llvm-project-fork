; Should use the target specific canBeCSECandidate in ColossusInstrInfo to
; prevent MachineCSE from modifying the counted loop pseudo instruction
; structure that the ColossusCountedLoopMIR pass expects. On success there
; should be 2 brnzdecs (instead of 1 brnzdec and 1 sub+brnz).

; RUN: llc -march=colossus < %s | FileCheck %s

declare void @llvm.memset.p0i8.i32(i8* nocapture writeonly, i8, i32, i1 immarg)

define void @clear_arr(i32 %N, [10 x [15 x i32]]* nocapture %arr) {
; CHECK-LABEL: clear_arr:
; CHECK:         brnzdec $m7, .LBB{{[0-9_]+}}
; CHECK:         brnzdec $m2, .LBB{{[0-9_]+}}
entry:
  %cmp31 = icmp sgt i32 %N, 0
  br i1 %cmp31, label %for.cond1.preheader.us.us.preheader, label %for.end14

for.cond1.preheader.us.us.preheader:
  %0 = shl nuw i32 %N, 2
  br label %for.cond1.preheader.us.us

for.cond1.preheader.us.us:
  %i.032.us.us = phi i32 [ %inc13.us.us, %for.cond1.for.inc12_crit_edge.split.us.us.us ], [ 0, %for.cond1.preheader.us.us.preheader ]
  br label %for.cond4.preheader.us.us.us

for.cond4.preheader.us.us.us:
  %j.029.us.us.us = phi i32 [ 0, %for.cond1.preheader.us.us ], [ %inc10.us.us.us, %for.cond4.preheader.us.us.us ]
  %scevgep = getelementptr [10 x [15 x i32]], [10 x [15 x i32]]* %arr, i32 %i.032.us.us, i32 %j.029.us.us.us, i32 0
  %scevgep41 = bitcast i32* %scevgep to i8*
  call void @llvm.memset.p0i8.i32(i8* align 4 %scevgep41, i8 0, i32 %0, i1 false)
  %inc10.us.us.us = add nuw nsw i32 %j.029.us.us.us, 1
  %exitcond.not = icmp eq i32 %inc10.us.us.us, %N
  br i1 %exitcond.not, label %for.cond1.for.inc12_crit_edge.split.us.us.us, label %for.cond4.preheader.us.us.us

for.cond1.for.inc12_crit_edge.split.us.us.us:
  %inc13.us.us = add nuw nsw i32 %i.032.us.us, 1
  %exitcond42.not = icmp eq i32 %inc13.us.us, %N
  br i1 %exitcond42.not, label %for.end14, label %for.cond1.preheader.us.us

for.end14:
  ret void
}
