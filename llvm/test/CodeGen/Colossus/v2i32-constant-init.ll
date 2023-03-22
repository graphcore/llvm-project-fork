; RUN: llc -march=colossus -colossus-coissue=false %s -mattr=+ipu1 -o - | FileCheck %s
; RUN: llc -march=colossus -colossus-coissue=false %s -mattr=+ipu2 -o - | FileCheck %s

; CHECK-LABEL: v2i32_const_init_1:
; CHECK:      # %bb.0:
; CHECK:      br $m10
define <2 x i32> @v2i32_const_init_1() {
	  ret <2 x i32> <i32 undef, i32 undef>
}

; CHECK-LABEL: v2i32_const_init_2:
; CHECK:      # %bb.0:
; CHECK-NEXT: add $m0, $m15, -1
; CHECK-NEXT: mov $m1, $m0
; CHECK:      br $m10
define <2 x i32> @v2i32_const_init_2() {
	  ret <2 x i32> <i32 undef, i32 4294967295>
}

; CHECK-LABEL: v2i32_const_init_3:
; CHECK:      # %bb.0:
; CHECK-NEXT: mov $m0, $m15
; CHECK-NEXT: setzi [[SETREG:\$m[0-6]]], 699050
; CHECK-NEXT: or $m1, [[SETREG]], 2862612480
; CHECK:      br $m10
define <2 x i32> @v2i32_const_init_3() {
	  ret <2 x i32> <i32 undef, i32 2863311530>
}

; CHECK-LABEL: v2i32_const_init_4:
; CHECK:      # %bb.0:
; CHECK-NEXT: add $m0, $m15, -1
; CHECK-NEXT: mov $m1, $m0
; CHECK:      br $m10
define <2 x i32> @v2i32_const_init_4() {
	  ret <2 x i32> <i32 4294967295, i32 undef>
}

; CHECK-LABEL: v2i32_const_init_5:
; CHECK:      # %bb.0:
; CHECK-NEXT: add $m0, $m15, -1
; CHECK-NEXT: mov $m1, $m0
; CHECK:      br $m10
define <2 x i32> @v2i32_const_init_5() {
	  ret <2 x i32> <i32 4294967295, i32 4294967295>
}

; CHECK-LABEL: v2i32_const_init_6:
; CHECK:      # %bb.0:
; CHECK-NEXT: add $m0, $m15, -1
; CHECK-NEXT: setzi [[SETREG:\$m[0-6]]], 699050
; CHECK-NEXT: or $m1, [[SETREG]], 2862612480
; CHECK:      br $m10
define <2 x i32> @v2i32_const_init_6() {
	  ret <2 x i32> <i32 4294967295, i32 2863311530>
}

; CHECK-LABEL: v2i32_const_init_7:
; CHECK:      # %bb.0:
; CHECK-NEXT: setzi [[SETREG:\$m[0-6]]], 699050
; CHECK-NEXT: or $m0, [[SETREG]], 2862612480
; CHECK-NEXT: mov $m1, $m15
; CHECK:      br $m10
define <2 x i32> @v2i32_const_init_7() {
	  ret <2 x i32> <i32 2863311530, i32 undef>
}

; CHECK-LABEL: v2i32_const_init_8:
; CHECK:      # %bb.0:
; CHECK-NEXT: setzi [[SETREG:\$m[0-6]]], 699050
; CHECK-NEXT: or $m0, [[SETREG]], 2862612480
; CHECK-NEXT: add $m1, $m15, -1
; CHECK:      br $m10
define <2 x i32> @v2i32_const_init_8() {
	  ret <2 x i32> <i32 2863311530, i32 4294967295>
}

; CHECK-LABEL: v2i32_const_init_9:
; CHECK:      # %bb.0:
; CHECK-NEXT: setzi [[SETREG:\$m[0-6]]], 699050
; CHECK-NEXT: or $m0, [[SETREG]], 2862612480
; CHECK-NEXT: mov $m1, $m0
; CHECK:      br $m10
define <2 x i32> @v2i32_const_init_9() {
	  ret <2 x i32> <i32 2863311530, i32 2863311530>
}
