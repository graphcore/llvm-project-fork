; RUN: llc < %s -mtriple=colossus -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -mtriple=colossus -mattr=+ipu2 | FileCheck %s

declare <2 x i1> @llvm.experimental.constrained.fcmps.v2f16(<2 x half>, <2 x half>, metadata, metadata)
declare <4 x i1> @llvm.experimental.constrained.fcmps.v4f16(<4 x half>, <4 x half>, metadata, metadata)
declare <2 x i1> @llvm.experimental.constrained.fcmps.v2f32(<2 x float>, <2 x float>, metadata, metadata)

; CHECK-LABEL: v2f16_vselect_min:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f16v2cmplt $a2, $a0, $a1
; CHECK-DAG:   and $a0, $a0, $a2
; CHECK-DAG:   andc $a1, $a1, $a2
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  or $a0, $a0, $a1
; CHECK-NEXT:  }
define <2 x half> @v2f16_vselect_min(<2 x half> %lhs, <2 x half> %rhs) {
  %1 = fcmp olt <2 x half> %lhs, %rhs
  %2 = select <2 x i1> %1, <2 x half> %lhs, <2 x half> %rhs
  ret <2 x half> %2
}

; CHECK-LABEL: constrained_v2f16_vselect_min:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f16v2cmplt $a2, $a0, $a1
; CHECK-DAG:   and $a0, $a0, $a2
; CHECK-DAG:   andc $a1, $a1, $a2
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  or $a0, $a0, $a1
; CHECK-NEXT:  }
define <2 x half> @constrained_v2f16_vselect_min(<2 x half> %lhs, <2 x half> %rhs) {
  %1 = tail call <2 x i1> @llvm.experimental.constrained.fcmps.v2f16(<2 x half> %lhs, <2 x half> %rhs, metadata !"olt", metadata !"fpexcept.strict")
  %2 = select <2 x i1> %1, <2 x half> %lhs, <2 x half> %rhs
  ret <2 x half> %2
}

; CHECK-LABEL: v4f16_vselect_min:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f16v4cmplt $a4:5, $a0:1, $a2:3
; CHECK-DAG:   and64 $a0:1, $a0:1, $a4:5
; CHECK-DAG:   andc64 $a2:3, $a2:3, $a4:5
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  or64 $a0:1, $a0:1, $a2:3
; CHECK-NEXT:  }
define <4 x half> @v4f16_vselect_min(<4 x half> %lhs, <4 x half> %rhs) {
  %1 = fcmp olt <4 x half> %lhs, %rhs
  %2 = select <4 x i1> %1, <4 x half> %lhs, <4 x half> %rhs
  ret <4 x half> %2
}

; CHECK-LABEL: constrained_v4f16_vselect_min:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f16v4cmplt $a4:5, $a0:1, $a2:3
; CHECK-DAG:   and64 $a0:1, $a0:1, $a4:5
; CHECK-DAG:   andc64 $a2:3, $a2:3, $a4:5
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  or64 $a0:1, $a0:1, $a2:3
; CHECK-NEXT:  }
define <4 x half> @constrained_v4f16_vselect_min(<4 x half> %lhs, <4 x half> %rhs) {
  %1 = tail call <4 x i1> @llvm.experimental.constrained.fcmps.v4f16(<4 x half> %lhs, <4 x half> %rhs, metadata !"olt", metadata !"fpexcept.strict")
  %2 = select <4 x i1> %1, <4 x half> %lhs, <4 x half> %rhs
  ret <4 x half> %2
}

; CHECK-LABEL: v2f32_vselect_min:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f32v2cmplt $a4:5, $a0:1, $a2:3
; CHECK-DAG:   and64 $a0:1, $a0:1, $a4:5
; CHECK-DAG:   andc64 $a2:3, $a2:3, $a4:5
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  or64 $a0:1, $a0:1, $a2:3
; CHECK-NEXT:  }
define <2 x float> @v2f32_vselect_min(<2 x float> %lhs, <2 x float> %rhs) {
  %1 = fcmp olt <2 x float> %lhs, %rhs
  %2 = select <2 x i1> %1, <2 x float> %lhs, <2 x float> %rhs
  ret <2 x float> %2
}

; CHECK-LABEL: constrained_v2f32_vselect_min:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f32v2cmplt $a4:5, $a0:1, $a2:3
; CHECK-DAG:   and64 $a0:1, $a0:1, $a4:5
; CHECK-DAG:   andc64 $a2:3, $a2:3, $a4:5
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  or64 $a0:1, $a0:1, $a2:3
; CHECK-NEXT:  }
define <2 x float> @constrained_v2f32_vselect_min(<2 x float> %lhs, <2 x float> %rhs) {
  %1 = tail call <2 x i1> @llvm.experimental.constrained.fcmps.v2f32(<2 x float> %lhs, <2 x float> %rhs, metadata !"olt", metadata !"fpexcept.strict")
  %2 = select <2 x i1> %1, <2 x float> %lhs, <2 x float> %rhs
  ret <2 x float> %2
}

; CHECK-LABEL: v2f16_vselect:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; CHECK:       shl $m1, $m0, 15
; CHECK-NEXT:  shl $m0, $m0, 31
; CHECK-NEXT:  shrs $m1, $m1, 31
; CHECK-NEXT:  shrs $m0, $m0, 31
; CHECK-NEXT:  sort4x16lo $m0, $m0, $m1
; CHECK-NEXT:  st32 $m0, $m11, $m15, 1
; CHECK-NEXT:  ld32 [[REGC:\$a[2-9]+]], $m11, $m15, 1
; CHECK-DAG:   and [[REG0:\$a[0-9]+]], $a0, [[REGC]]
; CHECK-DAG:   andc [[REG1:\$a[0-9]+]], $a1, [[REGC]]
; CHECK-NEXT:  {
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK-NEXT:  or $a0, [[REG0]], [[REG1]]
; CHECK-NEXT:  }
; CHECK:       br $m10
define <2 x half> @v2f16_vselect(<2 x i1> %cond, <2 x half> %t, <2 x half> %f) {
  %1 = select <2 x i1> %cond, <2 x half> %t, <2 x half> %f
  ret <2 x half> %1
}

; CHECK-LABEL: v4f16_vselect:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; CHECK-DAG:   sort4x16lo
; CHECK-DAG:   sort4x16lo
; CHECK-NOT:   finished-with-signext
; CHECK:       st32
; CHECK-NEXT:  st32
; CHECK-NEXT:  ld64
; CHECK-DAG:   and64
; CHECK-DAG:   andc64
; CHECK-NEXT:  {
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK-NEXT:  or64
; CHECK-NEXT:  }
; CHECK:       br $m10
define <4 x half> @v4f16_vselect(<4 x i1> %cond, <4 x half> %t, <4 x half> %f) {
  %1 = select <4 x i1> %cond, <4 x half> %t, <4 x half> %f
  ret <4 x half> %1
}

; CHECK-LABEL: v2f32_vselect:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; CHECK-DAG:   shl
; CHECK-DAG:   shl
; CHECK-DAG:   shrs
; CHECK-DAG:   shrs
; CHECK-NOT:   finished-with-signext
; CHECK:       st32
; CHECK-NEXT:  st32
; CHECK-NEXT:  ld64
; CHECK-DAG:   and64
; CHECK-DAG:   andc64
; CHECK-NEXT:  {
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK-NEXT:  or64
; CHECK-NEXT:  }
; CHECK:       br $m10
define <2 x float> @v2f32_vselect(<2 x i1> %cond, <2 x float> %t, <2 x float> %f) {
  %1 = select <2 x i1> %cond, <2 x float> %t, <2 x float> %f
  ret <2 x float> %1
}
