# RUN: llvm-mc -triple colossus-graphcore-elf -show-encoding < %s | FileCheck %s \
# RUN: -check-prefix=CHECK-IPU1
# RUN: not llvm-mc -triple colossus-graphcore-elf -mattr=+supervisor \
# RUN:   < %s 2>&1 >/dev/null | FileCheck %s -check-prefix=CHECK-SUPERVISOR

# CHECK-IPU1: st64 $a0:1, $m2, $m15, 0 # encoding: [0x00,0xf0,0x20,0x5f]
# CHECK-SUPERVISOR: error: instruction requires: Worker mode
st64 $a0:1, $m2, 0

# CHECK-IPU1: st64 $a2:3, $m2, $m15, 0 # encoding: [0x20,0xf0,0x20,0x5f]
# CHECK-SUPERVISOR: error: instruction requires: Worker mode
st64 $a2:3, $m2, 0

# CHECK-IPU1: st64 $a4:5, $m2, $m15, 0 # encoding: [0x40,0xf0,0x20,0x5f]
# CHECK-SUPERVISOR: error: instruction requires: Worker mode
st64 $a4:5, $m2, 0

# CHECK-IPU1: st64 $a6:7, $m2, $m15, 0 # encoding: [0x60,0xf0,0x20,0x5f]
# CHECK-SUPERVISOR: error: instruction requires: Worker mode
st64 $a6:7, $m2, 0

# CHECK-IPU1: st64 $a8:9, $m2, $m15, 0 # encoding: [0x80,0xf0,0x20,0x5f]
# CHECK-SUPERVISOR: error: instruction requires: Worker mode
st64 $a8:9, $m2, 0

# CHECK-IPU1: st64 $a10:11, $m2, $m15, 0 # encoding: [0xa0,0xf0,0x20,0x5f]
# CHECK-SUPERVISOR: error: instruction requires: Worker mode
st64 $a10:11, $m2, 0

# CHECK-IPU1: st64 $a12:13, $m2, $m15, 0 # encoding: [0xc0,0xf0,0x20,0x5f]
# CHECK-SUPERVISOR: error: instruction requires: Worker mode
st64 $a12:13, $m2, 0

# CHECK-IPU1: st64 $a14:15, $m2, $m15, 0 # encoding: [0xe0,0xf0,0x20,0x5f]
# CHECK-SUPERVISOR: error: instruction requires: Worker mode
st64 $a14:15, $m2, 0

# CHECK-IPU1: st64 $a0:1, $m2, $m15, 0 # encoding: [0x00,0xf0,0x20,0x5f]
# CHECK-SUPERVISOR: error: instruction requires: Worker mode
st64 $ap0, $m2, 0

# CHECK-IPU1: st64 $a2:3, $m2, $m15, 0 # encoding: [0x20,0xf0,0x20,0x5f]
# CHECK-SUPERVISOR: error: instruction requires: Worker mode
st64 $ap1, $m2, 0

# CHECK-IPU1: st64 $a4:5, $m2, $m15, 0 # encoding: [0x40,0xf0,0x20,0x5f]
# CHECK-SUPERVISOR: error: instruction requires: Worker mode
st64 $ap2, $m2, 0

# CHECK-IPU1: st64 $a6:7, $m2, $m15, 0 # encoding: [0x60,0xf0,0x20,0x5f]
# CHECK-SUPERVISOR: error: instruction requires: Worker mode
st64 $ap3, $m2, 0

# CHECK-IPU1: st64 $a8:9, $m2, $m15, 0 # encoding: [0x80,0xf0,0x20,0x5f]
# CHECK-SUPERVISOR: error: instruction requires: Worker mode
st64 $ap4, $m2, 0

# CHECK-IPU1: st64 $a10:11, $m2, $m15, 0 # encoding: [0xa0,0xf0,0x20,0x5f]
# CHECK-SUPERVISOR: error: instruction requires: Worker mode
st64 $ap5, $m2, 0

# CHECK-IPU1: st64 $a12:13, $m2, $m15, 0 # encoding: [0xc0,0xf0,0x20,0x5f]
# CHECK-SUPERVISOR: error: instruction requires: Worker mode
st64 $ap6, $m2, 0

# CHECK-IPU1: st64 $ap7, $m2, $m15, 0 # encoding: [0xe0,0xf0,0x20,0x5f]
# CHECK-SUPERVISOR: error: instruction requires: Worker mode
st64 $ap7, $m2, 0

# CHECK-IPU1: st64 $ap8, $m2, $m15, 0 # encoding: [0xe0,0xf0,0x20,0x5f]
# CHECK-SUPERVISOR: error: instruction requires: Worker mode
st64 $ap8, $m2, 0

# CHECK-IPU1: st64 $ap9, $m2, $m15, 0 # encoding: [0xe0,0xf0,0x20,0x5f]
# CHECK-SUPERVISOR: error: instruction requires: Worker mode
st64 $ap9, $m2, 0

# CHECK-IPU1: st64 $ap10, $m2, $m15, 0 # encoding: [0xe0,0xf0,0x20,0x5f]
# CHECK-SUPERVISOR: error: instruction requires: Worker mode
st64 $ap10, $m2, 0

# CHECK-IPU1: st64 $ap11, $m2, $m15, 0 # encoding: [0xe0,0xf0,0x20,0x5f]
# CHECK-SUPERVISOR: error: instruction requires: Worker mode
st64 $ap11, $m2, 0

# CHECK-IPU1: st64 $ap12, $m2, $m15, 0 # encoding: [0xe0,0xf0,0x20,0x5f]
# CHECK-SUPERVISOR: error: instruction requires: Worker mode
st64 $ap12, $m2, 0

# CHECK-IPU1: st64 $ap13, $m2, $m15, 0 # encoding: [0xe0,0xf0,0x20,0x5f]
# CHECK-SUPERVISOR: error: instruction requires: Worker mode
st64 $ap13, $m2, 0

# CHECK-IPU1: st64 $ap14, $m2, $m15, 0 # encoding: [0xe0,0xf0,0x20,0x5f]
# CHECK-SUPERVISOR: error: instruction requires: Worker mode
st64 $ap14, $m2, 0

# CHECK-IPU1: st64 $a14:15, $m2, $m15, 0 # encoding: [0xe0,0xf0,0x20,0x5f]
# CHECK-SUPERVISOR: error: instruction requires: Worker mode
st64 $ap15, $m2, 0
