; REQUIRES: asserts

; RUN: llc < %s -march=colossus -enable-misched -misched-postra=false -debug-only=post-RA-sched -o /dev/null 2>&1 > /dev/null | FileCheck %s --allow-empty --check-prefix=NO-POST-RA-SCHED-LIST
; RUN: llc < %s -march=colossus -enable-misched=false -misched-postra=false -debug-only=post-RA-sched -o /dev/null 2>&1 > /dev/null | FileCheck %s --allow-empty --check-prefix=NO-POST-RA-SCHED-LIST
; RUN: llc < %s -march=colossus -enable-misched -misched-postra=true -debug-only=machine-scheduler -o /dev/null 2>&1 > /dev/null | FileCheck %s --allow-empty --check-prefix=NO-POST-RA-MISCHED

; Both post register allocator scheduler are disabled.

; NO-POST-RA-MISCHED-NOT: Before post-MI-sched:
; NO-POST-RA-SCHED-LIST-NOT: PostRAScheduler

; RUN: llc < %s -march=colossus -enable-misched -verify-misched -debug-only=machine-scheduler -o - 2>&1 > /dev/null | FileCheck %s --check-prefixes=CHECK,COISSUE
; Force top-down and run the same checks, showing we default to top-down
; scheduling.
; RUN: llc < %s -march=colossus -enable-misched -verify-misched -misched-topdown -debug-only=machine-scheduler -o - 2>&1 > /dev/null | FileCheck %s --check-prefixes=CHECK,COISSUE
; RUN: llc < %s -march=colossus -enable-misched -verify-misched -colossus-coissue=false -debug-only=machine-scheduler -o - 2>&1 > /dev/null | FileCheck %s --check-prefixes=CHECK,SINGLE-ISSUE

; Check that the latency for load instructions is 1, same as arithmetic
; instructions but that COPY pseudo instructions have a latency of 0.
;
; CHECK-LABEL:  ********** MI Scheduling **********{{[[:space:]]}}one_cycle_load:%bb.0 entry
; CHECK:       SU({{.*}}COPY
; CHECK-NOT:   SU(
; CHECK:       Latency    : 0
; CHECK:       SU({{.*}}LD32_ZI
; CHECK-NOT:   SU(
; CHECK:       Latency    : 1
; CHECK:       SU({{.*}}SUB
; CHECK-NOT:   SU(
; CHECK:       Latency    : 1
; CHECK:       SU({{.*}}XOR
; CHECK-NOT:   SU(
; CHECK:       Latency    : 1
; CHECK:       SU({{.*}}MUL
; CHECK-NOT:   SU(
; CHECK:       Latency    : 1
; CHECK:       SU({{.*}}ADD
; CHECK-NOT:   SU(
; CHECK:       Latency    : 1
; CHECK:       SU({{.*}}OR
; CHECK-NOT:   SU(
; CHECK:       Latency    : 1

; CHECK:              ** Final schedule for %bb.0 ***
; CHECK-NEXT:         COPY
; CHECK-NEXT:         COPY
; CHECK-NEXT:         COPY
; CHECK-NEXT:         COPY
; COISSUE:            XOR
; COISSUE-NEXT:       LD32_ZI
; COISSUE-NEXT:       MUL
; COISSUE-NEXT:       SUB
; SINGLE-ISSUE:       LD32_ZI
; SINGLE-ISSUE-NEXT:  SUB
; SINGLE-ISSUE-NEXT:  XOR
; SINGLE-ISSUE-NEXT:  MUL
; CHECK-NEXT:         ADD
; CHECK-NEXT:         OR
; CHECK:        ********** INTERVALS **********

define i32 @one_cycle_load(i32* %a, i32 %b, i32 %c, i32 %d) {
entry:
  %load = load i32, i32* %a, align 4
  %sub = sub i32 %load, %b
  %xor = xor i32 %b, %c
  %mul = mul nsw i32 %xor, %d
  %add = add nsw i32 %mul, %b
  %or = or i32 %add, %sub
  ret i32 %or
}

; Check that the scheduler interleaves instructions for main and aux pipelines
; unless coissue is disabled. Variant #1: a block of "main instructions"
; followed by a single "aux instruction".

; CHECK-LABEL:        Before MISched:{{[[:space:]]}}# Machine code for function coissue1:
; CHECK:              liveins:
; CHECK-NEXT:         %3:ar = COPY $a0
; CHECK-NEXT:         %2:mr = COPY $m2
; CHECK-NEXT:         %1:mr = COPY $m1
; CHECK-NEXT:         %0:mr = COPY $m0
; CHECK-NEXT:         %4:mr = XOR %0:mr, %1:mr, 0
; CHECK-NEXT:         %5:mr = XOR %4:mr, %2:mr, 0
; CHECK-NEXT:         %7:ar = F32SUB $azero, %3:ar, 0
; CHECK-NEXT:         %8:ar = F32INT %7:ar, 3, 0
; CHECK-NEXT:         %9:ar = F32TOUI32 %8:ar, 0
; CHECK-NEXT:        %10:mr = COPY %9:ar
; CHECK-NEXT:        %11:mr = AND %5:mr, %10:mr, 0
; CHECK-NEXT:          $m0  = COPY %11:mr
; CHECK-NEXT:         RTN_PSEUDO

; CHECK:              ** Final schedule for %bb.0 ***
; CHECK-NEXT:         %3:ar = COPY $a0
; COISSUE-NEXT:       %1:mr = COPY $m1
; COISSUE-NEXT:       %0:mr = COPY $m0
; COISSUE-NEXT:       %2:mr = COPY $m2
; COISSUE-NEXT:       %7:ar = F32SUB $azero, %3:ar, 0
; COISSUE-NEXT:       %4:mr = XOR %0:mr, %1:mr, 0
; COISSUE-NEXT:       %8:ar = F32INT %7:ar, 3, 0
; COISSUE-NEXT:       %5:mr = XOR %4:mr, %2:mr, 0
; SINGLE-ISSUE-NEXT:  %2:mr = COPY $m2
; SINGLE-ISSUE-NEXT:  %1:mr = COPY $m1
; SINGLE-ISSUE-NEXT:  %0:mr = COPY $m0
; SINGLE-ISSUE-NEXT:  %4:mr = XOR %0:mr, %1:mr, 0
; SINGLE-ISSUE-NEXT:  %5:mr = XOR %4:mr, %2:mr, 0
; SINGLE-ISSUE-NEXT:  %7:ar = F32SUB $azero, %3:ar, 0
; SINGLE-ISSUE-NEXT:  %8:ar = F32INT %7:ar, 3, 0
; CHECK-NEXT:         %9:ar = F32TOUI32 %8:ar, 0
; CHECK-NEXT:        %10:mr = COPY %9:ar
; CHECK-NEXT:        %11:mr = AND %5:mr, %10:mr, 0
; CHECK-NEXT:          $m0  = COPY %11:mr
; CHECK-EMPTY:
define i32 @coissue1(i32 %a, i32 %b, i32 %c, float %d) {
  %xor1 = xor i32 %a, %b
  %xor2 = xor i32 %xor1, %c
  %fneg = fneg float %d
  %intfneg = fptoui float %fneg to i32
  %and = and i32 %xor2, %intfneg
  ret i32 %and
}

; Check that the scheduler interleaves instructions for main and aux pipelines
; unless coissue is disabled. Variant #2: a block of "aux instructions"
; followed by a single "main instruction".

; CHECK-LABEL:        Before MISched:{{[[:space:]]}}# Machine code for function coissue2:
; CHECK:              liveins:
; CHECK-NEXT:         %3:mr = COPY $m0
; CHECK-NEXT:         %2:ar = COPY $a2
; CHECK-NEXT:         %1:ar = COPY $a1
; CHECK-NEXT:         %0:ar = COPY $a0
; CHECK-NEXT:         %4:ar = F32ADD %0:ar, %1:ar, 0
; CHECK-NEXT:         %5:ar = F32ADD %4:ar, %2:ar, 0
; CHECK-NEXT:         %6:mr = SUB_ZI %3:mr, 0, 0
; CHECK-NEXT:         %7:ar = COPY %6:mr
; CHECK-NEXT:         %8:ar = F32FROMUI32 %7:ar, 0
; CHECK-NEXT:         %9:ar = F32MUL %5:ar, %8:ar, 0
; CHECK-NEXT:          $a0  = COPY %9:ar
; CHECK-NEXT:         RTN_PSEUDO

; CHECK:              ** Final schedule for %bb.0 ***
; CHECK-NEXT:         %3:mr = COPY $m0
; COISSUE-NEXT:       %1:ar = COPY $a1
; COISSUE-NEXT:       %0:ar = COPY $a0
; COISSUE-NEXT:       %2:ar = COPY $a2
; COISSUE-NEXT:       %4:ar = F32ADD %0:ar, %1:ar, 0
; COISSUE-NEXT:       %6:mr = SUB_ZI %3:mr, 0, 0
; COISSUE-NEXT:       %5:ar = F32ADD %4:ar, %2:ar, 0
; SINGLE-ISSUE-NEXT:  %2:ar = COPY $a2
; SINGLE-ISSUE-NEXT:  %1:ar = COPY $a1
; SINGLE-ISSUE-NEXT:  %0:ar = COPY $a0
; SINGLE-ISSUE-NEXT:  %4:ar = F32ADD %0:ar, %1:ar, 0
; SINGLE-ISSUE-NEXT:  %5:ar = F32ADD %4:ar, %2:ar, 0
; SINGLE-ISSUE-NEXT:  %6:mr = SUB_ZI %3:mr, 0, 0
; CHECK-NEXT:         %7:ar = COPY %6:mr
; CHECK-NEXT:         %8:ar = F32FROMUI32 %7:ar, 0
; CHECK-NEXT:         %9:ar = F32MUL %5:ar, %8:ar, 0
; CHECK-NEXT:          $a0  = COPY %9:ar
define float @coissue2(float %a, float %b, float %c, i32 %d) {
  %fadd1 = fadd float %a, %b
  %fadd2 = fadd float %fadd1, %c
  %neg = sub i32 0, %d
  %floatneg = uitofp i32 %neg to float
  %fmul = fmul float %fadd2, %floatneg
  ret float %fmul
}

; Check that the scheduler tries the latency heuristic before using node ID as
; a tie break to decide which of several candidates to schedule.

; CHECK-LABEL:        Before MISched:{{[[:space:]]}}# Machine code for function latency_before_nodeid:
; CHECK:              liveins:
; CHECK-NEXT:         %3:ar = COPY $a1
; CHECK-NEXT:         %2:ar = COPY $a0
; CHECK-NEXT:         %1:mr = COPY $m1
; CHECK-NEXT:         %0:mr = COPY $m0
; CHECK-NEXT:         %4:mr = MUL %0:mr, %1:mr, 0
; CHECK-NEXT:         %5:ar = F32ADD %2:ar, %3:ar, 0
; CHECK-NEXT:         %6:ar = F32INT %5:ar, 3, 0
; CHECK-NEXT:         %7:ar = F32TOI32 %6:ar, 0
; CHECK-NEXT:         %8:mr = COPY %7:ar
; CHECK-NEXT:         %9:mr = ADD %4:mr, %8:mr, 0
; CHECK-NEXT:          $m0  = COPY %9:mr
; CHECK-NEXT:         RTN_PSEUDO

; Check schedule units 4 and 5 correspond to MUL and F32ADD so that the next
; check makes sense.
; CHECK:  SU(4):   %4:mr = MUL %0:mr, %1:mr, 0
; CHECK:  SU(5):   %5:ar = F32ADD %2:ar, %3:ar, 0

; Check that the candidate selection is based on the latency heuristic and thus
; pick the f32add since the path to the bottom is the longest in terms of
; cumulated latency.
; CHECK:              Scheduling SU(3) %0:mr = COPY $m0
; CHECK-NOT:          Scheduling
; CHECK:              Queue TopQ.P:
; CHECK-NEXT:         Queue TopQ.A: 5 4
; CHECK-NEXT:           Cand SU(5) ORDER
; SINGLE-ISSUE-NEXT:    Cand SU(4) ORDER
; COISSUE-NEXT:       Pick Top TOP-PATH
; COISSUE-NEXT:       Scheduling SU(5) %5:ar = F32ADD %2:ar, %3:ar, 0
; SINGLE-ISSUE-NEXT:  Pick Top ORDER
; SINGLE-ISSUE-NEXT:  Scheduling SU(4) %4:mr = MUL %0:mr, %1:mr, 0

; CHECK:              ** Final schedule for %bb.0 ***
; CHECK-NEXT:         %3:ar = COPY $a1
; CHECK-NEXT:         %2:ar = COPY $a0
; CHECK-NEXT:         %1:mr = COPY $m1
; CHECK-NEXT:         %0:mr = COPY $m0
; COISSUE-NEXT:       %5:ar = F32ADD %2:ar, %3:ar, 0
; COISSUE-NEXT:       %4:mr = MUL %0:mr, %1:mr, 0
; SINGLE-ISSUE-NEXT:  %4:mr = MUL %0:mr, %1:mr, 0
; SINGLE-ISSUE-NEXT:  %5:ar = F32ADD %2:ar, %3:ar, 0
; CHECK-NEXT:         %6:ar = F32INT %5:ar, 3, 0
; CHECK-NEXT:         %7:ar = F32TOI32 %6:ar, 0
; CHECK-NEXT:         %8:mr = COPY %7:ar
; CHECK-NEXT:         %9:mr = ADD %4:mr, %8:mr, 0
; CHECK-NEXT:          $m0  = COPY %9:mr
define i32 @latency_before_nodeid(i32 %a, i32 %b, float %c, float %d) {
entry:
  %mul = mul i32 %a, %b
  %fadd = fadd float %c, %d
  %f = fptosi float %fadd to i32
  %ret = add i32 %mul, %f
  ret i32 %ret
}
