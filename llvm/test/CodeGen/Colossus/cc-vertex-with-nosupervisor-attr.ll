; RUN: not --crash llc -march=colossus -mattr=+supervisor,+ipu1 -o /dev/null %s 2>&1 | FileCheck %s
; RUN: not --crash llc -march=colossus -mattr=+supervisor,+ipu2 -o /dev/null %s 2>&1 | FileCheck %s

; CHECK: LLVM ERROR: in function 'with_nosupervisor_attr_overriden': colossus_vertex calling convention is only applicable to 'worker' functions but 'with_nosupervisor_attr_overriden' is being compiled as a 'supervisor' function
define colossus_vertex void @with_nosupervisor_attr_overriden() #0 {
  ret void
}

attributes #0 = { "target-features"="-supervisor" }
