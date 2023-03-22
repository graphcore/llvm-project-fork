add_llvm_component_library(LLVMColossusInfo
  ColossusTargetInfo.cpp

  LINK_COMPONENTS
  MC
  Support

  ADD_TO_COMPONENT
  Colossus
)
