//===-- ColossusISelDAGToDAG.cpp - DAG to DAG inst selector for Colossus --===//
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
// This file defines an instruction selector for the Colossus target to convert
// a legalized DAG into a Colossus-specific DAG, ready for instruction
// scheduling.
//
//===----------------------------------------------------------------------===//

#include "Colossus.h"
#include "ColossusSubtarget.h"
#include "ColossusTargetMachine.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/CodeGen/MachineFrameInfo.h"
#include "llvm/CodeGen/MachineFunction.h"
#include "llvm/CodeGen/MachineInstrBuilder.h"
#include "llvm/CodeGen/MachineRegisterInfo.h"
#include "llvm/CodeGen/SelectionDAG.h"
#include "llvm/CodeGen/SelectionDAGISel.h"
#include "llvm/IR/CallingConv.h"
#include "llvm/IR/Constants.h"
#include "llvm/IR/DerivedTypes.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/Intrinsics.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/Support/Compiler.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Support/KnownBits.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/CodeGen/TargetLowering.h"
#include <limits>

using namespace llvm;

#define DEBUG_TYPE "colossus-dag-to-dag"

/// ColossusDAGToDAGISel - Colossus specific code to select Colossus machine
/// instructions for SelectionDAG operations.
///
namespace {
  using CTL = ColossusTargetLowering;

  class ColossusDAGToDAGISel : public SelectionDAGISel {
    const ColossusSubtarget *Subtarget;

    bool HandleBaseRegOffset(SDValue &LHS, SDValue &RHS,
                             SDValue &Base, SDValue &Offset, unsigned Size);
    bool HandleBaseImmOffset(SDValue &LHS, SDValue &RHS,
                             SDValue &Base, SDValue &Offset, unsigned Size);
    bool HandleADDRrr(SDValue Addr, SDValue &Base,
                      SDValue &Offset, unsigned Size);
    bool HandleADDRri(SDValue Addr, SDValue &Base,
                      SDValue &Offset, unsigned Size);
    bool HandleADDRfi(SDValue Addr, SDValue &Base,
                      SDValue &Offset, unsigned Size);
    bool HandleADDRrrr(SDValue Addr, SDValue &Base, SDValue &Delta,
                       SDValue &Offset, unsigned Size);
    bool HandleADDRrri(SDValue Addr, SDValue &Base, SDValue &Delta,
                       SDValue &Offset, unsigned Size);

    SDNode *SelectPostIncLoad(SDNode *Op);
    SDNode *SelectPostIncStore(SDNode *Op);
    SDNode *SelectViaZeroRegister(SDNode *Op);
    SDNode *ReplaceWithLDB16(SDNode *N);
    SDNode *ReplaceWithF16AS(SDNode *N);
    SDNode *SelectConstant(SDNode *Op);

  public:
    ColossusDAGToDAGISel(ColossusTargetMachine &TM, CodeGenOpt::Level OptLevel)
      : SelectionDAGISel(TM, OptLevel)
      { }

    bool runOnMachineFunction(MachineFunction &MF) override {
      Subtarget = &MF.getSubtarget<ColossusSubtarget>();
      const Function &F = MF.getFunction();

      if ((F.getCallingConv() == CallingConv::Colossus_Vertex) &&
          !Subtarget->isWorkerMode()) {
        report_fatal_error("in function '" + Twine(F.getName()) + "': "
            "colossus_vertex calling convention is only applicable to 'worker' "
            "functions but '" + Twine(F.getName()) + "' is being compiled as a "
            "'" + Twine(Subtarget->getExecutionModeName()) + "' function");
      }

      return SelectionDAGISel::runOnMachineFunction(MF);
    }

    void PreprocessISelDAG() override;
    void Select(SDNode *N) override;

    // Complex patterns for addressing modes.
    template<int> bool
    SelectADDRrr(SDValue Addr, SDValue &Base, SDValue &Offset);

    template<int> bool
    SelectADDRri(SDValue Addr, SDValue &Base, SDValue &Offset);

    template<int> bool
    SelectADDRrrr(SDValue Addr, SDValue &Base, SDValue &Delta, SDValue &Offset);

    template<int> bool
    SelectADDRrri(SDValue Addr, SDValue &Base, SDValue &Delta, SDValue &Offset);

    template<int> bool
    SelectADDRfi(SDValue Addr, SDValue &Base, SDValue &Offset);

    // Inline assembly memory operands.
    bool SelectAddr(SDNode *Op, SDValue Addr, SDValue &Base, SDValue &Offset);
    bool SelectInlineAsmMemoryOperand(const SDValue &Op,
                                      unsigned ConstraintID,
                                      std::vector<SDValue> &OutOps) override;

    // If a given load/store can be turned into a post-inc load/store, derive
    // the base and delta addresses.
    void SelectAddrForPostInc(SDNode *N, SDValue Addr, SDValue &Base,
                              SDValue &Delta);
    SDValue getPostIncAddress(SDNode *OldMem, SDNode *NewMem, SDValue Addr);

    /// Return a target constant with the specified value, of type i32.
    inline SDValue getI32Imm(unsigned Imm, SDLoc dl) {
      return CurDAG->getTargetConstant(Imm, dl, MVT::i32);
    }

    StringRef getPassName() const override {
      return "Colossus DAG->DAG Pattern Instruction Selection";
    }

    // Include the pieces autogenerated from the target description.
    #include "ColossusGenDAGISel.inc"
  };

unsigned getShiftVal(unsigned Size) {
  switch (Size) {
  default: report_fatal_error("Unsupported shift value");
  case 64: return 3;
  case 32: return 2;
  case 16: return 1;
  case 8:  return 0;
  }
}

/// llvm/Support/Math.h's isShiftedInt()/isShiftedUInt with non-templated shift.
template<int Size>
bool isShiftedInt(int64_t Value, unsigned Shift) {
  return isInt<Size>(Value >> Shift) && Value % (1 << Shift) == 0;
}
template<int Size>
bool isShiftedUInt(uint64_t Value, unsigned Shift) {
  return isUInt<Size>(Value >> Shift) && Value % (1 << Shift) == 0;
}

}  // end anonymous namespace

void ColossusDAGToDAGISel::PreprocessISelDAG() {
  CTL::PostprocessForDAGToDAG(CurDAG, *Subtarget);
  LLVM_DEBUG(dbgs() << "Preprocessed selection DAG:\n"; CurDAG->dump(););
}

static bool isADD(SelectionDAG *CurDAG, SDValue Op) {
  if (Op.getOpcode() == ISD::ADD) {
    return true;
  }
  // An OR is equivalent to an ADD iff any 1s in LHS are disjoint from any
  // 1s in RHS. This is because LLVM canonicalises ADD to OR in this case.
  if (Op.getOpcode() == ISD::OR) {
    KnownBits KnownLHS, KnownRHS;
    KnownLHS = CurDAG->computeKnownBits(Op.getOperand(0));
    KnownRHS = CurDAG->computeKnownBits(Op.getOperand(1));
    uint64_t NonZeroBitsLHS = (~KnownLHS.Zero).getZExtValue();
    uint64_t NonZeroBitsRHS = (~KnownRHS.Zero).getZExtValue();
    return (NonZeroBitsLHS & NonZeroBitsRHS) == 0;
  }
  return false;
}

bool ColossusDAGToDAGISel::
HandleBaseRegOffset(SDValue &LHS, SDValue &RHS,
                    SDValue &Base, SDValue &Offset,
                    unsigned Size) {
  // Addr = base + (x << y).
  if (RHS.getOpcode() == ISD::SHL) {
    ConstantSDNode *ShiftConst = dyn_cast<ConstantSDNode>(RHS.getOperand(1));
    if (ShiftConst && ShiftConst->getSExtValue() == getShiftVal(Size)) {
      Base = LHS;
      Offset = RHS.getOperand(0);
      return true;
    }
  }
  // For 8-bit memory accesses, the offset is not scaled.
  if (Size == 8 && !isa<ConstantSDNode>(RHS)) {
    Base = LHS;
    Offset = RHS;
    return true;
  }
  return false;
}

bool ColossusDAGToDAGISel::
HandleBaseImmOffset(SDValue &LHS, SDValue &RHS,
                    SDValue &Base, SDValue &Offset,
                    unsigned Size) {
  // Addr = base + scaled immediate offset.
  if (ConstantSDNode *Constant = dyn_cast<ConstantSDNode>(RHS)) {
    int64_t OffsetVal = Constant->getSExtValue();
    if (OffsetVal >=0 && isShiftedUInt<12>(OffsetVal, getShiftVal(Size))) {
      int64_t ScaledOffsetVal = OffsetVal >> getShiftVal(Size);
      Base = LHS;
      Offset =
        CurDAG->getTargetConstant(ScaledOffsetVal, SDLoc(RHS), MVT::i32);
      return true;
    }
  }
  return false;
}

/// Handle base reg + offset reg.
/// Size is the size of the memory access.
/// Return true if it matches, false otherwise.
bool ColossusDAGToDAGISel::
HandleADDRrr(SDValue Addr, SDValue &Base, SDValue &Offset, unsigned Size) {
  // Addr = base register + scaled register offset.
  // Note that base register can be a frame index.
  if (isADD(CurDAG, Addr)) {
    SDValue LHS = Addr.getOperand(0);
    SDValue RHS = Addr.getOperand(1);
    if (HandleBaseRegOffset(LHS, RHS, Base, Offset, Size)) {
      return true;
    }
  }
  return false;
}

/// Handle base reg + offset imm.
bool ColossusDAGToDAGISel::
HandleADDRri(SDValue Addr, SDValue &Base, SDValue &Offset, unsigned Size) {
  // Addr = base register + scaled immediate offset.
  if (isADD(CurDAG, Addr)) {
    SDValue LHS = Addr.getOperand(0);
    SDValue RHS = Addr.getOperand(1);
    if (LHS.getOpcode() != ISD::FrameIndex &&
        HandleBaseImmOffset(LHS, RHS, Base, Offset, Size)) {
      return true;
    }
  }
  // Absolute address.
  if (!isADD(CurDAG, Addr) &&
      Addr.getOpcode() != ISD::FrameIndex) {
    Base = Addr;
    Offset = CurDAG->getTargetConstant(0, SDLoc(Addr), MVT::i32);
    return true;
  }
  return false;
}

/// Handle base reg + delta reg + offset reg.
bool ColossusDAGToDAGISel::
HandleADDRrrr(SDValue Addr, SDValue &Base, SDValue &Delta,
              SDValue &Offset, unsigned Size) {
  // Addr = base register + delta register + scaled offset immediate.
  if (isADD(CurDAG, Addr)) {
    SDValue LHS = Addr.getOperand(0);
    SDValue RHS = Addr.getOperand(1);
    SDValue AddrPart;
    if (HandleBaseRegOffset(LHS, RHS, AddrPart, Offset, Size)) {
      if (AddrPart.getOpcode() == ISD::ADD) {
        Base = AddrPart.getOperand(0);
        Delta = AddrPart.getOperand(1);
        return true;
      }
    }
  }
  // Addr = base register + scaled register offset.
  if (HandleADDRrr(Addr, Base, Offset, Size)) {
    Delta = CurDAG->getRegister(Colossus::MZERO, MVT::i32);
    return true;
  }
  return false;
}

/// Handle base reg + delta reg + offset imm.
bool ColossusDAGToDAGISel::
HandleADDRrri(SDValue Addr, SDValue &Base, SDValue &Delta,
              SDValue &Offset, unsigned Size) {
  if (isADD(CurDAG, Addr)) {
    SDValue LHS = Addr.getOperand(0);
    SDValue RHS = Addr.getOperand(1);
    SDValue AddrPart;
    // Addr = base register + delta register + offset immediate.
    if (LHS.getOpcode() != ISD::FrameIndex &&
        HandleBaseImmOffset(LHS, RHS, AddrPart, Offset, Size)) {
      if (AddrPart.getOpcode() == ISD::ADD) {
        Base = AddrPart.getOperand(0);
        Delta = AddrPart.getOperand(1);
        return true;
      }
    }
    // Addr = base register + (*non-scaled*) delta register.
    if (!HandleBaseRegOffset(LHS, RHS, Base, Offset, Size) &&
        !HandleBaseImmOffset(LHS, RHS, Base, Offset, Size)) {
      Base = LHS;
      Delta = RHS;
      Offset = CurDAG->getTargetConstant(0, SDLoc(Addr), MVT::i32);
      return true;
    }
  }
  if (HandleADDRri(Addr, Base, Offset, Size)) {
    Delta = CurDAG->getRegister(Colossus::MZERO, MVT::i32);
    return true;
  }
  return false;
}

/// Handle an address operand with a frame index.
bool ColossusDAGToDAGISel::
HandleADDRfi(SDValue Addr, SDValue &Base, SDValue &Offset, unsigned Size) {
  // Addr = frame index.
  if (FrameIndexSDNode *FIN = dyn_cast<FrameIndexSDNode>(Addr)) {
    Base = CurDAG->getTargetFrameIndex(FIN->getIndex(), MVT::i32);
    Offset = CurDAG->getTargetConstant(0, SDLoc(Addr), MVT::i32);
    return true;
  }
  if (isADD(CurDAG, Addr)) {
    SDValue LHS = Addr.getOperand(0);
    SDValue RHS = Addr.getOperand(1);
    if (FrameIndexSDNode *FIN = dyn_cast<FrameIndexSDNode>(LHS)) {
      // Addr = frame index + scaled constant offset.
      if (ConstantSDNode *Constant = dyn_cast<ConstantSDNode>(RHS)) {
        int64_t ConstVal = Constant->getSExtValue();
        if (ConstVal % (1 << getShiftVal(Size)) == 0) {
          // Note: the offset is scaled when the frame index is eliminated.
          Base = CurDAG->getTargetFrameIndex(FIN->getIndex(), MVT::i32);
          Offset = CurDAG->getTargetConstant(ConstVal, SDLoc(Addr), MVT::i32);
          return true;
        }
      }
    }
  }
  return false;
}

template<int Size>
bool ColossusDAGToDAGISel::
SelectADDRrr(SDValue Addr, SDValue &Base, SDValue &Offset) {
  return HandleADDRrr(Addr, Base, Offset, Size);
}

template<int Size>
bool ColossusDAGToDAGISel::
SelectADDRri(SDValue Addr, SDValue &Base, SDValue &Offset) {
  return HandleADDRri(Addr, Base, Offset, Size);
}

template<int Size>
bool ColossusDAGToDAGISel::
SelectADDRrrr(SDValue Addr, SDValue &Base, SDValue &Delta, SDValue &Offset) {
  return HandleADDRrrr(Addr, Base, Delta, Offset, Size);
}

template<int Size>
bool ColossusDAGToDAGISel::
SelectADDRrri(SDValue Addr, SDValue &Base, SDValue &Delta, SDValue &Offset) {
  return HandleADDRrri(Addr, Base, Delta, Offset, Size);
}

template<int Size>
bool ColossusDAGToDAGISel::
SelectADDRfi(SDValue Addr, SDValue &Base, SDValue &Offset) {
  return HandleADDRfi(Addr, Base, Offset, Size);
}

/// Handle generic address case. It is accessed from inlined asm '=m'
/// constraints, which could have any kind of pointer.
bool ColossusDAGToDAGISel::
SelectAddr(SDNode *Op, SDValue Addr,
           SDValue &Base, SDValue &Offset) {
  // Direct addresses.
  if (Addr.getOpcode() == ISD::TargetExternalSymbol ||
      Addr.getOpcode() == ISD::TargetGlobalAddress) {
    return false;
  }
  // Frame index.
  if (FrameIndexSDNode *FIN = dyn_cast<FrameIndexSDNode>(Addr)) {
    Base = CurDAG->getTargetFrameIndex(FIN->getIndex(), MVT::i32);
    Offset = CurDAG->getTargetConstant(0, SDLoc(Addr), MVT::i32);
    return true;
  }
  // Base + offset.
  if (Addr.getOpcode() == ISD::ADD) {
    Base = Addr.getOperand(0);
    Offset = Addr.getOperand(1);
    return true;
  }
  // Address.
  Base = Addr;
  Offset = CurDAG->getTargetConstant(0, SDLoc(Addr), MVT::i32);
  return true;
}

/// Select the specified address as a target addressing mode, according to the
/// specified constraint code.  If this does not match or is not implemented,
/// return true.  The resultant operands (which will appear in the machine
/// instruction) should be added to the OutOps vector.
bool ColossusDAGToDAGISel::
SelectInlineAsmMemoryOperand(const SDValue &Op,
                             unsigned ConstraintID,
                             std::vector<SDValue> &OutOps) {
  SDValue Op0, Op1;
  switch (ConstraintID) {
  default:
    return true;
  case InlineAsm::Constraint_m: // Memory.
    if (!SelectAddr(Op.getNode(), Op, Op0, Op1)) {
      return true;
    }
    break;
  }

  OutOps.push_back(Op0); // Base.
  OutOps.push_back(Op1); // Offset.
  return false;
}

void ColossusDAGToDAGISel::SelectAddrForPostInc(SDNode *N, SDValue Addr,
                                                SDValue &Base, SDValue &Delta) {
  SDLoc dl(N);
  SDValue ZeroReg = CurDAG->getRegister(Colossus::MZERO, MVT::i32);
  SDValue ZeroImm = CurDAG->getTargetConstant(0, dl, MVT::i32);

  Base = ZeroReg;
  Delta = Addr;
  
  if (Addr->getOpcode() == ISD::FrameIndex)
    return;

  SDValue NewBase, NewDelta, Offset;
  HandleADDRrri(Addr, NewBase, NewDelta, Offset, 32);

  if (!NewBase || !NewDelta || Offset != ZeroImm)
    return;

  if (NewBase != Addr && NewDelta != ZeroReg) {
    if (NewBase->getOpcode() == ISD::FrameIndex ||
        NewDelta->getOpcode() == ISD::FrameIndex)
      return;
    Base = NewBase;
    Delta = NewDelta;
  }
}

namespace {
SDValue zeroCostDivideOrAbort(SelectionDAG *DAG, SDValue val, int64_t by) {
  SDLoc dl(val);
  if (SDValue c = CTL::exactDivideConstant(DAG, val, by)) {
    auto cn = cast<ConstantSDNode>(c);
    return DAG->getTargetConstant(cn->getZExtValue(), dl, c.getValueType());
  }

  if (SDValue v = CTL::exactDivideVariable(DAG, val, by)) {
    return v;
  }

  LLVM_DEBUG(dbgs() << "Divde:"; val.dump(); dbgs() << "By " << by << "\n";);
  report_fatal_error("Cannot divide without introducing additional nodes");
}

} // namespace

SDValue ColossusDAGToDAGISel::getPostIncAddress(SDNode *OldMem, SDNode *NewMem,
                                                SDValue Addr) {
  const bool isLoad = isa<LoadSDNode>(OldMem);
  const unsigned OldMemOpIdxResNo = isLoad ? 1 : 0;
  // Load/store with base and delta components.
  if (NewMem->getOpcode() != Colossus::STM32STEP &&
      NewMem->getOperand(1) != Addr) {
    SDValue Base = NewMem->getOperand(0);
    SDValue NewDelta = SDValue(NewMem, 0);
    SDLoc dl(OldMem);
    for (SDNode::use_iterator UI = OldMem->use_begin(), E = OldMem->use_end();
         UI != E; ++UI) {
      SDUse &NewAddrUse = UI.getUse();
      if (NewAddrUse.getResNo() != OldMemOpIdxResNo)
        continue;
      SDNode *NewAddrUseNode = NewAddrUse.getUser();
      // Check whether this use is a substraction of the base from the postinc
      // address which computes the updated index.
      if (NewAddrUseNode->isMachineOpcode()) {
        if (NewAddrUseNode->getMachineOpcode() != Colossus::SUB)
          continue;
        // Note: MI sub has both operand swapped hence base is operand 0.
        if (NewAddrUseNode->getOperand(1) !=
                SDValue(OldMem, OldMemOpIdxResNo) ||
            NewAddrUseNode->getOperand(0) != Base)
          continue;
      } else {
        if (NewAddrUseNode->getOpcode() != ISD::SUB)
          continue;
        if (NewAddrUseNode->getOperand(0) !=
                SDValue(OldMem, OldMemOpIdxResNo) ||
            NewAddrUseNode->getOperand(1) != Base)
          continue;
      }
      ReplaceUses(SDValue(NewAddrUseNode, 0), NewDelta);
    }
    SDValue ZeroImm = CurDAG->getTargetConstant(0, dl, MVT::i32);
    SDNode *Add = CurDAG->getMachineNode(Colossus::ADD, dl, MVT::i32, Base,
                                         NewDelta, ZeroImm /*Coissue*/);
    return SDValue(Add, 0);
  }

  return SDValue(NewMem, 0);
}

SDNode *ColossusDAGToDAGISel::SelectPostIncLoad(SDNode *N) {
  LoadSDNode *LD = cast<LoadSDNode>(N);
  ISD::MemIndexedMode AM = LD->getAddressingMode();

  // Only consider post-incementing loads.
  if (AM != ISD::POST_INC) {
    return nullptr;
  }

  // Determine the opcode.
  unsigned ImmOpcode;
  unsigned RegOpcode;
  EVT LoadedVT = LD->getMemoryVT();

  ISD::LoadExtType ExtType = LD->getExtensionType();
  bool IsZeroExt = ExtType == ISD::ZEXTLOAD || ExtType == ISD::EXTLOAD;
  bool IsSignExt = ExtType == ISD::SEXTLOAD;

  if (LoadedVT.getStoreSize() == 8) {
    ImmOpcode = Colossus::LD64STEP_SI_A;
    RegOpcode = Colossus::LD64STEP_A;
  } else if (LoadedVT.getStoreSize() == 4 &&
             LoadedVT.isInteger()) {
    ImmOpcode = Colossus::LD32STEP_SI;
    RegOpcode = Colossus::LD32STEP;
  } else if (LoadedVT.getStoreSize() == 4 &&
             LoadedVT.isFloatingPoint()) {
    ImmOpcode = Colossus::LD32STEP_SI_A;
    RegOpcode = Colossus::LD32STEP_A;
  } else if (LoadedVT.getStoreSize() == 2) {
    if(LoadedVT.isFloatingPoint()) {
      assert(ExtType == ISD::NON_EXTLOAD);
      ImmOpcode = Colossus::LDB16STEP_SI;
      RegOpcode = Colossus::LDB16STEP;
    }
    else {
      assert(LoadedVT.isInteger());
      if (IsZeroExt) {
        ImmOpcode = Colossus::LDZ16STEP_SI;
        RegOpcode = Colossus::LDZ16STEP;
      } else if (IsSignExt) {
        ImmOpcode = Colossus::LDS16STEP_SI;
        RegOpcode = Colossus::LDS16STEP;
      } else {
        llvm_unreachable("Unexpected memory ext type");
      }
    }
  } else if (LoadedVT.getStoreSize() == 1) {
    if (IsZeroExt) {
      ImmOpcode = Colossus::LDZ8STEP_SI;
      RegOpcode = Colossus::LDZ8STEP;
    } else if (IsSignExt) {
      ImmOpcode = Colossus::LDS8STEP_SI;
      RegOpcode = Colossus::LDS8STEP;
    } else {
      llvm_unreachable("Unexpected memory ext type");
    }
  } else {
    llvm_unreachable("Unknown memory VT");
  }

  SDLoc dl(N);
  SDValue Chain = LD->getChain();
  SDValue Addr = LD->getBasePtr();
  SDValue ZeroImm = CurDAG->getTargetConstant(0, dl, MVT::i32);

  // Get the increment
  SDValue IncVal =
      zeroCostDivideOrAbort(CurDAG, LD->getOffset(), LoadedVT.getStoreSize());
  unsigned Opcode =
    (IncVal.getOpcode() == ISD::TargetConstant) ? ImmOpcode : RegOpcode;

  SDValue Base, Delta;
  SelectAddrForPostInc(N, Addr, Base, Delta);

  // Construct the new post-incrementing load.
  const SDValue Ops[] = {Base, Delta, IncVal, ZeroImm /*Coissue*/, Chain};
  SDNode *NewLD =
      CurDAG->getMachineNode(Opcode, dl, MVT::i32, LoadedVT, MVT::Other, Ops);
  SDValue NewAddr = getPostIncAddress(LD, NewLD, Addr);
  // Set mem refs.
  MachineMemOperand *MemOp = LD->getMemOperand();
  CurDAG->setNodeMemRefs(cast<MachineSDNode>(NewLD), {MemOp});
  // Update uses.
  const SDValue Froms[] = {SDValue(LD, 0),  // Loaded value
                           SDValue(LD, 1),  // Incremented address
                           SDValue(LD, 2)}; // Chain
  const SDValue Tos[] = {SDValue(NewLD, 1), // Address and value are swapped.
                         NewAddr, SDValue(NewLD, 2)};
  ReplaceUses(Froms, Tos, 3);
  return NewLD;
}

SDNode *ColossusDAGToDAGISel::SelectPostIncStore(SDNode *N) {
  StoreSDNode *ST = cast<StoreSDNode>(N);
  ISD::MemIndexedMode AM = ST->getAddressingMode();

  // Only consider post-incementing stores.
  if (AM != ISD::POST_INC) {
    return nullptr;
  }

  unsigned ImmOpcode;
  unsigned RegOpcode;
  EVT StoredVT = ST->getMemoryVT();

  if (StoredVT.getStoreSize() == 8) {
    ImmOpcode = Colossus::ST64STEP_SI_A;
    RegOpcode = Colossus::ST64STEP_A;
  } else if (StoredVT.getStoreSize() == 4 && StoredVT.isInteger()) {
    ImmOpcode = Colossus::ST32STEP_SI;
    RegOpcode = Colossus::STM32STEP;
  } else if (StoredVT.getStoreSize() == 4 && StoredVT.isFloatingPoint()) {
    ImmOpcode = Colossus::ST32STEP_SI_A;
    RegOpcode = Colossus::ST32STEP_A;
  } else {
    llvm_unreachable("Unknown memory type");
  }

  SDLoc dl(N);
  SDValue Chain = ST->getChain();
  SDValue Addr = ST->getBasePtr();
  SDValue Value = ST->getValue();
  SDValue ZeroImm = CurDAG->getTargetConstant(0, dl, MVT::i32);

  // Get the increment
  SDValue IncVal =
      zeroCostDivideOrAbort(CurDAG, ST->getOffset(), StoredVT.getStoreSize());
  unsigned Opcode =
    (IncVal.getOpcode() == ISD::TargetConstant) ? ImmOpcode : RegOpcode;

  // Construct the new post-incrementing store.
  SmallVector<SDValue, 6> Ops;
  if (Opcode == Colossus::STM32STEP) {
    Ops = {Value, Addr, IncVal, ZeroImm /*Coissue*/, Chain};
  } else {
    SDValue Base, Delta;
    SelectAddrForPostInc(N, Addr, Base, Delta);

    Ops = {Base, Delta, IncVal, Value, ZeroImm /*Coissue*/, Chain};
  }
  SDNode *NewST = CurDAG->getMachineNode(Opcode, dl, MVT::i32, MVT::Other, Ops);
  SDValue NewAddr = getPostIncAddress(ST, NewST, Addr);

  // Set mem refs.
  MachineMemOperand *MemOp = ST->getMemOperand();
  CurDAG->setNodeMemRefs(cast<MachineSDNode>(NewST), {MemOp});
  // Update uses.
  ReplaceUses(SDValue(ST, 0), NewAddr); // Incremented address.
  ReplaceUses(SDValue(ST, 1), SDValue(NewST, 1));
  return NewST;
}

SDNode *ColossusDAGToDAGISel::SelectViaZeroRegister(SDNode *N) {
  if (N->getNumValues() != 1) {
    return nullptr;
  }

  // This function only matches constant values
  auto maybeUint = CTL::SDValueToUINT64(SDValue(N, 0), *CurDAG);
  if (!maybeUint.hasValue()) {
    return nullptr;
  }

  EVT VT = N->getValueType(0);
  auto zeroRegister = Colossus::NoRegister;
  if (VT == MVT::v2i16 || VT == MVT::i32) {
    zeroRegister = Colossus::MZERO;
  } else if (VT == MVT::f16 || VT == MVT::v2f16 || VT == MVT::f32) {
    zeroRegister = Colossus::AZERO;
  } else if (VT == MVT::v4f16 || VT == MVT::v2f32) {
    zeroRegister = Colossus::AZEROS;
  } else {
    return nullptr;
  }
  SDLoc dl(N);
  SDValue Zero = CurDAG
    ->getCopyFromReg(CurDAG->getEntryNode(), dl, zeroRegister, VT);

  if (maybeUint.getValue() == 0u) {
    // Zero constants are optimally created by copying from the zero register
    return Zero.getNode();
  }

  if (VT.isFloatingPoint()) {
    // All bits set floating point constants should be lowered using (not zero)
    // This was previously achieved by special casing performBuildVectorCombine
    // It should be implemented analogously to the 32 bit constant lowering
    // T4185 is tracking this.
    auto usedBitsSet = [=](uint64_t value) {
      auto size = VT.getSizeInBits();
      if ((size == 64) && (value == UINT64_MAX)) {
        return true;
      }
      if ((size == 32) && (value == UINT32_MAX)) {
        return true;
      }
      return false;
    };

    if (usedBitsSet(maybeUint.getValue())) {
      SDValue coissueImm = CurDAG->getTargetConstant(0, dl, MVT::i32);
      unsigned op = VT.getSizeInBits() == 32 ? Colossus::NOT : Colossus::NOT64;
      return CurDAG->getMachineNode(op, dl, VT, Zero, coissueImm);
    }
  }

  return nullptr;
}

SDNode *ColossusDAGToDAGISel::ReplaceWithLDB16(SDNode *N) {
  // Replace v2f16 (sort4x16lo (f16asv2f16 (load x)) (f16asv2f16 (load x)))
  // with ldb16. Similarly for ldb16step
  assert(N->getOpcode() == ColossusISD::SORT4X16LO);
  EVT VT = N->getValueType(0);
  if (VT != MVT::v2f16) {
    return nullptr;
  }
  assert(N->getNumOperands() == 2);
  SDValue Op0 = N->getOperand(0);
  SDValue Op1 = N->getOperand(1);
  if (Op0 != Op1) {
    return nullptr;
  }

  // Look through the F16ASV2F16 expected to precede the load
  if ((Op0.getValueType() != MVT::v2f16) ||
      (Op0.getOpcode() != ColossusISD::F16ASV2F16)) { return nullptr; }
  SDValue LoadOp = Op0.getOperand(0);
  assert(LoadOp.getValueType() == MVT::f16);

  if (LoadOp.getOpcode() != ISD::LOAD) {
    return nullptr;
  }

  SDLoc dl(N);
  LoadSDNode *LD = cast<LoadSDNode>(LoadOp);
  // Cast original load node result to v2f16 before replacing with ldb16*
  SDValue RC = CurDAG->getTargetConstant(Colossus::ARRegClassID, dl, MVT::i32);
  SDNode *castValue = CurDAG->getMachineNode(TargetOpcode::COPY_TO_REGCLASS, dl,
                                             MVT::v2f16, SDValue(LD, 0), RC);
  auto am = LD->getAddressingMode();

  if (am == ISD::UNINDEXED) {
    SDValue Addr = LD->getBasePtr();
    SDValue Base;
    SDValue Delta;
    SDValue Offset;
    unsigned ldb16Opcode;
    if (SelectADDRrrr<16>(Addr, Base, Delta, Offset)) {
      ldb16Opcode = Colossus::LDB16;
    } else if (SelectADDRrri<16>(Addr, Base, Delta, Offset)) {
      ldb16Opcode = Colossus::LDB16_ZI;
    } else {
      return nullptr;
    }
    SDValue ZeroImm = CurDAG->getTargetConstant(0, dl, MVT::i32);
    const SDValue Ops[] = {Base, Delta, Offset, ZeroImm /* coissue */,
                           LD->getChain()};
    SDNode *NewLD =
        CurDAG->getMachineNode(ldb16Opcode, dl, MVT::f16, MVT::Other, Ops);
    // Set mem refs.
    MachineMemOperand *MemOp = LD->getMemOperand();
    CurDAG->setNodeMemRefs(cast<MachineSDNode>(NewLD), {MemOp});
    assert(LD->getNumValues() == 2);
    assert(NewLD->getNumValues() == 2);
    // Update uses.
    const SDValue Froms[] = {SDValue(LD, 0),  // value
                             SDValue(LD, 1)}; // chain
    const SDValue Tos[] = {SDValue(NewLD, 0), SDValue(NewLD, 1)};
    ReplaceUses(Froms, Tos, 2);
    return castValue;
  }

  if (am == ISD::POST_INC) {
    // Replace the load with a ldb16step
    SDNode *NewLD = SelectPostIncLoad(LD);
    assert(NewLD);
    (void)NewLD;
    return castValue;
  }

  return nullptr;
}

// Duplicates logic and explicitly implements a ColossusSORT4X16LO pattern in
// ColossusInstrInfo.td for strict FP nodes. Implementation in tablegen results
// in bailing out of the transformation because of the `hasOneUse` constraint
// while most of these patterns will have 2 of the same uses within the pattern.
SDNode *ColossusDAGToDAGISel::ReplaceWithF16AS(SDNode *N) {
  //  v2f16 ColossusSORT4X16LO(
  //    ColossusF16ASV2F16(any_fpround(f32AR:$op)),
  //    ColossusF16ASV2F16(any_fpround(f32AR:$op))
  //  )
  //    ->
  //  COPY_TO_REGCLASS(F32TOF16(f32AR:$op)), AR)
  SDLoc dl(N);
  SDValue Op0 = N->getOperand(0);
  SDValue Op1 = N->getOperand(1);
  SDValue ZeroImm = CurDAG->getTargetConstant(0, dl, MVT::i32);

  // Check:
  //    SORT4X16LO(x, x), where x only occurs within the sub-DAG
  if (Op0 != Op1 || !Op0->hasNUsesOfValue(2, 0))
    return {};

  // Check:
  //    SORT4X16LO(
  //      F16ASV2F16(y),
  //      F16ASV2F16(y)
  //    )
  if (Op0.getOpcode() != ColossusISD::F16ASV2F16)
    return {};

  SDValue F16ASV2F16_Op0 = Op0->getOperand(0);

  // Check:
  //    SORT4X16LO(
  //      F16ASV2F16(strict_fpround(z)),
  //      F16ASV2F16(strict_fpround(z))
  //    )
  if (F16ASV2F16_Op0.getOpcode() != ISD::STRICT_FP_ROUND)
    return {};

  SDValue StrictFPRound_Op0 = F16ASV2F16_Op0.getOperand(1);

  // Check:
  //    SORT4X16LO(
  //      F16ASV2F16(f16 strict_fpround(f32 z)),
  //      F16ASV2F16(f16 strict_fpround(f32 z))
  //    )
  if (F16ASV2F16_Op0.getSimpleValueType() != MVT::f16 ||
      StrictFPRound_Op0.getSimpleValueType() != MVT::f32)
    return {};

  SDNode *f32tof16 = CurDAG->getMachineNode(Colossus::F32TOF16, dl, MVT::f16,
                                             {StrictFPRound_Op0, ZeroImm});
  SDValue RC = CurDAG->getTargetConstant(Colossus::ARRegClassID, dl, MVT::i32);
  return CurDAG->getMachineNode(TargetOpcode::COPY_TO_REGCLASS, dl,
                                          MVT::v2f16, SDValue(f32tof16, 0), RC);
}

SDNode *ColossusDAGToDAGISel::SelectConstant(SDNode *Op) {
  if (auto Res = SelectViaZeroRegister(Op)) {
    return Res;
  }

  auto &DAG = *CurDAG;
  auto VT = Op->getValueType(0u);
  auto dl = SDLoc{Op};

  auto maybe64u = CTL::SDValueToUINT64(SDValue{Op, 0u}, DAG);
  if (!maybe64u) {
    return nullptr;
  }

  auto setziOpc = Colossus::SETZI;
  auto orizOpc = Colossus::OR_IZ;
  auto zeroReg = Colossus::MZERO;

  if (VT.isFloatingPoint()) {
    setziOpc = Colossus::SETZI_A;
    orizOpc = Colossus::OR_IZ_A;
    zeroReg = Colossus::AZERO;
  }

  auto entry = DAG.getEntryNode();
  auto zeroCpy = DAG.getCopyFromReg(entry, dl, zeroReg, VT);
  auto coissueImm = DAG.getTargetConstant(0u, dl, MVT::i32);

  if (VT.getSizeInBits() > 32u) {
    assert(VT.getSizeInBits() == 64u);
    return nullptr;
  }

  auto const val32u = static_cast<uint32_t>(*maybe64u);
  if (val32u == 0u) {
    return zeroCpy.getNode();
  }

  auto const hi12u = val32u & 0xFFF00000u;
  auto const lo20u = val32u & 0x000FFFFFu;

  if (hi12u == 0u) {
    auto valImm = DAG.getTargetConstant(lo20u, dl, MVT::i32);
    return DAG.getMachineNode(setziOpc, dl, VT, valImm, coissueImm);
  }

  if (lo20u == 0u) {
    auto valImm = DAG.getTargetConstant(hi12u, dl, MVT::i32);
    return DAG.getMachineNode(orizOpc, dl, VT, zeroCpy, valImm, coissueImm);
  }

  if (VT.isFloatingPoint()) {
    if (val32u == std::numeric_limits<uint32_t>::max()) {
      return DAG.getMachineNode(Colossus::NOT, dl, VT, zeroCpy, coissueImm);
    }
  }
  else {
    auto val32i = int32_t{};
    std::memcpy(&val32i, &val32u, 4);
    if (isInt<16u>(val32i)) {
      auto addOpc = Colossus::ADD_SI;
      auto valImm = DAG.getTargetConstant(val32u, dl, MVT::i32);
      return DAG.getMachineNode(addOpc, dl, VT, zeroCpy, valImm, coissueImm);
    }
  }

  auto loImm = DAG.getTargetConstant(lo20u, dl, MVT::i32);
  auto hiImm = DAG.getTargetConstant(hi12u, dl, MVT::i32);

  auto setLo = SDValue{
    DAG.getMachineNode(setziOpc, dl, VT, loImm, coissueImm), 0u
  };

  return DAG.getMachineNode(orizOpc, dl, VT, setLo, hiImm, coissueImm);
}

void ColossusDAGToDAGISel::Select(SDNode *N) {
  // Dump information about the Node being selected.
  LLVM_DEBUG(dbgs() << "Selecting: "; N->dump(CurDAG); errs() << "\n");

  // If we have a machine node, we already have selected it. For example,
  // INSERT/EXTRACT_SUBREG machine nodes are inserted by ISelLowering and are
  // not expected to go through the LLVM instruction selection in SelectCode().
  if (N->isMachineOpcode()) {
    LLVM_DEBUG(dbgs() << "== "; N->dump(CurDAG); errs() << "\n");
    N->setNodeId(-1);
    return;
  }

  // Custom selection.
  switch (N->getOpcode()) {

  case ISD::LOAD: {
    if (SDNode *Res = SelectPostIncLoad(N)) {
      ReplaceNode(N, Res);
      return;
    }
    break;
  }

  case ISD::STORE: {
    if (SDNode *Res = SelectPostIncStore(N)) {
      ReplaceNode(N, Res);
      return;
    }
    break;
  }

  case ColossusISD::SORT4X16LO: {
    if (SDNode *ldb16 = ReplaceWithLDB16(N)) {
      ReplaceNode(N, ldb16);
      return;
    } else if (SDNode *f16as = ReplaceWithF16AS(N)) {
      ReplaceNode(N, f16as);
      return;
    }
    break;
  }

    case ISD::CONCAT_VECTORS:
    case ColossusISD::CONCAT_VECTORS: {
      if (auto Res = SelectViaZeroRegister(N)) {
        ReplaceNode(N, Res);
        return;
      }
      break;
    }

    case ISD::Constant:
    case ISD::ConstantFP:
    case ISD::BUILD_VECTOR: {
      if (auto Res = SelectConstant(N)) {
        ReplaceNode(N, Res);
        return;
      }
      break;
    }
    }

    // Call the auto-generated selection code.
    SelectCode(N);
}

FunctionPass *llvm::createColossusISelDag(ColossusTargetMachine &TM,
                                          CodeGenOpt::Level OptLevel) {
  return new ColossusDAGToDAGISel(TM, OptLevel);
}
