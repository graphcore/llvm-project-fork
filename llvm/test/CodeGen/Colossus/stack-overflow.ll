; Check if worker stack checks are injected.
; RUN: llc < %s -march=colossus -colossus-stack-limit=__from_worker -colossus-stack-overflow-handler=on_overflow | FileCheck %s --check-prefixes=CHECK,WORKER,ALL

; Check if supervisor stack checks are injected.
; RUN: llc < %s -march=colossus -mattr=+supervisor -colossus-supervisor-stack-limit=__from_supervisor -colossus-stack-overflow-handler=on_overflow | FileCheck %s --check-prefixes=CHECK,SUPERVISOR,ALL

; Check if both stack checks are injected (regardless of supervisor attribute from -msupervisor) have no side effects in "both" mode.
; RUN: llc < %s -march=colossus -mattr=+both,-supervisor -colossus-stack-limit=__from_worker -colossus-supervisor-stack-limit=__from_supervisor -colossus-stack-overflow-handler=on_overflow | FileCheck %s --check-prefixes=CHECK,BOTH,ALL
; RUN: llc < %s -march=colossus -mattr=+both,+supervisor -colossus-stack-limit=__from_worker -colossus-supervisor-stack-limit=__from_supervisor -colossus-stack-overflow-handler=on_overflow | FileCheck %s --check-prefixes=CHECK,BOTH,ALL

; Check combinations that do not enable stack overflow checks.
; RUN: llc < %s -march=colossus -mattr=+supervisor | FileCheck %s --check-prefixes=CHECK
; RUN: llc < %s -march=colossus -mattr=+supervisor -colossus-stack-overflow-handler=on_overflow | FileCheck %s --check-prefixes=CHECK
; RUN: llc < %s -march=colossus -mattr=+supervisor -colossus-stack-limit=__from_worker -colossus-stack-overflow-handler=on_overflow | FileCheck %s --check-prefixes=CHECK
; RUN: llc < %s -march=colossus -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -march=colossus -mattr=+ipu2 | FileCheck %s
; RUN: llc < %s -march=colossus -colossus-stack-overflow-handler=on_overflow | FileCheck %s --check-prefixes=CHECK
; RUN: llc < %s -march=colossus -colossus-supervisor-stack-limit=__from_supervisor -colossus-stack-overflow-handler=on_overflow | FileCheck %s --check-prefixes=CHECK
; RUN: llc < %s -march=colossus -mattr=+both | FileCheck %s --check-prefixes=CHECK
; RUN: llc < %s -march=colossus -mattr=+both -colossus-stack-limit=__from_worker -colossus-stack-overflow-handler=on_overflow | FileCheck %s --check-prefixes=CHECK
; RUN: llc < %s -march=colossus -mattr=+both -colossus-supervisor-stack-limit=__from_supervisor -colossus-stack-overflow-handler=on_overflow | FileCheck %s --check-prefixes=CHECK

target triple = "colossus-graphcore--elf"

; CHECK-LABEL: no_stack_needs_no_check:
; CHECK-NEXT:  .cfi_startproc
; CHECK-NEXT:  # %bb.0
; CHECK:       br $m10
; CHECK:       .cfi_endproc
define i32 @no_stack_needs_no_check(i32 %x) {
  ret i32 %x
}

; CHECK-LABEL: fixed_alloc_induces_check:
; CHECK-NEXT:  .cfi_startproc
; CHECK-NEXT:  # %bb.0
; Set up stack frame
; CHECK-NEXT:  add $m11, $m11, -32
; Check for overflow
; BOTH-NEXT:   brz $m12, .LBB[[SUPERVISOR_BB:[_0-9]+]]
; BOTH-NEXT:   # %bb
; BOTH-NEXT:   sub $m6, $m12, $m11
; BOTH-NEXT:   cmpult $m6, $m6, __from_worker
;	BOTH-NEXT:   bri .LBB[[CONTINUE_BB:[_0-9]+]]
; BOTH-NEXT:   .LBB[[SUPERVISOR_BB]]
; BOTH-NEXT:   setzi $m6, __supervisor_base
; BOTH-NEXT:   sub $m6, $m6, $m11
; BOTH-NEXT:   cmpult $m6, $m6, __from_supervisor
; BOTH-NEXT:   .LBB[[CONTINUE_BB]]
; WORKER-NEXT: sub $m6, $m12, $m11
; SUPERVISOR-NEXT: setzi $m6, __supervisor_base
; SUPERVISOR-NEXT: sub $m6, $m6, $m11
; WORKER-NEXT: cmpult $m6, $m6, __from_worker
; SUPERVISOR-NEXT: cmpult $m6, $m6, __from_supervisor
; ALL-NEXT:    brz $m6, on_overflow
; CHECK:       .cfi_def_cfa_offset 32
; Tear down stack frame
; CHECK-NEXT:  add $m11, $m11, 32
; CHECK:       br $m10
; CHECK:       .cfi_endproc
define void @fixed_alloc_induces_check() {
  %a = alloca i32, i32 8
  ret void
}

; Because of the bitcast to float this test is only applicable in worker
; context.
;
; CHECK-LABEL: using_stack_induces_check:
; WORKER-NEXT:  .cfi_startproc
; WORKER-NEXT:  # %bb.0
; WORKER-NEXT:  add $m11, $m11, -8
; WORKER-NEXT:  sub $m6, $m12, $m11
; WORKER-NEXT:  cmpult $m6, $m6, __from_worker
; WORKER-NEXT:  brz $m6, on_overflow
; WORKER-NEXT:  .cfi_def_cfa_offset 8
; WORKER-NEXT:  st32 $m0, $m11, $m15, 1
; WORKER-NEXT:  ld32 $a0, $m11, $m15, 1
; WORKER-NEXT:  add $m11, $m11, 8
; WORKER:       br $m10
; WORKER:       .cfi_endproc
define float @using_stack_induces_check(i32 %x) {
  %res = bitcast i32 %x to float ; lowered via stack slot
  ret float %res
}

; CHECK-LABEL: overaligned_stack:
; CHECK-NEXT:  .cfi_startproc
; CHECK-NEXT:  # %bb.0
; Check for overflow
; ALL-NEXT:    add $m11, $m11, -32
; BOTH-NEXT:   brz $m12, .LBB[[SUPERVISOR_BB:[_0-9]+]]
; BOTH-NEXT:   # %bb
;	BOTH-NEXT:   sub $m6, $m12, $m11
;	BOTH-NEXT:   add $m6, $m6, 23
;	BOTH-NEXT:   cmpult $m6, $m6, __from_worker
;	BOTH-NEXT:   bri .LBB[[CONTINUE_BB:[_0-9]+]]
; BOTH-NEXT:   .LBB[[SUPERVISOR_BB]]:
;	BOTH-NEXT:   setzi $m6, __supervisor_base
;	BOTH-NEXT:   sub $m6, $m6, $m11
;	BOTH-NEXT:   add $m6, $m6, 23
;	BOTH-NEXT:   cmpult $m6, $m6, __from_supervisor
; BOTH-NEXT:   .LBB[[CONTINUE_BB]]:
; WORKER-NEXT: sub $m6, $m12, $m11
; SUPERVISOR-NEXT: setzi $m6, __supervisor_base
; SUPERVISOR-NEXT: sub $m6, $m6, $m11
; SUPERVISOR-NEXT: add $m6, $m6, 23
; WORKER-NEXT:     add $m6, $m6, 23
; WORKER-NEXT: cmpult $m6, $m6, __from_worker
; SUPERVISOR-NEXT: cmpult $m6, $m6, __from_supervisor
; ALL-NEXT:    brz $m6, on_overflow
; ALL-NEXT:    add $m11, $m11, 32
; Spill $bp
; CHECK-NEXT:  add $m11, $m11, -8
; CHECK-NEXT:  st32 $m8, $m11, $m15, 0
; CHECK-NEXT:  add $m8, $m11, 8
; Set up stack frame
; CHECK-NEXT:  add $m11, $m11, -32
; CHECK-NEXT:  andc $m11, $m11, 15
; CHECK:       .cfi_def_cfa_register $m8
; CHECK:       .cfi_offset $m8, -8
; Test down stack frame
; CHECK-NEXT:  mov $m11, $m8
; Restore $bp
; CHECK:       add $m8, $m8, -8
; CHECK:       ld32 $m8, $m8, $m15, 0
; CHECK:       br $m10
; CHECK:       .cfi_endproc
define void @overaligned_stack() {
  %a = alloca i32, i32 8, align 16
  ret void
}

; Checking for overflow base on runtime stack size requires a register scavenger
; which is not yet implemented. This test will trigger the overflow check for
; the spill of $fp but not for the subsequent stack adjustment.
; Check that the frame setup in the overflow check is not merged with the
; subsequent frame setup code. This is conservative but correct.
; CHECK-LABEL: runtime_frame_size_prevents_teardown_elision:
; CHECK-NEXT:  .cfi_startproc
; CHECK-NEXT:  # %bb.0
; Check for overflow from the $m9 spill slot
; CHECK-NEXT:  add $m11, $m11, -8
;	BOTH-NEXT:   brz $m12, .LBB[[SUPERVISOR_BB:[_0-9]+]]
; BOTH-NEXT:   # %bb
;	BOTH-NEXT:   sub $m6, $m12, $m11
;	BOTH-NEXT:   cmpult $m6, $m6, __from_worker
;	BOTH-NEXT:   bri .LBB[[CONTINUE_BB:[_0-9]+]]
; BOTH-NEXT:   .LBB[[SUPERVISOR_BB]]:
;	BOTH-NEXT:   setzi $m6, __supervisor_base
;	BOTH-NEXT:   sub $m6, $m6, $m11
;	BOTH-NEXT:   cmpult $m6, $m6, __from_supervisor
; BOTH-NEXT:   .LBB[[CONTINUE_BB]]:
;	brz $m6, on_overflow
; WORKER-NEXT: sub $m6, $m12, $m11
; SUPERVISOR-NEXT: setzi $m6, __supervisor_base
; SUPERVISOR-NEXT: sub $m6, $m6, $m11
; WORKER-NEXT: cmpult $m6, $m6, __from_worker
; SUPERVISOR-NEXT: cmpult $m6, $m6, __from_supervisor
; ALL-NEXT:    brz $m6, on_overflow
; ALL-NEXT:    add $m11, $m11, 8
; Continue as if there was no overflow check
; ALL-NEXT:    add $m11, $m11, -8
; CHECK-NEXT:  st32 $m9, $m11, $m15, 1
; CHECK-NEXT:  mov	$m9, $m11
; CHECK-NEXT:  .cfi_def_cfa $m9, 8
; CHECK-NEXT:  .cfi_offset $m9, -4
; CHECK-NEXT:  shl $m0, $m0, 2
; CHECK-NEXT:  add $m0, $m0, 7
; CHECK-NEXT:  andc $m0, $m0, 7
; CHECK-NEXT:  sub $m11, $m11, $m0
; CHECK-NEXT:  add $m11, $m9, 8
; CHECK:       ld32 $m9, $m9, $m15, 1
; CHECK:       br $m10
; CHECK:       .cfi_endproc
define void @runtime_frame_size_prevents_teardown_elision(i32 %len) {
  %a = alloca i32, i32 %len, align 4
  ret void
}
