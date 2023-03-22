
// RUN: clang -c %s -msupervisor -Os -o %t
// RUN: llvm-objdump -d %t | FileCheck %s

//CHECK: bad_floats:
// CHECK:      add $m11, $m11, -24
// CHECK:      st32 $m10, $m11, $m15, 5
// CHECK:      setzi $m2, 293601
// CHECK:      or $m0, $m2, 1067450368
// CHECK:      st32 $m0, $m11, $m15, 3
// CHECK:      setzi $m0, 922747
// CHECK:      or $m0, $m0, 1201668096
// CHECK:      st32 $m0, $m11, $m15, 2
// CHECK:      setzi $m1, 964689
// CHECK:      or $m1, $m1, 1066401792
// CHECK:      st32 $m1, $m11, $m15, 1
// CHECK:      setzi $m1, 335544
// CHECK:      or $m1, $m1, 3951034368
// CHECK:      st32 $m1, $m11, $m15, 0
// CHECK:      or $m1, $m2, 1065353216
// CHECK:      or $m3, $m2, 1066401792
// CHECK:      mov $m2, $m0
// CHECK:      call $m10, 0x0
// CHECK:      ld32 $m10, $m11, $m15, 5
// CHECK:      add $m11, $m11, 24
// CHECK:      br $m10

extern void compute_floats(double x, double y, double z, double w);
void bad_floats() {
    double x = 0.01;
    double y = 0.02;
    double z = 0.03;
    double w = 0.04;
    compute_floats(x, y, z, w);
}