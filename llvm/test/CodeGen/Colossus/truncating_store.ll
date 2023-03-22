; RUN: llc < %s -march=colossus -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -march=colossus -mattr=+ipu2 | FileCheck %s

;;; Floating point

; CHECK-LABEL: store_f32_to_f16:
; CHECK:       # %bb
; CHECK:       add $m11, $m11, -8
; CHECK:       {
; CHECK-NEXT:  st32 $m10, $m11, $m15, [[LRSpill:[0-1]+]]
; CHECK-NEXT:  f32tof16 $a0, $a0
; CHECK-NEXT:  }
; CHECK-NEXT:  call $m10, __st16f
; CHECK-NEXT:  ld32 $m10, $m11, $m15, [[LRSpill]]
; CHECK:       add $m11, $m11, 8
; CHECK:       br $m10
define void @store_f32_to_f16(float %v, half* %p) {
  %t = fptrunc float %v to half
  store half %t, half* %p
  ret void
}

declare half @llvm.experimental.constrained.fptrunc.f16.f32(float %src, metadata, metadata)

; CHECK-LABEL: strict_store_f32_to_f16:
; CHECK:       # %bb
; CHECK:       add $m11, $m11, -8
; CHECK:       {
; CHECK-NEXT:  st32 $m10, $m11, $m15, [[LRSpill:[0-1]+]]
; CHECK-NEXT:  f32tof16 $a0, $a0
; CHECK-NEXT:  }
; CHECK-NEXT:  call $m10, __st16f
; CHECK-NEXT:  ld32 $m10, $m11, $m15, [[LRSpill]]
; CHECK:       add $m11, $m11, 8
; CHECK:       br $m10
define void @strict_store_f32_to_f16(float %v, half* %p) {
  %t = tail call half @llvm.experimental.constrained.fptrunc.f16.f32(float %v, metadata !"round.tonearest", metadata !"fpexcept.strict")
  store half %t, half* %p
  ret void
}

; CHECK-LABEL: store_f32_to_f16_a1:
; CHECK:       # %bb
; CHECK:       add $m11, $m11, -8
; CHECK:       {
; CHECK-NEXT:  st32 $m10, $m11, $m15, [[LRSpill:[0-1]+]]
; CHECK-NEXT:  f32tof16 $a0, $a0
; CHECK-NEXT:  }
; CHECK-NEXT:  call $m10, __st16f_misaligned
; CHECK-NEXT:  ld32 $m10, $m11, $m15, [[LRSpill]]
; CHECK:       add $m11, $m11, 8
; CHECK:       br $m10
define void @store_f32_to_f16_a1(float %v, half* %p) {
  %t = fptrunc float %v to half
  store half %t, half* %p, align 1
  ret void
}

; CHECK-LABEL: strict_store_f32_to_f16_a1:
; CHECK:       # %bb
; CHECK:       add $m11, $m11, -8
; CHECK:       {
; CHECK-NEXT:  st32 $m10, $m11, $m15, [[LRSpill:[0-1]+]]
; CHECK-NEXT:  f32tof16 $a0, $a0
; CHECK-NEXT:  }
; CHECK-NEXT:  call $m10, __st16f_misaligned
; CHECK-NEXT:  ld32 $m10, $m11, $m15, [[LRSpill]]
; CHECK:       add $m11, $m11, 8
; CHECK:       br $m10
define void @strict_store_f32_to_f16_a1(float %v, half* %p) {
  %t = tail call half @llvm.experimental.constrained.fptrunc.f16.f32(float %v, metadata !"round.tonearest", metadata !"fpexcept.strict")
  store half %t, half* %p, align 1
  ret void
}

; CHECK-LABEL: store_v2f32_to_v2f16:
; CHECK:       # %bb
; CHECK-NEXT:  f32v2tof16 $a0, $a0:1
; CHECK-NEXT:  st32 $a0, $m0, $m15, 0
; CHECK:       br $m10
define void @store_v2f32_to_v2f16(<2 x float> %v, <2 x half>* %p) {
  %t = fptrunc <2 x float> %v to <2 x half>
  store <2 x half> %t, <2 x half>* %p
  ret void
}

declare <2 x half> @llvm.experimental.constrained.fptrunc.v2f16.v2f32(<2 x float> %src, metadata, metadata)

; CHECK-LABEL: strict_store_v2f32_to_v2f16:
; CHECK:       # %bb
; CHECK-NEXT:  f32v2tof16 $a0, $a0:1
; CHECK-NEXT:  st32 $a0, $m0, $m15, 0
; CHECK:       br $m10
define void @strict_store_v2f32_to_v2f16(<2 x float> %v, <2 x half>* %p) {
  %t = tail call <2 x half> @llvm.experimental.constrained.fptrunc.v2f16.v2f32(<2 x float> %v, metadata !"round.tonearest", metadata !"fpexcept.strict")
  store <2 x half> %t, <2 x half>* %p
  ret void
}

; CHECK-LABEL: store_v2f32_to_v2f16_a2:
; CHECK:       # %bb
; CHECK:       add $m11, $m11, -8
; CHECK:       {
; CHECK-NEXT:  st32 $m10, $m11, $m15, [[LRSpill:[0-1]+]]
; CHECK-NEXT:  f32v2tof16 $a0, $a0:1
; CHECK-NEXT:  }
; CHECK-NEXT:  call $m10, __st32f_align2
; CHECK-NEXT:  ld32 $m10, $m11, $m15, [[LRSpill]]
; CHECK:       add $m11, $m11, 8
; CHECK:       br $m10
define void @store_v2f32_to_v2f16_a2(<2 x float> %v, <2 x half>* %p) {
  %t = fptrunc <2 x float> %v to <2 x half>
  store <2 x half> %t, <2 x half>* %p, align 2
  ret void
}

; CHECK-LABEL: strict_store_v2f32_to_v2f16_a2:
; CHECK:       # %bb
; CHECK:       add $m11, $m11, -8
; CHECK:       {
; CHECK-NEXT:  st32 $m10, $m11, $m15, [[LRSpill:[0-1]+]]
; CHECK-NEXT:  f32v2tof16 $a0, $a0:1
; CHECK-NEXT:  }
; CHECK-NEXT:  call $m10, __st32f_align2
; CHECK-NEXT:  ld32 $m10, $m11, $m15, [[LRSpill]]
; CHECK:       add $m11, $m11, 8
; CHECK:       br $m10
define void @strict_store_v2f32_to_v2f16_a2(<2 x float> %v, <2 x half>* %p) {
  %t = tail call <2 x half> @llvm.experimental.constrained.fptrunc.v2f16.v2f32(<2 x float> %v, metadata !"round.tonearest", metadata !"fpexcept.strict")
  store <2 x half> %t, <2 x half>* %p, align 2
  ret void
}

; CHECK-LABEL: store_v2f32_to_v2f16_a1:
; CHECK:       # %bb
; CHECK:       add $m11, $m11, -8
; CHECK:       {
; CHECK-NEXT:  st32 $m10, $m11, $m15, [[LRSpill:[0-1]+]]
; CHECK-NEXT:  f32v2tof16 $a0, $a0:1
; CHECK-NEXT:  }
; CHECK-NEXT:  call $m10, __st32f_align1
; CHECK-NEXT:  ld32 $m10, $m11, $m15, [[LRSpill]]
; CHECK:       add $m11, $m11, 8
; CHECK:       br $m10
define void @store_v2f32_to_v2f16_a1(<2 x float> %v, <2 x half>* %p) {
  %t = fptrunc <2 x float> %v to <2 x half>
  store <2 x half> %t, <2 x half>* %p, align 1
  ret void
}

; CHECK-LABEL: strict_store_v2f32_to_v2f16_a1:
; CHECK:       # %bb
; CHECK:       add $m11, $m11, -8
; CHECK:       {
; CHECK-NEXT:  st32 $m10, $m11, $m15, [[LRSpill:[0-1]+]]
; CHECK-NEXT:  f32v2tof16 $a0, $a0:1
; CHECK-NEXT:  }
; CHECK-NEXT:  call $m10, __st32f_align1
; CHECK-NEXT:  ld32 $m10, $m11, $m15, [[LRSpill]]
; CHECK:       add $m11, $m11, 8
; CHECK:       br $m10
define void @strict_store_v2f32_to_v2f16_a1(<2 x float> %v, <2 x half>* %p) {
  %t = tail call <2 x half> @llvm.experimental.constrained.fptrunc.v2f16.v2f32(<2 x float> %v, metadata !"round.tonearest", metadata !"fpexcept.strict")
  store <2 x half> %t, <2 x half>* %p, align 1
  ret void
}

;;; (vectors of) i32

; CHECK-LABEL: store_i32_to_i16:
; CHECK:       # %bb
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m10, $m11, $m15, [[LRSpill:[0-1]+]]
; CHECK-NEXT:  mov [[TMP:\$m[2-9]+]], $m0
; CHECK-NEXT:  mov $m0, $m1
; CHECK-NEXT:  mov $m1, [[TMP]]
; CHECK-NEXT:  call $m10, __st16
; CHECK-NEXT:  ld32 $m10, $m11, $m15, [[LRSpill]]
; CHECK:       add $m11, $m11, 8
; CHECK:       br $m10
define void @store_i32_to_i16(i32 %v, i16* %p) {
  %t = trunc i32 %v to i16
  store i16 %t, i16* %p
  ret void
}

; CHECK-LABEL: store_i32_to_i16_a1:
; CHECK:       # %bb
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m10, $m11, $m15, [[LRSpill:[0-1]+]]
; CHECK-NEXT:  mov [[TMP:\$m[2-9]+]], $m0
; CHECK-NEXT:  mov $m0, $m1
; CHECK-NEXT:  mov $m1, [[TMP]]
; CHECK-NEXT:  call $m10, __st16_misaligned
; CHECK-NEXT:  ld32 $m10, $m11, $m15, [[LRSpill]]
; CHECK:       add $m11, $m11, 8
; CHECK:       br $m10
define void @store_i32_to_i16_a1(i32 %v, i16* %p) {
  %t = trunc i32 %v to i16
  store i16 %t, i16* %p, align 1
  ret void
}

; CHECK-LABEL: store_v2i32_to_v2i16:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $m0, $m0, $m1
; CHECK-NEXT:  st32 $m0, $m2, $m15, 0
; CHECK:       br $m10
define void @store_v2i32_to_v2i16(<2 x i32> %v, <2 x i16>* %p) {
  %t = trunc <2 x i32> %v to <2 x i16>
  store <2 x i16> %t, <2 x i16>* %p
  ret void
}

; CHECK-LABEL: store_v2i32_to_v2i16_a2:
; CHECK:       # %bb
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m10, $m11, $m15, [[LRSpill:[0-1]+]]
; CHECK-NEXT:  sort4x16lo $m1, $m0, $m1
; CHECK-NEXT:  mov $m0, $m2
; CHECK-NEXT:  call $m10, __st32_align2
; CHECK-NEXT:  ld32 $m10, $m11, $m15, [[LRSpill]]
; CHECK:       add $m11, $m11, 8
; CHECK:       br $m10
define void @store_v2i32_to_v2i16_a2(<2 x i32> %v, <2 x i16>* %p) {
  %t = trunc <2 x i32> %v to <2 x i16>
  store <2 x i16> %t, <2 x i16>* %p, align 2
  ret void
}

; CHECK-LABEL: store_v2i32_to_v2i16_a1:
; CHECK:       # %bb
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m10, $m11, $m15, [[LRSpill:[0-1]+]]
; CHECK-NEXT:  sort4x16lo $m1, $m0, $m1
; CHECK-NEXT:  mov $m0, $m2
; CHECK-NEXT:  call $m10, __st32_align1
; CHECK-NEXT:  ld32 $m10, $m11, $m15, [[LRSpill]]
; CHECK:       add $m11, $m11, 8
; CHECK:       br $m10
define void @store_v2i32_to_v2i16_a1(<2 x i32> %v, <2 x i16>* %p) {
  %t = trunc <2 x i32> %v to <2 x i16>
  store <2 x i16> %t, <2 x i16>* %p, align 1
  ret void
}

; CHECK-LABEL: store_i32_to_i8:
; CHECK:       # %bb
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m10, $m11, $m15, [[LRSpill:[0-1]+]]
; CHECK-NEXT:  mov [[TMP:\$m[2-9]+]], $m0
; CHECK-NEXT:  mov $m0, $m1
; CHECK-NEXT:  mov $m1, [[TMP]]
; CHECK-NEXT:  call $m10, __st8
; CHECK-NEXT:  ld32 $m10, $m11, $m15, [[LRSpill]]
; CHECK:       add $m11, $m11, 8
; CHECK:       br $m10
define void @store_i32_to_i8(i32 %v, i8* %p) {
  %t = trunc i32 %v to i8
  store i8 %t, i8* %p
  ret void
}

; CHECK-LABEL: store_v2i32_to_v2i8:
; CHECK:       # %bb
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m10, $m11, $m15, [[LRSpill:[0-1]+]]
; CHECK-NEXT:  sort4x16lo [[TMP:\$m[0-9]+]], $m0, $m1
; CHECK-NEXT:  sort8x8lo $m1, [[TMP]], $m15
; CHECK-NEXT:  mov $m0, $m2
; CHECK-NEXT:  call $m10, __st16
; CHECK-NEXT:  ld32 $m10, $m11, $m15, [[LRSpill]]
; CHECK:       add $m11, $m11, 8
; CHECK:       br $m10
define void @store_v2i32_to_v2i8(<2 x i32> %v, <2 x i8>* %p) {
  %t = trunc <2 x i32> %v to <2 x i8>
  store <2 x i8> %t, <2 x i8>* %p
  ret void
}

; CHECK-LABEL: store_v2i32_to_v2i8_a1:
; CHECK:       # %bb
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m10, $m11, $m15, [[LRSpill:[0-1]+]]
; CHECK-NEXT:  sort4x16lo [[TMP:\$m[0-9]+]], $m0, $m1
; CHECK-NEXT:  sort8x8lo $m1, [[TMP]], $m15
; CHECK-NEXT:  mov $m0, $m2
; CHECK-NEXT:  call $m10, __st16_misaligned
; CHECK-NEXT:  ld32 $m10, $m11, $m15, [[LRSpill]]
; CHECK:       add $m11, $m11, 8
; CHECK:       br $m10
define void @store_v2i32_to_v2i8_a1(<2 x i32> %v, <2 x i8>* %p) {
  %t = trunc <2 x i32> %v to <2 x i8>
  store <2 x i8> %t, <2 x i8>* %p, align 1
  ret void
}

;;; (vectors of) i16

; CHECK-LABEL: store_i16_to_i8:
; CHECK:       # %bb
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m10, $m11, $m15, [[LRSpill:[0-1]+]]
; CHECK-NEXT:  mov [[TMP:\$m[2-9]+]], $m0
; CHECK-NEXT:  mov $m0, $m1
; CHECK-NEXT:  mov $m1, [[TMP]]
; CHECK-NEXT:  call $m10, __st8
; CHECK-NEXT:  ld32 $m10, $m11, $m15, [[LRSpill]]
; CHECK:       add $m11, $m11, 8
; CHECK:       br $m10
define void @store_i16_to_i8(i16 %v, i8* %p) {
  %t = trunc i16 %v to i8
  store i8 %t, i8* %p
  ret void
}

; CHECK-LABEL: store_v2i16_to_v2i8:
; CHECK:       # %bb
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m10, $m11, $m15, [[LRSpill:[0-1]+]]
; CHECK-NEXT:  mov [[TMP:\$m[2-9]+]], $m1
; CHECK-NEXT:  sort8x8lo $m1, $m0, $m15
; CHECK-NEXT:  mov $m0, [[TMP]]
; CHECK-NEXT:  call $m10, __st16
; CHECK-NEXT:  ld32 $m10, $m11, $m15, [[LRSpill]]
; CHECK:       add $m11, $m11, 8
; CHECK:       br $m10
define void @store_v2i16_to_v2i8(<2 x i16> %v, <2 x i8>* %p) {
  %t = trunc <2 x i16> %v to <2 x i8>
  store <2 x i8> %t, <2 x i8>* %p
  ret void
}

; CHECK-LABEL: store_v2i16_to_v2i8_a1:
; CHECK:       # %bb
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m10, $m11, $m15, [[LRSpill:[0-1]+]]
; CHECK-NEXT:  mov [[TMP:\$m[2-9]+]], $m1
; CHECK-NEXT:  sort8x8lo $m1, $m0, $m15
; CHECK-NEXT:  mov $m0, [[TMP]]
; CHECK-NEXT:  call $m10, __st16_misaligned
; CHECK-NEXT:  ld32 $m10, $m11, $m15, [[LRSpill]]
; CHECK:       add $m11, $m11, 8
; CHECK:       br $m10
define void @store_v2i16_to_v2i8_a1(<2 x i16> %v, <2 x i8>* %p) {
  %t = trunc <2 x i16> %v to <2 x i8>
  store <2 x i8> %t, <2 x i8>* %p, align 1
  ret void
}

; CHECK-LABEL: store_v4i16_to_v4i8:
; CHECK:       # %bb
; CHECK-NEXT:  sort8x8lo $m0, $m0, $m1
; CHECK-NEXT:  st32 $m0, $m2, $m15, 0
; CHECK:       br $m10
define void @store_v4i16_to_v4i8(<4 x i16> %v, <4 x i8>* %p) {
  %t = trunc <4 x i16> %v to <4 x i8>
  store <4 x i8> %t, <4 x i8>* %p
  ret void
}

; CHECK-LABEL: store_v4i16_to_v4i8_a2:
; CHECK:       # %bb
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m10, $m11, $m15, [[LRSpill:[0-1]+]]
; CHECK-NEXT:  sort8x8lo $m1, $m0, $m1
; CHECK-NEXT:  mov $m0, $m2
; CHECK-NEXT:  call $m10, __st32_align2
; CHECK-NEXT:  ld32 $m10, $m11, $m15, [[LRSpill]]
; CHECK:       add $m11, $m11, 8
; CHECK:       br $m10
define void @store_v4i16_to_v4i8_a2(<4 x i16> %v, <4 x i8>* %p) {
  %t = trunc <4 x i16> %v to <4 x i8>
  store <4 x i8> %t, <4 x i8>* %p, align 2
  ret void
}

; CHECK-LABEL: store_v4i16_to_v4i8_a1:
; CHECK:       # %bb
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m10, $m11, $m15, [[LRSpill:[0-1]+]]
; CHECK-NEXT:  sort8x8lo $m1, $m0, $m1
; CHECK-NEXT:  mov $m0, $m2
; CHECK-NEXT:  call $m10, __st32_align1
; CHECK-NEXT:  ld32 $m10, $m11, $m15, [[LRSpill]]
; CHECK:       add $m11, $m11, 8
; CHECK:       br $m10
define void @store_v4i16_to_v4i8_a1(<4 x i16> %v, <4 x i8>* %p) {
  %t = trunc <4 x i16> %v to <4 x i8>
  store <4 x i8> %t, <4 x i8>* %p, align 1
  ret void
}
