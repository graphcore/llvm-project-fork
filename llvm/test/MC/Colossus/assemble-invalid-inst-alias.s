# RUN: not llvm-mc -triple colossus-graphcore-elf < %s 2>&1 | FileCheck %s

## Check error conditions.
##

# CHECK: macro instruction in bundle
{
        ldconst $m0, 42
        fnop
}

# CHECK: operand must be an immediate
        ldconst $m0, foo

# CHECK: operand must be an immediate
fred:
        ldconst $m0, fred

# CHECK: immediate is too large
        ldconst $m0, 0xfffffffff0
