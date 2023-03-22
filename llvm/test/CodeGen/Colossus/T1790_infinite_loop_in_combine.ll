; RUN: llvm-link %isdopc %s | opt -instcombine -always-inline -mattr=+ipu1 | llc -march=colossus -colossus-coissue=false -mattr=+ipu1 | FileCheck %s
; RUN: llvm-link %isdopc %s | opt -instcombine -always-inline -mattr=+ipu2 | llc -march=colossus -colossus-coissue=false -mattr=+ipu2 | FileCheck %s

declare <2 x half> @llvm.colossus.SDAG.unary.v2f16.v2f16(i32, <2 x half>)

@ColossusISD_FNOT = external constant i32

; CHECK-LABEL:  T1790_infinite_loop_in_combine:
; CHECK:        # %bb.0:
; CHECK-NEXT:   setzi [[REGA:\$a[1-9]+]], 65537
; CHECK-NEXT:   andc [[REGB:\$a[0-9]+]], [[REGA]], $a0
; CHECK-NEXT:   mov $m0, [[REGB]]
; CHECK-NEXT:   br $m10
define <2 x i16> @T1790_infinite_loop_in_combine(<2 x half> %x) {
   %id = load i32, i32* @ColossusISD_FNOT
   %fnot = call <2 x half> @llvm.colossus.SDAG.unary.v2f16.v2f16(i32 %id, <2 x half> %x)
   %cast2 = bitcast <2 x half> %fnot to <2 x i16>
   %and = and <2 x i16> %cast2, <i16 1, i16 1>
   ret <2 x i16> %and
}
