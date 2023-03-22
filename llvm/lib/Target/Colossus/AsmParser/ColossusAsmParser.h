//===-- ColossusAsmParser.h - Parse Colossus assembly instructions ------===//
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

#ifndef LLVM_LIB_TARGET_COLOSSUSASMPARSER_H
#define LLVM_LIB_TARGET_COLOSSUSASMPARSER_H

#include "Colossus.h"
#include "ColossusRegInfoGenerated.h"
#include "MCTargetDesc/ColossusMCInstrInfo.h"
#include "MCTargetDesc/ColossusMCTargetDesc.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/CodeGen/TargetOpcodes.h"
#include "llvm/MC/MCContext.h"
#include "llvm/MC/MCExpr.h"
#include "llvm/MC/MCInst.h"
#include "llvm/MC/MCParser/MCParsedAsmOperand.h"
#include "llvm/MC/MCParser/MCTargetAsmParser.h"
#include "llvm/MC/MCStreamer.h"
#include "llvm/MC/MCSubtargetInfo.h"
#include "llvm/MC/MCSymbol.h"
#include "llvm/MC/TargetRegistry.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/MathExtras.h"
#include <string>
#include <unordered_map>

#define DEBUG_TYPE "colossus-asm-parser"

using namespace llvm;

class ColossusOperand : public MCParsedAsmOperand {
  enum OperandKind {
    KindToken,
    KindReg,
    KindImm,
    KindMemoryReg,
    KindMemoryRegReg,
    KindMemoryRegImm,
    KindBroadcast,
  };

  OperandKind Kind;
  SMLoc StartLoc, EndLoc;

  bool AllowInvalid;

  // A string of length Length, starting at Data.
  struct TokenOp {
    const char *Data;
    unsigned Length;
  };

  struct RegOp {
    unsigned RegNum;
    ColossusMCInstrInfo::OperandModifier OperandModifier;
    unsigned Broadcast;
  };

  struct ImmOp {
    const MCExpr *Val;
  };

  struct MemOp {
    unsigned Base;
    unsigned DeltaReg;
    unsigned OffsetReg;
    const MCExpr *OffsetImm;
  };

  union {
    struct TokenOp Token;
    struct RegOp Reg;
    struct ImmOp Imm;
    struct MemOp Mem;
  };

public:
  ColossusOperand(OperandKind kind, SMLoc startLoc, SMLoc endLoc,
                  bool allowInvalid = false)
      : Kind(kind), StartLoc(startLoc), EndLoc(endLoc),
        AllowInvalid(allowInvalid) {}

  void setAllowInvalid() { AllowInvalid = true; }

  // Create particular kinds of operand.
  static std::unique_ptr<ColossusOperand> createToken(StringRef Str,
                                                      SMLoc Loc) {
    auto Op = std::make_unique<ColossusOperand>(KindToken, Loc, Loc);
    Op->Token.Data = Str.data();
    Op->Token.Length = Str.size();
    return Op;
  }

  static std::unique_ptr<ColossusOperand>
  createReg(unsigned Num, SMLoc StartLoc, SMLoc EndLoc,
            ColossusMCInstrInfo::OperandModifier OperandModifier =
                ColossusMCInstrInfo::OperandNoPostInc,
            unsigned Broadcast = 0) {
    auto Op = std::make_unique<ColossusOperand>(KindReg, StartLoc, EndLoc);
    Op->Reg.RegNum = Num;
    Op->Reg.OperandModifier = OperandModifier;
    Op->Reg.Broadcast = Broadcast;
    return Op;
  }

  static std::unique_ptr<ColossusOperand> createBroadcast(unsigned Num,
                                                          SMLoc StartLoc,
                                                          SMLoc EndLoc,
                                                          unsigned Broadcast) {
    auto Op = createReg(Num, StartLoc, EndLoc,
                        ColossusMCInstrInfo::OperandNoPostInc, Broadcast);
    Op->Kind = KindBroadcast;
    return Op;
  }

  static std::unique_ptr<ColossusOperand> createImm(const MCExpr *Expr,
                                                    SMLoc StartLoc,
                                                    SMLoc EndLoc,
                                                    bool AllowInvalid = false) {
    auto Op = std::make_unique<ColossusOperand>(KindImm, StartLoc, EndLoc,
                                                AllowInvalid);
    Op->Imm.Val = Expr;
    return Op;
  }

  static std::unique_ptr<ColossusOperand>
  createMEMrr(unsigned Base, unsigned Offset, SMLoc StartLoc, SMLoc EndLoc) {
    auto Op =
        std::make_unique<ColossusOperand>(KindMemoryReg, StartLoc, EndLoc);
    Op->Mem.Base = Base;
    Op->Mem.OffsetReg = Offset;
    Op->Mem.OffsetImm = nullptr;
    return Op;
  }

  static std::unique_ptr<ColossusOperand>
  createMEMrrr(unsigned Base, unsigned Delta, unsigned Offset, SMLoc StartLoc,
               SMLoc EndLoc) {
    auto Op =
        std::make_unique<ColossusOperand>(KindMemoryRegReg, StartLoc, EndLoc);
    Op->Mem.Base = Base;
    Op->Mem.DeltaReg = Delta;
    Op->Mem.OffsetReg = Offset;
    Op->Mem.OffsetImm = nullptr;
    return Op;
  }

  static std::unique_ptr<ColossusOperand>
  createMEMrri(unsigned Base, unsigned Delta, const MCExpr *Offset,
               SMLoc StartLoc, SMLoc EndLoc) {
    auto Op =
        std::make_unique<ColossusOperand>(KindMemoryRegImm, StartLoc, EndLoc);
    Op->Mem.Base = Base;
    Op->Mem.DeltaReg = Delta;
    Op->Mem.OffsetReg = Colossus::NoRegister;
    Op->Mem.OffsetImm = Offset;
    return Op;
  }

  // Two-operand addressing mode with delta offset set to a zero register.
  static std::unique_ptr<ColossusOperand>
  createMEMrr3(unsigned Base, unsigned Offset, SMLoc StartLoc, SMLoc EndLoc) {
    auto Op =
        std::make_unique<ColossusOperand>(KindMemoryRegReg, StartLoc, EndLoc);
    Op->Mem.Base = Base;
    Op->Mem.DeltaReg = Colossus::MZERO;
    Op->Mem.OffsetReg = Offset;
    Op->Mem.OffsetImm = nullptr;
    return Op;
  }

  // Two-operand addressing mode with delta offset set to a zero register.
  static std::unique_ptr<ColossusOperand> createMEMri3(unsigned Base,
                                                       const MCExpr *Offset,
                                                       SMLoc StartLoc,
                                                       SMLoc EndLoc) {
    auto Op =
        std::make_unique<ColossusOperand>(KindMemoryRegImm, StartLoc, EndLoc);
    Op->Mem.Base = Base;
    Op->Mem.DeltaReg = Colossus::MZERO;
    Op->Mem.OffsetReg = Colossus::NoRegister;
    Op->Mem.OffsetImm = Offset;
    return Op;
  }

  // Token operands
  bool isToken() const override { return Kind == KindToken; }
  StringRef getToken() const {
    assert(Kind == KindToken && "Not a token");
    return StringRef(Token.Data, Token.Length);
  }

  // Register operands.
  bool isReg() const override { return Kind == KindReg; }
  unsigned getReg() const override {
    assert((Kind == KindReg || Kind == KindBroadcast) && "Not a register");
    return Reg.RegNum;
  }

  ColossusMCInstrInfo::OperandModifier getOperandModifier() const {
    assert(Kind == KindReg && "Not a register");
    return Reg.OperandModifier;
  }

  // Immediate operands.
  bool isImm() const override { return Kind == KindImm; }
  const MCExpr *getImm() const {
    assert(Kind == KindImm && "Not an immediate");
    return Imm.Val;
  }
  template <unsigned N> bool isImmiz() const {
    if (Kind != KindImm)
      return false;
    auto *CE = dyn_cast<MCConstantExpr>(Imm.Val);
    if (!CE)
      return false;
    int64_t Value = CE->getValue();
    if (Value < 0) {
      return isShiftedInt<N, 32 - N>(Value);
    }
    return isShiftedUInt<N, 32 - N>(Value);
  }
  template <unsigned N> bool isImmzi() const {
    if (Kind != KindImm)
      return false;
    auto *CE = dyn_cast<MCConstantExpr>(Imm.Val);
    if (!CE)
      return false;
    int64_t Value = CE->getValue();
    return isUInt<N>(Value);
  }
  template <unsigned N> bool isImmsi() const {
    if (Kind != KindImm)
      return false;
    auto *CE = dyn_cast<MCConstantExpr>(Imm.Val);
    if (!CE)
      return false;
    int64_t Value = CE->getValue();
    return isInt<N>(Value);
  }
  bool isSymbolAddendExpr() const {
    if (Kind != KindImm) {
      return false;
    }
    auto *BinExpr = dyn_cast<MCBinaryExpr>(Imm.Val);
    if (!BinExpr) {
      return false;
    }
    return isa<MCSymbolRefExpr>(BinExpr->getLHS()) &&
          (isa<MCSymbolRefExpr>(BinExpr->getRHS()) ||
           isa<MCConstantExpr>(BinExpr->getRHS()));
  }
  static bool isSymbolRefExprLeaf(const MCExpr *Expr) {
    return isa<MCSymbolRefExpr>(Expr);
  }
  static bool isSymbolRefExpr(const MCExpr *Expr) {
    if (isSymbolRefExprLeaf(Expr))
      return true;
    if (const MCBinaryExpr *BinExpr = dyn_cast<MCBinaryExpr>(Expr))
      return isSymbolRefExpr(BinExpr->getLHS()) &&
             isSymbolRefExpr(BinExpr->getRHS());
    return false;
  }
  bool isSymbolRefExpr() const {
    if (Kind != KindImm)
      return false;
    return isSymbolRefExpr(Imm.Val);
  }

  static bool isValidRptExprLeaf(const MCExpr *Expr) {
    return isa<MCSymbolRefExpr>(Expr) || isa<MCConstantExpr>(Expr);
  }
  static bool isValidRptExpr(const MCExpr *Expr) {
    if (isValidRptExprLeaf(Expr)) {
      return true;
    }
    if (const MCBinaryExpr *BinExpr = dyn_cast<MCBinaryExpr>(Expr)) {
      return isValidRptExpr(BinExpr->getLHS()) &&
             isValidRptExpr(BinExpr->getRHS());
    }
    return false;
  }
  bool isValidRptExpr() const {
    // A valid rpt expression contains nested binary expressions with labels
    // and constants, e.g. '((<label1> - <label2>) / <const) - <const>'.
    if (Kind != KindImm) {
      return false;
    }
    return isValidRptExpr(Imm.Val);
  }

  // Accumulator register operands.
  bool isACCOperand() const { return Kind == KindReg; }
  bool isACCPairOperand() const { return Kind == KindReg; }
  bool isACCQuadOperand() const { return Kind == KindReg; }

  // Memory operands.
  bool isMEMrr() const { return Kind == KindMemoryReg; }
  bool isMEMrrr() const { return Kind == KindMemoryRegReg; }
  bool isMEMrri() const { return Kind == KindMemoryRegImm; }
  bool isMEMrr3() const { return Kind == KindMemoryRegReg; }
  bool isMEMri3() const { return Kind == KindMemoryRegImm; }
  bool isMem() const override { return isMEMrr() || isMEMrrr() || isMEMrri(); }

  unsigned getMemBase() const {
    assert((Kind == KindMemoryReg || Kind == KindMemoryRegReg ||
            Kind == KindMemoryRegImm) &&
           "Not a memory operand");
    return Mem.Base;
  }

  unsigned getMemDelta() const {
    assert((Kind == KindMemoryRegReg || Kind == KindMemoryRegImm) &&
           "Not a memory operand");
    return Mem.DeltaReg;
  }

  unsigned getMemOffsetReg() const {
    assert((Kind == KindMemoryReg || Kind == KindMemoryRegReg) &&
           "Not a memory operand");
    return Mem.OffsetReg;
  }

  const MCExpr *getMemOffsetImm() const {
    assert(Kind == KindMemoryRegImm && "Not a memory operand");
    return Mem.OffsetImm;
  }

  // Override MCParsedAsmOperand.
  SMLoc getStartLoc() const override { return StartLoc; }
  SMLoc getEndLoc() const override { return EndLoc; }
  void print(raw_ostream &OS) const override;

  // Used by the TableGen code to add particular types of operand
  // to an instruction.
  void addRegOperands(MCInst &Inst, unsigned N) const {
    assert(N == 1 && "Invalid number of operands");
    Inst.addOperand(MCOperand::createReg(getReg()));
  }

  void addImmOperands(MCInst &Inst, unsigned N) const {
    assert(N == 1 && "Invalid number of operands");
    // Add as immediates when possible.  Null MCExpr = 0.
    auto Expr = getImm();
    if (!Expr)
      Inst.addOperand(MCOperand::createImm(0));
    else if (auto *CE = dyn_cast<MCConstantExpr>(Expr))
      Inst.addOperand(MCOperand::createImm(CE->getValue()));
    else
      Inst.addOperand(MCOperand::createExpr(Expr));
  }

  void addMEMrrOperands(MCInst &Inst, unsigned N) {
    assert(N == 2 && "Invalid number of operands");
    assert(getMemOffsetReg() != Colossus::NoRegister && "Invalid offset reg");
    Inst.addOperand(MCOperand::createReg(getMemBase()));
    Inst.addOperand(MCOperand::createReg(getMemOffsetReg()));
  }

  void addMEMrrrOperands(MCInst &Inst, unsigned N) {
    assert(N == 3 && "Invalid number of operands");
    assert(getMemOffsetReg() != Colossus::NoRegister && "Invalid offset reg");
    Inst.addOperand(MCOperand::createReg(getMemBase()));
    Inst.addOperand(MCOperand::createReg(getMemDelta()));
    Inst.addOperand(MCOperand::createReg(getMemOffsetReg()));
  }

  void addMEMrriOperands(MCInst &Inst, unsigned N) {
    assert(N == 3 && "Invalid number of operands");
    Inst.addOperand(MCOperand::createReg(getMemBase()));
    Inst.addOperand(MCOperand::createReg(getMemDelta()));
    if (const MCConstantExpr *CE =
            dyn_cast<MCConstantExpr>(getMemOffsetImm())) {
      Inst.addOperand(MCOperand::createImm(CE->getValue()));
    } else {
      Inst.addOperand(MCOperand::createImm(0));
    }
  }

  void addMEMrr3Operands(MCInst &Inst, unsigned N) {
    assert(N == 3 && "Invalid number of operands");
    assert(getMemOffsetReg() != Colossus::NoRegister && "Invalid offset reg");
    Inst.addOperand(MCOperand::createReg(getMemBase()));
    Inst.addOperand(MCOperand::createReg(Colossus::MZERO));
    Inst.addOperand(MCOperand::createReg(getMemOffsetReg()));
  }

  // Used by the TableGen code to check for particular operand types.
  bool isImm1zi() const { return isImmzi<1>(); }
  bool isImm2zi() const { return isImmzi<2>(); }
  bool isImm3zi() const { return isImmzi<3>(); }
  bool isImm4zi() const { return isImmzi<4>(); }
  bool isImm6zi() const { return isImmzi<6>(); }
  bool isImm7zi() const { return isImmzi<7>(); }
  bool isImm8zi() const { return isImmzi<8>(); }
  bool isImm11zi() const { return isImmzi<11>(); }
  bool isImm12zi() const { return isImmzi<12>(); }
  bool isImm13zi() const { return isImmzi<13>(); }
  bool isImm16zi() const { return isImmzi<16>(); }
  bool isImm18zi() const { return isImmzi<18>(); }
  bool isImm19zi() const { return isImmzi<19>(); }
  bool isImm20zi() const { return isImmzi<20>(); }

  bool isImm8si() const { return isImmsi<8>(); }
  bool isImm11si() const { return isImmsi<11>(); }
  bool isImm12si() const { return isImmsi<12>(); }
  bool isImm16si() const { return isImmsi<16>(); }

  bool isImm12iz() const { return isImmiz<12>(); }
  bool isImm16iz() const { return isImmiz<16>(); }

  bool isAddress() const { return true; }

  bool isRunOperand() const {
    return isSymbolAddendExpr() || isSymbolRefExpr() || isImmzi<16>();
  }

  bool isRel8Operand() const {
    return isValidRptExpr() || isSymbolAddendExpr() || isSymbolRefExpr() ||
           isImmzi<8>();
  }

  bool isRel16Operand() const {
    return isSymbolAddendExpr() || isSymbolRefExpr() || isImmzi<16>();
  }

  bool isRel19S2Operand() const {
    return (AllowInvalid || isSymbolAddendExpr() || isSymbolRefExpr() ||
            isImmzi<19>());
  }

  bool isRel20Operand() const {
    return isSymbolAddendExpr() || isSymbolRefExpr() || isImmzi<20>();
  }

  bool isRel21Operand() const {
    return isSymbolAddendExpr() || isSymbolRefExpr() || isImmzi<21>();
  }

  bool isBroadcastLowerOperand() const {
    return Kind == KindBroadcast && Reg.Broadcast == COLOSSUS_TOP_BCAST_F16L;
  }

  bool isBroadcastUpperOperand() const {
    return Kind == KindBroadcast && Reg.Broadcast == COLOSSUS_TOP_BCAST_F16U;
  }

  bool isBroadcastOperand() const {
    return Kind == KindBroadcast && Reg.Broadcast == COLOSSUS_TOP_BCAST_F32;
  }

  bool isTrapOperand() const {
    return isSymbolAddendExpr() || isSymbolRefExpr() || isImmzi<8>();
  }
};

class ColossusAsmParser : public MCTargetAsmParser {
#define GET_ASSEMBLER_HEADER
#include "ColossusGenAsmMatcher.inc"

private:
  const MCSubtargetInfo &STI;
  MCAsmParser &Parser;
  const MCInstrInfo &MII;

  bool AllowInvalidBundles;
  bool AllowInvalidOperands;
  bool AllowInvalidExecutionMode;
  bool InBundle;
  bool AllowOptimzations;
  MCInst InstructionBundle;

  typedef llvm::StringMap<llvm::Optional<unsigned>> ArchMap;
  typedef std::tuple<std::string, bool, bool, ArchMap> RegDef;

  struct Register {
    unsigned Num;
    SMLoc StartLoc, EndLoc;
    ColossusMCInstrInfo::OperandModifier OperandModifier;
    unsigned Broadcast;
  };

  struct CSRInfo {
    bool AvailableInSupervisor;
    bool AvailableInWorker;
    ArchMap ArchAvailability;
    bool AvailableInCurrentMode(bool isSupervisor) const {
      return isSupervisor ? AvailableInSupervisor : AvailableInWorker;
    }
    llvm::Optional<unsigned>
    getRegNumForArch(std::string const &ArchName) const {
      return ArchAvailability.lookup(ArchName);
    }
  };

  std::unordered_map<std::string, CSRInfo> CSRDefines;

  SMLoc getLoc() const { return Parser.getTok().getLoc(); }
  bool parseSingleOperand(std::unique_ptr<ColossusOperand> &);
  bool parseOperand(OperandVector &Operands, StringRef Mnemonic);
  bool tryParseRegister(Register &reg, bool allowPostinc = true);
  bool tryParseCSR(const MCExpr *&Expr);
  std::string getArchString();
  void emitInstructionBundle(MCStreamer &Out);
  // Emit a single instruction or an instruction bundle.
  // Returns false if instruction is the first in a bundle, or if the bundle is
  // invalid, otherwise returns true.
  bool EmitInstruction(MCInst &Inst, MCStreamer &Out, SMLoc &IDLoc);

  // Custom parsing for immediate address operands.
  OperandMatchResultTy parseImmAddressOperand(OperandVector &Operands);

  // Custom parsing for accumulator register operands.
  template <int vecSize>
  OperandMatchResultTy parseACCOperand(OperandVector &Operands);

  OperandMatchResultTy parseBroadcastOperand(OperandVector &Operands);

  // Custom parsing for memory MEM* operands.
  OperandMatchResultTy parseMEM2Operand(OperandVector &Operands);
  OperandMatchResultTy parseMEM3Operand(OperandVector &Operands);

public:
  ColossusAsmParser(const MCSubtargetInfo &sti, MCAsmParser &parser,
                    const MCInstrInfo &MII, const MCTargetOptions &Options)
      : MCTargetAsmParser(Options, sti, MII), STI(sti), Parser(parser),
        MII(MII), AllowInvalidBundles(false), AllowInvalidOperands(false),
        AllowInvalidExecutionMode(false), InBundle(false),
        AllowOptimzations(false) {
    InstructionBundle.setOpcode(TargetOpcode::BUNDLE);

    // Keep CSRs in their own data structure
    std::vector<RegDef> RegDefines = CSR_REGISTERS;
    for (auto &Reg : RegDefines) {
      CSRInfo Info{std::get<1>(Reg), std::get<2>(Reg), std::get<3>(Reg)};
      CSRDefines[std::get<0>(Reg)] = Info;
    }
    setAvailableFeatures(ComputeAvailableFeatures(STI.getFeatureBits()));
  }

  ~ColossusAsmParser();

  bool ValidateOperands(OperandVector &Operands, MCInst &Inst);
  bool ValidateBundle(SMLoc L);
  void SwapBundleInstructionsIfRequired();

  ColossusMCInstrInfo::OperandModifier ParseOperandModifier();

  unsigned ParseOperandBroadcast(StringRef token);

  // Override MCTargetAsmParser.
  bool parsePrimaryExpr(const MCExpr *&Res, SMLoc &EndLoc) override;
  bool ParseDirective(AsmToken DirectiveID) override;
  OperandMatchResultTy tryParseRegister(unsigned &RegNo, SMLoc &StartLoc,
                                        SMLoc &EndLoc) override;
  bool ParseRegister(unsigned &RegNo, SMLoc &StartLoc, SMLoc &EndLoc) override;
  bool ParseInstruction(ParseInstructionInfo &Info, StringRef Name,
                        SMLoc NameLoc, OperandVector &Operands) override;
  bool MatchAndEmitInstruction(SMLoc IDLoc, unsigned &Opcode,
                               OperandVector &Operands, MCStreamer &Out,
                               uint64_t &ErrorInfo,
                               bool MatchingInlineAsm) override;

  llvm::Optional<bool> ExpandMacroInstruction(MCInst &Inst, SMLoc IDLoc,
                                              MCStreamer &Out);

  llvm::Optional<bool> ExpandMacroLdconst(MCInst &Inst, SMLoc IDLoc,
                                          MCStreamer &Out, unsigned SetziOpcode,
                                          unsigned OrOpcode);

  llvm::Optional<bool> ExpandMacroSubImm(MCInst &Inst, SMLoc IDLoc,
                                         MCStreamer &Out);

  bool ParseFloat16(bool Negate, uint16_t &Value);

  void onStatementPrefix(AsmToken Token) override;

  bool isSupervisor();
  void switchMode();
};

#endif // LLVM_LIB_TARGET_COLOSSUSASMPARSER_H
