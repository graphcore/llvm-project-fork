; ==============================================================================
; RUN: llc %s -filetype=obj -march=colossus -colossus-coissue=false \
; RUN:   -function-sections -stack-size-section -o %t1.o
; RUN: ld.lld %t1.o -r -o %t2.o
; RUN: llvm-objdump -t %t2.o | FileCheck %s --check-prefix=FUNC
; RUN: llvm-objdump -t %t2.o | FileCheck %s --check-prefix=STACK

; ==============================================================================
; Count the number of function sections.
; FUNC-COUNT-3: {{^[0-9A-Za-z]+ l d \.text\.(foo|bar|baz) }}

; Count the number of stack sizes sections.
; STACK-COUNT-3: {{^[0-9A-Za-z]+ l d \.stack_sizes }}

; ==============================================================================
target triple = "colossus-graphcore--elf"

define i8 @foo(i8 * %ptr) {
  %1 = load i8, i8 * %ptr
  ret i8 %1
}

define i16 @bar(i16 * %ptr) {
  %1 = load i16, i16 * %ptr
  ret i16 %1
}

define i32 @baz(i32 * %ptr) {
  %1 = load i32, i32 * %ptr
  ret i32 %1
}
