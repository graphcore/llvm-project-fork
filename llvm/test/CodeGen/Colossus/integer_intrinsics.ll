; RUN: llc < %s -mtriple=colossus -colossus-coissue=false -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -mtriple=colossus -colossus-coissue=false -mattr=+ipu2 | FileCheck %s


target triple = "colossus-graphcore--elf"

; Bitreverse and bswap are documented for scalar types

; CHECK-LABEL: call_bswap:
; CHECK:       # %bb
; CHECK-NEXT:  swap8 $m0, $m0
; CHECK-NEXT:  swap16 $m0, $m0
; CHECK-NEXT:  br $m10
declare i32 @llvm.bswap.i32(i32)
define i32 @call_bswap(i32 %x) {
  %res = call i32 @llvm.bswap.i32(i32 %x)
  ret i32 %res
}

; CHECK-LABEL: call_bitreverse:
; CHECK:       # %bb
; CHECK-NEXT:  bitrev8 $m0, $m0
; CHECK-NEXT:  swap8 $m0, $m0
; CHECK-NEXT:  swap16 $m0, $m0
; CHECK-NEXT:  br $m10
declare i32 @llvm.bitreverse.i32(i32)
define i32 @call_bitreverse(i32 %x) {
  %res = call i32 @llvm.bitreverse.i32(i32 %x)
  ret i32 %res
}

; Popcount is defined on scalar and vector types
; CHECK-LABEL: call_ctpop_i32:
; CHECK:       # %bb
; CHECK-NEXT:  popc $m0, $m0
; CHECK-NEXT:  br $m10
declare i32 @llvm.ctpop.i32(i32)
define i32 @call_ctpop_i32(i32 %x) {
  %res = call i32 @llvm.ctpop.i32(i32 %x)
  ret i32 %res
}

; CHECK-LABEL: call_ctpop_v2i32:
; CHECK:       # %bb
; CHECK-DAG:   popc $m0, $m0
; CHECK-DAG:   popc $m1, $m1
; CHECK-NEXT:  br $m10
declare <2 x i32> @llvm.ctpop.v2i32(<2 x i32>)
define <2 x i32> @call_ctpop_v2i32(<2 x i32> %x) {
  %res = call <2 x i32> @llvm.ctpop.v2i32(<2 x i32> %x)
  ret <2 x i32> %res
}

; CHECK-LABEL: call_ctpop_v2i16:
; CHECK:       # %bb
; CHECK-DAG:   sort4x16lo [[REGI0:\$m[0-9]+]], $m0, $m15
; CHECK-DAG:   sort4x16hi [[REGI1:\$m[0-9]+]], $m0, $m15
; CHECK-DAG:   popc [[REGI0]], [[REGI0]]
; CHECK-DAG:   popc [[REGI1]], [[REGI1]]
; CHECK-NEXT:  sort4x16lo $m0, [[REGI0]], [[REGI1]]
; CHECK-NEXT:  br $m10
declare <2 x i16> @llvm.ctpop.v2i16(<2 x i16>)
define <2 x i16> @call_ctpop_v2i16(<2 x i16> %x) {
  %res = call <2 x i16> @llvm.ctpop.v2i16(<2 x i16> %x)
  ret <2 x i16> %res
}

; CHECK-LABEL: call_ctpop_v4i16:
; CHECK:       # %bb
; CHECK-DAG:   sort4x16lo [[REGI0:\$m[0-9]+]], $m0, $m15
; CHECK-DAG:   sort4x16hi [[REGI1:\$m[0-9]+]], $m0, $m15
; CHECK-DAG:   sort4x16lo [[REGI2:\$m[0-9]+]], $m1, $m15
; CHECK-DAG:   sort4x16hi [[REGI3:\$m[0-9]+]], $m1, $m15
; CHECK-DAG:   popc [[REGI0]], [[REGI0]]
; CHECK-DAG:   popc [[REGI1]], [[REGI1]]
; CHECK-DAG:   popc [[REGI2]], [[REGI2]]
; CHECK-DAG:   popc [[REGI3]], [[REGI3]]
; CHECK-DAG:   sort4x16lo $m0, [[REGI0]], [[REGI1]]
; CHECK-DAG:   sort4x16lo $m1, [[REGI2]], [[REGI3]]
; CHECK-NEXT:  br $m10
declare <4 x i16> @llvm.ctpop.v4i16(<4 x i16>)
define <4 x i16> @call_ctpop_v4i16(<4 x i16> %x) {
  %res = call <4 x i16> @llvm.ctpop.v4i16(<4 x i16> %x)
  ret <4 x i16> %res
}

; CHECK-LABEL: call_ctlz_i32_0:
; CHECK:       # %bb
; CHECK-NEXT:  clz $m0, $m0
; CHECK-NEXT:  br $m10
declare i32 @llvm.ctlz.i32(i32,i1)
define i32 @call_ctlz_i32_0(i32 %x) {
  %res = call i32 @llvm.ctlz.i32(i32 %x,i1 0)
  ret i32 %res
}
; CHECK-LABEL: call_ctlz_i32_1:
; CHECK:       # %bb
; CHECK-NEXT:  clz $m0, $m0
; CHECK-NEXT:  br $m10
define i32 @call_ctlz_i32_1(i32 %x) {
  %res = call i32 @llvm.ctlz.i32(i32 %x,i1 1)
  ret i32 %res
}

; CHECK-LABEL: call_ctlz_v2i32_0:
; CHECK:       # %bb
; CHECK-DAG:   clz $m0, $m0
; CHECK-DAG:   clz $m1, $m1
; CHECK-NEXT:  br $m10
declare <2 x i32> @llvm.ctlz.v2i32(<2 x i32>,i1)
define <2 x i32> @call_ctlz_v2i32_0(<2 x i32> %x) {
  %res = call <2 x i32> @llvm.ctlz.v2i32(<2 x i32> %x,i1 0)
  ret <2 x i32> %res
}
; CHECK-LABEL: call_ctlz_v2i32_1:
; CHECK:       # %bb
; CHECK-DAG:   clz $m0, $m0
; CHECK-DAG:   clz $m1, $m1
; CHECK-NEXT:  br $m10
define <2 x i32> @call_ctlz_v2i32_1(<2 x i32> %x) {
  %res = call <2 x i32> @llvm.ctlz.v2i32(<2 x i32> %x,i1 1)
  ret <2 x i32> %res
}

; CHECK-LABEL: call_ctlz_v2i16_0:
; CHECK:       # %bb
; CHECK-DAG:   sort4x16lo [[REGI0:\$m[0-9]+]], $m0, $m15
; CHECK-DAG:   sort4x16hi [[REGI1:\$m[0-9]+]], $m0, $m15
; CHECK-DAG:   clz [[REGI0]], [[REGI0]]
; CHECK-DAG:   clz [[REGI1]], [[REGI1]]
; CHECK-DAG:   add [[REGI0]], [[REGI0]], -16
; CHECK-DAG:   add [[REGI1]], [[REGI1]], -16
; CHECK-NEXT:  sort4x16lo $m0, [[REGI0]], [[REGI1]]
; CHECK-NEXT:  br $m10
declare <2 x i16> @llvm.ctlz.v2i16(<2 x i16>,i1)
define <2 x i16> @call_ctlz_v2i16_0(<2 x i16> %x) {
  %res = call <2 x i16> @llvm.ctlz.v2i16(<2 x i16> %x,i1 0)
  ret <2 x i16> %res
}
; CHECK-LABEL: call_ctlz_v2i16_1:
; CHECK:       # %bb
; CHECK-DAG:   sort4x16lo [[REGI0:\$m[0-9]+]], $m0, $m15
; CHECK-DAG:   sort4x16hi [[REGI1:\$m[0-9]+]], $m0, $m15
; CHECK-DAG:   clz [[REGI0]], [[REGI0]]
; CHECK-DAG:   clz [[REGI1]], [[REGI1]]
; CHECK-DAG:   add [[REGI0]], [[REGI0]], -16
; CHECK-DAG:   add [[REGI1]], [[REGI1]], -16
; CHECK-NEXT:  sort4x16lo $m0, [[REGI0]], [[REGI1]]
; CHECK-NEXT:  br $m10
define <2 x i16> @call_ctlz_v2i16_1(<2 x i16> %x) {
  %res = call <2 x i16> @llvm.ctlz.v2i16(<2 x i16> %x,i1 1)
  ret <2 x i16> %res
}

; CHECK-LABEL: call_ctlz_v4i16_0:
; CHECK:       # %bb
; CHECK-DAG:   sort4x16lo [[REGI0:\$m[0-9]+]], $m0, $m15
; CHECK-DAG:   sort4x16hi [[REGI1:\$m[0-9]+]], $m0, $m15
; CHECK-DAG:   sort4x16lo [[REGI2:\$m[0-9]+]], $m1, $m15
; CHECK-DAG:   sort4x16hi [[REGI3:\$m[0-9]+]], $m1, $m15
; CHECK-DAG:   clz [[REGI0]], [[REGI0]]
; CHECK-DAG:   clz [[REGI1]], [[REGI1]]
; CHECK-DAG:   clz [[REGI2]], [[REGI2]]
; CHECK-DAG:   clz [[REGI3]], [[REGI3]]
; CHECK-DAG:   add [[REGI0]], [[REGI0]], -16
; CHECK-DAG:   add [[REGI1]], [[REGI1]], -16
; CHECK-DAG:   add [[REGI2]], [[REGI2]], -16
; CHECK-DAG:   add [[REGI3]], [[REGI3]], -16
; CHECK-DAG:   sort4x16lo $m0, [[REGI0]], [[REGI1]]
; CHECK-DAG:   sort4x16lo $m1, [[REGI2]], [[REGI3]]
; CHECK-NEXT:  br $m10
declare <4 x i16> @llvm.ctlz.v4i16(<4 x i16>,i1)
define <4 x i16> @call_ctlz_v4i16_0(<4 x i16> %x) {
  %res = call <4 x i16> @llvm.ctlz.v4i16(<4 x i16> %x,i1 0)
  ret <4 x i16> %res
}
; CHECK-LABEL: call_ctlz_v4i16_1:
; CHECK:       # %bb
; CHECK-DAG:   sort4x16lo [[REGI0:\$m[0-9]+]], $m0, $m15
; CHECK-DAG:   sort4x16hi [[REGI1:\$m[0-9]+]], $m0, $m15
; CHECK-DAG:   sort4x16lo [[REGI2:\$m[0-9]+]], $m1, $m15
; CHECK-DAG:   sort4x16hi [[REGI3:\$m[0-9]+]], $m1, $m15
; CHECK-DAG:   clz [[REGI0]], [[REGI0]]
; CHECK-DAG:   clz [[REGI1]], [[REGI1]]
; CHECK-DAG:   clz [[REGI2]], [[REGI2]]
; CHECK-DAG:   clz [[REGI3]], [[REGI3]]
; CHECK-DAG:   add [[REGI0]], [[REGI0]], -16
; CHECK-DAG:   add [[REGI1]], [[REGI1]], -16
; CHECK-DAG:   add [[REGI2]], [[REGI2]], -16
; CHECK-DAG:   add [[REGI3]], [[REGI3]], -16
; CHECK-DAG:   sort4x16lo $m0, [[REGI0]], [[REGI1]]
; CHECK-DAG:   sort4x16lo $m1, [[REGI2]], [[REGI3]]
; CHECK-NEXT:  br $m10
define <4 x i16> @call_ctlz_v4i16_1(<4 x i16> %x) {
  %res = call <4 x i16> @llvm.ctlz.v4i16(<4 x i16>%x,i1 1)
  ret <4 x i16> %res
}

; CHECK-LABEL: call_cttz_i32_0:
; CHECK:       # %bb
; CHECK-NEXT:  add [[TMPA0:\$m[0-9]+]], $m0, -1
; CHECK-NEXT:  andc [[TMPB0:\$m[0-9]+]], [[TMPA0]], $m0
; CHECK-NEXT:  popc $m0, [[TMPB0]]
; CHECK-NEXT:  br $m10
declare i32 @llvm.cttz.i32(i32,i1)
define i32 @call_cttz_i32_0(i32 %x) {
  %res = call i32 @llvm.cttz.i32(i32 %x,i1 0)
  ret i32 %res
}
; CHECK-LABEL: call_cttz_i32_1:
; CHECK:       # %bb
; CHECK-NEXT:  add [[TMPA0:\$m[0-9]+]], $m0, -1
; CHECK-NEXT:  andc [[TMPB0:\$m[0-9]+]], [[TMPA0]], $m0
; CHECK-NEXT:  popc $m0, [[TMPB0]]
; CHECK-NEXT:  br $m10
define i32 @call_cttz_i32_1(i32 %x) {
  %res = call i32 @llvm.cttz.i32(i32 %x,i1 1)
  ret i32 %res
}

; CHECK-LABEL: call_cttz_v2i32_0:
; CHECK:       # %bb
; CHECK-NEXT:  add [[TMPA0:\$m[0-9]+]], $m0, -1
; CHECK-NEXT:  andc [[TMPB0:\$m[0-9]+]], [[TMPA0]], $m0
; CHECK-NEXT:  popc $m0, [[TMPB0]]
; CHECK-NEXT:  add [[TMPA1:\$m[0-9]+]], $m1, -1
; CHECK-NEXT:  andc [[TMPB1:\$m[0-9]+]], [[TMPA1]], $m1
; CHECK-NEXT:  popc $m1, [[TMPB1]]
; CHECK-NEXT:  br $m10
declare <2 x i32> @llvm.cttz.v2i32(<2 x i32>,i1)
define <2 x i32> @call_cttz_v2i32_0(<2 x i32> %x) {
  %res = call <2 x i32> @llvm.cttz.v2i32(<2 x i32> %x,i1 0)
  ret <2 x i32> %res
}
; CHECK-LABEL: call_cttz_v2i32_1:
; CHECK:       # %bb
; CHECK-NEXT:  add [[TMPA0:\$m[0-9]+]], $m0, -1
; CHECK-NEXT:  andc [[TMPB0:\$m[0-9]+]], [[TMPA0]], $m0
; CHECK-NEXT:  popc $m0, [[TMPB0]]
; CHECK-NEXT:  add [[TMPA1:\$m[0-9]+]], $m1, -1
; CHECK-NEXT:  andc [[TMPB1:\$m[0-9]+]], [[TMPA1]], $m1
; CHECK-NEXT:  popc $m1, [[TMPB1]]
; CHECK-NEXT:  br $m10
define <2 x i32> @call_cttz_v2i32_1(<2 x i32> %x) {
  %res = call <2 x i32> @llvm.cttz.v2i32(<2 x i32> %x,i1 1)
  ret <2 x i32> %res
}

; CHECK-LABEL: call_cttz_v2i16_0:
; CHECK:       # %bb
; Set bit 17 to lower i16 via i32 operation
; CHECK-NEXT:  setzi [[TAG:\$m[0-9]+]], 65536

; Extract low half folded into the or
; CHECK-NEXT:  or [[TMPA0:\$m[0-9]+]], $m0, [[TAG]]
; CHECK-NEXT:  add [[TMPB0:\$m[0-9]+]], [[TMPA0]], -1
; CHECK-NEXT:  andc [[TMPC0:\$m[0-9]+]], [[TMPB0]], [[TMPA0]]
; CHECK-NEXT:  popc [[OUT0:\$m[0-9]+]], [[TMPC0]]

; Extract high half not folded
; CHECK-NEXT:  swap16 [[TMPHI:\$m[0-9]+]], $m0
; CHECK-NEXT:  or [[TMPA1:\$m[0-9]+]], [[TMPHI]], [[TAG]]
; CHECK-NEXT:  add [[TMPB1:\$m[0-9]+]], [[TMPA1]], -1
; CHECK-NEXT:  andc [[TMPC1:\$m[0-9]+]], [[TMPB1]], [[TMPA1]]
; CHECK-NEXT:  popc [[OUT1:\$m[0-9]+]], [[TMPC1]]

; CHECK-NEXT:  sort4x16lo $m0, [[OUT0]], [[OUT1]]
; CHECK-NEXT:  br $m10
declare <2 x i16> @llvm.cttz.v2i16(<2 x i16>,i1)
define <2 x i16> @call_cttz_v2i16_0(<2 x i16> %x) {
  %res = call <2 x i16> @llvm.cttz.v2i16(<2 x i16> %x,i1 0)
  ret <2 x i16> %res
}
; CHECK-LABEL: call_cttz_v2i16_1:
; CHECK:       # %bb
; CHECK-NEXT:  add [[TMPA0:\$m[0-9]+]], $m0, -1
; CHECK-NEXT:  andc [[TMPB0:\$m[0-9]+]], [[TMPA0]], $m0
; CHECK-NEXT:  popc [[OUT0:\$m[0-9]+]], [[TMPB0]]
; CHECK-NEXT:  swap16 [[TMPHI:\$m[0-9]+]], $m0
; CHECK-NEXT:  add [[TMPB1:\$m[0-9]+]], [[TMPA1]], -1
; CHECK-NEXT:  andc [[TMPC1:\$m[0-9]+]], [[TMPB1]], [[TMPA1]]
; CHECK-NEXT:  popc [[OUT1:\$m[0-9]+]], [[TMPC1]]
; CHECK-NEXT:  sort4x16lo $m0, [[OUT0]], [[OUT1]]
; CHECK-NEXT:  br $m10
define <2 x i16> @call_cttz_v2i16_1(<2 x i16> %x) {
  %res = call <2 x i16> @llvm.cttz.v2i16(<2 x i16> %x,i1 1)
  ret <2 x i16> %res
}

; CHECK-LABEL: call_cttz_v4i16_0:
; CHECK:       # %bb
; CHECK-NEXT:  setzi [[TAG:\$m[0-9]+]], 65536
; CHECK-NEXT:  or [[TMPA0:\$m[0-9]+]], $m1, [[TAG]]
; CHECK-NEXT:  add [[TMPB0:\$m[0-9]+]], [[TMPA0]], -1
; CHECK-NEXT:  andc [[TMPC0:\$m[0-9]+]], [[TMPB0]], [[TMPA0]]
; CHECK-NEXT:  popc [[OUT0:\$m[0-9]+]], [[TMPC0]]
; CHECK-NEXT:  swap16 [[TMPHI:\$m[0-9]+]], $m1
; CHECK-NEXT:  or [[TMPA1:\$m[0-9]+]], [[TMPHI]], [[TAG]]
; CHECK-NEXT:  add [[TMPB1:\$m[0-9]+]], [[TMPA1]], -1
; CHECK-NEXT:  andc [[TMPC1:\$m[0-9]+]], [[TMPB1]], [[TMPA1]]
; CHECK-NEXT:  popc [[OUT1:\$m[0-9]+]], [[TMPC1]]
; CHECK-NEXT:  sort4x16lo $m1, [[OUT0]], [[OUT1]]
; CHECK-NEXT:  or [[TMPA0:\$m[0-9]+]], $m0, [[TAG]]
; CHECK-NEXT:  add [[TMPB0:\$m[0-9]+]], [[TMPA0]], -1
; CHECK-NEXT:  andc [[TMPC0:\$m[0-9]+]], [[TMPB0]], [[TMPA0]]
; CHECK-NEXT:  popc [[OUT0:\$m[0-9]+]], [[TMPC0]]
; CHECK-NEXT:  swap16 [[TMPHI:\$m[0-9]+]], $m0
; CHECK-NEXT:  or [[TMPA1:\$m[0-9]+]], [[TMPHI]], [[TAG]]
; CHECK-NEXT:  add [[TMPB1:\$m[0-9]+]], [[TMPA1]], -1
; CHECK-NEXT:  andc [[TMPC1:\$m[0-9]+]], [[TMPB1]], [[TMPA1]]
; CHECK-NEXT:  popc [[OUT1:\$m[0-9]+]], [[TMPC1]]
; CHECK-NEXT:  sort4x16lo $m0, [[OUT0]], [[OUT1]]
; CHECK-NEXT:  br $m10
declare <4 x i16> @llvm.cttz.v4i16(<4 x i16>,i1)
define <4 x i16> @call_cttz_v4i16_0(<4 x i16> %x) {
  %res = call <4 x i16> @llvm.cttz.v4i16(<4 x i16> %x,i1 0)
  ret <4 x i16> %res
}
; CHECK-LABEL: call_cttz_v4i16_1:
; CHECK:       # %bb
; CHECK-NEXT:  add [[TMPA0:\$m[0-9]+]], $m1, -1
; CHECK-NEXT:  andc [[TMPB0:\$m[0-9]+]], [[TMPA0]], $m1
; CHECK-NEXT:  popc [[OUT0:\$m[0-9]+]], [[TMPB0]]
; CHECK-NEXT:  swap16 [[TMPHI:\$m[0-9]+]], $m1
; CHECK-NEXT:  add [[TMPB1:\$m[0-9]+]], [[TMPHI]], -1
; CHECK-NEXT:  andc [[TMPC1:\$m[0-9]+]], [[TMPB1]], [[TMPHI]]
; CHECK-NEXT:  popc [[OUT1:\$m[0-9]+]], [[TMPC1]]
; CHECK-NEXT:  sort4x16lo $m1, [[OUT0]], [[OUT1]]
; CHECK-NEXT:  add [[TMPA0:\$m[0-9]+]], $m0, -1
; CHECK-NEXT:  andc [[TMPB0:\$m[0-9]+]], [[TMPA0]], $m0
; CHECK-NEXT:  popc [[OUT0:\$m[0-9]+]], [[TMPB0]]
; CHECK-NEXT:  swap16 [[TMPHI:\$m[0-9]+]], $m0
; CHECK-NEXT:  add [[TMPB1:\$m[0-9]+]], [[TMPHI]], -1
; CHECK-NEXT:  andc [[TMPC1:\$m[0-9]+]], [[TMPB1]], [[TMPHI]]
; CHECK-NEXT:  popc [[OUT1:\$m[0-9]+]], [[TMPC1]]
; CHECK-NEXT:  sort4x16lo $m0, [[OUT0]], [[OUT1]]
; CHECK-NEXT:  br $m10
define <4 x i16> @call_cttz_v4i16_1(<4 x i16> %x) {
  %res = call <4 x i16> @llvm.cttz.v4i16(<4 x i16>%x,i1 1)
  ret <4 x i16> %res
}

