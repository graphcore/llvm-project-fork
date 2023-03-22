# Disabled. See T1059: Fix tests that used to rely on get/set of the
#                      accumulator.
#
# RUN: not llvm-mc -triple colossus-graphcore-elf < %s > %t
# RUN: not FileCheck < %t %s

#CHECK: f32getacc $a0, 0
f32getacc $a0, 0

#CHECK: f32getacc $a0, 1
f32getacc $a0, 1

#CHECK: f32getacc $a0, 2
f32getacc $a0, 2

#CHECK: f32getacc $a0, 3
f32getacc $a0, 3

#CHECK: f32getacc $a0, 4
f32getacc $a0, 4

#CHECK: f32getacc $a0, 5
f32getacc $a0, 5

#CHECK: f32getacc $a0, 6
f32getacc $a0, 6

#CHECK: f32getacc $a0, 7
f32getacc $a0, 7

#CHECK: f32putacc 0, $a0
f32putacc 0, $a0

#CHECK: f32putacc 1, $a0
f32putacc 1, $a0

#CHECK: f32putacc 2, $a0
f32putacc 2, $a0

#CHECK: f32putacc 3, $a0
f32putacc 3, $a0

#CHECK: f32putacc 4, $a0
f32putacc 4, $a0

#CHECK: f32putacc 5, $a0
f32putacc 5, $a0

#CHECK: f32putacc 6, $a0
f32putacc 6, $a0

#CHECK: f32putacc 7, $a0
f32putacc 7, $a0

#CHECK: f32v2getacc $a0:1, 0
f32v2getacc $a0:1, 0

#CHECK: f32v2getacc $a0:1, 0
f32v2getacc $a0:1, 1

#CHECK: f32v2getacc $a0:1, 2
f32v2getacc $a0:1, 2

#CHECK: f32v2getacc $a0:1, 2
f32v2getacc $a0:1, 3

#CHECK: f32v2getacc $a0:1, 4
f32v2getacc $a0:1, 4

#CHECK: f32v2getacc $a0:1, 4
f32v2getacc $a0:1, 5

#CHECK: f32v2getacc $a0:1, 6
f32v2getacc $a0:1, 6

#CHECK: f32v2getacc $a0:1, 6
f32v2getacc $a0:1, 7

#CHECK: f32v2putacc 0, $a0:1
f32v2putacc 0, $a0:1

#CHECK: f32v2putacc 0, $a0:1
f32v2putacc 1, $a0:1

#CHECK: f32v2putacc 2, $a0:1
f32v2putacc 2, $a0:1

#CHECK: f32v2putacc 2, $a0:1
f32v2putacc 3, $a0:1

#CHECK: f32v2putacc 4, $a0:1
f32v2putacc 4, $a0:1

#CHECK: f32v2putacc 4, $a0:1
f32v2putacc 5, $a0:1

#CHECK: f32v2putacc 6, $a0:1
f32v2putacc 6, $a0:1

#CHECK: f32v2putacc 6, $a0:1
f32v2putacc 7, $a0:1
