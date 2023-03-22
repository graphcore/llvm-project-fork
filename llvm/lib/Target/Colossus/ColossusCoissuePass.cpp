//===-- ColossusCoissuePass.cpp - Bundle adjacent instructions ------------===//
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

#include "Colossus.h"
#include "ColossusCoissueUtil.h"

#include "llvm/Support/CommandLine.h"
#include "llvm/Support/Debug.h"
#include "llvm/CodeGen/MachineFunctionPass.h"

using namespace llvm;
#define DEBUG_TYPE "colossus-coissue"
#define COLOSSUS_COISSUE_PASS_NAME "Colossus Coissue pass"
static cl::opt<bool> Coissue("colossus-coissue",
                             cl::desc("Apply coissue to MI before emission"),
                             cl::init(true), cl::Hidden);

namespace {
class ColossusCoissue : public MachineFunctionPass {
private:
public:
  static char ID;
  explicit ColossusCoissue() : MachineFunctionPass(ID) {
    initializeColossusCoissuePass(*PassRegistry::getPassRegistry());
  }

  bool runOnMachineFunction(MachineFunction &F) override;

  StringRef getPassName() const override { return COLOSSUS_COISSUE_PASS_NAME; }

  void getAnalysisUsage(AnalysisUsage &AU) const override {
    AU.setPreservesCFG();
    MachineFunctionPass::getAnalysisUsage(AU);
  }
};
char ColossusCoissue::ID = 0;

} // end anonymous namespace

INITIALIZE_PASS(ColossusCoissue, DEBUG_TYPE, COLOSSUS_COISSUE_PASS_NAME, false,
                false)

bool ColossusCoissue::runOnMachineFunction(MachineFunction &mf) {
  bool changed = false;
  Colossus::CoissueUtil util;

  for (MachineFunction::iterator MFI = mf.begin(), E = mf.end(); MFI != E;
       ++MFI) {
    for (MachineBasicBlock::instr_iterator BBI = MFI->instr_begin(),
                                           E = MFI->instr_end();
         BBI != E;) {
      if (std::next(BBI) == E) {
        break;
      }

      if (!util.canBundleWithNextInstr(MFI, BBI)) {
        BBI++;
        continue;
      }

      // Can't bundle if the first instruction is a branch or call as it
      // changes whether the second instruction is visible after the branch
      if (util.isControl(&*BBI)) {
        LLVM_DEBUG(dbgs() << "Control hazard, cannot dual issue\n";);
        BBI++;
        continue;
      }

      BBI = util.bundleWithNextInstr(MFI, BBI);
      changed = true;
    }
  }

  return changed;
}

bool llvm::enableColossusCoissue() { return Coissue; }

FunctionPass *llvm::createColossusCoissuePass() {
  return enableColossusCoissue() ? new ColossusCoissue() : nullptr;
}
