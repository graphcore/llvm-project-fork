; RUN: llc < %s -mtriple=colossus -colossus-coissue=false -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -mtriple=colossus -colossus-coissue=false -mattr=+ipu2 | FileCheck %s



; The codegen is suboptimal here. Specifically, one of the registers is dead
; halfway through the operation so these could be lowered using one register.

; CHECK-LABEL: concat_noop_v2i16:
; CHECK-NOT:   or
; CHECK-NOT:   mov
; CHECK:       br $m10
define <4 x i16> @concat_noop_v2i16(<2 x i16> %a, <2 x i16> %b) {
  %retval = shufflevector <2 x i16> %a,
                          <2 x i16> %b,
                          <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  ret <4 x i16> %retval
}

; CHECK-LABEL: concat_move_v2i16:
; CHECK-DAG:   mov [[REGLO:\$m[0-9]+]], $m1
; CHECK-DAG:   mov [[REGHI:\$m[0-9]+]], $m2
; CHECK-NOT:   Separate DAG groups
; CHECK-DAG:   mov $m0, [[REGLO]]
; CHECK-DAG:   mov $m1, [[REGHI]]
; CHECK-NEXT:  br $m10
define <4 x i16> @concat_move_v2i16(i16 %shim, <2 x i16> %a, <2 x i16> %b) {
  %retval = shufflevector <2 x i16> %a,
                          <2 x i16> %b,
                          <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  ret <4 x i16> %retval
}

; CHECK-LABEL: concat_swap_v2i16:
; CHECK-DAG:   mov [[REGLO:\$m[0-9]+]], $m0
; CHECK-DAG:   mov [[REGHI:\$m[0-9]+]], $m1
; CHECK-NOT:   Separate DAG groups
; CHECK-DAG:   mov $m1, [[REGLO]]
; CHECK-DAG:   mov $m0, [[REGHI]]
; CHECK-NEXT:  br $m10
define <4 x i16> @concat_swap_v2i16(<2 x i16> %a, <2 x i16> %b) {
  %retval = shufflevector <2 x i16> %a,
                          <2 x i16> %b,
                          <4 x i32> <i32 2, i32 3, i32 0, i32 1>
  ret <4 x i16> %retval
}

; CHECK-LABEL: concat_noop_v2f16:
; CHECK-NOT:   or
; CHECK:       br $m10
define <4 x half> @concat_noop_v2f16(<2 x half> %a, <2 x half> %b) {
  %retval = shufflevector <2 x half> %a,
                          <2 x half> %b,
                          <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  ret <4 x half> %retval
}

; CHECK-LABEL: concat_move_v2f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $a3, $a2
; CHECK-NEXT:  mov $a2, $a1
; CHECK-NEXT:  mov $a0:1, $a2:3
; CHECK-NEXT:  br $m10
define <4 x half> @concat_move_v2f16(half %shim, <2 x half> %a, <2 x half> %b) {
  %retval = shufflevector <2 x half> %a,
                          <2 x half> %b,
                          <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  ret <4 x half> %retval
}

; CHECK-LABEL: concat_swap_v2f16:
; CHECK:       # %bb.0:
; CHECK-DAG:   mov $a2, $a1
; CHECK-DAG:   mov $a3, $a0
; CHECK-NEXT:  mov $a0:1, $a2:3
; CHECK-NEXT:  br $m10
define <4 x half> @concat_swap_v2f16(<2 x half> %a, <2 x half> %b) {
  %retval = shufflevector <2 x half> %a,
                          <2 x half> %b,
                          <4 x i32> <i32 2, i32 3, i32 0, i32 1>
  ret <4 x half> %retval
}
