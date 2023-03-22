; RUN: opt -slp-vectorizer -mattr=+ipu1 < %s -o - | llc -mattr=+ipu1 -o - | FileCheck %s
; RUN: opt -slp-vectorizer -mattr=+ipu2 < %s -o - | llc -mattr=+ipu2 -o - | FileCheck %s
target triple = "colossus-graphcore--elf"

; CHECK-LABEL: no_memory_slp:
; CHECK:       # %bb
; CHECK-DAG:   sort4x16lo [[REGX:\$a[0-9]+]], $a0, $a1
; CHECK-DAG:   sort4x16lo [[REGY:\$a[0-9]+]], $a2, $a3
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2mul $a0, [[REGX]], [[REGY]]
; CHECK-NEXT:  }
define <2 x half> @no_memory_slp(half %x0, half %x1, half %y0, half %y1) {
  %xt = insertelement <2 x half> undef, half %x0, i32 0
  %x = insertelement <2 x half> %xt, half %x1, i32 1
  %yt = insertelement <2 x half> undef, half %y0, i32 0
  %y = insertelement <2 x half> %yt, half %y1, i32 1
  %r = fmul <2 x half> %x, %y
  ret <2 x half> %r
}

; CHECK-LABEL: slp_mul_v2f16:
; CHECK:       # %bb
; CHECK-DAG:   ld32 [[REGX:\$a[0-9]+]], $m0, $m15, 0
; CHECK-DAG:   ld32 [[REGY:\$a[0-9]+]], $m1, $m15, 0
; CHECK-NEXT:  f16v2mul [[REGZ:\$a[0-9]+]], [[REGX]], [[REGY]]
; CHECK-NEXT:  st32 [[REGZ:\$a[0-9]+]], $m2, $m15, 0
; CHECK-NEXT:  br $m10
define void @slp_mul_v2f16(half* align 4 %x,
                           half* align 4 %y,
                           half* noalias align 4 %z) {
entry:
  %0 = load half, half* %x, align 8
  %1 = load half, half* %y, align 8
  %mul = fmul half %0, %1
  store half %mul, half* %z, align 8
  %arrayidx3 = getelementptr inbounds half, half* %x, i32 1
  %2 = load half, half* %arrayidx3, align 2
  %arrayidx4 = getelementptr inbounds half, half* %y, i32 1
  %3 = load half, half* %arrayidx4, align 2
  %mul5 = fmul half %2, %3
  %arrayidx6 = getelementptr inbounds half, half* %z, i32 1
  store half %mul5, half* %arrayidx6, align 2
  ret void
}

; CHECK-LABEL: slp_mul_v4f16:
; CHECK:       # %bb
; CHECK-DAG:   ld64 [[REGX:\$a[0-9]+]]:{{[0-9]+}}, $m0, $m15, 0
; CHECK-DAG:   ld64 [[REGY:\$a[0-9]+]]:{{[0-9]+}}, $m1, $m15, 0
; CHECK-NEXT:  f16v4mul [[REGZ:\$a[0-9]+]]:{{[0-9]+}}, [[REGX]]:{{[0-9]+}}, [[REGY]]:{{[0-9]+}}
; CHECK-NEXT:  st64 [[REGZ:\$a[0-9]+]]:{{[0-9]+}}, $m2, $m15, 0
; CHECK-NEXT:  br $m10
define void @slp_mul_v4f16(half* align 8 %x,
                           half* align 8 %y,
                           half* noalias align 8 %z) {
entry:
  %0 = load half, half* %x, align 8
  %1 = load half, half* %y, align 8
  %mul = fmul half %0, %1
  store half %mul, half* %z, align 8
  %arrayidx3 = getelementptr inbounds half, half* %x, i32 1
  %2 = load half, half* %arrayidx3, align 2
  %arrayidx4 = getelementptr inbounds half, half* %y, i32 1
  %3 = load half, half* %arrayidx4, align 2
  %mul5 = fmul half %2, %3
  %arrayidx6 = getelementptr inbounds half, half* %z, i32 1
  store half %mul5, half* %arrayidx6, align 2
  %arrayidx7 = getelementptr inbounds half, half* %x, i32 2
  %4 = load half, half* %arrayidx7, align 4
  %arrayidx8 = getelementptr inbounds half, half* %y, i32 2
  %5 = load half, half* %arrayidx8, align 4
  %mul9 = fmul half %4, %5
  %arrayidx10 = getelementptr inbounds half, half* %z, i32 2
  store half %mul9, half* %arrayidx10, align 4
  %arrayidx11 = getelementptr inbounds half, half* %x, i32 3
  %6 = load half, half* %arrayidx11, align 2
  %arrayidx12 = getelementptr inbounds half, half* %y, i32 3
  %7 = load half, half* %arrayidx12, align 2
  %mul13 = fmul half %6, %7
  %arrayidx14 = getelementptr inbounds half, half* %z, i32 3
  store half %mul13, half* %arrayidx14, align 2
  ret void
}
; CHECK-LABEL: slp_and_v2i16:
; CHECK:       # %bb
; CHECK-DAG:   ld32 [[REGX:\$m[0-9]+]], $m0, $m15, 0
; CHECK-DAG:   ld32 [[REGY:\$m[0-9]+]], $m1, $m15, 0
; CHECK-NEXT:  and [[REGZ:\$m[0-9]+]], [[REGX]], [[REGY]]
; CHECK-NEXT:  st32 [[REGZ:\$m[0-9]+]], $m2, $m15, 0
; CHECK-NEXT:  br $m10
define void @slp_and_v2i16(i16* align 8 %x,
                           i16* align 8 %y,
                           i16* noalias align 8 %z) {
entry:
  %0 = load i16, i16* %x, align 8
  %1 = load i16, i16* %y, align 8
  %and = and i16 %0, %1
  store i16 %and, i16* %z, align 8
  %arrayidx3 = getelementptr inbounds i16, i16* %x, i32 1
  %2 = load i16, i16* %arrayidx3, align 2
  %arrayidx4 = getelementptr inbounds i16, i16* %y, i32 1
  %3 = load i16, i16* %arrayidx4, align 2
  %and5 = and i16 %2, %3
  %arrayidx6 = getelementptr inbounds i16, i16* %z, i32 1
  store i16 %and5, i16* %arrayidx6, align 2
  ret void
}

; CHECK-LABEL: conv_v2f16_to_v2f32:
; CHECK:       # %bb
; CHECK-NEXT:  ld32 [[REGLD:\$a[0-9]+]], $m0, $m15, 0
; CHECK-NEXT:  f16v2tof32 [[REGST:\$a[0-9]+]]:{{[0-9]+}}, [[REGLD]]
; CHECK-NEXT:  st64 [[REGST:\$a[0-9]+]]:{{[0-9]+}}, $m1, $m15, 0
; CHECK-NEXT:  br $m10
define void @conv_v2f16_to_v2f32(half* noalias align 8 %x, float* noalias align 8 %z) {
entry:
  %0 = load half, half* %x, align 8
  %conv = fpext half %0 to float
  store float %conv, float* %z, align 8
  %arrayidx2 = getelementptr inbounds half, half* %x, i32 1
  %1 = load half, half* %arrayidx2, align 2
  %conv3 = fpext half %1 to float
  %arrayidx4 = getelementptr inbounds float, float* %z, i32 1
  store float %conv3, float* %arrayidx4, align 4
  ret void
}

; CHECK-LABEL: conv_v2f32_to_v2f16:
; CHECK:       # %bb
; CHECK-NEXT:  ld64 [[REGLD:\$a[0-9]+]]:{{[0-9]+}}, $m0, $m15, 0
; CHECK-NEXT:  f32v2tof16 [[REGST:\$a[0-9]+]], [[REGLD]]
; CHECK-NEXT:  st32 [[REGST:\$a[0-9]+]], $m1, $m15, 0
; CHECK-NEXT:  br $m10
define void @conv_v2f32_to_v2f16(float* noalias align 8 %x, half* noalias align 8 %z) {
entry:
  %0 = load float, float* %x, align 8
  %conv = fptrunc float %0 to half
  store half %conv, half* %z, align 8
  %arrayidx2 = getelementptr inbounds float, float* %x, i32 1
  %1 = load float, float* %arrayidx2, align 2
  %conv3 = fptrunc float %1 to half
  %arrayidx4 = getelementptr inbounds half, half* %z, i32 1
  store half %conv3, half* %arrayidx4, align 4
  ret void
}
