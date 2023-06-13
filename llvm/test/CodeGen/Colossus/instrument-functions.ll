; RUN: llc -march=colossus -o - < %s | FileCheck %s

; CHECK-LABEL: test1:
; CHECK: mov [[RET:\$m[0-9]+]], $m10
; CHECK: setzi [[FUNC:\$m[0-9]+]], test1
; CHECK: mov $m0, [[FUNC]]
; CHECK: mov $m1, [[RET]]
; CHECK: call $m10, __cyg_profile_func_enter
; CHECK: mov $m0, [[FUNC]]
; CHECK: mov $m1, [[RET]]
; CHECK: call $m10, __cyg_profile_func_exit
define i32 @test1(i32 %x) {
entry:
  %0 = call i8* @llvm.returnaddress(i32 0)
  call void @__cyg_profile_func_enter(i8* bitcast (i32 (i32)* @test1 to i8*), i8* %0)
  %x.addr = alloca i32, align 4
  store i32 %x, i32* %x.addr, align 4
  %1 = load i32, i32* %x.addr, align 4
  %2 = call i8* @llvm.returnaddress(i32 0)
  call void @__cyg_profile_func_exit(i8* bitcast (i32 (i32)* @test1 to i8*), i8* %2)
  ret i32 %1
}

; CHECK-LABEL: test2:
; CHECK-NOT: __cyg_profile_func_enter
; CHECK-NOT: __cyg_profile_func_exit
define i32 @test2(i32 %x) {
entry:
  %x.addr = alloca i32, align 4
  store i32 %x, i32* %x.addr, align 4
  %0 = load i32, i32* %x.addr, align 4
  ret i32 %0
}

declare void @__cyg_profile_func_enter(i8*, i8*)

declare i8* @llvm.returnaddress(i32 immarg)

declare void @__cyg_profile_func_exit(i8*, i8*)

