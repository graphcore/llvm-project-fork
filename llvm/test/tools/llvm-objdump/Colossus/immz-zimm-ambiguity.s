# RUN: llvm-mc < %s -filetype=obj | llvm-objdump -d - | FileCheck %s -check-prefix=DEC
# RUN: llvm-mc < %s -filetype=obj | llvm-objdump -d --print-imm-hex - | FileCheck %s -check-prefix=HEX

# Issue T8347.

# DEC: or $a0, $a0, 3152019456
# HEX: or $a0, $a0, 0xbbe00000
or $a0, $a0, 0xbbe00000

# DEC: or $a0, $a0, 3006
# HEX: or $a0, $a0, 0xbbe
or $a0, $a0, 0x00000bbe
