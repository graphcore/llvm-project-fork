# Check that these directives are accepted by the assembler
# Currently they are ignored
# RUN: llvm-mc -triple colossus-graphcore-elf < %s > %t
.supervisor
.worker
