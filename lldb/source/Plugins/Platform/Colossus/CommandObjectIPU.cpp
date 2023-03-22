//===-- CommandObjectIPU.cpp ----------------------------------------------===//
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

#include "CommandObjectIPU.h"

#include "GraphcoreDeviceAccessTypes.h"
#include "PlatformColossus.h"
#include "Plugins/Process/Colossus/ProcessColossus.h"
#include "Plugins/Process/Colossus/ThreadColossus.h"
#include "lldb/Core/Module.h"
#include "lldb/Host/OptionParser.h"
#include "lldb/Interpreter/CommandInterpreter.h"
#include "lldb/Interpreter/CommandReturnObject.h"
#include "lldb/Interpreter/Options.h"
#include "lldb/Utility/State.h"
#include "llvm/ADT/SetVector.h"
#include "llvm/ADT/StringRef.h"

#include <iomanip>
#include <sstream>

using namespace lldb;
using namespace lldb_private;

namespace {

#define LLDB_OPTIONS_ipu_soc
#define LLDB_OPTIONS_ipu_app
// TableGen'erated command options.
#include "CommandObjectIPUOptions.inc"

#undef LLDB_OPTIONS_ipu_soc
#undef LLDB_OPTIONS_ipu_app

} // namespace

static const char *no_tile_error =
    "not attached to any tile, use 'ipu tile attach <tile-id>'";

//===----------------------------------------------------------------------===//
// CommandObjectIPUSoC
//===----------------------------------------------------------------------===//

namespace {

class CommandObjectIPUSoC final : public CommandObjectParsed {
public:
  CommandObjectIPUSoC(CommandInterpreter &interpreter,
                      PlatformColossus &platform);

  ~CommandObjectIPUSoC() override = default;

  Options *GetOptions() override { return &m_options; }

private:
  enum SoCReg : unsigned {
    eSoCRegTR,
    eSoCRegXB,
    eSoCRegPCI,
    eSoCRegNLC,
    eSoCRegSS,
    eSoCNumRegs
  };

  bool DoExecute(Args &command, CommandReturnObject &result) override;

  class CommandOptions final : public Options {
  public:
    Status SetOptionValue(uint32_t option_idx, llvm::StringRef option_arg,
                          ExecutionContext *execution_context) override;

    void OptionParsingStarting(ExecutionContext *execution_context) override {}

    llvm::ArrayRef<OptionDefinition> GetDefinitions() override {
      return llvm::makeArrayRef(g_ipu_soc_options);
    }

    // TODO: Change this to `false` once we enable pretty-printing.
    bool m_dump = true;
  };

  PlatformColossus &m_platform;
  CommandOptions m_options;
};

} // namespace

CommandObjectIPUSoC::CommandObjectIPUSoC(CommandInterpreter &interpreter,
                                         PlatformColossus &platform)
    : CommandObjectParsed(interpreter, "ipu soc",
                          "Read the specified SoC register(s)",
                          "ipu soc <register-names> [<command-options>]",
                          eCommandRequiresTarget),
      m_platform(platform) {
  SetHelpLong(R"(
The <register-names> can be any of the following:
  tr:  TR registers
  xb:  XB registers
  pci: PCI registers
  nlc: NLC registers
  ss:  SS registers

Example:
  (lldb) ipu soc tr xb --dump # Dump TR and XB registers from GCDA.
)");

  CommandArgumentData soc_reg_name_arg;
  soc_reg_name_arg.arg_type = eArgTypeName;
  soc_reg_name_arg.arg_repetition = eArgRepeatPlus;

  m_arguments.push_back(CommandArgumentEntry{soc_reg_name_arg});
}

bool CommandObjectIPUSoC::DoExecute(Args &command,
                                    CommandReturnObject &result) {
  if (command.empty()) {
    result.AppendError("No SoC registers specified.");
    result.SetStatus(eReturnStatusFailed);
    return false;
  }

  // Saves selected SoC registers by the order they are specified.
  llvm::SmallSetVector<unsigned, 8> selected_soc_regs;
  // Parse SoC register names. Emit warnings for invalid register names.
  for (const Args::ArgEntry &arg : command) {
    auto reg = llvm::StringSwitch<SoCReg>(arg.c_str())
                   .Case("tr", eSoCRegTR)
                   .Case("xb", eSoCRegXB)
                   .Case("pci", eSoCRegPCI)
                   .Case("nlc", eSoCRegNLC)
                   .Case("ss", eSoCRegSS)
                   .Default(eSoCNumRegs);
    if (reg != eSoCNumRegs)
      selected_soc_regs.insert(reg);
    else
      result.AppendWarningWithFormatv("'{0}' is not a SoC register name.",
                                      arg.c_str());
  }
  if (selected_soc_regs.empty()) {
    result.AppendError("No valid SoC register name selected.");
    result.SetStatus(eReturnStatusFailed);
    return false;
  }

  auto gcda = m_platform.GetLockedGCDA();
  auto device_sp = gcda->instance.getDevice(0);

  // If the option to dump directly from GCDA was specified, dump all selected
  // SoC registers.
  if (m_options.m_dump) {
    std::ostringstream os;
    for (auto soc_reg : selected_soc_regs) {
      switch (soc_reg) {
      case eSoCRegTR:
        device_sp->dumper.dumpTrRegs(os);
        break;

      case eSoCRegXB:
        device_sp->dumper.dumpXbRegs(os);
        break;

      case eSoCRegPCI:
        device_sp->dumper.dumpPciRegs(os);
        break;

      case eSoCRegNLC:
        device_sp->dumper.dumpNlcRegs(os);
        break;

      case eSoCRegSS:
        device_sp->dumper.dumpSsRegs(os);
        break;

      default:
        llvm_unreachable("unhandled soc register");
      }
    }
    result.AppendMessage(os.str());
  }

  return true;
}

Status CommandObjectIPUSoC::CommandOptions::SetOptionValue(uint32_t option_idx,
                                                           llvm::StringRef,
                                                           ExecutionContext *) {
  Status error;
  const int short_option = m_getopt_table[option_idx].val;

  switch (short_option) {
  case 'd':
    m_dump = true;
    break;

  default:
    llvm_unreachable("Unimplemented option");
  }

  return error;
}

//===----------------------------------------------------------------------===//
// CommandObjectIPULog
//===----------------------------------------------------------------------===//

namespace {

class CommandObjectIPULog final : public CommandObjectParsed {
public:
  CommandObjectIPULog(CommandInterpreter &interpreter,
                      PlatformColossus &platform);

  ~CommandObjectIPULog() override = default;

  bool DoExecute(Args &command, CommandReturnObject &result) override;

private:
  PlatformColossus &m_platform;
};

CommandObjectIPULog::CommandObjectIPULog(CommandInterpreter &interpreter,
                                         PlatformColossus &platform)
    : CommandObjectParsed(interpreter, "ipu log",
                          "Enable IPU device logging at the specified level",
                          "ipu log <logging-level>", eCommandRequiresTarget),
      m_platform(platform) {
  SetHelpLong(R"(
The <logging-level> is one of the following:
  trace:    Full verbose logging, including TDI operations
  debug:    Log debugging operations
  info:     Log high-level device operations
  warning:  Log non-critical errors
  error:    Log device errors
  critical: Log only critical failures
  off:      Disable logging

Examples:
  (lldb) ipu log debug  # Enable logging for debugging operations
  (lldb) ipu log off    # Disable logging
)");

  CommandArgumentData soc_reg_name_arg;
  soc_reg_name_arg.arg_type = eArgTypeName;
  soc_reg_name_arg.arg_repetition = eArgRepeatPlain;

  m_arguments.push_back(CommandArgumentEntry{soc_reg_name_arg});
}

bool CommandObjectIPULog::DoExecute(Args &command,
                                    CommandReturnObject &result) {
  const char *log_level_str = command.GetArgumentAtIndex(0);

  auto log_level =
      llvm::StringSwitch<
          llvm::Optional<GraphcoreDeviceAccessTypes::LoggingLevel>>(
          log_level_str)
          .Case("trace", GraphcoreDeviceAccessTypes::Trace)
          .Case("debug", GraphcoreDeviceAccessTypes::Debug)
          .Case("info", GraphcoreDeviceAccessTypes::Info)
          .Case("warning", GraphcoreDeviceAccessTypes::Warn)
          .Case("error", GraphcoreDeviceAccessTypes::Err)
          .Case("critical", GraphcoreDeviceAccessTypes::Critical)
          .Case("off", GraphcoreDeviceAccessTypes::Off)
          .Default(llvm::None);
  if (!log_level) {
    result.AppendError("No valid logging level selected.");
    result.SetStatus(eReturnStatusFailed);
    return false;
  }

  auto gcda = m_platform.GetLockedGCDA();
  gcda->trace.setLogLevel(*log_level);

  if (*log_level == GraphcoreDeviceAccessTypes::Off)
    result.AppendMessage("disabled IPU device logging");
  else
    result.AppendMessageWithFormatv("set IPU device logging level to '{0}'",
                                    log_level_str);

  return true;
}

} // namespace

//===----------------------------------------------------------------------===//
// CommandObjectIPUAppContinue
//===----------------------------------------------------------------------===//

namespace {

class CommandObjectIPUAppContinue final : public CommandObjectParsed {
public:
  CommandObjectIPUAppContinue(CommandInterpreter &interpreter,
                              PlatformColossus &platform)
      : CommandObjectParsed(interpreter, "continue",
                            "Resume execution of all tiles", "ipu app continue",
                            eCommandRequiresTarget | eCommandRequiresProcess),
        m_platform(platform) {}

  ~CommandObjectIPUAppContinue() override = default;

private:
  PlatformColossus &m_platform;

  bool DoExecute(Args &command, CommandReturnObject &result) override;

  const char *GetInvalidProcessDescription() override { return no_tile_error; }
};

} // namespace

bool CommandObjectIPUAppContinue::DoExecute(Args &command,
                                            CommandReturnObject &result) {
  for (auto &it : m_platform.GetProcesses()) {
    auto process = it.second;
    result.AppendMessageWithFormatv("Resuming tile {0}", process->GetTileNum());
    process->Resume();
  }
  return true;
}

//===----------------------------------------------------------------------===//
// CommandObjectIPUAppInterrupt
//===----------------------------------------------------------------------===//

namespace {

class CommandObjectIPUAppInterrupt final : public CommandObjectParsed {
public:
  CommandObjectIPUAppInterrupt(CommandInterpreter &interpreter,
                               PlatformColossus &platform)
      : CommandObjectParsed(interpreter, "interrupt",
                            "Halt execution of all tiles", "ipu app interrupt",
                            eCommandRequiresTarget | eCommandRequiresProcess),
        m_platform(platform) {}

  ~CommandObjectIPUAppInterrupt() override = default;

private:
  PlatformColossus &m_platform;

  bool DoExecute(Args &command, CommandReturnObject &result) override;

  const char *GetInvalidProcessDescription() override { return no_tile_error; }
};

} // namespace

bool CommandObjectIPUAppInterrupt::DoExecute(Args &command,
                                             CommandReturnObject &result) {
  for (auto &it : m_platform.GetProcesses()) {
    auto process = it.second;
    result.AppendMessageWithFormatv("Halting tile {0}", process->GetTileNum());
    process->Halt();
  }
  return true;
}

//===----------------------------------------------------------------------===//
// CommandObjectIPUApp
//===----------------------------------------------------------------------===//

namespace {

class CommandObjectIPUApp final : public CommandObjectMultiword {
public:
  CommandObjectIPUApp(CommandInterpreter &interpreter,
                      PlatformColossus &platform);

  ~CommandObjectIPUApp() override = default;
};

} // namespace

CommandObjectIPUApp::CommandObjectIPUApp(CommandInterpreter &interpreter,
                                         PlatformColossus &platform)
    : CommandObjectMultiword(interpreter, "ipu app",
                             "Application-wide IPU commands",
                             "ipu app <subcommand> [<command-options>]") {
  CommandObjectSP continue_command_object(
      new CommandObjectIPUAppContinue(interpreter, platform));
  CommandObjectSP interrupt_command_object(
      new CommandObjectIPUAppInterrupt(interpreter, platform));

  LoadSubCommand("continue", continue_command_object);
  LoadSubCommand("interrupt", interrupt_command_object);
}

//===----------------------------------------------------------------------===//
// CommandObjectIPUTileSelect
//===----------------------------------------------------------------------===//

namespace {

class CommandObjectIPUTileSelect final : public CommandObjectParsed {
public:
  CommandObjectIPUTileSelect(CommandInterpreter &interpreter,
                             PlatformColossus &platform)
      : CommandObjectParsed(interpreter, "tile", "Select the current tile",
                            "ipu tile select",
                            eCommandRequiresTarget | eCommandRequiresProcess),
        m_platform(platform) {
    CommandArgumentData tile_arg(eArgTypeUnsignedInteger, eArgRepeatPlain);
    m_arguments.push_back({tile_arg});
  }

  ~CommandObjectIPUTileSelect() override = default;

private:
  PlatformColossus &m_platform;

  bool DoExecute(Args &command, CommandReturnObject &result) override;

  const char *GetInvalidProcessDescription() override { return no_tile_error; }
};

} // namespace

bool CommandObjectIPUTileSelect::DoExecute(Args &command,
                                           CommandReturnObject &result) {
  if (command.GetArgumentCount() == 1) {
    const char *tile_index_arg = command.GetArgumentAtIndex(0);
    unsigned tile_idx;
    if (llvm::to_integer(tile_index_arg, tile_idx)) {
      TargetList &target_list = GetDebugger().GetTargetList();
      auto target = m_platform.GetTargets().find(tile_idx);
      if (target != m_platform.GetTargets().end()) {
        target_list.SetSelectedTarget(target->second);
        result.AppendMessageWithFormatv("Tile {0} selected.", tile_idx);
        return false;
      } else {
        result.AppendErrorWithFormatv("Not attached to tile {0}.", tile_idx);
        return false;
      }
    } else {
      result.AppendErrorWithFormatv("Expected integer tile index, got '{0}'.",
                                    tile_index_arg);
      return false;
    }
  } else {
    result.AppendError("Expected one argument (tile index).");
    return false;
  }
}

//===----------------------------------------------------------------------===//
// CommandObjectIPUTileAttach
//===----------------------------------------------------------------------===//

namespace {

class CommandObjectIPUTileAttach final : public CommandObjectParsed {
public:
  CommandObjectIPUTileAttach(CommandInterpreter &interpreter,
                             PlatformColossus &platform)
      : CommandObjectParsed(interpreter, "attach", "Attach to a tile",
                            "ipu tile attach <tile-id> | 'all'",
                            eCommandRequiresTarget),
        m_platform(platform) {
    CommandArgumentData tile_arg(eArgTypeUnsignedInteger, eArgRepeatPlain);
    m_arguments.push_back({tile_arg});
  }

  ~CommandObjectIPUTileAttach() override = default;

private:
  PlatformColossus &m_platform;

  bool DoExecute(Args &command, CommandReturnObject &result) override;
};

} // namespace

bool CommandObjectIPUTileAttach::DoExecute(Args &command,
                                           CommandReturnObject &result) {
  if (command.GetArgumentCount() != 1) {
    result.AppendError("expected argument <tile-id> | 'all'");
    return false;
  }

  Status err;
  ProcessSP remote_process_sp;
  const char *tile_index_arg = command.GetArgumentAtIndex(0);
  unsigned tile_idx, num_tiles = m_platform.GetNumTilesPerIPU();

  // We accept two formats for this argument: the string 'all', or a tile ID.
  if (llvm::StringRef(tile_index_arg).equals("all")) {
    remote_process_sp = m_platform.AttachAllTiles(GetDebugger(), err);
  } else {
    if (!llvm::to_integer(tile_index_arg, tile_idx)) {
      result.AppendErrorWithFormat(
          "expected integer tile index or 'all', got '%s'.", tile_index_arg);
      return false;
    }
    if (tile_idx >= num_tiles) {
      result.AppendErrorWithFormat("tile %u out of range (0 - %u).", tile_idx,
                                   num_tiles);
      return false;
    }
    remote_process_sp =
        m_platform.AttachSingleTile(GetDebugger(), tile_idx, err);
  }

  if (err.Fail()) {
    result.AppendError(err.AsCString());
    result.SetStatus(eReturnStatusFailed);
  } else if (!remote_process_sp) {
    result.AppendError("could not attach: unknown reason");
    result.SetStatus(eReturnStatusFailed);
  } else {
    result.SetStatus(eReturnStatusSuccessFinishResult);
  }
  return result.Succeeded();
}

//===----------------------------------------------------------------------===//
// CommandObjectIPUTileList
//===----------------------------------------------------------------------===//

namespace {

class CommandObjectIPUTileList final : public CommandObjectParsed {
public:
  CommandObjectIPUTileList(CommandInterpreter &interpreter,
                           PlatformColossus &platform)
      : CommandObjectParsed(interpreter, "tile", "Show status all tiles",
                            "ipu tile list",
                            eCommandRequiresTarget | eCommandRequiresProcess),
        m_platform(platform) {}

  ~CommandObjectIPUTileList() override = default;

private:
  PlatformColossus &m_platform;

  bool DoExecute(Args &command, CommandReturnObject &result) override;

  const char *GetInvalidProcessDescription() override { return no_tile_error; }
};

} // namespace

static std::string GetThreadSummary(ProcessColossus &process) {
  std::string tile_summary;

  unsigned inactive_threads = 0;
  unsigned active_threads = 0;
  unsigned active_workers = 0;
  unsigned inactive_workers = 0;

  std::string supervisor_summary;
  std::string workers_summary;

  const auto &iai = process.GetIPUArchInfo();
  auto &thread_list = process.GetThreadList();
  for (const auto &thread_sp : thread_list.Threads()) {
    auto *thread = std::static_pointer_cast<ThreadColossus>(thread_sp).get();
    const auto thread_status = thread->GetTileCtxtStatus();
    const auto target_thread = thread->GetTargetThread();
    std::string thread_summary;
    if (target_thread == GraphcoreDeviceAccessTypes::Supervisor) {
      thread_summary = "SU";
    } else {
      thread_summary = "W" + std::to_string((int)target_thread - 1);
    }
    thread_summary += ": " + thread->GetShortStatus();

    if (thread_status == iai.TCTXT_STATUS_ACTIVE) {
      if (target_thread != GraphcoreDeviceAccessTypes::Supervisor) {
        active_workers++;
      }
      active_threads++;
    } else if (thread_status == iai.TCTXT_STATUS_INACTIVE) {
      if (target_thread != GraphcoreDeviceAccessTypes::Supervisor) {
        inactive_workers++;
      }
      inactive_threads++;
    }

    // append string to either supervisor_summary or workers_summary
    std::string &summary =
        (target_thread == GraphcoreDeviceAccessTypes::Supervisor)
            ? supervisor_summary
            : workers_summary;

    if (!thread_summary.empty() && !summary.empty()) {
      summary += ", ";
    }
    summary += thread_summary;
  }

  // if all threads are ACTIVE or INACTIVE, summarise
  if (inactive_threads == iai.CTXT_TOTAL) {
    tile_summary = "all threads INACTIVE";
  } else if (active_threads == iai.CTXT_TOTAL) {
    tile_summary = "all threads ACTIVE";
  } else {
    // ok, slightly more interesting
    tile_summary = supervisor_summary;

    // if the workers are all ACTIVE or INACTIVE, summarise
    if (active_workers == iai.CTXT_WORKERS) {
      workers_summary = "all workers ACTIVE";
    } else if (inactive_workers == iai.CTXT_WORKERS) {
      workers_summary = "all workers INACTIVE";
    }
    if (!workers_summary.empty() && !tile_summary.empty()) {
      tile_summary += ", ";
    }
    tile_summary += workers_summary;
  }
  // This string appears after a full stop, so capitalise first char
  tile_summary[0] = toupper(tile_summary[0]);

  return tile_summary;
}

bool CommandObjectIPUTileList::DoExecute(Args &command,
                                         CommandReturnObject &result) {
  std::string path = m_platform.GetTargets()
                         .cbegin()
                         ->second->GetExecutableModule()
                         ->GetFileSpec()
                         .GetPath();

  result.AppendMessageWithFormatv(
      "Loaded program {0}, {1} tiles across {2} IPUs.", path.c_str(),
      m_platform.GetTargets().size(), m_platform.GetNumIpus());

  auto selected_process =
      GetDebugger().GetTargetList().GetSelectedTarget()->GetProcessSP();
  int selected_tile_num =
      std::static_pointer_cast<ProcessColossus>(selected_process)->GetTileNum();

  // Create and append a string that describes the state of either
  // a single tile, or of a range of tiles if they have an identical
  // summary string.
  const auto AppendTileSummary = [&](const std::string &summary, int tile,
                                     int last_different_tile) -> void {
    std::string tile_num_string;
    if ((selected_tile_num != tile) && (tile - last_different_tile > 0)) {
      // more than one tile has been the same
      tile_num_string = "  Tiles #" + std::to_string(last_different_tile) +
                        " - #" + std::to_string(tile);
    } else {
      // The selected tile has a "*" prefixed
      if (selected_tile_num == tile) {
        tile_num_string = "* ";
      } else {
        tile_num_string = "  ";
      }
      tile_num_string += "Tile #" + std::to_string(tile);
    }
    result.AppendMessageWithFormatv("{0}, {1}", tile_num_string.c_str(),
                                    summary.c_str());
  };

  std::string prev_tile_summary;
  std::string current_tile_summary;
  int last_different_tile = 0;
  int prev_tile_num = 0;
  int current_tile_num = 0;

  bool first_tile = true;
  for (auto &it : m_platform.GetProcesses()) {
    auto process = it.second;
    prev_tile_num = current_tile_num;
    prev_tile_summary = current_tile_summary;

    current_tile_summary = std::string() + StateAsCString(process->GetState()) +
                           ". " + GetThreadSummary(*process);
    current_tile_num = process->GetTileNum();
    if (first_tile) {
      last_different_tile = current_tile_num;
      first_tile = false;
    } else {
      if ((prev_tile_num == selected_tile_num) ||
          (current_tile_num == selected_tile_num) ||
          (prev_tile_summary != current_tile_summary) ||
          // Don't merge summaries if the tiles are discontiguous
          (prev_tile_num + 1 != current_tile_num)) {
        AppendTileSummary(prev_tile_summary, prev_tile_num,
                          last_different_tile);
        last_different_tile = current_tile_num;
      }
    }
  }
  AppendTileSummary(current_tile_summary, current_tile_num,
                    last_different_tile);

  return true;
}

//===----------------------------------------------------------------------===//
// CommandObjectIPUTile
//===----------------------------------------------------------------------===//

namespace {

class CommandObjectIPUTile final : public CommandObjectMultiword {
public:
  CommandObjectIPUTile(CommandInterpreter &interpreter,
                       PlatformColossus &platform);

  ~CommandObjectIPUTile() override = default;
};

} // namespace

CommandObjectIPUTile::CommandObjectIPUTile(CommandInterpreter &interpreter,
                                           PlatformColossus &platform)
    : CommandObjectMultiword(interpreter, "ipu tile", "IPU tile commands",
                             "ipu tile <subcommand> [<command-options>]") {

  CommandObjectSP select_command_object(
      new CommandObjectIPUTileSelect(interpreter, platform));
  CommandObjectSP list_command_object(
      new CommandObjectIPUTileList(interpreter, platform));
  CommandObjectSP attach_command_object(
      new CommandObjectIPUTileAttach(interpreter, platform));

  LoadSubCommand("select", select_command_object);
  LoadSubCommand("list", list_command_object);
  LoadSubCommand("attach", attach_command_object);
}

//===----------------------------------------------------------------------===//
// CommandObjectIPUThreadStatus
//===----------------------------------------------------------------------===//

namespace {

class CommandObjectIPUThreadStatus final : public CommandObjectParsed {
public:
  CommandObjectIPUThreadStatus(CommandInterpreter &interpreter,
                               PlatformColossus &platform)
      : CommandObjectParsed(interpreter, "status",
                            "Display current thread status",
                            "ipu thread status",
                            eCommandRequiresTarget | eCommandRequiresProcess),
        m_platform(platform) {}

  ~CommandObjectIPUThreadStatus() override = default;

private:
  PlatformColossus &m_platform;

  bool DoExecute(Args &command, CommandReturnObject &result) override;

  const char *GetInvalidProcessDescription() override { return no_tile_error; }
};

} // namespace

bool CommandObjectIPUThreadStatus::DoExecute(Args &command,
                                             CommandReturnObject &result) {
  auto selected_process = std::static_pointer_cast<ProcessColossus>(
      GetDebugger().GetTargetList().GetSelectedTarget()->GetProcessSP());
  auto selected_tile = selected_process->GetTileNum();
  auto selected_thread =
      std::static_pointer_cast<ThreadColossus>(
          selected_process->GetThreadList().GetSelectedThread())
          ->GetTargetThread();

  std::ostringstream os;
  auto ipu = selected_process->GetLockedIPU();
  ipu->dumper.dumpRegisters(selected_tile,
                            GraphcoreDeviceAccessTypes::TargetDebugInterface,
                            selected_thread, os);
  ipu->dumper.dumpThreadRegisters(selected_tile, selected_thread, os);
  result.AppendMessage(os.str());

  return true;
}

//===----------------------------------------------------------------------===//
// CommandObjectIPUThreadList
//===----------------------------------------------------------------------===//

namespace {

class CommandObjectIPUThreadList final : public CommandObjectParsed {
public:
  CommandObjectIPUThreadList(CommandInterpreter &interpreter,
                             PlatformColossus &platform)
      : CommandObjectParsed(interpreter, "list",
                            "Display status of all threads", "ipu thread list",
                            eCommandRequiresTarget | eCommandRequiresProcess |
                                eCommandProcessMustBePaused |
                                eCommandProcessMustBeLaunched),
        m_platform(platform) {}

  ~CommandObjectIPUThreadList() override = default;

private:
  PlatformColossus &m_platform;

  bool DoExecute(Args &command, CommandReturnObject &result) override;

  const char *GetInvalidProcessDescription() override { return no_tile_error; }
};

} // namespace

bool CommandObjectIPUThreadList::DoExecute(Args &command,
                                           CommandReturnObject &result) {
  const auto selected_process = std::static_pointer_cast<ProcessColossus>(
      GetDebugger().GetTargetList().GetSelectedTarget()->GetProcessSP());

  const Module *mod =
      selected_process->GetTarget().GetExecutableModulePointer();
  const auto &filename = mod->GetFileSpec().GetFilename();
  result.AppendMessageWithFormat("Tile %d stopped. Program binary: %s\n",
                                 selected_process->GetTileNum(),
                                 filename.AsCString());

  for (const auto &lldb_thread : selected_process->GetThreadList().Threads()) {
    ExecutionContext thread_exe_ctx(lldb_thread);
    auto *thread = std::static_pointer_cast<ThreadColossus>(lldb_thread).get();

    const StackFrameSP frame_sp = thread->GetStackFrameAtIndex(0);
    SymbolContext frame_sc;
    if (frame_sp) {
      thread_exe_ctx.SetFrameSP(frame_sp);
      frame_sc = frame_sp->GetSymbolContext(eSymbolContextEverything);
    }

    bool is_selected =
        selected_process->GetThreadList().GetSelectedThread() == lldb_thread;

    std::ostringstream thread_format;
    thread_format << (is_selected ? "* " : "  ");
    thread_format << "thread #${thread.index}: ";
    thread_format << std::setw(10) << thread->GetName() << ": ";

    std::string thread_status = thread->GetShortStatus();
    if (thread_status == "ACTIVE") {
      thread_format << "${ansi.fg.green}";
    } else if (thread_status == "INACTIVE") {
      thread_format << "${ansi.fg.cyan}";
    } else if (thread_status.find("TEXCPT_") != std::string::npos) {
      thread_format << "${ansi.fg.red}";
    } else {
      thread_format << "${ansi.fg.yellow}";
    }
    thread_format << std::left << std::setw(20) << thread_status;
    thread_format << "${ansi.normal}";

    // Backtrace
    thread_format << "{ ${ansi.fg.yellow}${frame.pc}${ansi.normal}}"
                     "{ ${function.name-with-args}"
                     "{${frame.no-debug}${function.pc-offset}}}"
                     "{ at ${ansi.fg.cyan}${line.file.basename}${ansi.normal}"
                     "{:${ansi.fg.yellow}${line.number}${ansi.normal}}"
                     "{:${ansi.fg.yellow}${line.column}${ansi.normal}}"
                     "}\n";
    FormatEntity::FormatCString(thread_format.str().c_str(),
                                result.GetOutputStream(),
                                frame_sp ? &frame_sc : nullptr, &thread_exe_ctx,
                                nullptr, nullptr, false, false);
  }

  return true;
}

//===----------------------------------------------------------------------===//
// CommandObjectIPUThread
//===----------------------------------------------------------------------===//

namespace {

class CommandObjectIPUThread final : public CommandObjectMultiword {
public:
  CommandObjectIPUThread(CommandInterpreter &interpreter,
                         PlatformColossus &platform);

  ~CommandObjectIPUThread() override = default;
};

} // namespace

CommandObjectIPUThread::CommandObjectIPUThread(CommandInterpreter &interpreter,
                                               PlatformColossus &platform)
    : CommandObjectMultiword(interpreter, "ipu thread",
                             "Commands which apply to IPU tile threads",
                             "ipu thread <subcommand> [<command-options>]") {
  LoadSubCommand("status", CommandObjectSP(new CommandObjectIPUThreadStatus(
                               interpreter, platform)));
  LoadSubCommand("list", CommandObjectSP(new CommandObjectIPUThreadList(
                             interpreter, platform)));
}

//===----------------------------------------------------------------------===//
// CommandObjectIPU
//===----------------------------------------------------------------------===//

CommandObjectIPU::CommandObjectIPU(CommandInterpreter &interpreter,
                                   PlatformColossus &platform)
    : CommandObjectMultiword(interpreter, "ipu",
                             "Commands for operating on IPU devices (see 'help "
                             "ipu' for shorthand.)",
                             "ipu <subcommand> [<command-options>]"),
      m_platform(platform) {
  LoadSubCommand(
      "soc", CommandObjectSP(new CommandObjectIPUSoC(interpreter, platform)));
  LoadSubCommand(
      "log", CommandObjectSP(new CommandObjectIPULog(interpreter, platform)));
  LoadSubCommand(
      "app", CommandObjectSP(new CommandObjectIPUApp(interpreter, platform)));
  LoadSubCommand(
      "tile", CommandObjectSP(new CommandObjectIPUTile(interpreter, platform)));
  LoadSubCommand("thread", CommandObjectSP(new CommandObjectIPUThread(
                               interpreter, platform)));
}

CommandObjectIPU::~CommandObjectIPU() = default;
