# RUN: not llvm-mc -triple colossus-graphcore-elf < %s 2>&1 | FileCheck %s

# Check that we get errors when trying to assemble invalid bundles.
# See T485: Error on invalid instruction bundles.

MainInAUX:
{
  setzi      $m0, 1
  // CHECK: error: invalid instruction in bundle
  setzi      $m1, 1
}

AuxInMain:
{
  // CHECK: error: invalid instruction in bundle
  f32fromi32 $a0, $a0
  setzi      $a1, 1
}

BothWrongLane:
{
  // CHECK: error: invalid instruction in bundle
  f32fromi32 $a0, $a0
  setzi      $m1, 1
}

AccessSameReg:
{
  // CHECK: error: bundle instructions cannot write to the same operand
  ld32       $a0, $m0, $m0
  setzi      $a0, 10
}

AccessSameRegInPair:
{
  // CHECK: error: bundle instructions cannot write to the same operand
  ld32       $a0, $m0, $m0
  f16v2tof32 $a0:1, $a0
}

AccessSameRegInQuad:
{
  // CHECK: error: bundle instructions cannot write to the same operand
  ld2x64pace $a0:1, $a2:3, $m0:1+=, $m15, 0x00
  setzi      $a1, 10
}

AccessSameQuadButUnwritten:
{
  // CHECK: error: bundle instructions cannot write to the same operand
  ld64a32    $a0:3, $m0++, $m0, $m1
  setzi      $a0, 10
}

CheckAllowInvalidBundles:
.warn_on_invalid_bundles
{
  // CHECK: warning: invalid instruction in bundle
  f32fromi32 $a0, $a0
  setzi      $m1, 1
}

CheckDisallowInvalidBundles:
.error_on_invalid_bundles
{
  // CHECK: error: invalid instruction in bundle
  f32fromi32 $a0, $a0
  setzi      $m1, 1
}

AccessDifferentRegs:
{
  // CHECK-NOT: error
  // CHECK-NOT: warning
  ld32       $a0, $m0, $m0
  setzi      $a1, 10
}

AccessDifferentRegInPair:
{
  // CHECK-NOT: error
  // CHECK-NOT: warning
  ld32       $a2, $m0, $m0
  f16v2tof32 $a0:1, $a0
}

