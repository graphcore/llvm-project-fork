//===-- ColossusLibmCalls.cpp - Convert libm calls to IR intrinsics ------===//
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
//
//===----------------------------------------------------------------------===//

#include "Colossus.h"

#include "llvm/ADT/StringSwitch.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/IntrinsicInst.h"
#include "llvm/IR/IntrinsicsColossus.h"
#include "llvm/Pass.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Target/TargetOptions.h"

using namespace llvm;
#define DEBUG_TYPE "colossus-libmcalls"
#define COLOSSUS_LIBMCALLS_PASS_NAME "Colossus libm calls pass"
static cl::opt<bool> Disable("disable-" DEBUG_TYPE,
                             cl::desc("Recognise colossus libmcalls"),
                             cl::init(false), cl::Hidden);

namespace {

class ColossusLibmCalls {
  Function &F;

public:
  ColossusLibmCalls(Function &F) : F(F) {}
  bool run();
};

class ColossusLibmCallsLegacyPass : public FunctionPass {
public:
  static char ID;
  ColossusLibmCallsLegacyPass() : FunctionPass(ID) {}

  bool runOnFunction(Function &F) override {
    ColossusLibmCalls LibmCall(F);
    return LibmCall.run();
  }

  StringRef getPassName() const override {
    return COLOSSUS_LIBMCALLS_PASS_NAME;
  }
};
} // namespace

char ColossusLibmCallsLegacyPass::ID = 0;

static RegisterPass<ColossusLibmCallsLegacyPass>
    reg(DEBUG_TYPE, COLOSSUS_LIBMCALLS_PASS_NAME, false, false);

FunctionPass *llvm::createColossusLibmCallsPass() {
  return new ColossusLibmCallsLegacyPass();
}

PreservedAnalyses ColossusLibmCallsPass::run(Function &F,
                                             FunctionAnalysisManager &AM) {
  ColossusLibmCalls LibmCall(F);
  bool Changed = LibmCall.run();
  return Changed ? PreservedAnalyses::none() : PreservedAnalyses::all();
}

bool ColossusLibmCalls::run() {
  if (Disable) {
    return false;
  }

  auto getIntrinsic = [=](StringRef name, Type *Ty, unsigned arity,
                          bool StrictFP) -> unsigned {
    if (name.size() > strlen("floor2_nearbyint")) {
      return Intrinsic::not_intrinsic;
    }

    auto &ctx = Ty->getContext();
    std::array<std::pair<StringRef, Type *>, 4> tab = {
        {{"half_", Type::getHalfTy(ctx)},
         {"half2_", FixedVectorType::get(Type::getHalfTy(ctx), 2)},
         {"half4_", FixedVectorType::get(Type::getHalfTy(ctx), 4)},
         {"float2_", FixedVectorType::get(Type::getFloatTy(ctx), 2)}}};

    std::string local = name.str();
    for (auto &i : tab) {
      if (name.startswith(i.first)) {
        if (Ty == i.second) {
          // prefix matches type, canonicalise to scalar f32 name
          local = local.substr(i.first.size()) + "f";
          break;
        } else {
          return Intrinsic::not_intrinsic;
        }
      }
    }
    if (local == name) { // true iff no prefixes matched
      if (Ty != Type::getFloatTy(ctx)) {
        return Intrinsic::not_intrinsic;
      }
    }

    // "Map" from libm function to tuple <intrinsic in default FP environment,
    // constrained intrinsic, arity>.
    auto r =
        StringSwitch<std::tuple<Intrinsic::ID, Intrinsic::ID, unsigned>>(local)
            .Case("sqrtf", {Intrinsic::sqrt,
                            Intrinsic::experimental_constrained_sqrt, 1})
            .Case("sinf",
                  {Intrinsic::sin, Intrinsic::experimental_constrained_sin, 1})
            .Case("cosf",
                  {Intrinsic::cos, Intrinsic::experimental_constrained_cos, 1})
            .Case("powf",
                  {Intrinsic::pow, Intrinsic::experimental_constrained_pow, 2})
            .Case("expf",
                  {Intrinsic::exp, Intrinsic::experimental_constrained_exp, 1})
            .Case("exp2f", {Intrinsic::exp2,
                            Intrinsic::experimental_constrained_exp2, 1})
            .Case("logf",
                  {Intrinsic::log, Intrinsic::experimental_constrained_log, 1})
            .Case("log10f", {Intrinsic::log10,
                             Intrinsic::experimental_constrained_log10, 1})
            .Case("log2f", {Intrinsic::log2,
                            Intrinsic::experimental_constrained_log2, 1})
            .Case("fmaf",
                  {Intrinsic::fma, Intrinsic::experimental_constrained_fma, 3})
            .Case("fabsf", {Intrinsic::fabs, Intrinsic::fabs, 1})
            .Case("fminf", {Intrinsic::minnum,
                            Intrinsic::experimental_constrained_minnum, 2})
            .Case("fmaxf", {Intrinsic::maxnum,
                            Intrinsic::experimental_constrained_maxnum, 2})
            .Case("copysignf", {Intrinsic::copysign, Intrinsic::copysign, 2})
            .Case("floorf", {Intrinsic::floor,
                             Intrinsic::experimental_constrained_floor, 1})
            .Case("ceilf", {Intrinsic::ceil,
                            Intrinsic::experimental_constrained_ceil, 1})
            .Case("truncf", {Intrinsic::trunc,
                             Intrinsic::experimental_constrained_trunc, 1})
            .Case("rintf", {Intrinsic::rint,
                            Intrinsic::experimental_constrained_rint, 1})
            .Case("nearbyintf",
                  {Intrinsic::nearbyint,
                   Intrinsic::experimental_constrained_nearbyint, 1})
            .Case("roundf", {Intrinsic::round,
                             Intrinsic::experimental_constrained_round, 1})
            .Case("tanhf",
                  {Intrinsic::colossus_tanh, Intrinsic::colossus_tanh, 1})
            .Case("rsqrtf",
                  {Intrinsic::colossus_rsqrt, Intrinsic::colossus_rsqrt, 1})
            .Case("sigmoidf",
                  {Intrinsic::colossus_sigmoid, Intrinsic::colossus_sigmoid, 1})
            .Default({Intrinsic::not_intrinsic, Intrinsic::not_intrinsic, 0});

    if (std::get<2>(r) != arity) {
      return Intrinsic::not_intrinsic;
    }

    return StrictFP ? std::get<1>(r) : std::get<0>(r);
  };

  bool Changed = false;
  const bool StrictFP = F.hasFnAttribute(Attribute::StrictFP);
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
      Type *resTy = Ty->getReturnType();
      // Relevant libm functions are homogenous with arity [1,3]
      if ((CI->arg_size() == 0) || (CI->arg_size() > 3) ||
          !std::all_of(CI->arg_begin(), CI->arg_end(),
                       [=](Value *v) { return resTy == v->getType(); })) {
        continue;
      }

      Intrinsic::ID id =
          getIntrinsic(Callee->getName(), resTy, CI->arg_size(), StrictFP);
      if (id != Intrinsic::not_intrinsic) {
        // getDeclaration requires an array of the same length as the
        // overload arity. For the libm intrinsics, this is always one
        Type *tmpTy[1] = {resTy};
        Function *intrin =
            Intrinsic::getDeclaration(CI->getModule(), id, tmpTy);
        if (intrin) {
          if (StrictFP && intrin->isConstrainedFPIntrinsic()) {
            // Constrained intrinsic needs extra parameters to encode the
            // rounding and exception so create a new CallInst.
            auto &Ctx = Ty->getContext();
            FunctionType *IntrinTy = intrin->getFunctionType();
            SmallVector<Value *, 4> Args(CI->arg_begin(), CI->arg_end());
            // Only add rounding parameter if the intrinsic supports several
            // different roundings.
            if (IntrinTy->getNumParams() > CI->arg_size() + 1) {
              auto *RoundingMDS = MDString::get(Ctx, "round.tonearest");
              Args.push_back(MetadataAsValue::get(Ctx, RoundingMDS));
            }
            auto *ExceptMDS = MDString::get(Ctx, "fpexcept.maytrap");
            Args.push_back(MetadataAsValue::get(Ctx, ExceptMDS));
            CallInst *NewCI = CallInst::Create(IntrinTy, intrin, Args, "", CI);

            // Rewire code to use this new CallInst.
            NewCI->takeName(CI);
            CI->replaceAllUsesWith(NewCI);
            CI->eraseFromParent();
            CI = NewCI;
          } else {
            CI->setCalledFunction(intrin);
          }
          LLVM_DEBUG(dbgs() << "ColossusLibmCalls: Replace call to "
                            << Callee->getName() << " with "
                            << Intrinsic::getName(id, tmpTy, CI->getModule())
                            << "\n";);
          Changed = true;
        }
      }
    }
  }
  return Changed;
}
