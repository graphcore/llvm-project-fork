//===-- llvm/BinaryFormat/ColossusRelocs.h - Colossus Relocs ----*- C++ -*-===//
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
/// \file
/// This file contains a function that will resolve Colossus relocations.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_BINARYFORMAT_COLOSSUSRELOCS_H
#define LLVM_BINARYFORMAT_COLOSSUSRELOCS_H

#include "llvm/BinaryFormat/ELF.h"
#include "llvm/Support/Endian.h"
#include <ipu_arch_info/ipuArchInfo.h>
#include <cstdint>

namespace llvm {
namespace colossus {

// Return the number of bytes that are read/written when resolving a relocation.
// Even though some are only 3 bytes, they still read/write 4 for convenience.
inline unsigned relocationSize(unsigned Type) {
  switch (Type) {
  case ELF::R_COLOSSUS_8:
    return 1;
  case ELF::R_COLOSSUS_16:
  case ELF::R_COLOSSUS_RELATIVE_16_S2:
  case ELF::R_COLOSSUS_16_S3:
  case ELF::R_COLOSSUS_16_S4:
  case ELF::R_COLOSSUS_16_S5:
    return 2;
  case ELF::R_COLOSSUS_32:
  case ELF::R_COLOSSUS_19_S2:
  case ELF::R_COLOSSUS_20:
  case ELF::R_COLOSSUS_21:
  case ELF::R_COLOSSUS_18_S2:
  case ELF::R_COLOSSUS_RUN:
    return 4;
  case ELF::R_COLOSSUS_64:
    return 8;
  }
  // Unknown relocation type. Assume it is large.
  return 8;
}

template <typename R, std::enable_if_t<std::is_integral<R>::value, int> = 0>
unsigned getType(R &Rel) {
  return Rel;
}

template <typename R, std::enable_if_t<std::is_class<R>::value, int> = 0>
unsigned getType(R &Rel) {
  return Rel.type;
}

// Write a relocation to the given address. This calls checkAlignment
// and checkUInt to the input value. If they ever return false, this
// returns false. It also returns false for unrecognised relocations.
// Otherwise it returns true. IPU-dependent parameters such as image
// base address are obtained from `IAI`.
//
// Example implementations for check predicates:
//
// auto checkAlignment = [](const std::uint8_t *loc, std::uint64_t v, int n) {
//   return (v & (n-1)) == 0;
// };
// auto checkUInt = [](const std::uint8_t *loc, std::uint64_t v, int n) {
//   return (v >> n) == 0;
// };
template <typename CA, typename CU, typename R>
bool resolveRelocation(const IPUArchInfo &IAI, uint8_t *Loc, R Rel,
                       uint64_t Val, CA checkAlignment, CU checkUInt) {
  const uint64_t DefaultImageBase = IAI.TMEM_REGION0_BASE_ADDR;

  using namespace llvm::support::endian;

  unsigned Type = getType(Rel);

  switch (Type) {
  // Debug section may reference discarded symbols or symbols in garbage
  // collected sections. These references are relocated to a tombstone value
  // using R_COLOSSUS_NONE.
  case ELF::R_COLOSSUS_NONE:
    return true;
  case ELF::R_COLOSSUS_8:
    if (!checkUInt(Loc, Val, 8, Rel))
      return false;
    *Loc = static_cast<std::uint8_t>(Val);
    return true;

  case ELF::R_COLOSSUS_16:
    if (!checkUInt(Loc, Val, 16, Rel))
      return false;
    write16le(Loc, Val);
    return true;

  case ELF::R_COLOSSUS_RELATIVE_16_S2:
    if (!checkAlignment(Loc, Val, 4, Rel))
      return false;
    Val = (Val - DefaultImageBase) >> 2;
    if (!checkUInt(Loc, Val, 16, Rel))
      return false;
    write16le(Loc, Val);
    return true;

  case ELF::R_COLOSSUS_16_S3:
    if (!checkAlignment(Loc, Val, 8, Rel))
      return false;
    Val = Val >> 3;
    if (!checkUInt(Loc, Val, 16, Rel))
      return false;
    write16le(Loc, Val);
    return true;

  case ELF::R_COLOSSUS_16_S4:
    if (!checkAlignment(Loc, Val, 16, Rel)) return false;
    Val = Val >> 4;
    if (!checkUInt(Loc, Val, 16, Rel)) return false;
    write16le(Loc, Val);
    return true;

  case ELF::R_COLOSSUS_16_S5:
    if (!checkAlignment(Loc, Val, 32, Rel)) return false;
    Val = Val >> 5;
    if (!checkUInt(Loc, Val, 16, Rel)) return false;
    write16le(Loc, Val);
    return true;

  case ELF::R_COLOSSUS_32:
    if (!checkUInt(Loc, Val, 32, Rel))
      return false;
    write32le(Loc, Val);
    return true;

  case ELF::R_COLOSSUS_64:
    write64le(Loc, Val);
    return true;

  case ELF::R_COLOSSUS_19_S2:
    if (!checkAlignment(Loc, Val, 4, Rel))
      return false;
    Val = Val >> 2;
    if (!checkUInt(Loc, Val, 19, Rel))
      return false;
    write32le(Loc, (read32le(Loc) & 0xFFF80000) | Val);
    return true;

  case ELF::R_COLOSSUS_20:
    if (!checkUInt(Loc, Val, 20, Rel))
      return false;
    write32le(Loc, (read32le(Loc) & 0xFFF00000) | Val);
    return true;

  case ELF::R_COLOSSUS_21:
    if (!checkUInt(Loc, Val, 21, Rel))
      return false;
    write32le(Loc, (read32le(Loc) & 0xFFE00000) | Val);
    return true;

  case ELF::R_COLOSSUS_18_S2:
    if (!checkAlignment(Loc, Val, 4, Rel))
      return false;
    Val = Val >> 2;
    if (!checkUInt(Loc, Val, 18, Rel))
      return false;
    write32le(Loc, (read32le(Loc) & 0xFFFC0000) | Val);
    return true;

  case ELF::R_COLOSSUS_RUN: {
    // Val = (S + A - TMEM_REGION0_BASE_ADDR) >> 2
    // 31  ...           19        16           11                0
    // +--     ---------------------------------------------------+
    // |                | Val[15:12] |         |     Val[11:0]    |
    // +--     ---------------------------------------------------+
    if (!checkAlignment(Loc, Val, 4, Rel))
      return false;
    Val = (Val - DefaultImageBase) >> 2;
    if (!checkUInt(Loc, Val, 16, Rel))
      return false;
    auto Val15_12 = (Val & 0xf000) << 4;
    auto Val11_0 = Val & 0xfff;
    write32le(Loc, (read32le(Loc) & 0xFFF0F000) | Val15_12 | Val11_0);
    return true;
  }

  default:
    break;
  }
  return false;
}

} // namespace colossus
} // namespace llvm

#endif
