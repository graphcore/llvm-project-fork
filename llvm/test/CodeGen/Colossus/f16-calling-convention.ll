; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py UTC_ARGS: --remove_checks
; RUN: llc < %s -mtriple=colossus -mattr=+ipu1 | FileCheck %s -check-prefixes=CHECK,IPU1_2
; RUN: llc < %s -mtriple=colossus -mattr=+ipu2 | FileCheck %s -check-prefixes=CHECK,IPU1_2

define void @callee_reg_args(half %a) {
; CHECK-LABEL: callee_reg_args:
; CHECK:       # %bb.0:
; CHECK-NEXT:    f16tof32 $a0, $a0
; CHECK-NEXT:    #APP
; CHECK-NEXT:    urand32 $a0
; CHECK-NEXT:    #NO_APP
; CHECK-NEXT:    br $m10
  call void asm sideeffect "urand32 $0", "r"(half %a)
  ret void
}

define void @callee_stack_arg(float %a0, float %a1, float %a2, float %a3, float %a4, float %a5, half %b) {
; IPU1_2-LABEL: callee_stack_arg:
; IPU1_2:       # %bb.0:
; IPU1_2-NEXT:    add $m11, $m11, -8
; IPU1_2-NEXT:    .cfi_def_cfa_offset 8
; IPU1_2-NEXT:    .cfi_offset $a6, -4
; IPU1_2-NEXT:    st32 $a6, $m11, $m15, 1 # 4-byte Folded Spill
; IPU1_2-NEXT:    ldb16 $a6, $m11, $m15, 4
; IPU1_2-NEXT:    f16tof32 $a6, $a6
; IPU1_2-NEXT:    #APP
; IPU1_2-NEXT:    andc $a0, $a1, $a2
; IPU1_2-NEXT:    andc $a3, $a4, $a5
; IPU1_2-NEXT:    urand32 $a6
; IPU1_2-NEXT:    #NO_APP
; IPU1_2-NEXT:    ld32 $a6, $m11, $m15, 1 # 4-byte Folded Reload
; IPU1_2-NEXT:    add $m11, $m11, 8
; IPU1_2-NEXT:    .cfi_def_cfa_offset 0
; IPU1_2-NEXT:    br $m10
;
  call void asm sideeffect "andc $0, $1, $2\0a\09andc $3, $4, $5\0a\09urand32 $6",
   "r,r,r,r,r,r,r"(float %a0, float %a1, float %a2, float %a3, float %a4, float %a5, half %b)
  ret void
}

define half @callee_return(half %a) {
; CHECK-LABEL: callee_return:
; CHECK:       # %bb.0:
; CHECK-NEXT:    f16tof32 $a1, $a0
; CHECK-NEXT:    #APP
; CHECK-NEXT:    urand32 $a1
; CHECK-NEXT:    #NO_APP
; CHECK-NEXT:    br $m10
  call void asm sideeffect "urand32 $0", "r"(half %a)
  ret half %a
}

define void @caller_reg_args(half %a) {
; CHECK-LABEL: caller_reg_args:
; CHECK:       # %bb.0:
; CHECK-NEXT:    add $m11, $m11, -8
; CHECK-NEXT:    .cfi_def_cfa_offset 8
; CHECK-NEXT:    .cfi_offset $m10, -4
; CHECK-NEXT:    st32 $m10, $m11, $m15, 1 # 4-byte Folded Spill
; CHECK-NEXT:    call $m10, callee_reg_args
; CHECK-NEXT:    ld32 $m10, $m11, $m15, 1 # 4-byte Folded Reload
; CHECK-NEXT:    add $m11, $m11, 8
; CHECK-NEXT:    .cfi_def_cfa_offset 0
; CHECK-NEXT:    br $m10
  call void @callee_reg_args(half %a)
  ret void
}

; Load the stack argument into a register
; Store it to the new location on the stack
; Invoke the next function
define void @caller_stack_arg(float %a0, float %a1, float %a2, float %a3, float %a4, float %a5, half %b) {
; IPU1_2-LABEL: caller_stack_arg:
; IPU1_2:       # %bb.0:
; IPU1_2-NEXT:    add $m11, $m11, -16
; IPU1_2-NEXT:    .cfi_def_cfa_offset 16
; IPU1_2-NEXT:    .cfi_offset $m10, -4
; IPU1_2-NEXT:    .cfi_offset $a6, -8
; IPU1_2-NEXT:    st32 $m10, $m11, $m15, 3 # 4-byte Folded Spill
; IPU1_2-NEXT:    st32 $a6, $m11, $m15, 2 # 4-byte Folded Spill
; IPU1_2-NEXT:    ldb16 $a6, $m11, $m15, 8
; IPU1_2-NEXT:    st32 $a6, $m11, $m15, 0
; IPU1_2-NEXT:    call $m10, callee_stack_arg
; IPU1_2-NEXT:    ld32 $a6, $m11, $m15, 2 # 4-byte Folded Reload
; IPU1_2-NEXT:    ld32 $m10, $m11, $m15, 3 # 4-byte Folded Reload
; IPU1_2-NEXT:    add $m11, $m11, 16
; IPU1_2-NEXT:    .cfi_def_cfa_offset 0
; IPU1_2-NEXT:    br $m10

  call void @callee_stack_arg(float %a0, float %a1, float %a2, float %a3, float %a4, float %a5, half %b)
  ret void
}
