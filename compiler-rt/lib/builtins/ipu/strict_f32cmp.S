// ===-- strict_f32cmp.S - Implements quiet strict float comparisons ------===//
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

#define __ELF__
#include "../assembly.h"

.macro strict_f32cmp cmpinst qnan_true do_cmp=1
	{
.if \qnan_true == 0
		mov $m0, $m15
.else
		add $m0, $m15, -1
.endif
		f32class $a2, $a0
	}
	{
		mov $m1, $a2
		f32class $a2, $a1
	}
	mov $m2, $a2
	cmpeq $m1, $m1, 2
	cmpeq $m2, $m2, 2
	or $m1, $m1, $m2
	brnz $m1, .LRET\@
.if \do_cmp == 0
	{
		// Not a qNaN, negate boolean value.
		sub $m0, -1, $m0
		// Compare and discard result to signal on SNaN.
		\cmpinst $azero, $a0, $a1
	}
.else
	\cmpinst $a0, $a0, $a1
	atom $m0, $a0
.endif
.LRET\@:
	br $lr
.endm

.macro strict_ord_f32cmp cmpinst
	strict_f32cmp \cmpinst 0
.endm

.macro strict_uno_f32cmp cmpinst
	strict_f32cmp \cmpinst 1
.endm


	.section .stack_sizes.__strict_f32cmp_oeq, "", @progbits
	.dc.l .text.__strict_f32cmp_oeq
	.uleb128 0

	.section .text.__strict_f32cmp_oeq
	.p2align	2
DEFINE_COMPILERRT_FUNCTION(__strict_f32cmp_oeq)
	strict_ord_f32cmp f32cmpeq
END_COMPILERRT_FUNCTION(__strict_f32cmp_oeq)


	.section .stack_sizes.__strict_f32cmp_one, "", @progbits
	.dc.l .text.__strict_f32cmp_one
	.uleb128 0

	.section .text.__strict_f32cmp_one
	.p2align	2
DEFINE_COMPILERRT_FUNCTION(__strict_f32cmp_one)
	strict_ord_f32cmp f32cmpne
END_COMPILERRT_FUNCTION(__strict_f32cmp_one)


	.section .stack_sizes.__strict_f32cmp_ogt, "", @progbits
	.dc.l .text.__strict_f32cmp_ogt
	.uleb128 0

	.section .text.__strict_f32cmp_ogt
	.p2align	2
DEFINE_COMPILERRT_FUNCTION(__strict_f32cmp_ogt)
	strict_ord_f32cmp f32cmpgt
END_COMPILERRT_FUNCTION(__strict_f32cmp_ogt)


	.section .stack_sizes.__strict_f32cmp_oge, "", @progbits
	.dc.l .text.__strict_f32cmp_oge
	.uleb128 0

	.section .text.__strict_f32cmp_oge
	.p2align	2
DEFINE_COMPILERRT_FUNCTION(__strict_f32cmp_oge)
	strict_ord_f32cmp f32cmpge
END_COMPILERRT_FUNCTION(__strict_f32cmp_oge)


	.section .stack_sizes.__strict_f32cmp_olt, "", @progbits
	.dc.l .text.__strict_f32cmp_olt
	.uleb128 0

	.section .text.__strict_f32cmp_olt
	.p2align	2
DEFINE_COMPILERRT_FUNCTION(__strict_f32cmp_olt)
	strict_ord_f32cmp f32cmplt
END_COMPILERRT_FUNCTION(__strict_f32cmp_olt)


	.section .stack_sizes.__strict_f32cmp_ole, "", @progbits
	.dc.l .text.__strict_f32cmp_ole
	.uleb128 0

	.section .text.__strict_f32cmp_ole
	.p2align	2
DEFINE_COMPILERRT_FUNCTION(__strict_f32cmp_ole)
	strict_ord_f32cmp f32cmple
END_COMPILERRT_FUNCTION(__strict_f32cmp_ole)


	.section .stack_sizes.__strict_f32cmp_ord, "", @progbits
	.dc.l .text.__strict_f32cmp_ord
	.uleb128 0

	.section .text.__strict_f32cmp_ord
	.p2align	2
DEFINE_COMPILERRT_FUNCTION(__strict_f32cmp_ord)
	strict_f32cmp f32cmpeq 0 0
END_COMPILERRT_FUNCTION(__strict_f32cmp_ord)


	.section .stack_sizes.__strict_f32cmp_ueq, "", @progbits
	.dc.l .text.__strict_f32cmp_ueq
	.uleb128 0

	.section .text.__strict_f32cmp_ueq
	.p2align	2
DEFINE_COMPILERRT_FUNCTION(__strict_f32cmp_ueq)
	strict_uno_f32cmp f32cmpeq
END_COMPILERRT_FUNCTION(__strict_f32cmp_ueq)


	.section .stack_sizes.__strict_f32cmp_une, "", @progbits
	.dc.l .text.__strict_f32cmp_une
	.uleb128 0

	.section .text.__strict_f32cmp_une
	.p2align	2
DEFINE_COMPILERRT_FUNCTION(__strict_f32cmp_une)
	strict_uno_f32cmp f32cmpne
END_COMPILERRT_FUNCTION(__strict_f32cmp_une)


	.section .stack_sizes.__strict_f32cmp_ugt, "", @progbits
	.dc.l .text.__strict_f32cmp_ugt
	.uleb128 0

	.section .text.__strict_f32cmp_ugt
	.p2align	2
DEFINE_COMPILERRT_FUNCTION(__strict_f32cmp_ugt)
	strict_uno_f32cmp f32cmpgt
END_COMPILERRT_FUNCTION(__strict_f32cmp_ugt)


	.section .stack_sizes.__strict_f32cmp_uge, "", @progbits
	.dc.l .text.__strict_f32cmp_uge
	.uleb128 0

	.section .text.__strict_f32cmp_uge
	.p2align	2
DEFINE_COMPILERRT_FUNCTION(__strict_f32cmp_uge)
	strict_uno_f32cmp f32cmpge
END_COMPILERRT_FUNCTION(__strict_f32cmp_uge)


	.section .stack_sizes.__strict_f32cmp_ult, "", @progbits
	.dc.l .text.__strict_f32cmp_ult
	.uleb128 0

	.section .text.__strict_f32cmp_ult
	.p2align	2
DEFINE_COMPILERRT_FUNCTION(__strict_f32cmp_ult)
	strict_uno_f32cmp f32cmplt
END_COMPILERRT_FUNCTION(__strict_f32cmp_ult)


	.section .stack_sizes.__strict_f32cmp_ule, "", @progbits
	.dc.l .text.__strict_f32cmp_ule
	.uleb128 0

	.section .text.__strict_f32cmp_ule
	.p2align	2
DEFINE_COMPILERRT_FUNCTION(__strict_f32cmp_ule)
	strict_uno_f32cmp f32cmple
END_COMPILERRT_FUNCTION(__strict_f32cmp_ule)


	.section .stack_sizes.__strict_f32cmp_uno, "", @progbits
	.dc.l .text.__strict_f32cmp_uno
	.uleb128 0

	.section .text.__strict_f32cmp_uno
	.p2align	2
DEFINE_COMPILERRT_FUNCTION(__strict_f32cmp_uno)
	strict_f32cmp f32cmpeq 1 0
END_COMPILERRT_FUNCTION(__strict_f32cmp_uno)
