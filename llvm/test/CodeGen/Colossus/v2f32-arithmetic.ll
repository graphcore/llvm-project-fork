; RUN: llc < %s -mtriple=colossus -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -mtriple=colossus -mattr=+ipu2 | FileCheck %s

declare <2 x float> @llvm.minnum.v2f32(<2 x float> %x, <2 x float> %y)
declare <2 x float> @llvm.maxnum.v2f32(<2 x float> %x, <2 x float> %y)

declare <2 x float> @llvm.experimental.constrained.fadd.v2f32(<2 x float>, <2 x float>, metadata, metadata)
declare <2 x float> @llvm.experimental.constrained.fsub.v2f32(<2 x float>, <2 x float>, metadata, metadata)
declare <2 x float> @llvm.experimental.constrained.fmul.v2f32(<2 x float>, <2 x float>, metadata, metadata)
declare <2 x float> @llvm.experimental.constrained.minnum.v2f32(<2 x float>, <2 x float>, metadata)
declare <2 x float> @llvm.experimental.constrained.maxnum.v2f32(<2 x float>, <2 x float>, metadata)

; CHECK-LABEL: test_add:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f32v2add $a0:1, $a0:1, $a2:3
; CHECK-NEXT:  }
define <2 x float> @test_add(<2 x float> %a, <2 x float> %b) {
  %res = fadd <2 x float> %a, %b
  ret <2 x float> %res
}

; CHECK-LABEL: test_strict_add:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f32v2add $a0:1, $a0:1, $a2:3
; CHECK-NEXT:  }
define <2 x float> @test_strict_add(<2 x float> %a, <2 x float> %b) {
  %res = call <2 x float> @llvm.experimental.constrained.fadd.v2f32(<2 x float> %a, <2 x float> %b, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <2 x float> %res
}

; CHECK-LABEL: test_sub:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f32v2sub $a0:1, $a0:1, $a2:3
; CHECK-NEXT:  }
define <2 x float> @test_sub(<2 x float> %a, <2 x float> %b) {
  %res = fsub <2 x float> %a, %b
  ret <2 x float> %res
}

; CHECK-LABEL: test_strict_sub:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f32v2sub $a0:1, $a0:1, $a2:3
; CHECK-NEXT:  }
define <2 x float> @test_strict_sub(<2 x float> %a, <2 x float> %b) {
  %res = call <2 x float> @llvm.experimental.constrained.fsub.v2f32(<2 x float> %a, <2 x float> %b, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <2 x float> %res
}

; CHECK-LABEL: test_mul:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f32v2mul $a0:1, $a0:1, $a2:3
; CHECK-NEXT:  }
define <2 x float> @test_mul(<2 x float> %a, <2 x float> %b) {
  %res = fmul <2 x float> %a, %b
  ret <2 x float> %res
}

; CHECK-LABEL: test_struct_mul:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f32v2mul $a0:1, $a0:1, $a2:3
; CHECK-NEXT:  }
define <2 x float> @test_struct_mul(<2 x float> %a, <2 x float> %b) {
  %res = call <2 x float> @llvm.experimental.constrained.fmul.v2f32(<2 x float> %a, <2 x float> %b, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <2 x float> %res
}

; CHECK-LABEL: test_minnum_v2f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f32v2min $a0:1, $a0:1, $a2:3
; CHECK-NEXT:  }
define <2 x float> @test_minnum_v2f32(<2 x float> %x, <2 x float> %y) {
  %retval = call <2 x float> @llvm.minnum.v2f32 (<2 x float> %x, <2 x float> %y)
  ret <2 x float> %retval
}

; CHECK-LABEL: test_constrained_minnum_v2f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f32v2min $a0:1, $a0:1, $a2:3
; CHECK-NEXT:  }
define <2 x float> @test_constrained_minnum_v2f32(<2 x float> %x, <2 x float> %y) {
  %retval = call <2 x float> @llvm.experimental.constrained.minnum.v2f32 (<2 x float> %x, <2 x float> %y, metadata !"fpexcept.strict")
  ret <2 x float> %retval
}

; CHECK-LABEL: test_maxnum_v2f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f32v2max $a0:1, $a0:1, $a2:3
; CHECK-NEXT:  }
define <2 x float> @test_maxnum_v2f32(<2 x float> %x, <2 x float> %y) {
  %retval = call <2 x float> @llvm.maxnum.v2f32 (<2 x float> %x, <2 x float> %y)
  ret <2 x float> %retval
}

; CHECK-LABEL: test_constrained_maxnum_v2f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f32v2max $a0:1, $a0:1, $a2:3
; CHECK-NEXT:  }
define <2 x float> @test_constrained_maxnum_v2f32(<2 x float> %x, <2 x float> %y) {
  %retval = call <2 x float> @llvm.experimental.constrained.maxnum.v2f32 (<2 x float> %x, <2 x float> %y, metadata !"fpexcept.strict")
  ret <2 x float> %retval
}

; CHECK-LABEL: v2f32_not_a:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  not64 $a0:1, $a0:1
; CHECK-NEXT:  }
define <2 x float> @v2f32_not_a(<2 x float> %x) {
  %xi = bitcast <2 x float> %x to <2 x i32>
  %res = xor <2 x i32> %xi, <i32 -1, i32 -1>
  %resf = bitcast <2 x i32> %res to <2 x float>
  ret <2 x float> %resf
}

; CHECK-LABEL: v2f32_not_b:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  not64 $a0:1, $a0:1
; CHECK-NEXT:  }
define <2 x float> @v2f32_not_b(<2 x float> %x) {
  %xi = bitcast <2 x float> %x to <2 x i32>
  %res = xor <2 x i32> <i32 -1, i32 -1>, %xi
  %resf = bitcast <2 x i32> %res to <2 x float>
  ret <2 x float> %resf
}

; CHECK-LABEL: v2f32_and_both_cast:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  and64 $a0:1, $a0:1, $a2:3
; CHECK-NEXT:  }
define <2 x float> @v2f32_and_both_cast(<2 x float> %x, <2 x float> %y) {
  %xi = bitcast <2 x float> %x to <2 x i32>
  %yi = bitcast <2 x float> %y to <2 x i32>
  %res = and <2 x i32> %xi, %yi
  %resf = bitcast <2 x i32> %res to <2 x float>
  ret <2 x float> %resf
}

; CHECK-LABEL: v2f32_and_left_cast:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; CHECK-DAG:   st32 $m0, $m11, $m15, 0
; CHECK-DAG:   st32 $m1, $m11, $m15, 1
; CHECK-NEXT:  ld64 $a2:3, $m11, $m15, 0
; CHECK-NEXT:  {
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK-NEXT:  and64 $a0:1, $a0:1, $a2:3
; CHECK-NEXT:  }
; CHECK:       br $m10
define <2 x float> @v2f32_and_left_cast(<2 x float> %x, <2 x i32> %y) {
  %xi = bitcast <2 x float> %x to <2 x i32>
  %res = and <2 x i32> %xi, %y
  %resf = bitcast <2 x i32> %res to <2 x float>
  ret <2 x float> %resf
}

; CHECK-LABEL: v2f32_and_right_cast:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; CHECK-DAG:   st32 $m0, $m11, $m15, 0
; CHECK-DAG:   st32 $m1, $m11, $m15, 1
; CHECK-NEXT:  ld64 $a2:3, $m11, $m15, 0
; CHECK-NEXT:  {
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK-NEXT:  and64 $a0:1, $a2:3, $a0:1
; CHECK-NEXT:  }
; CHECK:       br $m10
define <2 x float> @v2f32_and_right_cast(<2 x i32> %x, <2 x float> %y) {
  %yi = bitcast <2 x float> %y to <2 x i32>
  %res = and <2 x i32> %x, %yi
  %resf = bitcast <2 x i32> %res to <2 x float>
  ret <2 x float> %resf
}

; CHECK-LABEL: v2f32_or_both_cast:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  or64 $a0:1, $a0:1, $a2:3
; CHECK-NEXT:  }
define <2 x float> @v2f32_or_both_cast(<2 x float> %x, <2 x float> %y) {
  %xi = bitcast <2 x float> %x to <2 x i32>
  %yi = bitcast <2 x float> %y to <2 x i32>
  %res = or <2 x i32> %xi, %yi
  %resf = bitcast <2 x i32> %res to <2 x float>
  ret <2 x float> %resf
}

; CHECK-LABEL: v2f32_or_left_cast:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; CHECK-DAG:   st32 $m0, $m11, $m15, 0
; CHECK-DAG:   st32 $m1, $m11, $m15, 1
; CHECK-NEXT:  ld64 $a2:3, $m11, $m15, 0
; CHECK-NEXT:  {
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK-NEXT:  or64 $a0:1, $a0:1, $a2:3
; CHECK-NEXT:  }
; CHECK:       br $m10
define <2 x float> @v2f32_or_left_cast(<2 x float> %x, <2 x i32> %y) {
  %xi = bitcast <2 x float> %x to <2 x i32>
  %res = or <2 x i32> %xi, %y
  %resf = bitcast <2 x i32> %res to <2 x float>
  ret <2 x float> %resf
}

; CHECK-LABEL: v2f32_or_right_cast:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; CHECK-DAG:   st32 $m0, $m11, $m15, 0
; CHECK-DAG:   st32 $m1, $m11, $m15, 1
; CHECK-NEXT:  ld64 $a2:3, $m11, $m15, 0
; CHECK-NEXT:  {
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK-NEXT:  or64 $a0:1, $a2:3, $a0:1
; CHECK-NEXT:  }
; CHECK:       br $m10
define <2 x float> @v2f32_or_right_cast(<2 x i32> %x, <2 x float> %y) {
  %yi = bitcast <2 x float> %y to <2 x i32>
  %res = or <2 x i32> %x, %yi
  %resf = bitcast <2 x i32> %res to <2 x float>
  ret <2 x float> %resf
}
