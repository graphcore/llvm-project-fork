; RUN: llc < %s -mtriple=colossus -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -mtriple=colossus -mattr=+ipu2 | FileCheck %s

declare half @llvm.minnum.f16(half %x, half %y)
declare half @llvm.maxnum.f16(half %x, half %y)
declare half @llvm.experimental.constrained.minnum.f16(half, half, metadata)
declare half @llvm.experimental.constrained.maxnum.f16(half, half, metadata)

declare half @llvm.experimental.constrained.fadd.f16(half, half, metadata, metadata)
declare half @llvm.experimental.constrained.fsub.f16(half, half, metadata, metadata)
declare half @llvm.experimental.constrained.fmul.f16(half, half, metadata, metadata)

; CHECK-LABEL: test_add:
; CHECK:       # %bb.0:
; CHECK-NEXT:  sort4x16lo [[REGB:\$a[0-9]+]], $a1, $a1
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2add [[REGC:\$a[0-9]+]], $a0:BL, [[REGB]]
; CHECK-NEXT:  }
define half @test_add(half %a, half %b) {
  %res = fadd half %a, %b
  ret half %res
}

; CHECK-LABEL: strict_test_add:
; CHECK:       # %bb.0:
; CHECK-NEXT:  sort4x16lo [[REGB:\$a[0-9]+]], $a1, $a1
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2add [[REGC:\$a[0-9]+]], $a0:BL, [[REGB]]
; CHECK-NEXT:  }
define half @strict_test_add(half %a, half %b) {
  %res = call half @llvm.experimental.constrained.fadd.f16(half %a, half %b, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret half %res
}

; CHECK-LABEL: test_sub:
; CHECK:       # %bb.0:
; CHECK-DAG:   sort4x16lo [[REGB:\$a[0-9]+]], $a1, $a1
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2sub [[REGC:\$a[0-9]+]], $a0:BL, [[REGB]]
; CHECK-NEXT:  }
define half @test_sub(half %a, half %b) {
  %res = fsub half %a, %b
  ret half %res
}

; CHECK-LABEL: strict_test_sub:
; CHECK:       # %bb.0:
; CHECK-DAG:   sort4x16lo [[REGB:\$a[0-9]+]], $a1, $a1
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2sub [[REGC:\$a[0-9]+]], $a0:BL, [[REGB]]
; CHECK-NEXT:  }
define half @strict_test_sub(half %a, half %b) {
  %res = call half @llvm.experimental.constrained.fsub.f16(half %a, half %b, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret half %res
}

; CHECK-LABEL: test_mul:
; CHECK:       # %bb.0:
; CHECK-DAG:   sort4x16lo [[REGB:\$a[0-9]+]], $a1, $a1
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2mul [[REGC:\$a[0-9]+]], $a0:BL, [[REGB]]
; CHECK-NEXT:  }
define half @test_mul(half %a, half %b) {
  %res = fmul half %a, %b
  ret half %res
}

; CHECK-LABEL: strict_test_mul:
; CHECK:       # %bb.0:
; CHECK-DAG:   sort4x16lo [[REGB:\$a[0-9]+]], $a1, $a1
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2mul [[REGC:\$a[0-9]+]], $a0:BL, [[REGB]]
; CHECK-NEXT:  }
define half @strict_test_mul(half %a, half %b) {
  %res = call half @llvm.experimental.constrained.fmul.f16(half %a, half %b, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret half %res
}

; CHECK-LABEL: test_minnum_f16:
; CHECK:       # %bb.0:
; CHECK-DAG:   sort4x16lo [[REGA:\$a[0-9]+]], $a0, $a0
; CHECK-DAG:   sort4x16lo [[REGB:\$a[0-9]+]], $a1, $a1
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2min [[REGC:\$a[0-9]+]], [[REGA]], [[REGB]]
; CHECK-NEXT:  }
define half @test_minnum_f16(half %x, half %y) {
  %retval = call half @llvm.minnum.f16 (half %x, half %y)
  ret half %retval
}

; CHECK-LABEL: test_constrained_minnum_f16:
; CHECK:       # %bb.0:
; CHECK-DAG:   sort4x16lo [[REGA:\$a[0-9]+]], $a0, $a0
; CHECK-DAG:   sort4x16lo [[REGB:\$a[0-9]+]], $a1, $a1
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2min [[REGC:\$a[0-9]+]], [[REGA]], [[REGB]]
; CHECK-NEXT:  }
define half @test_constrained_minnum_f16(half %x, half %y) {
  %retval = call half @llvm.experimental.constrained.minnum.f16 (half %x, half %y, metadata !"fpexcept.strict")
  ret half %retval
}

; CHECK-LABEL: test_maxnum_f16:
; CHECK:       # %bb.0:
; CHECK-DAG:   sort4x16lo [[REGA:\$a[0-9]+]], $a0, $a0
; CHECK-DAG:   sort4x16lo [[REGB:\$a[0-9]+]], $a1, $a1
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2max [[REGC:\$a[0-9]+]], [[REGA]], [[REGB]]
; CHECK-NEXT:  }
define half @test_maxnum_f16(half %x, half %y) {
  %retval = call half @llvm.maxnum.f16 (half %x, half %y)
  ret half %retval
}

; CHECK-LABEL: test_constrained_maxnum_f16:
; CHECK:       # %bb.0:
; CHECK-DAG:   sort4x16lo [[REGA:\$a[0-9]+]], $a0, $a0
; CHECK-DAG:   sort4x16lo [[REGB:\$a[0-9]+]], $a1, $a1
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2max [[REGC:\$a[0-9]+]], [[REGA]], [[REGB]]
; CHECK-NEXT:  }
define half @test_constrained_maxnum_f16(half %x, half %y) {
  %retval = call half @llvm.experimental.constrained.maxnum.f16 (half %x, half %y, metadata !"fpexcept.strict")
  ret half %retval
}

;===------------------------------------------------------------------------===;
; Bitwise operations.
;===------------------------------------------------------------------------===;

; CHECK-LABEL: f16_not_a:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  not $a0, $a0
; CHECK-NEXT:  }
define half @f16_not_a(half %x) {
  %xi = bitcast half %x to i16
  %res = xor i16 %xi, -1
  %resf = bitcast i16 %res to half
  ret half %resf
}

; CHECK-LABEL: f16_not_b:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  not $a0, $a0
; CHECK-NEXT:  }
define half @f16_not_b(half %x) {
  %xi = bitcast half %x to i16
  %res = xor i16 -1, %xi
  %resf = bitcast i16 %res to half
  ret half %resf
}

; CHECK-LABEL: f16_and_both_cast:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  and $a0, $a0, $a1
; CHECK-NEXT:  }
define half @f16_and_both_cast(half %x, half %y) {
  %xi = bitcast half %x to i16
  %yi = bitcast half %y to i16
  %res = and i16 %xi, %yi
  %resf = bitcast i16 %res to half
  ret half %resf
}

; CHECK-LABEL: f16_and_left_cast:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m0, $m11, $m15, 1
; CHECK-NEXT:  ld32 $a1, $m11, $m15, 1
; CHECK-NEXT:  {
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK-NEXT:  and $a0, $a0, $a1
; CHECK-NEXT:  }
; CHECK:       br $m10
define half @f16_and_left_cast(half %x, i16 %y) {
  %xi = bitcast half %x to i16
  %res = and i16 %xi, %y
  %resf = bitcast i16 %res to half
  ret half %resf
}

; CHECK-LABEL: f16_and_right_cast:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m0, $m11, $m15, 1
; CHECK-NEXT:  ld32 $a1, $m11, $m15, 1
; CHECK-NEXT:  {
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK-NEXT:  and $a0, $a1, $a0
; CHECK-NEXT:  }
; CHECK:       br $m10
define half @f16_and_right_cast(i16 %x, half %y) {
  %yi = bitcast half %y to i16
  %res = and i16 %x, %yi
  %resf = bitcast i16 %res to half
  ret half %resf
}

; CHECK-LABEL: f16_or_both_cast:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  or $a0, $a0, $a1
; CHECK-NEXT:  }
define half @f16_or_both_cast(half %x, half %y) {
  %xi = bitcast half %x to i16
  %yi = bitcast half %y to i16
  %res = or i16 %xi, %yi
  %resf = bitcast i16 %res to half
  ret half %resf
}

; CHECK-LABEL: f16_or_left_cast:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m0, $m11, $m15, 1
; CHECK-NEXT:  ld32 $a1, $m11, $m15, 1
; CHECK-NEXT:  {
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK-NEXT:  or $a0, $a0, $a1
; CHECK-NEXT:  }
; CHECK:       br $m10
define half @f16_or_left_cast(half %x, i16 %y) {
  %xi = bitcast half %x to i16
  %res = or i16 %xi, %y
  %resf = bitcast i16 %res to half
  ret half %resf
}

; CHECK-LABEL: f16_or_right_cast:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m0, $m11, $m15, 1
; CHECK-NEXT:  ld32 $a1, $m11, $m15, 1
; CHECK-NEXT:  {
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK-NEXT:  or $a0, $a1, $a0
; CHECK-NEXT:  }
; CHECK:       br $m10
define half @f16_or_right_cast(i16 %x, half %y) {
  %yi = bitcast half %y to i16
  %res = or i16 %x, %yi
  %resf = bitcast i16 %res to half
  ret half %resf
}
