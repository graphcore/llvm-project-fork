; RUN: llc -march=colossus -colossus-coissue=false %s -mattr=+ipu1 -o - | FileCheck %s
; RUN: llc -march=colossus -colossus-coissue=false %s -mattr=+ipu2 -o - | FileCheck %s

; CHECK-LABEL: v2i16_const_init_1:
; CHECK:      # %bb.0:
; CHECK:      br $m10
define <2 x i16> @v2i16_const_init_1() {
	  ret <2 x i16> <i16 undef, i16 undef>
}

; CHECK-LABEL: v2i16_const_init_2:
; CHECK:      # %bb.0:
; CHECK-NEXT: add $m0, $m15, -1
; CHECK:      br $m10
define <2 x i16> @v2i16_const_init_2() {
	  ret <2 x i16> <i16 undef, i16 65535>
}

; CHECK-LABEL: v2i16_const_init_3:
; CHECK:      # %bb.0:
; CHECK-NEXT: setzi [[SETREG:\$m[0-6]]], 655360
; CHECK-NEXT: or $m0, [[SETREG]], 2862612480
; CHECK:      br $m10
define <2 x i16> @v2i16_const_init_3() {
	  ret <2 x i16> <i16 undef, i16 43690>
}

; CHECK-LABEL: v2i16_const_init_4:
; CHECK:      # %bb.0:
; CHECK-NEXT: add $m0, $m15, -1
; CHECK:      br $m10
define <2 x i16> @v2i16_const_init_4() {
	  ret <2 x i16> <i16 65535, i16 undef>
}

; CHECK-LABEL: v2i16_const_init_5:
; CHECK:      # %bb.0:
; CHECK-NEXT: add $m0, $m15, -1
; CHECK:      br $m10
define <2 x i16> @v2i16_const_init_5() {
	  ret <2 x i16> <i16 65535, i16 65535>
}

; CHECK-LABEL: v2i16_const_init_6:
; CHECK:      # %bb.0:
; CHECK-NEXT: setzi [[SETREG:\$m[0-6]]], 720895
; CHECK-NEXT: or $m0, [[SETREG]], 2862612480
; CHECK:      br $m10
define <2 x i16> @v2i16_const_init_6() {
	  ret <2 x i16> <i16 65535, i16 43690>
}

; CHECK-LABEL: v2i16_const_init_7:
; CHECK:      # %bb.0:
; CHECK-NEXT: setzi $m0, 43690
; CHECK:      br $m10
define <2 x i16> @v2i16_const_init_7() {
	  ret <2 x i16> <i16 43690, i16 undef>
}

; CHECK-LABEL: v2i16_const_init_8:
; CHECK:      # %bb.0:
; CHECK-NEXT: add $m0, $m15, -21846
; CHECK:      br $m10
define <2 x i16> @v2i16_const_init_8() {
	  ret <2 x i16> <i16 43690, i16 65535>
}

; CHECK-LABEL: v2i16_const_init_9:
; CHECK:      # %bb.0:
; CHECK-NEXT: setzi [[SETREG:\$m[0-6]]], 699050
; CHECK-NEXT: or $m0, [[SETREG]], 2862612480
; CHECK:      br $m10
define <2 x i16> @v2i16_const_init_9() {
	  ret <2 x i16> <i16 43690, i16 43690>
}
