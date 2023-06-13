; XFAIL: *
; RUN: llc < %s -march=colossus -mattr=+ipu1 | FileCheck %s
; RUN: llc < %s -march=colossus -mattr=+ipu2 | FileCheck %s
; RUN: llc -fp-contract=fast < %s -march=colossus | FileCheck %s --check-prefix FAST

declare <4 x half> @llvm.fma.v4f16(<4 x half> %a, <4 x half> %b, <4 x half> %c)
declare <4 x half> @llvm.experimental.constrained.fadd.v4f16(<4 x half>, <4 x half>, metadata, metadata)
declare <4 x half> @llvm.experimental.constrained.fmul.v4f16(<4 x half>, <4 x half>, metadata, metadata)
declare <4 x half> @llvm.experimental.constrained.fma.v4f16(<4 x half>, <4 x half>, <4 x half>, metadata, metadata)

; CHECK-LABEL: fma:
; CHECK:       f16v2tof32
; CHECK:       f16v2tof32
; CHECK:       f32v2putacc 0,
; CHECK:       f32v2putacc 2,
; CHECK:       f16v4mac $a{{.+}}, $a{{.+}}, 0
; CHECK:       f32v2getacc $a{{.+}}, 0
; CHECK:       f32v2tof16
; CHECK:       f32v2getacc $a{{.+}}, 2
; CHECK:       f32v2tof16
define <4 x half> @fma(<4 x half> %a, <4 x half> %b, <4 x half> %c) {
  %r = call <4 x half> @llvm.fma.v4f16(<4 x half> %a, <4 x half> %b, <4 x half> %c)
  ret <4 x half> %r
}

; CHECK-LABEL: constrained_fma:
; CHECK:       f16v2tof32
; CHECK:       f16v2tof32
; CHECK:       f32v2putacc 0,
; CHECK:       f32v2putacc 2,
; CHECK:       f16v4mac $a{{.+}}, $a{{.+}}, 0
; CHECK:       f32v2getacc $a{{.+}}, 0
; CHECK:       f32v2tof16
; CHECK:       f32v2getacc $a{{.+}}, 2
; CHECK:       f32v2tof16
define <4 x half> @constrained_fma(<4 x half> %a, <4 x half> %b, <4 x half> %c) {
  %r = call <4 x half> @llvm.experimental.constrained.fma.v4f16(<4 x half> %a, <4 x half> %b, <4 x half> %c, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <4 x half> %r
}

; CHECK-LABEL: fma_combined:
; CHECK:       f16v4mul $a0:1, $a0:1, $a2:3
; CHECK:       f16v4add $a0:1, $a0:1, $a2:3

; FAST-LABEL: fma_combined:
; FAST:       f16v2tof32
; FAST:       f16v2tof32
; FAST:       f32v2putacc 0,
; FAST:       f32v2putacc 2,
; FAST:       f16v4mac $a{{.+}}, $a{{.+}}, 0
; FAST:       f32v2getacc $a{{.+}}, 0
; FAST:       f32v2tof16
; FAST:       f32v2getacc $a{{.+}}, 2
; FAST:       f32v2tof16
define <4 x half> @fma_combined(<4 x half> %a, <4 x half> %b, <4 x half> %c) {
  %r1 = fmul <4 x half> %a, %b
  %r2 = fadd <4 x half> %r1, %c
  ret <4 x half> %r2
}

; CHECK-LABEL: constrained_fma_combined:
; CHECK:       f16v4mul $a0:1, $a0:1, $a2:3
; CHECK:       f16v4add $a0:1, $a0:1, $a2:3

; FAST-LABEL: constrained_fma_combined:
; FAST:       f16v2tof32
; FAST:       f16v2tof32
; FAST:       f32v2putacc 0,
; FAST:       f32v2putacc 2,
; FAST:       f16v4mac $a{{.+}}, $a{{.+}}, 0
; FAST:       f32v2getacc $a{{.+}}, 0
; FAST:       f32v2tof16
; FAST:       f32v2getacc $a{{.+}}, 2
; FAST:       f32v2tof16
define <4 x half> @constrained_fma_combined(<4 x half> %a, <4 x half> %b, <4 x half> %c) {
  %r1 = call <4 x half> @llvm.experimental.constrained.fmul.v4f16(<4 x half> %a, <4 x half> %b, metadata !"round.tonearest", metadata !"fpexcept.strict")
  %r2 = call <4 x half> @llvm.experimental.constrained.fadd.v4f16(<4 x half> %r1, <4 x half> %c, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <4 x half> %r2
}
