; RUN: llc < %s -mtriple=colossus -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -mtriple=colossus -mattr=+ipu2 | FileCheck %s

; TODO:
;  sitofp <4 x i16> %a to <4 x half> %b
;  uitofp <4 x i16> %a to <4 x half> %b

;===------------------------------------------------------------------------===;
; Bitcasts.
;===------------------------------------------------------------------------===;

; CHECK-LABEL: test_bitcast_from_v4i16:
; CHECK:       st32
; CHECK:       st32
; CHECK:       ld64
define <4 x half> @test_bitcast_from_v4i16(<4 x i16> %a) {
  %res = bitcast <4 x i16> %a to <4 x half>
  ret <4 x half> %res
}

; CHECK-LABEL: test_bitcast_to_v4i16:
; CHECK:       mov
; CHECK:       mov
define <4 x i16> @test_bitcast_to_v4i16(<4 x half> %a) {
  %res = bitcast <4 x half> %a to <4 x i16>
  ret <4 x i16> %res
}
