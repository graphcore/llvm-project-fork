# RUN: llvm-mc -triple colossus-unknown-elf < %s 2> %t.stderr 1> %t.stdout
# RUN: FileCheck %s < %t.stdout
# RUN: not llvm-mc -triple colossus-graphcore-elf -mattr=+supervisor \
# RUN:   < %s 2>&1 >/dev/null | FileCheck %s -check-prefix=CHECK-SUPERVISOR


# st64
# CHECK: st64 $a0:1, $m0, $m15, $m0
# CHECK-SUPERVISOR: error: instruction requires: Worker mode
st64 $a0:1, $m0, $m0
# CHECK: st64 $a0:1, $m0, $m15, 4
# CHECK-SUPERVISOR: error: instruction requires: Worker mode
st64 $a0:1, $m0, 4

# st32
# CHECK: st32 $a0, $m0, $m15, $m0
# CHECK-SUPERVISOR: error: instruction requires: Worker mode
st32 $a0, $m0, $m0
# CHECK: st32 $m0, $m0, $m15, 4
# CHECK-SUPERVISOR: error: instruction requires: Worker mode
st32 $m0, $m0, 4
# CHECK: st32 $a0, $m0, $m15, 4
st32 $a0, $m0, 4

# ld64
# CHECK: ld64 $a0:1, $m0, $m15, $m0
# CHECK-SUPERVISOR: error: instruction requires: Worker mode
ld64 $a0:1, $m0, $m0
# CHECK: ld64 $a0:1, $m0, $m15, 4
# CHECK-SUPERVISOR: error: instruction requires: Worker mode
ld64 $a0:1, $m0, 4

# ld32
# CHECK: ld32 $m0, $m0, $m15, $m0
ld32 $m0, $m0, $m0
# CHECK: ld32 $a0, $m0, $m15, $m0
ld32 $a0, $m0, $m0
# CHECK: ld32 $m0, $m0, $m15, 4
ld32 $m0, $m0, 4
# CHECK: ld32 $a0, $m0, $m15, 4
ld32 $a0, $m0, 4

# lds16
# CHECK: lds16 $m0, $m0, $m15, $m0
lds16 $m0, $m0, $m0
# CHECK: lds16 $m0, $m0, $m15, 4
lds16 $m0, $m0, 4

# lds8
# CHECK: lds8 $m0, $m0, $m15, $m0
lds8 $m0, $m0, $m0
# CHECK: lds8 $m0, $m0, $m15, 4
lds8 $m0, $m0, 4

# ldz16
# CHECK: ldz16 $m0, $m0, $m15, $m0
ldz16 $m0, $m0, $m0
# CHECK: ldb16 $a0, $m0, $m15, $m0
ldb16 $a0, $m0, $m0
# CHECK: ldz16 $m0, $m0, $m15, 4
ldz16 $m0, $m0, 4
# CHECK: ldb16 $a0, $m0, $m15, 4
ldb16 $a0, $m0, 4

# ldz8
# CHECK: ldz8 $m0, $m0, $m15, $m0
ldz8 $m0, $m0, $m0
# CHECK: ldz8 $m0, $m0, $m15, 4
ldz8 $m0, $m0, 4
