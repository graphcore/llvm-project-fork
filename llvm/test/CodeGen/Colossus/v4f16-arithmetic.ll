; RUN: llc < %s -mtriple=colossus -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -mtriple=colossus -mattr=+ipu2 | FileCheck %s

declare <4 x half> @llvm.minnum.v4f16(<4 x half> %x, <4 x half> %y)
declare <4 x half> @llvm.maxnum.v4f16(<4 x half> %x, <4 x half> %y)

declare <4 x half> @llvm.experimental.constrained.fadd.v4f16(<4 x half>, <4 x half>, metadata, metadata)
declare <4 x half> @llvm.experimental.constrained.fsub.v4f16(<4 x half>, <4 x half>, metadata, metadata)
declare <4 x half> @llvm.experimental.constrained.fmul.v4f16(<4 x half>, <4 x half>, metadata, metadata)
declare <4 x half> @llvm.experimental.constrained.minnum.v4f16(<4 x half>, <4 x half>, metadata)
declare <4 x half> @llvm.experimental.constrained.maxnum.v4f16(<4 x half>, <4 x half>, metadata)

; CHECK-LABEL: test_add:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4add $a0:1, $a0:1, $a2:3
; CHECK-NEXT:  }
define <4 x half> @test_add(<4 x half> %a, <4 x half> %b) {
  %res = fadd <4 x half> %a, %b
  ret <4 x half> %res
}

; CHECK-LABEL: test_strict_add:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4add $a0:1, $a0:1, $a2:3
; CHECK-NEXT:  }
define <4 x half> @test_strict_add(<4 x half> %a, <4 x half> %b) {
  %res = call <4 x half> @llvm.experimental.constrained.fadd.v4f16(<4 x half> %a, <4 x half> %b, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <4 x half> %res
}

; CHECK-LABEL: test_sub:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4sub $a0:1, $a0:1, $a2:3
; CHECK-NEXT:  }
define <4 x half> @test_sub(<4 x half> %a, <4 x half> %b) {
  %res = fsub <4 x half> %a, %b
  ret <4 x half> %res
}

; CHECK-LABEL: test_strict_sub:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4sub $a0:1, $a0:1, $a2:3
; CHECK-NEXT:  }
define <4 x half> @test_strict_sub(<4 x half> %a, <4 x half> %b) {
  %res = call <4 x half> @llvm.experimental.constrained.fsub.v4f16(<4 x half> %a, <4 x half> %b, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <4 x half> %res
}

; CHECK-LABEL: test_mul:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4mul $a0:1, $a0:1, $a2:3
; CHECK-NEXT:  }
define <4 x half> @test_mul(<4 x half> %a, <4 x half> %b) {
  %res = fmul <4 x half> %a, %b
  ret <4 x half> %res
}

; CHECK-LABEL: test_strict_mul:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4mul $a0:1, $a0:1, $a2:3
; CHECK-NEXT:  }
define <4 x half> @test_strict_mul(<4 x half> %a, <4 x half> %b) {
  %res = call <4 x half> @llvm.experimental.constrained.fmul.v4f16(<4 x half> %a, <4 x half> %b, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <4 x half> %res
}

; CHECK-LABEL: test_minnum_v4f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4min $a0:1, $a0:1, $a2:3
; CHECK-NEXT:  }
define <4 x half> @test_minnum_v4f16(<4 x half> %x, <4 x half> %y) {
  %retval = call <4 x half> @llvm.minnum.v4f16 (<4 x half> %x, <4 x half> %y)
  ret <4 x half> %retval
}

; CHECK-LABEL: test_constrained_minnum_v4f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4min $a0:1, $a0:1, $a2:3
; CHECK-NEXT:  }
define <4 x half> @test_constrained_minnum_v4f16(<4 x half> %x, <4 x half> %y) {
  %retval = call <4 x half> @llvm.experimental.constrained.minnum.v4f16 (<4 x half> %x, <4 x half> %y, metadata !"fpexcept.strict")
  ret <4 x half> %retval
}

; CHECK-LABEL: test_maxnum_v4f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4max $a0:1, $a0:1, $a2:3
; CHECK-NEXT:  }
define <4 x half> @test_maxnum_v4f16(<4 x half> %x, <4 x half> %y) {
  %retval = call <4 x half> @llvm.maxnum.v4f16 (<4 x half> %x, <4 x half> %y)
  ret <4 x half> %retval
}

; CHECK-LABEL: test_constrained_maxnum_v4f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4max $a0:1, $a0:1, $a2:3
; CHECK-NEXT:  }
define <4 x half> @test_constrained_maxnum_v4f16(<4 x half> %x, <4 x half> %y) {
  %retval = call <4 x half> @llvm.experimental.constrained.maxnum.v4f16 (<4 x half> %x, <4 x half> %y, metadata !"fpexcept.strict")
  ret <4 x half> %retval
}

; CHECK-LABEL: v4f16_not_a:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  not64 $a0:1, $a0:1
; CHECK-NEXT:  }
define <4 x half> @v4f16_not_a(<4 x half> %x) {
  %xi = bitcast <4 x half> %x to <4 x i16>
  %res = xor <4 x i16> %xi, <i16 -1, i16 -1, i16 -1, i16 -1>
  %resf = bitcast <4 x i16> %res to <4 x half>
  ret <4 x half> %resf
}

; CHECK-LABEL: v4f16_not_b:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  not64 $a0:1, $a0:1
; CHECK-NEXT:  }
define <4 x half> @v4f16_not_b(<4 x half> %x) {
  %xi = bitcast <4 x half> %x to <4 x i16>
  %res = xor <4 x i16> <i16 -1, i16 -1, i16 -1, i16 -1>, %xi
  %resf = bitcast <4 x i16> %res to <4 x half>
  ret <4 x half> %resf
}

; CHECK-LABEL: v4f16_and_both_cast:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  and64 $a0:1, $a0:1, $a2:3
; CHECK-NEXT:  }
define <4 x half> @v4f16_and_both_cast(<4 x half> %x, <4 x half> %y) {
  %xi = bitcast <4 x half> %x to <4 x i16>
  %yi = bitcast <4 x half> %y to <4 x i16>
  %res = and <4 x i16> %xi, %yi
  %resf = bitcast <4 x i16> %res to <4 x half>
  ret <4 x half> %resf
}

; CHECK-LABEL: v4f16_and_left_cast:
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
define <4 x half> @v4f16_and_left_cast(<4 x half> %x, <4 x i16> %y) {
  %xi = bitcast <4 x half> %x to <4 x i16>
  %res = and <4 x i16> %xi, %y
  %resf = bitcast <4 x i16> %res to <4 x half>
  ret <4 x half> %resf
}

; CHECK-LABEL: v4f16_and_right_cast:
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
define <4 x half> @v4f16_and_right_cast(<4 x i16> %x, <4 x half> %y) {
  %yi = bitcast <4 x half> %y to <4 x i16>
  %res = and <4 x i16> %x, %yi
  %resf = bitcast <4 x i16> %res to <4 x half>
  ret <4 x half> %resf
}

; CHECK-LABEL: v4f16_or_both_cast:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  or64 $a0:1, $a0:1, $a2:3
; CHECK-NEXT:  }
define <4 x half> @v4f16_or_both_cast(<4 x half> %x, <4 x half> %y) {
  %xi = bitcast <4 x half> %x to <4 x i16>
  %yi = bitcast <4 x half> %y to <4 x i16>
  %res = or <4 x i16> %xi, %yi
  %resf = bitcast <4 x i16> %res to <4 x half>
  ret <4 x half> %resf
}

; CHECK-LABEL: v4f16_or_left_cast:
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
define <4 x half> @v4f16_or_left_cast(<4 x half> %x, <4 x i16> %y) {
  %xi = bitcast <4 x half> %x to <4 x i16>
  %res = or <4 x i16> %xi, %y
  %resf = bitcast <4 x i16> %res to <4 x half>
  ret <4 x half> %resf
}

; CHECK-LABEL: v4f16_or_right_cast:
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
define <4 x half> @v4f16_or_right_cast(<4 x i16> %x, <4 x half> %y) {
  %yi = bitcast <4 x half> %y to <4 x i16>
  %res = or <4 x i16> %x, %yi
  %resf = bitcast <4 x i16> %res to <4 x half>
  ret <4 x half> %resf
}
