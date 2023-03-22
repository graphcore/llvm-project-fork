//===-- ColossusMCObjectWriter.cpp - Colossus ELF writer ------------------===//
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
#include "MCTargetDesc/ColossusMCTargetDesc.h"
#include "MCTargetDesc/ColossusMCFixups.h"
#include "llvm/MC/MCAssembler.h"
#include "llvm/MC/MCELFObjectWriter.h"
#include "llvm/MC/MCObjectWriter.h"
#include "llvm/MC/MCValue.h"
#include "llvm/Support/Debug.h"

using namespace llvm;
using namespace Colossus;

namespace {
class ColossusMCObjectWriter : public MCELFObjectTargetWriter {
public:
  ColossusMCObjectWriter();

  virtual ~ColossusMCObjectWriter();

protected:
  // Override MCELFObjectTargetWriter.
  unsigned getRelocType(MCContext &Ctx, const MCValue &Target,
                        const MCFixup &Fixup, bool IsPCRel) const override;
};
} // end anonymous namespace

ColossusMCObjectWriter::ColossusMCObjectWriter()
  : MCELFObjectTargetWriter(/*Is64Bit=*/false, ELF::ELFOSABI_STANDALONE,
                            ELF::EM_GRAPHCORE_IPU,
                            /*HasRelocationAddend=*/ true) {}

ColossusMCObjectWriter::~ColossusMCObjectWriter() {
}

unsigned ColossusMCObjectWriter::getRelocType(MCContext &Ctx,
                                              const MCValue &Target,
                                              const MCFixup &Fixup,
                                              bool IsPCRel) const {
  assert(!IsPCRel && "Unimplemented fixup -> relocation");

  MCSymbolRefExpr::VariantKind Variant = Target.getAccessVariant();
  switch (Variant) {
  case MCSymbolRefExpr::VariantKind::VK_None:
    break;
  case MCSymbolRefExpr::VariantKind::VK_COLOSSUS_RELATIVE_16_S2:
    if ((unsigned)Fixup.getKind() == FK_Data_1)
      report_fatal_error("Invalid fixup kind for @relative@16@s2 variant");
    return ELF::R_COLOSSUS_RELATIVE_16_S2;
  case MCSymbolRefExpr::VariantKind::VK_COLOSSUS_18_S2:
  {
    auto kind = (unsigned)Fixup.getKind();
    if (kind == FK_Data_1 || kind == FK_Data_2) {
      report_fatal_error("Invalid fixup kind for @18@s2 variant");
    }
    return ELF::R_COLOSSUS_18_S2;
  }
  break;
  case MCSymbolRefExpr::VariantKind::VK_COLOSSUS_19_S2:
  {
    auto kind = (unsigned)Fixup.getKind();
    if (kind == FK_Data_1 || kind == FK_Data_2) {
      report_fatal_error("Invalid fixup kind for @19@s2 variant");
    }
    return ELF::R_COLOSSUS_19_S2;
  }
  break;
  case MCSymbolRefExpr::VariantKind::VK_COLOSSUS_21:
  {
    auto kind = (unsigned)Fixup.getKind();
    if (kind == FK_Data_1 || kind == FK_Data_2) {
      report_fatal_error("Invalid fixup kind for @21 variant");
    }
    return ELF::R_COLOSSUS_21;
  }
  break;
  default:
    report_fatal_error("Unrecognized variant type");
  }

  switch((unsigned)Fixup.getKind()) {
  default:
    llvm_unreachable("Unimplemented fixup -> relocation");
  case FK_Data_1:
  case Colossus::fixup_colossus_8:      return ELF::R_COLOSSUS_8;
  case FK_Data_2:
  case Colossus::fixup_colossus_16:     return ELF::R_COLOSSUS_16;
  case FK_Data_4:                       return ELF::R_COLOSSUS_32;
  case FK_Data_8:                       return ELF::R_COLOSSUS_64;
  case Colossus::fixup_colossus_20:     return ELF::R_COLOSSUS_20;
  case Colossus::fixup_colossus_21:     return ELF::R_COLOSSUS_21;
  case Colossus::fixup_colossus_18_s2:  return ELF::R_COLOSSUS_18_S2;
  case Colossus::fixup_colossus_19_s2:  return ELF::R_COLOSSUS_19_S2;
  case Colossus::fixup_colossus_run:    return ELF::R_COLOSSUS_RUN;
  }

  return ELF::R_COLOSSUS_NONE;
}

std::unique_ptr <MCObjectTargetWriter> llvm::createColossusMCObjectWriter() {
  return std::make_unique<ColossusMCObjectWriter>();
}
