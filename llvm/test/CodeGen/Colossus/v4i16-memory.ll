; RUN: llc < %s -mtriple=colossus -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -mtriple=colossus -mattr=+ipu2 | FileCheck %s

; CHECK-LABEL: test_ld_r_v4i16:
; CHECK-DAG:   ld32 $m{{[0-9]+}}, $m0, $m15, 0
; CHECK-DAG:   ld32 $m{{[0-9]+}}, $m0, $m15, 1
define <4 x i16> @test_ld_r_v4i16(<4 x i16>* %ptr) {
  %res = load <4 x i16>, <4 x i16>* %ptr, align 8
  ret <4 x i16> %res
}

; CHECK-LABEL: test_ld_rr_v4i16:
; CHECK-DAG:   ld32 $m{{[0-9]+}}, $m0, $m2, 0
; CHECK-DAG:   ld32 $m{{[0-9]+}}, $m0, $m2, 1
define <4 x i16> @test_ld_rr_v4i16(<4 x i16>* %ptr, i32 %off) {
  %ptr1 = getelementptr <4 x i16>, <4 x i16>* %ptr, i32 %off
  %res = load <4 x i16>, <4 x i16>* %ptr1, align 8
  ret <4 x i16> %res
}

; CHECK-LABEL: test_ld_rrr_v4i16:
; CHECK-DAG:   add [[R1:\$m[0-9]+]], $m0, $m1
; CHECK-DAG:   shl [[R2:\$m[0-9]+]], $m2, 3
; CHECK-DAG:   ld32 $m{{[0-9]+}}, [[R1]], [[R2]], 0
; CHECK-DAG:   ld32 $m{{[0-9]+}}, [[R1]], [[R2]], 1
define <4 x i16> @test_ld_rrr_v4i16(i32 %ptr, i32 %delta, i32 %off) {
  %ptr1 = add i32 %ptr, %delta
  %ptr2 = inttoptr i32 %ptr1 to <4 x i16>*
  %ptr3 = getelementptr <4 x i16>, <4 x i16>* %ptr2, i32 %off
  %res = load <4 x i16>, <4 x i16>* %ptr3, align 8
  ret <4 x i16> %res
}

; CHECK-LABEL: test_ld_ri_v4i16:
; CHECK-DAG:   ld32 $m{{[0-9]+}}, $m0, $m15, 4094
; CHECK-DAG:   ld32 $m{{[0-9]+}}, $m0, $m15, 4095
define <4 x i16> @test_ld_ri_v4i16(<4 x i16>* %ptr) {
  %ptr1 = getelementptr <4 x i16>, <4 x i16>* %ptr, i32 2047
  %res = load <4 x i16>, <4 x i16>* %ptr1, align 8
  ret <4 x i16> %res
}

; CHECK-LABEL: test_ld_rri_v4i16:
; CHECK-DAG:   ld32 $m{{[0-9]+}}, $m0, $m1, 4094
; CHECK-DAG:   ld32 $m{{[0-9]+}}, $m0, $m1, 4095
define <4 x i16> @test_ld_rri_v4i16(i32 %ptr, i32 %delta) {
  %ptr1 = add i32 %ptr, %delta
  %ptr2 = inttoptr i32 %ptr1 to <4 x i16>*
  %ptr3 = getelementptr <4 x i16>, <4 x i16>* %ptr2, i32 2047
  %res = load <4 x i16>, <4 x i16>* %ptr3, align 8
  ret <4 x i16> %res
}

; CHECK-LABEL: test_ld_fi_v4i16:
; CHECK-DAG:   ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK-DAG:   ld32 $m{{[0-9]+}}, $m11, $m15, 1
define <4 x i16> @test_ld_fi_v4i16() {
  %ptr = alloca <4 x i16>, i32 64
  %res = load <4 x i16>, <4 x i16>* %ptr, align 8
  ret <4 x i16> %res
}

; CHECK-LABEL: test_ld_fii_v4i16:
; CHECK-DAG:   ld32 $m{{[0-9]+}}, $m11, $m15, 4094
; CHECK-DAG:   ld32 $m{{[0-9]+}}, $m11, $m15, 4095
define <4 x i16> @test_ld_fii_v4i16() {
  %ptr1 = alloca <4 x i16>, i32 64
  %ptr2 = getelementptr <4 x i16>, <4 x i16>* %ptr1, i32 2047
  %res = load <4 x i16>, <4 x i16>* %ptr2, align 8
  ret <4 x i16> %res
}

; CHECK-LABEL: test_ld_fir_v4i16:
; CHECK-DAG:   add [[BASE:\$m[0-9]+]], $m11, {{[0-9]+}}
; CHECK-DAG:   shl [[OFF:\$m[0-9]+]], $m0, 3
; CHECK-DAG:   ld32 $m{{[0-9]+}}, [[BASE]], [[OFF]], 0
; CHECK-DAG:   ld32 $m{{[0-9]+}}, [[BASE]], [[OFF]], 1
define <4 x i16> @test_ld_fir_v4i16(i32 %offset) {
  %ptr1 = alloca <4 x i16>, i32 64
  %ptr2 = getelementptr <4 x i16>, <4 x i16>* %ptr1, i32 %offset
  %res = load <4 x i16>, <4 x i16>* %ptr2, align 8
  ret <4 x i16> %res
}

; CHECK-LABEL: test_st_r_v4i16:
; CHECK-DAG:   st32 $m{{[0-9]+}}, $m0, $m15, 0
; CHECK-DAG:   st32 $m{{[0-9]+}}, $m0, $m15, 1
define void @test_st_r_v4i16(<4 x i16>* %ptr, <4 x i16> %data) {
  store <4 x i16> %data, <4 x i16>*  %ptr, align 8
  ret void
}

; CHECK-LABEL: test_st_rr_v4i16:
; CHECK-DAG:   st32 $m{{[0-9]+}}, $m0, $m1, 0
; CHECK-DAG:   st32 $m{{[0-9]+}}, $m0, $m1, 1
define void @test_st_rr_v4i16(<4 x i16>* %ptr, i32 %off, <4 x i16> %data) {
  %ptr1 = getelementptr <4 x i16>, <4 x i16>* %ptr, i32 %off
  store <4 x i16> %data, <4 x i16>* %ptr1, align 8
  ret void
}

; CHECK-LABEL: test_st_rrr_v4i16:
; CHECK-DAG:   add [[R1:\$m[0-9]+]], $m0, $m1
; CHECK-DAG:   shl [[R2:\$m[0-9]+]], $m2, 3
; CHECK-DAG:   st32 $m{{[0-9]+}}, [[R1]], [[R2]], 0
; CHECK-DAG:   st32 $m{{[0-9]+}}, [[R1]], [[R2]], 1
define void @test_st_rrr_v4i16(i32 %ptr, i32 %delta, i32 %off, <4 x i16> %data) {
  %ptr1 = add i32 %ptr, %delta
  %ptr2 = inttoptr i32 %ptr1 to <4 x i16>*
  %ptr3 = getelementptr <4 x i16>, <4 x i16>* %ptr2, i32 %off
  store <4 x i16> %data, <4 x i16>* %ptr3, align 8
  ret void
}

; CHECK-LABEL: test_st_ri_v4i16:
; CHECK-DAG:   st32 $m{{[0-9]+}}, $m0, $m15, 4094
; CHECK-DAG:   st32 $m{{[0-9]+}}, $m0, $m15, 4095
define void @test_st_ri_v4i16(<4 x i16>* %ptr, <4 x i16> %data) {
  %ptr1 = getelementptr <4 x i16>, <4 x i16>* %ptr, i32 2047
  store <4 x i16> %data, <4 x i16>* %ptr1, align 8
  ret void
}

; CHECK-LABEL: test_st_rri_v4i16:
; CHECK-DAG:   st32 $m{{[0-9]+}}, $m0, $m1, 4094
; CHECK-DAG:   st32 $m{{[0-9]+}}, $m0, $m1, 4095
define void @test_st_rri_v4i16(i32 %ptr, i32 %delta, <4 x i16> %data) {
  %ptr1 = add i32 %ptr, %delta
  %ptr2 = inttoptr i32 %ptr1 to <4 x i16>*
  %ptr3 = getelementptr <4 x i16>, <4 x i16>* %ptr2, i32 2047
  store <4 x i16> %data, <4 x i16>* %ptr3, align 8
  ret void
}

; CHECK-LABEL: test_st_fi_v4i16:
; CHECK-DAG:   st32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK-DAG:   st32 $m{{[0-9]+}}, $m11, $m15, 1
define void @test_st_fi_v4i16(<4 x i16> %data) {
  %ptr = alloca <4 x i16>, i32 64
  store <4 x i16> %data, <4 x i16>*  %ptr, align 8
  ret void
}

; CHECK-LABEL: test_st_fii_v4i16:
; CHECK-DAG:   st32 $m{{[0-9]+}}, $m11, $m15, 4094
; CHECK-DAG:   st32 $m{{[0-9]+}}, $m11, $m15, 4095
define void @test_st_fii_v4i16(<4 x i16> %data) {
  %ptr1 = alloca <4 x i16>, i32 64
  %ptr2 = getelementptr <4 x i16>, <4 x i16>* %ptr1, i32 2047
  store <4 x i16> %data, <4 x i16>* %ptr2, align 8
  ret void
}

