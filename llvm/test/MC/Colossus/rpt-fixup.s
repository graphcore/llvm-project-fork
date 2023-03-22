# RUN: llvm-mc -triple colossus-graphcore-elf -assemble -show-encoding < %s 1>%t.out
# RUN: FileCheck < %t.out %s
# RUN: not llvm-mc -triple colossus-graphcore-elf -mattr=+supervisor -filetype=obj -assemble \
# RUN: < %s 2>&1 >/dev/null | FileCheck %s -check-prefix=CHECK-SUPERVISOR

# CHECK: fixup A - offset: 0, value: 0, kind: fixup_colossus_single
# CHECK: fixup B - offset: 4, value: 0, kind: fixup_colossus_rpt
# CHECK-NEXT: fixup C - offset: 0, value: ((end-begin)/4)-1, kind: fixup_colossus_8
# CHECK: fixup D - offset: 0, value: 0, kind: fixup_colossus_control
# CHECK-SUPERVISOR: error: instruction requires: Worker mode
  rpt 0, ((end - begin) / 4) - 1
begin:
  add $m0, $m0, 0
end:
