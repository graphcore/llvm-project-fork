; RUN: not llc -march=colossus -o /dev/null %s 2>&1 | FileCheck %s

; CHECK: LLVM ERROR: Call to unsupported function 'operator delete(void*)' found in 'call_delete(float*)'.
define void @_Z11call_deletePf(float* nocapture nonnull %0) {
  %2 = bitcast float* %0 to i8*
  tail call void @_ZdlPv(i8* nonnull %2)
  ret void
}

declare void @_ZdlPv(i8* nocapture noundef)
