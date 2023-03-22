; RUN: llc < %s -march=colossus -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -march=colossus -mattr=+ipu2 | FileCheck %s

; Test basic load register and scaled immediate versions.
; Omit tests for all but ld32 for non-scaled immediate and arbitrary offset.

;===-----------------------------------------------------------------------===;
; LD32.
;===-----------------------------------------------------------------------===;

; Scaled immediate.
define i32 @load32_imm(i32* %p) {
; CHECK-LABEL: load32_imm:
; CHECK:       ld32 $m0, $m0, $m15, 11
	%1 = getelementptr i32, i32* %p, i32 11
	%2 = load i32, i32* %1, align 4
	ret i32 %2
}

; Nonscaled immediate.
define i32 @load32_imm_nonscaled(i32 %p) {
; CHECK-LABEL: load32_imm_nonscaled:
; CHECK:       ld32 $m0, $m0, $m15, 1
	%1 = add i32 %p, 4
  %2 = inttoptr i32 %1 to i32*
  %3 = load i32, i32* %2, align 4
	ret i32 %3
}

; Nonscaled constant out of range.
define i32 @load32_const_nonscaled(i32 %p) {
; CHECK-LABEL: load32_const_nonscaled:
; CHECK:       setzi $m[[c:[0-9]+]], 131069
; CHECK:       ld32 $m0, $m0, $m[[c]], 0
	%1 = add i32 %p, 131069
  %2 = inttoptr i32 %1 to i32*
  %3 = load i32, i32* %2, align 4
	ret i32 %3
}

; Arbitrary pointer.
define i32 @load32_ptr(i32* %p) {
; CHECK-LABEL: load32_ptr:
; CHECK:       ld32 $m0, $m0, $m15, 0
	%1 = load i32, i32* %p, align 4
	ret i32 %1
}

; Global symbol plus offset.
@g1 = dso_local global i32 0
define i32 @load32_global() {
; CHECK-LABEL: load32_global:
; CHECK:       setzi $m[[addr:[0-9]+]], g1+16
; CHECK-NEXT:  ld32 $m0, $m[[addr]], $m15, 0
	%1 = getelementptr i32, i32* @g1, i32 4
  %2 = load i32, i32* %1, align 4
  ret i32 %2
}

;===-----------------------------------------------------------------------===;
; LD16 sign extended.
;===-----------------------------------------------------------------------===;

define i32 @load_s16(i16* %p, i32 %offset) {
; CHECK-LABEL: load_s16:
; CHECK:       lds16 $m0, $m0, $m15, $m1
	%1 = getelementptr i16, i16* %p, i32 %offset
	%2 = load i16, i16* %1, align 2
  %3 = sext i16 %2 to i32
	ret i32 %3
}

define i32 @load_s16imm(i16* %p) {
; CHECK-LABEL: load_s16imm:
; CHECK:       lds16 $m0, $m0, $m15, 11
	%1 = getelementptr i16, i16* %p, i32 11
	%2 = load i16, i16* %1, align 2
	%3 = sext i16 %2 to i32
	ret i32 %3
}

define i32 @load_s16imm_fi() {
; CHECK-LABEL: load_s16imm_fi:
; CHECK:       lds16 $m0, $m11, $m15, 11
  %1 = alloca i16, i16 16
	%2 = getelementptr i16, i16* %1, i32 11
	%3 = load i16, i16* %2, align 2
	%4 = sext i16 %3 to i32
	ret i32 %4
}

;===-----------------------------------------------------------------------===;
; LD16 zero extended.
;===-----------------------------------------------------------------------===;

define i32 @load_z16(i16* %p, i32 %offset) {
; CHECK-LABEL: load_z16:
; CHECK:       ldz16 $m0, $m0, $m15, $m1
	%1 = getelementptr i16, i16* %p, i32 %offset
	%2 = load i16, i16* %1, align 2
  %3 = zext i16 %2 to i32
	ret i32 %3
}

define i32 @load_z16imm(i16* %p) {
; CHECK-LABEL: load_z16imm:
; CHECK:       ldz16 $m0, $m0, $m15, 11
	%1 = getelementptr i16, i16* %p, i32 11
	%2 = load i16, i16* %1, align 2
	%3 = zext i16 %2 to i32
	ret i32 %3
}

define i32 @load_z16imm_fi() {
; CHECK-LABEL: load_z16imm_fi:
; CHECK:       ldz16 $m0, $m11, $m15, 11
  %1 = alloca i16, i16 16
	%2 = getelementptr i16, i16* %1, i32 11
	%3 = load i16, i16* %2, align 2
	%4 = zext i16 %3 to i32
	ret i32 %4
}

;===-----------------------------------------------------------------------===;
; LD8 sign extended.
;===-----------------------------------------------------------------------===;

define i32 @load_s8(i8* %p, i32 %offset) {
; CHECK-LABEL: load_s8:
; CHECK:       lds8 $m0, $m0, $m15, $m1
	%1 = getelementptr i8, i8* %p, i32 %offset
	%2 = load i8, i8* %1, align 1
  %3 = sext i8 %2 to i32
	ret i32 %3
}

define i32 @load_s8imm(i8* %p) {
; CHECK-LABEL: load_s8imm:
; CHECK:       lds8 $m0, $m0, $m15, 11
	%1 = getelementptr i8, i8* %p, i32 11
	%2 = load i8, i8* %1, align 1
	%3 = sext i8 %2 to i32
	ret i32 %3
}

define i32 @load_s8imm_fi() {
; CHECK-LABEL: load_s8imm_fi:
; CHECK:       lds8 $m0, $m11, $m15, 11
  %1 = alloca i8, i8 16
	%2 = getelementptr i8, i8* %1, i32 11
	%3 = load i8, i8* %2, align 2
	%4 = sext i8 %3 to i32
	ret i32 %4
}

;===-----------------------------------------------------------------------===;
; LD8 zero extended.
;===-----------------------------------------------------------------------===;

define i32 @load_z8(i8* %p, i32 %offset) {
; CHECK-LABEL: load_z8:
; CHECK:       ldz8 $m0, $m0, $m15, $m1
	%1 = getelementptr i8, i8* %p, i32 %offset
	%2 = load i8, i8* %1, align 2
  %3 = zext i8 %2 to i32
	ret i32 %3
}

define i32 @load_z8imm(i8* %p) {
; CHECK-LABEL: load_z8imm:
; CHECK:       ldz8 $m0, $m0, $m15, 11
	%1 = getelementptr i8, i8* %p, i32 11
	%2 = load i8, i8* %1, align 2
	%3 = zext i8 %2 to i32
	ret i32 %3
}

define i32 @load_z8imm_fi() {
; CHECK-LABEL: load_z8imm_fi:
; CHECK:       ldz8 $m0, $m11, $m15, 11
  %1 = alloca i8, i8 16
	%2 = getelementptr i8, i8* %1, i32 11
	%3 = load i8, i8* %2, align 2
	%4 = zext i8 %3 to i32
	ret i32 %4
}
