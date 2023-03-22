; RUN: llc < %s -march=colossus -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -march=colossus -mattr=+ipu2 | FileCheck %s

; CHECK-LABEL: addr_g1
; CHECK:       setzi $m0, g1
define i32 *@addr_g1() {
	ret i32* @g1
}

; CHECK-LABEL: addr_g2
; CHECK:       setzi $m0, g2
define i32 *@addr_g2() {
	ret i32* @g2
}

; CHECK: .data
; CHECK: g1:
@g1 = global i32 4712

; CHECK: .bss
; CHECK: g2:
@g2 = global i32 0
