// RUN: llvm-mc -filetype=obj -triple colossus-graphcore-elf < %s | \
// RUN:    llvm-dwarfdump -debug-frame - | FileCheck %s

// CHECK: 00000000 00000010 ffffffff CIE
// CHECK: Format:                DWARF32
// CHECK: Version:               4
// CHECK: Augmentation:          ""
// CHECK: Address size:          4
// CHECK: Segment desc size:     0
// CHECK: Code alignment factor: 1
// CHECK: Data alignment factor: -4
// CHECK: Return address column: 10

// CHECK: DW_CFA_def_cfa: SP +0
// CHECK: DW_CFA_nop:
// CHECK: DW_CFA_nop:

dummy:
  .cfi_sections .debug_frame
  .cfi_startproc
  br $m10
  .cfi_endproc
