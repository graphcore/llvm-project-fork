# RUN: llvm-mc -filetype=obj -triple colossus-graphcore-elf %s -o -| llvm-objdump -d -r - | FileCheck %s
# CHECK: 00000008: R_COLOSSUS_19_S2 printstr
# CHECK: 0000000c:  R_COLOSSUS_20 picklerick
nop
nop
{
		call $m6, printstr
		setzi $a0, picklerick
}
