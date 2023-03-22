//===-- ColossusISelLowering.h - Colossus DAG Lowering ----------*- C++ -*-===//
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
// This file defines the interfaces that Colossus uses to lower LLVM code into a
// selection DAG.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_COLOSSUS_COLOSSUSISELLOWERING_H
#define LLVM_LIB_TARGET_COLOSSUS_COLOSSUSISELLOWERING_H

#include "Colossus.h"
#include "ColossusISDOpcodes.h"
#include "llvm/ADT/Optional.h"
#include "llvm/CodeGen/SelectionDAG.h"
#include "llvm/CodeGen/TargetLowering.h"
#include <set>

namespace llvm {

  // Forward delcarations
  class ColossusSubtarget;
  class ColossusTargetMachine;

  //===--------------------------------------------------------------------===//
  // TargetLowering Implementation
  //===--------------------------------------------------------------------===//

  class ColossusTargetLowering : public TargetLowering {
  public:
    explicit ColossusTargetLowering(const TargetMachine &TM,
                                    const ColossusSubtarget &Subtarget);

    /// Returns the name of a target specific DAG node.
    const char *getTargetNodeName(unsigned Opcode) const override;

    /// Provide custom lowering hooks for some operations.
    void ReplaceNodeResults(SDNode *N, SmallVectorImpl<SDValue> &Results,
                            SelectionDAG &DAG) const override;
    void LowerOperationWrapper(SDNode *N, SmallVectorImpl<SDValue> &Results,
                               SelectionDAG &DAG) const override;
    SDValue LowerOperation(SDValue Op, SelectionDAG &DAG) const override;

    SDValue PerformDAGCombine(SDNode *N, DAGCombinerInfo &DCI) const override;

    MachineBasicBlock *
      EmitInstrWithCustomInserter(MachineInstr &MI,
                                  MachineBasicBlock *MBB) const override;

    virtual const TargetRegisterClass *
    getRegClassFor(MVT VT, bool isDivergent = false) const override;

    bool isCheapToSpeculateCtlz() const override { return true; }
    bool isCheapToSpeculateCttz() const override { return true; }

    /// Fused multiply add formation.
    bool enableAggressiveFMAFusion(EVT VT) const override;
    bool isFMAFasterThanFMulAndFAdd(const MachineFunction &MF,
                                    EVT VT) const override;

    /// Return the ISD::SETCC ValueType.
    EVT getSetCCResultType(const DataLayout &, LLVMContext &,
                           EVT VT) const override;

    /// Return true if the specified immediate is legal icmp immediate, that is
    /// the target has icmp instructions which can compare a register against the
    /// immediate without having to materialize the immediate into a register.
    bool isLegalICmpImmediate(int64_t Imm) const override;

    /// isLegalAddImmediate - Return true if the specified immediate is legal
    /// add immediate, that is the target has add instructions which can
    /// add a register and the immediate without having to materialize
    /// the immediate into a register.
    bool isLegalAddImmediate(int64_t Imm) const override;

    // In some cases ShrinkDemandedConstant results in an expensive constant
    // materialization with an and instruction instead of a cheaper andc. Use
    // this hook to bail out of modififying the constant in such a case.
    bool targetShrinkDemandedConstant(SDValue Op, const APInt &DemandedBits,
                                      const APInt &DemandedElts,
                                      TargetLoweringOpt &TLO) const override;

    // Functions used by DAGToDAG
    static llvm::Optional<uint64_t> SDValueToUINT64(SDValue, SelectionDAG &);
    static SDValue exactDivideConstant(SelectionDAG *DAG, SDValue val, int64_t by);
    static SDValue exactDivideVariable(SelectionDAG *DAG, SDValue val, int64_t by);
    static void PostprocessForDAGToDAG(SelectionDAG*, const ColossusSubtarget &);

  private:
    const ColossusSubtarget &Subtarget;

    /// Last bitcast operand seen as a result of a DAG optimisation.
    mutable SDValue LastBitcastOp;
    /// Number of cycle checks since the bitcast operand was seen or revisited.
    mutable unsigned NumRoundsSinceLastBitcastOp = 0;
    /// Saved number of cycle checks after the same bitcast operand is seen.
    mutable Optional<unsigned> SavedNumRounds;

    bool isLikelyDAGCombineCycle(SDValue R) const;

    void LowerFP16ToInt(SDNode *N, SmallVectorImpl<SDValue> &Results,
                        SelectionDAG &DAG) const;
    void LowerIntToFP16(SDNode *N, SmallVectorImpl<SDValue> &Results,
                        SelectionDAG &DAG) const;

    bool softPromoteHalfType() const override { return true; }

    SDValue LowerBlockAddress(SDValue Op, SelectionDAG& DAG) const;
    SDValue LowerConstantPool(SDValue Op, SelectionDAG& DAG) const;
    SDValue LowerGlobalAddress(SDValue Op, SelectionDAG& DAG) const;
    SDValue LowerJumpTable(SDValue Op, SelectionDAG& DAG) const;
    SDValue LowerFLT_ROUNDS_(SDValue Op, SelectionDAG &DAG) const;
    SDValue LowerFRAME_TO_ARGS_OFFSET(SDValue Op, SelectionDAG &DAG) const;
    SDValue LowerINTRINSIC_W_CHAIN(SDValue Op, SelectionDAG &DAG) const;
    SDValue LowerINTRINSIC_WO_CHAIN(SDValue Op, SelectionDAG &DAG) const;
    SDValue LowerINTRINSIC_VOID(SDValue Op, SelectionDAG &DAG) const;
    SDValue LowerRETURNADDR(SDValue Op, SelectionDAG &DAG) const;
    SDValue LowerMUL(SDValue Op, SelectionDAG &DAG) const;
    SDValue LowerSETCC(SDValue Op, SelectionDAG &DAG) const;
    SDValue LowerLOAD(SDValue Op, SelectionDAG &DAG) const;
    SDValue LowerSTORE(SDValue Op, SelectionDAG &DAG) const;
    SDValue LowerStoreToLibcall(SDValue Op, SelectionDAG &DAG) const;
    SDValue LowerSIGN_EXTEND_INREG(SDValue Op, SelectionDAG &DAG) const;
    SDValue LowerUDIV(SDValue Op, SelectionDAG &DAG) const;
    SDValue LowerUREM(SDValue Op, SelectionDAG &DAG) const;
    SDValue LowerMULHX(SDValue Op, SelectionDAG &DAG) const;
    SDValue LowerXMUL_LOHI(SDValue Op, SelectionDAG &DAG) const;
    SDValue LowerFP_ROUND(SDValue Op, SelectionDAG &DAG) const;
    SDValue LowerVAARG(SDValue Op, SelectionDAG &DAG) const;
    SDValue LowerVASTART(SDValue Op, SelectionDAG &DAG) const;
    SDValue LowerVECTOR_SHUFFLE(SDValue Op, SelectionDAG &DAG) const;
    SDValue LowerSCALAR_TO_VECTOR(SDValue Op, SelectionDAG &DAG) const;
    SDValue LowerATOMIC_FENCE(SDValue Op, SelectionDAG &DAG) const;
    SDValue LowerATOMIC_LOAD(SDValue Op, SelectionDAG &DAG) const;
    SDValue LowerATOMIC_STORE(SDValue Op, SelectionDAG &DAG) const;
    SDValue recursiveLowerFPOperation(SDValue Op, SelectionDAG &DAG) const;
    SDValue LowerFNEG(SDValue Op, SelectionDAG &DAG) const;
    SDValue LowerLibmIntrinsic(SDValue Op, SelectionDAG &DAG) const;
    SDValue LowerFABSorFCOPYSIGN(SDValue Op, SelectionDAG &DAG) const;
    SDValue LowerSMINorSMAX(SDValue Op, SelectionDAG &DAG) const;

    bool shouldInsertFencesForAtomic(const Instruction *I) const override {
      // Request a fence for ATOMIC_* instructions, to reduce them to
      // Monotonic. Since Colossus is always SequentiallyConsistent, the fence
      // gets dropped once lowered in ColossusMCELFStreamer::emitInstruction().
      // When outputing assembly, it gets output as a comment.
      return true;
    }

    SDValue LowerCall(TargetLowering::CallLoweringInfo &CLI,
                      SmallVectorImpl<SDValue> &InVals) const override;

    SDValue
    LowerFormalArguments(SDValue Chain,
                         CallingConv::ID CallConv,
                         bool isVarArg,
                         const SmallVectorImpl<ISD::InputArg> &Ins,
                         const SDLoc &dl,
                         SelectionDAG &DAG,
                         SmallVectorImpl<SDValue> &InVals) const override;

    bool CanLowerReturn(CallingConv::ID CallConv,
                        MachineFunction &MF,
                        bool isVarArg,
                        const SmallVectorImpl<ISD::OutputArg> &ArgsFlags,
                        LLVMContext &Context) const override;

    SDValue LowerReturn(SDValue Chain,
                        CallingConv::ID CallConv,
                        bool isVarArg,
                        const SmallVectorImpl<ISD::OutputArg> &Outs,
                        const SmallVectorImpl<SDValue> &OutVals,
                        const SDLoc &dl,
                        SelectionDAG &DAG) const override;

    // Inline assembly support.
    std::pair<unsigned, const TargetRegisterClass*>
    getRegForInlineAsmConstraint(const TargetRegisterInfo *TRI,
                                 StringRef Constraint,
                                 MVT VT) const override;

    MachineBasicBlock *expandFPSelect(MachineInstr *MI,
                                      MachineBasicBlock *MBB) const;

    bool getPostIndexedAddressParts(SDNode *N,
                                    SDNode *Op,
                                    SDValue &Base,
                                    SDValue &Offset,
                                    ISD::MemIndexedMode &AM,
                                    SelectionDAG &DAG) const override;

    SDValue PerformDAGOptimisation(SDNode *, DAGCombinerInfo &) const;
    SDValue PerformDAGCanonicalisation(SDNode *, DAGCombinerInfo &) const;
  };
}
#endif
