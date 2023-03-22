; RUN: llc < %s -march=colossus -verify-machineinstrs

; Lowering Colossus::ICALL needs to preserve the register state of the operand.
; In this minimal test case, the operand is undefined. If this information is
; lost, -verify-machineinstrs will error with:
; *** Bad machine code: Using an undefined physical register ***
; Since calling undef() is undefined LLVM is allowed to generate any code so we
; only check that llc does not return an error. As a matter of fact, at the
; time of writing this line, llc generates a fully empty function, i.e. only a
; label and not even the return branch.
define void @func() {
  %fail = call i32 undef()
  ret void
}
