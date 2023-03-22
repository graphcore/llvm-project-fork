; RUN: llc < %s -march=colossus -colossus-coissue=false -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -march=colossus -colossus-coissue=false -mattr=+ipu2 | FileCheck %s

target triple = "colossus-graphcore--elf"

; CHECK-LABEL: sitofp_i16_to_f16:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; Sign extension induced by the ABI
; CHECK:       st32 $m0, $m11, $m15, 1
; CHECK-NEXT:  ld32 [[REGA:\$a[0-9]+]], $m11, $m15, 1
; CHECK-NEXT:  f32fromi32 [[REGB:\$a[0-9]+]], [[REGA]]
; CHECK-NEXT:  f32tof16 $a0, [[REGB]]
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10
define half @sitofp_i16_to_f16(i16 signext %src) {
  %retval = sitofp i16 %src to half
  ret half %retval
}

declare half @llvm.experimental.constrained.sitofp.f16.i16(i16 %src, metadata, metadata)

; CHECK-LABEL: strict_sitofp_i16_to_f16:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; Sign extension induced by the ABI
; CHECK:       st32 $m0, $m11, $m15, 1
; CHECK-NEXT:  ld32 [[REGA:\$a[0-9]+]], $m11, $m15, 1
; CHECK-NEXT:  f32fromi32 [[REGB:\$a[0-9]+]], [[REGA]]
; CHECK-NEXT:  f32tof16 $a0, [[REGB]]
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10
define half @strict_sitofp_i16_to_f16(i16 signext %src) {
  %retval = tail call half @llvm.experimental.constrained.sitofp.f16.i16(i16 %src, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret half %retval
}

; CHECK-LABEL: sitofp_i16_to_f32:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; Sign extension induced by the ABI
; CHECK:       st32 $m0, $m11, $m15, 1
; CHECK-NEXT:  ld32 [[REGA:\$a[0-9]+]], $m11, $m15, 1
; CHECK-NEXT:  f32fromi32 $a0, [[REGA]]
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10
define float @sitofp_i16_to_f32(i16 signext %src) {
  %retval = sitofp i16 %src to float
  ret float %retval
}

declare float @llvm.experimental.constrained.sitofp.f32.i16(i16 %src, metadata, metadata)

; CHECK-LABEL: strict_sitofp_i16_to_f32:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; Sign extension induced by the ABI
; CHECK:       st32 $m0, $m11, $m15, 1
; CHECK-NEXT:  ld32 [[REGA:\$a[0-9]+]], $m11, $m15, 1
; CHECK-NEXT:  f32fromi32 $a0, [[REGA]]
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10
define float @strict_sitofp_i16_to_f32(i16 signext %src) {
  %retval = tail call float @llvm.experimental.constrained.sitofp.f32.i16(i16 %src, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret float %retval
}

; CHECK-LABEL: sitofp_i32_to_f16:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; Sign extension induced by the ABI
; CHECK:       st32 $m0, $m11, $m15, 1
; CHECK-NEXT:  ld32 [[REGA:\$a[0-9]+]], $m11, $m15, 1
; CHECK-NEXT:  f32fromi32 [[REGB:\$a[0-9]+]], [[REGA]]
; CHECK-NEXT:  f32tof16 $a0, [[REGB]]
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10
define half @sitofp_i32_to_f16(i32 signext %src) {
  %retval = sitofp i32 %src to half
  ret half %retval
}

declare half @llvm.experimental.constrained.sitofp.f16.i32(i32 %src, metadata, metadata)

; CHECK-LABEL: strict_sitofp_i32_to_f16:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; Sign extension induced by the ABI
; CHECK:       st32 $m0, $m11, $m15, 1
; CHECK-NEXT:  ld32 [[REGA:\$a[0-9]+]], $m11, $m15, 1
; CHECK-NEXT:  f32fromi32 [[REGB:\$a[0-9]+]], [[REGA]]
; CHECK-NEXT:  f32tof16 $a0, [[REGB]]
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10
define half @strict_sitofp_i32_to_f16(i32 signext %src) {
  %retval = tail call half @llvm.experimental.constrained.sitofp.f16.i32(i32 %src, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret half %retval
}

; CHECK-LABEL: sitofp_i32_to_f32:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m0, $m11, $m15, 1
; CHECK-NEXT:  ld32 [[REGA:\$a[0-9]+]], $m11, $m15, 1
; CHECK-NEXT:  f32fromi32 $a0, [[REGA]]
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10
define float @sitofp_i32_to_f32(i32 signext %src) {
  %retval = sitofp i32 %src to float
  ret float %retval
}

declare float @llvm.experimental.constrained.sitofp.f32.i32(i32 %src, metadata, metadata)

; CHECK-LABEL: strict_sitofp_i32_to_f32:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m0, $m11, $m15, 1
; CHECK-NEXT:  ld32 [[REGA:\$a[0-9]+]], $m11, $m15, 1
; CHECK-NEXT:  f32fromi32 $a0, [[REGA]]
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10
define float @strict_sitofp_i32_to_f32(i32 signext %src) {
  %retval = tail call float @llvm.experimental.constrained.sitofp.f32.i32(i32 %src, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret float %retval
}

; CHECK-LABEL: uitofp_u16_to_f16:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; Zero extension induced by the ABI
; CHECK:       st32 $m0, $m11, $m15, 1
; CHECK-NEXT:  ld32 [[REGA:\$a[0-9]+]], $m11, $m15, 1
; CHECK-NEXT:  f32fromui32 [[REGB:\$a[0-9]+]], [[REGA]]
; CHECK-NEXT:  f32tof16 $a0, [[REGB]]
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10
define half @uitofp_u16_to_f16(i16 zeroext %src) {
  %retval = uitofp i16 %src to half
  ret half %retval
}

declare half @llvm.experimental.constrained.uitofp.f16.u16(i16 %src, metadata, metadata)

; CHECK-LABEL: strict_uitofp_u16_to_f16:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; Zero extension induced by the ABI
; CHECK:       st32 $m0, $m11, $m15, 1
; CHECK-NEXT:  ld32 [[REGA:\$a[0-9]+]], $m11, $m15, 1
; CHECK-NEXT:  f32fromui32 [[REGB:\$a[0-9]+]], [[REGA]]
; CHECK-NEXT:  f32tof16 $a0, [[REGB]]
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10
define half @strict_uitofp_u16_to_f16(i16 zeroext %src) {
  %retval = tail call half @llvm.experimental.constrained.uitofp.f16.u16(i16 %src, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret half %retval
}

; CHECK-LABEL: uitofp_u16_to_f32:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; Zero extension induced by the ABI
; CHECK:       st32 $m0, $m11, $m15, 1
; CHECK-NEXT:  ld32 [[REGA:\$a[0-9]+]], $m11, $m15, 1
; CHECK-NEXT:  f32fromui32 $a0, [[REGA]]
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10
define float @uitofp_u16_to_f32(i16 zeroext %src) {
  %retval = uitofp i16 %src to float
  ret float %retval
}

declare float @llvm.experimental.constrained.uitofp.f32.u16(i16 %src, metadata, metadata)

; CHECK-LABEL: strict_uitofp_u16_to_f32:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; Zero extension induced by the ABI
; CHECK:       st32 $m0, $m11, $m15, 1
; CHECK-NEXT:  ld32 [[REGA:\$a[0-9]+]], $m11, $m15, 1
; CHECK-NEXT:  f32fromui32 $a0, [[REGA]]
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10
define float @strict_uitofp_u16_to_f32(i16 zeroext %src) {
  %retval = tail call float @llvm.experimental.constrained.uitofp.f32.u16(i16 %src, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret float %retval
}

; CHECK-LABEL: uitofp_u32_to_f16:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; Zero extension induced by the ABI
; CHECK:       st32 $m0, $m11, $m15, 1
; CHECK-NEXT:  ld32 [[REGA:\$a[0-9]+]], $m11, $m15, 1
; CHECK-NEXT:  f32fromui32 [[REGB:\$a[0-9]+]], [[REGA]]
; CHECK-NEXT:  f32tof16 $a0, [[REGB]]
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10
define half @uitofp_u32_to_f16(i32 zeroext %src) {
  %retval = uitofp i32 %src to half
  ret half %retval
}

declare half @llvm.experimental.constrained.uitofp.f16.u32(i32 %src, metadata, metadata)

; CHECK-LABEL: strict_uitofp_u32_to_f16:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; Zero extension induced by the ABI
; CHECK:       st32 $m0, $m11, $m15, 1
; CHECK-NEXT:  ld32 [[REGA:\$a[0-9]+]], $m11, $m15, 1
; CHECK-NEXT:  f32fromui32 [[REGB:\$a[0-9]+]], [[REGA]]
; CHECK-NEXT:  f32tof16 $a0, [[REGB]]
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10
define half @strict_uitofp_u32_to_f16(i32 zeroext %src) {
  %retval = tail call half @llvm.experimental.constrained.uitofp.f16.u32(i32 %src, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret half %retval
}

; CHECK-LABEL: uitofp_u32_to_f32:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m0, $m11, $m15, 1
; CHECK-NEXT:  ld32 [[REGA:\$a[0-9]+]], $m11, $m15, 1
; CHECK-NEXT:  f32fromui32 $a0, [[REGA]]
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10
define float @uitofp_u32_to_f32(i32 zeroext %src) {
  %retval = uitofp i32 %src to float
  ret float %retval
}

declare float @llvm.experimental.constrained.uitofp.f32.u32(i32 %src, metadata, metadata)

; CHECK-LABEL: strict_uitofp_u32_to_f32:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m0, $m11, $m15, 1
; CHECK-NEXT:  ld32 [[REGA:\$a[0-9]+]], $m11, $m15, 1
; CHECK-NEXT:  f32fromui32 $a0, [[REGA]]
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10
define float @strict_uitofp_u32_to_f32(i32 zeroext %src) {
  %retval = tail call float @llvm.experimental.constrained.uitofp.f32.u32(i32 %src, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret float %retval
}

; CHECK-LABEL: fptosi_f16_to_i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f16tof32 $a0, $a0
; CHECK-NEXT:  f32int $a0, $a0, 3
; CHECK-NEXT:  f32toi32 $a0, $a0
; CHECK-NEXT:  mov $m0, $a0
; CHECK:       br $m10
define signext i16 @fptosi_f16_to_i16(half %src) {
  %retval = fptosi half %src to i16
  ret i16 %retval
}

declare i16 @llvm.experimental.constrained.fptosi.i16.f16(half %src, metadata)

; CHECK-LABEL: strict_fptosi_f16_to_i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f16tof32 $a0, $a0
; CHECK-NEXT:  f32int $a0, $a0, 3
; CHECK-NEXT:  f32toi32 $a0, $a0
; CHECK-NEXT:  mov $m0, $a0
; CHECK:       br $m10
define signext i16 @strict_fptosi_f16_to_i16(half %src) {
  %retval = tail call i16 @llvm.experimental.constrained.fptosi.i16.f16(half %src, metadata !"fpexcept.strict")
  ret i16 %retval
}

; CHECK-LABEL: fptosi_f16_to_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f16tof32 $a0, $a0
; CHECK-NEXT:  f32int $a0, $a0, 3
; CHECK-NEXT:  f32toi32 $a0, $a0
; CHECK-NEXT:  mov $m0, $a0
; CHECK:       br $m10
define signext i32 @fptosi_f16_to_i32(half %src) {
  %retval = fptosi half %src to i32
  ret i32 %retval
}

declare i32 @llvm.experimental.constrained.fptosi.i32.f16(half %src, metadata)

; CHECK-LABEL: strict_fptosi_f16_to_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f16tof32 $a0, $a0
; CHECK-NEXT:  f32int $a0, $a0, 3
; CHECK-NEXT:  f32toi32 $a0, $a0
; CHECK-NEXT:  mov $m0, $a0
; CHECK:       br $m10
define signext i32 @strict_fptosi_f16_to_i32(half %src) {
  %retval = tail call i32 @llvm.experimental.constrained.fptosi.i32.f16(half %src, metadata !"fpexcept.strict")
  ret i32 %retval
}

; CHECK-LABEL: fptoui_f16_to_u16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f16tof32 $a0, $a0
; CHECK-NEXT:  f32int $a0, $a0, 3
; CHECK-NEXT:  f32toui32 $a0, $a0
; CHECK-NEXT:  mov $m0, $a0
; CHECK:       br $m10
define zeroext i16 @fptoui_f16_to_u16(half %src) {
  %retval = fptoui half %src to i16
  ret i16 %retval
}

declare i16 @llvm.experimental.constrained.fptoui.u16.f16(half %src, metadata)

; CHECK-LABEL: strict_fptoui_f16_to_u16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f16tof32 $a0, $a0
; CHECK-NEXT:  f32int $a0, $a0, 3
; CHECK-NEXT:  f32toui32 $a0, $a0
; CHECK-NEXT:  mov $m0, $a0
; CHECK:       br $m10
define zeroext i16 @strict_fptoui_f16_to_u16(half %src) {
  %retval = tail call i16 @llvm.experimental.constrained.fptoui.u16.f16(half %src, metadata !"fpexcept.strict")
  ret i16 %retval
}

; CHECK-LABEL: fptoui_f16_to_u32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f16tof32 $a0, $a0
; CHECK-NEXT:  f32int $a0, $a0, 3
; CHECK-NEXT:  f32toui32 $a0, $a0
; CHECK-NEXT:  mov $m0, $a0
; CHECK:       br $m10
define zeroext i32 @fptoui_f16_to_u32(half %src) {
  %retval = fptoui half %src to i32
  ret i32 %retval
}

declare i32 @llvm.experimental.constrained.fptoui.u32.f16(half %src, metadata)

; CHECK-LABEL: strict_fptoui_f16_to_u32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f16tof32 $a0, $a0
; CHECK-NEXT:  f32int $a0, $a0, 3
; CHECK-NEXT:  f32toui32 $a0, $a0
; CHECK-NEXT:  mov $m0, $a0
; CHECK:       br $m10
define zeroext i32 @strict_fptoui_f16_to_u32(half %src) {
  %retval = tail call i32 @llvm.experimental.constrained.fptoui.u32.f16(half %src, metadata !"fpexcept.strict")
  ret i32 %retval
}

; CHECK-LABEL: fptosi_f32_to_i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f32int $a0, $a0, 3
; CHECK-NEXT:  f32toi32 $a0, $a0
; CHECK-NEXT:  mov $m0, $a0
; CHECK:       br $m10
define signext i16 @fptosi_f32_to_i16(float %src) {
  %retval = fptosi float %src to i16
  ret i16 %retval
}

declare i16 @llvm.experimental.constrained.fptosi.i16.f32(float %src, metadata)

; CHECK-LABEL: strict_fptosi_f32_to_i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f32int $a0, $a0, 3
; CHECK-NEXT:  f32toi32 $a0, $a0
; CHECK-NEXT:  mov $m0, $a0
; CHECK:       br $m10
define signext i16 @strict_fptosi_f32_to_i16(float %src) {
  %retval = tail call i16 @llvm.experimental.constrained.fptosi.i16.f32(float %src, metadata !"fpexcept.strict")
  ret i16 %retval
}

; CHECK-LABEL: fptosi_f32_to_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f32int $a0, $a0, 3
; CHECK-NEXT:  f32toi32 $a0, $a0
; CHECK-NEXT:  mov $m0, $a0
; CHECK:       br $m10
define signext i32 @fptosi_f32_to_i32(float %src) {
  %retval = fptosi float %src to i32
  ret i32 %retval
}

declare i32 @llvm.experimental.constrained.fptosi.i32.f32(float %src, metadata)

; CHECK-LABEL: strict_fptosi_f32_to_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f32int $a0, $a0, 3
; CHECK-NEXT:  f32toi32 $a0, $a0
; CHECK-NEXT:  mov $m0, $a0
; CHECK:       br $m10
define signext i32 @strict_fptosi_f32_to_i32(float %src) {
  %retval = tail call i32 @llvm.experimental.constrained.fptosi.i32.f32(float %src, metadata !"fpexcept.strict")
  ret i32 %retval
}

; CHECK-LABEL: fptoui_f32_to_u16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f32int $a0, $a0, 3
; CHECK-NEXT:  f32toui32 $a0, $a0
; CHECK-NEXT:  mov $m0, $a0
; CHECK:       br $m10
define zeroext i16 @fptoui_f32_to_u16(float %src) {
  %retval = fptoui float %src to i16
  ret i16 %retval
}

declare i16 @llvm.experimental.constrained.fptoui.u16.f32(float %src, metadata)

; CHECK-LABEL: strict_fptoui_f32_to_u16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f32int $a0, $a0, 3
; CHECK-NEXT:  f32toui32 $a0, $a0
; CHECK-NEXT:  mov $m0, $a0
; CHECK:       br $m10
define zeroext i16 @strict_fptoui_f32_to_u16(float %src) {
  %retval = tail call i16 @llvm.experimental.constrained.fptoui.u16.f32(float %src, metadata !"fpexcept.strict")
  ret i16 %retval
}

; CHECK-LABEL: fptoui_f32_to_u32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f32int $a0, $a0, 3
; CHECK-NEXT:  f32toui32 $a0, $a0
; CHECK-NEXT:  mov $m0, $a0
; CHECK:       br $m10
define zeroext i32 @fptoui_f32_to_u32(float %src) {
  %retval = fptoui float %src to i32
  ret i32 %retval
}

declare i32 @llvm.experimental.constrained.fptoui.u32.f32(float %src, metadata)

; CHECK-LABEL: strict_fptoui_f32_to_u32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f32int $a0, $a0, 3
; CHECK-NEXT:  f32toui32 $a0, $a0
; CHECK-NEXT:  mov $m0, $a0
; CHECK:       br $m10
define zeroext i32 @strict_fptoui_f32_to_u32(float %src) {
  %retval = tail call i32 @llvm.experimental.constrained.fptoui.u32.f32(float %src, metadata !"fpexcept.strict")
  ret i32 %retval
}

; CHECK-LABEL: sitofp_v2i16_to_v2f16:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; High half
; CHECK:       shrs [[REGA:\$m[1-9]+]], $m0, 16
; CHECK-NEXT:  st32 [[REGA]], $m11, $m15, 1
; CHECK-NEXT:  ld32 [[REGB:\$a[0-9]+]], $m11, $m15, 1
; CHECK-NEXT:  f32fromi32 [[REGB]], [[REGB]]
; CHECK-NEXT:  f32tof16 [[REGB]], [[REGB]]
; Low half
; CHECK-NEXT:  shl [[REGC:\$m[0-9]+]], $m0, 16
; CHECK-NEXT:  shrs [[REGC]], [[REGC]], 16
; CHECK-NEXT:  st32 [[REGC]], $m11, $m15, 1
; CHECK-NEXT:  ld32 [[REGD:\$a[0-9]+]], $m11, $m15, 1
; CHECK-NEXT:  f32fromi32 [[REGD]], [[REGD]]
; CHECK-NEXT:  f32tof16 [[REGD]], [[REGD]]
; Reassemble
; CHECK-NEXT:  sort4x16lo $a0, [[REGD]], [[REGB]]
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10
define <2 x half> @sitofp_v2i16_to_v2f16(<2 x i16> %src) {
  %retval = sitofp <2 x i16> %src to <2 x half>
  ret <2 x half> %retval
}

declare <2 x half> @llvm.experimental.constrained.sitofp.v2f16.v2i16(<2 x i16> %src, metadata, metadata)

; CHECK-LABEL: strict_sitofp_v2i16_to_v2f16:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; High half
; CHECK:       shrs [[REGA:\$m[1-9]+]], $m0, 16
; CHECK-NEXT:  st32 [[REGA]], $m11, $m15, 1
; CHECK-NEXT:  ld32 [[REGB:\$a[0-9]+]], $m11, $m15, 1
; CHECK-NEXT:  f32fromi32 [[REGB]], [[REGB]]
; CHECK-NEXT:  f32tof16 [[REGB]], [[REGB]]
; Low half
; CHECK-NEXT:  shl [[REGC:\$m[0-9]+]], $m0, 16
; CHECK-NEXT:  shrs [[REGC]], [[REGC]], 16
; CHECK-NEXT:  st32 [[REGC]], $m11, $m15, 1
; CHECK-NEXT:  ld32 [[REGD:\$a[0-9]+]], $m11, $m15, 1
; CHECK-NEXT:  f32fromi32 [[REGD]], [[REGD]]
; CHECK-NEXT:  f32tof16 [[REGD]], [[REGD]]
; Reassemble
; CHECK-NEXT:  sort4x16lo $a0, [[REGD]], [[REGB]]
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10
define <2 x half> @strict_sitofp_v2i16_to_v2f16(<2 x i16> %src) {
  %retval = tail call <2 x half> @llvm.experimental.constrained.sitofp.v2f16.v2i16(<2 x i16> %src, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <2 x half> %retval
}

; CHECK-LABEL: sitofp_v2i16_to_v2f32:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; Low half
; CHECK:       shl [[REGA:\$m[1-9]+]], $m0, 16
; CHECK-NEXT:  shrs [[REGA]], [[REGA]], 16
; CHECK-NEXT:  st32 [[REGA]], $m11, $m15, 1
; CHECK-NEXT:  ld32 [[REGB:\$a[0-9]+]], $m11, $m15, 1
; CHECK-NEXT:  f32fromi32 $a0, [[REGB]]
; High half
; CHECK-NEXT:  shrs [[REGC:\$m[0-9]+]], $m0, 16
; CHECK-NEXT:  st32 [[REGC]], $m11, $m15, 1
; CHECK-NEXT:  ld32 [[REGD:\$a[0-9]+]], $m11, $m15, 1
; CHECK-NEXT:  f32fromi32 $a1, [[REGD]]
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10
define <2 x float> @sitofp_v2i16_to_v2f32(<2 x i16> %src) {
  %retval = sitofp <2 x i16> %src to <2 x float>
  ret <2 x float> %retval
}

declare <2 x float> @llvm.experimental.constrained.sitofp.v2f32.v2i16(<2 x i16> %src, metadata, metadata)

; CHECK-LABEL: strict_sitofp_v2i16_to_v2f32:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; Low half
; CHECK:       shl [[REGA:\$m[1-9]+]], $m0, 16
; CHECK-NEXT:  shrs [[REGA]], [[REGA]], 16
; CHECK-NEXT:  st32 [[REGA]], $m11, $m15, 1
; CHECK-NEXT:  ld32 [[REGB:\$a[0-9]+]], $m11, $m15, 1
; CHECK-NEXT:  f32fromi32 $a0, [[REGB]]
; High half
; CHECK-NEXT:  shrs [[REGC:\$m[0-9]+]], $m0, 16
; CHECK-NEXT:  st32 [[REGC]], $m11, $m15, 1
; CHECK-NEXT:  ld32 [[REGD:\$a[0-9]+]], $m11, $m15, 1
; CHECK-NEXT:  f32fromi32 $a1, [[REGD]]
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10
define <2 x float> @strict_sitofp_v2i16_to_v2f32(<2 x i16> %src) {
  %retval = tail call <2 x float> @llvm.experimental.constrained.sitofp.v2f32.v2i16(<2 x i16> %src, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <2 x float> %retval
}

; CHECK-LABEL: sitofp_v2i32_to_v2f16:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m0, $m11, $m15, 1
; CHECK-NEXT:  ld32 [[REGA:\$a[0-9]+]], $m11, $m15, 1
; CHECK-NEXT:  st32 $m1, $m11, $m15, 1
; CHECK-NEXT:  ld32 [[REGB:\$a[0-9]+]], $m11, $m15, 1
; CHECK-NEXT:  f32fromi32 [[REGB]], [[REGB]]
; CHECK-NEXT:  f32tof16 [[REGB]], [[REGB]]
; CHECK-NEXT:  f32fromi32 [[REGA]], [[REGA]]
; CHECK-NEXT:  f32tof16 [[REGA]], [[REGA]]
; Reassemble
; CHECK-NEXT:  sort4x16lo $a0, [[REGA]], [[REGB]]
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10
define <2 x half> @sitofp_v2i32_to_v2f16(<2 x i32> %src) {
  %retval = sitofp <2 x i32> %src to <2 x half>
  ret <2 x half> %retval
}

declare <2 x half> @llvm.experimental.constrained.sitofp.v2f16.v2i32(<2 x i32> %src, metadata, metadata)

; CHECK-LABEL: strict_sitofp_v2i32_to_v2f16:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m0, $m11, $m15, 1
; CHECK-NEXT:  ld32 [[REGB:\$a[0-9]+]], $m11, $m15, 1
; CHECK-NEXT:  st32 $m1, $m11, $m15, 1
; CHECK-NEXT:  ld32 [[REGA:\$a[0-9]+]], $m11, $m15, 1
; CHECK-NEXT:  f32fromi32 [[REGA]], [[REGA]]
; CHECK-NEXT:  f32tof16 [[REGA]], [[REGA]]
; CHECK-NEXT:  f32fromi32 [[REGB]], [[REGB]]
; CHECK-NEXT:  f32tof16 [[REGB]], [[REGB]]
; Reassemble
; CHECK-NEXT:  sort4x16lo $a0, [[REGB]], [[REGA]]
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10
define <2 x half> @strict_sitofp_v2i32_to_v2f16(<2 x i32> %src) {
  %retval = tail call <2 x half> @llvm.experimental.constrained.sitofp.v2f16.v2i32(<2 x i32> %src, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <2 x half> %retval
}

; CHECK-LABEL: sitofp_v2i32_to_v2f32:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m1, $m11, $m15, 1
; CHECK-NEXT:  ld32 [[REGA:\$a[0-9]+]], $m11, $m15, 1
; CHECK-NEXT:  st32 $m0, $m11, $m15, 1
; CHECK-NEXT:  ld32 [[REGB:\$a[0-9]+]], $m11, $m15, 1
; CHECK-NEXT:  f32fromi32 $a0, [[REGB]]
; CHECK-NEXT:  f32fromi32 $a1, [[REGA]]
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10
define <2 x float> @sitofp_v2i32_to_v2f32(<2 x i32> %src) {
  %retval = sitofp <2 x i32> %src to <2 x float>
  ret <2 x float> %retval
}

declare <2 x float> @llvm.experimental.constrained.sitofp.v2f32.v2i32(<2 x i32> %src, metadata, metadata)

; CHECK-LABEL: strict_sitofp_v2i32_to_v2f32:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m1, $m11, $m15, 1
; CHECK-NEXT:  ld32 [[REGB:\$a[0-9]+]], $m11, $m15, 1
; CHECK-NEXT:  st32 $m0, $m11, $m15, 1
; CHECK-NEXT:  ld32 [[REGA:\$a[0-9]+]], $m11, $m15, 1
; CHECK-NEXT:  f32fromi32 $a0, [[REGA]]
; CHECK-NEXT:  f32fromi32 $a1, [[REGB]]
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10
define <2 x float> @strict_sitofp_v2i32_to_v2f32(<2 x i32> %src) {
  %retval = tail call <2 x float> @llvm.experimental.constrained.sitofp.v2f32.v2i32(<2 x i32> %src, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <2 x float> %retval
}

; CHECK-LABEL: uitofp_v2u16_to_v2f16:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; High half
; CHECK:       sort4x16hi [[REGA:\$m[0-9]+]], $m0, $m15
; Zero extended by above sort4x16
; CHECK-NEXT:  st32 [[REGA]], $m11, $m15, 1
; CHECK-NEXT:  ld32 [[REGB:\$a[0-9]+]], $m11, $m15, 1
; CHECK-NEXT:  f32fromui32 [[REGB]], [[REGB]]
; CHECK-NEXT:  f32tof16 [[REGB]], [[REGB]]
; Low half
; CHECK-NEXT:  sort4x16lo [[REGC:\$m[0-9]+]], $m0, $m15
; Zero extended by above sort4x16
; CHECK-NEXT:  st32 [[REGC]], $m11, $m15, 1
; CHECK-NEXT:  ld32 [[REGD:\$a[0-9]+]], $m11, $m15, 1
; CHECK-NEXT:  f32fromui32 [[REGD]], [[REGD]]
; CHECK-NEXT:  f32tof16 [[REGD]], [[REGD]]
; Reassemble
; CHECK-NEXT:  sort4x16lo $a0, [[REGD]], [[REGB]]
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10
define <2 x half> @uitofp_v2u16_to_v2f16(<2 x i16> %src) {
  %retval = uitofp <2 x i16> %src to <2 x half>
  ret <2 x half> %retval
}

declare <2 x half> @llvm.experimental.constrained.uitofp.v2f16.v2u16(<2 x i16> %src, metadata, metadata)

; CHECK-LABEL: strict_uitofp_v2u16_to_v2f16:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; High half
; CHECK:       sort4x16hi [[REGA:\$m[0-9]+]], $m0, $m15
; Zero extended by above sort4x16
; CHECK-NEXT:  st32 [[REGA]], $m11, $m15, 1
; CHECK-NEXT:  ld32 [[REGB:\$a[0-9]+]], $m11, $m15, 1
; CHECK-NEXT:  f32fromui32 [[REGB]], [[REGB]]
; CHECK-NEXT:  f32tof16 [[REGB]], [[REGB]]
; Low half
; CHECK-NEXT:  sort4x16lo [[REGC:\$m[0-9]+]], $m0, $m15
; Zero extended by above sort4x16
; CHECK-NEXT:  st32 [[REGC]], $m11, $m15, 1
; CHECK-NEXT:  ld32 [[REGD:\$a[0-9]+]], $m11, $m15, 1
; CHECK-NEXT:  f32fromui32 [[REGD]], [[REGD]]
; CHECK-NEXT:  f32tof16 [[REGD]], [[REGD]]
; Reassemble
; CHECK-NEXT:  sort4x16lo $a0, [[REGD]], [[REGB]]
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10
define <2 x half> @strict_uitofp_v2u16_to_v2f16(<2 x i16> %src) {
  %retval = tail call <2 x half> @llvm.experimental.constrained.uitofp.v2f16.v2u16(<2 x i16> %src, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <2 x half> %retval
}

; CHECK-LABEL: uitofp_v2u16_to_v2f32:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; Low half
; CHECK:       sort4x16lo [[REGA:\$m[1-9]+]], $m0, $m15
; Zero extended by above sort4x16
; CHECK-NEXT:  st32 [[REGA]], $m11, $m15, 1
; CHECK-NEXT:  ld32 [[REGB:\$a[0-9]+]], $m11, $m15, 1
; CHECK-NEXT:  f32fromui32 $a0, [[REGB]]
; High half
; CHECK-NEXT:  sort4x16hi [[REGC:\$m[0-9]+]], $m0, $m15
; CHECK-NEXT:  st32 [[REGC]], $m11, $m15, 1
; CHECK-NEXT:  ld32 [[REGD:\$a[0-9]+]], $m11, $m15, 1
; CHECK-NEXT:  f32fromui32 $a1, [[REGD]]
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10
define <2 x float> @uitofp_v2u16_to_v2f32(<2 x i16> %src) {
  %retval = uitofp <2 x i16> %src to <2 x float>
  ret <2 x float> %retval
}

declare <2 x float> @llvm.experimental.constrained.uitofp.v2f32.v2u16(<2 x i16> %src, metadata, metadata)

; CHECK-LABEL: strict_uitofp_v2u16_to_v2f32:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; Low half
; CHECK:       sort4x16lo [[REGA:\$m[1-9]+]], $m0, $m15
; Zero extended by above sort4x16
; CHECK-NEXT:  st32 [[REGA]], $m11, $m15, 1
; CHECK-NEXT:  ld32 [[REGB:\$a[0-9]+]], $m11, $m15, 1
; CHECK-NEXT:  f32fromui32 $a0, [[REGB]]
; High half
; CHECK-NEXT:  sort4x16hi [[REGC:\$m[0-9]+]], $m0, $m15
; CHECK-NEXT:  st32 [[REGC]], $m11, $m15, 1
; CHECK-NEXT:  ld32 [[REGD:\$a[0-9]+]], $m11, $m15, 1
; CHECK-NEXT:  f32fromui32 $a1, [[REGD]]
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10
define <2 x float> @strict_uitofp_v2u16_to_v2f32(<2 x i16> %src) {
  %retval = tail call <2 x float> @llvm.experimental.constrained.uitofp.v2f32.v2u16(<2 x i16> %src, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <2 x float> %retval
}

; CHECK-LABEL: uitofp_v2u32_to_v2f16:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m0, $m11, $m15, 1
; CHECK-NEXT:  ld32 [[REGA:\$a[0-9]+]], $m11, $m15, 1
; CHECK-NEXT:  st32 $m1, $m11, $m15, 1
; CHECK-NEXT:  ld32 [[REGB:\$a[0-9]+]], $m11, $m15, 1
; CHECK-NEXT:  f32fromui32 [[REGB]], [[REGB]]
; CHECK-NEXT:  f32tof16 [[REGB]], [[REGB]]
; CHECK-NEXT:  f32fromui32 [[REGA]], [[REGA]]
; CHECK-NEXT:  f32tof16 [[REGA]], [[REGA]]
; Reassemble
; CHECK-NEXT:  sort4x16lo $a0, [[REGA]], [[REGB]]
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10
define <2 x half> @uitofp_v2u32_to_v2f16(<2 x i32> %src) {
  %retval = uitofp <2 x i32> %src to <2 x half>
  ret <2 x half> %retval
}

declare <2 x half> @llvm.experimental.constrained.uitofp.v2f16.v2u32(<2 x i32> %src, metadata, metadata)

; CHECK-LABEL: strict_uitofp_v2u32_to_v2f16:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m0, $m11, $m15, 1
; CHECK-NEXT:  ld32 [[REGB:\$a[0-9]+]], $m11, $m15, 1
; CHECK-NEXT:  st32 $m1, $m11, $m15, 1
; CHECK-NEXT:  ld32 [[REGA:\$a[0-9]+]], $m11, $m15, 1
; CHECK-NEXT:  f32fromui32 [[REGA]], [[REGA]]
; CHECK-NEXT:  f32tof16 [[REGA]], [[REGA]]
; CHECK-NEXT:  f32fromui32 [[REGB]], [[REGB]]
; CHECK-NEXT:  f32tof16 [[REGB]], [[REGB]]
; Reassemble
; CHECK-NEXT:  sort4x16lo $a0, [[REGB]], [[REGA]]
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10
define <2 x half> @strict_uitofp_v2u32_to_v2f16(<2 x i32> %src) {
  %retval = tail call <2 x half> @llvm.experimental.constrained.uitofp.v2f16.v2u32(<2 x i32> %src, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <2 x half> %retval
}

; CHECK-LABEL: uitofp_v2u32_to_v2f32:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m1, $m11, $m15, 1
; CHECK-NEXT:  ld32 [[REGA:\$a[0-9]+]], $m11, $m15, 1
; CHECK-NEXT:  st32 $m0, $m11, $m15, 1
; CHECK-NEXT:  ld32 [[REGB:\$a[0-9]+]], $m11, $m15, 1
; CHECK-NEXT:  f32fromui32 $a0, [[REGB]]
; CHECK-NEXT:  f32fromui32 $a1, [[REGA]]
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10
define <2 x float> @uitofp_v2u32_to_v2f32(<2 x i32> %src) {
  %retval = uitofp <2 x i32> %src to <2 x float>
  ret <2 x float> %retval
}

declare <2 x float> @llvm.experimental.constrained.uitofp.v2f32.v2u32(<2 x i32> %src, metadata, metadata)

; CHECK-LABEL: strict_uitofp_v2u32_to_v2f32:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m1, $m11, $m15, 1
; CHECK-NEXT:  ld32 [[REGB:\$a[0-9]+]], $m11, $m15, 1
; CHECK-NEXT:  st32 $m0, $m11, $m15, 1
; CHECK-NEXT:  ld32 [[REGA:\$a[0-9]+]], $m11, $m15, 1
; CHECK-NEXT:  f32fromui32 $a0, [[REGA]]
; CHECK-NEXT:  f32fromui32 $a1, [[REGB]]
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10
define <2 x float> @strict_uitofp_v2u32_to_v2f32(<2 x i32> %src) {
  %retval = tail call <2 x float> @llvm.experimental.constrained.uitofp.v2f32.v2u32(<2 x i32> %src, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <2 x float> %retval
}

; CHECK-LABEL: fptosi_v2f16_to_v2i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f16tof32 [[REGC:\$a[1-9]+]], $a0
; CHECK-NEXT:  f32int [[REGC]], [[REGC]]
; CHECK-NEXT:  f32toi32 [[REGC]], [[REGC]]
; CHECK-NEXT:  mov [[REGD:\$m[0-9]+]], [[REGC]]
; CHECK-NEXT:  swap16 [[REGA:\$a[0-9]+]], $a0
; CHECK-NEXT:  f16tof32 [[REGA]], [[REGA]]
; CHECK-NEXT:  f32int [[REGA]], [[REGA]]
; CHECK-NEXT:  f32toi32 [[REGA]], [[REGA]]
; CHECK-NEXT:  mov [[REGB:\$m[0-9]+]], [[REGA]]
; CHECK-NEXT:  sort4x16lo $m0, [[REGD]], [[REGB]]
; CHECK:       br $m10
define <2 x i16> @fptosi_v2f16_to_v2i16(<2 x half> %src) {
  %retval = fptosi <2 x half> %src to <2 x i16>
  ret <2 x i16> %retval
}

declare <2 x i16> @llvm.experimental.constrained.fptosi.v2i16.v2f16(<2 x half> %src, metadata)

; CHECK-LABEL: strict_fptosi_v2f16_to_v2i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f16tof32 [[REGC:\$a[1-9]+]], $a0
; CHECK-NEXT:  f32int [[REGC]], [[REGC]]
; CHECK-NEXT:  f32toi32 [[REGC]], [[REGC]]
; CHECK-NEXT:  mov [[REGD:\$m[0-9]+]], [[REGC]]
; CHECK-NEXT:  swap16 [[REGA:\$a[0-9]+]], $a0
; CHECK-NEXT:  f16tof32 [[REGA]], [[REGA]]
; CHECK-NEXT:  f32int [[REGA]], [[REGA]]
; CHECK-NEXT:  f32toi32 [[REGA]], [[REGA]]
; CHECK-NEXT:  mov [[REGB:\$m[0-9]+]], [[REGA]]
; CHECK-NEXT:  sort4x16lo $m0, [[REGD]], [[REGB]]
; CHECK:       br $m10
define <2 x i16> @strict_fptosi_v2f16_to_v2i16(<2 x half> %src) {
  %retval = tail call <2 x i16> @llvm.experimental.constrained.fptosi.v2i16.v2f16(<2 x half> %src, metadata !"fpexcept.strict")
  ret <2 x i16> %retval
}

; CHECK-LABEL: fptosi_v2f16_to_v2i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f16tof32 [[REGA:\$a[1-9]+]], $a0
; CHECK-NEXT:  f32int [[REGA]], [[REGA]]
; CHECK-NEXT:  f32toi32 [[REGA]], [[REGA]]
; CHECK-NEXT:  mov $m0, [[REGA]]
; CHECK-NEXT:  swap16 [[REGB:\$a[0-9]+]], $a0
; CHECK-NEXT:  f16tof32 [[REGB]], [[REGB]]
; CHECK-NEXT:  f32int [[REGB]], [[REGB]]
; CHECK-NEXT:  f32toi32 [[REGB]], [[REGB]]
; CHECK-NEXT:  mov $m1, [[REGB]]
; CHECK:       br $m10
define <2 x i32> @fptosi_v2f16_to_v2i32(<2 x half> %src) {
  %retval = fptosi <2 x half> %src to <2 x i32>
  ret <2 x i32> %retval
}

declare <2 x i32> @llvm.experimental.constrained.fptosi.v2i32.v2f16(<2 x half> %src, metadata)

; CHECK-LABEL: strict_fptosi_v2f16_to_v2i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f16tof32 [[REGA:\$a[1-9]+]], $a0
; CHECK-NEXT:  f32int [[REGA]], [[REGA]]
; CHECK-NEXT:  f32toi32 [[REGA]], [[REGA]]
; CHECK-NEXT:  mov $m0, [[REGA]]
; CHECK-NEXT:  swap16 [[REGB:\$a[0-9]+]], $a0
; CHECK-NEXT:  f16tof32 [[REGB]], [[REGB]]
; CHECK-NEXT:  f32int [[REGB]], [[REGB]]
; CHECK-NEXT:  f32toi32 [[REGB]], [[REGB]]
; CHECK-NEXT:  mov $m1, [[REGB]]
; CHECK:       br $m10
define <2 x i32> @strict_fptosi_v2f16_to_v2i32(<2 x half> %src) {
  %retval = tail call <2 x i32> @llvm.experimental.constrained.fptosi.v2i32.v2f16(<2 x half> %src, metadata !"fpexcept.strict")
  ret <2 x i32> %retval
}

; CHECK-LABEL: fptoui_v2f16_to_v2u16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f16tof32 [[REGC:\$a[1-9]+]], $a0
; CHECK-NEXT:  f32int [[REGC]], [[REGC]]
; CHECK-NEXT:  f32toui32 [[REGC]], [[REGC]]
; CHECK-NEXT:  mov [[REGD:\$m[0-9]+]], [[REGC]]
; CHECK-NEXT:  swap16 [[REGA:\$a[0-9]+]], $a0
; CHECK-NEXT:  f16tof32 [[REGA]], [[REGA]]
; CHECK-NEXT:  f32int [[REGA]], [[REGA]]
; CHECK-NEXT:  f32toui32 [[REGA]], [[REGA]]
; CHECK-NEXT:  mov [[REGB:\$m[0-9]+]], [[REGA]]
; CHECK-NEXT:  sort4x16lo $m0, [[REGD]], [[REGB]]
; CHECK:       br $m10
define <2 x i16> @fptoui_v2f16_to_v2u16(<2 x half> %src) {
  %retval = fptoui <2 x half> %src to <2 x i16>
  ret <2 x i16> %retval
}

declare <2 x i16> @llvm.experimental.constrained.fptoui.v2u16.v2f16(<2 x half> %src, metadata)

; CHECK-LABEL: strict_fptoui_v2f16_to_v2u16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f16tof32 [[REGC:\$a[1-9]+]], $a0
; CHECK-NEXT:  f32int [[REGC]], [[REGC]]
; CHECK-NEXT:  f32toui32 [[REGC]], [[REGC]]
; CHECK-NEXT:  mov [[REGD:\$m[0-9]+]], [[REGC]]
; CHECK-NEXT:  swap16 [[REGA:\$a[0-9]+]], $a0
; CHECK-NEXT:  f16tof32 [[REGA]], [[REGA]]
; CHECK-NEXT:  f32int [[REGA]], [[REGA]]
; CHECK-NEXT:  f32toui32 [[REGA]], [[REGA]]
; CHECK-NEXT:  mov [[REGB:\$m[0-9]+]], [[REGA]]
; CHECK-NEXT:  sort4x16lo $m0, [[REGD]], [[REGB]]
; CHECK:       br $m10
define <2 x i16> @strict_fptoui_v2f16_to_v2u16(<2 x half> %src) {
  %retval = tail call <2 x i16> @llvm.experimental.constrained.fptoui.v2u16.v2f16(<2 x half> %src, metadata !"fpexcept.strict")
  ret <2 x i16> %retval
}

; CHECK-LABEL: fptoui_v2f16_to_v2u32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f16tof32 [[REGA:\$a[1-9]+]], $a0
; CHECK-NEXT:  f32int [[REGA]], [[REGA]]
; CHECK-NEXT:  f32toui32 [[REGA]], [[REGA]]
; CHECK-NEXT:  mov $m0, [[REGA]]
; CHECK-NEXT:  swap16 [[REGB:\$a[0-9]+]], $a0
; CHECK-NEXT:  f16tof32 [[REGB]], [[REGB]]
; CHECK-NEXT:  f32int [[REGB]], [[REGB]]
; CHECK-NEXT:  f32toui32 [[REGB]], [[REGB]]
; CHECK-NEXT:  mov $m1, [[REGB]]
; CHECK:       br $m10
define <2 x i32> @fptoui_v2f16_to_v2u32(<2 x half> %src) {
  %retval = fptoui <2 x half> %src to <2 x i32>
  ret <2 x i32> %retval
}

declare <2 x i32> @llvm.experimental.constrained.fptoui.v2u32.v2f16(<2 x half> %src, metadata)

; CHECK-LABEL: strict_fptoui_v2f16_to_v2u32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f16tof32 [[REGA:\$a[1-9]+]], $a0
; CHECK-NEXT:  f32int [[REGA]], [[REGA]]
; CHECK-NEXT:  f32toui32 [[REGA]], [[REGA]]
; CHECK-NEXT:  mov $m0, [[REGA]]
; CHECK-NEXT:  swap16 [[REGB:\$a[0-9]+]], $a0
; CHECK-NEXT:  f16tof32 [[REGB]], [[REGB]]
; CHECK-NEXT:  f32int [[REGB]], [[REGB]]
; CHECK-NEXT:  f32toui32 [[REGB]], [[REGB]]
; CHECK-NEXT:  mov $m1, [[REGB]]
; CHECK:       br $m10
define <2 x i32> @strict_fptoui_v2f16_to_v2u32(<2 x half> %src) {
  %retval = tail call <2 x i32> @llvm.experimental.constrained.fptoui.v2u32.v2f16(<2 x half> %src, metadata !"fpexcept.strict")
  ret <2 x i32> %retval
}

; CHECK-LABEL: fptosi_v2f32_to_v2i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f32int [[REGA:\$a[0-9]+]], $a1, 3
; CHECK-NEXT:  f32toi32 [[REGA]], [[REGA]]
; CHECK-NEXT:  mov [[REGB:\$m[0-9]+]], [[REGA]]
; CHECK-NEXT:  f32int [[REGC:\$a[0-9]+]], $a0, 3
; CHECK-NEXT:  f32toi32 [[REGC]], [[REGC]]
; CHECK-NEXT:  mov [[REGD:\$m[0-9]+]], [[REGC]]
; CHECK-NEXT:  sort4x16lo $m0, [[REGD]], [[REGB]]
; CHECK:       br $m10
define <2 x i16> @fptosi_v2f32_to_v2i16(<2 x float> %src) {
  %retval = fptosi <2 x float> %src to <2 x i16>
  ret <2 x i16> %retval
}

declare <2 x i16> @llvm.experimental.constrained.fptosi.v2i16.v2f32(<2 x float> %src, metadata)

; CHECK-LABEL: strict_fptosi_v2f32_to_v2i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f32int [[REGA:\$a[0-9]+]], $a1, 3
; CHECK-NEXT:  f32toi32 [[REGA]], [[REGA]]
; CHECK-NEXT:  mov [[REGB:\$m[0-9]+]], [[REGA]]
; CHECK-NEXT:  f32int [[REGC:\$a[0-9]+]], $a0, 3
; CHECK-NEXT:  f32toi32 [[REGC]], [[REGC]]
; CHECK-NEXT:  mov [[REGD:\$m[0-9]+]], [[REGC]]
; CHECK-NEXT:  sort4x16lo $m0, [[REGD]], [[REGB]]
; CHECK:       br $m10
define <2 x i16> @strict_fptosi_v2f32_to_v2i16(<2 x float> %src) {
  %retval = tail call <2 x i16> @llvm.experimental.constrained.fptosi.v2i16.v2f32(<2 x float> %src, metadata !"fpexcept.strict")
  ret <2 x i16> %retval
}

; CHECK-LABEL: fptosi_v2f32_to_v2i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f32int [[REGA:\$a[0-9]+]], $a0, 3
; CHECK-NEXT:  f32toi32 [[REGA]], [[REGA]]
; CHECK-NEXT:  mov $m0, [[REGA]]
; CHECK-NEXT:  f32int [[REGB:\$a[0-9]+]], $a1, 3
; CHECK-NEXT:  f32toi32 [[REGB]], [[REGB]]
; CHECK-NEXT:  mov $m1, [[REGB]]
; CHECK:       br $m10
define <2 x i32> @fptosi_v2f32_to_v2i32(<2 x float> %src) {
  %retval = fptosi <2 x float> %src to <2 x i32>
  ret <2 x i32> %retval
}

declare <2 x i32> @llvm.experimental.constrained.fptosi.v2i32.v2f32(<2 x float> %src, metadata)

; CHECK-LABEL: strict_fptosi_v2f32_to_v2i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f32int [[REGA:\$a[0-9]+]], $a0, 3
; CHECK-NEXT:  f32toi32 [[REGA]], [[REGA]]
; CHECK-NEXT:  mov $m0, [[REGA]]
; CHECK-NEXT:  f32int [[REGB:\$a[0-9]+]], $a1, 3
; CHECK-NEXT:  f32toi32 [[REGB]], [[REGB]]
; CHECK-NEXT:  mov $m1, [[REGB]]
; CHECK:       br $m10
define <2 x i32> @strict_fptosi_v2f32_to_v2i32(<2 x float> %src) {
  %retval = tail call <2 x i32> @llvm.experimental.constrained.fptosi.v2i32.v2f32(<2 x float> %src, metadata !"fpexcept.strict")
  ret <2 x i32> %retval
}

; CHECK-LABEL: fptoui_v2f32_to_v2u16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f32int [[REGA:\$a[0-9]+]], $a1, 3
; CHECK-NEXT:  f32toui32 [[REGA]], [[REGA]]
; CHECK-NEXT:  mov [[REGB:\$m[0-9]+]], [[REGA]]
; CHECK-NEXT:  f32int [[REGC:\$a[0-9]+]], $a0, 3
; CHECK-NEXT:  f32toui32 [[REGC]], [[REGC]]
; CHECK-NEXT:  mov [[REGD:\$m[0-9]+]], [[REGC]]
; CHECK-NEXT:  sort4x16lo $m0, [[REGD]], [[REGB]]
; CHECK:       br $m10
define <2 x i16> @fptoui_v2f32_to_v2u16(<2 x float> %src) {
  %retval = fptoui <2 x float> %src to <2 x i16>
  ret <2 x i16> %retval
}

declare <2 x i16> @llvm.experimental.constrained.fptoui.v2u16.v2f32(<2 x float> %src, metadata)

; CHECK-LABEL: strict_fptoui_v2f32_to_v2u16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f32int [[REGA:\$a[0-9]+]], $a1, 3
; CHECK-NEXT:  f32toui32 [[REGA]], [[REGA]]
; CHECK-NEXT:  mov [[REGB:\$m[0-9]+]], [[REGA]]
; CHECK-NEXT:  f32int [[REGC:\$a[0-9]+]], $a0, 3
; CHECK-NEXT:  f32toui32 [[REGC]], [[REGC]]
; CHECK-NEXT:  mov [[REGD:\$m[0-9]+]], [[REGC]]
; CHECK-NEXT:  sort4x16lo $m0, [[REGD]], [[REGB]]
; CHECK:       br $m10
define <2 x i16> @strict_fptoui_v2f32_to_v2u16(<2 x float> %src) {
  %retval = tail call <2 x i16> @llvm.experimental.constrained.fptoui.v2u16.v2f32(<2 x float> %src, metadata !"fpexcept.strict")
  ret <2 x i16> %retval
}

; CHECK-LABEL: fptoui_v2f32_to_v2u32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f32int [[REGA:\$a[0-9]+]], $a0, 3
; CHECK-NEXT:  f32toui32 [[REGA]], [[REGA]]
; CHECK-NEXT:  mov $m0, [[REGA]]
; CHECK-NEXT:  f32int [[REGB:\$a[0-9]+]], $a1, 3
; CHECK-NEXT:  f32toui32 [[REGB]], [[REGB]]
; CHECK-NEXT:  mov $m1, [[REGB]]
; CHECK:       br $m10
define <2 x i32> @fptoui_v2f32_to_v2u32(<2 x float> %src) {
  %retval = fptoui <2 x float> %src to <2 x i32>
  ret <2 x i32> %retval
}

declare <2 x i32> @llvm.experimental.constrained.fptoui.v2u32.v2f32(<2 x float> %src, metadata)

; CHECK-LABEL: strict_fptoui_v2f32_to_v2u32:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f32int [[REGA:\$a[0-9]+]], $a0, 3
; CHECK-NEXT:  f32toui32 [[REGA]], [[REGA]]
; CHECK-NEXT:  mov $m0, [[REGA]]
; CHECK-NEXT:  f32int [[REGB:\$a[0-9]+]], $a1, 3
; CHECK-NEXT:  f32toui32 [[REGB]], [[REGB]]
; CHECK-NEXT:  mov $m1, [[REGB]]
; CHECK:       br $m10
define <2 x i32> @strict_fptoui_v2f32_to_v2u32(<2 x float> %src) {
  %retval = tail call <2 x i32> @llvm.experimental.constrained.fptoui.v2u32.v2f32(<2 x float> %src, metadata !"fpexcept.strict")
  ret <2 x i32> %retval
}

; CHECK-LABEL: sitofp_v4i16_to_v4f16:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; High half of high half
; CHECK:       shrs [[REGA:\$m[2-9]+]], $m1, 16
; CHECK-NEXT:  st32 [[REGA]], $m11, $m15, 1
; CHECK-NEXT:  ld32 [[REGB:\$a[0-9]+]], $m11, $m15, 1
; CHECK-NEXT:  f32fromi32 [[REGB]], [[REGB]]
; CHECK-NEXT:  f32tof16 [[REGB]], [[REGB]]
; Low half of high half
; CHECK-NEXT:  shl [[REGC:\$m[1-9]+]], $m1, 16
; CHECK-NEXT:  shrs [[REGC]], [[REGC]], 16
; CHECK-NEXT:  st32 [[REGC]], $m11, $m15, 1
; CHECK-NEXT:  ld32 [[REGD:\$a[0-9]+]], $m11, $m15, 1
; CHECK-NEXT:  f32fromi32 [[REGD]], [[REGD]]
; CHECK-NEXT:  f32tof16 [[REGD]], [[REGD]]
; Reassemble
; CHECK-NEXT:  sort4x16lo $a1, [[REGD]], [[REGB]]
; High half of low half
; CHECK-NEXT:  shrs [[REGE:\$m[1-9]+]], $m0, 16
; CHECK-NEXT:  st32 [[REGE]], $m11, $m15, 1
; CHECK-NEXT:  ld32 [[REGF:\$a[0-9]+]], $m11, $m15, 1
; CHECK-NEXT:  f32fromi32 [[REGF]], [[REGF]]
; CHECK-NEXT:  f32tof16 [[REGF]], [[REGF]]
; Low half of low half
; CHECK-NEXT:  shl [[REGG:\$m[0-9]+]], $m0, 16
; CHECK-NEXT:  shrs [[REGG]], [[REGG]], 16
; CHECK-NEXT:  st32 [[REGG]], $m11, $m15, 1
; CHECK-NEXT:  ld32 [[REGH:\$a[0-9]+]], $m11, $m15, 1
; CHECK-NEXT:  f32fromi32 [[REGH]], [[REGH]]
; CHECK-NEXT:  f32tof16 [[REGH]], [[REGH]]
; Reassemble
; CHECK-NEXT:  sort4x16lo $a0, [[REGH]], [[REGF]]
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10
define <4 x half> @sitofp_v4i16_to_v4f16(<4 x i16> %src) {
  %retval = sitofp <4 x i16> %src to <4 x half>
  ret <4 x half> %retval
}

declare <4 x half> @llvm.experimental.constrained.sitofp.v4f16.v4i16(<4 x i16> %src, metadata, metadata)

; CHECK-LABEL: strict_sitofp_v4i16_to_v4f16:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; High half of high half
; CHECK:       shrs [[REGA:\$m[2-9]+]], $m1, 16
; CHECK-NEXT:  st32 [[REGA]], $m11, $m15, 1
; CHECK-NEXT:  ld32 [[REGB:\$a[0-9]+]], $m11, $m15, 1
; CHECK-NEXT:  f32fromi32 [[REGB]], [[REGB]]
; CHECK-NEXT:  f32tof16 [[REGB]], [[REGB]]
; Low half of high half
; CHECK-NEXT:  shl [[REGC:\$m[1-9]+]], $m1, 16
; CHECK-NEXT:  shrs [[REGC]], [[REGC]], 16
; CHECK-NEXT:  st32 [[REGC]], $m11, $m15, 1
; CHECK-NEXT:  ld32 [[REGD:\$a[0-9]+]], $m11, $m15, 1
; CHECK-NEXT:  f32fromi32 [[REGD]], [[REGD]]
; CHECK-NEXT:  f32tof16 [[REGD]], [[REGD]]
; Reassemble
; CHECK-NEXT:  sort4x16lo $a1, [[REGD]], [[REGB]]
; High half of low half
; CHECK-NEXT:  shrs [[REGE:\$m[1-9]+]], $m0, 16
; CHECK-NEXT:  st32 [[REGE]], $m11, $m15, 1
; CHECK-NEXT:  ld32 [[REGF:\$a[0-9]+]], $m11, $m15, 1
; CHECK-NEXT:  f32fromi32 [[REGF]], [[REGF]]
; CHECK-NEXT:  f32tof16 [[REGF]], [[REGF]]
; Low half of low half
; CHECK-NEXT:  shl [[REGG:\$m[0-9]+]], $m0, 16
; CHECK-NEXT:  shrs [[REGG]], [[REGG]], 16
; CHECK-NEXT:  st32 [[REGG]], $m11, $m15, 1
; CHECK-NEXT:  ld32 [[REGH:\$a[0-9]+]], $m11, $m15, 1
; CHECK-NEXT:  f32fromi32 [[REGH]], [[REGH]]
; CHECK-NEXT:  f32tof16 [[REGH]], [[REGH]]
; Reassemble
; CHECK-NEXT:  sort4x16lo $a0, [[REGH]], [[REGF]]
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10
define <4 x half> @strict_sitofp_v4i16_to_v4f16(<4 x i16> %src) {
  %retval = tail call <4 x half> @llvm.experimental.constrained.sitofp.v4f16.v4i16(<4 x i16> %src, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <4 x half> %retval
}

; CHECK-LABEL: uitofp_v4u16_to_v4f16:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; High half of high half
; CHECK:       sort4x16hi [[REGA:\$m[2-9]+]], $m1, $m15
; Zero extended by above sort4x16
; CHECK-NEXT:  st32 [[REGA]], $m11, $m15, 1
; CHECK-NEXT:  ld32 [[REGB:\$a[0-9]+]], $m11, $m15, 1
; CHECK-NEXT:  f32fromui32 [[REGB]], [[REGB]]
; CHECK-NEXT:  f32tof16 [[REGB]], [[REGB]]
; Low half of high half
; CHECK-NEXT:  sort4x16lo [[REGC:\$m[1-9]+]], $m1, $m15
; CHECK-NEXT:  st32 [[REGC]], $m11, $m15, 1
; CHECK-NEXT:  ld32 [[REGD:\$a[0-9]+]], $m11, $m15, 1
; CHECK-NEXT:  f32fromui32 [[REGD]], [[REGD]]
; CHECK-NEXT:  f32tof16 [[REGD]], [[REGD]]
; Reassemble
; CHECK-NEXT:  sort4x16lo $a1, [[REGD]], [[REGB]]
; High half of low half
; CHECK-NEXT:  sort4x16hi [[REGE:\$m[1-9]+]], $m0
; Zero extended by above sort4x16
; CHECK-NEXT:  st32 [[REGE]], $m11, $m15, 1
; CHECK-NEXT:  ld32 [[REGF:\$a[0-9]+]], $m11, $m15, 1
; CHECK-NEXT:  f32fromui32 [[REGF]], [[REGF]]
; CHECK-NEXT:  f32tof16 [[REGF]], [[REGF]]
; Low half of low half
; CHECK-NEXT:  sort4x16lo [[REGG:\$m[0-9]+]], $m0
; Zero extended by above sort4x16
; CHECK-NEXT:  st32 [[REGG]], $m11, $m15, 1
; CHECK-NEXT:  ld32 [[REGH:\$a[0-9]+]], $m11, $m15, 1
; CHECK-NEXT:  f32fromui32 [[REGH]], [[REGH]]
; CHECK-NEXT:  f32tof16 [[REGH]], [[REGH]]
; Reassemble
; CHECK-NEXT:  sort4x16lo $a0, [[REGH]], [[REGF]]
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10
define <4 x half> @uitofp_v4u16_to_v4f16(<4 x i16> %src) {
  %retval = uitofp <4 x i16> %src to <4 x half>
  ret <4 x half> %retval
}

declare <4 x half> @llvm.experimental.constrained.uitofp.v4f16.v4u16(<4 x i16> %src, metadata, metadata)

; CHECK-LABEL: strict_uitofp_v4u16_to_v4f16:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; High half of high half
; CHECK:       sort4x16hi [[REGA:\$m[2-9]+]], $m1, $m15
; Zero extended by above sort4x16
; CHECK-NEXT:  st32 [[REGA]], $m11, $m15, 1
; CHECK-NEXT:  ld32 [[REGB:\$a[0-9]+]], $m11, $m15, 1
; CHECK-NEXT:  f32fromui32 [[REGB]], [[REGB]]
; CHECK-NEXT:  f32tof16 [[REGB]], [[REGB]]
; Low half of high half
; CHECK-NEXT:  sort4x16lo [[REGC:\$m[1-9]+]], $m1, $m15
; CHECK-NEXT:  st32 [[REGC]], $m11, $m15, 1
; CHECK-NEXT:  ld32 [[REGD:\$a[0-9]+]], $m11, $m15, 1
; CHECK-NEXT:  f32fromui32 [[REGD]], [[REGD]]
; CHECK-NEXT:  f32tof16 [[REGD]], [[REGD]]
; Reassemble
; CHECK-NEXT:  sort4x16lo $a1, [[REGD]], [[REGB]]
; High half of low half
; CHECK-NEXT:  sort4x16hi [[REGE:\$m[1-9]+]], $m0
; Zero extended by above sort4x16
; CHECK-NEXT:  st32 [[REGE]], $m11, $m15, 1
; CHECK-NEXT:  ld32 [[REGF:\$a[0-9]+]], $m11, $m15, 1
; CHECK-NEXT:  f32fromui32 [[REGF]], [[REGF]]
; CHECK-NEXT:  f32tof16 [[REGF]], [[REGF]]
; Low half of low half
; CHECK-NEXT:  sort4x16lo [[REGG:\$m[0-9]+]], $m0
; Zero extended by above sort4x16
; CHECK-NEXT:  st32 [[REGG]], $m11, $m15, 1
; CHECK-NEXT:  ld32 [[REGH:\$a[0-9]+]], $m11, $m15, 1
; CHECK-NEXT:  f32fromui32 [[REGH]], [[REGH]]
; CHECK-NEXT:  f32tof16 [[REGH]], [[REGH]]
; Reassemble
; CHECK-NEXT:  sort4x16lo $a0, [[REGH]], [[REGF]]
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10
define <4 x half> @strict_uitofp_v4u16_to_v4f16(<4 x i16> %src) {
  %retval = tail call <4 x half> @llvm.experimental.constrained.uitofp.v4f16.v4u16(<4 x i16> %src, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <4 x half> %retval
}

; CHECK-LABEL: fptosi_v4f16_to_v4i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f16tof32 [[REGC:\$a[2-9]+]], $a1
; CHECK-NEXT:  f32int [[REGC]], [[REGC]]
; CHECK-NEXT:  f32toi32 [[REGC]], [[REGC]]
; CHECK-NEXT:  mov [[REGD:\$m[0-9]+]], [[REGC]]
; CHECK-NEXT:  swap16 [[REGA:\$a[1-9]+]], $a1
; CHECK-NEXT:  f16tof32 [[REGA]], [[REGA]]
; CHECK-NEXT:  f32int [[REGA]], [[REGA]]
; CHECK-NEXT:  f32toi32 [[REGA]], [[REGA]]
; CHECK-NEXT:  mov [[REGB:\$m[0-9]+]], [[REGA]]
; CHECK-NEXT:  sort4x16lo $m1, [[REGD]], [[REGB]]
; CHECK-NEXT:  f16tof32 [[REGG:\$a[1-9]+]], $a0
; CHECK-NEXT:  f32int [[REGG]], [[REGG]]
; CHECK-NEXT:  f32toi32 [[REGG]], [[REGG]]
; CHECK-NEXT:  mov [[REGH:\$m[0-9]+]], [[REGG]]
; CHECK-NEXT:  swap16 [[REGE:\$a[0-9]+]], $a0
; CHECK-NEXT:  f16tof32 [[REGE]], [[REGE]]
; CHECK-NEXT:  f32int [[REGE]], [[REGE]]
; CHECK-NEXT:  f32toi32 [[REGE]], [[REGE]]
; CHECK-NEXT:  mov [[REGF:\$m[0-9]+]], [[REGE]]
; CHECK-NEXT:  sort4x16lo $m0, [[REGH]], [[REGF]]
; CHECK:       br $m10
define <4 x i16> @fptosi_v4f16_to_v4i16(<4 x half> %src) {
  %retval = fptosi <4 x half> %src to <4 x i16>
  ret <4 x i16> %retval
}

declare <4 x i16> @llvm.experimental.constrained.fptosi.v4i16.v4f16(<4 x half> %src, metadata)

; CHECK-LABEL: strict_fptosi_v4f16_to_v4i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f16tof32 [[REGC:\$a[2-9]+]], $a1
; CHECK-NEXT:  f32int [[REGC]], [[REGC]]
; CHECK-NEXT:  f32toi32 [[REGC]], [[REGC]]
; CHECK-NEXT:  mov [[REGD:\$m[0-9]+]], [[REGC]]
; CHECK-NEXT:  swap16 [[REGA:\$a[1-9]+]], $a1
; CHECK-NEXT:  f16tof32 [[REGA]], [[REGA]]
; CHECK-NEXT:  f32int [[REGA]], [[REGA]]
; CHECK-NEXT:  f32toi32 [[REGA]], [[REGA]]
; CHECK-NEXT:  mov [[REGB:\$m[0-9]+]], [[REGA]]
; CHECK-NEXT:  sort4x16lo $m1, [[REGD]], [[REGB]]
; CHECK-NEXT:  f16tof32 [[REGG:\$a[1-9]+]], $a0
; CHECK-NEXT:  f32int [[REGG]], [[REGG]]
; CHECK-NEXT:  f32toi32 [[REGG]], [[REGG]]
; CHECK-NEXT:  mov [[REGH:\$m[0-9]+]], [[REGG]]
; CHECK-NEXT:  swap16 [[REGE:\$a[0-9]+]], $a0
; CHECK-NEXT:  f16tof32 [[REGE]], [[REGE]]
; CHECK-NEXT:  f32int [[REGE]], [[REGE]]
; CHECK-NEXT:  f32toi32 [[REGE]], [[REGE]]
; CHECK-NEXT:  mov [[REGF:\$m[0-9]+]], [[REGE]]
; CHECK-NEXT:  sort4x16lo $m0, [[REGH]], [[REGF]]
; CHECK:       br $m10
define <4 x i16> @strict_fptosi_v4f16_to_v4i16(<4 x half> %src) {
  %retval = tail call <4 x i16> @llvm.experimental.constrained.fptosi.v4i16.v4f16(<4 x half> %src, metadata !"fpexcept.strict")
  ret <4 x i16> %retval
}

; CHECK-LABEL: fptoui_v4f16_to_v4u16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f16tof32 [[REGC:\$a[2-9]+]], $a1
; CHECK-NEXT:  f32int [[REGC]], [[REGC]]
; CHECK-NEXT:  f32toui32 [[REGC]], [[REGC]]
; CHECK-NEXT:  mov [[REGD:\$m[0-9]+]], [[REGC]]
; CHECK-NEXT:  swap16 [[REGA:\$a[1-9]+]], $a1
; CHECK-NEXT:  f16tof32 [[REGA]], [[REGA]]
; CHECK-NEXT:  f32int [[REGA]], [[REGA]]
; CHECK-NEXT:  f32toui32 [[REGA]], [[REGA]]
; CHECK-NEXT:  mov [[REGB:\$m[0-9]+]], [[REGA]]
; CHECK-NEXT:  sort4x16lo $m1, [[REGD]], [[REGB]]
; CHECK-NEXT:  f16tof32 [[REGG:\$a[1-9]+]], $a0
; CHECK-NEXT:  f32int [[REGG]], [[REGG]]
; CHECK-NEXT:  f32toui32 [[REGG]], [[REGG]]
; CHECK-NEXT:  mov [[REGH:\$m[0-9]+]], [[REGG]]
; CHECK-NEXT:  swap16 [[REGE:\$a[0-9]+]], $a0
; CHECK-NEXT:  f16tof32 [[REGE]], [[REGE]]
; CHECK-NEXT:  f32int [[REGE]], [[REGE]]
; CHECK-NEXT:  f32toui32 [[REGE]], [[REGE]]
; CHECK-NEXT:  mov [[REGF:\$m[0-9]+]], [[REGE]]
; CHECK-NEXT:  sort4x16lo $m0, [[REGH]], [[REGF]]
; CHECK:       br $m10
define <4 x i16> @fptoui_v4f16_to_v4u16(<4 x half> %src) {
  %retval = fptoui <4 x half> %src to <4 x i16>
  ret <4 x i16> %retval
}

declare <4 x i16> @llvm.experimental.constrained.fptoui.v4u16.v4f16(<4 x half> %src, metadata)

; CHECK-LABEL: strict_fptoui_v4f16_to_v4u16:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f16tof32 [[REGC:\$a[2-9]+]], $a1
; CHECK-NEXT:  f32int [[REGC]], [[REGC]]
; CHECK-NEXT:  f32toui32 [[REGC]], [[REGC]]
; CHECK-NEXT:  mov [[REGD:\$m[0-9]+]], [[REGC]]
; CHECK-NEXT:  swap16 [[REGA:\$a[1-9]+]], $a1
; CHECK-NEXT:  f16tof32 [[REGA]], [[REGA]]
; CHECK-NEXT:  f32int [[REGA]], [[REGA]]
; CHECK-NEXT:  f32toui32 [[REGA]], [[REGA]]
; CHECK-NEXT:  mov [[REGB:\$m[0-9]+]], [[REGA]]
; CHECK-NEXT:  sort4x16lo $m1, [[REGD]], [[REGB]]
; CHECK-NEXT:  f16tof32 [[REGG:\$a[1-9]+]], $a0
; CHECK-NEXT:  f32int [[REGG]], [[REGG]]
; CHECK-NEXT:  f32toui32 [[REGG]], [[REGG]]
; CHECK-NEXT:  mov [[REGH:\$m[0-9]+]], [[REGG]]
; CHECK-NEXT:  swap16 [[REGE:\$a[0-9]+]], $a0
; CHECK-NEXT:  f16tof32 [[REGE]], [[REGE]]
; CHECK-NEXT:  f32int [[REGE]], [[REGE]]
; CHECK-NEXT:  f32toui32 [[REGE]], [[REGE]]
; CHECK-NEXT:  mov [[REGF:\$m[0-9]+]], [[REGE]]
; CHECK-NEXT:  sort4x16lo $m0, [[REGH]], [[REGF]]
; CHECK:       br $m10
define <4 x i16> @strict_fptoui_v4f16_to_v4u16(<4 x half> %src) {
  %retval = tail call <4 x i16> @llvm.experimental.constrained.fptoui.v4u16.v4f16(<4 x half> %src, metadata !"fpexcept.strict")
  ret <4 x i16> %retval
}
