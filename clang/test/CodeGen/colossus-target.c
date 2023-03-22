// REQUIRES: colossus-registered-target
// RUN: %clang_cc1 -triple colossus -emit-llvm -o - %s | FileCheck %s --check-prefixes=CHECK,CC1
// RUN: %clang -S -emit-llvm -o - %s | FileCheck %s --check-prefixes=CHECK,WORKER
// RUN: %clang -S -emit-llvm -msupervisor -o - %s | FileCheck %s --check-prefixes=CHECK,SUPERVISOR

// CHECK: void @func_supervisor() #0
__attribute__((target("supervisor")))
void func_supervisor() {}

// CHECK: void @func_worker() #1
__attribute__((target("worker")))
void func_worker() {}

// CHECK: void @func_supervisor2() #0
__attribute__((target("supervisor")))
void func_supervisor2() {}

// SUPERVISOR: void @func_unspecified() #0
// WORKER: void @func_unspecified() #1
// CC1: void @func_unspecified() #1
void func_unspecified() {}

// CHECK: void @func_both() #2
__attribute__((target("both")))
void func_both() {}

// CHECK: attributes #0
// CHECK-SAME: "target-features"="+supervisor"
// CHECK: attributes #1
// CHECK-SAME: "target-features"="+worker"
// CHECK: attributes #2
// CHECK-SAME: "target-features"="+both"
