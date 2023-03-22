#RUN: not llvm-mc -triple colossus-graphcore-elf %s --assemble 2>&1 | FileCheck %s --check-prefix=MEM3-CHECK
#RUN: not llvm-mc -triple colossus-graphcore-elf %s --assemble 2>&1 | FileCheck %s --check-prefix=MEM2-CHECK

# MEM3-CHECK: 6:15: error: Comma missing
# MEM3-CHECK-NEXT: ld32 $m0, $sp $mzero, 0
ld32 $m0, $sp $mzero, 0

# MEM2-CHECK: 10:16: error: Comma missing
# MEM2-CHECK-NEXT: stm32 $m0, $sp $m1
stm32 $m0, $sp $m1

