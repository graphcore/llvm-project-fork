//===--- ipudef.h ------ IPU type definitions -----------------------------===//
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

/**
 * \defgroup ipuGroup IPU Libraries.
 * \brief Runtime library components that are specific to the IPU.
 *
 * \file ipudef.h
 * \ingroup ipuGroup
 * \brief Type definitions for the IPU
 *
 * This file provides type definitions for native types on the IPU.
 *
 * \addtogroup ipuGroup
 * \{
 */
#ifndef _IPUDEF_H
#define _IPUDEF_H

#if !defined(__IPU__) && !defined(__POPC__)
#warning This file is intended for use in IPU device code only.
#endif

#ifdef _DOXYGEN_PREPROCESS
// These typedefs are for documentation purposes only.
// They do not participate in compilation.
typedef __fp16 half;
typedef __fp16[2] half2;
typedef __fp16[4] half4;
typedef __fp16[8] half8;
typedef float[2] float2;
typedef float[4] float4;
typedef char[2] char2;
typedef unsigned char[2] uchar2;
typedef char[4] char4;
typedef unsigned char[4] uchar4;
typedef short[2] short2;
typedef unsigned short[2] ushort2;
typedef short[4] short4;
typedef unsigned short[4] ushort4;
typedef int[2] int2;
typedef unsigned int[2] uint2;
typedef int[4] int4;
typedef unsigned int[4] uint4;
typedef long[2] long2;
typedef long[4] long4;
typedef long long[2] longlong2;
typedef long long[4] longlong4;
#define IPUDEF_HALF_DEFINED
#endif

/**
 * \cond
 */

#ifdef __cplusplus
extern "C" {
#endif

#ifndef __ASSEMBLER__

/* Colossus vector data types for worker context */
typedef __fp16 half;
typedef __fp16 half2 __attribute__((vector_size(sizeof(__fp16) * 2)));
typedef __fp16 half4 __attribute__((vector_size(sizeof(__fp16) * 4)));
typedef __fp16 half8 __attribute__((vector_size(sizeof(__fp16) * 8)));
typedef float float2 __attribute__((vector_size(sizeof(float) * 2)));
typedef float float4 __attribute__((vector_size(sizeof(float) * 4)));

#if defined(__IPU_ARCH_VERSION__) && __IPU_ARCH_VERSION__ >= 21
/* quarter (fp8) support */

typedef struct quarter {
  unsigned char value;
} quarter;

typedef struct quarter_metadata {
  enum format { f152, f143 } fmt;
  signed char scale;
} quarter_metadata;

#ifndef __SUPERVISOR__
inline __attribute__((always_inline)) void
setQuarterConfig(quarter_metadata md) {
  // Load format and scale into arf registers. Temporary variable tmp_fmt is
  // used to prevent reading all the bytes of the underlying type for md.fmt.
  unsigned char tmp_fmt = md.fmt << 1;
  float fmt, scale;
  __builtin_memcpy(&fmt, &tmp_fmt, sizeof(tmp_fmt));
  __builtin_memcpy(&scale, &md.scale, sizeof(md.scale));
  asm volatile("uput $FP_NFMT, %[format]\n\t"
               "uput $FP_SCL, %[scale]"
               :
               : [format] "r"(fmt), [scale] "r"(scale)
               :);
}

inline __attribute__((always_inline)) half quarterToHalf(quarter *input,
                                                         quarter_metadata md) {
  setQuarterConfig(md);
  half2 output_vec;
  asm volatile("ldb8 %[output_vec], $mzero, %[input], 0\n\t"
               "f8v2tof16 %[output_vec], %[output_vec]"
               : [output_vec] "=r"(output_vec)
               : [input] "r"(&input->value));
  return output_vec[0];
}

inline __attribute__((always_inline)) quarter
halfToQuarter(half *input, quarter_metadata md) {
  quarter_metadata negated_md = {md.fmt, -md.scale};
  setQuarterConfig(negated_md);
  half2 input_vec = {*input, *input};
  half2 tmp;
  quarter output;
  asm volatile("f16v2tof8 %[tmp], %[input_vec]\n\t"
               "atom %[output], %[tmp]"
               : [output] "=r"(output.value), [tmp] "=r"(tmp)
               : [input_vec] "r"(input_vec));
  return output;
}

inline __attribute__((always_inline)) quarter
quarterToQuarter(quarter *input, quarter_metadata md_from,
                 quarter_metadata md_to) {
  half temp = quarterToHalf(input, md_from);
  return halfToQuarter(&temp, md_to);
}

#endif // __IPU_ARCH_VERSION__ >= 21
#endif // !defined(__SUPERVISOR__)

typedef char char2 __attribute__((vector_size(sizeof(char) * 2)));
typedef unsigned char uchar2
    __attribute__((vector_size(sizeof(unsigned char) * 2)));
typedef char char4 __attribute__((vector_size(sizeof(char) * 4)));
typedef unsigned char uchar4
    __attribute__((vector_size(sizeof(unsigned char) * 4)));
typedef short short2 __attribute__((vector_size(sizeof(short) * 2)));
typedef unsigned short ushort2
    __attribute__((vector_size(sizeof(unsigned short) * 2)));
typedef short short4 __attribute__((vector_size(sizeof(short) * 4)));
typedef unsigned short ushort4
    __attribute__((vector_size(sizeof(unsigned short) * 4)));
typedef int int2 __attribute__((vector_size(sizeof(int) * 2)));
typedef unsigned int uint2
    __attribute__((vector_size(sizeof(unsigned int) * 2)));
typedef int int4 __attribute__((vector_size(sizeof(int) * 4)));
typedef unsigned int uint4
    __attribute__((vector_size(sizeof(unsigned int) * 4)));

typedef long long2 __attribute__((vector_size(sizeof(long) * 2)));
typedef long long4 __attribute__((vector_size(sizeof(long) * 4)));
typedef long long longlong2 __attribute__((vector_size(sizeof(long long) * 2)));
typedef long long longlong4 __attribute__((vector_size(sizeof(long long) * 4)));

#endif // !defined(__ASSEMBLER__)

#ifdef __cplusplus
} // extern "C"
#endif

/**
 * \endcond
 */

////////////////////////////////////////////////////////////////////////////////

#if defined(__cplusplus) && defined(__IPU__)

// Define specialisations of `ap_int` ------------------------------------------

#include <ap_int.h>

using rptsize_t = ap_int<__IPU_REPEAT_COUNT_SIZE__, false>;

#endif // defined(__cplusplus) && defined(__IPU__)

////////////////////////////////////////////////////////////////////////////////

#ifndef __SUPERVISOR__

#if defined(__cplusplus) && defined(__IPU__)

// Specialise `numeric_limits` for `half` type ---------------------------------

#include <limits>

namespace std {

template <> class numeric_limits<half> {
public:
  using type = half;

  static constexpr bool is_specialized = true;
  static constexpr half min() noexcept { return half(0.0f); }
  static constexpr half max() noexcept { return half(65504.0f); }
  static constexpr half lowest() noexcept { return half(-max()); }
  static constexpr int digits = 11;
  static constexpr int digits10 = 3;
  static constexpr int max_digits10 = 5;
  static constexpr bool is_signed = true;
  static constexpr bool is_integer = false;
  static constexpr bool is_exact = false;
  static constexpr int radix = 2;

  static constexpr half epsilon() noexcept {
    // 2^-10
    return half(0.0009765625f);
  }

  static constexpr half round_error() noexcept {
    // Error must be less than 1 ULP if stochastic rounding is enabled.
    return half(1.0f);
  }

  static constexpr int min_exponent = -13;
  static constexpr int min_exponent10 = -4;
  static constexpr int max_exponent = 16;
  static constexpr int max_exponent10 = 4;

  static constexpr bool has_infinity = false;
  static constexpr bool has_quiet_NaN = true;
  static constexpr bool has_signaling_NaN = false;
  static constexpr float_denorm_style has_denorm = denorm_present;
  static constexpr bool has_denorm_loss = false;

  // Infinity not fully supported on hardware.
  // See section 2.10.4.2 in the tile manual.
  static constexpr half infinity() noexcept {
    return half(numeric_limits<float>::infinity());
  }

  static constexpr half quiet_NaN() noexcept {
    return half(numeric_limits<float>::quiet_NaN());
  }

  // Signalling NaNs are not supported and are generally quietened.
  static constexpr half signaling_NaN() noexcept {
    return half(numeric_limits<float>::quiet_NaN());
  }

  static constexpr half denorm_min() noexcept {
    // 2^-24
    return half(0.00000005960464477539f);
  }

  // IEC559 requires signalling NaNs which are not supported.
  static constexpr bool is_iec559 = false;
  static constexpr bool is_bounded = true;
  static constexpr bool is_modulo = false;
  static constexpr bool traps = false;
  static constexpr bool tinyness_before = false;

  // Stochastic rounding may or may not be enabled depending on the
  // machine settings.
  static constexpr float_round_style round_style = round_indeterminate;
};

} // namespace std

// Define `half` literal operator ----------------------------------------------

constexpr half operator"" _h(long double x) { return half(x); }

// -----------------------------------------------------------------------------

#endif // defined(__cplusplus) && defined(__IPU__)

#endif // !defined(__SUPERVISOR__)

////////////////////////////////////////////////////////////////////////////////

#endif // _IPUDEF_H

/**
 * \}
 */
