# RUN: not llvm-mc -triple colossus-graphcore-elf -assemble %s  2> %t.stderr 1> %t.stdout
# RUN: FileCheck %s < %t.stdout
# RUN: FileCheck %s --check-prefix=CHECK-ERROR < %t.stderr
# RUN: not llvm-mc -triple colossus-graphcore-elf -mattr=+supervisor \
# RUN:   < %s 2>&1 >/dev/null | FileCheck %s -check-prefix=CHECK-SUPERVISOR

ARegPairs:
	// CHECK: st64step $a0:1, $m0, $m1+=, $m2
	// CHECK-SUPERVISOR: error: instruction requires: Worker mode
	st64step $a0:1, $m0, $m1+=, $m2
	// CHECK-ERROR: invalid operand for instruction
	st64step $a1:2, $m0, $m1+=, $m2

	// CHECK: st64step $a2:3, $m0, $m1+=, $m2
	// CHECK-SUPERVISOR: error: instruction requires: Worker mode
	st64step $a2:3, $m0, $m1+=, $m2
	// CHECK-ERROR: invalid operand for instruction
	st64step $a3:4, $m0, $m1+=, $m2

	// CHECK: st64step $a4:5, $m0, $m1+=, $m2
	// CHECK-SUPERVISOR: error: instruction requires: Worker mode
	st64step $a4:5, $m0, $m1+=, $m2
	// CHECK-ERROR: invalid operand for instruction
	st64step $a5:6, $m0, $m1+=, $m2

	// CHECK: st64step $a6:7, $m0, $m1+=, $m2
	// CHECK-SUPERVISOR: error: instruction requires: Worker mode
	st64step $a6:7, $m0, $m1+=, $m2
	// CHECK-ERROR: invalid operand for instruction
	st64step $a7:8, $m0, $m1+=, $m2

	// CHECK: st64step $a8:9, $m0, $m1+=, $m2
	// CHECK-SUPERVISOR: error: instruction requires: Worker mode
	st64step $a8:9, $m0, $m1+=, $m2
	// CHECK-ERROR: invalid operand for instruction
	st64step $a9:10, $m0, $m1+=, $m2

	// CHECK: st64step $a10:11, $m0, $m1+=, $m2
	// CHECK-SUPERVISOR: error: instruction requires: Worker mode
	st64step $a10:11, $m0, $m1+=, $m2
	// CHECK-ERROR: invalid operand for instruction
	st64step $a11:12, $m0, $m1+=, $m2

	// CHECK: st64step $a12:13, $m0, $m1+=, $m2
	// CHECK-SUPERVISOR: error: instruction requires: Worker mode
	st64step $a12:13, $m0, $m1+=, $m2
	// CHECK-ERROR: invalid operand for instruction
	st64step $a13:14, $m0, $m1+=, $m2

	// CHECK: st64step $a14:15, $m0, $m1+=, $m2
	// CHECK-SUPERVISOR: error: instruction requires: Worker mode
	st64step $a14:15, $m0, $m1+=, $m2
	// CHECK-ERROR: invalid operand for instruction
	st64step $a15:16, $m0, $m1+=, $m2

ARegQuads:

	// CHECK: ld64a32 $a0:3, $m0++, $m1, $m2
	// CHECK-SUPERVISOR: error: instruction requires: Worker mode
	ld64a32 $a0:3, $m0++, $m1, $m2
	// CHECK-ERROR: invalid operand for instruction
	ld64a32 $a1:4, $m0++, $m1, $m2
	// CHECK-ERROR: invalid operand for instruction
	ld64a32 $a2:5, $m0++, $m1, $m2
	// CHECK-ERROR: invalid operand for instruction
	ld64a32 $a3:6, $m0++, $m1, $m2

	// CHECK: ld64a32 $a4:7, $m0++, $m1, $m2
	// CHECK-SUPERVISOR: error: instruction requires: Worker mode
	ld64a32 $a4:7, $m0++, $m1, $m2
	// CHECK-ERROR: invalid operand for instruction
	ld64a32 $a5:8, $m0++, $m1, $m2
	// CHECK-ERROR: invalid operand for instruction
	ld64a32 $a6:9, $m0++, $m1, $m2
	// CHECK-ERROR: invalid operand for instruction
	ld64a32 $a7:10, $m0++, $m1, $m2

	// CHECK: ld64a32 $a8:11, $m0++, $m1, $m2
	// CHECK-SUPERVISOR: error: instruction requires: Worker mode
	ld64a32 $a8:11, $m0++, $m1, $m2
	// CHECK-ERROR: invalid operand for instruction
	ld64a32 $a9:12, $m0++, $m1, $m2
	// CHECK-ERROR: invalid operand for instruction
	ld64a32 $a10:13, $m0++, $m1, $m2
	// CHECK-ERROR: invalid operand for instruction
	ld64a32 $a11:14, $m0++, $m1, $m2

	// CHECK: ld64a32 $a12:15, $m0++, $m1, $m2
	// CHECK-SUPERVISOR: error: instruction requires: Worker mode
	ld64a32 $a12:15, $m0++, $m1, $m2
	// CHECK-ERROR: invalid operand for instruction
	ld64a32 $a13:16, $m0++, $m1, $m2
	// CHECK-ERROR: invalid operand for instruction
	ld64a32 $a14:17, $m0++, $m1, $m2
	// CHECK-ERROR: invalid operand for instruction
	ld64a32 $a15:18, $m0++, $m1, $m2

MRegPair:

	// CHECK: ldst64pace $a6:7, $a6:7, $m0:1+=, $m7, 0
	// CHECK-SUPERVISOR: error: instruction requires: Worker mode
	ldst64pace $a6:7, $a6:7, $m0:1+=, $m7, 0
	// CHECK-ERROR: unknown token in expression
	ldst64pace $a6:7, $a6:7, $m1:2+=, $m7, 0

	// CHECK: ldst64pace $a6:7, $a6:7, $m2:3+=, $m7, 0
	// CHECK-SUPERVISOR: error: instruction requires: Worker mode
	ldst64pace $a6:7, $a6:7, $m2:3+=, $m7, 0
	// CHECK-ERROR: unknown token in expression
	ldst64pace $a6:7, $a6:7, $m3:4+=, $m7, 0

	// CHECK: ldst64pace $a6:7, $a6:7, $m4:5+=, $m7, 0
	// CHECK-SUPERVISOR: error: instruction requires: Worker mode
	ldst64pace $a6:7, $a6:7, $m4:5+=, $m7, 0
	// CHECK-ERROR: unknown token in expression
	ldst64pace $a6:7, $a6:7, $m5:6+=, $m7, 0

	// CHECK: ldst64pace $a6:7, $a6:7, $m6:7+=, $m7, 0
	// CHECK-SUPERVISOR: error: instruction requires: Worker mode
	ldst64pace $a6:7, $a6:7, $m6:7+=, $m7, 0
	// CHECK-ERROR: unknown token in expression
	ldst64pace $a6:7, $a6:7, $m7:8+=, $m7, 0

	// CHECK: ldst64pace $a6:7, $a6:7, $m8:9+=, $m7, 0
	// CHECK-SUPERVISOR: error: instruction requires: Worker mode
	ldst64pace $a6:7, $a6:7, $m8:9+=, $m7, 0
	// CHECK-ERROR: unknown token in expression
	ldst64pace $a6:7, $a6:7, $m9:10+=, $m7, 0

	// CHECK: ldst64pace $a6:7, $a6:7, $m10:11+=, $m7, 0
	// CHECK-SUPERVISOR: error: instruction requires: Worker mode
	ldst64pace $a6:7, $a6:7, $m10:11+=, $m7, 0
	// CHECK-ERROR: unknown token in expression
	ldst64pace $a6:7, $a6:7, $m11:12+=, $m7, 0

	// CHECK: ldst64pace $a6:7, $a6:7, $m12:13+=, $m7, 0
	// CHECK-SUPERVISOR: error: instruction requires: Worker mode
	ldst64pace $a6:7, $a6:7, $m12:13+=, $m7, 0
	// CHECK-ERROR: unknown token in expression
	ldst64pace $a6:7, $a6:7, $m13:14+=, $m7, 0

	// CHECK: ldst64pace $a6:7, $a6:7, $m14:15+=, $m7, 0
	// CHECK-SUPERVISOR: error: instruction requires: Worker mode
	ldst64pace $a6:7, $a6:7, $m14:15+=, $m7, 0
	// CHECK-ERROR: unknown token in expression
	ldst64pace $a6:7, $a6:7, $m15:16+=, $m7, 0

CheckSupressionOfError:

	.allow_invalid_operands
	// CHECK: st64step $a0:1, $m0, $m1+=, $m2
	// CHECK-ERROR-NOT: invalid operand for instruction
	// CHECK-SUPERVISOR: error: instruction requires: Worker mode
	st64step $a1:2, $m0, $m1+=, $m2

	.error_on_invalid_operands
	// CHECK-ERROR: invalid operand for instruction
	st64step $a1:2, $m0, $m1+=, $m2
