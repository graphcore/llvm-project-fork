// Test the colossus -march argument

// RUN: %clang -### %s -o %t.o 2>&1 | FileCheck -check-prefix CHECK-IPU1 %s
// RUN: %clang -### %s -o %t.o -march=ipu1 2>&1 | FileCheck -check-prefixes CHECK-IPU1,CHECK-IPU1-TARGET %s
// RUN: %clang -### %s -o %t.o -march=ipu2 2>&1 | FileCheck -check-prefix CHECK-IPU2 %s

// CHECK-DAG: -D__IPU__
// CHECK-IPU1-TARGET: "-target-cpu" "ipu1"
// CHECK-IPU2-DAG: "-target-cpu" "ipu2"
// CHECK-IPU1-DAG: -D__IPU_ARCH_VERSION__=1
// CHECK-IPU2-DAG: -D__IPU_ARCH_VERSION__=2
// CHECK-IPU1-DAG: -D__IPU_REPEAT_COUNT_SIZE__=12
// CHECK-IPU2-DAG: -D__IPU_REPEAT_COUNT_SIZE__=16
// CHECK-DAG: -L..{{.*}}/ldscripts
// CHECK-IPU1-DAG: ipu1.x
// CHECK-IPU2-DAG: ipu2.x
// CHECK-IPU1-DAG: -lipu1
// CHECK-IPU2-DAG: -lipu2
// CHECK-IPU1-DAG: lib/crt_ipu1.o
// CHECK-IPU2-DAG: lib/crt_ipu2.o

// RUN: %clang %s -c -march=ipu1 2>&1 | FileCheck -check-prefix UNKNOWN-IPU1 %s -allow-empty
// RUN: %clang %s -c -march=ipu2 2>&1 | FileCheck -check-prefix UNKNOWN-IPU2 %s -allow-empty
// UNKNOWN-IPU1-NOT: '+ipu1' is not a recognized feature for this target (ignoring feature)
// UNKNOWN-IPU2-NOT: '+ipu2' is not a recognized feature for this target (ignoring feature)

// RUN: %clang -### %s -march=ipu1 -r -Tscript.x -efoo -Lmy_path -Lmy_path2 2>&1 | FileCheck -check-prefix FORWARDED-ARGS %s
// library paths
// FORWARDED-ARGS-NOT: ipu1.x
// FORWARDED-ARGS: "-Lmy_path"
// FORWARDED-ARGS: "-Lmy_path2"
// relocatable object
// FORWARDED-ARGS: "-r"
// trace input files
// linker script
// FORWARDED-ARGS: "-T" "script.x"
// entry
// FORWARDED-ARGS: "-e" "foo"
