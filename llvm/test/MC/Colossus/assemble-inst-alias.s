# RUN: llvm-mc -mattr=+ipu21  -triple colossus-graphcore-elf < %s 2>&1 | FileCheck %s
# Check that instruction aliases assemble correctly.

## Check valid aliases.
##

# CHECK: add
        addz $m0, $m1, 42
# CHECK: add
        adds $m0, $m1, 42
# CHECK: cmpeq
        cmpeqz $m0, $m1, 42
# CHECK: cmpeq
        cmpeqs $m0, $m1, 42
# CHECK: max
        maxz $m0, $m1, 42
# CHECK: max
        maxs $m0, $m1, 42
# CHECK: min
        minz $m0, $m1, 42
# CHECK: min
        mins $m0, $m1, 42
# CHECK: sub
        subz $m0, 42, $m1
# CHECK: sub
        subs $m0, 42, $m1
# CHECK: nop
        nop
# CHECK-NEXT: nop
        setzi $m14, 0
# CHECK-NEXT: fnop
        fnop
# CHECK-NEXT: fnop
        setzi $a13, 0
# CHECK-NEXT: mov{{.+}}$m1, $m0
        mov $m1, $m0
# CHECK-NEXT: mov{{.+}}$m1, $m0
        or $m1, $m0, 0
# CHECK-NEXT: mov{{.+}}$a1, $a0
        mov $a1, $a0
# CHECK-NEXT: mov{{.+}}$a1, $a0
        or $a1, $a0, 0
# CHECK-NEXT: mov{{.+}}$m1, $a0
        mov $m1, $a0
# CHECK-NEXT: mov{{.+}}$m1, $a0
        atom $m1, $a0
# CHECK-NEXT: get{{.+}}$a0, 1
        get $a0, 1
# CHECK-NEXT: get{{.+}}$a0, 1
        uget $a0, 1
# CHECK-NEXT: put{{.+}}1, $a0
        put 1, $a0
# CHECK-NEXT: put{{.+}}1, $a0
	uput 1, $a0
# CHECK-NEXT: setzi{{.+}}$m1, 74565
        ldconst $m1, 0x12345
# CHECK-NEXT: setzi{{.+}}$a1, 74565
        ldconst $a1, 0x12345
# CHECK-NEXT: setzi{{.+}}$m1, 49152
        ldconst $m1, -2.0h
# CHECK-NEXT: setzi{{.+}}$a1, 15360
        ldconst $a1, 1.0h
# CHECK-NEXT: setzi{{.+}}$m2, 144470
# CHECK-NEXT: or{{.+}}$m2, $m2, 1048576
        ldconst $m2, 0x123456
# CHECK-NEXT: setzi{{.+}}$a2, 144470
# CHECK-NEXT: or{{.+}}$a2, $a2, 1048576
        ldconst $a2, 0x123456
# CHECK-NEXT: setzi{{.+}}$m3, 284280
# CHECK-NEXT: or{{.+}}$m3, $m3, 305135616
        ldconst $m3, 0x12345678
# CHECK-NEXT: .set foo, 305419896
# CHECK-NEXT: setzi{{.+}}$m4, 284280
# CHECK-NEXT: or{{.+}}$m4, $m4, 305135616
.set foo, 0x12345678
        ldconst $m4, foo
# CHECK-NEXT: setzi{{.+}}$a4, 284280
# CHECK-NEXT: or{{.+}}$a4, $a4, 305135616
        ldconst $a4, foo
# CHECK-NEXT: zero{{.+}}$a0
        zero $a0
# CHECK-NEXT: zero{{.+}}$a10
        or $a10, $azero, $azero
# CHECK-NEXT: zero{{.+}}$m3
        zero $m3
# CHECK-NEXT: zero{{.+}}$m6
        or $m6, $mzero, $mzero
# CHECK-NEXT: zero{{.+}}$a2:3
        or64 $a2:3, $azeros, $azeros
# CHECK-NEXT: zero{{.+}}$a0:1
        zero $a0:1
# CHECK-NEXT: strap
        strap

