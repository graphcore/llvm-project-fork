//===- ColossusCallingConv.td ------------------------------*- tablegen -*-===//
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
// This describes the calling conventions for Colossus architecture.
//===----------------------------------------------------------------------===//

//===----------------------------------------------------------------------===//
// Colossus Return Value Calling Convention
//===----------------------------------------------------------------------===//

def RetCC_Colossus : CallingConv<[
  // Promote subword types to i32.
  CCIfType<[i8, i16], CCPromoteToType<i32>>,

  // i32 are returned in registers M0 - M3.
  CCIfType<[i32, v2i16], CCAssignToReg<[M0, M1, M2, M3]>>,
  CCIfType<[v2i32, v4i16], CCAssignToReg<[MD0, MD1]>>,

  // f32 and float vectors are returned in registers A0 - A5.
  CCIfType<[f32, f16, v2f16], CCAssignToReg<[A0, A1, A2, A3, A4, A5]>>,
  CCIfType<[v2f32, v4f16], CCAssignToReg<[AD0, AD1, AD2]>>
]>;

def RetCC_Colossus_Vertex : CallingConv<[
  CCIfType<[i32], CCAssignToReg<[M0]>>
]>;

//===----------------------------------------------------------------------===//
// Colossus Argument Calling Conventions
//===----------------------------------------------------------------------===//

def CC_Colossus_VarArg : CallingConv<[
  // All arguments of a variadic function are passed via memory.
  CCIfType<[i32, f32], CCAssignToStack<4, 4>>
]>;

def CC_Colossus_NonVarArg : CallingConv<[
  // The first 4 integer arguments are passed in M registers.
  CCIfType<[i32, v2i16], CCAssignToReg<[M0, M1, M2, M3]>>,
  CCIfType<[v2i32, v4i16], CCAssignToReg<[MD0, MD1]>>,

  // The first 6 f32 or float vector arguments are passed in A registers.
  CCIfType<[f32, f16, v2f16], CCAssignToReg<[A0, A1, A2, A3, A4, A5]>>,
  CCIfType<[v2f32, v4f16], CCAssignToReg<[AD0, AD1, AD2]>>,

  // Integers and floats get stored in 4-byte stack slots with 4-byte alignment.
  CCIfType<[i32, f32, f16, v2i16, v2f16], CCAssignToStack<4, 4>>,

  // 8-byte vectors in 8-byte stack slots with 8-byte alignment.
  CCIfType<[v2i32, v2f32, v4i16, v4f16], CCAssignToStack<8, 8>>
]>;

def CC_Colossus : CallingConv<[
  // Promote subword types to i32.
  CCIfType<[i8, i16], CCPromoteToType<i32>>,

  // If there is a var arg, use the VarArc CC.
  CCIfVarArg<CCDelegateTo<CC_Colossus_VarArg>>,

  // Otherwise, use the regular calling convention.
  CCIfNotVarArg<CCDelegateTo<CC_Colossus_NonVarArg>>
]>;

// Callee-save registers (including LR).
def CC_Save : CalleeSavedRegs<(add M7, BP, FP, LR, A6, A7)>;

// Callee-save registers when using a base pointer (BP reserved).
def CC_Save_BP : CalleeSavedRegs<(add M7, FP, LR, A6, A7)>;

// Callee-save registers when using a frame pointer (FP is reserved).
def CC_Save_FP : CalleeSavedRegs<(add M7, BP, LR, A6, A7)>;

// Callee-save registers when using both base pointer and frame pointer
def CC_Save_BP_AND_FP : CalleeSavedRegs<(add M7, LR, A6, A7)>;

// There are no callee-save registers for vertex functions.
def CC_Save_Vertex : CalleeSavedRegs<(add)>;
