; RUN: llc < %s -march=colossus -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -march=colossus -mattr=+ipu2 | FileCheck %s

; CHECK-LABEL: test_no_ops:
; CHECK:       nop
define void @test_no_ops() nounwind {
  tail call void asm sideeffect "nop", ""() nounwind
  ret void
}

; CHECK-LABEL: test_reg_dst:
; CHECK:       exitneg $m0
define i32 @test_reg_dst() nounwind {
  %1 = tail call i32 asm sideeffect "exitneg $0", "=r"() nounwind
  ret i32 %1
}

; CHECK-LABEL: test_reg_src:
; CHECK:       exitneg $m0
define void @test_reg_src(i32 %a) nounwind {
  tail call void asm sideeffect "exitneg $0", "r"(i32 %a) nounwind
  ret void
}

; CHECK-LABEL: test_imm_op:
; CHECK:       bri 0xa8
define void @test_imm_op() nounwind {
  tail call void asm sideeffect "bri $0", "i"(i32 42) nounwind
  ret void
}

@x = external global i32

; CHECK-LABEL: test_mem_op:
; CHECK:       andc $m0, $m0, 0
define i32 @test_mem_op() nounwind {
  %1 = call i32 asm "andc $0, $1", "=r,*m"(i32* elementtype(i32) @x) nounwind
  ret i32 %1
}

@y = dso_local global [10 x i32] zeroinitializer, align 4

; CHECK-LABEL: test_indexed_mem_op:
; CHECK:       setzi $m0, y+20
; CHECK:       andc $m0, $m0, 0
define i32 @test_indexed_mem_op() nounwind {
  %1 = getelementptr inbounds [10 x i32], [10 x i32]* @y, i32 0, i32 5
  %2 = call i32 asm "andc $0, $1", "=r,*m"(i32* elementtype(i32) %1) nounwind
  ret i32 %2
}

; CHECK-LABEL: test_reg_constraint:
; CHECK: mov $m10, $m0
; CHECK: exitneg $m10
define void @test_reg_constraint(i32 %x) nounwind {
  call void asm sideeffect "exitneg $0", "{$m10}"(i32 %x) nounwind
  ret void
}

; CHECK-LABEL: test_reg_clobber_constraint:
; CHECK: st32 $m9, $m11, $m15, 1
; CHECK: exitneg $m9
; CHECK: ld32 $m9, $m11, $m15, 1
define void @test_reg_clobber_constraint(i32 %x) nounwind {
  call void asm sideeffect "exitneg $0", "~{$m9}"() nounwind
  ret void
}

; CHECK-LABEL: test_get_reg_for_constraint_i16:
; CHECK:       exitneg $m0
define void @test_get_reg_for_constraint_i16(i16 %a) {
  call void asm sideeffect "exitneg $0", "r"(i16 %a)
  ret void
}

; CHECK-LABEL: test_get_reg_for_constraint_v2i16:
; CHECK:       exitneg $m0
define void @test_get_reg_for_constraint_v2i16(<2 x i16> %a) {
  call void asm sideeffect "exitneg $0", "r"(<2 x i16> %a)
  ret void
}

; CHECK-LABEL: test_get_reg_for_constraint_half:
; CHECK:       f16tof32 $a0
; CHECK:       get $a0, 0
define void @test_get_reg_for_constraint_half(half* %a) {
  %value = load half, half* %a
  call void asm sideeffect "get $0, 0", "r"(half %value)
  ret void
}

; CHECK-LABEL: test_get_reg_for_constraint_v2i32:
; CHECK:       tapack $m0:1, $m2, $m2, $m2
define void @test_get_reg_for_constraint_v2i32(<2 x i32> %a, i32 %b) {
  call void asm sideeffect "tapack $0, $1, $1, $1", "r,r"(<2 x i32> %a, i32 %b)
  ret void
}

; CHECK-LABEL: test_get_reg_for_constraint_v2f32:
; CHECK:       f16v4gacc $a0:1
define void @test_get_reg_for_constraint_v2f32(<2 x float> %a) {
  call void asm sideeffect "f16v4gacc $0", "r"(<2 x float> %a)
  ret void
}

; CHECK-LABEL: test_get_reg_for_constraint_v4f16:
; CHECK:       f16v4gacc $a0:1
define void @test_get_reg_for_constraint_v4f16(<4 x half> %a) {
  call void asm sideeffect "f16v4gacc $0", "r"(<4 x half> %a)
  ret void
}

; CHECK-LABEL: test_specific_m0
; CHECK:       setzi $m0, 0
define void @test_specific_m0() {
 call void asm sideeffect "setzi $0, 0", "~{$m0}"()
 ret void
}

; CHECK-LABEL: test_specific_m11
; CHECK:       setzi $m11, 0
define void @test_specific_m11() {
 call void asm sideeffect "setzi $0, 0", "~{$m11}"()
 ret void
}

; CHECK-LABEL: test_specific_m01
; CHECK:       mov $m0, $m15
; CHECK:       mov $m1, $m15
define void @test_specific_m01() {
 call void asm sideeffect "mov $$m0, $$m15\0a\09mov $$m1, $$m15", "~{$m0:1}"()
 ret void
}

; CHECK-LABEL: test_specific_m23
; CHECK:       mov $m2, $m15
; CHECK:       mov $m3, $m15
define void @test_specific_m23() {
 call void asm sideeffect "mov $$m2, $$m15\0a\09mov $$m3, $$m15", "~{$m2:3}"()
 ret void
}

; CHECK-LABEL: test_specific_a1
; CHECK:       setzi $a1, 0
define void @test_specific_a1() {
 call void asm sideeffect "setzi $0, 0", "~{$a1}"()
 ret void
}

; CHECK-LABEL: test_specific_a7
; CHECK:       setzi $a7, 0
define void @test_specific_a7() {
 call void asm sideeffect "setzi $0, 0", "~{$a7}"()
 ret void
}

; CHECK-LABEL: test_specific_a01
; CHECK:       zero $a0:1
define void @test_specific_a01() {
 call void asm sideeffect "mov $0, $$azeros", "~{$a0:1}"()
 ret void
}

; CHECK-LABEL: test_specific_a45
; CHECK:       zero $a4:5
define void @test_specific_a45() {
 call void asm sideeffect "mov $0, $$azeros", "~{$a4:5}"()
 ret void
}

; CHECK-LABEL: test_specific_a03
; CHECK:       zero $a0:1
; CHECK:       zero $a2:3
define void @test_specific_a03() {
 call void asm sideeffect "mov $$a0:1, $$azeros\0a\09mov $$a2:3, $$azeros", "~{$a0:3}"()
 ret void
}

; CHECK-LABEL: test_specific_a47
; CHECK:       zero $a4:5
; CHECK:       zero $a6:7
define void @test_specific_a47() {
 call void asm sideeffect "mov $$a4:5, $$azeros\0a\09mov $$a6:7, $$azeros", "~{$a4:7}"()
 ret void
}
