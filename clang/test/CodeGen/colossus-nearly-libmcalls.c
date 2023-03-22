// REQUIRES: colossus-registered-target
// RUN: %clang -Wno-incompatible-library-redeclaration --target=colossus -c -S -I%S/../../../../runtime/include/ %s -o - | FileCheck %s

// Check that functions that look similar to libm functions are unchanged

#include <colossus.h>

// CHECK-LABEL: sqrt_arity_mismatch:
// CHECK:       call $m10, sqrtf
float sqrtf(float, float);
float sqrt_arity_mismatch(float x, float y) { return sqrtf(x,y);}

// CHECK-LABEL: exp_type_mismatch:
// CHECK:       call $m10, expf
float expf(half);
float exp_type_mismatch(half x) { return expf(x);}

// CHECK-LABEL: arg_type_prefix_mismatch:
// CHECK:       call $m10, half2_exp
half2 half2_exp(half);
half2 arg_type_prefix_mismatch(half x) { return half2_exp(x); }

// CHECK-LABEL: res_type_prefix_mismatch:
// CHECK:       call $m10, half4_exp2
half half4_exp2(half4);
half res_type_prefix_mismatch(half4 x) { return half4_exp2(x); }

// CHECK-LABEL: both_type_prefix_mismatch:
// CHECK:       call $m10, half2_log
half half2_log(half);
half both_type_prefix_mismatch(half x) { return half2_log(x); }

// CHECK-LABEL: unary_arity_mismatch:
// CHECK:       call $m10, half2_log2
half2 half2_log2(half2,half2);
half2 unary_arity_mismatch(half2 x, half2 y) { return half2_log2(x,y);}

// CHECK-LABEL: binary_arity_mismatch:
// CHECK:       call $m10, float2_pow
float2 float2_pow(float2);
float2 binary_arity_mismatch(float2 x) { return float2_pow(x);}

// CHECK-LABEL: ternary_arity_mismatch:
// CHECK:       call $m10, half2_fma
half2 half2_fma(half2,half2,half2,half2);
half2 ternary_arity_mismatch(half2 x) { return half2_fma(x,x,x,x);}
