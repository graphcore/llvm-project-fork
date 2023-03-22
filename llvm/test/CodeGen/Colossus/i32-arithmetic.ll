; RUN: llc < %s -march=colossus -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -march=colossus -mattr=+ipu2 | FileCheck %s

;===------------------------------------------------------------------------===;
; ADD
;===------------------------------------------------------------------------===;

; CHECK-LABEL: add
; CHECK        add $m0, $m0, $m1
define i32 @add(i32 %a, i32 %b) {
  %1 = add i32 %a, %b
  ret i32 %1
}

; CHECK-LABEL: addzi
; CHECK        add $m0, $m0, 65535
define i32 @addzi(i32 %a) {
  %1 = add i32 %a, 65535
  ret i32 %1
}

; CHECK-LABEL: addiz
; CHECK        add $m0, $m0, 4293918720
define i32 @addiz(i32 %a) {
  %1 = add i32 %a, 4293918720
  ret i32 %1
}

; CHECK-LABEL: addsi
; CHECK        add $m0, $m0, -1
define i32 @addsi(i32 %a) {
  %1 = add i32 %a, -1
  ret i32 %1
}

;===------------------------------------------------------------------------===;
; AND
;===------------------------------------------------------------------------===;

; CHECK-LABEL: and:
; CHECK        and $m0, $m0, $m1
define i32 @and(i32 %a, i32 %b) {
  %1 = and i32 %a, %b
  ret i32 %1
}

; CHECK-LABEL: and_i32_v2i16:
; CHECK        and $m0, $m0, $m1
define i32 @and_i32_v2i16(i32 %a, <2 x i16> %b) {
  %1 = bitcast <2 x i16> %b to i32
  %2 = and i32 %a, %1
  ret i32 %2
}

; CHECK-LABEL: and_v2i16_i32:
; CHECK        and $m0, $m0, $m1
define i32 @and_v2i16_i32(<2 x i16> %a, i32 %b) {
  %1 = bitcast <2 x i16> %a to i32
  %2 = and i32 %1, %b
  ret i32 %2
}

; CHECK-LABEL: andiz:
; CHECK        and $m0, $m0, 42
define i32 @andiz(i32 %a) {
  %1 = and i32 %a, 42
  ret i32 %1
}

; CHECK-LABEL: andc:
; CHECK        andc $m0, $m0, $m1
define i32 @andc(i32 %a, i32 %b) {
  %1 = xor i32 %b, -1
  %2 = and i32 %a, %1
  ret i32 %2
}

;===------------------------------------------------------------------------===;
; MUL
;===------------------------------------------------------------------------===;

; CHECK-LABEL: mul
; CHECK:       mul $m0, $m0, $m1
; CHECK-NEXT:  br $m10
define i32 @mul(i32 %a, i32 %b) {
  %1 = mul i32 %a, %b
  ret i32 %1
}

; CHECK-LABEL: mulsi
; CHECK:       mul $m0, $m0, 3
; CHECK-NEXT:  br $m10
define i32 @mulsi(i32 %a) {
  %1 = mul i32 %a, 3
  ret i32 %1
}

;===------------------------------------------------------------------------===;
; OR
;===------------------------------------------------------------------------===;

; CHECK-LABEL: or
; CHECK        or $m0, $m0, $m1
define i32 @or(i32 %a, i32 %b) {
  %1 = or i32 %a, %b
  ret i32 %1
}

; CHECK-LABEL: oriz:
; CHECK        or $m0, $m0, 4293918720
define i32 @oriz(i32 %a) {
  %1 = or i32 %a, 4293918720
  ret i32 %1
}

;===------------------------------------------------------------------------===;
; SHL
;===------------------------------------------------------------------------===;

; CHECK-LABEL: shl
; CHECK        shl $m0, $m0, $m1
define i32 @shl(i32 %a, i32 %b) {
  %1 = shl i32 %a, %b
  ret i32 %1
}

; CHECK-LABEL: shlzi
; CHECK        shl $m0, $m0, 3
define i32 @shlzi(i32 %a) {
  %1 = shl i32 %a, 3
  ret i32 %1
}

;===------------------------------------------------------------------------===;
; SHR
;===------------------------------------------------------------------------===;

; CHECK-LABEL: shr
; CHECK        shr $m0, $m0, $m1
define i32 @shr(i32 %a, i32 %b) {
  %1 = lshr i32 %a, %b
  ret i32 %1
}

; CHECK-LABEL: shrzi
; CHECK        shr $m0, $m0, 3
define i32 @shrzi(i32 %a) {
  %1 = lshr i32 %a, 3
  ret i32 %1
}

; CHECK-LABEL: shrs
; CHECK        shrs $m0, $m0, $m1
define i32 @shrs(i32 %a, i32 %b) {
  %1 = ashr i32 %a, %b
  ret i32 %1
}

; CHECK-LABEL: shrszi
; CHECK        shrs $m0, $m0, 3
define i32 @shrszi(i32 %a) {
  %1 = ashr i32 %a, 3
  ret i32 %1
}

;===------------------------------------------------------------------------===;
; SUB
;===------------------------------------------------------------------------===;

; CHECK-LABEL: sub
; CHECK:       sub $m0, $m0, $m1
define i32 @sub(i32 %a, i32 %b) {
  %1 = sub i32 %a, %b
  ret i32 %1
}

; CHECK-LABEL: subzi
; CHECK        sub $m0, 42, $m0
define i32 @subzi(i32 %a) {
  %1 = sub i32 %a, 42
  %2 = sub i32 0, %1
  ret i32 %2
}

; CHECK-LABEL: subsi
; CHECK        sub $m0, -42, $m0
define i32 @subsi(i32 %a) {
  %1 = sub i32 %a, -42
  %2 = sub i32 0, %1
  ret i32 %2
}

;===------------------------------------------------------------------------===;
; XOR, XNOR
;===------------------------------------------------------------------------===;

; CHECK-LABEL: xor
; CHECK        xor $m0, $m0, $m1
define i32 @xor(i32 %a, i32 %b) {
  %1 = xor i32 %a, %b
  ret i32 %1
}

; CHECK-LABEL: xnor
; CHECK        xnor $m0, $m0, $m1
define i32 @xnor(i32 %a, i32 %b) {
  %1 = xor i32 %a, %b
  %2 = xor i32 %1, -1
  ret i32 %2
}

; CHECK-LABEL: i32_not:
; CHECK:       # %bb.0:
; CHECK-NEXT:  xnor $m0, $m0, $m15
; CHECK-NEXT:  br $m10
define i32 @i32_not(i32 %a) {
  %1 = xor i32 %a, -1
  ret i32 %1
}

;===------------------------------------------------------------------------===;
; MIN
;===------------------------------------------------------------------------===;

; CHECK-LABEL: min_slt
; CHECK:       min $m0, $m0, $m1
define i32 @min_slt(i32 %x, i32 %y) {
  %cmp = icmp slt i32 %x, %y
  %cond = select i1 %cmp, i32 %x, i32 %y
  ret i32 %cond
}

; CHECK-LABEL: min_sgt
; CHECK:       min $m0, $m0, $m1
define i32 @min_sgt(i32 %x, i32 %y) {
  %cmp = icmp sgt i32 %x, %y
  %cond = select i1 %cmp, i32 %y, i32 %x
  ret i32 %cond
}

; CHECK-LABEL: min_slt_ze_1
; CHECK:       min $m0, $m0, 0
define i32 @min_slt_ze_1(i32 %x) {
  %cmp = icmp slt i32 %x, 0
  %cond = select i1 %cmp, i32 %x, i32 0
  ret i32 %cond
}

; CHECK-LABEL: min_slt_ze_2
; CHECK:       min $m0, $m0, 65535
define i32 @min_slt_ze_2(i32 %x) {
  %cmp = icmp slt i32 %x, 65535
  %cond = select i1 %cmp, i32 %x, i32 65535
  ret i32 %cond
}

; CHECK-LABEL: min_sgt_ze_1
; CHECK:       min $m0, $m0, 0
define i32 @min_sgt_ze_1(i32 %x) {
  %cmp = icmp sgt i32 %x, 0
  %cond = select i1 %cmp, i32 0, i32 %x
  ret i32 %cond
}

; CHECK-LABEL: min_sgt_ze_2
; CHECK:       min $m0, $m0, 65535
define i32 @min_sgt_ze_2(i32 %x) {
  %cmp = icmp sgt i32 %x, 65535
  %cond = select i1 %cmp, i32 65535, i32 %x
  ret i32 %cond
}

; CHECK-LABEL: min_slt_set_1
; CHECK:       setzi $m1, 65536
; CHECK-NEXT:  min $m0, $m0, $m1
define i32 @min_slt_set_1(i32 %x) {
  %cmp = icmp slt i32 %x, 65536
  %cond = select i1 %cmp, i32 %x, i32 65536
  ret i32 %cond
}

; CHECK-LABEL: min_slt_set_2
; CHECK:       setzi [[RX:\$m[0-9]+]], 1015807
; CHECK-NEXT:  or [[RX]], [[RX]], 4293918720
; CHECK-NEXT:  min $m0, $m0, [[RX]]
define i32 @min_slt_set_2(i32 %x) {
  %cmp = icmp slt i32 %x, -32769
  %cond = select i1 %cmp, i32 %x, i32 -32769
  ret i32 %cond
}

; CHECK-LABEL: min_sgt_set_1
; CHECK:       setzi $m1, 65536
; CHECK-NEXT:  min $m0, $m0, $m1
define i32 @min_sgt_set_1(i32 %x) {
  %cmp = icmp sgt i32 %x, 65536
  %cond = select i1 %cmp, i32 65536, i32 %x
  ret i32 %cond
}

; CHECK-LABEL: min_sgt_set_2
; CHECK:       setzi [[RX:\$m[0-9]+]], 1015807
; CHECK-NEXT:  or [[RX]], [[RX]], 4293918720
; CHECK-NEXT:  min $m0, $m0, [[RX]]
define i32 @min_sgt_set_2(i32 %x) {
  %cmp = icmp sgt i32 %x, -32769
  %cond = select i1 %cmp, i32 -32769, i32 %x
  ret i32 %cond
}

; CHECK-LABEL: min_slt_se_1
; CHECK:       min $m0, $m0, -1
define i32 @min_slt_se_1(i32 %x) {
  %cmp = icmp slt i32 %x, -1
  %cond = select i1 %cmp, i32 %x, i32 -1
  ret i32 %cond
}

; CHECK-LABEL: min_slt_se_2
; CHECK:       min $m0, $m0, -32768
define i32 @min_slt_se_2(i32 %x) {
  %cmp = icmp slt i32 %x, -32768
  %cond = select i1 %cmp, i32 %x, i32 -32768
  ret i32 %cond
}

; CHECK-LABEL: min_sgt_se_1
; CHECK:       min $m0, $m0, -1
define i32 @min_sgt_se_1(i32 %x) {
  %cmp = icmp sgt i32 %x, -1
  %cond = select i1 %cmp, i32 -1, i32 %x
  ret i32 %cond
}

; CHECK-LABEL: min_sgt_se_2
; CHECK:       min $m0, $m0, -32768
define i32 @min_sgt_se_2(i32 %x) {
  %cmp = icmp sgt i32 %x, -32768
  %cond = select i1 %cmp, i32 -32768, i32 %x
  ret i32 %cond
}

; CHECK-LABEL: min_v2i16_extract
; CHECK-NOT:   {{\$m[01][^[:digit:]]}}
; CHECK:       shl [[X_LO:\$m[0-9]+]], $m0, 16
; CHECK-NEXT:  shl [[Y_LO:\$m[0-9]+]], $m1, 16
; CHECK-NEXT:  shrs [[X_LO]], [[X_LO]], 16
; CHECK-NEXT:  shrs [[Y_LO]], [[Y_LO]], 16
; CHECK-NEXT:  shrs [[X_HI:\$m[0-9]+]], $m0, 16
; CHECK-NEXT:  shrs [[Y_HI:\$m[0-9]+]], $m1, 16
; CHECK-NEXT:  min [[MIN_LO:\$m[0-9]+]], [[X_LO]], [[Y_LO]]
; CHECK-NEXT:  min [[MIN_HI:\$m[0-9]+]], [[X_HI]], [[Y_HI]]
; CHECK-NEXT:  sort4x16lo $m0, [[MIN_LO]], [[MIN_HI]]
; CHECK-NEXT:  br $m10
define <2 x i16> @min_v2i16_extract(<2 x i16> %x, <2 x i16> %y) {
  %x_0 = extractelement <2 x i16> %x, i32 0
  %y_0 = extractelement <2 x i16> %y, i32 0
  %cmp_0 = icmp slt i16 %x_0, %y_0
  %cond_0 = select i1 %cmp_0, i16 %x_0, i16 %y_0
  %vec_0 = insertelement <2 x i16> undef, i16 %cond_0, i32 0

  %x_1 = extractelement <2 x i16> %x, i32 1
  %y_1 = extractelement <2 x i16> %y, i32 1
  %cmp_1 = icmp slt i16 %x_1, %y_1
  %cond_1 = select i1 %cmp_1, i16 %x_1, i16 %y_1
  %vec_1 = insertelement <2 x i16> %vec_0, i16 %cond_1, i32 1
  
  ret <2 x i16> %vec_1
}

; CHECK-LABEL: min_v2i16_select
; CHECK-NOT:   {{\$m[01][^[:digit:]]}}
; CHECK:       shl [[Y_LO:\$m[0-9]+]], $m1, 16
; CHECK-NEXT:  shl [[X_LO:\$m[0-9]+]], $m0, 16
; CHECK-NEXT:  shrs [[Y_HI:\$m[0-9]+]], $m1, 16
; CHECK-NEXT:  shrs [[X_HI:\$m[0-9]+]], $m0, 16
; CHECK-NEXT:  shrs [[Y_LO]], [[Y_LO]], 16
; CHECK-NEXT:  shrs [[X_LO]], [[X_LO]], 16
; CHECK-NEXT:  min [[MIN_HI:\$m[0-9]+]], [[X_HI]], [[Y_HI]]
; CHECK-NEXT:  min [[MIN_LO:\$m[0-9]+]], [[X_LO]], [[Y_LO]]
; CHECK-NEXT:  sort4x16lo $m0, [[MIN_LO]], [[MIN_HI]]
; CHECK-NEXT:  br $m10
define <2 x i16> @min_v2i16_select(<2 x i16> %x, <2 x i16> %y) {
  %cmp = icmp slt <2 x i16> %x, %y
  %cond = select <2 x i1> %cmp, <2 x i16> %x, <2 x i16> %y
  ret <2 x i16> %cond
}

; CHECK-LABEL: min_v4i16_extract
; CHECK-NOT:   {{\$m[0-3][^[:digit:]]}}
; CHECK:       shl [[X_3:\$m[0-9]+]], $m1, 16
; CHECK-NEXT:  shl [[Y_3:\$m[0-9]+]], $m3, 16
; CHECK-NEXT:  shl [[X_1:\$m[0-9]+]], $m0, 16
; CHECK-NEXT:  shl [[Y_1:\$m[0-9]+]], $m2, 16
; CHECK-NEXT:  shrs [[X_3]], [[X_3]], 16
; CHECK-NEXT:  shrs [[Y_3]], [[Y_3]], 16
; CHECK-NEXT:  shrs [[X_1]], [[X_1]], 16
; CHECK-NEXT:  shrs [[Y_1]], [[Y_1]], 16
; CHECK-NEXT:  min [[MIN_3:\$m[0-9]+]], [[X_3]], [[Y_3]]
; CHECK-NEXT:  shrs [[X_2:\$m[0-9]+]], $m1, 16
; CHECK-NEXT:  shrs [[X_0:\$m[0-9]+]], $m0, 16
; CHECK-NEXT:  shrs [[Y_2:\$m[0-9]+]], $m3, 16
; CHECK-NEXT:  shrs [[Y_0:\$m[0-9]+]], $m2, 16
; CHECK-NEXT:  min [[MIN_2:\$m[0-9]+]], [[X_2]], [[Y_2]]
; CHECK-NEXT:  min [[MIN_1:\$m[0-9]+]], [[X_1]], [[Y_1]]
; CHECK-NEXT:  min [[MIN_0:\$m[0-9]+]], [[X_0]], [[Y_0]]
; CHECK-NEXT:  sort4x16lo $m1, [[MIN_3]], [[MIN_2]]
; CHECK-NEXT:  sort4x16lo $m0, [[MIN_1]], [[MIN_0]]
; CHECK-NOT:   {{\$m[01][^[:digit:]]}}
; CHECK:       br $m10
define <4 x i16> @min_v4i16_extract(<4 x i16> %x, <4 x i16> %y) {
  %x_0 = extractelement <4 x i16> %x, i32 0
  %y_0 = extractelement <4 x i16> %y, i32 0
  %cmp_0 = icmp slt i16 %x_0, %y_0
  %cond_0 = select i1 %cmp_0, i16 %x_0, i16 %y_0
  %vec_0 = insertelement <4 x i16> undef, i16 %cond_0, i32 0

  %x_1 = extractelement <4 x i16> %x, i32 1
  %y_1 = extractelement <4 x i16> %y, i32 1
  %cmp_1 = icmp slt i16 %x_1, %y_1
  %cond_1 = select i1 %cmp_1, i16 %x_1, i16 %y_1
  %vec_1 = insertelement <4 x i16> %vec_0, i16 %cond_1, i32 1
  
  %x_2 = extractelement <4 x i16> %x, i32 2
  %y_2 = extractelement <4 x i16> %y, i32 2
  %cmp_2 = icmp slt i16 %x_2, %y_2
  %cond_2 = select i1 %cmp_2, i16 %x_2, i16 %y_2
  %vec_2 = insertelement <4 x i16> %vec_1, i16 %cond_2, i32 2

  %x_3 = extractelement <4 x i16> %x, i32 3
  %y_3 = extractelement <4 x i16> %y, i32 3
  %cmp_3 = icmp slt i16 %x_3, %y_3
  %cond_3 = select i1 %cmp_3, i16 %x_3, i16 %y_3
  %vec_3 = insertelement <4 x i16> %vec_2, i16 %cond_3, i32 3

  ret <4 x i16> %vec_3
}

; CHECK-LABEL: min_v4i16_select
; CHECK-NOT:   {{\$m[0-3][^[:digit:]]}}
; CHECK:       shl [[Y_3:\$m[0-9]+]], $m3, 16
; CHECK-NEXT:  shl [[X_3:\$m[0-9]+]], $m1, 16
; CHECK-NEXT:  shrs [[Y_2:\$m[0-9]+]], $m3, 16
; CHECK-NEXT:  shrs [[X_2:\$m[0-9]+]], $m1, 16
; CHECK-NEXT:  shrs [[Y_3]], [[Y_3]], 16
; CHECK-NEXT:  shrs [[X_3]], [[X_3]], 16
; CHECK-NEXT:  min [[MIN_2:\$m[0-9]+]], [[X_2]], [[Y_2]]
; CHECK-NEXT:  shl [[Y_1:\$m[0-9]+]], $m2, 16
; CHECK-NEXT:  min [[MIN_3:\$m[0-9]+]], [[X_3]], [[Y_3]]
; CHECK-NEXT:  shl [[X_1:\$m[0-9]+]], $m0, 16
; CHECK-NEXT:  shrs [[Y_0:\$m[0-9]+]], $m2, 16
; CHECK-NEXT:  shrs [[X_0:\$m[0-9]+]], $m0, 16
; CHECK-NEXT:  shrs [[Y_1]], [[Y_1]], 16
; CHECK-NEXT:  shrs [[X_1]], [[X_1]], 16
; CHECK-NEXT:  sort4x16lo $m1, [[MIN_3]], [[MIN_2]]
; CHECK-NEXT:  min [[MIN_0:\$m[0-9]+]], [[X_0]], [[Y_0]]
; CHECK-NEXT:  min [[MIN_1:\$m[0-9]+]], [[X_1]], [[Y_1]]
; CHECK-NEXT:  sort4x16lo $m0, [[MIN_1]], [[MIN_0]]
; CHECK-NOT:   {{\$m[01][^[:digit:]]}}
; CHECK:       br $m10
define <4 x i16> @min_v4i16_select(<4 x i16> %x, <4 x i16> %y) {
  %cmp = icmp slt <4 x i16> %x, %y
  %cond = select <4 x i1> %cmp, <4 x i16> %x, <4 x i16> %y
  ret <4 x i16> %cond
}

; CHECK-LABEL: min_v2i32_extract
; CHECK-DAG:   min $m0, $m0, $m2
; CHECK-DAG:   min $m1, $m1, $m3
; CHECK-NEXT:  br $m10
define <2 x i32> @min_v2i32_extract(<2 x i32> %x, <2 x i32> %y) {
  %x_0 = extractelement <2 x i32> %x, i32 0
  %y_0 = extractelement <2 x i32> %y, i32 0
  %cmp_0 = icmp slt i32 %x_0, %y_0
  %cond_0 = select i1 %cmp_0, i32 %x_0, i32 %y_0
  %vec_0 = insertelement <2 x i32> undef, i32 %cond_0, i32 0

  %x_1 = extractelement <2 x i32> %x, i32 1
  %y_1 = extractelement <2 x i32> %y, i32 1
  %cmp_1 = icmp slt i32 %x_1, %y_1
  %cond_1 = select i1 %cmp_1, i32 %x_1, i32 %y_1
  %vec_1 = insertelement <2 x i32> %vec_0, i32 %cond_1, i32 1
  
  ret <2 x i32> %vec_1
}

; CHECK-LABEL: min_v2i32_select
; CHECK-DAG:   min $m0, $m0, $m2
; CHECK-DAG:   min $m1, $m1, $m3
; CHECK-NEXT:  br $m10
define <2 x i32> @min_v2i32_select(<2 x i32> %x, <2 x i32> %y) {
  %cmp = icmp slt <2 x i32> %x, %y
  %cond = select <2 x i1> %cmp, <2 x i32> %x, <2 x i32> %y
  ret <2 x i32> %cond
}

;===------------------------------------------------------------------------===;
; MAX
;===------------------------------------------------------------------------===;

; CHECK-LABEL: max_slt
; CHECK:       max $m0, $m0, $m1
define i32 @max_slt(i32 %x, i32 %y) {
  %cmp = icmp slt i32 %x, %y
  %cond = select i1 %cmp, i32 %y, i32 %x
  ret i32 %cond
}

; CHECK-LABEL: max_sgt
; CHECK:       max $m0, $m0, $m1
define i32 @max_sgt(i32 %x, i32 %y) {
  %cmp = icmp sgt i32 %x, %y
  %cond = select i1 %cmp, i32 %x, i32 %y
  ret i32 %cond
}

; CHECK-LABEL: max_slt_ze_1
; CHECK:       max $m0, $m0, 0
define i32 @max_slt_ze_1(i32 %x) {
  %cmp = icmp slt i32 %x, 0
  %cond = select i1 %cmp, i32 0, i32 %x
  ret i32 %cond
}

; CHECK-LABEL: max_slt_ze_2
; CHECK:       max $m0, $m0, 65535
define i32 @max_slt_ze_2(i32 %x) {
  %cmp = icmp slt i32 %x, 65535
  %cond = select i1 %cmp, i32 65535, i32 %x
  ret i32 %cond
}

; CHECK-LABEL: max_sgt_ze_1
; CHECK:       max $m0, $m0, 0
define i32 @max_sgt_ze_1(i32 %x) {
  %cmp = icmp sgt i32 %x, 0
  %cond = select i1 %cmp, i32 %x, i32 0
  ret i32 %cond
}

; CHECK-LABEL: max_sgt_ze_2
; CHECK:       max $m0, $m0, 65535
define i32 @max_sgt_ze_2(i32 %x) {
  %cmp = icmp sgt i32 %x, 65535
  %cond = select i1 %cmp, i32 %x, i32 65535
  ret i32 %cond
}

; CHECK-LABEL: max_slt_set_1
; CHECK:       setzi $m1, 65536
; CHECK-NEXT:  max $m0, $m0, $m1
define i32 @max_slt_set_1(i32 %x) {
  %cmp = icmp slt i32 %x, 65536
  %cond = select i1 %cmp, i32 65536, i32 %x
  ret i32 %cond
}

; CHECK-LABEL: max_slt_set_2
; CHECK:       setzi [[RX:\$m[0-9]+]], 1015807
; CHECK-NEXT:  or [[RX]], [[RX]], {{(4293918720|-1048576)}}
; CHECK-NEXT:  max $m0, $m0, [[RX]]
define i32 @max_slt_set_2(i32 %x) {
  %cmp = icmp slt i32 %x, -32769
  %cond = select i1 %cmp, i32 -32769, i32 %x
  ret i32 %cond
}

; CHECK-LABEL: max_sgt_set_1
; CHECK:       setzi $m1, 65536
; CHECK-NEXT:  max $m0, $m0, $m1
define i32 @max_sgt_set_1(i32 %x) {
  %cmp = icmp sgt i32 %x, 65536
  %cond = select i1 %cmp, i32 %x, i32 65536
  ret i32 %cond
}

; CHECK-LABEL: max_sgt_set_2
; CHECK:       setzi [[RX:\$m[0-9]+]], 1015807
; CHECK-NEXT:  or [[RX]], [[RX]], {{(4293918720|-1048576)}}
; CHECK-NEXT:  max $m0, $m0, [[RX]]
define i32 @max_sgt_set_2(i32 %x) {
  %cmp = icmp sgt i32 %x, -32769
  %cond = select i1 %cmp, i32 %x, i32 -32769
  ret i32 %cond
}

; CHECK-LABEL: max_slt_se_1
; CHECK:       max $m0, $m0, -1
define i32 @max_slt_se_1(i32 %x) {
  %cmp = icmp slt i32 %x, -1
  %cond = select i1 %cmp, i32 -1, i32 %x
  ret i32 %cond
}

; CHECK-LABEL: max_slt_se_2
; CHECK:       max $m0, $m0, -32768
define i32 @max_slt_se_2(i32 %x) {
  %cmp = icmp slt i32 %x, -32768
  %cond = select i1 %cmp, i32 -32768, i32 %x
  ret i32 %cond
}

; CHECK-LABEL: max_sgt_se_1
; CHECK:       max $m0, $m0, -1
define i32 @max_sgt_se_1(i32 %x) {
  %cmp = icmp sgt i32 %x, -1
  %cond = select i1 %cmp, i32 %x, i32 -1
  ret i32 %cond
}

; CHECK-LABEL: max_sgt_se_2
; CHECK:       max $m0, $m0, -32768
define i32 @max_sgt_se_2(i32 %x) {
  %cmp = icmp sgt i32 %x, -32768
  %cond = select i1 %cmp, i32 %x, i32 -32768
  ret i32 %cond
}

; CHECK-LABEL: max_v2i16_extract
; CHECK-NOT:   {{\$m[01][^[:digit:]]}}
; CHECK:       shl [[X_LO:\$m[0-9]+]], $m0, 16
; CHECK-NEXT:  shl [[Y_LO:\$m[0-9]+]], $m1, 16
; CHECK-NEXT:  shrs [[X_LO]], [[X_LO]], 16
; CHECK-NEXT:  shrs [[Y_LO]], [[Y_LO]], 16
; CHECK-NEXT:  shrs [[X_HI:\$m[0-9]+]], $m0, 16
; CHECK-NEXT:  shrs [[Y_HI:\$m[0-9]+]], $m1, 16
; CHECK-NEXT:  max [[MIN_LO:\$m[0-9]+]], [[X_LO]], [[Y_LO]]
; CHECK-NEXT:  max [[MIN_HI:\$m[0-9]+]], [[X_HI]], [[Y_HI]]
; CHECK-NEXT:  sort4x16lo $m0, [[MIN_LO]], [[MIN_HI]]
; CHECK-NEXT:  br $m10
define <2 x i16> @max_v2i16_extract(<2 x i16> %x, <2 x i16> %y) {
  %x_0 = extractelement <2 x i16> %x, i32 0
  %y_0 = extractelement <2 x i16> %y, i32 0
  %cmp_0 = icmp sgt i16 %x_0, %y_0
  %cond_0 = select i1 %cmp_0, i16 %x_0, i16 %y_0
  %vec_0 = insertelement <2 x i16> undef, i16 %cond_0, i32 0

  %x_1 = extractelement <2 x i16> %x, i32 1
  %y_1 = extractelement <2 x i16> %y, i32 1
  %cmp_1 = icmp sgt i16 %x_1, %y_1
  %cond_1 = select i1 %cmp_1, i16 %x_1, i16 %y_1
  %vec_1 = insertelement <2 x i16> %vec_0, i16 %cond_1, i32 1
  
  ret <2 x i16> %vec_1
}

; CHECK-LABEL: max_v2i16_select
; CHECK-NOT:   {{\$m[01][^[:digit:]]}}
; CHECK:       shl [[Y_LO:\$m[0-9]+]], $m1, 16
; CHECK-NEXT:  shl [[X_LO:\$m[0-9]+]], $m0, 16
; CHECK-NEXT:  shrs [[Y_HI:\$m[0-9]+]], $m1, 16
; CHECK-NEXT:  shrs [[X_HI:\$m[0-9]+]], $m0, 16
; CHECK-NEXT:  shrs [[Y_LO]], [[Y_LO]], 16
; CHECK-NEXT:  shrs [[X_LO]], [[X_LO]], 16
; CHECK-NEXT:  max [[MIN_HI:\$m[0-9]+]], [[X_HI]], [[Y_HI]]
; CHECK-NEXT:  max [[MIN_LO:\$m[0-9]+]], [[X_LO]], [[Y_LO]]
; CHECK-NEXT:  sort4x16lo $m0, [[MIN_LO]], [[MIN_HI]]
; CHECK-NEXT:  br $m10
define <2 x i16> @max_v2i16_select(<2 x i16> %x, <2 x i16> %y) {
  %cmp = icmp sgt <2 x i16> %x, %y
  %cond = select <2 x i1> %cmp, <2 x i16> %x, <2 x i16> %y
  ret <2 x i16> %cond
}

; CHECK-LABEL: max_v4i16_extract
; CHECK-NOT:   {{\$m[0-3][^[:digit:]]}}
; CHECK:       shl [[X_3:\$m[0-9]+]], $m1, 16
; CHECK-NEXT:  shl [[Y_3:\$m[0-9]+]], $m3, 16
; CHECK-NEXT:  shl [[X_1:\$m[0-9]+]], $m0, 16
; CHECK-NEXT:  shl [[Y_1:\$m[0-9]+]], $m2, 16
; CHECK-NEXT:  shrs [[X_3]], [[X_3]], 16
; CHECK-NEXT:  shrs [[Y_3]], [[Y_3]], 16
; CHECK-NEXT:  shrs [[X_1]], [[X_1]], 16
; CHECK-NEXT:  shrs [[Y_1]], [[Y_1]], 16
; CHECK-NEXT:  max [[MIN_3:\$m[0-9]+]], [[X_3]], [[Y_3]]
; CHECK-NEXT:  shrs [[X_2:\$m[0-9]+]], $m1, 16
; CHECK-NEXT:  shrs [[X_0:\$m[0-9]+]], $m0, 16
; CHECK-NEXT:  shrs [[Y_2:\$m[0-9]+]], $m3, 16
; CHECK-NEXT:  shrs [[Y_0:\$m[0-9]+]], $m2, 16
; CHECK-NEXT:  max [[MIN_2:\$m[0-9]+]], [[X_2]], [[Y_2]]
; CHECK-NEXT:  max [[MIN_1:\$m[0-9]+]], [[X_1]], [[Y_1]]
; CHECK-NEXT:  max [[MIN_0:\$m[0-9]+]], [[X_0]], [[Y_0]]
; CHECK-NEXT:  sort4x16lo $m1, [[MIN_3]], [[MIN_2]]
; CHECK-NEXT:  sort4x16lo $m0, [[MIN_1]], [[MIN_0]]
; CHECK-NOT:   {{\$m[01][^[:digit:]]}}
; CHECK:       br $m10
define <4 x i16> @max_v4i16_extract(<4 x i16> %x, <4 x i16> %y) {
  %x_0 = extractelement <4 x i16> %x, i32 0
  %y_0 = extractelement <4 x i16> %y, i32 0
  %cmp_0 = icmp sgt i16 %x_0, %y_0
  %cond_0 = select i1 %cmp_0, i16 %x_0, i16 %y_0
  %vec_0 = insertelement <4 x i16> undef, i16 %cond_0, i32 0

  %x_1 = extractelement <4 x i16> %x, i32 1
  %y_1 = extractelement <4 x i16> %y, i32 1
  %cmp_1 = icmp sgt i16 %x_1, %y_1
  %cond_1 = select i1 %cmp_1, i16 %x_1, i16 %y_1
  %vec_1 = insertelement <4 x i16> %vec_0, i16 %cond_1, i32 1
  
  %x_2 = extractelement <4 x i16> %x, i32 2
  %y_2 = extractelement <4 x i16> %y, i32 2
  %cmp_2 = icmp sgt i16 %x_2, %y_2
  %cond_2 = select i1 %cmp_2, i16 %x_2, i16 %y_2
  %vec_2 = insertelement <4 x i16> %vec_1, i16 %cond_2, i32 2

  %x_3 = extractelement <4 x i16> %x, i32 3
  %y_3 = extractelement <4 x i16> %y, i32 3
  %cmp_3 = icmp sgt i16 %x_3, %y_3
  %cond_3 = select i1 %cmp_3, i16 %x_3, i16 %y_3
  %vec_3 = insertelement <4 x i16> %vec_2, i16 %cond_3, i32 3

  ret <4 x i16> %vec_3
}

; CHECK-LABEL: max_v4i16_select
; CHECK-NOT:   {{\$m[0-3][^[:digit:]]}}
; CHECK:       shl [[Y_3:\$m[0-9]+]], $m3, 16
; CHECK-NEXT:  shl [[X_3:\$m[0-9]+]], $m1, 16
; CHECK-NEXT:  shrs [[Y_2:\$m[0-9]+]], $m3, 16
; CHECK-NEXT:  shrs [[X_2:\$m[0-9]+]], $m1, 16
; CHECK-NEXT:  shrs [[Y_3]], [[Y_3]], 16
; CHECK-NEXT:  shrs [[X_3]], [[X_3]], 16
; CHECK-NEXT:  max [[MIN_2:\$m[0-9]+]], [[X_2]], [[Y_2]]
; CHECK-NEXT:  shl [[Y_1:\$m[0-9]+]], $m2, 16
; CHECK-NEXT:  max [[MIN_3:\$m[0-9]+]], [[X_3]], [[Y_3]]
; CHECK-NEXT:  shl [[X_1:\$m[0-9]+]], $m0, 16
; CHECK-NEXT:  shrs [[Y_0:\$m[0-9]+]], $m2, 16
; CHECK-NEXT:  shrs [[X_0:\$m[0-9]+]], $m0, 16
; CHECK-NEXT:  shrs [[Y_1]], [[Y_1]], 16
; CHECK-NEXT:  shrs [[X_1]], [[X_1]], 16
; CHECK-NEXT:  sort4x16lo $m1, [[MIN_3]], [[MIN_2]]
; CHECK-NEXT:  max [[MIN_0:\$m[0-9]+]], [[X_0]], [[Y_0]]
; CHECK-NEXT:  max [[MIN_1:\$m[0-9]+]], [[X_1]], [[Y_1]]
; CHECK-NEXT:  sort4x16lo $m0, [[MIN_1]], [[MIN_0]]
; CHECK-NOT:   {{\$m[01][^[:digit:]]}}
; CHECK:       br $m10
define <4 x i16> @max_v4i16_select(<4 x i16> %x, <4 x i16> %y) {
  %cmp = icmp sgt <4 x i16> %x, %y
  %cond = select <4 x i1> %cmp, <4 x i16> %x, <4 x i16> %y
  ret <4 x i16> %cond
}

; CHECK-LABEL: max_v2i32_extract
; CHECK-DAG:   max $m0, $m0, $m2
; CHECK-DAG:   max $m1, $m1, $m3
; CHECK-NEXT:  br $m10
define <2 x i32> @max_v2i32_extract(<2 x i32> %x, <2 x i32> %y) {
  %x_0 = extractelement <2 x i32> %x, i32 0
  %y_0 = extractelement <2 x i32> %y, i32 0
  %cmp_0 = icmp sgt i32 %x_0, %y_0
  %cond_0 = select i1 %cmp_0, i32 %x_0, i32 %y_0
  %vec_0 = insertelement <2 x i32> undef, i32 %cond_0, i32 0

  %x_1 = extractelement <2 x i32> %x, i32 1
  %y_1 = extractelement <2 x i32> %y, i32 1
  %cmp_1 = icmp sgt i32 %x_1, %y_1
  %cond_1 = select i1 %cmp_1, i32 %x_1, i32 %y_1
  %vec_1 = insertelement <2 x i32> %vec_0, i32 %cond_1, i32 1
  
  ret <2 x i32> %vec_1
}

; CHECK-LABEL: max_v2i32_select
; CHECK-DAG:   max $m0, $m0, $m2
; CHECK-DAG:   max $m1, $m1, $m3
; CHECK-NEXT:  br $m10
define <2 x i32> @max_v2i32_select(<2 x i32> %x, <2 x i32> %y) {
  %cmp = icmp sgt <2 x i32> %x, %y
  %cond = select <2 x i1> %cmp, <2 x i32> %x, <2 x i32> %y
  ret <2 x i32> %cond
}
