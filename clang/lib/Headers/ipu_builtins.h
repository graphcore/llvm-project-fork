//===--- ipu_builtins.h ------ Declare IPU builtins -----------------------===//
//    Copyright (c) 2023 Graphcore Ltd. All Rights Reserved.
//     Licensed under the Apache License, Version 2.0 (the "License");
//     you may not use this file except in compliance with the License.
//     You may obtain a copy of the License at
//
//        http://www.apache.org/licenses/LICENSE-2.0
//
//     Unless required by applicable law or agreed to in writing, software
//     distributed under the License is distributed on an "AS IS" BASIS,
//     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//     See the License for the specific language governing permissions and
//     limitations under the License.
// --- LLVM Exceptions to the Apache 2.0 License ----
//
// As an exception, if, as a result of your compiling your source code, portions
// of this Software are embedded into an Object form of such source code, you
// may redistribute such embedded portions in such Object form without complying
// with the conditions of Sections 4(a), 4(b) and 4(d) of the License.
//
// In addition, if you combine or link compiled forms of this Software with
// software that is licensed under the GPLv2 ("Combined Software") and if a
// court of competent jurisdiction determines that the patent provision (Section
// 3), the indemnity provision (Section 9) or other Section of the License
// conflicts with the conditions of the GPLv2, you may retroactively and
// prospectively choose to deem waived or otherwise exclude such Section(s) of
// the License, but only in their entirety and only with respect to the Combined
// Software.
//
//===----------------------------------------------------------------------===//

#ifndef __IPU_BUILTINS_H
#define __IPU_BUILTINS_H

#include <ipudef.h>

#ifdef __cplusplus
extern "C" {
#endif

static __inline__
    __attribute__((__overloadable__,
                   clang_builtin_alias(__builtin_ipu_uputf)))
    void __builtin_ipu_uput(float, int);

static __inline__
    __attribute__((__overloadable__,
                   clang_builtin_alias(__builtin_ipu_uput)))
    void __builtin_ipu_uput(unsigned, int);

static __inline__ __attribute__((__overloadable__,
                                 clang_builtin_alias(__builtin_ipu_uput))) void
__builtin_ipu_uput(int, int);

static __inline__
    __attribute__((__overloadable__,
                   clang_builtin_alias(__builtin_ipu_isfinite_f32))) int
    __builtin_ipu_isfinite(float);
static __inline__
    __attribute__((__overloadable__,
                   clang_builtin_alias(__builtin_ipu_isfinite_v2f16)))
    short2 __builtin_ipu_isfinite(half2);
static __inline__
    __attribute__((__overloadable__,
                   clang_builtin_alias(__builtin_ipu_isfinite_v2f32)))
    int2 __builtin_ipu_isfinite(float2);
static __inline__
    __attribute__((__overloadable__,
                   clang_builtin_alias(__builtin_ipu_isfinite_v4f16)))
    short4 __builtin_ipu_isfinite(half4);

static __inline__
    __attribute__((__overloadable__,
                   clang_builtin_alias(__builtin_ipu_isinf_f32))) int
    __builtin_ipu_isinf(float);
static __inline__
    __attribute__((__overloadable__,
                   clang_builtin_alias(__builtin_ipu_isinf_v2f16)))
    short2 __builtin_ipu_isinf(half2);
static __inline__
    __attribute__((__overloadable__,
                   clang_builtin_alias(__builtin_ipu_isinf_v2f32)))
    int2 __builtin_ipu_isinf(float2);
static __inline__
    __attribute__((__overloadable__,
                   clang_builtin_alias(__builtin_ipu_isinf_v4f16)))
    short4 __builtin_ipu_isinf(half4);

static __inline__
    __attribute__((__overloadable__,
                   clang_builtin_alias(__builtin_ipu_isnan_f32))) int
    __builtin_ipu_isnan(float);
static __inline__
    __attribute__((__overloadable__,
                   clang_builtin_alias(__builtin_ipu_isnan_v2f16)))
    short2 __builtin_ipu_isnan(half2);
static __inline__
    __attribute__((__overloadable__,
                   clang_builtin_alias(__builtin_ipu_isnan_v2f32)))
    int2 __builtin_ipu_isnan(float2);
static __inline__
    __attribute__((__overloadable__,
                   clang_builtin_alias(__builtin_ipu_isnan_v4f16)))
    short4 __builtin_ipu_isnan(half4);

static __inline__ __attribute__((__overloadable__,
                                 clang_builtin_alias(__builtin_ipu_or_i32))) int
__builtin_ipu_or(unsigned, int);

static __inline__
    __attribute__((__overloadable__,
                   clang_builtin_alias(__builtin_ipu_or_i32)))
    int __builtin_ipu_or(int, int);

static __inline__
    __attribute__((__overloadable__,
                   clang_builtin_alias(__builtin_ipu_or_f32)))
    float __builtin_ipu_or(float, float);

static __inline__
    __attribute__((__overloadable__,
                   clang_builtin_alias(__builtin_ipu_or_v2f32)))
    float2 __builtin_ipu_or(float2, float2);

static __inline__
    __attribute__((__overloadable__,
                   clang_builtin_alias(__builtin_ipu_not_f32)))
    float __builtin_ipu_not(float);

static __inline__
    __attribute__((__overloadable__,
                   clang_builtin_alias(__builtin_ipu_not_v2f32)))
    float2 __builtin_ipu_not(float2);

static __inline__
    __attribute__((__overloadable__,
                   clang_builtin_alias(__builtin_ipu_f16v2absadd)))
    half2 __builtin_ipu_absadd(half2, half2);

static __inline__
    __attribute__((__overloadable__,
                   clang_builtin_alias(__builtin_ipu_f16v4absadd)))
    half4 __builtin_ipu_absadd(half4, half4);

static __inline__
    __attribute__((__overloadable__,
                   clang_builtin_alias(__builtin_ipu_f32v2absadd)))
    float2 __builtin_ipu_absadd(float2, float2);

static __inline__
    __attribute__((__overloadable__,
                   clang_builtin_alias(__builtin_ipu_f32absadd)))
    float __builtin_ipu_absadd(float, float);

static __inline__
    __attribute__((__overloadable__,
                   clang_builtin_alias(__builtin_ipu_f16v2absmax)))
    half2 __builtin_ipu_absmax(half2, half2);

static __inline__
    __attribute__((__overloadable__,
                   clang_builtin_alias(__builtin_ipu_f16v4absmax)))
    half4 __builtin_ipu_absmax(half4, half4);

static __inline__
    __attribute__((__overloadable__,
                   clang_builtin_alias(__builtin_ipu_f32v2absmax)))
    float2 __builtin_ipu_absmax(float2, float2);

static __inline__
    __attribute__((__overloadable__,
                   clang_builtin_alias(__builtin_ipu_f32absmax)))
    float __builtin_ipu_absmax(float, float);

static __inline__
    __attribute__((__overloadable__,
                   clang_builtin_alias(__builtin_ipu_f16v2max)))
    half2 __builtin_ipu_max(half2, half2);

static __inline__
    __attribute__((__overloadable__,
                   clang_builtin_alias(__builtin_ipu_f16v4max)))
    half4 __builtin_ipu_max(half4, half4);

static __inline__
    __attribute__((__overloadable__,
                   clang_builtin_alias(__builtin_ipu_f32v2max)))
    float2 __builtin_ipu_max(float2, float2);

static __inline__
    __attribute__((__overloadable__,
                   clang_builtin_alias(__builtin_ipu_f32max)))
    float __builtin_ipu_max(float, float);

static __inline__
    __attribute__((__overloadable__,
                   clang_builtin_alias(__builtin_ipu_f16v2min)))
    half2 __builtin_ipu_min(half2, half2);

static __inline__
    __attribute__((__overloadable__,
                   clang_builtin_alias(__builtin_ipu_f16v4min)))
    half4 __builtin_ipu_min(half4, half4);

static __inline__
    __attribute__((__overloadable__,
                   clang_builtin_alias(__builtin_ipu_f32v2min)))
    float2 __builtin_ipu_min(float2, float2);

static __inline__
    __attribute__((__overloadable__,
                   clang_builtin_alias(__builtin_ipu_f32min)))
    float __builtin_ipu_min(float, float);

static __inline__
    __attribute__((__overloadable__,
                   clang_builtin_alias(__builtin_ipu_and_i32))) int
    __builtin_ipu_and(unsigned, int);

static __inline__
    __attribute__((__overloadable__,
                   clang_builtin_alias(__builtin_ipu_and_i32)))
    int __builtin_ipu_and(int, int);

static __inline__
    __attribute__((__overloadable__,
                   clang_builtin_alias(__builtin_ipu_and_f32)))
    float __builtin_ipu_and(float, float);

static __inline__
    __attribute__((__overloadable__,
                   clang_builtin_alias(__builtin_ipu_and_v2f32)))
    float2 __builtin_ipu_and(float2, float2);

static __inline__
    __attribute__((__overloadable__,
                   clang_builtin_alias(__builtin_ipu_andc_i32))) int
    __builtin_ipu_andc(unsigned, int);

static __inline__
    __attribute__((__overloadable__,
                   clang_builtin_alias(__builtin_ipu_andc_i32)))
    int __builtin_ipu_andc(int, int);

static __inline__
    __attribute__((__overloadable__,
                   clang_builtin_alias(__builtin_ipu_andc_f32)))
    float __builtin_ipu_andc(float, float);

static __inline__
    __attribute__((__overloadable__,
                   clang_builtin_alias(__builtin_ipu_andc_v2f32)))
    float2 __builtin_ipu_andc(float2, float2);

static __inline__
    __attribute__((__overloadable__,
                   clang_builtin_alias(__builtin_ipu_f16v2clamp)))
    half2 __builtin_ipu_clamp(half2, half2);

static __inline__
    __attribute__((__overloadable__,
                   clang_builtin_alias(__builtin_ipu_f16v4clamp)))
    half4 __builtin_ipu_clamp(half4, half2);

static __inline__
    __attribute__((__overloadable__,
                   clang_builtin_alias(__builtin_ipu_f32v2clamp)))
    float2 __builtin_ipu_clamp(float2, float2);

static __inline__
    __attribute__((__overloadable__,
                   clang_builtin_alias(__builtin_ipu_f32clamp)))
    float __builtin_ipu_clamp(float, float2);

static __inline__
    __attribute__((__overloadable__,
                   clang_builtin_alias(__builtin_ipu_f16v2cmac)))
    void __builtin_ipu_cmac(half2, half2);

static __inline__
    __attribute__((__overloadable__,
                   clang_builtin_alias(__builtin_ipu_f16v4cmac)))
    void __builtin_ipu_cmac(half4, half4);

static __inline__
    __attribute__((__overloadable__,
                   clang_builtin_alias(__builtin_ipu_f16v2class)))
    short2 __builtin_ipu_class(half2);

static __inline__
    __attribute__((__overloadable__,
                   clang_builtin_alias(__builtin_ipu_f16v4class)))
    short4 __builtin_ipu_class(half4);

static __inline__
    __attribute__((__overloadable__,
                   clang_builtin_alias(__builtin_ipu_f32v2class)))
    short2 __builtin_ipu_class(float2);

static __inline__
    __attribute__((__overloadable__,
                   clang_builtin_alias(__builtin_ipu_f32class)))
    int __builtin_ipu_class(float);

static __inline__
    __attribute__((__overloadable__,
                   clang_builtin_alias(__builtin_ipu_f16v2cmpeq)))
    half2 __builtin_ipu_cmpeq(half2, half2);

static __inline__
    __attribute__((__overloadable__,
                   clang_builtin_alias(__builtin_ipu_f16v4cmpeq)))
    half4 __builtin_ipu_cmpeq(half4, half4);

static __inline__
    __attribute__((__overloadable__,
                   clang_builtin_alias(__builtin_ipu_f32v2cmpeq)))
    float2 __builtin_ipu_cmpeq(float2, float2);

static __inline__
    __attribute__((__overloadable__,
                   clang_builtin_alias(__builtin_ipu_f32cmpeq)))
    float __builtin_ipu_cmpeq(float, float);

static __inline__
    __attribute__((__overloadable__,
                   clang_builtin_alias(__builtin_ipu_f16v2cmpge)))
    half2 __builtin_ipu_cmpge(half2, half2);

static __inline__
    __attribute__((__overloadable__,
                   clang_builtin_alias(__builtin_ipu_f16v4cmpge)))
    half4 __builtin_ipu_cmpge(half4, half4);

static __inline__
    __attribute__((__overloadable__,
                   clang_builtin_alias(__builtin_ipu_f32v2cmpge)))
    float2 __builtin_ipu_cmpge(float2, float2);

static __inline__
    __attribute__((__overloadable__,
                   clang_builtin_alias(__builtin_ipu_f32cmpge)))
    float __builtin_ipu_cmpge(float, float);

static __inline__
    __attribute__((__overloadable__,
                   clang_builtin_alias(__builtin_ipu_f16v2cmpgt)))
    half2 __builtin_ipu_cmpgt(half2, half2);

static __inline__
    __attribute__((__overloadable__,
                   clang_builtin_alias(__builtin_ipu_f16v4cmpgt)))
    half4 __builtin_ipu_cmpgt(half4, half4);

static __inline__
    __attribute__((__overloadable__,
                   clang_builtin_alias(__builtin_ipu_f32v2cmpgt)))
    float2 __builtin_ipu_cmpgt(float2, float2);

static __inline__
    __attribute__((__overloadable__,
                   clang_builtin_alias(__builtin_ipu_f32cmpgt)))
    float __builtin_ipu_cmpgt(float, float);

static __inline__
    __attribute__((__overloadable__,
                   clang_builtin_alias(__builtin_ipu_f16v2cmple)))
    half2 __builtin_ipu_cmple(half2, half2);

static __inline__
    __attribute__((__overloadable__,
                   clang_builtin_alias(__builtin_ipu_f16v4cmple)))
    half4 __builtin_ipu_cmple(half4, half4);

static __inline__
    __attribute__((__overloadable__,
                   clang_builtin_alias(__builtin_ipu_f32v2cmple)))
    float2 __builtin_ipu_cmple(float2, float2);

static __inline__
    __attribute__((__overloadable__,
                   clang_builtin_alias(__builtin_ipu_f32cmple)))
    float __builtin_ipu_cmple(float, float);

static __inline__
    __attribute__((__overloadable__,
                   clang_builtin_alias(__builtin_ipu_f16v2cmplt)))
    half2 __builtin_ipu_cmplt(half2, half2);

static __inline__
    __attribute__((__overloadable__,
                   clang_builtin_alias(__builtin_ipu_f16v4cmplt)))
    half4 __builtin_ipu_cmplt(half4, half4);

static __inline__
    __attribute__((__overloadable__,
                   clang_builtin_alias(__builtin_ipu_f32v2cmplt)))
    float2 __builtin_ipu_cmplt(float2, float2);

static __inline__
    __attribute__((__overloadable__,
                   clang_builtin_alias(__builtin_ipu_f32cmplt)))
    float __builtin_ipu_cmplt(float, float);

static __inline__
    __attribute__((__overloadable__,
                   clang_builtin_alias(__builtin_ipu_f16v2cmpne)))
    half2 __builtin_ipu_cmpne(half2, half2);

static __inline__
    __attribute__((__overloadable__,
                   clang_builtin_alias(__builtin_ipu_f16v4cmpne)))
    half4 __builtin_ipu_cmpne(half4, half4);

static __inline__
    __attribute__((__overloadable__,
                   clang_builtin_alias(__builtin_ipu_f32v2cmpne)))
    float2 __builtin_ipu_cmpne(float2, float2);

static __inline__
    __attribute__((__overloadable__,
                   clang_builtin_alias(__builtin_ipu_f32cmpne)))
    float __builtin_ipu_cmpne(float, float);

static __inline__
    __attribute__((__overloadable__,
                   clang_builtin_alias(__builtin_ipu_f16v2exp)))
    half2 __builtin_ipu_exp(half2);

static __inline__
    __attribute__((__overloadable__,
                   clang_builtin_alias(__builtin_expf)))
    float __builtin_ipu_exp(float);

static __inline__
    __attribute__((__overloadable__,
                   clang_builtin_alias(__builtin_ipu_f16v2exp2)))
    half2 __builtin_ipu_exp2(half2);

static __inline__
    __attribute__((__overloadable__,
                   clang_builtin_alias(__builtin_exp2f)))
    float __builtin_ipu_exp2(float);

static __inline__
    __attribute__((__overloadable__,
                   clang_builtin_alias(__builtin_ipu_f16v2ln)))
    half2 __builtin_ipu_ln(half2);

static __inline__
    __attribute__((__overloadable__,
                   clang_builtin_alias(__builtin_logf)))
    float __builtin_ipu_ln(float);

static __inline__
    __attribute__((__overloadable__,
                   clang_builtin_alias(__builtin_ipu_f16v2log2)))
    half2 __builtin_ipu_log2(half2);

static __inline__
    __attribute__((__overloadable__,
                   clang_builtin_alias(__builtin_log2f)))
    float __builtin_ipu_log2(float);

static __inline__
    __attribute__((__overloadable__,
                   clang_builtin_alias(__builtin_ipu_f16v2gina)))
    half2 __builtin_ipu_gina(half2, int);

static __inline__
    __attribute__((__overloadable__,
                   clang_builtin_alias(__builtin_ipu_f32v2gina)))
    float2 __builtin_ipu_gina(float2, int);

static __inline__
    __attribute((__overloadable__,
                 clang_builtin_alias(__builtin_ipu_f16v4rmask)))
    half4 __builtin_ipu_rmask(half4, float);
static __inline__
    __attribute((__overloadable__,
                 clang_builtin_alias(__builtin_ipu_f32v2rmask)))
    float2 __builtin_ipu_rmask(float2, float);

static __inline__
    __attribute((__overloadable__,
                 clang_builtin_alias(__builtin_ipu_f16v2sigm)))
    half2 __builtin_ipu_sigm(half2);

static __inline__
    __attribute((__overloadable__,
                 clang_builtin_alias(__builtin_ipu_f32sigm)))
    float __builtin_ipu_sigm(float);

static __inline__
    __attribute((__overloadable__,
                 clang_builtin_alias(__builtin_ipu_f16v2sum)))
    float __builtin_ipu_sum(half2);
static __inline__
    __attribute((__overloadable__,
                 clang_builtin_alias(__builtin_ipu_f16v4sum)))
    float2 __builtin_ipu_sum(half4);
static __inline__
    __attribute((__overloadable__,
                 clang_builtin_alias(__builtin_ipu_f16v2tanh)))
    half2 __builtin_ipu_tanh(half2);
static __inline__
    __attribute((__overloadable__,
                 clang_builtin_alias(__builtin_tanhf)))
    float __builtin_ipu_tanh(float);

#ifdef __cplusplus
} /* extern "C" */
#endif

#endif /* __IPU_BUILTINS_H */
