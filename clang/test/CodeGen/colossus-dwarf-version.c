// REQUIRES: colossus-registered-target
// RUN: %clang -target colossus -emit-llvm -g -S -o - %s | FileCheck %s

int main (void) {
  return 0;
}

// CHECK: !{i32 7, !"Dwarf Version", i32 4}