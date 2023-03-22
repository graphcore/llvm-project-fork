; RUN: llc < %s -march=colossus -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -march=colossus -mattr=+ipu2 | FileCheck %s

; CHECK-LABEL: no_stack:
; CHECK-NEXT:  .cfi_startproc
; CHECK-NEXT: # %bb.0:
; CHECK-NEXT:  br $m10
; CHECK:       .cfi_endproc
define void @no_stack() {
  ret void
}

; CHECK-LABEL: sp:
; CHECK-NEXT:  .cfi_startproc
; CHECK-NEXT: # %bb.0:
; CHECK-NEXT:  add $m11, $m11, -8
; CFA defined as `SP + FrameSize`.
; CHECK-NEXT:  .cfi_def_cfa_offset 8
; CHECK-NEXT:  add $m11, $m11, 8
; CFA adjusted as SP is set to its initial value.
; CHECK-NEXT:  .cfi_def_cfa_offset 0
; CHECK-NEXT:  br $m10
; CHECK: .cfi_endproc
define void @sp() {
  %1 = alloca i32, i32 1
  ret void
}

; CHECK-LABEL: bp:
; CHECK-NEXT:  .cfi_startproc
; CHECK-NEXT: # %bb.0:
; CHECK-NEXT:  add $m11, $m11, -8
; CHECK-NEXT:  st32 $m8, $m11, $m15, 0
; CHECK-NEXT:  add $m8, $m11, 8
; Allocate space
; CHECK-NEXT:  add $m11, $m11, -16
; Align stack
; CHECK-NEXT:  andc $m11, $m11, 15
; CFA defined in terms of BP.
;	CHECK-NEXT:  .cfi_def_cfa_register $m8
; BP was saved at `CFA - 8`.
;	CHECK-NEXT:  .cfi_offset $m8, -8
; CHECK-NEXT:  mov $m11, $m8
; CHECK-NEXT:  add $m8, $m8, -8
; CFA set to SP initial value after BP is restored.
; CHECK-NEXT:  .cfi_def_cfa_register $m11
; CHECK-NEXT:  ld32 $m8, $m8, $m15, 0
; CHECK-NEXT:  br $m10
; CHECK:       .cfi_endproc
define void @bp() {
  %1 = alloca i32, i32 1, align 16
  ret void
}

; CHECK-LABEL: fp:
; CHECK-NEXT:  .cfi_startproc
; CHECK-NEXT: # %bb.0:
; CHECK-NEXT:  add $m11, $m11, -8
; CHECK-NEXT:  st32 $m9, $m11, $m15, [[FPSpill:[0-1]+]]
; CHECK-NEXT:  mov $m9, $m11
; CFA defined in terms of FP and takes into account the change in SP.
; CHECK-NEXT:  .cfi_def_cfa $m9, 8
; FIXME: Use @thomasp FileCheck arithmetic with multiplication once available.
;	CHECK-NEXT:  .cfi_offset $m9, -4
; Also provides alignment
; CHECK-NEXT:  shl $m0, $m0, 3
; Allocate space
; CHECK-NEXT:  sub $m11, $m11, $m0
; Restore sp from fp
; CHECK-NEXT:  add $m11, $m9, 8
; CHECK-NEXT:  ld32 $m9, $m9, $m15, [[FPSpill]]
; CFA set to SP initial value after FP is restored.
; CHECK-NEXT:  .cfi_def_cfa_register $m11
; CHECK-NEXT:  br $m10
; CHECK:       .cfi_endproc
define void @fp(i32 %n) {
  %b = mul i32 %n, 8
  %a = alloca i8, i32 %b
  ret void
}

; CHECK-LABEL: bp_and_fp:
; CHECK-NEXT:  .cfi_startproc
; CHECK-NEXT: # %bb.0:
; CHECK-NEXT:  add $m11, $m11, -8
; CHECK-NEXT:  st32 $m8, $m11, $m15, 0
; CHECK-NEXT:  add $m8, $m11, 8
; Space for variable and for fp spill
; CHECK-NEXT:  add $m11, $m11, -32
; Align stack
; CHECK-NEXT:  andc $m11, $m11, 15
; CHECK-NEXT:  st32 $m9, $m11, $m15, [[FPSpill:[0-3]+]]
; CHECK-NEXT:  mov $m9, $m11
; CFA is defined in terms of BP (preferred over FP).
; CHECK-NEXT:  .cfi_def_cfa_register $m8
; BP was saved at `CFA - 8`.
; CHECK-NEXT:  .cfi_offset $m8, -8
; FIXME: Use @thomasp FileCheck arithmetic with multiplication once available.
; CHECK-NEXT:  .cfi_offset $m9, -20
; Alignment for alloca
; CHECK-NEXT:  shl $m0, $m0, 3
; Allocate space for vla
; CHECK-NEXT:  sub $m11, $m11, $m0
; CHECK-NEXT:  mov $m11, $m8
; CHECK-NEXT:  ld32 $m9, $m9, $m15, [[FPSpill]]
; CHECK-NEXT:  add $m8, $m8, -8
; CFA set to SP initial value after BP is restored.
; CHECK-NEXT:  .cfi_def_cfa_register $m11
; CHECK-NEXT:  ld32 $m8, $m8, $m15, 0
; CHECK-NEXT:  br $m10
; CHECK:       .cfi_endproc
define void @bp_and_fp(i32 %n) {
  %b = mul i32 %n, 8
  %c = alloca i8, i32 1, align 16
  %a = alloca i8, i32 %b, align 4
  ret void
}

; CHECK-LABEL: adjcallstack:
; CHECK-NEXT:  .cfi_startproc
; CHECK-NEXT: # %bb.0:
; CHECK-NEXT:  add $m11, $m11, -8
; CHECK-NEXT:  st32 $m9, $m11, $m15, [[FPSpill:[0-1]+]]
; CHECK-NEXT:  mov $m9, $m11
; CFA defined in terms of FP and takes into account the change in SP.
; CHECK-NEXT:  .cfi_def_cfa $m9, 8
; FIXME: Use @thomasp FileCheck arithmetic with multiplication once available.
; CHECK-NEXT:  .cfi_offset $m9, -8
; CHECK-NEXT:  .cfi_offset $m10, -4
; CHECK-NEXT:  st32 $m10, $m9, $m15, [[LRSpill:[0-1]+]]
; CHECK-NEXT:  shl $m0, $m0, 3
; CHECK-NEXT:  sub $m0, $m11, $m0
; CHECK-NEXT:  mov $m11, $m0
; ADJCALLSTACKDOWN 8
; CHECK-NEXT:  add $m11, $m11, -8
; CHECK-DAG:   st32 $m0, $m11, $m15, 0
; CHECK-DAG:   st32 $m0, $m11, $m15, 1
; CHECK-DAG:   mov $m1, $m0
; CHECK-DAG:   mov $m2, $m0
; CHECK-DAG:   mov $m3, $m0
; CHECK-NEXT:  call $m10, use_stack_argument
; ADJCALLSTACKUP 8
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK-NEXT:  ld32 $m10, $m9, $m15, [[LRSpill]]
; CHECK-NEXT:  add $m11, $m9, 8
; CHECK-NEXT:  ld32 $m9, $m9, $m15, [[FPSpill]]
; CFA set to SP initial value after FP is restored.
; CHECK-NEXT:  .cfi_def_cfa_register $m11
; CHECK-NEXT:  br $m10
; CHECK:       .cfi_endproc
declare void @use_stack_argument(i8*,i8*,i8*,i8*,i8*,i8*);
define void @adjcallstack(i32 %n) {
  %b = mul i32 %n, 8
  %a = alloca i8, i32 %b
  call void @use_stack_argument(i8* %a,i8* %a,i8* %a,i8* %a,i8* %a,i8* %a)
  ret void
}
