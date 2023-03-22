//===-- ColossusTargetTransformInfo.cpp - Colossus TTI implementation -----===//
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
// This file implements the ColossusTTIImpl class.
//
//===----------------------------------------------------------------------===//

#include "ColossusTargetTransformInfo.h"
#include "ColossusFunctionCheck.h"
#include "ColossusTargetInstr.h"
#include "llvm/Analysis/IVDescriptors.h"
#include "llvm/IR/InstIterator.h"
#include "llvm/Transforms/Utils/ScalarEvolutionExpander.h"

using namespace llvm;

enum ImmOperand {
  ZIMM = 0b00000001,
  IMMZ = 0b00000010,
  SIMM = 0b00000100
};

// Signed numbers below 16 bits can use add. Numbers below 20 bits can use
// `setzi`, otherwise an additional `or` is needed.
// For example:
//  For signed numbers with less than 16 bits:
//    add $mX, $m15, <imm>
//  For numbers with less less than 20 bits:
//    setzi $mX, <imm>
//  For all other numbers with less than 32 bits:
//    setzi $mX, <imm & 0xfffff>
//    or $mX, $mX, <(imm & ~0xfffff) >> 20>
//
// The function returns 2 and 3 rather than 1 and 2 to force constant hoisting
// whenever an immediate cannot be folded in an instruction because constant
// hoisting pass only host when the cost of an instruction is > TTI::TCC_Basic.
static InstructionCost getImmCost(const APInt &Imm) {
  // add <dst>, $m15, <cst>
  if (Imm.getMinSignedBits() <= 16)
    return 2;

  unsigned BitWidth =
      Imm.isNegative() ? Imm.getMinSignedBits() : Imm.getActiveBits();
  assert(BitWidth <= 32);
  return BitWidth <= 20 ? 2 : 3;
}

// Codesize cost grows 1:1 wrt runtime cost.
int ColossusTTIImpl::getIntImmCodeSizeCost(unsigned Opc, unsigned Idx,
                                           const APInt &Imm, Type *Ty) {
  return *getIntImmCostInst(Opc, Idx, Imm, Ty, TTI::TCK_CodeSize).getValue();
}

InstructionCost ColossusTTIImpl::getIntImmCost(const APInt &Imm, Type *Ty,
                                               TTI::TargetCostKind CostKind) {
  assert(Ty->isIntegerTy());
  // Immediates with value 0 are free.
  if (Imm == 0)
    return TTI::TCC_Free;

  // Lowering immediates with a bitwidth > 32 results in worse code when hoisted
  // compared to unhoisted, returning free is default behaviour and will prevent
  // hoisting.
  if (Ty->getIntegerBitWidth() > 32)
    return TTI::TCC_Free;

  return getImmCost(Imm);
}

InstructionCost ColossusTTIImpl::getIntImmCostInst(unsigned Opc, unsigned Idx,
                                                   const APInt &Imm, Type *Ty,
                                                   TTI::TargetCostKind CostKind,
                                                   Instruction *Inst) {
  assert(Ty->isIntegerTy());
  // Immediates with value 0 are free.
  if (Imm == 0)
    return TTI::TCC_Free;

  // There are no instructions that allow embedding immediates > 32 bits so
  // sticking with the default behaviour of not hoisting (by returning free).
  if (Ty->getIntegerBitWidth() > 32)
    return TTI::TCC_Free;

  unsigned ImmBitwidth;
  unsigned ImmType = 0; // Types of immediates, possible to encode.
  unsigned ArgIdx;

  switch (Opc) {
  default:
    // Default is preventing any hoisting from happening, just to be safe.
    return TTI::TCC_Free;
  case Instruction::Or:
    // Or instruction also allows tail-extended immediate.
    ImmType |= IMMZ;
    LLVM_FALLTHROUGH;
  case Instruction::And:
  case Instruction::Shl:
  case Instruction::LShr:
  case Instruction::AShr:
    ImmType |= ZIMM;
    ArgIdx = 1;
    ImmBitwidth = XshrImmBitWidth(*ST, Opc);
    break;
  case Instruction::Add:
    ImmType |= ZIMM | SIMM;
    ArgIdx = 1;
    ImmBitwidth = 16;
    break;
  case Instruction::Mul:
    ImmType |= SIMM;
    ArgIdx = 1;
    ImmBitwidth = 16;
    break;
  case Instruction::Sub:
    ImmType |= ZIMM | SIMM;
    ArgIdx = 0;
    ImmBitwidth = 16;
    break;
  }

  // The opcode isn't commutative and the immediated argument doesn't
  // correspond to a hoist-able argument, therefore prevent hoisting.
  if (!Instruction::isCommutative(Opc) && Idx != ArgIdx)
    return TTI::TCC_Free;

  unsigned ImmBits; // Number of bits required to represent the immediate.

  // Set ImmBits depending on whether an instruction is Simm only.
  if ((ImmType & SIMM) && !(ImmType & ~SIMM)) {
    ImmBits = Imm.getMinSignedBits();
  } else {
    ImmBits = Imm.isNegative() ? Imm.getMinSignedBits() : Imm.getActiveBits();
  }

  // Fits in the instruction, therefore prevent hoisting.
  if (ImmBits <= ImmBitwidth)
    return TTI::TCC_Free;

  // If instruction supports zero-tailed immediates, check whether the
  // immediate fits in the instruction.
  if (ImmType & IMMZ) {
    unsigned mask = (1u << ImmBitwidth) - 1;
    unsigned shift = 32 - ImmBitwidth;
    mask <<= shift;
    uint64_t value = Imm.getZExtValue();

    // Tail should be 32-{ImmBitwidth} bits. If these bits are all 0, the
    // immediate can be encoded within the instruction (i.e. free).
    if (!(value & ~mask))
      return TTI::TCC_Free;
  }

  // Otherwise, find materialization cost.
  return getImmCost(Imm);
}

InstructionCost
ColossusTTIImpl::getIntrinsicInstrCost(const IntrinsicCostAttributes &ICA,
                                       TTI::TargetCostKind CostKind) {
  auto RetTy = ICA.getReturnType();
  auto &Tys = ICA.getArgTypes();

  // Anything involving doubles is expensive
  // SLP doesn't handle the lowering of double to {i32, i32} correctly
  // Returning a high cost for vectors of doubles sidesteps this
  auto isDouble = [](Type *t) {
    return t->isDoubleTy() ||
           (t->isVectorTy() &&
            cast<VectorType>(t)->getElementType()->isDoubleTy());
  };
  if (isDouble(RetTy) || std::any_of(Tys.begin(), Tys.end(),
                                     [=](Type *t) { return isDouble(t); })) {

    unsigned elts =
        RetTy->isVectorTy() ? cast<FixedVectorType>(RetTy)->getNumElements() : 1;
    return 20 * elts;
  }
  return BaseT::getIntrinsicInstrCost(ICA, CostKind);
}

InstructionCost ColossusTTIImpl::getMemoryOpCost(unsigned Opcode, Type *Src,
                                                 MaybeAlign Alignment,
                                                 unsigned AddressSpace,
                                                 TTI::TargetCostKind CostKind,
                                                 const Instruction *I) {
  assert(!Src->isVoidTy() && "Invalid type");
  // Assume types, such as structs, are expensive.
  EVT VT = getTLI()->getValueType(DL, Src, true);
  if (VT == MVT::Other)
    return 4;
  std::pair<InstructionCost, MVT> LT =
      getTLI()->getTypeLegalizationCost(DL, Src);

  // Assuming that all loads of legal types cost 1.
  InstructionCost Cost = LT.first;

  // 64-bit integer memory operations are implemented with two 32-bit integer
  // memory operations.
  if (VT.isInteger() && VT.getSizeInBits().getKnownMinSize() == 64)
    Cost *= 2;
  if (CostKind != TTI::TCK_RecipThroughput)
    return Cost;

  if (Src->isVectorTy() &&
      Src->getPrimitiveSizeInBits() < LT.second.getSizeInBits()) {
    // This is a vector load that legalizes to a larger type than the vector
    // itself. Unless the corresponding extending load or truncating store is
    // legal, then this will scalarize.
    TargetLowering::LegalizeAction LA = TargetLowering::Expand;
    EVT MemVT = getTLI()->getValueType(DL, Src);
    if (Opcode == Instruction::Store)
      LA = getTLI()->getTruncStoreAction(LT.second, MemVT);
    else
      LA = getTLI()->getLoadExtAction(ISD::EXTLOAD, LT.second, MemVT);

    if (LA != TargetLowering::Legal && LA != TargetLowering::Custom) {
      // This is a vector load/store for some illegal type that is scalarized.
      // We must account for the cost of building or decomposing the vector.
      Cost += getScalarizationOverhead(cast<VectorType>(Src),
                                       Opcode != Instruction::Store,
                                       Opcode == Instruction::Store);
    }
  }

  return Cost;
}

// Overload base implementation that checks the target features match.
// In some cases there might be a mismatch of supervisor/worker specified
// target attribute (__attribute__((target("Supervisor")))).
// Where possible we want to allow inlining.
// We must check that we do not inline code that uses float types into
// a caller that is targeting supervisor or both execution mode.
bool ColossusTTIImpl::areInlineCompatible(const Function *Caller,
                                          const Function *Callee) const {
  const TargetMachine &TM = getTLI()->getTargetMachine();

  const auto *CallerST =
      static_cast<const ColossusSubtarget *>(TM.getSubtargetImpl(*Caller));
  const auto *CalleeST =
      static_cast<const ColossusSubtarget *>(TM.getSubtargetImpl(*Callee));

  if (CallerST->isWorkerMode())
    return true;

  return CalleeST->isWorkerMode()
             ? !llvm::colossus::functionContainsFloatType(*Callee)
             : true;
}

bool ColossusTTIImpl::isHardwareLoopProfitable(Loop *L, ScalarEvolution &SE,
                                               AssumptionCache &AC,
                                               TargetLibraryInfo *LibInfo,
                                               HardwareLoopInfo &HWLoopInfo) {

  LLVMContext &C = L->getHeader()->getContext();
  auto i32 = Type::getInt32Ty(C);
  auto i64 = Type::getInt64Ty(C);

  // Convert the SCEV to Value* to then use computeKnownBits on.
  SCEVExpander Rewriter(SE, SE.getDataLayout(), "hwloop");

  auto emitRptHwLoop = [&HWLoopInfo, &i32, &i64](unsigned bitwidth) {
    HWLoopInfo.IsNestingLegal = true;
    HWLoopInfo.CounterInReg = false;
    HWLoopInfo.CountType = bitwidth == 64 ? i64 : i32;
    HWLoopInfo.LoopDecrement = ConstantInt::get(HWLoopInfo.CountType, 1);
    HWLoopInfo.PerformEntryTest = true; // Generate loop guard intr.
  };

  auto emitBrnzdecHwLoop = [&HWLoopInfo,&i32,&i64](unsigned bitwidth) {
    HWLoopInfo.IsNestingLegal = true;
    HWLoopInfo.CounterInReg = true;
    HWLoopInfo.CountType = bitwidth == 64 ? i64 : i32;
    HWLoopInfo.LoopDecrement = ConstantInt::get(HWLoopInfo.CountType, 1);
  };

  if (!Colossus::CountedLoop::EnableIR)
    return false;

  const unsigned long long IpuTripCount =
      ST->getIPUArchInfo().CSR_W_REPEAT_COUNT__VALUE__MASK;
  const unsigned long long BrnzMaxCount =
      0xFFFFFFFFllu; // 64b counters should only use brnzdec if within 32b.

  if (!SE.hasLoopInvariantBackedgeTakenCount(L))
    return false;

  const SCEV *BackedgeTakenCount = SE.getBackedgeTakenCount(L);
  if (isa<SCEVCouldNotCompute>(BackedgeTakenCount))
    return false;

  const SCEV *TripCountSCEV = SE.getAddExpr(
      BackedgeTakenCount, SE.getOne(BackedgeTakenCount->getType()));

  APInt TripCountMaxRange = SE.getUnsignedRangeMax(TripCountSCEV);

  // Preheader is required for analysing known bits (in Colossus' case).
  BasicBlock *preheader = L->getLoopPreheader();
  bool isKBValid = false;
  bool isKBValid_Brnzdec = false;

  if (preheader) {
    Instruction *I = preheader->getTerminator();
    Value *IV = Rewriter.expandCodeFor(TripCountSCEV,
                                       TripCountSCEV->getType(), I);
    KnownBits kbval = computeKnownBits(IV, SE.getDataLayout(), 0, &AC, I);
    kbval = kbval.getBitWidth() < 64 ? kbval.zext(64) : kbval;
    isKBValid = (kbval.Zero & ~IpuTripCount) == ~IpuTripCount;
    isKBValid_Brnzdec = (kbval.Zero & ~BrnzMaxCount) == ~BrnzMaxCount;
  }

  bool isWithinRptRange = TripCountMaxRange.ule(IpuTripCount);
  bool hasSubLoop = !L->getSubLoops().empty();

  auto TripCountIntType = dyn_cast<IntegerType>(TripCountSCEV->getType());
  if (!TripCountIntType)
    return false;

  unsigned bitwidth = TripCountIntType->getBitWidth();
  // If bitwidth <= 32, the hardware loop bitwidth would still be set to 32.
  if (bitwidth > 64) {
    return false;
  } else if (bitwidth > 32) {
    bitwidth = 64;
  }

  if (ST->isWorkerMode() && !hasSubLoop && (isWithinRptRange || isKBValid)) {
    // is rptable
    emitRptHwLoop(bitwidth);
    return true;
  }

  bool isWithinBrnzdecRange = TripCountMaxRange.ule(BrnzMaxCount);

  if (isWithinBrnzdecRange || isKBValid_Brnzdec) {
    emitBrnzdecHwLoop(bitwidth);
    return true;
  }

  return false;
}

bool ColossusTTIImpl::canSaveCmp(Loop *L, BranchInst **BI, ScalarEvolution *SE,
                LoopInfo *LI, DominatorTree *DT, AssumptionCache *AC,
                TargetLibraryInfo *LibInfo) const {
  // Make sure there are no loops nested within this loop.
  if (!L->getSubLoops().empty())
    return false;

  // Repeat loops not supported in supervisor (and by extension, mixed) mode.
  if (!ST->isWorkerMode())
    return false;

  // Stop if it's already known that tripcount > max repeat count.
  unsigned MaxTripCount = SE->getSmallConstantMaxTripCount(L);
  unsigned MaxRepeatCount =
      ST->getIPUArchInfo().CSR_W_REPEAT_COUNT__VALUE__MASK;
  if (MaxTripCount != 0 &&
        MaxTripCount > MaxRepeatCount)
    return false;

  // Make sure there's only one exiting block.
  BasicBlock *ExitingBlock = L->getExitingBlock();
  if (!ExitingBlock)
    return false;

  // Loop branch has to be conditional.
  auto *LoopBranch = static_cast<BranchInst*>(ExitingBlock->getTerminator());
  if (!LoopBranch->isConditional())
    return false;

  // Populate BI with terminating branch instruction of the ExitingBlock.
  *BI = LoopBranch;
  return true;
}
