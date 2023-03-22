; RUN: llc < %s -march=colossus -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -march=colossus -mattr=+ipu2 | FileCheck %s
; Test cases assembled from the fuzz tester (see: T830, T1805). The bit-width
; needs to be between 17 and 31 inclusive. The seperation into two basic
; blocks is required to prevent constant folding which hides the erroring
; selection DAG.

; CHECK-LABEL: seteq_2x
define void @seteq_2x() {
  %cmp = icmp eq <2 x i17> undef, zeroinitializer
  %insel = insertelement <2 x i1> %cmp, i1 false, i32 1
  br label %next

next:
  shufflevector <2 x i1> undef, <2 x i1> %insel, <2 x i32> <i32 3, i32 undef>
  ret void
}

; CHECK-LABEL: setne_2x
define void @setne_2x() {
  %cmp = icmp ne <2 x i17> undef, zeroinitializer
  %insel = insertelement <2 x i1> %cmp, i1 false, i32 1
  br label %next

next:
  shufflevector <2 x i1> undef, <2 x i1> %insel, <2 x i32> <i32 3, i32 undef>
  ret void
}

; CHECK-LABEL: setslt_2x
define void @setslt_2x() {
  %cmp = icmp slt <2 x i17> undef, zeroinitializer
  %insel = insertelement <2 x i1> %cmp, i1 false, i32 1
  br label %next

next:
  shufflevector <2 x i1> undef, <2 x i1> %insel, <2 x i32> <i32 3, i32 undef>
  ret void
}

; CHECK-LABEL: setult_2x
define void @setult_2x() {
  %cmp = icmp ult <2 x i17> undef, zeroinitializer
  %insel = insertelement <2 x i1> %cmp, i1 false, i32 1
  br label %next

next:
  shufflevector <2 x i1> undef, <2 x i1> %insel, <2 x i32> <i32 3, i32 undef>
  ret void
}

; CHECK-LABEL: setsgt_2x
define void @setsgt_2x() {
  %cmp = icmp sgt <2 x i17> undef, zeroinitializer
  %insel = insertelement <2 x i1> %cmp, i1 false, i32 1
  br label %next

next:
  shufflevector <2 x i1> undef, <2 x i1> %insel, <2 x i32> <i32 3, i32 undef>
  ret void
}

; CHECK-LABEL: setugt_2x
define void @setugt_2x() {
  %cmp = icmp ugt <2 x i17> undef, zeroinitializer
  %insel = insertelement <2 x i1> %cmp, i1 false, i32 1
  br label %next

next:
  shufflevector <2 x i1> undef, <2 x i1> %insel, <2 x i32> <i32 3, i32 undef>
  ret void
}

; CHECK-LABEL: setsle_2x
define void @setsle_2x() {
  %cmp = icmp sle <2 x i17> undef, zeroinitializer
  %insel = insertelement <2 x i1> %cmp, i1 false, i32 1
  br label %next

next:
  shufflevector <2 x i1> undef, <2 x i1> %insel, <2 x i32> <i32 3, i32 undef>
  ret void
}

; CHECK-LABEL: setule_2x
define void @setule_2x() {
  %cmp = icmp ule <2 x i17> undef, zeroinitializer
  %insel = insertelement <2 x i1> %cmp, i1 false, i32 1
  br label %next

next:
  shufflevector <2 x i1> undef, <2 x i1> %insel, <2 x i32> <i32 3, i32 undef>
  ret void
}

; CHECK-LABEL: setsge_2x
define void @setsge_2x() {
  %cmp = icmp sge <2 x i17> undef, zeroinitializer
  %insel = insertelement <2 x i1> %cmp, i1 false, i32 1
  br label %next

next:
  shufflevector <2 x i1> undef, <2 x i1> %insel, <2 x i32> <i32 3, i32 undef>
  ret void
}

; CHECK-LABEL: setuge_2x
define void @setuge_2x() {
  %cmp = icmp uge <2 x i17> undef, zeroinitializer
  %insel = insertelement <2 x i1> %cmp, i1 false, i32 1
  br label %next

next:
  shufflevector <2 x i1> undef, <2 x i1> %insel, <2 x i32> <i32 3, i32 undef>
  ret void
}

