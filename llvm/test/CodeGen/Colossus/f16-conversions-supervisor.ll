; RUN: llc < %s -march=colossus -mattr=\+supervisor,+ipu1 | FileCheck %s
; RUN: llc < %s -march=colossus -mattr=\+supervisor,+ipu2 | FileCheck %s

; CHECK-LABEL: load_store:
; CHECK:      add $m11, $m11, -8
; CHECK-NEXT: .cfi_def_cfa_offset 8
; CHECK-NEXT: .cfi_offset $m10, -4
; CHECK-NEXT: st32 $m10, $m11, $m15, 1                # 4-byte Folded Spill
; CHECK-NEXT: mov     $m2, $m1
; CHECK-NEXT: ldz16 $m1, $m0, $m15, 0
; CHECK-NEXT: mov     $m0, $m2
; CHECK-NEXT: call $m10, __st16
; CHECK-NEXT: ld32 $m10, $m11, $m15, 1                # 4-byte Folded Reload
; CHECK-NEXT: add $m11, $m11, 8
; CHECK-NEXT: .cfi_def_cfa_offset 0
; CHECK-NEXT: br $m10
define void @load_store(half* %in, half* %out) {
  %val = load half, half* %in
  store half %val, half* %out
  ret void
}

; CHECK-LABEL: from_si32:
; CHECK:      add $m11, $m11, -8
; CHECK-NEXT: .cfi_def_cfa_offset 8
; CHECK-NEXT: .cfi_offset $m10, -4
; CHECK-NEXT: .cfi_offset $m7, -8
; CHECK-NEXT: st32 $m10, $m11, $m15, 1                # 4-byte Folded Spill
; CHECK-NEXT: st32 $m7, $m11, $m15, 0                 # 4-byte Folded Spill
; CHECK-NEXT: mov     $m7, $m1
; CHECK-NEXT: call $m10, __floatsisf
; CHECK-NEXT: call $m10, __gnu_f2h_ieee
; CHECK-NEXT: mov     $m1, $m0
; CHECK-NEXT: mov     $m0, $m7
; CHECK-NEXT: call $m10, __st16
; CHECK-NEXT: ld32 $m7, $m11, $m15, 0                 # 4-byte Folded Reload
; CHECK-NEXT: ld32 $m10, $m11, $m15, 1                # 4-byte Folded Reload
; CHECK-NEXT: add $m11, $m11, 8
; CHECK-NEXT: .cfi_def_cfa_offset 0
; CHECK-NEXT: br $m10
define void @from_si32(i32 %val, half* %addr) {
  %res = sitofp i32 %val to half
  store half %res, half *%addr
  ret void
}


; CHECK-LABEL: from_ui32:
; CHECK:      add $m11, $m11, -8
; CHECK-NEXT: .cfi_def_cfa_offset 8
; CHECK-NEXT: .cfi_offset $m10, -4
; CHECK-NEXT: .cfi_offset $m7, -8
; CHECK-NEXT: st32 $m10, $m11, $m15, 1                # 4-byte Folded Spill
; CHECK-NEXT: st32 $m7, $m11, $m15, 0                 # 4-byte Folded Spill
; CHECK-NEXT: mov     $m7, $m1
; CHECK-NEXT: call $m10, __floatunsisf
; CHECK-NEXT: call $m10, __gnu_f2h_ieee
; CHECK-NEXT: mov     $m1, $m0
; CHECK-NEXT: mov     $m0, $m7
; CHECK-NEXT: call $m10, __st16
; CHECK-NEXT: ld32 $m7, $m11, $m15, 0                 # 4-byte Folded Reload
; CHECK-NEXT: ld32 $m10, $m11, $m15, 1                # 4-byte Folded Reload
; CHECK-NEXT: add $m11, $m11, 8
; CHECK-NEXT: .cfi_def_cfa_offset 0
; CHECK-NEXT: br $m10
define void @from_ui32(i32 %val, half* %addr) {
  %res = uitofp i32 %val to half
  store half %res, half *%addr
  ret void
}

; CHECK-LABEL: to_si32:
; CHECK:      add $m11, $m11, -8
; CHECK-NEXT: .cfi_def_cfa_offset 8
; CHECK-NEXT: .cfi_offset $m10, -4
; CHECK-NEXT: st32 $m10, $m11, $m15, 1                # 4-byte Folded Spill
; CHECK-NEXT: sort4x16lo $m0, $m0, $m15
; CHECK-NEXT: call $m10, __gnu_h2f_ieee
; CHECK-NEXT: call $m10, __fixsfsi
; CHECK-NEXT: ld32 $m10, $m11, $m15, 1                # 4-byte Folded Reload
; CHECK-NEXT: add $m11, $m11, 8
; CHECK-NEXT: .cfi_def_cfa_offset 0
; CHECK-NEXT: br $m10
define i32 @to_si32(half %val) {
  %res = fptosi half %val to i32
  ret i32 %res
}

; CHECK-LABEL: to_ui32:
; CHECK:      add $m11, $m11, -8
; CHECK-NEXT: .cfi_def_cfa_offset 8
; CHECK-NEXT: .cfi_offset $m10, -4
; CHECK-NEXT: st32 $m10, $m11, $m15, 1                # 4-byte Folded Spill
; CHECK-NEXT: sort4x16lo $m0, $m0, $m15
; CHECK-NEXT: call $m10, __gnu_h2f_ieee
; CHECK-NEXT: call $m10, __fixunssfsi
; CHECK-NEXT: ld32 $m10, $m11, $m15, 1                # 4-byte Folded Reload
; CHECK-NEXT: add $m11, $m11, 8
; CHECK-NEXT: .cfi_def_cfa_offset 0
; CHECK-NEXT: br $m10
define i32 @to_ui32(half %val) {
  %res = fptoui half %val to i32
  ret i32 %res
}

; CHECK-LABEL: f32_to_v2f16:
; CHECK:      add $m11, $m11, -8
; CHECK-NEXT: .cfi_def_cfa_offset 8
; CHECK-NEXT: .cfi_offset $m10, -4
; CHECK-NEXT: st32 $m10, $m11, $m15, 1                # 4-byte Folded Spill
; CHECK-NEXT: call $m10, __gnu_f2h_ieee
; CHECK-NEXT: sort4x16lo $m0, $m0, $m15
; CHECK-NEXT: mov     $m1, $m0
; CHECK-NEXT: ld32 $m10, $m11, $m15, 1                # 4-byte Folded Reload
; CHECK-NEXT: add $m11, $m11, 8
; CHECK-NEXT: .cfi_def_cfa_offset 0
; CHECK-NEXT: br $m10
define <2 x half> @f32_to_v2f16(float %x) {
  %h = fptrunc float %x to half
  %v0 = insertelement <2 x half> undef, half %h, i32 0
  %v1 = insertelement <2 x half> %v0, half %h, i32 1
  ret <2 x half> %v1
}

; CHECK-LABEL: f32_to_v2f16_with_broadcast:
; CHECK:      add $m11, $m11, -16
; CHECK-NEXT: .cfi_def_cfa_offset 16
; CHECK-NEXT: .cfi_offset $m8, -4
; CHECK-NEXT: .cfi_offset $m9, -8
; CHECK-NEXT: .cfi_offset $m10, -12
; CHECK-NEXT: .cfi_offset $m7, -16
; CHECK-NEXT: st32 $m8, $m11, $m15, 3                 # 4-byte Folded Spill
; CHECK-NEXT: st32 $m9, $m11, $m15, 2                 # 4-byte Folded Spill
; CHECK-NEXT: st32 $m10, $m11, $m15, 1                # 4-byte Folded Spill
; CHECK-NEXT: st32 $m7, $m11, $m15, 0                 # 4-byte Folded Spill
; CHECK-NEXT: mov	$m7, $m1
; CHECK-NEXT: call $m10, __gnu_f2h_ieee
; CHECK-NEXT: sort4x16lo $m9, $m7, $m7
; CHECK-NEXT: shr $m7, $m9, 16
; CHECK-NEXT: sort4x16lo $m0, $m0, $m15
; CHECK-NEXT: call $m10, __gnu_h2f_ieee
; CHECK-NEXT: mov	$m8, $m0
; CHECK-NEXT: sort4x16lo $m0, $m9, $m15
; CHECK-NEXT: call $m10, __gnu_h2f_ieee
; CHECK-NEXT: mov	$m1, $m0
; CHECK-NEXT: mov	$m0, $m8
; CHECK-NEXT: call $m10, __addsf3
; CHECK-NEXT: call $m10, __gnu_f2h_ieee
; CHECK-NEXT: sort4x16lo $m9, $m0, $m15
; CHECK-NEXT: mov	$m0, $m7
; CHECK-NEXT: call $m10, __gnu_h2f_ieee
; CHECK-NEXT: mov	$m1, $m0
; CHECK-NEXT: mov	$m0, $m8
; CHECK-NEXT: call $m10, __addsf3
; CHECK-NEXT: call $m10, __gnu_f2h_ieee
; CHECK-NEXT: shl $m1, $m0, 16
; CHECK-NEXT: or $m2, $m9, $m1
; CHECK-NEXT: sort4x16lo $m1, $m0, $m15
; CHECK-NEXT: mov	$m0, $m2
; CHECK-NEXT: ld32 $m7, $m11, $m15, 0                 # 4-byte Folded Reload
; CHECK-NEXT: ld32 $m10, $m11, $m15, 1                # 4-byte Folded Reload
; CHECK-NEXT: ld32 $m9, $m11, $m15, 2                 # 4-byte Folded Reload
; CHECK-NEXT: ld32 $m8, $m11, $m15, 3                 # 4-byte Folded Reload
; CHECK-NEXT: add $m11, $m11, 16
; CHECK-NEXT: .cfi_def_cfa_offset 0
; CHECK-NEXT: br $m10
define <2 x half> @f32_to_v2f16_with_broadcast(float %x, half %y) {
  %h = fptrunc float %x to half
  %xt = insertelement <2 x half> undef, half %h, i32 0
  %x2 = insertelement <2 x half> %xt, half %h, i32 1
  %yt = insertelement <2 x half> undef, half %y, i32 0
  %y2 = insertelement <2 x half> %yt, half %y, i32 1
  %res = fadd <2 x half> %x2, %y2
  ret <2 x half> %res
}

; CHECK-LABEL: low_v2f16_to_f32:
; CHECK:      add $m11, $m11, -8
; CHECK-NEXT: .cfi_def_cfa_offset 8
; CHECK-NEXT: .cfi_offset $m10, -4
; CHECK-NEXT: st32 $m10, $m11, $m15, 1                # 4-byte Folded Spill
; CHECK-NEXT: sort4x16lo $m0, $m0, $m15
; CHECK-NEXT: call $m10, __gnu_h2f_ieee
; CHECK-NEXT: ld32 $m10, $m11, $m15, 1                # 4-byte Folded Reload
; CHECK-NEXT: add $m11, $m11, 8
; CHECK-NEXT: .cfi_def_cfa_offset 0
; CHECK-NEXT: br $m10
define float @low_v2f16_to_f32(<2 x half> %x) {
  %lo = extractelement <2 x half> %x, i32 0
  %r = fpext half %lo to float
  ret float %r
}

declare float @llvm.experimental.constrained.fpext.f32.f16(half %src, metadata)

; CHECK-LABEL: strict_low_v2f16_to_f32:
; CHECK:      add $m11, $m11, -8
; CHECK-NEXT: .cfi_def_cfa_offset 8
; CHECK-NEXT: .cfi_offset $m10, -4
; CHECK-NEXT: st32 $m10, $m11, $m15, 1                # 4-byte Folded Spill
; CHECK-NEXT: sort4x16lo $m0, $m0, $m15
; CHECK-NEXT: call $m10, __gnu_h2f_ieee
; CHECK-NEXT: ld32 $m10, $m11, $m15, 1                # 4-byte Folded Reload
; CHECK-NEXT: add $m11, $m11, 8
; CHECK-NEXT: .cfi_def_cfa_offset 0
; CHECK-NEXT: br $m10
define float @strict_low_v2f16_to_f32(<2 x half> %x) {
  %lo = extractelement <2 x half> %x, i32 0
  %r = tail call float @llvm.experimental.constrained.fpext.f32.f16(half %lo, metadata !"fpexcept.strict")
  ret float %r
}

; CHECK-LABEL: high_v2f16_to_f32:
; CHECK:      add $m11, $m11, -8
; CHECK-NEXT: .cfi_def_cfa_offset 8
; CHECK-NEXT: .cfi_offset $m10, -4
; CHECK-NEXT: st32 $m10, $m11, $m15, 1                # 4-byte Folded Spill
; CHECK-NEXT: sort4x16lo $m0, $m1, $m15
; CHECK-NEXT: call $m10, __gnu_h2f_ieee
; CHECK-NEXT: ld32 $m10, $m11, $m15, 1                # 4-byte Folded Reload
; CHECK-NEXT: add $m11, $m11, 8
; CHECK-NEXT: .cfi_def_cfa_offset 0
; CHECK-NEXT: br $m10
define float @high_v2f16_to_f32(<2 x half> %x) {
  %hi = extractelement <2 x half> %x, i32 1
  %r = fpext half %hi to float
  ret float %r
}

; CHECK-LABEL: strict_high_v2f16_to_f32:
; CHECK:      add $m11, $m11, -8
; CHECK-NEXT: .cfi_def_cfa_offset 8
; CHECK-NEXT: .cfi_offset $m10, -4
; CHECK-NEXT: st32 $m10, $m11, $m15, 1                # 4-byte Folded Spill
; CHECK-NEXT: sort4x16lo $m0, $m1, $m15
; CHECK-NEXT: call $m10, __gnu_h2f_ieee
; CHECK-NEXT: ld32 $m10, $m11, $m15, 1                # 4-byte Folded Reload
; CHECK-NEXT: add $m11, $m11, 8
; CHECK-NEXT: .cfi_def_cfa_offset 0
; CHECK-NEXT: br $m10
define float @strict_high_v2f16_to_f32(<2 x half> %x) {
  %hi = extractelement <2 x half> %x, i32 1
  %r = tail call float @llvm.experimental.constrained.fpext.f32.f16(half %hi, metadata !"fpexcept.strict")
  ret float %r
}
