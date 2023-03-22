//===-- Colossus.td - Describe the Colossus Target Machine -*- tablegen -*-===//
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
// This is the top level entry point for the Colossus target.
//
//===----------------------------------------------------------------------===//

//===----------------------------------------------------------------------===//
// Target-independent interfaces which we are implementing
//===----------------------------------------------------------------------===//

include "llvm/Target/Target.td"

//===----------------------------------------------------------------------===//
// Descriptions
//===----------------------------------------------------------------------===//

// Features
def ModeWorker : SubtargetFeature<"worker", "ExecutionMode", "Worker",
                                  "Worker mode">;
def ModeSupervisor : SubtargetFeature<"supervisor", "ExecutionMode",
                                      "Supervisor", "Supervisor mode">;
def ModeBoth : SubtargetFeature<"both", "ExecutionMode", "Both", "Both mode">;

foreach i = [1, 2, 21] in {
def ModeArchIpu#i : SubtargetFeature<"ipu"#i,
"ColossusArchVersion", "Ipu"#i, "IPU target architecture">;
}

// Predicates
def IsSupervisor : Predicate<"Subtarget->isSupervisorMode()">,
                   AssemblerPredicate<(all_of ModeSupervisor), "Supervisor mode">;
def IsWorker : Predicate<"!Subtarget->isSupervisorMode()">,
               AssemblerPredicate<(all_of (not ModeSupervisor)), "Worker mode">;

def IsIpu1And2 : Predicate<"Subtarget->isIpu1And2()">,
             AssemblerPredicate<(any_of ModeArchIpu1, ModeArchIpu2, ModeArchIpu21), "IPU1 - IPU2 target architecture">;

def IsIpu2Plus : Predicate<"Subtarget->isIpu2Plus()">,
                 AssemblerPredicate<(all_of (not ModeArchIpu1)), "IPU2+ target architecture">;

def IsIpu21Plus : Predicate<"Subtarget->isIpu21Plus()">,
                 AssemblerPredicate<(all_of (not ModeArchIpu1), (not ModeArchIpu2)), "IPU2.1+ target architecture">;

def NoNaNsFPMath :    Predicate<"TM.Options.NoNaNsFPMath">;


include "ColossusRegisterInfo.td"
include "ColossusInstrInfo.td"
include "ColossusCallingConv.td"

def ColossusInstrInfo : InstrInfo;

//===----------------------------------------------------------------------===//
// Colossus processors supported.
//===----------------------------------------------------------------------===//

class Proc<string Name, list<SubtargetFeature> Features>
 : ProcessorModel<Name, ColossusCoissuedModel, Features>;

foreach i = [1, 2, 21] in {
  def : Proc<"ipu"#i, [!cast<SubtargetFeature>("ModeArchIpu"#i)]>;
}

def : Proc<"ipu-generic", []>;
def : ProcessorModel<"ipu-generic-single-issue", ColossusSingleIssuedModel, []>;

//===----------------------------------------------------------------------===//
// Declare the target which we are implementing
//===----------------------------------------------------------------------===//

def ColossusAsmWriter : AsmWriter {
  string AsmWriterClassName  = "InstPrinter";
  int PassSubtarget = 1;
  int Variant = 0;
}

def ColossusAsmParser : AsmParser {
  let ShouldEmitMatchRegisterAltName = 1;
  let AllowDuplicateRegisterNames = 1;
}

def Colossus : Target {
  // Pull in Instruction Info:
  let InstructionSet = ColossusInstrInfo;
  let AssemblyWriters = [ColossusAsmWriter];
  let AssemblyParsers = [ColossusAsmParser];
}

