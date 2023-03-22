; RUN: llc < %s -march=colossus -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -march=colossus -mattr=+ipu2 | FileCheck %s

; CHECK-LABEL:  load_align4_v2f32
; CHECK:        ld32 $a0, $m0, $m15, 0
; CHECK-NEXT:   ld32 $a1, $m0, $m15, 1
; CHECK-NEXT:   br $m10
define <2 x float> @load_align4_v2f32(<2 x float>* %p) {
  %res = load <2 x float>, <2 x float>* %p, align 4
  ret <2 x float> %res
}

; CHECK-LABEL:  load_align2_v2f32
; CHECK:        add $m11, $m11, -8
; CHECK:        ldz16 $m[[LD1:[0-9]+]], $m0, $m15, 3
; CHECK-NEXT:   ldz16 $m[[LD2:[0-9]+]], $m0, $m15, 2
; CHECK-NEXT:   sort4x16lo $m[[SORT1:[0-9]+]], $m[[LD2]], $m[[LD1]]
; CHECK-NEXT:   st32 $m[[SORT1]], $m11, $m15, 1
; CHECK-NEXT:   ldz16 $m[[LD3:[0-9]+]], $m0, $m15, 1
; CHECK-NEXT:   ldz16 $m[[LD4:[0-9]+]], $m0, $m15, 0
; CHECK-NEXT:   sort4x16lo $m[[SORT2:[0-9]+]], $m[[LD4]], $m[[LD3]]
; CHECK-NEXT:   st32 $m[[SORT2]], $m11, $m15, 0
; CHECK-NEXT:   ld64 $a0:1, $m11, $m15, 0
; CHECK-NEXT:   add $m11, $m11, 8
; CHECK:        br $m10
define <2 x float> @load_align2_v2f32(<2 x float>* %p) {
  %res = load <2 x float>, <2 x float>* %p, align 2
  ret <2 x float> %res
}

; CHECK-LABEL:  load_align1_v2f32
; CHECK:        add $m11, $m11, -8
; CHECK:        ldz8 $m[[LD1:[0-9]+]], $m0, $m15, 7
; CHECK-NEXT:   ldz8 $m[[LD2:[0-9]+]], $m0, $m15, 6
; CHECK-NEXT:   ldz8 $m[[LD3:[0-9]+]], $m0, $m15, 5
; CHECK-NEXT:   shuf8x8lo $m[[SHUF1:[0-9]+]], $m[[LD2]], $m[[LD1]]
; CHECK-NEXT:   ldz8 $m[[LD4:[0-9]+]], $m0, $m15, 4
; CHECK-NEXT:   shuf8x8lo $m[[SHUF2:[0-9]+]], $m[[LD4]], $m[[LD3]]
; CHECK-NEXT:   sort4x16lo $m[[SORT1:[0-9]+]], $m[[SHUF2]], $m[[SHUF1]]
; CHECK-NEXT:   st32 $m[[SORT1]], $m11, $m15, 1
; CHECK-NEXT:   ldz8 $m[[LD5:[0-9]+]], $m0, $m15, 3
; CHECK-NEXT:   ldz8 $m[[LD6:[0-9]+]], $m0, $m15, 2
; CHECK-NEXT:   ldz8 $m[[LD7:[0-9]+]], $m0, $m15, 1
; CHECK-NEXT:   ldz8 $m[[LD8:[0-9]+]], $m0, $m15, 0
; CHECK-NEXT:   shuf8x8lo $m[[SHUF3:[0-9]+]], $m[[LD6]], $m[[LD5]]
; CHECK-NEXT:   shuf8x8lo $m[[SHUF4:[0-9]+]], $m[[LD8]], $m[[LD7]]
; CHECK-NEXT:   sort4x16lo $m[[SORT2:[0-9]+]], $m[[SHUF4]], $m[[SHUF3]]
; CHECK-NEXT:   st32 $m[[SORT2]], $m11, $m15, 0
; CHECK-NEXT:   ld64 $a0:1, $m11, $m15, 0
; CHECK-NEXT:   add $m11, $m11, 8
; CHECK:        br $m10
define <2 x float> @load_align1_v2f32(<2 x float>* %p) {
  %res = load <2 x float>, <2 x float>* %p, align 1
  ret <2 x float> %res
}

; CHECK-LABEL:  load_align4_v4f16
; CHECK:        ld32 $a0, $m0, $m15, 0
; CHECK-NEXT:   ld32 $a1, $m0, $m15, 1
; CHECK:        br $m10
define <4 x half> @load_align4_v4f16(<4 x half>* %p) {
  %res = load <4 x half>, <4 x half>* %p, align 4
  ret <4 x half> %res
}

; CHECK-LABEL:  load_align2_v4f16
; CHECK:        add $m11, $m11, -8
; CHECK:        ldz16 $m[[LD1:[0-9]+]], $m0, $m15, 3
; CHECK-NEXT:   ldz16 $m[[LD2:[0-9]+]], $m0, $m15, 2
; CHECK-NEXT:   sort4x16lo $m[[SORT1:[0-9]+]], $m[[LD2]], $m[[LD1]]
; CHECK-NEXT:   st32 $m[[SORT1]], $m11, $m15, 1
; CHECK-NEXT:   ldz16 $m[[LD3:[0-9]+]], $m0, $m15, 1
; CHECK-NEXT:   ldz16 $m[[LD4:[0-9]+]], $m0, $m15, 0
; CHECK-NEXT:   sort4x16lo $m[[SORT2:[0-9]+]], $m[[LD4]], $m[[LD3]]
; CHECK-NEXT:   st32 $m[[SORT2]], $m11, $m15, 0
; CHECK-NEXT:   ld64 $a0:1, $m11, $m15, 0
; CHECK-NEXT:   add $m11, $m11, 8
; CHECK:        br $m10
define <4 x half> @load_align2_v4f16(<4 x half>* %p) {
  %res = load <4 x half>, <4 x half>* %p, align 2
  ret <4 x half> %res
}

; CHECK-LABEL:  load_align1_v4f16
; CHECK:        add $m11, $m11, -8
; CHECK:        ldz8 $m[[LD1:[0-9]+]], $m0, $m15, 7
; CHECK-NEXT:   ldz8 $m[[LD2:[0-9]+]], $m0, $m15, 6
; CHECK-NEXT:   ldz8 $m[[LD3:[0-9]+]], $m0, $m15, 5
; CHECK-NEXT:   shuf8x8lo $m[[SHUF1:[0-9]+]], $m[[LD2]], $m[[LD1]]
; CHECK-NEXT:   ldz8 $m[[LD4:[0-9]+]], $m0, $m15, 4
; CHECK-NEXT:   shuf8x8lo $m[[SHUF2:[0-9]+]], $m[[LD4]], $m[[LD3]]
; CHECK-NEXT:   sort4x16lo $m[[SORT1:[0-9]+]], $m[[SHUF2]], $m[[SHUF1]]
; CHECK-NEXT:   st32 $m[[SORT1]], $m11, $m15, 1
; CHECK-NEXT:   ldz8 $m[[LD5:[0-9]+]], $m0, $m15, 3
; CHECK-NEXT:   ldz8 $m[[LD6:[0-9]+]], $m0, $m15, 2
; CHECK-NEXT:   ldz8 $m[[LD7:[0-9]+]], $m0, $m15, 1
; CHECK-NEXT:   ldz8 $m[[LD8:[0-9]+]], $m0, $m15, 0
; CHECK-NEXT:   shuf8x8lo $m[[SHUF3:[0-9]+]], $m[[LD6]], $m[[LD5]]
; CHECK-NEXT:   shuf8x8lo $m[[SHUF4:[0-9]+]], $m[[LD8]], $m[[LD7]]
; CHECK-NEXT:   sort4x16lo $m[[SORT2:[0-9]+]], $m[[SHUF4]], $m[[SHUF3]]
; CHECK-NEXT:   st32 $m[[SORT2]], $m11, $m15, 0
; CHECK-NEXT:   ld64 $a0:1, $m11, $m15, 0
; CHECK-NEXT:   add $m11, $m11, 8
; CHECK:        br $m10
define <4 x half> @load_align1_v4f16(<4 x half>* %p) {
  %res = load <4 x half>, <4 x half>* %p, align 1
  ret <4 x half> %res
}

; CHECK-LABEL:  load_align4_v2i32
; CHECK:        ld32 $m[[LD1:[0-9]+]], $m0, $m15, 0
; CHECK-NEXT:   ld32 $m[[LD2:[0-9]+]], $m0, $m15, 1
; CHECK-NEXT:   mov $m0, $m[[LD1]]
; CHECK-NEXT:   mov $m1, $m[[LD2]]
; CHECK:        br $m10
define <2 x i32> @load_align4_v2i32(<2 x i32>* %p) {
  %res = load <2 x i32>, <2 x i32>* %p, align 4
  ret <2 x i32> %res
}

; CHECK-LABEL:  load_align2_v2i32
; CHECK:        add $m11, $m11, -8
; CHECK:        ldz16 $m[[LD1:[0-9]+]], $m0, $m15, 3
; CHECK-NEXT:   ldz16 $m[[LD2:[0-9]+]], $m0, $m15, 2
; CHECK-NEXT:   sort4x16lo $m[[SORT1:[0-9]+]], $m[[LD2]], $m[[LD1]]
; CHECK-NEXT:   st32 $m[[SORT1]], $m11, $m15, 1
; CHECK-NEXT:   ldz16 $m[[LD3:[0-9]+]], $m0, $m15, 1
; CHECK-NEXT:   ldz16 $m[[LD4:[0-9]+]], $m0, $m15, 0
; CHECK-NEXT:   sort4x16lo $m[[SORT2:[0-9]+]], $m[[LD4]], $m[[LD3]]
; CHECK-NEXT:   st32 $m[[SORT2]], $m11, $m15, 0
; CHECK-NEXT:   ld32 $m0, $m11, $m15, 0
; CHECK-NEXT:   ld32 $m1, $m11, $m15, 1
; CHECK-NEXT:   add $m11, $m11, 8
; CHECK:        br $m10
define <2 x i32> @load_align2_v2i32(<2 x i32>* %p) {
  %res = load <2 x i32>, <2 x i32>* %p, align 2
  ret <2 x i32> %res
}

; CHECK-LABEL:  load_align1_v2i32
; CHECK:        add $m11, $m11, -8
; CHECK:        ldz8 $m[[LD1:[0-9]+]], $m0, $m15, 7
; CHECK-NEXT:   ldz8 $m[[LD2:[0-9]+]], $m0, $m15, 6
; CHECK-NEXT:   ldz8 $m[[LD3:[0-9]+]], $m0, $m15, 5
; CHECK-NEXT:   shuf8x8lo $m[[SHUF1:[0-9]+]], $m[[LD2]], $m[[LD1]]
; CHECK-NEXT:   ldz8 $m[[LD4:[0-9]+]], $m0, $m15, 4
; CHECK-NEXT:   shuf8x8lo $m[[SHUF2:[0-9]+]], $m[[LD4]], $m[[LD3]]
; CHECK-NEXT:   sort4x16lo $m[[SORT1:[0-9]+]], $m[[SHUF2]], $m[[SHUF1]]
; CHECK-NEXT:   st32 $m[[SORT1]], $m11, $m15, 1
; CHECK-NEXT:   ldz8 $m[[LD5:[0-9]+]], $m0, $m15, 3
; CHECK-NEXT:   ldz8 $m[[LD6:[0-9]+]], $m0, $m15, 2
; CHECK-NEXT:   ldz8 $m[[LD7:[0-9]+]], $m0, $m15, 1
; CHECK-NEXT:   ldz8 $m[[LD8:[0-9]+]], $m0, $m15, 0
; CHECK-NEXT:   shuf8x8lo $m[[SHUF3:[0-9]+]], $m[[LD6]], $m[[LD5]]
; CHECK-NEXT:   shuf8x8lo $m[[SHUF4:[0-9]+]], $m[[LD8]], $m[[LD7]]
; CHECK-NEXT:   sort4x16lo $m[[SORT2:[0-9]+]], $m[[SHUF4]], $m[[SHUF3]]
; CHECK-NEXT:   st32 $m[[SORT2]], $m11, $m15, 0
; CHECK-NEXT:   ld32 $m0, $m11, $m15, 0
; CHECK-NEXT:   ld32 $m1, $m11, $m15, 1
; CHECK-NEXT:   add $m11, $m11, 8
; CHECK:        br $m10
define <2 x i32> @load_align1_v2i32(<2 x i32>* %p) {
  %res = load <2 x i32>, <2 x i32>* %p, align 1
  ret <2 x i32> %res
}

; CHECK-LABEL:  load_align4_v4i16
; CHECK:        ld32 $m[[LD1:[0-9]+]], $m0, $m15, 0
; CHECK-NEXT:   ld32 $m[[LD2:[0-9]+]], $m0, $m15, 1
; CHECK-NEXT:   mov $m0, $m[[LD1]]
; CHECK-NEXT:   mov $m1, $m[[LD2]]
; CHECK:        br $m10
define <4 x i16> @load_align4_v4i16(<4 x i16>* %p) {
  %res = load <4 x i16>, <4 x i16>* %p, align 4
  ret <4 x i16> %res
}

; CHECK-LABEL:  load_align2_v4i16
; CHECK:        add $m11, $m11, -8
; CHECK:        ldz16 $m[[LD1:[0-9]+]], $m0, $m15, 3
; CHECK-NEXT:   ldz16 $m[[LD2:[0-9]+]], $m0, $m15, 2
; CHECK-NEXT:   sort4x16lo $m[[SORT1:[0-9]+]], $m[[LD2]], $m[[LD1]]
; CHECK-NEXT:   st32 $m[[SORT1]], $m11, $m15, 1
; CHECK-NEXT:   ldz16 $m[[LD3:[0-9]+]], $m0, $m15, 1
; CHECK-NEXT:   ldz16 $m[[LD4:[0-9]+]], $m0, $m15, 0
; CHECK-NEXT:   sort4x16lo $m[[SORT2:[0-9]+]], $m[[LD4]], $m[[LD3]]
; CHECK-NEXT:   st32 $m[[SORT2]], $m11, $m15, 0
; CHECK-NEXT:   ld32 $m0, $m11, $m15, 0
; CHECK-NEXT:   ld32 $m1, $m11, $m15, 1
; CHECK-NEXT:   add $m11, $m11, 8
; CHECK:        br $m10
define <4 x i16> @load_align2_v4i16(<4 x i16>* %p) {
  %res = load <4 x i16>, <4 x i16>* %p, align 2
  ret <4 x i16> %res
}

; CHECK-LABEL:  load_align1_v4i16
; CHECK:        add $m11, $m11, -8
; CHECK:        ldz8 $m[[LD1:[0-9]+]], $m0, $m15, 7
; CHECK-NEXT:   ldz8 $m[[LD2:[0-9]+]], $m0, $m15, 6
; CHECK-NEXT:   ldz8 $m[[LD3:[0-9]+]], $m0, $m15, 5
; CHECK-NEXT:   shuf8x8lo $m[[SHUF1:[0-9]+]], $m[[LD2]], $m[[LD1]]
; CHECK-NEXT:   ldz8 $m[[LD4:[0-9]+]], $m0, $m15, 4
; CHECK-NEXT:   shuf8x8lo $m[[SHUF2:[0-9]+]], $m[[LD4]], $m[[LD3]]
; CHECK-NEXT:   sort4x16lo $m[[SORT1:[0-9]+]], $m[[SHUF2]], $m[[SHUF1]]
; CHECK-NEXT:   st32 $m[[SORT1]], $m11, $m15, 1
; CHECK-NEXT:   ldz8 $m[[LD5:[0-9]+]], $m0, $m15, 3
; CHECK-NEXT:   ldz8 $m[[LD6:[0-9]+]], $m0, $m15, 2
; CHECK-NEXT:   ldz8 $m[[LD7:[0-9]+]], $m0, $m15, 1
; CHECK-NEXT:   ldz8 $m[[LD8:[0-9]+]], $m0, $m15, 0
; CHECK-NEXT:   shuf8x8lo $m[[SHUF3:[0-9]+]], $m[[LD6]], $m[[LD5]]
; CHECK-NEXT:   shuf8x8lo $m[[SHUF4:[0-9]+]], $m[[LD8]], $m[[LD7]]
; CHECK-NEXT:   sort4x16lo $m[[SORT2:[0-9]+]], $m[[SHUF4]], $m[[SHUF3]]
; CHECK-NEXT:   st32 $m[[SORT2]], $m11, $m15, 0
; CHECK-NEXT:   ld32 $m0, $m11, $m15, 0
; CHECK-NEXT:   ld32 $m1, $m11, $m15, 1
; CHECK-NEXT:   add $m11, $m11, 8
; CHECK:        br $m10
define <4 x i16> @load_align1_v4i16(<4 x i16>* %p) {
  %res = load <4 x i16>, <4 x i16>* %p, align 1
  ret <4 x i16> %res
}

; CHECK-LABEL:  load_align2_i32
; CHECK:        ldz16 $m[[LD1:[0-9]+]], $m0, $m15, 1
; CHECK-NEXT:   ldz16 $m[[LD2:[0-9]+]], $m0, $m15, 0
; CHECK-NEXT:   sort4x16lo $m0, $m[[LD2]], $m[[LD1]]
; CHECK:        br $m10
define i32 @load_align2_i32(i32* %p) {
  %res = load i32, i32* %p, align 2
  ret i32 %res
}

; CHECK-LABEL:  load_align1_i32
; CHECK:        ldz8 $m[[LD1:[0-9]+]], $m0, $m15, 3
; CHECK-NEXT:   ldz8 $m[[LD2:[0-9]+]], $m0, $m15, 2
; CHECK-NEXT:   shuf8x8lo $m[[SHUF1:[0-9]+]], $m[[LD2]], $m[[LD1]]
; CHECK-NEXT:   ldz8 $m[[LD3:[0-9]+]], $m0, $m15, 1
; CHECK-NEXT:   ldz8 $m[[LD4:[0-9]+]], $m0, $m15, 0
; CHECK-NEXT:   shuf8x8lo $m[[SHUF2:[0-9]+]], $m[[LD4]], $m[[LD3]]
; CHECK-NEXT:   sort4x16lo $m0, $m[[SHUF2]], $m[[SHUF1]]
; CHECK:        br $m10
define i32 @load_align1_i32(i32* %p) {
  %res = load i32, i32* %p, align 1
  ret i32 %res
}

; CHECK-LABEL:  load_align2_float
; CHECK:        ldb16 $a[[LD1:[0-9]+]], $m0, $m15, 1
; CHECK-NEXT:   ldb16 $a[[LD2:[0-9]+]], $m0, $m15, 0
; CHECK-NEXT:   {
; CHECK-NEXT:     br $m10
; CHECK-NEXT:     sort4x16lo $a0, $a[[LD2]], $a[[LD1]]
; CHECK-NEXT:   }
define float @load_align2_float(float* %p) {
  %res = load float, float* %p, align 2
  ret float %res
}

; CHECK-LABEL:  load_align1_float
; CHECK:        ldz8 $m[[LD1:[0-9]+]], $m0, $m15, 3
; CHECK-NEXT:   ldz8 $m[[LD2:[0-9]+]], $m0, $m15, 2
; CHECK-NEXT:   shuf8x8lo $m[[SHUF1:[0-9]+]], $m[[LD2]], $m[[LD1]]
; CHECK-NEXT:   ldz8 $m[[LD3:[0-9]+]], $m0, $m15, 1
; CHECK-NEXT:   ldz8 $m[[LD4:[0-9]+]], $m0, $m15, 0
; CHECK-NEXT:   shuf8x8lo $m[[SHUF2:[0-9]+]], $m[[LD4]], $m[[LD3]]
; CHECK-NEXT:   sort4x16lo $m[[SORT1:[0-9]+]], $m[[SHUF2]], $m[[SHUF1]]
; CHECK-NEXT:   st32 $m[[SORT1]], $m11, $m15, 1
; CHECK-NEXT:   ld32 $a0, $m11, $m15, 1
; CHECK-NEXT:   add
; CHECK:        br $m10
define float @load_align1_float(float* %p) {
  %res = load float, float* %p, align 1
  ret float %res
}

; CHECK-LABEL:  load_align2_v2i16
; CHECK:        ldz16 $m[[LD1:[0-9]+]], $m0, $m15, 1
; CHECK-NEXT:   ldz16 $m[[LD2:[0-9]+]], $m0, $m15, 0
; CHECK-NEXT:   sort4x16lo $m0, $m[[LD2]], $m[[LD1]]
; CHECK:        br $m10
define <2 x i16> @load_align2_v2i16(<2 x i16>* %p) {
  %res = load <2 x i16>, <2 x i16>* %p, align 2
  ret <2 x i16> %res
}

; CHECK-LABEL:  load_align1_v2i16
; CHECK:        ldz8 $m[[LD1:[0-9]+]], $m0, $m15, 3
; CHECK-NEXT:   ldz8 $m[[LD2:[0-9]+]], $m0, $m15, 2
; CHECK-NEXT:   shuf8x8lo $m[[SHUF1:[0-9]+]], $m[[LD2]], $m[[LD1]]
; CHECK-NEXT:   ldz8 $m[[LD3:[0-9]+]], $m0, $m15, 1
; CHECK-NEXT:   ldz8 $m[[LD4:[0-9]+]], $m0, $m15, 0
; CHECK-NEXT:   shuf8x8lo $m[[SHUF2:[0-9]+]], $m[[LD4]], $m[[LD3]]
; CHECK-NEXT:   sort4x16lo $m0, $m[[SHUF2]], $m[[SHUF1]]
; CHECK:        br $m10
define <2 x i16> @load_align1_v2i16(<2 x i16>* %p) {
  %res = load <2 x i16>, <2 x i16>* %p, align 1
  ret <2 x i16> %res
}

; CHECK-LABEL:  load_align2_v2f16
; CHECK:        ldb16 $a[[LD1:[0-9]+]], $m0, $m15, 1
; CHECK-NEXT:   ldb16 $a[[LD2:[0-9]+]], $m0, $m15, 0
; CHECK-NEXT:   {
; CHECK-NEXT:     br $m10
; CHECK-NEXT:     sort4x16lo $a0, $a[[LD2]], $a[[LD1]]
; CHECK-NEXT:   }
define <2 x half> @load_align2_v2f16(<2 x half>* %p) {
  %res = load <2 x half>, <2 x half>* %p, align 2
  ret <2 x half> %res
}

; CHECK-LABEL:  load_align1_v2f16
; CHECK:        ldz8 $m[[LD1:[0-9]+]], $m0, $m15, 3
; CHECK-NEXT:   ldz8 $m[[LD2:[0-9]+]], $m0, $m15, 2
; CHECK-NEXT:   shuf8x8lo $m[[SHUF1:[0-9]+]], $m[[LD2]], $m[[LD1]]
; CHECK-NEXT:   ldz8 $m[[LD3:[0-9]+]], $m0, $m15, 1
; CHECK-NEXT:   ldz8 $m[[LD4:[0-9]+]], $m0, $m15, 0
; CHECK-NEXT:   shuf8x8lo $m[[SHUF2:[0-9]+]], $m[[LD4]], $m[[LD3]]
; CHECK-NEXT:   sort4x16lo $m[[SORT1:[0-9]+]], $m[[SHUF2]], $m[[SHUF1]]
; CHECK-NEXT:   st32 $m[[SORT1]], $m11, $m15, 1
; CHECK-NEXT:   ld32 $a0, $m11, $m15, 1
; CHECK-NEXT:   add
; CHECK:        br $m10
define <2 x half> @load_align1_v2f16(<2 x half>* %p) {
  %res = load <2 x half>, <2 x half>* %p, align 1
  ret <2 x half> %res
}

; CHECK-LABEL:  load_align1_i16
; CHECK:        ldz8 $m[[LD1:[0-9]+]], $m0, $m15, 1
; CHECK-NEXT:   ldz8 $m[[LD2:[0-9]+]], $m0, $m15, 0
; CHECK-NEXT:   shuf8x8lo $m0, $m[[LD2]], $m[[LD1]]
; CHECK:        br $m10
define i16 @load_align1_i16(i16* %p) {
  %res = load i16, i16* %p, align 1
  ret i16 %res
}

; CHECK-LABEL:  load_align1_half
; CHECK:        ldz8 $m[[LD1:[0-9]+]], $m0, $m15, 1
; CHECK-NEXT:   ldz8 $m[[LD2:[0-9]+]], $m0, $m15, 0
; CHECK-NEXT:   shuf8x8lo $m[[SHUF1:[0-9]+]], $m[[LD2]], $m[[LD1]]
; CHECK-NEXT:   st32 $m[[SHUF1]], $m11, $m15, 1
; CHECK-NEXT:   ld32 $a0, $m11, $m15, 1
; CHECK-NEXT:   add
; CHECK:        br $m10
define half @load_align1_half(half* %p) {
  %res = load half, half* %p, align 1
  ret half %res
}
