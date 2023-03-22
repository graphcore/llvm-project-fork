; RUN: llvm-link %isdopc %s | opt -instcombine -always-inline -mattr=+ipu1 | llc -march=colossus -colossus-coissue=false -mattr=+ipu1 | FileCheck %s
; RUN: llvm-link %isdopc %s | opt -instcombine -always-inline -mattr=+ipu2 | llc -march=colossus -colossus-coissue=false -mattr=+ipu2 | FileCheck %s

; These unit tests are derived from muldws.c and muldwu.c in hackers delight

@ISD_MULHU = external constant i32
@ISD_MULHS = external constant i32

declare i32 @llvm.colossus.SDAG.binary.i32.i32.i32(i32, i32, i32)

; CHECK-LABEL:  mulhu_isd_i32_0x1_0x1:
; CHECK:        # %bb.0:
; CHECK-NEXT:   mov $m0, $m15
; CHECK-NEXT:   br $m10
define i32 @mulhu_isd_i32_0x1_0x1()
{
  %id = load i32, i32* @ISD_MULHU
  %res = call i32 @llvm.colossus.SDAG.binary.i32.i32.i32(i32 %id, i32 1, i32 1)
  ret i32 %res
}

; CHECK-LABEL:  mulhu_isd_i32_0x0_0xFFFFFFFF:
; CHECK:        # %bb.0:
; CHECK-NEXT:   mov $m0, $m15
; CHECK-NEXT:   br $m10
define i32 @mulhu_isd_i32_0x0_0xFFFFFFFF()
{
  %id = load i32, i32* @ISD_MULHU
  %res = call i32 @llvm.colossus.SDAG.binary.i32.i32.i32(i32 %id, i32 0, i32 4294967295)
  ret i32 %res
}

; CHECK-LABEL:  mulhu_isd_i32_0x7_0x3:
; CHECK:        # %bb.0:
; CHECK-NEXT:   mov $m0, $m15
; CHECK-NEXT:   br $m10
define i32 @mulhu_isd_i32_0x7_0x3()
{
  %id = load i32, i32* @ISD_MULHU
  %res = call i32 @llvm.colossus.SDAG.binary.i32.i32.i32(i32 %id, i32 7, i32 3)
  ret i32 %res
}

; CHECK-LABEL:  mulhu_isd_i32_0x5555_0xAAAA:
; CHECK:        # %bb.0:
; CHECK-NEXT:   mov $m0, $m15
; CHECK-NEXT:   br $m10
define i32 @mulhu_isd_i32_0x5555_0xAAAA()
{
  %id = load i32, i32* @ISD_MULHU
  %res = call i32 @llvm.colossus.SDAG.binary.i32.i32.i32(i32 %id, i32 21845, i32 43690)
  ret i32 %res
}

; CHECK-LABEL:  mulhu_isd_i32_0x80000000_0x80000000:
; CHECK:        # %bb.0:
; CHECK-NEXT:   or $m0, $m15, 1073741824
; CHECK-NEXT:   br $m10
define i32 @mulhu_isd_i32_0x80000000_0x80000000()
{
  %id = load i32, i32* @ISD_MULHU
  %res = call i32 @llvm.colossus.SDAG.binary.i32.i32.i32(i32 %id, i32 2147483648, i32 2147483648)
  ret i32 %res
}

; CHECK-LABEL:  mulhu_isd_i32_0x12345678_0x87654321:
; CHECK:        # %bb.0:
; CHECK-NEXT:   setzi $m0, 52485
; CHECK-NEXT:   or $m0, $m0, 161480704
; CHECK-NEXT:   br $m10
define i32 @mulhu_isd_i32_0x12345678_0x87654321()
{
  %id = load i32, i32* @ISD_MULHU
  %res = call i32 @llvm.colossus.SDAG.binary.i32.i32.i32(i32 %id, i32 305419896, i32 2271560481)
  ret i32 %res
}

; CHECK-LABEL:  mulhu_isd_i32_0x89ABCDEF_0xFEDCBA98:
; CHECK:        # %bb.0:
; CHECK-NEXT:   setzi $m0, 993872
; CHECK-NEXT:   or $m0, $m0, 2298478592
; CHECK-NEXT:   br $m10
define i32 @mulhu_isd_i32_0x89ABCDEF_0xFEDCBA98()
{
  %id = load i32, i32* @ISD_MULHU
  %res = call i32 @llvm.colossus.SDAG.binary.i32.i32.i32(i32 %id, i32 2309737967, i32 4275878552)
  ret i32 %res
}

; CHECK-LABEL:  mulhu_isd_i32_0x55555555_0xAAAAAAAA:
; CHECK:        # %bb.0:
; CHECK-NEXT:   setzi $m0, 233016
; CHECK-NEXT:   or $m0, $m0, 954204160
; CHECK-NEXT:   br $m10
define i32 @mulhu_isd_i32_0x55555555_0xAAAAAAAA()
{
  %id = load i32, i32* @ISD_MULHU
  %res = call i32 @llvm.colossus.SDAG.binary.i32.i32.i32(i32 %id, i32 1431655765, i32 2863311530)
  ret i32 %res
}

; CHECK-LABEL:  mulhu_isd_i32_0xFFFFFFFF_0xFFFFFFFF:
; CHECK:        # %bb.0:
; CHECK-NEXT:   add $m0, $m15, -2
; CHECK-NEXT:   br $m10
define i32 @mulhu_isd_i32_0xFFFFFFFF_0xFFFFFFFF()
{
  %id = load i32, i32* @ISD_MULHU
  %res = call i32 @llvm.colossus.SDAG.binary.i32.i32.i32(i32 %id, i32 4294967295, i32 4294967295)
  ret i32 %res
}

; CHECK-LABEL: mulhs_isd_i32_1_1:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m15
; CHECK-NEXT:  br $m10
define i32 @mulhs_isd_i32_1_1() {
  %id = load i32, i32* @ISD_MULHS
  %res = call i32 @llvm.colossus.SDAG.binary.i32.i32.i32(i32 %id, i32  1, i32 1)
  ret i32 %res
}

; CHECK-LABEL: mulhs_isd_i32_0_0xFFFFFFFF:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m15
; CHECK-NEXT:  br $m10
define i32 @mulhs_isd_i32_0_0xFFFFFFFF() {
  %id = load i32, i32* @ISD_MULHS
  %res = call i32 @llvm.colossus.SDAG.binary.i32.i32.i32(i32 %id, i32  0, i32 4294967295)
  ret i32 %res
}

; CHECK-LABEL: mulhs_isd_i32_7_3:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m15
; CHECK-NEXT:  br $m10
define i32 @mulhs_isd_i32_7_3() {
  %id = load i32, i32* @ISD_MULHS
  %res = call i32 @llvm.colossus.SDAG.binary.i32.i32.i32(i32 %id, i32  7, i32 3)
  ret i32 %res
}

; CHECK-LABEL: mulhs_isd_i32_0x5555_0xAAAA:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m15
; CHECK-NEXT:  br $m10
define i32 @mulhs_isd_i32_0x5555_0xAAAA() {
  %id = load i32, i32* @ISD_MULHS
  %res = call i32 @llvm.colossus.SDAG.binary.i32.i32.i32(i32 %id, i32  21845, i32 43690)
  ret i32 %res
}

; CHECK-LABEL: mulhs_isd_i32_1_n1:
; CHECK:       # %bb.0:
; CHECK-NEXT:  add $m0, $m15, -1
; CHECK-NEXT:  br $m10
define i32 @mulhs_isd_i32_1_n1() {
  %id = load i32, i32* @ISD_MULHS
  %res = call i32 @llvm.colossus.SDAG.binary.i32.i32.i32(i32 %id, i32  1, i32 -1)
  ret i32 %res
}

; CHECK-LABEL: mulhs_isd_i32_5_n1:
; CHECK:       # %bb.0:
; CHECK-NEXT:  add $m0, $m15, -1
; CHECK-NEXT:  br $m10
define i32 @mulhs_isd_i32_5_n1() {
  %id = load i32, i32* @ISD_MULHS
  %res = call i32 @llvm.colossus.SDAG.binary.i32.i32.i32(i32 %id, i32  5, i32 -1)
  ret i32 %res
}

; CHECK-LABEL: mulhs_isd_i32_100_n7:
; CHECK:       # %bb.0:
; CHECK-NEXT:  add $m0, $m15, -1
; CHECK-NEXT:  br $m10
define i32 @mulhs_isd_i32_100_n7() {
  %id = load i32, i32* @ISD_MULHS
  %res = call i32 @llvm.colossus.SDAG.binary.i32.i32.i32(i32 %id, i32  100, i32 -7)
  ret i32 %res
}

; CHECK-LABEL: mulhs_isd_i32_0x100000_0xFEDC:
; CHECK:       # %bb.0:
; CHECK-NEXT:  setzi $m0, 15
; CHECK-NEXT:  br $m10
define i32 @mulhs_isd_i32_0x100000_0xFEDC() {
  %id = load i32, i32* @ISD_MULHS
  %res = call i32 @llvm.colossus.SDAG.binary.i32.i32.i32(i32 %id, i32 1048576, i32 65244)
  ret i32 %res
}

; CHECK-LABEL: mulhs_isd_i32_0xfffff_0xeeeee:
; CHECK:       # %bb.0:
; CHECK-NEXT:  setzi $m0, 238
; CHECK-NEXT:  br $m10
define i32 @mulhs_isd_i32_0xfffff_0xeeeee() {
  %id = load i32, i32* @ISD_MULHS
  %res = call i32 @llvm.colossus.SDAG.binary.i32.i32.i32(i32 %id, i32 1048575, i32 978670)
  ret i32 %res
}

; CHECK-LABEL: mulhs_isd_i32_0x7fffffff_0x7eeeeeee:
; CHECK:       # %bb.0:
; CHECK-NEXT:  setzi $m0, 489334
; CHECK-NEXT:  or $m0, $m0, 1064304640
; CHECK-NEXT:  br $m10
define i32 @mulhs_isd_i32_0x7fffffff_0x7eeeeeee() {
  %id = load i32, i32* @ISD_MULHS
  %res = call i32 @llvm.colossus.SDAG.binary.i32.i32.i32(i32 %id, i32 2147483647, i32 2129587950)
  ret i32 %res
}

; CHECK-LABEL: mulhs_isd_i32_n65536_65536:
; CHECK:       # %bb.0:
; CHECK-NEXT:  add $m0, $m15, -1
; CHECK-NEXT:  br $m10
define i32 @mulhs_isd_i32_n65536_65536() {
  %id = load i32, i32* @ISD_MULHS
  %res = call i32 @llvm.colossus.SDAG.binary.i32.i32.i32(i32 %id, i32  -65536, i32 65536)
  ret i32 %res
}

; CHECK-LABEL: mulhs_isd_i32_n100000_100000:
; CHECK:       # %bb.0:
; CHECK-NEXT:  add $m0, $m15, -3
; CHECK-NEXT:  br $m10
define i32 @mulhs_isd_i32_n100000_100000() {
  %id = load i32, i32* @ISD_MULHS
  %res = call i32 @llvm.colossus.SDAG.binary.i32.i32.i32(i32 %id, i32  -100000, i32 100000)
  ret i32 %res
}

; CHECK-LABEL: mulhs_isd_i32_n100000_n150000:
; CHECK:       # %bb.0:
; CHECK-NEXT:  setzi $m0, 3
; CHECK-NEXT:  br $m10
define i32 @mulhs_isd_i32_n100000_n150000() {
  %id = load i32, i32* @ISD_MULHS
  %res = call i32 @llvm.colossus.SDAG.binary.i32.i32.i32(i32 %id, i32  -100000, i32 -150000)
  ret i32 %res
}

; CHECK-LABEL: mulhs_isd_i32_0x80000000_0x7fffffff:
; CHECK:       # %bb.0:
; CHECK-NEXT:  or $m0, $m15, 3221225472
; CHECK-NEXT:  br $m10
define i32 @mulhs_isd_i32_0x80000000_0x7fffffff() {
  %id = load i32, i32* @ISD_MULHS
  %res = call i32 @llvm.colossus.SDAG.binary.i32.i32.i32(i32 %id, i32 2147483648, i32 2147483647)
  ret i32 %res
}

; CHECK-LABEL: mulhs_isd_i32_0x80000000_0x80000000:
; CHECK:       # %bb.0:
; CHECK-NEXT:  or $m0, $m15, 1073741824
; CHECK-NEXT:  br $m10
define i32 @mulhs_isd_i32_0x80000000_0x80000000() {
  %id = load i32, i32* @ISD_MULHS
  %res = call i32 @llvm.colossus.SDAG.binary.i32.i32.i32(i32 %id, i32 2147483648, i32 2147483648)
  ret i32 %res
}

; CHECK-LABEL: mulhs_isd_i32_0xc0000000_0xc0000000:
; CHECK:       # %bb.0:
; CHECK-NEXT:  or $m0, $m15, 268435456
; CHECK-NEXT:  br $m10
define i32 @mulhs_isd_i32_0xc0000000_0xc0000000() {
  %id = load i32, i32* @ISD_MULHS
  %res = call i32 @llvm.colossus.SDAG.binary.i32.i32.i32(i32 %id, i32 3221225472, i32 3221225472)
  ret i32 %res
}

; CHECK-LABEL: mulhs_isd_i32_0xFFFFFFF7_0xFFFFFFDF:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m15
; CHECK-NEXT:  br $m10
define i32 @mulhs_isd_i32_0xFFFFFFF7_0xFFFFFFDF() {
  %id = load i32, i32* @ISD_MULHS
  %res = call i32 @llvm.colossus.SDAG.binary.i32.i32.i32(i32 %id, i32 4294967287, i32 4294967263)
  ret i32 %res
}

; CHECK-LABEL: mulhs_isd_i32_0x12345678_0x87654321:
; CHECK:       # %bb.0:
; CHECK-NEXT:  setzi $m0, 816781
; CHECK-NEXT:  or $m0, $m0, 4150263808
; CHECK-NEXT:  br $m10
define i32 @mulhs_isd_i32_0x12345678_0x87654321() {
  %id = load i32, i32* @ISD_MULHS
  %res = call i32 @llvm.colossus.SDAG.binary.i32.i32.i32(i32 %id, i32 305419896, i32 2271560481)
  ret i32 %res
}

; CHECK-LABEL: mulhs_isd_i32_0x89ABCDEF_0xFEDCBA98:
; CHECK:       # %bb.0:
; CHECK-NEXT:  setzi $m0, 434633
; CHECK-NEXT:  or $m0, $m0, 8388608
; CHECK-NEXT:  br $m10
define i32 @mulhs_isd_i32_0x89ABCDEF_0xFEDCBA98() {
  %id = load i32, i32* @ISD_MULHS
  %res = call i32 @llvm.colossus.SDAG.binary.i32.i32.i32(i32 %id, i32 2309737967, i32 4275878552)
  ret i32 %res
}

; CHECK-LABEL: mulhs_isd_i32_0x55555555_0xAAAAAAAA:
; CHECK:       # %bb.0:
; CHECK-NEXT:  setzi $m0, 932067
; CHECK-NEXT:  or $m0, $m0, 3816816640
; CHECK-NEXT:  br $m10
define i32 @mulhs_isd_i32_0x55555555_0xAAAAAAAA() {
  %id = load i32, i32* @ISD_MULHS
  %res = call i32 @llvm.colossus.SDAG.binary.i32.i32.i32(i32 %id, i32 1431655765, i32 2863311530)
  ret i32 %res
}

; CHECK-LABEL: mulhs_isd_i32_0xFFFFFFFF_0xFFFFFFFF:
; CHECK:       # %bb.0:
; CHECK-NEXT:  mov $m0, $m15
; CHECK-NEXT:  br $m10
define i32 @mulhs_isd_i32_0xFFFFFFFF_0xFFFFFFFF() {
  %id = load i32, i32* @ISD_MULHS
  %res = call i32 @llvm.colossus.SDAG.binary.i32.i32.i32(i32 %id, i32 4294967295, i32 4294967295)
  ret i32 %res
}
