# RUN: llvm-mc -triple colossus-graphcore-elf -show-inst %s | FileCheck %s

# Test format [add $mDst, $mSrc0, $mSrc1]:
#CHECK-LABEL: RegRegRegFormat:
RegRegRegFormat:
add $m0, $m1, $m2
#CHECK-NEXT:    add $m0, $m1, $m2
#CHECK-NEXT:      <MCOperand Reg:{{[0-9]+}}>
#CHECK-NEXT:      <MCOperand Reg:{{[0-9]+}}>
#CHECK-NEXT:      <MCOperand Reg:{{[0-9]+}}>
add $m3, $m4, $m5
#CHECK:         add $m3, $m4, $m5
#CHECK-NEXT:      <MCOperand Reg:{{[0-9]+}}>
#CHECK-NEXT:      <MCOperand Reg:{{[0-9]+}}>
#CHECK-NEXT:      <MCOperand Reg:{{[0-9]+}}>
add $m6, $m7, $m1
#CHECK:         add $m6, $m7, $m1


# Test format [add $mDst, $mSrc0, zimm16]:
#CHECK-LABEL: RegRegZimm16Format
RegRegZimm16Format:
add $m1, $m2, 65535
#CHECK-NEXT:    add $m1, $m2, 65535
#CHECK:           <MCInst #{{[0-9]+}} ADD_ZI
#CHECK-NEXT:      <MCOperand Reg:{{[0-9]+}}>
#CHECK-NEXT:      <MCOperand Reg:{{[0-9]+}}>
#CHECK-NEXT:      <MCOperand Imm:65535>

# Immediates
Misc:
add $m1, $m2, 255
add $m1, $m2, 0
add $m1, $m2, 127
add $m1, $m2, -128
add $m1, $m2, 0x00000000
setzi $m0, Misc
setzi $m0, Misc + 1
