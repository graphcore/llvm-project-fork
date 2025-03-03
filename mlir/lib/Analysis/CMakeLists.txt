set(LLVM_OPTIONAL_SOURCES
  AliasAnalysis.cpp
  BufferViewFlowAnalysis.cpp
  CallGraph.cpp
  DataFlowAnalysis.cpp
  DataLayoutAnalysis.cpp
  IntRangeAnalysis.cpp
  Liveness.cpp
  SliceAnalysis.cpp

  AliasAnalysis/LocalAliasAnalysis.cpp

  DataFlow/ConstantPropagationAnalysis.cpp
  DataFlow/DeadCodeAnalysis.cpp
  DataFlow/SparseAnalysis.cpp
  )

add_mlir_library(MLIRAnalysis
  AliasAnalysis.cpp
  BufferViewFlowAnalysis.cpp
  CallGraph.cpp
  DataFlowAnalysis.cpp
  DataFlowFramework.cpp
  DataLayoutAnalysis.cpp
  IntRangeAnalysis.cpp
  Liveness.cpp
  SliceAnalysis.cpp

  AliasAnalysis/LocalAliasAnalysis.cpp

  DataFlow/ConstantPropagationAnalysis.cpp
  DataFlow/DeadCodeAnalysis.cpp
  DataFlow/SparseAnalysis.cpp

  ADDITIONAL_HEADER_DIRS
  ${MLIR_MAIN_INCLUDE_DIR}/mlir/Analysis

  DEPENDS
  mlir-headers

  LINK_LIBS PUBLIC
  MLIRCallInterfaces
  MLIRControlFlowInterfaces
  MLIRDataLayoutInterfaces
  MLIRInferIntRangeInterface
  MLIRInferTypeOpInterface
  MLIRLoopLikeInterface
  MLIRSideEffectInterfaces
  MLIRViewLikeInterface
  )

add_subdirectory(Presburger)
