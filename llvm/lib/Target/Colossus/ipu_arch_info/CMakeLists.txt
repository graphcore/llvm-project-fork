add_llvm_component_library(LLVMColossusArchInfo
  ipuArchInfo.cpp

  LINK_COMPONENTS
  Support

  ADD_TO_COMPONENT
  Colossus
)
