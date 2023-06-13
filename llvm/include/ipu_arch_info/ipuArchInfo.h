/*
 * Copyright (c) 2022 Graphcore Ltd. All rights reserved.
 */

#ifndef _ipuArchInfo_h_
#define _ipuArchInfo_h_

#include "llvm/Support/Compiler.h"

#include <cstdint>
#include <string>

struct IPUArchInfo {
  const uint32_t TMEM_REGION0_BASE_ADDR;
  const uint32_t CSR_W_REPEAT_COUNT__VALUE__MASK;
  const uint32_t ARF_GP_REGISTERS;
  const uint32_t MRF_GP_REGISTERS;

  IPUArchInfo(uint32_t TMEM_REGION0_BASE_ADDR,
              uint32_t CSR_W_REPEAT_COUNT__VALUE__MASK,
              uint32_t ARF_GP_REGISTERS, uint32_t MRF_GP_REGISTERS)
      : TMEM_REGION0_BASE_ADDR(TMEM_REGION0_BASE_ADDR),
        CSR_W_REPEAT_COUNT__VALUE__MASK(CSR_W_REPEAT_COUNT__VALUE__MASK),
        ARF_GP_REGISTERS(ARF_GP_REGISTERS), MRF_GP_REGISTERS(MRF_GP_REGISTERS) {
  }
};

extern "C" LLVM_EXTERNAL_VISIBILITY const IPUArchInfo &ipuArchInfoByName(const std::string &archName);

#endif // _ipuArchInfo_h_
