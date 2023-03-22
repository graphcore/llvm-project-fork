# Check  that the option -mattr=+supervisor is silently accepted
#RUN: llvm-mc -triple colossus-graphcore-elf -mattr=+supervisor -assemble \
#RUN: -show-encoding < %s 2>&1  | FileCheck %s

#CHECK-NOT: '+supervisor' is not a recognized feature for this target (ignoring feature)