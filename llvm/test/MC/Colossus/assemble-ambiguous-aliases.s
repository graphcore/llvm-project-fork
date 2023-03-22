# RUN: llvm-mc -filetype=obj -triple colossus-graphcore-elf -assemble %s -o - \
# RUN: | llvm-objdump --triple colossus-graphcore-elf --disassemble - \
# RUN: | FileCheck %s
# Assemble and check the differences between default add, adds for simm16,
# and addz for zimm16.

L_add:
# CHECK: 2a 00 00 22
  add $m0, $m0, 42
# CHECK: 2a 00 00 20
  addz $m0, $m0, 42
# CHECK: 2a 00 00 22
  adds $m0, $m0, 42

# CHECK: d6 ff 00 22
  add $m0, $m0, -42
# CHECK: d6 ff 00 22
  adds $m0, $m0, -42

# CHECK: 98 ff 00 20
  add $m0, $m0, 65432
# CHECK: 98 ff 00 20
  addz $m0, $m0, 65432

L_cmpeq:
# CHECK: 2a 00 00 28
  cmpeq $m0, $m0, 42
# CHECK: 2a 00 00 26
  cmpeqz $m0, $m0, 42
# CHECK: 2a 00 00 28
  cmpeqs $m0, $m0, 42

# CHECK: d6 ff 00 28
  cmpeq $m0, $m0, -42
# CHECK: d6 ff 00 28
  cmpeqs $m0, $m0, -42

# CHECK: 98 ff 00 26
  cmpeq $m0, $m0, 65432
# CHECK: 98 ff 00 26
  cmpeqz $m0, $m0, 65432

L_max:
# CHECK: 2a 00 00 30
  max $m0, $m0, 42
# CHECK: 2a 00 00 2e
  maxz $m0, $m0, 42
# CHECK: 2a 00 00 30
  maxs $m0, $m0, 42

# CHECK: d6 ff 00 30
  max $m0, $m0, -42
# CHECK: d6 ff 00 30
  maxs $m0, $m0, -42

# CHECK: 98 ff 00 2e
  max $m0, $m0, 65432
# CHECK: 98 ff 00 2e
  maxz $m0, $m0, 65432

L_min:
# CHECK: 2a 00 00 33
  min $m0, $m0, 42
# CHECK: 2a 00 00 31
  minz $m0, $m0, 42
# CHECK: 2a 00 00 33
  mins $m0, $m0, 42

# CHECK: d6 ff 00 33
  min $m0, $m0, -42
# CHECK: d6 ff 00 33
  mins $m0, $m0, -42

# CHECK: 98 ff 00 31
  min $m0, $m0, 65432
# CHECK: 98 ff 00 31
  minz $m0, $m0, 65432

L_sub:
# CHECK: 2a 00 00 39
  sub $m0, 42, $m0
# CHECK: 2a 00 00 37
  subz $m0, 42, $m0
# CHECK: 2a 00 00 39
  subs $m0, 42, $m0

# CHECK: d6 ff 00 39
  sub $m0, -42, $m0
# CHECK: d6 ff 00 39
  subs $m0, -42, $m0

# CHECK: 98 ff 00 37
  sub $m0, 65432, $m0
# CHECK: 98 ff 00 37
  subz $m0, 65432, $m0

