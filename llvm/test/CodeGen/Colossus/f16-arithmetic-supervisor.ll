; RUN: llc < %s -mtriple=colossus -mattr=+supervisor -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -mtriple=colossus -mattr=+supervisor -mattr=+ipu2 | FileCheck %s

declare half @llvm.minnum.f16(half %x, half %y)
declare half @llvm.maxnum.f16(half %x, half %y)
declare half @llvm.experimental.constrained.minnum.f16(half, half, metadata)
declare half @llvm.experimental.constrained.maxnum.f16(half, half, metadata)

; CHECK-LABEL: test_add:
; CHECK:      add $m11, $m11, -16
; CHECK-NEXT: .cfi_def_cfa_offset 16
; CHECK-NEXT: .cfi_offset $m8, -4
; CHECK-NEXT: .cfi_offset $m10, -8
; CHECK-NEXT: .cfi_offset $m7, -12
; CHECK-NEXT: st32 $m8, $m11, $m15, 3                 # 4-byte Folded Spill
; CHECK-NEXT: st32 $m10, $m11, $m15, 2                # 4-byte Folded Spill
; CHECK-NEXT: st32 $m7, $m11, $m15, 1                 # 4-byte Folded Spill
; CHECK-NEXT: mov	$m7, $m1
; CHECK-NEXT: sort4x16lo $m0, $m0, $m15
; CHECK-NEXT: call $m10, __gnu_h2f_ieee
; CHECK-NEXT: mov	$m8, $m0
; CHECK-NEXT: sort4x16lo $m0, $m7, $m15
; CHECK-NEXT: call $m10, __gnu_h2f_ieee
; CHECK-NEXT: mov	$m1, $m0
; CHECK-NEXT: mov	$m0, $m8
; CHECK-NEXT: call $m10, __addsf3
; CHECK-NEXT: call $m10, __gnu_f2h_ieee
; CHECK-NEXT: sort4x16lo $m0, $m0, $m15
; CHECK-NEXT: ld32 $m7, $m11, $m15, 1                 # 4-byte Folded Reload
; CHECK-NEXT: ld32 $m10, $m11, $m15, 2                # 4-byte Folded Reload
; CHECK-NEXT: ld32 $m8, $m11, $m15, 3                 # 4-byte Folded Reload
; CHECK-NEXT: add $m11, $m11, 16
; CHECK-NEXT: .cfi_def_cfa_offset 0
; CHECK-NEXT: br $m10
define half @test_add(half %a, half %b) {
  %res = fadd half %a, %b
  ret half %res
}

; CHECK-LABEL: test_sub:
; CHECK:       add $m11, $m11, -16
; CHECK-NEXT: .cfi_def_cfa_offset 16
; CHECK-NEXT: .cfi_offset $m8, -4
; CHECK-NEXT: .cfi_offset $m10, -8
; CHECK-NEXT: .cfi_offset $m7, -12
; CHECK-NEXT: st32 $m8, $m11, $m15, 3                 # 4-byte Folded Spill
; CHECK-NEXT: st32 $m10, $m11, $m15, 2                # 4-byte Folded Spill
; CHECK-NEXT: st32 $m7, $m11, $m15, 1                 # 4-byte Folded Spill
; CHECK-NEXT: mov	$m7, $m1
; CHECK-NEXT: sort4x16lo $m0, $m0, $m15
; CHECK-NEXT: call $m10, __gnu_h2f_ieee
; CHECK-NEXT: mov	$m8, $m0
; CHECK-NEXT: sort4x16lo $m0, $m7, $m15
; CHECK-NEXT: call $m10, __gnu_h2f_ieee
; CHECK-NEXT: mov	$m1, $m0
; CHECK-NEXT: mov	$m0, $m8
; CHECK-NEXT: call $m10, __subsf3
; CHECK-NEXT: call $m10, __gnu_f2h_ieee
; CHECK-NEXT: sort4x16lo $m0, $m0, $m15
; CHECK-NEXT: ld32 $m7, $m11, $m15, 1                 # 4-byte Folded Reload
; CHECK-NEXT: ld32 $m10, $m11, $m15, 2                # 4-byte Folded Reload
; CHECK-NEXT: ld32 $m8, $m11, $m15, 3                 # 4-byte Folded Reload
; CHECK-NEXT: add $m11, $m11, 16
; CHECK-NEXT: .cfi_def_cfa_offset 0
; CHECK-NEXT: br $m10
define half @test_sub(half %a, half %b) {
  %res = fsub half %a, %b
  ret half %res
}

; CHECK-LABEL: test_mul:
; CHECK:       add $m11, $m11, -16
; CHECK-NEXT: .cfi_def_cfa_offset 16
; CHECK-NEXT: .cfi_offset $m8, -4
; CHECK-NEXT: .cfi_offset $m10, -8
; CHECK-NEXT: .cfi_offset $m7, -12
; CHECK-NEXT: st32 $m8, $m11, $m15, 3                 # 4-byte Folded Spill
; CHECK-NEXT: st32 $m10, $m11, $m15, 2                # 4-byte Folded Spill
; CHECK-NEXT: st32 $m7, $m11, $m15, 1                 # 4-byte Folded Spill
; CHECK-NEXT: mov	$m7, $m1
; CHECK-NEXT: sort4x16lo $m0, $m0, $m15
; CHECK-NEXT: call $m10, __gnu_h2f_ieee
; CHECK-NEXT: mov	$m8, $m0
; CHECK-NEXT: sort4x16lo $m0, $m7, $m15
; CHECK-NEXT: call $m10, __gnu_h2f_ieee
; CHECK-NEXT: mov	$m1, $m0
; CHECK-NEXT: mov	$m0, $m8
; CHECK-NEXT: call $m10, __mulsf3
; CHECK-NEXT: call $m10, __gnu_f2h_ieee
; CHECK-NEXT: sort4x16lo $m0, $m0, $m15
; CHECK-NEXT: ld32 $m7, $m11, $m15, 1                 # 4-byte Folded Reload
; CHECK-NEXT: ld32 $m10, $m11, $m15, 2                # 4-byte Folded Reload
; CHECK-NEXT: ld32 $m8, $m11, $m15, 3                 # 4-byte Folded Reload
; CHECK-NEXT: add $m11, $m11, 16
; CHECK-NEXT: .cfi_def_cfa_offset 0
; CHECK-NEXT: br $m10
define half @test_mul(half %a, half %b) {
  %res = fmul half %a, %b
  ret half %res
}

; CHECK-LABEL: test_minnum_f16:
; CHECK:      add $m11, $m11, -16
; CHECK-NEXT: .cfi_def_cfa_offset 16
; CHECK-NEXT: .cfi_offset $m8, -4
; CHECK-NEXT: .cfi_offset $m10, -8
; CHECK-NEXT: .cfi_offset $m7, -12
; CHECK-NEXT: st32 $m8, $m11, $m15, 3                 # 4-byte Folded Spill
; CHECK-NEXT: st32 $m10, $m11, $m15, 2                # 4-byte Folded Spill
; CHECK-NEXT: st32 $m7, $m11, $m15, 1                 # 4-byte Folded Spill
; CHECK-NEXT: mov	$m7, $m1
; CHECK-NEXT: sort4x16lo $m0, $m0, $m15
; CHECK-NEXT: call $m10, __gnu_h2f_ieee
; CHECK-NEXT: mov	$m8, $m0
; CHECK-NEXT: sort4x16lo $m0, $m7, $m15
; CHECK-NEXT: call $m10, __gnu_h2f_ieee
; CHECK-NEXT: mov	$m1, $m0
; CHECK-NEXT: mov	$m0, $m8
; CHECK-NEXT: call $m10, fminf
; CHECK-NEXT: call $m10, __gnu_f2h_ieee
; CHECK-NEXT: sort4x16lo $m0, $m0, $m15
; CHECK-NEXT: ld32 $m7, $m11, $m15, 1                 # 4-byte Folded Reload
; CHECK-NEXT: ld32 $m10, $m11, $m15, 2                # 4-byte Folded Reload
; CHECK-NEXT: ld32 $m8, $m11, $m15, 3                 # 4-byte Folded Reload
; CHECK-NEXT: add $m11, $m11, 16
; CHECK-NEXT: .cfi_def_cfa_offset 0
; CHECK-NEXT: br $m10
define half @test_minnum_f16(half %x, half %y) {
  %retval = call half @llvm.minnum.f16 (half %x, half %y)
  ret half %retval
}

; CHECK-LABEL: test_constrained_minnum_f16:
; CHECK:      add $m11, $m11, -16
; CHECK-NEXT: .cfi_def_cfa_offset 16
; CHECK-NEXT: .cfi_offset $m8, -4
; CHECK-NEXT: .cfi_offset $m10, -8
; CHECK-NEXT: .cfi_offset $m7, -12
; CHECK-NEXT: st32 $m8, $m11, $m15, 3                 # 4-byte Folded Spill
; CHECK-NEXT: st32 $m10, $m11, $m15, 2                # 4-byte Folded Spill
; CHECK-NEXT: st32 $m7, $m11, $m15, 1                 # 4-byte Folded Spill
; CHECK-NEXT: mov	$m7, $m0
; CHECK-NEXT: sort4x16lo $m0, $m1, $m15
; CHECK-NEXT: call $m10, __gnu_h2f_ieee
; CHECK-NEXT: mov	$m8, $m0
; CHECK-NEXT: sort4x16lo $m0, $m7, $m15
; CHECK-NEXT: call $m10, __gnu_h2f_ieee
; CHECK-NEXT: mov	$m1, $m8
; CHECK-NEXT: call $m10, fminf
; CHECK-NEXT: call $m10, __gnu_f2h_ieee
; CHECK-NEXT: sort4x16lo $m0, $m0, $m15
; CHECK-NEXT: ld32 $m7, $m11, $m15, 1                 # 4-byte Folded Reload
; CHECK-NEXT: ld32 $m10, $m11, $m15, 2                # 4-byte Folded Reload
; CHECK-NEXT: ld32 $m8, $m11, $m15, 3                 # 4-byte Folded Reload
; CHECK-NEXT: add $m11, $m11, 16
; CHECK-NEXT: .cfi_def_cfa_offset 0
; CHECK-NEXT: br $m10
define half @test_constrained_minnum_f16(half %x, half %y) {
  %retval = call half @llvm.experimental.constrained.minnum.f16 (half %x, half %y, metadata !"fpexcept.strict")
  ret half %retval
}

; CHECK-LABEL: test_maxnum_f16:
; CHECK:      add $m11, $m11, -16
; CHECK-NEXT: .cfi_def_cfa_offset 16
; CHECK-NEXT: .cfi_offset $m8, -4
; CHECK-NEXT: .cfi_offset $m10, -8
; CHECK-NEXT: .cfi_offset $m7, -12
; CHECK-NEXT: st32 $m8, $m11, $m15, 3                 # 4-byte Folded Spill
; CHECK-NEXT: st32 $m10, $m11, $m15, 2                # 4-byte Folded Spill
; CHECK-NEXT: st32 $m7, $m11, $m15, 1                 # 4-byte Folded Spill
; CHECK-NEXT: mov	$m7, $m1
; CHECK-NEXT: sort4x16lo $m0, $m0, $m15
; CHECK-NEXT: call $m10, __gnu_h2f_ieee
; CHECK-NEXT: mov	$m8, $m0
; CHECK-NEXT: sort4x16lo $m0, $m7, $m15
; CHECK-NEXT: call $m10, __gnu_h2f_ieee
; CHECK-NEXT: mov	$m1, $m0
; CHECK-NEXT: mov	$m0, $m8
; CHECK-NEXT: call $m10, fmaxf
; CHECK-NEXT: call $m10, __gnu_f2h_ieee
; CHECK-NEXT: sort4x16lo $m0, $m0, $m15
; CHECK-NEXT: ld32 $m7, $m11, $m15, 1                 # 4-byte Folded Reload
; CHECK-NEXT: ld32 $m10, $m11, $m15, 2                # 4-byte Folded Reload
; CHECK-NEXT: ld32 $m8, $m11, $m15, 3                 # 4-byte Folded Reload
; CHECK-NEXT: add $m11, $m11, 16
; CHECK-NEXT: .cfi_def_cfa_offset 0
; CHECK-NEXT: br $m10
define half @test_maxnum_f16(half %x, half %y) {
  %retval = call half @llvm.maxnum.f16 (half %x, half %y)
  ret half %retval
}

; CHECK-LABEL: test_constrained_maxnum_f16:
; CHECK:      add $m11, $m11, -16
; CHECK-NEXT: .cfi_def_cfa_offset 16
; CHECK-NEXT: .cfi_offset $m8, -4
; CHECK-NEXT: .cfi_offset $m10, -8
; CHECK-NEXT: .cfi_offset $m7, -12
; CHECK-NEXT: st32 $m8, $m11, $m15, 3                 # 4-byte Folded Spill
; CHECK-NEXT: st32 $m10, $m11, $m15, 2                # 4-byte Folded Spill
; CHECK-NEXT: st32 $m7, $m11, $m15, 1                 # 4-byte Folded Spill
; CHECK-NEXT: mov	$m7, $m0
; CHECK-NEXT: sort4x16lo $m0, $m1, $m15
; CHECK-NEXT: call $m10, __gnu_h2f_ieee
; CHECK-NEXT: mov	$m8, $m0
; CHECK-NEXT: sort4x16lo $m0, $m7, $m15
; CHECK-NEXT: call $m10, __gnu_h2f_ieee
; CHECK-NEXT: mov	$m1, $m8
; CHECK-NEXT: call $m10, fmaxf
; CHECK-NEXT: call $m10, __gnu_f2h_ieee
; CHECK-NEXT: sort4x16lo $m0, $m0, $m15
; CHECK-NEXT: ld32 $m7, $m11, $m15, 1                 # 4-byte Folded Reload
; CHECK-NEXT: ld32 $m10, $m11, $m15, 2                # 4-byte Folded Reload
; CHECK-NEXT: ld32 $m8, $m11, $m15, 3                 # 4-byte Folded Reload
; CHECK-NEXT: add $m11, $m11, 16
; CHECK-NEXT: .cfi_def_cfa_offset 0
; CHECK-NEXT: br $m10
define half @test_constrained_maxnum_f16(half %x, half %y) {
  %retval = call half @llvm.experimental.constrained.maxnum.f16 (half %x, half %y, metadata !"fpexcept.strict")
  ret half %retval
}

;===------------------------------------------------------------------------===;
; Bitwise operations.
;===------------------------------------------------------------------------===;

; CHECK-LABEL: f16_not_a:
; CHECK:      add $m1, $m15, -1
; CHECK-NEXT: xor $m0, $m0, $m1
; CHECK-NEXT: br $m10
define half @f16_not_a(half %x) {
  %xi = bitcast half %x to i16
  %res = xor i16 %xi, -1
  %resf = bitcast i16 %res to half
  ret half %resf
}

; CHECK-LABEL: f16_not_b:
; CHECK:      add $m1, $m15, -1
; CHECK-NEXT: xor $m0, $m0, $m1
; CHECK-NEXT: br $m10
define half @f16_not_b(half %x) {
  %xi = bitcast half %x to i16
  %res = xor i16 -1, %xi
  %resf = bitcast i16 %res to half
  ret half %resf
}

; CHECK-LABEL: f16_and_both_cast:
; CHECK:      and $m0, $m0, $m1
; CHECK-NEXT: br $m10
define half @f16_and_both_cast(half %x, half %y) {
  %xi = bitcast half %x to i16
  %yi = bitcast half %y to i16
  %res = and i16 %xi, %yi
  %resf = bitcast i16 %res to half
  ret half %resf
}

; CHECK-LABEL: f16_and_left_cast:
; CHECK:      and $m0, $m0, $m1
; CHECK-NEXT: br $m10
define half @f16_and_left_cast(half %x, i16 %y) {
  %xi = bitcast half %x to i16
  %res = and i16 %xi, %y
  %resf = bitcast i16 %res to half
  ret half %resf
}

; CHECK-LABEL: f16_and_right_cast:
; CHECK:      and $m0, $m0, $m1
; CHECK-NEXT: br $m10
define half @f16_and_right_cast(i16 %x, half %y) {
  %yi = bitcast half %y to i16
  %res = and i16 %x, %yi
  %resf = bitcast i16 %res to half
  ret half %resf
}

; CHECK-LABEL: f16_or_both_cast:
; CHECK:      or $m0, $m0, $m1
; CHECK-NEXT: br $m10
define half @f16_or_both_cast(half %x, half %y) {
  %xi = bitcast half %x to i16
  %yi = bitcast half %y to i16
  %res = or i16 %xi, %yi
  %resf = bitcast i16 %res to half
  ret half %resf
}

; CHECK-LABEL: f16_or_left_cast:
; CHECK:      or $m0, $m0, $m1
; CHECK-NEXT: br $m10
define half @f16_or_left_cast(half %x, i16 %y) {
  %xi = bitcast half %x to i16
  %res = or i16 %xi, %y
  %resf = bitcast i16 %res to half
  ret half %resf
}

; CHECK-LABEL: f16_or_right_cast:
; CHECK:      or $m0, $m0, $m1
; CHECK-NEXT: br $m10
define half @f16_or_right_cast(i16 %x, half %y) {
  %yi = bitcast half %y to i16
  %res = or i16 %x, %yi
  %resf = bitcast i16 %res to half
  ret half %resf
}
