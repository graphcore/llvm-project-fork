; RUN: llc < %s -mtriple=colossus -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -mtriple=colossus -mattr=+ipu2 | FileCheck %s
; The following test cases check the values +/- 2 either side of
; side of when the argument changes between 12, 20, 32 bits.

; CHECK-LABEL: and_0x00000000:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov  $m0, $m15
; CHECK-NEXT:  br $m10
define i32 @and_0x00000000(i32 %x) {
  %res = and i32 %x, 0
  ret i32 %res
}

; CHECK-LABEL: and_0xFFFFFFFF:
; CHECK:       # %bb.0:
; CHECK-NEXT:  br $m10
define i32 @and_0xFFFFFFFF(i32 %x) {
  %res = and i32 %x, 4294967295
  ret i32 %x
}

; CHECK-LABEL: and_0x00000FFE:
; CHECK:       # %bb.0:
; CHECK-NEXT:  and $m0, $m0, 4094
; CHECK-NEXT:  br $m10
define i32 @and_0x00000FFE(i32 %x) {
  %res = and i32 %x, 4094
  ret i32 %res
}

; CHECK-LABEL: and_0x00000FFF:
; CHECK:       # %bb.0:
; CHECK-NEXT:  and $m0, $m0, 4095
; CHECK-NEXT:  br $m10
define i32 @and_0x00000FFF(i32 %x) {
  %res = and i32 %x, 4095
  ret i32 %res
}

; CHECK-LABEL: and_0x00001000:
; CHECK:       # %bb.0:
; CHECK-NEXT:  setzi [[REG:\$m[1-9]+]], 4096
; CHECK-NEXT:  and $m0, $m0, [[REG]]
; CHECK-NEXT:  br $m10
define i32 @and_0x00001000(i32 %x) {
  %res = and i32 %x, 4096
  ret i32 %res
}

; CHECK-LABEL: and_0x00001001:
; CHECK:       # %bb.0:
; CHECK-NEXT:  setzi [[REG:\$m[1-9]+]], 4097
; CHECK-NEXT:  and $m0, $m0, [[REG]]
; CHECK-NEXT:  br $m10
define i32 @and_0x00001001(i32 %x) {
  %res = and i32 %x, 4097
  ret i32 %res
}

; CHECK-LABEL: and_0x00001002:
; CHECK:       # %bb.0:
; CHECK-NEXT:  setzi [[REG:\$m[1-9]+]], 4098
; CHECK-NEXT:  and $m0, $m0, [[REG]]
; CHECK-NEXT:  br $m10
define i32 @and_0x00001002(i32 %x) {
  %res = and i32 %x, 4098
  ret i32 %res
}

; CHECK-LABEL: and_0x000FFFFE:
; CHECK:       # %bb.0:
; CHECK-NEXT:  setzi [[REG:\$m[1-9]+]], 1048574
; CHECK-NEXT:  and $m0, $m0, [[REG]]
; CHECK-NEXT:  br $m10
define i32 @and_0x000FFFFE(i32 %x) {
  %res = and i32 %x, 1048574
  ret i32 %res
}

; CHECK-LABEL: and_0x000FFFFF:
; CHECK:       # %bb.0:
; CHECK-NEXT:  setzi [[REG:\$m[1-9]+]], 1048575
; CHECK-NEXT:  and $m0, $m0, [[REG]]
; CHECK-NEXT:  br $m10
define i32 @and_0x000FFFFF(i32 %x) {
  %res = and i32 %x, 1048575
  ret i32 %res
}

; CHECK-LABEL: and_0x00100000:
; CHECK:       # %bb.0:
; CHECK-NEXT:  or [[REGB:\$m[1-9]+]], $m15, 1048576
; CHECK-NEXT:  and $m0, $m0, [[REGB]]
; CHECK-NEXT:  br $m10
define i32 @and_0x00100000(i32 %x) {
  %res = and i32 %x, 1048576
  ret i32 %res
}

; CHECK-LABEL: and_0x00100001:
; CHECK:       # %bb.0:
; CHECK-NEXT:  setzi [[REGA:\$m[1-9]+]], 1
; CHECK-NEXT:  or [[REGB:\$m[1-9]+]], [[REGA]], 1048576
; CHECK-NEXT:  and $m0, $m0, [[REGB]]
; CHECK-NEXT:  br $m10
define i32 @and_0x00100001(i32 %x) {
  %res = and i32 %x, 1048577
  ret i32 %res
}

; CHECK-LABEL: and_0x00100002:
; CHECK:       # %bb.0:
; CHECK-NEXT:  setzi [[REGA:\$m[1-9]+]], 2
; CHECK-NEXT:  or [[REGB:\$m[1-9]+]], [[REGA]], 1048576
; CHECK-NEXT:  and $m0, $m0, [[REGB]]
; CHECK-NEXT:  br $m10
define i32 @and_0x00100002(i32 %x) {
  %res = and i32 %x, 1048578
  ret i32 %res
}

; CHECK-LABEL: and_0xFFEFFFFE:
; CHECK:       # %bb.0:
; CHECK-NEXT:  setzi [[REGA:\$m[1-9]+]], 1048574
; CHECK-NEXT:  or [[REGB:\$m[1-9]+]], [[REGA]], 4292870144
; CHECK-NEXT:  and $m0, $m0, [[REGB]]
; CHECK-NEXT:  br $m10
define i32 @and_0xFFEFFFFE(i32 %x) {
  %res = and i32 %x, 4293918718
  ret i32 %res
}

; CHECK-LABEL: and_0xFFEFFFFF:
; CHECK:       # %bb.0:
; CHECK-NEXT:  setzi [[REGA:\$m[1-9]+]], 1048575
; CHECK-NEXT:  or [[REGB:\$m[1-9]+]], [[REGA]], 4292870144
; CHECK-NEXT:  and $m0, $m0, [[REGB]]
; CHECK-NEXT:  br $m10
define i32 @and_0xFFEFFFFF(i32 %x) {
  %res = and i32 %x, 4293918719
  ret i32 %res
}

; CHECK-LABEL: and_0xFFF00000:
; CHECK:       # %bb.0:
; CHECK-NEXT:  setzi [[REG:\$m[1-9]+]], 1048575
; CHECK-NEXT:  andc $m0, $m0, [[REG]]
; CHECK-NEXT:  br $m10
define i32 @and_0xFFF00000(i32 %x) {
  %res = and i32 %x, 4293918720
  ret i32 %res
}

; CHECK-LABEL: and_0xFFF00001:
; CHECK:       # %bb.0:
; CHECK-NEXT:  setzi [[REG:\$m[1-9]+]], 1048574
; CHECK-NEXT:  andc $m0, $m0, [[REG]]
; CHECK-NEXT:  br $m10
define i32 @and_0xFFF00001(i32 %x) {
  %res = and i32 %x, 4293918721
  ret i32 %res
}

; CHECK-LABEL: and_0xFFF00002:
; CHECK:       # %bb.0:
; CHECK-NEXT:  setzi [[REG:\$m[1-9]+]], 1048573
; CHECK-NEXT:  andc $m0, $m0, [[REG]]
; CHECK-NEXT:  br $m10
define i32 @and_0xFFF00002(i32 %x) {
  %res = and i32 %x, 4293918722
  ret i32 %res
}

; CHECK-LABEL: and_0xFFFFEFFE:
; CHECK:       # %bb.0:
; CHECK-NEXT:  setzi [[REG:\$m[1-9]+]], 4097
; CHECK-NEXT:  andc $m0, $m0, [[REG]]
; CHECK-NEXT:  br $m10
define i32 @and_0xFFFFEFFE(i32 %x) {
  %res = and i32 %x, 4294963198
  ret i32 %res
}

; CHECK-LABEL: and_0xFFFFEFFF:
; CHECK:       # %bb.0:
; CHECK-NEXT:  setzi [[REG:\$m[1-9]+]], 4096
; CHECK-NEXT:  andc $m0, $m0, [[REG]]
; CHECK-NEXT:  br $m10
define i32 @and_0xFFFFEFFF(i32 %x) {
  %res = and i32 %x, 4294963199
  ret i32 %res
}

; CHECK-LABEL: and_0xFFFFF000:
; CHECK:       # %bb.0:
; CHECK-NEXT:  andc $m0, $m0, 4095
; CHECK-NEXT:  br $m10
define i32 @and_0xFFFFF000(i32 %x) {
  %res = and i32 %x, 4294963200
  ret i32 %res
}

; CHECK-LABEL: and_0xFFFFF001:
; CHECK:       # %bb.0:
; CHECK-NEXT:  andc $m0, $m0, 4094
; CHECK-NEXT:  br $m10
define i32 @and_0xFFFFF001(i32 %x) {
  %res = and i32 %x, 4294963201
  ret i32 %res
}

; CHECK-LABEL: and_0xFFFFF002:
; CHECK:       # %bb.0:
; CHECK-NEXT:  andc $m0, $m0, 4093
; CHECK-NEXT:  br $m10
define i32 @and_0xFFFFF002(i32 %x) {
  %res = and i32 %x, 4294963202
  ret i32 %res
}
