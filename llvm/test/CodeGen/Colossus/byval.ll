; RUN: llc < %s -march=colossus -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -march=colossus -mattr=+ipu2 | FileCheck %s

; Test passing a word-size struct by value.
; CHECK-LABEL: s0_caller
; CHECK:       add $m11, $m11, -8
; CHECK:       ld32 [[rx:\$m[0-9]+]], $m0, $m15, 0
; CHECK:       st32 [[rx]]
; CHECK:       call $m10, s0_callee
%struct0 = type { i32 }
declare void @s0_callee(%struct0* byval(%struct0)) nounwind
define void @s0_caller(%struct0* %s0) nounwind {
  call void @s0_callee(%struct0* byval(%struct0) %s0) nounwind
  ret void
}

; Test passing a large struct by value.
; CHECK-LABEL: s1_caller
; CHECK:       add $m11, $m11, -48
; Src and dst addresses.
; CHECK:       mov $m1, $m0
; CHECK:       add [[rDst:\$m[0-9]+]], $m11, 8
; Call memcpy.
; CHECK:       setzi $m2, 40
; CHECK:       mov $m0, [[rDst]]
; CHECK:       call $m10, memcpy
; Call s1_callee.
; CHECK:       mov $m0, [[rDst]]
; CHECK:       call $m10, s1_callee
%struct1 = type { [10 x i32] }
declare void @s1_callee(%struct1* byval(%struct1)) nounwind
define void @s1_caller(%struct1* %s1) nounwind {
  call void @s1_callee(%struct1* byval(%struct1) %s1) nounwind
  ret void
}

; Test passing a struct byval with varargs.
; CHECK-LABEL: s2_caller
; CHECK:       add $m11, $m11, -48
; Address of struct from param.
; CHECK-DAG:   ld32 [[rSrc:\$m[0-9]+]], $m11, $m15, 12
; Address of local struct.
; CHECK-DAG:   add [[rDst:\$m[0-9]+]], $m11, 8
; memcpy the struct to local frame
; CHECK-DAG:   setzi $m2, 40
; CHECK:       call $m10, memcpy
; call s2_callee
; CHECK:       mov $m0, [[rDst]]
; CHECK:       call $m10, s2_callee
%struct2 = type { [10 x i32] }
declare void @s2_callee(%struct2* byval(%struct2)) nounwind
define void @s2_caller(%struct2* %s2, ...) nounwind {
  call void @s2_callee(%struct2* byval(%struct2) %s2)
  ret void
}
