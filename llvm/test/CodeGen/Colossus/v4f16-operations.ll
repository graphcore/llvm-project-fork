; RUN: llc < %s -mtriple=colossus -colossus-coissue=false -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -mtriple=colossus -colossus-coissue=false -mattr=+ipu2 | FileCheck %s



;===------------------------------------------------------------------------===;
; Build vector.
;===------------------------------------------------------------------------===;

; CHECK-LABEL: test_build_v4f16_splat:
; CHECK:       setzi $a0, 867533
; CHECK-NEXT:  or $a0, $a0, 1019215872
; CHECK-NEXT:  mov $a1, $a0
define <4 x half> @test_build_v4f16_splat() {
  ret <4 x half> <half 0xH3CCD, half 0xH3CCD, half 0xH3CCD, half 0xH3CCD>
}

; CHECK-LABEL: test_build_v4f16_splat_opt:
; CHECK:       setzi $a0, 65537
; CHECK-NEXT:  mov $a1, $a0
define <4 x half> @test_build_v4f16_splat_opt() {
  ret <4 x half> <half 0xH1, half 0xH1, half 0xH1, half 0xH1>
}

; CHECK-LABEL: build_from_zeros:
; CHECK:       # %bb.0:
; CHECK-DAG:   zero $a0:1
; CHECK-NEXT:  br
define <4 x half> @build_from_zeros() {
  ret <4 x half> <half 0xH0, half 0xH0, half 0xH0, half 0xH0>
}

; CHECK-LABEL: build_from_all_ones:
; CHECK:       # %bb.0:
; CHECK-NEXT:  not64 $a0:1, $a14:15
; CHECK-NEXT:  br
define <4 x half> @build_from_all_ones() {
  ret <4 x half> <half 0xHFFFF, half 0xHFFFF, half 0xHFFFF, half 0xHFFFF>
}

; CHECK-LABEL: test_build_v4f16:
; CHECK-DAG:   sort4x16lo
; CHECK-DAG:   sort4x16lo
define <4 x half> @test_build_v4f16(half %a1, half %a2,
                                    half %a3, half %a4) {
  %res1 = insertelement <4 x half> undef, half %a1, i32 0
  %res2 = insertelement <4 x half> %res1, half %a2, i32 1
  %res3 = insertelement <4 x half> %res2, half %a3, i32 2
  %res4 = insertelement <4 x half> %res3, half %a4, i32 3
  ret <4 x half> %res4
}

; Check the constant optimisation can be applied to half of the vector
; CHECK-LABEL: build_from_aacc:
; CHECK:       # %bb.0:
; CHECK-NEXT:  sort4x16lo $a0, $a0, $a1
; CHECK-NEXT:  setzi $a1, 65538
; CHECK-NEXT:  br
define <4 x half> @build_from_aacc(half %a1, half %a2) {
  %res1 = insertelement <4 x half> undef, half %a1, i64 0
  %res2 = insertelement <4 x half> %res1, half %a2, i64 1
  %res3 = insertelement <4 x half> %res2, half 0xH2, i64 2
  %res4 = insertelement <4 x half> %res3, half 0xH1, i64 3
  ret <4 x half> %res4
}

; CHECK-LABEL: build_from_ccaa:
; CHECK:       # %bb.0:
; CHECK-NEXT:  setzi $a2, 65538
; CHECK-NEXT:  sort4x16lo $a3, $a0, $a1
; CHECK-NEXT:  mov $a0:1, $a2:3
; CHECK-NEXT:  br
define <4 x half> @build_from_ccaa(half %a1, half %a2) {
  %res1 = insertelement <4 x half> undef, half 0xH2, i64 0
  %res2 = insertelement <4 x half> %res1, half 0xH1, i64 1
  %res3 = insertelement <4 x half> %res2, half %a1, i64 2
  %res4 = insertelement <4 x half> %res3, half %a2, i64 3
  ret <4 x half> %res4
}

; CHECK-LABEL: build_from_acac:
; CHECK:       # %bb.0:
; CHECK-DAG:   setzi [[REGA:\$a[0-9]+]], 2
; CHECK-DAG:   setzi [[REGB:\$a[0-9]+]], 1
; CHECK-DAG:   sort4x16lo $a0, $a0, [[REGA]]
; CHECK-DAG:   sort4x16lo $a1, $a1, [[REGB]]
; CHECK-NEXT:  br
define <4 x half> @build_from_acac(half %a1, half %a2) {
  %res1 = insertelement <4 x half> undef, half %a1, i64 0
  %res2 = insertelement <4 x half> %res1, half 0xH2, i64 1
  %res3 = insertelement <4 x half> %res2, half %a2, i64 2
  %res4 = insertelement <4 x half> %res3, half 0xH1, i64 3
  ret <4 x half> %res4
}

;===------------------------------------------------------------------------===;
; Insert element.
;===------------------------------------------------------------------------===;

; CHECK-LABEL: test_insert_at_0_undef:
; CHECK:       # %bb.0:
; CHECK-NOT:   sort4x16lo
; CHECK-NOT:   swap
; CHECK:       br $m10
define <4 x half> @test_insert_at_0_undef(half %value) {
  %res = insertelement <4 x half> undef, half %value, i64 0
  ret <4 x half> %res
}

; CHECK-LABEL: test_insert_at_1_undef:
; CHECK:       # %bb.0:
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  mov $a1, $a0
; CHECK-NEXT:  br
define <4 x half> @test_insert_at_1_undef(half %value) {
  %res = insertelement <4 x half> undef, half %value, i64 1
  ret <4 x half> %res
}

; CHECK-LABEL: test_insert_at_2_undef:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $a1, $a0
; CHECK-NEXT:  br
define <4 x half> @test_insert_at_2_undef(half %value) {
  %res = insertelement <4 x half> undef, half %value, i64 2
  ret <4 x half> %res
}

; CHECK-LABEL: test_insert_at_3_undef:
; CHECK:       # %bb.0:
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  mov $a1, $a0
; CHECK-NEXT:  br
define <4 x half> @test_insert_at_3_undef(half %value) {
  %res = insertelement <4 x half> undef, half %value, i64 3
  ret <4 x half> %res
}

; CHECK-LABEL: test_insert_at_N_undef:
; CHECK-DAG:   swap16
; CHECK-DAG:   cmpeq
; CHECK:       br $m10
define <4 x half> @test_insert_at_N_undef(half %value, i32 %idx) {
  %res = insertelement <4 x half> undef, half %value, i32 %idx
  ret <4 x half> %res
}

; CHECK-LABEL: test_insert_at_4_undef:
; This is UB. Any output is fine, provided not a crash.
; CHECK:       br $m10
define <4 x half> @test_insert_at_4_undef(half %value) {
  %res = insertelement <4 x half> undef, half %value, i64 4
  ret <4 x half> %res
}

; CHECK-LABEL: test_insert_at_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:  roll16 [[REGA:\$a[0-9]+]], $a0, $a2
; CHECK-NEXT:  swap16 $a0, [[REGA]]
; CHECK-NEXT:  br $m10
define <4 x half> @test_insert_at_0(<4 x half> %b, half %value) {
  %res = insertelement <4 x half> %b, half %value, i32 0
  ret <4 x half> %res
}

; CHECK-LABEL: test_insert_at_1:
; CHECK:       # %bb.0:
; CHECK-NEXT:  sort4x16lo $a0, $a0, $a2
; CHECK-NEXT:  br
define <4 x half> @test_insert_at_1(<4 x half> %b, half %value) {
  %res = insertelement <4 x half> %b, half %value, i32 1
  ret <4 x half> %res
}

; CHECK-LABEL: test_insert_at_2:
; CHECK:       # %bb.0:
; CHECK-NEXT:  roll16 [[REGA:\$a[0-9]+]], $a1, $a2
; CHECK-NEXT:  swap16 $a1, [[REGA]]
; CHECK-NEXT:  br
define <4 x half> @test_insert_at_2(<4 x half> %b, half %value) {
  %res = insertelement <4 x half> %b, half %value, i32 2
  ret <4 x half> %res
}

; CHECK-LABEL: test_insert_at_3:
; CHECK:       # %bb.0:
; CHECK-NEXT:  sort4x16lo $a1, $a1, $a2
; CHECK-NEXT:  br $m10
define <4 x half> @test_insert_at_3(<4 x half> %b, half %value) {
  %res = insertelement <4 x half> %b, half %value, i32 3
  ret <4 x half> %res
}

; CHECK-LABEL: test_insert_at_N:
; CHECK-DAG:   cmpeq
; CHECK-DAG:   roll16
; CHECK-DAG:   swap16
; CHECK-DAG:   sort4x16lo
; CHECK-DAG:   roll16
; CHECK-DAG:   swap16
; CHECK-DAG:   sort4x16lo
; CHECK:       br $m10
define <4 x half> @test_insert_at_N(<4 x half> %b, half %value, i32 %idx) {
  %res = insertelement <4 x half> %b, half %value, i32 %idx
  ret <4 x half> %res
}

; CHECK-LABEL: test_insert_at_4:
; This is UB. Any output is fine, provided not a crash.
; CHECK:       br $m10
define <4 x half> @test_insert_at_4(<4 x half> %b, half %value) {
  %res = insertelement <4 x half> %b, half %value, i64 4
  ret <4 x half> %res
}

;===------------------------------------------------------------------------===;
; Extract element.
;===------------------------------------------------------------------------===;

; CHECK-LABEL: test_extract_at_0:
; CHECK-NOT:   sort4x16
; CHECK:       br
define half @test_extract_at_0(<4 x half> %a) {
  %value = extractelement <4 x half> %a, i32 0
  ret half %value
}

; CHECK-LABEL: test_extract_at_1:
; CHECK:       swap16 $a0, $a0
; CHECK-NEXT:  br
define half @test_extract_at_1(<4 x half> %a) {
  %value = extractelement <4 x half> %a, i32 1
  ret half %value
}

; CHECK-LABEL: test_extract_at_2:
; CHECK:       mov $a0, $a1
; CHECK-NEXT:  br
define half @test_extract_at_2(<4 x half> %a) {
  %value = extractelement <4 x half> %a, i32 2
  ret half %value
}

; CHECK-LABEL: test_extract_at_3:
; CHECK:       swap16 $a0, $a1
; CHECK-NEXT:  br
define half @test_extract_at_3(<4 x half> %a) {
  %value = extractelement <4 x half> %a, i32 3
  ret half %value
}

; CHECK-LABEL: test_extract_at_N:
; CHECK-DAG:   swap16
; CHECK-DAG:   cmpeq
; CHECK-DAG:   brz
; CHECK-DAG:   cmpeq
; CHECK-DAG:   brz
; CHECK-DAG:   swap16
; CHECK-DAG:   cmpeq
; CHECK-DAG:   brz
; CHECK-DAG:   cmpeq
; CHECK-DAG:   brnz
; CHECK:       br
define half @test_extract_at_N(<4 x half> %a, i32 %idx) {
  %value = extractelement <4 x half> %a, i32 %idx
  ret half %value
}

;===------------------------------------------------------------------------===;
; Extract subvector
;===------------------------------------------------------------------------===;
; CHECK-LABEL: test_extract_subvec_at_0_nop:
; CHECK-NOT:   or
; CHECK-NOT:   mov
; CHECK:       br $m10
define <2 x half> @test_extract_subvec_at_0_nop(<4 x half> %a) {
  %lo = extractelement <4 x half> %a, i32 0
  %hi = extractelement <4 x half> %a, i32 1
  %res1 = insertelement <2 x half> undef, half %lo, i64 0
  %res2 = insertelement <2 x half> %res1, half %hi, i64 1
  ret <2 x half> %res2
}

; CHECK-LABEL: test_extract_subvec_at_0:
; CHECK:       mov  $a0:1, $a2:3
; CHECK-NEXT:  br $m10
define <2 x half> @test_extract_subvec_at_0(float %ignored, <4 x half> %a) {
  %lo = extractelement <4 x half> %a, i32 0
  %hi = extractelement <4 x half> %a, i32 1
  %res1 = insertelement <2 x half> undef, half %lo, i64 0
  %res2 = insertelement <2 x half> %res1, half %hi, i64 1
  ret <2 x half> %res2
}

; CHECK-LABEL: test_extract_subvec_at_1:
; CHECK:       mov $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_extract_subvec_at_1(<4 x half> %a) {
  %lo = extractelement <4 x half> %a, i32 2
  %hi = extractelement <4 x half> %a, i32 3
  %res1 = insertelement <2 x half> undef, half %lo, i64 0
  %res2 = insertelement <2 x half> %res1, half %hi, i64 1
  ret <2 x half> %res2
}
