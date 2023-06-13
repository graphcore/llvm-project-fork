//===-- ColossusAsmParser.cpp - Parse Colossus assembly instructions ------===//
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

#include "ColossusAsmParser.h"
#include "TargetInfo/ColossusTargetInfo.h"
#include "llvm/MC/MCParser/MCAsmLexer.h"

#define GET_REGISTER_MATCHER
#define GET_SUBTARGET_FEATURE_NAME
#define GET_MATCHER_IMPLEMENTATION
#include "ColossusGenAsmMatcher.inc"

bool ColossusAsmParser::parsePrimaryExpr(const MCExpr *&Res, SMLoc &EndLoc) {
  if (!tryParseCSR(Res))
    return false;
  return Parser.parsePrimaryExpr(Res, EndLoc, nullptr);
}

bool ColossusAsmParser::ParseDirective(AsmToken DirectiveID) {
  StringRef IDVal = DirectiveID.getIdentifier();

  if (IDVal == ".warn_on_invalid_bundles") {
    AllowInvalidBundles = true;
  } 
  else if (IDVal == ".error_on_invalid_bundles") {
    AllowInvalidBundles = false;
  }
  else if (IDVal == ".allow_invalid_operands") {
    AllowInvalidOperands = true;
  }
  else if (IDVal == ".error_on_invalid_operands") {
    AllowInvalidOperands = false;
  }
  else if (IDVal == ".allow_invalid_execution_mode") {
    AllowInvalidExecutionMode = true;
  }
  else if (IDVal == ".error_on_invalid_execution_mode") {
    AllowInvalidExecutionMode = false;
  }
  else if (IDVal == ".allow_invalid_repeat") {
    getParser().getStreamer().emitAssemblerFlag(MCAF_AllowInvalidRepeat);
  }
  else if (IDVal == ".allow_optimizations") {
    AllowOptimzations = true;
    getParser().getStreamer().emitAssemblerFlag(MCAF_AllowOptimizations);
  }
  else if (IDVal == ".half") {
    std::unique_ptr<ColossusOperand> Op;
    if (!parseSingleOperand(Op) && Op.get() && Op->isImm()) {
      getParser().getStreamer().emitValue(Op->getImm(), 2);
    } else {
      Error(getLoc(), "invalid .half operand");
      return true;
    }
  }
  else if (IDVal == ".supervisor") {
    if (!isSupervisor())
      switchMode();
  }
  else if (IDVal == ".worker") {
    if (isSupervisor())
      switchMode();
  }
  else {
    return true;
  }

  return false;
}

static unsigned MatchRegisterName(StringRef Name);
static unsigned MatchRegisterAltName(StringRef Name);

bool ColossusAsmParser::tryParseRegister(Register &Reg, bool allowPostinc) {
  Reg.StartLoc = Parser.getTok().getLoc();

  if (Parser.getTok().isNot(AsmToken::Dollar))
    return true;

  // Expect a register name.
  if (Parser.getLexer().peekTok().isNot(AsmToken::Identifier))
    return true;

  std::string RegName = "$";
  RegName +=  Parser.getLexer().peekTok().getString();
  unsigned RegNum = MatchRegisterName(RegName);

  // The post modified operand syntax is more difficult to parse than other
  // post modified syntaxes as the '@' could be a valid part of an identifier,
  // so is included in the register name token. Look for it here, and then after
  // the register has been matched try and look for other suffixes.
  ColossusMCInstrInfo::OperandModifier PostInc =
      ColossusMCInstrInfo::OperandNoPostInc;
  if (RegNum == 0 && RegName.back() == '@') {
    PostInc = ColossusMCInstrInfo::OperandPostMod;
    RegNum = MatchRegisterName(RegName.substr(0, RegName.size() - 1));
  }

  // Also handle some aliases.
  if (RegNum == 0) {
    RegNum = MatchRegisterAltName(RegName);
  }

  if (RegNum == 0)
    return true;

  // Read the register name
  Parser.Lex();

  // Read the second part of the register range syntax.
  //   $r[0-9]+:[0-9]+
  if (Parser.getLexer().peekTok().is(AsmToken::Colon)) {
    // Read colon.
    Parser.Lex();
    // Read register number.
    Parser.Lex();
    unsigned RegHi;
    if (Parser.getTok().getString().getAsInteger(10, RegHi)) {
      return true;
    }

    int PairID = -1, QuadID = -1, OctadID = -1;
    int RegSpan;
    int RegClassID;
    const auto *MRC = &ColossusMCRegisterClasses[Colossus::MRRegClassID];
    const auto *ARC = &ColossusMCRegisterClasses[Colossus::ARRegClassID];

    // Work out the current and super register classes
    if (ARC->contains(RegNum)) {
      PairID = Colossus::ARPairRegClassID;
      QuadID = Colossus::ARQuadRegClassID;
      OctadID = Colossus::AROctadRegClassID;
    } else if (MRC->contains(RegNum)) {
      PairID = Colossus::MRPairRegClassID;
    } else {
      // Unexpected register class.
      return true;
    }

    // Get the architectural register number for RegNum.
    const MCRegisterInfo *MCRI = getContext().getRegisterInfo();
    unsigned LoRegEncoding = MCRI->getEncodingValue(RegNum);

    // Work out register span.
    if (RegHi == LoRegEncoding + 1) {
      RegSpan = 2;
      RegClassID = PairID;
    } else if (QuadID > 0 && RegHi == LoRegEncoding + 3) {
      RegSpan = 4;
      RegClassID = QuadID;
    } else if (OctadID > 0 && RegHi == LoRegEncoding + 7) {
      RegSpan = 8;
      RegClassID = OctadID;
    } else {
      // Invalid register range.
      return true;
    }

    unsigned regIndex = LoRegEncoding / RegSpan;

    // Special case. As we have 15 Register pairs and 15 register quads for Mk3
    // In all architectures $a14:15 and $a11:15 map to AZEROS. So do not scale
    // The register index in this case.
    // See definiton of (MCPhysReg ARQuad and MCPhysReg ARPair in
    // ColossusGenRegisterInfo.inc)
    //
    // TODO: We might want to emit an error if the user tried to specify a pair
    // or quad in this format that is larger than 15... But we don't do that
    // currently.
    if ((RegClassID == Colossus::ARPairRegClassID ||
         RegClassID == Colossus::ARQuadRegClassID ||
         RegClassID == Colossus::AROctadRegClassID) &&
        RegHi == 15)
      regIndex = 15;

    // Need to use pairID or quadId
    RegNum = ColossusMCRegisterClasses[RegClassID].getRegister(regIndex);

    // Error if misaligned (T636).
    if (!AllowInvalidOperands && LoRegEncoding % RegSpan) {
      return true;
    }
  }

  Parser.Lex();
  Reg.Num = RegNum;
  Reg.EndLoc = Parser.getTok().getLoc();

  if (PostInc == ColossusMCInstrInfo::OperandNoPostInc) {
    PostInc = ParseOperandModifier();
  }

  Reg.OperandModifier = PostInc;

  if (!allowPostinc &&
      Reg.OperandModifier != ColossusMCInstrInfo::OperandNoPostInc) {
    Error(Reg.StartLoc, "Invalid post increment on operand");
  }
  return false;
}

bool ColossusAsmParser::tryParseCSR(const MCExpr *&Expr) {
  if (Parser.getTok().isNot(AsmToken::Dollar))
    return true;

  // Expect a register name.
  if (Parser.getLexer().peekTok().isNot(AsmToken::Identifier))
    return true;

  std::string RegName = "$";
  RegName += Parser.getLexer().peekTok().getString();

  // Check if register is a CSR.
  CSRInfo Info;

  auto CSRElt = CSRDefines.find(RegName);
  if (CSRElt == CSRDefines.end())
    return true;
  else
    Info = CSRElt->second;

  auto ArchString = getArchString();
  auto RegNum = Info.getRegNumForArch(ArchString);

  if (!RegNum)
    return true;

  if (!Info.AvailableInCurrentMode(isSupervisor()) &&
      !AllowInvalidExecutionMode)
    return Error(Parser.getTok().getLoc(), "The CSR " + RegName + " cannot be" +
                 " used in " + std::string(isSupervisor() ? "Supervisor" : 
                 "Worker") + " mode.");

  Expr = MCConstantExpr::create(*RegNum, getContext());

  Parser.Lex();
  Parser.Lex();
  return false;
}

std::string ColossusAsmParser::getArchString(){
  // Note this STI is not an instance of ColossusSubtarget but actually
  // ColossusGenMCSubtargetInfo.
  FeatureBitset FB = getSTI().getFeatureBits();

  if (FB[Colossus::ModeArchIpu21])
    return "ipu21";
  if (FB[Colossus::ModeArchIpu2])
      return "ipu2";
  return "ipu1";
}

OperandMatchResultTy ColossusAsmParser::tryParseRegister(unsigned &RegNo, SMLoc &StartLoc, SMLoc &EndLoc) {
  Register Reg;
  if (tryParseRegister(Reg))
    return MatchOperand_ParseFail;
  RegNo = Reg.Num;
  StartLoc = Reg.StartLoc;
  EndLoc = Reg.EndLoc;
  return MatchOperand_Success;
}

// Look if there's a post modify on this operand. If so, consume it and
// check later on when we know what instruction this is whether it's valid
// or not.
ColossusMCInstrInfo::OperandModifier ColossusAsmParser::ParseOperandModifier() {
  if (getLexer().is(AsmToken::Plus) &&
      getLexer().peekTok().is(AsmToken::Plus)) {
    Parser.Lex();
    Parser.Lex();
    return ColossusMCInstrInfo::OperandPostInc;
  } else if (getLexer().is(AsmToken::Plus) &&
             getLexer().peekTok().is(AsmToken::Equal)) {
    Parser.Lex();
    Parser.Lex();
    return ColossusMCInstrInfo::OperandPostIncOffset;
  } else if (getLexer().is(AsmToken::GreaterGreater)) {
    Parser.Lex();
    return ColossusMCInstrInfo::OperandPostIncDelta;
  } else if (getLexer().is(AsmToken::At)) {
    Parser.Lex();
    return ColossusMCInstrInfo::OperandPostMod;
  }

  return ColossusMCInstrInfo::OperandNoPostInc;
}

bool ColossusAsmParser::ParseRegister(unsigned &RegNo, SMLoc &StartLoc,
                                      SMLoc &EndLoc) {
  // Expect a register name.
  if (tryParseRegister(RegNo, StartLoc, EndLoc))
    return Error(getLoc(), "invalid register");
  return false;
}

bool ColossusAsmParser::ParseFloat16(bool Negate, uint16_t &Value) {
  bool SuffixSeen = false;
  auto HalfToken = getTok().getString();

  // If infh, remove the suffix so that APFloat can do the conversion.
  if (HalfToken == "infh") {
    HalfToken = "inf";
    SuffixSeen = true;
  }

  APFloat RealVal(APFloat::IEEEhalf(), HalfToken);
  if (Negate) {
    RealVal.changeSign();
  }
  Lex();

  // If not infh, check for the required suffix.
  auto Token = getTok();
  if (Token.is(AsmToken::Identifier) && Token.getString() == "h") {
    Lex();
    SuffixSeen = true;
  }

  if (!SuffixSeen) {
    return Error(getLoc(), "missing h suffix from float16 operand");
  }

  Value = static_cast<int16_t>(RealVal.bitcastToAPInt().getZExtValue());
  return false;
}

bool ColossusAsmParser::
parseSingleOperand(std::unique_ptr<ColossusOperand> &Op) {
  bool Negate = false;

  // For negative real values, we need to look-ahead and consume the sign.
  if (getLexer().getKind() == AsmToken::Minus) {
    auto NextTok = getLexer().peekTok();
    if (NextTok.is(AsmToken::Real) || (NextTok.is(AsmToken::Identifier) &&
                                       NextTok.getString() == "infh")) {
      Negate = true;
      Lex();
    }
  }

  // If inf then we need to convert the token kind to AsmToken::Real.
  AsmToken::TokenKind Kind;
  if (getTok().getString() == "infh") {
    Kind = AsmToken::Real;
  } else {
    Kind = getLexer().getKind();
  }

  switch(Kind) {
  default:
    return Error(getLoc(), "invalid operand");

  case AsmToken::Real: {
    SMLoc StartLoc = getLoc();
    uint16_t Float16;
    if (!ParseFloat16(Negate, Float16)) {
      auto Value = MCConstantExpr::create(Float16, getContext());

      SMLoc EndLoc =
        SMLoc::getFromPointer(Parser.getTok().getLoc().getPointer() - 1);

      Op = ColossusOperand::createImm(Value, StartLoc, EndLoc);
      return false;
    }
    return true;
  }

  case AsmToken::Dollar: {
    Register Reg;
    if (!tryParseRegister(Reg)) {
      Op = ColossusOperand::createReg(Reg.Num, Reg.StartLoc, Reg.EndLoc,
                                      Reg.OperandModifier);
      return false;
    }
    LLVM_FALLTHROUGH;
  }
  // Fall-through - identifiers can start with a $
  case AsmToken::LParen: LLVM_FALLTHROUGH;
  case AsmToken::Identifier: LLVM_FALLTHROUGH;
  case AsmToken::Minus: LLVM_FALLTHROUGH;
  case AsmToken::Integer: {
    SMLoc StartLoc = getLoc();
    const MCExpr *Expr;
    if (getParser().parseExpression(Expr))
      return true;
    SMLoc EndLoc =
      SMLoc::getFromPointer(Parser.getTok().getLoc().getPointer() - 1);
    Op = ColossusOperand::createImm(Expr, StartLoc, EndLoc);
    return false;
  }
  }
  return true;
}

bool ColossusAsmParser::parseOperand(OperandVector &Operands,
                                     StringRef Mnemonic) {
  OperandMatchResultTy ResTy = MatchOperandParserImpl(Operands, Mnemonic, true);

  // If there wasn't a custom match, try the generic matcher below. Otherwise,
  // there was a match, but an error occurred, in which case, just return that
  // the operand parsing failed.
  if (ResTy == MatchOperand_Success || ResTy == MatchOperand_ParseFail)
    return ResTy;

  std::unique_ptr<ColossusOperand> Op;
  if (parseSingleOperand(Op) || !Op) {
    return true;
  }
  Operands.push_back(std::move(Op));
  return false;
}

OperandMatchResultTy
ColossusAsmParser::parseImmAddressOperand(OperandVector &Operands) {
  SMLoc StartLoc = getLoc();
  // Register operands are invalid.
  Register Reg;
  if (!tryParseRegister(Reg)) {
    return MatchOperand_NoMatch;
  }
  // Parse a symbol or expression representing the address immediate.
  const MCExpr *Expr;
  if (!getParser().parseExpression(Expr)) {
    SMLoc EndLoc =
        SMLoc::getFromPointer(Parser.getTok().getLoc().getPointer() - 1);
    Operands.push_back(ColossusOperand::createImm(Expr, StartLoc, EndLoc,
                                                  AllowInvalidOperands));
    return MatchOperand_Success;
  }
  return MatchOperand_NoMatch;
}

unsigned ColossusAsmParser::ParseOperandBroadcast(StringRef token)
{
  // Derived from TileOpBCast in the ArchMan.
  return StringSwitch<unsigned>(token.str())
           .Case("B", COLOSSUS_TOP_BCAST_F32)
           .Case("BL", COLOSSUS_TOP_BCAST_F16L)
           .Case("BU", COLOSSUS_TOP_BCAST_F16U)
           .Default(0);
}

OperandMatchResultTy
ColossusAsmParser::parseBroadcastOperand(OperandVector &Operands) {
  SMLoc StartLoc = getLoc();

  if (Parser.getTok().isNot(AsmToken::Dollar))
    return MatchOperand_NoMatch;

  // Expect a register name.
  if (Parser.getLexer().peekTok().isNot(AsmToken::Identifier))
    return MatchOperand_NoMatch;

  std::string RegName = "$";
  RegName +=  Parser.getLexer().peekTok().getString();

  unsigned RegNum = MatchRegisterName(RegName);
  if (RegNum == 0)
    return MatchOperand_NoMatch;

  AsmToken Tokens[3];
  size_t ReadCount = Parser.getLexer().peekTokens(Tokens);

  if (ReadCount != sizeof(Tokens) / sizeof(Tokens[0]))
      return MatchOperand_NoMatch;

  if (Tokens[1].isNot(AsmToken::Colon))
    return MatchOperand_NoMatch;

  unsigned Broadcast = ParseOperandBroadcast(Tokens[2].getString());
  if (Broadcast) {
    Parser.Lex();
    Parser.Lex();
    Parser.Lex();
    Parser.Lex();
    SMLoc EndLoc = SMLoc::getFromPointer(Parser.getTok().getLoc().getPointer()
                                         - 1);

    Operands.push_back(ColossusOperand::createBroadcast(RegNum, StartLoc,
                                                        EndLoc, Broadcast));
    return MatchOperand_Success;
  }

  return MatchOperand_NoMatch;
}

template<int vecSize>
OperandMatchResultTy
ColossusAsmParser::parseACCOperand(OperandVector &Operands) {
  unsigned RegNum;
  SMLoc StartLoc = getLoc();
  auto &Token = Parser.getTok();
  if (Token.getString().getAsInteger(10, RegNum)) {
    return MatchOperand_NoMatch;
  }
  auto *RC = &ColossusMCRegisterClasses[Colossus::ACCRegClassID];
  if (vecSize == 2) {
    RC = &ColossusMCRegisterClasses[Colossus::ACCPairRegClassID];
    RegNum /= 2;
  }
  if (RegNum >= RC->getNumRegs()) {
    return MatchOperand_NoMatch;
  }
  Lex();
  SMLoc EndLoc =
      SMLoc::getFromPointer(Token.getLoc().getPointer() - 1);
  Operands.push_back(ColossusOperand::createReg(RC->getRegister(RegNum),
                                                StartLoc, EndLoc));
  return MatchOperand_Success;
}

OperandMatchResultTy
ColossusAsmParser::parseMEM2Operand(OperandVector &Operands) {
  SMLoc S, E;
  unsigned BaseReg = 0;
  unsigned OffReg = 0;

  // Base register.
  if (ParseRegister(BaseReg, S, E)) {
    return MatchOperand_NoMatch;
  }

  // Comma?
  if (getLexer().getKind() != AsmToken::Comma) {
    Error(getLexer().getLoc(), "Comma missing");
    return MatchOperand_ParseFail;
  }
  Parser.Lex();

  // Offset register.
  if (ParseRegister(OffReg, S, E)) {
    return MatchOperand_NoMatch;
  }

  // MEMrr
  Operands.push_back(ColossusOperand::createMEMrr(BaseReg, OffReg, S, E));
  return MatchOperand_Success;
}

OperandMatchResultTy
ColossusAsmParser::parseMEM3Operand(OperandVector &Operands) {
  SMLoc S, E;
  Register Reg1, Reg2;
  unsigned BaseReg = 0;

  // Base register.
  if (ParseRegister(BaseReg, S, E)) {
    return MatchOperand_NoMatch;
  }

  // Comma?
  if (getLexer().getKind() != AsmToken::Comma) {
    Error(getLexer().getLoc(), "Comma missing");
    return MatchOperand_ParseFail;
  }
  Parser.Lex();

  // Offset or delta register.
  if (tryParseRegister(Reg1, false)) {
    // If it's not a register, then check for an immediate.
    const MCExpr *Expr;
    S = getLoc();
    if (getParser().parseExpression(Expr)) {
      return MatchOperand_NoMatch;
    }
    // MEMri
    E = SMLoc::getFromPointer(getLoc().getPointer() - 1);

    const auto *MCE = dyn_cast<MCConstantExpr>(Expr);
    if (!MCE) {
      Error(S, "Operand is not a valid immediate");
      return MatchOperand_NoMatch;
    }

    if (MCE->getValue() >= (1 << 12) || MCE->getValue() < 0) {
      Error(S, "Out of bound immediate");
      return MatchOperand_NoMatch;
    }

    Operands.push_back(ColossusOperand::createMEMri3(BaseReg, Expr, S, E));
    return MatchOperand_Success;
  }

  // Comma?
  if (getLexer().getKind() != AsmToken::Comma) {
    // MEMrr
    E = Reg1.EndLoc;
    Operands.push_back(ColossusOperand::createMEMrr3(BaseReg, Reg1.Num, S, E));
    return MatchOperand_Success;
  }
  Parser.Lex();

  // Offset.
  if (tryParseRegister(Reg2, false)) {
    const MCExpr *Expr;
    S = getLoc();
    if (getParser().parseExpression(Expr)) {
      return MatchOperand_NoMatch;
    }
    // MEMrri
    E = SMLoc::getFromPointer(getLoc().getPointer() - 1);

    const auto *MCE = dyn_cast<MCConstantExpr>(Expr);
    if (!MCE) {
      Error(S, "Operand is not a valid immediate");
      return MatchOperand_NoMatch;
    }

    if (MCE->getValue() >= (1 << 12) || MCE->getValue() < 0) {
      Error(S, "Out of bound immediate");
      return MatchOperand_NoMatch;
    }

    Operands.push_back(ColossusOperand::createMEMrri(BaseReg, Reg1.Num,
                                                     Expr, S, E));
    return MatchOperand_Success;
  }

  // MEMrrr
  E = Reg2.EndLoc;
  Operands.push_back(ColossusOperand::createMEMrrr(BaseReg, Reg1.Num,
                                                   Reg2.Num, S, E));
  return MatchOperand_Success;
}

llvm::Optional<bool> ColossusAsmParser::ExpandMacroLdconst(MCInst &Inst,
                                                           SMLoc IDLoc,
                                                           MCStreamer &Out,
                                                           unsigned SetziOpcode,
                                                           unsigned OrOpcode) {
  const unsigned SetziMask = 0xfffff;
  const unsigned OrMask = ~SetziMask;
  auto &DestReg = Inst.getOperand(0);

  if (InBundle) {
    return Error(IDLoc, "macro instruction in bundle");
  }

  if (!Inst.getOperand(1).isImm()) {
    return Error(IDLoc, "operand must be an immediate");
  }

  auto Imm = Inst.getOperand(1).getImm();

  if (Imm > UINT32_MAX) {
    return Error(IDLoc, "immediate is too large");
  }

  // Emit a `setzi $DestReg, Imm[19:0]`.
  Inst.clear();
  Inst.setOpcode(SetziOpcode);
  Inst.setLoc(IDLoc);
  Inst.addOperand(DestReg);
  Inst.addOperand(MCOperand::createImm(Imm & SetziMask));
  Inst.addOperand(MCOperand::createImm(0));  /* coissue. */
  Out.emitInstruction(Inst, STI);

  // If the constant is > 20 bits, emit an
  // `or $DestReg, $DestReg, Imm[31:20]`.
  if (Imm & OrMask) {
    Inst.clear();
    Inst.setOpcode(OrOpcode);
    Inst.setLoc(IDLoc);
    Inst.addOperand(DestReg);
    Inst.addOperand(DestReg);
    Inst.addOperand(MCOperand::createImm(Imm & OrMask));
    Inst.addOperand(MCOperand::createImm(0)); /* coissue. */
    Out.emitInstruction(Inst, STI);
  }
  return true;
}

llvm::Optional<bool> ColossusAsmParser::ExpandMacroSubImm(MCInst &Inst,
                                                          SMLoc IDLoc,
                                                          MCStreamer &Out) {
  auto &DestReg = Inst.getOperand(0);
  auto &SrcReg = Inst.getOperand(1);

  if (!Inst.getOperand(2).isImm()) {
    return Error(IDLoc, "operand must be an immediate");
  }

  auto Imm = Inst.getOperand(2).getImm();
  Imm = -Imm;

  if (Imm > INT16_MAX || Imm < INT16_MIN) {
    return Error(IDLoc, "immediate is out of range");
  }

  // Emit a `add $DestReg, $SrcReg, -$imm`.
  Inst.clear();
  Inst.setOpcode(Colossus::ADD_SI);
  Inst.setLoc(IDLoc);
  Inst.addOperand(DestReg);
  Inst.addOperand(SrcReg);
  Inst.addOperand(MCOperand::createImm(Imm));
  Inst.addOperand(MCOperand::createImm(0)); /* coissue. */
  return EmitInstruction(Inst, Out, IDLoc);
}

llvm::Optional<bool>
ColossusAsmParser::ExpandMacroInstruction(MCInst &Inst, SMLoc IDLoc,
                                          MCStreamer &Out) {
  switch (Inst.getOpcode()) {
  case Colossus::SUB_IMM:
    return ExpandMacroSubImm(Inst, IDLoc, Out);

  case Colossus::LDCONST:
    return ExpandMacroLdconst(Inst, IDLoc, Out, Colossus::SETZI,
                              Colossus::OR_IZ);

  case Colossus::LDCONST_A:
    return ExpandMacroLdconst(Inst, IDLoc, Out, Colossus::SETZI_A,
                              Colossus::OR_IZ_A);

  default:
    return None;
  };
}

bool ColossusAsmParser::ParseInstruction(ParseInstructionInfo &Info,
                                         StringRef Name, SMLoc NameLoc,
                                         OperandVector &Operands) {
  Operands.push_back(ColossusOperand::createToken(Name, NameLoc));

  // Read the remaining operands while we're not at the end of the statement or
  // instruction bundle.
  if (getLexer().isNot(AsmToken::EndOfStatement) &&
      getLexer().isNot(AsmToken::RCurly)) {

    // Read the first operand.
    if (parseOperand(Operands, Name)) {
      Parser.eatToEndOfStatement();
      return true;
    }

    // Read any subsequent operands.
    while (getLexer().is(AsmToken::Comma)) {
      Parser.Lex();
      if (parseOperand(Operands, Name)) {
        Parser.eatToEndOfStatement();
        return true;
      }
    }

    if (getLexer().isNot(AsmToken::RCurly)) {
      if (getLexer().isNot(AsmToken::EndOfStatement)) {
        SMLoc Loc = getLexer().getLoc();
        Parser.eatToEndOfStatement();
        return Error(Loc, "unexpected token in argument list");
      }
    }
  }

  if (getLexer().is(AsmToken::EndOfStatement)) {
    Parser.Lex();
  }

  return false;
}

void ColossusOperand::print(raw_ostream &OS) const {
  switch (Kind) {
  case KindToken:
    OS << "Token: " << getToken();
    return;
  case KindReg:
    OS << "Reg: " << getReg();
    return;
  case KindBroadcast:
    OS << "Broadcast: " << getReg();
    return;
  case KindImm:
    OS << "Imm: " << getImm();
    return;
  case KindMemoryReg:
    OS << "Memory: " << getMemBase()
       << ", " << getMemOffsetReg();
    return;
  case KindMemoryRegReg:
    OS << "Memory: " << getMemBase()
       << ", " << getMemDelta()
       << ", " << getMemOffsetReg();
    return;
  case KindMemoryRegImm:
    OS << "Memory: " << getMemBase()
       << ", " << getMemDelta()
       << ", " << getMemOffsetImm();
    return;
  }
  llvm_unreachable("Unrecognised operand kind");
}

void ColossusAsmParser::emitInstructionBundle(MCStreamer &Out) {
  assert(InstructionBundle.getOpcode() == TargetOpcode::BUNDLE &&
         "Invalid instruction bundle");

  Out.emitInstruction(InstructionBundle, STI);

  // As EmitInstruction does not recursively checks for Inst Operands
  // We need to iterate through each instruction of the bundle and
  // pass it to the MCStreamer::EmitInstruction so that used expressions
  // Will be processed (See T1517 for more info).
  for (unsigned i = InstructionBundle.getNumOperands(); i--;) {
    assert(InstructionBundle.getOperand(i).isInst() &&
      "Expect operand of a bundle to be an MCInst");
    Out.MCStreamer::emitInstruction(*InstructionBundle.getOperand(i).getInst(),
                                    STI);
  }

  InstructionBundle.clear();
}

// Some Colossus instructions accept operand suffixes. For example, `$m0++`.
// Check all of the parsed assembly operands to ensure they're correct. Report
// a warning/error if missing or incorrect.
bool ColossusAsmParser::ValidateOperands(OperandVector &Operands,
                                         MCInst &Inst) {
  for (auto &ParsedOperand : Operands) {
    ColossusOperand &Op = static_cast<ColossusOperand &>(*ParsedOperand.get());

    if (Op.isReg()) {
      ColossusMCInstrInfo::OperandModifier HasPostInc = Op.getOperandModifier();
      ColossusMCInstrInfo::OperandModifier NeedsPostInc =
          ColossusMCInstrInfo::getOperandModifier(MII, Inst,
                                                  Op.getMCOperandNum());

      if (NeedsPostInc != HasPostInc) {
        if (HasPostInc == ColossusMCInstrInfo::OperandNoPostInc) {
          Parser.printError(Op.getStartLoc(), "missing operand post-inc suffix");
        } else {
          Parser.printError(Op.getStartLoc(), "invalid operand post-inc suffix");
        }
      }
    }
  }

  return false;
}

// Return true if both operands are the same register, or one is a subset of
// the other.
static bool OperandsClash(const MCRegisterInfo *MCRI, const MCOperand &Op1,
                          const MCOperand &Op2) {
  if (!Op1.isReg() || !Op2.isReg()) {
    return false;
  }
  auto Reg1 = Op1.getReg();
  auto Reg2 = Op2.getReg();

  // Clash if identical, or one is a sub-register of the other.
  if (Reg1 == Reg2 || MCRI->isSubRegister(Reg1, Reg2) ||
      MCRI->isSubRegister(Reg2, Reg1)) {
    return true;
  }

  return false;
}

// Ensure instruction bundles are valid:
// - The bundle must contain MAX_NUM_INSTRUCTIONS_IN_BUNDLE.
// - The first instruction in the bundle must be a MAIN instruction.
// - The second instruction in the bundle must be an AUX instruction.
// - The two instructions cannot write to the same destination register.
bool ColossusAsmParser::ValidateBundle(SMLoc L) {
  if (!InBundle) {
    return Parser.printError(L, "end of instruction bundle without start");
  }

  unsigned NumOperands = InstructionBundle.getNumOperands();
  if (NumOperands == 0) {
    return Parser.printError(L, "empty instruction bundle");
  }
  if (NumOperands != MAX_NUM_INSTRUCTIONS_IN_BUNDLE) {
    return Parser.printError(L, "too few instructions in bundle");
  }

  SmallVector<std::string, 2> Warnings;

  bool InvalidBundle = false;
  const auto &Insn0 = *InstructionBundle.getOperand(0).getInst();
  const auto &Insn1 = *InstructionBundle.getOperand(1).getInst();

  if (ColossusMCInstrInfo::getLane(MII, Insn0) != 0 ||
      ColossusMCInstrInfo::getLane(MII, Insn1) != 1) {
    InvalidBundle = true;
    Warnings.push_back("invalid instruction in bundle");
  }

  if (!ColossusMCInstrInfo::canCoIssue(MII, Insn0) ||
      !ColossusMCInstrInfo::canCoIssue(MII, Insn1)) {
    InvalidBundle = true;
    Warnings.push_back("instruction within bundle cannot be dual issued");
  }

  // Check that both instructions within the bundle do not write to the same
  // register.
  unsigned Insn0NumOps = MII.get(Insn0.getOpcode()).getNumDefs();
  unsigned Insn1NumOps = MII.get(Insn1.getOpcode()).getNumDefs();

  for (unsigned Insn0Op = 0; Insn0Op < Insn0NumOps; Insn0Op++) {
    auto &Insn0OutOp = Insn0.getOperand(Insn0Op);

    for (unsigned Insn1Op = 0; Insn1Op < Insn1NumOps; Insn1Op++) {
      auto &Insn1OutOp = Insn1.getOperand(Insn1Op);
      if (OperandsClash(getContext().getRegisterInfo(),
                        Insn0OutOp, Insn1OutOp)) {
        InvalidBundle = true;
        Warnings.push_back("bundle instructions cannot write to the same "
                           "operand");
      }
    }
  }

  // Output any warnings / errors.
  SMLoc Loc = Insn0.getLoc();
  for (auto &WarningMsg : Warnings) {
    if (AllowInvalidBundles)
      Warning(Loc, WarningMsg);
    else
      Parser.printError(Loc, WarningMsg);
  }

  return AllowInvalidBundles ? false : InvalidBundle;
}

void ColossusAsmParser::SwapBundleInstructionsIfRequired () {
  if (   !AllowOptimzations
      || InstructionBundle.getNumOperands() != MAX_NUM_INSTRUCTIONS_IN_BUNDLE)
    return;

  const auto &Insn0 = *InstructionBundle.getOperand(0).getInst();
  const auto &Insn1 = *InstructionBundle.getOperand(1).getInst();


    if ( ColossusMCInstrInfo::getLane(MII, Insn0) == 1
      && ColossusMCInstrInfo::getLane(MII, Insn1) == 0) {
    MCOperand aux = InstructionBundle.getOperand(0);
    InstructionBundle.getOperand(0) = InstructionBundle.getOperand(1);
    InstructionBundle.getOperand(1) = aux;
  }
}

bool ColossusAsmParser::EmitInstruction(MCInst &Inst, MCStreamer &Out,
                                        SMLoc &IDLoc) {
  if (InBundle) {
    if (InstructionBundle.getNumOperands() < MAX_NUM_INSTRUCTIONS_IN_BUNDLE) {
      MCInst *Instruction = new (getContext()) MCInst(Inst);
      ColossusMCInstrInfo::SetCoIssue(*Instruction, true);
      // Copy the instruction, and add it as an operand to our bundle.
      InstructionBundle.addOperand(MCOperand::createInst(Instruction));

    } else {
      return Error(IDLoc, "too many instructions in bundle");
    }
  } else {
    Out.emitInstruction(Inst, STI);
  }
  return false;
}

bool ColossusAsmParser::
MatchAndEmitInstruction(SMLoc IDLoc, unsigned &Opcode,
                        OperandVector &Operands,
                        MCStreamer &Out,
                        uint64_t &ErrorInfo,
                        bool MatchingInlineAsm) {
  MCInst Inst;
  unsigned MatchResult;
  FeatureBitset MissingFeatures;
  MatchResult = MatchInstructionImpl(Operands, Inst, ErrorInfo, MissingFeatures,
                                     MatchingInlineAsm);
  if (!AllowInvalidOperands && MatchResult == Match_InvalidOperand &&
      Operands.size() == 3) {
    StringRef Instr = ((ColossusOperand *)(&*Operands[0]))->getToken();
    ColossusOperand *ImmOp = (ColossusOperand *)(&*Operands[2]);
    if (Instr.equals("call") && ImmOp->isImmzi<20>()) {
      ImmOp->setAllowInvalid();
      MatchResult = MatchInstructionImpl(Operands, Inst, ErrorInfo,
                                         MissingFeatures, MatchingInlineAsm);
    }
  }
  if (AllowInvalidExecutionMode && MatchResult == Match_MissingFeature) {
    switchMode();
    MatchResult = MatchInstructionImpl(Operands, Inst, ErrorInfo, MissingFeatures,
                                       MatchingInlineAsm);
    switchMode();
  }

  switch (MatchResult) {
  default: break;
  case Match_Success:
  {
    auto Expanded = ExpandMacroInstruction(Inst, IDLoc, Out);
    if (Expanded.hasValue()) {
      return Expanded.getValue();
    }

    Inst.setLoc(IDLoc);

    if (ValidateOperands(Operands, Inst)) {
      return true;
    }

    return EmitInstruction(Inst, Out, IDLoc);
  }
  case Match_MissingFeature: {
    // Special case the error message for the very common case where only
    // a single subtarget feature is missing
    SmallString<126> Msg;
    raw_svector_ostream OS(Msg);
    OS << "instruction requires:";
    for (unsigned i = 0, e = MissingFeatures.size(); i != e; ++i) {
      if (MissingFeatures[i])
        OS << ' ' << getSubtargetFeatureName(i);
    }
    return Error(IDLoc, Msg);
  }

  case Match_InvalidOperand: {
    SMLoc ErrorLoc = IDLoc;
    if (ErrorInfo != ~0ULL) {
      if (ErrorInfo >= Operands.size())
        return Error(IDLoc, "too few operands for instruction");

      ErrorLoc = ((ColossusOperand &)*Operands[ErrorInfo]).getStartLoc();
      if (ErrorLoc == SMLoc())
        ErrorLoc = IDLoc;
    }
    return Error(ErrorLoc, "invalid operand for instruction");
  }

  case Match_MnemonicFail:
    return Error(IDLoc, "invalid instruction");
  }

  llvm_unreachable("Unexpected match type");
}

void ColossusAsmParser::onStatementPrefix(AsmToken Token) {
  bool HandledTok = false;

  if (Token.is(AsmToken::LCurly)) {
    HandledTok = true;

    if (InBundle){
      Parser.printError(Token.getLoc(), "start of instruction bundle without end");
    }

    InBundle = true;
    InstructionBundle.clear();

  } else if (Token.is(AsmToken::RCurly)) {
    HandledTok = true;
    SwapBundleInstructionsIfRequired();
    if (ValidateBundle(Token.getLoc())) {
      InstructionBundle.clear();
    } else {
      emitInstructionBundle(getStreamer());
    }

    InBundle = false;
  }

  if (HandledTok) {
    Parser.Lex();

    if (InBundle && Parser.getTok().is(AsmToken::RCurly)) {
      Parser.Lex();
      Parser.printError(Token.getLoc(), "empty instruction bundle");
      InBundle = false;
    }
  }
}

  bool ColossusAsmParser::isSupervisor() {
    return getSTI().getFeatureBits()[Colossus::ModeSupervisor];
  }

  void ColossusAsmParser::switchMode() {
    MCSubtargetInfo &STI = copySTI();
    auto FB = ComputeAvailableFeatures(STI.ToggleFeature(Colossus::ModeSupervisor));
    setAvailableFeatures(FB);
  }

ColossusAsmParser::~ColossusAsmParser() {
  if (InBundle)
    Parser.printError(getLoc(), "instruction bundle without end");
}

// Force static initialization.
extern "C" LLVM_EXTERNAL_VISIBILITY void LLVMInitializeColossusAsmParser() {
  RegisterMCAsmParser<ColossusAsmParser> X(getTheColossusTarget());
}
