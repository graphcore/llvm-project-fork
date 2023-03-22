; RUN: llc < %s -march=colossus -mattr=+supervisor,ipu1 | FileCheck %s
; RUN: llc < %s -march=colossus -mattr=+supervisor,ipu2 | FileCheck %s

declare i1 @llvm.experimental.constrained.fcmps.f32(float, float, metadata, metadata)

; Test lowering of SELECT_F32 pseudo with custom inserter.

; CHECK-LABEL: select_reg:
; CHECK:       movnz	$m2, $m0, $m1
; CHECK-NEXT:  mov	$m0, $m2
; CHECK-NEXT:  br $m10
define float @select_reg(i1 %cond, float %t, float %f) {
  %1 = select i1 %cond, float %t, float %f
  ret float %1
}

; CHECK-LABEL: select_fcmp:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -16
; CHECK:       st32 $m8, $m11, $m15, 3         # 4-byte Folded Spill
; CHECK-NEXT:  st32 $m10, $m11, $m15, 2        # 4-byte Folded Spill
; CHECK-NEXT:  st32 $m7, $m11, $m15, 1         # 4-byte Folded Spill
; CHECK-NEXT:  mov	$m7, $m3
; CHECK-NEXT:  mov	$m8, $m2
; CHECK-NEXT:  call $m10, __eqsf2
; CHECK-NEXT:  cmpeq $m0, $m0, 0
; CHECK-NEXT:  movnz	$m7, $m0, $m8
; CHECK-NEXT:  mov	$m0, $m7
; CHECK-NEXT:  ld32 $m7, $m11, $m15, 1         # 4-byte Folded Reload
; CHECK-NEXT:  ld32 $m10, $m11, $m15, 2        # 4-byte Folded Reload
; CHECK-NEXT:  ld32 $m8, $m11, $m15, 3         # 4-byte Folded Reload
; CHECK-NEXT:  add $m11, $m11, 16
define float @select_fcmp(float %lhs, float %rhs, float %t, float %f) {
  %1 = fcmp oeq float %lhs, %rhs
  %2 = select i1 %1, float %t, float %f
  ret float %2
}

; CHECK-LABEL: constrained_select_fcmp:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -16
; CHECK:       st32 $m8, $m11, $m15, 3         # 4-byte Folded Spill
; CHECK-NEXT:  st32 $m10, $m11, $m15, 2        # 4-byte Folded Spill
; CHECK-NEXT:  st32 $m7, $m11, $m15, 1         # 4-byte Folded Spill
; CHECK-NEXT:  mov	$m7, $m3
; CHECK-NEXT:  mov	$m8, $m2
; CHECK-NEXT:  call $m10, __eqsf2
; CHECK-NEXT:  cmpeq $m0, $m0, 0
; CHECK-NEXT:  movnz	$m7, $m0, $m8
; CHECK-NEXT:  mov	$m0, $m7
; CHECK-NEXT:  ld32 $m7, $m11, $m15, 1         # 4-byte Folded Reload
; CHECK-NEXT:  ld32 $m10, $m11, $m15, 2        # 4-byte Folded Reload
; CHECK-NEXT:  ld32 $m8, $m11, $m15, 3         # 4-byte Folded Reload
; CHECK-NEXT:  add $m11, $m11, 16
define float @constrained_select_fcmp(float %lhs, float %rhs, float %t, float %f) {
  %1 = tail call i1 @llvm.experimental.constrained.fcmps.f32(float %lhs, float %rhs, metadata !"oeq", metadata !"fpexcept.strict")
  %2 = select i1 %1, float %t, float %f
  ret float %2
}

; See fp-comparisons for other comparisons, olt, ogt, ult, ugt etc.
