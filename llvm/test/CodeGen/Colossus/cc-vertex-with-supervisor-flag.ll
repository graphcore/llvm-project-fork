; RUN: not --crash llc -march=colossus -mattr=+supervisor,+ipu1 -o /dev/null %s 2>&1 | FileCheck %s
; RUN: not --crash llc -march=colossus -mattr=+supervisor,+ipu2 -o /dev/null %s 2>&1 | FileCheck %s

; CHECK: LLVM ERROR: in function 'with_supervisor_flag': colossus_vertex calling convention is only applicable to 'worker' functions but 'with_supervisor_flag' is being compiled as a 'supervisor' function
define colossus_vertex void @with_supervisor_flag() {
  ret void
}
