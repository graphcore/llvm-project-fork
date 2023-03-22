; RUN: llc -march=colossus -enable-pipeliner=true < %s | FileCheck %s

%"class0" = type { i8*, i8*, i16, i16, i32 }

; Function Attrs: inaccessiblememonly mustprogress nofree nosync nounwind willreturn
declare void @llvm.assume(i1 noundef)

; CHECK-LABEL: SplitTranspose1D:

; Original preheader:
; Skip loop if IV is 0.
; CHECK: 	brz $m1, [[EXIT:\.LBB[0-9_]+]]
; CHECK: # %bb{{.*}}:
; CHECK: 	ld32 $m1, $m11, $m15, 13
; CHECK: 	mul $m1, $m0, $m1
; CHECK: 	sub $m1, $m9, $m1
; CHECK: 	mul $m1, $m1, $m7
; CHECK: 	ld32 $m2, $m11, $m15, 12
; CHECK: 	add $m2, $m8, $m2
; CHECK: 	add $m0, $m1, $m0
; CHECK: 	ld32 $m1, $m11, $m15, 15
; CHECK: 	shl $m3, $m1, 1
; CHECK: 	mul $m1, $m1, -14
; CHECK: 	ld32 $m6, $m11, $m15, 16
; CHECK: 	mul $m4, $m6, -3
; CHECK: 	ld32 $m8, $m11, $m15, 10
; CHECK: 	ld32 $m9, $m11, $m15, 17
; CHECK: 	add $m9, $m9, $m8
; CHECK: 	add $m2, $m2, $m0
; CHECK: 	or $m0, $m1, 1
; CHECK: 	st32 $m0, $m11, $m15, 15
; CHECK: 	st32 $m4, $m11, $m15, 12
; CHECK: 	add $m10, $m4, 1
; CHECK: 	ld32 $m0, $m11, $m15, 14
; CHECK: 	add $m8, $m0, -1
; CHECK: 	st32 $m3, $m11, $m15, 11
; CHECK: 	add $m0, $m3, -1
; CHECK: 	st32 $m0, $m11, $m15, 14
; CHECK: 	mul $m0, $m6, 5
; CHECK: 	st32 $m0, $m11, $m15, 13
; CHECK: 	mov $m6, $m10

; Software pipelined loop prologue:
; CHECK: 	shl $m0, $m15, 3
; CHECK: 	or $m0, $m0, 2
; CHECK: 	setzi $m1, 1
; CHECK: 	mov $m4, $m7
; CHECK: 	mul $m0, $m0, $m7
; CHECK: 	cmpslt $m10, $m1, $m5
; CHECK: 	st32 $m2, $m11, $m15, 8
; CHECK: 	add $m7, $m2, $m0
; CHECK: 	add $m1, $m15, 1
; CHECK: 	add $m2, $m9, 8
; CHECK: 	add $m0, $m5, -1
; CHECK: 	st32 $m6, $m11, $m15, 10
; CHECK: 	st32 $m8, $m11, $m15, 9
; CHECK: 	brz $m10, [[EPILOGUE:\.LBB[0-9_]+]]

; New preheader:
; CHECK: # %bb{{.*}}:
; CHECK: 	add $m0, $m0, -1
; CHECK: 	st32 $m4, $m11, $m15, 7

; Software pipelined loop kernel:
; CHECK: [[LOOP_LABEL:\.LBB[0-9_]+]]:
; CHECK: 	st32 $m2, $m11, $m15, 17
; CHECK: 	st32 $m9, $m11, $m15, 18
; CHECK: 	st32 $m1, $m11, $m15, 19
; CHECK: 	ld32 $m10, $m11, $m15, 16
; CHECK: 	ld32 $m3, $m11, $m15, 11
; CHECK: 	ld32 $m5, $m11, $m15, 12
; CHECK: 	ld32 $m8, $m11, $m15, 15
; CHECK: 	ld32 $m6, $m11, $m15, 10
; CHECK: 	ld32 $m4, $m11, $m15, 9
; CHECK: 	ld32 $m9, $m11, $m15, 14
; CHECK: 	ld32 $m1, $m11, $m15, 13
; CHECK: 	ld32 $m2, $m11, $m15, 18
; CHECK: 	#APP
; CHECK: 	nop
; CHECK: 	nop
; CHECK: 	nop
; CHECK: 	nop
; CHECK: 	#NO_APP
; CHECK: 	ld32 $m2, $m11, $m15, 17
; CHECK: 	mov $m9, $m2
; CHECK: 	ld32 $m1, $m11, $m15, 19
; CHECK: 	shl $m7, $m1, 3
; CHECK: 	or $m7, $m7, 2
; CHECK: 	add $m1, $m1, 1
; CHECK: 	ld32 $m3, $m11, $m15, 7
; CHECK: 	mul $m7, $m7, $m3
; CHECK: 	add $m2, $m2, 8
; CHECK: 	ld32 $m3, $m11, $m15, 8
; CHECK: 	add $m7, $m3, $m7
; CHECK: 	brnzdec $m0, [[LOOP_LABEL]]

; Software pipelined loop epilogue:
; CHECK: [[EPILOGUE]]:
; CHECK: 	ld32 $m0, $m11, $m15, 16
; CHECK: 	ld32 $m1, $m11, $m15, 11
; CHECK: 	ld32 $m2, $m11, $m15, 12
; CHECK: 	ld32 $m3, $m11, $m15, 15
; CHECK: 	ld32 $m4, $m11, $m15, 10
; CHECK: 	ld32 $m5, $m11, $m15, 9
; CHECK: 	ld32 $m6, $m11, $m15, 14
; CHECK: 	ld32 $m8, $m11, $m15, 13
; CHECK: 	#APP
; CHECK: 	nop
; CHECK: 	nop
; CHECK: 	nop
; CHECK: 	nop
; CHECK: 	#NO_APP
; CHECK: [[EXIT]]:

; Function Attrs: alwaysinline mustprogress nounwind
define weak_odr dso_local zeroext i1 @SplitTranspose1D(%"class0"* nonnull align 4 dereferenceable(16) %0, i32 %1) local_unnamed_addr align 2 {
  %3 = getelementptr inbounds %"class0", %"class0"* %0, i32 0, i32 4
  %4 = load i32, i32* %3, align 4
  %5 = lshr i32 %4, 22
  %6 = icmp ugt i32 %5, %1
  br i1 %6, label %7, label %72

7:                                                ; preds = %2
  %8 = getelementptr inbounds %"class0", %"class0"* %0, i32 0, i32 3
  %9 = load i16, i16* %8, align 2
  %10 = zext i16 %9 to i32
  %11 = shl nuw nsw i32 %10, 3
  %12 = getelementptr inbounds %"class0", %"class0"* %0, i32 0, i32 2
  %13 = load i16, i16* %12, align 4
  %14 = zext i16 %13 to i32
  %15 = shl nuw nsw i32 %14, 3
  %16 = mul i32 %15, %11
  %17 = shl i32 %1, 2
  %18 = and i32 %4, 1048575
  %19 = inttoptr i32 %18 to i8*
  call void @llvm.assume(i1 true) [ "align"(i8* %19, i32 2) ]
  %20 = inttoptr i32 %18 to i16*
  %21 = getelementptr inbounds i16, i16* %20, i32 %17
  %22 = load i16, i16* %21, align 2
  %23 = zext i16 %22 to i32
  %24 = shl nuw nsw i32 %23, 3
  %25 = getelementptr inbounds i16, i16* %21, i32 1
  %26 = load i16, i16* %25, align 2
  %27 = zext i16 %26 to i32
  %28 = mul nsw i32 %27, -8
  %29 = getelementptr inbounds i16, i16* %21, i32 2
  %30 = load i16, i16* %29, align 2
  %31 = zext i16 %30 to i32
  %32 = getelementptr inbounds i16, i16* %21, i32 3
  %33 = load i16, i16* %32, align 2
  %34 = zext i16 %33 to i32
  %35 = urem i32 %24, %16
  %36 = sub nsw i32 %24, %35
  %37 = getelementptr inbounds %"class0", %"class0"* %0, i32 0, i32 0
  %38 = load i8*, i8** %37, align 4
  call void @llvm.assume(i1 true) [ "align"(i8* %38, i32 8) ]
  %39 = getelementptr inbounds %"class0", %"class0"* %0, i32 0, i32 1
  %40 = load i8*, i8** %39, align 4
  call void @llvm.assume(i1 true) [ "align"(i8* %40, i32 8) ]
  %41 = getelementptr inbounds i8, i8* %40, i32 %36
  %42 = add nsw i32 %36, %28
  %43 = mul i32 %35, %15
  %44 = add i32 %42, %43
  %45 = add i32 %16, -1
  %46 = udiv i32 %44, %45
  %47 = mul i32 %46, %11
  %48 = sub i32 %35, %47
  %49 = getelementptr inbounds i8, i8* %38, i32 %24
  %50 = mul i32 %48, %15
  %51 = add i32 %50, %46
  %52 = getelementptr inbounds i8, i8* %41, i32 %51
  %53 = shl nuw nsw i32 %10, 1
  %54 = mul nsw i32 %10, -14
  %55 = or i32 %54, 1
  %56 = mul nsw i32 %14, -3
  %57 = add nsw i32 %56, 1
  %58 = add nsw i32 %31, -1
  %59 = add nsw i32 %53, -1
  %60 = mul nuw nsw i32 %14, 5
  %61 = icmp eq i16 %33, 0
  br i1 %61, label %72, label %62

62:                                               ; preds = %7, %62
  %63 = phi i32 [ %70, %62 ], [ 0, %7 ]
  %64 = shl i32 %63, 3
  %65 = getelementptr inbounds i8, i8* %49, i32 %64
  %66 = or i32 %64, 2
  %67 = mul i32 %66, %15
  %68 = getelementptr inbounds i8, i8* %52, i32 %67
  %69 = tail call { i8*, i8* } asm sideeffect "\0A\0A        nop\0A        nop\0A        nop\0A        nop\0A             ", "=r,=r,r,r,r,r,r,r,r,r,i,i,i,i,0,1,~{memory},~{$a0:1},~{$a2:3},~{$a4:5},~{$a6:7}"(i32 %58, i32 %55, i32 %53, i32 %59, i32 %14, i32 %56, i32 %60, i32 %57, i32 0, i32 1, i32 0, i32 1, i8* %65, i8* %68)
  %70 = add nuw nsw i32 %63, 1
  %71 = icmp eq i32 %70, %34
  br i1 %71, label %72, label %62

72:                                               ; preds = %62, %7, %2
  ret i1 true
}
