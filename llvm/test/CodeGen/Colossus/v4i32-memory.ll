; RUN: llc < %s -mtriple=colossus -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -mtriple=colossus -mattr=+ipu2 | FileCheck %s

; CHECK-LABEL: test_ld_r_v4i32:
; CHECK-DAG:   ld32 $m{{[0-9]+}}, $m0, $m15, 0
; CHECK-DAG:   ld32 $m{{[0-9]+}}, $m0, $m15, 1
; CHECK-DAG:   ld32 $m{{[0-9]+}}, $m0, $m15, 2
; CHECK-DAG:   ld32 $m{{[0-9]+}}, $m0, $m15, 3
define <4 x i32> @test_ld_r_v4i32(<4 x i32>* %ptr) {
  %res = load <4 x i32>, <4 x i32>* %ptr, align 16
  ret <4 x i32> %res
}

; CHECK-LABEL: test_ld_rr_v4i32:
; CHECK-DAG:   ld32 $m{{[0-9]+}}, $m0, $m1, 0
; CHECK-DAG:   ld32 $m{{[0-9]+}}, $m0, $m1, 1
; CHECK-DAG:   ld32 $m{{[0-9]+}}, $m0, $m1, 2
; CHECK-DAG:   ld32 $m{{[0-9]+}}, $m0, $m1, 3
define <4 x i32> @test_ld_rr_v4i32(<4 x i32>* %ptr, i32 %off) {
  %ptr1 = getelementptr <4 x i32>, <4 x i32>* %ptr, i32 %off
  %res = load <4 x i32>, <4 x i32>* %ptr1, align 16
  ret <4 x i32> %res
}

; CHECK-LABEL: test_ld_rrr_v4i32:
; CHECK-DAG:   add [[R1:\$m[0-9]+]], $m0, $m1
; CHECK-DAG:   shl [[R2:\$m[0-9]+]], $m2, 4
; CHECK-DAG:   ld32 $m{{[0-9]+}}, [[R1]], [[R2]], 0
; CHECK-DAG:   ld32 $m{{[0-9]+}}, [[R1]], [[R2]], 1
; CHECK-DAG:   ld32 $m{{[0-9]+}}, [[R1]], [[R2]], 2
; CHECK-DAG:   ld32 $m{{[0-9]+}}, [[R1]], [[R2]], 3
define <4 x i32> @test_ld_rrr_v4i32(i32 %ptr, i32 %delta, i32 %off) {
  %ptr1 = add i32 %ptr, %delta
  %ptr2 = inttoptr i32 %ptr1 to <4 x i32>*
  %ptr3 = getelementptr <4 x i32>, <4 x i32>* %ptr2, i32 %off
  %res = load <4 x i32>, <4 x i32>* %ptr3, align 16
  ret <4 x i32> %res
}

; CHECK-LABEL: test_ld_ri_v4i32:
; CHECK-DAG:   ld32 $m{{[0-9]+}}, $m0, $m15, 4092
; CHECK-DAG:   ld32 $m{{[0-9]+}}, $m0, $m15, 4093
; CHECK-DAG:   ld32 $m{{[0-9]+}}, $m0, $m15, 4094
; CHECK-DAG:   ld32 $m{{[0-9]+}}, $m0, $m15, 4095
define <4 x i32> @test_ld_ri_v4i32(<4 x i32>* %ptr) {
  %ptr1 = getelementptr <4 x i32>, <4 x i32>* %ptr, i32 1023
  %res = load <4 x i32>, <4 x i32>* %ptr1, align 16
  ret <4 x i32> %res
}

; CHECK-LABEL: test_ld_rri_v4i32:
; CHECK-DAG:   ld32 $m{{[0-9]+}}, $m0, $m1, 4092
; CHECK-DAG:   ld32 $m{{[0-9]+}}, $m0, $m1, 4093
; CHECK-DAG:   ld32 $m{{[0-9]+}}, $m0, $m1, 4094
; CHECK-DAG:   ld32 $m{{[0-9]+}}, $m0, $m1, 4095
define <4 x i32> @test_ld_rri_v4i32(i32 %ptr, i32 %delta) {
  %ptr1 = add i32 %ptr, %delta
  %ptr2 = inttoptr i32 %ptr1 to <4 x i32>*
  %ptr3 = getelementptr <4 x i32>, <4 x i32>* %ptr2, i32 1023
  %res = load <4 x i32>, <4 x i32>* %ptr3, align 16
  ret <4 x i32> %res
}

; CHECK-LABEL: test_ld_fi_v4i32:
; CHECK-DAG:   ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK-DAG:   ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK-DAG:   ld32 $m{{[0-9]+}}, $m11, $m15, 2
; CHECK-DAG:   ld32 $m{{[0-9]+}}, $m11, $m15, 3
define <4 x i32> @test_ld_fi_v4i32() {
  %ptr = alloca <4 x i32>, i32 128
  %res = load <4 x i32>, <4 x i32>* %ptr, align 16
  ret <4 x i32> %res
}

; CHECK-LABEL: test_ld_fii_v4i32:
; CHECK-DAG:   ld32 $m{{[0-9]+}}, $m11, $m15, 4092
; CHECK-DAG:   ld32 $m{{[0-9]+}}, $m11, $m15, 4093
; CHECK-DAG:   ld32 $m{{[0-9]+}}, $m11, $m15, 4094
; CHECK-DAG:   ld32 $m{{[0-9]+}}, $m11, $m15, 4095
define <4 x i32> @test_ld_fii_v4i32() {
  %ptr1 = alloca <4 x i32>, i32 128
  %ptr2 = getelementptr <4 x i32>, <4 x i32>* %ptr1, i32 1023
  %res = load <4 x i32>, <4 x i32>* %ptr2, align 16
  ret <4 x i32> %res
}

; CHECK-LABEL: test_ld_fir_v4i32:
; CHECK-DAG:   add [[BASE:\$m[0-9]+]], $m11, {{[0-9]+}}
; CHECK-DAG:   shl [[OFF:\$m[0-9]+]], $m0, 4
; CHECK-DAG:   ld32 $m{{[0-9]+}}, [[BASE]], [[OFF]], 0
; CHECK-DAG:   ld32 $m{{[0-9]+}}, [[BASE]], [[OFF]], 1
; CHECK-DAG:   ld32 $m{{[0-9]+}}, [[BASE]], [[OFF]], 2
; CHECK-DAG:   ld32 $m{{[0-9]+}}, [[BASE]], [[OFF]], 3
define <4 x i32> @test_ld_fir_v4i32(i32 %offset) {
  %ptr1 = alloca <4 x i32>, i32 128
  %ptr2 = getelementptr <4 x i32>, <4 x i32>* %ptr1, i32 %offset
  %res = load <4 x i32>, <4 x i32>* %ptr2, align 16
  ret <4 x i32> %res
}

; CHECK-LABEL: test_st_r_v4i32:
; CHECK-DAG:   st32 $m{{[0-9]+}}, $m0, $m15, 0
; CHECK-DAG:   st32 $m{{[0-9]+}}, $m0, $m15, 1
; CHECK-DAG:   st32 $m{{[0-9]+}}, $m0, $m15, 2
; CHECK-DAG:   st32 $m{{[0-9]+}}, $m0, $m15, 3
define void @test_st_r_v4i32(<4 x i32>* %ptr, <4 x i32> %data) {
  store <4 x i32> %data, <4 x i32>*  %ptr, align 16
  ret void
}

; CHECK-LABEL: test_st_rr_v4i32:
; CHECK-DAG:   st32 $m{{[0-9]+}}, $m0, $m1, 0
; CHECK-DAG:   st32 $m{{[0-9]+}}, $m0, $m1, 1
; CHECK-DAG:   st32 $m{{[0-9]+}}, $m0, $m1, 2
; CHECK-DAG:   st32 $m{{[0-9]+}}, $m0, $m1, 3
define void @test_st_rr_v4i32(<4 x i32>* %ptr, i32 %off, <4 x i32> %data) {
  %ptr1 = getelementptr <4 x i32>, <4 x i32>* %ptr, i32 %off
  store <4 x i32> %data, <4 x i32>* %ptr1, align 16
  ret void
}

; CHECK-LABEL: test_st_rrr_v4i32:
; CHECK-DAG:   add [[R1:\$m[0-9]+]], $m0, $m1
; CHECK-DAG:   shl [[R2:\$m[0-9]+]], $m2, 4
; CHECK-DAG:   st32 $m{{[0-9]+}}, [[R1]], [[R2]], 0
; CHECK-DAG:   st32 $m{{[0-9]+}}, [[R1]], [[R2]], 1
; CHECK-DAG:   st32 $m{{[0-9]+}}, [[R1]], [[R2]], 2
; CHECK-DAG:   st32 $m{{[0-9]+}}, [[R1]], [[R2]], 3
define void @test_st_rrr_v4i32(i32 %ptr, i32 %delta, i32 %off, <4 x i32> %data) {
  %ptr1 = add i32 %ptr, %delta
  %ptr2 = inttoptr i32 %ptr1 to <4 x i32>*
  %ptr3 = getelementptr <4 x i32>, <4 x i32>* %ptr2, i32 %off
  store <4 x i32> %data, <4 x i32>* %ptr3, align 16
  ret void
}

; CHECK-LABEL: test_st_ri_v4i32:
; CHECK-DAG:   st32 $m{{[0-9]+}}, $m0, $m15, 4092
; CHECK-DAG:   st32 $m{{[0-9]+}}, $m0, $m15, 4093
; CHECK-DAG:   st32 $m{{[0-9]+}}, $m0, $m15, 4094
; CHECK-DAG:   st32 $m{{[0-9]+}}, $m0, $m15, 4095
define void @test_st_ri_v4i32(<4 x i32>* %ptr, <4 x i32> %data) {
  %ptr1 = getelementptr <4 x i32>, <4 x i32>* %ptr, i32 1023
  store <4 x i32> %data, <4 x i32>* %ptr1, align 16
  ret void
}

; CHECK-LABEL: test_st_rri_v4i32:
; CHECK-DAG:   st32 $m{{[0-9]+}}, $m0, $m1, 4092
; CHECK-DAG:   st32 $m{{[0-9]+}}, $m0, $m1, 4093
; CHECK-DAG:   st32 $m{{[0-9]+}}, $m0, $m1, 4094
; CHECK-DAG:   st32 $m{{[0-9]+}}, $m0, $m1, 4095
define void @test_st_rri_v4i32(i32 %ptr, i32 %delta, <4 x i32> %data) {
  %ptr1 = add i32 %ptr, %delta
  %ptr2 = inttoptr i32 %ptr1 to <4 x i32>*
  %ptr3 = getelementptr <4 x i32>, <4 x i32>* %ptr2, i32 1023
  store <4 x i32> %data, <4 x i32>* %ptr3, align 16
  ret void
}

; CHECK-LABEL: test_st_fi_v4i32:
; CHECK-DAG:   st32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK-DAG:   st32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK-DAG:   st32 $m{{[0-9]+}}, $m11, $m15, 2
; CHECK-DAG:   st32 $m{{[0-9]+}}, $m11, $m15, 3
define void @test_st_fi_v4i32(<4 x i32> %data) {
  %ptr = alloca <4 x i32>, i32 128
  store <4 x i32> %data, <4 x i32>*  %ptr, align 16
  ret void
}

; CHECK-LABEL: test_st_fii_v4i32:
; CHECK-DAG:   st32 $m{{[0-9]+}}, $m11, $m15, 4092
; CHECK-DAG:   st32 $m{{[0-9]+}}, $m11, $m15, 4093
; CHECK-DAG:   st32 $m{{[0-9]+}}, $m11, $m15, 4094
; CHECK-DAG:   st32 $m{{[0-9]+}}, $m11, $m15, 4095
define void @test_st_fii_v4i32(<4 x i32> %data) {
  %ptr1 = alloca <4 x i32>, i32 128
  %ptr2 = getelementptr <4 x i32>, <4 x i32>* %ptr1, i32 1023
  store <4 x i32> %data, <4 x i32>* %ptr2, align 16
  ret void
}

