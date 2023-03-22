; RUN: llc < %s -march=colossus -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -march=colossus -mattr=+ipu2 | FileCheck %s
target triple = "colossus-graphcore--elf"

; CC: scalarise
; CHECK-LABEL: extract_0_from_v1i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i1 @extract_0_from_v1i1(i32 %ignore, <1 x i1> %x) {
  %res = extractelement <1 x i1> %x, i32 0
  ret i1 %res
}
; CC: pass as v2i16
; CHECK-LABEL: extract_0_from_v2i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i1 @extract_0_from_v2i1(i32 %ignore, <2 x i1> %x) {
  %res = extractelement <2 x i1> %x, i32 0
  ret i1 %res
}
; CC: pass as v2i16
; CHECK-LABEL: extract_1_from_v2i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:  swap16 $m0, $m1
; CHECK:       br $m10
define i1 @extract_1_from_v2i1(i32 %ignore, <2 x i1> %x) {
  %res = extractelement <2 x i1> %x, i32 1
  ret i1 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v3i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i1 @extract_0_from_v3i1(i32 %ignore, <3 x i1> %x) {
  %res = extractelement <3 x i1> %x, i32 0
  ret i1 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v3i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i1 @extract_1_from_v3i1(i32 %ignore, <3 x i1> %x) {
  %res = extractelement <3 x i1> %x, i32 1
  ret i1 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v3i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i1 @extract_2_from_v3i1(i32 %ignore, <3 x i1> %x) {
  %res = extractelement <3 x i1> %x, i32 2
  ret i1 %res
}
; CC: pass as v4i16
; CHECK-LABEL: extract_0_from_v4i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK-NEXT:  mov $m1, $m3
; CHECK:       br $m10
define i1 @extract_0_from_v4i1(i32 %ignore, <4 x i1> %x) {
  %res = extractelement <4 x i1> %x, i32 0
  ret i1 %res
}
; CC: pass as v4i16
; CHECK-LABEL: extract_1_from_v4i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:  swap16 $m0, $m2
; CHECK:       br $m10
define i1 @extract_1_from_v4i1(i32 %ignore, <4 x i1> %x) {
  %res = extractelement <4 x i1> %x, i32 1
  ret i1 %res
}
; CC: pass as v4i16
; CHECK-LABEL: extract_2_from_v4i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i1 @extract_2_from_v4i1(i32 %ignore, <4 x i1> %x) {
  %res = extractelement <4 x i1> %x, i32 2
  ret i1 %res
}
; CC: pass as v4i16
; CHECK-LABEL: extract_3_from_v4i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:  swap16 $m0, $m3
; CHECK:       br $m10
define i1 @extract_3_from_v4i1(i32 %ignore, <4 x i1> %x) {
  %res = extractelement <4 x i1> %x, i32 3
  ret i1 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v5i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i1 @extract_0_from_v5i1(i32 %ignore, <5 x i1> %x) {
  %res = extractelement <5 x i1> %x, i32 0
  ret i1 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v5i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i1 @extract_1_from_v5i1(i32 %ignore, <5 x i1> %x) {
  %res = extractelement <5 x i1> %x, i32 1
  ret i1 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v5i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i1 @extract_2_from_v5i1(i32 %ignore, <5 x i1> %x) {
  %res = extractelement <5 x i1> %x, i32 2
  ret i1 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v5i1:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i1 @extract_3_from_v5i1(i32 %ignore, <5 x i1> %x) {
  %res = extractelement <5 x i1> %x, i32 3
  ret i1 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v5i1:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i1 @extract_4_from_v5i1(i32 %ignore, <5 x i1> %x) {
  %res = extractelement <5 x i1> %x, i32 4
  ret i1 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v6i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i1 @extract_0_from_v6i1(i32 %ignore, <6 x i1> %x) {
  %res = extractelement <6 x i1> %x, i32 0
  ret i1 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v6i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i1 @extract_1_from_v6i1(i32 %ignore, <6 x i1> %x) {
  %res = extractelement <6 x i1> %x, i32 1
  ret i1 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v6i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i1 @extract_2_from_v6i1(i32 %ignore, <6 x i1> %x) {
  %res = extractelement <6 x i1> %x, i32 2
  ret i1 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v6i1:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i1 @extract_3_from_v6i1(i32 %ignore, <6 x i1> %x) {
  %res = extractelement <6 x i1> %x, i32 3
  ret i1 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v6i1:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i1 @extract_4_from_v6i1(i32 %ignore, <6 x i1> %x) {
  %res = extractelement <6 x i1> %x, i32 4
  ret i1 %res
}
; CC: scalarise
; CHECK-LABEL: extract_5_from_v6i1:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 2
; CHECK:       br $m10
define i1 @extract_5_from_v6i1(i32 %ignore, <6 x i1> %x) {
  %res = extractelement <6 x i1> %x, i32 5
  ret i1 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v7i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i1 @extract_0_from_v7i1(i32 %ignore, <7 x i1> %x) {
  %res = extractelement <7 x i1> %x, i32 0
  ret i1 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v7i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i1 @extract_1_from_v7i1(i32 %ignore, <7 x i1> %x) {
  %res = extractelement <7 x i1> %x, i32 1
  ret i1 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v7i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i1 @extract_2_from_v7i1(i32 %ignore, <7 x i1> %x) {
  %res = extractelement <7 x i1> %x, i32 2
  ret i1 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v7i1:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i1 @extract_3_from_v7i1(i32 %ignore, <7 x i1> %x) {
  %res = extractelement <7 x i1> %x, i32 3
  ret i1 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v7i1:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i1 @extract_4_from_v7i1(i32 %ignore, <7 x i1> %x) {
  %res = extractelement <7 x i1> %x, i32 4
  ret i1 %res
}
; CC: scalarise
; CHECK-LABEL: extract_5_from_v7i1:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 2
; CHECK:       br $m10
define i1 @extract_5_from_v7i1(i32 %ignore, <7 x i1> %x) {
  %res = extractelement <7 x i1> %x, i32 5
  ret i1 %res
}
; CC: scalarise
; CHECK-LABEL: extract_6_from_v7i1:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 3
; CHECK:       br $m10
define i1 @extract_6_from_v7i1(i32 %ignore, <7 x i1> %x) {
  %res = extractelement <7 x i1> %x, i32 6
  ret i1 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v8i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i1 @extract_0_from_v8i1(i32 %ignore, <8 x i1> %x) {
  %res = extractelement <8 x i1> %x, i32 0
  ret i1 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v8i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i1 @extract_1_from_v8i1(i32 %ignore, <8 x i1> %x) {
  %res = extractelement <8 x i1> %x, i32 1
  ret i1 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v8i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i1 @extract_2_from_v8i1(i32 %ignore, <8 x i1> %x) {
  %res = extractelement <8 x i1> %x, i32 2
  ret i1 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v8i1:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i1 @extract_3_from_v8i1(i32 %ignore, <8 x i1> %x) {
  %res = extractelement <8 x i1> %x, i32 3
  ret i1 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v8i1:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i1 @extract_4_from_v8i1(i32 %ignore, <8 x i1> %x) {
  %res = extractelement <8 x i1> %x, i32 4
  ret i1 %res
}
; CC: scalarise
; CHECK-LABEL: extract_5_from_v8i1:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 2
; CHECK:       br $m10
define i1 @extract_5_from_v8i1(i32 %ignore, <8 x i1> %x) {
  %res = extractelement <8 x i1> %x, i32 5
  ret i1 %res
}
; CC: scalarise
; CHECK-LABEL: extract_6_from_v8i1:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 3
; CHECK:       br $m10
define i1 @extract_6_from_v8i1(i32 %ignore, <8 x i1> %x) {
  %res = extractelement <8 x i1> %x, i32 6
  ret i1 %res
}
; CC: scalarise
; CHECK-LABEL: extract_7_from_v8i1:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 4
; CHECK:       br $m10
define i1 @extract_7_from_v8i1(i32 %ignore, <8 x i1> %x) {
  %res = extractelement <8 x i1> %x, i32 7
  ret i1 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v1i2:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i2 @extract_0_from_v1i2(i32 %ignore, <1 x i2> %x) {
  %res = extractelement <1 x i2> %x, i32 0
  ret i2 %res
}
; CC: pass as v2i16
; CHECK-LABEL: extract_0_from_v2i2:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i2 @extract_0_from_v2i2(i32 %ignore, <2 x i2> %x) {
  %res = extractelement <2 x i2> %x, i32 0
  ret i2 %res
}
; CC: pass as v2i16
; CHECK-LABEL: extract_1_from_v2i2:
; CHECK:       # %bb.0:
; CHECK-NEXT:  swap16 $m0, $m1
; CHECK:       br $m10
define i2 @extract_1_from_v2i2(i32 %ignore, <2 x i2> %x) {
  %res = extractelement <2 x i2> %x, i32 1
  ret i2 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v3i2:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i2 @extract_0_from_v3i2(i32 %ignore, <3 x i2> %x) {
  %res = extractelement <3 x i2> %x, i32 0
  ret i2 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v3i2:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i2 @extract_1_from_v3i2(i32 %ignore, <3 x i2> %x) {
  %res = extractelement <3 x i2> %x, i32 1
  ret i2 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v3i2:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i2 @extract_2_from_v3i2(i32 %ignore, <3 x i2> %x) {
  %res = extractelement <3 x i2> %x, i32 2
  ret i2 %res
}
; CC: pass as v4i16
; CHECK-LABEL: extract_0_from_v4i2:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK-NEXT:  mov $m1, $m3
; CHECK:       br $m10
define i2 @extract_0_from_v4i2(i32 %ignore, <4 x i2> %x) {
  %res = extractelement <4 x i2> %x, i32 0
  ret i2 %res
}
; CC: pass as v4i16
; CHECK-LABEL: extract_1_from_v4i2:
; CHECK:       # %bb.0:
; CHECK-NEXT:  swap16 $m0, $m2
; CHECK:       br $m10
define i2 @extract_1_from_v4i2(i32 %ignore, <4 x i2> %x) {
  %res = extractelement <4 x i2> %x, i32 1
  ret i2 %res
}
; CC: pass as v4i16
; CHECK-LABEL: extract_2_from_v4i2:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i2 @extract_2_from_v4i2(i32 %ignore, <4 x i2> %x) {
  %res = extractelement <4 x i2> %x, i32 2
  ret i2 %res
}
; CC: pass as v4i16
; CHECK-LABEL: extract_3_from_v4i2:
; CHECK:       # %bb.0:
; CHECK-NEXT:  swap16 $m0, $m3
; CHECK:       br $m10
define i2 @extract_3_from_v4i2(i32 %ignore, <4 x i2> %x) {
  %res = extractelement <4 x i2> %x, i32 3
  ret i2 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v5i2:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i2 @extract_0_from_v5i2(i32 %ignore, <5 x i2> %x) {
  %res = extractelement <5 x i2> %x, i32 0
  ret i2 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v5i2:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i2 @extract_1_from_v5i2(i32 %ignore, <5 x i2> %x) {
  %res = extractelement <5 x i2> %x, i32 1
  ret i2 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v5i2:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i2 @extract_2_from_v5i2(i32 %ignore, <5 x i2> %x) {
  %res = extractelement <5 x i2> %x, i32 2
  ret i2 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v5i2:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i2 @extract_3_from_v5i2(i32 %ignore, <5 x i2> %x) {
  %res = extractelement <5 x i2> %x, i32 3
  ret i2 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v5i2:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i2 @extract_4_from_v5i2(i32 %ignore, <5 x i2> %x) {
  %res = extractelement <5 x i2> %x, i32 4
  ret i2 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v6i2:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i2 @extract_0_from_v6i2(i32 %ignore, <6 x i2> %x) {
  %res = extractelement <6 x i2> %x, i32 0
  ret i2 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v6i2:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i2 @extract_1_from_v6i2(i32 %ignore, <6 x i2> %x) {
  %res = extractelement <6 x i2> %x, i32 1
  ret i2 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v6i2:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i2 @extract_2_from_v6i2(i32 %ignore, <6 x i2> %x) {
  %res = extractelement <6 x i2> %x, i32 2
  ret i2 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v6i2:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i2 @extract_3_from_v6i2(i32 %ignore, <6 x i2> %x) {
  %res = extractelement <6 x i2> %x, i32 3
  ret i2 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v6i2:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i2 @extract_4_from_v6i2(i32 %ignore, <6 x i2> %x) {
  %res = extractelement <6 x i2> %x, i32 4
  ret i2 %res
}
; CC: scalarise
; CHECK-LABEL: extract_5_from_v6i2:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 2
; CHECK:       br $m10
define i2 @extract_5_from_v6i2(i32 %ignore, <6 x i2> %x) {
  %res = extractelement <6 x i2> %x, i32 5
  ret i2 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v7i2:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i2 @extract_0_from_v7i2(i32 %ignore, <7 x i2> %x) {
  %res = extractelement <7 x i2> %x, i32 0
  ret i2 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v7i2:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i2 @extract_1_from_v7i2(i32 %ignore, <7 x i2> %x) {
  %res = extractelement <7 x i2> %x, i32 1
  ret i2 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v7i2:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i2 @extract_2_from_v7i2(i32 %ignore, <7 x i2> %x) {
  %res = extractelement <7 x i2> %x, i32 2
  ret i2 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v7i2:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i2 @extract_3_from_v7i2(i32 %ignore, <7 x i2> %x) {
  %res = extractelement <7 x i2> %x, i32 3
  ret i2 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v7i2:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i2 @extract_4_from_v7i2(i32 %ignore, <7 x i2> %x) {
  %res = extractelement <7 x i2> %x, i32 4
  ret i2 %res
}
; CC: scalarise
; CHECK-LABEL: extract_5_from_v7i2:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 2
; CHECK:       br $m10
define i2 @extract_5_from_v7i2(i32 %ignore, <7 x i2> %x) {
  %res = extractelement <7 x i2> %x, i32 5
  ret i2 %res
}
; CC: scalarise
; CHECK-LABEL: extract_6_from_v7i2:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 3
; CHECK:       br $m10
define i2 @extract_6_from_v7i2(i32 %ignore, <7 x i2> %x) {
  %res = extractelement <7 x i2> %x, i32 6
  ret i2 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v8i2:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i2 @extract_0_from_v8i2(i32 %ignore, <8 x i2> %x) {
  %res = extractelement <8 x i2> %x, i32 0
  ret i2 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v8i2:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i2 @extract_1_from_v8i2(i32 %ignore, <8 x i2> %x) {
  %res = extractelement <8 x i2> %x, i32 1
  ret i2 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v8i2:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i2 @extract_2_from_v8i2(i32 %ignore, <8 x i2> %x) {
  %res = extractelement <8 x i2> %x, i32 2
  ret i2 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v8i2:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i2 @extract_3_from_v8i2(i32 %ignore, <8 x i2> %x) {
  %res = extractelement <8 x i2> %x, i32 3
  ret i2 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v8i2:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i2 @extract_4_from_v8i2(i32 %ignore, <8 x i2> %x) {
  %res = extractelement <8 x i2> %x, i32 4
  ret i2 %res
}
; CC: scalarise
; CHECK-LABEL: extract_5_from_v8i2:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 2
; CHECK:       br $m10
define i2 @extract_5_from_v8i2(i32 %ignore, <8 x i2> %x) {
  %res = extractelement <8 x i2> %x, i32 5
  ret i2 %res
}
; CC: scalarise
; CHECK-LABEL: extract_6_from_v8i2:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 3
; CHECK:       br $m10
define i2 @extract_6_from_v8i2(i32 %ignore, <8 x i2> %x) {
  %res = extractelement <8 x i2> %x, i32 6
  ret i2 %res
}
; CC: scalarise
; CHECK-LABEL: extract_7_from_v8i2:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 4
; CHECK:       br $m10
define i2 @extract_7_from_v8i2(i32 %ignore, <8 x i2> %x) {
  %res = extractelement <8 x i2> %x, i32 7
  ret i2 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v1i3:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i3 @extract_0_from_v1i3(i32 %ignore, <1 x i3> %x) {
  %res = extractelement <1 x i3> %x, i32 0
  ret i3 %res
}
; CC: pass as v2i16
; CHECK-LABEL: extract_0_from_v2i3:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i3 @extract_0_from_v2i3(i32 %ignore, <2 x i3> %x) {
  %res = extractelement <2 x i3> %x, i32 0
  ret i3 %res
}
; CC: pass as v2i16
; CHECK-LABEL: extract_1_from_v2i3:
; CHECK:       # %bb.0:
; CHECK-NEXT:  swap16 $m0, $m1
; CHECK:       br $m10
define i3 @extract_1_from_v2i3(i32 %ignore, <2 x i3> %x) {
  %res = extractelement <2 x i3> %x, i32 1
  ret i3 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v3i3:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i3 @extract_0_from_v3i3(i32 %ignore, <3 x i3> %x) {
  %res = extractelement <3 x i3> %x, i32 0
  ret i3 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v3i3:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i3 @extract_1_from_v3i3(i32 %ignore, <3 x i3> %x) {
  %res = extractelement <3 x i3> %x, i32 1
  ret i3 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v3i3:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i3 @extract_2_from_v3i3(i32 %ignore, <3 x i3> %x) {
  %res = extractelement <3 x i3> %x, i32 2
  ret i3 %res
}
; CC: pass as v4i16
; CHECK-LABEL: extract_0_from_v4i3:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK-NEXT:  mov $m1, $m3
; CHECK:       br $m10
define i3 @extract_0_from_v4i3(i32 %ignore, <4 x i3> %x) {
  %res = extractelement <4 x i3> %x, i32 0
  ret i3 %res
}
; CC: pass as v4i16
; CHECK-LABEL: extract_1_from_v4i3:
; CHECK:       # %bb.0:
; CHECK-NEXT:  swap16 $m0, $m2
; CHECK:       br $m10
define i3 @extract_1_from_v4i3(i32 %ignore, <4 x i3> %x) {
  %res = extractelement <4 x i3> %x, i32 1
  ret i3 %res
}
; CC: pass as v4i16
; CHECK-LABEL: extract_2_from_v4i3:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i3 @extract_2_from_v4i3(i32 %ignore, <4 x i3> %x) {
  %res = extractelement <4 x i3> %x, i32 2
  ret i3 %res
}
; CC: pass as v4i16
; CHECK-LABEL: extract_3_from_v4i3:
; CHECK:       # %bb.0:
; CHECK-NEXT:  swap16 $m0, $m3
; CHECK:       br $m10
define i3 @extract_3_from_v4i3(i32 %ignore, <4 x i3> %x) {
  %res = extractelement <4 x i3> %x, i32 3
  ret i3 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v5i3:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i3 @extract_0_from_v5i3(i32 %ignore, <5 x i3> %x) {
  %res = extractelement <5 x i3> %x, i32 0
  ret i3 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v5i3:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i3 @extract_1_from_v5i3(i32 %ignore, <5 x i3> %x) {
  %res = extractelement <5 x i3> %x, i32 1
  ret i3 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v5i3:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i3 @extract_2_from_v5i3(i32 %ignore, <5 x i3> %x) {
  %res = extractelement <5 x i3> %x, i32 2
  ret i3 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v5i3:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i3 @extract_3_from_v5i3(i32 %ignore, <5 x i3> %x) {
  %res = extractelement <5 x i3> %x, i32 3
  ret i3 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v5i3:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i3 @extract_4_from_v5i3(i32 %ignore, <5 x i3> %x) {
  %res = extractelement <5 x i3> %x, i32 4
  ret i3 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v6i3:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i3 @extract_0_from_v6i3(i32 %ignore, <6 x i3> %x) {
  %res = extractelement <6 x i3> %x, i32 0
  ret i3 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v6i3:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i3 @extract_1_from_v6i3(i32 %ignore, <6 x i3> %x) {
  %res = extractelement <6 x i3> %x, i32 1
  ret i3 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v6i3:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i3 @extract_2_from_v6i3(i32 %ignore, <6 x i3> %x) {
  %res = extractelement <6 x i3> %x, i32 2
  ret i3 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v6i3:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i3 @extract_3_from_v6i3(i32 %ignore, <6 x i3> %x) {
  %res = extractelement <6 x i3> %x, i32 3
  ret i3 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v6i3:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i3 @extract_4_from_v6i3(i32 %ignore, <6 x i3> %x) {
  %res = extractelement <6 x i3> %x, i32 4
  ret i3 %res
}
; CC: scalarise
; CHECK-LABEL: extract_5_from_v6i3:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 2
; CHECK:       br $m10
define i3 @extract_5_from_v6i3(i32 %ignore, <6 x i3> %x) {
  %res = extractelement <6 x i3> %x, i32 5
  ret i3 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v7i3:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i3 @extract_0_from_v7i3(i32 %ignore, <7 x i3> %x) {
  %res = extractelement <7 x i3> %x, i32 0
  ret i3 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v7i3:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i3 @extract_1_from_v7i3(i32 %ignore, <7 x i3> %x) {
  %res = extractelement <7 x i3> %x, i32 1
  ret i3 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v7i3:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i3 @extract_2_from_v7i3(i32 %ignore, <7 x i3> %x) {
  %res = extractelement <7 x i3> %x, i32 2
  ret i3 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v7i3:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i3 @extract_3_from_v7i3(i32 %ignore, <7 x i3> %x) {
  %res = extractelement <7 x i3> %x, i32 3
  ret i3 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v7i3:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i3 @extract_4_from_v7i3(i32 %ignore, <7 x i3> %x) {
  %res = extractelement <7 x i3> %x, i32 4
  ret i3 %res
}
; CC: scalarise
; CHECK-LABEL: extract_5_from_v7i3:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 2
; CHECK:       br $m10
define i3 @extract_5_from_v7i3(i32 %ignore, <7 x i3> %x) {
  %res = extractelement <7 x i3> %x, i32 5
  ret i3 %res
}
; CC: scalarise
; CHECK-LABEL: extract_6_from_v7i3:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 3
; CHECK:       br $m10
define i3 @extract_6_from_v7i3(i32 %ignore, <7 x i3> %x) {
  %res = extractelement <7 x i3> %x, i32 6
  ret i3 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v8i3:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i3 @extract_0_from_v8i3(i32 %ignore, <8 x i3> %x) {
  %res = extractelement <8 x i3> %x, i32 0
  ret i3 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v8i3:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i3 @extract_1_from_v8i3(i32 %ignore, <8 x i3> %x) {
  %res = extractelement <8 x i3> %x, i32 1
  ret i3 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v8i3:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i3 @extract_2_from_v8i3(i32 %ignore, <8 x i3> %x) {
  %res = extractelement <8 x i3> %x, i32 2
  ret i3 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v8i3:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i3 @extract_3_from_v8i3(i32 %ignore, <8 x i3> %x) {
  %res = extractelement <8 x i3> %x, i32 3
  ret i3 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v8i3:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i3 @extract_4_from_v8i3(i32 %ignore, <8 x i3> %x) {
  %res = extractelement <8 x i3> %x, i32 4
  ret i3 %res
}
; CC: scalarise
; CHECK-LABEL: extract_5_from_v8i3:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 2
; CHECK:       br $m10
define i3 @extract_5_from_v8i3(i32 %ignore, <8 x i3> %x) {
  %res = extractelement <8 x i3> %x, i32 5
  ret i3 %res
}
; CC: scalarise
; CHECK-LABEL: extract_6_from_v8i3:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 3
; CHECK:       br $m10
define i3 @extract_6_from_v8i3(i32 %ignore, <8 x i3> %x) {
  %res = extractelement <8 x i3> %x, i32 6
  ret i3 %res
}
; CC: scalarise
; CHECK-LABEL: extract_7_from_v8i3:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 4
; CHECK:       br $m10
define i3 @extract_7_from_v8i3(i32 %ignore, <8 x i3> %x) {
  %res = extractelement <8 x i3> %x, i32 7
  ret i3 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v1i4:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i4 @extract_0_from_v1i4(i32 %ignore, <1 x i4> %x) {
  %res = extractelement <1 x i4> %x, i32 0
  ret i4 %res
}
; CC: pass as v2i16
; CHECK-LABEL: extract_0_from_v2i4:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i4 @extract_0_from_v2i4(i32 %ignore, <2 x i4> %x) {
  %res = extractelement <2 x i4> %x, i32 0
  ret i4 %res
}
; CC: pass as v2i16
; CHECK-LABEL: extract_1_from_v2i4:
; CHECK:       # %bb.0:
; CHECK-NEXT:  swap16 $m0, $m1
; CHECK:       br $m10
define i4 @extract_1_from_v2i4(i32 %ignore, <2 x i4> %x) {
  %res = extractelement <2 x i4> %x, i32 1
  ret i4 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v3i4:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i4 @extract_0_from_v3i4(i32 %ignore, <3 x i4> %x) {
  %res = extractelement <3 x i4> %x, i32 0
  ret i4 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v3i4:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i4 @extract_1_from_v3i4(i32 %ignore, <3 x i4> %x) {
  %res = extractelement <3 x i4> %x, i32 1
  ret i4 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v3i4:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i4 @extract_2_from_v3i4(i32 %ignore, <3 x i4> %x) {
  %res = extractelement <3 x i4> %x, i32 2
  ret i4 %res
}
; CC: pass as v4i16
; CHECK-LABEL: extract_0_from_v4i4:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK-NEXT:  mov $m1, $m3
; CHECK:       br $m10
define i4 @extract_0_from_v4i4(i32 %ignore, <4 x i4> %x) {
  %res = extractelement <4 x i4> %x, i32 0
  ret i4 %res
}
; CC: pass as v4i16
; CHECK-LABEL: extract_1_from_v4i4:
; CHECK:       # %bb.0:
; CHECK-NEXT:  swap16 $m0, $m2
; CHECK:       br $m10
define i4 @extract_1_from_v4i4(i32 %ignore, <4 x i4> %x) {
  %res = extractelement <4 x i4> %x, i32 1
  ret i4 %res
}
; CC: pass as v4i16
; CHECK-LABEL: extract_2_from_v4i4:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i4 @extract_2_from_v4i4(i32 %ignore, <4 x i4> %x) {
  %res = extractelement <4 x i4> %x, i32 2
  ret i4 %res
}
; CC: pass as v4i16
; CHECK-LABEL: extract_3_from_v4i4:
; CHECK:       # %bb.0:
; CHECK-NEXT:  swap16 $m0, $m3
; CHECK:       br $m10
define i4 @extract_3_from_v4i4(i32 %ignore, <4 x i4> %x) {
  %res = extractelement <4 x i4> %x, i32 3
  ret i4 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v5i4:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i4 @extract_0_from_v5i4(i32 %ignore, <5 x i4> %x) {
  %res = extractelement <5 x i4> %x, i32 0
  ret i4 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v5i4:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i4 @extract_1_from_v5i4(i32 %ignore, <5 x i4> %x) {
  %res = extractelement <5 x i4> %x, i32 1
  ret i4 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v5i4:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i4 @extract_2_from_v5i4(i32 %ignore, <5 x i4> %x) {
  %res = extractelement <5 x i4> %x, i32 2
  ret i4 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v5i4:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i4 @extract_3_from_v5i4(i32 %ignore, <5 x i4> %x) {
  %res = extractelement <5 x i4> %x, i32 3
  ret i4 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v5i4:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i4 @extract_4_from_v5i4(i32 %ignore, <5 x i4> %x) {
  %res = extractelement <5 x i4> %x, i32 4
  ret i4 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v6i4:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i4 @extract_0_from_v6i4(i32 %ignore, <6 x i4> %x) {
  %res = extractelement <6 x i4> %x, i32 0
  ret i4 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v6i4:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i4 @extract_1_from_v6i4(i32 %ignore, <6 x i4> %x) {
  %res = extractelement <6 x i4> %x, i32 1
  ret i4 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v6i4:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i4 @extract_2_from_v6i4(i32 %ignore, <6 x i4> %x) {
  %res = extractelement <6 x i4> %x, i32 2
  ret i4 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v6i4:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i4 @extract_3_from_v6i4(i32 %ignore, <6 x i4> %x) {
  %res = extractelement <6 x i4> %x, i32 3
  ret i4 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v6i4:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i4 @extract_4_from_v6i4(i32 %ignore, <6 x i4> %x) {
  %res = extractelement <6 x i4> %x, i32 4
  ret i4 %res
}
; CC: scalarise
; CHECK-LABEL: extract_5_from_v6i4:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 2
; CHECK:       br $m10
define i4 @extract_5_from_v6i4(i32 %ignore, <6 x i4> %x) {
  %res = extractelement <6 x i4> %x, i32 5
  ret i4 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v7i4:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i4 @extract_0_from_v7i4(i32 %ignore, <7 x i4> %x) {
  %res = extractelement <7 x i4> %x, i32 0
  ret i4 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v7i4:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i4 @extract_1_from_v7i4(i32 %ignore, <7 x i4> %x) {
  %res = extractelement <7 x i4> %x, i32 1
  ret i4 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v7i4:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i4 @extract_2_from_v7i4(i32 %ignore, <7 x i4> %x) {
  %res = extractelement <7 x i4> %x, i32 2
  ret i4 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v7i4:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i4 @extract_3_from_v7i4(i32 %ignore, <7 x i4> %x) {
  %res = extractelement <7 x i4> %x, i32 3
  ret i4 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v7i4:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i4 @extract_4_from_v7i4(i32 %ignore, <7 x i4> %x) {
  %res = extractelement <7 x i4> %x, i32 4
  ret i4 %res
}
; CC: scalarise
; CHECK-LABEL: extract_5_from_v7i4:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 2
; CHECK:       br $m10
define i4 @extract_5_from_v7i4(i32 %ignore, <7 x i4> %x) {
  %res = extractelement <7 x i4> %x, i32 5
  ret i4 %res
}
; CC: scalarise
; CHECK-LABEL: extract_6_from_v7i4:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 3
; CHECK:       br $m10
define i4 @extract_6_from_v7i4(i32 %ignore, <7 x i4> %x) {
  %res = extractelement <7 x i4> %x, i32 6
  ret i4 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v8i4:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i4 @extract_0_from_v8i4(i32 %ignore, <8 x i4> %x) {
  %res = extractelement <8 x i4> %x, i32 0
  ret i4 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v8i4:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i4 @extract_1_from_v8i4(i32 %ignore, <8 x i4> %x) {
  %res = extractelement <8 x i4> %x, i32 1
  ret i4 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v8i4:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i4 @extract_2_from_v8i4(i32 %ignore, <8 x i4> %x) {
  %res = extractelement <8 x i4> %x, i32 2
  ret i4 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v8i4:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i4 @extract_3_from_v8i4(i32 %ignore, <8 x i4> %x) {
  %res = extractelement <8 x i4> %x, i32 3
  ret i4 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v8i4:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i4 @extract_4_from_v8i4(i32 %ignore, <8 x i4> %x) {
  %res = extractelement <8 x i4> %x, i32 4
  ret i4 %res
}
; CC: scalarise
; CHECK-LABEL: extract_5_from_v8i4:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 2
; CHECK:       br $m10
define i4 @extract_5_from_v8i4(i32 %ignore, <8 x i4> %x) {
  %res = extractelement <8 x i4> %x, i32 5
  ret i4 %res
}
; CC: scalarise
; CHECK-LABEL: extract_6_from_v8i4:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 3
; CHECK:       br $m10
define i4 @extract_6_from_v8i4(i32 %ignore, <8 x i4> %x) {
  %res = extractelement <8 x i4> %x, i32 6
  ret i4 %res
}
; CC: scalarise
; CHECK-LABEL: extract_7_from_v8i4:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 4
; CHECK:       br $m10
define i4 @extract_7_from_v8i4(i32 %ignore, <8 x i4> %x) {
  %res = extractelement <8 x i4> %x, i32 7
  ret i4 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v1i5:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i5 @extract_0_from_v1i5(i32 %ignore, <1 x i5> %x) {
  %res = extractelement <1 x i5> %x, i32 0
  ret i5 %res
}
; CC: pass as v2i16
; CHECK-LABEL: extract_0_from_v2i5:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i5 @extract_0_from_v2i5(i32 %ignore, <2 x i5> %x) {
  %res = extractelement <2 x i5> %x, i32 0
  ret i5 %res
}
; CC: pass as v2i16
; CHECK-LABEL: extract_1_from_v2i5:
; CHECK:       # %bb.0:
; CHECK-NEXT:  swap16 $m0, $m1
; CHECK:       br $m10
define i5 @extract_1_from_v2i5(i32 %ignore, <2 x i5> %x) {
  %res = extractelement <2 x i5> %x, i32 1
  ret i5 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v3i5:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i5 @extract_0_from_v3i5(i32 %ignore, <3 x i5> %x) {
  %res = extractelement <3 x i5> %x, i32 0
  ret i5 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v3i5:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i5 @extract_1_from_v3i5(i32 %ignore, <3 x i5> %x) {
  %res = extractelement <3 x i5> %x, i32 1
  ret i5 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v3i5:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i5 @extract_2_from_v3i5(i32 %ignore, <3 x i5> %x) {
  %res = extractelement <3 x i5> %x, i32 2
  ret i5 %res
}
; CC: pass as v4i16
; CHECK-LABEL: extract_0_from_v4i5:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK-NEXT:  mov $m1, $m3
; CHECK:       br $m10
define i5 @extract_0_from_v4i5(i32 %ignore, <4 x i5> %x) {
  %res = extractelement <4 x i5> %x, i32 0
  ret i5 %res
}
; CC: pass as v4i16
; CHECK-LABEL: extract_1_from_v4i5:
; CHECK:       # %bb.0:
; CHECK-NEXT:  swap16 $m0, $m2
; CHECK:       br $m10
define i5 @extract_1_from_v4i5(i32 %ignore, <4 x i5> %x) {
  %res = extractelement <4 x i5> %x, i32 1
  ret i5 %res
}
; CC: pass as v4i16
; CHECK-LABEL: extract_2_from_v4i5:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i5 @extract_2_from_v4i5(i32 %ignore, <4 x i5> %x) {
  %res = extractelement <4 x i5> %x, i32 2
  ret i5 %res
}
; CC: pass as v4i16
; CHECK-LABEL: extract_3_from_v4i5:
; CHECK:       # %bb.0:
; CHECK-NEXT:  swap16 $m0, $m3
; CHECK:       br $m10
define i5 @extract_3_from_v4i5(i32 %ignore, <4 x i5> %x) {
  %res = extractelement <4 x i5> %x, i32 3
  ret i5 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v5i5:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i5 @extract_0_from_v5i5(i32 %ignore, <5 x i5> %x) {
  %res = extractelement <5 x i5> %x, i32 0
  ret i5 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v5i5:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i5 @extract_1_from_v5i5(i32 %ignore, <5 x i5> %x) {
  %res = extractelement <5 x i5> %x, i32 1
  ret i5 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v5i5:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i5 @extract_2_from_v5i5(i32 %ignore, <5 x i5> %x) {
  %res = extractelement <5 x i5> %x, i32 2
  ret i5 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v5i5:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i5 @extract_3_from_v5i5(i32 %ignore, <5 x i5> %x) {
  %res = extractelement <5 x i5> %x, i32 3
  ret i5 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v5i5:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i5 @extract_4_from_v5i5(i32 %ignore, <5 x i5> %x) {
  %res = extractelement <5 x i5> %x, i32 4
  ret i5 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v6i5:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i5 @extract_0_from_v6i5(i32 %ignore, <6 x i5> %x) {
  %res = extractelement <6 x i5> %x, i32 0
  ret i5 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v6i5:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i5 @extract_1_from_v6i5(i32 %ignore, <6 x i5> %x) {
  %res = extractelement <6 x i5> %x, i32 1
  ret i5 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v6i5:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i5 @extract_2_from_v6i5(i32 %ignore, <6 x i5> %x) {
  %res = extractelement <6 x i5> %x, i32 2
  ret i5 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v6i5:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i5 @extract_3_from_v6i5(i32 %ignore, <6 x i5> %x) {
  %res = extractelement <6 x i5> %x, i32 3
  ret i5 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v6i5:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i5 @extract_4_from_v6i5(i32 %ignore, <6 x i5> %x) {
  %res = extractelement <6 x i5> %x, i32 4
  ret i5 %res
}
; CC: scalarise
; CHECK-LABEL: extract_5_from_v6i5:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 2
; CHECK:       br $m10
define i5 @extract_5_from_v6i5(i32 %ignore, <6 x i5> %x) {
  %res = extractelement <6 x i5> %x, i32 5
  ret i5 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v7i5:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i5 @extract_0_from_v7i5(i32 %ignore, <7 x i5> %x) {
  %res = extractelement <7 x i5> %x, i32 0
  ret i5 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v7i5:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i5 @extract_1_from_v7i5(i32 %ignore, <7 x i5> %x) {
  %res = extractelement <7 x i5> %x, i32 1
  ret i5 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v7i5:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i5 @extract_2_from_v7i5(i32 %ignore, <7 x i5> %x) {
  %res = extractelement <7 x i5> %x, i32 2
  ret i5 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v7i5:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i5 @extract_3_from_v7i5(i32 %ignore, <7 x i5> %x) {
  %res = extractelement <7 x i5> %x, i32 3
  ret i5 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v7i5:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i5 @extract_4_from_v7i5(i32 %ignore, <7 x i5> %x) {
  %res = extractelement <7 x i5> %x, i32 4
  ret i5 %res
}
; CC: scalarise
; CHECK-LABEL: extract_5_from_v7i5:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 2
; CHECK:       br $m10
define i5 @extract_5_from_v7i5(i32 %ignore, <7 x i5> %x) {
  %res = extractelement <7 x i5> %x, i32 5
  ret i5 %res
}
; CC: scalarise
; CHECK-LABEL: extract_6_from_v7i5:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 3
; CHECK:       br $m10
define i5 @extract_6_from_v7i5(i32 %ignore, <7 x i5> %x) {
  %res = extractelement <7 x i5> %x, i32 6
  ret i5 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v8i5:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i5 @extract_0_from_v8i5(i32 %ignore, <8 x i5> %x) {
  %res = extractelement <8 x i5> %x, i32 0
  ret i5 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v8i5:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i5 @extract_1_from_v8i5(i32 %ignore, <8 x i5> %x) {
  %res = extractelement <8 x i5> %x, i32 1
  ret i5 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v8i5:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i5 @extract_2_from_v8i5(i32 %ignore, <8 x i5> %x) {
  %res = extractelement <8 x i5> %x, i32 2
  ret i5 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v8i5:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i5 @extract_3_from_v8i5(i32 %ignore, <8 x i5> %x) {
  %res = extractelement <8 x i5> %x, i32 3
  ret i5 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v8i5:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i5 @extract_4_from_v8i5(i32 %ignore, <8 x i5> %x) {
  %res = extractelement <8 x i5> %x, i32 4
  ret i5 %res
}
; CC: scalarise
; CHECK-LABEL: extract_5_from_v8i5:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 2
; CHECK:       br $m10
define i5 @extract_5_from_v8i5(i32 %ignore, <8 x i5> %x) {
  %res = extractelement <8 x i5> %x, i32 5
  ret i5 %res
}
; CC: scalarise
; CHECK-LABEL: extract_6_from_v8i5:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 3
; CHECK:       br $m10
define i5 @extract_6_from_v8i5(i32 %ignore, <8 x i5> %x) {
  %res = extractelement <8 x i5> %x, i32 6
  ret i5 %res
}
; CC: scalarise
; CHECK-LABEL: extract_7_from_v8i5:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 4
; CHECK:       br $m10
define i5 @extract_7_from_v8i5(i32 %ignore, <8 x i5> %x) {
  %res = extractelement <8 x i5> %x, i32 7
  ret i5 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v1i6:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i6 @extract_0_from_v1i6(i32 %ignore, <1 x i6> %x) {
  %res = extractelement <1 x i6> %x, i32 0
  ret i6 %res
}
; CC: pass as v2i16
; CHECK-LABEL: extract_0_from_v2i6:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i6 @extract_0_from_v2i6(i32 %ignore, <2 x i6> %x) {
  %res = extractelement <2 x i6> %x, i32 0
  ret i6 %res
}
; CC: pass as v2i16
; CHECK-LABEL: extract_1_from_v2i6:
; CHECK:       # %bb.0:
; CHECK-NEXT:  swap16 $m0, $m1
; CHECK:       br $m10
define i6 @extract_1_from_v2i6(i32 %ignore, <2 x i6> %x) {
  %res = extractelement <2 x i6> %x, i32 1
  ret i6 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v3i6:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i6 @extract_0_from_v3i6(i32 %ignore, <3 x i6> %x) {
  %res = extractelement <3 x i6> %x, i32 0
  ret i6 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v3i6:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i6 @extract_1_from_v3i6(i32 %ignore, <3 x i6> %x) {
  %res = extractelement <3 x i6> %x, i32 1
  ret i6 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v3i6:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i6 @extract_2_from_v3i6(i32 %ignore, <3 x i6> %x) {
  %res = extractelement <3 x i6> %x, i32 2
  ret i6 %res
}
; CC: pass as v4i16
; CHECK-LABEL: extract_0_from_v4i6:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK-NEXT:  mov $m1, $m3
; CHECK:       br $m10
define i6 @extract_0_from_v4i6(i32 %ignore, <4 x i6> %x) {
  %res = extractelement <4 x i6> %x, i32 0
  ret i6 %res
}
; CC: pass as v4i16
; CHECK-LABEL: extract_1_from_v4i6:
; CHECK:       # %bb.0:
; CHECK-NEXT:  swap16 $m0, $m2
; CHECK:       br $m10
define i6 @extract_1_from_v4i6(i32 %ignore, <4 x i6> %x) {
  %res = extractelement <4 x i6> %x, i32 1
  ret i6 %res
}
; CC: pass as v4i16
; CHECK-LABEL: extract_2_from_v4i6:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i6 @extract_2_from_v4i6(i32 %ignore, <4 x i6> %x) {
  %res = extractelement <4 x i6> %x, i32 2
  ret i6 %res
}
; CC: pass as v4i16
; CHECK-LABEL: extract_3_from_v4i6:
; CHECK:       # %bb.0:
; CHECK-NEXT:  swap16 $m0, $m3
; CHECK:       br $m10
define i6 @extract_3_from_v4i6(i32 %ignore, <4 x i6> %x) {
  %res = extractelement <4 x i6> %x, i32 3
  ret i6 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v5i6:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i6 @extract_0_from_v5i6(i32 %ignore, <5 x i6> %x) {
  %res = extractelement <5 x i6> %x, i32 0
  ret i6 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v5i6:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i6 @extract_1_from_v5i6(i32 %ignore, <5 x i6> %x) {
  %res = extractelement <5 x i6> %x, i32 1
  ret i6 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v5i6:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i6 @extract_2_from_v5i6(i32 %ignore, <5 x i6> %x) {
  %res = extractelement <5 x i6> %x, i32 2
  ret i6 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v5i6:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i6 @extract_3_from_v5i6(i32 %ignore, <5 x i6> %x) {
  %res = extractelement <5 x i6> %x, i32 3
  ret i6 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v5i6:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i6 @extract_4_from_v5i6(i32 %ignore, <5 x i6> %x) {
  %res = extractelement <5 x i6> %x, i32 4
  ret i6 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v6i6:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i6 @extract_0_from_v6i6(i32 %ignore, <6 x i6> %x) {
  %res = extractelement <6 x i6> %x, i32 0
  ret i6 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v6i6:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i6 @extract_1_from_v6i6(i32 %ignore, <6 x i6> %x) {
  %res = extractelement <6 x i6> %x, i32 1
  ret i6 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v6i6:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i6 @extract_2_from_v6i6(i32 %ignore, <6 x i6> %x) {
  %res = extractelement <6 x i6> %x, i32 2
  ret i6 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v6i6:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i6 @extract_3_from_v6i6(i32 %ignore, <6 x i6> %x) {
  %res = extractelement <6 x i6> %x, i32 3
  ret i6 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v6i6:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i6 @extract_4_from_v6i6(i32 %ignore, <6 x i6> %x) {
  %res = extractelement <6 x i6> %x, i32 4
  ret i6 %res
}
; CC: scalarise
; CHECK-LABEL: extract_5_from_v6i6:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 2
; CHECK:       br $m10
define i6 @extract_5_from_v6i6(i32 %ignore, <6 x i6> %x) {
  %res = extractelement <6 x i6> %x, i32 5
  ret i6 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v7i6:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i6 @extract_0_from_v7i6(i32 %ignore, <7 x i6> %x) {
  %res = extractelement <7 x i6> %x, i32 0
  ret i6 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v7i6:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i6 @extract_1_from_v7i6(i32 %ignore, <7 x i6> %x) {
  %res = extractelement <7 x i6> %x, i32 1
  ret i6 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v7i6:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i6 @extract_2_from_v7i6(i32 %ignore, <7 x i6> %x) {
  %res = extractelement <7 x i6> %x, i32 2
  ret i6 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v7i6:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i6 @extract_3_from_v7i6(i32 %ignore, <7 x i6> %x) {
  %res = extractelement <7 x i6> %x, i32 3
  ret i6 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v7i6:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i6 @extract_4_from_v7i6(i32 %ignore, <7 x i6> %x) {
  %res = extractelement <7 x i6> %x, i32 4
  ret i6 %res
}
; CC: scalarise
; CHECK-LABEL: extract_5_from_v7i6:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 2
; CHECK:       br $m10
define i6 @extract_5_from_v7i6(i32 %ignore, <7 x i6> %x) {
  %res = extractelement <7 x i6> %x, i32 5
  ret i6 %res
}
; CC: scalarise
; CHECK-LABEL: extract_6_from_v7i6:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 3
; CHECK:       br $m10
define i6 @extract_6_from_v7i6(i32 %ignore, <7 x i6> %x) {
  %res = extractelement <7 x i6> %x, i32 6
  ret i6 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v8i6:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i6 @extract_0_from_v8i6(i32 %ignore, <8 x i6> %x) {
  %res = extractelement <8 x i6> %x, i32 0
  ret i6 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v8i6:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i6 @extract_1_from_v8i6(i32 %ignore, <8 x i6> %x) {
  %res = extractelement <8 x i6> %x, i32 1
  ret i6 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v8i6:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i6 @extract_2_from_v8i6(i32 %ignore, <8 x i6> %x) {
  %res = extractelement <8 x i6> %x, i32 2
  ret i6 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v8i6:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i6 @extract_3_from_v8i6(i32 %ignore, <8 x i6> %x) {
  %res = extractelement <8 x i6> %x, i32 3
  ret i6 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v8i6:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i6 @extract_4_from_v8i6(i32 %ignore, <8 x i6> %x) {
  %res = extractelement <8 x i6> %x, i32 4
  ret i6 %res
}
; CC: scalarise
; CHECK-LABEL: extract_5_from_v8i6:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 2
; CHECK:       br $m10
define i6 @extract_5_from_v8i6(i32 %ignore, <8 x i6> %x) {
  %res = extractelement <8 x i6> %x, i32 5
  ret i6 %res
}
; CC: scalarise
; CHECK-LABEL: extract_6_from_v8i6:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 3
; CHECK:       br $m10
define i6 @extract_6_from_v8i6(i32 %ignore, <8 x i6> %x) {
  %res = extractelement <8 x i6> %x, i32 6
  ret i6 %res
}
; CC: scalarise
; CHECK-LABEL: extract_7_from_v8i6:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 4
; CHECK:       br $m10
define i6 @extract_7_from_v8i6(i32 %ignore, <8 x i6> %x) {
  %res = extractelement <8 x i6> %x, i32 7
  ret i6 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v1i7:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i7 @extract_0_from_v1i7(i32 %ignore, <1 x i7> %x) {
  %res = extractelement <1 x i7> %x, i32 0
  ret i7 %res
}
; CC: pass as v2i16
; CHECK-LABEL: extract_0_from_v2i7:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i7 @extract_0_from_v2i7(i32 %ignore, <2 x i7> %x) {
  %res = extractelement <2 x i7> %x, i32 0
  ret i7 %res
}
; CC: pass as v2i16
; CHECK-LABEL: extract_1_from_v2i7:
; CHECK:       # %bb.0:
; CHECK-NEXT:  swap16 $m0, $m1
; CHECK:       br $m10
define i7 @extract_1_from_v2i7(i32 %ignore, <2 x i7> %x) {
  %res = extractelement <2 x i7> %x, i32 1
  ret i7 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v3i7:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i7 @extract_0_from_v3i7(i32 %ignore, <3 x i7> %x) {
  %res = extractelement <3 x i7> %x, i32 0
  ret i7 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v3i7:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i7 @extract_1_from_v3i7(i32 %ignore, <3 x i7> %x) {
  %res = extractelement <3 x i7> %x, i32 1
  ret i7 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v3i7:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i7 @extract_2_from_v3i7(i32 %ignore, <3 x i7> %x) {
  %res = extractelement <3 x i7> %x, i32 2
  ret i7 %res
}
; CC: pass as v4i16
; CHECK-LABEL: extract_0_from_v4i7:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK-NEXT:  mov $m1, $m3
; CHECK:       br $m10
define i7 @extract_0_from_v4i7(i32 %ignore, <4 x i7> %x) {
  %res = extractelement <4 x i7> %x, i32 0
  ret i7 %res
}
; CC: pass as v4i16
; CHECK-LABEL: extract_1_from_v4i7:
; CHECK:       # %bb.0:
; CHECK-NEXT:  swap16 $m0, $m2
; CHECK:       br $m10
define i7 @extract_1_from_v4i7(i32 %ignore, <4 x i7> %x) {
  %res = extractelement <4 x i7> %x, i32 1
  ret i7 %res
}
; CC: pass as v4i16
; CHECK-LABEL: extract_2_from_v4i7:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i7 @extract_2_from_v4i7(i32 %ignore, <4 x i7> %x) {
  %res = extractelement <4 x i7> %x, i32 2
  ret i7 %res
}
; CC: pass as v4i16
; CHECK-LABEL: extract_3_from_v4i7:
; CHECK:       # %bb.0:
; CHECK-NEXT:  swap16 $m0, $m3
; CHECK:       br $m10
define i7 @extract_3_from_v4i7(i32 %ignore, <4 x i7> %x) {
  %res = extractelement <4 x i7> %x, i32 3
  ret i7 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v5i7:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i7 @extract_0_from_v5i7(i32 %ignore, <5 x i7> %x) {
  %res = extractelement <5 x i7> %x, i32 0
  ret i7 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v5i7:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i7 @extract_1_from_v5i7(i32 %ignore, <5 x i7> %x) {
  %res = extractelement <5 x i7> %x, i32 1
  ret i7 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v5i7:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i7 @extract_2_from_v5i7(i32 %ignore, <5 x i7> %x) {
  %res = extractelement <5 x i7> %x, i32 2
  ret i7 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v5i7:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i7 @extract_3_from_v5i7(i32 %ignore, <5 x i7> %x) {
  %res = extractelement <5 x i7> %x, i32 3
  ret i7 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v5i7:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i7 @extract_4_from_v5i7(i32 %ignore, <5 x i7> %x) {
  %res = extractelement <5 x i7> %x, i32 4
  ret i7 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v6i7:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i7 @extract_0_from_v6i7(i32 %ignore, <6 x i7> %x) {
  %res = extractelement <6 x i7> %x, i32 0
  ret i7 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v6i7:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i7 @extract_1_from_v6i7(i32 %ignore, <6 x i7> %x) {
  %res = extractelement <6 x i7> %x, i32 1
  ret i7 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v6i7:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i7 @extract_2_from_v6i7(i32 %ignore, <6 x i7> %x) {
  %res = extractelement <6 x i7> %x, i32 2
  ret i7 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v6i7:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i7 @extract_3_from_v6i7(i32 %ignore, <6 x i7> %x) {
  %res = extractelement <6 x i7> %x, i32 3
  ret i7 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v6i7:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i7 @extract_4_from_v6i7(i32 %ignore, <6 x i7> %x) {
  %res = extractelement <6 x i7> %x, i32 4
  ret i7 %res
}
; CC: scalarise
; CHECK-LABEL: extract_5_from_v6i7:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 2
; CHECK:       br $m10
define i7 @extract_5_from_v6i7(i32 %ignore, <6 x i7> %x) {
  %res = extractelement <6 x i7> %x, i32 5
  ret i7 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v7i7:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i7 @extract_0_from_v7i7(i32 %ignore, <7 x i7> %x) {
  %res = extractelement <7 x i7> %x, i32 0
  ret i7 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v7i7:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i7 @extract_1_from_v7i7(i32 %ignore, <7 x i7> %x) {
  %res = extractelement <7 x i7> %x, i32 1
  ret i7 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v7i7:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i7 @extract_2_from_v7i7(i32 %ignore, <7 x i7> %x) {
  %res = extractelement <7 x i7> %x, i32 2
  ret i7 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v7i7:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i7 @extract_3_from_v7i7(i32 %ignore, <7 x i7> %x) {
  %res = extractelement <7 x i7> %x, i32 3
  ret i7 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v7i7:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i7 @extract_4_from_v7i7(i32 %ignore, <7 x i7> %x) {
  %res = extractelement <7 x i7> %x, i32 4
  ret i7 %res
}
; CC: scalarise
; CHECK-LABEL: extract_5_from_v7i7:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 2
; CHECK:       br $m10
define i7 @extract_5_from_v7i7(i32 %ignore, <7 x i7> %x) {
  %res = extractelement <7 x i7> %x, i32 5
  ret i7 %res
}
; CC: scalarise
; CHECK-LABEL: extract_6_from_v7i7:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 3
; CHECK:       br $m10
define i7 @extract_6_from_v7i7(i32 %ignore, <7 x i7> %x) {
  %res = extractelement <7 x i7> %x, i32 6
  ret i7 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v8i7:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i7 @extract_0_from_v8i7(i32 %ignore, <8 x i7> %x) {
  %res = extractelement <8 x i7> %x, i32 0
  ret i7 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v8i7:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i7 @extract_1_from_v8i7(i32 %ignore, <8 x i7> %x) {
  %res = extractelement <8 x i7> %x, i32 1
  ret i7 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v8i7:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i7 @extract_2_from_v8i7(i32 %ignore, <8 x i7> %x) {
  %res = extractelement <8 x i7> %x, i32 2
  ret i7 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v8i7:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i7 @extract_3_from_v8i7(i32 %ignore, <8 x i7> %x) {
  %res = extractelement <8 x i7> %x, i32 3
  ret i7 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v8i7:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i7 @extract_4_from_v8i7(i32 %ignore, <8 x i7> %x) {
  %res = extractelement <8 x i7> %x, i32 4
  ret i7 %res
}
; CC: scalarise
; CHECK-LABEL: extract_5_from_v8i7:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 2
; CHECK:       br $m10
define i7 @extract_5_from_v8i7(i32 %ignore, <8 x i7> %x) {
  %res = extractelement <8 x i7> %x, i32 5
  ret i7 %res
}
; CC: scalarise
; CHECK-LABEL: extract_6_from_v8i7:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 3
; CHECK:       br $m10
define i7 @extract_6_from_v8i7(i32 %ignore, <8 x i7> %x) {
  %res = extractelement <8 x i7> %x, i32 6
  ret i7 %res
}
; CC: scalarise
; CHECK-LABEL: extract_7_from_v8i7:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 4
; CHECK:       br $m10
define i7 @extract_7_from_v8i7(i32 %ignore, <8 x i7> %x) {
  %res = extractelement <8 x i7> %x, i32 7
  ret i7 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v1i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i8 @extract_0_from_v1i8(i32 %ignore, <1 x i8> %x) {
  %res = extractelement <1 x i8> %x, i32 0
  ret i8 %res
}
; CC: pass as v2i16
; CHECK-LABEL: extract_0_from_v2i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i8 @extract_0_from_v2i8(i32 %ignore, <2 x i8> %x) {
  %res = extractelement <2 x i8> %x, i32 0
  ret i8 %res
}
; CC: pass as v2i16
; CHECK-LABEL: extract_1_from_v2i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:  swap16 $m0, $m1
; CHECK:       br $m10
define i8 @extract_1_from_v2i8(i32 %ignore, <2 x i8> %x) {
  %res = extractelement <2 x i8> %x, i32 1
  ret i8 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v3i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i8 @extract_0_from_v3i8(i32 %ignore, <3 x i8> %x) {
  %res = extractelement <3 x i8> %x, i32 0
  ret i8 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v3i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i8 @extract_1_from_v3i8(i32 %ignore, <3 x i8> %x) {
  %res = extractelement <3 x i8> %x, i32 1
  ret i8 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v3i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i8 @extract_2_from_v3i8(i32 %ignore, <3 x i8> %x) {
  %res = extractelement <3 x i8> %x, i32 2
  ret i8 %res
}
; CC: pass as v4i16
; CHECK-LABEL: extract_0_from_v4i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK-NEXT:  mov $m1, $m3
; CHECK:       br $m10
define i8 @extract_0_from_v4i8(i32 %ignore, <4 x i8> %x) {
  %res = extractelement <4 x i8> %x, i32 0
  ret i8 %res
}
; CC: pass as v4i16
; CHECK-LABEL: extract_1_from_v4i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:  swap16 $m0, $m2
; CHECK:       br $m10
define i8 @extract_1_from_v4i8(i32 %ignore, <4 x i8> %x) {
  %res = extractelement <4 x i8> %x, i32 1
  ret i8 %res
}
; CC: pass as v4i16
; CHECK-LABEL: extract_2_from_v4i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i8 @extract_2_from_v4i8(i32 %ignore, <4 x i8> %x) {
  %res = extractelement <4 x i8> %x, i32 2
  ret i8 %res
}
; CC: pass as v4i16
; CHECK-LABEL: extract_3_from_v4i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:  swap16 $m0, $m3
; CHECK:       br $m10
define i8 @extract_3_from_v4i8(i32 %ignore, <4 x i8> %x) {
  %res = extractelement <4 x i8> %x, i32 3
  ret i8 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v5i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i8 @extract_0_from_v5i8(i32 %ignore, <5 x i8> %x) {
  %res = extractelement <5 x i8> %x, i32 0
  ret i8 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v5i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i8 @extract_1_from_v5i8(i32 %ignore, <5 x i8> %x) {
  %res = extractelement <5 x i8> %x, i32 1
  ret i8 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v5i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i8 @extract_2_from_v5i8(i32 %ignore, <5 x i8> %x) {
  %res = extractelement <5 x i8> %x, i32 2
  ret i8 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v5i8:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i8 @extract_3_from_v5i8(i32 %ignore, <5 x i8> %x) {
  %res = extractelement <5 x i8> %x, i32 3
  ret i8 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v5i8:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i8 @extract_4_from_v5i8(i32 %ignore, <5 x i8> %x) {
  %res = extractelement <5 x i8> %x, i32 4
  ret i8 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v6i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i8 @extract_0_from_v6i8(i32 %ignore, <6 x i8> %x) {
  %res = extractelement <6 x i8> %x, i32 0
  ret i8 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v6i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i8 @extract_1_from_v6i8(i32 %ignore, <6 x i8> %x) {
  %res = extractelement <6 x i8> %x, i32 1
  ret i8 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v6i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i8 @extract_2_from_v6i8(i32 %ignore, <6 x i8> %x) {
  %res = extractelement <6 x i8> %x, i32 2
  ret i8 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v6i8:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i8 @extract_3_from_v6i8(i32 %ignore, <6 x i8> %x) {
  %res = extractelement <6 x i8> %x, i32 3
  ret i8 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v6i8:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i8 @extract_4_from_v6i8(i32 %ignore, <6 x i8> %x) {
  %res = extractelement <6 x i8> %x, i32 4
  ret i8 %res
}
; CC: scalarise
; CHECK-LABEL: extract_5_from_v6i8:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 2
; CHECK:       br $m10
define i8 @extract_5_from_v6i8(i32 %ignore, <6 x i8> %x) {
  %res = extractelement <6 x i8> %x, i32 5
  ret i8 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v7i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i8 @extract_0_from_v7i8(i32 %ignore, <7 x i8> %x) {
  %res = extractelement <7 x i8> %x, i32 0
  ret i8 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v7i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i8 @extract_1_from_v7i8(i32 %ignore, <7 x i8> %x) {
  %res = extractelement <7 x i8> %x, i32 1
  ret i8 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v7i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i8 @extract_2_from_v7i8(i32 %ignore, <7 x i8> %x) {
  %res = extractelement <7 x i8> %x, i32 2
  ret i8 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v7i8:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i8 @extract_3_from_v7i8(i32 %ignore, <7 x i8> %x) {
  %res = extractelement <7 x i8> %x, i32 3
  ret i8 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v7i8:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i8 @extract_4_from_v7i8(i32 %ignore, <7 x i8> %x) {
  %res = extractelement <7 x i8> %x, i32 4
  ret i8 %res
}
; CC: scalarise
; CHECK-LABEL: extract_5_from_v7i8:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 2
; CHECK:       br $m10
define i8 @extract_5_from_v7i8(i32 %ignore, <7 x i8> %x) {
  %res = extractelement <7 x i8> %x, i32 5
  ret i8 %res
}
; CC: scalarise
; CHECK-LABEL: extract_6_from_v7i8:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 3
; CHECK:       br $m10
define i8 @extract_6_from_v7i8(i32 %ignore, <7 x i8> %x) {
  %res = extractelement <7 x i8> %x, i32 6
  ret i8 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v8i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i8 @extract_0_from_v8i8(i32 %ignore, <8 x i8> %x) {
  %res = extractelement <8 x i8> %x, i32 0
  ret i8 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v8i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i8 @extract_1_from_v8i8(i32 %ignore, <8 x i8> %x) {
  %res = extractelement <8 x i8> %x, i32 1
  ret i8 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v8i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i8 @extract_2_from_v8i8(i32 %ignore, <8 x i8> %x) {
  %res = extractelement <8 x i8> %x, i32 2
  ret i8 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v8i8:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i8 @extract_3_from_v8i8(i32 %ignore, <8 x i8> %x) {
  %res = extractelement <8 x i8> %x, i32 3
  ret i8 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v8i8:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i8 @extract_4_from_v8i8(i32 %ignore, <8 x i8> %x) {
  %res = extractelement <8 x i8> %x, i32 4
  ret i8 %res
}
; CC: scalarise
; CHECK-LABEL: extract_5_from_v8i8:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 2
; CHECK:       br $m10
define i8 @extract_5_from_v8i8(i32 %ignore, <8 x i8> %x) {
  %res = extractelement <8 x i8> %x, i32 5
  ret i8 %res
}
; CC: scalarise
; CHECK-LABEL: extract_6_from_v8i8:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 3
; CHECK:       br $m10
define i8 @extract_6_from_v8i8(i32 %ignore, <8 x i8> %x) {
  %res = extractelement <8 x i8> %x, i32 6
  ret i8 %res
}
; CC: scalarise
; CHECK-LABEL: extract_7_from_v8i8:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 4
; CHECK:       br $m10
define i8 @extract_7_from_v8i8(i32 %ignore, <8 x i8> %x) {
  %res = extractelement <8 x i8> %x, i32 7
  ret i8 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v1i9:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i9 @extract_0_from_v1i9(i32 %ignore, <1 x i9> %x) {
  %res = extractelement <1 x i9> %x, i32 0
  ret i9 %res
}
; CC: pass as v2i16
; CHECK-LABEL: extract_0_from_v2i9:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i9 @extract_0_from_v2i9(i32 %ignore, <2 x i9> %x) {
  %res = extractelement <2 x i9> %x, i32 0
  ret i9 %res
}
; CC: pass as v2i16
; CHECK-LABEL: extract_1_from_v2i9:
; CHECK:       # %bb.0:
; CHECK-NEXT:  swap16 $m0, $m1
; CHECK:       br $m10
define i9 @extract_1_from_v2i9(i32 %ignore, <2 x i9> %x) {
  %res = extractelement <2 x i9> %x, i32 1
  ret i9 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v3i9:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i9 @extract_0_from_v3i9(i32 %ignore, <3 x i9> %x) {
  %res = extractelement <3 x i9> %x, i32 0
  ret i9 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v3i9:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i9 @extract_1_from_v3i9(i32 %ignore, <3 x i9> %x) {
  %res = extractelement <3 x i9> %x, i32 1
  ret i9 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v3i9:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i9 @extract_2_from_v3i9(i32 %ignore, <3 x i9> %x) {
  %res = extractelement <3 x i9> %x, i32 2
  ret i9 %res
}
; CC: pass as v4i16
; CHECK-LABEL: extract_0_from_v4i9:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK-NEXT:  mov $m1, $m3
; CHECK:       br $m10
define i9 @extract_0_from_v4i9(i32 %ignore, <4 x i9> %x) {
  %res = extractelement <4 x i9> %x, i32 0
  ret i9 %res
}
; CC: pass as v4i16
; CHECK-LABEL: extract_1_from_v4i9:
; CHECK:       # %bb.0:
; CHECK-NEXT:  swap16 $m0, $m2
; CHECK:       br $m10
define i9 @extract_1_from_v4i9(i32 %ignore, <4 x i9> %x) {
  %res = extractelement <4 x i9> %x, i32 1
  ret i9 %res
}
; CC: pass as v4i16
; CHECK-LABEL: extract_2_from_v4i9:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i9 @extract_2_from_v4i9(i32 %ignore, <4 x i9> %x) {
  %res = extractelement <4 x i9> %x, i32 2
  ret i9 %res
}
; CC: pass as v4i16
; CHECK-LABEL: extract_3_from_v4i9:
; CHECK:       # %bb.0:
; CHECK-NEXT:  swap16 $m0, $m3
; CHECK:       br $m10
define i9 @extract_3_from_v4i9(i32 %ignore, <4 x i9> %x) {
  %res = extractelement <4 x i9> %x, i32 3
  ret i9 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v5i9:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i9 @extract_0_from_v5i9(i32 %ignore, <5 x i9> %x) {
  %res = extractelement <5 x i9> %x, i32 0
  ret i9 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v5i9:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i9 @extract_1_from_v5i9(i32 %ignore, <5 x i9> %x) {
  %res = extractelement <5 x i9> %x, i32 1
  ret i9 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v5i9:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i9 @extract_2_from_v5i9(i32 %ignore, <5 x i9> %x) {
  %res = extractelement <5 x i9> %x, i32 2
  ret i9 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v5i9:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i9 @extract_3_from_v5i9(i32 %ignore, <5 x i9> %x) {
  %res = extractelement <5 x i9> %x, i32 3
  ret i9 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v5i9:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i9 @extract_4_from_v5i9(i32 %ignore, <5 x i9> %x) {
  %res = extractelement <5 x i9> %x, i32 4
  ret i9 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v6i9:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i9 @extract_0_from_v6i9(i32 %ignore, <6 x i9> %x) {
  %res = extractelement <6 x i9> %x, i32 0
  ret i9 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v6i9:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i9 @extract_1_from_v6i9(i32 %ignore, <6 x i9> %x) {
  %res = extractelement <6 x i9> %x, i32 1
  ret i9 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v6i9:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i9 @extract_2_from_v6i9(i32 %ignore, <6 x i9> %x) {
  %res = extractelement <6 x i9> %x, i32 2
  ret i9 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v6i9:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i9 @extract_3_from_v6i9(i32 %ignore, <6 x i9> %x) {
  %res = extractelement <6 x i9> %x, i32 3
  ret i9 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v6i9:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i9 @extract_4_from_v6i9(i32 %ignore, <6 x i9> %x) {
  %res = extractelement <6 x i9> %x, i32 4
  ret i9 %res
}
; CC: scalarise
; CHECK-LABEL: extract_5_from_v6i9:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 2
; CHECK:       br $m10
define i9 @extract_5_from_v6i9(i32 %ignore, <6 x i9> %x) {
  %res = extractelement <6 x i9> %x, i32 5
  ret i9 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v7i9:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i9 @extract_0_from_v7i9(i32 %ignore, <7 x i9> %x) {
  %res = extractelement <7 x i9> %x, i32 0
  ret i9 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v7i9:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i9 @extract_1_from_v7i9(i32 %ignore, <7 x i9> %x) {
  %res = extractelement <7 x i9> %x, i32 1
  ret i9 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v7i9:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i9 @extract_2_from_v7i9(i32 %ignore, <7 x i9> %x) {
  %res = extractelement <7 x i9> %x, i32 2
  ret i9 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v7i9:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i9 @extract_3_from_v7i9(i32 %ignore, <7 x i9> %x) {
  %res = extractelement <7 x i9> %x, i32 3
  ret i9 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v7i9:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i9 @extract_4_from_v7i9(i32 %ignore, <7 x i9> %x) {
  %res = extractelement <7 x i9> %x, i32 4
  ret i9 %res
}
; CC: scalarise
; CHECK-LABEL: extract_5_from_v7i9:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 2
; CHECK:       br $m10
define i9 @extract_5_from_v7i9(i32 %ignore, <7 x i9> %x) {
  %res = extractelement <7 x i9> %x, i32 5
  ret i9 %res
}
; CC: scalarise
; CHECK-LABEL: extract_6_from_v7i9:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 3
; CHECK:       br $m10
define i9 @extract_6_from_v7i9(i32 %ignore, <7 x i9> %x) {
  %res = extractelement <7 x i9> %x, i32 6
  ret i9 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v8i9:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i9 @extract_0_from_v8i9(i32 %ignore, <8 x i9> %x) {
  %res = extractelement <8 x i9> %x, i32 0
  ret i9 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v8i9:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i9 @extract_1_from_v8i9(i32 %ignore, <8 x i9> %x) {
  %res = extractelement <8 x i9> %x, i32 1
  ret i9 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v8i9:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i9 @extract_2_from_v8i9(i32 %ignore, <8 x i9> %x) {
  %res = extractelement <8 x i9> %x, i32 2
  ret i9 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v8i9:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i9 @extract_3_from_v8i9(i32 %ignore, <8 x i9> %x) {
  %res = extractelement <8 x i9> %x, i32 3
  ret i9 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v8i9:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i9 @extract_4_from_v8i9(i32 %ignore, <8 x i9> %x) {
  %res = extractelement <8 x i9> %x, i32 4
  ret i9 %res
}
; CC: scalarise
; CHECK-LABEL: extract_5_from_v8i9:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 2
; CHECK:       br $m10
define i9 @extract_5_from_v8i9(i32 %ignore, <8 x i9> %x) {
  %res = extractelement <8 x i9> %x, i32 5
  ret i9 %res
}
; CC: scalarise
; CHECK-LABEL: extract_6_from_v8i9:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 3
; CHECK:       br $m10
define i9 @extract_6_from_v8i9(i32 %ignore, <8 x i9> %x) {
  %res = extractelement <8 x i9> %x, i32 6
  ret i9 %res
}
; CC: scalarise
; CHECK-LABEL: extract_7_from_v8i9:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 4
; CHECK:       br $m10
define i9 @extract_7_from_v8i9(i32 %ignore, <8 x i9> %x) {
  %res = extractelement <8 x i9> %x, i32 7
  ret i9 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v1i10:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i10 @extract_0_from_v1i10(i32 %ignore, <1 x i10> %x) {
  %res = extractelement <1 x i10> %x, i32 0
  ret i10 %res
}
; CC: pass as v2i16
; CHECK-LABEL: extract_0_from_v2i10:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i10 @extract_0_from_v2i10(i32 %ignore, <2 x i10> %x) {
  %res = extractelement <2 x i10> %x, i32 0
  ret i10 %res
}
; CC: pass as v2i16
; CHECK-LABEL: extract_1_from_v2i10:
; CHECK:       # %bb.0:
; CHECK-NEXT:  swap16 $m0, $m1
; CHECK:       br $m10
define i10 @extract_1_from_v2i10(i32 %ignore, <2 x i10> %x) {
  %res = extractelement <2 x i10> %x, i32 1
  ret i10 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v3i10:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i10 @extract_0_from_v3i10(i32 %ignore, <3 x i10> %x) {
  %res = extractelement <3 x i10> %x, i32 0
  ret i10 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v3i10:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i10 @extract_1_from_v3i10(i32 %ignore, <3 x i10> %x) {
  %res = extractelement <3 x i10> %x, i32 1
  ret i10 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v3i10:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i10 @extract_2_from_v3i10(i32 %ignore, <3 x i10> %x) {
  %res = extractelement <3 x i10> %x, i32 2
  ret i10 %res
}
; CC: pass as v4i16
; CHECK-LABEL: extract_0_from_v4i10:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK-NEXT:  mov $m1, $m3
; CHECK:       br $m10
define i10 @extract_0_from_v4i10(i32 %ignore, <4 x i10> %x) {
  %res = extractelement <4 x i10> %x, i32 0
  ret i10 %res
}
; CC: pass as v4i16
; CHECK-LABEL: extract_1_from_v4i10:
; CHECK:       # %bb.0:
; CHECK-NEXT:  swap16 $m0, $m2
; CHECK:       br $m10
define i10 @extract_1_from_v4i10(i32 %ignore, <4 x i10> %x) {
  %res = extractelement <4 x i10> %x, i32 1
  ret i10 %res
}
; CC: pass as v4i16
; CHECK-LABEL: extract_2_from_v4i10:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i10 @extract_2_from_v4i10(i32 %ignore, <4 x i10> %x) {
  %res = extractelement <4 x i10> %x, i32 2
  ret i10 %res
}
; CC: pass as v4i16
; CHECK-LABEL: extract_3_from_v4i10:
; CHECK:       # %bb.0:
; CHECK-NEXT:  swap16 $m0, $m3
; CHECK:       br $m10
define i10 @extract_3_from_v4i10(i32 %ignore, <4 x i10> %x) {
  %res = extractelement <4 x i10> %x, i32 3
  ret i10 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v5i10:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i10 @extract_0_from_v5i10(i32 %ignore, <5 x i10> %x) {
  %res = extractelement <5 x i10> %x, i32 0
  ret i10 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v5i10:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i10 @extract_1_from_v5i10(i32 %ignore, <5 x i10> %x) {
  %res = extractelement <5 x i10> %x, i32 1
  ret i10 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v5i10:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i10 @extract_2_from_v5i10(i32 %ignore, <5 x i10> %x) {
  %res = extractelement <5 x i10> %x, i32 2
  ret i10 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v5i10:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i10 @extract_3_from_v5i10(i32 %ignore, <5 x i10> %x) {
  %res = extractelement <5 x i10> %x, i32 3
  ret i10 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v5i10:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i10 @extract_4_from_v5i10(i32 %ignore, <5 x i10> %x) {
  %res = extractelement <5 x i10> %x, i32 4
  ret i10 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v6i10:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i10 @extract_0_from_v6i10(i32 %ignore, <6 x i10> %x) {
  %res = extractelement <6 x i10> %x, i32 0
  ret i10 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v6i10:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i10 @extract_1_from_v6i10(i32 %ignore, <6 x i10> %x) {
  %res = extractelement <6 x i10> %x, i32 1
  ret i10 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v6i10:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i10 @extract_2_from_v6i10(i32 %ignore, <6 x i10> %x) {
  %res = extractelement <6 x i10> %x, i32 2
  ret i10 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v6i10:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i10 @extract_3_from_v6i10(i32 %ignore, <6 x i10> %x) {
  %res = extractelement <6 x i10> %x, i32 3
  ret i10 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v6i10:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i10 @extract_4_from_v6i10(i32 %ignore, <6 x i10> %x) {
  %res = extractelement <6 x i10> %x, i32 4
  ret i10 %res
}
; CC: scalarise
; CHECK-LABEL: extract_5_from_v6i10:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 2
; CHECK:       br $m10
define i10 @extract_5_from_v6i10(i32 %ignore, <6 x i10> %x) {
  %res = extractelement <6 x i10> %x, i32 5
  ret i10 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v7i10:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i10 @extract_0_from_v7i10(i32 %ignore, <7 x i10> %x) {
  %res = extractelement <7 x i10> %x, i32 0
  ret i10 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v7i10:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i10 @extract_1_from_v7i10(i32 %ignore, <7 x i10> %x) {
  %res = extractelement <7 x i10> %x, i32 1
  ret i10 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v7i10:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i10 @extract_2_from_v7i10(i32 %ignore, <7 x i10> %x) {
  %res = extractelement <7 x i10> %x, i32 2
  ret i10 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v7i10:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i10 @extract_3_from_v7i10(i32 %ignore, <7 x i10> %x) {
  %res = extractelement <7 x i10> %x, i32 3
  ret i10 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v7i10:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i10 @extract_4_from_v7i10(i32 %ignore, <7 x i10> %x) {
  %res = extractelement <7 x i10> %x, i32 4
  ret i10 %res
}
; CC: scalarise
; CHECK-LABEL: extract_5_from_v7i10:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 2
; CHECK:       br $m10
define i10 @extract_5_from_v7i10(i32 %ignore, <7 x i10> %x) {
  %res = extractelement <7 x i10> %x, i32 5
  ret i10 %res
}
; CC: scalarise
; CHECK-LABEL: extract_6_from_v7i10:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 3
; CHECK:       br $m10
define i10 @extract_6_from_v7i10(i32 %ignore, <7 x i10> %x) {
  %res = extractelement <7 x i10> %x, i32 6
  ret i10 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v8i10:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i10 @extract_0_from_v8i10(i32 %ignore, <8 x i10> %x) {
  %res = extractelement <8 x i10> %x, i32 0
  ret i10 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v8i10:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i10 @extract_1_from_v8i10(i32 %ignore, <8 x i10> %x) {
  %res = extractelement <8 x i10> %x, i32 1
  ret i10 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v8i10:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i10 @extract_2_from_v8i10(i32 %ignore, <8 x i10> %x) {
  %res = extractelement <8 x i10> %x, i32 2
  ret i10 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v8i10:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i10 @extract_3_from_v8i10(i32 %ignore, <8 x i10> %x) {
  %res = extractelement <8 x i10> %x, i32 3
  ret i10 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v8i10:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i10 @extract_4_from_v8i10(i32 %ignore, <8 x i10> %x) {
  %res = extractelement <8 x i10> %x, i32 4
  ret i10 %res
}
; CC: scalarise
; CHECK-LABEL: extract_5_from_v8i10:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 2
; CHECK:       br $m10
define i10 @extract_5_from_v8i10(i32 %ignore, <8 x i10> %x) {
  %res = extractelement <8 x i10> %x, i32 5
  ret i10 %res
}
; CC: scalarise
; CHECK-LABEL: extract_6_from_v8i10:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 3
; CHECK:       br $m10
define i10 @extract_6_from_v8i10(i32 %ignore, <8 x i10> %x) {
  %res = extractelement <8 x i10> %x, i32 6
  ret i10 %res
}
; CC: scalarise
; CHECK-LABEL: extract_7_from_v8i10:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 4
; CHECK:       br $m10
define i10 @extract_7_from_v8i10(i32 %ignore, <8 x i10> %x) {
  %res = extractelement <8 x i10> %x, i32 7
  ret i10 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v1i11:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i11 @extract_0_from_v1i11(i32 %ignore, <1 x i11> %x) {
  %res = extractelement <1 x i11> %x, i32 0
  ret i11 %res
}
; CC: pass as v2i16
; CHECK-LABEL: extract_0_from_v2i11:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i11 @extract_0_from_v2i11(i32 %ignore, <2 x i11> %x) {
  %res = extractelement <2 x i11> %x, i32 0
  ret i11 %res
}
; CC: pass as v2i16
; CHECK-LABEL: extract_1_from_v2i11:
; CHECK:       # %bb.0:
; CHECK-NEXT:  swap16 $m0, $m1
; CHECK:       br $m10
define i11 @extract_1_from_v2i11(i32 %ignore, <2 x i11> %x) {
  %res = extractelement <2 x i11> %x, i32 1
  ret i11 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v3i11:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i11 @extract_0_from_v3i11(i32 %ignore, <3 x i11> %x) {
  %res = extractelement <3 x i11> %x, i32 0
  ret i11 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v3i11:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i11 @extract_1_from_v3i11(i32 %ignore, <3 x i11> %x) {
  %res = extractelement <3 x i11> %x, i32 1
  ret i11 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v3i11:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i11 @extract_2_from_v3i11(i32 %ignore, <3 x i11> %x) {
  %res = extractelement <3 x i11> %x, i32 2
  ret i11 %res
}
; CC: pass as v4i16
; CHECK-LABEL: extract_0_from_v4i11:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK-NEXT:  mov $m1, $m3
; CHECK:       br $m10
define i11 @extract_0_from_v4i11(i32 %ignore, <4 x i11> %x) {
  %res = extractelement <4 x i11> %x, i32 0
  ret i11 %res
}
; CC: pass as v4i16
; CHECK-LABEL: extract_1_from_v4i11:
; CHECK:       # %bb.0:
; CHECK-NEXT:  swap16 $m0, $m2
; CHECK:       br $m10
define i11 @extract_1_from_v4i11(i32 %ignore, <4 x i11> %x) {
  %res = extractelement <4 x i11> %x, i32 1
  ret i11 %res
}
; CC: pass as v4i16
; CHECK-LABEL: extract_2_from_v4i11:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i11 @extract_2_from_v4i11(i32 %ignore, <4 x i11> %x) {
  %res = extractelement <4 x i11> %x, i32 2
  ret i11 %res
}
; CC: pass as v4i16
; CHECK-LABEL: extract_3_from_v4i11:
; CHECK:       # %bb.0:
; CHECK-NEXT:  swap16 $m0, $m3
; CHECK:       br $m10
define i11 @extract_3_from_v4i11(i32 %ignore, <4 x i11> %x) {
  %res = extractelement <4 x i11> %x, i32 3
  ret i11 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v5i11:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i11 @extract_0_from_v5i11(i32 %ignore, <5 x i11> %x) {
  %res = extractelement <5 x i11> %x, i32 0
  ret i11 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v5i11:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i11 @extract_1_from_v5i11(i32 %ignore, <5 x i11> %x) {
  %res = extractelement <5 x i11> %x, i32 1
  ret i11 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v5i11:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i11 @extract_2_from_v5i11(i32 %ignore, <5 x i11> %x) {
  %res = extractelement <5 x i11> %x, i32 2
  ret i11 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v5i11:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i11 @extract_3_from_v5i11(i32 %ignore, <5 x i11> %x) {
  %res = extractelement <5 x i11> %x, i32 3
  ret i11 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v5i11:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i11 @extract_4_from_v5i11(i32 %ignore, <5 x i11> %x) {
  %res = extractelement <5 x i11> %x, i32 4
  ret i11 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v6i11:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i11 @extract_0_from_v6i11(i32 %ignore, <6 x i11> %x) {
  %res = extractelement <6 x i11> %x, i32 0
  ret i11 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v6i11:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i11 @extract_1_from_v6i11(i32 %ignore, <6 x i11> %x) {
  %res = extractelement <6 x i11> %x, i32 1
  ret i11 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v6i11:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i11 @extract_2_from_v6i11(i32 %ignore, <6 x i11> %x) {
  %res = extractelement <6 x i11> %x, i32 2
  ret i11 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v6i11:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i11 @extract_3_from_v6i11(i32 %ignore, <6 x i11> %x) {
  %res = extractelement <6 x i11> %x, i32 3
  ret i11 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v6i11:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i11 @extract_4_from_v6i11(i32 %ignore, <6 x i11> %x) {
  %res = extractelement <6 x i11> %x, i32 4
  ret i11 %res
}
; CC: scalarise
; CHECK-LABEL: extract_5_from_v6i11:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 2
; CHECK:       br $m10
define i11 @extract_5_from_v6i11(i32 %ignore, <6 x i11> %x) {
  %res = extractelement <6 x i11> %x, i32 5
  ret i11 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v7i11:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i11 @extract_0_from_v7i11(i32 %ignore, <7 x i11> %x) {
  %res = extractelement <7 x i11> %x, i32 0
  ret i11 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v7i11:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i11 @extract_1_from_v7i11(i32 %ignore, <7 x i11> %x) {
  %res = extractelement <7 x i11> %x, i32 1
  ret i11 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v7i11:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i11 @extract_2_from_v7i11(i32 %ignore, <7 x i11> %x) {
  %res = extractelement <7 x i11> %x, i32 2
  ret i11 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v7i11:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i11 @extract_3_from_v7i11(i32 %ignore, <7 x i11> %x) {
  %res = extractelement <7 x i11> %x, i32 3
  ret i11 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v7i11:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i11 @extract_4_from_v7i11(i32 %ignore, <7 x i11> %x) {
  %res = extractelement <7 x i11> %x, i32 4
  ret i11 %res
}
; CC: scalarise
; CHECK-LABEL: extract_5_from_v7i11:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 2
; CHECK:       br $m10
define i11 @extract_5_from_v7i11(i32 %ignore, <7 x i11> %x) {
  %res = extractelement <7 x i11> %x, i32 5
  ret i11 %res
}
; CC: scalarise
; CHECK-LABEL: extract_6_from_v7i11:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 3
; CHECK:       br $m10
define i11 @extract_6_from_v7i11(i32 %ignore, <7 x i11> %x) {
  %res = extractelement <7 x i11> %x, i32 6
  ret i11 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v8i11:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i11 @extract_0_from_v8i11(i32 %ignore, <8 x i11> %x) {
  %res = extractelement <8 x i11> %x, i32 0
  ret i11 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v8i11:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i11 @extract_1_from_v8i11(i32 %ignore, <8 x i11> %x) {
  %res = extractelement <8 x i11> %x, i32 1
  ret i11 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v8i11:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i11 @extract_2_from_v8i11(i32 %ignore, <8 x i11> %x) {
  %res = extractelement <8 x i11> %x, i32 2
  ret i11 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v8i11:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i11 @extract_3_from_v8i11(i32 %ignore, <8 x i11> %x) {
  %res = extractelement <8 x i11> %x, i32 3
  ret i11 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v8i11:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i11 @extract_4_from_v8i11(i32 %ignore, <8 x i11> %x) {
  %res = extractelement <8 x i11> %x, i32 4
  ret i11 %res
}
; CC: scalarise
; CHECK-LABEL: extract_5_from_v8i11:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 2
; CHECK:       br $m10
define i11 @extract_5_from_v8i11(i32 %ignore, <8 x i11> %x) {
  %res = extractelement <8 x i11> %x, i32 5
  ret i11 %res
}
; CC: scalarise
; CHECK-LABEL: extract_6_from_v8i11:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 3
; CHECK:       br $m10
define i11 @extract_6_from_v8i11(i32 %ignore, <8 x i11> %x) {
  %res = extractelement <8 x i11> %x, i32 6
  ret i11 %res
}
; CC: scalarise
; CHECK-LABEL: extract_7_from_v8i11:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 4
; CHECK:       br $m10
define i11 @extract_7_from_v8i11(i32 %ignore, <8 x i11> %x) {
  %res = extractelement <8 x i11> %x, i32 7
  ret i11 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v1i12:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i12 @extract_0_from_v1i12(i32 %ignore, <1 x i12> %x) {
  %res = extractelement <1 x i12> %x, i32 0
  ret i12 %res
}
; CC: pass as v2i16
; CHECK-LABEL: extract_0_from_v2i12:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i12 @extract_0_from_v2i12(i32 %ignore, <2 x i12> %x) {
  %res = extractelement <2 x i12> %x, i32 0
  ret i12 %res
}
; CC: pass as v2i16
; CHECK-LABEL: extract_1_from_v2i12:
; CHECK:       # %bb.0:
; CHECK-NEXT:  swap16 $m0, $m1
; CHECK:       br $m10
define i12 @extract_1_from_v2i12(i32 %ignore, <2 x i12> %x) {
  %res = extractelement <2 x i12> %x, i32 1
  ret i12 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v3i12:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i12 @extract_0_from_v3i12(i32 %ignore, <3 x i12> %x) {
  %res = extractelement <3 x i12> %x, i32 0
  ret i12 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v3i12:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i12 @extract_1_from_v3i12(i32 %ignore, <3 x i12> %x) {
  %res = extractelement <3 x i12> %x, i32 1
  ret i12 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v3i12:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i12 @extract_2_from_v3i12(i32 %ignore, <3 x i12> %x) {
  %res = extractelement <3 x i12> %x, i32 2
  ret i12 %res
}
; CC: pass as v4i16
; CHECK-LABEL: extract_0_from_v4i12:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK-NEXT:  mov $m1, $m3
; CHECK:       br $m10
define i12 @extract_0_from_v4i12(i32 %ignore, <4 x i12> %x) {
  %res = extractelement <4 x i12> %x, i32 0
  ret i12 %res
}
; CC: pass as v4i16
; CHECK-LABEL: extract_1_from_v4i12:
; CHECK:       # %bb.0:
; CHECK-NEXT:  swap16 $m0, $m2
; CHECK:       br $m10
define i12 @extract_1_from_v4i12(i32 %ignore, <4 x i12> %x) {
  %res = extractelement <4 x i12> %x, i32 1
  ret i12 %res
}
; CC: pass as v4i16
; CHECK-LABEL: extract_2_from_v4i12:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i12 @extract_2_from_v4i12(i32 %ignore, <4 x i12> %x) {
  %res = extractelement <4 x i12> %x, i32 2
  ret i12 %res
}
; CC: pass as v4i16
; CHECK-LABEL: extract_3_from_v4i12:
; CHECK:       # %bb.0:
; CHECK-NEXT:  swap16 $m0, $m3
; CHECK:       br $m10
define i12 @extract_3_from_v4i12(i32 %ignore, <4 x i12> %x) {
  %res = extractelement <4 x i12> %x, i32 3
  ret i12 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v5i12:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i12 @extract_0_from_v5i12(i32 %ignore, <5 x i12> %x) {
  %res = extractelement <5 x i12> %x, i32 0
  ret i12 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v5i12:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i12 @extract_1_from_v5i12(i32 %ignore, <5 x i12> %x) {
  %res = extractelement <5 x i12> %x, i32 1
  ret i12 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v5i12:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i12 @extract_2_from_v5i12(i32 %ignore, <5 x i12> %x) {
  %res = extractelement <5 x i12> %x, i32 2
  ret i12 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v5i12:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i12 @extract_3_from_v5i12(i32 %ignore, <5 x i12> %x) {
  %res = extractelement <5 x i12> %x, i32 3
  ret i12 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v5i12:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i12 @extract_4_from_v5i12(i32 %ignore, <5 x i12> %x) {
  %res = extractelement <5 x i12> %x, i32 4
  ret i12 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v6i12:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i12 @extract_0_from_v6i12(i32 %ignore, <6 x i12> %x) {
  %res = extractelement <6 x i12> %x, i32 0
  ret i12 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v6i12:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i12 @extract_1_from_v6i12(i32 %ignore, <6 x i12> %x) {
  %res = extractelement <6 x i12> %x, i32 1
  ret i12 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v6i12:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i12 @extract_2_from_v6i12(i32 %ignore, <6 x i12> %x) {
  %res = extractelement <6 x i12> %x, i32 2
  ret i12 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v6i12:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i12 @extract_3_from_v6i12(i32 %ignore, <6 x i12> %x) {
  %res = extractelement <6 x i12> %x, i32 3
  ret i12 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v6i12:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i12 @extract_4_from_v6i12(i32 %ignore, <6 x i12> %x) {
  %res = extractelement <6 x i12> %x, i32 4
  ret i12 %res
}
; CC: scalarise
; CHECK-LABEL: extract_5_from_v6i12:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 2
; CHECK:       br $m10
define i12 @extract_5_from_v6i12(i32 %ignore, <6 x i12> %x) {
  %res = extractelement <6 x i12> %x, i32 5
  ret i12 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v7i12:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i12 @extract_0_from_v7i12(i32 %ignore, <7 x i12> %x) {
  %res = extractelement <7 x i12> %x, i32 0
  ret i12 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v7i12:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i12 @extract_1_from_v7i12(i32 %ignore, <7 x i12> %x) {
  %res = extractelement <7 x i12> %x, i32 1
  ret i12 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v7i12:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i12 @extract_2_from_v7i12(i32 %ignore, <7 x i12> %x) {
  %res = extractelement <7 x i12> %x, i32 2
  ret i12 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v7i12:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i12 @extract_3_from_v7i12(i32 %ignore, <7 x i12> %x) {
  %res = extractelement <7 x i12> %x, i32 3
  ret i12 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v7i12:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i12 @extract_4_from_v7i12(i32 %ignore, <7 x i12> %x) {
  %res = extractelement <7 x i12> %x, i32 4
  ret i12 %res
}
; CC: scalarise
; CHECK-LABEL: extract_5_from_v7i12:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 2
; CHECK:       br $m10
define i12 @extract_5_from_v7i12(i32 %ignore, <7 x i12> %x) {
  %res = extractelement <7 x i12> %x, i32 5
  ret i12 %res
}
; CC: scalarise
; CHECK-LABEL: extract_6_from_v7i12:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 3
; CHECK:       br $m10
define i12 @extract_6_from_v7i12(i32 %ignore, <7 x i12> %x) {
  %res = extractelement <7 x i12> %x, i32 6
  ret i12 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v8i12:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i12 @extract_0_from_v8i12(i32 %ignore, <8 x i12> %x) {
  %res = extractelement <8 x i12> %x, i32 0
  ret i12 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v8i12:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i12 @extract_1_from_v8i12(i32 %ignore, <8 x i12> %x) {
  %res = extractelement <8 x i12> %x, i32 1
  ret i12 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v8i12:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i12 @extract_2_from_v8i12(i32 %ignore, <8 x i12> %x) {
  %res = extractelement <8 x i12> %x, i32 2
  ret i12 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v8i12:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i12 @extract_3_from_v8i12(i32 %ignore, <8 x i12> %x) {
  %res = extractelement <8 x i12> %x, i32 3
  ret i12 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v8i12:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i12 @extract_4_from_v8i12(i32 %ignore, <8 x i12> %x) {
  %res = extractelement <8 x i12> %x, i32 4
  ret i12 %res
}
; CC: scalarise
; CHECK-LABEL: extract_5_from_v8i12:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 2
; CHECK:       br $m10
define i12 @extract_5_from_v8i12(i32 %ignore, <8 x i12> %x) {
  %res = extractelement <8 x i12> %x, i32 5
  ret i12 %res
}
; CC: scalarise
; CHECK-LABEL: extract_6_from_v8i12:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 3
; CHECK:       br $m10
define i12 @extract_6_from_v8i12(i32 %ignore, <8 x i12> %x) {
  %res = extractelement <8 x i12> %x, i32 6
  ret i12 %res
}
; CC: scalarise
; CHECK-LABEL: extract_7_from_v8i12:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 4
; CHECK:       br $m10
define i12 @extract_7_from_v8i12(i32 %ignore, <8 x i12> %x) {
  %res = extractelement <8 x i12> %x, i32 7
  ret i12 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v1i13:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i13 @extract_0_from_v1i13(i32 %ignore, <1 x i13> %x) {
  %res = extractelement <1 x i13> %x, i32 0
  ret i13 %res
}
; CC: pass as v2i16
; CHECK-LABEL: extract_0_from_v2i13:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i13 @extract_0_from_v2i13(i32 %ignore, <2 x i13> %x) {
  %res = extractelement <2 x i13> %x, i32 0
  ret i13 %res
}
; CC: pass as v2i16
; CHECK-LABEL: extract_1_from_v2i13:
; CHECK:       # %bb.0:
; CHECK-NEXT:  swap16 $m0, $m1
; CHECK:       br $m10
define i13 @extract_1_from_v2i13(i32 %ignore, <2 x i13> %x) {
  %res = extractelement <2 x i13> %x, i32 1
  ret i13 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v3i13:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i13 @extract_0_from_v3i13(i32 %ignore, <3 x i13> %x) {
  %res = extractelement <3 x i13> %x, i32 0
  ret i13 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v3i13:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i13 @extract_1_from_v3i13(i32 %ignore, <3 x i13> %x) {
  %res = extractelement <3 x i13> %x, i32 1
  ret i13 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v3i13:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i13 @extract_2_from_v3i13(i32 %ignore, <3 x i13> %x) {
  %res = extractelement <3 x i13> %x, i32 2
  ret i13 %res
}
; CC: pass as v4i16
; CHECK-LABEL: extract_0_from_v4i13:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK-NEXT:  mov $m1, $m3
; CHECK:       br $m10
define i13 @extract_0_from_v4i13(i32 %ignore, <4 x i13> %x) {
  %res = extractelement <4 x i13> %x, i32 0
  ret i13 %res
}
; CC: pass as v4i16
; CHECK-LABEL: extract_1_from_v4i13:
; CHECK:       # %bb.0:
; CHECK-NEXT:  swap16 $m0, $m2
; CHECK:       br $m10
define i13 @extract_1_from_v4i13(i32 %ignore, <4 x i13> %x) {
  %res = extractelement <4 x i13> %x, i32 1
  ret i13 %res
}
; CC: pass as v4i16
; CHECK-LABEL: extract_2_from_v4i13:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i13 @extract_2_from_v4i13(i32 %ignore, <4 x i13> %x) {
  %res = extractelement <4 x i13> %x, i32 2
  ret i13 %res
}
; CC: pass as v4i16
; CHECK-LABEL: extract_3_from_v4i13:
; CHECK:       # %bb.0:
; CHECK-NEXT:  swap16 $m0, $m3
; CHECK:       br $m10
define i13 @extract_3_from_v4i13(i32 %ignore, <4 x i13> %x) {
  %res = extractelement <4 x i13> %x, i32 3
  ret i13 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v5i13:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i13 @extract_0_from_v5i13(i32 %ignore, <5 x i13> %x) {
  %res = extractelement <5 x i13> %x, i32 0
  ret i13 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v5i13:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i13 @extract_1_from_v5i13(i32 %ignore, <5 x i13> %x) {
  %res = extractelement <5 x i13> %x, i32 1
  ret i13 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v5i13:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i13 @extract_2_from_v5i13(i32 %ignore, <5 x i13> %x) {
  %res = extractelement <5 x i13> %x, i32 2
  ret i13 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v5i13:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i13 @extract_3_from_v5i13(i32 %ignore, <5 x i13> %x) {
  %res = extractelement <5 x i13> %x, i32 3
  ret i13 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v5i13:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i13 @extract_4_from_v5i13(i32 %ignore, <5 x i13> %x) {
  %res = extractelement <5 x i13> %x, i32 4
  ret i13 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v6i13:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i13 @extract_0_from_v6i13(i32 %ignore, <6 x i13> %x) {
  %res = extractelement <6 x i13> %x, i32 0
  ret i13 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v6i13:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i13 @extract_1_from_v6i13(i32 %ignore, <6 x i13> %x) {
  %res = extractelement <6 x i13> %x, i32 1
  ret i13 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v6i13:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i13 @extract_2_from_v6i13(i32 %ignore, <6 x i13> %x) {
  %res = extractelement <6 x i13> %x, i32 2
  ret i13 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v6i13:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i13 @extract_3_from_v6i13(i32 %ignore, <6 x i13> %x) {
  %res = extractelement <6 x i13> %x, i32 3
  ret i13 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v6i13:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i13 @extract_4_from_v6i13(i32 %ignore, <6 x i13> %x) {
  %res = extractelement <6 x i13> %x, i32 4
  ret i13 %res
}
; CC: scalarise
; CHECK-LABEL: extract_5_from_v6i13:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 2
; CHECK:       br $m10
define i13 @extract_5_from_v6i13(i32 %ignore, <6 x i13> %x) {
  %res = extractelement <6 x i13> %x, i32 5
  ret i13 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v7i13:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i13 @extract_0_from_v7i13(i32 %ignore, <7 x i13> %x) {
  %res = extractelement <7 x i13> %x, i32 0
  ret i13 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v7i13:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i13 @extract_1_from_v7i13(i32 %ignore, <7 x i13> %x) {
  %res = extractelement <7 x i13> %x, i32 1
  ret i13 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v7i13:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i13 @extract_2_from_v7i13(i32 %ignore, <7 x i13> %x) {
  %res = extractelement <7 x i13> %x, i32 2
  ret i13 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v7i13:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i13 @extract_3_from_v7i13(i32 %ignore, <7 x i13> %x) {
  %res = extractelement <7 x i13> %x, i32 3
  ret i13 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v7i13:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i13 @extract_4_from_v7i13(i32 %ignore, <7 x i13> %x) {
  %res = extractelement <7 x i13> %x, i32 4
  ret i13 %res
}
; CC: scalarise
; CHECK-LABEL: extract_5_from_v7i13:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 2
; CHECK:       br $m10
define i13 @extract_5_from_v7i13(i32 %ignore, <7 x i13> %x) {
  %res = extractelement <7 x i13> %x, i32 5
  ret i13 %res
}
; CC: scalarise
; CHECK-LABEL: extract_6_from_v7i13:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 3
; CHECK:       br $m10
define i13 @extract_6_from_v7i13(i32 %ignore, <7 x i13> %x) {
  %res = extractelement <7 x i13> %x, i32 6
  ret i13 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v8i13:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i13 @extract_0_from_v8i13(i32 %ignore, <8 x i13> %x) {
  %res = extractelement <8 x i13> %x, i32 0
  ret i13 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v8i13:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i13 @extract_1_from_v8i13(i32 %ignore, <8 x i13> %x) {
  %res = extractelement <8 x i13> %x, i32 1
  ret i13 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v8i13:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i13 @extract_2_from_v8i13(i32 %ignore, <8 x i13> %x) {
  %res = extractelement <8 x i13> %x, i32 2
  ret i13 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v8i13:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i13 @extract_3_from_v8i13(i32 %ignore, <8 x i13> %x) {
  %res = extractelement <8 x i13> %x, i32 3
  ret i13 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v8i13:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i13 @extract_4_from_v8i13(i32 %ignore, <8 x i13> %x) {
  %res = extractelement <8 x i13> %x, i32 4
  ret i13 %res
}
; CC: scalarise
; CHECK-LABEL: extract_5_from_v8i13:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 2
; CHECK:       br $m10
define i13 @extract_5_from_v8i13(i32 %ignore, <8 x i13> %x) {
  %res = extractelement <8 x i13> %x, i32 5
  ret i13 %res
}
; CC: scalarise
; CHECK-LABEL: extract_6_from_v8i13:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 3
; CHECK:       br $m10
define i13 @extract_6_from_v8i13(i32 %ignore, <8 x i13> %x) {
  %res = extractelement <8 x i13> %x, i32 6
  ret i13 %res
}
; CC: scalarise
; CHECK-LABEL: extract_7_from_v8i13:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 4
; CHECK:       br $m10
define i13 @extract_7_from_v8i13(i32 %ignore, <8 x i13> %x) {
  %res = extractelement <8 x i13> %x, i32 7
  ret i13 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v1i14:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i14 @extract_0_from_v1i14(i32 %ignore, <1 x i14> %x) {
  %res = extractelement <1 x i14> %x, i32 0
  ret i14 %res
}
; CC: pass as v2i16
; CHECK-LABEL: extract_0_from_v2i14:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i14 @extract_0_from_v2i14(i32 %ignore, <2 x i14> %x) {
  %res = extractelement <2 x i14> %x, i32 0
  ret i14 %res
}
; CC: pass as v2i16
; CHECK-LABEL: extract_1_from_v2i14:
; CHECK:       # %bb.0:
; CHECK-NEXT:  swap16 $m0, $m1
; CHECK:       br $m10
define i14 @extract_1_from_v2i14(i32 %ignore, <2 x i14> %x) {
  %res = extractelement <2 x i14> %x, i32 1
  ret i14 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v3i14:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i14 @extract_0_from_v3i14(i32 %ignore, <3 x i14> %x) {
  %res = extractelement <3 x i14> %x, i32 0
  ret i14 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v3i14:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i14 @extract_1_from_v3i14(i32 %ignore, <3 x i14> %x) {
  %res = extractelement <3 x i14> %x, i32 1
  ret i14 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v3i14:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i14 @extract_2_from_v3i14(i32 %ignore, <3 x i14> %x) {
  %res = extractelement <3 x i14> %x, i32 2
  ret i14 %res
}
; CC: pass as v4i16
; CHECK-LABEL: extract_0_from_v4i14:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK-NEXT:  mov $m1, $m3
; CHECK:       br $m10
define i14 @extract_0_from_v4i14(i32 %ignore, <4 x i14> %x) {
  %res = extractelement <4 x i14> %x, i32 0
  ret i14 %res
}
; CC: pass as v4i16
; CHECK-LABEL: extract_1_from_v4i14:
; CHECK:       # %bb.0:
; CHECK-NEXT:  swap16 $m0, $m2
; CHECK:       br $m10
define i14 @extract_1_from_v4i14(i32 %ignore, <4 x i14> %x) {
  %res = extractelement <4 x i14> %x, i32 1
  ret i14 %res
}
; CC: pass as v4i16
; CHECK-LABEL: extract_2_from_v4i14:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i14 @extract_2_from_v4i14(i32 %ignore, <4 x i14> %x) {
  %res = extractelement <4 x i14> %x, i32 2
  ret i14 %res
}
; CC: pass as v4i16
; CHECK-LABEL: extract_3_from_v4i14:
; CHECK:       # %bb.0:
; CHECK-NEXT:  swap16 $m0, $m3
; CHECK:       br $m10
define i14 @extract_3_from_v4i14(i32 %ignore, <4 x i14> %x) {
  %res = extractelement <4 x i14> %x, i32 3
  ret i14 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v5i14:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i14 @extract_0_from_v5i14(i32 %ignore, <5 x i14> %x) {
  %res = extractelement <5 x i14> %x, i32 0
  ret i14 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v5i14:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i14 @extract_1_from_v5i14(i32 %ignore, <5 x i14> %x) {
  %res = extractelement <5 x i14> %x, i32 1
  ret i14 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v5i14:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i14 @extract_2_from_v5i14(i32 %ignore, <5 x i14> %x) {
  %res = extractelement <5 x i14> %x, i32 2
  ret i14 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v5i14:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i14 @extract_3_from_v5i14(i32 %ignore, <5 x i14> %x) {
  %res = extractelement <5 x i14> %x, i32 3
  ret i14 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v5i14:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i14 @extract_4_from_v5i14(i32 %ignore, <5 x i14> %x) {
  %res = extractelement <5 x i14> %x, i32 4
  ret i14 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v6i14:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i14 @extract_0_from_v6i14(i32 %ignore, <6 x i14> %x) {
  %res = extractelement <6 x i14> %x, i32 0
  ret i14 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v6i14:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i14 @extract_1_from_v6i14(i32 %ignore, <6 x i14> %x) {
  %res = extractelement <6 x i14> %x, i32 1
  ret i14 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v6i14:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i14 @extract_2_from_v6i14(i32 %ignore, <6 x i14> %x) {
  %res = extractelement <6 x i14> %x, i32 2
  ret i14 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v6i14:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i14 @extract_3_from_v6i14(i32 %ignore, <6 x i14> %x) {
  %res = extractelement <6 x i14> %x, i32 3
  ret i14 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v6i14:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i14 @extract_4_from_v6i14(i32 %ignore, <6 x i14> %x) {
  %res = extractelement <6 x i14> %x, i32 4
  ret i14 %res
}
; CC: scalarise
; CHECK-LABEL: extract_5_from_v6i14:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 2
; CHECK:       br $m10
define i14 @extract_5_from_v6i14(i32 %ignore, <6 x i14> %x) {
  %res = extractelement <6 x i14> %x, i32 5
  ret i14 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v7i14:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i14 @extract_0_from_v7i14(i32 %ignore, <7 x i14> %x) {
  %res = extractelement <7 x i14> %x, i32 0
  ret i14 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v7i14:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i14 @extract_1_from_v7i14(i32 %ignore, <7 x i14> %x) {
  %res = extractelement <7 x i14> %x, i32 1
  ret i14 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v7i14:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i14 @extract_2_from_v7i14(i32 %ignore, <7 x i14> %x) {
  %res = extractelement <7 x i14> %x, i32 2
  ret i14 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v7i14:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i14 @extract_3_from_v7i14(i32 %ignore, <7 x i14> %x) {
  %res = extractelement <7 x i14> %x, i32 3
  ret i14 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v7i14:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i14 @extract_4_from_v7i14(i32 %ignore, <7 x i14> %x) {
  %res = extractelement <7 x i14> %x, i32 4
  ret i14 %res
}
; CC: scalarise
; CHECK-LABEL: extract_5_from_v7i14:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 2
; CHECK:       br $m10
define i14 @extract_5_from_v7i14(i32 %ignore, <7 x i14> %x) {
  %res = extractelement <7 x i14> %x, i32 5
  ret i14 %res
}
; CC: scalarise
; CHECK-LABEL: extract_6_from_v7i14:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 3
; CHECK:       br $m10
define i14 @extract_6_from_v7i14(i32 %ignore, <7 x i14> %x) {
  %res = extractelement <7 x i14> %x, i32 6
  ret i14 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v8i14:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i14 @extract_0_from_v8i14(i32 %ignore, <8 x i14> %x) {
  %res = extractelement <8 x i14> %x, i32 0
  ret i14 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v8i14:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i14 @extract_1_from_v8i14(i32 %ignore, <8 x i14> %x) {
  %res = extractelement <8 x i14> %x, i32 1
  ret i14 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v8i14:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i14 @extract_2_from_v8i14(i32 %ignore, <8 x i14> %x) {
  %res = extractelement <8 x i14> %x, i32 2
  ret i14 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v8i14:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i14 @extract_3_from_v8i14(i32 %ignore, <8 x i14> %x) {
  %res = extractelement <8 x i14> %x, i32 3
  ret i14 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v8i14:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i14 @extract_4_from_v8i14(i32 %ignore, <8 x i14> %x) {
  %res = extractelement <8 x i14> %x, i32 4
  ret i14 %res
}
; CC: scalarise
; CHECK-LABEL: extract_5_from_v8i14:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 2
; CHECK:       br $m10
define i14 @extract_5_from_v8i14(i32 %ignore, <8 x i14> %x) {
  %res = extractelement <8 x i14> %x, i32 5
  ret i14 %res
}
; CC: scalarise
; CHECK-LABEL: extract_6_from_v8i14:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 3
; CHECK:       br $m10
define i14 @extract_6_from_v8i14(i32 %ignore, <8 x i14> %x) {
  %res = extractelement <8 x i14> %x, i32 6
  ret i14 %res
}
; CC: scalarise
; CHECK-LABEL: extract_7_from_v8i14:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 4
; CHECK:       br $m10
define i14 @extract_7_from_v8i14(i32 %ignore, <8 x i14> %x) {
  %res = extractelement <8 x i14> %x, i32 7
  ret i14 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v1i15:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i15 @extract_0_from_v1i15(i32 %ignore, <1 x i15> %x) {
  %res = extractelement <1 x i15> %x, i32 0
  ret i15 %res
}
; CC: pass as v2i16
; CHECK-LABEL: extract_0_from_v2i15:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i15 @extract_0_from_v2i15(i32 %ignore, <2 x i15> %x) {
  %res = extractelement <2 x i15> %x, i32 0
  ret i15 %res
}
; CC: pass as v2i16
; CHECK-LABEL: extract_1_from_v2i15:
; CHECK:       # %bb.0:
; CHECK-NEXT:  swap16 $m0, $m1
; CHECK:       br $m10
define i15 @extract_1_from_v2i15(i32 %ignore, <2 x i15> %x) {
  %res = extractelement <2 x i15> %x, i32 1
  ret i15 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v3i15:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i15 @extract_0_from_v3i15(i32 %ignore, <3 x i15> %x) {
  %res = extractelement <3 x i15> %x, i32 0
  ret i15 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v3i15:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i15 @extract_1_from_v3i15(i32 %ignore, <3 x i15> %x) {
  %res = extractelement <3 x i15> %x, i32 1
  ret i15 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v3i15:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i15 @extract_2_from_v3i15(i32 %ignore, <3 x i15> %x) {
  %res = extractelement <3 x i15> %x, i32 2
  ret i15 %res
}
; CC: pass as v4i16
; CHECK-LABEL: extract_0_from_v4i15:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK-NEXT:  mov $m1, $m3
; CHECK:       br $m10
define i15 @extract_0_from_v4i15(i32 %ignore, <4 x i15> %x) {
  %res = extractelement <4 x i15> %x, i32 0
  ret i15 %res
}
; CC: pass as v4i16
; CHECK-LABEL: extract_1_from_v4i15:
; CHECK:       # %bb.0:
; CHECK-NEXT:  swap16 $m0, $m2
; CHECK:       br $m10
define i15 @extract_1_from_v4i15(i32 %ignore, <4 x i15> %x) {
  %res = extractelement <4 x i15> %x, i32 1
  ret i15 %res
}
; CC: pass as v4i16
; CHECK-LABEL: extract_2_from_v4i15:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i15 @extract_2_from_v4i15(i32 %ignore, <4 x i15> %x) {
  %res = extractelement <4 x i15> %x, i32 2
  ret i15 %res
}
; CC: pass as v4i16
; CHECK-LABEL: extract_3_from_v4i15:
; CHECK:       # %bb.0:
; CHECK-NEXT:  swap16 $m0, $m3
; CHECK:       br $m10
define i15 @extract_3_from_v4i15(i32 %ignore, <4 x i15> %x) {
  %res = extractelement <4 x i15> %x, i32 3
  ret i15 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v5i15:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i15 @extract_0_from_v5i15(i32 %ignore, <5 x i15> %x) {
  %res = extractelement <5 x i15> %x, i32 0
  ret i15 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v5i15:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i15 @extract_1_from_v5i15(i32 %ignore, <5 x i15> %x) {
  %res = extractelement <5 x i15> %x, i32 1
  ret i15 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v5i15:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i15 @extract_2_from_v5i15(i32 %ignore, <5 x i15> %x) {
  %res = extractelement <5 x i15> %x, i32 2
  ret i15 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v5i15:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i15 @extract_3_from_v5i15(i32 %ignore, <5 x i15> %x) {
  %res = extractelement <5 x i15> %x, i32 3
  ret i15 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v5i15:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i15 @extract_4_from_v5i15(i32 %ignore, <5 x i15> %x) {
  %res = extractelement <5 x i15> %x, i32 4
  ret i15 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v6i15:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i15 @extract_0_from_v6i15(i32 %ignore, <6 x i15> %x) {
  %res = extractelement <6 x i15> %x, i32 0
  ret i15 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v6i15:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i15 @extract_1_from_v6i15(i32 %ignore, <6 x i15> %x) {
  %res = extractelement <6 x i15> %x, i32 1
  ret i15 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v6i15:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i15 @extract_2_from_v6i15(i32 %ignore, <6 x i15> %x) {
  %res = extractelement <6 x i15> %x, i32 2
  ret i15 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v6i15:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i15 @extract_3_from_v6i15(i32 %ignore, <6 x i15> %x) {
  %res = extractelement <6 x i15> %x, i32 3
  ret i15 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v6i15:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i15 @extract_4_from_v6i15(i32 %ignore, <6 x i15> %x) {
  %res = extractelement <6 x i15> %x, i32 4
  ret i15 %res
}
; CC: scalarise
; CHECK-LABEL: extract_5_from_v6i15:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 2
; CHECK:       br $m10
define i15 @extract_5_from_v6i15(i32 %ignore, <6 x i15> %x) {
  %res = extractelement <6 x i15> %x, i32 5
  ret i15 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v7i15:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i15 @extract_0_from_v7i15(i32 %ignore, <7 x i15> %x) {
  %res = extractelement <7 x i15> %x, i32 0
  ret i15 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v7i15:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i15 @extract_1_from_v7i15(i32 %ignore, <7 x i15> %x) {
  %res = extractelement <7 x i15> %x, i32 1
  ret i15 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v7i15:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i15 @extract_2_from_v7i15(i32 %ignore, <7 x i15> %x) {
  %res = extractelement <7 x i15> %x, i32 2
  ret i15 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v7i15:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i15 @extract_3_from_v7i15(i32 %ignore, <7 x i15> %x) {
  %res = extractelement <7 x i15> %x, i32 3
  ret i15 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v7i15:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i15 @extract_4_from_v7i15(i32 %ignore, <7 x i15> %x) {
  %res = extractelement <7 x i15> %x, i32 4
  ret i15 %res
}
; CC: scalarise
; CHECK-LABEL: extract_5_from_v7i15:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 2
; CHECK:       br $m10
define i15 @extract_5_from_v7i15(i32 %ignore, <7 x i15> %x) {
  %res = extractelement <7 x i15> %x, i32 5
  ret i15 %res
}
; CC: scalarise
; CHECK-LABEL: extract_6_from_v7i15:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 3
; CHECK:       br $m10
define i15 @extract_6_from_v7i15(i32 %ignore, <7 x i15> %x) {
  %res = extractelement <7 x i15> %x, i32 6
  ret i15 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v8i15:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i15 @extract_0_from_v8i15(i32 %ignore, <8 x i15> %x) {
  %res = extractelement <8 x i15> %x, i32 0
  ret i15 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v8i15:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i15 @extract_1_from_v8i15(i32 %ignore, <8 x i15> %x) {
  %res = extractelement <8 x i15> %x, i32 1
  ret i15 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v8i15:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i15 @extract_2_from_v8i15(i32 %ignore, <8 x i15> %x) {
  %res = extractelement <8 x i15> %x, i32 2
  ret i15 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v8i15:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i15 @extract_3_from_v8i15(i32 %ignore, <8 x i15> %x) {
  %res = extractelement <8 x i15> %x, i32 3
  ret i15 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v8i15:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i15 @extract_4_from_v8i15(i32 %ignore, <8 x i15> %x) {
  %res = extractelement <8 x i15> %x, i32 4
  ret i15 %res
}
; CC: scalarise
; CHECK-LABEL: extract_5_from_v8i15:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 2
; CHECK:       br $m10
define i15 @extract_5_from_v8i15(i32 %ignore, <8 x i15> %x) {
  %res = extractelement <8 x i15> %x, i32 5
  ret i15 %res
}
; CC: scalarise
; CHECK-LABEL: extract_6_from_v8i15:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 3
; CHECK:       br $m10
define i15 @extract_6_from_v8i15(i32 %ignore, <8 x i15> %x) {
  %res = extractelement <8 x i15> %x, i32 6
  ret i15 %res
}
; CC: scalarise
; CHECK-LABEL: extract_7_from_v8i15:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 4
; CHECK:       br $m10
define i15 @extract_7_from_v8i15(i32 %ignore, <8 x i15> %x) {
  %res = extractelement <8 x i15> %x, i32 7
  ret i15 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v1i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i16 @extract_0_from_v1i16(i32 %ignore, <1 x i16> %x) {
  %res = extractelement <1 x i16> %x, i32 0
  ret i16 %res
}
; CC: pass as v2i16
; CHECK-LABEL: extract_0_from_v2i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i16 @extract_0_from_v2i16(i32 %ignore, <2 x i16> %x) {
  %res = extractelement <2 x i16> %x, i32 0
  ret i16 %res
}
; CC: pass as v2i16
; CHECK-LABEL: extract_1_from_v2i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shr $m0, $m1, 16
; CHECK:       br $m10
define i16 @extract_1_from_v2i16(i32 %ignore, <2 x i16> %x) {
  %res = extractelement <2 x i16> %x, i32 1
  ret i16 %res
}
; CC: pass as v4i16
; CHECK-LABEL: extract_0_from_v3i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK-NEXT:  mov $m1, $m3
; CHECK:       br $m10
define i16 @extract_0_from_v3i16(i32 %ignore, <3 x i16> %x) {
  %res = extractelement <3 x i16> %x, i32 0
  ret i16 %res
}
; CC: pass as v4i16
; CHECK-LABEL: extract_1_from_v3i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  swap16 $m0, $m2
; CHECK:       br $m10
define i16 @extract_1_from_v3i16(i32 %ignore, <3 x i16> %x) {
  %res = extractelement <3 x i16> %x, i32 1
  ret i16 %res
}
; CC: pass as v4i16
; CHECK-LABEL: extract_2_from_v3i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i16 @extract_2_from_v3i16(i32 %ignore, <3 x i16> %x) {
  %res = extractelement <3 x i16> %x, i32 2
  ret i16 %res
}
; CC: pass as 1 v4i16
; CHECK-LABEL: extract_0_from_v4i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK-NEXT:  mov $m1, $m3
; CHECK:       br $m10
define i16 @extract_0_from_v4i16(i32 %ignore, <4 x i16> %x) {
  %res = extractelement <4 x i16> %x, i32 0
  ret i16 %res
}
; CC: pass as 1 v4i16
; CHECK-LABEL: extract_1_from_v4i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  swap16 $m0, $m2
; CHECK:       br $m10
define i16 @extract_1_from_v4i16(i32 %ignore, <4 x i16> %x) {
  %res = extractelement <4 x i16> %x, i32 1
  ret i16 %res
}
; CC: pass as 1 v4i16
; CHECK-LABEL: extract_2_from_v4i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i16 @extract_2_from_v4i16(i32 %ignore, <4 x i16> %x) {
  %res = extractelement <4 x i16> %x, i32 2
  ret i16 %res
}
; CC: pass as 1 v4i16
; CHECK-LABEL: extract_3_from_v4i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  swap16 $m0, $m3
; CHECK:       br $m10
define i16 @extract_3_from_v4i16(i32 %ignore, <4 x i16> %x) {
  %res = extractelement <4 x i16> %x, i32 3
  ret i16 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v5i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i16 @extract_0_from_v5i16(i32 %ignore, <5 x i16> %x) {
  %res = extractelement <5 x i16> %x, i32 0
  ret i16 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v5i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i16 @extract_1_from_v5i16(i32 %ignore, <5 x i16> %x) {
  %res = extractelement <5 x i16> %x, i32 1
  ret i16 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v5i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i16 @extract_2_from_v5i16(i32 %ignore, <5 x i16> %x) {
  %res = extractelement <5 x i16> %x, i32 2
  ret i16 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v5i16:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i16 @extract_3_from_v5i16(i32 %ignore, <5 x i16> %x) {
  %res = extractelement <5 x i16> %x, i32 3
  ret i16 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v5i16:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i16 @extract_4_from_v5i16(i32 %ignore, <5 x i16> %x) {
  %res = extractelement <5 x i16> %x, i32 4
  ret i16 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v6i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i16 @extract_0_from_v6i16(i32 %ignore, <6 x i16> %x) {
  %res = extractelement <6 x i16> %x, i32 0
  ret i16 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v6i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i16 @extract_1_from_v6i16(i32 %ignore, <6 x i16> %x) {
  %res = extractelement <6 x i16> %x, i32 1
  ret i16 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v6i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i16 @extract_2_from_v6i16(i32 %ignore, <6 x i16> %x) {
  %res = extractelement <6 x i16> %x, i32 2
  ret i16 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v6i16:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i16 @extract_3_from_v6i16(i32 %ignore, <6 x i16> %x) {
  %res = extractelement <6 x i16> %x, i32 3
  ret i16 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v6i16:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i16 @extract_4_from_v6i16(i32 %ignore, <6 x i16> %x) {
  %res = extractelement <6 x i16> %x, i32 4
  ret i16 %res
}
; CC: scalarise
; CHECK-LABEL: extract_5_from_v6i16:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 2
; CHECK:       br $m10
define i16 @extract_5_from_v6i16(i32 %ignore, <6 x i16> %x) {
  %res = extractelement <6 x i16> %x, i32 5
  ret i16 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v7i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i16 @extract_0_from_v7i16(i32 %ignore, <7 x i16> %x) {
  %res = extractelement <7 x i16> %x, i32 0
  ret i16 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v7i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i16 @extract_1_from_v7i16(i32 %ignore, <7 x i16> %x) {
  %res = extractelement <7 x i16> %x, i32 1
  ret i16 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v7i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i16 @extract_2_from_v7i16(i32 %ignore, <7 x i16> %x) {
  %res = extractelement <7 x i16> %x, i32 2
  ret i16 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v7i16:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i16 @extract_3_from_v7i16(i32 %ignore, <7 x i16> %x) {
  %res = extractelement <7 x i16> %x, i32 3
  ret i16 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v7i16:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i16 @extract_4_from_v7i16(i32 %ignore, <7 x i16> %x) {
  %res = extractelement <7 x i16> %x, i32 4
  ret i16 %res
}
; CC: scalarise
; CHECK-LABEL: extract_5_from_v7i16:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 2
; CHECK:       br $m10
define i16 @extract_5_from_v7i16(i32 %ignore, <7 x i16> %x) {
  %res = extractelement <7 x i16> %x, i32 5
  ret i16 %res
}
; CC: scalarise
; CHECK-LABEL: extract_6_from_v7i16:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 3
; CHECK:       br $m10
define i16 @extract_6_from_v7i16(i32 %ignore, <7 x i16> %x) {
  %res = extractelement <7 x i16> %x, i32 6
  ret i16 %res
}
; CC: pass as 2 v4i16
; CHECK-LABEL: extract_0_from_v8i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK-NEXT:  mov $m1, $m3
; CHECK:       br $m10
define i16 @extract_0_from_v8i16(i32 %ignore, <8 x i16> %x) {
  %res = extractelement <8 x i16> %x, i32 0
  ret i16 %res
}
; CC: pass as 2 v4i16
; CHECK-LABEL: extract_1_from_v8i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  swap16 $m0, $m2
; CHECK:       br $m10
define i16 @extract_1_from_v8i16(i32 %ignore, <8 x i16> %x) {
  %res = extractelement <8 x i16> %x, i32 1
  ret i16 %res
}
; CC: pass as 2 v4i16
; CHECK-LABEL: extract_2_from_v8i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i16 @extract_2_from_v8i16(i32 %ignore, <8 x i16> %x) {
  %res = extractelement <8 x i16> %x, i32 2
  ret i16 %res
}
; CC: pass as 2 v4i16
; CHECK-LABEL: extract_3_from_v8i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  swap16 $m0, $m3
; CHECK:       br $m10
define i16 @extract_3_from_v8i16(i32 %ignore, <8 x i16> %x) {
  %res = extractelement <8 x i16> %x, i32 3
  ret i16 %res
}
; CC: pass as 2 v4i16
; CHECK-LABEL: extract_4_from_v8i16:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i16 @extract_4_from_v8i16(i32 %ignore, <8 x i16> %x) {
  %res = extractelement <8 x i16> %x, i32 4
  ret i16 %res
}
; CC: pass as 2 v4i16
; CHECK-LABEL: extract_5_from_v8i16:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i16 @extract_5_from_v8i16(i32 %ignore, <8 x i16> %x) {
  %res = extractelement <8 x i16> %x, i32 5
  ret i16 %res
}
; CC: pass as 2 v4i16
; CHECK-LABEL: extract_6_from_v8i16:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i16 @extract_6_from_v8i16(i32 %ignore, <8 x i16> %x) {
  %res = extractelement <8 x i16> %x, i32 6
  ret i16 %res
}
; CC: pass as 2 v4i16
; CHECK-LABEL: extract_7_from_v8i16:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i16 @extract_7_from_v8i16(i32 %ignore, <8 x i16> %x) {
  %res = extractelement <8 x i16> %x, i32 7
  ret i16 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v1i17:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i17 @extract_0_from_v1i17(i32 %ignore, <1 x i17> %x) {
  %res = extractelement <1 x i17> %x, i32 0
  ret i17 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v2i17:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK-NEXT:  mov $m1, $m3
; CHECK:       br $m10
define i17 @extract_0_from_v2i17(i32 %ignore, <2 x i17> %x) {
  %res = extractelement <2 x i17> %x, i32 0
  ret i17 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v2i17:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i17 @extract_1_from_v2i17(i32 %ignore, <2 x i17> %x) {
  %res = extractelement <2 x i17> %x, i32 1
  ret i17 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v3i17:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i17 @extract_0_from_v3i17(i32 %ignore, <3 x i17> %x) {
  %res = extractelement <3 x i17> %x, i32 0
  ret i17 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v3i17:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i17 @extract_1_from_v3i17(i32 %ignore, <3 x i17> %x) {
  %res = extractelement <3 x i17> %x, i32 1
  ret i17 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v3i17:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i17 @extract_2_from_v3i17(i32 %ignore, <3 x i17> %x) {
  %res = extractelement <3 x i17> %x, i32 2
  ret i17 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v4i17:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i17 @extract_0_from_v4i17(i32 %ignore, <4 x i17> %x) {
  %res = extractelement <4 x i17> %x, i32 0
  ret i17 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v4i17:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i17 @extract_1_from_v4i17(i32 %ignore, <4 x i17> %x) {
  %res = extractelement <4 x i17> %x, i32 1
  ret i17 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v4i17:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i17 @extract_2_from_v4i17(i32 %ignore, <4 x i17> %x) {
  %res = extractelement <4 x i17> %x, i32 2
  ret i17 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v4i17:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i17 @extract_3_from_v4i17(i32 %ignore, <4 x i17> %x) {
  %res = extractelement <4 x i17> %x, i32 3
  ret i17 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v5i17:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i17 @extract_0_from_v5i17(i32 %ignore, <5 x i17> %x) {
  %res = extractelement <5 x i17> %x, i32 0
  ret i17 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v5i17:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i17 @extract_1_from_v5i17(i32 %ignore, <5 x i17> %x) {
  %res = extractelement <5 x i17> %x, i32 1
  ret i17 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v5i17:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i17 @extract_2_from_v5i17(i32 %ignore, <5 x i17> %x) {
  %res = extractelement <5 x i17> %x, i32 2
  ret i17 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v5i17:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i17 @extract_3_from_v5i17(i32 %ignore, <5 x i17> %x) {
  %res = extractelement <5 x i17> %x, i32 3
  ret i17 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v5i17:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i17 @extract_4_from_v5i17(i32 %ignore, <5 x i17> %x) {
  %res = extractelement <5 x i17> %x, i32 4
  ret i17 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v6i17:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i17 @extract_0_from_v6i17(i32 %ignore, <6 x i17> %x) {
  %res = extractelement <6 x i17> %x, i32 0
  ret i17 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v6i17:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i17 @extract_1_from_v6i17(i32 %ignore, <6 x i17> %x) {
  %res = extractelement <6 x i17> %x, i32 1
  ret i17 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v6i17:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i17 @extract_2_from_v6i17(i32 %ignore, <6 x i17> %x) {
  %res = extractelement <6 x i17> %x, i32 2
  ret i17 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v6i17:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i17 @extract_3_from_v6i17(i32 %ignore, <6 x i17> %x) {
  %res = extractelement <6 x i17> %x, i32 3
  ret i17 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v6i17:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i17 @extract_4_from_v6i17(i32 %ignore, <6 x i17> %x) {
  %res = extractelement <6 x i17> %x, i32 4
  ret i17 %res
}
; CC: scalarise
; CHECK-LABEL: extract_5_from_v6i17:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 2
; CHECK:       br $m10
define i17 @extract_5_from_v6i17(i32 %ignore, <6 x i17> %x) {
  %res = extractelement <6 x i17> %x, i32 5
  ret i17 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v7i17:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i17 @extract_0_from_v7i17(i32 %ignore, <7 x i17> %x) {
  %res = extractelement <7 x i17> %x, i32 0
  ret i17 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v7i17:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i17 @extract_1_from_v7i17(i32 %ignore, <7 x i17> %x) {
  %res = extractelement <7 x i17> %x, i32 1
  ret i17 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v7i17:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i17 @extract_2_from_v7i17(i32 %ignore, <7 x i17> %x) {
  %res = extractelement <7 x i17> %x, i32 2
  ret i17 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v7i17:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i17 @extract_3_from_v7i17(i32 %ignore, <7 x i17> %x) {
  %res = extractelement <7 x i17> %x, i32 3
  ret i17 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v7i17:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i17 @extract_4_from_v7i17(i32 %ignore, <7 x i17> %x) {
  %res = extractelement <7 x i17> %x, i32 4
  ret i17 %res
}
; CC: scalarise
; CHECK-LABEL: extract_5_from_v7i17:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 2
; CHECK:       br $m10
define i17 @extract_5_from_v7i17(i32 %ignore, <7 x i17> %x) {
  %res = extractelement <7 x i17> %x, i32 5
  ret i17 %res
}
; CC: scalarise
; CHECK-LABEL: extract_6_from_v7i17:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 3
; CHECK:       br $m10
define i17 @extract_6_from_v7i17(i32 %ignore, <7 x i17> %x) {
  %res = extractelement <7 x i17> %x, i32 6
  ret i17 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v8i17:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i17 @extract_0_from_v8i17(i32 %ignore, <8 x i17> %x) {
  %res = extractelement <8 x i17> %x, i32 0
  ret i17 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v8i17:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i17 @extract_1_from_v8i17(i32 %ignore, <8 x i17> %x) {
  %res = extractelement <8 x i17> %x, i32 1
  ret i17 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v8i17:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i17 @extract_2_from_v8i17(i32 %ignore, <8 x i17> %x) {
  %res = extractelement <8 x i17> %x, i32 2
  ret i17 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v8i17:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i17 @extract_3_from_v8i17(i32 %ignore, <8 x i17> %x) {
  %res = extractelement <8 x i17> %x, i32 3
  ret i17 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v8i17:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i17 @extract_4_from_v8i17(i32 %ignore, <8 x i17> %x) {
  %res = extractelement <8 x i17> %x, i32 4
  ret i17 %res
}
; CC: scalarise
; CHECK-LABEL: extract_5_from_v8i17:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 2
; CHECK:       br $m10
define i17 @extract_5_from_v8i17(i32 %ignore, <8 x i17> %x) {
  %res = extractelement <8 x i17> %x, i32 5
  ret i17 %res
}
; CC: scalarise
; CHECK-LABEL: extract_6_from_v8i17:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 3
; CHECK:       br $m10
define i17 @extract_6_from_v8i17(i32 %ignore, <8 x i17> %x) {
  %res = extractelement <8 x i17> %x, i32 6
  ret i17 %res
}
; CC: scalarise
; CHECK-LABEL: extract_7_from_v8i17:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 4
; CHECK:       br $m10
define i17 @extract_7_from_v8i17(i32 %ignore, <8 x i17> %x) {
  %res = extractelement <8 x i17> %x, i32 7
  ret i17 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v1i18:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i18 @extract_0_from_v1i18(i32 %ignore, <1 x i18> %x) {
  %res = extractelement <1 x i18> %x, i32 0
  ret i18 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v2i18:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK-NEXT:  mov $m1, $m3
; CHECK:       br $m10
define i18 @extract_0_from_v2i18(i32 %ignore, <2 x i18> %x) {
  %res = extractelement <2 x i18> %x, i32 0
  ret i18 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v2i18:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i18 @extract_1_from_v2i18(i32 %ignore, <2 x i18> %x) {
  %res = extractelement <2 x i18> %x, i32 1
  ret i18 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v3i18:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i18 @extract_0_from_v3i18(i32 %ignore, <3 x i18> %x) {
  %res = extractelement <3 x i18> %x, i32 0
  ret i18 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v3i18:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i18 @extract_1_from_v3i18(i32 %ignore, <3 x i18> %x) {
  %res = extractelement <3 x i18> %x, i32 1
  ret i18 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v3i18:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i18 @extract_2_from_v3i18(i32 %ignore, <3 x i18> %x) {
  %res = extractelement <3 x i18> %x, i32 2
  ret i18 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v4i18:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i18 @extract_0_from_v4i18(i32 %ignore, <4 x i18> %x) {
  %res = extractelement <4 x i18> %x, i32 0
  ret i18 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v4i18:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i18 @extract_1_from_v4i18(i32 %ignore, <4 x i18> %x) {
  %res = extractelement <4 x i18> %x, i32 1
  ret i18 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v4i18:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i18 @extract_2_from_v4i18(i32 %ignore, <4 x i18> %x) {
  %res = extractelement <4 x i18> %x, i32 2
  ret i18 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v4i18:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i18 @extract_3_from_v4i18(i32 %ignore, <4 x i18> %x) {
  %res = extractelement <4 x i18> %x, i32 3
  ret i18 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v5i18:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i18 @extract_0_from_v5i18(i32 %ignore, <5 x i18> %x) {
  %res = extractelement <5 x i18> %x, i32 0
  ret i18 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v5i18:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i18 @extract_1_from_v5i18(i32 %ignore, <5 x i18> %x) {
  %res = extractelement <5 x i18> %x, i32 1
  ret i18 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v5i18:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i18 @extract_2_from_v5i18(i32 %ignore, <5 x i18> %x) {
  %res = extractelement <5 x i18> %x, i32 2
  ret i18 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v5i18:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i18 @extract_3_from_v5i18(i32 %ignore, <5 x i18> %x) {
  %res = extractelement <5 x i18> %x, i32 3
  ret i18 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v5i18:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i18 @extract_4_from_v5i18(i32 %ignore, <5 x i18> %x) {
  %res = extractelement <5 x i18> %x, i32 4
  ret i18 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v6i18:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i18 @extract_0_from_v6i18(i32 %ignore, <6 x i18> %x) {
  %res = extractelement <6 x i18> %x, i32 0
  ret i18 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v6i18:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i18 @extract_1_from_v6i18(i32 %ignore, <6 x i18> %x) {
  %res = extractelement <6 x i18> %x, i32 1
  ret i18 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v6i18:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i18 @extract_2_from_v6i18(i32 %ignore, <6 x i18> %x) {
  %res = extractelement <6 x i18> %x, i32 2
  ret i18 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v6i18:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i18 @extract_3_from_v6i18(i32 %ignore, <6 x i18> %x) {
  %res = extractelement <6 x i18> %x, i32 3
  ret i18 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v6i18:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i18 @extract_4_from_v6i18(i32 %ignore, <6 x i18> %x) {
  %res = extractelement <6 x i18> %x, i32 4
  ret i18 %res
}
; CC: scalarise
; CHECK-LABEL: extract_5_from_v6i18:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 2
; CHECK:       br $m10
define i18 @extract_5_from_v6i18(i32 %ignore, <6 x i18> %x) {
  %res = extractelement <6 x i18> %x, i32 5
  ret i18 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v7i18:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i18 @extract_0_from_v7i18(i32 %ignore, <7 x i18> %x) {
  %res = extractelement <7 x i18> %x, i32 0
  ret i18 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v7i18:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i18 @extract_1_from_v7i18(i32 %ignore, <7 x i18> %x) {
  %res = extractelement <7 x i18> %x, i32 1
  ret i18 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v7i18:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i18 @extract_2_from_v7i18(i32 %ignore, <7 x i18> %x) {
  %res = extractelement <7 x i18> %x, i32 2
  ret i18 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v7i18:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i18 @extract_3_from_v7i18(i32 %ignore, <7 x i18> %x) {
  %res = extractelement <7 x i18> %x, i32 3
  ret i18 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v7i18:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i18 @extract_4_from_v7i18(i32 %ignore, <7 x i18> %x) {
  %res = extractelement <7 x i18> %x, i32 4
  ret i18 %res
}
; CC: scalarise
; CHECK-LABEL: extract_5_from_v7i18:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 2
; CHECK:       br $m10
define i18 @extract_5_from_v7i18(i32 %ignore, <7 x i18> %x) {
  %res = extractelement <7 x i18> %x, i32 5
  ret i18 %res
}
; CC: scalarise
; CHECK-LABEL: extract_6_from_v7i18:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 3
; CHECK:       br $m10
define i18 @extract_6_from_v7i18(i32 %ignore, <7 x i18> %x) {
  %res = extractelement <7 x i18> %x, i32 6
  ret i18 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v8i18:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i18 @extract_0_from_v8i18(i32 %ignore, <8 x i18> %x) {
  %res = extractelement <8 x i18> %x, i32 0
  ret i18 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v8i18:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i18 @extract_1_from_v8i18(i32 %ignore, <8 x i18> %x) {
  %res = extractelement <8 x i18> %x, i32 1
  ret i18 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v8i18:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i18 @extract_2_from_v8i18(i32 %ignore, <8 x i18> %x) {
  %res = extractelement <8 x i18> %x, i32 2
  ret i18 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v8i18:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i18 @extract_3_from_v8i18(i32 %ignore, <8 x i18> %x) {
  %res = extractelement <8 x i18> %x, i32 3
  ret i18 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v8i18:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i18 @extract_4_from_v8i18(i32 %ignore, <8 x i18> %x) {
  %res = extractelement <8 x i18> %x, i32 4
  ret i18 %res
}
; CC: scalarise
; CHECK-LABEL: extract_5_from_v8i18:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 2
; CHECK:       br $m10
define i18 @extract_5_from_v8i18(i32 %ignore, <8 x i18> %x) {
  %res = extractelement <8 x i18> %x, i32 5
  ret i18 %res
}
; CC: scalarise
; CHECK-LABEL: extract_6_from_v8i18:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 3
; CHECK:       br $m10
define i18 @extract_6_from_v8i18(i32 %ignore, <8 x i18> %x) {
  %res = extractelement <8 x i18> %x, i32 6
  ret i18 %res
}
; CC: scalarise
; CHECK-LABEL: extract_7_from_v8i18:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 4
; CHECK:       br $m10
define i18 @extract_7_from_v8i18(i32 %ignore, <8 x i18> %x) {
  %res = extractelement <8 x i18> %x, i32 7
  ret i18 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v1i19:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i19 @extract_0_from_v1i19(i32 %ignore, <1 x i19> %x) {
  %res = extractelement <1 x i19> %x, i32 0
  ret i19 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v2i19:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK-NEXT:  mov $m1, $m3
; CHECK:       br $m10
define i19 @extract_0_from_v2i19(i32 %ignore, <2 x i19> %x) {
  %res = extractelement <2 x i19> %x, i32 0
  ret i19 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v2i19:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i19 @extract_1_from_v2i19(i32 %ignore, <2 x i19> %x) {
  %res = extractelement <2 x i19> %x, i32 1
  ret i19 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v3i19:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i19 @extract_0_from_v3i19(i32 %ignore, <3 x i19> %x) {
  %res = extractelement <3 x i19> %x, i32 0
  ret i19 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v3i19:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i19 @extract_1_from_v3i19(i32 %ignore, <3 x i19> %x) {
  %res = extractelement <3 x i19> %x, i32 1
  ret i19 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v3i19:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i19 @extract_2_from_v3i19(i32 %ignore, <3 x i19> %x) {
  %res = extractelement <3 x i19> %x, i32 2
  ret i19 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v4i19:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i19 @extract_0_from_v4i19(i32 %ignore, <4 x i19> %x) {
  %res = extractelement <4 x i19> %x, i32 0
  ret i19 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v4i19:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i19 @extract_1_from_v4i19(i32 %ignore, <4 x i19> %x) {
  %res = extractelement <4 x i19> %x, i32 1
  ret i19 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v4i19:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i19 @extract_2_from_v4i19(i32 %ignore, <4 x i19> %x) {
  %res = extractelement <4 x i19> %x, i32 2
  ret i19 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v4i19:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i19 @extract_3_from_v4i19(i32 %ignore, <4 x i19> %x) {
  %res = extractelement <4 x i19> %x, i32 3
  ret i19 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v5i19:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i19 @extract_0_from_v5i19(i32 %ignore, <5 x i19> %x) {
  %res = extractelement <5 x i19> %x, i32 0
  ret i19 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v5i19:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i19 @extract_1_from_v5i19(i32 %ignore, <5 x i19> %x) {
  %res = extractelement <5 x i19> %x, i32 1
  ret i19 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v5i19:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i19 @extract_2_from_v5i19(i32 %ignore, <5 x i19> %x) {
  %res = extractelement <5 x i19> %x, i32 2
  ret i19 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v5i19:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i19 @extract_3_from_v5i19(i32 %ignore, <5 x i19> %x) {
  %res = extractelement <5 x i19> %x, i32 3
  ret i19 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v5i19:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i19 @extract_4_from_v5i19(i32 %ignore, <5 x i19> %x) {
  %res = extractelement <5 x i19> %x, i32 4
  ret i19 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v6i19:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i19 @extract_0_from_v6i19(i32 %ignore, <6 x i19> %x) {
  %res = extractelement <6 x i19> %x, i32 0
  ret i19 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v6i19:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i19 @extract_1_from_v6i19(i32 %ignore, <6 x i19> %x) {
  %res = extractelement <6 x i19> %x, i32 1
  ret i19 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v6i19:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i19 @extract_2_from_v6i19(i32 %ignore, <6 x i19> %x) {
  %res = extractelement <6 x i19> %x, i32 2
  ret i19 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v6i19:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i19 @extract_3_from_v6i19(i32 %ignore, <6 x i19> %x) {
  %res = extractelement <6 x i19> %x, i32 3
  ret i19 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v6i19:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i19 @extract_4_from_v6i19(i32 %ignore, <6 x i19> %x) {
  %res = extractelement <6 x i19> %x, i32 4
  ret i19 %res
}
; CC: scalarise
; CHECK-LABEL: extract_5_from_v6i19:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 2
; CHECK:       br $m10
define i19 @extract_5_from_v6i19(i32 %ignore, <6 x i19> %x) {
  %res = extractelement <6 x i19> %x, i32 5
  ret i19 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v7i19:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i19 @extract_0_from_v7i19(i32 %ignore, <7 x i19> %x) {
  %res = extractelement <7 x i19> %x, i32 0
  ret i19 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v7i19:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i19 @extract_1_from_v7i19(i32 %ignore, <7 x i19> %x) {
  %res = extractelement <7 x i19> %x, i32 1
  ret i19 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v7i19:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i19 @extract_2_from_v7i19(i32 %ignore, <7 x i19> %x) {
  %res = extractelement <7 x i19> %x, i32 2
  ret i19 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v7i19:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i19 @extract_3_from_v7i19(i32 %ignore, <7 x i19> %x) {
  %res = extractelement <7 x i19> %x, i32 3
  ret i19 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v7i19:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i19 @extract_4_from_v7i19(i32 %ignore, <7 x i19> %x) {
  %res = extractelement <7 x i19> %x, i32 4
  ret i19 %res
}
; CC: scalarise
; CHECK-LABEL: extract_5_from_v7i19:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 2
; CHECK:       br $m10
define i19 @extract_5_from_v7i19(i32 %ignore, <7 x i19> %x) {
  %res = extractelement <7 x i19> %x, i32 5
  ret i19 %res
}
; CC: scalarise
; CHECK-LABEL: extract_6_from_v7i19:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 3
; CHECK:       br $m10
define i19 @extract_6_from_v7i19(i32 %ignore, <7 x i19> %x) {
  %res = extractelement <7 x i19> %x, i32 6
  ret i19 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v8i19:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i19 @extract_0_from_v8i19(i32 %ignore, <8 x i19> %x) {
  %res = extractelement <8 x i19> %x, i32 0
  ret i19 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v8i19:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i19 @extract_1_from_v8i19(i32 %ignore, <8 x i19> %x) {
  %res = extractelement <8 x i19> %x, i32 1
  ret i19 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v8i19:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i19 @extract_2_from_v8i19(i32 %ignore, <8 x i19> %x) {
  %res = extractelement <8 x i19> %x, i32 2
  ret i19 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v8i19:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i19 @extract_3_from_v8i19(i32 %ignore, <8 x i19> %x) {
  %res = extractelement <8 x i19> %x, i32 3
  ret i19 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v8i19:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i19 @extract_4_from_v8i19(i32 %ignore, <8 x i19> %x) {
  %res = extractelement <8 x i19> %x, i32 4
  ret i19 %res
}
; CC: scalarise
; CHECK-LABEL: extract_5_from_v8i19:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 2
; CHECK:       br $m10
define i19 @extract_5_from_v8i19(i32 %ignore, <8 x i19> %x) {
  %res = extractelement <8 x i19> %x, i32 5
  ret i19 %res
}
; CC: scalarise
; CHECK-LABEL: extract_6_from_v8i19:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 3
; CHECK:       br $m10
define i19 @extract_6_from_v8i19(i32 %ignore, <8 x i19> %x) {
  %res = extractelement <8 x i19> %x, i32 6
  ret i19 %res
}
; CC: scalarise
; CHECK-LABEL: extract_7_from_v8i19:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 4
; CHECK:       br $m10
define i19 @extract_7_from_v8i19(i32 %ignore, <8 x i19> %x) {
  %res = extractelement <8 x i19> %x, i32 7
  ret i19 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v1i20:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i20 @extract_0_from_v1i20(i32 %ignore, <1 x i20> %x) {
  %res = extractelement <1 x i20> %x, i32 0
  ret i20 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v2i20:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK-NEXT:  mov $m1, $m3
; CHECK:       br $m10
define i20 @extract_0_from_v2i20(i32 %ignore, <2 x i20> %x) {
  %res = extractelement <2 x i20> %x, i32 0
  ret i20 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v2i20:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i20 @extract_1_from_v2i20(i32 %ignore, <2 x i20> %x) {
  %res = extractelement <2 x i20> %x, i32 1
  ret i20 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v3i20:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i20 @extract_0_from_v3i20(i32 %ignore, <3 x i20> %x) {
  %res = extractelement <3 x i20> %x, i32 0
  ret i20 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v3i20:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i20 @extract_1_from_v3i20(i32 %ignore, <3 x i20> %x) {
  %res = extractelement <3 x i20> %x, i32 1
  ret i20 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v3i20:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i20 @extract_2_from_v3i20(i32 %ignore, <3 x i20> %x) {
  %res = extractelement <3 x i20> %x, i32 2
  ret i20 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v4i20:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i20 @extract_0_from_v4i20(i32 %ignore, <4 x i20> %x) {
  %res = extractelement <4 x i20> %x, i32 0
  ret i20 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v4i20:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i20 @extract_1_from_v4i20(i32 %ignore, <4 x i20> %x) {
  %res = extractelement <4 x i20> %x, i32 1
  ret i20 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v4i20:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i20 @extract_2_from_v4i20(i32 %ignore, <4 x i20> %x) {
  %res = extractelement <4 x i20> %x, i32 2
  ret i20 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v4i20:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i20 @extract_3_from_v4i20(i32 %ignore, <4 x i20> %x) {
  %res = extractelement <4 x i20> %x, i32 3
  ret i20 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v5i20:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i20 @extract_0_from_v5i20(i32 %ignore, <5 x i20> %x) {
  %res = extractelement <5 x i20> %x, i32 0
  ret i20 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v5i20:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i20 @extract_1_from_v5i20(i32 %ignore, <5 x i20> %x) {
  %res = extractelement <5 x i20> %x, i32 1
  ret i20 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v5i20:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i20 @extract_2_from_v5i20(i32 %ignore, <5 x i20> %x) {
  %res = extractelement <5 x i20> %x, i32 2
  ret i20 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v5i20:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i20 @extract_3_from_v5i20(i32 %ignore, <5 x i20> %x) {
  %res = extractelement <5 x i20> %x, i32 3
  ret i20 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v5i20:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i20 @extract_4_from_v5i20(i32 %ignore, <5 x i20> %x) {
  %res = extractelement <5 x i20> %x, i32 4
  ret i20 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v6i20:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i20 @extract_0_from_v6i20(i32 %ignore, <6 x i20> %x) {
  %res = extractelement <6 x i20> %x, i32 0
  ret i20 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v6i20:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i20 @extract_1_from_v6i20(i32 %ignore, <6 x i20> %x) {
  %res = extractelement <6 x i20> %x, i32 1
  ret i20 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v6i20:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i20 @extract_2_from_v6i20(i32 %ignore, <6 x i20> %x) {
  %res = extractelement <6 x i20> %x, i32 2
  ret i20 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v6i20:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i20 @extract_3_from_v6i20(i32 %ignore, <6 x i20> %x) {
  %res = extractelement <6 x i20> %x, i32 3
  ret i20 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v6i20:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i20 @extract_4_from_v6i20(i32 %ignore, <6 x i20> %x) {
  %res = extractelement <6 x i20> %x, i32 4
  ret i20 %res
}
; CC: scalarise
; CHECK-LABEL: extract_5_from_v6i20:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 2
; CHECK:       br $m10
define i20 @extract_5_from_v6i20(i32 %ignore, <6 x i20> %x) {
  %res = extractelement <6 x i20> %x, i32 5
  ret i20 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v7i20:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i20 @extract_0_from_v7i20(i32 %ignore, <7 x i20> %x) {
  %res = extractelement <7 x i20> %x, i32 0
  ret i20 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v7i20:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i20 @extract_1_from_v7i20(i32 %ignore, <7 x i20> %x) {
  %res = extractelement <7 x i20> %x, i32 1
  ret i20 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v7i20:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i20 @extract_2_from_v7i20(i32 %ignore, <7 x i20> %x) {
  %res = extractelement <7 x i20> %x, i32 2
  ret i20 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v7i20:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i20 @extract_3_from_v7i20(i32 %ignore, <7 x i20> %x) {
  %res = extractelement <7 x i20> %x, i32 3
  ret i20 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v7i20:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i20 @extract_4_from_v7i20(i32 %ignore, <7 x i20> %x) {
  %res = extractelement <7 x i20> %x, i32 4
  ret i20 %res
}
; CC: scalarise
; CHECK-LABEL: extract_5_from_v7i20:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 2
; CHECK:       br $m10
define i20 @extract_5_from_v7i20(i32 %ignore, <7 x i20> %x) {
  %res = extractelement <7 x i20> %x, i32 5
  ret i20 %res
}
; CC: scalarise
; CHECK-LABEL: extract_6_from_v7i20:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 3
; CHECK:       br $m10
define i20 @extract_6_from_v7i20(i32 %ignore, <7 x i20> %x) {
  %res = extractelement <7 x i20> %x, i32 6
  ret i20 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v8i20:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i20 @extract_0_from_v8i20(i32 %ignore, <8 x i20> %x) {
  %res = extractelement <8 x i20> %x, i32 0
  ret i20 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v8i20:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i20 @extract_1_from_v8i20(i32 %ignore, <8 x i20> %x) {
  %res = extractelement <8 x i20> %x, i32 1
  ret i20 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v8i20:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i20 @extract_2_from_v8i20(i32 %ignore, <8 x i20> %x) {
  %res = extractelement <8 x i20> %x, i32 2
  ret i20 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v8i20:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i20 @extract_3_from_v8i20(i32 %ignore, <8 x i20> %x) {
  %res = extractelement <8 x i20> %x, i32 3
  ret i20 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v8i20:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i20 @extract_4_from_v8i20(i32 %ignore, <8 x i20> %x) {
  %res = extractelement <8 x i20> %x, i32 4
  ret i20 %res
}
; CC: scalarise
; CHECK-LABEL: extract_5_from_v8i20:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 2
; CHECK:       br $m10
define i20 @extract_5_from_v8i20(i32 %ignore, <8 x i20> %x) {
  %res = extractelement <8 x i20> %x, i32 5
  ret i20 %res
}
; CC: scalarise
; CHECK-LABEL: extract_6_from_v8i20:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 3
; CHECK:       br $m10
define i20 @extract_6_from_v8i20(i32 %ignore, <8 x i20> %x) {
  %res = extractelement <8 x i20> %x, i32 6
  ret i20 %res
}
; CC: scalarise
; CHECK-LABEL: extract_7_from_v8i20:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 4
; CHECK:       br $m10
define i20 @extract_7_from_v8i20(i32 %ignore, <8 x i20> %x) {
  %res = extractelement <8 x i20> %x, i32 7
  ret i20 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v1i21:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i21 @extract_0_from_v1i21(i32 %ignore, <1 x i21> %x) {
  %res = extractelement <1 x i21> %x, i32 0
  ret i21 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v2i21:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK-NEXT:  mov $m1, $m3
; CHECK:       br $m10
define i21 @extract_0_from_v2i21(i32 %ignore, <2 x i21> %x) {
  %res = extractelement <2 x i21> %x, i32 0
  ret i21 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v2i21:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i21 @extract_1_from_v2i21(i32 %ignore, <2 x i21> %x) {
  %res = extractelement <2 x i21> %x, i32 1
  ret i21 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v3i21:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i21 @extract_0_from_v3i21(i32 %ignore, <3 x i21> %x) {
  %res = extractelement <3 x i21> %x, i32 0
  ret i21 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v3i21:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i21 @extract_1_from_v3i21(i32 %ignore, <3 x i21> %x) {
  %res = extractelement <3 x i21> %x, i32 1
  ret i21 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v3i21:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i21 @extract_2_from_v3i21(i32 %ignore, <3 x i21> %x) {
  %res = extractelement <3 x i21> %x, i32 2
  ret i21 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v4i21:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i21 @extract_0_from_v4i21(i32 %ignore, <4 x i21> %x) {
  %res = extractelement <4 x i21> %x, i32 0
  ret i21 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v4i21:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i21 @extract_1_from_v4i21(i32 %ignore, <4 x i21> %x) {
  %res = extractelement <4 x i21> %x, i32 1
  ret i21 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v4i21:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i21 @extract_2_from_v4i21(i32 %ignore, <4 x i21> %x) {
  %res = extractelement <4 x i21> %x, i32 2
  ret i21 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v4i21:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i21 @extract_3_from_v4i21(i32 %ignore, <4 x i21> %x) {
  %res = extractelement <4 x i21> %x, i32 3
  ret i21 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v5i21:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i21 @extract_0_from_v5i21(i32 %ignore, <5 x i21> %x) {
  %res = extractelement <5 x i21> %x, i32 0
  ret i21 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v5i21:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i21 @extract_1_from_v5i21(i32 %ignore, <5 x i21> %x) {
  %res = extractelement <5 x i21> %x, i32 1
  ret i21 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v5i21:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i21 @extract_2_from_v5i21(i32 %ignore, <5 x i21> %x) {
  %res = extractelement <5 x i21> %x, i32 2
  ret i21 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v5i21:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i21 @extract_3_from_v5i21(i32 %ignore, <5 x i21> %x) {
  %res = extractelement <5 x i21> %x, i32 3
  ret i21 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v5i21:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i21 @extract_4_from_v5i21(i32 %ignore, <5 x i21> %x) {
  %res = extractelement <5 x i21> %x, i32 4
  ret i21 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v6i21:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i21 @extract_0_from_v6i21(i32 %ignore, <6 x i21> %x) {
  %res = extractelement <6 x i21> %x, i32 0
  ret i21 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v6i21:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i21 @extract_1_from_v6i21(i32 %ignore, <6 x i21> %x) {
  %res = extractelement <6 x i21> %x, i32 1
  ret i21 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v6i21:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i21 @extract_2_from_v6i21(i32 %ignore, <6 x i21> %x) {
  %res = extractelement <6 x i21> %x, i32 2
  ret i21 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v6i21:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i21 @extract_3_from_v6i21(i32 %ignore, <6 x i21> %x) {
  %res = extractelement <6 x i21> %x, i32 3
  ret i21 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v6i21:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i21 @extract_4_from_v6i21(i32 %ignore, <6 x i21> %x) {
  %res = extractelement <6 x i21> %x, i32 4
  ret i21 %res
}
; CC: scalarise
; CHECK-LABEL: extract_5_from_v6i21:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 2
; CHECK:       br $m10
define i21 @extract_5_from_v6i21(i32 %ignore, <6 x i21> %x) {
  %res = extractelement <6 x i21> %x, i32 5
  ret i21 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v7i21:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i21 @extract_0_from_v7i21(i32 %ignore, <7 x i21> %x) {
  %res = extractelement <7 x i21> %x, i32 0
  ret i21 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v7i21:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i21 @extract_1_from_v7i21(i32 %ignore, <7 x i21> %x) {
  %res = extractelement <7 x i21> %x, i32 1
  ret i21 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v7i21:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i21 @extract_2_from_v7i21(i32 %ignore, <7 x i21> %x) {
  %res = extractelement <7 x i21> %x, i32 2
  ret i21 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v7i21:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i21 @extract_3_from_v7i21(i32 %ignore, <7 x i21> %x) {
  %res = extractelement <7 x i21> %x, i32 3
  ret i21 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v7i21:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i21 @extract_4_from_v7i21(i32 %ignore, <7 x i21> %x) {
  %res = extractelement <7 x i21> %x, i32 4
  ret i21 %res
}
; CC: scalarise
; CHECK-LABEL: extract_5_from_v7i21:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 2
; CHECK:       br $m10
define i21 @extract_5_from_v7i21(i32 %ignore, <7 x i21> %x) {
  %res = extractelement <7 x i21> %x, i32 5
  ret i21 %res
}
; CC: scalarise
; CHECK-LABEL: extract_6_from_v7i21:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 3
; CHECK:       br $m10
define i21 @extract_6_from_v7i21(i32 %ignore, <7 x i21> %x) {
  %res = extractelement <7 x i21> %x, i32 6
  ret i21 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v8i21:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i21 @extract_0_from_v8i21(i32 %ignore, <8 x i21> %x) {
  %res = extractelement <8 x i21> %x, i32 0
  ret i21 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v8i21:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i21 @extract_1_from_v8i21(i32 %ignore, <8 x i21> %x) {
  %res = extractelement <8 x i21> %x, i32 1
  ret i21 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v8i21:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i21 @extract_2_from_v8i21(i32 %ignore, <8 x i21> %x) {
  %res = extractelement <8 x i21> %x, i32 2
  ret i21 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v8i21:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i21 @extract_3_from_v8i21(i32 %ignore, <8 x i21> %x) {
  %res = extractelement <8 x i21> %x, i32 3
  ret i21 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v8i21:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i21 @extract_4_from_v8i21(i32 %ignore, <8 x i21> %x) {
  %res = extractelement <8 x i21> %x, i32 4
  ret i21 %res
}
; CC: scalarise
; CHECK-LABEL: extract_5_from_v8i21:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 2
; CHECK:       br $m10
define i21 @extract_5_from_v8i21(i32 %ignore, <8 x i21> %x) {
  %res = extractelement <8 x i21> %x, i32 5
  ret i21 %res
}
; CC: scalarise
; CHECK-LABEL: extract_6_from_v8i21:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 3
; CHECK:       br $m10
define i21 @extract_6_from_v8i21(i32 %ignore, <8 x i21> %x) {
  %res = extractelement <8 x i21> %x, i32 6
  ret i21 %res
}
; CC: scalarise
; CHECK-LABEL: extract_7_from_v8i21:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 4
; CHECK:       br $m10
define i21 @extract_7_from_v8i21(i32 %ignore, <8 x i21> %x) {
  %res = extractelement <8 x i21> %x, i32 7
  ret i21 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v1i22:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i22 @extract_0_from_v1i22(i32 %ignore, <1 x i22> %x) {
  %res = extractelement <1 x i22> %x, i32 0
  ret i22 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v2i22:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK-NEXT:  mov $m1, $m3
; CHECK:       br $m10
define i22 @extract_0_from_v2i22(i32 %ignore, <2 x i22> %x) {
  %res = extractelement <2 x i22> %x, i32 0
  ret i22 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v2i22:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i22 @extract_1_from_v2i22(i32 %ignore, <2 x i22> %x) {
  %res = extractelement <2 x i22> %x, i32 1
  ret i22 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v3i22:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i22 @extract_0_from_v3i22(i32 %ignore, <3 x i22> %x) {
  %res = extractelement <3 x i22> %x, i32 0
  ret i22 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v3i22:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i22 @extract_1_from_v3i22(i32 %ignore, <3 x i22> %x) {
  %res = extractelement <3 x i22> %x, i32 1
  ret i22 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v3i22:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i22 @extract_2_from_v3i22(i32 %ignore, <3 x i22> %x) {
  %res = extractelement <3 x i22> %x, i32 2
  ret i22 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v4i22:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i22 @extract_0_from_v4i22(i32 %ignore, <4 x i22> %x) {
  %res = extractelement <4 x i22> %x, i32 0
  ret i22 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v4i22:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i22 @extract_1_from_v4i22(i32 %ignore, <4 x i22> %x) {
  %res = extractelement <4 x i22> %x, i32 1
  ret i22 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v4i22:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i22 @extract_2_from_v4i22(i32 %ignore, <4 x i22> %x) {
  %res = extractelement <4 x i22> %x, i32 2
  ret i22 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v4i22:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i22 @extract_3_from_v4i22(i32 %ignore, <4 x i22> %x) {
  %res = extractelement <4 x i22> %x, i32 3
  ret i22 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v5i22:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i22 @extract_0_from_v5i22(i32 %ignore, <5 x i22> %x) {
  %res = extractelement <5 x i22> %x, i32 0
  ret i22 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v5i22:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i22 @extract_1_from_v5i22(i32 %ignore, <5 x i22> %x) {
  %res = extractelement <5 x i22> %x, i32 1
  ret i22 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v5i22:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i22 @extract_2_from_v5i22(i32 %ignore, <5 x i22> %x) {
  %res = extractelement <5 x i22> %x, i32 2
  ret i22 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v5i22:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i22 @extract_3_from_v5i22(i32 %ignore, <5 x i22> %x) {
  %res = extractelement <5 x i22> %x, i32 3
  ret i22 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v5i22:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i22 @extract_4_from_v5i22(i32 %ignore, <5 x i22> %x) {
  %res = extractelement <5 x i22> %x, i32 4
  ret i22 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v6i22:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i22 @extract_0_from_v6i22(i32 %ignore, <6 x i22> %x) {
  %res = extractelement <6 x i22> %x, i32 0
  ret i22 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v6i22:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i22 @extract_1_from_v6i22(i32 %ignore, <6 x i22> %x) {
  %res = extractelement <6 x i22> %x, i32 1
  ret i22 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v6i22:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i22 @extract_2_from_v6i22(i32 %ignore, <6 x i22> %x) {
  %res = extractelement <6 x i22> %x, i32 2
  ret i22 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v6i22:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i22 @extract_3_from_v6i22(i32 %ignore, <6 x i22> %x) {
  %res = extractelement <6 x i22> %x, i32 3
  ret i22 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v6i22:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i22 @extract_4_from_v6i22(i32 %ignore, <6 x i22> %x) {
  %res = extractelement <6 x i22> %x, i32 4
  ret i22 %res
}
; CC: scalarise
; CHECK-LABEL: extract_5_from_v6i22:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 2
; CHECK:       br $m10
define i22 @extract_5_from_v6i22(i32 %ignore, <6 x i22> %x) {
  %res = extractelement <6 x i22> %x, i32 5
  ret i22 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v7i22:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i22 @extract_0_from_v7i22(i32 %ignore, <7 x i22> %x) {
  %res = extractelement <7 x i22> %x, i32 0
  ret i22 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v7i22:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i22 @extract_1_from_v7i22(i32 %ignore, <7 x i22> %x) {
  %res = extractelement <7 x i22> %x, i32 1
  ret i22 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v7i22:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i22 @extract_2_from_v7i22(i32 %ignore, <7 x i22> %x) {
  %res = extractelement <7 x i22> %x, i32 2
  ret i22 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v7i22:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i22 @extract_3_from_v7i22(i32 %ignore, <7 x i22> %x) {
  %res = extractelement <7 x i22> %x, i32 3
  ret i22 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v7i22:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i22 @extract_4_from_v7i22(i32 %ignore, <7 x i22> %x) {
  %res = extractelement <7 x i22> %x, i32 4
  ret i22 %res
}
; CC: scalarise
; CHECK-LABEL: extract_5_from_v7i22:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 2
; CHECK:       br $m10
define i22 @extract_5_from_v7i22(i32 %ignore, <7 x i22> %x) {
  %res = extractelement <7 x i22> %x, i32 5
  ret i22 %res
}
; CC: scalarise
; CHECK-LABEL: extract_6_from_v7i22:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 3
; CHECK:       br $m10
define i22 @extract_6_from_v7i22(i32 %ignore, <7 x i22> %x) {
  %res = extractelement <7 x i22> %x, i32 6
  ret i22 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v8i22:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i22 @extract_0_from_v8i22(i32 %ignore, <8 x i22> %x) {
  %res = extractelement <8 x i22> %x, i32 0
  ret i22 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v8i22:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i22 @extract_1_from_v8i22(i32 %ignore, <8 x i22> %x) {
  %res = extractelement <8 x i22> %x, i32 1
  ret i22 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v8i22:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i22 @extract_2_from_v8i22(i32 %ignore, <8 x i22> %x) {
  %res = extractelement <8 x i22> %x, i32 2
  ret i22 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v8i22:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i22 @extract_3_from_v8i22(i32 %ignore, <8 x i22> %x) {
  %res = extractelement <8 x i22> %x, i32 3
  ret i22 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v8i22:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i22 @extract_4_from_v8i22(i32 %ignore, <8 x i22> %x) {
  %res = extractelement <8 x i22> %x, i32 4
  ret i22 %res
}
; CC: scalarise
; CHECK-LABEL: extract_5_from_v8i22:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 2
; CHECK:       br $m10
define i22 @extract_5_from_v8i22(i32 %ignore, <8 x i22> %x) {
  %res = extractelement <8 x i22> %x, i32 5
  ret i22 %res
}
; CC: scalarise
; CHECK-LABEL: extract_6_from_v8i22:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 3
; CHECK:       br $m10
define i22 @extract_6_from_v8i22(i32 %ignore, <8 x i22> %x) {
  %res = extractelement <8 x i22> %x, i32 6
  ret i22 %res
}
; CC: scalarise
; CHECK-LABEL: extract_7_from_v8i22:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 4
; CHECK:       br $m10
define i22 @extract_7_from_v8i22(i32 %ignore, <8 x i22> %x) {
  %res = extractelement <8 x i22> %x, i32 7
  ret i22 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v1i23:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i23 @extract_0_from_v1i23(i32 %ignore, <1 x i23> %x) {
  %res = extractelement <1 x i23> %x, i32 0
  ret i23 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v2i23:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK-NEXT:  mov $m1, $m3
; CHECK:       br $m10
define i23 @extract_0_from_v2i23(i32 %ignore, <2 x i23> %x) {
  %res = extractelement <2 x i23> %x, i32 0
  ret i23 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v2i23:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i23 @extract_1_from_v2i23(i32 %ignore, <2 x i23> %x) {
  %res = extractelement <2 x i23> %x, i32 1
  ret i23 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v3i23:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i23 @extract_0_from_v3i23(i32 %ignore, <3 x i23> %x) {
  %res = extractelement <3 x i23> %x, i32 0
  ret i23 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v3i23:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i23 @extract_1_from_v3i23(i32 %ignore, <3 x i23> %x) {
  %res = extractelement <3 x i23> %x, i32 1
  ret i23 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v3i23:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i23 @extract_2_from_v3i23(i32 %ignore, <3 x i23> %x) {
  %res = extractelement <3 x i23> %x, i32 2
  ret i23 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v4i23:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i23 @extract_0_from_v4i23(i32 %ignore, <4 x i23> %x) {
  %res = extractelement <4 x i23> %x, i32 0
  ret i23 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v4i23:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i23 @extract_1_from_v4i23(i32 %ignore, <4 x i23> %x) {
  %res = extractelement <4 x i23> %x, i32 1
  ret i23 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v4i23:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i23 @extract_2_from_v4i23(i32 %ignore, <4 x i23> %x) {
  %res = extractelement <4 x i23> %x, i32 2
  ret i23 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v4i23:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i23 @extract_3_from_v4i23(i32 %ignore, <4 x i23> %x) {
  %res = extractelement <4 x i23> %x, i32 3
  ret i23 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v5i23:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i23 @extract_0_from_v5i23(i32 %ignore, <5 x i23> %x) {
  %res = extractelement <5 x i23> %x, i32 0
  ret i23 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v5i23:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i23 @extract_1_from_v5i23(i32 %ignore, <5 x i23> %x) {
  %res = extractelement <5 x i23> %x, i32 1
  ret i23 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v5i23:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i23 @extract_2_from_v5i23(i32 %ignore, <5 x i23> %x) {
  %res = extractelement <5 x i23> %x, i32 2
  ret i23 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v5i23:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i23 @extract_3_from_v5i23(i32 %ignore, <5 x i23> %x) {
  %res = extractelement <5 x i23> %x, i32 3
  ret i23 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v5i23:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i23 @extract_4_from_v5i23(i32 %ignore, <5 x i23> %x) {
  %res = extractelement <5 x i23> %x, i32 4
  ret i23 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v6i23:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i23 @extract_0_from_v6i23(i32 %ignore, <6 x i23> %x) {
  %res = extractelement <6 x i23> %x, i32 0
  ret i23 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v6i23:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i23 @extract_1_from_v6i23(i32 %ignore, <6 x i23> %x) {
  %res = extractelement <6 x i23> %x, i32 1
  ret i23 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v6i23:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i23 @extract_2_from_v6i23(i32 %ignore, <6 x i23> %x) {
  %res = extractelement <6 x i23> %x, i32 2
  ret i23 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v6i23:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i23 @extract_3_from_v6i23(i32 %ignore, <6 x i23> %x) {
  %res = extractelement <6 x i23> %x, i32 3
  ret i23 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v6i23:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i23 @extract_4_from_v6i23(i32 %ignore, <6 x i23> %x) {
  %res = extractelement <6 x i23> %x, i32 4
  ret i23 %res
}
; CC: scalarise
; CHECK-LABEL: extract_5_from_v6i23:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 2
; CHECK:       br $m10
define i23 @extract_5_from_v6i23(i32 %ignore, <6 x i23> %x) {
  %res = extractelement <6 x i23> %x, i32 5
  ret i23 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v7i23:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i23 @extract_0_from_v7i23(i32 %ignore, <7 x i23> %x) {
  %res = extractelement <7 x i23> %x, i32 0
  ret i23 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v7i23:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i23 @extract_1_from_v7i23(i32 %ignore, <7 x i23> %x) {
  %res = extractelement <7 x i23> %x, i32 1
  ret i23 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v7i23:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i23 @extract_2_from_v7i23(i32 %ignore, <7 x i23> %x) {
  %res = extractelement <7 x i23> %x, i32 2
  ret i23 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v7i23:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i23 @extract_3_from_v7i23(i32 %ignore, <7 x i23> %x) {
  %res = extractelement <7 x i23> %x, i32 3
  ret i23 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v7i23:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i23 @extract_4_from_v7i23(i32 %ignore, <7 x i23> %x) {
  %res = extractelement <7 x i23> %x, i32 4
  ret i23 %res
}
; CC: scalarise
; CHECK-LABEL: extract_5_from_v7i23:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 2
; CHECK:       br $m10
define i23 @extract_5_from_v7i23(i32 %ignore, <7 x i23> %x) {
  %res = extractelement <7 x i23> %x, i32 5
  ret i23 %res
}
; CC: scalarise
; CHECK-LABEL: extract_6_from_v7i23:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 3
; CHECK:       br $m10
define i23 @extract_6_from_v7i23(i32 %ignore, <7 x i23> %x) {
  %res = extractelement <7 x i23> %x, i32 6
  ret i23 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v8i23:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i23 @extract_0_from_v8i23(i32 %ignore, <8 x i23> %x) {
  %res = extractelement <8 x i23> %x, i32 0
  ret i23 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v8i23:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i23 @extract_1_from_v8i23(i32 %ignore, <8 x i23> %x) {
  %res = extractelement <8 x i23> %x, i32 1
  ret i23 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v8i23:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i23 @extract_2_from_v8i23(i32 %ignore, <8 x i23> %x) {
  %res = extractelement <8 x i23> %x, i32 2
  ret i23 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v8i23:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i23 @extract_3_from_v8i23(i32 %ignore, <8 x i23> %x) {
  %res = extractelement <8 x i23> %x, i32 3
  ret i23 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v8i23:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i23 @extract_4_from_v8i23(i32 %ignore, <8 x i23> %x) {
  %res = extractelement <8 x i23> %x, i32 4
  ret i23 %res
}
; CC: scalarise
; CHECK-LABEL: extract_5_from_v8i23:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 2
; CHECK:       br $m10
define i23 @extract_5_from_v8i23(i32 %ignore, <8 x i23> %x) {
  %res = extractelement <8 x i23> %x, i32 5
  ret i23 %res
}
; CC: scalarise
; CHECK-LABEL: extract_6_from_v8i23:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 3
; CHECK:       br $m10
define i23 @extract_6_from_v8i23(i32 %ignore, <8 x i23> %x) {
  %res = extractelement <8 x i23> %x, i32 6
  ret i23 %res
}
; CC: scalarise
; CHECK-LABEL: extract_7_from_v8i23:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 4
; CHECK:       br $m10
define i23 @extract_7_from_v8i23(i32 %ignore, <8 x i23> %x) {
  %res = extractelement <8 x i23> %x, i32 7
  ret i23 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v1i24:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i24 @extract_0_from_v1i24(i32 %ignore, <1 x i24> %x) {
  %res = extractelement <1 x i24> %x, i32 0
  ret i24 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v2i24:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK-NEXT:  mov $m1, $m3
; CHECK:       br $m10
define i24 @extract_0_from_v2i24(i32 %ignore, <2 x i24> %x) {
  %res = extractelement <2 x i24> %x, i32 0
  ret i24 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v2i24:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i24 @extract_1_from_v2i24(i32 %ignore, <2 x i24> %x) {
  %res = extractelement <2 x i24> %x, i32 1
  ret i24 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v3i24:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i24 @extract_0_from_v3i24(i32 %ignore, <3 x i24> %x) {
  %res = extractelement <3 x i24> %x, i32 0
  ret i24 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v3i24:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i24 @extract_1_from_v3i24(i32 %ignore, <3 x i24> %x) {
  %res = extractelement <3 x i24> %x, i32 1
  ret i24 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v3i24:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i24 @extract_2_from_v3i24(i32 %ignore, <3 x i24> %x) {
  %res = extractelement <3 x i24> %x, i32 2
  ret i24 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v4i24:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i24 @extract_0_from_v4i24(i32 %ignore, <4 x i24> %x) {
  %res = extractelement <4 x i24> %x, i32 0
  ret i24 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v4i24:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i24 @extract_1_from_v4i24(i32 %ignore, <4 x i24> %x) {
  %res = extractelement <4 x i24> %x, i32 1
  ret i24 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v4i24:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i24 @extract_2_from_v4i24(i32 %ignore, <4 x i24> %x) {
  %res = extractelement <4 x i24> %x, i32 2
  ret i24 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v4i24:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i24 @extract_3_from_v4i24(i32 %ignore, <4 x i24> %x) {
  %res = extractelement <4 x i24> %x, i32 3
  ret i24 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v5i24:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i24 @extract_0_from_v5i24(i32 %ignore, <5 x i24> %x) {
  %res = extractelement <5 x i24> %x, i32 0
  ret i24 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v5i24:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i24 @extract_1_from_v5i24(i32 %ignore, <5 x i24> %x) {
  %res = extractelement <5 x i24> %x, i32 1
  ret i24 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v5i24:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i24 @extract_2_from_v5i24(i32 %ignore, <5 x i24> %x) {
  %res = extractelement <5 x i24> %x, i32 2
  ret i24 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v5i24:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i24 @extract_3_from_v5i24(i32 %ignore, <5 x i24> %x) {
  %res = extractelement <5 x i24> %x, i32 3
  ret i24 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v5i24:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i24 @extract_4_from_v5i24(i32 %ignore, <5 x i24> %x) {
  %res = extractelement <5 x i24> %x, i32 4
  ret i24 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v6i24:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i24 @extract_0_from_v6i24(i32 %ignore, <6 x i24> %x) {
  %res = extractelement <6 x i24> %x, i32 0
  ret i24 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v6i24:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i24 @extract_1_from_v6i24(i32 %ignore, <6 x i24> %x) {
  %res = extractelement <6 x i24> %x, i32 1
  ret i24 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v6i24:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i24 @extract_2_from_v6i24(i32 %ignore, <6 x i24> %x) {
  %res = extractelement <6 x i24> %x, i32 2
  ret i24 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v6i24:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i24 @extract_3_from_v6i24(i32 %ignore, <6 x i24> %x) {
  %res = extractelement <6 x i24> %x, i32 3
  ret i24 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v6i24:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i24 @extract_4_from_v6i24(i32 %ignore, <6 x i24> %x) {
  %res = extractelement <6 x i24> %x, i32 4
  ret i24 %res
}
; CC: scalarise
; CHECK-LABEL: extract_5_from_v6i24:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 2
; CHECK:       br $m10
define i24 @extract_5_from_v6i24(i32 %ignore, <6 x i24> %x) {
  %res = extractelement <6 x i24> %x, i32 5
  ret i24 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v7i24:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i24 @extract_0_from_v7i24(i32 %ignore, <7 x i24> %x) {
  %res = extractelement <7 x i24> %x, i32 0
  ret i24 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v7i24:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i24 @extract_1_from_v7i24(i32 %ignore, <7 x i24> %x) {
  %res = extractelement <7 x i24> %x, i32 1
  ret i24 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v7i24:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i24 @extract_2_from_v7i24(i32 %ignore, <7 x i24> %x) {
  %res = extractelement <7 x i24> %x, i32 2
  ret i24 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v7i24:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i24 @extract_3_from_v7i24(i32 %ignore, <7 x i24> %x) {
  %res = extractelement <7 x i24> %x, i32 3
  ret i24 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v7i24:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i24 @extract_4_from_v7i24(i32 %ignore, <7 x i24> %x) {
  %res = extractelement <7 x i24> %x, i32 4
  ret i24 %res
}
; CC: scalarise
; CHECK-LABEL: extract_5_from_v7i24:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 2
; CHECK:       br $m10
define i24 @extract_5_from_v7i24(i32 %ignore, <7 x i24> %x) {
  %res = extractelement <7 x i24> %x, i32 5
  ret i24 %res
}
; CC: scalarise
; CHECK-LABEL: extract_6_from_v7i24:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 3
; CHECK:       br $m10
define i24 @extract_6_from_v7i24(i32 %ignore, <7 x i24> %x) {
  %res = extractelement <7 x i24> %x, i32 6
  ret i24 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v8i24:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i24 @extract_0_from_v8i24(i32 %ignore, <8 x i24> %x) {
  %res = extractelement <8 x i24> %x, i32 0
  ret i24 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v8i24:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i24 @extract_1_from_v8i24(i32 %ignore, <8 x i24> %x) {
  %res = extractelement <8 x i24> %x, i32 1
  ret i24 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v8i24:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i24 @extract_2_from_v8i24(i32 %ignore, <8 x i24> %x) {
  %res = extractelement <8 x i24> %x, i32 2
  ret i24 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v8i24:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i24 @extract_3_from_v8i24(i32 %ignore, <8 x i24> %x) {
  %res = extractelement <8 x i24> %x, i32 3
  ret i24 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v8i24:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i24 @extract_4_from_v8i24(i32 %ignore, <8 x i24> %x) {
  %res = extractelement <8 x i24> %x, i32 4
  ret i24 %res
}
; CC: scalarise
; CHECK-LABEL: extract_5_from_v8i24:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 2
; CHECK:       br $m10
define i24 @extract_5_from_v8i24(i32 %ignore, <8 x i24> %x) {
  %res = extractelement <8 x i24> %x, i32 5
  ret i24 %res
}
; CC: scalarise
; CHECK-LABEL: extract_6_from_v8i24:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 3
; CHECK:       br $m10
define i24 @extract_6_from_v8i24(i32 %ignore, <8 x i24> %x) {
  %res = extractelement <8 x i24> %x, i32 6
  ret i24 %res
}
; CC: scalarise
; CHECK-LABEL: extract_7_from_v8i24:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 4
; CHECK:       br $m10
define i24 @extract_7_from_v8i24(i32 %ignore, <8 x i24> %x) {
  %res = extractelement <8 x i24> %x, i32 7
  ret i24 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v1i25:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i25 @extract_0_from_v1i25(i32 %ignore, <1 x i25> %x) {
  %res = extractelement <1 x i25> %x, i32 0
  ret i25 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v2i25:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK-NEXT:  mov $m1, $m3
; CHECK:       br $m10
define i25 @extract_0_from_v2i25(i32 %ignore, <2 x i25> %x) {
  %res = extractelement <2 x i25> %x, i32 0
  ret i25 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v2i25:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i25 @extract_1_from_v2i25(i32 %ignore, <2 x i25> %x) {
  %res = extractelement <2 x i25> %x, i32 1
  ret i25 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v3i25:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i25 @extract_0_from_v3i25(i32 %ignore, <3 x i25> %x) {
  %res = extractelement <3 x i25> %x, i32 0
  ret i25 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v3i25:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i25 @extract_1_from_v3i25(i32 %ignore, <3 x i25> %x) {
  %res = extractelement <3 x i25> %x, i32 1
  ret i25 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v3i25:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i25 @extract_2_from_v3i25(i32 %ignore, <3 x i25> %x) {
  %res = extractelement <3 x i25> %x, i32 2
  ret i25 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v4i25:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i25 @extract_0_from_v4i25(i32 %ignore, <4 x i25> %x) {
  %res = extractelement <4 x i25> %x, i32 0
  ret i25 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v4i25:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i25 @extract_1_from_v4i25(i32 %ignore, <4 x i25> %x) {
  %res = extractelement <4 x i25> %x, i32 1
  ret i25 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v4i25:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i25 @extract_2_from_v4i25(i32 %ignore, <4 x i25> %x) {
  %res = extractelement <4 x i25> %x, i32 2
  ret i25 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v4i25:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i25 @extract_3_from_v4i25(i32 %ignore, <4 x i25> %x) {
  %res = extractelement <4 x i25> %x, i32 3
  ret i25 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v5i25:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i25 @extract_0_from_v5i25(i32 %ignore, <5 x i25> %x) {
  %res = extractelement <5 x i25> %x, i32 0
  ret i25 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v5i25:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i25 @extract_1_from_v5i25(i32 %ignore, <5 x i25> %x) {
  %res = extractelement <5 x i25> %x, i32 1
  ret i25 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v5i25:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i25 @extract_2_from_v5i25(i32 %ignore, <5 x i25> %x) {
  %res = extractelement <5 x i25> %x, i32 2
  ret i25 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v5i25:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i25 @extract_3_from_v5i25(i32 %ignore, <5 x i25> %x) {
  %res = extractelement <5 x i25> %x, i32 3
  ret i25 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v5i25:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i25 @extract_4_from_v5i25(i32 %ignore, <5 x i25> %x) {
  %res = extractelement <5 x i25> %x, i32 4
  ret i25 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v6i25:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i25 @extract_0_from_v6i25(i32 %ignore, <6 x i25> %x) {
  %res = extractelement <6 x i25> %x, i32 0
  ret i25 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v6i25:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i25 @extract_1_from_v6i25(i32 %ignore, <6 x i25> %x) {
  %res = extractelement <6 x i25> %x, i32 1
  ret i25 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v6i25:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i25 @extract_2_from_v6i25(i32 %ignore, <6 x i25> %x) {
  %res = extractelement <6 x i25> %x, i32 2
  ret i25 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v6i25:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i25 @extract_3_from_v6i25(i32 %ignore, <6 x i25> %x) {
  %res = extractelement <6 x i25> %x, i32 3
  ret i25 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v6i25:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i25 @extract_4_from_v6i25(i32 %ignore, <6 x i25> %x) {
  %res = extractelement <6 x i25> %x, i32 4
  ret i25 %res
}
; CC: scalarise
; CHECK-LABEL: extract_5_from_v6i25:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 2
; CHECK:       br $m10
define i25 @extract_5_from_v6i25(i32 %ignore, <6 x i25> %x) {
  %res = extractelement <6 x i25> %x, i32 5
  ret i25 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v7i25:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i25 @extract_0_from_v7i25(i32 %ignore, <7 x i25> %x) {
  %res = extractelement <7 x i25> %x, i32 0
  ret i25 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v7i25:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i25 @extract_1_from_v7i25(i32 %ignore, <7 x i25> %x) {
  %res = extractelement <7 x i25> %x, i32 1
  ret i25 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v7i25:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i25 @extract_2_from_v7i25(i32 %ignore, <7 x i25> %x) {
  %res = extractelement <7 x i25> %x, i32 2
  ret i25 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v7i25:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i25 @extract_3_from_v7i25(i32 %ignore, <7 x i25> %x) {
  %res = extractelement <7 x i25> %x, i32 3
  ret i25 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v7i25:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i25 @extract_4_from_v7i25(i32 %ignore, <7 x i25> %x) {
  %res = extractelement <7 x i25> %x, i32 4
  ret i25 %res
}
; CC: scalarise
; CHECK-LABEL: extract_5_from_v7i25:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 2
; CHECK:       br $m10
define i25 @extract_5_from_v7i25(i32 %ignore, <7 x i25> %x) {
  %res = extractelement <7 x i25> %x, i32 5
  ret i25 %res
}
; CC: scalarise
; CHECK-LABEL: extract_6_from_v7i25:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 3
; CHECK:       br $m10
define i25 @extract_6_from_v7i25(i32 %ignore, <7 x i25> %x) {
  %res = extractelement <7 x i25> %x, i32 6
  ret i25 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v8i25:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i25 @extract_0_from_v8i25(i32 %ignore, <8 x i25> %x) {
  %res = extractelement <8 x i25> %x, i32 0
  ret i25 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v8i25:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i25 @extract_1_from_v8i25(i32 %ignore, <8 x i25> %x) {
  %res = extractelement <8 x i25> %x, i32 1
  ret i25 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v8i25:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i25 @extract_2_from_v8i25(i32 %ignore, <8 x i25> %x) {
  %res = extractelement <8 x i25> %x, i32 2
  ret i25 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v8i25:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i25 @extract_3_from_v8i25(i32 %ignore, <8 x i25> %x) {
  %res = extractelement <8 x i25> %x, i32 3
  ret i25 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v8i25:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i25 @extract_4_from_v8i25(i32 %ignore, <8 x i25> %x) {
  %res = extractelement <8 x i25> %x, i32 4
  ret i25 %res
}
; CC: scalarise
; CHECK-LABEL: extract_5_from_v8i25:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 2
; CHECK:       br $m10
define i25 @extract_5_from_v8i25(i32 %ignore, <8 x i25> %x) {
  %res = extractelement <8 x i25> %x, i32 5
  ret i25 %res
}
; CC: scalarise
; CHECK-LABEL: extract_6_from_v8i25:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 3
; CHECK:       br $m10
define i25 @extract_6_from_v8i25(i32 %ignore, <8 x i25> %x) {
  %res = extractelement <8 x i25> %x, i32 6
  ret i25 %res
}
; CC: scalarise
; CHECK-LABEL: extract_7_from_v8i25:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 4
; CHECK:       br $m10
define i25 @extract_7_from_v8i25(i32 %ignore, <8 x i25> %x) {
  %res = extractelement <8 x i25> %x, i32 7
  ret i25 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v1i26:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i26 @extract_0_from_v1i26(i32 %ignore, <1 x i26> %x) {
  %res = extractelement <1 x i26> %x, i32 0
  ret i26 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v2i26:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK-NEXT:  mov $m1, $m3
; CHECK:       br $m10
define i26 @extract_0_from_v2i26(i32 %ignore, <2 x i26> %x) {
  %res = extractelement <2 x i26> %x, i32 0
  ret i26 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v2i26:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i26 @extract_1_from_v2i26(i32 %ignore, <2 x i26> %x) {
  %res = extractelement <2 x i26> %x, i32 1
  ret i26 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v3i26:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i26 @extract_0_from_v3i26(i32 %ignore, <3 x i26> %x) {
  %res = extractelement <3 x i26> %x, i32 0
  ret i26 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v3i26:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i26 @extract_1_from_v3i26(i32 %ignore, <3 x i26> %x) {
  %res = extractelement <3 x i26> %x, i32 1
  ret i26 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v3i26:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i26 @extract_2_from_v3i26(i32 %ignore, <3 x i26> %x) {
  %res = extractelement <3 x i26> %x, i32 2
  ret i26 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v4i26:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i26 @extract_0_from_v4i26(i32 %ignore, <4 x i26> %x) {
  %res = extractelement <4 x i26> %x, i32 0
  ret i26 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v4i26:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i26 @extract_1_from_v4i26(i32 %ignore, <4 x i26> %x) {
  %res = extractelement <4 x i26> %x, i32 1
  ret i26 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v4i26:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i26 @extract_2_from_v4i26(i32 %ignore, <4 x i26> %x) {
  %res = extractelement <4 x i26> %x, i32 2
  ret i26 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v4i26:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i26 @extract_3_from_v4i26(i32 %ignore, <4 x i26> %x) {
  %res = extractelement <4 x i26> %x, i32 3
  ret i26 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v5i26:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i26 @extract_0_from_v5i26(i32 %ignore, <5 x i26> %x) {
  %res = extractelement <5 x i26> %x, i32 0
  ret i26 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v5i26:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i26 @extract_1_from_v5i26(i32 %ignore, <5 x i26> %x) {
  %res = extractelement <5 x i26> %x, i32 1
  ret i26 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v5i26:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i26 @extract_2_from_v5i26(i32 %ignore, <5 x i26> %x) {
  %res = extractelement <5 x i26> %x, i32 2
  ret i26 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v5i26:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i26 @extract_3_from_v5i26(i32 %ignore, <5 x i26> %x) {
  %res = extractelement <5 x i26> %x, i32 3
  ret i26 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v5i26:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i26 @extract_4_from_v5i26(i32 %ignore, <5 x i26> %x) {
  %res = extractelement <5 x i26> %x, i32 4
  ret i26 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v6i26:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i26 @extract_0_from_v6i26(i32 %ignore, <6 x i26> %x) {
  %res = extractelement <6 x i26> %x, i32 0
  ret i26 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v6i26:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i26 @extract_1_from_v6i26(i32 %ignore, <6 x i26> %x) {
  %res = extractelement <6 x i26> %x, i32 1
  ret i26 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v6i26:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i26 @extract_2_from_v6i26(i32 %ignore, <6 x i26> %x) {
  %res = extractelement <6 x i26> %x, i32 2
  ret i26 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v6i26:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i26 @extract_3_from_v6i26(i32 %ignore, <6 x i26> %x) {
  %res = extractelement <6 x i26> %x, i32 3
  ret i26 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v6i26:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i26 @extract_4_from_v6i26(i32 %ignore, <6 x i26> %x) {
  %res = extractelement <6 x i26> %x, i32 4
  ret i26 %res
}
; CC: scalarise
; CHECK-LABEL: extract_5_from_v6i26:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 2
; CHECK:       br $m10
define i26 @extract_5_from_v6i26(i32 %ignore, <6 x i26> %x) {
  %res = extractelement <6 x i26> %x, i32 5
  ret i26 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v7i26:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i26 @extract_0_from_v7i26(i32 %ignore, <7 x i26> %x) {
  %res = extractelement <7 x i26> %x, i32 0
  ret i26 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v7i26:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i26 @extract_1_from_v7i26(i32 %ignore, <7 x i26> %x) {
  %res = extractelement <7 x i26> %x, i32 1
  ret i26 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v7i26:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i26 @extract_2_from_v7i26(i32 %ignore, <7 x i26> %x) {
  %res = extractelement <7 x i26> %x, i32 2
  ret i26 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v7i26:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i26 @extract_3_from_v7i26(i32 %ignore, <7 x i26> %x) {
  %res = extractelement <7 x i26> %x, i32 3
  ret i26 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v7i26:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i26 @extract_4_from_v7i26(i32 %ignore, <7 x i26> %x) {
  %res = extractelement <7 x i26> %x, i32 4
  ret i26 %res
}
; CC: scalarise
; CHECK-LABEL: extract_5_from_v7i26:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 2
; CHECK:       br $m10
define i26 @extract_5_from_v7i26(i32 %ignore, <7 x i26> %x) {
  %res = extractelement <7 x i26> %x, i32 5
  ret i26 %res
}
; CC: scalarise
; CHECK-LABEL: extract_6_from_v7i26:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 3
; CHECK:       br $m10
define i26 @extract_6_from_v7i26(i32 %ignore, <7 x i26> %x) {
  %res = extractelement <7 x i26> %x, i32 6
  ret i26 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v8i26:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i26 @extract_0_from_v8i26(i32 %ignore, <8 x i26> %x) {
  %res = extractelement <8 x i26> %x, i32 0
  ret i26 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v8i26:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i26 @extract_1_from_v8i26(i32 %ignore, <8 x i26> %x) {
  %res = extractelement <8 x i26> %x, i32 1
  ret i26 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v8i26:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i26 @extract_2_from_v8i26(i32 %ignore, <8 x i26> %x) {
  %res = extractelement <8 x i26> %x, i32 2
  ret i26 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v8i26:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i26 @extract_3_from_v8i26(i32 %ignore, <8 x i26> %x) {
  %res = extractelement <8 x i26> %x, i32 3
  ret i26 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v8i26:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i26 @extract_4_from_v8i26(i32 %ignore, <8 x i26> %x) {
  %res = extractelement <8 x i26> %x, i32 4
  ret i26 %res
}
; CC: scalarise
; CHECK-LABEL: extract_5_from_v8i26:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 2
; CHECK:       br $m10
define i26 @extract_5_from_v8i26(i32 %ignore, <8 x i26> %x) {
  %res = extractelement <8 x i26> %x, i32 5
  ret i26 %res
}
; CC: scalarise
; CHECK-LABEL: extract_6_from_v8i26:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 3
; CHECK:       br $m10
define i26 @extract_6_from_v8i26(i32 %ignore, <8 x i26> %x) {
  %res = extractelement <8 x i26> %x, i32 6
  ret i26 %res
}
; CC: scalarise
; CHECK-LABEL: extract_7_from_v8i26:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 4
; CHECK:       br $m10
define i26 @extract_7_from_v8i26(i32 %ignore, <8 x i26> %x) {
  %res = extractelement <8 x i26> %x, i32 7
  ret i26 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v1i27:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i27 @extract_0_from_v1i27(i32 %ignore, <1 x i27> %x) {
  %res = extractelement <1 x i27> %x, i32 0
  ret i27 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v2i27:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK-NEXT:  mov $m1, $m3
; CHECK:       br $m10
define i27 @extract_0_from_v2i27(i32 %ignore, <2 x i27> %x) {
  %res = extractelement <2 x i27> %x, i32 0
  ret i27 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v2i27:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i27 @extract_1_from_v2i27(i32 %ignore, <2 x i27> %x) {
  %res = extractelement <2 x i27> %x, i32 1
  ret i27 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v3i27:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i27 @extract_0_from_v3i27(i32 %ignore, <3 x i27> %x) {
  %res = extractelement <3 x i27> %x, i32 0
  ret i27 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v3i27:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i27 @extract_1_from_v3i27(i32 %ignore, <3 x i27> %x) {
  %res = extractelement <3 x i27> %x, i32 1
  ret i27 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v3i27:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i27 @extract_2_from_v3i27(i32 %ignore, <3 x i27> %x) {
  %res = extractelement <3 x i27> %x, i32 2
  ret i27 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v4i27:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i27 @extract_0_from_v4i27(i32 %ignore, <4 x i27> %x) {
  %res = extractelement <4 x i27> %x, i32 0
  ret i27 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v4i27:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i27 @extract_1_from_v4i27(i32 %ignore, <4 x i27> %x) {
  %res = extractelement <4 x i27> %x, i32 1
  ret i27 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v4i27:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i27 @extract_2_from_v4i27(i32 %ignore, <4 x i27> %x) {
  %res = extractelement <4 x i27> %x, i32 2
  ret i27 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v4i27:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i27 @extract_3_from_v4i27(i32 %ignore, <4 x i27> %x) {
  %res = extractelement <4 x i27> %x, i32 3
  ret i27 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v5i27:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i27 @extract_0_from_v5i27(i32 %ignore, <5 x i27> %x) {
  %res = extractelement <5 x i27> %x, i32 0
  ret i27 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v5i27:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i27 @extract_1_from_v5i27(i32 %ignore, <5 x i27> %x) {
  %res = extractelement <5 x i27> %x, i32 1
  ret i27 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v5i27:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i27 @extract_2_from_v5i27(i32 %ignore, <5 x i27> %x) {
  %res = extractelement <5 x i27> %x, i32 2
  ret i27 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v5i27:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i27 @extract_3_from_v5i27(i32 %ignore, <5 x i27> %x) {
  %res = extractelement <5 x i27> %x, i32 3
  ret i27 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v5i27:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i27 @extract_4_from_v5i27(i32 %ignore, <5 x i27> %x) {
  %res = extractelement <5 x i27> %x, i32 4
  ret i27 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v6i27:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i27 @extract_0_from_v6i27(i32 %ignore, <6 x i27> %x) {
  %res = extractelement <6 x i27> %x, i32 0
  ret i27 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v6i27:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i27 @extract_1_from_v6i27(i32 %ignore, <6 x i27> %x) {
  %res = extractelement <6 x i27> %x, i32 1
  ret i27 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v6i27:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i27 @extract_2_from_v6i27(i32 %ignore, <6 x i27> %x) {
  %res = extractelement <6 x i27> %x, i32 2
  ret i27 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v6i27:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i27 @extract_3_from_v6i27(i32 %ignore, <6 x i27> %x) {
  %res = extractelement <6 x i27> %x, i32 3
  ret i27 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v6i27:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i27 @extract_4_from_v6i27(i32 %ignore, <6 x i27> %x) {
  %res = extractelement <6 x i27> %x, i32 4
  ret i27 %res
}
; CC: scalarise
; CHECK-LABEL: extract_5_from_v6i27:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 2
; CHECK:       br $m10
define i27 @extract_5_from_v6i27(i32 %ignore, <6 x i27> %x) {
  %res = extractelement <6 x i27> %x, i32 5
  ret i27 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v7i27:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i27 @extract_0_from_v7i27(i32 %ignore, <7 x i27> %x) {
  %res = extractelement <7 x i27> %x, i32 0
  ret i27 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v7i27:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i27 @extract_1_from_v7i27(i32 %ignore, <7 x i27> %x) {
  %res = extractelement <7 x i27> %x, i32 1
  ret i27 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v7i27:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i27 @extract_2_from_v7i27(i32 %ignore, <7 x i27> %x) {
  %res = extractelement <7 x i27> %x, i32 2
  ret i27 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v7i27:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i27 @extract_3_from_v7i27(i32 %ignore, <7 x i27> %x) {
  %res = extractelement <7 x i27> %x, i32 3
  ret i27 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v7i27:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i27 @extract_4_from_v7i27(i32 %ignore, <7 x i27> %x) {
  %res = extractelement <7 x i27> %x, i32 4
  ret i27 %res
}
; CC: scalarise
; CHECK-LABEL: extract_5_from_v7i27:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 2
; CHECK:       br $m10
define i27 @extract_5_from_v7i27(i32 %ignore, <7 x i27> %x) {
  %res = extractelement <7 x i27> %x, i32 5
  ret i27 %res
}
; CC: scalarise
; CHECK-LABEL: extract_6_from_v7i27:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 3
; CHECK:       br $m10
define i27 @extract_6_from_v7i27(i32 %ignore, <7 x i27> %x) {
  %res = extractelement <7 x i27> %x, i32 6
  ret i27 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v8i27:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i27 @extract_0_from_v8i27(i32 %ignore, <8 x i27> %x) {
  %res = extractelement <8 x i27> %x, i32 0
  ret i27 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v8i27:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i27 @extract_1_from_v8i27(i32 %ignore, <8 x i27> %x) {
  %res = extractelement <8 x i27> %x, i32 1
  ret i27 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v8i27:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i27 @extract_2_from_v8i27(i32 %ignore, <8 x i27> %x) {
  %res = extractelement <8 x i27> %x, i32 2
  ret i27 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v8i27:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i27 @extract_3_from_v8i27(i32 %ignore, <8 x i27> %x) {
  %res = extractelement <8 x i27> %x, i32 3
  ret i27 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v8i27:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i27 @extract_4_from_v8i27(i32 %ignore, <8 x i27> %x) {
  %res = extractelement <8 x i27> %x, i32 4
  ret i27 %res
}
; CC: scalarise
; CHECK-LABEL: extract_5_from_v8i27:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 2
; CHECK:       br $m10
define i27 @extract_5_from_v8i27(i32 %ignore, <8 x i27> %x) {
  %res = extractelement <8 x i27> %x, i32 5
  ret i27 %res
}
; CC: scalarise
; CHECK-LABEL: extract_6_from_v8i27:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 3
; CHECK:       br $m10
define i27 @extract_6_from_v8i27(i32 %ignore, <8 x i27> %x) {
  %res = extractelement <8 x i27> %x, i32 6
  ret i27 %res
}
; CC: scalarise
; CHECK-LABEL: extract_7_from_v8i27:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 4
; CHECK:       br $m10
define i27 @extract_7_from_v8i27(i32 %ignore, <8 x i27> %x) {
  %res = extractelement <8 x i27> %x, i32 7
  ret i27 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v1i28:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i28 @extract_0_from_v1i28(i32 %ignore, <1 x i28> %x) {
  %res = extractelement <1 x i28> %x, i32 0
  ret i28 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v2i28:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK-NEXT:  mov $m1, $m3
; CHECK:       br $m10
define i28 @extract_0_from_v2i28(i32 %ignore, <2 x i28> %x) {
  %res = extractelement <2 x i28> %x, i32 0
  ret i28 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v2i28:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i28 @extract_1_from_v2i28(i32 %ignore, <2 x i28> %x) {
  %res = extractelement <2 x i28> %x, i32 1
  ret i28 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v3i28:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i28 @extract_0_from_v3i28(i32 %ignore, <3 x i28> %x) {
  %res = extractelement <3 x i28> %x, i32 0
  ret i28 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v3i28:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i28 @extract_1_from_v3i28(i32 %ignore, <3 x i28> %x) {
  %res = extractelement <3 x i28> %x, i32 1
  ret i28 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v3i28:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i28 @extract_2_from_v3i28(i32 %ignore, <3 x i28> %x) {
  %res = extractelement <3 x i28> %x, i32 2
  ret i28 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v4i28:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i28 @extract_0_from_v4i28(i32 %ignore, <4 x i28> %x) {
  %res = extractelement <4 x i28> %x, i32 0
  ret i28 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v4i28:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i28 @extract_1_from_v4i28(i32 %ignore, <4 x i28> %x) {
  %res = extractelement <4 x i28> %x, i32 1
  ret i28 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v4i28:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i28 @extract_2_from_v4i28(i32 %ignore, <4 x i28> %x) {
  %res = extractelement <4 x i28> %x, i32 2
  ret i28 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v4i28:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i28 @extract_3_from_v4i28(i32 %ignore, <4 x i28> %x) {
  %res = extractelement <4 x i28> %x, i32 3
  ret i28 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v5i28:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i28 @extract_0_from_v5i28(i32 %ignore, <5 x i28> %x) {
  %res = extractelement <5 x i28> %x, i32 0
  ret i28 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v5i28:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i28 @extract_1_from_v5i28(i32 %ignore, <5 x i28> %x) {
  %res = extractelement <5 x i28> %x, i32 1
  ret i28 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v5i28:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i28 @extract_2_from_v5i28(i32 %ignore, <5 x i28> %x) {
  %res = extractelement <5 x i28> %x, i32 2
  ret i28 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v5i28:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i28 @extract_3_from_v5i28(i32 %ignore, <5 x i28> %x) {
  %res = extractelement <5 x i28> %x, i32 3
  ret i28 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v5i28:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i28 @extract_4_from_v5i28(i32 %ignore, <5 x i28> %x) {
  %res = extractelement <5 x i28> %x, i32 4
  ret i28 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v6i28:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i28 @extract_0_from_v6i28(i32 %ignore, <6 x i28> %x) {
  %res = extractelement <6 x i28> %x, i32 0
  ret i28 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v6i28:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i28 @extract_1_from_v6i28(i32 %ignore, <6 x i28> %x) {
  %res = extractelement <6 x i28> %x, i32 1
  ret i28 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v6i28:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i28 @extract_2_from_v6i28(i32 %ignore, <6 x i28> %x) {
  %res = extractelement <6 x i28> %x, i32 2
  ret i28 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v6i28:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i28 @extract_3_from_v6i28(i32 %ignore, <6 x i28> %x) {
  %res = extractelement <6 x i28> %x, i32 3
  ret i28 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v6i28:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i28 @extract_4_from_v6i28(i32 %ignore, <6 x i28> %x) {
  %res = extractelement <6 x i28> %x, i32 4
  ret i28 %res
}
; CC: scalarise
; CHECK-LABEL: extract_5_from_v6i28:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 2
; CHECK:       br $m10
define i28 @extract_5_from_v6i28(i32 %ignore, <6 x i28> %x) {
  %res = extractelement <6 x i28> %x, i32 5
  ret i28 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v7i28:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i28 @extract_0_from_v7i28(i32 %ignore, <7 x i28> %x) {
  %res = extractelement <7 x i28> %x, i32 0
  ret i28 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v7i28:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i28 @extract_1_from_v7i28(i32 %ignore, <7 x i28> %x) {
  %res = extractelement <7 x i28> %x, i32 1
  ret i28 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v7i28:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i28 @extract_2_from_v7i28(i32 %ignore, <7 x i28> %x) {
  %res = extractelement <7 x i28> %x, i32 2
  ret i28 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v7i28:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i28 @extract_3_from_v7i28(i32 %ignore, <7 x i28> %x) {
  %res = extractelement <7 x i28> %x, i32 3
  ret i28 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v7i28:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i28 @extract_4_from_v7i28(i32 %ignore, <7 x i28> %x) {
  %res = extractelement <7 x i28> %x, i32 4
  ret i28 %res
}
; CC: scalarise
; CHECK-LABEL: extract_5_from_v7i28:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 2
; CHECK:       br $m10
define i28 @extract_5_from_v7i28(i32 %ignore, <7 x i28> %x) {
  %res = extractelement <7 x i28> %x, i32 5
  ret i28 %res
}
; CC: scalarise
; CHECK-LABEL: extract_6_from_v7i28:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 3
; CHECK:       br $m10
define i28 @extract_6_from_v7i28(i32 %ignore, <7 x i28> %x) {
  %res = extractelement <7 x i28> %x, i32 6
  ret i28 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v8i28:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i28 @extract_0_from_v8i28(i32 %ignore, <8 x i28> %x) {
  %res = extractelement <8 x i28> %x, i32 0
  ret i28 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v8i28:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i28 @extract_1_from_v8i28(i32 %ignore, <8 x i28> %x) {
  %res = extractelement <8 x i28> %x, i32 1
  ret i28 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v8i28:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i28 @extract_2_from_v8i28(i32 %ignore, <8 x i28> %x) {
  %res = extractelement <8 x i28> %x, i32 2
  ret i28 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v8i28:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i28 @extract_3_from_v8i28(i32 %ignore, <8 x i28> %x) {
  %res = extractelement <8 x i28> %x, i32 3
  ret i28 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v8i28:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i28 @extract_4_from_v8i28(i32 %ignore, <8 x i28> %x) {
  %res = extractelement <8 x i28> %x, i32 4
  ret i28 %res
}
; CC: scalarise
; CHECK-LABEL: extract_5_from_v8i28:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 2
; CHECK:       br $m10
define i28 @extract_5_from_v8i28(i32 %ignore, <8 x i28> %x) {
  %res = extractelement <8 x i28> %x, i32 5
  ret i28 %res
}
; CC: scalarise
; CHECK-LABEL: extract_6_from_v8i28:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 3
; CHECK:       br $m10
define i28 @extract_6_from_v8i28(i32 %ignore, <8 x i28> %x) {
  %res = extractelement <8 x i28> %x, i32 6
  ret i28 %res
}
; CC: scalarise
; CHECK-LABEL: extract_7_from_v8i28:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 4
; CHECK:       br $m10
define i28 @extract_7_from_v8i28(i32 %ignore, <8 x i28> %x) {
  %res = extractelement <8 x i28> %x, i32 7
  ret i28 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v1i29:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i29 @extract_0_from_v1i29(i32 %ignore, <1 x i29> %x) {
  %res = extractelement <1 x i29> %x, i32 0
  ret i29 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v2i29:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK-NEXT:  mov $m1, $m3
; CHECK:       br $m10
define i29 @extract_0_from_v2i29(i32 %ignore, <2 x i29> %x) {
  %res = extractelement <2 x i29> %x, i32 0
  ret i29 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v2i29:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i29 @extract_1_from_v2i29(i32 %ignore, <2 x i29> %x) {
  %res = extractelement <2 x i29> %x, i32 1
  ret i29 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v3i29:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i29 @extract_0_from_v3i29(i32 %ignore, <3 x i29> %x) {
  %res = extractelement <3 x i29> %x, i32 0
  ret i29 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v3i29:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i29 @extract_1_from_v3i29(i32 %ignore, <3 x i29> %x) {
  %res = extractelement <3 x i29> %x, i32 1
  ret i29 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v3i29:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i29 @extract_2_from_v3i29(i32 %ignore, <3 x i29> %x) {
  %res = extractelement <3 x i29> %x, i32 2
  ret i29 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v4i29:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i29 @extract_0_from_v4i29(i32 %ignore, <4 x i29> %x) {
  %res = extractelement <4 x i29> %x, i32 0
  ret i29 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v4i29:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i29 @extract_1_from_v4i29(i32 %ignore, <4 x i29> %x) {
  %res = extractelement <4 x i29> %x, i32 1
  ret i29 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v4i29:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i29 @extract_2_from_v4i29(i32 %ignore, <4 x i29> %x) {
  %res = extractelement <4 x i29> %x, i32 2
  ret i29 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v4i29:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i29 @extract_3_from_v4i29(i32 %ignore, <4 x i29> %x) {
  %res = extractelement <4 x i29> %x, i32 3
  ret i29 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v5i29:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i29 @extract_0_from_v5i29(i32 %ignore, <5 x i29> %x) {
  %res = extractelement <5 x i29> %x, i32 0
  ret i29 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v5i29:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i29 @extract_1_from_v5i29(i32 %ignore, <5 x i29> %x) {
  %res = extractelement <5 x i29> %x, i32 1
  ret i29 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v5i29:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i29 @extract_2_from_v5i29(i32 %ignore, <5 x i29> %x) {
  %res = extractelement <5 x i29> %x, i32 2
  ret i29 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v5i29:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i29 @extract_3_from_v5i29(i32 %ignore, <5 x i29> %x) {
  %res = extractelement <5 x i29> %x, i32 3
  ret i29 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v5i29:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i29 @extract_4_from_v5i29(i32 %ignore, <5 x i29> %x) {
  %res = extractelement <5 x i29> %x, i32 4
  ret i29 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v6i29:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i29 @extract_0_from_v6i29(i32 %ignore, <6 x i29> %x) {
  %res = extractelement <6 x i29> %x, i32 0
  ret i29 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v6i29:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i29 @extract_1_from_v6i29(i32 %ignore, <6 x i29> %x) {
  %res = extractelement <6 x i29> %x, i32 1
  ret i29 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v6i29:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i29 @extract_2_from_v6i29(i32 %ignore, <6 x i29> %x) {
  %res = extractelement <6 x i29> %x, i32 2
  ret i29 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v6i29:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i29 @extract_3_from_v6i29(i32 %ignore, <6 x i29> %x) {
  %res = extractelement <6 x i29> %x, i32 3
  ret i29 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v6i29:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i29 @extract_4_from_v6i29(i32 %ignore, <6 x i29> %x) {
  %res = extractelement <6 x i29> %x, i32 4
  ret i29 %res
}
; CC: scalarise
; CHECK-LABEL: extract_5_from_v6i29:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 2
; CHECK:       br $m10
define i29 @extract_5_from_v6i29(i32 %ignore, <6 x i29> %x) {
  %res = extractelement <6 x i29> %x, i32 5
  ret i29 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v7i29:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i29 @extract_0_from_v7i29(i32 %ignore, <7 x i29> %x) {
  %res = extractelement <7 x i29> %x, i32 0
  ret i29 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v7i29:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i29 @extract_1_from_v7i29(i32 %ignore, <7 x i29> %x) {
  %res = extractelement <7 x i29> %x, i32 1
  ret i29 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v7i29:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i29 @extract_2_from_v7i29(i32 %ignore, <7 x i29> %x) {
  %res = extractelement <7 x i29> %x, i32 2
  ret i29 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v7i29:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i29 @extract_3_from_v7i29(i32 %ignore, <7 x i29> %x) {
  %res = extractelement <7 x i29> %x, i32 3
  ret i29 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v7i29:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i29 @extract_4_from_v7i29(i32 %ignore, <7 x i29> %x) {
  %res = extractelement <7 x i29> %x, i32 4
  ret i29 %res
}
; CC: scalarise
; CHECK-LABEL: extract_5_from_v7i29:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 2
; CHECK:       br $m10
define i29 @extract_5_from_v7i29(i32 %ignore, <7 x i29> %x) {
  %res = extractelement <7 x i29> %x, i32 5
  ret i29 %res
}
; CC: scalarise
; CHECK-LABEL: extract_6_from_v7i29:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 3
; CHECK:       br $m10
define i29 @extract_6_from_v7i29(i32 %ignore, <7 x i29> %x) {
  %res = extractelement <7 x i29> %x, i32 6
  ret i29 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v8i29:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i29 @extract_0_from_v8i29(i32 %ignore, <8 x i29> %x) {
  %res = extractelement <8 x i29> %x, i32 0
  ret i29 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v8i29:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i29 @extract_1_from_v8i29(i32 %ignore, <8 x i29> %x) {
  %res = extractelement <8 x i29> %x, i32 1
  ret i29 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v8i29:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i29 @extract_2_from_v8i29(i32 %ignore, <8 x i29> %x) {
  %res = extractelement <8 x i29> %x, i32 2
  ret i29 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v8i29:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i29 @extract_3_from_v8i29(i32 %ignore, <8 x i29> %x) {
  %res = extractelement <8 x i29> %x, i32 3
  ret i29 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v8i29:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i29 @extract_4_from_v8i29(i32 %ignore, <8 x i29> %x) {
  %res = extractelement <8 x i29> %x, i32 4
  ret i29 %res
}
; CC: scalarise
; CHECK-LABEL: extract_5_from_v8i29:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 2
; CHECK:       br $m10
define i29 @extract_5_from_v8i29(i32 %ignore, <8 x i29> %x) {
  %res = extractelement <8 x i29> %x, i32 5
  ret i29 %res
}
; CC: scalarise
; CHECK-LABEL: extract_6_from_v8i29:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 3
; CHECK:       br $m10
define i29 @extract_6_from_v8i29(i32 %ignore, <8 x i29> %x) {
  %res = extractelement <8 x i29> %x, i32 6
  ret i29 %res
}
; CC: scalarise
; CHECK-LABEL: extract_7_from_v8i29:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 4
; CHECK:       br $m10
define i29 @extract_7_from_v8i29(i32 %ignore, <8 x i29> %x) {
  %res = extractelement <8 x i29> %x, i32 7
  ret i29 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v1i30:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i30 @extract_0_from_v1i30(i32 %ignore, <1 x i30> %x) {
  %res = extractelement <1 x i30> %x, i32 0
  ret i30 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v2i30:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK-NEXT:  mov $m1, $m3
; CHECK:       br $m10
define i30 @extract_0_from_v2i30(i32 %ignore, <2 x i30> %x) {
  %res = extractelement <2 x i30> %x, i32 0
  ret i30 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v2i30:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i30 @extract_1_from_v2i30(i32 %ignore, <2 x i30> %x) {
  %res = extractelement <2 x i30> %x, i32 1
  ret i30 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v3i30:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i30 @extract_0_from_v3i30(i32 %ignore, <3 x i30> %x) {
  %res = extractelement <3 x i30> %x, i32 0
  ret i30 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v3i30:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i30 @extract_1_from_v3i30(i32 %ignore, <3 x i30> %x) {
  %res = extractelement <3 x i30> %x, i32 1
  ret i30 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v3i30:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i30 @extract_2_from_v3i30(i32 %ignore, <3 x i30> %x) {
  %res = extractelement <3 x i30> %x, i32 2
  ret i30 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v4i30:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i30 @extract_0_from_v4i30(i32 %ignore, <4 x i30> %x) {
  %res = extractelement <4 x i30> %x, i32 0
  ret i30 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v4i30:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i30 @extract_1_from_v4i30(i32 %ignore, <4 x i30> %x) {
  %res = extractelement <4 x i30> %x, i32 1
  ret i30 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v4i30:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i30 @extract_2_from_v4i30(i32 %ignore, <4 x i30> %x) {
  %res = extractelement <4 x i30> %x, i32 2
  ret i30 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v4i30:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i30 @extract_3_from_v4i30(i32 %ignore, <4 x i30> %x) {
  %res = extractelement <4 x i30> %x, i32 3
  ret i30 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v5i30:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i30 @extract_0_from_v5i30(i32 %ignore, <5 x i30> %x) {
  %res = extractelement <5 x i30> %x, i32 0
  ret i30 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v5i30:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i30 @extract_1_from_v5i30(i32 %ignore, <5 x i30> %x) {
  %res = extractelement <5 x i30> %x, i32 1
  ret i30 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v5i30:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i30 @extract_2_from_v5i30(i32 %ignore, <5 x i30> %x) {
  %res = extractelement <5 x i30> %x, i32 2
  ret i30 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v5i30:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i30 @extract_3_from_v5i30(i32 %ignore, <5 x i30> %x) {
  %res = extractelement <5 x i30> %x, i32 3
  ret i30 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v5i30:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i30 @extract_4_from_v5i30(i32 %ignore, <5 x i30> %x) {
  %res = extractelement <5 x i30> %x, i32 4
  ret i30 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v6i30:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i30 @extract_0_from_v6i30(i32 %ignore, <6 x i30> %x) {
  %res = extractelement <6 x i30> %x, i32 0
  ret i30 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v6i30:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i30 @extract_1_from_v6i30(i32 %ignore, <6 x i30> %x) {
  %res = extractelement <6 x i30> %x, i32 1
  ret i30 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v6i30:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i30 @extract_2_from_v6i30(i32 %ignore, <6 x i30> %x) {
  %res = extractelement <6 x i30> %x, i32 2
  ret i30 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v6i30:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i30 @extract_3_from_v6i30(i32 %ignore, <6 x i30> %x) {
  %res = extractelement <6 x i30> %x, i32 3
  ret i30 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v6i30:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i30 @extract_4_from_v6i30(i32 %ignore, <6 x i30> %x) {
  %res = extractelement <6 x i30> %x, i32 4
  ret i30 %res
}
; CC: scalarise
; CHECK-LABEL: extract_5_from_v6i30:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 2
; CHECK:       br $m10
define i30 @extract_5_from_v6i30(i32 %ignore, <6 x i30> %x) {
  %res = extractelement <6 x i30> %x, i32 5
  ret i30 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v7i30:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i30 @extract_0_from_v7i30(i32 %ignore, <7 x i30> %x) {
  %res = extractelement <7 x i30> %x, i32 0
  ret i30 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v7i30:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i30 @extract_1_from_v7i30(i32 %ignore, <7 x i30> %x) {
  %res = extractelement <7 x i30> %x, i32 1
  ret i30 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v7i30:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i30 @extract_2_from_v7i30(i32 %ignore, <7 x i30> %x) {
  %res = extractelement <7 x i30> %x, i32 2
  ret i30 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v7i30:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i30 @extract_3_from_v7i30(i32 %ignore, <7 x i30> %x) {
  %res = extractelement <7 x i30> %x, i32 3
  ret i30 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v7i30:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i30 @extract_4_from_v7i30(i32 %ignore, <7 x i30> %x) {
  %res = extractelement <7 x i30> %x, i32 4
  ret i30 %res
}
; CC: scalarise
; CHECK-LABEL: extract_5_from_v7i30:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 2
; CHECK:       br $m10
define i30 @extract_5_from_v7i30(i32 %ignore, <7 x i30> %x) {
  %res = extractelement <7 x i30> %x, i32 5
  ret i30 %res
}
; CC: scalarise
; CHECK-LABEL: extract_6_from_v7i30:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 3
; CHECK:       br $m10
define i30 @extract_6_from_v7i30(i32 %ignore, <7 x i30> %x) {
  %res = extractelement <7 x i30> %x, i32 6
  ret i30 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v8i30:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i30 @extract_0_from_v8i30(i32 %ignore, <8 x i30> %x) {
  %res = extractelement <8 x i30> %x, i32 0
  ret i30 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v8i30:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i30 @extract_1_from_v8i30(i32 %ignore, <8 x i30> %x) {
  %res = extractelement <8 x i30> %x, i32 1
  ret i30 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v8i30:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i30 @extract_2_from_v8i30(i32 %ignore, <8 x i30> %x) {
  %res = extractelement <8 x i30> %x, i32 2
  ret i30 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v8i30:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i30 @extract_3_from_v8i30(i32 %ignore, <8 x i30> %x) {
  %res = extractelement <8 x i30> %x, i32 3
  ret i30 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v8i30:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i30 @extract_4_from_v8i30(i32 %ignore, <8 x i30> %x) {
  %res = extractelement <8 x i30> %x, i32 4
  ret i30 %res
}
; CC: scalarise
; CHECK-LABEL: extract_5_from_v8i30:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 2
; CHECK:       br $m10
define i30 @extract_5_from_v8i30(i32 %ignore, <8 x i30> %x) {
  %res = extractelement <8 x i30> %x, i32 5
  ret i30 %res
}
; CC: scalarise
; CHECK-LABEL: extract_6_from_v8i30:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 3
; CHECK:       br $m10
define i30 @extract_6_from_v8i30(i32 %ignore, <8 x i30> %x) {
  %res = extractelement <8 x i30> %x, i32 6
  ret i30 %res
}
; CC: scalarise
; CHECK-LABEL: extract_7_from_v8i30:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 4
; CHECK:       br $m10
define i30 @extract_7_from_v8i30(i32 %ignore, <8 x i30> %x) {
  %res = extractelement <8 x i30> %x, i32 7
  ret i30 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v1i31:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i31 @extract_0_from_v1i31(i32 %ignore, <1 x i31> %x) {
  %res = extractelement <1 x i31> %x, i32 0
  ret i31 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v2i31:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK-NEXT:  mov $m1, $m3
; CHECK:       br $m10
define i31 @extract_0_from_v2i31(i32 %ignore, <2 x i31> %x) {
  %res = extractelement <2 x i31> %x, i32 0
  ret i31 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v2i31:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i31 @extract_1_from_v2i31(i32 %ignore, <2 x i31> %x) {
  %res = extractelement <2 x i31> %x, i32 1
  ret i31 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v3i31:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i31 @extract_0_from_v3i31(i32 %ignore, <3 x i31> %x) {
  %res = extractelement <3 x i31> %x, i32 0
  ret i31 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v3i31:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i31 @extract_1_from_v3i31(i32 %ignore, <3 x i31> %x) {
  %res = extractelement <3 x i31> %x, i32 1
  ret i31 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v3i31:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i31 @extract_2_from_v3i31(i32 %ignore, <3 x i31> %x) {
  %res = extractelement <3 x i31> %x, i32 2
  ret i31 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v4i31:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i31 @extract_0_from_v4i31(i32 %ignore, <4 x i31> %x) {
  %res = extractelement <4 x i31> %x, i32 0
  ret i31 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v4i31:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i31 @extract_1_from_v4i31(i32 %ignore, <4 x i31> %x) {
  %res = extractelement <4 x i31> %x, i32 1
  ret i31 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v4i31:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i31 @extract_2_from_v4i31(i32 %ignore, <4 x i31> %x) {
  %res = extractelement <4 x i31> %x, i32 2
  ret i31 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v4i31:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i31 @extract_3_from_v4i31(i32 %ignore, <4 x i31> %x) {
  %res = extractelement <4 x i31> %x, i32 3
  ret i31 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v5i31:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i31 @extract_0_from_v5i31(i32 %ignore, <5 x i31> %x) {
  %res = extractelement <5 x i31> %x, i32 0
  ret i31 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v5i31:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i31 @extract_1_from_v5i31(i32 %ignore, <5 x i31> %x) {
  %res = extractelement <5 x i31> %x, i32 1
  ret i31 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v5i31:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i31 @extract_2_from_v5i31(i32 %ignore, <5 x i31> %x) {
  %res = extractelement <5 x i31> %x, i32 2
  ret i31 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v5i31:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i31 @extract_3_from_v5i31(i32 %ignore, <5 x i31> %x) {
  %res = extractelement <5 x i31> %x, i32 3
  ret i31 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v5i31:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i31 @extract_4_from_v5i31(i32 %ignore, <5 x i31> %x) {
  %res = extractelement <5 x i31> %x, i32 4
  ret i31 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v6i31:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i31 @extract_0_from_v6i31(i32 %ignore, <6 x i31> %x) {
  %res = extractelement <6 x i31> %x, i32 0
  ret i31 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v6i31:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i31 @extract_1_from_v6i31(i32 %ignore, <6 x i31> %x) {
  %res = extractelement <6 x i31> %x, i32 1
  ret i31 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v6i31:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i31 @extract_2_from_v6i31(i32 %ignore, <6 x i31> %x) {
  %res = extractelement <6 x i31> %x, i32 2
  ret i31 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v6i31:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i31 @extract_3_from_v6i31(i32 %ignore, <6 x i31> %x) {
  %res = extractelement <6 x i31> %x, i32 3
  ret i31 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v6i31:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i31 @extract_4_from_v6i31(i32 %ignore, <6 x i31> %x) {
  %res = extractelement <6 x i31> %x, i32 4
  ret i31 %res
}
; CC: scalarise
; CHECK-LABEL: extract_5_from_v6i31:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 2
; CHECK:       br $m10
define i31 @extract_5_from_v6i31(i32 %ignore, <6 x i31> %x) {
  %res = extractelement <6 x i31> %x, i32 5
  ret i31 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v7i31:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i31 @extract_0_from_v7i31(i32 %ignore, <7 x i31> %x) {
  %res = extractelement <7 x i31> %x, i32 0
  ret i31 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v7i31:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i31 @extract_1_from_v7i31(i32 %ignore, <7 x i31> %x) {
  %res = extractelement <7 x i31> %x, i32 1
  ret i31 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v7i31:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i31 @extract_2_from_v7i31(i32 %ignore, <7 x i31> %x) {
  %res = extractelement <7 x i31> %x, i32 2
  ret i31 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v7i31:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i31 @extract_3_from_v7i31(i32 %ignore, <7 x i31> %x) {
  %res = extractelement <7 x i31> %x, i32 3
  ret i31 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v7i31:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i31 @extract_4_from_v7i31(i32 %ignore, <7 x i31> %x) {
  %res = extractelement <7 x i31> %x, i32 4
  ret i31 %res
}
; CC: scalarise
; CHECK-LABEL: extract_5_from_v7i31:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 2
; CHECK:       br $m10
define i31 @extract_5_from_v7i31(i32 %ignore, <7 x i31> %x) {
  %res = extractelement <7 x i31> %x, i32 5
  ret i31 %res
}
; CC: scalarise
; CHECK-LABEL: extract_6_from_v7i31:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 3
; CHECK:       br $m10
define i31 @extract_6_from_v7i31(i32 %ignore, <7 x i31> %x) {
  %res = extractelement <7 x i31> %x, i32 6
  ret i31 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v8i31:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i31 @extract_0_from_v8i31(i32 %ignore, <8 x i31> %x) {
  %res = extractelement <8 x i31> %x, i32 0
  ret i31 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v8i31:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i31 @extract_1_from_v8i31(i32 %ignore, <8 x i31> %x) {
  %res = extractelement <8 x i31> %x, i32 1
  ret i31 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v8i31:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i31 @extract_2_from_v8i31(i32 %ignore, <8 x i31> %x) {
  %res = extractelement <8 x i31> %x, i32 2
  ret i31 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v8i31:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i31 @extract_3_from_v8i31(i32 %ignore, <8 x i31> %x) {
  %res = extractelement <8 x i31> %x, i32 3
  ret i31 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v8i31:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i31 @extract_4_from_v8i31(i32 %ignore, <8 x i31> %x) {
  %res = extractelement <8 x i31> %x, i32 4
  ret i31 %res
}
; CC: scalarise
; CHECK-LABEL: extract_5_from_v8i31:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 2
; CHECK:       br $m10
define i31 @extract_5_from_v8i31(i32 %ignore, <8 x i31> %x) {
  %res = extractelement <8 x i31> %x, i32 5
  ret i31 %res
}
; CC: scalarise
; CHECK-LABEL: extract_6_from_v8i31:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 3
; CHECK:       br $m10
define i31 @extract_6_from_v8i31(i32 %ignore, <8 x i31> %x) {
  %res = extractelement <8 x i31> %x, i32 6
  ret i31 %res
}
; CC: scalarise
; CHECK-LABEL: extract_7_from_v8i31:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 4
; CHECK:       br $m10
define i31 @extract_7_from_v8i31(i32 %ignore, <8 x i31> %x) {
  %res = extractelement <8 x i31> %x, i32 7
  ret i31 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v1i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i32 @extract_0_from_v1i32(i32 %ignore, <1 x i32> %x) {
  %res = extractelement <1 x i32> %x, i32 0
  ret i32 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v2i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK-NEXT:  mov $m1, $m3
; CHECK:       br $m10
define i32 @extract_0_from_v2i32(i32 %ignore, <2 x i32> %x) {
  %res = extractelement <2 x i32> %x, i32 0
  ret i32 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v2i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i32 @extract_1_from_v2i32(i32 %ignore, <2 x i32> %x) {
  %res = extractelement <2 x i32> %x, i32 1
  ret i32 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v3i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i32 @extract_0_from_v3i32(i32 %ignore, <3 x i32> %x) {
  %res = extractelement <3 x i32> %x, i32 0
  ret i32 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v3i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i32 @extract_1_from_v3i32(i32 %ignore, <3 x i32> %x) {
  %res = extractelement <3 x i32> %x, i32 1
  ret i32 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v3i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i32 @extract_2_from_v3i32(i32 %ignore, <3 x i32> %x) {
  %res = extractelement <3 x i32> %x, i32 2
  ret i32 %res
}
; CC: pass as 2 v2i32
; CHECK-LABEL: extract_0_from_v4i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK-NEXT:  mov $m1, $m3
; CHECK:       br $m10
define i32 @extract_0_from_v4i32(i32 %ignore, <4 x i32> %x) {
  %res = extractelement <4 x i32> %x, i32 0
  ret i32 %res
}
; CC: pass as 2 v2i32
; CHECK-LABEL: extract_1_from_v4i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i32 @extract_1_from_v4i32(i32 %ignore, <4 x i32> %x) {
  %res = extractelement <4 x i32> %x, i32 1
  ret i32 %res
}
; CC: pass as 2 v2i32
; CHECK-LABEL: extract_2_from_v4i32:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i32 @extract_2_from_v4i32(i32 %ignore, <4 x i32> %x) {
  %res = extractelement <4 x i32> %x, i32 2
  ret i32 %res
}
; CC: pass as 2 v2i32
; CHECK-LABEL: extract_3_from_v4i32:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i32 @extract_3_from_v4i32(i32 %ignore, <4 x i32> %x) {
  %res = extractelement <4 x i32> %x, i32 3
  ret i32 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v5i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i32 @extract_0_from_v5i32(i32 %ignore, <5 x i32> %x) {
  %res = extractelement <5 x i32> %x, i32 0
  ret i32 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v5i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i32 @extract_1_from_v5i32(i32 %ignore, <5 x i32> %x) {
  %res = extractelement <5 x i32> %x, i32 1
  ret i32 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v5i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i32 @extract_2_from_v5i32(i32 %ignore, <5 x i32> %x) {
  %res = extractelement <5 x i32> %x, i32 2
  ret i32 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v5i32:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i32 @extract_3_from_v5i32(i32 %ignore, <5 x i32> %x) {
  %res = extractelement <5 x i32> %x, i32 3
  ret i32 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v5i32:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i32 @extract_4_from_v5i32(i32 %ignore, <5 x i32> %x) {
  %res = extractelement <5 x i32> %x, i32 4
  ret i32 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v6i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i32 @extract_0_from_v6i32(i32 %ignore, <6 x i32> %x) {
  %res = extractelement <6 x i32> %x, i32 0
  ret i32 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v6i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i32 @extract_1_from_v6i32(i32 %ignore, <6 x i32> %x) {
  %res = extractelement <6 x i32> %x, i32 1
  ret i32 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v6i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i32 @extract_2_from_v6i32(i32 %ignore, <6 x i32> %x) {
  %res = extractelement <6 x i32> %x, i32 2
  ret i32 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v6i32:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i32 @extract_3_from_v6i32(i32 %ignore, <6 x i32> %x) {
  %res = extractelement <6 x i32> %x, i32 3
  ret i32 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v6i32:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i32 @extract_4_from_v6i32(i32 %ignore, <6 x i32> %x) {
  %res = extractelement <6 x i32> %x, i32 4
  ret i32 %res
}
; CC: scalarise
; CHECK-LABEL: extract_5_from_v6i32:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 2
; CHECK:       br $m10
define i32 @extract_5_from_v6i32(i32 %ignore, <6 x i32> %x) {
  %res = extractelement <6 x i32> %x, i32 5
  ret i32 %res
}
; CC: scalarise
; CHECK-LABEL: extract_0_from_v7i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m1
; CHECK:       br $m10
define i32 @extract_0_from_v7i32(i32 %ignore, <7 x i32> %x) {
  %res = extractelement <7 x i32> %x, i32 0
  ret i32 %res
}
; CC: scalarise
; CHECK-LABEL: extract_1_from_v7i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK:       br $m10
define i32 @extract_1_from_v7i32(i32 %ignore, <7 x i32> %x) {
  %res = extractelement <7 x i32> %x, i32 1
  ret i32 %res
}
; CC: scalarise
; CHECK-LABEL: extract_2_from_v7i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i32 @extract_2_from_v7i32(i32 %ignore, <7 x i32> %x) {
  %res = extractelement <7 x i32> %x, i32 2
  ret i32 %res
}
; CC: scalarise
; CHECK-LABEL: extract_3_from_v7i32:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i32 @extract_3_from_v7i32(i32 %ignore, <7 x i32> %x) {
  %res = extractelement <7 x i32> %x, i32 3
  ret i32 %res
}
; CC: scalarise
; CHECK-LABEL: extract_4_from_v7i32:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i32 @extract_4_from_v7i32(i32 %ignore, <7 x i32> %x) {
  %res = extractelement <7 x i32> %x, i32 4
  ret i32 %res
}
; CC: scalarise
; CHECK-LABEL: extract_5_from_v7i32:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 2
; CHECK:       br $m10
define i32 @extract_5_from_v7i32(i32 %ignore, <7 x i32> %x) {
  %res = extractelement <7 x i32> %x, i32 5
  ret i32 %res
}
; CC: scalarise
; CHECK-LABEL: extract_6_from_v7i32:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 3
; CHECK:       br $m10
define i32 @extract_6_from_v7i32(i32 %ignore, <7 x i32> %x) {
  %res = extractelement <7 x i32> %x, i32 6
  ret i32 %res
}
; CC: pass as 4 v2i32
; CHECK-LABEL: extract_0_from_v8i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m2
; CHECK-NEXT:  mov $m1, $m3
; CHECK:       br $m10
define i32 @extract_0_from_v8i32(i32 %ignore, <8 x i32> %x) {
  %res = extractelement <8 x i32> %x, i32 0
  ret i32 %res
}
; CC: pass as 4 v2i32
; CHECK-LABEL: extract_1_from_v8i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m3
; CHECK:       br $m10
define i32 @extract_1_from_v8i32(i32 %ignore, <8 x i32> %x) {
  %res = extractelement <8 x i32> %x, i32 1
  ret i32 %res
}
; CC: pass as 4 v2i32
; CHECK-LABEL: extract_2_from_v8i32:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 0
; CHECK:       br $m10
define i32 @extract_2_from_v8i32(i32 %ignore, <8 x i32> %x) {
  %res = extractelement <8 x i32> %x, i32 2
  ret i32 %res
}
; CC: pass as 4 v2i32
; CHECK-LABEL: extract_3_from_v8i32:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 1
; CHECK:       br $m10
define i32 @extract_3_from_v8i32(i32 %ignore, <8 x i32> %x) {
  %res = extractelement <8 x i32> %x, i32 3
  ret i32 %res
}
; CC: pass as 4 v2i32
; CHECK-LABEL: extract_4_from_v8i32:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 2
; CHECK:       br $m10
define i32 @extract_4_from_v8i32(i32 %ignore, <8 x i32> %x) {
  %res = extractelement <8 x i32> %x, i32 4
  ret i32 %res
}
; CC: pass as 4 v2i32
; CHECK-LABEL: extract_5_from_v8i32:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 3
; CHECK:       br $m10
define i32 @extract_5_from_v8i32(i32 %ignore, <8 x i32> %x) {
  %res = extractelement <8 x i32> %x, i32 5
  ret i32 %res
}
; CC: pass as 4 v2i32
; CHECK-LABEL: extract_6_from_v8i32:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 4
; CHECK:       br $m10
define i32 @extract_6_from_v8i32(i32 %ignore, <8 x i32> %x) {
  %res = extractelement <8 x i32> %x, i32 6
  ret i32 %res
}
; CC: pass as 4 v2i32
; CHECK-LABEL: extract_7_from_v8i32:
; CHECK:       # %bb.0:
; CHECK:       ld32 $m{{[0-9]+}}, $m11, $m15, 5
; CHECK:       br $m10
define i32 @extract_7_from_v8i32(i32 %ignore, <8 x i32> %x) {
  %res = extractelement <8 x i32> %x, i32 7
  ret i32 %res
}
