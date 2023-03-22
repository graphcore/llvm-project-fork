// Test the colossus -msupervisor argument

// RUN: %clang -### %s -o %t.o 2>&1 | FileCheck %s
// RUN: %clang -### %s -o %t.o -msupervisor 2>&1 | FileCheck -check-prefix SUPERVISOR %s
// RUN: %clang -### %s -o %t.o -msupervisor -march=ipu1 2>&1 | FileCheck -check-prefix MULTIPLE_FEATURE %s

// CHECK-NOT: "-target-feature"
// SUPERVISOR: "-target-feature" "-worker"
// MULTIPLE_FEATURE: "-target-feature" "-worker" "-target-feature" "+ipu1"
