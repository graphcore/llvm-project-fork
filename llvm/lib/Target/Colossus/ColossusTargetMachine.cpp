//===-- ColossusTargetMachine.cpp - Define TargetMachine for Colossus -----===//
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

#include "ColossusTargetMachine.h"
#include "Colossus.h"
#include "ColossusCountedLoopOptions.h"
#include "ColossusMachineScheduler.h"
#include "ColossusTargetObjectFile.h"
#include "ColossusTargetTransformInfo.h"
#include "TargetInfo/ColossusTargetInfo.h"
#include "llvm/CodeGen/Passes.h"
#include "llvm/CodeGen/TargetPassConfig.h"
#include "llvm/IR/LegacyPassManager.h"
#include "llvm/IR/Module.h"
#include "llvm/MC/TargetRegistry.h"
#include "llvm/Passes/PassBuilder.h"
#include "llvm/Transforms/IPO/PassManagerBuilder.h"
#include "llvm/Transforms/Scalar.h"
#include "llvm/Transforms/Vectorize.h"

using namespace llvm;

static Reloc::Model getEffectiveRelocModel(Optional<Reloc::Model> RM) {
  if (!RM.hasValue())
    return Reloc::Static;
  return *RM;
}

/// ColossusTargetMachine ctor - Create an ILP32 architecture model
///
ColossusTargetMachine::ColossusTargetMachine(const Target &T, const Triple &TT,
                                             StringRef CPU, StringRef FS,
                                             const TargetOptions &Options,
                                             Optional<Reloc::Model> RM,
                                             Optional<CodeModel::Model> CM,
                                             CodeGenOpt::Level OL, bool JIT)
    : LLVMTargetMachine(T,
                        "e-m:e-p:32:32-i1:8:32-i8:8:32-i16:16:32-i64:32-i128:64"
                        "-f64:32-f128:64-v128:64-a:0:32-n32",
                        TT, CPU, FS, Options, getEffectiveRelocModel(RM),
                        getEffectiveCodeModel(CM, CodeModel::Small), OL),
      TLOF(std::make_unique<ColossusTargetObjectFile>()) {
  initAsmInfo();
}

ColossusTargetMachine::~ColossusTargetMachine() {}

const ColossusSubtarget *
ColossusTargetMachine::getSubtargetImpl(const Function &F) const {
  Attribute CPUAttr = F.getFnAttribute("target-cpu");
  Attribute TuneAttr = F.getFnAttribute("tune-cpu");
  Attribute FSAttr = F.getFnAttribute("target-features");

  std::string CPU = !CPUAttr.hasAttribute(Attribute::None)
                        ? CPUAttr.getValueAsString().str()
                        : TargetCPU;
  std::string TuneCPU = !TuneAttr.hasAttribute(Attribute::None)
                            ? TuneAttr.getValueAsString().str()
                            : CPU;
  std::string FS = !FSAttr.hasAttribute(Attribute::None)
                       ? FSAttr.getValueAsString().str()
                       : TargetFS;

  auto &I = SubtargetMap[CPU + FS];
  if (!I) {
    // This needs to be done before we create a new subtarget since any
    // creation will depend on the TM and the code generation flags on the
    // function that reside in TargetOptions.
    resetTargetOptions(F);
    I = std::make_unique<ColossusSubtarget>(TargetTriple, CPU, TuneCPU, FS,
                                            *this);
  }
  return I.get();
}

namespace {
/// Colossus Code Generator Pass Configuration Options.
class ColossusPassConfig : public TargetPassConfig {
public:
  ColossusPassConfig(ColossusTargetMachine *TM, PassManagerBase &PM)
    : TargetPassConfig(*TM, PM) {}

  ColossusTargetMachine &getColossusTargetMachine() const {
    return getTM<ColossusTargetMachine>();
  }

  void addIRPasses() override;
  void addCodeGenPrepare() override;
  void addPreRegAlloc() override;
  void addPostRegAlloc() override;
  bool addPreISel() override;
  bool addInstSelector() override;
  void addPreEmitPass() override;
  ScheduleDAGInstrs *
  createMachineScheduler(MachineSchedContext *C) const override;
};
} // namespace

TargetPassConfig *ColossusTargetMachine::createPassConfig(PassManagerBase &PM) {
  return new ColossusPassConfig(this, PM);
}

ScheduleDAGInstrs *
ColossusPassConfig::createMachineScheduler(MachineSchedContext *C) const {
  auto *DAG = new ScheduleDAGMILive(
      C, enableColossusCoissue() ? std::make_unique<ColossusScheduler>(C)
                                 : std::make_unique<GenericScheduler>(C));
  // add DAG Mutations here.
  DAG->addMutation(createCopyConstrainDAGMutation(DAG->TII, DAG->TRI));
  return DAG;
}

void ColossusPassConfig::addIRPasses() {
  addPass(createAtomicExpandPass());
  TargetPassConfig::addIRPasses();
}

void ColossusPassConfig::addCodeGenPrepare() {
  // Running hwloops pass before actual CGP pass so the builtin assumes are
  // still in the IR and can be used by the hwloops pass.
  if (getOptLevel() != CodeGenOpt::None) {
    addPass(createColossusLoadStoreVectorizerPass());
    addPass(createHardwareLoopsPass());
  }
  TargetPassConfig::addCodeGenPrepare();
}

void ColossusPassConfig::addPreRegAlloc() {
  if (getOptLevel() != CodeGenOpt::None)
    addPass(&MachinePipelinerID);
  TargetPassConfig::addPreRegAlloc();
}

void ColossusPassConfig::addPostRegAlloc() {
  if (getOptLevel() != CodeGenOpt::None)
    addPass(createColossusUnnecessaryAndElimPass());
  TargetPassConfig::addPostRegAlloc();
}

bool ColossusPassConfig::addPreISel() {
  if (getOptLevel() != CodeGenOpt::None) {
    addPass(createLoopDeletionPass());
    addPass(createColossusLoopConversionPass());
    addPass(createCFGSimplificationPass());
  }
  return false;
}

bool ColossusPassConfig::addInstSelector() {
  addPass(createColossusISelDag(getColossusTargetMachine(), getOptLevel()));
  return false;
}

void ColossusPassConfig::addPreEmitPass() {
  if (getOptLevel() != CodeGenOpt::None) {
    addPass(createColossusCountedLoopMIRPass());
    FunctionPass *p = createColossusCoissuePass();
    if (p) {
      addPass(p);
    }
    addPass(&FinalizeMachineBundlesID);
  }
}

// Force static initialization.
extern "C" LLVM_EXTERNAL_VISIBILITY void LLVMInitializeColossusTarget() {
  RegisterTargetMachine<ColossusTargetMachine> X(getTheColossusTarget());
  PassRegistry *PR = PassRegistry::getPassRegistry();
  initializeColossusCountedLoopMIRPass(*PR);
  initializeColossusLoadStoreVectorizerPassPass(*PR);
  initializeColossusLoopConversionPass(*PR);
  initializeColossusUnnecessaryAndElimPass(*PR);
}

TargetTransformInfo
ColossusTargetMachine::getTargetTransformInfo(const Function &F) const {
  return TargetTransformInfo(ColossusTTIImpl(this, F));
}

void ColossusTargetMachine::adjustPassManager(PassManagerBuilder &PMB) {
  for (auto when : {
           PassManagerBuilder::EP_ScalarOptimizerLate,
           PassManagerBuilder::EP_EnabledOnOptLevel0,
       }) {
    PMB.addExtension(
        when, [&](const PassManagerBuilder &, legacy::PassManagerBase &PM) {
          PM.add(createColossusIntrinsicCallsPass());
        });
  }
  for (auto when : {
           PassManagerBuilder::EP_VectorizerStart,
           PassManagerBuilder::EP_EnabledOnOptLevel0,
       }) {
    PMB.addExtension(
        when, [&](const PassManagerBuilder &, legacy::PassManagerBase &PM) {
          PM.add(createColossusLibmCallsPass());
        });
  }
}

void ColossusTargetMachine::registerPassBuilderCallbacks(PassBuilder &PB) {

  PB.registerScalarOptimizerLateEPCallback(
      [=](FunctionPassManager &FPM, OptimizationLevel Level) {
        FPM.addPass(ColossusIntrinsicCallsPass());
      });

  PB.registerVectorizerStartEPCallback(
      [=](FunctionPassManager &FPM, OptimizationLevel Level) {
        FPM.addPass(ColossusLibmCallsPass());
      });
}
