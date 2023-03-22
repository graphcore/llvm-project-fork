; RUN: opt < %s -colossus-intrinsic-calls -instcombine -S | FileCheck %s

declare void @ipu_half4_store_postinc(ptr, <4 x half>, i32)
declare void @ipu_half2_store_postinc(ptr, <2 x half>, i32)
declare void @ipu_half_store_postinc(ptr, half, i32)
declare void @ipu_float2_store_postinc(ptr, <2 x float>, i32)
declare void @ipu_float_store_postinc(ptr, float, i32)
declare void @ipu_short4_store_postinc(ptr, <4 x i16>, i32)
declare void @ipu_short2_store_postinc(ptr, <2 x i16>, i32)
declare void @ipu_short_store_postinc(ptr, i16, i32)
declare void @ipu_int2_store_postinc(ptr, <2 x i32>, i32)
declare void @ipu_int_store_postinc(ptr, i32, i32)
declare void @ipu_char_store_postinc(ptr, i8, i32)
declare <4 x half> @ipu_half4_load_postinc(ptr, i32)
declare <2 x half> @ipu_half2_load_postinc(ptr, i32)
declare half @ipu_half_load_postinc(ptr, i32)
declare <2 x float> @ipu_float2_load_postinc(ptr, i32)
declare float @ipu_float_load_postinc(ptr, i32)
declare <4 x i16> @ipu_short4_load_postinc(ptr, i32)
declare <2 x i16> @ipu_short2_load_postinc(ptr, i32)
declare i16 @ipu_short_load_postinc(ptr, i32)
declare <2 x i32> @ipu_int2_load_postinc(ptr, i32)
declare i32 @ipu_int_load_postinc(ptr, i32)
declare i8 @ipu_char_load_postinc(ptr, i32)

; CHECK-LABEL: define ptr @call_intrin_ipu_half4_store_postinc_zero(ptr %a, <4 x half> %v) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    %0 = call ptr @llvm.colossus.ststep.v4f16(<4 x half> %v, ptr %a, i32 0)
; CHECK-NEXT:    ret ptr %0
; CHECK-NEXT:  }
define ptr @call_intrin_ipu_half4_store_postinc_zero(ptr %a, <4 x half> %v) {
entry:
  %a.addr = alloca ptr, align 8
  store ptr %a, ptr %a.addr, align 8
  call void @ipu_half4_store_postinc(ptr nonnull %a.addr, <4 x half> %v, i32 0)
  %res = load ptr, ptr %a.addr, align 8
  ret ptr %res
}

; CHECK-LABEL: define ptr @call_intrin_ipu_half4_store_postinc_pos(ptr %a, <4 x half> %v) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    %0 = call ptr @llvm.colossus.ststep.v4f16(<4 x half> %v, ptr %a, i32 42)
; CHECK-NEXT:    ret ptr %0
; CHECK-NEXT:  }
define ptr @call_intrin_ipu_half4_store_postinc_pos(ptr %a, <4 x half> %v) {
entry:
  %a.addr = alloca ptr, align 8
  store ptr %a, ptr %a.addr, align 8
  call void @ipu_half4_store_postinc(ptr nonnull %a.addr, <4 x half> %v, i32 42)
  %res = load ptr, ptr %a.addr, align 8
  ret ptr %res
}

; CHECK-LABEL: define ptr @call_intrin_ipu_half4_store_postinc_neg(ptr %a, <4 x half> %v) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    %0 = call ptr @llvm.colossus.ststep.v4f16(<4 x half> %v, ptr %a, i32 -81)
; CHECK-NEXT:    ret ptr %0
; CHECK-NEXT:  }
define ptr @call_intrin_ipu_half4_store_postinc_neg(ptr %a, <4 x half> %v) {
entry:
  %a.addr = alloca ptr, align 8
  store ptr %a, ptr %a.addr, align 8
  call void @ipu_half4_store_postinc(ptr nonnull %a.addr, <4 x half> %v, i32 -81)
  %res = load ptr, ptr %a.addr, align 8
  ret ptr %res
}

; CHECK-LABEL: define ptr @call_intrin_ipu_half4_store_postinc_variable(ptr %a, <4 x half> %v, i32 %incr) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    %0 = call ptr @llvm.colossus.ststep.v4f16(<4 x half> %v, ptr %a, i32 %incr)
; CHECK-NEXT:    ret ptr %0
; CHECK-NEXT:  }
define ptr @call_intrin_ipu_half4_store_postinc_variable(ptr %a, <4 x half> %v, i32 %incr) {
entry:
  %a.addr = alloca ptr, align 8
  store ptr %a, ptr %a.addr, align 8
  call void @ipu_half4_store_postinc(ptr nonnull %a.addr, <4 x half> %v, i32 %incr)
  %res = load ptr, ptr %a.addr, align 8
  ret ptr %res
}

; CHECK-LABEL: define { <4 x half>, ptr } @call_intrin_ipu_half4_load_postinc_zero(ptr %a) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    %0 = call { <4 x half>, ptr } @llvm.colossus.ldstep.v4f16(ptr %a, i32 0)
; CHECK-NEXT:    ret { <4 x half>, ptr } %0
; CHECK-NEXT:  }
define { <4 x half>, ptr } @call_intrin_ipu_half4_load_postinc_zero(ptr %a) {
entry:
  %a.addr = alloca ptr, align 8
  store ptr %a, ptr %a.addr, align 8
  %val = call <4 x half> @ipu_half4_load_postinc(ptr nonnull %a.addr, i32 0)
  %res = load ptr, ptr %a.addr, align 8
  %res_low = insertvalue { <4 x half>, ptr } undef, <4 x half> %val, 0
  %res_high = insertvalue { <4 x half>, ptr } %res_low, ptr %res, 1
  ret { <4 x half>, ptr } %res_high
}

; CHECK-LABEL: define { <4 x half>, ptr } @call_intrin_ipu_half4_load_postinc_pos(ptr %a) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    %0 = call { <4 x half>, ptr } @llvm.colossus.ldstep.v4f16(ptr %a, i32 42)
; CHECK-NEXT:    ret { <4 x half>, ptr } %0
; CHECK-NEXT:  }
define { <4 x half>, ptr } @call_intrin_ipu_half4_load_postinc_pos(ptr %a) {
entry:
  %a.addr = alloca ptr, align 8
  store ptr %a, ptr %a.addr, align 8
  %val = call <4 x half> @ipu_half4_load_postinc(ptr nonnull %a.addr, i32 42)
  %res = load ptr, ptr %a.addr, align 8
  %res_low = insertvalue { <4 x half>, ptr } undef, <4 x half> %val, 0
  %res_high = insertvalue { <4 x half>, ptr } %res_low, ptr %res, 1
  ret { <4 x half>, ptr } %res_high
}

; CHECK-LABEL: define { <4 x half>, ptr } @call_intrin_ipu_half4_load_postinc_neg(ptr %a) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    %0 = call { <4 x half>, ptr } @llvm.colossus.ldstep.v4f16(ptr %a, i32 -81)
; CHECK-NEXT:    ret { <4 x half>, ptr } %0
; CHECK-NEXT:  }
define { <4 x half>, ptr } @call_intrin_ipu_half4_load_postinc_neg(ptr %a) {
entry:
  %a.addr = alloca ptr, align 8
  store ptr %a, ptr %a.addr, align 8
  %val = call <4 x half> @ipu_half4_load_postinc(ptr nonnull %a.addr, i32 -81)
  %res = load ptr, ptr %a.addr, align 8
  %res_low = insertvalue { <4 x half>, ptr } undef, <4 x half> %val, 0
  %res_high = insertvalue { <4 x half>, ptr } %res_low, ptr %res, 1
  ret { <4 x half>, ptr } %res_high
}

; CHECK-LABEL: define { <4 x half>, ptr } @call_intrin_ipu_half4_load_postinc_variable(ptr %a, i32 %incr) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    %0 = call { <4 x half>, ptr } @llvm.colossus.ldstep.v4f16(ptr %a, i32 %incr)
; CHECK-NEXT:    ret { <4 x half>, ptr } %0
; CHECK-NEXT:  }
define { <4 x half>, ptr } @call_intrin_ipu_half4_load_postinc_variable(ptr %a, i32 %incr) {
entry:
  %a.addr = alloca ptr, align 8
  store ptr %a, ptr %a.addr, align 8
  %val = call <4 x half> @ipu_half4_load_postinc(ptr nonnull %a.addr, i32 %incr)
  %res = load ptr, ptr %a.addr, align 8
  %res_low = insertvalue { <4 x half>, ptr } undef, <4 x half> %val, 0
  %res_high = insertvalue { <4 x half>, ptr } %res_low, ptr %res, 1
  ret { <4 x half>, ptr } %res_high
}

; CHECK-LABEL: define ptr @call_intrin_ipu_half2_store_postinc_zero(ptr %a, <2 x half> %v) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    %0 = call ptr @llvm.colossus.ststep.v2f16(<2 x half> %v, ptr %a, i32 0)
; CHECK-NEXT:    ret ptr %0
; CHECK-NEXT:  }
define ptr @call_intrin_ipu_half2_store_postinc_zero(ptr %a, <2 x half> %v) {
entry:
  %a.addr = alloca ptr, align 8
  store ptr %a, ptr %a.addr, align 8
  call void @ipu_half2_store_postinc(ptr nonnull %a.addr, <2 x half> %v, i32 0)
  %res = load ptr, ptr %a.addr, align 8
  ret ptr %res
}

; CHECK-LABEL: define ptr @call_intrin_ipu_half2_store_postinc_pos(ptr %a, <2 x half> %v) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    %0 = call ptr @llvm.colossus.ststep.v2f16(<2 x half> %v, ptr %a, i32 42)
; CHECK-NEXT:    ret ptr %0
; CHECK-NEXT:  }
define ptr @call_intrin_ipu_half2_store_postinc_pos(ptr %a, <2 x half> %v) {
entry:
  %a.addr = alloca ptr, align 8
  store ptr %a, ptr %a.addr, align 8
  call void @ipu_half2_store_postinc(ptr nonnull %a.addr, <2 x half> %v, i32 42)
  %res = load ptr, ptr %a.addr, align 8
  ret ptr %res
}

; CHECK-LABEL: define ptr @call_intrin_ipu_half2_store_postinc_neg(ptr %a, <2 x half> %v) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    %0 = call ptr @llvm.colossus.ststep.v2f16(<2 x half> %v, ptr %a, i32 -81)
; CHECK-NEXT:    ret ptr %0
; CHECK-NEXT:  }
define ptr @call_intrin_ipu_half2_store_postinc_neg(ptr %a, <2 x half> %v) {
entry:
  %a.addr = alloca ptr, align 8
  store ptr %a, ptr %a.addr, align 8
  call void @ipu_half2_store_postinc(ptr nonnull %a.addr, <2 x half> %v, i32 -81)
  %res = load ptr, ptr %a.addr, align 8
  ret ptr %res
}

; CHECK-LABEL: define ptr @call_intrin_ipu_half2_store_postinc_variable(ptr %a, <2 x half> %v, i32 %incr) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    %0 = call ptr @llvm.colossus.ststep.v2f16(<2 x half> %v, ptr %a, i32 %incr)
; CHECK-NEXT:    ret ptr %0
; CHECK-NEXT:  }
define ptr @call_intrin_ipu_half2_store_postinc_variable(ptr %a, <2 x half> %v, i32 %incr) {
entry:
  %a.addr = alloca ptr, align 8
  store ptr %a, ptr %a.addr, align 8
  call void @ipu_half2_store_postinc(ptr nonnull %a.addr, <2 x half> %v, i32 %incr)
  %res = load ptr, ptr %a.addr, align 8
  ret ptr %res
}

; CHECK-LABEL: define { <2 x half>, ptr } @call_intrin_ipu_half2_load_postinc_zero(ptr %a) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    %0 = call { <2 x half>, ptr } @llvm.colossus.ldstep.v2f16(ptr %a, i32 0)
; CHECK-NEXT:    ret { <2 x half>, ptr } %0
; CHECK-NEXT:  }
define { <2 x half>, ptr } @call_intrin_ipu_half2_load_postinc_zero(ptr %a) {
entry:
  %a.addr = alloca ptr, align 8
  store ptr %a, ptr %a.addr, align 8
  %val = call <2 x half> @ipu_half2_load_postinc(ptr nonnull %a.addr, i32 0)
  %res = load ptr, ptr %a.addr, align 8
  %res_low = insertvalue { <2 x half>, ptr } undef, <2 x half> %val, 0
  %res_high = insertvalue { <2 x half>, ptr } %res_low, ptr %res, 1
  ret { <2 x half>, ptr } %res_high
}

; CHECK-LABEL: define { <2 x half>, ptr } @call_intrin_ipu_half2_load_postinc_pos(ptr %a) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    %0 = call { <2 x half>, ptr } @llvm.colossus.ldstep.v2f16(ptr %a, i32 42)
; CHECK-NEXT:    ret { <2 x half>, ptr } %0
; CHECK-NEXT:  }
define { <2 x half>, ptr } @call_intrin_ipu_half2_load_postinc_pos(ptr %a) {
entry:
  %a.addr = alloca ptr, align 8
  store ptr %a, ptr %a.addr, align 8
  %val = call <2 x half> @ipu_half2_load_postinc(ptr nonnull %a.addr, i32 42)
  %res = load ptr, ptr %a.addr, align 8
  %res_low = insertvalue { <2 x half>, ptr } undef, <2 x half> %val, 0
  %res_high = insertvalue { <2 x half>, ptr } %res_low, ptr %res, 1
  ret { <2 x half>, ptr } %res_high
}

; CHECK-LABEL: define { <2 x half>, ptr } @call_intrin_ipu_half2_load_postinc_neg(ptr %a) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    %0 = call { <2 x half>, ptr } @llvm.colossus.ldstep.v2f16(ptr %a, i32 -81)
; CHECK-NEXT:    ret { <2 x half>, ptr } %0
; CHECK-NEXT:  }
define { <2 x half>, ptr } @call_intrin_ipu_half2_load_postinc_neg(ptr %a) {
entry:
  %a.addr = alloca ptr, align 8
  store ptr %a, ptr %a.addr, align 8
  %val = call <2 x half> @ipu_half2_load_postinc(ptr nonnull %a.addr, i32 -81)
  %res = load ptr, ptr %a.addr, align 8
  %res_low = insertvalue { <2 x half>, ptr } undef, <2 x half> %val, 0
  %res_high = insertvalue { <2 x half>, ptr } %res_low, ptr %res, 1
  ret { <2 x half>, ptr } %res_high
}

; CHECK-LABEL: define { <2 x half>, ptr } @call_intrin_ipu_half2_load_postinc_variable(ptr %a, i32 %incr) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    %0 = call { <2 x half>, ptr } @llvm.colossus.ldstep.v2f16(ptr %a, i32 %incr)
; CHECK-NEXT:    ret { <2 x half>, ptr } %0
; CHECK-NEXT:  }
define { <2 x half>, ptr } @call_intrin_ipu_half2_load_postinc_variable(ptr %a, i32 %incr) {
entry:
  %a.addr = alloca ptr, align 8
  store ptr %a, ptr %a.addr, align 8
  %val = call <2 x half> @ipu_half2_load_postinc(ptr nonnull %a.addr, i32 %incr)
  %res = load ptr, ptr %a.addr, align 8
  %res_low = insertvalue { <2 x half>, ptr } undef, <2 x half> %val, 0
  %res_high = insertvalue { <2 x half>, ptr } %res_low, ptr %res, 1
  ret { <2 x half>, ptr } %res_high
}

; CHECK-LABEL: define ptr @call_intrin_ipu_half_store_postinc_zero(ptr %a, half %v) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    %a.addr = alloca ptr, align 8
; CHECK-NEXT:    store ptr %a, ptr %a.addr, align 8
; CHECK-NEXT:    call void @ipu_half_store_postinc(ptr nonnull %a.addr, half %v, i32 0)
; CHECK-NEXT:    %res = load ptr, ptr %a.addr, align 8
; CHECK-NEXT:    ret ptr %res
; CHECK-NEXT:  }
define ptr @call_intrin_ipu_half_store_postinc_zero(ptr %a, half %v) {
entry:
  %a.addr = alloca ptr, align 8
  store ptr %a, ptr %a.addr, align 8
  call void @ipu_half_store_postinc(ptr nonnull %a.addr, half %v, i32 0)
  %res = load ptr, ptr %a.addr, align 8
  ret ptr %res
}

; CHECK-LABEL: define ptr @call_intrin_ipu_half_store_postinc_pos(ptr %a, half %v) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    %a.addr = alloca ptr, align 8
; CHECK-NEXT:    store ptr %a, ptr %a.addr, align 8
; CHECK-NEXT:    call void @ipu_half_store_postinc(ptr nonnull %a.addr, half %v, i32 42)
; CHECK-NEXT:    %res = load ptr, ptr %a.addr, align 8
; CHECK-NEXT:    ret ptr %res
; CHECK-NEXT:  }
define ptr @call_intrin_ipu_half_store_postinc_pos(ptr %a, half %v) {
entry:
  %a.addr = alloca ptr, align 8
  store ptr %a, ptr %a.addr, align 8
  call void @ipu_half_store_postinc(ptr nonnull %a.addr, half %v, i32 42)
  %res = load ptr, ptr %a.addr, align 8
  ret ptr %res
}

; CHECK-LABEL: define ptr @call_intrin_ipu_half_store_postinc_neg(ptr %a, half %v) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    %a.addr = alloca ptr, align 8
; CHECK-NEXT:    store ptr %a, ptr %a.addr, align 8
; CHECK-NEXT:    call void @ipu_half_store_postinc(ptr nonnull %a.addr, half %v, i32 -81)
; CHECK-NEXT:    %res = load ptr, ptr %a.addr, align 8
; CHECK-NEXT:    ret ptr %res
; CHECK-NEXT:  }
define ptr @call_intrin_ipu_half_store_postinc_neg(ptr %a, half %v) {
entry:
  %a.addr = alloca ptr, align 8
  store ptr %a, ptr %a.addr, align 8
  call void @ipu_half_store_postinc(ptr nonnull %a.addr, half %v, i32 -81)
  %res = load ptr, ptr %a.addr, align 8
  ret ptr %res
}

; CHECK-LABEL: define ptr @call_intrin_ipu_half_store_postinc_variable(ptr %a, half %v, i32 %incr) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    %a.addr = alloca ptr, align 8
; CHECK-NEXT:    store ptr %a, ptr %a.addr, align 8
; CHECK-NEXT:    call void @ipu_half_store_postinc(ptr nonnull %a.addr, half %v, i32 %incr)
; CHECK-NEXT:    %res = load ptr, ptr %a.addr, align 8
; CHECK-NEXT:    ret ptr %res
; CHECK-NEXT:  }
define ptr @call_intrin_ipu_half_store_postinc_variable(ptr %a, half %v, i32 %incr) {
entry:
  %a.addr = alloca ptr, align 8
  store ptr %a, ptr %a.addr, align 8
  call void @ipu_half_store_postinc(ptr nonnull %a.addr, half %v, i32 %incr)
  %res = load ptr, ptr %a.addr, align 8
  ret ptr %res
}

; CHECK-LABEL: define { half, ptr } @call_intrin_ipu_half_load_postinc_zero(ptr %a) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    %0 = call { half, ptr } @llvm.colossus.ldstep.f16(ptr %a, i32 0)
; CHECK-NEXT:    ret { half, ptr } %0
; CHECK-NEXT:  }
define { half, ptr } @call_intrin_ipu_half_load_postinc_zero(ptr %a) {
entry:
  %a.addr = alloca ptr, align 8
  store ptr %a, ptr %a.addr, align 8
  %val = call half @ipu_half_load_postinc(ptr nonnull %a.addr, i32 0)
  %res = load ptr, ptr %a.addr, align 8
  %res_low = insertvalue { half, ptr } undef, half %val, 0
  %res_high = insertvalue { half, ptr } %res_low, ptr %res, 1
  ret { half, ptr } %res_high
}

; CHECK-LABEL: define { half, ptr } @call_intrin_ipu_half_load_postinc_pos(ptr %a) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    %0 = call { half, ptr } @llvm.colossus.ldstep.f16(ptr %a, i32 42)
; CHECK-NEXT:    ret { half, ptr } %0
; CHECK-NEXT:  }
define { half, ptr } @call_intrin_ipu_half_load_postinc_pos(ptr %a) {
entry:
  %a.addr = alloca ptr, align 8
  store ptr %a, ptr %a.addr, align 8
  %val = call half @ipu_half_load_postinc(ptr nonnull %a.addr, i32 42)
  %res = load ptr, ptr %a.addr, align 8
  %res_low = insertvalue { half, ptr } undef, half %val, 0
  %res_high = insertvalue { half, ptr } %res_low, ptr %res, 1
  ret { half, ptr } %res_high
}

; CHECK-LABEL: define { half, ptr } @call_intrin_ipu_half_load_postinc_neg(ptr %a) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    %0 = call { half, ptr } @llvm.colossus.ldstep.f16(ptr %a, i32 -81)
; CHECK-NEXT:    ret { half, ptr } %0
; CHECK-NEXT:  }
define { half, ptr } @call_intrin_ipu_half_load_postinc_neg(ptr %a) {
entry:
  %a.addr = alloca ptr, align 8
  store ptr %a, ptr %a.addr, align 8
  %val = call half @ipu_half_load_postinc(ptr nonnull %a.addr, i32 -81)
  %res = load ptr, ptr %a.addr, align 8
  %res_low = insertvalue { half, ptr } undef, half %val, 0
  %res_high = insertvalue { half, ptr } %res_low, ptr %res, 1
  ret { half, ptr } %res_high
}

; CHECK-LABEL: define { half, ptr } @call_intrin_ipu_half_load_postinc_variable(ptr %a, i32 %incr) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    %0 = call { half, ptr } @llvm.colossus.ldstep.f16(ptr %a, i32 %incr)
; CHECK-NEXT:    ret { half, ptr } %0
; CHECK-NEXT:  }
define { half, ptr } @call_intrin_ipu_half_load_postinc_variable(ptr %a, i32 %incr) {
entry:
  %a.addr = alloca ptr, align 8
  store ptr %a, ptr %a.addr, align 8
  %val = call half @ipu_half_load_postinc(ptr nonnull %a.addr, i32 %incr)
  %res = load ptr, ptr %a.addr, align 8
  %res_low = insertvalue { half, ptr } undef, half %val, 0
  %res_high = insertvalue { half, ptr } %res_low, ptr %res, 1
  ret { half, ptr } %res_high
}

; CHECK-LABEL: define ptr @call_intrin_ipu_float2_store_postinc_zero(ptr %a, <2 x float> %v) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    %0 = call ptr @llvm.colossus.ststep.v2f32(<2 x float> %v, ptr %a, i32 0)
; CHECK-NEXT:    ret ptr %0
; CHECK-NEXT:  }
define ptr @call_intrin_ipu_float2_store_postinc_zero(ptr %a, <2 x float> %v) {
entry:
  %a.addr = alloca ptr, align 8
  store ptr %a, ptr %a.addr, align 8
  call void @ipu_float2_store_postinc(ptr nonnull %a.addr, <2 x float> %v, i32 0)
  %res = load ptr, ptr %a.addr, align 8
  ret ptr %res
}

; CHECK-LABEL: define ptr @call_intrin_ipu_float2_store_postinc_pos(ptr %a, <2 x float> %v) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    %0 = call ptr @llvm.colossus.ststep.v2f32(<2 x float> %v, ptr %a, i32 42)
; CHECK-NEXT:    ret ptr %0
; CHECK-NEXT:  }
define ptr @call_intrin_ipu_float2_store_postinc_pos(ptr %a, <2 x float> %v) {
entry:
  %a.addr = alloca ptr, align 8
  store ptr %a, ptr %a.addr, align 8
  call void @ipu_float2_store_postinc(ptr nonnull %a.addr, <2 x float> %v, i32 42)
  %res = load ptr, ptr %a.addr, align 8
  ret ptr %res
}

; CHECK-LABEL: define ptr @call_intrin_ipu_float2_store_postinc_neg(ptr %a, <2 x float> %v) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    %0 = call ptr @llvm.colossus.ststep.v2f32(<2 x float> %v, ptr %a, i32 -81)
; CHECK-NEXT:    ret ptr %0
; CHECK-NEXT:  }
define ptr @call_intrin_ipu_float2_store_postinc_neg(ptr %a, <2 x float> %v) {
entry:
  %a.addr = alloca ptr, align 8
  store ptr %a, ptr %a.addr, align 8
  call void @ipu_float2_store_postinc(ptr nonnull %a.addr, <2 x float> %v, i32 -81)
  %res = load ptr, ptr %a.addr, align 8
  ret ptr %res
}

; CHECK-LABEL: define ptr @call_intrin_ipu_float2_store_postinc_variable(ptr %a, <2 x float> %v, i32 %incr) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    %0 = call ptr @llvm.colossus.ststep.v2f32(<2 x float> %v, ptr %a, i32 %incr)
; CHECK-NEXT:    ret ptr %0
; CHECK-NEXT:  }
define ptr @call_intrin_ipu_float2_store_postinc_variable(ptr %a, <2 x float> %v, i32 %incr) {
entry:
  %a.addr = alloca ptr, align 8
  store ptr %a, ptr %a.addr, align 8
  call void @ipu_float2_store_postinc(ptr nonnull %a.addr, <2 x float> %v, i32 %incr)
  %res = load ptr, ptr %a.addr, align 8
  ret ptr %res
}

; CHECK-LABEL: define { <2 x float>, ptr } @call_intrin_ipu_float2_load_postinc_zero(ptr %a) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    %0 = call { <2 x float>, ptr } @llvm.colossus.ldstep.v2f32(ptr %a, i32 0)
; CHECK-NEXT:    ret { <2 x float>, ptr } %0
; CHECK-NEXT:  }
define { <2 x float>, ptr } @call_intrin_ipu_float2_load_postinc_zero(ptr %a) {
entry:
  %a.addr = alloca ptr, align 8
  store ptr %a, ptr %a.addr, align 8
  %val = call <2 x float> @ipu_float2_load_postinc(ptr nonnull %a.addr, i32 0)
  %res = load ptr, ptr %a.addr, align 8
  %res_low = insertvalue { <2 x float>, ptr } undef, <2 x float> %val, 0
  %res_high = insertvalue { <2 x float>, ptr } %res_low, ptr %res, 1
  ret { <2 x float>, ptr } %res_high
}

; CHECK-LABEL: define { <2 x float>, ptr } @call_intrin_ipu_float2_load_postinc_pos(ptr %a) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    %0 = call { <2 x float>, ptr } @llvm.colossus.ldstep.v2f32(ptr %a, i32 42)
; CHECK-NEXT:    ret { <2 x float>, ptr } %0
; CHECK-NEXT:  }
define { <2 x float>, ptr } @call_intrin_ipu_float2_load_postinc_pos(ptr %a) {
entry:
  %a.addr = alloca ptr, align 8
  store ptr %a, ptr %a.addr, align 8
  %val = call <2 x float> @ipu_float2_load_postinc(ptr nonnull %a.addr, i32 42)
  %res = load ptr, ptr %a.addr, align 8
  %res_low = insertvalue { <2 x float>, ptr } undef, <2 x float> %val, 0
  %res_high = insertvalue { <2 x float>, ptr } %res_low, ptr %res, 1
  ret { <2 x float>, ptr } %res_high
}

; CHECK-LABEL: define { <2 x float>, ptr } @call_intrin_ipu_float2_load_postinc_neg(ptr %a) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    %0 = call { <2 x float>, ptr } @llvm.colossus.ldstep.v2f32(ptr %a, i32 -81)
; CHECK-NEXT:    ret { <2 x float>, ptr } %0
; CHECK-NEXT:  }
define { <2 x float>, ptr } @call_intrin_ipu_float2_load_postinc_neg(ptr %a) {
entry:
  %a.addr = alloca ptr, align 8
  store ptr %a, ptr %a.addr, align 8
  %val = call <2 x float> @ipu_float2_load_postinc(ptr nonnull %a.addr, i32 -81)
  %res = load ptr, ptr %a.addr, align 8
  %res_low = insertvalue { <2 x float>, ptr } undef, <2 x float> %val, 0
  %res_high = insertvalue { <2 x float>, ptr } %res_low, ptr %res, 1
  ret { <2 x float>, ptr } %res_high
}

; CHECK-LABEL: define { <2 x float>, ptr } @call_intrin_ipu_float2_load_postinc_variable(ptr %a, i32 %incr) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    %0 = call { <2 x float>, ptr } @llvm.colossus.ldstep.v2f32(ptr %a, i32 %incr)
; CHECK-NEXT:    ret { <2 x float>, ptr } %0
; CHECK-NEXT:  }
define { <2 x float>, ptr } @call_intrin_ipu_float2_load_postinc_variable(ptr %a, i32 %incr) {
entry:
  %a.addr = alloca ptr, align 8
  store ptr %a, ptr %a.addr, align 8
  %val = call <2 x float> @ipu_float2_load_postinc(ptr nonnull %a.addr, i32 %incr)
  %res = load ptr, ptr %a.addr, align 8
  %res_low = insertvalue { <2 x float>, ptr } undef, <2 x float> %val, 0
  %res_high = insertvalue { <2 x float>, ptr } %res_low, ptr %res, 1
  ret { <2 x float>, ptr } %res_high
}

; CHECK-LABEL: define ptr @call_intrin_ipu_float_store_postinc_zero(ptr %a, float %v) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    %0 = call ptr @llvm.colossus.ststep.f32(float %v, ptr %a, i32 0)
; CHECK-NEXT:    ret ptr %0
; CHECK-NEXT:  }
define ptr @call_intrin_ipu_float_store_postinc_zero(ptr %a, float %v) {
entry:
  %a.addr = alloca ptr, align 8
  store ptr %a, ptr %a.addr, align 8
  call void @ipu_float_store_postinc(ptr nonnull %a.addr, float %v, i32 0)
  %res = load ptr, ptr %a.addr, align 8
  ret ptr %res
}

; CHECK-LABEL: define ptr @call_intrin_ipu_float_store_postinc_pos(ptr %a, float %v) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    %0 = call ptr @llvm.colossus.ststep.f32(float %v, ptr %a, i32 42)
; CHECK-NEXT:    ret ptr %0
; CHECK-NEXT:  }
define ptr @call_intrin_ipu_float_store_postinc_pos(ptr %a, float %v) {
entry:
  %a.addr = alloca ptr, align 8
  store ptr %a, ptr %a.addr, align 8
  call void @ipu_float_store_postinc(ptr nonnull %a.addr, float %v, i32 42)
  %res = load ptr, ptr %a.addr, align 8
  ret ptr %res
}

; CHECK-LABEL: define ptr @call_intrin_ipu_float_store_postinc_neg(ptr %a, float %v) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    %0 = call ptr @llvm.colossus.ststep.f32(float %v, ptr %a, i32 -81)
; CHECK-NEXT:    ret ptr %0
; CHECK-NEXT:  }
define ptr @call_intrin_ipu_float_store_postinc_neg(ptr %a, float %v) {
entry:
  %a.addr = alloca ptr, align 8
  store ptr %a, ptr %a.addr, align 8
  call void @ipu_float_store_postinc(ptr nonnull %a.addr, float %v, i32 -81)
  %res = load ptr, ptr %a.addr, align 8
  ret ptr %res
}

; CHECK-LABEL: define ptr @call_intrin_ipu_float_store_postinc_variable(ptr %a, float %v, i32 %incr) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    %0 = call ptr @llvm.colossus.ststep.f32(float %v, ptr %a, i32 %incr)
; CHECK-NEXT:    ret ptr %0
; CHECK-NEXT:  }
define ptr @call_intrin_ipu_float_store_postinc_variable(ptr %a, float %v, i32 %incr) {
entry:
  %a.addr = alloca ptr, align 8
  store ptr %a, ptr %a.addr, align 8
  call void @ipu_float_store_postinc(ptr nonnull %a.addr, float %v, i32 %incr)
  %res = load ptr, ptr %a.addr, align 8
  ret ptr %res
}

; CHECK-LABEL: define { float, ptr } @call_intrin_ipu_float_load_postinc_zero(ptr %a) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    %0 = call { float, ptr } @llvm.colossus.ldstep.f32(ptr %a, i32 0)
; CHECK-NEXT:    ret { float, ptr } %0
; CHECK-NEXT:  }
define { float, ptr } @call_intrin_ipu_float_load_postinc_zero(ptr %a) {
entry:
  %a.addr = alloca ptr, align 8
  store ptr %a, ptr %a.addr, align 8
  %val = call float @ipu_float_load_postinc(ptr nonnull %a.addr, i32 0)
  %res = load ptr, ptr %a.addr, align 8
  %res_low = insertvalue { float, ptr } undef, float %val, 0
  %res_high = insertvalue { float, ptr } %res_low, ptr %res, 1
  ret { float, ptr } %res_high
}

; CHECK-LABEL: define { float, ptr } @call_intrin_ipu_float_load_postinc_pos(ptr %a) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    %0 = call { float, ptr } @llvm.colossus.ldstep.f32(ptr %a, i32 42)
; CHECK-NEXT:    ret { float, ptr } %0
; CHECK-NEXT:  }
define { float, ptr } @call_intrin_ipu_float_load_postinc_pos(ptr %a) {
entry:
  %a.addr = alloca ptr, align 8
  store ptr %a, ptr %a.addr, align 8
  %val = call float @ipu_float_load_postinc(ptr nonnull %a.addr, i32 42)
  %res = load ptr, ptr %a.addr, align 8
  %res_low = insertvalue { float, ptr } undef, float %val, 0
  %res_high = insertvalue { float, ptr } %res_low, ptr %res, 1
  ret { float, ptr } %res_high
}

; CHECK-LABEL: define { float, ptr } @call_intrin_ipu_float_load_postinc_neg(ptr %a) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    %0 = call { float, ptr } @llvm.colossus.ldstep.f32(ptr %a, i32 -81)
; CHECK-NEXT:    ret { float, ptr } %0
; CHECK-NEXT:  }
define { float, ptr } @call_intrin_ipu_float_load_postinc_neg(ptr %a) {
entry:
  %a.addr = alloca ptr, align 8
  store ptr %a, ptr %a.addr, align 8
  %val = call float @ipu_float_load_postinc(ptr nonnull %a.addr, i32 -81)
  %res = load ptr, ptr %a.addr, align 8
  %res_low = insertvalue { float, ptr } undef, float %val, 0
  %res_high = insertvalue { float, ptr } %res_low, ptr %res, 1
  ret { float, ptr } %res_high
}

; CHECK-LABEL: define { float, ptr } @call_intrin_ipu_float_load_postinc_variable(ptr %a, i32 %incr) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    %0 = call { float, ptr } @llvm.colossus.ldstep.f32(ptr %a, i32 %incr)
; CHECK-NEXT:    ret { float, ptr } %0
; CHECK-NEXT:  }
define { float, ptr } @call_intrin_ipu_float_load_postinc_variable(ptr %a, i32 %incr) {
entry:
  %a.addr = alloca ptr, align 8
  store ptr %a, ptr %a.addr, align 8
  %val = call float @ipu_float_load_postinc(ptr nonnull %a.addr, i32 %incr)
  %res = load ptr, ptr %a.addr, align 8
  %res_low = insertvalue { float, ptr } undef, float %val, 0
  %res_high = insertvalue { float, ptr } %res_low, ptr %res, 1
  ret { float, ptr } %res_high
}

; CHECK-LABEL: define ptr @call_intrin_ipu_short4_store_postinc_zero(ptr %a, <4 x i16> %v) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    %0 = call ptr @llvm.colossus.ststep.v4i16(<4 x i16> %v, ptr %a, i32 0)
; CHECK-NEXT:    ret ptr %0
; CHECK-NEXT:  }
define ptr @call_intrin_ipu_short4_store_postinc_zero(ptr %a, <4 x i16> %v) {
entry:
  %a.addr = alloca ptr, align 8
  store ptr %a, ptr %a.addr, align 8
  call void @ipu_short4_store_postinc(ptr nonnull %a.addr, <4 x i16> %v, i32 0)
  %res = load ptr, ptr %a.addr, align 8
  ret ptr %res
}

; CHECK-LABEL: define ptr @call_intrin_ipu_short4_store_postinc_pos(ptr %a, <4 x i16> %v) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    %0 = call ptr @llvm.colossus.ststep.v4i16(<4 x i16> %v, ptr %a, i32 42)
; CHECK-NEXT:    ret ptr %0
; CHECK-NEXT:  }
define ptr @call_intrin_ipu_short4_store_postinc_pos(ptr %a, <4 x i16> %v) {
entry:
  %a.addr = alloca ptr, align 8
  store ptr %a, ptr %a.addr, align 8
  call void @ipu_short4_store_postinc(ptr nonnull %a.addr, <4 x i16> %v, i32 42)
  %res = load ptr, ptr %a.addr, align 8
  ret ptr %res
}

; CHECK-LABEL: define ptr @call_intrin_ipu_short4_store_postinc_neg(ptr %a, <4 x i16> %v) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    %0 = call ptr @llvm.colossus.ststep.v4i16(<4 x i16> %v, ptr %a, i32 -81)
; CHECK-NEXT:    ret ptr %0
; CHECK-NEXT:  }
define ptr @call_intrin_ipu_short4_store_postinc_neg(ptr %a, <4 x i16> %v) {
entry:
  %a.addr = alloca ptr, align 8
  store ptr %a, ptr %a.addr, align 8
  call void @ipu_short4_store_postinc(ptr nonnull %a.addr, <4 x i16> %v, i32 -81)
  %res = load ptr, ptr %a.addr, align 8
  ret ptr %res
}

; CHECK-LABEL: define ptr @call_intrin_ipu_short4_store_postinc_variable(ptr %a, <4 x i16> %v, i32 %incr) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    %0 = call ptr @llvm.colossus.ststep.v4i16(<4 x i16> %v, ptr %a, i32 %incr)
; CHECK-NEXT:    ret ptr %0
; CHECK-NEXT:  }
define ptr @call_intrin_ipu_short4_store_postinc_variable(ptr %a, <4 x i16> %v, i32 %incr) {
entry:
  %a.addr = alloca ptr, align 8
  store ptr %a, ptr %a.addr, align 8
  call void @ipu_short4_store_postinc(ptr nonnull %a.addr, <4 x i16> %v, i32 %incr)
  %res = load ptr, ptr %a.addr, align 8
  ret ptr %res
}

; CHECK-LABEL: define { <4 x i16>, ptr } @call_intrin_ipu_short4_load_postinc_zero(ptr %a) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    %0 = call { <4 x i16>, ptr } @llvm.colossus.ldstep.v4i16(ptr %a, i32 0)
; CHECK-NEXT:    ret { <4 x i16>, ptr } %0
; CHECK-NEXT:  }
define { <4 x i16>, ptr } @call_intrin_ipu_short4_load_postinc_zero(ptr %a) {
entry:
  %a.addr = alloca ptr, align 8
  store ptr %a, ptr %a.addr, align 8
  %val = call <4 x i16> @ipu_short4_load_postinc(ptr nonnull %a.addr, i32 0)
  %res = load ptr, ptr %a.addr, align 8
  %res_low = insertvalue { <4 x i16>, ptr } undef, <4 x i16> %val, 0
  %res_high = insertvalue { <4 x i16>, ptr } %res_low, ptr %res, 1
  ret { <4 x i16>, ptr } %res_high
}

; CHECK-LABEL: define { <4 x i16>, ptr } @call_intrin_ipu_short4_load_postinc_pos(ptr %a) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    %0 = call { <4 x i16>, ptr } @llvm.colossus.ldstep.v4i16(ptr %a, i32 42)
; CHECK-NEXT:    ret { <4 x i16>, ptr } %0
; CHECK-NEXT:  }
define { <4 x i16>, ptr } @call_intrin_ipu_short4_load_postinc_pos(ptr %a) {
entry:
  %a.addr = alloca ptr, align 8
  store ptr %a, ptr %a.addr, align 8
  %val = call <4 x i16> @ipu_short4_load_postinc(ptr nonnull %a.addr, i32 42)
  %res = load ptr, ptr %a.addr, align 8
  %res_low = insertvalue { <4 x i16>, ptr } undef, <4 x i16> %val, 0
  %res_high = insertvalue { <4 x i16>, ptr } %res_low, ptr %res, 1
  ret { <4 x i16>, ptr } %res_high
}

; CHECK-LABEL: define { <4 x i16>, ptr } @call_intrin_ipu_short4_load_postinc_neg(ptr %a) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    %0 = call { <4 x i16>, ptr } @llvm.colossus.ldstep.v4i16(ptr %a, i32 -81)
; CHECK-NEXT:    ret { <4 x i16>, ptr } %0
; CHECK-NEXT:  }
define { <4 x i16>, ptr } @call_intrin_ipu_short4_load_postinc_neg(ptr %a) {
entry:
  %a.addr = alloca ptr, align 8
  store ptr %a, ptr %a.addr, align 8
  %val = call <4 x i16> @ipu_short4_load_postinc(ptr nonnull %a.addr, i32 -81)
  %res = load ptr, ptr %a.addr, align 8
  %res_low = insertvalue { <4 x i16>, ptr } undef, <4 x i16> %val, 0
  %res_high = insertvalue { <4 x i16>, ptr } %res_low, ptr %res, 1
  ret { <4 x i16>, ptr } %res_high
}

; CHECK-LABEL: define { <4 x i16>, ptr } @call_intrin_ipu_short4_load_postinc_variable(ptr %a, i32 %incr) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    %0 = call { <4 x i16>, ptr } @llvm.colossus.ldstep.v4i16(ptr %a, i32 %incr)
; CHECK-NEXT:    ret { <4 x i16>, ptr } %0
; CHECK-NEXT:  }
define { <4 x i16>, ptr } @call_intrin_ipu_short4_load_postinc_variable(ptr %a, i32 %incr) {
entry:
  %a.addr = alloca ptr, align 8
  store ptr %a, ptr %a.addr, align 8
  %val = call <4 x i16> @ipu_short4_load_postinc(ptr nonnull %a.addr, i32 %incr)
  %res = load ptr, ptr %a.addr, align 8
  %res_low = insertvalue { <4 x i16>, ptr } undef, <4 x i16> %val, 0
  %res_high = insertvalue { <4 x i16>, ptr } %res_low, ptr %res, 1
  ret { <4 x i16>, ptr } %res_high
}

; CHECK-LABEL: define ptr @call_intrin_ipu_short2_store_postinc_zero(ptr %a, <2 x i16> %v) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    %0 = call ptr @llvm.colossus.ststep.v2i16(<2 x i16> %v, ptr %a, i32 0)
; CHECK-NEXT:    ret ptr %0
; CHECK-NEXT:  }
define ptr @call_intrin_ipu_short2_store_postinc_zero(ptr %a, <2 x i16> %v) {
entry:
  %a.addr = alloca ptr, align 8
  store ptr %a, ptr %a.addr, align 8
  call void @ipu_short2_store_postinc(ptr nonnull %a.addr, <2 x i16> %v, i32 0)
  %res = load ptr, ptr %a.addr, align 8
  ret ptr %res
}

; CHECK-LABEL: define ptr @call_intrin_ipu_short2_store_postinc_pos(ptr %a, <2 x i16> %v) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    %0 = call ptr @llvm.colossus.ststep.v2i16(<2 x i16> %v, ptr %a, i32 42)
; CHECK-NEXT:    ret ptr %0
; CHECK-NEXT:  }
define ptr @call_intrin_ipu_short2_store_postinc_pos(ptr %a, <2 x i16> %v) {
entry:
  %a.addr = alloca ptr, align 8
  store ptr %a, ptr %a.addr, align 8
  call void @ipu_short2_store_postinc(ptr nonnull %a.addr, <2 x i16> %v, i32 42)
  %res = load ptr, ptr %a.addr, align 8
  ret ptr %res
}

; CHECK-LABEL: define ptr @call_intrin_ipu_short2_store_postinc_neg(ptr %a, <2 x i16> %v) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    %0 = call ptr @llvm.colossus.ststep.v2i16(<2 x i16> %v, ptr %a, i32 -81)
; CHECK-NEXT:    ret ptr %0
; CHECK-NEXT:  }
define ptr @call_intrin_ipu_short2_store_postinc_neg(ptr %a, <2 x i16> %v) {
entry:
  %a.addr = alloca ptr, align 8
  store ptr %a, ptr %a.addr, align 8
  call void @ipu_short2_store_postinc(ptr nonnull %a.addr, <2 x i16> %v, i32 -81)
  %res = load ptr, ptr %a.addr, align 8
  ret ptr %res
}

; CHECK-LABEL: define ptr @call_intrin_ipu_short2_store_postinc_variable(ptr %a, <2 x i16> %v, i32 %incr) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    %0 = call ptr @llvm.colossus.ststep.v2i16(<2 x i16> %v, ptr %a, i32 %incr)
; CHECK-NEXT:    ret ptr %0
; CHECK-NEXT:  }
define ptr @call_intrin_ipu_short2_store_postinc_variable(ptr %a, <2 x i16> %v, i32 %incr) {
entry:
  %a.addr = alloca ptr, align 8
  store ptr %a, ptr %a.addr, align 8
  call void @ipu_short2_store_postinc(ptr nonnull %a.addr, <2 x i16> %v, i32 %incr)
  %res = load ptr, ptr %a.addr, align 8
  ret ptr %res
}

; CHECK-LABEL: define { <2 x i16>, ptr } @call_intrin_ipu_short2_load_postinc_zero(ptr %a) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    %0 = call { <2 x i16>, ptr } @llvm.colossus.ldstep.v2i16(ptr %a, i32 0)
; CHECK-NEXT:    ret { <2 x i16>, ptr } %0
; CHECK-NEXT:  }
define { <2 x i16>, ptr } @call_intrin_ipu_short2_load_postinc_zero(ptr %a) {
entry:
  %a.addr = alloca ptr, align 8
  store ptr %a, ptr %a.addr, align 8
  %val = call <2 x i16> @ipu_short2_load_postinc(ptr nonnull %a.addr, i32 0)
  %res = load ptr, ptr %a.addr, align 8
  %res_low = insertvalue { <2 x i16>, ptr } undef, <2 x i16> %val, 0
  %res_high = insertvalue { <2 x i16>, ptr } %res_low, ptr %res, 1
  ret { <2 x i16>, ptr } %res_high
}

; CHECK-LABEL: define { <2 x i16>, ptr } @call_intrin_ipu_short2_load_postinc_pos(ptr %a) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    %0 = call { <2 x i16>, ptr } @llvm.colossus.ldstep.v2i16(ptr %a, i32 42)
; CHECK-NEXT:    ret { <2 x i16>, ptr } %0
; CHECK-NEXT:  }
define { <2 x i16>, ptr } @call_intrin_ipu_short2_load_postinc_pos(ptr %a) {
entry:
  %a.addr = alloca ptr, align 8
  store ptr %a, ptr %a.addr, align 8
  %val = call <2 x i16> @ipu_short2_load_postinc(ptr nonnull %a.addr, i32 42)
  %res = load ptr, ptr %a.addr, align 8
  %res_low = insertvalue { <2 x i16>, ptr } undef, <2 x i16> %val, 0
  %res_high = insertvalue { <2 x i16>, ptr } %res_low, ptr %res, 1
  ret { <2 x i16>, ptr } %res_high
}

; CHECK-LABEL: define { <2 x i16>, ptr } @call_intrin_ipu_short2_load_postinc_neg(ptr %a) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    %0 = call { <2 x i16>, ptr } @llvm.colossus.ldstep.v2i16(ptr %a, i32 -81)
; CHECK-NEXT:    ret { <2 x i16>, ptr } %0
; CHECK-NEXT:  }
define { <2 x i16>, ptr } @call_intrin_ipu_short2_load_postinc_neg(ptr %a) {
entry:
  %a.addr = alloca ptr, align 8
  store ptr %a, ptr %a.addr, align 8
  %val = call <2 x i16> @ipu_short2_load_postinc(ptr nonnull %a.addr, i32 -81)
  %res = load ptr, ptr %a.addr, align 8
  %res_low = insertvalue { <2 x i16>, ptr } undef, <2 x i16> %val, 0
  %res_high = insertvalue { <2 x i16>, ptr } %res_low, ptr %res, 1
  ret { <2 x i16>, ptr } %res_high
}

; CHECK-LABEL: define { <2 x i16>, ptr } @call_intrin_ipu_short2_load_postinc_variable(ptr %a, i32 %incr) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    %0 = call { <2 x i16>, ptr } @llvm.colossus.ldstep.v2i16(ptr %a, i32 %incr)
; CHECK-NEXT:    ret { <2 x i16>, ptr } %0
; CHECK-NEXT:  }
define { <2 x i16>, ptr } @call_intrin_ipu_short2_load_postinc_variable(ptr %a, i32 %incr) {
entry:
  %a.addr = alloca ptr, align 8
  store ptr %a, ptr %a.addr, align 8
  %val = call <2 x i16> @ipu_short2_load_postinc(ptr nonnull %a.addr, i32 %incr)
  %res = load ptr, ptr %a.addr, align 8
  %res_low = insertvalue { <2 x i16>, ptr } undef, <2 x i16> %val, 0
  %res_high = insertvalue { <2 x i16>, ptr } %res_low, ptr %res, 1
  ret { <2 x i16>, ptr } %res_high
}

; CHECK-LABEL: define ptr @call_intrin_ipu_short_store_postinc_zero(ptr %a, i16 %v) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    %a.addr = alloca ptr, align 8
; CHECK-NEXT:    store ptr %a, ptr %a.addr, align 8
; CHECK-NEXT:    call void @ipu_short_store_postinc(ptr nonnull %a.addr, i16 %v, i32 0)
; CHECK-NEXT:    %res = load ptr, ptr %a.addr, align 8
; CHECK-NEXT:    ret ptr %res
; CHECK-NEXT:  }
define ptr @call_intrin_ipu_short_store_postinc_zero(ptr %a, i16 %v) {
entry:
  %a.addr = alloca ptr, align 8
  store ptr %a, ptr %a.addr, align 8
  call void @ipu_short_store_postinc(ptr nonnull %a.addr, i16 %v, i32 0)
  %res = load ptr, ptr %a.addr, align 8
  ret ptr %res
}

; CHECK-LABEL: define ptr @call_intrin_ipu_short_store_postinc_pos(ptr %a, i16 %v) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    %a.addr = alloca ptr, align 8
; CHECK-NEXT:    store ptr %a, ptr %a.addr, align 8
; CHECK-NEXT:    call void @ipu_short_store_postinc(ptr nonnull %a.addr, i16 %v, i32 42)
; CHECK-NEXT:    %res = load ptr, ptr %a.addr, align 8
; CHECK-NEXT:    ret ptr %res
; CHECK-NEXT:  }
define ptr @call_intrin_ipu_short_store_postinc_pos(ptr %a, i16 %v) {
entry:
  %a.addr = alloca ptr, align 8
  store ptr %a, ptr %a.addr, align 8
  call void @ipu_short_store_postinc(ptr nonnull %a.addr, i16 %v, i32 42)
  %res = load ptr, ptr %a.addr, align 8
  ret ptr %res
}

; CHECK-LABEL: define ptr @call_intrin_ipu_short_store_postinc_neg(ptr %a, i16 %v) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    %a.addr = alloca ptr, align 8
; CHECK-NEXT:    store ptr %a, ptr %a.addr, align 8
; CHECK-NEXT:    call void @ipu_short_store_postinc(ptr nonnull %a.addr, i16 %v, i32 -81)
; CHECK-NEXT:    %res = load ptr, ptr %a.addr, align 8
; CHECK-NEXT:    ret ptr %res
; CHECK-NEXT:  }
define ptr @call_intrin_ipu_short_store_postinc_neg(ptr %a, i16 %v) {
entry:
  %a.addr = alloca ptr, align 8
  store ptr %a, ptr %a.addr, align 8
  call void @ipu_short_store_postinc(ptr nonnull %a.addr, i16 %v, i32 -81)
  %res = load ptr, ptr %a.addr, align 8
  ret ptr %res
}

; CHECK-LABEL: define ptr @call_intrin_ipu_short_store_postinc_variable(ptr %a, i16 %v, i32 %incr) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    %a.addr = alloca ptr, align 8
; CHECK-NEXT:    store ptr %a, ptr %a.addr, align 8
; CHECK-NEXT:    call void @ipu_short_store_postinc(ptr nonnull %a.addr, i16 %v, i32 %incr)
; CHECK-NEXT:    %res = load ptr, ptr %a.addr, align 8
; CHECK-NEXT:    ret ptr %res
; CHECK-NEXT:  }
define ptr @call_intrin_ipu_short_store_postinc_variable(ptr %a, i16 %v, i32 %incr) {
entry:
  %a.addr = alloca ptr, align 8
  store ptr %a, ptr %a.addr, align 8
  call void @ipu_short_store_postinc(ptr nonnull %a.addr, i16 %v, i32 %incr)
  %res = load ptr, ptr %a.addr, align 8
  ret ptr %res
}

; CHECK-LABEL: define { i16, ptr } @call_intrin_ipu_short_load_postinc_zero(ptr %a) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    %0 = call { i16, ptr } @llvm.colossus.ldstep.i16(ptr %a, i32 0)
; CHECK-NEXT:    ret { i16, ptr } %0
; CHECK-NEXT:  }
define { i16, ptr } @call_intrin_ipu_short_load_postinc_zero(ptr %a) {
entry:
  %a.addr = alloca ptr, align 8
  store ptr %a, ptr %a.addr, align 8
  %val = call i16 @ipu_short_load_postinc(ptr nonnull %a.addr, i32 0)
  %res = load ptr, ptr %a.addr, align 8
  %res_low = insertvalue { i16, ptr } undef, i16 %val, 0
  %res_high = insertvalue { i16, ptr } %res_low, ptr %res, 1
  ret { i16, ptr } %res_high
}

; CHECK-LABEL: define { i16, ptr } @call_intrin_ipu_short_load_postinc_pos(ptr %a) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    %0 = call { i16, ptr } @llvm.colossus.ldstep.i16(ptr %a, i32 42)
; CHECK-NEXT:    ret { i16, ptr } %0
; CHECK-NEXT:  }
define { i16, ptr } @call_intrin_ipu_short_load_postinc_pos(ptr %a) {
entry:
  %a.addr = alloca ptr, align 8
  store ptr %a, ptr %a.addr, align 8
  %val = call i16 @ipu_short_load_postinc(ptr nonnull %a.addr, i32 42)
  %res = load ptr, ptr %a.addr, align 8
  %res_low = insertvalue { i16, ptr } undef, i16 %val, 0
  %res_high = insertvalue { i16, ptr } %res_low, ptr %res, 1
  ret { i16, ptr } %res_high
}

; CHECK-LABEL: define { i16, ptr } @call_intrin_ipu_short_load_postinc_neg(ptr %a) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    %0 = call { i16, ptr } @llvm.colossus.ldstep.i16(ptr %a, i32 -81)
; CHECK-NEXT:    ret { i16, ptr } %0
; CHECK-NEXT:  }
define { i16, ptr } @call_intrin_ipu_short_load_postinc_neg(ptr %a) {
entry:
  %a.addr = alloca ptr, align 8
  store ptr %a, ptr %a.addr, align 8
  %val = call i16 @ipu_short_load_postinc(ptr nonnull %a.addr, i32 -81)
  %res = load ptr, ptr %a.addr, align 8
  %res_low = insertvalue { i16, ptr } undef, i16 %val, 0
  %res_high = insertvalue { i16, ptr } %res_low, ptr %res, 1
  ret { i16, ptr } %res_high
}

; CHECK-LABEL: define { i16, ptr } @call_intrin_ipu_short_load_postinc_variable(ptr %a, i32 %incr) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    %0 = call { i16, ptr } @llvm.colossus.ldstep.i16(ptr %a, i32 %incr)
; CHECK-NEXT:    ret { i16, ptr } %0
; CHECK-NEXT:  }
define { i16, ptr } @call_intrin_ipu_short_load_postinc_variable(ptr %a, i32 %incr) {
entry:
  %a.addr = alloca ptr, align 8
  store ptr %a, ptr %a.addr, align 8
  %val = call i16 @ipu_short_load_postinc(ptr nonnull %a.addr, i32 %incr)
  %res = load ptr, ptr %a.addr, align 8
  %res_low = insertvalue { i16, ptr } undef, i16 %val, 0
  %res_high = insertvalue { i16, ptr } %res_low, ptr %res, 1
  ret { i16, ptr } %res_high
}

; CHECK-LABEL: define ptr @call_intrin_ipu_int2_store_postinc_zero(ptr %a, <2 x i32> %v) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    %0 = call ptr @llvm.colossus.ststep.v2i32(<2 x i32> %v, ptr %a, i32 0)
; CHECK-NEXT:    ret ptr %0
; CHECK-NEXT:  }
define ptr @call_intrin_ipu_int2_store_postinc_zero(ptr %a, <2 x i32> %v) {
entry:
  %a.addr = alloca ptr, align 8
  store ptr %a, ptr %a.addr, align 8
  call void @ipu_int2_store_postinc(ptr nonnull %a.addr, <2 x i32> %v, i32 0)
  %res = load ptr, ptr %a.addr, align 8
  ret ptr %res
}

; CHECK-LABEL: define ptr @call_intrin_ipu_int2_store_postinc_pos(ptr %a, <2 x i32> %v) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    %0 = call ptr @llvm.colossus.ststep.v2i32(<2 x i32> %v, ptr %a, i32 42)
; CHECK-NEXT:    ret ptr %0
; CHECK-NEXT:  }
define ptr @call_intrin_ipu_int2_store_postinc_pos(ptr %a, <2 x i32> %v) {
entry:
  %a.addr = alloca ptr, align 8
  store ptr %a, ptr %a.addr, align 8
  call void @ipu_int2_store_postinc(ptr nonnull %a.addr, <2 x i32> %v, i32 42)
  %res = load ptr, ptr %a.addr, align 8
  ret ptr %res
}

; CHECK-LABEL: define ptr @call_intrin_ipu_int2_store_postinc_neg(ptr %a, <2 x i32> %v) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    %0 = call ptr @llvm.colossus.ststep.v2i32(<2 x i32> %v, ptr %a, i32 -81)
; CHECK-NEXT:    ret ptr %0
; CHECK-NEXT:  }
define ptr @call_intrin_ipu_int2_store_postinc_neg(ptr %a, <2 x i32> %v) {
entry:
  %a.addr = alloca ptr, align 8
  store ptr %a, ptr %a.addr, align 8
  call void @ipu_int2_store_postinc(ptr nonnull %a.addr, <2 x i32> %v, i32 -81)
  %res = load ptr, ptr %a.addr, align 8
  ret ptr %res
}

; CHECK-LABEL: define ptr @call_intrin_ipu_int2_store_postinc_variable(ptr %a, <2 x i32> %v, i32 %incr) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    %0 = call ptr @llvm.colossus.ststep.v2i32(<2 x i32> %v, ptr %a, i32 %incr)
; CHECK-NEXT:    ret ptr %0
; CHECK-NEXT:  }
define ptr @call_intrin_ipu_int2_store_postinc_variable(ptr %a, <2 x i32> %v, i32 %incr) {
entry:
  %a.addr = alloca ptr, align 8
  store ptr %a, ptr %a.addr, align 8
  call void @ipu_int2_store_postinc(ptr nonnull %a.addr, <2 x i32> %v, i32 %incr)
  %res = load ptr, ptr %a.addr, align 8
  ret ptr %res
}

; CHECK-LABEL: define { <2 x i32>, ptr } @call_intrin_ipu_int2_load_postinc_zero(ptr %a) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    %0 = call { <2 x i32>, ptr } @llvm.colossus.ldstep.v2i32(ptr %a, i32 0)
; CHECK-NEXT:    ret { <2 x i32>, ptr } %0
; CHECK-NEXT:  }
define { <2 x i32>, ptr } @call_intrin_ipu_int2_load_postinc_zero(ptr %a) {
entry:
  %a.addr = alloca ptr, align 8
  store ptr %a, ptr %a.addr, align 8
  %val = call <2 x i32> @ipu_int2_load_postinc(ptr nonnull %a.addr, i32 0)
  %res = load ptr, ptr %a.addr, align 8
  %res_low = insertvalue { <2 x i32>, ptr } undef, <2 x i32> %val, 0
  %res_high = insertvalue { <2 x i32>, ptr } %res_low, ptr %res, 1
  ret { <2 x i32>, ptr } %res_high
}

; CHECK-LABEL: define { <2 x i32>, ptr } @call_intrin_ipu_int2_load_postinc_pos(ptr %a) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    %0 = call { <2 x i32>, ptr } @llvm.colossus.ldstep.v2i32(ptr %a, i32 42)
; CHECK-NEXT:    ret { <2 x i32>, ptr } %0
; CHECK-NEXT:  }
define { <2 x i32>, ptr } @call_intrin_ipu_int2_load_postinc_pos(ptr %a) {
entry:
  %a.addr = alloca ptr, align 8
  store ptr %a, ptr %a.addr, align 8
  %val = call <2 x i32> @ipu_int2_load_postinc(ptr nonnull %a.addr, i32 42)
  %res = load ptr, ptr %a.addr, align 8
  %res_low = insertvalue { <2 x i32>, ptr } undef, <2 x i32> %val, 0
  %res_high = insertvalue { <2 x i32>, ptr } %res_low, ptr %res, 1
  ret { <2 x i32>, ptr } %res_high
}

; CHECK-LABEL: define { <2 x i32>, ptr } @call_intrin_ipu_int2_load_postinc_neg(ptr %a) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    %0 = call { <2 x i32>, ptr } @llvm.colossus.ldstep.v2i32(ptr %a, i32 -81)
; CHECK-NEXT:    ret { <2 x i32>, ptr } %0
; CHECK-NEXT:  }
define { <2 x i32>, ptr } @call_intrin_ipu_int2_load_postinc_neg(ptr %a) {
entry:
  %a.addr = alloca ptr, align 8
  store ptr %a, ptr %a.addr, align 8
  %val = call <2 x i32> @ipu_int2_load_postinc(ptr nonnull %a.addr, i32 -81)
  %res = load ptr, ptr %a.addr, align 8
  %res_low = insertvalue { <2 x i32>, ptr } undef, <2 x i32> %val, 0
  %res_high = insertvalue { <2 x i32>, ptr } %res_low, ptr %res, 1
  ret { <2 x i32>, ptr } %res_high
}

; CHECK-LABEL: define { <2 x i32>, ptr } @call_intrin_ipu_int2_load_postinc_variable(ptr %a, i32 %incr) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    %0 = call { <2 x i32>, ptr } @llvm.colossus.ldstep.v2i32(ptr %a, i32 %incr)
; CHECK-NEXT:    ret { <2 x i32>, ptr } %0
; CHECK-NEXT:  }
define { <2 x i32>, ptr } @call_intrin_ipu_int2_load_postinc_variable(ptr %a, i32 %incr) {
entry:
  %a.addr = alloca ptr, align 8
  store ptr %a, ptr %a.addr, align 8
  %val = call <2 x i32> @ipu_int2_load_postinc(ptr nonnull %a.addr, i32 %incr)
  %res = load ptr, ptr %a.addr, align 8
  %res_low = insertvalue { <2 x i32>, ptr } undef, <2 x i32> %val, 0
  %res_high = insertvalue { <2 x i32>, ptr } %res_low, ptr %res, 1
  ret { <2 x i32>, ptr } %res_high
}

; CHECK-LABEL: define ptr @call_intrin_ipu_int_store_postinc_zero(ptr %a, i32 %v) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    %0 = call ptr @llvm.colossus.ststep.i32(i32 %v, ptr %a, i32 0)
; CHECK-NEXT:    ret ptr %0
; CHECK-NEXT:  }
define ptr @call_intrin_ipu_int_store_postinc_zero(ptr %a, i32 %v) {
entry:
  %a.addr = alloca ptr, align 8
  store ptr %a, ptr %a.addr, align 8
  call void @ipu_int_store_postinc(ptr nonnull %a.addr, i32 %v, i32 0)
  %res = load ptr, ptr %a.addr, align 8
  ret ptr %res
}

; CHECK-LABEL: define ptr @call_intrin_ipu_int_store_postinc_pos(ptr %a, i32 %v) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    %0 = call ptr @llvm.colossus.ststep.i32(i32 %v, ptr %a, i32 42)
; CHECK-NEXT:    ret ptr %0
; CHECK-NEXT:  }
define ptr @call_intrin_ipu_int_store_postinc_pos(ptr %a, i32 %v) {
entry:
  %a.addr = alloca ptr, align 8
  store ptr %a, ptr %a.addr, align 8
  call void @ipu_int_store_postinc(ptr nonnull %a.addr, i32 %v, i32 42)
  %res = load ptr, ptr %a.addr, align 8
  ret ptr %res
}

; CHECK-LABEL: define ptr @call_intrin_ipu_int_store_postinc_neg(ptr %a, i32 %v) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    %0 = call ptr @llvm.colossus.ststep.i32(i32 %v, ptr %a, i32 -81)
; CHECK-NEXT:    ret ptr %0
; CHECK-NEXT:  }
define ptr @call_intrin_ipu_int_store_postinc_neg(ptr %a, i32 %v) {
entry:
  %a.addr = alloca ptr, align 8
  store ptr %a, ptr %a.addr, align 8
  call void @ipu_int_store_postinc(ptr nonnull %a.addr, i32 %v, i32 -81)
  %res = load ptr, ptr %a.addr, align 8
  ret ptr %res
}

; CHECK-LABEL: define ptr @call_intrin_ipu_int_store_postinc_variable(ptr %a, i32 %v, i32 %incr) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    %0 = call ptr @llvm.colossus.ststep.i32(i32 %v, ptr %a, i32 %incr)
; CHECK-NEXT:    ret ptr %0
; CHECK-NEXT:  }
define ptr @call_intrin_ipu_int_store_postinc_variable(ptr %a, i32 %v, i32 %incr) {
entry:
  %a.addr = alloca ptr, align 8
  store ptr %a, ptr %a.addr, align 8
  call void @ipu_int_store_postinc(ptr nonnull %a.addr, i32 %v, i32 %incr)
  %res = load ptr, ptr %a.addr, align 8
  ret ptr %res
}

; CHECK-LABEL: define { i32, ptr } @call_intrin_ipu_int_load_postinc_zero(ptr %a) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    %0 = call { i32, ptr } @llvm.colossus.ldstep.i32(ptr %a, i32 0)
; CHECK-NEXT:    ret { i32, ptr } %0
; CHECK-NEXT:  }
define { i32, ptr } @call_intrin_ipu_int_load_postinc_zero(ptr %a) {
entry:
  %a.addr = alloca ptr, align 8
  store ptr %a, ptr %a.addr, align 8
  %val = call i32 @ipu_int_load_postinc(ptr nonnull %a.addr, i32 0)
  %res = load ptr, ptr %a.addr, align 8
  %res_low = insertvalue { i32, ptr } undef, i32 %val, 0
  %res_high = insertvalue { i32, ptr } %res_low, ptr %res, 1
  ret { i32, ptr } %res_high
}

; CHECK-LABEL: define { i32, ptr } @call_intrin_ipu_int_load_postinc_pos(ptr %a) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    %0 = call { i32, ptr } @llvm.colossus.ldstep.i32(ptr %a, i32 42)
; CHECK-NEXT:    ret { i32, ptr } %0
; CHECK-NEXT:  }
define { i32, ptr } @call_intrin_ipu_int_load_postinc_pos(ptr %a) {
entry:
  %a.addr = alloca ptr, align 8
  store ptr %a, ptr %a.addr, align 8
  %val = call i32 @ipu_int_load_postinc(ptr nonnull %a.addr, i32 42)
  %res = load ptr, ptr %a.addr, align 8
  %res_low = insertvalue { i32, ptr } undef, i32 %val, 0
  %res_high = insertvalue { i32, ptr } %res_low, ptr %res, 1
  ret { i32, ptr } %res_high
}

; CHECK-LABEL: define { i32, ptr } @call_intrin_ipu_int_load_postinc_neg(ptr %a) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    %0 = call { i32, ptr } @llvm.colossus.ldstep.i32(ptr %a, i32 -81)
; CHECK-NEXT:    ret { i32, ptr } %0
; CHECK-NEXT:  }
define { i32, ptr } @call_intrin_ipu_int_load_postinc_neg(ptr %a) {
entry:
  %a.addr = alloca ptr, align 8
  store ptr %a, ptr %a.addr, align 8
  %val = call i32 @ipu_int_load_postinc(ptr nonnull %a.addr, i32 -81)
  %res = load ptr, ptr %a.addr, align 8
  %res_low = insertvalue { i32, ptr } undef, i32 %val, 0
  %res_high = insertvalue { i32, ptr } %res_low, ptr %res, 1
  ret { i32, ptr } %res_high
}

; CHECK-LABEL: define { i32, ptr } @call_intrin_ipu_int_load_postinc_variable(ptr %a, i32 %incr) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    %0 = call { i32, ptr } @llvm.colossus.ldstep.i32(ptr %a, i32 %incr)
; CHECK-NEXT:    ret { i32, ptr } %0
; CHECK-NEXT:  }
define { i32, ptr } @call_intrin_ipu_int_load_postinc_variable(ptr %a, i32 %incr) {
entry:
  %a.addr = alloca ptr, align 8
  store ptr %a, ptr %a.addr, align 8
  %val = call i32 @ipu_int_load_postinc(ptr nonnull %a.addr, i32 %incr)
  %res = load ptr, ptr %a.addr, align 8
  %res_low = insertvalue { i32, ptr } undef, i32 %val, 0
  %res_high = insertvalue { i32, ptr } %res_low, ptr %res, 1
  ret { i32, ptr } %res_high
}

; CHECK-LABEL: define ptr @call_intrin_ipu_char_store_postinc_zero(ptr %a, i8 %v) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    %a.addr = alloca ptr, align 8
; CHECK-NEXT:    store ptr %a, ptr %a.addr, align 8
; CHECK-NEXT:    call void @ipu_char_store_postinc(ptr nonnull %a.addr, i8 %v, i32 0)
; CHECK-NEXT:    %res = load ptr, ptr %a.addr, align 8
; CHECK-NEXT:    ret ptr %res
; CHECK-NEXT:  }
define ptr @call_intrin_ipu_char_store_postinc_zero(ptr %a, i8 %v) {
entry:
  %a.addr = alloca ptr, align 8
  store ptr %a, ptr %a.addr, align 8
  call void @ipu_char_store_postinc(ptr nonnull %a.addr, i8 %v, i32 0)
  %res = load ptr, ptr %a.addr, align 8
  ret ptr %res
}

; CHECK-LABEL: define ptr @call_intrin_ipu_char_store_postinc_pos(ptr %a, i8 %v) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    %a.addr = alloca ptr, align 8
; CHECK-NEXT:    store ptr %a, ptr %a.addr, align 8
; CHECK-NEXT:    call void @ipu_char_store_postinc(ptr nonnull %a.addr, i8 %v, i32 42)
; CHECK-NEXT:    %res = load ptr, ptr %a.addr, align 8
; CHECK-NEXT:    ret ptr %res
; CHECK-NEXT:  }
define ptr @call_intrin_ipu_char_store_postinc_pos(ptr %a, i8 %v) {
entry:
  %a.addr = alloca ptr, align 8
  store ptr %a, ptr %a.addr, align 8
  call void @ipu_char_store_postinc(ptr nonnull %a.addr, i8 %v, i32 42)
  %res = load ptr, ptr %a.addr, align 8
  ret ptr %res
}

; CHECK-LABEL: define ptr @call_intrin_ipu_char_store_postinc_neg(ptr %a, i8 %v) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    %a.addr = alloca ptr, align 8
; CHECK-NEXT:    store ptr %a, ptr %a.addr, align 8
; CHECK-NEXT:    call void @ipu_char_store_postinc(ptr nonnull %a.addr, i8 %v, i32 -81)
; CHECK-NEXT:    %res = load ptr, ptr %a.addr, align 8
; CHECK-NEXT:    ret ptr %res
; CHECK-NEXT:  }
define ptr @call_intrin_ipu_char_store_postinc_neg(ptr %a, i8 %v) {
entry:
  %a.addr = alloca ptr, align 8
  store ptr %a, ptr %a.addr, align 8
  call void @ipu_char_store_postinc(ptr nonnull %a.addr, i8 %v, i32 -81)
  %res = load ptr, ptr %a.addr, align 8
  ret ptr %res
}

; CHECK-LABEL: define ptr @call_intrin_ipu_char_store_postinc_variable(ptr %a, i8 %v, i32 %incr) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    %a.addr = alloca ptr, align 8
; CHECK-NEXT:    store ptr %a, ptr %a.addr, align 8
; CHECK-NEXT:    call void @ipu_char_store_postinc(ptr nonnull %a.addr, i8 %v, i32 %incr)
; CHECK-NEXT:    %res = load ptr, ptr %a.addr, align 8
; CHECK-NEXT:    ret ptr %res
; CHECK-NEXT:  }
define ptr @call_intrin_ipu_char_store_postinc_variable(ptr %a, i8 %v, i32 %incr) {
entry:
  %a.addr = alloca ptr, align 8
  store ptr %a, ptr %a.addr, align 8
  call void @ipu_char_store_postinc(ptr nonnull %a.addr, i8 %v, i32 %incr)
  %res = load ptr, ptr %a.addr, align 8
  ret ptr %res
}

; CHECK-LABEL: define { i8, ptr } @call_intrin_ipu_char_load_postinc_zero(ptr %a) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    %0 = call { i8, ptr } @llvm.colossus.ldstep.i8(ptr %a, i32 0)
; CHECK-NEXT:    ret { i8, ptr } %0
; CHECK-NEXT:  }
define { i8, ptr } @call_intrin_ipu_char_load_postinc_zero(ptr %a) {
entry:
  %a.addr = alloca ptr, align 8
  store ptr %a, ptr %a.addr, align 8
  %val = call i8 @ipu_char_load_postinc(ptr nonnull %a.addr, i32 0)
  %res = load ptr, ptr %a.addr, align 8
  %res_low = insertvalue { i8, ptr } undef, i8 %val, 0
  %res_high = insertvalue { i8, ptr } %res_low, ptr %res, 1
  ret { i8, ptr } %res_high
}

; CHECK-LABEL: define { i8, ptr } @call_intrin_ipu_char_load_postinc_pos(ptr %a) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    %0 = call { i8, ptr } @llvm.colossus.ldstep.i8(ptr %a, i32 42)
; CHECK-NEXT:    ret { i8, ptr } %0
; CHECK-NEXT:  }
define { i8, ptr } @call_intrin_ipu_char_load_postinc_pos(ptr %a) {
entry:
  %a.addr = alloca ptr, align 8
  store ptr %a, ptr %a.addr, align 8
  %val = call i8 @ipu_char_load_postinc(ptr nonnull %a.addr, i32 42)
  %res = load ptr, ptr %a.addr, align 8
  %res_low = insertvalue { i8, ptr } undef, i8 %val, 0
  %res_high = insertvalue { i8, ptr } %res_low, ptr %res, 1
  ret { i8, ptr } %res_high
}

; CHECK-LABEL: define { i8, ptr } @call_intrin_ipu_char_load_postinc_neg(ptr %a) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    %0 = call { i8, ptr } @llvm.colossus.ldstep.i8(ptr %a, i32 -81)
; CHECK-NEXT:    ret { i8, ptr } %0
; CHECK-NEXT:  }
define { i8, ptr } @call_intrin_ipu_char_load_postinc_neg(ptr %a) {
entry:
  %a.addr = alloca ptr, align 8
  store ptr %a, ptr %a.addr, align 8
  %val = call i8 @ipu_char_load_postinc(ptr nonnull %a.addr, i32 -81)
  %res = load ptr, ptr %a.addr, align 8
  %res_low = insertvalue { i8, ptr } undef, i8 %val, 0
  %res_high = insertvalue { i8, ptr } %res_low, ptr %res, 1
  ret { i8, ptr } %res_high
}

; CHECK-LABEL: define { i8, ptr } @call_intrin_ipu_char_load_postinc_variable(ptr %a, i32 %incr) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    %0 = call { i8, ptr } @llvm.colossus.ldstep.i8(ptr %a, i32 %incr)
; CHECK-NEXT:    ret { i8, ptr } %0
; CHECK-NEXT:  }
define { i8, ptr } @call_intrin_ipu_char_load_postinc_variable(ptr %a, i32 %incr) {
entry:
  %a.addr = alloca ptr, align 8
  store ptr %a, ptr %a.addr, align 8
  %val = call i8 @ipu_char_load_postinc(ptr nonnull %a.addr, i32 %incr)
  %res = load ptr, ptr %a.addr, align 8
  %res_low = insertvalue { i8, ptr } undef, i8 %val, 0
  %res_high = insertvalue { i8, ptr } %res_low, ptr %res, 1
  ret { i8, ptr } %res_high
}
