; RUN: llc < %s -march=colossus -mattr=+ipu1 -colossus-vertex-red-zone-size=-1 | FileCheck %s -check-prefix=RZ_m1
; RUN: llc < %s -march=colossus -mattr=+ipu1 -colossus-vertex-red-zone-size=7 | FileCheck %s -check-prefix=RZ_7
; RUN: llc < %s -march=colossus -mattr=+ipu1 -colossus-vertex-red-zone-size=9 | FileCheck %s -check-prefix=RZ_9
; RUN: llc < %s -march=colossus -mattr=+ipu1 -colossus-vertex-red-zone-size=15 | FileCheck %s -check-prefix=RZ_15
; RUN: llc < %s -march=colossus -mattr=+ipu1 -colossus-vertex-red-zone-size=65536 | FileCheck %s -check-prefix=RZ_L

; RUN: llc < %s -march=colossus -mattr=+ipu2 -colossus-vertex-red-zone-size=-1 | FileCheck %s -check-prefix=RZ_m1
; RUN: llc < %s -march=colossus -mattr=+ipu2 -colossus-vertex-red-zone-size=7 | FileCheck %s -check-prefix=RZ_7
; RUN: llc < %s -march=colossus -mattr=+ipu2 -colossus-vertex-red-zone-size=9 | FileCheck %s -check-prefix=RZ_9
; RUN: llc < %s -march=colossus -mattr=+ipu2 -colossus-vertex-red-zone-size=15 | FileCheck %s -check-prefix=RZ_15
; RUN: llc < %s -march=colossus -mattr=+ipu2 -colossus-vertex-red-zone-size=65536 | FileCheck %s -check-prefix=RZ_L


; Negative redzone is treated as zero
; RZ_m1-LABEL: func:
; RZ_m1:       add $m11, $m12, -16
; RZ_m1:       exitnz $m15

; Redzone size rounded down to nearest multiple of 8
; RZ_7-LABEL:  func:
; RZ_7:        add $m11, $m12, -16
; RZ_7:        exitnz $m15
; RZ_9-LABEL:  func:
; RZ_9:        add $m11, $m12, -8
; RZ_9:        exitnz $m15
; RZ_15-LABEL: func:
; RZ_15:       add $m11, $m12, -8
; RZ_15:       exitnz $m15

; At most 8 bytes above $m12 to keep worker overflow checks working
; RZ_L-LABEL:  func:
; RZ_L:        add $m11, $m12, 8
; RZ_L:        exitnz $m15
define colossus_vertex i32 @func() {
  %a = alloca i32, i32 4
  call void asm sideeffect "# Use stack object", "r"(i32* %a)
  ret i32 0
}
