; RUN: llc < %s -mtriple=colossus -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -mtriple=colossus -mattr=+ipu2 | FileCheck %s

; CHECK-LABEL: fadd_v2:
; CHECK:    	  .cfi_startproc
; CHECK-NEXT: # %bb.0:
; CHECK-NEXT: 	f32add $a0, $a0, $a1
; CHECK-NEXT: 	{
; CHECK-NEXT: 		br $m10
; CHECK-NEXT: 		mov	$a1, $a0
; CHECK-NEXT: 	}
define <2 x float> @fadd_v2(float %a, float %b) {
  %sa0 = insertelement <2 x float> undef, float %a, i32 0
  %sa1 = insertelement <2 x float> %sa0, float %a, i32 1
  %sb0 = insertelement <2 x float> undef, float %b, i32 0
  %sb1 = insertelement <2 x float> %sb0, float %b, i32 1
  %res = fadd <2 x float> %sa1, %sb1
  ret <2 x float> %res
}

; CHECK-LABEL: fsub_v2:
; CHECK:    	.cfi_startproc
; CHECK-NEXT: # %bb.0:
; CHECK-NEXT: 	f32sub $a0, $a0, $a1
; CHECK-NEXT: 	{
; CHECK-NEXT: 		br $m10
; CHECK-NEXT: 		mov	$a1, $a0
; CHECK-NEXT: 	}
define <2 x float> @fsub_v2(float %a, float %b) {
  %sa0 = insertelement <2 x float> undef, float %a, i32 0
  %sa1 = insertelement <2 x float> %sa0, float %a, i32 1
  %sb0 = insertelement <2 x float> undef, float %b, i32 0
  %sb1 = insertelement <2 x float> %sb0, float %b, i32 1
  %res = fsub <2 x float> %sa1, %sb1
  ret <2 x float> %res
}

; CHECK-LABEL: fmul_v2:
; CHECK:    	.cfi_startproc
; CHECK-NEXT: # %bb.0:
; CHECK-NEXT: 	f32mul $a0, $a0, $a1
; CHECK-NEXT: 	{
; CHECK-NEXT: 		br $m10
; CHECK-NEXT: 		mov	$a1, $a0
; CHECK-NEXT: 	}
define <2 x float> @fmul_v2(float %a, float %b) {
  %sa0 = insertelement <2 x float> undef, float %a, i32 0
  %sa1 = insertelement <2 x float> %sa0, float %a, i32 1
  %sb0 = insertelement <2 x float> undef, float %b, i32 0
  %sb1 = insertelement <2 x float> %sb0, float %b, i32 1
  %res = fmul <2 x float> %sa1, %sb1
  ret <2 x float> %res
}

; CHECK-LABEL: and_v2:
; CHECK:    	.cfi_startproc
; CHECK-NEXT: # %bb.0:
; CHECK-NEXT: 	and $m0, $m0, $m1
; CHECK-NEXT: 	mov	$m1, $m0
; CHECK-NEXT: 	br $m10
define <2 x i32> @and_v2(i32 %a, i32 %b) {
  %sa0 = insertelement <2 x i32> undef, i32 %a, i32 0
  %sa1 = insertelement <2 x i32> %sa0, i32 %a, i32 1
  %sb0 = insertelement <2 x i32> undef, i32 %b, i32 0
  %sb1 = insertelement <2 x i32> %sb0, i32 %b, i32 1
  %res = and <2 x i32> %sa1, %sb1
  ret <2 x i32> %res
}

; CHECK-LABEL: or_v2:
; CHECK:    	.cfi_startproc
; CHECK-NEXT: # %bb.0:
; CHECK-NEXT: 	or $m0, $m0, $m1
; CHECK-NEXT: 	mov	$m1, $m0
; CHECK-NEXT: 	br $m10
define <2 x i32> @or_v2(i32 %a, i32 %b) {
  %sa0 = insertelement <2 x i32> undef, i32 %a, i32 0
  %sa1 = insertelement <2 x i32> %sa0, i32 %a, i32 1
  %sb0 = insertelement <2 x i32> undef, i32 %b, i32 0
  %sb1 = insertelement <2 x i32> %sb0, i32 %b, i32 1
  %res = or <2 x i32> %sa1, %sb1
  ret <2 x i32> %res
}

; CHECK-LABEL: xor_v2:
; CHECK:    	.cfi_startproc
; CHECK-NEXT: # %bb.0:
; CHECK-NEXT: 	xor $m0, $m0, $m1
; CHECK-NEXT: 	mov	$m1, $m0
; CHECK-NEXT: 	br $m10
define <2 x i32> @xor_v2(i32 %a, i32 %b) {
  %sa0 = insertelement <2 x i32> undef, i32 %a, i32 0
  %sa1 = insertelement <2 x i32> %sa0, i32 %a, i32 1
  %sb0 = insertelement <2 x i32> undef, i32 %b, i32 0
  %sb1 = insertelement <2 x i32> %sb0, i32 %b, i32 1
  %res = xor <2 x i32> %sa1, %sb1
  ret <2 x i32> %res
}

; CHECK-LABEL: fcmp_oeq_v2
; CHECK: # %bb.0:
; CHECK-NEXT: 	f32cmpeq $a0, $a0, $a1
; CHECK-NEXT: 	mov $m0, $a0
; CHECK-NEXT: 	mov $m1, $m0
; CHECK-NEXT: 	sort4x16lo $m0, $m0, $m1
; CHECK-NEXT: 	br $m10
define <2 x i1> @fcmp_oeq_v2(float %a, float %b) {
  %sa0 = insertelement <2 x float> undef, float %a, i32 0
  %sa1 = insertelement <2 x float> %sa0, float %a, i32 1
  %sb0 = insertelement <2 x float> undef, float %b, i32 0
  %sb1 = insertelement <2 x float> %sb0, float %b, i32 1
  %res = fcmp oeq <2 x float> %sa1, %sb1
  ret <2 x i1> %res
}

; CHECK-LABEL: fcmp_one_v2
; CHECK: # %bb.0:
; CHECK-NEXT: 	f32cmpgt $a2, $a0, $a1
; CHECK-NEXT: 	f32cmplt $a0, $a0, $a1
; CHECK-NEXT: 	or $a0, $a0, $a2
; CHECK-NEXT: 	mov $m0, $a0
; CHECK-NEXT: 	mov $m1, $m0
; CHECK-NEXT: 	sort4x16lo $m0, $m0, $m1
; CHECK-NEXT: 	br $m10
define <2 x i1> @fcmp_one_v2(float %a, float %b) {
  %sa0 = insertelement <2 x float> undef, float %a, i32 0
  %sa1 = insertelement <2 x float> %sa0, float %a, i32 1
  %sb0 = insertelement <2 x float> undef, float %b, i32 0
  %sb1 = insertelement <2 x float> %sb0, float %b, i32 1
  %res = fcmp one <2 x float> %sa1, %sb1
  ret <2 x i1> %res
}

; CHECK-LABEL: fcmp_ogt_v2
; CHECK: # %bb.0:
; CHECK-NEXT: 	f32cmpgt $a0, $a0, $a1
; CHECK-NEXT: 	mov $m0, $a0
; CHECK-NEXT: 	mov $m1, $m0
; CHECK-NEXT: 	sort4x16lo $m0, $m0, $m1
; CHECK-NEXT: 	br $m10
define <2 x i1> @fcmp_ogt_v2(float %a, float %b) {
  %sa0 = insertelement <2 x float> undef, float %a, i32 0
  %sa1 = insertelement <2 x float> %sa0, float %a, i32 1
  %sb0 = insertelement <2 x float> undef, float %b, i32 0
  %sb1 = insertelement <2 x float> %sb0, float %b, i32 1
  %res = fcmp ogt <2 x float> %sa1, %sb1
  ret <2 x i1> %res
}

; CHECK-LABEL: fcmp_oge_v2
; CHECK: # %bb.0:
; CHECK-NEXT: 	f32cmpge $a0, $a0, $a1
; CHECK-NEXT: 	mov $m0, $a0
; CHECK-NEXT: 	mov $m1, $m0
; CHECK-NEXT: 	sort4x16lo $m0, $m0, $m1
; CHECK-NEXT: 	br $m10
define <2 x i1> @fcmp_oge_v2(float %a, float %b) {
  %sa0 = insertelement <2 x float> undef, float %a, i32 0
  %sa1 = insertelement <2 x float> %sa0, float %a, i32 1
  %sb0 = insertelement <2 x float> undef, float %b, i32 0
  %sb1 = insertelement <2 x float> %sb0, float %b, i32 1
  %res = fcmp oge <2 x float> %sa1, %sb1
  ret <2 x i1> %res
}

; CHECK-LABEL: fcmp_olt_v2
; CHECK: # %bb.0:
; CHECK-NEXT: 	f32cmplt $a0, $a0, $a1
; CHECK-NEXT: 	mov $m0, $a0
; CHECK-NEXT: 	mov $m1, $m0
; CHECK-NEXT: 	sort4x16lo $m0, $m0, $m1
; CHECK-NEXT: 	br $m10
define <2 x i1> @fcmp_olt_v2(float %a, float %b) {
  %sa0 = insertelement <2 x float> undef, float %a, i32 0
  %sa1 = insertelement <2 x float> %sa0, float %a, i32 1
  %sb0 = insertelement <2 x float> undef, float %b, i32 0
  %sb1 = insertelement <2 x float> %sb0, float %b, i32 1
  %res = fcmp olt <2 x float> %sa1, %sb1
  ret <2 x i1> %res
}

; CHECK-LABEL: fcmp_ole_v2
; CHECK: # %bb.0:
; CHECK-NEXT: 	f32cmple $a0, $a0, $a1
; CHECK-NEXT: 	mov $m0, $a0
; CHECK-NEXT: 	mov $m1, $m0
; CHECK-NEXT: 	sort4x16lo $m0, $m0, $m1
; CHECK-NEXT: 	br $m10
define <2 x i1> @fcmp_ole_v2(float %a, float %b) {
  %sa0 = insertelement <2 x float> undef, float %a, i32 0
  %sa1 = insertelement <2 x float> %sa0, float %a, i32 1
  %sb0 = insertelement <2 x float> undef, float %b, i32 0
  %sb1 = insertelement <2 x float> %sb0, float %b, i32 1
  %res = fcmp ole <2 x float> %sa1, %sb1
  ret <2 x i1> %res
}

; CHECK-LABEL: fcmp_ord_v2
; CHECK: # %bb.0:
; CHECK-NEXT: 	f32cmpeq $a1, $a1, $a1
; CHECK-NEXT: 	f32cmpeq $a0, $a0, $a0
; CHECK-NEXT: 	and $a0, $a0, $a1
; CHECK-NEXT: 	mov $m0, $a0
; CHECK-NEXT: 	mov $m1, $m0
; CHECK-NEXT: 	sort4x16lo $m0, $m0, $m1
; CHECK-NEXT: 	br $m10
define <2 x i1> @fcmp_ord_v2(float %a, float %b) {
  %sa0 = insertelement <2 x float> undef, float %a, i32 0
  %sa1 = insertelement <2 x float> %sa0, float %a, i32 1
  %sb0 = insertelement <2 x float> undef, float %b, i32 0
  %sb1 = insertelement <2 x float> %sb0, float %b, i32 1
  %res = fcmp ord <2 x float> %sa1, %sb1
  ret <2 x i1> %res
}

; CHECK-LABEL: fcmp_ueq_v2
; CHECK: # %bb.0:
; CHECK-NEXT: 	f32cmpgt $a2, $a0, $a1
; CHECK-NEXT: 	f32cmplt $a0, $a0, $a1
; CHECK-NEXT: 	or $a0, $a0, $a2
; CHECK-NEXT: 	not $a0, $a0
; CHECK-NEXT: 	mov $m0, $a0
; CHECK-NEXT: 	mov $m1, $m0
; CHECK-NEXT: 	sort4x16lo $m0, $m0, $m1
; CHECK-NEXT: 	br $m10
define <2 x i1> @fcmp_ueq_v2(float %a, float %b) {
  %sa0 = insertelement <2 x float> undef, float %a, i32 0
  %sa1 = insertelement <2 x float> %sa0, float %a, i32 1
  %sb0 = insertelement <2 x float> undef, float %b, i32 0
  %sb1 = insertelement <2 x float> %sb0, float %b, i32 1
  %res = fcmp ueq <2 x float> %sa1, %sb1
  ret <2 x i1> %res
}

; CHECK-LABEL: fcmp_une_v2
; CHECK: # %bb.0:
; CHECK-NEXT: 	f32cmpne $a0, $a0, $a1
; CHECK-NEXT: 	mov $m0, $a0
; CHECK-NEXT: 	mov $m1, $m0
; CHECK-NEXT: 	sort4x16lo $m0, $m0, $m1
; CHECK-NEXT: 	br $m10
define <2 x i1> @fcmp_une_v2(float %a, float %b) {
  %sa0 = insertelement <2 x float> undef, float %a, i32 0
  %sa1 = insertelement <2 x float> %sa0, float %a, i32 1
  %sb0 = insertelement <2 x float> undef, float %b, i32 0
  %sb1 = insertelement <2 x float> %sb0, float %b, i32 1
  %res = fcmp une <2 x float> %sa1, %sb1
  ret <2 x i1> %res
}

; CHECK-LABEL: fcmp_ugt_v2
; CHECK: # %bb.0:
; CHECK-NEXT: 	f32cmple $a0, $a0, $a1
; CHECK-NEXT: 	not $a0, $a0
; CHECK-NEXT: 	mov $m0, $a0
; CHECK-NEXT: 	mov $m1, $m0
; CHECK-NEXT: 	sort4x16lo $m0, $m0, $m1
; CHECK-NEXT: 	br $m10
define <2 x i1> @fcmp_ugt_v2(float %a, float %b) {
  %sa0 = insertelement <2 x float> undef, float %a, i32 0
  %sa1 = insertelement <2 x float> %sa0, float %a, i32 1
  %sb0 = insertelement <2 x float> undef, float %b, i32 0
  %sb1 = insertelement <2 x float> %sb0, float %b, i32 1
  %res = fcmp ugt <2 x float> %sa1, %sb1
  ret <2 x i1> %res
}

; CHECK-LABEL: fcmp_uge_v2
; CHECK: # %bb.0:
; CHECK-NEXT: 	f32cmplt $a0, $a0, $a1
; CHECK-NEXT: 	not $a0, $a0
; CHECK-NEXT: 	mov $m0, $a0
; CHECK-NEXT: 	mov $m1, $m0
; CHECK-NEXT: 	sort4x16lo $m0, $m0, $m1
; CHECK-NEXT: 	br $m10
define <2 x i1> @fcmp_uge_v2(float %a, float %b) {
  %sa0 = insertelement <2 x float> undef, float %a, i32 0
  %sa1 = insertelement <2 x float> %sa0, float %a, i32 1
  %sb0 = insertelement <2 x float> undef, float %b, i32 0
  %sb1 = insertelement <2 x float> %sb0, float %b, i32 1
  %res = fcmp uge <2 x float> %sa1, %sb1
  ret <2 x i1> %res
}

; CHECK-LABEL: fcmp_ult_v2
; CHECK: # %bb.0:
; CHECK-NEXT: 	f32cmpge $a0, $a0, $a1
; CHECK-NEXT: 	not $a0, $a0
; CHECK-NEXT: 	mov $m0, $a0
; CHECK-NEXT: 	mov $m1, $m0
; CHECK-NEXT: 	sort4x16lo $m0, $m0, $m1
; CHECK-NEXT: 	br $m10
define <2 x i1> @fcmp_ult_v2(float %a, float %b) {
  %sa0 = insertelement <2 x float> undef, float %a, i32 0
  %sa1 = insertelement <2 x float> %sa0, float %a, i32 1
  %sb0 = insertelement <2 x float> undef, float %b, i32 0
  %sb1 = insertelement <2 x float> %sb0, float %b, i32 1
  %res = fcmp ult <2 x float> %sa1, %sb1
  ret <2 x i1> %res
}

; CHECK-LABEL: fcmp_ule_v2
; CHECK: # %bb.0:
; CHECK-NEXT: 	f32cmpgt $a0, $a0, $a1
; CHECK-NEXT: 	not $a0, $a0
; CHECK-NEXT: 	mov $m0, $a0
; CHECK-NEXT: 	mov $m1, $m0
; CHECK-NEXT: 	sort4x16lo $m0, $m0, $m1
; CHECK-NEXT: 	br $m10
define <2 x i1> @fcmp_ule_v2(float %a, float %b) {
  %sa0 = insertelement <2 x float> undef, float %a, i32 0
  %sa1 = insertelement <2 x float> %sa0, float %a, i32 1
  %sb0 = insertelement <2 x float> undef, float %b, i32 0
  %sb1 = insertelement <2 x float> %sb0, float %b, i32 1
  %res = fcmp ule <2 x float> %sa1, %sb1
  ret <2 x i1> %res
}

; CHECK-LABEL: fcmp_uno_v2
; CHECK: # %bb.0:
; CHECK-NEXT: 	f32cmpne $a1, $a1, $a1
; CHECK-NEXT: 	f32cmpne $a0, $a0, $a0
; CHECK-NEXT: 	or $a0, $a0, $a1
; CHECK-NEXT: 	mov $m0, $a0
; CHECK-NEXT: 	mov $m1, $m0
; CHECK-NEXT: 	sort4x16lo $m0, $m0, $m1
; CHECK-NEXT: 	br $m10
define <2 x i1> @fcmp_uno_v2(float %a, float %b) {
  %sa0 = insertelement <2 x float> undef, float %a, i32 0
  %sa1 = insertelement <2 x float> %sa0, float %a, i32 1
  %sb0 = insertelement <2 x float> undef, float %b, i32 0
  %sb1 = insertelement <2 x float> %sb0, float %b, i32 1
  %res = fcmp uno <2 x float> %sa1, %sb1
  ret <2 x i1> %res
}

; CHECK-LABEL: fadd_v2_bitcast_right:
; CHECK:    	 st32 $m0, $m11, $m15, 1
; CHECK-NEXT:  ld32 $a1, $m11, $m15, 1
; CHECK-NEXT:  f32add $a0, $a0, $a1
; CHECK-NEXT:  {
; CHECK-NEXT:  	add $m11, $m11, 8
; CHECK-NEXT:  	mov	$a1, $a0
; CHECK-NEXT:  }
define <2 x float> @fadd_v2_bitcast_right(float %a, i32 %b) {
  %sa0 = insertelement <2 x float> undef, float %a, i32 0
  %sa1 = insertelement <2 x float> %sa0, float %a, i32 1
  %sb0 = insertelement <2 x i32> undef, i32 %b, i32 0
  %sb1 = insertelement <2 x i32> %sb0, i32 %b, i32 1
  %sb2 = bitcast <2 x i32> %sb1 to <2 x float>
  %res = fadd <2 x float> %sa1, %sb2
  ret <2 x float> %res
}

; CHECK-LABEL: fadd_v2_bitcast_left:
; CHECK:       st32 $m0, $m11, $m15, 1
; CHECK-NEXT:  ld32 $a1, $m11, $m15, 1
; CHECK-NEXT:  f32add $a0, $a1, $a0
; CHECK-NEXT:  {
; CHECK-NEXT:  	 add $m11, $m11, 8
; CHECK-NEXT:  	 mov	$a1, $a0
; CHECK-NEXT:  }
define <2 x float> @fadd_v2_bitcast_left(i32 %a, float %b) {
  %sa0 = insertelement <2 x i32> undef, i32 %a, i32 0
  %sa1 = insertelement <2 x i32> %sa0, i32 %a, i32 1
  %sa2 = bitcast <2 x i32> %sa1 to <2 x float>
  %sb0 = insertelement <2 x float> undef, float %b, i32 0
  %sb1 = insertelement <2 x float> %sb0, float %b, i32 1
  %res = fadd <2 x float> %sa2, %sb1
  ret <2 x float> %res
}

; CHECK-LABEL: fadd_v2_bitcast_both:
; CHECK:       st32 $m1, $m11, $m15, 1
; CHECK-NEXT:  ld32 $a0, $m11, $m15, 1
; CHECK-NEXT:  st32 $m0, $m11, $m15, 1
; CHECK-NEXT:  ld32 $a1, $m11, $m15, 1
; CHECK-NEXT:  f32add $a0, $a1, $a0
; CHECK-NEXT:  {
; CHECK-NEXT:  	add $m11, $m11, 8
; CHECK-NEXT:  	mov	$a1, $a0
; CHECK-NEXT:  }
define <2 x float> @fadd_v2_bitcast_both(i32 %a, i32 %b) {
  %sa0 = insertelement <2 x i32> undef, i32 %a, i32 0
  %sa1 = insertelement <2 x i32> %sa0, i32 %a, i32 1
  %sa2 = bitcast <2 x i32> %sa1 to <2 x float>
  %sb0 = insertelement <2 x i32> undef, i32 %b, i32 0
  %sb1 = insertelement <2 x i32> %sb0, i32 %b, i32 1
  %sb2 = bitcast <2 x i32> %sb1 to <2 x float>
  %res = fadd <2 x float> %sa2, %sb2
  ret <2 x float> %res
}
