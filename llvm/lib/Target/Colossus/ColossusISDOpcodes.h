//===-- ColossusISDOpcodes.h - Colossus CodeGen Opcodes ---------*- C++ -*-===//
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
// This file declares colossus codegen opcodes.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_COLOSSUS_COLOSSUSISDOPCODES_H
#define LLVM_LIB_TARGET_COLOSSUS_COLOSSUSISDOPCODES_H

#include "llvm/CodeGen/ISDOpcodes.h"

namespace llvm {
namespace ColossusISD {
enum NodeType {
  // Start the numbering where the builtin ops and target ops leave off.
  FIRST_NUMBER = ISD::BUILTIN_OP_END,

  // Global symbol address wrapper.
  ADDR,

  // Call a subroutine.
  CALL,

  // Indirect subroutine call.
  ICALL,

  // Offset from frame pointer to the first (possible) on-stack argument.
  FRAME_TO_ARGS_OFFSET,

  // Memory barrier.
  MEM_BARRIER,

  // Subroutine return
  RTN,

  // Pseudo operation for holding return registers.
  RTN_REG_HOLDER,

  // Set the link register, for use with ICALL.
  SETLR,

  // Pseudo operation for saving the current stack pointer.
  STACKSAVE,

  // Pseudo operation for restoring the stack pointer.
  STACKRESTORE,

  // Exit from a vertex function.
  VERTEX_EXIT,

  // Global address wrapper.
  WRAPPER,

  // Colossus bitwise operations
  FNOT, FAND, FOR, ANDC,

  // Same as ISD::CONCAT_VECTORS, bypasses the generic DAGCombiner pass
  CONCAT_VECTORS,

  // 16 bit shuffle operations
  SORT4X16LO, SORT4X16HI, ROLL16,

  // Floating point comparisons
  FCMP,

  // f32 / integer conversions on ARF. FP_TO_SINT etc induce bitcasts at Select
  F32_TO_SINT, F32_TO_UINT, SINT_TO_F32, UINT_TO_F32,

  // Essentially bitcasts, but between different widths
  F16ASV2F16, V2F16ASF16,

  // Mathematical functions
  FTANH, FSIGMOID, FRSQRT,

  // Hardware loops
  CLOOP_BEGIN_VALUE, CLOOP_BEGIN_TERMINATOR, CLOOP_END_VALUE, CLOOP_END_BRANCH, CLOOP_GUARD_BRANCH,

  // 8 bit shuffle operations
  SORT8X8LO, SHUF8X8LO, SHUF8X8HI,

  // Strict floating point comparisons
  STRICT_FCMPS = ISD::FIRST_TARGET_STRICTFP_OPCODE,

  // Strict f32 / integer conversions on ARF. STRICT_FP_TO_SINT etc induce
  // bitcasts at Select
  STRICT_F32_TO_SINT, STRICT_F32_TO_UINT,

  // Strict mathematical functions
  STRICT_FRSQRT,
};
}
}

#endif
