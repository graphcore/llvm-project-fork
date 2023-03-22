add_llvm_component_library(LLVMColossusDesc
  ColossusMCAsmBackend.cpp
  ColossusMCAsmInfo.cpp
  ColossusMCCodeEmitter.cpp
  ColossusMCELFStreamer.cpp
  ColossusMCObjectWriter.cpp
  ColossusMCTargetDesc.cpp
  ColossusMCInstrInfo.cpp
  ColossusInstPrinter.cpp

  LINK_COMPONENTS
  ColossusInfo
  MC
  Support

  ADD_TO_COMPONENT
  Colossus
)
