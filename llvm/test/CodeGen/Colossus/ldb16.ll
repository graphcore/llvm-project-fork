; RUN: llvm-link %isdopc %s | opt -instcombine -always-inline -mattr=+ipu1 | llc -march=colossus -colossus-coissue=false -mattr=+ipu1 | FileCheck %s
; RUN: llvm-link %isdopc %s | opt -instcombine -always-inline -mattr=+ipu2 | llc -march=colossus -colossus-coissue=false -mattr=+ipu2 | FileCheck %s

; Uses SORT4X16LO instead of insertelement to broadcast the scalar. This avoids
; an upstream optimisation in LowerFormalArguments, see T3117 for details
; This allows these tests to be more focussed on the specific lowering sequence.

@ColossusISD_F16ASV2F16 = external constant i32
@ColossusISD_SORT4X16LO = external constant i32
declare <2 x half> @llvm.colossus.SDAG.binary.v2f16.v2f16.v2f16(i32, <2 x half>, <2 x half>)
declare <2 x half> @llvm.colossus.SDAG.unary.v2f16.f16(i32, half)
define internal <2 x half> @broadcast_f16(half %x) #0 {
   %bc = load i32, i32* @ColossusISD_F16ASV2F16
   %wider = call <2 x half> @llvm.colossus.SDAG.unary.v2f16.f16(i32 %bc, half %x)
   %id = load i32, i32* @ColossusISD_SORT4X16LO
   %res = call <2 x half> @llvm.colossus.SDAG.binary.v2f16.v2f16.v2f16(i32 %id, <2 x half> %wider, <2 x half> %wider)
   ret <2 x half> %res
}
declare {half, half*} @llvm.colossus.ldstep.f16(half*, i32)
attributes #0 = {alwaysinline}

; CHECK-LABEL: load_then_return_as_v2f16:
; CHECK:       # %bb
; CHECK-NEXT:  ldb16 $a0, $m0, $m15, 0
; CHECK-NEXT:  br $m10
define <2 x half> @load_then_return_as_v2f16(half * %px) {
  %x = load half, half* %px
  %res1 = insertelement <2 x half> undef, half %x, i32 0
  %res2 = insertelement <2 x half> %res1, half %x, i32 1
  ret <2 x half> %res2
}

; CHECK-LABEL: loadstep_then_return_as_v2f16:
; CHECK:       # %bb
; CHECK-NEXT:  ldb16step $a0, $m15, $m0+=, 42
; CHECK-NEXT:  br $m10
define <2 x half> @loadstep_then_return_as_v2f16(half * %px) {
  %ldx = call {half, half*} @llvm.colossus.ldstep.f16(half* %px, i32 42)
  %x = extractvalue { half, half* } %ldx, 0
  %res1 = insertelement <2 x half> undef, half %x, i32 0
  %res2 = insertelement <2 x half> %res1, half %x, i32 1
  ret <2 x half> %res2
}

; CHECK-LABEL: load_then_add:
; CHECK:       # %bb
; CHECK-DAG:   ldb16 [[A0:\$a[0-9]+]], $m0, $m15, 0
; CHECK-DAG:   ldb16 [[A1:\$a[0-9]+]], $m1, $m15, 0
; CHECK-NEXT:  f16v2add $a0, [[A0]], [[A1]]
; CHECK-NEXT:  br $m10
define <2 x half> @load_then_add(half* %px, half* %py) {
  %x = load half, half* %px
  %x2 = call <2 x half> @broadcast_f16(half %x)
  %y = load half, half* %py
  %y2 = call <2 x half> @broadcast_f16(half %y)
  %add = fadd <2 x half> %x2, %y2
  ret <2 x half> %add
}

; CHECK-LABEL: loadstep_then_add:
; CHECK:       # %bb
; CHECK-DAG:   ldb16step [[A0:\$a[0-9]+]], $m15, $m0+=, 1
; CHECK-DAG:   ldb16step [[A1:\$a[0-9]+]], $m15, $m1+=, 2
; CHECK-NEXT:  f16v2add $a0, [[A0]], [[A1]]
; CHECK-NEXT:  br $m10
define <2 x half> @loadstep_then_add(half* %px, half* %py) {
  %ldx = call {half, half*} @llvm.colossus.ldstep.f16(half* %px, i32 1)
  %x = extractvalue { half, half* } %ldx, 0
  %x2 = call <2 x half> @broadcast_f16(half %x)
  %ldy = call {half, half*} @llvm.colossus.ldstep.f16(half* %py, i32 2)
  %y = extractvalue { half, half* } %ldy, 0
  %y2 = call <2 x half> @broadcast_f16(half %y)
  %add = fadd <2 x half> %x2, %y2
  ret <2 x half> %add
}

; CHECK-LABEL: load_offset_then_add:
; CHECK:       # %bb
; CHECK-DAG:   ldb16 [[A1:\$a[0-9]+]], $m0, $m15, $m1
; CHECK-DAG:   ldb16 [[A0:\$a[0-9]+]], $m2, $m15, $m3
; CHECK-NEXT:  f16v2add $a0, [[A1]], [[A0]]
; CHECK-NEXT:  br $m10
define <2 x half> @load_offset_then_add(half* %px, i32 %ox, half* %py, i32 %oy) {
  %ix = getelementptr inbounds half, half* %px, i32 %ox
  %x = load half, half* %ix
  %x2 = call <2 x half> @broadcast_f16(half %x)
  %iy = getelementptr inbounds half, half* %py, i32 %oy
  %y = load half, half* %iy
  %y2 = call <2 x half> @broadcast_f16(half %y)
  %add = fadd <2 x half> %x2, %y2
  ret <2 x half> %add
}

; ldstep with nonzero offset is unimplemented. See T5900

; Check the interaction between ldb16 and broadcast arithmetic. Specifically,
; it is better to sink the broadcast into the ldb16 than into the arithmetic
; in case the other argument to the arithmetic also benefits from broadcast

; CHECK-LABEL: broadcast_load_and_scalar:
; CHECK:       # %bb
; CHECK-NEXT:  ldb16 [[A1:\$a[1-9]+]], $m0, $m15, 0
; CHECK-NEXT:  f16v2add $a0, $a0:BL, [[A1]]
; CHECK-NEXT:  br $m10
define <2 x half> @broadcast_load_and_scalar(half* %px, half %y) {
  %x = load half, half* %px
  %x2 = call <2 x half> @broadcast_f16(half %x)
  %y2 = call <2 x half> @broadcast_f16(half %y)
  %add = fadd <2 x half> %x2, %y2
  ret <2 x half> %add
}

; CHECK-LABEL: broadcast_loadstep_and_scalar:
; CHECK:       # %bb
; CHECK-DAG:   ldb16step [[A1:\$a[1-9]+]], $m15, $m0+=, 1
; CHECK-NEXT:  f16v2add $a0, $a0:BL, [[A1]]
; CHECK-NEXT:  br $m10
define <2 x half> @broadcast_loadstep_and_scalar(half* %px, half %y) {
  %ldx = call {half, half*} @llvm.colossus.ldstep.f16(half* %px, i32 1)
  %x = extractvalue { half, half* } %ldx, 0
  %x2 = call <2 x half> @broadcast_f16(half %x)
  %y2 = call <2 x half> @broadcast_f16(half %y)
  %add = fadd <2 x half> %x2, %y2
  ret <2 x half> %add
}

; CHECK-LABEL: broadcast_scalar_and_load:
; CHECK:       # %bb
; CHECK-NEXT:  ldb16 [[A1:\$a[1-9]+]], $m0, $m15, 0
; CHECK-NEXT:  f16v2add $a0, $a0:BL, [[A1]]
; CHECK-NEXT:  br $m10
define <2 x half> @broadcast_scalar_and_load(half %x, half* %py) {
  %x2 = call <2 x half> @broadcast_f16(half %x)
  %y = load half, half* %py
  %y2 = call <2 x half> @broadcast_f16(half %y)
  %add = fadd <2 x half> %x2, %y2
  ret <2 x half> %add
}

; CHECK-LABEL: broadcast_scalar_and_loadstep:
; CHECK:       # %bb
; CHECK-DAG:   ldb16step [[A1:\$a[1-9]+]], $m15, $m0+=, 1
; CHECK-NEXT:  f16v2add $a0, $a0:BL, [[A1]]
; CHECK-NEXT:  br $m10
define <2 x half> @broadcast_scalar_and_loadstep(half %x, half* %py) {
  %x2 = call <2 x half> @broadcast_f16(half %x)
  %ldy = call {half, half*} @llvm.colossus.ldstep.f16(half* %py, i32 1)
  %y = extractvalue { half, half* } %ldy, 0
  %y2 = call <2 x half> @broadcast_f16(half %y)
  %add = fadd <2 x half> %x2, %y2
  ret <2 x half> %add
}
