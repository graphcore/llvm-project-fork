; RUN: llc < %s -march=colossus -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -march=colossus -mattr=+ipu2 | FileCheck %s

; Single use of load with bitcast

; CHECK-LABEL: load_f32_from_i32_ptr:
; CHECK:       # %bb
; CHECK-NEXT:  ld32 $a0, $m0, $m15, 0
; CHECK:       br $m10
define float @load_f32_from_i32_ptr(i32* %addr)
{
  %val = load i32, i32* %addr
  %res = bitcast i32 %val to float
  ret float %res
}

; CHECK-LABEL: load_f32_from_i32_val:
; CHECK:       # %bb
; CHECK-NEXT:  ld32 $a0, $m0, $m15, 0
; CHECK:       br $m10
define float @load_f32_from_i32_val(i32* %addr)
{
  %faddr = bitcast i32* %addr to float*
  %res = load float, float* %faddr
  ret float %res
}

; CHECK-LABEL: load_i32_from_f32_ptr:
; CHECK:       # %bb
; CHECK-NEXT:  ld32 $m0, $m0, $m15, 0
; CHECK:       br $m10
define i32 @load_i32_from_f32_ptr(float* %addr)
{
  %val = load float, float* %addr
  %res = bitcast float %val to i32
  ret i32 %res
}

; CHECK-LABEL: load_i32_from_f32_val:
; CHECK:       # %bb
; CHECK-NEXT:  ld32 $m0, $m0, $m15, 0
; CHECK:       br $m10
define i32 @load_i32_from_f32_val(float* %addr)
{
  %iaddr = bitcast float* %addr to i32*
  %res = load i32, i32* %iaddr
  ret i32 %res
}

; CHECK-LABEL: load_v2f32_from_v2i32_ptr:
; CHECK:       # %bb
; CHECK-NEXT:  ld64 $a0:1, $m0, $m15, 0
; CHECK:       br $m10
define <2 x float> @load_v2f32_from_v2i32_ptr(<2 x i32>* %addr)
{
  %val = load <2 x i32>, <2 x i32>* %addr
  %res = bitcast <2 x i32> %val to <2 x float>
  ret <2 x float> %res
}

; CHECK-LABEL: load_v2f32_from_v2i32_val:
; CHECK:       # %bb
; CHECK-NEXT:  ld64 $a0:1, $m0, $m15, 0
; CHECK:       br $m10
define <2 x float> @load_v2f32_from_v2i32_val(<2 x i32>* %addr)
{
  %faddr = bitcast <2 x i32>* %addr to <2 x float>*
  %res = load <2 x float>, <2 x float>* %faddr
  ret <2 x float> %res
}

; CHECK-LABEL: load_v2i32_from_v2f32_ptr:
; CHECK:       # %bb
; CHECK-DAG:   ld32 [[LO:\$m[0-9]+]], $m0, $m15, 0
; CHECK-DAG:   ld32 [[HI:\$m[0-9]+]], $m0, $m15, 1
; CHECK-NOT:   break-dag-group
; CHECK-DAG:   mov $m0, [[LO]]
; CHECK-DAG:   mov $m1, [[HI]]
; CHECK:       br $m10
define <2 x i32> @load_v2i32_from_v2f32_ptr(<2 x float>* %addr)
{
  %val = load <2 x float>, <2 x float>* %addr
  %res = bitcast <2 x float> %val to <2 x i32>
  ret <2 x i32> %res
}

; CHECK-LABEL: load_v2i32_from_v2f32_val:
; CHECK:       # %bb
; CHECK-DAG:   ld32 [[LO:\$m[0-9]+]], $m0, $m15, 0
; CHECK-DAG:   ld32 [[HI:\$m[0-9]+]], $m0, $m15, 1
; CHECK-NOT:   break-dag-group
; CHECK-DAG:   mov $m0, [[LO]]
; CHECK-DAG:   mov $m1, [[HI]]
; CHECK:       br $m10
define <2 x i32> @load_v2i32_from_v2f32_val(<2 x float>* %addr)
{
  %iaddr = bitcast <2 x float>* %addr to <2 x i32>*
  %res = load <2 x i32>, <2 x i32>* %iaddr
  ret <2 x i32> %res
}

; Single use of postinc load with bitcast

declare {float, float*} @llvm.colossus.ldstep.f32(float*, i32)
declare {i32, i32*} @llvm.colossus.ldstep.i32(i32*, i32)

; CHECK-LABEL: call_ldstep_f32:
; CHECK:       # %bb
; CHECK-NEXT:  mov $m1, $m0
; CHECK-NEXT:  ld32step $m0, $m15, $m1+=, 1
; CHECK:       br $m10
define {i32, i32*} @call_ldstep_f32(i32 * %addr) {
  %bcaddr = bitcast i32* %addr to float*
  %loaded = call {float, float*} @llvm.colossus.ldstep.f32(float* %bcaddr, i32 1)
  %loaded0 = extractvalue { float, float* } %loaded, 0
  %loaded1 = extractvalue { float, float* } %loaded, 1
  %bcloaded0 = bitcast float %loaded0 to i32
  %bcloaded1 = bitcast float* %loaded1 to i32*
  %res_low = insertvalue { i32, i32* } undef, i32 %bcloaded0, 0
  %res_high = insertvalue { i32, i32* } %res_low, i32* %bcloaded1, 1
  ret {i32, i32*} %res_high
}

; CHECK-LABEL: call_ldstep_i32:
; CHECK:       # %bb
; CHECK-NEXT:  ld32step $a0, $m15, $m0+=, 1
; CHECK:       br $m10
define {float, float*} @call_ldstep_i32(float * %addr) {
  %bcaddr = bitcast float* %addr to i32*
  %loaded = call {i32, i32*} @llvm.colossus.ldstep.i32(i32* %bcaddr, i32 1)
  %loaded0 = extractvalue { i32, i32* } %loaded, 0
  %loaded1 = extractvalue { i32, i32* } %loaded, 1
  %bcloaded0 = bitcast i32 %loaded0 to float
  %bcloaded1 = bitcast i32* %loaded1 to float*
  %res_low = insertvalue { float, float* } undef, float %bcloaded0, 0
  %res_high = insertvalue { float, float* } %res_low, float* %bcloaded1, 1
  ret {float, float*} %res_high
}

declare {<2 x float>, <2 x float>*} @llvm.colossus.ldstep.v2f32(<2 x float>*, i32)
declare {<2 x i32>, <2 x i32>*} @llvm.colossus.ldstep.v2i32(<2 x i32>*, i32)

; CHECK-LABEL: call_ldstep_f64:
; Codegen isn't ideal for 64 bit integer loads
; TODO: Decide if it's worth doing postinc load on arf then two atom
; CHECK:       # %bb
; CHECK-DAG:   ld32 {{\$m[0-9]+}}, $m0, $m15, 0
; CHECK-DAG:   ld32 {{\$m[0-9]+}}, $m0, $m15, 1
; CHECK:       add {{\$m[0-9]+}}, $m0, 8
; CHECK:       br $m10
define {<2 x i32>, <2 x i32>*} @call_ldstep_f64(<2 x i32> * %addr) {
  %bcaddr = bitcast <2 x i32>* %addr to <2 x float>*
  %loaded = call {<2 x float>, <2 x float>*} @llvm.colossus.ldstep.v2f32(<2 x float>* %bcaddr, i32 1)
  %loaded0 = extractvalue { <2 x float>, <2 x float>* } %loaded, 0
  %loaded1 = extractvalue { <2 x float>, <2 x float>* } %loaded, 1
  %bcloaded0 = bitcast <2 x float> %loaded0 to <2 x i32>
  %bcloaded1 = bitcast <2 x float>* %loaded1 to <2 x i32>*
  %res_low = insertvalue { <2 x i32>, <2 x i32>* } undef, <2 x i32> %bcloaded0, 0
  %res_high = insertvalue { <2 x i32>, <2 x i32>* } %res_low, <2 x i32>* %bcloaded1, 1
  ret {<2 x i32>, <2 x i32>*} %res_high
}

; CHECK-LABEL: call_ldstep_i64:
; CHECK:       # %bb
; CHECK-NEXT:  ld64step $a0:1, $m15, $m0+=, 1
; CHECK:       br $m10
define {<2 x float>, <2 x float>*} @call_ldstep_i64(<2 x float> * %addr) {
  %bcaddr = bitcast <2 x float>* %addr to <2 x i32>*
  %loaded = call {<2 x i32>, <2 x i32>*} @llvm.colossus.ldstep.v2i32(<2 x i32>* %bcaddr, i32 1)
  %loaded0 = extractvalue { <2 x i32>, <2 x i32>* } %loaded, 0
  %loaded1 = extractvalue { <2 x i32>, <2 x i32>* } %loaded, 1
  %bcloaded0 = bitcast <2 x i32> %loaded0 to <2 x float>
  %bcloaded1 = bitcast <2 x i32>* %loaded1 to <2 x float>*
  %res_low = insertvalue { <2 x float>, <2 x float>* } undef, <2 x float> %bcloaded0, 0
  %res_high = insertvalue { <2 x float>, <2 x float>* } %res_low, <2 x float>* %bcloaded1, 1
  ret {<2 x float>, <2 x float>*} %res_high
}

; Multiple uses of load

; CHECK-LABEL: load_int_multiple_float_uses:
; CHECK:       # %bb
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m10, $m11, $m15, [[LRSpill:[0-1]]]
; Uses on ARF, load to ARF
; CHECK-NEXT:  ld32 $a0, $m0, $m15, 0
; CHECK-NEXT:  mov $a1, $a0
; CHECK-NEXT:  call $m10, sink_f
; CHECK-NEXT:  ld32 $m10, $m11, $m15, [[LRSpill]]
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10
declare void @sink_f(float, <2 x half>)
define void @load_int_multiple_float_uses(i32* %addr)
{
  %i = load i32, i32* %addr
  %f = bitcast i32 %i to float
  %h = bitcast i32 %i to <2 x half>
  call void @sink_f(float %f, <2 x half> %h)
  ret void
}

; CHECK-LABEL: load_float_multiple_int_uses:
; CHECK:       # %bb
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m10, $m11, $m15, [[LRSpill:[0-1]]]
; Uses on MRF, load to MRF
; CHECK-NEXT:  ld32 $m0, $m0, $m15, 0
; CHECK-NEXT:  mov $m1, $m0
; CHECK-NEXT:  call $m10, sink_i
; CHECK-NEXT:  ld32 $m10, $m11, $m15, [[LRSpill]]
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10
declare void @sink_i(i32, <2 x i16>)
define void @load_float_multiple_int_uses(float* %addr)
{
  %f = load float, float* %addr
  %i = bitcast float %f to i32
  %s = bitcast float %f to <2 x i16>
  call void @sink_i(i32 %i, <2 x i16> %s)
  ret void
}

declare void @sink(float, <2 x half>, i32, <2 x i16>)

; CHECK-LABEL: load_f32_from_i32_multiple_uses:
; CHECK:       # %bb
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m10, $m11, $m15, [[LRSpill:[0-1]]]
; Uses on MRF and ARF, load to ARF
; CHECK-NEXT:  ld32 $a0, $m0, $m15, 0
; Copy the value to the other registers for call
; CHECK-NEXT:  {
; CHECK-NEXT:  mov $m0, $a0
; CHECK-NEXT:  mov $a1, $a0
; CHECK-NEXT:  }
; CHECK-NEXT:  mov $m1, $m0
; CHECK-NEXT:  call $m10, sink
; CHECK-NEXT:  ld32 $m10, $m11, $m15, [[LRSpill]]
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10
define void @load_f32_from_i32_multiple_uses(i32* %addr)
{
  %i = load i32, i32* %addr
  %f = bitcast i32 %i to float
  %h = bitcast i32 %i to <2 x half>
  %s = bitcast i32 %i to <2 x i16>
  call void @sink(float %f, <2 x half> %h, i32 %i, <2 x i16> %s)
  ret void
}

; CHECK-LABEL: load_i32_from_f32_multiple_uses:
; CHECK:       # %bb
; CHECK:       add $m11, $m11, -8
; CHECK:       st32 $m10, $m11, $m15, [[LRSpill:[0-1]]]
; Uses on MRF and ARF, load to ARF
; CHECK-NEXT:  ld32 $a0, $m0, $m15, 0
; Copy the value to the other registers for call
; CHECK-NEXT:  {
; CHECK-NEXT:  mov $m0, $a0
; CHECK-NEXT:  mov $a1, $a0
; CHECK-NEXT:  }
; CHECK-NEXT:  mov $m1, $m0
; CHECK-NEXT:  call $m10, sink
; CHECK-NEXT:  ld32 $m10, $m11, $m15, [[LRSpill]]
; CHECK-NEXT:  add $m11, $m11, 8
; CHECK:       br $m10
define void @load_i32_from_f32_multiple_uses(float* %addr)
{
  %f = load float, float* %addr
  %i = bitcast float %f to i32
  %h = bitcast float %f to <2 x half>
  %s = bitcast float %f to <2 x i16>
  call void @sink(float %f, <2 x half> %h, i32 %i, <2 x i16> %s)
  ret void
}
