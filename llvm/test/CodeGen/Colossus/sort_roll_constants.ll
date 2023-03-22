; RUN: llvm-link %isdopc %s | opt -instcombine -always-inline -mattr=+ipu1 | llc -march=colossus -colossus-coissue=false -mattr=+ipu1 | FileCheck %s
; RUN: llvm-link %isdopc %s | opt -instcombine -always-inline -mattr=+ipu2 | llc -march=colossus -colossus-coissue=false -mattr=+ipu2 | FileCheck %s

declare <2 x half> @llvm.colossus.SDAG.binary.v2f16(i32, <2 x half>, <2 x half>)

@ColossusISD_SORT4X16LO = external constant i32
@ColossusISD_SORT4X16HI = external constant i32
@ColossusISD_ROLL16 = external constant i32

; CHECK-LABEL: SORT4X16LO_un_bc:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196609
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un_bc() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half 0xH2>,
        <2 x half> <half 0xH3, half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un_bc1:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196609
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un_bc1() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half 0xH2>,
        <2 x half> <half 0xH3, half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un_bc2:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196609
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un_bc2() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half bitcast (i16 2 to half)>,
        <2 x half> <half 0xH3, half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un_bc3:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196609
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un_bc3() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half 0xH2>,
        <2 x half> <half bitcast (i16 3 to half), half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un_bc4:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196609
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un_bc4() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half 0xH2>,
        <2 x half> <half 0xH3, half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un_bc12:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196609
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un_bc12() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half bitcast (i16 2 to half)>,
        <2 x half> <half 0xH3, half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un_bc13:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196609
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un_bc13() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half 0xH2>,
        <2 x half> <half bitcast (i16 3 to half), half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un_bc14:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196609
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un_bc14() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half 0xH2>,
        <2 x half> <half 0xH3, half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un_bc23:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196609
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un_bc23() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half bitcast (i16 2 to half)>,
        <2 x half> <half bitcast (i16 3 to half), half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un_bc24:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196609
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un_bc24() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half bitcast (i16 2 to half)>,
        <2 x half> <half 0xH3, half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un_bc34:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196609
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un_bc34() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half 0xH2>,
        <2 x half> <half bitcast (i16 3 to half), half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un_bc123:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196609
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un_bc123() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half bitcast (i16 2 to half)>,
        <2 x half> <half bitcast (i16 3 to half), half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un_bc124:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196609
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un_bc124() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half bitcast (i16 2 to half)>,
        <2 x half> <half 0xH3, half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un_bc134:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196609
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un_bc134() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half 0xH2>,
        <2 x half> <half bitcast (i16 3 to half), half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un_bc234:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196609
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un_bc234() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half bitcast (i16 2 to half)>,
        <2 x half> <half bitcast (i16 3 to half), half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un_bc1234:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196609
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un_bc1234() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half bitcast (i16 2 to half)>,
        <2 x half> <half bitcast (i16 3 to half), half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un1_bc:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un1_bc() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half 0xH2>,
        <2 x half> <half 0xH3, half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un1_bc1:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un1_bc1() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half 0xH2>,
        <2 x half> <half 0xH3, half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un1_bc2:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un1_bc2() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half bitcast (i16 2 to half)>,
        <2 x half> <half 0xH3, half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un1_bc3:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un1_bc3() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half 0xH2>,
        <2 x half> <half bitcast (i16 3 to half), half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un1_bc4:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un1_bc4() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half 0xH2>,
        <2 x half> <half 0xH3, half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un1_bc12:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un1_bc12() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 2 to half)>,
        <2 x half> <half 0xH3, half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un1_bc13:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un1_bc13() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half 0xH2>,
        <2 x half> <half bitcast (i16 3 to half), half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un1_bc14:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un1_bc14() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half 0xH2>,
        <2 x half> <half 0xH3, half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un1_bc23:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un1_bc23() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half bitcast (i16 2 to half)>,
        <2 x half> <half bitcast (i16 3 to half), half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un1_bc24:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un1_bc24() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half bitcast (i16 2 to half)>,
        <2 x half> <half 0xH3, half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un1_bc34:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un1_bc34() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half 0xH2>,
        <2 x half> <half bitcast (i16 3 to half), half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un1_bc123:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un1_bc123() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 2 to half)>,
        <2 x half> <half bitcast (i16 3 to half), half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un1_bc124:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un1_bc124() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 2 to half)>,
        <2 x half> <half 0xH3, half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un1_bc134:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un1_bc134() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half 0xH2>,
        <2 x half> <half bitcast (i16 3 to half), half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un1_bc234:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un1_bc234() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half bitcast (i16 2 to half)>,
        <2 x half> <half bitcast (i16 3 to half), half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un1_bc1234:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un1_bc1234() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 2 to half)>,
        <2 x half> <half bitcast (i16 3 to half), half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un2_bc:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196609
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un2_bc() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half undef>,
        <2 x half> <half 0xH3, half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un2_bc1:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196609
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un2_bc1() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half undef>,
        <2 x half> <half 0xH3, half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un2_bc2:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196609
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un2_bc2() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half bitcast (i16 undef to half)>,
        <2 x half> <half 0xH3, half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un2_bc3:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196609
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un2_bc3() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half undef>,
        <2 x half> <half bitcast (i16 3 to half), half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un2_bc4:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196609
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un2_bc4() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half undef>,
        <2 x half> <half 0xH3, half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un2_bc12:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196609
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un2_bc12() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half bitcast (i16 undef to half)>,
        <2 x half> <half 0xH3, half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un2_bc13:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196609
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un2_bc13() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half undef>,
        <2 x half> <half bitcast (i16 3 to half), half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un2_bc14:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196609
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un2_bc14() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half undef>,
        <2 x half> <half 0xH3, half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un2_bc23:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196609
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un2_bc23() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half bitcast (i16 undef to half)>,
        <2 x half> <half bitcast (i16 3 to half), half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un2_bc24:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196609
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un2_bc24() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half bitcast (i16 undef to half)>,
        <2 x half> <half 0xH3, half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un2_bc34:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196609
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un2_bc34() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half undef>,
        <2 x half> <half bitcast (i16 3 to half), half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un2_bc123:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196609
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un2_bc123() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half bitcast (i16 undef to half)>,
        <2 x half> <half bitcast (i16 3 to half), half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un2_bc124:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196609
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un2_bc124() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half bitcast (i16 undef to half)>,
        <2 x half> <half 0xH3, half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un2_bc134:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196609
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un2_bc134() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half undef>,
        <2 x half> <half bitcast (i16 3 to half), half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un2_bc234:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196609
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un2_bc234() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half bitcast (i16 undef to half)>,
        <2 x half> <half bitcast (i16 3 to half), half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un2_bc1234:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196609
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un2_bc1234() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half bitcast (i16 undef to half)>,
        <2 x half> <half bitcast (i16 3 to half), half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un3_bc:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 1
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un3_bc() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half 0xH2>,
        <2 x half> <half undef, half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un3_bc1:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 1
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un3_bc1() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half 0xH2>,
        <2 x half> <half undef, half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un3_bc2:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 1
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un3_bc2() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half bitcast (i16 2 to half)>,
        <2 x half> <half undef, half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un3_bc3:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 1
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un3_bc3() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half 0xH2>,
        <2 x half> <half bitcast (i16 undef to half), half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un3_bc4:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 1
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un3_bc4() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half 0xH2>,
        <2 x half> <half undef, half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un3_bc12:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 1
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un3_bc12() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half bitcast (i16 2 to half)>,
        <2 x half> <half undef, half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un3_bc13:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 1
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un3_bc13() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half 0xH2>,
        <2 x half> <half bitcast (i16 undef to half), half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un3_bc14:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 1
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un3_bc14() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half 0xH2>,
        <2 x half> <half undef, half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un3_bc23:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 1
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un3_bc23() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half bitcast (i16 2 to half)>,
        <2 x half> <half bitcast (i16 undef to half), half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un3_bc24:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 1
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un3_bc24() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half bitcast (i16 2 to half)>,
        <2 x half> <half undef, half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un3_bc34:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 1
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un3_bc34() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half 0xH2>,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un3_bc123:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 1
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un3_bc123() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half bitcast (i16 2 to half)>,
        <2 x half> <half bitcast (i16 undef to half), half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un3_bc124:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 1
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un3_bc124() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half bitcast (i16 2 to half)>,
        <2 x half> <half undef, half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un3_bc134:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 1
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un3_bc134() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half 0xH2>,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un3_bc234:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 1
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un3_bc234() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half bitcast (i16 2 to half)>,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un3_bc1234:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 1
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un3_bc1234() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half bitcast (i16 2 to half)>,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un4_bc:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196609
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un4_bc() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half 0xH2>,
        <2 x half> <half 0xH3, half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un4_bc1:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196609
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un4_bc1() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half 0xH2>,
        <2 x half> <half 0xH3, half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un4_bc2:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196609
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un4_bc2() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half bitcast (i16 2 to half)>,
        <2 x half> <half 0xH3, half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un4_bc3:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196609
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un4_bc3() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half 0xH2>,
        <2 x half> <half bitcast (i16 3 to half), half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un4_bc4:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196609
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un4_bc4() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half 0xH2>,
        <2 x half> <half 0xH3, half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un4_bc12:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196609
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un4_bc12() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half bitcast (i16 2 to half)>,
        <2 x half> <half 0xH3, half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un4_bc13:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196609
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un4_bc13() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half 0xH2>,
        <2 x half> <half bitcast (i16 3 to half), half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un4_bc14:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196609
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un4_bc14() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half 0xH2>,
        <2 x half> <half 0xH3, half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un4_bc23:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196609
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un4_bc23() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half bitcast (i16 2 to half)>,
        <2 x half> <half bitcast (i16 3 to half), half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un4_bc24:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196609
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un4_bc24() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half bitcast (i16 2 to half)>,
        <2 x half> <half 0xH3, half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un4_bc34:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196609
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un4_bc34() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half 0xH2>,
        <2 x half> <half bitcast (i16 3 to half), half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un4_bc123:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196609
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un4_bc123() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half bitcast (i16 2 to half)>,
        <2 x half> <half bitcast (i16 3 to half), half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un4_bc124:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196609
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un4_bc124() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half bitcast (i16 2 to half)>,
        <2 x half> <half 0xH3, half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un4_bc134:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196609
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un4_bc134() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half 0xH2>,
        <2 x half> <half bitcast (i16 3 to half), half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un4_bc234:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196609
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un4_bc234() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half bitcast (i16 2 to half)>,
        <2 x half> <half bitcast (i16 3 to half), half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un4_bc1234:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196609
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un4_bc1234() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half bitcast (i16 2 to half)>,
        <2 x half> <half bitcast (i16 3 to half), half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un12_bc:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un12_bc() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half undef>,
        <2 x half> <half 0xH3, half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un12_bc1:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un12_bc1() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half undef>,
        <2 x half> <half 0xH3, half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un12_bc2:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un12_bc2() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half bitcast (i16 undef to half)>,
        <2 x half> <half 0xH3, half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un12_bc3:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un12_bc3() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half undef>,
        <2 x half> <half bitcast (i16 3 to half), half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un12_bc4:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un12_bc4() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half undef>,
        <2 x half> <half 0xH3, half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un12_bc12:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un12_bc12() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 undef to half)>,
        <2 x half> <half 0xH3, half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un12_bc13:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un12_bc13() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half undef>,
        <2 x half> <half bitcast (i16 3 to half), half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un12_bc14:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un12_bc14() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half undef>,
        <2 x half> <half 0xH3, half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un12_bc23:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un12_bc23() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half bitcast (i16 undef to half)>,
        <2 x half> <half bitcast (i16 3 to half), half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un12_bc24:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un12_bc24() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half bitcast (i16 undef to half)>,
        <2 x half> <half 0xH3, half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un12_bc34:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un12_bc34() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half undef>,
        <2 x half> <half bitcast (i16 3 to half), half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un12_bc123:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un12_bc123() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 undef to half)>,
        <2 x half> <half bitcast (i16 3 to half), half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un12_bc124:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un12_bc124() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 undef to half)>,
        <2 x half> <half 0xH3, half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un12_bc134:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un12_bc134() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half undef>,
        <2 x half> <half bitcast (i16 3 to half), half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un12_bc234:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un12_bc234() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half bitcast (i16 undef to half)>,
        <2 x half> <half bitcast (i16 3 to half), half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un12_bc1234:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un12_bc1234() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 undef to half)>,
        <2 x half> <half bitcast (i16 3 to half), half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un13_bc:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un13_bc() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half 0xH2>,
        <2 x half> <half undef, half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un13_bc1:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un13_bc1() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half 0xH2>,
        <2 x half> <half undef, half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un13_bc2:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un13_bc2() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half bitcast (i16 2 to half)>,
        <2 x half> <half undef, half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un13_bc3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un13_bc3() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half 0xH2>,
        <2 x half> <half bitcast (i16 undef to half), half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un13_bc4:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un13_bc4() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half 0xH2>,
        <2 x half> <half undef, half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un13_bc12:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un13_bc12() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 2 to half)>,
        <2 x half> <half undef, half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un13_bc13:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un13_bc13() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half 0xH2>,
        <2 x half> <half bitcast (i16 undef to half), half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un13_bc14:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un13_bc14() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half 0xH2>,
        <2 x half> <half undef, half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un13_bc23:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un13_bc23() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half bitcast (i16 2 to half)>,
        <2 x half> <half bitcast (i16 undef to half), half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un13_bc24:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un13_bc24() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half bitcast (i16 2 to half)>,
        <2 x half> <half undef, half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un13_bc34:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un13_bc34() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half 0xH2>,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un13_bc123:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un13_bc123() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 2 to half)>,
        <2 x half> <half bitcast (i16 undef to half), half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un13_bc124:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un13_bc124() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 2 to half)>,
        <2 x half> <half undef, half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un13_bc134:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un13_bc134() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half 0xH2>,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un13_bc234:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un13_bc234() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half bitcast (i16 2 to half)>,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un13_bc1234:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un13_bc1234() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 2 to half)>,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un14_bc:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un14_bc() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half 0xH2>,
        <2 x half> <half 0xH3, half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un14_bc1:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un14_bc1() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half 0xH2>,
        <2 x half> <half 0xH3, half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un14_bc2:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un14_bc2() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half bitcast (i16 2 to half)>,
        <2 x half> <half 0xH3, half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un14_bc3:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un14_bc3() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half 0xH2>,
        <2 x half> <half bitcast (i16 3 to half), half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un14_bc4:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un14_bc4() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half 0xH2>,
        <2 x half> <half 0xH3, half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un14_bc12:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un14_bc12() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 2 to half)>,
        <2 x half> <half 0xH3, half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un14_bc13:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un14_bc13() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half 0xH2>,
        <2 x half> <half bitcast (i16 3 to half), half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un14_bc14:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un14_bc14() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half 0xH2>,
        <2 x half> <half 0xH3, half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un14_bc23:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un14_bc23() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half bitcast (i16 2 to half)>,
        <2 x half> <half bitcast (i16 3 to half), half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un14_bc24:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un14_bc24() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half bitcast (i16 2 to half)>,
        <2 x half> <half 0xH3, half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un14_bc34:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un14_bc34() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half 0xH2>,
        <2 x half> <half bitcast (i16 3 to half), half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un14_bc123:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un14_bc123() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 2 to half)>,
        <2 x half> <half bitcast (i16 3 to half), half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un14_bc124:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un14_bc124() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 2 to half)>,
        <2 x half> <half 0xH3, half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un14_bc134:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un14_bc134() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half 0xH2>,
        <2 x half> <half bitcast (i16 3 to half), half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un14_bc234:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un14_bc234() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half bitcast (i16 2 to half)>,
        <2 x half> <half bitcast (i16 3 to half), half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un14_bc1234:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un14_bc1234() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 2 to half)>,
        <2 x half> <half bitcast (i16 3 to half), half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un23_bc:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 1
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un23_bc() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half undef>,
        <2 x half> <half undef, half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un23_bc1:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 1
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un23_bc1() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half undef>,
        <2 x half> <half undef, half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un23_bc2:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 1
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un23_bc2() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half bitcast (i16 undef to half)>,
        <2 x half> <half undef, half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un23_bc3:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 1
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un23_bc3() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half undef>,
        <2 x half> <half bitcast (i16 undef to half), half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un23_bc4:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 1
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un23_bc4() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half undef>,
        <2 x half> <half undef, half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un23_bc12:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 1
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un23_bc12() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half bitcast (i16 undef to half)>,
        <2 x half> <half undef, half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un23_bc13:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 1
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un23_bc13() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half undef>,
        <2 x half> <half bitcast (i16 undef to half), half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un23_bc14:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 1
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un23_bc14() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half undef>,
        <2 x half> <half undef, half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un23_bc23:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 1
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un23_bc23() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half bitcast (i16 undef to half)>,
        <2 x half> <half bitcast (i16 undef to half), half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un23_bc24:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 1
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un23_bc24() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half bitcast (i16 undef to half)>,
        <2 x half> <half undef, half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un23_bc34:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 1
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un23_bc34() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half undef>,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un23_bc123:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 1
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un23_bc123() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half bitcast (i16 undef to half)>,
        <2 x half> <half bitcast (i16 undef to half), half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un23_bc124:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 1
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un23_bc124() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half bitcast (i16 undef to half)>,
        <2 x half> <half undef, half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un23_bc134:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 1
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un23_bc134() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half undef>,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un23_bc234:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 1
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un23_bc234() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half bitcast (i16 undef to half)>,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un23_bc1234:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 1
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un23_bc1234() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half bitcast (i16 undef to half)>,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un24_bc:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196609
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un24_bc() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half undef>,
        <2 x half> <half 0xH3, half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un24_bc1:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196609
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un24_bc1() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half undef>,
        <2 x half> <half 0xH3, half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un24_bc2:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196609
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un24_bc2() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half bitcast (i16 undef to half)>,
        <2 x half> <half 0xH3, half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un24_bc3:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196609
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un24_bc3() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half undef>,
        <2 x half> <half bitcast (i16 3 to half), half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un24_bc4:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196609
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un24_bc4() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half undef>,
        <2 x half> <half 0xH3, half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un24_bc12:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196609
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un24_bc12() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half bitcast (i16 undef to half)>,
        <2 x half> <half 0xH3, half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un24_bc13:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196609
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un24_bc13() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half undef>,
        <2 x half> <half bitcast (i16 3 to half), half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un24_bc14:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196609
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un24_bc14() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half undef>,
        <2 x half> <half 0xH3, half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un24_bc23:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196609
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un24_bc23() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half bitcast (i16 undef to half)>,
        <2 x half> <half bitcast (i16 3 to half), half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un24_bc24:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196609
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un24_bc24() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half bitcast (i16 undef to half)>,
        <2 x half> <half 0xH3, half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un24_bc34:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196609
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un24_bc34() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half undef>,
        <2 x half> <half bitcast (i16 3 to half), half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un24_bc123:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196609
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un24_bc123() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half bitcast (i16 undef to half)>,
        <2 x half> <half bitcast (i16 3 to half), half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un24_bc124:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196609
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un24_bc124() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half bitcast (i16 undef to half)>,
        <2 x half> <half 0xH3, half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un24_bc134:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196609
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un24_bc134() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half undef>,
        <2 x half> <half bitcast (i16 3 to half), half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un24_bc234:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196609
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un24_bc234() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half bitcast (i16 undef to half)>,
        <2 x half> <half bitcast (i16 3 to half), half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un24_bc1234:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196609
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un24_bc1234() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half bitcast (i16 undef to half)>,
        <2 x half> <half bitcast (i16 3 to half), half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un34_bc:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 1
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un34_bc() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half 0xH2>,
        <2 x half> <half undef, half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un34_bc1:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 1
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un34_bc1() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half 0xH2>,
        <2 x half> <half undef, half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un34_bc2:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 1
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un34_bc2() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half bitcast (i16 2 to half)>,
        <2 x half> <half undef, half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un34_bc3:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 1
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un34_bc3() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half 0xH2>,
        <2 x half> <half bitcast (i16 undef to half), half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un34_bc4:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 1
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un34_bc4() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half 0xH2>,
        <2 x half> <half undef, half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un34_bc12:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 1
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un34_bc12() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half bitcast (i16 2 to half)>,
        <2 x half> <half undef, half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un34_bc13:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 1
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un34_bc13() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half 0xH2>,
        <2 x half> <half bitcast (i16 undef to half), half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un34_bc14:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 1
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un34_bc14() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half 0xH2>,
        <2 x half> <half undef, half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un34_bc23:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 1
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un34_bc23() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half bitcast (i16 2 to half)>,
        <2 x half> <half bitcast (i16 undef to half), half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un34_bc24:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 1
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un34_bc24() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half bitcast (i16 2 to half)>,
        <2 x half> <half undef, half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un34_bc34:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 1
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un34_bc34() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half 0xH2>,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un34_bc123:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 1
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un34_bc123() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half bitcast (i16 2 to half)>,
        <2 x half> <half bitcast (i16 undef to half), half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un34_bc124:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 1
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un34_bc124() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half bitcast (i16 2 to half)>,
        <2 x half> <half undef, half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un34_bc134:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 1
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un34_bc134() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half 0xH2>,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un34_bc234:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 1
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un34_bc234() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half bitcast (i16 2 to half)>,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un34_bc1234:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 1
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un34_bc1234() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half bitcast (i16 2 to half)>,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un123_bc:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un123_bc() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half undef>,
        <2 x half> <half undef, half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un123_bc1:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un123_bc1() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half undef>,
        <2 x half> <half undef, half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un123_bc2:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un123_bc2() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half bitcast (i16 undef to half)>,
        <2 x half> <half undef, half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un123_bc3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un123_bc3() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half undef>,
        <2 x half> <half bitcast (i16 undef to half), half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un123_bc4:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un123_bc4() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half undef>,
        <2 x half> <half undef, half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un123_bc12:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un123_bc12() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 undef to half)>,
        <2 x half> <half undef, half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un123_bc13:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un123_bc13() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half undef>,
        <2 x half> <half bitcast (i16 undef to half), half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un123_bc14:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un123_bc14() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half undef>,
        <2 x half> <half undef, half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un123_bc23:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un123_bc23() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half bitcast (i16 undef to half)>,
        <2 x half> <half bitcast (i16 undef to half), half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un123_bc24:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un123_bc24() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half bitcast (i16 undef to half)>,
        <2 x half> <half undef, half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un123_bc34:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un123_bc34() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half undef>,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un123_bc123:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un123_bc123() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 undef to half)>,
        <2 x half> <half bitcast (i16 undef to half), half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un123_bc124:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un123_bc124() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 undef to half)>,
        <2 x half> <half undef, half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un123_bc134:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un123_bc134() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half undef>,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un123_bc234:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un123_bc234() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half bitcast (i16 undef to half)>,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un123_bc1234:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un123_bc1234() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 undef to half)>,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un124_bc:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un124_bc() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half undef>,
        <2 x half> <half 0xH3, half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un124_bc1:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un124_bc1() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half undef>,
        <2 x half> <half 0xH3, half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un124_bc2:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un124_bc2() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half bitcast (i16 undef to half)>,
        <2 x half> <half 0xH3, half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un124_bc3:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un124_bc3() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half undef>,
        <2 x half> <half bitcast (i16 3 to half), half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un124_bc4:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un124_bc4() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half undef>,
        <2 x half> <half 0xH3, half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un124_bc12:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un124_bc12() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 undef to half)>,
        <2 x half> <half 0xH3, half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un124_bc13:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un124_bc13() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half undef>,
        <2 x half> <half bitcast (i16 3 to half), half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un124_bc14:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un124_bc14() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half undef>,
        <2 x half> <half 0xH3, half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un124_bc23:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un124_bc23() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half bitcast (i16 undef to half)>,
        <2 x half> <half bitcast (i16 3 to half), half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un124_bc24:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un124_bc24() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half bitcast (i16 undef to half)>,
        <2 x half> <half 0xH3, half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un124_bc34:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un124_bc34() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half undef>,
        <2 x half> <half bitcast (i16 3 to half), half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un124_bc123:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un124_bc123() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 undef to half)>,
        <2 x half> <half bitcast (i16 3 to half), half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un124_bc124:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un124_bc124() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 undef to half)>,
        <2 x half> <half 0xH3, half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un124_bc134:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un124_bc134() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half undef>,
        <2 x half> <half bitcast (i16 3 to half), half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un124_bc234:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un124_bc234() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half bitcast (i16 undef to half)>,
        <2 x half> <half bitcast (i16 3 to half), half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un124_bc1234:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un124_bc1234() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 undef to half)>,
        <2 x half> <half bitcast (i16 3 to half), half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un134_bc:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un134_bc() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half 0xH2>,
        <2 x half> <half undef, half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un134_bc1:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un134_bc1() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half 0xH2>,
        <2 x half> <half undef, half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un134_bc2:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un134_bc2() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half bitcast (i16 2 to half)>,
        <2 x half> <half undef, half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un134_bc3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un134_bc3() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half 0xH2>,
        <2 x half> <half bitcast (i16 undef to half), half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un134_bc4:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un134_bc4() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half 0xH2>,
        <2 x half> <half undef, half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un134_bc12:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un134_bc12() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 2 to half)>,
        <2 x half> <half undef, half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un134_bc13:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un134_bc13() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half 0xH2>,
        <2 x half> <half bitcast (i16 undef to half), half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un134_bc14:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un134_bc14() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half 0xH2>,
        <2 x half> <half undef, half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un134_bc23:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un134_bc23() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half bitcast (i16 2 to half)>,
        <2 x half> <half bitcast (i16 undef to half), half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un134_bc24:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un134_bc24() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half bitcast (i16 2 to half)>,
        <2 x half> <half undef, half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un134_bc34:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un134_bc34() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half 0xH2>,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un134_bc123:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un134_bc123() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 2 to half)>,
        <2 x half> <half bitcast (i16 undef to half), half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un134_bc124:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un134_bc124() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 2 to half)>,
        <2 x half> <half undef, half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un134_bc134:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un134_bc134() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half 0xH2>,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un134_bc234:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un134_bc234() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half bitcast (i16 2 to half)>,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un134_bc1234:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un134_bc1234() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 2 to half)>,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un234_bc:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 1
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un234_bc() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half undef>,
        <2 x half> <half undef, half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un234_bc1:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 1
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un234_bc1() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half undef>,
        <2 x half> <half undef, half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un234_bc2:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 1
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un234_bc2() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half bitcast (i16 undef to half)>,
        <2 x half> <half undef, half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un234_bc3:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 1
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un234_bc3() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half undef>,
        <2 x half> <half bitcast (i16 undef to half), half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un234_bc4:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 1
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un234_bc4() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half undef>,
        <2 x half> <half undef, half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un234_bc12:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 1
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un234_bc12() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half bitcast (i16 undef to half)>,
        <2 x half> <half undef, half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un234_bc13:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 1
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un234_bc13() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half undef>,
        <2 x half> <half bitcast (i16 undef to half), half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un234_bc14:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 1
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un234_bc14() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half undef>,
        <2 x half> <half undef, half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un234_bc23:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 1
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un234_bc23() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half bitcast (i16 undef to half)>,
        <2 x half> <half bitcast (i16 undef to half), half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un234_bc24:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 1
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un234_bc24() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half bitcast (i16 undef to half)>,
        <2 x half> <half undef, half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un234_bc34:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 1
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un234_bc34() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half undef>,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un234_bc123:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 1
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un234_bc123() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half bitcast (i16 undef to half)>,
        <2 x half> <half bitcast (i16 undef to half), half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un234_bc124:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 1
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un234_bc124() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half bitcast (i16 undef to half)>,
        <2 x half> <half undef, half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un234_bc134:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 1
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un234_bc134() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half undef>,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un234_bc234:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 1
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un234_bc234() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half bitcast (i16 undef to half)>,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un234_bc1234:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 1
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un234_bc1234() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half bitcast (i16 undef to half)>,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un1234_bc:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un1234_bc() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half undef>,
        <2 x half> <half undef, half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un1234_bc1:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un1234_bc1() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half undef>,
        <2 x half> <half undef, half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un1234_bc2:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un1234_bc2() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half bitcast (i16 undef to half)>,
        <2 x half> <half undef, half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un1234_bc3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un1234_bc3() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half undef>,
        <2 x half> <half bitcast (i16 undef to half), half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un1234_bc4:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un1234_bc4() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half undef>,
        <2 x half> <half undef, half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un1234_bc12:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un1234_bc12() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 undef to half)>,
        <2 x half> <half undef, half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un1234_bc13:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un1234_bc13() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half undef>,
        <2 x half> <half bitcast (i16 undef to half), half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un1234_bc14:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un1234_bc14() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half undef>,
        <2 x half> <half undef, half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un1234_bc23:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un1234_bc23() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half bitcast (i16 undef to half)>,
        <2 x half> <half bitcast (i16 undef to half), half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un1234_bc24:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un1234_bc24() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half bitcast (i16 undef to half)>,
        <2 x half> <half undef, half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un1234_bc34:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un1234_bc34() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half undef>,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un1234_bc123:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un1234_bc123() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 undef to half)>,
        <2 x half> <half bitcast (i16 undef to half), half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un1234_bc124:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un1234_bc124() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 undef to half)>,
        <2 x half> <half undef, half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un1234_bc134:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un1234_bc134() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half undef>,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un1234_bc234:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un1234_bc234() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half bitcast (i16 undef to half)>,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16LO_un1234_bc1234:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16LO_un1234_bc1234() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 undef to half)>,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un_bc:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262146
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un_bc() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half 0xH2>,
        <2 x half> <half 0xH3, half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un_bc1:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262146
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un_bc1() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half 0xH2>,
        <2 x half> <half 0xH3, half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un_bc2:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262146
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un_bc2() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half bitcast (i16 2 to half)>,
        <2 x half> <half 0xH3, half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un_bc3:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262146
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un_bc3() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half 0xH2>,
        <2 x half> <half bitcast (i16 3 to half), half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un_bc4:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262146
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un_bc4() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half 0xH2>,
        <2 x half> <half 0xH3, half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un_bc12:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262146
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un_bc12() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half bitcast (i16 2 to half)>,
        <2 x half> <half 0xH3, half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un_bc13:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262146
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un_bc13() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half 0xH2>,
        <2 x half> <half bitcast (i16 3 to half), half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un_bc14:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262146
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un_bc14() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half 0xH2>,
        <2 x half> <half 0xH3, half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un_bc23:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262146
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un_bc23() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half bitcast (i16 2 to half)>,
        <2 x half> <half bitcast (i16 3 to half), half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un_bc24:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262146
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un_bc24() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half bitcast (i16 2 to half)>,
        <2 x half> <half 0xH3, half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un_bc34:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262146
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un_bc34() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half 0xH2>,
        <2 x half> <half bitcast (i16 3 to half), half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un_bc123:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262146
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un_bc123() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half bitcast (i16 2 to half)>,
        <2 x half> <half bitcast (i16 3 to half), half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un_bc124:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262146
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un_bc124() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half bitcast (i16 2 to half)>,
        <2 x half> <half 0xH3, half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un_bc134:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262146
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un_bc134() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half 0xH2>,
        <2 x half> <half bitcast (i16 3 to half), half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un_bc234:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262146
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un_bc234() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half bitcast (i16 2 to half)>,
        <2 x half> <half bitcast (i16 3 to half), half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un_bc1234:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262146
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un_bc1234() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half bitcast (i16 2 to half)>,
        <2 x half> <half bitcast (i16 3 to half), half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un1_bc:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262146
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un1_bc() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half 0xH2>,
        <2 x half> <half 0xH3, half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un1_bc1:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262146
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un1_bc1() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half 0xH2>,
        <2 x half> <half 0xH3, half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un1_bc2:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262146
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un1_bc2() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half bitcast (i16 2 to half)>,
        <2 x half> <half 0xH3, half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un1_bc3:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262146
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un1_bc3() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half 0xH2>,
        <2 x half> <half bitcast (i16 3 to half), half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un1_bc4:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262146
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un1_bc4() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half 0xH2>,
        <2 x half> <half 0xH3, half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un1_bc12:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262146
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un1_bc12() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 2 to half)>,
        <2 x half> <half 0xH3, half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un1_bc13:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262146
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un1_bc13() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half 0xH2>,
        <2 x half> <half bitcast (i16 3 to half), half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un1_bc14:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262146
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un1_bc14() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half 0xH2>,
        <2 x half> <half 0xH3, half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un1_bc23:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262146
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un1_bc23() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half bitcast (i16 2 to half)>,
        <2 x half> <half bitcast (i16 3 to half), half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un1_bc24:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262146
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un1_bc24() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half bitcast (i16 2 to half)>,
        <2 x half> <half 0xH3, half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un1_bc34:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262146
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un1_bc34() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half 0xH2>,
        <2 x half> <half bitcast (i16 3 to half), half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un1_bc123:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262146
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un1_bc123() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 2 to half)>,
        <2 x half> <half bitcast (i16 3 to half), half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un1_bc124:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262146
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un1_bc124() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 2 to half)>,
        <2 x half> <half 0xH3, half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un1_bc134:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262146
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un1_bc134() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half 0xH2>,
        <2 x half> <half bitcast (i16 3 to half), half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un1_bc234:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262146
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un1_bc234() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half bitcast (i16 2 to half)>,
        <2 x half> <half bitcast (i16 3 to half), half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un1_bc1234:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262146
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un1_bc1234() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 2 to half)>,
        <2 x half> <half bitcast (i16 3 to half), half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un2_bc:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262144
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un2_bc() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half undef>,
        <2 x half> <half 0xH3, half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un2_bc1:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262144
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un2_bc1() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half undef>,
        <2 x half> <half 0xH3, half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un2_bc2:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262144
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un2_bc2() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half bitcast (i16 undef to half)>,
        <2 x half> <half 0xH3, half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un2_bc3:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262144
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un2_bc3() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half undef>,
        <2 x half> <half bitcast (i16 3 to half), half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un2_bc4:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262144
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un2_bc4() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half undef>,
        <2 x half> <half 0xH3, half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un2_bc12:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262144
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un2_bc12() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half bitcast (i16 undef to half)>,
        <2 x half> <half 0xH3, half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un2_bc13:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262144
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un2_bc13() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half undef>,
        <2 x half> <half bitcast (i16 3 to half), half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un2_bc14:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262144
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un2_bc14() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half undef>,
        <2 x half> <half 0xH3, half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un2_bc23:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262144
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un2_bc23() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half bitcast (i16 undef to half)>,
        <2 x half> <half bitcast (i16 3 to half), half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un2_bc24:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262144
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un2_bc24() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half bitcast (i16 undef to half)>,
        <2 x half> <half 0xH3, half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un2_bc34:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262144
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un2_bc34() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half undef>,
        <2 x half> <half bitcast (i16 3 to half), half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un2_bc123:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262144
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un2_bc123() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half bitcast (i16 undef to half)>,
        <2 x half> <half bitcast (i16 3 to half), half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un2_bc124:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262144
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un2_bc124() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half bitcast (i16 undef to half)>,
        <2 x half> <half 0xH3, half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un2_bc134:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262144
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un2_bc134() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half undef>,
        <2 x half> <half bitcast (i16 3 to half), half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un2_bc234:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262144
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un2_bc234() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half bitcast (i16 undef to half)>,
        <2 x half> <half bitcast (i16 3 to half), half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un2_bc1234:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262144
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un2_bc1234() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half bitcast (i16 undef to half)>,
        <2 x half> <half bitcast (i16 3 to half), half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un3_bc:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262146
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un3_bc() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half 0xH2>,
        <2 x half> <half undef, half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un3_bc1:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262146
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un3_bc1() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half 0xH2>,
        <2 x half> <half undef, half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un3_bc2:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262146
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un3_bc2() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half bitcast (i16 2 to half)>,
        <2 x half> <half undef, half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un3_bc3:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262146
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un3_bc3() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half 0xH2>,
        <2 x half> <half bitcast (i16 undef to half), half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un3_bc4:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262146
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un3_bc4() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half 0xH2>,
        <2 x half> <half undef, half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un3_bc12:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262146
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un3_bc12() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half bitcast (i16 2 to half)>,
        <2 x half> <half undef, half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un3_bc13:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262146
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un3_bc13() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half 0xH2>,
        <2 x half> <half bitcast (i16 undef to half), half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un3_bc14:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262146
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un3_bc14() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half 0xH2>,
        <2 x half> <half undef, half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un3_bc23:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262146
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un3_bc23() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half bitcast (i16 2 to half)>,
        <2 x half> <half bitcast (i16 undef to half), half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un3_bc24:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262146
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un3_bc24() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half bitcast (i16 2 to half)>,
        <2 x half> <half undef, half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un3_bc34:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262146
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un3_bc34() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half 0xH2>,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un3_bc123:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262146
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un3_bc123() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half bitcast (i16 2 to half)>,
        <2 x half> <half bitcast (i16 undef to half), half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un3_bc124:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262146
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un3_bc124() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half bitcast (i16 2 to half)>,
        <2 x half> <half undef, half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un3_bc134:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262146
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un3_bc134() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half 0xH2>,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un3_bc234:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262146
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un3_bc234() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half bitcast (i16 2 to half)>,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un3_bc1234:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262146
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un3_bc1234() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half bitcast (i16 2 to half)>,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un4_bc:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un4_bc() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half 0xH2>,
        <2 x half> <half 0xH3, half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un4_bc1:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un4_bc1() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half 0xH2>,
        <2 x half> <half 0xH3, half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un4_bc2:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un4_bc2() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half bitcast (i16 2 to half)>,
        <2 x half> <half 0xH3, half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un4_bc3:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un4_bc3() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half 0xH2>,
        <2 x half> <half bitcast (i16 3 to half), half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un4_bc4:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un4_bc4() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half 0xH2>,
        <2 x half> <half 0xH3, half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un4_bc12:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un4_bc12() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half bitcast (i16 2 to half)>,
        <2 x half> <half 0xH3, half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un4_bc13:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un4_bc13() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half 0xH2>,
        <2 x half> <half bitcast (i16 3 to half), half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un4_bc14:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un4_bc14() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half 0xH2>,
        <2 x half> <half 0xH3, half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un4_bc23:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un4_bc23() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half bitcast (i16 2 to half)>,
        <2 x half> <half bitcast (i16 3 to half), half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un4_bc24:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un4_bc24() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half bitcast (i16 2 to half)>,
        <2 x half> <half 0xH3, half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un4_bc34:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un4_bc34() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half 0xH2>,
        <2 x half> <half bitcast (i16 3 to half), half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un4_bc123:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un4_bc123() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half bitcast (i16 2 to half)>,
        <2 x half> <half bitcast (i16 3 to half), half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un4_bc124:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un4_bc124() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half bitcast (i16 2 to half)>,
        <2 x half> <half 0xH3, half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un4_bc134:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un4_bc134() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half 0xH2>,
        <2 x half> <half bitcast (i16 3 to half), half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un4_bc234:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un4_bc234() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half bitcast (i16 2 to half)>,
        <2 x half> <half bitcast (i16 3 to half), half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un4_bc1234:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un4_bc1234() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half bitcast (i16 2 to half)>,
        <2 x half> <half bitcast (i16 3 to half), half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un12_bc:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262144
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un12_bc() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half undef>,
        <2 x half> <half 0xH3, half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un12_bc1:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262144
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un12_bc1() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half undef>,
        <2 x half> <half 0xH3, half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un12_bc2:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262144
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un12_bc2() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half bitcast (i16 undef to half)>,
        <2 x half> <half 0xH3, half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un12_bc3:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262144
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un12_bc3() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half undef>,
        <2 x half> <half bitcast (i16 3 to half), half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un12_bc4:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262144
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un12_bc4() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half undef>,
        <2 x half> <half 0xH3, half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un12_bc12:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262144
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un12_bc12() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 undef to half)>,
        <2 x half> <half 0xH3, half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un12_bc13:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262144
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un12_bc13() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half undef>,
        <2 x half> <half bitcast (i16 3 to half), half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un12_bc14:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262144
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un12_bc14() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half undef>,
        <2 x half> <half 0xH3, half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un12_bc23:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262144
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un12_bc23() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half bitcast (i16 undef to half)>,
        <2 x half> <half bitcast (i16 3 to half), half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un12_bc24:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262144
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un12_bc24() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half bitcast (i16 undef to half)>,
        <2 x half> <half 0xH3, half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un12_bc34:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262144
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un12_bc34() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half undef>,
        <2 x half> <half bitcast (i16 3 to half), half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un12_bc123:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262144
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un12_bc123() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 undef to half)>,
        <2 x half> <half bitcast (i16 3 to half), half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un12_bc124:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262144
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un12_bc124() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 undef to half)>,
        <2 x half> <half 0xH3, half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un12_bc134:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262144
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un12_bc134() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half undef>,
        <2 x half> <half bitcast (i16 3 to half), half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un12_bc234:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262144
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un12_bc234() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half bitcast (i16 undef to half)>,
        <2 x half> <half bitcast (i16 3 to half), half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un12_bc1234:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262144
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un12_bc1234() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 undef to half)>,
        <2 x half> <half bitcast (i16 3 to half), half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un13_bc:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262146
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un13_bc() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half 0xH2>,
        <2 x half> <half undef, half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un13_bc1:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262146
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un13_bc1() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half 0xH2>,
        <2 x half> <half undef, half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un13_bc2:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262146
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un13_bc2() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half bitcast (i16 2 to half)>,
        <2 x half> <half undef, half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un13_bc3:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262146
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un13_bc3() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half 0xH2>,
        <2 x half> <half bitcast (i16 undef to half), half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un13_bc4:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262146
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un13_bc4() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half 0xH2>,
        <2 x half> <half undef, half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un13_bc12:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262146
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un13_bc12() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 2 to half)>,
        <2 x half> <half undef, half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un13_bc13:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262146
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un13_bc13() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half 0xH2>,
        <2 x half> <half bitcast (i16 undef to half), half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un13_bc14:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262146
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un13_bc14() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half 0xH2>,
        <2 x half> <half undef, half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un13_bc23:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262146
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un13_bc23() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half bitcast (i16 2 to half)>,
        <2 x half> <half bitcast (i16 undef to half), half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un13_bc24:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262146
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un13_bc24() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half bitcast (i16 2 to half)>,
        <2 x half> <half undef, half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un13_bc34:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262146
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un13_bc34() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half 0xH2>,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un13_bc123:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262146
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un13_bc123() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 2 to half)>,
        <2 x half> <half bitcast (i16 undef to half), half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un13_bc124:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262146
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un13_bc124() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 2 to half)>,
        <2 x half> <half undef, half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un13_bc134:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262146
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un13_bc134() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half 0xH2>,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un13_bc234:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262146
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un13_bc234() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half bitcast (i16 2 to half)>,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un13_bc1234:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262146
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un13_bc1234() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 2 to half)>,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un14_bc:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un14_bc() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half 0xH2>,
        <2 x half> <half 0xH3, half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un14_bc1:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un14_bc1() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half 0xH2>,
        <2 x half> <half 0xH3, half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un14_bc2:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un14_bc2() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half bitcast (i16 2 to half)>,
        <2 x half> <half 0xH3, half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un14_bc3:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un14_bc3() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half 0xH2>,
        <2 x half> <half bitcast (i16 3 to half), half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un14_bc4:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un14_bc4() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half 0xH2>,
        <2 x half> <half 0xH3, half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un14_bc12:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un14_bc12() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 2 to half)>,
        <2 x half> <half 0xH3, half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un14_bc13:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un14_bc13() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half 0xH2>,
        <2 x half> <half bitcast (i16 3 to half), half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un14_bc14:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un14_bc14() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half 0xH2>,
        <2 x half> <half 0xH3, half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un14_bc23:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un14_bc23() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half bitcast (i16 2 to half)>,
        <2 x half> <half bitcast (i16 3 to half), half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un14_bc24:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un14_bc24() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half bitcast (i16 2 to half)>,
        <2 x half> <half 0xH3, half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un14_bc34:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un14_bc34() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half 0xH2>,
        <2 x half> <half bitcast (i16 3 to half), half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un14_bc123:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un14_bc123() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 2 to half)>,
        <2 x half> <half bitcast (i16 3 to half), half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un14_bc124:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un14_bc124() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 2 to half)>,
        <2 x half> <half 0xH3, half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un14_bc134:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un14_bc134() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half 0xH2>,
        <2 x half> <half bitcast (i16 3 to half), half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un14_bc234:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un14_bc234() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half bitcast (i16 2 to half)>,
        <2 x half> <half bitcast (i16 3 to half), half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un14_bc1234:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un14_bc1234() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 2 to half)>,
        <2 x half> <half bitcast (i16 3 to half), half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un23_bc:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262144
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un23_bc() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half undef>,
        <2 x half> <half undef, half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un23_bc1:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262144
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un23_bc1() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half undef>,
        <2 x half> <half undef, half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un23_bc2:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262144
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un23_bc2() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half bitcast (i16 undef to half)>,
        <2 x half> <half undef, half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un23_bc3:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262144
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un23_bc3() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half undef>,
        <2 x half> <half bitcast (i16 undef to half), half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un23_bc4:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262144
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un23_bc4() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half undef>,
        <2 x half> <half undef, half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un23_bc12:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262144
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un23_bc12() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half bitcast (i16 undef to half)>,
        <2 x half> <half undef, half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un23_bc13:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262144
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un23_bc13() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half undef>,
        <2 x half> <half bitcast (i16 undef to half), half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un23_bc14:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262144
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un23_bc14() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half undef>,
        <2 x half> <half undef, half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un23_bc23:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262144
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un23_bc23() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half bitcast (i16 undef to half)>,
        <2 x half> <half bitcast (i16 undef to half), half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un23_bc24:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262144
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un23_bc24() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half bitcast (i16 undef to half)>,
        <2 x half> <half undef, half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un23_bc34:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262144
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un23_bc34() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half undef>,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un23_bc123:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262144
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un23_bc123() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half bitcast (i16 undef to half)>,
        <2 x half> <half bitcast (i16 undef to half), half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un23_bc124:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262144
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un23_bc124() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half bitcast (i16 undef to half)>,
        <2 x half> <half undef, half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un23_bc134:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262144
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un23_bc134() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half undef>,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un23_bc234:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262144
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un23_bc234() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half bitcast (i16 undef to half)>,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un23_bc1234:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262144
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un23_bc1234() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half bitcast (i16 undef to half)>,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un24_bc:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un24_bc() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half undef>,
        <2 x half> <half 0xH3, half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un24_bc1:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un24_bc1() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half undef>,
        <2 x half> <half 0xH3, half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un24_bc2:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un24_bc2() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half bitcast (i16 undef to half)>,
        <2 x half> <half 0xH3, half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un24_bc3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un24_bc3() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half undef>,
        <2 x half> <half bitcast (i16 3 to half), half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un24_bc4:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un24_bc4() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half undef>,
        <2 x half> <half 0xH3, half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un24_bc12:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un24_bc12() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half bitcast (i16 undef to half)>,
        <2 x half> <half 0xH3, half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un24_bc13:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un24_bc13() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half undef>,
        <2 x half> <half bitcast (i16 3 to half), half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un24_bc14:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un24_bc14() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half undef>,
        <2 x half> <half 0xH3, half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un24_bc23:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un24_bc23() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half bitcast (i16 undef to half)>,
        <2 x half> <half bitcast (i16 3 to half), half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un24_bc24:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un24_bc24() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half bitcast (i16 undef to half)>,
        <2 x half> <half 0xH3, half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un24_bc34:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un24_bc34() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half undef>,
        <2 x half> <half bitcast (i16 3 to half), half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un24_bc123:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un24_bc123() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half bitcast (i16 undef to half)>,
        <2 x half> <half bitcast (i16 3 to half), half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un24_bc124:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un24_bc124() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half bitcast (i16 undef to half)>,
        <2 x half> <half 0xH3, half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un24_bc134:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un24_bc134() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half undef>,
        <2 x half> <half bitcast (i16 3 to half), half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un24_bc234:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un24_bc234() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half bitcast (i16 undef to half)>,
        <2 x half> <half bitcast (i16 3 to half), half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un24_bc1234:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un24_bc1234() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half bitcast (i16 undef to half)>,
        <2 x half> <half bitcast (i16 3 to half), half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un34_bc:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un34_bc() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half 0xH2>,
        <2 x half> <half undef, half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un34_bc1:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un34_bc1() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half 0xH2>,
        <2 x half> <half undef, half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un34_bc2:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un34_bc2() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half bitcast (i16 2 to half)>,
        <2 x half> <half undef, half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un34_bc3:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un34_bc3() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half 0xH2>,
        <2 x half> <half bitcast (i16 undef to half), half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un34_bc4:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un34_bc4() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half 0xH2>,
        <2 x half> <half undef, half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un34_bc12:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un34_bc12() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half bitcast (i16 2 to half)>,
        <2 x half> <half undef, half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un34_bc13:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un34_bc13() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half 0xH2>,
        <2 x half> <half bitcast (i16 undef to half), half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un34_bc14:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un34_bc14() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half 0xH2>,
        <2 x half> <half undef, half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un34_bc23:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un34_bc23() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half bitcast (i16 2 to half)>,
        <2 x half> <half bitcast (i16 undef to half), half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un34_bc24:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un34_bc24() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half bitcast (i16 2 to half)>,
        <2 x half> <half undef, half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un34_bc34:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un34_bc34() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half 0xH2>,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un34_bc123:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un34_bc123() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half bitcast (i16 2 to half)>,
        <2 x half> <half bitcast (i16 undef to half), half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un34_bc124:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un34_bc124() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half bitcast (i16 2 to half)>,
        <2 x half> <half undef, half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un34_bc134:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un34_bc134() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half 0xH2>,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un34_bc234:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un34_bc234() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half bitcast (i16 2 to half)>,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un34_bc1234:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un34_bc1234() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half bitcast (i16 2 to half)>,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un123_bc:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262144
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un123_bc() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half undef>,
        <2 x half> <half undef, half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un123_bc1:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262144
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un123_bc1() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half undef>,
        <2 x half> <half undef, half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un123_bc2:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262144
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un123_bc2() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half bitcast (i16 undef to half)>,
        <2 x half> <half undef, half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un123_bc3:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262144
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un123_bc3() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half undef>,
        <2 x half> <half bitcast (i16 undef to half), half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un123_bc4:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262144
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un123_bc4() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half undef>,
        <2 x half> <half undef, half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un123_bc12:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262144
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un123_bc12() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 undef to half)>,
        <2 x half> <half undef, half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un123_bc13:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262144
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un123_bc13() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half undef>,
        <2 x half> <half bitcast (i16 undef to half), half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un123_bc14:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262144
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un123_bc14() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half undef>,
        <2 x half> <half undef, half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un123_bc23:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262144
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un123_bc23() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half bitcast (i16 undef to half)>,
        <2 x half> <half bitcast (i16 undef to half), half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un123_bc24:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262144
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un123_bc24() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half bitcast (i16 undef to half)>,
        <2 x half> <half undef, half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un123_bc34:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262144
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un123_bc34() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half undef>,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un123_bc123:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262144
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un123_bc123() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 undef to half)>,
        <2 x half> <half bitcast (i16 undef to half), half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un123_bc124:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262144
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un123_bc124() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 undef to half)>,
        <2 x half> <half undef, half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un123_bc134:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262144
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un123_bc134() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half undef>,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un123_bc234:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262144
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un123_bc234() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half bitcast (i16 undef to half)>,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un123_bc1234:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 262144
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un123_bc1234() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 undef to half)>,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un124_bc:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un124_bc() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half undef>,
        <2 x half> <half 0xH3, half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un124_bc1:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un124_bc1() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half undef>,
        <2 x half> <half 0xH3, half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un124_bc2:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un124_bc2() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half bitcast (i16 undef to half)>,
        <2 x half> <half 0xH3, half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un124_bc3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un124_bc3() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half undef>,
        <2 x half> <half bitcast (i16 3 to half), half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un124_bc4:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un124_bc4() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half undef>,
        <2 x half> <half 0xH3, half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un124_bc12:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un124_bc12() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 undef to half)>,
        <2 x half> <half 0xH3, half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un124_bc13:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un124_bc13() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half undef>,
        <2 x half> <half bitcast (i16 3 to half), half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un124_bc14:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un124_bc14() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half undef>,
        <2 x half> <half 0xH3, half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un124_bc23:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un124_bc23() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half bitcast (i16 undef to half)>,
        <2 x half> <half bitcast (i16 3 to half), half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un124_bc24:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un124_bc24() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half bitcast (i16 undef to half)>,
        <2 x half> <half 0xH3, half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un124_bc34:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un124_bc34() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half undef>,
        <2 x half> <half bitcast (i16 3 to half), half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un124_bc123:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un124_bc123() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 undef to half)>,
        <2 x half> <half bitcast (i16 3 to half), half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un124_bc124:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un124_bc124() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 undef to half)>,
        <2 x half> <half 0xH3, half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un124_bc134:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un124_bc134() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half undef>,
        <2 x half> <half bitcast (i16 3 to half), half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un124_bc234:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un124_bc234() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half bitcast (i16 undef to half)>,
        <2 x half> <half bitcast (i16 3 to half), half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un124_bc1234:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un124_bc1234() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 undef to half)>,
        <2 x half> <half bitcast (i16 3 to half), half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un134_bc:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un134_bc() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half 0xH2>,
        <2 x half> <half undef, half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un134_bc1:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un134_bc1() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half 0xH2>,
        <2 x half> <half undef, half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un134_bc2:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un134_bc2() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half bitcast (i16 2 to half)>,
        <2 x half> <half undef, half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un134_bc3:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un134_bc3() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half 0xH2>,
        <2 x half> <half bitcast (i16 undef to half), half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un134_bc4:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un134_bc4() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half 0xH2>,
        <2 x half> <half undef, half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un134_bc12:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un134_bc12() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 2 to half)>,
        <2 x half> <half undef, half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un134_bc13:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un134_bc13() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half 0xH2>,
        <2 x half> <half bitcast (i16 undef to half), half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un134_bc14:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un134_bc14() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half 0xH2>,
        <2 x half> <half undef, half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un134_bc23:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un134_bc23() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half bitcast (i16 2 to half)>,
        <2 x half> <half bitcast (i16 undef to half), half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un134_bc24:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un134_bc24() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half bitcast (i16 2 to half)>,
        <2 x half> <half undef, half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un134_bc34:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un134_bc34() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half 0xH2>,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un134_bc123:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un134_bc123() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 2 to half)>,
        <2 x half> <half bitcast (i16 undef to half), half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un134_bc124:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un134_bc124() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 2 to half)>,
        <2 x half> <half undef, half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un134_bc134:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un134_bc134() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half 0xH2>,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un134_bc234:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un134_bc234() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half bitcast (i16 2 to half)>,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un134_bc1234:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un134_bc1234() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 2 to half)>,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un234_bc:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un234_bc() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half undef>,
        <2 x half> <half undef, half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un234_bc1:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un234_bc1() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half undef>,
        <2 x half> <half undef, half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un234_bc2:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un234_bc2() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half bitcast (i16 undef to half)>,
        <2 x half> <half undef, half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un234_bc3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un234_bc3() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half undef>,
        <2 x half> <half bitcast (i16 undef to half), half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un234_bc4:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un234_bc4() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half undef>,
        <2 x half> <half undef, half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un234_bc12:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un234_bc12() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half bitcast (i16 undef to half)>,
        <2 x half> <half undef, half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un234_bc13:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un234_bc13() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half undef>,
        <2 x half> <half bitcast (i16 undef to half), half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un234_bc14:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un234_bc14() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half undef>,
        <2 x half> <half undef, half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un234_bc23:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un234_bc23() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half bitcast (i16 undef to half)>,
        <2 x half> <half bitcast (i16 undef to half), half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un234_bc24:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un234_bc24() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half bitcast (i16 undef to half)>,
        <2 x half> <half undef, half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un234_bc34:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un234_bc34() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half undef>,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un234_bc123:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un234_bc123() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half bitcast (i16 undef to half)>,
        <2 x half> <half bitcast (i16 undef to half), half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un234_bc124:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un234_bc124() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half bitcast (i16 undef to half)>,
        <2 x half> <half undef, half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un234_bc134:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un234_bc134() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half undef>,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un234_bc234:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un234_bc234() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half bitcast (i16 undef to half)>,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un234_bc1234:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un234_bc1234() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half bitcast (i16 undef to half)>,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un1234_bc:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un1234_bc() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half undef>,
        <2 x half> <half undef, half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un1234_bc1:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un1234_bc1() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half undef>,
        <2 x half> <half undef, half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un1234_bc2:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un1234_bc2() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half bitcast (i16 undef to half)>,
        <2 x half> <half undef, half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un1234_bc3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un1234_bc3() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half undef>,
        <2 x half> <half bitcast (i16 undef to half), half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un1234_bc4:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un1234_bc4() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half undef>,
        <2 x half> <half undef, half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un1234_bc12:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un1234_bc12() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 undef to half)>,
        <2 x half> <half undef, half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un1234_bc13:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un1234_bc13() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half undef>,
        <2 x half> <half bitcast (i16 undef to half), half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un1234_bc14:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un1234_bc14() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half undef>,
        <2 x half> <half undef, half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un1234_bc23:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un1234_bc23() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half bitcast (i16 undef to half)>,
        <2 x half> <half bitcast (i16 undef to half), half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un1234_bc24:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un1234_bc24() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half bitcast (i16 undef to half)>,
        <2 x half> <half undef, half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un1234_bc34:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un1234_bc34() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half undef>,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un1234_bc123:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un1234_bc123() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 undef to half)>,
        <2 x half> <half bitcast (i16 undef to half), half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un1234_bc124:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un1234_bc124() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 undef to half)>,
        <2 x half> <half undef, half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un1234_bc134:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un1234_bc134() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half undef>,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un1234_bc234:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un1234_bc234() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half bitcast (i16 undef to half)>,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: SORT4X16HI_un1234_bc1234:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @SORT4X16HI_un1234_bc1234() {
    %id = load i32, i32* @ColossusISD_SORT4X16HI
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 undef to half)>,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un_bc:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196610
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un_bc() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half 0xH2>,
        <2 x half> <half 0xH3, half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un_bc1:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196610
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un_bc1() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half 0xH2>,
        <2 x half> <half 0xH3, half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un_bc2:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196610
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un_bc2() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half bitcast (i16 2 to half)>,
        <2 x half> <half 0xH3, half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un_bc3:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196610
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un_bc3() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half 0xH2>,
        <2 x half> <half bitcast (i16 3 to half), half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un_bc4:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196610
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un_bc4() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half 0xH2>,
        <2 x half> <half 0xH3, half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un_bc12:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196610
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un_bc12() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half bitcast (i16 2 to half)>,
        <2 x half> <half 0xH3, half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un_bc13:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196610
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un_bc13() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half 0xH2>,
        <2 x half> <half bitcast (i16 3 to half), half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un_bc14:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196610
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un_bc14() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half 0xH2>,
        <2 x half> <half 0xH3, half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un_bc23:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196610
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un_bc23() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half bitcast (i16 2 to half)>,
        <2 x half> <half bitcast (i16 3 to half), half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un_bc24:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196610
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un_bc24() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half bitcast (i16 2 to half)>,
        <2 x half> <half 0xH3, half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un_bc34:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196610
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un_bc34() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half 0xH2>,
        <2 x half> <half bitcast (i16 3 to half), half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un_bc123:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196610
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un_bc123() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half bitcast (i16 2 to half)>,
        <2 x half> <half bitcast (i16 3 to half), half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un_bc124:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196610
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un_bc124() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half bitcast (i16 2 to half)>,
        <2 x half> <half 0xH3, half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un_bc134:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196610
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un_bc134() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half 0xH2>,
        <2 x half> <half bitcast (i16 3 to half), half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un_bc234:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196610
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un_bc234() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half bitcast (i16 2 to half)>,
        <2 x half> <half bitcast (i16 3 to half), half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un_bc1234:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196610
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un_bc1234() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half bitcast (i16 2 to half)>,
        <2 x half> <half bitcast (i16 3 to half), half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un1_bc:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196610
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un1_bc() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half 0xH2>,
        <2 x half> <half 0xH3, half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un1_bc1:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196610
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un1_bc1() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half 0xH2>,
        <2 x half> <half 0xH3, half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un1_bc2:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196610
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un1_bc2() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half bitcast (i16 2 to half)>,
        <2 x half> <half 0xH3, half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un1_bc3:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196610
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un1_bc3() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half 0xH2>,
        <2 x half> <half bitcast (i16 3 to half), half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un1_bc4:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196610
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un1_bc4() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half 0xH2>,
        <2 x half> <half 0xH3, half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un1_bc12:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196610
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un1_bc12() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 2 to half)>,
        <2 x half> <half 0xH3, half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un1_bc13:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196610
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un1_bc13() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half 0xH2>,
        <2 x half> <half bitcast (i16 3 to half), half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un1_bc14:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196610
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un1_bc14() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half 0xH2>,
        <2 x half> <half 0xH3, half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un1_bc23:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196610
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un1_bc23() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half bitcast (i16 2 to half)>,
        <2 x half> <half bitcast (i16 3 to half), half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un1_bc24:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196610
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un1_bc24() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half bitcast (i16 2 to half)>,
        <2 x half> <half 0xH3, half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un1_bc34:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196610
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un1_bc34() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half 0xH2>,
        <2 x half> <half bitcast (i16 3 to half), half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un1_bc123:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196610
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un1_bc123() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 2 to half)>,
        <2 x half> <half bitcast (i16 3 to half), half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un1_bc124:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196610
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un1_bc124() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 2 to half)>,
        <2 x half> <half 0xH3, half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un1_bc134:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196610
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un1_bc134() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half 0xH2>,
        <2 x half> <half bitcast (i16 3 to half), half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un1_bc234:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196610
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un1_bc234() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half bitcast (i16 2 to half)>,
        <2 x half> <half bitcast (i16 3 to half), half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un1_bc1234:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196610
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un1_bc1234() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 2 to half)>,
        <2 x half> <half bitcast (i16 3 to half), half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un2_bc:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un2_bc() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half undef>,
        <2 x half> <half 0xH3, half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un2_bc1:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un2_bc1() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half undef>,
        <2 x half> <half 0xH3, half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un2_bc2:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un2_bc2() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half bitcast (i16 undef to half)>,
        <2 x half> <half 0xH3, half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un2_bc3:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un2_bc3() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half undef>,
        <2 x half> <half bitcast (i16 3 to half), half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un2_bc4:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un2_bc4() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half undef>,
        <2 x half> <half 0xH3, half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un2_bc12:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un2_bc12() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half bitcast (i16 undef to half)>,
        <2 x half> <half 0xH3, half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un2_bc13:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un2_bc13() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half undef>,
        <2 x half> <half bitcast (i16 3 to half), half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un2_bc14:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un2_bc14() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half undef>,
        <2 x half> <half 0xH3, half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un2_bc23:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un2_bc23() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half bitcast (i16 undef to half)>,
        <2 x half> <half bitcast (i16 3 to half), half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un2_bc24:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un2_bc24() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half bitcast (i16 undef to half)>,
        <2 x half> <half 0xH3, half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un2_bc34:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un2_bc34() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half undef>,
        <2 x half> <half bitcast (i16 3 to half), half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un2_bc123:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un2_bc123() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half bitcast (i16 undef to half)>,
        <2 x half> <half bitcast (i16 3 to half), half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un2_bc124:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un2_bc124() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half bitcast (i16 undef to half)>,
        <2 x half> <half 0xH3, half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un2_bc134:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un2_bc134() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half undef>,
        <2 x half> <half bitcast (i16 3 to half), half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un2_bc234:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un2_bc234() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half bitcast (i16 undef to half)>,
        <2 x half> <half bitcast (i16 3 to half), half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un2_bc1234:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un2_bc1234() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half bitcast (i16 undef to half)>,
        <2 x half> <half bitcast (i16 3 to half), half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un3_bc:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un3_bc() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half 0xH2>,
        <2 x half> <half undef, half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un3_bc1:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un3_bc1() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half 0xH2>,
        <2 x half> <half undef, half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un3_bc2:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un3_bc2() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half bitcast (i16 2 to half)>,
        <2 x half> <half undef, half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un3_bc3:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un3_bc3() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half 0xH2>,
        <2 x half> <half bitcast (i16 undef to half), half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un3_bc4:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un3_bc4() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half 0xH2>,
        <2 x half> <half undef, half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un3_bc12:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un3_bc12() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half bitcast (i16 2 to half)>,
        <2 x half> <half undef, half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un3_bc13:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un3_bc13() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half 0xH2>,
        <2 x half> <half bitcast (i16 undef to half), half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un3_bc14:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un3_bc14() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half 0xH2>,
        <2 x half> <half undef, half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un3_bc23:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un3_bc23() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half bitcast (i16 2 to half)>,
        <2 x half> <half bitcast (i16 undef to half), half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un3_bc24:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un3_bc24() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half bitcast (i16 2 to half)>,
        <2 x half> <half undef, half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un3_bc34:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un3_bc34() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half 0xH2>,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un3_bc123:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un3_bc123() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half bitcast (i16 2 to half)>,
        <2 x half> <half bitcast (i16 undef to half), half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un3_bc124:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un3_bc124() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half bitcast (i16 2 to half)>,
        <2 x half> <half undef, half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un3_bc134:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un3_bc134() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half 0xH2>,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un3_bc234:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un3_bc234() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half bitcast (i16 2 to half)>,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un3_bc1234:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un3_bc1234() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half bitcast (i16 2 to half)>,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un4_bc:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196610
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un4_bc() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half 0xH2>,
        <2 x half> <half 0xH3, half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un4_bc1:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196610
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un4_bc1() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half 0xH2>,
        <2 x half> <half 0xH3, half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un4_bc2:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196610
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un4_bc2() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half bitcast (i16 2 to half)>,
        <2 x half> <half 0xH3, half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un4_bc3:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196610
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un4_bc3() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half 0xH2>,
        <2 x half> <half bitcast (i16 3 to half), half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un4_bc4:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196610
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un4_bc4() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half 0xH2>,
        <2 x half> <half 0xH3, half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un4_bc12:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196610
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un4_bc12() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half bitcast (i16 2 to half)>,
        <2 x half> <half 0xH3, half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un4_bc13:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196610
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un4_bc13() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half 0xH2>,
        <2 x half> <half bitcast (i16 3 to half), half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un4_bc14:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196610
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un4_bc14() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half 0xH2>,
        <2 x half> <half 0xH3, half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un4_bc23:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196610
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un4_bc23() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half bitcast (i16 2 to half)>,
        <2 x half> <half bitcast (i16 3 to half), half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un4_bc24:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196610
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un4_bc24() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half bitcast (i16 2 to half)>,
        <2 x half> <half 0xH3, half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un4_bc34:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196610
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un4_bc34() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half 0xH2>,
        <2 x half> <half bitcast (i16 3 to half), half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un4_bc123:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196610
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un4_bc123() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half bitcast (i16 2 to half)>,
        <2 x half> <half bitcast (i16 3 to half), half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un4_bc124:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196610
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un4_bc124() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half bitcast (i16 2 to half)>,
        <2 x half> <half 0xH3, half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un4_bc134:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196610
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un4_bc134() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half 0xH2>,
        <2 x half> <half bitcast (i16 3 to half), half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un4_bc234:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196610
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un4_bc234() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half bitcast (i16 2 to half)>,
        <2 x half> <half bitcast (i16 3 to half), half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un4_bc1234:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196610
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un4_bc1234() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half bitcast (i16 2 to half)>,
        <2 x half> <half bitcast (i16 3 to half), half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un12_bc:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un12_bc() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half undef>,
        <2 x half> <half 0xH3, half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un12_bc1:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un12_bc1() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half undef>,
        <2 x half> <half 0xH3, half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un12_bc2:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un12_bc2() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half bitcast (i16 undef to half)>,
        <2 x half> <half 0xH3, half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un12_bc3:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un12_bc3() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half undef>,
        <2 x half> <half bitcast (i16 3 to half), half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un12_bc4:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un12_bc4() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half undef>,
        <2 x half> <half 0xH3, half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un12_bc12:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un12_bc12() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 undef to half)>,
        <2 x half> <half 0xH3, half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un12_bc13:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un12_bc13() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half undef>,
        <2 x half> <half bitcast (i16 3 to half), half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un12_bc14:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un12_bc14() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half undef>,
        <2 x half> <half 0xH3, half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un12_bc23:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un12_bc23() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half bitcast (i16 undef to half)>,
        <2 x half> <half bitcast (i16 3 to half), half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un12_bc24:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un12_bc24() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half bitcast (i16 undef to half)>,
        <2 x half> <half 0xH3, half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un12_bc34:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un12_bc34() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half undef>,
        <2 x half> <half bitcast (i16 3 to half), half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un12_bc123:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un12_bc123() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 undef to half)>,
        <2 x half> <half bitcast (i16 3 to half), half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un12_bc124:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un12_bc124() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 undef to half)>,
        <2 x half> <half 0xH3, half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un12_bc134:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un12_bc134() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half undef>,
        <2 x half> <half bitcast (i16 3 to half), half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un12_bc234:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un12_bc234() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half bitcast (i16 undef to half)>,
        <2 x half> <half bitcast (i16 3 to half), half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un12_bc1234:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un12_bc1234() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 undef to half)>,
        <2 x half> <half bitcast (i16 3 to half), half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un13_bc:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un13_bc() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half 0xH2>,
        <2 x half> <half undef, half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un13_bc1:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un13_bc1() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half 0xH2>,
        <2 x half> <half undef, half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un13_bc2:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un13_bc2() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half bitcast (i16 2 to half)>,
        <2 x half> <half undef, half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un13_bc3:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un13_bc3() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half 0xH2>,
        <2 x half> <half bitcast (i16 undef to half), half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un13_bc4:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un13_bc4() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half 0xH2>,
        <2 x half> <half undef, half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un13_bc12:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un13_bc12() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 2 to half)>,
        <2 x half> <half undef, half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un13_bc13:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un13_bc13() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half 0xH2>,
        <2 x half> <half bitcast (i16 undef to half), half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un13_bc14:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un13_bc14() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half 0xH2>,
        <2 x half> <half undef, half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un13_bc23:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un13_bc23() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half bitcast (i16 2 to half)>,
        <2 x half> <half bitcast (i16 undef to half), half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un13_bc24:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un13_bc24() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half bitcast (i16 2 to half)>,
        <2 x half> <half undef, half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un13_bc34:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un13_bc34() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half 0xH2>,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un13_bc123:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un13_bc123() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 2 to half)>,
        <2 x half> <half bitcast (i16 undef to half), half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un13_bc124:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un13_bc124() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 2 to half)>,
        <2 x half> <half undef, half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un13_bc134:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un13_bc134() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half 0xH2>,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un13_bc234:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un13_bc234() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half bitcast (i16 2 to half)>,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un13_bc1234:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un13_bc1234() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 2 to half)>,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un14_bc:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196610
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un14_bc() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half 0xH2>,
        <2 x half> <half 0xH3, half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un14_bc1:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196610
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un14_bc1() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half 0xH2>,
        <2 x half> <half 0xH3, half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un14_bc2:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196610
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un14_bc2() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half bitcast (i16 2 to half)>,
        <2 x half> <half 0xH3, half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un14_bc3:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196610
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un14_bc3() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half 0xH2>,
        <2 x half> <half bitcast (i16 3 to half), half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un14_bc4:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196610
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un14_bc4() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half 0xH2>,
        <2 x half> <half 0xH3, half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un14_bc12:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196610
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un14_bc12() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 2 to half)>,
        <2 x half> <half 0xH3, half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un14_bc13:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196610
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un14_bc13() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half 0xH2>,
        <2 x half> <half bitcast (i16 3 to half), half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un14_bc14:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196610
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un14_bc14() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half 0xH2>,
        <2 x half> <half 0xH3, half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un14_bc23:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196610
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un14_bc23() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half bitcast (i16 2 to half)>,
        <2 x half> <half bitcast (i16 3 to half), half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un14_bc24:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196610
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un14_bc24() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half bitcast (i16 2 to half)>,
        <2 x half> <half 0xH3, half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un14_bc34:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196610
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un14_bc34() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half 0xH2>,
        <2 x half> <half bitcast (i16 3 to half), half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un14_bc123:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196610
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un14_bc123() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 2 to half)>,
        <2 x half> <half bitcast (i16 3 to half), half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un14_bc124:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196610
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un14_bc124() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 2 to half)>,
        <2 x half> <half 0xH3, half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un14_bc134:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196610
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un14_bc134() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half 0xH2>,
        <2 x half> <half bitcast (i16 3 to half), half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un14_bc234:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196610
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un14_bc234() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half bitcast (i16 2 to half)>,
        <2 x half> <half bitcast (i16 3 to half), half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un14_bc1234:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196610
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un14_bc1234() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 2 to half)>,
        <2 x half> <half bitcast (i16 3 to half), half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un23_bc:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un23_bc() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half undef>,
        <2 x half> <half undef, half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un23_bc1:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un23_bc1() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half undef>,
        <2 x half> <half undef, half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un23_bc2:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un23_bc2() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half bitcast (i16 undef to half)>,
        <2 x half> <half undef, half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un23_bc3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un23_bc3() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half undef>,
        <2 x half> <half bitcast (i16 undef to half), half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un23_bc4:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un23_bc4() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half undef>,
        <2 x half> <half undef, half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un23_bc12:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un23_bc12() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half bitcast (i16 undef to half)>,
        <2 x half> <half undef, half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un23_bc13:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un23_bc13() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half undef>,
        <2 x half> <half bitcast (i16 undef to half), half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un23_bc14:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un23_bc14() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half undef>,
        <2 x half> <half undef, half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un23_bc23:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un23_bc23() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half bitcast (i16 undef to half)>,
        <2 x half> <half bitcast (i16 undef to half), half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un23_bc24:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un23_bc24() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half bitcast (i16 undef to half)>,
        <2 x half> <half undef, half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un23_bc34:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un23_bc34() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half undef>,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un23_bc123:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un23_bc123() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half bitcast (i16 undef to half)>,
        <2 x half> <half bitcast (i16 undef to half), half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un23_bc124:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un23_bc124() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half bitcast (i16 undef to half)>,
        <2 x half> <half undef, half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un23_bc134:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un23_bc134() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half undef>,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un23_bc234:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un23_bc234() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half bitcast (i16 undef to half)>,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un23_bc1234:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un23_bc1234() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half bitcast (i16 undef to half)>,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un24_bc:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un24_bc() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half undef>,
        <2 x half> <half 0xH3, half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un24_bc1:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un24_bc1() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half undef>,
        <2 x half> <half 0xH3, half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un24_bc2:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un24_bc2() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half bitcast (i16 undef to half)>,
        <2 x half> <half 0xH3, half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un24_bc3:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un24_bc3() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half undef>,
        <2 x half> <half bitcast (i16 3 to half), half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un24_bc4:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un24_bc4() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half undef>,
        <2 x half> <half 0xH3, half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un24_bc12:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un24_bc12() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half bitcast (i16 undef to half)>,
        <2 x half> <half 0xH3, half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un24_bc13:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un24_bc13() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half undef>,
        <2 x half> <half bitcast (i16 3 to half), half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un24_bc14:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un24_bc14() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half undef>,
        <2 x half> <half 0xH3, half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un24_bc23:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un24_bc23() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half bitcast (i16 undef to half)>,
        <2 x half> <half bitcast (i16 3 to half), half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un24_bc24:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un24_bc24() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half bitcast (i16 undef to half)>,
        <2 x half> <half 0xH3, half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un24_bc34:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un24_bc34() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half undef>,
        <2 x half> <half bitcast (i16 3 to half), half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un24_bc123:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un24_bc123() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half bitcast (i16 undef to half)>,
        <2 x half> <half bitcast (i16 3 to half), half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un24_bc124:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un24_bc124() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half bitcast (i16 undef to half)>,
        <2 x half> <half 0xH3, half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un24_bc134:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un24_bc134() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half undef>,
        <2 x half> <half bitcast (i16 3 to half), half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un24_bc234:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un24_bc234() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half bitcast (i16 undef to half)>,
        <2 x half> <half bitcast (i16 3 to half), half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un24_bc1234:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un24_bc1234() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half bitcast (i16 undef to half)>,
        <2 x half> <half bitcast (i16 3 to half), half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un34_bc:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un34_bc() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half 0xH2>,
        <2 x half> <half undef, half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un34_bc1:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un34_bc1() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half 0xH2>,
        <2 x half> <half undef, half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un34_bc2:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un34_bc2() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half bitcast (i16 2 to half)>,
        <2 x half> <half undef, half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un34_bc3:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un34_bc3() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half 0xH2>,
        <2 x half> <half bitcast (i16 undef to half), half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un34_bc4:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un34_bc4() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half 0xH2>,
        <2 x half> <half undef, half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un34_bc12:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un34_bc12() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half bitcast (i16 2 to half)>,
        <2 x half> <half undef, half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un34_bc13:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un34_bc13() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half 0xH2>,
        <2 x half> <half bitcast (i16 undef to half), half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un34_bc14:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un34_bc14() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half 0xH2>,
        <2 x half> <half undef, half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un34_bc23:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un34_bc23() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half bitcast (i16 2 to half)>,
        <2 x half> <half bitcast (i16 undef to half), half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un34_bc24:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un34_bc24() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half bitcast (i16 2 to half)>,
        <2 x half> <half undef, half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un34_bc34:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un34_bc34() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half 0xH2>,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un34_bc123:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un34_bc123() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half bitcast (i16 2 to half)>,
        <2 x half> <half bitcast (i16 undef to half), half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un34_bc124:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un34_bc124() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half bitcast (i16 2 to half)>,
        <2 x half> <half undef, half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un34_bc134:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un34_bc134() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half 0xH2>,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un34_bc234:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un34_bc234() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half bitcast (i16 2 to half)>,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un34_bc1234:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un34_bc1234() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half bitcast (i16 2 to half)>,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un123_bc:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un123_bc() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half undef>,
        <2 x half> <half undef, half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un123_bc1:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un123_bc1() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half undef>,
        <2 x half> <half undef, half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un123_bc2:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un123_bc2() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half bitcast (i16 undef to half)>,
        <2 x half> <half undef, half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un123_bc3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un123_bc3() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half undef>,
        <2 x half> <half bitcast (i16 undef to half), half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un123_bc4:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un123_bc4() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half undef>,
        <2 x half> <half undef, half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un123_bc12:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un123_bc12() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 undef to half)>,
        <2 x half> <half undef, half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un123_bc13:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un123_bc13() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half undef>,
        <2 x half> <half bitcast (i16 undef to half), half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un123_bc14:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un123_bc14() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half undef>,
        <2 x half> <half undef, half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un123_bc23:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un123_bc23() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half bitcast (i16 undef to half)>,
        <2 x half> <half bitcast (i16 undef to half), half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un123_bc24:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un123_bc24() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half bitcast (i16 undef to half)>,
        <2 x half> <half undef, half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un123_bc34:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un123_bc34() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half undef>,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un123_bc123:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un123_bc123() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 undef to half)>,
        <2 x half> <half bitcast (i16 undef to half), half 0xH4>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un123_bc124:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un123_bc124() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 undef to half)>,
        <2 x half> <half undef, half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un123_bc134:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un123_bc134() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half undef>,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un123_bc234:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un123_bc234() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half bitcast (i16 undef to half)>,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un123_bc1234:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un123_bc1234() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 undef to half)>,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 4 to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un124_bc:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un124_bc() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half undef>,
        <2 x half> <half 0xH3, half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un124_bc1:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un124_bc1() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half undef>,
        <2 x half> <half 0xH3, half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un124_bc2:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un124_bc2() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half bitcast (i16 undef to half)>,
        <2 x half> <half 0xH3, half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un124_bc3:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un124_bc3() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half undef>,
        <2 x half> <half bitcast (i16 3 to half), half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un124_bc4:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un124_bc4() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half undef>,
        <2 x half> <half 0xH3, half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un124_bc12:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un124_bc12() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 undef to half)>,
        <2 x half> <half 0xH3, half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un124_bc13:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un124_bc13() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half undef>,
        <2 x half> <half bitcast (i16 3 to half), half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un124_bc14:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un124_bc14() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half undef>,
        <2 x half> <half 0xH3, half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un124_bc23:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un124_bc23() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half bitcast (i16 undef to half)>,
        <2 x half> <half bitcast (i16 3 to half), half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un124_bc24:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un124_bc24() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half bitcast (i16 undef to half)>,
        <2 x half> <half 0xH3, half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un124_bc34:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un124_bc34() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half undef>,
        <2 x half> <half bitcast (i16 3 to half), half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un124_bc123:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un124_bc123() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 undef to half)>,
        <2 x half> <half bitcast (i16 3 to half), half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un124_bc124:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un124_bc124() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 undef to half)>,
        <2 x half> <half 0xH3, half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un124_bc134:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un124_bc134() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half undef>,
        <2 x half> <half bitcast (i16 3 to half), half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un124_bc234:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un124_bc234() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half bitcast (i16 undef to half)>,
        <2 x half> <half bitcast (i16 3 to half), half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un124_bc1234:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 196608
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un124_bc1234() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 undef to half)>,
        <2 x half> <half bitcast (i16 3 to half), half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un134_bc:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un134_bc() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half 0xH2>,
        <2 x half> <half undef, half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un134_bc1:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un134_bc1() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half 0xH2>,
        <2 x half> <half undef, half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un134_bc2:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un134_bc2() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half bitcast (i16 2 to half)>,
        <2 x half> <half undef, half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un134_bc3:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un134_bc3() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half 0xH2>,
        <2 x half> <half bitcast (i16 undef to half), half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un134_bc4:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un134_bc4() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half 0xH2>,
        <2 x half> <half undef, half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un134_bc12:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un134_bc12() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 2 to half)>,
        <2 x half> <half undef, half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un134_bc13:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un134_bc13() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half 0xH2>,
        <2 x half> <half bitcast (i16 undef to half), half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un134_bc14:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un134_bc14() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half 0xH2>,
        <2 x half> <half undef, half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un134_bc23:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un134_bc23() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half bitcast (i16 2 to half)>,
        <2 x half> <half bitcast (i16 undef to half), half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un134_bc24:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un134_bc24() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half bitcast (i16 2 to half)>,
        <2 x half> <half undef, half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un134_bc34:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un134_bc34() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half 0xH2>,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un134_bc123:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un134_bc123() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 2 to half)>,
        <2 x half> <half bitcast (i16 undef to half), half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un134_bc124:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un134_bc124() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 2 to half)>,
        <2 x half> <half undef, half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un134_bc134:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un134_bc134() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half 0xH2>,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un134_bc234:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un134_bc234() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half bitcast (i16 2 to half)>,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un134_bc1234:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $a0, 2
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un134_bc1234() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 2 to half)>,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un234_bc:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un234_bc() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half undef>,
        <2 x half> <half undef, half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un234_bc1:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un234_bc1() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half undef>,
        <2 x half> <half undef, half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un234_bc2:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un234_bc2() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half bitcast (i16 undef to half)>,
        <2 x half> <half undef, half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un234_bc3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un234_bc3() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half undef>,
        <2 x half> <half bitcast (i16 undef to half), half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un234_bc4:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un234_bc4() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half undef>,
        <2 x half> <half undef, half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un234_bc12:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un234_bc12() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half bitcast (i16 undef to half)>,
        <2 x half> <half undef, half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un234_bc13:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un234_bc13() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half undef>,
        <2 x half> <half bitcast (i16 undef to half), half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un234_bc14:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un234_bc14() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half undef>,
        <2 x half> <half undef, half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un234_bc23:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un234_bc23() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half bitcast (i16 undef to half)>,
        <2 x half> <half bitcast (i16 undef to half), half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un234_bc24:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un234_bc24() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half bitcast (i16 undef to half)>,
        <2 x half> <half undef, half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un234_bc34:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un234_bc34() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half undef>,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un234_bc123:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un234_bc123() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half bitcast (i16 undef to half)>,
        <2 x half> <half bitcast (i16 undef to half), half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un234_bc124:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un234_bc124() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half bitcast (i16 undef to half)>,
        <2 x half> <half undef, half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un234_bc134:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un234_bc134() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half undef>,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un234_bc234:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un234_bc234() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half 0xH1, half bitcast (i16 undef to half)>,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un234_bc1234:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un234_bc1234() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 1 to half), half bitcast (i16 undef to half)>,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un1234_bc:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un1234_bc() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half undef>,
        <2 x half> <half undef, half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un1234_bc1:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un1234_bc1() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half undef>,
        <2 x half> <half undef, half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un1234_bc2:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un1234_bc2() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half bitcast (i16 undef to half)>,
        <2 x half> <half undef, half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un1234_bc3:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un1234_bc3() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half undef>,
        <2 x half> <half bitcast (i16 undef to half), half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un1234_bc4:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un1234_bc4() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half undef>,
        <2 x half> <half undef, half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un1234_bc12:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un1234_bc12() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 undef to half)>,
        <2 x half> <half undef, half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un1234_bc13:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un1234_bc13() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half undef>,
        <2 x half> <half bitcast (i16 undef to half), half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un1234_bc14:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un1234_bc14() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half undef>,
        <2 x half> <half undef, half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un1234_bc23:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un1234_bc23() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half bitcast (i16 undef to half)>,
        <2 x half> <half bitcast (i16 undef to half), half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un1234_bc24:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un1234_bc24() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half bitcast (i16 undef to half)>,
        <2 x half> <half undef, half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un1234_bc34:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un1234_bc34() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half undef>,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un1234_bc123:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un1234_bc123() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 undef to half)>,
        <2 x half> <half bitcast (i16 undef to half), half undef>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un1234_bc124:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un1234_bc124() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 undef to half)>,
        <2 x half> <half undef, half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un1234_bc134:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un1234_bc134() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half undef>,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un1234_bc234:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un1234_bc234() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half undef, half bitcast (i16 undef to half)>,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

; CHECK-LABEL: ROLL16_un1234_bc1234:
; CHECK:       # %bb
; CHECK-NOT:   $a
; CHECK-NEXT:  br $m10
define <2 x half> @ROLL16_un1234_bc1234() {
    %id = load i32, i32* @ColossusISD_ROLL16
    %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16(
        i32 %id,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 undef to half)>,
        <2 x half> <half bitcast (i16 undef to half), half bitcast (i16 undef to half)>
    )
    ret <2 x half> %res
}

