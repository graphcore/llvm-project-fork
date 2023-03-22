; RUN: llc < %s -march=colossus -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -march=colossus -mattr=+ipu2 | FileCheck %s

; CHECK-LABEL: const0:
; CHECK:       mov $m0, $m15
; CHECK:       br $m10
define i32 @const0() {
  ret i32 0
}

; CHECK-LABEL: const0f:
; CHECK:       {
; CHECK:       br $m10
; CHECK:       mov $a0, $a15
; CHECK:       }
define float @const0f() {
  ret float 0.0
}

; CHECK-LABEL: const0v2i16:
; CHECK:       mov $m0, $m15
; CHECK:       br $m10
define <2 x i16> @const0v2i16() {
  ret <2 x i16> <i16 0, i16 0>
}

; Test 20-bit immediate.

; CHECK-LABEL: const20:
; CHECK:       setzi $m0, 1
; CHECK:       br $m10
define i32 @const20() {
  ret i32 1
}

; CHECK-LABEL: const20v2i16:
; CHECK:       setzi $m0, 983044
; CHECK:       br $m10
define <2 x i16> @const20v2i16() {
  ret <2 x i16> <i16 4, i16 15>
}

; Test 20-bit half immediate.
; CHECK-LABEL: const20h:
; CHECK:       {
; CHECK:       br $m10
; CHECK:       setzi $a0, 1
; CHECK:       }
define half @const20h() {
  %flt = bitcast i16 1 to half
  ret half %flt
}

; Test zero half immediate.
; CHECK-LABEL: const0h:
; CHECK:       {
; CHECK:       br $m10
; CHECK:       mov $a0, $a15
; CHECK:       }
define half @const0h() {
  %flt = bitcast i16 0 to half
  ret half %flt
}

; Test 20-bit float immediate.
; CHECK-LABEL: const20f:
; CHECK:       {
; CHECK:       br $m10
; CHECK:       setzi $a0, 1
; CHECK:       }
define float @const20f() {
  %flt = bitcast i32 1 to float
  ret float %flt
}

; Test > 20-bit constant.
; CHECK-LABEL: const32:
; CHECK:       setzi $m0, 811342
; CHECK-NEXT:  or $m0, $m0, 11534336
; CHECK:       br $m10
define i32 @const32() {
  ret i32 12345678
}

; Test > 20-bit half immediate.
; CHECK-LABEL: const32h:
; CHECK:       {
; CHECK:       br $m10
; CHECK:       setzi $a0, 16
; CHECK:       }
define half @const32h() {
  %flt = bitcast i16 16 to half
  ret half %flt
}

; Test > 20-bit float constant.
; CHECK-LABEL: const32f:
; CHECK:       setzi $a0, 811342
; CHECK:       {
; CHECK:       br $m10
; CHECK:       or $a0, $a0, 11534336
; CHECK:       }
define float @const32f() {
  %flt = bitcast i32 12345678 to float
  ret float %flt
}

; Test < 16-bit negative constant.
; CHECK-LABEL: constlt16n:
; CHECK:       add $m0, $m15, -4
; CHECK:       br $m10
define i32 @constlt16n() {
  ret i32 -4
}

; Test 16-bit negative constant.
; CHECK-LABEL: const16n:
; CHECK:       add $m0, $m15, -32768
; CHECK:       br $m10
define i32 @const16n() {
  ret i32 -32768
}

; Test > 16-bit negative constant.
; CHECK-LABEL: constgt16n:
; CHECK:       setzi $m0, 1015807
; CHECK-NEXT:  or $m0, $m0, 4293918720
; CHECK-NEXT:  br $m10
define i32 @constgt16n() {
  ret i32 -32769
}

; Test 64-bit constant (2**48-1).
; CHECK-LABEL: const64_ones:
; CHECK:       add $m0, $m15, -1
; CHECK-NEXT:  setzi $m1, 65535
; CHECK-NEXT:  br $m10
define i64 @const64_ones() {
  ret i64 281474976710655
}

; Test 64-bit constant (not all ones).
; CHECK-LABEL: const64:
; CHECK:       setzi $m1, 699050
; CHECK-NEXT:  or $m0, $m1, 2862612480
; CHECK-NEXT:  or $m1, $m1, 178257920
define i64 @const64() {
  ret i64 768614336404564650
}

; Test float constant.
; CHECK-LABEL: float_const:
; CHECK:       {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  or $a0, $a15, 3212836864
; CHECK:       }
define float @float_const() {
  ret float -1.0
}

; CHECK-LABEL: all_bits_set_float:
; CHECK:       {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  not $a0, $a15
; CHECK:       }
define float @all_bits_set_float() {
 %m1 = bitcast i32 -1 to float
 ret float %m1
}

; Test v2f16 constants
; CHECK-LABEL: v2f16_const_20bit:
; CHECK:       {
; CHECK-NEXT:  br $m10
; CHECK:       setzi $a0, 1048284
; CHECK:       }
define <2 x half> @v2f16_const_20bit() {
  ret <2 x half> <half 0xHFEDC, half 0xHF>
}

; CHECK-LABEL: v2f16_const_32bit:
; CHECK:       setzi $a0, 983039
; CHECK:       {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  or $a0, $a0, 4007657472
; CHECK:       }
define <2 x half> @v2f16_const_32bit() {
  ret <2 x half> <half 0xHFFFF, half 0xHEEEE>
}

; Test double constant.
; CHECK-LABEL: double_const:
; CHECK-DAG:   mov $m0, $m15
; CHECK-DAG:   or $m1, $m15, 3220176896
; CHECK-NEXT:  br $m10
define double @double_const() {
  ret double -1.0
}

; CHECK: .section  .NAMEDSECT,"a",@progbits
; CHECK: .globl  gc1
; CHECK: .p2align  1
; CHECK: size gc1, 4
@gc1 = constant i32 0, section ".NAMEDSECT", align 2
