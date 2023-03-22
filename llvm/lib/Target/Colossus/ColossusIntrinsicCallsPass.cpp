//===-- ColossusIntrinsicCalls.cpp - Convert known calls to IR intrinsics -===//
//    Copyright (c) 2022 Graphcore Ltd. All Rights Reserved.
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
//
//===----------------------------------------------------------------------===//

#define DEBUG_TYPE "colossus-intrinsic-calls"
#define COLOSSUS_INTRINSIC_CALLS_PASS_NAME "Colossus intrinsic calls pass"

#include "Colossus.h"

#include "llvm/ADT/StringSwitch.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/IntrinsicInst.h"
#include "llvm/IR/IntrinsicsColossus.h"
#include "llvm/Pass.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/MathExtras.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Target/TargetOptions.h"

using namespace llvm;
namespace {

class ColossusIntrinsicCalls {
  Function &F;

public:
  ColossusIntrinsicCalls(Function &F) : F(F) {}
  bool run();
};

class ColossusIntrinsicCallsLegacyPass : public FunctionPass {
public:
  static char ID;
  ColossusIntrinsicCallsLegacyPass() : FunctionPass(ID) {}

  bool runOnFunction(Function &F) override {
    ColossusIntrinsicCalls IntrinsicCall(F);
    return IntrinsicCall.run();
  }
  StringRef getPassName() const override {
    return COLOSSUS_INTRINSIC_CALLS_PASS_NAME;
  }
};
} // namespace
char ColossusIntrinsicCallsLegacyPass::ID = 0;

static RegisterPass<ColossusIntrinsicCallsLegacyPass>
    reg(DEBUG_TYPE, COLOSSUS_INTRINSIC_CALLS_PASS_NAME, false, false);

FunctionPass *llvm::createColossusIntrinsicCallsPass() {
  return new ColossusIntrinsicCallsLegacyPass();
}

PreservedAnalyses ColossusIntrinsicCallsPass::run(Function &F,
                                                  FunctionAnalysisManager &AM) {
  ColossusIntrinsicCalls IntrinsicCall(F);
  bool Changed = IntrinsicCall.run();
  return Changed ? PreservedAnalyses::none() : PreservedAnalyses::all();
}

bool ColossusIntrinsicCalls::run() {
  LLVMContext &ctx = F.getContext();
  Module *M = F.getParent();

  auto strToType = [&](StringRef name) -> Type * {
    auto h = Type::getHalfTy(ctx);
    auto f = Type::getFloatTy(ctx);
    auto i32 = Type::getInt32Ty(ctx);
    auto i16 = Type::getInt16Ty(ctx);
    auto i8 = Type::getInt8Ty(ctx);
    return StringSwitch<Type *>(name)
        .Case("half", h)
        .Case("half2", FixedVectorType::get(h, 2))
        .Case("half4", FixedVectorType::get(h, 4))
        .Case("float", f)
        .Case("float2", FixedVectorType::get(f, 2))
        .Case("int", i32)
        .Case("uint", i32)
        .Case("int2", FixedVectorType::get(i32, 2))
        .Case("uint2", FixedVectorType::get(i32, 2))
        .Case("short", i16)
        .Case("ushort", i16)
        .Case("short2", FixedVectorType::get(i16, 2))
        .Case("ushort2", FixedVectorType::get(i16, 2))
        .Case("short4", FixedVectorType::get(i16, 4))
        .Case("ushort4", FixedVectorType::get(i16, 4))
        .Case("char", i8)
        .Case("uchar", i8)
        .Default(nullptr);
  };

  auto replaceStoreIntrinsic = [&](CallInst *CI, StringRef name) {
    IRBuilder<> Builder(CI);
    auto addr = CI->getOperand(0);
    auto value = CI->getOperand(1);
    auto incr = CI->getOperand(2);
    {
      Type *polyType = strToType(name);
      Function *TheFn =
          Intrinsic::getDeclaration(M, Intrinsic::colossus_ststep, {polyType});

      Type *LoadTy = polyType->getPointerTo();
      auto I8PtrTy = Type::getInt8Ty(ctx)->getPointerTo();
      auto loaded =
          Builder.CreateBitCast(Builder.CreateLoad(LoadTy, addr), I8PtrTy);
      CallInst *intrinCall = Builder.CreateCall(TheFn, {value, loaded, incr});
      Builder.CreateStore(Builder.CreateBitCast(intrinCall, LoadTy), addr);

      // The function returned void so has no uses to replace
      CI->eraseFromParent();
      return true;
    }
    return false;
  };

  auto replaceLoadIntrinsic = [&](CallInst *CI, StringRef name) {
    IRBuilder<> Builder(CI);
    auto addr = CI->getOperand(0);
    auto incr = CI->getOperand(1);
    {
      Type *polyType = strToType(name);
      Function *TheFn =
          Intrinsic::getDeclaration(M, Intrinsic::colossus_ldstep, {polyType});

      Type *LoadTy = polyType->getPointerTo();
      auto loaded = Builder.CreateLoad(LoadTy, addr);
      CallInst *intrinCall = Builder.CreateCall(TheFn, {loaded, incr});
      Value *resValue = Builder.CreateExtractValue(intrinCall, {0});
      Value *resAddr = Builder.CreateExtractValue(intrinCall, {1});
      Builder.CreateStore(resAddr, addr);

      CI->replaceAllUsesWith(resValue);
      CI->eraseFromParent();
      return true;
    }
    return false;
  };

  bool Changed = false;
  for (auto &BB : F) {
    for (BasicBlock::iterator I = BB.begin(), E = BB.end(); I != E;) {
      // Ignore non-calls.
      CallInst *CI = dyn_cast<CallInst>(I);
      ++I;
      if (!CI) {
        continue;
      }
      // Ignore indirect calls and intrinsics
      Function *Callee = CI->getCalledFunction();
      if (!Callee || Callee->isIntrinsic()) {
        continue;
      }

      FunctionType *Ty = Callee->getFunctionType();
      unsigned arity = CI->arg_size();
      auto name = Callee->getName();

      const char *prefix = "ipu_";
      if (!name.startswith(prefix)) {
        continue;
      }
      name = name.slice(strlen(prefix), StringRef::npos);

      const char *storeSuffix = "_store_postinc";
      const char *loadSuffix = "_load_postinc";

      auto storeTypesOK = [&](StringRef typeName) {
        // void (*ipu_T_store_postinc)(T** %a, T %v, i32 %i)
        Type *reqValueType = strToType(typeName);
        if (!reqValueType || (reqValueType->getPrimitiveSizeInBits() < 32)) {
          return false;
        }
        Type *storePrototype[4] = {
            Type::getVoidTy(ctx),
            reqValueType->getPointerTo()->getPointerTo(),
            reqValueType,
            Type::getInt32Ty(ctx),
        };
        Type *callPrototype[4] = {
            Ty->getReturnType(),
            CI->getOperand(0)->getType(),
            CI->getOperand(1)->getType(),
            CI->getOperand(2)->getType(),
        };
        for (unsigned i = 0; i < 4; i++) {
          if (storePrototype[i] != callPrototype[i]) {
            return false;
          }
        }
        return true;
      };

      auto loadTypesOK = [&](StringRef typeName) {
        // T (*ipu_T_load_postinc)(T** %a, i32 %i)
        Type *reqValueType = strToType(typeName);
        if (!reqValueType) {
          return false;
        }
        Type *loadPrototype[3] = {
            reqValueType,
            reqValueType->getPointerTo()->getPointerTo(),
            Type::getInt32Ty(ctx),
        };
        Type *callPrototype[3] = {
            Ty->getReturnType(),
            CI->getOperand(0)->getType(),
            CI->getOperand(1)->getType(),
        };
        for (unsigned i = 0; i < 3; i++) {
          if (loadPrototype[i] != callPrototype[i]) {
            return false;
          }
        }
        return true;
      };

      // void (*ipu_T_store_postinc)(T** %a, T %v, i32 %i)
      //   =>
      // T* (*colossus_ststep) (T %v, T* %a, i32 %i)
      if (arity == 3 && name.endswith(storeSuffix)) {
        name = name.slice(0, name.size() - strlen(storeSuffix));
        if (storeTypesOK(name)) {
          if (replaceStoreIntrinsic(CI, name)) {
            Changed = true;
            LLVM_DEBUG(
                dbgs() << "ColossusIntrinsicCalls: Replace call to "
                       << Callee->getName() << " with "
                       << Intrinsic::getName(Intrinsic::colossus_ststep,
                                             {strToType(name), strToType(name)},
                                             CI->getModule())
                       << "\n";);
          }
        }
      }

      // T (*ipu_T_load_postinc)(T** %a, i32 %i)
      //   =>
      // {T, T*} (*colossus_ldstep)(T* %a, i32 %i)
      if (arity == 2 && name.endswith(loadSuffix)) {
        name = name.slice(0, name.size() - strlen(loadSuffix));
        if (loadTypesOK(name)) {
          if (replaceLoadIntrinsic(CI, name)) {
            Changed = true;
            LLVM_DEBUG(dbgs() << "ColossusIntrinsicCalls: Replace call to "
                              << Callee->getName() << " with "
                              << Intrinsic::getName(Intrinsic::colossus_ldstep,
                                                    {strToType(name)},
                                                    CI->getModule())
                              << "\n";);
          }
        }
      }
    }
  }

  return Changed;
}
