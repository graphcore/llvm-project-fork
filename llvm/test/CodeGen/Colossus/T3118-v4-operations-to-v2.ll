; RUN: llc < %s -mtriple=colossus | FileCheck %s

; CHECK-LABEL: fadd_f16v4:
; CHECK:       sort4x16lo $a0, $a0, $a1
; CHECK-NEXT:  sort4x16lo $a1, $a2, $a3
; CHECK-NEXT:  f16v2add $a0, $a0, $a1
; CHECK-NEXT:  {
; CHECK-NEXT:          br $m10
; CHECK-NEXT:          mov     $a1, $a0
; CHECK-NEXT:  }
define <4 x half> @fadd_f16v4(half %a, half %b, half %c, half %d) {
  %s0 = insertelement <4 x half> undef, half %a, i32 0
  %s1 = insertelement <4 x half> %s0, half %b, i32 1
  %s2 = insertelement <4 x half> %s1, half %a, i32 2
  %vec0 = insertelement <4 x half> %s2, half %b, i32 3

  %t0 = insertelement <4 x half> undef, half %c, i32 0
  %t1 = insertelement <4 x half> %t0, half %d, i32 1
  %t2 = insertelement <4 x half> %t1, half %c, i32 2
  %vec1 = insertelement <4 x half> %t2, half %d, i32 3

  %res = fadd <4 x half> %vec0, %vec1
  ret <4 x half> %res
}

; CHECK-LABEL: fadd_f16v4_palindromes:
; CHECK:       sort4x16lo $a0, $a0, $a1
; CHECK-NEXT:  sort4x16lo $a1, $a2, $a3
; CHECK-NEXT:  f16v2add $a0, $a0, $a1
; CHECK-NEXT:  {
; CHECK-NEXT:          br $m10
; CHECK-NEXT:          swap16  $a1, $a0
; CHECK-NEXT:  }
define <4 x half> @fadd_f16v4_palindromes(half %a, half %b, half %c, half %d) {
  %s0 = insertelement <4 x half> undef, half %a, i32 0
  %s1 = insertelement <4 x half> %s0, half %b, i32 1
  %s2 = insertelement <4 x half> %s1, half %b, i32 2
  %vec0 = insertelement <4 x half> %s2, half %a, i32 3

  %t0 = insertelement <4 x half> undef, half %c, i32 0
  %t1 = insertelement <4 x half> %t0, half %d, i32 1
  %t2 = insertelement <4 x half> %t1, half %d, i32 2
  %vec1 = insertelement <4 x half> %t2, half %c, i32 3

  %res = fadd <4 x half> %vec0, %vec1
  ret <4 x half> %res
}

; CHECK-LABEL: fsub_f16v4:
; CHECK:       sort4x16lo $a0, $a0, $a1
; CHECK-NEXT:  sort4x16lo $a1, $a2, $a3
; CHECK-NEXT:  f16v2sub $a0, $a0, $a1
; CHECK-NEXT:  {
; CHECK-NEXT:          br $m10
; CHECK-NEXT:          mov     $a1, $a0
; CHECK-NEXT:  }
define <4 x half> @fsub_f16v4(half %a, half %b, half %c, half %d) {
  %s0 = insertelement <4 x half> undef, half %a, i32 0
  %s1 = insertelement <4 x half> %s0, half %b, i32 1
  %s2 = insertelement <4 x half> %s1, half %a, i32 2
  %vec0 = insertelement <4 x half> %s2, half %b, i32 3

  %t0 = insertelement <4 x half> undef, half %c, i32 0
  %t1 = insertelement <4 x half> %t0, half %d, i32 1
  %t2 = insertelement <4 x half> %t1, half %c, i32 2
  %vec1 = insertelement <4 x half> %t2, half %d, i32 3

  %res = fsub <4 x half> %vec0, %vec1
  ret <4 x half> %res
}

; CHECK-LABEL: fsub_f16v4_palindromes:
; CHECK:       sort4x16lo $a0, $a0, $a1
; CHECK-NEXT:  sort4x16lo $a1, $a2, $a3
; CHECK-NEXT:  f16v2sub $a0, $a0, $a1
; CHECK-NEXT:  {
; CHECK-NEXT:          br $m10
; CHECK-NEXT:          swap16  $a1, $a0
; CHECK-NEXT:  }
define <4 x half> @fsub_f16v4_palindromes(half %a, half %b, half %c, half %d) {
  %s0 = insertelement <4 x half> undef, half %a, i32 0
  %s1 = insertelement <4 x half> %s0, half %b, i32 1
  %s2 = insertelement <4 x half> %s1, half %b, i32 2
  %vec0 = insertelement <4 x half> %s2, half %a, i32 3

  %t0 = insertelement <4 x half> undef, half %c, i32 0
  %t1 = insertelement <4 x half> %t0, half %d, i32 1
  %t2 = insertelement <4 x half> %t1, half %d, i32 2
  %vec1 = insertelement <4 x half> %t2, half %c, i32 3

  %res = fsub <4 x half> %vec0, %vec1
  ret <4 x half> %res
}

; CHECK-LABEL: fmul_f16v4:
; CHECK:       sort4x16lo $a0, $a0, $a1
; CHECK-NEXT:  sort4x16lo $a1, $a2, $a3
; CHECK-NEXT:  f16v2mul $a0, $a0, $a1
; CHECK-NEXT:  {
; CHECK-NEXT:          br $m10
; CHECK-NEXT:          mov     $a1, $a0
; CHECK-NEXT:  }
define <4 x half> @fmul_f16v4(half %a, half %b, half %c, half %d) {
  %s0 = insertelement <4 x half> undef, half %a, i32 0
  %s1 = insertelement <4 x half> %s0, half %b, i32 1
  %s2 = insertelement <4 x half> %s1, half %a, i32 2
  %vec0 = insertelement <4 x half> %s2, half %b, i32 3

  %t0 = insertelement <4 x half> undef, half %c, i32 0
  %t1 = insertelement <4 x half> %t0, half %d, i32 1
  %t2 = insertelement <4 x half> %t1, half %c, i32 2
  %vec1 = insertelement <4 x half> %t2, half %d, i32 3

  %res = fmul <4 x half> %vec0, %vec1
  ret <4 x half> %res
}

; CHECK-LABEL: fmul_f16v4_palindromes:
; CHECK:       sort4x16lo $a0, $a0, $a1
; CHECK-NEXT:  sort4x16lo $a1, $a2, $a3
; CHECK-NEXT:  f16v2mul $a0, $a0, $a1
; CHECK-NEXT:  {
; CHECK-NEXT:          br $m10
; CHECK-NEXT:          swap16     $a1, $a0
; CHECK-NEXT:  }
define <4 x half> @fmul_f16v4_palindromes(half %a, half %b, half %c, half %d) {
  %s0 = insertelement <4 x half> undef, half %a, i32 0
  %s1 = insertelement <4 x half> %s0, half %b, i32 1
  %s2 = insertelement <4 x half> %s1, half %b, i32 2
  %vec0 = insertelement <4 x half> %s2, half %a, i32 3

  %t0 = insertelement <4 x half> undef, half %c, i32 0
  %t1 = insertelement <4 x half> %t0, half %d, i32 1
  %t2 = insertelement <4 x half> %t1, half %d, i32 2
  %vec1 = insertelement <4 x half> %t2, half %c, i32 3

  %res = fmul <4 x half> %vec0, %vec1
  ret <4 x half> %res
}

; CHECK-LABEL: and_i16v4:
; CHECK:       sort4x16lo $m0, $m0, $m1
; CHECK-NEXT:  sort4x16lo $m1, $m2, $m3
; CHECK-NEXT:  and $m0, $m0, $m1
; CHECK-NEXT:  mov     $m1, $m0
define <4 x i16> @and_i16v4(i16 %a, i16 %b, i16 %c, i16 %d) {
  %s0 = insertelement <4 x i16> undef, i16 %a, i32 0
  %s1 = insertelement <4 x i16> %s0, i16 %b, i32 1
  %s2 = insertelement <4 x i16> %s1, i16 %a, i32 2
  %vec0 = insertelement <4 x i16> %s2, i16 %b, i32 3

  %t0 = insertelement <4 x i16> undef, i16 %c, i32 0
  %t1 = insertelement <4 x i16> %t0, i16 %d, i32 1
  %t2 = insertelement <4 x i16> %t1, i16 %c, i32 2
  %vec1 = insertelement <4 x i16> %t2, i16 %d, i32 3

  %res = and <4 x i16> %vec0, %vec1
  ret <4 x i16> %res
}

; CHECK-LABEL: and_i16v4_palindromes:
; CHECK:       sort4x16lo $m0, $m0, $m1
; CHECK-NEXT:  sort4x16lo $m1, $m2, $m3
; CHECK-NEXT:  and $m0, $m0, $m1
; CHECK-NEXT:  swap16     $m1, $m0
define <4 x i16> @and_i16v4_palindromes(i16 %a, i16 %b, i16 %c, i16 %d) {
  %s0 = insertelement <4 x i16> undef, i16 %a, i32 0
  %s1 = insertelement <4 x i16> %s0, i16 %b, i32 1
  %s2 = insertelement <4 x i16> %s1, i16 %b, i32 2
  %vec0 = insertelement <4 x i16> %s2, i16 %a, i32 3

  %t0 = insertelement <4 x i16> undef, i16 %c, i32 0
  %t1 = insertelement <4 x i16> %t0, i16 %d, i32 1
  %t2 = insertelement <4 x i16> %t1, i16 %d, i32 2
  %vec1 = insertelement <4 x i16> %t2, i16 %c, i32 3

  %res = and <4 x i16> %vec0, %vec1
  ret <4 x i16> %res
}

; CHECK-LABEL: or_i16v2:
; CHECK:       sort4x16lo $m0, $m0, $m1
; CHECK-NEXT:  sort4x16lo $m1, $m2, $m3
; CHECK-NEXT:  or $m0, $m0, $m1
; CHECK-NEXT:  mov     $m1, $m0
define <4 x i16> @or_i16v2(i16 %a, i16 %b, i16 %c, i16 %d) {
  %s0 = insertelement <4 x i16> undef, i16 %a, i32 0
  %s1 = insertelement <4 x i16> %s0, i16 %b, i32 1
  %s2 = insertelement <4 x i16> %s1, i16 %a, i32 2
  %vec0 = insertelement <4 x i16> %s2, i16 %b, i32 3

  %t0 = insertelement <4 x i16> undef, i16 %c, i32 0
  %t1 = insertelement <4 x i16> %t0, i16 %d, i32 1
  %t2 = insertelement <4 x i16> %t1, i16 %c, i32 2
  %vec1 = insertelement <4 x i16> %t2, i16 %d, i32 3

  %res = or <4 x i16> %vec0, %vec1
  ret <4 x i16> %res
}

; CHECK-LABEL: xor_i16v2:
; CHECK:       sort4x16lo $m0, $m0, $m1
; CHECK-NEXT:  sort4x16lo $m1, $m2, $m3
; CHECK-NEXT:  xor $m0, $m0, $m1
; CHECK-NEXT:  mov     $m1, $m0
define <4 x i16> @xor_i16v2(i16 %a, i16 %b, i16 %c, i16 %d) {
  %s0 = insertelement <4 x i16> undef, i16 %a, i32 0
  %s1 = insertelement <4 x i16> %s0, i16 %b, i32 1
  %s2 = insertelement <4 x i16> %s1, i16 %a, i32 2
  %vec0 = insertelement <4 x i16> %s2, i16 %b, i32 3

  %t0 = insertelement <4 x i16> undef, i16 %c, i32 0
  %t1 = insertelement <4 x i16> %t0, i16 %d, i32 1
  %t2 = insertelement <4 x i16> %t1, i16 %c, i32 2
  %vec1 = insertelement <4 x i16> %t2, i16 %d, i32 3

  %res = xor <4 x i16> %vec0, %vec1
  ret <4 x i16> %res
}

; CHECK-LABEL: fadd_v4_bitcast_2nd_vec:
; CHECK:       {
; CHECK-NEXT:          add $m11, $m11, -8
; CHECK-NEXT:          sort4x16lo $a0, $a0, $a1
; CHECK-NEXT:  }
; CHECK-NEXT:  .cfi_def_cfa_offset 8
; CHECK-NEXT:  sort4x16lo $m0, $m0, $m1
; CHECK-NEXT:  st32 $m0, $m11, $m15, 1
; CHECK-NEXT:  ld32 $a1, $m11, $m15, 1
; CHECK-NEXT:  f16v2add $a0, $a0, $a1
; CHECK-NEXT:  {
; CHECK-NEXT:          add $m11, $m11, 8
; CHECK-NEXT:          mov     $a1, $a0
; CHECK-NEXT:  }
; CHECK-NEXT:  .cfi_def_cfa_offset 0
; CHECK-NEXT:  br $m10
define <4 x half> @fadd_v4_bitcast_2nd_vec(half %a, half %b, i16 %c, i16 %d) {
  %sa0 = insertelement <4 x half> undef, half %a, i32 0
  %sa1 = insertelement <4 x half> %sa0, half %b, i32 1
  %sa2 = insertelement <4 x half> %sa1, half %a, i32 2
  %vec0 = insertelement <4 x half> %sa2, half %b, i32 3

  %sb0 = insertelement <4 x i16> undef, i16 %c, i32 0
  %sb1 = insertelement <4 x i16> %sb0, i16 %d, i32 1
  %sb2 = insertelement <4 x i16> %sb1, i16 %c, i32 2
  %sb3 = insertelement <4 x i16> %sb2, i16 %d, i32 3
  
  %vec1 = bitcast <4 x i16> %sb3 to <4 x half>

  %res = fadd <4 x half> %vec0, %vec1
  ret <4 x half> %res
}

; CHECK-LABEL: fadd_v4_bitcast_2nd_vec_palindromes:
; CHECK:       {
; CHECK-NEXT:          add $m11, $m11, -8
; CHECK-NEXT:          sort4x16lo $a0, $a0, $a1
; CHECK-NEXT:  }
; CHECK-NEXT:  .cfi_def_cfa_offset 8
; CHECK-NEXT:  sort4x16lo $m0, $m0, $m1
; CHECK-NEXT:  st32 $m0, $m11, $m15, 1
; CHECK-NEXT:  ld32 $a1, $m11, $m15, 1
; CHECK-NEXT:  f16v2add $a0, $a0, $a1
; CHECK-NEXT:  {
; CHECK-NEXT:          add $m11, $m11, 8
; CHECK-NEXT:          swap16     $a1, $a0
; CHECK-NEXT:  }
; CHECK-NEXT:  .cfi_def_cfa_offset 0
; CHECK-NEXT:  br $m10
define <4 x half> @fadd_v4_bitcast_2nd_vec_palindromes(half %a, half %b, 
                                                       i16 %c, i16 %d) {
  %sa0 = insertelement <4 x half> undef, half %a, i32 0
  %sa1 = insertelement <4 x half> %sa0, half %b, i32 1
  %sa2 = insertelement <4 x half> %sa1, half %b, i32 2
  %vec0 = insertelement <4 x half> %sa2, half %a, i32 3

  %sb0 = insertelement <4 x i16> undef, i16 %c, i32 0
  %sb1 = insertelement <4 x i16> %sb0, i16 %d, i32 1
  %sb2 = insertelement <4 x i16> %sb1, i16 %d, i32 2
  %sb3 = insertelement <4 x i16> %sb2, i16 %c, i32 3
  
  %vec1 = bitcast <4 x i16> %sb3 to <4 x half>

  %res = fadd <4 x half> %vec0, %vec1
  ret <4 x half> %res
}

; CHECK-LABEL: fadd_v4_bitcast_4th_elt:
; CHECK:       add $m11, $m11, -8
; CHECK-NEXT:  .cfi_def_cfa_offset 8
; CHECK-NEXT:  st32 $m0, $m11, $m15, 1
; CHECK-NEXT:  {
; CHECK-NEXT:  ld32 $a3, $m11, $m15, 1
; CHECK-NEXT:  sort4x16lo $a0, $a0, $a1
; CHECK-NEXT:  }
; CHECK-NEXT:  sort4x16lo $a1, $a2, $a3
; CHECK-NEXT:  f16v2add $a0, $a0, $a1
; CHECK-NEXT:  {
; CHECK-NEXT:          add $m11, $m11, 8
; CHECK-NEXT:          mov     $a1, $a0
; CHECK-NEXT:  }
define <4 x half> @fadd_v4_bitcast_4th_elt(half %a, half %b, half %c, i16 %d) {
  %sa0 = insertelement <4 x half> undef, half %a, i32 0
  %sa1 = insertelement <4 x half> %sa0, half %b, i32 1
  %sa2 = insertelement <4 x half> %sa1, half %a, i32 2
  %vec0 = insertelement <4 x half> %sa2, half %b, i32 3

  %halfd = bitcast i16 %d to half

  %sb0 = insertelement <4 x half> undef, half %c, i32 0
  %sb1 = insertelement <4 x half> %sb0, half %halfd, i32 1
  %sb2 = insertelement <4 x half> %sb1, half %c, i32 2
  %vec1 = insertelement <4 x half> %sb2, half %halfd, i32 3
  
  %res = fadd <4 x half> %vec0, %vec1
  ret <4 x half> %res
}

; CHECK-LABEL: fadd_v4_bitcast_4th_elt_palindromes:
; CHECK:       add $m11, $m11, -8
; CHECK-NEXT:  .cfi_def_cfa_offset 8
; CHECK-NEXT:  st32 $m0, $m11, $m15, 1
; CHECK-NEXT:  {
; CHECK-NEXT:  ld32 $a3, $m11, $m15, 1
; CHECK-NEXT:  sort4x16lo $a0, $a0, $a1
; CHECK-NEXT:  }
; CHECK-NEXT:  sort4x16lo $a1, $a2, $a3
; CHECK-NEXT:  f16v2add $a0, $a0, $a1
; CHECK-NEXT:  {
; CHECK-NEXT:          add $m11, $m11, 8
; CHECK-NEXT:          swap16     $a1, $a0
; CHECK-NEXT:  }
define <4 x half> @fadd_v4_bitcast_4th_elt_palindromes(half %a, half %b, 
                                                       half %c, i16 %d) {
  %sa0 = insertelement <4 x half> undef, half %a, i32 0
  %sa1 = insertelement <4 x half> %sa0, half %b, i32 1
  %sa2 = insertelement <4 x half> %sa1, half %b, i32 2
  %vec0 = insertelement <4 x half> %sa2, half %a, i32 3

  %halfd = bitcast i16 %d to half

  %sb0 = insertelement <4 x half> undef, half %c, i32 0
  %sb1 = insertelement <4 x half> %sb0, half %halfd, i32 1
  %sb2 = insertelement <4 x half> %sb1, half %halfd, i32 2
  %vec1 = insertelement <4 x half> %sb2, half %c, i32 3
  
  %res = fadd <4 x half> %vec0, %vec1
  ret <4 x half> %res
}

; CHECK-LABEL: fadd_v4_bitcast_all:
; CHECK:       add $m11, $m11, -8
; CHECK-NEXT:  .cfi_def_cfa_offset 8
; CHECK-NEXT:  sort4x16lo $m0, $m0, $m1
; CHECK-NEXT:  sort4x16lo $m1, $m2, $m3
; CHECK-NEXT:  st32 $m0, $m11, $m15, 1
; CHECK-NEXT:  ld32 $a0, $m11, $m15, 1
; CHECK-NEXT:  st32 $m1, $m11, $m15, 1
; CHECK-NEXT:  ld32 $a1, $m11, $m15, 1
; CHECK-NEXT:  f16v2add $a0, $a0, $a1
; CHECK-NEXT:  {
; CHECK-NEXT:          add $m11, $m11, 8
; CHECK-NEXT:          mov $a1, $a0
; CHECK-NEXT:  }
define <4 x half> @fadd_v4_bitcast_all(i16 %a, i16 %b, i16 %c, i16 %d) {
  %sa0 = insertelement <4 x i16> undef, i16 %a, i32 0
  %sa1 = insertelement <4 x i16> %sa0, i16 %b, i32 1
  %sa2 = insertelement <4 x i16> %sa1, i16 %a, i32 2
  %sa3 = insertelement <4 x i16> %sa2, i16 %b, i32 3

  %vec0 = bitcast <4 x i16> %sa3 to <4 x half>

  %sb0 = insertelement <4 x i16> undef, i16 %c, i32 0
  %sb1 = insertelement <4 x i16> %sb0, i16 %d, i32 1
  %sb2 = insertelement <4 x i16> %sb1, i16 %c, i32 2
  %sb3 = insertelement <4 x i16> %sb2, i16 %d, i32 3

  %vec1 = bitcast <4 x i16> %sb3 to <4 x half>

  %res = fadd <4 x half> %vec0, %vec1
  ret <4 x half> %res
}
