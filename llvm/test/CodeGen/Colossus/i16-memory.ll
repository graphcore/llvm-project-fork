; RUN: llc < %s -mtriple=colossus -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -mtriple=colossus -mattr=+ipu2 | FileCheck %s

; CHECK-LABEL: test_ld_r_i16:
; CHECK:       ldz16 $m0, $m0, $m15, 0
; CHECK-NEXT:  br $m10
define i16 @test_ld_r_i16(i16* %ptr) {
  %res = load i16, i16* %ptr, align 2
  ret i16 %res
}

; CHECK-LABEL: test_ld_rr_i16:
; CHECK:       ldz16 $m0, $m0, $m15, $m1
; CHECK-NEXT:  br $m10
define i16 @test_ld_rr_i16(i16* %ptr, i32 %off) {
  %ptr1 = getelementptr i16, i16* %ptr, i32 %off
  %res = load i16, i16* %ptr1, align 2
  ret i16 %res
}

; CHECK-LABEL: test_ld_rrr_i16:
; CHECK:       ldz16 $m0, $m0, $m1, $m2
; CHECK-NEXT:  br $m10
define i16 @test_ld_rrr_i16(i32 %ptr, i32 %delta, i32 %off) {
  %ptr1 = add i32 %ptr, %delta
  %ptr2 = inttoptr i32 %ptr1 to i16*
  %ptr3 = getelementptr i16, i16* %ptr2, i32 %off
  %res = load i16, i16* %ptr3, align 2
  ret i16 %res
}

; CHECK-LABEL: test_ld_ri_i16:
; CHECK:       ldz16 $m0, $m0, $m15, 4095
; CHECK-NEXT:  br $m10
define i16 @test_ld_ri_i16(i16* %ptr) {
  %ptr1 = getelementptr i16, i16* %ptr, i32 4095
  %res = load i16, i16* %ptr1, align 2
  ret i16 %res
}

; CHECK-LABEL: test_ld_rri_i16:
; CHECK:       ldz16 $m0, $m0, $m1, 4095
; CHECK-NEXT:  br $m10
define i16 @test_ld_rri_i16(i32 %ptr, i32 %delta) {
  %ptr1 = add i32 %ptr, %delta
  %ptr2 = inttoptr i32 %ptr1 to i16*
  %ptr3 = getelementptr i16, i16* %ptr2, i32 4095
  %res = load i16, i16* %ptr3, align 2
  ret i16 %res
}

; CHECK-LABEL: test_ld_fi_i16:
; CHECK:       ldz16 $m0, $m11, $m15, 0
define i16 @test_ld_fi_i16() {
  %ptr = alloca i16, i32 16
  %res = load i16, i16* %ptr, align 2
  ret i16 %res
}

; CHECK-LABEL: test_ld_fii_i16:
; CHECK:       ldz16 $m0, $m11, $m15, 4095
define i16 @test_ld_fii_i16() {
  %ptr1 = alloca i16, i32 16
  %ptr2 = getelementptr i16, i16* %ptr1, i32 4095
  %res = load i16, i16* %ptr2, align 2
  ret i16 %res
}

; CHECK-LABEL: test_ld_fir_i16:
; CHECK-DAG:   add [[BASE:\$m[0-9]+]], $m11, 0
; CHECK:       ldz16 $m0, [[BASE]], $m15, $m0
define i16 @test_ld_fir_i16(i32 %offset) {
  %ptr1 = alloca i16, i32 16
  %ptr2 = getelementptr i16, i16* %ptr1, i32 %offset
  %res = load i16, i16* %ptr2, align 2
  ret i16 %res
}

; CHECK-LABEL: test_st_r_i16:
; CHECK:       call $m10, __st16
define void @test_st_r_i16(i16* %ptr, i16 %data) {
  store i16 %data, i16*  %ptr, align 2
  ret void
}

; CHECK-LABEL: test_st_rr_i16:
; CHECK:       call $m10, __st16
define void @test_st_rr_i16(i16* %ptr, i32 %off, i16 %data) {
  %ptr1 = getelementptr i16, i16* %ptr, i32 %off
  store i16 %data, i16* %ptr1, align 2
  ret void
}

; CHECK-LABEL: test_st_rrr_i16:
; CHECK:       call $m10, __st16
define void @test_st_rrr_i16(i32 %ptr, i32 %delta, i32 %off, i16 %data) {
  %ptr1 = add i32 %ptr, %delta
  %ptr2 = inttoptr i32 %ptr1 to i16*
  %ptr3 = getelementptr i16, i16* %ptr2, i32 %off
  store i16 %data, i16* %ptr3, align 2
  ret void
}

; CHECK-LABEL: test_st_ri_i16:
; CHECK:       call $m10, __st16
define void @test_st_ri_i16(i16* %ptr, i16 %data) {
  %ptr1 = getelementptr i16, i16* %ptr, i32 4095
  store i16 %data, i16* %ptr1, align 2
  ret void
}

; CHECK-LABEL: test_st_rri_i16:
; CHECK:       call $m10, __st16
define void @test_st_rri_i16(i32 %ptr, i32 %delta, i16 %data) {
  %ptr1 = add i32 %ptr, %delta
  %ptr2 = inttoptr i32 %ptr1 to i16*
  %ptr3 = getelementptr i16, i16* %ptr2, i32 4095
  store i16 %data, i16* %ptr3, align 2
  ret void
}

; CHECK-LABEL: test_st_fi_i16:
; CHECK:       call $m10, __st16
define void @test_st_fi_i16(i16 %data) {
  %ptr = alloca i16, i32 16
  store i16 %data, i16*  %ptr, align 2
  ret void
}

; CHECK-LABEL: test_st_fii_i16:
; CHECK:       call $m10, __st16
define void @test_st_fii_i16(i16 %data) {
  %ptr1 = alloca i16, i32 16
  %ptr2 = getelementptr i16, i16* %ptr1, i32 4095
  store i16 %data, i16* %ptr2, align 2
  ret void
}

; CHECK-LABEL: test_st_fir_i16:
; CHECK-DAG:   add [[BASE:\$m[0-9]+]], $m11, {{[0-9]+}}
; CHECK:       call $m10, __st16
define void @test_st_fir_i16(i32 %offset, i16 %data) {
  %ptr1 = alloca i16, i32 16
  %ptr2 = getelementptr i16, i16* %ptr1, i32 %offset
  store i16 %data, i16* %ptr2, align 2
  ret void
}

