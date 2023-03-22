//===-- ColossusMCAsmBackend.cpp - Colossus Assembler Backend -------------===//
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
#include "ColossusRegisterInfo.h"
#include "MCTargetDesc/ColossusMCFixups.h"
#include "MCTargetDesc/ColossusMCInstrInfo.h"
#include "llvm/ADT/Triple.h"
#include "llvm/BinaryFormat/MachO.h"
#include "llvm/MC/MCAsmBackend.h"
#include "llvm/MC/MCAsmLayout.h"
#include "llvm/MC/MCAssembler.h"
#include "llvm/MC/MCContext.h"
#include "llvm/MC/MCDirectives.h"
#include "llvm/MC/MCELFObjectWriter.h"
#include "llvm/MC/MCFixupKindInfo.h"
#include "llvm/MC/MCInstrInfo.h"
#include "llvm/MC/MCObjectWriter.h"
#include "llvm/MC/MCSectionELF.h"
#include "llvm/MC/MCSectionMachO.h"
#include "llvm/MC/MCValue.h"
#include "llvm/MC/TargetRegistry.h"
#include "llvm/Support/EndianStream.h"
#include "llvm/Support/ErrorHandling.h"

using namespace llvm;

namespace {
unsigned adjustFixupValue(unsigned Kind, uint64_t Value,
                                 bool IsResolved) {
  switch (Kind) {
  default:
    llvm_unreachable("Unknown fixup kind!");
  case FK_Data_1:
  case FK_Data_2:
  case FK_Data_4:
  case FK_Data_8:
    {
      return Value;
    }
  case Colossus::fixup_colossus_8:
    {
      return Value & 0xff;
    }
  case Colossus::fixup_colossus_16:
    {
      return Value & 0xffff;
    }
  case Colossus::fixup_colossus_20:
    {
      return Value & 0xfffff;
    }
  case Colossus::fixup_colossus_19_s2:
    {
      return (Value >> 2) & 0x7ffff;
    }
  case Colossus::fixup_colossus_run:
    {
      assert(!IsResolved && "run fixup has been resolved");
      return 0;
    }
  case Colossus::fixup_colossus_18_s2:
    {
      return (Value >> 2) & 0x3ffff;
    }
  }
}

void validateRptBody(unsigned rptBodySize, SmallVectorImpl<MCFixup> &Fixups,
                     MCContext &Context) {
  for (const MCFixup &Fixup : Fixups) {
    unsigned Offset = Fixup.getOffset();
    if (Offset >= rptBodySize) {
      break;
    }

    auto kind = Fixup.getKind();

    if (kind == (unsigned)Colossus::fixup_colossus_single) {
      Context.reportError(Fixup.getLoc(), "repeat blocks must "
                                          "only contain instruction bundles");
    } else if (kind == (unsigned)Colossus::fixup_colossus_control) {
      Context.reportError(Fixup.getLoc(), "repeat blocks cannot "
                                          "contain control instructions");
    } else if (kind == (unsigned)Colossus::fixup_colossus_system) {
      Context.reportError(Fixup.getLoc(), "repeat blocks cannot "
                                          "contain system instructions");
    }
  }
}

class ColossusMCAsmBackend : public MCAsmBackend {

public:
  ColossusMCAsmBackend(const Target &T)
      : MCAsmBackend(support::endianness::little)
      , MII(T.createMCInstrInfo())
      , AllowInvalidRepeat(false)
      , AllowOptimizations(false) {
  }

   std::unique_ptr<MCObjectTargetWriter> createObjectTargetWriter() const override {
    return createColossusMCObjectWriter();
  }

  unsigned getNumFixupKinds() const override {
    return Colossus::NumTargetFixupKinds;
  }

  const MCFixupKindInfo &getFixupKindInfo(MCFixupKind Kind) const override {
    const static MCFixupKindInfo Infos[Colossus::NumTargetFixupKinds] = {
      // This table *must* be in the order that the fixup_* kinds are defined in
      // ColossusMCFixups.h.
      //
      // Name                           Offset (bits) Size (bits)     Flags
      { "fixup_colossus_8",             0,             8,             0 },
      { "fixup_colossus_16",            0,            16,             0 },
      { "fixup_colossus_20",            0,            20,             0 },
      { "fixup_colossus_21",            0,            21,             0 },
      { "fixup_colossus_18_s2",         0,            18,             0 },
      { "fixup_colossus_19_s2",         0,            19,             0 },
      // run: 16-bits split into 2 chunks, bits 0-11, then 16-19
      { "fixup_colossus_run",           0,            16,             0 },
      { "fixup_colossus_rpt",           0,             0,             0 },
      { "fixup_colossus_control",       0,             0,             0 },
      { "fixup_colossus_system",        0,             0,             0 },
      { "fixup_colossus_single",        0,             0,             0 }
    };

    if (Kind < FirstTargetFixupKind)
      return MCAsmBackend::getFixupKindInfo(Kind);

    assert(unsigned(Kind - FirstTargetFixupKind) < getNumFixupKinds() &&
           "Invalid kind!");
    return Infos[Kind - FirstTargetFixupKind];
  }

  bool shouldForceRelocation(const MCAssembler &,
                             const MCFixup &Fixup,
                             const MCValue &) override {
    unsigned Kind = Fixup.getKind();
    switch (Kind) {
    default: return false;
    // Fixup is relative to the base of memory - leave it for the linker to
    // resolve since the linker knows the memory layout.
    case Colossus::fixup_colossus_run: return true;
    }
  }

  void applyFixup(const MCAssembler &Asm, const MCFixup &Fixup,
                  const MCValue &Target, MutableArrayRef<char> Data,
                  uint64_t Value, bool IsResolved,
                  const MCSubtargetInfo *STI) const override;

  bool mayNeedRelaxation(const MCInst &Inst,
                         const MCSubtargetInfo &STI) const override;

  bool needsRelaxableFragment(const MCInst &Inst) override;

  bool fixupNeedsRelaxation(const MCFixup &Fixup, uint64_t Value,
                            const MCRelaxableFragment *DF,
                            const MCAsmLayout &Layout) const override;
  void relaxInstruction(MCInst &Inst,
                        const MCSubtargetInfo &STI) const override;
  void finishLayout(MCAssembler const &Asm, MCAsmLayout &Layout) const override;
  bool writeNopData(raw_ostream &OS, uint64_t Count,
                    const MCSubtargetInfo *STI) const override;
  void handleAssemblerFlag(MCAssemblerFlag Flag) override;

private:
  std::unique_ptr<const MCInstrInfo> MII;
  bool AllowInvalidRepeat; // Allows unaligned RPT instructions to be emittet
                           // without the assembler emitting an error.
  bool AllowOptimizations; // Allows the assembler to perform optimizations
                           // on written assembly.

  static unsigned getRepeatBodyLength(const MCInst &Inst, MCAsmLayout &Layout);
};
} // end anonymous namespace

void ColossusMCAsmBackend::handleAssemblerFlag(MCAssemblerFlag Flag) {
  switch (Flag) {
  default:
    break;
  case MCAF_AllowInvalidRepeat:
    AllowInvalidRepeat = true;
    break;
  case MCAF_AllowOptimizations:
    AllowOptimizations = true;
    break;
  }
}

void ColossusMCAsmBackend::applyFixup(const MCAssembler &Asm,
                                      const MCFixup &Fixup,
                                      const MCValue &,
                                      MutableArrayRef<char> Data,
                                      uint64_t Value,
                                      bool IsResolved,
                                      const MCSubtargetInfo */*STI*/) const {
  MCFixupKind Kind = Fixup.getKind();
  const MCFixupKindInfo &Info = getFixupKindInfo(Kind);

  if (Kind == (unsigned)Colossus::fixup_colossus_rpt
    || Kind == (unsigned)Colossus::fixup_colossus_control
    || Kind == (unsigned)Colossus::fixup_colossus_system
    || Kind == (unsigned)Colossus::fixup_colossus_single) {
    return;
  }

  unsigned Offset = Fixup.getOffset();
  unsigned Size = (Info.TargetSize + Info.TargetOffset + 7) / 8;

  assert(Offset + Size <= Data.size() && "Invalid fixup offset!");

  // Apply any target-specific value adjustments.
  Value = adjustFixupValue(Fixup.getKind(), Value, IsResolved);
  // Shift the value into position.
  Value <<= Info.TargetOffset;

  // Little-endian insertion of Size bytes.
  for (unsigned I = 0; I != Size; ++I) {
    Data[Offset + I] |= uint8_t(Value >> (I * 8));
  }
}

bool ColossusMCAsmBackend::mayNeedRelaxation(const MCInst &Inst,
    const MCSubtargetInfo &STI) const {
  auto Opcode = Inst.getOpcode();
  if (Opcode != TargetOpcode::BUNDLE) {
    return false;
  }

  auto SecondInst = Inst.getOperand(1).getInst();

  return AllowOptimizations
      && ColossusMCInstrInfo::isRepeat(Inst)
      && ColossusMCInstrInfo::isFnop(STI, *SecondInst);
}

// mayNeedRelaxation already called see MCAssembler::fragmentNeedsRelaxation
// in MCAssembler.cpp
bool ColossusMCAsmBackend::fixupNeedsRelaxation(
    const MCFixup &Fixup, uint64_t Value, const MCRelaxableFragment *DF,
    const MCAsmLayout &Layout) const {
  assert(DF && "unexepected nullptr DF");
  // Section will be promoted to at least 8 byte aligned, so we can check if
  // the offset of the next instruction is 8 byte aligned, or if we need to
  // change the rpt instruction to a bundle to align the rpt body.

  const MCInst *Inst = &DF->getInst();
  auto Opcode = Inst->getOpcode();

  if (Opcode != TargetOpcode::BUNDLE) {
    return false;
  }

  auto nextOffset = Layout.getFragmentOffset(DF) + 8;
  return (nextOffset & 7) != 0;
}

void ColossusMCAsmBackend::relaxInstruction(MCInst &Inst,
                                            const MCSubtargetInfo &STI) const {
  if (!mayNeedRelaxation(Inst, STI))
    return;

  MCInst Res = *Inst.getOperand(0).getInst();
  ColossusMCInstrInfo::SetCoIssue(Res, false);
  Inst = std::move(Res);
}

bool ColossusMCAsmBackend::needsRelaxableFragment(const MCInst &Inst) {

  return ColossusMCInstrInfo::isRepeat(Inst);
}

unsigned ColossusMCAsmBackend::getRepeatBodyLength(const MCInst &Inst,
                                                   MCAsmLayout &Layout) {
  auto &Operand = Inst.getOperand(1);

  // If it's an expression.
  if (Operand.isExpr()) {
    auto RptBodySize = Inst.getOperand(1).getExpr();
    MCValue Res;
    if (RptBodySize->evaluateAsValue(Res, Layout)) {
      return (Res.getConstant() + 1) * 2;
    }
  }

  // If it's an immediate.
  if (Operand.isImm()) {
    return (Operand.getImm() + 1) * 2;
  }

  // If we can't decode it, return zero. For the repeat validity checks this
  // will result in them being disabled for the body of this repeat.
  return 0;
}

void ColossusMCAsmBackend::finishLayout(MCAssembler const &Asm,
                                        MCAsmLayout &Layout) const {
  if (AllowInvalidRepeat) {
    return;
  }

  MCContext &Context = Layout.getAssembler().getContext();
  unsigned RptBodySize = 0;

  // Iterate over all fragments looking for `rpt` instructions.
  // When we find one, check it meets all of the restrictions and warn if not.
  for (const auto Section : Layout.getSectionOrder()) {
    for (auto &Fragment : Section->getFragmentList()) {
      switch (Fragment.getKind()) {
      default:
        RptBodySize = 0;
        break;

      case MCFragment::FT_Data: {
        // Following contents is in a rpt body
        if (RptBodySize) {
          auto &DF = cast<MCDataFragment>(Fragment);
          validateRptBody(RptBodySize,
                          DF.getFixups(), Context);
          auto Size = DF.getContents().size();
          Size > RptBodySize ? RptBodySize = 0 : RptBodySize -= Size;
        }
      }
      break;
      // rpt instruction
      case MCFragment::FT_Relaxable: {
        if (AllowOptimizations) {
             Section->setAlignment(Align(8));
        }

        auto &RF = cast<MCRelaxableFragment>(Fragment);
        const MCInst *Inst = &RF.getInst();
        auto Opcode = Inst->getOpcode();

        if (ColossusMCInstrInfo::isRepeat(*Inst)) {
          auto nextOffset = Layout.getFragmentOffset(&Fragment) +
                            (Opcode == TargetOpcode::BUNDLE ? 8 : 4);
          if (Section->getAlignment() < 8 || (nextOffset & 7) != 0) {
            char const * message = Opcode == TargetOpcode::BUNDLE ?
                "code following rpt instruction is misaligned. Please add a "
                "nop before the bundled rpt instruction to ensure the rpt "
                "body is 8 byte aligned"
              : "code following rpt instruction is misaligned. Please bundle "
                "the rpt instruction with fnop to ensure the rpt body is 8 "
                "byte aligned";
            Context.reportError(
                RF.getInst().getLoc(),
                message);
          } else {
            if (Opcode == TargetOpcode::BUNDLE) {
              Inst = Inst->getOperand(0).getInst();
            }
            RptBodySize = getRepeatBodyLength(*Inst, Layout) * 4;
          }
        }
      } break;
      }
    }
  }
}

bool ColossusMCAsmBackend::writeNopData(raw_ostream &OS,
                           uint64_t Count, const MCSubtargetInfo *STI) const {
  // If the count is not 4-byte aligned, we must be writing data into the text
  // section (otherwise we have unaligned instructions, and thus have far
  // bigger problems), so just write zeros instead.
  OS.write_zeros(Count % 4);

  // We are properly aligned, so write NOPs as requested.
  Count /= 4;
  for (uint64_t i = 0; i != Count; ++i)
    support::endian::write<uint32_t>(OS, 0x19e00000, Endian);

  return true;
}

MCAsmBackend *llvm::createColossusMCAsmBackend(const Target &T,
                                               const MCSubtargetInfo &STI,
                                               const MCRegisterInfo &MRI,
                                               const MCTargetOptions &Options) {
  return new ColossusMCAsmBackend(T);
}
