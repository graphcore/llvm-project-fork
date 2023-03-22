; RUN: llc -mtriple=colossus-graphcore-elf -filetype=obj %s -o - \
; RUN:   | llvm-readobj -h -r - | FileCheck %s

; Basic test of LLVM direct object emission.

; CHECK: Format: elf32-colossus
; CHECK: Arch: colossus
; CHECK: AddressSize: 32bit
; CHECK: Machine: EM_GRAPHCORE_IPU
