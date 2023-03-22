#RUN: llvm-mc -mattr=+ipu1 -filetype=obj -triple colossus-graphcore-elf -assemble %s -o - \
#RUN:   | llvm-objdump --no-show-raw-insn --triple colossus-graphcore-elf --disassemble - \
#RUN:   | FileCheck %s
#RUN: not llvm-mc -mattr=+ipu1  -filetype=obj -mattr=+supervisor -triple colossus-graphcore-elf -assemble %s -o - \
#RUN:   < %s 2>&1 >/dev/null | FileCheck %s -check-prefix=CHECK-SUPERVISOR

.align 8
{ rpt 0, s8 ; fnop }
.set s8, 146
# CHECK: rpt 0, 146
# CHECK-SUPERVISOR: error: instruction requires: Worker mode
