; RUN: llc -march=colossus -mattr=+ipu1 -o /dev/null %s 2>&1
; RUN: llc -march=colossus -mattr=+ipu2 -o /dev/null %s 2>&1
; RUN: not --crash llc -march=colossus --colossus-enable-target-checks -o /dev/null %s 2>&1 | FileCheck %s

define void @worker_func() #0 {
  ret void
}

; CHECK: LLVM ERROR: in function 'supervisor_func': called worker function 'worker_func' must have __attribute__((target("supervisor")))
define void @supervisor_func() #1 {
  call void @worker_func()
  ret void
}

attributes #0 = { "target-features"="+worker" }
attributes #1 = { "target-features"="+supervisor" }
