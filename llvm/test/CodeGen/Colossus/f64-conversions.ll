; RUN: llc < %s -march=colossus -colossus-coissue=false -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -march=colossus -colossus-coissue=false -mattr=+ipu2 | FileCheck %s

; double is represented as two i32 values
; float is represented as f32 in both colossus and compiler-rt
; half is represented as f16 in colossus but i16 in compiler-rt

; CHECK-LABEL: extend16:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m10, $m11, $m15, 1
; CHECK-NEXT:  f16tof32 $a0, $a0
; CHECK-NEXT:  call $m10, __extendsfdf2
; CHECK-NEXT:  ld32 $m10, $m11, $m15, 1
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10
define double @extend16(half %x) {
  %res = fpext half %x to double
  ret double %res
}

declare double @llvm.experimental.constrained.fpext.f64.f16(half %src, metadata)

; CHECK-LABEL: strict_extend16:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m10, $m11, $m15, 1
; CHECK-NEXT:  f16tof32 $a0, $a0
; CHECK-NEXT:  call $m10, __extendsfdf2
; CHECK-NEXT:  ld32 $m10, $m11, $m15, 1
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10
define double @strict_extend16(half %x) {
  %res = tail call double @llvm.experimental.constrained.fpext.f64.f16(half %x, metadata !"fpexcept.strict")
  ret double %res
}

; CHECK-LABEL: extend32:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m10, $m11, $m15, 1
; CHECK-NEXT:  call $m10, __extendsfdf2
; CHECK-NEXT:  ld32 $m10, $m11, $m15, 1
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10
define double @extend32(float %x) {
  %res = fpext float %x to double
  ret double %res
}

declare double @llvm.experimental.constrained.fpext.f64.f32(float %src, metadata)

; CHECK-LABEL: strict_extend32:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m10, $m11, $m15, 1
; CHECK-NEXT:  call $m10, __extendsfdf2
; CHECK-NEXT:  ld32 $m10, $m11, $m15, 1
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10
define double @strict_extend32(float %x) {
  %res = tail call double @llvm.experimental.constrained.fpext.f64.f32(float %x, metadata !"fpexcept.strict")
  ret double %res
}

; CHECK-LABEL: trunc16:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m10, $m11, $m15, 1
; CHECK-NEXT:  call $m10, __truncdfhf2
; CHECK-NEXT:  st32 $m0, $m11, $m15, 0
; CHECK-NEXT:  ld32 $a0, $m11, $m15, 0
; CHECK-NEXT:  ld32 $m10, $m11, $m15, 1
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10
define half @trunc16(double %x) {
  %res = fptrunc double %x to half
  ret half %res
}

declare half @llvm.experimental.constrained.fptrunc.f16.f64(double %src, metadata, metadata)

; CHECK-LABEL: strict_trunc16:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m10, $m11, $m15, 1
; CHECK-NEXT:  call $m10, __truncdfhf2
; CHECK-NEXT:  st32 $m0, $m11, $m15, 0
; CHECK-NEXT:  ld32 $a0, $m11, $m15, 0
; CHECK-NEXT:  ld32 $m10, $m11, $m15, 1
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10
define half @strict_trunc16(double %x) {
  %res = tail call half @llvm.experimental.constrained.fptrunc.f16.f64(double %x, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret half %res
}

; CHECK-LABEL: trunc32:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m10, $m11, $m15, 1
; CHECK-NEXT:  call $m10, __truncdfsf2
; CHECK-NEXT:  ld32 $m10, $m11, $m15, 1
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10
define float @trunc32(double %x) {
  %res = fptrunc double %x to float
  ret float %res
}

declare float @llvm.experimental.constrained.fptrunc.f32.f64(double %src, metadata, metadata)

; CHECK-LABEL: strict_trunc32:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m10, $m11, $m15, 1
; CHECK-NEXT:  call $m10, __truncdfsf2
; CHECK-NEXT:  ld32 $m10, $m11, $m15, 1
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10
define float @strict_trunc32(double %x) {
  %res = tail call float @llvm.experimental.constrained.fptrunc.f32.f64(double %x, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret float %res
}

; CHECK-LABEL: extendv216:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -16
; CHECK-DAG:   st32 $a6, $m11, $m15, [[A6Spill:[0-9]+]]
; CHECK-DAG:   st32 $m10, $m11, $m15, [[M10Spill:[0-9]+]]
; CHECK-DAG:   st32 $m7, $m11, $m15, [[M7Spill:[0-9]+]]
; CHECK-DAG:   st32 $m8, $m11, $m15, [[M8Spill:[0-9]+]]
; CHECK-NEXT:  mov [[A0Save:\$a[0-9]+]], $a0
; First call
; CHECK-NEXT:  f16tof32 $a0, [[A0Save]]
; CHECK-NEXT:  call $m10, __extendsfdf2
; CHECK-NEXT:  mov [[Res0:\$m[0-9]+]], $m0
; CHECK-NEXT:  mov [[Res1:\$m[0-9]+]], $m1
; Second call
; CHECK-NEXT:  swap16 $a0, [[A0Save]]
; CHECK-NEXT:  f16tof32 $a0, $a0
; CHECK-NEXT:  call $m10, __extendsfdf2
; CHECK-NEXT:  mov $m2, $m0
; CHECK-NEXT:  mov $m3, $m1
; CHECK-NEXT:  mov $m0, [[Res0]]
; CHECK-NEXT:  mov $m1, [[Res1]]
; CHECK-DAG:   ld32 $a6, $m11, $m15, [[A6Spill]]
; CHECK-DAG:   ld32 $m10, $m11, $m15, [[M10Spill]]
; CHECK-DAG:   ld32 $m7, $m11, $m15, [[M7Spill]]
; CHECK-DAG:   ld32 $m8, $m11, $m15, [[M8Spill]]
; CHECK-NEXT:  add $m11, $m11, 16
; CHECK:       br $m10
define <2 x double> @extendv216(<2 x half> %x) {
  %res = fpext <2 x half> %x to <2 x double>
  ret <2 x double> %res
}

declare <2 x double> @llvm.experimental.constrained.fpext.v2f64.v2f16(<2 x half> %src, metadata)

; CHECK-LABEL: strict_extendv216:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -16
; CHECK-DAG:   st32 $a6, $m11, $m15, [[A6Spill:[0-9]+]]
; CHECK-DAG:   st32 $m10, $m11, $m15, [[M10Spill:[0-9]+]]
; CHECK-DAG:   st32 $m7, $m11, $m15, [[M7Spill:[0-9]+]]
; CHECK-DAG:   st32 $m8, $m11, $m15, [[M8Spill:[0-9]+]]
; CHECK-NEXT:  mov [[A0Save:\$a[0-9]+]], $a0
; First call
; CHECK-NEXT:  swap16 $a0, [[A0Save]]
; CHECK-NEXT:  f16tof32 $a0, $a0
; CHECK-NEXT:  call $m10, __extendsfdf2
; CHECK-NEXT:  mov [[Res0:\$m[0-9]+]], $m0
; CHECK-NEXT:  mov [[Res1:\$m[0-9]+]], $m1
; Second call
; CHECK-NEXT:  f16tof32 $a0, [[A0Save]]
; CHECK-NEXT:  call $m10, __extendsfdf2
; CHECK-NEXT:  mov $m2, [[Res0]]
; CHECK-NEXT:  mov $m3, [[Res1]]
; CHECK-DAG:   ld32 $a6, $m11, $m15, [[A6Spill]]
; CHECK-DAG:   ld32 $m10, $m11, $m15, [[M10Spill]]
; CHECK-DAG:   ld32 $m7, $m11, $m15, [[M7Spill]]
; CHECK-DAG:   ld32 $m8, $m11, $m15, [[M8Spill]]
; CHECK-NEXT:  add $m11, $m11, 16
; CHECK:       br $m10
define <2 x double> @strict_extendv216(<2 x half> %x) {
  %res = tail call <2 x double> @llvm.experimental.constrained.fpext.v2f64.v2f16(<2 x half> %x, metadata !"fpexcept.strict")
  ret <2 x double> %res
}

; CHECK-LABEL: extendv232:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -24
; CHECK-DAG:   st64 $a6:7, $m11, $m15, [[A67Spill:[0-9]+]]
; CHECK-DAG:   st32 $m10, $m11, $m15, [[M10Spill:[0-9]+]]
; CHECK-DAG:   st32 $m7, $m11, $m15, [[M7Spill:[0-9]+]]
; CHECK-DAG:   st32 $m8, $m11, $m15, [[M8Spill:[0-9]+]]
; CHECK-NEXT:  mov $a6:7, $a0:1
; First call
; CHECK-NEXT:  call $m10, __extendsfdf2
; CHECK-NEXT:  mov [[Res0:\$m[0-9]+]], $m0
; CHECK-NEXT:  mov [[Res1:\$m[0-9]+]], $m1
; Second call
; CHECK-NEXT:  mov $a0, $a7
; CHECK-NEXT:  call $m10, __extendsfdf2
; CHECK-DAG:   mov $m2, $m0
; CHECK-DAG:   mov $m3, $m1
; Shuffle registers
; CHECK-NOT:   break-dag-groups
; CHECK-DAG:   mov $m0, [[Res0]]
; CHECK-DAG:   mov $m1, [[Res1]]
; CHECK-NOT:   break-dag-groups
; CHECK-DAG:   ld64 $a6:7, $m11, $m15, [[A67Spill]]
; CHECK-DAG:   ld32 $m10, $m11, $m15, [[M10Spill]]
; CHECK-DAG:   ld32 $m7, $m11, $m15, [[M7Spill]]
; CHECK-DAG:   ld32 $m8, $m11, $m15, [[M8Spill]]
; CHECK-NEXT:  add $m11, $m11, 24
; CHECK:       br $m10
define <2 x double> @extendv232(<2 x float> %x) {
  %res = fpext <2 x float> %x to <2 x double>
  ret <2 x double> %res
}

declare <2 x double> @llvm.experimental.constrained.fpext.v2f64.v2f32(<2 x float> %src, metadata)

; CHECK-LABEL: strict_extendv232:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -24
; CHECK-DAG:   st64 $a6:7, $m11, $m15, [[A67Spill:[0-9]+]]
; CHECK-DAG:   st32 $m10, $m11, $m15, [[M10Spill:[0-9]+]]
; CHECK-DAG:   st32 $m7, $m11, $m15, [[M7Spill:[0-9]+]]
; CHECK-DAG:   st32 $m8, $m11, $m15, [[M8Spill:[0-9]+]]
; CHECK-NEXT:  mov $a6:7, $a0:1
; CHECK-NEXT:  mov $a0, $a7
; First call
; CHECK-NEXT:  call $m10, __extendsfdf2
; CHECK-NEXT:  mov [[Res0:\$m[0-9]+]], $m0
; CHECK-NEXT:  mov [[Res1:\$m[0-9]+]], $m1
; CHECK-NEXT:  mov $a0, $a6
; Second call
; CHECK-NEXT:  call $m10, __extendsfdf2
; Shuffle registers
; CHECK-NOT:   break-dag-groups
; CHECK-DAG:   mov $m2, [[Res0]]
; CHECK-DAG:   mov $m3, [[Res1]]
; CHECK-NOT:   break-dag-groups
; CHECK-DAG:   ld64 $a6:7, $m11, $m15, [[A67Spill]]
; CHECK-DAG:   ld32 $m10, $m11, $m15, [[M10Spill]]
; CHECK-DAG:   ld32 $m7, $m11, $m15, [[M7Spill]]
; CHECK-DAG:   ld32 $m8, $m11, $m15, [[M8Spill]]
; CHECK-NEXT:  add $m11, $m11, 24
; CHECK:       br $m10
define <2 x double> @strict_extendv232(<2 x float> %x) {
  %res = tail call <2 x double> @llvm.experimental.constrained.fpext.v2f64.v2f32(<2 x float> %x, metadata !"fpexcept.strict")
  ret <2 x double> %res
}

; CHECK-LABEL: truncv216:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -24
; CHECK-DAG:   st32 $m10, $m11, $m15, [[M10Spill:[0-9]+]]
; CHECK-DAG:   st32 $m7, $m11, $m15, [[M7Spill:[0-9]+]]
; CHECK-DAG:   st32 $m8, $m11, $m15, [[M8Spill:[0-9]+]]
; CHECK-DAG:   st32 $m9, $m11, $m15, [[M9Spill:[0-9]+]]
; CHECK-NOT:   break-dag-groups
; CHECK-DAG:   mov [[M0Save:\$m[0-9]+]], $m0
; CHECK-DAG:   mov [[M1Save:\$m[0-9]+]], $m1
; CHECK-NEXT:  mov $m0, $m2
; CHECK-NEXT:  mov $m1, $m3
; CHECK-NEXT:  call $m10, __truncdfhf2
; CHECK-NEXT:  mov [[Res0:\$m[0-9]+]], $m0
; CHECK-NEXT:  mov $m0, [[M0Save]]
; CHECK-NEXT:  mov $m1, [[M1Save]]
; CHECK-NEXT:  call $m10, __truncdfhf2
; CHECK-NEXT:  sort4x16lo $m0, $m0, [[Res0]]
; CHECK-NEXT:  st32 $m0, $m11, $m15, [[Scratch:[0-9]+]]
; CHECK-NEXT:  ld32 $a0, $m11, $m15, [[Scratch]]
; CHECK-DAG:   ld32 $m10, $m11, $m15, [[M10Spill]]
; CHECK-DAG:   ld32 $m7, $m11, $m15, [[M7Spill]]
; CHECK-DAG:   ld32 $m8, $m11, $m15, [[M8Spill]]
; CHECK-DAG:   ld32 $m9, $m11, $m15, [[M9Spill]]
; CHECK-NEXT:  add $m11, $m11, 24
; CHECK:       br $m10
define <2 x half> @truncv216(<2 x double> %x) {
  %res = fptrunc <2 x double> %x to <2 x half>
  ret <2 x half> %res
}

; CHECK-LABEL: truncv232:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -24
; CHECK-DAG:   st64 $a6:7, $m11, $m15, [[A67Spill:[0-9]+]]
; CHECK-DAG:   st32 $m10, $m11, $m15, [[M10Spill:[0-9]+]]
; CHECK-DAG:   st32 $m7, $m11, $m15, [[M7Spill:[0-9]+]]
; CHECK-DAG:   st32 $m8, $m11, $m15, [[M8Spill:[0-9]+]]
; CHECK-NOT:   break-dag-groups
; CHECK-DAG:   mov [[M0Save:\$m[0-9]+]], $m0
; CHECK-DAG:   mov [[M1Save:\$m[0-9]+]], $m1
; CHECK-NEXT:  mov $m0, $m2
; CHECK-NEXT:  mov $m1, $m3
; CHECK-NEXT:  call $m10, __truncdfsf2
; CHECK-NEXT:  mov $a7, $a0
; CHECK-NEXT:  mov $m0, [[M0Save]]
; CHECK-NEXT:  mov $m1, [[M1Save]]
; CHECK-NEXT:  call $m10, __truncdfsf2
; CHECK-NEXT:  mov $a6, $a0
; CHECK-NEXT:  mov $a0:1, $a6:7
; CHECK-DAG:   ld64 $a6:7, $m11, $m15, [[A67Spill]]
; CHECK-DAG:   ld32 $m10, $m11, $m15, [[M10Spill]]
; CHECK-DAG:   ld32 $m7, $m11, $m15, [[M7Spill]]
; CHECK-DAG:   ld32 $m8, $m11, $m15, [[M8Spill]]
; CHECK-NEXT:  add $m11, $m11, 24
; CHECK:       br $m10
define <2 x float> @truncv232(<2 x double> %x) {
  %res = fptrunc <2 x double> %x to <2 x float>
  ret <2 x float> %res
}

