; RUN: llc < %s -mtriple=colossus -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -mtriple=colossus -mattr=+ipu2 | FileCheck %s

; Test a DAG transform for (ne x c) => (eq x c) for constant c != 0
; cmpeq is preferred to cmpne because it can take an immediate operand
; cmpne is preferred when the constant is zero to allow brnzdec

; CHECK-LABEL: test_eq_0:
; CHECK:       brz $m0, [[LABEL:\.L[A-Z0-9_]+]]
; CHECK:       br $m10
; CHECK:       [[LABEL]]:
; CHECK:       br $m10
define void @test_eq_0(i32 %idx) {
entry:
  %cmp = icmp eq i32 %idx, 0
  br i1 %cmp, label %if.then, label %if.end
if.then:
  call void asm sideeffect "# Sink", ""()
  br label %if.end
if.end:
  ret void
}

; CHECK-LABEL: test_eq_1:
; CHECK:       cmpeq [[REG:\$m[0-9]+]], $m0, 1
; CHECK:       brz [[REG]], [[LABEL:\.L[A-Z0-9_]+]]
; CHECK:       [[LABEL]]:
; CHECK:       br $m10
define void @test_eq_1(i32 %idx) {
entry:
  %cmp = icmp eq i32 %idx, 1
  br i1 %cmp, label %if.then, label %if.end
if.then:
  call void asm sideeffect "# Sink", ""()
  br label %if.end
if.end:
  ret void
}

; CHECK-LABEL: test_eq_2:
; CHECK:       cmpeq [[REG:\$m[0-9]+]], $m0, 2
; CHECK:       brz [[REG]], [[LABEL:\.L[A-Z0-9_]+]]
; CHECK:       [[LABEL]]:
; CHECK:       br $m10
define void @test_eq_2(i32 %idx) {
entry:
  %cmp = icmp eq i32 %idx, 2
  br i1 %cmp, label %if.then, label %if.end
if.then:
  call void asm sideeffect "# Sink", ""()
  br label %if.end
if.end:
  ret void
}

; CHECK-LABEL: test_ne_0:
; CHECK:       brz [[REG]], [[LABEL:\.L[A-Z0-9_]+]]
; CHECK:       [[LABEL]]:
; CHECK:       br $m10
define void @test_ne_0(i32 %idx) {
entry:
  %cmp = icmp ne i32 %idx, 0
  br i1 %cmp, label %if.then, label %if.end
if.then:
  call void asm sideeffect "# Sink", ""()
  br label %if.end
if.end:
  ret void
}

; CHECK-LABEL: test_ne_1:
; CHECK:       cmpeq [[REG:\$m[0-9]+]], $m0, 1
; CHECK:       brnz [[REG]], [[LABEL:\.L[A-Z0-9_]+]]
; CHECK:       [[LABEL]]:
; CHECK:       br $m10
define void @test_ne_1(i32 %idx) {
entry:
  %cmp = icmp ne i32 %idx, 1
  br i1 %cmp, label %if.then, label %if.end
if.then:
  call void asm sideeffect "# Sink", ""()
  br label %if.end
if.end:
  ret void
}

; CHECK-LABEL: test_ne_2:
; CHECK:       cmpeq [[REG:\$m[0-9]+]], $m0, 2
; CHECK:       brnz [[REG]], [[LABEL:\.L[A-Z0-9_]+]]
; CHECK:       [[LABEL]]:
; CHECK:       br $m10
define void @test_ne_2(i32 %idx) {
entry:
  %cmp = icmp ne i32 %idx, 2
  br i1 %cmp, label %if.then, label %if.end
if.then:
  call void asm sideeffect "# Sink", ""()
  br label %if.end
if.end:
  ret void
}
