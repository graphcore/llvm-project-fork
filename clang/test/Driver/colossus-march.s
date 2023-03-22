// Test the colossus -march argument

// RUN: %clang -### %s -o %t.o 2>&1 | FileCheck %s
// RUN: %clang -### %s -o %t.o -march=ipu1 2>&1 | FileCheck -check-prefix CHECK-IPU1 %s
// RUN: %clang -### %s -o %t.o -march=ipu2 2>&1 | FileCheck -check-prefix CHECK-IPU2 %s

// CHECK-NOT: "-target-feature "+ipu"
// CHECK-IPU1: "-target-feature" "+ipu1"
// CHECK-IPU2: "-target-feature" "+ipu2"
