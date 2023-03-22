# RUN: llvm-mc -mattr=+ipu2 -triple colossus-graphcore-elf -assemble -show-encoding < %s 1>%t.out
# RUN: FileCheck < %t.out %s

# CHECK: #   fixup A - offset: 0, value: 0, kind: fixup_colossus_single
# CHECK: #   fixup B - offset: 0, value: 0, kind: fixup_colossus_system
# CHECK-NOT: fixup C
  put 0, $m0

label:
