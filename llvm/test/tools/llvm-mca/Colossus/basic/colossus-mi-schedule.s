# NOTE: Assertions have been autogenerated by utils/update_mca_test_checks.py
# RUN:  llvm-mca -mtriple=colossus -mcpu=ipu2  < %s | FileCheck %s

	
	.text
	.allow_optimizations
	.file	"colossus-mi-schedule.ll"
	.globl	one_cycle_load                  # -- Begin function one_cycle_load
	.p2align	2
	.type	one_cycle_load,@function
one_cycle_load:                         # @one_cycle_load
	.cfi_startproc
# %bb.0:                                # %entry
	xor $m2, $m1, $m2
	ld32 $m0, $m0, $m15, 0
	mul $m2, $m2, $m3
	sub $m0, $m0, $m1
	add $m1, $m2, $m1
	or $m0, $m1, $m0
	br $m10
.Lfunc_end0:
	.size	one_cycle_load, .Lfunc_end0-one_cycle_load
	.cfi_endproc
                                        # -- End function
	.globl	coissue1                        # -- Begin function coissue1
	.p2align	2
	.type	coissue1,@function
coissue1:                               # @coissue1
	.cfi_startproc
# %bb.0:
	{
		xor $m0, $m0, $m1
		f32sub $a0, $a15, $a0
	}
	{
		xor $m0, $m0, $m2
		f32int $a0, $a0, 3
	}
	f32toui32 $a0, $a0
	mov	$m1, $a0
	and $m0, $m0, $m1
	br $m10
.Lfunc_end1:
	.size	coissue1, .Lfunc_end1-coissue1
	.cfi_endproc
                                        # -- End function
	.globl	coissue2                        # -- Begin function coissue2
	.p2align	2
	.type	coissue2,@function
coissue2:                               # @coissue2
	.cfi_startproc
# %bb.0:
	# LLVM-MCA-BEGIN fpcomp
	{
		# LLVM-MCA-BEGIN is1
		add $m11, $m11, -8
		f32add $a0, $a0, $a1
		# LLVM-MCA-END is1
	}
	.cfi_def_cfa_offset 8
	{
		sub $m0, 0, $m0
		f32add $a0, $a0, $a2
	}
	st32 $m0, $m11, $m15, 1
	ld32 $a1, $m11, $m15, 1
	f32fromui32 $a1, $a1
	{
		add $m11, $m11, 8
		f32mul $a0, $a0, $a1
	}
	# LLVM-MCA-END fpcomp
	.cfi_def_cfa_offset 0
	br $m10
.Lfunc_end2:
	.size	coissue2, .Lfunc_end2-coissue2
	.cfi_endproc
                                        # -- End function
	.globl	latency_before_nodeid           # -- Begin function latency_before_nodeid
	.p2align	2
	.type	latency_before_nodeid,@function
latency_before_nodeid:                  # @latency_before_nodeid
	.cfi_startproc
# %bb.0:                                # %entry
	{
		mul $m0, $m0, $m1
		f32add $a0, $a0, $a1
	}
	f32int $a0, $a0, 3
	f32toi32 $a0, $a0
	mov	$m1, $a0
	add $m0, $m0, $m1
	br $m10
.Lfunc_end3:
	.size	latency_before_nodeid, .Lfunc_end3-latency_before_nodeid
	.cfi_endproc
                                        # -- End function
	.section	".note.GNU-stack","",@progbits


CHECK:		 [0] Code Region - fpcomp

CHECK:		 Iterations:        100
CHECK-NEXT:	 Instructions:      900
CHECK-NEXT:	 Total Cycles:      502
CHECK-NEXT:	 Total uOps:        900

CHECK:		 Dispatch Width:    2
CHECK-NEXT:	 uOps Per Cycle:    1.79
CHECK-NEXT:	 IPC:               1.79
CHECK-NEXT:	 Block RThroughput: 5.0

CHECK:		 Instruction Info:
CHECK-NEXT:	 [1]: #uOps
CHECK-NEXT:	 [2]: Latency
CHECK-NEXT:	 [3]: RThroughput
CHECK-NEXT:	 [4]: MayLoad
CHECK-NEXT:	 [5]: MayStore
CHECK-NEXT:	 [6]: HasSideEffects (U)

CHECK:		 [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
CHECK-NEXT:	  1      1     1.00                        add $m11, $m11, -8
CHECK-NEXT:	  1      1     1.00                        f32add $a0, $a0, $a1
CHECK-NEXT:	  1      1     1.00                        sub $m0, 0, $m0
CHECK-NEXT:	  1      1     1.00                        f32add $a0, $a0, $a2
CHECK-NEXT:	  1      1     1.00           *            st32 $m0, $m11, $m15, 1
CHECK-NEXT:	  1      1     1.00    *                   ld32 $a1, $m11, $m15, 1
CHECK-NEXT:	  1      1     1.00                        f32fromui32 $a1, $a1
CHECK-NEXT:	  1      1     1.00                        add $m11, $m11, 8
CHECK-NEXT:	  1      1     1.00                        f32mul $a0, $a0, $a1


CHECK:		 Resources:
CHECK-NEXT:  [0]   - ColossusUnitAux
CHECK-NEXT:  [1]   - ColossusUnitMain

CHECK:		 Resource pressure per iteration:
CHECK-NEXT:  [0]    [1]    
CHECK-NEXT:  4.00   5.00   

CHECK:		 Resource pressure by instruction:
CHECK-NEXT:  [0]    [1]    Instructions:
CHECK-NEXT:   -     1.00   add $m11, $m11, -8
CHECK-NEXT:  1.00    -     f32add $a0, $a0, $a1
CHECK-NEXT:   -     1.00   sub $m0, 0, $m0
CHECK-NEXT:  1.00    -     f32add $a0, $a0, $a2
CHECK-NEXT:   -     1.00   st32 $m0, $m11, $m15, 1
CHECK-NEXT:   -     1.00   ld32 $a1, $m11, $m15, 1
CHECK-NEXT:  1.00    -     f32fromui32 $a1, $a1
CHECK-NEXT:   -     1.00   add $m11, $m11, 8
CHECK-NEXT:  1.00    -     f32mul $a0, $a0, $a1

CHECK:		 [1] Code Region - is1

CHECK:		 Iterations:        100
CHECK-NEXT:  Instructions:      200
CHECK-NEXT:  Total Cycles:      101
CHECK-NEXT:  Total uOps:        200

CHECK:		 Dispatch Width:    2
CHECK-NEXT:  uOps Per Cycle:    1.98
CHECK-NEXT:  IPC:               1.98
CHECK-NEXT:  Block RThroughput: 1.0

CHECK:	     Instruction Info:
CHECK-NEXT:  [1]: #uOps
CHECK-NEXT:  [2]: Latency
CHECK-NEXT:  [3]: RThroughput
CHECK-NEXT:  [4]: MayLoad
CHECK-NEXT:  [5]: MayStore
CHECK-NEXT:  [6]: HasSideEffects (U)

CHECK:		 [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
CHECK-NEXT:   1      1     1.00                        add $m11, $m11, -8
CHECK-NEXT:   1      1     1.00                        f32add $a0, $a0, $a1

CHECK:		 Resources:
CHECK-NEXT:  [0]   - ColossusUnitAux
CHECK-NEXT:  [1]   - ColossusUnitMain

CHECK:		 Resource pressure per iteration:
CHECK-NEXT:  [0]    [1]    
CHECK-NEXT:  1.00   1.00   

CHECK:		 Resource pressure by instruction:
CHECK-NEXT:  [0]    [1]    Instructions:
CHECK-NEXT:   -     1.00   add $m11, $m11, -8
CHECK-NEXT:  1.00    -     f32add $a0, $a0, $a1