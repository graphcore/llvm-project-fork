; RUN: llvm-link %isdopc %s | opt -instcombine -always-inline -mattr=+ipu1 | llc -march=colossus -colossus-coissue=false -mattr=+ipu1 | FileCheck %s
; RUN: llvm-link %isdopc %s | opt -instcombine -always-inline -mattr=+ipu2 | llc -march=colossus -colossus-coissue=false -mattr=+ipu2 | FileCheck %s
target triple = "colossus-graphcore--elf"

@ISD_EXTRACT_VECTOR_ELT = external constant i32
@ISD_BUILD_VECTOR = external constant i32

; Check this is not optimised to v2f16 = vector_shuffle<0,0> t16, undef:v2f16
; by reduceBuildVecToShuffle
; SelectionDAG has 14 nodes:
;   t0: ch = EntryToken
;   t2: v4f16,ch = CopyFromReg t0, Register:v4f16 %vreg0
;   t4: v4f16,ch = CopyFromReg t0, Register:v4f16 %vreg1
;   t6: f16 = extract_vector_elt t2, Constant:i32<0>
;   t8: f16 = extract_vector_elt t2, Constant:i32<2>
;   t9: v2f16 = BUILD_VECTOR t6, t8
;  t11: ch,glue = CopyToReg t0, Register:v2f16 %A0, t9
;  t12: ch = RTN t11
;  t13: ch = RTN_REG_HOLDER t12, Register:v2f16 %A0, t11:1

declare half @llvm.colossus.SDAG.binary.f16.v4f16.i32(i32, <4 x half>, i32)
declare <2 x half> @llvm.colossus.SDAG.binary.v2f16.f16.f16(i32, half, half)

; CHECK-LABEL: repro:
; CHECK:       # %bb
; CHECK-NOT:   sort4x16lo $a0, $a0, $a0
; CHECK-NEXT:  sort4x16lo $a0, $a0, $a1
; CHECK-NEXT:  br $m10
define <2 x half> @repro(<4 x half> %x, <4 x half> %y) {
  %eve = load i32, i32* @ISD_EXTRACT_VECTOR_ELT
  %bv = load i32, i32* @ISD_BUILD_VECTOR
  %t6 = call half @llvm.colossus.SDAG.binary.f16.v4f16.i32(i32 %eve, <4 x half> %x, i32 0)
  %t8 = call half @llvm.colossus.SDAG.binary.f16.v4f16.i32(i32 %eve, <4 x half> %x, i32 2)
  %t9 = call <2 x half> @llvm.colossus.SDAG.binary.v2f16.f16.f16(i32 %bv, half %t6, half %t8)
  ret <2 x half> %t9
}
