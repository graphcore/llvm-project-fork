// REQUIRES: colossus-registered-target
// RUN: %clang --target=colossus -c -O0 -S -I%S/../../../../runtime/include/ %s -o - | FileCheck %s
// RUN: %clang --target=colossus -c -O1 -S -I%S/../../../../runtime/include/ %s -o - | FileCheck %s

#include <__memory_intrinsics.h>

// CHECK-LABEL: call_ipu_half2_store_postinc:
// CHECK:       st32step
void call_ipu_half2_store_postinc(half2 **addr, half2 value) { ipu_half2_store_postinc(addr, value, 1); }

// CHECK-LABEL: call_ipu_half2_store_postinc_var:
// CHECK:       st32step
void call_ipu_half2_store_postinc_var(half2 **addr, half2 value, int N) { ipu_half2_store_postinc(addr, value, N); }

// CHECK-LABEL: call_ipu_half2_load_postinc:
// CHECK:       ld32step
half2 call_ipu_half2_load_postinc(const half2 **addr) { return ipu_half2_load_postinc(addr, 1); }

// CHECK-LABEL: call_ipu_half2_load_postinc_var:
// CHECK:       ld32step
half2 call_ipu_half2_load_postinc_var(const half2 **addr, int N) { return ipu_half2_load_postinc(addr, N); }

// CHECK-LABEL: call_ipu_half4_store_postinc:
// CHECK:       st64step
void call_ipu_half4_store_postinc(half4 **addr, half4 value) { ipu_half4_store_postinc(addr, value, 1); }

// CHECK-LABEL: call_ipu_half4_store_postinc_var:
// CHECK:       st64step
void call_ipu_half4_store_postinc_var(half4 **addr, half4 value, int N) { ipu_half4_store_postinc(addr, value, N); }

// CHECK-LABEL: call_ipu_half4_load_postinc:
// CHECK:       ld64step
half4 call_ipu_half4_load_postinc(const half4 **addr) { return ipu_half4_load_postinc(addr, 1); }

// CHECK-LABEL: call_ipu_half4_load_postinc_var:
// CHECK:       ld64step
half4 call_ipu_half4_load_postinc_var(const half4 **addr, int N) { return ipu_half4_load_postinc(addr, N); }

// CHECK-LABEL: call_ipu_float_store_postinc:
// CHECK:       st32step
void call_ipu_float_store_postinc(float **addr, float value) { ipu_float_store_postinc(addr, value, 1); }

// CHECK-LABEL: call_ipu_float_store_postinc_var:
// CHECK:       st32step
void call_ipu_float_store_postinc_var(float **addr, float value, int N) { ipu_float_store_postinc(addr, value, N); }

// CHECK-LABEL: call_ipu_float_load_postinc:
// CHECK:       ld32step
float call_ipu_float_load_postinc(const float **addr) { return ipu_float_load_postinc(addr, 1); }

// CHECK-LABEL: call_ipu_float_load_postinc_var:
// CHECK:       ld32step
float call_ipu_float_load_postinc_var(const float **addr, int N) { return ipu_float_load_postinc(addr, N); }

// CHECK-LABEL: call_ipu_float2_store_postinc:
// CHECK:       st64step
void call_ipu_float2_store_postinc(float2 **addr, float2 value) { ipu_float2_store_postinc(addr, value, 1); }

// CHECK-LABEL: call_ipu_float2_store_postinc_var:
// CHECK:       st64step
void call_ipu_float2_store_postinc_var(float2 **addr, float2 value, int N) { ipu_float2_store_postinc(addr, value, N); }

// CHECK-LABEL: call_ipu_float2_load_postinc:
// CHECK:       ld64step
float2 call_ipu_float2_load_postinc(const float2 **addr) { return ipu_float2_load_postinc(addr, 1); }

// CHECK-LABEL: call_ipu_float2_load_postinc_var:
// CHECK:       ld64step
float2 call_ipu_float2_load_postinc_var(const float2 **addr, int N) { return ipu_float2_load_postinc(addr, N); }

// CHECK-LABEL: call_ipu_int_store_postinc:
// CHECK:       st32step
void call_ipu_int_store_postinc(int **addr, int value) { ipu_int_store_postinc(addr, value, 1); }

// CHECK-LABEL: call_ipu_int_store_postinc_var:
// CHECK:       stm32step
void call_ipu_int_store_postinc_var(int **addr, int value, int N) { ipu_int_store_postinc(addr, value, N); }

// CHECK-LABEL: call_ipu_int_load_postinc:
// CHECK:       ld32step
int call_ipu_int_load_postinc(const int **addr) { return ipu_int_load_postinc(addr, 1); }

// CHECK-LABEL: call_ipu_int_load_postinc_var:
// CHECK:       ld32step
int call_ipu_int_load_postinc_var(const int **addr, int N) { return ipu_int_load_postinc(addr, N); }

// CHECK-LABEL: call_ipu_uint_store_postinc:
// CHECK:       st32step
void call_ipu_uint_store_postinc(unsigned **addr, unsigned value) { ipu_uint_store_postinc(addr, value, 1); }

// CHECK-LABEL: call_ipu_uint_store_postinc_var:
// CHECK:       stm32step
void call_ipu_uint_store_postinc_var(unsigned **addr, unsigned value, int N) { ipu_uint_store_postinc(addr, value, N); }

// CHECK-LABEL: call_ipu_uint_load_postinc:
// CHECK:       ld32step
unsigned call_ipu_uint_load_postinc(const unsigned **addr) { return ipu_uint_load_postinc(addr, 1); }

// CHECK-LABEL: call_ipu_uint_load_postinc_var:
// CHECK:       ld32step
unsigned call_ipu_uint_load_postinc_var(const unsigned **addr, int N) { return ipu_uint_load_postinc(addr, N); }

// CHECK-LABEL: call_ipu_short_load_postinc:
// CHECK:       lds16step
short call_ipu_short_load_postinc(const short **addr) { return ipu_short_load_postinc(addr, 1); }

// CHECK-LABEL: call_ipu_short_load_postinc_var:
// CHECK:       lds16step
short call_ipu_short_load_postinc_var(const short **addr, int N) { return ipu_short_load_postinc(addr, N); }

// CHECK-LABEL: call_ipu_ushort_load_postinc:
// CHECK:       ldz16step
unsigned short call_ipu_ushort_load_postinc(const unsigned short **addr) { return ipu_ushort_load_postinc(addr, 1); }

// CHECK-LABEL: call_ipu_ushort_load_postinc_var:
// CHECK:       ldz16step
unsigned short call_ipu_ushort_load_postinc_var(const unsigned short **addr, int N) { return ipu_ushort_load_postinc(addr, N); }

// CHECK-LABEL: call_ipu_char_load_postinc:
// CHECK:       lds8step
char call_ipu_char_load_postinc(const char **addr) { return ipu_char_load_postinc(addr, 1); }

// CHECK-LABEL: call_ipu_char_load_postinc_var:
// CHECK:       lds8step
char call_ipu_char_load_postinc_var(const char **addr, int N) { return ipu_char_load_postinc(addr, N); }

// CHECK-LABEL: call_ipu_uchar_load_postinc:
// CHECK:       ldz8step
unsigned char call_ipu_uchar_load_postinc(const unsigned char **addr) { return ipu_uchar_load_postinc(addr, 1); }

// CHECK-LABEL: call_ipu_uchar_load_postinc_var:
// CHECK:       ldz8step
unsigned char call_ipu_uchar_load_postinc_var(const unsigned char **addr, int N) { return ipu_uchar_load_postinc(addr, N); }
