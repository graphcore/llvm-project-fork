set(ISD_OPCODE_CONSTANTS)
set(ISD_OPCODE_CONSTANTS_PRINTER_SOURCE ColossusISDOpcodeConstantsPrinter.cpp)
string(REGEX REPLACE "\\.cpp" "" ISD_OPCODE_CONSTANTS_PRINTER ${ISD_OPCODE_CONSTANTS_PRINTER_SOURCE})

# Build with the host compiler a program that output extern constexpr for each
# ISD node initialized with a literal value. Using the host compiler guarantees
# the file will compile even if ColossusISDOpcodes.h transitively includes C++
# standard header files. The host compiler will also resolve for us the ISD
# enum value in the C++ file to a literal value in the program output, allowing
# us to compile the C++ output file to LLVM IR with the clang compiler in the
# generation step below to LLVM IR using the clang compiler being built without
# needing any header.
add_llvm_utility(${ISD_OPCODE_CONSTANTS_PRINTER}
  ${ISD_OPCODE_CONSTANTS_PRINTER_SOURCE}
)

target_link_libraries(${ISD_OPCODE_CONSTANTS_PRINTER} PRIVATE LLVMSupport)

# Generate LLVM IR file with ISD opcode constants used by LLVM Colossus
# testsuite and copy it into Colossus test directory.
set(GENERATED_ISD_OPCODE_CONSTANTS_FILENAME isd_opcode_constants.ll)
set(GENERATED_ISD_OPCODE_CONSTANTS_FILE ${CMAKE_SOURCE_DIR}/test/CodeGen/Colossus/${GENERATED_ISD_OPCODE_CONSTANTS_FILENAME})
set(ISD_OPCODE_CONSTANTS_FILE_GENERATOR gen_isd_opcode_constants)
add_custom_target(regenerate_isd_opcode_constants_file ALL
  DEPENDS ${CMAKE_BINARY_DIR}/${GENERATED_ISD_OPCODE_CONSTANTS_FILENAME}
)
add_custom_command(
  OUTPUT ${CMAKE_BINARY_DIR}/${GENERATED_ISD_OPCODE_CONSTANTS_FILENAME}
  COMMAND ${CMAKE_COMMAND} -E env PATH=${CMAKE_BINARY_DIR}/bin:$ENV{PATH}
          ${CMAKE_CURRENT_SOURCE_DIR}/${ISD_OPCODE_CONSTANTS_FILE_GENERATOR}
          ${CMAKE_BINARY_DIR}/${GENERATED_ISD_OPCODE_CONSTANTS_FILENAME}
  DEPENDS ${ISD_OPCODE_CONSTANTS_PRINTER} clang
  COMMENT "Generating ${GENERATED_ISD_OPCODE_CONSTANTS_FILENAME}"
  MAIN_DEPENDENCY ${CMAKE_CURRENT_SOURCE_DIR}/${ISD_OPCODE_CONSTANTS_FILE_GENERATOR}
  VERBATIM
)
