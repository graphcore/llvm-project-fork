// REQUIRES: colossus-registered-target
// RUN: %clang_cc1 -triple colossus -emit-llvm -o - %s | FileCheck %s

void test_clobbers(void) {
  asm("" : : : "$m0" ,"$m1" ,"$m2" ,"$m3" ,"$m4" ,"$m5" ,"$m6" ,"$m7" ,
               "$m8" ,"$m9" ,"$m10","$m11","$m12","$m13","$m14","$m15",
               "$a0" ,"$a1" ,"$a2" ,"$a3" ,"$a4" ,"$a5" ,"$a6" ,"$a7" ,
               "$a8" ,"$a9" ,"$a10","$a11","$a12","$a13","$a14","$a15",
               "$a0:1", "$a2:3", "$a4:5", "$a6:7");
}

void test_aliases(void) {
  asm("" : : : "$bp");
  // CHECK: call void asm sideeffect "", "~{$m8}"()
  asm("" : : : "$fp");
  // CHECK: call void asm sideeffect "", "~{$m9}"()
  asm("" : : : "$lr");
  // CHECK: call void asm sideeffect "", "~{$m10}"()
  asm("" : : : "$sp");
  // CHECK: call void asm sideeffect "", "~{$m11}"()
  asm("" : : : "$mworker_base");
  // CHECK: call void asm sideeffect "", "~{$m12}"()
  asm("" : : : "$mvertex_base");
  // CHECK: call void asm sideeffect "", "~{$m13}"()
  asm("" : : : "$mzero");
  // CHECK: call void asm sideeffect "", "~{$m15}"()
  asm("" : : : "$azero");
  // CHECK: call void asm sideeffect "", "~{$a15}"()
}
