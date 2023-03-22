; RUN: llc < %s -march=colossus -mattr=+supervisor,+ipu1 | FileCheck %s
; RUN: llc < %s -march=colossus -mattr=+supervisor,+ipu1 -enable-no-infs-fp-math | FileCheck %s
; RUN: llc < %s -march=colossus -mattr=+supervisor,+ipu1 -enable-no-signed-zeros-fp-math | FileCheck %s

; RUN: llc < %s -march=colossus -mattr=+supervisor,+ipu2 | FileCheck %s
; RUN: llc < %s -march=colossus -mattr=+supervisor,+ipu2 -enable-no-infs-fp-math | FileCheck %s
; RUN: llc < %s -march=colossus -mattr=+supervisor,+ipu2 -enable-no-signed-zeros-fp-math | FileCheck %s

target triple = "colossus-graphcore--elf"

declare i1 @llvm.experimental.constrained.fcmps.f16(half, half, metadata, metadata)

; CHECK-LABEL: fcmp_false_f16:
; CHECK:      mov $m0, $m15
; CHECK-NEXT: br $m10
define i1 @fcmp_false_f16(half %lhs, half %rhs) {
  %retval = fcmp false half %lhs, %rhs
  ret i1 %retval
}

; CHECK-LABEL: fcmp_oeq_f16:
; CHECK:       add $m11, $m11, -16
; CHECK-NEXT: .cfi_def_cfa_offset 16
; CHECK-NEXT: .cfi_offset $m8, -4
; CHECK-NEXT: .cfi_offset $m10, -8
; CHECK-NEXT: .cfi_offset $m7, -12
; CHECK-NEXT: st32 $m8, $m11, $m15, 3                 # 4-byte Folded Spill
; CHECK-NEXT: st32 $m10, $m11, $m15, 2                # 4-byte Folded Spill
; CHECK-NEXT: st32 $m7, $m11, $m15, 1                 # 4-byte Folded Spill
; CHECK-NEXT: mov	$m7, $m1
; CHECK-NEXT: sort4x16lo $m0, $m0, $m15
; CHECK-NEXT: call $m10, __gnu_h2f_ieee
; CHECK-NEXT: mov	$m8, $m0
; CHECK-NEXT: sort4x16lo $m0, $m7, $m15
; CHECK-NEXT: call $m10, __gnu_h2f_ieee
; CHECK-NEXT: mov	$m1, $m0
; CHECK-NEXT: mov	$m0, $m8
; CHECK-NEXT: call $m10, __eqsf2
; CHECK-NEXT: cmpeq $m0, $m0, 0
; CHECK-NEXT: ld32 $m7, $m11, $m15, 1                 # 4-byte Folded Reload
; CHECK-NEXT: ld32 $m10, $m11, $m15, 2                # 4-byte Folded Reload
; CHECK-NEXT: ld32 $m8, $m11, $m15, 3                 # 4-byte Folded Reload
; CHECK-NEXT: add $m11, $m11, 16
; CHECK-NEXT: .cfi_def_cfa_offset 0
; CHECK-NEXT: br $m10
define i1 @fcmp_oeq_f16(half %lhs, half %rhs) {
  %retval = fcmp oeq half %lhs, %rhs
  ret i1 %retval
}

; CHECK-LABEL: constrained_fcmps_oeq_f16:
; CHECK:       add $m11, $m11, -16
; CHECK-NEXT: .cfi_def_cfa_offset 16
; CHECK-NEXT: .cfi_offset $m8, -4
; CHECK-NEXT: .cfi_offset $m10, -8
; CHECK-NEXT: .cfi_offset $m7, -12
; CHECK-NEXT: st32 $m8, $m11, $m15, 3                 # 4-byte Folded Spill
; CHECK-NEXT: st32 $m10, $m11, $m15, 2                # 4-byte Folded Spill
; CHECK-NEXT: st32 $m7, $m11, $m15, 1                 # 4-byte Folded Spill
; CHECK-NEXT: mov     $m7, $m0
; CHECK-NEXT: sort4x16lo $m0, $m1, $m15
; CHECK-NEXT: call $m10, __gnu_h2f_ieee
; CHECK-NEXT: mov     $m8, $m0
; CHECK-NEXT: sort4x16lo $m0, $m7, $m15
; CHECK-NEXT: call $m10, __gnu_h2f_ieee
; CHECK-NEXT: mov     $m1, $m8
; CHECK-NEXT: call $m10, __eqsf2
; CHECK-NEXT: cmpeq $m0, $m0, 0
; CHECK-NEXT: ld32 $m7, $m11, $m15, 1                 # 4-byte Folded Reload
; CHECK-NEXT: ld32 $m10, $m11, $m15, 2                # 4-byte Folded Reload
; CHECK-NEXT: ld32 $m8, $m11, $m15, 3                 # 4-byte Folded Reload
; CHECK-NEXT: add $m11, $m11, 16
; CHECK-NEXT: .cfi_def_cfa_offset 0
; CHECK-NEXT: br $m10
define i1 @constrained_fcmps_oeq_f16(half %lhs, half %rhs) {
  %retval = tail call i1 @llvm.experimental.constrained.fcmps.f16(half %lhs, half %rhs, metadata !"oeq", metadata !"fpexcept.strict")
  ret i1 %retval
}

; CHECK-LABEL: fcmp_ogt_f16:
; CHECK:      add $m11, $m11, -16
; CHECK-NEXT: .cfi_def_cfa_offset 16
; CHECK-NEXT: .cfi_offset $m8, -4
; CHECK-NEXT: .cfi_offset $m10, -8
; CHECK-NEXT: .cfi_offset $m7, -12
; CHECK-NEXT: st32 $m8, $m11, $m15, 3                 # 4-byte Folded Spill
; CHECK-NEXT: st32 $m10, $m11, $m15, 2                # 4-byte Folded Spill
; CHECK-NEXT: st32 $m7, $m11, $m15, 1                 # 4-byte Folded Spill
; CHECK-NEXT: mov	$m7, $m1
; CHECK-NEXT: sort4x16lo $m0, $m0, $m15
; CHECK-NEXT: call $m10, __gnu_h2f_ieee
; CHECK-NEXT: mov	$m8, $m0
; CHECK-NEXT: sort4x16lo $m0, $m7, $m15
; CHECK-NEXT: call $m10, __gnu_h2f_ieee
; CHECK-NEXT: mov	$m1, $m0
; CHECK-NEXT: mov	$m0, $m8
; CHECK-NEXT: call $m10, __gtsf2
; CHECK-NEXT: cmpslt $m0, $m15, $m0
; CHECK-NEXT: ld32 $m7, $m11, $m15, 1                 # 4-byte Folded Reload
; CHECK-NEXT: ld32 $m10, $m11, $m15, 2                # 4-byte Folded Reload
; CHECK-NEXT: ld32 $m8, $m11, $m15, 3                 # 4-byte Folded Reload
; CHECK-NEXT: add $m11, $m11, 16
; CHECK-NEXT: .cfi_def_cfa_offset 0
; CHECK-NEXT: br $m10
define i1 @fcmp_ogt_f16(half %lhs, half %rhs) {
  %retval = fcmp ogt half %lhs, %rhs
  ret i1 %retval
}

; CHECK-LABEL: constrained_fcmps_ogt_f16:
; CHECK:      add $m11, $m11, -16
; CHECK-NEXT: .cfi_def_cfa_offset 16
; CHECK-NEXT: .cfi_offset $m8, -4
; CHECK-NEXT: .cfi_offset $m10, -8
; CHECK-NEXT: .cfi_offset $m7, -12
; CHECK-NEXT: st32 $m8, $m11, $m15, 3                 # 4-byte Folded Spill
; CHECK-NEXT: st32 $m10, $m11, $m15, 2                # 4-byte Folded Spill
; CHECK-NEXT: st32 $m7, $m11, $m15, 1                 # 4-byte Folded Spill
; CHECK-NEXT: mov     $m7, $m0
; CHECK-NEXT: sort4x16lo $m0, $m1, $m15
; CHECK-NEXT: call $m10, __gnu_h2f_ieee
; CHECK-NEXT: mov     $m8, $m0
; CHECK-NEXT: sort4x16lo $m0, $m7, $m15
; CHECK-NEXT: call $m10, __gnu_h2f_ieee
; CHECK-NEXT: mov     $m1, $m8
; CHECK-NEXT: call $m10, __gtsf2
; CHECK-NEXT: cmpslt $m0, $m15, $m0
; CHECK-NEXT: ld32 $m7, $m11, $m15, 1                 # 4-byte Folded Reload
; CHECK-NEXT: ld32 $m10, $m11, $m15, 2                # 4-byte Folded Reload
; CHECK-NEXT: ld32 $m8, $m11, $m15, 3                 # 4-byte Folded Reload
; CHECK-NEXT: add $m11, $m11, 16
; CHECK-NEXT: .cfi_def_cfa_offset 0
; CHECK-NEXT: br $m10
define i1 @constrained_fcmps_ogt_f16(half %lhs, half %rhs) {
  %retval = tail call i1 @llvm.experimental.constrained.fcmps.f16(half %lhs, half %rhs, metadata !"ogt", metadata !"fpexcept.strict")
  ret i1 %retval
}

; CHECK-LABEL: fcmp_oge_f16:
; CHECK:      add $m11, $m11, -16
; CHECK-NEXT: .cfi_def_cfa_offset 16
; CHECK-NEXT: .cfi_offset $m8, -4
; CHECK-NEXT: .cfi_offset $m10, -8
; CHECK-NEXT: .cfi_offset $m7, -12
; CHECK-NEXT: st32 $m8, $m11, $m15, 3                 # 4-byte Folded Spill
; CHECK-NEXT: st32 $m10, $m11, $m15, 2                # 4-byte Folded Spill
; CHECK-NEXT: st32 $m7, $m11, $m15, 1                 # 4-byte Folded Spill
; CHECK-NEXT: mov	$m7, $m1
; CHECK-NEXT: sort4x16lo $m0, $m0, $m15
; CHECK-NEXT: call $m10, __gnu_h2f_ieee
; CHECK-NEXT: mov	$m8, $m0
; CHECK-NEXT: sort4x16lo $m0, $m7, $m15
; CHECK-NEXT: call $m10, __gnu_h2f_ieee
; CHECK-NEXT: mov	$m1, $m0
; CHECK-NEXT: mov	$m0, $m8
; CHECK-NEXT: call $m10, __gesf2
; CHECK-NEXT: add $m1, $m15, -1
; CHECK-NEXT: cmpslt $m0, $m1, $m0
; CHECK-NEXT: ld32 $m7, $m11, $m15, 1                 # 4-byte Folded Reload
; CHECK-NEXT: ld32 $m10, $m11, $m15, 2                # 4-byte Folded Reload
; CHECK-NEXT: ld32 $m8, $m11, $m15, 3                 # 4-byte Folded Reload
; CHECK-NEXT: add $m11, $m11, 16
; CHECK-NEXT: .cfi_def_cfa_offset 0
; CHECK-NEXT: br $m10
define i1 @fcmp_oge_f16(half %lhs, half %rhs) {
  %retval = fcmp oge half %lhs, %rhs
  ret i1 %retval
}

; CHECK-LABEL: constrained_fcmps_oge_f16:
; CHECK:      add $m11, $m11, -16
; CHECK-NEXT: .cfi_def_cfa_offset 16
; CHECK-NEXT: .cfi_offset $m8, -4
; CHECK-NEXT: .cfi_offset $m10, -8
; CHECK-NEXT: .cfi_offset $m7, -12
; CHECK-NEXT: st32 $m8, $m11, $m15, 3                 # 4-byte Folded Spill
; CHECK-NEXT: st32 $m10, $m11, $m15, 2                # 4-byte Folded Spill
; CHECK-NEXT: st32 $m7, $m11, $m15, 1                 # 4-byte Folded Spill
; CHECK-NEXT: mov	$m7, $m0
; CHECK-NEXT: sort4x16lo $m0, $m1, $m15
; CHECK-NEXT: call $m10, __gnu_h2f_ieee
; CHECK-NEXT: mov	$m8, $m0
; CHECK-NEXT: sort4x16lo $m0, $m7, $m15
; CHECK-NEXT: call $m10, __gnu_h2f_ieee
; CHECK-NEXT: mov	$m1, $m8
; CHECK-NEXT: call $m10, __gesf2
; CHECK-NEXT: add $m1, $m15, -1
; CHECK-NEXT: cmpslt $m0, $m1, $m0
; CHECK-NEXT: ld32 $m7, $m11, $m15, 1                 # 4-byte Folded Reload
; CHECK-NEXT: ld32 $m10, $m11, $m15, 2                # 4-byte Folded Reload
; CHECK-NEXT: ld32 $m8, $m11, $m15, 3                 # 4-byte Folded Reload
; CHECK-NEXT: add $m11, $m11, 16
; CHECK-NEXT: .cfi_def_cfa_offset 0
; CHECK-NEXT: br $m10
define i1 @constrained_fcmps_oge_f16(half %lhs, half %rhs) {
  %retval = tail call i1 @llvm.experimental.constrained.fcmps.f16(half %lhs, half %rhs, metadata !"oge", metadata !"fpexcept.strict")
  ret i1 %retval
}

; CHECK-LABEL: fcmp_olt_f16:
; CHECK:      add $m11, $m11, -16
; CHECK-NEXT: .cfi_def_cfa_offset 16
; CHECK-NEXT: .cfi_offset $m8, -4
; CHECK-NEXT: .cfi_offset $m10, -8
; CHECK-NEXT: .cfi_offset $m7, -12
; CHECK-NEXT: st32 $m8, $m11, $m15, 3                 # 4-byte Folded Spill
; CHECK-NEXT: st32 $m10, $m11, $m15, 2                # 4-byte Folded Spill
; CHECK-NEXT: st32 $m7, $m11, $m15, 1                 # 4-byte Folded Spill
; CHECK-NEXT: mov	$m7, $m1
; CHECK-NEXT: sort4x16lo $m0, $m0, $m15
; CHECK-NEXT: call $m10, __gnu_h2f_ieee
; CHECK-NEXT: mov	$m8, $m0
; CHECK-NEXT: sort4x16lo $m0, $m7, $m15
; CHECK-NEXT: call $m10, __gnu_h2f_ieee
; CHECK-NEXT: mov	$m1, $m0
; CHECK-NEXT: mov	$m0, $m8
; CHECK-NEXT: call $m10, __ltsf2
; CHECK-NEXT: cmpslt $m0, $m0, 0
; CHECK-NEXT: ld32 $m7, $m11, $m15, 1                 # 4-byte Folded Reload
; CHECK-NEXT: ld32 $m10, $m11, $m15, 2                # 4-byte Folded Reload
; CHECK-NEXT: ld32 $m8, $m11, $m15, 3                 # 4-byte Folded Reload
; CHECK-NEXT: add $m11, $m11, 16
; CHECK-NEXT: .cfi_def_cfa_offset 0
; CHECK-NEXT: br $m10
define i1 @fcmp_olt_f16(half %lhs, half %rhs) {
  %retval = fcmp olt half %lhs, %rhs
  ret i1 %retval
}

; CHECK-LABEL: constrained_fcmps_olt_f16:
; CHECK:      add $m11, $m11, -16
; CHECK-NEXT: .cfi_def_cfa_offset 16
; CHECK-NEXT: .cfi_offset $m8, -4
; CHECK-NEXT: .cfi_offset $m10, -8
; CHECK-NEXT: .cfi_offset $m7, -12
; CHECK-NEXT: st32 $m8, $m11, $m15, 3                 # 4-byte Folded Spill
; CHECK-NEXT: st32 $m10, $m11, $m15, 2                # 4-byte Folded Spill
; CHECK-NEXT: st32 $m7, $m11, $m15, 1                 # 4-byte Folded Spill
; CHECK-NEXT: mov     $m7, $m0
; CHECK-NEXT: sort4x16lo $m0, $m1, $m15
; CHECK-NEXT: call $m10, __gnu_h2f_ieee
; CHECK-NEXT: mov     $m8, $m0
; CHECK-NEXT: sort4x16lo $m0, $m7, $m15
; CHECK-NEXT: call $m10, __gnu_h2f_ieee
; CHECK-NEXT: mov     $m1, $m8
; CHECK-NEXT: call $m10, __ltsf2
; CHECK-NEXT: cmpslt $m0, $m0, 0
; CHECK-NEXT: ld32 $m7, $m11, $m15, 1                 # 4-byte Folded Reload
; CHECK-NEXT: ld32 $m10, $m11, $m15, 2                # 4-byte Folded Reload
; CHECK-NEXT: ld32 $m8, $m11, $m15, 3                 # 4-byte Folded Reload
; CHECK-NEXT: add $m11, $m11, 16
; CHECK-NEXT: .cfi_def_cfa_offset 0
; CHECK-NEXT: br $m10
define i1 @constrained_fcmps_olt_f16(half %lhs, half %rhs) {
  %retval = tail call i1 @llvm.experimental.constrained.fcmps.f16(half %lhs, half %rhs, metadata !"olt", metadata !"fpexcept.strict")
  ret i1 %retval
}

; CHECK-LABEL: fcmp_ole_f16:
; CHECK:      add $m11, $m11, -16
; CHECK-NEXT: .cfi_def_cfa_offset 16
; CHECK-NEXT: .cfi_offset $m8, -4
; CHECK-NEXT: .cfi_offset $m10, -8
; CHECK-NEXT: .cfi_offset $m7, -12
; CHECK-NEXT: st32 $m8, $m11, $m15, 3                 # 4-byte Folded Spill
; CHECK-NEXT: st32 $m10, $m11, $m15, 2                # 4-byte Folded Spill
; CHECK-NEXT: st32 $m7, $m11, $m15, 1                 # 4-byte Folded Spill
; CHECK-NEXT: mov	$m7, $m1
; CHECK-NEXT: sort4x16lo $m0, $m0, $m15
; CHECK-NEXT: call $m10, __gnu_h2f_ieee
; CHECK-NEXT: mov	$m8, $m0
; CHECK-NEXT: sort4x16lo $m0, $m7, $m15
; CHECK-NEXT: call $m10, __gnu_h2f_ieee
; CHECK-NEXT: mov	$m1, $m0
; CHECK-NEXT: mov	$m0, $m8
; CHECK-NEXT: call $m10, __lesf2
; CHECK-NEXT: cmpslt $m0, $m0, 1
; CHECK-NEXT: ld32 $m7, $m11, $m15, 1                 # 4-byte Folded Reload
; CHECK-NEXT: ld32 $m10, $m11, $m15, 2                # 4-byte Folded Reload
; CHECK-NEXT: ld32 $m8, $m11, $m15, 3                 # 4-byte Folded Reload
; CHECK-NEXT: add $m11, $m11, 16
; CHECK-NEXT: .cfi_def_cfa_offset 0
; CHECK-NEXT: br $m10
define i1 @fcmp_ole_f16(half %lhs, half %rhs) {
  %retval = fcmp ole half %lhs, %rhs
  ret i1 %retval
}

; CHECK-LABEL: constrained_fcmps_ole_f16:
; CHECK:      add $m11, $m11, -16
; CHECK-NEXT: .cfi_def_cfa_offset 16
; CHECK-NEXT: .cfi_offset $m8, -4
; CHECK-NEXT: .cfi_offset $m10, -8
; CHECK-NEXT: .cfi_offset $m7, -12
; CHECK-NEXT: st32 $m8, $m11, $m15, 3                 # 4-byte Folded Spill
; CHECK-NEXT: st32 $m10, $m11, $m15, 2                # 4-byte Folded Spill
; CHECK-NEXT: st32 $m7, $m11, $m15, 1                 # 4-byte Folded Spill
; CHECK-NEXT: mov     $m7, $m0
; CHECK-NEXT: sort4x16lo $m0, $m1, $m15
; CHECK-NEXT: call $m10, __gnu_h2f_ieee
; CHECK-NEXT: mov     $m8, $m0
; CHECK-NEXT: sort4x16lo $m0, $m7, $m15
; CHECK-NEXT: call $m10, __gnu_h2f_ieee
; CHECK-NEXT: mov     $m1, $m8
; CHECK-NEXT: call $m10, __lesf2
; CHECK-NEXT: cmpslt $m0, $m0, 1
; CHECK-NEXT: ld32 $m7, $m11, $m15, 1                 # 4-byte Folded Reload
; CHECK-NEXT: ld32 $m10, $m11, $m15, 2                # 4-byte Folded Reload
; CHECK-NEXT: ld32 $m8, $m11, $m15, 3                 # 4-byte Folded Reload
; CHECK-NEXT: add $m11, $m11, 16
; CHECK-NEXT: .cfi_def_cfa_offset 0
; CHECK-NEXT: br $m10
define i1 @constrained_fcmps_ole_f16(half %lhs, half %rhs) {
  %retval = tail call i1 @llvm.experimental.constrained.fcmps.f16(half %lhs, half %rhs, metadata !"ole", metadata !"fpexcept.strict")
  ret i1 %retval
}

; CHECK-LABEL: fcmp_one_f16:
; CHECK:       add $m11, $m11, -16
; CHECK-NEXT: .cfi_def_cfa_offset 16
; CHECK-NEXT: .cfi_offset $m8, -4
; CHECK-NEXT: .cfi_offset $m9, -8
; CHECK-NEXT: .cfi_offset $m10, -12
; CHECK-NEXT: .cfi_offset $m7, -16
; CHECK-NEXT: st32 $m8, $m11, $m15, 3                 # 4-byte Folded Spill
; CHECK-NEXT: st32 $m9, $m11, $m15, 2                 # 4-byte Folded Spill
; CHECK-NEXT: st32 $m10, $m11, $m15, 1                # 4-byte Folded Spill
; CHECK-NEXT: st32 $m7, $m11, $m15, 0                 # 4-byte Folded Spill
; CHECK-NEXT: mov	$m7, $m1
; CHECK-NEXT: sort4x16lo $m0, $m0, $m15
; CHECK-NEXT: call $m10, __gnu_h2f_ieee
; CHECK-NEXT: mov	$m8, $m0
; CHECK-NEXT: sort4x16lo $m0, $m7, $m15
; CHECK-NEXT: call $m10, __gnu_h2f_ieee
; CHECK-NEXT: mov	$m7, $m0
; CHECK-NEXT: mov	$m0, $m8
; CHECK-NEXT: mov	$m1, $m7
; CHECK-NEXT: call $m10, __eqsf2
; CHECK-NEXT: cmpne $m9, $m0, $m15
; CHECK-NEXT: mov	$m0, $m8
; CHECK-NEXT: mov	$m1, $m7
; CHECK-NEXT: call $m10, __unordsf2
; CHECK-NEXT: cmpeq $m0, $m0, 0
; CHECK-NEXT: and $m0, $m0, $m9
; CHECK-NEXT: ld32 $m7, $m11, $m15, 0                 # 4-byte Folded Reload
; CHECK-NEXT: ld32 $m10, $m11, $m15, 1                # 4-byte Folded Reload
; CHECK-NEXT: ld32 $m9, $m11, $m15, 2                 # 4-byte Folded Reload
; CHECK-NEXT: ld32 $m8, $m11, $m15, 3                 # 4-byte Folded Reload
; CHECK-NEXT: add $m11, $m11, 16
; CHECK-NEXT: .cfi_def_cfa_offset 0
; CHECK-NEXT: br $m10
define i1 @fcmp_one_f16(half %lhs, half %rhs) {
  %retval = fcmp one half %lhs, %rhs
  ret i1 %retval
}

; CHECK-LABEL: constrained_fcmps_one_f16:
; CHECK:       add $m11, $m11, -16
; CHECK-NEXT: .cfi_def_cfa_offset 16
; CHECK-NEXT: .cfi_offset $m8, -4
; CHECK-NEXT: .cfi_offset $m9, -8
; CHECK-NEXT: .cfi_offset $m10, -12
; CHECK-NEXT: .cfi_offset $m7, -16
; CHECK-NEXT: st32 $m8, $m11, $m15, 3                 # 4-byte Folded Spill
; CHECK-NEXT: st32 $m9, $m11, $m15, 2                 # 4-byte Folded Spill
; CHECK-NEXT: st32 $m10, $m11, $m15, 1                # 4-byte Folded Spill
; CHECK-NEXT: st32 $m7, $m11, $m15, 0                 # 4-byte Folded Spill
; CHECK-NEXT: mov     $m7, $m0
; CHECK-NEXT: sort4x16lo $m0, $m1, $m15
; CHECK-NEXT: call $m10, __gnu_h2f_ieee
; CHECK-NEXT: mov     $m8, $m0
; CHECK-NEXT: sort4x16lo $m0, $m7, $m15
; CHECK-NEXT: call $m10, __gnu_h2f_ieee
; CHECK-NEXT: mov     $m7, $m0
; CHECK-NEXT: mov     $m1, $m8
; CHECK-NEXT: call $m10, __eqsf2
; CHECK-NEXT: cmpne $m9, $m0, $m15
; CHECK-NEXT: mov     $m0, $m7
; CHECK-NEXT: mov     $m1, $m8
; CHECK-NEXT: call $m10, __unordsf2
; CHECK-NEXT: cmpeq $m0, $m0, 0
; CHECK-NEXT: and $m0, $m0, $m9
; CHECK-NEXT: ld32 $m7, $m11, $m15, 0                 # 4-byte Folded Reload
; CHECK-NEXT: ld32 $m10, $m11, $m15, 1                # 4-byte Folded Reload
; CHECK-NEXT: ld32 $m9, $m11, $m15, 2                 # 4-byte Folded Reload
; CHECK-NEXT: ld32 $m8, $m11, $m15, 3                 # 4-byte Folded Reload
; CHECK-NEXT: add $m11, $m11, 16
; CHECK-NEXT: .cfi_def_cfa_offset 0
; CHECK-NEXT: br $m10
define i1 @constrained_fcmps_one_f16(half %lhs, half %rhs) {
  %retval = tail call i1 @llvm.experimental.constrained.fcmps.f16(half %lhs, half %rhs, metadata !"one", metadata !"fpexcept.strict")
  ret i1 %retval
}

; CHECK-LABEL: fcmp_ord_f16:
; CHECK:      add $m11, $m11, -16
; CHECK-NEXT: .cfi_def_cfa_offset 16
; CHECK-NEXT: .cfi_offset $m8, -4
; CHECK-NEXT: .cfi_offset $m10, -8
; CHECK-NEXT: .cfi_offset $m7, -12
; CHECK-NEXT: st32 $m8, $m11, $m15, 3                 # 4-byte Folded Spill
; CHECK-NEXT: st32 $m10, $m11, $m15, 2                # 4-byte Folded Spill
; CHECK-NEXT: st32 $m7, $m11, $m15, 1                 # 4-byte Folded Spill
; CHECK-NEXT: mov	$m7, $m1
; CHECK-NEXT: sort4x16lo $m0, $m0, $m15
; CHECK-NEXT: call $m10, __gnu_h2f_ieee
; CHECK-NEXT: mov	$m8, $m0
; CHECK-NEXT: sort4x16lo $m0, $m7, $m15
; CHECK-NEXT: call $m10, __gnu_h2f_ieee
; CHECK-NEXT: mov	$m1, $m0
; CHECK-NEXT: mov	$m0, $m8
; CHECK-NEXT: call $m10, __unordsf2
; CHECK-NEXT: cmpeq $m0, $m0, 0
; CHECK-NEXT: ld32 $m7, $m11, $m15, 1                 # 4-byte Folded Reload
; CHECK-NEXT: ld32 $m10, $m11, $m15, 2                # 4-byte Folded Reload
; CHECK-NEXT: ld32 $m8, $m11, $m15, 3                 # 4-byte Folded Reload
; CHECK-NEXT: add $m11, $m11, 16
; CHECK-NEXT: .cfi_def_cfa_offset 0
; CHECK-NEXT: br $m10
define i1 @fcmp_ord_f16(half %lhs, half %rhs) {
  %retval = fcmp ord half %lhs, %rhs
  ret i1 %retval
}

; CHECK-LABEL: constrained_fcmps_ord_f16:
; CHECK:      add $m11, $m11, -16
; CHECK-NEXT: .cfi_def_cfa_offset 16
; CHECK-NEXT: .cfi_offset $m8, -4
; CHECK-NEXT: .cfi_offset $m10, -8
; CHECK-NEXT: .cfi_offset $m7, -12
; CHECK-NEXT: st32 $m8, $m11, $m15, 3                 # 4-byte Folded Spill
; CHECK-NEXT: st32 $m10, $m11, $m15, 2                # 4-byte Folded Spill
; CHECK-NEXT: st32 $m7, $m11, $m15, 1                 # 4-byte Folded Spill
; CHECK-NEXT: mov     $m7, $m0
; CHECK-NEXT: sort4x16lo $m0, $m1, $m15
; CHECK-NEXT: call $m10, __gnu_h2f_ieee
; CHECK-NEXT: mov     $m8, $m0
; CHECK-NEXT: sort4x16lo $m0, $m7, $m15
; CHECK-NEXT: call $m10, __gnu_h2f_ieee
; CHECK-NEXT: mov     $m1, $m8
; CHECK-NEXT: call $m10, __unordsf2
; CHECK-NEXT: cmpeq $m0, $m0, 0
; CHECK-NEXT: ld32 $m7, $m11, $m15, 1                 # 4-byte Folded Reload
; CHECK-NEXT: ld32 $m10, $m11, $m15, 2                # 4-byte Folded Reload
; CHECK-NEXT: ld32 $m8, $m11, $m15, 3                 # 4-byte Folded Reload
; CHECK-NEXT: add $m11, $m11, 16
; CHECK-NEXT: .cfi_def_cfa_offset 0
; CHECK-NEXT: br $m10
define i1 @constrained_fcmps_ord_f16(half %lhs, half %rhs) {
  %retval = tail call i1 @llvm.experimental.constrained.fcmps.f16(half %lhs, half %rhs, metadata !"ord", metadata !"fpexcept.strict")
  ret i1 %retval
}

; CHECK-LABEL: fcmp_ueq_f16:
; CHECK:      add $m11, $m11, -16
; CHECK-NEXT: .cfi_def_cfa_offset 16
; CHECK-NEXT: .cfi_offset $m8, -4
; CHECK-NEXT: .cfi_offset $m9, -8
; CHECK-NEXT: .cfi_offset $m10, -12
; CHECK-NEXT: .cfi_offset $m7, -16
; CHECK-NEXT: st32 $m8, $m11, $m15, 3                 # 4-byte Folded Spill
; CHECK-NEXT: st32 $m9, $m11, $m15, 2                 # 4-byte Folded Spill
; CHECK-NEXT: st32 $m10, $m11, $m15, 1                # 4-byte Folded Spill
; CHECK-NEXT: st32 $m7, $m11, $m15, 0                 # 4-byte Folded Spill
; CHECK-NEXT: mov	$m7, $m1
; CHECK-NEXT: sort4x16lo $m0, $m0, $m15
; CHECK-NEXT: call $m10, __gnu_h2f_ieee
; CHECK-NEXT: mov	$m8, $m0
; CHECK-NEXT: sort4x16lo $m0, $m7, $m15
; CHECK-NEXT: call $m10, __gnu_h2f_ieee
; CHECK-NEXT: mov	$m7, $m0
; CHECK-NEXT: mov	$m0, $m8
; CHECK-NEXT: mov	$m1, $m7
; CHECK-NEXT: call $m10, __unordsf2
; CHECK-NEXT: cmpne $m9, $m0, $m15
; CHECK-NEXT: mov	$m0, $m8
; CHECK-NEXT: mov	$m1, $m7
; CHECK-NEXT: call $m10, __eqsf2
; CHECK-NEXT: cmpeq $m0, $m0, 0
; CHECK-NEXT: or $m0, $m9, $m0
; CHECK-NEXT: ld32 $m7, $m11, $m15, 0                 # 4-byte Folded Reload
; CHECK-NEXT: ld32 $m10, $m11, $m15, 1                # 4-byte Folded Reload
; CHECK-NEXT: ld32 $m9, $m11, $m15, 2                 # 4-byte Folded Reload
; CHECK-NEXT: ld32 $m8, $m11, $m15, 3                 # 4-byte Folded Reload
; CHECK-NEXT: add $m11, $m11, 16
; CHECK-NEXT: .cfi_def_cfa_offset 0
; CHECK-NEXT: br $m10
define i1 @fcmp_ueq_f16(half %lhs, half %rhs) {
  %retval = fcmp ueq half %lhs, %rhs
  ret i1 %retval
}

; CHECK-LABEL: constrained_fcmps_ueq_f16:
; CHECK:      add $m11, $m11, -16
; CHECK-NEXT: .cfi_def_cfa_offset 16
; CHECK-NEXT: .cfi_offset $m8, -4
; CHECK-NEXT: .cfi_offset $m9, -8
; CHECK-NEXT: .cfi_offset $m10, -12
; CHECK-NEXT: .cfi_offset $m7, -16
; CHECK-NEXT: st32 $m8, $m11, $m15, 3                 # 4-byte Folded Spill
; CHECK-NEXT: st32 $m9, $m11, $m15, 2                 # 4-byte Folded Spill
; CHECK-NEXT: st32 $m10, $m11, $m15, 1                # 4-byte Folded Spill
; CHECK-NEXT: st32 $m7, $m11, $m15, 0                 # 4-byte Folded Spill
; CHECK-NEXT: mov     $m7, $m0
; CHECK-NEXT: sort4x16lo $m0, $m1, $m15
; CHECK-NEXT: call $m10, __gnu_h2f_ieee
; CHECK-NEXT: mov     $m8, $m0
; CHECK-NEXT: sort4x16lo $m0, $m7, $m15
; CHECK-NEXT: call $m10, __gnu_h2f_ieee
; CHECK-NEXT: mov     $m7, $m0
; CHECK-NEXT: mov     $m1, $m8
; CHECK-NEXT: call $m10, __unordsf2
; CHECK-NEXT: cmpne $m9, $m0, $m15
; CHECK-NEXT: mov     $m0, $m7
; CHECK-NEXT: mov     $m1, $m8
; CHECK-NEXT: call $m10, __eqsf2
; CHECK-NEXT: cmpeq $m0, $m0, 0
; CHECK-NEXT: or $m0, $m9, $m0
; CHECK-NEXT: ld32 $m7, $m11, $m15, 0                 # 4-byte Folded Reload
; CHECK-NEXT: ld32 $m10, $m11, $m15, 1                # 4-byte Folded Reload
; CHECK-NEXT: ld32 $m9, $m11, $m15, 2                 # 4-byte Folded Reload
; CHECK-NEXT: ld32 $m8, $m11, $m15, 3                 # 4-byte Folded Reload
; CHECK-NEXT: add $m11, $m11, 16
; CHECK-NEXT: .cfi_def_cfa_offset 0
; CHECK-NEXT: br $m10
define i1 @constrained_fcmps_ueq_f16(half %lhs, half %rhs) {
  %retval = tail call i1 @llvm.experimental.constrained.fcmps.f16(half %lhs, half %rhs, metadata !"ueq", metadata !"fpexcept.strict")
  ret i1 %retval
}

; CHECK-LABEL: fcmp_ugt_f16:
; CHECK:      add $m11, $m11, -16
; CHECK-NEXT: .cfi_def_cfa_offset 16
; CHECK-NEXT: .cfi_offset $m8, -4
; CHECK-NEXT: .cfi_offset $m10, -8
; CHECK-NEXT: .cfi_offset $m7, -12
; CHECK-NEXT: st32 $m8, $m11, $m15, 3                 # 4-byte Folded Spill
; CHECK-NEXT: st32 $m10, $m11, $m15, 2                # 4-byte Folded Spill
; CHECK-NEXT: st32 $m7, $m11, $m15, 1                 # 4-byte Folded Spill
; CHECK-NEXT: mov	$m7, $m1
; CHECK-NEXT: sort4x16lo $m0, $m0, $m15
; CHECK-NEXT: call $m10, __gnu_h2f_ieee
; CHECK-NEXT: mov	$m8, $m0
; CHECK-NEXT: sort4x16lo $m0, $m7, $m15
; CHECK-NEXT: call $m10, __gnu_h2f_ieee
; CHECK-NEXT: mov	$m1, $m0
; CHECK-NEXT: mov	$m0, $m8
; CHECK-NEXT: call $m10, __lesf2
; CHECK-NEXT: cmpslt $m0, $m15, $m0
; CHECK-NEXT: ld32 $m7, $m11, $m15, 1                 # 4-byte Folded Reload
; CHECK-NEXT: ld32 $m10, $m11, $m15, 2                # 4-byte Folded Reload
; CHECK-NEXT: ld32 $m8, $m11, $m15, 3                 # 4-byte Folded Reload
; CHECK-NEXT: add $m11, $m11, 16
; CHECK-NEXT: .cfi_def_cfa_offset 0
; CHECK-NEXT: br $m10
define i1 @fcmp_ugt_f16(half %lhs, half %rhs) {
  %retval = fcmp ugt half %lhs, %rhs
  ret i1 %retval
}

; CHECK-LABEL: constrained_fcmps_ugt_f16:
; CHECK:      add $m11, $m11, -16
; CHECK-NEXT: .cfi_def_cfa_offset 16
; CHECK-NEXT: .cfi_offset $m8, -4
; CHECK-NEXT: .cfi_offset $m10, -8
; CHECK-NEXT: .cfi_offset $m7, -12
; CHECK-NEXT: st32 $m8, $m11, $m15, 3                 # 4-byte Folded Spill
; CHECK-NEXT: st32 $m10, $m11, $m15, 2                # 4-byte Folded Spill
; CHECK-NEXT: st32 $m7, $m11, $m15, 1                 # 4-byte Folded Spill
; CHECK-NEXT: mov     $m7, $m0
; CHECK-NEXT: sort4x16lo $m0, $m1, $m15
; CHECK-NEXT: call $m10, __gnu_h2f_ieee
; CHECK-NEXT: mov     $m8, $m0
; CHECK-NEXT: sort4x16lo $m0, $m7, $m15
; CHECK-NEXT: call $m10, __gnu_h2f_ieee
; CHECK-NEXT: mov     $m1, $m8
; CHECK-NEXT: call $m10, __lesf2
; CHECK-NEXT: cmpslt $m0, $m15, $m0
; CHECK-NEXT: ld32 $m7, $m11, $m15, 1                 # 4-byte Folded Reload
; CHECK-NEXT: ld32 $m10, $m11, $m15, 2                # 4-byte Folded Reload
; CHECK-NEXT: ld32 $m8, $m11, $m15, 3                 # 4-byte Folded Reload
; CHECK-NEXT: add $m11, $m11, 16
; CHECK-NEXT: .cfi_def_cfa_offset 0
; CHECK-NEXT: br $m10
define i1 @constrained_fcmps_ugt_f16(half %lhs, half %rhs) {
  %retval = tail call i1 @llvm.experimental.constrained.fcmps.f16(half %lhs, half %rhs, metadata !"ugt", metadata !"fpexcept.strict")
  ret i1 %retval
}

; CHECK-LABEL: fcmp_uge_f16:
; CHECK:      add $m11, $m11, -16
; CHECK-NEXT: .cfi_def_cfa_offset 16
; CHECK-NEXT: .cfi_offset $m8, -4
; CHECK-NEXT: .cfi_offset $m10, -8
; CHECK-NEXT: .cfi_offset $m7, -12
; CHECK-NEXT: st32 $m8, $m11, $m15, 3                 # 4-byte Folded Spill
; CHECK-NEXT: st32 $m10, $m11, $m15, 2                # 4-byte Folded Spill
; CHECK-NEXT: st32 $m7, $m11, $m15, 1                 # 4-byte Folded Spill
; CHECK-NEXT: mov	$m7, $m1
; CHECK-NEXT: sort4x16lo $m0, $m0, $m15
; CHECK-NEXT: call $m10, __gnu_h2f_ieee
; CHECK-NEXT: mov	$m8, $m0
; CHECK-NEXT: sort4x16lo $m0, $m7, $m15
; CHECK-NEXT: call $m10, __gnu_h2f_ieee
; CHECK-NEXT: mov	$m1, $m0
; CHECK-NEXT: mov	$m0, $m8
; CHECK-NEXT: call $m10, __ltsf2
; CHECK-NEXT: add $m1, $m15, -1
; CHECK-NEXT: cmpslt $m0, $m1, $m0
; CHECK-NEXT: ld32 $m7, $m11, $m15, 1                 # 4-byte Folded Reload
; CHECK-NEXT: ld32 $m10, $m11, $m15, 2                # 4-byte Folded Reload
; CHECK-NEXT: ld32 $m8, $m11, $m15, 3                 # 4-byte Folded Reload
; CHECK-NEXT: add $m11, $m11, 16
; CHECK-NEXT: .cfi_def_cfa_offset 0
; CHECK-NEXT: br $m10
define i1 @fcmp_uge_f16(half %lhs, half %rhs) {
  %retval = fcmp uge half %lhs, %rhs
  ret i1 %retval
}

; CHECK-LABEL: constrained_fcmps_uge_f16:
; CHECK:      add $m11, $m11, -16
; CHECK-NEXT: .cfi_def_cfa_offset 16
; CHECK-NEXT: .cfi_offset $m8, -4
; CHECK-NEXT: .cfi_offset $m10, -8
; CHECK-NEXT: .cfi_offset $m7, -12
; CHECK-NEXT: st32 $m8, $m11, $m15, 3                 # 4-byte Folded Spill
; CHECK-NEXT: st32 $m10, $m11, $m15, 2                # 4-byte Folded Spill
; CHECK-NEXT: st32 $m7, $m11, $m15, 1                 # 4-byte Folded Spill
; CHECK-NEXT: mov     $m7, $m0
; CHECK-NEXT: sort4x16lo $m0, $m1, $m15
; CHECK-NEXT: call $m10, __gnu_h2f_ieee
; CHECK-NEXT: mov     $m8, $m0
; CHECK-NEXT: sort4x16lo $m0, $m7, $m15
; CHECK-NEXT: call $m10, __gnu_h2f_ieee
; CHECK-NEXT: mov     $m1, $m8
; CHECK-NEXT: call $m10, __ltsf2
; CHECK-NEXT: add $m1, $m15, -1
; CHECK-NEXT: cmpslt $m0, $m1, $m0
; CHECK-NEXT: ld32 $m7, $m11, $m15, 1                 # 4-byte Folded Reload
; CHECK-NEXT: ld32 $m10, $m11, $m15, 2                # 4-byte Folded Reload
; CHECK-NEXT: ld32 $m8, $m11, $m15, 3                 # 4-byte Folded Reload
; CHECK-NEXT: add $m11, $m11, 16
; CHECK-NEXT: .cfi_def_cfa_offset 0
; CHECK-NEXT: br $m10
define i1 @constrained_fcmps_uge_f16(half %lhs, half %rhs) {
  %retval = tail call i1 @llvm.experimental.constrained.fcmps.f16(half %lhs, half %rhs, metadata !"uge", metadata !"fpexcept.strict")
  ret i1 %retval
}

; CHECK-LABEL: fcmp_ult_f16:
; CHECK:      add $m11, $m11, -16
; CHECK-NEXT: .cfi_def_cfa_offset 16
; CHECK-NEXT: .cfi_offset $m8, -4
; CHECK-NEXT: .cfi_offset $m10, -8
; CHECK-NEXT: .cfi_offset $m7, -12
; CHECK-NEXT: st32 $m8, $m11, $m15, 3                 # 4-byte Folded Spill
; CHECK-NEXT: st32 $m10, $m11, $m15, 2                # 4-byte Folded Spill
; CHECK-NEXT: st32 $m7, $m11, $m15, 1                 # 4-byte Folded Spill
; CHECK-NEXT: mov	$m7, $m1
; CHECK-NEXT: sort4x16lo $m0, $m0, $m15
; CHECK-NEXT: call $m10, __gnu_h2f_ieee
; CHECK-NEXT: mov	$m8, $m0
; CHECK-NEXT: sort4x16lo $m0, $m7, $m15
; CHECK-NEXT: call $m10, __gnu_h2f_ieee
; CHECK-NEXT: mov	$m1, $m0
; CHECK-NEXT: mov	$m0, $m8
; CHECK-NEXT: call $m10, __gesf2
; CHECK-NEXT: cmpslt $m0, $m0, 0
; CHECK-NEXT: ld32 $m7, $m11, $m15, 1                 # 4-byte Folded Reload
; CHECK-NEXT: ld32 $m10, $m11, $m15, 2                # 4-byte Folded Reload
; CHECK-NEXT: ld32 $m8, $m11, $m15, 3                 # 4-byte Folded Reload
; CHECK-NEXT: add $m11, $m11, 16
; CHECK-NEXT: .cfi_def_cfa_offset 0
; CHECK-NEXT: br $m10
define i1 @fcmp_ult_f16(half %lhs, half %rhs) {
  %retval = fcmp ult half %lhs, %rhs
  ret i1 %retval
}

; CHECK-LABEL: constrained_fcmps_ult_f16:
; CHECK:      add $m11, $m11, -16
; CHECK-NEXT: .cfi_def_cfa_offset 16
; CHECK-NEXT: .cfi_offset $m8, -4
; CHECK-NEXT: .cfi_offset $m10, -8
; CHECK-NEXT: .cfi_offset $m7, -12
; CHECK-NEXT: st32 $m8, $m11, $m15, 3                 # 4-byte Folded Spill
; CHECK-NEXT: st32 $m10, $m11, $m15, 2                # 4-byte Folded Spill
; CHECK-NEXT: st32 $m7, $m11, $m15, 1                 # 4-byte Folded Spill
; CHECK-NEXT: mov     $m7, $m0
; CHECK-NEXT: sort4x16lo $m0, $m1, $m15
; CHECK-NEXT: call $m10, __gnu_h2f_ieee
; CHECK-NEXT: mov     $m8, $m0
; CHECK-NEXT: sort4x16lo $m0, $m7, $m15
; CHECK-NEXT: call $m10, __gnu_h2f_ieee
; CHECK-NEXT: mov     $m1, $m8
; CHECK-NEXT: call $m10, __gesf2
; CHECK-NEXT: cmpslt $m0, $m0, 0
; CHECK-NEXT: ld32 $m7, $m11, $m15, 1                 # 4-byte Folded Reload
; CHECK-NEXT: ld32 $m10, $m11, $m15, 2                # 4-byte Folded Reload
; CHECK-NEXT: ld32 $m8, $m11, $m15, 3                 # 4-byte Folded Reload
; CHECK-NEXT: add $m11, $m11, 16
; CHECK-NEXT: .cfi_def_cfa_offset 0
; CHECK-NEXT: br $m10
define i1 @constrained_fcmps_ult_f16(half %lhs, half %rhs) {
  %retval = tail call i1 @llvm.experimental.constrained.fcmps.f16(half %lhs, half %rhs, metadata !"ult", metadata !"fpexcept.strict")
  ret i1 %retval
}

; CHECK-LABEL: fcmp_ule_f16:
; CHECK:      add $m11, $m11, -16
; CHECK-NEXT: .cfi_def_cfa_offset 16
; CHECK-NEXT: .cfi_offset $m8, -4
; CHECK-NEXT: .cfi_offset $m10, -8
; CHECK-NEXT: .cfi_offset $m7, -12
; CHECK-NEXT: st32 $m8, $m11, $m15, 3                 # 4-byte Folded Spill
; CHECK-NEXT: st32 $m10, $m11, $m15, 2                # 4-byte Folded Spill
; CHECK-NEXT: st32 $m7, $m11, $m15, 1                 # 4-byte Folded Spill
; CHECK-NEXT: mov	$m7, $m1
; CHECK-NEXT: sort4x16lo $m0, $m0, $m15
; CHECK-NEXT: call $m10, __gnu_h2f_ieee
; CHECK-NEXT: mov	$m8, $m0
; CHECK-NEXT: sort4x16lo $m0, $m7, $m15
; CHECK-NEXT: call $m10, __gnu_h2f_ieee
; CHECK-NEXT: mov	$m1, $m0
; CHECK-NEXT: mov	$m0, $m8
; CHECK-NEXT: call $m10, __gtsf2
; CHECK-NEXT: cmpslt $m0, $m0, 1
; CHECK-NEXT: ld32 $m7, $m11, $m15, 1                 # 4-byte Folded Reload
; CHECK-NEXT: ld32 $m10, $m11, $m15, 2                # 4-byte Folded Reload
; CHECK-NEXT: ld32 $m8, $m11, $m15, 3                 # 4-byte Folded Reload
; CHECK-NEXT: add $m11, $m11, 16
; CHECK-NEXT: .cfi_def_cfa_offset 0
; CHECK-NEXT: br $m10
define i1 @fcmp_ule_f16(half %lhs, half %rhs) {
  %retval = fcmp ule half %lhs, %rhs
  ret i1 %retval
}

; CHECK-LABEL: constrained_fcmps_ule_f16:
; CHECK:      add $m11, $m11, -16
; CHECK-NEXT: .cfi_def_cfa_offset 16
; CHECK-NEXT: .cfi_offset $m8, -4
; CHECK-NEXT: .cfi_offset $m10, -8
; CHECK-NEXT: .cfi_offset $m7, -12
; CHECK-NEXT: st32 $m8, $m11, $m15, 3                 # 4-byte Folded Spill
; CHECK-NEXT: st32 $m10, $m11, $m15, 2                # 4-byte Folded Spill
; CHECK-NEXT: st32 $m7, $m11, $m15, 1                 # 4-byte Folded Spill
; CHECK-NEXT: mov     $m7, $m0
; CHECK-NEXT: sort4x16lo $m0, $m1, $m15
; CHECK-NEXT: call $m10, __gnu_h2f_ieee
; CHECK-NEXT: mov     $m8, $m0
; CHECK-NEXT: sort4x16lo $m0, $m7, $m15
; CHECK-NEXT: call $m10, __gnu_h2f_ieee
; CHECK-NEXT: mov     $m1, $m8
; CHECK-NEXT: call $m10, __gtsf2
; CHECK-NEXT: cmpslt $m0, $m0, 1
; CHECK-NEXT: ld32 $m7, $m11, $m15, 1                 # 4-byte Folded Reload
; CHECK-NEXT: ld32 $m10, $m11, $m15, 2                # 4-byte Folded Reload
; CHECK-NEXT: ld32 $m8, $m11, $m15, 3                 # 4-byte Folded Reload
; CHECK-NEXT: add $m11, $m11, 16
; CHECK-NEXT: .cfi_def_cfa_offset 0
; CHECK-NEXT: br $m10
define i1 @constrained_fcmps_ule_f16(half %lhs, half %rhs) {
  %retval = tail call i1 @llvm.experimental.constrained.fcmps.f16(half %lhs, half %rhs, metadata !"ule", metadata !"fpexcept.strict")
  ret i1 %retval
}

; CHECK-LABEL: fcmp_une_f16:
; CHECK:      add $m11, $m11, -16
; CHECK-NEXT: .cfi_def_cfa_offset 16
; CHECK-NEXT: .cfi_offset $m8, -4
; CHECK-NEXT: .cfi_offset $m10, -8
; CHECK-NEXT: .cfi_offset $m7, -12
; CHECK-NEXT: st32 $m8, $m11, $m15, 3                 # 4-byte Folded Spill
; CHECK-NEXT: st32 $m10, $m11, $m15, 2                # 4-byte Folded Spill
; CHECK-NEXT: st32 $m7, $m11, $m15, 1                 # 4-byte Folded Spill
; CHECK-NEXT: mov	$m7, $m1
; CHECK-NEXT: sort4x16lo $m0, $m0, $m15
; CHECK-NEXT: call $m10, __gnu_h2f_ieee
; CHECK-NEXT: mov	$m8, $m0
; CHECK-NEXT: sort4x16lo $m0, $m7, $m15
; CHECK-NEXT: call $m10, __gnu_h2f_ieee
; CHECK-NEXT: mov	$m1, $m0
; CHECK-NEXT: mov	$m0, $m8
; CHECK-NEXT: call $m10, __nesf2
; CHECK-NEXT: cmpne $m0, $m0, $m15
; CHECK-NEXT: ld32 $m7, $m11, $m15, 1                 # 4-byte Folded Reload
; CHECK-NEXT: ld32 $m10, $m11, $m15, 2                # 4-byte Folded Reload
; CHECK-NEXT: ld32 $m8, $m11, $m15, 3                 # 4-byte Folded Reload
; CHECK-NEXT: add $m11, $m11, 16
; CHECK-NEXT: .cfi_def_cfa_offset 0
; CHECK-NEXT: br $m10
define i1 @fcmp_une_f16(half %lhs, half %rhs) {
  %retval = fcmp une half %lhs, %rhs
  ret i1 %retval
}

; CHECK-LABEL: constrained_fcmps_une_f16:
; CHECK:      add $m11, $m11, -16
; CHECK-NEXT: .cfi_def_cfa_offset 16
; CHECK-NEXT: .cfi_offset $m8, -4
; CHECK-NEXT: .cfi_offset $m10, -8
; CHECK-NEXT: .cfi_offset $m7, -12
; CHECK-NEXT: st32 $m8, $m11, $m15, 3                 # 4-byte Folded Spill
; CHECK-NEXT: st32 $m10, $m11, $m15, 2                # 4-byte Folded Spill
; CHECK-NEXT: st32 $m7, $m11, $m15, 1                 # 4-byte Folded Spill
; CHECK-NEXT: mov     $m7, $m0
; CHECK-NEXT: sort4x16lo $m0, $m1, $m15
; CHECK-NEXT: call $m10, __gnu_h2f_ieee
; CHECK-NEXT: mov     $m8, $m0
; CHECK-NEXT: sort4x16lo $m0, $m7, $m15
; CHECK-NEXT: call $m10, __gnu_h2f_ieee
; CHECK-NEXT: mov     $m1, $m8
; CHECK-NEXT: call $m10, __nesf2
; CHECK-NEXT: cmpne $m0, $m0, $m15
; CHECK-NEXT: ld32 $m7, $m11, $m15, 1                 # 4-byte Folded Reload
; CHECK-NEXT: ld32 $m10, $m11, $m15, 2                # 4-byte Folded Reload
; CHECK-NEXT: ld32 $m8, $m11, $m15, 3                 # 4-byte Folded Reload
; CHECK-NEXT: add $m11, $m11, 16
; CHECK-NEXT: .cfi_def_cfa_offset 0
; CHECK-NEXT: br $m10
define i1 @constrained_fcmps_une_f16(half %lhs, half %rhs) {
  %retval = tail call i1 @llvm.experimental.constrained.fcmps.f16(half %lhs, half %rhs, metadata !"une", metadata !"fpexcept.strict")
  ret i1 %retval
}

; CHECK-LABEL: fcmp_uno_f16:
; CHECK:      add $m11, $m11, -16
; CHECK-NEXT: .cfi_def_cfa_offset 16
; CHECK-NEXT: .cfi_offset $m8, -4
; CHECK-NEXT: .cfi_offset $m10, -8
; CHECK-NEXT: .cfi_offset $m7, -12
; CHECK-NEXT: st32 $m8, $m11, $m15, 3                 # 4-byte Folded Spill
; CHECK-NEXT: st32 $m10, $m11, $m15, 2                # 4-byte Folded Spill
; CHECK-NEXT: st32 $m7, $m11, $m15, 1                 # 4-byte Folded Spill
; CHECK-NEXT: mov	$m7, $m1
; CHECK-NEXT: sort4x16lo $m0, $m0, $m15
; CHECK-NEXT: call $m10, __gnu_h2f_ieee
; CHECK-NEXT: mov	$m8, $m0
; CHECK-NEXT: sort4x16lo $m0, $m7, $m15
; CHECK-NEXT: call $m10, __gnu_h2f_ieee
; CHECK-NEXT: mov	$m1, $m0
; CHECK-NEXT: mov	$m0, $m8
; CHECK-NEXT: call $m10, __unordsf2
; CHECK-NEXT: cmpne $m0, $m0, $m15
; CHECK-NEXT: ld32 $m7, $m11, $m15, 1                 # 4-byte Folded Reload
; CHECK-NEXT: ld32 $m10, $m11, $m15, 2                # 4-byte Folded Reload
; CHECK-NEXT: ld32 $m8, $m11, $m15, 3                 # 4-byte Folded Reload
; CHECK-NEXT: add $m11, $m11, 16
; CHECK-NEXT: .cfi_def_cfa_offset 0
; CHECK-NEXT: br $m10
define i1 @fcmp_uno_f16(half %lhs, half %rhs) {
  %retval = fcmp uno half %lhs, %rhs
  ret i1 %retval
}

; CHECK-LABEL: constrained_fcmps_uno_f16:
; CHECK:      add $m11, $m11, -16
; CHECK-NEXT: .cfi_def_cfa_offset 16
; CHECK-NEXT: .cfi_offset $m8, -4
; CHECK-NEXT: .cfi_offset $m10, -8
; CHECK-NEXT: .cfi_offset $m7, -12
; CHECK-NEXT: st32 $m8, $m11, $m15, 3                 # 4-byte Folded Spill
; CHECK-NEXT: st32 $m10, $m11, $m15, 2                # 4-byte Folded Spill
; CHECK-NEXT: st32 $m7, $m11, $m15, 1                 # 4-byte Folded Spill
; CHECK-NEXT: mov     $m7, $m0
; CHECK-NEXT: sort4x16lo $m0, $m1, $m15
; CHECK-NEXT: call $m10, __gnu_h2f_ieee
; CHECK-NEXT: mov     $m8, $m0
; CHECK-NEXT: sort4x16lo $m0, $m7, $m15
; CHECK-NEXT: call $m10, __gnu_h2f_ieee
; CHECK-NEXT: mov     $m1, $m8
; CHECK-NEXT: call $m10, __unordsf2
; CHECK-NEXT: cmpne $m0, $m0, $m15
; CHECK-NEXT: ld32 $m7, $m11, $m15, 1                 # 4-byte Folded Reload
; CHECK-NEXT: ld32 $m10, $m11, $m15, 2                # 4-byte Folded Reload
; CHECK-NEXT: ld32 $m8, $m11, $m15, 3                 # 4-byte Folded Reload
; CHECK-NEXT: add $m11, $m11, 16
; CHECK-NEXT: .cfi_def_cfa_offset 0
; CHECK-NEXT: br $m10
define i1 @constrained_fcmps_uno_f16(half %lhs, half %rhs) {
  %retval = tail call i1 @llvm.experimental.constrained.fcmps.f16(half %lhs, half %rhs, metadata !"uno", metadata !"fpexcept.strict")
  ret i1 %retval
}

; CHECK-LABEL: fcmp_true_f16:
; CHECK:      setzi $m0, 1
; CHECK-NEXT: br $m10
define i1 @fcmp_true_f16(half %lhs, half %rhs) {
  %retval = fcmp true half %lhs, %rhs
  ret i1 %retval
}
