; RUN: not --crash llc -march=colossus -mattr=+ipu1 -o /dev/null %s 2>&1 | FileCheck %s
; RUN: not --crash llc -march=colossus -mattr=+ipu2 -o /dev/null %s 2>&1 | FileCheck %s


; CHECK: LLVM ERROR: in function 'with_supervisor_attr': colossus_vertex calling convention is only applicable to 'worker' functions but 'with_supervisor_attr' is being compiled as a 'supervisor' function
define colossus_vertex void @with_supervisor_attr() #0 {
  ret void
}

attributes #0 = { "target-features"="+supervisor" }
