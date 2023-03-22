// REQUIRES: colossus-registered-target
// RUN: %clang -S -emit-llvm -O0 -o - %s | FileCheck %s --check-prefixes=CHECK,O0
// RUN: %clang -S -emit-llvm -O3 -o - %s | FileCheck %s --check-prefixes=CHECK,O3

// This test is to safeguard that inline is happening correctly for a
// codelet-like function after all target features are appropriately set for
// every function. See T13462 and T11494.

class Dummy {
public:
  bool compute() { return true; }
};

// CHECK: @_Z7codeletv()
// CHECK-SAME: #0
__attribute__((colossus_vertex))
int codelet() {
  void *base = __builtin_ipu_get_vertex_base();
  auto v = static_cast<Dummy*>(base);
  return v->compute();
}

// O0: define
// O0-SAME: @_ZN5Dummy7computeEv
// O0-SAME: #0
// O3-NOT: _ZN5Dummy7computeEv

// CHECK: attributes #0
// CHECK-SAME: "target-features"="+worker"
