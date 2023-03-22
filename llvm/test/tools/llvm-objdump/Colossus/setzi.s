# RUN: clang -c %s -o %texec 
# RUN: llvm-objdump -d %texec | FileCheck %s

.globl	main 

_Z4funcv:                           	# @_Z4funcv
# %bb.0:     
	br $m10	

main:                                   # @main
# %bb.0:                                # %entry
	setzi $a0, 629146					# disassembler shows no hex representation 
	setzi $m0, 311492       		    # try to confuse disassembler
	call $m10, _Z4funcv
	mov	$m0, $a0
	br $m10
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
  



# CHECK:       00000000 <_Z4funcv>:
# CHECK-NEXT:         0: 00 00 a0 43   br $m10

# CHECK:       00000004 <main>:
# CHECK-NEXT:         4: 9a 99 09 1a   setzi $a0, 629146
# CHECK-NEXT:         8: c4 c0 04 19   setzi $m0, 311492
# CHECK-NEXT:         c: 00 00 a0 18   call $m10, 0x0 <_Z4funcv>
# CHECK-NEXT:        10: 00 00 00 5d   mov     $m0, $a0
# CHECK-NEXT:        14: 00 00 a0 43   br $m10


# New patch objdump output: 

# 00000000 <_Z4funcv>:
#        0: 00 00 a0 43   br $m10
# 
# 00000004 <main>:
#        4: 9a 99 09 1a   setzi $a0, 629146
#        8: c4 c0 04 19   setzi $m0, 311492               # 0x4c0c4
#        c: 00 00 a0 18   call $m10, 0x0 <.text>          <-- Error with new patch
#       10: 00 00 00 5d   mov     $m0, $a0
#       14: 00 00 a0 43   br $m10
# 