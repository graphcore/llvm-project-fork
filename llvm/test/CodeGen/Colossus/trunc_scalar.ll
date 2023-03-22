; RUN: llc < %s -march=colossus -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -march=colossus -mattr=+ipu2 | FileCheck %s

; CHECK-LABEL: i64_to_i32:
; CHECK: 	     br $m10
define i32 @i64_to_i32(i64 %x) {
  %y = trunc i64 %x to i32
  ret i32 %y
}

; CHECK-LABEL: i64_to_i16:
; CHECK: 	     br $m10
define i16 @i64_to_i16(i64 %x) {
  %y = trunc i64 %x to i16
  ret i16 %y
}

; CHECK-LABEL: i64_to_i8:
; CHECK: 	     br $m10
define i8 @i64_to_i8(i64 %x) {
  %y = trunc i64 %x to i8
  ret i8 %y
}

; CHECK-LABEL: i32_to_i16:
; CHECK: 	     br $m10
define i16 @i32_to_i16(i32 %x) {
  %y = trunc i32 %x to i16
  ret i16 %y
}

; CHECK-LABEL: i32_to_i8:
; CHECK: 	     br $m10
define i8 @i32_to_i8(i32 %x) {
  %y = trunc i32 %x to i8
  ret i8 %y
}

; CHECK-LABEL: float_to_half:
; CHECK: 	     {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f32tof16 $a0, $a0
; CHECK-NEXT:  }
define half @float_to_half(float %x) {
  %y = fptrunc float %x to half
  ret half %y
}

; CHECK-LABEL: i16_to_i8:
; CHECK: 	     br $m10
define i8 @i16_to_i8(i16 %x) {
  %y = trunc i16 %x to i8
  ret i8 %y
}

