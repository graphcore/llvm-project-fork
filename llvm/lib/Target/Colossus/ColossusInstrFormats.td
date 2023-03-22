//===-- ColossusInstrFormats.td - Colossus Instr Formats ---*- tablegen -*-===//
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

//===----------------------------------------------------------------------===//
// Instruction format superclass
//===----------------------------------------------------------------------===//

class InstColossus : Instruction {
  let Namespace = "Colossus";
}

// Pseudo instructions.
class Pseudo<dag outs, dag ins, string asmstr, list<dag> pattern> :
  InstColossus {
  let isPseudo = 1;
  let hasNoSchedulingInfo = 1;
  let Size = 0;
  let OutOperandList = outs;
  let InOperandList = ins;
  let AsmString   = asmstr;
  let Pattern = pattern;
  let isCodeGenOnly = 1;
}

// Pseudo instructions.
class AsmPseudo<dag outs, dag ins, string asmstr, list<dag> pattern> :
  InstColossus {
  let isPseudo = 1;
  let hasNoSchedulingInfo = 1;
  let Size = 0;
  let OutOperandList = outs;
  let InOperandList = ins;
  let AsmString   = asmstr;
  let Pattern = pattern;
  let isCodeGenOnly = 0;
}

// Real instructions (have encoding information).
class EncodedIBase : InstColossus {
  bits<1> LaneNumber = 0;
  bits<1> CanCoIssue = 0;
  bits<1> SystemInstruction = 0;
  bits<1> ControlInstruction = 0;
  let TSFlags{22} = LaneNumber;
  let TSFlags{23} = ControlInstruction;
  let TSFlags{24} = SystemInstruction;
  let TSFlags{25} = CanCoIssue;
}

class EncodedI : EncodedIBase {
  let Size = 4;
  field bits<32> Inst;
  field bits<32> SoftFail = 0;
  
}

class EncodedI64 : EncodedIBase {
  let Size = 8;
  field bits<64> Inst;
  field bits<64> SoftFail = 0;
  list<Predicate> Predicates = [IsSupervisor];
}

class EncodedWorkerI : EncodedI {
  list<Predicate> Predicates = [IsWorker];  
}

class EncodedSupervisorI : EncodedI {
  list<Predicate> Predicates = [IsSupervisor];
}

// One-bit flag operand.
class Flag<int Default=0> : OperandWithDefaultOps<i1, (ops (i1 Default))>;

// Address fields for memory instruction formats. Each format has a delta
// offset register field, for reg-reg or reg-imm addressing modes this field is
// set to a zero register.

// Instructions with three 4-bit source registers operands
class FM3X2   { bits<8>addr; } 
// Instructions with 3 x 4-bit MRF source register operands and a 1 x 4-bit MRF
// or ARF destination register operand.
class FM3D    { bits<12>addr; }
// Instructions with three 4-bit source registers operands
class FM3I3   { bits<20>addr; }
// 2 x 4-bit MRF register source operands, plus 1 x 12-bit immediate and 
// 1 x 4-bit MRF or ARF destination register.
class FMDMI3  { bits<20>addr; }
// 3 x 4-bit MRF source register operands plus 1 x 4-bit ARF source register
//operand.
class FM3A    { bits<12>addr; }
// 2 x 4-bit MRF source register operands, plus 1 x 4-bit ARF source operand
// with 1 x 12-bit immediate. The immediate operand is split across 3 separate
// fields.
class FMIMIAI { bits<20>addr; }
class FM2AI   { bits<16>addr; }