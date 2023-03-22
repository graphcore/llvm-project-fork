; RUN: llc < %s -mtriple=colossus -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -mtriple=colossus -mattr=+ipu2 | FileCheck %s

; CHECK-LABEL: test_ld_r_v2f32:
; CHECK:       ld64 $a0:1, $m0, $m15, 0
; CHECK-NEXT:  br $m10
define <2 x float> @test_ld_r_v2f32(<2 x float>* %ptr) {
  %res = load <2 x float>, <2 x float>* %ptr, align 8
  ret <2 x float> %res
}

; CHECK-LABEL: test_ld_rr_v2f32:
; CHECK:       ld64 $a0:1, $m0, $m15, $m1
; CHECK-NEXT:  br $m10
define <2 x float> @test_ld_rr_v2f32(<2 x float>* %ptr, i32 %off) {
  %ptr1 = getelementptr <2 x float>, <2 x float>* %ptr, i32 %off
  %res = load <2 x float>, <2 x float>* %ptr1, align 8
  ret <2 x float> %res
}

; CHECK-LABEL: test_ld_rrr_v2f32:
; CHECK:       ld64 $a0:1, $m0, $m1, $m2
; CHECK-NEXT:  br $m10
define <2 x float> @test_ld_rrr_v2f32(i32 %ptr, i32 %delta, i32 %off) {
  %ptr1 = add i32 %ptr, %delta
  %ptr2 = inttoptr i32 %ptr1 to <2 x float>*
  %ptr3 = getelementptr <2 x float>, <2 x float>* %ptr2, i32 %off
  %res = load <2 x float>, <2 x float>* %ptr3, align 8
  ret <2 x float> %res
}

; CHECK-LABEL: test_ld_ri_v2f32:
; CHECK:       ld64 $a0:1, $m0, $m15, 4095
; CHECK-NEXT:  br $m10
define <2 x float> @test_ld_ri_v2f32(<2 x float>* %ptr) {
  %ptr1 = getelementptr <2 x float>, <2 x float>* %ptr, i32 4095
  %res = load <2 x float>, <2 x float>* %ptr1, align 8
  ret <2 x float> %res
}

; CHECK-LABEL: test_ld_rri_v2f32:
; CHECK:       ld64 $a0:1, $m0, $m1, 4095
; CHECK-NEXT:  br $m10
define <2 x float> @test_ld_rri_v2f32(i32 %ptr, i32 %delta) {
  %ptr1 = add i32 %ptr, %delta
  %ptr2 = inttoptr i32 %ptr1 to <2 x float>*
  %ptr3 = getelementptr <2 x float>, <2 x float>* %ptr2, i32 4095
  %res = load <2 x float>, <2 x float>* %ptr3, align 8
  ret <2 x float> %res
}

; CHECK-LABEL: test_ld_fi_v2f32:
; CHECK:       ld64 $a0:1, $m11, $m15, 0
define <2 x float> @test_ld_fi_v2f32() {
  %ptr = alloca <2 x float>, i32 64
  %res = load <2 x float>, <2 x float>* %ptr, align 8
  ret <2 x float> %res
}

; CHECK-LABEL: test_ld_fii_v2f32:
; CHECK:       ld64 $a0:1, $m11, $m15, 4095
define <2 x float> @test_ld_fii_v2f32() {
  %ptr1 = alloca <2 x float>, i32 64
  %ptr2 = getelementptr <2 x float>, <2 x float>* %ptr1, i32 4095
  %res = load <2 x float>, <2 x float>* %ptr2, align 8
  ret <2 x float> %res
}

; CHECK-LABEL: test_ld_fir_v2f32:
; CHECK-DAG:   add [[BASE:\$m[0-9]+]], $m11, 0
; CHECK:       ld64 $a0:1, [[BASE]], $m15, $m0
define <2 x float> @test_ld_fir_v2f32(i32 %offset) {
  %ptr1 = alloca <2 x float>, i32 64
  %ptr2 = getelementptr <2 x float>, <2 x float>* %ptr1, i32 %offset
  %res = load <2 x float>, <2 x float>* %ptr2, align 8
  ret <2 x float> %res
}

; CHECK-LABEL: test_st_r_v2f32:
; CHECK:       st64 $a0:1, $m0, $m15, 0
; CHECK-NEXT:  br $m10
define void @test_st_r_v2f32(<2 x float>* %ptr, <2 x float> %data) {
  store <2 x float> %data, <2 x float>*  %ptr, align 8
  ret void
}

; CHECK-LABEL: test_st_rr_v2f32:
; CHECK:       st64 $a0:1, $m0, $m15, $m1
; CHECK-NEXT:  br $m10
define void @test_st_rr_v2f32(<2 x float>* %ptr, i32 %off, <2 x float> %data) {
  %ptr1 = getelementptr <2 x float>, <2 x float>* %ptr, i32 %off
  store <2 x float> %data, <2 x float>* %ptr1, align 8
  ret void
}

; CHECK-LABEL: test_st_rrr_v2f32:
; CHECK:       st64 $a0:1, $m0, $m1, $m2
; CHECK-NEXT:  br $m10
define void @test_st_rrr_v2f32(i32 %ptr, i32 %delta, i32 %off, <2 x float> %data) {
  %ptr1 = add i32 %ptr, %delta
  %ptr2 = inttoptr i32 %ptr1 to <2 x float>*
  %ptr3 = getelementptr <2 x float>, <2 x float>* %ptr2, i32 %off
  store <2 x float> %data, <2 x float>* %ptr3, align 8
  ret void
}

; CHECK-LABEL: test_st_ri_v2f32:
; CHECK:       st64 $a0:1, $m0, $m15, 4095
; CHECK-NEXT:  br $m10
define void @test_st_ri_v2f32(<2 x float>* %ptr, <2 x float> %data) {
  %ptr1 = getelementptr <2 x float>, <2 x float>* %ptr, i32 4095
  store <2 x float> %data, <2 x float>* %ptr1, align 8
  ret void
}

; CHECK-LABEL: test_st_rri_v2f32:
; CHECK:       st64 $a0:1, $m0, $m1, 4095
; CHECK-NEXT:  br $m10
define void @test_st_rri_v2f32(i32 %ptr, i32 %delta, <2 x float> %data) {
  %ptr1 = add i32 %ptr, %delta
  %ptr2 = inttoptr i32 %ptr1 to <2 x float>*
  %ptr3 = getelementptr <2 x float>, <2 x float>* %ptr2, i32 4095
  store <2 x float> %data, <2 x float>* %ptr3, align 8
  ret void
}

; CHECK-LABEL: test_st_fi_v2f32:
; CHECK:       st64 $a0:1, $m11, $m15, 0
define void @test_st_fi_v2f32(<2 x float> %data) {
  %ptr = alloca <2 x float>, i32 64
  store <2 x float> %data, <2 x float>*  %ptr, align 8
  ret void
}

; CHECK-LABEL: test_st_fii_v2f32:
; CHECK:       st64 $a0:1, $m11, $m15, 4095
define void @test_st_fii_v2f32(<2 x float> %data) {
  %ptr1 = alloca <2 x float>, i32 64
  %ptr2 = getelementptr <2 x float>, <2 x float>* %ptr1, i32 4095
  store <2 x float> %data, <2 x float>* %ptr2, align 8
  ret void
}

; CHECK-LABEL: test_st_fir_v2f32:
; CHECK-DAG:   add [[BASE:\$m[0-9]+]], $m11, {{[0-9]+}}
; CHECK:       st64 $a0:1, [[BASE]], $m15, $m0
define void @test_st_fir_v2f32(i32 %offset, <2 x float> %data) {
  %ptr1 = alloca <2 x float>, i32 64
  %ptr2 = getelementptr <2 x float>, <2 x float>* %ptr1, i32 %offset
  store <2 x float> %data, <2 x float>* %ptr2, align 8
  ret void
}

