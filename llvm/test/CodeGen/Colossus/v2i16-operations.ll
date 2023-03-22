; RUN: llc < %s -mtriple=colossus -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -mtriple=colossus -mattr=+ipu2 | FileCheck %s

;===------------------------------------------------------------------------===;
; Build vector.
;===------------------------------------------------------------------------===;

; CHECK-LABEL: test_build_v2i16_splat:
; CHECK:       setzi $m0, 867533
; CHECK-NEXT:  or $m0, $m0, 1019215872
; CHECK-NEXT:  br
define <2 x i16> @test_build_v2i16_splat() {
  ret <2 x i16> <i16 15565, i16 15565>
}

; CHECK-LABEL: test_build_v2i16:
; CHECK:       sort4x16lo $m0, $m0, $m1
; CHECK-NEXT:  br
define <2 x i16> @test_build_v2i16(i16 %a1, i16 %a2) {
  %res1 = insertelement <2 x i16> undef, i16 %a1, i32 0
  %res2 = insertelement <2 x i16> %res1, i16 %a2, i32 1
  ret <2 x i16> %res2
}

; CHECK-LABEL: build_from_constants:
; CHECK:       # %bb.0:
; CHECK-NEXT:  setzi $m0, 262147
; CHECK-NEXT:  br
define <2 x i16> @build_from_constants() {
  ret <2 x i16> <i16 3, i16 4>
}

; CHECK-LABEL: build_from_zeros:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m15
; CHECK-NEXT:  br
define <2 x i16> @build_from_zeros() {
  ret <2 x i16> <i16 0, i16 0>
}

; CHECK-LABEL: build_from_two_ones:
; CHECK:       # %bb.0:
; CHECK-NEXT:  setzi $m0, 65537
; CHECK-NEXT:  br
define <2 x i16> @build_from_two_ones() {
  ret <2 x i16> <i16 1, i16 1>
}

; CHECK-LABEL: build_from_all_ones:
; CHECK:       # %bb.0:
; CHECK-NEXT:  add $m0, $m15, -1
; CHECK-NEXT:  br
define <2 x i16> @build_from_all_ones() {
  ret <2 x i16> <i16 65535, i16 65535>
}

; CHECK-LABEL: build_from_minus_one:
; CHECK:       # %bb.0:
; CHECK-NEXT:  add $m0, $m15, -1
; CHECK-NEXT:  br
define <2 x i16> @build_from_minus_one() {
  ret <2 x i16> <i16 -1, i16 -1>
}

; CHECK-LABEL: test_build_v2i16_first_zero:
; CHECK:       sort4x16lo $m0, $m15, $m1
; CHECK-NEXT:  br
define <2 x i16> @test_build_v2i16_first_zero(i32 %unused, i16 %a1) {
  %res1 = insertelement <2 x i16> undef, i16 0, i32 0
  %res2 = insertelement <2 x i16> %res1, i16 %a1, i32 1
  ret <2 x i16> %res2
}

; CHECK-LABEL: test_build_v2i16_second_zero:
; CHECK:       sort4x16lo $m0, $m1, $m15
; CHECK-NEXT:  br
define <2 x i16> @test_build_v2i16_second_zero(i32 %unused, i16 %a1) {
  %res1 = insertelement <2 x i16> undef, i16 %a1, i32 0
  %res2 = insertelement <2 x i16> %res1, i16 0, i32 1
  ret <2 x i16> %res2
}

;===------------------------------------------------------------------------===;
; Insert element.
;===------------------------------------------------------------------------===;

; CHECK-LABEL: insert_i16_0_undef:
; CHECK:       # %bb.0:
; CHECK-NEXT:  br $m10
define <2 x i16> @insert_i16_0_undef(i16 %x) {
  %1 = insertelement <2 x i16> undef, i16 %x, i32 0
  ret <2 x i16> %1
}

; CHECK-LABEL: insert_i16_1_undef:
; CHECK:       # %bb.0:
; CHECK-NEXT:  swap16 $m0, $m0
; CHECK-NEXT:  br $m10
define <2 x i16> @insert_i16_1_undef(i16 %x) {
  %1 = insertelement <2 x i16> undef, i16 %x, i32 1
  ret <2 x i16> %1
}

; CHECK-LABEL: insert_i16_N_undef:
; CHECK-DAG:   swap16
; CHECK-DAG:   movnz
; CHECK-NEXT:  br $m10
define <2 x i16> @insert_i16_N_undef(i16 %x, i32 %y) {
  %1 = insertelement <2 x i16> undef, i16 %x, i32 %y
  ret <2 x i16> %1
}

; CHECK-LABEL: insert_i16_2_undef:
; This is UB. Any output is fine, provided not a crash.
; CHECK:       br $m10
define <2 x i16> @insert_i16_2_undef(i16 %x) {
  %1 = insertelement <2 x i16> undef, i16 %x, i32 2
  ret <2 x i16> %1
}

; CHECK-LABEL: insert_i16_0:
; CHECK:       roll16 $m0, $m0, $m1
; CHECK-NEXT:  swap16 $m0, $m0
; CHECK-NEXT:  br $m10
define <2 x i16> @insert_i16_0(<2 x i16> %x, i16 %y) {
  %1 = insertelement <2 x i16> %x, i16 %y, i32 0
  ret <2 x i16> %1
}

; CHECK-LABEL: insert_i16_1:
; CHECK:       sort4x16lo $m0, $m0, $m1
; CHECK-NEXT:  br $m10
define <2 x i16> @insert_i16_1(<2 x i16> %x, i16 %y) {
  %1 = insertelement <2 x i16> %x, i16 %y, i32 1
  ret <2 x i16> %1
}

; CHECK-LABEL: insert_i16_N:
; CHECK-DAG:   swap16
; CHECK-DAG:   roll16
; CHECK-DAG:   sort4x16lo
; CHECK-DAG:   movnz
; CHECK-NEXT:  br $m10
define <2 x i16> @insert_i16_N(<2 x i16> %x, i32 %y, i16 %z) {
  %1 = insertelement <2 x i16> %x, i16 %z, i32 %y
  ret <2 x i16> %1
}

; CHECK-LABEL: insert_i16_2:
; This is UB. Any output is fine, provided not a crash.
; CHECK:       br $m10
define <2 x i16> @insert_i16_2(<2 x i16> %x, i16 %y) {
  %1 = insertelement <2 x i16> %x, i16 %y, i32 2
  ret <2 x i16> %1
}

;===------------------------------------------------------------------------===;
; Extract element.
;===------------------------------------------------------------------------===;

; CHECK-LABEL: extract_i16_0_then_anyext:
; CHECK:       # %bb.0:
; CHECK-NEXT:  br $m10
 define i16 @extract_i16_0_then_anyext(<2 x i16> %x) {
   %retval = extractelement <2 x i16> %x, i32 0
   ret i16 %retval
}

; CHECK-LABEL: extract_i16_0_then_zext:
; CHECK:       # %bb.0:
; CHECK-NEXT:  sort4x16lo $m0, $m0, $m15
; CHECK-NEXT:  br $m10
 define zeroext i16 @extract_i16_0_then_zext(<2 x i16> %x) {
   %retval = extractelement <2 x i16> %x, i32 0
   ret i16 %retval
}

; CHECK-LABEL: extract_i16_0_then_sext:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shl $m0, $m0, 16
; CHECK-NEXT:  shrs $m0, $m0, 16
; CHECK-NEXT:  br $m10
 define signext i16 @extract_i16_0_then_sext(<2 x i16> %x) {
   %retval = extractelement <2 x i16> %x, i32 0
   ret i16 %retval
}

; CHECK-LABEL: extract_i16_1_then_anyext:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shr $m0, $m0, 16
; CHECK-NEXT:  br $m10
 define i16 @extract_i16_1_then_anyext(<2 x i16> %x) {
   %retval = extractelement <2 x i16> %x, i32 1
   ret i16 %retval
}

; CHECK-LABEL: extract_i16_1_then_zext:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shr $m0, $m0, 16
; CHECK-NEXT:  br $m10
 define zeroext i16 @extract_i16_1_then_zext(<2 x i16> %x) {
   %retval = extractelement <2 x i16> %x, i32 1
   ret i16 %retval
}

; CHECK-LABEL: extract_i16_1_then_sext:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shrs $m0, $m0, 16
; CHECK-NEXT:  br $m10
 define signext i16 @extract_i16_1_then_sext(<2 x i16> %x) {
   %retval = extractelement <2 x i16> %x, i32 1
   ret i16 %retval
}

; CHECK-LABEL: extract_i16_N:
; CHECK:       # %bb.0:
; CHECK-NEXT:  swap16 $m2, $m0
; CHECK-NEXT:  movnz $m0, $m1, $m2
; CHECK-NEXT:  br $m10
define i16 @extract_i16_N(<2 x i16> %x, i32 %idx) {
  %1 = extractelement <2 x i16> %x, i32 %idx
  ret i16 %1
}

; CHECK-LABEL: extract_i16_2:
; This is UB. Any output is fine, provided not a crash.
; CHECK:       br
define i16 @extract_i16_2(<2 x i16> %x)  {
  %1 = extractelement <2 x i16> %x, i32 2
  ret i16 %1
}
