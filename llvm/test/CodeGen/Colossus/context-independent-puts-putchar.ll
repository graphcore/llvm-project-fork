; RUN: llc -march=colossus -mattr=+ipu1 -o - %s | FileCheck %s
; RUN: llc -march=colossus -mattr=+ipu2 -o - %s | FileCheck %s

@.str = private constant [7 x i8] c"hello\0A\00"

declare i32 @puts(i8*) #1

declare i32 @putchar(i32) #1

; CHECK: call $m10, puts
; CHECK: call $m10, putchar
define void @worker_func() #0 {
  %puts = call i32 @puts(i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0))
  %putchar = call i32 @putchar(i32 120)
  ret void
}

attributes #0 = { "target-features"="+worker" }
attributes #1 = { "target-features"="+supervisor" }

