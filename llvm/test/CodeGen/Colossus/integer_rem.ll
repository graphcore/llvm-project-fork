; RUN: llc < %s -march=colossus -colossus-coissue=false -mattr=+ipu1 | FileCheck %s --check-prefixes=CHECK,WORKER
; RUN: llc < %s -march=colossus -colossus-coissue=false -mattr=+ipu2 | FileCheck %s --check-prefixes=CHECK,WORKER

; RUN: llc < %s -march=colossus -colossus-coissue=false -mattr=+supervisor,ipu1 | FileCheck %s --check-prefixes=CHECK,SUPERVISOR
; RUN: llc < %s -march=colossus -colossus-coissue=false -mattr=+supervisor,ipu2 | FileCheck %s --check-prefixes=CHECK,SUPERVISOR

; CHECK: perform_smod_u32:
; WORKER: call $m10, __modsi3
; SUPERVISOR: call $m10, __supervisor_modsi3
define i32 @perform_smod_u32(i32 %0, i32 %1) {
  %3 = srem i32 %0, %1
  ret i32 %3
}

; CHECK: perform_smod_u16:
; WORKER: call $m10, __modsi3
; SUPERVISOR: call $m10, __supervisor_modsi3
define zeroext i16 @perform_smod_u16(i16 zeroext %0, i16 zeroext %1) {
  %3 = srem i16 %0, %1
  ret i16 %3
}

; CHECK: perform_smod_u8:
; WORKER: call $m10, __modsi3
; SUPERVISOR: call $m10, __supervisor_modsi3
define zeroext i8 @perform_smod_u8(i8 zeroext %0, i8 zeroext %1) {
  %3 = srem i8 %0, %1
  ret i8 %3
}

; CHECK: perform_umod_u32:
; WORKER: call $m10, __umodsi3
; SUPERVISOR: call $m10, __supervisor_umodsi3
define i32 @perform_umod_u32(i32 %0, i32 %1) {
  %3 = urem i32 %0, %1
  ret i32 %3
}

; CHECK: perform_umod_u16:
; WORKER: call $m10, __umodsi3
; SUPERVISOR: call $m10, __supervisor_umodsi3
define zeroext i16 @perform_umod_u16(i16 zeroext %0, i16 zeroext %1) {
  %3 = urem i16 %0, %1
  ret i16 %3
}

; CHECK: perform_umod_u8:
; WORKER: call $m10, __umodsi3
; SUPERVISOR: call $m10, __supervisor_umodsi3
define zeroext i8 @perform_umod_u8(i8 zeroext %0, i8 zeroext %1) {
  %3 = urem i8 %0, %1
  ret i8 %3
}
