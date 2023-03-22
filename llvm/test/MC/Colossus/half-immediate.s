# RUN: not llvm-mc -triple colossus-graphcore-elf < %s 2> %t

#CHECK:         setzi $a0, 15360
setzi $a0, 1.0h

#CHECK-NEXT:    setzi $a0, 15361
setzi $a0, 1.0009765625h

#CHECK-NEXT:    setzi $a0, 49152
setzi $a0, -2.0h

#CHECK-NEXT:    setzi $a0, 31743
setzi $a0, 65504.0h

#CHECK-NEXT:    setzi $a0, 1024
setzi $a0, 6.10352e-5h

#CHECK-NEXT:    setzi $a0, 1023
setzi $a0, 6.09756e-5h

#CHECK-NEXT:    setzi $a0, 1
setzi $a0, 5.96046e-8h

#CHECK-NEXT:    setzi $a0, 0
setzi $a0, 0.0h

#CHECK-NEXT:    setzi $a0, 32768
setzi $a0, -0.0h

#CHECK-NEXT:    setzi $a0, 31744
setzi $a0, infh

#CHECK-NEXT:    setzi $a0, 64512
setzi $a0, -infh

#CHECK-NEXT:    setzi $a0, 13653
setzi $a0, 0.333251953125h

#CHECK-NEXT: .half 15360
.half 15360

#CHECK-NEXT: .half 15360
.half 1.0h

#CHECK-NEXT: .half 48128
.half -1.0h

#CHECK-NEXT: .half 31744
.half infh

#CHECK-NEXT: .half 64512
.half -infh

#CHECK-NEXT: .half 13653
.half 0.333251953125h

#CHECK-NEXT:    missing h suffix from float16 operand
.half 1.0

#CHECK-NEXT:    missing h suffix from float16 operand
.half 1.0f

#CHECK-NEXT:    missing h suffix from float16 operand
setzi $a0, 0.0

#CHECK-NEXT:    invalid .half operand
.half $a0

#CHECK-NEXT:    missing h suffix from float16 operand
setzi $a0, 6.10352e-5
