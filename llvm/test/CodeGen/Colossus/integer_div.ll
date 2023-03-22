; RUN: llc < %s -march=colossus -colossus-coissue=false -mattr=+ipu1 | FileCheck %s  --check-prefixes=CHECK,WORKER
; RUN: llc < %s -march=colossus -colossus-coissue=false -mattr=+ipu2 | FileCheck %s  --check-prefixes=CHECK,WORKER

; RUN: llc < %s -march=colossus -colossus-coissue=false -mattr=+supervisor,ipu1 | FileCheck %s --check-prefixes=CHECK,SUPERVISOR
; RUN: llc < %s -march=colossus -colossus-coissue=false -mattr=+supervisor,ipu2 | FileCheck %s --check-prefixes=CHECK,SUPERVISOR

; CHECK: perform_sdiv_u32:
; WORKER: call $m10, __divsi3
; SUPERVISOR: call $m10, __supervisor_divsi3
define i32 @perform_sdiv_u32(i32 %0, i32 %1) {
  %3 = sdiv i32 %0, %1
  ret i32 %3
}

; CHECK: perform_sdiv_u16:
; WORKER: call $m10, __divsi3
; SUPERVISOR: call $m10, __supervisor_divsi3
define zeroext i16 @perform_sdiv_u16(i16 zeroext %0, i16 zeroext %1) {
  %3 = sdiv i16 %0, %1
  ret i16 %3
}

; CHECK: perform_sdiv_u8:
; WORKER: call $m10, __divsi3
; SUPERVISOR: call $m10, __supervisor_divsi3
define zeroext i8 @perform_sdiv_u8(i8 zeroext %0, i8 zeroext %1) {
  %3 = sdiv i8 %0, %1
  ret i8 %3
}

; CHECK: perform_udiv_u32:
; WORKER: call $m10, __udivsi3
; SUPERVISOR: call $m10, __supervisor_udivsi3
define i32 @perform_udiv_u32(i32 %0, i32 %1) {
  %3 = udiv i32 %0, %1
  ret i32 %3
}

; CHECK: perform_udiv_u16:
; WORKER: call $m10, __udivsi3
; SUPERVISOR: call $m10, __supervisor_udivsi3
define zeroext i16 @perform_udiv_u16(i16 zeroext %0, i16 zeroext %1) {
  %3 = udiv i16 %0, %1
  ret i16 %3
}

; CHECK: perform_udiv_u8:
; WORKER: call $m10, __udivsi3
; SUPERVISOR: call $m10, __supervisor_udivsi3
define zeroext i8 @perform_udiv_u8(i8 zeroext %0, i8 zeroext %1) {
  %3 = udiv i8 %0, %1
  ret i8 %3
}
