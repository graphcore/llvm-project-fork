; RUN: llc < %s -mtriple=colossus -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -mtriple=colossus -mattr=+ipu2 | FileCheck %s

; The insert/extract N cases produce branchier code than would be hand written.
; The insert/extract at known N are optimal. On the basis that indices into
; vector will usually be deduced at compile time this is acceptable.
; The applicable test cases for N are specific and fragile, partly to detect
; when the codegen changes (for better or for worse);

;===------------------------------------------------------------------------===;
; Build vector.
;===------------------------------------------------------------------------===;

; CHECK-LABEL: test_build_v2i32_splat:
; This could be implemented by writing to a0 then copying to a1
; or vice versa. Assuming the reg allocator picks $m0 first
; because I can't specify this condition in filecheck
; CHECK:       setzi $m0, 42
; CHECK-NEXT:  mov $m1, $m0
; CHECK-NEXT:  br
define <2 x i32> @test_build_v2i32_splat(<2 x i32> %a) {
  ret <2 x i32> <i32 42, i32 42>
}

; CHECK-LABEL: build_from_zeros:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m15
; CHECK-NEXT:  mov $m1, $m15
; CHECK-NEXT:  br
define <2 x i32> @build_from_zeros() {
  ret <2 x i32> <i32 0, i32 0>
}

; CHECK-LABEL: build_from_all_ones:
; CHECK:       # %bb.0:
; CHECK-DAG:   add $m0, $m15, -1
; CHECK-DAG:   mov $m1, $m0
; CHECK-NEXT:  br
define <2 x i32> @build_from_all_ones() {
  ret <2 x i32> <i32 4294967295, i32 4294967295>
}

; CHECK-LABEL: build_from_minus_one:
; CHECK:       # %bb.0:
; CHECK-DAG:   add $m0, $m15, -1
; CHECK-DAG:   mov $m1, $m0
; CHECK-NEXT:  br
define <2 x i32> @build_from_minus_one() {
  ret <2 x i32> <i32 -1, i32 -1>
}

; CHECK-LABEL: test_build_v2i32_nop:
; %a1 and %a2 are in $m0 and $m1 already, so it's a no-op
; CHECK-NOT:   or
; CHECK-NOT:   setzi
; CHECK:       br
define <2 x i32> @test_build_v2i32_nop(i32 %a1, i32 %a2) {
  %res1 = insertelement <2 x i32> undef, i32 %a1, i32 0
  %res2 = insertelement <2 x i32> %res1, i32 %a2, i32 1
  ret <2 x i32> %res2
}

; CHECK-LABEL: test_build_v2i32:
; CHECK-DAG:   mov $m0, $m2
; CHECK-DAG:   mov $m1, $m3
; CHECK-NEXT:  br
define <2 x i32> @test_build_v2i32(i32 %ignore0, i32 %ignore1,
                                   i32 %a1, i32 %a2) {
  %res1 = insertelement <2 x i32> undef, i32 %a1, i32 0
  %res2 = insertelement <2 x i32> %res1, i32 %a2, i32 1
  ret <2 x i32> %res2
}

; CHECK-LABEL: build_from_constants:
; CHECK-DAG:   setzi $m0, 42
; CHECK-DAG:   setzi $m1, 81
; CHECK-NEXT:  br
define <2 x i32> @build_from_constants() {
  ret <2 x i32> <i32 42, i32 81>
}

;===------------------------------------------------------------------------===;
; Insert element.
;===------------------------------------------------------------------------===;

; CHECK-LABEL: insert_i32_0_undef
; CHECK:       mov $m0, $m1
; CHECK-NEXT:  br
define <2 x i32> @insert_i32_0_undef(i32 %ignore, i32 %x) {
  %1 = insertelement <2 x i32> undef, i32 %x, i32 0
  ret <2 x i32> %1
}

; CHECK-LABEL: insert_i32_1_undef
; CHECK:       mov $m1, $m0
; CHECK-NEXT:  br
define <2 x i32> @insert_i32_1_undef(i32 %x) {
  %1 = insertelement <2 x i32> undef, i32 %x, i32 1
  ret <2 x i32> %1
}

; CHECK-LABEL: insert_i32_0_undef_nop
; CHECK-NOT:   or
; CHECK:       br
define <2 x i32> @insert_i32_0_undef_nop(i32 %x) {
  %1 = insertelement <2 x i32> undef, i32 %x, i32 0
  ret <2 x i32> %1
}

; CHECK-LABEL: insert_i32_1_undef_nop
; CHECK-NOT:   or
; CHECK:       br
define <2 x i32> @insert_i32_1_undef_nop(i32 %ignore, i32 %x) {
  %1 = insertelement <2 x i32> undef, i32 %x, i32 1
  ret <2 x i32> %1
}

; CHECK-LABEL: insert_i32_N_undef
; CHECK:       mov $m0, $m1
; CHECK-DAG:   movnz $m1, $m2, $m1
; CHECK-DAG:   movnz $m0, $m2, $m0
; CHECK-NEXT:  br
define <2 x i32> @insert_i32_N_undef(i32 %ignore0,
                                     i32 %x, i32 %y) {
  %1 = insertelement <2 x i32> undef, i32 %x, i32 %y
  ret <2 x i32> %1
}

; CHECK-LABEL: insert_i32_N_undef_nop0
; Which values are passed to 'or' depends on how undef is handled
; This complicates the test case somewhat
; CHECK:       mov [[REGM1:\$m[0-9]+]], $m1
; CHECK-NEXT:  mov $m1, $m0
; CHECK-NOT:   break-check-dag-groups
; CHECK-DAG:   movnz $m1, [[REGM1]], $m1
; CHECK-DAG:   movnz $m0, [[REGM1]], $m0
; CHECK-NEXT:  br

define <2 x i32> @insert_i32_N_undef_nop0(i32 %x, i32 %y) {
  %1 = insertelement <2 x i32> undef, i32 %x, i32 %y
  ret <2 x i32> %1
}

; CHECK-LABEL: insert_i32_N_undef_nop1
; CHECK:       mov $m0, $m1
; CHECK-DAG:   movnz $m1, $m2, $m1
; CHECK-DAG:   movnz $m0, $m2, $m0
; CHECK-NEXT:  br $m10
define <2 x i32> @insert_i32_N_undef_nop1(i32 %ignore, i32 %x, i32 %y) {
  %1 = insertelement <2 x i32> undef, i32 %x, i32 %y
  ret <2 x i32> %1
}

; CHECK-LABEL: insert_i32_2_undef
; This is UB. Any output is fine, provided not a crash.
; CHECK:       br
define <2 x i32> @insert_i32_2_undef(i32 %x) {
  %1 = insertelement <2 x i32> undef, i32 %x, i32 2
  ret <2 x i32> %1
}

; CHECK-LABEL: insert_i32_0:
; CHECK:       mov $m0, $m2
; CHECK-NEXT:  br
define <2 x i32> @insert_i32_0(<2 x i32> %x, i32 %y) {
  %1 = insertelement <2 x i32> %x, i32 %y, i32 0
  ret <2 x i32> %1
}

; CHECK-LABEL: insert_i32_1:
; CHECK:       mov $m1, $m2
; CHECK-NEXT:  br
define <2 x i32> @insert_i32_1(<2 x i32> %x, i32 %y) {
  %1 = insertelement <2 x i32> %x, i32 %y, i32 1
  ret <2 x i32> %1
}

; CHECK-LABEL: insert_i32_N:
; This is not great either
; CHECK-DAG:   mov [[REGM0:\$m[0-9]+]], $m0
; CHECK-DAG:   mov [[REGM1:\$m[0-9]+]], $m1
; CHECK:       mov $m0, $m3
; CHECK-NOT:   break-check-dag-groups
; CHECK-DAG:   movnz $m1, $m2, $m3
; CHECK-DAG:   movnz $m0, $m2, [[REGM0]]
; CHECK:       br
define <2 x i32> @insert_i32_N(<2 x i32> %x, i32 %y, i32 %z) {
  %1 = insertelement <2 x i32> %x, i32 %z, i32 %y
  ret <2 x i32> %1
}

; CHECK-LABEL: insert_i32_2
; This is UB. Any output is fine, provided not a crash.
; CHECK:       br
define <2 x i32> @insert_i32_2(<2 x i32> %x, i32 %y) {
  %1 = insertelement <2 x i32> %x, i32 %y, i32 2
  ret <2 x i32> %1
}

;===------------------------------------------------------------------------===;
; Extract element.
;===------------------------------------------------------------------------===;

; CHECK-LABEL: extract_i32_0:
; CHECK:       mov $m0, $m2
; CHECK:       mov $m1, $m3
; CHECK-NEXT:  br
define i32 @extract_i32_0(i32 %ignore, <2 x i32> %x) {
  %1 = extractelement <2 x i32> %x, i32 0
  ret i32 %1
}

; CHECK-LABEL: extract_i32_0_nop:
; CHECK-NOT:   or
; CHECK-NOT:   mov
; CHECK:       br
define i32 @extract_i32_0_nop(<2 x i32> %x) {
  %1 = extractelement <2 x i32> %x, i32 0
  ret i32 %1
}

; CHECK-LABEL: extract_i32_1:
; CHECK:       mov $m0, $m1
; CHECK:       br
define i32 @extract_i32_1(<2 x i32> %x)  {
  %1 = extractelement <2 x i32> %x, i32 1
  ret i32 %1
}

; CHECK-LABEL: extract_i32_N:
; CHECK:       movnz $m2, $m1, $m3
; CHECK-NEXT:  mov $m0, $m2
; CHECK-NEXT:  br
define i32 @extract_i32_N(i32 %ignore, <2 x i32> %x, i32 %idx) {
  %1 = extractelement <2 x i32> %x, i32 %idx
  ret i32 %1
}

; CHECK-LABEL: extract_i32_N_nop:
; CHECK:       movnz $m0, $m2, $m1
; CHECK:       br
define i32 @extract_i32_N_nop(<2 x i32> %x, i32 %idx) {
  %1 = extractelement <2 x i32> %x, i32 %idx
  ret i32 %1
}

; CHECK-LABEL: extract_i32_2:
; This is UB. Any output is fine, provided not a crash.
; CHECK:       br
define i32 @extract_i32_2(<2 x i32> %x)  {
  %1 = extractelement <2 x i32> %x, i32 2
  ret i32 %1
}
