// REQUIRES: colossus-registered-target
// RUN: %clang_cc1 -triple colossus -emit-llvm -o - %s | FileCheck %s

// CHECK: define dso_local colossus_vertex void @foo()
__attribute__((colossus_vertex))
void foo() {
}

// CHECK: define dso_local colossus_vertex void @bar()
void bar() __attribute__((colossus_vertex)) {
}

// CHECK: define dso_local void @baz() [[ATTR2:#[0-9]+]]
void baz() {
}

// Allow function pointers with colossus_vertex attribute
// CHECK-NOT: attribute only applies to functions
typedef int (*vertex_fptr_t)(void)  __attribute__((colossus_vertex));;
