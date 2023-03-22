; RUN: llvm-link %isdopc %s | opt -instcombine -always-inline -mattr=+ipu1 | llc -march=colossus -colossus-coissue=false -mattr=+ipu1 | FileCheck %s
; RUN: llvm-link %isdopc %s | opt -instcombine -always-inline -mattr=+ipu2 | llc -march=colossus -colossus-coissue=false -mattr=+ipu2 | FileCheck %s

@ISD_UMUL_LOHI = external constant i32
@ISD_MULHU = external constant i32

declare i32 @llvm.colossus.SDAG.binary.i32.i32.i32(i32, i32, i32)
declare <2 x i32> @llvm.colossus.SDAG.binary.v2i32.v2i32.v2i32(i32, <2 x i32>, <2 x i32>)

declare {i32, i32} @llvm.colossus.SDAG.binary.binary.i32.i32.i32.i32(i32, i32, i32)
declare {<2 x i32>, <2 x i32>} @llvm.colossus.SDAG.binary.binary.v2i32.v2i32.v2i32.v2i32(i32, <2 x i32>, <2 x i32>)

; Regexes check the custom lowering of i32 exactly
; v2i32 mulhx is lowered by splitting in half then calling the i32 lowering
; xmul_lohi is lowered as one multiplication and one mulhx

; CHECK-LABEL: mulhu_i32:
; CHECK:       # %bb.0:
; CHECK-DAG:   sort4x16lo [[LOY:\$m[2-9]+]], $m1, $m15
; CHECK-DAG:   sort4x16lo [[LOX:\$m[2-9]+]], $m0, $m15
; CHECK-NEXT:  mul [[LOXLOY:\$m[0-9]+]], [[LOX]], [[LOY]]
; CHECK-NEXT:  shr [[LOXLOY]], [[LOXLOY]], 16
; CHECK-NEXT:  shr [[HIX:\$m[0-9]+]], $m0, 16
; CHECK-NEXT:  mul [[HIXLOY:\$m[0-9]+]], [[HIX]], [[LOY]]
; CHECK-NEXT:  add [[REG0:\$m[0-9]+]], [[HIXLOY]], [[LOXLOY]]
; CHECK-NEXT:  shr [[REG1:\$m[0-9]+]], [[REG0]], 16
; CHECK-NEXT:  shr [[HIY:\$m[0-9]+]], $m1, 16
; CHECK-NEXT:  mul [[HIXHIY:\$m[0-9]+]], [[HIX]], [[HIY]]
; CHECK-NEXT:  add [[REG2:\$m[0-9]+]], [[HIXHIY]], [[REG1]]
; CHECK-NEXT:  sort4x16lo [[REG3:\$m[0-9]+]], [[REG0]], $m15
; CHECK-NEXT:  mul [[LOXHIY:\$m[0-9]+]], [[LOX]], [[HIY]]
; CHECK-NEXT:  add [[REG4:\$m[0-9]+]], [[LOXHIY]], [[REG3]]
; CHECK-NEXT:  shr [[REG5:\$m[0-9]+]], [[REG4]], 16
; CHECK-NEXT:  add $m0, [[REG2]], [[REG5]]
; CHECK-NEXT:  br $m10
define i32 @mulhu_i32(i32 zeroext %x, i32 zeroext %y)
{
 %id = load i32, i32* @ISD_MULHU
 %res = call i32 @llvm.colossus.SDAG.binary.i32.i32.i32(i32 %id, i32 %x, i32 %y)
 ret i32 %res
}

; CHECK-LABEL: mulhu_v2i32:
; CHECK-DAG:   mul
; CHECK-DAG:   mul
; CHECK-DAG:   mul
; CHECK-DAG:   mul
; CHECK-DAG:   add
; CHECK-DAG:   add
; CHECK-DAG:   add
; CHECK-DAG:   add
; CHECK-DAG:   shr
; CHECK-DAG:   shr
; CHECK-DAG:   shr
; CHECK-DAG:   shr
; CHECK-DAG:   shr
; CHECK-DAG:   mul
; CHECK-DAG:   mul
; CHECK-DAG:   mul
; CHECK-DAG:   mul
; CHECK-DAG:   add
; CHECK-DAG:   add
; CHECK-DAG:   add
; CHECK-DAG:   add
; CHECK-DAG:   shr
; CHECK-DAG:   shr
; CHECK-DAG:   shr
; CHECK-DAG:   shr
; CHECK-DAG:   shr
; CHECK:       br $m10
define <2 x i32> @mulhu_v2i32(<2 x i32> %x, <2 x i32> %y)
{
 %id = load i32, i32* @ISD_MULHU
 %res = call <2 x i32> @llvm.colossus.SDAG.binary.v2i32.v2i32.v2i32(i32 %id, <2 x i32> %x, <2 x i32> %y)
 ret <2 x i32> %res
}

; umul_lohi is lowered to mulhu (checked above) and a single mul on the input
; registers. From a register pressure perspective the mul $m0, $m0, $m1 should
; happen earlier in the codegen and the trailing mov elided.
; CHECK-LABEL: umul_lohi_i32:
; CHECK:       # %bb.0:
; CHECK-DAG:   sort4x16lo [[LOY:\$m[2-9]+]], $m1, $m15
; CHECK-DAG:   sort4x16lo [[LOX:\$m[2-9]+]], $m0, $m15
; CHECK-NEXT:  mul [[LOXLOY:\$m[0-9]+]], [[LOX]], [[LOY]]
; CHECK-NEXT:  shr [[LOXLOY]], [[LOXLOY]], 16
; CHECK-NEXT:  shr [[HIX:\$m[0-9]+]], $m0, 16
; CHECK-NEXT:  mul [[HIXLOY:\$m[0-9]+]], [[HIX]], [[LOY]]
; CHECK-NEXT:  add [[REG0:\$m[0-9]+]], [[HIXLOY]], [[LOXLOY]]
; CHECK-NEXT:  shr [[REG1:\$m[0-9]+]], [[REG0]], 16
; CHECK-NEXT:  shr [[HIY:\$m[0-9]+]], $m1, 16
; CHECK-NEXT:  mul [[HIXHIY:\$m[0-9]+]], [[HIX]], [[HIY]]
; CHECK-NEXT:  add [[REG2:\$m[0-9]+]], [[HIXHIY]], [[REG1]]
; CHECK-NEXT:  sort4x16lo [[REG3:\$m[0-9]+]], [[REG0]], $m15
; CHECK-NEXT:  mul [[LOXHIY:\$m[0-9]+]], [[LOX]], [[HIY]]
; CHECK-NEXT:  add [[REG4:\$m[0-9]+]], [[LOXHIY]], [[REG3]]
; CHECK-NEXT:  shr [[REG5:\$m[0-9]+]], [[REG4]], 16
; CHECK-NEXT:  add [[REG6:\$m[0-9]+]], [[REG2]], [[REG5]]
; CHECK-NEXT:  mul $m0, $m0, $m1
; CHECK-NEXT:  mov $m1, [[REG6]]
; CHECK:       br $m10
define {i32, i32} @umul_lohi_i32(i32 zeroext %x, i32 zeroext %y)
{
 %id = load i32, i32* @ISD_UMUL_LOHI
 %res = call {i32, i32} @llvm.colossus.SDAG.binary.binary.i32.i32.i32.i32(i32 %id, i32 %x, i32 %y)
 ret {i32, i32} %res
}

; CHECK-LABEL: umul_lohi_v2i32:
; CHECK:       # %bb.0:
; CHECK-DAG:   mul {{\$m[0-9]+}}, $m0, $m2
; CHECK-DAG:   mul {{\$m[0-9]+}}, $m1, $m3
; CHECK-DAG:   mul
; CHECK-DAG:   mul
; CHECK-DAG:   mul
; CHECK-DAG:   mul
; CHECK-DAG:   add
; CHECK-DAG:   add
; CHECK-DAG:   add
; CHECK-DAG:   add
; CHECK-DAG:   shr
; CHECK-DAG:   shr
; CHECK-DAG:   shr
; CHECK-DAG:   shr
; CHECK-DAG:   shr
; CHECK-DAG:   mul
; CHECK-DAG:   mul
; CHECK-DAG:   mul
; CHECK-DAG:   mul
; CHECK-DAG:   add
; CHECK-DAG:   add
; CHECK-DAG:   add
; CHECK-DAG:   add
; CHECK-DAG:   shr
; CHECK-DAG:   shr
; CHECK-DAG:   shr
; CHECK-DAG:   shr
; CHECK-DAG:   shr
; CHECK:       br $m10
define {<2 x i32>, <2 x i32>} @umul_lohi_v2i32(<2 x i32> %x, <2 x i32> %y)
{
 %id = load i32, i32* @ISD_UMUL_LOHI
 %res = call {<2 x i32>, <2 x i32>} @llvm.colossus.SDAG.binary.binary.v2i32.v2i32.v2i32.v2i32(i32 %id, <2 x i32> %x, <2 x i32> %y)
 ret {<2 x i32>, <2 x i32>} %res
}
