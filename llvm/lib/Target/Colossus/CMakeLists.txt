add_llvm_component_group(Colossus)

set(LLVM_TARGET_DEFINITIONS Colossus.td)

# IPU local patch begin
set(TABLEGEN_COMMON_ARGS "-I=${LLVM_COLOSSUS_TBLGEN_INCDIR}")
if("ipu2" IN_LIST ENABLED_IPU_ARCH_NAMES)
  list(APPEND TABLEGEN_COMMON_ARGS "-DIPU2")
endif()
if("ipu21" IN_LIST ENABLED_IPU_ARCH_NAMES)
  list(APPEND TABLEGEN_COMMON_ARGS "-DIPU21" "-DIPU21PLUS")
endif()

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Werror")

if("ipu2" IN_LIST ENABLED_IPU_ARCH_NAMES)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DIPU2")
  endif()
if("ipu21" IN_LIST ENABLED_IPU_ARCH_NAMES)
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DIPU21 -DIPU21PLUS")
endif()
# IPU local patch end

tablegen(LLVM ColossusGenAsmMatcher.inc -gen-asm-matcher ${TABLEGEN_COMMON_ARGS})
tablegen(LLVM ColossusGenAsmWriter.inc -gen-asm-writer ${TABLEGEN_COMMON_ARGS})
tablegen(LLVM ColossusGenCallingConv.inc -gen-callingconv ${TABLEGEN_COMMON_ARGS})
tablegen(LLVM ColossusGenDAGISel.inc -gen-dag-isel ${TABLEGEN_COMMON_ARGS})
tablegen(LLVM ColossusGenDisassemblerTables.inc -gen-disassembler ${TABLEGEN_COMMON_ARGS})
tablegen(LLVM ColossusGenInstrInfo.inc -gen-instr-info ${TABLEGEN_COMMON_ARGS})
tablegen(LLVM ColossusGenMCCodeEmitter.inc -gen-emitter ${TABLEGEN_COMMON_ARGS})
tablegen(LLVM ColossusGenRegisterInfo.inc -gen-register-info ${TABLEGEN_COMMON_ARGS})
tablegen(LLVM ColossusGenSubtargetInfo.inc -gen-subtarget ${TABLEGEN_COMMON_ARGS})
tablegen(LLVM ColossusGenMCPseudoLowering.inc -gen-pseudo-lowering ${TABLEGEN_COMMON_ARGS})

add_public_tablegen_target(ColossusCommonTableGen)

add_llvm_target(ColossusCodeGen
  ColossusAsmPrinter.cpp
  ColossusCoissuePass.cpp
  ColossusCoissueUtil.cpp
  ColossusCountedLoopOptions.cpp
  ColossusCountedLoopMIRPass.cpp
  ColossusFrameLowering.cpp
  ColossusFunctionCheck.cpp
  ColossusInstrInfo.cpp
  ColossusIntrinsicCallsPass.cpp
  ColossusISelDAGToDAG.cpp
  ColossusISelLowering.cpp
  ColossusLibmCallsPass.cpp
  ColossusLoadStoreVectorizer.cpp
  ColossusLoopConversionPass.cpp
  ColossusMachineFunctionInfo.cpp
  ColossusMachineScheduler.cpp
  ColossusMCInstLower.cpp
  ColossusRegisterInfo.cpp
  ColossusSelectionDAGInfo.cpp
  ColossusSubtarget.cpp
  ColossusTargetMachine.cpp
  ColossusTargetObjectFile.cpp
  ColossusTargetTransformInfo.cpp
  ColossusUnnecessaryAndElim.cpp

  LINK_COMPONENTS
  Analysis
  AsmPrinter
  CodeGen
  ColossusArchInfo
  ColossusAsmParser
  ColossusDesc
  ColossusInfo
  Core
  Demangle
  IPO
  MC
  SelectionDAG
  Support
  Scalar
  Target
  TransformUtils

  ADD_TO_COMPONENT
  Colossus
)

add_subdirectory(ipu_arch_info)
add_subdirectory(AsmParser)
add_subdirectory(Disassembler)
add_subdirectory(ISDOpcodeConstantsPrinter)
add_subdirectory(TargetInfo)
add_subdirectory(MCTargetDesc)
