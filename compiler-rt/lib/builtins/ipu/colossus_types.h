// ===-- colossus_types.h - Vector type definitions -----------------------===//
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
//
// This file defines the vector types used by the IPU builtins in the library.
//
// This file is not part of the interface of this library.
//
//===----------------------------------------------------------------------===//

#ifndef _COLOSSUS_TYPES_H
#define _COLOSSUS_TYPES_H

// Colossus vector data types
#ifndef __SUPERVISOR__
typedef __fp16 half2 __attribute__((vector_size(sizeof(__fp16) * 2)));
typedef __fp16 half4 __attribute__((vector_size(sizeof(__fp16) * 4)));
typedef float float2 __attribute__((vector_size(sizeof(float) * 2)));
typedef float float4 __attribute__((vector_size(sizeof(float) * 4)));
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

#endif // _COLOSSUS_TYPES_H
