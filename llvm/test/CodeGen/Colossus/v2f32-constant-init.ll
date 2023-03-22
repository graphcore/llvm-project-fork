; RUN: llc -march=colossus -colossus-coissue=false %s -mattr=+ipu1 -o - | FileCheck %s
; RUN: llc -march=colossus -colossus-coissue=false %s -mattr=+ipu2 -o - | FileCheck %s

; CHECK-LABEL: v2f32_const_init_1:
; CHECK:      # %bb.0:
; CHECK:      br $m10
define <2 x float> @v2f32_const_init_1() {
	  ret <2 x float> <float undef, float undef>
}

; CHECK-LABEL: v2f32_const_init_2:
; CHECK:      # %bb.0:
; CHECK-NEXT: not64 $a0:1, $a14:15
; CHECK:      br $m10
define <2 x float> @v2f32_const_init_2() {
	  ret <2 x float> <float undef, float 0xFFFFFFFFE0000000>
}

; CHECK-LABEL: v2f32_const_init_3:
; CHECK:      # %bb.0:
; CHECK-NEXT: mov $a0, $a15
; CHECK-NEXT: setzi [[SETREG:\$a[0-5]]], 699050
; CHECK-NEXT: or $a1, [[SETREG]], 2862612480
; CHECK:      br $m10
define <2 x float> @v2f32_const_init_3() {
	  ret <2 x float> <float undef, float 0xBD55555540000000>
}

; CHECK-LABEL: v2f32_const_init_4:
; CHECK:      # %bb.0:
; CHECK-NEXT: not64 $a0:1, $a14:15
; CHECK:      br $m10
define <2 x float> @v2f32_const_init_4() {
	  ret <2 x float> <float 0xFFFFFFFFE0000000, float undef>
}

; CHECK-LABEL: v2f32_const_init_5:
; CHECK:      # %bb.0:
; CHECK-NEXT: not64 $a0:1, $a14:15
; CHECK:      br $m10
define <2 x float> @v2f32_const_init_5() {
	  ret <2 x float> <float 0xFFFFFFFFE0000000, float 0xFFFFFFFFE0000000>
}

; CHECK-LABEL: v2f32_const_init_6:
; CHECK:      # %bb.0:
; CHECK-NEXT: not $a0, $a15
; CHECK-NEXT: setzi [[SETREG:\$a[0-5]]], 699050
; CHECK-NEXT: or $a1, [[SETREG]], 2862612480
; CHECK:      br $m10
define <2 x float> @v2f32_const_init_6() {
	  ret <2 x float> <float 0xFFFFFFFFE0000000, float 0xBD55555540000000>
}

; CHECK-LABEL: v2f32_const_init_7:
; CHECK:      # %bb.0:
; CHECK-NEXT: setzi [[SETREG:\$a[0-5]]], 699050
; CHECK-NEXT: or $a0, [[SETREG]], 2862612480
; CHECK-NEXT: mov $a1, $a15
; CHECK:      br $m10
define <2 x float> @v2f32_const_init_7() {
	  ret <2 x float> <float 0xBD55555540000000, float undef>
}

; CHECK-LABEL: v2f32_const_init_8:
; CHECK:      # %bb.0:
; CHECK-NEXT: setzi [[SETREG:\$a[0-5]]], 699050
; CHECK-NEXT: or $a0, [[SETREG]], 2862612480
; CHECK-NEXT: not $a1, $a15
; CHECK:      br $m10
define <2 x float> @v2f32_const_init_8() {
	  ret <2 x float> <float 0xBD55555540000000, float 0xFFFFFFFFE0000000>
}

; CHECK-LABEL: v2f32_const_init_9:
; CHECK:      # %bb.0:
; CHECK-NEXT: setzi [[SETREG:\$a[0-5]]], 699050
; CHECK-NEXT: or $a0, [[SETREG]], 2862612480
; CHECK-NEXT: mov $a1, $a0
; CHECK:      br $m10
define <2 x float> @v2f32_const_init_9() {
	  ret <2 x float> <float 0xBD55555540000000, float 0xBD55555540000000>
}
