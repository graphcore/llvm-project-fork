; RUN: llc -march=colossus -colossus-coissue=false %s -mattr=+ipu1 -o - | FileCheck %s
; RUN: llc -march=colossus -colossus-coissue=false %s -mattr=+ipu2 -o - | FileCheck %s

; CHECK-LABEL: v4i16_const_init_1:
; CHECK:      # %bb.0:
; CHECK:      br $m10
define <4 x i16> @v4i16_const_init_1() {
	  ret <4 x i16> <i16 undef, i16 undef, i16 undef, i16 undef>
}

; CHECK-LABEL: v4i16_const_init_2:
; CHECK:      # %bb.0:
; CHECK-NEXT: add $m1, $m15, -1
; CHECK:      br $m10
define <4 x i16> @v4i16_const_init_2() {
	  ret <4 x i16> <i16 undef, i16 undef, i16 undef, i16 65535>
}

; CHECK-LABEL: v4i16_const_init_3:
; CHECK:      # %bb.0:
; CHECK-NEXT: setzi [[SETREG:\$m[0-6]]], 655360
; CHECK-NEXT: or $m1, [[SETREG]], 2862612480
; CHECK:      br $m10
define <4 x i16> @v4i16_const_init_3() {
	  ret <4 x i16> <i16 undef, i16 undef, i16 undef, i16 43690>
}

; CHECK-LABEL: v4i16_const_init_4:
; CHECK:      # %bb.0:
; CHECK-NEXT: add $m1, $m15, -1
; CHECK:      br $m10
define <4 x i16> @v4i16_const_init_4() {
	  ret <4 x i16> <i16 undef, i16 undef, i16 65535, i16 undef>
}

; CHECK-LABEL: v4i16_const_init_5:
; CHECK:      # %bb.0:
; CHECK-NEXT: add $m1, $m15, -1
; CHECK:      br $m10
define <4 x i16> @v4i16_const_init_5() {
	  ret <4 x i16> <i16 undef, i16 undef, i16 65535, i16 65535>
}

; CHECK-LABEL: v4i16_const_init_6:
; CHECK:      # %bb.0:
; CHECK-NEXT: setzi [[SETREG:\$m[0-6]]], 720895
; CHECK-NEXT: or $m1, [[SETREG]], 2862612480
; CHECK:      br $m10
define <4 x i16> @v4i16_const_init_6() {
	  ret <4 x i16> <i16 undef, i16 undef, i16 65535, i16 43690>
}

; CHECK-LABEL: v4i16_const_init_7:
; CHECK:      # %bb.0:
; CHECK-NEXT: setzi $m1, 43690
; CHECK:      br $m10
define <4 x i16> @v4i16_const_init_7() {
	  ret <4 x i16> <i16 undef, i16 undef, i16 43690, i16 undef>
}

; CHECK-LABEL: v4i16_const_init_8:
; CHECK:      # %bb.0:
; CHECK-NEXT: add $m1, $m15, -21846
; CHECK:      br $m10
define <4 x i16> @v4i16_const_init_8() {
	  ret <4 x i16> <i16 undef, i16 undef, i16 43690, i16 65535>
}

; CHECK-LABEL: v4i16_const_init_9:
; CHECK:      # %bb.0:
; CHECK-NEXT: setzi [[SETREG:\$m[0-6]]], 699050
; CHECK-NEXT: or $m1, [[SETREG]], 2862612480
; CHECK:      br $m10
define <4 x i16> @v4i16_const_init_9() {
	  ret <4 x i16> <i16 undef, i16 undef, i16 43690, i16 43690>
}

; CHECK-LABEL: v4i16_const_init_10:
; CHECK:      # %bb.0:
; CHECK-NEXT: add $m0, $m15, -1
; CHECK:      br $m10
define <4 x i16> @v4i16_const_init_10() {
	  ret <4 x i16> <i16 undef, i16 65535, i16 undef, i16 undef>
}

; CHECK-LABEL: v4i16_const_init_11:
; CHECK:      # %bb.0:
; CHECK-NEXT: add $m0, $m15, -1
; CHECK-NEXT: mov $m1, $m0
; CHECK:      br $m10
define <4 x i16> @v4i16_const_init_11() {
	  ret <4 x i16> <i16 undef, i16 65535, i16 undef, i16 65535>
}

; CHECK-LABEL: v4i16_const_init_12:
; CHECK:      # %bb.0:
; CHECK-NEXT: add $m0, $m15, -1
; CHECK-NEXT: setzi [[SETREG:\$m[0-6]]], 655360
; CHECK-NEXT: or $m1, [[SETREG]], 2862612480
; CHECK:      br $m10
define <4 x i16> @v4i16_const_init_12() {
	  ret <4 x i16> <i16 undef, i16 65535, i16 undef, i16 43690>
}

; CHECK-LABEL: v4i16_const_init_13:
; CHECK:      # %bb.0:
; CHECK-NEXT: add $m0, $m15, -1
; CHECK-NEXT: mov $m1, $m0
; CHECK:      br $m10
define <4 x i16> @v4i16_const_init_13() {
	  ret <4 x i16> <i16 undef, i16 65535, i16 65535, i16 undef>
}

; CHECK-LABEL: v4i16_const_init_14:
; CHECK:      # %bb.0:
; CHECK-NEXT: add $m0, $m15, -1
; CHECK-NEXT: mov $m1, $m0
; CHECK:      br $m10
define <4 x i16> @v4i16_const_init_14() {
	  ret <4 x i16> <i16 undef, i16 65535, i16 65535, i16 65535>
}

; CHECK-LABEL: v4i16_const_init_15:
; CHECK:      # %bb.0:
; CHECK-NEXT: add $m0, $m15, -1
; CHECK-NEXT: setzi [[SETREG:\$m[0-6]]], 720895
; CHECK-NEXT: or $m1, [[SETREG]], 2862612480
; CHECK:      br $m10
define <4 x i16> @v4i16_const_init_15() {
	  ret <4 x i16> <i16 undef, i16 65535, i16 65535, i16 43690>
}

; CHECK-LABEL: v4i16_const_init_16:
; CHECK:      # %bb.0:
; CHECK-NEXT: add $m0, $m15, -1
; CHECK-NEXT: setzi $m1, 43690
; CHECK:      br $m10
define <4 x i16> @v4i16_const_init_16() {
	  ret <4 x i16> <i16 undef, i16 65535, i16 43690, i16 undef>
}

; CHECK-LABEL: v4i16_const_init_17:
; CHECK:      # %bb.0:
; CHECK-NEXT: add $m0, $m15, -1
; CHECK-NEXT: add $m1, $m15, -21846
; CHECK:      br $m10
define <4 x i16> @v4i16_const_init_17() {
	  ret <4 x i16> <i16 undef, i16 65535, i16 43690, i16 65535>
}

; CHECK-LABEL: v4i16_const_init_18:
; CHECK:      # %bb.0:
; CHECK-NEXT: add $m0, $m15, -1
; CHECK-NEXT: setzi [[SETREG:\$m[0-6]]], 699050
; CHECK-NEXT: or $m1, [[SETREG]], 2862612480
; CHECK:      br $m10
define <4 x i16> @v4i16_const_init_18() {
	  ret <4 x i16> <i16 undef, i16 65535, i16 43690, i16 43690>
}

; CHECK-LABEL: v4i16_const_init_19:
; CHECK:      # %bb.0:
; CHECK-NEXT: setzi [[SETREG:\$m[0-6]]], 655360
; CHECK-NEXT: or $m0, [[SETREG]], 2862612480
; CHECK:      br $m10
define <4 x i16> @v4i16_const_init_19() {
	  ret <4 x i16> <i16 undef, i16 43690, i16 undef, i16 undef>
}

; CHECK-LABEL: v4i16_const_init_20:
; CHECK:      # %bb.0:
; CHECK-NEXT: setzi [[SETREG:\$m[0-6]]], 655360
; CHECK-NEXT: or $m0, [[SETREG]], 2862612480
; CHECK-NEXT: add $m1, $m15, -1
; CHECK:      br $m10
define <4 x i16> @v4i16_const_init_20() {
	  ret <4 x i16> <i16 undef, i16 43690, i16 undef, i16 65535>
}

; CHECK-LABEL: v4i16_const_init_21:
; CHECK:      # %bb.0:
; CHECK-NEXT: setzi [[SETREG:\$m[0-6]]], 655360
; CHECK-NEXT: or $m0, [[SETREG]], 2862612480
; CHECK-NEXT: mov $m1, $m0
; CHECK:      br $m10
define <4 x i16> @v4i16_const_init_21() {
	  ret <4 x i16> <i16 undef, i16 43690, i16 undef, i16 43690>
}

; CHECK-LABEL: v4i16_const_init_22:
; CHECK:      # %bb.0:
; CHECK-NEXT: setzi [[SETREG:\$m[0-6]]], 655360
; CHECK-NEXT: or $m0, [[SETREG]], 2862612480
; CHECK-NEXT: add $m1, $m15, -1
; CHECK:      br $m10
define <4 x i16> @v4i16_const_init_22() {
	  ret <4 x i16> <i16 undef, i16 43690, i16 65535, i16 undef>
}

; CHECK-LABEL: v4i16_const_init_23:
; CHECK:      # %bb.0:
; CHECK-NEXT: setzi [[SETREG:\$m[0-6]]], 655360
; CHECK-NEXT: or $m0, [[SETREG]], 2862612480
; CHECK-NEXT: add $m1, $m15, -1
; CHECK:      br $m10
define <4 x i16> @v4i16_const_init_23() {
	  ret <4 x i16> <i16 undef, i16 43690, i16 65535, i16 65535>
}

; CHECK-LABEL: v4i16_const_init_24:
; CHECK:      # %bb.0:
; CHECK-NEXT: setzi [[SETREG:\$m[0-6]]], 655360
; CHECK-NEXT: or $m0, [[SETREG]], 2862612480
; CHECK-NEXT: setzi [[SETREG:\$m[0-6]]], 720895
; CHECK-NEXT: or $m1, [[SETREG]], 2862612480
; CHECK:      br $m10
define <4 x i16> @v4i16_const_init_24() {
	  ret <4 x i16> <i16 undef, i16 43690, i16 65535, i16 43690>
}

; CHECK-LABEL: v4i16_const_init_25:
; CHECK:      # %bb.0:
; CHECK-NEXT: setzi [[SETREG:\$m[0-6]]], 655360
; CHECK-NEXT: or $m0, [[SETREG]], 2862612480
; CHECK-NEXT: setzi $m1, 43690
; CHECK:      br $m10
define <4 x i16> @v4i16_const_init_25() {
	  ret <4 x i16> <i16 undef, i16 43690, i16 43690, i16 undef>
}

; CHECK-LABEL: v4i16_const_init_26:
; CHECK:      # %bb.0:
; CHECK-NEXT: setzi [[SETREG:\$m[0-6]]], 655360
; CHECK-NEXT: or $m0, [[SETREG]], 2862612480
; CHECK-NEXT: add $m1, $m15, -21846
; CHECK:      br $m10
define <4 x i16> @v4i16_const_init_26() {
	  ret <4 x i16> <i16 undef, i16 43690, i16 43690, i16 65535>
}

; CHECK-LABEL: v4i16_const_init_27:
; CHECK:      # %bb.0:
; CHECK-NEXT: setzi [[SETREG:\$m[0-6]]], 655360
; CHECK-NEXT: or $m0, [[SETREG]], 2862612480
; CHECK-NEXT: setzi [[SETREG:\$m[0-6]]], 699050
; CHECK-NEXT: or $m1, [[SETREG]], 2862612480
; CHECK:      br $m10
define <4 x i16> @v4i16_const_init_27() {
	  ret <4 x i16> <i16 undef, i16 43690, i16 43690, i16 43690>
}

; CHECK-LABEL: v4i16_const_init_28:
; CHECK:      # %bb.0:
; CHECK-NEXT: add $m0, $m15, -1
; CHECK:      br $m10
define <4 x i16> @v4i16_const_init_28() {
	  ret <4 x i16> <i16 65535, i16 undef, i16 undef, i16 undef>
}

; CHECK-LABEL: v4i16_const_init_29:
; CHECK:      # %bb.0:
; CHECK-NEXT: add $m0, $m15, -1
; CHECK-NEXT: mov $m1, $m0
; CHECK:      br $m10
define <4 x i16> @v4i16_const_init_29() {
	  ret <4 x i16> <i16 65535, i16 undef, i16 undef, i16 65535>
}

; CHECK-LABEL: v4i16_const_init_30:
; CHECK:      # %bb.0:
; CHECK-NEXT: add $m0, $m15, -1
; CHECK-NEXT: setzi [[SETREG:\$m[0-6]]], 655360
; CHECK-NEXT: or $m1, [[SETREG]], 2862612480
; CHECK:      br $m10
define <4 x i16> @v4i16_const_init_30() {
	  ret <4 x i16> <i16 65535, i16 undef, i16 undef, i16 43690>
}

; CHECK-LABEL: v4i16_const_init_31:
; CHECK:      # %bb.0:
; CHECK-NEXT: add $m0, $m15, -1
; CHECK-NEXT: mov $m1, $m0
; CHECK:      br $m10
define <4 x i16> @v4i16_const_init_31() {
	  ret <4 x i16> <i16 65535, i16 undef, i16 65535, i16 undef>
}

; CHECK-LABEL: v4i16_const_init_32:
; CHECK:      # %bb.0:
; CHECK-NEXT: add $m0, $m15, -1
; CHECK-NEXT: mov $m1, $m0
; CHECK:      br $m10
define <4 x i16> @v4i16_const_init_32() {
	  ret <4 x i16> <i16 65535, i16 undef, i16 65535, i16 65535>
}

; CHECK-LABEL: v4i16_const_init_33:
; CHECK:      # %bb.0:
; CHECK-NEXT: add $m0, $m15, -1
; CHECK-NEXT: setzi [[SETREG:\$m[0-6]]], 720895
; CHECK-NEXT: or $m1, [[SETREG]], 2862612480
; CHECK:      br $m10
define <4 x i16> @v4i16_const_init_33() {
	  ret <4 x i16> <i16 65535, i16 undef, i16 65535, i16 43690>
}

; CHECK-LABEL: v4i16_const_init_34:
; CHECK:      # %bb.0:
; CHECK-NEXT: add $m0, $m15, -1
; CHECK-NEXT: setzi $m1, 43690
; CHECK:      br $m10
define <4 x i16> @v4i16_const_init_34() {
	  ret <4 x i16> <i16 65535, i16 undef, i16 43690, i16 undef>
}

; CHECK-LABEL: v4i16_const_init_35:
; CHECK:      # %bb.0:
; CHECK-NEXT: add $m0, $m15, -1
; CHECK-NEXT: add $m1, $m15, -21846
; CHECK:      br $m10
define <4 x i16> @v4i16_const_init_35() {
	  ret <4 x i16> <i16 65535, i16 undef, i16 43690, i16 65535>
}

; CHECK-LABEL: v4i16_const_init_36:
; CHECK:      # %bb.0:
; CHECK-NEXT: add $m0, $m15, -1
; CHECK-NEXT: setzi [[SETREG:\$m[0-6]]], 699050
; CHECK-NEXT: or $m1, [[SETREG]], 2862612480
; CHECK:      br $m10
define <4 x i16> @v4i16_const_init_36() {
	  ret <4 x i16> <i16 65535, i16 undef, i16 43690, i16 43690>
}

; CHECK-LABEL: v4i16_const_init_37:
; CHECK:      # %bb.0:
; CHECK-NEXT: add $m0, $m15, -1
; CHECK:      br $m10
define <4 x i16> @v4i16_const_init_37() {
	  ret <4 x i16> <i16 65535, i16 65535, i16 undef, i16 undef>
}

; CHECK-LABEL: v4i16_const_init_38:
; CHECK:      # %bb.0:
; CHECK-NEXT: add $m0, $m15, -1
; CHECK-NEXT: mov $m1, $m0
; CHECK:      br $m10
define <4 x i16> @v4i16_const_init_38() {
	  ret <4 x i16> <i16 65535, i16 65535, i16 undef, i16 65535>
}

; CHECK-LABEL: v4i16_const_init_39:
; CHECK:      # %bb.0:
; CHECK-NEXT: add $m0, $m15, -1
; CHECK-NEXT: setzi [[SETREG:\$m[0-6]]], 655360
; CHECK-NEXT: or $m1, [[SETREG]], 2862612480
; CHECK:      br $m10
define <4 x i16> @v4i16_const_init_39() {
	  ret <4 x i16> <i16 65535, i16 65535, i16 undef, i16 43690>
}

; CHECK-LABEL: v4i16_const_init_40:
; CHECK:      # %bb.0:
; CHECK-NEXT: add $m0, $m15, -1
; CHECK-NEXT: mov $m1, $m0
; CHECK:      br $m10
define <4 x i16> @v4i16_const_init_40() {
	  ret <4 x i16> <i16 65535, i16 65535, i16 65535, i16 undef>
}

; CHECK-LABEL: v4i16_const_init_41:
; CHECK:      # %bb.0:
; CHECK-NEXT: add $m0, $m15, -1
; CHECK-NEXT: mov $m1, $m0
; CHECK:      br $m10
define <4 x i16> @v4i16_const_init_41() {
	  ret <4 x i16> <i16 65535, i16 65535, i16 65535, i16 65535>
}

; CHECK-LABEL: v4i16_const_init_42:
; CHECK:      # %bb.0:
; CHECK-NEXT: add $m0, $m15, -1
; CHECK-NEXT: setzi [[SETREG:\$m[0-6]]], 720895
; CHECK-NEXT: or $m1, [[SETREG]], 2862612480
; CHECK:      br $m10
define <4 x i16> @v4i16_const_init_42() {
	  ret <4 x i16> <i16 65535, i16 65535, i16 65535, i16 43690>
}

; CHECK-LABEL: v4i16_const_init_43:
; CHECK:      # %bb.0:
; CHECK-NEXT: add $m0, $m15, -1
; CHECK-NEXT: setzi $m1, 43690
; CHECK:      br $m10
define <4 x i16> @v4i16_const_init_43() {
	  ret <4 x i16> <i16 65535, i16 65535, i16 43690, i16 undef>
}

; CHECK-LABEL: v4i16_const_init_44:
; CHECK:      # %bb.0:
; CHECK-NEXT: add $m0, $m15, -1
; CHECK-NEXT: add $m1, $m15, -21846
; CHECK:      br $m10
define <4 x i16> @v4i16_const_init_44() {
	  ret <4 x i16> <i16 65535, i16 65535, i16 43690, i16 65535>
}

; CHECK-LABEL: v4i16_const_init_45:
; CHECK:      # %bb.0:
; CHECK-NEXT: add $m0, $m15, -1
; CHECK-NEXT: setzi [[SETREG:\$m[0-6]]], 699050
; CHECK-NEXT: or $m1, [[SETREG]], 2862612480
; CHECK:      br $m10
define <4 x i16> @v4i16_const_init_45() {
	  ret <4 x i16> <i16 65535, i16 65535, i16 43690, i16 43690>
}

; CHECK-LABEL: v4i16_const_init_46:
; CHECK:      # %bb.0:
; CHECK-NEXT: setzi [[SETREG:\$m[0-6]]], 720895
; CHECK-NEXT: or $m0, [[SETREG]], 2862612480
; CHECK:      br $m10
define <4 x i16> @v4i16_const_init_46() {
	  ret <4 x i16> <i16 65535, i16 43690, i16 undef, i16 undef>
}

; CHECK-LABEL: v4i16_const_init_47:
; CHECK:      # %bb.0:
; CHECK-NEXT: setzi [[SETREG:\$m[0-6]]], 720895
; CHECK-NEXT: or $m0, [[SETREG]], 2862612480
; CHECK-NEXT: add $m1, $m15, -1
; CHECK:      br $m10
define <4 x i16> @v4i16_const_init_47() {
	  ret <4 x i16> <i16 65535, i16 43690, i16 undef, i16 65535>
}

; CHECK-LABEL: v4i16_const_init_48:
; CHECK:      # %bb.0:
; CHECK-NEXT: setzi [[SETREG:\$m[0-6]]], 720895
; CHECK-NEXT: or $m0, [[SETREG]], 2862612480
; CHECK-NEXT: setzi [[SETREG:\$m[0-6]]], 655360
; CHECK-NEXT: or $m1, [[SETREG]], 2862612480
; CHECK:      br $m10
define <4 x i16> @v4i16_const_init_48() {
	  ret <4 x i16> <i16 65535, i16 43690, i16 undef, i16 43690>
}

; CHECK-LABEL: v4i16_const_init_49:
; CHECK:      # %bb.0:
; CHECK-NEXT: setzi [[SETREG:\$m[0-6]]], 720895
; CHECK-NEXT: or $m0, [[SETREG]], 2862612480
; CHECK-NEXT: add $m1, $m15, -1
; CHECK:      br $m10
define <4 x i16> @v4i16_const_init_49() {
	  ret <4 x i16> <i16 65535, i16 43690, i16 65535, i16 undef>
}

; CHECK-LABEL: v4i16_const_init_50:
; CHECK:      # %bb.0:
; CHECK-NEXT: setzi [[SETREG:\$m[0-6]]], 720895
; CHECK-NEXT: or $m0, [[SETREG]], 2862612480
; CHECK-NEXT: add $m1, $m15, -1
; CHECK:      br $m10
define <4 x i16> @v4i16_const_init_50() {
	  ret <4 x i16> <i16 65535, i16 43690, i16 65535, i16 65535>
}

; CHECK-LABEL: v4i16_const_init_51:
; CHECK:      # %bb.0:
; CHECK-NEXT: setzi [[SETREG:\$m[0-6]]], 720895
; CHECK-NEXT: or $m0, [[SETREG]], 2862612480
; CHECK-NEXT: mov $m1, $m0
; CHECK:      br $m10
define <4 x i16> @v4i16_const_init_51() {
	  ret <4 x i16> <i16 65535, i16 43690, i16 65535, i16 43690>
}

; CHECK-LABEL: v4i16_const_init_52:
; CHECK:      # %bb.0:
; CHECK-NEXT: setzi [[SETREG:\$m[0-6]]], 720895
; CHECK-NEXT: or $m0, [[SETREG]], 2862612480
; CHECK-NEXT: setzi $m1, 43690
; CHECK:      br $m10
define <4 x i16> @v4i16_const_init_52() {
	  ret <4 x i16> <i16 65535, i16 43690, i16 43690, i16 undef>
}

; CHECK-LABEL: v4i16_const_init_53:
; CHECK:      # %bb.0:
; CHECK-NEXT: setzi [[SETREG:\$m[0-6]]], 720895
; CHECK-NEXT: or $m0, [[SETREG]], 2862612480
; CHECK-NEXT: add $m1, $m15, -21846
; CHECK:      br $m10
define <4 x i16> @v4i16_const_init_53() {
	  ret <4 x i16> <i16 65535, i16 43690, i16 43690, i16 65535>
}

; CHECK-LABEL: v4i16_const_init_54:
; CHECK:      # %bb.0:
; CHECK-NEXT: setzi [[SETREG:\$m[0-6]]], 720895
; CHECK-NEXT: or $m0, [[SETREG]], 2862612480
; CHECK-NEXT: setzi [[SETREG:\$m[0-6]]], 699050
; CHECK-NEXT: or $m1, [[SETREG]], 2862612480
; CHECK:      br $m10
define <4 x i16> @v4i16_const_init_54() {
	  ret <4 x i16> <i16 65535, i16 43690, i16 43690, i16 43690>
}

; CHECK-LABEL: v4i16_const_init_55:
; CHECK:      # %bb.0:
; CHECK-NEXT: setzi $m0, 43690
; CHECK:      br $m10
define <4 x i16> @v4i16_const_init_55() {
	  ret <4 x i16> <i16 43690, i16 undef, i16 undef, i16 undef>
}

; CHECK-LABEL: v4i16_const_init_56:
; CHECK:      # %bb.0:
; CHECK-NEXT: setzi $m0, 43690
; CHECK-NEXT: add $m1, $m15, -1
; CHECK:      br $m10
define <4 x i16> @v4i16_const_init_56() {
	  ret <4 x i16> <i16 43690, i16 undef, i16 undef, i16 65535>
}

; CHECK-LABEL: v4i16_const_init_57:
; CHECK:      # %bb.0:
; CHECK-NEXT: setzi $m0, 43690
; CHECK-NEXT: setzi [[SETREG:\$m[0-6]]], 655360
; CHECK-NEXT: or $m1, [[SETREG]], 2862612480
; CHECK:      br $m10
define <4 x i16> @v4i16_const_init_57() {
	  ret <4 x i16> <i16 43690, i16 undef, i16 undef, i16 43690>
}

; CHECK-LABEL: v4i16_const_init_58:
; CHECK:      # %bb.0:
; CHECK-NEXT: setzi $m0, 43690
; CHECK-NEXT: add $m1, $m15, -1
; CHECK:      br $m10
define <4 x i16> @v4i16_const_init_58() {
	  ret <4 x i16> <i16 43690, i16 undef, i16 65535, i16 undef>
}

; CHECK-LABEL: v4i16_const_init_59:
; CHECK:      # %bb.0:
; CHECK-NEXT: setzi $m0, 43690
; CHECK-NEXT: add $m1, $m15, -1
; CHECK:      br $m10
define <4 x i16> @v4i16_const_init_59() {
	  ret <4 x i16> <i16 43690, i16 undef, i16 65535, i16 65535>
}

; CHECK-LABEL: v4i16_const_init_60:
; CHECK:      # %bb.0:
; CHECK-NEXT: setzi $m0, 43690
; CHECK-NEXT: setzi [[SETREG:\$m[0-6]]], 720895
; CHECK-NEXT: or $m1, [[SETREG]], 2862612480
; CHECK:      br $m10
define <4 x i16> @v4i16_const_init_60() {
	  ret <4 x i16> <i16 43690, i16 undef, i16 65535, i16 43690>
}

; CHECK-LABEL: v4i16_const_init_61:
; CHECK:      # %bb.0:
; CHECK-NEXT: setzi $m0, 43690
; CHECK-NEXT: mov $m1, $m0
; CHECK:      br $m10
define <4 x i16> @v4i16_const_init_61() {
	  ret <4 x i16> <i16 43690, i16 undef, i16 43690, i16 undef>
}

; CHECK-LABEL: v4i16_const_init_62:
; CHECK:      # %bb.0:
; CHECK-NEXT: setzi $m0, 43690
; CHECK-NEXT: add $m1, $m15, -21846
; CHECK:      br $m10
define <4 x i16> @v4i16_const_init_62() {
	  ret <4 x i16> <i16 43690, i16 undef, i16 43690, i16 65535>
}

; CHECK-LABEL: v4i16_const_init_63:
; CHECK:      # %bb.0:
; CHECK-NEXT: setzi $m0, 43690
; CHECK-NEXT: setzi [[SETREG:\$m[0-6]]], 699050
; CHECK-NEXT: or $m1, [[SETREG]], 2862612480
; CHECK:      br $m10
define <4 x i16> @v4i16_const_init_63() {
	  ret <4 x i16> <i16 43690, i16 undef, i16 43690, i16 43690>
}

; CHECK-LABEL: v4i16_const_init_64:
; CHECK:      # %bb.0:
; CHECK-NEXT: add $m0, $m15, -21846
; CHECK:      br $m10
define <4 x i16> @v4i16_const_init_64() {
	  ret <4 x i16> <i16 43690, i16 65535, i16 undef, i16 undef>
}

; CHECK-LABEL: v4i16_const_init_65:
; CHECK:      # %bb.0:
; CHECK-NEXT: add $m0, $m15, -21846
; CHECK-NEXT: add $m1, $m15, -1
; CHECK:      br $m10
define <4 x i16> @v4i16_const_init_65() {
	  ret <4 x i16> <i16 43690, i16 65535, i16 undef, i16 65535>
}

; CHECK-LABEL: v4i16_const_init_66:
; CHECK:      # %bb.0:
; CHECK-NEXT: add $m0, $m15, -21846
; CHECK-NEXT: setzi [[SETREG:\$m[0-6]]], 655360
; CHECK-NEXT: or $m1, [[SETREG]], 2862612480
; CHECK:      br $m10
define <4 x i16> @v4i16_const_init_66() {
	  ret <4 x i16> <i16 43690, i16 65535, i16 undef, i16 43690>
}

; CHECK-LABEL: v4i16_const_init_67:
; CHECK:      # %bb.0:
; CHECK-NEXT: add $m0, $m15, -21846
; CHECK-NEXT: add $m1, $m15, -1
; CHECK:      br $m10
define <4 x i16> @v4i16_const_init_67() {
	  ret <4 x i16> <i16 43690, i16 65535, i16 65535, i16 undef>
}

; CHECK-LABEL: v4i16_const_init_68:
; CHECK:      # %bb.0:
; CHECK-NEXT: add $m0, $m15, -21846
; CHECK-NEXT: add $m1, $m15, -1
; CHECK:      br $m10
define <4 x i16> @v4i16_const_init_68() {
	  ret <4 x i16> <i16 43690, i16 65535, i16 65535, i16 65535>
}

; CHECK-LABEL: v4i16_const_init_69:
; CHECK:      # %bb.0:
; CHECK-NEXT: add $m0, $m15, -21846
; CHECK-NEXT: setzi [[SETREG:\$m[0-6]]], 720895
; CHECK-NEXT: or $m1, [[SETREG]], 2862612480
; CHECK:      br $m10
define <4 x i16> @v4i16_const_init_69() {
	  ret <4 x i16> <i16 43690, i16 65535, i16 65535, i16 43690>
}

; CHECK-LABEL: v4i16_const_init_70:
; CHECK:      # %bb.0:
; CHECK-NEXT: add $m0, $m15, -21846
; CHECK-NEXT: setzi $m1, 43690
; CHECK:      br $m10
define <4 x i16> @v4i16_const_init_70() {
	  ret <4 x i16> <i16 43690, i16 65535, i16 43690, i16 undef>
}

; CHECK-LABEL: v4i16_const_init_71:
; CHECK:      # %bb.0:
; CHECK-NEXT: add $m0, $m15, -21846
; CHECK-NEXT: mov $m1, $m0
; CHECK:      br $m10
define <4 x i16> @v4i16_const_init_71() {
	  ret <4 x i16> <i16 43690, i16 65535, i16 43690, i16 65535>
}

; CHECK-LABEL: v4i16_const_init_72:
; CHECK:      # %bb.0:
; CHECK-NEXT: add $m0, $m15, -21846
; CHECK-NEXT: setzi [[SETREG:\$m[0-6]]], 699050
; CHECK-NEXT: or $m1, [[SETREG]], 2862612480
; CHECK:      br $m10
define <4 x i16> @v4i16_const_init_72() {
	  ret <4 x i16> <i16 43690, i16 65535, i16 43690, i16 43690>
}

; CHECK-LABEL: v4i16_const_init_73:
; CHECK:      # %bb.0:
; CHECK-NEXT: setzi [[SETREG:\$m[0-6]]], 699050
; CHECK-NEXT: or $m0, [[SETREG]], 2862612480
; CHECK:      br $m10
define <4 x i16> @v4i16_const_init_73() {
	  ret <4 x i16> <i16 43690, i16 43690, i16 undef, i16 undef>
}

; CHECK-LABEL: v4i16_const_init_74:
; CHECK:      # %bb.0:
; CHECK-NEXT: setzi [[SETREG:\$m[0-6]]], 699050
; CHECK-NEXT: or $m0, [[SETREG]], 2862612480
; CHECK-NEXT: add $m1, $m15, -1
; CHECK:      br $m10
define <4 x i16> @v4i16_const_init_74() {
	  ret <4 x i16> <i16 43690, i16 43690, i16 undef, i16 65535>
}

; CHECK-LABEL: v4i16_const_init_75:
; CHECK:      # %bb.0:
; CHECK-NEXT: setzi [[SETREG:\$m[0-6]]], 699050
; CHECK-NEXT: or $m0, [[SETREG]], 2862612480
; CHECK-NEXT: setzi [[SETREG:\$m[0-6]]], 655360
; CHECK-NEXT: or $m1, [[SETREG]], 2862612480
; CHECK:      br $m10
define <4 x i16> @v4i16_const_init_75() {
	  ret <4 x i16> <i16 43690, i16 43690, i16 undef, i16 43690>
}

; CHECK-LABEL: v4i16_const_init_76:
; CHECK:      # %bb.0:
; CHECK-NEXT: setzi [[SETREG:\$m[0-6]]], 699050
; CHECK-NEXT: or $m0, [[SETREG]], 2862612480
; CHECK-NEXT: add $m1, $m15, -1
; CHECK:      br $m10
define <4 x i16> @v4i16_const_init_76() {
	  ret <4 x i16> <i16 43690, i16 43690, i16 65535, i16 undef>
}

; CHECK-LABEL: v4i16_const_init_77:
; CHECK:      # %bb.0:
; CHECK-NEXT: setzi [[SETREG:\$m[0-6]]], 699050
; CHECK-NEXT: or $m0, [[SETREG]], 2862612480
; CHECK-NEXT: add $m1, $m15, -1
; CHECK:      br $m10
define <4 x i16> @v4i16_const_init_77() {
	  ret <4 x i16> <i16 43690, i16 43690, i16 65535, i16 65535>
}

; CHECK-LABEL: v4i16_const_init_78:
; CHECK:      # %bb.0:
; CHECK-NEXT: setzi [[SETREG:\$m[0-6]]], 699050
; CHECK-NEXT: or $m0, [[SETREG]], 2862612480
; CHECK-NEXT: setzi [[SETREG:\$m[0-6]]], 720895
; CHECK-NEXT: or $m1, [[SETREG]], 2862612480
; CHECK:      br $m10
define <4 x i16> @v4i16_const_init_78() {
	  ret <4 x i16> <i16 43690, i16 43690, i16 65535, i16 43690>
}

; CHECK-LABEL: v4i16_const_init_79:
; CHECK:      # %bb.0:
; CHECK-NEXT: setzi [[SETREG:\$m[0-6]]], 699050
; CHECK-NEXT: or $m0, [[SETREG]], 2862612480
; CHECK-NEXT: setzi $m1, 43690
; CHECK:      br $m10
define <4 x i16> @v4i16_const_init_79() {
	  ret <4 x i16> <i16 43690, i16 43690, i16 43690, i16 undef>
}

; CHECK-LABEL: v4i16_const_init_80:
; CHECK:      # %bb.0:
; CHECK-NEXT: setzi [[SETREG:\$m[0-6]]], 699050
; CHECK-NEXT: or $m0, [[SETREG]], 2862612480
; CHECK-NEXT: add $m1, $m15, -21846
; CHECK:      br $m10
define <4 x i16> @v4i16_const_init_80() {
	  ret <4 x i16> <i16 43690, i16 43690, i16 43690, i16 65535>
}

; CHECK-LABEL: v4i16_const_init_81:
; CHECK:      # %bb.0:
; CHECK-NEXT: setzi [[SETREG:\$m[0-6]]], 699050
; CHECK-NEXT: or $m0, [[SETREG]], 2862612480
; CHECK-NEXT: mov $m1, $m0
; CHECK:      br $m10
define <4 x i16> @v4i16_const_init_81() {
	  ret <4 x i16> <i16 43690, i16 43690, i16 43690, i16 43690>
}
