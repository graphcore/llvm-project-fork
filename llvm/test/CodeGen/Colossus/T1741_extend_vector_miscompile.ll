; RUN: llc < %s -mtriple=colossus -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -mtriple=colossus -mattr=+ipu2 | FileCheck %s

; These cases caused internal asserts during the lowering of any_extend_vector_inreg
; Both were found by fuzz testing, the common theme is hitting a DAGCombine which
; translates the vector shuffle into an any_extend_vector_inreg

; CHECK-LABEL: autogenA
define void @autogenA() {
BB:
  br label %CF842

CF842:                                            ; preds = %CF842, %BB
  br i1 undef, label %CF842, label %CF904

CF904:                                            ; preds = %CF842
  %L100 = load <8 x i1>, <8 x i1>* undef
    br label %CF848

CF848:                                            ; preds = %CF848, %CF904
  %Sl207 = select i1 undef, <8 x i1> undef, <8 x i1> %L100
    br label %CF848
}

; CHECK-LABEL: autogenB
define void @autogenB() {
BB:
  %I186 = insertelement <16 x i16> undef, i16 undef, i32 7
    br label %CF957

CF957:                                            ; preds = %CF957, %BB
  %E282 = extractelement <16 x i1> zeroinitializer, i32 0
    br i1 %E282, label %CF957, label %CF963

CF963:                                            ; preds = %CF957
  %Shuff335 = shufflevector <16 x i16> %I186, <16 x i16> %I186, <16 x i32> <i32 25, i32 undef, i32 undef, i32 undef, i32 undef, i32 3, i32 5, i32 7, i32 9, i32 11, i32 13, i32 undef, i32 undef, i32 undef, i32 21, i32 undef>
    br label %CF849

CF849:                                            ; preds = %CF849, %CF963
  %Shuff379 = shufflevector <16 x i16> %Shuff335, <16 x i16> %I186, <16 x i32> <i32 undef, i32 0, i32 2, i32 4, i32 6, i32 8, i32 10, i32 12, i32 14, i32 undef, i32 18, i32 20, i32 22, i32 24, i32 26, i32 undef>
    br label %CF849
 }
