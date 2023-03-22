; RUN: llc < %s -colossus-coissue=false -march=colossus -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -colossus-coissue=false -march=colossus -mattr=+ipu2 | FileCheck %s

; CHECK-LABEL: v2f16_extract_high_insert_high:
; CHECK:      # %bb.0:
; CHECK-NEXT: roll16 $a0, $a0, $a1
; CHECK-NEXT: swap16 $a0, $a0
; CHECK-NEXT: br $m10
define <2 x half> @v2f16_extract_high_insert_high(<2 x half> %v, half %h) {
   %v2 = extractelement <2 x half> %v, i32 1
   %v3 = insertelement <2 x half> undef, half %v2, i32 1
   %v4 = insertelement <2 x half> %v3, half %h, i32 0
   ret <2 x half> %v4
}

; CHECK-LABEL: v2f16_extract_low_insert_low:
; CHECK:      # %bb.0:
; CHECK-NEXT: sort4x16lo $a0, $a0, $a1
; CHECK-NEXT: br $m10
define <2 x half> @v2f16_extract_low_insert_low(<2 x half> %v, half %h) {
   %v2 = extractelement <2 x half> %v, i32 0
   %v3 = insertelement <2 x half> undef, half %v2, i32 0
   %v4 = insertelement <2 x half> %v3, half %h, i32 1
   ret <2 x half> %v4
}

; CHECK-LABEL: v2f16_extract_low_insert_high:
; CHECK:      # %bb.0:
; CHECK-NEXT: sort4x16lo $a0, $a1, $a0
; CHECK-NEXT: br $m10
define <2 x half> @v2f16_extract_low_insert_high(<2 x half> %v, half %h) {
   %v2 = extractelement <2 x half> %v, i32 0
   %v3 = insertelement <2 x half> undef, half %v2, i32 1
   %v4 = insertelement <2 x half> %v3, half %h, i32 0
   ret <2 x half> %v4
}

; CHECK-LABEL: v2f16_extract_high_insert_low:
; CHECK:      # %bb.0:
; CHECK-NEXT: roll16 $a0, $a0, $a1
; CHECK-NEXT: br $m10
define <2 x half> @v2f16_extract_high_insert_low(<2 x half> %v, half %h) {
   %v2 = extractelement <2 x half> %v, i32 1
   %v3 = insertelement <2 x half> undef, half %v2, i32 0
   %v4 = insertelement <2 x half> %v3, half %h, i32 1
   ret <2 x half> %v4
}

; CHECK-LABEL: v2i16_extract_high_insert_high:
; CHECK:      # %bb.0:
; CHECK-NEXT: roll16 $m0, $m0, $m1
; CHECK-NEXT: swap16 $m0, $m0
; CHECK-NEXT: br $m10
define <2 x i16> @v2i16_extract_high_insert_high(<2 x i16> %v, i16 %h) {
   %v2 = extractelement <2 x i16> %v, i32 1
   %v3 = insertelement <2 x i16> undef, i16 %v2, i32 1
   %v4 = insertelement <2 x i16> %v3, i16 %h, i32 0
   ret <2 x i16> %v4
}

; CHECK-LABEL: v2i16_extract_low_insert_low:
; CHECK:      # %bb.0:
; CHECK-NEXT: sort4x16lo $m0, $m0, $m1
; CHECK-NEXT: br $m10
define <2 x i16> @v2i16_extract_low_insert_low(<2 x i16> %v, i16 %h) {
   %v2 = extractelement <2 x i16> %v, i32 0
   %v3 = insertelement <2 x i16> undef, i16 %v2, i32 0
   %v4 = insertelement <2 x i16> %v3, i16 %h, i32 1
   ret <2 x i16> %v4
}

; CHECK-LABEL: v2i16_extract_low_insert_high:
; CHECK:      # %bb.0:
; CHECK-NEXT: sort4x16lo $m0, $m1, $m0
; CHECK-NEXT: br $m10
define <2 x i16> @v2i16_extract_low_insert_high(<2 x i16> %v, i16 %h) {
   %v2 = extractelement <2 x i16> %v, i32 0
   %v3 = insertelement <2 x i16> undef, i16 %v2, i32 1
   %v4 = insertelement <2 x i16> %v3, i16 %h, i32 0
   ret <2 x i16> %v4
}

; CHECK-LABEL: v2i16_extract_high_insert_low:
; CHECK:      # %bb.0:
; CHECK-NEXT: roll16 $m0, $m0, $m1
; CHECK-NEXT: br $m10
define <2 x i16> @v2i16_extract_high_insert_low(<2 x i16> %v, i16 %h) {
   %v2 = extractelement <2 x i16> %v, i32 1
   %v3 = insertelement <2 x i16> undef, i16 %v2, i32 0
   %v4 = insertelement <2 x i16> %v3, i16 %h, i32 1
   ret <2 x i16> %v4
}

