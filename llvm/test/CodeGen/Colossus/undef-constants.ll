; RUN: llc < %s -march=colossus -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -march=colossus -mattr=+ipu2 | FileCheck %s

;===------------------------------------------------------------------------===;
; <2 x i16>
;===------------------------------------------------------------------------===;

; CHECK-LABEL: zeros_undef_v2i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m15
; CHECK-NEXT:  br $m10
define <2 x i16> @zeros_undef_v2i16() {
  ret <2 x i16> <i16 0, i16 undef>
}

; CHECK-LABEL: undef_zeros_v2i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m15
; CHECK-NEXT:  br $m10
define <2 x i16> @undef_zeros_v2i16() {
  ret <2 x i16> <i16 undef, i16 0>
}

; CHECK-LABEL: ones_undef_v2i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  add $m0, $m15, -1
; CHECK-NEXT:  br $m10
define <2 x i16> @ones_undef_v2i16() {
  ret <2 x i16> <i16 65535, i16 undef>
}

; CHECK-LABEL: undef_ones_v2i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  add $m0, $m15, -1
; CHECK-NEXT:  br $m10
define <2 x i16> @undef_ones_v2i16() {
  ret <2 x i16> <i16 undef, i16 65535>
}

;===------------------------------------------------------------------------===;
; <2 x i32>
;===------------------------------------------------------------------------===;

; CHECK-LABEL: undef_zeros_v2i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m15
; CHECK-NEXT:  mov $m1, $m15
; CHECK-NEXT:  br $m10
define <2 x i32> @undef_zeros_v2i32() {
  ret <2 x i32> <i32 undef, i32 0>
}

; CHECK-LABEL: zeros_undef_v2i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m15
; CHECK-NEXT:  mov $m1, $m15
; CHECK-NEXT:  br $m10
define <2 x i32> @zeros_undef_v2i32() {
  ret <2 x i32> <i32 0, i32 undef>
}

; CHECK-LABEL: undef_ones_v2i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  add $m0, $m15, -1
; CHECK-NEXT:  mov $m1, $m0
; CHECK-NEXT:  br $m10
define <2 x i32> @undef_ones_v2i32() {
  ret <2 x i32> <i32 undef, i32 4294967295>
}

; CHECK-LABEL: ones_undef_v2i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  add $m0, $m15, -1
; CHECK-NEXT:  mov $m1, $m0
; CHECK-NEXT:  br $m10
define <2 x i32> @ones_undef_v2i32() {
  ret <2 x i32> <i32 4294967295, i32 undef>
}

; CHECK-LABEL: undef_imm1_v2i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m15
; CHECK-NEXT:  setzi $m1, 172048
; CHECK-NEXT:  or $m1, $m1, 1017118720
; CHECK-NEXT:  br $m10
define <2 x i32> @undef_imm1_v2i32() {
  ret <2 x i32> <i32 undef, i32 1017290768>
}

; CHECK-LABEL: imm1_undef_v2i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  setzi $m0, 172048
; CHECK-NEXT:  or $m0, $m0, 1017118720
; CHECK-NEXT:  mov $m1, $m15
; CHECK-NEXT:  br $m10
define <2 x i32> @imm1_undef_v2i32() {
  ret <2 x i32> <i32 1017290768, i32 undef>
}

; CHECK-LABEL: undef_imm2_v2i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m15
; CHECK-NEXT:  add $m1, $m15, -3
; CHECK-NEXT:  br $m10
define <2 x i32> @undef_imm2_v2i32() {
  ret <2 x i32> <i32 undef, i32 4294967293>
}

; CHECK-LABEL: imm2_undef_v2i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  add $m0, $m15, -3
; CHECK-NEXT:  mov $m1, $m15
; CHECK-NEXT:  br $m10
define <2 x i32> @imm2_undef_v2i32() {
  ret <2 x i32> <i32 4294967293, i32 undef>
}

; CHECK-LABEL: undef_imm3_v2i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m15
; CHECK-NEXT:  setzi $m1, 1048575
; CHECK-NEXT:  br $m10
define <2 x i32> @undef_imm3_v2i32() {
  ret <2 x i32> <i32 undef, i32 1048575>
}

; CHECK-LABEL: imm3_undef_v2i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  setzi $m0, 1048575
; CHECK-NEXT:  mov $m1, $m15
; CHECK-NEXT:  br $m10
define <2 x i32> @imm3_undef_v2i32() {
  ret <2 x i32> <i32 1048575, i32 undef>
}

; CHECK-LABEL: undef_imm4_v2i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m15
; CHECK-NEXT:  setzi $m1, 1048575
; CHECK-NEXT:  or $m1, $m1, 1048576
; CHECK-NEXT:  br $m10
define <2 x i32> @undef_imm4_v2i32() {
  ret <2 x i32> <i32 undef, i32 2097151>
}

; CHECK-LABEL: imm4_undef_v2i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  setzi $m0, 1048575
; CHECK-NEXT:  or $m0, $m0, 1048576
; CHECK-NEXT:  mov $m1, $m15
; CHECK-NEXT:  br $m10
define <2 x i32> @imm4_undef_v2i32() {
  ret <2 x i32> <i32 2097151, i32 undef>
}

; CHECK-LABEL: undef_imm5_v2i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m15
; CHECK-NEXT:  or $m1, $m15, 4293918720
; CHECK-NEXT:  br $m10
define <2 x i32> @undef_imm5_v2i32() {
  ret <2 x i32> <i32 undef, i32 4293918720>
}

; CHECK-LABEL: imm5_undef_v2i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  or $m0, $m15, 4293918720
; CHECK-NEXT:  mov $m1, $m15
; CHECK-NEXT:  br $m10
define <2 x i32> @imm5_undef_v2i32() {
  ret <2 x i32> <i32 4293918720, i32 undef>
}

; CHECK-LABEL: undef_imm6_v2i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m15
; CHECK-NEXT:  setzi $m1, 65536
; CHECK-NEXT:  or $m1, $m1, 4293918720
; CHECK-NEXT:  br $m10
define <2 x i32> @undef_imm6_v2i32() {
  ret <2 x i32> <i32 undef, i32 4293984256>
}

; CHECK-LABEL: imm6_undef_v2i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  setzi $m0, 65536
; CHECK-NEXT:  or $m0, $m0, 4293918720
; CHECK-NEXT:  mov $m1, $m15
; CHECK-NEXT:  br $m10
define <2 x i32> @imm6_undef_v2i32() {
  ret <2 x i32> <i32 4293984256, i32 undef>
}

;===------------------------------------------------------------------------===;
; <2 x half>
;===------------------------------------------------------------------------===;

; CHECK-LABEL: zeros_undef_v2f16:
; CHECK:       # %bb.0:
; CHECK:       mov  $a0, $a15
define <2 x half> @zeros_undef_v2f16() {
  ret <2 x half> <half 0xH0, half undef>
}

; CHECK-LABEL: undef_zeros_v2f16:
; CHECK:       # %bb.0:
; CHECK:       mov  $a0, $a15
define <2 x half> @undef_zeros_v2f16() {
  ret <2 x half> <half undef, half 0xH0>
}

; CHECK-LABEL: ones_undef_v2f16:
; CHECK:       # %bb.0:
; CHECK:       not $a0, $a15
define <2 x half> @ones_undef_v2f16() {
  ret <2 x half> <half 0xHFFFF, half undef>
}

; CHECK-LABEL: undef_ones_v2f16:
; CHECK:       # %bb.0:
; CHECK:       not $a0, $a15
define <2 x half> @undef_ones_v2f16() {
  ret <2 x half> <half undef, half 0xHFFFF>
}
