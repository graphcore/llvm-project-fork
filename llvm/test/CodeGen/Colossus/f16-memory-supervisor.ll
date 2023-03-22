; RUN: llc < %s -mtriple=colossus -mattr=+supervisor | FileCheck %s

; CHECK-LABEL: test_ld_r_f16:
; CHECK:       ldz16 $m0, $m0, $m15, 0
; CHECK-NEXT:  br $m10
define half @test_ld_r_f16(half* %ptr) {
  %res = load half, half* %ptr, align 2
  ret half %res
}

; CHECK-LABEL: test_ld_rr_f16:
; CHECK:       ldz16 $m0, $m0, $m15, $m1
; CHECK-NEXT:  br $m10
define half @test_ld_rr_f16(half* %ptr, i32 %off) {
  %ptr1 = getelementptr half, half* %ptr, i32 %off
  %res = load half, half* %ptr1, align 2
  ret half %res
}

; CHECK-LABEL: test_ld_rrr_f16:
; CHECK:       ldz16 $m0, $m0, $m1, $m2
; CHECK-NEXT:  br $m10
define half @test_ld_rrr_f16(i32 %ptr, i32 %delta, i32 %off) {
  %ptr1 = add i32 %ptr, %delta
  %ptr2 = inttoptr i32 %ptr1 to half*
  %ptr3 = getelementptr half, half* %ptr2, i32 %off
  %res = load half, half* %ptr3, align 2
  ret half %res
}

; CHECK-LABEL: test_ld_ri_f16:
; CHECK:       ldz16 $m0, $m0, $m15, 4095
; CHECK-NEXT:  br $m10
define half @test_ld_ri_f16(half* %ptr) {
  %ptr1 = getelementptr half, half* %ptr, i32 4095
  %res = load half, half* %ptr1, align 2
  ret half %res
}

; CHECK-LABEL: test_ld_rri_f16:
; CHECK:       ldz16 $m0, $m0, $m1, 4095
; CHECK-NEXT:  br $m10
define half @test_ld_rri_f16(i32 %ptr, i32 %delta) {
  %ptr1 = add i32 %ptr, %delta
  %ptr2 = inttoptr i32 %ptr1 to half*
  %ptr3 = getelementptr half, half* %ptr2, i32 4095
  %res = load half, half* %ptr3, align 2
  ret half %res
}

; CHECK-LABEL: test_ld_fi_f16:
; CHECK:      add $m11, $m11, -32
; CHECK-NEXT: .cfi_def_cfa_offset 32
; CHECK-NEXT: ldz16 $m0, $m11, $m15, 0
; CHECK-NEXT: add $m11, $m11, 32
; CHECK-NEXT: .cfi_def_cfa_offset 0
; CHECK-NEXT: br $m10
define half @test_ld_fi_f16() {
  %ptr = alloca half, i32 16
  %res = load half, half* %ptr, align 2
  ret half %res
}

; CHECK-LABEL: test_ld_fii_f16:
; CHECK:      add $m11, $m11, -32
; CHECK-NEXT: .cfi_def_cfa_offset 32
; CHECK-NEXT: ldz16 $m0, $m11, $m15, 4095
; CHECK-NEXT: add $m11, $m11, 32
; CHECK-NEXT: .cfi_def_cfa_offset 0
; CHECK-NEXT: br $m10
define half @test_ld_fii_f16() {
  %ptr1 = alloca half, i32 16
  %ptr2 = getelementptr half, half* %ptr1, i32 4095
  %res = load half, half* %ptr2, align 2
  ret half %res
}

; CHECK-LABEL: test_ld_fir_f16:
; CHECK-DAG:  add $m11, $m11, -32
; CHECK-NEXT: .cfi_def_cfa_offset 32
; CHECK-NEXT: add $m1, $m11, 0
; CHECK-NEXT: ldz16 $m0, $m1, $m15, $m0
; CHECK-NEXT: add $m11, $m11, 32
; CHECK-NEXT: .cfi_def_cfa_offset 0
; CHECK-NEXT: br $m10
define half @test_ld_fir_f16(i32 %offset) {
  %ptr1 = alloca half, i32 16
  %ptr2 = getelementptr half, half* %ptr1, i32 %offset
  %res = load half, half* %ptr2, align 2
  ret half %res
}

; CHECK-LABEL: test_st_r_f16:
; CHECK:      add $m11, $m11, -8
; CHECK-NEXT: .cfi_def_cfa_offset 8
; CHECK-NEXT: .cfi_offset $m10, -4
; CHECK-NEXT: st32 $m10, $m11, $m15, 1                # 4-byte Folded Spill
; CHECK-NEXT: call $m10, __st16
; CHECK-NEXT: ld32 $m10, $m11, $m15, 1                # 4-byte Folded Reload
; CHECK-NEXT: add $m11, $m11, 8
; CHECK-NEXT: .cfi_def_cfa_offset 0
; CHECK-NEXT: br $m10
define void @test_st_r_f16(half* %ptr, half %data) {
  store half %data, half*  %ptr, align 2
  ret void
}

; CHECK-LABEL: test_st_rr_f16:
; CHECK:      add $m11, $m11, -8
; CHECK-NEXT: .cfi_def_cfa_offset 8
; CHECK-NEXT: .cfi_offset $m10, -4
; CHECK-NEXT: st32 $m10, $m11, $m15, 1                # 4-byte Folded Spill
; CHECK-NEXT: shl $m1, $m1, 1
; CHECK-NEXT: add $m0, $m0, $m1
; CHECK-NEXT: mov     $m1, $m2
; CHECK-NEXT: call $m10, __st16
; CHECK-NEXT: ld32 $m10, $m11, $m15, 1                # 4-byte Folded Reload
; CHECK-NEXT: add $m11, $m11, 8
; CHECK-NEXT: .cfi_def_cfa_offset 0
; CHECK-NEXT: br $m10
define void @test_st_rr_f16(half* %ptr, i32 %off, half %data) {
  %ptr1 = getelementptr half, half* %ptr, i32 %off
  store half %data, half* %ptr1, align 2
  ret void
}

; CHECK-LABEL: test_st_rrr_f16:
; CHECK:      add $m11, $m11, -8
; CHECK-NEXT: .cfi_def_cfa_offset 8
; CHECK-NEXT: .cfi_offset $m10, -4
; CHECK-NEXT: st32 $m10, $m11, $m15, 1                # 4-byte Folded Spill
; CHECK-NEXT: add $m0, $m0, $m1
; CHECK-NEXT: shl $m1, $m2, 1
; CHECK-NEXT: add $m0, $m0, $m1
; CHECK-NEXT: mov     $m1, $m3
; CHECK-NEXT: call $m10, __st16
; CHECK-NEXT: ld32 $m10, $m11, $m15, 1                # 4-byte Folded Reload
; CHECK-NEXT: add $m11, $m11, 8
; CHECK-NEXT: .cfi_def_cfa_offset 0
; CHECK-NEXT: br $m10
define void @test_st_rrr_f16(i32 %ptr, i32 %delta, i32 %off, half %data) {
  %ptr1 = add i32 %ptr, %delta
  %ptr2 = inttoptr i32 %ptr1 to half*
  %ptr3 = getelementptr half, half* %ptr2, i32 %off
  store half %data, half* %ptr3, align 2
  ret void
}

; CHECK-LABEL: test_st_ri_f16:
; CHECK:      add $m11, $m11, -8
; CHECK-NEXT: .cfi_def_cfa_offset 8
; CHECK-NEXT: .cfi_offset $m10, -4
; CHECK-NEXT: st32 $m10, $m11, $m15, 1                # 4-byte Folded Spill
; CHECK-NEXT: add $m0, $m0, 8190
; CHECK-NEXT: call $m10, __st16
; CHECK-NEXT: ld32 $m10, $m11, $m15, 1                # 4-byte Folded Reload
; CHECK-NEXT: add $m11, $m11, 8
; CHECK-NEXT: .cfi_def_cfa_offset 0
; CHECK-NEXT: br $m10
define void @test_st_ri_f16(half* %ptr, half %data) {
  %ptr1 = getelementptr half, half* %ptr, i32 4095
  store half %data, half* %ptr1, align 2
  ret void
}

; CHECK-LABEL: test_st_rri_f16:
; CHECK:      add $m11, $m11, -8
; CHECK-NEXT: .cfi_def_cfa_offset 8
; CHECK-NEXT: .cfi_offset $m10, -4
; CHECK-NEXT: st32 $m10, $m11, $m15, 1                # 4-byte Folded Spill
; CHECK-NEXT: add $m0, $m0, $m1
; CHECK-NEXT: add $m0, $m0, 8190
; CHECK-NEXT: mov     $m1, $m2
; CHECK-NEXT: call $m10, __st16
; CHECK-NEXT: ld32 $m10, $m11, $m15, 1                # 4-byte Folded Reload
; CHECK-NEXT: add $m11, $m11, 8
; CHECK-NEXT: .cfi_def_cfa_offset 0
; CHECK-NEXT: br $m10
define void @test_st_rri_f16(i32 %ptr, i32 %delta, half %data) {
  %ptr1 = add i32 %ptr, %delta
  %ptr2 = inttoptr i32 %ptr1 to half*
  %ptr3 = getelementptr half, half* %ptr2, i32 4095
  store half %data, half* %ptr3, align 2
  ret void
}

; CHECK-LABEL: test_st_fi_f16:
; CHECK:      add $m11, $m11, -40
; CHECK-NEXT: .cfi_def_cfa_offset 40
; CHECK-NEXT: .cfi_offset $m10, -36
; CHECK-NEXT: st32 $m10, $m11, $m15, 1                # 4-byte Folded Spill
; CHECK-NEXT: mov     $m1, $m0
; CHECK-NEXT: add $m0, $m11, 8
; CHECK-NEXT: call $m10, __st16
; CHECK-NEXT: ld32 $m10, $m11, $m15, 1                # 4-byte Folded Reload
; CHECK-NEXT: add $m11, $m11, 40
; CHECK-NEXT: .cfi_def_cfa_offset 0
; CHECK-NEXT: br $m10
define void @test_st_fi_f16(half %data) {
  %ptr = alloca half, i32 16
  store half %data, half*  %ptr, align 2
  ret void
}

; CHECK-LABEL: test_st_fii_f16:
; CHECK:      add $m11, $m11, -40
 ; CHECK-NEXT: .cfi_def_cfa_offset 40
 ; CHECK-NEXT: .cfi_offset $m10, -36
 ; CHECK-NEXT: st32 $m10, $m11, $m15, 1                # 4-byte Folded Spill
 ; CHECK-NEXT: mov     $m1, $m0
 ; CHECK-NEXT: add $m0, $m11, 8
 ; CHECK-NEXT: add $m0, $m0, 8190
 ; CHECK-NEXT: call $m10, __st16
 ; CHECK-NEXT: ld32 $m10, $m11, $m15, 1                # 4-byte Folded Reload
 ; CHECK-NEXT: add $m11, $m11, 40
 ; CHECK-NEXT: .cfi_def_cfa_offset 0
 ; CHECK-NEXT: br $m10
define void @test_st_fii_f16(half %data) {
  %ptr1 = alloca half, i32 16
  %ptr2 = getelementptr half, half* %ptr1, i32 4095
  store half %data, half* %ptr2, align 2
  ret void
}

; CHECK-LABEL: test_st_fir_f16:
; CHECK:      add $m11, $m11, -40
; CHECK-NEXT: .cfi_def_cfa_offset 40
; CHECK-NEXT: .cfi_offset $m10, -36
; CHECK-NEXT: st32 $m10, $m11, $m15, 1                # 4-byte Folded Spill
; CHECK-NEXT: shl $m0, $m0, 1
; CHECK-NEXT: add $m2, $m11, 8
; CHECK-NEXT: add $m0, $m2, $m0
; CHECK-NEXT: call $m10, __st16
; CHECK-NEXT: ld32 $m10, $m11, $m15, 1                # 4-byte Folded Reload
; CHECK-NEXT: add $m11, $m11, 40
; CHECK-NEXT: .cfi_def_cfa_offset 0
; CHECK-NEXT: br $m10
define void @test_st_fir_f16(i32 %offset, half %data) {
  %ptr1 = alloca half, i32 16
  %ptr2 = getelementptr half, half* %ptr1, i32 %offset
  store half %data, half* %ptr2, align 2
  ret void
}

