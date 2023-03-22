; RUN: llc < %s -mtriple=colossus -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -mtriple=colossus -mattr=+ipu2 | FileCheck %s

; CHECK-LABEL: test_ld_r_v4f16:
; CHECK:       ld64 $a0:1, $m0, $m15, 0
; CHECK-NEXT:  br $m10
define <4 x half> @test_ld_r_v4f16(<4 x half>* %ptr) {
  %res = load <4 x half>, <4 x half>* %ptr, align 8
  ret <4 x half> %res
}

; CHECK-LABEL: test_ld_rr_v4f16:
; CHECK:       ld64 $a0:1, $m0, $m15, $m1
; CHECK-NEXT:  br $m10
define <4 x half> @test_ld_rr_v4f16(<4 x half>* %ptr, i32 %off) {
  %ptr1 = getelementptr <4 x half>, <4 x half>* %ptr, i32 %off
  %res = load <4 x half>, <4 x half>* %ptr1, align 8
  ret <4 x half> %res
}

; CHECK-LABEL: test_ld_rrr_v4f16:
; CHECK:       ld64 $a0:1, $m0, $m1, $m2
; CHECK-NEXT:  br $m10
define <4 x half> @test_ld_rrr_v4f16(i32 %ptr, i32 %delta, i32 %off) {
  %ptr1 = add i32 %ptr, %delta
  %ptr2 = inttoptr i32 %ptr1 to <4 x half>*
  %ptr3 = getelementptr <4 x half>, <4 x half>* %ptr2, i32 %off
  %res = load <4 x half>, <4 x half>* %ptr3, align 8
  ret <4 x half> %res
}

; CHECK-LABEL: test_ld_ri_v4f16:
; CHECK:       ld64 $a0:1, $m0, $m15, 4095
; CHECK-NEXT:  br $m10
define <4 x half> @test_ld_ri_v4f16(<4 x half>* %ptr) {
  %ptr1 = getelementptr <4 x half>, <4 x half>* %ptr, i32 4095
  %res = load <4 x half>, <4 x half>* %ptr1, align 8
  ret <4 x half> %res
}

; CHECK-LABEL: test_ld_rri_v4f16:
; CHECK:       ld64 $a0:1, $m0, $m1, 4095
; CHECK-NEXT:  br $m10
define <4 x half> @test_ld_rri_v4f16(i32 %ptr, i32 %delta) {
  %ptr1 = add i32 %ptr, %delta
  %ptr2 = inttoptr i32 %ptr1 to <4 x half>*
  %ptr3 = getelementptr <4 x half>, <4 x half>* %ptr2, i32 4095
  %res = load <4 x half>, <4 x half>* %ptr3, align 8
  ret <4 x half> %res
}

; CHECK-LABEL: test_ld_fi_v4f16:
; CHECK:       ld64 $a0:1, $m11, $m15, 0
define <4 x half> @test_ld_fi_v4f16() {
  %ptr = alloca <4 x half>, i32 64
  %res = load <4 x half>, <4 x half>* %ptr, align 8
  ret <4 x half> %res
}

; CHECK-LABEL: test_ld_fii_v4f16:
; CHECK:       ld64 $a0:1, $m11, $m15, 4095
define <4 x half> @test_ld_fii_v4f16() {
  %ptr1 = alloca <4 x half>, i32 64
  %ptr2 = getelementptr <4 x half>, <4 x half>* %ptr1, i32 4095
  %res = load <4 x half>, <4 x half>* %ptr2, align 8
  ret <4 x half> %res
}

; CHECK-LABEL: test_ld_fir_v4f16:
; CHECK-DAG:   add [[BASE:\$m[0-9]+]], $m11, 0
; CHECK:       ld64 $a0:1, [[BASE]], $m15, $m0
define <4 x half> @test_ld_fir_v4f16(i32 %offset) {
  %ptr1 = alloca <4 x half>, i32 64
  %ptr2 = getelementptr <4 x half>, <4 x half>* %ptr1, i32 %offset
  %res = load <4 x half>, <4 x half>* %ptr2, align 8
  ret <4 x half> %res
}

; CHECK-LABEL: test_st_r_v4f16:
; CHECK:       st64 $a0:1, $m0, $m15, 0
; CHECK-NEXT:  br $m10
define void @test_st_r_v4f16(<4 x half>* %ptr, <4 x half> %data) {
  store <4 x half> %data, <4 x half>*  %ptr, align 8
  ret void
}

; CHECK-LABEL: test_st_rr_v4f16:
; CHECK:       st64 $a0:1, $m0, $m15, $m1
; CHECK-NEXT:  br $m10
define void @test_st_rr_v4f16(<4 x half>* %ptr, i32 %off, <4 x half> %data) {
  %ptr1 = getelementptr <4 x half>, <4 x half>* %ptr, i32 %off
  store <4 x half> %data, <4 x half>* %ptr1, align 8
  ret void
}

; CHECK-LABEL: test_st_rrr_v4f16:
; CHECK:       st64 $a0:1, $m0, $m1, $m2
; CHECK-NEXT:  br $m10
define void @test_st_rrr_v4f16(i32 %ptr, i32 %delta, i32 %off, <4 x half> %data) {
  %ptr1 = add i32 %ptr, %delta
  %ptr2 = inttoptr i32 %ptr1 to <4 x half>*
  %ptr3 = getelementptr <4 x half>, <4 x half>* %ptr2, i32 %off
  store <4 x half> %data, <4 x half>* %ptr3, align 8
  ret void
}

; CHECK-LABEL: test_st_ri_v4f16:
; CHECK:       st64 $a0:1, $m0, $m15, 4095
; CHECK-NEXT:  br $m10
define void @test_st_ri_v4f16(<4 x half>* %ptr, <4 x half> %data) {
  %ptr1 = getelementptr <4 x half>, <4 x half>* %ptr, i32 4095
  store <4 x half> %data, <4 x half>* %ptr1, align 8
  ret void
}

; CHECK-LABEL: test_st_rri_v4f16:
; CHECK:       st64 $a0:1, $m0, $m1, 4095
; CHECK-NEXT:  br $m10
define void @test_st_rri_v4f16(i32 %ptr, i32 %delta, <4 x half> %data) {
  %ptr1 = add i32 %ptr, %delta
  %ptr2 = inttoptr i32 %ptr1 to <4 x half>*
  %ptr3 = getelementptr <4 x half>, <4 x half>* %ptr2, i32 4095
  store <4 x half> %data, <4 x half>* %ptr3, align 8
  ret void
}

; CHECK-LABEL: test_st_fi_v4f16:
; CHECK:       st64 $a0:1, $m11, $m15, 0
define void @test_st_fi_v4f16(<4 x half> %data) {
  %ptr = alloca <4 x half>, i32 64
  store <4 x half> %data, <4 x half>*  %ptr, align 8
  ret void
}

; CHECK-LABEL: test_st_fii_v4f16:
; CHECK:       st64 $a0:1, $m11, $m15, 4095
define void @test_st_fii_v4f16(<4 x half> %data) {
  %ptr1 = alloca <4 x half>, i32 64
  %ptr2 = getelementptr <4 x half>, <4 x half>* %ptr1, i32 4095
  store <4 x half> %data, <4 x half>* %ptr2, align 8
  ret void
}

; CHECK-LABEL: test_st_fir_v4f16:
; CHECK-DAG:   add [[BASE:\$m[0-9]+]], $m11, {{[0-9]+}}
; CHECK:       st64 $a0:1, [[BASE]], $m15, $m0
define void @test_st_fir_v4f16(i32 %offset, <4 x half> %data) {
  %ptr1 = alloca <4 x half>, i32 64
  %ptr2 = getelementptr <4 x half>, <4 x half>* %ptr1, i32 %offset
  store <4 x half> %data, <4 x half>* %ptr2, align 8
  ret void
}

