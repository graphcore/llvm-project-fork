; RUN: llc < %s -march=colossus -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -march=colossus -mattr=+ipu2 | FileCheck %s

; The LLVM-IR below was produced by gc-clang with the following C code:
;
; void rpt_loop(float *in, float *out, unsigned len) {
;   const unsigned cnt = len & 0xFFF;
;   float load = *in++;
;   for (unsigned i = 0; i < cnt; ++i) {
;     const float temp = load * load;
;     load = *in++;
;     *out++ = temp;
;   }
; }
;
; gc-clang -g -O3 rpt.c -S -emit-llvm -o rpt.ll

target triple = "colossus-graphcore-unknown-elf"

; CHECK-LABEL: rpt_loop
; CHECK: {
; CHECK-NEXT: rpt
; CHECK-NEXT: fnop
; CHECK-NEXT: }
; CHECK: #DEBUG_VALUE 
; CHECK: {
; CHECK-NEXT: ld32step
; CHECK-NEXT: f32mul
; CHECK-NEXT: }
; CHECK: #DEBUG_VALUE
; CHECK: {
; CHECK-NEXT: st32step
; CHECK-NEXT: fnop
; CHECK-NEXT: }
define dso_local void @rpt_loop(float* nocapture readonly %in, float* nocapture %out, i32 %len) local_unnamed_addr #0 !dbg !7 {
entry:
  call void @llvm.dbg.value(metadata float* %in, metadata !14, metadata !DIExpression()), !dbg !26
  call void @llvm.dbg.value(metadata float* %out, metadata !15, metadata !DIExpression()), !dbg !26
  call void @llvm.dbg.value(metadata i32 %len, metadata !16, metadata !DIExpression()), !dbg !26
  %and = and i32 %len, 4095, !dbg !27
  call void @llvm.dbg.value(metadata i32 %and, metadata !17, metadata !DIExpression()), !dbg !26
  call void @llvm.dbg.value(metadata float* %in, metadata !14, metadata !DIExpression(DW_OP_plus_uconst, 4, DW_OP_stack_value)), !dbg !26
  call void @llvm.dbg.value(metadata float undef, metadata !19, metadata !DIExpression()), !dbg !26
  call void @llvm.dbg.value(metadata i32 0, metadata !20, metadata !DIExpression()), !dbg !28
  call void @llvm.dbg.value(metadata float* %in, metadata !14, metadata !DIExpression(DW_OP_plus_uconst, 4, DW_OP_stack_value)), !dbg !26
  call void @llvm.dbg.value(metadata float* %out, metadata !15, metadata !DIExpression()), !dbg !26
  %cmp11 = icmp eq i32 %and, 0, !dbg !29
  br i1 %cmp11, label %for.cond.cleanup, label %for.body.preheader, !dbg !30

for.body.preheader:                               ; preds = %entry
  %0 = load float, float* %in, align 4, !dbg !31, !tbaa !32
  call void @llvm.dbg.value(metadata float %0, metadata !19, metadata !DIExpression()), !dbg !26
  br label %for.body, !dbg !30

for.cond.cleanup:                                 ; preds = %for.body, %entry
  ret void, !dbg !36

for.body:                                         ; preds = %for.body, %for.body.preheader
  %in.addr.015.pn = phi float* [ %in.addr.015, %for.body ], [ %in, %for.body.preheader ]
  %i.014 = phi i32 [ %inc, %for.body ], [ 0, %for.body.preheader ]
  %load.013 = phi float [ %1, %for.body ], [ %0, %for.body.preheader ]
  %out.addr.012 = phi float* [ %incdec.ptr2, %for.body ], [ %out, %for.body.preheader ]
  %in.addr.015 = getelementptr inbounds float, float* %in.addr.015.pn, i32 1, !dbg !26
  call void @llvm.dbg.value(metadata i32 %i.014, metadata !20, metadata !DIExpression()), !dbg !28
  call void @llvm.dbg.value(metadata float %load.013, metadata !19, metadata !DIExpression()), !dbg !26
  call void @llvm.dbg.value(metadata float* %out.addr.012, metadata !15, metadata !DIExpression()), !dbg !26
  %mul = fmul float %load.013, %load.013, !dbg !37
  call void @llvm.dbg.value(metadata float %mul, metadata !22, metadata !DIExpression()), !dbg !38
  call void @llvm.dbg.value(metadata float* %in.addr.015, metadata !14, metadata !DIExpression(DW_OP_plus_uconst, 4, DW_OP_stack_value)), !dbg !26
  %1 = load float, float* %in.addr.015, align 4, !dbg !39, !tbaa !32
  %incdec.ptr2 = getelementptr inbounds float, float* %out.addr.012, i32 1, !dbg !40
  store float %mul, float* %out.addr.012, align 4, !dbg !41, !tbaa !32
  %inc = add nuw nsw i32 %i.014, 1, !dbg !42
  call void @llvm.dbg.value(metadata float* %in.addr.015, metadata !14, metadata !DIExpression(DW_OP_plus_uconst, 4, DW_OP_stack_value)), !dbg !26
  call void @llvm.dbg.value(metadata i32 %inc, metadata !20, metadata !DIExpression()), !dbg !28
  call void @llvm.dbg.value(metadata float %1, metadata !19, metadata !DIExpression()), !dbg !26
  call void @llvm.dbg.value(metadata float* %incdec.ptr2, metadata !15, metadata !DIExpression()), !dbg !26
  %exitcond = icmp eq i32 %inc, %and, !dbg !29
  br i1 %exitcond, label %for.cond.cleanup, label %for.body, !dbg !30, !llvm.loop !43
}

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #1

attributes #0 = { nofree norecurse nounwind optsize "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="none" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-features"="-supervisor" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!3, !4, !5}
!llvm.ident = !{!6}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "clang version 10.0.0 (git@phabricator.sourcevertex.net:diffusion/LLVMPROJECT/llvm-project.git 8efe6cbb6343a8c44892120e56baceb50a574375)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, nameTableKind: None)
!1 = !DIFile(filename: "rpt.c", directory: "/")
!2 = !{}
!3 = !{i32 2, !"Dwarf Version", i32 4}
!4 = !{i32 2, !"Debug Info Version", i32 3}
!5 = !{i32 1, !"wchar_size", i32 4}
!6 = !{!"clang version 10.0.0 (git@phabricator.sourcevertex.net:diffusion/LLVMPROJECT/llvm-project.git 8efe6cbb6343a8c44892120e56baceb50a574375)"}
!7 = distinct !DISubprogram(name: "rpt_loop", scope: !1, file: !1, line: 2, type: !8, scopeLine: 2, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !13)
!8 = !DISubroutineType(types: !9)
!9 = !{null, !10, !10, !12}
!10 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !11, size: 32)
!11 = !DIBasicType(name: "float", size: 32, encoding: DW_ATE_float)
!12 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!13 = !{!14, !15, !16, !17, !19, !20, !22}
!14 = !DILocalVariable(name: "in", arg: 1, scope: !7, file: !1, line: 2, type: !10)
!15 = !DILocalVariable(name: "out", arg: 2, scope: !7, file: !1, line: 2, type: !10)
!16 = !DILocalVariable(name: "len", arg: 3, scope: !7, file: !1, line: 2, type: !12)
!17 = !DILocalVariable(name: "cnt", scope: !7, file: !1, line: 3, type: !18)
!18 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !12)
!19 = !DILocalVariable(name: "load", scope: !7, file: !1, line: 4, type: !11)
!20 = !DILocalVariable(name: "i", scope: !21, file: !1, line: 5, type: !12)
!21 = distinct !DILexicalBlock(scope: !7, file: !1, line: 5, column: 3)
!22 = !DILocalVariable(name: "temp", scope: !23, file: !1, line: 6, type: !25)
!23 = distinct !DILexicalBlock(scope: !24, file: !1, line: 5, column: 38)
!24 = distinct !DILexicalBlock(scope: !21, file: !1, line: 5, column: 3)
!25 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !11)
!26 = !DILocation(line: 0, scope: !7)
!27 = !DILocation(line: 3, column: 28, scope: !7)
!28 = !DILocation(line: 0, scope: !21)
!29 = !DILocation(line: 5, column: 26, scope: !24)
!30 = !DILocation(line: 5, column: 3, scope: !21)
!31 = !DILocation(line: 4, column: 16, scope: !7)
!32 = !{!33, !33, i64 0}
!33 = !{!"float", !34, i64 0}
!34 = !{!"omnipotent char", !35, i64 0}
!35 = !{!"Simple C/C++ TBAA"}
!36 = !DILocation(line: 10, column: 1, scope: !7)
!37 = !DILocation(line: 6, column: 29, scope: !23)
!38 = !DILocation(line: 0, scope: !23)
!39 = !DILocation(line: 7, column: 12, scope: !23)
!40 = !DILocation(line: 8, column: 9, scope: !23)
!41 = !DILocation(line: 8, column: 12, scope: !23)
!42 = !DILocation(line: 5, column: 33, scope: !24)
!43 = distinct !{!43, !30, !44}
!44 = !DILocation(line: 9, column: 3, scope: !21)
