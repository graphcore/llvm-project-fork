// RUN: llvm-mc -filetype=obj -triple colossus-graphcore-elf %s -o %t.o
// RUN: llvm-readobj -r %t.o | FileCheck --check-prefix=RELOCS %s
// RUN: llvm-dwarfdump -eh-frame %t.o | FileCheck --check-prefix=DWARF %s

// DWARF: 00000000 00000010 00000000 CIE
// DWARF: Format:                DWARF32
// DWARF: Version:               1
// DWARF: Augmentation:          "zR"
// DWARF: Code alignment factor: 1
// DWARF: Data alignment factor: -4
// DWARF: Return address column: 10
// DWARF: Augmentation data:     00

// DWARF: DW_CFA_def_cfa: SP +0

// RELOCS: Relocations [
// RELOCS:   Section ({{.+}}) .rel{{a?}}.eh_frame {
// RELOCS:     R_COLOSSUS_32
// RELOCS:   }
// RELOCS: ]
dummy:
  .cfi_startproc
  br $m10
  .cfi_endproc
