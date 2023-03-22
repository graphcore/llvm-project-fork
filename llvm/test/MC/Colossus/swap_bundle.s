#RUN: llvm-mc -filetype=obj -triple colossus-graphcore-elf -assemble %s -o - \
#RUN:   | llvm-objdump --no-show-raw-insn --triple colossus-graphcore-elf --disassemble - \
#RUN:   | FileCheck %s
#RUN: not llvm-mc -filetype=obj -triple colossus-graphcore-elf -mattr=+supervisor -assemble \
#RUN:   < %s 2>&1 >/dev/null | FileCheck %s -check-prefix=CHECK-SUPERVISOR

.allow_optimizations
#CHECK:<loop>:
#CHECK-NEXT:    {
#CHECK-NEXT:    brnzdec $m1, 0x0
#CHECK-NEXT:    f32add $a1, $a1, $a2
#CHECK-NEXT:    }
#CHECK-SUPERVISOR: error: instruction requires: Worker mode
loop:
  // do some stuff
  {
    f32add $a1, $a1, $a2
    brnzdec $m1, loop
  }
