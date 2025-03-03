//===- ColossusLoadStoreVectorizer.cpp - Colossus Load & Store Vectorizer -===//
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
// THIS PASS IS THE ALREADY EXISTING LoadStoreVectorizer PASS LOCATED IN 
// '$LLVM/llvm/lib/Transforms/Vectorize'.
//
// Modifications are Colossus target specific. When upstreamed a permutation
// of this pass should be patched into the original pass.
//
//===----------------------------------------------------------------------===//

//#include "llvm/Transforms/Vectorize/LoadStoreVectorizer.h"
#include "llvm/ADT/APInt.h"
#include "llvm/ADT/ArrayRef.h"
#include "llvm/ADT/MapVector.h"
#include "llvm/ADT/PostOrderIterator.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/SmallPtrSet.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/ADT/Statistic.h"
#include "llvm/ADT/iterator_range.h"
#include "llvm/Analysis/AliasAnalysis.h"
#include "llvm/Analysis/MemoryLocation.h"
#include "llvm/Analysis/ScalarEvolution.h"
#include "llvm/Analysis/TargetTransformInfo.h"
#include "llvm/Analysis/ValueTracking.h"
#include "llvm/Analysis/VectorUtils.h"
#include "llvm/IR/Attributes.h"
#include "llvm/IR/BasicBlock.h"
#include "llvm/IR/Constants.h"
#include "llvm/IR/DataLayout.h"
#include "llvm/IR/DerivedTypes.h"
#include "llvm/IR/Dominators.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/GetElementPtrTypeIterator.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/InstrTypes.h"
#include "llvm/IR/Instruction.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/IntrinsicInst.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/Type.h"
#include "llvm/IR/User.h"
#include "llvm/IR/Value.h"
#include "llvm/InitializePasses.h"
#include "llvm/Pass.h"
#include "llvm/Support/Casting.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/KnownBits.h"
#include "llvm/Support/MathExtras.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Transforms/Utils/Local.h"
//#include "llvm/Transforms/Vectorize.h"
#include <algorithm>
#include <cassert>
#include <cstdlib>
#include <tuple>
#include <utility>

#include "Colossus.h"

using namespace llvm;

#define DEBUG_TYPE "colossus-load-store-vectorizer"

STATISTIC(ColossusNumVectorInstructions,
          "Number of Colossus vector accesses generated");
STATISTIC(ColossusNumScalarsVectorized,
          "Number of Colossus scalar accesses vectorized");

// FIXME: Assuming stack alignment of 4 is always good enough
// Colossus uses 8, but doubt this would make a difference even with 4.
static const unsigned StackAdjustedAlignment = 8;

namespace {

/// ChainID is an arbitrary token that is allowed to be different only for the
/// accesses that are guaranteed to be considered non-consecutive by
/// Vectorizer::isConsecutiveAccess. It's used for grouping instructions
/// together and reducing the number of instructions the main search operates on
/// at a time, i.e. this is to reduce compile time and nothing else as the main
/// search has O(n^2) time complexity. The underlying type of ChainID should not
/// be relied upon.
using ChainID = const Value *;
using InstrList = SmallVector<Instruction *, 8>;
using InstrListMap = MapVector<ChainID, InstrList>;

class Vectorizer {
  Function &F;
  AliasAnalysis &AA;
  DominatorTree &DT;
  ScalarEvolution &SE;
  TargetTransformInfo &TTI;
  const DataLayout &DL;
  IRBuilder<> Builder;

public:
  Vectorizer(Function &F, AliasAnalysis &AA, DominatorTree &DT,
             ScalarEvolution &SE, TargetTransformInfo &TTI)
      : F(F), AA(AA), DT(DT), SE(SE), TTI(TTI),
        DL(F.getParent()->getDataLayout()), Builder(SE.getContext()) {}

  bool run();

private:
  unsigned getPointerAddressSpace(Value *I);

  static const unsigned MaxDepth = 3;
  bool isConsecutiveAccess(Value *A, Value *B);
  bool areConsecutivePointers(Value *PtrA, Value *PtrB, APInt PtrDelta,
                              unsigned Depth = 0) const;
  bool lookThroughComplexAddresses(Value *PtrA, Value *PtrB, APInt PtrDelta,
                                   unsigned Depth) const;
  bool lookThroughSelects(Value *PtrA, Value *PtrB, const APInt &PtrDelta,
                          unsigned Depth) const;

  /// After vectorization, reorder the instructions that I depends on
  /// (the instructions defining its operands), to ensure they dominate I.
  void reorder(Instruction *I);

  /// Returns the first and the last instructions in Chain.
  std::pair<BasicBlock::iterator, BasicBlock::iterator>
  getBoundaryInstrs(ArrayRef<Instruction *> Chain);

  /// Erases the original instructions after vectorizing.
  void eraseInstructions(ArrayRef<Instruction *> Chain);

  /// "Legalize" the vector type that would be produced by combining \p
  /// ElementSizeBits elements in \p Chain. Break into two pieces such that the
  /// total size of each piece is 1, 2 or a multiple of 4 bytes. \p Chain is
  /// expected to have more than 4 elements.
  std::pair<ArrayRef<Instruction *>, ArrayRef<Instruction *>>
  splitOddVectorElts(ArrayRef<Instruction *> Chain, unsigned ElementSizeBits);

  /// Finds the largest prefix of Chain that's vectorizable, checking for
  /// intervening instructions which may affect the memory accessed by the
  /// instructions within Chain.
  ///
  /// The elements of \p Chain must be all loads or all stores and must be in
  /// address order.
  ArrayRef<Instruction *> getVectorizablePrefix(ArrayRef<Instruction *> Chain);

  /// Collects load and store instructions to vectorize.
  std::pair<InstrListMap, InstrListMap> collectInstructions(BasicBlock *BB);

  /// Processes the collected instructions, the \p Map. The values of \p Map
  /// should be all loads or all stores.
  bool vectorizeChains(InstrListMap &Map);

  /// Finds the load/stores to consecutive memory addresses and vectorizes them.
  bool vectorizeInstructions(ArrayRef<Instruction *> Instrs);

  /// Vectorizes the load instructions in Chain.
  bool
  vectorizeLoadChain(ArrayRef<Instruction *> Chain,
                     SmallPtrSet<Instruction *, 16> *InstructionsProcessed);

  /// Vectorizes the store instructions in Chain.
  bool
  vectorizeStoreChain(ArrayRef<Instruction *> Chain,
                      SmallPtrSet<Instruction *, 16> *InstructionsProcessed);

  /// Check if this load/store access is misaligned accesses.
  bool accessIsMisaligned(unsigned SzInBytes, unsigned AddressSpace,
                          Align Alignment);

  // Check if instruction is a constrained floating point intrinsic call.
  static bool isConstrainedFPIntrinsic(Instruction const & instr);

  // The real propagateMetadata expects a SmallVector<Value*>, but we deal in
  // vectors of Instructions.
  static void propagateMetadata(Instruction *I, ArrayRef<Instruction *> IL);

  // Colossus specific chain legalizing. When upstreaming/upstreamed we may
  // want to create a hook for this in TargetTransformInfo.
  //
  // `min_align` - Minimum alignment requirement for the first instruction in a
  //               load/store pair.
  //
  template<typename T, size_t min_align>
  static void colossusLegalizeChain(InstrListMap &refs);
};

class ColossusLoadStoreVectorizerPass : public FunctionPass {
public:
  static char ID;

  ColossusLoadStoreVectorizerPass() : FunctionPass(ID) {
    initializeColossusLoadStoreVectorizerPassPass(
      *PassRegistry::getPassRegistry()
    );
  }

  bool runOnFunction(Function &F) override;

  StringRef getPassName() const override {
    return "Colossus Load and Store Vectorizer";
  }

  void getAnalysisUsage(AnalysisUsage &AU) const override {
    AU.addRequired<AAResultsWrapperPass>();
    AU.addRequired<ScalarEvolutionWrapperPass>();
    AU.addRequired<DominatorTreeWrapperPass>();
    AU.addRequired<TargetTransformInfoWrapperPass>();
    AU.setPreservesCFG();
  }
};

} // end anonymous namespace

char ColossusLoadStoreVectorizerPass::ID = 0;

INITIALIZE_PASS_BEGIN(ColossusLoadStoreVectorizerPass, DEBUG_TYPE,
                      "Vectorize Colossus load and Store instructions",
                      false, false)
INITIALIZE_PASS_DEPENDENCY(SCEVAAWrapperPass)
INITIALIZE_PASS_DEPENDENCY(DominatorTreeWrapperPass)
INITIALIZE_PASS_DEPENDENCY(AAResultsWrapperPass)
INITIALIZE_PASS_DEPENDENCY(GlobalsAAWrapperPass)
INITIALIZE_PASS_DEPENDENCY(TargetTransformInfoWrapperPass)
INITIALIZE_PASS_END(ColossusLoadStoreVectorizerPass, DEBUG_TYPE,
                    "Vectorize Colossus load and store instructions",
                    false, false)

FunctionPass *llvm::createColossusLoadStoreVectorizerPass() {
  return new ColossusLoadStoreVectorizerPass();
}

bool ColossusLoadStoreVectorizerPass::runOnFunction(Function &F) {
  // Don't vectorize when the attribute NoImplicitFloat is used.
  if (skipFunction(F) || F.hasFnAttribute(Attribute::NoImplicitFloat))
    return false;

  AliasAnalysis &AA = getAnalysis<AAResultsWrapperPass>().getAAResults();
  DominatorTree &DT = getAnalysis<DominatorTreeWrapperPass>().getDomTree();
  ScalarEvolution &SE = getAnalysis<ScalarEvolutionWrapperPass>().getSE();
  TargetTransformInfo &TTI =
      getAnalysis<TargetTransformInfoWrapperPass>().getTTI(F);

  Vectorizer V(F, AA, DT, SE, TTI);
  return V.run();
}

bool Vectorizer::isConstrainedFPIntrinsic(Instruction const & instr) {

  if (!isa<IntrinsicInst>(instr)) {
    return false;
  }

  switch (cast<IntrinsicInst>(instr).getIntrinsicID()) {
#define DAG_INSTRUCTION(NAME, NARG, ROUND_MODE, INTRINSIC, DAGN)               \
    case Intrinsic::INTRINSIC: {                                               \
      return true;                                                             \
    }
#include "llvm/IR/ConstrainedOps.def"
    default: {
      return false;
    }
  }
}

void Vectorizer::propagateMetadata(Instruction *I, ArrayRef<Instruction *> IL) {
  SmallVector<Value *, 8> VL(IL.begin(), IL.end());
  ::propagateMetadata(I, VL);
}

template<typename T, size_t min_align>
void Vectorizer::colossusLegalizeChain(InstrListMap &refs) {
  // In the case of Colossus, only vectorize when we find consecutive float
  // loads/stores that are power-two aligned. Any load/store that doesn't
  // adhere to this pattern won't be considered for vectorization. The final
  // chain should match the RE: (84)*
  if (refs.empty())
    return;

  SmallPtrSet<Instruction *, 16> markedInstr;

  using ConstInstrIterator = InstrList::const_iterator;

  auto getAlign = [](ConstInstrIterator instr) {
    return cast<T>(*instr)->getAlign();
  };
  auto isPower2Aligned = [](ConstInstrIterator instr) {
    return isPowerOf2_64(cast<T>(*instr)->getAlign().value());
  };

  // Find and mark instructions that can be omitted from vectorization.
  for (auto & Chain : refs) {
    auto instr = Chain.second.begin();
    auto const end = Chain.second.end();
    // Only consecutive power-two aligned loads/stores may be considered for
    // vectorisation. All other instructions are added to the marked set.
    while (instr != end) {
      auto nextInstr = instr + 1;
      while (nextInstr != end) {
        auto const instrAlignment = getAlign(instr);
        auto const nextInstrAlignment = getAlign(nextInstr);
        if (isPower2Aligned(instr) &&
            isPower2Aligned(nextInstr) &&
            instrAlignment >= min_align &&
            instrAlignment > nextInstrAlignment) {
          break;
        }
        markedInstr.insert(*instr);
        instr++;
        nextInstr++;
      }

      if (nextInstr == end) {
        markedInstr.insert(*instr);
        break;
      }
      instr += 2;
    }
    // Erase marked instructions from the vectorization chain in reverse order
    // to make consecutive erasing easier as the vector gets resized at each
    // removal (also prevents O(n^2) runtime).
    for (auto I = Chain.second.end() - 1; I >= Chain.second.begin(); I--) {
      if (markedInstr.count(*I))
        Chain.second.erase(I);
    }
  }
}

// Vectorizer Implementation
bool Vectorizer::run() {
  bool Changed = false;

  // Scan the blocks in the function in post order.
  for (BasicBlock *BB : post_order(&F)) {
    InstrListMap LoadRefs, StoreRefs;
    std::tie(LoadRefs, StoreRefs) = collectInstructions(BB);
    colossusLegalizeChain<LoadInst, 8u>(LoadRefs);
    colossusLegalizeChain<StoreInst, 4u>(StoreRefs);
    Changed |= vectorizeChains(LoadRefs);
    Changed |= vectorizeChains(StoreRefs);
  }

  return Changed;
}

unsigned Vectorizer::getPointerAddressSpace(Value *I) {
  if (LoadInst *L = dyn_cast<LoadInst>(I))
    return L->getPointerAddressSpace();
  if (StoreInst *S = dyn_cast<StoreInst>(I))
    return S->getPointerAddressSpace();
  return -1;
}

// FIXME: Merge with llvm::isConsecutiveAccess
bool Vectorizer::isConsecutiveAccess(Value *A, Value *B) {
  Value *PtrA = getLoadStorePointerOperand(A);
  Value *PtrB = getLoadStorePointerOperand(B);
  unsigned ASA = getPointerAddressSpace(A);
  unsigned ASB = getPointerAddressSpace(B);

  // Check that the address spaces match and that the pointers are valid.
  if (!PtrA || !PtrB || (ASA != ASB))
    return false;

  // Make sure that A and B are different pointers of the same size type.
  Type *PtrATy = getLoadStoreType(A);
  Type *PtrBTy = getLoadStoreType(B);
  if (PtrA == PtrB ||
      PtrATy->isVectorTy() != PtrBTy->isVectorTy() ||
      DL.getTypeStoreSize(PtrATy) != DL.getTypeStoreSize(PtrBTy) ||
      DL.getTypeStoreSize(PtrATy->getScalarType()) !=
          DL.getTypeStoreSize(PtrBTy->getScalarType()))
    return false;

  unsigned PtrBitWidth = DL.getPointerSizeInBits(ASA);
  APInt Size(PtrBitWidth, DL.getTypeStoreSize(PtrATy));

  return areConsecutivePointers(PtrA, PtrB, Size);
}

bool Vectorizer::areConsecutivePointers(Value *PtrA, Value *PtrB,
                                        APInt PtrDelta, unsigned Depth) const {
  unsigned PtrBitWidth = DL.getPointerTypeSizeInBits(PtrA->getType());
  APInt OffsetA(PtrBitWidth, 0);
  APInt OffsetB(PtrBitWidth, 0);
  PtrA = PtrA->stripAndAccumulateInBoundsConstantOffsets(DL, OffsetA);
  PtrB = PtrB->stripAndAccumulateInBoundsConstantOffsets(DL, OffsetB);

  unsigned NewPtrBitWidth = DL.getTypeStoreSizeInBits(PtrA->getType());

  if (NewPtrBitWidth != DL.getTypeStoreSizeInBits(PtrB->getType()))
    return false;

  // In case if we have to shrink the pointer
  // stripAndAccumulateInBoundsConstantOffsets should properly handle a
  // possible overflow and the value should fit into a smallest data type
  // used in the cast/gep chain.
  assert(OffsetA.getMinSignedBits() <= NewPtrBitWidth &&
         OffsetB.getMinSignedBits() <= NewPtrBitWidth);

  OffsetA = OffsetA.sextOrTrunc(NewPtrBitWidth);
  OffsetB = OffsetB.sextOrTrunc(NewPtrBitWidth);
  PtrDelta = PtrDelta.sextOrTrunc(NewPtrBitWidth);

  APInt OffsetDelta = OffsetB - OffsetA;

  // Check if they are based on the same pointer. That makes the offsets
  // sufficient.
  if (PtrA == PtrB)
    return OffsetDelta == PtrDelta;

  // Compute the necessary base pointer delta to have the necessary final delta
  // equal to the pointer delta requested.
  APInt BaseDelta = PtrDelta - OffsetDelta;

  // Compute the distance with SCEV between the base pointers.
  const SCEV *PtrSCEVA = SE.getSCEV(PtrA);
  const SCEV *PtrSCEVB = SE.getSCEV(PtrB);
  const SCEV *C = SE.getConstant(BaseDelta);
  const SCEV *X = SE.getAddExpr(PtrSCEVA, C);
  if (X == PtrSCEVB)
    return true;

  // The above check will not catch the cases where one of the pointers is
  // factorized but the other one is not, such as (C + (S * (A + B))) vs
  // (AS + BS). Get the minus scev. That will allow re-combining the expresions
  // and getting the simplified difference.
  const SCEV *Dist = SE.getMinusSCEV(PtrSCEVB, PtrSCEVA);
  if (C == Dist)
    return true;

  // Sometimes even this doesn't work, because SCEV can't always see through
  // patterns that look like (gep (ext (add (shl X, C1), C2))). Try checking
  // things the hard way.
  return lookThroughComplexAddresses(PtrA, PtrB, BaseDelta, Depth);
}

bool Vectorizer::lookThroughComplexAddresses(Value *PtrA, Value *PtrB,
                                             APInt PtrDelta,
                                             unsigned Depth) const {
  auto *GEPA = dyn_cast<GetElementPtrInst>(PtrA);
  auto *GEPB = dyn_cast<GetElementPtrInst>(PtrB);
  if (!GEPA || !GEPB)
    return lookThroughSelects(PtrA, PtrB, PtrDelta, Depth);

  // Look through GEPs after checking they're the same except for the last
  // index.
  if (GEPA->getNumOperands() != GEPB->getNumOperands() ||
      GEPA->getPointerOperand() != GEPB->getPointerOperand())
    return false;
  gep_type_iterator GTIA = gep_type_begin(GEPA);
  gep_type_iterator GTIB = gep_type_begin(GEPB);
  for (unsigned I = 0, E = GEPA->getNumIndices() - 1; I < E; ++I) {
    if (GTIA.getOperand() != GTIB.getOperand())
      return false;
    ++GTIA;
    ++GTIB;
  }

  Instruction *OpA = dyn_cast<Instruction>(GTIA.getOperand());
  Instruction *OpB = dyn_cast<Instruction>(GTIB.getOperand());
  if (!OpA || !OpB || OpA->getOpcode() != OpB->getOpcode() ||
      OpA->getType() != OpB->getType())
    return false;

  if (PtrDelta.isNegative()) {
    if (PtrDelta.isMinSignedValue())
      return false;
    PtrDelta.negate();
    std::swap(OpA, OpB);
  }
  uint64_t Stride = DL.getTypeAllocSize(GTIA.getIndexedType());
  if (PtrDelta.urem(Stride) != 0)
    return false;
  unsigned IdxBitWidth = OpA->getType()->getScalarSizeInBits();
  APInt IdxDiff = PtrDelta.udiv(Stride).zext(IdxBitWidth);

  // Only look through a ZExt/SExt.
  if (!isa<SExtInst>(OpA) && !isa<ZExtInst>(OpA))
    return false;

  bool Signed = isa<SExtInst>(OpA);

  // At this point A could be a function parameter, i.e. not an instruction
  Value *ValA = OpA->getOperand(0);
  OpB = dyn_cast<Instruction>(OpB->getOperand(0));
  if (!OpB || ValA->getType() != OpB->getType())
    return false;

  // Now we need to prove that adding IdxDiff to ValA won't overflow.
  bool Safe = false;
  auto CheckFlags = [](Instruction *I, bool Signed) {
    BinaryOperator *BinOpI = cast<BinaryOperator>(I);
    return (Signed && BinOpI->hasNoSignedWrap()) ||
           (!Signed && BinOpI->hasNoUnsignedWrap());
  };

  // First attempt: if OpB is an add with NSW/NUW, and OpB is IdxDiff added to
  // ValA, we're okay.
  if (OpB->getOpcode() == Instruction::Add &&
      isa<ConstantInt>(OpB->getOperand(1)) &&
      IdxDiff.sle(cast<ConstantInt>(OpB->getOperand(1))->getSExtValue()) &&
      CheckFlags(OpB, Signed))
    Safe = true;

  // Second attempt: If both OpA and OpB is an add with NSW/NUW and with
  // the same LHS operand, we can guarantee that the transformation is safe
  // if we can prove that OpA won't overflow when IdxDiff added to the RHS
  // of OpA.
  // For example:
  //  %tmp7 = add nsw i32 %tmp2, %v0
  //  %tmp8 = sext i32 %tmp7 to i64
  //  ...
  //  %tmp11 = add nsw i32 %v0, 1
  //  %tmp12 = add nsw i32 %tmp2, %tmp11
  //  %tmp13 = sext i32 %tmp12 to i64
  //
  //  Both %tmp7 and %tmp2 has the nsw flag and the first operand
  //  is %tmp2. It's guaranteed that adding 1 to %tmp7 won't overflow
  //  because %tmp11 adds 1 to %v0 and both %tmp11 and %tmp12 has the
  //  nsw flag.
  OpA = dyn_cast<Instruction>(ValA);
  if (!Safe && OpA && OpA->getOpcode() == Instruction::Add &&
      OpB->getOpcode() == Instruction::Add &&
      OpA->getOperand(0) == OpB->getOperand(0) && CheckFlags(OpA, Signed) &&
      CheckFlags(OpB, Signed)) {
    Value *RHSA = OpA->getOperand(1);
    Value *RHSB = OpB->getOperand(1);
    Instruction *OpRHSA = dyn_cast<Instruction>(RHSA);
    Instruction *OpRHSB = dyn_cast<Instruction>(RHSB);
    // Match `x +nsw/nuw y` and `x +nsw/nuw (y +nsw/nuw IdxDiff)`.
    if (OpRHSB && OpRHSB->getOpcode() == Instruction::Add &&
        CheckFlags(OpRHSB, Signed) && isa<ConstantInt>(OpRHSB->getOperand(1))) {
      int64_t CstVal = cast<ConstantInt>(OpRHSB->getOperand(1))->getSExtValue();
      if (OpRHSB->getOperand(0) == RHSA && IdxDiff.getSExtValue() == CstVal)
        Safe = true;
    }
    // Match `x +nsw/nuw (y +nsw/nuw -Idx)` and `x +nsw/nuw (y +nsw/nuw x)`.
    if (OpRHSA && OpRHSA->getOpcode() == Instruction::Add &&
        CheckFlags(OpRHSA, Signed) && isa<ConstantInt>(OpRHSA->getOperand(1))) {
      int64_t CstVal = cast<ConstantInt>(OpRHSA->getOperand(1))->getSExtValue();
      if (OpRHSA->getOperand(0) == RHSB && IdxDiff.getSExtValue() == -CstVal)
        Safe = true;
    }
    // Match `x +nsw/nuw (y +nsw/nuw c)` and
    // `x +nsw/nuw (y +nsw/nuw (c + IdxDiff))`.
    if (OpRHSA && OpRHSB && OpRHSA->getOpcode() == Instruction::Add &&
        OpRHSB->getOpcode() == Instruction::Add && CheckFlags(OpRHSA, Signed) &&
        CheckFlags(OpRHSB, Signed) && isa<ConstantInt>(OpRHSA->getOperand(1)) &&
        isa<ConstantInt>(OpRHSB->getOperand(1))) {
      int64_t CstValA =
          cast<ConstantInt>(OpRHSA->getOperand(1))->getSExtValue();
      int64_t CstValB =
          cast<ConstantInt>(OpRHSB->getOperand(1))->getSExtValue();
      if (OpRHSA->getOperand(0) == OpRHSB->getOperand(0) &&
          IdxDiff.getSExtValue() == (CstValB - CstValA))
        Safe = true;
    }
  }

  unsigned BitWidth = ValA->getType()->getScalarSizeInBits();

  // Third attempt:
  // If all set bits of IdxDiff or any higher order bit other than the sign bit
  // are known to be zero in ValA, we can add Diff to it while guaranteeing no
  // overflow of any sort.
  if (!Safe) {
    OpA = dyn_cast<Instruction>(ValA);
    if (!OpA)
      return false;
    KnownBits Known(BitWidth);
    computeKnownBits(OpA, Known, DL, 0, nullptr, OpA, &DT);
    APInt BitsAllowedToBeSet = Known.Zero.zext(IdxDiff.getBitWidth());
    if (Signed)
      BitsAllowedToBeSet.clearBit(BitWidth - 1);
    if (BitsAllowedToBeSet.ult(IdxDiff))
      return false;
  }

  const SCEV *OffsetSCEVA = SE.getSCEV(ValA);
  const SCEV *OffsetSCEVB = SE.getSCEV(OpB);
  const SCEV *C = SE.getConstant(IdxDiff.trunc(BitWidth));
  const SCEV *X = SE.getAddExpr(OffsetSCEVA, C);
  return X == OffsetSCEVB;
}

bool Vectorizer::lookThroughSelects(Value *PtrA, Value *PtrB,
                                    const APInt &PtrDelta,
                                    unsigned Depth) const {
  if (Depth++ == MaxDepth)
    return false;

  if (auto *SelectA = dyn_cast<SelectInst>(PtrA)) {
    if (auto *SelectB = dyn_cast<SelectInst>(PtrB)) {
      return SelectA->getCondition() == SelectB->getCondition() &&
             areConsecutivePointers(SelectA->getTrueValue(),
                                    SelectB->getTrueValue(), PtrDelta, Depth) &&
             areConsecutivePointers(SelectA->getFalseValue(),
                                    SelectB->getFalseValue(), PtrDelta, Depth);
    }
  }
  return false;
}

void Vectorizer::reorder(Instruction *I) {
  SmallPtrSet<Instruction *, 16> InstructionsToMove;
  SmallVector<Instruction *, 16> Worklist;

  Worklist.push_back(I);
  while (!Worklist.empty()) {
    Instruction *IW = Worklist.pop_back_val();
    int NumOperands = IW->getNumOperands();
    for (int i = 0; i < NumOperands; i++) {
      Instruction *IM = dyn_cast<Instruction>(IW->getOperand(i));
      if (!IM || IM->getOpcode() == Instruction::PHI)
        continue;

      // If IM is in another BB, no need to move it, because this pass only
      // vectorizes instructions within one BB.
      if (IM->getParent() != I->getParent())
        continue;

      if (!IM->comesBefore(I)) {
        InstructionsToMove.insert(IM);
        Worklist.push_back(IM);
      }
    }
  }

  // All instructions to move should follow I. Start from I, not from begin().
  for (auto BBI = I->getIterator(), E = I->getParent()->end(); BBI != E;
       ++BBI) {
    if (!InstructionsToMove.count(&*BBI))
      continue;
    Instruction *IM = &*BBI;
    --BBI;
    IM->removeFromParent();
    IM->insertBefore(I);
  }
}

std::pair<BasicBlock::iterator, BasicBlock::iterator>
Vectorizer::getBoundaryInstrs(ArrayRef<Instruction *> Chain) {
  Instruction *C0 = Chain[0];
  BasicBlock::iterator FirstInstr = C0->getIterator();
  BasicBlock::iterator LastInstr = C0->getIterator();

  BasicBlock *BB = C0->getParent();
  unsigned NumFound = 0;
  for (Instruction &I : *BB) {
    if (!is_contained(Chain, &I))
      continue;

    ++NumFound;
    if (NumFound == 1) {
      FirstInstr = I.getIterator();
    }
    if (NumFound == Chain.size()) {
      LastInstr = I.getIterator();
      break;
    }
  }

  // Range is [first, last).
  return std::make_pair(FirstInstr, ++LastInstr);
}

void Vectorizer::eraseInstructions(ArrayRef<Instruction *> Chain) {
  SmallVector<Instruction *, 16> Instrs;
  for (Instruction *I : Chain) {
    Value *PtrOperand = getLoadStorePointerOperand(I);
    assert(PtrOperand && "Instruction must have a pointer operand.");
    Instrs.push_back(I);
    if (GetElementPtrInst *GEP = dyn_cast<GetElementPtrInst>(PtrOperand))
      Instrs.push_back(GEP);
  }

  // Erase instructions.
  for (Instruction *I : Instrs)
    if (I->use_empty())
      I->eraseFromParent();
}

std::pair<ArrayRef<Instruction *>, ArrayRef<Instruction *>>
Vectorizer::splitOddVectorElts(ArrayRef<Instruction *> Chain,
                               unsigned ElementSizeBits) {
  unsigned ElementSizeBytes = ElementSizeBits / 8;
  unsigned SizeBytes = ElementSizeBytes * Chain.size();
  unsigned NumLeft = (SizeBytes - (SizeBytes % 4)) / ElementSizeBytes;
  if (NumLeft == Chain.size()) {
    if ((NumLeft & 1) == 0)
      NumLeft /= 2; // Split even in half
    else
      --NumLeft;    // Split off last element
  } else if (NumLeft == 0)
    NumLeft = 1;
  return std::make_pair(Chain.slice(0, NumLeft), Chain.slice(NumLeft));
}

ArrayRef<Instruction *>
Vectorizer::getVectorizablePrefix(ArrayRef<Instruction *> Chain) {
  // These are in BB order, unlike Chain, which is in address order.
  SmallVector<Instruction *, 16> MemoryInstrs;
  SmallVector<Instruction *, 16> ChainInstrs;

  bool IsLoadChain = isa<LoadInst>(Chain[0]);
  LLVM_DEBUG({
    for (Instruction *I : Chain) {
      if (IsLoadChain)
        assert(isa<LoadInst>(I) &&
               "All elements of Chain must be loads, or all must be stores.");
      else
        assert(isa<StoreInst>(I) &&
               "All elements of Chain must be loads, or all must be stores.");
    }
  });

  for (Instruction &I : make_range(getBoundaryInstrs(Chain))) {
    if (isa<LoadInst>(I) || isa<StoreInst>(I)) {
      if (!is_contained(Chain, &I))
        MemoryInstrs.push_back(&I);
      else
        ChainInstrs.push_back(&I);
    } else if (isa<IntrinsicInst>(&I) &&
               cast<IntrinsicInst>(&I)->getIntrinsicID() ==
                   Intrinsic::sideeffect) {
      // Ignore llvm.sideeffect calls.
    } else if (isa<IntrinsicInst>(&I) &&
               cast<IntrinsicInst>(&I)->getIntrinsicID() ==
                   Intrinsic::pseudoprobe) {
      // Ignore llvm.pseudoprobe calls.
    } else if (isConstrainedFPIntrinsic(I)) {
      // Ignore constrained FP intrinsics.
    } else if (IsLoadChain && (I.mayWriteToMemory() || I.mayThrow())) {
      LLVM_DEBUG(dbgs() << "LSV: Found may-write/throw operation: " << I
                        << '\n');
      break;
    } else if (!IsLoadChain && (I.mayReadOrWriteMemory() || I.mayThrow())) {
      LLVM_DEBUG(dbgs() << "LSV: Found may-read/write/throw operation: " << I
                        << '\n');
      break;
    }
  }

  // Loop until we find an instruction in ChainInstrs that we can't vectorize.
  unsigned ChainInstrIdx = 0;
  Instruction *BarrierMemoryInstr = nullptr;

  for (unsigned E = ChainInstrs.size(); ChainInstrIdx < E; ++ChainInstrIdx) {
    Instruction *ChainInstr = ChainInstrs[ChainInstrIdx];

    // If a barrier memory instruction was found, chain instructions that follow
    // will not be added to the valid prefix.
    if (BarrierMemoryInstr && BarrierMemoryInstr->comesBefore(ChainInstr))
      break;

    // Check (in BB order) if any instruction prevents ChainInstr from being
    // vectorized. Find and store the first such "conflicting" instruction.
    for (Instruction *MemInstr : MemoryInstrs) {
      // If a barrier memory instruction was found, do not check past it.
      if (BarrierMemoryInstr && BarrierMemoryInstr->comesBefore(MemInstr))
        break;

      auto *MemLoad = dyn_cast<LoadInst>(MemInstr);
      auto *ChainLoad = dyn_cast<LoadInst>(ChainInstr);
      if (MemLoad && ChainLoad)
        continue;

      // We can ignore the alias if the we have a load store pair and the load
      // is known to be invariant. The load cannot be clobbered by the store.
      auto IsInvariantLoad = [](const LoadInst *LI) -> bool {
        return LI->hasMetadata(LLVMContext::MD_invariant_load);
      };

      // We can ignore the alias as long as the load comes before the store,
      // because that means we won't be moving the load past the store to
      // vectorize it (the vectorized load is inserted at the location of the
      // first load in the chain).
      if (isa<StoreInst>(MemInstr) && ChainLoad &&
          (IsInvariantLoad(ChainLoad) || ChainLoad->comesBefore(MemInstr)))
        continue;

      // Same case, but in reverse.
      if (MemLoad && isa<StoreInst>(ChainInstr) &&
          (IsInvariantLoad(MemLoad) || MemLoad->comesBefore(ChainInstr)))
        continue;

      if (!AA.isNoAlias(MemoryLocation::get(MemInstr),
                        MemoryLocation::get(ChainInstr))) {
        LLVM_DEBUG({
          dbgs() << "LSV: Found alias:\n"
                    "  Aliasing instruction and pointer:\n"
                 << "  " << *MemInstr << '\n'
                 << "  " << *getLoadStorePointerOperand(MemInstr) << '\n'
                 << "  Aliased instruction and pointer:\n"
                 << "  " << *ChainInstr << '\n'
                 << "  " << *getLoadStorePointerOperand(ChainInstr) << '\n';
        });
        // Save this aliasing memory instruction as a barrier, but allow other
        // instructions that precede the barrier to be vectorized with this one.
        BarrierMemoryInstr = MemInstr;
        break;
      }
    }
    // Continue the search only for store chains, since vectorizing stores that
    // precede an aliasing load is valid. Conversely, vectorizing loads is valid
    // up to an aliasing store, but should not pull loads from further down in
    // the basic block.
    if (IsLoadChain && BarrierMemoryInstr) {
      // The BarrierMemoryInstr is a store that precedes ChainInstr.
      assert(BarrierMemoryInstr->comesBefore(ChainInstr));
      break;
    }
  }

  // Find the largest prefix of Chain whose elements are all in
  // ChainInstrs[0, ChainInstrIdx).  This is the largest vectorizable prefix of
  // Chain.  (Recall that Chain is in address order, but ChainInstrs is in BB
  // order.)
  SmallPtrSet<Instruction *, 8> VectorizableChainInstrs(
      ChainInstrs.begin(), ChainInstrs.begin() + ChainInstrIdx);
  unsigned ChainIdx = 0;
  for (unsigned ChainLen = Chain.size(); ChainIdx < ChainLen; ++ChainIdx) {
    if (!VectorizableChainInstrs.count(Chain[ChainIdx]))
      break;
  }
  return Chain.slice(0, ChainIdx);
}

static ChainID getChainID(const Value *Ptr) {
  const Value *ObjPtr = getUnderlyingObject(Ptr);
  if (const auto *Sel = dyn_cast<SelectInst>(ObjPtr)) {
    // The select's themselves are distinct instructions even if they share the
    // same condition and evaluate to consecutive pointers for true and false
    // values of the condition. Therefore using the select's themselves for
    // grouping instructions would put consecutive accesses into different lists
    // and they won't be even checked for being consecutive, and won't be
    // vectorized.
    return Sel->getCondition();
  }
  return ObjPtr;
}

std::pair<InstrListMap, InstrListMap>
Vectorizer::collectInstructions(BasicBlock *BB) {
  InstrListMap LoadRefs;
  InstrListMap StoreRefs;

  for (Instruction &I : *BB) {
    if (!I.mayReadOrWriteMemory())
      continue;

    if (LoadInst *LI = dyn_cast<LoadInst>(&I)) {
      if (!LI->isSimple())
        continue;

      // Skip if it's not legal.
      if (!TTI.isLegalToVectorizeLoad(LI))
        continue;

      Type *Ty = LI->getType();
      if (!VectorType::isValidElementType(Ty->getScalarType()))
        continue;

      // Skip weird non-byte sizes. They probably aren't worth the effort of
      // handling correctly.
      unsigned TySize = DL.getTypeSizeInBits(Ty);
      if ((TySize % 8) != 0)
        continue;

      // Skip vectors of pointers. The vectorizeLoadChain/vectorizeStoreChain
      // functions are currently using an integer type for the vectorized
      // load/store, and does not support casting between the integer type and a
      // vector of pointers (e.g. i64 to <2 x i16*>)
      if (Ty->isVectorTy() && Ty->isPtrOrPtrVectorTy())
        continue;

      Value *Ptr = LI->getPointerOperand();
      unsigned AS = Ptr->getType()->getPointerAddressSpace();
      unsigned VecRegSize = TTI.getLoadStoreVecRegBitWidth(AS);

      unsigned VF = VecRegSize / TySize;
      VectorType *VecTy = dyn_cast<VectorType>(Ty);

      // No point in looking at these if they're too big to vectorize.
      if (TySize > VecRegSize / 2 ||
          (VecTy && TTI.getLoadVectorFactor(VF, TySize, TySize / 8, VecTy) == 0))
        continue;

      // Make sure all the users of a vector are constant-index extracts.
      if (isa<VectorType>(Ty) && !llvm::all_of(LI->users(), [](const User *U) {
            const ExtractElementInst *EEI = dyn_cast<ExtractElementInst>(U);
            return EEI && isa<ConstantInt>(EEI->getOperand(1));
          }))
        continue;

      // Save the load locations.
      const ChainID ID = getChainID(Ptr);
      LoadRefs[ID].push_back(LI);
    } else if (StoreInst *SI = dyn_cast<StoreInst>(&I)) {
      if (!SI->isSimple())
        continue;

      // Skip if it's not legal.
      if (!TTI.isLegalToVectorizeStore(SI))
        continue;

      Type *Ty = SI->getValueOperand()->getType();
      if (!VectorType::isValidElementType(Ty->getScalarType()))
        continue;

      // Skip vectors of pointers. The vectorizeLoadChain/vectorizeStoreChain
      // functions are currently using an integer type for the vectorized
      // load/store, and does not support casting between the integer type and a
      // vector of pointers (e.g. i64 to <2 x i16*>)
      if (Ty->isVectorTy() && Ty->isPtrOrPtrVectorTy())
        continue;

      // Skip weird non-byte sizes. They probably aren't worth the effort of
      // handling correctly.
      unsigned TySize = DL.getTypeSizeInBits(Ty);
      if ((TySize % 8) != 0)
        continue;

      Value *Ptr = SI->getPointerOperand();
      unsigned AS = Ptr->getType()->getPointerAddressSpace();
      unsigned VecRegSize = TTI.getLoadStoreVecRegBitWidth(AS);

      unsigned VF = VecRegSize / TySize;
      VectorType *VecTy = dyn_cast<VectorType>(Ty);

      // No point in looking at these if they're too big to vectorize.
      if (TySize > VecRegSize / 2 ||
          (VecTy && TTI.getStoreVectorFactor(VF, TySize, TySize / 8, VecTy) == 0))
        continue;

      if (isa<VectorType>(Ty) && !llvm::all_of(SI->users(), [](const User *U) {
            const ExtractElementInst *EEI = dyn_cast<ExtractElementInst>(U);
            return EEI && isa<ConstantInt>(EEI->getOperand(1));
          }))
        continue;

      // Save store location.
      const ChainID ID = getChainID(Ptr);
      StoreRefs[ID].push_back(SI);
    }
  }

  return {LoadRefs, StoreRefs};
}

bool Vectorizer::vectorizeChains(InstrListMap &Map) {
  bool Changed = false;

  for (const std::pair<ChainID, InstrList> &Chain : Map) {
    unsigned Size = Chain.second.size();
    if (Size < 2)
      continue;

    LLVM_DEBUG(dbgs() << "LSV: Analyzing a chain of length " << Size << ".\n");

    // Process the stores in chunks of 64.
    for (unsigned CI = 0, CE = Size; CI < CE; CI += 64) {
      unsigned Len = std::min<unsigned>(CE - CI, 64);
      ArrayRef<Instruction *> Chunk(&Chain.second[CI], Len);
      Changed |= vectorizeInstructions(Chunk);
    }
  }

  return Changed;
}

bool Vectorizer::vectorizeInstructions(ArrayRef<Instruction *> Instrs) {
  LLVM_DEBUG(dbgs() << "LSV: Vectorizing " << Instrs.size()
                    << " instructions.\n");
  SmallVector<int, 16> Heads, Tails;
  int ConsecutiveChain[64];

  // Do a quadratic search on all of the given loads/stores and find all of the
  // pairs of loads/stores that follow each other.
  for (int i = 0, e = Instrs.size(); i < e; ++i) {
    ConsecutiveChain[i] = -1;
    for (int j = e - 1; j >= 0; --j) {
      if (i == j)
        continue;

      if (isConsecutiveAccess(Instrs[i], Instrs[j])) {
        if (ConsecutiveChain[i] != -1) {
          int CurDistance = std::abs(ConsecutiveChain[i] - i);
          int NewDistance = std::abs(ConsecutiveChain[i] - j);
          if (j < i || NewDistance > CurDistance)
            continue; // Should not insert.
        }

        Tails.push_back(j);
        Heads.push_back(i);
        ConsecutiveChain[i] = j;
      }
    }
  }

  bool Changed = false;
  SmallPtrSet<Instruction *, 16> InstructionsProcessed;

  for (int Head : Heads) {
    if (InstructionsProcessed.count(Instrs[Head]))
      continue;
    bool LongerChainExists = false;
    for (unsigned TIt = 0; TIt < Tails.size(); TIt++)
      if (Head == Tails[TIt] &&
          !InstructionsProcessed.count(Instrs[Heads[TIt]])) {
        LongerChainExists = true;
        break;
      }
    if (LongerChainExists)
      continue;

    // We found an instr that starts a chain. Now follow the chain and try to
    // vectorize it.
    SmallVector<Instruction *, 16> Operands;
    int I = Head;
    while (I != -1 && (is_contained(Tails, I) || is_contained(Heads, I))) {
      if (InstructionsProcessed.count(Instrs[I]))
        break;

      Operands.push_back(Instrs[I]);
      I = ConsecutiveChain[I];
    }

    bool Vectorized = false;
    if (isa<LoadInst>(*Operands.begin()))
      Vectorized = vectorizeLoadChain(Operands, &InstructionsProcessed);
    else
      Vectorized = vectorizeStoreChain(Operands, &InstructionsProcessed);

    Changed |= Vectorized;
  }

  return Changed;
}

bool Vectorizer::vectorizeStoreChain(
    ArrayRef<Instruction *> Chain,
    SmallPtrSet<Instruction *, 16> *InstructionsProcessed) {
  StoreInst *S0 = cast<StoreInst>(Chain[0]);

  // If the vector has an int element, default to int for the whole store.
  Type *StoreTy = nullptr;
  for (Instruction *I : Chain) {
    StoreTy = cast<StoreInst>(I)->getValueOperand()->getType();
    if (StoreTy->isIntOrIntVectorTy())
      break;

    if (StoreTy->isPtrOrPtrVectorTy()) {
      StoreTy = Type::getIntNTy(F.getParent()->getContext(),
                                DL.getTypeSizeInBits(StoreTy));
      break;
    }
  }
  assert(StoreTy && "Failed to find store type");

  unsigned Sz = DL.getTypeSizeInBits(StoreTy);
  unsigned AS = S0->getPointerAddressSpace();
  unsigned VecRegSize = TTI.getLoadStoreVecRegBitWidth(AS);
  unsigned VF = VecRegSize / Sz;
  unsigned ChainSize = Chain.size();
  Align Alignment = S0->getAlign();

  if (!isPowerOf2_32(Sz) || VF < 2 || ChainSize < 2) {
    InstructionsProcessed->insert(Chain.begin(), Chain.end());
    return false;
  }

  ArrayRef<Instruction *> NewChain = getVectorizablePrefix(Chain);
  if (NewChain.empty()) {
    // No vectorization possible.
    InstructionsProcessed->insert(Chain.begin(), Chain.end());
    return false;
  }
  if (NewChain.size() == 1) {
    // Failed after the first instruction. Discard it and try the smaller chain.
    InstructionsProcessed->insert(NewChain.front());
    return false;
  }

  // Update Chain to the valid vectorizable subchain.
  Chain = NewChain;
  ChainSize = Chain.size();

  // Check if it's legal to vectorize this chain. If not, split the chain and
  // try again.
  unsigned EltSzInBytes = Sz / 8;
  unsigned SzInBytes = EltSzInBytes * ChainSize;

  FixedVectorType *VecTy;
  auto *VecStoreTy = dyn_cast<FixedVectorType>(StoreTy);
  if (VecStoreTy)
    VecTy = FixedVectorType::get(StoreTy->getScalarType(),
                                 Chain.size() * VecStoreTy->getNumElements());
  else
    VecTy = FixedVectorType::get(StoreTy, Chain.size());

  // If it's more than the max vector size or the target has a better
  // vector factor, break it into two pieces.
  unsigned TargetVF = TTI.getStoreVectorFactor(VF, Sz, SzInBytes, VecTy);
  if (ChainSize > VF || (VF != TargetVF && TargetVF < ChainSize)) {
    LLVM_DEBUG(dbgs() << "LSV: Chain doesn't match with the vector factor."
                         " Creating two separate arrays.\n");
    return vectorizeStoreChain(Chain.slice(0, TargetVF),
                               InstructionsProcessed) |
           vectorizeStoreChain(Chain.slice(TargetVF), InstructionsProcessed);
  }

  LLVM_DEBUG({
    dbgs() << "LSV: Stores to vectorize:\n";
    for (Instruction *I : Chain)
      dbgs() << "  " << *I << "\n";
  });

  // We won't try again to vectorize the elements of the chain, regardless of
  // whether we succeed below.
  InstructionsProcessed->insert(Chain.begin(), Chain.end());

  // If the store is going to be misaligned, don't vectorize it.
  if (accessIsMisaligned(SzInBytes, AS, Alignment)) {
    if (S0->getPointerAddressSpace() != DL.getAllocaAddrSpace()) {
      auto Chains = splitOddVectorElts(Chain, Sz);
      return vectorizeStoreChain(Chains.first, InstructionsProcessed) |
             vectorizeStoreChain(Chains.second, InstructionsProcessed);
    }

    Align NewAlign = getOrEnforceKnownAlignment(S0->getPointerOperand(),
                                                Align(StackAdjustedAlignment),
                                                DL, S0, nullptr, &DT);
    if (NewAlign >= Alignment)
      Alignment = NewAlign;
    else
      return false;
  }

  if (!TTI.isLegalToVectorizeStoreChain(SzInBytes, Alignment, AS)) {
    auto Chains = splitOddVectorElts(Chain, Sz);
    return vectorizeStoreChain(Chains.first, InstructionsProcessed) |
           vectorizeStoreChain(Chains.second, InstructionsProcessed);
  }

  BasicBlock::iterator First, Last;
  std::tie(First, Last) = getBoundaryInstrs(Chain);
  Builder.SetInsertPoint(&*Last);

  Value *Vec = UndefValue::get(VecTy);

  if (VecStoreTy) {
    unsigned VecWidth = VecStoreTy->getNumElements();
    for (unsigned I = 0, E = Chain.size(); I != E; ++I) {
      StoreInst *Store = cast<StoreInst>(Chain[I]);
      for (unsigned J = 0, NE = VecStoreTy->getNumElements(); J != NE; ++J) {
        unsigned NewIdx = J + I * VecWidth;
        Value *Extract = Builder.CreateExtractElement(Store->getValueOperand(),
                                                      Builder.getInt32(J));
        if (Extract->getType() != StoreTy->getScalarType())
          Extract = Builder.CreateBitCast(Extract, StoreTy->getScalarType());

        Value *Insert =
            Builder.CreateInsertElement(Vec, Extract, Builder.getInt32(NewIdx));
        Vec = Insert;
      }
    }
  } else {
    for (unsigned I = 0, E = Chain.size(); I != E; ++I) {
      StoreInst *Store = cast<StoreInst>(Chain[I]);
      Value *Extract = Store->getValueOperand();
      if (Extract->getType() != StoreTy->getScalarType())
        Extract =
            Builder.CreateBitOrPointerCast(Extract, StoreTy->getScalarType());

      Value *Insert =
          Builder.CreateInsertElement(Vec, Extract, Builder.getInt32(I));
      Vec = Insert;
    }
  }

  StoreInst *SI = Builder.CreateAlignedStore(
    Vec,
    Builder.CreateBitCast(S0->getPointerOperand(), VecTy->getPointerTo(AS)),
    Alignment);
  propagateMetadata(SI, Chain);

  eraseInstructions(Chain);
  ++ColossusNumVectorInstructions;
  ColossusNumScalarsVectorized += Chain.size();
  return true;
}

bool Vectorizer::vectorizeLoadChain(
    ArrayRef<Instruction *> Chain,
    SmallPtrSet<Instruction *, 16> *InstructionsProcessed) {
  LoadInst *L0 = cast<LoadInst>(Chain[0]);

  // If the vector has an int element, default to int for the whole load.
  Type *LoadTy = nullptr;
  for (const auto &V : Chain) {
    LoadTy = cast<LoadInst>(V)->getType();
    if (LoadTy->isIntOrIntVectorTy())
      break;

    if (LoadTy->isPtrOrPtrVectorTy()) {
      LoadTy = Type::getIntNTy(F.getParent()->getContext(),
                               DL.getTypeSizeInBits(LoadTy));
      break;
    }
  }
  assert(LoadTy && "Can't determine LoadInst type from chain");

  unsigned Sz = DL.getTypeSizeInBits(LoadTy);
  unsigned AS = L0->getPointerAddressSpace();
  unsigned VecRegSize = TTI.getLoadStoreVecRegBitWidth(AS);
  unsigned VF = VecRegSize / Sz;
  unsigned ChainSize = Chain.size();
  Align Alignment = L0->getAlign();

  if (!isPowerOf2_32(Sz) || VF < 2 || ChainSize < 2) {
    InstructionsProcessed->insert(Chain.begin(), Chain.end());
    return false;
  }

  ArrayRef<Instruction *> NewChain = getVectorizablePrefix(Chain);
  if (NewChain.empty()) {
    // No vectorization possible.
    InstructionsProcessed->insert(Chain.begin(), Chain.end());
    return false;
  }
  if (NewChain.size() == 1) {
    // Failed after the first instruction. Discard it and try the smaller chain.
    InstructionsProcessed->insert(NewChain.front());
    return false;
  }

  // Update Chain to the valid vectorizable subchain.
  Chain = NewChain;
  ChainSize = Chain.size();

  // Check if it's legal to vectorize this chain. If not, split the chain and
  // try again.
  unsigned EltSzInBytes = Sz / 8;
  unsigned SzInBytes = EltSzInBytes * ChainSize;
  VectorType *VecTy;
  auto *VecLoadTy = dyn_cast<FixedVectorType>(LoadTy);
  if (VecLoadTy)
    VecTy = FixedVectorType::get(LoadTy->getScalarType(),
                                 Chain.size() * VecLoadTy->getNumElements());
  else
    VecTy = FixedVectorType::get(LoadTy, Chain.size());

  // If it's more than the max vector size or the target has a better
  // vector factor, break it into two pieces.
  unsigned TargetVF = TTI.getLoadVectorFactor(VF, Sz, SzInBytes, VecTy);
  if (ChainSize > VF || (VF != TargetVF && TargetVF < ChainSize)) {
    LLVM_DEBUG(dbgs() << "LSV: Chain doesn't match with the vector factor."
                         " Creating two separate arrays.\n");
    return vectorizeLoadChain(Chain.slice(0, TargetVF), InstructionsProcessed) |
           vectorizeLoadChain(Chain.slice(TargetVF), InstructionsProcessed);
  }

  // We won't try again to vectorize the elements of the chain, regardless of
  // whether we succeed below.
  InstructionsProcessed->insert(Chain.begin(), Chain.end());

  // If the load is going to be misaligned, don't vectorize it.
  if (accessIsMisaligned(SzInBytes, AS, Alignment)) {
    if (L0->getPointerAddressSpace() != DL.getAllocaAddrSpace()) {
      auto Chains = splitOddVectorElts(Chain, Sz);
      return vectorizeLoadChain(Chains.first, InstructionsProcessed) |
             vectorizeLoadChain(Chains.second, InstructionsProcessed);
    }

    Align NewAlign = getOrEnforceKnownAlignment(L0->getPointerOperand(),
                                                Align(StackAdjustedAlignment),
                                                DL, L0, nullptr, &DT);
    if (NewAlign >= Alignment)
      Alignment = NewAlign;
    else
      return false;
  }

  if (!TTI.isLegalToVectorizeLoadChain(SzInBytes, Alignment, AS)) {
    auto Chains = splitOddVectorElts(Chain, Sz);
    return vectorizeLoadChain(Chains.first, InstructionsProcessed) |
           vectorizeLoadChain(Chains.second, InstructionsProcessed);
  }

  LLVM_DEBUG({
    dbgs() << "LSV: Loads to vectorize:\n";
    for (Instruction *I : Chain)
      I->dump();
  });

  // getVectorizablePrefix already computed getBoundaryInstrs.  The value of
  // Last may have changed since then, but the value of First won't have.  If it
  // matters, we could compute getBoundaryInstrs only once and reuse it here.
  BasicBlock::iterator First, Last;
  std::tie(First, Last) = getBoundaryInstrs(Chain);
  Builder.SetInsertPoint(&*First);

  Value *Bitcast =
      Builder.CreateBitCast(L0->getPointerOperand(), VecTy->getPointerTo(AS));
  LoadInst *LI =
      Builder.CreateAlignedLoad(VecTy, Bitcast, MaybeAlign(Alignment));
  propagateMetadata(LI, Chain);

  if (VecLoadTy) {
    SmallVector<Instruction *, 16> InstrsToErase;

    unsigned VecWidth = VecLoadTy->getNumElements();
    for (unsigned I = 0, E = Chain.size(); I != E; ++I) {
      for (auto Use : Chain[I]->users()) {
        // All users of vector loads are ExtractElement instructions with
        // constant indices, otherwise we would have bailed before now.
        Instruction *UI = cast<Instruction>(Use);
        unsigned Idx = cast<ConstantInt>(UI->getOperand(1))->getZExtValue();
        unsigned NewIdx = Idx + I * VecWidth;
        Value *V = Builder.CreateExtractElement(LI, Builder.getInt32(NewIdx),
                                                UI->getName());
        if (V->getType() != UI->getType())
          V = Builder.CreateBitCast(V, UI->getType());

        // Replace the old instruction.
        UI->replaceAllUsesWith(V);
        InstrsToErase.push_back(UI);
      }
    }

    // Since we might have opaque pointers we might end up using the pointer
    // operand of the first load (wrt. memory loaded) for the vector load. Since
    // this first load might not be the first in the block we potentially need
    // to reorder the pointer operand (and its operands). If we have a bitcast
    // though it might be before the load and should be the reorder start
    // instruction. "Might" because for opaque pointers the "bitcast" is just
    // the first loads pointer operand, as oppposed to something we inserted at
    // the right position ourselves.
    Instruction *BCInst = dyn_cast<Instruction>(Bitcast);
    reorder((BCInst && BCInst != L0->getPointerOperand()) ? BCInst : LI);

    for (auto I : InstrsToErase)
      I->eraseFromParent();
  } else {
    for (unsigned I = 0, E = Chain.size(); I != E; ++I) {
      Value *CV = Chain[I];
      Value *V =
          Builder.CreateExtractElement(LI, Builder.getInt32(I), CV->getName());
      if (V->getType() != CV->getType()) {
        V = Builder.CreateBitOrPointerCast(V, CV->getType());
      }

      // Replace the old instruction.
      CV->replaceAllUsesWith(V);
    }

    // Since we might have opaque pointers we might end up using the pointer
    // operand of the first load (wrt. memory loaded) for the vector load. Since
    // this first load might not be the first in the block we potentially need
    // to reorder the pointer operand (and its operands). If we have a bitcast
    // though it might be before the load and should be the reorder start
    // instruction. "Might" because for opaque pointers the "bitcast" is just
    // the first loads pointer operand, as oppposed to something we inserted at
    // the right position ourselves.
    Instruction *BCInst = dyn_cast<Instruction>(Bitcast);
    reorder((BCInst && BCInst != L0->getPointerOperand()) ? BCInst : LI);
  }

  eraseInstructions(Chain);

  ++ColossusNumVectorInstructions;
  ColossusNumScalarsVectorized += Chain.size();
  return true;
}

bool Vectorizer::accessIsMisaligned(unsigned SzInBytes, unsigned AddressSpace,
                                    Align Alignment) {
  if (Alignment.value() % SzInBytes == 0)
    return false;

  bool Fast = false;
  bool Allows = TTI.allowsMisalignedMemoryAccesses(F.getParent()->getContext(),
                                                   SzInBytes * 8, AddressSpace,
                                                   Alignment, &Fast);
  LLVM_DEBUG(dbgs() << "LSV: Target said misaligned is allowed? " << Allows
                    << " and fast? " << Fast << "\n";);
  return !Allows || !Fast;
}
