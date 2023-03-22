; RUN: not llc -march=colossus -o /dev/null %s 2>&1 | FileCheck %s

; CHECK: LLVM ERROR: Call to unsupported function 'operator new(unsigned long)' found in 'call_new(float)'.
define noalias nonnull float* @_Z8call_newf(float %0) {
  %2 = tail call noalias nonnull dereferenceable(4) i8* @_Znwm(i32 4)
  %3 = bitcast i8* %2 to float*
  store float %0, float* %3, align 4
  ret float* %3
}

declare noalias noundef nonnull i8* @_Znwm(i32)
