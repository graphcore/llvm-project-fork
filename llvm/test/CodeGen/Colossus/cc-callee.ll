; RUN: llc < %s -march=colossus -colossus-coissue=false -mattr=+ipu1 | FileCheck %s -check-prefix=SP
; RUN: llc < %s -march=colossus -colossus-coissue=false -mattr=+ipu2 | FileCheck %s -check-prefix=SP
; RUN: llc < %s -march=colossus -colossus-coissue=false -mattr=+ipu1 -frame-pointer=all | FileCheck %s -check-prefix=FP
; RUN: llc < %s -march=colossus -colossus-coissue=false -mattr=+ipu2 -frame-pointer=all | FileCheck %s -check-prefix=FP

; Test a basic function.
; SP-LABEL: basic
; FP-LABEL: basic
define void @basic() {
; SP: br $m10

; FP: add $m11, $m11, -8
; FP: st32 $m9, $m11, $m15, 1
; FP: mov $m9, $m11
; FP: add $m11, $m9, 8
; FP: ld32 $m9, $m9, $m15, 1
; FP: br $m10
  ret void
}

; Test callee args are passed in registers $m1 - $m3.
; SP-LABEL: callee_reg_args
define void @callee_reg_args(i32 %f1, i32 %f2, i32 %f3, i32 %f4) {
; CHECK: ldz8 $m0, $m1, $m2, $m3
  call void asm sideeffect "ldz8 $0, $1, $2, $3",
    "r,r,r,r"(i32 %f1, i32 %f2, i32 %f3, i32 %f4)
  ret void
}

; Test callee args passed on the stack.
; SP-LABEL: callee_stack_args
; FP-LABEL: callee_stack_args
define void @callee_stack_args(i32 %f1, i32 %f2, i32 %f3, i32 %f4,
                               i32 %f5, i32 %f6, i32 %f7) {
; SP-DAG: ld32 $m{{[0-9]+}}, $m11, $m15, 0
; SP-DAG: ld32 $m{{[0-9]+}}, $m11, $m15, 1
; SP-DAG: ld32 $m{{[0-9]+}}, $m11, $m15, 2

; FP-DAG: ld32 $m{{[0-9]+}}, $m9, $m15, 2
; FP-DAG: ld32 $m{{[0-9]+}}, $m9, $m15, 3
; FP-DAG: ld32 $m{{[0-9]+}}, $m9, $m15, 4
  call void asm sideeffect "", "r,r,r"(i32 %f5, i32 %f6, i32 %f7)
  ret void
}

; Test spilling of callee-save register $m9.
; SP-LABEL: callee_spills
define void @callee_spills(i32 %f1, i32 %f2, i32 %f3, i32 %f4) {

; SP-DAG: st32 $m9, $m11, $m15, [[IMM2:[0-9]+]]
; ...
; SP-DAG: ld32 $m9, $m11, $m15, [[IMM2]]

  ; Cause a spill of $m9.
  call void asm sideeffect "", "~{$m9}"()

  ; Keep the argument registers $m0 - $m3 alive.
  call void asm sideeffect "", "r,r,r,r"(i32 %f1, i32 %f2, i32 %f3, i32 %f4)

  ret void
}

; Test spilling of callee-saves ($m8) and loading of stack arguments.
; SP-LABEL: callee_args_spills
; FP-LABEL: callee_args_spills
define void @callee_args_spills(i32 %f1, i32 %f2, i32 %f3, i32 %f4,
                                i32 %f5, i32 %f6, i32 %f7) {
; SP:     add $m11, $m11, -8
; SP-DAG: st32 $m9, $m11, $m15, 1
; SP-DAG: ld32 $m0, $m11, $m15, 2
; SP-DAG: ld32 $m1, $m11, $m15, 3
; SP-DAG: ld32 $m2, $m11, $m15, 4
; ..
; SP-DAG: ld32 $m9, $m11, $m15, 1
; SP:     add $m11, $m11, 8
; SP:     br $m10

; FP:     add $m11, $m11, -8
; FP:     st32 $m9, $m11, $m15, 1
; FP:     mov $m9, $m11
; FP-DAG: ld32 $m0, $m9, $m15, 2
; FP-DAG: ld32 $m1, $m9, $m15, 3
; FP-DAG: ld32 $m2, $m9, $m15, 4
; ...
; FP:     add $m11, $m9, 8
; FP:     ld32 $m9, $m9, $m15, 1
; FP:     br $m10

  ; Cause loads of args 4 - 7 from the stack.
  call void asm sideeffect "", "r, r, r"(i32 %f5, i32 %f6, i32 %f7)

  ; Cause spills of the callee saves $m9.
  call void asm sideeffect "", "~{$m9}"()

  ret void
}

; Test float arguments registers.
; SP-LABEL: callee_float_args:
; SP:       andc $a0, $a1, $a2
; SP:       andc $a3, $a4, $a{{[0-9]+}}
define void @callee_float_args(float %f1, float %f2, float %f3, float %f4,
                               float %f5, float %f6) {
  call void asm sideeffect "andc $0, $1, $2\0a\09andc $3, $4, $5",
    "r,r,r,r,r,r"(float %f1, float %f2, float %f3, float %f4,
                  float %f5, float %f6)
  ret void
}

; SP-LABEL: callee_mixed_args:
; SP:       mov $m0, $a0
; SP:       mov $m1, $a1
; SP:       mov $m2, $a2
; SP:       mov $m3, $a3
define void @callee_mixed_args(float %f1, i32 %f2, float %f3, i32 %f4,
                               float %f5, i32 %f6, float %f7, i32 %f8) {
  call void asm sideeffect "mov $1, $0\0a\09mov $3, $2\0a\09mov $5, $4\0a\09mov $7, $6",
    "r,r,r,r,r,r,r,r"(float %f1, i32 %f2, float %f3, i32 %f4,
                      float %f5, i32 %f6, float %f7, i32 %f8)
  ret void
}

; Test i32 return value is passed in $m0.
; SP-LABEL: callee_return_i32:
; SP:     	add $m0, $m0, 1
; SP:     	br $m10
define i32 @callee_return_i32(i32 %a) {
  %1 = add nsw i32 %a, 1
  ret i32 %1
}

; Test float return value is passed in $a0.
; SP-LABEL: callee_return_float:
; SP:       or $a0, $a15, 1065353216
; SP-NEXT:  br $m10
define float @callee_return_float() {
  ret float 1.0
}
