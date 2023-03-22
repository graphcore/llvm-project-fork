# RUN: llvm-mc -filetype=obj -triple colossus-graphcore-elf %s -o - \
# RUN:  | llvm-objdump -d - | FileCheck %s
# RUN: not llvm-mc -filetype=obj -mattr=+supervisor -triple colossus-graphcore-elf \
# RUN:  < %s 2>&1 >/dev/null | FileCheck %s -check-prefix=CHECK-SUPERVISOR

#CHECK: f32max $a0, $a0, $a0
#CHECK-SUPERVISOR: error: instruction requires: Worker mode
f32max $a0, $a0, $a0

#CHECK-NEXT: nop
#CHECK-NEXT: nop
#CHECK-NEXT: nop
.align 16
