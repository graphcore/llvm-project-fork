# RUN: llvm-mc -assemble -triple colossus-unknown-elf < %s | FileCheck %s

# CHECK: add $m0, $m0, 0
sub $m0, $m0, 0

# CHECK: add $m0, $m0, 21
sub $m0, $m0, -21

# CHECK: add $m0, $m0, -10
sub $m0, $m0, 10

# CHECK: add $m0, $m0, -12345
sub $m0, $m0, 12345

# CHECK: add $m0, $m0, -12321
sub $m0, $m0, 12321

# CHECK: add $m0, $m0, -32767
sub $m0, $m0, 32767

# CHECK: add $m0, $m0, 32767
sub $m0, $m0, -32767

# CHECK: add $m0, $m0, -21212
# CHECK-NEXT: setzi $a4, 1
{
    sub $m0, $m0, 21212
    setzi $a4, 1
}