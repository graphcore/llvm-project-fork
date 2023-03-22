; RUN: llc < %s -march=colossus -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -march=colossus -mattr=+ipu2 | FileCheck %s

;///////////////////////////////////////////////////////////////////////////////
;// Align 1
;///////////////////////////////////////////////////////////////////////////////

; CHECK-LABEL: ld_align1:
; CHECK:       # %bb
; CHECK-NEXT:  ldz8 $m[[LD1:[0-9]+]], $m0, $m15, {{[0-3]}}
; CHECK-NEXT:  ldz8 $m[[LD2:[0-9]+]], $m0, $m15, {{[0-3]}}
; CHECK-NEXT:  sort4x16lo $m[[SORT1:[0-9]+]], $m[[LD2]], $m[[LD1]]
; CHECK-NEXT:  ldz8 $m[[LD3:[0-9]+]], $m0, $m15, {{[0-3]}}
; CHECK-NEXT:  ldz8 $m[[LD4:[0-9]+]], $m0, $m15, {{[0-3]}}
; CHECK-NEXT:  sort4x16lo $m[[SORT2:[0-9]+]], $m[[LD4]], $m[[LD3]]
; CHECK-NEXT:  br $m10
define <4 x i8> @ld_align1(<4 x i8>* readonly %src) {
	%1 = load <4 x i8>, <4 x i8>* %src, align 1
	ret <4 x i8> %1
}

; CHECK-LABEL: ld_sext_align1:
; CHECK:       # %bb
; CHECK-NEXT:  lds8 $m[[LD1:[0-9]+]], $m0, $m15, {{[0-3]}}
; CHECK-NEXT:  lds8 $m[[LD2:[0-9]+]], $m0, $m15, {{[0-3]}}
; CHECK-NEXT:  sort4x16lo $m[[SORT1:[0-9]+]], $m[[LD2]], $m[[LD1]]
; CHECK-NEXT:  lds8 $m[[LD3:[0-9]+]], $m0, $m15, {{[0-3]}}
; CHECK-NEXT:  lds8 $m[[LD4:[0-9]+]], $m0, $m15, {{[0-3]}}
; CHECK-NEXT:  sort4x16lo $m[[SORT2:[0-9]+]], $m[[LD4]], $m[[LD3]]
; CHECK-NEXT:  br $m10
define <4 x i16> @ld_sext_align1(<4 x i8>* readonly %src) {
	%1 = load <4 x i8>, <4 x i8>* %src, align 1
	%2 = sext <4 x i8> %1 to <4 x i16>
	ret <4 x i16> %2
}

; CHECK-LABEL: ld_zext_align1:
; CHECK:       # %bb
; CHECK-NEXT:  ldz8 $m[[LD1:[0-9]+]], $m0, $m15, {{[0-3]}}
; CHECK-NEXT:  ldz8 $m[[LD2:[0-9]+]], $m0, $m15, {{[0-3]}}
; CHECK-NEXT:  sort4x16lo $m[[SORT1:[0-9]+]], $m[[LD2]], $m[[LD1]]
; CHECK-NEXT:  ldz8 $m[[LD3:[0-9]+]], $m0, $m15, {{[0-3]}}
; CHECK-NEXT:  ldz8 $m[[LD4:[0-9]+]], $m0, $m15, {{[0-3]}}
; CHECK-NEXT:  sort4x16lo $m[[SORT2:[0-9]+]], $m[[LD4]], $m[[LD3]]
; CHECK-NEXT:  br $m10
define <4 x i16> @ld_zext_align1(<4 x i8>* readonly %src) {
	%1 = load <4 x i8>, <4 x i8>* %src, align 1
	%2 = zext <4 x i8> %1 to <4 x i16>
	ret <4 x i16> %2
}

;///////////////////////////////////////////////////////////////////////////////
;// Align 2
;///////////////////////////////////////////////////////////////////////////////

; CHECK-LABEL: ld_align2:
; CHECK:       # %bb
; CHECK-NEXT:  ldz16 $m[[LD1:[0-9]+]], $m0, $m15, {{[0-3]}}
; CHECK-NEXT:  ldz16 $m[[LD2:[0-9]+]], $m0, $m15, {{[0-3]}}
; CHECK-NEXT:  sort4x16lo $m[[SORT:[0-9]+]], $m[[LD2]], $m[[LD1]]
; CHECK-NEXT:  shuf8x8hi $m[[SHUFHI:[0-9]+]], $m[[SORT]], $m15
; CHECK-NEXT:  shuf8x8lo $m[[SHUFLO:[0-9]+]], $m[[SORT]], $m15
; CHECK-NEXT:  br $m10
define <4 x i8> @ld_align2(<4 x i8>* readonly %src) {
	%1 = load <4 x i8>, <4 x i8>* %src, align 2
	ret <4 x i8> %1
}

; CHECK-LABEL: ld_sext_align2:
; CHECK:       # %bb
; CHECK-NEXT:  lds8 $m[[LD1:[0-9]+]], $m0, $m15, {{[0-3]}}
; CHECK-NEXT:  lds8 $m[[LD2:[0-9]+]], $m0, $m15, {{[0-3]}}
; CHECK-NEXT:  sort4x16lo $m[[SORT1:[0-9]+]], $m[[LD2]], $m[[LD1]]
; CHECK-NEXT:  lds8 $m[[LD3:[0-9]+]], $m0, $m15, {{[0-3]}}
; CHECK-NEXT:  lds8 $m[[LD4:[0-9]+]], $m0, $m15, {{[0-3]}}
; CHECK-NEXT:  sort4x16lo $m[[SORT2:[0-9]+]], $m[[LD4]], $m[[LD3]]
; CHECK-NEXT:  br $m10
define <4 x i16> @ld_sext_align2(<4 x i8>* readonly %src) {
	%1 = load <4 x i8>, <4 x i8>* %src, align 2
	%2 = sext <4 x i8> %1 to <4 x i16>
	ret <4 x i16> %2
}

; CHECK-LABEL: ld_zext_align2:
; CHECK:       # %bb
; CHECK-NEXT:  ldz16 $m[[LD1:[0-9]+]], $m0, $m15, {{[0-3]}}
; CHECK-NEXT:  ldz16 $m[[LD2:[0-9]+]], $m0, $m15, {{[0-3]}}
; CHECK-NEXT:  sort4x16lo $m[[SORT:[0-9]+]], $m[[LD2]], $m[[LD1]]
; CHECK-NEXT:  shuf8x8hi $m[[SHUFHI:[0-9]+]], $m[[SORT]], $m15
; CHECK-NEXT:  shuf8x8lo $m[[SHUFLO:[0-9]+]], $m[[SORT]], $m15
; CHECK-NEXT:  br $m10
define <4 x i16> @ld_zext_align2(<4 x i8>* readonly %src) {
	%1 = load <4 x i8>, <4 x i8>* %src, align 2
	%2 = zext <4 x i8> %1 to <4 x i16>
	ret <4 x i16> %2
}

;///////////////////////////////////////////////////////////////////////////////
;// Align 4
;///////////////////////////////////////////////////////////////////////////////

; CHECK-LABEL: ld_align4:
; CHECK:       # %bb
; CHECK-NEXT:  ld32 $m[[LOAD:[0-9]+]], $m{{[0-9]+}}, $m15, 0
; CHECK-NEXT:  shuf8x8hi $m[[SHUFHI:[0-9]+]], $m[[LOAD]], $m15
; CHECK-NEXT:  shuf8x8lo $m[[SHUFLO:[0-9]+]], $m[[LOAD]], $m15
; CHECK-NEXT:  br $m10
define <4 x i8> @ld_align4(<4 x i8>* readonly %src) {
	%1 = load <4 x i8>, <4 x i8>* %src, align 4
	ret <4 x i8> %1
}

; CHECK-LABEL: ld_sext_align4:
; CHECK:       # %bb
; CHECK-NEXT:  lds8 $m[[LD1:[0-9]+]], $m0, $m15, {{[0-3]}}
; CHECK-NEXT:  lds8 $m[[LD2:[0-9]+]], $m0, $m15, {{[0-3]}}
; CHECK-NEXT:  sort4x16lo $m[[SORT1:[0-9]+]], $m[[LD2]], $m[[LD1]]
; CHECK-NEXT:  lds8 $m[[LD3:[0-9]+]], $m0, $m15, {{[0-3]}}
; CHECK-NEXT:  lds8 $m[[LD4:[0-9]+]], $m0, $m15, {{[0-3]}}
; CHECK-NEXT:  sort4x16lo $m[[SORT2:[0-9]+]], $m[[LD4]], $m[[LD3]]
; CHECK-NEXT:  br $m10
define <4 x i16> @ld_sext_align4(<4 x i8>* readonly %src) {
	%1 = load <4 x i8>, <4 x i8>* %src, align 4
	%2 = sext <4 x i8> %1 to <4 x i16>
	ret <4 x i16> %2
}

; CHECK-LABEL: ld_zext_align4:
; CHECK:       # %bb
; CHECK-NEXT:  ld32 $m[[LOAD:[0-9]+]], $m{{[0-9]+}}, $m15, 0
; CHECK-NEXT:  shuf8x8hi $m[[SHUFHI:[0-9]+]], $m[[LOAD]], $m15
; CHECK-NEXT:  shuf8x8lo $m[[SHUFLO:[0-9]+]], $m[[LOAD]], $m15
; CHECK-NEXT:  br $m10
define <4 x i16> @ld_zext_align4(<4 x i8>* readonly %src) {
	%1 = load <4 x i8>, <4 x i8>* %src, align 4
	%2 = zext <4 x i8> %1 to <4 x i16>
	ret <4 x i16> %2
}
