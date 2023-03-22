; RUN: llc < %s -march=colossus -mattr=\+supervisor,+ipu1 | FileCheck %s

; RUN: llc < %s -march=colossus -mattr=\+supervisor,+ipu2 | FileCheck %s

; CHECK-LABEL: fp_to_sint:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m10, $m11, $m15, 1        # 4-byte Folded Spill
; CHECK-NEXT:  call $m10, __fixsfsi
; CHECK-NEXT:  ld32 $m10, $m11, $m15, 1        # 4-byte Folded Reload
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10
define i32 @fp_to_sint(float %fval) {
  %ival = fptosi float %fval to i32
  ret i32 %ival
}

declare i32 @llvm.experimental.constrained.fptosi(float, metadata)

; CHECK-LABEL: strict_fp_to_sint:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m10, $m11, $m15, 1        # 4-byte Folded Spill
; CHECK-NEXT:  call $m10, __fixsfsi
; CHECK-NEXT:  ld32 $m10, $m11, $m15, 1        # 4-byte Folded Reload
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10
define i32 @strict_fp_to_sint(float %fval) {
  %ival = call i32 @llvm.experimental.constrained.fptosi(float %fval, metadata !"fpexcept.strict")
  ret i32 %ival
}

; CHECK-LABEL: fp_to_uint:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m10, $m11, $m15, 1        # 4-byte Folded Spill
; CHECK-NEXT:  call $m10, __fixunssfsi
; CHECK-NEXT:  ld32 $m10, $m11, $m15, 1        # 4-byte Folded Reload
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10
define i32 @fp_to_uint(float %fval) {
  %ival = fptoui float %fval to i32
  ret i32 %ival
}

declare i32 @llvm.experimental.constrained.fptoui(float, metadata)

; CHECK-LABEL: strict_fp_to_uint:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m10, $m11, $m15, 1        # 4-byte Folded Spill
; CHECK-NEXT:  call $m10, __fixunssfsi
; CHECK-NEXT:  ld32 $m10, $m11, $m15, 1        # 4-byte Folded Reload
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10
define i32 @strict_fp_to_uint(float %fval) {
  %ival = call i32 @llvm.experimental.constrained.fptoui(float %fval, metadata !"fpexcept.strict")
  ret i32 %ival
}

; CHECK-LABEL: sint_to_fp:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m10, $m11, $m15, 1        # 4-byte Folded Spill
; CHECK-NEXT:  call $m10, __floatsisf
; CHECK-NEXT:  ld32 $m10, $m11, $m15, 1        # 4-byte Folded Reload
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10
define float @sint_to_fp(i32 %ival) {
  %fval = sitofp i32 %ival to float
  ret float %fval
}

declare float @llvm.experimental.constrained.sitofp(i32, metadata, metadata)

; CHECK-LABEL: strict_sint_to_fp:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m10, $m11, $m15, 1        # 4-byte Folded Spill
; CHECK-NEXT:  call $m10, __floatsisf
; CHECK-NEXT:  ld32 $m10, $m11, $m15, 1        # 4-byte Folded Reload
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10
define float @strict_sint_to_fp(i32 %ival) {
  %fval = call float @llvm.experimental.constrained.sitofp(i32 %ival, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret float %fval
}

; CHECK-LABEL: uint_to_fp:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m10, $m11, $m15, 1        # 4-byte Folded Spill
; CHECK-NEXT:  call $m10, __floatunsisf
; CHECK-NEXT:  ld32 $m10, $m11, $m15, 1        # 4-byte Folded Reload
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10
define float @uint_to_fp(i32 %ival) {
  %fval = uitofp i32 %ival to float
  ret float %fval
}

declare float @llvm.experimental.constrained.uitofp(i32, metadata, metadata)

; CHECK-LABEL: strict_uint_to_fp:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m10, $m11, $m15, 1        # 4-byte Folded Spill
; CHECK-NEXT:  call $m10, __floatunsisf
; CHECK-NEXT:  ld32 $m10, $m11, $m15, 1        # 4-byte Folded Reload
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10
define float @strict_uint_to_fp(i32 %ival) {
  %fval = call float @llvm.experimental.constrained.uitofp(i32 %ival, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret float %fval
}
