//===-- ColossusAsmPrinter.cpp - Colossus LLVM assembly writer ------------===//
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
// This file contains a printer that converts from our internal representation
// of machine-dependent LLVM code to the XAS-format Colossus assembly language.
//
//===----------------------------------------------------------------------===//

#include "Colossus.h"
#include "ColossusInstrInfo.h"
#include "ColossusMCInstLower.h"
#include "ColossusSubtarget.h"
#include "ColossusTargetMachine.h"
#include "ColossusTargetStreamer.h"
#include "MCTargetDesc/ColossusInstPrinter.h"
#include "TargetInfo/ColossusTargetInfo.h"
#include "llvm/ADT/SmallString.h"
#include "llvm/ADT/StringExtras.h"
#include "llvm/BinaryFormat/ELF.h"
#include "llvm/CodeGen/AsmPrinter.h"
#include "llvm/CodeGen/MachineConstantPool.h"
#include "llvm/CodeGen/MachineFrameInfo.h"
#include "llvm/CodeGen/MachineFunctionPass.h"
#include "llvm/CodeGen/MachineInstr.h"
#include "llvm/CodeGen/MachineJumpTableInfo.h"
#include "llvm/CodeGen/MachineModuleInfo.h"
#include "llvm/IR/Constants.h"
#include "llvm/IR/DataLayout.h"
#include "llvm/IR/DebugInfo.h"
#include "llvm/IR/DerivedTypes.h"
#include "llvm/IR/Mangler.h"
#include "llvm/IR/Module.h"
#include "llvm/MC/MCAsmInfo.h"
#include "llvm/MC/MCExpr.h"
#include "llvm/MC/MCInst.h"
#include "llvm/MC/MCSectionELF.h"
#include "llvm/MC/MCStreamer.h"
#include "llvm/MC/MCSymbol.h"
#include "llvm/MC/TargetRegistry.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Target/TargetLoweringObjectFile.h"
#include <algorithm>
#include <cctype>

using namespace llvm;

#define DEBUG_TYPE "colossus-asm-printer"

namespace {
  class ColossusAsmPrinter : public AsmPrinter {
    ColossusMCInstLower MCInstLowering;
    DenseMap<MCSymbol const *, unsigned> stackSizeSecIds;

  public:
    explicit ColossusAsmPrinter(TargetMachine &TM,
                                std::unique_ptr<MCStreamer> Streamer)
      : AsmPrinter(TM, std::move(Streamer)),
        MCInstLowering(*this) {}

    StringRef getPassName() const override {
      return "Colossus Assembly Printer";
    }

    void emitFunctionEntryLabel() override;
    void emitInstruction(const MachineInstr *MI) override;
    void emitFunctionBodyStart() override;
    void emitStartOfAsmFile(Module &) override;

    void printOperand(const MachineInstr *MI,
                      int opNum,
                      raw_ostream &O);
    bool PrintAsmOperand(const MachineInstr *MI,
                         unsigned OpNo,
                         const char *ExtraCode,
                         raw_ostream &O) override;
    bool PrintAsmMemoryOperand(const MachineInstr *MI,
                               unsigned OpNum,
                               const char *ExtraCode,
                               raw_ostream &O) override;

    bool lowerOperand(const MachineOperand &MO, MCOperand &MCOp);

  private:
    // tblgen'erated function.
    bool emitPseudoExpansionLowering(MCStreamer &OutStreamer,
                                     const MachineInstr *MI);
  };
} // end of anonymous namespace

void ColossusAsmPrinter::emitFunctionEntryLabel() {
  (*OutStreamer).emitLabel(CurrentFnSym);
}

void ColossusAsmPrinter::emitFunctionBodyStart() {
  MCInstLowering.Initialize(&MF->getContext());
}

void ColossusAsmPrinter::emitStartOfAsmFile(Module &M) {
  OutStreamer->emitAssemblerFlag(MCAF_AllowOptimizations);
}

bool ColossusAsmPrinter::lowerOperand(const MachineOperand &MO,
                                      MCOperand &MCOp) {
  MCOp = MCInstLowering.LowerOperand(MO);
  return MCOp.isValid();
}

#include "ColossusGenMCPseudoLowering.inc"

void ColossusAsmPrinter::emitInstruction(const MachineInstr *MI) {
  // Do any auto-generated pseudo lowering.
  if (emitPseudoExpansionLowering(*OutStreamer, MI)) {
    return;
  }

  if (MI->isBundle()) {
    MCInst MCB;
    MCB.setOpcode(Colossus::BUNDLE);
    const MachineBasicBlock *MBB = MI->getParent();
    MachineBasicBlock::const_instr_iterator MII = MI->getIterator();
    assert(MII->getOpcode() == Colossus::BUNDLE);
    // Skip first BUNDLE instruction, add remaining instructions as operands.
    ++MII;

    while (MII != MBB->instr_end() && MII->isInsideBundle()) {
      assert(MII->getOpcode() != Colossus::LABEL &&
             "LABEL not permitted in BUNDLE");

      const MachineInstr *BundleMI = &*MII;
      MCInst * instr = new (OutContext) MCInst(MCInstLowering.Lower(BundleMI));
      MCB.addOperand(MCOperand::createInst(instr));
      ++MII;
    }
    // Ensure the bundle is the correct size.
    assert(MCB.getNumOperands() == 2 &&
           "Bundle does not contain two instructions");
    EmitToStreamer(*OutStreamer, MCB);
  } else {
    // Default emission for single issue.
    if (MI->getOpcode() == Colossus::LABEL) {
      (*OutStreamer).emitLabel(MI->getOperand(0).getMCSymbol());
    } else {
      MCInst MCI = MCInstLowering.Lower(MI);
      EmitToStreamer(*OutStreamer, MCI);
    }
  }
}

void ColossusAsmPrinter::
printOperand(const MachineInstr *MI, int opNum, raw_ostream &O) {
  const MachineOperand &MO = MI->getOperand(opNum);
  switch (MO.getType()) {
  default:
    llvm_unreachable("not implemented");
  case MachineOperand::MO_Register:
    O << ColossusInstPrinter::getRegisterName(MO.getReg());
    break;
  case MachineOperand::MO_Immediate:
    O << MO.getImm();
    break;
  case MachineOperand::MO_MachineBasicBlock:
    MO.getMBB()->getSymbol()->print(O, MAI);
    return;
  case MachineOperand::MO_GlobalAddress:
    getSymbol(MO.getGlobal())->print(O, MAI);
    break;
  case MachineOperand::MO_BlockAddress:
    O <<  GetBlockAddressSymbol(MO.getBlockAddress())->getName();
    break;
  case MachineOperand::MO_ExternalSymbol:
    O << MO.getSymbolName();
    break;
  }
}

/// Print out an operand for an inline asm expression.
bool ColossusAsmPrinter::
PrintAsmOperand(const MachineInstr *MI,
                unsigned OpNo,
                const char *ExtraCode,
                raw_ostream &O) {
  // Print the operand if there is no operand modifier.
  if (!ExtraCode || !ExtraCode[0]) {
    printOperand(MI, OpNo, O);
    return false;
  }
  // Otherwise, fallback on the default implementation.
  return AsmPrinter::PrintAsmOperand(MI, OpNo, ExtraCode, O);
}

bool ColossusAsmPrinter::
PrintAsmMemoryOperand(const MachineInstr *MI,
                      unsigned OpNum,
                      const char *ExtraCode,
                      raw_ostream &O) {
  if (ExtraCode && ExtraCode[0]) {
    return true; // Unknown modifier.
  }
  printOperand(MI, OpNum, O);
  O << ", ";
  printOperand(MI, OpNum + 1, O);
  return false;
}

// Force static initialization.
extern "C" LLVM_EXTERNAL_VISIBILITY void LLVMInitializeColossusAsmPrinter() {
  RegisterAsmPrinter<ColossusAsmPrinter> X(getTheColossusTarget());
}
