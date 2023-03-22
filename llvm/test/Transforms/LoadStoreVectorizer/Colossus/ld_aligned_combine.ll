; REQUIRES: colossus-registered-target
; RUN: opt -mtriple=colossus-graphcore-elf --colossus-load-store-vectorizer < %s \
; RUN: | llc -o - | FileCheck %s

; CHECK-LABEL: add_8_8:
; CHECK:      ld32 $a0, $m0, $m15, 0
; CHECK-NEXT: ld32 $a1, $m0, $m15, 1
; CHECK-NEXT: {
; CHECK-NEXT:   br $m10
; CHECK-NEXT:   f32add $a0, $a0, $a1
; CHECK-NEXT: }
define dso_local float @add_8_8(float* nocapture readonly %0) {
  %2 = load float, float* %0, align 8
  %3 = getelementptr inbounds float, float* %0, i32 1
  %4 = load float, float* %3, align 8
  %5 = fadd float %2, %4
  ret float %5
}

; CHECK-LABEL: add_8_4:
; CHECK:      ld64 $a0:1, $m0, $m15, 0
; CHECK-NEXT: {
; CHECK-NEXT:   br $m10
; CHECK-NEXT:   f32add $a0, $a0, $a1
; CHECK-NEXT: }
define dso_local float @add_8_4(float* nocapture readonly %0) {
  %2 = load float, float* %0, align 8
  %3 = getelementptr inbounds float, float* %0, i32 1
  %4 = load float, float* %3, align 4
  %5 = fadd float %2, %4
  ret float %5
}

; CHECK-LABEL: add_4_4:
; CHECK:      ld32 $a0, $m0, $m15, 0
; CHECK-NEXT: ld32 $a1, $m0, $m15, 1
; CHECK-NEXT: {
; CHECK-NEXT:   br $m10
; CHECK-NEXT:   f32add $a0, $a0, $a1
; CHECK-NEXT: }
define dso_local float @add_4_4(float* nocapture readonly %0) {
  %2 = load float, float* %0, align 4
  %3 = getelementptr inbounds float, float* %0, i32 1
  %4 = load float, float* %3, align 4
  %5 = fadd float %2, %4
  ret float %5
}

; CHECK-LABEL: add_4_8:
; CHECK:      ld32 $a0, $m0, $m15, 0
; CHECK-NEXT: ld32 $a1, $m0, $m15, 1
; CHECK-NEXT: {
; CHECK-NEXT:   br $m10
; CHECK-NEXT:   f32add $a0, $a0, $a1
; CHECK-NEXT: }
define dso_local float @add_4_8(float* nocapture readonly %0) {
  %2 = load float, float* %0, align 4
  %3 = getelementptr inbounds float, float* %0, i32 1
  %4 = load float, float* %3, align 8
  %5 = fadd float %2, %4
  ret float %5
}

; CHECK-LABEL: add_8_2_4:
; CHECK:      ldb16 $a0, $m0, $m15, 3
; CHECK-NEXT: ldb16 $a1, $m0, $m15, 2
; CHECK-NEXT: {
; CHECK-NEXT:   ld32 $a1, $m0, $m15, 0
; CHECK-NEXT:   sort4x16lo $a0, $a1, $a0
; CHECK-NEXT: }
; CHECK-NEXT: {
; CHECK-NEXT:   ld32 $a2, $m0, $m15, 2
; CHECK-NEXT:   f32add $a0, $a1, $a0
; CHECK-NEXT: }
; CHECK-NEXT: {
; CHECK-NEXT:   br $m10
; CHECK-NEXT:   f32add $a0, $a0, $a2
; CHECK-NEXT: }
define dso_local float @add_8_2_4(float* nocapture readonly %0) {
  %2 = load float, float* %0, align 8
  %3 = getelementptr inbounds float, float* %0, i32 1
  %4 = load float, float* %3, align 2
  %5 = getelementptr inbounds float, float* %0, i32 2
  %6 = load float, float* %5, align 4
  %7 = fadd float %2, %4
  %8 = fadd float %7, %6
  ret float %8
}

; CHECK-LABEL: add_8_4_2:
; CHECK:      ld64 $a0:1, $m0, $m15, 0
; CHECK-NEXT: {
; CHECK-NEXT:   ldb16 $a1, $m0, $m15, 5
; CHECK-NEXT:   f32add $a0, $a0, $a1
; CHECK-NEXT: }
; CHECK-NEXT: ldb16 $a2, $m0, $m15, 4
; CHECK-NEXT: sort4x16lo $a1, $a2, $a1
; CHECK-NEXT: {
; CHECK-NEXT:   br $m10
; CHECK-NEXT:   f32add $a0, $a0, $a1
; CHECK-NEXT: }
define dso_local float @add_8_4_2(float* nocapture readonly %0) {
  %2 = load float, float* %0, align 8
  %3 = getelementptr inbounds float, float* %0, i32 1
  %4 = load float, float* %3, align 4
  %5 = getelementptr inbounds float, float* %0, i32 2
  %6 = load float, float* %5, align 2
  %7 = fadd float %2, %4
  %8 = fadd float %7, %6
  ret float %8
}

; CHECK-LABEL: add_2_8_4:
; CHECK:      ldb16 $a0, $m0, $m15, 1
; CHECK-NEXT: ldb16 $a1, $m0, $m15, 0
; CHECK-NEXT: {
; CHECK-NEXT:   setzi $m1, 4
; CHECK-NEXT:   sort4x16lo $a0, $a1, $a0
; CHECK-NEXT: }
; CHECK-NEXT: ld64 $a2:3, $m0, $m1, 0
; CHECK-NEXT: f32add $a0, $a0, $a2
; CHECK-NEXT: {
; CHECK-NEXT:   br $m10
; CHECK-NEXT:   f32add $a0, $a0, $a3
; CHECK-NEXT: }
define dso_local float @add_2_8_4(float* nocapture readonly %0) {
  %2 = load float, float* %0, align 2
  %3 = getelementptr inbounds float, float* %0, i32 1
  %4 = load float, float* %3, align 8
  %5 = getelementptr inbounds float, float* %0, i32 2
  %6 = load float, float* %5, align 4
  %7 = fadd float %2, %4
  %8 = fadd float %7, %6
  ret float %8
}

; CHECK-LABEL: add_8_4_8_4:
; CHECK:      ld64 $a0:1, $m0, $m15, 0
; CHECK-NEXT: {
; CHECK-NEXT:   ld64 $a2:3, $m0, $m15, 1
; CHECK-NEXT:   f32add $a0, $a0, $a1
; CHECK-NEXT: }
; CHECK-NEXT: f32add $a1, $a2, $a3
; CHECK-NEXT: {
; CHECK-NEXT:   br $m10
; CHECK-NEXT:   f32add $a0, $a0, $a1
; CHECK-NEXT: }
define dso_local float @add_8_4_8_4(float* nocapture readonly %0) {
  %2 = load float, float* %0, align 8
  %3 = getelementptr inbounds float, float* %0, i32 1
  %4 = load float, float* %3, align 4
  %5 = getelementptr inbounds float, float* %0, i32 2
  %6 = load float, float* %5, align 8
  %7 = getelementptr inbounds float, float* %0, i32 3
  %8 = load float, float* %7, align 4
  %9 = fadd float %2, %4
  %10 = fadd float %6, %8
  %11 = fadd float %9, %10
  ret float %11
}

; -----------------------------------------------------------------------------

; CHECK-LABEL: half_add_4_4:
; CHECK:       # %bb.0:
; CHECK-NEXT:  ldb16 $a0, $m0, $m15, 1
; CHECK-NEXT:  ldb16 $a1, $m0, $m15, 0
; CHECK-NEXT:  {
; CHECK-NEXT:    br $m10
; CHECK-NEXT:    f16v2add $a0, $a1, $a0
; CHECK-NEXT:  }

define dso_local half @half_add_4_4(half* nocapture readonly %0) {
  %2 = load half, half* %0, align 4
  %3 = getelementptr inbounds half, half* %0, i32 1
  %4 = load half, half* %3, align 4
  %5 = fadd half %2, %4
  ret half %5
}

; CHECK-LABEL: half_add_4_2:
; CHECK:       # %bb.0:
; CHECK-NEXT:  ldb16 $a0, $m0, $m15, 1
; CHECK-NEXT:  ldb16 $a1, $m0, $m15, 0
; CHECK-NEXT:  {
; CHECK-NEXT:    br $m10
; CHECK-NEXT:    f16v2add $a0, $a1, $a0
; CHECK-NEXT:  }

define dso_local half @half_add_4_2(half* nocapture readonly %0) {
  %2 = load half, half* %0, align 4
  %3 = getelementptr inbounds half, half* %0, i32 1
  %4 = load half, half* %3, align 2
  %5 = fadd half %2, %4
  ret half %5
}

; CHECK-LABEL: half_add_2_2:
; CHECK:       # %bb.0:
; CHECK-NEXT:  ldb16 $a0, $m0, $m15, 1
; CHECK-NEXT:  ldb16 $a1, $m0, $m15, 0
; CHECK-NEXT:  {
; CHECK-NEXT:    br $m10
; CHECK-NEXT:    f16v2add $a0, $a1, $a0
; CHECK-NEXT:  }

define dso_local half @half_add_2_2(half* nocapture readonly %0) {
  %2 = load half, half* %0, align 2
  %3 = getelementptr inbounds half, half* %0, i32 1
  %4 = load half, half* %3, align 2
  %5 = fadd half %2, %4
  ret half %5
}

; CHECK-LABEL: half_add_2_4:
; CHECK:       # %bb.0:
; CHECK-NEXT:  ldb16 $a0, $m0, $m15, 1
; CHECK-NEXT:  ldb16 $a1, $m0, $m15, 0
; CHECK-NEXT:  {
; CHECK-NEXT:    br $m10
; CHECK-NEXT:    f16v2add $a0, $a1, $a0
; CHECK-NEXT:  }

define dso_local half @half_add_2_4(half* nocapture readonly %0) {
  %2 = load half, half* %0, align 2
  %3 = getelementptr inbounds half, half* %0, i32 1
  %4 = load half, half* %3, align 4
  %5 = fadd half %2, %4
  ret half %5
}

; CHECK-LABEL: half_add_4_1_2:
; CHECK:       ldz8 $m1, $m0, $m15, 3
; CHECK-NEXT:  ldz8 $m2, $m0, $m15, 2
; CHECK-NEXT:  shuf8x8lo $m1, $m2, $m1
; CHECK-NEXT:  ldb16 $a0, $m0, $m15, 0
; CHECK-NEXT:  st32 $m1, $m11, $m15, 1
; CHECK-NEXT:  ld32 $a1, $m11, $m15, 1
; CHECK-NEXT:  {
; CHECK-NEXT:    ldb16 $a1, $m0, $m15, 2
; CHECK-NEXT:    f16v2add $a0, $a1:BL, $a0
; CHECK-NEXT:  }
; CHECK-NEXT:  {
; CHECK-NEXT:    add $m11, $m11, 8
; CHECK-NEXT:    f16v2add $a0, $a0:BL, $a1
; CHECK-NEXT:  }

define dso_local half @half_add_4_1_2(half* nocapture readonly %0) {
  %2 = load half, half* %0, align 4
  %3 = getelementptr inbounds half, half* %0, i32 1
  %4 = load half, half* %3, align 1
  %5 = getelementptr inbounds half, half* %0, i32 2
  %6 = load half, half* %5, align 2
  %7 = fadd half %2, %4
  %8 = fadd half %7, %6
  ret half %8
}

; CHECK-LABEL: half_add_4_2_1:
; CHECK:       ldz8 $m1, $m0, $m15, 5
; CHECK-NEXT:  ldz8 $m2, $m0, $m15, 4
; CHECK-NEXT:  shuf8x8lo $m1, $m2, $m1
; CHECK-NEXT:  ldb16 $a0, $m0, $m15, 1
; CHECK-NEXT:  ldb16 $a1, $m0, $m15, 0
; CHECK-NEXT:  {
; CHECK-NEXT:    st32 $m1, $m11, $m15, 1
; CHECK-NEXT:    f16v2add $a0, $a1, $a0
; CHECK-NEXT:  }
; CHECK-NEXT:  ld32 $a1, $m11, $m15, 1
; CHECK-NEXT:  sort4x16lo $a1, $a1, $a1
; CHECK-NEXT:  {
; CHECK-NEXT:    add $m11, $m11, 8
; CHECK-NEXT:    f16v2add $a0, $a0:BL, $a1
; CHECK-NEXT:  }

define dso_local half @half_add_4_2_1(half* nocapture readonly %0) {
  %2 = load half, half* %0, align 4
  %3 = getelementptr inbounds half, half* %0, i32 1
  %4 = load half, half* %3, align 2
  %5 = getelementptr inbounds half, half* %0, i32 2
  %6 = load half, half* %5, align 1
  %7 = fadd half %2, %4
  %8 = fadd half %7, %6
  ret half %8
}

; CHECK-LABEL: half_add_1_4_2:
; CHECK:       ldz8 $m1, $m0, $m15, 1
; CHECK-NEXT:  ldz8 $m2, $m0, $m15, 0
; CHECK-NEXT:  shuf8x8lo $m1, $m2, $m1
; CHECK-NEXT:  ldb16 $a0, $m0, $m15, 1
; CHECK-NEXT:  st32 $m1, $m11, $m15, 1
; CHECK-NEXT:  ld32 $a1, $m11, $m15, 1
; CHECK-NEXT:  {
; CHECK-NEXT:    ldb16 $a1, $m0, $m15, 2
; CHECK-NEXT:    f16v2add $a0, $a1:BL, $a0
; CHECK-NEXT:  }
; CHECK-NEXT:  {
; CHECK-NEXT:    add $m11, $m11, 8
; CHECK-NEXT:    f16v2add $a0, $a0:BL, $a1
; CHECK-NEXT:  }

define dso_local half @half_add_1_4_2(half* nocapture readonly %0) {
  %2 = load half, half* %0, align 1
  %3 = getelementptr inbounds half, half* %0, i32 1
  %4 = load half, half* %3, align 4
  %5 = getelementptr inbounds half, half* %0, i32 2
  %6 = load half, half* %5, align 2
  %7 = fadd half %2, %4
  %8 = fadd half %7, %6
  ret half %8
}

; CHECK-LABEL: half_add_4_2_4_2:
; CHECK:       # %bb.0:
; CHECK-NEXT:  ldb16 $a0, $m0, $m15, 3
; CHECK-NEXT:  ldb16 $a1, $m0, $m15, 2
; CHECK-NEXT:  {
; CHECK-NEXT:    ldb16 $a1, $m0, $m15, 1
; CHECK-NEXT:    f16v2add $a0, $a1, $a0
; CHECK-NEXT:  }
; CHECK-NEXT:  ldb16 $a2, $m0, $m15, 0
; CHECK-NEXT:  f16v2add $a1, $a2, $a1
; CHECK-NEXT:  sort4x16lo $a0, $a0, $a0
; CHECK-NEXT:  {
; CHECK-NEXT:    br $m10
; CHECK-NEXT:    f16v2add $a0, $a1:BL, $a0
; CHECK-NEXT:  }

define dso_local half @half_add_4_2_4_2(half* nocapture readonly %0) {
  %2 = load half, half* %0, align 4
  %3 = getelementptr inbounds half, half* %0, i32 1
  %4 = load half, half* %3, align 2
  %5 = getelementptr inbounds half, half* %0, i32 2
  %6 = load half, half* %5, align 4
  %7 = getelementptr inbounds half, half* %0, i32 3
  %8 = load half, half* %7, align 2
  %9 = fadd half %2, %4
  %10 = fadd half %6, %8
  %11 = fadd half %9, %10
  ret half %11
}
