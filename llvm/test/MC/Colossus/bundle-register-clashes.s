# RUN: not llvm-mc -mattr=+ipu2 -triple colossus-graphcore-elf < %s 2>&1 \
# RUN:  >/dev/null | FileCheck %s -check-prefix=CHECK-IPU2-FAIL


# CHECK-IPU2-FAIL:  error: bundle instructions cannot write to the same operand
{
  ld32 $a15, $m13, $m15, 0
  setzi $a15, 4
}


# CHECK-IPU2-FAIL:  error: bundle instructions cannot write to the same operand
{
  ld64 $a14:15, $m13, $m15, 0
  setzi $a15, 4
}


# CHECK-IPU2-FAIL:  error: bundle instructions cannot write to the same operand
{
  ld32 $a12, $m13, $m15, 0
  setzi $a12, 4
}
