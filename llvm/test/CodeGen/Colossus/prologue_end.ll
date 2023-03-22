; RUN: llc < %s -march=colossus -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -march=colossus -mattr=+ipu2 | FileCheck %s

; ModuleID = 'backtrace.c'
source_filename = "backtrace.c"
target datalayout = "e-m:e-p:32:32-i1:8:32-i8:8:32-i16:16:32-i64:32-i128:64-f64:32-f128:64-v128:64-a:0:32-n32"
target triple = "colossus-graphcore-unknown-elf"

; CHECK: .cfi_startproc
;	CHECK: add $m11, $m11, -8
;	CHECK: .cfi_def_cfa_offset 8
;	CHECK: .cfi_offset $m10, -4
;	CHECK: st32 $m10, $m11, $m15, 1
;	CHECK: prologue_end
; Function Attrs: noinline nounwind optnone
define dso_local void @backtrace() #0 !dbg !7 {
entry:
  call void bitcast (void (...)* @dummy to void ()*)(), !dbg !10
  ret void, !dbg !11
}

declare dso_local void @dummy(...) #1

attributes #0 = { noinline nounwind optnone "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="none" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-features"="+worker" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="none" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-features"="+worker" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!3, !4, !5}
!llvm.ident = !{!6}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "clang version 11.0.0 (git@phabricator.sourcevertex.net:diffusion/LLVMPROJECT/llvm-project.git 606deac4428437f339549c23b131f386c06f5555)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "backtrace.c", directory: "/scratch/leandrov/repos/colossus_tools_view/_lldb")
!2 = !{}
!3 = !{i32 7, !"Dwarf Version", i32 4}
!4 = !{i32 2, !"Debug Info Version", i32 3}
!5 = !{i32 1, !"wchar_size", i32 4}
!6 = !{!"clang version 11.0.0 (git@phabricator.sourcevertex.net:diffusion/LLVMPROJECT/llvm-project.git 606deac4428437f339549c23b131f386c06f5555)"}
!7 = distinct !DISubprogram(name: "backtrace", scope: !1, file: !1, line: 3, type: !8, scopeLine: 3, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!8 = !DISubroutineType(types: !9)
!9 = !{null}
!10 = !DILocation(line: 4, column: 3, scope: !7)
!11 = !DILocation(line: 5, column: 1, scope: !7)
