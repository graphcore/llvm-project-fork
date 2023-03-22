; RUN: llc < %s -mtriple=colossus -colossus-coissue=false -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -mtriple=colossus -colossus-coissue=false -mattr=+ipu2 | FileCheck %s



;===------------------------------------------------------------------------===;
; Build vector.
;===------------------------------------------------------------------------===;

; CHECK-LABEL: test_build_v2f16_splat:
; CHECK:       # %bb.0:
; CHECK-NEXT:  setzi $a0, 867533
; CHECK-NEXT:  or $a0, $a0, 1019215872
; CHECK-NEXT:  br $m10
define <2 x half> @test_build_v2f16_splat() {
  ret <2 x half> <half 0xH3CCD, half 0xH3CCD>
}

; CHECK-LABEL: test_build_v2f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  sort4x16lo $a0, $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_build_v2f16(half %a1, half %a2) {
  %res1 = insertelement <2 x half> undef, half %a1, i32 0
  %res2 = insertelement <2 x half> %res1, half %a2, i32 1
  ret <2 x half> %res2
}

; CHECK-LABEL: build_from_constants:
; CHECK:       # %bb.0:
; CHECK-NEXT:  setzi $a0, 262147
; CHECK-NEXT:  br $m10
define <2 x half> @build_from_constants() {
  ret <2 x half> <half 0xH3, half 0xH4>
}

; CHECK-LABEL: build_from_zeros:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $a0, $a15
; CHECK-NEXT:  br
define <2 x half> @build_from_zeros() {
  ret <2 x half> <half 0xH0, half 0xH0>
}

; CHECK-LABEL: build_from_two_ones:
; CHECK:       # %bb.0:
; CHECK-NEXT:  setzi $a0, 65537
; CHECK-NEXT:  br
define <2 x half> @build_from_two_ones() {
  ret <2 x half> <half 0xH1, half 0xH1>
}

; CHECK-LABEL: build_from_all_ones:
; CHECK:       # %bb.0:
; CHECK-NEXT:  not $a0, $a15
; CHECK-NEXT:  br
define <2 x half> @build_from_all_ones() {
  ret <2 x half> <half 0xHFFFF, half 0xHFFFF>
}

; CHECK-LABEL: test_build_v2f16_first_zero:
; CHECK:       sort4x16lo $a0, $a15, $a1
; CHECK-NEXT:  br
define <2 x half> @test_build_v2f16_first_zero(half %unused, half %a1) {
  %res1 = insertelement <2 x half> undef, half 0xH0, i32 0
  %res2 = insertelement <2 x half> %res1, half %a1, i32 1
  ret <2 x half> %res2
}

; CHECK-LABEL: test_build_v2f16_second_zero:
; CHECK:       sort4x16lo $a0, $a1, $a15
; CHECK-NEXT:  br
define <2 x half> @test_build_v2f16_second_zero(half %unused, half %a1) {
  %res1 = insertelement <2 x half> undef, half %a1, i32 0
  %res2 = insertelement <2 x half> %res1, half 0xH0, i32 1
  ret <2 x half> %res2
}

;===------------------------------------------------------------------------===;
; Insert element.
;===------------------------------------------------------------------------===;

; CHECK-LABEL: insert_half_0_undef:
; CHECK:       # %bb.0:
; CHECK-NEXT:  br $m10
define <2 x half> @insert_half_0_undef(half %x) {
  %1 = insertelement <2 x half> undef, half %x, i32 0
  ret <2 x half> %1
}

; CHECK-LABEL: insert_half_1_undef:
; CHECK:       # %bb.0:
; CHECK-NEXT:  swap16  $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @insert_half_1_undef(half %x) {
  %1 = insertelement <2 x half> undef, half %x, i32 1
  ret <2 x half> %1
}

; CHECK-LABEL: insert_half_N_undef:
; Codegen for this may change when optimisations are introduced.
; CHECK-DAG:   swap16
; CHECK-DAG:   brz
; CHECK:       br $m10
define <2 x half> @insert_half_N_undef(half %x, i32 %y) {
  %1 = insertelement <2 x half> undef, half %x, i32 %y
  ret <2 x half> %1
}

; CHECK-LABEL: insert_half_2_undef:
; This is UB. Any output is fine, provided not a crash.
; CHECK:       br $m10
define <2 x half> @insert_half_2_undef(half %x) {
  %1 = insertelement <2 x half> undef, half %x, i32 2
  ret <2 x half> %1
}

; CHECK-LABEL: insert_half_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:  roll16 $a0, $a0, $a1
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @insert_half_0(<2 x half> %x, half %y) {
  %1 = insertelement <2 x half> %x, half %y, i32 0
  ret <2 x half> %1
}

; CHECK-LABEL: insert_half_1:
; CHECK:       # %bb.0:
; CHECK-NEXT:  sort4x16lo $a0, $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @insert_half_1(<2 x half> %x, half %y) {
  %1 = insertelement <2 x half> %x, half %y, i32 1
  ret <2 x half> %1
}

; CHECK-LABEL: insert_half_N:
; Codegen for this may change when optimisations are introduced.
; CHECK-DAG:   roll16
; CHECK-DAG:   swap16
; CHECK-DAG:   sort4x16lo
; CHECK-DAG:   brz
; CHECK:       br $m10
define <2 x half> @insert_half_N(<2 x half> %x, i32 %y, half %z) {
  %1 = insertelement <2 x half> %x, half %z, i32 %y
  ret <2 x half> %1
}

; CHECK-LABEL: insert_half_2
; This is UB. Any output is fine, provided not a crash.
; CHECK:       br $m10
define <2 x half> @insert_half_2(<2 x half> %x, half %y) {
  %1 = insertelement <2 x half> %x, half %y, i32 2
  ret <2 x half> %1
}

;===------------------------------------------------------------------------===;
; Extract element.
;===------------------------------------------------------------------------===;

; CHECK-LABEL: extract_half_0:
; CHECK:       # %bb.0:
; CHECK-NOT:   sort4x16
; CHECK:       br $m10
define half @extract_half_0(<2 x half> %x) {
  %1 = extractelement <2 x half> %x, i32 0
  ret half %1
}

; CHECK-LABEL: extract_half_1:
; CHECK:       # %bb.0:
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define half @extract_half_1(<2 x half> %x)  {
  %1 = extractelement <2 x half> %x, i32 1
  ret half %1
}

; CHECK-LABEL: extract_half_N:
; CHECK:       brz $m0, [[LABEL:\.L[A-Z0-9_]+]] 
; CHECK:       swap16 $a0, $a0
; CHECK:       [[LABEL]]:
; CHECK:       br $m10
define half @extract_half_N(<2 x half> %x, i32 %idx) {
  %1 = extractelement <2 x half> %x, i32 %idx
  ret half %1
}

; CHECK-LABEL: extract_half_2:
; This is UB. Any output is fine, provided not a crash.
; CHECK:       br
define half @extract_half_2(<2 x half> %x)  {
  %1 = extractelement <2 x half> %x, i32 2
  ret half %1
}
