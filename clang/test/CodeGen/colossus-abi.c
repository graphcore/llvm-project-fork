// REQUIRES: colossus-registered-target
// RUN: %clang_cc1 -triple colossus -verify %s

_Static_assert(sizeof(long) == 4, "sizeof long long is wrong");
_Static_assert(_Alignof(long) == 4, "alignof long long is wrong");

_Static_assert(sizeof(long long) == 8, "sizeof long long is wrong");
_Static_assert(_Alignof(long long) == 8, "alignof long long is wrong");

// RUN: %clang_cc1 -triple colossus-unknown-unknown -fno-signed-char -fno-common -emit-llvm -o - %s | FileCheck %s

// CHECK: target triple = "colossus-unknown-unknown"

#include <stdarg.h>
struct x { int a[5]; };
void f(void*);
void testva (int n, ...) {
  // CHECK-LABEL: testva
  va_list ap;
  va_start(ap,n);
  // CHECK: [[AP:%[a-z0-9]+]] = alloca ptr, align 4
  // CHECK: call void @llvm.va_start(ptr [[AP]])

  char* v1 = va_arg (ap, char*);
  f(v1);
  // CHECK: [[I:%[a-z0-9]+]] = load ptr, ptr [[AP]], align 4
  // CHECK: [[IN:%[a-z0-9]+]] = getelementptr inbounds i8, ptr [[I]], i32 4
  // CHECK: store ptr [[IN]], ptr [[AP]], align 4
  // CHECK: [[V1:%[a-z0-9]+]] = load ptr, ptr [[I]], align 4
  // CHECK: store ptr [[V1]], ptr [[V:%[a-z0-9]+]], align 4
  // CHECK: [[V2:%[a-z0-9]+]] = load ptr, ptr [[V]], align 4
  // CHECK: call void @f(ptr noundef [[V2]])

  char v2 = va_arg (ap, char); // expected-warning{{second argument to 'va_arg' is of promotable type 'char'}}
  f(&v2);
  // CHECK: [[I:%[a-z0-9]+]] = load ptr, ptr [[AP]], align 4
  // CHECK: [[IN:%[a-z0-9]+]] = getelementptr inbounds i8, ptr [[I]], i32 4
  // CHECK: store ptr [[IN]], ptr [[AP]], align 4
  // CHECK: [[V1:%[a-z0-9]+]] = load i8, ptr [[I]], align 4
  // CHECK: store i8 [[V1]], ptr [[V:%[a-z0-9]+]], align 1
  // CHECK: call void @f(ptr noundef [[V]])

  int v3 = va_arg (ap, int);
  f(&v3);
  // CHECK: [[I:%[a-z0-9]+]] = load ptr, ptr [[AP]], align 4
  // CHECK: [[IN:%[a-z0-9]+]] = getelementptr inbounds i8, ptr [[I]], i32 4
  // CHECK: store ptr [[IN]], ptr [[AP]], align 4
  // CHECK: [[V1:%[a-z0-9]+]] = load i32, ptr [[I]], align 4
  // CHECK: store i32 [[V1]], ptr [[V:%[a-z0-9]+]], align 4
  // CHECK: call void @f(ptr noundef [[V]])

  struct x v5 = va_arg (ap, struct x);  // typical aggregate type
  f(&v5);
  // CHECK: [[I:%[a-z0-9]+]] = load ptr, ptr [[AP]], align 4
  // CHECK: [[P:%[a-z0-9]+]] = load ptr, ptr [[I]], align 4
  // CHECK: [[IN:%[a-z0-9]+]] = getelementptr inbounds i8, ptr [[I]], i32 4
  // CHECK: store ptr [[IN]], ptr [[AP]], align 4
  // CHECK: call void @llvm.memcpy.p0.p0.i32(ptr align 4 [[V:%[a-z0-9]+]], ptr align 4 [[P]], i32 20, i1 false)
  // CHECK: call void @f(ptr noundef [[V]])

  int* v6 = va_arg (ap, int[4]);  // an unusual aggregate type
  f(v6);
  // CHECK: [[I:%[a-z0-9]+]] = load ptr, ptr [[AP]], align 4
  // CHECK: [[P:%[a-z0-9]+]] = load ptr, ptr [[I]], align 4
  // CHECK: [[IN:%[a-z0-9]+]] = getelementptr inbounds i8, ptr [[I]], i32 4
  // CHECK: store ptr [[IN]], ptr [[AP]], align 4
  // CHECK: call void @llvm.memcpy.p0.p0.i32(ptr align 4 [[V0:%[a-z0-9]+]], ptr align 4 [[P]], i32 16, i1 false)
  // CHECK: [[V2:%[a-z0-9]+]] = getelementptr inbounds [4 x i32], ptr [[V0]], i32 0, i32 0
  // CHECK: store ptr [[V2]], ptr [[V:%[a-z0-9]+]], align 4
  // CHECK: [[V3:%[a-z0-9]+]] = load ptr, ptr [[V]], align 4
  // CHECK: call void @f(ptr noundef [[V3]])
}

// CHECK: "frame-pointer"="none"
