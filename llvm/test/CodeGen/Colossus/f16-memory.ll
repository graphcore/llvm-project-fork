; RUN: llc < %s -mtriple=colossus -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -mtriple=colossus -mattr=+ipu2 | FileCheck %s

; CHECK-LABEL: test_ld_r_f16:
; CHECK:       ldb16 $a0, $m0, $m15, 0
; CHECK-NEXT:  br $m10
define half @test_ld_r_f16(half* %ptr) {
  %res = load half, half* %ptr, align 2
  ret half %res
}

; CHECK-LABEL: test_ld_rr_f16:
; CHECK:       ldb16 $a0, $m0, $m15, $m1
; CHECK-NEXT:  br $m10
define half @test_ld_rr_f16(half* %ptr, i32 %off) {
  %ptr1 = getelementptr half, half* %ptr, i32 %off
  %res = load half, half* %ptr1, align 2
  ret half %res
}

; CHECK-LABEL: test_ld_rrr_f16:
; CHECK:       ldb16 $a0, $m0, $m1, $m2
; CHECK-NEXT:  br $m10
define half @test_ld_rrr_f16(i32 %ptr, i32 %delta, i32 %off) {
  %ptr1 = add i32 %ptr, %delta
  %ptr2 = inttoptr i32 %ptr1 to half*
  %ptr3 = getelementptr half, half* %ptr2, i32 %off
  %res = load half, half* %ptr3, align 2
  ret half %res
}

; CHECK-LABEL: test_ld_ri_f16:
; CHECK:       ldb16 $a0, $m0, $m15, 4095
; CHECK-NEXT:  br $m10
define half @test_ld_ri_f16(half* %ptr) {
  %ptr1 = getelementptr half, half* %ptr, i32 4095
  %res = load half, half* %ptr1, align 2
  ret half %res
}

; CHECK-LABEL: test_ld_rri_f16:
; CHECK:       ldb16 $a0, $m0, $m1, 4095
; CHECK-NEXT:  br $m10
define half @test_ld_rri_f16(i32 %ptr, i32 %delta) {
  %ptr1 = add i32 %ptr, %delta
  %ptr2 = inttoptr i32 %ptr1 to half*
  %ptr3 = getelementptr half, half* %ptr2, i32 4095
  %res = load half, half* %ptr3, align 2
  ret half %res
}

; CHECK-LABEL: test_ld_fi_f16:
; CHECK:       ldb16 $a0, $m11, $m15, 0
define half @test_ld_fi_f16() {
  %ptr = alloca half, i32 16
  %res = load half, half* %ptr, align 2
  ret half %res
}

; CHECK-LABEL: test_ld_fii_f16:
; CHECK:       ldb16 $a0, $m11, $m15, 4095
define half @test_ld_fii_f16() {
  %ptr1 = alloca half, i32 16
  %ptr2 = getelementptr half, half* %ptr1, i32 4095
  %res = load half, half* %ptr2, align 2
  ret half %res
}

; CHECK-LABEL: test_ld_fir_f16:
; CHECK-DAG:   add [[BASE:\$m[0-9]+]], $m11, 0
; CHECK:       ldb16 $a0, [[BASE]], $m15, $m0
define half @test_ld_fir_f16(i32 %offset) {
  %ptr1 = alloca half, i32 16
  %ptr2 = getelementptr half, half* %ptr1, i32 %offset
  %res = load half, half* %ptr2, align 2
  ret half %res
}

; CHECK-LABEL: test_st_r_f16:
; CHECK:       call $m10, __st16f
define void @test_st_r_f16(half* %ptr, half %data) {
  store half %data, half*  %ptr, align 2
  ret void
}

; CHECK-LABEL: test_st_rr_f16:
; CHECK:       call $m10, __st16f
define void @test_st_rr_f16(half* %ptr, i32 %off, half %data) {
  %ptr1 = getelementptr half, half* %ptr, i32 %off
  store half %data, half* %ptr1, align 2
  ret void
}

; CHECK-LABEL: test_st_rrr_f16:
; CHECK:       call $m10, __st16f
define void @test_st_rrr_f16(i32 %ptr, i32 %delta, i32 %off, half %data) {
  %ptr1 = add i32 %ptr, %delta
  %ptr2 = inttoptr i32 %ptr1 to half*
  %ptr3 = getelementptr half, half* %ptr2, i32 %off
  store half %data, half* %ptr3, align 2
  ret void
}

; CHECK-LABEL: test_st_ri_f16:
; CHECK:       call $m10, __st16f
define void @test_st_ri_f16(half* %ptr, half %data) {
  %ptr1 = getelementptr half, half* %ptr, i32 4095
  store half %data, half* %ptr1, align 2
  ret void
}

; CHECK-LABEL: test_st_rri_f16:
; CHECK:       call $m10, __st16f
define void @test_st_rri_f16(i32 %ptr, i32 %delta, half %data) {
  %ptr1 = add i32 %ptr, %delta
  %ptr2 = inttoptr i32 %ptr1 to half*
  %ptr3 = getelementptr half, half* %ptr2, i32 4095
  store half %data, half* %ptr3, align 2
  ret void
}

; CHECK-LABEL: test_st_fi_f16:
; CHECK:       call $m10, __st16f
define void @test_st_fi_f16(half %data) {
  %ptr = alloca half, i32 16
  store half %data, half*  %ptr, align 2
  ret void
}

; CHECK-LABEL: test_st_fii_f16:
; CHECK:       call $m10, __st16f
define void @test_st_fii_f16(half %data) {
  %ptr1 = alloca half, i32 16
  %ptr2 = getelementptr half, half* %ptr1, i32 4095
  store half %data, half* %ptr2, align 2
  ret void
}

; CHECK-LABEL: test_st_fir_f16:
; CHECK-DAG:   add [[BASE:\$m[0-9]+]], $m11, {{[0-9]+}}
; CHECK:       call $m10, __st16f
define void @test_st_fir_f16(i32 %offset, half %data) {
  %ptr1 = alloca half, i32 16
  %ptr2 = getelementptr half, half* %ptr1, i32 %offset
  store half %data, half* %ptr2, align 2
  ret void
}

