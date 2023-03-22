; RUN: llc < %s -march=colossus -mattr=+ipu1 -colossus-stack-limit=__from_poplar -colossus-stack-overflow-handler=on_overflow | FileCheck %s
; RUN: llc < %s -march=colossus -mattr=+ipu2 -colossus-stack-limit=__from_poplar -colossus-stack-overflow-handler=on_overflow | FileCheck %s
target triple = "colossus-graphcore--elf"

; CHECK-LABEL: simple_vertex_stack_check:
; CHECK-NEXT:  .cfi_startproc
; CHECK-NEXT:  # %bb.0
; Check for overflow
; CHECK-NEXT:  setzi $m6, 32
; CHECK-NEXT:  cmpult $m6, $m6, __from_poplar
; CHECK-NEXT:  brz $m6, on_overflow
; Continue as if there was no overflow check
; CHECK-NEXT:  add $m11, $m12, -32
; CHECK-NEXT:  exitnz $m15
; CHECK:       .cfi_endproc
define colossus_vertex i32 @simple_vertex_stack_check() {
  %1 = alloca i32, i32 8
  ret i32 0
}

; CHECK-LABEL: simple_vertex_stack_check_exceeds_setzi:
; CHECK-NEXT:  .cfi_startproc
; CHECK-NEXT:  # %bb.0
; Check for overflow
; CHECK-NEXT:  or $m6, $m15, 1048576
; CHECK-NEXT:  cmpult $m6, $m6, __from_poplar
; CHECK-NEXT:  brz $m6, on_overflow
; Continue as if there was no overflow check
; CHECK-NEXT:  or $m6, $m15, 1048576
; CHECK-NEXT:  sub $m11, $m12, $m6
; CHECK-NEXT:  exitnz $m15
; CHECK:       .cfi_endproc
define colossus_vertex i32 @simple_vertex_stack_check_exceeds_setzi() {
  %1 = alloca i32, i32 262144
  ret i32 0
}

; CHECK-LABEL: overaligned_stack_vertex:
; CHECK-NEXT:  .cfi_startproc
; CHECK-NEXT:  # %bb.0
; Check for overflow
; CHECK-NEXT:  setzi $m6, 47
; CHECK-NEXT:  cmpult $m6, $m6, __from_poplar
; CHECK-NEXT:  brz $m6, on_overflow
; Continue
; CHECK-NEXT:  add $m11, $m12, -32
; CHECK-NEXT:  andc $m11, $m11, 15
; CHECK-NEXT:  exitnz $m15
; CHECK:       .cfi_endproc
define colossus_vertex i32 @overaligned_stack_vertex () {
  %a = alloca i32, i32 8, align 16
  ret i32 0
}
