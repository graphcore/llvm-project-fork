; RUN: llc < %s -mtriple=colossus -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -mtriple=colossus -mattr=+ipu2 | FileCheck %s

; CHECK-LABEL: t3359_ult:
; CHECK:       # %bb
; CHECK-NEXT:  cmpult $m0, $m0, $m1
; CHECK-NOT:   cmpeq
; CHECK-NEXT:  brz $m0, [[LABEL:\.L[A-Z0-9_]+]]
; CHECK-NEXT:  # %bb
; CHECK-NEXT:  st32 $a15, $m2, $m15, 0
; CHECK-NEXT:  [[LABEL]]:
; CHECK-NEXT:  br $m10
define void @t3359_ult(i32 %index, i32 %size, i32* %out) {
entry:
  %cmp = icmp ult i32 %index, %size
  br i1 %cmp, label %if.then, label %if.end

if.then:
  store i32 0, i32* %out
  br label %if.end

if.end:
  ret void
}

; CHECK-LABEL: t3359_slt:
; CHECK:       # %bb
; CHECK-NEXT:  cmpslt $m0, $m0, $m1
; CHECK-NOT:   cmpeq
; CHECK-NEXT:  brz $m0, [[LABEL:\.L[A-Z0-9_]+]]
; CHECK-NEXT:  # %bb
; CHECK-NEXT:  st32 $a15, $m2, $m15, 0
; CHECK-NEXT:  [[LABEL]]:
; CHECK-NEXT:  br $m10
define void @t3359_slt(i32 %index, i32 %size, i32* %out) {
entry:
  %cmp = icmp slt i32 %index, %size
  br i1 %cmp, label %if.then, label %if.end

if.then:
  store i32 0, i32* %out
  br label %if.end

if.end:
  ret void
}

