// REQUIRES: colossus-registered-target
// RUN: %clang --target=colossus -c -S -I%S/../../../../runtime/include/ %s -o - | FileCheck %s

#include <colossus.h>

// Check that functions that look similar to intrinsic memory functions are unchanged

// CHECK-LABEL: call_ipu_half2_store_postinc_arity_mismatch:
// CHECK:       call $m10, ipu_half2_store_postinc
void ipu_half2_store_postinc(half2 **, half2, half2, int);
void call_ipu_half2_store_postinc_arity_mismatch(half2 **addr, half2 value) {
  ipu_half2_store_postinc(addr, value, value, 1);
}

// CHECK-LABEL: call_ipu_half2_load_postinc_arity_mismatch:
// CHECK:       call $m10, ipu_half2_load_postinc
half2 ipu_half2_load_postinc(half2 **, int, int);
half2 call_ipu_half2_load_postinc_arity_mismatch(half2 **addr) {
  return ipu_half2_load_postinc(addr, 1, 1);
}

// CHECK-LABEL: call_ipu_half4_load_postinc_type_mismatch:
// CHECK:       call $m10, ipu_half4_load_postinc
float ipu_half4_load_postinc(half4 **, int);
float call_ipu_half4_load_postinc_type_mismatch(half4 **addr) {
  return ipu_half4_load_postinc(addr, 1);
}

// CHECK-LABEL: call_ipu_float2_store_postinc_return_type_mismatch:
// CHECK:       call $m10, ipu_float2_store_postinc
int ipu_float2_store_postinc(float2 **, float2, int);
void call_ipu_float2_store_postinc_return_type_mismatch(float2 **addr, float2 value) {
  ipu_float2_store_postinc(addr, value, 1);
}
