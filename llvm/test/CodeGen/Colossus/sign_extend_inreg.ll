; RUN: llc < %s -march=colossus -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -march=colossus -mattr=+ipu2 | FileCheck %s
target triple = "colossus-graphcore--elf"

; CHECK-LABEL: signext_inreg1_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shl $m0, $m0, 31
; CHECK-NEXT:  shrs $m0, $m0, 31
; CHECK-NEXT:  br $m10
define i32 @signext_inreg1_i32(i32 %x) {
  %t = trunc i32 %x to i1
  %s = sext i1 %t to i32
  ret i32 %s
}

; CHECK-LABEL: signext_inreg2_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shl $m0, $m0, 30
; CHECK-NEXT:  shrs $m0, $m0, 30
; CHECK-NEXT:  br $m10
define i32 @signext_inreg2_i32(i32 %x) {
  %t = trunc i32 %x to i2
  %s = sext i2 %t to i32
  ret i32 %s
}

; CHECK-LABEL: signext_inreg3_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shl $m0, $m0, 29
; CHECK-NEXT:  shrs $m0, $m0, 29
; CHECK-NEXT:  br $m10
define i32 @signext_inreg3_i32(i32 %x) {
  %t = trunc i32 %x to i3
  %s = sext i3 %t to i32
  ret i32 %s
}

; CHECK-LABEL: signext_inreg4_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shl $m0, $m0, 28
; CHECK-NEXT:  shrs $m0, $m0, 28
; CHECK-NEXT:  br $m10
define i32 @signext_inreg4_i32(i32 %x) {
  %t = trunc i32 %x to i4
  %s = sext i4 %t to i32
  ret i32 %s
}

; CHECK-LABEL: signext_inreg5_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shl $m0, $m0, 27
; CHECK-NEXT:  shrs $m0, $m0, 27
; CHECK-NEXT:  br $m10
define i32 @signext_inreg5_i32(i32 %x) {
  %t = trunc i32 %x to i5
  %s = sext i5 %t to i32
  ret i32 %s
}

; CHECK-LABEL: signext_inreg6_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shl $m0, $m0, 26
; CHECK-NEXT:  shrs $m0, $m0, 26
; CHECK-NEXT:  br $m10
define i32 @signext_inreg6_i32(i32 %x) {
  %t = trunc i32 %x to i6
  %s = sext i6 %t to i32
  ret i32 %s
}

; CHECK-LABEL: signext_inreg7_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shl $m0, $m0, 25
; CHECK-NEXT:  shrs $m0, $m0, 25
; CHECK-NEXT:  br $m10
define i32 @signext_inreg7_i32(i32 %x) {
  %t = trunc i32 %x to i7
  %s = sext i7 %t to i32
  ret i32 %s
}

; CHECK-LABEL: signext_inreg8_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shl $m0, $m0, 24
; CHECK-NEXT:  shrs $m0, $m0, 24
; CHECK-NEXT:  br $m10
define i32 @signext_inreg8_i32(i32 %x) {
  %t = trunc i32 %x to i8
  %s = sext i8 %t to i32
  ret i32 %s
}

; CHECK-LABEL: signext_inreg9_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shl $m0, $m0, 23
; CHECK-NEXT:  shrs $m0, $m0, 23
; CHECK-NEXT:  br $m10
define i32 @signext_inreg9_i32(i32 %x) {
  %t = trunc i32 %x to i9
  %s = sext i9 %t to i32
  ret i32 %s
}

; CHECK-LABEL: signext_inreg10_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shl $m0, $m0, 22
; CHECK-NEXT:  shrs $m0, $m0, 22
; CHECK-NEXT:  br $m10
define i32 @signext_inreg10_i32(i32 %x) {
  %t = trunc i32 %x to i10
  %s = sext i10 %t to i32
  ret i32 %s
}

; CHECK-LABEL: signext_inreg11_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shl $m0, $m0, 21
; CHECK-NEXT:  shrs $m0, $m0, 21
; CHECK-NEXT:  br $m10
define i32 @signext_inreg11_i32(i32 %x) {
  %t = trunc i32 %x to i11
  %s = sext i11 %t to i32
  ret i32 %s
}

; CHECK-LABEL: signext_inreg12_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shl $m0, $m0, 20
; CHECK-NEXT:  shrs $m0, $m0, 20
; CHECK-NEXT:  br $m10
define i32 @signext_inreg12_i32(i32 %x) {
  %t = trunc i32 %x to i12
  %s = sext i12 %t to i32
  ret i32 %s
}

; CHECK-LABEL: signext_inreg13_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shl $m0, $m0, 19
; CHECK-NEXT:  shrs $m0, $m0, 19
; CHECK-NEXT:  br $m10
define i32 @signext_inreg13_i32(i32 %x) {
  %t = trunc i32 %x to i13
  %s = sext i13 %t to i32
  ret i32 %s
}

; CHECK-LABEL: signext_inreg14_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shl $m0, $m0, 18
; CHECK-NEXT:  shrs $m0, $m0, 18
; CHECK-NEXT:  br $m10
define i32 @signext_inreg14_i32(i32 %x) {
  %t = trunc i32 %x to i14
  %s = sext i14 %t to i32
  ret i32 %s
}

; CHECK-LABEL: signext_inreg15_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shl $m0, $m0, 17
; CHECK-NEXT:  shrs $m0, $m0, 17
; CHECK-NEXT:  br $m10
define i32 @signext_inreg15_i32(i32 %x) {
  %t = trunc i32 %x to i15
  %s = sext i15 %t to i32
  ret i32 %s
}

; CHECK-LABEL: signext_inreg16_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shl $m0, $m0, 16
; CHECK-NEXT:  shrs $m0, $m0, 16
; CHECK-NEXT:  br $m10
define i32 @signext_inreg16_i32(i32 %x) {
  %t = trunc i32 %x to i16
  %s = sext i16 %t to i32
  ret i32 %s
}

; CHECK-LABEL: signext_inreg17_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shl $m0, $m0, 15
; CHECK-NEXT:  shrs $m0, $m0, 15
; CHECK-NEXT:  br $m10
define i32 @signext_inreg17_i32(i32 %x) {
  %t = trunc i32 %x to i17
  %s = sext i17 %t to i32
  ret i32 %s
}

; CHECK-LABEL: signext_inreg18_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shl $m0, $m0, 14
; CHECK-NEXT:  shrs $m0, $m0, 14
; CHECK-NEXT:  br $m10
define i32 @signext_inreg18_i32(i32 %x) {
  %t = trunc i32 %x to i18
  %s = sext i18 %t to i32
  ret i32 %s
}

; CHECK-LABEL: signext_inreg19_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shl $m0, $m0, 13
; CHECK-NEXT:  shrs $m0, $m0, 13
; CHECK-NEXT:  br $m10
define i32 @signext_inreg19_i32(i32 %x) {
  %t = trunc i32 %x to i19
  %s = sext i19 %t to i32
  ret i32 %s
}

; CHECK-LABEL: signext_inreg20_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shl $m0, $m0, 12
; CHECK-NEXT:  shrs $m0, $m0, 12
; CHECK-NEXT:  br $m10
define i32 @signext_inreg20_i32(i32 %x) {
  %t = trunc i32 %x to i20
  %s = sext i20 %t to i32
  ret i32 %s
}

; CHECK-LABEL: signext_inreg21_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shl $m0, $m0, 11
; CHECK-NEXT:  shrs $m0, $m0, 11
; CHECK-NEXT:  br $m10
define i32 @signext_inreg21_i32(i32 %x) {
  %t = trunc i32 %x to i21
  %s = sext i21 %t to i32
  ret i32 %s
}

; CHECK-LABEL: signext_inreg22_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shl $m0, $m0, 10
; CHECK-NEXT:  shrs $m0, $m0, 10
; CHECK-NEXT:  br $m10
define i32 @signext_inreg22_i32(i32 %x) {
  %t = trunc i32 %x to i22
  %s = sext i22 %t to i32
  ret i32 %s
}

; CHECK-LABEL: signext_inreg23_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shl $m0, $m0, 9
; CHECK-NEXT:  shrs $m0, $m0, 9
; CHECK-NEXT:  br $m10
define i32 @signext_inreg23_i32(i32 %x) {
  %t = trunc i32 %x to i23
  %s = sext i23 %t to i32
  ret i32 %s
}

; CHECK-LABEL: signext_inreg24_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shl $m0, $m0, 8
; CHECK-NEXT:  shrs $m0, $m0, 8
; CHECK-NEXT:  br $m10
define i32 @signext_inreg24_i32(i32 %x) {
  %t = trunc i32 %x to i24
  %s = sext i24 %t to i32
  ret i32 %s
}

; CHECK-LABEL: signext_inreg25_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shl $m0, $m0, 7
; CHECK-NEXT:  shrs $m0, $m0, 7
; CHECK-NEXT:  br $m10
define i32 @signext_inreg25_i32(i32 %x) {
  %t = trunc i32 %x to i25
  %s = sext i25 %t to i32
  ret i32 %s
}

; CHECK-LABEL: signext_inreg26_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shl $m0, $m0, 6
; CHECK-NEXT:  shrs $m0, $m0, 6
; CHECK-NEXT:  br $m10
define i32 @signext_inreg26_i32(i32 %x) {
  %t = trunc i32 %x to i26
  %s = sext i26 %t to i32
  ret i32 %s
}

; CHECK-LABEL: signext_inreg27_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shl $m0, $m0, 5
; CHECK-NEXT:  shrs $m0, $m0, 5
; CHECK-NEXT:  br $m10
define i32 @signext_inreg27_i32(i32 %x) {
  %t = trunc i32 %x to i27
  %s = sext i27 %t to i32
  ret i32 %s
}

; CHECK-LABEL: signext_inreg28_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shl $m0, $m0, 4
; CHECK-NEXT:  shrs $m0, $m0, 4
; CHECK-NEXT:  br $m10
define i32 @signext_inreg28_i32(i32 %x) {
  %t = trunc i32 %x to i28
  %s = sext i28 %t to i32
  ret i32 %s
}

; CHECK-LABEL: signext_inreg29_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shl $m0, $m0, 3
; CHECK-NEXT:  shrs $m0, $m0, 3
; CHECK-NEXT:  br $m10
define i32 @signext_inreg29_i32(i32 %x) {
  %t = trunc i32 %x to i29
  %s = sext i29 %t to i32
  ret i32 %s
}

; CHECK-LABEL: signext_inreg30_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shl $m0, $m0, 2
; CHECK-NEXT:  shrs $m0, $m0, 2
; CHECK-NEXT:  br $m10
define i32 @signext_inreg30_i32(i32 %x) {
  %t = trunc i32 %x to i30
  %s = sext i30 %t to i32
  ret i32 %s
}

; CHECK-LABEL: signext_inreg31_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shl $m0, $m0, 1
; CHECK-NEXT:  shrs $m0, $m0, 1
; CHECK-NEXT:  br $m10
define i32 @signext_inreg31_i32(i32 %x) {
  %t = trunc i32 %x to i31
  %s = sext i31 %t to i32
  ret i32 %s
}

; CHECK-LABEL: signext_inreg1_v2i32:
; CHECK:       # %bb.0:
; CHECK-NEXT: shl [[REG0:\$m[0-9]+]], $m0, 31
; CHECK-NEXT: shrs $m0, [[REG0]], 31
; CHECK-NEXT: shl [[REG1:\$m[0-9]+]], $m1, 31
; CHECK-NEXT: shrs $m1, [[REG1]], 31
; CHECK-NEXT:  br $m10
define <2 x i32> @signext_inreg1_v2i32(<2 x i32> %x) {
  %t = trunc <2 x i32> %x to <2 x i1>
  %s = sext <2 x i1> %t to <2 x i32>
  ret <2 x i32> %s
}

; CHECK-LABEL: signext_inreg2_v2i32:
; CHECK:       # %bb.0:
; CHECK-NEXT: shl [[REG0:\$m[0-9]+]], $m0, 30
; CHECK-NEXT: shrs $m0, [[REG0]], 30
; CHECK-NEXT: shl [[REG1:\$m[0-9]+]], $m1, 30
; CHECK-NEXT: shrs $m1, [[REG1]], 30
; CHECK-NEXT:  br $m10
define <2 x i32> @signext_inreg2_v2i32(<2 x i32> %x) {
  %t = trunc <2 x i32> %x to <2 x i2>
  %s = sext <2 x i2> %t to <2 x i32>
  ret <2 x i32> %s
}

; CHECK-LABEL: signext_inreg3_v2i32:
; CHECK:       # %bb.0:
; CHECK-NEXT: shl [[REG0:\$m[0-9]+]], $m0, 29
; CHECK-NEXT: shrs $m0, [[REG0]], 29
; CHECK-NEXT: shl [[REG1:\$m[0-9]+]], $m1, 29
; CHECK-NEXT: shrs $m1, [[REG1]], 29
; CHECK-NEXT:  br $m10
define <2 x i32> @signext_inreg3_v2i32(<2 x i32> %x) {
  %t = trunc <2 x i32> %x to <2 x i3>
  %s = sext <2 x i3> %t to <2 x i32>
  ret <2 x i32> %s
}

; CHECK-LABEL: signext_inreg4_v2i32:
; CHECK:       # %bb.0:
; CHECK-NEXT: shl [[REG0:\$m[0-9]+]], $m0, 28
; CHECK-NEXT: shrs $m0, [[REG0]], 28
; CHECK-NEXT: shl [[REG1:\$m[0-9]+]], $m1, 28
; CHECK-NEXT: shrs $m1, [[REG1]], 28
; CHECK-NEXT:  br $m10
define <2 x i32> @signext_inreg4_v2i32(<2 x i32> %x) {
  %t = trunc <2 x i32> %x to <2 x i4>
  %s = sext <2 x i4> %t to <2 x i32>
  ret <2 x i32> %s
}

; CHECK-LABEL: signext_inreg5_v2i32:
; CHECK:       # %bb.0:
; CHECK-NEXT: shl [[REG0:\$m[0-9]+]], $m0, 27
; CHECK-NEXT: shrs $m0, [[REG0]], 27
; CHECK-NEXT: shl [[REG1:\$m[0-9]+]], $m1, 27
; CHECK-NEXT: shrs $m1, [[REG1]], 27
; CHECK-NEXT:  br $m10
define <2 x i32> @signext_inreg5_v2i32(<2 x i32> %x) {
  %t = trunc <2 x i32> %x to <2 x i5>
  %s = sext <2 x i5> %t to <2 x i32>
  ret <2 x i32> %s
}

; CHECK-LABEL: signext_inreg6_v2i32:
; CHECK:       # %bb.0:
; CHECK-NEXT: shl [[REG0:\$m[0-9]+]], $m0, 26
; CHECK-NEXT: shrs $m0, [[REG0]], 26
; CHECK-NEXT: shl [[REG1:\$m[0-9]+]], $m1, 26
; CHECK-NEXT: shrs $m1, [[REG1]], 26
; CHECK-NEXT:  br $m10
define <2 x i32> @signext_inreg6_v2i32(<2 x i32> %x) {
  %t = trunc <2 x i32> %x to <2 x i6>
  %s = sext <2 x i6> %t to <2 x i32>
  ret <2 x i32> %s
}

; CHECK-LABEL: signext_inreg7_v2i32:
; CHECK:       # %bb.0:
; CHECK-NEXT: shl [[REG0:\$m[0-9]+]], $m0, 25
; CHECK-NEXT: shrs $m0, [[REG0]], 25
; CHECK-NEXT: shl [[REG1:\$m[0-9]+]], $m1, 25
; CHECK-NEXT: shrs $m1, [[REG1]], 25
; CHECK-NEXT:  br $m10
define <2 x i32> @signext_inreg7_v2i32(<2 x i32> %x) {
  %t = trunc <2 x i32> %x to <2 x i7>
  %s = sext <2 x i7> %t to <2 x i32>
  ret <2 x i32> %s
}

; CHECK-LABEL: signext_inreg8_v2i32:
; CHECK:       # %bb.0:
; CHECK-NEXT: shl [[REG0:\$m[0-9]+]], $m0, 24
; CHECK-NEXT: shrs $m0, [[REG0]], 24
; CHECK-NEXT: shl [[REG1:\$m[0-9]+]], $m1, 24
; CHECK-NEXT: shrs $m1, [[REG1]], 24
; CHECK-NEXT:  br $m10
define <2 x i32> @signext_inreg8_v2i32(<2 x i32> %x) {
  %t = trunc <2 x i32> %x to <2 x i8>
  %s = sext <2 x i8> %t to <2 x i32>
  ret <2 x i32> %s
}

; CHECK-LABEL: signext_inreg9_v2i32:
; CHECK:       # %bb.0:
; CHECK-NEXT: shl [[REG0:\$m[0-9]+]], $m0, 23
; CHECK-NEXT: shrs $m0, [[REG0]], 23
; CHECK-NEXT: shl [[REG1:\$m[0-9]+]], $m1, 23
; CHECK-NEXT: shrs $m1, [[REG1]], 23
; CHECK-NEXT:  br $m10
define <2 x i32> @signext_inreg9_v2i32(<2 x i32> %x) {
  %t = trunc <2 x i32> %x to <2 x i9>
  %s = sext <2 x i9> %t to <2 x i32>
  ret <2 x i32> %s
}

; CHECK-LABEL: signext_inreg10_v2i32:
; CHECK:       # %bb.0:
; CHECK-NEXT: shl [[REG0:\$m[0-9]+]], $m0, 22
; CHECK-NEXT: shrs $m0, [[REG0]], 22
; CHECK-NEXT: shl [[REG1:\$m[0-9]+]], $m1, 22
; CHECK-NEXT: shrs $m1, [[REG1]], 22
; CHECK-NEXT:  br $m10
define <2 x i32> @signext_inreg10_v2i32(<2 x i32> %x) {
  %t = trunc <2 x i32> %x to <2 x i10>
  %s = sext <2 x i10> %t to <2 x i32>
  ret <2 x i32> %s
}

; CHECK-LABEL: signext_inreg11_v2i32:
; CHECK:       # %bb.0:
; CHECK-NEXT: shl [[REG0:\$m[0-9]+]], $m0, 21
; CHECK-NEXT: shrs $m0, [[REG0]], 21
; CHECK-NEXT: shl [[REG1:\$m[0-9]+]], $m1, 21
; CHECK-NEXT: shrs $m1, [[REG1]], 21
; CHECK-NEXT:  br $m10
define <2 x i32> @signext_inreg11_v2i32(<2 x i32> %x) {
  %t = trunc <2 x i32> %x to <2 x i11>
  %s = sext <2 x i11> %t to <2 x i32>
  ret <2 x i32> %s
}

; CHECK-LABEL: signext_inreg12_v2i32:
; CHECK:       # %bb.0:
; CHECK-NEXT: shl [[REG0:\$m[0-9]+]], $m0, 20
; CHECK-NEXT: shrs $m0, [[REG0]], 20
; CHECK-NEXT: shl [[REG1:\$m[0-9]+]], $m1, 20
; CHECK-NEXT: shrs $m1, [[REG1]], 20
; CHECK-NEXT:  br $m10
define <2 x i32> @signext_inreg12_v2i32(<2 x i32> %x) {
  %t = trunc <2 x i32> %x to <2 x i12>
  %s = sext <2 x i12> %t to <2 x i32>
  ret <2 x i32> %s
}

; CHECK-LABEL: signext_inreg13_v2i32:
; CHECK:       # %bb.0:
; CHECK-NEXT: shl [[REG0:\$m[0-9]+]], $m0, 19
; CHECK-NEXT: shrs $m0, [[REG0]], 19
; CHECK-NEXT: shl [[REG1:\$m[0-9]+]], $m1, 19
; CHECK-NEXT: shrs $m1, [[REG1]], 19
; CHECK-NEXT:  br $m10
define <2 x i32> @signext_inreg13_v2i32(<2 x i32> %x) {
  %t = trunc <2 x i32> %x to <2 x i13>
  %s = sext <2 x i13> %t to <2 x i32>
  ret <2 x i32> %s
}

; CHECK-LABEL: signext_inreg14_v2i32:
; CHECK:       # %bb.0:
; CHECK-NEXT: shl [[REG0:\$m[0-9]+]], $m0, 18
; CHECK-NEXT: shrs $m0, [[REG0]], 18
; CHECK-NEXT: shl [[REG1:\$m[0-9]+]], $m1, 18
; CHECK-NEXT: shrs $m1, [[REG1]], 18
; CHECK-NEXT:  br $m10
define <2 x i32> @signext_inreg14_v2i32(<2 x i32> %x) {
  %t = trunc <2 x i32> %x to <2 x i14>
  %s = sext <2 x i14> %t to <2 x i32>
  ret <2 x i32> %s
}

; CHECK-LABEL: signext_inreg15_v2i32:
; CHECK:       # %bb.0:
; CHECK-NEXT: shl [[REG0:\$m[0-9]+]], $m0, 17
; CHECK-NEXT: shrs $m0, [[REG0]], 17
; CHECK-NEXT: shl [[REG1:\$m[0-9]+]], $m1, 17
; CHECK-NEXT: shrs $m1, [[REG1]], 17
; CHECK-NEXT:  br $m10
define <2 x i32> @signext_inreg15_v2i32(<2 x i32> %x) {
  %t = trunc <2 x i32> %x to <2 x i15>
  %s = sext <2 x i15> %t to <2 x i32>
  ret <2 x i32> %s
}

; CHECK-LABEL: signext_inreg16_v2i32:
; CHECK:       # %bb.0:
; CHECK-NEXT: shl [[REG0:\$m[0-9]+]], $m0, 16
; CHECK-NEXT: shrs $m0, [[REG0]], 16
; CHECK-NEXT: shl [[REG1:\$m[0-9]+]], $m1, 16
; CHECK-NEXT: shrs $m1, [[REG1]], 16
; CHECK-NEXT:  br $m10
define <2 x i32> @signext_inreg16_v2i32(<2 x i32> %x) {
  %t = trunc <2 x i32> %x to <2 x i16>
  %s = sext <2 x i16> %t to <2 x i32>
  ret <2 x i32> %s
}

; CHECK-LABEL: signext_inreg17_v2i32:
; CHECK:       # %bb.0:
; CHECK-NEXT: shl [[REG0:\$m[0-9]+]], $m0, 15
; CHECK-NEXT: shrs $m0, [[REG0]], 15
; CHECK-NEXT: shl [[REG1:\$m[0-9]+]], $m1, 15
; CHECK-NEXT: shrs $m1, [[REG1]], 15
; CHECK-NEXT:  br $m10
define <2 x i32> @signext_inreg17_v2i32(<2 x i32> %x) {
  %t = trunc <2 x i32> %x to <2 x i17>
  %s = sext <2 x i17> %t to <2 x i32>
  ret <2 x i32> %s
}

; CHECK-LABEL: signext_inreg18_v2i32:
; CHECK:       # %bb.0:
; CHECK-NEXT: shl [[REG0:\$m[0-9]+]], $m0, 14
; CHECK-NEXT: shrs $m0, [[REG0]], 14
; CHECK-NEXT: shl [[REG1:\$m[0-9]+]], $m1, 14
; CHECK-NEXT: shrs $m1, [[REG1]], 14
; CHECK-NEXT:  br $m10
define <2 x i32> @signext_inreg18_v2i32(<2 x i32> %x) {
  %t = trunc <2 x i32> %x to <2 x i18>
  %s = sext <2 x i18> %t to <2 x i32>
  ret <2 x i32> %s
}

; CHECK-LABEL: signext_inreg19_v2i32:
; CHECK:       # %bb.0:
; CHECK-NEXT: shl [[REG0:\$m[0-9]+]], $m0, 13
; CHECK-NEXT: shrs $m0, [[REG0]], 13
; CHECK-NEXT: shl [[REG1:\$m[0-9]+]], $m1, 13
; CHECK-NEXT: shrs $m1, [[REG1]], 13
; CHECK-NEXT:  br $m10
define <2 x i32> @signext_inreg19_v2i32(<2 x i32> %x) {
  %t = trunc <2 x i32> %x to <2 x i19>
  %s = sext <2 x i19> %t to <2 x i32>
  ret <2 x i32> %s
}

; CHECK-LABEL: signext_inreg20_v2i32:
; CHECK:       # %bb.0:
; CHECK-NEXT: shl [[REG0:\$m[0-9]+]], $m0, 12
; CHECK-NEXT: shrs $m0, [[REG0]], 12
; CHECK-NEXT: shl [[REG1:\$m[0-9]+]], $m1, 12
; CHECK-NEXT: shrs $m1, [[REG1]], 12
; CHECK-NEXT:  br $m10
define <2 x i32> @signext_inreg20_v2i32(<2 x i32> %x) {
  %t = trunc <2 x i32> %x to <2 x i20>
  %s = sext <2 x i20> %t to <2 x i32>
  ret <2 x i32> %s
}

; CHECK-LABEL: signext_inreg21_v2i32:
; CHECK:       # %bb.0:
; CHECK-NEXT: shl [[REG0:\$m[0-9]+]], $m0, 11
; CHECK-NEXT: shrs $m0, [[REG0]], 11
; CHECK-NEXT: shl [[REG1:\$m[0-9]+]], $m1, 11
; CHECK-NEXT: shrs $m1, [[REG1]], 11
; CHECK-NEXT:  br $m10
define <2 x i32> @signext_inreg21_v2i32(<2 x i32> %x) {
  %t = trunc <2 x i32> %x to <2 x i21>
  %s = sext <2 x i21> %t to <2 x i32>
  ret <2 x i32> %s
}

; CHECK-LABEL: signext_inreg22_v2i32:
; CHECK:       # %bb.0:
; CHECK-NEXT: shl [[REG0:\$m[0-9]+]], $m0, 10
; CHECK-NEXT: shrs $m0, [[REG0]], 10
; CHECK-NEXT: shl [[REG1:\$m[0-9]+]], $m1, 10
; CHECK-NEXT: shrs $m1, [[REG1]], 10
; CHECK-NEXT:  br $m10
define <2 x i32> @signext_inreg22_v2i32(<2 x i32> %x) {
  %t = trunc <2 x i32> %x to <2 x i22>
  %s = sext <2 x i22> %t to <2 x i32>
  ret <2 x i32> %s
}

; CHECK-LABEL: signext_inreg23_v2i32:
; CHECK:       # %bb.0:
; CHECK-NEXT: shl [[REG0:\$m[0-9]+]], $m0, 9
; CHECK-NEXT: shrs $m0, [[REG0]], 9
; CHECK-NEXT: shl [[REG1:\$m[0-9]+]], $m1, 9
; CHECK-NEXT: shrs $m1, [[REG1]], 9
; CHECK-NEXT:  br $m10
define <2 x i32> @signext_inreg23_v2i32(<2 x i32> %x) {
  %t = trunc <2 x i32> %x to <2 x i23>
  %s = sext <2 x i23> %t to <2 x i32>
  ret <2 x i32> %s
}

; CHECK-LABEL: signext_inreg24_v2i32:
; CHECK:       # %bb.0:
; CHECK-NEXT: shl [[REG0:\$m[0-9]+]], $m0, 8
; CHECK-NEXT: shrs $m0, [[REG0]], 8
; CHECK-NEXT: shl [[REG1:\$m[0-9]+]], $m1, 8
; CHECK-NEXT: shrs $m1, [[REG1]], 8
; CHECK-NEXT:  br $m10
define <2 x i32> @signext_inreg24_v2i32(<2 x i32> %x) {
  %t = trunc <2 x i32> %x to <2 x i24>
  %s = sext <2 x i24> %t to <2 x i32>
  ret <2 x i32> %s
}

; CHECK-LABEL: signext_inreg25_v2i32:
; CHECK:       # %bb.0:
; CHECK-NEXT: shl [[REG0:\$m[0-9]+]], $m0, 7
; CHECK-NEXT: shrs $m0, [[REG0]], 7
; CHECK-NEXT: shl [[REG1:\$m[0-9]+]], $m1, 7
; CHECK-NEXT: shrs $m1, [[REG1]], 7
; CHECK-NEXT:  br $m10
define <2 x i32> @signext_inreg25_v2i32(<2 x i32> %x) {
  %t = trunc <2 x i32> %x to <2 x i25>
  %s = sext <2 x i25> %t to <2 x i32>
  ret <2 x i32> %s
}

; CHECK-LABEL: signext_inreg26_v2i32:
; CHECK:       # %bb.0:
; CHECK-NEXT: shl [[REG0:\$m[0-9]+]], $m0, 6
; CHECK-NEXT: shrs $m0, [[REG0]], 6
; CHECK-NEXT: shl [[REG1:\$m[0-9]+]], $m1, 6
; CHECK-NEXT: shrs $m1, [[REG1]], 6
; CHECK-NEXT:  br $m10
define <2 x i32> @signext_inreg26_v2i32(<2 x i32> %x) {
  %t = trunc <2 x i32> %x to <2 x i26>
  %s = sext <2 x i26> %t to <2 x i32>
  ret <2 x i32> %s
}

; CHECK-LABEL: signext_inreg27_v2i32:
; CHECK:       # %bb.0:
; CHECK-NEXT: shl [[REG0:\$m[0-9]+]], $m0, 5
; CHECK-NEXT: shrs $m0, [[REG0]], 5
; CHECK-NEXT: shl [[REG1:\$m[0-9]+]], $m1, 5
; CHECK-NEXT: shrs $m1, [[REG1]], 5
; CHECK-NEXT:  br $m10
define <2 x i32> @signext_inreg27_v2i32(<2 x i32> %x) {
  %t = trunc <2 x i32> %x to <2 x i27>
  %s = sext <2 x i27> %t to <2 x i32>
  ret <2 x i32> %s
}

; CHECK-LABEL: signext_inreg28_v2i32:
; CHECK:       # %bb.0:
; CHECK-NEXT: shl [[REG0:\$m[0-9]+]], $m0, 4
; CHECK-NEXT: shrs $m0, [[REG0]], 4
; CHECK-NEXT: shl [[REG1:\$m[0-9]+]], $m1, 4
; CHECK-NEXT: shrs $m1, [[REG1]], 4
; CHECK-NEXT:  br $m10
define <2 x i32> @signext_inreg28_v2i32(<2 x i32> %x) {
  %t = trunc <2 x i32> %x to <2 x i28>
  %s = sext <2 x i28> %t to <2 x i32>
  ret <2 x i32> %s
}

; CHECK-LABEL: signext_inreg29_v2i32:
; CHECK:       # %bb.0:
; CHECK-NEXT: shl [[REG0:\$m[0-9]+]], $m0, 3
; CHECK-NEXT: shrs $m0, [[REG0]], 3
; CHECK-NEXT: shl [[REG1:\$m[0-9]+]], $m1, 3
; CHECK-NEXT: shrs $m1, [[REG1]], 3
; CHECK-NEXT:  br $m10
define <2 x i32> @signext_inreg29_v2i32(<2 x i32> %x) {
  %t = trunc <2 x i32> %x to <2 x i29>
  %s = sext <2 x i29> %t to <2 x i32>
  ret <2 x i32> %s
}

; CHECK-LABEL: signext_inreg30_v2i32:
; CHECK:       # %bb.0:
; CHECK-NEXT: shl [[REG0:\$m[0-9]+]], $m0, 2
; CHECK-NEXT: shrs $m0, [[REG0]], 2
; CHECK-NEXT: shl [[REG1:\$m[0-9]+]], $m1, 2
; CHECK-NEXT: shrs $m1, [[REG1]], 2
; CHECK-NEXT:  br $m10
define <2 x i32> @signext_inreg30_v2i32(<2 x i32> %x) {
  %t = trunc <2 x i32> %x to <2 x i30>
  %s = sext <2 x i30> %t to <2 x i32>
  ret <2 x i32> %s
}

; CHECK-LABEL: signext_inreg31_v2i32:
; CHECK:       # %bb.0:
; CHECK-NEXT: shl [[REG0:\$m[0-9]+]], $m0, 1
; CHECK-NEXT: shrs $m0, [[REG0]], 1
; CHECK-NEXT: shl [[REG1:\$m[0-9]+]], $m1, 1
; CHECK-NEXT: shrs $m1, [[REG1]], 1
; CHECK-NEXT:  br $m10
define <2 x i32> @signext_inreg31_v2i32(<2 x i32> %x) {
  %t = trunc <2 x i32> %x to <2 x i31>
  %s = sext <2 x i31> %t to <2 x i32>
  ret <2 x i32> %s
}

; CHECK-LABEL: signext_inreg1_v2i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shl  [[REG0:\$m[0-9]+]], $m0, 15
; CHECK-NEXT:  shl [[REG1:\$m[0-9]+]], $m0, 31
; CHECK-NEXT:  shrs [[REG0]], [[REG0]], 31
; CHECK-NEXT:  shrs [[REG1]], [[REG1]], 31
; CHECK-NEXT:  sort4x16lo $m0, [[REG1]], [[REG0]]
; CHECK-NEXT:  br $m10
define <2 x i16> @signext_inreg1_v2i16(<2 x i16> %x) {
  %t = trunc <2 x i16> %x to <2 x i1>
  %s = sext <2 x i1> %t to <2 x i16>
  ret <2 x i16> %s
}

; CHECK-LABEL: signext_inreg2_v2i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shl  [[REG0:\$m[0-9]+]], $m0, 14
; CHECK-NEXT:  shl [[REG1:\$m[0-9]+]], $m0, 30
; CHECK-NEXT:  shrs [[REG0]], [[REG0]], 30
; CHECK-NEXT:  shrs [[REG1]], [[REG1]], 30
; CHECK-NEXT:  sort4x16lo $m0, [[REG1]], [[REG0]]
; CHECK-NEXT:  br $m10
define <2 x i16> @signext_inreg2_v2i16(<2 x i16> %x) {
  %t = trunc <2 x i16> %x to <2 x i2>
  %s = sext <2 x i2> %t to <2 x i16>
  ret <2 x i16> %s
}

; CHECK-LABEL: signext_inreg3_v2i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shl  [[REG0:\$m[0-9]+]], $m0, 13
; CHECK-NEXT:  shl [[REG1:\$m[0-9]+]], $m0, 29
; CHECK-NEXT:  shrs [[REG0]], [[REG0]], 29
; CHECK-NEXT:  shrs [[REG1]], [[REG1]], 29
; CHECK-NEXT:  sort4x16lo $m0, [[REG1]], [[REG0]]
; CHECK-NEXT:  br $m10
define <2 x i16> @signext_inreg3_v2i16(<2 x i16> %x) {
  %t = trunc <2 x i16> %x to <2 x i3>
  %s = sext <2 x i3> %t to <2 x i16>
  ret <2 x i16> %s
}

; CHECK-LABEL: signext_inreg4_v2i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shl  [[REG0:\$m[0-9]+]], $m0, 12
; CHECK-NEXT:  shl [[REG1:\$m[0-9]+]], $m0, 28
; CHECK-NEXT:  shrs [[REG0]], [[REG0]], 28
; CHECK-NEXT:  shrs [[REG1]], [[REG1]], 28
; CHECK-NEXT:  sort4x16lo $m0, [[REG1]], [[REG0]]
; CHECK-NEXT:  br $m10
define <2 x i16> @signext_inreg4_v2i16(<2 x i16> %x) {
  %t = trunc <2 x i16> %x to <2 x i4>
  %s = sext <2 x i4> %t to <2 x i16>
  ret <2 x i16> %s
}

; CHECK-LABEL: signext_inreg5_v2i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shl  [[REG0:\$m[0-9]+]], $m0, 11
; CHECK-NEXT:  shl [[REG1:\$m[0-9]+]], $m0, 27
; CHECK-NEXT:  shrs [[REG0]], [[REG0]], 27
; CHECK-NEXT:  shrs [[REG1]], [[REG1]], 27
; CHECK-NEXT:  sort4x16lo $m0, [[REG1]], [[REG0]]
; CHECK-NEXT:  br $m10
define <2 x i16> @signext_inreg5_v2i16(<2 x i16> %x) {
  %t = trunc <2 x i16> %x to <2 x i5>
  %s = sext <2 x i5> %t to <2 x i16>
  ret <2 x i16> %s
}

; CHECK-LABEL: signext_inreg6_v2i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shl  [[REG0:\$m[0-9]+]], $m0, 10
; CHECK-NEXT:  shl [[REG1:\$m[0-9]+]], $m0, 26
; CHECK-NEXT:  shrs [[REG0]], [[REG0]], 26
; CHECK-NEXT:  shrs [[REG1]], [[REG1]], 26
; CHECK-NEXT:  sort4x16lo $m0, [[REG1]], [[REG0]]
; CHECK-NEXT:  br $m10
define <2 x i16> @signext_inreg6_v2i16(<2 x i16> %x) {
  %t = trunc <2 x i16> %x to <2 x i6>
  %s = sext <2 x i6> %t to <2 x i16>
  ret <2 x i16> %s
}

; CHECK-LABEL: signext_inreg7_v2i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shl  [[REG0:\$m[0-9]+]], $m0, 9
; CHECK-NEXT:  shl [[REG1:\$m[0-9]+]], $m0, 25
; CHECK-NEXT:  shrs [[REG0]], [[REG0]], 25
; CHECK-NEXT:  shrs [[REG1]], [[REG1]], 25
; CHECK-NEXT:  sort4x16lo $m0, [[REG1]], [[REG0]]
; CHECK-NEXT:  br $m10
define <2 x i16> @signext_inreg7_v2i16(<2 x i16> %x) {
  %t = trunc <2 x i16> %x to <2 x i7>
  %s = sext <2 x i7> %t to <2 x i16>
  ret <2 x i16> %s
}

; CHECK-LABEL: signext_inreg8_v2i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shl  [[REG0:\$m[0-9]+]], $m0, 8
; CHECK-NEXT:  shl [[REG1:\$m[0-9]+]], $m0, 24
; CHECK-NEXT:  shrs [[REG0]], [[REG0]], 24
; CHECK-NEXT:  shrs [[REG1]], [[REG1]], 24
; CHECK-NEXT:  sort4x16lo $m0, [[REG1]], [[REG0]]
; CHECK-NEXT:  br $m10
define <2 x i16> @signext_inreg8_v2i16(<2 x i16> %x) {
  %t = trunc <2 x i16> %x to <2 x i8>
  %s = sext <2 x i8> %t to <2 x i16>
  ret <2 x i16> %s
}

; CHECK-LABEL: signext_inreg9_v2i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shl  [[REG0:\$m[0-9]+]], $m0, 7
; CHECK-NEXT:  shl [[REG1:\$m[0-9]+]], $m0, 23
; CHECK-NEXT:  shrs [[REG0]], [[REG0]], 23
; CHECK-NEXT:  shrs [[REG1]], [[REG1]], 23
; CHECK-NEXT:  sort4x16lo $m0, [[REG1]], [[REG0]]
; CHECK-NEXT:  br $m10
define <2 x i16> @signext_inreg9_v2i16(<2 x i16> %x) {
  %t = trunc <2 x i16> %x to <2 x i9>
  %s = sext <2 x i9> %t to <2 x i16>
  ret <2 x i16> %s
}

; CHECK-LABEL: signext_inreg10_v2i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shl  [[REG0:\$m[0-9]+]], $m0, 6
; CHECK-NEXT:  shl [[REG1:\$m[0-9]+]], $m0, 22
; CHECK-NEXT:  shrs [[REG0]], [[REG0]], 22
; CHECK-NEXT:  shrs [[REG1]], [[REG1]], 22
; CHECK-NEXT:  sort4x16lo $m0, [[REG1]], [[REG0]]
; CHECK-NEXT:  br $m10
define <2 x i16> @signext_inreg10_v2i16(<2 x i16> %x) {
  %t = trunc <2 x i16> %x to <2 x i10>
  %s = sext <2 x i10> %t to <2 x i16>
  ret <2 x i16> %s
}

; CHECK-LABEL: signext_inreg11_v2i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shl  [[REG0:\$m[0-9]+]], $m0, 5
; CHECK-NEXT:  shl [[REG1:\$m[0-9]+]], $m0, 21
; CHECK-NEXT:  shrs [[REG0]], [[REG0]], 21
; CHECK-NEXT:  shrs [[REG1]], [[REG1]], 21
; CHECK-NEXT:  sort4x16lo $m0, [[REG1]], [[REG0]]
; CHECK-NEXT:  br $m10
define <2 x i16> @signext_inreg11_v2i16(<2 x i16> %x) {
  %t = trunc <2 x i16> %x to <2 x i11>
  %s = sext <2 x i11> %t to <2 x i16>
  ret <2 x i16> %s
}

; CHECK-LABEL: signext_inreg12_v2i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shl  [[REG0:\$m[0-9]+]], $m0, 4
; CHECK-NEXT:  shl [[REG1:\$m[0-9]+]], $m0, 20
; CHECK-NEXT:  shrs [[REG0]], [[REG0]], 20
; CHECK-NEXT:  shrs [[REG1]], [[REG1]], 20
; CHECK-NEXT:  sort4x16lo $m0, [[REG1]], [[REG0]]
; CHECK-NEXT:  br $m10
define <2 x i16> @signext_inreg12_v2i16(<2 x i16> %x) {
  %t = trunc <2 x i16> %x to <2 x i12>
  %s = sext <2 x i12> %t to <2 x i16>
  ret <2 x i16> %s
}

; CHECK-LABEL: signext_inreg13_v2i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shl  [[REG0:\$m[0-9]+]], $m0, 3
; CHECK-NEXT:  shl [[REG1:\$m[0-9]+]], $m0, 19
; CHECK-NEXT:  shrs [[REG0]], [[REG0]], 19
; CHECK-NEXT:  shrs [[REG1]], [[REG1]], 19
; CHECK-NEXT:  sort4x16lo $m0, [[REG1]], [[REG0]]
; CHECK-NEXT:  br $m10
define <2 x i16> @signext_inreg13_v2i16(<2 x i16> %x) {
  %t = trunc <2 x i16> %x to <2 x i13>
  %s = sext <2 x i13> %t to <2 x i16>
  ret <2 x i16> %s
}

; CHECK-LABEL: signext_inreg14_v2i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shl  [[REG0:\$m[0-9]+]], $m0, 2
; CHECK-NEXT:  shl [[REG1:\$m[0-9]+]], $m0, 18
; CHECK-NEXT:  shrs [[REG0]], [[REG0]], 18
; CHECK-NEXT:  shrs [[REG1]], [[REG1]], 18
; CHECK-NEXT:  sort4x16lo $m0, [[REG1]], [[REG0]]
; CHECK-NEXT:  br $m10
define <2 x i16> @signext_inreg14_v2i16(<2 x i16> %x) {
  %t = trunc <2 x i16> %x to <2 x i14>
  %s = sext <2 x i14> %t to <2 x i16>
  ret <2 x i16> %s
}

; CHECK-LABEL: signext_inreg15_v2i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shl  [[REG0:\$m[0-9]+]], $m0, 1
; CHECK-NEXT:  shl [[REG1:\$m[0-9]+]], $m0, 17
; CHECK-NEXT:  shrs [[REG0]], [[REG0]], 17
; CHECK-NEXT:  shrs [[REG1]], [[REG1]], 17
; CHECK-NEXT:  sort4x16lo $m0, [[REG1]], [[REG0]]
; CHECK-NEXT:  br $m10
define <2 x i16> @signext_inreg15_v2i16(<2 x i16> %x) {
  %t = trunc <2 x i16> %x to <2 x i15>
  %s = sext <2 x i15> %t to <2 x i16>
  ret <2 x i16> %s
}

; CHECK-LABEL: signext_inreg1_v4i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shl [[REG0:\$m[0-9]+]], $m1, 15
; CHECK-NEXT:  shl [[REG1:\$m[0-9]+]], $m1, 31
; CHECK-NEXT:  shrs [[REG0]], [[REG0]], 31
; CHECK-NEXT:  shrs [[REG1]], [[REG1]], 31
; CHECK-NEXT:  shl [[REG2:\$m[0-9]+]], $m0, 15
; CHECK-NEXT:  shl [[REG3:\$m[0-9]+]], $m0, 31
; CHECK-NEXT:  sort4x16lo $m1, [[REG1]], [[REG0]]
; CHECK-NEXT:  shrs [[REGTMP0:\$m[0-9]+]], [[REG2]], 31
; CHECK-NEXT:  shrs [[REGTMP1:\$m[0-9]+]], [[REG3]], 31
; CHECK-NEXT:  sort4x16lo $m0, [[REGTMP1]], [[REGTMP0]]
; CHECK-NEXT:  br $m10
define <4 x i16> @signext_inreg1_v4i16(<4 x i16> %x) {
  %t = trunc <4 x i16> %x to <4 x i1>
  %s = sext <4 x i1> %t to <4 x i16>
  ret <4 x i16> %s
}

; CHECK-LABEL: signext_inreg2_v4i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shl [[REG0:\$m[0-9]+]], $m1, 14
; CHECK-NEXT:  shl [[REG1:\$m[0-9]+]], $m1, 30
; CHECK-NEXT:  shrs [[REG0]], [[REG0]], 30
; CHECK-NEXT:  shrs [[REG1]], [[REG1]], 30
; CHECK-NEXT:  shl [[REG2:\$m[0-9]+]], $m0, 14
; CHECK-NEXT:  shl [[REG3:\$m[0-9]+]], $m0, 30
; CHECK-NEXT:  sort4x16lo $m1, [[REG1]], [[REG0]]
; CHECK-NEXT:  shrs [[REGTMP0:\$m[0-9]+]], [[REG2]], 30
; CHECK-NEXT:  shrs [[REGTMP1:\$m[0-9]+]], [[REG3]], 30
; CHECK-NEXT:  sort4x16lo $m0, [[REGTMP1]], [[REGTMP0]]
; CHECK-NEXT:  br $m10
define <4 x i16> @signext_inreg2_v4i16(<4 x i16> %x) {
  %t = trunc <4 x i16> %x to <4 x i2>
  %s = sext <4 x i2> %t to <4 x i16>
  ret <4 x i16> %s
}

; CHECK-LABEL: signext_inreg3_v4i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shl [[REG0:\$m[0-9]+]], $m1, 13
; CHECK-NEXT:  shl [[REG1:\$m[0-9]+]], $m1, 29
; CHECK-NEXT:  shrs [[REG0]], [[REG0]], 29
; CHECK-NEXT:  shrs [[REG1]], [[REG1]], 29
; CHECK-NEXT:  shl [[REG2:\$m[0-9]+]], $m0, 13
; CHECK-NEXT:  shl [[REG3:\$m[0-9]+]], $m0, 29
; CHECK-NEXT:  sort4x16lo $m1, [[REG1]], [[REG0]]
; CHECK-NEXT:  shrs [[REGTMP0:\$m[0-9]+]], [[REG2]], 29
; CHECK-NEXT:  shrs [[REGTMP1:\$m[0-9]+]], [[REG3]], 29
; CHECK-NEXT:  sort4x16lo $m0, [[REGTMP1]], [[REGTMP0]]
; CHECK-NEXT:  br $m10
define <4 x i16> @signext_inreg3_v4i16(<4 x i16> %x) {
  %t = trunc <4 x i16> %x to <4 x i3>
  %s = sext <4 x i3> %t to <4 x i16>
  ret <4 x i16> %s
}

; CHECK-LABEL: signext_inreg4_v4i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shl [[REG0:\$m[0-9]+]], $m1, 12
; CHECK-NEXT:  shl [[REG1:\$m[0-9]+]], $m1, 28
; CHECK-NEXT:  shrs [[REG0]], [[REG0]], 28
; CHECK-NEXT:  shrs [[REG1]], [[REG1]], 28
; CHECK-NEXT:  shl [[REG2:\$m[0-9]+]], $m0, 12
; CHECK-NEXT:  shl [[REG3:\$m[0-9]+]], $m0, 28
; CHECK-NEXT:  sort4x16lo $m1, [[REG1]], [[REG0]]
; CHECK-NEXT:  shrs [[REGTMP0:\$m[0-9]+]], [[REG2]], 28
; CHECK-NEXT:  shrs [[REGTMP1:\$m[0-9]+]], [[REG3]], 28
; CHECK-NEXT:  sort4x16lo $m0, [[REGTMP1]], [[REGTMP0]]
; CHECK-NEXT:  br $m10
define <4 x i16> @signext_inreg4_v4i16(<4 x i16> %x) {
  %t = trunc <4 x i16> %x to <4 x i4>
  %s = sext <4 x i4> %t to <4 x i16>
  ret <4 x i16> %s
}

; CHECK-LABEL: signext_inreg5_v4i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shl [[REG0:\$m[0-9]+]], $m1, 11
; CHECK-NEXT:  shl [[REG1:\$m[0-9]+]], $m1, 27
; CHECK-NEXT:  shrs [[REG0]], [[REG0]], 27
; CHECK-NEXT:  shrs [[REG1]], [[REG1]], 27
; CHECK-NEXT:  shl [[REG2:\$m[0-9]+]], $m0, 11
; CHECK-NEXT:  shl [[REG3:\$m[0-9]+]], $m0, 27
; CHECK-NEXT:  sort4x16lo $m1, [[REG1]], [[REG0]]
; CHECK-NEXT:  shrs [[REGTMP0:\$m[0-9]+]], [[REG2]], 27
; CHECK-NEXT:  shrs [[REGTMP1:\$m[0-9]+]], [[REG3]], 27
; CHECK-NEXT:  sort4x16lo $m0, [[REGTMP1]], [[REGTMP0]]
; CHECK-NEXT:  br $m10
define <4 x i16> @signext_inreg5_v4i16(<4 x i16> %x) {
  %t = trunc <4 x i16> %x to <4 x i5>
  %s = sext <4 x i5> %t to <4 x i16>
  ret <4 x i16> %s
}

; CHECK-LABEL: signext_inreg6_v4i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shl [[REG0:\$m[0-9]+]], $m1, 10
; CHECK-NEXT:  shl [[REG1:\$m[0-9]+]], $m1, 26
; CHECK-NEXT:  shrs [[REG0]], [[REG0]], 26
; CHECK-NEXT:  shrs [[REG1]], [[REG1]], 26
; CHECK-NEXT:  shl [[REG2:\$m[0-9]+]], $m0, 10
; CHECK-NEXT:  shl [[REG3:\$m[0-9]+]], $m0, 26
; CHECK-NEXT:  sort4x16lo $m1, [[REG1]], [[REG0]]
; CHECK-NEXT:  shrs [[REGTMP0:\$m[0-9]+]], [[REG2]], 26
; CHECK-NEXT:  shrs [[REGTMP1:\$m[0-9]+]], [[REG3]], 26
; CHECK-NEXT:  sort4x16lo $m0, [[REGTMP1]], [[REGTMP0]]
; CHECK-NEXT:  br $m10
define <4 x i16> @signext_inreg6_v4i16(<4 x i16> %x) {
  %t = trunc <4 x i16> %x to <4 x i6>
  %s = sext <4 x i6> %t to <4 x i16>
  ret <4 x i16> %s
}

; CHECK-LABEL: signext_inreg7_v4i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shl [[REG0:\$m[0-9]+]], $m1, 9
; CHECK-NEXT:  shl [[REG1:\$m[0-9]+]], $m1, 25
; CHECK-NEXT:  shrs [[REG0]], [[REG0]], 25
; CHECK-NEXT:  shrs [[REG1]], [[REG1]], 25
; CHECK-NEXT:  shl [[REG2:\$m[0-9]+]], $m0, 9
; CHECK-NEXT:  shl [[REG3:\$m[0-9]+]], $m0, 25
; CHECK-NEXT:  sort4x16lo $m1, [[REG1]], [[REG0]]
; CHECK-NEXT:  shrs [[REGTMP0:\$m[0-9]+]], [[REG2]], 25
; CHECK-NEXT:  shrs [[REGTMP1:\$m[0-9]+]], [[REG3]], 25
; CHECK-NEXT:  sort4x16lo $m0, [[REGTMP1]], [[REGTMP0]]
; CHECK-NEXT:  br $m10
define <4 x i16> @signext_inreg7_v4i16(<4 x i16> %x) {
  %t = trunc <4 x i16> %x to <4 x i7>
  %s = sext <4 x i7> %t to <4 x i16>
  ret <4 x i16> %s
}

; CHECK-LABEL: signext_inreg8_v4i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shl [[REG0:\$m[0-9]+]], $m1, 8
; CHECK-NEXT:  shl [[REG1:\$m[0-9]+]], $m1, 24
; CHECK-NEXT:  shrs [[REG0]], [[REG0]], 24
; CHECK-NEXT:  shrs [[REG1]], [[REG1]], 24
; CHECK-NEXT:  shl [[REG2:\$m[0-9]+]], $m0, 8
; CHECK-NEXT:  shl [[REG3:\$m[0-9]+]], $m0, 24
; CHECK-NEXT:  sort4x16lo $m1, [[REG1]], [[REG0]]
; CHECK-NEXT:  shrs [[REGTMP0:\$m[0-9]+]], [[REG2]], 24
; CHECK-NEXT:  shrs [[REGTMP1:\$m[0-9]+]], [[REG3]], 24
; CHECK-NEXT:  sort4x16lo $m0, [[REGTMP1]], [[REGTMP0]]
; CHECK-NEXT:  br $m10
define <4 x i16> @signext_inreg8_v4i16(<4 x i16> %x) {
  %t = trunc <4 x i16> %x to <4 x i8>
  %s = sext <4 x i8> %t to <4 x i16>
  ret <4 x i16> %s
}

; CHECK-LABEL: signext_inreg9_v4i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shl [[REG0:\$m[0-9]+]], $m1, 7
; CHECK-NEXT:  shl [[REG1:\$m[0-9]+]], $m1, 23
; CHECK-NEXT:  shrs [[REG0]], [[REG0]], 23
; CHECK-NEXT:  shrs [[REG1]], [[REG1]], 23
; CHECK-NEXT:  shl [[REG2:\$m[0-9]+]], $m0, 7
; CHECK-NEXT:  shl [[REG3:\$m[0-9]+]], $m0, 23
; CHECK-NEXT:  sort4x16lo $m1, [[REG1]], [[REG0]]
; CHECK-NEXT:  shrs [[REGTMP0:\$m[0-9]+]], [[REG2]], 23
; CHECK-NEXT:  shrs [[REGTMP1:\$m[0-9]+]], [[REG3]], 23
; CHECK-NEXT:  sort4x16lo $m0, [[REGTMP1]], [[REGTMP0]]
; CHECK-NEXT:  br $m10
define <4 x i16> @signext_inreg9_v4i16(<4 x i16> %x) {
  %t = trunc <4 x i16> %x to <4 x i9>
  %s = sext <4 x i9> %t to <4 x i16>
  ret <4 x i16> %s
}

; CHECK-LABEL: signext_inreg10_v4i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shl [[REG0:\$m[0-9]+]], $m1, 6
; CHECK-NEXT:  shl [[REG1:\$m[0-9]+]], $m1, 22
; CHECK-NEXT:  shrs [[REG0]], [[REG0]], 22
; CHECK-NEXT:  shrs [[REG1]], [[REG1]], 22
; CHECK-NEXT:  shl [[REG2:\$m[0-9]+]], $m0, 6
; CHECK-NEXT:  shl [[REG3:\$m[0-9]+]], $m0, 22
; CHECK-NEXT:  sort4x16lo $m1, [[REG1]], [[REG0]]
; CHECK-NEXT:  shrs [[REGTMP0:\$m[0-9]+]], [[REG2]], 22
; CHECK-NEXT:  shrs [[REGTMP1:\$m[0-9]+]], [[REG3]], 22
; CHECK-NEXT:  sort4x16lo $m0, [[REGTMP1]], [[REGTMP0]]
; CHECK-NEXT:  br $m10
define <4 x i16> @signext_inreg10_v4i16(<4 x i16> %x) {
  %t = trunc <4 x i16> %x to <4 x i10>
  %s = sext <4 x i10> %t to <4 x i16>
  ret <4 x i16> %s
}

; CHECK-LABEL: signext_inreg11_v4i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shl [[REG0:\$m[0-9]+]], $m1, 5
; CHECK-NEXT:  shl [[REG1:\$m[0-9]+]], $m1, 21
; CHECK-NEXT:  shrs [[REG0]], [[REG0]], 21
; CHECK-NEXT:  shrs [[REG1]], [[REG1]], 21
; CHECK-NEXT:  shl [[REG2:\$m[0-9]+]], $m0, 5
; CHECK-NEXT:  shl [[REG3:\$m[0-9]+]], $m0, 21
; CHECK-NEXT:  sort4x16lo $m1, [[REG1]], [[REG0]]
; CHECK-NEXT:  shrs [[REGTMP0:\$m[0-9]+]], [[REG2]], 21
; CHECK-NEXT:  shrs [[REGTMP1:\$m[0-9]+]], [[REG3]], 21
; CHECK-NEXT:  sort4x16lo $m0, [[REGTMP1]], [[REGTMP0]]
; CHECK-NEXT:  br $m10
define <4 x i16> @signext_inreg11_v4i16(<4 x i16> %x) {
  %t = trunc <4 x i16> %x to <4 x i11>
  %s = sext <4 x i11> %t to <4 x i16>
  ret <4 x i16> %s
}

; CHECK-LABEL: signext_inreg12_v4i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shl [[REG0:\$m[0-9]+]], $m1, 4
; CHECK-NEXT:  shl [[REG1:\$m[0-9]+]], $m1, 20
; CHECK-NEXT:  shrs [[REG0]], [[REG0]], 20
; CHECK-NEXT:  shrs [[REG1]], [[REG1]], 20
; CHECK-NEXT:  shl [[REG2:\$m[0-9]+]], $m0, 4
; CHECK-NEXT:  shl [[REG3:\$m[0-9]+]], $m0, 20
; CHECK-NEXT:  sort4x16lo $m1, [[REG1]], [[REG0]]
; CHECK-NEXT:  shrs [[REGTMP0:\$m[0-9]+]], [[REG2]], 20
; CHECK-NEXT:  shrs [[REGTMP1:\$m[0-9]+]], [[REG3]], 20
; CHECK-NEXT:  sort4x16lo $m0, [[REGTMP1]], [[REGTMP0]]
; CHECK-NEXT:  br $m10
define <4 x i16> @signext_inreg12_v4i16(<4 x i16> %x) {
  %t = trunc <4 x i16> %x to <4 x i12>
  %s = sext <4 x i12> %t to <4 x i16>
  ret <4 x i16> %s
}

; CHECK-LABEL: signext_inreg13_v4i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shl [[REG0:\$m[0-9]+]], $m1, 3
; CHECK-NEXT:  shl [[REG1:\$m[0-9]+]], $m1, 19
; CHECK-NEXT:  shrs [[REG0]], [[REG0]], 19
; CHECK-NEXT:  shrs [[REG1]], [[REG1]], 19
; CHECK-NEXT:  shl [[REG2:\$m[0-9]+]], $m0, 3
; CHECK-NEXT:  shl [[REG3:\$m[0-9]+]], $m0, 19
; CHECK-NEXT:  sort4x16lo $m1, [[REG1]], [[REG0]]
; CHECK-NEXT:  shrs [[REGTMP0:\$m[0-9]+]], [[REG2]], 19
; CHECK-NEXT:  shrs [[REGTMP1:\$m[0-9]+]], [[REG3]], 19
; CHECK-NEXT:  sort4x16lo $m0, [[REGTMP1]], [[REGTMP0]]
; CHECK-NEXT:  br $m10
define <4 x i16> @signext_inreg13_v4i16(<4 x i16> %x) {
  %t = trunc <4 x i16> %x to <4 x i13>
  %s = sext <4 x i13> %t to <4 x i16>
  ret <4 x i16> %s
}

; CHECK-LABEL: signext_inreg14_v4i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shl [[REG0:\$m[0-9]+]], $m1, 2
; CHECK-NEXT:  shl [[REG1:\$m[0-9]+]], $m1, 18
; CHECK-NEXT:  shrs [[REG0]], [[REG0]], 18
; CHECK-NEXT:  shrs [[REG1]], [[REG1]], 18
; CHECK-NEXT:  shl [[REG2:\$m[0-9]+]], $m0, 2
; CHECK-NEXT:  shl [[REG3:\$m[0-9]+]], $m0, 18
; CHECK-NEXT:  sort4x16lo $m1, [[REG1]], [[REG0]]
; CHECK-NEXT:  shrs [[REGTMP0:\$m[0-9]+]], [[REG2]], 18
; CHECK-NEXT:  shrs [[REGTMP1:\$m[0-9]+]], [[REG3]], 18
; CHECK-NEXT:  sort4x16lo $m0, [[REGTMP1]], [[REGTMP0]]
; CHECK-NEXT:  br $m10
define <4 x i16> @signext_inreg14_v4i16(<4 x i16> %x) {
  %t = trunc <4 x i16> %x to <4 x i14>
  %s = sext <4 x i14> %t to <4 x i16>
  ret <4 x i16> %s
}

; CHECK-LABEL: signext_inreg15_v4i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shl [[REG0:\$m[0-9]+]], $m1, 1
; CHECK-NEXT:  shl [[REG1:\$m[0-9]+]], $m1, 17
; CHECK-NEXT:  shrs [[REG0]], [[REG0]], 17
; CHECK-NEXT:  shrs [[REG1]], [[REG1]], 17
; CHECK-NEXT:  shl [[REG2:\$m[0-9]+]], $m0, 1
; CHECK-NEXT:  shl [[REG3:\$m[0-9]+]], $m0, 17
; CHECK-NEXT:  sort4x16lo $m1, [[REG1]], [[REG0]]
; CHECK-NEXT:  shrs [[REGTMP0:\$m[0-9]+]], [[REG2]], 17
; CHECK-NEXT:  shrs [[REGTMP1:\$m[0-9]+]], [[REG3]], 17
; CHECK-NEXT:  sort4x16lo $m0, [[REGTMP1]], [[REGTMP0]]
; CHECK-NEXT:  br $m10
define <4 x i16> @signext_inreg15_v4i16(<4 x i16> %x) {
  %t = trunc <4 x i16> %x to <4 x i15>
  %s = sext <4 x i15> %t to <4 x i16>
  ret <4 x i16> %s
}
