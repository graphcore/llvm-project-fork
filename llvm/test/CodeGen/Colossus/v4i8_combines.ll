; RUN: llvm-link %isdopc %s | opt -instcombine -always-inline -mattr=+ipu1 | llc -march=colossus -colossus-coissue=false -mattr=+ipu1 | FileCheck %s
; RUN: llvm-link %isdopc %s | opt -instcombine -always-inline -mattr=+ipu2 | llc -march=colossus -colossus-coissue=false -mattr=+ipu2 | FileCheck %s

;-------------------------------------------------------------------------------
; External Definitions
;-------------------------------------------------------------------------------

declare i32 @llvm.colossus.SDAG.binary.i32(i32, i32, i32)

@ColossusISD_SORT8X8LO = external constant i32
@ColossusISD_SHUF8X8LO = external constant i32
@ColossusISD_SHUF8X8HI = external constant i32

;-------------------------------------------------------------------------------
; CHECK-LABEL: sort_shuf_combine:
; CHECK:       # %bb
; CHECK-NEXT:  br $m10
define <4 x i8> @sort_shuf_combine(<4 x i8> %val) {

  %id_sort = load i32, i32* @ColossusISD_SORT8X8LO
  %id_shufhi = load i32, i32* @ColossusISD_SHUF8X8HI
  %id_shuflo = load i32, i32* @ColossusISD_SHUF8X8LO

  %1 = bitcast <4 x i8> %val to i32
  %2 = call i32 @llvm.colossus.SDAG.binary.i32(i32 %id_shufhi, i32 %1, i32 0)
  %3 = call i32 @llvm.colossus.SDAG.binary.i32(i32 %id_shuflo, i32 %1, i32 0)
  %4 = call i32 @llvm.colossus.SDAG.binary.i32(i32 %id_sort, i32 %3, i32 %2)
  %5 = bitcast i32 %4 to <4 x i8>
  ret <4 x i8> %5
}
