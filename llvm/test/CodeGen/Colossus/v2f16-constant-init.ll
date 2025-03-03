; RUN: llc -march=colossus -colossus-coissue=false %s -mattr=+ipu1 -o - | FileCheck %s
; RUN: llc -march=colossus -colossus-coissue=false %s -mattr=+ipu2 -o - | FileCheck %s

; CHECK-LABEL: v2f16_const_init_1:
; CHECK:      # %bb.0:
; CHECK:      br $m10
define <2 x half> @v2f16_const_init_1() {
	  ret <2 x half> <half undef, half undef>
}

; CHECK-LABEL: v2f16_const_init_2:
; CHECK:      # %bb.0:
; CHECK-NEXT: not $a0, $a15
; CHECK:      br $m10
define <2 x half> @v2f16_const_init_2() {
	  ret <2 x half> <half undef, half 0xHFFFF>
}

; CHECK-LABEL: v2f16_const_init_3:
; CHECK:      # %bb.0:
; CHECK-NEXT: setzi [[SETREG:\$a[0-5]]], 655360
; CHECK-NEXT: or $a0, [[SETREG]], 2862612480
; CHECK:      br $m10
define <2 x half> @v2f16_const_init_3() {
	  ret <2 x half> <half undef, half 0xHAAAA>
}

; CHECK-LABEL: v2f16_const_init_4:
; CHECK:      # %bb.0:
; CHECK-NEXT: not $a0, $a15
; CHECK:      br $m10
define <2 x half> @v2f16_const_init_4() {
	  ret <2 x half> <half 0xHFFFF, half undef>
}

; CHECK-LABEL: v2f16_const_init_5:
; CHECK:      # %bb.0:
; CHECK-NEXT: not $a0, $a15
; CHECK:      br $m10
define <2 x half> @v2f16_const_init_5() {
	  ret <2 x half> <half 0xHFFFF, half 0xHFFFF>
}

; CHECK-LABEL: v2f16_const_init_6:
; CHECK:      # %bb.0:
; CHECK-NEXT: setzi [[SETREG:\$a[0-5]]], 720895
; CHECK-NEXT: or $a0, [[SETREG]], 2862612480
; CHECK:      br $m10
define <2 x half> @v2f16_const_init_6() {
	  ret <2 x half> <half 0xHFFFF, half 0xHAAAA>
}

; CHECK-LABEL: v2f16_const_init_7:
; CHECK:      # %bb.0:
; CHECK-NEXT: setzi $a0, 43690
; CHECK:      br $m10
define <2 x half> @v2f16_const_init_7() {
	  ret <2 x half> <half 0xHAAAA, half undef>
}

; CHECK-LABEL: v2f16_const_init_8:
; CHECK:      # %bb.0:
; CHECK-NEXT: setzi [[SETREG:\$a[0-5]]], 1026730
; CHECK-NEXT: or $a0, [[SETREG]], 4293918720
; CHECK:      br $m10
define <2 x half> @v2f16_const_init_8() {
	  ret <2 x half> <half 0xHAAAA, half 0xHFFFF>
}

; CHECK-LABEL: v2f16_const_init_9:
; CHECK:      # %bb.0:
; CHECK-NEXT: setzi [[SETREG:\$a[0-5]]], 699050
; CHECK-NEXT: or $a0, [[SETREG]], 2862612480
; CHECK:      br $m10
define <2 x half> @v2f16_const_init_9() {
	  ret <2 x half> <half 0xHAAAA, half 0xHAAAA>
}
