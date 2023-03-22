//===-- ColossusInstrInfoTest.cpp - Colossus Instruction Information -----===//
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
#include "ColossusInstrInfo.h"
#include "gtest/gtest.h"
using namespace llvm;

#include "llvm/IR/LLVMContext.h"
#include "llvm/CodeGen/MachineModuleInfo.h"
#include "llvm/CodeGen/MachineFrameInfo.h"
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
class ColossusInstrInfoTest : public ::testing::Test {
public:
  ColossusInstrInfoTest() : M("Test", C) {
    LLVMInitializeColossusTarget();
    LLVMInitializeColossusAsmParser();
    LLVMInitializeColossusAsmPrinter();
    LLVMInitializeColossusTargetInfo();
    LLVMInitializeColossusTargetMC();
    std::string error;
    target = TargetRegistry::lookupTarget(triple, error);

    TargetOptions Options;
    auto TM = static_cast<LLVMTargetMachine *>(target->createTargetMachine(
        "Colossus", "", "", Options, None, None, CodeGenOpt::Aggressive));

    auto Type = FunctionType::get(Type::getVoidTy(C), false);

    M.setDataLayout(TM->createDataLayout());
    auto F = Function::Create(Type, GlobalValue::ExternalLinkage,
                                "Test", &M);
    F->addFnAttr("target-features", "+ipu21");
    MachineModuleInfo MMI(TM);
    const TargetSubtargetInfo &STI = *TM->getSubtargetImpl(*F);

    MF = std::make_unique<MachineFunction>(*F, *TM, STI, 420,
                                            MMI);
  }

protected:
  
  LLVMContext C;
  Module M;
  DebugLoc DL;
  ColossusInstrInfo CII;
  std::string const triple = "colossus-graphcore-unknown-elf";
  Target const *target;
  std::unique_ptr<MachineFunction> MF;
};

} // namespace

TEST_F(ColossusInstrInfoTest, TestCopyPhysRegMtoM) {
  auto MBB = MF->CreateMachineBasicBlock();
  MCRegister dest(Colossus::M0);
  MCRegister src(Colossus::M1);
  CII.copyPhysReg(*MBB, MBB->begin(), DL, dest, src, false);

  auto I = MBB->begin();

  ASSERT_EQ(Colossus::OR_ZI,   I->getOpcode());
  ASSERT_EQ(Colossus::M0,    I->getOperand(0).getReg());
  ASSERT_EQ(Colossus::M1,    I->getOperand(1).getReg());
  ASSERT_EQ(0,               I->getOperand(2).getImm());
  ASSERT_EQ(0,               I->getOperand(3).getImm());
  ASSERT_EQ(4u, I->getNumOperands());
}

TEST_F(ColossusInstrInfoTest, TestCopyPhysRegAtoA) {
  auto MBB = MF->CreateMachineBasicBlock();
  MCRegister dest(Colossus::A0);
  MCRegister src(Colossus::A1);
  CII.copyPhysReg(*MBB, MBB->begin(), DL, dest, src, false);

  auto I = MBB->begin();

  ASSERT_EQ(Colossus::OR_ZI_A, I->getOpcode());
  ASSERT_EQ(Colossus::A0,      I->getOperand(0).getReg());
  ASSERT_EQ(Colossus::A1,      I->getOperand(1).getReg());
  ASSERT_EQ(0,                 I->getOperand(2).getImm());
  ASSERT_EQ(0,                 I->getOperand(3).getImm());
  ASSERT_EQ(4u, I->getNumOperands());
}

TEST_F(ColossusInstrInfoTest, TestCopyPhysRegPairMM) {
  auto MBB = MF->CreateMachineBasicBlock();
  MCRegister dest(Colossus::MD0);
  MCRegister src(Colossus::MD1);
  CII.copyPhysReg(*MBB, MBB->begin(), DL, dest, src, false);

  auto I = MBB->begin();

  ASSERT_EQ(Colossus::OR_ZI,  I->getOpcode());
  ASSERT_EQ(Colossus::M0,     I->getOperand(0).getReg());
  ASSERT_EQ(0,                I->getOperand(2).getImm());
  ASSERT_EQ(0,                I->getOperand(3).getImm());
  ASSERT_EQ(5u, I->getNumOperands());

  I++;
  ASSERT_EQ(Colossus::OR_ZI,  I->getOpcode());
  ASSERT_EQ(Colossus::M1,     I->getOperand(0).getReg());
  ASSERT_EQ(0,                I->getOperand(2).getImm());
  ASSERT_EQ(0,                I->getOperand(3).getImm());
  ASSERT_EQ(5u, I->getNumOperands());
}


TEST_F(ColossusInstrInfoTest, TestCopyPhysRegPairAA) {
  auto MBB = MF->CreateMachineBasicBlock();
  MCRegister dest(Colossus::AD0);
  MCRegister src(Colossus::AD1);
  CII.copyPhysReg(*MBB, MBB->begin(), DL, dest, src, false);

  auto I = MBB->begin();

  ASSERT_EQ(Colossus::OR64,   I->getOpcode());
  ASSERT_EQ(Colossus::AD0,    I->getOperand(0).getReg());
  ASSERT_EQ(Colossus::AD1,    I->getOperand(1).getReg());
  ASSERT_EQ(Colossus::AZEROS, I->getOperand(2).getReg());
  ASSERT_EQ(0,                I->getOperand(3).getImm());
  ASSERT_EQ(4u, I->getNumOperands());
}

TEST_F(ColossusInstrInfoTest, TestloadRegFromStackSlotPair) {
  auto MBB = MF->CreateMachineBasicBlock();
  MachineFrameInfo &MFI = MF->getFrameInfo();
  MCRegister dest(Colossus::AD0);
  auto FrameIdx = MFI.CreateStackObject(4u, Align(1), true);
  CII.loadRegFromStackSlot(*MBB, MBB->begin(), dest, FrameIdx,
        &Colossus::ARPairRegClass, nullptr);

  auto I = MBB->begin();
  ASSERT_EQ(Colossus::LD64_A_FI, I->getOpcode());
  ASSERT_EQ(Colossus::AD0,       I->getOperand(0).getReg());
  ASSERT_EQ(FrameIdx,            I->getOperand(1).getIndex());
  ASSERT_EQ(0,                   I->getOperand(2).getImm());
  ASSERT_EQ(3u, I->getNumOperands());
}


TEST_F(ColossusInstrInfoTest, TestStoreRegToStackSlotPair) {
  auto MBB = MF->CreateMachineBasicBlock();
  MachineFrameInfo &MFI = MF->getFrameInfo();
  MCRegister src(Colossus::AD0);
  auto FrameIdx = MFI.CreateStackObject(4u, Align(1), true);
  CII.storeRegToStackSlot(*MBB, MBB->begin(), src, false, 
        FrameIdx, &Colossus::ARPairRegClass, nullptr);

  auto I = MBB->begin();
  ASSERT_EQ(Colossus::ST64_A_FI, I->getOpcode());
  ASSERT_EQ(Colossus::AD0,       I->getOperand(0).getReg());
  ASSERT_EQ(FrameIdx,            I->getOperand(1).getIndex());
  ASSERT_EQ(0,                   I->getOperand(2).getImm());
  ASSERT_EQ(3u, I->getNumOperands());
}
