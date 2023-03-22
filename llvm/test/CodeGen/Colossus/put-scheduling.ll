; REQUIRES: asserts
; RUN: llc < %s -march=colossus -enable-misched -print-before=machine-scheduler -misched-print-dags -print-after=machine-scheduler -o /dev/null 2>&1 > /dev/null | FileCheck --enable-var-scope %s

; Example of scheduler DAG dump taken some time ago from uput_uput_ordering
; before the use of isSchedulingBoundary for put/uput:

; SU(0):   %1:ar = COPY $mzero
;   # preds left       : 0
;   # succs left       : 1
;   # rdefs left       : 0
;   Latency            : 0
;   Depth              : 0
;   Height             : 0
;   Successors:
;     SU(1): Data Latency=0 Reg=%1
;   Single Issue       : false;
; SU(1):   UPUT %1:ar, 2, 0
;   # preds left       : 1
;   # succs left       : 1
;   # rdefs left       : 0
;   Latency            : 1
;   Depth              : 0
;   Height             : 0
;   Predecessors:
;     SU(0): Data Latency=0 Reg=%1
;   Successors:
;     SU(4): Ord  Latency=0 Barrier
;   Single Issue       : false;
; SU(2):   %2:mr = SETZI 1, 0
;   # preds left       : 0
;   # succs left       : 1
;   # rdefs left       : 0
;   Latency            : 1
;   Depth              : 0
;   Height             : 1
;   Successors:
;     SU(3): Data Latency=1 Reg=%2
;   Single Issue       : false;
; SU(3):   %3:ar = COPY %2:mr
;   # preds left       : 1
;   # succs left       : 1
;   # rdefs left       : 0
;   Latency            : 0
;   Depth              : 1
;   Height             : 0
;   Predecessors:
;     SU(2): Data Latency=1 Reg=%2
;   Successors:
;     SU(4): Data Latency=0 Reg=%3
;   Single Issue       : false;
; SU(4):   UPUT %3:ar, 3, 0
;   # preds left       : 2
;   # succs left       : 0
;   # rdefs left       : 0
;   Latency            : 1
;   Depth              : 1
;   Height             : 0
;   Predecessors:
;     SU(3): Data Latency=0 Reg=%3
;     SU(1): Ord  Latency=0 Barrier
;   Single Issue       : false;
; ExitSU:   RTN_PSEUDO
;   # preds left       : 0
;   # succs left       : 0
;   # rdefs left       : 0
;   Latency            : 0
;   Depth              : 0
;   Height             : 0

declare void @llvm.colossus.uput(i32, i32)

; CHECK-LABEL: Before Machine Instruction Scheduler{{.*[[:space:]].*}}Machine code for function uput_uput_ordering:

; Check the two uput are in the same order as in IR before MI scheduling.
; CHECK: UPUT %[[#]]:ar, 2, 0
; CHECK: UPUT %[[#]]:ar, 3, 0
; CHECK: End machine code for function uput_uput_ordering.

; Check the two uput are either ExitSU or not part of a scheduling zone.
; CHECK-NOT: {{^(Exit)?}}SU  UPUT %[[#]]:ar, 2, 0
; CHECK:     ExitSU:         UPUT %[[#]]:ar, 3, 0
; CHECK-NOT: {{^(Exit)?}}SU  UPUT %[[#]]:ar, 2, 0

; Check the two uput are in the same order as in IR after MI scheduling.
; CHECK: IR Dump After Machine Instruction Scheduler
; CHECK-NEXT: Machine code for function uput_uput_ordering:
; CHECK: UPUT %[[#]]:ar, 2, 0
; CHECK: UPUT %[[#]]:ar, 3, 0
define dso_local void @uput_uput_ordering() local_unnamed_addr {
  tail call void @llvm.colossus.uput(i32 0, i32 2)
  tail call void @llvm.colossus.uput(i32 1, i32 3)
  ret void
}

declare void @llvm.colossus.put(i32, i32)

; CHECK-LABEL: Before Machine Instruction Scheduler{{.*[[:space:]].*}}Machine code for function put_put_ordering:

; Check the two put are in the same order as in IR before MI scheduling.
; CHECK:     PUT $mzero, 2, 0
; CHECK:     PUT $mzero, 3, 0
; CHECK: End machine code for function put_put_ordering.

; Check no scheduling zone and thus no scheduling unit exist.
; CHECK-NOT: {{^(Exit)?}}SU

; Check the two put are in the same order as in IR after MI scheduling.
; CHECK: IR Dump After Machine Instruction Scheduler
; CHECK-NEXT: Machine code for function put_put_ordering:
; CHECK:     PUT $mzero, 2, 0
; CHECK:     PUT $mzero, 3, 0
define dso_local void @put_put_ordering() local_unnamed_addr {
  tail call void @llvm.colossus.put(i32 0, i32 2)
  tail call void @llvm.colossus.put(i32 0, i32 3)
  ret void
}

declare i32 @llvm.colossus.uget(i32)

; CHECK-LABEL: Before Machine Instruction Scheduler{{.*[[:space:]].*}}Machine code for function uput_uget_ordering:

; Check the two uput and two uget are in the same order as in IR before MI
; scheduling.
; CHECK:     %[[#VAL:]]:ar = UGET 2, 0
; CHECK:     UPUT %[[#]]:ar, 2, 0
; CHECK:     %[[#]]:ar = UGET 2, 0
; CHECK:     UPUT %[[#VAL]]:ar, 2, 0
; CHECK: End machine code for function uput_uget_ordering.

; Check the two uput are both ExitSU and the two uget are before the same uput
; as in IR.
; CHECK:     SU([[#]]): %[[#]]:ar = UGET 2, 0
; CHECK-NOT: {{^}}ExitSU:
; CHECK:     ExitSU:    UPUT %[[#VAL]]:ar, 2, 0
; CHECK:     SU([[#]]): %[[#VAL]]:ar = UGET 2, 0
; CHECK-NOT: {{^}}ExitSU:
; CHECK:     ExitSU:    UPUT %[[#]]:ar, 2, 0

; Check the two uput and two uget are in the same order as in IR before MI
; scheduling.
; CHECK: IR Dump After Machine Instruction Scheduler
; CHECK-NEXT: Machine code for function uput_uget_ordering:
; CHECK:     %[[#VAL]]:ar = UGET 2, 0
; CHECK:     UPUT %[[#]]:ar, 2, 0
; CHECK:     %[[#]]:ar = UGET 2, 0
; CHECK:     UPUT %[[#VAL]]:ar, 2, 0
define dso_local i32 @uput_uget_ordering() local_unnamed_addr {
  %1 = tail call i32 @llvm.colossus.uget(i32 2)
  tail call void @llvm.colossus.uput(i32 0, i32 2)
  %2 = tail call i32 @llvm.colossus.uget(i32 2)
  tail call void @llvm.colossus.uput(i32 %1, i32 2)
  ret i32 %2
}

declare i32 @llvm.colossus.get(i32)

; CHECK-LABEL: Before Machine Instruction Scheduler{{.*[[:space:]].*}}Machine code for function put_get_ordering:

; Check the two put and two get are in the same order as in IR before MI
; scheduling.
; CHECK:     %[[#VAL:]]:mr = GET 2, 0
; CHECK:     PUT $mzero, 2, 0
; CHECK:     %[[#]]:mr = GET 2, 0
; CHECK:     PUT %[[#VAL]]:mr, 2, 0
; CHECK: End machine code for function put_get_ordering.

; Check no scheduling zone and thus no scheduling unit exist.
; CHECK-NOT: {{^(Exit)?}}SU

; Check the two put and two get are in the same order as in IR after MI
; scheduling.
; CHECK: IR Dump After Machine Instruction Scheduler
; CHECK-NEXT: Machine code for function put_get_ordering:
; CHECK:     %[[#VAL]]:mr = GET 2, 0
; CHECK:     PUT $mzero, 2, 0
; CHECK:     %[[#]]:mr = GET 2, 0
; CHECK:     PUT %[[#VAL]]:mr, 2, 0
define dso_local i32 @put_get_ordering() local_unnamed_addr {
  %1 = tail call i32 @llvm.colossus.get(i32 2)
  tail call void @llvm.colossus.put(i32 0, i32 2)
  %2 = tail call i32 @llvm.colossus.get(i32 2)
  tail call void @llvm.colossus.put(i32 %1, i32 2)
  ret i32 %2
}

; CHECK-LABEL: Before Machine Instruction Scheduler{{.*[[:space:]].*}}Machine code for function uput_f32tof16_ordering:

; Check the uput and f32tof16 are in the same order as in IR before MI
; scheduling.
; CHECK: UPUT %[[#]]:ar, 2, 0
; CHECK: %[[#]]:ar = F32TOF16 %0:ar, 0
; CHECK: End machine code for function uput_f32tof16_ordering.

; Check the uput is an ExitSU and the f32tof16 is after the uput, as in IR.
; CHECK: SU([[#]]): %[[#]]:ar = F32TOF16 %0:ar, 0
; CHECK-NOT: {{^}}ExitSU:
; CHECK: ExitSU:    RTN_PSEUDO
; CHECK-NOT: {{^}}ExitSU:
; CHECK: ExitSU:    UPUT %[[#]]:ar, 2, 0

; Check the uput and f32tof16 are in the same order as in IR after MI
; scheduling.
; CHECK: IR Dump After Machine Instruction Scheduler
; CHECK-NEXT: Machine code for function uput_f32tof16_ordering:
; CHECK: UPUT %[[#]]:ar, 2, 0
; CHECK: %[[#]]:ar = F32TOF16 %0:ar, 0
define dso_local half @uput_f32tof16_ordering(float %0) local_unnamed_addr {
  tail call void @llvm.colossus.uput(i32 0, i32 2)
  %2 = fptrunc float %0 to half
  ret half %2
}

; CHECK-LABEL: Before Machine Instruction Scheduler{{.*[[:space:]].*}}Machine code for function put_f32tof16_ordering:

; Check the put and f32tof16 are in the same order as in IR before MI
; scheduling.
; CHECK: PUT $mzero, 2, 0
; CHECK: %[[#]]:ar = F32TOF16 %0:ar, 0
; CHECK: End machine code for function put_f32tof16_ordering.

; Check the put and f32tof16 are in different scheduling zone.
; CHECK: SU([[#]]): %[[#]]:ar = F32TOF16 %0:ar, 0
; CHECK-NOT: {{^}}ExitSU:
; CHECK-NOT: SU([[#]]): PUT $mzero, 2, 0
; CHECK: ExitSU:    RTN_PSEUDO
; CHECK-NOT: {{^(Exit)?SU.*}}: PUT $mzero, 2, 0

; Check the put and f32tof16 are in the same order as in IR after MI
; scheduling.
; CHECK: IR Dump After Machine Instruction Scheduler
; CHECK-NEXT: Machine code for function put_f32tof16_ordering:
; CHECK: PUT $mzero, 2, 0
; CHECK: %[[#]]:ar = F32TOF16 %0:ar, 0
define dso_local half @put_f32tof16_ordering(float %0) local_unnamed_addr {
  tail call void @llvm.colossus.put(i32 0, i32 2)
  %2 = fptrunc float %0 to half
  ret half %2
}

; CHECK-LABEL: Before Machine Instruction Scheduler{{.*[[:space:]].*}}Machine code for function uget_uput_f32tof16_ordering:

; Check the two uput and f32tof16 are in the same order as in IR before MI
; scheduling.
; CHECK: %[[#VAL:]]:ar = UGET 2, 0
; CHECK: UPUT %[[#ZEROVAL:]]:ar, 2, 0
; CHECK: %[[#]]:ar = F32TOF16 %0:ar, 0
; CHECK: UPUT %[[#VAL]]:ar, 2, 0
; CHECK: End machine code for function uget_uput_f32tof16_ordering.

; Check the f32tof16 and second uput are not part of a scheduling zone.
; CHECK-NOT: {{^(Exit)?SU.*}}: UPUT [[#VAL]]:ar, 2, 0
; CHECK-NOT: {{^(Exit)?SU.*}}: [[#]]:ar = F32TOF16 %0:ar, 0
; CHECK: SU([[#]]): %[[#VAL]]:ar = UGET 2, 0
; CHECK-NOT: {{^}}ExitSU:
; CHECK: ExitSU: UPUT %[[#ZEROVAL]]:ar, 2, 0
; CHECK-NOT: {{^(Exit)?SU.*}}: UPUT [[#VAL]]:ar, 2, 0
; CHECK-NOT: {{^(Exit)?SU.*}}: [[#]]:ar = F32TOF16 %0:ar, 0

; Check the f32tof16 is in the same order with regards to the two uput after MI
; scheduling.
; CHECK: IR Dump After Machine Instruction Scheduler
; CHECK-NEXT: Machine code for function uget_uput_f32tof16_ordering:
; CHECK: %[[#VAL]]:ar = UGET 2, 0
; CHECK: UPUT %[[#]]:ar, 2, 0
; CHECK: %[[#]]:ar = F32TOF16 %0:ar, 0
; CHECK: UPUT %[[#VAL]]:ar, 2, 0
define dso_local half @uget_uput_f32tof16_ordering(float %0) local_unnamed_addr {
  %2 = tail call i32 @llvm.colossus.uget(i32 2)
  tail call void @llvm.colossus.uput(i32 0, i32 2)
  %3 = fptrunc float %0 to half
  tail call void @llvm.colossus.uput(i32 %2, i32 2)
  ret half %3
}

; CHECK-LABEL: Before Machine Instruction Scheduler{{.*[[:space:]].*}}Machine code for function get_put_f32tof16_ordering:

; Check the two put and f32tof16 are in the same order as in IR before MI
; scheduling.
; CHECK: %[[#VAL:]]:mr = GET 2, 0
; CHECK: PUT $mzero, 2, 0
; CHECK: %[[#]]:ar = F32TOF16 %0:ar, 0
; CHECK: PUT %[[#VAL]]:mr, 2, 0
; CHECK: End machine code for function get_put_f32tof16_ordering.

; Check the f32tof16 and second put are not part of a scheduling zone.
; CHECK-NOT: {{^(Exit)?SU.*}}: PUT [[#VAL]]:mr, 2, 0
; CHECK-NOT: {{^(Exit)?SU.*}}: [[#]]:ar = F32TOF16 %0:ar, 0
; CHECK: SU([[#]]): %[[#VAL]]:mr = GET 2, 0
; CHECK-NOT: {{^}}ExitSU:
; CHECK: ExitSU: PUT $mzero, 2, 0
; CHECK-NOT: {{^(Exit)?SU.*}}: PUT [[#VAL]]:mr, 2, 0
; CHECK-NOT: {{^(Exit)?SU.*}}: [[#]]:ar = F32TOF16 %0:ar, 0

; Check the f32tof16 is in the same order with regards to the two uput after MI
; scheduling.
; CHECK: IR Dump After Machine Instruction Scheduler
; CHECK-NEXT: Machine code for function get_put_f32tof16_ordering:
; CHECK: %[[#VAL]]:mr = GET 2, 0
; CHECK: PUT $mzero, 2, 0
; CHECK: %[[#]]:ar = F32TOF16 %0:ar, 0
; CHECK: PUT %[[#VAL]]:mr, 2, 0
define dso_local half @get_put_f32tof16_ordering(float %0) local_unnamed_addr {
  %2 = tail call i32 @llvm.colossus.get(i32 2)
  tail call void @llvm.colossus.put(i32 0, i32 2)
  %3 = fptrunc float %0 to half
  tail call void @llvm.colossus.put(i32 %2, i32 2)
  ret half %3
}
