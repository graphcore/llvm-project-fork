# RUN: llvm-mc -triple colossus-graphcore-elf -filetype=obj -assemble < %s | \
# RUN: llvm-readobj -r - | FileCheck %s

.globl defined_bar
defined_bar:
# CHECK: 0x0 R_COLOSSUS_RELATIVE_16_S2 bar 0x4
.short (bar + 4)@relative@16@s2

# CHECK: 0x2 R_COLOSSUS_18_S2 bar 0x4
.long (bar + 4)@abs18@s2

# CHECK: 0x6 R_COLOSSUS_19_S2 bar 0x4
.long (bar + 4)@abs19@s2

# CHECK: 0xA R_COLOSSUS_19_S2 defined_bar 0x4
.long (defined_bar + 4)@abs19@s2
