; RUN: opt < %s -colossus-libmcalls -disable-colossus-libmcalls=false -S | FileCheck %s -check-prefix=ENABLE
; RUN: opt < %s -colossus-libmcalls -disable-colossus-libmcalls=true -S | FileCheck %s -check-prefix=DISABLE

declare float @sinf(float %x0)
; CHECK-LABEL: define float @call_sinf(float %x0) {
; ENABLE:        %call = call float @llvm.sin.f32(float %x0)
; DISABLE:       %call = call float @sinf(float %x0)
; CHECK:         ret float %call
; CHECK:       }
define float @call_sinf(float %x0) {
  %call = call float @sinf(float %x0)
  ret float %call
}

declare <4 x half> @half4_pow(<4 x half> %x0, <4 x half> %x1)
; CHECK-LABEL: define <4 x half> @call_half4_pow(<4 x half> %x0, <4 x half> %x1) {
; ENABLE:        %call = call <4 x half> @llvm.pow.v4f16(<4 x half> %x0, <4 x half> %x1)
; DISABLE:       %call = call <4 x half> @half4_pow(<4 x half> %x0, <4 x half> %x1)
; CHECK:         ret <4 x half> %call
; CHECK:       }
define <4 x half> @call_half4_pow(<4 x half> %x0, <4 x half> %x1) {
  %call = call <4 x half> @half4_pow(<4 x half> %x0, <4 x half> %x1)
  ret <4 x half> %call
}
