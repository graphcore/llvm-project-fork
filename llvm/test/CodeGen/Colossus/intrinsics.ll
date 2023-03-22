; RUN: llc < %s -march=colossus -mattr=+ipu1 | \
; RUN:     FileCheck %s --check-prefixes=CHECK,CHECK-IPU1_2
; RUN: llc < %s -march=colossus -mattr=+ipu2 | \
; RUN:     FileCheck %s --check-prefixes=CHECK,CHECK-IPU1_2


declare i32 @llvm.colossus.get.scount.l()
declare i32 @llvm.colossus.get.scount.u()
declare i8* @llvm.colossus.get.vertex.base()
declare i32 @llvm.colossus.get.tile.id()
declare i32 @llvm.colossus.get.worker.id()
declare <2 x i32> @llvm.colossus.tapack(i8*,i8*,i8*)
declare i32 @llvm.colossus.urand32()
declare i64 @llvm.colossus.urand64()
declare half @llvm.colossus.urand.f16()
declare float @llvm.colossus.urand.f32()
declare <2 x i16> @llvm.colossus.f16v2class(<2 x half>)
declare <4 x i16> @llvm.colossus.f16v4class(<4 x half>)
declare <2 x i16> @llvm.colossus.f32v2class(<2 x float>)
declare i32 @llvm.colossus.f32class(float)
declare i32 @llvm.colossus.get(i32)
declare i32 @llvm.colossus.uget(i32)
declare float @llvm.colossus.ugetf(i32)
declare void @llvm.colossus.put(i32, i32)
declare void @llvm.colossus.uput(i32, i32)
declare void @llvm.colossus.uputf(float, i32)
declare i1 @llvm.colossus.is.worker.mode()
declare i32 @llvm.colossus.and.i32(i32, i32)
declare float @llvm.colossus.and.f32(float, float)
declare <2 x float> @llvm.colossus.and.v2f32(<2 x float>, <2 x float>)
declare i32 @llvm.colossus.andc.i32(i32, i32)
declare float @llvm.colossus.andc.f32(float, float)
declare <2 x float> @llvm.colossus.andc.v2f32(<2 x float>, <2 x float>)
declare i32 @llvm.colossus.or.i32(i32, i32)
declare float @llvm.colossus.or.f32(float, float)
declare <2 x float> @llvm.colossus.or.v2f32(<2 x float>, <2 x float>)
declare float @llvm.colossus.not.f32(float)
declare <2 x float> @llvm.colossus.not.v2f32(<2 x float>)
declare i32 @llvm.colossus.bitrev8(i32)
declare i32 @llvm.colossus.roll8l(i32, i32)
declare i32 @llvm.colossus.roll8r(i32, i32)
declare <2 x float> @llvm.colossus.roll32(<2 x float>, <2 x float>)
declare i32 @llvm.colossus.shuf8x8hi(i32, i32)
declare i32 @llvm.colossus.shuf8x8lo(i32, i32)
declare <2 x float> @llvm.colossus.sort4x32hi(<2 x float>, <2 x float>)
declare <2 x float> @llvm.colossus.sort4x32lo(<2 x float>, <2 x float>)
declare i32 @llvm.colossus.sort8x8hi(i32, i32)
declare i32 @llvm.colossus.sort8x8lo(i32, i32)
declare i32 @llvm.colossus.sort8(i32)
declare i32 @llvm.colossus.swap8(i32)
declare i32 @llvm.colossus.cms(i32)
declare <2 x half> @llvm.colossus.f16v2absadd(<2 x half>, <2 x half>)
declare <4 x half> @llvm.colossus.f16v4absadd(<4 x half>, <4 x half>)
declare <2 x float> @llvm.colossus.f32v2absadd(<2 x float>, <2 x float>)
declare float @llvm.colossus.f32absadd(float, float)
declare <2 x half> @llvm.colossus.f16v2absmax(<2 x half>, <2 x half>)
declare <4 x half> @llvm.colossus.f16v4absmax(<4 x half>, <4 x half>)
declare <2 x float> @llvm.colossus.f32v2absmax(<2 x float>, <2 x float>)
declare float @llvm.colossus.f32absmax(float, float)
declare <2 x half> @llvm.colossus.f16v2max(<2 x half>, <2 x half>)
declare <4 x half> @llvm.colossus.f16v4max(<4 x half>, <4 x half>)
declare <2 x float> @llvm.colossus.f32v2max(<2 x float>, <2 x float>)
declare float @llvm.colossus.f32max(float, float)
declare half @llvm.colossus.f16v2maxc(<2 x half>)
declare <2 x half> @llvm.colossus.f16v4maxc(<4 x half>)
declare <2 x half> @llvm.colossus.f16v2min(<2 x half>, <2 x half>)
declare <4 x half> @llvm.colossus.f16v4min(<4 x half>, <4 x half>)
declare <2 x float> @llvm.colossus.f32v2min(<2 x float>, <2 x float>)
declare float @llvm.colossus.f32min(float, float)
declare <2 x half> @llvm.colossus.f16v2clamp(<2 x half>, <2 x half>)
declare <4 x half> @llvm.colossus.f16v4clamp(<4 x half>, <2 x half>)
declare <2 x float> @llvm.colossus.f32v2clamp(<2 x float>, <2 x float>)
declare float @llvm.colossus.f32clamp(float, <2 x float>)
declare void @llvm.colossus.f16v2cmac(<2 x half>, <2 x half>)
declare void @llvm.colossus.f16v4cmac(<4 x half>, <4 x half>)
declare <2 x half> @llvm.colossus.f16v2cmpeq(<2 x half>, <2 x half>)
declare <4 x half> @llvm.colossus.f16v4cmpeq(<4 x half>, <4 x half>)
declare <2 x float> @llvm.colossus.f32v2cmpeq(<2 x float>, <2 x float>)
declare float @llvm.colossus.f32cmpeq(float, float)
declare <2 x half> @llvm.colossus.f16v2cmpge(<2 x half>, <2 x half>)
declare <4 x half> @llvm.colossus.f16v4cmpge(<4 x half>, <4 x half>)
declare <2 x float> @llvm.colossus.f32v2cmpge(<2 x float>, <2 x float>)
declare float @llvm.colossus.f32cmpge(float, float)
declare <2 x half> @llvm.colossus.f16v2cmpgt(<2 x half>, <2 x half>)
declare <4 x half> @llvm.colossus.f16v4cmpgt(<4 x half>, <4 x half>)
declare <2 x float> @llvm.colossus.f32v2cmpgt(<2 x float>, <2 x float>)
declare float @llvm.colossus.f32cmpgt(float, float)
declare <2 x half> @llvm.colossus.f16v2cmple(<2 x half>, <2 x half>)
declare <4 x half> @llvm.colossus.f16v4cmple(<4 x half>, <4 x half>)
declare <2 x float> @llvm.colossus.f32v2cmple(<2 x float>, <2 x float>)
declare float @llvm.colossus.f32cmple(float, float)
declare <2 x half> @llvm.colossus.f16v2cmplt(<2 x half>, <2 x half>)
declare <4 x half> @llvm.colossus.f16v4cmplt(<4 x half>, <4 x half>)
declare <2 x float> @llvm.colossus.f32v2cmplt(<2 x float>, <2 x float>)
declare float @llvm.colossus.f32cmplt(float, float)
declare <2 x half> @llvm.colossus.f16v2cmpne(<2 x half>, <2 x half>)
declare <4 x half> @llvm.colossus.f16v4cmpne(<4 x half>, <4 x half>)
declare <2 x float> @llvm.colossus.f32v2cmpne(<2 x float>, <2 x float>)
declare float @llvm.colossus.f32cmpne(float, float)
declare <2 x half> @llvm.colossus.f16v2exp(<2 x half>)
declare <2 x half> @llvm.colossus.f16v2exp2(<2 x half>)
declare <2 x half> @llvm.colossus.f16v2ln(<2 x half>)
declare <2 x half> @llvm.colossus.f16v2log2(<2 x half>)
declare void @llvm.colossus.f32v2aop(<2 x float>, <2 x float>, i32)
declare <2 x float> @llvm.colossus.f32v2axpy(<2 x float>, <2 x float>)
declare <2 x half> @llvm.colossus.f16v2gina(<2 x half>, i32)
declare <2 x float> @llvm.colossus.f32v2gina(<2 x float>, i32)
declare <2 x half> @llvm.colossus.f16v2grand()
declare <2 x float> @llvm.colossus.f32v2grand()
declare <4 x half> @llvm.colossus.f16v4rmask(<4 x half>, float)
declare <2 x float> @llvm.colossus.f32v2rmask(<2 x float>, float)
declare <2 x half> @llvm.colossus.f16v2sigm(<2 x half>)
declare float @llvm.colossus.f32sigm(float)
declare float @llvm.colossus.f16v2sum(<2 x half>)
declare <2 x float> @llvm.colossus.f16v4sum(<4 x half>)
declare <2 x half> @llvm.colossus.f16v2tanh(<2 x half>)

; CHECK-LABEL: get_scount_l:
; CHECK:       get $m0, 96
define i32 @get_scount_l() {
  %1 = call i32 @llvm.colossus.get.scount.l()
  ret i32 %1
}

; CHECK-LABEL: get_scount_u:
; CHECK:       get $m0, 97
define i32 @get_scount_u() {
  %1 = call i32 @llvm.colossus.get.scount.u()
  ret i32 %1
}

; Check that MachineCSE doesn't eliminate duplicate rdrand instructions.
; CHECK-LABEL: test_no_elim:
; CHECK:       get
; CHECK:       get
define i32 @test_no_elim() {
 %1 = call i32 @llvm.colossus.get.scount.l()
 %2 = call i32 @llvm.colossus.get.scount.l()
 %add = add i32 %2, %1
 ret i32 %add
}

; CHECK-LABEL: get_vertex_base:
; CHECK:       mov $m0, $m13
define i8* @get_vertex_base() {
  %1 = call i8* @llvm.colossus.get.vertex.base()
  ret i8* %1
}

; CHECK-LABEL: get_tile_id:
; CHECK:       get $m0, 3
define i32 @get_tile_id() {
  %1 = call i32 @llvm.colossus.get.tile.id()
  ret i32 %1
}

; CHECK-LABEL: get_worker_id:
; CHECK:       get $m0, 1
; CHECK-NEXT:  and $m0, $m0, 7
define i32 @get_worker_id() {
  %1 = call i32 @llvm.colossus.get.worker.id()
  ret i32 %1
}

; CHECK-LABEL: test_tapack:
; CHECK:       tapack $m0:1, $m0, $m1, $m2
define <2 x i32> @test_tapack(i8* %x, i8* %y, i8* %z) {
  %res = call <2 x i32> @llvm.colossus.tapack(i8* %x, i8* %y, i8* %z)
  ret <2 x i32> %res
}

; CHECK-LABEL: test_urand32:
; CHECK:       urand32 $a0
; CHECK:       mov     $m0, $a0
define i32 @test_urand32() {
  %r = call i32 @llvm.colossus.urand32()
  ret i32 %r
}

; CHECK-LABEL: test_urand64:
; CHECK:       urand64 $a0:1
; CHECK:       mov     $m0, $a0
; CHECK:       mov     $m1, $a1
define i64 @test_urand64() {
  %r = call i64 @llvm.colossus.urand64()
  ret i64 %r
}

; CHECK-LABEL: test_urand_f16
; CHECK:       urand32 $a0
; CHECK-NEXT:  {
; CHECK-NEXT:     br $m10
; CHECK-NEXT:     f16v2sufromui $a0, $a0
; CHECK-NEXT:  }
define half @test_urand_f16() {
  %r = call half @llvm.colossus.urand.f16()
  ret half %r
}

; CHECK-LABEL: test_urand_f32
; CHECK:       urand32 $a0
; CHECK-NEXT:  {
; CHECK-NEXT:     br $m10
; CHECK-NEXT:     f32sufromui $a0, $a0
; CHECK-NEXT:  }
define float @test_urand_f32() {
  %r = call float @llvm.colossus.urand.f32()
  ret float %r
}

; CHECK-LABEL: test_f16v2class:
; CHECK:       f16v2class $a0, $a0
; CHECK-NEXT:  mov     $m0, $a0
; CHECK-NEXT:  shuf8x8lo $m0, $m0, $m15
; CHECK-NEXT:  br $m10
define <2 x i16> @test_f16v2class(<2 x half> %x) {
  %res = call <2 x i16> @llvm.colossus.f16v2class(<2 x half> %x)
  ret <2 x i16> %res
}

; CHECK-LABEL: test_f16v4class:
; CHECK:       f16v4class $a0, $a0
; CHECK-NEXT:  mov     $m1, $a0
; CHECK-NEXT:  shuf8x8lo $m0, $m1, $m15
; CHECK-NEXT:  shuf8x8hi $m1, $m1, $m15
; CHECK-NEXT:  br $m10
define <4 x i16> @test_f16v4class(<4 x half> %x) {
  %res = call <4 x i16> @llvm.colossus.f16v4class(<4 x half> %x)
  ret <4 x i16> %res
}

; CHECK-LABEL: test_f32v2class:
; CHECK:       f32v2class $a0, $a0:1
; CHECK-NEXT:  mov     $m0, $a0
; CHECK-NEXT:  shuf8x8lo $m0, $m0, $m15
; CHECK-NEXT:  br $m10
define <2 x i16> @test_f32v2class(<2 x float> %x) {
  %res = call <2 x i16> @llvm.colossus.f32v2class(<2 x float> %x)
  ret <2 x i16> %res
}

; CHECK-LABEL: test_f32class:
; CHECK:       f32class $a0, $a0
; CHECK-NEXT:  mov     $m0, $a0
; CHECK-NEXT:  br $m10
define i32 @test_f32class(float %x) {
  %1 = call i32 @llvm.colossus.f32class(float %x)
  ret i32 %1
}

; CHECK-LABEL: test_get:
; CHECK:       get $m0, 123
define i32 @test_get() {
  %res = call i32 @llvm.colossus.get(i32 123)
  ret i32 %res
}

; CHECK-LABEL: test_uget:
; CHECK:       get     $a0, 124
; CHECK-NEXT:  mov     $m0, $a0
; CHECK-NEXT:  br $m10
define i32 @test_uget() {
  %res = call i32 @llvm.colossus.uget(i32 124)
  ret i32 %res
}

; CHECK-LABEL: test_ugetf:
; CHECK:       {
; CHECK-NEXT:          br $m10
; CHECK-NEXT:          get     $a0, 124
; CHECK-NEXT:  }
define float @test_ugetf() {
  %res = call float @llvm.colossus.ugetf(i32 124)
  ret float %res
}

; CHECK-LABEL: test_put:
; CHECK:       put 125, $m0
define void @test_put(i32 %x) {
  call void @llvm.colossus.put(i32 %x, i32 125)
  ret void
}

; CHECK-LABEL: test_uput:
; CHECK:       add $m11, $m11, -8
; CHECK-NEXT:  .cfi_def_cfa_offset 8
; CHECK-NEXT:  st32 $m0, $m11, $m15, 1
; CHECK-NEXT:  ld32 $a0, $m11, $m15, 1
; CHECK-NEXT:  {
; CHECK-NEXT:          add $m11, $m11, 8
; CHECK-NEXT:          put     126, $a0
; CHECK-NEXT:  }
; CHECK-NEXT:  .cfi_def_cfa_offset 0
; CHECK-NEXT:  br $m10
define void @test_uput(i32 %x) {
  call void @llvm.colossus.uput(i32 %x, i32 126)
  ret void
}

; CHECK-LABEL: test_uputf:
; CHECK:       {
; CHECK-NEXT:          br $m10
; CHECK-NEXT:          put     127, $a0
; CHECK-NEXT:  }
define void @test_uputf(float %x) {
  call void @llvm.colossus.uputf(float %x, i32 127)
  ret void
}

; CHECK-LABEL: is_worker_mode:
; CHECK:       cmpne $m0, $m12, $m15
define i1 @is_worker_mode() {
  %res = call i1 @llvm.colossus.is.worker.mode()
  ret i1 %res
}

; CHECK-LABEL: test_or_i32:
; CHECK:       or $m0, $m0, $m1
define i32 @test_or_i32(i32 %x, i32 %y) {
  %res = call i32 @llvm.colossus.or.i32(i32 %x, i32 %y)
  ret i32 %res
}

; CHECK-LABEL: test_or_i32_imm:
; CHECK:       or $m0, $m0, 1000
define i32 @test_or_i32_imm(i32 %x) {
  %res = call i32 @llvm.colossus.or.i32(i32 %x, i32 1000)
  ret i32 %res
}

; CHECK-LABEL: test_or_f32:
; CHECK:       or $a0, $a0, $a1
define float @test_or_f32(float %x, float %y) {
  %res = call float @llvm.colossus.or.f32(float %x, float %y)
  ret float %res
}

; CHECK-LABEL: test_or_v2f32:
; CHECK:       or64 $a0:1, $a0:1, $a2:3
define <2 x float> @test_or_v2f32(<2 x float> %x, <2 x float> %y) {
  %res = call <2 x float> @llvm.colossus.or.v2f32(<2 x float> %x, <2 x float> %y)
  ret <2 x float> %res
}

; CHECK-LABEL: test_not_f32:
; CHECK:       not $a0, $a0
define float @test_not_f32(float %x) {
  %res = call float @llvm.colossus.not.f32(float %x)
  ret float %res
}

; CHECK-LABEL: test_not_v2f32:
; CHECK:       not64 $a0:1, $a0:1
define <2 x float> @test_not_v2f32(<2 x float> %x) {
  %res = call <2 x float> @llvm.colossus.not.v2f32(<2 x float> %x)
  ret <2 x float> %res
}

; CHECK-LABEL: test_bitrev8:
; CHECK:       bitrev8 $m0, $m0
define i32 @test_bitrev8(i32 %x) {
  %res = call i32 @llvm.colossus.bitrev8(i32 %x)
  ret i32 %res
}

; CHECK-LABEL: test_and_i32:
; CHECK:       and $m0, $m0, $m1
define i32 @test_and_i32(i32 %x, i32 %y) {
  %res = call i32 @llvm.colossus.and.i32(i32 %x, i32 %y)
  ret i32 %res
}

; CHECK-LABEL: test_and_i32_zimm:
; CHECK:       and $m0, $m0, 1000
define i32 @test_and_i32_zimm(i32 %x) {
  %res = call i32 @llvm.colossus.and.i32(i32 %x, i32 1000)
  ret i32 %res
}

; CHECK-LABEL:       test_and_i32_immz:

; CHECK-IPU1_2:      or $m1, $m15, 1048576
; CHECK-IPU1_2-NEXT: and $m0, $m0, $m1
define i32 @test_and_i32_immz(i32 %x) {
  %res = call i32 @llvm.colossus.and.i32(i32 %x, i32 1048576)
  ret i32 %res
}

; CHECK-LABEL: test_and_f32:
; CHECK:       and $a0, $a0, $a1
define float @test_and_f32(float %x, float %y) {
  %res = call float @llvm.colossus.and.f32(float %x, float %y)
  ret float %res
}

; CHECK-LABEL: test_and_v2f32:
; CHECK:       and64 $a0:1, $a0:1, $a2:3
define <2 x float> @test_and_v2f32(<2 x float> %x, <2 x float> %y) {
  %res = call <2 x float> @llvm.colossus.and.v2f32(<2 x float> %x, <2 x float> %y)
  ret <2 x float> %res
}

; CHECK-LABEL: test_andc_i32:
; CHECK:       andc $m0, $m0, $m1
define i32 @test_andc_i32(i32 %x, i32 %y) {
  %res = call i32 @llvm.colossus.andc.i32(i32 %x, i32 %y)
  ret i32 %res
}

; CHECK-LABEL: test_andc_i32_zimm:
; CHECK:       andc $m0, $m0, 1000
define i32 @test_andc_i32_zimm(i32 %x) {
  %res = call i32 @llvm.colossus.andc.i32(i32 %x, i32 1000)
  ret i32 %res
}

; CHECK-LABEL:       test_andc_i32_immz:

; CHECK-IPU1_2:      or $m1, $m15, 1048576
; CHECK-IPU1_2-NEXT: andc $m0, $m0, $m1
define i32 @test_andc_i32_immz(i32 %x) {
  %res = call i32 @llvm.colossus.andc.i32(i32 %x, i32 1048576)
  ret i32 %res
}

; CHECK-LABEL: test_andc_f32:
; CHECK:       andc $a0, $a0, $a1
define float @test_andc_f32(float %x, float %y) {
  %res = call float @llvm.colossus.andc.f32(float %x, float %y)
  ret float %res
}

; CHECK-LABEL: test_andc_v2f32:
; CHECK:       andc64 $a0:1, $a0:1, $a2:3
define <2 x float> @test_andc_v2f32(<2 x float> %x, <2 x float> %y) {
  %res = call <2 x float> @llvm.colossus.andc.v2f32(<2 x float> %x, <2 x float> %y)
  ret <2 x float> %res
}

; CHECK-LABEL: test_roll8l:
; CHECK:       roll8l $m0, $m0, $m1
define i32 @test_roll8l(i32 %x, i32 %y) {
  %res = call i32 @llvm.colossus.roll8l(i32 %x, i32 %y)
  ret i32 %res
}

; CHECK-LABEL: test_roll8r:
; CHECK:       roll8r $m0, $m0, $m1
define i32 @test_roll8r(i32 %x, i32 %y) {
  %res = call i32 @llvm.colossus.roll8r(i32 %x, i32 %y)
  ret i32 %res
}

; CHECK-LABEL: test_roll32:
; CHECK:       roll32 $a0:1, $a0:1, $a2:3
define <2 x float> @test_roll32(<2 x float> %x, <2 x float> %y) {
  %res = call <2 x float> @llvm.colossus.roll32(<2 x float> %x, <2 x float> %y)
  ret <2 x float> %res
}

; CHECK-LABEL: test_shuf8x8hi:
; CHECK:       shuf8x8hi $m0, $m0, $m1
define i32 @test_shuf8x8hi(i32 %x, i32 %y) {
  %res = call i32 @llvm.colossus.shuf8x8hi(i32 %x, i32 %y)
  ret i32 %res
}

; CHECK-LABEL: test_shuf8x8lo:
; CHECK:       shuf8x8lo $m0, $m0, $m1
define i32 @test_shuf8x8lo(i32 %x, i32 %y) {
  %res = call i32 @llvm.colossus.shuf8x8lo(i32 %x, i32 %y)
  ret i32 %res
}

; CHECK-LABEL: test_sort4x32hi:
; CHECK:       sort4x32hi $a0:1, $a0:1, $a2:3
define <2 x float> @test_sort4x32hi(<2 x float> %x, <2 x float> %y) {
  %res = call <2 x float> @llvm.colossus.sort4x32hi(<2 x float> %x, <2 x float> %y)
  ret <2 x float> %res
}

; CHECK-LABEL: test_sort4x32lo:
; CHECK:       sort4x32lo $a0:1, $a0:1, $a2:3
define <2 x float> @test_sort4x32lo(<2 x float> %x, <2 x float> %y) {
  %res = call <2 x float> @llvm.colossus.sort4x32lo(<2 x float> %x, <2 x float> %y)
  ret <2 x float> %res
}

; CHECK-LABEL: test_sort8x8hi:
; CHECK:       sort8x8hi $m0, $m0, $m1
define i32 @test_sort8x8hi(i32 %x, i32 %y) {
  %res = call i32 @llvm.colossus.sort8x8hi(i32 %x, i32 %y)
  ret i32 %res
}

; CHECK-LABEL: test_sort8x8lo:
; CHECK:       sort8x8lo $m0, $m0, $m1
define i32 @test_sort8x8lo(i32 %x, i32 %y) {
  %res = call i32 @llvm.colossus.sort8x8lo(i32 %x, i32 %y)
  ret i32 %res
}

; CHECK-LABEL: test_sort8:
; CHECK:       sort8 $m0, $m0
define i32 @test_sort8(i32 %x) {
  %res = call i32 @llvm.colossus.sort8(i32 %x)
  ret i32 %res
}

; CHECK-LABEL: test_swap8:
; CHECK:       swap8 $m0, $m0
define i32 @test_swap8(i32 %x) {
  %res = call i32 @llvm.colossus.swap8(i32 %x)
  ret i32 %res
}

; CHECK-LABEL: test_cms:
; CHECK:       cms $m0, $m0
define i32 @test_cms(i32 %x) {
  %res = call i32 @llvm.colossus.cms(i32 %x)
  ret i32 %res
}

; CHECK-LABEL: test_f16v2absadd:
; CHECK:       f16v2absadd $a0, $a0, $a1
define <2 x half> @test_f16v2absadd(<2 x half> %x, <2 x half> %y) {
    %res = call <2 x half> @llvm.colossus.f16v2absadd(<2 x half> %x, <2 x half> %y)
    ret <2 x half> %res
}

; CHECK-LABEL: test_f16v4absadd:
; CHECK:       f16v4absadd $a0:1, $a0:1, $a2:3
define <4 x half> @test_f16v4absadd(<4 x half> %x, <4 x half> %y) {
    %res = call <4 x half> @llvm.colossus.f16v4absadd(<4 x half> %x, <4 x half> %y)
    ret <4 x half> %res
}

; CHECK-LABEL: test_f32v2absadd:
; CHECK:       f32v2absadd $a0:1, $a0:1, $a2:3
define <2 x float> @test_f32v2absadd(<2 x float> %x, <2 x float> %y) {
    %res = call <2 x float> @llvm.colossus.f32v2absadd(<2 x float> %x, <2 x float> %y)
    ret <2 x float> %res
}

; CHECK-LABEL: test_f32absadd:
; CHECK:       f32absadd $a0, $a0, $a1
define float @test_f32absadd(float %x, float %y) {
    %res = call float @llvm.colossus.f32absadd(float %x, float %y)
    ret float %res
}

; CHECK-LABEL: test_f16v2absmax:
; CHECK:       f16v2absmax $a0, $a1, $a0
define <2 x half> @test_f16v2absmax(<2 x half> %x, <2 x half> %y) {
    %res = call <2 x half> @llvm.colossus.f16v2absmax(<2 x half> %x, <2 x half> %y)
    ret <2 x half> %res
}

; CHECK-LABEL: test_f16v4absmax:
; CHECK:       f16v4absmax $a0:1, $a2:3, $a0:1
define <4 x half> @test_f16v4absmax(<4 x half> %x, <4 x half> %y) {
    %res = call <4 x half> @llvm.colossus.f16v4absmax(<4 x half> %x, <4 x half> %y)
    ret <4 x half> %res
}

; CHECK-LABEL: test_f32v2absmax:
; CHECK:       f32v2absmax $a0:1, $a2:3, $a0:1
define <2 x float> @test_f32v2absmax(<2 x float> %x, <2 x float> %y) {
    %res = call <2 x float> @llvm.colossus.f32v2absmax(<2 x float> %x, <2 x float> %y)
    ret <2 x float> %res
}

; CHECK-LABEL: test_f32absmax:
; CHECK:       f32absmax $a0, $a0, $a1
define float @test_f32absmax(float %x, float %y) {
    %res = call float @llvm.colossus.f32absmax(float %x, float %y)
    ret float %res
}

; CHECK-LABEL: test_f16v2max:
; CHECK:       f16v2max $a0, $a0, $a1
define <2 x half> @test_f16v2max(<2 x half> %x, <2 x half> %y) {
    %res = call <2 x half> @llvm.colossus.f16v2max(<2 x half> %x, <2 x half> %y)
    ret <2 x half> %res
}

; CHECK-LABEL: test_f16v4max:
; CHECK:       f16v4max $a0:1, $a0:1, $a2:3
define <4 x half> @test_f16v4max(<4 x half> %x, <4 x half> %y) {
    %res = call <4 x half> @llvm.colossus.f16v4max(<4 x half> %x, <4 x half> %y)
    ret <4 x half> %res
}

; CHECK-LABEL: test_f32v2max:
; CHECK:       f32v2max $a0:1, $a0:1, $a2:3
define <2 x float> @test_f32v2max(<2 x float> %x, <2 x float> %y) {
    %res = call <2 x float> @llvm.colossus.f32v2max(<2 x float> %x, <2 x float> %y)
    ret <2 x float> %res
}

; CHECK-LABEL: test_f32max:
; CHECK:       f32max $a0, $a0, $a1
define float @test_f32max(float %x, float %y) {
    %res = call float @llvm.colossus.f32max(float %x, float %y)
    ret float %res
}

; CHECK-LABEL: test_f16v2maxc:
; CHECK:       f16v2maxc $a0, $a0
define half @test_f16v2maxc(<2 x half> %x) {
    %res = call half @llvm.colossus.f16v2maxc(<2 x half> %x)
    ret half %res
}

; CHECK-LABEL: test_f16v4maxc:
; CHECK:       f16v4maxc $a0, $a0:1
define <2 x half> @test_f16v4maxc(<4 x half> %x) {
    %res = call <2 x half> @llvm.colossus.f16v4maxc(<4 x half> %x)
    ret <2 x half> %res
}

; CHECK-LABEL: test_f16v2min:
; CHECK:       f16v2min $a0, $a0, $a1
define <2 x half> @test_f16v2min(<2 x half> %x, <2 x half> %y) {
    %res = call <2 x half> @llvm.colossus.f16v2min(<2 x half> %x, <2 x half> %y)
    ret <2 x half> %res
}

; CHECK-LABEL: test_f16v4min:
; CHECK:       f16v4min $a0:1, $a0:1, $a2:3
define <4 x half> @test_f16v4min(<4 x half> %x, <4 x half> %y) {
    %res = call <4 x half> @llvm.colossus.f16v4min(<4 x half> %x, <4 x half> %y)
    ret <4 x half> %res
}

; CHECK-LABEL: test_f32v2min:
; CHECK:       f32v2min $a0:1, $a0:1, $a2:3
define <2 x float> @test_f32v2min(<2 x float> %x, <2 x float> %y) {
    %res = call <2 x float> @llvm.colossus.f32v2min(<2 x float> %x, <2 x float> %y)
    ret <2 x float> %res
}

; CHECK-LABEL: test_f32min:
; CHECK:       f32min $a0, $a0, $a1
define float @test_f32min(float %x, float %y) {
    %res = call float @llvm.colossus.f32min(float %x, float %y)
    ret float %res
}

; CHECK-LABEL: test_f16v2clamp:
; CHECK:       f16v2clamp $a0, $a0, $a1
define <2 x half> @test_f16v2clamp(<2 x half> %x, <2 x half> %y) {
    %res = call <2 x half> @llvm.colossus.f16v2clamp(<2 x half> %x, <2 x half> %y)
    ret <2 x half> %res
}

; CHECK-LABEL: test_f16v4clamp:
; CHECK:       f16v4clamp $a0:1, $a0:1, $a2
define <4 x half> @test_f16v4clamp(<4 x half> %x, <2 x half> %y) {
    %res = call <4 x half> @llvm.colossus.f16v4clamp(<4 x half> %x, <2 x half> %y)
    ret <4 x half> %res
}

; CHECK-LABEL: test_f32v2clamp:
; CHECK:       f32v2clamp $a0:1, $a0:1, $a2:3
define <2 x float> @test_f32v2clamp(<2 x float> %x, <2 x float> %y) {
    %res = call <2 x float> @llvm.colossus.f32v2clamp(<2 x float> %x, <2 x float> %y)
    ret <2 x float> %res
}

; CHECK-LABEL: test_f32clamp:
; CHECK:       f32clamp $a0, $a0, $a2:3
define float @test_f32clamp(float %x, <2 x float> %y) {
    %res = call float @llvm.colossus.f32clamp(float %x, <2 x float> %y)
    ret float %res
}

; CHECK-LABEL: test_f16v2cmac:
; CHECK:       f16v2cmac $a0, $a1
define void @test_f16v2cmac(<2 x half> %x, <2 x half> %y) {
    call void @llvm.colossus.f16v2cmac(<2 x half> %x, <2 x half> %y)
    ret void
}

; CHECK-LABEL: test_f16v4cmac:
; CHECK:       f16v4cmac $a0:1, $a2:3
define void @test_f16v4cmac(<4 x half> %x, <4 x half> %y) {
    call void @llvm.colossus.f16v4cmac(<4 x half> %x, <4 x half> %y)
    ret void
}

; CHECK-LABEL: test_f16v2cmpeq:
; CHECK:       f16v2cmpeq $a0, $a0, $a1
define <2 x half> @test_f16v2cmpeq(<2 x half> %x, <2 x half> %y) {
    %res = call <2 x half> @llvm.colossus.f16v2cmpeq(<2 x half> %x, <2 x half> %y)
    ret <2 x half> %res
}

; CHECK-LABEL: test_f16v4cmpeq:
; CHECK:       f16v4cmpeq $a0:1, $a0:1, $a2:3
define <4 x half> @test_f16v4cmpeq(<4 x half> %x, <4 x half> %y) {
    %res = call <4 x half> @llvm.colossus.f16v4cmpeq(<4 x half> %x, <4 x half> %y)
    ret <4 x half> %res
}

; CHECK-LABEL: test_f32v2cmpeq:
; CHECK:       f32v2cmpeq $a0:1, $a0:1, $a2:3
define <2 x float> @test_f32v2cmpeq(<2 x float> %x, <2 x float> %y) {
    %res = call <2 x float> @llvm.colossus.f32v2cmpeq(<2 x float> %x, <2 x float> %y)
    ret <2 x float> %res
}

; CHECK-LABEL: test_f32cmpeq:
; CHECK:       f32cmpeq $a0, $a0, $a1
define float @test_f32cmpeq(float %x, float %y) {
    %res = call float @llvm.colossus.f32cmpeq(float %x, float %y)
    ret float %res
}

; CHECK-LABEL: test_f16v2cmpge:
; CHECK:       f16v2cmpge $a0, $a0, $a1
define <2 x half> @test_f16v2cmpge(<2 x half> %x, <2 x half> %y) {
    %res = call <2 x half> @llvm.colossus.f16v2cmpge(<2 x half> %x, <2 x half> %y)
    ret <2 x half> %res
}

; CHECK-LABEL: test_f16v4cmpge:
; CHECK:       f16v4cmpge $a0:1, $a0:1, $a2:3
define <4 x half> @test_f16v4cmpge(<4 x half> %x, <4 x half> %y) {
    %res = call <4 x half> @llvm.colossus.f16v4cmpge(<4 x half> %x, <4 x half> %y)
    ret <4 x half> %res
}

; CHECK-LABEL: test_f32v2cmpge:
; CHECK:       f32v2cmpge $a0:1, $a0:1, $a2:3
define <2 x float> @test_f32v2cmpge(<2 x float> %x, <2 x float> %y) {
    %res = call <2 x float> @llvm.colossus.f32v2cmpge(<2 x float> %x, <2 x float> %y)
    ret <2 x float> %res
}

; CHECK-LABEL: test_f32cmpge:
; CHECK:       f32cmpge $a0, $a0, $a1
define float @test_f32cmpge(float %x, float %y) {
    %res = call float @llvm.colossus.f32cmpge(float %x, float %y)
    ret float %res
}

; CHECK-LABEL: test_f16v2cmpgt:
; CHECK:       f16v2cmpgt $a0, $a0, $a1
define <2 x half> @test_f16v2cmpgt(<2 x half> %x, <2 x half> %y) {
    %res = call <2 x half> @llvm.colossus.f16v2cmpgt(<2 x half> %x, <2 x half> %y)
    ret <2 x half> %res
}

; CHECK-LABEL: test_f16v4cmpgt:
; CHECK:       f16v4cmpgt $a0:1, $a0:1, $a2:3
define <4 x half> @test_f16v4cmpgt(<4 x half> %x, <4 x half> %y) {
    %res = call <4 x half> @llvm.colossus.f16v4cmpgt(<4 x half> %x, <4 x half> %y)
    ret <4 x half> %res
}

; CHECK-LABEL: test_f32v2cmpgt:
; CHECK:       f32v2cmpgt $a0:1, $a0:1, $a2:3
define <2 x float> @test_f32v2cmpgt(<2 x float> %x, <2 x float> %y) {
    %res = call <2 x float> @llvm.colossus.f32v2cmpgt(<2 x float> %x, <2 x float> %y)
    ret <2 x float> %res
}

; CHECK-LABEL: test_f32cmpgt:
; CHECK:       f32cmpgt $a0, $a0, $a1
define float @test_f32cmpgt(float %x, float %y) {
    %res = call float @llvm.colossus.f32cmpgt(float %x, float %y)
    ret float %res
}

; CHECK-LABEL: test_f16v2cmple:
; CHECK:       f16v2cmple $a0, $a0, $a1
define <2 x half> @test_f16v2cmple(<2 x half> %x, <2 x half> %y) {
    %res = call <2 x half> @llvm.colossus.f16v2cmple(<2 x half> %x, <2 x half> %y)
    ret <2 x half> %res
}

; CHECK-LABEL: test_f16v4cmple:
; CHECK:       f16v4cmple $a0:1, $a0:1, $a2:3
define <4 x half> @test_f16v4cmple(<4 x half> %x, <4 x half> %y) {
    %res = call <4 x half> @llvm.colossus.f16v4cmple(<4 x half> %x, <4 x half> %y)
    ret <4 x half> %res
}

; CHECK-LABEL: test_f32v2cmple:
; CHECK:       f32v2cmple $a0:1, $a0:1, $a2:3
define <2 x float> @test_f32v2cmple(<2 x float> %x, <2 x float> %y) {
    %res = call <2 x float> @llvm.colossus.f32v2cmple(<2 x float> %x, <2 x float> %y)
    ret <2 x float> %res
}

; CHECK-LABEL: test_f32cmple:
; CHECK:       f32cmple $a0, $a0, $a1
define float @test_f32cmple(float %x, float %y) {
    %res = call float @llvm.colossus.f32cmple(float %x, float %y)
    ret float %res
}

; CHECK-LABEL: test_f16v2cmplt:
; CHECK:       f16v2cmplt $a0, $a0, $a1
define <2 x half> @test_f16v2cmplt(<2 x half> %x, <2 x half> %y) {
    %res = call <2 x half> @llvm.colossus.f16v2cmplt(<2 x half> %x, <2 x half> %y)
    ret <2 x half> %res
}

; CHECK-LABEL: test_f16v4cmplt:
; CHECK:       f16v4cmplt $a0:1, $a0:1, $a2:3
define <4 x half> @test_f16v4cmplt(<4 x half> %x, <4 x half> %y) {
    %res = call <4 x half> @llvm.colossus.f16v4cmplt(<4 x half> %x, <4 x half> %y)
    ret <4 x half> %res
}

; CHECK-LABEL: test_f32v2cmplt:
; CHECK:       f32v2cmplt $a0:1, $a0:1, $a2:3
define <2 x float> @test_f32v2cmplt(<2 x float> %x, <2 x float> %y) {
    %res = call <2 x float> @llvm.colossus.f32v2cmplt(<2 x float> %x, <2 x float> %y)
    ret <2 x float> %res
}

; CHECK-LABEL: test_f32cmplt:
; CHECK:       f32cmplt $a0, $a0, $a1
define float @test_f32cmplt(float %x, float %y) {
    %res = call float @llvm.colossus.f32cmplt(float %x, float %y)
    ret float %res
}

; CHECK-LABEL: test_f16v2cmpne:
; CHECK:       f16v2cmpne $a0, $a0, $a1
define <2 x half> @test_f16v2cmpne(<2 x half> %x, <2 x half> %y) {
    %res = call <2 x half> @llvm.colossus.f16v2cmpne(<2 x half> %x, <2 x half> %y)
    ret <2 x half> %res
}

; CHECK-LABEL: test_f16v4cmpne:
; CHECK:       f16v4cmpne $a0:1, $a0:1, $a2:3
define <4 x half> @test_f16v4cmpne(<4 x half> %x, <4 x half> %y) {
    %res = call <4 x half> @llvm.colossus.f16v4cmpne(<4 x half> %x, <4 x half> %y)
    ret <4 x half> %res
}

; CHECK-LABEL: test_f32v2cmpne:
; CHECK:       f32v2cmpne $a0:1, $a0:1, $a2:3
define <2 x float> @test_f32v2cmpne(<2 x float> %x, <2 x float> %y) {
    %res = call <2 x float> @llvm.colossus.f32v2cmpne(<2 x float> %x, <2 x float> %y)
    ret <2 x float> %res
}

; CHECK-LABEL: test_f32cmpne:
; CHECK:       f32cmpne $a0, $a0, $a1
define float @test_f32cmpne(float %x, float %y) {
    %res = call float @llvm.colossus.f32cmpne(float %x, float %y)
    ret float %res
}

; CHECK-LABEL: test_f16v2exp:
; CHECK:       f16v2exp $a0, $a0
define <2 x half> @test_f16v2exp(<2 x half> %x) {
    %res = call <2 x half> @llvm.colossus.f16v2exp(<2 x half> %x)
    ret <2 x half> %res
}

; CHECK-LABEL: test_f16v2exp2:
; CHECK:       f16v2exp2 $a0, $a0
define <2 x half> @test_f16v2exp2(<2 x half> %x) {
    %res = call <2 x half> @llvm.colossus.f16v2exp2(<2 x half> %x)
    ret <2 x half> %res
}

; CHECK-LABEL: test_f16v2ln:
; CHECK:       f16v2ln $a0, $a0
define <2 x half> @test_f16v2ln(<2 x half> %x) {
    %res = call <2 x half> @llvm.colossus.f16v2ln(<2 x half> %x)
    ret <2 x half> %res
}

; CHECK-LABEL: test_f16v2log2:
; CHECK:       f16v2log2 $a0, $a0
define <2 x half> @test_f16v2log2(<2 x half> %x) {
    %res = call <2 x half> @llvm.colossus.f16v2log2(<2 x half> %x)
    ret <2 x half> %res
}

; CHECK-LABEL: test_f32v2aop:
; CHECK:       f32v2aop $a0:1, $a2:3, 0
define void @test_f32v2aop(<2 x float> %x, <2 x float> %y) {
    call void @llvm.colossus.f32v2aop(<2 x float> %x, <2 x float> %y, i32 0)
    ret void
}

; CHECK-LABEL: test_f32v2axpy:
; CHECK:       f32v2axpy $a0:1, $a2:3, $a0:1
define <2 x float> @test_f32v2axpy(<2 x float> %x, <2 x float> %y) {
    %res = call <2 x float> @llvm.colossus.f32v2axpy(<2 x float> %x, <2 x float> %y)
    ret <2 x float> %res
}

; CHECK-LABEL: test_f16v2gina:
; CHECK:       f16v2gina $a0, $a0, 1000
define <2 x half> @test_f16v2gina(<2 x half> %x) {
    %res = call <2 x half> @llvm.colossus.f16v2gina(<2 x half> %x, i32 1000)
    ret <2 x half> %res
}

; CHECK-LABEL: test_f32v2gina:
; CHECK:       f32v2gina $a0:1, $a0:1, 1000
define <2 x float> @test_f32v2gina(<2 x float> %x) {
    %res = call <2 x float> @llvm.colossus.f32v2gina(<2 x float> %x, i32 1000)
    ret <2 x float> %res
}

; CHECK-LABEL: test_f16v2grand:
; CHECK:       f16v2grand $a0
define <2 x half> @test_f16v2grand(<2 x half> %x) {
    %res = call <2 x half> @llvm.colossus.f16v2grand()
    ret <2 x half> %res
}

; CHECK-LABEL: test_f32v2grand:
; CHECK:       f32v2grand $a0:1
define <2 x float> @test_f32v2grand(<2 x float> %x) {
    %res = call <2 x float> @llvm.colossus.f32v2grand()
    ret <2 x float> %res
}

; CHECK-LABEL: test_f16v4rmask
; CHECK:       f16v4rmask $a0:1, $a0:1, $a2
define <4 x half> @test_f16v4rmask(<4 x half> %x, float %y) {
    %res = call <4 x half> @llvm.colossus.f16v4rmask(<4 x half> %x, float %y)
    ret <4 x half> %res
}

; CHECK-LABEL: test_f32v2rmask
; CHECK:       f32v2rmask $a0:1, $a0:1, $a2
define <2 x float> @test_f32v2rmask(<2 x float> %x, float %y) {
    %res = call <2 x float> @llvm.colossus.f32v2rmask(<2 x float> %x, float %y)
    ret <2 x float> %res
}

; CHECK-LABEL: test_f16v2sigm
; CHECK:       f16v2sigm $a0, $a0
define <2 x half> @test_f16v2sigm(<2 x half> %x) {
    %res = call <2 x half> @llvm.colossus.f16v2sigm(<2 x half> %x)
    ret <2 x half> %res
}

; CHECK-LABEL: test_f32sigm
; CHECK:       f32sigm $a0, $a0
define float @test_f32sigm(float %x) {
    %res = call float @llvm.colossus.f32sigm(float %x)
    ret float %res
}

; CHECK-LABEL: test_f16v2sum
; CHECK:       f16v2sum $a0, $a0
define float @test_f16v2sum(<2 x half> %x) {
    %res = call float @llvm.colossus.f16v2sum(<2 x half> %x)
    ret float %res
}

; CHECK-LABEL: test_f16v4sum
; CHECK:       f16v4sum $a0:1, $a0:1
define <2 x float> @test_f16v4sum(<4 x half> %x) {
    %res = call <2 x float> @llvm.colossus.f16v4sum(<4 x half> %x)
    ret <2 x float> %res
}

; CHECK-LABEL: test_f16v2tanh
; CHECK:       f16v2tanh $a0, $a0
define <2 x half> @test_f16v2tanh(<2 x half> %x) {
    %res = call <2 x half> @llvm.colossus.f16v2tanh(<2 x half> %x)
    ret <2 x half> %res
}
