; RUN: llc < %s -mtriple=colossus -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -mtriple=colossus -mattr=+ipu2 | FileCheck %s
target triple = "colossus-graphcore--elf"

declare i32 @bitwise_equal_i32_i32(i32, i32)
declare i32 @bitwise_equal_f32_f32(float, float)
declare i32 @bitwise_equal_v2i32_v2i32(<2 x i32>, <2 x i32>)
declare i32 @bitwise_equal_v2f32_v2f32(<2 x float>, <2 x float>)

; CHECK-LABEL: load_f32_from_i32:
; CHECK-NEXT: # %bb.0:
; CHECK-NEXT:  add $m11, $m11, -8
; CHECK-NEXT:  st32 $m10, $m11, $m15, [[SPILL:[0-1]]]
; CHECK-NEXT:  ld32 $a1, $m11, $m15, 2
; CHECK-NEXT:  call $m10, bitwise_equal_f32_f32
; CHECK-NEXT:  ld32 $m10, $m11, $m15, [[SPILL]]
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK-NEXT:  br $m10
define i32 @load_f32_from_i32(float %reg, i32 %i0, i32 %i1, i32 %i2, i32 %i3, i32 %stack) #0 {
  %cast = bitcast i32 %stack to float
  %call = tail call i32 @bitwise_equal_f32_f32(float %reg, float %cast)
  ret i32 %call
}

; CHECK-LABEL: load_v2f32_from_v2i32:
; CHECK-NEXT: # %bb.0:
; CHECK-NEXT:  add $m11, $m11, -8
; CHECK-NEXT:  st32 $m10, $m11, $m15, [[SPILL:[0-1]]]
; CHECK-NEXT:  ld64 $a2:3, $m11, $m15, 1
; CHECK-NEXT:  call $m10, bitwise_equal_v2f32_v2f32
; CHECK-NEXT:  ld32 $m10, $m11, $m15, [[SPILL]]
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK-NEXT:  br $m10
define i32 @load_v2f32_from_v2i32(<2 x float> %reg, i32 %i0, i32 %i1, i32 %i2, i32 %i3, <2 x i32> %stack) #0 {
  %cast = bitcast <2 x i32> %stack to <2 x float>
  %call = tail call i32 @bitwise_equal_v2f32_v2f32(<2 x float> %reg, <2 x float> %cast)
  ret i32 %call
}

; CHECK-LABEL: load_i32_from_f32:
; CHECK-NEXT: # %bb.0:
; CHECK-NEXT:  add $m11, $m11, -8
; CHECK-NEXT:  st32 $m10, $m11, $m15, [[SPILL:[0-1]]]
; CHECK-NEXT:  ld32 $m1, $m11, $m15, 2
; CHECK-NEXT:  call $m10, bitwise_equal_i32_i32
; CHECK-NEXT:  ld32 $m10, $m11, $m15, [[SPILL]]
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK-NEXT:  br $m10
define i32 @load_i32_from_f32(i32 %reg, float %f0, float %f1, float %f2, float %f3, float %f4, float %f5, float %stack) #0 {
  %cast = bitcast float %stack to i32
  %call = tail call i32 @bitwise_equal_i32_i32(i32 %reg, i32 %cast)
  ret i32 %call
}

; CHECK-LABEL: load_v2i32_from_v2f32:
; CHECK-NEXT: # %bb.0:
; CHECK-NEXT:  add $m11, $m11, -8
; CHECK-NEXT:  st32 $m10, $m11, $m15, [[SPILL:[0-1]]]
; CHECK-DAG:   ld32 $m2, $m11, $m15, 2
; CHECK-DAG:   ld32 $m3, $m11, $m15, 3
; CHECK-NEXT:  call $m10, bitwise_equal_v2i32_v2i32
; CHECK-NEXT:  ld32 $m10, $m11, $m15, [[SPILL]]
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK-NEXT:  br $m10
define i32 @load_v2i32_from_v2f32(<2 x i32> %reg, float %f0, float %f1, float %f2, float %f3, float %f4, float %f5, <2 x float> %stack) #0 {
  %cast = bitcast <2 x float> %stack to <2 x i32>
  %call = tail call i32 @bitwise_equal_v2i32_v2i32(<2 x i32> %reg, <2 x i32> %cast)
  ret i32 %call
}

; CHECK-LABEL: store_f32_as_i32:
; CHECK-NEXT: # %bb.0:
; CHECK-NEXT:  add $m11, $m11, -8
; CHECK-NEXT:  st32 $m10, $m11, $m15, 1
; CHECK-NEXT:  st32 $a0, $m11, $m15, 0
; CHECK-NEXT:  call $m10, load_f32_from_i32
; CHECK-NEXT:  ld32 $m10, $m11, $m15, 1
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK-NEXT:  br $m10
define i32 @store_f32_as_i32(float %x) #0 {
  %cast = bitcast float %x to i32
  %call = tail call i32 @load_f32_from_i32(float %x, i32 undef, i32 undef, i32 undef, i32 undef, i32 %cast)
  ret i32 %call
}

; CHECK-LABEL: store_v2f32_as_v2i32:
; CHECK-NEXT: # %bb.0:
; CHECK-NEXT:  add $m11, $m11, -16
; CHECK-NEXT:  st32 $m10, $m11, $m15, [[SPILL:[2-3]]]
; CHECK-NEXT:  st64 $a0:1, $m11, $m15, 0
; CHECK-NEXT:  call $m10, load_v2f32_from_v2i32
; CHECK-NEXT:  ld32 $m10, $m11, $m15, [[SPILL]]
; CHECK-NEXT:  add $m11, $m11, 16
; CHECK-NEXT:  br $m10
define i32 @store_v2f32_as_v2i32(<2 x float> %x) #0 {
  %cast = bitcast <2 x float> %x to <2 x i32>
  %call = tail call i32 @load_v2f32_from_v2i32(<2 x float> %x, i32 undef, i32 undef, i32 undef, i32 undef, <2 x i32> %cast)
  ret i32 %call
}

; CHECK-LABEL: store_i32_as_f32:
; CHECK-NEXT: # %bb.0:
; CHECK-NEXT:  add $m11, $m11, -8
; CHECK-NEXT:  st32 $m10, $m11, $m15, 1
; CHECK-NEXT:  st32 $m0, $m11, $m15, 0
; CHECK-NEXT:  call $m10, load_i32_from_f32
; CHECK-NEXT:  ld32 $m10, $m11, $m15, 1
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK-NEXT:  br $m10
define i32 @store_i32_as_f32(i32 %x) #0 {
  %cast = bitcast i32 %x to float
  %call = tail call i32 @load_i32_from_f32(i32 %x, float undef, float undef, float undef, float undef, float undef, float undef, float %cast)
  ret i32 %call
}

; CHECK-LABEL: store_v2i32_as_v2f32:
; CHECK-NEXT: # %bb.0:
; CHECK-NEXT:  add $m11, $m11, -16
; CHECK-NEXT:  st32 $m10, $m11, $m15, [[SPILL:[2-3]]]
; CHECK-DAG:   st32 $m0, $m11, $m15, 0
; CHECK-DAG:   st32 $m1, $m11, $m15, 1
; CHECK-NEXT:  call $m10, load_v2i32_from_v2f32
; CHECK-NEXT:  ld32 $m10, $m11, $m15, [[SPILL]]
; CHECK-NEXT:  add $m11, $m11, 16
; CHECK-NEXT:  br $m10
define i32 @store_v2i32_as_v2f32(<2 x i32> %x) #0 {
  %cast = bitcast <2 x i32> %x to <2 x float>
  %call = tail call i32 @load_v2i32_from_v2f32(<2 x i32> %x, float undef, float undef, float undef, float undef, float undef, float undef, <2 x float> %cast)
  ret i32 %call
}

attributes #0 = { noinline nounwind }
