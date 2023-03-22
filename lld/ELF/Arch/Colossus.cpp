//===- Colossus.cpp --------------------------- The LLVM Linker -----------===//
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

#include "Config.h"
#include "InputFiles.h"
#include "Symbols.h"
#include "Target.h"
#include "lld/Common/ErrorHandler.h"
#include "lld/Common/TargetOptionsCommandFlags.h"
#include "llvm/BinaryFormat/ColossusRelocs.h"
#include "llvm/Support/Endian.h"
#include <ipu_arch_info/ipuArchInfo.h>

using namespace llvm;
using namespace llvm::object;
using namespace llvm::support::endian;
using namespace llvm::ELF;
using namespace lld;
using namespace lld::elf;

namespace {
class Colossus final : public TargetInfo {
  const IPUArchInfo &IAI;

  // Simple wrapper to avoid calling getCPUStr() twice.
  static std::string getCPU() {
    std::string CPU = getCPUStr();
    return CPU.empty() ? "ipu1" : CPU;
  }

public:
  Colossus();
  void relocate(uint8_t *Loc, const Relocation &Rel,
                uint64_t Val) const override;
  uint32_t calcEFlags() const override;
  RelExpr getRelExpr(RelType Type, const Symbol &S,
                     const uint8_t *Loc) const override;
};
} // namespace

Colossus::Colossus() : IAI(ipuArchInfoByName(getCPU())) {
  defaultImageBase = IAI.TMEM_REGION0_BASE_ADDR;
  defaultMaxPageSize = 4;
}

uint32_t Colossus::calcEFlags() const {
  // If there are only binary input files (from -b binary), use a
  // value of 0 for the ELF header flags.
  if (ctx->objectFiles.empty())
    return 0;

  uint32_t target = cast<ObjFile<ELF32LE>>(ctx->objectFiles.front())
                        ->getObj()
                        .getHeader()
                        .e_flags &
                    EF_GRAPHCORE_ARCH;

  for (InputFile *f : ctx->objectFiles) {
    assert(config->ekind == ELF32LEKind);
    uint32_t eflags = cast<ObjFile<ELF32LE>>(f)->getObj().getHeader().e_flags &
                      EF_GRAPHCORE_ARCH;
    if (eflags && target && eflags != target) {
      warn(toString(f) +
           "Cannot link object files compiled for different IPU arch" +
           toString(ctx->objectFiles.front()));
    }
  }
  return target;
}

RelExpr Colossus::getRelExpr(RelType Type, const Symbol &S,
                             const uint8_t *Loc) const {
  return R_ABS;
}

void Colossus::relocate(uint8_t *Loc, const Relocation &Rel,
                        uint64_t Val) const {

  const auto elfCheckAlignment = [](uint8_t *Loc, uint64_t V, int N,
                                    const Relocation &Rel) {
    checkAlignment(Loc, V, N, Rel);
    return true;
  };
  const auto elfCheckUInt = [](uint8_t *Loc, uint64_t V, int N,
                               const Relocation &Rel) {
    checkUInt(Loc, V, N, Rel);
    return true;
  };

  // Since checkAlignment/checkUInt always return true, if resolveRelocation()
  // returns false it must be because it is an unrecognised relocation.
  if (!colossus::resolveRelocation(IAI, Loc, Rel, Val, elfCheckAlignment,
                                   elfCheckUInt)) {
    error(getErrorLocation(Loc) + "unrecognized reloc " + Twine(Rel.type));
  }
}

TargetInfo *elf::getColossusTargetInfo() {
  static Colossus Target;
  return &Target;
}
