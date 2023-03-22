; RUN: llc < %s -march=colossus -colossus-coissue=false -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -march=colossus -colossus-coissue=false -mattr=+ipu2 | FileCheck %s

target triple = "colossus-graphcore--elf"

; CHECK-LABEL: sitofp_f32_to_f32:
; CHECK:       # %bb
; CHECK-NEXT:  f32fromi32 $a0, $a0
; CHECK:       br $m10
define float @sitofp_f32_to_f32(float %src) {
  %int = bitcast float %src to i32
  %res = sitofp i32 %int to float
  ret float %res
}

declare float @llvm.experimental.constrained.sitofp.f32.i32(i32, metadata, metadata)

; CHECK-LABEL: constrained_sitofp_f32_to_f32:
; CHECK:       # %bb
; CHECK-NEXT:  f32fromi32 $a0, $a0
; CHECK:       br $m10
define float @constrained_sitofp_f32_to_f32(float %src) {
  %int = bitcast float %src to i32
  %res = call float @llvm.experimental.constrained.sitofp.f32.i32(i32 %int, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret float %res
}

; Sign extension is always on the MRF. See T4670
; CHECK-LABEL: sitofp_f16_to_f16:
; CHECK:       # %bb
; CHECK:       add $m11, $m11, -8
; CHECK:       mov $m0, $a0
; CHECK-NEXT:  shl $m0, $m0, 16
; CHECK-NEXT:  shrs $m0, $m0, 16
; CHECK-NEXT:  st32 $m0, $m11, $m15, 1
; CHECK-NEXT:  ld32 $a0, $m11, $m15, 1
; CHECK-NEXT:  f32fromi32 $a0, $a0
; CHECK-NEXT:  f32tof16 $a0, $a0
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10
define half @sitofp_f16_to_f16(half %src) {
  %int = bitcast half %src to i16
  %res = sitofp i16 %int to half
  ret half %res
}

declare half @llvm.experimental.constrained.sitofp.f16.i16(i16, metadata, metadata)

; Sign extension is always on the MRF. See T4670
; CHECK-LABEL: constrained_sitofp_f16_to_f16:
; CHECK:       # %bb
; CHECK:       add $m11, $m11, -8
; CHECK:       mov $m0, $a0
; CHECK-NEXT:  shl $m0, $m0, 16
; CHECK-NEXT:  shrs $m0, $m0, 16
; CHECK-NEXT:  st32 $m0, $m11, $m15, 1
; CHECK-NEXT:  ld32 $a0, $m11, $m15, 1
; CHECK-NEXT:  f32fromi32 $a0, $a0
; CHECK-NEXT:  f32tof16 $a0, $a0
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10
define half @constrained_sitofp_f16_to_f16(half %src) {
  %int = bitcast half %src to i16
  %res = call half @llvm.experimental.constrained.sitofp.f16.i16(i16 %int, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret half %res
}

; CHECK-LABEL: uitofp_f32_to_f32:
; CHECK:       # %bb
; CHECK-NEXT:  f32fromui32 $a0, $a0
; CHECK:       br $m10
define float @uitofp_f32_to_f32(float %src) {
  %int = bitcast float %src to i32
  %res = uitofp i32 %int to float
  ret float %res
}

declare float @llvm.experimental.constrained.uitofp.f32.i32(i32, metadata, metadata)

; CHECK-LABEL: constrained_uitofp_f32_to_f32:
; CHECK:       # %bb
; CHECK-NEXT:  f32fromui32 $a0, $a0
; CHECK:       br $m10
define float @constrained_uitofp_f32_to_f32(float %src) {
  %int = bitcast float %src to i32
  %res = call float @llvm.experimental.constrained.uitofp.f32.i32(i32 %int, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret float %res
}

; Zero extension works on either register file
; CHECK-LABEL: uitofp_f16_to_f16:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a0, $a15
; CHECK-NEXT:  f32fromui32 $a0, $a0
; CHECK-NEXT:  f32tof16 $a0, $a0
; CHECK:       br $m10
define half @uitofp_f16_to_f16(half %src) {
  %int = bitcast half %src to i16
  %res = uitofp i16 %int to half
  ret half %res
}

declare half @llvm.experimental.constrained.uitofp.f16.i16(i16, metadata, metadata)

; Zero extension works on either register file
; CHECK-LABEL: constrained_uitofp_f16_to_f16:
; CHECK:       # %bb
; CHECK-NEXT:  sort4x16lo $a0, $a0, $a15
; CHECK-NEXT:  f32fromui32 $a0, $a0
; CHECK-NEXT:  f32tof16 $a0, $a0
; CHECK:       br $m10
define half @constrained_uitofp_f16_to_f16(half %src) {
  %int = bitcast half %src to i16
  %res = call half @llvm.experimental.constrained.uitofp.f16.i16(i16 %int, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret half %res
}

; CHECK-LABEL: fptosi_f32_to_f32:
; CHECK:       # %bb
; CHECK-NEXT:  f32int $a0, $a0, 3
; CHECK-NEXT:  f32toi32 $a0, $a0
; CHECK:       br $m10
define float @fptosi_f32_to_f32(float %src) {
  %int = fptosi float %src to i32
  %res = bitcast i32 %int to float
  ret float %res
}

declare i32 @llvm.experimental.constrained.fptosi.i32.f32(float, metadata)

; CHECK-LABEL: constrained_fptosi_f32_to_f32:
; CHECK:       # %bb
; CHECK-NEXT:  f32int $a0, $a0, 3
; CHECK-NEXT:  f32toi32 $a0, $a0
; CHECK:       br $m10
define float @constrained_fptosi_f32_to_f32(float %src) {
  %int = call i32 @llvm.experimental.constrained.fptosi.i32.f32(float %src, metadata !"fpexcept.strict")
  %res = bitcast i32 %int to float
  ret float %res
}

; CHECK-LABEL: fptosi_f16_to_f16:
; CHECK:       # %bb
; CHECK-NEXT:  f16tof32 $a0, $a0
; CHECK-NEXT:  f32int $a0, $a0, 3
; CHECK-NEXT:  f32toi32 $a0, $a0
; CHECK:       br $m10
define half @fptosi_f16_to_f16(half %src) {
  %int = fptosi half %src to i16
  %res = bitcast i16 %int to half
  ret half %res
}

declare i16 @llvm.experimental.constrained.fptosi.i16.f16(half, metadata)

; CHECK-LABEL: constrained_fptosi_f16_to_f16:
; CHECK:       # %bb
; CHECK-NEXT:  f16tof32 $a0, $a0
; CHECK-NEXT:  f32int $a0, $a0, 3
; CHECK-NEXT:  f32toi32 $a0, $a0
; CHECK:       br $m10
define half @constrained_fptosi_f16_to_f16(half %src) {
  %int = call i16 @llvm.experimental.constrained.fptosi.i16.f16(half %src, metadata !"fpexcept.strict")
  %res = bitcast i16 %int to half
  ret half %res
}

; CHECK-LABEL: fptoui_f32_to_f32:
; CHECK:       # %bb
; CHECK-NEXT:  f32int $a0, $a0, 3
; CHECK-NEXT:  f32toui32 $a0, $a0
; CHECK:       br $m10
define float @fptoui_f32_to_f32(float %src) {
  %int = fptoui float %src to i32
  %res = bitcast i32 %int to float
  ret float %res
}

declare i32 @llvm.experimental.constrained.fptoui.i32.f32(float, metadata)

; CHECK-LABEL: constrained_fptoui_f32_to_f32:
; CHECK:       # %bb
; CHECK-NEXT:  f32int $a0, $a0, 3
; CHECK-NEXT:  f32toui32 $a0, $a0
; CHECK:       br $m10
define float @constrained_fptoui_f32_to_f32(float %src) {
  %int = call i32 @llvm.experimental.constrained.fptoui.i32.f32(float %src, metadata !"fpexcept.strict")
  %res = bitcast i32 %int to float
  ret float %res
}

; CHECK-LABEL: fptoui_f16_to_f16:
; CHECK:       # %bb
; CHECK-NEXT:  f16tof32 $a0, $a0
; CHECK-NEXT:  f32int $a0, $a0, 3
; CHECK-NEXT:  f32toui32 $a0, $a0
; CHECK:       br $m10
define half @fptoui_f16_to_f16(half %src) {
  %int = fptoui half %src to i16
  %res = bitcast i16 %int to half
  ret half %res
}

declare i16 @llvm.experimental.constrained.fptoui.i16.f16(half, metadata)

; CHECK-LABEL: constrained_fptoui_f16_to_f16:
; CHECK:       # %bb
; CHECK-NEXT:  f16tof32 $a0, $a0
; CHECK-NEXT:  f32int $a0, $a0, 3
; CHECK-NEXT:  f32toui32 $a0, $a0
; CHECK:       br $m10
define half @constrained_fptoui_f16_to_f16(half %src) {
  %int = call i16 @llvm.experimental.constrained.fptoui.i16.f16(half %src, metadata !"fpexcept.strict")
  %res = bitcast i16 %int to half
  ret half %res
}

; If the bitcast is folded into the load, ISD::SINT_TO_FP wouldn't have a
; bitcast to elide during select. Using ColossusISD::SINT_TO_F32 avoids this
; as the zero-bitcast fixed point is a float load instead of an integer load

; CHECK-LABEL: sitofp_f32_to_f32_load:
; CHECK:       # %bb
; CHECK-NEXT:  ld32 [[REG:\$a[0-9]+]], $m0, $m15, 0
; CHECK-NEXT:  f32fromi32 $a0, [[REG]]
; CHECK:       br $m10
define float @sitofp_f32_to_f32_load(float * %srcp) {
  %src = load float, float* %srcp
  %int = bitcast float %src to i32
  %res = sitofp i32 %int to float
  ret float %res
}

; CHECK-LABEL: constrained_sitofp_f32_to_f32_load:
; CHECK:       # %bb
; CHECK-NEXT:  ld32 [[REG:\$a[0-9]+]], $m0, $m15, 0
; CHECK-NEXT:  f32fromi32 $a0, [[REG]]
; CHECK:       br $m10
define float @constrained_sitofp_f32_to_f32_load(float * %srcp) {
  %src = load float, float* %srcp
  %int = bitcast float %src to i32
  %res = call float @llvm.experimental.constrained.sitofp.f32.i32(i32 %int, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret float %res
}

; CHECK-LABEL: uitofp_f32_to_f32_load:
; CHECK:       # %bb
; CHECK-NEXT:  ld32 [[REG:\$a[0-9]+]], $m0, $m15, 0
; CHECK-NEXT:  f32fromui32 $a0, [[REG]]
; CHECK:       br $m10
define float @uitofp_f32_to_f32_load(float * %srcp) {
  %src = load float, float* %srcp
  %int = bitcast float %src to i32
  %res = uitofp i32 %int to float
  ret float %res
}

; CHECK-LABEL: constrained_uitofp_f32_to_f32_load:
; CHECK:       # %bb
; CHECK-NEXT:  ld32 [[REG:\$a[0-9]+]], $m0, $m15, 0
; CHECK-NEXT:  f32fromui32 $a0, [[REG]]
; CHECK:       br $m10
define float @constrained_uitofp_f32_to_f32_load(float * %srcp) {
  %src = load float, float* %srcp
  %int = bitcast float %src to i32
  %res = call float @llvm.experimental.constrained.uitofp.f32.i32(i32 %int, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret float %res
}
