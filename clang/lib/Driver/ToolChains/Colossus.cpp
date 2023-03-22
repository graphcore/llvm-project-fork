//===--- Colossus.cpp - Colossus ToolChain Implementations ------*- C++ -*-===//
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

#include "Colossus.h"
#include "CommonArgs.h"
#include "clang/Driver/Compilation.h"
#include "clang/Driver/Driver.h"
#include "clang/Driver/Options.h"
#include "llvm/Option/ArgList.h"
#include "llvm/Support/FileSystem.h"
#include "llvm/Support/Path.h"
#include <cstdlib> // ::getenv

using namespace clang::driver;
using namespace clang::driver::toolchains;
using namespace clang;
using namespace llvm::opt;

void tools::colossus::Link::ConstructJob(Compilation &C, const JobAction &JA,
                                         const InputInfo &Output,
                                         const InputInfoList &Inputs,
                                         const ArgList &Args,
                                         const char *LinkingOutput) const {
  const toolchains::ColossusToolChain &ToolChain =
      static_cast<const toolchains::ColossusToolChain &>(getToolChain());
  const Driver &Driver = ToolChain.getDriver();

  ArgStringList CmdArgs;

  // Arguments.
  bool buildingLib = Args.hasArg(options::OPT_shared);
  bool incStartFiles = !Args.hasArg(options::OPT_nostartfiles);
  bool incDefLibs = !Args.hasArg(options::OPT_nodefaultlibs);
  bool incStdLib = !Args.hasArg(options::OPT_nostdlib);
  bool incStdLdScript = !Args.hasArg(options::OPT_T);
  bool supervisor = Args.hasArg(options::OPT_msupervisor);

  std::string ipuArchName = "ipu1";
  if (const Arg *A = Args.getLastArg(options::OPT_march_EQ)) {
    StringRef MArch = A->getValue();
    ipuArchName = MArch.str();
  }

  // runtime/lib
  SmallString<128> LibDir(Driver.InstalledDir);
  llvm::sys::path::append(LibDir, "..", "colossus");
  supervisor ? llvm::sys::path::append(LibDir, "supervisor", "lib")
             : llvm::sys::path::append(LibDir, "lib");
  CmdArgs.push_back(Args.MakeArgString(Twine("-L") + LibDir.str()));

  // compiler-rt
  LibDir.clear();
  LibDir.append(Driver.InstalledDir);
  llvm::sys::path::append(LibDir, "..", "lib", "graphcore");
  llvm::sys::path::append(LibDir, "lib", ipuArchName);
  CmdArgs.push_back(Args.MakeArgString(Twine("-L") + LibDir.str()));

  // Output file.
  if (Output.isFilename()) {
    CmdArgs.push_back("-o");
    CmdArgs.push_back(Output.getFilename());
  } else {
    assert(Output.isNothing() && "Invalid output.");
  }

  // Start files.
  if (incStartFiles && incStdLib && !buildingLib) {
    SmallString<128> CrtPath(Driver.InstalledDir);
    llvm::sys::path::append(CrtPath, "..", "colossus");
    supervisor ? llvm::sys::path::append(CrtPath, "supervisor", "lib")
               : llvm::sys::path::append(CrtPath, "lib");
    std::string crtName = "crt_";
    crtName += ipuArchName;
    crtName += ".o";
    llvm::sys::path::append(CrtPath, crtName);
    CmdArgs.push_back(Args.MakeArgString(CrtPath.str()));
  }

  // Linker script
  if (incStdLdScript) {
    SmallString<128> ScriptDirPath(Driver.InstalledDir);
    llvm::sys::path::append(ScriptDirPath, "..", "colossus", "lib",
                            "ldscripts");
    CmdArgs.push_back(Args.MakeArgString(Twine("-L") + ScriptDirPath.str()));
    std::string linkerScript = ipuArchName + ".x";
    CmdArgs.push_back(Args.MakeArgString(Twine("--script=") + linkerScript));
  }

  Args.AddAllArgs(CmdArgs, options::OPT_L);
  ToolChain.AddFilePathLibArgs(Args, CmdArgs);
  Args.AddAllArgs(CmdArgs,
                  {options::OPT_T_Group, options::OPT_e, options::OPT_s,
                   options::OPT_t, options::OPT_Z_Flag, options::OPT_r});

  // Linker inputs.
  AddLinkerInputs(getToolChain(), Inputs, Args, CmdArgs, JA);

  if (incDefLibs && incStdLib) {
    // Colossus library.
    std::string lib = "-l";
    lib += ipuArchName;
    CmdArgs.push_back(Args.MakeArgString(lib));
    // clang_rt library.
    CmdArgs.push_back(Args.MakeArgString("-lclang_rt.builtins-ipu"));
  }

  const char *Exec =
      Args.MakeArgString(getToolChain().GetProgramPath("gc-ld.lld"));
  C.addCommand(std::make_unique<Command>(
      JA, *this, ResponseFileSupport::AtFileCurCP(), Exec, CmdArgs, Inputs));
}

void tools::colossus::getColossusTargetFeatures(
    const Driver &, const llvm::opt::ArgList &Args,
    std::vector<llvm::StringRef> &Features) {
  if (Args.hasArg(options::OPT_msupervisor)) {
    Features.push_back("-worker");
  }

  if (const Arg *A = Args.getLastArg(options::OPT_march_EQ)) {
    std::string MArch = "+";
    MArch += A->getValue();
    Features.push_back(Args.MakeArgString(MArch));
  }
}

/// Colossus tool chain

ColossusToolChain::ColossusToolChain(const Driver &D,
                                     const llvm::Triple &Triple,
                                     const ArgList &Args)
    : ToolChain(D, Triple, Args) {
  supervisor_ = Args.hasArg(options::OPT_msupervisor);
  getProgramPaths().push_back(getDriver().getInstalledDir());
  if (getDriver().getInstalledDir() != getDriver().Dir)
    getProgramPaths().push_back(getDriver().Dir);
}

Tool *ColossusToolChain::buildLinker() const {
  return new tools::colossus::Link(*this);
}

bool ColossusToolChain::isPICDefault() const { return false; }

bool ColossusToolChain::isPIEDefault(const llvm::opt::ArgList &Args) const {
  return false;
}

bool ColossusToolChain::isPICDefaultForced() const { return false; }

bool ColossusToolChain::SupportsProfiling() const { return false; }

bool ColossusToolChain::hasBlocksRuntime() const { return false; }

void ColossusToolChain::AddClangSystemIncludeArgs(
    const ArgList &DriverArgs, ArgStringList &CC1Args) const {
  const Driver &D = getDriver();
  bool NoStdInc = DriverArgs.hasArg(options::OPT_nostdinc);
  bool NoStdlibInc = DriverArgs.hasArg(options::OPT_nostdlibinc);
  bool NoBuiltinInc = DriverArgs.hasArg(options::OPT_nobuiltininc);

  if (NoStdInc)
    return;

  // ../colossus/include
  if (!NoStdlibInc) {
    SmallString<128> IncDir(getDriver().getInstalledDir());
    llvm::sys::path::append(IncDir, "..", "colossus", "include");
    addSystemInclude(DriverArgs, CC1Args, IncDir.str());
  }

  // Add the Clang builtin headers (<resource>/include)
  if (!NoBuiltinInc) {
    SmallString<128> P(D.ResourceDir);
    llvm::sys::path::append(P, "include");
    addSystemInclude(DriverArgs, CC1Args, P);
  }
}

void ColossusToolChain::addClangTargetOptions(
    const llvm::opt::ArgList &DriverArgs, llvm::opt::ArgStringList &CC1Args,
    Action::OffloadKind) const {
  CC1Args.push_back("-nostdsysteminc");

  if (isWorker()) {
    // If compiling for the IPU, use native half types.
    CC1Args.push_back("-fnative-half-type");
    CC1Args.push_back("-fallow-half-arguments-and-returns");

    // Disable lax vector conversions by default
    CC1Args.push_back("-flax-vector-conversions=none");

    bool optimizeForSize = false;

    if (Arg *A = DriverArgs.getLastArg(options::OPT_O_Group)) {
      if (A->getOption().matches(options::OPT_O)) {
        StringRef S(A->getValue());
        if (S == "s" || S == "z") {
          optimizeForSize = true;
        }
      }
    }

    if (Arg *A = DriverArgs.getLastArg(options::OPT_mmax_nops_in_rpt)) {
      StringRef S = A->getValue();
      CC1Args.push_back("-mllvm");
      CC1Args.push_back(DriverArgs.MakeArgString("-max-nops-in-rpt=" + S));
    } else if (optimizeForSize) {
      CC1Args.push_back("-mllvm");
      CC1Args.push_back("-max-nops-in-rpt=1");
    }

    if (Arg *A = DriverArgs.getLastArg(options::OPT_mnop_threshold_in_rpt)) {
      StringRef S = A->getValue();
      CC1Args.push_back("-mllvm");
      CC1Args.push_back(DriverArgs.MakeArgString("-nop-threshold-in-rpt=" + S));
    } else if (optimizeForSize) {
      CC1Args.push_back("-mllvm");
      CC1Args.push_back("-nop-threshold-in-rpt=0");
    }
  }

  // Also force non-PIC code.
  CC1Args.push_back("-mrelocation-model");
  CC1Args.push_back("static");
  CC1Args.push_back("-ffunction-sections");
  CC1Args.push_back("-fdata-sections");
}

void ColossusToolChain::AddClangCXXStdlibIncludeArgs(
    const ArgList &DriverArgs, ArgStringList &CC1Args) const {
  if (DriverArgs.hasArg(options::OPT_nostdinc, options::OPT_nostdincxx,
                        options::OPT_nostdlibinc))
    return;
  // TODO.
}

void ColossusToolChain::AddCXXStdlibLibArgs(const ArgList &Args,
                                            ArgStringList &CmdArgs) const {
  // TODO.
}
