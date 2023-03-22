//===-- ColossusLoopConversionPass - IR level conversion of hwloop intr ---===//
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
// Looks for any HardwareLoops intrinsics and mechanically converts them to the
// Colossus equivalent intrinsics. Any decision logic is located in Colossus'
// TargetTransformInfo::isHardwareLoopProfitable.
//
//===----------------------------------------------------------------------===//

#include "Colossus.h"
#include "ColossusCountedLoopOptions.h"
#include "ColossusSubtarget.h"
#include "llvm/Analysis/LoopInfo.h"
#include "llvm/CodeGen/TargetPassConfig.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/IntrinsicInst.h"
#include "llvm/IR/IntrinsicsColossus.h"
#include "llvm/InitializePasses.h"
#include "llvm/Pass.h"
#include "llvm/Support/Debug.h"
#include "llvm/Transforms/Utils/Local.h"
#include "llvm/Transforms/Utils/LoopUtils.h"

using namespace llvm;
#define DEBUG_TYPE "colossus-loop-conversion"
#define PASS_NAME "Colossus loop conversion"

namespace {
using md = Colossus::CountedLoop::metadata;
class ColossusLoopConversion : public FunctionPass {
  LoopInfo *LI;
  LLVMContext *ctx;
  Module *M;

public:
  static char ID;
  ColossusLoopConversion() : FunctionPass(ID) {}

  bool runOnFunction(Function &F) override;
  StringRef getPassName() const override { return PASS_NAME; }

  void getAnalysisUsage(AnalysisUsage &AU) const override {
    AU.addRequired<LoopInfoWrapperPass>();
  }

private:
  Value *processIterIntr(BasicBlock *BB, IntrinsicInst *II, md Metadata);
  bool processIntr(BasicBlock *BB, IntrinsicInst *II);
  BasicBlock *processLoopGuardIntr(BasicBlock *Predecessor, IntrinsicInst *II);
  void processTestSetIntr(BasicBlock *Predecessor, IntrinsicInst *II);
  void processTestStartIntr(BasicBlock *Predecessor, IntrinsicInst *II);
  void processSetIntr(BasicBlock *Preheader, IntrinsicInst *II);
  void processStartIntr(BasicBlock *BB, IntrinsicInst *II);
  void processDecRegIntr(BasicBlock *BB, IntrinsicInst *II);
};
} // namespace
char ColossusLoopConversion::ID = 0;

INITIALIZE_PASS_BEGIN(ColossusLoopConversion, DEBUG_TYPE, PASS_NAME, false,
                      false)
INITIALIZE_PASS_DEPENDENCY(HardwareLoops)
INITIALIZE_PASS_DEPENDENCY(LoopInfoWrapperPass)
INITIALIZE_PASS_END(ColossusLoopConversion, DEBUG_TYPE, PASS_NAME, false, false)

FunctionPass *llvm::createColossusLoopConversionPass() {
  return new ColossusLoopConversion();
}

namespace {

bool isCallIntrID(const CallInst *CI, Intrinsic::ID IID) {
  return CI != nullptr && CI->getIntrinsicID() == IID;
}

Instruction *findHwLoopIntrinsic(BasicBlock *BB, Intrinsic::ID IID) {
  auto isIntIDInst = [&IID](Instruction &I) {
    return isCallIntrID(dyn_cast<CallInst>(&I), IID);
  };
  auto Inst = std::find_if(BB->begin(), BB->end(), isIntIDInst);
  return Inst != BB->end() ? &(*Inst) : nullptr;
}

} // namespace

Value *ColossusLoopConversion::processIterIntr(BasicBlock *BB,
                                               IntrinsicInst *II, md Metadata) {
  auto I32Ty = Type::getInt32Ty(*ctx);
  auto I64Ty = Type::getInt64Ty(*ctx);
  auto metadata = ConstantInt::get(I32Ty, static_cast<uint16_t>(Metadata));

  IRBuilder<> SLIIBuilder(II);
  Value *counter = II->getOperand(0);
  bool isi64TC = counter->getType()->getIntegerBitWidth() == 64;
  Value *zextTruncCounter = SLIIBuilder.CreateZExtOrTrunc(counter, I32Ty);
  Function *func =
      Intrinsic::getDeclaration(M, Intrinsic::colossus_cloop_begin);
  CallInst *cloopBeginCall =
      SLIIBuilder.CreateCall(func, {zextTruncCounter, metadata}, "cloop.begin");
  Value *cloopBegin = isi64TC
                          ? SLIIBuilder.CreateZExtOrTrunc(cloopBeginCall, I64Ty)
                          : cloopBeginCall;
  return cast<Value>(cloopBegin);
}

BasicBlock *
ColossusLoopConversion::processLoopGuardIntr(BasicBlock *Predecessor,
                                             IntrinsicInst *II) {

  // Expecting either:
  // %0 = call { i32, i1 } @llvm.test.start.loop.iterations.i32(i32 %x)
  // %1 = extractvalue { i32, i1 } %0, 1
  // %2 = extractvalue { i32, i1 } %0, 0
  // br i1 %1, label %for.body.preheader, label %End
  // Or:
  // %0 = call i1 @llvm.test.set.loop.iterations.i32(i32 %x)
  // br i1 %0, label %for.body.preheader, label %for.cond.cleanup

  BranchInst *BI = cast<BranchInst>(Predecessor->getTerminator());

  Value *counter = II->getOperand(0);

  BasicBlock *Preheader = BI->getSuccessor(0);

  IRBuilder<> Builder(Predecessor->getTerminator());
  auto I32Ty = Type::getInt32Ty(*ctx);
  auto metadata = ConstantInt::get(I32Ty, 0); // Metadata unused for now.
  Value *zextTruncCounter = Builder.CreateZExtOrTrunc(counter, I32Ty);

  Function *func =
      Intrinsic::getDeclaration(M, Intrinsic::colossus_cloop_guard);
  CallInst *cloopGuardCall =
      Builder.CreateCall(func, {zextTruncCounter, metadata}, "cloop.guard");

  auto I1Ty = Type::getInt1Ty(*ctx);
  Value *TruncCloopGuard =
      Builder.CreateZExtOrTrunc(cloopGuardCall, I1Ty, "cloop.guard.trunc");
  BI->setCondition(TruncCloopGuard);

  // BranchProbabilityInfo.cpp would normally assign branch weights of 12-20 if
  // it sees a cond branch based on a compare with 0. We set these weights
  // manually to preserve those probabilities after replacing the compare with
  // the intrinsic.
  SmallVector<Metadata *, 3> weights = {
      MDString::get(*ctx, "branch_weights"),
      ValueAsMetadata::getConstant(ConstantInt::get(I32Ty, 20)),
      ValueAsMetadata::getConstant(ConstantInt::get(I32Ty, 12))};
  MDNode *branchWeights = MDNode::get(*ctx, weights);
  BI->setMetadata("prof", branchWeights);

  // Move this intrinsic to the preheader as if it was a set.loop.iterations or
  // start.loop.iterations intrinsic, then process it normally.
  II->moveBefore(Preheader->getFirstNonPHI());

  return Preheader;
}

void ColossusLoopConversion::processTestSetIntr(BasicBlock *Predecessor,
                                                IntrinsicInst *II) {
  // Expecting:
  // %0 = call i1 @llvm.test.set.loop.iterations.i32(i32 %x)
  // br i1 %0, label %for.body.preheader, label %for.cond.cleanup
  assert((cast<Value>(II) ==
          cast<BranchInst>(Predecessor->getTerminator())->getCondition()) &&
         "Malformed Loop Guard Intrinsic");
  BasicBlock *Preheader = processLoopGuardIntr(Predecessor, II);
  // Move this intrinsic to the preheader as if it was a set.loop.iterations
  // intrinsic, then process it normally.
  II->moveBefore(Preheader->getTerminator());
  processSetIntr(Preheader, II);
}

void ColossusLoopConversion::processTestStartIntr(BasicBlock *Predecessor,
                                                  IntrinsicInst *II) {
  // Expecting:
  // %0 = call { i32, i1 } @llvm.test.start.loop.iterations.i32(i32 %x)
  // %1 = extractvalue { i32, i1 } %0, 1
  // %2 = extractvalue { i32, i1 } %0, 0
  ExtractValueInst *ExtractCompare =
      cast<ExtractValueInst>(II->getNextNonDebugInstruction());
  ExtractValueInst *ExtractCounter =
      cast<ExtractValueInst>(ExtractCompare->getNextNonDebugInstruction());
  assert((cast<Value>(ExtractCompare) ==
          cast<BranchInst>(Predecessor->getTerminator())->getCondition()) &&
         "Malformed Loop Guard Intrinsic");
  assert(ExtractCompare->getOperand(0) == cast<Value>(II) &&
         *(ExtractCompare->idx_begin()) == 1 &&
         ExtractCompare->getNumIndices() == 1);
  assert(ExtractCounter->getOperand(0) == cast<Value>(II) &&
         *(ExtractCounter->idx_begin()) == 0 &&
         ExtractCompare->getNumIndices() == 1);

  BasicBlock *Preheader = processLoopGuardIntr(Predecessor, II);

  // Create a start.loop.iterations intrinsic, then process it normally.
  IRBuilder<> Builder(Preheader->getTerminator());
  Value *counter = II->getOperand(0);
  Function *startIntr = Intrinsic::getDeclaration(
      M, Intrinsic::start_loop_iterations, counter->getType());
  IntrinsicInst *startLoopCall =
      cast<IntrinsicInst>(Builder.CreateCall(startIntr, counter));
  ExtractCounter->replaceAllUsesWith(startLoopCall);
  ExtractCompare->eraseFromParent();
  ExtractCounter->eraseFromParent();
  II->eraseFromParent();
  processStartIntr(Preheader, startLoopCall);
}

void ColossusLoopConversion::processSetIntr(BasicBlock *Preheader,
                                            IntrinsicInst *II) {
  auto I32Ty = Type::getInt32Ty(*ctx);
  Value *counter = processIterIntr(Preheader, II, md::tripCountOKForRpt);
  auto metadata =
      ConstantInt::get(I32Ty, static_cast<uint16_t>(md::tripCountOKForRpt));
  II->eraseFromParent();

  // The preheader successor will be the loop's header.
  Loop *L = LI->getLoopFor(Preheader->getSingleSuccessor());

  SmallVector<BasicBlock*, 4> ExitingBlocks;
  L->getExitingBlocks(ExitingBlocks);

  auto *LoopDecInstr = [&]() -> Instruction* {
    for (BasicBlock *LoopBB : ExitingBlocks) {
      if (auto *Inst = findHwLoopIntrinsic(LoopBB, Intrinsic::loop_decrement))
        return Inst;
    }
    return nullptr;
  }();

  BasicBlock *Header = L->getHeader();
  BasicBlock *Latch = L->getLoopLatch();

  assert(LoopDecInstr && "Latch must contain loop_decrement intrinsic.");

  // Put the PHI in the loop header.
  IRBuilder<> HeaderBuilder(Header->getFirstNonPHI());
  PHINode *loopPhi =
      HeaderBuilder.CreatePHI(LoopDecInstr->getOperand(0)->getType(), 2);
  loopPhi->addIncoming(counter, Preheader);

  // Replace loop_decrement intrinsic w/ Colossus equivalent.
  IRBuilder<> DecBuilder(LoopDecInstr);
  Value *zextTruncPhi = DecBuilder.CreateZExtOrTrunc(loopPhi, I32Ty);
  CallInst *cloopEnd = DecBuilder.CreateCall(
      Intrinsic::getDeclaration(M, Intrinsic::colossus_cloop_end),
      {zextTruncPhi, metadata}, "cloop.end");

  Value *indVar =
      DecBuilder.CreateExtractValue(cloopEnd, 0, "cloop.end.iv");
  Value *cc = DecBuilder.CreateExtractValue(cloopEnd, 1, "cloop.end.cc");

  Value *truncCC =
      DecBuilder.CreateTrunc(cc, Type::getInt1Ty(*ctx), "cloop.end.cc.trunc");

  // If counter is 64b, make indVar 64b as well so phi gets arguments of the
  // same type.
  auto I64Ty = Type::getInt64Ty(*ctx);
  bool isi64TC = counter->getType()->getIntegerBitWidth() == 64;
  indVar = isi64TC ? DecBuilder.CreateZExtOrTrunc(indVar, I64Ty) : indVar;

  LoopDecInstr->replaceAllUsesWith(truncCC);
  loopPhi->addIncoming(indVar, Latch);
  LoopDecInstr->eraseFromParent();
}

void ColossusLoopConversion::processStartIntr(BasicBlock *BB,
                                              IntrinsicInst *II) {
  Value *counter = processIterIntr(BB, II, md::none);

  II->replaceAllUsesWith(counter);
  II->eraseFromParent();
}

void ColossusLoopConversion::processDecRegIntr(BasicBlock *BB,
                                               IntrinsicInst *II) {
  auto *I32Ty = Type::getInt32Ty(*ctx);
  auto *I64Ty = Type::getInt64Ty(*ctx);
  auto metadata = ConstantInt::get(I32Ty, static_cast<uint16_t>(md::none));
  bool isi64TC = II->getType()->getIntegerBitWidth() == 64;
  // Find the IV phi node and replace the variable passed from outside the loop
  // to the one returned by the hardware loop initializer (i.e. cloop.begin).
  PHINode *loopPhi = dyn_cast<PHINode>(II->getOperand(0));
  IRBuilder<> DecBuilder(II);
  Value *zextTruncPhi = DecBuilder.CreateZExtOrTrunc(loopPhi, I32Ty);
  CallInst *cloopEnd = DecBuilder.CreateCall(
      Intrinsic::getDeclaration(M, Intrinsic::colossus_cloop_end),
      {zextTruncPhi, metadata}, "cloop.end");

  Value *exactIndVar =
      DecBuilder.CreateExtractValue(cloopEnd, 0, "cloop.end.iv");
  Value *cc = DecBuilder.CreateExtractValue(cloopEnd, 1, "cloop.end.cc");

  Value *indVar =
      isi64TC ? DecBuilder.CreateZExtOrTrunc(exactIndVar, I64Ty) : exactIndVar;
  Value *truncCC =
      DecBuilder.CreateTrunc(cc, Type::getInt1Ty(*ctx), "cloop.end.cc.trunc");

  BranchInst *TI = dyn_cast<BranchInst>(BB->getTerminator());
  Value *deadCond = TI->getCondition();
  TI->setCondition(truncCC);
  RecursivelyDeleteTriviallyDeadInstructions(deadCond);

  II->replaceAllUsesWith(indVar);
  II->eraseFromParent();
}

bool ColossusLoopConversion::processIntr(BasicBlock *BB, IntrinsicInst *II) {
  switch (II->getIntrinsicID()) {
  default:
    llvm_unreachable("Unsupported intrinsic.");
  case Intrinsic::test_start_loop_iterations:
    processTestStartIntr(BB, II);
    break;
  case Intrinsic::test_set_loop_iterations:
    processTestSetIntr(BB, II);
    break;
  case Intrinsic::set_loop_iterations:
    processSetIntr(BB, II);
    break;
  case Intrinsic::start_loop_iterations:
    processStartIntr(BB, II);
    break;
  case Intrinsic::loop_decrement_reg:
    processDecRegIntr(BB, II);
    break;
  }
  return true;
}

bool ColossusLoopConversion::runOnFunction(Function &F) {
  SmallVector<IntrinsicInst *, 4> Intrinsics;
  LI = &getAnalysis<LoopInfoWrapperPass>().getLoopInfo();
  bool changed = false;

  // Filter to find the intrinsics.
  auto MatchIntr = [](const Instruction &I) -> bool {
    auto Intr = dyn_cast<IntrinsicInst>(&I);
    if (!Intr)
      return false;
    switch (Intr->getIntrinsicID()) {
    default:
      return false;
    case Intrinsic::test_set_loop_iterations:
    case Intrinsic::test_start_loop_iterations:
    case Intrinsic::set_loop_iterations:
    case Intrinsic::start_loop_iterations:
    case Intrinsic::loop_decrement_reg:
      return true;
    }
  };

  // Search for the hardware loop intrinsics as emitted by HardwareLoops.
  for (auto BBi = F.begin(); BBi != F.end(); ++BBi) {
    BasicBlock *BB = &(*BBi);
    auto Intrs =
        llvm::make_filter_range(make_range(BB->begin(), BB->end()), MatchIntr);
    for (auto Inst = Intrs.begin(); Inst != Intrs.end(); ++Inst) {
      IntrinsicInst *II = cast<IntrinsicInst>(&(*Inst));
      Intrinsics.push_back(II);
    }
  }

  ctx = &F.getContext();
  M = F.getParent();

  for (auto Intr : Intrinsics) {
    changed |= processIntr(Intr->getParent(), Intr);
  }

  return changed;
}
