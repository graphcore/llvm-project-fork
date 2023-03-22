; RUN: llc < %s -march=colossus -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -march=colossus -mattr=+ipu2 | FileCheck %s

; These bitcasts are also just A -> and M -> A register file moves.

; A -> M
; CHECK-LABEL: float_to_i32:
; CHECK:       mov $m0, $a0
; CHECK:       br
define i32 @float_to_i32(float %v1) {
  %res = bitcast float %v1 to i32
  ret i32 %res
}

; M -> A
; CHECK-LABEL: i32_to_float:
; CHECK:       add
; CHECK:       st32 $m0
; CHECK-NEXT:  ld32 $a0
; CHECK-NEXT:  add
; CHECK:       br
define float @i32_to_float(i32 %v1) {
  %res = bitcast i32 %v1 to float
  ret float %res
}

; TODO

;%v2i32 = type <2 x i32>
;%v2f32 = type <2 x float>

; AA -> MM
;define %v2i32 @v2f32_to_v2i32(%v2f32 %v1) {
;  %res = bitcast %v2f32 %v1 to %v2i32
;  ret %v2i32 %res
;}

; MM -> AA
;define %v2f32 @v2f32_to_v2i32(%v2i32 %v1) {
;  %res = bitcast %v2i32 %v1 to %v2f32
;  ret %v2f32 %res
;}

; A -> MM

; M -> AA
