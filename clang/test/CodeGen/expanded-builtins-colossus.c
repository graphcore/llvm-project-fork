// RUN: %clang -target colossus -S -emit-llvm -fdiscard-value-names -O3 \
// RUN:   -o - %s \
// RUN:   | FileCheck --check-prefixes=CHECK,NOEXP %s
// RUN: %clang -target colossus -S -emit-llvm -fdiscard-value-names \
// RUN:   -ffp-exception-behavior=maytrap -O3 -o - %s \
// RUN:   | FileCheck --check-prefixes=CHECK,EXP %s

#include <ipu_builtins.h>

// Test __builtin_ipu_isfinite()

// CHECK-LABEL: @test_f32_isfinite(float noundef %0)
// CHECK-NEXT:  %2 = tail call i32 @llvm.colossus.f32class(float %0)
// CHECK-NEXT:  %3 = icmp ugt i32 %2, 4
// CHECK-NEXT:  %4 = zext i1 %3 to i32
// CHECK-NEXT:  ret i32 %4
int test_f32_isfinite(float x) {
  return __builtin_ipu_isfinite(x);
}

// CHECK-LABEL: @test_v2f16_isfinite(<2 x half> noundef %0)
// CHECK-NEXT:  %2 = bitcast <2 x half> %0 to <2 x i16>
// CHECK-NEXT:  %3 = and <2 x i16> %2, <i16 31744, i16 31744>
// CHECK-NEXT:  %4 = bitcast <2 x i16> %3 to <2 x half>
// NOEXP-NEXT:  %5 = fcmp une <2 x half> %4, <half 0xH7C00, half 0xH7C00>
// EXP-NEXT:    %5 = tail call <2 x i1> @llvm.experimental.constrained.fcmps.v2f16(<2 x half> %4, <2 x half> <half 0xH7C00, half 0xH7C00>, metadata !"une", metadata !"fpexcept.maytrap")
// CHECK-NEXT:  %6 = zext <2 x i1> %5 to <2 x i16>
// CHECK-NEXT:  ret <2 x i16> %6
short2 test_v2f16_isfinite(half2 x) {
  return __builtin_ipu_isfinite(x);
}

// CHECK-LABEL: @test_v2f32_isfinite(<2 x float> noundef %0)
// CHECK-NEXT:  %2 = bitcast <2 x float> %0 to <2 x i32>
// CHECK-NEXT:  %3 = and <2 x i32> %2, <i32 2139095040, i32 2139095040>
// CHECK-NEXT:  %4 = bitcast <2 x i32> %3 to <2 x float>
// NOEXP-NEXT:  %5 = fcmp une <2 x float> %4, <float 0x7FF0000000000000, float 0x7FF0000000000000>
// EXP-NEXT:    %5 = tail call <2 x i1> @llvm.experimental.constrained.fcmps.v2f32(<2 x float> %4, <2 x float> <float 0x7FF0000000000000, float 0x7FF0000000000000>, metadata !"une", metadata !"fpexcept.maytrap")
// CHECK-NEXT:  %6 = zext <2 x i1> %5 to <2 x i32>
// CHECK-NEXT:  ret <2 x i32> %6
int2 test_v2f32_isfinite(float2 x) {
  return __builtin_ipu_isfinite(x);
}

// CHECK-LABEL: @test_v4f16_isfinite(<4 x half> noundef %0)
// CHECK-NEXT:  %2 = bitcast <4 x half> %0 to <4 x i16>
// CHECK-NEXT:  %3 = and <4 x i16> %2, <i16 31744, i16 31744, i16 31744, i16 31744>
// CHECK-NEXT:  %4 = bitcast <4 x i16> %3 to <4 x half>
// NOEXP-NEXT:  %5 = fcmp une <4 x half> %4, <half 0xH7C00, half 0xH7C00, half 0xH7C00, half 0xH7C00>
// EXP-NEXT:    %5 = tail call <4 x i1> @llvm.experimental.constrained.fcmps.v4f16(<4 x half> %4, <4 x half> <half 0xH7C00, half 0xH7C00, half 0xH7C00, half 0xH7C00>, metadata !"une", metadata !"fpexcept.maytrap")
// CHECK-NEXT:  %6 = zext <4 x i1> %5 to <4 x i16>
// CHECK-NEXT:  ret <4 x i16> %6
short4 test_v4f16_isfinite(half4 x) {
  return __builtin_ipu_isfinite(x);
}

// Test __builtin_ipu_isinf()

// CHECK-LABEL: @test_f32_isinf(float noundef %0)
// CHECK-NEXT:  %2 = tail call i32 @llvm.colossus.f32class(float %0)
// CHECK-NEXT:  %3 = add i32 %2, -3
// CHECK-NEXT:  %4 = icmp ult i32 %3, 2
// CHECK-NEXT:  %5 = zext i1 %4 to i32
// CHECK-NEXT:  ret i32 %5
int test_f32_isinf(float x) {
  return __builtin_ipu_isinf(x);
}

// CHECK-LABEL: @test_v2f16_isinf(<2 x half> noundef %0)

// NOEXP-NEXT:  %2 = tail call <2 x half> @llvm.fabs.v2f16(<2 x half> %0)
// NOEXP-NEXT:  %3 = fcmp oeq <2 x half> %2, <half 0xH7C00, half 0xH7C00>
// NOEXP-NEXT:  %4 = zext <2 x i1> %3 to <2 x i16>
// NOEXP-NEXT:  ret <2 x i16> %4

// EXP-NEXT:    %2 = bitcast <2 x half> %0 to <2 x i16>
// EXP-NEXT:    %3 = and <2 x i16> %2, <i16 31744, i16 31744>
// EXP-NEXT:    %4 = bitcast <2 x i16> %3 to <2 x half>
// EXP-NEXT:    %5 = tail call <2 x i1> @llvm.experimental.constrained.fcmps.v2f16(<2 x half> %4, <2 x half> <half 0xH7C00, half 0xH7C00>, metadata !"oeq", metadata !"fpexcept.maytrap")
// EXP-NEXT:    %6 = and <2 x i16> %2, <i16 1023, i16 1023>
// EXP-NEXT:    %7 = bitcast <2 x i16> %6 to <2 x half>
// EXP-NEXT:    %8 = tail call <2 x i1> @llvm.experimental.constrained.fcmps.v2f16(<2 x half> %7, <2 x half> zeroinitializer, metadata !"oeq", metadata !"fpexcept.maytrap")
// EXP-NEXT:    %9 = and <2 x i1> %8, %5
// EXP-NEXT:    %10 = zext <2 x i1> %9 to <2 x i16>
// EXP-NEXT:    ret <2 x i16> %10
short2 test_v2f16_isinf(half2 x) {
  return __builtin_ipu_isinf(x);
}

// CHECK-LABEL: @test_v2f32_isinf(<2 x float> noundef %0)

// NOEXP-NEXT:  %2 = tail call <2 x float> @llvm.fabs.v2f32(<2 x float> %0)
// NOEXP-NEXT:  %3 = fcmp oeq <2 x float> %2, <float 0x7FF0000000000000, float 0x7FF0000000000000>
// NOEXP-NEXT:  %4 = zext <2 x i1> %3 to <2 x i32>
// NOEXP-NEXT:  ret <2 x i32> %4

// EXP-NEXT:    %2 = bitcast <2 x float> %0 to <2 x i32>
// EXP-NEXT:    %3 = and <2 x i32> %2, <i32 2139095040, i32 2139095040>
// EXP-NEXT:    %4 = bitcast <2 x i32> %3 to <2 x float>
// EXP-NEXT:    %5 = tail call <2 x i1> @llvm.experimental.constrained.fcmps.v2f32(<2 x float> %4, <2 x float> <float 0x7FF0000000000000, float 0x7FF0000000000000>, metadata !"oeq", metadata !"fpexcept.maytrap")
// EXP-NEXT:    %6 = and <2 x i32> %2, <i32 8388607, i32 8388607>
// EXP-NEXT:    %7 = icmp eq <2 x i32> %6, zeroinitializer
// EXP-NEXT:    %8 = and <2 x i1> %5, %7
// EXP-NEXT:    %9 = zext <2 x i1> %8 to <2 x i32>
// EXP-NEXT:    ret <2 x i32> %9
int2 test_v2f32_isinf(float2 x) {
  return __builtin_ipu_isinf(x);
}

// CHECK-LABEL: @test_v4f16_isinf(<4 x half> noundef %0)
// NOEXP-NEXT:  %2 = tail call <4 x half> @llvm.fabs.v4f16(<4 x half> %0)
// NOEXP-NEXT:  %3 = fcmp oeq <4 x half> %2, <half 0xH7C00, half 0xH7C00, half 0xH7C00, half 0xH7C00>
// NOEXP-NEXT:  %4 = zext <4 x i1> %3 to <4 x i16>
// NOEXP-NEXT:  ret <4 x i16> %4

// EXP-NEXT:    %2 = bitcast <4 x half> %0 to <4 x i16>
// EXP-NEXT:    %3 = and <4 x i16> %2, <i16 31744, i16 31744, i16 31744, i16 31744>
// EXP-NEXT:    %4 = bitcast <4 x i16> %3 to <4 x half>
// EXP-NEXT:    %5 = tail call <4 x i1> @llvm.experimental.constrained.fcmps.v4f16(<4 x half> %4, <4 x half> <half 0xH7C00, half 0xH7C00, half 0xH7C00, half 0xH7C00>, metadata !"oeq", metadata !"fpexcept.maytrap")
// EXP-NEXT:    %6 = and <4 x i16> %2, <i16 1023, i16 1023, i16 1023, i16 1023>
// EXP-NEXT:    %7 = bitcast <4 x i16> %6 to <4 x half>
// EXP-NEXT:    %8 = tail call <4 x i1> @llvm.experimental.constrained.fcmps.v4f16(<4 x half> %7, <4 x half> zeroinitializer, metadata !"oeq", metadata !"fpexcept.maytrap")
// EXP-NEXT:    %9 = and <4 x i1> %8, %5
// EXP-NEXT:    %10 = zext <4 x i1> %9 to <4 x i16>
// EXP-NEXT:    ret <4 x i16> %10
short4 test_v4f16_isinf(half4 x) {
  return __builtin_ipu_isinf(x);
}

// Test __builtin_ipu_isnan()

// CHECK-LABEL: @test_f32_isnan(float noundef %0)
// CHECK-NEXT:  %2 = tail call i32 @llvm.colossus.f32class(float %0)
// CHECK-NEXT:  %3 = icmp ult i32 %2, 3
// CHECK-NEXT:  %4 = zext i1 %3 to i32
// CHECK-NEXT:  ret i32 %4
int test_f32_isnan(float x) {
  return __builtin_ipu_isnan(x);
}

// CHECK-LABEL: @test_v2f16_isnan(<2 x half> noundef %0)

// NOEXP-NEXT:  %2 = fcmp uno <2 x half> %0, zeroinitializer
// NOEXP-NEXT:  %3 = zext <2 x i1> %2 to <2 x i16>
// NOEXP-NEXT:  ret <2 x i16> %3

// EXP-NEXT:    %2 = bitcast <2 x half> %0 to <2 x i16>
// EXP-NEXT:    %3 = and <2 x i16> %2, <i16 31744, i16 31744>
// EXP-NEXT:    %4 = bitcast <2 x i16> %3 to <2 x half>
// EXP-NEXT:    %5 = tail call <2 x i1> @llvm.experimental.constrained.fcmps.v2f16(<2 x half> %4, <2 x half> <half 0xH7C00, half 0xH7C00>, metadata !"oeq", metadata !"fpexcept.maytrap")
// EXP-NEXT:    %6 = and <2 x i16> %2, <i16 1023, i16 1023>
// EXP-NEXT:    %7 = bitcast <2 x i16> %6 to <2 x half>
// EXP-NEXT:    %8 = tail call <2 x i1> @llvm.experimental.constrained.fcmps.v2f16(<2 x half> %7, <2 x half> zeroinitializer, metadata !"une", metadata !"fpexcept.maytrap")
// EXP-NEXT:    %9 = and <2 x i1> %8, %5
// EXP-NEXT:    %10 = zext <2 x i1> %9 to <2 x i16>
// EXP-NEXT:    ret <2 x i16> %10
short2 test_v2f16_isnan(half2 x) {
  return __builtin_ipu_isnan(x);
}

// CHECK-LABEL: @test_v2f32_isnan(<2 x float> noundef %0)

// NOEXP-NEXT:  %2 = fcmp uno <2 x float> %0, zeroinitializer
// NOEXP-NEXT:  %3 = zext <2 x i1> %2 to <2 x i32>
// NOEXP-NEXT:  ret <2 x i32> %3

// EXP-NEXT:    %2 = bitcast <2 x float> %0 to <2 x i32>
// EXP-NEXT:    %3 = and <2 x i32> %2, <i32 2139095040, i32 2139095040>
// EXP-NEXT:    %4 = bitcast <2 x i32> %3 to <2 x float>
// EXP-NEXT:    %5 = tail call <2 x i1> @llvm.experimental.constrained.fcmps.v2f32(<2 x float> %4, <2 x float> <float 0x7FF0000000000000, float 0x7FF0000000000000>, metadata !"oeq", metadata !"fpexcept.maytrap")
// EXP-NEXT:    %6 = and <2 x i32> %2, <i32 8388607, i32 8388607>
// EXP-NEXT:    %7 = icmp ne <2 x i32> %6, zeroinitializer
// EXP-NEXT:    %8 = and <2 x i1> %5, %7
// EXP-NEXT:    %9 = zext <2 x i1> %8 to <2 x i32>
// EXP-NEXT:    ret <2 x i32> %9
int2 test_v2f32_isnan(float2 x) {
  return __builtin_ipu_isnan(x);
}

// CHECK-LABEL: @test_v4f16_isnan(<4 x half> noundef %0)

// NOEXP-NEXT:  %2 = fcmp uno <4 x half> %0, zeroinitializer
// NOEXP-NEXT:  %3 = zext <4 x i1> %2 to <4 x i16>
// NOEXP-NEXT:  ret <4 x i16> %3

// EXP-NEXT:    %2 = bitcast <4 x half> %0 to <4 x i16>
// EXP-NEXT:    %3 = and <4 x i16> %2, <i16 31744, i16 31744, i16 31744, i16 31744>
// EXP-NEXT:    %4 = bitcast <4 x i16> %3 to <4 x half>
// EXP-NEXT:    %5 = tail call <4 x i1> @llvm.experimental.constrained.fcmps.v4f16(<4 x half> %4, <4 x half> <half 0xH7C00, half 0xH7C00, half 0xH7C00, half 0xH7C00>, metadata !"oeq", metadata !"fpexcept.maytrap")
// EXP-NEXT:    %6 = and <4 x i16> %2, <i16 1023, i16 1023, i16 1023, i16 1023>
// EXP-NEXT:    %7 = bitcast <4 x i16> %6 to <4 x half>
// EXP-NEXT:    %8 = tail call <4 x i1> @llvm.experimental.constrained.fcmps.v4f16(<4 x half> %7, <4 x half> zeroinitializer, metadata !"une", metadata !"fpexcept.maytrap")
// EXP-NEXT:    %9 = and <4 x i1> %8, %5
// EXP-NEXT:    %10 = zext <4 x i1> %9 to <4 x i16>
// EXP-NEXT:    ret <4 x i16> %10
short4 test_v4f16_isnan(half4 x) {
  return __builtin_ipu_isnan(x);
}
