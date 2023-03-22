; RUN: llc < %s -march=colossus -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -march=colossus -mattr=+ipu2 | FileCheck %s

; CHECK-LABEL: store_align4_v2f32:
; CHECK-DAG:   st32 $a0, $m0, $m15, 0
; CHECK-DAG:   st32 $a1, $m0, $m15, 1
; CHECK:       br $m10
define void @store_align4_v2f32(<2 x float>* %p, <2 x float> %v) {
  store <2 x float> %v, <2 x float>* %p, align 4
  ret void
}

; CHECK-LABEL: store_align4_v4f16:
; CHECK-DAG:   st32 $a0, $m0, $m15, 0
; CHECK-DAG:   st32 $a1, $m0, $m15, 1
; CHECK:       br $m10
define void @store_align4_v4f16(<4 x half>* %p, <4 x half> %v) {
  store <4 x half> %v, <4 x half>* %p, align 4
  ret void
}

; 64 bit misaligned stores are lowered by generic code to an aligned
; store to the stack (of the 64 bit value) followed by 32 bit integer
; loads followed by 32 bit stores with the initial alignment
; This is functional but not optimal

; CHECK-LABEL: store_align2_v2f32:
; CHECK:       add $m11, $m11, -16
; CHECK:       st32 $m10, $m11, $m15, [[LRSpill:[0-1]+]]
; CHECK:       st32
; CHECK:       mov
; CHECK:       st64
; CHECK:       ld32
; CHECK:       add
; CHECK:       call $m10, __st32_align2
; CHECK:       ld32
; CHECK:       mov
; CHECK:       call $m10, __st32_align2
; CHECK:       ld32
; CHECK:       ld32 $m10, $m11, $m15, [[LRSpill]]
; CHECK:       add $m11, $m11, 16
; CHECK:       br $m10
define void @store_align2_v2f32(<2 x float>* %p, <2 x float> %v) {
  store <2 x float> %v, <2 x float>* %p, align 2
  ret void
}

; CHECK-LABEL: store_align2_v4f16:
; CHECK:       add $m11, $m11, -16
; CHECK:       st32 $m10, $m11, $m15, [[LRSpill:[0-1]+]]
; CHECK:       st32
; CHECK:       mov
; CHECK:       st64
; CHECK:       ld32
; CHECK:       add
; CHECK:       call $m10, __st32_align2
; CHECK:       ld32
; CHECK:       mov
; CHECK:       call $m10, __st32_align2
; CHECK:       ld32
; CHECK:       ld32 $m10, $m11, $m15, [[LRSpill]]
; CHECK:       add $m11, $m11, 16
; CHECK:       br $m10
define void @store_align2_v4f16(<4 x half>* %p, <4 x half> %v) {
  store <4 x half> %v, <4 x half>* %p, align 2
  ret void
}

; CHECK-LABEL: store_align1_v2f32:
; CHECK:       add $m11, $m11, -16
; CHECK:       st32 $m10, $m11, $m15, [[LRSpill:[0-1]+]]
; CHECK:       st32
; CHECK:       mov
; CHECK:       st64
; CHECK:       ld32
; CHECK:       add
; CHECK:       call $m10, __st32_align1
; CHECK:       ld32
; CHECK:       mov
; CHECK:       call $m10, __st32_align1
; CHECK:       ld32
; CHECK:       ld32 $m10, $m11, $m15, [[LRSpill]]
; CHECK:       add $m11, $m11, 16
; CHECK:       br $m10
define void @store_align1_v2f32(<2 x float>* %p, <2 x float> %v) {
  store <2 x float> %v, <2 x float>* %p, align 1
  ret void
}

; CHECK-LABEL: store_align1_v4f16:
; CHECK:       add $m11, $m11, -16
; CHECK:       st32 $m10, $m11, $m15, [[LRSpill:[0-1]+]]
; CHECK:       st32
; CHECK:       mov
; CHECK:       st64
; CHECK:       ld32
; CHECK:       add
; CHECK:       call $m10, __st32_align1
; CHECK:       ld32
; CHECK:       mov
; CHECK:       call $m10, __st32_align1
; CHECK:       ld32
; CHECK:       ld32 $m10, $m11, $m15, [[LRSpill]]
; CHECK:       add $m11, $m11, 16
; CHECK:       br $m10
define void @store_align1_v4f16(<4 x half>* %p, <4 x half> %v) {
  store <4 x half> %v, <4 x half>* %p, align 1
  ret void
}

; 32 bit misaligned stores have corresponding runtime functions

; CHECK-LABEL: store_align2_f32:
; CHECK:       # %bb
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m10, $m11, $m15, [[LRSpill:[0-1]+]]
; CHECK-NEXT:  call $m10, __st32f_align2
; CHECK-NEXT:  ld32 $m10, $m11, $m15, [[LRSpill]]
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10  
define void @store_align2_f32(float* %p, float %v) {
  store float %v, float* %p, align 2
  ret void
}

; CHECK-LABEL: store_align2_v2f16:
; CHECK:       # %bb
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m10, $m11, $m15, [[LRSpill:[0-1]+]]
; CHECK-NEXT:  call $m10, __st32f_align2
; CHECK-NEXT:  ld32 $m10, $m11, $m15, [[LRSpill]]
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10  
define void @store_align2_v2f16(<2 x half>* %p, <2 x half> %v) {
  store <2 x half> %v, <2 x half>* %p, align 2
  ret void
}

; CHECK-LABEL: store_align1_f32:
; CHECK:       # %bb
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m10, $m11, $m15, [[LRSpill:[0-1]+]]
; CHECK-NEXT:  call $m10, __st32f_align1
; CHECK-NEXT:  ld32 $m10, $m11, $m15, [[LRSpill]]
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10  
define void @store_align1_f32(float* %p, float %v) {
  store float %v, float* %p, align 1
  ret void
}

; CHECK-LABEL: store_align1_v2f16:
; CHECK:       # %bb
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m10, $m11, $m15, [[LRSpill:[0-1]+]]
; CHECK-NEXT:  call $m10, __st32f_align1
; CHECK-NEXT:  ld32 $m10, $m11, $m15, [[LRSpill]]
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10  
define void @store_align1_v2f16(<2 x half>* %p, <2 x half> %v) {
  store <2 x half> %v, <2 x half>* %p, align 1
  ret void
}

; CHECK-LABEL: store_align1_f16:
; CHECK:       # %bb
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m10, $m11, $m15, [[LRSpill:[0-1]+]]
; CHECK-NEXT:  call $m10, __st16f_misaligned
; CHECK-NEXT:  ld32 $m10, $m11, $m15, [[LRSpill]]
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10  
define void @store_align1_f16(half* %p, half %v) {
  store half %v, half* %p, align 1
  ret void
}
