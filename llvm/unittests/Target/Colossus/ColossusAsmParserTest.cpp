#include "ColossusAsmParser.h"
#include "llvm/MC/MCAsmInfo.h"
#include "llvm/MC/MCObjectFileInfo.h"
#include "llvm/MC/MCStreamer.h"
#include "llvm/MC/TargetRegistry.h"
#include "llvm/Support/SourceMgr.h"
#include "gtest/gtest.h"

using namespace llvm;

extern "C" {

void LLVMInitializeColossusTargetInfo();
void LLVMInitializeColossusAsmParser();
void LLVMInitializeColossusTarget();
void LLVMInitializeColossusAsmPrinter();
void LLVMInitializeColossusTargetMC();
void LLVMInitializeColossusDisassembler();

} // extern "C"

namespace {
class ColossusAsmParserTest : public ::testing::Test {
protected:
  ColossusAsmParserTest() {
    std::string error;

    LLVMInitializeColossusTarget();
    LLVMInitializeColossusAsmParser();
    LLVMInitializeColossusAsmPrinter();
    LLVMInitializeColossusTargetInfo();
    LLVMInitializeColossusTargetMC();
    target = TargetRegistry::lookupTarget(triple, error);

    mri.reset(target->createMCRegInfo(triple));
    mai.reset(target->createMCAsmInfo(*mri, triple, mopt));
    sti.reset(target->createMCSubtargetInfo(triple, "", ""));
    mcii.reset(target->createMCInstrInfo());
  }

  void setupAssembler(std::string registers_to_parse) {
    register_names = registers_to_parse;
    srcMgr.AddNewSourceBuffer(MemoryBuffer::getMemBuffer(register_names),
                              SMLoc());

    ctx.reset(new MCContext(Triple("colossus-graphcore-unknown-elf"), mai.get(),
                            mri.get(), sti.get(), &srcMgr));
    mofi.initMCObjectFileInfo(*ctx, false);
    ctx->setObjectFileInfo(&mofi);
    ms.reset(createNullStreamer(*ctx));
    parser.reset(createMCAsmParser(srcMgr, *ctx, *ms, *mai));

    tap.reset(target->createMCAsmParser(*sti, *parser, *mcii, mopt));
    parser->setTargetParser(*tap);
  }

  Target const *target;
  std::string register_names;
  std::string const triple = "colossus-graphcore-unknown-elf";
  std::unique_ptr<MCInstrInfo> mcii;
  std::unique_ptr<MCSubtargetInfo> sti;
  std::unique_ptr<MCRegisterInfo> mri;
  std::unique_ptr<MCAsmInfo> mai;
  std::unique_ptr<MCStreamer> ms;
  std::unique_ptr<MCAsmParser> parser;
  std::unique_ptr<MCTargetAsmParser> tap;
  std::unique_ptr<MCContext> ctx;
  MCObjectFileInfo mofi;
  SourceMgr srcMgr;

public:
  llvm::MCTargetOptions mopt;
};

TEST_F(ColossusAsmParserTest, ParseMRFRegisters) {

  setupAssembler("$m0\n$m1\n$m2\n$m3\n$m4\n$m5\n$m6\n$m7\n$m8\n$m9\n"
                 "$m10\n$m11\n$m12\n$m13\n$m14\n$m15");

  for (auto expected_reg :
       {Colossus::M0, Colossus::M1, Colossus::M2, Colossus::M3, Colossus::M4,
        Colossus::M5, Colossus::M6, Colossus::M7, Colossus::BP, Colossus::FP,
        Colossus::LR, Colossus::SP, Colossus::MWORKER_BASE,
        Colossus::MVERTEX_BASE, Colossus::M14, Colossus::MZERO}) {
    parser->Lex();
    SMLoc S, E;
    unsigned reg;
    OperandMatchResultTy res;
    res = tap->tryParseRegister(reg, S, E);
    ASSERT_EQ(res, MatchOperand_Success);
    ASSERT_EQ(reg, expected_reg);
  }
}

TEST_F(ColossusAsmParserTest, ParseMRpairs) {
  setupAssembler(
      "$m0:1\n$m2:3\n$m4:5\n$m6:7\n$m8:9\n$m10:11\n$m12:13\n$m14:15");

  for (auto expected_reg :
       {Colossus::MD0, Colossus::MD1, Colossus::MD2, Colossus::MD3,
        Colossus::MD4, Colossus::MD5, Colossus::MD6, Colossus::MD7}) {
    parser->Lex();
    SMLoc S, E;
    unsigned reg;
    OperandMatchResultTy res;
    res = tap->tryParseRegister(reg, S, E);
    ASSERT_EQ(res, MatchOperand_Success);
    ASSERT_EQ(reg, expected_reg);
  }
}

TEST_F(ColossusAsmParserTest, ParseARFRegisters) {
  setupAssembler("$a0\n$a1\n$a2\n$a3\n$a4\n$a5\n$a6\n$a7\n$a8\n$a9\n$a10\n$"
                 "a11\n$a12\n$a13\n$a14\n$a15");

  for (auto expected_reg :
       {Colossus::A0, Colossus::A1, Colossus::A2, Colossus::A3, Colossus::A4,
        Colossus::A5, Colossus::A6, Colossus::A7, Colossus::A8, Colossus::A9,
        Colossus::A10, Colossus::A11, Colossus::A12, Colossus::A13,
        Colossus::A14, Colossus::AZERO}) {
    parser->Lex();
    SMLoc S, E;
    unsigned reg;
    OperandMatchResultTy res;
    res = tap->tryParseRegister(reg, S, E);
    ASSERT_EQ(res, MatchOperand_Success);
    ASSERT_EQ(reg, expected_reg);
  }
}

TEST_F(ColossusAsmParserTest, ParseARpairs) {
  setupAssembler(
      "$a0:1\n$a2:3\n$a4:5\n$a6:7\n$a8:9\n$a10:11\n$a12:13\n$a14:15");

  for (auto expected_reg :
       {Colossus::AD0, Colossus::AD1, Colossus::AD2, Colossus::AD3,
        Colossus::AD4, Colossus::AD5, Colossus::AD6, Colossus::AZEROS}) {
    parser->Lex();
    SMLoc S, E;
    unsigned reg;
    OperandMatchResultTy res;
    res = tap->tryParseRegister(reg, S, E);
    ASSERT_EQ(res, MatchOperand_Success);
    ASSERT_EQ(reg, expected_reg);
  }
}

TEST_F(ColossusAsmParserTest, ParseARquads) {
  setupAssembler("$a0:3\n$a4:7\n$a8:11\n$a12:15");

  for (auto expected_reg :
       {Colossus::AQ0, Colossus::AQ1, Colossus::AQ2, Colossus::AQZERO}) {
    parser->Lex();
    SMLoc S, E;
    unsigned reg;
    OperandMatchResultTy res;
    res = tap->tryParseRegister(reg, S, E);
    ASSERT_EQ(res, MatchOperand_Success);
    ASSERT_EQ(reg, expected_reg);
  }
}

TEST_F(ColossusAsmParserTest, ParseARoctads) {
  setupAssembler("$a0:7\n$a8:15");

  for (auto expected_reg : {Colossus::AO0, Colossus::AOZERO}) {
    parser->Lex();
    SMLoc S, E;
    unsigned reg;
    OperandMatchResultTy res;
    res = tap->tryParseRegister(reg, S, E);
    ASSERT_EQ(res, MatchOperand_Success);
    ASSERT_EQ(reg, expected_reg);
  }
}
} // namespace
