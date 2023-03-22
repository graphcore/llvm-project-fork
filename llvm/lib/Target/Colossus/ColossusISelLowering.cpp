//===-- ColossusISelLowering.cpp - Colossus DAG Lowering Implementation ---===//
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
// This file implements the ColossusTargetLowering class.
//
//===----------------------------------------------------------------------===//

#include "ColossusISelLowering.h"
#include "Colossus.h"
#include "ColossusCountedLoopOptions.h"
#include "ColossusFrameLowering.h"
#include "ColossusMachineFunctionInfo.h"
#include "ColossusSubtarget.h"
#include "ColossusTargetInstr.h"
#include "ColossusTargetMachine.h"
#include "ColossusTargetObjectFile.h"
#include "llvm/CodeGen/CallingConvLower.h"
#include "llvm/CodeGen/MachineFrameInfo.h"
#include "llvm/CodeGen/MachineFunction.h"
#include "llvm/CodeGen/MachineInstrBuilder.h"
#include "llvm/CodeGen/MachineJumpTableInfo.h"
#include "llvm/CodeGen/MachineRegisterInfo.h"
#include "llvm/CodeGen/SelectionDAGISel.h"
#include "llvm/CodeGen/ValueTypes.h"
#include "llvm/Demangle/Demangle.h"
#include "llvm/IR/CallingConv.h"
#include "llvm/IR/Constants.h"
#include "llvm/IR/DerivedTypes.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/GlobalAlias.h"
#include "llvm/IR/GlobalVariable.h"
#include "llvm/IR/Intrinsics.h"
#include "llvm/IR/IntrinsicsColossus.h"
#include "llvm/MC/MCContext.h"
#include "llvm/MC/MCSymbol.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Support/MathExtras.h"
#include "llvm/Support/raw_ostream.h"
#include <algorithm>
#include <regex>
#include <set>

using namespace llvm;

#define DEBUG_TYPE "colossus-isel-lowering"

static cl::opt<bool>
EnableTargetModeChecks("colossus-enable-target-checks", cl::Hidden,
  cl::desc("Enable / disable consistency checks between direct function calls "
           "from supervisor to worker mode."),
  cl::init(false));

static bool isWorkerSubtarget(SelectionDAG const &DAG) {
  auto &CSTM = static_cast<ColossusSubtarget const &>(DAG.getSubtarget());
  return CSTM.isWorkerMode();
}

static bool isSupervisorSubtarget(SelectionDAG const &DAG) {
  auto &CSTM = static_cast<ColossusSubtarget const &>(DAG.getSubtarget());
  return CSTM.isSupervisorMode();
}

ColossusTargetLowering
::ColossusTargetLowering(const TargetMachine &TM,
                         const ColossusSubtarget &Subtarget)
    : TargetLowering(TM), Subtarget(Subtarget) {

  // Set up the register classes.

  // Integers.
  addRegisterClass(MVT::i32,   &Colossus::MRRegClass);
  // Floats.

  if (Subtarget.isWorkerMode()) {
    LLVM_DEBUG(dbgs() << "Registering AR registers for worker mode");
    addRegisterClass(MVT::f32,   &Colossus::ARRegClass);
    addRegisterClass(MVT::f16,   &Colossus::ARRegClass);
    addRegisterClass(MVT::v2f16, &Colossus::ARRegClass);
    addRegisterClass(MVT::v2f32, &Colossus::ARPairRegClass);
    addRegisterClass(MVT::v4f16 , &Colossus::ARPairRegClass);
  }

  // These are used for vector predicate values.
  addRegisterClass(MVT::v2i16, &Colossus::MRRegClass);
  addRegisterClass(MVT::v2i32, &Colossus::MRPairRegClass);
  addRegisterClass(MVT::v4i16, &Colossus::MRPairRegClass);

  // Compute derived properties from the register classes.
  computeRegisterProperties(Subtarget.getRegisterInfo());

  // Stack pointer.
  setStackPointerRegisterToSaveRestore(
        ColossusRegisterInfo::getStackRegister());

  // Instruction scheduling.
  setSchedulingPreference(Sched::RegPressure);

  // Use all zeros/ones predicates for SETCC operation results.
  setBooleanContents(/*IntTy=*/ZeroOrOneBooleanContent,
                     /*FloatTy=*/ZeroOrNegativeOneBooleanContent);
  setBooleanVectorContents(ZeroOrNegativeOneBooleanContent);

  // TRAP is legal.
  setOperationAction(ISD::TRAP, MVT::Other, Legal);

  // Custom lower intrinsics.
  setOperationAction(ISD::INTRINSIC_W_CHAIN, MVT::i8, Custom);
  setOperationAction(ISD::INTRINSIC_W_CHAIN, MVT::i16, Custom);
  setOperationAction(ISD::INTRINSIC_W_CHAIN, MVT::i32, Custom);
  setOperationAction(ISD::INTRINSIC_W_CHAIN, MVT::i64, Custom);
  setOperationAction(ISD::INTRINSIC_W_CHAIN, MVT::Other, Custom);
  setOperationAction(ISD::INTRINSIC_WO_CHAIN, MVT::i1, Custom);
  setOperationAction(ISD::INTRINSIC_WO_CHAIN, MVT::Other, Custom);
  setOperationAction(ISD::INTRINSIC_VOID, MVT::Other, Custom);

  // Promote i1 loads.
  for (MVT VT : MVT::integer_valuetypes()) {
    setLoadExtAction(ISD::EXTLOAD,  VT, MVT::i1, Promote);
    setLoadExtAction(ISD::ZEXTLOAD, VT, MVT::i1, Promote);
    setLoadExtAction(ISD::SEXTLOAD, VT, MVT::i1, Promote);
  }

  // f16 loads.
  setLoadExtAction(ISD::EXTLOAD,  MVT::f32, MVT::f16, Expand);

  // f16 stores
  setTruncStoreAction(MVT::f32, MVT::f16, Expand);

  // Custom expand subword stores.
  setTruncStoreAction(MVT::i32, MVT::i16, Custom);
  setTruncStoreAction(MVT::i32, MVT::i8, Custom);
  setOperationAction(ISD::STORE, MVT::i16, Custom);
  setOperationAction(ISD::STORE, MVT::i8, Custom);

  // Naturally aligned 64 bit memory ops are legal in the sense that they can
  // reach Select() without problems. They are custom lowered to efficiently
  // handle lower than natural alignment.
  // Naturally aligned 32 bit and 16 bit memory ops are legal, while unaligned
  // ops are custom lowered.
  for (auto op : {ISD::LOAD, ISD::STORE}) {
    for (auto type : {MVT::i32, MVT::v2i16, MVT::v2i32, MVT::v4i16,
                      MVT::f16, MVT::f32, MVT::v2f16, MVT::v2f32, MVT::v4f16}) {
      setOperationAction(op, type, Custom);
    }
  }

  // i16 loads.
  setLoadExtAction(ISD::EXTLOAD,  MVT::i32, MVT::i16, Custom);
  setLoadExtAction(ISD::ZEXTLOAD, MVT::i32, MVT::i16, Custom);

  setIndexedLoadAction(ISD::POST_INC, MVT::i8,     Legal);
  setIndexedLoadAction(ISD::POST_INC, MVT::i16,    Legal);
  setIndexedLoadAction(ISD::POST_INC, MVT::i32,    Legal);
  setIndexedLoadAction(ISD::POST_INC, MVT::v2i16,  Legal);
  setIndexedLoadAction(ISD::POST_INC, MVT::f16,    Legal);
  setIndexedLoadAction(ISD::POST_INC, MVT::v2f16,  Legal);
  setIndexedLoadAction(ISD::POST_INC, MVT::f32,    Legal);
  setIndexedLoadAction(ISD::POST_INC, MVT::v2f32,  Legal);
  setIndexedLoadAction(ISD::POST_INC, MVT::v4f16,  Legal);

  setIndexedStoreAction(ISD::POST_INC, MVT::i32,   Legal);
  setIndexedStoreAction(ISD::POST_INC, MVT::v2i16, Legal);
  setIndexedStoreAction(ISD::POST_INC, MVT::f32,   Legal);
  setIndexedStoreAction(ISD::POST_INC, MVT::v2f16, Legal);
  setIndexedStoreAction(ISD::POST_INC, MVT::v2f32, Legal);
  setIndexedStoreAction(ISD::POST_INC, MVT::v4f16, Legal);

  setOperationAction(ISD::SETCC, MVT::i32, Legal);
  // Expand BR_CC into a SETCC.
  setOperationAction(ISD::BR_CC, MVT::i32, Expand);
  setOperationAction(ISD::BR_CC, MVT::f32, Expand);
  setOperationAction(ISD::BR_CC, MVT::f16, Expand);
  // Expand SELECT_CC into a SETCC and a SELECT.
  setOperationAction(ISD::SELECT_CC, MVT::i32, Expand);
  setOperationAction(ISD::SELECT_CC, MVT::f16, Expand);
  setOperationAction(ISD::SELECT_CC, MVT::f32, Expand);

  // Jump tables.
  setOperationAction(ISD::BR_JT, MVT::Other, Expand);

  // Varargs
  setOperationAction(ISD::FRAME_TO_ARGS_OFFSET, MVT::i32, Custom);
  setOperationAction(ISD::VAEND,   MVT::Other, Expand);
  setOperationAction(ISD::VACOPY,  MVT::Other, Expand);
  setOperationAction(ISD::VAARG,   MVT::Other, Custom);
  setOperationAction(ISD::VASTART, MVT::Other, Custom);

  // Dynamic stack allocation.
  setOperationAction(ISD::STACKSAVE,          MVT::Other, Expand);
  setOperationAction(ISD::STACKRESTORE,       MVT::Other, Expand);
  setOperationAction(ISD::DYNAMIC_STACKALLOC, MVT::i32, Expand);

  // Supported bit manipulations.
  setOperationAction(ISD::BSWAP, MVT::i32, Legal);
  setOperationAction(ISD::BITREVERSE, MVT::i32, Legal);
  setOperationAction(ISD::CTLZ,  MVT::i32, Legal);
  setOperationAction(ISD::CTPOP, MVT::i32, Legal);

  for (auto VT : {MVT::v2i32, MVT::v2i16, MVT::v4i16}) {
    setOperationAction(ISD::CTLZ, VT, Expand);
    setOperationAction(ISD::CTPOP, VT, Expand);
  }

  // Addresses.
  setOperationAction(ISD::JumpTable,     MVT::i32, Custom);
  setOperationAction(ISD::GlobalAddress, MVT::i32, Custom);
  setOperationAction(ISD::BlockAddress,  MVT::i32, Custom);

  // Constants.
  setOperationAction(ISD::Constant,     MVT::i8, Legal);
  setOperationAction(ISD::Constant,     MVT::i16, Legal);
  setOperationAction(ISD::Constant,     MVT::i32, Legal);
  setOperationAction(ISD::ConstantFP,   MVT::f32, Legal);
  setOperationAction(ISD::ConstantFP,   MVT::f16, Legal);
  // Expansion of uint_to_fp creates i64 constant pool nodes.
  setOperationAction(ISD::ConstantPool, MVT::i32, Custom);
  setOperationAction(ISD::ConstantPool, MVT::i64, Custom);

  // Min and Max Support.
  setOperationAction(ISD::SMIN, MVT::i32, Legal);
  setOperationAction(ISD::SMAX, MVT::i32, Legal);

  setOperationAction(ISD::SMIN, MVT::v2i16, Custom);
  setOperationAction(ISD::SMAX, MVT::v2i16, Custom);

  setOperationAction(ISD::SMIN, MVT::v4i16, Custom);
  setOperationAction(ISD::SMAX, MVT::v4i16, Custom);

  // Note on ABS: ABS is not marked legal here since our ABS instruction returns
  // 0 for INT_MIN which is against the semantic of ISD::ABS (T28307).

  // Unsupported integer operations.
  for (unsigned IntOp : {
      ISD::UDIV,
      ISD::UREM,
      ISD::SDIV,
      ISD::SREM,
      ISD::SDIVREM,
      ISD::UDIVREM,
      // Ops with carries for multiple precision add and sub.
      ISD::ADDC,
      ISD::ADDE,
      ISD::SUBC,
      ISD::SUBE,
      // 64-bit shifts.
      ISD::SHL_PARTS,
      ISD::SRA_PARTS,
      ISD::SRL_PARTS,
      // Bit manipulations.
      ISD::ROTL,
      ISD::ROTR,
      ISD::CTTZ,
      ISD::CTTZ_ZERO_UNDEF,
      ISD::CTLZ_ZERO_UNDEF}) {
    setOperationAction(IntOp, MVT::i32, Expand);
  }
  for (unsigned op : {ISD::CTTZ, ISD::CTTZ_ZERO_UNDEF, ISD::CTLZ_ZERO_UNDEF}) {
    for (auto VT : {MVT::i32, MVT::v2i32, MVT::v2i16, MVT::v4i16}) {
      setOperationAction(op, VT, Expand);
    }
  }

  // The default expansion of i32 XMUL_LOHI i32 requires a legal i16 type
  // The expansion of XMUL_LOHI fails because vector unrolling code cannot
  // handle multiple return values.
  // Custom lowering both (XMUL_LOHI in terms of MULHX) solves both.
  // vxi16 are not created by legalisation for these nodes when i32 is legal
  for (auto VT : {MVT::i32, MVT::v2i32,}) {
    setOperationAction(ISD::MULHU, VT, Custom);
    setOperationAction(ISD::MULHS, VT, Custom);
    setOperationAction(ISD::UMUL_LOHI, VT, Custom);
    setOperationAction(ISD::SMUL_LOHI, VT, Custom);
  }

  // f16
  setOperationAction(ISD::FP_ROUND, MVT::f16, Legal);
  setOperationAction(ISD::FP_EXTEND, MVT::f16, Legal);
  setOperationAction(ISD::SETCC, MVT::f16, Promote);
  setOperationAction(ISD::STRICT_FP_ROUND, MVT::f16, Legal);
  setOperationAction(ISD::STRICT_FP_EXTEND, MVT::f16, Legal);
  setOperationAction(ISD::STRICT_FSETCC, MVT::f16, Promote);
  setOperationAction(ISD::STRICT_FSETCCS, MVT::f16, Promote);

  // f32
  setOperationAction(ISD::FP_EXTEND, MVT::f32, Legal);
  setOperationAction(ISD::STRICT_FP_EXTEND, MVT::f32, Legal);
  // Comparisons are custom lowered to expose that the result is in ARF and
  // that some comparison need several instructions.
  setOperationAction(ISD::SETCC, MVT::f32, Custom);
  setOperationAction(ISD::STRICT_FSETCC, MVT::f32, Custom);
  setOperationAction(ISD::STRICT_FSETCCS, MVT::f32, Custom);

  //Current rounding mode.
  setOperationAction(ISD::FLT_ROUNDS_, MVT::i32, Custom);

  // integer to floating point conversions
  for (unsigned op :
       {ISD::SINT_TO_FP, ISD::UINT_TO_FP, ISD::FP_TO_SINT, ISD::FP_TO_UINT,
        ISD::STRICT_SINT_TO_FP, ISD::STRICT_UINT_TO_FP, ISD::STRICT_FP_TO_SINT,
        ISD::STRICT_FP_TO_UINT}) {
    // Base case. Wider types are rewritten in terms of this
    setOperationAction(op, MVT::i32, Legal);
    // vectors can be expanded to multiple 32 bit ops
    setOperationAction(op, MVT::v4i16, Expand);
    setOperationAction(op, MVT::v2i16, Expand);
    setOperationAction(op, MVT::v2i32, Expand);
    // i64 to f16 is custom lowered via i32
    setOperationAction(op, MVT::i64, Custom);
    // The default handling for v2i64 => v2f16 splits the vector, but also
    // introduces a conversion via f32. i64 => f32 is then a library call
    // Lowering via i32 instead is better for colossus.
    setOperationAction(op, MVT::v2i64, Custom);
  }

  // Expand unsupported binary vector operations
  for (MVT VT : MVT::integer_fixedlen_vector_valuetypes()) {
    for (auto Op : {
             ISD::SRA,
             ISD::SRL,
             ISD::SHL,
             ISD::SDIV,
             ISD::UDIV,
             ISD::SREM,
             ISD::UREM,
             ISD::SDIVREM,
             ISD::UDIVREM,
             ISD::SIGN_EXTEND_INREG,
         }) {
      setOperationAction(Op, VT, Expand);
    }
  }

  for (auto Op : {ISD::ADD, ISD::SUB, ISD::MUL})
    {
      setOperationAction(Op, MVT::v2i16, Expand);
      setOperationAction(Op, MVT::v4i16, Expand);
      setOperationAction(Op, MVT::v2i32, Expand);
    }

  for (MVT VT : MVT::integer_valuetypes())
    {
      if (VT.getScalarSizeInBits() <= 32)
        setOperationAction(ISD::SIGN_EXTEND_INREG, VT, Custom);
    }

  // v2i32

  setOperationAction(ISD::ADD,  MVT::v2i32, Expand);
  setOperationAction(ISD::SINT_TO_FP, MVT::v2i32, Expand);
  setOperationAction(ISD::STRICT_SINT_TO_FP, MVT::v2i32, Expand);

  // v2x32 vector shuffle expand lowers directly to mov
  setOperationAction(ISD::VECTOR_SHUFFLE, MVT::v2i32, Expand);
  setOperationAction(ISD::VECTOR_SHUFFLE, MVT::v2f32, Expand);

// vNx16 vector shuffle expand is custom lowered to take advantage
// of the instruction selection information available in the mask
  setOperationAction(ISD::VECTOR_SHUFFLE, MVT::v2i16, Custom);
  setOperationAction(ISD::VECTOR_SHUFFLE, MVT::v2f16, Custom);
  setOperationAction(ISD::VECTOR_SHUFFLE, MVT::v4i16, Custom);
  setOperationAction(ISD::VECTOR_SHUFFLE, MVT::v4f16, Custom);

  // v2f16
  setLoadExtAction(ISD::EXTLOAD,  MVT::v2f32, MVT::v2f16, Expand);
  setLoadExtAction(ISD::ZEXTLOAD, MVT::v2f32, MVT::v2f16, Expand);
  setLoadExtAction(ISD::SEXTLOAD, MVT::v2f32, MVT::v2f16, Expand);

  setTruncStoreAction(MVT::v2f32, MVT::v2f16, Expand);
  // Strict operations must be marked legal explicitely while the target does
  // not have strict FP enabled. See the case statements for strict operations
  // in VectorLegalizer::LegalizeOp().
  setOperationAction(ISD::STRICT_FP_ROUND, MVT::v2f16, Legal);
  setOperationAction(ISD::STRICT_FP_EXTEND, MVT::v2f32, Legal);

  struct FPEntry {
    unsigned Node;
    LegalizeAction f32;
    LegalizeAction v2f32;
    LegalizeAction f16;
    LegalizeAction v2f16;
    LegalizeAction v4f16;
  };
  // clang-format off
  static const std::array<FPEntry, 58> FPArray = {{
      // Node                   f32      v2f32    f16      v2f16    v4f16
      { ISD::FABS,              Custom,  Custom,  Custom,  Custom,  Custom,  },
      { ISD::FADD,              Legal,   Legal,   Custom,  Legal,   Legal,   },
      { ISD::FCEIL,             Legal,   Custom,  Custom,  Custom,  Custom,  },
      { ISD::FCOPYSIGN,         Custom,  Custom,  Custom,  Custom,  Custom,  },
      { ISD::FCOS,              Expand,  Custom,  Custom,  Custom,  Custom,  },
      { ISD::FDIV,              Legal,   Custom,  Custom,  Custom,  Custom,  },
      { ISD::FEXP,              Legal,   Custom,  Custom,  Legal,   Custom,  },
      { ISD::FEXP2,             Legal,   Custom,  Custom,  Legal,   Custom,  },
      { ISD::FFLOOR,            Legal,   Custom,  Custom,  Custom,  Custom,  },
      { ISD::FGETSIGN,          Expand,  Expand,  Expand,  Expand,  Expand,  },
      { ISD::FLOG,              Legal,   Custom,  Custom,  Legal,   Custom,  },
      { ISD::FLOG10,            Expand,  Custom,  Custom,  Custom,  Custom,  },
      { ISD::FLOG2,             Legal,   Custom,  Custom,  Legal,   Custom,  },
      { ISD::FMA,               Expand,  Custom,  Custom,  Custom,  Custom,  },
      { ISD::FMAD,              Expand,  Expand,  Expand,  Expand,  Expand,  },
      { ISD::FMAXIMUM,          Expand,  Expand,  Expand,  Expand,  Expand,  },
      { ISD::FMAXNUM,           Legal,   Legal,   Custom,  Legal,   Legal,   },
      { ISD::FMINIMUM,          Expand,  Expand,  Expand,  Expand,  Expand,  },
      { ISD::FMINNUM,           Legal,   Legal,   Custom,  Legal,   Legal,   },
      { ISD::FMUL,              Legal,   Legal,   Custom,  Legal,   Legal,   },
      { ISD::FNEARBYINT,        Legal,   Custom,  Custom,  Custom,  Custom,  },
      { ISD::FNEG,              Custom,  Custom,  Custom,  Custom,  Custom,  },
      { ISD::FPOW,              Expand,  Custom,  Custom,  Custom,  Custom,  },
      { ISD::FPOWI,             Expand,  Expand,  Promote, Expand,  Expand,  },
      { ISD::FREM,              Expand,  Custom,  Custom,  Custom,  Custom,  },
      { ISD::FRINT,             Legal,   Custom,  Custom,  Custom,  Custom,  },
      { ISD::FROUND,            Legal,   Custom,  Custom,  Custom,  Custom,  },
      { ISD::FSIN,              Expand,  Custom,  Custom,  Custom,  Custom,  },
      { ISD::FSINCOS,           Expand,  Expand,  Expand,  Expand,  Expand,  },
      { ISD::FSQRT,             Legal,   Custom,  Custom,  Custom,  Custom,  },
      { ISD::FSUB,              Legal,   Legal,   Custom,  Legal,   Legal,   },
      { ISD::FTRUNC,            Legal,   Custom,  Custom,  Custom,  Custom,  },
      { ISD::STRICT_FADD,       Legal,   Legal,   Custom,  Legal,   Legal,   },
      { ISD::STRICT_FCEIL,      Legal,   Custom,  Custom,  Custom,  Custom,  },
      { ISD::STRICT_FCOS,       Expand,  Custom,  Custom,  Custom,  Custom,  },
      { ISD::STRICT_FDIV,       Legal,   Custom,  Custom,  Custom,  Custom,  },
      { ISD::STRICT_FEXP,       Legal,   Custom,  Custom,  Legal,   Custom,  },
      { ISD::STRICT_FEXP2,      Legal,   Custom,  Custom,  Legal,   Custom,  },
      { ISD::STRICT_FFLOOR,     Legal,   Custom,  Custom,  Custom,  Custom,  },
      { ISD::STRICT_FLOG,       Legal,   Custom,  Custom,  Legal,   Custom,  },
      { ISD::STRICT_FLOG10,     Expand,  Custom,  Custom,  Custom,  Custom,  },
      { ISD::STRICT_FLOG2,      Legal,   Custom,  Custom,  Legal,   Custom,  },
      { ISD::STRICT_FMA,        Expand,  Custom,  Custom,  Custom,  Custom,  },
      { ISD::STRICT_FMAXIMUM,   Expand,  Expand,  Expand,  Expand,  Expand,  },
      { ISD::STRICT_FMAXNUM,    Legal,   Legal,   Custom,  Legal,   Legal,   },
      { ISD::STRICT_FMINIMUM,   Expand,  Expand,  Expand,  Expand,  Expand,  },
      { ISD::STRICT_FMINNUM,    Legal,   Legal,   Custom,  Legal,   Legal,   },
      { ISD::STRICT_FMUL,       Legal,   Legal,   Custom,  Legal,   Legal,   },
      { ISD::STRICT_FNEARBYINT, Legal,   Custom,  Custom,  Custom,  Custom,  },
      { ISD::STRICT_FPOW,       Expand,  Custom,  Custom,  Custom,  Custom,  },
      { ISD::STRICT_FPOWI,      Expand,  Expand,  Promote, Expand,  Expand,  },
      { ISD::STRICT_FREM,       Expand,  Custom,  Custom,  Custom,  Custom,  },
      { ISD::STRICT_FRINT,      Legal,   Custom,  Custom,  Custom,  Custom,  },
      { ISD::STRICT_FROUND,     Legal,   Custom,  Custom,  Custom,  Custom,  },
      { ISD::STRICT_FSIN,       Expand,  Custom,  Custom,  Custom,  Custom,  },
      { ISD::STRICT_FSQRT,      Legal,   Custom,  Custom,  Custom,  Custom,  },
      { ISD::STRICT_FSUB,       Legal,   Legal,   Custom,  Legal,   Legal,   },
      { ISD::STRICT_FTRUNC,     Legal,   Custom,  Custom,  Custom,  Custom,  },
      }};
  // clang-format on

  for (size_t i = 0; i < FPArray.size(); i++) {
    auto &r = FPArray[i];
    setOperationAction(r.Node, MVT::f16, r.f16);
    setOperationAction(r.Node, MVT::v2f16, r.v2f16);
    setOperationAction(r.Node, MVT::v4f16, r.v4f16);
    setOperationAction(r.Node, MVT::f32, r.f32);
    setOperationAction(r.Node, MVT::v2f32, r.v2f32);
  }

  // v2i16

  setTruncStoreAction(MVT::v2i16, MVT::v2i1, Expand);
  setOperationAction(ISD::SINT_TO_FP, MVT::v2i16, Expand);
  setOperationAction(ISD::STRICT_SINT_TO_FP, MVT::v2i16, Expand);

  // v4i16
  setOperationAction(ISD::BR_CC,     MVT::v4i16, Expand);

  setTruncStoreAction(MVT::v2i8, MVT::v2i1, Expand);
  setTruncStoreAction(MVT::v2i16, MVT::v2i1, Expand);
  setTruncStoreAction(MVT::v2i32, MVT::v2i1, Expand);

  setTruncStoreAction(MVT::v2i16, MVT::v2i8, Expand);
  setTruncStoreAction(MVT::v2i32, MVT::v2i8, Expand);

  setTruncStoreAction(MVT::v2i32, MVT::v2i16, Expand);

  setTruncStoreAction(MVT::v4i8, MVT::v4i1, Expand);
  setTruncStoreAction(MVT::v4i16, MVT::v4i1, Expand);

  setTruncStoreAction(MVT::v2i16, MVT::v2i8, Custom);
  setTruncStoreAction(MVT::v4i16, MVT::v4i8, Custom);

  for (auto Load : { ISD::EXTLOAD, ISD::SEXTLOAD, ISD::ZEXTLOAD }) {

    setLoadExtAction(Load,  MVT::v2i8, MVT::v2i1, Expand);
    setLoadExtAction(Load,  MVT::v2i16, MVT::v2i1, Expand);
    setLoadExtAction(Load,  MVT::v2i32, MVT::v2i1, Expand);

    setLoadExtAction(Load,  MVT::v2i16, MVT::v2i8, Expand);
    setLoadExtAction(Load,  MVT::v2i32, MVT::v2i8, Expand);

    setLoadExtAction(Load,  MVT::v4i8, MVT::v4i1, Expand);
    setLoadExtAction(Load,  MVT::v4i16, MVT::v4i1, Expand);

    setLoadExtAction(Load,  MVT::v4i16, MVT::v4i8, Custom);
  }

  // Common handling for vector types
  for (MVT VT : MVT::fixedlen_vector_valuetypes()) {
    setOperationAction(ISD::SELECT, VT, Legal);
    setOperationAction(ISD::VSELECT, VT, Expand);
    setOperationAction(ISD::SELECT_CC, VT, Expand);
    setOperationAction(ISD::BUILD_VECTOR, VT, Legal);
    setOperationAction(ISD::EXTRACT_VECTOR_ELT, VT, Legal);
    setOperationAction(ISD::INSERT_VECTOR_ELT, VT, Legal);
    setOperationAction(ISD::EXTRACT_SUBVECTOR, VT, Legal);
    setOperationAction(ISD::INSERT_SUBVECTOR, VT, Expand);
    setOperationAction(ISD::SCALAR_TO_VECTOR, VT, Custom);
    // Upstream CONCAT_VECTORS, expand is broken (BZ 12772)
    setOperationAction(ISD::CONCAT_VECTORS, VT, Legal);
  }

  // Setcc. Explicit handling for every register class.
  // Expand rewrites SETO and SETUO in terms of ISD::AND and ISD::OR.
  // This doesn't work for floating point vectors
  for (MVT VT : MVT::integer_fixedlen_vector_valuetypes()) {
    setCondCodeAction(ISD::SETO, VT, Expand);
    setCondCodeAction(ISD::SETUO, VT, Expand);
  }

  // Comparisons are custom lowered to expose that the result is in ARF and
  // that some comparison need several instructions.
  setOperationAction(ISD::SETCC, MVT::v2f16, Custom);
  setOperationAction(ISD::SETCC, MVT::v4f16, Custom);
  setOperationAction(ISD::SETCC, MVT::v2f32, Custom);
  setOperationAction(ISD::SETCC, MVT::v4i16, Custom);
  setOperationAction(ISD::SETCC, MVT::v2i16, Custom);
  setOperationAction(ISD::SETCC, MVT::v2i32, Custom);
  setOperationAction(ISD::STRICT_FSETCCS, MVT::v2f16, Custom);
  setOperationAction(ISD::STRICT_FSETCCS, MVT::v4f16, Custom);
  setOperationAction(ISD::STRICT_FSETCCS, MVT::v2f32, Custom);
  setOperationAction(ISD::STRICT_FSETCCS, MVT::v4i16, Custom);
  setOperationAction(ISD::STRICT_FSETCCS, MVT::v2i16, Custom);
  setOperationAction(ISD::STRICT_FSETCCS, MVT::v2i32, Custom);

  // Atomic operations.
  setOperationAction(ISD::ATOMIC_FENCE, MVT::Other, Custom);
  setOperationAction(ISD::ATOMIC_LOAD,  MVT::i32, Custom);
  setOperationAction(ISD::ATOMIC_STORE, MVT::i32, Custom);

  // Function alignment.
  setMinFunctionAlignment(Align(4));
  setPrefFunctionAlignment(Align(4));

  // Optimisations and canonicalisations
  for (ISD::NodeType op : {
           ISD::BUILD_VECTOR,
           ISD::BITCAST,
           ISD::FP_ROUND,
           ISD::STRICT_FP_ROUND,
           ISD::ANY_EXTEND,
           ISD::SIGN_EXTEND,
           ISD::ZERO_EXTEND,
           ISD::SIGN_EXTEND_INREG,
           ISD::ADD,
           ISD::SUB,
           ISD::AND,
           ISD::OR,
           ISD::XOR,
           ISD::ANY_EXTEND_VECTOR_INREG,
           ISD::SIGN_EXTEND_VECTOR_INREG,
           ISD::ZERO_EXTEND_VECTOR_INREG,
           ISD::EXTRACT_VECTOR_ELT,
           ISD::INSERT_VECTOR_ELT,
           ISD::EXTRACT_SUBVECTOR,
           ISD::SHL,
           ISD::LOAD,
           ISD::STORE,
           ISD::FP_TO_SINT,
           ISD::STRICT_FP_TO_SINT,
           ISD::FP_TO_UINT,
           ISD::STRICT_FP_TO_UINT,
           ISD::SINT_TO_FP,
           ISD::STRICT_SINT_TO_FP,
           ISD::UINT_TO_FP,
           ISD::STRICT_UINT_TO_FP,
           ISD::FDIV,
           ISD::STRICT_FDIV,
       }) {
    setTargetDAGCombine(op);
  }

  // Implements testing hook
  setTargetDAGCombine(ISD::INTRINSIC_W_CHAIN);
  setTargetDAGCombine(ISD::INTRINSIC_WO_CHAIN);

  // Provide special runtime library function names for supervisor
  // implementations of CRT functions. Currently we only need to do this for
  // udiv/umod operations that are handled here, as well as store operations
  // that are handled separately when we lower stores.
  if(Subtarget.isSupervisorMode()) {
    setLibcallName(RTLIB::SDIV_I32, "__supervisor_divsi3");
    setLibcallName(RTLIB::SREM_I32, "__supervisor_modsi3");
    setLibcallName(RTLIB::UDIV_I32, "__supervisor_udivsi3");
    setLibcallName(RTLIB::UREM_I32, "__supervisor_umodsi3");
  }

  IsStrictFPEnabled = true;
}

const char *ColossusTargetLowering::getTargetNodeName(unsigned Opcode) const {
  switch (Opcode) {
  default: return nullptr;
  case ColossusISD::ADDR:           return "ADDR";
  case ColossusISD::CALL:           return "CALL";
  case ColossusISD::ICALL:          return "ICALL";
  case ColossusISD::FRAME_TO_ARGS_OFFSET:
    return "ColossusISD::FRAME_TO_ARGS_OFFSET";
  case ColossusISD::MEM_BARRIER:    return "MEM_BARRIER";
  case ColossusISD::RTN:            return "RTN";
  case ColossusISD::RTN_REG_HOLDER: return "RTN_REG_HOLDER";
  case ColossusISD::SETLR:          return "SETLR";
  case ColossusISD::STACKSAVE:      return "STACKSAVE";
  case ColossusISD::STACKRESTORE:   return "STACKRESTORE";
  case ColossusISD::VERTEX_EXIT:    return "VERTEX_EXIT";
  case ColossusISD::WRAPPER:        return "WRAPPER";
  case ColossusISD::FNOT:           return "FNOT";
  case ColossusISD::FAND:           return "FAND";
  case ColossusISD::FOR:            return "FOR";
  case ColossusISD::ANDC:           return "ANDC";
  case ColossusISD::CONCAT_VECTORS: return "COLOSSUS_CONCAT_VECTORS";
  case ColossusISD::SORT4X16LO:     return "COLOSSUS_SORT4X16LO";
  case ColossusISD::SORT4X16HI:     return "COLOSSUS_SORT4X16HI";
  case ColossusISD::ROLL16:         return "COLOSSUS_ROLL16";
  case ColossusISD::FCMP:
    return "FCMP";
  case ColossusISD::F32_TO_SINT:    return "F32_TO_SINT";
  case ColossusISD::F32_TO_UINT:    return "F32_TO_UINT";
  case ColossusISD::SINT_TO_F32:    return "SINT_TO_F32";
  case ColossusISD::UINT_TO_F32:    return "UINT_TO_F32";
  case ColossusISD::F16ASV2F16:     return "F16ASV2F16";
  case ColossusISD::V2F16ASF16:     return "V2F16ASF16";
  case ColossusISD::FTANH:          return "FTANH";
  case ColossusISD::FRSQRT:         return "FRSQRT";
  case ColossusISD::FSIGMOID:       return "FSIGMOID";
  case ColossusISD::SORT8X8LO:      return "COLOSSUS_SORT8X8LO";
  case ColossusISD::SHUF8X8LO:      return "COLOSSUS_SHUF8X8LO";
  case ColossusISD::SHUF8X8HI:      return "COLOSSUS_SHUF8X8HI";
  case ColossusISD::STRICT_FCMPS:
    return "COLOSSUS_STRICT_FCMPS";
  case ColossusISD::STRICT_FRSQRT:  return "COLOSSUS_STRICT_FRSQRT";
  case ColossusISD::STRICT_F32_TO_SINT: 
    return "COLOSSUS_STRICT_F32_TO_SINT";
  case ColossusISD::STRICT_F32_TO_UINT: 
    return "COLOSSUS_STRICT_F32_TO_UINT";
  case ColossusISD::CLOOP_BEGIN_VALUE:
    return "CLOOP_BEGIN_VALUE";
  case ColossusISD::CLOOP_BEGIN_TERMINATOR:
    return "CLOOP_BEGIN_TERMINATOR";
  case ColossusISD::CLOOP_END_VALUE:
    return "CLOOP_END_VALUE";
  case ColossusISD::CLOOP_END_BRANCH:
    return "CLOOP_END_BRANCH";
  case ColossusISD::CLOOP_GUARD_BRANCH:
    return "CLOOP_GUARD_BRANCH";
  }
}

// Invoked when the result type is illegal
void ColossusTargetLowering::ReplaceNodeResults(
    SDNode *N, SmallVectorImpl<SDValue> &Results, SelectionDAG &DAG) const {
  switch (N->getOpcode()) {
  case ISD::FP_TO_UINT:
  case ISD::FP_TO_SINT:
  case ISD::STRICT_FP_TO_UINT:
  case ISD::STRICT_FP_TO_SINT: {
    LowerFP16ToInt(N, Results, DAG);
    return;
  }
  case ISD::SIGN_EXTEND_INREG: {
    if (SDValue r = LowerSIGN_EXTEND_INREG(SDValue(N, 0), DAG)) {
      Results.push_back(r);
    }
    return;
  }
  case ISD::INTRINSIC_W_CHAIN: {
    unsigned IntNo = cast<ConstantSDNode>(N->getOperand(1))->getZExtValue();
    if (IntNo == Intrinsic::colossus_ldstep) {
      assert(N->getNumValues() == 3);   // value, addr+incr*sizeof(ty), ch
      assert(N->getNumOperands() == 4); // ch, id, addr, incr
      for (unsigned i = 0; i < N->getNumValues(); i++) {
        Results.push_back(LowerINTRINSIC_W_CHAIN(SDValue(N, i), DAG));
      }
      return;
    }
    if (IntNo == Intrinsic::colossus_urand64) {
      assert(N->getNumValues() == 2);   // value, ch
      Results.push_back(LowerINTRINSIC_W_CHAIN(SDValue(N, 0), DAG));
      Results.push_back(N->getOperand(0));
      return;
    }
    llvm_unreachable("Unimplemented legalization of intrinsic with side " \
                      "effects in ReplaceNodeResults");
  }
  case ISD::INTRINSIC_WO_CHAIN: {
    unsigned IntNo = cast<ConstantSDNode>(N->getOperand(0))->getZExtValue();
    if (IntNo == Intrinsic::colossus_is_worker_mode) {
      // Technically more of a hack, as this legalizes the intrinsic moreso than
      // legalizing the return type of the intrinsic. Current target independent
      // type promotion doesn't support intrinsic promotion. However, i1 needs
      // to be ensured, hence this expension "hack".
      SDValue WorkerBaseReg = DAG.getRegister(Colossus::MWORKER_BASE, MVT::i32);
      SDValue ZeroReg = DAG.getRegister(Colossus::MZERO, MVT::i32);
      SDValue SetNotEqual = DAG.getSetCC(SDLoc(N), MVT::i1, WorkerBaseReg,
                                        ZeroReg, ISD::CondCode::SETNE);
      Results.push_back(SetNotEqual);
      return;
    }
    llvm_unreachable("Unimplemented legalization of intrinsic w/o side " \
                      "effects in ReplaceNodeResults");
  }
  default:
    // f16 types and vector float types get handled in
    // DAGTypeLegalizer::SoftPromoteHalfResult
    if (!N->getValueType(0).isFloatingPoint()) {
      LLVM_DEBUG(dbgs() << "ReplaceNodeResults: "; N->dump(&DAG);
                 dbgs() << "\n");
      llvm_unreachable("Unimplemented operand in ReplaceNodeResults");
    }
  }
}

// Invoked when the operand type is illegal and the result type legal
void ColossusTargetLowering::LowerOperationWrapper(
    SDNode *N, SmallVectorImpl<SDValue> &Results, SelectionDAG &DAG) const {
  switch (N->getOpcode()) {
  case ISD::UINT_TO_FP:
  case ISD::SINT_TO_FP:
  case ISD::STRICT_UINT_TO_FP:
  case ISD::STRICT_SINT_TO_FP: {
    LowerIntToFP16(N, Results, DAG);
    return;
  }
  case ISD::STORE: {
    if (N->getOperand(1).getValueType() == MVT::v4i8) {
      if (auto res = LowerSTORE(SDValue{N, 0}, DAG)) {
        Results.push_back(res);
      }
    }
    return;
  }
  case ISD::LOAD: {
    if (N->getOperand(1).getValueType() == MVT::v4i8) {
      if (auto res = LowerLOAD(SDValue{N, 0}, DAG)) {
        Results.push_back(res);
      }
    }
    return;
  }
  default: {
    // Default case is the same as the default implementation
    if (SDValue Res = LowerOperation(SDValue(N, 0), DAG)) {
      Results.push_back(Res);
    }
    return;
  }
  }
}

// Invoked when the operation is illegal, operands and result both legal types
SDValue ColossusTargetLowering::
LowerOperation(SDValue Op, SelectionDAG &DAG) const {
  switch (Op.getOpcode()) {
  default:
    llvm_unreachable("Unimplemented operand");
  case ISD::BlockAddress:         return LowerBlockAddress(Op, DAG);
  case ISD::ConstantPool:         return LowerConstantPool(Op, DAG);
  case ISD::GlobalAddress:        return LowerGlobalAddress(Op, DAG);
  case ISD::JumpTable:            return LowerJumpTable(Op, DAG);
  case ISD::FLT_ROUNDS_:          return LowerFLT_ROUNDS_(Op, DAG);
  case ISD::FRAME_TO_ARGS_OFFSET: return LowerFRAME_TO_ARGS_OFFSET(Op, DAG);
  case ISD::INTRINSIC_W_CHAIN:    return LowerINTRINSIC_W_CHAIN(Op, DAG);
  case ISD::INTRINSIC_WO_CHAIN:   return LowerINTRINSIC_WO_CHAIN(Op, DAG);
  case ISD::INTRINSIC_VOID:       return LowerINTRINSIC_VOID(Op, DAG);
  case ISD::RETURNADDR:           return LowerRETURNADDR(Op, DAG);
  case ISD::SETCC:
  case ISD::STRICT_FSETCC:
  case ISD::STRICT_FSETCCS:       return LowerSETCC(Op, DAG);
  case ISD::LOAD:                 return LowerLOAD(Op, DAG);
  case ISD::STORE:                return LowerSTORE(Op, DAG);
  case ISD::SIGN_EXTEND_INREG:    return LowerSIGN_EXTEND_INREG(Op, DAG);
  case ISD::UDIV:                 return LowerUDIV(Op, DAG);
  case ISD::UREM:                 return LowerUREM(Op, DAG);
  case ISD::MULHU:
  case ISD::MULHS:                return LowerMULHX(Op, DAG);
  case ISD::UMUL_LOHI:
  case ISD::SMUL_LOHI:            return LowerXMUL_LOHI(Op, DAG);
  case ISD::VAARG:                return LowerVAARG(Op, DAG);
  case ISD::VASTART:              return LowerVASTART(Op, DAG);
  case ISD::VECTOR_SHUFFLE:       return LowerVECTOR_SHUFFLE(Op, DAG);
  case ISD::SCALAR_TO_VECTOR:     return LowerSCALAR_TO_VECTOR(Op, DAG);
  case ISD::ATOMIC_FENCE:         return LowerATOMIC_FENCE(Op, DAG);
  case ISD::ATOMIC_LOAD:          return LowerATOMIC_LOAD(Op, DAG);
  case ISD::ATOMIC_STORE:         return LowerATOMIC_STORE(Op, DAG);
  case ISD::FABS:
  case ISD::FCOPYSIGN:            return LowerFABSorFCOPYSIGN(Op, DAG);
  case ISD::FADD:
  case ISD::STRICT_FADD:
  case ISD::FMAXNUM:
  case ISD::STRICT_FMAXNUM:
  case ISD::FMINNUM:
  case ISD::STRICT_FMINNUM:
  case ISD::FMUL:
  case ISD::STRICT_FMUL:
  case ISD::FSUB:
  case ISD::STRICT_FSUB:
    return recursiveLowerFPOperation(Op, DAG);
  case ISD::FNEG:                 return LowerFNEG(Op, DAG);
  case ISD::FCEIL:
  case ISD::STRICT_FCEIL:
  case ISD::FCOS:
  case ISD::STRICT_FCOS:
  case ISD::FDIV:
  case ISD::STRICT_FDIV:
  case ISD::FEXP2:
  case ISD::STRICT_FEXP2:
  case ISD::FEXP:
  case ISD::STRICT_FEXP:
  case ISD::FFLOOR:
  case ISD::STRICT_FFLOOR:
  case ISD::FLOG10:
  case ISD::STRICT_FLOG10:
  case ISD::FLOG2:
  case ISD::STRICT_FLOG2:
  case ISD::FLOG:
  case ISD::STRICT_FLOG:
  case ISD::FMA:
  case ISD::STRICT_FMA:
  case ISD::FNEARBYINT:
  case ISD::STRICT_FNEARBYINT:
  case ISD::FPOW:
  case ISD::STRICT_FPOW:
  case ISD::FREM:
  case ISD::STRICT_FREM:
  case ISD::FRINT:
  case ISD::STRICT_FRINT:
  case ISD::FROUND:
  case ISD::STRICT_FROUND:
  case ISD::FSIN:
  case ISD::STRICT_FSIN:
  case ISD::FSQRT:
  case ISD::STRICT_FSQRT:
  case ISD::FTRUNC:
  case ISD::STRICT_FTRUNC:        return LowerLibmIntrinsic(Op, DAG);
  case ISD::SMIN:
  case ISD::SMAX:                 return LowerSMINorSMAX(Op, DAG);
  }
}

MachineBasicBlock *ColossusTargetLowering::
EmitInstrWithCustomInserter(MachineInstr &MI, MachineBasicBlock *MBB) const {
  switch (MI.getOpcode()) {
  default: llvm_unreachable("Unknown instruction with custom inserter");
  case Colossus::SELECT_F16:
  case Colossus::SELECT_V2F16:
  case Colossus::SELECT_V4F16:
  case Colossus::SELECT_F32:
  case Colossus::SELECT_V2F32:
    return expandFPSelect(&MI, MBB);
  }
}

/// Create a new basic block after MBB.
static MachineBasicBlock *emitBlockAfter(MachineBasicBlock *MBB) {
  MachineFunction &MF = *MBB->getParent();
  MachineBasicBlock *NewMBB = MF.CreateMachineBasicBlock(MBB->getBasicBlock());
  MF.insert(std::next(MachineFunction::iterator(MBB)), NewMBB);
  return NewMBB;
}

/// Split MBB before MI and return the new block (the one that contains MI).
static MachineBasicBlock *splitBlockBefore(MachineInstr *MI,
                                           MachineBasicBlock *MBB) {
  MachineBasicBlock *NewMBB = emitBlockAfter(MBB);
  NewMBB->splice(NewMBB->begin(), MBB, MI, MBB->end());
  NewMBB->transferSuccessorsAndUpdatePHIs(MBB);
  return NewMBB;
}

/// Expand
///   %result = select %cond, %true, %false
/// into:
///   StartMBB:
///     BRNZ $cond, JoinBB
///     # fallthrough
///   FalseMBB:
///     # fallthrough
///   TrueMBB:
///     %result = phi [ %false, FalseMBB ], [ %true, StartMBB ]
MachineBasicBlock *ColossusTargetLowering::
expandFPSelect(MachineInstr *MI, MachineBasicBlock *MBB) const {

  const ColossusInstrInfo *CII = Subtarget.getInstrInfo();
  MachineRegisterInfo &RegInfo = MI->getParent()->getParent()->getRegInfo();
  DebugLoc dl = MI->getDebugLoc();

  unsigned DestReg = MI->getOperand(0).getReg();
  unsigned CondReg = MI->getOperand(1).getReg();
  unsigned TrueReg = MI->getOperand(2).getReg();
  unsigned FalseReg = MI->getOperand(3).getReg();

  MachineBasicBlock *StartMBB = MBB;
  MachineBasicBlock *JoinMBB = splitBlockBefore(MI, MBB);
  MachineBasicBlock *FalseMBB = emitBlockAfter(StartMBB);

  if (Colossus::ARRegClass.contains(CondReg)) {
    // If the condition is in an A register, move it to an M register.
    unsigned VMReg = RegInfo.createVirtualRegister(&Colossus::MRRegClass);
    BuildMI(MBB, dl, CII->get(Colossus::ATOM), VMReg)
      .addReg(CondReg)
      .addImm(0 /* Coissue bit */);
    CondReg = VMReg;
  }

  // StartMBB:
  //   ...
  MBB = StartMBB;
  BuildMI(MBB, dl, CII->get(Colossus::BRNZ))
      .addReg(CondReg)
    .addMBB(JoinMBB)
    .addImm(0 /* Coissue bit */);
  MBB->addSuccessor(JoinMBB);
  MBB->addSuccessor(FalseMBB);

  // FalseMBB:
  //   ...
  MBB = FalseMBB;
  MBB->addSuccessor(JoinMBB);

  // JoinMBB:
  //   ...
  MBB = JoinMBB;
  BuildMI(*MBB, MI, dl, CII->get(Colossus::PHI), DestReg)
      .addReg(TrueReg).addMBB(StartMBB)
      .addReg(FalseReg).addMBB(FalseMBB);

  MI->eraseFromParent();
  return JoinMBB;
}

/// Returns true and, by reference, base pointer, offset pointer and addressing
/// mode, if this node can be combined with a load / store to form a
/// post-indexed load / store.
bool ColossusTargetLowering::
getPostIndexedAddressParts(SDNode *N,
                           SDNode *Op,
                           SDValue &Base,
                           SDValue &Offset,
                           ISD::MemIndexedMode &AM,
                           SelectionDAG &DAG) const {
  if (Op->getOpcode() != ISD::ADD &&
      Op->getOpcode() != ISD::SUB) {
    return false;
  }

  // Get the memory value type.
  EVT VT;
  if (LoadSDNode *LD = dyn_cast<LoadSDNode>(N)) {
    VT = LD->getMemoryVT();
  } else if (StoreSDNode *ST = dyn_cast<StoreSDNode>(N)) {
    VT = ST->getMemoryVT();
  } else {
    return false;
  }

  if (ConstantSDNode *RHS = dyn_cast<ConstantSDNode>(Op->getOperand(1))) {
    int64_t IncVal = RHS->getSExtValue();
    if (Op->getOpcode() == ISD::SUB) {
      IncVal = -IncVal;
    }

    // 8 bits are available for the immediate step value.
    constexpr unsigned Simm = 8;

    if (VT.getStoreSize() == 8) {
      if (!isShiftedInt<Simm, 3>(IncVal)) {
        return false;
      }
    } else if (VT.getStoreSize() == 4) {
      if (!isShiftedInt<Simm, 2>(IncVal)) {
        return false;
      }
    } else if (VT.getStoreSize() == 2) {
      if (!isShiftedInt<Simm, 1>(IncVal)) {
        return false;
      }
    } else if (VT.getStoreSize() == 1) {
      if (!isInt<Simm>(IncVal)) {
        return false;
      }
    } else {
      llvm_unreachable("Unknown memory VT");
    }

    // Post-increment loads only support 8-bit signed immediate increments.
    Base = Op->getOperand(0);
    Offset = DAG.getConstant(IncVal, SDLoc(N), MVT::i32);
    AM = ISD::POST_INC;
    return true;
  }

  return false;
}

namespace {
using CTL = ColossusTargetLowering;

SDValue locallyVectorize16BitOp(SDValue Op, SelectionDAG &DAG,
                                bool undefIsValid) {
  // floating point arithmetic broadcasts the value across both
  // lanes in order to keep exception handling consistent.
  // bitwise operations don't raise exceptions so can use undef.
  SDLoc dl(Op);
  unsigned Opc = Op.getOpcode();
  unsigned numOperands = Op.getNumOperands();
  bool strictFP = Op.getNode()->isStrictFPOpcode();
  unsigned firstValueArgument = strictFP ? 1 : 0;
  unsigned numValueOperands = numOperands - firstValueArgument;
  assert(numValueOperands == 1 || numValueOperands == 2);
  SDValue Chain = Op.getOperand(0);

  EVT argTy = Op.getOperand(firstValueArgument).getValueType();
  assert(numValueOperands == 1 ||
         argTy == Op.getOperand(firstValueArgument + 1).getValueType());
  EVT resTy = Op.getValueType();

  auto toVecTy = [](EVT Ty) {
    assert(Ty == MVT::f16 || Ty == MVT::i16);
    return Ty == MVT::f16 ? MVT::v2f16 : MVT::v2i16;
  };

  SDValue OpU = DAG.getUNDEF(argTy);

  SDValue Op0 = Op.getOperand(firstValueArgument);
  SDValue Op0Hi = undefIsValid ? OpU : Op0;
  SDValue Op0Vec =
      DAG.getNode(ISD::BUILD_VECTOR, dl, toVecTy(argTy), Op0, Op0Hi);

  SDValue Vectorized;
  if (numValueOperands == 1) {
    if (strictFP) {
      Vectorized =
          DAG.getNode(Opc, dl, {toVecTy(resTy), MVT::Other}, {Chain, Op0Vec});
    } else {
      Vectorized = DAG.getNode(Opc, dl, toVecTy(resTy), Op0Vec);
    }
  } else {
    assert(numValueOperands == 2);
    SDValue Op1 = Op.getOperand(firstValueArgument + 1);
    SDValue Op1Hi = undefIsValid ? OpU : Op1;
    SDValue Op1Vec =
        DAG.getNode(ISD::BUILD_VECTOR, dl, toVecTy(argTy), Op1, Op1Hi);
    if (strictFP) {
      Vectorized = DAG.getNode(Opc, dl, {toVecTy(resTy), MVT::Other},
                               {Chain, Op0Vec, Op1Vec});
    } else {
      Vectorized = DAG.getNode(Opc, dl, toVecTy(resTy), Op0Vec, Op1Vec);
    }
  }

  SDValue Zero = DAG.getConstant(0, dl, MVT::i32);
  SDValue Extract =
      DAG.getNode(ISD::EXTRACT_VECTOR_ELT, dl, resTy, Vectorized, Zero);
  if (!strictFP) {
    return Extract;
  }

  Chain = Vectorized.getValue(1);
  return DAG.getMergeValues({Extract, Chain}, dl);
}

bool isConstantMinusOne(SDValue N) {
  if (isAllOnesConstant(N)) {
    return true;
  }
  if (ConstantFPSDNode *CF = dyn_cast<ConstantFPSDNode>(N)) {
    return CF->getValueAPF().bitcastToAPInt().isAllOnesValue();
  }
  return false;
}

bool allBitsSet(SDValue Op) {
  // Test whether integer or floating point scalar or vectors
  // are a constant value with all bits set.
  Op = peekThroughBitcasts(Op);
  if (isConstantMinusOne(Op)) {
    return true;
  }
  if (ISD::isBuildVectorAllOnes(Op.getNode())) {
    return true;
  }
  if (Op.getOpcode() == ColossusISD::CONCAT_VECTORS) {
    assert(Op.getNumOperands() == 2);
    return allBitsSet(Op.getOperand(0)) && allBitsSet(Op.getOperand(1));
  }
  return false;
}

bool allBitsClear(SDValue Op) {
  Op = peekThroughBitcasts(Op);
  if (isNullConstant(Op) || isNullFPConstant(Op)) {
    return true;
  }
  if (ISD::isBuildVectorAllZeros(Op.getNode())) {
    return true;
  }
  if (Op.getOpcode() == ColossusISD::CONCAT_VECTORS) {
    assert(Op.getNumOperands() == 2);
    return allBitsClear(Op.getOperand(0)) && allBitsClear(Op.getOperand(1));
  }
  return false;
}

bool isCanonicalConstant(SDValue Op) {
  if (!Op) {
    return false;
  }
  EVT VT = Op.getValueType();

  // Either a constant or a build vector of constants, without bitcasts
  // and without truncation for build vector of integers
  if (dyn_cast<ConstantSDNode>(Op) || dyn_cast<ConstantFPSDNode>(Op)) {
    return true;
  }

  if (VT == MVT::v4f16 || VT == MVT::v4i16) {
    if (Op.getOpcode() == ColossusISD::CONCAT_VECTORS) {
      assert(Op.getNumOperands() == 2);
      return isCanonicalConstant(Op.getOperand(0)) &&
             isCanonicalConstant(Op.getOperand(1));
    } else {
      return false;
    }
  }

  if (Op.getOpcode() == ISD::BUILD_VECTOR) {
    for (const SDValue &elt : Op->op_values()) {
      ConstantSDNode *i = dyn_cast<ConstantSDNode>(elt);
      ConstantFPSDNode *f = dyn_cast<ConstantFPSDNode>(elt);
      bool nonTruncatingInt =
          i && isUIntN(VT.getScalarSizeInBits(), i->getZExtValue());
      if (!(f || nonTruncatingInt)) {
        return false;
      }
    }
    return true;
  }

  return false;
}

bool isBuildVectorOfConstantNodes(SDValue Op) {
  if (Op.getOpcode() != ISD::BUILD_VECTOR) {
    return false;
  }

  for (auto const &val : Op->op_values()) {
    if (val.isUndef()) {
      continue;
    }
    if (isa<ConstantSDNode>(val) || isa<ConstantFPSDNode>(val)) {
      continue;
    }
    return false;
  }

  return true;
}

SDValue makeCanonicalConstant(uint64_t value, EVT VT, SDLoc dl,
                              SelectionDAG &DAG) {
  // Similar to SelectionDAG::getConstant and SelectionDAG::getConstantFP
  // Constructs a constant of the requested legal type.
  uint32_t H[2] = {
      static_cast<uint32_t>(value >> 00u),
      static_cast<uint32_t>(value >> 32u),
  };

  uint16_t Q[4] = {
      static_cast<uint16_t>(value >> 00u),
      static_cast<uint16_t>(value >> 16u),
      static_cast<uint16_t>(value >> 32u),
      static_cast<uint16_t>(value >> 48u),
  };

  unsigned SB = VT.getSizeInBits();
  if ((SB == 64) || ((SB == 32) && (H[1] == 0)) ||
      ((SB == 16) && ((Q[3] | Q[2] | Q[1]) == 0))) {

    if (VT == MVT::f16) {
      APFloat apflo = APFloat(APFloatBase::IEEEhalf(), APInt(16, Q[0]));
      return DAG.getConstantFP(apflo, dl, MVT::f16);
    }

    if (VT == MVT::f32) {
      APFloat apf = APFloat(APFloatBase::IEEEsingle(), APInt(32, value));
      return DAG.getConstantFP(apf, dl, MVT::f32);
    }

    if (VT == MVT::i32) {
      return DAG.getConstant(H[0], dl, MVT::i32);
    }

    if (VT == MVT::v2i16 || VT == MVT::v2f16) {
      EVT ElType = VT == MVT::v2i16 ? MVT::i32 : MVT::f16;
      return DAG.getNode(ISD::BUILD_VECTOR, dl, VT,
                         makeCanonicalConstant(Q[0], ElType, dl, DAG),
                         makeCanonicalConstant(Q[1], ElType, dl, DAG));
    }

    if (VT == MVT::v2i32 || VT == MVT::v2f32) {
      EVT ElType = VT == MVT::v2i32 ? MVT::i32 : MVT::f32;
      return DAG.getNode(ISD::BUILD_VECTOR, dl, VT,
                         makeCanonicalConstant(H[0], ElType, dl, DAG),
                         makeCanonicalConstant(H[1], ElType, dl, DAG));
    }

    if (VT == MVT::v4i16 || VT == MVT::v4f16) {
      EVT HalfType = VT == MVT::v4i16 ? MVT::v2i16 : MVT::v2f16;
      return DAG.getNode(ColossusISD::CONCAT_VECTORS, dl, VT,
                         makeCanonicalConstant(H[0], HalfType, dl, DAG),
                         makeCanonicalConstant(H[1], HalfType, dl, DAG));
    }
  }

  return SDValue();
}

SDValue getCanonicalConstant(SDValue Op, SelectionDAG &DAG) {
  if (isCanonicalConstant(Op)) {
    return Op;
  }

  auto maybeValue = ColossusTargetLowering::SDValueToUINT64(Op, DAG);
  if (maybeValue.hasValue()) {
    SDValue res = makeCanonicalConstant(maybeValue.getValue(),
                                        Op.getValueType(), SDLoc(Op), DAG);
    assert(isCanonicalConstant(res));
    return res;
  }

  return SDValue();
}

MVT queryConcatType(EVT VT) {
  auto numElems = 2u;
  EVT scalarType = VT;

  if (VT.isVector()) {
    numElems = VT.getVectorNumElements() * 2;
    scalarType = VT.getVectorElementType();
  }

  return MVT::getVectorVT(scalarType.getSimpleVT(), numElems);
}

SDValue concatValues(SDValue lo, SDValue hi, SelectionDAG &DAG,
                     MVT outputType) {
  EVT VT = lo.getValueType();
  assert(VT == hi.getValueType());
  assert(VT.getSizeInBits() <= 32);
  assert((std::set<MVT>{MVT::v2f16, MVT::v2f32, MVT::v4f16, MVT::v2i16,
                        MVT::v2i32, MVT::v4i16}
              .count(outputType) == 1));

  assert((outputType == queryConcatType(VT)) ||
         (outputType == MVT::v2i16 && VT == MVT::i32));

  unsigned concatOpcode = VT.isVector() ? (unsigned)ColossusISD::CONCAT_VECTORS
                                        : (unsigned)ISD::BUILD_VECTOR;

  return DAG.getNode(concatOpcode, SDLoc{lo}, outputType, lo, hi);
}

SDValue concatValues(SDValue lo, SDValue hi, SelectionDAG &DAG) {
  auto const VT = lo.getValueType();
  return concatValues(lo, hi, DAG, queryConcatType(VT));
}

std::pair<SDValue, SDValue> splitValue(SDValue value, SelectionDAG &DAG) {
  auto const VT = value.getValueType();
  assert((std::set<MVT>{MVT::v2f16, MVT::v2f32, MVT::v4f16, MVT::v2i16,
                        MVT::v2i32, MVT::v4i16}
              .count(VT.getSimpleVT()) == 1));

  auto indexScaling = 1u;
  auto halfWidthType = VT.getVectorElementType();
  auto extractOpcode = unsigned{ISD::EXTRACT_VECTOR_ELT};

  auto const halfNumElems = VT.getVectorNumElements() / 2;

  if (halfNumElems > 1) {
    indexScaling = 2u;
    halfWidthType = MVT::getVectorVT(halfWidthType.getSimpleVT(), halfNumElems);
    extractOpcode = ISD::EXTRACT_SUBVECTOR;
  } else if (halfWidthType == MVT::i16) {
    halfWidthType = MVT::i32;
  }

  SDLoc dl{value};

  auto extractHalf = [&](unsigned index) {
    auto const extractArg = DAG.getConstant(index * indexScaling, dl, MVT::i32);
    return DAG.getNode(extractOpcode, dl, halfWidthType, value, extractArg);
  };

  return std::make_pair(extractHalf(0), extractHalf(1));
}

static SDValue deriveStoreFromExisting(SelectionDAG &DAG, StoreSDNode *STNode,
                                       SDValue Value) {
  // Make a store node that writes Value to the same place that Store currently
  // writes some different value. Note this will not attempt to create
  // truncating stores
  SDLoc dl(STNode);
  SDValue Addr = STNode->getBasePtr();
  SDValue derived =
      DAG.getStore(STNode->getChain(), dl, Value, Addr,
                   STNode->getPointerInfo(), STNode->getAlignment(),
                   STNode->getMemOperand()->getFlags(), STNode->getAAInfo());
  if (STNode->isIndexed()) {
    derived = DAG.getIndexedStore(derived, dl, Addr, STNode->getOffset(),
                                  STNode->getAddressingMode());
  }
  return derived;
}

SDValue performExtendVectorInregCanonicalisation(SDNode *N, SelectionDAG &DAG) {
  // Expand extendvectorinreg whenever it occurs. This fixes T1741 by working
  // around incorrect type legalisation of any_extend_vector_inreg.
  // The semantics are a direct translation of the comment block in ISDOpcodes.h
  // Keep the N lowest lanes of the input, where N is the number of lanes output
  // extending each individually until the output bitwidth equals the input
  unsigned Opc = N->getOpcode();
  assert(Opc == ISD::ANY_EXTEND_VECTOR_INREG ||
         Opc == ISD::SIGN_EXTEND_VECTOR_INREG ||
         Opc == ISD::ZERO_EXTEND_VECTOR_INREG);

  SDValue Op = SDValue(N, 0);
  SDLoc dl(Op);
  assert(Op.getNumOperands() == 1);
  SDValue inVec = Op.getOperand(0);
  EVT outVT = Op.getValueType();
  EVT inVT = inVec.getValueType();

  assert(outVT.isInteger() && outVT.isVector());
  assert(inVT.isInteger() && inVT.isVector());
  assert(inVT.getSizeInBits() == outVT.getSizeInBits());

  unsigned outLanes = outVT.getVectorNumElements();
  assert(outLanes < inVT.getVectorNumElements());

  // The only case that can be created after type legalisation is v4i16 => v2i32
  // The intermediate type is then v2i16 which is also legal so there is no need
  // to scalarize the intermediate value here.
  EVT lowLanesType = EVT::getVectorVT(*DAG.getContext(),
                                      inVT.getVectorElementType(), outLanes);
  SmallVector<SDValue, 4> elements;
  for (unsigned i = 0; i < outLanes; i++) {
    // Round up to i32 to ensure the intermediate value is type legal
    // extract_vector_elt creates a larger type then build_vector truncates it
    EVT EltVT = lowLanesType.getScalarSizeInBits() < 32
                    ? MVT::i32
                    : lowLanesType.getVectorElementType();
    elements.push_back(DAG.getNode(ISD::EXTRACT_VECTOR_ELT, dl, EltVT, inVec,
                                   DAG.getConstant(i, dl, MVT::i32)));
  }

  SDValue lowLanesOfInput = DAG.getBuildVector(lowLanesType, dl, elements);
  assert(lowLanesOfInput.getValueType().getSizeInBits() < inVT.getSizeInBits());

  switch (Opc) {
  default:
    llvm_unreachable("Unknown opcode when combining extend vector inreg");
  case ISD::ANY_EXTEND_VECTOR_INREG:
    return DAG.getAnyExtOrTrunc(lowLanesOfInput, dl, outVT);
  case ISD::SIGN_EXTEND_VECTOR_INREG:
    return DAG.getSExtOrTrunc(lowLanesOfInput, dl, outVT);
  case ISD::ZERO_EXTEND_VECTOR_INREG:
    return DAG.getZExtOrTrunc(lowLanesOfInput, dl, outVT);
  }
}

SDValue removeVariableIndexInsertOrExtract(
    SDNode *N, SelectionDAG &DAG, TargetLowering::DAGCombinerInfo &DCI) {
  unsigned opc = N->getOpcode();
  assert(opc == ISD::EXTRACT_VECTOR_ELT || opc == ISD::INSERT_VECTOR_ELT);
  if (!DCI.isAfterLegalizeDAG()) {
    return SDValue();
  }
  SDLoc dl(N);
  EVT VT = N->getValueType(0);

  SDValue vec = N->getOperand(0);
  SDValue val;
  SDValue idx;

  if (opc == ISD::EXTRACT_VECTOR_ELT) {
    idx = N->getOperand(1);
  } else {
    val = N->getOperand(1);
    idx = N->getOperand(2);
  }

  unsigned n = vec.getValueType().getVectorNumElements();

  auto getFixedIndex = [&](unsigned i) {
    assert(i < n);
    if (opc == ISD::EXTRACT_VECTOR_ELT) {
      return DAG.getNode(ISD::EXTRACT_VECTOR_ELT, dl, VT, vec,
                         DAG.getConstant(i, dl, MVT::i32));
    } else {
      return DAG.getNode(ISD::INSERT_VECTOR_ELT, dl, VT, vec, val,
                         DAG.getConstant(i, dl, MVT::i32));
    }
  };

  // This function lowers an operation at unknown index to exactly the
  // same pattern previously targeted by InstrInfo.td.
  // The motivation is to allow broadcast instructions to assume that extract
  // and insert element always use a constant index, and to potentially enable
  // other DAGCombines to improve code in the branches.
  // The code generated for vectors of length 4 can be improved by removing
  // a select and using the index-as-condition trick used by length 2 twice

  if (!dyn_cast<ConstantSDNode>(idx)) {
    // When index is a variable, expand to select between constant indices
    if (n == 2) {
      // Then index is either 0 or 1, else undefined behaviour
      // so it can be used as the condition of select
      assert(idx.getValueType() == MVT::i32);
      return DAG.getNode(ISD::SELECT, dl, VT, idx, getFixedIndex(1),
                         getFixedIndex(0));
    }

    if (n == 4) {
      SDValue pred[4];
      for (unsigned i = 0; i < 4; i++) {
        pred[i] = DAG.getSetCC(dl, MVT::i32, idx,
                               DAG.getConstant(i, dl, MVT::i32), ISD::SETEQ);
      }
      auto getSelect = [&](SDValue pred, SDValue cons, SDValue alt) {
        return DAG.getNode(ISD::SELECT, dl, VT, pred, cons, alt);
      };

      return getSelect(pred[0], getFixedIndex(0),
                       getSelect(pred[1], getFixedIndex(1),
                                 getSelect(pred[2], getFixedIndex(2),
                                           getSelect(pred[3], getFixedIndex(3),
                                                     DAG.getUNDEF(VT)))));
    }
  }

  return SDValue();
}

SDValue performExtractVectorEltCanonicalisation(
    SDNode *N, SelectionDAG &DAG, TargetLowering::DAGCombinerInfo &DCI) {
  assert(N->getOpcode() == ISD::EXTRACT_VECTOR_ELT);
  if (!DCI.isAfterLegalizeDAG()) {
    return SDValue();
  }

  if (SDValue cvi = removeVariableIndexInsertOrExtract(N, DAG, DCI)) {
    return cvi;
  }

  SDLoc dl(N);
  EVT VT = N->getValueType(0);

  SDValue vec = N->getOperand(0);
  uint64_t idx = cast<ConstantSDNode>(N->getOperand(1))->getZExtValue();

  auto lowerExtract = [&](EVT VT, SDValue src, uint64_t idx) {
    EVT VecVT = src.getValueType();
    assert(VecVT == MVT::v2f16 || VecVT == MVT::v2i16);
    unsigned op = idx == 0 ? ColossusISD::SORT4X16LO : ColossusISD::SORT4X16HI;

    SDValue extracted = DAG.getNode(op, dl, VecVT, src, DAG.getUNDEF(VecVT));
    if (VT == MVT::f16) {
      return DAG.getNode(ColossusISD::V2F16ASF16, dl, MVT::f16, extracted);
    } else {
      assert(VT == MVT::i32);
      return DAG.getBitcast(MVT::i32, extracted);
    }
  };

  EVT VecVT = vec.getValueType();
  if (VecVT == MVT::v2f16 || VecVT == MVT::v2i16)
    {
      return lowerExtract(VT, vec, idx);
    }

  if (VecVT == MVT::v4f16 || VecVT == MVT::v4i16)
    {
      auto split = splitValue(vec, DAG);
      bool lowHalf = (idx == 0 || idx == 1);
      auto subvec = lowHalf ? split.first : split.second;
      uint64_t subidx = lowHalf ? idx : idx - 2;
      return lowerExtract(VT, subvec, subidx);
    }

  return SDValue();
}

SDValue performInsertVectorEltCanonicalisation(
    SDNode *N, SelectionDAG &DAG, TargetLowering::DAGCombinerInfo &DCI) {
  assert(N->getOpcode() == ISD::INSERT_VECTOR_ELT);
  if (!DCI.isAfterLegalizeDAG()) {
    return SDValue();
  }

  if (SDValue cvi = removeVariableIndexInsertOrExtract(N, DAG, DCI)) {
    return cvi;
  }

  SDLoc dl(N);
  EVT VT = N->getValueType(0);

  SDValue vec = N->getOperand(0);
  assert(vec.getValueType() == VT);
  SDValue val = N->getOperand(1);
  uint64_t idx = cast<ConstantSDNode>(N->getOperand(2))->getZExtValue();

  auto lowerInsert = [&](SDValue src, SDValue val, uint64_t idx) {
    // Translate a v2x16 insert into an extract and a build_vector
    EVT VecVT = src.getValueType();
    EVT EltVT = val.getValueType();
    assert(VecVT == MVT::v2f16 || VecVT == MVT::v2i16);
    assert(idx == 0 || idx == 1);

    // inserting at idx, preserve value at other_idx
    uint64_t other_idx = (idx == 0) ? 1 : 0;

    SmallVector<SDValue,2> p = {SDValue(), SDValue(),};
    p[idx] = val;
    p[other_idx] = DAG.getNode(ISD::EXTRACT_VECTOR_ELT, dl, EltVT,
                               src, DAG.getConstant(other_idx, dl, MVT::i32));
    return DAG.getBuildVector(VecVT, dl, p);
  };

  if (VT == MVT::v2f16 || VT == MVT::v2i16) {
    return lowerInsert(vec, val, idx);
  }

  if (VT == MVT::v4f16 || VT == MVT::v4i16) {
    // Extract subvectors, insert into one of them, concatenate
    auto subvec = splitValue(vec, DAG);
    if (idx < 2) {
      subvec.first = lowerInsert(subvec.first, val, idx);
    } else {
      subvec.second = lowerInsert(subvec.second, val, idx - 2);
    }
    return concatValues(subvec.first,
                                                subvec.second, DAG);
  }

  return SDValue();
}

SDValue performBuildVectorCombine(SDNode *N, SelectionDAG &DAG,
                                  TargetLowering::DAGCombinerInfo &DCI) {
  assert(N->getOpcode() == ISD::BUILD_VECTOR);
  if (!DCI.isAfterLegalizeDAG()) {
    return SDValue();
  }

  SDLoc dl(N);
  EVT VT = N->getValueType(0);

  if (isCanonicalConstant(SDValue(N, 0))) {
    return SDValue();
  }
  else if (auto constant = getCanonicalConstant(SDValue(N, 0), DAG)) {
    return constant;
  }

  if (VT == MVT::v4i16 || VT == MVT::v4f16) {
    assert(N->getNumOperands() == 4);
    MVT halfVT = VT == MVT::v4i16 ? MVT::v2i16 : MVT::v2f16;
    SDValue low_half = DAG.getNode(ISD::BUILD_VECTOR, dl, halfVT,
                                   N->getOperand(0), N->getOperand(1));
    SDValue high_half = DAG.getNode(ISD::BUILD_VECTOR, dl, halfVT,
                                    N->getOperand(2), N->getOperand(3));
    return DAG.getNode(ColossusISD::CONCAT_VECTORS, dl, VT, low_half,
                       high_half);
  }

  if (VT == MVT::v2i16 || VT == MVT::v2f16) {
    if (isBuildVectorOfConstantNodes(SDValue{N, 0})) {
      return {};
    }

    SDValue Op[2] = {N->getOperand(0), N->getOperand(1)};
    for (unsigned i = 0; i < 2; i++) {
      if (VT == MVT::v2f16) {
        assert(Op[i].getValueType() == MVT::f16);
        Op[i] = DAG.getNode(ColossusISD::F16ASV2F16, dl, VT, Op[i]);
        assert(Op[i].getValueType() == MVT::v2f16);
      } else {
        assert(Op[i].getValueType() == MVT::i32);
        Op[i] = DAG.getBitcast(MVT::v2i16, Op[i]);
        assert(Op[i].getValueType() == MVT::v2i16);
      }
    }
    return DAG.getNode(ColossusISD::SORT4X16LO, dl, VT, Op[0], Op[1]);
  }

  return SDValue();
}

SDValue performExtractVectorEltCombine(SDNode *N, SelectionDAG &DAG,
                                       TargetLowering::DAGCombinerInfo &DCI) {
  // (extract_vector_elt (build_vector x y) i) => x or y when the types match
  assert(N->getOpcode() == ISD::EXTRACT_VECTOR_ELT);

  auto index = dyn_cast<ConstantSDNode>(N->getOperand(1));
  SDValue vec = N->getOperand(0);
  EVT VT = vec.getValueType();
  if (index && (vec.getOpcode() == ISD::BUILD_VECTOR)) {
    auto i = index->getZExtValue();
    if (i < VT.getVectorNumElements()) {
      SDValue op = vec.getOperand(i);
      EVT resVT = N->getValueType(0);
      EVT argVT = op.getValueType();
      EVT midVT = VT.getVectorElementType();
      // build_vector has truncating semantics and extract_vector_elt
      // has extending semantics. Only transform if all types match.
      if (resVT == argVT && resVT == midVT) {
        return op;
      }
    }
  }
  return SDValue();
}

SDValue performExtractSubvectorCombine(SDNode *N, SelectionDAG &DAG) {
  assert(N->getOpcode() == ISD::EXTRACT_SUBVECTOR);

  auto dl = SDLoc{N};
  auto VT = N->getValueType(0u);
  auto op0 = N->getOperand(0u);
  auto index = N->getOperand(1u);
  auto opcode = op0.getOpcode();

  // This case specifically targets a MERGE_VALUES node of two operands. The
  // first operand must have the value type expected by EXTRACT_SUBVECTOR, and
  // the second operand must be a chain.
  //
  auto handleMergeValues = [&]() -> SDValue {
    auto merge = op0;
    if (merge.getNumOperands() != 2u) {
      return {};
    }
    auto val = merge.getOperand(0u);
    auto mergeVT = val.getValueType();
    auto vecElemVT = VT.getVectorElementType();
    if (!mergeVT.isVector() || mergeVT.getVectorElementType() != vecElemVT) {
      return {};
    }
    auto chain = merge.getOperand(1u);
    if (chain.getValueType() != MVT::Other) {
      return {};
    }
    return DAG.getNode(ISD::EXTRACT_SUBVECTOR, dl, VT, val, index);
  };

  auto handleConcatVectors = [&]() -> SDValue {
    auto concat = op0;
    if (concat.getOperand(0u).getValueType() != VT) {
      return {};
    }
    auto maybeVal = CTL::SDValueToUINT64(index, DAG);
    if (!maybeVal) {
      return {};
    }
    auto indexVal = unsigned(*maybeVal) / VT.getVectorNumElements();
    return concat.getOperand(indexVal);
  };

  switch (opcode) {
    case ISD::MERGE_VALUES: {
      return handleMergeValues();
    }
    case ISD::CONCAT_VECTORS:
    case ColossusISD::CONCAT_VECTORS: {
      return handleConcatVectors();
    }
  }

  return {};
}

SDValue isBitwiseNotOfExistingNode(SDValue N) {
  // Returns the existing node if available, otherwise SDValue()
  // The caller will need to handle bitcasting to an appropriate type

  if (N.getOpcode() == ColossusISD::FNOT) {
    return N.getOperand(0);
  }

  if (N.getOpcode() == ISD::XOR) {
    if (allBitsSet(N.getOperand(1))) {
      return N.getOperand(0);
    }
  }

  if (N.getOpcode() == ISD::BITCAST) {
    return isBitwiseNotOfExistingNode(N->getOperand(0));
  }

  return SDValue();
}

SDValue changeBitwiseOpSide(SDValue N, SelectionDAG &DAG, EVT ViaTy) {
  // Moves an operation between main and aux sides by wrapping input and output
  // in bitcasts to the specified type
  // Requires unary or binary operation.
  // On success, returned SDValue has the same type as N
  // On failure, returns SDValue(), e.g. can't always replace xor => not

  SDLoc dl(N);
  EVT ArgTy = N.getValueType();

  assert((ArgTy.isInteger() && ViaTy.isFloatingPoint()) ||
         (ArgTy.isFloatingPoint() && ViaTy.isInteger()));
  assert(N.getNumOperands() == 1 || N.getNumOperands() == 2);

  if (SDValue NotOp = isBitwiseNotOfExistingNode(N)) {
    SDValue typedNotOp = DAG.getBitcast(ViaTy, NotOp);
    SDValue changedNode =
        ArgTy.isInteger()
            ? DAG.getNode(ColossusISD::FNOT, dl, ViaTy, typedNotOp)
            : DAG.getNode(ISD::XOR, dl, ViaTy, typedNotOp,
                          DAG.getAllOnesConstant(dl, ViaTy));
    return DAG.getBitcast(ArgTy, changedNode);
  } else {
    unsigned other = ISD::DELETED_NODE; // Any sentinel
    unsigned op = N.getOpcode();

    // Binary nodes that can execute on the other side
    static const std::pair<unsigned, unsigned> map[] = {
        {ISD::AND, ColossusISD::FAND},
        {ISD::OR, ColossusISD::FOR},
        {ColossusISD::ANDC, ColossusISD::ANDC},
        {ColossusISD::SORT4X16LO, ColossusISD::SORT4X16LO},
        {ColossusISD::SORT4X16HI, ColossusISD::SORT4X16HI},
        {ColossusISD::ROLL16, ColossusISD::ROLL16},
    };
    for (auto p : map) {
      if (op == p.first) {
        other = p.second;
      }
      if (op == p.second) {
        other = p.first;
      }
    }

    if (other != ISD::DELETED_NODE) {
      SDValue C0 = DAG.getBitcast(ViaTy, N.getOperand(0));
      SDValue C1 = DAG.getBitcast(ViaTy, N.getOperand(1));
      SDValue R = DAG.getNode(other, dl, ViaTy, C0, C1);
      SDValue RC = DAG.getBitcast(ArgTy, R);
      return RC;
    }
  }

  return SDValue();
}

SDValue changeBitwiseOpSide(SDValue N, SelectionDAG &DAG) {
  // Convenience wrapper. Picks a reasonable default for the intermediate
  // type for changeBitwiseOpSide.
  static const std::pair<MVT, MVT> changeTypeSideMap[] = {
      {MVT::i16, MVT::f16},     {MVT::i32, MVT::f32},
      {MVT::v2i16, MVT::v2f16}, {MVT::v2i32, MVT::v2f32},
      {MVT::v4i16, MVT::v4f16},
  };

  EVT ArgTy = N.getValueType();
  EVT ViaTy = ArgTy; // sentinel

  for (auto p : changeTypeSideMap) {
    if (ArgTy == p.first) {
      ViaTy = p.second;
    } else if (ArgTy == p.second) {
      ViaTy = p.first;
    }
  }

  assert(ViaTy != ArgTy && "Unknown type");
  assert((ArgTy.isInteger() && ViaTy.isFloatingPoint()) ||
         (ArgTy.isFloatingPoint() && ViaTy.isInteger()));

  return changeBitwiseOpSide(N, DAG, ViaTy);
}

enum class RegisterFilePreference { MAIN, AUX, EITHER, UNKNOWN };

RegisterFilePreference getCurrentRegisterFile(SDValue Op) {
  EVT VT = Op.getValueType();
  // Any ISD nodes which map to operations on the other register file
  // could be special cased here.
  if (VT.isInteger()) {
    return RegisterFilePreference::MAIN;
  }
  if (VT.isFloatingPoint()) {
    return RegisterFilePreference::AUX;
  }
  return RegisterFilePreference::UNKNOWN;
}

RegisterFilePreference getRegisterFilePreference(SDValue Op) {
  // Decide whether it would be better for Op to be evaluated using main or aux
  // Terminates on non-constant nodes that are not in the isInvertible list.
  // Loads and stores may be worth including here.

  auto isInvertible = [](unsigned Opcode) {
    static unsigned tab[] = {
        ISD::AND,         ISD::OR,           ISD::XOR,     ColossusISD::FAND,
        ColossusISD::FOR, ColossusISD::FNOT, ColossusISD::ANDC,
        ColossusISD::SORT4X16LO, ColossusISD::SORT4X16HI, ColossusISD::ROLL16,
        ISD::BITCAST,
    };
    return std::find(std::begin(tab), std::end(tab), Opcode) != std::end(tab);
  };

  auto fallback = getCurrentRegisterFile(Op);

  if (isCanonicalConstant(Op)) {
    return RegisterFilePreference::EITHER;
  }

  if (!isInvertible(Op.getOpcode())) {
    return fallback;
  }

  if (Op.hasOneUse()) {
    unsigned num = Op.getNumOperands();
    if (num == 1) {
      SDValue Op0 = Op.getOperand(0);
      auto Op0Prefer = getRegisterFilePreference(Op0);
      return (Op0Prefer == RegisterFilePreference::UNKNOWN) ? fallback
                                                            : Op0Prefer;
    }

    if (num == 2) {
      SDValue Op0 = Op.getOperand(0);
      SDValue Op1 = Op.getOperand(1);
      auto Op0Prefer = getRegisterFilePreference(Op0);
      auto Op1Prefer = getRegisterFilePreference(Op1);

      if ((Op0Prefer == RegisterFilePreference::UNKNOWN) ||
          (Op1Prefer == RegisterFilePreference::UNKNOWN)) {
        return fallback;
      }
      if (Op0Prefer == Op1Prefer) {
        return Op0Prefer;
      }
      if (Op0Prefer == RegisterFilePreference::EITHER) {
        return Op1Prefer;
      }
      if (Op1Prefer == RegisterFilePreference::EITHER) {
        return Op0Prefer;
      }

      if (Op0Prefer != Op1Prefer) {
        assert(Op0Prefer == RegisterFilePreference::MAIN ||
               Op0Prefer == RegisterFilePreference::AUX);
        assert(Op1Prefer == RegisterFilePreference::MAIN ||
               Op1Prefer == RegisterFilePreference::AUX);
        return RegisterFilePreference::EITHER;
      }
    }
  }

  return fallback;
}

bool performBitcastLoadCombine(SDNode *N, SelectionDAG &DAG) {
  // Optimise (bitcast (load x))
  // Returns true iff the DAG was mutated
  assert(N->getOpcode() == ISD::BITCAST);
  assert(N->getOperand(0).getOpcode() == ISD::LOAD);
  auto *LDNode = cast<LoadSDNode>(N->getOperand(0).getNode());
  if (LDNode->isVolatile()) {
    return false;
  }

  EVT retTy = N->getValueType(0);
  EVT ldTy = LDNode->getValueType(0);

  if (retTy.getSizeInBits() < 32) {
    // subword loads are complicated by illegal i16 type and missing f16 postinc
    return false;
  }

  if (!ISD::isNON_EXTLoad(LDNode)) {
    return false;
  }
  assert(LDNode->getMemoryVT() == ldTy);

  auto changeLoadType = [&](LoadSDNode *LDNode, EVT to) -> LoadSDNode * {
    auto r = cast<LoadSDNode>(
        DAG.getLoad(LDNode->getAddressingMode(), ISD::NON_EXTLOAD, to,
                    SDLoc(LDNode), LDNode->getChain(), LDNode->getBasePtr(),
                    LDNode->getOffset(), LDNode->getPointerInfo(), to,
                    LDNode->getAlignment(), LDNode->getMemOperand()->getFlags(),
                    LDNode->getAAInfo(), LDNode->getRanges()));
    assert(LDNode->getNumValues() == r->getNumValues());
    return r;
  };

  auto replaceLoadChainAndOffset = [&](LoadSDNode *from, LoadSDNode *to) {
    auto am = from->getAddressingMode();
    assert(am == ISD::UNINDEXED || am == ISD::POST_INC);
    assert(am == to->getAddressingMode());
    if (am == ISD::UNINDEXED) {
      // replace chain from old load with that of the new load
      DAG.ReplaceAllUsesOfValueWith(SDValue(from, 1), SDValue(to, 1));
    } else {
      // replace addr and chain from old load with that of the new load
      DAG.ReplaceAllUsesOfValueWith(SDValue(from, 1), SDValue(to, 1));
      DAG.ReplaceAllUsesOfValueWith(SDValue(from, 2), SDValue(to, 2));
    }
  };

  if (LDNode->hasOneUse()) {
    // Fold the bitcast into the load.
    auto replacement = changeLoadType(LDNode, retTy);

    // Replace value from bitcast with that of the new load
    // Terminates because two nodes are replaced with one.
    DAG.ReplaceAllUsesOfValueWith(SDValue(N, 0), SDValue(replacement, 0));
    replaceLoadChainAndOffset(LDNode, replacement);
    return true;
  }

  // Optimising loads with multiple uses is more subtle.
  //
  // a) All uses are on MRF
  // b) All uses are on ARF
  // c) Uses are on both register files
  //
  // Loading to the MRF is optimal for a) and very poor for c)
  // Loading to the ARF is optimal for b) and reasonable for c)
  // Therefore load to ARF unless all uses are on the MRF

  if (!LDNode->hasAnyUseOfValue(0)) {
    // If the loaded value is unused code elsewhere should erase the load
    return false;
  }

  bool hasFloatingPointUse = [&]() {
    for (auto i = LDNode->use_begin(); i != LDNode->use_end(); ++i) {
      if (i.getUse().getResNo() == 0) { // skip uses of chain, offset
        SDNode *u = *i;
        EVT useType =
            (u->getOpcode() == ISD::BITCAST) ? u->getValueType(0) : ldTy;
        if (useType.isFloatingPoint()) {
          return true;
        }
      }
    }
    return false;
  }();

  if ((ldTy.isInteger() && hasFloatingPointUse) ||
      (ldTy.isFloatingPoint() && !hasFloatingPointUse)) {

    // Create a load to the type that this particular bitcast use was to
    auto replacement = changeLoadType(LDNode, retTy);

    // Replace uses of this bitcast with the new load
    assert(SDValue(N, 0).getValueType() ==
           SDValue(replacement, 0).getValueType());
    DAG.ReplaceAllUsesOfValueWith(SDValue(N, 0), SDValue(replacement, 0));
    assert((N->getNumValues() == 1) && (!N->hasAnyUseOfValue(0)));

    // Replace the load chain and offset with those from the new load
    replaceLoadChainAndOffset(LDNode, replacement);

    // Replace remaining uses of the old load with a bitcast from the new load
    SDValue castValue = DAG.getBitcast(ldTy, SDValue(replacement, 0));
    DAG.ReplaceAllUsesOfValueWith(SDValue(LDNode, 0), castValue);

    // The old load is now also dead
    for (unsigned i = 0; i < LDNode->getNumValues(); i++) {
      assert(!LDNode->hasAnyUseOfValue(i));
    }

    // One bitcast and one load have been replaced with one bitcast and one load
    // Termination follows from special casing the single use case and otherwise
    // leaving a load to the ARF unchanged unless all uses are on the MRF.
    assert(!replacement->hasOneUse());
    return true;
  }

  return false;
}

SDValue performBitcastCombine(SDNode *N, SelectionDAG &DAG,
                              TargetLowering::DAGCombinerInfo &DCI) {
  EVT VT = N->getValueType(0);
  assert(N->getNumOperands() == 1);
  SDValue N0 = N->getOperand(0);

  // Implement promote integer operand for i16 -> f16 which arises in f64 -> f16
  // to avoid the handling in PromoteIntOp_BITCAST (in LegalizeIntegerTypes)

  if (DCI.isBeforeLegalize()) {
    if ((VT == MVT::f16) && (N0.getValueType() == MVT::i16)) {
      return locallyVectorize16BitOp(SDValue(N, 0), DAG, true);
    }
    if ((VT == MVT::i16) && (N0.getValueType() == MVT::f16)) {
      return locallyVectorize16BitOp(SDValue(N, 0), DAG, true);
    }
  }

  // Wait until everything is legalized before folding bitcasts
  if (!DCI.isAfterLegalizeDAG()) {
    return SDValue();
  }

  // Cannot bitcast to i16 after legalize
  if (VT == MVT::f16) {
    return SDValue();
  }

  if (N0.getOpcode() == ISD::LOAD) {
    if (performBitcastLoadCombine(N, DAG)) {
      return SDValue();
    }
  }

  // Bitcast of a binary op has three instances of type information
  // so can make a more informed choice than the bitwise boolean combine
  auto BitcastPrefer = getCurrentRegisterFile(SDValue(N,0));
  if (N0.getNumOperands() == 2) {
    auto Op0Pref = getRegisterFilePreference(N0.getOperand(0));
    auto Op1Pref = getRegisterFilePreference(N0.getOperand(1));
    auto BinopPrefer = getCurrentRegisterFile(N0);

    auto A = RegisterFilePreference::AUX;
    auto M = RegisterFilePreference::MAIN;
    auto E = RegisterFilePreference::EITHER;

    unsigned votesAux = (BitcastPrefer == A) + (Op0Pref == A) + (Op1Pref == A);
    unsigned votesMain = (BitcastPrefer == M) + (Op0Pref == M) + (Op1Pref == M);
    const bool consensusForChange =
        ((votesAux > votesMain) && (BinopPrefer == M)) ||
        ((votesMain > votesAux) && (BinopPrefer == A));

    const bool BitcastAndBinopOnDifferentSides =
      (BitcastPrefer == M && BinopPrefer == A) ||
      (BitcastPrefer == A && BinopPrefer == M);

    const bool canElideBitcast =
        (Op0Pref == E) && (Op1Pref == E) && BitcastAndBinopOnDifferentSides;

    if (consensusForChange || canElideBitcast) {
      if (SDValue r = changeBitwiseOpSide(N0, DAG, VT)) {
        // changeBitwiseOpSide puts a bitcast around the result
        // We don't want this as we've asked for the right type
        assert(r.getOpcode() == ISD::BITCAST);
        r = r.getOperand(0);
        assert(r.getOpcode() != ISD::BITCAST);
        assert (r.getValueType() == VT);
        return r;
      }
    }
  }

  // Replace bitcasts of a constant with the constant itself
  // The only case where this is suboptimal is when a constant is used on
  // both ARF and MRF and uses more than one instruction per word to instantiate
  // In that specific case it is slightly cheaper to instantiate on ARF and copy
  // This is believed to be both rare and difficult to detect.
  if (SDValue canon = getCanonicalConstant(SDValue(N, 0), DAG)) {
    return canon;
  }

  return SDValue();
}

SDValue incrBySize(SelectionDAG &DAG, SDLoc dl, SDValue x, SDValue size) {
  assert(size.getValueType() == MVT::i32);
  // Fold ADD inline to support calling this after DAGCombine has finished.
  if (dyn_cast<ConstantSDNode>(size)) {
    uint64_t cSize = cast<ConstantSDNode>(size)->getZExtValue();
    if (cSize == 0) {
      return x;
    }
    if (x.getOpcode() == ISD::ADD) {
      if (auto *c = dyn_cast<ConstantSDNode>(x.getOperand(1))) {
        uint64_t a = c->getZExtValue();
        if ((a + cSize) <= UINT32_MAX) {
          return DAG.getNode(ISD::ADD, dl, MVT::i32, x.getOperand(0),
                             DAG.getConstant(a + cSize, dl, MVT::i32));
        }
      }
    }
  }
  return DAG.getNode(ISD::ADD, dl, MVT::i32, x, size);
}
SDValue incrBySize(SelectionDAG &DAG, SDLoc dl, SDValue x, unsigned size) {
  return incrBySize(DAG, dl, x, DAG.getConstant(size, dl, MVT ::i32));
}

SDValue expandPostincLoad(SDNode *N, SelectionDAG &DAG) {
  assert(N->getOpcode() == ISD::LOAD);
  LoadSDNode *LDNode = cast<LoadSDNode>(N);
  assert(LDNode->getAddressingMode() == ISD::POST_INC);
  SDLoc dl(N);
  SDValue addr = LDNode->getBasePtr();
  SDValue offset = LDNode->getOffset();
  if (addr.getValueType() == MVT::i32 && offset.getValueType() == MVT::i32) {
    SDValue replacementAddr = incrBySize(DAG, dl, addr, offset);
    SDValue replacementLoad = DAG.getLoad(
        ISD::UNINDEXED, LDNode->getExtensionType(), LDNode->getValueType(0), dl,
        LDNode->getChain(), addr, DAG.getUNDEF(MVT::i32),
        LDNode->getPointerInfo(), LDNode->getMemoryVT(), LDNode->getAlignment(),
        LDNode->getMemOperand()->getFlags(), LDNode->getAAInfo(),
        LDNode->getRanges());

    assert(replacementLoad.getNode()->getNumValues() == 2);
    assert(LDNode->getNumValues() == 3);
    return DAG.getMergeValues({replacementLoad, replacementAddr,
                               SDValue(replacementLoad.getNode(), 1)},
                              dl);
  }
  return {};
}

SDValue expandPostincStore(SDNode *N, SelectionDAG &DAG) {
  assert(N->getOpcode() == ISD::STORE);
  auto *STNode = cast<StoreSDNode>(N);
  assert(STNode->getAddressingMode() == ISD::POST_INC);
  SDLoc dl(N);
  SDValue addr = STNode->getBasePtr();
  SDValue offset = STNode->getOffset();
  if (addr.getValueType() == MVT::i32 && offset.getValueType() == MVT::i32) {
    SDValue replacementAddr = incrBySize(DAG, dl, addr, offset);

    SDValue replacementStore =
        DAG.getStore(STNode->getChain(), SDLoc(N), STNode->getValue(), addr,
                     STNode->getPointerInfo(), STNode->getAlignment(),
                     STNode->getMemOperand()->getFlags(), STNode->getAAInfo());

    // Replacing a node that returns addr, chain
    assert(replacementStore.getNode()->getNumValues() == 1);
    assert(STNode->getNumValues() == 2);
    DAG.ReplaceAllUsesOfValueWith(SDValue(STNode, 0), replacementAddr);
    DAG.ReplaceAllUsesOfValueWith(SDValue(STNode, 1), replacementStore);
    return DAG.getMergeValues({replacementAddr, replacementStore}, dl);
  }

  return {};
}

bool postincOffsetSupported(SelectionDAG &DAG, LSBaseSDNode *N) {
  SDValue offset = N->getOffset();
  if (auto *constantOffset = dyn_cast<ConstantSDNode>(offset)) {
    // Replace postinc of zero with plain memop
    if (constantOffset->getZExtValue() == 0) {
      return false;
    }
  }

  unsigned incVal = N->getMemoryVT().getStoreSize();
  if (CTL::exactDivideConstant(&DAG, offset, incVal)) {
    return true;
  }
  if (CTL::exactDivideVariable(&DAG, offset, incVal)) {
    return true;
  }
  return false;
}

SDValue performLoadCombine(SDNode *N, SelectionDAG &DAG) {
  assert(N->getOpcode() == ISD::LOAD);
  auto *LDNode = cast<LoadSDNode>(N);
  if (LDNode->getAddressingMode() == ISD::POST_INC) {
    if (!postincOffsetSupported(DAG, LDNode))
      return expandPostincLoad(N, DAG);
  }
  return {};
}

SDValue performStoreCombine(SDNode *N, SelectionDAG &DAG) {
  assert(N->getOpcode() == ISD::STORE);
  auto *STNode = cast<StoreSDNode>(N);
  if (STNode->getAddressingMode() == ISD::POST_INC) {
    if (!postincOffsetSupported(DAG, STNode))
      return expandPostincStore(N, DAG);
  }
  return {};
}

/// Return true if 'Use' is a load or a store that uses N as its base pointer
/// and that N may be folded in the load / store addressing mode.
static bool canFoldInAddressingMode(SDNode *N, SDNode *Use, SelectionDAG &DAG,
                                    const TargetLowering &TLI) {
  EVT VT;
  unsigned AS;

  if (LoadSDNode *LD = dyn_cast<LoadSDNode>(Use)) {
    if (LD->isIndexed() || LD->getBasePtr().getNode() != N) {
      return false;
    }
    VT = LD->getMemoryVT();
    AS = LD->getAddressSpace();
  } else if (StoreSDNode *ST = dyn_cast<StoreSDNode>(Use)) {
    if (ST->isIndexed() || ST->getBasePtr().getNode() != N) {
      return false;
    }
    VT = ST->getMemoryVT();
    AS = ST->getAddressSpace();
  } else {
    return false;
  }

  TargetLowering::AddrMode AM;
  if (N->getOpcode() == ISD::ADD) {
    AM.HasBaseReg = true;
    ConstantSDNode *Offset = dyn_cast<ConstantSDNode>(N->getOperand(1));
    if (Offset) {
      // [reg +/- imm]
      AM.BaseOffs = Offset->getSExtValue();
    } else {
      // [reg +/- reg]
      AM.Scale = 1;
    }
  } else if (N->getOpcode() == ISD::SUB) {
    AM.HasBaseReg = true;
    ConstantSDNode *Offset = dyn_cast<ConstantSDNode>(N->getOperand(1));
    if (Offset) {
      // [reg +/- imm]
      AM.BaseOffs = -Offset->getSExtValue();
    } else {
      // [reg +/- reg]
      AM.Scale = 1;
    }
  } else {
    return false;
  }

  return TLI.isLegalAddressingMode(DAG.getDataLayout(), AM,
                                   VT.getTypeForEVT(*DAG.getContext()), AS);
}

/// Try to combine a load/store \p N at address \p Ptr with a add/sub \p Op
/// updating all or part of the address \p Ptr into a post-indexed load/store.
/// The transformation folds the add/subtract into the new indexed load/store
/// effectively and all of its uses are redirected to the new load/store or
/// an operation on the new load/store in the case where \p op only updates
/// part of \p Ptr. The chain for the new node uses the result chains of all
/// the other load and stores which were sharing the same chain before the
/// folding happens.
/// \returns the combined node.
/// TODO: upstream to the middle end.
static SDNode *
combineToPostIndexedLoadStore(SDNode *N, SDNode *Op, SDNode *Ptr,
                              SelectionDAG &DAG,
                              TargetLowering::DAGCombinerInfo &DCI) {
  assert(Op->getOpcode() == ISD::ADD || Op->getOpcode() == ISD::SUB);
  EVT VT;
  bool isLoad = true;
  const TargetLowering &TLI = DAG.getTargetLoweringInfo();

  if (LoadSDNode *LD = dyn_cast<LoadSDNode>(N)) {
    if (LD->isIndexed()) {
      return {};
    }
    VT = LD->getMemoryVT();
    if (!TLI.isIndexedLoadLegal(ISD::POST_INC, VT) &&
        !TLI.isIndexedLoadLegal(ISD::POST_DEC, VT)) {
      return {};
    }
    if (Ptr != LD->getBasePtr().getNode()) {
      return {};
    }
  } else if (StoreSDNode *ST = dyn_cast<StoreSDNode>(N)) {
    if (ST->isIndexed()) {
      return {};
    }
    VT = ST->getMemoryVT();
    if (!TLI.isIndexedStoreLegal(ISD::POST_INC, VT) &&
        !TLI.isIndexedStoreLegal(ISD::POST_DEC, VT)) {
      return {};
    }
    if (Ptr != ST->getBasePtr().getNode()) {
      return {};
    }
    isLoad = false;
  }

  bool withDelta = Ptr->getOpcode() == ISD::ADD;

  SDValue BasePtr;
  SDValue Offset;
  ISD::MemIndexedMode AM = ISD::UNINDEXED;
  if (!TLI.getPostIndexedAddressParts(N, Op, BasePtr, Offset, AM, DAG)) {
    return {};
  }

  if (withDelta) {
    if (!BasePtr->isOperandOf(Ptr))
      return {};
  } else
    assert(BasePtr.getNode() == Ptr);

  // Don't create an indexed load / store with zero offset.
  if (isNullConstant(Offset)) {
    return {};
  }

  // Try turning it into a post-indexed load / store except when
  // 1) Another load / store use the same base address and is a
  //    successor in the control flow graph, if Op is folded that
  //    would introduce a copy to keep the base pointer alive.
  // 2) All uses are load / store ops that use it as base ptr (and
  //    it may be folded as addressing mmode).
  // 3) Op must be independent of N, i.e. Op is neither a predecessor
  //    nor a successor of N. Otherwise, if Op is folded that would
  //    create a cycle.

  if (isa<FrameIndexSDNode>(Ptr) || isa<RegisterSDNode>(Ptr)) {
    return {};
  }

  // Check for #1. While at it, record result chains of load and store nodes
  // independent from N to force the postinc'ed N to be successor of those in
  // order to avoid a copy of Ptr.
  bool TryNext = false;
  SmallVector<SDValue, 4> tokens;
  for (SDNode *PtrUse : Ptr->uses()) {
    if (PtrUse == Ptr || PtrUse == N || PtrUse == Op) {
      continue;
    }

    if (N->isPredecessorOf(PtrUse)) {
      TryNext = true;
      break;
    }

    if (PtrUse->getOpcode() != ISD::ADD && PtrUse->getOpcode() != ISD::SUB) {
      continue;
    }

    for (SDNode *OpUse : PtrUse->uses()) {
      if (OpUse->isPredecessorOf(N) || N->isPredecessorOf(OpUse)) {
        continue;
      }

      bool OpUseIsLoad = dyn_cast<LoadSDNode>(OpUse);
      if (!OpUseIsLoad && !dyn_cast<StoreSDNode>(OpUse)) {
        continue;
      }

      assert(SDValue(OpUse, OpUse->getNumValues() - 1).getValueType() ==
             MVT::Other);
      tokens.push_back(SDValue(OpUse, OpUse->getNumValues() - 1));
    }
  }

  if (TryNext) {
    return {};
  }

  // Check for #2.
  bool RealUse = false;
  for (SDNode *OpUse : Op->uses()) {
    if (!canFoldInAddressingMode(Op, OpUse, DAG, TLI)) {
      RealUse = true;
    }
  }

  if (!RealUse) {
    return {};
  }

  // Check for #3.
  SmallPtrSet<const SDNode *, 32> Visited;
  SmallVector<const SDNode *, 8> Worklist;
  // Ptr is predecessor to both N and Op.
  Visited.insert(Ptr);
  Worklist.push_back(N);
  Worklist.push_back(Op);
  if (SDNode::hasPredecessorHelper(N, Visited, Worklist) ||
      SDNode::hasPredecessorHelper(Op, Visited, Worklist)) {
    return {};
  }

  SDLoc dl(N);
  SDValue MemAddr = withDelta ? SDValue(Ptr, 0) : BasePtr;
  SDValue NewMemOpValue =
      isLoad ? DAG.getIndexedLoad(SDValue(N, 0), dl, MemAddr, Offset, AM)
             : DAG.getIndexedStore(SDValue(N, 0), dl, MemAddr, Offset, AM);
  SDNode *NewMemOpNode = NewMemOpValue.getNode();
  SDValue NewAddr = SDValue(NewMemOpNode, isLoad ? 1 : 0);
  SDValue BaseAddr =
      Ptr->getOperand(0) == BasePtr ? Ptr->getOperand(1) : Ptr->getOperand(0);
  // If Op was updating part of Ptr only, substract the base from the
  // post-incremented address to get the updated part.
  SDValue NewOp = withDelta ? DAG.getNode(ISD::SUB, dl, Op->getValueType(0),
                                          NewAddr, BaseAddr)
                            : SDValue(NewMemOpNode, isLoad ? 1 : 0);

  // Make Result a successor of other load/store nodes involving Ptr by
  // updating its chain to a new TokenFactor with the chain of all those
  // nodes, recorded during check #1.
  if (!tokens.empty()) {
    SmallVector<SDValue, 4> ResultOps;
    for (SDValue Operand : NewMemOpNode->ops()) {
      ResultOps.push_back(Operand);
    }
    assert(ResultOps[0].getValueType() == MVT::Other);
    tokens.push_back(NewMemOpNode->getOperand(0));
    ResultOps[0] = DAG.getTokenFactor(SDLoc(NewMemOpNode), tokens);
    DAG.UpdateNodeOperands(NewMemOpNode, ResultOps);
  }

  LLVM_DEBUG(dbgs() << "\nReplacing.5 "; N->dump(&DAG); dbgs() << "\nWith: ";
             NewMemOpNode->dump(&DAG); dbgs() << '\n');

  SmallVector<SDValue, 2> NewMemOpValues;
  if (isLoad) {
    NewMemOpValues.push_back(SDValue(NewMemOpNode, 0));
    NewMemOpValues.push_back(SDValue(NewMemOpNode, 2));
  } else {
    NewMemOpValues.push_back(SDValue(NewMemOpNode, 1));
  }
  DCI.CombineTo(N, ArrayRef<SDValue>(NewMemOpValues), /*AddTo=*/true);
  // Replace the uses of Op with uses of the updated base value.
  DCI.CombineTo(Op, NewOp, /*AddTo=*/true);

  return NewMemOpNode;
}

/// Search for load/store with the same base as this add/sub and try to combine
/// them into a post-indexed load/store. Compared to the same combine pattern
/// in the middle end, this one will catch cases where a load/store share the
/// same base as several add/sub but only some of them can be folded.
//
/// Here we try to combine an add/sub into a load/store instead of the reverse
/// because we want the existing add/sub combine patterns to be called first
/// before trying a postinc combine. This is because in some case the address
/// of a load/store is expressed by 2 nested add (e.g. to compute the address
/// of a second element of a vector when each element is not naturally
/// aligned, as in load_align2_v2f32 of the misaligned_load.ll testcase). In
/// such a case we want the 2 add to be combined before looking at whether the
/// resulting add can be combined itself with a load/store into a postinc
/// load/store.
SDValue performAddSubCombine(SDNode *N, SelectionDAG &DAG,
                             TargetLowering::DAGCombinerInfo &DCI) {
  assert(N->getOpcode() == ISD::ADD || N->getOpcode() == ISD::SUB);
  // Do not create postinc until after type legalization because integer
  // promotion only expects unindexed load.
  if (!DCI.isAfterLegalizeDAG())
    return {};

  // Base pointer is only used by N, no load/store to pair it with.
  SDValue Ptr = N->getOperand(0);
  if (Ptr.getNode()->hasOneUse())
    return {};

  auto doCombine = [&](SDNode *Addr) -> bool {
    for (SDNode *AddrUse : Addr->uses()) {
      if (AddrUse == N)
        continue;
      if (AddrUse->getOpcode() != ISD::LOAD && 
          AddrUse->getOpcode() != ISD::STORE)
        continue;
      if (combineToPostIndexedLoadStore(AddrUse, N, Addr, DAG, DCI))
        return true;
    }
    return false;
  };

  // Try to combine with all load/store using the same base. Example:
  // load/store: ... (base addr:) Ptr
  // N:          ADD/SUB Ptr, IncVal
  if (doCombine(Ptr.getNode()))
    return SDValue(N, 0);

  // Try to perform combine on the pattern where the load/store uses the sum of
  // two addresses as its base (a base and a delta). Example:
  // BasePlusDelta: ADD a, Ptr
  // load/store:    ... (base addr:) BasePlusDelta
  // N:             ADD/SUB Ptr, IncVal
  if (dyn_cast<ConstantSDNode>(N->getOperand(1))) {
    SDNode *BasePtr = Ptr.getNode();
    for (SDNode *BaseUse : BasePtr->uses()) {
      if (BaseUse == N)
        continue;
      if (BaseUse->getOpcode() != ISD::ADD)
        continue;
      SDNode *BasePlusDelta = BaseUse;

      if (dyn_cast<ConstantSDNode>(BasePlusDelta->getOperand(1)))
        continue;
      if (Ptr != BasePlusDelta->getOperand(1) || !N->hasOneUse())
        continue;
      if (BasePlusDelta->getOperand(0)->getOpcode() == ISD::FrameIndex ||
          BasePlusDelta->getOperand(1)->getOpcode() == ISD::FrameIndex)
        continue;

      if (doCombine(BasePlusDelta))
        return SDValue(N, 0);
    }
  }

  return {};
}

SDValue changeRegisterFile(SDValue Op, SelectionDAG &DAG) {
  unsigned num = Op.getNumOperands();
  if (num == 1 || num == 2) {
    auto PrefRF = getRegisterFilePreference(Op);
    auto CurrentRF = getCurrentRegisterFile(Op);
    const bool consensusForChange =
        (PrefRF != RegisterFilePreference::EITHER) && (PrefRF != CurrentRF);

    if (consensusForChange) {
      if (SDValue r = changeBitwiseOpSide(Op, DAG)) {
        return r;
      }
    }
  }
  return SDValue();
}

SDValue performBitwiseBooleanCombineEqualOperands(SDNode *N,
                                                  SelectionDAG &DAG) {
  assert(N->getNumOperands() == 2);
  auto Op0 = N->getOperand(0);
  auto Op1 = N->getOperand(1);
  if (Op0 == Op1) {
    SDLoc dl(N);
    EVT VT = N->getValueType(0);
    unsigned Opc = N->getOpcode();

    SDValue zero = makeCanonicalConstant(0, VT, dl, DAG);

    if (Op0.getOpcode() == ISD::UNDEF) {
      switch (Opc) {
        // Returning undef would be valid for any binary bitwise op on two
        // undef arguments. LLVM currently maps the operation to a constant
        // for ISD nodes. Reproducing this behaviour here for consistency.
      case ColossusISD::FAND:
      case ColossusISD::ANDC: {
        // (andc undef undef) => (and undef (not undef)) => (and undef undef)
        return zero;
      }
      case ColossusISD::FOR: {
        auto sz = VT.getSizeInBits();
        assert(sz == 32u || sz == 64u);
        return makeCanonicalConstant(
          sz == 32u ? UINT32_MAX : UINT64_MAX, VT, dl, DAG);
      }
      }
    } else {
      switch (Opc) {
      case ColossusISD::ANDC: {
        return zero;
      }
      case ColossusISD::FAND:
      case ColossusISD::FOR: {
        return Op0;
      }
      }
    }
  }

  return SDValue();
}

SDValue performBitwiseBooleanCombine(SDNode *N, SelectionDAG &DAG,
                                     TargetLowering::DAGCombinerInfo &DCI) {
  EVT VT = N->getValueType(0);
  if (DCI.isBeforeLegalize()) {
    // Lower bitwise i16 via v2i16 instead of via i32
    // This mirrors the f16 => v2f16 lowering and facilitates
    // pattern matching for ColossusFAND et al
    if (VT == MVT::i16) {
      return locallyVectorize16BitOp(SDValue(N, 0), DAG, true);
    }
  }

  if (!DCI.isAfterLegalizeDAG()) {
    return SDValue();
  }

  // Unimplemented for f16 as it is expected to be lowered as v2f16
  if (VT == MVT::f16) {
    return SDValue();
  }

  if (SDValue changed = changeRegisterFile(SDValue(N,0), DAG)) {
    return changed;
  }

  if (N->getNumOperands() == 1) {
    if (N->getOperand(0).getOpcode() == ISD::UNDEF) {
      return DAG.getUNDEF(VT);
    }
  }

  if (N->getNumOperands() != 2) {
    return SDValue();
  }

  if (SDValue eq = performBitwiseBooleanCombineEqualOperands(N, DAG)) {
    return eq;
  }

  unsigned Opc = N->getOpcode();
  SDLoc dl(N);

  auto Op0 = N->getOperand(0);
  auto Op1 = N->getOperand(1);

  // Fold zeros/ones argument to ColossusISD nodes
  if (Opc == ColossusISD::FAND) {
    if (allBitsSet(Op0) || allBitsClear(Op1)) {
      return Op1;
    }
    if (allBitsClear(Op0) || allBitsSet(Op1)) {
      return Op0;
    }
  }
  if (Opc == ColossusISD::FOR) {
    if (allBitsSet(Op0) || allBitsClear(Op1)) {
      return Op0;
    }
    if (allBitsClear(Op0) || allBitsSet(Op1)) {
      return Op1;
    }
  }
  if (Opc == ColossusISD::ANDC) {
    if (allBitsSet(Op0)) {
      // (andc -1 y) => (and -1 (not y)) => (not y)
      if (VT.isFloatingPoint()) {
        return DAG.getNode(ColossusISD::FNOT, dl, VT, Op1);
      } else {
        return DAG.getNOT(dl, Op1, VT);
      }
    }
    if (allBitsSet(Op1)) {
      // (andc x -1) => (and x 0) => 0
      SDValue Zero32 = DAG.getConstant(0, dl, MVT::i32);
      unsigned bits = VT.getSizeInBits();
      if (bits == 32) {
        return DAG.getBitcast(VT, Zero32);
      }
      if (bits == 64) {
        return DAG.getBitcast(
            VT, DAG.getNode(ISD::BUILD_VECTOR, dl, MVT::v2i32, Zero32, Zero32));
      }
    }
    if (allBitsClear(Op0) || allBitsClear(Op1)) {
      // (andc 0 y) => 0
      // (andc x 0) => (and x -1) => x
      return Op0;
    }
  }

  // Fold some combinations of not, and, andc
  if (Opc == ISD::AND || Opc == ColossusISD::FAND || Opc == ColossusISD::ANDC) {
    auto getOtherOpcode = [=]() -> unsigned {
      if (VT.isInteger()) {
        assert(Opc == ISD::AND || Opc == ColossusISD::ANDC);
        return (Opc == ISD::AND) ? (unsigned)ColossusISD::ANDC
                                 : (unsigned)ISD::AND;
      } else {
        assert(Opc == ColossusISD::FAND || Opc == ColossusISD::ANDC);
        return (Opc == ColossusISD::FAND) ? ColossusISD::ANDC
                                          : ColossusISD::FAND;
      }
    };

    // (and (not x) y) => (and y (not x)) is unsafe as LLVM may swap them back

    // (and (not x) y) => (andc y x)
    if (SDValue NotOp = isBitwiseNotOfExistingNode(Op0)) {
      if (Opc == ISD::AND || Opc == ColossusISD::FAND) {
        return DAG.getNode(getOtherOpcode(), dl, VT, Op1,
                           DAG.getBitcast(VT, NotOp));
      }
    }

    // (and x (not y)) => (andc x y)
    // (andc x (not y)) => (and x y)
    if (SDValue NotOp = isBitwiseNotOfExistingNode(Op1)) {
      return DAG.getNode(getOtherOpcode(), dl, VT, Op0,
                         DAG.getBitcast(VT, NotOp));
    }
  }

  // Using AND to zero the high half of a word can be folded into a LDZ8(STEP)
  // or LDZ16(STEP).
  // (and (ld8 anyext a) 0xff      => (ld8 zext a)
  // (and (ld16 anyext a) 0xffff   => (ld16 zext a)
  if (Opc == ISD::AND) {
    SDValue Op0root = peekThroughBitcasts(Op0);
    if (LoadSDNode *LDNode = dyn_cast<LoadSDNode>(Op0root)) {
      if (LDNode->getExtensionType() == ISD::EXTLOAD) {
        auto const Op1VT = Op1.getValueType();
        auto const MemVT = LDNode->getMemoryVT();
        if ((MemVT == MVT::i16 &&
             Op1 == makeCanonicalConstant(65535u, Op1VT, dl, DAG)) ||
            (MemVT == MVT::i8 &&
             Op1 == makeCanonicalConstant(255u, Op1VT, dl, DAG))) {
          SDValue zextLoad = DAG.getLoad(
              LDNode->getAddressingMode(), ISD::ZEXTLOAD,
              LDNode->getValueType(0), dl, LDNode->getChain(),
              LDNode->getBasePtr(), LDNode->getOffset(),
              LDNode->getPointerInfo(), MemVT, LDNode->getAlignment(),
              LDNode->getMemOperand()->getFlags(), LDNode->getAAInfo(),
              LDNode->getRanges());
          DAG.ReplaceAllUsesWith(LDNode, zextLoad.getNode());
          return zextLoad; // Replace AND with the zext load value
        }
      }
    }
  }

  // Using AND to zero the high half of a word can be folded into a SORT4X16
  // This is probably the wrong way around. Canonicalising SORT/ROLL to
  // and/shift can expose more optimisations.
  // (and (sort4x16lo a b) 0xffff) => (sort4x16lo a 0x0)
  // (and (sort4x16hi a b) 0xffff) => (sort4x16hi a 0x0)
  // (and c 0xffff)                => (sort4x16lo c 0x0)
  if (Opc == ISD::AND || Opc == ColossusISD::FAND) {
    auto const Op1VT = Op1.getValueType();
    if (Op1 == makeCanonicalConstant(65535u, Op1VT, dl, DAG)) {
      SDValue Op0root = peekThroughBitcasts(Op0);
      unsigned Op0Opc = Op0root.getOpcode();
      SDValue Zero = makeCanonicalConstant(0, VT, dl, DAG);
      if (Op0Opc == ColossusISD::SORT4X16LO ||
          Op0Opc == ColossusISD::SORT4X16HI) {
        return DAG.getNode(Op0Opc, dl, VT,
                           DAG.getBitcast(VT, Op0root.getOperand(0)), Zero);
      }
      return DAG.getNode(ColossusISD::SORT4X16LO, dl, VT, Op0, Zero);
    }
  }

  return SDValue();
}

SDValue performAndCombine(SDNode *N, SelectionDAG &DAG,
                          TargetLowering::DAGCombinerInfo &DCI) {
  assert(N->getOpcode() == ISD::AND);

  auto Op0 = N->getOperand(0);
  auto Op1 = N->getOperand(1);
  auto dl = SDLoc{N};

  // Transform a zero extended unordered setcc into a comparison of the negated
  // condition against zero to avoid the result of cmp being bitwise-negated
  // just for the result to be masked with 1. In other words, use
  // (cmpeq (cmp<negcond>), 0) instead of (and (not (cmp<unord cond>)), 1).
  if (Op0->getOpcode() != ISD::SETCC)
    return {};
  auto Cond = cast<CondCodeSDNode>(Op0->getOperand(2))->get();
  if (getUnorderedFlavor(Cond) != 1)
    return {};
  auto Cst1 = dyn_cast<ConstantSDNode>(Op1.getNode());
  if (!Cst1 || Cst1->getZExtValue() != 1)
    return {};
  auto CmpLHS = Op0.getOperand(0);
  auto CmpRHS = Op0.getOperand(1);
  auto NegCond = getSetCCInverse(Cond, CmpLHS.getValueType());
  SDValue SetCC = DAG.getSetCC(dl, MVT::i32, CmpLHS, CmpRHS, NegCond);
  auto Bitcast = DAG.getBitcast(MVT::i32, SetCC);
  return DAG.getSetCC(dl, MVT::i32, Bitcast, DAG.getConstant(0, dl, MVT::i32),
                      ISD::SETEQ);
}

SDValue performRSQRTCombine(SDNode * N, SelectionDAG & DAG,
                            TargetLowering::DAGCombinerInfo & DCI) {
  if (!isWorkerSubtarget(DAG))
    return {};

  LLVM_DEBUG(dbgs() << "performRSQRTCombine:");

  assert(N->getOpcode() == ISD::FDIV || N->getOpcode() == ISD::STRICT_FDIV);
  auto const strictDiv = N->isStrictFPOpcode();
  auto const firstDivValueOperand = strictDiv ? 1u : 0u;
  assert(N->getNumOperands() - firstDivValueOperand == 2u);

  EVT VT = N->getValueType(0u);

  if (VT != MVT::f32) {
    return SDValue();
  }

  auto first = N->getOperand(firstDivValueOperand);
  auto firstVT = first->getValueType(0u);
  auto fp_first = dyn_cast<ConstantFPSDNode>(first);

  if (!(firstVT == MVT::f32 && fp_first)) {
    return SDValue();
  }

  if (!fp_first->isExactlyValue(1.0)) {
    return SDValue();
  }

  auto second = N->getOperand(firstDivValueOperand + 1u);

  if (second->getOpcode() != ISD::FSQRT &&
      second->getOpcode() != ISD::STRICT_FSQRT) {
    return SDValue();
  }

  auto secondVT = second->getValueType(0u);

  if (secondVT != MVT::f32) {
    return SDValue();
  }

  auto const strictFsqrt = second->isStrictFPOpcode();
  auto const firstFsqrtValueOperand = strictFsqrt ? 1u : 0u;
  auto value = second->getOperand(firstFsqrtValueOperand);
  if (strictDiv || strictFsqrt) {
    SDValue chain = strictDiv ? N->getOperand(0) : second->getOperand(0);
    SDValue strictFrsqrt = DAG.getNode(ColossusISD::STRICT_FRSQRT, SDLoc(N),
                                       {VT, MVT::Other}, {chain, value});
    if (strictFsqrt) {
      SmallVector<SDValue, 2> Results = {strictFrsqrt,
                                         strictFrsqrt.getValue(1)};
      DCI.CombineTo(second.getNode(), ArrayRef<SDValue>(Results),
                    /*AddTo=*/true);
    }
    return strictFrsqrt;
  }
  return DAG.getNode(ColossusISD::FRSQRT, SDLoc(N), VT, value);
}

SDValue makeSORTorRoll(unsigned Opc, SelectionDAG &DAG, SDLoc dl, EVT VT,
                       SDValue arg0, SDValue arg1) {
  return DAG.getNode(Opc, dl, VT, DAG.getBitcast(VT, arg0),
                     DAG.getBitcast(VT, arg1));
}
SDValue makeSORT4X16LO(SelectionDAG &DAG, SDLoc dl, EVT VT, SDValue arg0,
                       SDValue arg1) {
  // (arg1 & 0xffff) | (arg2 << 16)
  return makeSORTorRoll(ColossusISD::SORT4X16LO, DAG, dl, VT, arg0, arg1);
}
SDValue makeSORT4X16HI(SelectionDAG &DAG, SDLoc dl, EVT VT, SDValue arg0,
                       SDValue arg1) {
  // (arg1 >> 16) | ((arg2 >> 16) << 16)
  return makeSORTorRoll(ColossusISD::SORT4X16HI, DAG, dl, VT, arg0, arg1);
}
SDValue makeROLL16(SelectionDAG &DAG, SDLoc dl, EVT VT, SDValue arg0,
                   SDValue arg1) {
  // (arg1 >> 16) | (arg2 << 16)
  return makeSORTorRoll(ColossusISD::ROLL16, DAG, dl, VT, arg0, arg1);
}
SDValue makePICK16(SelectionDAG &DAG, SDLoc dl, EVT VT, SDValue arg0,
                   SDValue arg1) {
  // ((arg1 >> 16) << 16) | (arg2 & 0xffff)

  SDValue tmp = makeSORTorRoll(ColossusISD::ROLL16, DAG, dl, VT, arg1, arg0);
  return DAG.getNode(ColossusISD::ROLL16, dl, VT, tmp, tmp);
}

SDValue performSORTorROLLCombine(SDValue Op, SelectionDAG &DAG) {
  // Combines that apply to sort4x16{lo,hi} and roll16
  auto const Opc = Op.getOpcode();
  auto dl = SDLoc{Op};
  auto VT = Op.getValueType();

  assert(VT.getSizeInBits() == 32); // sort/roll only defined on 32 bit types
  assert(Op.getNumOperands() == 2);
  assert((std::set<unsigned>{ColossusISD::SORT4X16HI,
                             ColossusISD::SORT4X16LO,
                             ColossusISD::ROLL16,}.count(Opc) > 0));

  if (auto changed = changeRegisterFile(Op, DAG)) {
    return changed;
  }

  auto Op0 = Op.getOperand(0);
  auto Op1 = Op.getOperand(1);

  if (Op0.isUndef() && Op1.isUndef()) {
    return DAG.getUNDEF(VT);
  }

  using SDValuePair = std::pair<SDValue,SDValue>;

  auto doSplit = [&](SDValue val) -> llvm::Optional<SDValuePair> {
    auto valVT = val.getValueType();
    auto argVT = valVT.isFloatingPoint() ? MVT::f16 : MVT::i32;
    if (val.isUndef()) {
      return SDValuePair{DAG.getUNDEF(argVT), DAG.getUNDEF(argVT)};
    }
    if (isBuildVectorOfConstantNodes(val)) {
      return splitValue(val, DAG);
    }
    if (auto maybeU64 = CTL::SDValueToUINT64(val, DAG)) {
      assert(*maybeU64 <= std::numeric_limits<uint32_t>::max());
      auto lo = makeCanonicalConstant(*maybeU64 & 0xFFFFu, argVT, dl, DAG);
      auto hi = makeCanonicalConstant(*maybeU64 >> 16u, argVT, dl, DAG);
      return SDValuePair{lo, hi};
    }
    return {};
  };

  auto Op0Split = doSplit(Op0);
  auto Op1Split = doSplit(Op1);

  if (!(Op0Split && Op1Split)) {
    return {};
  }

  auto makeResult = [&](SDValue lo, SDValue hi) -> SDValue {
    auto resVT = EVT{VT.isFloatingPoint() ? MVT::v2f16 : MVT::v2i16};
    auto res = DAG.getBuildVector(resVT, dl, {lo, hi});
    return DAG.getBitcast(VT, res);
  };

  switch (Opc) {
    case ColossusISD::SORT4X16HI: {
      return makeResult(Op0Split->second, Op1Split->second);
    }
    case ColossusISD::SORT4X16LO: {
      return makeResult(Op0Split->first, Op1Split->first);
    }
    case ColossusISD::ROLL16: {
      return makeResult(Op0Split->second, Op1Split->first);
    }
    default: {
      llvm_unreachable("Unhandled Opcode.");
      break;
    }
  }

  return {};
}

bool isSORT4X16LO(SDValue x) {
  x = peekThroughBitcasts(x);
  return x.getOpcode() == ColossusISD::SORT4X16LO;
}
bool isSORT4X16HI(SDValue x) {
  x = peekThroughBitcasts(x);
  return x.getOpcode() == ColossusISD::SORT4X16HI;
}
bool isROLL16(SDValue x) {
  x = peekThroughBitcasts(x);
  return x.getOpcode() == ColossusISD::ROLL16;
}
SDValue peekOperand(SDValue x, unsigned i) {
  x = peekThroughBitcasts(x);
  return x.getOperand(i);
}

SDValue performSORT4X16LOCombine(SDNode *N, SelectionDAG &DAG) {
  assert(N->getOpcode() == ColossusISD::SORT4X16LO);
  assert(N->getNumOperands() == 2);
  SDLoc dl(N);
  EVT VT = N->getValueType(0);
  SDValue Op0 = N->getOperand(0);
  SDValue Op1 = N->getOperand(1);

  if (SDValue general = performSORTorROLLCombine(SDValue(N, 0), DAG)) {
    return general;
  }

  if (Op0.getOpcode() == ISD::UNDEF) {
    return makeROLL16(DAG, dl, VT, Op0, Op1);
  }

  if (isSORT4X16LO(Op0)) {
    // (SORT4X16LO (SORT4X16LO X Y) Z) => (SORT4X16LO X Z)
    return makeSORT4X16LO(DAG, dl, VT, peekOperand(Op0, 0), Op1);
  }

  if (isSORT4X16HI(Op0) && Op1 == makeCanonicalConstant(0, VT, dl, DAG)) {
    // (SORT4X16LO (SORT4X16HI X Y) 0x0) => (SORT4X16HI X 0x0)
    return makeSORT4X16HI(DAG, dl, VT, peekOperand(Op0, 0), Op1);
  }

  if (isSORT4X16HI(Op0)) {
    // (SORT4X16LO (SORT4X16HI X Y) Z) => (ROLL16 X Z)
    return makeROLL16(DAG, dl, VT, peekOperand(Op0, 0), Op1);
  }

  if (isROLL16(Op0)) {
    // (SORT4X16LO (ROLL16 X Y) Z) => (ROLL16 X Z)
    return makeROLL16(DAG, dl, VT, peekOperand(Op0, 0), Op1);
  }

  if (isSORT4X16LO(Op1)) {
    // (SORT4X16LO X (SORT4X16LO Y Z)) => (SORT4X16LO X Y)
    return makeSORT4X16LO(DAG, dl, VT, Op0, peekOperand(Op1, 0));
  }

  if (isSORT4X16HI(Op1)) {
    // (SORT4X16LO X (SORT4X16HI Y Z)) => (PICK16 X Y)
    return makePICK16(DAG, dl, VT, Op0, peekOperand(Op1, 0));
  }

  if (isROLL16(Op1)) {
    // (SORT4X16LO X (ROLL16 Y Z)) => (PICK16 X Y)
    return makePICK16(DAG, dl, VT, Op0, peekOperand(Op1, 0));
  }

  return SDValue();
}

SDValue performSORT4X16HICombine(SDNode *N, SelectionDAG &DAG) {
  assert(N->getOpcode() == ColossusISD::SORT4X16HI);
  assert(N->getNumOperands() == 2);
  SDLoc dl(N);
  EVT VT = N->getValueType(0);
  SDValue Op0 = N->getOperand(0);
  SDValue Op1 = N->getOperand(1);

  if (SDValue general = performSORTorROLLCombine(SDValue(N, 0), DAG)) {
    return general;
  }

  if (Op1.getOpcode() == ISD::UNDEF) {
    return makeROLL16(DAG, dl, VT, Op0, Op1);
  }

  if (isSORT4X16LO(Op0)) {
    // (SORT4X16HI (SORT4X16LO X Y) Z) => (PICK16 Y Z)
    return makePICK16(DAG, dl, VT, peekOperand(Op0, 1), Op1);
  }

  if (isSORT4X16HI(Op0)) {
    // (SORT4X16HI (SORT4X16HI X Y) Z) => (SORT4X16HI Y Z)
    return makeSORT4X16HI(DAG, dl, VT, peekOperand(Op0, 1), Op1);
  }

  if (isROLL16(Op0)) {
    // (SORT4X16HI (ROLL16 X Y) Z) => (PICK16 Y Z)
    return makePICK16(DAG, dl, VT, peekOperand(Op0, 1), Op1);
  }

  if (isSORT4X16LO(Op1)) {
    // (SORT4X16HI X (SORT4X16LO Y Z)) => (ROLL16 X Z)
    return makeROLL16(DAG, dl, VT, Op0, peekOperand(Op1, 1));
  }

  if (isSORT4X16HI(Op1)) {
    // (SORT4X16HI X (SORT4X16HI Y Z)) => (SORT4X16HI X Z)
    return makeSORT4X16HI(DAG, dl, VT, Op0, peekOperand(Op1, 1));
  }

  if (isROLL16(Op1)) {
    // (SORT4X16HI X (ROLL16 Y Z)) => (ROLL16 X Z)
    return makeROLL16(DAG, dl, VT, Op0, peekOperand(Op1, 1));
  }

  return SDValue();
}

SDValue performROLL16Combine(SDNode *N, SelectionDAG &DAG) {
  assert(N->getOpcode() == ColossusISD::ROLL16);
  assert(N->getNumOperands() == 2);
  SDLoc dl(N);
  EVT VT = N->getValueType(0);
  SDValue Op0 = N->getOperand(0);
  SDValue Op1 = N->getOperand(1);

  if (SDValue general = performSORTorROLLCombine(SDValue(N, 0), DAG)) {
    return general;
  }

  // (ROLL16 X X) is (SWAP16 X)
  // Folding (SWAP16 (SORT|ROLL)) can lead to non-termination when combined
  // with the other DAGCombines on SORT and ROLL which introduce SWAP16 nodes

  if (Op0 == Op1) {

    // Optimise SWAP16
    SDValue X = peekOperand(Op0, 0);
    SDValue Y = peekOperand(Op0, 1);

    if (isSORT4X16LO(Op0)) {
      // (SWAP16 (SORT4X16LO X Y)) => (SORT4X16LO Y X)
      return makeSORT4X16LO(DAG, dl, VT, Y, X);
    }

    if (isSORT4X16HI(Op0)) {
      // (SWAP16 (SORT4X16HI X Y)) => (SORT4X16HI Y X)
      return makeSORT4X16HI(DAG, dl, VT, Y, X);
    }

    if (isROLL16(Op0)) {
      if (X == Y) {
        // (SWAP16 (SWAP16 X)) => X
        return DAG.getBitcast(VT, X);
      }

      if (Y.getOpcode() == ISD::UNDEF) {
        // (SWAP16 (ROLL16 X U)) => (SORT4X16HI U X)
        return makeSORT4X16HI(DAG, dl, VT, Y, X);
      }

      if (X.getOpcode() == ISD::UNDEF) {
        // (SWAP16 (ROLL16 U Y)) => (SORT4X16LO Y U)
        return makeSORT4X16LO(DAG, dl, VT, Y, X);
      }
    }
  } else {
    // Optimising ROLL16 will terminate when it is not a SWAP16

    if (isSORT4X16LO(Op0)) {
      // (ROLL16 (SORT4X16LO X Y) Z) => (SORT4X16LO Y Z)
      return makeSORT4X16LO(DAG, dl, VT, peekOperand(Op0, 1), Op1);
    }

    if (isSORT4X16HI(Op0)) {
      // (ROLL16 (ROLL16 X Y) Z) => (ROLL16 Y Z)
      return makeROLL16(DAG, dl, VT, peekOperand(Op0, 1), Op1);
    }

    if (isROLL16(Op0)) {
      // (ROLL16 (ROLL16 X Y) Z) => (SORT4X16LO Y Z)
      return makeSORT4X16LO(DAG, dl, VT, peekOperand(Op0, 1), Op1);
    }

    if (isSORT4X16LO(Op1)) {
      // (ROLL16 X (SORT4X16LO Y Z)) => (ROLL16 X Y)
      return makeROLL16(DAG, dl, VT, Op0, peekOperand(Op1, 0));
    }

    if (isSORT4X16HI(Op1)) {
      // (ROLL16 X (SORT4X16HI Y Z)) => (SORT4X16HI X Y)
      return makeSORT4X16HI(DAG, dl, VT, Op0, peekOperand(Op1, 0));
    }

    if (isROLL16(Op1)) {
      // (ROLL16 X (ROLL Y Z)) => (SORT4X16HI X Y)
      return makeSORT4X16HI(DAG, dl, VT, Op0, peekOperand(Op1, 0));
    }
  }

  return SDValue();
}

SDValue performSORT8X8LOCombine(SDNode *N, SelectionDAG &DAG) {
  assert(N->getNumOperands() == 2u);
  assert(N->getValueType(0u) == MVT::i32);

  auto op0 = N->getOperand(0u);
  auto op1 = N->getOperand(1u);

  if (op0.getOpcode() == ColossusISD::SHUF8X8LO &&
      op1.getOpcode() == ColossusISD::SHUF8X8HI) {

    op0 = op0.getOperand(0u);
    op1 = op1.getOperand(0u);

    if (op0 == op1) {
      return op0;
    }
  }

  return {};
}

SDValue performConversionOptimisation(SDNode *N, SelectionDAG &DAG,
                                      TargetLowering::DAGCombinerInfo &DCI) {
  // Convert to colossus specific isd nodes that take and return f32
  // The ISD nodes convert between integer and floating point types. These
  // would introduce a bitcast at instruction selection, too late to fold
  // with other bitcasts. This optimisation replaces the nodes in order to
  // expose bitcasts to other combines.
  unsigned Opc = N->getOpcode();
  unsigned ColossusOpc = [Opc]() {
    switch (Opc) {
    default:
      llvm_unreachable("Unhandled Opcode.");
    case ISD::FP_TO_SINT:
      return ColossusISD::F32_TO_SINT;
    case ISD::FP_TO_UINT:
      return ColossusISD::F32_TO_UINT;
    case ISD::STRICT_FP_TO_SINT:
      return ColossusISD::STRICT_F32_TO_SINT;
    case ISD::STRICT_FP_TO_UINT:
      return ColossusISD::STRICT_F32_TO_UINT;
    case ISD::SINT_TO_FP:
    case ISD::STRICT_SINT_TO_FP:
      return ColossusISD::SINT_TO_F32;
    case ISD::UINT_TO_FP:
    case ISD::STRICT_UINT_TO_FP:
      return ColossusISD::UINT_TO_F32;
    }
  }();

  if (!DCI.isAfterLegalizeDAG()) {
    return SDValue();
  }

  bool StrictFP = N->isStrictFPOpcode();
  unsigned NumOperands = N->getNumOperands();
  assert(NumOperands == (StrictFP ? 2 : 1));
  SDLoc dl(N);
  SDValue ScalarArg = N->getOperand(StrictFP ? 1 : 0);
  EVT ScalarArgVT = ScalarArg.getValueType();
  EVT ResVT = N->getValueType(0);
  SDValue Chain = StrictFP ? N->getOperand(0) : SDValue();
  SDValue Results[] = {SDValue(), Chain};

  switch (Opc) {
  default:
    llvm_unreachable("Unhandled opcode");
  case ISD::FP_TO_SINT:
  case ISD::FP_TO_UINT:
  case ISD::STRICT_FP_TO_SINT:
  case ISD::STRICT_FP_TO_UINT: {
    assert(ResVT == MVT::i32);
    if ((ScalarArgVT == MVT::f16) && (ScalarArgVT != MVT::f32)) {
      return {};
    }

    EVT ConvertVTs[] = {MVT::f32, MVT::Other};
    SDValue ConvertScalarArg = ScalarArg;
    if (ScalarArgVT == MVT::f16) {
      if (StrictFP) {
        std::tie(ConvertScalarArg, Chain) =
            DAG.getStrictFPExtendOrRound(ScalarArg, Chain, dl, MVT::f32);
      } else {
        ConvertScalarArg = DAG.getFPExtendOrRound(ScalarArg, dl, MVT::f32);
      }
    }
    SmallVector<SDValue, 2> ConvertArgs = {Chain, ConvertScalarArg};
    SDValue Converted = DAG.getNode(
        ColossusOpc, dl, ArrayRef<EVT>(ConvertVTs, NumOperands),
        ArrayRef<SDValue>(ConvertArgs).slice(ConvertArgs.size() - NumOperands));
    Results[0] = DAG.getBitcast(ResVT, Converted);
    if (StrictFP) {
      Results[1] = Converted.getValue(1);
    }
    DCI.CombineTo(N, ArrayRef<SDValue>(Results, NumOperands), /*AddTo=*/true);
    return {};
  }
  case ISD::SINT_TO_FP:
  case ISD::UINT_TO_FP:
  case ISD::STRICT_SINT_TO_FP:
  case ISD::STRICT_UINT_TO_FP: {
    assert(ScalarArgVT == MVT::i32);
    if ((ResVT != MVT::f16) && (ResVT != MVT::f32)) {
      return {};
    }

    SDValue ScalarArgAsF32 = DAG.getBitcast(MVT::f32, ScalarArg);
    SDValue Converted = DAG.getNode(ColossusOpc, dl, MVT::f32, ScalarArgAsF32);
    if (ResVT == MVT::f16) {
      if (StrictFP) {
        std::tie(Results[0], Results[1]) =
            DAG.getStrictFPExtendOrRound(Converted, Chain, dl, ResVT);
      } else {
        Results[0] = DAG.getFPExtendOrRound(Converted, dl, ResVT);
      }
    } else {
      Results[0] = Converted;
    }
    DCI.CombineTo(N, ArrayRef<SDValue>(Results, NumOperands), /*AddTo=*/true);
    return {};
  }
  }
  return {};
}

SDValue performF16V2F16ConversionCombine(SDNode *N, SelectionDAG &DAG) {
  // Handle cancellation, undef etc
  SDLoc dl(N);
  unsigned Opc = N->getOpcode();
  assert(Opc == ColossusISD::F16ASV2F16 || Opc == ColossusISD::V2F16ASF16);

  SDValue Op0 = N->getOperand(0);
  if (Op0.getOpcode() == ISD::UNDEF) {
    return DAG.getUNDEF(N->getValueType(0));
  }

  if (Opc == ColossusISD::F16ASV2F16 &&
      Op0.getOpcode() == ColossusISD::V2F16ASF16) {
    // (F16ASV2F16 (V2F16ASF16 X)) => X with top half undef
    // More efficient to construct the SORT4X16 directly
    return DAG.getNode(ColossusISD::SORT4X16LO, dl, MVT::v2f16,
                       Op0.getOperand(0), DAG.getUNDEF(MVT::v2f16));
  }

  if (Opc == ColossusISD::V2F16ASF16 &&
      Op0.getOpcode() == ColossusISD::F16ASV2F16) {
    // (V2F16ASF16 (F16ASV2F16 X)) => X
    return Op0.getOperand(0);
  }
  return SDValue();
}

template <typename F>
SDValue performFP_ROUNDCombine(SDNode *N, SelectionDAG &DAG,
                               TargetLowering::DAGCombinerInfo &DCI,
                               F lowerfp_round) {
  // Fold FP_ROUND f64 => f16 before type legalisation
  // The builtin type legalisation runs before LowerOperationWrapper
  // and creates a call to __truncdfhf2 that leaves the f16 result in
  // $m0. This function is called before the legaliser in order to
  // intercept and generate a call that leaves the f16 result in $a0.

  if (!DCI.isBeforeLegalize()) {
    return SDValue();
  }
  auto Opc = N->getOpcode();
  assert(Opc == ISD::FP_ROUND || Opc == ISD::STRICT_FP_ROUND);
  bool StrictFP = Opc == ISD::STRICT_FP_ROUND;
  SDValue from = StrictFP ? N->getOperand(1) : N->getOperand(0);
  assert(StrictFP ? N->getNumOperands() == 3 : N->getNumOperands() == 2);
  EVT VT = N->getValueType(0);

  if (VT == MVT::f16) {
    if (from.getValueType() == MVT::f64) {
      return lowerfp_round(SDValue(N,0), DAG);
    }
  }

  if (VT.isVector() && VT.getVectorElementType() == MVT::f16) {
    SDLoc dl(N);
    unsigned N = VT.getVectorNumElements();
    assert(N == from.getValueType().getVectorNumElements());
    if (from.getValueType().getVectorElementType() == MVT::f64) {
      SmallVector<SDValue, 4> rounded;
      for (unsigned i = 0; i < N; i++) {
        SDValue fromElt = DAG.getNode(ISD::EXTRACT_VECTOR_ELT, dl, MVT::f64,
                                      from, DAG.getConstant(i, dl, MVT::i32));
        SDValue roundOp = DAG.getFPExtendOrRound(fromElt, dl, MVT::f16);
        SDValue roundElt = lowerfp_round(roundOp, DAG);
        assert(roundElt.getValueType() == MVT::f16);
        rounded.push_back(roundElt);
      }
      return DAG.getBuildVector(VT, dl, rounded);
    }
  }

  return SDValue();
}

SDValue performSIGN_EXTEND_INREGCombine(SDNode *N, SelectionDAG &DAG) {
  assert(N->getOpcode() == ISD::SIGN_EXTEND_INREG);
  if (N->getValueType(0) != MVT::i32) {
    return SDValue();
  }
  SDLoc dl(N);
  EVT widthTy = cast<VTSDNode>(N->getOperand(1))->getVT();

  if (widthTy == MVT::i16 || widthTy == MVT::i8) {
    if (LoadSDNode *LDNode = dyn_cast<LoadSDNode>(N->getOperand(0))) {
      if (LDNode->getMemoryVT() == widthTy) {
        if (LDNode->getExtensionType() == ISD::EXTLOAD) {
          SDValue sextLoad = DAG.getLoad(
              LDNode->getAddressingMode(), ISD::SEXTLOAD,
              LDNode->getValueType(0), dl, LDNode->getChain(),
              LDNode->getBasePtr(), LDNode->getOffset(),
              LDNode->getPointerInfo(), LDNode->getMemoryVT(),
              LDNode->getAlignment(), LDNode->getMemOperand()->getFlags(),
              LDNode->getAAInfo(), LDNode->getRanges());
          DAG.ReplaceAllUsesWith(LDNode, sextLoad.getNode());
          return sextLoad; // Replace SIGN_EXTEND_INREG with the sext load value
        }
      }
    }
  }
  return SDValue();
}

SDValue performEXTENDCombine(SDNode *N, SelectionDAG &DAG) {
  // Look for extract from v2i16 => extend
  // This particular sequence arises when lowering f16 via v2f16

  SDValue Op0 = N->getOperand(0);
  if (Op0.getOpcode() != ISD::EXTRACT_VECTOR_ELT) {
    return SDValue();
  }

  if ((N->getValueType(0) == MVT::i32) && (Op0.getValueType() == MVT::i16)) {
    SDValue vec = Op0.getOperand(0);

    if (vec.getValueType() == MVT::v2i16) {
      ConstantSDNode *idx = dyn_cast<ConstantSDNode>(Op0.getOperand(1));
      if (!idx) {
        return SDValue();
      }

      SDLoc dl(N);
      SDValue i32vec = DAG.getBitcast(MVT::i32, vec);
      SDValue sixteen = DAG.getConstant(16, dl, MVT::i32);
      if (idx->getZExtValue() == 0) {
        if (N->getOpcode() == ISD::ANY_EXTEND) {
          return i32vec;
        }
        if (N->getOpcode() == ISD::SIGN_EXTEND) {
          SDValue left = DAG.getNode(ISD::SHL, dl, MVT::i32, i32vec, sixteen);
          return DAG.getNode(ISD::SRA, dl, MVT::i32, left, sixteen);
        }
        if (N->getOpcode() == ISD::ZERO_EXTEND) {
          // Generates better code than vec & 0xffff
          return DAG.getBitcast(
              MVT::i32,
              DAG.getNode(ISD::INSERT_VECTOR_ELT, dl, MVT::v2i16, vec,
                          DAG.getConstant(UINT64_C(0), dl, MVT::i32),
                          DAG.getConstant(UINT64_C(1), dl, MVT::i32)));
        }
      }
      if (idx->getZExtValue() == 1) {
        if (N->getOpcode() == ISD::ANY_EXTEND ||
            N->getOpcode() == ISD::ZERO_EXTEND) {
          return DAG.getNode(ISD::SRL, dl, MVT::i32, i32vec, sixteen);
        }
        if (N->getOpcode() == ISD::SIGN_EXTEND) {
          return DAG.getNode(ISD::SRA, dl, MVT::i32, i32vec, sixteen);
        }
      }
    }
  }
  return SDValue();
}

SDValue performShiftCombine(SDNode *N, SelectionDAG &DAG,
                            TargetLowering::DAGCombinerInfo &DCI) {
  // This pattern arises when lowering extract_vector_elt
  // Corresponding transforms could be implemented for right shift.
  assert(N->getOpcode() == ISD::SHL);
  assert(N->getNumOperands() == 2);

  auto shiftNode = dyn_cast<ConstantSDNode>(N->getOperand(1));
  if (DCI.isBeforeLegalize() || !shiftNode) {
    return SDValue();
  }

  LLVM_DEBUG(dbgs() << "performShiftCombine: "; N->dump(););
  assert(N->getValueType(0) == MVT::i32);

  EVT VT = MVT::i32;
  SDValue Op0 = peekThroughBitcasts(N->getOperand(0));
  auto shiftBy = shiftNode->getZExtValue();
  SDLoc dl(N);

  if (shiftBy >= 16) {
    if (Op0.getOpcode() == ColossusISD::SORT4X16LO) {
      // (shl (sort4x16lo x y) v) => (shl x v)
      return DAG.getNode(ISD::SHL, dl, VT,
                         DAG.getBitcast(VT, Op0.getOperand(0)),
                         N->getOperand(1));
    }

    if (Op0.getOpcode() == ColossusISD::SORT4X16HI ||
        Op0.getOpcode() == ColossusISD::ROLL16) {
      // (shl (sort4x16hi x y) (+ 16 d)) => (shl (and x ~0xffff) d)
      // where d is often zero, dropping the dependency on y
      // transform also applies to roll16
      SDValue tmp =
          DAG.getNode(ISD::AND, dl, VT, DAG.getBitcast(VT, Op0.getOperand(0)),
                      DAG.getConstant(0xffff0000u, dl, MVT::i32));
      if ((shiftBy - 16) > 0) {
        tmp = DAG.getNode(ISD::SHL, dl, VT, tmp,
                          DAG.getConstant(shiftBy - 16, dl, MVT::i32));
      }
      return tmp;
    }
  }

  return SDValue();
}
}

SDValue
ColossusTargetLowering::PerformDAGCanonicalisation(SDNode *N,
                                                   DAGCombinerInfo &DCI) const {
  SelectionDAG &DAG = DCI.DAG;
  switch (N->getOpcode()) {
  default:
    return SDValue();
  case ISD::ANY_EXTEND_VECTOR_INREG:
  case ISD::SIGN_EXTEND_VECTOR_INREG:
  case ISD::ZERO_EXTEND_VECTOR_INREG:
    return performExtendVectorInregCanonicalisation(N, DAG);
  case ISD::EXTRACT_VECTOR_ELT:
    return performExtractVectorEltCanonicalisation(N, DAG, DCI);
  case ISD::INSERT_VECTOR_ELT:
    return performInsertVectorEltCanonicalisation(N, DAG, DCI);
  }
}

SDValue
ColossusTargetLowering::PerformDAGOptimisation(SDNode *N,
                                               DAGCombinerInfo &DCI) const {
  SelectionDAG &DAG = DCI.DAG;
  switch (N->getOpcode()) {
  default:
    return SDValue();
  case ISD::BUILD_VECTOR:
    return performBuildVectorCombine(N, DAG, DCI);
  case ISD::EXTRACT_VECTOR_ELT:
    return performExtractVectorEltCombine(N, DAG, DCI);
  case ISD::EXTRACT_SUBVECTOR:
    return performExtractSubvectorCombine(N, DAG);
  case ISD::BITCAST:
    return performBitcastCombine(N, DAG, DCI);
  case ISD::LOAD:
    return performLoadCombine(N, DAG);
  case ISD::STORE:
    return performStoreCombine(N, DAG);
  case ISD::FP_ROUND:
  case ISD::STRICT_FP_ROUND:
    return performFP_ROUNDCombine(
        N, DAG, DCI,
        [=](SDValue Op, SelectionDAG &DAG) { return LowerFP_ROUND(Op, DAG); });
  case ISD::SIGN_EXTEND_INREG:
    return performSIGN_EXTEND_INREGCombine(N, DAG);
  case ISD::SIGN_EXTEND:
  case ISD::ZERO_EXTEND:
  case ISD::ANY_EXTEND:
    return performEXTENDCombine(N, DAG);
  case ISD::SHL:
    return performShiftCombine(N, DAG, DCI);
  case ISD::ADD:
  case ISD::SUB:
    return performAddSubCombine(N, DAG, DCI);
  case ISD::AND:
    if (SDValue ret = performAndCombine(N, DAG, DCI))
      return ret;
    LLVM_FALLTHROUGH;
  case ISD::OR:
  case ISD::XOR:
  case ColossusISD::FAND:
  case ColossusISD::FOR:
  case ColossusISD::FNOT:
  case ColossusISD::ANDC:
    return performBitwiseBooleanCombine(N, DAG, DCI);
  case ColossusISD::SORT4X16LO:
    return performSORT4X16LOCombine(N, DAG);
  case ColossusISD::SORT4X16HI:
    return performSORT4X16HICombine(N, DAG);
  case ColossusISD::ROLL16:
    return performROLL16Combine(N, DAG);
  case ColossusISD::SORT8X8LO:
    return performSORT8X8LOCombine(N, DAG);
  case ISD::FP_TO_SINT:
  case ISD::FP_TO_UINT:
  case ISD::STRICT_FP_TO_SINT:
  case ISD::STRICT_FP_TO_UINT:
  case ISD::SINT_TO_FP:
  case ISD::UINT_TO_FP:
  case ISD::STRICT_SINT_TO_FP:
  case ISD::STRICT_UINT_TO_FP:
    return performConversionOptimisation(N, DAG, DCI);
  case ColossusISD::F16ASV2F16:
  case ColossusISD::V2F16ASF16:
    return performF16V2F16ConversionCombine(N, DAG);
  case ISD::FDIV:
  case ISD::STRICT_FDIV:
    return performRSQRTCombine(N, DAG, DCI);
  }
}

SDValue expandColossusSDAGHook(SDNode *N, SelectionDAG &DAG) {
  bool IsChained = false;
  unsigned OpNum = 0;

  if (N->getOpcode() == ISD::INTRINSIC_W_CHAIN) {
    IsChained = true;
    ++OpNum;
  } else if (N->getOpcode() != ISD::INTRINSIC_WO_CHAIN) {
    return SDValue();
  }

  unsigned IntNo = cast<ConstantSDNode>(N->getOperand(OpNum++))->getZExtValue();

  if (IntNo == Intrinsic::colossus_SDAG_unary ||
      IntNo == Intrinsic::colossus_SDAG_chained_unary ||
      IntNo == Intrinsic::colossus_SDAG_binary ||
      IntNo == Intrinsic::colossus_SDAG_binary_binary) {

    ConstantSDNode *ISDIdNode =
        dyn_cast<ConstantSDNode>(N->getOperand(OpNum++));
    if (!ISDIdNode || (ISDIdNode->getValueType(0) != MVT::i32)) {
      report_fatal_error(
          "Intrinsic SDAG requires a constant i32 for the first argument");
    }
    unsigned ISDId = ISDIdNode->getZExtValue();

    SmallVector<EVT, 2> resultTypes;
    for (unsigned i = 0; i < N->getNumValues(); i++) {
      resultTypes.push_back(N->getValueType(i));
    }

    SmallVector<SDValue, 2> operands;
    assert(N->getNumOperands() >= 2);
    if (IsChained) {
      operands.push_back(N->getOperand(0));
    }
    for (unsigned i = OpNum; i < N->getNumOperands(); i++) {
      operands.push_back(N->getOperand(i));
    }

    if (IntNo == Intrinsic::colossus_SDAG_unary) {
      LLVM_DEBUG(dbgs() << "Lowering SDAG_unary node: "; N->dump(););
      assert(N->getNumOperands() == 3);
      assert(resultTypes.size() == 1);
      assert(operands.size() == 1);
    } else if (IntNo == Intrinsic::colossus_SDAG_chained_unary) {
      LLVM_DEBUG(dbgs() << "Lowering SDAG_chained_unary node: "; N->dump(););
      assert(N->getNumOperands() == 4);
      assert(resultTypes.size() == 2);
      assert(operands.size() == 2);
    } else if (IntNo == Intrinsic::colossus_SDAG_binary) {
      LLVM_DEBUG(dbgs() << "Lowering SDAG_binary node: "; N->dump(););
      assert(N->getNumOperands() == 4);
      assert(resultTypes.size() == 1);
      assert(operands.size() == 2);
    } else if (IntNo == Intrinsic::colossus_SDAG_binary_binary) {
      LLVM_DEBUG(dbgs() << "Lowering SDAG_binary_binary node: "; N->dump(););
      assert(N->getNumOperands() == 4);
      assert(resultTypes.size() == 2);
      assert(operands.size() == 2);
    }

    SDLoc dl(N);
    SDValue Res = DAG.getNode(ISDId, dl, resultTypes, operands);
    return Res;
  }

  return SDValue();
}

/// Tests whether there's a potential cycle after the result of a DAG
/// optimisation, given as \p R.
///
/// \remark The test is essentially done by tracking the number of cycle checks
/// done since the last bitcast operand was tracked and revisited, which if it
/// repeats, it's considered to be likely an infinite recursion.
bool ColossusTargetLowering::isLikelyDAGCombineCycle(SDValue R) const {
  // Track the number of cycle checks done since the last tracked bitcast op.
  if (LastBitcastOp)
    ++NumRoundsSinceLastBitcastOp;

  if (R->getOpcode() != ISD::BITCAST)
    return false;

  SDValue BitcastOp = R->getOperand(0);

  // Reset if there's no bitcast op tracked or there's a new bitcast op seen.
  if (!LastBitcastOp || (LastBitcastOp != BitcastOp)) {
    LastBitcastOp = BitcastOp;
    NumRoundsSinceLastBitcastOp = 0;
    SavedNumRounds.reset();
    return false;
  }

  if (LastBitcastOp != BitcastOp)
    return false;

  // The same bitcast operand was seen. Save the number of cycle checks since
  // the operand was first tracked.
  if (!SavedNumRounds) {
    SavedNumRounds = NumRoundsSinceLastBitcastOp;
    NumRoundsSinceLastBitcastOp = 0;
    return false;
  }

  // If the same node was revisited with the same number of cycle checks
  // in-between, then it's likely a cycle.
  //
  // NOTE: If this cycle detection results in a regression somewhere, it can
  // be improved by simply adding a threshold on the number tests.
  bool IsLikelyCycle = *SavedNumRounds == NumRoundsSinceLastBitcastOp;

  LLVM_DEBUG({
    if (IsLikelyCycle) {
      llvm::dbgs() << "Potential cycle detected: '";
      BitcastOp->dump();
      llvm::dbgs() << "' revisited with the same number of combinations "
                   << "in-between!";
    }
  });

  return IsLikelyCycle;
}

SDValue ColossusTargetLowering::PerformDAGCombine(SDNode *N,
                                                  DAGCombinerInfo &DCI) const {
  if (SDValue h = expandColossusSDAGHook(N, DCI.DAG)) {
    return h;
  }
  if (SDValue c = PerformDAGCanonicalisation(N, DCI)) {
    return c;
  }
  if (SDValue o = PerformDAGOptimisation(N, DCI)) {
    if (isLikelyDAGCombineCycle(o)) {
      LLVM_DEBUG(llvm::dbgs()
                     << "Discarding value due to potential combine cycle: ";
                 o->dump());
      return {};
    }

    return o;
  }
  return SDValue();
}

// After DAG combines, and before ISelDAGToDAG, there is a customisation hook to perform
// any final DAG rewrites. This hook is on DAGToDAGISel but has a lot in common with
// ISelLowering. Prior to moving the implementation here, there was an increasing number
// of exposed static functions for code reuse between the two.
// Implementing here means ISelDAGToDAG can focus on translation between DAGs

namespace {
SDValue storeConstantsViaInstantiatingOnARF(SDNode *N, SelectionDAG &DAG) {
  // Instantiating the constant on the ARF before storing using the MRF
  // improves the balance between the two pipelines. It also allows 64bit
  // stores in a single operation. This cannot be done at ISel DAGCombine
  // because it conflicts with a generic transform that rewrites in favour
  // of instantiating the constant as an integer before the store.
  StoreSDNode *SDNode = dyn_cast<StoreSDNode>(N);
  if (!SDNode) {
    return SDValue();
  }
  SDLoc dl(SDNode);
  EVT MemVT = SDNode->getMemoryVT();
  if (MemVT.isInteger()) {

    if (SDNode->isTruncatingStore()) {
      // Scalar truncating stores were lowered to library calls
      // v2i32 to v2i16 may make it this far
      return SDValue();
    }

    unsigned s = MemVT.getSizeInBits();
    assert(s == 32 || s == 64);
    SDValue Value = SDNode->getValue();
    if (isCanonicalConstant(Value)) {
      SDValue c = DAG.getBitcast(s == 32 ? MVT::f32 : MVT::v2f32, Value);
      SDValue newValue = getCanonicalConstant(c, DAG);
      assert(isCanonicalConstant(newValue));

      return deriveStoreFromExisting(DAG, SDNode, newValue);
    }
  }

  return SDValue();
}

SDValue split64BitIntegerLoad(SDNode *N, SelectionDAG &DAG) {
  if (N->getOpcode() != ISD::LOAD) {
    return SDValue();
  }
  LoadSDNode *LDNode = cast<LoadSDNode>(N);
  SDLoc dl(LDNode);

  EVT MemVT = LDNode->getMemoryVT();
  if (MemVT == MVT::v2i32 || MemVT == MVT::v4i16) {
    if (!ISD::isNON_EXTLoad(LDNode)) {
      report_fatal_error("Unexpected extending vector load");
    }
    unsigned Align = LDNode->getAlignment();
    if (Align < MemVT.getStoreSize()) {
      report_fatal_error("Unexpected abnormally aligned load");
    }
    SDValue Chain = LDNode->getChain();
    EVT SplitVT = (MemVT == MVT::v2i32) ? MVT::i32 : MVT::v2i16;
    unsigned Size = MemVT.getStoreSize() / 2;
    SDValue AddrLo = LDNode->getBasePtr();
    SDValue AddrHi = incrBySize(DAG, dl, AddrLo, Size);

    auto &pInfo = LDNode->getPointerInfo();
    auto flags = LDNode->getMemOperand()->getFlags();
    SDValue Lo = DAG.getLoad(SplitVT, dl, Chain, AddrLo, pInfo, Align, flags);
    SDValue Hi = DAG.getLoad(SplitVT, dl, Chain, AddrHi,
                             pInfo.getWithOffset(Size),
                             (Align + Size) % Align, flags);

    SDValue OutRes = concatValues(Lo, Hi, DAG);
    SDValue OutChains[] = {SDValue(Hi.getNode(), 1), SDValue(Lo.getNode(), 1)};
    SDValue OutChain = DAG.getNode(ISD::TokenFactor, dl, MVT::Other, OutChains);

    if (LDNode->isUnindexed())
      return DAG.getMergeValues({OutRes, OutChain}, dl);

    assert(LDNode->getAddressingMode() == ISD::POST_INC);
    SDValue bytesOffset = LDNode->getOffset();

    // Future optimisation should sometimes fold this into one of the loads
    SDValue postincOffset = incrBySize(DAG, dl, AddrLo, bytesOffset);

    return DAG.getMergeValues({OutRes, postincOffset, OutChain}, dl);
  }
  return SDValue();
}

SDValue split64BitIntegerStore(SDNode *N, SelectionDAG &DAG) {
  StoreSDNode *SDNode = dyn_cast<StoreSDNode>(N);
  if (!SDNode) {
    return SDValue();
  }
  SDLoc dl(SDNode);

  EVT MemVT = SDNode->getMemoryVT();

  if (MemVT == MVT::v2i32 || MemVT == MVT::v4i16) {
    if (SDNode->isTruncatingStore()) {
      report_fatal_error("Unexpected truncating vector store");
    }
    unsigned Align = SDNode->getAlignment();
    if (Align < MemVT.getStoreSize()) {
      report_fatal_error("Unexpected abnormally aligned store");
    }
    SDValue Chain = SDNode->getChain();
    SDValue Value = SDNode->getValue();
    unsigned Size = MemVT.getStoreSize() / 2;
    SDValue AddrLo = SDNode->getBasePtr();
    SDValue AddrHi = incrBySize(DAG, dl, AddrLo, Size);

    auto split = splitValue(Value, DAG);
    auto &pInfo = SDNode->getPointerInfo();
    auto flags = SDNode->getMemOperand()->getFlags();

    SDValue OutChains[2];
    OutChains[0] =
        DAG.getStore(Chain, dl, split.first, AddrLo, pInfo, Align, flags);
    OutChains[1] = DAG.getStore(Chain, dl, split.second, AddrHi,
                                pInfo.getWithOffset(Size),
                                (Align + Size) % Align, flags);
    SDValue OutChain = DAG.getNode(ISD::TokenFactor, dl, MVT::Other, OutChains);

    if (SDNode->isUnindexed())
      return OutChain;

    assert(SDNode->getAddressingMode() == ISD::POST_INC);
    SDValue bytesOffset = SDNode->getOffset();

    // Future optimisation should sometimes fold this into one of the stores
    SDValue postincOffset = incrBySize(DAG, dl, AddrLo, bytesOffset);

    // Uses of the value
    return DAG.getMergeValues({postincOffset, OutChain}, dl);
  }

  return SDValue();
}

SDValue replaceUnsupportedPostincMemoryOp(SDNode *N, SelectionDAG &DAG) {
  switch (N->getOpcode()) {
  case ISD::LOAD: {
    return performLoadCombine(N, DAG);
  }
  case ISD::STORE: {
    return performStoreCombine(N, DAG);
  }
  default: { return SDValue(); }
  }
}

SDValue replaceUndefs(SDNode *N, SelectionDAG &DAG) {
  auto Op = peekThroughBitcasts(SDValue{N, 0});
  auto VT = Op.getValueType();
  auto dl = SDLoc{N};
  auto Opc = Op.getOpcode();

  switch (Opc) {
    case ISD::CONCAT_VECTORS:
    case ColossusISD::CONCAT_VECTORS: {
      assert(Op.getNumOperands() == 2);
      auto arg0 = Op.getOperand(0);
      auto arg1 = Op.getOperand(1);
      // A concat of 2 undef values makes no sense.
      assert((!arg0->isUndef() || !arg1->isUndef()) && "Not in canonical form");

      bool changed = false;
      auto replaceUndefVectorElems = [&](SDValue &arg) -> SDValue {
        if (arg->isUndef())
          return arg;

        auto NewArg = replaceUndefs(arg.getNode(), DAG);
        if (!NewArg)
          return arg;

        changed = true;
        return NewArg;
      };
      arg0 = replaceUndefVectorElems(arg0);
      arg1 = replaceUndefVectorElems(arg1);

      // While Undef values are legal with the default
      // -ffp-exception-behavior value and allow more optimisations to
      // happen, the code actually ends up being used with exceptions
      // enabled. So we use arg0 twice for the concat vector since we know it
      // to be defined.
      if (VT.isFloatingPoint() && arg0->isUndef()) {
        changed = true;
        arg0 = arg1;
      } else if (VT.isFloatingPoint() && arg1->isUndef()) {
        changed = true;
        arg1 = arg0;
      }

      if (!changed)
        return {};

      return DAG.getNode(Opc, dl, VT, arg0, arg1);
    }
    case ISD::BUILD_VECTOR: {
      auto const numArgs = Op.getNumOperands();
      auto isAllOnes = true;
      auto numUndefs = 0u;

      for (auto i = 0u; i < numArgs; ++i) {
        auto arg = Op.getOperand(i);

        if (isCanonicalConstant(arg)) {
          if (!allBitsSet(arg)) {
            isAllOnes = false;
          }
        }
        else if (arg.isUndef()) {
          numUndefs += 1u;
        }
        else {
          return {};
        }
      }

      if (numUndefs == 0u) {
        return {};
      }

      auto const argVT = Op.getOperand(0).getValueType();
      auto const bitWidth = argVT.getSizeInBits();
      auto const undefVal = uint64_t(isAllOnes ? -1 : 0) >> (64u - bitWidth);

      auto replacement = makeCanonicalConstant(undefVal, argVT, dl, DAG);
      auto buildVecArgs = SmallVector<SDValue, 4>{};

      for (auto i = 0u; i < numArgs; ++i) {
        auto arg = Op.getOperand(i);
        if (arg.isUndef()) {
          arg = replacement;
        }
        buildVecArgs.push_back(arg);
      }

      return DAG.getBuildVector(VT, dl, buildVecArgs);
    }
  }

  return {};
}

bool isLegalImmForCmp(int64_t Imm) {
  return isUInt<16>(Imm);
}

SDValue expandSetcc(SDNode *N, SelectionDAG &DAG) {
  SDLoc dl(N);
  // i32 setcc has instruction support for eq, ne, slt, ult
  auto getSetCC = [&](SDValue lhs, SDValue rhs, ISD::CondCode cc) {
    return DAG.getSetCC(dl, MVT::i32, lhs, rhs, cc);
  };
  auto withEqZero = [&](SDValue X) {
    SDValue zero = DAG.getConstant(0, dl, MVT::i32);
    return DAG.getSetCC(dl, MVT::i32, X, zero, ISD::SETEQ);
  };

  if (N->getOpcode() == ISD::SETCC) {
    SDValue LHS = N->getOperand(0);
    SDValue RHS = N->getOperand(1);
    if (LHS.getValueType() == MVT::i32) {
      ISD::CondCode CC = cast<CondCodeSDNode>(N->getOperand(2))->get();

      switch (CC) {
      default: { return SDValue(); }
      case ISD::SETGT: {
        return getSetCC(RHS, LHS, ISD::SETLT);
      }
      case ISD::SETUGT: {
        return getSetCC(RHS, LHS, ISD::SETULT);
      }
      case ISD::SETLE: {
        return withEqZero(getSetCC(RHS, LHS, ISD::SETLT));
      }
      case ISD::SETULE: {
        return withEqZero(getSetCC(RHS, LHS, ISD::SETULT));
      }
      case ISD::SETGE: {
        return withEqZero(getSetCC(LHS, RHS, ISD::SETLT));
      }
      case ISD::SETUGE: {
        return withEqZero(getSetCC(LHS, RHS, ISD::SETULT));
      }
      case ISD::SETNE: {
        // As cmpne doesn't have an encoding for an immediate, we require an 
        // additional regiester to materialise it.
        // Replace: 
        // setzi $m1, 12345
        // cmpne $mResult $m0, $m0
        // with:
        // cmpeq $mResult, $m0, 12345 
        // cmpeq $mResult, $mResult, 0
        //
        // if immediate is zero, then we can use $m15:
        // cmpne $mResult, $m0, $m15
        auto cRHS = dyn_cast<ConstantSDNode>(RHS);
        if (cRHS && cRHS->getSExtValue() != 0 && 
            isLegalImmForCmp(cRHS->getSExtValue())) {
          return withEqZero(getSetCC(LHS, RHS, ISD::SETEQ));
        }
      }
      }
    }
  }
  return SDValue();
}

// Convert bitwise operations on 64bit-wide vectors to two operations on 32bit
// scalar when the second operand is an immediate to allow folding it into the
// instruction during select.
SDValue split64BitIntegerBitwiseOps(SDNode *N, SelectionDAG &DAG) {
  SDLoc dl(N);
  EVT VT = N->getValueType(0);
  // Bail out on unsupported vector type
  if (!(VT == MVT::v2i32 || VT == MVT::v4i16)) {
    return SDValue();
  }
  static const unsigned tab[] = {ISD::AND, ISD::OR, ColossusISD::ANDC};
  unsigned opc = N->getOpcode();
  // Only do the transform for supported instructions
  if (std::find(std::begin(tab), std::end(tab), opc) == std::end(tab)) {
    return SDValue();
  }

  SDValue op1 = N->getOperand(1);
  // Only fold if one operand is a constant
  if (!isCanonicalConstant(op1)) {
    return SDValue();
  }

  EVT Via = MVT::i32;
  SDValue op0 = N->getOperand(0);
  // Split operand 0 into two 32bit parts
  auto op0Split = splitValue(op0, DAG);
  EVT splitVT = op0Split.first.getValueType();
  // Cast to 32bit scalar
  SDValue op0Lo = DAG.getBitcast(Via, op0Split.first);
  SDValue op0Hi = DAG.getBitcast(Via, op0Split.second);

  // Split 64bit constant into two 32bit scalars
  uint64_t op1Value = CTL::SDValueToUINT64(op1, DAG).getValue();
  SDValue op1Lo = makeCanonicalConstant(op1Value & 0xFFFFFFFFu, Via,
                                             SDLoc(op1), DAG);
  SDValue op1Hi =
      makeCanonicalConstant(op1Value >> 32u, Via, SDLoc(op1), DAG);

  // Perform operation on each set of 32bit scalar and reconstruct vector of
  // same type as original operand 0.
  SDValue resLo =
      DAG.getBitcast(splitVT, DAG.getNode(opc, dl, Via, op0Lo, op1Lo));
  SDValue resHi =
      DAG.getBitcast(splitVT, DAG.getNode(opc, dl, Via, op0Hi, op1Hi));
  // Create full vector from both half and return
  return concatValues(resLo, resHi, DAG, VT.getSimpleVT());
}

SDValue castv2x16(SDNode *N, SelectionDAG &DAG) {
  // Convert bitwise operations on v2x16 to x32 when the second operand is an
  // immediate to allow folding it into the instruction during select.
  SDLoc dl(N);
  EVT VT = N->getValueType(0);
  if (!(VT == MVT::v2i16 || VT == MVT::v2f16)) {
    return SDValue();
  }

  static unsigned tab[] = {
      ISD::AND,          ISD::OR,          ISD::XOR,
      ColossusISD::FAND, ColossusISD::FOR, ColossusISD::ANDC,
  };
  unsigned opc = N->getOpcode();
  if (std::find(std::begin(tab), std::end(tab), opc) == std::end(tab)) {
    return SDValue();
  }

  SDValue op1 = N->getOperand(1);
  if (!isCanonicalConstant(op1)) {
    return SDValue();
  }

  auto value = ColossusTargetLowering::SDValueToUINT64(op1, DAG);
  if (!value) {
    return SDValue();
  }
  // Constant does not fit in zimm12 or (for v2f16) immz12 and there are other
  // uses.
  if (!op1.hasOneUse() && (*value >= (1 << 12)) &&
      ((VT != MVT::v2f16) || (*value & ((1 << 20) - 1)))) {
    return SDValue();
  }

  EVT Via = (VT == MVT::v2i16) ? MVT::i32 : MVT::f32;
  SDValue op0 = DAG.getBitcast(Via, N->getOperand(0));
  op1 = getCanonicalConstant(DAG.getBitcast(Via, op1), DAG);
  return DAG.getBitcast(VT, DAG.getNode(opc, dl, Via, op0, op1));
}

SDValue invertBranch(SDNode *N, SelectionDAG &DAG) {
  // ISD::SETNE and ISD::SETEQ can be swapped by also swapping the labels
  // used by the branches at the end of the basic block
  // cmpeq has imm16zi and imm16si versions but cmpne does not
  // there is a brnzdec instruction that will benefit from cmpne x 0

  auto canInvert = [&](ISD::CondCode c) {
    return c == ISD::SETEQ || c == ISD::SETNE;
  };
  auto invertCC = [&](ISD::CondCode c) {
    assert(canInvert(c));
    return c == ISD::SETEQ ? ISD::SETNE : ISD::SETEQ;
  };

  SDLoc dl(N);
  if (N->getOpcode() == ISD::BR) {
    SDValue br_ch = N->getOperand(0);
    SDValue br_bb = N->getOperand(1);
    if (br_ch->getOpcode() == ISD::BRCOND) {
      SDValue brcond_ch = br_ch.getOperand(0);
      SDValue brcond_cc = br_ch.getOperand(1);
      SDValue brcond_bb = br_ch.getOperand(2);

      if ((brcond_cc.getOpcode() != ISD::SETCC) ||
          (brcond_cc.getValueType() != MVT::i32)) {
        return SDValue();
      }

      SDValue LHS = brcond_cc.getOperand(0);
      SDValue RHS = brcond_cc.getOperand(1);
      ISD::CondCode CC = cast<CondCodeSDNode>(brcond_cc.getOperand(2))->get();
      if (canInvert(CC)) {
        auto cRHS = dyn_cast<ConstantSDNode>(RHS);
        if (cRHS) {
          bool invertProfitable =
              (CC == ISD::SETEQ && (cRHS->getZExtValue() == 0)) ||
              (CC == ISD::SETNE);
          if (invertProfitable) {
            return DAG.getNode(
                ISD::BR, dl, MVT::Other,
                DAG.getNode(ISD::BRCOND, dl, MVT::Other, brcond_ch,
                            DAG.getSetCC(dl, MVT::i32, LHS, RHS, invertCC(CC)),
                            br_bb),
                brcond_bb);
          }
        }
      }
    }
  }
  return SDValue();
}
}

SDValue reorderVectorOpExpr(SDNode *N, SelectionDAG &DAG) {
  // operator(BUILD_VECTOR(x, x), BUILD_VECTOR(y, y))
  //   ->
  // BUILD_VECTOR(operator(x, y), operator(x, y))

  // Cmp(BUILD_VECTOR(x, x), BUILD_VECTOR(y, y), cond)
  //   ->
  // BUILD_VECTOR(Cmp(x, y, cond), Cmp(x, y, cond))

  // operator(CONCAT_VECTORS(BUILD_VECTOR(a, b), BUILD_VECTOR(a, b)),
  //          CONCAT_VECTORS(BUILD_VECTOR(c, d), BUILD_VECTOR(c, d)))
  //   ->
  // CONCAT_VECTORS(operator(BUILD_VECTOR(a, b), BUILD_VECTOR(c, d)),
  //                operator(BUILD_VECTOR(a, b), BUILD_VECTOR(c, d)))

  // with VT == v4f16 or VT == v4i16:
  // operator(CONCAT_VECTORS(BUILD_VECTOR(a, b), BUILD_VECTOR(b, a)),
  //          CONCAT_VECTORS(BUILD_VECTOR(c, d), BUILD_VECTOR(d, c)))
  //   ->
  // CONCAT_VECTORS(     operator(BUILD_VECTOR(a, b), BUILD_VECTOR(c, d)),
  //                swap(operator(BUILD_VECTOR(a, b), BUILD_VECTOR(c, d))))
  auto VT = N->getValueType(0u);
  if (!VT.isVector())
    return {};

  // There are no f16 instructions so do not reduce v2f16 operations.
  if (VT == MVT::v2f16)
    return {};
  auto const vec_size = VT.getVectorNumElements();
  unsigned Opc = N->getOpcode();

  auto const fcmp = Opc == ColossusISD::FCMP;
  auto const fnot = Opc == ColossusISD::FNOT;
  bool binop_root = N->getNumOperands() == 2u;
  // ColossusFCMP node has 3 operands.
  if (!binop_root && !fnot && !fcmp)
    return {};

  auto const vec_root_opc = [&]() {
    if (vec_size == 2u) {
      return unsigned(ISD::BUILD_VECTOR);
    }
    return unsigned(ColossusISD::CONCAT_VECTORS);
  }();

  // Set to indicate that the two vectors have the format abba & cddc:
  bool palindromes = (VT == MVT::v4f16) || (VT == MVT::v4i16);
  auto HasSingleNodeUse = [](SDValue op) {
    SDNode *node = nullptr;
    for (auto UI = op->use_begin(), E = op->use_end(); UI != E; ++UI) {
      if (UI.getUse().getResNo() != op.getResNo())
        continue;
      if (!node)
        node = UI.getUse().getNode();
      if (UI.getUse().getNode() != node)
        return false;
    }
    return true;
  };

  auto op0VT = N->getOperand(0u).getValueType();
  for (auto &operand : N->op_values()) {
    if (fcmp && dyn_cast<CondCodeSDNode>(operand.getNode()))
      continue;
    auto curr_op = peekThroughBitcasts(operand);
    auto opVT = operand.getValueType();
    if (opVT != op0VT || !opVT.isVector() ||
        opVT.getVectorNumElements() != vec_size || !HasSingleNodeUse(operand) ||
        !HasSingleNodeUse(curr_op) || curr_op.getNumOperands() != 2u ||
        curr_op.getOpcode() != vec_root_opc)
      return {};

    auto op0 = peekThroughBitcasts(curr_op.getOperand(0u));
    auto op1 = peekThroughBitcasts(curr_op.getOperand(1u));
    if (palindromes && (!op0.getValueType().isVector() ||
                        !op1.getValueType().isVector() ||
                         op0.getOperand(0u) != op1.getOperand(1u) ||
                         op0.getOperand(1u) != op1.getOperand(0u)))
      palindromes = false;
    if (!palindromes && op0 != op1)
      return {};
  }

  SmallVector<SDValue, 2u> vecs;
  for (auto &curr_op : N->op_values()) {
    if (fcmp && dyn_cast<CondCodeSDNode>(curr_op.getNode()))
      continue;
    vecs.push_back(peekThroughBitcasts(curr_op));
  }

  LLVM_DEBUG(dbgs() << "\nReordering: ";
    bool first = true;
    for (auto &curr_vec : vecs) {
      if (first)
        first = false;
      else
        dbgs() << "            ";
      curr_vec->dump(&DAG);
    }
    dbgs() << "            ";
    N->dump(&DAG););

  auto dl = SDLoc(N);
  auto newVT = vec_size == 2u
                   ? VT.getScalarType()
                   : VT.getHalfNumVectorElementsVT(*DAG.getContext());
  auto newOpVT = vec_size == 2u
                     ? op0VT.getScalarType()
                     : op0VT.getHalfNumVectorElementsVT(*DAG.getContext());

  SmallVector<SDValue, 2u> op_operands;
  for (auto &curr_vec : vecs)
    op_operands.push_back(curr_vec.getOperand(0u));

  for (auto &op : op_operands) {
    if (op.getValueType() != newOpVT) {
      op = DAG.getBitcast(newOpVT, op);
    }
  }

  auto oper = fcmp ? DAG.getNode(Opc, dl, newVT, op_operands[0], op_operands[1],
                                 N->getOperand(2))
                   : DAG.getNode(Opc, dl, newVT, op_operands);
  auto vec_root = DAG.getNode(vec_root_opc, dl, VT, oper, oper);

  if (palindromes) {
    auto swapped_oper = DAG.getNode(ColossusISD::ROLL16, dl, newVT, oper, oper);
    vec_root = DAG.getNode(vec_root_opc, dl, VT, oper, swapped_oper);
  }

  LLVM_DEBUG(
    dbgs() << "  To: "; vec_root->dump(&DAG);
    dbgs() << "      "; oper->dump(&DAG);

    if (vec_size == 4u) {
      for (auto &op : op_operands) {
        dbgs() << "      "; op->dump(&DAG);
      }
    }

    dbgs() << "\n";
  );

  return vec_root;
}

SDValue reorderBitcastVectorExpr(SDNode *N, SelectionDAG &DAG) {
  if (N->getOpcode() != ISD::BITCAST)
    return {};

  auto const VT = N->getValueType(0u);
  if (!VT.isVector())
    return {};

  auto const vec_size = VT.getVectorNumElements();
  auto const vec_root_opc = [&]() {
    if (vec_size == 2u) {
      return unsigned(ISD::BUILD_VECTOR);
    }
    return unsigned(ColossusISD::CONCAT_VECTORS);
  }();

  auto vec_root = N->getOperand(0);
  if (vec_root.getNumOperands() != 2u || vec_root.getOpcode() != vec_root_opc)
    return {};

  auto op0 = peekThroughBitcasts(vec_root.getOperand(0u));
  auto op1 = peekThroughBitcasts(vec_root.getOperand(1u));
  if (op0 != op1)
    return {};

  auto dl = SDLoc(N);
  auto newVT = vec_size == 2u
                   ? VT.getScalarType()
                   : VT.getHalfNumVectorElementsVT(*DAG.getContext());

  auto cast = DAG.getBitcast(newVT, op0);
  vec_root = DAG.getNode(vec_root_opc, dl, VT, cast, cast);
  return vec_root;
}

void ColossusTargetLowering::PostprocessForDAGToDAG(
  SelectionDAG *CurDAG, const ColossusSubtarget &Subtarget) {
  enum executionModes {
    emWorker,
    emBoth,
  };

  for (auto transform : {
      std::make_pair(storeConstantsViaInstantiatingOnARF, emWorker),
      std::make_pair(split64BitIntegerStore,              emBoth),
      std::make_pair(split64BitIntegerLoad,               emBoth),
      std::make_pair(replaceUnsupportedPostincMemoryOp,   emBoth),
      std::make_pair(replaceUndefs,                       emBoth),
      std::make_pair(expandSetcc,                         emBoth),
      std::make_pair(split64BitIntegerBitwiseOps,         emBoth),
      std::make_pair(castv2x16,                           emBoth),
      std::make_pair(invertBranch,                        emBoth),
      std::make_pair(reorderVectorOpExpr,                 emBoth),
      std::make_pair(reorderBitcastVectorExpr,            emBoth),
  }) {
    // Skip worker transformations
    if (transform.second == emWorker && !Subtarget.isWorkerMode())
      continue;
    // Apply each transform in sequence to all nodes to allow one transform
    // to act on the output of it's predecessor
    for (SelectionDAG::allnodes_iterator I = CurDAG->allnodes_begin(),
                                         E = CurDAG->allnodes_end();
         I != E;) {
      SDNode *N = &*I++; // Preincrement iterator to avoid invalidation issues.
      if (SDValue res = transform.first(N, *CurDAG)) {
        --I;
        // Combine has already run so nothing will fold the merge values later.
        if (res.getOpcode() == ISD::MERGE_VALUES) {
          SmallVector<SDValue, 8> Ops(res.getNode()->op_values());
          CurDAG->ReplaceAllUsesWith(N, Ops.data());
        } else {
          CurDAG->ReplaceAllUsesWith(N, res.getNode());
        }
        ++I;
        CurDAG->DeleteNode(N);
      }
    }
    CurDAG->RemoveDeadNodes();
  }
}

/// Return the register class that should be used for the specified value type.
/// We provide a custom implementation of this function in order that the
/// accumulator registers are not chosen for the allocation of virtual ones.
const TargetRegisterClass *ColossusTargetLowering::
getRegClassFor(MVT VT, bool isDivergent) const {
  if (VT.isInteger()) {
    if (VT.getStoreSize() <= 4) return &Colossus::MRRegClass;
    if (VT.getStoreSize() == 8) return &Colossus::MRPairRegClass;
  }
  if (VT.isFloatingPoint()) {
    if (VT.getStoreSize() <= 4)  return &Colossus::ARRegClass;
    if (VT.getStoreSize() == 8)  return &Colossus::ARPairRegClass;
  }
  llvm_unreachable("Unexpected type for register class");
}

/// Return true if target always beneficiates from combining into FMA for a
/// given value type. This must typically return false on targets where FMA
/// takes more cycles to execute than FADD.
bool ColossusTargetLowering::enableAggressiveFMAFusion(EVT VT) const {
  return false;
}

/// Return true if an FMA operation is faster than a pair of fmul and fadd
/// instructions.
bool ColossusTargetLowering::isFMAFasterThanFMulAndFAdd(
    const MachineFunction &MF, EVT VT) const {
  return false;
}

EVT ColossusTargetLowering::
getSetCCResultType(const DataLayout &, LLVMContext &, EVT VT) const {
  if (!VT.isVector()) {
    return MVT::i32;
  }
  return VT.changeVectorElementTypeToInteger();
}

bool ColossusTargetLowering::isLegalICmpImmediate(int64_t Imm) const {
  return isLegalImmForCmp(Imm);
}

bool ColossusTargetLowering::isLegalAddImmediate(int64_t Imm) const {
  return isInt<16>(Imm) || isUInt<16>(static_cast<uint64_t>(Imm));
}

bool ColossusTargetLowering::targetShrinkDemandedConstant(
    SDValue Op, const APInt &DemandedBits, const APInt &DemandedElts,
    TargetLoweringOpt &TLO) const {
  if (Op.getOpcode() == ISD::AND) {
    if (auto *RHSC = dyn_cast<ConstantSDNode>(Op.getOperand(1))) {
      APInt NegatedC = ~RHSC->getAPIntValue();
      // Returning true means preventing shrinking the constant.
      return NegatedC.getActiveBits() <= 20;
    }
  }
  return false;
}

llvm::Optional<uint64_t>
ColossusTargetLowering::SDValueToUINT64(SDValue Op, SelectionDAG &DAG) {
  if (!Op) {
    return {};
  }
  Op = peekThroughBitcasts(Op);
  EVT VT = Op.getValueType();
  if (VT.getSizeInBits() > 64) {
    return {};
  }

  if (ConstantSDNode *i = dyn_cast<ConstantSDNode>(Op)) {
    return i->getZExtValue();
  }

  if (ConstantFPSDNode *f = dyn_cast<ConstantFPSDNode>(Op)) {
    return f->getValueAPF().bitcastToAPInt().getZExtValue();
  }
  unsigned Opc = Op.getOpcode();

  if (VT == MVT::v4i16 || VT == MVT::v4f16) {
    if (Opc == ColossusISD::CONCAT_VECTORS || Opc == ISD::CONCAT_VECTORS) {
      assert(Op.getNumOperands() == 2);
      SDValue lo = Op.getOperand(0);
      SDValue hi = Op.getOperand(1);
      assert(lo.getValueType() == hi.getValueType());
      assert(lo.getValueType().getSizeInBits() == 32);
      auto loUint = SDValueToUINT64(lo, DAG);
      auto hiUint = SDValueToUINT64(hi, DAG);
      if (loUint.hasValue() && hiUint.hasValue()) {
        return loUint.getValue() | (hiUint.getValue() << 32u);
      }
    }
  }

  if (Opc == ISD::BUILD_VECTOR) {
    const unsigned SS = VT.getScalarSizeInBits();
    if (!(SS == 16 || SS == 32)) {
      return {};
    }

    unsigned N = Op.getNumOperands();
    SmallVector<uint64_t, 4> ops;
    for (unsigned i = 0; i < N; i++) {
      auto c = SDValueToUINT64(Op.getOperand(i), DAG);
      if (c.hasValue()) {
        uint64_t elementValue = c.getValue();
        if (VT.isInteger() && SS == 16) {
          elementValue &= 0xFFFFu; // truncating semantics
        }
        if (isUIntN(SS, elementValue)) {
          ops.push_back(elementValue);
        }
      }
    }
    if (ops.size() != N) {
      return {};
    }

    if (N == 2) {
      if (SS == 32) {
        return ops[0] | (ops[1] << 32u);
      }
      if (SS == 16) {
        return ops[0] | (ops[1] << 16u);
      }
    }

    if (N == 4) {
      if (SS == 16) {
        return ops[0] | (ops[1] << 16u) | (ops[2] << 32u) | (ops[3] << 48u);
      }
    }
  }

  return {};
}

SDValue ColossusTargetLowering::exactDivideConstant(SelectionDAG *DAG, SDValue val, int64_t by)
{
  SDLoc dl(val);
  if (by == 0 || val.getValueType() != MVT::i32) {
    return {};
  }

  if (ConstantSDNode *numerator = dyn_cast<ConstantSDNode>(val)) {
    int64_t imm = numerator->getSExtValue();
    int64_t d = imm / by;
    if (d * by == imm) {
      return DAG->getConstant(d, dl, MVT::i32);
    }
  }

  return {};
}

SDValue ColossusTargetLowering::exactDivideVariable(SelectionDAG *DAG, SDValue val, int64_t by)
{
  SDLoc dl(val);
  if (by == 0 || val.getValueType() != MVT::i32) {
    return {};
  }

  if (by == 1) {
    return val;
  }

  // Can divide by reaching through a multiplication
  if (val.getOpcode() == ISD::MUL) {
    if (auto *multiplier = dyn_cast<ConstantSDNode>(val.getOperand(1))) {
      if (by == multiplier->getSExtValue()) {
        return val.getOperand(0);
      }
    }
  }

  // Multiplication may have been normalised to a shift
  if (val.getOpcode() == ISD::SHL) {
    if (auto *shiftAmount = dyn_cast<ConstantSDNode>(val.getOperand(1))) {
      if (by == (1u << shiftAmount->getZExtValue())) {
        return val.getOperand(0);
      }
    }
  }

  return {};
}
//===----------------------------------------------------------------------===//
//                            Custom lowering
//===----------------------------------------------------------------------===//

static void lowerFP16IntConversion(SDNode *N, SmallVectorImpl<SDValue> &Results,
                                   SelectionDAG &DAG) {
  // Lower conversion between f16 and integers wider than i32 by converting
  // via i32.
  unsigned Opc = N->getOpcode();
  assert((Opc == ISD::FP_TO_UINT) || (Opc == ISD::FP_TO_SINT) ||
         (Opc == ISD::STRICT_FP_TO_UINT) || (Opc == ISD::STRICT_FP_TO_SINT) ||
         (Opc == ISD::UINT_TO_FP) || (Opc == ISD::SINT_TO_FP) ||
         (Opc == ISD::STRICT_UINT_TO_FP) || (Opc == ISD::STRICT_SINT_TO_FP));
  bool IsSigned =
      ((Opc == ISD::FP_TO_SINT) || (Opc == ISD::SINT_TO_FP) ||
       (Opc == ISD::STRICT_FP_TO_SINT) || (Opc == ISD::STRICT_SINT_TO_FP));
  bool StrictFP =
      ((Opc == ISD::STRICT_FP_TO_UINT) || (Opc == ISD::STRICT_FP_TO_SINT) ||
       (Opc == ISD::STRICT_UINT_TO_FP) || (Opc == ISD::STRICT_SINT_TO_FP));
  assert(N->getNumOperands() == (StrictFP ? 2 : 1));
  EVT OutVT = N->getValueType(0);
  unsigned ScalarArgNum = StrictFP ? 1 : 0;
  SDValue ScalarArg = N->getOperand(ScalarArgNum);
  EVT InVT = ScalarArg.getValueType();
  SDLoc dl(N);

  auto TooWideInt = [](EVT VT) {
    assert(VT.isInteger());
    return VT.getScalarSizeInBits() > 32;
  };

  // fp16 to integer base case
  if ((InVT == MVT::f16) && TooWideInt(OutVT)) {
    assert(OutVT.isScalarInteger());
    SDValue F16Toi32;
    if (StrictFP) {
      SDValue Chain = N->getOperand(0);
      F16Toi32 =
          DAG.getNode(Opc, dl, {MVT::i32, MVT::Other}, {Chain, ScalarArg});
    } else {
      F16Toi32 = DAG.getNode(Opc, dl, MVT::i32, N->ops());
    }
    SDValue FPRes = IsSigned ? DAG.getSExtOrTrunc(F16Toi32, dl, OutVT)
                             : DAG.getZExtOrTrunc(F16Toi32, dl, OutVT);
    Results.push_back(FPRes);
    if (StrictFP) {
      Results.push_back(F16Toi32.getValue(1));
    }
    return;
  }

  // integer to fp16 base case
  if ((OutVT == MVT::f16) && TooWideInt(InVT)) {
    assert(InVT.isScalarInteger());
    SDValue IxxToi32 = IsSigned ? DAG.getSExtOrTrunc(ScalarArg, dl, MVT::i32)
                                : DAG.getZExtOrTrunc(ScalarArg, dl, MVT::i32);
    if (StrictFP) {
      SDValue Chain = N->getOperand(0);
      SDValue Res =
          DAG.getNode(Opc, dl, {OutVT, MVT::Other}, {Chain, IxxToi32});
      Results.push_back(Res);
      Results.push_back(Res.getValue(1));
    } else {
      Results.push_back(DAG.getNode(Opc, dl, OutVT, IxxToi32));
    }
    return;
  }

  // recurse on vector types, wrapping the elements in Opc
  auto IsVecF16 = [](EVT Ty) {
    return Ty.isVector() && Ty.getVectorElementType() == MVT::f16;
  };
  auto IsVecWiderI32 = [=](EVT Ty) {
    return Ty.isInteger() && Ty.isVector() && TooWideInt(Ty);
  };
  if ((IsVecF16(InVT) || IsVecF16(OutVT)) &&
      (IsVecWiderI32(InVT) || IsVecWiderI32(OutVT))) {
    assert(InVT.getVectorNumElements() == OutVT.getVectorNumElements());
    SmallVector<SDValue, 4> Elements;
    DAG.ExtractVectorElements(N->getOperand(ScalarArgNum), Elements);

    SmallVector<SDValue, 4> Chains;
    for (auto &i : Elements) {
      SDValue SC;
      if (StrictFP) {
        SDValue Chain = N->getOperand(0);
        SC = DAG.getNode(Opc, dl, {OutVT.getVectorElementType(), MVT::Other},
                         {Chain, i});
      } else {
        SC = DAG.getNode(Opc, dl, OutVT.getVectorElementType(), i);
      }
      SmallVector<SDValue, 2> ElementRes;
      lowerFP16IntConversion(SC.getNode(), ElementRes, DAG);
      if (!ElementRes.empty()) {
        i = ElementRes[0];
        if (StrictFP) {
          Chains.push_back(ElementRes[1]);
        }
        assert(i);
      }
    }

    // At least one of the original elements was lowered to something else.
    if (!Chains.empty()) {
      Results.push_back(DAG.getBuildVector(OutVT, dl, Elements));
      if (StrictFP) {
        Results.push_back(
            DAG.getNode(ISD::TokenFactor, dl, MVT::Other, Chains));
      }
    }
  }
}

void ColossusTargetLowering::LowerFP16ToInt(SDNode *N,
                                            SmallVectorImpl<SDValue> &Results,
                                            SelectionDAG &DAG) const {
  assert(N->getOpcode() == ISD::FP_TO_UINT ||
         N->getOpcode() == ISD::FP_TO_SINT ||
         N->getOpcode() == ISD::STRICT_FP_TO_UINT ||
         N->getOpcode() == ISD::STRICT_FP_TO_SINT);
  lowerFP16IntConversion(N, Results, DAG);
}

void ColossusTargetLowering::LowerIntToFP16(SDNode *N,
                                            SmallVectorImpl<SDValue> &Results,
                                            SelectionDAG &DAG) const {
  assert(N->getOpcode() == ISD::UINT_TO_FP ||
         N->getOpcode() == ISD::SINT_TO_FP ||
         N->getOpcode() == ISD::STRICT_UINT_TO_FP ||
         N->getOpcode() == ISD::STRICT_SINT_TO_FP);
  lowerFP16IntConversion(N, Results, DAG);
}

SDValue ColossusTargetLowering::LowerBlockAddress(SDValue Op,
                                                  SelectionDAG &DAG) const {
  const BlockAddressSDNode *BN = cast<BlockAddressSDNode>(Op.getNode());
  const BlockAddress *Addr = BN->getBlockAddress();
  int64_t Offset = BN->getOffset();
  EVT VT = Op.getValueType();
  SDValue BlockAddr = DAG.getTargetBlockAddress(Addr, MVT::i32, Offset);
  return DAG.getNode(ColossusISD::WRAPPER, Op, VT, BlockAddr);
}

SDValue ColossusTargetLowering::
LowerConstantPool(SDValue Op, SelectionDAG& DAG) const {
  const ConstantPoolSDNode *CP = cast<ConstantPoolSDNode>(Op.getNode());
  EVT VT = Op.getValueType();
  SDValue ConstPool;
  if (CP->isMachineConstantPoolEntry()) {
    ConstPool = DAG.getTargetConstantPool(CP->getMachineCPVal(), VT,
                                          CP->getAlign(),
                                          CP->getOffset());
  } else {
    ConstPool = DAG.getTargetConstantPool(CP->getConstVal(), VT,
                                          CP->getAlign(),
                                          CP->getOffset());
  }
  return DAG.getNode(ColossusISD::WRAPPER, Op, VT, ConstPool);
}

SDValue ColossusTargetLowering::
LowerGlobalAddress(SDValue Op, SelectionDAG& DAG) const {
  const GlobalAddressSDNode *GN = cast<GlobalAddressSDNode>(Op.getNode());
  const GlobalValue *Addr = GN->getGlobal();
  SDLoc dl(GN);
  int64_t Offset = GN->getOffset();
  EVT VT = Op.getValueType();
  SDValue GlobalAddr = DAG.getTargetGlobalAddress(Addr, dl, MVT::i32, Offset);
  return DAG.getNode(ColossusISD::WRAPPER, Op, VT, GlobalAddr);
}

SDValue ColossusTargetLowering::
LowerJumpTable(SDValue Op, SelectionDAG& DAG) const {
  const JumpTableSDNode *JT = cast<JumpTableSDNode>(Op.getNode());
  EVT VT = Op.getValueType();
  SDValue TJT = DAG.getTargetJumpTable(JT->getIndex(), MVT::i32);
  return DAG.getNode(ColossusISD::WRAPPER, Op, VT, TJT);
}

SDValue ColossusTargetLowering::
LowerFLT_ROUNDS_(SDValue Op, SelectionDAG &DAG) const {
  // The rounding mode is stored in bits [11:9] of the worker $FP_CTL:RND bits,
  // but the only rounding mode supported on Tommy is round-to-nearest,
  // ties-to-even, so this function always returns 1:
  //  -1 - Undefined
  //   0 - Round to 0
  //   1 - Round to nearest
  //   2 - Round to +inf
  //   3 - Round to -inf
  SDLoc dl(Op);
  SDValue Chain = Op.getOperand(0);
  SDValue Value = DAG.getConstant(1, dl, MVT::i32);
  return DAG.getMergeValues({Value, Chain}, dl);
}

SDValue ColossusTargetLowering::
LowerFRAME_TO_ARGS_OFFSET(SDValue Op, SelectionDAG &DAG) const {
  return DAG.getNode(ColossusISD::FRAME_TO_ARGS_OFFSET, SDLoc(Op), MVT::i32);
}

SDValue
ColossusTargetLowering::LowerINTRINSIC_W_CHAIN(SDValue Op,
                                               SelectionDAG &DAG) const {
  SDValue chain = Op.getOperand(0);
  SDLoc dl(Op);
  unsigned IntNo = cast<ConstantSDNode>(Op.getOperand(1))->getZExtValue();
  LLVM_DEBUG(dbgs() << "Lower intrinsic W chain: "; Op.dump(););

  auto check_implemented_type = [](EVT VT) {
    static EVT tab[] = {
        MVT::v2f32, MVT::v4f16, MVT::f32, MVT::v2f16, MVT::f16,
        MVT::v2i32, MVT::v4i16, MVT::i32, MVT::v2i16, MVT::i16, MVT::i8,
    };
    if (std::find(std::begin(tab), std::end(tab), VT) == std::end(tab)) {
      report_fatal_error("colossus ld/st step unimplemented for type");
    }
  };

  auto check_and_scale_stride = [&](SDValue stride, EVT VT) {
    // The intrinsic specifies the stride in number of elements but the store
    // node specifies it in number of bytes.

    if (stride.getValueType() != MVT::i32) {
      LLVM_DEBUG(dbgs() << "incr: "; stride.dump(););
      report_fatal_error("colossus ld/st step requires i32 increment");
    }
    unsigned scale = (VT.getSizeInBits() / 8);

    return DAG.getNode(ISD::MUL, dl, MVT::i32, stride, DAG.getConstant(scale, dl, MVT::i32));
  };

  auto isValidCloopMetadata = [&](SDValue x) {
    auto metadata = dyn_cast<ConstantSDNode>(x);
    return metadata && (metadata->getZExtValue() <= UINT16_MAX);
  };

  auto lowerColossusOp = [&](unsigned Opcode) -> SDValue {
    auto const VT = Op.getValueType();
    assert(Op.getNumOperands() == 3);
    auto const arg0 = Op.getOperand(2);
    assert(arg0.getValueType() == VT);
    auto const chain = Op.getOperand(0);
    assert(chain.getValueType() == MVT::Other);
    auto colossusOp =
        DAG.getNode(Opcode, SDLoc{Op}, {VT, MVT::Other}, {chain, arg0});
    return recursiveLowerFPOperation(colossusOp, DAG);
  };

  switch (IntNo) {
  case Intrinsic::colossus_constrained_rsqrt: {
    return lowerColossusOp(ColossusISD::STRICT_FRSQRT);
  }
  case Intrinsic::colossus_ststep: {
    assert(Op.getNumOperands() == 5);
    assert(Op.getResNo() == 0);
    SDValue value = Op.getOperand(2);
    SDValue addr = Op.getOperand(3);
    SDValue stride = Op.getOperand(4);
    EVT stTy = value.getValueType();
    check_implemented_type(stTy);
    if (stTy.getSizeInBits() < 32) {
      report_fatal_error("colossus subword postinc stores unimplemented");
    }
    assert(addr.getValueType() == MVT::i32);
    assert(stride.getValueType() == MVT::i32);

    SDValue store = DAG.getStore(chain, dl, value, addr, MachinePointerInfo());
    SDValue scaled_stride = check_and_scale_stride(stride, stTy);
    return DAG.getIndexedStore(store, dl, addr, scaled_stride, ISD::POST_INC);
  }
  case Intrinsic::colossus_ldstep:
   {
    assert(Op.getNumOperands() == 4);
    SDValue addr = Op.getOperand(2);
    SDValue stride = Op.getOperand(3);
    assert(addr.getValueType() == MVT::i32);
    assert(stride.getValueType() == MVT::i32);
    EVT ldTy = Op.getNode()->getValueType(0);
    check_implemented_type(ldTy);
    assert(Op.getNode()->getValueType(1) == MVT::i32);
    assert(Op.getNode()->getValueType(2) == MVT::Other);

    auto getLoadType = [](EVT ldTy) -> EVT {
      if (ldTy == MVT::i16 || ldTy == MVT::i8) {
        return MVT::i32;
      }
      return ldTy;
    };

    auto getTypeLegalLoad = [&]() {
      EVT iTy = getLoadType(ldTy);
      assert(ldTy.getSizeInBits() <= iTy.getSizeInBits());
      ISD::LoadExtType ExtType =
          (iTy == ldTy) ? ISD::NON_EXTLOAD : ISD::EXTLOAD;
      return DAG.getExtLoad(ExtType, dl, iTy, chain, addr, MachinePointerInfo(),
                            ldTy);
    };

    SDValue scaled_stride = check_and_scale_stride(stride, ldTy);
    SDValue indexedLoad = DAG.getIndexedLoad(getTypeLegalLoad(), dl, addr,
                                             scaled_stride, ISD::POST_INC);

    assert(Op.getNode()->getNumValues() ==
           indexedLoad.getNode()->getNumValues());

    if (Op.getResNo() == 0) {
      EVT iTy = getLoadType(ldTy);
      return (iTy == ldTy) ? indexedLoad
                           : DAG.getAnyExtOrTrunc(indexedLoad, dl, ldTy);
    }
    return SDValue(indexedLoad.getNode(), Op.getResNo());
  }
  case Intrinsic::colossus_cloop_begin: {
    assert(Op->getNumOperands() == 4);
    auto onFailure = [&]() {
      // Fall back is to delete the intrinsic in situ
      LLVM_DEBUG(dbgs() << "Replacing cloop begin intrinsic with fallback: ";
            Op.dump(););
      assert(Op.getOpcode() == ISD::INTRINSIC_W_CHAIN);
      DAG.ReplaceAllUsesOfValueWith(Op, Op.getOperand(2));
      DAG.ReplaceAllUsesOfValueWith(SDValue(Op.getNode(), 1), Op.getOperand(0));
      return SDValue();
    };

    // i32 (*colossus.cloop.begin)(i32, i32)
    // This is lowered into two ISD nodes. One is a terminator, the other
    // represents the potential need to keep an induction variable around.
    // Should be able to write a more robust version of this using DAG.getRoot
    // The second argument is metadata, passed along to the back end
    // The induction variable node is a like for like replacement
    LLVM_DEBUG(dbgs() << "Lowering colossus.cloop.begin: "; Op.dump(); DAG.dump(););

    if (!Colossus::CountedLoop::EnableISel) {
      return onFailure();
    }
    // First replace the intrinsic call with a node that represents the
    // induction variable, then insert a terminator as near to the
    // root of the DAG as possible
    SDValue root = DAG.getRoot();
    if (root->getOpcode() == ISD::BR) {
      SDValue brOp = root->getOperand(0);
      if (brOp.getOpcode() == ISD::BRCOND) {
        // hardware loop header should only be inserted in an unconditional BB
        return onFailure();
      }
    } else if (root->getOpcode() == ISD::TokenFactor) {
      // TokenFactor is OK
    } else {
      return onFailure();
    }

    if (!isValidCloopMetadata(Op.getOperand(3))) {
      return onFailure();
    }

    // Replace the intrinsic with an ISD node. This will update the CopyToReg
    // that copies the induction variable out of the basic block
    SDValue originalChain = Op.getOperand(0);
    assert(originalChain.getValueType() == MVT::Other);

    SDVTList VTs = DAG.getVTList(MVT::i32, MVT::Other);
    SDValue beginValue =
        DAG.getNode(ColossusISD::CLOOP_BEGIN_VALUE, dl, VTs, originalChain,
                    Op.getOperand(2), Op.getOperand(3));

    if (root.getOpcode() == ISD::TokenFactor) {
      SDValue begin_terminator =
          DAG.getNode(ColossusISD::CLOOP_BEGIN_TERMINATOR, dl, MVT::Other, root,
                      beginValue, Op.getOperand(3));
      DAG.setRoot(begin_terminator);
    } else {
      assert(root.getOpcode() == ISD::BR);
      SDValue begin_terminator =
          DAG.getNode(ColossusISD::CLOOP_BEGIN_TERMINATOR, dl, MVT::Other,
                      root.getOperand(0), beginValue, Op.getOperand(3));
      DAG.ReplaceAllUsesWith(root,
                             DAG.getNode(ISD::BR, dl, MVT::Other,
                                         begin_terminator, root.getOperand(1)));
    }
    return beginValue;
  }
  case Intrinsic::colossus_cloop_end: {
    // Expecting an IR sequence:
    // %cloop.end = call i32 @llvm.colossus.cloop.end(i32 %cloop.phi, i32 %meta)
    // %cloop.end.iv = extractvalue {i32, i32} %cloop.end, 0
    // %cloop.end.cc = extractvalue {i32, i32} %cloop.end, 1
    // %cloop.end.cc.trunc = trunc i32 %cloop.end to i1
    // br i1 %cloop.end.cc.trunc, label %t, label %f
    assert(Op->getNumOperands() == 4);
    auto onFailure = [&]() {
      assert(Op.getOpcode() == ISD::INTRINSIC_W_CHAIN);
      LLVM_DEBUG(dbgs() << "Replacing cloop end intrinsic with fallback: ";
            Op.dump(););

      SDValue decr = DAG.getNode(ISD::SUB, dl, MVT::i32, Op.getOperand(2),
                                 DAG.getConstant(1, dl, MVT::i32));

      // Replace the uses of the induction variable with the decrement
      DAG.ReplaceAllUsesOfValueWith(SDValue(Op.getNode(), 0), decr);

      // Replace the uses of condition with a new setcc
      SDValue nz = DAG.getSetCC(dl, MVT::i32, decr,
                                DAG.getConstant(0, dl, MVT::i32), ISD::SETNE);
      DAG.ReplaceAllUsesOfValueWith(SDValue(Op.getNode(), 1), nz);

      // Remove the intrinsic from its chain
      DAG.ReplaceAllUsesOfValueWith(SDValue(Op.getNode(), 2), Op.getOperand(0));
      return SDValue();
    };

    auto isCountedLoopEnd = [&](SDValue x) {
      if (x.getOpcode() == ISD::INTRINSIC_W_CHAIN) {
        unsigned IntNo = cast<ConstantSDNode>(x.getOperand(1))->getZExtValue();
        return IntNo == Intrinsic::colossus_cloop_end;
      }
      return false;
    };

    LLVM_DEBUG(dbgs() << "Lowering colossus.cloop.end: "; Op.dump(); DAG.dump(););

    if (!Colossus::CountedLoop::EnableISel) {
      return onFailure();
    }

    // Require this instruction to be in a conditional block. Find the brcond.
    SDValue brcond = DAG.getRoot();
    if (brcond.getOpcode() == ISD::BR) {
      brcond = brcond.getOperand(0);
    }
    if (brcond.getOpcode() != ISD::BRCOND) {
      return onFailure();
    }

    if (!isValidCloopMetadata(Op.getOperand(3))) {
      return onFailure();
    }

    // The brcond condition is likely to be an and with 1 from legalisation.
    // If so we want to reach through it.
    SDValue brcondValue = brcond.getOperand(1);
    if (brcondValue.getOpcode() == ISD::AND) {
      if (brcondValue.getOperand(1) == DAG.getConstant(1, dl, MVT::i32)) {
        brcondValue = brcondValue.getOperand(0);
      }
    }

    if (!isCountedLoopEnd(brcondValue)) {
      return onFailure();
    }

    // Established that we have a conditional branch on the return value
    // of the counted loop end intrinsic. This is the desired pattern.

    // The intrinsic returns i32 (indvar), i32 (cc), ch
    // Replace all uses of this by a node that represents the decrement of
    // the loop counter.
    SDVTList VTs = DAG.getVTList(MVT::i32, MVT::Other);
    SDNode *endValue =
        DAG.getNode(ColossusISD::CLOOP_END_VALUE, dl, VTs, Op.getOperand(0),
                    Op.getOperand(2), Op.getOperand(3))
            .getNode();

    // Replace indvar and cc with the integer returned by CLOOP_END_VALUE
    for (unsigned i = 0; i < 2; i++) {
      DAG.ReplaceAllUsesOfValueWith(SDValue(Op.getNode(), i),
                                    SDValue(endValue, 0));
    }

    // Replace chain
    DAG.ReplaceAllUsesOfValueWith(SDValue(Op.getNode(), 2),
                                  SDValue(endValue, 1));

    // Replace the conditional branch with a specialised version that also
    // takes the integer returned by CLOOP_END_VALUE
    SDValue endBranch =
        DAG.getNode(ColossusISD::CLOOP_END_BRANCH, SDLoc(brcond), MVT::Other,
                    brcond.getOperand(0), brcond.getOperand(2),
                    SDValue(endValue, 0), Op.getOperand(3));

    // Replace the brcond with a specialised conditional branch
    DAG.ReplaceAllUsesWith(brcond, endBranch);
    return SDValue();
  }
  case Intrinsic::colossus_cloop_guard: {
    // Expecting the following IR sequence:
    // %cloop.guard = call i32 @llvm.colossus.cloop.guard(i32 %x, i32 0)
    // %cloop.guard.trunc = trunc i32 %cloop.guard to i1
    // br i1 %cloop.guard.trunc, label %for.body.preheader, label
    // %for.cond.cleanup

    assert(Op->getNumOperands() == 4);

    auto onFailure = [&]() {
      assert(Op.getOpcode() == ISD::INTRINSIC_W_CHAIN);
      LLVM_DEBUG(dbgs() << "Replacing cloop guard intrinsic with fallback: ";
                 Op.dump(););

      // Replace the uses of condition with a new setcc
      SDValue nz = DAG.getSetCC(dl, MVT::i32, Op.getOperand(2),
                                DAG.getConstant(0, dl, MVT::i32), ISD::SETNE);

      // Replace the uses of the intrinsic return val with the setcc return val
      DAG.ReplaceAllUsesOfValueWith(SDValue(Op.getNode(), 0), nz);

      // Remove the intrinsic from its chain
      DAG.ReplaceAllUsesOfValueWith(SDValue(Op.getNode(), 1), Op.getOperand(0));
      return SDValue();
    };

    auto isCountedLoopGuard = [&](SDValue x) {
      if (x.getOpcode() == ISD::INTRINSIC_W_CHAIN) {
        unsigned IntNo = cast<ConstantSDNode>(x.getOperand(1))->getZExtValue();
        return IntNo == Intrinsic::colossus_cloop_guard;
      }
      return false;
    };

    // DAG may look like this:
    // t0: ch = EntryToken
    //   t2: i32,ch = CopyFromReg t0, Register:i32 %8
    // t7: i32,ch = llvm.colossus.cloop.guard t0, TargetConstant:i32<2424>, t2,
    // Constant:i32<0>
    //       t11: ch = CopyToReg t0, Register:i32 %10, Constant:i32<42>
    //     t15: ch = TokenFactor t11, t7:1
    //       t24: i32 = and *t7*, Constant:i32<1>
    //     t28: i32 = setcc *t24*, Constant:i32<0>, seteq:ch
    //   t21: ch = brcond t15, *t28*, BasicBlock:ch<.loopexit 0x55ea6d2e9658>
    // t18: ch = br *t21*, BasicBlock:ch<.preheader 0x55ea6d2e9578>
    //  ^ DAG Root
    // Start at DAG root and reach through to cloop.guard
    // Then replace the brcond, setcc, and, cloop.guard with pseudo instruction

    LLVM_DEBUG(dbgs() << "Lowering colossus.cloop.guard: "; Op.dump();
               DAG.dump(););

    SDValue brcond = DAG.getRoot();
    if (brcond.getOpcode() == ISD::BR)
      brcond = brcond.getOperand(0);

    if (brcond.getOpcode() != ISD::BRCOND) {
      return onFailure();
    }

    SDValue setccNode = brcond.getOperand(1);

    if ((setccNode.getOpcode() != ISD::SETCC) ||
        (setccNode.getOperand(1) != DAG.getConstant(0, dl, MVT::i32)) ||
        (setccNode.getOperand(2) != DAG.getCondCode(ISD::SETEQ))) {
      return onFailure();
    }
    SDValue andNode = setccNode.getOperand(0);
    if ((andNode.getOpcode() != ISD::AND) ||
        (andNode.getOperand(1) != DAG.getConstant(1, dl, MVT::i32))) {
      return onFailure();
    }
    SDValue cloopGuard = andNode.getOperand(0);

    if (!isCountedLoopGuard(cloopGuard)) {
      return onFailure();
    }

    // Replace conditional branch with Cloop Guard Branch Psuedo.
    SDValue endBranchVal = DAG.getNode(
        ColossusISD::CLOOP_GUARD_BRANCH, SDLoc(brcond), MVT::Other,
        brcond.getOperand(0) /* node before brcond */,
        brcond.getOperand(2) /* loopExit BB */,
        Op.getOperand(2) /* loop count */, Op.getOperand(3) /* metadata */);

    // Replace chain
    DAG.ReplaceAllUsesWith(brcond, endBranchVal);
    // Remove the intrinsic from its chain
    DAG.ReplaceAllUsesOfValueWith(SDValue(Op.getNode(), 1), Op.getOperand(0));

    return SDValue();
  }
  case Intrinsic::colossus_urand64: {
    assert(Op.getNumOperands() == 2);
    LLVM_DEBUG(dbgs() << "Lowering urand64 intrinsic: ";
                          Op.dump(); DAG.dump(););
    SDValue coissueImm = DAG.getTargetConstant(0u, dl, MVT::i32);
    SDValue urand64 = SDValue(
      DAG.getMachineNode(Colossus::URAND64, dl, MVT::v2f32, coissueImm), 0);

    // Extract elements of the urand64 result to copy to MRF registers
    SDValue index0 = DAG.getNode(ISD::EXTRACT_VECTOR_ELT, dl, MVT::i32, urand64,
                                 DAG.getConstant(0, dl, MVT::i32));
    SDValue index1 = DAG.getNode(ISD::EXTRACT_VECTOR_ELT, dl, MVT::i32, urand64,
                                 DAG.getConstant(1, dl, MVT::i32));

    auto Opcode = ColossusATOM(Subtarget);

    SDValue atom0 = SDValue(
      DAG.getMachineNode(Opcode, dl, MVT::i32, index0, coissueImm), 0);
    SDValue atom1 = SDValue(
      DAG.getMachineNode(Opcode, dl, MVT::i32, index1, coissueImm), 0);
    return DAG.getNode(ISD::BUILD_PAIR, dl, MVT::i64, atom0, atom1);
  }
  case Intrinsic::colossus_get:
  case Intrinsic::colossus_uget:
    assert(dyn_cast<ConstantSDNode>(Op.getOperand(2u)) &&
           Op.getConstantOperandVal(2u) < 256 &&
           "CSR number must be a constant unsigned integer < 256.");
    LLVM_FALLTHROUGH;
  default:
    // Use default lowering.
    return SDValue();
  }
}

SDValue ColossusTargetLowering::
LowerINTRINSIC_WO_CHAIN(SDValue Op, SelectionDAG &DAG) const {
  unsigned IntNo = cast<ConstantSDNode>(Op.getOperand(0))->getZExtValue();

  auto lowerColossusOp = [&](unsigned Opcode)-> SDValue {
    auto const VT = Op.getValueType();
    assert(Op.getNumOperands() == 2);
    auto const arg0 = Op.getOperand(1);
    assert(arg0.getValueType() == VT);
    auto colossusOp = DAG.getNode(Opcode, SDLoc{Op}, VT, arg0);
    return recursiveLowerFPOperation(colossusOp, DAG);
  };

  switch (IntNo) {
    case Intrinsic::colossus_tanh: {
      return lowerColossusOp(ColossusISD::FTANH);
    }
    case Intrinsic::colossus_rsqrt: {
      return lowerColossusOp(ColossusISD::FRSQRT);
    }
    case Intrinsic::colossus_sigmoid: {
      return lowerColossusOp(ColossusISD::FSIGMOID);
    }
    default: {
      // Use default lowering.
      return SDValue();
    }
  }
}

SDValue ColossusTargetLowering::
LowerINTRINSIC_VOID(SDValue Op, SelectionDAG &DAG) const {
  unsigned IntNo = cast<ConstantSDNode>(Op.getOperand(1))->getZExtValue();

  switch(IntNo) {
    case Intrinsic::colossus_put:
    case Intrinsic::colossus_uput: {
      assert(dyn_cast<ConstantSDNode>(Op.getOperand(3u)) &&
             Op.getConstantOperandVal(3u) < 256 &&
             "CSR number must be a constant unsigned integer < 256.");
      break;
    }
    case Intrinsic::colossus_f32v2aop: {
      assert(dyn_cast<ConstantSDNode>(Op.getOperand(4u)) &&
             Op.getConstantOperandVal(4u) < 256 &&
             "Last argument must be a constant unsigned integer < 256.");
      break;
    }
    case Intrinsic::colossus_f16v2gina:
    case Intrinsic::colossus_f32v2gina: {
      assert(dyn_cast<ConstantSDNode>(Op.getOperand(3u)) &&
             Op.getConstantOperandVal(3u) < 4096 &&
             "Last argument must be a constant unsigned integer < 4096.");
      break; 
    }
  }
  // Use default lowering.
  return SDValue();
}
SDValue ColossusTargetLowering::
LowerRETURNADDR(SDValue Op, SelectionDAG &DAG) const {
  // Only supports depth of 0 (i.e. current function's return address).
  if (cast<ConstantSDNode>(Op.getOperand(0))->getZExtValue() != 0) {
    return SDValue();
  }

  MachineFunction &MF = DAG.getMachineFunction();
  MachineFrameInfo &MFI = MF.getFrameInfo();
  MFI.setReturnAddressIsTaken(true);

  SDLoc dl(Op);

  // The LR (i.e. $m10) register contains the return address.
  unsigned Reg = MF.addLiveIn(Colossus::LR, getRegClassFor(MVT::i32));
  return DAG.getCopyFromReg(DAG.getEntryNode(), dl, Reg, Op.getValueType());
}

SDValue ColossusTargetLowering::
LowerSIGN_EXTEND_INREG(SDValue Op, SelectionDAG &DAG) const {
  // Lower SIGN_EXTEND_INREG of i32 to a shift left, arithmetic shift right.

  // Let legalize expand this if it isn't a legal type yet.
  EVT VT = Op.getValueType();
  if (!DAG.getTargetLoweringInfo().isTypeLegal(VT))
    return SDValue();
  assert(VT == MVT::i32 || "Sign extend with shifts only supported on i32");

  SDLoc dl(Op);
  SDValue toExtend = Op.getOperand(0);
  EVT InnerType = cast<VTSDNode>(Op.getOperand(1))->getVT();
  unsigned sextFromWidth = InnerType.getScalarSizeInBits();

  unsigned elementWidth = 32;
  if (sextFromWidth >= elementWidth) {
    report_fatal_error("Invalid SIGN_EXTEND node: Cannot shift >= type width");
  }

  SDValue shiftBy = DAG.getConstant(elementWidth - sextFromWidth, dl, MVT::i32);
  return DAG.getNode(ISD::SRA, dl, VT,
                     DAG.getNode(ISD::SHL, dl, VT, toExtend, shiftBy), shiftBy);
}

SDValue ColossusTargetLowering::
LowerUDIV(SDValue Op, SelectionDAG &DAG) const {
  // Lower udiv i32 LHS, RHS to __udivsi3(LSH, RHS).
  SDLoc dl(Op);
  SDValue LHS = Op.getOperand(0);
  SDValue RHS = Op.getOperand(1);

  assert(LHS.getValueType() == MVT::i32 &&
         RHS.getValueType() == MVT::i32 &&
         "Expected MVT::i32 operands for udiv");

  Type *IntTy = Type::getInt32Ty(*DAG.getContext());

  TargetLowering::ArgListTy Args;
  TargetLowering::ArgListEntry Entry;
  Entry.Ty = IntTy;
  Entry.Node = LHS;
  Args.push_back(Entry);
  Entry.Node = RHS;
  Args.push_back(Entry);

  SDValue ExtSym = DAG.getExternalSymbol("__udivsi3",
                                         getPointerTy(DAG.getDataLayout()));
  SDValue Chain = DAG.getEntryNode();

  TargetLowering::CallLoweringInfo CLI(DAG);
  const TargetLowering &TLI = *DAG.getSubtarget().getTargetLowering();
  CLI.setDebugLoc(dl).setChain(Chain)
      .setCallee(TLI.getLibcallCallingConv(RTLIB::UDIV_I32),
                 IntTy, ExtSym, std::move(Args));
  std::pair<SDValue, SDValue> CallResult = LowerCallTo(CLI);
  return CallResult.first;
}

SDValue ColossusTargetLowering::
LowerUREM(SDValue Op, SelectionDAG &DAG) const {
  // Lower urem i32 LHS, RHS to __umodsi3(LSH, RHS).
  SDLoc dl(Op);
  SDValue LHS = Op.getOperand(0);
  SDValue RHS = Op.getOperand(1);

  assert(LHS.getValueType() == MVT::i32 &&
         RHS.getValueType() == MVT::i32 &&
         "Expected MVT::i32 operands for urem");

  Type *IntTy = Type::getInt32Ty(*DAG.getContext());

  TargetLowering::ArgListTy Args;
  TargetLowering::ArgListEntry Entry;
  Entry.Ty = IntTy;
  Entry.Node = LHS;
  Args.push_back(Entry);
  Entry.Node = RHS;
  Args.push_back(Entry);

  SDValue ExtSym = DAG.getExternalSymbol("__umodsi3",
                                         getPointerTy(DAG.getDataLayout()));
  SDValue Chain = DAG.getEntryNode();

  TargetLowering::CallLoweringInfo CLI(DAG);
  const TargetLowering &TLI = *DAG.getSubtarget().getTargetLowering();
  CLI.setDebugLoc(dl).setChain(Chain)
      .setCallee(TLI.getLibcallCallingConv(RTLIB::UREM_I32),
                 IntTy, ExtSym, std::move(Args));
  std::pair<SDValue, SDValue> CallResult = LowerCallTo(CLI);
  return CallResult.first;
}

static SDValue lowerI32MULHX(SDValue Op, SelectionDAG &DAG) {
  unsigned Opc = Op.getOpcode();
  SDLoc dl(Op);

  assert(Opc == ISD::MULHU || Opc == ISD::MULHS);
  assert(Op.getValueType() == MVT::i32 && "Only implemented for i32");

  SDValue sixteen = DAG.getConstant(16, dl, MVT::i32);
  auto add = [&](SDValue x, SDValue y) {
    return DAG.getNode(ISD::ADD, dl, MVT::i32, x, y);
  };
  auto mul = [&](SDValue x, SDValue y) {
    return DAG.getNode(ISD::MUL, dl, MVT::i32, x, y);
  };
  auto shr16 = [&](SDValue x) {
    unsigned shr = (Opc == ISD::MULHS) ? ISD::SRA : ISD::SRL;
    return DAG.getNode(shr, dl, MVT::i32, x, sixteen);
  };
  auto andffff = [&](SDValue x) {
    return DAG.getNode(ISD::AND, dl, MVT::i32, x,
                       DAG.getConstant(0xFFFF, dl, MVT::i32));
  };

  // literal transcription from hackers delight (originally knuth 4.3.1, M)
  // http://www.hackersdelight.org/hdcodetxt/muldws.c.txt
  // http://www.hackersdelight.org/hdcodetxt/muldwu.c.txt
  SDValue u = Op.getOperand(0);
  SDValue v = Op.getOperand(1);

  SDValue u0 = shr16(u);
  SDValue v0 = shr16(v);

  SDValue u1 = andffff(u);
  SDValue v1 = andffff(v);

  SDValue t = mul(u1, v1);

  SDValue k = DAG.getNode(ISD::SRL, dl, MVT::i32, t, sixteen);

  t = add(mul(u0, v1), k);

  SDValue w2 = andffff(t);
  SDValue w1 = shr16(t);

  t = add(mul(u1, v0), w2);
  k = shr16(t);

  return add(add(mul(u0, v0), w1), k);
}

SDValue ColossusTargetLowering::LowerMULHX(SDValue Op,
                                           SelectionDAG &DAG) const {
  /// MULHU/MULHS - Multiply high - Multiply two integers of type iN,
  /// producing an unsigned/signed value of type i[2*N], then return the top
  /// part.

  EVT VT = Op.getValueType();
  SDLoc dl(Op);
  unsigned Opc = Op.getOpcode();
  assert(Opc == ISD::MULHU || Opc == ISD::MULHS);
  assert(Op.getResNo() == 0);
  assert(VT == MVT::i32 || VT == MVT::v2i32);

  LLVM_DEBUG(dbgs() << "LowerMULHX: "; Op.dump(););

  if (VT == MVT::i32) {
    return lowerI32MULHX(Op, DAG);
  }

  SDValue lhs = Op.getOperand(0);
  SDValue rhs = Op.getOperand(1);
  SmallVector<SDValue, 2> vec;

  if (VT == MVT::v2i32) {
    auto lhsSplit = splitValue(lhs, DAG);
    auto rhsSplit = splitValue(rhs, DAG);
    auto recur = [&](SDValue l, SDValue r) {
      return lowerI32MULHX(DAG.getNode(Opc, dl, MVT::i32, l, r), DAG);
    };

    return concatValues(
        recur(lhsSplit.first, rhsSplit.first),
        recur(lhsSplit.second, rhsSplit.second), DAG);
  }

  llvm_unreachable("Unknown type in LowerMULHX");
}

SDValue ColossusTargetLowering::LowerXMUL_LOHI(SDValue Op,
                                               SelectionDAG &DAG) const {
  // Lower XMUL_LOHI as a merge_values of MUL and MULHX
  // Builtin expand breaks on vectors of nodes that create multiple values
  // This will be invoked twice per ISD node, once for each result value
  EVT VT = Op.getValueType();
  SDLoc dl(Op);
  unsigned Opc = Op.getOpcode();
  unsigned ResNo = Op.getResNo();
  assert(Opc == ISD::UMUL_LOHI || Opc == ISD::SMUL_LOHI);
  assert(ResNo == 0 || ResNo == 1);
  assert(VT == MVT::i32 || VT == MVT::v2i32);

  LLVM_DEBUG(dbgs() << "Invoked LowerXMUL_LOHI: "; Op.dump(););

  SDValue Op0 = Op.getOperand(0);
  SDValue Op1 = Op.getOperand(1);

  unsigned MULHXOpcode = Opc == ISD::UMUL_LOHI ? ISD::MULHU : ISD::MULHS;
  SDValue res[2] = {
      DAG.getNode(ISD::MUL, dl, VT, Op0, Op1),
      LowerMULHX(DAG.getNode(MULHXOpcode, dl, VT, Op0, Op1), DAG),
  };

  SDVTList VTs = DAG.getVTList(VT, VT);
  SDNode *N = DAG.getNode(ISD::MERGE_VALUES, dl, VTs, res[0], res[1]).getNode();
  return SDValue(N, ResNo);
}

SDValue ColossusTargetLowering::
LowerFP_ROUND(SDValue Op, SelectionDAG &DAG) const {
  // Lowers fpround f64 -> f16 via i16
  // Both f64 and i16 are illegal types, so this custom lowering can only
  // be called before type legalisation. Otherwise f64 has been converted to
  // two i32s and the returned i16 will trigger asserts downstream.
  auto Opc = Op.getOpcode();
  assert(Opc == ISD::FP_ROUND || Opc == ISD::STRICT_FP_ROUND);
  bool StrictFP = Opc == ISD::STRICT_FP_ROUND;
  SDValue Y = StrictFP ? Op.getOperand(1) : Op.getOperand(0);
  assert(StrictFP ? Op.getNumOperands() == 3 : Op.getNumOperands() == 2);
  assert(Op.getValueType() == MVT::f16);
  assert(Y.getValueType() == MVT::f64);
  Type *ArgTy = Type::getDoubleTy(*DAG.getContext());
  Type *ResTy = Type::getInt16Ty(*DAG.getContext());

  TargetLowering::ArgListTy Args;
  TargetLowering::ArgListEntry Entry;
  Entry.Ty = ArgTy;
  Entry.Node = Y;
  Args.push_back(Entry);

  const TargetLowering &TLI = DAG.getTargetLoweringInfo();
  assert(isWorkerSubtarget(DAG));
  SDValue ExtSym = DAG.getExternalSymbol("__truncdfhf2",
                                         TLI.getPointerTy(DAG.getDataLayout()));
  SDValue Chain = StrictFP ? Op.getOperand(0) : DAG.getEntryNode();

  TargetLowering::CallLoweringInfo CLI(DAG);
  SDLoc dl(Op);
  CLI.setDebugLoc(dl).setChain(Chain).setCallee(
      TLI.getLibcallCallingConv(RTLIB::FPROUND_F64_F16), ResTy, ExtSym,
      std::move(Args));
  std::pair<SDValue, SDValue> CallResult = LowerCallTo(CLI);

  SDValue call_result = CallResult.first;
  assert(call_result.getValueType() == MVT::i16);

  // At this stage we have an i16 that needs to be bitcast to a f16
  // This is a problem because i16 is an illegal type and the contract
  // on custom lowering is that it only returns legal types.
  // A 'clean' solution would be to immediately drop to machine instructions
  // A concise solution is to return an ISD node using an illegal i16 and trust
  // that the call site is before type legalisation.

  SDValue Cast = DAG.getBitcast(MVT::f16, call_result);
  if (!StrictFP)
    return Cast;

  Chain = CallResult.second.getValue(1);
  return DAG.getMergeValues({Cast, Chain}, dl);
}

static SDValue LowerSTRICT_FSETCC(SDValue Op, SelectionDAG &DAG) {
  assert(Op.getOpcode() == ISD::STRICT_FSETCC);
  ISD::CondCode CC = cast<CondCodeSDNode>(Op.getOperand(3))->get();
  SDLoc dl(Op);
  SDValue Chain = Op.getOperand(0);
  SDValue LHS = Op.getOperand(1);
  SDValue RHS = Op.getOperand(2);

  auto GetLibcallName = [CC]() {
    switch (CC) {
    default:
      report_fatal_error("Unexpected SETCC condition");

    case ISD::SETO:
      return "__strict_f32cmp_ord";

    case ISD::SETEQ:
    case ISD::SETOEQ:
      return "__strict_f32cmp_oeq";

    case ISD::SETNE:
    case ISD::SETONE:
      return "__strict_f32cmp_one";

    case ISD::SETGT:
    case ISD::SETOGT:
      return "__strict_f32cmp_ogt";

    case ISD::SETGE:
    case ISD::SETOGE:
      return "__strict_f32cmp_oge";

    case ISD::SETLT:
    case ISD::SETOLT:
      return "__strict_f32cmp_olt";

    case ISD::SETLE:
    case ISD::SETOLE:
      return "__strict_f32cmp_ole";

    case ISD::SETUO:
      return "__strict_f32cmp_uno";
    case ISD::SETUEQ:
      return "__strict_f32cmp_ueq";
    case ISD::SETUNE:
      return "__strict_f32cmp_une";
    case ISD::SETUGT:
      return "__strict_f32cmp_ugt";
    case ISD::SETUGE:
      return "__strict_f32cmp_uge";
    case ISD::SETULT:
      return "__strict_f32cmp_ult";
    case ISD::SETULE:
      return "__strict_f32cmp_ule";
    }
  };

  const TargetLowering &TLI = DAG.getTargetLoweringInfo();
  MVT PtrTy = TLI.getPointerTy(DAG.getDataLayout());
  SDValue ExtSym = DAG.getExternalSymbol(GetLibcallName(), PtrTy);
  TargetLowering::CallLoweringInfo CLI(DAG);

  Type *BoolTy = Type::getInt1Ty(*DAG.getContext());
  Type *FloatTy = Type::getFloatTy(*DAG.getContext());
  TargetLowering::ArgListTy Args;
  TargetLowering::ArgListEntry Entry;
  Entry.Ty = FloatTy;
  Entry.Node = LHS;
  Args.push_back(Entry);
  Entry.Node = RHS;
  Args.push_back(Entry);
  CLI.setDebugLoc(dl).setChain(Chain).setCallee(CallingConv::C, BoolTy, ExtSym,
                                                std::move(Args));
  std::pair<SDValue, SDValue> CallResult = TLI.LowerCallTo(CLI);
  return CallResult.second;
}

static SDValue LowerFloatingPointSETCC(SDValue Op, SelectionDAG &DAG) {
  unsigned Opc = Op.getOpcode();
  if (Opc == ISD::STRICT_FSETCC) {
    return LowerSTRICT_FSETCC(Op, DAG);
  }

  assert(Opc == ISD::SETCC || Opc == ISD::STRICT_FSETCCS);
  SDLoc dl(Op);
  auto const StrictFP = Op->isStrictFPOpcode();
  auto const LHSOpNum = StrictFP ? 1 : 0;
  SDValue Chain = StrictFP ? Op.getOperand(0) : SDValue();
  SDValue LHS = Op.getOperand(LHSOpNum);
  SDValue RHS = Op.getOperand(LHSOpNum + 1);
  ISD::CondCode CC = cast<CondCodeSDNode>(Op.getOperand(LHSOpNum + 2))->get();
  EVT CmpVT = Op.getValueType();
  EVT TmpVT = LHS.getValueType();
  if (!(TmpVT == MVT::f32 || TmpVT == MVT::v2f32 || TmpVT == MVT::v2f16 ||
        TmpVT == MVT::v4f16)) {
    report_fatal_error("Unexpected SETCC EVT");
  }
  assert(CmpVT.isInteger());
  assert(CmpVT.getSizeInBits() == TmpVT.getSizeInBits());

  auto LowerToColossusCmp = [&](ISD::CondCode CC, SDValue LHS, SDValue RHS) {
    SDValue Pred = DAG.getCondCode(CC);
    if (StrictFP)
      return DAG.getNode(ColossusISD::STRICT_FCMPS, dl, {TmpVT, MVT::Other},
                         {Chain, LHS, RHS, Pred});
    return DAG.getNode(ColossusISD::FCMP, dl, TmpVT, LHS, RHS, Pred);
  };

  auto getResult = [&](SDValue Result, SDValue Cmp0, SDValue Cmp1) {
    if (StrictFP) {
      SmallVector<SDValue, 2> Chains = {Cmp0.getValue(1), Cmp1.getValue(1)};
      Chain = DAG.getTokenFactor(dl, Chains);
      return DAG.getMergeValues({Result, Chain}, dl);
    }
    return Result;
  };

  switch (CC) {
  default:
    report_fatal_error("Unexpected SETCC condition");
  case ISD::SETOEQ:
  case ISD::SETOGT:
  case ISD::SETOGE:
  case ISD::SETOLT:
  case ISD::SETOLE:
  case ISD::SETUNE:
  case ISD::SETEQ:
  case ISD::SETNE:
  case ISD::SETGT:
  case ISD::SETGE:
  case ISD::SETLT:
  case ISD::SETLE: {
    SDValue Cmp = LowerToColossusCmp(CC, LHS, RHS);
    SDValue Result = DAG.getBitcast(CmpVT, Cmp);
    if (StrictFP)
      return DAG.getMergeValues({Result, Cmp.getValue(1)}, dl);
    return Result;
  }
  case ISD::SETUGT:
  case ISD::SETUGE:
  case ISD::SETULT:
  case ISD::SETULE: {
    const ISD::CondCode InvCC = getSetCCInverse(CC, TmpVT);
    SDValue Cmp = LowerToColossusCmp(InvCC, LHS, RHS);
    SDValue Not = DAG.getNode(ColossusISD::FNOT, dl, TmpVT, Cmp);
    SDValue Result = DAG.getBitcast(CmpVT, Not);
    if (StrictFP)
      return DAG.getMergeValues({Result, Cmp.getValue(1)}, dl);
    return Result;
  }
  case ISD::SETONE: {
    SDValue CmpLT = LowerToColossusCmp(ISD::SETOLT, LHS, RHS);
    SDValue CmpGT = LowerToColossusCmp(ISD::SETOGT, LHS, RHS);
    SDValue Or = DAG.getNode(ColossusISD::FOR, dl, TmpVT, CmpLT, CmpGT);
    return getResult(DAG.getBitcast(CmpVT, Or), CmpLT, CmpGT);
  }
  case ISD::SETO: {
    SDValue CmpLHS = LowerToColossusCmp(ISD::SETOEQ, LHS, LHS);
    SDValue CmpRHS = LowerToColossusCmp(ISD::SETOEQ, RHS, RHS);
    SDValue And = DAG.getNode(ColossusISD::FAND, dl, TmpVT, CmpLHS, CmpRHS);
    return getResult(DAG.getBitcast(CmpVT, And), CmpLHS, CmpRHS);
  }
  case ISD::SETUEQ: {
    SDValue CmpLT = LowerToColossusCmp(ISD::SETOLT, LHS, RHS);
    SDValue CmpGT = LowerToColossusCmp(ISD::SETOGT, LHS, RHS);
    SDValue Or = DAG.getNode(ColossusISD::FOR, dl, TmpVT, CmpLT, CmpGT);
    SDValue Not = DAG.getNode(ColossusISD::FNOT, dl, TmpVT, Or);
    return getResult(DAG.getBitcast(CmpVT, Not), CmpLT, CmpGT);
  }
  case ISD::SETUO: {
    SDValue CmpLHS = LowerToColossusCmp(ISD::SETUNE, LHS, LHS);
    SDValue CmpRHS = LowerToColossusCmp(ISD::SETUNE, RHS, RHS);
    SDValue Or = DAG.getNode(ColossusISD::FOR, dl, TmpVT, CmpLHS, CmpRHS);
    return getResult(DAG.getBitcast(CmpVT, Or), CmpLHS, CmpRHS);
  }
  }
}

static SDValue LowerIntegerSETCC(SDValue Op, SelectionDAG &DAG) {
  SDLoc dl(Op);
  ISD::CondCode CC = cast<CondCodeSDNode>(Op.getOperand(2))->get();
  SDValue LHS = Op.getOperand(0);
  SDValue RHS = Op.getOperand(1);
  EVT CmpVT = Op.getValueType();
  EVT TmpVT = LHS.getValueType();
  if (!(TmpVT == MVT::v2i32 || TmpVT == MVT::v2i16 || TmpVT == MVT::v4i16)) {
    report_fatal_error("Unexpected SETCC EVT");
  }

  SmallVector<SDValue, 4> LHSElts;
  SmallVector<SDValue, 4> RHSElts;
  const unsigned arity = TmpVT.getVectorNumElements();

  for (unsigned i = 0; i < arity; i++) {
    SDValue idx = DAG.getConstant(i, dl, MVT::i32);
    LHSElts.push_back(
        DAG.getNode(ISD::EXTRACT_VECTOR_ELT, dl, MVT::i32, LHS, idx));
    RHSElts.push_back(
        DAG.getNode(ISD::EXTRACT_VECTOR_ELT, dl, MVT::i32, RHS, idx));
  }

  auto zeroExtendElement = [&](SDValue elt) {
    assert(elt.getValueType() == MVT::i32);
    SDValue mask = DAG.getConstant(65535u, dl, MVT::i32);
    return DAG.getNode(ISD::AND, dl, MVT::i32, elt, mask);
  };

  auto signExtendElement = [&](SDValue elt, unsigned width) {
    assert(width == 16 || width == 31);
    assert(elt.getValueType() == MVT::i32);
    return DAG.getNode(ISD::SIGN_EXTEND_INREG, dl, MVT::i32, elt,
                       DAG.getValueType(width == 16 ? MVT::i16 : MVT::i1));
  };

  switch (CC) {
  default: { report_fatal_error("Unexpected integer SETCC condition"); }
  case ISD::SETEQ:
  case ISD::SETNE:
  case ISD::SETUGT:
  case ISD::SETUGE:
  case ISD::SETULT:
  case ISD::SETULE: {
    if (TmpVT.getScalarSizeInBits() == 16u) {
      for (unsigned i = 0; i < arity; i++) {
        LHSElts[i] = zeroExtendElement(LHSElts[i]);
        RHSElts[i] = zeroExtendElement(RHSElts[i]);
      }
    }
    break;
  }
  case ISD::SETGT:
  case ISD::SETGE:
  case ISD::SETLT:
  case ISD::SETLE: {
    if (TmpVT.getScalarSizeInBits() == 16u) {
      for (unsigned i = 0; i < arity; i++) {
        LHSElts[i] = signExtendElement(LHSElts[i], 16u);
        RHSElts[i] = signExtendElement(RHSElts[i], 16u);
      }
    }
    break;
  }
  }

  SmallVector<SDValue, 4> compared;
  for (unsigned i = 0; i < arity; i++) {
    compared.push_back(signExtendElement(
        DAG.getSetCC(dl, MVT::i32, LHSElts[i], RHSElts[i], CC), 31u));
  }

  return DAG.getBuildVector(CmpVT, dl, compared);
}

SDValue ColossusTargetLowering::LowerSETCC(SDValue Op,
                                           SelectionDAG &DAG) const {
  SDLoc dl(Op);
  auto const StrictFP = Op->isStrictFPOpcode();
  auto const LHSOpNum = StrictFP ? 1 : 0;
  SDValue LHS = Op.getOperand(LHSOpNum);
  SDValue RHS = Op.getOperand(LHSOpNum + 1);
  EVT CmpVT = Op.getValueType();
  assert(CmpVT.getStoreSize() <= 8 && "Unexpected SETCC result");
  EVT TmpVT = LHS.getValueType();
  assert(TmpVT == RHS.getValueType() && "Unexpected argument type in SETCC");
  (void)CmpVT;
  (void)RHS;
  if (TmpVT.isFloatingPoint()) {
    return LowerFloatingPointSETCC(Op, DAG);
  } else {
    assert(CmpVT.isVector() && "Expected vector SETCC");
    return LowerIntegerSETCC(Op, DAG);
  }
}

static SDValue incrByImmediate(SelectionDAG &DAG, SDValue Op, uint32_t imm) {
  SDLoc dl(Op);
  assert(Op.getValueType() == MVT::i32);
  SDValue c = DAG.getConstant(imm, dl, MVT::i32);
  return DAG.getNode(ISD::ADD, dl, MVT::i32, Op, c);
}

SDValue ColossusTargetLowering::LowerLOAD(SDValue Op, SelectionDAG &DAG) const {

  using LoadExtType = ISD::LoadExtType;

  SDLoc dl(Op);
  LoadSDNode *LDNode = cast<LoadSDNode>(Op);
  if (!ISD::isUNINDEXEDLoad(LDNode)) {
    // Indexed loads at this point in the pipeline are generated
    // by intrinsics that are lowered to already legal loads.
    return SDValue();
  }

  EVT MemVT = LDNode->getMemoryVT();
  unsigned Align = LDNode->getAlignment();
  SDValue Chain = LDNode->getChain();
  SDValue Addr = LDNode->getBasePtr();
  auto &pInfo = LDNode->getPointerInfo();
  auto flags = LDNode->getMemOperand()->getFlags();
  auto extType = LDNode->getExtensionType();

  auto getSplitVT = [](EVT x) {
    assert(x.isVector());
    unsigned n = x.getVectorNumElements();
    MVT elementVT = x.getVectorElementType().getSimpleVT();
    if (n == 2) {
      return elementVT;
    } else {
      return MVT::getVectorVT(elementVT, n / 2);
    }
  };

  if (MemVT.getSizeInBits() == 64) {
    assert(MemVT.isVector());
    if (Align >= 8) {
      return SDValue();
    }

    if (Align == 4) {
      // Split into two 32 bit, align 4 ops
      MVT SplitVT = getSplitVT(MemVT);
      unsigned Size = MemVT.getStoreSize() / 2;

      SDValue AddrLo = Addr;
      SDValue AddrHi = incrByImmediate(DAG, Addr, Size);

      SDValue Lo = DAG.getLoad(SplitVT, dl, Chain, AddrLo, pInfo, Align, flags);
      SDValue Hi = DAG.getLoad(SplitVT, dl, Chain, AddrHi, pInfo, Align, flags);

      SDValue OutRes = concatValues(Lo, Hi, DAG);
      SDValue OutChains[] = {SDValue(Hi.getNode(), 1),
                             SDValue(Lo.getNode(), 1)};
      SDValue OutChain =
        DAG.getNode(ISD::TokenFactor, dl, MVT::Other, OutChains);

      SDValue Ops[2] = {OutRes, OutChain};
      SDNode *merged = DAG.getMergeValues(Ops, dl).getNode();
      return SDValue(merged, Op.getResNo());
    }

    auto Ops = expandUnalignedLoad(LDNode, DAG);
    auto Merged = DAG.getMergeValues({Ops.first, Ops.second}, dl).getNode();
    return {Merged, Op.getResNo()};
  }

  // ---------------------------------------------------------------------------

  auto getLoadi8 = [&](SDValue addr) {
    return DAG.getExtLoad(ISD::EXTLOAD, dl, MVT::i32, Chain,
                          addr, pInfo, MVT::i8, 1u, flags);
  };

  auto getLoadi16 = [&](SDValue addr) {
    return DAG.getExtLoad(ISD::EXTLOAD, dl, MVT::i32, Chain,
                          addr, pInfo, MVT::i16, 2u, flags);
  };

  auto getLoadf16 = [&](SDValue addr) {
    return DAG.getLoad(MVT::f16, dl, Chain,
                       addr, pInfo, 2u, flags);
  };

  auto getMergeVals = [&](SDValue val) -> SDValue {
    auto MergeVal = DAG.getMergeValues({val, Chain}, dl);
    return {MergeVal.getNode(), Op.getResNo()};
  };

  if (extType == LoadExtType::NON_EXTLOAD) {

    switch (MemVT.getSimpleVT().SimpleTy) {
      case MVT::i32:
      case MVT::f32:
      case MVT::v2i16:
      case MVT::v2f16: {

        if (Align >= MemVT.getStoreSize()) {
          return {};
        }

        LLVM_DEBUG(dbgs() << "LowerLOAD of " << MemVT.getEVTString() << "\n");

        if (Align == 2u) {

          auto getValues = [&]() -> SmallVector<SDValue, 2u> {
            auto const LoAddr = Addr;
            auto const HiAddr = incrByImmediate(DAG, Addr, Align);

            if (MemVT.isInteger()) {

              auto getLoad = [&](SDValue addr) {
                return DAG.getBitcast(MVT::v2i16, getLoadi16(addr));
              };

              return {getLoad(LoAddr), getLoad(HiAddr)};
            }

            assert(MemVT.isFloatingPoint());

            auto getLoad = [&](SDValue addr) {
              auto Val = getLoadf16(addr);
              return DAG.getNode(ColossusISD::F16ASV2F16, dl, MVT::v2f16, Val);
            };

            return {getLoad(LoAddr), getLoad(HiAddr)};
          };

          auto Vals = getValues();
          auto VecVT = Vals[0].getValueType();
          auto SortVal = DAG.getNode(ColossusISD::SORT4X16LO, dl, VecVT, Vals);
          auto Bitcast = DAG.getBitcast(MemVT, SortVal);
          return getMergeVals(Bitcast);
        }

        assert(Align == 1u);

        // Single byte loads are not supported on the ARF. Perform load on the
        // MRF and cast to expected result type.

        auto LoValues = SmallVector<SDValue, 2u>{
          getLoadi8(Addr),
          getLoadi8(incrByImmediate(DAG, Addr, 1u))
        };

        auto HiValues = SmallVector<SDValue, 2u>{
          getLoadi8(incrByImmediate(DAG, Addr, 2u)),
          getLoadi8(incrByImmediate(DAG, Addr, 3u))
        };

        auto ShufValues = SmallVector<SDValue, 2u>{
          DAG.getNode(ColossusISD::SHUF8X8LO, dl, MVT::i32, LoValues),
          DAG.getNode(ColossusISD::SHUF8X8LO, dl, MVT::i32, HiValues)
        };

        auto SortVal = DAG.getNode(ColossusISD::SORT4X16LO,
                                   dl, MVT::i32, ShufValues);

        auto Bitcast = DAG.getBitcast(MemVT, SortVal);
        return getMergeVals(Bitcast);
      }
      case MVT::f16: {

        if (Align >= MemVT.getStoreSize()) {
          return {};
        }

        assert(Align == 1u);

        LLVM_DEBUG(dbgs() << "LowerLOAD of " << MemVT.getEVTString() << "\n");

        auto Vals = SmallVector<SDValue, 2u>{
          getLoadi8(Addr),
          getLoadi8(incrByImmediate(DAG, Addr, 1u))
        };

        auto ShufVal = DAG.getNode(ColossusISD::SHUF8X8LO, dl, MVT::i32, Vals);
        auto Bitcast = DAG.getBitcast(MVT::v2f16, ShufVal);
        auto Split = splitValue(Bitcast, DAG);
        return getMergeVals(Split.first);
      }
      default: {
        break;
      }
    }
  }

  // ---------------------------------------------------------------------------

  if (extType == LoadExtType::EXTLOAD || extType == LoadExtType::ZEXTLOAD) {
    auto ArgVT = Op.getValueType();

    if (MemVT == MVT::i16 && ArgVT == MVT::i32) {

      if (Align >= MemVT.getStoreSize()) {
        return {};
      }

      assert(Align == 1u);

      LLVM_DEBUG(dbgs() << "LowerLOAD of " << MemVT.getEVTString() << "\n");

      auto Vals = SmallVector<SDValue, 2u>{
        getLoadi8(Addr),
        getLoadi8(incrByImmediate(DAG, Addr, 1u))
      };

      auto ShufVal = DAG.getNode(ColossusISD::SHUF8X8LO, dl, MVT::i32, Vals);
      return getMergeVals(ShufVal);
    }

    if (MemVT == MVT::v4i8 && ArgVT == MVT::v4i16) {
      LLVM_DEBUG(dbgs() << "LowerLOAD of " << MemVT.getEVTString() << "\n");

      auto doLoad = [&](MVT type) -> SDValue {
        return DAG.getLoad(type, dl, Chain, Addr, pInfo, Align, flags);
      };

      auto doExpand = [&](SDValue val) -> SDValue {
        auto zero = DAG.getConstant(0u, dl, MVT::i32);
        auto ops = std::array<SDValue, 2u>{val, zero};
        auto lo = DAG.getNode(ColossusISD::SHUF8X8LO, dl, MVT::i32, ops);
        auto hi = DAG.getNode(ColossusISD::SHUF8X8HI, dl, MVT::i32, ops);
        lo = DAG.getBitcast(MVT::v2i16, lo);
        hi = DAG.getBitcast(MVT::v2i16, hi);
        return concatValues(lo, hi, DAG);
      };

      if (Align >= 4u) {
        auto ldval = doLoad(MVT::i32);
        auto outRes = doExpand(ldval);
        auto outChain = cast<LoadSDNode>(ldval)->getChain();
        auto merged = DAG.getMergeValues({outRes, outChain}, dl);
        return {merged.getNode(), Op.getResNo()};
      }

      SDValue Ops[2];
      if (Align == 2u) {
        auto ldval = doLoad(MVT::v2i16);
        std::tie(Ops[0], Ops[1]) =
            scalarizeVectorLoad(cast<LoadSDNode>(ldval), DAG);
        auto bcast = DAG.getBitcast(MVT::i32, DAG.getMergeValues(Ops, dl));
        auto outRes = doExpand(bcast);
        auto outChain = cast<LoadSDNode>(ldval)->getChain();
        auto merged = DAG.getMergeValues({outRes, outChain}, dl);
        return {merged.getNode(), Op.getResNo()};
      }

      std::tie(Ops[0], Ops[1]) = scalarizeVectorLoad(LDNode, DAG);
      return DAG.getMergeValues(Ops, dl);
    }
  }

  return SDValue();
}

SDValue ColossusTargetLowering::LowerStoreToLibcall(SDValue Op,
                                                    SelectionDAG &DAG) const {
  assert(Op.getOpcode() == ISD::STORE);
  StoreSDNode *STNode = cast<StoreSDNode>(Op);
  SDLoc dl(STNode);
  EVT MemVT = STNode->getMemoryVT();
  unsigned Align = STNode->getAlignment();
  SDValue Chain = STNode->getChain();
  SDValue Value = STNode->getValue();
  SDValue Addr = STNode->getBasePtr();

  auto getLibcallName = [](bool floatingPoint, unsigned alignment,
                           unsigned storeSize, bool isSupervisor) {
    assert(storeSize == 1 || storeSize == 2 || storeSize == 4);

    if (storeSize == 1) {
      assert(!floatingPoint);
      return "__st8";
    }

    assert(!(isSupervisor && floatingPoint));
    const char *table[/*ss*/ 2][/*a*/ 2][/*fp*/ 2][/*supervisor*/ 2] = {
      // 16 bit stores
      {
        // align 2
        {
          {"__st16", "__st16"},
          {"__st16f", "not_supported"},
        },
        // align 1
        {
          {"__st16_misaligned", "__supervisor_st16_misaligned"},
          {"__st16f_misaligned", "not_supported"},
        },
      },
      // 32 bit stores
      {
        // align 2
        {
          {"__st32_align2", "__supervisor_st32_align2"},
          {"__st32f_align2", "not_supported"},
        },
        // align 1
        {
          {"__st32_align1", "__supervisor_st32_align1"},
          {"__st32f_align1", "not_supported"},
        },
      },
    };

    return table[storeSize == 4][alignment == 1][floatingPoint][isSupervisor];
  };

  auto ss = MemVT.getStoreSize();
  bool smallPowerTwo = (ss == 1 || ss == 2 || ss == 4);
  if (!smallPowerTwo) {
    return {};
  }

  bool subword = ss < 4;
  bool misaligned = Align < ss;
  if (subword && MemVT.isVector()) {
    return {};
  }

  if (subword || misaligned) {
    const char *libcall =
        getLibcallName(MemVT.isFloatingPoint(), Align, ss, 
                       isSupervisorSubtarget(DAG));

    Type *IntTy = Type::getInt32Ty(*DAG.getContext());
    Type *VoidTy = Type::getVoidTy(*DAG.getContext());
    Type *ValueTy = MemVT.getTypeForEVT(*DAG.getContext());
    MVT PtrTy = getPointerTy(DAG.getDataLayout());

    TargetLowering::ArgListTy Args;
    TargetLowering::ArgListEntry Entry;
    Entry.Ty = IntTy;
    Entry.Node = Addr;
    Args.push_back(Entry);
    Entry.Ty = ValueTy;
    Entry.Node = Value;
    Args.push_back(Entry);

    SDValue ExtSym = DAG.getExternalSymbol(libcall, PtrTy);
    TargetLowering::CallLoweringInfo CLI(DAG);
    CLI.setDebugLoc(dl).setChain(Chain).setCallee(CallingConv::C, VoidTy,
                                                  ExtSym, std::move(Args));
    std::pair<SDValue, SDValue> CallResult = LowerCallTo(CLI);
    return CallResult.second;
  }

  return {};
}

SDValue ColossusTargetLowering::LowerSTORE(SDValue Op,
                                           SelectionDAG &DAG) const {
  SDLoc dl(Op);
  StoreSDNode *STNode = cast<StoreSDNode>(Op);
  if (!ISD::isUNINDEXEDStore(STNode)) {
    // Indexed stores at this point in the pipeline are generated
    // by intrinsics that are lowered to already legal stores.
    return SDValue();
  }

  EVT MemVT = STNode->getMemoryVT();

  // Emit function calls for scalar subword stores
  auto ss = MemVT.getStoreSize();
  if (!MemVT.isVector() && ss < 4) {
    if (ss == 1 || ss == 2) {
      return LowerStoreToLibcall(Op, DAG);
    } else {
      report_fatal_error("unsupported sub-word store size");
    }
  }

  unsigned Align = STNode->getAlignment();
  SDValue Chain = STNode->getChain();
  SDValue Value = STNode->getValue();
  SDValue Addr = STNode->getBasePtr();
  auto &pInfo = STNode->getPointerInfo();
  auto flags = STNode->getMemOperand()->getFlags();
  auto AAInfo = STNode->getAAInfo();

  if (MemVT.getSizeInBits() == 64) {
    assert(MemVT.isVector());
    if (!ISD::isNormalStore(STNode)) {
      // 64 bit truncating stores are not custom lowered
      report_fatal_error("Unexpected custom lowered truncating store");
    }
    if (Align >= 8) {
      return SDValue();
    }

    if (Align == 4) {
      auto split = splitValue(Value, DAG);
      unsigned Size = MemVT.getStoreSize() / 2;
      assert(Addr.getValueType() == MVT::i32);
      SDValue AddrLo = Addr;
      SDValue AddrHi = incrByImmediate(DAG, Addr, Size);

      SDValue OutChains[2];
      OutChains[0] =
          DAG.getStore(Chain, dl, split.first, AddrLo, pInfo, Align, flags);
      OutChains[1] =
          DAG.getStore(Chain, dl, split.second, AddrHi, pInfo, Align, flags);
      return DAG.getNode(ISD::TokenFactor, dl, MVT::Other, OutChains);
    }

    return expandUnalignedStore(STNode, DAG);
  }

  // Optimise truncating stores to vectors of i8
  auto ArgVT = Value.getValueType();
  if (MemVT == MVT::v4i8 && ArgVT == MVT::v4i16) {
    auto getSortNode = [&]() -> SDValue {
      auto valPair = splitValue(Value, DAG);
      auto arg0 = DAG.getBitcast(MVT::i32, valPair.first);
      auto arg1 = DAG.getBitcast(MVT::i32, valPair.second);
      return DAG.getNode(ColossusISD::SORT8X8LO, dl, MVT::i32, {arg0, arg1});
    };
    SDValue t = deriveStoreFromExisting(DAG, STNode, getSortNode());
    return (Align < 4) ? LowerStoreToLibcall(t, DAG) : t;
  }
  if (MemVT == MVT::v2i8 && ArgVT == MVT::v2i16) {
    // Truncate v2i16 to v2i8 within an i32, then store said i32
    SDValue tmp = DAG.getNode(ColossusISD::SORT8X8LO, dl, MVT::i32,
                              DAG.getBitcast(MVT::i32, Value),
                              DAG.getConstant(0, dl, MVT::i32));
    tmp = DAG.getTruncStore(Chain, dl, tmp, Addr, pInfo, MVT::i16, Align, flags,
                            AAInfo);
    return LowerStoreToLibcall(tmp, DAG);
  }

  // Emit function calls for 32 bit misaligned stores
  if (ss == 4 && Align < 4) {
    return LowerStoreToLibcall(Op, DAG);
  }

  // For all other stores, use the default lowering.
  return SDValue();
}

SDValue ColossusTargetLowering::
LowerVAARG(SDValue Op, SelectionDAG &DAG) const {
  // Whist llvm does not support aggregate varargs we can ignore
  // the possibility of the ValueType being an implicit byVal vararg.
  SDNode *Node = Op.getNode();
  EVT VT = Node->getValueType(0); // not an aggregate
  SDValue InChain = Node->getOperand(0);
  SDValue VAListPtr = Node->getOperand(1);
  EVT PtrVT = VAListPtr.getValueType();
  const Value *SV = cast<SrcValueSDNode>(Node->getOperand(2))->getValue();
  SDLoc dl(Node);
  SDValue VAList = DAG.getLoad(PtrVT, dl, InChain,
                               VAListPtr, MachinePointerInfo(SV));
  // Increment the pointer, VAList, to the next vararg
  SDValue nextPtr = DAG.getNode(ISD::ADD, dl, PtrVT, VAList,
                                DAG.getIntPtrConstant(VT.getSizeInBits() / 8,
                                                      dl));
  // Store the incremented VAList to the legalized pointer
  InChain = DAG.getStore(VAList.getValue(1), dl, nextPtr, VAListPtr,
                         MachinePointerInfo(SV));
  // Load the actual argument out of the pointer VAList
  return DAG.getLoad(VT, dl, InChain, VAList, MachinePointerInfo());
}

SDValue ColossusTargetLowering::
LowerVASTART(SDValue Op, SelectionDAG &DAG) const {
  // va_start(i8*) stores the address of the VarArgsFrameIndex slot
  // (stack pointer + stack frame size) into the memory location argument.
  SDLoc dl(Op);
  MachineFunction &MF = DAG.getMachineFunction();
  ColossusFunctionInfo *CFI = MF.getInfo<ColossusFunctionInfo>();
  int FrameIndex = CFI->getVarArgsFrameIndex();
  SDValue Addr = DAG.getFrameIndex(FrameIndex, MVT::i32);
  return DAG.getStore(Op.getOperand(0), dl, Addr, Op.getOperand(1),
                      MachinePointerInfo::getFixedStack(MF, FrameIndex));
}

namespace {
namespace shuffle {

  template <size_t N> void populate_undef(std::array<int, N> & mask) {
    static_assert(N == 2 || N == 4, "");
    // Given a shufflevector mask, replace any undef values with
    // ones that will lead to the cheapest instruction sequence.
    // The cost metric used for this was:
    // Register copies are free (nb the copy elision pass isn't implemented yet)
    // swap16 is preferred to roll16 or sort4x16
    // Fewer instructions are better

    // Precondition: There will be at most one undef value per pair

    auto other = [](size_t x) { return (x % 2) ? x - 1 : x + 1; };
    auto is_undef = [](int x) { return x < 0; };

    auto num_undef = [&]() {
      return std::count_if(std::begin(mask), std::end(mask), is_undef);
    };

    auto undef_index = [&]() {
      assert(num_undef() == 1);
      for (size_t i = 0; i < N; i++) {
        if (is_undef(mask[i])) {
          return i;
        }
      }
      assert(false);
      return N;
    };

    // Given a pair with one undef value, choose to either
    // copy or swap from the other half of that register
    if (N == 2) {
      assert(num_undef() < 2);
      if (num_undef() == 1) {
        size_t u = undef_index();
        mask[u] = other(mask[other(u)]);
        assert(num_undef() == 0);
      }
    }

    if (N == 4) {
      assert(num_undef() < 3);

      if (num_undef() == 2) {
        // Detect where two swap16 can be replaced by a roll16 and a copy
        // The corresponding undef (mask[1],mask[2]) would use two instructions
        if (is_undef(mask[0]) && is_undef(mask[3])) {
          if ((mask[1] % 2 == 0) && (mask[2] % 2 == 1)) {
            mask[0] = mask[2];
          }
        }
      }

      if (num_undef() == 1) {
        const size_t u = undef_index();
        const size_t d = other(u);
        assert(!is_undef(d));

        // Check for the case where a roll and a swap are needed to populate
        // a single register and the other output register is satisfied by the
        // result of the roll. This replaces roll->swap->swap with roll->swap.
        // Specifically, <a b b a> and a & b are in different registers

        bool is_symmetric = true;
        for (unsigned i = 0u; i < 2u; i++) {
          if ((mask[i] >= 0) && (mask[3 - i] >= 0)) {
            if (mask[i] != mask[3 - i]) {
              is_symmetric = false;
            }
          }
        }

        bool is_derived_from_different_registers = true;
        if (u == 0 || u == 1) {
          if (mask[2] / 2 == mask[3] / 2) {
            is_derived_from_different_registers = false;
          }
        }
        if (u == 2 || u == 3) {
          if (mask[0] / 2 == mask[1] / 2) {
            is_derived_from_different_registers = false;
          }
        }

        if (is_symmetric && is_derived_from_different_registers) {
          mask[u] = mask[3 - u];
          assert(num_undef() == 0);
          return;
        }

        // Copy or swap from the other half of the output vector
        if (mask[d] == mask[(d + 2) % 4]) {
          mask[u] = mask[(u + 2) % 4];
          assert(num_undef() == 0);
          return;
        }
        if (mask[d] == mask[3 - d]) {
          mask[u] = mask[3 - u];
          assert(num_undef() == 0);
          return;
        }
      }

      // Recurse to handle any remaining undef values
      {
        std::array<int, 2> lo{{mask[0], mask[1]}};
        populate_undef<2>(lo);
        mask[0] = lo[0];
        mask[1] = lo[1];
      }
      {
        std::array<int, 2> hi{{mask[2], mask[3]}};
        populate_undef<2>(hi);
        mask[2] = hi[0];
        mask[3] = hi[1];
      }
    }
    assert(num_undef() == 0);
    return;
  }

  template <unsigned ArrSize>
  static SDValue v2x16(SelectionDAG & DAG, SDLoc dl, ArrayRef<int> mask,
                       std::array<SDValue, ArrSize> Pair) {
    assert(mask.size() == 2);
    auto VecVT = Pair[0].getValueType();
    auto RetVT = VecVT.isInteger() ? MVT::v2i16 : MVT::v2f16;
    MVT intermediateVT = (RetVT == MVT::v2i16) ? MVT::i32 : MVT::f16;

    auto low = [](unsigned x) { return (x % 2) == 0; };

    if (mask[0] < 0 && mask[1] < 0) {
      return DAG.getUNDEF(RetVT);
    }

    std::array<int, 2> MM{{mask[0], mask[1]}};
    populate_undef<2>(MM);
    assert(mask[0] >= 0 ? (MM[0] == mask[0]) : true);
    assert(mask[1] >= 0 ? (MM[1] == mask[1]) : true);

    assert(MM[0] / 2u < ArrSize);
    SDValue &P0 = Pair[MM[0] / 2u];
    assert(MM[1] / 2u < ArrSize);
    SDValue &P1 = Pair[MM[1] / 2u];

    // Both output elements are from the same input register.
    if (MM[0] / 2u == MM[1] / 2u) {
      assert(P0 == P1);
      if (low(MM[0]) && ((MM[0] + 1) == MM[1])) {
        return P0;
      }
    }

    // Otherwise need to use both input registers.
    auto buildFromP0P1GivenIndices = [&](unsigned idxP0, unsigned idxP1) {
      return DAG.getNode(
          ISD::BUILD_VECTOR, dl, RetVT,
          DAG.getNode(ISD::EXTRACT_VECTOR_ELT, dl, intermediateVT, P0,
                      DAG.getConstant(idxP0, dl, MVT::i32)),
          DAG.getNode(ISD::EXTRACT_VECTOR_ELT, dl, intermediateVT, P1,
                      DAG.getConstant(idxP1, dl, MVT::i32)));
    };
    if (low(MM[0])) {
      if (low(MM[1])) {
        return buildFromP0P1GivenIndices(0, 0);
      } else {
        return buildFromP0P1GivenIndices(0, 1);
      }
    } else {
      if (low(MM[1])) {
        return buildFromP0P1GivenIndices(1, 0);
      } else {
        return buildFromP0P1GivenIndices(1, 1);
      }
    }
  }

  template <unsigned ArrSize>
  static SDValue v4x16(SelectionDAG & DAG, SDLoc dl, ArrayRef<int> M,
                       std::array<SDValue, ArrSize> Pair) {
    assert(M.size() == 4);
    static_assert(ArrSize == 4, "");
    auto VecVT = Pair[0].getValueType();
    auto RetVT = VecVT.isInteger() ? MVT::v2i16 : MVT::v2f16;
    auto RetVTQuad = VecVT.isInteger() ? MVT::v4i16 : MVT::v4f16;

    auto swapPair = [&DAG, dl, RetVT](SDValue Vec) -> SDValue {
      MVT intermediateVT = (RetVT == MVT::v2i16) ? MVT::i32 : MVT::f16;
      return DAG.getNode(
            ISD::BUILD_VECTOR, dl, RetVT,
            DAG.getNode(ISD::EXTRACT_VECTOR_ELT, dl, intermediateVT, Vec,
                        DAG.getConstant(1, dl, MVT::i32)),
            DAG.getNode(ISD::EXTRACT_VECTOR_ELT, dl, intermediateVT, Vec,
                        DAG.getConstant(0, dl, MVT::i32)));
    };

    auto concat_two_v2x16 = [&](SDValue ResLo, SDValue ResHi) {
      // Use Colossus concat here to avoid a general combine undef => 0
      return DAG.getNode(ColossusISD::CONCAT_VECTORS, dl, RetVTQuad, ResLo,
                         ResHi);
    };

    // Handle simple undef cases
    if (std::all_of(M.begin(), M.end(), [](int x) { return x < 0; })) {
      return DAG.getUNDEF(RetVTQuad);
    }

    if (M[0] < 0 && M[1] < 0) {
      SDValue ResLo = DAG.getUNDEF(RetVT);
      SDValue ResHi = v2x16<4>(DAG, dl, {M.data() + 2, 2}, Pair);
      return concat_two_v2x16(ResLo, ResHi);
    }
    if (M[2] < 0 && M[3] < 0) {
      SDValue ResLo = v2x16<4>(DAG, dl, {M.data(), 2}, Pair);
      SDValue ResHi = DAG.getUNDEF(RetVT);
      return concat_two_v2x16(ResLo, ResHi);
    }

    // Copy the input mask into a mutable mask, then populate the undef values
    // with values chosen to optimise the following instruction selection
    std::array<int, 4> MM{{M[0], M[1], M[2], M[3]}};
    populate_undef(MM);
    for (unsigned i = 0; i < 4; i++) {
      assert(M[0] >= 0 ? (MM[0] == M[0]) : true);
    }

    // Both halves are the same
    if ((MM[0] == MM[2]) && (MM[1] == MM[3])) {
      SDValue ResLo = v2x16<4>(DAG, dl, {MM.data(), 2}, Pair);
      SDValue ResHi = ResLo;
      return concat_two_v2x16(ResLo, ResHi);
    }

    // One half is swap16 of the other, so build the cheaper half first
    if ((MM[0] == MM[3]) && (MM[1] == MM[2])) {
      auto needs_both_roll_and_swap = [&](int lo, int hi) {
        assert(MM[lo] >= 0);
        assert(MM[hi] >= 0);
        // Copy or swap suffice if the word is built from a single register
        if ((MM[lo] / 2u) != (MM[hi] / 2u)) {
          // Test if we are also an instance of the only two instruction case
          if (MM[lo] % 2 == 0) {
            if (MM[hi] % 2 == 1) {
              return true;
            }
          }
        }
        return false;
      };
      auto is_simple_copy = [&](unsigned lo, unsigned hi) {
        return (lo + 1 == hi);
      };

      SDValue ResLo, ResHi;
      if (needs_both_roll_and_swap(0, 1)) {
        ResHi = v2x16<4>(DAG, dl, {MM.data() + 2, 2}, Pair);
        ResLo = swapPair(ResHi);
      } else if (is_simple_copy(MM[2], MM[3])) {
        ResHi = v2x16<4>(DAG, dl, {MM.data() + 2, 2}, Pair);
        ResLo = swapPair(ResHi);
      } else {
        ResLo = v2x16<4>(DAG, dl, {MM.data(), 2}, Pair);
        ResHi = swapPair(ResLo);
      }
      return concat_two_v2x16(ResLo, ResHi);
    }

    // General case
    SDValue ResLo = v2x16<4>(DAG, dl, {MM.data(), 2}, Pair);
    SDValue ResHi = v2x16<4>(DAG, dl, {MM.data() + 2, 2}, Pair);
    return concat_two_v2x16(ResLo, ResHi);
  }
}
}

SDValue ColossusTargetLowering::LowerVECTOR_SHUFFLE(SDValue Op,
                                                    SelectionDAG &DAG) const {
  SDLoc dl(Op);
  ShuffleVectorSDNode *SVN = cast<ShuffleVectorSDNode>(Op.getNode());
  ArrayRef<int> M = SVN->getMask();
  SDValue Vec0 = Op.getOperand(0);
  SDValue Vec1 = Op.getOperand(1);

  EVT VecTy = Vec0.getValueType();
  assert(VecTy == Vec1.getValueType());

  if (VecTy == MVT::v2i16 || VecTy == MVT::v4i16) {
    assert((M.size() == 2 && Op.getValueType() == MVT::v2i16) ||
           (M.size() == 4 && Op.getValueType() == MVT::v4i16));
  }
  if (VecTy == MVT::v2f16 || VecTy == MVT::v4f16) {
    assert((M.size() == 2 && Op.getValueType() == MVT::v2f16) ||
           (M.size() == 4 && Op.getValueType() == MVT::v4f16));
  }

  if (VecTy == MVT::v2i16 || VecTy == MVT::v2f16) {
    assert(std::all_of(M.begin(), M.end(), [](int x) { return x < 4; }));
    return shuffle::v2x16<2>(DAG,dl,M,{{Vec0, Vec1}});
  }

  if (VecTy == MVT::v4i16 || VecTy == MVT::v4f16) {
    assert(std::all_of(M.begin(), M.end(), [](int x) { return x < 8; }));
    auto Vec0Split = splitValue(Vec0, DAG);
    auto Vec1Split = splitValue(Vec1, DAG);
    return shuffle::v4x16<4>(DAG, dl, M,
                             {{
                                 Vec0Split.first,
                                 Vec0Split.second,
                                 Vec1Split.first,
                                 Vec1Split.second,
                             }});
  }

  return SDValue();
}

SDValue ColossusTargetLowering::LowerSCALAR_TO_VECTOR(SDValue Op,
                                                      SelectionDAG &DAG) const {
  // setOperationAction(Expand) generates store/load via the stack
  EVT VT = Op.getValueType();
  unsigned numElts = VT.getVectorNumElements();
  SmallVector<SDValue, 4> Ops;
  Ops.push_back(Op.getOperand(0));
  SDValue undef = DAG.getUNDEF(Ops[0].getValueType());
  for (unsigned i = 1; i < numElts; i++) {
    Ops.push_back(undef);
  }
  return DAG.getBuildVector(VT, SDLoc(Op), Ops);
}

SDValue ColossusTargetLowering::
LowerATOMIC_FENCE(SDValue Op, SelectionDAG &DAG) const {
  SDLoc dl(Op);
  return DAG.getNode(ColossusISD::MEM_BARRIER, dl,
                     MVT::Other, Op.getOperand(0));
}

SDValue ColossusTargetLowering::
LowerATOMIC_LOAD(SDValue Op, SelectionDAG &DAG) const {
  AtomicSDNode *N = cast<AtomicSDNode>(Op);
  assert(N->getOpcode() == ISD::ATOMIC_LOAD && "Bad Atomic OP");
  assert(
      (N->getSuccessOrdering() == AtomicOrdering::Unordered ||
       N->getSuccessOrdering() == AtomicOrdering::Monotonic) &&
      "shouldInsertFencesForAtomic() expects unordered / monotonic when true");
  if (N->getMemoryVT() == MVT::i32) {
    if (N->getAlignment() < 4) {
      report_fatal_error("i32 atomic load must be aligned");
    }
    return DAG.getLoad(getPointerTy(DAG.getDataLayout()),
                       SDLoc(Op),
                       N->getChain(), N->getBasePtr(), N->getPointerInfo(),
                       N->getAlignment(), N->getMemOperand()->getFlags(),
                       N->getAAInfo(), N->getRanges());
  }
  if (N->getMemoryVT() == MVT::i16) {
    if (N->getAlignment() < 2) {
      report_fatal_error("i16 atomic load must be aligned");
    }
    return DAG.getExtLoad(ISD::EXTLOAD, SDLoc(Op), MVT::i32, N->getChain(),
                          N->getBasePtr(), N->getPointerInfo(), MVT::i16,
                          N->getAlignment(), N->getMemOperand()->getFlags(),
                          N->getAAInfo());
  }
  if (N->getMemoryVT() == MVT::i8) {
    return DAG.getExtLoad(ISD::EXTLOAD, SDLoc(Op), MVT::i32, N->getChain(),
                          N->getBasePtr(), N->getPointerInfo(), MVT::i8,
                          N->getAlignment(), N->getMemOperand()->getFlags(),
                          N->getAAInfo());
  }
  return SDValue();
}

SDValue ColossusTargetLowering::
LowerATOMIC_STORE(SDValue Op, SelectionDAG &DAG) const {
  AtomicSDNode *N = cast<AtomicSDNode>(Op);
  assert(N->getOpcode() == ISD::ATOMIC_STORE && "Bad Atomic OP");
  assert(
      (N->getSuccessOrdering() == AtomicOrdering::Unordered ||
       N->getSuccessOrdering() == AtomicOrdering::Monotonic) &&
      "shouldInsertFencesForAtomic() expects unordered / monotonic when true");
  if (N->getMemoryVT() == MVT::i32) {
    if (N->getAlignment() < 4)
      report_fatal_error("atomic store must be aligned");
    return DAG.getStore(N->getChain(), SDLoc(Op), N->getVal(), N->getBasePtr(),
                        N->getPointerInfo(), N->getAlignment(),
                        N->getMemOperand()->getFlags(), N->getAAInfo());
  }
  if (N->getMemoryVT() == MVT::i8 ||
      N->getMemoryVT() == MVT::i16) {
    report_fatal_error("i8 and i16 atomic store not supported");
  }
  return SDValue();
}

static const char *getLibmName(unsigned node, EVT ty) {
  assert(ty == MVT::f16 || ty == MVT::v2f16 || ty == MVT::v4f16 ||
         ty == MVT::v2f32);

  struct libmInfoEntry {
    const char *f16;
    const char *v2f16;
    const char *v4f16;
    const char *v2f32;
  };

  const auto &LibmInfo = [node]() -> libmInfoEntry {
    switch (node) {
    default:
      report_fatal_error("Cannot lower intrinsic to unknown libm call");
    case ISD::FABS:
      return {"half_fabs", "half2_fabs", "half4_fabs", "float2_fabs"};
    case ISD::FCOPYSIGN:
      return {"half_copysign", "half2_copysign", "half4_copysign",
              "float2_copysign"};
    case ISD::FREM:
    case ISD::STRICT_FREM:
      return {"half_fmod", "half2_fmod", "half4_fmod", "float2_fmod"};
    case ISD::FEXP:
    case ISD::STRICT_FEXP:
      return {"half_exp", "half2_exp", "half4_exp", "float2_exp"};
    case ISD::FEXP2:
    case ISD::STRICT_FEXP2:
      return {"half_exp2", "half2_exp2", "half4_exp2", "float2_exp2"};
    case ISD::FLOG:
    case ISD::STRICT_FLOG:
      return {"half_log", "half2_log", "half4_log", "float2_log"};
    case ISD::FLOG2:
    case ISD::STRICT_FLOG2:
      return {"half_log2", "half2_log2", "half4_log2", "float2_log2"};
    case ISD::FLOG10:
    case ISD::STRICT_FLOG10:
      return {"half_log10", "half2_log10", "half4_log10", "float2_log10"};
    case ISD::FSIN:
    case ISD::STRICT_FSIN:
      return {"half_sin", "half2_sin", "half4_sin", "float2_sin"};
    case ISD::FCOS:
    case ISD::STRICT_FCOS:
      return {"half_cos", "half2_cos", "half4_cos", "float2_cos"};
    case ISD::FPOW:
    case ISD::STRICT_FPOW:
      return {"half_pow", "half2_pow", "half4_pow", "float2_pow"};
    case ISD::FSQRT:
    case ISD::STRICT_FSQRT:
      return {"half_sqrt", "half2_sqrt", "half4_sqrt", "float2_sqrt"};
    case ISD::FMA:
    case ISD::STRICT_FMA:
      return {"half_fma", "half2_fma", "half4_fma", "float2_fma"};
    }
  }();

  if (ty == MVT::f16)
    return LibmInfo.f16;
  if (ty == MVT::v2f16)
    return LibmInfo.v2f16;
  if (ty == MVT::v4f16)
    return LibmInfo.v4f16;
  if (ty == MVT::v2f32)
    return LibmInfo.v2f32;

  llvm_unreachable("Unsupported type");
}

static std::pair<SDValue, SDValue> split64BitFloatOperation(SDValue Op,
                                                            SelectionDAG &DAG) {
  const unsigned num = Op.getNumOperands();
  const unsigned opc = Op.getOpcode();
  bool StrictFP = Op.getNode()->isStrictFPOpcode();
  assert(num > 0);
  SDLoc dl(Op);
  EVT VT = Op.getValueType();
  assert(VT == MVT::v2f32 || VT == MVT::v4f16);
  EVT halfTy = (VT == MVT::v2f32) ? MVT::f32 : MVT::v2f16;

  SmallVector<SDValue, 4> lowHalf, highHalf;
  for (unsigned i = 0; i < num; i++) {
    SDValue operand = Op.getOperand(i);
    std::pair<SDValue, SDValue> split;
    if (i == 0 && StrictFP) {
      assert(operand.getValueType() == MVT::Other);
      split.first = split.second = operand;
    } else {
      assert(operand.getValueType() == VT);
      split = splitValue(operand, DAG);
    }
    lowHalf.push_back(split.first);
    highHalf.push_back(split.second);
  }

  if (StrictFP) {
    return std::make_pair(DAG.getNode(opc, dl, {halfTy, MVT::Other}, lowHalf),
                          DAG.getNode(opc, dl, {halfTy, MVT::Other}, highHalf));
  }
  return std::make_pair(DAG.getNode(opc, dl, halfTy, lowHalf),
                        DAG.getNode(opc, dl, halfTy, highHalf));
}

// Custom lowering for non-f32 floating point operations
// Makes better use of available vector operations than the builtin expand
// which scalarises everything.
SDValue
ColossusTargetLowering::recursiveLowerFPOperation(SDValue Op,
                                                  SelectionDAG &DAG) const {
  bool StrictFP = Op.getNode()->isStrictFPOpcode();
  auto firstValueOperand = StrictFP ? 1u : 0u;
  assert(Op.getNumOperands() > firstValueOperand);
  auto dl = SDLoc{Op};
  auto VT = Op.getValueType();
  auto const Opc = Op.getOpcode();

  auto getColossusOpAction = [this](unsigned Opc, EVT VT) -> LegalizeAction {
    switch (Opc) {
      case ColossusISD::FTANH:
      case ColossusISD::FSIGMOID: {
        return (VT == MVT::f32 || VT == MVT::v2f16) ? Legal : Expand;
      }
      case ColossusISD::FRSQRT:
      case ColossusISD::STRICT_FRSQRT: {
        return (VT == MVT::f32) ? Legal : Expand;
      }
      default: {
        assert(getOperationAction(Opc, MVT::f32) == Legal);
        return getOperationAction(Opc, VT);
      }
    }
  };

  // Simplify recursive handling
  if (getColossusOpAction(Opc, VT) == Legal) {
    return Op;
  }

  if (VT == MVT::v2f32) {
    // Equivalent to built in expand, useful for v2f16 => v2f32
    auto split = split64BitFloatOperation(Op, DAG);
    SDValue vector = DAG.getBuildVector(VT, dl, {split.first, split.second});
    if (!StrictFP) {
      return vector;
    }
    SmallVector<SDValue, 2> chains = {split.first.getValue(1),
                                      split.second.getValue(1)};
    SDValue outputChain = DAG.getTokenFactor(dl, chains);
    return DAG.getMergeValues({vector, outputChain}, dl);
  }

  if (VT == MVT::v4f16) {
    // Split into two v2f16 operations
    auto split = split64BitFloatOperation(Op, DAG);
    SDValue lowHalf = recursiveLowerFPOperation(split.first, DAG);
    SDValue highHalf = recursiveLowerFPOperation(split.second, DAG);
    SDValue vector =
        DAG.getNode(ISD::CONCAT_VECTORS, dl, VT, lowHalf, highHalf);
    if (!StrictFP) {
      return vector;
    }
    SmallVector<SDValue, 2> chains = {lowHalf.getValue(1),
                                      highHalf.getValue(1)};
    SDValue outputChain = DAG.getTokenFactor(dl, chains);
    return DAG.getMergeValues({vector, outputChain}, dl);
  }

  auto promoteOperands = [&](SDValue Op, EVT to) {
    SmallVector<SDValue, 3> tmp;
    SmallVector<SDValue, 3> chains;
    if (StrictFP) {
      tmp.push_back({});
    }
    for (unsigned i = firstValueOperand; i < Op.getNumOperands(); ++i) {
      SDValue opi = Op.getOperand(i);
      assert(opi.getValueType() == VT);
      if (StrictFP) {
        SDValue Chain = Op.getOperand(0);
        tmp.push_back(DAG.getStrictFPExtendOrRound(opi, Chain, dl, to).first);
        chains.push_back(tmp.back().getValue(1));
      } else {
        tmp.push_back(DAG.getFPExtendOrRound(opi, dl, to));
      }
    }
    if (StrictFP) {
      tmp[0] = DAG.getTokenFactor(dl, chains);
    }
    return tmp;
  };

  if (VT == MVT::f16) {
    if (getColossusOpAction(Opc, MVT::v2f16) == Legal) {
      // Prefer v2f16 to f32 if available
      return locallyVectorize16BitOp(Op, DAG, false);
    } else { // Otherwise promote to f32
      auto args = promoteOperands(Op, MVT::f32);
      if (StrictFP) {
        SDValue viaPromotion =
            DAG.getNode(Opc, dl, {MVT::f32, MVT::Other}, args);
        SDValue Chain = viaPromotion.getValue(1);
        return DAG.getStrictFPExtendOrRound(viaPromotion, Chain, dl, VT).first;
      }
      SDValue viaPromotion = DAG.getNode(Opc, dl, MVT::f32, args);
      return DAG.getFPExtendOrRound(viaPromotion, dl, VT);
    }
  }

  if (VT == MVT::v2f16) {
    // Promote to v2f32 without scalarising
    auto args = promoteOperands(Op, MVT::v2f32);
    SDValue viaPromotion = DAG.getNode(Opc, dl, MVT::v2f32, args);
    SDValue loweredFPOp = recursiveLowerFPOperation(viaPromotion, DAG);
    if (!StrictFP) {
      return DAG.getFPExtendOrRound(loweredFPOp, dl, VT);
    }
    SDValue Chain = loweredFPOp.getValue(1);
    auto FPRoundResults =
        DAG.getStrictFPExtendOrRound(loweredFPOp, Chain, dl, VT);
    return FPRoundResults.first;
  }

  LLVM_DEBUG(dbgs() << "recursiveLowerFPOperation: "; Op.dump(););
  report_fatal_error("recursiveLowerFPOperation cannot handle Op");
}

SDValue ColossusTargetLowering::LowerFNEG(SDValue Op,
                                          SelectionDAG &DAG) const {
  SDLoc DL(Op);
  SDValue Zero = DAG.getConstantFP(0.0, DL, Op.getValueType());
  return DAG.getNode(ISD::FSUB, DL, Op.getValueType(), Zero, Op.getOperand(0));
}

SDValue ColossusTargetLowering::LowerLibmIntrinsic(SDValue Op,
                                                   SelectionDAG &DAG) const {
  bool strictFP = Op.getNode()->isStrictFPOpcode();
  assert(Op.getNumOperands() > (strictFP ? 1 : 0));
  SDLoc dl(Op);
  EVT VT = Op.getValueType();

  assert(VT != MVT::f32); // f32 handled by standard lowering mechanism

  // Use instruction support if it's available
  if (getOperationAction(Op.getOpcode(), MVT::f32) == Legal) {
    return recursiveLowerFPOperation(Op, DAG);
  }

  auto getType = [&](EVT VT) -> Type * {
    LLVMContext *context = DAG.getContext();
    if (VT == MVT::f16)
      return Type::getHalfTy(*context);
    if (VT == MVT::v2f16)
      return FixedVectorType::get(Type::getHalfTy(*context), 2);
    if (VT == MVT::v4f16)
      return FixedVectorType::get(Type::getHalfTy(*context), 4);
    if (VT == MVT::v2f32)
      return FixedVectorType::get(Type::getFloatTy(*context), 2);
    report_fatal_error("Unhandled type");
  };

  Type *vecType = getType(VT);
  TargetLowering::ArgListTy Args;
  TargetLowering::ArgListEntry Entry;
  Entry.Ty = vecType;

  for (unsigned i = strictFP ? 1 : 0; i < Op.getNumOperands(); i++) {
    Entry.Node = Op.getOperand(i);
    assert(Entry.Node.getValueType() == VT); // assumes homogenous
    Args.push_back(Entry);
  }

  const char *libmName = getLibmName(Op.getOpcode(), VT);
  SDValue ExtSym =
      DAG.getExternalSymbol(libmName, getPointerTy(DAG.getDataLayout()));
  SDValue Chain = strictFP ? Op.getOperand(0) : DAG.getEntryNode();

  TargetLowering::CallLoweringInfo CLI(DAG);
  CLI.setDebugLoc(dl).setChain(Chain).setCallee(CallingConv::C, vecType, ExtSym,
                                                std::move(Args));
  std::pair<SDValue, SDValue> CallResult = LowerCallTo(CLI);
  return DAG.getMergeValues({CallResult.first, CallResult.second}, dl);
}

SDValue ColossusTargetLowering::LowerFABSorFCOPYSIGN(SDValue Op,
                                               SelectionDAG &DAG) const {
  assert(Op.getOpcode() == ISD::FABS ||
         Op.getOpcode() == ISD::FCOPYSIGN);
  EVT VT = Op.getValueType();
  SDLoc dl(Op);

  SDValue Op0 = Op.getOperand(0);
  SDValue Op1 = (Op.getNumOperands() > 1) ? Op.getOperand(1) : SDValue();

  // Lower f16 via v2f16
  if (VT == MVT::f16) {
    SDValue lhs = DAG.getNode(ISD::BUILD_VECTOR, dl, MVT::v2f16, Op0,
                              DAG.getUNDEF(MVT::f16));
    SDValue vec = (Op.getOpcode() == ISD::FABS)
                      ? DAG.getNode(ISD::FABS, dl, MVT::v2f16, lhs)
                      : DAG.getNode(ISD::FCOPYSIGN, dl, MVT::v2f16, lhs,
                                    DAG.getNode(ISD::BUILD_VECTOR, dl,
                                                MVT::v2f16, Op1, Op1));

    SDValue lowered = LowerFABSorFCOPYSIGN(vec, DAG);
    return DAG.getNode(ISD::EXTRACT_VECTOR_ELT, dl, MVT::f16, lowered,
                       DAG.getConstant(0, dl, MVT::i32));
  }

  // Lower fabs by (fabs x) => (fcopysign x 0)
  if (Op.getOpcode() == ISD::FABS) {
    SDValue zero32 = DAG.getConstant(0, dl, MVT::i32);
    SDValue zero = DAG.getBitcast(
        VT, VT.getSizeInBits() == 32
                ? zero32
                : DAG.getSplatBuildVector(MVT::v2i32, dl, zero32));
    return LowerFABSorFCOPYSIGN(DAG.getNode(ISD::FCOPYSIGN, dl, VT, Op0, zero),
                                DAG);
  }

  assert((Op.getOpcode() == ISD::FCOPYSIGN) && (VT != MVT::f16));
  bool homogenous = (Op0.getValueType() == VT) && (Op1.getValueType() == VT);
  if (!homogenous) {
    report_fatal_error("Unhandled type in FCOPYSIGN");
  }

  SDValue f32Bitmask = DAG.getConstant(1u << 31u, dl, MVT::i32);
  SDValue f16Bitmask = DAG.getConstant((1u << 31u) | (1u << 15u), dl, MVT::i32);

  SDValue bitmask;
  if (VT == MVT::f32) {
    bitmask = f32Bitmask;
  } else if (VT == MVT::v2f16) {
    bitmask = f16Bitmask;
  } else if (VT == MVT::v2f32) {
    bitmask =
        DAG.getNode(ISD::BUILD_VECTOR, dl, MVT::v2i32, f32Bitmask, f32Bitmask);
  } else if (VT == MVT::v4f16) {
    bitmask =
        DAG.getNode(ISD::BUILD_VECTOR, dl, MVT::v2i32, f16Bitmask, f16Bitmask);
  } else {
    report_fatal_error("Unhandled type in FCOPYSIGN");
  }
  // Convert the integer (vector) to the appropriate floating point type
  bitmask = DAG.getBitcast(VT, bitmask);
  SDValue signBits = DAG.getNode(ColossusISD::FAND, dl, VT, Op1, bitmask);
  SDValue otherBits = DAG.getNode(ColossusISD::ANDC, dl, VT, Op0, bitmask);
  return DAG.getNode(ColossusISD::FOR, dl, VT, signBits, otherBits);
}

SDValue ColossusTargetLowering::LowerSMINorSMAX(SDValue Op,
                                                SelectionDAG &DAG) const {
  auto const opcode = Op.getOpcode();

  assert(getOperationAction(opcode, MVT::i32) == Legal);
  assert(Op.getNumOperands() > 0);

  auto const dl = SDLoc{Op};
  auto const VT = Op.getValueType();

  assert(VT == MVT::v2i16 || VT == MVT::v4i16);

  auto extractElem = [&](SDValue vec, SDValue index) {
    auto elemTy = DAG.getValueType(MVT::i16);
    auto elem = DAG.getNode(ISD::EXTRACT_VECTOR_ELT, dl, MVT::i32, vec, index);
    return DAG.getNode(ISD::SIGN_EXTEND_INREG, dl, MVT::i32, elem, elemTy);
  };

  // Iterate over vector elements.
  auto operations = SmallVector<SDValue, 2u>{};
  auto const elemCount = VT.getVectorNumElements();

  for (auto i = 0u; i < elemCount; ++i) {
    auto index = DAG.getConstant(i, dl, MVT::i32);
    auto lhs = extractElem(Op.getOperand(0), index);
    auto rhs = extractElem(Op.getOperand(1), index);
    operations.push_back(DAG.getNode(opcode, dl, MVT::i32, lhs, rhs));
  }

  return DAG.getBuildVector(VT, dl, operations);
}

//===----------------------------------------------------------------------===//
//                      Calling convention implementation
//===----------------------------------------------------------------------===//

#include "ColossusGenCallingConv.inc"

//===----------------------------------------------------------------------===//
//                            Call implementation
//===----------------------------------------------------------------------===//

SDValue ColossusTargetLowering::
LowerCall(TargetLowering::CallLoweringInfo &CLI,
          SmallVectorImpl<SDValue> &InVals) const {
  SelectionDAG &DAG                     = CLI.DAG;
  SDLoc &dl                             = CLI.DL;
  SmallVectorImpl<ISD::OutputArg> &Outs = CLI.Outs;
  SmallVectorImpl<SDValue> &OutVals     = CLI.OutVals;
  SmallVectorImpl<ISD::InputArg> &Ins   = CLI.Ins;
  SDValue Chain                         = CLI.Chain;
  SDValue Callee                        = CLI.Callee;
  bool &isTailCall                      = CLI.IsTailCall;
  CallingConv::ID CallConv              = CLI.CallConv;
  bool isVarArg                         = CLI.IsVarArg;

  MachineFunction &MF = DAG.getMachineFunction();
  MF.getInfo<ColossusFunctionInfo>()->setHasCall();

  LLVM_DEBUG(dbgs() << "LowerCall for " << MF.getName() << '\n');

  if (const CallBase *CB = CLI.CB) {
    if (const Function *CalleeFn = CB->getCalledFunction()) {

      // Check for unsupported function calls.
      static auto const funcNameRx = std::regex("^_Z(n[wa]|d[la])");
      if (std::regex_search(CalleeFn->getName().str(), funcNameRx)) {
        report_fatal_error(Twine("Call to unsupported function '") +
                               llvm::demangle(CalleeFn->getName().str()) +
                               "' found in '" +
                               llvm::demangle(MF.getName().str()) + "'.",
                           false);
      }

      // Make sure that the target mode of function called is the same as the
      // caller. This check is only for direct function calls.
      const auto *CalleeST = static_cast<const ColossusSubtarget *>(
          getTargetMachine().getSubtargetImpl(*CalleeFn));
      const auto &CallerST = MF.getSubtarget<ColossusSubtarget>();

      auto hasCorrectExecutionContexts = [&]() -> bool {
        // Anything goes if context target doesn't require verification.
        if (!EnableTargetModeChecks)
          return true;

        // If caller and callee have the same execution mode, allow the call.
        if (CalleeST->isSameExecutionMode(CallerST))
          return true;

        // If either caller or callee has "both" mode enabled, allow the call.
        if (CalleeST->isBothMode() || CallerST.isBothMode())
          return true;

        // Return false for all other cases.
        return false;
      };

      // InstCombine transforms some printf formats into puts and putchar. In
      // these cases no execution context is added as InstCombine is target
      // independent but as these are defined as "both" in runtime it should be
      // fine to ignore these cases.
      std::array<StringRef, 2> ignoreCallCtxFor = {"puts", "putchar"};
      bool canBeIgnored = std::any_of(
          ignoreCallCtxFor.begin(), ignoreCallCtxFor.end(),
          [&CalleeFn](StringRef &S) { return S.equals(CalleeFn->getName()); });

      // Either the validation step can be ignored or we have to check for it.
      if (!canBeIgnored && !hasCorrectExecutionContexts())
        report_fatal_error(
            "in function '" + Twine(MF.getName()) + "': called "
            + CalleeST->getExecutionModeName() + " function '"
            + Twine(CalleeFn->getName()) + "' must have "
            "__attribute__((target(\"" + Twine(CallerST.getExecutionModeName())
            + "\")))");
    }
  }

  // Colossus target does not yet support tail call optimization.
  isTailCall = false;

  // Indirect calls need to be dealt with separately.
  bool isIndirectCall = false;

  // Analyze operands of the call, assigning locations to each operand.
  SmallVector<CCValAssign, 16> ArgLocs;
  CCState CCInfo(CallConv, isVarArg, MF, ArgLocs, *DAG.getContext());
  CCInfo.AnalyzeCallOperands(Outs, CC_Colossus);

  // Create local copies for byval args.
  SmallVector<SDValue, 4> ByValArgs;
  for (unsigned I = 0,  E = Outs.size(); I != E; ++I) {
    ISD::ArgFlagsTy Flags = Outs[I].Flags;
    if (!Flags.isByVal()) {
      continue;
    }

    SDValue Arg = OutVals[I];
    unsigned Size = Flags.getByValSize();
    Align Alignment = Flags.getNonZeroByValAlign();

    // Allocate a stack object for the copy.
    MachineFrameInfo &MFI = MF.getFrameInfo();
    int FrameIndex = MFI.CreateStackObject(Size, Alignment, false);

    // Create a memcpy of the copy.
    SDValue FIN = DAG.getFrameIndex(FrameIndex, MVT::i32);
    SDValue SizeNode = DAG.getConstant(Size, dl, MVT::i32);
    Chain =
        DAG.getMemcpy(Chain, dl, FIN, Arg, SizeNode, Alignment, false, false,
                      isTailCall, MachinePointerInfo(), MachinePointerInfo());
    LLVM_DEBUG(dbgs() << "  > Local space allocated for byval arg " << I
                      << " at frame index " << FrameIndex << '\n');
    ByValArgs.push_back(FIN);
  }

  // Get the size of the outgoing arguments stack space requirement.
  const unsigned NumBytes = CCInfo.getNextStackOffset();

  Chain = DAG.getCALLSEQ_START(Chain, NumBytes, 0, dl);

  SmallVector<std::pair<unsigned, SDValue>, 8> RegsToPass;
  SmallVector<SDValue, 8> MemOpChains;

  // Walk the register/memloc assignments, inserting copies/loads.
  for (unsigned I = 0, ByvalArgIdx = 0, E = ArgLocs.size(); I != E; ++I) {
    CCValAssign &VA = ArgLocs[I];
    SDValue Arg = OutVals[I];

    // Use local copy if it is a byval arg.
    ISD::ArgFlagsTy Flags = Outs[I].Flags;
    if (Flags.isByVal()) {
      Arg = ByValArgs[ByvalArgIdx++];
    }

    if (VA.isRegLoc()) {
      // Argument passed in a register.
      RegsToPass.push_back(std::make_pair(VA.getLocReg(), Arg));
      LLVM_DEBUG(dbgs() << "  > Argument " << I << " passed via "
                        << ColossusRegisterInfo::getRegisterName(VA.getLocReg())
                        << '\n');
    } else if (VA.isMemLoc()) {
      // Argument passed on the stack, always relative to the stack pointer.
      unsigned Offset = VA.getLocMemOffset();
      SDValue StackPtr =
          DAG.getRegister(ColossusRegisterInfo::getStackRegister(), MVT::i32);
      SDValue PtrOff = DAG.getIntPtrConstant(Offset, dl);
      PtrOff = DAG.getNode(ISD::ADD, dl, MVT::i32, StackPtr, PtrOff);
      // Create the store from virtual register SDNode.
      // Avoid f16 store. Nesting call sequences is unsupported.
      SDValue toStore =
          (Arg.getValueType() == MVT::f16)
              ? DAG.getNode(ColossusISD::F16ASV2F16, dl, MVT::v2f16, Arg)
              : Arg;
      SDValue Store = DAG.getStore(Chain, dl, toStore, PtrOff,
                                   MachinePointerInfo());
      MemOpChains.push_back(Store);
      LLVM_DEBUG(dbgs() << "  > Argument " << I << " passed via SP["
                        << (Offset / 4) << "]\n");
    } else {
      assert(0 && "Can only pass arguments via registers or the stack");
    }
  }

  // Make sure all stores occur before the call.
  if (!MemOpChains.empty()) {
    Chain = DAG.getNode(ISD::TokenFactor, dl, MVT::Other, MemOpChains);
  }

  // Build a sequence of copy-to-reg nodes chained together with token chain
  // and flag operands which copy the outgoing args into the appropriate regs.
  // The InGlue parameter is necessary since all emitted instructions must be
  // stuck together.
  SDValue Glue;
  for (auto &Reg : RegsToPass) {
    Chain = DAG.getCopyToReg(Chain, dl, Reg.first, Reg.second, Glue);
    Glue = Chain.getValue(1);
  }

  if (GlobalAddressSDNode *G = dyn_cast<GlobalAddressSDNode>(Callee)) {
    // If the callee is a GlobalAddress node (every direct call is) turn it
    // into a TargetGlobalAddress node so that legalize doesn't hack it.
    Callee = DAG.getTargetGlobalAddress(G->getGlobal(), dl, MVT::i32);
  } else if (ExternalSymbolSDNode *E = dyn_cast<ExternalSymbolSDNode>(Callee)) {
    // Likewise ExternalSymbol -> TargetExternalSymbol.
    Callee = DAG.getTargetExternalSymbol(E->getSymbol(), MVT::i32);
  } else {
    // Indirect call.
    isIndirectCall = true;
  }

  // Create ColossusISD::Call/ICALL, returns a chain and glue.
  const TargetRegisterInfo *TRI = Subtarget.getRegisterInfo();
  const uint32_t *Mask = TRI->getCallPreservedMask(MF, CallConv);
  assert(Mask && "Missing call preserved mask for calling convention");
  SDVTList NodeTys = DAG.getVTList(MVT::Other, MVT::Glue);

  if (isIndirectCall) {
    // For an indirect call, lower it to a SETLR followed by the CALL. This is
    // matched to a SETZI to set the link register to the address after the
    // call, and a BR to perform the call via a register.

    // Create a label symbol.
    const TargetLowering &TLI = DAG.getTargetLoweringInfo();
    MVT PtrVT = TLI.getPointerTy(DAG.getDataLayout());
    MCSymbol *Sym = MF.getContext().createTempSymbol();
    SDValue LinkLabel = DAG.getMCSymbol(Sym, PtrVT);

    // SETLR
    SmallVector<SDValue, 3> Ops1;
    Ops1.push_back(Chain);
    Ops1.push_back(LinkLabel);
    if (Glue.getNode()) {
      Ops1.push_back(Glue);
    }
    Chain = DAG.getNode(ColossusISD::SETLR, dl, NodeTys, Ops1);
    Glue = Chain.getValue(1);

    // ICALL
    SmallVector<SDValue, 8> Ops2;
    Ops2.push_back(Chain);
    Ops2.push_back(LinkLabel);
    Ops2.push_back(Callee);

    // Add argument registers to Ops so that they are known live into the call.
    for (auto &Reg : RegsToPass) {
      Ops2.push_back(DAG.getRegister(Reg.first, Reg.second.getValueType()));
    }

    // Add a register mask operand representing the call-preserved registers.
    Ops2.push_back(DAG.getRegisterMask(Mask));

    Ops2.push_back(Glue);
    Chain = DAG.getNode(ColossusISD::ICALL, dl, NodeTys, Ops2);
  } else {
    // ColossusISD::CALL/ICALL node types and ops.
    SmallVector<SDValue, 8> Ops;
    Ops.push_back(Chain);
    Ops.push_back(Callee);

    // Add argument registers to Ops so that they are known live into the call.
    for (auto &Reg : RegsToPass) {
      Ops.push_back(DAG.getRegister(Reg.first, Reg.second.getValueType()));
    }

    // Add a register mask operand representing the call-preserved registers.
    Ops.push_back(DAG.getRegisterMask(Mask));

    if (Glue.getNode()) {
      Ops.push_back(Glue);
    }
    Chain = DAG.getNode(ColossusISD::CALL, dl, NodeTys, Ops);
  }
  Glue = Chain.getValue(1);

  // Create the CALLSEQ_END node.
  SDValue Op1 = DAG.getIntPtrConstant(NumBytes, dl, true);
  SDValue Op2 = DAG.getIntPtrConstant(0, dl, true);
  Chain = DAG.getCALLSEQ_END(Chain, Op1, Op2, Glue, dl);
  Glue = Chain.getValue(1);

  // Assign locations to each value returned by this call.
  SmallVector<CCValAssign, 16> RVLocs;
  CCState RVInfo(CallConv, isVarArg, DAG.getMachineFunction(), RVLocs,
                 *DAG.getContext());

  RVInfo.AnalyzeCallResult(Ins, RetCC_Colossus);

  // Copy all of the result registers out of their specified physreg.
  for (auto &Loc : RVLocs) {
    Chain = DAG.getCopyFromReg(Chain, dl, Loc.getLocReg(), Loc.getValVT(),
                               Glue).getValue(1);
    Glue = Chain.getValue(2);
    InVals.push_back(Chain.getValue(0));
  }

  return Chain;
}

//===----------------------------------------------------------------------===//
//             Formal arguments calling convention implementation
//===----------------------------------------------------------------------===//

/// This helper function adds the specified physical register to the
/// MachineFunction as a live in value.  It also creates a corresponding
/// virtual register for it.
static unsigned addLiveIn(MachineRegisterInfo &RegInfo,
                          const TargetRegisterClass *RC,
                          unsigned PReg) {
  unsigned VReg = RegInfo.createVirtualRegister(RC);
  RegInfo.addLiveIn(PReg, VReg);
  return VReg;
}

SDValue ColossusTargetLowering::
LowerFormalArguments(SDValue Chain,
                     CallingConv::ID CallConv,
                     bool isVarArg,
                     const SmallVectorImpl<ISD::InputArg> &Ins,
                     const SDLoc &dl,
                     SelectionDAG &DAG,
                     SmallVectorImpl<SDValue> &InVals) const {
  MachineFunction &MF = DAG.getMachineFunction();
  MachineFrameInfo &MFI = MF.getFrameInfo();
  MachineRegisterInfo &RegInfo = MF.getRegInfo();

  LLVM_DEBUG(dbgs() << "LowerFormalArguments for " << MF.getName() << '\n');

  // Assign locations to all of the incoming arguments.
  SmallVector<CCValAssign, 16> ArgLocs;
  CCState CCInfo(CallConv, isVarArg, MF, ArgLocs, *DAG.getContext());

  if (CCInfo.getCallingConv() == CallingConv::Colossus_Vertex) {
    if (!Ins.empty()) {
      report_fatal_error("Unexpected argument to vertex function");
    }
    LLVM_DEBUG(dbgs() << "End of LowerFormalArguments\n");
    return Chain;
  }

  CCInfo.AnalyzeFormalArguments(Ins, CC_Colossus);

  SmallVector<SDValue, 4> MemOps;

  // For each argument location.
  for (auto &VA : ArgLocs) {
    // CopyFromReg or load argument registers.
    if (VA.isRegLoc()) {
      // Transform arguments passed in physical registers into virtual ones.
      EVT RegVT = VA.getLocVT();
      unsigned VReg;
      if (RegVT.isInteger() &&
          RegVT.getStoreSize() == 4) {
        VReg = addLiveIn(RegInfo, &Colossus::MRRegClass, VA.getLocReg());
      } else if (RegVT.isInteger() &&
                 RegVT.getStoreSize() == 8) {
        VReg = addLiveIn(RegInfo, &Colossus::MRPairRegClass, VA.getLocReg());
      } else if (RegVT.isFloatingPoint() &&
                 RegVT.getStoreSize() <= 4) {
        VReg = addLiveIn(RegInfo, &Colossus::ARRegClass, VA.getLocReg());
      } else if (RegVT.isFloatingPoint() &&
                 RegVT.getStoreSize() == 8) {
        VReg = addLiveIn(RegInfo, &Colossus::ARPairRegClass, VA.getLocReg());
      } else {
        report_fatal_error("Unexpected register EVT");
      }
      // Create copy from reg to virtual register SDNode.
      SDValue ArgIn = DAG.getCopyFromReg(Chain, dl, VReg, RegVT);
      InVals.push_back(ArgIn);
      LLVM_DEBUG(dbgs() << "  Formal passed via "
                        << ColossusRegisterInfo::getRegisterName(VA.getLocReg())
                        << '\n');
    } else if (VA.isMemLoc()) {
      // Load arguments passed on the stack into virtual registers.
      EVT MemVT = VA.getValVT();
      const TargetRegisterClass *RC;
      if (MemVT.isInteger() &&
          MemVT.getStoreSize() == 4) {
        RC = &Colossus::MRRegClass;
      } else if (MemVT.isInteger() &&
                 MemVT.getStoreSize() == 8) {
        RC = &Colossus::MRPairRegClass;
      } else if (MemVT.isFloatingPoint() &&
                 MemVT.getStoreSize() <= 4) {
        RC = &Colossus::ARRegClass;
      } else if (MemVT.isFloatingPoint() &&
                 MemVT.getStoreSize() == 8) {
        RC = &Colossus::ARPairRegClass;
      } else {
        report_fatal_error("Unexpected memory EVT");
      }
      // Create the frame index object for this incoming parameter.
      const unsigned Offset = VA.getLocMemOffset();
      const TargetRegisterInfo *TRI = MF.getSubtarget().getRegisterInfo();
      const int FI =
          MFI.CreateFixedObject(TRI->getSpillSize(*RC), Offset, true);
      // Create the load to virtual register SDNode.
      SDValue FIN = DAG.getFrameIndex(FI, MVT::i32);
      SDValue ArgIn = DAG.getLoad(VA.getValVT(), dl, Chain, FIN,
                                  MachinePointerInfo::getFixedStack(MF, FI));
      InVals.push_back(ArgIn);
      LLVM_DEBUG(dbgs() << "  Formal loaded via SP[" << (Offset / 4) << "]\n");
    } else {
      assert(0 && "Can only pass arguments via registers or the stack");
    }
  }

  // Variadic argument(s).
  //                       |                      |  Callee frame
  //                       +======================+
  //  VarArgsFrameIndex -> | Caller outgoing args |  Caller frame
  //                       | var args...          |
  //                       +----------------------+
  //                       |                      |
  if (isVarArg) {
    const TargetRegisterClass *RC = &Colossus::MRRegClass;
    const TargetRegisterInfo *TRI = MF.getSubtarget().getRegisterInfo();
    ColossusFunctionInfo *CFI = MF.getInfo<ColossusFunctionInfo>();
    int Offset = CCInfo.getNextStackOffset();
    int FrameIndex =
        MFI.CreateFixedObject(TRI->getSpillSize(*RC), Offset, true);
    CFI->setVarArgsFrameIndex(FrameIndex);
    LLVM_DEBUG(dbgs() << "  VA args stored at frame index " << FrameIndex
                      << " at offset " << Offset << '\n');
  }

  LLVM_DEBUG(dbgs() << "End of LowerFormalArguments\n");
  return Chain;
}

//===----------------------------------------------------------------------===//
//               Return value calling convention implementation
//===----------------------------------------------------------------------===//

bool ColossusTargetLowering::
CanLowerReturn(CallingConv::ID CallConv,
               MachineFunction &MF,
               bool isVarArg,
               const SmallVectorImpl<ISD::OutputArg> &Outs,
               LLVMContext &Context) const {
  SmallVector<CCValAssign, 16> RVLocs;
  CCState CCInfo(CallConv, isVarArg, MF, RVLocs, Context);
  if (CCInfo.getCallingConv() == CallingConv::Colossus_Vertex) {
    return CCInfo.CheckReturn(Outs, RetCC_Colossus_Vertex);
  }
  return CCInfo.CheckReturn(Outs, RetCC_Colossus);
}

SDValue ColossusTargetLowering::
LowerReturn(SDValue Chain,
            CallingConv::ID CallConv,
            bool isVarArg,
            const SmallVectorImpl<ISD::OutputArg> &Outs,
            const SmallVectorImpl<SDValue> &OutVals,
            const SDLoc &dl,
            SelectionDAG &DAG) const {
  MachineFunction &MF = DAG.getMachineFunction();

  // CCValAssign - represent the assignment of the return value to a location.
  SmallVector<CCValAssign, 16> RVLocs;

  // CCState - info about the registers and stack slot.
  CCState CCInfo(CallConv, isVarArg, MF, RVLocs, *DAG.getContext());

  SDValue Glue;

  // Vertex functions
  if (CCInfo.getCallingConv() == CallingConv::Colossus_Vertex) {
    CCInfo.AnalyzeReturn(Outs, RetCC_Colossus_Vertex);
    if(RVLocs.size() == 0) {
      return DAG.getNode(ColossusISD::VERTEX_EXIT, dl, MVT::Other,
                         Chain, DAG.getConstant(1, dl, MVT::i32));
    } else if(RVLocs.size() == 1) {
      assert(RVLocs[0].isRegLoc() &&
             "Vertex functions return must be in register");
      return DAG.getNode(ColossusISD::VERTEX_EXIT, dl, MVT::Other, Chain,
                         OutVals[0]);
    } else {
      report_fatal_error("Vertex fns cannot return in multiple locations.");
      return SDValue();
    }
  }

  CCInfo.AnalyzeReturn(Outs, RetCC_Colossus);

  SmallVector<SDValue, 4> RetOps(1, Chain);

  // Copy the result values into the output registers.
  for (unsigned i = 0, e = RVLocs.size(); i < e; ++i) {
    CCValAssign &VA = RVLocs[i];
    assert(VA.isRegLoc() && "Can only return in registers");

    // Copy the result values into the output registers.
    Chain = DAG.getCopyToReg(Chain, dl, VA.getLocReg(), OutVals[i], Glue);

    // Guarantee that all emitted copies are stuck together.
    Glue = Chain.getValue(1);
    RetOps.push_back(DAG.getRegister(VA.getLocReg(), VA.getLocVT()));
  }

  // Add the flag if we have it.
  if (Glue.getNode()) {
    RetOps.push_back(Glue);
  }

  // Create a RTN, chaining it with the register accesses above.
  RetOps[0] = DAG.getNode(ColossusISD::RTN, dl, MVT::Other, Chain);

  // Create a RTN_REG_HOLDER instruction, which holds the implict register
  // uses implied by the chaining of the registers above. This is done so that
  // false read-after-write dependencies are not created between a RTN and a
  // preceding instruction that defines one of the return registers.
  return DAG.getNode(ColossusISD::RTN_REG_HOLDER, dl, MVT::Other, RetOps);
}

//===----------------------------------------------------------------------===//
// Inline asm support
//===----------------------------------------------------------------------===//

// Parse an "{$[am][0-9]+}" or "{$[am][0-9]+:[0-9]+}" register constraint.
// maps 0-based register numbers to LLVM register numbers.
static std::pair<unsigned, const TargetRegisterClass *>
parseRegisterNumber(StringRef Constraint) {
  const char *fail = "Invalid register constraint";

  bool mrf = Constraint[2] == 'm';
  bool arf = Constraint[2] == 'a';
  if (!(mrf || arf)) {
    report_fatal_error(fail);
  }

  size_t colon = Constraint.find_first_of(':');

  if (colon == StringRef::npos) {
    auto *RC = mrf ? &Colossus::MRRegClass : &Colossus::ARRegClass;

    unsigned Value;
    bool Failed =
        Constraint.slice(3, Constraint.size() - 1).getAsInteger(10, Value);
    if (!Failed && Value < RC->getNumRegs()) {
      return std::make_pair(RC->getRegister(Value), RC);
    }
  } else {
    unsigned before, after;
    bool beforeFailed = Constraint.slice(3, colon).getAsInteger(10, before);
    bool afterFailed = Constraint.slice(colon + 1, Constraint.size() - 1)
                           .getAsInteger(10, after);
    if (beforeFailed || afterFailed) {
      report_fatal_error(fail);
    }

    if ((before % 2 == 0) && (before + 1 == after)) {
      auto *RC = mrf ? &Colossus::MRPairRegClass : &Colossus::ARPairRegClass;

      unsigned Value = before / 2;
      if (Value < RC->getNumRegs()) {
        return std::make_pair(RC->getRegister(Value), RC);
      }
    }

    if ((before % 4 == 0) && (before + 3 == after) && arf) {
      auto *RC = &Colossus::ARQuadRegClass;
      unsigned Value = before / 4;
      if (Value < RC->getNumRegs()) {
        return std::make_pair(RC->getRegister(Value), RC);
      }
    }
  }

  report_fatal_error(fail);
}

std::pair<unsigned, const TargetRegisterClass*> ColossusTargetLowering::
getRegForInlineAsmConstraint(const TargetRegisterInfo *TRI,
                             StringRef Constraint,
                             MVT VT) const {
  if (Constraint.size() == 1) {
    switch (Constraint[0]) {
    default : break;
    // Single letter 'r' constaint code.
    case 'r':
      if (VT.isInteger() &&
          VT.getStoreSize() <= 4) {
        return std::make_pair(0U, &Colossus::MRRegClass);
      } else if (VT.isFloatingPoint() &&
                 VT.getStoreSize() <= 4) {
        return std::make_pair(0U, &Colossus::ARRegClass);
      } else if (VT.isInteger() &&
                 VT.is64BitVector()) {
        return std::make_pair(0U, &Colossus::MRPairRegClass);
      } else if (VT.isFloatingPoint() &&
                 VT.is64BitVector()) {
        return std::make_pair(0U, &Colossus::ARPairRegClass);
      } else {
       // 128 bit vector types are also unsupported
       report_fatal_error("Unsupported inline asm reg type");
      }
    }
  }
  if (Constraint.size() > 0 &&
      Constraint[0] == '{' &&
      Constraint[1] == '$' &&
      Constraint[Constraint.size()-1] == '}') {
    // Handle specific register constraints, e.g. '{$m3}'. This overrides the
    // default parsing of registers, by getRegForInlineAsmConstraint (below),
    // because the interpretation depends on the value type and uses the
    // internal LLVM register names, rather than the external asm ones.
    return parseRegisterNumber(Constraint);
  }
  // Use the default implementation in TargetLowering to convert the register
  // constraint into a member of a register class.
  return TargetLowering::getRegForInlineAsmConstraint(TRI, Constraint, VT);
}

