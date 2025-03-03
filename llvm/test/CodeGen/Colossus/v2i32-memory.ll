; RUN: llc < %s -mtriple=colossus -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -mtriple=colossus -mattr=+ipu2 | FileCheck %s

; CHECK-LABEL: test_ld_r_v2i32:
; CHECK-DAG:   ld32 $m{{[0-9]+}}, $m0, $m15, 0
; CHECK-DAG:   ld32 $m{{[0-9]+}}, $m0, $m15, 1
define <2 x i32> @test_ld_r_v2i32(<2 x i32>* %ptr) {
  %res = load <2 x i32>, <2 x i32>* %ptr, align 8
  ret <2 x i32> %res
}

; CHECK-LABEL: test_ld_rr_v2i32:
; CHECK-DAG:   ld32 $m{{[0-9]+}}, $m0, $m2, 0
; CHECK-DAG:   ld32 $m{{[0-9]+}}, $m0, $m2, 1
define <2 x i32> @test_ld_rr_v2i32(<2 x i32>* %ptr, i32 %off) {
  %ptr1 = getelementptr <2 x i32>, <2 x i32>* %ptr, i32 %off
  %res = load <2 x i32>, <2 x i32>* %ptr1, align 8
  ret <2 x i32> %res
}

; CHECK-LABEL: test_ld_rrr_v2i32:
; CHECK-DAG:   add [[R1:\$m[0-9]+]], $m0, $m1
; CHECK-DAG:   shl [[R2:\$m[0-9]+]], $m2, 3
; CHECK-DAG:   ld32 $m{{[0-9]+}}, [[R1]], [[R2]], 0
; CHECK-DAG:   ld32 $m{{[0-9]+}}, [[R1]], [[R2]], 1
define <2 x i32> @test_ld_rrr_v2i32(i32 %ptr, i32 %delta, i32 %off) {
  %ptr1 = add i32 %ptr, %delta
  %ptr2 = inttoptr i32 %ptr1 to <2 x i32>*
  %ptr3 = getelementptr <2 x i32>, <2 x i32>* %ptr2, i32 %off
  %res = load <2 x i32>, <2 x i32>* %ptr3, align 8
  ret <2 x i32> %res
}

; CHECK-LABEL: test_ld_ri_v2i32:
; CHECK-DAG:   ld32 $m{{[0-9]+}}, $m0, $m15, 4094
; CHECK-DAG:   ld32 $m{{[0-9]+}}, $m0, $m15, 4095
define <2 x i32> @test_ld_ri_v2i32(<2 x i32>* %ptr) {
  %ptr1 = getelementptr <2 x i32>, <2 x i32>* %ptr, i32 2047
  %res = load <2 x i32>, <2 x i32>* %ptr1, align 8
  ret <2 x i32> %res
}

; CHECK-LABEL: test_ld_rri_v2i32:
; CHECK-DAG:   ld32 $m{{[0-9]+}}, $m0, $m1, 4094
; CHECK-DAG:   ld32 $m{{[0-9]+}}, $m0, $m1, 4095
define <2 x i32> @test_ld_rri_v2i32(i32 %ptr, i32 %delta) {
  %ptr1 = add i32 %ptr, %delta
  %ptr2 = inttoptr i32 %ptr1 to <2 x i32>*
  %ptr3 = getelementptr <2 x i32>, <2 x i32>* %ptr2, i32 2047
  %res = load <2 x i32>, <2 x i32>* %ptr3, align 8
  ret <2 x i32> %res
}

; CHECK-LABEL: test_ld_fi_v2i32:
; CHECK-DAG:   ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK-DAG:   ld32 $m{{[0-9]+}}, $m11, $m15, 1
define <2 x i32> @test_ld_fi_v2i32() {
  %ptr = alloca <2 x i32>, i32 64
  %res = load <2 x i32>, <2 x i32>* %ptr, align 8
  ret <2 x i32> %res
}

; CHECK-LABEL: test_ld_fii_v2i32:
; CHECK-DAG:   ld32 $m{{[0-9]+}}, $m11, $m15, 4094
; CHECK-DAG:   ld32 $m{{[0-9]+}}, $m11, $m15, 4095
define <2 x i32> @test_ld_fii_v2i32() {
  %ptr1 = alloca <2 x i32>, i32 64
  %ptr2 = getelementptr <2 x i32>, <2 x i32>* %ptr1, i32 2047
  %res = load <2 x i32>, <2 x i32>* %ptr2, align 8
  ret <2 x i32> %res
}

; CHECK-LABEL: test_ld_fir_v2i32:
; CHECK-DAG:   add [[BASE:\$m[0-9]+]], $m11, {{[0-9]+}}
; CHECK-DAG:   shl [[OFF:\$m[0-9]+]], $m0, 3
; CHECK-DAG:   ld32 $m{{[0-9]+}}, [[BASE]], [[OFF]], 0
; CHECK-DAG:   ld32 $m{{[0-9]+}}, [[BASE]], [[OFF]], 1
define <2 x i32> @test_ld_fir_v2i32(i32 %offset) {
  %ptr1 = alloca <2 x i32>, i32 64
  %ptr2 = getelementptr <2 x i32>, <2 x i32>* %ptr1, i32 %offset
  %res = load <2 x i32>, <2 x i32>* %ptr2, align 8
  ret <2 x i32> %res
}

; CHECK-LABEL: test_st_r_v2i32:
; CHECK-DAG:   st32 $m{{[0-9]+}}, $m0, $m15, 0
; CHECK-DAG:   st32 $m{{[0-9]+}}, $m0, $m15, 1
define void @test_st_r_v2i32(<2 x i32>* %ptr, <2 x i32> %data) {
  store <2 x i32> %data, <2 x i32>*  %ptr, align 8
  ret void
}

; CHECK-LABEL: test_st_rr_v2i32:
; CHECK-DAG:   st32 $m{{[0-9]+}}, $m0, $m1, 0
; CHECK-DAG:   st32 $m{{[0-9]+}}, $m0, $m1, 1
define void @test_st_rr_v2i32(<2 x i32>* %ptr, i32 %off, <2 x i32> %data) {
  %ptr1 = getelementptr <2 x i32>, <2 x i32>* %ptr, i32 %off
  store <2 x i32> %data, <2 x i32>* %ptr1, align 8
  ret void
}

; CHECK-LABEL: test_st_rrr_v2i32:
; CHECK-DAG:   add [[R1:\$m[0-9]+]], $m0, $m1
; CHECK-DAG:   shl [[R2:\$m[0-9]+]], $m2, 3
; CHECK-DAG:   st32 $m{{[0-9]+}}, [[R1]], [[R2]], 0
; CHECK-DAG:   st32 $m{{[0-9]+}}, [[R1]], [[R2]], 1
define void @test_st_rrr_v2i32(i32 %ptr, i32 %delta, i32 %off, <2 x i32> %data) {
  %ptr1 = add i32 %ptr, %delta
  %ptr2 = inttoptr i32 %ptr1 to <2 x i32>*
  %ptr3 = getelementptr <2 x i32>, <2 x i32>* %ptr2, i32 %off
  store <2 x i32> %data, <2 x i32>* %ptr3, align 8
  ret void
}

; CHECK-LABEL: test_st_ri_v2i32:
; CHECK-DAG:   st32 $m{{[0-9]+}}, $m0, $m15, 4094
; CHECK-DAG:   st32 $m{{[0-9]+}}, $m0, $m15, 4095
define void @test_st_ri_v2i32(<2 x i32>* %ptr, <2 x i32> %data) {
  %ptr1 = getelementptr <2 x i32>, <2 x i32>* %ptr, i32 2047
  store <2 x i32> %data, <2 x i32>* %ptr1, align 8
  ret void
}

; CHECK-LABEL: test_st_rri_v2i32:
; CHECK-DAG:   st32 $m{{[0-9]+}}, $m0, $m1, 4094
; CHECK-DAG:   st32 $m{{[0-9]+}}, $m0, $m1, 4095
define void @test_st_rri_v2i32(i32 %ptr, i32 %delta, <2 x i32> %data) {
  %ptr1 = add i32 %ptr, %delta
  %ptr2 = inttoptr i32 %ptr1 to <2 x i32>*
  %ptr3 = getelementptr <2 x i32>, <2 x i32>* %ptr2, i32 2047
  store <2 x i32> %data, <2 x i32>* %ptr3, align 8
  ret void
}

; CHECK-LABEL: test_st_fi_v2i32:
; CHECK-DAG:   st32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK-DAG:   st32 $m{{[0-9]+}}, $m11, $m15, 1
define void @test_st_fi_v2i32(<2 x i32> %data) {
  %ptr = alloca <2 x i32>, i32 64
  store <2 x i32> %data, <2 x i32>*  %ptr, align 8
  ret void
}

; CHECK-LABEL: test_st_fii_v2i32:
; CHECK-DAG:   st32 $m{{[0-9]+}}, $m11, $m15, 4094
; CHECK-DAG:   st32 $m{{[0-9]+}}, $m11, $m15, 4095
define void @test_st_fii_v2i32(<2 x i32> %data) {
  %ptr1 = alloca <2 x i32>, i32 64
  %ptr2 = getelementptr <2 x i32>, <2 x i32>* %ptr1, i32 2047
  store <2 x i32> %data, <2 x i32>* %ptr2, align 8
  ret void
}

