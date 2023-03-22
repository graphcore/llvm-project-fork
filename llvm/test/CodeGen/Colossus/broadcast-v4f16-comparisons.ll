; RUN: llc < %s -march=colossus -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -march=colossus -mattr=+ipu2 | FileCheck %s
target triple = "colossus-graphcore--elf"

declare <4 x i1> @llvm.experimental.constrained.fcmps.v4f16(<4 x half>, <4 x half>, metadata, metadata)

;;; Broadcast from a scalar

; CHECK-LABEL: fcmp_oeq_scalar_vector:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4cmpeq $a0:1, $a0:BL, $a2:3
; CHECK-NEXT:  }
define <4 x half> @fcmp_oeq_scalar_vector(half %a, <4 x half> %b) {
  %s0 = insertelement <4 x half> undef, half %a, i32 0
  %s1 = insertelement <4 x half> %s0, half %a, i32 1
  %s2 = insertelement <4 x half> %s1, half %a, i32 2
  %s3 = insertelement <4 x half> %s2, half %a, i32 3
  %res = fcmp oeq <4 x half> %s3, %b
  %se = sext <4 x i1> %res to <4 x i16>
  %bc = bitcast <4 x i16> %se to <4 x half>
  ret <4 x half> %bc
}

; CHECK-LABEL: constrained_fcmps_oeq_scalar_vector:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4cmpeq $a0:1, $a0:BL, $a2:3
; CHECK-NEXT:  }
define <4 x half> @constrained_fcmps_oeq_scalar_vector(half %a, <4 x half> %b) {
  %s0 = insertelement <4 x half> undef, half %a, i32 0
  %s1 = insertelement <4 x half> %s0, half %a, i32 1
  %s2 = insertelement <4 x half> %s1, half %a, i32 2
  %s3 = insertelement <4 x half> %s2, half %a, i32 3
  %res = tail call <4 x i1> @llvm.experimental.constrained.fcmps.v4f16(<4 x half> %s3, <4 x half> %b, metadata !"oeq", metadata !"fpexcept.strict")
  %se = sext <4 x i1> %res to <4 x i16>
  %bc = bitcast <4 x i16> %se to <4 x half>
  ret <4 x half> %bc
}

; CHECK-LABEL: fcmp_one_scalar_vector:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f16v4cmpgt $a4:5, $a0:BL, $a2:3
; CHECK-NEXT:  f16v4cmplt $a0:1, $a0:BL, $a2:3
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  or64 $a0:1, $a0:1, $a4:5
; CHECK-NEXT:  }
define <4 x half> @fcmp_one_scalar_vector(half %a, <4 x half> %b) {
  %s0 = insertelement <4 x half> undef, half %a, i32 0
  %s1 = insertelement <4 x half> %s0, half %a, i32 1
  %s2 = insertelement <4 x half> %s1, half %a, i32 2
  %s3 = insertelement <4 x half> %s2, half %a, i32 3
  %res = fcmp one <4 x half> %s3, %b
  %se = sext <4 x i1> %res to <4 x i16>
  %bc = bitcast <4 x i16> %se to <4 x half>
  ret <4 x half> %bc
}

; CHECK-LABEL: constrained_fcmps_one_scalar_vector:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f16v4cmpgt $a4:5, $a0:BL, $a2:3
; CHECK-NEXT:  f16v4cmplt $a0:1, $a0:BL, $a2:3
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  or64 $a0:1, $a0:1, $a4:5
; CHECK-NEXT:  }
define <4 x half> @constrained_fcmps_one_scalar_vector(half %a, <4 x half> %b) {
  %s0 = insertelement <4 x half> undef, half %a, i32 0
  %s1 = insertelement <4 x half> %s0, half %a, i32 1
  %s2 = insertelement <4 x half> %s1, half %a, i32 2
  %s3 = insertelement <4 x half> %s2, half %a, i32 3
  %res = tail call <4 x i1> @llvm.experimental.constrained.fcmps.v4f16(<4 x half> %s3, <4 x half> %b, metadata !"one", metadata !"fpexcept.strict")
  %se = sext <4 x i1> %res to <4 x i16>
  %bc = bitcast <4 x i16> %se to <4 x half>
  ret <4 x half> %bc
}

; CHECK-LABEL: fcmp_oge_scalar_vector:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4cmpge $a0:1, $a0:BL, $a2:3
; CHECK-NEXT:  }
define <4 x half> @fcmp_oge_scalar_vector(half %a, <4 x half> %b) {
  %s0 = insertelement <4 x half> undef, half %a, i32 0
  %s1 = insertelement <4 x half> %s0, half %a, i32 1
  %s2 = insertelement <4 x half> %s1, half %a, i32 2
  %s3 = insertelement <4 x half> %s2, half %a, i32 3
  %res = fcmp oge <4 x half> %s3, %b
  %se = sext <4 x i1> %res to <4 x i16>
  %bc = bitcast <4 x i16> %se to <4 x half>
  ret <4 x half> %bc
}

; CHECK-LABEL: constrained_fcmps_oge_scalar_vector:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4cmpge $a0:1, $a0:BL, $a2:3
; CHECK-NEXT:  }
define <4 x half> @constrained_fcmps_oge_scalar_vector(half %a, <4 x half> %b) {
  %s0 = insertelement <4 x half> undef, half %a, i32 0
  %s1 = insertelement <4 x half> %s0, half %a, i32 1
  %s2 = insertelement <4 x half> %s1, half %a, i32 2
  %s3 = insertelement <4 x half> %s2, half %a, i32 3
  %res = tail call <4 x i1> @llvm.experimental.constrained.fcmps.v4f16(<4 x half> %s3, <4 x half> %b, metadata !"oge", metadata !"fpexcept.strict")
  %se = sext <4 x i1> %res to <4 x i16>
  %bc = bitcast <4 x i16> %se to <4 x half>
  ret <4 x half> %bc
}

; CHECK-LABEL: fcmp_ogt_scalar_vector:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4cmpgt $a0:1, $a0:BL, $a2:3
; CHECK-NEXT:  }
define <4 x half> @fcmp_ogt_scalar_vector(half %a, <4 x half> %b) {
  %s0 = insertelement <4 x half> undef, half %a, i32 0
  %s1 = insertelement <4 x half> %s0, half %a, i32 1
  %s2 = insertelement <4 x half> %s1, half %a, i32 2
  %s3 = insertelement <4 x half> %s2, half %a, i32 3
  %res = fcmp ogt <4 x half> %s3, %b
  %se = sext <4 x i1> %res to <4 x i16>
  %bc = bitcast <4 x i16> %se to <4 x half>
  ret <4 x half> %bc
}

; CHECK-LABEL: constrained_fcmps_ogt_scalar_vector:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4cmpgt $a0:1, $a0:BL, $a2:3
; CHECK-NEXT:  }
define <4 x half> @constrained_fcmps_ogt_scalar_vector(half %a, <4 x half> %b) {
  %s0 = insertelement <4 x half> undef, half %a, i32 0
  %s1 = insertelement <4 x half> %s0, half %a, i32 1
  %s2 = insertelement <4 x half> %s1, half %a, i32 2
  %s3 = insertelement <4 x half> %s2, half %a, i32 3
  %res = tail call <4 x i1> @llvm.experimental.constrained.fcmps.v4f16(<4 x half> %s3, <4 x half> %b, metadata !"ogt", metadata !"fpexcept.strict")
  %se = sext <4 x i1> %res to <4 x i16>
  %bc = bitcast <4 x i16> %se to <4 x half>
  ret <4 x half> %bc
}

; CHECK-LABEL: fcmp_ole_scalar_vector:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4cmple $a0:1, $a0:BL, $a2:3
; CHECK-NEXT:  }
define <4 x half> @fcmp_ole_scalar_vector(half %a, <4 x half> %b) {
  %s0 = insertelement <4 x half> undef, half %a, i32 0
  %s1 = insertelement <4 x half> %s0, half %a, i32 1
  %s2 = insertelement <4 x half> %s1, half %a, i32 2
  %s3 = insertelement <4 x half> %s2, half %a, i32 3
  %res = fcmp ole <4 x half> %s3, %b
  %se = sext <4 x i1> %res to <4 x i16>
  %bc = bitcast <4 x i16> %se to <4 x half>
  ret <4 x half> %bc
}

; CHECK-LABEL: constrained_fcmps_ole_scalar_vector:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4cmple $a0:1, $a0:BL, $a2:3
; CHECK-NEXT:  }
define <4 x half> @constrained_fcmps_ole_scalar_vector(half %a, <4 x half> %b) {
  %s0 = insertelement <4 x half> undef, half %a, i32 0
  %s1 = insertelement <4 x half> %s0, half %a, i32 1
  %s2 = insertelement <4 x half> %s1, half %a, i32 2
  %s3 = insertelement <4 x half> %s2, half %a, i32 3
  %res = tail call <4 x i1> @llvm.experimental.constrained.fcmps.v4f16(<4 x half> %s3, <4 x half> %b, metadata !"ole", metadata !"fpexcept.strict")
  %se = sext <4 x i1> %res to <4 x i16>
  %bc = bitcast <4 x i16> %se to <4 x half>
  ret <4 x half> %bc
}

; CHECK-LABEL: fcmp_olt_scalar_vector:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4cmplt $a0:1, $a0:BL, $a2:3
; CHECK-NEXT:  }
define <4 x half> @fcmp_olt_scalar_vector(half %a, <4 x half> %b) {
  %s0 = insertelement <4 x half> undef, half %a, i32 0
  %s1 = insertelement <4 x half> %s0, half %a, i32 1
  %s2 = insertelement <4 x half> %s1, half %a, i32 2
  %s3 = insertelement <4 x half> %s2, half %a, i32 3
  %res = fcmp olt <4 x half> %s3, %b
  %se = sext <4 x i1> %res to <4 x i16>
  %bc = bitcast <4 x i16> %se to <4 x half>
  ret <4 x half> %bc
}

; CHECK-LABEL: constrained_fcmps_olt_scalar_vector:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4cmplt $a0:1, $a0:BL, $a2:3
; CHECK-NEXT:  }
define <4 x half> @constrained_fcmps_olt_scalar_vector(half %a, <4 x half> %b) {
  %s0 = insertelement <4 x half> undef, half %a, i32 0
  %s1 = insertelement <4 x half> %s0, half %a, i32 1
  %s2 = insertelement <4 x half> %s1, half %a, i32 2
  %s3 = insertelement <4 x half> %s2, half %a, i32 3
  %res = tail call <4 x i1> @llvm.experimental.constrained.fcmps.v4f16(<4 x half> %s3, <4 x half> %b, metadata !"olt", metadata !"fpexcept.strict")
  %se = sext <4 x i1> %res to <4 x i16>
  %bc = bitcast <4 x i16> %se to <4 x half>
  ret <4 x half> %bc
}

;;; Broadcast element of a vector of length 2

; CHECK-LABEL: fcmp_oeq_v2e0:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4cmpeq $a0:1, $a0:BL, $a2:3
; CHECK-NEXT:  }
define <4 x half> @fcmp_oeq_v2e0(<2 x half> %a, <4 x half> %b) {
  %e = extractelement <2 x half> %a, i32 0
  %s0 = insertelement <4 x half> undef, half %e, i32 0
  %s1 = insertelement <4 x half> %s0, half %e, i32 1
  %s2 = insertelement <4 x half> %s1, half %e, i32 2
  %s3 = insertelement <4 x half> %s2, half %e, i32 3
  %res = fcmp oeq <4 x half> %s3, %b
  %se = sext <4 x i1> %res to <4 x i16>
  %bc = bitcast <4 x i16> %se to <4 x half>
  ret <4 x half> %bc
}

; CHECK-LABEL: constrained_fcmps_oeq_v2e0:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4cmpeq $a0:1, $a0:BL, $a2:3
; CHECK-NEXT:  }
define <4 x half> @constrained_fcmps_oeq_v2e0(<2 x half> %a, <4 x half> %b) {
  %e = extractelement <2 x half> %a, i32 0
  %s0 = insertelement <4 x half> undef, half %e, i32 0
  %s1 = insertelement <4 x half> %s0, half %e, i32 1
  %s2 = insertelement <4 x half> %s1, half %e, i32 2
  %s3 = insertelement <4 x half> %s2, half %e, i32 3
  %res = tail call <4 x i1> @llvm.experimental.constrained.fcmps.v4f16(<4 x half> %s3, <4 x half> %b, metadata !"oeq", metadata !"fpexcept.strict")
  %se = sext <4 x i1> %res to <4 x i16>
  %bc = bitcast <4 x i16> %se to <4 x half>
  ret <4 x half> %bc
}

; CHECK-LABEL: fcmp_oeq_v2e1:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4cmpeq $a0:1, $a0:BU, $a2:3
; CHECK-NEXT:  }
define <4 x half> @fcmp_oeq_v2e1(<2 x half> %a, <4 x half> %b) {
  %e = extractelement <2 x half> %a, i32 1
  %s0 = insertelement <4 x half> undef, half %e, i32 0
  %s1 = insertelement <4 x half> %s0, half %e, i32 1
  %s2 = insertelement <4 x half> %s1, half %e, i32 2
  %s3 = insertelement <4 x half> %s2, half %e, i32 3
  %res = fcmp oeq <4 x half> %s3, %b
  %se = sext <4 x i1> %res to <4 x i16>
  %bc = bitcast <4 x i16> %se to <4 x half>
  ret <4 x half> %bc
}

; CHECK-LABEL: constrained_fcmps_oeq_v2e1:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4cmpeq $a0:1, $a0:BU, $a2:3
; CHECK-NEXT:  }
define <4 x half> @constrained_fcmps_oeq_v2e1(<2 x half> %a, <4 x half> %b) {
  %e = extractelement <2 x half> %a, i32 1
  %s0 = insertelement <4 x half> undef, half %e, i32 0
  %s1 = insertelement <4 x half> %s0, half %e, i32 1
  %s2 = insertelement <4 x half> %s1, half %e, i32 2
  %s3 = insertelement <4 x half> %s2, half %e, i32 3
  %res = tail call <4 x i1> @llvm.experimental.constrained.fcmps.v4f16(<4 x half> %s3, <4 x half> %b, metadata !"oeq", metadata !"fpexcept.strict")
  %se = sext <4 x i1> %res to <4 x i16>
  %bc = bitcast <4 x i16> %se to <4 x half>
  ret <4 x half> %bc
}

; CHECK-LABEL: fcmp_one_v2e0:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f16v4cmpgt $a4:5, $a0:BL, $a2:3
; CHECK-NEXT:  f16v4cmplt $a0:1, $a0:BL, $a2:3
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  or64 $a0:1, $a0:1, $a4:5
; CHECK-NEXT:  }
define <4 x half> @fcmp_one_v2e0(<2 x half> %a, <4 x half> %b) {
  %e = extractelement <2 x half> %a, i32 0
  %s0 = insertelement <4 x half> undef, half %e, i32 0
  %s1 = insertelement <4 x half> %s0, half %e, i32 1
  %s2 = insertelement <4 x half> %s1, half %e, i32 2
  %s3 = insertelement <4 x half> %s2, half %e, i32 3
  %res = fcmp one <4 x half> %s3, %b
  %se = sext <4 x i1> %res to <4 x i16>
  %bc = bitcast <4 x i16> %se to <4 x half>
  ret <4 x half> %bc
}

; CHECK-LABEL: constrained_fcmps_one_v2e0:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f16v4cmpgt $a4:5, $a0:BL, $a2:3
; CHECK-NEXT:  f16v4cmplt $a0:1, $a0:BL, $a2:3
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  or64 $a0:1, $a0:1, $a4:5
; CHECK-NEXT:  }
define <4 x half> @constrained_fcmps_one_v2e0(<2 x half> %a, <4 x half> %b) {
  %e = extractelement <2 x half> %a, i32 0
  %s0 = insertelement <4 x half> undef, half %e, i32 0
  %s1 = insertelement <4 x half> %s0, half %e, i32 1
  %s2 = insertelement <4 x half> %s1, half %e, i32 2
  %s3 = insertelement <4 x half> %s2, half %e, i32 3
  %res = tail call <4 x i1> @llvm.experimental.constrained.fcmps.v4f16(<4 x half> %s3, <4 x half> %b, metadata !"one", metadata !"fpexcept.strict")
  %se = sext <4 x i1> %res to <4 x i16>
  %bc = bitcast <4 x i16> %se to <4 x half>
  ret <4 x half> %bc
}

; CHECK-LABEL: fcmp_one_v2e1:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f16v4cmpgt $a4:5, $a0:BU, $a2:3
; CHECK-NEXT:  f16v4cmplt $a0:1, $a0:BU, $a2:3
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  or64 $a0:1, $a0:1, $a4:5
; CHECK-NEXT:  }
define <4 x half> @fcmp_one_v2e1(<2 x half> %a, <4 x half> %b) {
  %e = extractelement <2 x half> %a, i32 1
  %s0 = insertelement <4 x half> undef, half %e, i32 0
  %s1 = insertelement <4 x half> %s0, half %e, i32 1
  %s2 = insertelement <4 x half> %s1, half %e, i32 2
  %s3 = insertelement <4 x half> %s2, half %e, i32 3
  %res = fcmp one <4 x half> %s3, %b
  %se = sext <4 x i1> %res to <4 x i16>
  %bc = bitcast <4 x i16> %se to <4 x half>
  ret <4 x half> %bc
}

; CHECK-LABEL: constrained_fcmps_one_v2e1:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f16v4cmpgt $a4:5, $a0:BU, $a2:3
; CHECK-NEXT:  f16v4cmplt $a0:1, $a0:BU, $a2:3
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  or64 $a0:1, $a0:1, $a4:5
; CHECK-NEXT:  }
define <4 x half> @constrained_fcmps_one_v2e1(<2 x half> %a, <4 x half> %b) {
  %e = extractelement <2 x half> %a, i32 1
  %s0 = insertelement <4 x half> undef, half %e, i32 0
  %s1 = insertelement <4 x half> %s0, half %e, i32 1
  %s2 = insertelement <4 x half> %s1, half %e, i32 2
  %s3 = insertelement <4 x half> %s2, half %e, i32 3
  %res = tail call <4 x i1> @llvm.experimental.constrained.fcmps.v4f16(<4 x half> %s3, <4 x half> %b, metadata !"one", metadata !"fpexcept.strict")
  %se = sext <4 x i1> %res to <4 x i16>
  %bc = bitcast <4 x i16> %se to <4 x half>
  ret <4 x half> %bc
}

; CHECK-LABEL: fcmp_oge_v2e0:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4cmpge $a0:1, $a0:BL, $a2:3
; CHECK-NEXT:  }
define <4 x half> @fcmp_oge_v2e0(<2 x half> %a, <4 x half> %b) {
  %e = extractelement <2 x half> %a, i32 0
  %s0 = insertelement <4 x half> undef, half %e, i32 0
  %s1 = insertelement <4 x half> %s0, half %e, i32 1
  %s2 = insertelement <4 x half> %s1, half %e, i32 2
  %s3 = insertelement <4 x half> %s2, half %e, i32 3
  %res = fcmp oge <4 x half> %s3, %b
  %se = sext <4 x i1> %res to <4 x i16>
  %bc = bitcast <4 x i16> %se to <4 x half>
  ret <4 x half> %bc
}

; CHECK-LABEL: constrained_fcmps_oge_v2e0:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4cmpge $a0:1, $a0:BL, $a2:3
; CHECK-NEXT:  }
define <4 x half> @constrained_fcmps_oge_v2e0(<2 x half> %a, <4 x half> %b) {
  %e = extractelement <2 x half> %a, i32 0
  %s0 = insertelement <4 x half> undef, half %e, i32 0
  %s1 = insertelement <4 x half> %s0, half %e, i32 1
  %s2 = insertelement <4 x half> %s1, half %e, i32 2
  %s3 = insertelement <4 x half> %s2, half %e, i32 3
  %res = tail call <4 x i1> @llvm.experimental.constrained.fcmps.v4f16(<4 x half> %s3, <4 x half> %b, metadata !"oge", metadata !"fpexcept.strict")
  %se = sext <4 x i1> %res to <4 x i16>
  %bc = bitcast <4 x i16> %se to <4 x half>
  ret <4 x half> %bc
}

; CHECK-LABEL: fcmp_oge_v2e1:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4cmpge $a0:1, $a0:BU, $a2:3
; CHECK-NEXT:  }
define <4 x half> @fcmp_oge_v2e1(<2 x half> %a, <4 x half> %b) {
  %e = extractelement <2 x half> %a, i32 1
  %s0 = insertelement <4 x half> undef, half %e, i32 0
  %s1 = insertelement <4 x half> %s0, half %e, i32 1
  %s2 = insertelement <4 x half> %s1, half %e, i32 2
  %s3 = insertelement <4 x half> %s2, half %e, i32 3
  %res = fcmp oge <4 x half> %s3, %b
  %se = sext <4 x i1> %res to <4 x i16>
  %bc = bitcast <4 x i16> %se to <4 x half>
  ret <4 x half> %bc
}

; CHECK-LABEL: constrained_fcmps_oge_v2e1:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4cmpge $a0:1, $a0:BU, $a2:3
; CHECK-NEXT:  }
define <4 x half> @constrained_fcmps_oge_v2e1(<2 x half> %a, <4 x half> %b) {
  %e = extractelement <2 x half> %a, i32 1
  %s0 = insertelement <4 x half> undef, half %e, i32 0
  %s1 = insertelement <4 x half> %s0, half %e, i32 1
  %s2 = insertelement <4 x half> %s1, half %e, i32 2
  %s3 = insertelement <4 x half> %s2, half %e, i32 3
  %res = tail call <4 x i1> @llvm.experimental.constrained.fcmps.v4f16(<4 x half> %s3, <4 x half> %b, metadata !"oge", metadata !"fpexcept.strict")
  %se = sext <4 x i1> %res to <4 x i16>
  %bc = bitcast <4 x i16> %se to <4 x half>
  ret <4 x half> %bc
}

; CHECK-LABEL: fcmp_ogt_v2e0:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4cmpgt $a0:1, $a0:BL, $a2:3
; CHECK-NEXT:  }
define <4 x half> @fcmp_ogt_v2e0(<2 x half> %a, <4 x half> %b) {
  %e = extractelement <2 x half> %a, i32 0
  %s0 = insertelement <4 x half> undef, half %e, i32 0
  %s1 = insertelement <4 x half> %s0, half %e, i32 1
  %s2 = insertelement <4 x half> %s1, half %e, i32 2
  %s3 = insertelement <4 x half> %s2, half %e, i32 3
  %res = fcmp ogt <4 x half> %s3, %b
  %se = sext <4 x i1> %res to <4 x i16>
  %bc = bitcast <4 x i16> %se to <4 x half>
  ret <4 x half> %bc
}

; CHECK-LABEL: constrained_fcmps_ogt_v2e0:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4cmpgt $a0:1, $a0:BL, $a2:3
; CHECK-NEXT:  }
define <4 x half> @constrained_fcmps_ogt_v2e0(<2 x half> %a, <4 x half> %b) {
  %e = extractelement <2 x half> %a, i32 0
  %s0 = insertelement <4 x half> undef, half %e, i32 0
  %s1 = insertelement <4 x half> %s0, half %e, i32 1
  %s2 = insertelement <4 x half> %s1, half %e, i32 2
  %s3 = insertelement <4 x half> %s2, half %e, i32 3
  %res = tail call <4 x i1> @llvm.experimental.constrained.fcmps.v4f16(<4 x half> %s3, <4 x half> %b, metadata !"ogt", metadata !"fpexcept.strict")
  %se = sext <4 x i1> %res to <4 x i16>
  %bc = bitcast <4 x i16> %se to <4 x half>
  ret <4 x half> %bc
}

; CHECK-LABEL: fcmp_ogt_v2e1:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4cmpgt $a0:1, $a0:BU, $a2:3
; CHECK-NEXT:  }
define <4 x half> @fcmp_ogt_v2e1(<2 x half> %a, <4 x half> %b) {
  %e = extractelement <2 x half> %a, i32 1
  %s0 = insertelement <4 x half> undef, half %e, i32 0
  %s1 = insertelement <4 x half> %s0, half %e, i32 1
  %s2 = insertelement <4 x half> %s1, half %e, i32 2
  %s3 = insertelement <4 x half> %s2, half %e, i32 3
  %res = fcmp ogt <4 x half> %s3, %b
  %se = sext <4 x i1> %res to <4 x i16>
  %bc = bitcast <4 x i16> %se to <4 x half>
  ret <4 x half> %bc
}

; CHECK-LABEL: constrained_fcmps_ogt_v2e1:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4cmpgt $a0:1, $a0:BU, $a2:3
; CHECK-NEXT:  }
define <4 x half> @constrained_fcmps_ogt_v2e1(<2 x half> %a, <4 x half> %b) {
  %e = extractelement <2 x half> %a, i32 1
  %s0 = insertelement <4 x half> undef, half %e, i32 0
  %s1 = insertelement <4 x half> %s0, half %e, i32 1
  %s2 = insertelement <4 x half> %s1, half %e, i32 2
  %s3 = insertelement <4 x half> %s2, half %e, i32 3
  %res = tail call <4 x i1> @llvm.experimental.constrained.fcmps.v4f16(<4 x half> %s3, <4 x half> %b, metadata !"ogt", metadata !"fpexcept.strict")
  %se = sext <4 x i1> %res to <4 x i16>
  %bc = bitcast <4 x i16> %se to <4 x half>
  ret <4 x half> %bc
}

; CHECK-LABEL: fcmp_ole_v2e0:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4cmple $a0:1, $a0:BL, $a2:3
; CHECK-NEXT:  }
define <4 x half> @fcmp_ole_v2e0(<2 x half> %a, <4 x half> %b) {
  %e = extractelement <2 x half> %a, i32 0
  %s0 = insertelement <4 x half> undef, half %e, i32 0
  %s1 = insertelement <4 x half> %s0, half %e, i32 1
  %s2 = insertelement <4 x half> %s1, half %e, i32 2
  %s3 = insertelement <4 x half> %s2, half %e, i32 3
  %res = fcmp ole <4 x half> %s3, %b
  %se = sext <4 x i1> %res to <4 x i16>
  %bc = bitcast <4 x i16> %se to <4 x half>
  ret <4 x half> %bc
}

; CHECK-LABEL: constrained_fcmps_ole_v2e0:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4cmple $a0:1, $a0:BL, $a2:3
; CHECK-NEXT:  }
define <4 x half> @constrained_fcmps_ole_v2e0(<2 x half> %a, <4 x half> %b) {
  %e = extractelement <2 x half> %a, i32 0
  %s0 = insertelement <4 x half> undef, half %e, i32 0
  %s1 = insertelement <4 x half> %s0, half %e, i32 1
  %s2 = insertelement <4 x half> %s1, half %e, i32 2
  %s3 = insertelement <4 x half> %s2, half %e, i32 3
  %res = tail call <4 x i1> @llvm.experimental.constrained.fcmps.v4f16(<4 x half> %s3, <4 x half> %b, metadata !"ole", metadata !"fpexcept.strict")
  %se = sext <4 x i1> %res to <4 x i16>
  %bc = bitcast <4 x i16> %se to <4 x half>
  ret <4 x half> %bc
}

; CHECK-LABEL: fcmp_ole_v2e1:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4cmple $a0:1, $a0:BU, $a2:3
; CHECK-NEXT:  }
define <4 x half> @fcmp_ole_v2e1(<2 x half> %a, <4 x half> %b) {
  %e = extractelement <2 x half> %a, i32 1
  %s0 = insertelement <4 x half> undef, half %e, i32 0
  %s1 = insertelement <4 x half> %s0, half %e, i32 1
  %s2 = insertelement <4 x half> %s1, half %e, i32 2
  %s3 = insertelement <4 x half> %s2, half %e, i32 3
  %res = fcmp ole <4 x half> %s3, %b
  %se = sext <4 x i1> %res to <4 x i16>
  %bc = bitcast <4 x i16> %se to <4 x half>
  ret <4 x half> %bc
}

; CHECK-LABEL: constrained_fcmps_ole_v2e1:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4cmple $a0:1, $a0:BU, $a2:3
; CHECK-NEXT:  }
define <4 x half> @constrained_fcmps_ole_v2e1(<2 x half> %a, <4 x half> %b) {
  %e = extractelement <2 x half> %a, i32 1
  %s0 = insertelement <4 x half> undef, half %e, i32 0
  %s1 = insertelement <4 x half> %s0, half %e, i32 1
  %s2 = insertelement <4 x half> %s1, half %e, i32 2
  %s3 = insertelement <4 x half> %s2, half %e, i32 3
  %res = tail call <4 x i1> @llvm.experimental.constrained.fcmps.v4f16(<4 x half> %s3, <4 x half> %b, metadata !"ole", metadata !"fpexcept.strict")
  %se = sext <4 x i1> %res to <4 x i16>
  %bc = bitcast <4 x i16> %se to <4 x half>
  ret <4 x half> %bc
}

; CHECK-LABEL: fcmp_olt_v2e0:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4cmplt $a0:1, $a0:BL, $a2:3
; CHECK-NEXT:  }
define <4 x half> @fcmp_olt_v2e0(<2 x half> %a, <4 x half> %b) {
  %e = extractelement <2 x half> %a, i32 0
  %s0 = insertelement <4 x half> undef, half %e, i32 0
  %s1 = insertelement <4 x half> %s0, half %e, i32 1
  %s2 = insertelement <4 x half> %s1, half %e, i32 2
  %s3 = insertelement <4 x half> %s2, half %e, i32 3
  %res = fcmp olt <4 x half> %s3, %b
  %se = sext <4 x i1> %res to <4 x i16>
  %bc = bitcast <4 x i16> %se to <4 x half>
  ret <4 x half> %bc
}

; CHECK-LABEL: constrained_fcmps_olt_v2e0:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4cmplt $a0:1, $a0:BL, $a2:3
; CHECK-NEXT:  }
define <4 x half> @constrained_fcmps_olt_v2e0(<2 x half> %a, <4 x half> %b) {
  %e = extractelement <2 x half> %a, i32 0
  %s0 = insertelement <4 x half> undef, half %e, i32 0
  %s1 = insertelement <4 x half> %s0, half %e, i32 1
  %s2 = insertelement <4 x half> %s1, half %e, i32 2
  %s3 = insertelement <4 x half> %s2, half %e, i32 3
  %res = tail call <4 x i1> @llvm.experimental.constrained.fcmps.v4f16(<4 x half> %s3, <4 x half> %b, metadata !"olt", metadata !"fpexcept.strict")
  %se = sext <4 x i1> %res to <4 x i16>
  %bc = bitcast <4 x i16> %se to <4 x half>
  ret <4 x half> %bc
}

; CHECK-LABEL: fcmp_olt_v2e1:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4cmplt $a0:1, $a0:BU, $a2:3
; CHECK-NEXT:  }
define <4 x half> @fcmp_olt_v2e1(<2 x half> %a, <4 x half> %b) {
  %e = extractelement <2 x half> %a, i32 1
  %s0 = insertelement <4 x half> undef, half %e, i32 0
  %s1 = insertelement <4 x half> %s0, half %e, i32 1
  %s2 = insertelement <4 x half> %s1, half %e, i32 2
  %s3 = insertelement <4 x half> %s2, half %e, i32 3
  %res = fcmp olt <4 x half> %s3, %b
  %se = sext <4 x i1> %res to <4 x i16>
  %bc = bitcast <4 x i16> %se to <4 x half>
  ret <4 x half> %bc
}

; CHECK-LABEL: constrained_fcmps_olt_v2e1:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4cmplt $a0:1, $a0:BU, $a2:3
; CHECK-NEXT:  }
define <4 x half> @constrained_fcmps_olt_v2e1(<2 x half> %a, <4 x half> %b) {
  %e = extractelement <2 x half> %a, i32 1
  %s0 = insertelement <4 x half> undef, half %e, i32 0
  %s1 = insertelement <4 x half> %s0, half %e, i32 1
  %s2 = insertelement <4 x half> %s1, half %e, i32 2
  %s3 = insertelement <4 x half> %s2, half %e, i32 3
  %res = tail call <4 x i1> @llvm.experimental.constrained.fcmps.v4f16(<4 x half> %s3, <4 x half> %b, metadata !"olt", metadata !"fpexcept.strict")
  %se = sext <4 x i1> %res to <4 x i16>
  %bc = bitcast <4 x i16> %se to <4 x half>
  ret <4 x half> %bc
}

;;; Broadcast element of a vector of length 4

; CHECK-LABEL: fcmp_oeq_v4e0:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4cmpeq $a0:1, $a0:BL, $a2:3
; CHECK-NEXT:  }
define <4 x half> @fcmp_oeq_v4e0(<4 x half> %a, <4 x half> %b) {
  %e = extractelement <4 x half> %a, i32 0
  %s0 = insertelement <4 x half> undef, half %e, i32 0
  %s1 = insertelement <4 x half> %s0, half %e, i32 1
  %s2 = insertelement <4 x half> %s1, half %e, i32 2
  %s3 = insertelement <4 x half> %s2, half %e, i32 3
  %res = fcmp oeq <4 x half> %s3, %b
  %se = sext <4 x i1> %res to <4 x i16>
  %bc = bitcast <4 x i16> %se to <4 x half>
  ret <4 x half> %bc
}

; CHECK-LABEL: constrained_fcmps_oeq_v4e0:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4cmpeq $a0:1, $a0:BL, $a2:3
; CHECK-NEXT:  }
define <4 x half> @constrained_fcmps_oeq_v4e0(<4 x half> %a, <4 x half> %b) {
  %e = extractelement <4 x half> %a, i32 0
  %s0 = insertelement <4 x half> undef, half %e, i32 0
  %s1 = insertelement <4 x half> %s0, half %e, i32 1
  %s2 = insertelement <4 x half> %s1, half %e, i32 2
  %s3 = insertelement <4 x half> %s2, half %e, i32 3
  %res = tail call <4 x i1> @llvm.experimental.constrained.fcmps.v4f16(<4 x half> %s3, <4 x half> %b, metadata !"oeq", metadata !"fpexcept.strict")
  %se = sext <4 x i1> %res to <4 x i16>
  %bc = bitcast <4 x i16> %se to <4 x half>
  ret <4 x half> %bc
}

; CHECK-LABEL: fcmp_oeq_v4e1:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4cmpeq $a0:1, $a0:BU, $a2:3
; CHECK-NEXT:  }
define <4 x half> @fcmp_oeq_v4e1(<4 x half> %a, <4 x half> %b) {
  %e = extractelement <4 x half> %a, i32 1
  %s0 = insertelement <4 x half> undef, half %e, i32 0
  %s1 = insertelement <4 x half> %s0, half %e, i32 1
  %s2 = insertelement <4 x half> %s1, half %e, i32 2
  %s3 = insertelement <4 x half> %s2, half %e, i32 3
  %res = fcmp oeq <4 x half> %s3, %b
  %se = sext <4 x i1> %res to <4 x i16>
  %bc = bitcast <4 x i16> %se to <4 x half>
  ret <4 x half> %bc
}

; CHECK-LABEL: constrained_fcmps_oeq_v4e1:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4cmpeq $a0:1, $a0:BU, $a2:3
; CHECK-NEXT:  }
define <4 x half> @constrained_fcmps_oeq_v4e1(<4 x half> %a, <4 x half> %b) {
  %e = extractelement <4 x half> %a, i32 1
  %s0 = insertelement <4 x half> undef, half %e, i32 0
  %s1 = insertelement <4 x half> %s0, half %e, i32 1
  %s2 = insertelement <4 x half> %s1, half %e, i32 2
  %s3 = insertelement <4 x half> %s2, half %e, i32 3
  %res = tail call <4 x i1> @llvm.experimental.constrained.fcmps.v4f16(<4 x half> %s3, <4 x half> %b, metadata !"oeq", metadata !"fpexcept.strict")
  %se = sext <4 x i1> %res to <4 x i16>
  %bc = bitcast <4 x i16> %se to <4 x half>
  ret <4 x half> %bc
}

; CHECK-LABEL: fcmp_oeq_v4e2:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4cmpeq $a0:1, $a1:BL, $a2:3
; CHECK-NEXT:  }
define <4 x half> @fcmp_oeq_v4e2(<4 x half> %a, <4 x half> %b) {
  %e = extractelement <4 x half> %a, i32 2
  %s0 = insertelement <4 x half> undef, half %e, i32 0
  %s1 = insertelement <4 x half> %s0, half %e, i32 1
  %s2 = insertelement <4 x half> %s1, half %e, i32 2
  %s3 = insertelement <4 x half> %s2, half %e, i32 3
  %res = fcmp oeq <4 x half> %s3, %b
  %se = sext <4 x i1> %res to <4 x i16>
  %bc = bitcast <4 x i16> %se to <4 x half>
  ret <4 x half> %bc
}

; CHECK-LABEL: constrained_fcmps_oeq_v4e2:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4cmpeq $a0:1, $a1:BL, $a2:3
; CHECK-NEXT:  }
define <4 x half> @constrained_fcmps_oeq_v4e2(<4 x half> %a, <4 x half> %b) {
  %e = extractelement <4 x half> %a, i32 2
  %s0 = insertelement <4 x half> undef, half %e, i32 0
  %s1 = insertelement <4 x half> %s0, half %e, i32 1
  %s2 = insertelement <4 x half> %s1, half %e, i32 2
  %s3 = insertelement <4 x half> %s2, half %e, i32 3
  %res = tail call <4 x i1> @llvm.experimental.constrained.fcmps.v4f16(<4 x half> %s3, <4 x half> %b, metadata !"oeq", metadata !"fpexcept.strict")
  %se = sext <4 x i1> %res to <4 x i16>
  %bc = bitcast <4 x i16> %se to <4 x half>
  ret <4 x half> %bc
}

; CHECK-LABEL: fcmp_oeq_v4e3:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4cmpeq $a0:1, $a1:BU, $a2:3
; CHECK-NEXT:  }
define <4 x half> @fcmp_oeq_v4e3(<4 x half> %a, <4 x half> %b) {
  %e = extractelement <4 x half> %a, i32 3
  %s0 = insertelement <4 x half> undef, half %e, i32 0
  %s1 = insertelement <4 x half> %s0, half %e, i32 1
  %s2 = insertelement <4 x half> %s1, half %e, i32 2
  %s3 = insertelement <4 x half> %s2, half %e, i32 3
  %res = fcmp oeq <4 x half> %s3, %b
  %se = sext <4 x i1> %res to <4 x i16>
  %bc = bitcast <4 x i16> %se to <4 x half>
  ret <4 x half> %bc
}

; CHECK-LABEL: constrained_fcmps_oeq_v4e3:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4cmpeq $a0:1, $a1:BU, $a2:3
; CHECK-NEXT:  }
define <4 x half> @constrained_fcmps_oeq_v4e3(<4 x half> %a, <4 x half> %b) {
  %e = extractelement <4 x half> %a, i32 3
  %s0 = insertelement <4 x half> undef, half %e, i32 0
  %s1 = insertelement <4 x half> %s0, half %e, i32 1
  %s2 = insertelement <4 x half> %s1, half %e, i32 2
  %s3 = insertelement <4 x half> %s2, half %e, i32 3
  %res = tail call <4 x i1> @llvm.experimental.constrained.fcmps.v4f16(<4 x half> %s3, <4 x half> %b, metadata !"oeq", metadata !"fpexcept.strict")
  %se = sext <4 x i1> %res to <4 x i16>
  %bc = bitcast <4 x i16> %se to <4 x half>
  ret <4 x half> %bc
}

; CHECK-LABEL: fcmp_one_v4e0:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f16v4cmpgt $a4:5, $a0:BL, $a2:3
; CHECK-NEXT:  f16v4cmplt $a0:1, $a0:BL, $a2:3
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  or64 $a0:1, $a0:1, $a4:5
; CHECK-NEXT:  }
define <4 x half> @fcmp_one_v4e0(<4 x half> %a, <4 x half> %b) {
  %e = extractelement <4 x half> %a, i32 0
  %s0 = insertelement <4 x half> undef, half %e, i32 0
  %s1 = insertelement <4 x half> %s0, half %e, i32 1
  %s2 = insertelement <4 x half> %s1, half %e, i32 2
  %s3 = insertelement <4 x half> %s2, half %e, i32 3
  %res = fcmp one <4 x half> %s3, %b
  %se = sext <4 x i1> %res to <4 x i16>
  %bc = bitcast <4 x i16> %se to <4 x half>
  ret <4 x half> %bc
}

; CHECK-LABEL: constrained_fcmps_one_v4e0:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f16v4cmpgt $a4:5, $a0:BL, $a2:3
; CHECK-NEXT:  f16v4cmplt $a0:1, $a0:BL, $a2:3
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  or64 $a0:1, $a0:1, $a4:5
; CHECK-NEXT:  }
define <4 x half> @constrained_fcmps_one_v4e0(<4 x half> %a, <4 x half> %b) {
  %e = extractelement <4 x half> %a, i32 0
  %s0 = insertelement <4 x half> undef, half %e, i32 0
  %s1 = insertelement <4 x half> %s0, half %e, i32 1
  %s2 = insertelement <4 x half> %s1, half %e, i32 2
  %s3 = insertelement <4 x half> %s2, half %e, i32 3
  %res = tail call <4 x i1> @llvm.experimental.constrained.fcmps.v4f16(<4 x half> %s3, <4 x half> %b, metadata !"one", metadata !"fpexcept.strict")
  %se = sext <4 x i1> %res to <4 x i16>
  %bc = bitcast <4 x i16> %se to <4 x half>
  ret <4 x half> %bc
}

; CHECK-LABEL: fcmp_one_v4e1:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f16v4cmpgt $a4:5, $a0:BU, $a2:3
; CHECK-NEXT:  f16v4cmplt $a0:1, $a0:BU, $a2:3
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  or64 $a0:1, $a0:1, $a4:5
; CHECK-NEXT:  }
define <4 x half> @fcmp_one_v4e1(<4 x half> %a, <4 x half> %b) {
  %e = extractelement <4 x half> %a, i32 1
  %s0 = insertelement <4 x half> undef, half %e, i32 0
  %s1 = insertelement <4 x half> %s0, half %e, i32 1
  %s2 = insertelement <4 x half> %s1, half %e, i32 2
  %s3 = insertelement <4 x half> %s2, half %e, i32 3
  %res = fcmp one <4 x half> %s3, %b
  %se = sext <4 x i1> %res to <4 x i16>
  %bc = bitcast <4 x i16> %se to <4 x half>
  ret <4 x half> %bc
}

; CHECK-LABEL: constrained_fcmps_one_v4e1:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f16v4cmpgt $a4:5, $a0:BU, $a2:3
; CHECK-NEXT:  f16v4cmplt $a0:1, $a0:BU, $a2:3
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  or64 $a0:1, $a0:1, $a4:5
; CHECK-NEXT:  }
define <4 x half> @constrained_fcmps_one_v4e1(<4 x half> %a, <4 x half> %b) {
  %e = extractelement <4 x half> %a, i32 1
  %s0 = insertelement <4 x half> undef, half %e, i32 0
  %s1 = insertelement <4 x half> %s0, half %e, i32 1
  %s2 = insertelement <4 x half> %s1, half %e, i32 2
  %s3 = insertelement <4 x half> %s2, half %e, i32 3
  %res = tail call <4 x i1> @llvm.experimental.constrained.fcmps.v4f16(<4 x half> %s3, <4 x half> %b, metadata !"one", metadata !"fpexcept.strict")
  %se = sext <4 x i1> %res to <4 x i16>
  %bc = bitcast <4 x i16> %se to <4 x half>
  ret <4 x half> %bc
}

; CHECK-LABEL: fcmp_one_v4e2:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f16v4cmpgt $a4:5, $a1:BL, $a2:3
; CHECK-NEXT:  f16v4cmplt $a0:1, $a1:BL, $a2:3
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  or64 $a0:1, $a0:1, $a4:5
; CHECK-NEXT:  }
define <4 x half> @fcmp_one_v4e2(<4 x half> %a, <4 x half> %b) {
  %e = extractelement <4 x half> %a, i32 2
  %s0 = insertelement <4 x half> undef, half %e, i32 0
  %s1 = insertelement <4 x half> %s0, half %e, i32 1
  %s2 = insertelement <4 x half> %s1, half %e, i32 2
  %s3 = insertelement <4 x half> %s2, half %e, i32 3
  %res = fcmp one <4 x half> %s3, %b
  %se = sext <4 x i1> %res to <4 x i16>
  %bc = bitcast <4 x i16> %se to <4 x half>
  ret <4 x half> %bc
}

; CHECK-LABEL: constrained_fcmps_one_v4e2:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f16v4cmpgt $a4:5, $a1:BL, $a2:3
; CHECK-NEXT:  f16v4cmplt $a0:1, $a1:BL, $a2:3
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  or64 $a0:1, $a0:1, $a4:5
; CHECK-NEXT:  }
define <4 x half> @constrained_fcmps_one_v4e2(<4 x half> %a, <4 x half> %b) {
  %e = extractelement <4 x half> %a, i32 2
  %s0 = insertelement <4 x half> undef, half %e, i32 0
  %s1 = insertelement <4 x half> %s0, half %e, i32 1
  %s2 = insertelement <4 x half> %s1, half %e, i32 2
  %s3 = insertelement <4 x half> %s2, half %e, i32 3
  %res = tail call <4 x i1> @llvm.experimental.constrained.fcmps.v4f16(<4 x half> %s3, <4 x half> %b, metadata !"one", metadata !"fpexcept.strict")
  %se = sext <4 x i1> %res to <4 x i16>
  %bc = bitcast <4 x i16> %se to <4 x half>
  ret <4 x half> %bc
}

; CHECK-LABEL: fcmp_one_v4e3:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f16v4cmpgt $a4:5, $a1:BU, $a2:3
; CHECK-NEXT:  f16v4cmplt $a0:1, $a1:BU, $a2:3
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  or64 $a0:1, $a0:1, $a4:5
; CHECK-NEXT:  }
define <4 x half> @fcmp_one_v4e3(<4 x half> %a, <4 x half> %b) {
  %e = extractelement <4 x half> %a, i32 3
  %s0 = insertelement <4 x half> undef, half %e, i32 0
  %s1 = insertelement <4 x half> %s0, half %e, i32 1
  %s2 = insertelement <4 x half> %s1, half %e, i32 2
  %s3 = insertelement <4 x half> %s2, half %e, i32 3
  %res = fcmp one <4 x half> %s3, %b
  %se = sext <4 x i1> %res to <4 x i16>
  %bc = bitcast <4 x i16> %se to <4 x half>
  ret <4 x half> %bc
}

; CHECK-LABEL: constrained_fcmps_one_v4e3:
; CHECK:       # %bb.0:
; CHECK-NEXT:  f16v4cmpgt $a4:5, $a1:BU, $a2:3
; CHECK-NEXT:  f16v4cmplt $a0:1, $a1:BU, $a2:3
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  or64 $a0:1, $a0:1, $a4:5
; CHECK-NEXT:  }
define <4 x half> @constrained_fcmps_one_v4e3(<4 x half> %a, <4 x half> %b) {
  %e = extractelement <4 x half> %a, i32 3
  %s0 = insertelement <4 x half> undef, half %e, i32 0
  %s1 = insertelement <4 x half> %s0, half %e, i32 1
  %s2 = insertelement <4 x half> %s1, half %e, i32 2
  %s3 = insertelement <4 x half> %s2, half %e, i32 3
  %res = tail call <4 x i1> @llvm.experimental.constrained.fcmps.v4f16(<4 x half> %s3, <4 x half> %b, metadata !"one", metadata !"fpexcept.strict")
  %se = sext <4 x i1> %res to <4 x i16>
  %bc = bitcast <4 x i16> %se to <4 x half>
  ret <4 x half> %bc
}

; CHECK-LABEL: fcmp_oge_v4e0:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4cmpge $a0:1, $a0:BL, $a2:3
; CHECK-NEXT:  }
define <4 x half> @fcmp_oge_v4e0(<4 x half> %a, <4 x half> %b) {
  %e = extractelement <4 x half> %a, i32 0
  %s0 = insertelement <4 x half> undef, half %e, i32 0
  %s1 = insertelement <4 x half> %s0, half %e, i32 1
  %s2 = insertelement <4 x half> %s1, half %e, i32 2
  %s3 = insertelement <4 x half> %s2, half %e, i32 3
  %res = fcmp oge <4 x half> %s3, %b
  %se = sext <4 x i1> %res to <4 x i16>
  %bc = bitcast <4 x i16> %se to <4 x half>
  ret <4 x half> %bc
}

; CHECK-LABEL: constrained_fcmps_oge_v4e0:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4cmpge $a0:1, $a0:BL, $a2:3
; CHECK-NEXT:  }
define <4 x half> @constrained_fcmps_oge_v4e0(<4 x half> %a, <4 x half> %b) {
  %e = extractelement <4 x half> %a, i32 0
  %s0 = insertelement <4 x half> undef, half %e, i32 0
  %s1 = insertelement <4 x half> %s0, half %e, i32 1
  %s2 = insertelement <4 x half> %s1, half %e, i32 2
  %s3 = insertelement <4 x half> %s2, half %e, i32 3
  %res = tail call <4 x i1> @llvm.experimental.constrained.fcmps.v4f16(<4 x half> %s3, <4 x half> %b, metadata !"oge", metadata !"fpexcept.strict")
  %se = sext <4 x i1> %res to <4 x i16>
  %bc = bitcast <4 x i16> %se to <4 x half>
  ret <4 x half> %bc
}

; CHECK-LABEL: fcmp_oge_v4e1:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4cmpge $a0:1, $a0:BU, $a2:3
; CHECK-NEXT:  }
define <4 x half> @fcmp_oge_v4e1(<4 x half> %a, <4 x half> %b) {
  %e = extractelement <4 x half> %a, i32 1
  %s0 = insertelement <4 x half> undef, half %e, i32 0
  %s1 = insertelement <4 x half> %s0, half %e, i32 1
  %s2 = insertelement <4 x half> %s1, half %e, i32 2
  %s3 = insertelement <4 x half> %s2, half %e, i32 3
  %res = fcmp oge <4 x half> %s3, %b
  %se = sext <4 x i1> %res to <4 x i16>
  %bc = bitcast <4 x i16> %se to <4 x half>
  ret <4 x half> %bc
}

; CHECK-LABEL: constrained_fcmps_oge_v4e1:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4cmpge $a0:1, $a0:BU, $a2:3
; CHECK-NEXT:  }
define <4 x half> @constrained_fcmps_oge_v4e1(<4 x half> %a, <4 x half> %b) {
  %e = extractelement <4 x half> %a, i32 1
  %s0 = insertelement <4 x half> undef, half %e, i32 0
  %s1 = insertelement <4 x half> %s0, half %e, i32 1
  %s2 = insertelement <4 x half> %s1, half %e, i32 2
  %s3 = insertelement <4 x half> %s2, half %e, i32 3
  %res = tail call <4 x i1> @llvm.experimental.constrained.fcmps.v4f16(<4 x half> %s3, <4 x half> %b, metadata !"oge", metadata !"fpexcept.strict")
  %se = sext <4 x i1> %res to <4 x i16>
  %bc = bitcast <4 x i16> %se to <4 x half>
  ret <4 x half> %bc
}

; CHECK-LABEL: fcmp_oge_v4e2:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4cmpge $a0:1, $a1:BL, $a2:3
; CHECK-NEXT:  }
define <4 x half> @fcmp_oge_v4e2(<4 x half> %a, <4 x half> %b) {
  %e = extractelement <4 x half> %a, i32 2
  %s0 = insertelement <4 x half> undef, half %e, i32 0
  %s1 = insertelement <4 x half> %s0, half %e, i32 1
  %s2 = insertelement <4 x half> %s1, half %e, i32 2
  %s3 = insertelement <4 x half> %s2, half %e, i32 3
  %res = fcmp oge <4 x half> %s3, %b
  %se = sext <4 x i1> %res to <4 x i16>
  %bc = bitcast <4 x i16> %se to <4 x half>
  ret <4 x half> %bc
}

; CHECK-LABEL: constrained_fcmps_oge_v4e2:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4cmpge $a0:1, $a1:BL, $a2:3
; CHECK-NEXT:  }
define <4 x half> @constrained_fcmps_oge_v4e2(<4 x half> %a, <4 x half> %b) {
  %e = extractelement <4 x half> %a, i32 2
  %s0 = insertelement <4 x half> undef, half %e, i32 0
  %s1 = insertelement <4 x half> %s0, half %e, i32 1
  %s2 = insertelement <4 x half> %s1, half %e, i32 2
  %s3 = insertelement <4 x half> %s2, half %e, i32 3
  %res = tail call <4 x i1> @llvm.experimental.constrained.fcmps.v4f16(<4 x half> %s3, <4 x half> %b, metadata !"oge", metadata !"fpexcept.strict")
  %se = sext <4 x i1> %res to <4 x i16>
  %bc = bitcast <4 x i16> %se to <4 x half>
  ret <4 x half> %bc
}

; CHECK-LABEL: fcmp_oge_v4e3:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4cmpge $a0:1, $a1:BU, $a2:3
; CHECK-NEXT:  }
define <4 x half> @fcmp_oge_v4e3(<4 x half> %a, <4 x half> %b) {
  %e = extractelement <4 x half> %a, i32 3
  %s0 = insertelement <4 x half> undef, half %e, i32 0
  %s1 = insertelement <4 x half> %s0, half %e, i32 1
  %s2 = insertelement <4 x half> %s1, half %e, i32 2
  %s3 = insertelement <4 x half> %s2, half %e, i32 3
  %res = fcmp oge <4 x half> %s3, %b
  %se = sext <4 x i1> %res to <4 x i16>
  %bc = bitcast <4 x i16> %se to <4 x half>
  ret <4 x half> %bc
}

; CHECK-LABEL: constrained_fcmps_oge_v4e3:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4cmpge $a0:1, $a1:BU, $a2:3
; CHECK-NEXT:  }
define <4 x half> @constrained_fcmps_oge_v4e3(<4 x half> %a, <4 x half> %b) {
  %e = extractelement <4 x half> %a, i32 3
  %s0 = insertelement <4 x half> undef, half %e, i32 0
  %s1 = insertelement <4 x half> %s0, half %e, i32 1
  %s2 = insertelement <4 x half> %s1, half %e, i32 2
  %s3 = insertelement <4 x half> %s2, half %e, i32 3
  %res = tail call <4 x i1> @llvm.experimental.constrained.fcmps.v4f16(<4 x half> %s3, <4 x half> %b, metadata !"oge", metadata !"fpexcept.strict")
  %se = sext <4 x i1> %res to <4 x i16>
  %bc = bitcast <4 x i16> %se to <4 x half>
  ret <4 x half> %bc
}

; CHECK-LABEL: fcmp_ogt_v4e0:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4cmpgt $a0:1, $a0:BL, $a2:3
; CHECK-NEXT:  }
define <4 x half> @fcmp_ogt_v4e0(<4 x half> %a, <4 x half> %b) {
  %e = extractelement <4 x half> %a, i32 0
  %s0 = insertelement <4 x half> undef, half %e, i32 0
  %s1 = insertelement <4 x half> %s0, half %e, i32 1
  %s2 = insertelement <4 x half> %s1, half %e, i32 2
  %s3 = insertelement <4 x half> %s2, half %e, i32 3
  %res = fcmp ogt <4 x half> %s3, %b
  %se = sext <4 x i1> %res to <4 x i16>
  %bc = bitcast <4 x i16> %se to <4 x half>
  ret <4 x half> %bc
}

; CHECK-LABEL: constrained_fcmps_ogt_v4e0:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4cmpgt $a0:1, $a0:BL, $a2:3
; CHECK-NEXT:  }
define <4 x half> @constrained_fcmps_ogt_v4e0(<4 x half> %a, <4 x half> %b) {
  %e = extractelement <4 x half> %a, i32 0
  %s0 = insertelement <4 x half> undef, half %e, i32 0
  %s1 = insertelement <4 x half> %s0, half %e, i32 1
  %s2 = insertelement <4 x half> %s1, half %e, i32 2
  %s3 = insertelement <4 x half> %s2, half %e, i32 3
  %res = tail call <4 x i1> @llvm.experimental.constrained.fcmps.v4f16(<4 x half> %s3, <4 x half> %b, metadata !"ogt", metadata !"fpexcept.strict")
  %se = sext <4 x i1> %res to <4 x i16>
  %bc = bitcast <4 x i16> %se to <4 x half>
  ret <4 x half> %bc
}

; CHECK-LABEL: fcmp_ogt_v4e1:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4cmpgt $a0:1, $a0:BU, $a2:3
; CHECK-NEXT:  }
define <4 x half> @fcmp_ogt_v4e1(<4 x half> %a, <4 x half> %b) {
  %e = extractelement <4 x half> %a, i32 1
  %s0 = insertelement <4 x half> undef, half %e, i32 0
  %s1 = insertelement <4 x half> %s0, half %e, i32 1
  %s2 = insertelement <4 x half> %s1, half %e, i32 2
  %s3 = insertelement <4 x half> %s2, half %e, i32 3
  %res = fcmp ogt <4 x half> %s3, %b
  %se = sext <4 x i1> %res to <4 x i16>
  %bc = bitcast <4 x i16> %se to <4 x half>
  ret <4 x half> %bc
}

; CHECK-LABEL: constrained_fcmps_ogt_v4e1:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4cmpgt $a0:1, $a0:BU, $a2:3
; CHECK-NEXT:  }
define <4 x half> @constrained_fcmps_ogt_v4e1(<4 x half> %a, <4 x half> %b) {
  %e = extractelement <4 x half> %a, i32 1
  %s0 = insertelement <4 x half> undef, half %e, i32 0
  %s1 = insertelement <4 x half> %s0, half %e, i32 1
  %s2 = insertelement <4 x half> %s1, half %e, i32 2
  %s3 = insertelement <4 x half> %s2, half %e, i32 3
  %res = tail call <4 x i1> @llvm.experimental.constrained.fcmps.v4f16(<4 x half> %s3, <4 x half> %b, metadata !"ogt", metadata !"fpexcept.strict")
  %se = sext <4 x i1> %res to <4 x i16>
  %bc = bitcast <4 x i16> %se to <4 x half>
  ret <4 x half> %bc
}

; CHECK-LABEL: fcmp_ogt_v4e2:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4cmpgt $a0:1, $a1:BL, $a2:3
; CHECK-NEXT:  }
define <4 x half> @fcmp_ogt_v4e2(<4 x half> %a, <4 x half> %b) {
  %e = extractelement <4 x half> %a, i32 2
  %s0 = insertelement <4 x half> undef, half %e, i32 0
  %s1 = insertelement <4 x half> %s0, half %e, i32 1
  %s2 = insertelement <4 x half> %s1, half %e, i32 2
  %s3 = insertelement <4 x half> %s2, half %e, i32 3
  %res = fcmp ogt <4 x half> %s3, %b
  %se = sext <4 x i1> %res to <4 x i16>
  %bc = bitcast <4 x i16> %se to <4 x half>
  ret <4 x half> %bc
}

; CHECK-LABEL: constrained_fcmps_ogt_v4e2:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4cmpgt $a0:1, $a1:BL, $a2:3
; CHECK-NEXT:  }
define <4 x half> @constrained_fcmps_ogt_v4e2(<4 x half> %a, <4 x half> %b) {
  %e = extractelement <4 x half> %a, i32 2
  %s0 = insertelement <4 x half> undef, half %e, i32 0
  %s1 = insertelement <4 x half> %s0, half %e, i32 1
  %s2 = insertelement <4 x half> %s1, half %e, i32 2
  %s3 = insertelement <4 x half> %s2, half %e, i32 3
  %res = tail call <4 x i1> @llvm.experimental.constrained.fcmps.v4f16(<4 x half> %s3, <4 x half> %b, metadata !"ogt", metadata !"fpexcept.strict")
  %se = sext <4 x i1> %res to <4 x i16>
  %bc = bitcast <4 x i16> %se to <4 x half>
  ret <4 x half> %bc
}

; CHECK-LABEL: fcmp_ogt_v4e3:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4cmpgt $a0:1, $a1:BU, $a2:3
; CHECK-NEXT:  }
define <4 x half> @fcmp_ogt_v4e3(<4 x half> %a, <4 x half> %b) {
  %e = extractelement <4 x half> %a, i32 3
  %s0 = insertelement <4 x half> undef, half %e, i32 0
  %s1 = insertelement <4 x half> %s0, half %e, i32 1
  %s2 = insertelement <4 x half> %s1, half %e, i32 2
  %s3 = insertelement <4 x half> %s2, half %e, i32 3
  %res = fcmp ogt <4 x half> %s3, %b
  %se = sext <4 x i1> %res to <4 x i16>
  %bc = bitcast <4 x i16> %se to <4 x half>
  ret <4 x half> %bc
}

; CHECK-LABEL: constrained_fcmps_ogt_v4e3:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4cmpgt $a0:1, $a1:BU, $a2:3
; CHECK-NEXT:  }
define <4 x half> @constrained_fcmps_ogt_v4e3(<4 x half> %a, <4 x half> %b) {
  %e = extractelement <4 x half> %a, i32 3
  %s0 = insertelement <4 x half> undef, half %e, i32 0
  %s1 = insertelement <4 x half> %s0, half %e, i32 1
  %s2 = insertelement <4 x half> %s1, half %e, i32 2
  %s3 = insertelement <4 x half> %s2, half %e, i32 3
  %res = tail call <4 x i1> @llvm.experimental.constrained.fcmps.v4f16(<4 x half> %s3, <4 x half> %b, metadata !"ogt", metadata !"fpexcept.strict")
  %se = sext <4 x i1> %res to <4 x i16>
  %bc = bitcast <4 x i16> %se to <4 x half>
  ret <4 x half> %bc
}

; CHECK-LABEL: fcmp_ole_v4e0:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4cmple $a0:1, $a0:BL, $a2:3
; CHECK-NEXT:  }
define <4 x half> @fcmp_ole_v4e0(<4 x half> %a, <4 x half> %b) {
  %e = extractelement <4 x half> %a, i32 0
  %s0 = insertelement <4 x half> undef, half %e, i32 0
  %s1 = insertelement <4 x half> %s0, half %e, i32 1
  %s2 = insertelement <4 x half> %s1, half %e, i32 2
  %s3 = insertelement <4 x half> %s2, half %e, i32 3
  %res = fcmp ole <4 x half> %s3, %b
  %se = sext <4 x i1> %res to <4 x i16>
  %bc = bitcast <4 x i16> %se to <4 x half>
  ret <4 x half> %bc
}

; CHECK-LABEL: constrained_fcmps_ole_v4e0:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4cmple $a0:1, $a0:BL, $a2:3
; CHECK-NEXT:  }
define <4 x half> @constrained_fcmps_ole_v4e0(<4 x half> %a, <4 x half> %b) {
  %e = extractelement <4 x half> %a, i32 0
  %s0 = insertelement <4 x half> undef, half %e, i32 0
  %s1 = insertelement <4 x half> %s0, half %e, i32 1
  %s2 = insertelement <4 x half> %s1, half %e, i32 2
  %s3 = insertelement <4 x half> %s2, half %e, i32 3
  %res = tail call <4 x i1> @llvm.experimental.constrained.fcmps.v4f16(<4 x half> %s3, <4 x half> %b, metadata !"ole", metadata !"fpexcept.strict")
  %se = sext <4 x i1> %res to <4 x i16>
  %bc = bitcast <4 x i16> %se to <4 x half>
  ret <4 x half> %bc
}

; CHECK-LABEL: fcmp_ole_v4e1:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4cmple $a0:1, $a0:BU, $a2:3
; CHECK-NEXT:  }
define <4 x half> @fcmp_ole_v4e1(<4 x half> %a, <4 x half> %b) {
  %e = extractelement <4 x half> %a, i32 1
  %s0 = insertelement <4 x half> undef, half %e, i32 0
  %s1 = insertelement <4 x half> %s0, half %e, i32 1
  %s2 = insertelement <4 x half> %s1, half %e, i32 2
  %s3 = insertelement <4 x half> %s2, half %e, i32 3
  %res = fcmp ole <4 x half> %s3, %b
  %se = sext <4 x i1> %res to <4 x i16>
  %bc = bitcast <4 x i16> %se to <4 x half>
  ret <4 x half> %bc
}

; CHECK-LABEL: constrained_fcmps_ole_v4e1:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4cmple $a0:1, $a0:BU, $a2:3
; CHECK-NEXT:  }
define <4 x half> @constrained_fcmps_ole_v4e1(<4 x half> %a, <4 x half> %b) {
  %e = extractelement <4 x half> %a, i32 1
  %s0 = insertelement <4 x half> undef, half %e, i32 0
  %s1 = insertelement <4 x half> %s0, half %e, i32 1
  %s2 = insertelement <4 x half> %s1, half %e, i32 2
  %s3 = insertelement <4 x half> %s2, half %e, i32 3
  %res = tail call <4 x i1> @llvm.experimental.constrained.fcmps.v4f16(<4 x half> %s3, <4 x half> %b, metadata !"ole", metadata !"fpexcept.strict")
  %se = sext <4 x i1> %res to <4 x i16>
  %bc = bitcast <4 x i16> %se to <4 x half>
  ret <4 x half> %bc
}

; CHECK-LABEL: fcmp_ole_v4e2:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4cmple $a0:1, $a1:BL, $a2:3
; CHECK-NEXT:  }
define <4 x half> @fcmp_ole_v4e2(<4 x half> %a, <4 x half> %b) {
  %e = extractelement <4 x half> %a, i32 2
  %s0 = insertelement <4 x half> undef, half %e, i32 0
  %s1 = insertelement <4 x half> %s0, half %e, i32 1
  %s2 = insertelement <4 x half> %s1, half %e, i32 2
  %s3 = insertelement <4 x half> %s2, half %e, i32 3
  %res = fcmp ole <4 x half> %s3, %b
  %se = sext <4 x i1> %res to <4 x i16>
  %bc = bitcast <4 x i16> %se to <4 x half>
  ret <4 x half> %bc
}

; CHECK-LABEL: constrained_fcmps_ole_v4e2:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4cmple $a0:1, $a1:BL, $a2:3
; CHECK-NEXT:  }
define <4 x half> @constrained_fcmps_ole_v4e2(<4 x half> %a, <4 x half> %b) {
  %e = extractelement <4 x half> %a, i32 2
  %s0 = insertelement <4 x half> undef, half %e, i32 0
  %s1 = insertelement <4 x half> %s0, half %e, i32 1
  %s2 = insertelement <4 x half> %s1, half %e, i32 2
  %s3 = insertelement <4 x half> %s2, half %e, i32 3
  %res = tail call <4 x i1> @llvm.experimental.constrained.fcmps.v4f16(<4 x half> %s3, <4 x half> %b, metadata !"ole", metadata !"fpexcept.strict")
  %se = sext <4 x i1> %res to <4 x i16>
  %bc = bitcast <4 x i16> %se to <4 x half>
  ret <4 x half> %bc
}

; CHECK-LABEL: fcmp_ole_v4e3:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4cmple $a0:1, $a1:BU, $a2:3
; CHECK-NEXT:  }
define <4 x half> @fcmp_ole_v4e3(<4 x half> %a, <4 x half> %b) {
  %e = extractelement <4 x half> %a, i32 3
  %s0 = insertelement <4 x half> undef, half %e, i32 0
  %s1 = insertelement <4 x half> %s0, half %e, i32 1
  %s2 = insertelement <4 x half> %s1, half %e, i32 2
  %s3 = insertelement <4 x half> %s2, half %e, i32 3
  %res = fcmp ole <4 x half> %s3, %b
  %se = sext <4 x i1> %res to <4 x i16>
  %bc = bitcast <4 x i16> %se to <4 x half>
  ret <4 x half> %bc
}

; CHECK-LABEL: constrained_fcmps_ole_v4e3:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4cmple $a0:1, $a1:BU, $a2:3
; CHECK-NEXT:  }
define <4 x half> @constrained_fcmps_ole_v4e3(<4 x half> %a, <4 x half> %b) {
  %e = extractelement <4 x half> %a, i32 3
  %s0 = insertelement <4 x half> undef, half %e, i32 0
  %s1 = insertelement <4 x half> %s0, half %e, i32 1
  %s2 = insertelement <4 x half> %s1, half %e, i32 2
  %s3 = insertelement <4 x half> %s2, half %e, i32 3
  %res = tail call <4 x i1> @llvm.experimental.constrained.fcmps.v4f16(<4 x half> %s3, <4 x half> %b, metadata !"ole", metadata !"fpexcept.strict")
  %se = sext <4 x i1> %res to <4 x i16>
  %bc = bitcast <4 x i16> %se to <4 x half>
  ret <4 x half> %bc
}

; CHECK-LABEL: fcmp_olt_v4e0:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4cmplt $a0:1, $a0:BL, $a2:3
; CHECK-NEXT:  }
define <4 x half> @fcmp_olt_v4e0(<4 x half> %a, <4 x half> %b) {
  %e = extractelement <4 x half> %a, i32 0
  %s0 = insertelement <4 x half> undef, half %e, i32 0
  %s1 = insertelement <4 x half> %s0, half %e, i32 1
  %s2 = insertelement <4 x half> %s1, half %e, i32 2
  %s3 = insertelement <4 x half> %s2, half %e, i32 3
  %res = fcmp olt <4 x half> %s3, %b
  %se = sext <4 x i1> %res to <4 x i16>
  %bc = bitcast <4 x i16> %se to <4 x half>
  ret <4 x half> %bc
}

; CHECK-LABEL: constrained_fcmps_olt_v4e0:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4cmplt $a0:1, $a0:BL, $a2:3
; CHECK-NEXT:  }
define <4 x half> @constrained_fcmps_olt_v4e0(<4 x half> %a, <4 x half> %b) {
  %e = extractelement <4 x half> %a, i32 0
  %s0 = insertelement <4 x half> undef, half %e, i32 0
  %s1 = insertelement <4 x half> %s0, half %e, i32 1
  %s2 = insertelement <4 x half> %s1, half %e, i32 2
  %s3 = insertelement <4 x half> %s2, half %e, i32 3
  %res = tail call <4 x i1> @llvm.experimental.constrained.fcmps.v4f16(<4 x half> %s3, <4 x half> %b, metadata !"olt", metadata !"fpexcept.strict")
  %se = sext <4 x i1> %res to <4 x i16>
  %bc = bitcast <4 x i16> %se to <4 x half>
  ret <4 x half> %bc
}

; CHECK-LABEL: fcmp_olt_v4e1:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4cmplt $a0:1, $a0:BU, $a2:3
; CHECK-NEXT:  }
define <4 x half> @fcmp_olt_v4e1(<4 x half> %a, <4 x half> %b) {
  %e = extractelement <4 x half> %a, i32 1
  %s0 = insertelement <4 x half> undef, half %e, i32 0
  %s1 = insertelement <4 x half> %s0, half %e, i32 1
  %s2 = insertelement <4 x half> %s1, half %e, i32 2
  %s3 = insertelement <4 x half> %s2, half %e, i32 3
  %res = fcmp olt <4 x half> %s3, %b
  %se = sext <4 x i1> %res to <4 x i16>
  %bc = bitcast <4 x i16> %se to <4 x half>
  ret <4 x half> %bc
}

; CHECK-LABEL: constrained_fcmps_olt_v4e1:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4cmplt $a0:1, $a0:BU, $a2:3
; CHECK-NEXT:  }
define <4 x half> @constrained_fcmps_olt_v4e1(<4 x half> %a, <4 x half> %b) {
  %e = extractelement <4 x half> %a, i32 1
  %s0 = insertelement <4 x half> undef, half %e, i32 0
  %s1 = insertelement <4 x half> %s0, half %e, i32 1
  %s2 = insertelement <4 x half> %s1, half %e, i32 2
  %s3 = insertelement <4 x half> %s2, half %e, i32 3
  %res = tail call <4 x i1> @llvm.experimental.constrained.fcmps.v4f16(<4 x half> %s3, <4 x half> %b, metadata !"olt", metadata !"fpexcept.strict")
  %se = sext <4 x i1> %res to <4 x i16>
  %bc = bitcast <4 x i16> %se to <4 x half>
  ret <4 x half> %bc
}

; CHECK-LABEL: fcmp_olt_v4e2:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4cmplt $a0:1, $a1:BL, $a2:3
; CHECK-NEXT:  }
define <4 x half> @fcmp_olt_v4e2(<4 x half> %a, <4 x half> %b) {
  %e = extractelement <4 x half> %a, i32 2
  %s0 = insertelement <4 x half> undef, half %e, i32 0
  %s1 = insertelement <4 x half> %s0, half %e, i32 1
  %s2 = insertelement <4 x half> %s1, half %e, i32 2
  %s3 = insertelement <4 x half> %s2, half %e, i32 3
  %res = fcmp olt <4 x half> %s3, %b
  %se = sext <4 x i1> %res to <4 x i16>
  %bc = bitcast <4 x i16> %se to <4 x half>
  ret <4 x half> %bc
}

; CHECK-LABEL: constrained_fcmps_olt_v4e2:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4cmplt $a0:1, $a1:BL, $a2:3
; CHECK-NEXT:  }
define <4 x half> @constrained_fcmps_olt_v4e2(<4 x half> %a, <4 x half> %b) {
  %e = extractelement <4 x half> %a, i32 2
  %s0 = insertelement <4 x half> undef, half %e, i32 0
  %s1 = insertelement <4 x half> %s0, half %e, i32 1
  %s2 = insertelement <4 x half> %s1, half %e, i32 2
  %s3 = insertelement <4 x half> %s2, half %e, i32 3
  %res = tail call <4 x i1> @llvm.experimental.constrained.fcmps.v4f16(<4 x half> %s3, <4 x half> %b, metadata !"olt", metadata !"fpexcept.strict")
  %se = sext <4 x i1> %res to <4 x i16>
  %bc = bitcast <4 x i16> %se to <4 x half>
  ret <4 x half> %bc
}

; CHECK-LABEL: fcmp_olt_v4e3:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4cmplt $a0:1, $a1:BU, $a2:3
; CHECK-NEXT:  }
define <4 x half> @fcmp_olt_v4e3(<4 x half> %a, <4 x half> %b) {
  %e = extractelement <4 x half> %a, i32 3
  %s0 = insertelement <4 x half> undef, half %e, i32 0
  %s1 = insertelement <4 x half> %s0, half %e, i32 1
  %s2 = insertelement <4 x half> %s1, half %e, i32 2
  %s3 = insertelement <4 x half> %s2, half %e, i32 3
  %res = fcmp olt <4 x half> %s3, %b
  %se = sext <4 x i1> %res to <4 x i16>
  %bc = bitcast <4 x i16> %se to <4 x half>
  ret <4 x half> %bc
}

; CHECK-LABEL: constrained_fcmps_olt_v4e3:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f16v4cmplt $a0:1, $a1:BU, $a2:3
; CHECK-NEXT:  }
define <4 x half> @constrained_fcmps_olt_v4e3(<4 x half> %a, <4 x half> %b) {
  %e = extractelement <4 x half> %a, i32 3
  %s0 = insertelement <4 x half> undef, half %e, i32 0
  %s1 = insertelement <4 x half> %s0, half %e, i32 1
  %s2 = insertelement <4 x half> %s1, half %e, i32 2
  %s3 = insertelement <4 x half> %s2, half %e, i32 3
  %res = tail call <4 x i1> @llvm.experimental.constrained.fcmps.v4f16(<4 x half> %s3, <4 x half> %b, metadata !"olt", metadata !"fpexcept.strict")
  %se = sext <4 x i1> %res to <4 x i16>
  %bc = bitcast <4 x i16> %se to <4 x half>
  ret <4 x half> %bc
}
