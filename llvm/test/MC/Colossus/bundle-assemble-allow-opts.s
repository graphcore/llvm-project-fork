# RUN: not llvm-mc -mattr=+ipu21 -triple colossus-graphcore-elf -assemble -show-inst -show-encoding %s  2> %t.stderr 1> %t.stdout
# RUN: FileCheck %s < %t.stdout
# RUN: FileCheck %s --check-prefix=CHECK-ERROR < %t.stderr
# RUN: not llvm-mc -mattr=+ipu21 -mattr=+supervisor -triple colossus-graphcore-elf \
# RUN: -assemble -show-inst -show-encoding < %s 2>&1 >/dev/null | FileCheck %s -check-prefix=CHECK-SUPERVISOR

# Test for T822: Incorrect error message when assembling a bundle.
# The actual error was in the register pair definition and not strictly related
# to bundle checking.
# CHECK-LABEL: CheckT822
# CHECK: ld64 $a8:9, $m0, $m15, 1
# CHECK: or $a7, $a7, 602931200
# CHECK-SUPERVISOR: error: instruction requires: Worker mode
.allow_optimizations
CheckT822:
  {
    ld64 $a8:9, $m0, 1
    or $a7, $a7, 575 << 20
  }

# CHECK-LABEL: MultiLineValidInstructionBundle:
# CHECK: add $m1, $m2, $m3
# CHECK: setzi $a4, 1
# CHECK-SUPERVISOR: error: instruction requires: Worker mode
MultiLineValidInstructionBundle:
  {
    add $m1, $m2, $m3
    setzi $a4, 1
  }

# CHECK-LABEL: InstructionWitoutOperandAtEndOfSingleLineBundle:
# CHECK: sub $m0, $m1, $m2
# CHECK: fnop
# CHECK-SUPERVISOR: error: instruction requires: Worker mode
InstructionWitoutOperandAtEndOfSingleLineBundle:
{ sub $m0, $m1, $m2 ; fnop }

# CHECK-LABEL: SingleLineValidInstructionBundle:
# CHECK: sub $m0, $m1, $m2
# CHECK: setzi $a3, 1
# CHECK-SUPERVISOR: error: instruction requires: Worker mode
SingleLineValidInstructionBundle:
  { sub $m0, $m1, $m2 ; setzi $a3, 1 }

# CHECK-LABEL: BundleStartInAnIf0Block:
# CHECK-SUPERVISOR: error: instruction requires: Worker mode
BundleStartInAnIf0Block:
.if 0
{
.endif

# CHECK-LABEL: BundleStartInACComment:
# CHECK-SUPERVISOR: error: instruction requires: Worker mode
BundleStartInACComment:
// {

# CHECK-LABEL: BundleStartInACppSingleLineComment:
# CHECK-SUPERVISOR: error: instruction requires: Worker mode
BundleStartInACppSingleLineComment:
/* { */

# CHECK-LABEL: BundleStartInACppMultiLineComment:
# CHECK-SUPERVISOR: error: instruction requires: Worker mode
BundleStartInACppMultiLineComment:
/*
  {
*/

# CHECK-LABEL: SingleLineValidInstructionBundleAfterCommentBundleStart:
# CHECK: add $m1, $m2, $m3
# CHECK: setzi $a4, 1
# CHECK-SUPERVISOR: error: instruction requires: Worker mode
SingleLineValidInstructionBundleAfterCommentBundleStart:
  { add $m1, $m2, $m3 ; setzi $a4, 1 }

# CHECK-ERROR: error: too many instructions in bundle
SingleLineInvalidInstructionBundleTooManyInsns:
  { sub $m1, $m1, $m1 ; setzi $a2, 1; setzi $a3, 1 }

# CHECK-ERROR: error: too few instructions in bundle
SingleLineInvalidInstructionBundleSingleInsn:
  { add $m1, $m2, $m3 }

# CHECK-ERROR: error: end of instruction bundle without start
EndOfInstructionBundleWithoutStart:
  add $m3, $m3, $m3 }

# CHECK-ERROR: error: empty instruction bundle
EmptyInstructionBundleWithSpace:
{ }

# CHECK-ERROR: error: empty instruction bundle
EmptyInstructionBundleWithNewline:
{
}

# CHECK-ERROR: error: empty instruction bundle
EmptyInstructionBundleWithoutSpace:
{}

# CHECK-ERROR: error: start of instruction bundle without end
  { add $m1, $m2, $m3; add $m4, $m5, $m6
  { add $m9, $m9, $m9; setzi $a0, 1 }

# CHECK-ERROR: error: too many instructions in bundle
SingleLineInvalidInstructionBundleTooManyInsnsPsuedoInsn:
  { sub $m1, $m1, 543 ; setzi $a2, 1; setzi $a3, 1 }

# CHECK-ERROR: error: too few instructions in bundle
SingleLineInvalidInstructionBundleSingleInsnPsuedoInsn:
  { sub $m1, $m2, 34 }

# CHECK-ERROR: error: end of instruction bundle without start
EndOfInstructionBundleWithoutStartPsuedoInsn:
  add $m3, $m3, $m3 }

# CHECK-ERROR: error: start of instruction bundle without end
  { sub $m1, $m2, 11; add $m4, $m5, $m6
  { sub $m9, $m9, 12; setzi $a0, 1 }

# CHECK-ERROR: error: instruction bundle without end
InstructionBundleWithoutEnd:
  { sub $m3, $m3, $m3; add $m4, $m5, $m6
