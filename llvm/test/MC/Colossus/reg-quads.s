# RUN: llvm-mc -triple colossus-graphcore-elf -show-encoding < %s | FileCheck %s \
# RUN: -check-prefix=CHECK-IPU1
# RUN: not llvm-mc -triple colossus-graphcore-elf -mattr=+supervisor \
# RUN:   < %s 2>&1 >/dev/null | FileCheck %s -check-prefix=CHECK-SUPERVISOR

# CHECK-IPU1: ld128 $a0:3, $m0, $m0, $m0 # encoding: [0x05,0x08,0x00,0x4d]
# CHECK-SUPERVISOR: error: instruction requires: Worker mode
ld128 $a0:3, $m0, $m0, $m0

# CHECK-IPU1: ld128 $a4:7, $m0, $m0, $m0 # encoding: [0x45,0x08,0x00,0x4d]
# CHECK-SUPERVISOR: error: instruction requires: Worker mode
ld128 $a4:7, $m0, $m0, $m0

# CHECK-IPU1: ld128 $a8:11, $m0, $m0, $m0 # encoding: [0x85,0x08,0x00,0x4d]
# CHECK-SUPERVISOR: error: instruction requires: Worker mode
ld128 $a8:11, $m0, $m0, $m0

# CHECK-IPU1: ld128 $a12:15, $m0, $m0, $m0 # encoding: [0xc5,0x08,0x00,0x4d]
# CHECK-SUPERVISOR: error: instruction requires: Worker mode
ld128 $a12:15, $m0, $m0, $m0
 
# ld2xst64pace has a special 3 bit encoding of an ARQuad

# CHECK-IPU1: ld2xst64pace $a0:3, $a0:1, $m2:3+=, $m4, 0 # encoding: [0x00,0x28,0x40,0x56]
# CHECK-SUPERVISOR: error: instruction requires: Worker mode
ld2xst64pace  $a0:3, $a0:1, $m2:3+=, $m4, 0b000000

# CHECK-IPU1: ld2xst64pace $a4:7, $a0:1, $m2:3+=, $m4, 0 # encoding: [0x00,0x28,0x44,0x56]
# CHECK-SUPERVISOR: error: instruction requires: Worker mode
ld2xst64pace  $a4:7, $a0:1, $m2:3+=, $m4, 0b000000

# CHECK-IPU1: ld2xst64pace $a8:11, $a0:1, $m2:3+=, $m4, 0 # encoding: [0x00,0x28,0x48,0x56]
# CHECK-SUPERVISOR: error: instruction requires: Worker mode
ld2xst64pace  $a8:11, $a0:1, $m2:3+=, $m4, 0b000000

# CHECK-IPU1: ld2xst64pace $a12:15, $a0:1, $m2:3+=, $m4, 0 # encoding: [0x00,0x28,0x4c,0x56]
# CHECK-SUPERVISOR: error: instruction requires: Worker mode
ld2xst64pace  $a12:15, $a0:1, $m2:3+=, $m4, 0b000000
