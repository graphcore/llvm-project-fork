; RUN: llc < %s -march=colossus -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -march=colossus -mattr=+ipu2 | FileCheck %s
; CHECK-LABEL: t3357:
; CHECK:       # %bb
; CHECK-NOT:   get
; CHECK-NEXT:  ld32 $m0, $m13, $m15, 0
; CHECK-NEXT:  exitnz $m0
define colossus_vertex i32 @t3357() {
entry:
  %0 = tail call i8* @llvm.colossus.get.vertex.base()
  %rc = bitcast i8* %0 to i32*
  %1 = load i32, i32* %rc
  ret i32 %1
}
declare i8* @llvm.colossus.get.vertex.base()
