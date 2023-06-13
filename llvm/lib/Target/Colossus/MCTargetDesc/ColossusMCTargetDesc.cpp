//===-- ColossusMCTargetDesc.cpp - Colossus Target Descriptions -----------===//
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
// This file provides Colossus specific target descriptions.
//
//===----------------------------------------------------------------------===//

#include "ColossusMCTargetDesc.h"
#include "Colossus.h"
#include "ColossusInstPrinter.h"
#include "ColossusMCAsmInfo.h"
#include "ColossusMCELFStreamer.h"
#include "ColossusSubtarget.h"
#include "ColossusTargetStreamer.h"
#include "TargetInfo/ColossusTargetInfo.h"
#include "llvm/BinaryFormat/ELF.h"
#include "llvm/MC/MCAssembler.h"
#include "llvm/MC/MCInstrAnalysis.h"
#include "llvm/MC/MCInstrInfo.h"
#include "llvm/MC/MCObjectStreamer.h"
#include "llvm/MC/MCObjectWriter.h"
#include "llvm/MC/MCRegisterInfo.h"
#include "llvm/MC/MCSubtargetInfo.h"
#include "llvm/MC/TargetRegistry.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Support/FormattedStream.h"

using namespace llvm;

#define GET_INSTRINFO_MC_DESC
#include "ColossusGenInstrInfo.inc"

#define GET_SUBTARGETINFO_MC_DESC
#include "ColossusGenSubtargetInfo.inc"

#define GET_REGINFO_MC_DESC
#include "ColossusGenRegisterInfo.inc"

static MCInstrInfo *createColossusMCInstrInfo() {
  MCInstrInfo *X = new MCInstrInfo();
  InitColossusMCInstrInfo(X);
  return X;
}

static MCRegisterInfo *createColossusMCRegisterInfo(const Triple &TT) {
  MCRegisterInfo *X = new MCRegisterInfo();
  InitColossusMCRegisterInfo(X, Colossus::LR);
  return X;
}

static MCSubtargetInfo *createColossusMCSubtargetInfo(const Triple &TT,
                                                      StringRef CPU,
                                                      StringRef FS) {
  return createColossusMCSubtargetInfoImpl(TT, CPU, /*TuneCPU=*/CPU, FS);
}

static MCAsmInfo *createColossusMCAsmInfo(const MCRegisterInfo &MRI,
                                          const Triple &TT,
                                          const MCTargetOptions &Options) {
  MCAsmInfo *MAI = new ColossusMCAsmInfo(TT);

  // The initial state of the frame pointer is SP.
  const unsigned DwarfSPReg = MRI.getDwarfRegNum(Colossus::SP, true);
  auto Instr = MCCFIInstruction::cfiDefCfa(nullptr, DwarfSPReg, 0);
  MAI->addInitialFrameState(Instr);

  return MAI;
}

static MCInstPrinter *createColossusMCInstPrinter(const Triple &T,
                                               unsigned SyntaxVariant,
                                               const MCAsmInfo &MAI,
                                               const MCInstrInfo &MII,
                                               const MCRegisterInfo &MRI) {
  return new ColossusInstPrinter(MAI, MII, MRI);
}

ColossusTargetStreamer::ColossusTargetStreamer(MCStreamer &S)
  : MCTargetStreamer(S) {}
ColossusTargetStreamer::~ColossusTargetStreamer() {}

namespace {

class ColossusTargetAsmStreamer : public ColossusTargetStreamer {
  formatted_raw_ostream &OS;
public:
  ColossusTargetAsmStreamer(MCStreamer &S, formatted_raw_ostream &OS);
  void emitRawText(StringRef S) override;
};

ColossusTargetAsmStreamer::ColossusTargetAsmStreamer(MCStreamer &S,
                                               formatted_raw_ostream &OS)
    : ColossusTargetStreamer(S), OS(OS) {}

}

void ColossusTargetAsmStreamer::emitRawText(StringRef S) {
  OS << S;
}

class ColossusTargetELFStreamer : public ColossusTargetStreamer {
  public:
  MCELFStreamer &getStreamer() {
    return static_cast<MCELFStreamer &>(Streamer);
  }
  ColossusTargetELFStreamer(MCStreamer &S, MCSubtargetInfo const &STI)
    : ColossusTargetStreamer(S) {
      MCAssembler &MCA = getStreamer().getAssembler();
      unsigned flags = ELF::EF_GRAPHCORE_ARCH_IPU1;

      if (STI.hasFeature(Colossus::ModeArchIpu2))
        flags = ELF::EF_GRAPHCORE_ARCH_IPU2;
      else if (STI.hasFeature(Colossus::ModeArchIpu21))
        flags = ELF::EF_GRAPHCORE_ARCH_IPU21;

      MCA.setELFHeaderEFlags(flags);
    }

    void emitRawText(StringRef ) override {}
};

static MCTargetStreamer *createColossusMCAsmStreamer(MCStreamer &S,
                                                     formatted_raw_ostream &OS,
                                                     MCInstPrinter *InstPrint,
                                                     bool ShowInst) {
  return new ColossusTargetAsmStreamer(S, OS);
}

static MCTargetStreamer *
createColossusObjectTargetStreamer(MCStreamer &S, const MCSubtargetInfo &STI) {
  return new ColossusTargetELFStreamer(S, STI);
}


class ColossusMCInstrAnalysis : public MCInstrAnalysis {
public:
  ColossusMCInstrAnalysis(const MCInstrInfo *Info) : MCInstrAnalysis(Info) {}

  virtual bool isCall(const MCInst &Inst) const override {
    auto op = Inst.getOpcode();
    if (op == Colossus::CALL)
      return true;
    return MCInstrAnalysis::isCall(Inst);
  }

  virtual bool
  evaluateBranch(const MCInst &Inst, uint64_t Addr, uint64_t Size,
                 uint64_t &Target) const override {
    auto op = Inst.getOpcode();
    if (op == Colossus::CALL ||
        op == Colossus::BRZ ||
        op == Colossus::BRNZ ||
        op == Colossus::BRPOS) {
      int64_t Imm = Inst.getOperand(1).getImm() * 4;
      Target = Imm;
      return true;
    }
    else if (op == Colossus::BR) {
      int64_t Imm = Inst.getOperand(0).getImm() * 4;
      Target = Imm;
      return true;
    }
    else if (op == Colossus::BRNZDEC) {
      int64_t Imm = Inst.getOperand(2).getImm() * 4;
      Target = Imm;
      return true;
    }

    return false;
  }
};

static MCInstrAnalysis *createColossusMCInstrAnalysis(const MCInstrInfo *Info) {
  return new ColossusMCInstrAnalysis(Info);
}

// Force static initialization.
extern "C" LLVM_EXTERNAL_VISIBILITY void LLVMInitializeColossusTargetMC() {
  // Register the MC asm info.
  RegisterMCAsmInfoFn X(getTheColossusTarget(), createColossusMCAsmInfo);

  // Register the MC instruction info.
  TargetRegistry::RegisterMCInstrInfo(getTheColossusTarget(),
                                      createColossusMCInstrInfo);

  // Register the MC register info.
  TargetRegistry::RegisterMCRegInfo(getTheColossusTarget(),
                                    createColossusMCRegisterInfo);

  // Register the MC subtarget info.
  TargetRegistry::RegisterMCSubtargetInfo(getTheColossusTarget(),
                                          createColossusMCSubtargetInfo);

  // Register the MCInstPrinter
  TargetRegistry::RegisterMCInstPrinter(getTheColossusTarget(),
                                        createColossusMCInstPrinter);
  TargetRegistry::RegisterMCInstrAnalysis(getTheColossusTarget(),
                                          createColossusMCInstrAnalysis);

  // Register the MC code emitter
  TargetRegistry::RegisterMCCodeEmitter(getTheColossusTarget(),
                                        createColossusMCCodeEmitter);

  // Register the MC asm backend.
  TargetRegistry::RegisterMCAsmBackend(getTheColossusTarget(),
                                       createColossusMCAsmBackend);

  TargetRegistry::RegisterELFStreamer(getTheColossusTarget(),
                                      createColossusELFStreamer);

  // Register the obj target streamer
  TargetRegistry::RegisterObjectTargetStreamer(
      getTheColossusTarget(), createColossusObjectTargetStreamer);

  TargetRegistry::RegisterAsmTargetStreamer(getTheColossusTarget(),
                                            createColossusMCAsmStreamer);
}
