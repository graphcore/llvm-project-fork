// RUN: clang -S -O3 -mmax-nops-in-rpt=10 %s -o - | FileCheck %s -check-prefix=CHECK



// CHECK-LABEL: Loop_64b_builtin_small:
// CHECK:   rpt {{\$m[0-9]+}}, {{[0-9]}}
// CHECK:   br $m10
unsigned Loop_64b_builtin_small(unsigned long long inc, unsigned*arr) {
  unsigned z=0;
  __builtin_assume(inc < 2000);

  while (inc) {
      z += arr[inc];
      inc--;
  }

  return z;
}


// CHECK-LABEL: Loop_64b_builtin_32b:
// CHECK-NOT:   rpt
// CHECK:       [[LABEL_LOOP:\.L[A-Z0-9_]+]]:
// CHECK:       brnzdec {{\$m[0-9]+}}, [[LABEL_LOOP]]
// CHECK-NOT:   rpt
// CHECK:       br $m10
unsigned Loop_64b_builtin_32b(unsigned long long inc, unsigned*arr) {
  unsigned z=0;
  __builtin_assume(inc <= 0xFFFFFFFF);
  
  while (inc) {
      z += arr[inc];
      inc--;
  }

  return z;
}
