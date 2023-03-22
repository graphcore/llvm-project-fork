; RUN: llvm-link %isdopc %s | opt -instcombine -always-inline -mattr=+ipu1 | llc -march=colossus -colossus-coissue=false -mattr=+ipu1 | FileCheck %s
; RUN: llvm-link %isdopc %s | opt -instcombine -always-inline -mattr=+ipu2 | llc -march=colossus -colossus-coissue=false -mattr=+ipu2 | FileCheck %s

; Exhaustive test coverage for DAG Combines on SORT4X16LO, SORT4X16HI, ROLL16
; The ISD nodes are type agnostic so checking for <2 x half> is sufficient

declare <2 x half> @llvm.colossus.SDAG.binary.v2f16.v2f16.v2f16(i32, <2 x half>, <2 x half>)
@ColossusISD_SORT4X16LO = external constant i32
@ColossusISD_SORT4X16HI = external constant i32
@ColossusISD_ROLL16 = external constant i32

define internal <2 x half> @sortlo(<2 x half> %x, <2 x half> %y) #0 {
  %id = load i32, i32* @ColossusISD_SORT4X16LO
  %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16.v2f16.v2f16(i32 %id, <2 x half> %x, <2 x half> %y)
 ret <2 x half> %res
}

define internal <2 x half> @sorthi(<2 x half> %x, <2 x half> %y) #0 {
  %id = load i32, i32* @ColossusISD_SORT4X16HI
  %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16.v2f16.v2f16(i32 %id, <2 x half> %x, <2 x half> %y)
 ret <2 x half> %res
}

define internal <2 x half> @roll16(<2 x half> %x, <2 x half> %y) #0 {
  %id = load i32, i32* @ColossusISD_ROLL16
  %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16.v2f16.v2f16(i32 %id, <2 x half> %x, <2 x half> %y)
 ret <2 x half> %res
}

attributes #0 = {alwaysinline}

; CHECK-LABEL: test_lo.u.u_lo.u.3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.u.u_lo.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> undef)
  %x4 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.u.u_lo.0.3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.u.u_lo.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> undef)
  %x4 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.u.u_lo.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.u.u_lo.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> undef)
  %x4 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.u.u_lo.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.u.u_lo.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> undef)
  %x4 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.u.u_lo.3.u:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.u.u_lo.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> undef)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.u.u_lo.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.u.u_lo.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> undef)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.u.u_lo.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.u.u_lo.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> undef)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.u.u_lo.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.u.u_lo.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> undef)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.u.u_lo.3.3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.u.u_lo.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> undef)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.u.0_lo.u.3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.u.0_lo.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x0)
  %x4 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.u.0_lo.0.3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.u.0_lo.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x0)
  %x4 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.u.0_lo.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.u.0_lo.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x0)
  %x4 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.u.0_lo.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.u.0_lo.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x0)
  %x4 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.u.0_lo.3.u:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.u.0_lo.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x0)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.u.0_lo.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.u.0_lo.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x0)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.u.0_lo.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.u.0_lo.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x0)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.u.0_lo.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.u.0_lo.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x0)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.u.0_lo.3.3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.u.0_lo.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x0)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.u.1_lo.u.3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.u.1_lo.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x1)
  %x4 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.u.1_lo.0.3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.u.1_lo.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x1)
  %x4 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.u.1_lo.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.u.1_lo.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x1)
  %x4 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.u.1_lo.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.u.1_lo.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x1)
  %x4 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.u.1_lo.3.u:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.u.1_lo.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x1)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.u.1_lo.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.u.1_lo.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x1)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.u.1_lo.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.u.1_lo.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x1)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.u.1_lo.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.u.1_lo.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x1)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.u.1_lo.3.3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.u.1_lo.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x1)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.u.2_lo.u.3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.u.2_lo.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x2)
  %x4 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.u.2_lo.0.3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.u.2_lo.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x2)
  %x4 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.u.2_lo.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.u.2_lo.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x2)
  %x4 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.u.2_lo.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.u.2_lo.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x2)
  %x4 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.u.2_lo.3.u:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.u.2_lo.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x2)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.u.2_lo.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.u.2_lo.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x2)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.u.2_lo.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.u.2_lo.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x2)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.u.2_lo.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.u.2_lo.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x2)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.u.2_lo.3.3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.u.2_lo.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x2)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.0.u_lo.u.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.0.u_lo.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> undef)
  %x4 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.0.u_lo.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.0.u_lo.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> undef)
  %x4 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.0.u_lo.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a1, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.0.u_lo.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> undef)
  %x4 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.0.u_lo.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a2, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.0.u_lo.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> undef)
  %x4 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.0.u_lo.3.u:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.0.u_lo.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> undef)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.0.u_lo.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.0.u_lo.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> undef)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.0.u_lo.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.0.u_lo.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> undef)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.0.u_lo.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.0.u_lo.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> undef)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.0.u_lo.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.0.u_lo.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> undef)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.0.0_lo.u.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.0.0_lo.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x0)
  %x4 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.0.0_lo.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.0.0_lo.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x0)
  %x4 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.0.0_lo.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a1, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.0.0_lo.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x0)
  %x4 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.0.0_lo.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a2, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.0.0_lo.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x0)
  %x4 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.0.0_lo.3.u:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.0.0_lo.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x0)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.0.0_lo.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.0.0_lo.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x0)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.0.0_lo.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.0.0_lo.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x0)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.0.0_lo.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.0.0_lo.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x0)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.0.0_lo.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.0.0_lo.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x0)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.0.1_lo.u.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.0.1_lo.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x1)
  %x4 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.0.1_lo.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.0.1_lo.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x1)
  %x4 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.0.1_lo.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a1, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.0.1_lo.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x1)
  %x4 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.0.1_lo.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a2, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.0.1_lo.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x1)
  %x4 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.0.1_lo.3.u:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.0.1_lo.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x1)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.0.1_lo.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.0.1_lo.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x1)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.0.1_lo.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.0.1_lo.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x1)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.0.1_lo.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.0.1_lo.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x1)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.0.1_lo.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.0.1_lo.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x1)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.0.2_lo.u.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.0.2_lo.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x2)
  %x4 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.0.2_lo.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.0.2_lo.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x2)
  %x4 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.0.2_lo.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a1, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.0.2_lo.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x2)
  %x4 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.0.2_lo.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a2, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.0.2_lo.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x2)
  %x4 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.0.2_lo.3.u:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.0.2_lo.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x2)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.0.2_lo.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.0.2_lo.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x2)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.0.2_lo.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.0.2_lo.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x2)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.0.2_lo.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.0.2_lo.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x2)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.0.2_lo.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.0.2_lo.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x2)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.1.u_lo.u.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.1.u_lo.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> undef)
  %x4 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.1.u_lo.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.1.u_lo.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> undef)
  %x4 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.1.u_lo.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a1, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.1.u_lo.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> undef)
  %x4 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.1.u_lo.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a2, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.1.u_lo.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> undef)
  %x4 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.1.u_lo.3.u:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.1.u_lo.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> undef)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.1.u_lo.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a1, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.1.u_lo.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> undef)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.1.u_lo.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a1, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.1.u_lo.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> undef)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.1.u_lo.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a1, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.1.u_lo.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> undef)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.1.u_lo.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a1, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.1.u_lo.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> undef)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.1.0_lo.u.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.1.0_lo.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x0)
  %x4 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.1.0_lo.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.1.0_lo.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x0)
  %x4 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.1.0_lo.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a1, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.1.0_lo.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x0)
  %x4 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.1.0_lo.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a2, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.1.0_lo.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x0)
  %x4 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.1.0_lo.3.u:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.1.0_lo.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x0)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.1.0_lo.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a1, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.1.0_lo.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x0)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.1.0_lo.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a1, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.1.0_lo.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x0)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.1.0_lo.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a1, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.1.0_lo.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x0)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.1.0_lo.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a1, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.1.0_lo.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x0)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.1.1_lo.u.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.1.1_lo.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x1)
  %x4 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.1.1_lo.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.1.1_lo.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x1)
  %x4 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.1.1_lo.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a1, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.1.1_lo.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x1)
  %x4 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.1.1_lo.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a2, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.1.1_lo.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x1)
  %x4 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.1.1_lo.3.u:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.1.1_lo.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x1)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.1.1_lo.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a1, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.1.1_lo.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x1)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.1.1_lo.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a1, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.1.1_lo.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x1)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.1.1_lo.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a1, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.1.1_lo.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x1)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.1.1_lo.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a1, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.1.1_lo.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x1)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.1.2_lo.u.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.1.2_lo.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x2)
  %x4 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.1.2_lo.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.1.2_lo.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x2)
  %x4 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.1.2_lo.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a1, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.1.2_lo.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x2)
  %x4 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.1.2_lo.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a2, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.1.2_lo.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x2)
  %x4 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.1.2_lo.3.u:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.1.2_lo.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x2)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.1.2_lo.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a1, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.1.2_lo.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x2)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.1.2_lo.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a1, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.1.2_lo.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x2)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.1.2_lo.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a1, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.1.2_lo.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x2)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.1.2_lo.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a1, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.1.2_lo.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x2)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.2.u_lo.u.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.2.u_lo.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> undef)
  %x4 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.2.u_lo.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.2.u_lo.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> undef)
  %x4 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.2.u_lo.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a1, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.2.u_lo.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> undef)
  %x4 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.2.u_lo.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a2, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.2.u_lo.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> undef)
  %x4 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.2.u_lo.3.u:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.2.u_lo.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> undef)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.2.u_lo.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a2, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.2.u_lo.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> undef)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.2.u_lo.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a2, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.2.u_lo.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> undef)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.2.u_lo.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a2, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.2.u_lo.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> undef)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.2.u_lo.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a2, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.2.u_lo.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> undef)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.2.0_lo.u.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.2.0_lo.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x0)
  %x4 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.2.0_lo.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.2.0_lo.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x0)
  %x4 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.2.0_lo.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a1, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.2.0_lo.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x0)
  %x4 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.2.0_lo.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a2, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.2.0_lo.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x0)
  %x4 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.2.0_lo.3.u:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.2.0_lo.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x0)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.2.0_lo.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a2, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.2.0_lo.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x0)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.2.0_lo.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a2, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.2.0_lo.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x0)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.2.0_lo.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a2, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.2.0_lo.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x0)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.2.0_lo.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a2, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.2.0_lo.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x0)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.2.1_lo.u.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.2.1_lo.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x1)
  %x4 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.2.1_lo.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.2.1_lo.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x1)
  %x4 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.2.1_lo.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a1, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.2.1_lo.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x1)
  %x4 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.2.1_lo.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a2, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.2.1_lo.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x1)
  %x4 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.2.1_lo.3.u:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.2.1_lo.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x1)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.2.1_lo.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a2, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.2.1_lo.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x1)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.2.1_lo.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a2, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.2.1_lo.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x1)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.2.1_lo.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a2, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.2.1_lo.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x1)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.2.1_lo.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a2, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.2.1_lo.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x1)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.2.2_lo.u.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.2.2_lo.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x2)
  %x4 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.2.2_lo.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.2.2_lo.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x2)
  %x4 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.2.2_lo.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a1, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.2.2_lo.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x2)
  %x4 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.2.2_lo.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a2, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.2.2_lo.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x2)
  %x4 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.2.2_lo.3.u:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.2.2_lo.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x2)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.2.2_lo.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a2, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.2.2_lo.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x2)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.2.2_lo.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a2, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.2.2_lo.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x2)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.2.2_lo.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a2, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.2.2_lo.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x2)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.2.2_lo.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a2, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.2.2_lo.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x2)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.u.u_hi.u.3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.u.u_hi.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> undef)
  %x4 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.u.u_hi.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.u.u_hi.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> undef)
  %x4 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.u.u_hi.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.u.u_hi.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> undef)
  %x4 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.u.u_hi.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.u.u_hi.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> undef)
  %x4 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.u.u_hi.3.u:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.u.u_hi.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> undef)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.u.u_hi.3.0:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.u.u_hi.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> undef)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.u.u_hi.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.u.u_hi.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> undef)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.u.u_hi.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.u.u_hi.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> undef)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.u.u_hi.3.3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.u.u_hi.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> undef)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.u.0_hi.u.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.u.0_hi.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x0)
  %x4 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.u.0_hi.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.u.0_hi.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x0)
  %x4 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.u.0_hi.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a1, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.u.0_hi.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x0)
  %x4 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.u.0_hi.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a2, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.u.0_hi.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x0)
  %x4 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.u.0_hi.3.u:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.u.0_hi.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x0)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.u.0_hi.3.0:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.u.0_hi.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x0)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.u.0_hi.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a1, $a0
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.u.0_hi.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x0)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.u.0_hi.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a2, $a0
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.u.0_hi.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x0)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.u.0_hi.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.u.0_hi.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x0)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.u.1_hi.u.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.u.1_hi.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x1)
  %x4 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.u.1_hi.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.u.1_hi.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x1)
  %x4 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.u.1_hi.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.u.1_hi.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x1)
  %x4 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.u.1_hi.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a2, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.u.1_hi.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x1)
  %x4 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.u.1_hi.3.u:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.u.1_hi.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x1)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.u.1_hi.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a0, $a1
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.u.1_hi.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x1)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.u.1_hi.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.u.1_hi.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x1)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.u.1_hi.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a2, $a1
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.u.1_hi.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x1)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.u.1_hi.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a1, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.u.1_hi.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x1)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.u.2_hi.u.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.u.2_hi.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x2)
  %x4 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.u.2_hi.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.u.2_hi.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x2)
  %x4 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.u.2_hi.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a1, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.u.2_hi.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x2)
  %x4 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.u.2_hi.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.u.2_hi.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x2)
  %x4 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.u.2_hi.3.u:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.u.2_hi.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x2)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.u.2_hi.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a0, $a2
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.u.2_hi.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x2)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.u.2_hi.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a1, $a2
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.u.2_hi.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x2)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.u.2_hi.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.u.2_hi.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x2)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.u.2_hi.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a2, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.u.2_hi.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x2)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.0.u_hi.u.3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.0.u_hi.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> undef)
  %x4 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.0.u_hi.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.0.u_hi.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> undef)
  %x4 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.0.u_hi.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.0.u_hi.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> undef)
  %x4 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.0.u_hi.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.0.u_hi.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> undef)
  %x4 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.0.u_hi.3.u:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.0.u_hi.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> undef)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.0.u_hi.3.0:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.0.u_hi.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> undef)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.0.u_hi.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.0.u_hi.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> undef)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.0.u_hi.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.0.u_hi.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> undef)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.0.u_hi.3.3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.0.u_hi.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> undef)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.0.0_hi.u.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.0.0_hi.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x0)
  %x4 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.0.0_hi.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.0.0_hi.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x0)
  %x4 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.0.0_hi.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a1, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.0.0_hi.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x0)
  %x4 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.0.0_hi.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a2, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.0.0_hi.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x0)
  %x4 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.0.0_hi.3.u:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.0.0_hi.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x0)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.0.0_hi.3.0:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.0.0_hi.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x0)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.0.0_hi.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a1, $a0
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.0.0_hi.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x0)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.0.0_hi.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a2, $a0
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.0.0_hi.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x0)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.0.0_hi.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.0.0_hi.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x0)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.0.1_hi.u.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.0.1_hi.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x1)
  %x4 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.0.1_hi.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.0.1_hi.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x1)
  %x4 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.0.1_hi.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.0.1_hi.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x1)
  %x4 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.0.1_hi.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a2, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.0.1_hi.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x1)
  %x4 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.0.1_hi.3.u:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.0.1_hi.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x1)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.0.1_hi.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a0, $a1
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.0.1_hi.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x1)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.0.1_hi.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.0.1_hi.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x1)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.0.1_hi.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a2, $a1
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.0.1_hi.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x1)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.0.1_hi.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a1, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.0.1_hi.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x1)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.0.2_hi.u.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.0.2_hi.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x2)
  %x4 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.0.2_hi.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.0.2_hi.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x2)
  %x4 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.0.2_hi.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a1, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.0.2_hi.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x2)
  %x4 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.0.2_hi.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.0.2_hi.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x2)
  %x4 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.0.2_hi.3.u:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.0.2_hi.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x2)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.0.2_hi.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a0, $a2
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.0.2_hi.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x2)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.0.2_hi.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a1, $a2
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.0.2_hi.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x2)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.0.2_hi.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.0.2_hi.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x2)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.0.2_hi.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a2, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.0.2_hi.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x2)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.1.u_hi.u.3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.1.u_hi.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> undef)
  %x4 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.1.u_hi.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.1.u_hi.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> undef)
  %x4 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.1.u_hi.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.1.u_hi.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> undef)
  %x4 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.1.u_hi.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.1.u_hi.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> undef)
  %x4 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.1.u_hi.3.u:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.1.u_hi.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> undef)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.1.u_hi.3.0:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.1.u_hi.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> undef)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.1.u_hi.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.1.u_hi.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> undef)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.1.u_hi.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.1.u_hi.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> undef)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.1.u_hi.3.3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.1.u_hi.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> undef)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.1.0_hi.u.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.1.0_hi.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x0)
  %x4 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.1.0_hi.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.1.0_hi.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x0)
  %x4 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.1.0_hi.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a1, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.1.0_hi.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x0)
  %x4 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.1.0_hi.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a2, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.1.0_hi.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x0)
  %x4 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.1.0_hi.3.u:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.1.0_hi.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x0)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.1.0_hi.3.0:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.1.0_hi.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x0)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.1.0_hi.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a1, $a0
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.1.0_hi.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x0)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.1.0_hi.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a2, $a0
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.1.0_hi.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x0)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.1.0_hi.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.1.0_hi.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x0)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.1.1_hi.u.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.1.1_hi.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x1)
  %x4 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.1.1_hi.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.1.1_hi.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x1)
  %x4 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.1.1_hi.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.1.1_hi.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x1)
  %x4 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.1.1_hi.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a2, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.1.1_hi.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x1)
  %x4 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.1.1_hi.3.u:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.1.1_hi.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x1)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.1.1_hi.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a0, $a1
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.1.1_hi.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x1)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.1.1_hi.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.1.1_hi.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x1)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.1.1_hi.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a2, $a1
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.1.1_hi.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x1)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.1.1_hi.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a1, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.1.1_hi.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x1)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.1.2_hi.u.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.1.2_hi.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x2)
  %x4 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.1.2_hi.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.1.2_hi.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x2)
  %x4 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.1.2_hi.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a1, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.1.2_hi.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x2)
  %x4 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.1.2_hi.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.1.2_hi.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x2)
  %x4 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.1.2_hi.3.u:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.1.2_hi.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x2)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.1.2_hi.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a0, $a2
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.1.2_hi.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x2)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.1.2_hi.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a1, $a2
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.1.2_hi.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x2)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.1.2_hi.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.1.2_hi.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x2)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.1.2_hi.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a2, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.1.2_hi.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x2)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.2.u_hi.u.3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.2.u_hi.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> undef)
  %x4 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.2.u_hi.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.2.u_hi.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> undef)
  %x4 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.2.u_hi.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.2.u_hi.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> undef)
  %x4 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.2.u_hi.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.2.u_hi.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> undef)
  %x4 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.2.u_hi.3.u:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.2.u_hi.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> undef)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.2.u_hi.3.0:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.2.u_hi.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> undef)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.2.u_hi.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.2.u_hi.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> undef)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.2.u_hi.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.2.u_hi.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> undef)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.2.u_hi.3.3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.2.u_hi.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> undef)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.2.0_hi.u.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.2.0_hi.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x0)
  %x4 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.2.0_hi.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.2.0_hi.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x0)
  %x4 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.2.0_hi.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a1, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.2.0_hi.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x0)
  %x4 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.2.0_hi.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a2, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.2.0_hi.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x0)
  %x4 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.2.0_hi.3.u:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.2.0_hi.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x0)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.2.0_hi.3.0:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.2.0_hi.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x0)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.2.0_hi.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a1, $a0
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.2.0_hi.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x0)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.2.0_hi.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a2, $a0
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.2.0_hi.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x0)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.2.0_hi.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.2.0_hi.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x0)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.2.1_hi.u.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.2.1_hi.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x1)
  %x4 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.2.1_hi.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.2.1_hi.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x1)
  %x4 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.2.1_hi.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.2.1_hi.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x1)
  %x4 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.2.1_hi.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a2, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.2.1_hi.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x1)
  %x4 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.2.1_hi.3.u:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.2.1_hi.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x1)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.2.1_hi.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a0, $a1
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.2.1_hi.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x1)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.2.1_hi.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.2.1_hi.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x1)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.2.1_hi.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a2, $a1
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.2.1_hi.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x1)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.2.1_hi.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a1, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.2.1_hi.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x1)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.2.2_hi.u.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.2.2_hi.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x2)
  %x4 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.2.2_hi.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.2.2_hi.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x2)
  %x4 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.2.2_hi.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a1, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.2.2_hi.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x2)
  %x4 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.2.2_hi.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.2.2_hi.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x2)
  %x4 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.2.2_hi.3.u:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.2.2_hi.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x2)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.2.2_hi.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a0, $a2
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.2.2_hi.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x2)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.2.2_hi.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a1, $a2
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.2.2_hi.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x2)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.2.2_hi.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.2.2_hi.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x2)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.2.2_hi.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a2, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.2.2_hi.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x2)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.u.u_rl.u.3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.u.u_rl.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> undef)
  %x4 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.u.u_rl.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.u.u_rl.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> undef)
  %x4 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.u.u_rl.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.u.u_rl.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> undef)
  %x4 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.u.u_rl.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.u.u_rl.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> undef)
  %x4 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.u.u_rl.3.u:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.u.u_rl.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> undef)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.u.u_rl.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.u.u_rl.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> undef)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.u.u_rl.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.u.u_rl.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> undef)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.u.u_rl.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.u.u_rl.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> undef)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.u.u_rl.3.3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.u.u_rl.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> undef)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.u.0_rl.u.3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.u.0_rl.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x0)
  %x4 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.u.0_rl.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.u.0_rl.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x0)
  %x4 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.u.0_rl.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.u.0_rl.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x0)
  %x4 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.u.0_rl.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.u.0_rl.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x0)
  %x4 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.u.0_rl.3.u:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.u.0_rl.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x0)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.u.0_rl.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.u.0_rl.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x0)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.u.0_rl.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.u.0_rl.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x0)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.u.0_rl.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.u.0_rl.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x0)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.u.0_rl.3.3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.u.0_rl.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x0)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.u.1_rl.u.3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.u.1_rl.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x1)
  %x4 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.u.1_rl.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.u.1_rl.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x1)
  %x4 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.u.1_rl.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.u.1_rl.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x1)
  %x4 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.u.1_rl.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.u.1_rl.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x1)
  %x4 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.u.1_rl.3.u:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.u.1_rl.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x1)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.u.1_rl.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a1, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.u.1_rl.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x1)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.u.1_rl.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a1, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.u.1_rl.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x1)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.u.1_rl.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a1, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.u.1_rl.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x1)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.u.1_rl.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.u.1_rl.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x1)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.u.2_rl.u.3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.u.2_rl.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x2)
  %x4 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.u.2_rl.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.u.2_rl.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x2)
  %x4 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.u.2_rl.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.u.2_rl.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x2)
  %x4 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.u.2_rl.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.u.2_rl.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x2)
  %x4 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.u.2_rl.3.u:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.u.2_rl.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x2)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.u.2_rl.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a2, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.u.2_rl.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x2)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.u.2_rl.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a2, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.u.2_rl.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x2)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.u.2_rl.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a2, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.u.2_rl.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x2)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.u.2_rl.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.u.2_rl.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x2)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.0.u_rl.u.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.0.u_rl.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> undef)
  %x4 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.0.u_rl.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.0.u_rl.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> undef)
  %x4 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.0.u_rl.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a1, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.0.u_rl.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> undef)
  %x4 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.0.u_rl.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a2, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.0.u_rl.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> undef)
  %x4 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.0.u_rl.3.u:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.0.u_rl.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> undef)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.0.u_rl.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.0.u_rl.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> undef)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.0.u_rl.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.0.u_rl.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> undef)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.0.u_rl.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.0.u_rl.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> undef)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.0.u_rl.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.0.u_rl.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> undef)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.0.0_rl.u.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.0.0_rl.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x0)
  %x4 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.0.0_rl.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.0.0_rl.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x0)
  %x4 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.0.0_rl.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a1, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.0.0_rl.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x0)
  %x4 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.0.0_rl.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a2, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.0.0_rl.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x0)
  %x4 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.0.0_rl.3.u:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.0.0_rl.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x0)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.0.0_rl.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.0.0_rl.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x0)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.0.0_rl.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.0.0_rl.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x0)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.0.0_rl.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.0.0_rl.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x0)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.0.0_rl.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.0.0_rl.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x0)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.0.1_rl.u.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.0.1_rl.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x1)
  %x4 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.0.1_rl.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.0.1_rl.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x1)
  %x4 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.0.1_rl.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a1, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.0.1_rl.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x1)
  %x4 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.0.1_rl.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a2, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.0.1_rl.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x1)
  %x4 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.0.1_rl.3.u:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.0.1_rl.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x1)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.0.1_rl.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a1, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.0.1_rl.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x1)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.0.1_rl.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a1, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.0.1_rl.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x1)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.0.1_rl.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a1, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.0.1_rl.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x1)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.0.1_rl.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a1, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.0.1_rl.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x1)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.0.2_rl.u.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.0.2_rl.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x2)
  %x4 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.0.2_rl.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.0.2_rl.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x2)
  %x4 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.0.2_rl.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a1, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.0.2_rl.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x2)
  %x4 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.0.2_rl.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a2, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.0.2_rl.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x2)
  %x4 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.0.2_rl.3.u:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.0.2_rl.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x2)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.0.2_rl.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a2, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.0.2_rl.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x2)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.0.2_rl.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a2, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.0.2_rl.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x2)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.0.2_rl.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a2, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.0.2_rl.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x2)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.0.2_rl.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a2, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.0.2_rl.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x2)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.1.u_rl.u.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.1.u_rl.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> undef)
  %x4 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.1.u_rl.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.1.u_rl.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> undef)
  %x4 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.1.u_rl.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.1.u_rl.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> undef)
  %x4 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.1.u_rl.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a2, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.1.u_rl.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> undef)
  %x4 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.1.u_rl.3.u:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.1.u_rl.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> undef)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.1.u_rl.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.1.u_rl.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> undef)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.1.u_rl.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.1.u_rl.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> undef)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.1.u_rl.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.1.u_rl.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> undef)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.1.u_rl.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.1.u_rl.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> undef)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.1.0_rl.u.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.1.0_rl.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x0)
  %x4 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.1.0_rl.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.1.0_rl.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x0)
  %x4 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.1.0_rl.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.1.0_rl.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x0)
  %x4 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.1.0_rl.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a2, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.1.0_rl.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x0)
  %x4 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.1.0_rl.3.u:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.1.0_rl.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x0)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.1.0_rl.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.1.0_rl.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x0)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.1.0_rl.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.1.0_rl.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x0)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.1.0_rl.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.1.0_rl.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x0)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.1.0_rl.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.1.0_rl.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x0)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.1.1_rl.u.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.1.1_rl.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x1)
  %x4 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.1.1_rl.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.1.1_rl.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x1)
  %x4 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.1.1_rl.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.1.1_rl.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x1)
  %x4 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.1.1_rl.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a2, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.1.1_rl.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x1)
  %x4 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.1.1_rl.3.u:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.1.1_rl.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x1)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.1.1_rl.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a1, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.1.1_rl.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x1)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.1.1_rl.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a1, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.1.1_rl.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x1)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.1.1_rl.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a1, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.1.1_rl.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x1)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.1.1_rl.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a1, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.1.1_rl.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x1)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.1.2_rl.u.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.1.2_rl.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x2)
  %x4 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.1.2_rl.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.1.2_rl.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x2)
  %x4 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.1.2_rl.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.1.2_rl.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x2)
  %x4 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.1.2_rl.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a2, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.1.2_rl.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x2)
  %x4 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.1.2_rl.3.u:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.1.2_rl.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x2)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.1.2_rl.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a2, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.1.2_rl.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x2)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.1.2_rl.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a2, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.1.2_rl.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x2)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.1.2_rl.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a2, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.1.2_rl.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x2)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.1.2_rl.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a2, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.1.2_rl.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x2)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.2.u_rl.u.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.2.u_rl.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> undef)
  %x4 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.2.u_rl.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.2.u_rl.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> undef)
  %x4 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.2.u_rl.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a1, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.2.u_rl.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> undef)
  %x4 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.2.u_rl.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.2.u_rl.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> undef)
  %x4 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.2.u_rl.3.u:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.2.u_rl.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> undef)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.2.u_rl.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.2.u_rl.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> undef)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.2.u_rl.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.2.u_rl.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> undef)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.2.u_rl.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.2.u_rl.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> undef)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.2.u_rl.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.2.u_rl.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> undef)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.2.0_rl.u.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.2.0_rl.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x0)
  %x4 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.2.0_rl.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.2.0_rl.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x0)
  %x4 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.2.0_rl.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a1, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.2.0_rl.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x0)
  %x4 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.2.0_rl.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.2.0_rl.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x0)
  %x4 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.2.0_rl.3.u:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.2.0_rl.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x0)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.2.0_rl.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.2.0_rl.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x0)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.2.0_rl.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.2.0_rl.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x0)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.2.0_rl.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.2.0_rl.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x0)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.2.0_rl.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.2.0_rl.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x0)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.2.1_rl.u.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.2.1_rl.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x1)
  %x4 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.2.1_rl.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.2.1_rl.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x1)
  %x4 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.2.1_rl.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a1, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.2.1_rl.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x1)
  %x4 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.2.1_rl.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.2.1_rl.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x1)
  %x4 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.2.1_rl.3.u:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.2.1_rl.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x1)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.2.1_rl.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a1, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.2.1_rl.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x1)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.2.1_rl.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a1, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.2.1_rl.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x1)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.2.1_rl.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a1, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.2.1_rl.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x1)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.2.1_rl.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a1, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.2.1_rl.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x1)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.2.2_rl.u.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.2.2_rl.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x2)
  %x4 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.2.2_rl.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.2.2_rl.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x2)
  %x4 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.2.2_rl.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a1, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.2.2_rl.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x2)
  %x4 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.2.2_rl.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.2.2_rl.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x2)
  %x4 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.2.2_rl.3.u:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.2.2_rl.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x2)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.2.2_rl.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a2, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.2.2_rl.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x2)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.2.2_rl.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a2, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.2.2_rl.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x2)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.2.2_rl.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a2, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.2.2_rl.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x2)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_lo.2.2_rl.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a2, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_lo.2.2_rl.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x2)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.u.u_lo.u.3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.u.u_lo.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> undef)
  %x4 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.u.u_lo.0.3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.u.u_lo.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> undef)
  %x4 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.u.u_lo.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.u.u_lo.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> undef)
  %x4 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.u.u_lo.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.u.u_lo.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> undef)
  %x4 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.u.u_lo.3.u:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.u.u_lo.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> undef)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.u.u_lo.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.u.u_lo.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> undef)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.u.u_lo.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.u.u_lo.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> undef)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.u.u_lo.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.u.u_lo.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> undef)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.u.u_lo.3.3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.u.u_lo.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> undef)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.u.0_lo.u.3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.u.0_lo.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x0)
  %x4 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.u.0_lo.0.3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.u.0_lo.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x0)
  %x4 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.u.0_lo.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.u.0_lo.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x0)
  %x4 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.u.0_lo.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.u.0_lo.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x0)
  %x4 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.u.0_lo.3.u:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.u.0_lo.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x0)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.u.0_lo.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.u.0_lo.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x0)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.u.0_lo.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.u.0_lo.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x0)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.u.0_lo.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.u.0_lo.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x0)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.u.0_lo.3.3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.u.0_lo.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x0)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.u.1_lo.u.3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.u.1_lo.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x1)
  %x4 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.u.1_lo.0.3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.u.1_lo.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x1)
  %x4 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.u.1_lo.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.u.1_lo.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x1)
  %x4 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.u.1_lo.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.u.1_lo.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x1)
  %x4 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.u.1_lo.3.u:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.u.1_lo.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x1)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.u.1_lo.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.u.1_lo.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x1)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.u.1_lo.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.u.1_lo.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x1)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.u.1_lo.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.u.1_lo.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x1)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.u.1_lo.3.3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.u.1_lo.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x1)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.u.2_lo.u.3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.u.2_lo.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x2)
  %x4 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.u.2_lo.0.3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.u.2_lo.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x2)
  %x4 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.u.2_lo.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.u.2_lo.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x2)
  %x4 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.u.2_lo.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.u.2_lo.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x2)
  %x4 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.u.2_lo.3.u:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.u.2_lo.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x2)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.u.2_lo.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.u.2_lo.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x2)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.u.2_lo.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.u.2_lo.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x2)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.u.2_lo.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.u.2_lo.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x2)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.u.2_lo.3.3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.u.2_lo.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x2)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.0.u_lo.u.3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.0.u_lo.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> undef)
  %x4 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.0.u_lo.0.3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.0.u_lo.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> undef)
  %x4 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.0.u_lo.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a0, $a1
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.0.u_lo.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> undef)
  %x4 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.0.u_lo.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a0, $a2
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.0.u_lo.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> undef)
  %x4 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.0.u_lo.3.u:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.0.u_lo.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> undef)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.0.u_lo.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.0.u_lo.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> undef)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.0.u_lo.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.0.u_lo.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> undef)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.0.u_lo.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.0.u_lo.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> undef)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.0.u_lo.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.0.u_lo.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> undef)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.0.0_lo.u.3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.0.0_lo.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x0)
  %x4 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.0.0_lo.0.3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.0.0_lo.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x0)
  %x4 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.0.0_lo.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a0, $a1
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.0.0_lo.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x0)
  %x4 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.0.0_lo.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a0, $a2
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.0.0_lo.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x0)
  %x4 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.0.0_lo.3.u:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.0.0_lo.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x0)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.0.0_lo.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.0.0_lo.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x0)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.0.0_lo.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.0.0_lo.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x0)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.0.0_lo.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.0.0_lo.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x0)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.0.0_lo.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.0.0_lo.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x0)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.0.1_lo.u.3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.0.1_lo.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x1)
  %x4 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.0.1_lo.0.3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.0.1_lo.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x1)
  %x4 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.0.1_lo.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a0, $a1
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.0.1_lo.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x1)
  %x4 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.0.1_lo.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a0, $a2
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.0.1_lo.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x1)
  %x4 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.0.1_lo.3.u:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.0.1_lo.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x1)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.0.1_lo.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.0.1_lo.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x1)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.0.1_lo.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.0.1_lo.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x1)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.0.1_lo.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.0.1_lo.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x1)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.0.1_lo.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.0.1_lo.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x1)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.0.2_lo.u.3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.0.2_lo.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x2)
  %x4 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.0.2_lo.0.3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.0.2_lo.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x2)
  %x4 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.0.2_lo.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a0, $a1
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.0.2_lo.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x2)
  %x4 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.0.2_lo.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a0, $a2
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.0.2_lo.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x2)
  %x4 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.0.2_lo.3.u:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.0.2_lo.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x2)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.0.2_lo.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.0.2_lo.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x2)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.0.2_lo.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.0.2_lo.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x2)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.0.2_lo.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.0.2_lo.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x2)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.0.2_lo.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.0.2_lo.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x2)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.1.u_lo.u.3:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.1.u_lo.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> undef)
  %x4 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.1.u_lo.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a1, $a0
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.1.u_lo.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> undef)
  %x4 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.1.u_lo.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.1.u_lo.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> undef)
  %x4 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.1.u_lo.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a1, $a2
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.1.u_lo.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> undef)
  %x4 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.1.u_lo.3.u:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.1.u_lo.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> undef)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.1.u_lo.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a1, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.1.u_lo.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> undef)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.1.u_lo.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.1.u_lo.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> undef)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.1.u_lo.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a1, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.1.u_lo.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> undef)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.1.u_lo.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a1, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.1.u_lo.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> undef)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.1.0_lo.u.3:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.1.0_lo.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x0)
  %x4 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.1.0_lo.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a1, $a0
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.1.0_lo.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x0)
  %x4 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.1.0_lo.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.1.0_lo.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x0)
  %x4 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.1.0_lo.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a1, $a2
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.1.0_lo.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x0)
  %x4 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.1.0_lo.3.u:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.1.0_lo.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x0)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.1.0_lo.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a1, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.1.0_lo.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x0)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.1.0_lo.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.1.0_lo.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x0)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.1.0_lo.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a1, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.1.0_lo.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x0)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.1.0_lo.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a1, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.1.0_lo.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x0)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.1.1_lo.u.3:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.1.1_lo.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x1)
  %x4 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.1.1_lo.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a1, $a0
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.1.1_lo.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x1)
  %x4 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.1.1_lo.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.1.1_lo.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x1)
  %x4 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.1.1_lo.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a1, $a2
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.1.1_lo.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x1)
  %x4 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.1.1_lo.3.u:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.1.1_lo.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x1)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.1.1_lo.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a1, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.1.1_lo.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x1)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.1.1_lo.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.1.1_lo.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x1)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.1.1_lo.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a1, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.1.1_lo.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x1)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.1.1_lo.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a1, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.1.1_lo.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x1)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.1.2_lo.u.3:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.1.2_lo.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x2)
  %x4 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.1.2_lo.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a1, $a0
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.1.2_lo.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x2)
  %x4 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.1.2_lo.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.1.2_lo.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x2)
  %x4 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.1.2_lo.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a1, $a2
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.1.2_lo.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x2)
  %x4 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.1.2_lo.3.u:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.1.2_lo.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x2)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.1.2_lo.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a1, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.1.2_lo.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x2)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.1.2_lo.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.1.2_lo.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x2)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.1.2_lo.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a1, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.1.2_lo.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x2)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.1.2_lo.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a1, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.1.2_lo.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x2)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.2.u_lo.u.3:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.2.u_lo.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> undef)
  %x4 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.2.u_lo.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a2, $a0
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.2.u_lo.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> undef)
  %x4 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.2.u_lo.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a2, $a1
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.2.u_lo.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> undef)
  %x4 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.2.u_lo.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.2.u_lo.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> undef)
  %x4 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.2.u_lo.3.u:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.2.u_lo.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> undef)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.2.u_lo.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a2, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.2.u_lo.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> undef)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.2.u_lo.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a2, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.2.u_lo.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> undef)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.2.u_lo.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.2.u_lo.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> undef)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.2.u_lo.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a2, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.2.u_lo.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> undef)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.2.0_lo.u.3:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.2.0_lo.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x0)
  %x4 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.2.0_lo.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a2, $a0
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.2.0_lo.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x0)
  %x4 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.2.0_lo.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a2, $a1
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.2.0_lo.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x0)
  %x4 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.2.0_lo.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.2.0_lo.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x0)
  %x4 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.2.0_lo.3.u:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.2.0_lo.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x0)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.2.0_lo.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a2, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.2.0_lo.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x0)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.2.0_lo.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a2, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.2.0_lo.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x0)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.2.0_lo.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.2.0_lo.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x0)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.2.0_lo.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a2, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.2.0_lo.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x0)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.2.1_lo.u.3:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.2.1_lo.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x1)
  %x4 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.2.1_lo.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a2, $a0
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.2.1_lo.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x1)
  %x4 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.2.1_lo.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a2, $a1
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.2.1_lo.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x1)
  %x4 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.2.1_lo.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.2.1_lo.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x1)
  %x4 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.2.1_lo.3.u:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.2.1_lo.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x1)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.2.1_lo.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a2, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.2.1_lo.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x1)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.2.1_lo.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a2, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.2.1_lo.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x1)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.2.1_lo.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.2.1_lo.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x1)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.2.1_lo.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a2, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.2.1_lo.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x1)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.2.2_lo.u.3:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.2.2_lo.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x2)
  %x4 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.2.2_lo.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a2, $a0
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.2.2_lo.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x2)
  %x4 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.2.2_lo.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a2, $a1
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.2.2_lo.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x2)
  %x4 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.2.2_lo.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.2.2_lo.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x2)
  %x4 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.2.2_lo.3.u:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.2.2_lo.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x2)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.2.2_lo.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a2, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.2.2_lo.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x2)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.2.2_lo.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a2, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.2.2_lo.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x2)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.2.2_lo.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.2.2_lo.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x2)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.2.2_lo.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a2, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.2.2_lo.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x2)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.u.u_hi.u.3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.u.u_hi.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> undef)
  %x4 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.u.u_hi.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.u.u_hi.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> undef)
  %x4 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.u.u_hi.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.u.u_hi.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> undef)
  %x4 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.u.u_hi.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.u.u_hi.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> undef)
  %x4 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.u.u_hi.3.u:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.u.u_hi.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> undef)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.u.u_hi.3.0:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.u.u_hi.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> undef)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.u.u_hi.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.u.u_hi.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> undef)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.u.u_hi.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.u.u_hi.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> undef)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.u.u_hi.3.3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.u.u_hi.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> undef)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.u.0_hi.u.3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.u.0_hi.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x0)
  %x4 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.u.0_hi.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.u.0_hi.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x0)
  %x4 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.u.0_hi.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a1, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.u.0_hi.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x0)
  %x4 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.u.0_hi.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a2, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.u.0_hi.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x0)
  %x4 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.u.0_hi.3.u:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.u.0_hi.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x0)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.u.0_hi.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.u.0_hi.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x0)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.u.0_hi.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.u.0_hi.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x0)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.u.0_hi.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.u.0_hi.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x0)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.u.0_hi.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.u.0_hi.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x0)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.u.1_hi.u.3:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.u.1_hi.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x1)
  %x4 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.u.1_hi.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.u.1_hi.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x1)
  %x4 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.u.1_hi.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a1, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.u.1_hi.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x1)
  %x4 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.u.1_hi.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a2, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.u.1_hi.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x1)
  %x4 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.u.1_hi.3.u:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.u.1_hi.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x1)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.u.1_hi.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a1, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.u.1_hi.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x1)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.u.1_hi.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a1, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.u.1_hi.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x1)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.u.1_hi.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a1, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.u.1_hi.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x1)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.u.1_hi.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a1, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.u.1_hi.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x1)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.u.2_hi.u.3:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.u.2_hi.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x2)
  %x4 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.u.2_hi.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.u.2_hi.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x2)
  %x4 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.u.2_hi.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a1, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.u.2_hi.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x2)
  %x4 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.u.2_hi.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a2, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.u.2_hi.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x2)
  %x4 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.u.2_hi.3.u:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.u.2_hi.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x2)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.u.2_hi.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a2, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.u.2_hi.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x2)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.u.2_hi.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a2, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.u.2_hi.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x2)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.u.2_hi.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a2, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.u.2_hi.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x2)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.u.2_hi.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a2, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.u.2_hi.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x2)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.0.u_hi.u.3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.0.u_hi.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> undef)
  %x4 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.0.u_hi.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.0.u_hi.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> undef)
  %x4 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.0.u_hi.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.0.u_hi.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> undef)
  %x4 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.0.u_hi.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.0.u_hi.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> undef)
  %x4 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.0.u_hi.3.u:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.0.u_hi.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> undef)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.0.u_hi.3.0:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.0.u_hi.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> undef)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.0.u_hi.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.0.u_hi.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> undef)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.0.u_hi.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.0.u_hi.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> undef)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.0.u_hi.3.3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.0.u_hi.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> undef)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.0.0_hi.u.3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.0.0_hi.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x0)
  %x4 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.0.0_hi.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.0.0_hi.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x0)
  %x4 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.0.0_hi.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a1, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.0.0_hi.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x0)
  %x4 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.0.0_hi.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a2, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.0.0_hi.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x0)
  %x4 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.0.0_hi.3.u:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.0.0_hi.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x0)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.0.0_hi.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.0.0_hi.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x0)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.0.0_hi.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.0.0_hi.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x0)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.0.0_hi.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.0.0_hi.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x0)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.0.0_hi.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.0.0_hi.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x0)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.0.1_hi.u.3:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.0.1_hi.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x1)
  %x4 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.0.1_hi.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.0.1_hi.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x1)
  %x4 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.0.1_hi.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a1, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.0.1_hi.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x1)
  %x4 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.0.1_hi.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a2, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.0.1_hi.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x1)
  %x4 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.0.1_hi.3.u:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.0.1_hi.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x1)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.0.1_hi.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a1, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.0.1_hi.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x1)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.0.1_hi.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a1, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.0.1_hi.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x1)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.0.1_hi.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a1, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.0.1_hi.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x1)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.0.1_hi.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a1, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.0.1_hi.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x1)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.0.2_hi.u.3:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.0.2_hi.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x2)
  %x4 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.0.2_hi.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.0.2_hi.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x2)
  %x4 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.0.2_hi.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a1, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.0.2_hi.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x2)
  %x4 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.0.2_hi.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a2, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.0.2_hi.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x2)
  %x4 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.0.2_hi.3.u:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.0.2_hi.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x2)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.0.2_hi.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a2, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.0.2_hi.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x2)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.0.2_hi.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a2, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.0.2_hi.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x2)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.0.2_hi.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a2, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.0.2_hi.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x2)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.0.2_hi.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a2, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.0.2_hi.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x2)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.1.u_hi.u.3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.1.u_hi.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> undef)
  %x4 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.1.u_hi.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.1.u_hi.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> undef)
  %x4 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.1.u_hi.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.1.u_hi.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> undef)
  %x4 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.1.u_hi.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.1.u_hi.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> undef)
  %x4 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.1.u_hi.3.u:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.1.u_hi.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> undef)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.1.u_hi.3.0:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.1.u_hi.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> undef)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.1.u_hi.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.1.u_hi.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> undef)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.1.u_hi.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.1.u_hi.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> undef)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.1.u_hi.3.3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.1.u_hi.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> undef)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.1.0_hi.u.3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.1.0_hi.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x0)
  %x4 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.1.0_hi.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.1.0_hi.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x0)
  %x4 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.1.0_hi.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a1, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.1.0_hi.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x0)
  %x4 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.1.0_hi.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a2, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.1.0_hi.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x0)
  %x4 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.1.0_hi.3.u:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.1.0_hi.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x0)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.1.0_hi.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.1.0_hi.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x0)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.1.0_hi.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.1.0_hi.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x0)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.1.0_hi.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.1.0_hi.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x0)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.1.0_hi.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.1.0_hi.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x0)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.1.1_hi.u.3:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.1.1_hi.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x1)
  %x4 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.1.1_hi.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.1.1_hi.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x1)
  %x4 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.1.1_hi.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a1, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.1.1_hi.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x1)
  %x4 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.1.1_hi.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a2, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.1.1_hi.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x1)
  %x4 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.1.1_hi.3.u:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.1.1_hi.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x1)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.1.1_hi.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a1, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.1.1_hi.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x1)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.1.1_hi.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a1, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.1.1_hi.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x1)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.1.1_hi.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a1, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.1.1_hi.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x1)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.1.1_hi.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a1, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.1.1_hi.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x1)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.1.2_hi.u.3:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.1.2_hi.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x2)
  %x4 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.1.2_hi.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.1.2_hi.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x2)
  %x4 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.1.2_hi.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a1, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.1.2_hi.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x2)
  %x4 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.1.2_hi.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a2, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.1.2_hi.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x2)
  %x4 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.1.2_hi.3.u:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.1.2_hi.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x2)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.1.2_hi.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a2, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.1.2_hi.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x2)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.1.2_hi.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a2, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.1.2_hi.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x2)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.1.2_hi.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a2, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.1.2_hi.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x2)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.1.2_hi.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a2, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.1.2_hi.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x2)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.2.u_hi.u.3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.2.u_hi.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> undef)
  %x4 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.2.u_hi.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.2.u_hi.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> undef)
  %x4 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.2.u_hi.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.2.u_hi.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> undef)
  %x4 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.2.u_hi.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.2.u_hi.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> undef)
  %x4 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.2.u_hi.3.u:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.2.u_hi.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> undef)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.2.u_hi.3.0:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.2.u_hi.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> undef)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.2.u_hi.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.2.u_hi.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> undef)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.2.u_hi.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.2.u_hi.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> undef)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.2.u_hi.3.3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.2.u_hi.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> undef)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.2.0_hi.u.3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.2.0_hi.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x0)
  %x4 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.2.0_hi.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.2.0_hi.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x0)
  %x4 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.2.0_hi.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a1, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.2.0_hi.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x0)
  %x4 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.2.0_hi.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a2, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.2.0_hi.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x0)
  %x4 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.2.0_hi.3.u:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.2.0_hi.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x0)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.2.0_hi.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.2.0_hi.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x0)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.2.0_hi.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.2.0_hi.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x0)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.2.0_hi.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.2.0_hi.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x0)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.2.0_hi.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.2.0_hi.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x0)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.2.1_hi.u.3:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.2.1_hi.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x1)
  %x4 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.2.1_hi.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.2.1_hi.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x1)
  %x4 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.2.1_hi.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a1, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.2.1_hi.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x1)
  %x4 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.2.1_hi.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a2, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.2.1_hi.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x1)
  %x4 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.2.1_hi.3.u:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.2.1_hi.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x1)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.2.1_hi.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a1, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.2.1_hi.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x1)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.2.1_hi.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a1, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.2.1_hi.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x1)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.2.1_hi.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a1, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.2.1_hi.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x1)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.2.1_hi.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a1, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.2.1_hi.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x1)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.2.2_hi.u.3:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.2.2_hi.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x2)
  %x4 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.2.2_hi.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.2.2_hi.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x2)
  %x4 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.2.2_hi.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a1, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.2.2_hi.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x2)
  %x4 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.2.2_hi.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a2, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.2.2_hi.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x2)
  %x4 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.2.2_hi.3.u:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.2.2_hi.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x2)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.2.2_hi.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a2, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.2.2_hi.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x2)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.2.2_hi.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a2, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.2.2_hi.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x2)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.2.2_hi.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a2, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.2.2_hi.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x2)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.2.2_hi.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a2, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.2.2_hi.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x2)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.u.u_rl.u.3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.u.u_rl.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> undef)
  %x4 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.u.u_rl.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.u.u_rl.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> undef)
  %x4 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.u.u_rl.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.u.u_rl.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> undef)
  %x4 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.u.u_rl.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.u.u_rl.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> undef)
  %x4 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.u.u_rl.3.u:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.u.u_rl.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> undef)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.u.u_rl.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.u.u_rl.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> undef)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.u.u_rl.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.u.u_rl.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> undef)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.u.u_rl.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.u.u_rl.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> undef)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.u.u_rl.3.3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.u.u_rl.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> undef)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.u.0_rl.u.3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.u.0_rl.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x0)
  %x4 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.u.0_rl.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.u.0_rl.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x0)
  %x4 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.u.0_rl.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.u.0_rl.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x0)
  %x4 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.u.0_rl.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.u.0_rl.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x0)
  %x4 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.u.0_rl.3.u:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.u.0_rl.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x0)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.u.0_rl.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.u.0_rl.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x0)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.u.0_rl.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.u.0_rl.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x0)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.u.0_rl.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.u.0_rl.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x0)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.u.0_rl.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.u.0_rl.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x0)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.u.1_rl.u.3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.u.1_rl.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x1)
  %x4 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.u.1_rl.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.u.1_rl.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x1)
  %x4 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.u.1_rl.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.u.1_rl.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x1)
  %x4 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.u.1_rl.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.u.1_rl.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x1)
  %x4 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.u.1_rl.3.u:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.u.1_rl.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x1)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.u.1_rl.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a1, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.u.1_rl.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x1)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.u.1_rl.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.u.1_rl.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x1)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.u.1_rl.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a1, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.u.1_rl.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x1)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.u.1_rl.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.u.1_rl.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x1)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.u.2_rl.u.3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.u.2_rl.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x2)
  %x4 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.u.2_rl.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.u.2_rl.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x2)
  %x4 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.u.2_rl.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.u.2_rl.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x2)
  %x4 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.u.2_rl.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.u.2_rl.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x2)
  %x4 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.u.2_rl.3.u:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.u.2_rl.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x2)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.u.2_rl.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a2, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.u.2_rl.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x2)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.u.2_rl.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a2, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.u.2_rl.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x2)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.u.2_rl.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.u.2_rl.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x2)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.u.2_rl.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.u.2_rl.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x2)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.0.u_rl.u.3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.0.u_rl.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> undef)
  %x4 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.0.u_rl.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.0.u_rl.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> undef)
  %x4 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.0.u_rl.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a1, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.0.u_rl.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> undef)
  %x4 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.0.u_rl.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a2, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.0.u_rl.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> undef)
  %x4 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.0.u_rl.3.u:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.0.u_rl.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> undef)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.0.u_rl.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.0.u_rl.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> undef)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.0.u_rl.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.0.u_rl.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> undef)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.0.u_rl.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.0.u_rl.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> undef)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.0.u_rl.3.3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.0.u_rl.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> undef)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.0.0_rl.u.3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.0.0_rl.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x0)
  %x4 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.0.0_rl.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.0.0_rl.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x0)
  %x4 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.0.0_rl.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a1, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.0.0_rl.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x0)
  %x4 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.0.0_rl.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a2, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.0.0_rl.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x0)
  %x4 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.0.0_rl.3.u:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.0.0_rl.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x0)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.0.0_rl.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.0.0_rl.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x0)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.0.0_rl.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.0.0_rl.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x0)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.0.0_rl.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.0.0_rl.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x0)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.0.0_rl.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.0.0_rl.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x0)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.0.1_rl.u.3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.0.1_rl.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x1)
  %x4 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.0.1_rl.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.0.1_rl.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x1)
  %x4 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.0.1_rl.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a1, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.0.1_rl.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x1)
  %x4 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.0.1_rl.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a2, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.0.1_rl.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x1)
  %x4 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.0.1_rl.3.u:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.0.1_rl.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x1)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.0.1_rl.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a1, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.0.1_rl.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x1)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.0.1_rl.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.0.1_rl.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x1)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.0.1_rl.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a1, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.0.1_rl.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x1)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.0.1_rl.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a1, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.0.1_rl.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x1)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.0.2_rl.u.3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.0.2_rl.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x2)
  %x4 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.0.2_rl.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.0.2_rl.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x2)
  %x4 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.0.2_rl.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a1, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.0.2_rl.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x2)
  %x4 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.0.2_rl.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a2, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.0.2_rl.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x2)
  %x4 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.0.2_rl.3.u:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.0.2_rl.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x2)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.0.2_rl.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a2, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.0.2_rl.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x2)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.0.2_rl.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a2, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.0.2_rl.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x2)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.0.2_rl.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.0.2_rl.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x2)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.0.2_rl.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a2, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.0.2_rl.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x2)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.1.u_rl.u.3:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.1.u_rl.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> undef)
  %x4 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.1.u_rl.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.1.u_rl.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> undef)
  %x4 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.1.u_rl.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a1, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.1.u_rl.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> undef)
  %x4 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.1.u_rl.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a2, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.1.u_rl.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> undef)
  %x4 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.1.u_rl.3.u:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.1.u_rl.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> undef)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.1.u_rl.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.1.u_rl.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> undef)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.1.u_rl.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.1.u_rl.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> undef)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.1.u_rl.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.1.u_rl.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> undef)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.1.u_rl.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.1.u_rl.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> undef)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.1.0_rl.u.3:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.1.0_rl.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x0)
  %x4 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.1.0_rl.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.1.0_rl.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x0)
  %x4 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.1.0_rl.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a1, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.1.0_rl.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x0)
  %x4 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.1.0_rl.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a2, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.1.0_rl.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x0)
  %x4 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.1.0_rl.3.u:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.1.0_rl.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x0)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.1.0_rl.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.1.0_rl.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x0)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.1.0_rl.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.1.0_rl.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x0)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.1.0_rl.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.1.0_rl.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x0)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.1.0_rl.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.1.0_rl.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x0)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.1.1_rl.u.3:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.1.1_rl.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x1)
  %x4 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.1.1_rl.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.1.1_rl.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x1)
  %x4 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.1.1_rl.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a1, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.1.1_rl.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x1)
  %x4 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.1.1_rl.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a2, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.1.1_rl.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x1)
  %x4 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.1.1_rl.3.u:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.1.1_rl.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x1)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.1.1_rl.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a1, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.1.1_rl.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x1)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.1.1_rl.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.1.1_rl.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x1)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.1.1_rl.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a1, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.1.1_rl.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x1)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.1.1_rl.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a1, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.1.1_rl.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x1)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.1.2_rl.u.3:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.1.2_rl.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x2)
  %x4 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.1.2_rl.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.1.2_rl.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x2)
  %x4 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.1.2_rl.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a1, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.1.2_rl.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x2)
  %x4 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.1.2_rl.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a2, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.1.2_rl.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x2)
  %x4 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.1.2_rl.3.u:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.1.2_rl.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x2)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.1.2_rl.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a2, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.1.2_rl.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x2)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.1.2_rl.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a2, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.1.2_rl.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x2)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.1.2_rl.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.1.2_rl.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x2)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.1.2_rl.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a2, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.1.2_rl.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x2)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.2.u_rl.u.3:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.2.u_rl.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> undef)
  %x4 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.2.u_rl.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.2.u_rl.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> undef)
  %x4 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.2.u_rl.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a1, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.2.u_rl.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> undef)
  %x4 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.2.u_rl.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a2, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.2.u_rl.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> undef)
  %x4 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.2.u_rl.3.u:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.2.u_rl.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> undef)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.2.u_rl.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.2.u_rl.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> undef)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.2.u_rl.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.2.u_rl.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> undef)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.2.u_rl.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.2.u_rl.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> undef)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.2.u_rl.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.2.u_rl.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> undef)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.2.0_rl.u.3:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.2.0_rl.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x0)
  %x4 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.2.0_rl.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.2.0_rl.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x0)
  %x4 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.2.0_rl.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a1, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.2.0_rl.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x0)
  %x4 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.2.0_rl.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a2, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.2.0_rl.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x0)
  %x4 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.2.0_rl.3.u:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.2.0_rl.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x0)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.2.0_rl.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.2.0_rl.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x0)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.2.0_rl.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.2.0_rl.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x0)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.2.0_rl.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.2.0_rl.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x0)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.2.0_rl.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.2.0_rl.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x0)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.2.1_rl.u.3:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.2.1_rl.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x1)
  %x4 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.2.1_rl.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.2.1_rl.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x1)
  %x4 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.2.1_rl.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a1, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.2.1_rl.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x1)
  %x4 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.2.1_rl.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a2, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.2.1_rl.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x1)
  %x4 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.2.1_rl.3.u:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.2.1_rl.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x1)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.2.1_rl.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a1, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.2.1_rl.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x1)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.2.1_rl.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.2.1_rl.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x1)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.2.1_rl.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a1, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.2.1_rl.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x1)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.2.1_rl.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a1, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.2.1_rl.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x1)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.2.2_rl.u.3:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.2.2_rl.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x2)
  %x4 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.2.2_rl.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.2.2_rl.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x2)
  %x4 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.2.2_rl.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a1, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.2.2_rl.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x2)
  %x4 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.2.2_rl.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a2, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.2.2_rl.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x2)
  %x4 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.2.2_rl.3.u:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.2.2_rl.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x2)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.2.2_rl.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a2, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.2.2_rl.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x2)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.2.2_rl.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a2, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.2.2_rl.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x2)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.2.2_rl.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.2.2_rl.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x2)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_hi.2.2_rl.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a2, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_hi.2.2_rl.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x2)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.u.u_lo.u.3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.u.u_lo.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> undef, <2 x half> undef)
  %x4 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.u.u_lo.0.3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.u.u_lo.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> undef, <2 x half> undef)
  %x4 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.u.u_lo.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.u.u_lo.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> undef, <2 x half> undef)
  %x4 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.u.u_lo.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.u.u_lo.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> undef, <2 x half> undef)
  %x4 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.u.u_lo.3.u:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.u.u_lo.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> undef, <2 x half> undef)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.u.u_lo.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.u.u_lo.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> undef, <2 x half> undef)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.u.u_lo.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.u.u_lo.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> undef, <2 x half> undef)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.u.u_lo.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.u.u_lo.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> undef, <2 x half> undef)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.u.u_lo.3.3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.u.u_lo.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> undef, <2 x half> undef)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.u.0_lo.u.3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.u.0_lo.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x0)
  %x4 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.u.0_lo.0.3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.u.0_lo.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x0)
  %x4 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.u.0_lo.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.u.0_lo.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x0)
  %x4 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.u.0_lo.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.u.0_lo.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x0)
  %x4 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.u.0_lo.3.u:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.u.0_lo.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x0)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.u.0_lo.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.u.0_lo.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x0)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.u.0_lo.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.u.0_lo.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x0)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.u.0_lo.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.u.0_lo.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x0)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.u.0_lo.3.3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.u.0_lo.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x0)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.u.1_lo.u.3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.u.1_lo.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x1)
  %x4 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.u.1_lo.0.3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.u.1_lo.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x1)
  %x4 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.u.1_lo.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.u.1_lo.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x1)
  %x4 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.u.1_lo.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.u.1_lo.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x1)
  %x4 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.u.1_lo.3.u:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.u.1_lo.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x1)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.u.1_lo.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.u.1_lo.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x1)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.u.1_lo.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.u.1_lo.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x1)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.u.1_lo.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.u.1_lo.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x1)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.u.1_lo.3.3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.u.1_lo.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x1)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.u.2_lo.u.3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.u.2_lo.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x2)
  %x4 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.u.2_lo.0.3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.u.2_lo.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x2)
  %x4 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.u.2_lo.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.u.2_lo.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x2)
  %x4 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.u.2_lo.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.u.2_lo.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x2)
  %x4 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.u.2_lo.3.u:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.u.2_lo.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x2)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.u.2_lo.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.u.2_lo.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x2)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.u.2_lo.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.u.2_lo.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x2)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.u.2_lo.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.u.2_lo.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x2)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.u.2_lo.3.3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.u.2_lo.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x2)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.0.u_lo.u.3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.0.u_lo.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> undef)
  %x4 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.0.u_lo.0.3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.0.u_lo.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> undef)
  %x4 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.0.u_lo.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a0, $a1
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.0.u_lo.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> undef)
  %x4 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.0.u_lo.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a0, $a2
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.0.u_lo.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> undef)
  %x4 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.0.u_lo.3.u:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.0.u_lo.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> undef)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.0.u_lo.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.0.u_lo.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> undef)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.0.u_lo.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.0.u_lo.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> undef)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.0.u_lo.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.0.u_lo.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> undef)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.0.u_lo.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.0.u_lo.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> undef)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.0.0_lo.u.3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.0.0_lo.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x0)
  %x4 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.0.0_lo.0.3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.0.0_lo.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x0)
  %x4 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.0.0_lo.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a0, $a1
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.0.0_lo.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x0)
  %x4 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.0.0_lo.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a0, $a2
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.0.0_lo.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x0)
  %x4 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.0.0_lo.3.u:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.0.0_lo.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x0)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.0.0_lo.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.0.0_lo.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x0)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.0.0_lo.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.0.0_lo.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x0)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.0.0_lo.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.0.0_lo.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x0)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.0.0_lo.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.0.0_lo.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x0)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.0.1_lo.u.3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.0.1_lo.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x1)
  %x4 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.0.1_lo.0.3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.0.1_lo.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x1)
  %x4 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.0.1_lo.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a0, $a1
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.0.1_lo.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x1)
  %x4 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.0.1_lo.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a0, $a2
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.0.1_lo.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x1)
  %x4 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.0.1_lo.3.u:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.0.1_lo.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x1)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.0.1_lo.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.0.1_lo.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x1)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.0.1_lo.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.0.1_lo.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x1)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.0.1_lo.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.0.1_lo.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x1)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.0.1_lo.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.0.1_lo.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x1)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.0.2_lo.u.3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.0.2_lo.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x2)
  %x4 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.0.2_lo.0.3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.0.2_lo.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x2)
  %x4 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.0.2_lo.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a0, $a1
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.0.2_lo.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x2)
  %x4 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.0.2_lo.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a0, $a2
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.0.2_lo.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x2)
  %x4 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.0.2_lo.3.u:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.0.2_lo.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x2)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.0.2_lo.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.0.2_lo.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x2)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.0.2_lo.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.0.2_lo.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x2)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.0.2_lo.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.0.2_lo.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x2)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.0.2_lo.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.0.2_lo.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x2)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.1.u_lo.u.3:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.1.u_lo.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> undef)
  %x4 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.1.u_lo.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a1, $a0
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.1.u_lo.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> undef)
  %x4 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.1.u_lo.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.1.u_lo.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> undef)
  %x4 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.1.u_lo.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a1, $a2
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.1.u_lo.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> undef)
  %x4 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.1.u_lo.3.u:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.1.u_lo.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> undef)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.1.u_lo.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a1, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.1.u_lo.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> undef)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.1.u_lo.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.1.u_lo.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> undef)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.1.u_lo.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a1, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.1.u_lo.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> undef)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.1.u_lo.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a1, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.1.u_lo.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> undef)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.1.0_lo.u.3:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.1.0_lo.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x0)
  %x4 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.1.0_lo.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a1, $a0
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.1.0_lo.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x0)
  %x4 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.1.0_lo.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.1.0_lo.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x0)
  %x4 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.1.0_lo.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a1, $a2
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.1.0_lo.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x0)
  %x4 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.1.0_lo.3.u:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.1.0_lo.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x0)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.1.0_lo.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a1, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.1.0_lo.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x0)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.1.0_lo.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.1.0_lo.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x0)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.1.0_lo.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a1, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.1.0_lo.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x0)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.1.0_lo.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a1, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.1.0_lo.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x0)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.1.1_lo.u.3:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.1.1_lo.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x1)
  %x4 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.1.1_lo.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a1, $a0
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.1.1_lo.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x1)
  %x4 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.1.1_lo.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.1.1_lo.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x1)
  %x4 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.1.1_lo.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a1, $a2
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.1.1_lo.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x1)
  %x4 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.1.1_lo.3.u:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.1.1_lo.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x1)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.1.1_lo.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a1, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.1.1_lo.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x1)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.1.1_lo.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.1.1_lo.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x1)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.1.1_lo.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a1, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.1.1_lo.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x1)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.1.1_lo.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a1, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.1.1_lo.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x1)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.1.2_lo.u.3:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.1.2_lo.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x2)
  %x4 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.1.2_lo.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a1, $a0
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.1.2_lo.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x2)
  %x4 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.1.2_lo.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.1.2_lo.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x2)
  %x4 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.1.2_lo.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a1, $a2
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.1.2_lo.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x2)
  %x4 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.1.2_lo.3.u:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.1.2_lo.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x2)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.1.2_lo.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a1, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.1.2_lo.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x2)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.1.2_lo.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.1.2_lo.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x2)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.1.2_lo.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a1, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.1.2_lo.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x2)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.1.2_lo.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a1, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.1.2_lo.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x2)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.2.u_lo.u.3:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.2.u_lo.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> undef)
  %x4 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.2.u_lo.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a2, $a0
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.2.u_lo.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> undef)
  %x4 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.2.u_lo.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a2, $a1
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.2.u_lo.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> undef)
  %x4 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.2.u_lo.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.2.u_lo.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> undef)
  %x4 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.2.u_lo.3.u:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.2.u_lo.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> undef)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.2.u_lo.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a2, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.2.u_lo.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> undef)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.2.u_lo.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a2, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.2.u_lo.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> undef)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.2.u_lo.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.2.u_lo.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> undef)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.2.u_lo.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a2, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.2.u_lo.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> undef)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.2.0_lo.u.3:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.2.0_lo.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x0)
  %x4 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.2.0_lo.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a2, $a0
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.2.0_lo.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x0)
  %x4 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.2.0_lo.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a2, $a1
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.2.0_lo.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x0)
  %x4 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.2.0_lo.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.2.0_lo.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x0)
  %x4 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.2.0_lo.3.u:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.2.0_lo.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x0)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.2.0_lo.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a2, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.2.0_lo.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x0)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.2.0_lo.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a2, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.2.0_lo.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x0)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.2.0_lo.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.2.0_lo.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x0)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.2.0_lo.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a2, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.2.0_lo.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x0)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.2.1_lo.u.3:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.2.1_lo.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x1)
  %x4 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.2.1_lo.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a2, $a0
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.2.1_lo.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x1)
  %x4 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.2.1_lo.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a2, $a1
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.2.1_lo.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x1)
  %x4 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.2.1_lo.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.2.1_lo.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x1)
  %x4 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.2.1_lo.3.u:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.2.1_lo.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x1)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.2.1_lo.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a2, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.2.1_lo.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x1)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.2.1_lo.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a2, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.2.1_lo.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x1)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.2.1_lo.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.2.1_lo.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x1)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.2.1_lo.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a2, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.2.1_lo.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x1)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.2.2_lo.u.3:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.2.2_lo.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x2)
  %x4 = call <2 x half> @sortlo(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.2.2_lo.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a2, $a0
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.2.2_lo.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x2)
  %x4 = call <2 x half> @sortlo(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.2.2_lo.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a2, $a1
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.2.2_lo.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x2)
  %x4 = call <2 x half> @sortlo(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.2.2_lo.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.2.2_lo.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x2)
  %x4 = call <2 x half> @sortlo(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.2.2_lo.3.u:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.2.2_lo.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x2)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.2.2_lo.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a2, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.2.2_lo.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x2)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.2.2_lo.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a2, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.2.2_lo.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x2)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.2.2_lo.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.2.2_lo.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x2)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.2.2_lo.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a2, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.2.2_lo.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x2)
  %x4 = call <2 x half> @sortlo(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.u.u_hi.u.3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.u.u_hi.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> undef, <2 x half> undef)
  %x4 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.u.u_hi.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.u.u_hi.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> undef, <2 x half> undef)
  %x4 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.u.u_hi.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.u.u_hi.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> undef, <2 x half> undef)
  %x4 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.u.u_hi.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.u.u_hi.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> undef, <2 x half> undef)
  %x4 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.u.u_hi.3.u:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.u.u_hi.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> undef, <2 x half> undef)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.u.u_hi.3.0:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.u.u_hi.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> undef, <2 x half> undef)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.u.u_hi.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.u.u_hi.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> undef, <2 x half> undef)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.u.u_hi.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.u.u_hi.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> undef, <2 x half> undef)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.u.u_hi.3.3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.u.u_hi.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> undef, <2 x half> undef)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.u.0_hi.u.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.u.0_hi.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x0)
  %x4 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.u.0_hi.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.u.0_hi.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x0)
  %x4 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.u.0_hi.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a1, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.u.0_hi.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x0)
  %x4 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.u.0_hi.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a2, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.u.0_hi.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x0)
  %x4 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.u.0_hi.3.u:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.u.0_hi.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x0)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.u.0_hi.3.0:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.u.0_hi.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x0)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.u.0_hi.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a1, $a0
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.u.0_hi.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x0)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.u.0_hi.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a2, $a0
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.u.0_hi.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x0)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.u.0_hi.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.u.0_hi.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x0)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.u.1_hi.u.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.u.1_hi.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x1)
  %x4 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.u.1_hi.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.u.1_hi.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x1)
  %x4 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.u.1_hi.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.u.1_hi.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x1)
  %x4 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.u.1_hi.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a2, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.u.1_hi.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x1)
  %x4 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.u.1_hi.3.u:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.u.1_hi.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x1)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.u.1_hi.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a0, $a1
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.u.1_hi.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x1)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.u.1_hi.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.u.1_hi.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x1)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.u.1_hi.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a2, $a1
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.u.1_hi.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x1)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.u.1_hi.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a1, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.u.1_hi.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x1)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.u.2_hi.u.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.u.2_hi.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x2)
  %x4 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.u.2_hi.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.u.2_hi.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x2)
  %x4 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.u.2_hi.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a1, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.u.2_hi.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x2)
  %x4 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.u.2_hi.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.u.2_hi.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x2)
  %x4 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.u.2_hi.3.u:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.u.2_hi.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x2)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.u.2_hi.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a0, $a2
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.u.2_hi.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x2)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.u.2_hi.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a1, $a2
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.u.2_hi.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x2)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.u.2_hi.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.u.2_hi.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x2)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.u.2_hi.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a2, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.u.2_hi.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x2)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.0.u_hi.u.3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.0.u_hi.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> undef)
  %x4 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.0.u_hi.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.0.u_hi.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> undef)
  %x4 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.0.u_hi.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.0.u_hi.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> undef)
  %x4 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.0.u_hi.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.0.u_hi.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> undef)
  %x4 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.0.u_hi.3.u:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.0.u_hi.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> undef)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.0.u_hi.3.0:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.0.u_hi.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> undef)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.0.u_hi.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.0.u_hi.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> undef)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.0.u_hi.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.0.u_hi.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> undef)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.0.u_hi.3.3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.0.u_hi.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> undef)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.0.0_hi.u.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.0.0_hi.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x0)
  %x4 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.0.0_hi.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.0.0_hi.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x0)
  %x4 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.0.0_hi.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a1, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.0.0_hi.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x0)
  %x4 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.0.0_hi.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a2, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.0.0_hi.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x0)
  %x4 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.0.0_hi.3.u:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.0.0_hi.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x0)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.0.0_hi.3.0:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.0.0_hi.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x0)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.0.0_hi.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a1, $a0
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.0.0_hi.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x0)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.0.0_hi.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a2, $a0
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.0.0_hi.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x0)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.0.0_hi.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.0.0_hi.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x0)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.0.1_hi.u.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.0.1_hi.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x1)
  %x4 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.0.1_hi.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.0.1_hi.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x1)
  %x4 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.0.1_hi.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.0.1_hi.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x1)
  %x4 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.0.1_hi.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a2, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.0.1_hi.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x1)
  %x4 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.0.1_hi.3.u:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.0.1_hi.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x1)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.0.1_hi.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a0, $a1
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.0.1_hi.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x1)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.0.1_hi.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.0.1_hi.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x1)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.0.1_hi.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a2, $a1
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.0.1_hi.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x1)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.0.1_hi.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a1, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.0.1_hi.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x1)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.0.2_hi.u.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.0.2_hi.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x2)
  %x4 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.0.2_hi.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.0.2_hi.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x2)
  %x4 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.0.2_hi.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a1, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.0.2_hi.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x2)
  %x4 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.0.2_hi.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.0.2_hi.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x2)
  %x4 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.0.2_hi.3.u:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.0.2_hi.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x2)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.0.2_hi.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a0, $a2
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.0.2_hi.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x2)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.0.2_hi.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a1, $a2
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.0.2_hi.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x2)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.0.2_hi.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.0.2_hi.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x2)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.0.2_hi.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a2, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.0.2_hi.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x2)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.1.u_hi.u.3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.1.u_hi.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> undef)
  %x4 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.1.u_hi.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.1.u_hi.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> undef)
  %x4 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.1.u_hi.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.1.u_hi.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> undef)
  %x4 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.1.u_hi.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.1.u_hi.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> undef)
  %x4 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.1.u_hi.3.u:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.1.u_hi.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> undef)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.1.u_hi.3.0:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.1.u_hi.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> undef)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.1.u_hi.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.1.u_hi.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> undef)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.1.u_hi.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.1.u_hi.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> undef)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.1.u_hi.3.3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.1.u_hi.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> undef)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.1.0_hi.u.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.1.0_hi.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x0)
  %x4 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.1.0_hi.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.1.0_hi.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x0)
  %x4 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.1.0_hi.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a1, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.1.0_hi.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x0)
  %x4 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.1.0_hi.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a2, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.1.0_hi.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x0)
  %x4 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.1.0_hi.3.u:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.1.0_hi.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x0)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.1.0_hi.3.0:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.1.0_hi.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x0)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.1.0_hi.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a1, $a0
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.1.0_hi.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x0)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.1.0_hi.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a2, $a0
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.1.0_hi.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x0)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.1.0_hi.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.1.0_hi.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x0)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.1.1_hi.u.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.1.1_hi.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x1)
  %x4 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.1.1_hi.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.1.1_hi.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x1)
  %x4 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.1.1_hi.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.1.1_hi.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x1)
  %x4 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.1.1_hi.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a2, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.1.1_hi.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x1)
  %x4 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.1.1_hi.3.u:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.1.1_hi.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x1)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.1.1_hi.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a0, $a1
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.1.1_hi.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x1)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.1.1_hi.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.1.1_hi.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x1)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.1.1_hi.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a2, $a1
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.1.1_hi.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x1)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.1.1_hi.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a1, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.1.1_hi.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x1)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.1.2_hi.u.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.1.2_hi.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x2)
  %x4 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.1.2_hi.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.1.2_hi.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x2)
  %x4 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.1.2_hi.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a1, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.1.2_hi.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x2)
  %x4 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.1.2_hi.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.1.2_hi.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x2)
  %x4 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.1.2_hi.3.u:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.1.2_hi.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x2)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.1.2_hi.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a0, $a2
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.1.2_hi.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x2)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.1.2_hi.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a1, $a2
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.1.2_hi.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x2)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.1.2_hi.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.1.2_hi.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x2)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.1.2_hi.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a2, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.1.2_hi.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x2)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.2.u_hi.u.3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.2.u_hi.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> undef)
  %x4 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.2.u_hi.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.2.u_hi.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> undef)
  %x4 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.2.u_hi.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.2.u_hi.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> undef)
  %x4 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.2.u_hi.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.2.u_hi.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> undef)
  %x4 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.2.u_hi.3.u:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.2.u_hi.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> undef)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.2.u_hi.3.0:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.2.u_hi.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> undef)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.2.u_hi.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.2.u_hi.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> undef)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.2.u_hi.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.2.u_hi.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> undef)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.2.u_hi.3.3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.2.u_hi.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> undef)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.2.0_hi.u.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.2.0_hi.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x0)
  %x4 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.2.0_hi.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.2.0_hi.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x0)
  %x4 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.2.0_hi.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a1, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.2.0_hi.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x0)
  %x4 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.2.0_hi.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a2, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.2.0_hi.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x0)
  %x4 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.2.0_hi.3.u:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.2.0_hi.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x0)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.2.0_hi.3.0:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.2.0_hi.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x0)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.2.0_hi.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a1, $a0
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.2.0_hi.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x0)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.2.0_hi.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a2, $a0
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.2.0_hi.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x0)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.2.0_hi.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.2.0_hi.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x0)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.2.1_hi.u.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.2.1_hi.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x1)
  %x4 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.2.1_hi.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.2.1_hi.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x1)
  %x4 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.2.1_hi.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.2.1_hi.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x1)
  %x4 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.2.1_hi.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a2, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.2.1_hi.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x1)
  %x4 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.2.1_hi.3.u:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.2.1_hi.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x1)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.2.1_hi.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a0, $a1
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.2.1_hi.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x1)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.2.1_hi.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.2.1_hi.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x1)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.2.1_hi.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a2, $a1
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.2.1_hi.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x1)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.2.1_hi.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a1, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.2.1_hi.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x1)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.2.2_hi.u.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.2.2_hi.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x2)
  %x4 = call <2 x half> @sorthi(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.2.2_hi.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.2.2_hi.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x2)
  %x4 = call <2 x half> @sorthi(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.2.2_hi.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a1, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.2.2_hi.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x2)
  %x4 = call <2 x half> @sorthi(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.2.2_hi.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.2.2_hi.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x2)
  %x4 = call <2 x half> @sorthi(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.2.2_hi.3.u:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.2.2_hi.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x2)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.2.2_hi.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a0, $a2
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.2.2_hi.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x2)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.2.2_hi.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a1, $a2
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.2.2_hi.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x2)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.2.2_hi.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.2.2_hi.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x2)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.2.2_hi.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a2, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.2.2_hi.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x2)
  %x4 = call <2 x half> @sorthi(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.u.u_rl.u.3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.u.u_rl.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> undef, <2 x half> undef)
  %x4 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.u.u_rl.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.u.u_rl.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> undef, <2 x half> undef)
  %x4 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.u.u_rl.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.u.u_rl.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> undef, <2 x half> undef)
  %x4 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.u.u_rl.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.u.u_rl.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> undef, <2 x half> undef)
  %x4 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.u.u_rl.3.u:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.u.u_rl.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> undef, <2 x half> undef)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.u.u_rl.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.u.u_rl.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> undef, <2 x half> undef)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.u.u_rl.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.u.u_rl.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> undef, <2 x half> undef)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.u.u_rl.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.u.u_rl.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> undef, <2 x half> undef)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.u.u_rl.3.3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.u.u_rl.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> undef, <2 x half> undef)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.u.0_rl.u.3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.u.0_rl.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x0)
  %x4 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.u.0_rl.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.u.0_rl.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x0)
  %x4 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.u.0_rl.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.u.0_rl.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x0)
  %x4 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.u.0_rl.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.u.0_rl.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x0)
  %x4 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.u.0_rl.3.u:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.u.0_rl.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x0)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.u.0_rl.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.u.0_rl.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x0)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.u.0_rl.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.u.0_rl.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x0)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.u.0_rl.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.u.0_rl.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x0)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.u.0_rl.3.3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.u.0_rl.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x0)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.u.1_rl.u.3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.u.1_rl.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x1)
  %x4 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.u.1_rl.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.u.1_rl.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x1)
  %x4 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.u.1_rl.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.u.1_rl.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x1)
  %x4 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.u.1_rl.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.u.1_rl.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x1)
  %x4 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.u.1_rl.3.u:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.u.1_rl.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x1)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.u.1_rl.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a1, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.u.1_rl.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x1)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.u.1_rl.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a1, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.u.1_rl.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x1)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.u.1_rl.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a1, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.u.1_rl.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x1)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.u.1_rl.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.u.1_rl.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x1)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.u.2_rl.u.3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.u.2_rl.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x2)
  %x4 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.u.2_rl.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.u.2_rl.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x2)
  %x4 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.u.2_rl.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.u.2_rl.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x2)
  %x4 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.u.2_rl.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.u.2_rl.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x2)
  %x4 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.u.2_rl.3.u:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.u.2_rl.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x2)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.u.2_rl.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a2, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.u.2_rl.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x2)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.u.2_rl.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a2, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.u.2_rl.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x2)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.u.2_rl.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a2, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.u.2_rl.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x2)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.u.2_rl.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.u.2_rl.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x2)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.0.u_rl.u.3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.0.u_rl.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> undef)
  %x4 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.0.u_rl.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.0.u_rl.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> undef)
  %x4 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.0.u_rl.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a1, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.0.u_rl.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> undef)
  %x4 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.0.u_rl.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a2, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.0.u_rl.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> undef)
  %x4 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.0.u_rl.3.u:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.0.u_rl.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> undef)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.0.u_rl.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.0.u_rl.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> undef)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.0.u_rl.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.0.u_rl.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> undef)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.0.u_rl.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.0.u_rl.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> undef)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.0.u_rl.3.3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.0.u_rl.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> undef)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.0.0_rl.u.3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.0.0_rl.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x0)
  %x4 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.0.0_rl.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.0.0_rl.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x0)
  %x4 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.0.0_rl.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a1, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.0.0_rl.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x0)
  %x4 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.0.0_rl.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a2, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.0.0_rl.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x0)
  %x4 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.0.0_rl.3.u:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.0.0_rl.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x0)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.0.0_rl.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.0.0_rl.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x0)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.0.0_rl.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.0.0_rl.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x0)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.0.0_rl.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.0.0_rl.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x0)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.0.0_rl.3.3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.0.0_rl.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x0)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.0.1_rl.u.3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.0.1_rl.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x1)
  %x4 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.0.1_rl.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.0.1_rl.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x1)
  %x4 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.0.1_rl.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a1, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.0.1_rl.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x1)
  %x4 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.0.1_rl.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a2, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.0.1_rl.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x1)
  %x4 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.0.1_rl.3.u:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.0.1_rl.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x1)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.0.1_rl.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a1, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.0.1_rl.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x1)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.0.1_rl.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a1, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.0.1_rl.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x1)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.0.1_rl.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a1, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.0.1_rl.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x1)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.0.1_rl.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a0, $a1
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.0.1_rl.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x1)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.0.2_rl.u.3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.0.2_rl.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x2)
  %x4 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.0.2_rl.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.0.2_rl.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x2)
  %x4 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.0.2_rl.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a1, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.0.2_rl.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x2)
  %x4 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.0.2_rl.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a2, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.0.2_rl.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x2)
  %x4 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.0.2_rl.3.u:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.0.2_rl.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x2)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.0.2_rl.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a2, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.0.2_rl.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x2)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.0.2_rl.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a2, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.0.2_rl.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x2)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.0.2_rl.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a2, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.0.2_rl.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x2)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.0.2_rl.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a0, $a2
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.0.2_rl.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x2)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.1.u_rl.u.3:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.1.u_rl.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> undef)
  %x4 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.1.u_rl.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.1.u_rl.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> undef)
  %x4 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.1.u_rl.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a1, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.1.u_rl.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> undef)
  %x4 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.1.u_rl.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a2, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.1.u_rl.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> undef)
  %x4 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.1.u_rl.3.u:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.1.u_rl.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> undef)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.1.u_rl.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.1.u_rl.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> undef)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.1.u_rl.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.1.u_rl.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> undef)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.1.u_rl.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.1.u_rl.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> undef)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.1.u_rl.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.1.u_rl.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> undef)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.1.0_rl.u.3:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.1.0_rl.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x0)
  %x4 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.1.0_rl.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.1.0_rl.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x0)
  %x4 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.1.0_rl.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a1, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.1.0_rl.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x0)
  %x4 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.1.0_rl.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a2, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.1.0_rl.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x0)
  %x4 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.1.0_rl.3.u:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.1.0_rl.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x0)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.1.0_rl.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.1.0_rl.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x0)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.1.0_rl.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.1.0_rl.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x0)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.1.0_rl.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.1.0_rl.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x0)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.1.0_rl.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a1, $a0
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.1.0_rl.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x0)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.1.1_rl.u.3:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.1.1_rl.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x1)
  %x4 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.1.1_rl.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.1.1_rl.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x1)
  %x4 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.1.1_rl.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a1, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.1.1_rl.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x1)
  %x4 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.1.1_rl.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a2, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.1.1_rl.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x1)
  %x4 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.1.1_rl.3.u:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.1.1_rl.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x1)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.1.1_rl.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a1, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.1.1_rl.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x1)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.1.1_rl.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a1, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.1.1_rl.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x1)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.1.1_rl.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a1, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.1.1_rl.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x1)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.1.1_rl.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.1.1_rl.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x1)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.1.2_rl.u.3:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.1.2_rl.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x2)
  %x4 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.1.2_rl.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.1.2_rl.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x2)
  %x4 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.1.2_rl.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a1, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.1.2_rl.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x2)
  %x4 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.1.2_rl.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a2, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.1.2_rl.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x2)
  %x4 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.1.2_rl.3.u:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.1.2_rl.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x2)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.1.2_rl.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a2, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.1.2_rl.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x2)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.1.2_rl.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a2, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.1.2_rl.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x2)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.1.2_rl.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a2, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.1.2_rl.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x2)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.1.2_rl.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a1, $a2
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.1.2_rl.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x2)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.2.u_rl.u.3:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.2.u_rl.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> undef)
  %x4 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.2.u_rl.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.2.u_rl.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> undef)
  %x4 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.2.u_rl.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a1, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.2.u_rl.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> undef)
  %x4 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.2.u_rl.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a2, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.2.u_rl.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> undef)
  %x4 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.2.u_rl.3.u:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.2.u_rl.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> undef)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.2.u_rl.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.2.u_rl.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> undef)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.2.u_rl.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.2.u_rl.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> undef)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.2.u_rl.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.2.u_rl.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> undef)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.2.u_rl.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.2.u_rl.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> undef)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.2.0_rl.u.3:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.2.0_rl.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x0)
  %x4 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.2.0_rl.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.2.0_rl.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x0)
  %x4 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.2.0_rl.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a1, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.2.0_rl.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x0)
  %x4 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.2.0_rl.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a2, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.2.0_rl.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x0)
  %x4 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.2.0_rl.3.u:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.2.0_rl.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x0)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.2.0_rl.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.2.0_rl.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x0)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.2.0_rl.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.2.0_rl.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x0)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.2.0_rl.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.2.0_rl.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x0)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.2.0_rl.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a2, $a0
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.2.0_rl.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x0)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.2.1_rl.u.3:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.2.1_rl.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x1)
  %x4 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.2.1_rl.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.2.1_rl.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x1)
  %x4 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.2.1_rl.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a1, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.2.1_rl.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x1)
  %x4 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.2.1_rl.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a2, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.2.1_rl.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x1)
  %x4 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.2.1_rl.3.u:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.2.1_rl.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x1)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.2.1_rl.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a1, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.2.1_rl.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x1)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.2.1_rl.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a1, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.2.1_rl.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x1)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.2.1_rl.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a1, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.2.1_rl.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x1)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.2.1_rl.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  roll16 $a0, $a2, $a1
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.2.1_rl.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x1)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.2.2_rl.u.3:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.2.2_rl.u.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x2)
  %x4 = call <2 x half> @roll16(<2 x half> undef, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.2.2_rl.0.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.2.2_rl.0.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x2)
  %x4 = call <2 x half> @roll16(<2 x half> %x0, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.2.2_rl.1.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a1, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.2.2_rl.1.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x2)
  %x4 = call <2 x half> @roll16(<2 x half> %x1, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.2.2_rl.2.3:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16hi $a0, $a2, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.2.2_rl.2.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x2)
  %x4 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x3)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.2.2_rl.3.u:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.2.2_rl.3.u(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x2)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> undef)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.2.2_rl.3.0:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a2, $a0
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.2.2_rl.3.0(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x2)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x0)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.2.2_rl.3.1:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a2, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.2.2_rl.3.1(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x2)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x1)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.2.2_rl.3.2:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a2, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.2.2_rl.3.2(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x2)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x2)
  ret <2 x half> %x4
}

; CHECK-LABEL: test_rl.2.2_rl.3.3:
; CHECK:       # %bb
; CHECK-NEXT:  mov $a0, $a2
; CHECK-NEXT:  br $m10
define <2 x half> @test_rl.2.2_rl.3.3(<2 x half> %x0, <2 x half> %x1, <2 x half> %x2) {
  %x3 = call <2 x half> @roll16(<2 x half> %x2, <2 x half> %x2)
  %x4 = call <2 x half> @roll16(<2 x half> %x3, <2 x half> %x3)
  ret <2 x half> %x4
}
