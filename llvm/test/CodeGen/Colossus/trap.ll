; RUN: llc < %s -march=colossus -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -march=colossus -mattr=+ipu2 | FileCheck %s
; RUN: llc < %s -march=colossus -mattr=\+supervisor,+ipu1 | FileCheck %s

; RUN: llc < %s -march=colossus -mattr=\+supervisor,+ipu2 | FileCheck %s

declare void @llvm.trap() nounwind

; CHECK-LABEL: do_trap
; CHECK:       trap 0
; CHECK-NEXT:  .Lfunc_end0:
define void @do_trap() {
    call void @llvm.trap() 
    unreachable
}

declare void @llvm.debugtrap() nounwind

; CHECK-LABEL: do_debug_trap
; CHECK:       trap 0
; CHECK-NEXT:  .Lfunc_end1:
define void @do_debug_trap() {
    call void @llvm.debugtrap()
    unreachable
}

