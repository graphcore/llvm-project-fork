//===-- PlatformColossus.cpp ------------------------------------*- C++ -*-===//
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

#include "PlatformColossus.h"

#include "CommandObjectIPU.h"
#include "Plugins/Process/Colossus/ProcessColossus.h"
#include "Plugins/Process/Colossus/ProcessColossusLog.h"
#include "graphcore_binary/GraphcoreBinary.hpp"

#include "lldb/Core/Debugger.h"
#include "lldb/Core/Module.h"
#include "lldb/Core/ModuleList.h"
#include "lldb/Core/ModuleSpec.h"
#include "lldb/Core/PluginManager.h"
#include "lldb/Host/Config.h"
#include "lldb/Host/HostInfo.h"
#include "lldb/Host/OptionParser.h"
#include "lldb/Interpreter/CommandInterpreter.h"
#include "lldb/Interpreter/OptionArgParser.h"
#include "lldb/Target/Process.h"
#include "lldb/Target/Target.h"
#include "lldb/Utility/FileSpec.h"
#include "lldb/Utility/State.h"
#include "lldb/Utility/StreamString.h"

using namespace lldb;
using namespace lldb_private;

static uint32_t g_initialize_count = 0;
LLDB_PLUGIN_DEFINE(PlatformColossus)

#define MREG_NUM_FP 9
#define MREG_NUM_LR 10
#define MREG_NUM_SP 11

static RegisterSet MRRegSet = {
    "Memory Registers", "mr", 0, /* set at runtime to number of registers */
    nullptr /* set at runtime to array of absolute register indices */};
static RegisterSet ARRegSet = {"Arithmetic Registers", "ar", 0, nullptr};
static RegisterSet SCSRRegSet = {"Supervisor Control and Status Registers",
                                 "csr", 0, nullptr};
static RegisterSet WCSRRegSet = {"Worker Control and Status Registers", "csr",
                                 0, nullptr};
static RegisterSet TDIRegSet = {"Target Debug Interface Registers", "tdi", 0,
                                nullptr};

// TODO generate $m and $a register names in ipu_arch_info
static const char *mreg_names[] = {"m0",  "m1",  "m2",  "m3", "m4",  "m5",
                                   "m6",  "m7",  "m8",  "m9", "m10", "m11",
                                   "m12", "m13", "m14", "m15"};

static const char *areg_names[] = {"a0",  "a1",  "a2",  "a3", "a4",  "a5",
                                   "a6",  "a7",  "a8",  "a9", "a10", "a11",
                                   "a12", "a13", "a14", "a15"};

static const RegisterSet *SupervisorRegSets[] = {&MRRegSet, &SCSRRegSet,
                                                 &TDIRegSet};
static const RegisterSet *WorkerRegSets[] = {&MRRegSet, &ARRegSet, &WCSRRegSet,
                                             &TDIRegSet};

const size_t k_num_supervisor_regsets = llvm::array_lengthof(SupervisorRegSets);
const size_t k_num_worker_regsets = llvm::array_lengthof(WorkerRegSets);

static void SetDefaultRegisterInfo(
    RegisterInfo *reg_info, uint32_t *register_map,
    int i,             // slot in register_map
    int reg_num,       // identifier passed to GCDA to specify a register
    int abs_reg_index) // globally unique index of all registers
{
  reg_info->alt_name = nullptr;
  reg_info->byte_size = 4;
  reg_info->encoding = eEncodingUint;
  reg_info->format = eFormatHex;
  reg_info->kinds[lldb::eRegisterKindEHFrame] = i;
  reg_info->kinds[lldb::eRegisterKindDWARF] = abs_reg_index;
  reg_info->kinds[lldb::eRegisterKindGeneric] = LLDB_INVALID_REGNUM;
  reg_info->kinds[lldb::eRegisterKindProcessPlugin] = reg_num;
  reg_info->kinds[lldb::eRegisterKindLLDB] = abs_reg_index;
  register_map[i] = abs_reg_index;
}

void PlatformColossus::FreeRegisterInfos() {
  MRRegSet.num_registers = 0;
  delete[] MRRegSet.registers;
  MRRegSet.registers = nullptr;

  ARRegSet.num_registers = 0;
  delete[] ARRegSet.registers;
  ARRegSet.registers = nullptr;

  SCSRRegSet.num_registers = 0;
  delete[] SCSRRegSet.registers;
  SCSRRegSet.registers = nullptr;

  WCSRRegSet.num_registers = 0;
  delete[] WCSRRegSet.registers;
  WCSRRegSet.registers = nullptr;

  TDIRegSet.num_registers = 0;
  delete[] TDIRegSet.registers;
  TDIRegSet.registers = nullptr;

  delete[] m_register_infos;
  m_register_infos = nullptr;

  m_total_registers = 0;
}

void PlatformColossus::MakeRegisterInfos(const IPUArchInfo &iai) {

  if (m_register_infos) {
    // probably an error
    FreeRegisterInfos();
  }

  assert(iai.MRF_CAPACITY == llvm::array_lengthof(mreg_names));
  assert(iai.ARF_CAPACITY == llvm::array_lengthof(areg_names));

  m_total_registers = iai.MRF_CAPACITY + iai.ARF_CAPACITY +
                      iai.CSR_S.registers.registers.size() +
                      iai.CSR_W.registers.registers.size() +
                      iai.TDI.registers.registers.size();
  m_register_infos = new RegisterInfo[m_total_registers]();

  int abs_reg_index = 0;
  // for each group, allocate RegisterInfo with sensible values
  // store begin and end indices

  // $m registers
  {
    int num_registers = iai.MRF_CAPACITY;
    MRRegSet.num_registers = num_registers;
    uint32_t *registers = new uint32_t[num_registers];
    MRRegSet.registers = registers;
    for (int i = 0; i < num_registers; i++) {
      RegisterInfo *reg_info = &m_register_infos[abs_reg_index];
      SetDefaultRegisterInfo(reg_info, registers, i, i, abs_reg_index);
      reg_info->name = mreg_names[i];
      switch (i) {
      case MREG_NUM_FP:
        reg_info->alt_name = "fp";
        reg_info->kinds[lldb::eRegisterKindGeneric] = LLDB_REGNUM_GENERIC_FP;
        break;
      case MREG_NUM_LR:
        reg_info->alt_name = "lr";
        reg_info->kinds[lldb::eRegisterKindGeneric] = LLDB_REGNUM_GENERIC_RA;
        break;
      case MREG_NUM_SP:
        reg_info->alt_name = "sp";
        reg_info->kinds[lldb::eRegisterKindGeneric] = LLDB_REGNUM_GENERIC_SP;
        break;
      default:
        break;
      }
      reg_info->byte_offset =
          GraphcoreDeviceAccessTypes::Memory; // we overload byte_offset to mean
                                              // the register class
      abs_reg_index++;
    }
  }

  // $a registers
  {
    int num_registers = iai.ARF_CAPACITY;
    ARRegSet.num_registers = num_registers;
    uint32_t *register_map = new uint32_t[num_registers];
    ARRegSet.registers = register_map;
    for (int i = 0; i < num_registers; i++) {
      RegisterInfo *reg_info = &m_register_infos[abs_reg_index];
      SetDefaultRegisterInfo(reg_info, register_map, i, i, abs_reg_index);
      reg_info->name = areg_names[i];
      reg_info->byte_offset = GraphcoreDeviceAccessTypes::Arithmetic;
      abs_reg_index++;
    }
  }

  // Supervisor CSR registers
  {
    auto &iai_registers = iai.CSR_S.registers.registers;
    int num_registers = iai_registers.size();
    SCSRRegSet.num_registers = num_registers;
    uint32_t *register_map = new uint32_t[num_registers];
    SCSRRegSet.registers = register_map;
    for (int i = 0; i < num_registers; i++) {
      unsigned reg_num = iai_registers[i]->index;
      RegisterInfo *reg_info = &m_register_infos[abs_reg_index];
      SetDefaultRegisterInfo(reg_info, register_map, i, reg_num, abs_reg_index);
      reg_info->name = iai_registers[i]->name.c_str();
      reg_info->byte_offset = GraphcoreDeviceAccessTypes::ControlAndStatus;
      if (reg_num == iai.CSR_S.PC.index) {
        reg_info->kinds[lldb::eRegisterKindGeneric] = LLDB_REGNUM_GENERIC_PC;
      }
      abs_reg_index++;
    }
  }

  // Workers CSR registers
  {
    auto &iai_registers = iai.CSR_W.registers.registers;
    int num_registers = iai_registers.size();
    WCSRRegSet.num_registers = num_registers;
    uint32_t *register_map = new uint32_t[num_registers];
    WCSRRegSet.registers = register_map;
    for (int i = 0; i < num_registers; i++) {
      unsigned reg_num = iai_registers[i]->index;
      RegisterInfo *reg_info = &m_register_infos[abs_reg_index];
      SetDefaultRegisterInfo(reg_info, register_map, i, reg_num, abs_reg_index);
      reg_info->name = iai_registers[i]->name.c_str();
      reg_info->byte_offset = GraphcoreDeviceAccessTypes::ControlAndStatus;
      if (reg_num == iai.CSR_W.PC.index) {
        reg_info->kinds[lldb::eRegisterKindGeneric] = LLDB_REGNUM_GENERIC_PC;
      }
      abs_reg_index++;
    }
  }

  // TDI registers
  {
    auto &iai_registers = iai.TDI.registers.registers;
    int num_registers = iai_registers.size();
    TDIRegSet.num_registers = num_registers;
    uint32_t *register_map = new uint32_t[num_registers];
    TDIRegSet.registers = register_map;
    for (int i = 0; i < num_registers; i++) {
      unsigned reg_num = iai_registers[i]->index;
      RegisterInfo *reg_info = &m_register_infos[abs_reg_index];
      SetDefaultRegisterInfo(reg_info, register_map, i, reg_num, abs_reg_index);
      reg_info->name = iai_registers[i]->name.c_str();
      reg_info->byte_offset = GraphcoreDeviceAccessTypes::TargetDebugInterface;
      abs_reg_index++;
    }
  }
}

size_t PlatformColossus::GetRegisterCount() { return m_total_registers; }

const RegisterInfo *PlatformColossus::GetRegisterInfoAtIndex(size_t reg) {
  if (reg < m_total_registers)
    return &m_register_infos[reg];

  return NULL;
}

size_t PlatformColossus::GetRegisterSetCount(
    GraphcoreDeviceAccessTypes::TargetThread thread_id) {

  if (thread_id == GraphcoreDeviceAccessTypes::Supervisor) {
    return k_num_supervisor_regsets;
  } else {
    return k_num_worker_regsets;
  }
}

const RegisterSet *PlatformColossus::GetRegisterSet(
    GraphcoreDeviceAccessTypes::TargetThread thread_id, size_t reg_set) {

  if (reg_set < GetRegisterSetCount(thread_id)) {
    if (thread_id == GraphcoreDeviceAccessTypes::Supervisor) {
      return SupervisorRegSets[reg_set];
    } else {
      return WorkerRegSets[reg_set];
    }
  }
  return NULL;
}

uint32_t
PlatformColossus::ConvertRegisterKindToRegisterNumber(lldb::RegisterKind kind,
                                                      uint32_t reg) {

  if (kind == eRegisterKindGeneric) {
    switch (reg) {
    case LLDB_REGNUM_GENERIC_PC:
      return SCSRRegSet.registers[0]; // PC
    case LLDB_REGNUM_GENERIC_FP:
      return MRRegSet.registers[MREG_NUM_FP]; // $m9
    case LLDB_REGNUM_GENERIC_RA:
      return MRRegSet.registers[MREG_NUM_LR]; // $m10
    case LLDB_REGNUM_GENERIC_SP:
      return MRRegSet.registers[MREG_NUM_SP]; // $m11
    default:
      break;
    }
  } else if (kind == eRegisterKindDWARF) {
    // dwarf regs use absolute indexes in m_register_infos
    if (reg < m_total_registers) {
      return reg;
    }
  }
  return LLDB_INVALID_REGNUM;
}

PlatformSP PlatformColossus::CreateInstance(bool force, const ArchSpec *arch) {
  bool create = force;

  if (create == false && arch && arch->IsValid()) {
    const llvm::Triple &triple = arch->GetTriple();
    switch (triple.getArch()) {
    case llvm::Triple::colossus:
      create = true;
      break;
    default:
      break;
    }
  }

  if (create)
    return PlatformSP(new PlatformColossus(false));

  return PlatformSP();
}

void PlatformColossus::Initialize() {
  Platform::Initialize();

  if (g_initialize_count++ == 0) {
    PluginManager::RegisterPlugin(GetPluginNameStatic(),
                                  GetPluginDescriptionStatic(), CreateInstance);
  }
}

void PlatformColossus::Terminate() {
  if (g_initialize_count > 0) {
    if (--g_initialize_count == 0) {
      PluginManager::UnregisterPlugin(PlatformColossus::CreateInstance);
    }
  }

  Platform::Terminate();
}

bool PlatformColossus::IsConnected() const { return m_target_device_id > -1; }

const char *PlatformColossus::GetHostname() {
  return m_target_hostname.c_str();
}

std::string PlatformColossus::GetPlatformSpecificConnectionInformation() {
  return "\n  Device: " + std::to_string(m_target_device_id) + "\n" +
         "  IPU architecture: " + m_ipu_arch_name + "\n" +
         "  IPUs: " + std::to_string(m_num_ipus) + "\n" +
         "  Tiles per IPU: " + std::to_string(m_num_tiles_per_ipu) + "\n";
}

lldb_private::Status
PlatformColossus::GetFileWithUUID(const FileSpec & /*platform_file*/,
                                  const UUID * /*uuid_ptr*/,
                                  FileSpec & /*local_file*/) {
  Log *log = GetLog(ColossusLog::Error);
  if (log) {
    log->Printf("%s: ** ERROR **", __PRETTY_FUNCTION__);
  }
  return lldb_private::Status("unimplemented");
}

PlatformColossus::PlatformColossus(bool is_host)
    : Platform(is_host), m_target_hostname("localhost"), m_target_device_id(-1),
      m_debugger(nullptr), m_is_attaching_to_ipus(false),
      m_remote_platform_sp(), m_target_list(nullptr), m_register_infos(nullptr),
      m_total_registers(0) {}

PlatformColossus::~PlatformColossus() { FreeRegisterInfos(); }

bool PlatformColossus::GetProcessInfo(lldb::pid_t pid,
                                      ProcessInstanceInfo &process_info) {
  Log *log = GetLog(ColossusLog::Error);
  if (log) {
    log->Printf("%s: ** ERROR **", __PRETTY_FUNCTION__);
  }
  return false;
}

std::vector<ArchSpec>
PlatformColossus::GetSupportedArchitectures(const ArchSpec &process_host_arch) {
  std::vector<ArchSpec> result = {ArchSpec("colossus")};
  return result;
}

ArchSpec PlatformColossus::GetRemoteSystemArchitecture() {
  return ArchSpec("colossus");
}

void PlatformColossus::GetStatus(Stream &strm) { Platform::GetStatus(strm); }

size_t
PlatformColossus::GetSoftwareBreakpointTrapOpcode(Target &target,
                                                  BreakpointSite *bp_site) {
  // static const uint8_t g_trap_opcode[] = {0x0e, 0x90, 0x00, 0x41};
  if (bp_site->SetTrapOpcode((uint8_t *)&m_patch_bp, 4))
    return 4;

  return 0;
}

lldb_private::Status
PlatformColossus::LaunchProcess(ProcessLaunchInfo &launch_info) {
  lldb_private::Status error;
  error.SetErrorString("native execution is not possible");
  return error;
}

static void tileExceptedCallback(void *obj, std::vector<int> &excepted_tiles) {
  auto ipu_wrapper = (IPUWrapper *)obj;
  for (auto tile_id : excepted_tiles) {
    ipu_wrapper->platform->GotTileException(ipu_wrapper->ipu_index, tile_id);
  }
}

void PlatformColossus::GotTileException(int ipu_index, int tile_id) {
  const lldb::pid_t pid = GetPidForIPUIndexAndTileNum(ipu_index, tile_id);
  const unsigned index = pid - 1;

  auto *log = GetLog(ColossusLog::Process);
  LLDB_LOG(
      log,
      "PlatformColossus::{0}: got an exception in IPU {1}, tile {2} (pid {3})",
      __FUNCTION__, ipu_index, tile_id, pid);

  auto it = m_processes.find(index);
  if (it != m_processes.end())
    it->second->HandleInferiorException();
}

lldb_private::Status PlatformColossus::ConnectRemote(Args &args) {
  Status status;
  if (IsConnected()) {
    status.SetErrorStringWithFormat(
        "the platform is already connected to device %d on '%s', "
        "execute 'platform disconnect' to close the "
        "current connection",
        m_target_device_id, m_target_hostname.c_str());
  } else {
    llvm::StringRef device_id_string;
    const char *hostname = "localhost";
    if (args.GetArgumentCount() == 1) {
      // assume localhost and a device id
      device_id_string = args.GetArgumentAtIndex(0);
    } else if (args.GetArgumentCount() == 2) {
      // assume hostname deviceId
      hostname = args.GetArgumentAtIndex(0);
      device_id_string = args.GetArgumentAtIndex(1);
    } else {
      status.SetErrorStringWithFormat("requires hostname and IPU device id");
      return status;
    }

    unsigned device_id;
    if (device_id_string.getAsInteger(0, device_id)) {
      status.SetErrorStringWithFormat("expected integer device id, got %s",
                                      device_id_string.data());
      return status;
    }
    LockedGCDA lgcda = GetLockedGCDA();
    int remote_device_id;
    remote_device_id =
        lgcda->instance.registerRemoteDevice(hostname, device_id);
    if ((remote_device_id > -1) && lgcda->instance.attach(remote_device_id)) {
      m_target_device_id = device_id;
      m_target_hostname = hostname;
      auto device = lgcda->instance.getDevice();
      m_threads_per_tile = device->getIpuArchInfo().CTXT_TOTAL.value();
      m_ipu_arch_name = device->getIpuArchInfo().ipuArchName;
      MakeRegisterInfos(device->getIpuArchInfo());
      m_patch_bp = device->getIpuArchInfo().encode.trap_mmmn_zi(0);
      m_num_ipus = device->getNumIPUs();
      m_num_tiles_per_ipu = device->getIPU(0)->getNumTiles();
      m_ipus = new IPUWrapper[m_num_ipus];
      for (unsigned i = 0; i < m_num_ipus; i++) {
        m_ipus[i].platform = this;
        m_ipus[i].ipu_index = i;
        m_ipus[i].ipu =
            std::dynamic_pointer_cast<GraphcoreDeviceRemote>(device->getIPU(i));
        m_ipus[i].ipu->ipuEvents.registerTileExceptedCallback(
            &m_ipus[i], tileExceptedCallback);
      }

      auto &interpreter = lldb_private::Debugger::GetDebuggerAtIndex(0)
                              ->GetCommandInterpreter();
      interpreter.AddUserCommand(
          "ipu", CommandObjectSP(new CommandObjectIPU(interpreter, *this)),
          /*can_replace=*/true);
    } else {
      status.SetErrorStringWithFormat("failed to connect to device %d on %s",
                                      device_id, hostname);
    }
  }
  return status;
}

lldb_private::Status PlatformColossus::DisconnectRemote() {
  auto &interpreter =
      lldb_private::Debugger::GetDebuggerAtIndex(0)->GetCommandInterpreter();
  interpreter.RemoveUser("ipu");

  Status status;
  if (IsConnected()) {
    LockedGCDA lgcda = GetLockedGCDA();
    lgcda->instance.detach();
    m_target_device_id = -1;
  }

  // m_target_list is only set on attach, so it may be null here
  if (m_target_list) {
    std::vector<TargetSP> delete_target_list;
    for (int i = 0; i < m_target_list->GetNumTargets(); ++i)
      delete_target_list.push_back(m_target_list->GetTargetAtIndex(i));

    const size_t num_targets_to_delete = delete_target_list.size();
    for (size_t idx = 0; idx < num_targets_to_delete; ++idx) {
      TargetSP target_sp = delete_target_list[idx];
      ProcessSP process_sp(target_sp->GetProcessSP());
      if (process_sp)
        process_sp->Finalize();
      m_target_list->DeleteTarget(target_sp);
      target_sp->Destroy();
    }
  }

  delete[] m_ipus;
  m_processes.clear();
  m_targets.clear();
  m_debugger = nullptr;
  m_target_list = nullptr;

  FreeRegisterInfos();

  return status;
}

lldb::ProcessSP PlatformColossus::DebugProcess(ProcessLaunchInfo &launch_info,
                                               Debugger &debugger,
                                               Target &target,
                                               lldb_private::Status &error) {

  lldb::ProcessSP process_sp;
  error.SetErrorString("no, use attach");
  return process_sp;
}

lldb_private::Status PlatformColossus::Install(const FileSpec &src,
                                               const FileSpec &dst) {

  return {};
}

lldb::ProcessSP
PlatformColossus::AttachSingleTile(Debugger &debugger, unsigned tile_idx,
                                   lldb_private::Status &error) {
  if (!IsConnected()) {
    error.SetErrorString(
        "not connected to remote IPU device (use 'platform connect <ipu-id>')");
    return nullptr;
  } else if (m_targets.find(tile_idx) != m_targets.end()) {
    error.SetErrorStringWithFormatv("already attached to tile {0}", tile_idx);
    return nullptr;
  }

  m_is_attaching_to_ipus = true;
  m_debugger = &debugger;
  m_target_list = &debugger.GetTargetList();

  auto target = debugger.GetSelectedTarget();
  auto default_exe_module = target->GetExecutableModule();

  auto launch_info = ProcessLaunchInfo();
  launch_info.Clear();
  launch_info.SetHijackListener(Listener::MakeListener("colossus hijacker"));
  auto attach_info = ProcessAttachInfo(launch_info);

  ListenerSP listener_sp(Listener::MakeListener("colossus process creation"));

  TargetSP target_sp(target->shared_from_this());
  m_targets.insert({tile_idx, target_sp});
  if (m_targets.size() > 1) {
    m_target_list->CreateTarget(debugger, "", "colossus", eLoadDependentsNo,
                                NULL, m_targets.at(tile_idx));
    target_sp = m_targets.at(tile_idx);
  }

  auto process_sp =
      CreateTileProcess(debugger, tile_idx + 1, target_sp, attach_info,
                        listener_sp, default_exe_module, error);
  if (error.Fail()) {
    m_is_attaching_to_ipus = false;
    return nullptr;
  }
  process_sp->WaitForProcessToStop(llvm::None, nullptr, true, listener_sp);
  process_sp->RestoreProcessEvents();

  m_target_list->SetSelectedTarget(target_sp);
  m_is_attaching_to_ipus = false;

  return process_sp;
}

lldb::ProcessSP PlatformColossus::AttachAllTiles(Debugger &debugger,
                                                 lldb_private::Status &error) {
  if (!IsConnected()) {
    error.SetErrorString("not connected to remote IPU device");
    return nullptr;
  } else if (m_targets.size() != 0) {
    error.SetErrorString("already attached to a tile");
    return nullptr;
  }

  m_debugger = &debugger;
  m_target_list = &debugger.GetTargetList();

  auto target = debugger.GetSelectedTarget();
  auto default_exe_module = target->GetExecutableModule();

  auto launch_info = ProcessLaunchInfo();
  launch_info.Clear();
  launch_info.SetHijackListener(Listener::MakeListener("colossus hijacker"));
  auto attach_info = ProcessAttachInfo(launch_info);

  // single ELFs will not have an object name, only members of a container
  bool is_multi_elf = default_exe_module->GetObjectName() != nullptr;

  // if we have a GraphcoreBinary container we should not
  // attach to more than the number of tile programs in the container
  unsigned total_tiles = m_num_ipus * m_num_tiles_per_ipu;
  if (is_multi_elf) {
    GraphcoreBinary gc_bin;
    gc_bin.load(default_exe_module->GetFileSpec().GetPath());
    unsigned obj_count = gc_bin.getNumTiles();
    total_tiles = std::min(obj_count, total_tiles);
  }

  TargetSP target_sp(target->shared_from_this());
  m_targets.insert({0, target_sp}); // add the current target

  // Create a target per tile.
  for (unsigned i = 1; i < total_tiles; i++) {
    m_targets.insert({i, nullptr});
    error = m_target_list->CreateTarget(
        debugger, "", "colossus", eLoadDependentsNo, NULL, m_targets.at(i));
    if (error.Fail()) {
      return nullptr;
    }
  }

  ProcessSP process_sp;
  ListenerSP listener_sp(Listener::MakeListener("colossus process creation"));

  m_is_attaching_to_ipus = true;
  for (auto target_index = 0; target_index < m_target_list->GetNumTargets();
       target_index++) {
    auto target_sp = m_target_list->GetTargetAtIndex(target_index);
    process_sp =
        CreateTileProcess(debugger, target_index + 1, target_sp, attach_info,
                          listener_sp, default_exe_module, error);
    if (error.Fail()) {
      m_is_attaching_to_ipus = false;
      return nullptr;
    }
  }
  for (auto &proc : m_processes) {
    proc.second->WaitForProcessToStop(llvm::None, nullptr, true, listener_sp);
    proc.second->RestoreProcessEvents();
  }

  // Leave the user with the first target tile selected.
  m_target_list->SetSelectedTarget(m_target_list->GetTargetAtIndex(0));
  m_is_attaching_to_ipus = false;
  return process_sp;
}

lldb::ProcessSP PlatformColossus::CreateTileProcess(
    Debugger &debugger, unsigned int pid, TargetSP current_target,
    ProcessAttachInfo &attach_info, ListenerSP listener_sp,
    ModuleSP default_exe_module, lldb_private::Status &error) {
  // single ELFs will not have an object name, only members of a container
  bool is_multi_elf = default_exe_module->GetObjectName() != nullptr;

  FileSpec file_spec = default_exe_module->GetFileSpec();
  ModuleSpec module_spec(file_spec);
  module_spec.GetArchitecture().SetArchitecture(
      eArchTypeELF, llvm::ELF::EM_GRAPHCORE_IPU, LLDB_INVALID_CPUTYPE, 0);

  // if we are using a GraphcoreBinary container we
  // extract the object for the current tile by configuring
  // a ModuleSpec named with the tile number and passing that
  // to ResolveExecutable
  if (is_multi_elf) {
    std::string tile_name = std::to_string(pid - 1);
    module_spec.GetObjectName().SetCString(tile_name.c_str());

    FileSpecList executable_search_paths(
        Target::GetDefaultExecutableSearchPaths());
    const auto file_specs =
        executable_search_paths.GetSize() ? &executable_search_paths : nullptr;

    lldb::ModuleSP exe_module_sp;
    error = ResolveExecutable(module_spec, exe_module_sp, file_specs);
    if (error.Fail()) {
      return nullptr;
    }

    current_target->SetExecutableModule(exe_module_sp, eLoadDependentsNo);
  } else {
    // We have a single ELF, use that for all tiles
    current_target->SetExecutableModule(default_exe_module, eLoadDependentsNo);
  }

  current_target->GetExecutableModule()->GetObjectFile()->SetLoadAddress(
      *current_target, 0, true);

  auto process_sp = current_target->CreateProcess(
      attach_info.GetListener(), "colossus", nullptr, /*can_connect=*/true);

  attach_info.SetProcessID(pid);
  debugger.GetOutputStream().Printf("Creating process %d for IPU %d, tile %d\n",
                                    pid, GetIPUIndexFromPid(pid),
                                    GetTileNumFromPid(pid));
  process_sp->HijackProcessEvents(listener_sp);
  m_processes.insert(
      {pid - 1, reinterpret_cast<ProcessColossus *>(process_sp.get())});
  process_sp->Attach(attach_info);

  return process_sp;
}

lldb::ProcessSP PlatformColossus::Attach(ProcessAttachInfo &attach_info,
                                         Debugger &debugger, Target *target,
                                         lldb_private::Status &error) {
  if (attach_info.GetProcessID() == LLDB_INVALID_PROCESS_ID) {
    return AttachAllTiles(debugger, error);
  } else {
    return AttachSingleTile(debugger, attach_info.GetProcessID() - 1, error);
  }
}

void PlatformColossus::CalculateTrapHandlerSymbolNames() {
  Log *log = GetLog(ColossusLog::Error);
  if (log) {
    log->Printf("%s: ** ERROR **", __PRETTY_FUNCTION__);
  }
}

// Not sure if this is useful, for now just use dummy
// borrowed from the Windows implementation
class ColossusUserIDResolver : public UserIDResolver {
protected:
  llvm::Optional<std::string> DoGetUserName(id_t uid) override {
    return llvm::None;
  }
  llvm::Optional<std::string> DoGetGroupName(id_t gid) override {
    return llvm::None;
  }
};

static ColossusUserIDResolver g_user_id_resolver;

UserIDResolver &PlatformColossus::GetUserIDResolver() {
  return g_user_id_resolver;
}

unsigned PlatformColossus::GetIPUIndexFromPid(lldb::pid_t pid) const {
  return (pid - 1) / m_num_tiles_per_ipu;
}

GraphcoreDeviceAccessTypes::TileNumber
PlatformColossus::GetTileNumFromPid(lldb::pid_t pid) const {
  return static_cast<GraphcoreDeviceAccessTypes::TileNumber>(
      (pid - 1) % m_num_tiles_per_ipu);
}

LockedGCDA PlatformColossus::GetLockedGCDA() {
  return LockedGCDA(m_gcda, m_gcda_mutex);
}

LockedIPU PlatformColossus::GetLockedIPU(lldb::pid_t pid) {
  const unsigned ipu_index = GetIPUIndexFromPid(pid);
  return LockedIPU(m_ipus[ipu_index].ipu, m_ipus[ipu_index].mutex);
}

const IPUArchInfo &PlatformColossus::GetIPUArchInfo(lldb::pid_t pid) const {
  const unsigned ipu_index = GetIPUIndexFromPid(pid);
  // NOTE: No need to lock the IPU to access arch info since it's immutable.
  return m_ipus[ipu_index].ipu->getIpuArchInfo();
}

lldb::pid_t
PlatformColossus::GetPidForIPUIndexAndTileNum(unsigned ipu_index,
                                              unsigned tile_num) const {
  return (m_num_tiles_per_ipu * ipu_index) + tile_num + 1;
}
