; RUN: llc < %s -mtriple=colossus -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -mtriple=colossus -mattr=+ipu2 | FileCheck %s

; CHECK-LABEL: test_ld_r_v2i16:
; CHECK:       ld32 $m0, $m0, $m15, 0
; CHECK-NEXT:  br $m10
define <2 x i16> @test_ld_r_v2i16(<2 x i16>* %ptr) {
  %res = load <2 x i16>, <2 x i16>* %ptr, align 4
  ret <2 x i16> %res
}

; CHECK-LABEL: test_ld_rr_v2i16:
; CHECK:       ld32 $m0, $m0, $m15, $m1
; CHECK-NEXT:  br $m10
define <2 x i16> @test_ld_rr_v2i16(<2 x i16>* %ptr, i32 %off) {
  %ptr1 = getelementptr <2 x i16>, <2 x i16>* %ptr, i32 %off
  %res = load <2 x i16>, <2 x i16>* %ptr1, align 4
  ret <2 x i16> %res
}

; CHECK-LABEL: test_ld_rrr_v2i16:
; CHECK:       ld32 $m0, $m0, $m1, $m2
; CHECK-NEXT:  br $m10
define <2 x i16> @test_ld_rrr_v2i16(i32 %ptr, i32 %delta, i32 %off) {
  %ptr1 = add i32 %ptr, %delta
  %ptr2 = inttoptr i32 %ptr1 to <2 x i16>*
  %ptr3 = getelementptr <2 x i16>, <2 x i16>* %ptr2, i32 %off
  %res = load <2 x i16>, <2 x i16>* %ptr3, align 4
  ret <2 x i16> %res
}

; CHECK-LABEL: test_ld_ri_v2i16:
; CHECK:       ld32 $m0, $m0, $m15, 4095
; CHECK-NEXT:  br $m10
define <2 x i16> @test_ld_ri_v2i16(<2 x i16>* %ptr) {
  %ptr1 = getelementptr <2 x i16>, <2 x i16>* %ptr, i32 4095
  %res = load <2 x i16>, <2 x i16>* %ptr1, align 4
  ret <2 x i16> %res
}

; CHECK-LABEL: test_ld_rri_v2i16:
; CHECK:       ld32 $m0, $m0, $m1, 4095
; CHECK-NEXT:  br $m10
define <2 x i16> @test_ld_rri_v2i16(i32 %ptr, i32 %delta) {
  %ptr1 = add i32 %ptr, %delta
  %ptr2 = inttoptr i32 %ptr1 to <2 x i16>*
  %ptr3 = getelementptr <2 x i16>, <2 x i16>* %ptr2, i32 4095
  %res = load <2 x i16>, <2 x i16>* %ptr3, align 4
  ret <2 x i16> %res
}

; CHECK-LABEL: test_ld_fi_v2i16:
; CHECK:       ld32 $m0, $m11, $m15, 0
define <2 x i16> @test_ld_fi_v2i16() {
  %ptr = alloca <2 x i16>, i32 32
  %res = load <2 x i16>, <2 x i16>* %ptr, align 4
  ret <2 x i16> %res
}

; CHECK-LABEL: test_ld_fii_v2i16:
; CHECK:       ld32 $m0, $m11, $m15, 4095
define <2 x i16> @test_ld_fii_v2i16() {
  %ptr1 = alloca <2 x i16>, i32 32
  %ptr2 = getelementptr <2 x i16>, <2 x i16>* %ptr1, i32 4095
  %res = load <2 x i16>, <2 x i16>* %ptr2, align 4
  ret <2 x i16> %res
}

; CHECK-LABEL: test_ld_fir_v2i16:
; CHECK-DAG:   add [[BASE:\$m[0-9]+]], $m11, 0
; CHECK:       ld32 $m0, [[BASE]], $m15, $m0
define <2 x i16> @test_ld_fir_v2i16(i32 %offset) {
  %ptr1 = alloca <2 x i16>, i32 32
  %ptr2 = getelementptr <2 x i16>, <2 x i16>* %ptr1, i32 %offset
  %res = load <2 x i16>, <2 x i16>* %ptr2, align 4
  ret <2 x i16> %res
}

; CHECK-LABEL: test_st_r_v2i16:
; CHECK:       st32 $m{{[0-9]+}}, $m0, $m15, 0
; CHECK-NEXT:  br $m10
define void @test_st_r_v2i16(<2 x i16>* %ptr, <2 x i16> %data) {
  store <2 x i16> %data, <2 x i16>*  %ptr, align 4
  ret void
}

; CHECK-LABEL: test_st_rr_v2i16:
; CHECK:       stm32 $m2, $m0, $m1
; CHECK-NEXT:  br $m10
define void @test_st_rr_v2i16(<2 x i16>* %ptr, i32 %off, <2 x i16> %data) {
  %ptr1 = getelementptr <2 x i16>, <2 x i16>* %ptr, i32 %off
  store <2 x i16> %data, <2 x i16>* %ptr1, align 4
  ret void
}

; CHECK-LABEL: test_st_rrr_v2i16:
; CHECK:       add $m0, $m0, $m1
; CHECK-NEXT:  stm32 $m3, $m0, $m2
; CHECK-NEXT:  br $m10
define void @test_st_rrr_v2i16(i32 %ptr, i32 %delta, i32 %off, <2 x i16> %data) {
  %ptr1 = add i32 %ptr, %delta
  %ptr2 = inttoptr i32 %ptr1 to <2 x i16>*
  %ptr3 = getelementptr <2 x i16>, <2 x i16>* %ptr2, i32 %off
  store <2 x i16> %data, <2 x i16>* %ptr3, align 4
  ret void
}

; CHECK-LABEL: test_st_ri_v2i16:
; CHECK:       st32 $m{{[0-9]+}}, $m0, $m15, 4095
; CHECK-NEXT:  br $m10
define void @test_st_ri_v2i16(<2 x i16>* %ptr, <2 x i16> %data) {
  %ptr1 = getelementptr <2 x i16>, <2 x i16>* %ptr, i32 4095
  store <2 x i16> %data, <2 x i16>* %ptr1, align 4
  ret void
}

; CHECK-LABEL: test_st_rri_v2i16:
; CHECK:       st32 $m{{[0-9]+}}, $m0, $m1, 4095
; CHECK-NEXT:  br $m10
define void @test_st_rri_v2i16(i32 %ptr, i32 %delta, <2 x i16> %data) {
  %ptr1 = add i32 %ptr, %delta
  %ptr2 = inttoptr i32 %ptr1 to <2 x i16>*
  %ptr3 = getelementptr <2 x i16>, <2 x i16>* %ptr2, i32 4095
  store <2 x i16> %data, <2 x i16>* %ptr3, align 4
  ret void
}

; CHECK-LABEL: test_st_fi_v2i16:
; CHECK:       st32 $m{{[0-9]+}}, $m11, $m15, 0
define void @test_st_fi_v2i16(<2 x i16> %data) {
  %ptr = alloca <2 x i16>, i32 32
  store <2 x i16> %data, <2 x i16>*  %ptr, align 4
  ret void
}

; CHECK-LABEL: test_st_fii_v2i16:
; CHECK:       st32 $m{{[0-9]+}}, $m11, $m15, 4095
define void @test_st_fii_v2i16(<2 x i16> %data) {
  %ptr1 = alloca <2 x i16>, i32 32
  %ptr2 = getelementptr <2 x i16>, <2 x i16>* %ptr1, i32 4095
  store <2 x i16> %data, <2 x i16>* %ptr2, align 4
  ret void
}

; CHECK-LABEL: test_st_fir_v2i16:
; CHECK-DAG:   add [[BASE:\$m[0-9]+]], $m11, {{[0-9]+}}
; CHECK:       stm32 $m{{[0-9]+}}, [[BASE]], $m0
define void @test_st_fir_v2i16(i32 %offset, <2 x i16> %data) {
  %ptr1 = alloca <2 x i16>, i32 32
  %ptr2 = getelementptr <2 x i16>, <2 x i16>* %ptr1, i32 %offset
  store <2 x i16> %data, <2 x i16>* %ptr2, align 4
  ret void
}

