add_llvm_component_library(LLVMColossusDisassembler
  ColossusDisassembler.cpp

  LINK_COMPONENTS
  ColossusDesc
  ColossusInfo
  MC
  MCDisassembler
  Support

  ADD_TO_COMPONENT
  Colossus
)
