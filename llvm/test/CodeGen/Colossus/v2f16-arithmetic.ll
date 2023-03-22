; RUN: llc < %s -mtriple=colossus -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -mtriple=colossus -mattr=+ipu2 | FileCheck %s

declare <2 x half> @llvm.minnum.v2f16(<2 x half> %x, <2 x half> %y)
declare <2 x half> @llvm.maxnum.v2f16(<2 x half> %x, <2 x half> %y)

declare <2 x half> @llvm.experimental.constrained.fadd.v2f16(<2 x half>, <2 x half>, metadata, metadata)
declare <2 x half> @llvm.experimental.constrained.fsub.v2f16(<2 x half>, <2 x half>, metadata, metadata)
declare <2 x half> @llvm.experimental.constrained.fmul.v2f16(<2 x half>, <2 x half>, metadata, metadata)
declare <2 x half> @llvm.experimental.constrained.minnum.v2f16(<2 x half>, <2 x half>, metadata)
declare <2 x half> @llvm.experimental.constrained.maxnum.v2f16(<2 x half>, <2 x half>, metadata)

; CHECK-LABEL: test_add:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2add $a0, $a0, $a1
; CHECK-NEXT:  }
define <2 x half> @test_add(<2 x half> %a, <2 x half> %b) {
  %res = fadd <2 x half> %a, %b
  ret <2 x half> %res
}

; CHECK-LABEL: test_strict_add:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2add $a0, $a0, $a1
; CHECK-NEXT:  }
define <2 x half> @test_strict_add(<2 x half> %a, <2 x half> %b) {
  %res = call <2 x half> @llvm.experimental.constrained.fadd.v2f16(<2 x half> %a, <2 x half> %b, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <2 x half> %res
}

; CHECK-LABEL: test_sub:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2sub $a0, $a0, $a1
; CHECK-NEXT:  }
define <2 x half> @test_sub(<2 x half> %a, <2 x half> %b) {
  %res = fsub <2 x half> %a, %b
  ret <2 x half> %res
}

; CHECK-LABEL: test_strict_sub:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2sub $a0, $a0, $a1
; CHECK-NEXT:  }
define <2 x half> @test_strict_sub(<2 x half> %a, <2 x half> %b) {
  %res = call <2 x half> @llvm.experimental.constrained.fsub.v2f16(<2 x half> %a, <2 x half> %b, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <2 x half> %res
}

; CHECK-LABEL: test_mul:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2mul $a0, $a0, $a1
; CHECK-NEXT:  }
define <2 x half> @test_mul(<2 x half> %a, <2 x half> %b) {
  %res = fmul <2 x half> %a, %b
  ret <2 x half> %res
}

; CHECK-LABEL: test_strict_mul:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2mul $a0, $a0, $a1
; CHECK-NEXT:  }
define <2 x half> @test_strict_mul(<2 x half> %a, <2 x half> %b) {
  %res = call <2 x half> @llvm.experimental.constrained.fmul.v2f16(<2 x half> %a, <2 x half> %b, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <2 x half> %res
}

; CHECK-LABEL: test_minnum_v2f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2min $a0, $a0, $a1
; CHECK-NEXT:  }
define <2 x half> @test_minnum_v2f16(<2 x half> %x, <2 x half> %y) {
  %retval = call <2 x half> @llvm.minnum.v2f16 (<2 x half> %x, <2 x half> %y)
  ret <2 x half> %retval
}

; CHECK-LABEL: test_constrained_minnum_v2f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2min $a0, $a0, $a1
; CHECK-NEXT:  }
define <2 x half> @test_constrained_minnum_v2f16(<2 x half> %x, <2 x half> %y) {
  %retval = call <2 x half> @llvm.experimental.constrained.minnum.v2f16 (<2 x half> %x, <2 x half> %y, metadata !"fpexcept.strict")
  ret <2 x half> %retval
}

; CHECK-LABEL: test_maxnum_v2f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2max $a0, $a0, $a1
; CHECK-NEXT:  }
define <2 x half> @test_maxnum_v2f16(<2 x half> %x, <2 x half> %y) {
  %retval = call <2 x half> @llvm.maxnum.v2f16 (<2 x half> %x, <2 x half> %y)
  ret <2 x half> %retval
}

; CHECK-LABEL: test_constrained_maxnum_v2f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2max $a0, $a0, $a1
; CHECK-NEXT:  }
define <2 x half> @test_constrained_maxnum_v2f16(<2 x half> %x, <2 x half> %y) {
  %retval = call <2 x half> @llvm.experimental.constrained.maxnum.v2f16 (<2 x half> %x, <2 x half> %y, metadata !"fpexcept.strict")
  ret <2 x half> %retval
}

; CHECK-LABEL: v2f16_not:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  not $a0, $a0
; CHECK-NEXT:  }
define <2 x half> @v2f16_not(<2 x half> %x) {
  %xi = bitcast <2 x half> %x to <2 x i16>
  %res = xor <2 x i16> %xi, <i16 -1, i16 -1>
  %resf = bitcast <2 x i16> %res to <2 x half>
  ret <2 x half> %resf
}

; CHECK-LABEL: v2f16_and_both_cast:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  and $a0, $a0, $a1
; CHECK-NEXT:  }
define <2 x half> @v2f16_and_both_cast(<2 x half> %x, <2 x half> %y) {
  %xi = bitcast <2 x half> %x to i32
  %yi = bitcast <2 x half> %y to i32
  %res = and i32 %xi, %yi
  %resf = bitcast i32 %res to <2 x half>
  ret <2 x half> %resf
}

; CHECK-LABEL: v2f16_and_left_cast:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m0, $m11, $m15, 1
; CHECK-NEXT:  ld32 $a1, $m11, $m15, 1
; CHECK-NEXT:  {
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK-NEXT:  and $a0, $a0, $a1
; CHECK-NEXT:  }
; CHECK:       br $m10
define <2 x half> @v2f16_and_left_cast(<2 x half> %x, i32 %y) {
  %xi = bitcast <2 x half> %x to i32
  %res = and i32 %xi, %y
  %resf = bitcast i32 %res to <2 x half>
  ret <2 x half> %resf
}

; CHECK-LABEL: v2f16_and_right_cast:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m0, $m11, $m15, 1
; CHECK-NEXT:  ld32 $a1, $m11, $m15, 1
; CHECK-NEXT:  {
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK-NEXT:  and $a0, $a1, $a0
; CHECK-NEXT:  }
; CHECK:       br $m10
define <2 x half> @v2f16_and_right_cast(i32 %x, <2 x half> %y) {
  %yi = bitcast <2 x half> %y to i32
  %res = and i32 %x, %yi
  %resf = bitcast i32 %res to <2 x half>
  ret <2 x half> %resf
}

; CHECK-LABEL: v2f16_or_both_cast:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  or $a0, $a0, $a1
; CHECK-NEXT:  }
define <2 x half> @v2f16_or_both_cast(<2 x half> %x, <2 x half> %y) {
  %xi = bitcast <2 x half> %x to i32
  %yi = bitcast <2 x half> %y to i32
  %res = or i32 %xi, %yi
  %resf = bitcast i32 %res to <2 x half>
  ret <2 x half> %resf
}

; CHECK-LABEL: v2f16_or_left_cast:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m0, $m11, $m15, 1
; CHECK-NEXT:  ld32 $a1, $m11, $m15, 1
; CHECK-NEXT:  {
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK-NEXT:  or $a0, $a0, $a1
; CHECK-NEXT:  }
; CHECK:       br $m10
define <2 x half> @v2f16_or_left_cast(<2 x half> %x, i32 %y) {
  %xi = bitcast <2 x half> %x to i32
  %res = or i32 %xi, %y
  %resf = bitcast i32 %res to <2 x half>
  ret <2 x half> %resf
}

; CHECK-LABEL: v2f16_or_right_cast:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m0, $m11, $m15, 1
; CHECK-NEXT:  ld32 $a1, $m11, $m15, 1
; CHECK-NEXT:  {
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK-NEXT:  or $a0, $a1, $a0
; CHECK-NEXT:  }
; CHECK:       br $m10
define <2 x half> @v2f16_or_right_cast(i32 %x, <2 x half> %y) {
  %yi = bitcast <2 x half> %y to i32
  %res = or i32 %x, %yi
  %resf = bitcast i32 %res to <2 x half>
  ret <2 x half> %resf
}
