//===-- ColossusInstrInfo.td - Colossus Instructions -*- tablegen -*-------===//
//    Copyright (c) 2023 Graphcore Ltd. All Rights Reserved.
//     Licensed under the Apache License, Version 2.0 (the "License");
//     you may not use this file except in compliance with the License.
//     You may obtain a copy of the License at
//
//        http://www.apache.org/licenses/LICENSE-2.0
//
//     Unless required by applicable law or agreed to in writing, software
//     distributed under the License is distributed on an "AS IS" BASIS,
//     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//     See the License for the specific language governing permissions and
//     limitations under the License.
// --- LLVM Exceptions to the Apache 2.0 License ----
//
// As an exception, if, as a result of your compiling your source code, portions
// of this Software are embedded into an Object form of such source code, you
// may redistribute such embedded portions in such Object form without complying
// with the conditions of Sections 4(a), 4(b) and 4(d) of the License.
//
// In addition, if you combine or link compiled forms of this Software with
// software that is licensed under the GPLv2 ("Combined Software") and if a
// court of competent jurisdiction determines that the patent provision (Section
// 3), the indemnity provision (Section 9) or other Section of the License
// conflicts with the conditions of the GPLv2, you may retroactively and
// prospectively choose to deem waived or otherwise exclude such Section(s) of
// the License, but only in their entirety and only with respect to the Combined
// Software.
//
//===----------------------------------------------------------------------===//
//
// This file describes the Colossus instructions in TableGen format.
//
//===----------------------------------------------------------------------===//

//===----------------------------------------------------------------------===//
// Instruction format superclass.
//===----------------------------------------------------------------------===//

include "ColossusInstrFormats.td"
include "ColossusSchedule.td"
include "ColossusDefinesGenerated.td"

//===----------------------------------------------------------------------===//
// Colossus-specific DAG Nodes.
//===----------------------------------------------------------------------===//

// These are target-independent nodes, but have target-specific formats.

def SDT_ColossusCallSeqStart : SDCallSeqStart<[SDTCisVT<0, i32>,
                                               SDTCisVT<1, i32>]>;
def callseq_start : SDNode<"ISD::CALLSEQ_START",
                           SDT_ColossusCallSeqStart,
                           [SDNPHasChain, SDNPOptInGlue, SDNPOutGlue]>;

def SDT_ColossusCallSeqEnd : SDCallSeqEnd<[SDTCisVT<0, i32>,
                                           SDTCisVT<1, i32>]>;
def callseq_end : SDNode<"ISD::CALLSEQ_END",
                         SDT_ColossusCallSeqEnd,
                         [SDNPHasChain, SDNPOptInGlue, SDNPOutGlue]>;

def rtn_reg_holder : SDNode<"ColossusISD::RTN_REG_HOLDER",
                            SDTNone,
                            [SDNPHasChain, SDNPVariadic]>;

def stacksave : SDNode<"ColossusISD::STACKSAVE",
                       SDTNone,
                       [SDNPHasChain]>;

def stackrestore : SDNode<"ColossusISD::STACKRESTORE",
                          SDTNone,
                          [SDNPHasChain]>;

def frametoargsoffset : SDNode<"ColossusISD::FRAME_TO_ARGS_OFFSET",
                               SDTIntLeaf,
                               []>;

def SDT_ColossusCall : SDTypeProfile<0, 1, [SDTCisVT<0, i32>]>;
def ColossusCall : SDNode<"ColossusISD::CALL",
                          SDT_ColossusCall,
                          [SDNPHasChain, SDNPOptInGlue, SDNPOutGlue,
                           SDNPVariadic]>;

def SDT_ColossusSetLR : SDTypeProfile<0, 1, [SDTCisVT<0, i32>]>;
def ColossusSetLR : SDNode<"ColossusISD::SETLR",
                           SDT_ColossusSetLR,
                           [SDNPHasChain, SDNPOptInGlue, SDNPOutGlue]>;

def SDT_ColossusICall : SDTypeProfile<0, 2, [SDTCisVT<0, i32>,
                                             SDTCisVT<1, i32>]>;
def ColossusICall : SDNode<"ColossusISD::ICALL",
                           SDT_ColossusICall,
                           [SDNPHasChain, SDNPOptInGlue, SDNPOutGlue,
                            SDNPVariadic]>;

def ColossusRtn : SDNode<"ColossusISD::RTN",
                         SDTNone,
                         [SDNPHasChain, SDNPOptInGlue]>;

def ColossusVertexExit : SDNode<"ColossusISD::VERTEX_EXIT",
                                SDTypeProfile<0, 1, []>,
                                [SDNPHasChain, SDNPOptInGlue]>;

def ColossusWrapper : SDNode<"ColossusISD::WRAPPER",
                             SDTIntUnaryOp>;

def SDT_ColossusValue : SDTypeProfile<1, 2, [SDTCisVT<0, i32>,
                                             SDTCisVT<1, i32>,
                                             SDTCisVT<2, i32>]>;
def ColossusCloopBeginValue :
  SDNode<"ColossusISD::CLOOP_BEGIN_VALUE",
         SDT_ColossusValue,
         [SDNPHasChain]>;
def ColossusCloopBeginTerminator :
  SDNode<"ColossusISD::CLOOP_BEGIN_TERMINATOR",
         SDTypeProfile<0, 2, [SDTCisVT<0, i32>, SDTCisVT<1, i32>]>,
         [SDNPHasChain]>;
def ColossusCloopEndValue :
  SDNode<"ColossusISD::CLOOP_END_VALUE",
         SDT_ColossusValue,
         [SDNPHasChain]>;
def ColossusCloopEndBranch :
  SDNode<"ColossusISD::CLOOP_END_BRANCH",
         SDTypeProfile<0, 3, [SDTCisVT<1, i32>, SDTCisVT<2, i32>]>,
         [SDNPHasChain]>;
def ColossusCloopGuardBranch :
  SDNode<"ColossusISD::CLOOP_GUARD_BRANCH",
         SDTypeProfile<0, 3, [SDTCisVT<1, i32>, SDTCisVT<2, i32>]>,
         [SDNPHasChain]>;

// Memory barrier.
def SDT_ColossusMemBarrier : SDTypeProfile<0, 0, []>;
def ColossusMemBarrier : SDNode<"ColossusISD::MEM_BARRIER",
                                SDT_ColossusMemBarrier,
                                [SDNPHasChain]>;

// Colossus bitwise operations
def SDT_ColossusBinOp : SDTypeProfile<1, 2, [SDTCisSameAs<1,0>,
                                             SDTCisSameAs<2,1>]>;

def SDT_ColossusI32BinOp : SDTypeProfile<1, 2, [SDTCisVT<0, i32>,
                                                SDTCisVT<1, i32>,
                                                SDTCisVT<2, i32>]>;

def ColossusFNOT : SDNode<"ColossusISD::FNOT", SDTFPUnaryOp>;
def ColossusFAND : SDNode<"ColossusISD::FAND", SDTFPBinOp>;
def ColossusFOR : SDNode<"ColossusISD::FOR", SDTFPBinOp>;
def ColossusANDC : SDNode<"ColossusISD::ANDC", SDT_ColossusBinOp>;

// SORT and ROLL are limited to 32 bit types
def ColossusSORT4X16LO : SDNode<"ColossusISD::SORT4X16LO", SDT_ColossusBinOp>;
def ColossusSORT4X16HI : SDNode<"ColossusISD::SORT4X16HI", SDT_ColossusBinOp>;
def ColossusROLL16 : SDNode<"ColossusISD::ROLL16", SDT_ColossusBinOp>;
def ColossusSORT8X8LO : SDNode<"ColossusISD::SORT8X8LO", SDT_ColossusI32BinOp>;
def ColossusSHUF8X8LO : SDNode<"ColossusISD::SHUF8X8LO", SDT_ColossusI32BinOp>;
def ColossusSHUF8X8HI : SDNode<"ColossusISD::SHUF8X8HI", SDT_ColossusI32BinOp>;

// Same as ISD::CONCAT_VECTORS, bypasses the generic DAGCombiner pass
def ColossusCONCAT_VECTORS : SDNode<"ColossusISD::CONCAT_VECTORS",
    SDTypeProfile<1, 2, [SDTCisSubVecOfVec<1, 0>, SDTCisSameAs<1, 2>]>,[]>;

// Floating point comparisons
def SDT_ColossusFCMP : SDTypeProfile<1, 3, [
  SDTCisFP<0>, SDTCisSameAs<1, 2>, SDTCisVT<3, OtherVT>
]>;
def ColossusFCMP : SDNode<"ColossusISD::FCMP", SDT_ColossusFCMP>;
def ColossusSTRICT_FCMPS : SDNode<"ColossusISD::STRICT_FCMPS", SDT_ColossusFCMP, [SDNPHasChain]>;
def any_ColossusFCMP : PatFrags<(ops node:$lhs, node:$rhs, node:$pred), [(ColossusFCMP node:$lhs, node:$rhs, node:$pred), (ColossusSTRICT_FCMPS node:$lhs, node:$rhs, node:$pred)]>;

def any_ColossusFCMPOEQ  : PatFrag<(ops node:$lhs, node:$rhs),
                                   (any_ColossusFCMP node:$lhs, node:$rhs, SETOEQ)>;
def any_ColossusFCMPOLT  : PatFrag<(ops node:$lhs, node:$rhs),
                                   (any_ColossusFCMP node:$lhs, node:$rhs, SETOLT)>;
def any_ColossusFCMPOLE  : PatFrag<(ops node:$lhs, node:$rhs),
                                   (any_ColossusFCMP node:$lhs, node:$rhs, SETOLE)>;
def any_ColossusFCMPOGT  : PatFrag<(ops node:$lhs, node:$rhs),
                                   (any_ColossusFCMP node:$lhs, node:$rhs, SETOGT)>;
def any_ColossusFCMPOGE  : PatFrag<(ops node:$lhs, node:$rhs),
                                   (any_ColossusFCMP node:$lhs, node:$rhs, SETOGE)>;
def any_ColossusFCMPUNE  : PatFrag<(ops node:$lhs, node:$rhs),
                                   (any_ColossusFCMP node:$lhs, node:$rhs, SETUNE)>;
def any_ColossusFCMPEQ  : PatFrag<(ops node:$lhs, node:$rhs),
                                  (any_ColossusFCMP node:$lhs, node:$rhs, SETEQ)>;
def any_ColossusFCMPNE  : PatFrag<(ops node:$lhs, node:$rhs),
                                  (any_ColossusFCMP node:$lhs, node:$rhs, SETNE)>;
def any_ColossusFCMPLT  : PatFrag<(ops node:$lhs, node:$rhs),
                                  (any_ColossusFCMP node:$lhs, node:$rhs, SETLT)>;
def any_ColossusFCMPLE  : PatFrag<(ops node:$lhs, node:$rhs),
                                  (any_ColossusFCMP node:$lhs, node:$rhs, SETLE)>;
def any_ColossusFCMPGT  : PatFrag<(ops node:$lhs, node:$rhs),
                                  (any_ColossusFCMP node:$lhs, node:$rhs, SETGT)>;
def any_ColossusFCMPGE  : PatFrag<(ops node:$lhs, node:$rhs),
                                  (any_ColossusFCMP node:$lhs, node:$rhs, SETGE)>;

// Floating point / integer conversions on the ARF
def SDT_ColossusUnaryF32 : SDTypeProfile<1, 1, [SDTCisVT<0, f32>,  SDTCisSameAs<0, 1>]>;
def f32_to_sint : SDNode<"ColossusISD::F32_TO_SINT", SDT_ColossusUnaryF32>;
def strict_f32_to_sint : SDNode<"ColossusISD::STRICT_F32_TO_SINT", SDT_ColossusUnaryF32, [SDNPHasChain]>;
def any_f32_to_sint : PatFrags<(ops node:$src), [(strict_f32_to_sint node:$src), (f32_to_sint node:$src)]>;
def f32_to_uint : SDNode<"ColossusISD::F32_TO_UINT", SDT_ColossusUnaryF32>;
def strict_f32_to_uint : SDNode<"ColossusISD::STRICT_F32_TO_UINT", SDT_ColossusUnaryF32, [SDNPHasChain]>;
def any_f32_to_uint : PatFrags<(ops node:$src), [(strict_f32_to_uint node:$src), (f32_to_uint node:$src)]>;
def sint_to_f32 : SDNode<"ColossusISD::SINT_TO_F32", SDT_ColossusUnaryF32>;
def uint_to_f32 : SDNode<"ColossusISD::UINT_TO_F32", SDT_ColossusUnaryF32>;

// Essentially bitcasts, but between different widths
def ColossusF16ASV2F16 : SDNode<"ColossusISD::F16ASV2F16",
  SDTypeProfile<1,1, [SDTCisVT<0, v2f16>, SDTCisVT<1,f16>]>>;
def ColossusV2F16ASF16 : SDNode<"ColossusISD::V2F16ASF16",
  SDTypeProfile<1,1, [SDTCisVT<0, f16>, SDTCisVT<1,v2f16>]>>;

def fexp : SDNode<"ISD::FEXP", SDTFPUnaryOp>;
def strict_fexp : SDNode<"ISD::STRICT_FEXP", SDTFPUnaryOp, [SDNPHasChain]>;
def any_fexp : PatFrags<(ops node:$src),
                         [(strict_fexp node:$src), (fexp node:$src)]>;
def flog : SDNode<"ISD::FLOG", SDTFPUnaryOp>;
def strict_flog : SDNode<"ISD::STRICT_FLOG", SDTFPUnaryOp, [SDNPHasChain]>;
def any_flog : PatFrags<(ops node:$src),
                        [(strict_flog node:$src), (flog node:$src)]>;

def ColossusFTANH : SDNode<"ColossusISD::FTANH", SDTFPUnaryOp>;

def ColossusFRSQRT : SDNode<"ColossusISD::FRSQRT", SDTFPUnaryOp>;
def ColossusSTRICT_FRSQRT : SDNode<"ColossusISD::STRICT_FRSQRT", SDTFPUnaryOp, [SDNPHasChain]>;
def any_ColossusFRSQRT : PatFrags<(ops node:$src), [(ColossusSTRICT_FRSQRT node:$src), (ColossusFRSQRT node:$src)]>;

def ColossusFSIGMOID : SDNode<"ColossusISD::FSIGMOID", SDTFPUnaryOp>;

//===----------------------------------------------------------------------===//
// Instruction Pattern Stuff
//===----------------------------------------------------------------------===//

class ImmAsmOperand<string suffix> : AsmOperandClass {
  let Name = "Imm"#suffix;
  let RenderMethod = "addImmOperands";
}

class ImmZIOperand<int sz, AsmOperandClass MatchClass> : Operand<i32>,
    ImmLeaf<i32, "return isUInt<"#sz#">((uint32_t)Imm);"> {
  let ParserMatchClass = MatchClass;
}

class ImmSIOperand<int sz, AsmOperandClass MatchClass> : Operand<i32>,
    ImmLeaf<i32, "return isInt<"#sz#">((int32_t)Imm);"> {
  let ParserMatchClass = MatchClass;
  let DecoderMethod = "DecodeImm"#sz#"SIOperand";
  let PrintMethod = "printImmSIOperand<"#sz#">";
}

class ImmIZOperand<int sz, AsmOperandClass MatchClass> : Operand<i32>,
    ImmLeaf<i32, "return isShiftedUInt<"#sz#",32-"#sz#">((uint32_t)Imm);"> {
  let ParserMatchClass = MatchClass;
  let EncoderMethod = "getImm"#sz#"IZValue";
  let DecoderMethod = "DecodeImm"#sz#"IZOperand";
}

class FP32ImmZIOperand<int sz, AsmOperandClass MatchClass> : Operand<f32>,
  FPImmLeaf<f32,
    "uint64_t value = Imm.bitcastToAPInt().getZExtValue();"
    "return isUInt<"#sz#">(value);"> {
  let ParserMatchClass = MatchClass;
}

class FP32ImmIZOperand<int sz, AsmOperandClass MatchClass> : Operand<f32>,
  FPImmLeaf<f32,
    "uint64_t value = Imm.bitcastToAPInt().getZExtValue();"
    "return isShiftedUInt<"#sz#",32-"#sz#">(value);"> {
  let ParserMatchClass = MatchClass;
  let EncoderMethod = "getImm"#sz#"IZValue";
  let DecoderMethod = "DecodeImm"#sz#"IZOperand";
}

def AddressAsmOperand : AsmOperandClass {
  let Name = "Address";
  let ParserMethod = "parseImmAddressOperand";
  let RenderMethod = "addImmOperands";
}

def Rel19S2OperandClass : AsmOperandClass {
  let Name = "Rel19S2Operand";
  let ParserMethod = "parseImmAddressOperand";
  let RenderMethod = "addImmOperands";
}

def Rel19S2Operand : Operand<OtherVT> {
  let ParserMatchClass = Rel19S2OperandClass;
  let EncoderMethod = "getRel19S2OpValue";
  let PrintMethod = "printBranchOperand<2>";
}

def CallOperand : Operand<i32> {
  let ParserMatchClass = AddressAsmOperand;
  let EncoderMethod = "getRel19S2OpValue";
  let PrintMethod = "printBranchOperand<2>";
}

def LabelOperand : Operand<iPTR>;

def BroadcastLowerOperandClass : AsmOperandClass {
  let Name = "BroadcastLowerOperand";
  let ParserMethod = "parseBroadcastOperand";
  let RenderMethod = "addRegOperands";
}

def BroadcastUpperOperandClass : AsmOperandClass {
  let Name = "BroadcastUpperOperand";
  let ParserMethod = "parseBroadcastOperand";
  let RenderMethod = "addRegOperands";
}

def BroadcastOperandClass : AsmOperandClass {
  let Name = "BroadcastOperand";
  let ParserMethod = "parseBroadcastOperand";
  let RenderMethod = "addRegOperands";
}

def BroadcastLowerOperand :  RegisterOperand<AR> {
  let ParserMatchClass = BroadcastLowerOperandClass;
  let PrintMethod = "printBroadcastLowerOperand";
}

def BroadcastUpperOperand :RegisterOperand<AR> {
  let ParserMatchClass = BroadcastUpperOperandClass;
  let PrintMethod = "printBroadcastUpperOperand";
}

def BroadcastOperand : RegisterOperand<AR> {
  let ParserMatchClass = BroadcastOperandClass;
  let PrintMethod = "printBroadcastOperand";
}

def RunOperandClass : AsmOperandClass {
  let Name = "RunOperand";
  let RenderMethod = "addImmOperands";
}

def RunOperand : Operand<i32> {
  let ParserMatchClass = RunOperandClass;
  let EncoderMethod = "getRunOpValue";
}

def Rel8OperandClass : AsmOperandClass {
  let Name = "Rel8Operand";
  let RenderMethod = "addImmOperands";
}

def Rel8Operand : Operand<i32> {
  let ParserMatchClass = Rel8OperandClass;
  let EncoderMethod = "getRel8OpValue";
}

def Rel16OperandClass : AsmOperandClass {
  let Name = "Rel16Operand";
  let RenderMethod = "addImmOperands";
}

def Rel16Operand : Operand<i32> {
  let ParserMatchClass = Rel16OperandClass;
  let EncoderMethod = "getRel16OpValue";
}

def Rel20OperandClass : AsmOperandClass {
  let Name = "Rel20Operand";
  let RenderMethod = "addImmOperands";
}

def Rel20Operand : Operand<i32> {
  let ParserMatchClass = Rel20OperandClass;
  let EncoderMethod = "getRel20OpValue";
}

def Rel21OperandClass : AsmOperandClass {
  let Name = "Rel21Operand";
  let RenderMethod = "addImmOperands";
}

def Rel21Operand : Operand<i32> {
  let ParserMatchClass = Rel21OperandClass;
  let EncoderMethod = "getRel21OpValue";
}

def ACCOperandClass : AsmOperandClass {
  let Name = "ACCOperand";
  let ParserMethod = "parseACCOperand<1>";
  let RenderMethod = "addRegOperands";
}

def ACCOperand : RegisterOperand<ACC, "printACCOperand"> {
  let ParserMatchClass = ACCOperandClass;
}

def ACCPairOperandClass : AsmOperandClass {
  let Name = "ACCPairOperand";
  let ParserMethod = "parseACCOperand<2>";
  let RenderMethod = "addRegOperands";
}

def ACCPairOperand : RegisterOperand<ACCPair, "printACCOperand"> {
  let ParserMatchClass = ACCPairOperandClass;
}

def ARPairOperand : RegisterOperand<ARPair> {
  let EncoderMethod = "getARPairEncoding";
}

def ARQuadOperand : RegisterOperand<ARQuad> {
  let EncoderMethod = "getARQuadEncoding";
}

//===----------------------------------------------------------------------===//
// Pattern fragments for values and types.
//===----------------------------------------------------------------------===//

// Pattern fragments that combines the value type and the register class into a
// single parameter. The pattern fragments in the definitions below need to
// have a named register, otherwise i32 will be assumed regardless of the
// register class. The name of the register does not matter.

def i32MR : PatLeaf<(i32 MR:$R)>;
def f32AR : PatLeaf<(f32 AR:$R)>;
def f16AR : PatLeaf<(f16 AR:$R)>;

def v2i16MR : PatLeaf<(v2i16 MR:$R)>;
def v2i32MR : PatLeaf<(v2i32 MRPair:$R)>;
def v4i16MR : PatLeaf<(v4i16 MRPair:$R)>;

def v2f16AR : PatLeaf<(v2f16 AR:$R)>;
def v2f32AR : PatLeaf<(v2f32 ARPairOperand:$R)>;
def v4f16AR : PatLeaf<(v4f16 ARPairOperand:$R)>;
def v4f32AR : PatLeaf<(v4f32 ARQuadOperand:$R)>;
def v8f16AR : PatLeaf<(v8f16 ARQuadOperand:$R)>;
def v8f32AR : PatLeaf<(v8f32 AROctad:$R)>;

def CoissueFlag : Flag<0>;

def imm20zi : ImmZIOperand<20, ImmAsmOperand<"20zi">>;

// Addressing modes.
// Two operand.
def ADDRrr64 : ComplexPattern<i32, 2, "SelectADDRrr<64>", [], []>;
def ADDRri64 : ComplexPattern<i32, 2, "SelectADDRri<64>", [frameindex], []>;
def ADDRrr32 : ComplexPattern<i32, 2, "SelectADDRrr<32>", [], []>;
def ADDRri32 : ComplexPattern<i32, 2, "SelectADDRri<32>", [frameindex], []>;
def ADDRrr16 : ComplexPattern<i32, 2, "SelectADDRrr<16>", [], []>;
def ADDRri16 : ComplexPattern<i32, 2, "SelectADDRri<16>", [frameindex], []>;
def ADDRrr8  : ComplexPattern<i32, 2, "SelectADDRrr<8>",  [], []>;
def ADDRri8  : ComplexPattern<i32, 2, "SelectADDRri<8>",  [frameindex], []>;
def ADDRfi64 : ComplexPattern<i32, 2, "SelectADDRfi<64>", [frameindex], []>;
def ADDRfi32 : ComplexPattern<i32, 2, "SelectADDRfi<32>", [frameindex], []>;
def ADDRfi16 : ComplexPattern<i32, 2, "SelectADDRfi<16>", [frameindex], []>;
def ADDRfi8  : ComplexPattern<i32, 2, "SelectADDRfi<8>",  [frameindex], []>;
// Three-operand with delta offsets.
def ADDRrrr64 : ComplexPattern<i32, 3, "SelectADDRrrr<64>", [], []>;
def ADDRrri64 : ComplexPattern<i32, 3, "SelectADDRrri<64>", [frameindex], []>;
def ADDRrrr32 : ComplexPattern<i32, 3, "SelectADDRrrr<32>", [], []>;
def ADDRrri32 : ComplexPattern<i32, 3, "SelectADDRrri<32>", [frameindex], []>;
def ADDRrrr16 : ComplexPattern<i32, 3, "SelectADDRrrr<16>", [], []>;
def ADDRrri16 : ComplexPattern<i32, 3, "SelectADDRrri<16>", [frameindex], []>;
def ADDRrrr8  : ComplexPattern<i32, 3, "SelectADDRrrr<8>",  [], []>;
def ADDRrri8  : ComplexPattern<i32, 3, "SelectADDRrri<8>",  [frameindex], []>;

// Address operands.
def MEMrrAsmOperand : AsmOperandClass {
  let Name = "MEMrr";
  let ParserMethod = "parseMEM2Operand";
}

def MEMrrrAsmOperand : AsmOperandClass {
  let Name = "MEMrrr";
  let ParserMethod = "parseMEM3Operand";
}

def MEMrriAsmOperand : AsmOperandClass {
  let Name = "MEMrri";
  let ParserMethod = "parseMEM3Operand";
}

// Two-op addressing mode.
def MEMrr : Operand<i32> {
  let PrintMethod = "printMEM2Operand";
  let DecoderMethod = "DecodeMEMrrOperand";
  let EncoderMethod = "getMEMrrEncoding";
  let MIOperandInfo = (ops MR:$op0, MR:$op1);
  let ParserMatchClass = MEMrrAsmOperand;
}
def MEMri : Operand<i32> {
  let MIOperandInfo = (ops MR:$op0, MR:$op1);
}

// Three-op addressing modes.
def MEMrrr : Operand<i32> {
  let PrintMethod = "printMEM3Operand";
  let DecoderMethod = "DecodeMEMrrrOperand";
  let EncoderMethod = "getMEMrrrEncoding";
  let MIOperandInfo = (ops MR:$op0, MR:$op1, MR:$op2);
  let ParserMatchClass = MEMrrrAsmOperand;
}
def MEMrri : Operand<i32> {
  let PrintMethod = "printMEM3Operand";
  let DecoderMethod = "DecodeMEMrriOperand";
  let EncoderMethod = "getMEMrriEncoding";
  let MIOperandInfo = (ops MR:$op0, MR:$op1, i32imm:$op2);
  let ParserMatchClass = MEMrriAsmOperand;
}

// SDNode transform to scale a signed immediate value by 8.
def Div8si : SDNodeXForm<imm, [{
  assert(N->getSExtValue() % 8 == 0);
  return getI32Imm(N->getSExtValue() / 8, SDLoc(N));
}]>;

// By 4.
def Div4si : SDNodeXForm<imm, [{
  assert(N->getSExtValue() % 4 == 0);
  return getI32Imm(N->getSExtValue() / 4, SDLoc(N));
}]>;

// By 2.
def Div2si : SDNodeXForm<imm, [{
  assert(N->getSExtValue() % 2 == 0);
  return getI32Imm(N->getSExtValue() / 2, SDLoc(N));
}]>;

// Check a 16si immediate is a multiple of 8.
def Imm16siDiv8 : PatLeaf<(imm), [{
  return isShiftedInt<13, 3>(N->getSExtValue());
}]>;

// Multiple of 4.
def Imm16siDiv4 : PatLeaf<(imm), [{
  return isShiftedInt<14, 2>(N->getSExtValue());
}]>;

// Multiple of 2.
def Imm16siDiv2 : PatLeaf<(imm), [{
  return isShiftedInt<15, 1>(N->getSExtValue());
}]>;

// Negative 16-bit immediate.
def NegImm16 : PatLeaf<(imm), [{
  int32_t value = N->getSExtValue();
  return value < 0 && isInt<16>(value);
}]>;

// Mask off the bottom 20 bits.
def Lo20Mask : SDNodeXForm<imm, [{
  return CurDAG->getTargetConstant(
      (unsigned)N->getZExtValue() & 0xFFFFF, SDLoc(N), MVT::i32);
}]>;

// Mask off the top 12 bits.
def Hi12Mask : SDNodeXForm<imm, [{
  return CurDAG->getTargetConstant(
      (unsigned)N->getZExtValue() & (0xFFF << 20), SDLoc(N), MVT::i32);
}]>;

//===----------------------------------------------------------------------===//
// Generated instruction classes.
//===----------------------------------------------------------------------===//

include "ColossusInstrInfoCommonGenerated.td"
include "ColossusInstrInfoSupervisorGenerated.td"
include "ColossusInstrInfoWorkerGenerated.td"
include "ColossusInstrInfoDefinesGenerated.td"

//===----------------------------------------------------------------------===//
// Pseudo instructions.
//===----------------------------------------------------------------------===//

def LDCONST : AsmPseudo<(outs MR:$dest),
                        (ins i32imm:$imm),
                        "ldconst $dest, $imm",
                        []>;

def LDCONST_A : AsmPseudo<(outs AR:$dest),
                        (ins i32imm:$imm),
                        "ldconst $dest, $imm",
                        []>;

def SUB_IMM : AsmPseudo<(outs MR:$dest),
                        (ins MR:$src, imm16si:$imm, CoissueFlag:$coissue),
                        "sub $dest, $src, $imm",
                        []>;

let Defs = [SP], Uses = [SP] in {
def ADJCALLSTACKDOWN : Pseudo<(outs),
                              (ins i32imm:$amt1, i32imm:$amt2),
                              "# ADJCALLSTACKDOWN $amt1 $amt2",
                              [(callseq_start timm:$amt1, timm:$amt2)]>;

def ADJCALLSTACKUP : Pseudo<(outs),
                            (ins i32imm:$amt1, i32imm:$amt2),
                            "# ADJCALLSTACKUP $amt1 $amt2",
                            [(callseq_end timm:$amt1, timm:$amt2)]>;
}

let hasSideEffects = 1  in {
def STACKSAVE : Pseudo<(outs),
                       (ins),
                       "# STACKSAVE ",
                       [(stacksave)]>;

def STACKRESTORE : Pseudo<(outs),
                          (ins),
                          "# STACKRESTORE",
                          [(stackrestore)]>;
}

def CALL_PSEUDO : Pseudo<(outs),
                         (ins CallOperand:$addr),
                         "# CALL_PSEUDO $addr",
                         []> {
  let isCall = 1;
  let Defs = [LR];
}

def SETLR : Pseudo<(outs),
                   (ins LabelOperand:$link),
                   "# SETLR $link",
                   []> {
  let Defs = [LR];
}

def ICALL : Pseudo<(outs),
                   (ins LabelOperand:$link, CallOperand:$addr),
                   "# ICALL $link, $addr",
                   []> {
  let isCall = 1;
  let Uses = [LR];
}

def RTN_PSEUDO : Pseudo<(outs),
                        (ins),
                        "# RTN_PSEUDO",
                        []> {
  let isReturn = 1;
  let isTerminator = 1;
  let isBarrier = 1;
  let Pattern = [(ColossusRtn)];
}

def RTN_REG_HOLDER : Pseudo<(outs),
                            (ins),
                            "# RTN_REG_HOLDER",
                            [(rtn_reg_holder)]> {
  let isReturn = 1;
  let isTerminator = 1;
  let isBarrier = 1;
}

let isReMaterializable = 1 in
def FRAME_TO_ARGS_OFFSET : Pseudo<(outs MR:$dst),
                                  (ins),
                                  "# FRAME_TO_ARGS_OFFSET $dst",
                                  [(set i32MR:$dst, (frametoargsoffset))]>;

def LABEL : Pseudo<(outs),
                   (ins CallOperand:$sym),
                   "# LABEL $sym",
                   []>;

let hasSideEffects = 1 in
def MEM_BARRIER : Pseudo<(outs),
                         (ins),
                         "# MEM_BARRIER",
                         [(ColossusMemBarrier)]>;

def FRAME_INDEX : Pseudo<(outs MR:$dst),
                         (ins MEMri:$addr),
                         "# FRAME_INDEX $dst, $addr",
                         [(set MR:$dst, ADDRfi32:$addr)]>;

let OperandType = "OPERAND_IMMEDIATE" in {
  def f16imm : Operand<f16>;
}

// There is no floating point MOVZ, so selects are lowered using a branch.
class select_float_pseudo<string Suffix, ValueType VT, DAGOperand RC,
                          PatFrag RegTy> :
  Pseudo<(outs RC:$dst),
         (ins MR:$cond, RC:$true, RC:$false),
         "# SELECT_" # Suffix # " $dst, $cond, $true, $false",
         [(set RegTy:$dst,
            (VT (select i32MR:$cond, RegTy:$true, RegTy:$false)))]>;

let usesCustomInserter = 1 in {
  def SELECT_F16 : select_float_pseudo<"F16", f16, AR, f16AR>;
  def SELECT_V2F16 : select_float_pseudo<"V2F16", v2f16, AR, v2f16AR>;
  def SELECT_V4F16 : select_float_pseudo<"V4F16", v4f16, ARPairOperand, v4f16AR>;
  def SELECT_F32 : select_float_pseudo<"F32", f32, AR, f32AR>;
  def SELECT_V2F32 : select_float_pseudo<"V2F32", v2f32, ARPairOperand, v2f32AR>;
}


// Frame-index loads and stores. Note: these are lowered to machine
// instructions by ColossusRegisterInfo::EliminateFrameIndex().

let mayLoad = 1, hasSideEffects = 0 in {

  // LD64
  def LD64_FI : Pseudo<(outs MRPair:$dst),
                       (ins MEMri:$addr),
                       "# LD64_FI $dst, $addr", []>;

  def LD64_A_FI : Pseudo<(outs ARPair:$dst),
                         (ins MEMri:$addr),
                         "# LD64_A_FI $dst, $addr", []>;

  def LD64_ACC_FI : Pseudo<(outs ACCPair:$dst),
                           (ins MEMri:$addr),
                           "# LD64_ACC_FI $dst, $addr", []>;

  // LD32
  def LD32_FI : Pseudo<(outs MR:$dst),
                       (ins MEMri:$addr),
                       "# LD32_FI $dst, $addr", []>;

  def LD32_A_FI : Pseudo<(outs AR:$dst),
                         (ins MEMri:$addr),
                         "# LD32_A_FI $dst, $addr", []>;

  def LD32_ACC_FI : Pseudo<(outs ACC:$dst),
                           (ins MEMri:$addr),
                           "# LD32_ACC_FI $dst, $addr", []>;

  // LD16
  def LDS16_FI : Pseudo<(outs MR:$dst),
                        (ins MEMri:$addr),
                        "# LDS16_FI $dst, $addr", []>;

  def LDZ16_FI : Pseudo<(outs MR:$dst),
                        (ins MEMri:$addr),
                        "# LDZ16_FI $dst, $addr", []>;

  def LDZ16_A_FI : Pseudo<(outs AR:$dst),
                          (ins MEMri:$addr),
                          "# LDZ16_A_FI $dst, $addr", []>;

  // LD8
  def LDS8_FI : Pseudo<(outs MR:$dst),
                       (ins MEMri:$addr),
                       "# LDS8_FI $dst, $addr", []>;

  def LDZ8_FI : Pseudo<(outs MR:$dst),
                       (ins MEMri:$addr),
                       "# LDZ8_FI $dst, $addr", []>;
}

let mayStore = 1, hasSideEffects = 0 in {

  // ST64
  def ST64_FI : Pseudo<(outs),
                       (ins MRPair:$src, MEMri:$addr),
                       "# ST64_FI $src, $addr", []>;

  def ST64_A_FI : Pseudo<(outs),
                         (ins ARPair:$src, MEMri:$addr),
                         "# ST64_A_FI $src, $addr", []>;

  def ST64_ACC_FI : Pseudo<(outs),
                           (ins ACCPair:$src, MEMri:$addr),
                           "# ST64_ACC_FI $src, $addr", []>;

  // ST32
  def ST32_FI : Pseudo<(outs),
                       (ins MR:$src, MEMri:$addr),
                       "# ST32_FI $src, $addr", []>;

  def ST32_A_FI : Pseudo<(outs),
                         (ins AR:$src, MEMri:$addr),
                         "# ST32_A_FI $src, $addr", []>;

  def ST32_ACC_FI : Pseudo<(outs),
                           (ins ACC:$src, MEMri:$addr),
                           "# ST32_ACC_FI $src, $addr", []>;
}

//===----------------------------------------------------------------------===//
// Control instructions
//===----------------------------------------------------------------------===//

def CALL : inst_call_mmmn_zi { 
  let isCall = 1;
  let Defs = [LR];
}

// rtn must be followed by a RTN_REG_HOLDER. It must be marked as a
// terminator so that it is considered part of a return sequence and callee
// spills can be restored correctly.
def RTN : inst_br_mmmn {
  let isReturn = 1;
  let isTerminator = 1;
  let isBarrier = 1;
}

// Variant of RTN to use for indirect branch.
def BRIND : inst_br_mmmn {
  let Pattern = [(brind MR:$op0)];
  let isCodeGenOnly = 1;
  let isTerminator = 1;
  let isBranch = 1;
  let isBarrier = 1;
  let isIndirectBranch = 1;
}

// Variant of BR only used for for indirect call_mmmn_zi.
def CALLIND : Pseudo<(outs), (ins MR:$op0, CoissueFlag:$coissue), "br_mmmn $op0", []>,
    PseudoInstExpansion<(RTN MR:$op0, CoissueFlag:$coissue)> {
  let isCall = 1;
  let isBarrier = 1;
}

let isBranch = 1, isTerminator = 1 in {
  // br_mmmn*
  def BR : inst_bri_mmmn_zi {
    let Pattern = [(br bb:$op0)];
    let isBarrier = 1;
  }
  def BRNEG : inst_brneg_mmmn_zi {
    let Pattern = [(brcond (i32 (setlt i32MR:$op0, (i32 0))), bb:$op1)];
  }
  def BRPOS : inst_brpos_mmmn_zi {
    let Pattern = [(brcond (i32 (setlt (i32 -1), i32MR:$op0)), bb:$op1)];
  }
  def BRNZ : inst_brnz_mmmn_zi {
    let Pattern = [(brcond (i32 (setne i32MR:$op0, (i32 0))), bb:$op1)];
  }
  def BRZ : inst_brz_mmmn_zi {
    let Pattern = [(brcond (i32 (seteq i32MR:$op0, 0)), bb:$op1)];
  }

  // TODO: Pattern
  def BRNZDEC: inst_brnzdec_mmmn_zi;

}

//===----------------------------------------------------------------------===//
// Memory-access instructions.
//===----------------------------------------------------------------------===//

let hasSideEffects = 0 in {
  def LDST64PACE : inst_ldst64pace_mbbn_ef;
  def LD2XST64PACE : inst_ld2xst64pace_mbbn_ef;
}

// Loads.
let hasSideEffects = 0 in {
  def LDD16A64    : inst_ldd16a64_mmbn;
  def LD64A32PACE : inst_ld64a32pace_mmbn_ef;
  def LD64B16PACE : inst_ld64b16pace_mmbn_ef;

  def LD128STEP    : inst_ld128step_mmbn;
  def LD128STEP_SI : inst_ld128step_mmbn_si;

  // ld64step_mmbn
  def LD64STEP_A    : inst_ld64step_mmbn;
  def LD64STEP_SI_A : inst_ld64step_mmbn_si;

  // ld32step_mmmn
  def LD32STEP      : inst_ld32step_mmmn;
  def LD32STEP_SI   : inst_ld32step_mmmn_si;
  def LD32STEP_A    : inst_ld32step_mmbn;
  def LD32STEP_SI_A : inst_ld32step_mmbn_si;

  // ldstep16s
  def LDS16STEP     : inst_lds16step_mmmn;
  def LDS16STEP_SI : inst_lds16step_mmmn_si;

  // ldz16step_mmmn
  def LDZ16STEP      : inst_ldz16step_mmmn;
  def LDZ16STEP_SI   : inst_ldz16step_mmmn_si;

  // lds8step_mmmn
  def LDS8STEP    : inst_lds8step_mmmn;
  def LDS8STEP_SI : inst_lds8step_mmmn_si;

  // ldz8step_mmmn
  def LDZ8STEP    : inst_ldz8step_mmmn;
  def LDZ8STEP_SI : inst_ldz8step_mmmn_si;

  // Multi-access loads.
  def LD2X64PACE   : inst_ld2x64pace_mmbn_ef;
  def LDD16B16     : inst_ldd16b16_mmbn;
  def LDD16A32     : inst_ldd16a32_mmbn;
  def LDD16V2A32   : inst_ldd16v2a32_mmbn;
  def LD64A32      : inst_ld64a32_mmbn;
  def LDB16B16     : inst_ldb16b16_mmbn;

#ifdef IPU21PLUS
  def LDB8STEP    : inst_ldb8step_mmbn;
  def LDB8STEP_SI : inst_ldb8step_mmbn_si;
#endif

  def LDB16STEP    : inst_ldb16step_mmbn;
  def LDB16STEP_SI : inst_ldb16step_mmbn_si;

  // Load and put_mmmn_zi instructions
  def LD64PUTCS    : inst_ld64putcs_mmmn_zi;
  def LD128PUTCS   : inst_ld128putcs_mmmn_zi;
}

// Stores.
let hasSideEffects = 0 in {
  def ST64PACE : inst_st64pace_mbmn_ef;

  // st32_mmmn
  def STM32 : inst_stm32_mmmn, FM3X2 {
    // No delta-offset operand.
    let op0 = addr{3-0};
    let op1 = addr{7-4};
    let AsmString = "stm32 $op2, $addr";
    dag InOperandList = (ins MR:$op2, MEMrr:$addr,
                         CoissueFlag:$coissue);
  }

  def ST32_ZI : inst_st32_mmmn_zi, FM3I3 {
  let op0 = addr{3-0};
  let op1 = addr{7-4};
  let op2 = addr{19-8};
  let AsmString = "st32 $op3, $addr";
  let mayStore = 1;
  dag InOperandList = (ins MR:$op3, MEMrri:$addr, CoissueFlag:$coissue);
}

  // st64step_mbmn
  def ST64STEP_A    : inst_st64step_mbmn;
  def ST64STEP_SI_A : inst_st64step_mbmn_si;

  // st32step_mbmn
  def ST32STEP_SI   : inst_st32step_mmmn_si;
  def ST32STEP_A    : inst_st32step_mbmn;
  def ST32STEP_SI_A : inst_st32step_mbmn_si;

  def STM32STEP : inst_stm32step_mmmn;
}

//===----------------------------------------------------------------------===//
// Integer instructions.
//===----------------------------------------------------------------------===//

// abs_mmmn Note: ABS is not lowered to the ABS instruction because it is against the semantic of ISD::ABS (T28307)
def ABS : inst_abs_mmmn;

// add
def ADD : inst_add_mmmn {
  let Pattern = [(set i32MR:$op0, (add i32MR:$op1, i32MR:$op2))];
}
def ADD_ZI : inst_add_mmmn_zi {
  let Pattern = [(set i32MR:$op0, (add i32MR:$op1, imm16zi:$op2))];
}
def ADD_SI : inst_add_mmmn_si {
  let Pattern = [(set i32MR:$op0, (add i32MR:$op1, imm16si:$op2))];
}

// and
def AND : inst_and_mmmn {
  let Pattern = [(set i32MR:$op0, (and i32MR:$op1, i32MR:$op2))];
}

def AND_A : inst_and_aaan;
def AND_IZ_A : inst_and_aaan_iz;

def AND_ZI : inst_and_mmmn_zi {
  let Pattern = [(set i32MR:$op0, (and i32MR:$op1, imm12zi:$op2))];
}

def AND_ZI_A : inst_and_aaan_zi;

def ANDC : inst_andc_mmmn {
  let Pattern = [(set i32MR:$op0, (and i32MR:$op1, (not i32MR:$op2)))];
}

def AND64 : inst_and64_aaan;
def ANDC64 : inst_andc64_aaan;

def ANDC_ZI : inst_andc_mmmn_zi {
  let Pattern = [(set i32MR:$op0, (and i32MR:$op1, (not imm16zi:$op2)))];
}

def ANDC_IZ_A : inst_andc_aaan_iz;
def ANDC_A : inst_andc_aaan;
def ANDC_ZI_A : inst_andc_aaan_zi;
def ATOM : inst_atom_mamn;

def CLZ : inst_clz_mmmn {
  let Pattern = [(set i32MR:$op0, (ctlz i32MR:$op1))];
}

// cmp*
// Patterns matching set{eq, ne, lt, ult}.
let isCompare = 1 in {
  def CMPEQ : inst_cmpeq_mmmn {
    let Pattern = [(set i32MR:$op0, (i32 (seteq i32MR:$op1, i32MR:$op2)))];
  }
  def CMPEQ_ZI : inst_cmpeq_mmmn_zi {
    let Pattern = [(set i32MR:$op0, (i32 (seteq i32MR:$op1, imm16zi:$op2)))];
  }
  def CMPEQ_SI : inst_cmpeq_mmmn_si {
    let Pattern = [(set i32MR:$op0, (i32 (seteq i32MR:$op1, imm16si:$op2)))];
  }
  def CMPNE : inst_cmpne_mmmn {
    let Pattern = [(set i32MR:$op0, (i32 (setne i32MR:$op1, i32MR:$op2)))];
  }
  def CMPSLT : inst_cmpslt_mmmn {
    let Pattern = [(set i32MR:$op0, (i32 (setlt i32MR:$op1, i32MR:$op2)))];
  }
  def CMPSLT_SI: inst_cmpslt_mmmn_si {
    let Pattern = [(set i32MR:$op0, (i32 (setlt i32MR:$op1, imm16si:$op2)))];
  }
  def CMPULT : inst_cmpult_mmmn {
    let Pattern = [(set i32MR:$op0, (i32 (setult i32MR:$op1, i32MR:$op2)))];
  }
  def CMPULT_ZI : inst_cmpult_mmmn_zi {
    let Pattern = [(set i32MR:$op0, (i32 (setult i32MR:$op1, imm16zi:$op2)))];
  }
}

// Macros wrapping the I32 comparisons
def CMPI32EQ : OutPatFrag<(ops node:$lhs, node:$rhs),
                          (i32 (CMPEQ node:$lhs, node:$rhs))>;
def CMPI32NE : OutPatFrag<(ops node:$lhs, node:$rhs),
                          (i32 (CMPNE node:$lhs, node:$rhs))>;
def CMPI32SLT : OutPatFrag<(ops node:$lhs, node:$rhs),
                           (i32 (CMPSLT node:$lhs, node:$rhs))>;
def CMPI32ULT : OutPatFrag<(ops node:$lhs, node:$rhs),
                           (i32 (CMPULT node:$lhs, node:$rhs))>;
def CMPI32SGT : OutPatFrag<(ops node:$lhs, node:$rhs),
                           (i32 (CMPSLT node:$rhs, node:$lhs))>;
def CMPI32UGT : OutPatFrag<(ops node:$lhs, node:$rhs),
                           (i32 (CMPULT node:$rhs, node:$lhs))>;
def CMPI32SLE : OutPatFrag<(ops node:$lhs, node:$rhs),
                           (i32 (CMPEQ_ZI (CMPSLT node:$rhs, node:$lhs), 0))>;
def CMPI32ULE : OutPatFrag<(ops node:$lhs, node:$rhs),
                           (i32 (CMPEQ_ZI (CMPULT node:$rhs, node:$lhs), 0))>;
def CMPI32SGE : OutPatFrag<(ops node:$lhs, node:$rhs),
                           (i32 (CMPEQ_ZI (CMPSLT node:$lhs, node:$rhs), 0))>;
def CMPI32UGE : OutPatFrag<(ops node:$lhs, node:$rhs),
                           (i32 (CMPEQ_ZI (CMPULT node:$lhs, node:$rhs), 0))>;

// exit*
let isReturn = 1, isTerminator = 1, isBarrier = 1, Predicates = [IsWorker, IsIpu1And2] in {
  def EXITNZ : inst_exitnz_mmmn {
    let Pattern = [(ColossusVertexExit i32MR:$op0)];
  }
  def EXITNEG : inst_exitneg_mmmn {
    let Pattern = [(ColossusVertexExit (i32 (srl i32MR:$op0, (i32 31))))];
  }
  def EXITPOS : inst_exitpos_mmmn {
    let Pattern = [(ColossusVertexExit (i32 (setlt (i32 -1), i32MR:$op0)))];
  }
  def EXITZ : inst_exitz_mmmn {
    let Pattern = [(ColossusVertexExit (i32 (seteq i32MR:$op0, (i32 0))))];
  }
}

let Predicates = [IsIpu1And2] in {
  def : Pat<(ColossusVertexExit (i32 (setne i32MR:$op0, (i32 0)))),
            (EXITNZ i32MR:$op0)>;
}

def NonZeroImm: PatLeaf<(imm), [{
    return N->getZExtValue() != 0u;
}]>;

def : Pat<(ColossusVertexExit (i32 NonZeroImm)),
          (EXITZ (COPY (i32 MZERO)))>;


// max_mmmn
def MAX : inst_max_mmmn {
  let Pattern = [(set i32MR:$op0, (smax i32MR:$op1, i32MR:$op2))];
}

def MAX_ZI : inst_max_mmmn_zi {
  let Pattern = [(set i32MR:$op0, (smax i32MR:$op1, imm16zi:$op2))];
}

def MAX_SI : inst_max_mmmn_si {
  let Pattern = [(set i32MR:$op0, (smax i32MR:$op1, imm16si:$op2))];
}

// min_mmmn
def MIN : inst_min_mmmn {
  let Pattern = [(set i32MR:$op0, (smin i32MR:$op1, i32MR:$op2))];
}

def MIN_ZI : inst_min_mmmn_zi {
  let Pattern = [(set i32MR:$op0, (smin i32MR:$op1, imm16zi:$op2))];
}

def MIN_SI : inst_min_mmmn_si {
  let Pattern = [(set i32MR:$op0, (smin i32MR:$op1, imm16si:$op2))];
}

def MOVZ : inst_movz_mmmn {
  let isSelect = 1;
  let isReMaterializable = 1;
}

// mul
def MUL : inst_mul_mmmn {
  let Pattern = [(set i32MR:$op0, (mul i32MR:$op1, i32MR:$op2))];
}

def MUL_SI : inst_mul_mmmn_si {
  let Pattern = [(set i32MR:$op0, (mul i32MR:$op1, imm16si:$op2))];
}

// or
def OR : inst_or_mmmn {
  let Pattern = [(set i32MR:$op0, (or i32MR:$op1, i32MR:$op2))];
}
def OR_IZ : inst_or_mmmn_iz {
  let Pattern = [(set i32MR:$op0, (or i32MR:$op1, imm12iz:$op2))];
}
def OR_ZI : inst_or_mmmn_zi {
  let Pattern = [(set i32MR:$op0, (or i32MR:$op1, imm12zi:$op2))];
}

let hasSideEffects = 0 in {
  def OR_A : inst_or_aaan;
  def OR_IZ_A : inst_or_aaan_iz;
  def OR_ZI_A : inst_or_aaan_zi;
}

def POPC : inst_popc_mmmn {
  let Pattern = [(set i32MR:$op0, (ctpop i32MR:$op1))];
}

def ROLL32 : inst_roll32_aaan;
def ROLL16 : inst_roll16_mmmn;
def ROLL8L : inst_roll8l_mmmn;
def ROLL8R : inst_roll8r_mmmn;
def ROLL16_A : inst_roll16_aaan;

def RPT_ZI : inst_rpt_mmmn_zi_zi;
def RPT : inst_rpt_mmmn_zi;

def SETZI : inst_setzi_mmmn_zi {
  let Pattern = [(set i32MR:$op0, (imm20zi:$op1))];
}

def SETZI_A : inst_setzi_aaan_zi {
  let hasSideEffects = 0;
}

// shl
def SHL : inst_shl_mmmn {
  let Pattern = [(set i32MR:$op0, (shl i32MR:$op1, i32MR:$op2))];
}
def SHL_ZI : inst_shl_mmmn_zi {
  let Pattern = [(set i32MR:$op0, (shl i32MR:$op1, imm12zi:$op2))];
}

// shr_mmmn
def SHR : inst_shr_mmmn {
  let Pattern = [(set i32MR:$op0, (srl i32MR:$op1, i32MR:$op2))];
}
def SHR_ZI : inst_shr_mmmn_zi {
  let Pattern = [(set i32MR:$op0, (srl i32MR:$op1, imm12zi:$op2))];
}

// shrs_mmmn
def SHRS : inst_shrs_mmmn {
  let Pattern = [(set i32MR:$op0, (sra i32MR:$op1, i32MR:$op2))];
}
def SHRS_ZI : inst_shrs_mmmn_zi {
  let Pattern = [(set i32MR:$op0, (sra i32MR:$op1, imm12zi:$op2))];
}

def SHUF8X8HI : inst_shuf8x8hi_mmmn;
def SHUF8X8LO : inst_shuf8x8lo_mmmn;
def SORT4X16HI : inst_sort4x16hi_mmmn;
def SORT4X16LO : inst_sort4x16lo_mmmn;
def SORT8 : inst_sort8_mmmn;
def SORT8X8HI : inst_sort8x8hi_mmmn;
def SORT8X8LO : inst_sort8x8lo_mmmn;
def SORT4X16HI_A : inst_sort4x16hi_aaan;
def SORT4X16LO_A : inst_sort4x16lo_aaan;
def SORT4X32HI : inst_sort4x32hi_aaan;
def SORT4X32LO : inst_sort4x32lo_aaan;

// sub
def SUB : inst_sub_mmmn {
  let Pattern = [(set i32MR:$op0, (sub i32MR:$op2, i32MR:$op1))];
}
def SUB_ZI : inst_sub_mmmn_zi {
  let Pattern = [(set i32MR:$op0, (sub imm16zi:$op2, i32MR:$op1))];
}
def SUB_SI : inst_sub_mmmn_si {
  let Pattern = [(set i32MR:$op0, (sub imm16si:$op2, i32MR:$op1))];
}

def SWAP8 : inst_swap8_mmmn;

def TRAP : inst_trap_mmmn_zi;

def XNOR : inst_xnor_mmmn {
  let Pattern = [(set i32MR:$op0, (not (xor i32MR:$op1, i32MR:$op2)))];
}

def XOR : inst_xor_mmmn {
  let Pattern = [(set i32MR:$op0, (xor i32MR:$op1, i32MR:$op2))];
}

def TAPACK : inst_tapack_mmmn;

// Bitwise andc_mmmn
def i32_not_xform : SDNodeXForm<imm, [{
      // Transformation function: ~imm
      assert(N->getZExtValue() <= UINT32_MAX && "i64 should not reach here");
      uint32_t value = N->getZExtValue();
      return getI32Imm(~value, SDLoc(N));
      }]>;

def Imm12Not : PatLeaf<(imm), [{
    uint32_t value = N->getZExtValue();
    return isUInt<12>(~value);
    }]>;

def Imm20Not : PatLeaf<(imm), [{
    uint32_t value = N->getZExtValue();
    return isUInt<20>(~value);
    }]>;

def : Pat<(and i32MR:$op0, Imm12Not:$op1),
          (ANDC_ZI i32MR:$op0, (i32_not_xform Imm12Not:$op1))>;

def : Pat<(and i32MR:$op0, Imm20Not:$op1),
          (ANDC i32MR:$op0, (SETZI (i32_not_xform Imm20Not:$op1)))>;

// Bitwise floating point ops
class BitwiseFP_t
{
  EncodedI and;
  EncodedI or;
  EncodedI not;
  EncodedI andc;
  PatLeaf src;
  ValueType dst;
}

multiclass BitwiseFP<BitwiseFP_t Op> {
    def : Pat<(Op.dst (ColossusFNOT Op.src:$op)),
              (Op.dst (Op.not Op.src:$op))>;
    def : Pat<(Op.dst (ColossusFAND Op.src:$op0, Op.src:$op1)),
              (Op.dst (Op.and Op.src:$op0, Op.src:$op1))>;
    def : Pat<(Op.dst (ColossusFOR Op.src:$op0, Op.src:$op1)),
              (Op.dst (Op.or Op.src:$op0, Op.src:$op1))>;
    def : Pat<(Op.dst (ColossusANDC Op.src:$op0, Op.src:$op1)),
              (Op.dst (Op.andc Op.src:$op0, Op.src:$op1))>;
}

def BitwiseFP_F16 : BitwiseFP_t
{
  EncodedI and = AND_A;
  EncodedI or = OR_A;
  EncodedI not = NOT;
  EncodedI andc = ANDC_A;
  PatLeaf src = f16AR;
  ValueType dst = f16;
}
defm : BitwiseFP<BitwiseFP_F16>;

def BitwiseFP_F32 : BitwiseFP_t
{
  EncodedI and = AND_A;
  EncodedI or = OR_A;
  EncodedI not = NOT;
  EncodedI andc = ANDC_A;
  PatLeaf src = f32AR;
  ValueType dst = f32;
}
defm : BitwiseFP<BitwiseFP_F32>;

def BitwiseFP_V2F16 : BitwiseFP_t
{
  EncodedI and = AND_A;
  EncodedI or = OR_A;
  EncodedI not = NOT;
  EncodedI andc = ANDC_A;
  PatLeaf src = v2f16AR;
  ValueType dst = v2f16;
}
defm : BitwiseFP<BitwiseFP_V2F16>;

def BitwiseFP_V2F32 : BitwiseFP_t
{
  EncodedI and = AND64;
  EncodedI or = OR64;
  EncodedI not = NOT64;
  EncodedI andc = ANDC64;
  PatLeaf src = v2f32AR;
  ValueType dst = v2f32;
}
defm : BitwiseFP<BitwiseFP_V2F32>;

def BitwiseFP_V4F16 : BitwiseFP_t
{
  EncodedI and = AND64;
  EncodedI or = OR64;
  EncodedI not = NOT64;
  EncodedI andc = ANDC64;
  PatLeaf src = v4f16AR;
  ValueType dst = v4f16;
}
defm : BitwiseFP<BitwiseFP_V4F16>;

// float immediate operand patterns

def fp32imm12zi : FP32ImmZIOperand<12, ImmAsmOperand<"12zi">>;
def fp32imm12iz : FP32ImmIZOperand<12, ImmAsmOperand<"12iz">>;
def f32imm_to_target_imm : SDNodeXForm<fpimm, [{
  // Translate the fp immediate to an integer for the instruction
  auto Imm = N->getValueAPF();
  uint64_t value = Imm.bitcastToAPInt().getZExtValue();
  assert(value <= UINT32_MAX);
  return getI32Imm(value, SDLoc(N));
}]>;

multiclass BitwiseF32Imm<SDNode Op, EncodedI OP_ZI, EncodedI OP_IZ>
{
  def : Pat<(f32 (Op f32AR:$op0, fp32imm12zi:$op1)),
            (f32 (OP_ZI f32AR:$op0, (f32imm_to_target_imm fp32imm12zi:$op1)))>;
  def : Pat<(f32 (Op f32AR:$op0, fp32imm12iz:$op1)),
            (f32 (OP_IZ f32AR:$op0, (f32imm_to_target_imm fp32imm12iz:$op1)))>;
}

defm : BitwiseF32Imm<ColossusFAND, AND_ZI_A, AND_IZ_A>;
defm : BitwiseF32Imm<ColossusFOR, OR_ZI_A, OR_IZ_A>;
defm : BitwiseF32Imm<ColossusANDC, ANDC_ZI_A, ANDC_IZ_A>;

//===----------------------------------------------------------------------===//
// Vector helper macros
//===----------------------------------------------------------------------===//

// Word width vector operations can be untyped. This is especially useful for
// manipulating v4i16 and v4f16 in 32 bit blocks
def build_pair_word :
  OutPatFrag<(ops node:$lo, node:$hi),
             (INSERT_SUBREG
                (INSERT_SUBREG (IMPLICIT_DEF), node:$lo, SubRegLo),
            node:$hi, SubRegHi)>;

def extract_pair_word_low :
      OutPatFrag<(ops node:$src),
                 (EXTRACT_SUBREG node:$src, SubRegLo)>;
def extract_pair_word_high :
      OutPatFrag<(ops node:$src),
                 (EXTRACT_SUBREG node:$src, SubRegHi)>;

def insert_pair_word_low :
      OutPatFrag<(ops node:$src, node:$val),
                 (INSERT_SUBREG node:$src, node:$val, SubRegLo)>;
def insert_pair_word_high :
      OutPatFrag<(ops node:$src, node:$val),
                 (INSERT_SUBREG node:$src, node:$val, SubRegHi)>;

// The typed versions help the inference engine so reduce boilerplate later on
def build_v2i32 : OutPatFrag<(ops node:$lo, node:$hi),
                                 (v2i32 (build_pair_word node:$lo, node:$hi))>;

def build_v2f32 : OutPatFrag<(ops node:$lo, node:$hi),
                                 (v2f32 (build_pair_word node:$lo, node:$hi))>;

multiclass extract_pair_word<ValueType Ty> {
  def _0 : OutPatFrag<(ops node:$src),
                      (Ty (extract_pair_word_low node:$src))>;
  def _1 : OutPatFrag<(ops node:$src),
                      (Ty (extract_pair_word_high node:$src))>;
}
defm extract_v2i32 : extract_pair_word<i32>;
defm extract_v2f32 : extract_pair_word<f32>;

multiclass insert_pair_word<ValueType Ty> {
  def _0 : OutPatFrag<(ops node:$src, node:$val),
                      (Ty (insert_pair_word_low node:$src, node:$val))>;
  def _1 : OutPatFrag<(ops node:$src, node:$val),
                      (Ty (insert_pair_word_high node:$src, node:$val))>;
}
defm insert_v2i32 : insert_pair_word<v2i32>;
defm insert_v2f32 : insert_pair_word<v2f32>;

//===----------------------------------------------------------------------===//
// f32 instructions.
//===----------------------------------------------------------------------===//

// fadd
def F32ADD : inst_f32add_aaan {
  let Pattern = [(set f32AR:$op0, (any_fadd f32AR:$op1, f32AR:$op2))];
}

// fsub
def F32SUB : inst_f32sub_aaan {
  let Pattern = [(set f32AR:$op0, (any_fsub f32AR:$op1, f32AR:$op2))];
}

// fdiv
def F32DIV : inst_f32div_aaan {
  let Pattern = [(set f32AR:$op0, (any_fdiv f32AR:$op1, f32AR:$op2))];
}

// fmul
def F32MUL : inst_f32mul_aaan {
  let Pattern = [(set f32AR:$op0, (any_fmul f32AR:$op1, f32AR:$op2))];
}

// fcmp*
let isCompare = 1 in {
  def F32CMPEQ : inst_f32cmpeq_aaan;
  def F32CMPGE : inst_f32cmpge_aaan;
  def F32CMPGT : inst_f32cmpgt_aaan;
  def F32CMPLE : inst_f32cmple_aaan;
  def F32CMPLT : inst_f32cmplt_aaan;
  def F32CMPNE : inst_f32cmpne_aaan;
}

def F32EXP : inst_f32exp_aaan {
  let Pattern = [(set f32AR:$op0, (any_fexp f32AR:$op1))];
}

def F32EXP2 : inst_f32exp2_aaan {
  let Pattern = [(set f32AR:$op0, (any_fexp2 f32AR:$op1))];
}

def F32MAX : inst_f32max_aaan {
  let Pattern = [(set f32AR:$op0, (any_fmaxnum f32AR:$op1, f32AR:$op2))];
}

def F32MIN : inst_f32min_aaan {
  let Pattern = [(set f32AR:$op0, (any_fminnum f32AR:$op1, f32AR:$op2))];
}

def F32LOG2 : inst_f32log2_aaan {
  let Pattern = [(set f32AR:$op0, (any_flog2 f32AR:$op1))];
}

def F32LN : inst_f32ln_aaan {
  let Pattern = [(set f32AR:$op0, (any_flog f32AR:$op1))];
}

def F32SIGMOID : inst_f32sigm_aaan {
  let Pattern = [(set f32AR:$op0, (ColossusFSIGMOID f32AR:$op1))];
}

def F32SQRT : inst_f32sqrt_aaan {
  let Pattern = [(set f32AR:$op0, (any_fsqrt f32AR:$op1))];
}

def F32OORX : inst_f32oorx_aaan {
  let Pattern = [(set f32AR:$op0, (any_ColossusFRSQRT f32AR:$op1))];
}

def F32TANH : inst_f32tanh_aaan {
  let Pattern = [(set f32AR:$op0, (ColossusFTANH f32AR:$op1))];
}

//===----------------------------------------------------------------------===//
// f16 conversions.
//===----------------------------------------------------------------------===//

// fround f32 -> f16
def F32TOF16 : inst_f32tof16_aaan {
  let Pattern = [(set f16AR:$op0, (any_fpround f32AR:$op1))];
}

// fpextend f16 -> f32
def F16TOF32 : inst_f16tof32_aaan {
  let Pattern = [(set f32AR:$op0, (any_fpextend f16AR:$op1))];
}

// fp_to_f16 and f16_to_fp are typed as float to int conversions.
def strict_fp_to_f16  : SDNode<"ISD::STRICT_FP_TO_FP16" , SDTFPToIntOp, [SDNPHasChain]>;
def strict_f16_to_fp  : SDNode<"ISD::STRICT_FP16_TO_FP" , SDTIntToFPOp, [SDNPHasChain]>;
def any_fp_to_f16     : PatFrags<(ops node:$src),
                                 [(strict_fp_to_f16 node:$src),
                                  (fp_to_f16 node:$src)]>;
def any_f16_to_fp     : PatFrags<(ops node:$src),
                                 [(strict_f16_to_fp node:$src),
                                  (f16_to_fp node:$src)]>;

// fp_to_f16
def f32_to_f16 : OutPatFrag<(ops node:$src), (f16 (F32TOF16 node:$src))>;
def : Pat<(i32 (any_fp_to_f16 f32AR:$src)),
          (i32 (COPY_TO_REGCLASS (f32_to_f16 f32AR:$src), MR))>;

// f16_to_fp
def f16_to_f32 : OutPatFrag<(ops node:$src), (f32 (F16TOF32 node:$src))>;
def : Pat<(f32 (any_f16_to_fp i32MR:$src)),
          (f32 (f16_to_f32 (COPY_TO_REGCLASS i32MR:$src, AR)))>;


//===----------------------------------------------------------------------===//
// f32v2 instructions.
//===----------------------------------------------------------------------===//

// The separate pattern clause leads to a pattern match clause in GenDAGISel.inc
// If omitted, i.e. 'def F32V2ADD : inst_f32v2add_aaan;', no pattern is recorded
// This means that none of the F323V2 operations listed below are active yet

def F32V2AOP : inst_f32v2aop_aaan_ef;
def F32V2GINA : inst_f32v2gina_aaan_zi;
def F32V2GRAND : inst_f32v2grand_aaan;
def F32V2CLAMP : inst_f32v2clamp_aaan;
def F32V2RMASK : inst_f32v2rmask_aaan;
def F32V2AXPY : inst_f32v2axpy_aaan;
def F32V2MAC : inst_f32v2mac_aaan;
def F32V2ABSADD : inst_f32v2absadd_aaan;
def F32V2ABSMAX : inst_f32v2absmax_aaan;
def F32V2SUFROMUI : inst_f32v2sufromui_aaan;
let isCompare = 1 in {
  def F32V2CMPEQ : inst_f32v2cmpeq_aaan;
  def F32V2CMPGE : inst_f32v2cmpge_aaan;
  def F32V2CMPGT : inst_f32v2cmpgt_aaan;
  def F32V2CMPLE : inst_f32v2cmple_aaan;
  def F32V2CMPLT : inst_f32v2cmplt_aaan;
  def F32V2CMPNE : inst_f32v2cmpne_aaan;
}

def F32V2ADD : inst_f32v2add_aaan {
  let Pattern = [(set v2f32AR:$op0, (any_fadd v2f32AR:$op1, v2f32AR:$op2))];
}

def F32V2SUB : inst_f32v2sub_aaan {
  let Pattern = [(set v2f32AR:$op0, (any_fsub v2f32AR:$op1, v2f32AR:$op2))];
}

def F32V2MUL : inst_f32v2mul_aaan {
  let Pattern = [(set v2f32AR:$op0, (any_fmul v2f32AR:$op1, v2f32AR:$op2))];
}

def F32V2MAX : inst_f32v2max_aaan {
  let Pattern = [(set v2f32AR:$op0, (any_fmaxnum v2f32AR:$op1, v2f32AR:$op2))];
}

def F32V2MIN : inst_f32v2min_aaan {
  let Pattern = [(set v2f32AR:$op0, (any_fminnum v2f32AR:$op1, v2f32AR:$op2))];
}

def F32V2TOF16 : inst_f32v2tof16_aaan {
  let Pattern = [(set v2f16AR:$op0, (any_fpround v2f32AR:$op1))];
}

//===----------------------------------------------------------------------===//
// f16v2 instructions.
//===----------------------------------------------------------------------===//

def F16V2ADD : inst_f16v2add_aaan {
  let Pattern = [(set v2f16AR:$op0, (any_fadd v2f16AR:$op1, v2f16AR:$op2))];
}

def F16V2SUB : inst_f16v2sub_aaan {
  let Pattern = [(set v2f16AR:$op0, (any_fsub v2f16AR:$op1, v2f16AR:$op2))];
}

def F16V2MUL : inst_f16v2mul_aaan {
  let Pattern = [(set v2f16AR:$op0, (any_fmul v2f16AR:$op1, v2f16AR:$op2))];
}

def F16V2EXP : inst_f16v2exp_aaan {
  let Pattern = [(set v2f16AR:$op0, (any_fexp v2f16AR:$op1))];
}

def F16V2LN : inst_f16v2ln_aaan {
  let Pattern = [(set v2f16AR:$op0, (any_flog v2f16AR:$op1))];
}

def F16V2EXP2 : inst_f16v2exp2_aaan {
  let Pattern = [(set v2f16AR:$op0, (any_fexp2 v2f16AR:$op1))];
}

def F16V2LOG2 : inst_f16v2log2_aaan {
  let Pattern = [(set v2f16AR:$op0, (any_flog2 v2f16AR:$op1))];
}

def F16V2MAX : inst_f16v2max_aaan {
  let Pattern = [(set v2f16AR:$op0, (any_fmaxnum v2f16AR:$op1, v2f16AR:$op2))];
}

def F16V2MIN : inst_f16v2min_aaan {
  let Pattern = [(set v2f16AR:$op0, (any_fminnum v2f16AR:$op1, v2f16AR:$op2))];
}

def F16V2TOF32 : inst_f16v2tof32_aaan {
  let Pattern = [(set v2f32AR:$op0, (any_fpextend v2f16AR:$op1))];
}

def F16V2TANH : inst_f16v2tanh_aaan {
  let Pattern = [(set v2f16AR:$op0, (ColossusFTANH v2f16AR:$op1))];
}

def F16V2SIGMOID : inst_f16v2sigm_aaan {
  let Pattern = [(set v2f16AR:$op0, (ColossusFSIGMOID v2f16AR:$op1))];
}

let isCompare = 1 in {
    def F16V2CMPEQ : inst_f16v2cmpeq_aaan;
    def F16V2CMPGE : inst_f16v2cmpge_aaan;
    def F16V2CMPGT : inst_f16v2cmpgt_aaan;
    def F16V2CMPLE : inst_f16v2cmple_aaan;
    def F16V2CMPLT : inst_f16v2cmplt_aaan;
    def F16V2CMPNE : inst_f16v2cmpne_aaan;
}

//===----------------------------------------------------------------------===//
// Broadcast instruction variants.
//===----------------------------------------------------------------------===//
def F16V2ADD_BU : inst_f16v2add_aaau;
def F16V2CMPEQ_BU : inst_f16v2cmpeq_aaau;
def F16V2CMPGE_BU : inst_f16v2cmpge_aaau;
def F16V2CMPGT_BU : inst_f16v2cmpgt_aaau;
def F16V2CMPLE_BU : inst_f16v2cmple_aaau;
def F16V2CMPLT_BU : inst_f16v2cmplt_aaau;
def F16V2CMPNE_BU : inst_f16v2cmpne_aaau;
def F16V2MUL_BU : inst_f16v2mul_aaau;
def F16V2SUB_BU : inst_f16v2sub_aaau;
def F16V4ADD_BU : inst_f16v4add_aaau;
def F16V4CMPEQ_BU : inst_f16v4cmpeq_aaau;
def F16V4CMPGE_BU : inst_f16v4cmpge_aaau;
def F16V4CMPGT_BU : inst_f16v4cmpgt_aaau;
def F16V4CMPLE_BU : inst_f16v4cmple_aaau;
def F16V4CMPLT_BU : inst_f16v4cmplt_aaau;
def F16V4CMPNE_BU : inst_f16v4cmpne_aaau;
def F16V4MUL_BU : inst_f16v4mul_aaau;
def F16V4SUB_BU : inst_f16v4sub_aaau;
def SORT4X16LO_BU : inst_sort4x16lo_aaau;
def F16V2ADD_BL : inst_f16v2add_aaal;
def F16V2CMPEQ_BL : inst_f16v2cmpeq_aaal;
def F16V2CMPGE_BL : inst_f16v2cmpge_aaal;
def F16V2CMPGT_BL : inst_f16v2cmpgt_aaal;
def F16V2CMPLE_BL : inst_f16v2cmple_aaal;
def F16V2CMPLT_BL : inst_f16v2cmplt_aaal;
def F16V2CMPNE_BL : inst_f16v2cmpne_aaal;
def F16V2MUL_BL : inst_f16v2mul_aaal;
def F16V2SUB_BL : inst_f16v2sub_aaal;
def F16V4ADD_BL : inst_f16v4add_aaal;
def F16V4CMPEQ_BL : inst_f16v4cmpeq_aaal;
def F16V4CMPGE_BL : inst_f16v4cmpge_aaal;
def F16V4CMPGT_BL : inst_f16v4cmpgt_aaal;
def F16V4CMPLE_BL : inst_f16v4cmple_aaal;
def F16V4CMPLT_BL : inst_f16v4cmplt_aaal;
def F16V4CMPNE_BL : inst_f16v4cmpne_aaal;
def F16V4MUL_BL : inst_f16v4mul_aaal;
def F16V4SUB_BL : inst_f16v4sub_aaal;
def F32V2ADD_BL : inst_f32v2add_aaat;
def F32V2CMPEQ_BL : inst_f32v2cmpeq_aaat;
def F32V2CMPGE_BL : inst_f32v2cmpge_aaat;
def F32V2CMPGT_BL : inst_f32v2cmpgt_aaat;
def F32V2CMPLE_BL : inst_f32v2cmple_aaat;
def F32V2CMPLT_BL : inst_f32v2cmplt_aaat;
def F32V2CMPNE_BL : inst_f32v2cmpne_aaat;
def F32V2MUL_BL : inst_f32v2mul_aaat;
def F32V2SUB_BL : inst_f32v2sub_aaat;

//===----------------------------------------------------------------------===//
// f16v4 instructions.
//===----------------------------------------------------------------------===//

def F16V4CLASS : inst_f16v4class_aaan;
def F16V4ABSACC : inst_f16v4absacc_aaan;
def F16V4ABSADD : inst_f16v4absadd_aaan;
def F16V4ABSMAX : inst_f16v4absmax_aaan;
def F16V4MAXC : inst_f16v4maxc_aaan;
def F16V4MIX: inst_f16v4mix_aaan;
def F16V4GACC : inst_f16v4gacc_aaan;
def F16V4ACC : inst_f16v4acc_aaan;
def F16V4HIHOAMP : inst_f16v4hihoamp_aaan_ef;
def F16V4HIHOSLIC : inst_f16v4hihoslic_aaan_ef;
def F16V4SISOSLIC : inst_f16v4sisoslic_aaan_ef;
def F16V4SIHOAMP : inst_f16v4sihoamp_aaan_ef;
def F16V4SISOAMP : inst_f16v4sisoamp_aaan_ef;
def F16V4SIHOSLIC : inst_f16v4sihoslic_aaan_ef;
def F16V4CLAMP : inst_f16v4clamp_aaan;
def F16V4RMASK : inst_f16v4rmask_aaan;
def F16V4SUFROMUI : inst_f16v4sufromui_aaan;
def F16V4ISTACC : inst_f16v4istacc_aaan_ef;
def F16V4STACC: inst_f16v4stacc_aaan_ef;

def F16V4ADD : inst_f16v4add_aaan {
  let Pattern = [(set v4f16AR:$op0, (any_fadd v4f16AR:$op1, v4f16AR:$op2))];
}

def F16V4SUB : inst_f16v4sub_aaan {
  let Pattern = [(set v4f16AR:$op0, (any_fsub v4f16AR:$op1, v4f16AR:$op2))];
}

def F16V4MUL : inst_f16v4mul_aaan {
  let Pattern = [(set v4f16AR:$op0, (any_fmul v4f16AR:$op1, v4f16AR:$op2))];
}

def F16V4MAX : inst_f16v4max_aaan {
  let Pattern = [(set v4f16AR:$op0, (any_fmaxnum v4f16AR:$op1, v4f16AR:$op2))];
}

def F16V4MIN : inst_f16v4min_aaan {
  let Pattern = [(set v4f16AR:$op0, (any_fminnum v4f16AR:$op1, v4f16AR:$op2))];
}

let isCompare = 1 in {
  def F16V4CMPEQ : inst_f16v4cmpeq_aaan;
  def F16V4CMPGE : inst_f16v4cmpge_aaan;
  def F16V4CMPGT : inst_f16v4cmpgt_aaan;
  def F16V4CMPLE : inst_f16v4cmple_aaan;
  def F16V4CMPLT : inst_f16v4cmplt_aaan;
  def F16V4CMPNE : inst_f16v4cmpne_aaan;
}

def F16V4SUM : inst_f16v4sum_aaan;
def F16V4CMAC : inst_f16v4cmac_aaan;

//===----------------------------------------------------------------------===//
// Call patterns.
//===----------------------------------------------------------------------===//

def : Pat<(ColossusCall tglobaladdr:$addr),
          (CALL_PSEUDO CallOperand:$addr)>;

def : Pat<(ColossusCall texternalsym:$addr),
          (CALL_PSEUDO CallOperand:$addr)>;

def : Pat<(ColossusSetLR ptr_rc:$link),
          (SETLR LabelOperand:$link)>;

def : Pat<(ColossusICall ptr_rc:$link, MR:$addr),
          (ICALL LabelOperand:$link, MR:$addr)>;

//===----------------------------------------------------------------------===//
// Branch patterns.
//===----------------------------------------------------------------------===//

// Generic conditional branch pattern, to be used with SETCC patterns below.

def : Pat<(brcond i32MR:$cond, bb:$addr),
          (BRNZ MR:$cond, bb:$addr)>;

//===----------------------------------------------------------------------===//
// SELECT patterns.
//===----------------------------------------------------------------------===//

// SELECT_FLOAT is a pseudo instruction, SELECT_INT is a PatFrag
// It might be worth implementing SELECT_INT as a pseudo instruction
// in order to share more of the vector patterns between int & float
def SELECT_I32 :
  OutPatFrag<(ops node:$cond, node:$true, node:$false),
            (i32 (MOVZ node:$true, node:$false, node:$cond))>, Requires<[IsIpu1And2]>;

def SELECT_V2I32 :
  OutPatFrag<(ops node:$cond, node:$true, node:$false),
            (build_v2i32
              (SELECT_I32 $cond,
                (extract_v2i32_0 node:$true),
                (extract_v2i32_0 node:$false)),
              (SELECT_I32 $cond,
                (extract_v2i32_1 node:$true),
                (extract_v2i32_1 node:$false)))>, Requires<[IsIpu1And2]>;

def SELECT_V2I16 :
  OutPatFrag<(ops node:$cond, node:$true, node:$false),
            (v2i16 (MOVZ node:$true, node:$false, node:$cond))>, Requires<[IsIpu1And2]>;

def SELECT_V4I16 :
  OutPatFrag<(ops node:$cond, node:$true, node:$false),
            (v4i16 (build_pair_word
                      (SELECT_V2I16 $cond,
                        (extract_v2i32_0 node:$true),
                        (extract_v2i32_0 node:$false)),
                      (SELECT_V2I16 $cond,
                        (extract_v2i32_1 node:$true),
                        (extract_v2i32_1 node:$false))))>, Requires<[IsIpu1And2]>;

// Integer select patterns.
def : Pat<(select i32MR:$cond, i32MR:$true, i32MR:$false),
          (SELECT_I32 i32MR:$cond, i32MR:$true, i32MR:$false)>, Requires<[IsIpu1And2]>;

def : Pat<(select i32MR:$cond, v2i32MR:$true, v2i32MR:$false),
          (SELECT_V2I32 i32MR:$cond, v2i32MR:$true, v2i32MR:$false)>, Requires<[IsIpu1And2]>;

def : Pat<(select i32MR:$cond, v2i16MR:$true, v2i16MR:$false),
          (SELECT_V2I16 i32MR:$cond, v2i16MR:$true, v2i16MR:$false)>, Requires<[IsIpu1And2]>;

def : Pat<(select i32MR:$cond, v4i16MR:$true, v4i16MR:$false),
          (SELECT_V4I16 i32MR:$cond, v4i16MR:$true, v4i16MR:$false)>, Requires<[IsIpu1And2]>;
//===----------------------------------------------------------------------===//
// Address pattern fragments.
//===----------------------------------------------------------------------===//

// Load a block address.
def : Pat<(i32 (ColossusWrapper tblockaddress:$addr)),
          (SETZI imm20zi:$addr)>;

// Load a global symbol address.
def : Pat<(i32 (ColossusWrapper tglobaladdr:$addr)),
          (SETZI imm20zi:$addr)>;

// Load a jump table address.
def : Pat<(i32 (ColossusWrapper tjumptable:$jt)),
          (SETZI imm20zi:$jt)>;

// Load a constant pool address.
def : Pat<(i32 (ColossusWrapper tconstpool:$addr)),
          (SETZI imm20zi:$addr)>;

//===----------------------------------------------------------------------===//
// Store patterns.
//===----------------------------------------------------------------------===//

// st64_mbmn

multiclass Store64A<PatFrag RegTy> {
  def : Pat<(store RegTy:$src, ADDRrrr64:$addr),
            (ST64_A RegTy:$src, ADDRrrr64:$addr)>;

  def : Pat<(store RegTy:$src, ADDRrri64:$addr),
            (ST64_ZI_A RegTy:$src, ADDRrri64:$addr)>;

  def : Pat<(store RegTy:$src, ADDRfi64:$addr),
            (ST64_A_FI RegTy:$src, ADDRfi64:$addr)>;
}

defm : Store64A<v2f32AR>;
defm : Store64A<v4f16AR>;

// st32_mmmn

multiclass Store32M<PatFrag RegTy> {
  def : Pat<(store RegTy:$src, ADDRrr32:$addr),
            (STM32 MR:$src, ADDRrr32:$addr)>;
  let Predicates = [IsIpu1And2] in {
    def : Pat <(store RegTy:$op1, ADDRrri32:$addr),
             (ST32_ZI MR:$op1, ADDRrri32:$addr)>;
  }
  def : Pat<(store RegTy:$src, ADDRfi32:$addr),
            (ST32_FI MR:$src, ADDRfi32:$addr)>;
}

defm : Store32M<i32MR>;
defm : Store32M<v2i16MR>;

multiclass Store32A<PatFrag RegTy> {
  def : Pat<(store RegTy:$op1, ADDRrrr32:$addr),
            (ST32_A AR:$op1, ADDRrrr32:$addr)>;

  def : Pat<(store RegTy:$op1, ADDRrri32:$addr),
            (ST32_ZI_A AR:$op1, ADDRrri32:$addr)>;

  def : Pat<(store RegTy:$src, ADDRfi32:$addr),
            (ST32_A_FI AR:$src, ADDRfi32:$addr)>;
}

defm : Store32A<v2f16AR>;
defm : Store32A<f32AR>;

//===----------------------------------------------------------------------===//
// Load patterns.
//===----------------------------------------------------------------------===//

def colossusExtloadf16 : PatFrag<(ops node:$ptr), (extload node:$ptr), [{
  return cast<LoadSDNode>(N)->getMemoryVT() == MVT::f16;
}]>;

// ld64_mman

multiclass Load64A<ValueType Ty> {
  def : Pat<(Ty (load ADDRrrr64:$addr)), (LD64_A    ADDRrrr64:$addr)>;
  def : Pat<(Ty (load ADDRrri64:$addr)), (LD64_ZI_A ADDRrri64:$addr)>;
}

defm : Load64A<v2f32>;
defm : Load64A<v4f16>;

// ld32_mmmn

multiclass Load32M<ValueType Ty> {
  def : Pat<(Ty (load ADDRrrr32:$addr)), (LD32    ADDRrrr32:$addr)>;
  def : Pat<(Ty (load ADDRrri32:$addr)), (LD32_ZI ADDRrri32:$addr)>;
}

multiclass Load32A<ValueType Ty> {
  def : Pat<(Ty (load ADDRrrr32:$addr)), (LD32_A    ADDRrrr32:$addr)>;
  def : Pat<(Ty (load ADDRrri32:$addr)), (LD32_ZI_A ADDRrri32:$addr)>;
}

defm : Load32M<i32>;
defm : Load32M<v2i16>;
defm : Load32A<f32>;
defm : Load32A<v2f16>;

// ld16 anyext
def : Pat<(i32 (extloadi16 ADDRrrr16:$addr)), (LDZ16    ADDRrrr16:$addr)>;
def : Pat<(i32 (extloadi16 ADDRrri16:$addr)), (LDZ16_ZI ADDRrri16:$addr)>;

def : Pat<(f32 (colossusExtloadf16 ADDRrrr16:$addr)),
          (f32 (F16TOF32 (LDB16 ADDRrrr16:$addr)))>;

def : Pat<(f32 (colossusExtloadf16 ADDRrri16:$addr)),
          (f32 (F16TOF32 (LDB16_ZI ADDRrri16:$addr)))>;

// ldz16_mmmn
def : Pat<(i32 (zextloadi16 ADDRrrr16:$addr)), (LDZ16    ADDRrrr16:$addr)>;
def : Pat<(i32 (zextloadi16 ADDRrri16:$addr)), (LDZ16_ZI ADDRrri16:$addr)>;

def : Pat<(f16 (load ADDRrrr16:$addr)), (LDB16 ADDRrrr16:$addr)>;
def : Pat<(f16 (load ADDRrri16:$addr)), (LDB16_ZI ADDRrri16:$addr)>;

// lds16_mmmn
def : Pat<(i32 (sextloadi16 ADDRrrr16:$addr)), (LDS16    ADDRrrr16:$addr)>;
def : Pat<(i32 (sextloadi16 ADDRrri16:$addr)), (LDS16_ZI ADDRrri16:$addr)>;

// lds8_mmmn
def : Pat<(i32 (sextloadi8 ADDRrrr8:$addr)), (LDS8    ADDRrrr8:$addr)>;
def : Pat<(i32 (sextloadi8 ADDRrri8:$addr)), (LDS8_ZI ADDRrri8:$addr)>;

// ldz8_mmmn
def : Pat<(i32 (zextloadi8 ADDRrrr8:$addr)), (LDZ8    ADDRrrr8:$addr)>;
def : Pat<(i32 (zextloadi8 ADDRrri8:$addr)), (LDZ8_ZI ADDRrri8:$addr)>;

// load i8 anyextend
def : Pat<(i32 (extloadi8 ADDRrrr8:$addr)), (LDZ8    ADDRrrr8:$addr)>;
def : Pat<(i32 (extloadi8 ADDRrri8:$addr)), (LDZ8_ZI ADDRrri8:$addr)>;

// Frame index load patterns.
// NOTE: there is no targeting of delta offsets for FI memory accesses.

// ld64_mman
def : Pat<(v2f32 (load ADDRfi64:$addr)), (LD64_A_FI ADDRfi64:$addr)>;
def : Pat<(v4f16 (load ADDRfi64:$addr)), (LD64_A_FI ADDRfi64:$addr)>;

// ld32_mmmn
def : Pat<(i32   (load ADDRfi32:$addr)), (LD32_FI   ADDRfi32:$addr)>;
def : Pat<(v2i16 (load ADDRfi32:$addr)), (LD32_FI   ADDRfi32:$addr)>;
def : Pat<(f32   (load ADDRfi32:$addr)), (LD32_A_FI ADDRfi32:$addr)>;
def : Pat<(v2f16 (load ADDRfi32:$addr)), (LD32_A_FI ADDRfi32:$addr)>;

// ldz16_mmmn
def : Pat<(i32 (zextloadi16 ADDRfi16:$addr)), (LDZ16_FI   ADDRfi16:$addr)>;
def : Pat<(f16 (load ADDRfi16:$addr)),        (LDZ16_A_FI ADDRfi16:$addr)>;

// lds16_mmmn
def : Pat<(i32 (sextloadi16 ADDRfi16:$addr)), (LDS16_FI ADDRfi16:$addr)>;

// load i16 anyext
def : Pat<(i32 (extloadi16 ADDRfi16:$addr)), (LDZ16_FI ADDRfi16:$addr)>;

def : Pat<(f32 (colossusExtloadf16 ADDRfi16:$addr)),
          (f32 (F16TOF32 (LDZ16_A_FI ADDRfi16:$addr)))>;

// lds8_mmmn
def : Pat<(i32 (sextloadi8 ADDRfi8:$addr)), (LDS8_FI ADDRfi8:$addr)>;

// ldz8_mmmn
def : Pat<(i32 (zextloadi8 ADDRfi8:$addr)), (LDZ8_FI ADDRfi8:$addr)>;

// load i8 anyextend
def : Pat<(i32 (extloadi8 ADDRfi8:$addr)), (LDZ8_FI ADDRfi8:$addr)>;

//===----------------------------------------------------------------------===//
// f32 conversion patterns.
//===----------------------------------------------------------------------===//

// The rounding mode immediate values used below must match the definition in
// tileimplconsts_tommy.h.
//   TFPU_ROUND_EVEN   = 0
//   TFPU_ROUND_POSINF = 1
//   TFPU_ROUND_NEGINF = 2
//   TFPU_ROUND_ZERO   = 3
//   TFPU_ROUND_AWAY   = 4

// fceil
def : Pat<(any_fceil f32AR:$val),
          (F32INT f32AR:$val, 1 /*TFPU_ROUND_POSINF*/)>;

// ffloor
def : Pat<(any_ffloor f32AR:$val),
          (F32INT f32AR:$val, 2 /*TFPU_ROUND_NEGINF*/)>;

// ftrunc
def : Pat<(any_ftrunc f32AR:$val),
          (F32INT f32AR:$val, 3 /*TFPU_ROUND_ZERO*/)>;

// fround
def : Pat<(any_fround f32AR:$val),
          (F32INT f32AR:$val, 4 /*TFPU_ROUND_AWAY*/)>;

// frint
def : Pat<(any_frint f32AR:$val),
          (F32INT f32AR:$val, 0 /*TFPU_ROUND_EVEN*/)>;

// fnearbyint
def : Pat<(any_fnearbyint f32AR:$val),
          (F32INT f32AR:$val, 0 /*TFPU_ROUND_EVEN*/)>;


//===----------------------------------------------------------------------===//
// fp <-> int patterns
//===----------------------------------------------------------------------===//

// sint_to_fp and strict_sint_to_fp
def : Pat<(f16 (any_sint_to_fp i32MR:$val)),
          (f16 (F32TOF16 (F32FROMI32 (COPY_TO_REGCLASS i32MR:$val, AR))))>;

def : Pat<(f32 (any_sint_to_fp i32MR:$val)),
          (f32 (F32FROMI32 (COPY_TO_REGCLASS i32MR:$val, AR)))>;

def : Pat<(f32 (sint_to_f32 f32AR:$val)),
          (f32 (F32FROMI32 f32AR:$val))>;

// uint_to_fp and strict_uint_to_fp
def : Pat<(f16 (any_uint_to_fp i32MR:$val)),
          (f16 (F32TOF16 (F32FROMUI32 (COPY_TO_REGCLASS i32MR:$val, AR))))>;

def : Pat<(f32 (any_uint_to_fp i32MR:$val)),
          (f32 (F32FROMUI32 (COPY_TO_REGCLASS i32MR:$val, AR)))>;

def : Pat<(f32 (uint_to_f32 f32AR:$val)),
          (f32 (F32FROMUI32 f32AR:$val))>;

def F32INT_ROUND_ZERO : OutPatFrag<(ops node:$x),
                                   (F32INT node:$x, 3 /*TFPU_ROUND_ZERO*/)>;

// fp_to_sint and strict_fp_to_sint
def : Pat<(i32 (any_fp_to_sint f16AR:$val)),
          (i32 (COPY_TO_REGCLASS
                 (F32TOI32
                   (F32INT_ROUND_ZERO
                     (F16TOF32 f16AR:$val))), MR))>;

def : Pat<(i32 (any_fp_to_sint f32AR:$val)),
          (i32 (COPY_TO_REGCLASS
                 (F32TOI32
                   (F32INT_ROUND_ZERO f32AR:$val)), MR))>;

def : Pat<(f32 (any_f32_to_sint f32AR:$val)),
          (f32 (F32TOI32 (F32INT_ROUND_ZERO f32AR:$val)))>;

// fp_to_uint and strict_fp_to_uint
def : Pat<(i32 (any_fp_to_uint f16AR:$val)),
          (i32 (COPY_TO_REGCLASS
                 (F32TOUI32
                   (F32INT_ROUND_ZERO
                     (F16TOF32 f16AR:$val))), MR))>;

def : Pat<(i32 (any_fp_to_uint f32AR:$val)),
          (i32 (COPY_TO_REGCLASS
                 (F32TOUI32
                   (F32INT_ROUND_ZERO f32AR:$val)), MR))>;

def : Pat<(f32 (any_f32_to_uint f32AR:$val)),
          (f32 (F32TOUI32 (F32INT_ROUND_ZERO f32AR:$val)))>;

//===----------------------------------------------------------------------===//
// fp setcc is custom lowered to combinations of these ColossusISD nodes
//===----------------------------------------------------------------------===//

class FCMP_aux<PatFrags isdop, EncodedI mop, PatLeaf src, ValueType dst>
  : Pat<(dst (isdop src:$op0, src:$op1)),
        (dst (mop src:$op0, src:$op1))>;

multiclass FCMP<PatFrags isdop, EncodedI f32op, EncodedI v2f16op,
                EncodedI v2f32op, EncodedI v4f16op>

{
  def : FCMP_aux<isdop, f32op, f32AR, f32>;
  def : FCMP_aux<isdop, v2f16op, v2f16AR, v2f16>;
  def : FCMP_aux<isdop, v2f32op, v2f32AR, v2f32>;
  def : FCMP_aux<isdop, v4f16op, v4f16AR, v4f16>;
}
multiclass FCMP2<PatFrags isdop, PatFrags isdop2, EncodedI f32op, EncodedI v2f16op, EncodedI v2f32op, EncodedI v4f16op>
{
  defm : FCMP<isdop, f32op, v2f16op, v2f32op, v4f16op>;
  defm : FCMP<isdop2, f32op, v2f16op, v2f32op, v4f16op>;
}

defm : FCMP2<any_ColossusFCMPOEQ, any_ColossusFCMPEQ, F32CMPEQ, F16V2CMPEQ, F32V2CMPEQ, F16V4CMPEQ>;
defm : FCMP2<any_ColossusFCMPUNE, any_ColossusFCMPNE, F32CMPNE, F16V2CMPNE, F32V2CMPNE, F16V4CMPNE>;
defm : FCMP2<any_ColossusFCMPOGT, any_ColossusFCMPGT, F32CMPGT, F16V2CMPGT, F32V2CMPGT, F16V4CMPGT>;
defm : FCMP2<any_ColossusFCMPOGE, any_ColossusFCMPGE, F32CMPGE, F16V2CMPGE, F32V2CMPGE, F16V4CMPGE>;
defm : FCMP2<any_ColossusFCMPOLT, any_ColossusFCMPLT, F32CMPLT, F16V2CMPLT, F32V2CMPLT, F16V4CMPLT>;
defm : FCMP2<any_ColossusFCMPOLE, any_ColossusFCMPLE, F32CMPLE, F16V2CMPLE, F32V2CMPLE, F16V4CMPLE>;


//===----------------------------------------------------------------------===//
// Vector patterns.
//===----------------------------------------------------------------------===//

// Arithmetic

multiclass vectorIntegerBitwiseBinaryOp<SDNode Op, EncodedI Instr> {
  def : Pat<(v2i16 (Op (v2i16 MR:$op1), (v2i16 MR:$op2))),
            (v2i16 (Instr (COPY_TO_REGCLASS v2i16MR:$op1, MR),
                          (COPY_TO_REGCLASS v2i16MR:$op2, MR)))>;

  def : Pat<(v2i32 (Op (v2i32 MRPair:$op1), (v2i32 MRPair:$op2))),
            (build_v2i32 (Instr (extract_v2i32_0 v2i32:$op1),
                                (extract_v2i32_0 v2i32:$op2)),
                         (Instr (extract_v2i32_1 v2i32:$op1),
                                (extract_v2i32_1 v2i32:$op2)))>;

  def : Pat<(v4i16 (Op (v4i16 MRPair:$op1), (v4i16 MRPair:$op2))),
            (v4i16 (build_pair_word
                     (Instr (extract_pair_word_low v4i16:$op1),
                            (extract_pair_word_low v4i16:$op2)),
                     (Instr (extract_pair_word_high v4i16:$op1),
                            (extract_pair_word_high v4i16:$op2))))>;
}

defm : vectorIntegerBitwiseBinaryOp<and, AND>;
defm : vectorIntegerBitwiseBinaryOp<or, OR>;
defm : vectorIntegerBitwiseBinaryOp<xor, XOR>;

// build_vector

// v2i32
def : Pat<(v2i32 (build_vector i32MR:$a1, i32MR:$a2)),
          (build_v2i32 i32MR:$a1, i32MR:$a2)>;

// v2f32
def : Pat<(v2f32 (build_vector f32AR:$a1, f32AR:$a2)),
          (build_v2f32 f32AR:$a1, f32AR:$a2)>;

// concat vectors
def : Pat<(v4f16 (concat_vectors v2f16AR:$a1, v2f16AR:$a2)),
          (build_pair_word v2f16AR:$a1, v2f16AR:$a2)>;
def : Pat<(v4i16 (concat_vectors v2i16MR:$a1, v2i16MR:$a2)),
          (build_pair_word v2i16MR:$a1, v2i16MR:$a2)>;
def : Pat<(v4f16 (ColossusCONCAT_VECTORS v2f16AR:$a1, v2f16AR:$a2)),
          (build_pair_word v2f16AR:$a1, v2f16AR:$a2)>;
def : Pat<(v4i16 (ColossusCONCAT_VECTORS v2i16MR:$a1, v2i16MR:$a2)),
          (build_pair_word v2i16MR:$a1, v2i16MR:$a2)>;

// extract_subvector
def : Pat<(v2i16 (extract_subvector v4i16MR:$src, (i32 0))),
          (v2i16 (extract_pair_word_low v4i16MR:$src))>;
def : Pat<(v2i16 (extract_subvector v4i16MR:$src, (i32 2))),
          (v2i16 (extract_pair_word_high v4i16MR:$src))>;
def : Pat<(v2f16 (extract_subvector v4f16AR:$src, (i32 0))),
          (v2f16 (extract_pair_word_low v4f16AR:$src))>;
def : Pat<(v2f16 (extract_subvector v4f16AR:$src, (i32 2))),
          (v2f16 (extract_pair_word_high v4f16AR:$src))>;

// extractelt

// v2i32
def : Pat<(i32 (extractelt v2i32MR:$src, (i32 0))),
          (extract_v2i32_0 v2i32MR:$src)>;

def : Pat<(i32 (extractelt v2i32MR:$src, (i32 1))),
          (extract_v2i32_1 v2i32MR:$src)>;

// v2f32
def : Pat<(f32 (extractelt v2f32AR:$src, (i32 0))),
          (extract_v2f32_0 v2f32AR:$src)>;

def : Pat<(f32 (extractelt v2f32AR:$src, (i32 1))),
          (extract_v2f32_1 v2f32AR:$src)>;

// insertelt

// v2f32
def : Pat<(v2f32 (insertelt v2f32AR:$src, f32AR:$val, (i32 0))),
          (insert_v2f32_0 v2f32AR:$src, f32AR:$val)>;

def : Pat<(v2f32 (insertelt v2f32AR:$src, f32AR:$val, (i32 1))),
          (insert_v2f32_1 v2f32AR:$src, f32AR:$val)>;

// v2i32
def : Pat<(v2i32 (insertelt v2i32MR:$src, i32MR:$val, (i32 0))),
          (insert_v2i32_0 v2i32MR:$src, i32MR:$val)>;

def : Pat<(v2i32 (insertelt v2i32MR:$src, i32MR:$val, (i32 1))),
          (insert_v2i32_1 v2i32MR:$src, i32MR:$val)>;

// Logic for the strict equivalent is implemented by
// ReplaceWithF16AS in 'ColossusISelDAGToDAG.cpp' to work around
// the limitation of one 'use' for patterns.
// F32TOF16 broadcasts into both halves of the output register
def : Pat<(v2f16 (ColossusSORT4X16LO (v2f16 (ColossusF16ASV2F16 (f16 (any_fpround f32AR:$op)))),
                                     (v2f16 (ColossusF16ASV2F16 (f16 (any_fpround f32AR:$op)))))),
          (COPY_TO_REGCLASS (f16 (F32TOF16 f32AR:$op)), AR)>;

// Broadcast v2f32 arithmetic, allowing lowering zero constant as a copy
def build_vector_bc : PatFrag<(ops node:$src),
                                       (build_vector node:$src, node:$src),
[{
    SDValue op = N->getOperand(0);
    // there are no MRF broadcast instructions so don't need to check for zero
    const ConstantFPSDNode * cfp = dyn_cast<ConstantFPSDNode>(op);
    if (cfp) {
      const ConstantFP *C = cfp->getConstantFPValue();
      if (C->isZero()) {
        // don't use broadcast to create an all-bits-zero constant
        return C->isNegative();
      }
    }
    return true;
}]>;

class v2f32_broadcast<SDPatternOperator op, EncodedI F32V2OP_BL> :
   Pat<(v2f32 (op (v2f32 (build_vector_bc f32AR:$x)), v2f32AR:$y)),
       (v2f32 (F32V2OP_BL f32AR:$x, v2f32AR:$y))>;

def : v2f32_broadcast<fadd, F32V2ADD_BL>;
def : v2f32_broadcast<strict_fadd, F32V2ADD_BL>;
def : v2f32_broadcast<fsub, F32V2SUB_BL>;
def : v2f32_broadcast<strict_fsub, F32V2SUB_BL>;
def : v2f32_broadcast<fmul, F32V2MUL_BL>;
def : v2f32_broadcast<strict_fmul, F32V2MUL_BL>;

def : v2f32_broadcast<any_ColossusFCMPOEQ, F32V2CMPEQ_BL>;
def : v2f32_broadcast<any_ColossusFCMPUNE, F32V2CMPNE_BL>;
def : v2f32_broadcast<any_ColossusFCMPOGT, F32V2CMPGT_BL>;
def : v2f32_broadcast<any_ColossusFCMPOGE, F32V2CMPGE_BL>;
def : v2f32_broadcast<any_ColossusFCMPOLT, F32V2CMPLT_BL>;
def : v2f32_broadcast<any_ColossusFCMPOLE, F32V2CMPLE_BL>;
def : v2f32_broadcast<any_ColossusFCMPEQ, F32V2CMPEQ_BL>;
def : v2f32_broadcast<any_ColossusFCMPNE, F32V2CMPNE_BL>;
def : v2f32_broadcast<any_ColossusFCMPGT, F32V2CMPGT_BL>;
def : v2f32_broadcast<any_ColossusFCMPGE, F32V2CMPGE_BL>;
def : v2f32_broadcast<any_ColossusFCMPLT, F32V2CMPLT_BL>;
def : v2f32_broadcast<any_ColossusFCMPLE, F32V2CMPLE_BL>;

def : v2f32_broadcast<any_ColossusFCMPEQ, F32V2CMPEQ_BL>;
def : v2f32_broadcast<any_ColossusFCMPNE, F32V2CMPNE_BL>;
def : v2f32_broadcast<any_ColossusFCMPGT, F32V2CMPGT_BL>;
def : v2f32_broadcast<any_ColossusFCMPGE, F32V2CMPGE_BL>;
def : v2f32_broadcast<any_ColossusFCMPLT, F32V2CMPLT_BL>;
def : v2f32_broadcast<any_ColossusFCMPLE, F32V2CMPLE_BL>;

// broadcasts based on SORT4X16

def build_vector_v2f16_bc : PatFrag<(ops node:$src),
                                    (ColossusSORT4X16LO node:$src, node:$src),
[{
    SDValue op = N->getOperand(0);
    // Match a broadcast scalar via the sort4x16lo_mmmn pattern
    // If the scalar is from a 16 bit load or fp_round then
    // it is better to fold the sort4x16lo_mmmn into the load/round instead
    // in order to allow the other operand to be broadcast as well
    if (op.getValueType() == MVT::v2f16) {
      if (op.getOpcode() == ColossusISD::F16ASV2F16) {
        unsigned opc = op.getOperand(0).getOpcode();
        if (opc == ISD::FP_ROUND || opc == ISD::STRICT_FP_ROUND ||
            opc == ISD::LOAD) {
          return false;
        }
      }
    }
    return true;
}]>;

multiclass broadcast_v2<SDPatternOperator Op,
                        EncodedI F16V2OP_BL,
                        EncodedI F16V2OP_BU,
                        EncodedI F16V4OP_BL,
                        EncodedI F16V4OP_BU>
{
  def : Pat<(v2f16 (Op (v2f16 (build_vector_v2f16_bc v2f16AR:$lhs)), v2f16AR:$rhs)),
            (F16V2OP_BL v2f16AR:$lhs, v2f16AR:$rhs)>;

  def : Pat<(v2f16 (Op (v2f16 (ColossusSORT4X16HI v2f16AR:$lhs, v2f16AR:$lhs)), v2f16AR:$rhs)),
            (F16V2OP_BU v2f16AR:$lhs, v2f16AR:$rhs)>;

  def : Pat<(v4f16 (Op (v4f16 (ColossusCONCAT_VECTORS
                                (v2f16 (ColossusSORT4X16LO v2f16AR:$lhs, v2f16AR:$lhs)),
                                (v2f16 (ColossusSORT4X16LO v2f16AR:$lhs, v2f16AR:$lhs)))),
                                v4f16AR:$rhs)),
              (F16V4OP_BL v2f16AR:$lhs, v4f16AR:$rhs)>;

  def : Pat<(v4f16 (Op (v4f16 (ColossusCONCAT_VECTORS
                                (v2f16 (ColossusSORT4X16HI v2f16AR:$lhs, v2f16AR:$lhs)),
                                (v2f16 (ColossusSORT4X16HI v2f16AR:$lhs, v2f16AR:$lhs)))),
                                v4f16AR:$rhs)),
              (F16V4OP_BU v2f16AR:$lhs, v4f16AR:$rhs)>;
}

defm : broadcast_v2<fadd, F16V2ADD_BL, F16V2ADD_BU, F16V4ADD_BL, F16V4ADD_BU>;
defm : broadcast_v2<strict_fadd, F16V2ADD_BL, F16V2ADD_BU, F16V4ADD_BL, F16V4ADD_BU>;
defm : broadcast_v2<fsub, F16V2SUB_BL, F16V2SUB_BU, F16V4SUB_BL, F16V4SUB_BU>;
defm : broadcast_v2<strict_fsub, F16V2SUB_BL, F16V2SUB_BU, F16V4SUB_BL, F16V4SUB_BU>;
defm : broadcast_v2<fmul, F16V2MUL_BL, F16V2MUL_BU, F16V4MUL_BL, F16V4MUL_BU>;
defm : broadcast_v2<strict_fmul, F16V2MUL_BL, F16V2MUL_BU, F16V4MUL_BL, F16V4MUL_BU>;
defm : broadcast_v2<any_ColossusFCMPOEQ, F16V2CMPEQ_BL, F16V2CMPEQ_BU, F16V4CMPEQ_BL, F16V4CMPEQ_BU>;
defm : broadcast_v2<any_ColossusFCMPOGT, F16V2CMPGT_BL, F16V2CMPGT_BU, F16V4CMPGT_BL, F16V4CMPGT_BU>;
defm : broadcast_v2<any_ColossusFCMPOGE, F16V2CMPGE_BL, F16V2CMPGE_BU, F16V4CMPGE_BL, F16V4CMPGE_BU>;
defm : broadcast_v2<any_ColossusFCMPOLT, F16V2CMPLT_BL, F16V2CMPLT_BU, F16V4CMPLT_BL, F16V4CMPLT_BU>;
defm : broadcast_v2<any_ColossusFCMPOLE, F16V2CMPLE_BL, F16V2CMPLE_BU, F16V4CMPLE_BL, F16V4CMPLE_BU>;
defm : broadcast_v2<any_ColossusFCMPUNE, F16V2CMPNE_BL, F16V2CMPNE_BU, F16V4CMPNE_BL, F16V4CMPNE_BU>;
defm : broadcast_v2<any_ColossusFCMPEQ, F16V2CMPEQ_BL, F16V2CMPEQ_BU, F16V4CMPEQ_BL, F16V4CMPEQ_BU>;
defm : broadcast_v2<any_ColossusFCMPNE, F16V2CMPNE_BL, F16V2CMPNE_BU, F16V4CMPNE_BL, F16V4CMPNE_BU>;
defm : broadcast_v2<any_ColossusFCMPGT, F16V2CMPGT_BL, F16V2CMPGT_BU, F16V4CMPGT_BL, F16V4CMPGT_BU>;
defm : broadcast_v2<any_ColossusFCMPGE, F16V2CMPGE_BL, F16V2CMPGE_BU, F16V4CMPGE_BL, F16V4CMPGE_BU>;
defm : broadcast_v2<any_ColossusFCMPLT, F16V2CMPLT_BL, F16V2CMPLT_BU, F16V4CMPLT_BL, F16V4CMPLT_BU>;
defm : broadcast_v2<any_ColossusFCMPLE, F16V2CMPLE_BL, F16V2CMPLE_BU, F16V4CMPLE_BL, F16V4CMPLE_BU>;

// Bitcasts (reinterpretation of values held in registers).

// f32 <-> i32
def : Pat<(i32   (bitconvert f32AR:$src)),   (COPY_TO_REGCLASS f32AR:$src,   MR)>;
def : Pat<(f32   (bitconvert i32MR:$src)),   (COPY_TO_REGCLASS i32MR:$src,   AR)>;

// v2i16 <-> v2f16
def : Pat<(v2i16 (bitconvert v2f16AR:$src)),
          (COPY_TO_REGCLASS v2f16AR:$src, MR)>;
def : Pat<(v2f16 (bitconvert v2i16MR:$src)),
          (COPY_TO_REGCLASS v2i16MR:$src, AR)>;

// v2i16 <-> i32
def : Pat<(i32   (bitconvert v2i16MR:$src)), (i32MR:$src)>;
def : Pat<(v2i16 (bitconvert i32MR:$src)),   (v2i16MR:$src)>;

// v2f16 <-> i32
def : Pat<(i32 (bitconvert v2f16AR:$src)),
          (COPY_TO_REGCLASS v2f16AR:$src, MR)>;
def : Pat<(v2f16 (bitconvert i32MR:$src)),
          (COPY_TO_REGCLASS i32MR:$src, AR)>;

// v2i16 <-> f32
def : Pat<(v2i16 (bitconvert f32AR:$src)),
          (COPY_TO_REGCLASS f32AR:$src, MR)>;
def : Pat<(f32 (bitconvert v2i16MR:$src)),
          (COPY_TO_REGCLASS v2i16MR:$src, AR)>;
// v2f16 <-> f32
def : Pat<(f32 (bitconvert v2f16AR:$src)), (f32AR:$src)>;
def : Pat<(v2f16 (bitconvert f32AR:$src)), (v2f16AR:$src)>;

// v2f32 <-> v2i32
def : Pat<(v2i32 (bitconvert v2f32AR:$src)),
          (COPY_TO_REGCLASS v2f32AR:$src, MRPair)>;
def : Pat<(v2f32 (bitconvert v2i32MR:$src)),
          (COPY_TO_REGCLASS v2i32MR:$src, ARPair)>;

// v4i16 <-> v2i32
def : Pat<(v2i32 (bitconvert v4i16MR:$src)), (v2i32MR:$src)>;
def : Pat<(v4i16 (bitconvert v2i32MR:$src)), (v4i16MR:$src)>;

// v4f16 <-> v2f32
def : Pat<(v2f32 (bitconvert v4f16AR:$src)), (v2f32AR:$src)>;
def : Pat<(v4f16 (bitconvert v2f32AR:$src)), (v4f16AR:$src)>;

// v4f16 <-> v2i32
def : Pat<(v2i32 (bitconvert v4f16AR:$src)),
          (COPY_TO_REGCLASS v4f16AR:$src, MRPair)>;
def : Pat<(v4f16 (bitconvert v2i32MR:$src)),
          (COPY_TO_REGCLASS v2i32MR:$src, ARPair)>;

// v4i16 <-> v2f32
def : Pat<(v4i16 (bitconvert v2f32AR:$src)),
          (COPY_TO_REGCLASS v2f32AR:$src, MRPair)>;
def : Pat<(v2f32 (bitconvert v4i16MR:$src)),
          (COPY_TO_REGCLASS v4i16MR:$src, ARPair)>;

// v4f16 <-> v4i16
def : Pat<(v4i16 (bitconvert v4f16AR:$src)),
          (COPY_TO_REGCLASS v4f16AR:$src, MRPair)>;
def : Pat<(v4f16 (bitconvert v4i16MR:$src)),
          (COPY_TO_REGCLASS v4i16MR:$src, ARPair)>;

// f16 <-> v2f16
def : Pat<(v2f16 (ColossusF16ASV2F16 f16AR:$src)),
          (v2f16 (COPY_TO_REGCLASS f16AR:$src, AR))>;
def : Pat<(f16 (ColossusV2F16ASF16 v2f16AR:$src)),
          (f16 (COPY_TO_REGCLASS v2f16AR:$src, AR))>;

//===----------------------------------------------------------------------===//
// integer conversion patterns.
//===----------------------------------------------------------------------===//
def : Pat<(v2i16 (trunc v2i32MR:$val)),
          (v2i16 (SORT4X16LO (EXTRACT_SUBREG v2i32MR:$val, SubRegLo),
                             (EXTRACT_SUBREG v2i32MR:$val, SubRegHi)))>;

let Predicates = [IsIpu1And2] in {
  def : Pat<(v2i32 (sext v2i16MR:$src)),
              (v2i32 (build_v2i32 (SHRS_ZI (SHL_ZI v2i16MR:$src, 16), 16),
                                  (SHRS_ZI v2i16MR:$src, 16)))>;

  def : Pat<(v2i32 (zext v2i16MR:$src)),
            (v2i32
              (build_v2i32 (i32 (SORT4X16LO v2i16MR:$src, (COPY (v2i16 MZERO)))),
                              (i32 (SHR_ZI v2i16MR:$src, 16))))>;

  def : Pat<(v2i32 (anyext v2i16MR:$src)),
            (v2i32
              (build_v2i32 (i32 (COPY_TO_REGCLASS v2i16MR:$src, MR)),
                          (i32 (SHR_ZI v2i16MR:$src, 16))))>;
}

//===----------------------------------------------------------------------===//
// Other pattern fragments.
//===----------------------------------------------------------------------===//

def : Pat<(i32 (ColossusANDC i32MR:$op0, i32MR:$op1)),
          (i32 (ANDC i32MR:$op0, i32MR:$op1))>;
def : Pat<(i32 (ColossusANDC i32MR:$op0, imm12zi:$op1)),
          (i32 (ANDC_ZI i32MR:$op0, imm12zi:$op1))>;

def : Pat<(v2i16 (ColossusANDC v2i16MR:$op0, v2i16MR:$op1)),
          (v2i16 (ANDC v2i16MR:$op0, v2i16MR:$op1))>;

def : Pat<(v2i32 (ColossusANDC v2i32MR:$op0, v2i32MR:$op1)),
          (v2i32 (build_pair_word
                      (ANDC (extract_pair_word_low v2i32MR:$op0), (extract_pair_word_low v2i32MR:$op1)),
                      (ANDC (extract_pair_word_high v2i32MR:$op0), (extract_pair_word_high v2i32MR:$op1))))>;

def : Pat<(v4i16 (ColossusANDC v4i16MR:$op0, v4i16MR:$op1)),
          (v4i16 (build_pair_word
                      (ANDC (extract_pair_word_low v4i16MR:$op0), (extract_pair_word_low v4i16MR:$op1)),
                      (ANDC (extract_pair_word_high v4i16MR:$op0), (extract_pair_word_high v4i16MR:$op1))))>;

// 16 bit shuffle nodes
class shuffle_direct_lowering<ValueType RT, PatLeaf ArgTy, SDNode Op, EncodedI EI>
 : Pat<(RT (Op ArgTy:$op0, ArgTy:$op1)),
       (RT (EI ArgTy:$op0, ArgTy:$op1))>;

def : shuffle_direct_lowering<v2i16, v2i16MR, ColossusSORT4X16LO, SORT4X16LO>;
def : shuffle_direct_lowering<i32, i32MR, ColossusSORT4X16LO, SORT4X16LO>;
def : shuffle_direct_lowering<v2i16, v2i16MR, ColossusSORT4X16HI, SORT4X16HI>;
def : shuffle_direct_lowering<i32, i32MR, ColossusSORT4X16HI, SORT4X16HI>;
def : shuffle_direct_lowering<v2i16, v2i16MR, ColossusROLL16, ROLL16>;
def : shuffle_direct_lowering<i32, i32MR, ColossusROLL16, ROLL16>;

def : shuffle_direct_lowering<v2f16, v2f16AR, ColossusSORT4X16LO, SORT4X16LO_A>;
def : shuffle_direct_lowering<f32, f32AR, ColossusSORT4X16LO, SORT4X16LO_A>;
def : shuffle_direct_lowering<v2f16, v2f16AR, ColossusSORT4X16HI, SORT4X16HI_A>;
def : shuffle_direct_lowering<f32, f32AR, ColossusSORT4X16HI, SORT4X16HI_A>;
def : shuffle_direct_lowering<v2f16, v2f16AR, ColossusROLL16, ROLL16_A>;
def : shuffle_direct_lowering<f32, f32AR, ColossusROLL16, ROLL16_A>;

def : Pat<(i32 (ColossusSORT8X8LO i32MR:$op0, i32MR:$op1)),
          (i32 (SORT8X8LO i32MR:$op0, i32MR:$op1))>;
def : Pat<(i32 (ColossusSHUF8X8LO i32MR:$op0, i32MR:$op1)),
          (i32 (SHUF8X8LO i32MR:$op0, i32MR:$op1))>;
def : Pat<(i32 (ColossusSHUF8X8HI i32MR:$op0, i32MR:$op1)),
          (i32 (SHUF8X8HI i32MR:$op0, i32MR:$op1))>;

// handle undef efficiently
multiclass shuffle_undef_lowering<ValueType VTy, PatLeaf ArgTy, RegisterClass RC, EncodedI ROLL>
{
 def : Pat<(VTy (ColossusSORT4X16LO ArgTy:$op0, (VTy undef))),
           (VTy (COPY_TO_REGCLASS ArgTy:$op0, RC))>;

 def : Pat<(VTy (ColossusSORT4X16LO (VTy undef), ArgTy:$op0)),
           (VTy (COPY_TO_REGCLASS (ROLL ArgTy:$op0, ArgTy:$op0), RC))>;

 def : Pat<(VTy (ColossusSORT4X16HI (VTy undef), ArgTy:$op0)),
           (VTy (COPY_TO_REGCLASS ArgTy:$op0, RC))>;

 def : Pat<(VTy (ColossusSORT4X16HI ArgTy:$op0, (VTy undef))),
           (VTy (COPY_TO_REGCLASS (ROLL ArgTy:$op0, ArgTy:$op0), RC))>;

 def : Pat<(VTy (ColossusROLL16 ArgTy:$op0, (VTy undef))),
           (VTy (COPY_TO_REGCLASS (ROLL ArgTy:$op0, ArgTy:$op0), RC))>;

 def : Pat<(VTy (ColossusROLL16 (VTy undef), ArgTy:$op0)),
           (VTy (COPY_TO_REGCLASS (ROLL ArgTy:$op0, ArgTy:$op0), RC))>;
}

defm : shuffle_undef_lowering<v2f16, v2f16AR, AR, ROLL16_A>;
defm : shuffle_undef_lowering<f32, f32AR, AR, ROLL16_A>;
defm : shuffle_undef_lowering<v2i16, v2i16MR, MR, ROLL16>;
defm : shuffle_undef_lowering<i32, i32MR, MR, ROLL16>;

// Prefer (swap16 (roll16_mmmn x y)) to two sort4x16 as it decreases reg pressure
// There is existing test coverage for this from shuffle
// The equal arguments case is needed to avoid choosing swap
// when all elements are equal.
// The swap case might be better introduced as a DAGCombine.
def SWAP16 : OutPatFrag<(ops node:$src),
                          (ROLL16 node:$src, node:$src)>;
def SWAP16_A : OutPatFrag<(ops node:$src),
                          (ROLL16_A node:$src, node:$src)>;

def : Pat<(v4f16 (ColossusCONCAT_VECTORS
            (v2f16 (ColossusSORT4X16LO v2f16AR:$x0, v2f16AR:$x0)),
            (v2f16 (ColossusSORT4X16LO v2f16AR:$x0, v2f16AR:$x0)))),
          (build_pair_word (SORT4X16LO_A v2f16AR:$x0, v2f16AR:$x0),
                           (SORT4X16LO_A v2f16AR:$x0, v2f16AR:$x0))>;

def : Pat<(v4f16 (ColossusCONCAT_VECTORS
            (v2f16 (ColossusSORT4X16HI v2f16AR:$x0, v2f16AR:$x0)),
            (v2f16 (ColossusSORT4X16HI v2f16AR:$x0, v2f16AR:$x0)))),
          (build_pair_word (SORT4X16HI_A v2f16AR:$x0, v2f16AR:$x0),
                           (SORT4X16HI_A v2f16AR:$x0, v2f16AR:$x0))>;

def : Pat<(v4f16 (ColossusCONCAT_VECTORS
            (v2f16 (ColossusSORT4X16LO v2f16AR:$x0, v2f16AR:$x1)),
            (v2f16 (ColossusSORT4X16LO v2f16AR:$x1, v2f16AR:$x0)))),
          (build_pair_word (SORT4X16LO_A v2f16AR:$x0, v2f16AR:$x1),
            (SWAP16_A (SORT4X16LO_A v2f16AR:$x0, v2f16AR:$x1)))>;

def : Pat<(v4f16 (ColossusCONCAT_VECTORS
            (v2f16 (ColossusSORT4X16HI v2f16AR:$x0, v2f16AR:$x1)),
            (v2f16 (ColossusSORT4X16HI v2f16AR:$x1, v2f16AR:$x0)))),
          (build_pair_word (SORT4X16HI_A v2f16AR:$x0, v2f16AR:$x1),
            (SWAP16_A (SORT4X16HI_A v2f16AR:$x0, v2f16AR:$x1)))>;

def : Pat<(v4i16 (ColossusCONCAT_VECTORS
            (v2i16 (ColossusSORT4X16LO v2i16MR:$x0, v2i16MR:$x0)),
            (v2i16 (ColossusSORT4X16LO v2i16MR:$x0, v2i16MR:$x0)))),
          (build_pair_word (SORT4X16LO v2i16MR:$x0, v2i16MR:$x0),
                           (SORT4X16LO v2i16MR:$x0, v2i16MR:$x0))>;

def : Pat<(v4i16 (ColossusCONCAT_VECTORS
            (v2i16 (ColossusSORT4X16HI v2i16MR:$x0, v2i16MR:$x0)),
            (v2i16 (ColossusSORT4X16HI v2i16MR:$x0, v2i16MR:$x0)))),
          (build_pair_word (SORT4X16HI v2i16MR:$x0, v2i16MR:$x0),
                           (SORT4X16HI v2i16MR:$x0, v2i16MR:$x0))>;

def : Pat<(v4i16 (ColossusCONCAT_VECTORS
            (v2i16 (ColossusSORT4X16LO v2i16MR:$x0, v2i16MR:$x1)),
            (v2i16 (ColossusSORT4X16LO v2i16MR:$x1, v2i16MR:$x0)))),
          (build_pair_word (SORT4X16LO v2i16MR:$x0, v2i16MR:$x1),
            (SWAP16 (SORT4X16LO v2i16MR:$x0, v2i16MR:$x1)))>;

def : Pat<(v4i16 (ColossusCONCAT_VECTORS
            (v2i16 (ColossusSORT4X16HI v2i16MR:$x0, v2i16MR:$x1)),
            (v2i16 (ColossusSORT4X16HI v2i16MR:$x1, v2i16MR:$x0)))),
          (build_pair_word (SORT4X16HI v2i16MR:$x0, v2i16MR:$x1),
            (SWAP16 (SORT4X16HI v2i16MR:$x0, v2i16MR:$x1)))>;

// Byte swap and bitreverse i32.
def BSWAP32 : OutPatFrag<(ops node:$x),
                         (i32 (SWAP16 (SWAP8 node:$x)))>;
def : Pat<(bswap i32MR:$x),
          (BSWAP32 i32MR:$x)>;
def : Pat<(bitreverse i32MR:$x),
          (BSWAP32 (i32 (BITREV8 i32MR:$x)))>;

// Lower bitwise not on integers to XNOR with zero
def : Pat<(i32 (not i32MR:$op)),
          (i32 (XNOR i32MR:$op, (COPY (i32 MZERO))))>;

def : Pat<(v2i32 (vnot v2i32MR:$op)),
          (v2i32 (build_pair_word
            (XNOR (extract_pair_word_low v2i32MR:$op), (COPY (i32 MZERO))),
            (XNOR (extract_pair_word_high v2i32MR:$op), (COPY (i32 MZERO)))))>;


def : Pat<(v2i16 (xor v2i16MR:$op, (build_vector (i32 65535), (i32 65535)))),
          (v2i16 (XNOR v2i16MR:$op, (COPY (v2i16 MZERO))))>;

def : Pat<(v4i16 (xor v4i16MR:$op,
                      (ColossusCONCAT_VECTORS (build_vector (i32 65535), (i32 65535)),
                                              (build_vector (i32 65535), (i32 65535))))),
          (v4i16 (build_pair_word
            (XNOR (extract_pair_word_low v4i16MR:$op), (COPY (v2i16 MZERO))),
            (XNOR (extract_pair_word_high v4i16MR:$op), (COPY (v2i16 MZERO)))))>;

// Trap.
def : Pat<(trap),
          (TRAP 0)>;

//===----------------------------------------------------------------------===//
// Intrinsics.
//===----------------------------------------------------------------------===//

def : Pat<(i32 (int_colossus_get_scount_l)),    (GET 96)>;
def : Pat<(i32 (int_colossus_get_scount_u)),    (GET 97)>;

def : Pat<(i32 (int_colossus_get_vertex_base)), (COPY (i32 MVERTEX_BASE))>;
def : Pat<(i32 (int_colossus_get_tile_id)), (GET 3)>;

def CSR_W_WSR__CTXTID_M1__MASK : PatLeaf<(i32 0x00000007)>;
def : Pat<(i32 (int_colossus_get_worker_id)),(AND (GET COLOSSUS_WSR), 
                                                   CSR_W_WSR__CTXTID_M1__MASK)>;

def : Pat<(v2i32 (int_colossus_tapack i32MR:$x, i32MR:$y, i32MR:$z)),
          (TAPACK i32MR:$x, i32MR:$y, i32MR:$z)>;

def : Pat<(i32 (int_colossus_urand32)), (ATOM (URAND32))>;

def : Pat<(f16 (int_colossus_urand_f16)), (F16V2SUFROMUI (URAND32))>;
def : Pat<(f32 (int_colossus_urand_f32)), (F32SUFROMUI (URAND32))>;

def : Pat<(i32 (int_colossus_f32class AR:$op1)),
          (COPY_TO_REGCLASS (f32 (F32CLASS AR:$op1)), MR)>;
def : Pat<(v2i16 (int_colossus_f16v2class v2f16:$op1)),
          (SHUF8X8LO (i32 (COPY_TO_REGCLASS (f32 (F16V2CLASS v2f16:$op1)), MR)),
                     (i32 MZERO)
          )>;
def : Pat<(v2i16 (int_colossus_f32v2class v2f32:$op1)),
          (SHUF8X8LO (i32 (COPY_TO_REGCLASS (f32 (F32V2CLASS v2f32:$op1)), MR)),
                     (i32 MZERO)
          )>;
def : Pat<(v4i16 (int_colossus_f16v4class v4f16:$op1)),
          (v4i16 (build_pair_word (v2i16 (
           SHUF8X8LO (i32 (COPY_TO_REGCLASS (f32 (F16V4CLASS v4f16:$op1)), MR)),
                     (i32 MZERO)
          )), (v2i16 (
           SHUF8X8HI (i32 (COPY_TO_REGCLASS (f32 (F16V4CLASS v4f16:$op1)), MR)),
                     (i32 MZERO)))
          ))>;

def : Pat<(i32 (int_colossus_get imm8zi:$op1)), (GET imm8zi:$op1)>;
def : Pat<(i32 (int_colossus_uget imm8zi:$op1)), (COPY_TO_REGCLASS (f32 (UGET imm8zi:$op1)), MR)>;
def : Pat<(f32 (int_colossus_ugetf imm8zi:$op1)), (UGET imm8zi:$op1)>;

def : Pat<(int_colossus_put i32:$op0, imm8zi:$op1), (PUT i32:$op0, imm8zi:$op1)>, Requires<[IsIpu1And2]>;
def : Pat<(int_colossus_uput i32:$op0, imm8zi:$op1), (UPUT (COPY_TO_REGCLASS i32:$op0, AR), imm8zi:$op1)>;
def : Pat<(int_colossus_uputf AR:$op0, imm8zi:$op1), (UPUT AR:$op0, imm8zi:$op1)>;

def : Pat<(i32 (int_colossus_and_i32 i32:$op1, i32:$op2)), (AND i32:$op1, i32:$op2)>;
def : Pat<(i32 (int_colossus_and_i32 i32:$op1, imm12zi:$op2)), (AND_ZI i32:$op1, imm12zi:$op2)>;
def : Pat<(f32 (int_colossus_and_f32 f32:$op1, f32:$op2)), (AND_A f32:$op1, f32:$op2)>;
def : Pat<(f32 (int_colossus_and_f32 f32:$op1, fp32imm12iz:$op2)), (AND_IZ_A f32:$op1, (f32imm_to_target_imm fp32imm12iz:$op2))>;
def : Pat<(f32 (int_colossus_and_f32 f32:$op1, fp32imm12zi:$op2)), (AND_ZI_A f32:$op1, (f32imm_to_target_imm fp32imm12zi:$op2))>;
def : Pat<(v2f32 (int_colossus_and_v2f32 v2f32:$op1, v2f32:$op2)), (AND64 v2f32:$op1, v2f32:$op2)>;

def : Pat<(i32 (int_colossus_andc_i32 i32:$op1, i32:$op2)), (ANDC i32:$op1, i32:$op2)>;
def : Pat<(i32 (int_colossus_andc_i32 i32:$op1, imm12zi:$op2)), (ANDC_ZI i32:$op1, imm12zi:$op2)>;

def : Pat<(f32 (int_colossus_andc_f32 f32:$op1, f32:$op2)), (ANDC_A f32:$op1, f32:$op2)>;
def : Pat<(f32 (int_colossus_andc_f32 f32:$op1, fp32imm12iz:$op2)), (ANDC_IZ_A f32:$op1, (f32imm_to_target_imm fp32imm12iz:$op2))>;
def : Pat<(f32 (int_colossus_andc_f32 f32:$op1, fp32imm12zi:$op2)), (ANDC_ZI_A f32:$op1, (f32imm_to_target_imm fp32imm12zi:$op2))>;
def : Pat<(v2f32 (int_colossus_andc_v2f32 v2f32:$op1, v2f32:$op2)), (ANDC64 v2f32:$op1, v2f32:$op2)>;

def : Pat<(i32 (int_colossus_or_i32 i32:$op1, i32:$op2)), (OR i32:$op1, i32:$op2)>;
def : Pat<(i32 (int_colossus_or_i32 i32:$op1, imm12zi:$op2)), (OR_ZI i32:$op1, imm12zi:$op2)>;
def : Pat<(f32 (int_colossus_or_f32 f32:$op1, f32:$op2)), (OR_A f32:$op1, f32:$op2)>;
def : Pat<(f32 (int_colossus_or_f32 f32:$op1, fp32imm12iz:$op2)), (OR_IZ_A f32:$op1, (f32imm_to_target_imm fp32imm12iz:$op2))>;
def : Pat<(f32 (int_colossus_or_f32 f32:$op1, fp32imm12zi:$op2)), (OR_ZI_A f32:$op1, (f32imm_to_target_imm fp32imm12zi:$op2))>;
def : Pat<(v2f32 (int_colossus_or_v2f32 v2f32:$op1, v2f32:$op2)), (OR64 v2f32:$op1, v2f32:$op2)>;
def : Pat<(f32 (int_colossus_not_f32 f32:$op1)), (NOT f32:$op1)>;
def : Pat<(v2f32 (int_colossus_not_v2f32 v2f32:$op1)), (NOT64 v2f32:$op1)>;

def : Pat<(i32 (int_colossus_bitrev8 i32:$op1)), (BITREV8 i32:$op1)>;
def : Pat<(i32 (int_colossus_cms i32:$op1)), (CMS i32:$op1)>;

def : Pat<(v2f32 (int_colossus_roll32 v2f32:$op1, v2f32:$op2)), (ROLL32 v2f32:$op1, v2f32:$op2)>;
def : Pat<(i32 (int_colossus_roll8r i32:$op1, i32:$op2)), (ROLL8R i32:$op1, i32:$op2)>;
def : Pat<(i32 (int_colossus_roll8l i32:$op1, i32:$op2)), (ROLL8L i32:$op1, i32:$op2)>;

def : Pat<(i32 (int_colossus_shuf8x8hi i32:$op1, i32:$op2)), (SHUF8X8HI i32:$op1, i32:$op2)>;
def : Pat<(i32 (int_colossus_shuf8x8lo i32:$op1, i32:$op2)), (SHUF8X8LO i32:$op1, i32:$op2)>;
def : Pat<(v2f32 (int_colossus_sort4x32hi v2f32:$op1, v2f32:$op2)), (SORT4X32HI v2f32:$op1, v2f32:$op2)>;
def : Pat<(v2f32 (int_colossus_sort4x32lo v2f32:$op1, v2f32:$op2)), (SORT4X32LO v2f32:$op1, v2f32:$op2)>;
def : Pat<(i32 (int_colossus_sort8x8hi i32:$op1, i32:$op2)), (SORT8X8HI i32:$op1, i32:$op2)>;
def : Pat<(i32 (int_colossus_sort8x8lo i32:$op1, i32:$op2)), (SORT8X8LO i32:$op1, i32:$op2)>;
def : Pat<(i32 (int_colossus_sort8 i32:$op1)), (SORT8 i32:$op1)>;
def : Pat<(i32 (int_colossus_swap8 i32:$op1)), (SWAP8 i32:$op1)>;

def : Pat<(v2f16 (int_colossus_f16v2absadd v2f16:$op1, v2f16:$op2)), (F16V2ABSADD v2f16:$op1, v2f16:$op2)>;
def : Pat<(v4f16 (int_colossus_f16v4absadd v4f16:$op1, v4f16:$op2)), (F16V4ABSADD v4f16:$op1, v4f16:$op2)>;
def : Pat<(v2f32 (int_colossus_f32v2absadd v2f32:$op1, v2f32:$op2)), (F32V2ABSADD v2f32:$op1, v2f32:$op2)>;
def : Pat<(f32 (int_colossus_f32absadd f32:$op1, f32:$op2)), (F32ABSADD f32:$op1, f32:$op2)>;

def : Pat<(v2f16 (int_colossus_f16v2absmax v2f16:$op1, v2f16:$op2)), (F16V2ABSMAX v2f16:$op1, v2f16:$op2)>;
def : Pat<(v4f16 (int_colossus_f16v4absmax v4f16:$op1, v4f16:$op2)), (F16V4ABSMAX v4f16:$op1, v4f16:$op2)>;
def : Pat<(v2f32 (int_colossus_f32v2absmax v2f32:$op1, v2f32:$op2)), (F32V2ABSMAX v2f32:$op1, v2f32:$op2)>;
def : Pat<(f32 (int_colossus_f32absmax f32:$op1, f32:$op2)), (F32ABSMAX f32:$op1, f32:$op2)>;
def : Pat<(v2f16 (int_colossus_f16v2max v2f16:$op1, v2f16:$op2)), (F16V2MAX v2f16:$op1, v2f16:$op2)>;
def : Pat<(v4f16 (int_colossus_f16v4max v4f16:$op1, v4f16:$op2)), (F16V4MAX v4f16:$op1, v4f16:$op2)>;
def : Pat<(v2f32 (int_colossus_f32v2max v2f32:$op1, v2f32:$op2)), (F32V2MAX v2f32:$op1, v2f32:$op2)>;
def : Pat<(f32 (int_colossus_f32max f32:$op1, f32:$op2)), (F32MAX f32:$op1, f32:$op2)>;
def : Pat<(f16 (int_colossus_f16v2maxc v2f16:$op1)), (F16V2MAXC v2f16:$op1)>;
def : Pat<(v2f16 (int_colossus_f16v4maxc v4f16:$op1)), (F16V4MAXC v4f16:$op1)>;
def : Pat<(v2f16 (int_colossus_f16v2min v2f16:$op1, v2f16:$op2)), (F16V2MIN v2f16:$op1, v2f16:$op2)>;
def : Pat<(v4f16 (int_colossus_f16v4min v4f16:$op1, v4f16:$op2)), (F16V4MIN v4f16:$op1, v4f16:$op2)>;
def : Pat<(v2f32 (int_colossus_f32v2min v2f32:$op1, v2f32:$op2)), (F32V2MIN v2f32:$op1, v2f32:$op2)>;
def : Pat<(f32 (int_colossus_f32min f32:$op1, f32:$op2)), (F32MIN f32:$op1, f32:$op2)>;

def : Pat<(v2f16 (int_colossus_f16v2clamp v2f16:$op1, v2f16:$op2)), (F16V2CLAMP v2f16:$op1, v2f16:$op2)>;
def : Pat<(v4f16 (int_colossus_f16v4clamp v4f16:$op1, v2f16:$op2)), (F16V4CLAMP v4f16:$op1, v2f16:$op2)>;
def : Pat<(v2f32 (int_colossus_f32v2clamp v2f32:$op1, v2f32:$op2)), (F32V2CLAMP v2f32:$op1, v2f32:$op2)>;
def : Pat<(f32 (int_colossus_f32clamp f32:$op1, v2f32:$op2)), (F32CLAMP f32:$op1, v2f32:$op2)>;

def : Pat<(int_colossus_f16v2cmac v2f16:$op1, v2f16:$op2), (F16V2CMAC v2f16:$op1, v2f16:$op2)>;
def : Pat<(int_colossus_f16v4cmac v4f16:$op1, v4f16:$op2), (F16V4CMAC v4f16:$op1, v4f16:$op2)>;

def : Pat<(v2f16 (int_colossus_f16v2exp v2f16:$op1)), (F16V2EXP v2f16:$op1)>;
def : Pat<(v2f16 (int_colossus_f16v2exp2 v2f16:$op1)), (F16V2EXP2 v2f16:$op1)>;
def : Pat<(v2f16 (int_colossus_f16v2ln v2f16:$op1)), (F16V2LN v2f16:$op1)>;
def : Pat<(v2f16 (int_colossus_f16v2log2 v2f16:$op1)), (F16V2LOG2 v2f16:$op1)>;

def : Pat<(int_colossus_f32v2aop v2f32:$op1, v2f32:$op2, imm8zi:$op3), (F32V2AOP v2f32:$op1, v2f32:$op2, imm8zi:$op3)>;
def : Pat<(v2f32 (int_colossus_f32v2axpy v2f32:$op1, v2f32:$op2)), (F32V2AXPY v2f32:$op1, v2f32:$op2)>;
def : Pat<(v2f16 (int_colossus_f16v2gina v2f16:$op1, imm12zi:$op2)), (F16V2GINA v2f16:$op1, imm12zi:$op2)>;
def : Pat<(v2f32 (int_colossus_f32v2gina v2f32:$op1, imm12zi:$op2)), (F32V2GINA v2f32:$op1, imm12zi:$op2)>;

def : Pat<(v2f16 (int_colossus_f16v2grand)), (F16V2GRAND)>;
def : Pat<(v2f32 (int_colossus_f32v2grand)), (F32V2GRAND)>;

def : Pat<(v2f16 (int_colossus_f16v2cmpeq v2f16:$op1, v2f16:$op2)), (F16V2CMPEQ v2f16:$op1, v2f16:$op2)>;
def : Pat<(v4f16 (int_colossus_f16v4cmpeq v4f16:$op1, v4f16:$op2)), (F16V4CMPEQ v4f16:$op1, v4f16:$op2)>;
def : Pat<(v2f32 (int_colossus_f32v2cmpeq v2f32:$op1, v2f32:$op2)), (F32V2CMPEQ v2f32:$op1, v2f32:$op2)>;
def : Pat<(f32 (int_colossus_f32cmpeq f32:$op1, f32:$op2)), (F32CMPEQ f32:$op1, f32:$op2)>;
def : Pat<(v2f16 (int_colossus_f16v2cmpge v2f16:$op1, v2f16:$op2)), (F16V2CMPGE v2f16:$op1, v2f16:$op2)>;
def : Pat<(v4f16 (int_colossus_f16v4cmpge v4f16:$op1, v4f16:$op2)), (F16V4CMPGE v4f16:$op1, v4f16:$op2)>;
def : Pat<(v2f32 (int_colossus_f32v2cmpge v2f32:$op1, v2f32:$op2)), (F32V2CMPGE v2f32:$op1, v2f32:$op2)>;
def : Pat<(f32 (int_colossus_f32cmpge f32:$op1, f32:$op2)), (F32CMPGE f32:$op1, f32:$op2)>;
def : Pat<(v2f16 (int_colossus_f16v2cmpgt v2f16:$op1, v2f16:$op2)), (F16V2CMPGT v2f16:$op1, v2f16:$op2)>;
def : Pat<(v4f16 (int_colossus_f16v4cmpgt v4f16:$op1, v4f16:$op2)), (F16V4CMPGT v4f16:$op1, v4f16:$op2)>;
def : Pat<(v2f32 (int_colossus_f32v2cmpgt v2f32:$op1, v2f32:$op2)), (F32V2CMPGT v2f32:$op1, v2f32:$op2)>;
def : Pat<(f32 (int_colossus_f32cmpgt f32:$op1, f32:$op2)), (F32CMPGT f32:$op1, f32:$op2)>;
def : Pat<(v2f16 (int_colossus_f16v2cmple v2f16:$op1, v2f16:$op2)), (F16V2CMPLE v2f16:$op1, v2f16:$op2)>;
def : Pat<(v4f16 (int_colossus_f16v4cmple v4f16:$op1, v4f16:$op2)), (F16V4CMPLE v4f16:$op1, v4f16:$op2)>;
def : Pat<(v2f32 (int_colossus_f32v2cmple v2f32:$op1, v2f32:$op2)), (F32V2CMPLE v2f32:$op1, v2f32:$op2)>;
def : Pat<(f32 (int_colossus_f32cmple f32:$op1, f32:$op2)), (F32CMPLE f32:$op1, f32:$op2)>;
def : Pat<(v2f16 (int_colossus_f16v2cmplt v2f16:$op1, v2f16:$op2)), (F16V2CMPLT v2f16:$op1, v2f16:$op2)>;
def : Pat<(v4f16 (int_colossus_f16v4cmplt v4f16:$op1, v4f16:$op2)), (F16V4CMPLT v4f16:$op1, v4f16:$op2)>;
def : Pat<(v2f32 (int_colossus_f32v2cmplt v2f32:$op1, v2f32:$op2)), (F32V2CMPLT v2f32:$op1, v2f32:$op2)>;
def : Pat<(f32 (int_colossus_f32cmplt f32:$op1, f32:$op2)), (F32CMPLT f32:$op1, f32:$op2)>;
def : Pat<(v2f16 (int_colossus_f16v2cmpne v2f16:$op1, v2f16:$op2)), (F16V2CMPNE v2f16:$op1, v2f16:$op2)>;
def : Pat<(v4f16 (int_colossus_f16v4cmpne v4f16:$op1, v4f16:$op2)), (F16V4CMPNE v4f16:$op1, v4f16:$op2)>;
def : Pat<(v2f32 (int_colossus_f32v2cmpne v2f32:$op1, v2f32:$op2)), (F32V2CMPNE v2f32:$op1, v2f32:$op2)>;
def : Pat<(f32 (int_colossus_f32cmpne f32:$op1, f32:$op2)), (F32CMPNE f32:$op1, f32:$op2)>;

def : Pat<(v4f16 (int_colossus_f16v4rmask v4f16:$op1, f32:$op2)), (F16V4RMASK v4f16:$op1, f32:$op2)>;
def : Pat<(v2f32 (int_colossus_f32v2rmask v2f32:$op1, f32:$op2)), (F32V2RMASK v2f32:$op1, f32:$op2)>;
def : Pat<(v2f16 (int_colossus_f16v2sigm v2f16:$op1)), (F16V2SIGMOID v2f16:$op1)>;
def : Pat<(f32 (int_colossus_f32sigm f32:$op1)), (F32SIGMOID f32:$op1)>;
def : Pat<(f32 (int_colossus_f16v2sum v2f16:$op1)), (F16V2SUM v2f16:$op1)>;
def : Pat<(v2f32 (int_colossus_f16v4sum v4f16:$op1)), (F16V4SUM v4f16:$op1)>;
def : Pat<(v2f16 (int_colossus_f16v2tanh v2f16:$op1)), (F16V2TANH v2f16:$op1)>;

class RegConstraint<string C> {
  string Constraints = C;
}

let mayLoad = 0, mayStore = 0 in {
// The loop value nodes can't be terminators because a copytoreg is needed
// between their location and the terminators
// Metadata limit of imm16zi could be increased by implementing imm32
  let hasSideEffects = 0, isAsCheapAsAMove = 1 in {
    def CLOOP_BEGIN_VALUE : Pseudo<(outs MR:$op0),
                               (ins MR:$op1, imm16zi:$meta),
                               "# CLOOP_BEGIN_VALUE $op0, $op1, $meta",
                               []>,RegConstraint<"$op0 = $op1">;

    def CLOOP_END_VALUE : Pseudo<(outs MR:$op0),
                             (ins MR:$op1, imm16zi:$meta),
                             "# CLOOP_END_VALUE $op0, $op1, $meta",
                             []>,RegConstraint<"$op0 = $op1">;
  }

  def CLOOP_BEGIN_TERMINATOR : Pseudo<(outs),
                                      (ins MR:$op0, imm16zi:$meta),
                                      "# CLOOP_BEGIN_TERMINATOR $op0, $meta",
                                      []> {
    let isTerminator = 1;
    let hasSideEffects = 0;
  }

  def CLOOP_END_BRANCH : Pseudo<(outs),
                            (ins MR:$op0, Rel19S2Operand:$op1, imm16zi:$meta),
                            "# CLOOP_END_BRANCH $op0, $op1, $meta",
                             []> {
    let isBranch = 1;
    let isTerminator = 1;
    let hasSideEffects = 1;
  }

  def CLOOP_GUARD_BRANCH : Pseudo<(outs),
                            (ins MR:$op0, Rel19S2Operand:$op1, imm16zi:$meta),
                            "# CLOOP_GUARD_BRANCH $op0, $op1, $meta",
                             []> {
    let isBranch = 1;
    let isTerminator = 1;
    let hasSideEffects = 1;
  }
}

def : Pat<(i32 (ColossusCloopBeginValue i32MR:$op0, imm16zi:$meta)),
          (i32 (CLOOP_BEGIN_VALUE i32MR:$op0, imm16zi:$meta))>;
def : Pat<(i32 (ColossusCloopEndValue i32MR:$op0, imm16zi:$meta)),
          (i32 (CLOOP_END_VALUE i32MR:$op0, imm16zi:$meta))>;
def : Pat<(ColossusCloopBeginTerminator i32MR:$op0, imm16zi:$meta),
          (CLOOP_BEGIN_TERMINATOR i32MR:$op0, imm16zi:$meta)>;
def : Pat<(ColossusCloopEndBranch bb:$op0, i32MR:$op1, imm16zi:$meta),
          (CLOOP_END_BRANCH i32MR:$op1, bb:$op0, imm16zi:$meta)>;
def : Pat<(ColossusCloopGuardBranch bb:$op0, i32MR:$op1, imm16zi:$meta),
          (CLOOP_GUARD_BRANCH i32MR:$op1, bb:$op0, imm16zi:$meta)>;

//===----------------------------------------------------------------------===//
// Instruction aliases. The lowest line number wins when two match.
//===----------------------------------------------------------------------===//

foreach coissue = [0, 1] in
{
  def : InstAlias<"adds $op0, $op1, $op2", (ADD_SI MR:$op0, MR:$op1, imm16si:$op2, coissue), 0>;
  def : InstAlias<"addz $op0, $op1, $op2", (ADD_ZI MR:$op0, MR:$op1, imm16zi:$op2, coissue), 0>;
  def : InstAlias<"cmpeqs $op0, $op1, $op2", (CMPEQ_SI MR:$op0, MR:$op1, imm16si:$op2, coissue), 0>;
  def : InstAlias<"cmpeqz $op0, $op1, $op2", (CMPEQ_ZI MR:$op0, MR:$op1, imm16zi:$op2, coissue), 0>;
  def : InstAlias<"maxs $op0, $op1, $op2", (MAX_SI MR:$op0, MR:$op1, imm16si:$op2, coissue), 0>;
  def : InstAlias<"maxz $op0, $op1, $op2", (MAX_ZI MR:$op0, MR:$op1, imm16zi:$op2, coissue), 0>;
  def : InstAlias<"mins $op0, $op1, $op2", (MIN_SI MR:$op0, MR:$op1, imm16si:$op2, coissue), 0>;
  def : InstAlias<"minz $op0, $op1, $op2", (MIN_ZI MR:$op0, MR:$op1, imm16zi:$op2, coissue), 0>;
  def : InstAlias<"subs $op0, $op2, $op1", (SUB_SI MR:$op0, MR:$op1, imm16si:$op2, coissue), 0>;
  def : InstAlias<"subz $op0, $op2, $op1", (SUB_ZI MR:$op0, MR:$op1, imm16zi:$op2, coissue), 0>;
  def : InstAlias<"f16v4sisov2amp $op0, $op1, $op2, $op3", (F16V4SISOAMP ARPair:$op0, ARPair:$op1, ARPair:$op2, imm6zi:$op3, coissue), 0>;
  def : InstAlias<"f16v4sisov2slic $op0, $op1, $op2, $op3", (F16V4SISOSLIC ARPair:$op0, ARPair:$op1, ARPair:$op2, imm6zi:$op3, coissue), 0>;
  def : InstAlias<"nop", (SETZI M14, 0, coissue)>;
  def : InstAlias<"fnop", (SETZI_A A13, 0, coissue)>, Requires<[IsWorker, IsIpu1And2]>;
  def : InstAlias<"zero $op1", (OR MR:$op1, MZERO, MZERO, coissue)>;
  def : InstAlias<"zero $op1", (OR_A AR:$op1, AZERO, AZERO, coissue)>, Requires<[IsWorker]>;
  def : InstAlias<"zero $op1", (OR64 ARPair:$op1, AZEROS, AZEROS, coissue)>, Requires<[IsWorker]>;
  def : InstAlias<"mov $op1, $op2", (OR_ZI MR:$op1, MR:$op2, 0, coissue)>;
  def : InstAlias<"mov $op1, $op2", (OR_IZ MR:$op1, MR:$op2, 0, coissue)>;
  def : InstAlias<"mov $op1, $op2", (OR_ZI_A AR:$op1, AR:$op2, 0, coissue)>, Requires<[IsWorker]>;
  def : InstAlias<"mov $op1, $op2", (OR_IZ_A AR:$op1, AR:$op2, 0, coissue)>, Requires<[IsWorker]>;
  def : InstAlias<"mov $op1, $op2", (ATOM MR:$op1, AR:$op2, coissue)>, Requires<[IsWorker]>;

  def : InstAlias<"mov $op1, $op2", (OR64 ARPair:$op1, ARPair:$op2, AZEROS, coissue)>, Requires<[IsWorker]>;
  def : InstAlias<"movnz $op0, $op2, $op1", (MOVZ MR:$op0, MR:$op1, MR:$op2, coissue)>, Requires<[IsIpu1And2]>;

  def : InstAlias<"get $op1, $op2", (UGET AR:$op1, imm8zi:$op2, coissue)>, Requires<[IsWorker]>;
  def : InstAlias<"put $op1, $op0", (UPUT AR:$op0, imm8zi:$op1, coissue)>, Requires<[IsWorker]>;
  def : InstAlias<"swap16 $op0, $op1", (ROLL16 MR:$op0, MR:$op1, MR:$op1, coissue)>;
  def : InstAlias<"swap16 $op0, $op1", (ROLL16_A AR:$op0, AR:$op1, AR:$op1, coissue)>, Requires<[IsWorker]>;
  def : InstAlias<"strap", (PUT MZERO, 255, coissue)>, Requires<[IsIpu1And2]>;
}

//===----------------------------------------------------------------------===//
// IPU 2+
//===----------------------------------------------------------------------===//

#ifdef IPU2
def SORT4X16HI_BL : inst_sort4x16hi_aaal;
def F32SISOV2SLIC : inst_f32sisov2slic_aaan_ef;
#endif
