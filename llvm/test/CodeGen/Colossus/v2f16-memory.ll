; RUN: llc < %s -mtriple=colossus -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -mtriple=colossus -mattr=+ipu2 | FileCheck %s

; CHECK-LABEL: test_ld_r_v2f16:
; CHECK:       ld32 $a0, $m0, $m15, 0
; CHECK-NEXT:  br $m10
define <2 x half> @test_ld_r_v2f16(<2 x half>* %ptr) {
  %res = load <2 x half>, <2 x half>* %ptr, align 4
  ret <2 x half> %res
}

; CHECK-LABEL: test_ld_rr_v2f16:
; CHECK:       ld32 $a0, $m0, $m15, $m1
; CHECK-NEXT:  br $m10
define <2 x half> @test_ld_rr_v2f16(<2 x half>* %ptr, i32 %off) {
  %ptr1 = getelementptr <2 x half>, <2 x half>* %ptr, i32 %off
  %res = load <2 x half>, <2 x half>* %ptr1, align 4
  ret <2 x half> %res
}

; CHECK-LABEL: test_ld_rrr_v2f16:
; CHECK:       ld32 $a0, $m0, $m1, $m2
; CHECK-NEXT:  br $m10
define <2 x half> @test_ld_rrr_v2f16(i32 %ptr, i32 %delta, i32 %off) {
  %ptr1 = add i32 %ptr, %delta
  %ptr2 = inttoptr i32 %ptr1 to <2 x half>*
  %ptr3 = getelementptr <2 x half>, <2 x half>* %ptr2, i32 %off
  %res = load <2 x half>, <2 x half>* %ptr3, align 4
  ret <2 x half> %res
}

; CHECK-LABEL: test_ld_ri_v2f16:
; CHECK:       ld32 $a0, $m0, $m15, 4095
; CHECK-NEXT:  br $m10
define <2 x half> @test_ld_ri_v2f16(<2 x half>* %ptr) {
  %ptr1 = getelementptr <2 x half>, <2 x half>* %ptr, i32 4095
  %res = load <2 x half>, <2 x half>* %ptr1, align 4
  ret <2 x half> %res
}

; CHECK-LABEL: test_ld_rri_v2f16:
; CHECK:       ld32 $a0, $m0, $m1, 4095
; CHECK-NEXT:  br $m10
define <2 x half> @test_ld_rri_v2f16(i32 %ptr, i32 %delta) {
  %ptr1 = add i32 %ptr, %delta
  %ptr2 = inttoptr i32 %ptr1 to <2 x half>*
  %ptr3 = getelementptr <2 x half>, <2 x half>* %ptr2, i32 4095
  %res = load <2 x half>, <2 x half>* %ptr3, align 4
  ret <2 x half> %res
}

; CHECK-LABEL: test_ld_fi_v2f16:
; CHECK:       ld32 $a0, $m11, $m15, 0
define <2 x half> @test_ld_fi_v2f16() {
  %ptr = alloca <2 x half>, i32 32
  %res = load <2 x half>, <2 x half>* %ptr, align 4
  ret <2 x half> %res
}

; CHECK-LABEL: test_ld_fii_v2f16:
; CHECK:       ld32 $a0, $m11, $m15, 4095
define <2 x half> @test_ld_fii_v2f16() {
  %ptr1 = alloca <2 x half>, i32 32
  %ptr2 = getelementptr <2 x half>, <2 x half>* %ptr1, i32 4095
  %res = load <2 x half>, <2 x half>* %ptr2, align 4
  ret <2 x half> %res
}

; CHECK-LABEL: test_ld_fir_v2f16:
; CHECK-DAG:   add [[BASE:\$m[0-9]+]], $m11, 0
; CHECK:       ld32 $a0, [[BASE]], $m15, $m0
define <2 x half> @test_ld_fir_v2f16(i32 %offset) {
  %ptr1 = alloca <2 x half>, i32 32
  %ptr2 = getelementptr <2 x half>, <2 x half>* %ptr1, i32 %offset
  %res = load <2 x half>, <2 x half>* %ptr2, align 4
  ret <2 x half> %res
}

; CHECK-LABEL: test_st_r_v2f16:
; CHECK:       st32 $a0, $m0, $m15, 0
; CHECK-NEXT:  br $m10
define void @test_st_r_v2f16(<2 x half>* %ptr, <2 x half> %data) {
  store <2 x half> %data, <2 x half>*  %ptr, align 4
  ret void
}

; CHECK-LABEL: test_st_rr_v2f16:
; CHECK:       st32 $a0, $m0, $m15, $m1
; CHECK-NEXT:  br $m10
define void @test_st_rr_v2f16(<2 x half>* %ptr, i32 %off, <2 x half> %data) {
  %ptr1 = getelementptr <2 x half>, <2 x half>* %ptr, i32 %off
  store <2 x half> %data, <2 x half>* %ptr1, align 4
  ret void
}

; CHECK-LABEL: test_st_rrr_v2f16:
; CHECK:       st32 $a0, $m0, $m1, $m2
; CHECK-NEXT:  br $m10
define void @test_st_rrr_v2f16(i32 %ptr, i32 %delta, i32 %off, <2 x half> %data) {
  %ptr1 = add i32 %ptr, %delta
  %ptr2 = inttoptr i32 %ptr1 to <2 x half>*
  %ptr3 = getelementptr <2 x half>, <2 x half>* %ptr2, i32 %off
  store <2 x half> %data, <2 x half>* %ptr3, align 4
  ret void
}

; CHECK-LABEL: test_st_ri_v2f16:
; CHECK:       st32 $a0, $m0, $m15, 4095
; CHECK-NEXT:  br $m10
define void @test_st_ri_v2f16(<2 x half>* %ptr, <2 x half> %data) {
  %ptr1 = getelementptr <2 x half>, <2 x half>* %ptr, i32 4095
  store <2 x half> %data, <2 x half>* %ptr1, align 4
  ret void
}

; CHECK-LABEL: test_st_rri_v2f16:
; CHECK:       st32 $a0, $m0, $m1, 4095
; CHECK-NEXT:  br $m10
define void @test_st_rri_v2f16(i32 %ptr, i32 %delta, <2 x half> %data) {
  %ptr1 = add i32 %ptr, %delta
  %ptr2 = inttoptr i32 %ptr1 to <2 x half>*
  %ptr3 = getelementptr <2 x half>, <2 x half>* %ptr2, i32 4095
  store <2 x half> %data, <2 x half>* %ptr3, align 4
  ret void
}

; CHECK-LABEL: test_st_fi_v2f16:
; CHECK:       st32 $a0, $m11, $m15, 0
define void @test_st_fi_v2f16(<2 x half> %data) {
  %ptr = alloca <2 x half>, i32 32
  store <2 x half> %data, <2 x half>*  %ptr, align 4
  ret void
}

; CHECK-LABEL: test_st_fii_v2f16:
; CHECK:       st32 $a0, $m11, $m15, 4095
define void @test_st_fii_v2f16(<2 x half> %data) {
  %ptr1 = alloca <2 x half>, i32 32
  %ptr2 = getelementptr <2 x half>, <2 x half>* %ptr1, i32 4095
  store <2 x half> %data, <2 x half>* %ptr2, align 4
  ret void
}

; CHECK-LABEL: test_st_fir_v2f16:
; CHECK-DAG:   add [[BASE:\$m[0-9]+]], $m11, {{[0-9]+}}
; CHECK:       st32 $a0, [[BASE]], $m15, $m0
define void @test_st_fir_v2f16(i32 %offset, <2 x half> %data) {
  %ptr1 = alloca <2 x half>, i32 32
  %ptr2 = getelementptr <2 x half>, <2 x half>* %ptr1, i32 %offset
  store <2 x half> %data, <2 x half>* %ptr2, align 4
  ret void
}

