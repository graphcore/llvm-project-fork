//===- ColossusSchedule.td - Colossus Scheduling Definitions -*- tablegen -*-=//
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
 
// As an exception, if, as a result of your compiling your source code, portions
// of this Software are embedded into an Object form of such source code, you
// may redistribute such embedded portions in such Object form without complying
// with the conditions of Sections 4(a), 4(b) and 4(d) of the License.
 
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
// This file defines the SchedRead/Write data for the Colossus processor.
//
//===----------------------------------------------------------------------===//

// ===---------------------------------------------------------------------===//
// Colossus is an in-order superscalar microprocessor. It can issue a maximum
// of two instructions per cycle. There's one ALU+LSU+branch unit (main) and a
// FPU. This scheduler is a MachineScheduler. See TargetSchedule.td for
// details.

class ColossusModel<int width> : SchedMachineModel {
  let MicroOpBufferSize = 1; // Colossus is an in-order processor.
  let IssueWidth = width;    // Micro-ops per cycle depends on whether bundling
                             // is enabled.
  let LoadLatency = 1;       // All loads take 1 cycle.
  let MispredictPenalty = 0; // No branch predictor, all branches take 1 cycle.
  let PostRAScheduler = 0;   // Disable post RegAlloc Scheduler pass. Itinerary
                             // class info should be added if enabling it for
                             // it to understand coissue.
  let CompleteModel = 1;     // Scheduling model covers all instructions.
}

// 2 micro-ops dispatched per cycle.
def ColossusCoissuedModel : ColossusModel<2>;

// No co-issue, 1 micro-ops dispatched per cycle.
def ColossusSingleIssuedModel : ColossusModel<1>;


//===----------------------------------------------------------------------===//
// Define each kind of processor resource and number available.

// Modeling each pipeline as a ProcResource using the BufferSize = 0 since
// Colossus is an in-order processor.

def ColossusUnitMain   : ProcResource<1> { let BufferSize = 0; } // IALU & LSU
def ColossusUnitAux    : ProcResource<1> { let BufferSize = 0; } // AUX


//===----------------------------------------------------------------------===//
// SchedWrite types which map instructions to ProcResources.

def WriteMain : SchedWrite;
def WriteFreeMain : SchedWrite;
def WriteAux : SchedWrite;
def WriteFreeAux : SchedWrite;
def WriteFreeCopy : SchedWrite;


//===----------------------------------------------------------------------===//
// Subtarget-specific ProcResources set latency of SchedWrites.

foreach ColossusModel = [ColossusCoissuedModel, ColossusSingleIssuedModel] in {
  let SchedModel = ColossusModel in {

    def : WriteRes<WriteMain, [ColossusUnitMain]> { let Latency = 1; }
    def : WriteRes<WriteFreeMain, [ColossusUnitMain]> {
      let ResourceCycles = [0];
      let Latency = 1;
      let NumMicroOps = 0;
    }
    def : WriteRes<WriteAux, [ColossusUnitAux]> { let Latency = 1; }

    // Assume COPY won't generate any instruction.
    def : WriteRes<WriteFreeCopy, [ColossusUnitMain]> {
      let ResourceCycles = [0];
      let Latency = 0;
      let NumMicroOps = 0;
    }
    def : InstRW<[WriteFreeCopy], (instrs COPY)>;
} // SchedModel
} // foreach ColossusModel
