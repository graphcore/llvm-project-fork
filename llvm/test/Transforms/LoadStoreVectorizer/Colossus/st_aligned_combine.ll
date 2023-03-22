; REQUIRES: colossus-registered-target
; RUN: opt -mtriple=colossus-graphcore-elf --colossus-load-store-vectorizer < %s \
; RUN: | llc -o - | FileCheck %s

; CHECK-LABEL: st_8_8:
; CHECK: st32 $a0, $m0, $m15, 0
; CHECK-NEXT: st32 $a1, $m0, $m15, 1
define dso_local void @st_8_8(float* nocapture %0, float %1, float %2) {
  store float %1, float* %0, align 8
  %4 = getelementptr inbounds float, float* %0, i32 1
  store float %2, float* %4, align 8
  ret void
}

; CHECK-LABEL: st_8_4:
; CHECK: st64 $a0:1, $m0, $m15, 0
define dso_local void @st_8_4(float* nocapture %0, float %1, float %2) {
  store float %1, float* %0, align 8
  %4 = getelementptr inbounds float, float* %0, i32 1
  store float %2, float* %4, align 4
  ret void
}

; CHECK-LABEL: st_4_4:
; CHECK: st32 $a0, $m0, $m15, 0
; CHECK-NEXT: st32 $a1, $m0, $m15, 1
define dso_local void @st_4_4(float* nocapture %0, float %1, float %2) {
  store float %1, float* %0, align 4
  %4 = getelementptr inbounds float, float* %0, i32 1
  store float %2, float* %4, align 4
  ret void
}

; CHECK-LABEL: st_4_8:
; CHECK: st32 $a0, $m0, $m15, 0
; CHECK-NEXT: st32 $a1, $m0, $m15, 1
define dso_local void @st_4_8(float* nocapture %0, float %1, float %2) {
  store float %1, float* %0, align 4
  %4 = getelementptr inbounds float, float* %0, i32 1
  store float %2, float* %4, align 8
  ret void
}

; -----------------------------------------------------------------------------

; CHECK-LABEL: half_st_4_4:
; CHECK:       call $m10, __st16f
; CHECK:       call $m10, __st16f

define dso_local void @half_st_4_4(half* nocapture %0, half %1, half %2) {
  store half %1, half* %0, align 4
  %4 = getelementptr inbounds half, half* %0, i32 1
  store half %2, half* %4, align 4
  ret void
}

; CHECK-LABEL: half_st_4_2:
; CHECK:       # %bb.0:
; CHECK-NEXT:  sort4x16lo $a0, $a0, $a1
; CHECK-NEXT:  st32 $a0, $m0, $m15, 0
; CHECK-NEXT:  br $m10

define dso_local void @half_st_4_2(half* nocapture %0, half %1, half %2) {
  store half %1, half* %0, align 4
  %4 = getelementptr inbounds half, half* %0, i32 1
  store half %2, half* %4, align 2
  ret void
}

; CHECK-LABEL: half_st_2_2:
; CHECK:       call $m10, __st16f
; CHECK:       call $m10, __st16f

define dso_local void @half_st_2_2(half* nocapture %0, half %1, half %2) {
  store half %1, half* %0, align 2
  %4 = getelementptr inbounds half, half* %0, i32 1
  store half %2, half* %4, align 2
  ret void
}

; CHECK-LABEL: half_st_2_4:
; CHECK:       call $m10, __st16f
; CHECK:       call $m10, __st16f

define dso_local void @half_st_2_4(half* nocapture %0, half %1, half %2) {
  store half %1, half* %0, align 2
  %4 = getelementptr inbounds half, half* %0, i32 1
  store half %2, half* %4, align 4
  ret void
}
