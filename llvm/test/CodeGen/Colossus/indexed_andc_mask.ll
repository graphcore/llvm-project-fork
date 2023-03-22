; RUN: llc < %s -march=colossus -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -march=colossus -mattr=+ipu2 | FileCheck %s

; Function that generates Neg0x3:
; void Neg0x3(__fp16* in, __fp16* out, unsigned idx) {
;   *out = in[idx & (~3)];
; }

define void @Neg0x3(half* %in, half* %out, i32 %idx) {
; CHECK-LABEL: Neg0x3:
; CHECK:    andc [[IDX:\$m[0-9]+]], [[IDX]], 3
entry:
  %and = and i32 %idx, -4
  %arrayidx = getelementptr half, half* %in, i32 %and
  %0 = load half, half* %arrayidx, align 2
  store half %0, half* %out, align 2
  ret void
}

define void @Neg0x1000(half* %in, half* %out, i32 %idx) {
; CHECK-LABEL: Neg0x1000:
; CHECK:    setzi [[CREG:\$m[0-9]+]], 4096
; CHECK:    andc [[IDX:\$m[0-9]+]], [[IDX]], [[CREG]]
entry:
  %and = and i32 %idx, -4097
  %arrayidx = getelementptr half, half* %in, i32 %and
  %0 = load half, half* %arrayidx, align 2
  store half %0, half* %out, align 2
  ret void
}

define void @Neg0x200000(half* %in, half* %out, i32 %idx) {
; CHECK-LABEL: Neg0x200000:
; CHECK:    setzi [[CREG:\$m[0-9]+]], 1048575
; CHECK:    or [[CREG]], [[CREG]], 2144337920
; CHECK:    and [[IDX:\$m[0-9]+]], [[IDX]], [[CREG]]
entry:
  %and = and i32 %idx, -2097153
  %arrayidx = getelementptr half, half* %in, i32 %and
  %0 = load half, half* %arrayidx, align 2
  store half %0, half* %out, align 2
  ret void
}

