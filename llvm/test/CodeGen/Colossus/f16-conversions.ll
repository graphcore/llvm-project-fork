; RUN: llc < %s -march=colossus -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -march=colossus -mattr=+ipu2 | FileCheck %s

; CHECK-LABEL: load_store:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m10, $m11, $m15, 1
; CHECK-NEXT:  ldb16 [[REGA0:\$a[0-9]+]], $m0, $m15, 0
; CHECK-NEXT:  mov $m0, $m1
; CHECK-NEXT:  call $m10, __st16f
; CHECK-NEXT:  ld32 $m10, $m11, $m15, 1
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10
define void @load_store(half* %in, half* %out) {
  %val = load half, half* %in
  store half %val, half* %out
  ret void
}

; CHECK-LABEL: from_si32:
; CHECK:       f32fromi32
; CHECK:       f32tof16
; CHECK:       call $m10, __st16f
; CHECK:       br $m10
define void @from_si32(i32 %val, half* %addr) {
  %res = sitofp i32 %val to half
  store half %res, half *%addr
  ret void
}

declare half @llvm.experimental.constrained.sitofp.f16.i32(i32, metadata, metadata)

; CHECK-LABEL: strict_from_si32:
; CHECK:       f32fromi32
; CHECK:       f32tof16
; CHECK:       call $m10, __st16f
; CHECK:       br $m10
define void @strict_from_si32(i32 %val, half* %addr) {
  %res = call half @llvm.experimental.constrained.sitofp.f16.i32(i32 %val, metadata !"round.tonearest", metadata !"fpexcept.strict")
  store half %res, half *%addr
  ret void
}

; CHECK-LABEL: from_ui32:
; CHECK:       f32fromui32
; CHECK:       f32tof16
; CHECK:       call $m10, __st16f
; CHECK:       br $m10
define void @from_ui32(i32 %val, half* %addr) {
  %res = uitofp i32 %val to half
  store half %res, half *%addr
  ret void
}

declare half @llvm.experimental.constrained.uitofp.f16.i32(i32, metadata, metadata)

; CHECK-LABEL: strict_from_ui32:
; CHECK:       f32fromui32
; CHECK:       f32tof16
; CHECK:       call $m10, __st16f
; CHECK:       br $m10
define void @strict_from_ui32(i32 %val, half* %addr) {
  %res = call half @llvm.experimental.constrained.uitofp.f16.i32(i32 %val, metadata !"round.tonearest", metadata !"fpexcept.strict")
  store half %res, half *%addr
  ret void
}

; CHECK-LABEL: to_si32:
; CHECK:       f16tof32
; CHECK:       f32int
; CHECK:       f32toi32
; CHECK:       mov
define i32 @to_si32(half %val) {
  %res = fptosi half %val to i32
  ret i32 %res
}

declare i32 @llvm.experimental.constrained.fptosi.i32.f16(half, metadata)

; CHECK-LABEL: strict_to_si32:
; CHECK:       f16tof32
; CHECK:       f32int
; CHECK:       f32toi32
; CHECK:       mov
define i32 @strict_to_si32(half %val) {
  %res = call i32 @llvm.experimental.constrained.fptosi.i32.f16(half %val, metadata !"fpexcept.strict")
  ret i32 %res
}

; CHECK-LABEL: to_ui32:
; CHECK:       f16tof32
; CHECK:       f32int
; CHECK:       f32toui32
; CHECK:       mov
define i32 @to_ui32(half %val) {
  %res = fptoui half %val to i32
  ret i32 %res
}

declare i32 @llvm.experimental.constrained.fptoui.i32.f16(half, metadata)

; CHECK-LABEL: strict_to_ui32:
; CHECK:       f16tof32
; CHECK:       f32int
; CHECK:       f32toui32
; CHECK:       mov
define i32 @strict_to_ui32(half %val) {
  %res = call i32 @llvm.experimental.constrained.fptoui.i32.f16(half %val, metadata !"fpexcept.strict")
  ret i32 %res
}

; CHECK-LABEL: f32_to_v2f16:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f32tof16 $a0, $a0
; CHECK-NEXT:  }
define <2 x half> @f32_to_v2f16(float %x) {
  %h = fptrunc float %x to half
  %v0 = insertelement <2 x half> undef, half %h, i32 0
  %v1 = insertelement <2 x half> %v0, half %h, i32 1
  ret <2 x half> %v1
}

declare half @llvm.experimental.constrained.fptrunc(float,metadata,metadata)

; CHECK-LABEL: strict_f32_to_v2f16:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f32tof16 $a0, $a0
; CHECK-NEXT:  }
define <2 x half> @strict_f32_to_v2f16(float %x) {
  %h = call half @llvm.experimental.constrained.fptrunc(float %x, metadata !"round.tonearest", metadata !"fpexcept.strict")
  %v0 = insertelement <2 x half> undef, half %h, i32 0
  %v1 = insertelement <2 x half> %v0, half %h, i32 1
  ret <2 x half> %v1
}

; CHECK-LABEL: f32_to_v2f16_with_broadcast:
; CHECK:       # %bb
; CHECK-NEXT:  f32tof16 [[A0:\$a[0-9]+]], $a0
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2add $a0, $a1:BL, [[A0]]
; CHECK-NEXT:  }
define <2 x half> @f32_to_v2f16_with_broadcast(float %x, half %y) {
  %h = fptrunc float %x to half
  %xt = insertelement <2 x half> undef, half %h, i32 0
  %x2 = insertelement <2 x half> %xt, half %h, i32 1
  %yt = insertelement <2 x half> undef, half %y, i32 0
  %y2 = insertelement <2 x half> %yt, half %y, i32 1
  %res = fadd <2 x half> %x2, %y2
  ret <2 x half> %res
}

; CHECK-LABEL: strict_f32_to_v2f16_with_broadcast:
; CHECK:       # %bb
; CHECK-NEXT:  f32tof16 $a0, $a0
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v2add $a0, $a1:BL, $a0
; CHECK-NEXT:  }
define <2 x half> @strict_f32_to_v2f16_with_broadcast(float %x, half %y) {
  %h = call half @llvm.experimental.constrained.fptrunc(float %x, metadata !"round.tonearest", metadata !"fpexcept.strict")
  %xt = insertelement <2 x half> undef, half %h, i32 0
  %x2 = insertelement <2 x half> %xt, half %h, i32 1
  %yt = insertelement <2 x half> undef, half %y, i32 0
  %y2 = insertelement <2 x half> %yt, half %y, i32 1
  %res = fadd <2 x half> %x2, %y2
  ret <2 x half> %res
}

; CHECK-LABEL: low_v2f16_to_f32:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16tof32 $a0, $a0
; CHECK-NEXT:  }
define float @low_v2f16_to_f32(<2 x half> %x) {
  %lo = extractelement <2 x half> %x, i32 0
  %r = fpext half %lo to float
  ret float %r
}

declare float @llvm.experimental.constrained.fpext.f32.f16(half %src, metadata)

; CHECK-LABEL: strict_low_v2f16_to_f32:
; CHECK:       # %bb
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16tof32 $a0, $a0
; CHECK-NEXT:  }
define float @strict_low_v2f16_to_f32(<2 x half> %x) {
  %lo = extractelement <2 x half> %x, i32 0
  %r = tail call float @llvm.experimental.constrained.fpext.f32.f16(half %lo, metadata !"fpexcept.strict")
  ret float %r
}

; CHECK-LABEL: high_v2f16_to_f32:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16tof32 $a0, $a0
; CHECK-NEXT:  }
define float @high_v2f16_to_f32(<2 x half> %x) {
  %hi = extractelement <2 x half> %x, i32 1
  %r = fpext half %hi to float
  ret float %r
}

; CHECK-LABEL: strict_high_v2f16_to_f32:
; CHECK:       # %bb
; CHECK-NEXT:  swap16 $a0, $a0
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16tof32 $a0, $a0
; CHECK-NEXT:  }
define float @strict_high_v2f16_to_f32(<2 x half> %x) {
  %hi = extractelement <2 x half> %x, i32 1
  %r = tail call float @llvm.experimental.constrained.fpext.f32.f16(half %hi, metadata !"fpexcept.strict")
  ret float %r
}
