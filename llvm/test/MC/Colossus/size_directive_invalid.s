# RUN: not llvm-mc -triple colossus-graphcore-elf -o %t -filetype=obj  < %s 2>&1 | FileCheck -allow-empty %s

# CHECK::12:27: error: unexpected token in directive
# CHECK:.size myexcellentfunction .-myexcellentfunction
# CHECK:                          ^

myawesomefunction:
nop
nop
nop

.size myexcellentfunction .-myexcellentfunction
No newline at end of file
