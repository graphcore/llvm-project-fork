; RUN: llvm-link %isdopc %s | opt -instcombine -always-inline -mattr=+ipu1 | llc -march=colossus -colossus-coissue=false -mattr=+ipu1 | FileCheck %s
; RUN: llvm-link %isdopc %s | opt -instcombine -always-inline -mattr=+ipu2 | llc -march=colossus -colossus-coissue=false -mattr=+ipu2 | FileCheck %s

;-------------------------------------------------------------------------------

declare i32 @llvm.colossus.SDAG.unary.i32.i32(i32, i32)

declare <2 x i16> @llvm.colossus.SDAG.binary.v2i16.v4i16.i32(
  i32, <4 x i16>, i32
)

declare <2 x i16> @llvm.colossus.SDAG.binary.v2i16.v8i16.i32(
  i32, <8 x i16>, i32
)

declare <4 x i16> @llvm.colossus.SDAG.binary.v4i16.v2i16.v2i16(
  i32, <2 x i16>, <2 x i16>
)

declare <8 x i16> @llvm.colossus.SDAG.binary.v8i16.v4i16.v4i16(
  i32, <4 x i16>, <4 x i16>
)

;-------------------------------------------------------------------------------

@ISD_CONCAT_VECTORS = external constant i32
@ISD_EXTRACT_SUBVECTOR = external constant i32

;-------------------------------------------------------------------------------
; CHECK-LABEL: subvec_concat:
; CHECK:       # %bb
; CHECK-NEXT:  ld32 $m0, $m0, $m15, 0
; CHECK-NEXT:  br $m10
define <2 x i16> @subvec_concat(<2 x i16>* %lo, <2 x i16>* %hi) {

  %id_concat = load i32, i32* @ISD_CONCAT_VECTORS
  %id_extract = load i32, i32* @ISD_EXTRACT_SUBVECTOR

  %lo_val = load <2 x i16>, <2 x i16>* %lo
  %hi_val = load <2 x i16>, <2 x i16>* %hi
  %concat = call <4 x i16> @llvm.colossus.SDAG.binary.v4i16.v2i16.v2i16(
    i32 %id_concat, <2 x i16> %lo_val, <2 x i16> %hi_val
  )
  %extract = call <2 x i16> @llvm.colossus.SDAG.binary.v2i16.v4i16.i32(
    i32 %id_extract, <4 x i16> %concat, i32 0
  )
  ret <2 x i16> %extract
}

;-------------------------------------------------------------------------------
; CHECK-LABEL: subvec_colossus_concat:
; CHECK:       # %bb
; CHECK-NEXT:  ld32 $m0, $m0, $m15, 0
; CHECK-NEXT:  br $m10
define <2 x i16> @subvec_colossus_concat(<4 x i16>* %lo, <4 x i16>* %hi) {

  %id_concat = load i32, i32* @ISD_CONCAT_VECTORS
  %id_extract = load i32, i32* @ISD_EXTRACT_SUBVECTOR

  %lo_val = load <4 x i16>, <4 x i16>* %lo
  %hi_val = load <4 x i16>, <4 x i16>* %hi
  %concat = call <8 x i16> @llvm.colossus.SDAG.binary.v8i16.v4i16.v4i16(
    i32 %id_concat, <4 x i16> %lo_val, <4 x i16> %hi_val
  )
  %extract = call <2 x i16> @llvm.colossus.SDAG.binary.v2i16.v8i16.i32(
    i32 %id_extract, <8 x i16> %concat, i32 0
  )
  ret <2 x i16> %extract
}
