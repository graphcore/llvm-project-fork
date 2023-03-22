//===-- ProcessColossus.cpp -------------------------------------*- C++ -*-===//
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

// C Includes
#include <stdlib.h>

// C++ Includes
#include <mutex>

// Other libraries and framework includes
#include "Plugins/ObjectFile/ELF/ObjectFileELF.h"
#include "lldb/Breakpoint/Watchpoint.h"
#include "lldb/Core/Debugger.h"
#include "lldb/Core/Module.h"
#include "lldb/Core/ModuleSpec.h"
#include "lldb/Core/PluginManager.h"
#include "lldb/Core/Section.h"
#include "lldb/Host/ThreadLauncher.h"
#include "lldb/Interpreter/OptionValueProperties.h"
#include "lldb/Target/DynamicLoader.h"
#include "lldb/Target/StopInfo.h"
#include "lldb/Target/Target.h"
#include "lldb/Target/UnixSignals.h"
#include "lldb/Utility/DataBufferHeap.h"
#include "lldb/Utility/Log.h"
#include "lldb/Utility/State.h"
#include "lldb/lldb-enumerations.h"
#include "llvm/BinaryFormat/ELF.h"
#include "llvm/Support/SaveAndRestore.h"

#include "Plugins/Platform/Colossus/PlatformColossus.h"
#include "ProcessColossus.h"
#include "ProcessColossusLog.h"
#include "RegisterContextColossus.h"
#include "ThreadColossus.h"

using namespace lldb_private;

using namespace lldb;

LLDB_PLUGIN_DEFINE(ProcessColossus)

//===----------------------------------------------------------------------===//
// Plugin Properties
//===----------------------------------------------------------------------===//

namespace {

#define LLDB_PROPERTIES_processcolossus
#include "ProcessColossusProperties.inc"

enum {

#define LLDB_PROPERTIES_processcolossus
#include "ProcessColossusPropertiesEnum.inc"

};

class PluginProperties final : public Properties {
public:
  static ConstString GetSettingName() {
    return ConstString(ProcessColossus::GetPluginNameStatic());
  }

  PluginProperties() : Properties() {
    m_collection_sp = std::make_shared<OptionValueProperties>(GetSettingName());
    m_collection_sp->Initialize(g_processcolossus_properties);
  }

  ~PluginProperties() override {}

  bool GetStopSyscall() const {
    return m_collection_sp->GetPropertyAtIndexAsBoolean(
        nullptr, ePropertyStopSyscall, /*fail_value=*/false);
  }
};

using ProcessColossusPropertiesSP = std::shared_ptr<PluginProperties>;

static ProcessColossusPropertiesSP &GetGlobalPluginProperties() {
  static ProcessColossusPropertiesSP g_settings_sp;
  if (!g_settings_sp)
    g_settings_sp = std::make_shared<PluginProperties>();
  return g_settings_sp;
}

} // namespace

//===----------------------------------------------------------------------===//
// ProcessColossus
//===----------------------------------------------------------------------===//

const char *ProcessColossus::GetPluginDescriptionStatic() {
  return "Colossus plug-in.";
}

void ProcessColossus::Terminate() {}

lldb_private::Status ProcessColossus::DoLaunch(Module *exe_module,
                                               ProcessLaunchInfo &launch_info) {
  lldb_private::Status result;
  return result;
}

/* TODO: Implement this. Task T28869. */
Status ProcessColossus::DoDetach(bool keep_stopped) {
  // This is just the minimal support required for 'quit' to not hang.
  // It is not full support for detaching/attaching.
  Status result;
  SetPrivateState(eStateDetached);
  ResumePrivateStateThread();
  return result;
}

lldb_private::Status
ProcessColossus::DoAttachToProcessWithID(lldb::pid_t pid,
                                         const ProcessAttachInfo &attach_info) {
  lldb_private::Status result;

  SetID(pid);
  m_iai = &m_platform->GetIPUArchInfo(pid);
  m_tile_num = m_platform->GetTileNumFromPid(pid);
  m_ipu_index = m_platform->GetIPUIndexFromPid(pid);
  m_num_threads = m_platform->GetThreadsPerTile();

  // We need to be stopped for RefreshStateAfterStop to populate m_thread_list
  SetPrivateState(eStateStopped);
  m_thread_list.RefreshStateAfterStop();

  bool unused;
  DoHalt(unused);

  return result;
}

lldb::ProcessSP ProcessColossus::CreateInstance(lldb::TargetSP target_sp,
                                                lldb::ListenerSP listener_sp,
                                                const lldb_private::FileSpec *,
                                                bool /*can_connect*/) {
  lldb::ProcessSP process_sp;

  process_sp.reset(new ProcessColossus(target_sp, listener_sp));

  return process_sp;
}

bool ProcessColossus::CanDebug(lldb::TargetSP target_sp,
                               bool plugin_specified_by_name) {
  return true;
}

ProcessColossus::ProcessColossus(lldb::TargetSP target_sp,
                                 lldb::ListenerSP listener_sp)
    : Process(target_sp, listener_sp),
      m_platform(static_cast<lldb_private::PlatformColossus *>(
          GetTarget().GetPlatform().get())),
      m_os(llvm::Triple::UnknownOS) {}

ProcessColossus::~ProcessColossus() {
  Clear();
  // We need to call finalize on the process before destroying ourselves
  // to make sure all of the broadcaster cleanup goes as planned. If we
  // destruct this class, then Process::~Process() might have problems
  // trying to fully destroy the broadcaster.
  Finalize();
}

bool ProcessColossus::DoUpdateThreadList(ThreadList &old_thread_list,
                                         ThreadList &new_thread_list) {
  auto *log = GetLog(ColossusLog::Process);
  LLDB_LOG(log, "ProcessColossus::{0}, pid = {1}", __FUNCTION__, GetID());

  // Create the initial thread list.
  if (old_thread_list.GetSize(false) == 0) {
    for (lldb::tid_t tid = 1; tid <= m_num_threads; ++tid) {
      lldb::ThreadSP thread_sp(new ThreadColossus(*this, tid));
      new_thread_list.AddThread(thread_sp);
    }
    return true;
  }

  // We have fixed threads, so don't update the list.
  return false;
}

void ProcessColossus::RefreshStateAfterStop() {
  auto *log = GetLog(ColossusLog::Process);
  LLDB_LOG(log, "ProcessColossus::{0}, pid = {1}", __FUNCTION__, GetID());

  m_thread_exceptions_mutex.lock();
  const auto thread_exceptions = std::move(m_thread_exceptions);
  m_thread_exceptions_mutex.unlock();

  // Stop IPU threads if the process halted. Doing it here prevents it to be
  // asynchronously intertwined with runThread during resume.
  if (!thread_exceptions.empty())
    StopThreads();

  // Handle tile exceptions. Must be done after process stops in order for
  // information (e.g. stop information) to be correctly associated with the
  // ID of the process that stopped.
  for (const auto &exception_info : thread_exceptions) {
    auto thread_sp =
        m_thread_list.FindThreadByID(exception_info.tid, /*can_update=*/false);
    if (auto *thread = static_cast<ThreadColossus *>(thread_sp.get()))
      HandleTileException(thread, exception_info);
    // If no stop info description is provided, fall-back to tile exception
    // name.
    //
    // NOTE: It's important to check for the stop description here since
    // `GetDescription` will cache a description once, based on the current
    // state of the stop information.
    if (auto stop_info_sp = thread_sp->GetStopInfo())
      if (!stop_info_sp->GetDescription()) {
        const std::string &desc =
            m_iai->TileException.findNameByValue(exception_info.tile_exception);
        stop_info_sp->SetDescription(desc.c_str());
      }
  }

  m_thread_list.RefreshStateAfterStop();
}

lldb_private::Status
ProcessColossus::EnableBreakpointSite(lldb_private::BreakpointSite *bp_site) {
  auto *log = GetLog(ColossusLog::Breakpoints);
  LLDB_LOG(log, "ProcessColossus::{0}, bp_site = {1:x} id = {2}, addr = {3:x}",
           __FUNCTION__, bp_site, bp_site->GetID(), bp_site->GetLoadAddress());

  if (bp_site->HardwareRequired()) {
    auto ipu = GetLockedIPU();
    Status error;

    // Verify that no other hardware breakpoints are already set as only a
    // single hardware breakpoint can be set at a time.
    GetBreakpointSiteList().ForEach([this, &error](BreakpointSite *bp_site) {
      if (bp_site->HardwareRequired())
        error.SetErrorStringWithFormatv(
            "hardware breakpoint already in place at tile {0}, address {1:x}",
            GetTileNum(), bp_site->GetLoadAddress());
    });
    if (error.Fail()) {
      bp_site->SetEnabled(false);
      return error;
    }

    LLDB_LOG(log, "ProcessColossus::{0}, enabling hardware breakpoint",
             __FUNCTION__);

    ipu->debug.enableIBreak(GetTileNum(),
                            GraphcoreDeviceAccessTypes::IbrkTarget::enableAll,
                            bp_site->GetLoadAddress());
    bp_site->SetEnabled(true);
    bp_site->SetType(BreakpointSite::eHardware);
    return error;
  }

  return EnableSoftwareBreakpoint(bp_site);
}

lldb_private::Status
ProcessColossus::DisableBreakpointSite(lldb_private::BreakpointSite *bp_site) {
  auto *log = GetLog(ColossusLog::Breakpoints);
  LLDB_LOG(log, "ProcessColossus::{0}, bp_site = {1:x} id = {2}, addr = {3:x}",
           __FUNCTION__, bp_site, bp_site->GetID(), bp_site->GetLoadAddress());

  if (bp_site->HardwareRequired()) {
    auto ipu = GetLockedIPU();

    LLDB_LOG(log, "ProcessColossus::{0}, disabling hardware breakpoint",
             __FUNCTION__);

    ipu->debug.disableIBreak(GetTileNum());
    bp_site->SetEnabled(false);
    return Status();
  }

  return DisableSoftwareBreakpoint(bp_site);
}

lldb_private::Status ProcessColossus::GetWatchpointSupportInfo(uint32_t &num) {
  num = m_iai->TDBG_DBRK_CHANNELS;
  return {};
}

lldb_private::Status ProcessColossus::GetWatchpointSupportInfo(uint32_t &num,
                                                               bool &after) {
  GetWatchpointSupportInfo(num);
  // Watchpoints do *not* trigger after the load/store instruction is executed.
  after = false;
  return {};
}

lldb_private::Status ProcessColossus::EnableWatchpoint(Watchpoint *wp,
                                                       bool notify) {
  Status error;

  auto *log = GetLog(ColossusLog::Watchpoints);
  LLDB_LOG(log, "ProcessColossus::{0}, wp = {1:x}, id = {2}", __FUNCTION__, wp,
           wp->GetID());

  // Prevent creation of read watchpoints since no tile arch currently
  // implements data breaks on loads.
  if (wp->WatchpointRead()) {
    error.SetErrorStringWithFormatv("read watchpoint not supported");
    wp->SetEnabled(false, notify);
    return error;
  }

  // Prevent creation of multiple watchpoints. Only a single watchpoint is
  // allowed.
  if (wp_info) {
    error.SetErrorStringWithFormatv(
        "watchpoint already enabled: id = {0}, store address = {1:x}",
        wp_info->id, wp_info->hit_addr);
    return error;
  }

  auto tile_num = GetTileNum();
  ThreadColossus *sv_thread = GetSupervisorThread();
  auto sv_target_thread = sv_thread->GetTargetThread();
  auto ipu = GetLockedIPU();

  sv_thread->Stop();
  // Prevent creation of the watchpoint if one was already set by an external
  // source.
  auto &reg_ctx = sv_thread->GetRegisterContextColossus();
  if (reg_ctx.GetDBreakEnableBit()) {
    lldb::addr_t wp_hit_addr = reg_ctx.GetDBreakBase();
    error.SetErrorStringWithFormatv(
        "watchpoint already enabled (external): store address = {0:x}",
        wp_hit_addr);
    return error;
  }
  ipu->debug.restoreThread(tile_num, sv_target_thread);

  ipu->debug.enableDBreak(tile_num, wp->GetLoadAddress(), wp->GetByteSize());

  wp->SetEnabled(true, notify);
  wp->SetHardwareIndex(0);

  wp_info = BreakInfo(wp->GetID(), wp->GetLoadAddress());

  return error;
}

lldb_private::Status ProcessColossus::DisableWatchpoint(Watchpoint *wp,
                                                        bool notify) {
  auto *log = GetLog(ColossusLog::Watchpoints);
  LLDB_LOG(log, "ProcessColossus::{0}, wp = {1:x}, id = {2}", __FUNCTION__, wp,
           wp->GetID());

  auto ipu = GetLockedIPU();
  ipu->debug.disableDBreak(GetTileNum());

  wp->SetEnabled(false, notify);

  wp_info.reset();

  return {};
}

lldb_private::Status ProcessColossus::DoDestroy() {
  SetPrivateState(eStateExited);
  return {};
}

bool ProcessColossus::IsAlive() { return true; }

lldb_private::Status ProcessColossus::DoResume() {
  auto *log = GetLog(ColossusLog::Process);
  LLDB_LOG(log, "ProcessColossus::DoResume, pid = {0}", GetID());

  // Set the process to running first. If any exception happens after, this
  // ensures run -> stop order, which prevents the process from keep running
  // when it should actually stop.
  SetPrivateState(eStateRunning);

  // Resume all threads.
  for (const auto &thread_sp : m_thread_list.Threads()) {
    auto *thread = static_cast<ThreadColossus *>(thread_sp.get());
    bool context_changed = false;

    Status error = thread->Resume(&context_changed);
    if (error.Fail())
      return error;

    // Clear thread exception status if the tile context changed.
    if (context_changed) {
      LLDB_LOG(log,
               "ProcessColossus::DoResume, clear exception for thread '{0}'",
               thread->GetName());
      std::lock_guard<std::recursive_mutex> guard(m_thread_exceptions_mutex);
      auto it = m_thread_status.find(thread_sp->GetID());
      if (it != m_thread_status.end())
        m_thread_status.erase(it);
    }
  }

  return {};
}

void ProcessColossus::HandleTileException(
    ThreadColossus *thread, const TileExceptionInfo &tile_exception_info) {
  assert(thread);

  auto *log = GetLog(ColossusLog::Process);
  const auto tile_exception = tile_exception_info.tile_exception;

  if (log) {
    const std::string exception_name =
        m_iai->TileException.findNameByValue(tile_exception);
    LLDB_LOG(log, "ProcessColossus::{0}, thread = {1}, exception type = {2}",
             __FUNCTION__, thread->GetName(), exception_name);
  }

  // Handle instruction breaks.
  if (tile_exception == m_iai->TEXCPT_IBRK) {
    thread->HandleTileInstructionBreak();
    return;
  }

  // Handle data breaks.
  if (tile_exception == m_iai->TEXCPT_DBRK) {
    thread->HandleTileDataBreak();
    return;
  }

  // Handle patched breakpoints (trap 0).
  if (tile_exception == m_iai->TEXCPT_PBRK0) {
    if (ClearSoftwareSingleStepBreakpoint(thread->GetID()))
      thread->HandleTrace();
    else
      thread->HandleTilePatchedBreak();
    return;
  }

  // Handle system calls (trap 1).
  if (tile_exception == m_iai->TEXCPT_PBRK1) {
    thread->HandleSyscall(*tile_exception_info.syscall);
    return;
  }

  // Handle retirement breaks.
  if (tile_exception == m_iai->TEXCPT_RBRK) {
    thread->HandleTileRetirementBreak();
    return;
  }

  // Handle generic tile exceptions.
  if ((tile_exception == m_iai->TEXCPT_MEMERR) ||
      (tile_exception == m_iai->TEXCPT_EXERR) ||
      (tile_exception == m_iai->TEXCPT_INVALID_INSTR) ||
      (tile_exception == m_iai->TEXCPT_INVALID_PC) ||
      (tile_exception == m_iai->TEXCPT_INVALID_OP) ||
      (tile_exception == m_iai->TEXCPT_INVALID_ADDR) ||
      (tile_exception == m_iai->TEXCPT_EXCONF) ||
      (tile_exception == m_iai->TEXCPT_CONFLICT) ||
      (tile_exception == m_iai->TEXCPT_FP) ||
      (tile_exception == m_iai->TEXCPT_BOS) ||
      (tile_exception == m_iai->TEXCPT_PBRK1)) {
    thread->HandleGenericTileException(tile_exception);
    return;
  }

  // NOTE: Supposedly this function is never called if there is no tile
  // exception. If this happens, the exception name will be logged above.
  if (tile_exception == m_iai->TEXCPT_NONE)
    return;

  llvm_unreachable("unhandled tile exception");
}

void ProcessColossus::StopThreads() {
  for (const auto &thread_sp : m_thread_list.Threads()) {
    auto *thread = static_cast<ThreadColossus *>(thread_sp.get());
    thread->Stop();
  }
}

/// Handles the specified system call and returns \c true if the thread was
/// resumed, or \c false otherwise. If the thread is not resumed on an exit
/// system call, then \p exit_process is set to \c true if the process was
/// exited.
static bool HandleSyscall(const LockedIPU &ipu, ProcessColossus *process,
                          ThreadColossus *thread,
                          GraphcoreDeviceAccessTypes::SyscallType syscall_type,
                          bool &process_exited) {
  auto *log = GetLog(ColossusLog::Process);
  LLDB_LOG(log, "ProcessColossus::{0}, system call = {1}", __FUNCTION__,
           syscall_type);

  const auto tile_num = process->GetTileNum();
  const auto target_thread = thread->GetTargetThread();

  process_exited = false;
  const auto should_resume_thread = [&]() -> bool {
    switch (syscall_type) {
    case GraphcoreDeviceAccessTypes::Exit: {
      const unsigned exit_status =
          ipu->debug.getSyscallExit(tile_num, target_thread);
      LLDB_LOG(log, "syscall exit, status = {0}", exit_status);
      // Exiting the supervisor terminates the process, otherwise, set the exit
      // status for the worker to be handled later.
      if (thread->IsSupervisorThread()) {
        process->StopThreads();
        process->SetExitStatus(exit_status, nullptr);
        process_exited = true;
      } else
        thread->SetWorkerExitStatus(exit_status);
      return false;
    }

    case GraphcoreDeviceAccessTypes::Write: {
      unsigned num_bytes;
      const std::string buf =
          ipu->debug.getSyscallWrite(tile_num, target_thread, num_bytes);

      LLDB_LOG(log, "syscall write, buf = {0}, num_bytes = {1}", buf,
               num_bytes);
      return !GetGlobalPluginProperties()->GetStopSyscall();
    }

    case GraphcoreDeviceAccessTypes::GetArgs:
      // TODO: Use GCDA `getArgs` when `process launch` is implemented. T30690.
      LLDB_LOG(log, "syscall argv, argc = 0");
      return !GetGlobalPluginProperties()->GetStopSyscall();

    case GraphcoreDeviceAccessTypes::StackOverflow:
    case GraphcoreDeviceAccessTypes::NotDetected:
      return false;

    default:
      llvm_unreachable("unhandled system call");
    }
  }();

  if (should_resume_thread) {
    LLDB_LOG(log, "resuming thread from system call, tile = {0}, thread = {1}",
             tile_num, thread->GetName());
    ipu->debug.resumeFromSyscall(tile_num, target_thread);
  }

  return should_resume_thread;
}

void ProcessColossus::HandleInferiorException() {
  auto *log = GetLog(ColossusLog::Process);
  LLDB_LOG(log, "ProcessColossus::{0}, pid = {1}", __FUNCTION__, GetID());

  if (m_platform->IsAttachingToIPUs() || m_ignore_tile_exceptions) {
    LLDB_LOG(log, "ignored inferior exception");
    return;
  }

  // Process the tile exception for each thread. A tile exception happens when
  // one or more tile execution context status has changed, but each thread must
  // be checked individually since there is no exception for a specific thred.
  for (const auto &thread_sp : m_thread_list.Threads()) {
    auto *thread = static_cast<ThreadColossus *>(thread_sp.get());

    const auto thread_status = thread->GetTileCtxtStatus();
    const auto target_thread = thread->GetTargetThread();
    const lldb::tid_t tid = thread->GetID();
    const auto ipu = GetLockedIPU();

    const bool is_quiescent =
        ipu->debug.isThreadQuiescent(m_tile_num, target_thread);
    const bool is_excepted =
        (thread_status == m_iai->TCTXT_STATUS_EXCEPTED_DBG) ||
        (thread_status == m_iai->TCTXT_STATUS_EXCEPTED_NDBG);

    LLDB_LOG(log, "thread = {0}, status = {1}, quiescent? {2}",
             thread->GetName(), thread->GetTileCtxtStatusName(thread_status),
             is_quiescent);

    if (!is_quiescent || !is_excepted)
      continue;

    const auto syscall_type = ipu->debug.isSyscall(m_tile_num, target_thread);
    bool process_exited;
    if (HandleSyscall(ipu, this, thread, syscall_type, process_exited))
      continue;
    // Stop processing the exception if the process already exited.
    if (process_exited)
      return;

    std::lock_guard<std::recursive_mutex> guard(m_thread_exceptions_mutex);
    const auto thread_exception =
        ipu->debug.getExceptionType(m_tile_num, target_thread);
    const auto &entry = m_thread_status.try_emplace(tid, thread_exception);
    // Save the thread exception to be processed later or ignore the exception
    // if one was already saved and not yet processed.
    if (entry.second) {
      entry.first->second = thread_exception;
      m_thread_exceptions.emplace_back(tid, thread_exception, syscall_type);
    } else if (entry.first->second != thread_exception) {
      const std::string exception_name =
          m_iai->TileException.findNameByValue(thread_exception);
      LLDB_LOG(log, "ProcessColossus::{0}, ignoring exception {1}",
               __FUNCTION__, exception_name);
    } else {
      LLDB_LOG(log, "ProcessColossus::{0}, thread status did not change",
               __FUNCTION__);
    }
  }

  std::lock_guard<std::recursive_mutex> guard(m_thread_exceptions_mutex);
  // Stop the process if any exception relevant to the debugger is available
  // to be processed later.
  if (!m_thread_exceptions.empty())
    SetPrivateState(eStateStopped);
}

lldb_private::Status ProcessColossus::DoHalt(bool &caused_stop) {
  auto *log = GetLog(ColossusLog::Process);
  LLDB_LOG(log, "ProcessColossus::DoHalt, pid = {0}", GetID());

  llvm::SaveAndRestore<bool> saved_ignore(m_ignore_tile_exceptions, true);
  StopThreads();
  caused_stop = true;
  SetPrivateState(eStateStopped);

  return {};
}

GraphcoreDeviceAccessTypes::TargetThread
ProcessColossus::getFirstQuiescentThread(const LockedIPU &ipu) {
  auto *log = GetLog(ColossusLog::Process);
  const auto thread = ipu->debug.getFirstQuiescentThread(m_tile_num);

  if (static_cast<unsigned>(thread) < m_num_threads) {
    LLDB_LOG(log, "first quiescent thread: {0}", thread);
  } else {
    LLDB_LOG(log, "no quiescent thread available");
  }
  return thread;
}

// Modifies size to fit in available memory
// Returns false if addr is outside of memory or not word aligned
// Returns false if size is not word aligned
bool ProcessColossus::AttemptMakeValidTileAddressRange(
    lldb::addr_t addr, size_t &size, lldb_private::Status &error) {
  const unsigned base = m_iai->TMEM_BASE_ADDR;
  const unsigned end = base + (m_iai->TMEM_SIZE_WORDS * 4);
  const int remaining = end - addr;

  if ((addr < base) || (addr >= end) || (remaining < 0)) {
    error.SetErrorStringWithFormatv("address {0:x} out of range: {1:x} - {2:x}",
                                    addr, base, end);
    return false;
  }

  if (addr % 4 != 0) {
    error.SetErrorStringWithFormatv("address {0:x} is not on a 4 byte boundary",
                                    addr);
    return false;
  }

  if (size % 4 != 0) {
    error.SetErrorStringWithFormatv("size {0} is not a multiple of 4 bytes",
                                    size);
    return false;
  }

  size = std::min((size_t)remaining, size);

  return true;
}

size_t ProcessColossus::DoReadMemory(lldb::addr_t addr, void *buf, size_t size,
                                     lldb_private::Status &error) {
  auto *log = GetLog(ColossusLog::Process);
  LLDB_LOG(log, "ProcessColossus::{0}, pid = {1}, addr = {2:x}", __FUNCTION__,
           GetID(), addr);

  const auto ipu = GetLockedIPU();
  const auto target_thread = getFirstQuiescentThread(ipu);
  if (target_thread >= m_num_threads) {
    error.SetErrorStringWithFormat(
        "error: no quiescent threads available to read memory");
    return 0;
  }

  if (!AttemptMakeValidTileAddressRange(addr, size, error)) {
    return 0;
  }

  lldb::addr_t curr;
  auto dest = static_cast<unsigned *>(buf);

  for (curr = addr; curr < addr + size; curr += 4) {
    *dest = ipu->debug.readTileMemory(m_tile_num, target_thread, curr);
    dest++;
  }

  return size;
}

size_t ProcessColossus::DoWriteMemory(lldb::addr_t addr, const void *buf,
                                      size_t size,
                                      lldb_private::Status &error) {
  auto *log = GetLog(ColossusLog::Process);
  LLDB_LOG(log, "ProcessColossus::{0}, pid = {1}, addr = {2:x}", __FUNCTION__,
           GetID(), addr);

  const auto ipu = GetLockedIPU();
  const auto target_thread = getFirstQuiescentThread(ipu);
  if (target_thread >= m_num_threads) {
    error.SetErrorStringWithFormat(
        "error: no quiescent threads available to write memory");
    return 0;
  }

  if (!AttemptMakeValidTileAddressRange(addr, size, error)) {
    return 0;
  }

  lldb::addr_t curr;
  auto src = static_cast<const unsigned *>(buf);

  for (curr = addr; curr < addr + size; curr += 4) {
    ipu->debug.writeTileMemory(m_tile_num, target_thread, curr, *src);
    src++;
  }

  return size;
}

void ProcessColossus::SetSoftwareSingleStepBreakpoint(lldb::tid_t tid,
                                                      lldb::addr_t addr) {
  auto bp_info_it = m_thread_step_bps.find(tid);
  // Software single-stepping may be attempted multiple times on the same
  // address, for e.g. a data break when trying to step-over a breakpoint.
  // In such cases, the setup is already in place and nothing needs to be
  // done, but we expect the addresses to be always the same.
  if (bp_info_it != m_thread_step_bps.end()) {
    assert((addr == bp_info_it->second.hit_addr) &&
           "expecting single-stepping to overlap on the same address!");
    return;
  }

  // Create a software breakpoint for internal use in single-stepping.
  auto sw_step_bp = GetTarget().CreateBreakpoint(addr, /*internal=*/true,
                                                 /*request_hardware=*/false);
  sw_step_bp->SetBreakpointKind("software single-step");

  // Callback always returns false since internal single-step breakpoints should
  // never directly cause the program to stop.
  auto ShouldStop = [](void *, StoppointCallbackContext *, lldb::user_id_t,
                       lldb::user_id_t) { return false; };
  sw_step_bp->SetCallback(ShouldStop, this, /*is_synchronous=*/true);

  m_thread_step_bps.try_emplace(tid, BreakInfo(sw_step_bp->GetID(), addr));
}

bool ProcessColossus::ClearSoftwareSingleStepBreakpoint(lldb::tid_t tid) {
  auto it = m_thread_step_bps.find(tid);
  if (it == m_thread_step_bps.end())
    return false;

  GetTarget().RemoveBreakpointByID(it->second.id);
  m_thread_step_bps.erase(it);
  return true;
}

void ProcessColossus::Clear() {
  m_thread_list.Clear();
  m_os = llvm::Triple::UnknownOS;
}

void ProcessColossus::Initialize() {
  static std::once_flag g_once_flag;

  std::call_once(g_once_flag, []() {
    PluginManager::RegisterPlugin(GetPluginNameStatic(),
                                  GetPluginDescriptionStatic(), CreateInstance,
                                  DebuggerInitialize);
  });
}

void ProcessColossus::DebuggerInitialize(Debugger &debugger) {
  if (!PluginManager::GetSettingForProcessPlugin(
          debugger, PluginProperties::GetSettingName())) {
    PluginManager::CreateSettingForProcessPlugin(
        debugger, GetGlobalPluginProperties()->GetValueProperties(),
        ConstString("Properties for the colossus process plug-in."),
        /*is_global_setting=*/true);
  }
}

LockedIPU ProcessColossus::GetLockedIPU() {
  return m_platform->GetLockedIPU(GetID());
}

ThreadColossus *ProcessColossus::GetSupervisorThread() {
  return static_cast<ThreadColossus *>(
      GetThreadList()
          .FindThreadByID(ThreadColossus::k_supervisor_thread_id, false)
          .get());
}
