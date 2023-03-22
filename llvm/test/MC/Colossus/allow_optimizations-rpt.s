#RUN: llvm-mc -mattr=+ipu21 -filetype=obj -triple colossus-graphcore-elf -assemble %s -o - \
#RUN:   | llvm-objdump --no-show-raw-insn --triple colossus-graphcore-elf --disassemble - \
#RUN:   | FileCheck %s
#RUN: not llvm-mc -mattr=+ipu21 -filetype=obj -mattr=+supervisor -triple colossus-graphcore-elf -assemble %s -o - \
#RUN:   < %s 2>&1 >/dev/null | FileCheck %s -check-prefix=CHECK-SUPERVISOR

.allow_optimizations
.allow_invalid_repeat

# -------------------------------
# rpt first operand is an immediate
# -------------------------------

#CHECK:      {{[0-9a-f]+}}: nop
#CHECK-NEXT:                rpt 0, 8
#CHECK-NEXT:  {
#CHECK-NEXT: {{[0-9a-f]+}}: add $m1, $m0, 5
#CHECK-NEXT: {{[0-9a-f]+}}: fnop
#CHECK-NEXT:  }
#CHECK-SUPERVISOR: error: instruction requires: Worker mode
  .align 8
  nop
  { rpt 0, 8 # final operand kind is immediate
    ; fnop }
  { add $m1, $m0, 5   ; fnop }

# -------------------------------
# rpt first operand is an register
# -------------------------------

#CHECK:      {{[0-9a-f]+}}: nop
#CHECK-NEXT:                rpt $m5, 8
#CHECK-NEXT: {
#CHECK-NEXT: {{[0-9a-f]+}}: add $m1, $m0, 5
#CHECK-NEXT: {{[0-9a-f]+}}: fnop
#CHECK-NEXT: }
#CHECK-SUPERVISOR: error: instruction requires: Worker mode
  .align 8
  nop
  { rpt $m5, 8 # final operand kind is immediate
    ; fnop }
  { add $m1, $m0, 5   ; fnop }
