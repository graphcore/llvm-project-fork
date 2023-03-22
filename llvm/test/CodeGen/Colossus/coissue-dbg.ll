; RUN: llc < %s -march=colossus -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -march=colossus -mattr=+ipu2 | FileCheck %s

; Verify that a pair of instructions are bundled under the presence of
; meta-instructions between the pair.

; The LLVM-IR below was produced by gc-clang with the following C code:
;
; float output_input_operand_clash(float y, float *x) {
;   float a = *x;
;   float b = a * y;
;   return b;
; }
;
; gc-clang -g -O3 coissue.c -S -emit-llvm -o coissue.ll

target triple = "colossus-graphcore-unknown-elf"

; CHECK-LABEL: output_input_operand_clash
; CHECK: {
; CHECK-NEXT: br
;	CHECK-NEXT: f32mul
; CHECK-NEXT: }
; CHECK: #DEBUG_VALUE
define dso_local float @output_input_operand_clash(float %y, float* nocapture readonly %x) local_unnamed_addr #0 !dbg !7 {
entry:
  call void @llvm.dbg.value(metadata float %y, metadata !13, metadata !DIExpression()), !dbg !17
  call void @llvm.dbg.value(metadata float* %x, metadata !14, metadata !DIExpression()), !dbg !17
  %0 = load float, float* %x, align 4, !dbg !18, !tbaa !19
  call void @llvm.dbg.value(metadata float %0, metadata !15, metadata !DIExpression()), !dbg !17
  %mul = fmul float %0, %y, !dbg !23
  call void @llvm.dbg.value(metadata float %mul, metadata !16, metadata !DIExpression()), !dbg !17
  ret float %mul, !dbg !24
}

declare void @llvm.dbg.value(metadata, metadata, metadata) #1

attributes #0 = { norecurse nounwind readonly "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="none" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-features"="-supervisor" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!3, !4, !5}
!llvm.ident = !{!6}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "clang version 10.0.0 (git@phabricator.sourcevertex.net:diffusion/LLVMPROJECT/llvm-project.git 8efe6cbb6343a8c44892120e56baceb50a574375)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, nameTableKind: None)
!1 = !DIFile(filename: "coissue.c", directory: "/")
!2 = !{}
!3 = !{i32 2, !"Dwarf Version", i32 4}
!4 = !{i32 2, !"Debug Info Version", i32 3}
!5 = !{i32 1, !"wchar_size", i32 4}
!6 = !{!"clang version 10.0.0 (git@phabricator.sourcevertex.net:diffusion/LLVMPROJECT/llvm-project.git 8efe6cbb6343a8c44892120e56baceb50a574375)"}
!7 = distinct !DISubprogram(name: "output_input_operand_clash", scope: !1, file: !1, line: 2, type: !8, scopeLine: 2, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !12)
!8 = !DISubroutineType(types: !9)
!9 = !{!10, !10, !11}
!10 = !DIBasicType(name: "float", size: 32, encoding: DW_ATE_float)
!11 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !10, size: 32)
!12 = !{!13, !14, !15, !16}
!13 = !DILocalVariable(name: "y", arg: 1, scope: !7, file: !1, line: 2, type: !10)
!14 = !DILocalVariable(name: "x", arg: 2, scope: !7, file: !1, line: 2, type: !11)
!15 = !DILocalVariable(name: "a", scope: !7, file: !1, line: 3, type: !10)
!16 = !DILocalVariable(name: "b", scope: !7, file: !1, line: 4, type: !10)
!17 = !DILocation(line: 0, scope: !7)
!18 = !DILocation(line: 3, column: 13, scope: !7)
!19 = !{!20, !20, i64 0}
!20 = !{!"float", !21, i64 0}
!21 = !{!"omnipotent char", !22, i64 0}
!22 = !{!"Simple C/C++ TBAA"}
!23 = !DILocation(line: 4, column: 15, scope: !7)
!24 = !DILocation(line: 5, column: 3, scope: !7)
