
; llvm.returnaddress(c) with c>0 will always return 0 for Colossus

; RUN: llc  -march=colossus < %s | FileCheck %s

define i8* @retaddr(i32 %x) {
entry:
; CHECK:        retaddr:
; CHECK:        # %bb.0:
; CHECK-NEXT:   mov $m0, $m10
  %0 = call i8* @llvm.returnaddress(i32 0)
  ret i8* %0
}

define i8* @retaddr_2(i32 %x) {
entry:
; CHECK:        retaddr_2:
; CHECK:        # %bb.0:
; CHECK-NEXT:   mov $m0, $m15
  %0 = call i8* @llvm.returnaddress(i32 2)
  ret i8* %0
}
declare i8* @llvm.returnaddress(i32)
