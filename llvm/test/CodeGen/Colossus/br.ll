; RUN: llc < %s -march=colossus -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -march=colossus -mattr=+ipu2 | FileCheck %s

; CHECK-LABEL: brneg:
; CHECK:       brneg $m0, .LBB{{[0-9_]+}}
; CHECK-NOT:   br
; CHECK:       mul $m0, $m0, $m1
; CHECK-NEXT:  br
define i32 @brneg(i32 %a) {
  %1 = icmp slt i32 %a, 0
  br i1 %1, label %true, label %false
false: ; should fall through.
  %2 = call i32 asm sideeffect "", "=r,r"(i32 %a)
  %3 = mul i32 %a, %2
  ret i32 %3
true:
  ret i32 0
}

; CHECK-LABEL: brz:
; CHECK:       brz $m0, .LBB{{[0-9_]+}}
; CHECK-NOT:   br
; CHECK:       mul $m0, $m0, $m1
; CHECK-NEXT:  br
define i32 @brz(i32 %a) {
  %1 = icmp eq i32 %a, 0
  br i1 %1, label %true, label %false
false: ; should fall through.
  %2 = call i32 asm sideeffect "", "=r,r"(i32 %a)
  %3 = mul i32 %a, %2
  ret i32 %3
true:
  ret i32 0
}

; CHECK-LABEL: brpos:
; CHECK:       brpos $m0, .LBB{{[0-9_]+}}
; CHECK-NOT:   br $m0
; CHECK:       br $m10
define void @brpos(i32 %a) {
entry:
  br label %body

body:
  %i = phi i32 [ %inc, %body ], [0, %entry ]
  %ia = call i32 asm sideeffect "", "=r,r"(i32 %i)
  %inc = add i32 %ia, 1
  %cmp = icmp sge i32 %inc, 0
  br i1 %cmp, label %body, label %exit

exit:
  ret void
}

; CHECK-LABEL: brnz:
; CHECK:       brnz $m0, .LBB{{[0-9_]+}}
; CHECK-NOT:   br $m0
; CHECK:       br $m10
define void @brnz(i32 %a) {
entry:
  br label %body

body:
  %i = phi i32 [ %inc, %body ], [0, %entry ]
  %ia = call i32 asm sideeffect "", "=r,r"(i32 %i)
  %inc = add i32 %ia, 1
  %cmp = icmp ne i32 %inc, 0
  br i1 %cmp, label %body, label %exit

exit:
  ret void
}
