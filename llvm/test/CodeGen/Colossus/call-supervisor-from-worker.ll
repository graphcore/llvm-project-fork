; RUN: not --crash llc -march=colossus -colossus-enable-target-checks -mattr=+ipu1 -o /dev/null %s 2>&1 | FileCheck %s
; RUN: not --crash llc -march=colossus -colossus-enable-target-checks -mattr=+ipu2 -o /dev/null %s 2>&1 | FileCheck %s

define void @supervisor_func() #0 {
  ret void
}

; CHECK: LLVM ERROR: in function 'worker_func': called supervisor function 'supervisor_func' must have __attribute__((target("worker")))
define void @worker_func() #1 {
  call void @supervisor_func()
  ret void
}

attributes #0 = { "target-features"="+supervisor" }
attributes #1 = { "target-features"="+worker" }
