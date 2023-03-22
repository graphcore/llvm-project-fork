; RUN: llc < %s -mtriple=colossus -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -mtriple=colossus -mattr=+ipu2 | FileCheck %s

;===------------------------------------------------------------------------===;
; Build vector.
;===------------------------------------------------------------------------===;

; CHECK-LABEL: test_build_v4i16_splat:
; CHECK:       setzi $m0, 655402
; CHECK-NEXT:  or $m0, $m0, 2097152
; CHECK-NEXT:  mov $m1, $m0
; CHECK-NEXT:  br
define <4 x i16> @test_build_v4i16_splat() {
  ret <4 x i16> <i16 42, i16 42, i16 42, i16 42>
}

; CHECK-LABEL: test_build_v4i16_splat_small_different_values:
; CHECK-DAG:   setzi $m0, 131073
; CHECK-DAG:   setzi $m1, 262147
; CHECK-NEXT:  br
define <4 x i16> @test_build_v4i16_splat_small_different_values() {
  ret <4 x i16> <i16 1, i16 2, i16 3, i16 4>
}

; CHECK-LABEL: build_from_zeros:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m15
; CHECK-NEXT:   mov $m1, $m15
; CHECK-NEXT:  br
define <4 x i16> @build_from_zeros() {
  ret <4 x i16> <i16 0, i16 0, i16 0, i16 0>
}

; CHECK-LABEL: test_build_v4i16_splat_opt:
; CHECK:       # %bb.0:
; CHECK-NEXT:  setzi $m0, 65537
; CHECK-NEXT:  mov $m1, $m0
; CHECK-NEXT:  br
define <4 x i16> @test_build_v4i16_splat_opt() {
  ret <4 x i16> <i16 1, i16 1, i16 1, i16 1>
}

; CHECK-LABEL: build_from_all_ones:
; CHECK:       # %bb.0:
; CHECK-DAG:   add $m0, $m15, -1
; CHECK-DAG:   mov $m1, $m0
; CHECK-NEXT:  br
define <4 x i16> @build_from_all_ones() {
  ret <4 x i16> <i16 65535, i16 65535, i16 65535, i16 65535>
}

; CHECK-LABEL: build_from_minus_one:
; CHECK:       # %bb.0:
; CHECK-DAG:   add $m0, $m15, -1
; CHECK-DAG:   mov $m1, $m0
; CHECK-NEXT:  br
define <4 x i16> @build_from_minus_one() {
  ret <4 x i16> <i16 -1, i16 -1, i16 -1, i16 -1>
}

; CHECK-LABEL: test_build_v4i16:
; CHECK-DAG:   sort4x16lo
; CHECK-DAG:   sort4x16lo
define <4 x i16> @test_build_v4i16(i16 %a1, i16 %a2,
                                   i16 %a3, i16 %a4) {
  %res1 = insertelement <4 x i16> undef, i16 %a1, i64 0
  %res2 = insertelement <4 x i16> %res1, i16 %a2, i64 1
  %res3 = insertelement <4 x i16> %res2, i16 %a3, i64 2
  %res4 = insertelement <4 x i16> %res3, i16 %a4, i64 3
  ret <4 x i16> %res4
}

; Check the constant optimisation can be applied to half of the vector
; CHECK-LABEL: build_from_aacc:
; CHECK:       # %bb.0:
; CHECK-NEXT:  sort4x16lo $m0, $m0, $m1
; CHECK-NEXT:  setzi $m1, 524292
; CHECK-NEXT:  br
define <4 x i16> @build_from_aacc(i16 %a1, i16 %a2) {
  %res1 = insertelement <4 x i16> undef, i16 %a1, i64 0
  %res2 = insertelement <4 x i16> %res1, i16 %a2, i64 1
  %res3 = insertelement <4 x i16> %res2, i16 4, i64 2
  %res4 = insertelement <4 x i16> %res3, i16 8, i64 3
  ret <4 x i16> %res4
}

; CHECK-LABEL: build_from_ccaa:
; CHECK:       # %bb.0:
; CHECK-NEXT:  sort4x16lo $m1, $m0, $m1
; CHECK-NEXT:  setzi $m0, 524292
; CHECK-NEXT:  br
define <4 x i16> @build_from_ccaa(i16 %a1, i16 %a2) {
  %res1 = insertelement <4 x i16> undef, i16 4, i64 0
  %res2 = insertelement <4 x i16> %res1, i16 8, i64 1
  %res3 = insertelement <4 x i16> %res2, i16 %a1, i64 2
  %res4 = insertelement <4 x i16> %res3, i16 %a2, i64 3
  ret <4 x i16> %res4
}

; CHECK-LABEL: build_from_acac:
; CHECK:       # %bb.0:
; CHECK-DAG:   setzi [[REGA:\$m[0-9]+]], 4
; CHECK-DAG:   setzi [[REGB:\$m[0-9]+]], 8
; CHECK-DAG:   sort4x16lo $m0, $m0, [[REGA]]
; CHECK-DAG:   sort4x16lo $m1, $m1, [[REGB]]
; CHECK-NEXT:  br
define <4 x i16> @build_from_acac(i16 %a1, i16 %a2) {
  %res1 = insertelement <4 x i16> undef, i16 %a1, i64 0
  %res2 = insertelement <4 x i16> %res1, i16 4, i64 1
  %res3 = insertelement <4 x i16> %res2, i16 %a2, i64 2
  %res4 = insertelement <4 x i16> %res3, i16 8, i64 3
  ret <4 x i16> %res4
}

;===------------------------------------------------------------------------===;
; Insert element.
;===------------------------------------------------------------------------===;

; CHECK-LABEL: test_insert_at_0_undef:
; CHECK:       # %bb.0:
; CHECK-NOT:   sort4x16lo
; CHECK-NOT:   swap
; CHECK:       br $m10
define <4 x i16> @test_insert_at_0_undef(i16 %value) {
  %res = insertelement <4 x i16> undef, i16 %value, i64 0
  ret <4 x i16> %res
}

; CHECK-LABEL: test_insert_at_1_undef:
; CHECK:       # %bb.0:
; CHECK-NEXT:  swap16 $m0, $m0
; CHECK-NEXT:  br
define <4 x i16> @test_insert_at_1_undef(i16 %value) {
  %res = insertelement <4 x i16> undef, i16 %value, i64 1
  ret <4 x i16> %res
}

; CHECK-LABEL: test_insert_at_2_undef:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m1, $m0
; CHECK-NEXT:  br
define <4 x i16> @test_insert_at_2_undef(i16 %value) {
  %res = insertelement <4 x i16> undef, i16 %value, i64 2
  ret <4 x i16> %res
}

; CHECK-LABEL: test_insert_at_3_undef:
; CHECK:       # %bb.0:
; CHECK-NEXT:  swap16 $m1, $m0
; CHECK-NEXT:  br
define <4 x i16> @test_insert_at_3_undef(i16 %value) {
  %res = insertelement <4 x i16> undef, i16 %value, i64 3
  ret <4 x i16> %res
}

; CHECK-LABEL: test_insert_at_N_undef:
; CHECK-DAG:   swap16
; CHECK-DAG:   cmpeq
; CHECK-DAG:   cmpeq
; CHECK-DAG:   cmpeq
; CHECK-DAG:   movnz
; CHECK-DAG:   movnz
; CHECK-DAG:   movnz
; CHECK-DAG:   movnz
; CHECK-DAG:   movnz
; CHECK-DAG:   movnz
; CHECK:       br
define <4 x i16> @test_insert_at_N_undef(i16 %value, i32 %idx) {
  %res = insertelement <4 x i16> undef, i16 %value, i32 %idx
  ret <4 x i16> %res
}

; CHECK-LABEL: test_insert_at_4_undef:
; This is UB. Any output is fine, provided not a crash.
; CHECK:       br $m10
define <4 x i16> @test_insert_at_4_undef(i16 %value) {
  %res = insertelement <4 x i16> undef, i16 %value, i64 4
  ret <4 x i16> %res
}

; CHECK-LABEL: test_insert_at_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:  roll16 [[REGA:\$m[0-9]+]], $m0, $m2
; CHECK-NEXT:  swap16 $m0, [[REGA]]
; CHECK-NEXT:  br
define <4 x i16> @test_insert_at_0(<4 x i16> %b, i16 %value) {
  %res = insertelement <4 x i16> %b, i16 %value, i64 0
  ret <4 x i16> %res
}

; CHECK-LABEL: test_insert_at_1:
; CHECK:       # %bb.0:
; CHECK-NEXT:  sort4x16lo $m0, $m0, $m2
; CHECK-NEXT:  br
define <4 x i16> @test_insert_at_1(<4 x i16> %b, i16 %value) {
  %res = insertelement <4 x i16> %b, i16 %value, i64 1
  ret <4 x i16> %res
}

; CHECK-LABEL: test_insert_at_2:
; CHECK:       # %bb.0:
; CHECK-NEXT:  roll16 [[REGA:\$m[0-9]+]], $m1, $m2
; CHECK-NEXT:  swap16 $m1, [[REGA]]
; CHECK-NEXT:  br
define <4 x i16> @test_insert_at_2(<4 x i16> %b, i16 %value) {
  %res = insertelement <4 x i16> %b, i16 %value, i64 2
  ret <4 x i16> %res
}

; CHECK-LABEL: test_insert_at_3:
; CHECK:       # %bb.0:
; CHECK-NEXT:  sort4x16lo $m1, $m1, $m2
; CHECK-NEXT:  br $m10
define <4 x i16> @test_insert_at_3(<4 x i16> %b, i16 %value) {
  %res = insertelement <4 x i16> %b, i16 %value, i64 3
  ret <4 x i16> %res
}

; CHECK-LABEL: test_insert_at_N:
; CHECK:       # %bb.0:
; CHECK-DAG:   roll16
; CHECK-DAG:   swap16
; CHECK-DAG:   sort4x16lo
; CHECK-DAG:   movnz
; CHECK-DAG:   movnz
; CHECK-DAG:   roll16
; CHECK-DAG:   swap16
; CHECK-DAG:   sort4x16lo
; CHECK-DAG:   movnz
; CHECK-DAG:   movnz
; CHECK:       br $m10
define <4 x i16> @test_insert_at_N(<4 x i16> %b, i16 %value, i32 %idx) {
  %res = insertelement <4 x i16> %b, i16 %value, i32 %idx
  ret <4 x i16> %res
}

; CHECK-LABEL: test_insert_at_4:
; This is UB. Any output is fine, provided not a crash.
; CHECK:       br $m10
define <4 x i16> @test_insert_at_4(<4 x i16> %b, i16 %value) {
  %res = insertelement <4 x i16> %b, i16 %value, i64 4
  ret <4 x i16> %res
}

;===------------------------------------------------------------------------===;
; Extract element.
;===------------------------------------------------------------------------===;

; CHECK-LABEL: test_extract_at_0:
; CHECK-NOT:   sort4x16
; CHECK:       br
define i16 @test_extract_at_0(<4 x i16> %a) {
  %value = extractelement <4 x i16> %a, i64 0
  ret i16 %value
}

; CHECK-LABEL: test_extract_at_1:
; CHECK:       swap16 $m0, $m0
; CHECK-NEXT:  br
define i16 @test_extract_at_1(<4 x i16> %a) {
  %value = extractelement <4 x i16> %a, i64 1
  ret i16 %value
}

; CHECK-LABEL: test_extract_at_2:
; CHECK:       mov $m0, $m1
; CHECK-NEXT:  br
define i16 @test_extract_at_2(<4 x i16> %a) {
  %value = extractelement <4 x i16> %a, i64 2
  ret i16 %value
}

; CHECK-LABEL: test_extract_at_3:
; CHECK:       swap16 $m0, $m1
; CHECK-NEXT:  br
define i16 @test_extract_at_3(<4 x i16> %a) {
  %value = extractelement <4 x i16> %a, i64 3
  ret i16 %value
}

; CHECK-LABEL: test_extract_at_N:
; CHECK-DAG:   swap16
; CHECK-DAG:   swap16
; CHECK-DAG:   movnz
; CHECK-DAG:   movnz
; CHECK-DAG:   movnz
; CHECK:       br
define i16 @test_extract_at_N(<4 x i16> %a, i32 %idx) {
  %value = extractelement <4 x i16> %a, i32 %idx
  ret i16 %value
}

;===------------------------------------------------------------------------===;
; Extract subvector
;===------------------------------------------------------------------------===;
; CHECK-LABEL: test_extract_subvec_at_0_nop:
; CHECK-NOT:   or
; CHECK-NOT:   mov
; CHECK:       br $m10
define <2 x i16> @test_extract_subvec_at_0_nop(<4 x i16> %a) {
  %lo = extractelement <4 x i16> %a, i32 0
  %hi = extractelement <4 x i16> %a, i32 1
  %res1 = insertelement <2 x i16> undef, i16 %lo, i64 0
  %res2 = insertelement <2 x i16> %res1, i16 %hi, i64 1
  ret <2 x i16> %res2
}

; CHECK-LABEL: test_extract_subvec_at_0:
; CHECK:       mov $m0, $m2
; CHECK-NEXT:  mov $m1, $m3
; CHECK-NEXT:  br $m10
define <2 x i16> @test_extract_subvec_at_0(i32 %ignored, <4 x i16> %a) {
  %lo = extractelement <4 x i16> %a, i32 0
  %hi = extractelement <4 x i16> %a, i32 1
  %res1 = insertelement <2 x i16> undef, i16 %lo, i64 0
  %res2 = insertelement <2 x i16> %res1, i16 %hi, i64 1
  ret <2 x i16> %res2
}

; CHECK-LABEL: test_extract_subvec_at_1:
; CHECK:       mov $m0, $m1
; CHECK-NEXT:  br $m10
define <2 x i16> @test_extract_subvec_at_1(<4 x i16> %a) {
  %lo = extractelement <4 x i16> %a, i32 2
  %hi = extractelement <4 x i16> %a, i32 3
  %res1 = insertelement <2 x i16> undef, i16 %lo, i64 0
  %res2 = insertelement <2 x i16> %res1, i16 %hi, i64 1
  ret <2 x i16> %res2
}
