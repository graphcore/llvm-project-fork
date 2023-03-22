; RUN: llc -march=colossus -mattr=+ipu1 < %s | FileCheck %s
; RUN: llc -march=colossus -mattr=+ipu2 < %s | FileCheck %s

declare void @c1(i32*)
declare void @c2(i32*)
declare void @c3(i32*)
declare void @c4(i32*)
declare void @c5(i32*)

; Check basic emission of a jump table.

; CHECK-LABEL: foo
; Load address of jump table.
; CHECK:       setzi {{\$m[0-9]+}}, [[JTL:.LJTI[0-9_]+]]
; Indirect branch.
; CHECK:       br {{\$m[0-9]+}}
; End of function.
; CHECK:       br $m10
; The jump table.
; CHECK:       [[JTL]]:
; CHECK:       .long {{.L[0-9A-Z_]+}}
; CHECK:       .long {{.L[0-9A-Z_]+}}
; CHECK:       .long {{.L[0-9A-Z_]+}}
; CHECK:       .long {{.L[0-9A-Z_]+}}
; CHECK:       .long {{.L[0-9A-Z_]+}}
define i32 @foo(i32 %x) nounwind {
  %i = alloca i32, align 4
  switch i32 %x, label %sw.epilog [
    i32 0, label %sw.bb1
    i32 1, label %sw.bb2
    i32 2, label %sw.bb3
    i32 3, label %sw.bb4
    i32 4, label %sw.bb5
  ]
sw.bb1:
  call void @c1(i32* %i)
  br label %sw.epilog
sw.bb2:
  call void @c2(i32* %i)
  br label %sw.epilog
sw.bb3:
  call void @c3(i32* %i)
  br label %sw.epilog
sw.bb4:
  call void @c4(i32* %i)
  br label %sw.epilog
sw.bb5:
  call void @c5(i32* %i)
  br label %sw.epilog
sw.epilog:
  %1 = load i32, i32* %i, align 4
  ret i32 %1
}
