; RUN: llc -march=colossus -colossus-coissue=false %s -mattr=+ipu1 -o - | FileCheck %s
; RUN: llc -march=colossus -colossus-coissue=false %s -mattr=+ipu2 -o - | FileCheck %s

; CHECK-LABEL: v8f16_const_init_85:
; CHECK:      # %bb.0:
; CHECK:      not64 $a0:1, $a14:15
; CHECK:      mov     $a2:3, $a0:1
; CHECK:      br $m10
define <8 x half> @v8f16_const_init_85() {
	  ret <8 x half> <half undef, half undef, half undef, half 0xHFFFF, half undef, half undef, half 0xHFFFF, half undef>
}
