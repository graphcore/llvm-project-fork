//=== ColossusInstPrinter.cpp - Convert Colossus MCInst to assembly -------===//
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
// This class prints an Colossus MCInst to a .s file.
//
//===----------------------------------------------------------------------===//

#include "ColossusInstPrinter.h"
#include "ColossusMCInstrInfo.h"
#include "llvm/ADT/StringExtras.h"
#include "llvm/CodeGen/TargetOpcodes.h"
#include "llvm/MC/MCExpr.h"
#include "llvm/MC/MCInst.h"
#include "llvm/MC/MCInstrInfo.h"
#include "llvm/MC/MCSymbol.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Support/NativeFormatting.h"

using namespace llvm;

#define DEBUG_TYPE "asm-printer"

#define PRINT_ALIAS_INSTR
#include "ColossusGenAsmWriter.inc"

const char ColossusInstPrinter::BundlePadding = '\t';

void ColossusInstPrinter::printRegName(raw_ostream &OS, unsigned RegNo) const {
  OS << StringRef(getRegisterName(RegNo)).lower();
}

void ColossusInstPrinter::printSingleInst(const MCInst *MI, uint64_t Address,
                                          StringRef Annot,
                                          const MCSubtargetInfo &STI,
                                          raw_ostream &O) {
  if (!printAliasInstr(MI, Address, STI, O))
    printInstruction(MI, Address, STI, O);
  printAnnotation(O, Annot);
}

void ColossusInstPrinter::printInst(const MCInst *MI, uint64_t Address,
                                    StringRef Annot, const MCSubtargetInfo &STI,
                                    raw_ostream &O) {
  const char StartBundle = '{', EndBundle = '}';

  if (MI->getOpcode() == TargetOpcode::BUNDLE) {
    O << BundlePadding << StartBundle;

    for (const auto &InstOperand : *MI) {
      const MCInst *Instruction = InstOperand.getInst();
      O << '\n' << BundlePadding;
      printSingleInst(Instruction, Address, Annot, STI, O);
    }
    O << '\n' << BundlePadding << EndBundle;
  } else {
    printSingleInst(MI, Address, Annot, STI, O);
  }
}

template<int sz>
void ColossusInstPrinter::printImmSIOperand(const MCInst *MI, unsigned OpNum,
                                            const MCSubtargetInfo &STI,
                                            raw_ostream &O) {
  const MCOperand &Op = MI->getOperand(OpNum);
  int64_t Value = Op.getImm();

  if (getPrintImmHex()) {
    // Consider only the first 'sz' bits from 'Value'. write_hex() will
    // determine the number of nibbles needed to be written based on the
    // truncated value.
    auto HexValue = static_cast<uint64_t>(Value & ((1ull << sz) - 1ull));
    llvm::write_hex(O, HexValue, llvm::HexPrintStyle::PrefixLower);
  } else {
    O << Value;
  }
}

template<unsigned scale>
void ColossusInstPrinter::printBranchOperand(const MCInst *MI,
                                             unsigned int OpNo,
                                             const MCSubtargetInfo &STI,
                                             raw_ostream &O) {
  if (!MI->getOperand(OpNo).isImm())
    return printOperand(MI, OpNo, STI, O);

  O << "0x";
  auto Value = (uint32_t) MI->getOperand(OpNo).getImm() << scale;
  O.write_hex(SignExtend32<32>(Value));
}

void ColossusInstPrinter::printACCOperand(const MCInst *MI,
                                          unsigned int OpNo,
                                          raw_ostream &O) {
  const MCOperand &Op = MI->getOperand(OpNo);
  assert(Op.isReg() && "Expected register ACC operand.");
  O << MRI.getEncodingValue(Op.getReg());
}

void ColossusInstPrinter::
printOperand(const MCInst *MI, unsigned OpNo, const MCSubtargetInfo &STI,
             raw_ostream &O) {
  const MCOperand &Op = MI->getOperand(OpNo);
  if (Op.isReg()) {
    printRegName(O, Op.getReg());

    switch (ColossusMCInstrInfo::getOperandModifier(MII, *MI, OpNo)) {
    default:
      break;
    case ColossusMCInstrInfo::OperandPostInc:
      O << "++";
      break;
    case ColossusMCInstrInfo::OperandPostIncOffset:
      O << "+=";
      break;
    case ColossusMCInstrInfo::OperandPostIncDelta:
      O << ">>";
      break;
    case ColossusMCInstrInfo::OperandPostMod:
      O << "@";
      break;
    }
    return;
  }

  if (Op.isImm()) {
    int64_t Value = Op.getImm();

    if (getPrintImmHex()) {
      O << formatHex(static_cast<uint64_t>(Value));
    } else {
      // All immediates here are 32-bit and all signed immediates are already
      // handled in printImmSIOperand(), so we cast all values to 32-bit
      // unsigned values to avoid ambiguities and comply with the spec.
      O << formatDec(static_cast<uint32_t>(Value));
    }

    return;
  }

  assert(Op.isExpr() && "unknown operand kind in printOperand");
  Op.getExpr()->print(O, &MAI);
}

void ColossusInstPrinter::
printMEM2Operand(const MCInst *MI, int opNum, const MCSubtargetInfo &STI,
                 raw_ostream &O) {
  printOperand(MI, opNum, STI, O);
  O << ", ";
  printOperand(MI, opNum + 1, STI, O);
}

void ColossusInstPrinter::printBroadcastLowerOperand(const MCInst *MI,
                                                     int opNum,
                                                     const MCSubtargetInfo &STI,
                                                     raw_ostream &O) {
  const MCOperand &Op = MI->getOperand(opNum);
  printRegName(O, Op.getReg());
  O << ":BL";
}

void ColossusInstPrinter::printBroadcastUpperOperand(const MCInst *MI,
                                                     int opNum,
                                                     const MCSubtargetInfo &STI,
                                                     raw_ostream &O) {
  const MCOperand &Op = MI->getOperand(opNum);
  printRegName(O, Op.getReg());
  O << ":BU";
}

void ColossusInstPrinter::printBroadcastOperand(const MCInst *MI, int opNum,
                                                const MCSubtargetInfo &STI,
                                                raw_ostream &O) {
  const MCOperand &Op = MI->getOperand(opNum);
  printRegName(O, Op.getReg());
  O << ":B";
}

void ColossusInstPrinter::
printMEM3Operand(const MCInst *MI, int opNum, const MCSubtargetInfo &STI,
                 raw_ostream &O) {
  printOperand(MI, opNum, STI, O);
  O << ", ";
  printOperand(MI, opNum + 1, STI, O);
  O << ", ";
  printOperand(MI, opNum + 2, STI, O);
}

void ColossusInstPrinter::printARPairOperand(const MCInst *MI, unsigned opNum,
                                             raw_ostream &O) {
  const MCOperand &Op = MI->getOperand(opNum);
  printRegName(O, Op.getReg());
}

void ColossusInstPrinter::printARQuadOperand(const MCInst *MI, unsigned opNum,
                                             raw_ostream &O) {
  const MCOperand &Op = MI->getOperand(opNum);
  printRegName(O, Op.getReg());
}
