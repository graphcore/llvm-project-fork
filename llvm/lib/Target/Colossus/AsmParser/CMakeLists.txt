add_llvm_component_library(LLVMColossusAsmParser
  ColossusAsmParser.cpp

  LINK_COMPONENTS
  ColossusDesc
  ColossusInfo
  MC
  MCParser
  Support

  ADD_TO_COMPONENT
  Colossus
)
