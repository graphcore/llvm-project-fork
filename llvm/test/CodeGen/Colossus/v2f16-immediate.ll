; RUN: llvm-link %isdopc %s | opt -instcombine -always-inline -mattr=+ipu1 | llc -march=colossus -colossus-coissue=false -mattr=+ipu1 | FileCheck %s
; RUN: llvm-link %isdopc %s | opt -instcombine -always-inline -mattr=+ipu2 | llc -march=colossus -colossus-coissue=false -mattr=+ipu2 | FileCheck %s

; RUN: llvm-link %isdopc %s | opt -instcombine -always-inline -mattr=+ipu1 | llc -march=colossus -colossus-coissue=false -mattr=+ipu1 -stop-after=finalize-isel | FileCheck --check-prefix=POSTISEL %s
; RUN: llvm-link %isdopc %s | opt -instcombine -always-inline -mattr=+ipu2 | llc -march=colossus -colossus-coissue=false -mattr=+ipu2 -stop-after=finalize-isel | FileCheck --check-prefix=POSTISEL %s
target triple = "colossus-graphcore--elf"

@ColossusISD_FAND = external constant i32
@ColossusISD_FOR = external constant i32
@ColossusISD_ANDC = external constant i32

declare <2 x half> @llvm.colossus.SDAG.binary.v2f16.v2f16.v2f16(i32, <2 x half>, <2 x half>)

define <2 x half> @AND(<2 x half> %x, i32 %imm) #0 {
  %y = bitcast i32 %imm to <2 x half>
  %id = load i32, i32* @ColossusISD_FAND
  %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16.v2f16.v2f16(i32 %id, <2 x half> %x, <2 x half> %y)
  ret <2 x half> %res
}
define <2 x half> @OR(<2 x half> %x, i32 %imm) #0 {
  %y = bitcast i32 %imm to <2 x half>
  %id = load i32, i32* @ColossusISD_FOR
  %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16.v2f16.v2f16(i32 %id, <2 x half> %x, <2 x half> %y)
  ret <2 x half> %res
}
define <2 x half> @ANDC(<2 x half> %x, i32 %imm) #0 {
  %y = bitcast i32 %imm to <2 x half>
  %id = load i32, i32* @ColossusISD_ANDC
  %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16.v2f16.v2f16(i32 %id, <2 x half> %x, <2 x half> %y)
  ret <2 x half> %res
}
attributes #0 = {alwaysinline}

; CHECK-LABEL: and_a_zi12:
; CHECK:       # %bb
; CHECK-NEXT:  and $a0, $a0, 4095
; CHECK:       br $m10
define <2 x half> @and_a_zi12(<2 x half> %x) {
  %res = call <2 x half> @AND(<2 x half> %x, i32 4095) ; cst = 0xFFF
  ret <2 x half> %res
}

; CHECK-LABEL: and_a_zi12_over:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a1, 4096
; CHECK-NEXT:  and $a0, $a0, $a1
; CHECK:       br $m10
define <2 x half> @and_a_zi12_over(<2 x half> %x) {
  %res = call <2 x half> @AND(<2 x half> %x, i32 4096) ; cst = 0x1000
  ret <2 x half> %res
}

; CHECK-LABEL: and_a_iz12:
; CHECK:       # %bb
; CHECK-NEXT:  and $a0, $a0, 4293918720
; CHECK:       br $m10
define <2 x half> @and_a_iz12(<2 x half> %x) {
  %res = call <2 x half> @AND(<2 x half> %x, i32 4293918720) ; cst = 0xFFF00000
  ret <2 x half> %res
}

; CHECK-LABEL: and_a_iz12_over:
; CHECK:       # %bb
; CHECK-NEXT:  setzi [[SETREG:\$a[1-5]]], 524288
; CHECK-NEXT:  or $a1, [[SETREG]], 4293918720
; CHECK-NEXT:  and $a0, $a0, $a1
; CHECK:       br $m10
define <2 x half> @and_a_iz12_over(<2 x half> %x) {
  %res = call <2 x half> @AND(<2 x half> %x, i32 4294443008) ; cst = 0xFFF80000
  ret <2 x half> %res
}

; Check that a constant also used in a non bitwise operation is not
; synthesized twice.
; POSTISEL-LABEL: name: and_a_iz12_over_reuse
; POSTISEL:       liveins: $a0
; POSTISEL:       %0:ar = COPY $a0
; POSTISEL-NEXT:  %1:ar = SETZI_A 31744, 0
; POSTISEL-NEXT:  %2:ar = OR_IZ_A killed %1, 2080374784, 0
; POSTISEL-NEXT:  %3:ar = AND_A %0, %2, 0
; POSTISEL-NEXT:  %4:ar = F16V2CMPNE killed %3, %2, 0
; POSTISEL-NEXT:  %5:mr = COPY %4
; POSTISEL-NEXT:  $m0 = COPY %5
; POSTISEL-NEXT:  RTN_PSEUDO
; POSTISEL-NEXT:  RTN_REG_HOLDER implicit $m0
define <2 x i1> @and_a_iz12_over_reuse(<2 x half> %x) {
  %masked = call <2 x half> @AND(<2 x half> %x, i32 2080406528) ; cst = 0x7C007C00
  %res = fcmp une <2 x half> %masked, <half 0xH7C00, half 0xH7C00>
  ret <2 x i1> %res
}

; CHECK-LABEL: or_a_zi12:
; CHECK:       # %bb
; CHECK-NEXT:  or $a0, $a0, 4095
; CHECK:       br $m10
define <2 x half> @or_a_zi12(<2 x half> %x) {
  %res = call <2 x half> @OR(<2 x half> %x, i32 4095) ; cst = 0xFFF
  ret <2 x half> %res
}

; CHECK-LABEL: or_a_zi12_over:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a1, 4096
; CHECK-NEXT:  or $a0, $a0, $a1
; CHECK:       br $m10
define <2 x half> @or_a_zi12_over(<2 x half> %x) {
  %res = call <2 x half> @OR(<2 x half> %x, i32 4096) ; cst = 0x1000
  ret <2 x half> %res
}

; CHECK-LABEL: or_a_iz12:
; CHECK:       # %bb
; CHECK-NEXT:  or $a0, $a0, 4293918720
; CHECK:       br $m10
define <2 x half> @or_a_iz12(<2 x half> %x) {
  %res = call <2 x half> @OR(<2 x half> %x, i32 4293918720) ; cst = 0xFFF00000
  ret <2 x half> %res
}

; CHECK-LABEL: or_a_iz12_over:
; CHECK:       # %bb
; CHECK-NEXT:  setzi [[SETREG:\$a[1-5]]], 524288
; CHECK-NEXT:  or $a1, [[SETREG]], 4293918720
; CHECK-NEXT:  or $a0, $a0, $a1
; CHECK:       br $m10
define <2 x half> @or_a_iz12_over(<2 x half> %x) {
  %res = call <2 x half> @OR(<2 x half> %x, i32 4294443008) ; cst = 0xFFF80000
  ret <2 x half> %res
}

; Check that a constant also used in a non bitwise operation is not
; synthesized twice.
; POSTISEL-LABEL: name: or_a_iz12_over_reuse
; POSTISEL:       liveins: $a0
; POSTISEL:       %0:ar = COPY $a0
; POSTISEL-NEXT:  %1:ar = SETZI_A 31744, 0
; POSTISEL-NEXT:  %2:ar = OR_IZ_A killed %1, 2080374784, 0
; POSTISEL-NEXT:  %3:ar = OR_A %0, %2, 0
; POSTISEL-NEXT:  %4:ar = F16V2CMPNE killed %3, %2, 0
; POSTISEL-NEXT:  %5:mr = COPY %4
; POSTISEL-NEXT:  $m0 = COPY %5
; POSTISEL-NEXT:  RTN_PSEUDO
; POSTISEL-NEXT:  RTN_REG_HOLDER implicit $m0
define <2 x i1> @or_a_iz12_over_reuse(<2 x half> %x) {
  %masked = call <2 x half> @OR(<2 x half> %x, i32 2080406528) ; cst = 0x7C007C00
  %res = fcmp une <2 x half> %masked, <half 0xH7C00, half 0xH7C00>
  ret <2 x i1> %res
}

; CHECK-LABEL: andc_a_zi12:
; CHECK:       # %bb
; CHECK-NEXT:  andc $a0, $a0, 4095
; CHECK:       br $m10
define <2 x half> @andc_a_zi12(<2 x half> %x) {
  %res = call <2 x half> @ANDC(<2 x half> %x, i32 4095) ; cst = 0xFFF
  ret <2 x half> %res
}

; CHECK-LABEL: andc_a_zi12_over:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a1, 4096
; CHECK-NEXT:  andc $a0, $a0, $a1
; CHECK:       br $m10
define <2 x half> @andc_a_zi12_over(<2 x half> %x) {
  %res = call <2 x half> @ANDC(<2 x half> %x, i32 4096) ; cst = 0x1000
  ret <2 x half> %res
}

; CHECK-LABEL: andc_a_iz12:
; CHECK:       # %bb
; CHECK-NEXT:  andc $a0, $a0, 4293918720
; CHECK:       br $m10
define <2 x half> @andc_a_iz12(<2 x half> %x) {
  %res = call <2 x half> @ANDC(<2 x half> %x, i32 4293918720) ; cst = 0xFFF00000
  ret <2 x half> %res
}

; CHECK-LABEL: andc_a_iz12_over:
; CHECK:       # %bb
; CHECK-NEXT:  setzi [[SETREG:\$a[1-5]]], 524288
; CHECK-NEXT:  or $a1, [[SETREG]], 4293918720
; CHECK-NEXT:  andc $a0, $a0, $a1
; CHECK:       br $m10
define <2 x half> @andc_a_iz12_over(<2 x half> %x) {
  %res = call <2 x half> @ANDC(<2 x half> %x, i32 4294443008) ; cst = 0xFFF80000
  ret <2 x half> %res
}

; Check that a constant also used in a non bitwise operation is not
; synthesized twice.
; POSTISEL-LABEL: name: andc_a_iz12_over_reuse
; POSTISEL:       liveins: $a0
; POSTISEL:       %0:ar = COPY $a0
; POSTISEL-NEXT:  %1:ar = SETZI_A 31744, 0
; POSTISEL-NEXT:  %2:ar = OR_IZ_A killed %1, 2080374784, 0
; POSTISEL-NEXT:  %3:ar = ANDC_A %0, %2, 0
; POSTISEL-NEXT:  %4:ar = F16V2CMPNE killed %3, %2, 0
; POSTISEL-NEXT:  %5:mr = COPY %4
; POSTISEL-NEXT:  $m0 = COPY %5
; POSTISEL-NEXT:  RTN_PSEUDO
; POSTISEL-NEXT:  RTN_REG_HOLDER implicit $m0
define <2 x i1> @andc_a_iz12_over_reuse(<2 x half> %x) {
  %masked = call <2 x half> @ANDC(<2 x half> %x, i32 2080406528) ; cst = 0x7C007C00
  %res = fcmp une <2 x half> %masked, <half 0xH7C00, half 0xH7C00>
  ret <2 x i1> %res
}
