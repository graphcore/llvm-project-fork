; RUN: llc < %s -march=colossus -mattr=+ipu1 -colossus-vertex-red-zone-size=0 | FileCheck %s -check-prefix=RZ_0
; RUN: llc < %s -march=colossus -mattr=+ipu1 -colossus-vertex-red-zone-size=8 | FileCheck %s -check-prefix=RZ_8
; RUN: llc < %s -march=colossus -mattr=+ipu1 -colossus-vertex-red-zone-size=16 | FileCheck %s -check-prefix=RZ_16
; RUN: llc < %s -march=colossus -mattr=+ipu1 -colossus-vertex-red-zone-size=24 | FileCheck %s -check-prefix=RZ_24
; RUN: llc < %s -march=colossus -mattr=+ipu1 -colossus-vertex-red-zone-size=32 | FileCheck %s -check-prefix=RZ_32

; RUN: llc < %s -march=colossus -mattr=+ipu2 -colossus-vertex-red-zone-size=0 | FileCheck %s -check-prefix=RZ_0
; RUN: llc < %s -march=colossus -mattr=+ipu2 -colossus-vertex-red-zone-size=8 | FileCheck %s -check-prefix=RZ_8
; RUN: llc < %s -march=colossus -mattr=+ipu2 -colossus-vertex-red-zone-size=16 | FileCheck %s -check-prefix=RZ_16
; RUN: llc < %s -march=colossus -mattr=+ipu2 -colossus-vertex-red-zone-size=24 | FileCheck %s -check-prefix=RZ_24
; RUN: llc < %s -march=colossus -mattr=+ipu2 -colossus-vertex-red-zone-size=32 | FileCheck %s -check-prefix=RZ_32

; RUN: llc < %s -march=colossus -mattr=+ipu1 -colossus-vertex-red-zone-size=0 -colossus-stack-limit=__from_poplar -colossus-stack-overflow-handler=on_overflow | FileCheck %s -check-prefix=SO_0
; RUN: llc < %s -march=colossus -mattr=+ipu1 -colossus-vertex-red-zone-size=8 -colossus-stack-limit=__from_poplar -colossus-stack-overflow-handler=on_overflow | FileCheck %s -check-prefix=SO_8
; RUN: llc < %s -march=colossus -mattr=+ipu1 -colossus-vertex-red-zone-size=16 -colossus-stack-limit=__from_poplar -colossus-stack-overflow-handler=on_overflow | FileCheck %s -check-prefix=SO_16
; RUN: llc < %s -march=colossus -mattr=+ipu1 -colossus-vertex-red-zone-size=24 -colossus-stack-limit=__from_poplar -colossus-stack-overflow-handler=on_overflow | FileCheck %s -check-prefix=SO_24
; RUN: llc < %s -march=colossus -mattr=+ipu1 -colossus-vertex-red-zone-size=32 -colossus-stack-limit=__from_poplar -colossus-stack-overflow-handler=on_overflow | FileCheck %s -check-prefix=SO_32

; RUN: llc < %s -march=colossus -mattr=+ipu2 -colossus-vertex-red-zone-size=0 -colossus-stack-limit=__from_poplar -colossus-stack-overflow-handler=on_overflow | FileCheck %s -check-prefix=SO_0
; RUN: llc < %s -march=colossus -mattr=+ipu2 -colossus-vertex-red-zone-size=8 -colossus-stack-limit=__from_poplar -colossus-stack-overflow-handler=on_overflow | FileCheck %s -check-prefix=SO_8
; RUN: llc < %s -march=colossus -mattr=+ipu2 -colossus-vertex-red-zone-size=16 -colossus-stack-limit=__from_poplar -colossus-stack-overflow-handler=on_overflow | FileCheck %s -check-prefix=SO_16
; RUN: llc < %s -march=colossus -mattr=+ipu2 -colossus-vertex-red-zone-size=24 -colossus-stack-limit=__from_poplar -colossus-stack-overflow-handler=on_overflow | FileCheck %s -check-prefix=SO_24
; RUN: llc < %s -march=colossus -mattr=+ipu2 -colossus-vertex-red-zone-size=32 -colossus-stack-limit=__from_poplar -colossus-stack-overflow-handler=on_overflow | FileCheck %s -check-prefix=SO_32

; Fixed stack slots are indexed relative to $m11. A future refinement
; to getFrameRegister can allow direct use of $m12 where $m11 is not needed.

@len = external dso_local local_unnamed_addr global i32, align 4
@data = external dso_local local_unnamed_addr global float*, align 4
@res = external dso_local local_unnamed_addr global float, align 4

; RZ_0-LABEL: access_fixed_slot:
; RZ_0:       add $m11, $m12
; RZ_0:       st64 $a0:1, $m11, $m15, 0
; RZ_0:       ld64 $a0:1, $m11, $m15, 0
; RZ_0:       exitnz $m15
; RZ_8-LABEL: access_fixed_slot:
; RZ_8-NOT:   add $m11, $m12
; RZ_8:       mov $m11, $m12
; RZ_8:       st64 $a0:1, $m11, $m15, 0
; RZ_8:       ld64 $a0:1, $m11, $m15, 0
; RZ_8:       exitnz $m15

define colossus_vertex i32 @access_fixed_slot() {
entry:
  %0 = tail call { <2 x float>, <2 x float>, <2 x float>, <2 x float> } asm "# Write fp regs", "=r,=r,=r,=r"()
  %asmresult = extractvalue { <2 x float>, <2 x float>, <2 x float>, <2 x float> } %0, 0
  %asmresult1 = extractvalue { <2 x float>, <2 x float>, <2 x float>, <2 x float> } %0, 1
  %asmresult2 = extractvalue { <2 x float>, <2 x float>, <2 x float>, <2 x float> } %0, 2
  %asmresult3 = extractvalue { <2 x float>, <2 x float>, <2 x float>, <2 x float> } %0, 3
  %1 = load i32, i32* @len, align 4
  %cmp13 = icmp sgt i32 %1, 0
  br i1 %cmp13, label %for.body.lr.ph, label %for.cond.cleanup

for.body.lr.ph:                                   ; preds = %entry
  %2 = load float*, float** @data, align 4
  br label %for.body

for.body:                                         ; preds = %for.body.lr.ph, %for.body
  %i.015 = phi i32 [ 0, %for.body.lr.ph ], [ %inc, %for.body ]
  %x.014 = phi float [ 1.000000e+00, %for.body.lr.ph ], [ %add, %for.body ]
  %arrayidx = getelementptr inbounds float, float* %2, i32 %i.015
  %3 = load float, float* %arrayidx, align 4
  %add = fadd float %x.014, %3
  %inc = add nuw nsw i32 %i.015, 1
  %cmp = icmp slt i32 %inc, %1
  br i1 %cmp, label %for.body, label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.body, %entry
  %x.0.lcssa = phi float [ 1.000000e+00, %entry ], [ %add, %for.body ]
  store float %x.0.lcssa, float* @res, align 4
  tail call void asm sideeffect "# Read fp regs", "r,r,r,r"(<2 x float> %asmresult, <2 x float> %asmresult1, <2 x float> %asmresult2, <2 x float> %asmresult3)
  ret i32 0
}

define colossus_vertex i32 @sp_alloc() {
  %a = alloca i32, i32 4
  call void asm sideeffect "# Use stack object", "r"(i32* %a)
  ret i32 0
}
; RZ_0-LABEL:  sp_alloc:
; RZ_0:        add $m11, $m12, -16
; RZ_0:        exitnz $m15
; RZ_8-LABEL:  sp_alloc:
; RZ_8:        add $m11, $m12, -8
; RZ_8:        exitnz $m15
; RZ_16-LABEL: sp_alloc:
; RZ_16:       mov $m11, $m12
; RZ_16:       exitnz $m15
; RZ_24-LABEL: sp_alloc:
; RZ_24:       add $m11, $m12, 8
; RZ_24:       exitnz $m15
; RZ_32-LABEL: sp_alloc:
; RZ_32:       add $m11, $m12, 8
; RZ_32:       exitnz $m15
; SO_0-LABEL:  access_fixed_slot:
; SO_0:        setzi $m6, 16
; SO_0:        cmpult $m6, $m6, __from_poplar
; SO_0:        brz $m6, on_overflow
; SO_0:        add $m11, $m12, -16
; SO_0:        exitnz $m15
; SO_8-LABEL:  access_fixed_slot:
; SO_8:        setzi $m6, 8
; SO_8:        cmpult $m6, $m6, __from_poplar
; SO_8:        brz $m6, on_overflow
; SO_8:        add $m11, $m12, -8
; SO_8:        exitnz $m15
; SO_16-LABEL: access_fixed_slot:
; SO_16-NOT:   setzi $m6
; SO_16-NOT:   cmpult $m6, $m6, __from_poplar
; SO_16-NOT:   brz $m6, on_overflow
; SO_16:       mov $m11, $m12
; SO_16:       exitnz $m15
; SO_24-LABEL: access_fixed_slot:
; SO_24-NOT:   setzi $m6
; SO_24-NOT:   cmpult $m6, $m6, __from_poplar
; SO_24-NOT:   brz $m6, on_overflow
; SO_24:       add $m11, $m12, 8
; SO_24:       exitnz $m15
; SO_32-LABEL: access_fixed_slot:
; SO_32-NOT:   setzi $m6
; SO_32-NOT:   cmpult $m6, $m6, __from_poplar
; SO_32-NOT:   brz $m6, on_overflow
; SO_32:       add $m11, $m12, 8
; SO_32:       exitnz $m15
define colossus_vertex i32 @sp_alloc_and_align() {
  %a = alloca i32, i32 4, align 16
  call void asm sideeffect "# Use stack object", "r"(i32* %a)
  ret i32 0
}

; RZ_0-LABEL:  sp_alloc_and_align:
; RZ_0:        add $m11, $m12, -16
; RZ_0:        andc $m11, $m11, 15
; RZ_0:        add $m0, $m11, 0
; RZ_0:        exitnz $m15
; RZ_8-LABEL:  sp_alloc_and_align:
; RZ_8:        add $m11, $m12, -8
; RZ_8:        andc $m11, $m11, 15
; RZ_8:        add $m0, $m11, 0
; RZ_8:        exitnz $m15
; RZ_16-LABEL: sp_alloc_and_align:
; RZ_16:       andc $m11, $m12, 15
; RZ_16:       add $m0, $m11, 0
; RZ_16:       exitnz $m15
; RZ_24-LABEL: sp_alloc_and_align:
; RZ_24:       add $m11, $m12, 8
; RZ_24:       andc $m11, $m11, 15
; RZ_24:       add $m0, $m11, 0
; RZ_24:       exitnz $m15
; RZ_32-LABEL: sp_alloc_and_align:
; RZ_32:       add $m11, $m12, 8
; RZ_32:       andc $m11, $m11, 15
; RZ_32:       add $m0, $m11, 0
; RZ_32:       exitnz $m15
; SO_0-LABEL:  sp_alloc_and_align:
; SO_0:        setzi $m6, 31
; SO_0:        cmpult $m6, $m6, __from_poplar
; SO_0:        brz $m6, on_overflow
; SO_0:        add $m11, $m12, -16
; SO_0:        andc $m11, $m11, 15
; SO_0:        add $m0, $m11, 0
; SO_0:        exitnz $m15
; SO_8-LABEL:  sp_alloc_and_align:
; SO_8:        setzi $m6, 23
; SO_8:        cmpult $m6, $m6, __from_poplar
; SO_8:        brz $m6, on_overflow
; SO_8:        add $m11, $m12, -8
; SO_8:        andc $m11, $m11, 15
; SO_8:        add $m0, $m11, 0
; SO_8:        exitnz $m15
; SO_16-LABEL: sp_alloc_and_align:
; SO_16:       setzi $m6, 15
; SO_16:       cmpult $m6, $m6, __from_poplar
; SO_16:       brz $m6, on_overflow
; SO_16:       andc $m11, $m12, 15
; SO_16:       add $m0, $m11, 0
; SO_16:       exitnz $m15
; SO_24-LABEL: sp_alloc_and_align:
; SO_24:       setzi $m6, 7
; SO_24:       cmpult $m6, $m6, __from_poplar
; SO_24:       brz $m6, on_overflow
; SO_24:       add $m11, $m12, 8
; SO_24:       andc $m11, $m11, 15
; SO_24:       add $m0, $m11, 0
; SO_24:       exitnz $m15
; SO_32-LABEL: sp_alloc_and_align:
; SO_32-NOT    setzi $m6
; SO_32-NOT:   cmpult $m6, $m6, __from_poplar
; SO_32-NOT:   brz $m6, on_overflow
; SO_32:       add $m11, $m12, 8
; SO_32:       andc $m11, $m11, 15
; SO_32:       add $m0, $m11, 0
; SO_32:       exitnz $m15
