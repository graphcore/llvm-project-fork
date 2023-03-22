//===-- ColossusRegisterInfoTest.cpp - Colossus Instruction Information --===//
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

#include "ColossusRegisterInfo.h"
#include "ColossusInstrInfo.h"
#include "gtest/gtest.h"
using namespace llvm;

#include "llvm/IR/LLVMContext.h"
#include "llvm/CodeGen/MachineFunction.h"
#include "llvm/CodeGen/MachineModuleInfo.h"
#include "llvm/CodeGen/MachineFrameInfo.h"
#include "llvm/CodeGen/MachineOperand.h"
#include "llvm/MC/TargetRegistry.h"
#include "llvm/Target/TargetMachine.h"
#include "llvm/Target/TargetOptions.h"

#define GET_REGINFO_ENUM
#include "ColossusGenRegisterInfo.inc"

#define GET_INSTRINFO_ENUM
#include "ColossusGenInstrInfo.inc"

extern "C" {

void LLVMInitializeColossusTargetInfo();
void LLVMInitializeColossusAsmParser();
void LLVMInitializeColossusTarget();
void LLVMInitializeColossusAsmPrinter();
void LLVMInitializeColossusTargetMC();
void LLVMInitializeColossusDisassembler();

} // extern "C"

namespace {
class ColossusRegisterInfoTest : public ::testing::Test {
public:
  ColossusRegisterInfoTest() : M("Test", C) {
    LLVMInitializeColossusTarget();
    LLVMInitializeColossusAsmParser();
    LLVMInitializeColossusAsmPrinter();
    LLVMInitializeColossusTargetInfo();
    LLVMInitializeColossusTargetMC();
    std::string error;
    target = TargetRegistry::lookupTarget(triple, error);

    TargetOptions Options;
    TM.reset(static_cast<LLVMTargetMachine *>(target->createTargetMachine(
        "Colossus", "", "", Options, None, None, CodeGenOpt::Aggressive)));

    M.setDataLayout(TM->createDataLayout());
  }

    void setUpFunc(std::string arch){
      auto Type = FunctionType::get(Type::getVoidTy(C), false);
      auto F = Function::Create(Type, GlobalValue::ExternalLinkage,
                                  "Test", &M);
      arch = "+" + arch;
      F->addFnAttr("target-features", arch);
      MachineModuleInfo MMI(TM.get());
      const TargetSubtargetInfo &STI = *TM->getSubtargetImpl(*F);

      MF = std::make_unique<MachineFunction>(*F, *TM, STI, 420,
                                              MMI);
      MBB = MF->CreateMachineBasicBlock();
    }

    MachineBasicBlock::iterator doLoadTest(std::string arch, TargetRegisterClass const &RC,
                                               unsigned destReg) {
    setUpFunc(arch);
    
    MachineFrameInfo &MFI = MF->getFrameInfo();
    MCRegister dest(destReg);
    auto FrameIdx = MFI.CreateStackObject(4u, Align(1), true);
    CII.loadRegFromStackSlot(*MBB, MBB->begin(), dest, FrameIdx, &RC, nullptr);

    CRI.eliminateFrameIndex(MBB->begin(), 0, 1);
    return MBB->begin();
  }

  MachineBasicBlock::iterator doStoreTest(std::string arch, TargetRegisterClass const &RC,
                                               unsigned srcReg) {
    setUpFunc(arch);

    MachineFrameInfo &MFI = MF->getFrameInfo();
    MCRegister src(srcReg);
    auto FrameIdx = MFI.CreateStackObject(4u, Align(1), true);
    CII.storeRegToStackSlot(*MBB, MBB->begin(), src, true, FrameIdx, &RC, nullptr);

    CRI.eliminateFrameIndex(MBB->begin(), 0, 1);
    return MBB->begin();
  }

protected:
  
  LLVMContext C;
  Module M;
  std::unique_ptr<LLVMTargetMachine> TM;
  DebugLoc DL;
  ColossusRegisterInfo CRI;
  ColossusInstrInfo CII;
  std::string const triple = "colossus-graphcore-unknown-elf";
  Target const *target;
  std::unique_ptr<MachineFunction> MF;
  MachineBasicBlock *MBB;
};

// IPU2 tests
TEST_F(ColossusRegisterInfoTest, eliminateFrameIndex_LD32_ipu2) {
    auto I = doLoadTest("ipu2", Colossus::MRRegClass, Colossus::M0);

  ASSERT_EQ(Colossus::LD32_ZI, I->getOpcode());
  ASSERT_EQ(Colossus::M0,      I->getOperand(0).getReg());
  ASSERT_EQ(Colossus::SP,      I->getOperand(1).getReg());
  ASSERT_EQ(Colossus::MZERO,   I->getOperand(2).getReg());
  ASSERT_EQ(0,                 I->getOperand(3).getImm());
  ASSERT_EQ(0,                 I->getOperand(4).getImm());
  ASSERT_EQ(5u,                I->getNumOperands());
  ASSERT_EQ(++I, MBB->end());
}

TEST_F(ColossusRegisterInfoTest, eliminateFrameIndex_LD64_ipu2) {
  auto I = doLoadTest("ipu2", Colossus::MRPairRegClass, Colossus::MD0);
  
  ASSERT_EQ(Colossus::LD32_ZI, I->getOpcode());
  ASSERT_EQ(Colossus::M0,      I->getOperand(0).getReg());
  ASSERT_EQ(Colossus::SP,      I->getOperand(1).getReg());
  ASSERT_EQ(Colossus::MZERO,   I->getOperand(2).getReg());
  ASSERT_EQ(0,                 I->getOperand(3).getImm());
  ASSERT_EQ(0,                 I->getOperand(4).getImm());
  ASSERT_EQ(5u,                I->getNumOperands());
  I++;
  ASSERT_EQ(Colossus::LD32_ZI, I->getOpcode());
  ASSERT_EQ(Colossus::M1,      I->getOperand(0).getReg());
  ASSERT_EQ(Colossus::SP,      I->getOperand(1).getReg());
  ASSERT_EQ(Colossus::MZERO,   I->getOperand(2).getReg());
  ASSERT_EQ(1,                 I->getOperand(3).getImm());
  ASSERT_EQ(0,                 I->getOperand(4).getImm());
  ASSERT_EQ(5u,                I->getNumOperands());
  ASSERT_EQ(++I, MBB->end());
}

TEST_F(ColossusRegisterInfoTest, eliminateFrameIndex_LD32_A_ipu2) {
  auto I = doLoadTest("ipu2", Colossus::ARRegClass, Colossus::A0);

  ASSERT_EQ(Colossus::LD32_ZI_A, I->getOpcode());
  ASSERT_EQ(Colossus::A0,        I->getOperand(0).getReg());
  ASSERT_EQ(Colossus::SP,        I->getOperand(1).getReg());
  ASSERT_EQ(Colossus::MZERO,     I->getOperand(2).getReg());
  ASSERT_EQ(0,                   I->getOperand(3).getImm());
  ASSERT_EQ(0,                   I->getOperand(4).getImm());
  ASSERT_EQ(5u,                  I->getNumOperands());
  ASSERT_EQ(++I, MBB->end());
}

TEST_F(ColossusRegisterInfoTest, eliminateFrameIndex_LD64_A_ipu2) {
  auto I = doLoadTest("ipu2", Colossus::ARPairRegClass, Colossus::AD0);

  ASSERT_EQ(Colossus::LD64_ZI_A, I->getOpcode());
  ASSERT_EQ(Colossus::AD0,       I->getOperand(0).getReg());
  ASSERT_EQ(Colossus::SP,        I->getOperand(1).getReg());
  ASSERT_EQ(Colossus::MZERO,     I->getOperand(2).getReg());
  ASSERT_EQ(0,                   I->getOperand(3).getImm());
  ASSERT_EQ(0,                   I->getOperand(4).getImm());
  ASSERT_EQ(5u,                  I->getNumOperands());
  ASSERT_EQ(++I, MBB->end());
}

TEST_F(ColossusRegisterInfoTest, eliminateFrameIndex_LD128_A_ipu2) {
  auto I = doLoadTest("ipu2", Colossus::ARQuadRegClass, Colossus::AQ0);

  ASSERT_EQ(Colossus::LD64_ZI_A, I->getOpcode());
  ASSERT_EQ(Colossus::A0,        I->getOperand(0).getReg());
  ASSERT_EQ(Colossus::SP,        I->getOperand(1).getReg());
  ASSERT_EQ(Colossus::MZERO,     I->getOperand(2).getReg());
  ASSERT_EQ(0,                   I->getOperand(3).getImm());
  ASSERT_EQ(0,                   I->getOperand(4).getImm());
  ASSERT_EQ(5u,                  I->getNumOperands());
  I++;
  ASSERT_EQ(Colossus::LD64_ZI_A, I->getOpcode());
  ASSERT_EQ(Colossus::A1,        I->getOperand(0).getReg());
  ASSERT_EQ(Colossus::SP,        I->getOperand(1).getReg());
  ASSERT_EQ(Colossus::MZERO,     I->getOperand(2).getReg());
  ASSERT_EQ(1,                   I->getOperand(3).getImm());
  ASSERT_EQ(0,                   I->getOperand(4).getImm());
  ASSERT_EQ(5u,                  I->getNumOperands());
  ASSERT_EQ(++I, MBB->end());
}

TEST_F(ColossusRegisterInfoTest, eliminateFrameIndex_ST32_ipu2) {
  auto I = doStoreTest("ipu2", Colossus::MRRegClass, Colossus::M0);

  ASSERT_EQ(Colossus::ST32_ZI, I->getOpcode());
  ASSERT_EQ(Colossus::M0,      I->getOperand(0).getReg());
  ASSERT_EQ(Colossus::SP,      I->getOperand(1).getReg());
  ASSERT_EQ(Colossus::MZERO,   I->getOperand(2).getReg());
  ASSERT_EQ(0,                 I->getOperand(3).getImm());
  ASSERT_EQ(0,                 I->getOperand(4).getImm());
  ASSERT_EQ(5u,                I->getNumOperands());
  ASSERT_EQ(++I, MBB->end());
}

TEST_F(ColossusRegisterInfoTest, eliminateFrameIndex_ST64_ipu2) {
  auto I = doStoreTest("ipu2", Colossus::MRPairRegClass, Colossus::MD0);
  
  ASSERT_EQ(Colossus::ST32_ZI, I->getOpcode());
  ASSERT_EQ(Colossus::M0,      I->getOperand(0).getReg());
  ASSERT_EQ(Colossus::SP,      I->getOperand(1).getReg());
  ASSERT_EQ(Colossus::MZERO,   I->getOperand(2).getReg());
  ASSERT_EQ(0,                 I->getOperand(3).getImm());
  ASSERT_EQ(0,                 I->getOperand(4).getImm());
  ASSERT_EQ(Colossus::MD0,     I->getOperand(5).getReg());
  ASSERT_EQ(6u,                I->getNumOperands());
  I++;
  ASSERT_EQ(Colossus::ST32_ZI, I->getOpcode());
  ASSERT_EQ(Colossus::M1,      I->getOperand(0).getReg());
  ASSERT_EQ(Colossus::SP,      I->getOperand(1).getReg());
  ASSERT_EQ(Colossus::MZERO,   I->getOperand(2).getReg());
  ASSERT_EQ(1,                 I->getOperand(3).getImm());
  ASSERT_EQ(0,                 I->getOperand(4).getImm());
  ASSERT_EQ(Colossus::MD0,     I->getOperand(5).getReg());
  ASSERT_EQ(6u,                I->getNumOperands());
  ASSERT_EQ(++I, MBB->end());
}



TEST_F(ColossusRegisterInfoTest, eliminateFrameIndex_ST32_A_ipu2) {
  auto I = doStoreTest("ipu2", Colossus::ARRegClass, Colossus::A0);

  ASSERT_EQ(Colossus::ST32_ZI_A, I->getOpcode());
  ASSERT_EQ(Colossus::A0,        I->getOperand(0).getReg());
  ASSERT_EQ(Colossus::SP,        I->getOperand(1).getReg());
  ASSERT_EQ(Colossus::MZERO,     I->getOperand(2).getReg());
  ASSERT_EQ(0,                   I->getOperand(3).getImm());
  ASSERT_EQ(0,                   I->getOperand(4).getImm());
  ASSERT_EQ(5u,                  I->getNumOperands());
  ASSERT_EQ(++I, MBB->end());
}

TEST_F(ColossusRegisterInfoTest, eliminateFrameIndex_ST64_A_ipu2) {
  auto I = doStoreTest("ipu2", Colossus::ARPairRegClass, Colossus::AD0);

  ASSERT_EQ(Colossus::ST64_ZI_A, I->getOpcode());
  ASSERT_EQ(Colossus::AD0,       I->getOperand(0).getReg());
  ASSERT_EQ(Colossus::SP,        I->getOperand(1).getReg());
  ASSERT_EQ(Colossus::MZERO,     I->getOperand(2).getReg());
  ASSERT_EQ(0,                   I->getOperand(3).getImm());
  ASSERT_EQ(0,                   I->getOperand(4).getImm());
  ASSERT_EQ(5u,                  I->getNumOperands());
  ASSERT_EQ(++I, MBB->end());
}

TEST_F(ColossusRegisterInfoTest, eliminateFrameIndex_ST128_A_ipu2) {
  auto I = doStoreTest("ipu2", Colossus::ARQuadRegClass, Colossus::AQ0);

  ASSERT_EQ(Colossus::ST64_ZI_A, I->getOpcode());
  ASSERT_EQ(Colossus::A0,      I->getOperand(0).getReg());
  ASSERT_EQ(Colossus::SP,      I->getOperand(1).getReg());
  ASSERT_EQ(Colossus::MZERO,   I->getOperand(2).getReg());
  ASSERT_EQ(0,                 I->getOperand(3).getImm());
  ASSERT_EQ(0,                 I->getOperand(4).getImm());
  ASSERT_EQ(Colossus::AQ0,     I->getOperand(5).getReg());
  ASSERT_EQ(6u,                I->getNumOperands());
  ++I;
  ASSERT_EQ(Colossus::ST64_ZI_A, I->getOpcode());
  ASSERT_EQ(Colossus::A1,      I->getOperand(0).getReg());
  ASSERT_EQ(Colossus::SP,      I->getOperand(1).getReg());
  ASSERT_EQ(Colossus::MZERO,   I->getOperand(2).getReg());
  ASSERT_EQ(1,                 I->getOperand(3).getImm());
  ASSERT_EQ(0,                 I->getOperand(4).getImm());
  ASSERT_EQ(Colossus::AQ0,     I->getOperand(5).getReg());
  ASSERT_EQ(6u,                I->getNumOperands());
  ASSERT_EQ(++I, MBB->end());
}

} // namespace
