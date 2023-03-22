; RUN: llc < %s -march=colossus -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -march=colossus -mattr=+ipu2 | FileCheck %s
target triple = "colossus-graphcore--elf"

; A few cases generate redundant copies at the end of the BB, see T1052
; Checks each instance of shift by in register value and each constant for i32
; Constant shifts for vectors are not checked as the implementation lowers
; to a build_vector of scalars

; CHECK-LABEL: shl_1_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shl $m0, $m0, 1
; CHECK-NEXT:  br $m10
define i32 @shl_1_i32(i32 %x) {
  %res = shl i32 %x, 1
  ret i32 %res
}

; CHECK-LABEL: shl_2_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shl $m0, $m0, 2
; CHECK-NEXT:  br $m10
define i32 @shl_2_i32(i32 %x) {
  %res = shl i32 %x, 2
  ret i32 %res
}

; CHECK-LABEL: shl_3_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shl $m0, $m0, 3
; CHECK-NEXT:  br $m10
define i32 @shl_3_i32(i32 %x) {
  %res = shl i32 %x, 3
  ret i32 %res
}

; CHECK-LABEL: shl_4_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shl $m0, $m0, 4
; CHECK-NEXT:  br $m10
define i32 @shl_4_i32(i32 %x) {
  %res = shl i32 %x, 4
  ret i32 %res
}

; CHECK-LABEL: shl_5_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shl $m0, $m0, 5
; CHECK-NEXT:  br $m10
define i32 @shl_5_i32(i32 %x) {
  %res = shl i32 %x, 5
  ret i32 %res
}

; CHECK-LABEL: shl_6_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shl $m0, $m0, 6
; CHECK-NEXT:  br $m10
define i32 @shl_6_i32(i32 %x) {
  %res = shl i32 %x, 6
  ret i32 %res
}

; CHECK-LABEL: shl_7_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shl $m0, $m0, 7
; CHECK-NEXT:  br $m10
define i32 @shl_7_i32(i32 %x) {
  %res = shl i32 %x, 7
  ret i32 %res
}

; CHECK-LABEL: shl_8_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shl $m0, $m0, 8
; CHECK-NEXT:  br $m10
define i32 @shl_8_i32(i32 %x) {
  %res = shl i32 %x, 8
  ret i32 %res
}

; CHECK-LABEL: shl_9_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shl $m0, $m0, 9
; CHECK-NEXT:  br $m10
define i32 @shl_9_i32(i32 %x) {
  %res = shl i32 %x, 9
  ret i32 %res
}

; CHECK-LABEL: shl_10_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shl $m0, $m0, 10
; CHECK-NEXT:  br $m10
define i32 @shl_10_i32(i32 %x) {
  %res = shl i32 %x, 10
  ret i32 %res
}

; CHECK-LABEL: shl_11_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shl $m0, $m0, 11
; CHECK-NEXT:  br $m10
define i32 @shl_11_i32(i32 %x) {
  %res = shl i32 %x, 11
  ret i32 %res
}

; CHECK-LABEL: shl_12_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shl $m0, $m0, 12
; CHECK-NEXT:  br $m10
define i32 @shl_12_i32(i32 %x) {
  %res = shl i32 %x, 12
  ret i32 %res
}

; CHECK-LABEL: shl_13_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shl $m0, $m0, 13
; CHECK-NEXT:  br $m10
define i32 @shl_13_i32(i32 %x) {
  %res = shl i32 %x, 13
  ret i32 %res
}

; CHECK-LABEL: shl_14_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shl $m0, $m0, 14
; CHECK-NEXT:  br $m10
define i32 @shl_14_i32(i32 %x) {
  %res = shl i32 %x, 14
  ret i32 %res
}

; CHECK-LABEL: shl_15_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shl $m0, $m0, 15
; CHECK-NEXT:  br $m10
define i32 @shl_15_i32(i32 %x) {
  %res = shl i32 %x, 15
  ret i32 %res
}

; CHECK-LABEL: shl_16_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shl $m0, $m0, 16
; CHECK-NEXT:  br $m10
define i32 @shl_16_i32(i32 %x) {
  %res = shl i32 %x, 16
  ret i32 %res
}

; CHECK-LABEL: shl_17_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shl $m0, $m0, 17
; CHECK-NEXT:  br $m10
define i32 @shl_17_i32(i32 %x) {
  %res = shl i32 %x, 17
  ret i32 %res
}

; CHECK-LABEL: shl_18_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shl $m0, $m0, 18
; CHECK-NEXT:  br $m10
define i32 @shl_18_i32(i32 %x) {
  %res = shl i32 %x, 18
  ret i32 %res
}

; CHECK-LABEL: shl_19_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shl $m0, $m0, 19
; CHECK-NEXT:  br $m10
define i32 @shl_19_i32(i32 %x) {
  %res = shl i32 %x, 19
  ret i32 %res
}

; CHECK-LABEL: shl_20_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shl $m0, $m0, 20
; CHECK-NEXT:  br $m10
define i32 @shl_20_i32(i32 %x) {
  %res = shl i32 %x, 20
  ret i32 %res
}

; CHECK-LABEL: shl_21_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shl $m0, $m0, 21
; CHECK-NEXT:  br $m10
define i32 @shl_21_i32(i32 %x) {
  %res = shl i32 %x, 21
  ret i32 %res
}

; CHECK-LABEL: shl_22_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shl $m0, $m0, 22
; CHECK-NEXT:  br $m10
define i32 @shl_22_i32(i32 %x) {
  %res = shl i32 %x, 22
  ret i32 %res
}

; CHECK-LABEL: shl_23_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shl $m0, $m0, 23
; CHECK-NEXT:  br $m10
define i32 @shl_23_i32(i32 %x) {
  %res = shl i32 %x, 23
  ret i32 %res
}

; CHECK-LABEL: shl_24_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shl $m0, $m0, 24
; CHECK-NEXT:  br $m10
define i32 @shl_24_i32(i32 %x) {
  %res = shl i32 %x, 24
  ret i32 %res
}

; CHECK-LABEL: shl_25_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shl $m0, $m0, 25
; CHECK-NEXT:  br $m10
define i32 @shl_25_i32(i32 %x) {
  %res = shl i32 %x, 25
  ret i32 %res
}

; CHECK-LABEL: shl_26_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shl $m0, $m0, 26
; CHECK-NEXT:  br $m10
define i32 @shl_26_i32(i32 %x) {
  %res = shl i32 %x, 26
  ret i32 %res
}

; CHECK-LABEL: shl_27_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shl $m0, $m0, 27
; CHECK-NEXT:  br $m10
define i32 @shl_27_i32(i32 %x) {
  %res = shl i32 %x, 27
  ret i32 %res
}

; CHECK-LABEL: shl_28_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shl $m0, $m0, 28
; CHECK-NEXT:  br $m10
define i32 @shl_28_i32(i32 %x) {
  %res = shl i32 %x, 28
  ret i32 %res
}

; CHECK-LABEL: shl_29_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shl $m0, $m0, 29
; CHECK-NEXT:  br $m10
define i32 @shl_29_i32(i32 %x) {
  %res = shl i32 %x, 29
  ret i32 %res
}

; CHECK-LABEL: shl_30_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shl $m0, $m0, 30
; CHECK-NEXT:  br $m10
define i32 @shl_30_i32(i32 %x) {
  %res = shl i32 %x, 30
  ret i32 %res
}

; CHECK-LABEL: shl_31_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shl $m0, $m0, 31
; CHECK-NEXT:  br $m10
define i32 @shl_31_i32(i32 %x) {
  %res = shl i32 %x, 31
  ret i32 %res
}

; CHECK-LABEL: lshr_1_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shr $m0, $m0, 1
; CHECK-NEXT:  br $m10
define i32 @lshr_1_i32(i32 %x) {
  %res = lshr i32 %x, 1
  ret i32 %res
}

; CHECK-LABEL: lshr_2_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shr $m0, $m0, 2
; CHECK-NEXT:  br $m10
define i32 @lshr_2_i32(i32 %x) {
  %res = lshr i32 %x, 2
  ret i32 %res
}

; CHECK-LABEL: lshr_3_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shr $m0, $m0, 3
; CHECK-NEXT:  br $m10
define i32 @lshr_3_i32(i32 %x) {
  %res = lshr i32 %x, 3
  ret i32 %res
}

; CHECK-LABEL: lshr_4_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shr $m0, $m0, 4
; CHECK-NEXT:  br $m10
define i32 @lshr_4_i32(i32 %x) {
  %res = lshr i32 %x, 4
  ret i32 %res
}

; CHECK-LABEL: lshr_5_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shr $m0, $m0, 5
; CHECK-NEXT:  br $m10
define i32 @lshr_5_i32(i32 %x) {
  %res = lshr i32 %x, 5
  ret i32 %res
}

; CHECK-LABEL: lshr_6_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shr $m0, $m0, 6
; CHECK-NEXT:  br $m10
define i32 @lshr_6_i32(i32 %x) {
  %res = lshr i32 %x, 6
  ret i32 %res
}

; CHECK-LABEL: lshr_7_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shr $m0, $m0, 7
; CHECK-NEXT:  br $m10
define i32 @lshr_7_i32(i32 %x) {
  %res = lshr i32 %x, 7
  ret i32 %res
}

; CHECK-LABEL: lshr_8_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shr $m0, $m0, 8
; CHECK-NEXT:  br $m10
define i32 @lshr_8_i32(i32 %x) {
  %res = lshr i32 %x, 8
  ret i32 %res
}

; CHECK-LABEL: lshr_9_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shr $m0, $m0, 9
; CHECK-NEXT:  br $m10
define i32 @lshr_9_i32(i32 %x) {
  %res = lshr i32 %x, 9
  ret i32 %res
}

; CHECK-LABEL: lshr_10_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shr $m0, $m0, 10
; CHECK-NEXT:  br $m10
define i32 @lshr_10_i32(i32 %x) {
  %res = lshr i32 %x, 10
  ret i32 %res
}

; CHECK-LABEL: lshr_11_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shr $m0, $m0, 11
; CHECK-NEXT:  br $m10
define i32 @lshr_11_i32(i32 %x) {
  %res = lshr i32 %x, 11
  ret i32 %res
}

; CHECK-LABEL: lshr_12_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shr $m0, $m0, 12
; CHECK-NEXT:  br $m10
define i32 @lshr_12_i32(i32 %x) {
  %res = lshr i32 %x, 12
  ret i32 %res
}

; CHECK-LABEL: lshr_13_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shr $m0, $m0, 13
; CHECK-NEXT:  br $m10
define i32 @lshr_13_i32(i32 %x) {
  %res = lshr i32 %x, 13
  ret i32 %res
}

; CHECK-LABEL: lshr_14_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shr $m0, $m0, 14
; CHECK-NEXT:  br $m10
define i32 @lshr_14_i32(i32 %x) {
  %res = lshr i32 %x, 14
  ret i32 %res
}

; CHECK-LABEL: lshr_15_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shr $m0, $m0, 15
; CHECK-NEXT:  br $m10
define i32 @lshr_15_i32(i32 %x) {
  %res = lshr i32 %x, 15
  ret i32 %res
}

; CHECK-LABEL: lshr_16_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shr $m0, $m0, 16
; CHECK-NEXT:  br $m10
define i32 @lshr_16_i32(i32 %x) {
  %res = lshr i32 %x, 16
  ret i32 %res
}

; CHECK-LABEL: lshr_17_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shr $m0, $m0, 17
; CHECK-NEXT:  br $m10
define i32 @lshr_17_i32(i32 %x) {
  %res = lshr i32 %x, 17
  ret i32 %res
}

; CHECK-LABEL: lshr_18_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shr $m0, $m0, 18
; CHECK-NEXT:  br $m10
define i32 @lshr_18_i32(i32 %x) {
  %res = lshr i32 %x, 18
  ret i32 %res
}

; CHECK-LABEL: lshr_19_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shr $m0, $m0, 19
; CHECK-NEXT:  br $m10
define i32 @lshr_19_i32(i32 %x) {
  %res = lshr i32 %x, 19
  ret i32 %res
}

; CHECK-LABEL: lshr_20_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shr $m0, $m0, 20
; CHECK-NEXT:  br $m10
define i32 @lshr_20_i32(i32 %x) {
  %res = lshr i32 %x, 20
  ret i32 %res
}

; CHECK-LABEL: lshr_21_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shr $m0, $m0, 21
; CHECK-NEXT:  br $m10
define i32 @lshr_21_i32(i32 %x) {
  %res = lshr i32 %x, 21
  ret i32 %res
}

; CHECK-LABEL: lshr_22_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shr $m0, $m0, 22
; CHECK-NEXT:  br $m10
define i32 @lshr_22_i32(i32 %x) {
  %res = lshr i32 %x, 22
  ret i32 %res
}

; CHECK-LABEL: lshr_23_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shr $m0, $m0, 23
; CHECK-NEXT:  br $m10
define i32 @lshr_23_i32(i32 %x) {
  %res = lshr i32 %x, 23
  ret i32 %res
}

; CHECK-LABEL: lshr_24_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shr $m0, $m0, 24
; CHECK-NEXT:  br $m10
define i32 @lshr_24_i32(i32 %x) {
  %res = lshr i32 %x, 24
  ret i32 %res
}

; CHECK-LABEL: lshr_25_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shr $m0, $m0, 25
; CHECK-NEXT:  br $m10
define i32 @lshr_25_i32(i32 %x) {
  %res = lshr i32 %x, 25
  ret i32 %res
}

; CHECK-LABEL: lshr_26_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shr $m0, $m0, 26
; CHECK-NEXT:  br $m10
define i32 @lshr_26_i32(i32 %x) {
  %res = lshr i32 %x, 26
  ret i32 %res
}

; CHECK-LABEL: lshr_27_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shr $m0, $m0, 27
; CHECK-NEXT:  br $m10
define i32 @lshr_27_i32(i32 %x) {
  %res = lshr i32 %x, 27
  ret i32 %res
}

; CHECK-LABEL: lshr_28_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shr $m0, $m0, 28
; CHECK-NEXT:  br $m10
define i32 @lshr_28_i32(i32 %x) {
  %res = lshr i32 %x, 28
  ret i32 %res
}

; CHECK-LABEL: lshr_29_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shr $m0, $m0, 29
; CHECK-NEXT:  br $m10
define i32 @lshr_29_i32(i32 %x) {
  %res = lshr i32 %x, 29
  ret i32 %res
}

; CHECK-LABEL: lshr_30_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shr $m0, $m0, 30
; CHECK-NEXT:  br $m10
define i32 @lshr_30_i32(i32 %x) {
  %res = lshr i32 %x, 30
  ret i32 %res
}

; CHECK-LABEL: lshr_31_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shr $m0, $m0, 31
; CHECK-NEXT:  br $m10
define i32 @lshr_31_i32(i32 %x) {
  %res = lshr i32 %x, 31
  ret i32 %res
}

; CHECK-LABEL: ashr_1_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shrs $m0, $m0, 1
; CHECK-NEXT:  br $m10
define i32 @ashr_1_i32(i32 %x) {
  %res = ashr i32 %x, 1
  ret i32 %res
}

; CHECK-LABEL: ashr_2_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shrs $m0, $m0, 2
; CHECK-NEXT:  br $m10
define i32 @ashr_2_i32(i32 %x) {
  %res = ashr i32 %x, 2
  ret i32 %res
}

; CHECK-LABEL: ashr_3_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shrs $m0, $m0, 3
; CHECK-NEXT:  br $m10
define i32 @ashr_3_i32(i32 %x) {
  %res = ashr i32 %x, 3
  ret i32 %res
}

; CHECK-LABEL: ashr_4_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shrs $m0, $m0, 4
; CHECK-NEXT:  br $m10
define i32 @ashr_4_i32(i32 %x) {
  %res = ashr i32 %x, 4
  ret i32 %res
}

; CHECK-LABEL: ashr_5_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shrs $m0, $m0, 5
; CHECK-NEXT:  br $m10
define i32 @ashr_5_i32(i32 %x) {
  %res = ashr i32 %x, 5
  ret i32 %res
}

; CHECK-LABEL: ashr_6_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shrs $m0, $m0, 6
; CHECK-NEXT:  br $m10
define i32 @ashr_6_i32(i32 %x) {
  %res = ashr i32 %x, 6
  ret i32 %res
}

; CHECK-LABEL: ashr_7_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shrs $m0, $m0, 7
; CHECK-NEXT:  br $m10
define i32 @ashr_7_i32(i32 %x) {
  %res = ashr i32 %x, 7
  ret i32 %res
}

; CHECK-LABEL: ashr_8_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shrs $m0, $m0, 8
; CHECK-NEXT:  br $m10
define i32 @ashr_8_i32(i32 %x) {
  %res = ashr i32 %x, 8
  ret i32 %res
}

; CHECK-LABEL: ashr_9_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shrs $m0, $m0, 9
; CHECK-NEXT:  br $m10
define i32 @ashr_9_i32(i32 %x) {
  %res = ashr i32 %x, 9
  ret i32 %res
}

; CHECK-LABEL: ashr_10_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shrs $m0, $m0, 10
; CHECK-NEXT:  br $m10
define i32 @ashr_10_i32(i32 %x) {
  %res = ashr i32 %x, 10
  ret i32 %res
}

; CHECK-LABEL: ashr_11_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shrs $m0, $m0, 11
; CHECK-NEXT:  br $m10
define i32 @ashr_11_i32(i32 %x) {
  %res = ashr i32 %x, 11
  ret i32 %res
}

; CHECK-LABEL: ashr_12_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shrs $m0, $m0, 12
; CHECK-NEXT:  br $m10
define i32 @ashr_12_i32(i32 %x) {
  %res = ashr i32 %x, 12
  ret i32 %res
}

; CHECK-LABEL: ashr_13_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shrs $m0, $m0, 13
; CHECK-NEXT:  br $m10
define i32 @ashr_13_i32(i32 %x) {
  %res = ashr i32 %x, 13
  ret i32 %res
}

; CHECK-LABEL: ashr_14_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shrs $m0, $m0, 14
; CHECK-NEXT:  br $m10
define i32 @ashr_14_i32(i32 %x) {
  %res = ashr i32 %x, 14
  ret i32 %res
}

; CHECK-LABEL: ashr_15_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shrs $m0, $m0, 15
; CHECK-NEXT:  br $m10
define i32 @ashr_15_i32(i32 %x) {
  %res = ashr i32 %x, 15
  ret i32 %res
}

; CHECK-LABEL: ashr_16_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shrs $m0, $m0, 16
; CHECK-NEXT:  br $m10
define i32 @ashr_16_i32(i32 %x) {
  %res = ashr i32 %x, 16
  ret i32 %res
}

; CHECK-LABEL: ashr_17_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shrs $m0, $m0, 17
; CHECK-NEXT:  br $m10
define i32 @ashr_17_i32(i32 %x) {
  %res = ashr i32 %x, 17
  ret i32 %res
}

; CHECK-LABEL: ashr_18_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shrs $m0, $m0, 18
; CHECK-NEXT:  br $m10
define i32 @ashr_18_i32(i32 %x) {
  %res = ashr i32 %x, 18
  ret i32 %res
}

; CHECK-LABEL: ashr_19_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shrs $m0, $m0, 19
; CHECK-NEXT:  br $m10
define i32 @ashr_19_i32(i32 %x) {
  %res = ashr i32 %x, 19
  ret i32 %res
}

; CHECK-LABEL: ashr_20_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shrs $m0, $m0, 20
; CHECK-NEXT:  br $m10
define i32 @ashr_20_i32(i32 %x) {
  %res = ashr i32 %x, 20
  ret i32 %res
}

; CHECK-LABEL: ashr_21_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shrs $m0, $m0, 21
; CHECK-NEXT:  br $m10
define i32 @ashr_21_i32(i32 %x) {
  %res = ashr i32 %x, 21
  ret i32 %res
}

; CHECK-LABEL: ashr_22_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shrs $m0, $m0, 22
; CHECK-NEXT:  br $m10
define i32 @ashr_22_i32(i32 %x) {
  %res = ashr i32 %x, 22
  ret i32 %res
}

; CHECK-LABEL: ashr_23_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shrs $m0, $m0, 23
; CHECK-NEXT:  br $m10
define i32 @ashr_23_i32(i32 %x) {
  %res = ashr i32 %x, 23
  ret i32 %res
}

; CHECK-LABEL: ashr_24_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shrs $m0, $m0, 24
; CHECK-NEXT:  br $m10
define i32 @ashr_24_i32(i32 %x) {
  %res = ashr i32 %x, 24
  ret i32 %res
}

; CHECK-LABEL: ashr_25_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shrs $m0, $m0, 25
; CHECK-NEXT:  br $m10
define i32 @ashr_25_i32(i32 %x) {
  %res = ashr i32 %x, 25
  ret i32 %res
}

; CHECK-LABEL: ashr_26_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shrs $m0, $m0, 26
; CHECK-NEXT:  br $m10
define i32 @ashr_26_i32(i32 %x) {
  %res = ashr i32 %x, 26
  ret i32 %res
}

; CHECK-LABEL: ashr_27_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shrs $m0, $m0, 27
; CHECK-NEXT:  br $m10
define i32 @ashr_27_i32(i32 %x) {
  %res = ashr i32 %x, 27
  ret i32 %res
}

; CHECK-LABEL: ashr_28_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shrs $m0, $m0, 28
; CHECK-NEXT:  br $m10
define i32 @ashr_28_i32(i32 %x) {
  %res = ashr i32 %x, 28
  ret i32 %res
}

; CHECK-LABEL: ashr_29_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shrs $m0, $m0, 29
; CHECK-NEXT:  br $m10
define i32 @ashr_29_i32(i32 %x) {
  %res = ashr i32 %x, 29
  ret i32 %res
}

; CHECK-LABEL: ashr_30_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shrs $m0, $m0, 30
; CHECK-NEXT:  br $m10
define i32 @ashr_30_i32(i32 %x) {
  %res = ashr i32 %x, 30
  ret i32 %res
}

; CHECK-LABEL: ashr_31_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shrs $m0, $m0, 31
; CHECK-NEXT:  br $m10
define i32 @ashr_31_i32(i32 %x) {
  %res = ashr i32 %x, 31
  ret i32 %res
}

; CHECK-LABEL: shl_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shl $m0, $m0, $m1
; CHECK-NEXT:  br $m10
define i32 @shl_i32(i32 %x, i32 %y) {
  %res = shl i32 %x, %y
  ret i32 %res
}

; CHECK-LABEL: lshr_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shr $m0, $m0, $m1
; CHECK-NEXT:  br $m10
define i32 @lshr_i32(i32 %x, i32 %y) {
  %res = lshr i32 %x, %y
  ret i32 %res
}

; CHECK-LABEL: ashr_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shrs $m0, $m0, $m1
; CHECK-NEXT:  br $m10
define i32 @ashr_i32(i32 %x, i32 %y) {
  %res = ashr i32 %x, %y
  ret i32 %res
}

; CHECK-LABEL: shl_v2i32:
; CHECK:       # %bb.0:
; CHECK-DAG:   shl $m0, $m0, $m2
; CHECK-DAG:   shl $m1, $m1, $m3
; CHECK-NEXT:  br $m10
define <2 x i32> @shl_v2i32(<2 x i32> %x, <2 x i32> %y) {
  %res = shl <2 x i32> %x, %y
  ret <2 x i32> %res
}

; CHECK-LABEL: lshr_v2i32:
; CHECK:       # %bb.0:
; CHECK-DAG:   shr $m0, $m0, $m2
; CHECK-DAG:   shr $m1, $m1, $m3
; CHECK-NEXT:  br $m10
define <2 x i32> @lshr_v2i32(<2 x i32> %x, <2 x i32> %y) {
  %res = lshr <2 x i32> %x, %y
  ret <2 x i32> %res
}

; CHECK-LABEL: ashr_v2i32:
; CHECK:       # %bb.0:
; CHECK-DAG:   shrs $m0, $m0, $m2
; CHECK-DAG:   shrs $m1, $m1, $m3
; CHECK-NEXT:  br $m10
define <2 x i32> @ashr_v2i32(<2 x i32> %x, <2 x i32> %y) {
  %res = ashr <2 x i32> %x, %y
  ret <2 x i32> %res
}

; CHECK-LABEL: shl_v2i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  sort4x16lo [[LO1:\$m[0-9]+]], $m1, $m15
; CHECK-NEXT:  sort4x16hi [[HI1:\$m[0-9]+]], $m1, $m15
; CHECK-NEXT:  shl [[LO1]], $m0, [[LO1]]
; CHECK-NEXT:  swap16 [[HI0:\$m[0-9]+]], [[HI0]]
; CHECK-NEXT:  shl $m0, [[HI0]], [[HI1]]
; CHECK-NEXT:  sort4x16lo $m0, $m2, $m0
; CHECK-NEXT:  br $m10
define <2 x i16> @shl_v2i16(<2 x i16> %x, <2 x i16> %y) {
  %res = shl <2 x i16> %x, %y
  ret <2 x i16> %res
}

; CHECK-LABEL: lshr_v2i16:
; CHECK:       # %bb.0:
; CHECK-DAG:   sort4x16hi [[HI1:\$m[2-9]+]], $m1, $m15
; CHECK-DAG:   sort4x16hi [[HI0:\$m[2-9]+]], $m0, $m15
; CHECK-DAG:   sort4x16lo [[LO1:\$m[0-9]+]], $m1, $m15
; CHECK-DAG:   sort4x16lo [[LO0:\$m[0-9]+]], $m0, $m15
; CHECK:       shr $m2, [[HI0]], [[HI1]]
; CHECK-NEXT:  shr $m0, [[LO0]], [[LO1]]
; CHECK-NEXT:  sort4x16lo $m0, $m0, $m2
; CHECK-NEXT:  br $m10
define <2 x i16> @lshr_v2i16(<2 x i16> %x, <2 x i16> %y) {
  %res = lshr <2 x i16> %x, %y
  ret <2 x i16> %res
}

; CHECK-LABEL: ashr_v2i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shl [[LO_SEXT:\$m[0-9]+]], $m0, 16
; CHECK-NEXT:  sort4x16hi [[HI_BY:\$m[0-9]+]], $m1, $m15
; CHECK-NEXT:  shrs [[HI_SEXT:\$m[0-9]+]], $m0, 16
; CHECK-NEXT:  sort4x16lo [[LO_BY:\$m[0-9]+]], $m1, $m15
; CHECK-NEXT:  shrs [[LO_SEXT]], [[LO_SEXT]], 16
; CHECK-NEXT:  shrs [[HI_RES:\$m[0-9]+]], [[HI_SEXT]], [[HI_BY]]
; CHECK-NEXT:  shrs [[LO_RES:\$m[0-9]+]], [[LO_SEXT]], [[LO_BY]]
; CHECK-NEXT:  sort4x16lo $m0, [[LO_RES]], [[HI_RES]]
; CHECK-NEXT:  br $m10
define <2 x i16> @ashr_v2i16(<2 x i16> %x, <2 x i16> %y) {
  %res = ashr <2 x i16> %x, %y
  ret <2 x i16> %res
}

; CHECK-LABEL: shl_v4i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  sort4x16lo [[REG0:\$m[0-9]+]], $m3, $m15
; CHECK-NEXT:  sort4x16hi [[REG1:\$m[0-9]+]], $m3, $m15
; CHECK-NEXT:  swap16 [[REG3:\$m[0-9]+]], $m1
; CHECK-NEXT:  shl [[REG4:\$m[0-9]+]], $m1, [[REG0]]
; CHECK-NEXT:  shl [[REG5:\$m[0-9]+]], [[REG3]], [[REG1]]
; CHECK-NEXT:  sort4x16lo [[REG6:\$m[0-9]+]], $m2, $m15
; CHECK-NEXT:  sort4x16hi [[REG7:\$m[0-9]+]], $m2, $m15
; CHECK-NEXT:  swap16 [[REG8:\$m[0-9]+]], $m0
; CHECK-NEXT:  sort4x16lo $m1, [[REG4]], [[REG5]]
; CHECK-NEXT:  shl [[REG9:\$m[0-9]+]], $m0, [[REG6]]
; CHECK-NEXT:  shl [[REG10:\$m[0-9]+]], [[REG8]], [[REG7]]
; CHECK-NEXT:  sort4x16lo $m0, [[REG9]], [[REG10]]
; CHECK-NEXT:  br $m10
define <4 x i16> @shl_v4i16(<4 x i16> %x, <4 x i16> %y) {
  %res = shl <4 x i16> %x, %y
  ret <4 x i16> %res
}

; CHECK-LABEL: lshr_v4i16:
; CHECK:       # %bb.0:
; First the top half
; CHECK-NEXT:  sort4x16hi [[HI3:\$m[0-9]+]], $m3, $m15
; CHECK-NEXT:  sort4x16hi [[HI1:\$m[0-9]+]], $m1, $m15
; CHECK-NEXT:  sort4x16lo [[LO3:\$m[0-9]+]], $m3, $m15
; CHECK-NEXT:  sort4x16lo [[LO1:\$m[0-9]+]], $m1, $m15
; CHECK-NEXT:  shr $m4, [[HI1]], [[HI3]]
; CHECK-NEXT:  shr $m1, [[LO1]], [[LO3]]
; Then the low half
; CHECK-NEXT:  sort4x16hi [[HI2:\$m[0-9]+]], $m2, $m15
; CHECK-NEXT:  sort4x16hi [[HI0:\$m[0-9]+]], $m0, $m15
; CHECK-NEXT:  sort4x16lo [[LO2:\$m[0-9]+]], $m2, $m15
; CHECK-NEXT:  sort4x16lo [[LO0:\$m[0-9]+]], $m0, $m15
; Combine
; CHECK-NEXT:  sort4x16lo $m1, $m1, $m4
; CHECK-NEXT:  shr $m3, [[HI0]], [[HI2]]
; CHECK-NEXT:  shr $m0, [[LO0]], [[LO2]]
; CHECK-NEXT:  sort4x16lo $m0, $m0, $m3
; CHECK-NEXT:  br $m10
define <4 x i16> @lshr_v4i16(<4 x i16> %x, <4 x i16> %y) {
  %res = lshr <4 x i16> %x, %y
  ret <4 x i16> %res
}

; CHECK-LABEL: ashr_v4i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  shl [[I2_SEXT:\$m[0-9]+]], $m1, 16
; CHECK-NEXT:  sort4x16hi [[I3_BY:\$m[0-9]+]], $m3, $m15
; CHECK-NEXT:  shrs [[I3_SEXT:\$m[0-9]+]], $m1, 16
; CHECK-NEXT:  sort4x16lo [[I2_BY:\$m[0-9]+]], $m3, $m15
; CHECK-NEXT:  shrs [[I2_SEXT]], [[I2_SEXT]], 16
; CHECK-NEXT:  shrs [[I3_RES:\$m[0-9]+]], [[I3_SEXT]], [[I3_BY]]
; CHECK-NEXT:  shl [[I0_SEXT:\$m[0-9]+]], $m0, 16
; CHECK-NEXT:  shrs [[I2_RES:\$m[0-9]+]], [[I2_SEXT]], [[I2_BY]]
; CHECK-NEXT:  sort4x16hi [[I1_BY:\$m[0-9]+]], $m2, $m15
; CHECK-NEXT:  shrs [[I1_SEXT:\$m[0-9]+]], $m0, 16
; CHECK-NEXT:  sort4x16lo [[I0_BY:\$m[0-9]+]], $m2, $m15
; CHECK-NEXT:  shrs [[I0_SEXT]], [[I0_SEXT]], 16
; CHECK-NEXT:  sort4x16lo $m1, [[I2_RES]], [[I3_RES]]
; CHECK-NEXT:  shrs [[I1_RES:\$m[0-9]+]], [[I1_SEXT]], [[I1_BY]]
; CHECK-NEXT:  shrs [[I0_RES:\$m[0-9]+]], [[I0_SEXT]], [[I0_BY]]
; CHECK-NEXT:  sort4x16lo $m0, [[I0_RES]], [[I1_RES]]
; CHECK-NEXT:  br $m10
define <4 x i16> @ashr_v4i16(<4 x i16> %x, <4 x i16> %y) {
  %res = ashr <4 x i16> %x, %y
  ret <4 x i16> %res
}
