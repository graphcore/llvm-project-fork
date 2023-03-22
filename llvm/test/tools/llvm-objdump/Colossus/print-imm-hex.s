# RUN: llvm-mc < %s -filetype=obj | llvm-objdump -d - | FileCheck %s -check-prefix=DEC
# RUN: llvm-mc < %s -filetype=obj | llvm-objdump -d --print-imm-hex - | FileCheck %s -check-prefix=HEX

# NOTE: Branches imm are always hex.

# TODO: Test mod with simm12 when implemented.

# DEC: bri 0xc
# HEX: bri 0xc
bri 3

# DEC: call $m0, 0xc
# HEX: call $m0, 0xc
call $m0, 3

# DEC: setzi $a0, 57005
# HEX: setzi $a0, 0xdead
setzi $a0, 57005

# DEC: put 13, $m0
# HEX: put 0xd, $m0
put 13, $m0

# DEC: brnzdec $m0, 0xc
# HEX: brnzdec $m0, 0xc
brnzdec $m0, 3

# DEC: add $m0, $m1, -1
# HEX: add $m0, $m1, 0xffff
add $m0, $m1, -1

# DEC: sub $m0, 13, $m1
# HEX: sub $m0, 0xd, $m1
sub $m0, 13, $m1

# DEC: st32 $m0, $m1, $m2, 10
# HEX: st32 $m0, $m1, $m2, 0xa
# DEC: st32 $a0, $m1, $m2, 10
# HEX: st32 $a0, $m1, $m2, 0xa
st32 $m0, $m1, $m2, 10
st32 $a0, $m1, $m2, 10

# DEC: ld128step $a0:3, $m0, $m1+=, -1
# HEX: ld128step $a0:3, $m0, $m1+=, 0xff
ld128step $a0:3, $m0, $m1+=, -1

# DEC: st64pace $a10:11, $m4:5+=, $m1, 11
# HEX: st64pace $a10:11, $m4:5+=, $m1, 0xb
st64pace $a10:11, $m4:5+=, $m1, 11

# DEC: st32step $m0, $m1, $m2+=, -1
# HEX: st32step $m0, $m1, $m2+=, 0xff
# DEC: st32step $a0, $m1, $m2+=, -1
# HEX: st32step $a0, $m1, $m2+=, 0xff
st32step $m0, $m1, $m2+=, -1
st32step $a0, $m1, $m2+=, -1

# DEC: ld2x64pace $a4:5, $a6:7, $m0:1+=, $m15, 12
# HEX: ld2x64pace $a4:5, $a6:7, $m0:1+=, $m15, 0xc
ld2x64pace $a4:5, $a6:7, $m0:1+=, $m15, 12

# DEC: ldst64pace $a0:1, $a2:3, $m0:1+=, $m15, 13
# HEX: ldst64pace $a0:1, $a2:3, $m0:1+=, $m15, 0xd
ldst64pace $a0:1, $a2:3, $m0:1+=, $m15, 13

.supervisor

# Test if immz12 always prints positive decimal values.
#
# DEC: or $m0, $m0, 4293918720
# HEX: or $m0, $m0, 0xfff00000
# DEC: or $m0, $m0, 4293918720
# HEX: or $m0, $m0, 0xfff00000
or $m0, $m0, 4293918720
or $m0, $m0, -1048576
