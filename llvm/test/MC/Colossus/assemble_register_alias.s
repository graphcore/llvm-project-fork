# RUN: llvm-mc -triple colossus-graphcore-elf < %s | FileCheck %s
# RUN: not llvm-mc -mattr=+supervisor -triple colossus-graphcore-elf \
# RUN:  < %s 2>&1 >/dev/null | FileCheck %s -check-prefix=CHECK-SUPERVISOR

# Check that register aliases assemble correctly.

# CHECK: or $m[[REG0:[0-9]+]], $m[[REG1:[0-9]+]], $m[[REG2:[0-9]+]]
# CHECK: or $m[[REG0]], $m[[REG1]], $m[[REG2]]
or $m8, $m8, $m8
or $bp, $bp, $bp

# CHECK: or $m[[REG0:[0-9]+]], $m[[REG1:[0-9]+]], $m[[REG2:[0-9]+]]
# CHECK: or $m[[REG0]], $m[[REG1]], $m[[REG2]]
or $m9, $m9, $m9
or $fp, $fp, $fp

# CHECK: or $m[[REG0:[0-9]+]], $m[[REG1:[0-9]+]], $m[[REG2:[0-9]+]]
# CHECK: or $m[[REG0]], $m[[REG1]], $m[[REG2]]
or $m10, $m10, $m10
or $lr, $lr, $lr

# CHECK: or $m[[REG0:[0-9]+]], $m[[REG1:[0-9]+]], $m[[REG2:[0-9]+]]
# CHECK: or $m[[REG0]], $m[[REG1]], $m[[REG2]]
or $m11, $m11, $m11
or $sp, $sp, $sp

# CHECK: setzi $a[[REG1:[0-9]+]], 0
# CHECK: setzi $a[[REG1]], 0
setzi $a15, 0
setzi $azero, 0

# CHECK: setzi $m[[REG0:[0-9]+]], 0
# CHECK: setzi $m[[REG0]], 0
setzi $m15, 0
setzi $mzero, 0

# CHECK: or $m[[REG0:[0-9]+]], $m[[REG1:[0-9]+]], $m[[REG2:[0-9]+]]
# CHECK: or $m[[REG0]], $m[[REG1]], $m[[REG2]]
or $m0, $mworker_base, $mworker_base
or $m0, $m12, $m12

# CHECK: or $m[[REG0:[0-9]+]], $m[[REG1:[0-9]+]], $m[[REG2:[0-9]+]]
# CHECK: or $m[[REG0]], $m[[REG1]], $m[[REG2]]
or $m0, $mvertex_base, $mvertex_base
or $m0, $m13, $m13

# CHECK: f32v2add $a[[REG0:[0-9]+]]:[[REG1:[0-9]+]], $a[[REG2:[0-9]+]]:[[REG3:[0-9]+]], $a[[REG2:[0-9]+]]:[[REG3:[0-9]+]]
# CHECK: f32v2add $a[[REG0]]:[[REG1]], $a[[REG2]]:[[REG3]], $a[[REG2]]:[[REG3]]
# CHECK-SUPERVISOR: error: instruction requires: Worker mode
f32v2add $a0:1, $a14:15, $a14:15
f32v2add $a0:1, $azeros, $azeros
