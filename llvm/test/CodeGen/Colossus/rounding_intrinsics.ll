; RUN: llc < %s -mtriple=colossus -colossus-coissue=false -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -mtriple=colossus -colossus-coissue=false -mattr=+ipu2 | FileCheck %s


target triple = "colossus-graphcore--elf"

; CHECK-LABEL: flt_rounds:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $m0, 1
; CHECK-NEXT:  br $m10
declare i32 @llvm.flt.rounds()
define i32 @flt_rounds() {
  %mode = call i32 @llvm.flt.rounds( )
  ret i32 %mode
}

; CHECK-LABEL: test_ceil_f16:
; CHECK:       # %bb
; CHECK-NEXT:  f16tof32 $a0, $a0
; CHECK-NEXT:  f32int $a0, $a0, 1
; CHECK-NEXT:  f32tof16 $a0, $a0
; CHECK-NEXT:  br $m10
declare half @llvm.ceil.f16(half %x)
define half @test_ceil_f16(half %x) {
  %res = call half @llvm.ceil.f16(half %x)
  ret half %res
}

; CHECK-LABEL: test_constrained_ceil_f16:
; CHECK:       # %bb
; CHECK-NEXT:  f16tof32 $a0, $a0
; CHECK-NEXT:  f32int $a0, $a0, 1
; CHECK-NEXT:  f32tof16 $a0, $a0
; CHECK-NEXT:  br $m10
declare half @llvm.experimental.constrained.ceil.f16(half, metadata)
define half @test_constrained_ceil_f16(half %x) {
  %res = call half @llvm.experimental.constrained.ceil.f16(half %x, metadata !"fpexcept.strict")
  ret half %res
}

; CHECK-LABEL: test_ceil_f32:
; CHECK:       # %bb
; CHECK-NEXT:  f32int $a0, $a0, 1
; CHECK-NEXT:  br $m10
declare float @llvm.ceil.f32(float %x)
define float @test_ceil_f32(float %x) {
  %res = call float @llvm.ceil.f32(float %x)
  ret float %res
}

; CHECK-LABEL: test_constrained_ceil_f32:
; CHECK:       # %bb
; CHECK-NEXT:  f32int $a0, $a0, 1
; CHECK-NEXT:  br $m10
declare float @llvm.experimental.constrained.ceil.f32(float, metadata)
define float @test_constrained_ceil_f32(float %x) {
  %res = call float @llvm.experimental.constrained.ceil.f32(float %x, metadata !"fpexcept.strict")
  ret float %res
}

; CHECK-LABEL: test_ceil_v2f16:
; CHECK:       # %bb
; CHECK-NEXT:  f16v2tof32 $a0:1, $a0
; CHECK-DAG:   f32int $a[[R0:[0-9]+]], $a0, 1
; CHECK-DAG:   f32int $a[[R1:[0-9]+]], $a1, 1
; CHECK-NEXT:  f32v2tof16 $a0, $a[[R0]]:[[R1]]
; CHECK-NEXT:  br $m10
declare <2 x half> @llvm.ceil.v2f16(<2 x half> %x)
define <2 x half> @test_ceil_v2f16(<2 x half> %x) {
  %res = call <2 x half> @llvm.ceil.v2f16(<2 x half> %x)
  ret <2 x half> %res
}

; CHECK-LABEL: test_constrained_ceil_v2f16:
; CHECK:       # %bb
; CHECK-NEXT:  f16v2tof32 $a0:1, $a0
; CHECK-DAG:   f32int $a[[R0:[0-9]+]], $a0, 1
; CHECK-DAG:   f32int $a[[R1:[0-9]+]], $a1, 1
; CHECK-NEXT:  f32v2tof16 $a0, $a[[R0]]:[[R1]]
; CHECK-NEXT:  br $m10
declare <2 x half> @llvm.experimental.constrained.ceil.v2f16(<2 x half>, metadata)
define <2 x half> @test_constrained_ceil_v2f16(<2 x half> %x) {
  %res = call <2 x half> @llvm.experimental.constrained.ceil.v2f16(<2 x half> %x, metadata !"fpexcept.strict")
  ret <2 x half> %res
}

; CHECK-LABEL: test_ceil_v2f32:
; CHECK:       # %bb
; CHECK-DAG:   f32int $a0, $a0, 1
; CHECK-DAG:   f32int $a1, $a1, 1
; CHECK-NEXT:  br $m10
declare <2 x float> @llvm.ceil.v2f32(<2 x float> %x)
define <2 x float> @test_ceil_v2f32(<2 x float> %x) {
  %res = call <2 x float> @llvm.ceil.v2f32(<2 x float> %x)
  ret <2 x float> %res
}

; CHECK-LABEL: test_constrained_ceil_v2f32:
; CHECK:       # %bb
; CHECK-DAG:   f32int $a0, $a0, 1
; CHECK-DAG:   f32int $a1, $a1, 1
; CHECK-NEXT:  br $m10
declare <2 x float> @llvm.experimental.constrained.ceil.v2f32(<2 x float>, metadata)
define <2 x float> @test_constrained_ceil_v2f32(<2 x float> %x) {
  %res = call <2 x float> @llvm.experimental.constrained.ceil.v2f32(<2 x float> %x, metadata !"fpexcept.strict")
  ret <2 x float> %res
}

; CHECK-LABEL: test_ceil_v4f16:
; CHECK:       # %bb
; CHECK-DAG:   f16v2tof32
; CHECK-DAG:   f16v2tof32
; CHECK-DAG:   f32int $a{{[0-9]+}}, $a{{[0-9]+}}, 1
; CHECK-DAG:   f32int $a{{[0-9]+}}, $a{{[0-9]+}}, 1
; CHECK-DAG:   f32int $a{{[0-9]+}}, $a{{[0-9]+}}, 1
; CHECK-DAG:   f32int $a{{[0-9]+}}, $a{{[0-9]+}}, 1
; CHECK-DAG:   f32v2tof16
; CHECK:       f32v2tof16
; CHECK-NEXT:  br $m10
declare <4 x half> @llvm.ceil.v4f16(<4 x half> %x)
define <4 x half> @test_ceil_v4f16(<4 x half> %x) {
  %res = call <4 x half> @llvm.ceil.v4f16(<4 x half> %x)
  ret <4 x half> %res
}

; CHECK-LABEL: test_constrained_ceil_v4f16:
; CHECK:       # %bb
; CHECK-DAG:   f16v2tof32
; CHECK-DAG:   f16v2tof32
; CHECK-DAG:   f32int $a{{[0-9]+}}, $a{{[0-9]+}}, 1
; CHECK-DAG:   f32int $a{{[0-9]+}}, $a{{[0-9]+}}, 1
; CHECK-DAG:   f32int $a{{[0-9]+}}, $a{{[0-9]+}}, 1
; CHECK-DAG:   f32int $a{{[0-9]+}}, $a{{[0-9]+}}, 1
; CHECK-DAG:   f32v2tof16
; CHECK:       f32v2tof16
; CHECK-NEXT:  br $m10
declare <4 x half> @llvm.experimental.constrained.ceil.v4f16(<4 x half>, metadata)
define <4 x half> @test_constrained_ceil_v4f16(<4 x half> %x) {
  %res = call <4 x half> @llvm.experimental.constrained.ceil.v4f16(<4 x half> %x, metadata !"fpexcept.strict")
  ret <4 x half> %res
}

; CHECK-LABEL: test_floor_f16:
; CHECK:       # %bb
; CHECK-NEXT:  f16tof32 $a0, $a0
; CHECK-NEXT:  f32int $a0, $a0, 2
; CHECK-NEXT:  f32tof16 $a0, $a0
; CHECK-NEXT:  br $m10
declare half @llvm.floor.f16(half %x)
define half @test_floor_f16(half %x) {
  %res = call half @llvm.floor.f16(half %x)
  ret half %res
}

; CHECK-LABEL: test_constrained_floor_f16:
; CHECK:       # %bb
; CHECK-NEXT:  f16tof32 $a0, $a0
; CHECK-NEXT:  f32int $a0, $a0, 2
; CHECK-NEXT:  f32tof16 $a0, $a0
; CHECK-NEXT:  br $m10
declare half @llvm.experimental.constrained.floor.f16(half, metadata)
define half @test_constrained_floor_f16(half %x) {
  %res = call half @llvm.experimental.constrained.floor.f16(half %x, metadata !"fpexcept.strict")
  ret half %res
}

; CHECK-LABEL: test_floor_f32:
; CHECK:       # %bb
; CHECK-NEXT:  f32int $a0, $a0, 2
; CHECK-NEXT:  br $m10
declare float @llvm.floor.f32(float %x)
define float @test_floor_f32(float %x) {
  %res = call float @llvm.floor.f32(float %x)
  ret float %res
}

; CHECK-LABEL: test_constrained_floor_f32:
; CHECK:       # %bb
; CHECK-NEXT:  f32int $a0, $a0, 2
; CHECK-NEXT:  br $m10
declare float @llvm.experimental.constrained.floor.f32(float, metadata)
define float @test_constrained_floor_f32(float %x) {
  %res = call float @llvm.experimental.constrained.floor.f32(float %x, metadata !"fpexcept.strict")
  ret float %res
}

; CHECK-LABEL: test_floor_v2f16:
; CHECK:       # %bb
; CHECK-NEXT:  f16v2tof32 $a0:1, $a0
; CHECK-DAG:   f32int $a[[R0:[0-9]+]], $a0, 2
; CHECK-DAG:   f32int $a[[R1:[0-9]+]], $a1, 2
; CHECK-NEXT:  f32v2tof16 $a0, $a[[R0]]:[[R1]]
; CHECK-NEXT:  br $m10
declare <2 x half> @llvm.floor.v2f16(<2 x half> %x)
define <2 x half> @test_floor_v2f16(<2 x half> %x) {
  %res = call <2 x half> @llvm.floor.v2f16(<2 x half> %x)
  ret <2 x half> %res
}

; CHECK-LABEL: test_constrained_floor_v2f16:
; CHECK:       # %bb
; CHECK-NEXT:  f16v2tof32 $a0:1, $a0
; CHECK-DAG:   f32int $a[[R0:[0-9]+]], $a0, 2
; CHECK-DAG:   f32int $a[[R1:[0-9]+]], $a1, 2
; CHECK-NEXT:  f32v2tof16 $a0, $a[[R0]]:[[R1]]
; CHECK-NEXT:  br $m10
declare <2 x half> @llvm.experimental.constrained.floor.v2f16(<2 x half>, metadata)
define <2 x half> @test_constrained_floor_v2f16(<2 x half> %x) {
  %res = call <2 x half> @llvm.experimental.constrained.floor.v2f16(<2 x half> %x, metadata !"fpexcept.strict")
  ret <2 x half> %res
}

; CHECK-LABEL: test_floor_v2f32:
; CHECK:       # %bb
; CHECK-DAG:   f32int $a0, $a0, 2
; CHECK-DAG:   f32int $a1, $a1, 2
; CHECK-NEXT:  br $m10
declare <2 x float> @llvm.floor.v2f32(<2 x float> %x)
define <2 x float> @test_floor_v2f32(<2 x float> %x) {
  %res = call <2 x float> @llvm.floor.v2f32(<2 x float> %x)
  ret <2 x float> %res
}

; CHECK-LABEL: test_constrained_floor_v2f32:
; CHECK:       # %bb
; CHECK-DAG:   f32int $a0, $a0, 2
; CHECK-DAG:   f32int $a1, $a1, 2
; CHECK-NEXT:  br $m10
declare <2 x float> @llvm.experimental.constrained.floor.v2f32(<2 x float>, metadata)
define <2 x float> @test_constrained_floor_v2f32(<2 x float> %x) {
  %res = call <2 x float> @llvm.experimental.constrained.floor.v2f32(<2 x float> %x, metadata !"fpexcept.strict")
  ret <2 x float> %res
}

; CHECK-LABEL: test_floor_v4f16:
; CHECK:       # %bb
; CHECK-DAG:   f16v2tof32
; CHECK-DAG:   f16v2tof32
; CHECK-DAG:   f32int $a{{[0-9]+}}, $a{{[0-9]+}}, 2
; CHECK-DAG:   f32int $a{{[0-9]+}}, $a{{[0-9]+}}, 2
; CHECK-DAG:   f32int $a{{[0-9]+}}, $a{{[0-9]+}}, 2
; CHECK-DAG:   f32int $a{{[0-9]+}}, $a{{[0-9]+}}, 2
; CHECK-DAG:   f32v2tof16
; CHECK:       f32v2tof16
; CHECK-NEXT:  br $m10
declare <4 x half> @llvm.floor.v4f16(<4 x half> %x)
define <4 x half> @test_floor_v4f16(<4 x half> %x) {
  %res = call <4 x half> @llvm.floor.v4f16(<4 x half> %x)
  ret <4 x half> %res
}

; CHECK-LABEL: test_constrained_floor_v4f16:
; CHECK:       # %bb
; CHECK-DAG:   f16v2tof32
; CHECK-DAG:   f16v2tof32
; CHECK-DAG:   f32int $a{{[0-9]+}}, $a{{[0-9]+}}, 2
; CHECK-DAG:   f32int $a{{[0-9]+}}, $a{{[0-9]+}}, 2
; CHECK-DAG:   f32int $a{{[0-9]+}}, $a{{[0-9]+}}, 2
; CHECK-DAG:   f32int $a{{[0-9]+}}, $a{{[0-9]+}}, 2
; CHECK-DAG:   f32v2tof16
; CHECK:       f32v2tof16
; CHECK-NEXT:  br $m10
declare <4 x half> @llvm.experimental.constrained.floor.v4f16(<4 x half>, metadata)
define <4 x half> @test_constrained_floor_v4f16(<4 x half> %x) {
  %res = call <4 x half> @llvm.experimental.constrained.floor.v4f16(<4 x half> %x, metadata !"fpexcept.strict")
  ret <4 x half> %res
}

; CHECK-LABEL: test_nearbyint_f16:
; CHECK:       # %bb
; CHECK-NEXT:  f16tof32 $a0, $a0
; CHECK-NEXT:  f32int $a0, $a0, 0
; CHECK-NEXT:  f32tof16 $a0, $a0
; CHECK-NEXT:  br $m10
declare half @llvm.nearbyint.f16(half %x)
define half @test_nearbyint_f16(half %x) {
  %res = call half @llvm.nearbyint.f16(half %x)
  ret half %res
}

; CHECK-LABEL: test_constrained_nearbyint_f16:
; CHECK:       # %bb
; CHECK-NEXT:  f16tof32 $a0, $a0
; CHECK-NEXT:  f32int $a0, $a0, 0
; CHECK-NEXT:  f32tof16 $a0, $a0
; CHECK-NEXT:  br $m10
declare half @llvm.experimental.constrained.nearbyint.f16(half, metadata, metadata)
define half @test_constrained_nearbyint_f16(half %x) {
  %res = call half @llvm.experimental.constrained.nearbyint.f16(half %x, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret half %res
}

; CHECK-LABEL: test_nearbyint_f32:
; CHECK:       # %bb
; CHECK-NEXT:  f32int $a0, $a0, 0
; CHECK-NEXT:  br $m10
declare float @llvm.nearbyint.f32(float %x)
define float @test_nearbyint_f32(float %x) {
  %res = call float @llvm.nearbyint.f32(float %x)
  ret float %res
}

; CHECK-LABEL: test_constrained_nearbyint_f32:
; CHECK:       # %bb
; CHECK-NEXT:  f32int $a0, $a0, 0
; CHECK-NEXT:  br $m10
declare float @llvm.experimental.constrained.nearbyint.f32(float, metadata, metadata)
define float @test_constrained_nearbyint_f32(float %x) {
  %res = call float @llvm.experimental.constrained.nearbyint.f32(float %x, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret float %res
}

; CHECK-LABEL: test_nearbyint_v2f16:
; CHECK:       # %bb
; CHECK-NEXT:  f16v2tof32 $a0:1, $a0
; CHECK-DAG:   f32int $a[[R0:[0-9]+]], $a0, 0
; CHECK-DAG:   f32int $a[[R1:[0-9]+]], $a1, 0
; CHECK-NEXT:  f32v2tof16 $a0, $a[[R0]]:[[R1]]
; CHECK-NEXT:  br $m10
declare <2 x half> @llvm.nearbyint.v2f16(<2 x half> %x)
define <2 x half> @test_nearbyint_v2f16(<2 x half> %x) {
  %res = call <2 x half> @llvm.nearbyint.v2f16(<2 x half> %x)
  ret <2 x half> %res
}

; CHECK-LABEL: test_constrained_nearbyint_v2f16:
; CHECK:       # %bb
; CHECK-NEXT:  f16v2tof32 $a0:1, $a0
; CHECK-DAG:   f32int $a[[R0:[0-9]+]], $a0, 0
; CHECK-DAG:   f32int $a[[R1:[0-9]+]], $a1, 0
; CHECK-NEXT:  f32v2tof16 $a0, $a[[R0]]:[[R1]]
; CHECK-NEXT:  br $m10
declare <2 x half> @llvm.experimental.constrained.nearbyint.v2f16(<2 x half>, metadata, metadata)
define <2 x half> @test_constrained_nearbyint_v2f16(<2 x half> %x) {
  %res = call <2 x half> @llvm.experimental.constrained.nearbyint.v2f16(<2 x half> %x, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <2 x half> %res
}

; CHECK-LABEL: test_nearbyint_v2f32:
; CHECK:       # %bb
; CHECK-DAG:   f32int $a0, $a0, 0
; CHECK-DAG:   f32int $a1, $a1, 0
; CHECK-NEXT:  br $m10
declare <2 x float> @llvm.nearbyint.v2f32(<2 x float> %x)
define <2 x float> @test_nearbyint_v2f32(<2 x float> %x) {
  %res = call <2 x float> @llvm.nearbyint.v2f32(<2 x float> %x)
  ret <2 x float> %res
}

; CHECK-LABEL: test_constrained_nearbyint_v2f32:
; CHECK:       # %bb
; CHECK-DAG:   f32int $a0, $a0, 0
; CHECK-DAG:   f32int $a1, $a1, 0
; CHECK-NEXT:  br $m10
declare <2 x float> @llvm.experimental.constrained.nearbyint.v2f32(<2 x float>, metadata, metadata)
define <2 x float> @test_constrained_nearbyint_v2f32(<2 x float> %x) {
  %res = call <2 x float> @llvm.experimental.constrained.nearbyint.v2f32(<2 x float> %x, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <2 x float> %res
}

; CHECK-LABEL: test_nearbyint_v4f16:
; CHECK:       # %bb
; CHECK-DAG:   f16v2tof32
; CHECK-DAG:   f16v2tof32
; CHECK-DAG:   f32int $a{{[0-9]+}}, $a{{[0-9]+}}, 0
; CHECK-DAG:   f32int $a{{[0-9]+}}, $a{{[0-9]+}}, 0
; CHECK-DAG:   f32int $a{{[0-9]+}}, $a{{[0-9]+}}, 0
; CHECK-DAG:   f32int $a{{[0-9]+}}, $a{{[0-9]+}}, 0
; CHECK-DAG:   f32v2tof16
; CHECK:       f32v2tof16
; CHECK-NEXT:  br $m10
declare <4 x half> @llvm.nearbyint.v4f16(<4 x half> %x)
define <4 x half> @test_nearbyint_v4f16(<4 x half> %x) {
  %res = call <4 x half> @llvm.nearbyint.v4f16(<4 x half> %x)
  ret <4 x half> %res
}

; CHECK-LABEL: test_constrained_nearbyint_v4f16:
; CHECK:       # %bb
; CHECK-DAG:   f16v2tof32
; CHECK-DAG:   f16v2tof32
; CHECK-DAG:   f32int $a{{[0-9]+}}, $a{{[0-9]+}}, 0
; CHECK-DAG:   f32int $a{{[0-9]+}}, $a{{[0-9]+}}, 0
; CHECK-DAG:   f32int $a{{[0-9]+}}, $a{{[0-9]+}}, 0
; CHECK-DAG:   f32int $a{{[0-9]+}}, $a{{[0-9]+}}, 0
; CHECK-DAG:   f32v2tof16
; CHECK:       f32v2tof16
; CHECK-NEXT:  br $m10
declare <4 x half> @llvm.experimental.constrained.nearbyint.v4f16(<4 x half>, metadata, metadata)
define <4 x half> @test_constrained_nearbyint_v4f16(<4 x half> %x) {
  %res = call <4 x half> @llvm.experimental.constrained.nearbyint.v4f16(<4 x half> %x, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <4 x half> %res
}

; CHECK-LABEL: test_rint_f16:
; CHECK:       # %bb
; CHECK-NEXT:  f16tof32 $a0, $a0
; CHECK-NEXT:  f32int $a0, $a0, 0
; CHECK-NEXT:  f32tof16 $a0, $a0
; CHECK-NEXT:  br $m10
declare half @llvm.rint.f16(half %x)
define half @test_rint_f16(half %x) {
  %res = call half @llvm.rint.f16(half %x)
  ret half %res
}

; CHECK-LABEL: test_constrained_rint_f16:
; CHECK:       # %bb
; CHECK-NEXT:  f16tof32 $a0, $a0
; CHECK-NEXT:  f32int $a0, $a0, 0
; CHECK-NEXT:  f32tof16 $a0, $a0
; CHECK-NEXT:  br $m10
declare half @llvm.experimental.constrained.rint.f16(half, metadata, metadata)
define half @test_constrained_rint_f16(half %x) {
  %res = call half @llvm.experimental.constrained.rint.f16(half %x, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret half %res
}

; CHECK-LABEL: test_rint_f32:
; CHECK:       # %bb
; CHECK-NEXT:  f32int $a0, $a0, 0
; CHECK-NEXT:  br $m10
declare float @llvm.rint.f32(float %x)
define float @test_rint_f32(float %x) {
  %res = call float @llvm.rint.f32(float %x)
  ret float %res
}

; CHECK-LABEL: test_constrained_rint_f32:
; CHECK:       # %bb
; CHECK-NEXT:  f32int $a0, $a0, 0
; CHECK-NEXT:  br $m10
declare float @llvm.experimental.constrained.rint.f32(float, metadata, metadata)
define float @test_constrained_rint_f32(float %x) {
  %res = call float @llvm.experimental.constrained.rint.f32(float %x, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret float %res
}

; CHECK-LABEL: test_rint_v2f16:
; CHECK:       # %bb
; CHECK-NEXT:  f16v2tof32 $a0:1, $a0
; CHECK-DAG:   f32int $a[[R0:[0-9]+]], $a0, 0
; CHECK-DAG:   f32int $a[[R1:[0-9]+]], $a1, 0
; CHECK-NEXT:  f32v2tof16 $a0, $a[[R0]]:[[R1]]
; CHECK-NEXT:  br $m10
declare <2 x half> @llvm.rint.v2f16(<2 x half> %x)
define <2 x half> @test_rint_v2f16(<2 x half> %x) {
  %res = call <2 x half> @llvm.rint.v2f16(<2 x half> %x)
  ret <2 x half> %res
}

; CHECK-LABEL: test_constrained_rint_v2f16:
; CHECK:       # %bb
; CHECK-NEXT:  f16v2tof32 $a0:1, $a0
; CHECK-DAG:   f32int $a[[R0:[0-9]+]], $a0, 0
; CHECK-DAG:   f32int $a[[R1:[0-9]+]], $a1, 0
; CHECK-NEXT:  f32v2tof16 $a0, $a[[R0]]:[[R1]]
; CHECK-NEXT:  br $m10
declare <2 x half> @llvm.experimental.constrained.rint.v2f16(<2 x half>, metadata, metadata)
define <2 x half> @test_constrained_rint_v2f16(<2 x half> %x) {
  %res = call <2 x half> @llvm.experimental.constrained.rint.v2f16(<2 x half> %x, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <2 x half> %res
}

; CHECK-LABEL: test_rint_v2f32:
; CHECK:       # %bb
; CHECK-DAG:   f32int $a0, $a0, 0
; CHECK-DAG:   f32int $a1, $a1, 0
; CHECK-NEXT:  br $m10
declare <2 x float> @llvm.rint.v2f32(<2 x float> %x)
define <2 x float> @test_rint_v2f32(<2 x float> %x) {
  %res = call <2 x float> @llvm.rint.v2f32(<2 x float> %x)
  ret <2 x float> %res
}

; CHECK-LABEL: test_constrained_rint_v2f32:
; CHECK:       # %bb
; CHECK-DAG:   f32int $a0, $a0, 0
; CHECK-DAG:   f32int $a1, $a1, 0
; CHECK-NEXT:  br $m10
declare <2 x float> @llvm.experimental.constrained.rint.v2f32(<2 x float>, metadata, metadata)
define <2 x float> @test_constrained_rint_v2f32(<2 x float> %x) {
  %res = call <2 x float> @llvm.experimental.constrained.rint.v2f32(<2 x float> %x, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <2 x float> %res
}

; CHECK-LABEL: test_rint_v4f16:
; CHECK:       # %bb
; CHECK-DAG:   f16v2tof32
; CHECK-DAG:   f16v2tof32
; CHECK-DAG:   f32int $a{{[0-9]+}}, $a{{[0-9]+}}, 0
; CHECK-DAG:   f32int $a{{[0-9]+}}, $a{{[0-9]+}}, 0
; CHECK-DAG:   f32int $a{{[0-9]+}}, $a{{[0-9]+}}, 0
; CHECK-DAG:   f32int $a{{[0-9]+}}, $a{{[0-9]+}}, 0
; CHECK-DAG:   f32v2tof16
; CHECK:       f32v2tof16
; CHECK-NEXT:  br $m10
declare <4 x half> @llvm.rint.v4f16(<4 x half> %x)
define <4 x half> @test_rint_v4f16(<4 x half> %x) {
  %res = call <4 x half> @llvm.rint.v4f16(<4 x half> %x)
  ret <4 x half> %res
}

; CHECK-LABEL: test_constrained_rint_v4f16:
; CHECK:       # %bb
; CHECK-DAG:   f16v2tof32
; CHECK-DAG:   f16v2tof32
; CHECK-DAG:   f32int $a{{[0-9]+}}, $a{{[0-9]+}}, 0
; CHECK-DAG:   f32int $a{{[0-9]+}}, $a{{[0-9]+}}, 0
; CHECK-DAG:   f32int $a{{[0-9]+}}, $a{{[0-9]+}}, 0
; CHECK-DAG:   f32int $a{{[0-9]+}}, $a{{[0-9]+}}, 0
; CHECK-DAG:   f32v2tof16
; CHECK:       f32v2tof16
; CHECK-NEXT:  br $m10
declare <4 x half> @llvm.experimental.constrained.rint.v4f16(<4 x half>, metadata, metadata)
define <4 x half> @test_constrained_rint_v4f16(<4 x half> %x) {
  %res = call <4 x half> @llvm.experimental.constrained.rint.v4f16(<4 x half> %x, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <4 x half> %res
}

; CHECK-LABEL: test_round_f16:
; CHECK:       # %bb
; CHECK-NEXT:  f16tof32 $a0, $a0
; CHECK-NEXT:  f32int $a0, $a0, 4
; CHECK-NEXT:  f32tof16 $a0, $a0
; CHECK-NEXT:  br $m10
declare half @llvm.round.f16(half %x)
define half @test_round_f16(half %x) {
  %res = call half @llvm.round.f16(half %x)
  ret half %res
}

; CHECK-LABEL: test_constrained_round_f16:
; CHECK:       # %bb
; CHECK-NEXT:  f16tof32 $a0, $a0
; CHECK-NEXT:  f32int $a0, $a0, 4
; CHECK-NEXT:  f32tof16 $a0, $a0
; CHECK-NEXT:  br $m10
declare half @llvm.experimental.constrained.round.f16(half, metadata)
define half @test_constrained_round_f16(half %x) {
  %res = call half @llvm.experimental.constrained.round.f16(half %x, metadata !"fpexcept.strict")
  ret half %res
}

; CHECK-LABEL: test_round_f32:
; CHECK:       # %bb
; CHECK-NEXT:  f32int $a0, $a0, 4
; CHECK-NEXT:  br $m10
declare float @llvm.round.f32(float %x)
define float @test_round_f32(float %x) {
  %res = call float @llvm.round.f32(float %x)
  ret float %res
}

; CHECK-LABEL: test_constrained_round_f32:
; CHECK:       # %bb
; CHECK-NEXT:  f32int $a0, $a0, 4
; CHECK-NEXT:  br $m10
declare float @llvm.experimental.constrained.round.f32(float, metadata)
define float @test_constrained_round_f32(float %x) {
  %res = call float @llvm.experimental.constrained.round.f32(float %x, metadata !"fpexcept.strict")
  ret float %res
}

; CHECK-LABEL: test_round_v2f16:
; CHECK:       # %bb
; CHECK-NEXT:  f16v2tof32 $a0:1, $a0
; CHECK-DAG:   f32int $a[[R0:[0-9]+]], $a0, 4
; CHECK-DAG:   f32int $a[[R1:[0-9]+]], $a1, 4
; CHECK-NEXT:  f32v2tof16 $a0, $a[[R0]]:[[R1]]
; CHECK-NEXT:  br $m10
declare <2 x half> @llvm.round.v2f16(<2 x half> %x)
define <2 x half> @test_round_v2f16(<2 x half> %x) {
  %res = call <2 x half> @llvm.round.v2f16(<2 x half> %x)
  ret <2 x half> %res
}

; CHECK-LABEL: test_constrained_round_v2f16:
; CHECK:       # %bb
; CHECK-NEXT:  f16v2tof32 $a0:1, $a0
; CHECK-DAG:   f32int $a[[R0:[0-9]+]], $a0, 4
; CHECK-DAG:   f32int $a[[R1:[0-9]+]], $a1, 4
; CHECK-NEXT:  f32v2tof16 $a0, $a[[R0]]:[[R1]]
; CHECK-NEXT:  br $m10
declare <2 x half> @llvm.experimental.constrained.round.v2f16(<2 x half>, metadata)
define <2 x half> @test_constrained_round_v2f16(<2 x half> %x) {
  %res = call <2 x half> @llvm.experimental.constrained.round.v2f16(<2 x half> %x, metadata !"fpexcept.strict")
  ret <2 x half> %res
}

; CHECK-LABEL: test_round_v2f32:
; CHECK:       # %bb
; CHECK-DAG:   f32int $a{{[0-9]+}}, $a0, 4
; CHECK-DAG:   f32int $a{{[0-9]+}}, $a1, 4
; CHECK-NEXT:  br $m10
declare <2 x float> @llvm.round.v2f32(<2 x float> %x)
define <2 x float> @test_round_v2f32(<2 x float> %x) {
  %res = call <2 x float> @llvm.round.v2f32(<2 x float> %x)
  ret <2 x float> %res
}

; CHECK-LABEL: test_constrained_round_v2f32:
; CHECK:       # %bb
; CHECK-DAG:   f32int $a{{[0-9]+}}, $a0, 4
; CHECK-DAG:   f32int $a{{[0-9]+}}, $a1, 4
; CHECK-NEXT:  br $m10
declare <2 x float> @llvm.experimental.constrained.round.v2f32(<2 x float>, metadata)
define <2 x float> @test_constrained_round_v2f32(<2 x float> %x) {
  %res = call <2 x float> @llvm.experimental.constrained.round.v2f32(<2 x float> %x, metadata !"fpexcept.strict")
  ret <2 x float> %res
}

; CHECK-LABEL: test_round_v4f16:
; CHECK:       # %bb
; CHECK-DAG:   f16v2tof32
; CHECK-DAG:   f16v2tof32
; CHECK-DAG:   f32int $a{{[0-9]+}}, $a{{[0-9]+}}, 4
; CHECK-DAG:   f32int $a{{[0-9]+}}, $a{{[0-9]+}}, 4
; CHECK-DAG:   f32int $a{{[0-9]+}}, $a{{[0-9]+}}, 4
; CHECK-DAG:   f32int $a{{[0-9]+}}, $a{{[0-9]+}}, 4
; CHECK-DAG:   f32v2tof16
; CHECK:       f32v2tof16
; CHECK-NEXT:  br $m10
declare <4 x half> @llvm.round.v4f16(<4 x half> %x)
define <4 x half> @test_round_v4f16(<4 x half> %x) {
  %res = call <4 x half> @llvm.round.v4f16(<4 x half> %x)
  ret <4 x half> %res
}

; CHECK-LABEL: test_constrained_round_v4f16:
; CHECK:       # %bb
; CHECK-DAG:   f16v2tof32
; CHECK-DAG:   f16v2tof32
; CHECK-DAG:   f32int $a{{[0-9]+}}, $a{{[0-9]+}}, 4
; CHECK-DAG:   f32int $a{{[0-9]+}}, $a{{[0-9]+}}, 4
; CHECK-DAG:   f32int $a{{[0-9]+}}, $a{{[0-9]+}}, 4
; CHECK-DAG:   f32int $a{{[0-9]+}}, $a{{[0-9]+}}, 4
; CHECK-DAG:   f32v2tof16
; CHECK:       f32v2tof16
; CHECK-NEXT:  br $m10
declare <4 x half> @llvm.experimental.constrained.round.v4f16(<4 x half>, metadata)
define <4 x half> @test_constrained_round_v4f16(<4 x half> %x) {
  %res = call <4 x half> @llvm.experimental.constrained.round.v4f16(<4 x half> %x, metadata !"fpexcept.strict")
  ret <4 x half> %res
}

; CHECK-LABEL: test_trunc_f16:
; CHECK:       # %bb
; CHECK-NEXT:  f16tof32 $a0, $a0
; CHECK-NEXT:  f32int $a0, $a0, 3
; CHECK-NEXT:  f32tof16 $a0, $a0
; CHECK-NEXT:  br $m10
declare half @llvm.trunc.f16(half %x)
define half @test_trunc_f16(half %x) {
  %res = call half @llvm.trunc.f16(half %x)
  ret half %res
}

; CHECK-LABEL: test_constrained_trunc_f16:
; CHECK:       # %bb
; CHECK-NEXT:  f16tof32 $a0, $a0
; CHECK-NEXT:  f32int $a0, $a0, 3
; CHECK-NEXT:  f32tof16 $a0, $a0
; CHECK-NEXT:  br $m10
declare half @llvm.experimental.constrained.trunc.f16(half, metadata)
define half @test_constrained_trunc_f16(half %x) {
  %res = call half @llvm.experimental.constrained.trunc.f16(half %x, metadata !"fpexcept.strict")
  ret half %res
}

; CHECK-LABEL: test_trunc_f32:
; CHECK:       # %bb
; CHECK-NEXT:  f32int $a0, $a0, 3
; CHECK-NEXT:  br $m10
declare float @llvm.trunc.f32(float %x)
define float @test_trunc_f32(float %x) {
  %res = call float @llvm.trunc.f32(float %x)
  ret float %res
}

; CHECK-LABEL: test_constrained_trunc_f32:
; CHECK:       # %bb
; CHECK-NEXT:  f32int $a0, $a0, 3
; CHECK-NEXT:  br $m10
declare float @llvm.experimental.constrained.trunc.f32(float, metadata)
define float @test_constrained_trunc_f32(float %x) {
  %res = call float @llvm.experimental.constrained.trunc.f32(float %x, metadata !"fpexcept.strict")
  ret float %res
}

; CHECK-LABEL: test_trunc_v2f16:
; CHECK:       # %bb
; CHECK-NEXT:  f16v2tof32 $a0:1, $a0
; CHECK-DAG:   f32int $a[[R0:[0-9]+]], $a0, 3
; CHECK-DAG:   f32int $a[[R1:[0-9]+]], $a1, 3
; CHECK-NEXT:  f32v2tof16 $a0, $a[[R0]]:[[R1]]
; CHECK-NEXT:  br $m10
declare <2 x half> @llvm.trunc.v2f16(<2 x half> %x)
define <2 x half> @test_trunc_v2f16(<2 x half> %x) {
  %res = call <2 x half> @llvm.trunc.v2f16(<2 x half> %x)
  ret <2 x half> %res
}

; CHECK-LABEL: test_constrained_trunc_v2f16:
; CHECK:       # %bb
; CHECK-NEXT:  f16v2tof32 $a0:1, $a0
; CHECK-DAG:   f32int $a[[R0:[0-9]+]], $a0, 3
; CHECK-DAG:   f32int $a[[R1:[0-9]+]], $a1, 3
; CHECK-NEXT:  f32v2tof16 $a0, $a[[R0]]:[[R1]]
; CHECK-NEXT:  br $m10
declare <2 x half> @llvm.experimental.constrained.trunc.v2f16(<2 x half>, metadata)
define <2 x half> @test_constrained_trunc_v2f16(<2 x half> %x) {
  %res = call <2 x half> @llvm.experimental.constrained.trunc.v2f16(<2 x half> %x, metadata !"fpexcept.strict")
  ret <2 x half> %res
}

; CHECK-LABEL: test_trunc_v2f32:
; CHECK:       # %bb
; CHECK-DAG:   f32int $a0, $a0, 3
; CHECK-DAG:   f32int $a1, $a1, 3
; CHECK-NEXT:  br $m10
declare <2 x float> @llvm.trunc.v2f32(<2 x float> %x)
define <2 x float> @test_trunc_v2f32(<2 x float> %x) {
  %res = call <2 x float> @llvm.trunc.v2f32(<2 x float> %x)
  ret <2 x float> %res
}

; CHECK-LABEL: test_constrained_trunc_v2f32:
; CHECK:       # %bb
; CHECK-DAG:   f32int $a0, $a0, 3
; CHECK-DAG:   f32int $a1, $a1, 3
; CHECK-NEXT:  br $m10
declare <2 x float> @llvm.experimental.constrained.trunc.v2f32(<2 x float>, metadata)
define <2 x float> @test_constrained_trunc_v2f32(<2 x float> %x) {
  %res = call <2 x float> @llvm.experimental.constrained.trunc.v2f32(<2 x float> %x, metadata !"fpexcept.strict")
  ret <2 x float> %res
}

; CHECK-LABEL: test_trunc_v4f16:
; CHECK:       # %bb
; CHECK-DAG:   f16v2tof32
; CHECK-DAG:   f16v2tof32
; CHECK-DAG:   f32int $a{{[0-9]+}}, $a{{[0-9]+}}, 3
; CHECK-DAG:   f32int $a{{[0-9]+}}, $a{{[0-9]+}}, 3
; CHECK-DAG:   f32int $a{{[0-9]+}}, $a{{[0-9]+}}, 3
; CHECK-DAG:   f32int $a{{[0-9]+}}, $a{{[0-9]+}}, 3
; CHECK-DAG:   f32v2tof16
; CHECK:       f32v2tof16
; CHECK-NEXT:  br $m10
declare <4 x half> @llvm.trunc.v4f16(<4 x half> %x)
define <4 x half> @test_trunc_v4f16(<4 x half> %x) {
  %res = call <4 x half> @llvm.trunc.v4f16(<4 x half> %x)
  ret <4 x half> %res
}

; CHECK-LABEL: test_constrained_trunc_v4f16:
; CHECK:       # %bb
; CHECK-DAG:   f16v2tof32
; CHECK-DAG:   f16v2tof32
; CHECK-DAG:   f32int $a{{[0-9]+}}, $a{{[0-9]+}}, 3
; CHECK-DAG:   f32int $a{{[0-9]+}}, $a{{[0-9]+}}, 3
; CHECK-DAG:   f32int $a{{[0-9]+}}, $a{{[0-9]+}}, 3
; CHECK-DAG:   f32int $a{{[0-9]+}}, $a{{[0-9]+}}, 3
; CHECK-DAG:   f32v2tof16
; CHECK:       f32v2tof16
; CHECK-NEXT:  br $m10
declare <4 x half> @llvm.experimental.constrained.trunc.v4f16(<4 x half>, metadata)
define <4 x half> @test_constrained_trunc_v4f16(<4 x half> %x) {
  %res = call <4 x half> @llvm.experimental.constrained.trunc.v4f16(<4 x half> %x, metadata !"fpexcept.strict")
  ret <4 x half> %res
}
