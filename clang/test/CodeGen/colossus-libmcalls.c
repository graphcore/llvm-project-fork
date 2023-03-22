// REQUIRES: colossus-registered-target
// RUN: %clang --target=colossus -c -S -I%S/../../../../runtime/include/ %s -o - | FileCheck %s

// Checks that libm function calls with ISA support lower to said instructions

#include <math.h>
#include <__vector_math.h>

// CHECK-LABEL: call_float_exp:
// CHECK:       f32exp
float call_float_exp(float x) { return expf(x); }

// CHECK-LABEL: call_float2_exp:
// CHECK:       f32exp
// CHECK:       f32exp
float2 call_float2_exp(float2 x) { return float2_exp(x); }

// CHECK-LABEL: call_half_exp:
// CHECK:       f16v2exp
half call_half_exp(half x) { return half_exp(x); }

// CHECK-LABEL: call_half2_exp:
// CHECK:       f16v2exp
half2 call_half2_exp(half2 x) { return half2_exp(x); }

// CHECK-LABEL: call_half4_exp:
// CHECK:       f16v2exp
// CHECK:       f16v2exp
half4 call_half4_exp(half4 x) { return half4_exp(x); }

// CHECK-LABEL: call_float_exp2:
// CHECK:       f32exp2
float call_float_exp2(float x) { return exp2f(x); }

// CHECK-LABEL: call_float2_exp2:
// CHECK:       f32exp2
// CHECK:       f32exp2
float2 call_float2_exp2(float2 x) { return float2_exp2(x); }

// CHECK-LABEL: call_half_exp2:
// CHECK:       f16v2exp2
half call_half_exp2(half x) { return half_exp2(x); }

// CHECK-LABEL: call_half2_exp2:
// CHECK:       f16v2exp2
half2 call_half2_exp2(half2 x) { return half2_exp2(x); }

// CHECK-LABEL: call_half4_exp2:
// CHECK:       f16v2exp2
// CHECK:       f16v2exp2
half4 call_half4_exp2(half4 x) { return half4_exp2(x); }

// CHECK-LABEL: call_float_log:
// CHECK:       f32ln
float call_float_log(float x) { return logf(x); }

// CHECK-LABEL: call_float2_log:
// CHECK:       f32ln
// CHECK:       f32ln
float2 call_float2_log(float2 x) { return float2_log(x); }

// CHECK-LABEL: call_half_log:
// CHECK:       f16v2ln
half call_half_log(half x) { return half_log(x); }

// CHECK-LABEL: call_half2_log:
// CHECK:       f16v2ln
half2 call_half2_log(half2 x) { return half2_log(x); }

// CHECK-LABEL: call_half4_log:
// CHECK:       f16v2ln
// CHECK:       f16v2ln
half4 call_half4_log(half4 x) { return half4_log(x); }

// CHECK-LABEL: call_float_log2:
// CHECK:       f32log2
float call_float_log2(float x) { return log2f(x); }

// CHECK-LABEL: call_float2_log2:
// CHECK:       f32log2
// CHECK:       f32log2
float2 call_float2_log2(float2 x) { return float2_log2(x); }

// CHECK-LABEL: call_half_log2:
// CHECK:       f16v2log2
half call_half_log2(half x) { return half_log2(x); }

// CHECK-LABEL: call_half2_log2:
// CHECK:       f16v2log2
half2 call_half2_log2(half2 x) { return half2_log2(x); }

// CHECK-LABEL: call_half4_log2:
// CHECK:       f16v2log2
// CHECK:       f16v2log2
half4 call_half4_log2(half4 x) { return half4_log2(x); }

// CHECK-LABEL: call_float_sqrt:
// CHECK:       f32sqrt
float call_float_sqrt(float x) { return sqrtf(x); }

// CHECK-LABEL: call_float2_sqrt:
// CHECK:       f32sqrt
// CHECK:       f32sqrt
float2 call_float2_sqrt(float2 x) { return float2_sqrt(x); }

// CHECK-LABEL: call_half_sqrt:
// CHECK:       f32sqrt
half call_half_sqrt(half x) { return half_sqrt(x); }

// CHECK-LABEL: call_half2_sqrt:
// CHECK:       f32sqrt
// CHECK:       f32sqrt
half2 call_half2_sqrt(half2 x) { return half2_sqrt(x); }

// CHECK-LABEL: call_half4_sqrt:
// CHECK:       f32sqrt
// CHECK:       f32sqrt
// CHECK:       f32sqrt
// CHECK:       f32sqrt
half4 call_half4_sqrt(half4 x) { return half4_sqrt(x); }

// CHECK-LABEL: call_half_ceil:
// CHECK:       f32int $a{{[0-9]+}}, $a{{[0-9]+}}, 1
half call_half_ceil(half x) { return half_ceil(x); }

// CHECK-LABEL: call_half2_floor:
// CHECK:       f32int $a{{[0-9]+}}, $a{{[0-9]+}}, 2
// CHECK:       f32int $a{{[0-9]+}}, $a{{[0-9]+}}, 2
half2 call_half2_floor(half2 x) { return half2_floor(x); }

// CHECK-LABEL: call_half4_nearbyint:
// CHECK:       f32int $a{{[0-9]+}}, $a{{[0-9]+}}, 0
// CHECK:       f32int $a{{[0-9]+}}, $a{{[0-9]+}}, 0
// CHECK:       f32int $a{{[0-9]+}}, $a{{[0-9]+}}, 0
// CHECK:       f32int $a{{[0-9]+}}, $a{{[0-9]+}}, 0
half4 call_half4_nearbyint(half4 x) { return half4_nearbyint(x); }

// CHECK-LABEL: call_rintf:
// CHECK:       f32int $a{{[0-9]+}}, $a{{[0-9]+}}, 0
float call_rintf(float x) { return rintf(x); }

// CHECK-LABEL: call_float2_round:
// CHECK:       f32int $a{{[0-9]+}}, $a{{[0-9]+}}, 4
// CHECK:       f32int $a{{[0-9]+}}, $a{{[0-9]+}}, 4
float2 call_float2_round(float2 x) { return float2_round(x); }

// CHECK-LABEL: call_half2_trunc:
// CHECK:       f32int $a{{[0-9]+}}, $a{{[0-9]+}}, 3
// CHECK:       f32int $a{{[0-9]+}}, $a{{[0-9]+}}, 3
half2 call_half2_trunc(half2 x) { return half2_trunc(x); }
