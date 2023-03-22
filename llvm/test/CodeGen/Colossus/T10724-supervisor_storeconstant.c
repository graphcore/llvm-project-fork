// RUN: clang -c %s -msupervisor -march=ipu1 -Os -o %t
// RUN: llvm-objdump -d %t | FileCheck %s
// RUN: clang -c %s -msupervisor -march=ipu2 -Os -o %t
// RUN: llvm-objdump -d %t | FileCheck %s

// RUN: clang -c %s -msupervisor -march=ipu2 -Os -o %t
// RUN: llvm-objdump -d %t | FileCheck %s

// CHECK: setPacket:
// CHECK:       mov $m1, $m0
// CHECK:       mov $m0, $m15
// CHECK:       setzi $m2, 811342
// CHECK:       or $m2, $m2, 11534336
// CHECK:       st32 $m2, $m1, $m15, 0
// CHECK:       br $m10
int setPacket(unsigned int *p) {
  *p = 12345678;
  return 0;
}
