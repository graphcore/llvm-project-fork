; RUN: llc < %s -march=colossus -mattr=+ipu1 | FileCheck %s -check-prefix=SP
; RUN: llc < %s -march=colossus -mattr=+ipu2 | FileCheck %s -check-prefix=SP
; RUN: llc < %s -march=colossus -mattr=+ipu1 -frame-pointer=all | FileCheck %s -check-prefix=FP
; RUN: llc < %s -march=colossus -mattr=+ipu2 -frame-pointer=all | FileCheck %s -check-prefix=FP

declare void @callee2(i32 %a1, i32 %a2, i32 %a3,
                      i32 %a4, i32 %a5, i32 %a6,
                      i32 %a7, i32 %a8, i32 %a9,
                      i32 %a10)

; Test:
;  - spilling of callee-saves ($m8)
;  - loading of incoming stack arguments
;  - storing of outgoing stack arguments

; SP-LABEL: foo
; FP-LABEL: foo
define i32 @foo(i32 %f1, i32 %f2, i32 %f3,
                i32 %f4, i32 %f5, i32 %f6,
                i32 %f7, i32 %f8, i32 %f9,
                i32 %f10) nounwind {
; SP:     add $m11, $m11, -40
; SP-DAG: st32 $m8, $m11, $m15, 9
; SP-DAG: st32 $m10, $m11, $m15, 8
; SP-DAG: st32 $m7, $m11, $m15, 7
; ... inline asm and adds.
; SP: 		setzi $a0, 10
; SP: 		setzi $a1, 9
; SP: 		setzi $a2, 8
; SP: 		setzi $a3, 7
; SP: 		st32 $a0, $m11, $m15, 5
; SP: 		setzi $a0, 6
; SP: 		st32 $a1, $m11, $m15, 4
; SP: 		setzi $a1, 5
; SP: 		st32 $a2, $m11, $m15, 3
; SP: 		st32 $a3, $m11, $m15, 2
; SP: 		st32 $a0, $m11, $m15, 1
; SP: 		st32 $a1, $m11, $m15, 0
; ... load reg args.
; SP:     call $m10, callee2
; SP-DAG: ld32 $m7, $m11, $m15, 7
; SP-DAG: ld32 $m10, $m11, $m15, 8
; SP-DAG: ld32 $m8, $m11, $m15, 9
; SP:     add $m11, $m11, 40
; SP:     br

; FP:     add $m11, $m11, -40
; FP:     st32 $m9, $m11, $m15, 6
; FP:     mov $m9, $m11
; FP:     st32 $m8, $m9, $m15, 9
; FP:     st32 $m10, $m9, $m15, 8
; FP:     st32 $m7, $m9, $m15, 7
; inline asm and adds.
; FP:     setzi $a0, 10
; FP:     setzi $a1, 9
; FP:     setzi $a2, 8
; FP:     setzi $a3, 7
; FP:     st32 $a0, $m11, $m15, 5
; FP:     setzi $a0, 6
; FP:     st32 $a1, $m11, $m15, 4
; FP:     setzi $a1, 5
; FP:     st32 $a2, $m11, $m15, 3
; FP:     st32 $a3, $m11, $m15, 2
; FP:     st32 $a0, $m11, $m15, 1
; FP:     st32 $a1, $m11, $m15, 0
; ... load arg regs.
; FP:     call $m10, callee2
; FP:     ld32 $m7, $m9, $m15, 7
; FP:     ld32 $m10, $m9, $m15, 8
; FP:     ld32 $m8, $m9, $m15, 9
; FP:     add $m11, $m9, 40
; FP:     ld32 $m9, $m9, $m15, 6
; FP:     br

  ; Cause spills of the callee saves $m8.
  call void asm sideeffect "", "~{$m8}"()

  ; Cause loads of args 8 - 10 from the stack.
  %1 = add nsw i32 %f8, %f9
  %2 = add nsw i32 %1, %f10

  ; Cause stores to the stack for arguments 8 - 10.
  call void @callee2(i32 1, i32 2, i32 3,
                     i32 4, i32 5, i32 6,
                     i32 7, i32 8, i32 9,
                     i32 10)

  ret i32 %2
}
