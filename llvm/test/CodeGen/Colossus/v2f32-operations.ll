; RUN: llc < %s -mtriple=colossus -colossus-coissue=false -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -mtriple=colossus -colossus-coissue=false -mattr=+ipu2 | FileCheck %s



; The insert/extract N cases produce branchier code than would be hand written.
; The insert/extract at known N are optimal. On the basis that indices into
; vector will usually be deduced at compile time this is acceptable.
; The applicable test cases for N are specific and fragile, partly to detect
; when the codegen changes (for better or for worse);

;===------------------------------------------------------------------------===;
; Build vector.
;===------------------------------------------------------------------------===;

; CHECK-LABEL: test_build_v2f32_splat:
; This could be implemented by writing to a0 then copying to a1
; or vice versa. Assuming the reg allocator picks $a0 first
; because I can't specify this condition in filecheck
; CHECK:       or $a0, $a15, 1073741824
; CHECK-NEXT:  mov $a1, $a0
; CHECK-NEXT:  br
define <2 x float> @test_build_v2f32_splat(<2 x float> %a) {
  ret <2 x float> <float 2.0, float 2.0>
}

; CHECK-LABEL: test_build_v2f32_nop:
; %a1 and %a2 are in $a0 and $a1 already, so it's a no-op
; CHECK-NOT:   or
; CHECK-NOT:   setzi
; CHECK:       br
define <2 x float> @test_build_v2f32_nop(float %a1, float %a2) {
  %res1 = insertelement <2 x float> undef, float %a1, i32 0
  %res2 = insertelement <2 x float> %res1, float %a2, i32 1
  ret <2 x float> %res2
}

; CHECK-LABEL: test_build_v2f32:
; CHECK:       mov $a0:1, $a2:3
; CHECK-NEXT:  br
define <2 x float> @test_build_v2f32(float %ignore0, float %ignore1,
                                     float %a1, float %a2) {
  %res1 = insertelement <2 x float> undef, float %a1, i32 0
  %res2 = insertelement <2 x float> %res1, float %a2, i32 1
  ret <2 x float> %res2
}

; CHECK-LABEL: build_from_constants:
; CHECK-DAG:   or $a0, $a15, 1073741824
; CHECK-DAG:   or $a1, $a15, 1077936128
; CHECK-NEXT:  br
define <2 x float> @build_from_constants() {
  ret <2 x float> <float 2.0, float 3.0>
}

; CHECK-LABEL: build_from_zeros:
; CHECK:       # %bb.0:
; CHECK-DAG:   zero $a0:1
; CHECK-NEXT:  br
define <2 x float> @build_from_zeros() {
  ret <2 x float> <float 0.0, float 0.0>
}

; CHECK-LABEL: build_from_all_ones:
; CHECK:       # %bb.0:
; CHECK-DAG:   not64 $a0:1, $a14:15
; CHECK-NEXT:  br
define <2 x float> @build_from_all_ones() {
  %c = bitcast i32 -1 to float
  %1 = insertelement <2 x float> undef, float %c, i32 0
  %2 = insertelement <2 x float> %1, float %c, i32 1
  ret <2 x float> %2
}

;===------------------------------------------------------------------------===;
; Insert element.
;===------------------------------------------------------------------------===;

; CHECK-LABEL: insert_float_0_undef
; CHECK:       mov $a0, $a1
; CHECK-NEXT:  br
define <2 x float> @insert_float_0_undef(float %ignore, float %x) {
  %1 = insertelement <2 x float> undef, float %x, i32 0
  ret <2 x float> %1
}

; CHECK-LABEL: insert_float_1_undef
; CHECK:       mov $a1, $a0
; CHECK-NEXT:  br
define <2 x float> @insert_float_1_undef(float %x) {
  %1 = insertelement <2 x float> undef, float %x, i32 1
  ret <2 x float> %1
}

; CHECK-LABEL: insert_float_0_undef_nop
; CHECK-NOT:   or
; CHECK:       br
define <2 x float> @insert_float_0_undef_nop(float %x) {
  %1 = insertelement <2 x float> undef, float %x, i32 0
  ret <2 x float> %1
}

; CHECK-LABEL: insert_float_1_undef_nop
; CHECK-NOT:   or
; CHECK:       br
define <2 x float> @insert_float_1_undef_nop(float %ignore, float %x) {
  %1 = insertelement <2 x float> undef, float %x, i32 1
  ret <2 x float> %1
}

; CHECK-LABEL: insert_float_N_undef
; CHECK-DAG:   brnz $m0
; CHECK-DAG:   mov $a1, $a2
; CHECK-DAG:   mov $a0, $a1
; CHECK:       br
define <2 x float> @insert_float_N_undef(float %ignore0, float %ignore1,
                                         float %x, i32 %y) {
  %1 = insertelement <2 x float> undef, float %x, i32 %y
  ret <2 x float> %1
}

; CHECK-LABEL: insert_float_N_undef_nop0
; This is currently suboptimal. Generated code:
;       mov $a1, $a0
;       brnz $m0, label
;       mov $a0, $a1
; label:
;       br $m10
; Preferred code:
;       brz $m0, label
;       mov $a1, $a0
; label:
;       br $m10
; CHECK-DAG:   brnz $m0
; CHECK-DAG:   mov $a1, $a0
; CHECK-DAG:   mov $a0, $a1
; CHECK:       br
define <2 x float> @insert_float_N_undef_nop0(float %x, i32 %y) {
  %1 = insertelement <2 x float> undef, float %x, i32 %y
  ret <2 x float> %1
}

; CHECK-LABEL: insert_float_N_undef_nop1
; This is currently optimal.
; CHECK-DAG:   brnz $m0
; CHECK-NOT:   mov $a1, $a0
; CHECK-DAG:   mov $a0, $a1
; CHECK:       br
define <2 x float> @insert_float_N_undef_nop1(float %ignore, float %x, i32 %y) {
  %1 = insertelement <2 x float> undef, float %x, i32 %y
  ret <2 x float> %1
}

; CHECK-LABEL: insert_float_2_undef
; This is UB. Any output is fine, provided not a crash.
; CHECK:       br
define <2 x float> @insert_float_2_undef(float %x) {
  %1 = insertelement <2 x float> undef, float %x, i32 2
  ret <2 x float> %1
}

; CHECK-LABEL: insert_float_0:
; CHECK:       mov $a0, $a2
; CHECK-NEXT:  br
define <2 x float> @insert_float_0(<2 x float> %x, float %y) {
  %1 = insertelement <2 x float> %x, float %y, i32 0
  ret <2 x float> %1
}

; CHECK-LABEL: insert_float_1:
; CHECK:       mov $a1, $a2
; CHECK-NEXT:  br
define <2 x float> @insert_float_1(<2 x float> %x, float %y) {
  %1 = insertelement <2 x float> %x, float %y, i32 1
  ret <2 x float> %1
}

; CHECK-LABEL: insert_float_N:
; CHECK-DAG:   brz $m0
; CHECK-DAG:   mov $a1, $a2
; CHECK-DAG:   br $m10
; CHECK-DAG:   mov $a0, $a2
; CHECK-DAG:   br $m10
define <2 x float> @insert_float_N(<2 x float> %x, i32 %y, float %z) {
  %1 = insertelement <2 x float> %x, float %z, i32 %y
  ret <2 x float> %1
}

; CHECK-LABEL: insert_float_2
; This is UB. Any output is fine, provided not a crash.
; CHECK:       br
define <2 x float> @insert_float_2(<2 x float> %x, float %y) {
  %1 = insertelement <2 x float> %x, float %y, i32 2
  ret <2 x float> %1
}

;===------------------------------------------------------------------------===;
; Extract element.
;===------------------------------------------------------------------------===;

; CHECK-LABEL: extract_float_0:
; CHECK:       mov  $a0:1, $a2:3
; CHECK-NEXT:  br
define float @extract_float_0(float %ignore, <2 x float> %x) {
  %1 = extractelement <2 x float> %x, i32 0
  ret float %1
}

; CHECK-LABEL: extract_float_0_nop:
; CHECK-NOT:   or
; CHECK-NOT:   mov
; CHECK:       br
define float @extract_float_0_nop(<2 x float> %x) {
  %1 = extractelement <2 x float> %x, i32 0
  ret float %1
}

; CHECK-LABEL: extract_float_1:
; CHECK:       mov $a0, $a1
; CHECK:       br
define float @extract_float_1(<2 x float> %x)  {
  %1 = extractelement <2 x float> %x, i32 1
  ret float %1
}

; CHECK-LABEL: extract_float_N:
; CHECK-DAG:   brnz $m0
; CHECK-DAG:   mov $a3, $a2
; CHECK-DAG:   mov $a0, $a3
; CHECK:       br
define float @extract_float_N(float %ignore, <2 x float> %x, i32 %idx) {
  %1 = extractelement <2 x float> %x, i32 %idx
  ret float %1
}

; CHECK-LABEL: extract_float_N_nop:
; CHECK-DAG:   brnz $m0
; CHECK-DAG:   mov $a1, $a0
; CHECK-DAG:   mov $a0, $a1
; CHECK:       br
define float @extract_float_N_nop(<2 x float> %x, i32 %idx) {
  %1 = extractelement <2 x float> %x, i32 %idx
  ret float %1
}

; CHECK-LABEL: extract_float_2:
; This is UB. Any output is fine, provided not a crash.
; CHECK:       br
define float @extract_float_2(<2 x float> %x)  {
  %1 = extractelement <2 x float> %x, i32 2
  ret float %1
}
