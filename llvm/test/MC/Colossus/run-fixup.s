# RUN: llvm-mc -triple colossus-graphcore-elf -mattr=+supervisor -filetype=obj -assemble < %s | \
# RUN: llvm-readobj -r - | FileCheck %s
# RUN: not llvm-mc -triple colossus-graphcore-elf -filetype=obj -assemble \
# RUN: < %s 2>&1 >/dev/null | FileCheck %s -check-prefix=CHECK-WORKER

# Force the use of a relocation, even if the symbol value is known
# since the relocation can't be applied without knowing the base of memory.
  run $m0, $m1, vertex
.set vertex, 262144
# CHECK: 0x0 R_COLOSSUS_RUN
# CHECK-WORKER: error: instruction requires: Supervisor mode
