; -colossus-coissue is enabled by default. Should be disabled when building supervisor code
; RUN: llc < %s -march=colossus -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -march=colossus -mattr=+ipu2 | FileCheck %s
; RUN: llc < %s -march=colossus -mattr=+ipu1 -colossus-coissue=true | FileCheck %s
; RUN: llc < %s -march=colossus -mattr=+ipu2 -colossus-coissue=true | FileCheck %s
; RUN: llc < %s -march=colossus -colossus-coissue=false -mattr=+ipu1 | FileCheck %s --check-prefix=DISABLED
; RUN: llc < %s -march=colossus -colossus-coissue=false -mattr=+ipu2 | FileCheck %s --check-prefix=DISABLED

; RUN: llc < %s -march=colossus -mattr=+supervisor | FileCheck %s --check-prefix=SUPERVISOR
; RUN: llc < %s -march=colossus -colossus-coissue=true -mattr=+supervisor | FileCheck %s --check-prefix=SUPERVISOR
; RUN: llc < %s -march=colossus -colossus-coissue=false -mattr=+supervisor | FileCheck %s --check-prefix=SUPERVISOR

; CHECK-LABEL: M_arithmetic_then_branch:
; CHECK-NOT:   {
; CHECK-NOT:   }
; CHECK:       br $m10

; DISABLED-LABEL: M_arithmetic_then_branch:
; DISABLED-NOT:   {
; DISABLED-NOT:   }
; DISABLED:       br $m10

; SUPERVISOR-LABEL: M_arithmetic_then_branch:
; SUPERVISOR-NOT:   {
; SUPERVISOR-NOT:   }
; SUPERVISOR:       br $m10
define i32 @M_arithmetic_then_branch(i32 %x) {
   %r = add i32 %x, 1
   ret i32 %r
}

; CHECK-LABEL: M_branch_then_arithmetic:
; CHECK-NOT:   {
; CHECK-NOT:   }
; CHECK:       br $m10

; DISABLED-LABEL: M_branch_then_arithmetic:
; DISABLED-NOT:   {
; DISABLED-NOT:   }
; DISABLED:       br $m10

; SUPERVISOR-LABEL: M_branch_then_arithmetic:
; SUPERVISOR-NOT:   {
; SUPERVISOR-NOT:   }
; SUPERVISOR:       br $m10
define i32 @M_branch_then_arithmetic(i32 %x, i32 %y){
  %cmp = icmp eq i32 %y, 0
  %add = zext i1 %cmp to i32
  %add.x = shl nsw i32 %x, %add
  ret i32 %add.x
}

; CHECK-LABEL: A_branch_then_arithmetic:
; CHECK-NOT:   {
; CHECK-NOT:   }
; CHECK:       br $m10

; DISABLED-LABEL: A_branch_then_arithmetic:
; DISABLED-NOT:   {
; DISABLED-NOT:   }
; DISABLED:       br $m10

; SUPERVISOR-LABEL: A_branch_then_arithmetic:
; SUPERVISOR-NOT:   {
; SUPERVISOR-NOT:   }
; SUPERVISOR:       br $m10
define float @A_branch_then_arithmetic(float %x, i32 %y) {
entry:
  %cmp = icmp eq i32 %y, 0
  %add = fadd float %x, %x
  %add.x = select i1 %cmp, float %add, float %x
  ret float %add.x
}

; CHECK-LABEL: A_arithmetic_then_branch:
; CHECK:       # %bb.0:
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  add $a0, $a0, $a0
; CHECK-NEXT:  }

; DISABLED-LABEL: A_arithmetic_then_branch:
; DISABLED:       # %bb.0:
; DISABLED-NOT:   {
; DISABLED-NEXT:  f32add $a0, $a0, $a0
; DISABLED-NEXT:  br $m10
; DISABLED-NOT:   }

; SUPERVISOR-LABEL: A_arithmetic_then_branch:               # @A_arithmetic_then_branch
; SUPERVISOR:        # %bb.0:
; SUPERVISOR:        add $m11, $m11, -8
; SUPERVISOR:        st32 $m10, $m11, $m15, 1        # 4-byte Folded Spill
; SUPERVISOR-NEXT:   mov $m1, $m0
; SUPERVISOR-NEXT:   call $m10, __addsf3
; SUPERVISOR-NEXT:   ld32 $m10, $m11, $m15, 1        # 4-byte Folded Reload
; SUPERVISOR-NEXT:   add $m11, $m11, 8
; SUPERVISOR:        br $m10
define float @A_arithmetic_then_branch(float %x) {
   %r = fadd float %x, %x
   ret float %r
}

declare i32 @sink_i32(i32)
declare float @sink_f32(float)

; CHECK-LABEL: M_arithmetic_then_call:
; CHECK-NOT:   {
; CHECK-NOT:   }
; CHECK:       br $m10

; DISABLED-LABEL: M_arithmetic_then_call:
; DISABLED-NOT:   {
; DISABLED-NOT:   }
; DISABLED:       br $m10

; SUPERVISOR-LABEL: M_arithmetic_then_call:
; SUPERVISOR-NOT:   {
; SUPERVISOR-NOT:   }
; SUPERVISOR:       br $m10
define i32 @M_arithmetic_then_call(i32 %x) {
  %mul = mul nsw i32 %x, %x
  %add = add nsw i32 %mul, %x
  %call = tail call i32 @sink_i32(i32 %add)
  ret i32 %call
}
; CHECK-LABEL: M_call_then_arithmetic:
; CHECK-NOT:   {
; CHECK-NOT:   }
; CHECK:       br $m10

; DISABLED-LABEL: M_call_then_arithmetic:
; DISABLED-NOT:   {
; DISABLED-NOT:   }
; DISABLED:       br $m10

; SUPERVISOR-LABEL: M_call_then_arithmetic:
; SUPERVISOR-NOT:   {
; SUPERVISOR-NOT:   }
; SUPERVISOR:       br $m10
define i32 @M_call_then_arithmetic(i32 %x) {
  %call = tail call i32 @sink_i32(i32 %x)
  %mul = mul nsw i32 %call, %x
  %add = add nsw i32 %mul, %x
  ret i32 %add
}

; Expect this to break once call can be coissued
; CHECK-LABEL: A_arithmetic_then_call:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; CHECK:       {
; CHECK-NEXT:  st32 $m10, $m11, $m15, 1
; CHECK-NEXT:  f32mul $a1, $a0, $a0
; CHECK-NEXT:  }
; CHECK-NEXT:  f32add $a0, $a1, $a0
; CHECK-NEXT:  call $m10, sink_f32
; CHECK-NEXT:  ld32 $m10, $m11, $m15, 1
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10

; DISABLED-LABEL: A_arithmetic_then_call:                 # @A_arithmetic_then_call
; DISABLED:        # %bb.0:                                # %entry
; DISABLED:        add $m11, $m11, -8
; DISABLED:        st32 $m10, $m11, $m15, 1        # 4-byte Folded Spill
; DISABLED-NEXT:   f32mul $a1, $a0, $a0
; DISABLED-NEXT:   f32add $a0, $a1, $a0
; DISABLED-NEXT:   call $m10, sink_f32
; DISABLED-NEXT:   ld32 $m10, $m11, $m15, 1        # 4-byte Folded Reload
; DISABLED-NEXT:   add $m11, $m11, 8
; DISABLED:        br $m10

; SUPERVISOR-LABEL: A_arithmetic_then_call:                 # @A_arithmetic_then_call
; SUPERVISOR:        # %bb.0:                                # %entry
; SUPERVISOR:        add $m11, $m11, -8
; SUPERVISOR:        st32 $m10, $m11, $m15, 1        # 4-byte Folded Spill
; SUPERVISOR-NEXT:   st32 $m7, $m11, $m15, 0         # 4-byte Folded Spill
; SUPERVISOR-NEXT:   mov $m7, $m0
; SUPERVISOR-NEXT:   mov $m1, $m7
; SUPERVISOR-NEXT:   call $m10, __mulsf3
; SUPERVISOR-NEXT:   mov $m1, $m7
; SUPERVISOR-NEXT:   call $m10, __addsf3
; SUPERVISOR-NEXT:   call $m10, sink_f32
; SUPERVISOR-NEXT:   ld32 $m7, $m11, $m15, 0         # 4-byte Folded Reload
; SUPERVISOR-NEXT:   ld32 $m10, $m11, $m15, 1        # 4-byte Folded Reload
; SUPERVISOR-NEXT:   add $m11, $m11, 8
; SUPERVISOR:        br $m10
define float @A_arithmetic_then_call(float %x) {
entry:
  %mul = fmul float %x, %x
  %add = fadd float %mul, %x
  %call = tail call float @sink_f32(float %add)
  ret float %call
}

; Expect this to remain valid once call can be coissued
; CHECK-LABEL: A_call_then_arithmetic:
; CHECK:       # %bb.0:
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m10, $m11, $m15, 1
; CHECK-NEXT:  {
; CHECK-NEXT:  st32 $a6, $m11, $m15, 0
; CHECK-NEXT:  mov $a6, $a0
; CHECK-NEXT:  }
; CHECK-NEXT:  call $m10, sink_f32
; CHECK-NEXT:  f32mul $a0, $a0, $a6
; CHECK-NEXT:  {
; CHECK-NEXT:  ld32 $a6, $m11, $m15, 0
; CHECK-NEXT:  f32add $a0, $a0, $a6
; CHECK-NEXT:  }
; CHECK-NEXT:  ld32 $m10, $m11, $m15, 1
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10

; DISABLED-LABEL: A_call_then_arithmetic:                 # @A_call_then_arithmetic
; DISABLED:        # %bb.0:                                # %entry
; DISABLED:        add $m11, $m11, -8
; DISABLED:        st32 $m10, $m11, $m15, 1        # 4-byte Folded Spill
; DISABLED-NEXT:   st32 $a6, $m11, $m15, 0         # 4-byte Folded Spill
; DISABLED-NEXT:   mov $a6, $a0
; DISABLED-NEXT:   call $m10, sink_f32
; DISABLED-NEXT:   f32mul $a0, $a0, $a6
; DISABLED-NEXT:   f32add $a0, $a0, $a6
; DISABLED-NEXT:   ld32 $a6, $m11, $m15, 0         # 4-byte Folded Reload
; DISABLED-NEXT:   ld32 $m10, $m11, $m15, 1        # 4-byte Folded Reload
; DISABLED-NEXT:   add $m11, $m11, 8
; DISABLED:        br $m10

; SUPERVISOR-LABEL: A_call_then_arithmetic:                 # @A_call_then_arithmetic
; SUPERVISOR:       # %bb.0:                                # %entry
; SUPERVISOR:       add $m11, $m11, -8
; SUPERVISOR:       st32 $m10, $m11, $m15, 1        # 4-byte Folded Spill
; SUPERVISOR-NEXT:  st32 $m7, $m11, $m15, 0         # 4-byte Folded Spill
; SUPERVISOR-NEXT:  mov $m7, $m0
; SUPERVISOR-NEXT:  call $m10, sink_f32
; SUPERVISOR-NEXT:  mov $m1, $m7
; SUPERVISOR-NEXT:  call $m10, __mulsf3
; SUPERVISOR-NEXT:  mov $m1, $m7
; SUPERVISOR-NEXT:  call $m10, __addsf3
; SUPERVISOR-NEXT:  ld32 $m7, $m11, $m15, 0         # 4-byte Folded Reload
; SUPERVISOR-NEXT:  ld32 $m10, $m11, $m15, 1        # 4-byte Folded Reload
; SUPERVISOR-NEXT:  add $m11, $m11, 8
; SUPERVISOR:       br $m10
define float @A_call_then_arithmetic(float %x) {
entry:
  %call = tail call float @sink_f32(float %x)
  %mul = fmul float %call, %x
  %add = fadd float %mul, %x
  ret float %add
}

; CHECK-LABEL: output_input_operand_clash:
; CHECK:       # %bb.0:
; CHECK-NEXT:  ld32 $a1, $m0, $m15, 0
; CHECK-NEXT:  {
; CHECK-NEXT:  br $m10
; CHECK-NEXT:  f32mul $a0, $a1, $a0
; CHECK-NEXT:  }

; DISABLED-LABEL: output_input_operand_clash:             # @output_input_operand_clash
; DISABLED:        # %bb.0:
; DISABLED-NEXT:   ld32 $a1, $m0, $m15, 0
; DISABLED-NEXT:   f32mul $a0, $a1, $a0
; DISABLED:        br $m10

; SUPERVISOR-LABEL: output_input_operand_clash:             # @output_input_operand_clash
; SUPERVISOR:        # %bb.0:
; SUPERVISOR:        add $m11, $m11, -8
; SUPERVISOR:        st32 $m10, $m11, $m15, 1        # 4-byte Folded Spill
; SUPERVISOR-NEXT:   mov $m2, $m0
; SUPERVISOR-NEXT:   ld32 $m0, $m1, $m15, 0
; SUPERVISOR-NEXT:   mov $m1, $m2
; SUPERVISOR-NEXT:   call $m10, __mulsf3
; SUPERVISOR-NEXT:   ld32 $m10, $m11, $m15, 1        # 4-byte Folded Reload
; SUPERVISOR-NEXT:   add $m11, $m11, 8
; SUPERVISOR:        br $m10
define float @output_input_operand_clash(float %y, float* %x) {
  %a = load float, float* %x, align 4
  %b = fmul float %a, %y
  ret float %b
}

; CHECK-LABEL: axpy_twice:
; CHECK:       # %bb.0:
; CHECK-NEXT:  ld32 $a1, $m0, $m15, 0
; CHECK-NEXT:  {
; CHECK-NEXT:  ld32 $a2, $m0, $m15, 1
; CHECK-NEXT:  f32add $a1, $a0, $a1
; CHECK-NEXT:  }
; CHECK-NEXT:  {
; CHECK-NEXT:  st32 $a1, $m1, $m15, 0
; CHECK-NEXT:  f32add $a0, $a0, $a2
; CHECK-NEXT:  }
; CHECK-NEXT:  st32 $a0, $m1, $m15, 1
; CHECK:       br $m10

; DISABLED-LABEL: axpy_twice:                             # @axpy_twice
; DISABLED:        # %bb.0:
; DISABLED-NEXT:   ld32 $a1, $m0, $m15, 0
; DISABLED-NEXT:   ld32 $a2, $m0, $m15, 1
; DISABLED-NEXT:   f32add $a1, $a0, $a1
; DISABLED-NEXT:   f32add $a0, $a0, $a2
; DISABLED-NEXT:   st32 $a1, $m1, $m15, 0
; DISABLED-NEXT:   st32 $a0, $m1, $m15, 1
; DISABLED:        br $m10

; SUPERVISOR-LABEL: axpy_twice:                             # @axpy_twice
; SUPERVISOR:        # %bb.0:
; SUPERVISOR:        add $m11, $m11, -24
; SUPERVISOR:        st32 $m8, $m11, $m15, 4         # 4-byte Folded Spill
; SUPERVISOR-NEXT:   st32 $m9, $m11, $m15, 3         # 4-byte Folded Spill
; SUPERVISOR-NEXT:   st32 $m10, $m11, $m15, 2        # 4-byte Folded Spill
; SUPERVISOR-NEXT:   st32 $m7, $m11, $m15, 1         # 4-byte Folded Spill
; SUPERVISOR-NEXT:   mov $m7, $m2
; SUPERVISOR-NEXT:   mov $m8, $m0
; SUPERVISOR-NEXT:   ld32 $m2, $m1, $m15, 0
; SUPERVISOR-NEXT:   ld32 $m0, $m1, $m15, 1
; SUPERVISOR-NEXT:   st32 $m0, $m11, $m15, 5
; SUPERVISOR-NEXT:   mov $m0, $m8
; SUPERVISOR-NEXT:   mov $m1, $m2
; SUPERVISOR-NEXT:   call $m10, __addsf3
; SUPERVISOR-NEXT:   mov $m9, $m0
; SUPERVISOR-NEXT:   mov $m0, $m8
; SUPERVISOR-NEXT:   ld32 $m1, $m11, $m15, 5
; SUPERVISOR-NEXT:   call $m10, __addsf3
; SUPERVISOR-NEXT:   st32 $m9, $m7, $m15, 0
; SUPERVISOR-NEXT:   st32 $m0, $m7, $m15, 1
; SUPERVISOR-NEXT:   ld32 $m7, $m11, $m15, 1         # 4-byte Folded Reload
; SUPERVISOR-NEXT:   ld32 $m10, $m11, $m15, 2        # 4-byte Folded Reload
; SUPERVISOR-NEXT:   ld32 $m9, $m11, $m15, 3         # 4-byte Folded Reload
; SUPERVISOR-NEXT:   ld32 $m8, $m11, $m15, 4         # 4-byte Folded Reload
; SUPERVISOR-NEXT:   add $m11, $m11, 24
; SUPERVISOR:        br $m10
define void @axpy_twice(float %y, float* %in, float* %out) {
  %pin0 = getelementptr float, float* %in, i32 0
  %pout0 = getelementptr float, float* %out, i32 0
  %pin1 = getelementptr float, float* %in, i32 1
  %pout1 = getelementptr float, float* %out, i32 1
  %in0 = load float, float* %pin0, align 4
  %in1 = load float, float* %pin1, align 4
  %add0 = fadd float %y, %in0
  %add1 = fadd float %y, %in1
  store float %add0, float* %pout0, align 4
  store float %add1, float* %pout1, align 4
  ret void
}
