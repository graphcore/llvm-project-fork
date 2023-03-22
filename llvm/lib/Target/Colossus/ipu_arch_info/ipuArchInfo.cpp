/*
 * Copyright (c) 2022 Graphcore Ltd. All rights reserved.
 */

#include "ipu_arch_info/ipuArchInfo.h"
#include "llvm/ADT/StringRef.h"
#include "llvm/Support/ErrorHandling.h"
#include <stdexcept>

using namespace llvm;

struct IPUArchInfo ipu1(0x40000, 0xfff, 0x8, 0x0c);
struct IPUArchInfo ipu2(0x4c000, 0xffff, 0x8, 0x0c);
struct IPUArchInfo ipu21(0x4c000, 0xffff, 0x8, 0x0c);

const IPUArchInfo &ipuArchInfoByName(const std::string &archName) {
  if (archName == "ipu1") {
    return ipu1;
  } else if (archName == "ipu2") {
    return ipu2;
  } else if (archName == "ipu21") {
    return ipu21;
  } else {
    std::string error =
        "'" + archName + "' is not a supported IPU architecture";
    report_fatal_error(error);
  }
}
