; RUN: llc -march=colossus -mattr=+ipu1 < %s | FileCheck %s
; RUN: llc -march=colossus -mattr=+ipu2 < %s | FileCheck %s

; Take address of labels so that CFG Simplification does not optimize the
; indirectbr away
@loclabels = private unnamed_addr constant [2 x i8*] [i8* blockaddress(@f, %return1), i8* blockaddress(@f, %return2)], align 1

; CHECK: br $m0
; CHECK: br $m10
define i32 @f(i8* %target) nounwind {
  indirectbr i8* %target, [label %return1, label %return2]
return1:
  ret i32 -1
return2:
  ; Incite register allocator to keep %target in $m0 so that indirectbr is made
  ; off $m0 and the CHECK directive succeeds.
  %1 = ptrtoint i8* %target to i32
  ret i32 %1
}
