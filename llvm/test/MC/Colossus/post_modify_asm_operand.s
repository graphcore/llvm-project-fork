# RUN: not llvm-mc -triple colossus-graphcore-elf -assemble %s  2> %t.stderr 1> %t.stdout
# RUN: FileCheck %s < %t.stdout
# RUN: FileCheck %s --check-prefix=CHECK-ERROR < %t.stderr

# T82: Assembly syntax for ldistep<n> doesn't match the Arch Man.


# All valid instructions without operand suffixes:

#CHECK-ERROR: missing operand post-inc suffix
    ld2x64pace  $a0:1, $a2:3, $m0:1, $m15, 0x00
#CHECK-ERROR: missing operand post-inc suffix
    ld2x64pace  $a0:1, $a0:1, $m0:1, $m15, 0x00
#CHECK-ERROR: missing operand post-inc suffix
    ld16zstep   $a0, $mzero, $m0, 1
#CHECK-ERROR: missing operand post-inc suffix
    ld32step    $a0, $mzero, $m0, 1
#CHECK-ERROR: missing operand post-inc suffix
    ld64step    $a0:1, $mzero, $m0, 1
#CHECK-ERROR: missing operand post-inc suffix
    lds16step   $m0, $mzero, $m0, 1
#CHECK-ERROR: missing operand post-inc suffix
    lds8step    $m0, $mzero, $m0, 1
#CHECK-ERROR: missing operand post-inc suffix
    ldz16step   $m0, $mzero, $m0, 1
#CHECK-ERROR: missing operand post-inc suffix
    ldz8step    $m0, $mzero, $m0, 1
#CHECK-ERROR: missing operand post-inc suffix
    st64step    $a0:1, $mzero, $m0, 1
#CHECK-ERROR: missing operand post-inc suffix
    st32step    $m0, $mzero, $m0, 1
#CHECK-ERROR: missing operand post-inc suffix
    ldd16b16      $a0, $m0, $m0, $m0
#CHECK-ERROR: missing operand post-inc suffix
    ldb16b16      $a0:1, $m0, $m0, $m0
#CHECK-ERROR: missing operand post-inc suffix
    ldd16v2a32     $a0, $m0, $m0, $m0
#CHECK-ERROR: missing operand post-inc suffix
    ldb16b16      $a0:1, $m0, $m0, $m0
#CHECK-ERROR: missing operand post-inc suffix
    ldd16v2a32     $a0, $m0, $m0, $m0


# All valid instructions with operand suffixes:

#CHECK: ld2x64pace $a0:1, $a2:3, $m0:1+=, $m15, 0
    ld2x64pace  $a0:1, $a2:3, $m0:1+=, $m15, 0x00
#CHECK: ldst64pace $a0:1, $a0:1, $m0:1+=, $m15, 0
    ldst64pace  $a0:1, $a0:1, $m0:1+=, $m15, 0x00
#CHECK: ld32step $a0, $m15, $m0+=, 1
    ld32step    $a0, $mzero, $m0+=, 1
#CHECK: ld64step $a0:1, $m15, $m0+=, 1
    ld64step    $a0:1, $mzero, $m0+=, 1
#CHECK: ldst64pace $a0:1, $a0:1, $m0:1+=, $m15, 0
    ldst64pace  $a0:1, $a0:1, $m0:1+=, $m15, 0x00
#CHECK: lds16step $m0, $m15, $m0+=, 1
    lds16step   $m0, $mzero, $m0+=, 1
#CHECK:  lds8step $m0, $m15, $m0+=, 1
    lds8step    $m0, $mzero, $m0+=, 1
#CHECK: ldz16step $m0, $m15, $m0+=, 1
    ldz16step   $m0, $mzero, $m0+=, 1
#CHECK: ldz8step $m0, $m15, $m0+=, 1
    ldz8step    $m0, $mzero, $m0+=, 1
#CHECK: st64step $a0:1, $m15, $m0+=, 1
    st64step    $a0:1, $mzero, $m0+=, 1
#CHECK: st32step $m0, $m15, $m0+=, 1
    st32step    $m0, $mzero, $m0+=, 1
#CHECK: ldd16b16 $a0, $m0++, $m0, $m1@
    ldd16b16      $a0, $m0++, $m0, $m1@
#CHECK: ldb16b16 $a0:1, $m0, $m0++, $m0>>
    ldb16b16      $a0:1, $m0, $m0++, $m0>>
#CHECK: ldd16v2a32 $a0, $m0++, $m0, $m0@
    ldd16v2a32     $a0, $m0++, $m0, $m0@
#CHECK: ldb16b16 $a0:1, $m0, $m0++, $m0>>
    ldb16b16      $a0:1, $m0, $m0++, $m0>>
#CHECK: ldd16v2a32 $a0, $m0++, $m0, $m0@
    ldd16v2a32     $a0, $m0++, $m0, $m0@


# Check invalid use of suffixes on instructions that don't take one:

#CHECK-ERROR: invalid operand post-inc suffix
    setzi       $m0++, 1
#CHECK-ERROR: invalid operand post-inc suffix
    setzi       $m0+=, 1
#CHECK-ERROR: invalid operand post-inc suffix
    setzi       $m0@, 1
#CHECK-ERROR: invalid operand post-inc suffix
    setzi       $m0>>, 1


# Check using the wrong suffix type on a += operand:

#CHECK-ERROR: invalid operand post-inc suffix
    ld32step   $a0, $mzero, $m0++, 1
#CHECK-ERROR: invalid operand post-inc suffix
    ld32step   $a0, $mzero, $m0>>, 1
#CHECK-ERROR: invalid operand post-inc suffix
    ld32step   $a0, $mzero, $m0@, 1


# Check using the wrong suffix type on a ++ operand:
#CHECK-ERROR: invalid operand post-inc suffix
    ldd16b16      $a0, $m0+=, $m0, $m1@
#CHECK-ERROR: invalid operand post-inc suffix
    ldd16b16      $a0, $m0>>, $m0, $m1@
#CHECK-ERROR: invalid operand post-inc suffix
    ldd16b16      $a0, $m0@, $m0, $m1@

# Check using the wrong suffix type on a >> operand
#CHECK-ERROR: invalid operand post-inc suffix
    ldb16b16      $a0:1, $m0, $m0++, $m0++
#CHECK-ERROR: invalid operand post-inc suffix
    ldb16b16      $a0:1, $m0, $m0++, $m0+=
#CHECK-ERROR: invalid operand post-inc suffix
    ldb16b16      $a0:1, $m0, $m0++, $m0@

# Check using the wrong suffix type on a @ operand
#CHECK-ERROR: invalid operand post-inc suffix
    ldd16v2a32     $a0, $m0++, $m0, $m0++
#CHECK-ERROR: invalid operand post-inc suffix
    ldd16v2a32     $a0, $m0++, $m0, $m0+=
#CHECK-ERROR: invalid operand post-inc suffix
    ldd16v2a32     $a0, $m0++, $m0, $m0>>

# Check invalid operand suffixes:
#CHECK-ERROR: invalid operand for instruction
    setzi       $m0?, 1
#CHECK-ERROR: unexpected token in argument list
    setzi       $m0<<, 1
#CHECK-ERROR: unexpected token in argument list
    setzi       $m0>=, 1
#CHECK-ERROR: unexpected token in argument list
    setzi       $m0>!, 1
