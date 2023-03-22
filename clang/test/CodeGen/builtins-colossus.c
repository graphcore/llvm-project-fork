// RUN: %clang_cc1 -triple colossus-unknown-unknown -emit-llvm -o - %s \
// RUN:   | FileCheck %s
// RUN: gc-clang -S -emit-llvm -msupervisor -DSUPERVISOR -o - %s \
// RUN:   | FileCheck %s --check-prefix=CHECK-SUPERVISOR
// RUN: %clang --target=colossus -S -emit-llvm -o - %s -DHALF \
// RUN:   | FileCheck %s --check-prefix=CHECK-HALF
#include <ipu_builtins.h>

typedef __fp16 half2 __attribute__ ((vector_size (sizeof(__fp16)*2)));
typedef __fp16 half4 __attribute__ ((vector_size (sizeof(__fp16)*4)));
typedef float float2 __attribute__ ((vector_size (sizeof(float)*2)));
typedef float float4 __attribute__ ((vector_size (sizeof(float)*4)));

#ifdef SUPERVISOR
unsigned test_get_scount_l() {
// CHECK-SUPERVISOR: %{{.*}} = call i32 @llvm.colossus.get.scount.l()
  unsigned res = __builtin_ipu_get_scount_l();
  return res;
}

unsigned test_get_scount_u() {
// CHECK-SUPERVISOR: %{{.*}} = call i32 @llvm.colossus.get.scount.u()
  unsigned res = __builtin_ipu_get_scount_u();
  return res;
}

unsigned test_get_tile_id() {
// CHECK-SUPERVISOR: %{{.*}} = call i32 @llvm.colossus.get.tile.id()
  unsigned res = __builtin_ipu_get_tile_id();
  return res;
}
#endif // SUPERVISOR

#ifndef SUPERVISOR
void *test_get_vertex_base() {
  // CHECK: %{{.*}} = call ptr @llvm.colossus.get.vertex.base()
  void *res = __builtin_ipu_get_vertex_base();
  return res;
}

unsigned test_get_worker_id() {
// CHECK: %{{.*}} = call i32 @llvm.colossus.get.worker.id()
  unsigned res = __builtin_ipu_get_worker_id();
  return res;
}

typedef unsigned int uint2
    __attribute__((vector_size(sizeof(unsigned int) * 2)));

uint2 test_tapack(const void *x, const void *y, const void *z) {
  // CHECK: %{{.*}} = call <2 x i32> @llvm.colossus.tapack(ptr %{{.*}}, ptr %{{.*}}, ptr %{{.*}})
  uint2 res = __builtin_ipu_tapack(x, y, z);
  return res;
}

typedef float float2
    __attribute__((vector_size(sizeof(float) * 2)));

unsigned test_urand32(void) {
// CHECK: %{{.*}} = call i32 @llvm.colossus.urand32()
  unsigned res = __builtin_ipu_urand32();
  return res;
}

unsigned long long test_urand64(void) {
// CHECK: %{{.*}} = call i64 @llvm.colossus.urand64()
  unsigned long long res = __builtin_ipu_urand64();
  return res;
}

#ifdef HALF
__fp16 test_urand_f16(void) {
// CHECK-HALF: %{{.*}} = call half @llvm.colossus.urand.f16()
  __fp16 res = __builtin_ipu_urand_f16();
  return res;
}

// CHECK-HALF: call <2 x half> @llvm.colossus.f16v2gina.i32(<2 x half> %{{.*}}, i32 1000)
half2 call_f16v2gina(half2 x) {
    return __builtin_ipu_f16v2gina(x, 1000);
}

#endif

float test_urand_f32(void) {
// CHECK: %{{.*}} = call float @llvm.colossus.urand.f32()
  float res = __builtin_ipu_urand_f32();
  return res;
}

int test_f32class(float x) {
// CHECK: %{{.*}} = call i32 @llvm.colossus.f32class(float %{{.*}})
  int res = __builtin_ipu_f32class(x);
  return res;
}

// check float conversions are lowered to LLVM intrinsics.
// this allows libm to implement these conversions by calling __builtin
// lroundf, lrintf are lowered to libm calls as there are no IR builtins

// CHECK: call float @llvm.ceil.f32
float call_ceilf(float x) {return __builtin_ceilf(x);}

// CHECK: call float @llvm.floor.f32
float call_floorf(float x) {return __builtin_floorf(x);}

// CHECK: call float @llvm.trunc.f32
float call_truncf(float x) {return __builtin_truncf(x);}

// CHECK: call float @llvm.round.f32
float call_roundf(float x) {return __builtin_roundf(x);}

// CHECK: call float @llvm.nearbyint.f32
float call_nearbyintf(float x) {return __builtin_nearbyintf(x);}

// CHECK: call float @llvm.rint.f32
float call_rintf(float x) {return __builtin_rintf(x);}

// CHECK: call void @llvm.colossus.uput.i32(i32 %0, i32 209)
void call_uput(unsigned x) {
  __builtin_ipu_uput(x, 209);
}

// CHECK: call void @llvm.colossus.uputf.i32(float %0, i32 209)
void call_uputf(float x) {
  __builtin_ipu_uput(x, 209);
}

// CHECK: call void @llvm.colossus.uputf.i32(float %0, i32 209)
void call_uputf2(float x) {
  __builtin_ipu_uputf(x, 209);
}

// CHECK: call void @llvm.colossus.put.i32(i32 %0, i32 210)
void call_put(unsigned x) {
  __builtin_ipu_put(x, 210);
}

// CHECK: call i32 @llvm.colossus.get.i32(i32 211)
unsigned call_get() {
  return __builtin_ipu_get(211);
}

// CHECK: call i32 @llvm.colossus.uget.i32(i32 212)
unsigned call_uget() {
  return __builtin_ipu_uget(212);
}

// CHECK: call float @llvm.colossus.ugetf.i32(i32 212)
unsigned call_ugetf() {
  return __builtin_ipu_ugetf(212);
}

// CHECK: call i1 @llvm.colossus.is.worker.mode()
int call_is_worker_mode() {
  return __builtin_ipu_is_worker_mode();
}

// CHECK: call i32 @llvm.colossus.and.i32(i32 %0, i32 %1)
int call_and_int(int x, int y) {
  return __builtin_ipu_and(x, y);
}

// CHECK: call i32 @llvm.colossus.and.i32(i32 %0, i32 1000)
int call_and_int_imm(int x) {
  return __builtin_ipu_and(x, 1000);
}

// CHECK: call i32 @llvm.colossus.and.i32(i32 %0, i32 %1)
unsigned call_and_uint(unsigned x, unsigned y) {
  return __builtin_ipu_and(x, y);
}

// CHECK: call float @llvm.colossus.and.f32(float %0, float %1)
float call_and_float(float x, float y) {
  return __builtin_ipu_and(x, y);
}

// CHECK: call <2 x float> @llvm.colossus.and.v2f32(<2 x float> %0, <2 x float> %1)
float2 call_and_float2(float2 x, float2 y) {
  return __builtin_ipu_and(x, y);
}

// CHECK: call i32 @llvm.colossus.andc.i32(i32 %0, i32 %1)
int call_andc_int(int x, int y) {
  return __builtin_ipu_andc(x, y);
}

// CHECK: call i32 @llvm.colossus.andc.i32(i32 %0, i32 1000)
int call_andc_int_imm(int x) {
  return __builtin_ipu_andc(x, 1000);
}

// CHECK: call i32 @llvm.colossus.andc.i32(i32 %0, i32 %1)
unsigned call_andc_uint(unsigned x, unsigned y) {
  return __builtin_ipu_andc(x, y);
}

// CHECK: call float @llvm.colossus.andc.f32(float %0, float %1)
float call_andc_float(float x, float y) {
  return __builtin_ipu_andc(x, y);
}

// CHECK: call <2 x float> @llvm.colossus.andc.v2f32(<2 x float> %0, <2 x float> %1)
float2 call_andc_float2(float2 x, float2 y) {
  return __builtin_ipu_andc(x, y);
}

// CHECK: call i32 @llvm.colossus.or.i32(i32 %0, i32 %1)
int call_or_int(int x, int y) {
  return __builtin_ipu_or(x, y);
}

// CHECK: call i32 @llvm.colossus.or.i32(i32 %0, i32 1000)
int call_or_int_imm(int x) {
  return __builtin_ipu_or(x, 1000);
}

// CHECK: call i32 @llvm.colossus.or.i32(i32 %0, i32 %1)
unsigned call_or_uint(unsigned x, unsigned y) {
  return __builtin_ipu_or(x, y);
}

// CHECK: call float @llvm.colossus.or.f32(float %0, float %1)
float call_or_float(float x, float y) {
  return __builtin_ipu_or(x, y);
}

// CHECK: call <2 x float> @llvm.colossus.or.v2f32(<2 x float> %0, <2 x float> %1)
float2 call_or_float2(float2 x, float2 y) {
  return __builtin_ipu_or(x, y);
}

// CHECK: call float @llvm.colossus.not.f32(float %0)
float call_not_f32(float x) {
  return __builtin_ipu_not(x);
}

// CHECK: call <2 x float> @llvm.colossus.not.v2f32(<2 x float> %0)
float2 call_not_v2f32(float2 x) {
  return __builtin_ipu_not(x);
}

// CHECK: call i32 @llvm.colossus.bitrev8(i32 %0)
unsigned call_bitrev8(unsigned x) {
    return __builtin_ipu_bitrev8(x);
}

// CHECK: call i32 @llvm.colossus.roll8l(i32 %0, i32 %1)
unsigned call_roll8l(unsigned x, unsigned y) {
  return __builtin_ipu_roll8l(x, y);
}

// CHECK: call i32 @llvm.colossus.roll8r(i32 %0, i32 %1)
unsigned call_roll8r(unsigned x, unsigned y) {
  return __builtin_ipu_roll8r(x, y);
}

// CHECK: call <2 x float> @llvm.colossus.roll32(<2 x float> %0, <2 x float> %1)
float2 call_roll32(float2 x, float2 y) {
  return __builtin_ipu_roll32(x, y);
}

// CHECK: call i32 @llvm.colossus.shuf8x8hi(i32 %0, i32 %1)
unsigned call_shuf8x8hi(unsigned x, unsigned y) {
  return __builtin_ipu_shuf8x8hi(x, y);
}

// CHECK: call i32 @llvm.colossus.shuf8x8lo(i32 %0, i32 %1)
unsigned call_shuf8x8lo(unsigned x, unsigned y) {
  return __builtin_ipu_shuf8x8lo(x, y);
}

// CHECK: call <2 x float> @llvm.colossus.sort4x32hi(<2 x float> %0, <2 x float> %1)
float2 call_sort4x32hi(float2 x, float2 y) {
  return __builtin_ipu_sort4x32hi(x, y);
}

// CHECK: call <2 x float> @llvm.colossus.sort4x32lo(<2 x float> %0, <2 x float> %1)
float2 call_sort4x32lo(float2 x, float2 y) {
  return __builtin_ipu_sort4x32lo(x, y);
}

// CHECK: call i32 @llvm.colossus.sort8x8hi(i32 %0, i32 %1)
int call_sort8x8hi(int x, int y) {
  return __builtin_ipu_sort8x8hi(x, y);
}

// CHECK: call i32 @llvm.colossus.sort8x8lo(i32 %0, i32 %1)
int call_sort8x8lo(int x, int y) {
  return __builtin_ipu_sort8x8lo(x, y);
}

// CHECK: call i32 @llvm.colossus.sort8(i32 %0)
unsigned call_sort8(unsigned x) {
  return __builtin_ipu_sort8(x);
}

// CHECK: call i32 @llvm.colossus.swap8(i32 %0)
unsigned call_swap8(unsigned x) {
  return __builtin_ipu_swap8(x);
}

// CHECK: call i32 @llvm.colossus.cms(i32 %0)
unsigned int call_cms(int x) {
    return __builtin_ipu_cms(x);
}

// CHECK: call <2 x half> @llvm.colossus.f16v2clamp(<2 x half> %1, <2 x half> %3)
half2 call_f16v2clamp(half2 x, half2 y) {
    return __builtin_ipu_f16v2clamp(x, y);
}

// CHECK: call <4 x half> @llvm.colossus.f16v4clamp(<4 x half> %1, <2 x half> %3)
half4 call_f16v4clamp(half4 x, half2 y) {
    return __builtin_ipu_f16v4clamp(x, y);
}

// CHECK: call <2 x float> @llvm.colossus.f32v2clamp(<2 x float> %0, <2 x float> %1)
float2 call_f32v2clamp(float2 x, float2 y) {
    return __builtin_ipu_f32v2clamp(x, y);
}

// CHECK: call float @llvm.colossus.f32clamp(float %0, <2 x float> %1)
float call_f32clamp(float x, float2 y) {
    return __builtin_ipu_f32clamp(x, y);
}

// CHECK: call void @llvm.colossus.f16v2cmac(<2 x half> %1, <2 x half> %3)
void call_f16v2cmac(half2 x, half2 y) {
    __builtin_ipu_f16v2cmac(x, y);
}

// CHECK: call void @llvm.colossus.f16v4cmac(<4 x half> %1, <4 x half> %3)
void call_f16v4cmac(half4 x, half4 y) {
    __builtin_ipu_f16v4cmac(x, y);
}

// CHECK: call <2 x half> @llvm.colossus.f16v2absadd(<2 x half> %1, <2 x half> %3)
half2 call_f16v2absadd(half2 x, half2 y) {
    return __builtin_ipu_absadd(x, y);
}

// CHECK: call <4 x half> @llvm.colossus.f16v4absadd(<4 x half> %1, <4 x half> %3)
half4 call_f16v4absadd(half4 x, half4 y) {
    return __builtin_ipu_absadd(x, y);
}

// CHECK: call <2 x float> @llvm.colossus.f32v2absadd(<2 x float> %0, <2 x float> %1)
float2 call_f32v2absadd(float2 x, float2 y) {
    return __builtin_ipu_absadd(x, y);
}

// CHECK: call float @llvm.colossus.f32absadd(float %0, float %1)
float call_f32absadd(float x, float y) {
    return __builtin_ipu_absadd(x, y);
}

// CHECK: call <2 x half> @llvm.colossus.f16v2absmax(<2 x half> %1, <2 x half> %3)
half2 call_f16v2absmax(half2 x, half2 y) {
    return __builtin_ipu_absmax(x, y);
}

// CHECK: call <4 x half> @llvm.colossus.f16v4absmax(<4 x half> %1, <4 x half> %3)
half4 call_f16v4absmax(half4 x, half4 y) {
    return __builtin_ipu_absmax(x, y);
}

// CHECK: call <2 x float> @llvm.colossus.f32v2absmax(<2 x float> %0, <2 x float> %1)
float2 call_f32v2absmax(float2 x, float2 y) {
    return __builtin_ipu_absmax(x, y);
}

// CHECK: call float @llvm.colossus.f32absmax(float %0, float %1)
float call_f32absmax(float x, float y) {
    return __builtin_ipu_absmax(x, y);
}

// CHECK: call <2 x half> @llvm.colossus.f16v2max(<2 x half> %1, <2 x half> %3)
half2 call_f16v2max(half2 x, half2 y) {
    return __builtin_ipu_max(x, y);
}

// CHECK: call <4 x half> @llvm.colossus.f16v4max(<4 x half> %1, <4 x half> %3)
half4 call_f16v4max(half4 x, half4 y) {
    return __builtin_ipu_max(x, y);
}

// CHECK: call <2 x float> @llvm.colossus.f32v2max(<2 x float> %0, <2 x float> %1)
float2 call_f32v2max(float2 x, float2 y) {
    return __builtin_ipu_max(x, y);
}

// CHECK: call float @llvm.colossus.f32max(float %0, float %1)
float call_f32max(float x, float y) {
    return __builtin_ipu_max(x, y);
}

#ifdef HALF
// CHECK-HALF: call half @llvm.colossus.f16v2maxc(<2 x half> %{{.*}})
half call_f16v2maxc(half2 x) {
    return __builtin_ipu_f16v2maxc(x);
}
#endif

// CHECK: call <2 x half> @llvm.colossus.f16v4maxc(<4 x half> %1)
half2 call_f16v4maxc_2(half4 x) {
    return __builtin_ipu_f16v4maxc(x);
}

// CHECK: call <2 x half> @llvm.colossus.f16v2min(<2 x half> %1, <2 x half> %3)
half2 call_f16v2min(half2 x, half2 y) {
    return __builtin_ipu_min(x, y);
}

// CHECK: call <4 x half> @llvm.colossus.f16v4min(<4 x half> %1, <4 x half> %3)
half4 call_f16v4min(half4 x, half4 y) {
    return __builtin_ipu_min(x, y);
}

// CHECK: call <2 x float> @llvm.colossus.f32v2min(<2 x float> %0, <2 x float> %1)
float2 call_f32v2min(float2 x, float2 y) {
    return __builtin_ipu_min(x, y);
}

// CHECK: call float @llvm.colossus.f32min(float %0, float %1)
float call_f32min(float x, float y) {
    return __builtin_ipu_min(x, y);
}

// CHECK: call <2 x half> @llvm.colossus.f16v2cmpeq(<2 x half> %1, <2 x half> %3)
half2 call_f16v2cmpeq(half2 x, half2 y) {
    return __builtin_ipu_f16v2cmpeq(x, y);
}

// CHECK: call <4 x half> @llvm.colossus.f16v4cmpeq(<4 x half> %1, <4 x half> %3)
half4 call_f16v4cmpeq(half4 x, half4 y) {
    return __builtin_ipu_f16v4cmpeq(x, y);
}

// CHECK: call <2 x float> @llvm.colossus.f32v2cmpeq(<2 x float> %0, <2 x float> %1)
float2 call_f32v2cmpeq(float2 x, float2 y) {
    return __builtin_ipu_f32v2cmpeq(x, y);
}

// CHECK: call float @llvm.colossus.f32cmpeq(float %0, float %1)
float call_f32cmpeq(float x, float y) {
    return __builtin_ipu_f32cmpeq(x, y);
}

// CHECK: call <2 x half> @llvm.colossus.f16v2cmpge(<2 x half> %1, <2 x half> %3)
half2 call_f16v2cmpge(half2 x, half2 y) {
    return __builtin_ipu_f16v2cmpge(x, y);
}

// CHECK: call <4 x half> @llvm.colossus.f16v4cmpge(<4 x half> %1, <4 x half> %3)
half4 call_f16v4cmpge(half4 x, half4 y) {
    return __builtin_ipu_f16v4cmpge(x, y);
}

// CHECK: call <2 x float> @llvm.colossus.f32v2cmpge(<2 x float> %0, <2 x float> %1)
float2 call_f32v2cmpge(float2 x, float2 y) {
    return __builtin_ipu_f32v2cmpge(x, y);
}

// CHECK: call float @llvm.colossus.f32cmpge(float %0, float %1)
float call_f32cmpge(float x, float y) {
    return __builtin_ipu_f32cmpge(x, y);
}

// CHECK: call <2 x half> @llvm.colossus.f16v2cmpgt(<2 x half> %1, <2 x half> %3)
half2 call_f16v2cmpgt(half2 x, half2 y) {
    return __builtin_ipu_f16v2cmpgt(x, y);
}

// CHECK: call <4 x half> @llvm.colossus.f16v4cmpgt(<4 x half> %1, <4 x half> %3)
half4 call_f16v4cmpgt(half4 x, half4 y) {
    return __builtin_ipu_f16v4cmpgt(x, y);
}

// CHECK: call <2 x float> @llvm.colossus.f32v2cmpgt(<2 x float> %0, <2 x float> %1)
float2 call_f32v2cmpgt(float2 x, float2 y) {
    return __builtin_ipu_f32v2cmpgt(x, y);
}

// CHECK: call float @llvm.colossus.f32cmpgt(float %0, float %1)
float call_f32cmpgt(float x, float y) {
    return __builtin_ipu_f32cmpgt(x, y);
}

// CHECK: call <2 x half> @llvm.colossus.f16v2cmple(<2 x half> %1, <2 x half> %3)
half2 call_f16v2cmple(half2 x, half2 y) {
    return __builtin_ipu_f16v2cmple(x, y);
}

// CHECK: call <4 x half> @llvm.colossus.f16v4cmple(<4 x half> %1, <4 x half> %3)
half4 call_f16v4cmple(half4 x, half4 y) {
    return __builtin_ipu_f16v4cmple(x, y);
}

// CHECK: call <2 x float> @llvm.colossus.f32v2cmple(<2 x float> %0, <2 x float> %1)
float2 call_f32v2cmple(float2 x, float2 y) {
    return __builtin_ipu_f32v2cmple(x, y);
}

// CHECK: call float @llvm.colossus.f32cmple(float %0, float %1)
float call_f32cmple(float x, float y) {
    return __builtin_ipu_f32cmple(x, y);
}

// CHECK: call <2 x half> @llvm.colossus.f16v2cmplt(<2 x half> %1, <2 x half> %3)
half2 call_f16v2cmplt(half2 x, half2 y) {
    return __builtin_ipu_f16v2cmplt(x, y);
}

// CHECK: call <4 x half> @llvm.colossus.f16v4cmplt(<4 x half> %1, <4 x half> %3)
half4 call_f16v4cmplt(half4 x, half4 y) {
    return __builtin_ipu_f16v4cmplt(x, y);
}

// CHECK: call <2 x float> @llvm.colossus.f32v2cmplt(<2 x float> %0, <2 x float> %1)
float2 call_f32v2cmplt(float2 x, float2 y) {
    return __builtin_ipu_f32v2cmplt(x, y);
}

// CHECK: call float @llvm.colossus.f32cmplt(float %0, float %1)
float call_f32cmplt(float x, float y) {
    return __builtin_ipu_f32cmplt(x, y);
}

// CHECK: call <2 x half> @llvm.colossus.f16v2cmpne(<2 x half> %1, <2 x half> %3)
half2 call_f16v2cmpne(half2 x, half2 y) {
    return __builtin_ipu_f16v2cmpne(x, y);
}

// CHECK: call <4 x half> @llvm.colossus.f16v4cmpne(<4 x half> %1, <4 x half> %3)
half4 call_f16v4cmpne(half4 x, half4 y) {
    return __builtin_ipu_f16v4cmpne(x, y);
}

// CHECK: call <2 x float> @llvm.colossus.f32v2cmpne(<2 x float> %0, <2 x float> %1)
float2 call_f32v2cmpne(float2 x, float2 y) {
    return __builtin_ipu_f32v2cmpne(x, y);
}

// CHECK: call float @llvm.colossus.f32cmpne(float %0, float %1)
float call_f32cmpne(float x, float y) {
    return __builtin_ipu_f32cmpne(x, y);
}

// CHECK: call <2 x half> @llvm.colossus.f16v2exp(<2 x half> %1)
half2 call_f16v2exp(half2 x) {
    return __builtin_ipu_f16v2exp(x);
}

// CHECK: call <2 x half> @llvm.colossus.f16v2exp2(<2 x half> %1)
half2 call_f16v2exp2(half2 x) {
    return __builtin_ipu_f16v2exp2(x);
}

// CHECK: call <2 x half> @llvm.colossus.f16v2ln(<2 x half> %1)
half2 call_f16v2ln(half2 x) {
    return __builtin_ipu_f16v2ln(x);
}

// CHECK: call <2 x half> @llvm.colossus.f16v2log2(<2 x half> %1)
half2 call_f16v2log2(half2 x) {
    return __builtin_ipu_f16v2log2(x);
}

// CHECK: call void @llvm.colossus.f32v2aop.i32(<2 x float> %0, <2 x float> %1, i32 0)
void call_f32v2aop(float2 x, float2 y) {
    __builtin_ipu_f32v2aop(x, y, 0);
}

// CHECK: call <2 x float> @llvm.colossus.f32v2axpy(<2 x float> %0, <2 x float> %1)
float2 call_f32v2axpy(float2 x, float2 y) {
    return __builtin_ipu_f32v2axpy(x, y);
}

// CHECK: call <2 x float> @llvm.colossus.f32v2gina.i32(<2 x float> %0, i32 1000)
float2 call_f32v2gina(float2 x) {
    return __builtin_ipu_f32v2gina(x, 1000);
}

// CHECK: call <2 x half> @llvm.colossus.f16v2grand()
half2 call_f16v2grand() {
    return __builtin_ipu_f16v2grand();
}

// CHECK: call <2 x float> @llvm.colossus.f32v2grand()
float2 call_f32v2grand() {
    return __builtin_ipu_f32v2grand();
}

// CHECK: call <4 x half> @llvm.colossus.f16v4rmask(<4 x half> %1, float %2)
half4 call_f16v4rmask(half4 x, float y) {
    return __builtin_ipu_rmask(x, y);
}

// CHECK: call <2 x float> @llvm.colossus.f32v2rmask(<2 x float> %0, float %1)
float2 call_f32v2rmask(float2 x, float y) {
    return __builtin_ipu_rmask(x, y);
}

// CHECK: call <2 x half> @llvm.colossus.f16v2sigm(<2 x half> %1)
half2 call_f16v2sigm(half2 x) {
    return __builtin_ipu_sigm(x);
}

// CHECK: call float @llvm.colossus.f32sigm(float %0)
float call_f32sigm(float x) {
    return __builtin_ipu_sigm(x);
}

// CHECK: call float @llvm.colossus.f16v2sum(<2 x half> %1)
float call_f16v2sum(half2 x) {
    return __builtin_ipu_sum(x);
}

// CHECK: call <2 x float> @llvm.colossus.f16v4sum(<4 x half> %1)
float2 call_f16v4sum(half4 x) {
    return __builtin_ipu_sum(x);
}

// CHECK: call <2 x half> @llvm.colossus.f16v2tanh(<2 x half> %1)
half2 call_f16v2tanh(half2 x) {
    return __builtin_ipu_tanh(x);
}

// CHECK: call float @llvm.colossus.tanh.f32(float noundef %0)
float call_f32tanh(float x) {
    return __builtin_ipu_tanh(x);
}

#endif // !defined(SUPERVISOR)
