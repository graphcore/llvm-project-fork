; RUN: llc < %s -mtriple=colossus -mattr=+supervisor,+ipu1 | FileCheck %s
; RUN: llc < %s -mtriple=colossus -mattr=+supervisor,+ipu2 | FileCheck %s

; CHECK-LABEL: test_ld_r_f32:
; CHECK:       ld32 $m0, $m0, $m15, 0
; CHECK-NEXT:  br $m10
define float @test_ld_r_f32(float* %ptr) {
  %res = load float, float* %ptr, align 4
  ret float %res
}

; CHECK-LABEL: test_ld_rr_f32:
; CHECK:       ld32 $m0, $m0, $m15, $m1
; CHECK-NEXT:  br $m10
define float @test_ld_rr_f32(float* %ptr, i32 %off) {
  %ptr1 = getelementptr float, float* %ptr, i32 %off
  %res = load float, float* %ptr1, align 4
  ret float %res
}

; CHECK-LABEL: test_ld_rrr_f32:
; CHECK:       ld32 $m0, $m0, $m1, $m2
; CHECK-NEXT:  br $m10
define float @test_ld_rrr_f32(i32 %ptr, i32 %delta, i32 %off) {
  %ptr1 = add i32 %ptr, %delta
  %ptr2 = inttoptr i32 %ptr1 to float*
  %ptr3 = getelementptr float, float* %ptr2, i32 %off
  %res = load float, float* %ptr3, align 4
  ret float %res
}

; CHECK-LABEL: test_ld_ri_f32:
; CHECK:       ld32 $m0, $m0, $m15, 4095
; CHECK-NEXT:  br $m10
define float @test_ld_ri_f32(float* %ptr) {
  %ptr1 = getelementptr float, float* %ptr, i32 4095
  %res = load float, float* %ptr1, align 4
  ret float %res
}

; CHECK-LABEL: test_ld_rri_f32:
; CHECK:       ld32 $m0, $m0, $m1, 4095
; CHECK-NEXT:  br $m10
define float @test_ld_rri_f32(i32 %ptr, i32 %delta) {
  %ptr1 = add i32 %ptr, %delta
  %ptr2 = inttoptr i32 %ptr1 to float*
  %ptr3 = getelementptr float, float* %ptr2, i32 4095
  %res = load float, float* %ptr3, align 4
  ret float %res
}

; CHECK-LABEL: test_ld_fi_f32:
; CHECK:       ld32 $m0, $m11, $m15, 0
define float @test_ld_fi_f32() {
  %ptr = alloca float, i32 32
  %res = load float, float* %ptr, align 4
  ret float %res
}

; CHECK-LABEL: test_ld_fii_f32:
; CHECK:       ld32 $m0, $m11, $m15, 4095
define float @test_ld_fii_f32() {
  %ptr1 = alloca float, i32 32
  %ptr2 = getelementptr float, float* %ptr1, i32 4095
  %res = load float, float* %ptr2, align 4
  ret float %res
}

; CHECK-LABEL: test_ld_fir_f32:
; CHECK-DAG:   add [[BASE:\$m[0-9]+]], $m11, 0
; CHECK:       ld32 $m0, [[BASE]], $m15, $m0
define float @test_ld_fir_f32(i32 %offset) {
  %ptr1 = alloca float, i32 32
  %ptr2 = getelementptr float, float* %ptr1, i32 %offset
  %res = load float, float* %ptr2, align 4
  ret float %res
}

; CHECK-LABEL: test_st_r_f32:
; CHECK:       st32 $m1, $m0, $m15, 0
; CHECK-NEXT:  br $m10
define void @test_st_r_f32(float* %ptr, float %data) {
  store float %data, float*  %ptr, align 4
  ret void
}

; CHECK-LABEL: test_st_rr_f32:
; CHECK:       stm32 $m2, $m0, $m1
; CHECK-NEXT:  br $m10
define void @test_st_rr_f32(float* %ptr, i32 %off, float %data) {
  %ptr1 = getelementptr float, float* %ptr, i32 %off
  store float %data, float* %ptr1, align 4
  ret void
}

; CHECK-LABEL: test_st_rrr_f32:
; CHECK:       add $m0, $m0, $m1
; CHECK:       stm32 $m3, $m0, $m2
; CHECK-NEXT:  br $m10
define void @test_st_rrr_f32(i32 %ptr, i32 %delta, i32 %off, float %data) {
  %ptr1 = add i32 %ptr, %delta
  %ptr2 = inttoptr i32 %ptr1 to float*
  %ptr3 = getelementptr float, float* %ptr2, i32 %off
  store float %data, float* %ptr3, align 4
  ret void
}

; CHECK-LABEL: test_st_ri_f32:
; CHECK:       st32 $m1, $m0, $m15, 4095
; CHECK-NEXT:  br $m10
define void @test_st_ri_f32(float* %ptr, float %data) {
  %ptr1 = getelementptr float, float* %ptr, i32 4095
  store float %data, float* %ptr1, align 4
  ret void
}

; CHECK-LABEL: test_st_rri_f32:
; CHECK:       st32 $m2, $m0, $m1, 4095
; CHECK-NEXT:  br $m10
define void @test_st_rri_f32(i32 %ptr, i32 %delta, float %data) {
  %ptr1 = add i32 %ptr, %delta
  %ptr2 = inttoptr i32 %ptr1 to float*
  %ptr3 = getelementptr float, float* %ptr2, i32 4095
  store float %data, float* %ptr3, align 4
  ret void
}

; CHECK-LABEL: test_st_fi_f32:
; CHECK:       st32 $m0, $m11, $m15, 0
define void @test_st_fi_f32(float %data) {
  %ptr = alloca float, i32 32
  store float %data, float*  %ptr, align 4
  ret void
}

; CHECK-LABEL: test_st_fii_f32:
; CHECK:       st32 $m0, $m11, $m15, 4095
define void @test_st_fii_f32(float %data) {
  %ptr1 = alloca float, i32 32
  %ptr2 = getelementptr float, float* %ptr1, i32 4095
  store float %data, float* %ptr2, align 4
  ret void
}

; CHECK-LABEL: test_st_fir_f32:
; CHECK-DAG:   add [[BASE:\$m[0-9]+]], $m11, {{[0-9]+}}
; CHECK:       stm32 $m1, [[BASE]], $m0
define void @test_st_fir_f32(i32 %offset, float %data) {
  %ptr1 = alloca float, i32 32
  %ptr2 = getelementptr float, float* %ptr1, i32 %offset
  store float %data, float* %ptr2, align 4
  ret void
}
