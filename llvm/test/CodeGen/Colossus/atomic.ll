; RUN: llc < %s -march=colossus -mattr=+ipu1 | FileCheck %s
; RUN: llc --filetype=obj < %s -march=colossus -o /dev/null -mattr=+ipu1
; RUN: llc < %s -march=colossus -mattr=+ipu2 | FileCheck %s
; RUN: llc --filetype=obj < %s -march=colossus -o /dev/null -mattr=+ipu2

; CHECK-LABEL: atomic_fence
; CHECK:       # MEM_BARRIER
; CHECK:       # MEM_BARRIER
; CHECK:       # MEM_BARRIER
; CHECK:       # MEM_BARRIER
; CHECK:       br $m10
define void @atomic_fence() nounwind {
entry:
  fence acquire
  fence release
  fence acq_rel
  fence seq_cst
  ret void
}

@pool = external global i64

; NOTE: atomic i8 and i16 stores not supported.

define void @atomic_load_store() nounwind {
entry:
; CHECK-LABEL: atomic_load_store
; CHECK:       setzi [[ADDR:\$m[0-9]+]], pool

; ## Acquire.

; CHECK:       ld32 [[R0:\$m[0-9]+]], [[ADDR]], $m15, 0
; CHECK-NEXT:  # MEM_BARRIER
  %0 = load atomic i32, i32* bitcast (i64* @pool to i32*) acquire, align 4

; CHECK-NEXT:  ldz16 [[R1:\$m[0-9]+]], [[ADDR]], $m15, 0
; CHECK-NEXT:  # MEM_BARRIER
  %1 = load atomic i16, i16* bitcast (i64* @pool to i16*) acquire, align 2

; CHECK-NEXT:  ldz8 [[R2:\$m[0-9]+]], [[ADDR]], $m15, 0
; CHECK-NEXT:  # MEM_BARRIER
  %2 = load atomic i8, i8* bitcast (i64* @pool to i8*) acquire, align 1

; ## Release.

; CHECK-NEXT:  # MEM_BARRIER
; CHECK-NEXT:  st32 [[R0]], [[ADDR]]
  store atomic i32 %0, i32* bitcast (i64* @pool to i32*) release, align 4

  call void asm sideeffect "", "r"(i16 %1)
  call void asm sideeffect "", "r"(i8 %2)

; ## SequentiallyConsistent.

; CHECK:       ld32 [[R3:\$m[0-9]+]], [[ADDR]], $m15, 0
; CHECK-NEXT:  # MEM_BARRIER
  %3 = load atomic i32, i32* bitcast (i64* @pool to i32*) seq_cst, align 4

; CHECK-NEXT:  ldz16 [[R4:\$m[0-9]+]], [[ADDR]], $m15, 0
; CHECK-NEXT:  # MEM_BARRIER
  %4 = load atomic i16, i16* bitcast (i64* @pool to i16*) seq_cst, align 2

; CHECK-NEXT:  ldz8 [[R5:\$m[0-9]+]], [[ADDR]], $m15, 0
; CHECK-NEXT:  # MEM_BARRIER
  %5 = load atomic i8, i8* bitcast (i64* @pool to i8*) seq_cst, align 1

; CHECK-NEXT:  # MEM_BARRIER
; CHECK-NEXT:  st32 [[R3]], [[ADDR]], $m15, 0
; CHECK-NEXT:  # MEM_BARRIER
  store atomic i32 %3, i32* bitcast (i64* @pool to i32*) seq_cst, align 4

  call void asm sideeffect "", "r"(i16 %4)
  call void asm sideeffect "", "r"(i8 %5)

; ## Monotonic.

; CHECK:      ld32 [[R4:\$m[0-9]+]], [[ADDR]], $m15, 0
  %6 = load atomic i32, i32* bitcast (i64* @pool to i32*) monotonic, align 4
    call void asm sideeffect "", "r"(i32 %6)

; CHECK: st32 [[R4]], [[ADDR]], $m15, 0
  store atomic i32 %6, i32* bitcast (i64* @pool to i32*) monotonic, align 4
    call void asm sideeffect "", "r"(i32 %6)

; CHECK:      ldz16
  %7 = load atomic i16, i16* bitcast (i64* @pool to i16*) monotonic, align 2
  call void asm sideeffect "", "r"(i16 %7)

; CHECK:      ldz8
  %8 = load atomic i8, i8* bitcast (i64* @pool to i8*) monotonic, align 1
  call void asm sideeffect "", "r"(i8 %8)

  ret void
}
