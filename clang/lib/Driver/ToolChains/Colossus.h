//===--- Colossus.h - Colossus ToolChain Implementations --------------*- C++ -*-===//
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

#ifndef LLVM_CLANG_LIB_DRIVER_TOOLCHAINS_COLOSSUS_H
#define LLVM_CLANG_LIB_DRIVER_TOOLCHAINS_COLOSSUS_H

#include "clang/Driver/Tool.h"
#include "clang/Driver/ToolChain.h"

namespace clang {
namespace driver {
namespace tools {

namespace colossus {
  class LLVM_LIBRARY_VISIBILITY Link : public Tool {
  public:
    Link(const ToolChain &TC) : Tool("colossus::Link",
                                     "linker", TC) {}

  bool hasIntegratedCPP() const override { return false; }
  bool isLinkJob() const override { return true; }
  void ConstructJob(Compilation &C, const JobAction &JA,
                    const InputInfo &Output, const InputInfoList &Inputs,
                    const llvm::opt::ArgList &TCArgs,
                    const char *LinkingOutput) const override;
};

void getColossusTargetFeatures(const Driver &D, const llvm::opt::ArgList &Args,
                             std::vector<llvm::StringRef> &Features);
} // end namespace colossus.
} // end namespace tools

 namespace toolchains {

 class LLVM_LIBRARY_VISIBILITY ColossusToolChain : public ToolChain {
   public:
     ColossusToolChain(const Driver &D, const llvm::Triple &Triple,
                       const llvm::opt::ArgList &Args);
   protected:
     Tool *buildLinker() const override;
   public:
     bool isPICDefault() const override;
     bool isPIEDefault(const llvm::opt::ArgList &Args) const override;
     bool isPICDefaultForced() const override;
     bool SupportsProfiling() const override;
     bool hasBlocksRuntime() const override;
     void AddClangSystemIncludeArgs(const llvm::opt::ArgList &DriverArgs,
                                    llvm::opt::ArgStringList &CC1Args) const override;
     void addClangTargetOptions(const llvm::opt::ArgList &DriverArgs,
                                llvm::opt::ArgStringList &CC1Args,
                                Action::OffloadKind DeviceOffloadKind) const override;
     void AddClangCXXStdlibIncludeArgs(const llvm::opt::ArgList &DriverArgs,
                                       llvm::opt::ArgStringList &CC1Args) const override;
     void AddCXXStdlibLibArgs(const llvm::opt::ArgList &Args,
                              llvm::opt::ArgStringList &CmdArgs) const override;
     static bool IsProductionInstall(const std::string &InstalledDir);
     bool IsIntegratedAssemblerDefault() const override { return true; };
     bool IsMathErrnoDefault() const override { return false; }
     unsigned GetDefaultDwarfVersion() const override { return 4; }
     // I can't tell the naming convention of functions here. Both seem to override
     // both is and Is are used...
     bool isSupervisor() const {
      return supervisor_;
     }

     bool isWorker() const {
      return !supervisor_;
     }
   private:
    bool supervisor_;
   };
 }

} // end namespace driver
} // end namespace clang

#endif
