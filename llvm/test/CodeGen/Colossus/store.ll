; RUN: llvm-link %isdopc %s | opt -instcombine -always-inline -mattr=+ipu1 | llc -march=colossus -colossus-coissue=false -mattr=+ipu1 | FileCheck %s
; RUN: llvm-link %isdopc %s | opt -instcombine -always-inline -mattr=+ipu2 | llc -march=colossus -colossus-coissue=false -mattr=+ipu2 | FileCheck %s
; RUN: llvm-link %isdopc %s | opt -instcombine -always-inline | llc -march=colossus -colossus-coissue=false -mattr=+supervisor | FileCheck %s --check-prefixes=CHECK,SUPERVISOR,NOT-WORKER
; RUN: llvm-link %isdopc %s | opt -instcombine -always-inline | llc -march=colossus -colossus-coissue=false -mattr=+both | FileCheck %s --check-prefixes=CHECK,NOT-WORKER

; Test the various store addressing modes.

;===-----------------------------------------------------------------------===;
; External Definitions
;===-----------------------------------------------------------------------===;

declare i32 @llvm.colossus.SDAG.binary.i32(i32, i32, i32)

@ColossusISD_SORT8X8LO = external constant i32
@ColossusISD_SHUF8X8LO = external constant i32
@ColossusISD_SHUF8X8HI = external constant i32

;===-----------------------------------------------------------------------===;
; ST32
;===-----------------------------------------------------------------------===;

; Immediate non-scaled.
define void @store32_imm_nonscaled(i32 %p, i32 %val) {
; CHECK-LABEL: store32_imm_nonscaled:
; CHECK:       st32 $m1, $m0, $m15, 1
	%1 = add i32 %p, 4
  %2 = inttoptr i32 %1 to i32*
  store i32 %val, i32* %2, align 4
	ret void
}

; Arbitrary pointer.
define void @store32_ptr(i32* %p, i32 %val) {
; CHECK-LABEL: store32_ptr:
; CHECK:       st32 $m1, $m0, $m15, 0
	store i32 %val, i32* %p, align 4
	ret void
}

; Global symbol plus offset.
@g1 = dso_local global i32 0
define void @store32_global(i32 %val) {
; CHECK-LABEL: store32_global:
; CHECK:       setzi $m[[addr:[0-9]+]], g1+16
; CHECK-NEXT:  st32 $m0, $m[[addr]], $m15, 0
	%1 = getelementptr i32, i32* @g1, i32 4
  store i32 %val, i32* %1, align 4
  ret void
}

;===-----------------------------------------------------------------------===;
; Stores of i8, i16 with ld32 and st32.
;===-----------------------------------------------------------------------===;

define void @store_i16_misaligned(i16* %q) {
; CHECK-LABEL: store_i16_misaligned
; WORKER:      call $m10, __st16_misaligned
; SUPERVISOR:  call $m10, __supervisor_st16_misaligned
  store i16 4660, i16* %q, align 1
  ret void
}

define void @store_i8(i8* %q) {
; CHECK-LABEL: store_i8
; WORKER:      call $m10, __st8
; SUPERVISOR:  call $m10, __st8
  store i8 171, i8* %q, align 1
  ret void
}

;===-----------------------------------------------------------------------===;
; Store constants using the ARF if in worker mode
;===-----------------------------------------------------------------------===;

; CHECK-LABEL: store_zero_f32:
; WORKER:      st32 $a15, $m0, $m15, 0
; NOT-WORKER:  st32 $m15, $m0, $m15, 0
define void @store_zero_f32(float * %p) {
  store float 0.0, float *%p
  ret void
}

; CHECK-LABEL: store_zero_i32:
; WORKER:      st32 $a15, $m0, $m15, 0
; NOT-WORKER:  st32 $m15, $m0, $m15, 0
define void @store_zero_i32(i32 * %p) {
  store i32 0, i32 *%p
  ret void
}

; CHECK-LABEL: store_zero_v2f32:
; WORKER:      st64 $a14:15, $m0, $m15, 0
; NOT-WORKER:  st32 $m15, $m0, $m15, 1
; NOT-WORKER:  st32 $m15, $m0, $m15, 0
define void @store_zero_v2f32(<2 x float> * %p) {
  store <2 x float> <float 0.0, float 0.0>, <2 x float> *%p
  ret void
}

; CHECK-LABEL: store_zero_v2i32:
; WORKER:      st64 $a14:15, $m0, $m15, 0
; NOT-WORKER:  st32 $m15, $m0, $m15, 1
; NOT-WORKER:  st32 $m15, $m0, $m15, 0
define void @store_zero_v2i32(<2 x i32> * %p) {
  store <2 x i32> <i32 0, i32 0>, <2 x i32> *%p
  ret void
}

; CHECK-LABEL: store_constant_f32:
; WORKER:      setzi $a0, 42
; WORKER:      st32 $a0, $m0, $m15, 0
; NOT-WORKER:  setzi $m1, 42
; NOT-WORKER:  st32 $m1, $m0, $m15, 0
define void @store_constant_f32(float * %p) {
  %bc = bitcast i32 42 to float
  store float %bc, float *%p
  ret void
}

; CHECK-LABEL: store_constant_i32:
; WORKER:      setzi $a0, 42
; WORKER:      st32 $a0, $m0, $m15, 0
; NOT-WORKER:  setzi $m1, 42
; NOT-WORKER:  st32 $m1, $m0, $m15, 0
define void @store_constant_i32(i32 * %p) {
  store i32 42, i32 *%p
  ret void
}

; CHECK-LABEL: store_constant_v2f32:
; WORKER:      setzi $a0, 42
; WORKER:      setzi $a1, 101
; WORKER:      st64 $a0:1, $m0, $m15, 0
; NOT-WORKER:  setzi $m1, 101
; NOT-WORKER:  st32 $m1, $m0, $m15, 1
; NOT-WORKER:  setzi $m1, 42
; NOT-WORKER:  st32 $m1, $m0, $m15, 0
define void @store_constant_v2f32(<2 x float> * %p) {
  %bc = bitcast <2 x i32> <i32 42, i32 101> to <2 x float>
  store <2 x float> %bc, <2 x float> *%p
  ret void
}

; CHECK-LABEL: store_constant_v2i32:
; WORKER:      setzi $a0, 42
; WORKER:      setzi $a1, 101
; WORKER:      st64 $a0:1, $m0, $m15, 0
; NOT-WORKER:  setzi $m1, 101
; NOT-WORKER:  st32 $m1, $m0, $m15, 1
; NOT-WORKER:  setzi $m1, 42
; NOT-WORKER:  st32 $m1, $m0, $m15, 0
define void @store_constant_v2i32(<2 x i32> * %p) {
  store <2 x i32> <i32 42, i32 101>, <2 x i32> *%p
  ret void
}

; CHECK-LABEL: store_constant_v2f16:
; WORKER:      setzi $a0, 196612
; WORKER:      st32 $a0, $m0, $m15, 0
; NOT-WORKER:  setzi $m1, 196612
; NOT-WORKER:  st32 $m1, $m0, $m15, 0
define void @store_constant_v2f16(<2 x half> * %p) {
  %bc = bitcast <2 x i16> <i16 4, i16 3> to <2 x half>
  store <2 x half> %bc, <2 x half> *%p
  ret void
}

; CHECK-LABEL: store_constant_v2i16:
; WORKER:      setzi $a0, 196612
; WORKER:      st32 $a0, $m0, $m15, 0
; NOT-WORKER:  setzi $m1, 196612
; NOT-WORKER:  st32 $m1, $m0, $m15, 0
define void @store_constant_v2i16(<2 x i16> * %p) {
  store <2 x i16> <i16 4, i16 3>, <2 x i16> *%p
  ret void
}

; CHECK-LABEL: store_constant_v4f16:
; WORKER:      setzi $a0, 196612
; WORKER:      setzi $a1, 65538
; WORKER:      st64 $a0:1, $m0, $m15, 0
; NOT-WORKER:  setzi $m1, 65538
; NOT-WORKER:  st32 $m1, $m0, $m15, 1
; NOT-WORKER:  setzi $m1, 196612
; NOT-WORKER:  st32 $m1, $m0, $m15, 0
; NOT-WORKER:  br $m10
define void @store_constant_v4f16(<4 x half> * %p) {
  %bc = bitcast <4 x i16> <i16 4, i16 3, i16 2, i16 1> to <4 x half>
  store <4 x half> %bc, <4 x half> *%p
  ret void
}

; CHECK-LABEL: store_constant_v4i16:
; WORKER:      setzi $a0, 196612
; WORKER:      setzi $a1, 65538
; WORKER:      st64 $a0:1, $m0, $m15, 0
; NOT-WORKER:  setzi $m2, 196612
; NOT-WORKER:  setzi $m1, 65538
; NOT-WORKER:  st32 $m1, $m0, $m15, 1
; NOT-WORKER:  st32 $m2, $m0, $m15, 0
define void @store_constant_v4i16(<4 x i16> * %p) {
  store <4 x i16> <i16 4, i16 3, i16 2, i16 1>, <4 x i16> *%p
  ret void
}

;===-----------------------------------------------------------------------===;
; Stores of v4i8.
;===-----------------------------------------------------------------------===;

; CHECK-LABEL: st_v4i8:
; CHECK:       # %bb
; CHECK-NEXT:  sort8x8lo $m[[SORT8:[0-9]+]], $m{{[0-9]+}}, $m{{[0-9]+}}
; CHECK-NEXT:  st32 $m[[SORT8]], $m{{[0-9]+}}, $m15, 0
; CHECK-NEXT:  br $m10
define void @st_v4i8(<4 x i8> %val, <4 x i8>* %dest) {
  store <4 x i8> %val, <4 x i8>* %dest
  ret void
}

; CHECK-LABEL: ld_v4i8_st_v4i8:
; CHECK:       # %bb
; CHECK-NEXT:  ld32 $m[[LOAD:[0-9]+]], $m{{[0-9]+}}, $m15, 0
; CHECK-NEXT:  st32 $m[[LOAD]], $m{{[0-9]+}}, $m15, 0
; CHECK-NEXT:  br $m10
define void @ld_v4i8_st_v4i8(<4 x i8>* %src, <4 x i8>* %dst) {
  %val = load <4 x i8>, <4 x i8>* %src
  store <4 x i8> %val, <4 x i8>* %dst
  ret void
}

; CHECK-LABEL: ld_v4i8_st_v4i8_asm:
; CHECK:       # %bb
; CHECK-NEXT:  ld32 $m[[LOAD:[0-9]+]], $m{{[0-9]+}}, $m15, 0
; CHECK-NEXT:  st32 $m[[LOAD]], $m{{[0-9]+}}, $m15, 0
; CHECK-NEXT:  br $m10
define void @ld_v4i8_st_v4i8_asm(<4 x i8>* %src, <4 x i8>* %dst) {

  %id_sort = load i32, i32* @ColossusISD_SORT8X8LO
  %id_shufhi = load i32, i32* @ColossusISD_SHUF8X8HI
  %id_shuflo = load i32, i32* @ColossusISD_SHUF8X8LO

  %1 = load <4 x i8>, <4 x i8>* %src
  %2 = bitcast <4 x i8> %1 to i32
  %3 = call i32 @llvm.colossus.SDAG.binary.i32(i32 %id_shufhi, i32 %2, i32 0)
  %4 = call i32 @llvm.colossus.SDAG.binary.i32(i32 %id_shuflo, i32 %2, i32 0)
  %5 = call i32 @llvm.colossus.SDAG.binary.i32(i32 %id_sort, i32 %4, i32 %3)
  %6 = bitcast i32 %5 to <4 x i8>
  store <4 x i8> %6, <4 x i8>* %dst
  ret void
}

; CHECK-LABEL: ld_v4i8_st_v4i8_align1:
; CHECK:            # %bb
; CHECK:            ld32 $m[[LOAD:[0-9]+]], $m{{[0-9]+}}, $m15, 0
; CHECK-NEXT:       mov $m0, $m2
; WORKER-NEXT:      call $m10, __st32_align1
; SUPERVISOR-NEXT:  call $m10, __supervisor_st32_align1
; CHECK:            br $m10
define void @ld_v4i8_st_v4i8_align1(<4 x i8>* %src, <4 x i8>* align 1 %dst) {
  %val = load <4 x i8>, <4 x i8>* %src
  store <4 x i8> %val, <4 x i8>* %dst, align 1
  ret void
}

; CHECK-LABEL: ld_v4i8_st_v4i8_align2:
; CHECK:            # %bb
; CHECK:            ld32 $m[[LOAD:[0-9]+]], $m{{[0-9]+}}, $m15, 0
; CHECK-NEXT:       mov $m0, $m2
; WORKER-NEXT:      call $m10, __st32_align2
; SUPERVISOR-NEXT:  call $m10, __supervisor_st32_align2
; CHECK:            br $m10
define void @ld_v4i8_st_v4i8_align2(<4 x i8>* %src, <4 x i8>* align 2 %dst) {
  %val = load <4 x i8>, <4 x i8>* %src
  store <4 x i8> %val, <4 x i8>* %dst, align 2
  ret void
}

; CHECK-LABEL: ld_v4i8_st_v4i8_align4:
; CHECK:       # %bb
; CHECK-NEXT:  ld32 $m[[LOAD:[0-9]+]], $m{{[0-9]+}}, $m15, 0
; CHECK-NEXT:  st32 $m[[LOAD]], $m{{[0-9]+}}, $m15, 0
; CHECK-NEXT:  br $m10
define void @ld_v4i8_st_v4i8_align4(<4 x i8>* %src, <4 x i8>* align 4 %dst) {
  %val = load <4 x i8>, <4 x i8>* %src
  store <4 x i8> %val, <4 x i8>* %dst, align 4
  ret void
}

;===-----------------------------------------------------------------------===;
; Truncating stores from v4i16 to v4i8.
;===-----------------------------------------------------------------------===;

; CHECK-LABEL: v4i16_st_v4i8:
; CHECK:       # %bb
; CHECK-NEXT:  sort8x8lo $m[[SORT8:[0-9]+]], $m{{[0-9]+}}, $m{{[0-9]+}}
; CHECK-NEXT:  st32 $m[[SORT8]], $m{{[0-9]+}}, $m15, 0
; CHECK-NEXT:  br $m10
define void @v4i16_st_v4i8(<4 x i16> %val, <4 x i8>* %dest) {
  %truncval = trunc <4 x i16> %val to <4 x i8>
  store <4 x i8> %truncval, <4 x i8>* %dest
  ret void
}

; CHECK-LABEL: ld_v4i16_st_v4i8:
; CHECK:       # %bb
; CHECK-NEXT:  ld32 $m[[LD1:[0-9]+]], $m0, $m15, 0
; CHECK-NEXT:  ld32 $m[[LD2:[0-9]+]], $m0, $m15, 1
; CHECK-NEXT:  sort8x8lo $m[[SORT8:[0-9]+]], $m[[LD1]], $m[[LD2]]
; CHECK-NEXT:  st32 $m[[SORT8]], $m{{[0-9]+}}, $m15, 0
; CHECK-NEXT:  br $m10
define void @ld_v4i16_st_v4i8(<4 x i16>* %src, <4 x i8>* %dst) {
  %val = load <4 x i16>, <4 x i16>* %src
  %truncval = trunc <4 x i16> %val to <4 x i8>
  store <4 x i8> %truncval, <4 x i8>* %dst
  ret void
}

; CHECK-LABEL:   ld_v4i16_st_v4i8_align1:
; CHECK:       # %bb
; CHECK:       ld32 $m[[LD1:[0-9]+]], $m0, $m15, 0
; CHECK-NEXT:  ld32 $m[[LD2:[0-9]+]], $m0, $m15, 1
; CHECK-NEXT:  sort8x8lo $m1, $m[[LD1]], $m[[LD2]]
; CHECK-NEXT:  mov $m0, $m2
; WORKER-NEXT:  call $m10, __st32_align1
; SUPERVISOR-NEXT:  call $m10, __supervisor_st32_align1
; CHECK:       br $m10
define void @ld_v4i16_st_v4i8_align1(<4 x i16>* %src, <4 x i8>* align 1 %dst) {
  %val = load <4 x i16>, <4 x i16>* %src
  %truncval = trunc <4 x i16> %val to <4 x i8>
  store <4 x i8> %truncval, <4 x i8>* %dst, align 1
  ret void
}

; CHECK-LABEL: ld_v4i16_st_v4i8_align2:
; CHECK:       # %bb
; CHECK:       ld32 $m[[LD1:[0-9]+]], $m0, $m15, 0
; CHECK-NEXT:  ld32 $m[[LD2:[0-9]+]], $m0, $m15, 1
; CHECK-NEXT:  sort8x8lo $m1, $m[[LD1]], $m[[LD2]]
; CHECK-NEXT:  mov $m0, $m2
; WORKER-NEXT:  call $m10, __st32_align2
; SUPERVISOR-NEXT:  call $m10, __supervisor_st32_align2
; CHECK:       br $m10
define void @ld_v4i16_st_v4i8_align2(<4 x i16>* %src, <4 x i8>* align 2 %dst) {
  %val = load <4 x i16>, <4 x i16>* %src
  %truncval = trunc <4 x i16> %val to <4 x i8>
  store <4 x i8> %truncval, <4 x i8>* %dst, align 2
  ret void
}

; CHECK-LABEL: ld_v4i16_st_v4i8_align4:
; CHECK:       # %bb
; CHECK-NEXT:  ld32 $m[[LD1:[0-9]+]], $m0, $m15, 0
; CHECK-NEXT:  ld32 $m[[LD2:[0-9]+]], $m0, $m15, 1
; CHECK-NEXT:  sort8x8lo $m[[SORT8:[0-9]+]], $m[[LD1]], $m[[LD2]]
; CHECK-NEXT:  st32 $m[[SORT8]], $m{{[0-9]+}}, $m15, 0
; CHECK-NEXT:  br $m10
define void @ld_v4i16_st_v4i8_align4(<4 x i16>* %src, <4 x i8>* align 4 %dst) {
  %val = load <4 x i16>, <4 x i16>* %src
  %truncval = trunc <4 x i16> %val to <4 x i8>
  store <4 x i8> %truncval, <4 x i8>* %dst, align 4
  ret void
}
