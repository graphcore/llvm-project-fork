; RUN: llc -march=colossus -mattr=+ipu1 < %s | FileCheck %s
; RUN: llc -march=colossus -mattr=+ipu2 < %s | FileCheck %s

; Code that emits this IR:
; int strcmp(const char *s1, const char *s2) {
;   const unsigned char *ss1 = (const unsigned char *) s1;
;   const unsigned char *ss2 = (const unsigned char *) s2;
;   for (; *ss1 != '\0'; ++ss1) {
;     if (*ss1 != *ss2) {
;       break;
;     }
;     ss2++;
;   }
;   return *ss1 - *ss2;
; }

; CHECK:  strcmp:
; CHECK:    ldz8 [[LDZ8REG:\$m[0-9]+]], {{\$m[0-9]+}}, {{\$m[0-9]+}}, 0
; CHECK:    brz {{\$m[0-9]}}, .LBB0_4
; CHECK:    add {{\$m[0-9]}}, $m0, 1
; CHECK:  .LBB0_2:
; CHECK:    ldz8 {{\$m[0-9]+}}, {{\$m[0-9]+}}, {{\$m[0-9]+}}, 0
; CHECK:    cmpne {{\$m[0-9]+}}, [[LDZ8REG]], {{\$m[0-9]+}}
; CHECK:    brnz {{\$m[0-9]+}}, .LBB0_5
; CHECK:    ldz8step [[LDZ8REG]], {{\$m[0-9]+}}, {{\$m[0-9]+}}+=, 1
; CHECK:    add {{\$m[0-9]+}}, {{\$m[0-9]+}}, 1
; CHECK:    brnz [[LDZ8REG]], .LBB0_2
; CHECK:  .LBB0_4:
; CHECK:    mov	{{\$m[0-9]+}}, {{\$m[0-9]+}}
; CHECK:  .LBB0_5:
; CHECK:    ldz8 {{\$m[0-9]+}}, {{\$m[0-9]+}}, {{\$m[0-9]+}}, 0
; CHECK:    sub {{\$m[0-9]+}}, [[LDZ8REG]], {{\$m[0-9]+}}
; CHECK:    br {{\$m[0-9]+}}

define i32 @strcmp(i8* %s1, i8* %s2) {
entry:
  %0 = load i8, i8* %s1, align 1
  %cmp16 = icmp eq i8 %0, 0
  br i1 %cmp16, label %for.end, label %for.body

for.body:
  %1 = phi i8 [ %3, %if.end ], [ %0, %entry ]
  %ss2.018 = phi i8* [ %incdec.ptr, %if.end ], [ %s2, %entry ]
  %ss1.017 = phi i8* [ %incdec.ptr6, %if.end ], [ %s1, %entry ]
  %2 = load i8, i8* %ss2.018, align 1
  %cmp4 = icmp eq i8 %1, %2
  br i1 %cmp4, label %if.end, label %for.end

if.end:
  %incdec.ptr = getelementptr inbounds i8, i8* %ss2.018, i32 1
  %incdec.ptr6 = getelementptr inbounds i8, i8* %ss1.017, i32 1
  %3 = load i8, i8* %incdec.ptr6, align 1
  %cmp = icmp eq i8 %3, 0
  br i1 %cmp, label %for.end, label %for.body

for.end:
  %ss2.0.lcssa = phi i8* [ %s2, %entry ], [ %ss2.018, %for.body ], [ %incdec.ptr, %if.end ]
  %.lcssa = phi i8 [ 0, %entry ], [ %1, %for.body ], [ 0, %if.end ]
  %conv7 = zext i8 %.lcssa to i32
  %4 = load i8, i8* %ss2.0.lcssa, align 1
  %conv8 = zext i8 %4 to i32
  %sub = sub nsw i32 %conv7, %conv8
  ret i32 %sub
}

