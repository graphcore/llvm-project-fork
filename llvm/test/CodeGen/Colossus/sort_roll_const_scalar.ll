; RUN: llvm-link %isdopc %s | opt -instcombine -always-inline -mattr=+ipu1 | llc -march=colossus -colossus-coissue=false -mattr=+ipu1 | FileCheck %s
; RUN: llvm-link %isdopc %s | opt -instcombine -always-inline -mattr=+ipu2 | llc -march=colossus -colossus-coissue=false -mattr=+ipu2 | FileCheck %s

declare i32 @llvm.colossus.SDAG.binary.i32.i32.i32(i32, i32, i32)

@ColossusISD_SORT4X16LO = external constant i32

; CHECK-LABEL: SORT4X16LO_cu:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $m0, 65535
; CHECK-NEXT:  br $m10
define i32 @SORT4X16LO_cu() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call i32 @llvm.colossus.SDAG.binary.i32.i32.i32(
        i32 %id,
        i32 4294967295,
        i32 undef
    )
    ret i32 %res
}

; CHECK-LABEL: SORT4X16LO_uc:
; CHECK:       # %bb
; CHECK-NEXT:  setzi $m0, 983040
; CHECK-NEXT:  or $m0, $m0, 4293918720
; CHECK-NEXT:  br $m10
define i32 @SORT4X16LO_uc() {
    %id = load i32, i32* @ColossusISD_SORT4X16LO
    %res = call i32 @llvm.colossus.SDAG.binary.i32.i32.i32(
        i32 %id,
        i32 undef,
        i32 4294967295
    )
    ret i32 %res
}
