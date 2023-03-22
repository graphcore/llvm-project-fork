// RUN: not %clang_cc1 -triple colossus-unknown-unknown -emit-llvm -o - /dev/null %s 2>&1 \
// RUN:   -D ERROR1| FileCheck %s --check-prefix CHECK-ERROR1
// RUN: not %clang_cc1 -triple colossus-unknown-unknown -emit-llvm -o - /dev/null %s 2>&1 \
// RUN:   -D ERROR2 | FileCheck %s --check-prefix CHECK-ERROR2
// RUN: not %clang_cc1 -triple colossus-unknown-unknown -emit-llvm -o - /dev/null %s 2>&1 \
// RUN:   -D ERROR3 | FileCheck %s --check-prefix CHECK-ERROR3

typedef __fp16 half2 __attribute__ ((vector_size (sizeof(__fp16)*2)));
typedef float float2 __attribute__ ((vector_size (sizeof(float)*2)));

#ifdef ERROR1
// CHECK-ERROR1: error: Immediate argument must be a constant unsigned integer < 4096.
float2 call_f32v2gina_bigimm(float2 x) {
  return __builtin_ipu_f32v2gina(x, 10000);
}

// CHECK-ERROR1: error: argument to '__builtin_ipu_uput' must be a constant integer
void call_uput(unsigned x, unsigned y) {
  __builtin_ipu_uput(x, y);
}

// CHECK-ERROR1: error: argument to '__builtin_ipu_put' must be a constant integer
void call_put(unsigned x, unsigned y) {
  __builtin_ipu_put(x, y);
}

// CHECK-ERROR1: error: argument to '__builtin_ipu_get' must be a constant integer
unsigned call_get(unsigned x) {
  return __builtin_ipu_get(x);
}

// CHECK-ERROR1: error: argument to '__builtin_ipu_uget' must be a constant integer
unsigned call_uget(unsigned x) {
  return __builtin_ipu_uget(x);
}

// CHECK-ERROR1: error: argument to '__builtin_ipu_f32v2aop' must be a constant integer
void call_f32v2aop(float2 src0, float2 src1, unsigned x) {
  __builtin_ipu_f32v2aop(src0, src1, x);
}

// CHECK-ERROR1: error: argument to '__builtin_ipu_f16v2gina' must be a constant integer
half2 call_f16v2gina(half2 x, unsigned y) {
  return __builtin_ipu_f16v2gina(x, y);
}

// CHECK-ERROR1: error: argument to '__builtin_ipu_f32v2gina' must be a constant integer
float2 call_f32v2gina(float2 x, unsigned y) {
  return __builtin_ipu_f32v2gina(x, y);
}

// CHECK-ERROR1: warning: implicit conversion from 'int' to 'unsigned char' changes value from 256 to 0
void call_uput_warning(unsigned x) {
  __builtin_ipu_uput(x, 256);
}

// CHECK-ERROR1: warning: implicit conversion from 'int' to 'unsigned char' changes value from 257 to 1
void call_put_warning(unsigned x) {
  __builtin_ipu_put(x, 257);
}

// CHECK-ERROR1: warning: implicit conversion from 'int' to 'unsigned char' changes value from 258 to 2
unsigned call_get_warning() {
  return __builtin_ipu_get(258);
}

// CHECK-ERROR1: warning: implicit conversion from 'int' to 'unsigned char' changes value from 259 to 3
unsigned call_uget_warning() {
  return __builtin_ipu_uget(259);
}

// CHECK-ERROR1: warning: implicit conversion from 'int' to 'unsigned char' changes value from 260 to 4
void call_f32v2aop_warning(float2 src0, float2 src1) {
  __builtin_ipu_f32v2aop(src0, src1, 260);
}
#endif // ERROR1

#ifdef ERROR2
// CHECK-ERROR2: error: Immediate argument must be a constant unsigned integer < 4096.
half2 call_f16v2gina_bigimm(half2 x) {
  return __builtin_ipu_f16v2gina(x, 10000);
}
#endif // ERROR2

#ifdef ERROR3
// CHECK-ERROR3: error: '__builtin_ipu_get_tile_id' needs target feature supervisor
unsigned call_get_tile_id_in_worker() {
  return __builtin_ipu_get_tile_id();
}
#endif // ERROR3
