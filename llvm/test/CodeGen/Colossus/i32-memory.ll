; RUN: llc < %s -mtriple=colossus -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -mtriple=colossus -mattr=+ipu2 | FileCheck %s

; CHECK-LABEL: test_ld_r_i32:
; CHECK:       ld32 $m0, $m0, $m15, 0
; CHECK-NEXT:  br $m10
define i32 @test_ld_r_i32(i32* %ptr) {
  %res = load i32, i32* %ptr, align 4
  ret i32 %res
}

; CHECK-LABEL: test_ld_rr_i32:
; CHECK:       ld32 $m0, $m0, $m15, $m1
; CHECK-NEXT:  br $m10
define i32 @test_ld_rr_i32(i32* %ptr, i32 %off) {
  %ptr1 = getelementptr i32, i32* %ptr, i32 %off
  %res = load i32, i32* %ptr1, align 4
  ret i32 %res
}

; CHECK-LABEL: test_ld_rrr_i32:
; CHECK:       ld32 $m0, $m0, $m1, $m2
; CHECK-NEXT:  br $m10
define i32 @test_ld_rrr_i32(i32 %ptr, i32 %delta, i32 %off) {
  %ptr1 = add i32 %ptr, %delta
  %ptr2 = inttoptr i32 %ptr1 to i32*
  %ptr3 = getelementptr i32, i32* %ptr2, i32 %off
  %res = load i32, i32* %ptr3, align 4
  ret i32 %res
}

; CHECK-LABEL: test_ld_ri_i32:
; CHECK:       ld32 $m0, $m0, $m15, 4095
; CHECK-NEXT:  br $m10
define i32 @test_ld_ri_i32(i32* %ptr) {
  %ptr1 = getelementptr i32, i32* %ptr, i32 4095
  %res = load i32, i32* %ptr1, align 4
  ret i32 %res
}

; CHECK-LABEL: test_ld_rri_i32:
; CHECK:       ld32 $m0, $m0, $m1, 4095
; CHECK-NEXT:  br $m10
define i32 @test_ld_rri_i32(i32 %ptr, i32 %delta) {
  %ptr1 = add i32 %ptr, %delta
  %ptr2 = inttoptr i32 %ptr1 to i32*
  %ptr3 = getelementptr i32, i32* %ptr2, i32 4095
  %res = load i32, i32* %ptr3, align 4
  ret i32 %res
}

; CHECK-LABEL: test_ld_fi_i32:
; CHECK:       ld32 $m0, $m11, $m15, 0
define i32 @test_ld_fi_i32() {
  %ptr = alloca i32, i32 32
  %res = load i32, i32* %ptr, align 4
  ret i32 %res
}

; CHECK-LABEL: test_ld_fii_i32:
; CHECK:       ld32 $m0, $m11, $m15, 4095
define i32 @test_ld_fii_i32() {
  %ptr1 = alloca i32, i32 32
  %ptr2 = getelementptr i32, i32* %ptr1, i32 4095
  %res = load i32, i32* %ptr2, align 4
  ret i32 %res
}

; CHECK-LABEL: test_ld_fir_i32:
; CHECK-DAG:   add [[BASE:\$m[0-9]+]], $m11, 0
; CHECK:       ld32 $m0, [[BASE]], $m15, $m0
define i32 @test_ld_fir_i32(i32 %offset) {
  %ptr1 = alloca i32, i32 32
  %ptr2 = getelementptr i32, i32* %ptr1, i32 %offset
  %res = load i32, i32* %ptr2, align 4
  ret i32 %res
}

; CHECK-LABEL: test_st_r_i32:
; CHECK:       st32 $m{{[0-9]+}}, $m0, $m15, 0
; CHECK-NEXT:  br $m10
define void @test_st_r_i32(i32* %ptr, i32 %data) {
  store i32 %data, i32*  %ptr, align 4
  ret void
}

; CHECK-LABEL: test_st_rr_i32:
; CHECK:       stm32 $m2, $m0, $m1
; CHECK-NEXT:  br $m10
define void @test_st_rr_i32(i32* %ptr, i32 %off, i32 %data) {
  %ptr1 = getelementptr i32, i32* %ptr, i32 %off
  store i32 %data, i32* %ptr1, align 4
  ret void
}

; CHECK-LABEL: test_st_rrr_i32:
; CHECK:       add $m0, $m0, $m1
; CHECK-NEXT:  stm32 $m3, $m0, $m2
; CHECK-NEXT:  br $m10
define void @test_st_rrr_i32(i32 %ptr, i32 %delta, i32 %off, i32 %data) {
  %ptr1 = add i32 %ptr, %delta
  %ptr2 = inttoptr i32 %ptr1 to i32*
  %ptr3 = getelementptr i32, i32* %ptr2, i32 %off
  store i32 %data, i32* %ptr3, align 4
  ret void
}

; CHECK-LABEL: test_st_ri_i32:
; CHECK:       st32 $m{{[0-9]+}}, $m0, $m15, 4095
; CHECK-NEXT:  br $m10
define void @test_st_ri_i32(i32* %ptr, i32 %data) {
  %ptr1 = getelementptr i32, i32* %ptr, i32 4095
  store i32 %data, i32* %ptr1, align 4
  ret void
}

; CHECK-LABEL: test_st_rri_i32:
; CHECK:       st32 $m{{[0-9]+}}, $m0, $m1, 4095
; CHECK-NEXT:  br $m10
define void @test_st_rri_i32(i32 %ptr, i32 %delta, i32 %data) {
  %ptr1 = add i32 %ptr, %delta
  %ptr2 = inttoptr i32 %ptr1 to i32*
  %ptr3 = getelementptr i32, i32* %ptr2, i32 4095
  store i32 %data, i32* %ptr3, align 4
  ret void
}

; CHECK-LABEL: test_st_fi_i32:
; CHECK:       st32 $m{{[0-9]+}}, $m11, $m15, 0
define void @test_st_fi_i32(i32 %data) {
  %ptr = alloca i32, i32 32
  store i32 %data, i32*  %ptr, align 4
  ret void
}

; CHECK-LABEL: test_st_fii_i32:
; CHECK:       st32 $m{{[0-9]+}}, $m11, $m15, 4095
define void @test_st_fii_i32(i32 %data) {
  %ptr1 = alloca i32, i32 32
  %ptr2 = getelementptr i32, i32* %ptr1, i32 4095
  store i32 %data, i32* %ptr2, align 4
  ret void
}

; CHECK-LABEL: test_st_fir_i32:
; CHECK-DAG:   add [[BASE:\$m[0-9]+]], $m11, {{[0-9]+}}
; CHECK:       stm32 $m{{[0-9]+}}, [[BASE]], $m0
define void @test_st_fir_i32(i32 %offset, i32 %data) {
  %ptr1 = alloca i32, i32 32
  %ptr2 = getelementptr i32, i32* %ptr1, i32 %offset
  store i32 %data, i32* %ptr2, align 4
  ret void
}

