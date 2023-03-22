#RUN: llvm-mc -filetype=obj -mattr=+supervisor -triple colossus-graphcore-elf -assemble %s -o - \
#RUN:   | llvm-objdump --mattr=+supervisor --no-show-raw-insn --triple colossus-graphcore-elf --disassemble - \
#RUN:   | FileCheck %s

setzi $m0, s1
.set s1, 606744
# CHECK: setzi $m0, 606744

bri s2
.set s2, 0x65434
# CHECK: bri 0x65434
