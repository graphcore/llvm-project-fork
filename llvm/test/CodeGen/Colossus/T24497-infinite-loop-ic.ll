; RUN: llc -O2 < %s -march=colossus -mattr=+ipu1
; RUN: llc -O2 < %s -march=colossus -mattr=+ipu2
;
; In very rare circumstances, it's possible that the DAG is shaped in a way
; that causes register file preferences to be indefinitely toggled during
; selection of bitwise ops with -O2 flag. This file can reproduce the issue
; if no fix is in place.

target datalayout = "e-m:e-p:32:32-i1:8:32-i8:8:32-i16:16:32-i64:32-i128:64-f64:32-f128:64-v128:64-a:0:32-n32"
target triple = "colossus-graphcore-unknown-elf"

%class.MaxVertex = type { %"class.poplar::Input", %"class.poplar::Input", %"class.poplar::Input", %"class.poplar::Output" }
%"class.poplar::Input" = type { %"struct.poplar::Vector" }
%"struct.poplar::Vector" = type { %"struct.poplar::detail::VectorBase" }
%"struct.poplar::detail::VectorBase" = type { %"class.poplar::SpanVectorBase" }
%"class.poplar::SpanVectorBase" = type { %"struct.poplar::BaseWithAlign" }
%"struct.poplar::BaseWithAlign" = type { %"struct.poplar::VectorBase" }
%"struct.poplar::VectorBase" = type { i8*, i32 }
%"class.poplar::Output" = type { %"struct.poplar::Vector" }

$_ZN9MaxVertexIfE7computeEv = comdat any

; Function Attrs: nounwind
define weak_odr dso_local zeroext i1 @_ZN9MaxVertexIfE7computeEv(%class.MaxVertex* %this) local_unnamed_addr #0 comdat align 2 {
entry:
  %beginPtr.i.i.i43 = getelementptr inbounds %class.MaxVertex, %class.MaxVertex* %this, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0
  %0 = load i8*, i8** %beginPtr.i.i.i43, align 4, !tbaa !2
  %ptrint.i.i.i44 = ptrtoint i8* %0 to i32
  %maskedptr.i.i.i45 = and i32 %ptrint.i.i.i44, 3
  %maskcond.i.i.i46 = icmp eq i32 %maskedptr.i.i.i45, 0
  tail call void @llvm.assume(i1 %maskcond.i.i.i46) #2
  %1 = bitcast i8* %0 to float*
  %size_.i.i = getelementptr inbounds %class.MaxVertex, %class.MaxVertex* %this, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 1
  %2 = load i32, i32* %size_.i.i, align 4, !tbaa !8
  %add.ptr.i = getelementptr inbounds float, float* %1, i32 %2
  %cmp.not47 = icmp eq float* %add.ptr.i, %1
  br i1 %cmp.not47, label %for.cond.cleanup, label %for.body.lr.ph

for.body.lr.ph:                                   ; preds = %entry
  %beginPtr.i.i.i34 = getelementptr inbounds %class.MaxVertex, %class.MaxVertex* %this, i32 0, i32 1, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0
  %3 = load i8*, i8** %beginPtr.i.i.i34, align 4, !tbaa !2
  %ptrint.i.i.i35 = ptrtoint i8* %3 to i32
  %maskedptr.i.i.i36 = and i32 %ptrint.i.i.i35, 3
  %maskcond.i.i.i37 = icmp eq i32 %maskedptr.i.i.i36, 0
  tail call void @llvm.assume(i1 %maskcond.i.i.i37) #2
  %4 = bitcast i8* %3 to float*
  %beginPtr.i.i.i29 = getelementptr inbounds %class.MaxVertex, %class.MaxVertex* %this, i32 0, i32 2, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0
  %5 = load i8*, i8** %beginPtr.i.i.i29, align 4, !tbaa !2
  %ptrint.i.i.i30 = ptrtoint i8* %5 to i32
  %maskedptr.i.i.i31 = and i32 %ptrint.i.i.i30, 3
  %maskcond.i.i.i32 = icmp eq i32 %maskedptr.i.i.i31, 0
  tail call void @llvm.assume(i1 %maskcond.i.i.i32) #2
  %6 = bitcast i8* %5 to float*
  %beginPtr.i.i.i = getelementptr inbounds %class.MaxVertex, %class.MaxVertex* %this, i32 0, i32 3, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0
  %7 = load i8*, i8** %beginPtr.i.i.i, align 4, !tbaa !2
  %ptrint.i.i.i = ptrtoint i8* %7 to i32
  %maskedptr.i.i.i = and i32 %ptrint.i.i.i, 3
  %maskcond.i.i.i = icmp eq i32 %maskedptr.i.i.i, 0
  tail call void @llvm.assume(i1 %maskcond.i.i.i) #2
  %8 = bitcast i8* %7 to float*
  %9 = shl nsw i32 %2, 2
  %10 = add i32 %9, -4
  %11 = lshr exact i32 %10, 2
  %12 = add nuw nsw i32 %11, 1
  %min.iters.check = icmp eq i32 %10, 0
  br i1 %min.iters.check, label %for.body.preheader, label %vector.memcheck

for.body.preheader:                               ; preds = %middle.block, %vector.memcheck, %for.body.lr.ph
  %i.049.ph = phi i32 [ 0, %vector.memcheck ], [ 0, %for.body.lr.ph ], [ %n.vec, %middle.block ]
  %__begin0.048.ph = phi float* [ %1, %vector.memcheck ], [ %1, %for.body.lr.ph ], [ %ind.end, %middle.block ]
  br label %for.body

vector.memcheck:                                  ; preds = %for.body.lr.ph
  %13 = shl nsw i32 %2, 2
  %scevgep = getelementptr i8, i8* %7, i32 %13
  %scevgep50 = getelementptr i8, i8* %3, i32 %13
  %scevgep51 = getelementptr i8, i8* %5, i32 %13
  %scevgep52 = getelementptr i8, i8* %0, i32 %13
  %bound0 = icmp ult i8* %7, %scevgep50
  %bound1 = icmp ult i8* %3, %scevgep
  %found.conflict = and i1 %bound0, %bound1
  %bound053 = icmp ult i8* %7, %scevgep51
  %bound154 = icmp ult i8* %5, %scevgep
  %found.conflict55 = and i1 %bound053, %bound154
  %conflict.rdx = or i1 %found.conflict, %found.conflict55
  %bound056 = icmp ult i8* %7, %scevgep52
  %bound157 = icmp ult i8* %0, %scevgep
  %found.conflict58 = and i1 %bound056, %bound157
  %conflict.rdx59 = or i1 %conflict.rdx, %found.conflict58
  br i1 %conflict.rdx59, label %for.body.preheader, label %vector.ph

vector.ph:                                        ; preds = %vector.memcheck
  %n.vec = and i32 %12, 2147483646
  %ind.end = getelementptr float, float* %1, i32 %n.vec
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i32 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %next.gep = getelementptr float, float* %1, i32 %index
  %14 = getelementptr inbounds float, float* %4, i32 %index
  %15 = getelementptr inbounds float, float* %6, i32 %index
  %16 = bitcast float* %14 to <2 x float>*
  %wide.load = load <2 x float>, <2 x float>* %16, align 4, !alias.scope !9
  %17 = bitcast float* %15 to <2 x float>*
  %wide.load61 = load <2 x float>, <2 x float>* %17, align 4, !alias.scope !12
  %18 = fcmp olt <2 x float> %wide.load, %wide.load61
  %19 = bitcast float* %next.gep to <2 x float>*
  %wide.load62 = load <2 x float>, <2 x float>* %19, align 4, !alias.scope !14
  %20 = select <2 x i1> %18, <2 x float> %wide.load61, <2 x float> %wide.load
  %21 = fcmp olt <2 x float> %wide.load62, %20
  %22 = select <2 x i1> %21, <2 x float> %20, <2 x float> %wide.load62
  %23 = fcmp oeq <2 x float> %22, <float 0xFFF0000000000000, float 0xFFF0000000000000>
  %24 = getelementptr inbounds float, float* %8, i32 %index
  %25 = select <2 x i1> %23, <2 x float> zeroinitializer, <2 x float> %22
  %26 = bitcast float* %24 to <2 x float>*
  store <2 x float> %25, <2 x float>* %26, align 4, !tbaa !16, !alias.scope !18, !noalias !20
  %index.next = add i32 %index, 2
  %27 = icmp eq i32 %index.next, %n.vec
  br i1 %27, label %middle.block, label %vector.body, !llvm.loop !21

middle.block:                                     ; preds = %vector.body
  %cmp.n = icmp eq i32 %12, %n.vec
  br i1 %cmp.n, label %for.cond.cleanup, label %for.body.preheader

for.cond.cleanup:                                 ; preds = %for.body, %middle.block, %entry
  ret i1 true

for.body:                                         ; preds = %for.body.preheader, %for.body
  %i.049 = phi i32 [ %inc, %for.body ], [ %i.049.ph, %for.body.preheader ]
  %__begin0.048 = phi float* [ %incdec.ptr, %for.body ], [ %__begin0.048.ph, %for.body.preheader ]
  %arrayidx.i38 = getelementptr inbounds float, float* %4, i32 %i.049
  %arrayidx.i33 = getelementptr inbounds float, float* %6, i32 %i.049
  %28 = load float, float* %arrayidx.i38, align 4
  %29 = load float, float* %arrayidx.i33, align 4
  %cmp.i.i.i27 = fcmp olt float %28, %29
  %30 = load float, float* %__begin0.048, align 4
  %31 = select i1 %cmp.i.i.i27, float %29, float %28
  %cmp.i.i.i = fcmp olt float %30, %31
  %32 = select i1 %cmp.i.i.i, float %31, float %30
  %cmp8 = fcmp oeq float %32, 0xFFF0000000000000
  %arrayidx.i = getelementptr inbounds float, float* %8, i32 %i.049
  %. = select i1 %cmp8, float 0.000000e+00, float %32
  store float %., float* %arrayidx.i, align 4, !tbaa !16
  %inc = add nuw nsw i32 %i.049, 1
  %incdec.ptr = getelementptr inbounds float, float* %__begin0.048, i32 1
  %cmp.not = icmp eq float* %incdec.ptr, %add.ptr.i
  br i1 %cmp.not, label %for.cond.cleanup, label %for.body, !llvm.loop !23
}

; Function Attrs: nounwind willreturn
declare void @llvm.assume(i1) #1

attributes #0 = { nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="none" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-features"="+worker" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind willreturn }
attributes #2 = { nounwind }

!llvm.module.flags = !{!0}
!llvm.ident = !{!1}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{!"clang version 11.0.0 (git@phabricator.sourcevertex.net:diffusion/LLVMPROJECT/llvm-project.git 67ac06cce985a2f4c7471e2c8ad90ae4623439ea)"}
!2 = !{!3, !4, i64 0}
!3 = !{!"_ZTSN6poplar10VectorBaseE", !4, i64 0, !7, i64 4}
!4 = !{!"any pointer", !5, i64 0}
!5 = !{!"omnipotent char", !6, i64 0}
!6 = !{!"Simple C++ TBAA"}
!7 = !{!"int", !5, i64 0}
!8 = !{!3, !7, i64 4}
!9 = !{!10}
!10 = distinct !{!10, !11}
!11 = distinct !{!11, !"LVerDomain"}
!12 = !{!13}
!13 = distinct !{!13, !11}
!14 = !{!15}
!15 = distinct !{!15, !11}
!16 = !{!17, !17, i64 0}
!17 = !{!"float", !5, i64 0}
!18 = !{!19}
!19 = distinct !{!19, !11}
!20 = !{!10, !13, !15}
!21 = distinct !{!21, !22}
!22 = !{!"llvm.loop.isvectorized", i32 1}
!23 = distinct !{!23, !22}
!24 = !{!4, !4, i64 0}
!25 = !{!26}
!26 = distinct !{!26, !27}
!27 = distinct !{!27, !"LVerDomain"}
!28 = !{!29}
!29 = distinct !{!29, !27}
!30 = !{!31}
!31 = distinct !{!31, !27}
!32 = !{!33}
!33 = distinct !{!33, !27}
!34 = !{!26, !29, !31}
!35 = distinct !{!35, !22}
!36 = distinct !{!36, !22}
