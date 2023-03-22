; RUN: llc < %s -march=colossus -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -march=colossus -mattr=+ipu2 | FileCheck %s

; Task T15543 mentions an excess of instructions emitted. This occurred because
; the tripcount of the loop got modified resulting in the counted loops pass not
; emitting a rpt loop. Instead it opted for the a brnzdec loop which depends on
; Scalar Evolution (SCEV) to emit preheader code preparing the trip count for a
; brnzdec loop. This SCEV code is what was observed in T15543 as redundant
; code.

; CHECK-LABEL: repeatable_loop:
; CHECK:      {
; CHECK-NEXT:  rpt $m0, 0
; CHECK-NEXT:  fnop
; CHECK-NEXT: }
; CHECK-NEXT: {
; CHECK-NEXT:   add $m1, $m1, 48
; CHECK-NEXT:   fnop
; CHECK-NEXT: }

define i1 @repeatable_loop() {
entry:
  %shr.i.i = lshr i32 undef, 2
  %add.i.i = add nuw nsw i32 %shr.i.i, 5
  %sub.i.i = sub nsw i32 %add.i.i, undef
  %mul.i.i = mul i32 %sub.i.i, 43691
  %shr1.i.i = lshr i32 %mul.i.i, 18
  %and.i.i = and i32 %shr1.i.i, 4095
  %cmp51.not.i = icmp eq i32 %and.i.i, 0
  br i1 %cmp51.not.i, label %for.cond.cleanup.i, label %for.body.i

for.cond.cleanup.i.loopexit:
  %0 = extractvalue { <4 x half>, <4 x half>* } %1, 1
  br label %for.cond.cleanup.i

for.cond.cleanup.i:
  %h4Out.0.lcssa.i = phi <4 x half>* [ undef, %entry ], [ %add.ptr5.i, %for.cond.cleanup.i.loopexit ]
  br label %exit

for.body.i:
  %h4Out.054.i = phi <4 x half>* [ %add.ptr5.i, %for.body.i ], [ undef, %entry ]
  %i.053.i = phi i32 [ %inc.i, %for.body.i ], [ 0, %entry ]
  %1 = tail call { <4 x half>, <4 x half>* } @llvm.colossus.ldstep.v4f16(<4 x half>* undef, i32 6)
  %add.ptr5.i = getelementptr inbounds <4 x half>, <4 x half>* %h4Out.054.i, i32 6
  %inc.i = add nuw nsw i32 %i.053.i, 1
  %exitcond.not.i = icmp eq i32 %inc.i, %and.i.i
  br i1 %exitcond.not.i, label %for.cond.cleanup.i.loopexit, label %for.body.i

exit:
  ret i1 true
}

declare { <4 x half>, <4 x half>* } @llvm.colossus.ldstep.v4f16(<4 x half>*, i32)

