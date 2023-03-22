; RUN: llc -march=colossus -mattr=+ipu1 -o /dev/null %s 2>&1
; RUN: llc -march=colossus -mattr=+ipu2 -o /dev/null %s 2>&1

define void @both_func() #2 {
  ret void
}

define void @worker_func() #0 {
  call void @both_func()
  ret void
}

define void @supervisor_func() #1 {
  call void @both_func()
  ret void
}

define void @both_func_calling_worker_and_supervisor() #2 {
  call void @worker_func()
  call void @supervisor_func()
  ret void
}

attributes #0 = { "target-features"="+worker" }
attributes #1 = { "target-features"="+supervisor" }
attributes #2 = { "target-features"="+both" }
