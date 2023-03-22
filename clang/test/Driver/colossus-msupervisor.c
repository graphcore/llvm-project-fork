// Test the colossus -msupervisor argument

// RUN: %clang -###  %s -o %t.o -msupervisor 2>&1 |\
// RUN: FileCheck -check-prefix=CC1-SUPERVISOR %s
// CC1-SUPERVISOR-NOT: "-I"
// CC1-SUPERVISOR-NOT: "-fnative-half-type"
// CC1-SUPERVISOR-NOT: "-fallow-half-arguments-and-returns"
// CC1-SUPERVISOR-NOT: "-fno-lax-vector-conversions"
// CC1-SUPERVISOR: "-mrelocation-model"
// CC1-SUPERVISOR: "static"
// CC1-SUPERVISOR: "-ffunction-sections"
// CC1-SUPERVISOR: "-fdata-sections"
// CC1-SUPERVISOR: "-target-feature" "-worker"
// CC1-SUPERVISOR: "-D__SUPERVISOR__"
// Test runtime path.
// CC1-SUPERVISOR: ../colossus/supervisor/lib"
// Test compiler-rt path.
// CC1-SUPERVISOR: ../lib/graphcore/lib/ipu1
// Test runtime crt path.
// CC1-SUPERVISOR: ../colossus/supervisor/lib/crt

// RUN: %clang -###  %s -o %t.o -msupervisor -fno-integrated-as 2>&1 |\
// RUN: FileCheck -check-prefix=CC1AS-SUPERVISOR %s
// CC1AS-SUPERVISOR: -cc1as
// CC1AS-SUPERVISOR: "-target-feature" "-worker"
// RUN: %clang -###  %s -o %t.o 2>&1 | FileCheck -check-prefix=CC1-WORKER %s
// CC1-WORKER-NOT: "-target-feature" "-worker"
// CC1-WORKER-NOT: "-D__SUPERVISOR__"
// CC1-WORKER-NOT: "-fno-lax-vector-conversions"
// CC1-WORKER-NOT: "-I"
// CC1-WORKER: "-fnative-half-type"
// CC1-WORKER: "-fallow-half-arguments-and-returns"
// CC1-WORKER: "-mrelocation-model"
// CC1-WORKER: "static"
// CC1-WORKER: "-ffunction-sections"
// CC1-WORKER: "-fdata-sections"
// Test runtime path.
// CC1-WORKER: ../colossus/lib"
// Test compiler-rt path.
// CC1-WORKER: ../lib/graphcore/lib/ipu1
// Test runtime crt path.
// CC1-WORKER: ../colossus/lib/crt

// RUN: %clang -###  %s -o %t.o -fno-integrated-as 2>&1 |\
// RUN: FileCheck -check-prefix=CC1AS-WORKER %s
// CC1AS-WORKER: -cc1as
// CC1AS-WORKER-NOT: "-target-feature" "-worker"
