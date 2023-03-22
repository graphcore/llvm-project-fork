//===-- ColossusTargetTransformInfo.h - Colossus specific TTI ---*- C++ -*-===//
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
/// \file
/// This file a TargetTransformInfo::Concept conforming object specific to the
/// Colossus target machine. It uses the target's detailed information to
/// provide more precise answers to certain TTI queries, while letting the
/// target independent and default TTI implementations handle the rest.
///
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_COLOSSUS_COLOSSUSTARGETTRANSFORMINFO_H
#define LLVM_LIB_TARGET_COLOSSUS_COLOSSUSTARGETTRANSFORMINFO_H

#include "Colossus.h"
#include "ColossusCountedLoopOptions.h"
#include "ColossusTargetMachine.h"
#include "llvm/Analysis/AssumptionCache.h"
#include "llvm/Analysis/TargetTransformInfo.h"
#include "llvm/Analysis/ValueTracking.h"
#include "llvm/CodeGen/BasicTTIImpl.h"
#include "llvm/CodeGen/TargetLowering.h"
#include "llvm/Support/KnownBits.h"

namespace llvm {

class ColossusTTIImpl : public BasicTTIImplBase<ColossusTTIImpl> {
  typedef BasicTTIImplBase<ColossusTTIImpl> BaseT;
  typedef TargetTransformInfo TTI;
  friend BaseT;

  const ColossusSubtarget *ST;
  const ColossusTargetLowering *TLI;
  const ColossusTargetMachine *TM;

  const ColossusSubtarget *getST() const { return ST; }
  const ColossusTargetLowering *getTLI() const { return TLI; }

public:
  explicit ColossusTTIImpl(const ColossusTargetMachine *TM, const Function &F)
      : BaseT(TM, F.getParent()->getDataLayout()), ST(TM->getSubtargetImpl(F)),
        TLI(ST->getTargetLowering()), TM(TM) {}

  // Provide value semantics. MSVC requires that we spell all of these out.
  ColossusTTIImpl(const ColossusTTIImpl &Arg)
      : BaseT(static_cast<const BaseT &>(Arg)), ST(Arg.ST), TLI(Arg.TLI),
        TM(Arg.TM) {}
  ColossusTTIImpl(ColossusTTIImpl &&Arg)
      : BaseT(std::move(static_cast<BaseT &>(Arg))), ST(std::move(Arg.ST)),
        TLI(std::move(Arg.TLI)), TM(std::move(Arg.TM)) {}

  TypeSize getRegisterBitWidth(bool Vector) const {
    if (Vector) {
      return TypeSize::getFixed(64);
    }
    return TypeSize::getFixed(32);
  }

  // Technically, 128 bit loads are also possible for floats but for now
  // only support 64 bits.
  unsigned getLoadStoreVecRegBitWidth(unsigned AddrSpace) const {
    return 64;
  }

  // Allow misaligned vectorized loads and stores for Colossus.
  bool allowsMisalignedMemoryAccesses(LLVMContext &Context, unsigned BitWidth,
                                      unsigned AddressSpace, Align Alignment,
                                      bool *Fast) {
    *Fast = true; // Colossus' {ld|st}64 is faster than consecutive 
                  // two {ld|st}32
    return true;
  }

  // Vectorize consecutive float loads
  bool isLegalToVectorizeLoad(LoadInst *LI) const {
    auto const type = LI->getType();
    auto const size = type->getScalarSizeInBits() / 8u;
    auto const alignment = LI->getAlign();

    return (type->isFloatTy() || type->isHalfTy()) &&
           isPowerOf2_64(alignment.value()) &&
           alignment >= size;
  }

  // Vectorize consecutive float stores
  bool isLegalToVectorizeStore(StoreInst *SI) const {
    auto const type = SI->getValueOperand()->getType();
    auto const size = type->getScalarSizeInBits() / 8u;
    auto const alignment = SI->getAlign().value();

    return (type->isFloatTy() || type->isHalfTy()) &&
           isPowerOf2_64(alignment) &&
           alignment >= size;
  }

  unsigned getMinVectorRegisterBitWidth() const { return 32; }

  unsigned getMaxInterleaveFactor(unsigned VF) const { return 1; }

  InstructionCost getIntrinsicInstrCost(const IntrinsicCostAttributes &ICA,
                                        TTI::TargetCostKind CostKind);

  InstructionCost getIntImmCost(const APInt &Imm, Type *Ty,
                                TTI::TargetCostKind CostKind);

  InstructionCost getIntImmCostInst(unsigned Opc, unsigned Idx,
                                    const APInt &Imm, Type *Ty,
                                    TTI::TargetCostKind CostKind,
                                    Instruction *Inst = nullptr);
  int getIntImmCodeSizeCost(unsigned Opc, unsigned Idx, const APInt &Imm,
                            Type *Ty);

  TTI::PopcntSupportKind getPopcntSupport(unsigned IntTyWidthInBit) {
    // Fast Colossus popcount instruction exists for MRF (i.e. 32-bit widths).
    if (IntTyWidthInBit == 32)
      return TTI::PSK_FastHardware;
    return TTI::PSK_Software;
  }

  /// Compute cost of memory operation \p Opcode in \p AddressSpace whose
  /// access is of type \p Src and with \p Alignment. If non null, \p I
  /// holds the instruction doing the access.
  InstructionCost getMemoryOpCost(unsigned Opcode, Type *Src,
                                  MaybeAlign Alignment, unsigned AddressSpace,
                                  TTI::TargetCostKind CostKind,
                                  const Instruction *I = nullptr);

  bool areInlineCompatible(const Function *Caller,
                           const Function *Callee) const;

  // Determines whether inserting hwloops is profitable, possible, and populates
  // the HWLoopInfo struct appropriately for the correct intrinsic to be
  // inserted.
  bool isHardwareLoopProfitable(Loop *L, ScalarEvolution &SE,
                                AssumptionCache &AC, TargetLibraryInfo *LibInfo,
                                HardwareLoopInfo &HWLoopInfo);

  // Colossus can save compares in case a repeat loop can be used/emitted.
  bool canSaveCmp(Loop *L, BranchInst **BI, ScalarEvolution *SE, LoopInfo *LI,
                  DominatorTree *DT, AssumptionCache *AC,
                  TargetLibraryInfo *LibInfo) const;

  enum ColossusRegisterClass { ARF, MRF, ARPair, MRPair, ARQuad };

  /// \return the number of registers in the target-provided register class.
  unsigned getNumberOfRegisters(unsigned ClassID) const {
    unsigned const ARF_GP_REGISTERS = ST->getIPUArchInfo().ARF_GP_REGISTERS;
    unsigned const MRF_GP_REGISTERS = ST->getIPUArchInfo().MRF_GP_REGISTERS;
    unsigned const NUM_RESERVED_REGISTERS = 2; // LR + SP

    switch (ClassID) {
    case MRPair:
      return (MRF_GP_REGISTERS - NUM_RESERVED_REGISTERS) / 2;
    case ARPair:
      return ARF_GP_REGISTERS / 2; // $aN:N+1
    case ARQuad:
      return ARF_GP_REGISTERS / 4; // $aN:N+3
    case ARF:
      return ARF_GP_REGISTERS;
    case MRF:
      return MRF_GP_REGISTERS - NUM_RESERVED_REGISTERS;
    default:
      llvm_unreachable("unknown register class");
      // What the function used to return as default.
      return MRF_GP_REGISTERS - NUM_RESERVED_REGISTERS;
      break;
    }
  }

  unsigned getRegisterClassForType(bool Vector, Type *Ty) const {
    // There are some conditions in which the type isn't passed through
    // So we'll conservatively assume the MRF class which will match the
    // original behaviour of getNumberOfRegisters() function.
    if (!Ty)
      return Vector ? MRPair : MRF;

    if (Ty->isFloatingPointTy()) {
      auto size = Ty->getPrimitiveSizeInBits();
      if (size > 64) {
        return ARQuad;
      }
      return size < 64 ? ARF : ARPair;
    } else {
      return Ty->getPrimitiveSizeInBits() < 64 ? MRF : MRPair;
    }
  }

  /// \return the target-provided register class name
  const char *getRegisterClassName(unsigned ClassID) const {
    switch (ClassID) {
    default:
      llvm_unreachable("unknown register class");
      return "Colossus::unknown register class";
    case ARF:
      return "Colossus::ARF";
    case MRF:
      return "Colossus::MRF";
    case ARPair:
      return "Colossus::ARPair";
    case MRPair:
      return "Colossus::MRPair";
    case ARQuad:
      return "Colossus::ARQuad";
    }
  }
};

} // end namespace llvm

#endif
