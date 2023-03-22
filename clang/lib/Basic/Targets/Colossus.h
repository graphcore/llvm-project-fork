//===--- Colossus.h - Declare Colossus target feature support ----- C++ -*-===//
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
// This file declares Colossus TargetInfo objects.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_CLANG_LIB_BASIC_TARGETS_COLOSSUS_H
#define LLVM_CLANG_LIB_BASIC_TARGETS_COLOSSUS_H

#include "clang/Basic/Diagnostic.h"
#include "clang/Basic/TargetInfo.h"
#include "clang/Basic/TargetBuiltins.h"

namespace clang {
namespace targets {
}
class LLVM_LIBRARY_VISIBILITY ColossusTargetInfo : public TargetInfo {
    static const Builtin::Info BuiltinInfo[];
  public:
    static const char * const GCCRegNames[];
    static const TargetInfo::GCCRegAlias GCCRegAliases[];

    ColossusTargetInfo(const llvm::Triple &Triple, const TargetOptions &)
        : TargetInfo(Triple) {
      BigEndian = false;
      NoAsmVariants = true;
      LongAlign = 32;
      LongWidth = 32;
      LongLongAlign = 64;
      LongLongWidth = 64;
      SuitableAlign = 32;
      DoubleAlign = LongDoubleAlign = 32;
      MaxVectorAlign = 64;
      WIntType = UnsignedInt;
      UseZeroLengthBitfieldAlignment = true;
      MaxAtomicPromoteWidth = MaxAtomicInlineWidth = 32;
      PtrDiffType = IntPtrType = SignedInt;
      SizeType = UnsignedInt;
      HasStrictFP = true;
      resetDataLayout("e-m:e-p:32:32-i1:8:32-i8:8:32-i16:16:32-i64:32-i128:64"
                      "-f64:32-f128:64-v128:64-a:0:32-n32");
    }
    void getTargetDefines(const LangOptions &Opts,
                          MacroBuilder &Builder) const override {
    }

    ArrayRef<Builtin::Info> getTargetBuiltins() const override {
      return llvm::makeArrayRef(BuiltinInfo,
               clang::Colossus::LastTSBuiltin-Builtin::FirstTSBuiltin);
    }

    BuiltinVaListKind getBuiltinVaListKind() const override {
      return TargetInfo::VoidPtrBuiltinVaList;
    }

    const char *getClobbers() const override {
      return "";
    }

    bool isValidCPUName(StringRef Name) const override {
      return Name.startswith("ipu");
    }

    bool setCPU(const std::string &Name) override {
      return isValidCPUName(Name);
    }

    ArrayRef<const char *> getGCCRegNames() const override;

    ArrayRef<TargetInfo::GCCRegAlias> getGCCRegAliases() const override;

    bool validateAsmConstraint(const char *&Name,
                               TargetInfo::ConstraintInfo &Info) const override {
      return false;
    }

    bool initFeatureMap(llvm::StringMap<bool> &Features,
                              DiagnosticsEngine &Diags, StringRef CPU,
                              const std::vector<std::string> &FeaturesVec) const override;

    bool hasBitIntType() const override { return true; }
  };

  const char *const ColossusTargetInfo::GCCRegNames[] = {
    "$m0" , "$m1" , "$m2" , "$m3" , "$m4" , "$m5" , "$m6" , "$m7" ,
    "$m8" , "$m9" , "$m10", "$m11", "$m12", "$m13", "$m14", "$m15",
    "$a0" , "$a1" , "$a2" , "$a3" , "$a4" , "$a5" , "$a6" , "$a7" ,
    "$a8" , "$a9" , "$a10", "$a11", "$a12", "$a13", "$a14", "$a15",
    "$a0:1", "$a2:3", "$a4:5", "$a6:7", 
  };

  const TargetInfo::GCCRegAlias ColossusTargetInfo::GCCRegAliases[] = {
      {{"$bp"}, "$m8"},
      {{"$fp"}, "$m9"},
      {{"$lr"}, "$m10"},
      {{"$sp"}, "$m11"},
      {{"$mworker_base"}, "$m12"},
      {{"$mvertex_base"}, "$m13"},
      {{"$azero"}, "$a15"},
      {{"$mzero"}, "$m15"},
  };

  ArrayRef<const char*> ColossusTargetInfo::getGCCRegNames() const {
    return llvm::makeArrayRef(GCCRegNames);
  }

  ArrayRef<TargetInfo::GCCRegAlias> ColossusTargetInfo::
  getGCCRegAliases() const {
    return llvm::makeArrayRef(GCCRegAliases);
  }

  // FIXME: Move this to a new Colossus.cpp file later.
  bool ColossusTargetInfo::initFeatureMap(llvm::StringMap<bool> &Features,
                              DiagnosticsEngine &Diags, StringRef CPU,
                              const std::vector<std::string> &FeaturesVec) const {
    // This keeps track of "-msupervisor" which resolves to "-worker".
    // We override this if any explicit target attribute is set in the
    // function (this is to be changed later).
    bool hasImplicitSupervisorTarget = false;

    StringRef TargetFeat;
    std::vector<std::string> UpdatedFeaturesVec;
    for (const std::string &F : FeaturesVec) {
      if (F == "-worker") {
        hasImplicitSupervisorTarget = true;
      } else if (F == "+worker" || F == "+supervisor" || F == "+both") {
        // Sets the explicit target feature found in function attributes.
        // This must not be set twice as they are mutually exclusive.
        if (!TargetFeat.empty()) {
          Diags.Report(diag::err_opt_not_valid_with_opt) << TargetFeat << F;
          return false;
        }
        TargetFeat = F;
      } else {
        UpdatedFeaturesVec.push_back(F);
      }
    }

    // Either have the explicit target attribute or the implicit from
    // "-msupervisor" option. If neither, we default to "+worker".
    if (!TargetFeat.empty())
      UpdatedFeaturesVec.push_back(TargetFeat.str());
    else if (hasImplicitSupervisorTarget)
      UpdatedFeaturesVec.push_back("+supervisor");
    else
      UpdatedFeaturesVec.push_back("+worker");
  
    return TargetInfo::initFeatureMap(Features, Diags, CPU, UpdatedFeaturesVec);
  }

  const Builtin::Info ColossusTargetInfo::BuiltinInfo[] = {
#define BUILTIN(ID, TYPE, ATTRS) \
  { #ID, TYPE, ATTRS, nullptr, ALL_LANGUAGES, nullptr },
#define LIBBUILTIN(ID, TYPE, ATTRS, HEADER) \
  { #ID, TYPE, ATTRS, HEADER, ALL_LANGUAGES, nullptr },
#define TARGET_BUILTIN(ID, TYPE, ATTRS, FEATURE)                               \
  {#ID, TYPE, ATTRS, nullptr, ALL_LANGUAGES, FEATURE},
#include "clang/Basic/BuiltinsColossus.def"
  };
}

#endif // LLVM_CLANG_LIB_BASIC_TARGETS_COLOSSUS_H
