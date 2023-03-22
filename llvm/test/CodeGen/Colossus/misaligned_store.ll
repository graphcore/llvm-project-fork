; RUN: llc < %s -march=colossus -mattr=+ipu1 | FileCheck %s --check-prefixes=CHECK,WORKER
; RUN: llc < %s -march=colossus -mattr=+ipu2 | FileCheck %s --check-prefixes=CHECK,WORKER
; RUN: llc < %s -march=colossus -mattr=+supervisor,+ipu1 | FileCheck %s --check-prefixes=CHECK,SUPERVISOR
; RUN: llc < %s -march=colossus -mattr=+supervisor,+ipu2 | FileCheck %s --check-prefixes=CHECK,SUPERVISOR

; CHECK-LABEL: store_align4_v2i32:
; CHECK-DAG:   st32 $m2, $m0, $m15, 0
; CHECK-DAG:   st32 $m3, $m0, $m15, 1
; CHECK:       br $m10
define void @store_align4_v2i32(<2 x i32>* %p, <2 x i32> %v) {
  store <2 x i32> %v, <2 x i32>* %p, align 4
  ret void
}

; CHECK-LABEL: store_align4_v4i16:
; CHECK-DAG:   st32 $m2, $m0, $m15, 0
; CHECK-DAG:   st32 $m3, $m0, $m15, 1
; CHECK:       br $m10
define void @store_align4_v4i16(<4 x i16>* %p, <4 x i16> %v) {
  store <4 x i16> %v, <4 x i16>* %p, align 4
  ret void
}

; CHECK-LABEL: store_align2_v2i32:
; CHECK:       add $m11, $m11, -16
; CHECK:       st32 $m10, $m11, $m15, [[LRSpill:[0-1]+]]
; CHECK:       st32
; CHECK:       mov
; CHECK:       st32
; CHECK:       st32
; CHECK:       ld32
; CHECK:       add
; SUPERVISOR:  call $m10, __supervisor_st32_align2
; WORKER:      call $m10, __st32_align2
; CHECK:       ld32
; CHECK:       mov
; WORKER:      call $m10, __st32_align2
; SUPERVISOR:  call $m10, __supervisor_st32_align2
; CHECK:       ld32
; CHECK:       ld32 $m10, $m11, $m15, [[LRSpill]]
; CHECK:       add $m11, $m11, 16
; CHECK:       br $m10
define void @store_align2_v2i32(<2 x i32>* %p, <2 x i32> %v) {
  store <2 x i32> %v, <2 x i32>* %p, align 2
  ret void
}

; CHECK-LABEL: store_align2_v4i16:
; CHECK:       add $m11, $m11, -16
; CHECK:       st32 $m10, $m11, $m15, [[LRSpill:[0-1]+]]
; CHECK:       st32
; CHECK:       mov
; CHECK:       st32
; CHECK:       st32
; CHECK:       ld32
; CHECK:       add
; WORKER:      call $m10, __st32_align2
; SUPERVISOR:  call $m10, __supervisor_st32_align2
; CHECK:       ld32
; CHECK:       mov
; WORKER:      call $m10, __st32_align2
; SUPERVISOR:  call $m10, __supervisor_st32_align2
; CHECK:       ld32
; CHECK:       ld32 $m10, $m11, $m15, [[LRSpill]]
; CHECK:       add $m11, $m11, 16
; CHECK:       br $m10
define void @store_align2_v4i16(<4 x i16>* %p, <4 x i16> %v) {
  store <4 x i16> %v, <4 x i16>* %p, align 2
  ret void
}

; CHECK-LABEL: store_align1_v2i32:
; CHECK:       add $m11, $m11, -16
; CHECK:       st32 $m10, $m11, $m15, [[LRSpill:[0-1]+]]
; CHECK:       st32
; CHECK:       mov
; CHECK:       st32
; CHECK:       st32
; CHECK:       ld32
; CHECK:       add
; WORKER:      call $m10, __st32_align1
; SUPERVISOR:  call $m10, __supervisor_st32_align1
; CHECK:       ld32
; CHECK:       mov
; WORKER:      call $m10, __st32_align1
; SUPERVISOR:  call $m10, __supervisor_st32_align1
; CHECK:       ld32
; CHECK:       ld32 $m10, $m11, $m15, [[LRSpill]]
; CHECK:       add $m11, $m11, 16
; CHECK:       br $m10
define void @store_align1_v2i32(<2 x i32>* %p, <2 x i32> %v) {
  store <2 x i32> %v, <2 x i32>* %p, align 1
  ret void
}

; CHECK-LABEL: store_align1_v4i16
; CHECK:       add $m11, $m11, -16
; CHECK:       st32 $m10, $m11, $m15, [[LRSpill:[0-1]+]]
; CHECK:       st32
; CHECK:       mov
; CHECK:       st32
; CHECK:       st32
; CHECK:       ld32
; CHECK:       add
; WORKER:      call $m10, __st32_align1
; SUPERVISOR:  call $m10, __supervisor_st32_align1
; CHECK:       ld32
; CHECK:       mov
; WORKER:      call $m10, __st32_align1
; SUPERVISOR:  call $m10, __supervisor_st32_align1
; CHECK:       ld32
; CHECK:       ld32 $m10, $m11, $m15, [[LRSpill]]
; CHECK:       add $m11, $m11, 16
; CHECK:       br $m10
define void @store_align1_v4i16(<4 x i16>* %p, <4 x i16> %v) {
  store <4 x i16> %v, <4 x i16>* %p, align 1
  ret void
}

; 32 bit misaligned stores have corresponding runtime functions

; CHECK-LABEL: store_align2_i32:
; CHECK:       # %bb
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m10, $m11, $m15, [[LRSpill:[0-1]+]]
; WORKER-NEXT: call $m10, __st32_align2
; SUPERVISOR:  call $m10, __supervisor_st32_align2
; CHECK-NEXT:  ld32 $m10, $m11, $m15, [[LRSpill]]
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10  
define void @store_align2_i32(i32* %p, i32 %v) {
  store i32 %v, i32* %p, align 2
  ret void
}

; CHECK-LABEL: store_align2_v2i16:
; CHECK:       # %bb
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m10, $m11, $m15, [[LRSpill:[0-1]+]]
; WORKER-NEXT:  call $m10, __st32_align2
; SUPERVISOR:  call $m10, __supervisor_st32_align2
; CHECK-NEXT:  ld32 $m10, $m11, $m15, [[LRSpill]]
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10  
define void @store_align2_v2i16(<2 x i16>* %p, <2 x i16> %v) {
  store <2 x i16> %v, <2 x i16>* %p, align 2
  ret void
}

; CHECK-LABEL: store_align1_i32:
; CHECK:       # %bb
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m10, $m11, $m15, [[LRSpill:[0-1]+]]
; WORKER-NEXT: call $m10, __st32_align1
; SUPERVISOR:  call $m10, __supervisor_st32_align1
; CHECK-NEXT:  ld32 $m10, $m11, $m15, [[LRSpill]]
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10  
define void @store_align1_i32(i32* %p, i32 %v) {
  store i32 %v, i32* %p, align 1
  ret void
}

; CHECK-LABEL: store_align1_v2i16:
; CHECK:       # %bb
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m10, $m11, $m15, [[LRSpill:[0-1]+]]
; WORKER-NEXT: call $m10, __st32_align1
; SUPERVISOR:  call $m10, __supervisor_st32_align1
; CHECK-NEXT:  ld32 $m10, $m11, $m15, [[LRSpill]]
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10  
define void @store_align1_v2i16(<2 x i16>* %p, <2 x i16> %v) {
  store <2 x i16> %v, <2 x i16>* %p, align 1
  ret void
}


; CHECK-LABEL: store_align1_i16:
; CHECK:       # %bb
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m10, $m11, $m15, [[LRSpill:[0-1]+]]
; WORKER-NEXT: call $m10, __st16_misaligned
; SUPERVISOR:  call $m10, __supervisor_st16_misaligned
; CHECK-NEXT:  ld32 $m10, $m11, $m15, [[LRSpill]]
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10  
define void @store_align1_i16(i16* %p, i16 %v) {
  store i16 %v, i16* %p, align 1
  ret void
}
