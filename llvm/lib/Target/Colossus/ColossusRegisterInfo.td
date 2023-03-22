//===-- ColossusRegisterInfo.td - Colossus Register defs ---*- tablegen -*-===//
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
//  Declarations that describe the Colossus register file
//===----------------------------------------------------------------------===//

class ColossusReg<bits<16> num, string n, list<string> alt = []> : Register<n> {
  field bits<16> Num;
  let Namespace = "Colossus";
  let HWEncoding = num;
  let AltNames = alt;
}

// Subregister indices.
let Namespace = "Colossus" in {
  // Register pairs.
  def SubRegLo : SubRegIndex<32>;
  def SubRegHi : SubRegIndex<32, 32>;
}

// Registers are identified with 4-bit ID numbers.
// 32-bit registers.
class R<bits<16> num, string n, list<string> alt = []> : ColossusReg<num, n, alt> {
  let Num = num;
}

// 64-bit register pairs.
class RP<bits<16> num, string n, list<Register> subregs, list<string> alt = []> :
    ColossusReg<num, n, alt> {
  let SubRegs = subregs;
  let SubRegIndices = [SubRegLo, SubRegHi];
  let CoveredBySubRegs = 1;
}

// 64-bit register pairs in the upper register file (these pairs cannot be accessed
// by single 32-bit registers
class RPU<bits<16> num, string n> :
    ColossusReg<num, n> {
}

// Memory registers.
foreach i = {0 - 7, 14} in {
  def M#i : R<i, "$m"#i>, DwarfRegNum<[i]>;
}

def BP : R<8, "$m8", ["$bp"]>, DwarfRegNum<[8]>;
def FP : R<9, "$m9", ["$fp"]>, DwarfRegNum<[9]>;
def LR : R<10, "$m10", ["$lr"]>, DwarfRegNum<[10]>;
def SP : R<11, "$m11", ["$sp"]>, DwarfRegNum<[11]>;

def MWORKER_BASE : R<12, "$m12", ["$mworker_base"]>, DwarfRegNum<[12]>;
def MVERTEX_BASE : R<13, "$m13", ["$mvertex_base"]>, DwarfRegNum<[13]>;

def MZERO : R<15, "$m15", ["$mzero"]>, DwarfRegNum<[15]>;

// Arithmetic registers.
foreach i = 0 - 14 in {
  def A#i : R<i, "$a"#i>, DwarfRegNum<[!add(i, 15)]>;
}

def AZERO : R<15, "$a15", ["$azero"]>, DwarfRegNum<[31]>;

// Aliases of the M/A registers (consecutive pairs) used for 64-bit load and
// stores.  Provide unique names here so they don't clash with the A/R*s. These
// are custom printed by 'print[M|A]PairOperand' in
// InstrPrinter/ColossusInstrPrinter.

def MD0 : RP<0,  "$m0:1",   [M0,  M1]>,  DwarfRegNum<[32]>;
def MD1 : RP<2,  "$m2:3",   [M2,  M3]>,  DwarfRegNum<[33]>;
def MD2 : RP<4,  "$m4:5",   [M4,  M5]>,  DwarfRegNum<[34]>;
def MD3 : RP<6,  "$m6:7",   [M6,  M7]>,  DwarfRegNum<[35]>;
def MD4 : RP<8,  "$m8:9",   [BP,  FP]>,  DwarfRegNum<[36]>;
def MD5 : RP<10, "$m10:11", [LR,  SP]>, DwarfRegNum<[37]>;
def MD6 : RP<12, "$m12:13", [MWORKER_BASE, MVERTEX_BASE]>, DwarfRegNum<[38]>;
def MD7 : RP<14, "$m14:15", [M14, MZERO]>, DwarfRegNum<[39]>;

def AD0 : RP<0, "$a0:1",   [A0,  A1], ["$ap0"]>,  DwarfRegNum<[40]>;
def AD1 : RP<1, "$a2:3",   [A2,  A3], ["$ap1"]>,  DwarfRegNum<[41]>;
def AD2 : RP<2, "$a4:5",   [A4,  A5], ["$ap2"]>,  DwarfRegNum<[42]>;
def AD3 : RP<3, "$a6:7",   [A6,  A7], ["$ap3"]>,  DwarfRegNum<[43]>;
def AD4 : RP<4,  "$a8:9",   [A8,  A9], ["$ap4"]>,  DwarfRegNum<[44]>;
def AD5 : RP<5, "$a10:11", [A10, A11], ["$ap5"]>, DwarfRegNum<[45]>;
def AD6 : RP<6, "$a12:13", [A12, A13], ["$ap6"]>, DwarfRegNum<[46]>;
def AZEROS : RP<15, "$a14:15", [A14, AZERO], ["$azeros", "$ap15"]>, DwarfRegNum<[47]>;

// Accumulator registers.
foreach i = 0 - 7 in {
  def ACC#i : R<i, ""#i>, DwarfRegNum<[!add(i, 52)]>;
}

def ACCD0 : RP<0, "0:1", [ACC0, ACC1]>, DwarfRegNum<[60]>;
def ACCD1 : RP<2, "2:3", [ACC2, ACC3]>, DwarfRegNum<[61]>;
def ACCD2 : RP<4, "4:5", [ACC4, ACC5]>, DwarfRegNum<[62]>;
def ACCD3 : RP<6, "6:7", [ACC6, ACC7]>, DwarfRegNum<[63]>;

foreach i = 7 - 14 in {
  def AD#i : RPU<i, "$ap"#i>, DwarfRegNum<[!add(i, 66)]>;
}

// TODO: reorder class register sequences based on calling convention/
// reserved registers.

let Size = 32 /*The spill size in bits of the register class.*/ in {
// Memory register class.
def MR : RegisterClass<"Colossus", [i32, v2i16], /*alignment=*/ 32,
                       (add (sequence "M%u", 0, 7), BP, FP, LR, SP,
                         MWORKER_BASE, MVERTEX_BASE,
                          M14, MZERO)>;
// Arithmetic register class.
def AR : RegisterClass<"Colossus", [f32, f16, v2f16], /*alignment=*/ 32,
                       (add (sequence "A%u", 0, 14), AZERO)>;
// Accumulator register class.
def ACC : RegisterClass<"Colossus", [f32], /*alignment=*/ 32,
                        (add (sequence "ACC%u", 0, 7))>;
}

// Even-odd pairs of M/A.
let Size = 64 in {
def MRPair : RegisterClass<"Colossus", [v2i32, v4i16], /*alignment=*/ 64,
                           (add (sequence "MD%u", 0, 7))>;
def ARPair : RegisterClass<"Colossus", [v2f32, v4f16], /*alignment=*/ 64,
                           (add (sequence "AD%u", 0, 14), AZEROS)>;
def ACCPair : RegisterClass<"Colossus", [v2f32], /*alignment=*/ 64,
                            (add ACCD0, ACCD1, ACCD2, ACCD3)>;
}

// Subregister indices.
let Namespace = "Colossus" in {
  // Register quad pairs.
  def QuadLo : SubRegIndex<64>;
  def QuadHi : SubRegIndex<64, 64>;

  def QuadAR0 : SubRegIndex<32>;
  def QuadAR1 : SubRegIndex<32, 32>;
  def QuadAR2 : ComposedSubRegIndex<QuadHi, QuadAR0>;
  def QuadAR3 : ComposedSubRegIndex<QuadHi, QuadAR1>;
  // Register octad pairs.
  def OctadLo : SubRegIndex<128>;
  def OctadHi : SubRegIndex<128, 128>;
}

// 128-bit register quads.
class RQ<bits<16> num, string n, list<Register> subregs, list<string> alt = []> :
    ColossusReg<num, n, alt> {
  let SubRegs = subregs;
  let SubRegIndices = [QuadLo, QuadHi];
  let CoveredBySubRegs = 1;
}

class RQU<bits<16> num, string n> :
    ColossusReg<num, n> {
}

// 256-bit register octads.
class RO<bits<16> num, string n, list<Register> subregs, list<string> alt = []> :
   ColossusReg<num, n, alt> {
 let SubRegs = subregs;
 let SubRegIndices = [OctadLo, OctadHi];
 let CoveredBySubRegs = 1;
}

class ROU<bits<16> num, string n> :
    ColossusReg<num, n> {
}

def AQ0 : RQ<0, "$a0:3",   [AD0, AD1], ["$aq0"]>, DwarfRegNum<[48]>;
def AQ1 : RQ<1, "$a4:7",   [AD2, AD3], ["$aq1"]>, DwarfRegNum<[49]>;
def AQ2 : RQ<2, "$a8:11",  [AD4, AD5], ["$aq2"]>, DwarfRegNum<[50]>;
def AQZERO : RQ<15, "$a12:15", [AD6, AZEROS], ["$aq15"]>, DwarfRegNum<[51]>;

def ACCQ0 : RQ<0, "0:3", [ACCD0, ACCD1]>, DwarfRegNum<[64]>;
def ACCQ1 : RQ<4, "4:7", [ACCD2, ACCD3]>, DwarfRegNum<[65]>;

 foreach i = 3 - 14 in {
   def AQ#i : RQU<i, "$aq"#i>, DwarfRegNum<[!add(i, 75)]>;
 }

 def AO0 : RO<0,  "$a0:7",   [AQ0, AQ1], ["$ao0"]>, DwarfRegNum<[76]>;
 def AOZERO : RO<4,  "$a8:15",  [AQ2, AQ3], ["$ao1"]>, DwarfRegNum<[77]>;

  foreach i = 1 - 14 in {
   def AO#i : ROU<i, "$ao"#i>, DwarfRegNum<[!add(i, 78)]>;
 }
 

// Quads of A.
let Size = 128 in {
def ARQuad : RegisterClass<"Colossus", [v4f32], /*alignment=*/ 64,
                           (add (sequence "AQ%u", 0, 14), AQZERO)>;
def ACCQuad : RegisterClass<"Colossus", [v4f32], /*alignment=*/ 64,
                            (add ACCQ0, ACCQ1)>;
}

// Octads of A 
let Size = 256 in {
  def AROctad : RegisterClass<"Colossus", [v8f32], /*alignment=*/ 64,
                          (add (sequence "AO%u", 0, 14), AOZERO)>;
}

