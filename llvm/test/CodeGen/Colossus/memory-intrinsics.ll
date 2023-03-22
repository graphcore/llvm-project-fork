; RUN: llc < %s -march=colossus -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -march=colossus -mattr=+ipu2 | FileCheck %s

declare ptr @llvm.colossus.ststep.v4f16(<4 x half>, ptr, i32)
declare {<4 x half>, ptr} @llvm.colossus.ldstep.v4f16(ptr, i32)
declare float @llvm.experimental.constrained.fpext.f32.f16(half %src, metadata)

; CHECK-LABEL: call_ststep_v4f16_reg:
; CHECK:       st64step $a0:1, $m15, $m0+=, $m1
; CHECK-NEXT:  br $m10
define ptr @call_ststep_v4f16_reg(<4 x half> %value, ptr %base, i32 %incr) {
  %res = call ptr @llvm.colossus.ststep.v4f16(<4 x half> %value, ptr %base, i32 %incr)
  ret ptr %res
}

; CHECK-LABEL: call_ststep_v4f16:
; CHECK:       st64step $a0:1, $m15, $m0+=, 127
; CHECK-NEXT:  br $m10
define ptr @call_ststep_v4f16(<4 x half> %value, ptr %base) {
  %res = call ptr @llvm.colossus.ststep.v4f16(<4 x half> %value, ptr %base, i32 127)
  ret ptr %res
}

; CHECK-LABEL: call_ldstep_v4f16_reg:
; CHECK:       ld64step $a0:1, $m15, $m0+=, $m1
; CHECK-NEXT:  br $m10
define {<4 x half>, ptr} @call_ldstep_v4f16_reg(ptr %base, i32 %incr) {
  %res = call {<4 x half>, ptr} @llvm.colossus.ldstep.v4f16(ptr %base, i32 %incr)
  ret {<4 x half>, ptr} %res
}

; CHECK-LABEL: call_ldstep_v4f16:
; CHECK:       ld64step $a0:1, $m15, $m0+=, -128
; CHECK-NEXT:  br $m10
define {<4 x half>, ptr} @call_ldstep_v4f16(ptr %base) {
  %res = call {<4 x half>, ptr} @llvm.colossus.ldstep.v4f16(ptr %base, i32 -128)
  ret {<4 x half>, ptr} %res
}

declare ptr @llvm.colossus.ststep.v2f32(<2 x float>, ptr, i32)
declare {<2 x float>, ptr} @llvm.colossus.ldstep.v2f32(ptr, i32)

; CHECK-LABEL: call_ststep_v2f32_reg:
; CHECK:       st64step $a0:1, $m15, $m0+=, $m1
; CHECK-NEXT:  br $m10
define ptr @call_ststep_v2f32_reg(<2 x float> %value, ptr %base, i32 %incr) {
  %res = call ptr @llvm.colossus.ststep.v2f32(<2 x float> %value, ptr %base, i32 %incr)
  ret ptr %res
}

; CHECK-LABEL: call_ststep_v2f32:
; CHECK:       st64step $a0:1, $m15, $m0+=, 1
; CHECK-NEXT:  br $m10
define ptr @call_ststep_v2f32(<2 x float> %value, ptr %base) {
  %res = call ptr @llvm.colossus.ststep.v2f32(<2 x float> %value, ptr %base, i32 1)
  ret ptr %res
}

; CHECK-LABEL: call_ldstep_v2f32_reg:
; CHECK:       ld64step $a0:1, $m15, $m0+=, $m1
; CHECK-NEXT:  br $m10
define {<2 x float>, ptr} @call_ldstep_v2f32_reg(ptr %base, i32 %incr) {
  %res = call {<2 x float>, ptr} @llvm.colossus.ldstep.v2f32( ptr %base, i32 %incr)
  ret {<2 x float>, ptr} %res
}

; CHECK-LABEL: call_ldstep_v2f32:
; CHECK:       ld64step $a0:1, $m15, $m0+=, 42
; CHECK-NEXT:  br $m10
define {<2 x float>, ptr} @call_ldstep_v2f32(ptr %base) {
  %res = call {<2 x float>, ptr} @llvm.colossus.ldstep.v2f32( ptr %base, i32 42)
  ret {<2 x float>, ptr} %res
}

declare ptr @llvm.colossus.ststep.v4i16(<4 x i16>, ptr, i32)
declare {<4 x i16>, ptr} @llvm.colossus.ldstep.v4i16(ptr, i32)

; CHECK-LABEL: call_ststep_v4i16_reg:
; CHECK:       shl $m3, $m3, 3
; CHECK-NEXT:  add $m3, $m2, $m3
; CHECK-NEXT:  st32 $m1, $m2, $m15, 1
; CHECK-NEXT:  st32 $m0, $m2, $m15, 0
; CHECK-NEXT:  mov $m0, $m3
; CHECK-NEXT:  br $m10
define ptr @call_ststep_v4i16_reg(<4 x i16> %value, ptr %base, i32 %incr) {
  %res = call ptr @llvm.colossus.ststep.v4i16(<4 x i16> %value, ptr %base, i32 %incr)
  ret ptr %res
}

; CHECK-LABEL: call_ststep_v4i16:
; CHECK:       st32 $m1, $m2, $m15, 1
; CHECK-NEXT:  st32 $m0, $m2, $m15, 0
; CHECK-NEXT:  add $m0, $m2, 1016
; CHECK-NEXT:  br $m10
define ptr @call_ststep_v4i16(<4 x i16> %value, ptr %base) {
  %res = call ptr @llvm.colossus.ststep.v4i16(<4 x i16> %value, ptr %base, i32 127)
  ret ptr %res
}

; The mov should be removed by T2123
; CHECK-LABEL: call_ldstep_v4i16_reg:
; CHECK:       shl $m1, $m1, 3
; CHECK-NEXT:  ld32 [[M0:\$m[0-9]+]], $m0, $m15, 0
; CHECK-NEXT:  add $m2, $m0, $m1
; CHECK-NEXT:  ld32 [[M1:\$m[0-9]+]], $m0, $m15, 1
; CHECK-NEXT:  mov $m0, [[M0]]
; CHECK-NEXT:  mov $m1, [[M1]]
; CHECK-NEXT:  br $m10
define {<4 x i16>, ptr} @call_ldstep_v4i16_reg(ptr %base, i32 %incr) {
  %res = call {<4 x i16>, ptr} @llvm.colossus.ldstep.v4i16( ptr %base, i32 %incr)
  ret {<4 x i16>, ptr} %res
}

; CHECK-LABEL: call_ldstep_v4i16:
; CHECK:       ld32 [[M0:\$m[0-9]+]], $m0, $m15, 0
; CHECK-NEXT:  ld32 [[M1:\$m[0-9]+]], $m0, $m15, 1
; CHECK-NEXT:  add $m2, $m0, -1024
; CHECK-NEXT:  mov $m0, [[M0]]
; CHECK-NEXT:  mov $m1, [[M1]]
; CHECK-NEXT:  br $m10
define {<4 x i16>, ptr} @call_ldstep_v4i16(ptr %base) {
  %res = call {<4 x i16>, ptr} @llvm.colossus.ldstep.v4i16( ptr %base, i32 -128)
  ret {<4 x i16>, ptr} %res
}

declare ptr @llvm.colossus.ststep.v2i32(<2 x i32>, ptr, i32)
declare {<2 x i32>, ptr} @llvm.colossus.ldstep.v2i32(ptr, i32)

; CHECK-LABEL: call_ststep_v2i32_reg:
; CHECK:       shl $m3, $m3, 3
; CHECK-NEXT:  add $m3, $m2, $m3
; CHECK-NEXT:  st32 $m1, $m2, $m15, 1
; CHECK-NEXT:  st32 $m0, $m2, $m15, 0
; CHECK-NEXT:  mov $m0, $m3
; CHECK-NEXT:  br $m10
define ptr @call_ststep_v2i32_reg(<2 x i32> %value, ptr %base, i32 %incr) {
  %res = call ptr @llvm.colossus.ststep.v2i32(<2 x i32> %value, ptr %base, i32 %incr)
  ret ptr %res
}

; CHECK-LABEL: call_ststep_v2i32:
; CHECK:       st32 $m1, $m2, $m15, 1
; CHECK-NEXT:  st32 $m0, $m2, $m15, 0
; CHECK-NEXT:  add $m0, $m2, 8
; CHECK-NEXT:  br $m10
define ptr @call_ststep_v2i32(<2 x i32> %value, ptr %base) {
  %res = call ptr @llvm.colossus.ststep.v2i32(<2 x i32> %value, ptr %base, i32 1)
  ret ptr %res
}

; CHECK-LABEL: call_ldstep_v2i32_reg:
; CHECK:       shl $m1, $m1, 3
; CHECK-NEXT:  ld32 [[M0:\$m[0-9]+]], $m0, $m15, 0
; CHECK-NEXT:  add $m2, $m0, $m1
; CHECK-NEXT:  ld32 [[M1:\$m[0-9]+]], $m0, $m15, 1
; CHECK-NEXT:  mov $m0, [[M0]]
; CHECK-NEXT:  mov $m1, [[M1]]
; CHECK-NEXT:  br $m10
define {<2 x i32>, ptr} @call_ldstep_v2i32_reg(ptr %base, i32 %incr) {
  %res = call {<2 x i32>, ptr} @llvm.colossus.ldstep.v2i32( ptr %base, i32 %incr)
  ret {<2 x i32>, ptr} %res
}

; CHECK-LABEL: call_ldstep_v2i32:
; CHECK:       ld32 [[M0:\$m[0-9]+]], $m0, $m15, 0
; CHECK-NEXT:  ld32 [[M1:\$m[0-9]+]], $m0, $m15, 1
; CHECK-NEXT:  add $m2, $m0, 336
; CHECK-NEXT:  mov $m0, [[M0]]
; CHECK-NEXT:  mov $m1, [[M1]]
; CHECK-NEXT:  br $m10
define {<2 x i32>, ptr} @call_ldstep_v2i32(ptr %base) {
  %res = call {<2 x i32>, ptr} @llvm.colossus.ldstep.v2i32( ptr %base, i32 42)
  ret {<2 x i32>, ptr} %res
}

declare ptr @llvm.colossus.ststep.v2f16(<2 x half>, ptr, i32)
declare {<2 x half>, ptr} @llvm.colossus.ldstep.v2f16(ptr, i32)

; CHECK-LABEL: call_ststep_v2f16_reg:
; CHECK:       st32step $a0, $m15, $m0+=, $m1
; CHECK-NEXT:  br $m10
define ptr @call_ststep_v2f16_reg(<2 x half> %value, ptr %base, i32 %incr) {
  %res = call ptr @llvm.colossus.ststep.v2f16(<2 x half> %value, ptr %base, i32 %incr)
  ret ptr %res
}

; CHECK-LABEL: call_ststep_v2f16:
; CHECK:       st32step $a0, $m15, $m0+=, 42
; CHECK-NEXT:  br $m10
define ptr @call_ststep_v2f16(<2 x half> %value, ptr %base) {
  %res = call ptr @llvm.colossus.ststep.v2f16(<2 x half> %value, ptr %base, i32 42)
  ret ptr %res
}

; CHECK-LABEL: call_ldstep_v2f16_reg:
; CHECK:       ld32step $a0, $m15, $m0+=, $m1
; CHECK-NEXT:  br $m10
define {<2 x half>, ptr} @call_ldstep_v2f16_reg(ptr %base, i32 %incr) {
  %res = call {<2 x half>, ptr} @llvm.colossus.ldstep.v2f16( ptr %base, i32 %incr)
  ret {<2 x half>, ptr} %res
}

; CHECK-LABEL: call_ldstep_v2f16:
; CHECK:       ld32step $a0, $m15, $m0+=, 42
; CHECK-NEXT:  br $m10
define {<2 x half>, ptr} @call_ldstep_v2f16(ptr %base) {
  %res = call {<2 x half>, ptr} @llvm.colossus.ldstep.v2f16( ptr %base, i32 42)
  ret {<2 x half>, ptr} %res
}

declare {half, half*} @llvm.colossus.ldstep.f16(half*, i32)

; CHECK-LABEL: call_ldstep_f16_reg:
; CHECK:       ldb16step $a0, $m15, $m0+=, $m1
; CHECK-NEXT:  br $m10
define {half, half*} @call_ldstep_f16_reg(half* %base, i32 %incr) {
  %res = call {half, half*} @llvm.colossus.ldstep.f16(half* %base, i32 %incr)
  ret {half, half*} %res
}

; CHECK-LABEL: call_ldstep_f16:
; CHECK:       ldb16step $a0, $m15, $m0+=, 42
; CHECK-NEXT:  br $m10
define {half, half*} @call_ldstep_f16(half* %base) {
  %res = call {half, half*} @llvm.colossus.ldstep.f16(half* %base, i32 42)
  ret {half, half*} %res
}

; CHECK-LABEL: call_ldstep_f16_to_f32_reg:
; CHECK:       ldb16step $a0, $m15, $m0+=, $m1
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16tof32 $a0, $a0
; CHECK-NEXT:  }
define {float, half*} @call_ldstep_f16_to_f32_reg(half* %base, i32 %incr) {
  %res = call {half, half*} @llvm.colossus.ldstep.f16(half* %base, i32 %incr)

  %reslo = extractvalue {half, half*} %res, 0
  %reshi = extractvalue {half, half*} %res, 1

  %reslof32 = fpext half %reslo to float

  %tmp = insertvalue {float, half*} undef, float %reslof32, 0
  %tmp1 = insertvalue {float, half*} %tmp, half* %reshi, 1

  ret {float, half*} %tmp1
}

; CHECK-LABEL: call_ldstep_strict_f16_to_f32_reg:
; CHECK:       ldb16step $a0, $m15, $m0+=, $m1
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16tof32 $a0, $a0
; CHECK-NEXT:  }
define {float, half*} @call_ldstep_strict_f16_to_f32_reg(half* %base, i32 %incr) {
  %res = call {half, half*} @llvm.colossus.ldstep.f16(half* %base, i32 %incr)

  %reslo = extractvalue {half, half*} %res, 0
  %reshi = extractvalue {half, half*} %res, 1

  %reslof32 = tail call float @llvm.experimental.constrained.fpext.f32.f16(half %reslo, metadata !"fpexcept.strict")

  %tmp = insertvalue {float, half*} undef, float %reslof32, 0
  %tmp1 = insertvalue {float, half*} %tmp, half* %reshi, 1

  ret {float, half*} %tmp1
}

; CHECK-LABEL: call_ldstep_f16_to_f32:
; CHECK:       ldb16step $a0, $m15, $m0+=, 42
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16tof32 $a0, $a0
; CHECK-NEXT:  }
define {float, half*} @call_ldstep_f16_to_f32(half* %base) {
  %res = call {half, half*} @llvm.colossus.ldstep.f16(half* %base, i32 42)

  %reslo = extractvalue {half, half*} %res, 0
  %reshi = extractvalue {half, half*} %res, 1

  %reslof32 = fpext half %reslo to float

  %tmp = insertvalue {float, half*} undef, float %reslof32, 0
  %tmp1 = insertvalue {float, half*} %tmp, half* %reshi, 1

  ret {float, half*} %tmp1
}

; CHECK-LABEL: call_ldstep_strict_f16_to_f32:
; CHECK:       ldb16step $a0, $m15, $m0+=, 42
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16tof32 $a0, $a0
; CHECK-NEXT:  }
define {float, half*} @call_ldstep_strict_f16_to_f32(half* %base) {
  %res = call {half, half*} @llvm.colossus.ldstep.f16(half* %base, i32 42)

  %reslo = extractvalue {half, half*} %res, 0
  %reshi = extractvalue {half, half*} %res, 1

  %reslof32 = tail call float @llvm.experimental.constrained.fpext.f32.f16(half %reslo, metadata !"fpexcept.strict")

  %tmp = insertvalue {float, half*} undef, float %reslof32, 0
  %tmp1 = insertvalue {float, half*} %tmp, half* %reshi, 1

  ret {float, half*} %tmp1
}

declare float* @llvm.colossus.ststep.f32(float, float*, i32)
declare {float, float*} @llvm.colossus.ldstep.f32(float*, i32)

; CHECK-LABEL: call_ststep_f32_reg:
; CHECK:       st32step $a0, $m15, $m0+=, $m1
; CHECK-NEXT:  br $m10
define float* @call_ststep_f32_reg(float %value, float* %base, i32 %incr) {
  %res = call float* @llvm.colossus.ststep.f32(float %value, float* %base, i32 %incr)
  ret float* %res
}

; CHECK-LABEL: call_ststep_f32:
; CHECK:       st32step $a0, $m15, $m0+=, 42
; CHECK-NEXT:  br $m10
define float* @call_ststep_f32(float %value, float* %base) {
  %res = call float* @llvm.colossus.ststep.f32(float %value, float* %base, i32 42)
  ret float* %res
}

; CHECK-LABEL: call_ldstep_f32_reg:
; CHECK:       ld32step $a0, $m15, $m0+=, $m1
; CHECK-NEXT:  br $m10
define {float, float*} @call_ldstep_f32_reg(float* %base, i32 %incr) {
  %res = call {float, float*} @llvm.colossus.ldstep.f32( float* %base, i32 %incr)
  ret {float, float*} %res
}

; CHECK-LABEL: call_ldstep_f32:
; CHECK:       ld32step $a0, $m15, $m0+=, 42
; CHECK-NEXT:  br $m10
define {float, float*} @call_ldstep_f32(float* %base) {
  %res = call {float, float*} @llvm.colossus.ldstep.f32( float* %base, i32 42)
  ret {float, float*} %res
}

declare ptr @llvm.colossus.ststep.v2i16(<2 x i16>, ptr, i32)
declare {<2 x i16>, ptr} @llvm.colossus.ldstep.v2i16(ptr, i32)

; CHECK-LABEL: call_ststep_v2i16_reg:
; CHECK:       stm32step $m0, $m1, $m2
; CHECK-NEXT:  mov $m0, $m1
; CHECK-NEXT:  br $m10
define ptr @call_ststep_v2i16_reg(<2 x i16> %value, ptr %base, i32 %incr) {
  %res = call ptr @llvm.colossus.ststep.v2i16(<2 x i16> %value, ptr %base, i32 %incr)
  ret ptr %res
}

; CHECK-LABEL: call_ststep_v2i16:
; CHECK:       st32step $m0, $m15, $m1+=, 42
; CHECK-NEXT:  mov $m0, $m1
; CHECK-NEXT:  br $m10
define ptr @call_ststep_v2i16(<2 x i16> %value, ptr %base) {
  %res = call ptr @llvm.colossus.ststep.v2i16(<2 x i16> %value, ptr %base, i32 42)
  ret ptr %res
}

; CHECK-LABEL: call_ldstep_v2i16_reg:
; CHECK:       mov $m2, $m0
; CHECK-NEXT:  ld32step $m0, $m15, $m2+=, $m1
; CHECK-NEXT:  mov $m1, $m2
; CHECK-NEXT:  br $m10
define {<2 x i16>, ptr} @call_ldstep_v2i16_reg(ptr %base, i32 %incr) {
  %res = call {<2 x i16>, ptr} @llvm.colossus.ldstep.v2i16( ptr %base, i32 %incr)
  ret {<2 x i16>, ptr} %res
}

; CHECK-LABEL: call_ldstep_v2i16:
; CHECK:       mov $m1, $m0
; CHECK-NEXT:  ld32step $m0, $m15, $m1+=, 42
; CHECK-NEXT:  br $m10
define {<2 x i16>, ptr} @call_ldstep_v2i16(ptr %base) {
  %res = call {<2 x i16>, ptr} @llvm.colossus.ldstep.v2i16( ptr %base, i32 42)
  ret {<2 x i16>, ptr} %res
}

declare i32* @llvm.colossus.ststep.i32(i32, i32*, i32)
declare {i32, i32*} @llvm.colossus.ldstep.i32(i32*, i32)

; CHECK-LABEL: call_ststep_i32_reg:
; CHECK:       stm32step $m0, $m1, $m2
; CHECK-NEXT:  mov $m0, $m1
; CHECK-NEXT:  br $m10
define i32* @call_ststep_i32_reg(i32 %value, i32* %base, i32 %incr) {
  %res = call i32* @llvm.colossus.ststep.i32(i32 %value, i32* %base, i32 %incr)
  ret i32* %res
}

; CHECK-LABEL: call_ststep_i32:
; CHECK:       st32step $m0, $m15, $m1+=, 42
; CHECK-NEXT:  mov $m0, $m1
; CHECK-NEXT:  br $m10
define i32* @call_ststep_i32(i32 %value, i32* %base) {
  %res = call i32* @llvm.colossus.ststep.i32(i32 %value, i32* %base, i32 42)
  ret i32* %res
}

; CHECK-LABEL: call_ldstep_i32_reg:
; CHECK:       mov $m2, $m0
; CHECK-NEXT:  ld32step $m0, $m15, $m2+=, $m1
; CHECK-NEXT:  mov $m1, $m2
; CHECK-NEXT:  br $m10
define {i32, i32*} @call_ldstep_i32_reg(i32* %base, i32 %incr) {
  %res = call {i32, i32*} @llvm.colossus.ldstep.i32( i32* %base, i32 %incr)
  ret {i32, i32*} %res
}

; CHECK-LABEL: call_ldstep_i32:
; CHECK:       mov $m1, $m0
; CHECK-NEXT:  ld32step $m0, $m15, $m1+=, 42
; CHECK-NEXT:  br $m10
define {i32, i32*} @call_ldstep_i32(i32* %base) {
  %res = call {i32, i32*} @llvm.colossus.ldstep.i32( i32* %base, i32 42)
  ret {i32, i32*} %res
}

declare {i16, i16*} @llvm.colossus.ldstep.i16(i16*, i32)

; CHECK-LABEL: call_ldstep_i16_reg:
; CHECK:       mov $m2, $m0
; CHECK-NEXT:  ldz16step $m0, $m15, $m2+=, $m1
; CHECK-NEXT:  mov $m1, $m2
; CHECK-NEXT:  br $m10
define {i16, i16*} @call_ldstep_i16_reg(i16* %base, i32 %incr) {
  %res = call {i16, i16*} @llvm.colossus.ldstep.i16(i16* %base, i32 %incr)
  ret {i16, i16*} %res
}

; CHECK-LABEL: call_ldstep_i16:
; CHECK:       mov $m1, $m0
; CHECK-NEXT:  ldz16step $m0, $m15, $m1+=, 42
; CHECK-NEXT:  br $m10
define {i16, i16*} @call_ldstep_i16(i16* %base) {
  %res = call {i16, i16*} @llvm.colossus.ldstep.i16(i16* %base, i32 42)
  ret {i16, i16*} %res
}

; CHECK-LABEL: call_ldstep_i16z_reg:
; CHECK:       mov $m2, $m0
; CHECK-NEXT:  ldz16step $m0, $m15, $m2+=, $m1
; CHECK-NEXT:  mov $m1, $m2
; CHECK-NEXT:  br $m10
define {i32, i16*} @call_ldstep_i16z_reg(i16* %base, i32 %incr) {
  %ldres = call {i16, i16*} @llvm.colossus.ldstep.i16(i16* %base, i32 %incr)
  %ldres0 = extractvalue { i16, i16* } %ldres, 0
  %ldres1 = extractvalue { i16, i16* } %ldres, 1
  %ldres0ext = zext i16 %ldres0 to i32
  %res_low = insertvalue { i32, i16* } undef, i32 %ldres0ext, 0
  %res_high = insertvalue { i32, i16* } %res_low, i16* %ldres1, 1
  ret { i32, i16* } %res_high
}

; CHECK-LABEL: call_ldstep_i16z:
; CHECK:       mov $m1, $m0
; CHECK-NEXT:  ldz16step $m0, $m15, $m1+=, 42
; CHECK-NEXT:  br $m10
define {i32, i16*} @call_ldstep_i16z(i16* %base) {
  %ldres = call {i16, i16*} @llvm.colossus.ldstep.i16(i16* %base, i32 42)
  %ldres0 = extractvalue { i16, i16* } %ldres, 0
  %ldres1 = extractvalue { i16, i16* } %ldres, 1
  %ldres0ext = zext i16 %ldres0 to i32
  %res_low = insertvalue { i32, i16* } undef, i32 %ldres0ext, 0
  %res_high = insertvalue { i32, i16* } %res_low, i16* %ldres1, 1
  ret { i32, i16* } %res_high
}

; CHECK-LABEL: call_ldstep_i16s_reg:
; CHECK:       mov $m2, $m0
; CHECK-NEXT:  lds16step $m0, $m15, $m2+=, $m1
; CHECK-NEXT:  mov $m1, $m2
; CHECK-NEXT:  br $m10
define {i32, i16*} @call_ldstep_i16s_reg(i16* %base, i32 %incr) {
  %ldres = call {i16, i16*} @llvm.colossus.ldstep.i16(i16* %base, i32 %incr)
  %ldres0 = extractvalue { i16, i16* } %ldres, 0
  %ldres1 = extractvalue { i16, i16* } %ldres, 1
  %ldres0ext = sext i16 %ldres0 to i32
  %res_low = insertvalue { i32, i16* } undef, i32 %ldres0ext, 0
  %res_high = insertvalue { i32, i16* } %res_low, i16* %ldres1, 1
  ret { i32, i16* } %res_high
}

; CHECK-LABEL: call_ldstep_i16s:
; CHECK:       mov $m1, $m0
; CHECK-NEXT:  lds16step $m0, $m15, $m1+=, 42
; CHECK-NEXT:  br $m10
define {i32, i16*} @call_ldstep_i16s(i16* %base) {
  %ldres = call {i16, i16*} @llvm.colossus.ldstep.i16(i16* %base, i32 42)
  %ldres0 = extractvalue { i16, i16* } %ldres, 0
  %ldres1 = extractvalue { i16, i16* } %ldres, 1
  %ldres0ext = sext i16 %ldres0 to i32
  %res_low = insertvalue { i32, i16* } undef, i32 %ldres0ext, 0
  %res_high = insertvalue { i32, i16* } %res_low, i16* %ldres1, 1
  ret { i32, i16* } %res_high
}

declare {i8, i8*} @llvm.colossus.ldstep.i8(i8*, i32)

; CHECK-LABEL: call_ldstep_i8_reg:
; CHECK:       mov $m2, $m0
; CHECK-NEXT:  ldz8step $m0, $m15, $m2+=, $m1
; CHECK-NEXT:  mov $m1, $m2
; CHECK-NEXT:  br $m10
define {i8, i8*} @call_ldstep_i8_reg(i8* %base, i32 %incr) {
  %res = call {i8, i8*} @llvm.colossus.ldstep.i8(i8* %base, i32 %incr)
  ret {i8, i8*} %res
}

; CHECK-LABEL: call_ldstep_i8:
; CHECK:       mov $m1, $m0
; CHECK-NEXT:  ldz8step $m0, $m15, $m1+=, 42
; CHECK-NEXT:  br $m10
define {i8, i8*} @call_ldstep_i8(i8* %base) {
  %res = call {i8, i8*} @llvm.colossus.ldstep.i8(i8* %base, i32 42)
  ret {i8, i8*} %res
}

; CHECK-LABEL: call_ldstep_i8z_reg:
; CHECK:       mov $m2, $m0
; CHECK-NEXT:  ldz8step $m0, $m15, $m2+=, $m1
; CHECK-NEXT:  mov $m1, $m2
; CHECK-NEXT:  br $m10
define {i32, i8*} @call_ldstep_i8z_reg(i8* %base, i32 %incr) {
  %ldres = call {i8, i8*} @llvm.colossus.ldstep.i8(i8* %base, i32 %incr)
  %ldres0 = extractvalue { i8, i8* } %ldres, 0
  %ldres1 = extractvalue { i8, i8* } %ldres, 1
  %ldres0ext = zext i8 %ldres0 to i32
  %res_low = insertvalue { i32, i8* } undef, i32 %ldres0ext, 0
  %res_high = insertvalue { i32, i8* } %res_low, i8* %ldres1, 1
  ret { i32, i8* } %res_high
}

; CHECK-LABEL: call_ldstep_i8z:
; CHECK:       mov $m1, $m0
; CHECK-NEXT:  ldz8step $m0, $m15, $m1+=, 42
; CHECK-NEXT:  br $m10
define {i32, i8*} @call_ldstep_i8z(i8* %base) {
  %ldres = call {i8, i8*} @llvm.colossus.ldstep.i8(i8* %base, i32 42)
  %ldres0 = extractvalue { i8, i8* } %ldres, 0
  %ldres1 = extractvalue { i8, i8* } %ldres, 1
  %ldres0ext = zext i8 %ldres0 to i32
  %res_low = insertvalue { i32, i8* } undef, i32 %ldres0ext, 0
  %res_high = insertvalue { i32, i8* } %res_low, i8* %ldres1, 1
  ret { i32, i8* } %res_high
}

; CHECK-LABEL: call_ldstep_i8s_reg:
; CHECK:       mov $m2, $m0
; CHECK-NEXT:  lds8step $m0, $m15, $m2+=, $m1
; CHECK-NEXT:  mov $m1, $m2
; CHECK-NEXT:  br $m10
define {i32, i8*} @call_ldstep_i8s_reg(i8* %base, i32 %incr) {
  %ldres = call {i8, i8*} @llvm.colossus.ldstep.i8(i8* %base, i32 %incr)
  %ldres0 = extractvalue { i8, i8* } %ldres, 0
  %ldres1 = extractvalue { i8, i8* } %ldres, 1
  %ldres0ext = sext i8 %ldres0 to i32
  %res_low = insertvalue { i32, i8* } undef, i32 %ldres0ext, 0
  %res_high = insertvalue { i32, i8* } %res_low, i8* %ldres1, 1
  ret { i32, i8* } %res_high
}

; CHECK-LABEL: call_ldstep_i8s:
; CHECK:       mov $m1, $m0
; CHECK-NEXT:  lds8step $m0, $m15, $m1+=, 42
; CHECK-NEXT:  br $m10
define {i32, i8*} @call_ldstep_i8s(i8* %base) {
  %ldres = call {i8, i8*} @llvm.colossus.ldstep.i8(i8* %base, i32 42)
  %ldres0 = extractvalue { i8, i8* } %ldres, 0
  %ldres1 = extractvalue { i8, i8* } %ldres, 1
  %ldres0ext = sext i8 %ldres0 to i32
  %res_low = insertvalue { i32, i8* } undef, i32 %ldres0ext, 0
  %res_high = insertvalue { i32, i8* } %res_low, i8* %ldres1, 1
  ret { i32, i8* } %res_high
}

; Increment of zero generates a normal load or store

; CHECK-LABEL: call_ststep_f32_zero:
; CHECK:       # %bb
; CHECK-NEXT:  st32 $a0, $m0, $m15, 0
; CHECK-NEXT:  br $m10
define float* @call_ststep_f32_zero(float %value, float* %base) {
  %res = call float* @llvm.colossus.ststep.f32(float %value, float* %base, i32 0)
  ret float* %res
}

; CHECK-LABEL: call_ststep_f32_zero_offset:
; CHECK:       # %bb
; CHECK-NEXT:  add $m1, $m0, 40
; CHECK-NEXT:  st32 $a0, $m0, $m15, 10
; CHECK-NEXT:  mov $m0, $m1
; CHECK-NEXT:  br $m10
define float* @call_ststep_f32_zero_offset(float %value, float* %base) {
  %base.incr = getelementptr float, float* %base, i32 10
  %res = call float* @llvm.colossus.ststep.f32(float %value, float* %base.incr, i32 0)
  ret float* %res
}

; CHECK-LABEL: call_ststep_i32_zero:
; CHECK:       # %bb
; CHECK-NEXT:  st32 $m0, $m1, $m15, 0
; CHECK-NEXT:  mov $m0, $m1
; CHECK-NEXT:  br $m10
define i32* @call_ststep_i32_zero(i32 %value, i32* %base) {
  %res = call i32* @llvm.colossus.ststep.i32(i32 %value, i32* %base, i32 0)
  ret i32* %res
}

; CHECK-LABEL: call_ldstep_f32_zero:
; CHECK:       # %bb
; CHECK-NEXT:  ld32 $a0, $m0, $m15, 0
; CHECK-NEXT:  br $m10
define {float, float*} @call_ldstep_f32_zero(float* %base) {
  %res = call {float, float*} @llvm.colossus.ldstep.f32( float* %base, i32 0)
  ret {float, float*} %res
}

; CHECK-LABEL: call_ldstep_f32_zero_offset:
; CHECK:       # %bb
; CHECK-NEXT:  add $m1, $m0, 40
; CHECK-NEXT:  ld32 $a0, $m0, $m15, 10
; CHECK-NEXT:  mov $m0, $m1
; CHECK-NEXT:  br $m10
define {float, float*} @call_ldstep_f32_zero_offset(float* %base) {
  %base.incr = getelementptr float, float* %base, i32 10
  %res = call {float, float*} @llvm.colossus.ldstep.f32( float* %base.incr, i32 0)
  ret {float, float*} %res
}

; The mov is a result of call lowering chaining outputs together
; CHECK-LABEL: call_ldstep_i32_zero:
; CHECK:       # %bb
; CHECK-NEXT:  add $m1, $m0, 80
; CHECK-NEXT:  ld32 $m0, $m0, $m15, 20
; CHECK-NEXT:  br $m10
define {i32, i32*} @call_ldstep_i32_zero(i32* %base) {
  %base.incr = getelementptr i32, i32* %base, i32 20
  %res = call {i32, i32*} @llvm.colossus.ldstep.i32( i32* %base.incr, i32 0)
  ret {i32, i32*} %res
}

; Increment other than simple multiple generates normal load or store

; CHECK-LABEL: call_ldstep_f32_unhandled_increment:
; Incrementing before the load is suboptimal. An artefact of the call lowering.
; CHECK:       # %bb
; CHECK-NEXT:  shl $m1, $m1, 3
; CHECK-NEXT:  add $m1, $m0, $m1
; CHECK-NEXT:  ld32 $a0, $m0, $m15, 0
; CHECK-NEXT:  mov $m0, $m1
; CHECK-NEXT:  br $m10
define {float, float*} @call_ldstep_f32_unhandled_increment(float* %base, i32 %x) {
  %incr = mul i32 %x, 2
  %res = call {float, float*} @llvm.colossus.ldstep.f32( float* %base, i32 %incr)
  ret {float, float*} %res
}

; CHECK-LABEL: call_ststep_v2i32_unhandled_increment:
; CHECK:       # %bb
; CHECK-NEXT:  mul $m3, $m3, 24
; CHECK-NEXT:  add $m3, $m2, $m3
; CHECK-NEXT:  st32 $m1, $m2, $m15, 1
; CHECK-NEXT:  st32 $m0, $m2, $m15, 0
; CHECK-NEXT:  mov $m0, $m3
; CHECK-NEXT:  br $m10
define ptr @call_ststep_v2i32_unhandled_increment(<2 x i32> %value, ptr %base, i32 %x) {
  %incr = mul i32 %x, 3
  %res = call ptr @llvm.colossus.ststep.v2i32(<2 x i32> %value, ptr %base, i32 %incr)
  ret ptr %res
}

; Storing a 32 or 64 bit constant will always use the ARF

; CHECK-LABEL: call_ststep_constant_v2f32_reg:
; CHECK:       setzi $a0, 42
; CHECK-NEXT:  setzi $a1, 101
; CHECK-NEXT:  st64step $a0:1, $m15, $m0+=, $m1
; CHECK-NEXT:  br $m10
define ptr @call_ststep_constant_v2f32_reg(ptr %base, i32 %incr) {
  %bc = bitcast <2 x i32> <i32 42, i32 101> to <2 x float>
  %res = call ptr @llvm.colossus.ststep.v2f32(<2 x float> %bc, ptr %base, i32 %incr)
  ret ptr %res
}

; CHECK-LABEL: call_ststep_constant_v2f32:
; CHECK:       setzi $a0, 42
; CHECK-NEXT:  setzi $a1, 101
; CHECK-NEXT:  st64step $a0:1, $m15, $m0+=, 1
; CHECK-NEXT:  br $m10
define ptr @call_ststep_constant_v2f32(ptr %base) {
  %bc = bitcast <2 x i32> <i32 42, i32 101> to <2 x float>
  %res = call ptr @llvm.colossus.ststep.v2f32(<2 x float> %bc, ptr %base, i32 1)
  ret ptr %res
}

; CHECK-LABEL: call_ststep_constant_v2i32_reg:
; CHECK:       setzi $a0, 42
; CHECK-NEXT:  setzi $a1, 101
; CHECK-NEXT:  st64step $a0:1, $m15, $m0+=, $m1
; CHECK-NEXT:  br $m10
define ptr @call_ststep_constant_v2i32_reg(ptr %base, i32 %incr) {
  %res = call ptr @llvm.colossus.ststep.v2i32(<2 x i32> <i32 42, i32 101>, ptr %base, i32 %incr)
  ret ptr %res
}

; CHECK-LABEL: call_ststep_constant_v2i32:
; CHECK:       setzi $a0, 42
; CHECK-NEXT:  setzi $a1, 101
; CHECK-NEXT:  st64step $a0:1, $m15, $m0+=, 1
; CHECK-NEXT:  br $m10
define ptr @call_ststep_constant_v2i32(ptr %base) {
  %res = call ptr @llvm.colossus.ststep.v2i32(<2 x i32> <i32 42, i32 101>, ptr %base, i32 1)
  ret ptr %res
}

; CHECK-LABEL: call_ststep_constant_f32_reg:
; CHECK:       setzi $a0, 42
; CHECK-NEXT:  st32step $a0, $m15, $m0+=, $m1
; CHECK-NEXT:  br $m10
define ptr @call_ststep_constant_f32_reg(ptr %base, i32 %incr) {
  %bc = bitcast i32 42 to float
  %res = call ptr @llvm.colossus.ststep.f32(float %bc, ptr %base, i32 %incr)
  ret ptr %res
}

; CHECK-LABEL: call_ststep_constant_f32:
; CHECK:       setzi $a0, 42
; CHECK-NEXT:  st32step $a0, $m15, $m0+=, 1
; CHECK-NEXT:  br $m10
define ptr @call_ststep_constant_f32(ptr %base) {
  %bc = bitcast i32 42 to float
  %res = call ptr @llvm.colossus.ststep.f32(float %bc, ptr %base, i32 1)
  ret ptr %res
}

; CHECK-LABEL: call_ststep_constant_i32_reg:
; CHECK:       setzi $a0, 42
; CHECK-NEXT:  st32step $a0, $m15, $m0+=, $m1
; CHECK-NEXT:  br $m10
define ptr @call_ststep_constant_i32_reg(ptr %base, i32 %incr) {
  %res = call ptr @llvm.colossus.ststep.i32(i32 42, ptr %base, i32 %incr)
  ret ptr %res
}

; CHECK-LABEL: call_ststep_constant_i32:
; CHECK:       setzi $a0, 42
; CHECK-NEXT:  st32step $a0, $m15, $m0+=, 1
; CHECK-NEXT:  br $m10
define ptr @call_ststep_constant_i32(ptr %base) {
  %res = call ptr @llvm.colossus.ststep.i32(i32 42, ptr %base, i32 1)
  ret ptr %res
}
