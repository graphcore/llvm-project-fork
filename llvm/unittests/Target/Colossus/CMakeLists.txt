include_directories(
  ${PROJECT_SOURCE_DIR}/lib/Target/Colossus
  ${PROJECT_SOURCE_DIR}/lib/Target/Colossus/AsmParser
  ${PROJECT_BINARY_DIR}/lib/Target/Colossus
)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Werror")

set(LLVM_LINK_COMPONENTS
  ColossusDesc
  ColossusInfo
  Colossus
  CodeGen
  MC
  MCParser
  Support
  Core
  Target
)

add_llvm_target_unittest(ColossusTests
  ColossusAsmParserTest.cpp
  ColossusInstrInfoTest.cpp
  ColossusRegisterInfoTest.cpp
)