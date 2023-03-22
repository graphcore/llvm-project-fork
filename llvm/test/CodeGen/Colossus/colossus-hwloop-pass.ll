; RUN: opt < %s -mtriple=colossus -mcpu=ipu1 -hardware-loops -colossus-loop-conversion -S | FileCheck %s --check-prefixes=CHECK,IPU1
; RUN: opt < %s -mtriple=colossus -mcpu=ipu1 -hardware-loops -colossus-loop-conversion -colossus-cloop-enable-ir=true -S | FileCheck %s --check-prefixes=CHECK,IPU1

; RUN: opt < %s -mtriple=colossus -mcpu=ipu2 -hardware-loops -colossus-loop-conversion -S | FileCheck %s --check-prefixes=CHECK,IPU2
; RUN: opt < %s -mtriple=colossus -mcpu=ipu2 -hardware-loops -colossus-loop-conversion -colossus-cloop-enable-ir=true -S | FileCheck %s --check-prefixes=CHECK,IPU2

; RUN: opt < %s -mtriple=colossus -hardware-loops -colossus-loop-conversion -colossus-cloop-enable-ir=false -S | FileCheck %s --check-prefix=CLOOP-DISABLED
; RUN: opt < %s -mtriple=colossus -hardware-loops -colossus-loop-conversion -S -mattr=+supervisor | FileCheck %s --check-prefix=CLOOP-DISABLED
; RUN: opt < %s -mtriple=colossus -hardware-loops -colossus-loop-conversion -colossus-cloop-enable-ir=false -S -mattr=+supervisor  | FileCheck %s --check-prefix=CLOOP-DISABLED
; RUN: opt < %s -mtriple=colossus -hardware-loops -colossus-loop-conversion -colossus-cloop-enable-ir=true -S -mattr=+supervisor  | FileCheck %s --check-prefix=CLOOP-DISABLED

; Test empty counted loop deletion. Since this is done by enabling a middle end
; pass at the right place in the pass pipeline, we test this by running -O2
; passes. Loop vectorization is disabled because it leads to more complex code
; generation and thus more CHECK-NEXT directives.
; RUN: opt < %s -O2 -mtriple=colossus -hardware-loops -colossus-loop-conversion -colossus-cloop-enable-ir -vectorize-loops=false -S --print-after=colossus-loop-conversion 2>&1 | FileCheck %s -check-prefix=USELESS

; CLOOP-DISABLED-NOT: llvm.colossus.cloop.begin(i32 %{{[0-9a-zA-Z]+}}, i32 1)
; CLOOP-DISABLED-NOT: llvm.colossus.cloop.end(i32 %{{[0-9a-zA-Z]+}}, i32 1)

; simple_loop, loop_without_preheader and reversed_branch_loop transform to identical IR

; CHECK-LABEL: define void @simple_loop(i32 %N, <2 x float>* %x, <2 x float>* %y)
; CHECK:       entry:
; CHECK:         %cmp3 = icmp sgt i32 %N, 0
; CHECK:         br i1 %cmp3, label %for.body.preheader, label %for.cond.cleanup
; CHECK:       for.body.preheader:
; CHECK:         %cloop.begin = call i32 @llvm.colossus.cloop.begin(i32 %N, i32 0)
; CHECK:         br label %for.body
; CHECK:       for.body:
; CHECK:         %0 = phi i32 [ %cloop.begin, %for.body.preheader ], [ %cloop.end.iv, %for.body ]
; CHECK:         %1 = load <2 x float>, <2 x float>* %x
; CHECK:         store <2 x float> %1, <2 x float>* %y
; CHECK:         %cloop.end = call { i32, i32 } @llvm.colossus.cloop.end(i32 %0, i32 0)
; CHECK:         %cloop.end.iv = extractvalue { i32, i32 } %cloop.end, 0
; CHECK:         %cloop.end.cc = extractvalue { i32, i32 } %cloop.end, 1
; CHECK:         %cloop.end.cc.trunc = trunc i32 %cloop.end.cc to i1
; CHECK:         br i1 %cloop.end.cc.trunc, label %for.body, label %for.cond.cleanup
; CHECK:       for.cond.cleanup:
; CHECK:         ret void
; CHECK:       }
define void @simple_loop(i32 %N, <2 x float>* %x, <2 x float>* %y)  {
entry:
  %cmp3 = icmp sgt i32 %N, 0
  br i1 %cmp3, label %for.body.preheader, label %for.cond.cleanup
for.body.preheader:
  br label %for.body
for.body:
  %lsr.iv = phi i32 [ %N, %for.body.preheader ], [ %lsr.iv.next, %for.body ]
  %0 = load <2 x float>, <2 x float>* %x
  store <2 x float> %0, <2 x float>* %y
  %lsr.iv.next = add i32 %lsr.iv, -1
  %exitcond = icmp eq i32 %lsr.iv.next, 0
  br i1 %exitcond, label %for.cond.cleanup, label %for.body
for.cond.cleanup:
  ret void
}

; CHECK-LABEL: define void @loop_without_preheader(i32 %N, <2 x float>* %x, <2 x float>* %y)
; CHECK:       entry:
; CHECK:         %cmp3 = icmp sgt i32 %N, 0
; CHECK:         br i1 %cmp3, label %for.body.preheader, label %for.cond.cleanup
; CHECK:       for.body.preheader:
; CHECK:         %cloop.begin = call i32 @llvm.colossus.cloop.begin(i32 %N, i32 0)
; CHECK:         br label %for.body
; CHECK:       for.body:
; CHECK:         %0 = phi i32 [ %cloop.begin, %for.body.preheader ], [ %cloop.end.iv, %for.body ]
; CHECK:         %1 = load <2 x float>, <2 x float>* %x
; CHECK:         store <2 x float> %1, <2 x float>* %y
; CHECK:         %cloop.end = call { i32, i32 } @llvm.colossus.cloop.end(i32 %0, i32 0)
; CHECK:         %cloop.end.iv = extractvalue { i32, i32 } %cloop.end, 0
; CHECK:         %cloop.end.cc = extractvalue { i32, i32 } %cloop.end, 1
; CHECK:         %cloop.end.cc.trunc = trunc i32 %cloop.end.cc to i1
; CHECK:         br i1 %cloop.end.cc.trunc, label %for.body, label %for.cond.cleanup
; CHECK:       for.cond.cleanup:
; CHECK:         ret void
; CHECK:       }
define void @loop_without_preheader(i32 %N, <2 x float>* %x, <2 x float>* %y)  {
entry:
  %cmp3 = icmp sgt i32 %N, 0
  br i1 %cmp3, label %for.body, label %for.cond.cleanup
for.body:
  %iv = phi i32 [ %inc, %for.body ], [ 0, %entry ]
  %0 = load <2 x float>, <2 x float>* %x
  store <2 x float> %0, <2 x float>* %y
  %inc = add nuw nsw i32 %iv, 1
  %exitcond = icmp eq i32 %inc, %N
  br i1 %exitcond, label %for.cond.cleanup, label %for.body
for.cond.cleanup:
  ret void
}

; CHECK-LABEL: define void @reversed_branch_loop(i32 %N, <2 x float>* %x, <2 x float>* %y)
; CHECK:       entry:
; CHECK:         %cmp3 = icmp sgt i32 %N, 0
; CHECK:         br i1 %cmp3, label %for.body.preheader, label %for.cond.cleanup
; CHECK:       for.body.preheader:
; CHECK:         %cloop.begin = call i32 @llvm.colossus.cloop.begin(i32 %N, i32 0)
; CHECK:         br label %for.body
; CHECK:       for.body:
; CHECK:         %0 = phi i32 [ %cloop.begin, %for.body.preheader ], [ %cloop.end.iv, %for.body ]
; CHECK:         %1 = load <2 x float>, <2 x float>* %x
; CHECK:         store <2 x float> %1, <2 x float>* %y
; CHECK:         %cloop.end = call { i32, i32 } @llvm.colossus.cloop.end(i32 %0, i32 0)
; CHECK:         %cloop.end.iv = extractvalue { i32, i32 } %cloop.end, 0
; CHECK:         %cloop.end.cc = extractvalue { i32, i32 } %cloop.end, 1
; CHECK:         %cloop.end.cc.trunc = trunc i32 %cloop.end.cc to i1
; CHECK:         br i1 %cloop.end.cc.trunc, label %for.body, label %for.cond.cleanup
; CHECK:       for.cond.cleanup:
; CHECK:         ret void
; CHECK:       }
define void @reversed_branch_loop(i32 %N, <2 x float>* %x, <2 x float>* %y)  {
entry:
  %cmp3 = icmp sgt i32 %N, 0
  br i1 %cmp3, label %for.body.preheader, label %for.cond.cleanup
for.body.preheader:
  br label %for.body
for.body:
  %lsr.iv = phi i32 [ %N, %for.body.preheader ], [ %lsr.iv.next, %for.body ]
  %0 = load <2 x float>, <2 x float>* %x
  store <2 x float> %0, <2 x float>* %y
  %lsr.iv.next = add i32 %lsr.iv, -1
  %exitcond = icmp ne i32 %lsr.iv.next, 0
  br i1 %exitcond, label %for.body, label %for.cond.cleanup
for.cond.cleanup:
  ret void
}

; CHECK-LABEL: define void @constant_trip_count(<2 x float>* %x, <2 x float>* %y)
; CHECK:       entry:
; IPU1:          %cloop.begin = call i32 @llvm.colossus.cloop.begin(i32 8192, i32 0)
; IPU2:          %cloop.begin = call i32 @llvm.colossus.cloop.begin(i32 8192, i32 1)
; CHECK:         br label %for.body
; CHECK:       for.body:
; CHECK:         %0 = phi i32  [ %cloop.begin, %entry ], [ %cloop.end.iv, %for.body ]
; CHECK:         %1 = load <2 x float>, <2 x float>* %x
; CHECK:         store <2 x float> %1, <2 x float>* %y
; IPU1:          %cloop.end = call { i32, i32 } @llvm.colossus.cloop.end(i32 %0, i32 0)
; IPU2:          %cloop.end = call { i32, i32 } @llvm.colossus.cloop.end(i32 %0, i32 1)
; CHECK:         %cloop.end.iv = extractvalue { i32, i32 } %cloop.end, 0
; CHECK:         %cloop.end.cc = extractvalue { i32, i32 } %cloop.end, 1
; CHECK:         %cloop.end.cc.trunc = trunc i32 %cloop.end.cc to i1
; CHECK:         br i1 %cloop.end.cc.trunc, label %for.body, label %for.cond.cleanup
; CHECK:       for.cond.cleanup:
; CHECK:         ret void
; CHECK:       }
define void @constant_trip_count(<2 x float>* %x, <2 x float>* %y)  {
entry:
  br label %for.body
for.body:
  %lsr.iv = phi i32 [ %lsr.iv.next, %for.body ], [ 8192, %entry ]
  %0 = load <2 x float>, <2 x float>* %x
  store <2 x float> %0, <2 x float>* %y
  %lsr.iv.next = add i32 %lsr.iv, -1
  %exitcond = icmp eq i32 %lsr.iv.next, 0
  br i1 %exitcond, label %for.cond.cleanup, label %for.body
for.cond.cleanup:
  ret void
}

; CHECK-LABEL: define void @short_trip_count(i16 %N, <2 x float>* %x, <2 x float>* %y)
; CHECK:       entry:
; CHECK:         %cmp3 = icmp sgt i16 %N, 0
; IPU2:          %0 = add i16 %N, -1
; IPU2:          %1 = zext i16 %0 to i32
; CHECK:         br i1 %cmp3, label %for.body.preheader, label %for.cond.cleanup
; CHECK:       for.body.preheader:
; IPU1:          %0 = add i16 %N, -1
; IPU1:          %1 = zext i16 %0 to i32
; IPU1:          %cloop.begin = call i32 @llvm.colossus.cloop.begin(i32 %2, i32 0)
; IPU2:          %cloop.begin = call i32 @llvm.colossus.cloop.begin(i32 %2, i32 1)
; CHECK:         br label %for.body
; CHECK:       for.body:
; CHECK:         %3 = phi i32 [ %cloop.begin, %for.body.preheader ], [ %cloop.end.iv, %for.body ]
; CHECK:         %4 = load <2 x float>, <2 x float>* %x, align 8
; CHECK:         store <2 x float> %4, <2 x float>* %y, align 8
; IPU1:          %cloop.end = call { i32, i32 } @llvm.colossus.cloop.end(i32 %3, i32 0)
; IPU2:          %cloop.end = call { i32, i32 } @llvm.colossus.cloop.end(i32 %3, i32 1)
; CHECK:         %cloop.end.iv = extractvalue { i32, i32 } %cloop.end, 0
; CHECK:         %cloop.end.cc = extractvalue { i32, i32 } %cloop.end, 1
; CHECK:         %cloop.end.cc.trunc = trunc i32 %cloop.end.cc to i1
; CHECK:         br i1 %cloop.end.cc.trunc, label %for.body, label %for.cond.cleanup
; CHECK:       for.cond.cleanup:
; CHECK:         ret void
; CHECK:       }
define void @short_trip_count(i16 %N, <2 x float>* %x, <2 x float>* %y)  {
entry:
  %cmp3 = icmp sgt i16 %N, 0
  br i1 %cmp3, label %for.body.preheader, label %for.cond.cleanup
for.body.preheader:
  br label %for.body
for.body:
  %lsr.iv = phi i16 [ %N, %for.body.preheader ], [ %lsr.iv.next, %for.body ]
  %0 = load <2 x float>, <2 x float>* %x
  store <2 x float> %0, <2 x float>* %y
  %lsr.iv.next = add i16 %lsr.iv, -1
  %exitcond = icmp eq i16 %lsr.iv.next, 0
  br i1 %exitcond, label %for.cond.cleanup, label %for.body
for.cond.cleanup:
  ret void
}

; CHECK-LABEL: define void @char_trip_count(i8 %N, <2 x float>* %x, <2 x float>* %y)
; CHECK:       entry:
; CHECK:         %cmp3 = icmp sgt i8 %N, 0
; CHECK:         %0 = add i8 %N, -1
; CHECK:         %1 = zext i8 %0 to i32
; CHECK:         br i1 %cmp3, label %for.body.preheader, label %for.cond.cleanup
; CHECK:       for.body.preheader:
; CHECK:         %cloop.begin = call i32 @llvm.colossus.cloop.begin(i32 %2, i32 1)
; CHECK:         br label %for.body
; CHECK:       for.body:
; CHECK:         %3 = phi i32 [ %cloop.begin, %for.body.preheader ], [ %cloop.end.iv, %for.body ]
; CHECK:         %4 = load <2 x float>, <2 x float>* %x, align 8
; CHECK:         store <2 x float> %4, <2 x float>* %y, align 8
; CHECK:         %cloop.end = call { i32, i32 } @llvm.colossus.cloop.end(i32 %3, i32 1)
; CHECK:         %cloop.end.iv = extractvalue { i32, i32 } %cloop.end, 0
; CHECK:         %cloop.end.cc = extractvalue { i32, i32 } %cloop.end, 1
; CHECK:         %cloop.end.cc.trunc = trunc i32 %cloop.end.cc to i1
; CHECK:         br i1 %cloop.end.cc.trunc, label %for.body, label %for.cond.cleanup
; CHECK:       for.cond.cleanup:
; CHECK:         ret void
; CHECK:       }
define void @char_trip_count(i8 %N, <2 x float>* %x, <2 x float>* %y)  {
entry:
  %cmp3 = icmp sgt i8 %N, 0
  br i1 %cmp3, label %for.body.preheader, label %for.cond.cleanup
for.body.preheader:
  br label %for.body
for.body:
  %lsr.iv = phi i8 [ %N, %for.body.preheader ], [ %lsr.iv.next, %for.body ]
  %0 = load <2 x float>, <2 x float>* %x
  store <2 x float> %0, <2 x float>* %y
  %lsr.iv.next = add i8 %lsr.iv, -1
  %exitcond = icmp eq i8 %lsr.iv.next, 0
  br i1 %exitcond, label %for.cond.cleanup, label %for.body
for.cond.cleanup:
  ret void
}

; CHECK-LABEL: define void @long_trip_count(i64 %N, <2 x float>* %x, <2 x float>* %y)
; CHECK-NOT:   colossus.cloop.begin
; CHECK-NOT:   colossus.cloop.end
define void @long_trip_count(i64 %N, <2 x float>* %x, <2 x float>* %y)  {
entry:
  %cmp3 = icmp sgt i64 %N, 0
  br i1 %cmp3, label %for.body.preheader, label %for.cond.cleanup
for.body.preheader:
  br label %for.body
for.body:
  %lsr.iv = phi i64 [ %N, %for.body.preheader ], [ %lsr.iv.next, %for.body ]
  %0 = load <2 x float>, <2 x float>* %x
  store <2 x float> %0, <2 x float>* %y
  %lsr.iv.next = add i64 %lsr.iv, -1
  %exitcond = icmp eq i64 %lsr.iv.next, 0
  br i1 %exitcond, label %for.cond.cleanup, label %for.body
for.cond.cleanup:
  ret void
}

; CHECK-LABEL: define void @nonzero_trip_count(i32 %N, <2 x float>* %x, <2 x float>* %y)
; CHECK:       entry:
; CHECK:         %cloop.begin = call i32 @llvm.colossus.cloop.begin(i32 %N, i32 0)
; CHECK:         br label %for.body
; CHECK:       for.body:
; CHECK:         %0 = phi i32 [ %cloop.begin, %entry ], [ %cloop.end.iv, %for.body ]
; CHECK:         %1 = load <2 x float>, <2 x float>* %x
; CHECK:         store <2 x float> %1, <2 x float>* %y
; CHECK:         %cloop.end = call { i32, i32 } @llvm.colossus.cloop.end(i32 %0, i32 0)
; CHECK:         %cloop.end.iv = extractvalue { i32, i32 } %cloop.end, 0
; CHECK:         %cloop.end.cc = extractvalue { i32, i32 } %cloop.end, 1
; CHECK:         %cloop.end.cc.trunc = trunc i32 %cloop.end.cc to i1
; CHECK:         br i1 %cloop.end.cc.trunc, label %for.body, label %for.cond.cleanup
; CHECK:       for.cond.cleanup:
; CHECK:         ret void
; CHECK:       }
define void @nonzero_trip_count(i32 %N, <2 x float>* %x, <2 x float>* %y)  {
entry:
  br label %for.body
for.body:
  %lsr.iv = phi i32 [ %N, %entry ], [ %lsr.iv.next, %for.body ]
  %0 = load <2 x float>, <2 x float>* %x
  store <2 x float> %0, <2 x float>* %y
  %lsr.iv.next = add i32 %lsr.iv, -1
  %exitcond = icmp eq i32 %lsr.iv.next, 0
  br i1 %exitcond, label %for.cond.cleanup, label %for.body
for.cond.cleanup:
  ret void
}

; CHECK-LABEL: define void @computed_trip_count(i32 %N, <2 x float>* %x, <2 x float>* %y)
; CHECK:       entry:
; CHECK:         %cN = lshr i32 %N, 4
; CHECK:         %cmp3 = icmp sgt i32 %cN, 0
; CHECK:         br i1 %cmp3, label %for.body.preheader, label %for.cond.cleanup
; CHECK:       for.body.preheader:
; CHECK:         %cloop.begin = call i32 @llvm.colossus.cloop.begin(i32 %cN, i32 0)
; CHECK:         br label %for.body
; CHECK:       for.body:
; CHECK:         %0 = phi i32 [ %cloop.begin, %for.body.preheader ], [ %cloop.end.iv, %for.body ]
; CHECK:         %1 = load <2 x float>, <2 x float>* %x
; CHECK:         store <2 x float> %1, <2 x float>* %y
; CHECK:         %cloop.end = call { i32, i32 } @llvm.colossus.cloop.end(i32 %0, i32 0)
; CHECK:         %cloop.end.iv = extractvalue { i32, i32 } %cloop.end, 0
; CHECK:         %cloop.end.cc = extractvalue { i32, i32 } %cloop.end, 1
; CHECK:         %cloop.end.cc.trunc = trunc i32 %cloop.end.cc to i1
; CHECK:         br i1 %cloop.end.cc.trunc, label %for.body, label %for.cond.cleanup
; CHECK:       for.cond.cleanup:
; CHECK:         ret void
; CHECK:       }
define void @computed_trip_count(i32 %N, <2 x float>* %x, <2 x float>* %y)  {
entry:
  %cN = lshr i32 %N, 4
  %cmp3 = icmp sgt i32 %cN, 0
  br i1 %cmp3, label %for.body.preheader, label %for.cond.cleanup
for.body.preheader:
  br label %for.body
for.body:
  %lsr.iv = phi i32 [ %cN, %for.body.preheader ], [ %lsr.iv.next, %for.body ]
  %0 = load <2 x float>, <2 x float>* %x
  store <2 x float> %0, <2 x float>* %y
  %lsr.iv.next = add i32 %lsr.iv, -1
  %exitcond = icmp eq i32 %lsr.iv.next, 0
  br i1 %exitcond, label %for.cond.cleanup, label %for.body
for.cond.cleanup:
  ret void
}

; i12 is small enough to be within the limit for rpt
; CHECK-LABEL: define void @i12_trip_count(i12 %N, <2 x float>* %x, <2 x float>* %y)
; CHECK:         %0 = add i12 %N, -1
; CHECK:         %1 = zext i12 %0 to i32
; CHECK:       for.body.preheader:
; CHECK:         %cloop.begin = call i32 @llvm.colossus.cloop.begin(i32 %2, i32 1)
; CHECK:         br label %for.body
; CHECK:       for.body:
; CHECK:         %3 = phi i32 [ %cloop.begin, %for.body.preheader ], [ %cloop.end.iv, %for.body ]
; CHECK:         %cloop.end = call { i32, i32 } @llvm.colossus.cloop.end(i32 %3, i32 1)
; CHECK:       }
define void @i12_trip_count(i12 %N, <2 x float>* %x, <2 x float>* %y)  {
entry:
  %cmp3 = icmp sgt i12 %N, 0
  br i1 %cmp3, label %for.body.preheader, label %for.cond.cleanup
for.body.preheader:
  br label %for.body
for.body:
  %lsr.iv = phi i12 [ %N, %for.body.preheader ], [ %lsr.iv.next, %for.body ]
  %0 = load <2 x float>, <2 x float>* %x
  store <2 x float> %0, <2 x float>* %y
  %lsr.iv.next = add i12 %lsr.iv, -1
  %exitcond = icmp eq i12 %lsr.iv.next, 0
  br i1 %exitcond, label %for.cond.cleanup, label %for.body
for.cond.cleanup:
  ret void
}

; i13 is outside the limit for rpt
; CHECK-LABEL: define void @i13_trip_count(i13 %N, <2 x float>* %x, <2 x float>* %y)
; IPU2:         %0 = add i13 %N, -1
; IPU2:         %1 = zext i13 %0 to i32
; CHECK:       for.body.preheader:
; IPU1:          %0 = add i13 %N, -1
; IPU1:          %1 = zext i13 %0 to i32
; IPU1:          %cloop.begin = call i32 @llvm.colossus.cloop.begin(i32 %2, i32 0)
; IPU2:          %cloop.begin = call i32 @llvm.colossus.cloop.begin(i32 %2, i32 1)
; CHECK:         br label %for.body
; CHECK:       for.body:
; CHECK:         %3 = phi i32 [ %cloop.begin, %for.body.preheader ], [ %cloop.end.iv, %for.body ]
; IPU1:          %cloop.end = call { i32, i32 } @llvm.colossus.cloop.end(i32 %3, i32 0)
; IPU2:          %cloop.end = call { i32, i32 } @llvm.colossus.cloop.end(i32 %3, i32 1)
; CHECK:       }
define void @i13_trip_count(i13 %N, <2 x float>* %x, <2 x float>* %y)  {
entry:
  %cmp3 = icmp sgt i13 %N, 0
  br i1 %cmp3, label %for.body.preheader, label %for.cond.cleanup
for.body.preheader:
  br label %for.body
for.body:
  %lsr.iv = phi i13 [ %N, %for.body.preheader ], [ %lsr.iv.next, %for.body ]
  %0 = load <2 x float>, <2 x float>* %x
  store <2 x float> %0, <2 x float>* %y
  %lsr.iv.next = add i13 %lsr.iv, -1
  %exitcond = icmp eq i13 %lsr.iv.next, 0
  br i1 %exitcond, label %for.cond.cleanup, label %for.body
for.cond.cleanup:
  ret void
}

; CHECK-LABEL: define void @small_mask_simple_loop(i32 %argN, <2 x float>* %x, <2 x float>* %y)
; CHECK:       for.body.preheader:
; CHECK:         %N = and i32 %argN, 4095
; CHECK:         %cloop.begin = call i32 @llvm.colossus.cloop.begin(i32 %N, i32 1)
; CHECK:         br label %for.body
; CHECK:       for.body:
; CHECK:         %0 = phi i32 [ %cloop.begin, %for.body.preheader ], [ %cloop.end.iv, %for.body ]
; CHECK:         %cloop.end = call { i32, i32 } @llvm.colossus.cloop.end(i32 %0, i32 1)
; CHECK:         br i1 %cloop.end.cc.trunc, label %for.body, label %for.cond.cleanup
; CHECK:       }
define void @small_mask_simple_loop(i32 %argN, <2 x float>* %x, <2 x float>* %y)  {
entry:
  %cmp3 = icmp sgt i32 %argN, 0
  br i1 %cmp3, label %for.body.preheader, label %for.cond.cleanup
for.body.preheader:
  %N = and i32 %argN, 4095
  br label %for.body
for.body:
  %lsr.iv = phi i32 [ %N, %for.body.preheader ], [ %lsr.iv.next, %for.body ]
  %0 = load <2 x float>, <2 x float>* %x
  store <2 x float> %0, <2 x float>* %y
  %lsr.iv.next = add i32 %lsr.iv, -1
  %exitcond = icmp eq i32 %lsr.iv.next, 0
  br i1 %exitcond, label %for.cond.cleanup, label %for.body
for.cond.cleanup:
  ret void
}

; CHECK-LABEL: define void @large_mask_simple_loop(i32 %argN, <2 x float>* %x, <2 x float>* %y)
; CHECK:       for.body.preheader:
; CHECK:         %N = and i32 %argN, 8191
; IPU1:          %cloop.begin = call i32 @llvm.colossus.cloop.begin(i32 %N, i32 0)
; IPU2:          %cloop.begin = call i32 @llvm.colossus.cloop.begin(i32 %N, i32 1)
; CHECK:         br label %for.body
; CHECK:       for.body:
; CHECK:         %0 = phi i32 [ %cloop.begin, %for.body.preheader ], [ %cloop.end.iv, %for.body ]
; IPU1:          %cloop.end = call { i32, i32 } @llvm.colossus.cloop.end(i32 %0, i32 0)
; IPU2:          %cloop.end = call { i32, i32 } @llvm.colossus.cloop.end(i32 %0, i32 1)
; CHECK:         br i1 %cloop.end.cc.trunc, label %for.body, label %for.cond.cleanup
; CHECK:       }
define void @large_mask_simple_loop(i32 %argN, <2 x float>* %x, <2 x float>* %y)  {
entry:
  %cmp3 = icmp sgt i32 %argN, 0
  br i1 %cmp3, label %for.body.preheader, label %for.cond.cleanup
for.body.preheader:
  %N = and i32 %argN, 8191
  br label %for.body
for.body:
  %lsr.iv = phi i32 [ %N, %for.body.preheader ], [ %lsr.iv.next, %for.body ]
  %0 = load <2 x float>, <2 x float>* %x
  store <2 x float> %0, <2 x float>* %y
  %lsr.iv.next = add i32 %lsr.iv, -1
  %exitcond = icmp eq i32 %lsr.iv.next, 0
  br i1 %exitcond, label %for.cond.cleanup, label %for.body
for.cond.cleanup:
  ret void
}

; CHECK-LABEL: define void @load_small_counter(i32* %pN, <2 x float>* %x, <2 x float>* %y)
; CHECK:       entry:
; CHECK:         %N = load i32, i32* %pN, align 4, !range !0
; CHECK:         %cmp3 = icmp sgt i32 %N, 0
; CHECK:         br i1 %cmp3, label %for.body.preheader, label %for.cond.cleanup
; CHECK:       for.body.preheader:
; CHECK:         %cloop.begin = call i32 @llvm.colossus.cloop.begin(i32 %N, i32 1)
; CHECK:         br label %for.body
; CHECK:       for.body:
; CHECK:         %0 = phi i32 [ %cloop.begin, %for.body.preheader ], [ %cloop.end.iv, %for.body ]
; CHECK:         %cloop.end = call { i32, i32 } @llvm.colossus.cloop.end(i32 %0, i32 1)
; CHECK:         br i1 %cloop.end.cc.trunc, label %for.body, label %for.cond.cleanup
; CHECK:       }
define void @load_small_counter(i32* %pN, <2 x float>* %x, <2 x float>* %y)  {
entry:
  %N = load i32, i32* %pN, !range !0
  %cmp3 = icmp sgt i32 %N, 0
  br i1 %cmp3, label %for.body.preheader, label %for.cond.cleanup
for.body.preheader:
  br label %for.body
for.body:
  %lsr.iv = phi i32 [ %N, %for.body.preheader ], [ %lsr.iv.next, %for.body ]
  %0 = load <2 x float>, <2 x float>* %x
  store <2 x float> %0, <2 x float>* %y
  %lsr.iv.next = add i32 %lsr.iv, -1
  %exitcond = icmp eq i32 %lsr.iv.next, 0
  br i1 %exitcond, label %for.cond.cleanup, label %for.body
for.cond.cleanup:
  ret void
}
!0 = !{ i32 0, i32 4096 }

; CHECK-LABEL: define void @load_large_counter(i32* %pN, <2 x float>* %x, <2 x float>* %y)
; CHECK:       entry:
; CHECK:         %N = load i32, i32* %pN, align 4, !range !1
; CHECK:         %cmp3 = icmp sgt i32 %N, 0
; CHECK:         br i1 %cmp3, label %for.body.preheader, label %for.cond.cleanup
; CHECK:       for.body.preheader:
; IPU1:          %cloop.begin = call i32 @llvm.colossus.cloop.begin(i32 %N, i32 0)
; IPU2:          %cloop.begin = call i32 @llvm.colossus.cloop.begin(i32 %N, i32 1)
; CHECK:         br label %for.body
; CHECK:       for.body:
; CHECK:         %0 = phi i32 [ %cloop.begin, %for.body.preheader ], [ %cloop.end.iv, %for.body ]
; IPU1:          %cloop.end = call { i32, i32 } @llvm.colossus.cloop.end(i32 %0, i32 0)
; IPU2:          %cloop.end = call { i32, i32 } @llvm.colossus.cloop.end(i32 %0, i32 1)
; CHECK:         br i1 %cloop.end.cc.trunc, label %for.body, label %for.cond.cleanup
; CHECK:       }
define void @load_large_counter(i32* %pN, <2 x float>* %x, <2 x float>* %y)  {
entry:
  %N = load i32, i32* %pN, !range !1
  %cmp3 = icmp sgt i32 %N, 0
  br i1 %cmp3, label %for.body.preheader, label %for.cond.cleanup
for.body.preheader:
  br label %for.body
for.body:
  %lsr.iv = phi i32 [ %N, %for.body.preheader ], [ %lsr.iv.next, %for.body ]
  %0 = load <2 x float>, <2 x float>* %x
  store <2 x float> %0, <2 x float>* %y
  %lsr.iv.next = add i32 %lsr.iv, -1
  %exitcond = icmp eq i32 %lsr.iv.next, 0
  br i1 %exitcond, label %for.cond.cleanup, label %for.body
for.cond.cleanup:
  ret void
}
!1 = !{ i32 0, i32 4097 }

; IPU2-LABEL: define void @load_large_counter_ipu2(i32* %pN, <2 x float>* %x, <2 x float>* %y)
; IPU2:       entry:
; IPU2:         %N = load i32, i32* %pN, align 4, !range !2
; IPU2:         %cmp3 = icmp sgt i32 %N, 0
; IPU2:         br i1 %cmp3, label %for.body.preheader, label %for.cond.cleanup
; IPU2:       for.body.preheader:
; IPU2:         %cloop.begin = call i32 @llvm.colossus.cloop.begin(i32 %N, i32 0)
; IPU2:         br label %for.body
; IPU2:       for.body:
; IPU2:         %0 = phi i32 [ %cloop.begin, %for.body.preheader ], [ %cloop.end.iv, %for.body ]
; IPU2:         %cloop.end = call { i32, i32 } @llvm.colossus.cloop.end(i32 %0, i32 0)
; IPU2:         br i1 %cloop.end.cc.trunc, label %for.body, label %for.cond.cleanup
; IPU2:       }
define void @load_large_counter_ipu2(i32* %pN, <2 x float>* %x, <2 x float>* %y)  {
entry:
  %N = load i32, i32* %pN, !range !2
  %cmp3 = icmp sgt i32 %N, 0
  br i1 %cmp3, label %for.body.preheader, label %for.cond.cleanup
for.body.preheader:
  br label %for.body
for.body:
  %lsr.iv = phi i32 [ %N, %for.body.preheader ], [ %lsr.iv.next, %for.body ]
  %0 = load <2 x float>, <2 x float>* %x
  store <2 x float> %0, <2 x float>* %y
  %lsr.iv.next = add i32 %lsr.iv, -1
  %exitcond = icmp eq i32 %lsr.iv.next, 0
  br i1 %exitcond, label %for.cond.cleanup, label %for.body
for.cond.cleanup:
  ret void
}
!2 = !{ i32 0, i32 65537 }

; Nested loop, only innermost loop transformed
declare void @sink(i32, i32)

; CHECK-LABEL: define void @nested(i32 %n, i32 %m)
; CHECK:       entry:
; CHECK:         %cmp16 = icmp sgt i32 %n, 0
; CHECK:         br i1 %cmp16, label %for.cond1.preheader.lr.ph, label %for.cond.cleanup
; CHECK:       for.cond1.preheader.lr.ph:
; CHECK:         %cmp214 = icmp sgt i32 %m, 0
; CHECK:         %cloop.begin = call i32 @llvm.colossus.cloop.begin(i32 %n, i32 0)
; CHECK:         br label %for.cond1.preheader
; CHECK:       for.cond1.preheader:
; CHECK:         %i.017 = phi i32 [ 0, %for.cond1.preheader.lr.ph ], [ %inc6, %for.cond.cleanup3 ]
; CHECK:         %0 = phi i32 [ %cloop.begin, %for.cond1.preheader.lr.ph ], [ %cloop.end.iv3, %for.cond.cleanup3 ]
; CHECK:         br i1 %cmp214, label %for.body4.preheader, label %for.cond.cleanup3
; CHECK:       for.body4.preheader:
; CHECK:         %cloop.begin1 = call i32 @llvm.colossus.cloop.begin(i32 %m, i32 0)
; CHECK:         br label %for.body4
; CHECK:       for.body4:
; CHECK:         %j.015 = phi i32 [ %inc, %for.body4 ], [ 0, %for.body4.preheader ]
; CHECK:         %1 = phi i32 [ %cloop.begin1, %for.body4.preheader ], [ %cloop.end.iv, %for.body4 ]
; CHECK:         tail call void @sink(i32 %i.017, i32 %j.015)
; CHECK:         %inc = add nuw nsw i32 %j.015, 1
; CHECK:         %cloop.end = call { i32, i32 } @llvm.colossus.cloop.end(i32 %1, i32 0)
; CHECK:         %cloop.end.iv = extractvalue { i32, i32 } %cloop.end, 0
; CHECK:         %cloop.end.cc = extractvalue { i32, i32 } %cloop.end, 1
; CHECK:         %cloop.end.cc.trunc = trunc i32 %cloop.end.cc to i1
; CHECK:         br i1 %cloop.end.cc.trunc, label %for.body4, label %for.cond.cleanup3
; CHECK:       for.cond.cleanup3:
; CHECK:         %inc6 = add nuw nsw i32 %i.017, 1
; CHECK:         %cloop.end2 = call { i32, i32 } @llvm.colossus.cloop.end(i32 %0, i32 0)
; CHECK:         %cloop.end.iv3 = extractvalue { i32, i32 } %cloop.end2, 0
; CHECK:         %cloop.end.cc4 = extractvalue { i32, i32 } %cloop.end2, 1
; CHECK:         %cloop.end.cc.trunc5 = trunc i32 %cloop.end.cc4 to i1
; CHECK:         br i1 %cloop.end.cc.trunc5, label %for.cond1.preheader, label %for.cond.cleanup
; CHECK:       for.cond.cleanup:
; CHECK:         ret void
; CHECK:       }
define void @nested(i32 %n, i32 %m) {
entry:
  %cmp16 = icmp sgt i32 %n, 0
  br i1 %cmp16, label %for.cond1.preheader.lr.ph, label %for.cond.cleanup
for.cond1.preheader.lr.ph:
  %cmp214 = icmp sgt i32 %m, 0
  br label %for.cond1.preheader
for.cond1.preheader:
  %i.017 = phi i32 [ 0, %for.cond1.preheader.lr.ph ], [ %inc6, %for.cond.cleanup3 ]
  br i1 %cmp214, label %for.body4.preheader, label %for.cond.cleanup3
for.body4.preheader:
  br label %for.body4
for.body4:
  %j.015 = phi i32 [ %inc, %for.body4 ], [ 0, %for.body4.preheader ]
  tail call void @sink(i32 %i.017, i32 %j.015)
  %inc = add nuw nsw i32 %j.015, 1
  %exitcond = icmp eq i32 %inc, %m
  br i1 %exitcond, label %for.cond.cleanup3, label %for.body4
for.cond.cleanup3:
  %inc6 = add nuw nsw i32 %i.017, 1
  %exitcond18 = icmp eq i32 %inc6, %n
  br i1 %exitcond18, label %for.cond.cleanup, label %for.cond1.preheader
for.cond.cleanup:
  ret void
}

; USELESS-LABEL: define void @max_useless(i32 %n, i32* nocapture %ptr)
; USELESS-NEXT: entry:
; USELESS-NEXT: ret void
; USELESS-NEXT: }
define void @max_useless(i32 %n, i32* %ptr) {
entry:
  br label %for.preheader
for.preheader:
  br label %for.body
for.body:
  %iv = phi i32 [ %n, %for.preheader ], [ %iv.next, %for.body ]
  %sum.loop.start = phi i32 [ 0, %for.preheader ], [ %sum.loop.next, %for.body ]
  %ptr.loop.start = phi i32* [ %ptr, %for.preheader ], [ %ptr.loop.next, %for.body]
  %0 = load i32, i32* %ptr.loop.start
  %sum.loop.next = add i32 %sum.loop.start, %0
  %intptr.loop.start = ptrtoint i32* %ptr.loop.start to i32
  %intptr.loop.next = add i32 %intptr.loop.start, 1
  %ptr.loop.next = inttoptr i32 %intptr.loop.next to i32*
  %iv.next = sub i32 %iv, 1
  %1 = icmp ule i32 %iv.next, 0
  br i1 %1, label %for.cleanup, label %for.body
for.cleanup:
  ret void
}

; USELESS-LABEL: define void @not_useless_atomic(i32 %n, i32* nocapture readonly %ptr)
; USELESS-NEXT: entry:
; USELESS-NEXT: %cloop.begin = call i32 @llvm.colossus.cloop.begin(i32 %n, i32 0)
; USELESS-NEXT: br label %for.body
; USELESS-EMPTY:
; USELESS-NEXT: for.body:
; USELESS-NEXT: %0 = phi i32 [ %cloop.begin, %entry ], [ %cloop.end.iv, %for.body ]
; USELESS-NEXT: %1 = load atomic i32, i32* %ptr acquire, align 4
; USELESS-NEXT: %cloop.end = call { i32, i32 } @llvm.colossus.cloop.end(i32 %0, i32 0)
; USELESS-NEXT: %cloop.end.iv = extractvalue { i32, i32 } %cloop.end, 0
; USELESS-NEXT: %cloop.end.cc = extractvalue { i32, i32 } %cloop.end, 1
; USELESS-NEXT: %cloop.end.cc.trunc = trunc i32 %cloop.end.cc to i1
; USELESS-NEXT: br i1 %cloop.end.cc.trunc, label %for.body, label %for.cleanup
; USELESS-EMPTY:
; USELESS-NEXT: for.cleanup:
; USELESS-NEXT: ret void
; USELESS-NEXT: }
define void @not_useless_atomic(i32 %n, i32* %ptr) {
entry:
  br label %for.preheader
for.preheader:
  br label %for.body
for.body:
  %iv = phi i32 [ %n, %for.preheader ], [ %iv.next, %for.body ]
  %0 = load atomic i32, i32* %ptr acquire, align 4
  %iv.next = sub i32 %iv, 1
  %1 = icmp ule i32 %iv.next, 0
  br i1 %1, label %for.cleanup, label %for.body
for.cleanup:
  ret void
}

; USELESS-LABEL: define void @not_useless_volatile(i32 %n, i32* %ptr)
; USELESS-NEXT: entry:
; USELESS-NEXT: %cloop.begin = call i32 @llvm.colossus.cloop.begin(i32 %n, i32 0)
; USELESS-NEXT: br label %for.body
; USELESS-EMPTY:
; USELESS-NEXT: for.body:
; USELESS-NEXT: %0 = phi i32 [ %cloop.begin, %entry ], [ %cloop.end.iv, %for.body ]
; USELESS-NEXT: %1 = load volatile i32, i32* %ptr
; USELESS-NEXT: %cloop.end = call { i32, i32 } @llvm.colossus.cloop.end(i32 %0, i32 0)
; USELESS-NEXT: %cloop.end.iv = extractvalue { i32, i32 } %cloop.end, 0
; USELESS-NEXT: %cloop.end.cc = extractvalue { i32, i32 } %cloop.end, 1
; USELESS-NEXT: %cloop.end.cc.trunc = trunc i32 %cloop.end.cc to i1
; USELESS-NEXT: br i1 %cloop.end.cc.trunc, label %for.body, label %for.cleanup
; USELESS-EMPTY:
; USELESS-NEXT: for.cleanup:
; USELESS-NEXT: ret void
; USELESS-NEXT: }
define void @not_useless_volatile(i32 %n, i32* %ptr) {
entry:
  br label %for.preheader
for.preheader:
  br label %for.body
for.body:
  %iv = phi i32 [ %n, %for.preheader ], [ %iv.next, %for.body ]
  %0 = load volatile i32, i32* %ptr
  %iv.next = sub i32 %iv, 1
  %1 = icmp ule i32 %iv.next, 0
  br i1 %1, label %for.cleanup, label %for.body
for.cleanup:
  ret void
}

; USELESS-LABEL: define void @not_useless_store(i32 %n, i32* nocapture writeonly %ptr)
; USELESS-NEXT: entry:
; USELESS-NEXT: %cloop.begin = call i32 @llvm.colossus.cloop.begin(i32 %n, i32 0)
; USELESS-NEXT: br label %for.body
; USELESS-EMPTY:
; USELESS-NEXT: for.body:
; USELESS-NEXT: %iv = phi i32 [ %n, %entry ], [ %idx, %for.body ]
; USELESS-NEXT: %0 = phi i32 [ %cloop.begin, %entry ], [ %cloop.end.iv, %for.body ]
; USELESS-NEXT: %idx = add i32 %iv, -1
; USELESS-NEXT: %1 = sext i32 %idx to i64
; USELESS-NEXT: %dst = getelementptr i32, i32* %ptr, i64 %1
; USELESS-NEXT: store i32 0, i32* %dst
; USELESS-NEXT: %cloop.end = call { i32, i32 } @llvm.colossus.cloop.end(i32 %0, i32 0)
; USELESS-NEXT: %cloop.end.iv = extractvalue { i32, i32 } %cloop.end, 0
; USELESS-NEXT: %cloop.end.cc = extractvalue { i32, i32 } %cloop.end, 1
; USELESS-NEXT: %cloop.end.cc.trunc = trunc i32 %cloop.end.cc to i1
; USELESS-NEXT: br i1 %cloop.end.cc.trunc, label %for.body, label %for.cleanup
; USELESS-EMPTY:
; USELESS-NEXT: for.cleanup:
; USELESS-NEXT: ret void
; USELESS-NEXT: }
define void @not_useless_store(i32 %n, i32* %ptr) {
entry:
  br label %for.preheader
for.preheader:
  br label %for.body
for.body:
  %iv = phi i32 [ %n, %for.preheader ], [ %iv.next, %for.body ]
  %idx = add i32 %iv, -1
  %dst = getelementptr i32, i32* %ptr, i32 %idx
  store i32 0, i32* %dst
  %iv.next = sub i32 %iv, 1
  %0 = icmp ule i32 %iv.next, 0
  br i1 %0, label %for.cleanup, label %for.body
for.cleanup:
  ret void
}

; USELESS-LABEL: define i32 @not_useless_compute(i32 %n, i32 %m)
; USELESS-NEXT: entry:
; USELESS-NEXT: %cloop.begin = call i32 @llvm.colossus.cloop.begin(i32 %n, i32 0)
; USELESS-NEXT: br label %for.body
; USELESS-EMPTY:
; USELESS-NEXT: for.body:
; USELESS-NEXT: %iv = phi i32 [ %n, %entry ], [ %iv.next, %for.body ]
; USELESS-NEXT: %sum = phi i32 [ 0, %entry ], [ %sum.next, %for.body ]
; USELESS-NEXT: %0 = phi i32 [ %cloop.begin, %entry ], [ %cloop.end.iv, %for.body ]
; USELESS-NEXT: %modi = urem i32 %iv, %m
; USELESS-NEXT: %sum.next = add i32 %modi, %sum
; USELESS-NEXT: %iv.next = add i32 %iv, -1
; USELESS-NEXT: %cloop.end = call { i32, i32 } @llvm.colossus.cloop.end(i32 %0, i32 0)
; USELESS-NEXT: %cloop.end.iv = extractvalue { i32, i32 } %cloop.end, 0
; USELESS-NEXT: %cloop.end.cc = extractvalue { i32, i32 } %cloop.end, 1
; USELESS-NEXT: %cloop.end.cc.trunc = trunc i32 %cloop.end.cc to i1
; USELESS-NEXT: br i1 %cloop.end.cc.trunc, label %for.body, label %for.cleanup
; USELESS-EMPTY:
; USELESS-NEXT: for.cleanup:
; USELESS-NEXT: ret i32 %sum.next
; USELESS-NEXT: }
define i32 @not_useless_compute(i32 %n, i32 %m) {
entry:
  br label %for.preheader
for.preheader:
  br label %for.body
for.body:
  %iv = phi i32 [ %n, %for.preheader ], [ %iv.next, %for.body ]
  %sum = phi i32 [ 0, %for.preheader ], [ %sum.next, %for.body ]
  %modi = urem i32 %iv, %m
  %sum.next = add i32 %sum, %modi
  %iv.next = sub i32 %iv, 1
  %0 = icmp ule i32 %iv.next, 0
  br i1 %0, label %for.cleanup, label %for.body
for.cleanup:
  %sum.final = phi i32 [ %sum.next, %for.body ]
  ret i32 %sum.final
}


;CHECK-LABEL:  define i32 @loop_guard_intrinsic(i32 %x, i32* nocapture readonly %arr)
;CHECK:  entry:
;CHECK:    %and = and i32 %x, 255
;CHECK:    %cmp7.not = icmp eq i32 %and, 0
;CHECK:    %cloop.guard = call i32 @llvm.colossus.cloop.guard(i32 %and, i32 0)
;CHECK:    %cloop.guard.trunc = trunc i32 %cloop.guard to i1
;CHECK:    br i1 %cloop.guard.trunc, label %for.body.preheader, label %for.cond.cleanup

define i32 @loop_guard_intrinsic(i32 %x, i32* nocapture readonly %arr) {
entry:
  %and = and i32 %x, 255
  %cmp7.not = icmp eq i32 %and, 0
  br i1 %cmp7.not, label %for.cond.cleanup, label %for.body

for.cond.cleanup:
  %sum.0.lcssa = phi i32 [ 42, %entry ], [ %add, %for.body ]
  ret i32 %sum.0.lcssa

for.body:
  %i.09 = phi i32 [ %inc, %for.body ], [ 0, %entry ]
  %sum.08 = phi i32 [ %add, %for.body ], [ 42, %entry ]
  %arrayidx = getelementptr inbounds i32, i32* %arr, i32 %i.09
  %0 = load i32, i32* %arrayidx, align 4
  %add = add i32 %0, %sum.08
  %inc = add nuw nsw i32 %i.09, 1
  %exitcond.not = icmp eq i32 %inc, %and
  br i1 %exitcond.not, label %for.cond.cleanup, label %for.body
}
