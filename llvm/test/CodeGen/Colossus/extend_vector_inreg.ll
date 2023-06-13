; XFAIL: *
; RUN: llvm-link %isdopc %s | opt -instcombine -always-inline | llc -march=colossus -o %t.this
; RUN: llvm-link %isdopc %S/extend_vector_inreg_reference.ll | opt -instcombine -always-inline | llc -march=colossus -o %t.other
; RUN: diff %t.this %t.other
target triple = "colossus-graphcore--elf"

; Create extend vector inreg sdag nodes.
; Diff compares the result with open coded equivalent.

@ISD_ANY_EXTEND = external constant i32
@ISD_ANY_EXTEND_VECTOR_INREG = external constant i32
@ISD_ZERO_EXTEND = external constant i32
@ISD_ZERO_EXTEND_VECTOR_INREG = external constant i32
@ISD_SIGN_EXTEND = external constant i32
@ISD_SIGN_EXTEND_VECTOR_INREG = external constant i32

declare <1 x i2> @llvm.colossus.SDAG.unary.v1i2.v2i1(i32, <2 x i1>)
declare <1 x i4> @llvm.colossus.SDAG.unary.v1i4.v2i2(i32, <2 x i2>)
declare <1 x i6> @llvm.colossus.SDAG.unary.v1i6.v2i3(i32, <2 x i3>)
declare <1 x i8> @llvm.colossus.SDAG.unary.v1i8.v2i4(i32, <2 x i4>)
declare <1 x i10> @llvm.colossus.SDAG.unary.v1i10.v2i5(i32, <2 x i5>)
declare <1 x i12> @llvm.colossus.SDAG.unary.v1i12.v2i6(i32, <2 x i6>)
declare <1 x i14> @llvm.colossus.SDAG.unary.v1i14.v2i7(i32, <2 x i7>)
declare <1 x i16> @llvm.colossus.SDAG.unary.v1i16.v2i8(i32, <2 x i8>)
declare <1 x i18> @llvm.colossus.SDAG.unary.v1i18.v2i9(i32, <2 x i9>)
declare <1 x i20> @llvm.colossus.SDAG.unary.v1i20.v2i10(i32, <2 x i10>)
declare <1 x i22> @llvm.colossus.SDAG.unary.v1i22.v2i11(i32, <2 x i11>)
declare <1 x i24> @llvm.colossus.SDAG.unary.v1i24.v2i12(i32, <2 x i12>)
declare <1 x i26> @llvm.colossus.SDAG.unary.v1i26.v2i13(i32, <2 x i13>)
declare <1 x i28> @llvm.colossus.SDAG.unary.v1i28.v2i14(i32, <2 x i14>)
declare <1 x i30> @llvm.colossus.SDAG.unary.v1i30.v2i15(i32, <2 x i15>)
declare <1 x i32> @llvm.colossus.SDAG.unary.v1i32.v2i16(i32, <2 x i16>)
declare <1 x i34> @llvm.colossus.SDAG.unary.v1i34.v2i17(i32, <2 x i17>)
declare <1 x i36> @llvm.colossus.SDAG.unary.v1i36.v2i18(i32, <2 x i18>)
declare <1 x i38> @llvm.colossus.SDAG.unary.v1i38.v2i19(i32, <2 x i19>)
declare <1 x i40> @llvm.colossus.SDAG.unary.v1i40.v2i20(i32, <2 x i20>)
declare <1 x i42> @llvm.colossus.SDAG.unary.v1i42.v2i21(i32, <2 x i21>)
declare <1 x i44> @llvm.colossus.SDAG.unary.v1i44.v2i22(i32, <2 x i22>)
declare <1 x i46> @llvm.colossus.SDAG.unary.v1i46.v2i23(i32, <2 x i23>)
declare <1 x i48> @llvm.colossus.SDAG.unary.v1i48.v2i24(i32, <2 x i24>)
declare <1 x i50> @llvm.colossus.SDAG.unary.v1i50.v2i25(i32, <2 x i25>)
declare <1 x i52> @llvm.colossus.SDAG.unary.v1i52.v2i26(i32, <2 x i26>)
declare <1 x i54> @llvm.colossus.SDAG.unary.v1i54.v2i27(i32, <2 x i27>)
declare <1 x i56> @llvm.colossus.SDAG.unary.v1i56.v2i28(i32, <2 x i28>)
declare <1 x i58> @llvm.colossus.SDAG.unary.v1i58.v2i29(i32, <2 x i29>)
declare <1 x i60> @llvm.colossus.SDAG.unary.v1i60.v2i30(i32, <2 x i30>)
declare <1 x i62> @llvm.colossus.SDAG.unary.v1i62.v2i31(i32, <2 x i31>)
declare <1 x i64> @llvm.colossus.SDAG.unary.v1i64.v2i32(i32, <2 x i32>)
declare <1 x i3> @llvm.colossus.SDAG.unary.v1i3.v3i1(i32, <3 x i1>)
declare <1 x i6> @llvm.colossus.SDAG.unary.v1i6.v3i2(i32, <3 x i2>)
declare <2 x i3> @llvm.colossus.SDAG.unary.v2i3.v3i2(i32, <3 x i2>)
declare <1 x i9> @llvm.colossus.SDAG.unary.v1i9.v3i3(i32, <3 x i3>)
declare <1 x i12> @llvm.colossus.SDAG.unary.v1i12.v3i4(i32, <3 x i4>)
declare <2 x i6> @llvm.colossus.SDAG.unary.v2i6.v3i4(i32, <3 x i4>)
declare <1 x i15> @llvm.colossus.SDAG.unary.v1i15.v3i5(i32, <3 x i5>)
declare <1 x i18> @llvm.colossus.SDAG.unary.v1i18.v3i6(i32, <3 x i6>)
declare <2 x i9> @llvm.colossus.SDAG.unary.v2i9.v3i6(i32, <3 x i6>)
declare <1 x i21> @llvm.colossus.SDAG.unary.v1i21.v3i7(i32, <3 x i7>)
declare <1 x i24> @llvm.colossus.SDAG.unary.v1i24.v3i8(i32, <3 x i8>)
declare <2 x i12> @llvm.colossus.SDAG.unary.v2i12.v3i8(i32, <3 x i8>)
declare <1 x i27> @llvm.colossus.SDAG.unary.v1i27.v3i9(i32, <3 x i9>)
declare <1 x i30> @llvm.colossus.SDAG.unary.v1i30.v3i10(i32, <3 x i10>)
declare <2 x i15> @llvm.colossus.SDAG.unary.v2i15.v3i10(i32, <3 x i10>)
declare <1 x i33> @llvm.colossus.SDAG.unary.v1i33.v3i11(i32, <3 x i11>)
declare <1 x i36> @llvm.colossus.SDAG.unary.v1i36.v3i12(i32, <3 x i12>)
declare <2 x i18> @llvm.colossus.SDAG.unary.v2i18.v3i12(i32, <3 x i12>)
declare <1 x i39> @llvm.colossus.SDAG.unary.v1i39.v3i13(i32, <3 x i13>)
declare <1 x i42> @llvm.colossus.SDAG.unary.v1i42.v3i14(i32, <3 x i14>)
declare <2 x i21> @llvm.colossus.SDAG.unary.v2i21.v3i14(i32, <3 x i14>)
declare <1 x i45> @llvm.colossus.SDAG.unary.v1i45.v3i15(i32, <3 x i15>)
declare <1 x i48> @llvm.colossus.SDAG.unary.v1i48.v3i16(i32, <3 x i16>)
declare <2 x i24> @llvm.colossus.SDAG.unary.v2i24.v3i16(i32, <3 x i16>)
declare <1 x i51> @llvm.colossus.SDAG.unary.v1i51.v3i17(i32, <3 x i17>)
declare <1 x i54> @llvm.colossus.SDAG.unary.v1i54.v3i18(i32, <3 x i18>)
declare <2 x i27> @llvm.colossus.SDAG.unary.v2i27.v3i18(i32, <3 x i18>)
declare <1 x i57> @llvm.colossus.SDAG.unary.v1i57.v3i19(i32, <3 x i19>)
declare <1 x i60> @llvm.colossus.SDAG.unary.v1i60.v3i20(i32, <3 x i20>)
declare <2 x i30> @llvm.colossus.SDAG.unary.v2i30.v3i20(i32, <3 x i20>)
declare <1 x i63> @llvm.colossus.SDAG.unary.v1i63.v3i21(i32, <3 x i21>)
declare <2 x i33> @llvm.colossus.SDAG.unary.v2i33.v3i22(i32, <3 x i22>)
declare <2 x i36> @llvm.colossus.SDAG.unary.v2i36.v3i24(i32, <3 x i24>)
declare <2 x i39> @llvm.colossus.SDAG.unary.v2i39.v3i26(i32, <3 x i26>)
declare <2 x i42> @llvm.colossus.SDAG.unary.v2i42.v3i28(i32, <3 x i28>)
declare <2 x i45> @llvm.colossus.SDAG.unary.v2i45.v3i30(i32, <3 x i30>)
declare <2 x i48> @llvm.colossus.SDAG.unary.v2i48.v3i32(i32, <3 x i32>)
declare <2 x i51> @llvm.colossus.SDAG.unary.v2i51.v3i34(i32, <3 x i34>)
declare <2 x i54> @llvm.colossus.SDAG.unary.v2i54.v3i36(i32, <3 x i36>)
declare <2 x i57> @llvm.colossus.SDAG.unary.v2i57.v3i38(i32, <3 x i38>)
declare <2 x i60> @llvm.colossus.SDAG.unary.v2i60.v3i40(i32, <3 x i40>)
declare <2 x i63> @llvm.colossus.SDAG.unary.v2i63.v3i42(i32, <3 x i42>)
declare <1 x i4> @llvm.colossus.SDAG.unary.v1i4.v4i1(i32, <4 x i1>)
declare <2 x i2> @llvm.colossus.SDAG.unary.v2i2.v4i1(i32, <4 x i1>)
declare <1 x i8> @llvm.colossus.SDAG.unary.v1i8.v4i2(i32, <4 x i2>)
declare <2 x i4> @llvm.colossus.SDAG.unary.v2i4.v4i2(i32, <4 x i2>)
declare <1 x i12> @llvm.colossus.SDAG.unary.v1i12.v4i3(i32, <4 x i3>)
declare <2 x i6> @llvm.colossus.SDAG.unary.v2i6.v4i3(i32, <4 x i3>)
declare <3 x i4> @llvm.colossus.SDAG.unary.v3i4.v4i3(i32, <4 x i3>)
declare <1 x i16> @llvm.colossus.SDAG.unary.v1i16.v4i4(i32, <4 x i4>)
declare <2 x i8> @llvm.colossus.SDAG.unary.v2i8.v4i4(i32, <4 x i4>)
declare <1 x i20> @llvm.colossus.SDAG.unary.v1i20.v4i5(i32, <4 x i5>)
declare <2 x i10> @llvm.colossus.SDAG.unary.v2i10.v4i5(i32, <4 x i5>)
declare <1 x i24> @llvm.colossus.SDAG.unary.v1i24.v4i6(i32, <4 x i6>)
declare <2 x i12> @llvm.colossus.SDAG.unary.v2i12.v4i6(i32, <4 x i6>)
declare <3 x i8> @llvm.colossus.SDAG.unary.v3i8.v4i6(i32, <4 x i6>)
declare <1 x i28> @llvm.colossus.SDAG.unary.v1i28.v4i7(i32, <4 x i7>)
declare <2 x i14> @llvm.colossus.SDAG.unary.v2i14.v4i7(i32, <4 x i7>)
declare <1 x i32> @llvm.colossus.SDAG.unary.v1i32.v4i8(i32, <4 x i8>)
declare <2 x i16> @llvm.colossus.SDAG.unary.v2i16.v4i8(i32, <4 x i8>)
declare <1 x i36> @llvm.colossus.SDAG.unary.v1i36.v4i9(i32, <4 x i9>)
declare <2 x i18> @llvm.colossus.SDAG.unary.v2i18.v4i9(i32, <4 x i9>)
declare <3 x i12> @llvm.colossus.SDAG.unary.v3i12.v4i9(i32, <4 x i9>)
declare <1 x i40> @llvm.colossus.SDAG.unary.v1i40.v4i10(i32, <4 x i10>)
declare <2 x i20> @llvm.colossus.SDAG.unary.v2i20.v4i10(i32, <4 x i10>)
declare <1 x i44> @llvm.colossus.SDAG.unary.v1i44.v4i11(i32, <4 x i11>)
declare <2 x i22> @llvm.colossus.SDAG.unary.v2i22.v4i11(i32, <4 x i11>)
declare <1 x i48> @llvm.colossus.SDAG.unary.v1i48.v4i12(i32, <4 x i12>)
declare <2 x i24> @llvm.colossus.SDAG.unary.v2i24.v4i12(i32, <4 x i12>)
declare <3 x i16> @llvm.colossus.SDAG.unary.v3i16.v4i12(i32, <4 x i12>)
declare <1 x i52> @llvm.colossus.SDAG.unary.v1i52.v4i13(i32, <4 x i13>)
declare <2 x i26> @llvm.colossus.SDAG.unary.v2i26.v4i13(i32, <4 x i13>)
declare <1 x i56> @llvm.colossus.SDAG.unary.v1i56.v4i14(i32, <4 x i14>)
declare <2 x i28> @llvm.colossus.SDAG.unary.v2i28.v4i14(i32, <4 x i14>)
declare <1 x i60> @llvm.colossus.SDAG.unary.v1i60.v4i15(i32, <4 x i15>)
declare <2 x i30> @llvm.colossus.SDAG.unary.v2i30.v4i15(i32, <4 x i15>)
declare <3 x i20> @llvm.colossus.SDAG.unary.v3i20.v4i15(i32, <4 x i15>)
declare <1 x i64> @llvm.colossus.SDAG.unary.v1i64.v4i16(i32, <4 x i16>)
declare <2 x i32> @llvm.colossus.SDAG.unary.v2i32.v4i16(i32, <4 x i16>)
declare <2 x i34> @llvm.colossus.SDAG.unary.v2i34.v4i17(i32, <4 x i17>)
declare <2 x i36> @llvm.colossus.SDAG.unary.v2i36.v4i18(i32, <4 x i18>)
declare <3 x i24> @llvm.colossus.SDAG.unary.v3i24.v4i18(i32, <4 x i18>)
declare <2 x i38> @llvm.colossus.SDAG.unary.v2i38.v4i19(i32, <4 x i19>)
declare <2 x i40> @llvm.colossus.SDAG.unary.v2i40.v4i20(i32, <4 x i20>)
declare <2 x i42> @llvm.colossus.SDAG.unary.v2i42.v4i21(i32, <4 x i21>)
declare <3 x i28> @llvm.colossus.SDAG.unary.v3i28.v4i21(i32, <4 x i21>)
declare <2 x i44> @llvm.colossus.SDAG.unary.v2i44.v4i22(i32, <4 x i22>)
declare <2 x i46> @llvm.colossus.SDAG.unary.v2i46.v4i23(i32, <4 x i23>)
declare <2 x i48> @llvm.colossus.SDAG.unary.v2i48.v4i24(i32, <4 x i24>)
declare <3 x i32> @llvm.colossus.SDAG.unary.v3i32.v4i24(i32, <4 x i24>)
declare <2 x i50> @llvm.colossus.SDAG.unary.v2i50.v4i25(i32, <4 x i25>)
declare <2 x i52> @llvm.colossus.SDAG.unary.v2i52.v4i26(i32, <4 x i26>)
declare <2 x i54> @llvm.colossus.SDAG.unary.v2i54.v4i27(i32, <4 x i27>)
declare <3 x i36> @llvm.colossus.SDAG.unary.v3i36.v4i27(i32, <4 x i27>)
declare <2 x i56> @llvm.colossus.SDAG.unary.v2i56.v4i28(i32, <4 x i28>)
declare <2 x i58> @llvm.colossus.SDAG.unary.v2i58.v4i29(i32, <4 x i29>)
declare <2 x i60> @llvm.colossus.SDAG.unary.v2i60.v4i30(i32, <4 x i30>)
declare <3 x i40> @llvm.colossus.SDAG.unary.v3i40.v4i30(i32, <4 x i30>)
declare <2 x i62> @llvm.colossus.SDAG.unary.v2i62.v4i31(i32, <4 x i31>)
declare <2 x i64> @llvm.colossus.SDAG.unary.v2i64.v4i32(i32, <4 x i32>)
declare <3 x i44> @llvm.colossus.SDAG.unary.v3i44.v4i33(i32, <4 x i33>)
declare <3 x i48> @llvm.colossus.SDAG.unary.v3i48.v4i36(i32, <4 x i36>)
declare <3 x i52> @llvm.colossus.SDAG.unary.v3i52.v4i39(i32, <4 x i39>)
declare <3 x i56> @llvm.colossus.SDAG.unary.v3i56.v4i42(i32, <4 x i42>)
declare <3 x i60> @llvm.colossus.SDAG.unary.v3i60.v4i45(i32, <4 x i45>)
declare <3 x i64> @llvm.colossus.SDAG.unary.v3i64.v4i48(i32, <4 x i48>)
declare <1 x i5> @llvm.colossus.SDAG.unary.v1i5.v5i1(i32, <5 x i1>)
declare <1 x i10> @llvm.colossus.SDAG.unary.v1i10.v5i2(i32, <5 x i2>)
declare <2 x i5> @llvm.colossus.SDAG.unary.v2i5.v5i2(i32, <5 x i2>)
declare <1 x i15> @llvm.colossus.SDAG.unary.v1i15.v5i3(i32, <5 x i3>)
declare <3 x i5> @llvm.colossus.SDAG.unary.v3i5.v5i3(i32, <5 x i3>)
declare <1 x i20> @llvm.colossus.SDAG.unary.v1i20.v5i4(i32, <5 x i4>)
declare <2 x i10> @llvm.colossus.SDAG.unary.v2i10.v5i4(i32, <5 x i4>)
declare <4 x i5> @llvm.colossus.SDAG.unary.v4i5.v5i4(i32, <5 x i4>)
declare <1 x i25> @llvm.colossus.SDAG.unary.v1i25.v5i5(i32, <5 x i5>)
declare <1 x i30> @llvm.colossus.SDAG.unary.v1i30.v5i6(i32, <5 x i6>)
declare <2 x i15> @llvm.colossus.SDAG.unary.v2i15.v5i6(i32, <5 x i6>)
declare <3 x i10> @llvm.colossus.SDAG.unary.v3i10.v5i6(i32, <5 x i6>)
declare <1 x i35> @llvm.colossus.SDAG.unary.v1i35.v5i7(i32, <5 x i7>)
declare <1 x i40> @llvm.colossus.SDAG.unary.v1i40.v5i8(i32, <5 x i8>)
declare <2 x i20> @llvm.colossus.SDAG.unary.v2i20.v5i8(i32, <5 x i8>)
declare <4 x i10> @llvm.colossus.SDAG.unary.v4i10.v5i8(i32, <5 x i8>)
declare <1 x i45> @llvm.colossus.SDAG.unary.v1i45.v5i9(i32, <5 x i9>)
declare <3 x i15> @llvm.colossus.SDAG.unary.v3i15.v5i9(i32, <5 x i9>)
declare <1 x i50> @llvm.colossus.SDAG.unary.v1i50.v5i10(i32, <5 x i10>)
declare <2 x i25> @llvm.colossus.SDAG.unary.v2i25.v5i10(i32, <5 x i10>)
declare <1 x i55> @llvm.colossus.SDAG.unary.v1i55.v5i11(i32, <5 x i11>)
declare <1 x i60> @llvm.colossus.SDAG.unary.v1i60.v5i12(i32, <5 x i12>)
declare <2 x i30> @llvm.colossus.SDAG.unary.v2i30.v5i12(i32, <5 x i12>)
declare <3 x i20> @llvm.colossus.SDAG.unary.v3i20.v5i12(i32, <5 x i12>)
declare <4 x i15> @llvm.colossus.SDAG.unary.v4i15.v5i12(i32, <5 x i12>)
declare <2 x i35> @llvm.colossus.SDAG.unary.v2i35.v5i14(i32, <5 x i14>)
declare <3 x i25> @llvm.colossus.SDAG.unary.v3i25.v5i15(i32, <5 x i15>)
declare <2 x i40> @llvm.colossus.SDAG.unary.v2i40.v5i16(i32, <5 x i16>)
declare <4 x i20> @llvm.colossus.SDAG.unary.v4i20.v5i16(i32, <5 x i16>)
declare <2 x i45> @llvm.colossus.SDAG.unary.v2i45.v5i18(i32, <5 x i18>)
declare <3 x i30> @llvm.colossus.SDAG.unary.v3i30.v5i18(i32, <5 x i18>)
declare <2 x i50> @llvm.colossus.SDAG.unary.v2i50.v5i20(i32, <5 x i20>)
declare <4 x i25> @llvm.colossus.SDAG.unary.v4i25.v5i20(i32, <5 x i20>)
declare <3 x i35> @llvm.colossus.SDAG.unary.v3i35.v5i21(i32, <5 x i21>)
declare <2 x i55> @llvm.colossus.SDAG.unary.v2i55.v5i22(i32, <5 x i22>)
declare <2 x i60> @llvm.colossus.SDAG.unary.v2i60.v5i24(i32, <5 x i24>)
declare <3 x i40> @llvm.colossus.SDAG.unary.v3i40.v5i24(i32, <5 x i24>)
declare <4 x i30> @llvm.colossus.SDAG.unary.v4i30.v5i24(i32, <5 x i24>)
declare <3 x i45> @llvm.colossus.SDAG.unary.v3i45.v5i27(i32, <5 x i27>)
declare <4 x i35> @llvm.colossus.SDAG.unary.v4i35.v5i28(i32, <5 x i28>)
declare <3 x i50> @llvm.colossus.SDAG.unary.v3i50.v5i30(i32, <5 x i30>)
declare <4 x i40> @llvm.colossus.SDAG.unary.v4i40.v5i32(i32, <5 x i32>)
declare <3 x i55> @llvm.colossus.SDAG.unary.v3i55.v5i33(i32, <5 x i33>)
declare <3 x i60> @llvm.colossus.SDAG.unary.v3i60.v5i36(i32, <5 x i36>)
declare <4 x i45> @llvm.colossus.SDAG.unary.v4i45.v5i36(i32, <5 x i36>)
declare <4 x i50> @llvm.colossus.SDAG.unary.v4i50.v5i40(i32, <5 x i40>)
declare <4 x i55> @llvm.colossus.SDAG.unary.v4i55.v5i44(i32, <5 x i44>)
declare <4 x i60> @llvm.colossus.SDAG.unary.v4i60.v5i48(i32, <5 x i48>)
declare <1 x i6> @llvm.colossus.SDAG.unary.v1i6.v6i1(i32, <6 x i1>)
declare <2 x i3> @llvm.colossus.SDAG.unary.v2i3.v6i1(i32, <6 x i1>)
declare <3 x i2> @llvm.colossus.SDAG.unary.v3i2.v6i1(i32, <6 x i1>)
declare <1 x i12> @llvm.colossus.SDAG.unary.v1i12.v6i2(i32, <6 x i2>)
declare <2 x i6> @llvm.colossus.SDAG.unary.v2i6.v6i2(i32, <6 x i2>)
declare <3 x i4> @llvm.colossus.SDAG.unary.v3i4.v6i2(i32, <6 x i2>)
declare <4 x i3> @llvm.colossus.SDAG.unary.v4i3.v6i2(i32, <6 x i2>)
declare <1 x i18> @llvm.colossus.SDAG.unary.v1i18.v6i3(i32, <6 x i3>)
declare <2 x i9> @llvm.colossus.SDAG.unary.v2i9.v6i3(i32, <6 x i3>)
declare <3 x i6> @llvm.colossus.SDAG.unary.v3i6.v6i3(i32, <6 x i3>)
declare <1 x i24> @llvm.colossus.SDAG.unary.v1i24.v6i4(i32, <6 x i4>)
declare <2 x i12> @llvm.colossus.SDAG.unary.v2i12.v6i4(i32, <6 x i4>)
declare <3 x i8> @llvm.colossus.SDAG.unary.v3i8.v6i4(i32, <6 x i4>)
declare <4 x i6> @llvm.colossus.SDAG.unary.v4i6.v6i4(i32, <6 x i4>)
declare <1 x i30> @llvm.colossus.SDAG.unary.v1i30.v6i5(i32, <6 x i5>)
declare <2 x i15> @llvm.colossus.SDAG.unary.v2i15.v6i5(i32, <6 x i5>)
declare <3 x i10> @llvm.colossus.SDAG.unary.v3i10.v6i5(i32, <6 x i5>)
declare <5 x i6> @llvm.colossus.SDAG.unary.v5i6.v6i5(i32, <6 x i5>)
declare <1 x i36> @llvm.colossus.SDAG.unary.v1i36.v6i6(i32, <6 x i6>)
declare <2 x i18> @llvm.colossus.SDAG.unary.v2i18.v6i6(i32, <6 x i6>)
declare <3 x i12> @llvm.colossus.SDAG.unary.v3i12.v6i6(i32, <6 x i6>)
declare <4 x i9> @llvm.colossus.SDAG.unary.v4i9.v6i6(i32, <6 x i6>)
declare <1 x i42> @llvm.colossus.SDAG.unary.v1i42.v6i7(i32, <6 x i7>)
declare <2 x i21> @llvm.colossus.SDAG.unary.v2i21.v6i7(i32, <6 x i7>)
declare <3 x i14> @llvm.colossus.SDAG.unary.v3i14.v6i7(i32, <6 x i7>)
declare <1 x i48> @llvm.colossus.SDAG.unary.v1i48.v6i8(i32, <6 x i8>)
declare <2 x i24> @llvm.colossus.SDAG.unary.v2i24.v6i8(i32, <6 x i8>)
declare <3 x i16> @llvm.colossus.SDAG.unary.v3i16.v6i8(i32, <6 x i8>)
declare <4 x i12> @llvm.colossus.SDAG.unary.v4i12.v6i8(i32, <6 x i8>)
declare <1 x i54> @llvm.colossus.SDAG.unary.v1i54.v6i9(i32, <6 x i9>)
declare <2 x i27> @llvm.colossus.SDAG.unary.v2i27.v6i9(i32, <6 x i9>)
declare <3 x i18> @llvm.colossus.SDAG.unary.v3i18.v6i9(i32, <6 x i9>)
declare <1 x i60> @llvm.colossus.SDAG.unary.v1i60.v6i10(i32, <6 x i10>)
declare <2 x i30> @llvm.colossus.SDAG.unary.v2i30.v6i10(i32, <6 x i10>)
declare <3 x i20> @llvm.colossus.SDAG.unary.v3i20.v6i10(i32, <6 x i10>)
declare <4 x i15> @llvm.colossus.SDAG.unary.v4i15.v6i10(i32, <6 x i10>)
declare <5 x i12> @llvm.colossus.SDAG.unary.v5i12.v6i10(i32, <6 x i10>)
declare <2 x i33> @llvm.colossus.SDAG.unary.v2i33.v6i11(i32, <6 x i11>)
declare <3 x i22> @llvm.colossus.SDAG.unary.v3i22.v6i11(i32, <6 x i11>)
declare <2 x i36> @llvm.colossus.SDAG.unary.v2i36.v6i12(i32, <6 x i12>)
declare <3 x i24> @llvm.colossus.SDAG.unary.v3i24.v6i12(i32, <6 x i12>)
declare <4 x i18> @llvm.colossus.SDAG.unary.v4i18.v6i12(i32, <6 x i12>)
declare <2 x i39> @llvm.colossus.SDAG.unary.v2i39.v6i13(i32, <6 x i13>)
declare <3 x i26> @llvm.colossus.SDAG.unary.v3i26.v6i13(i32, <6 x i13>)
declare <2 x i42> @llvm.colossus.SDAG.unary.v2i42.v6i14(i32, <6 x i14>)
declare <3 x i28> @llvm.colossus.SDAG.unary.v3i28.v6i14(i32, <6 x i14>)
declare <4 x i21> @llvm.colossus.SDAG.unary.v4i21.v6i14(i32, <6 x i14>)
declare <2 x i45> @llvm.colossus.SDAG.unary.v2i45.v6i15(i32, <6 x i15>)
declare <3 x i30> @llvm.colossus.SDAG.unary.v3i30.v6i15(i32, <6 x i15>)
declare <5 x i18> @llvm.colossus.SDAG.unary.v5i18.v6i15(i32, <6 x i15>)
declare <2 x i48> @llvm.colossus.SDAG.unary.v2i48.v6i16(i32, <6 x i16>)
declare <3 x i32> @llvm.colossus.SDAG.unary.v3i32.v6i16(i32, <6 x i16>)
declare <4 x i24> @llvm.colossus.SDAG.unary.v4i24.v6i16(i32, <6 x i16>)
declare <2 x i51> @llvm.colossus.SDAG.unary.v2i51.v6i17(i32, <6 x i17>)
declare <3 x i34> @llvm.colossus.SDAG.unary.v3i34.v6i17(i32, <6 x i17>)
declare <2 x i54> @llvm.colossus.SDAG.unary.v2i54.v6i18(i32, <6 x i18>)
declare <3 x i36> @llvm.colossus.SDAG.unary.v3i36.v6i18(i32, <6 x i18>)
declare <4 x i27> @llvm.colossus.SDAG.unary.v4i27.v6i18(i32, <6 x i18>)
declare <2 x i57> @llvm.colossus.SDAG.unary.v2i57.v6i19(i32, <6 x i19>)
declare <3 x i38> @llvm.colossus.SDAG.unary.v3i38.v6i19(i32, <6 x i19>)
declare <2 x i60> @llvm.colossus.SDAG.unary.v2i60.v6i20(i32, <6 x i20>)
declare <3 x i40> @llvm.colossus.SDAG.unary.v3i40.v6i20(i32, <6 x i20>)
declare <4 x i30> @llvm.colossus.SDAG.unary.v4i30.v6i20(i32, <6 x i20>)
declare <5 x i24> @llvm.colossus.SDAG.unary.v5i24.v6i20(i32, <6 x i20>)
declare <2 x i63> @llvm.colossus.SDAG.unary.v2i63.v6i21(i32, <6 x i21>)
declare <3 x i42> @llvm.colossus.SDAG.unary.v3i42.v6i21(i32, <6 x i21>)
declare <3 x i44> @llvm.colossus.SDAG.unary.v3i44.v6i22(i32, <6 x i22>)
declare <4 x i33> @llvm.colossus.SDAG.unary.v4i33.v6i22(i32, <6 x i22>)
declare <3 x i46> @llvm.colossus.SDAG.unary.v3i46.v6i23(i32, <6 x i23>)
declare <3 x i48> @llvm.colossus.SDAG.unary.v3i48.v6i24(i32, <6 x i24>)
declare <4 x i36> @llvm.colossus.SDAG.unary.v4i36.v6i24(i32, <6 x i24>)
declare <3 x i50> @llvm.colossus.SDAG.unary.v3i50.v6i25(i32, <6 x i25>)
declare <5 x i30> @llvm.colossus.SDAG.unary.v5i30.v6i25(i32, <6 x i25>)
declare <3 x i52> @llvm.colossus.SDAG.unary.v3i52.v6i26(i32, <6 x i26>)
declare <4 x i39> @llvm.colossus.SDAG.unary.v4i39.v6i26(i32, <6 x i26>)
declare <3 x i54> @llvm.colossus.SDAG.unary.v3i54.v6i27(i32, <6 x i27>)
declare <3 x i56> @llvm.colossus.SDAG.unary.v3i56.v6i28(i32, <6 x i28>)
declare <4 x i42> @llvm.colossus.SDAG.unary.v4i42.v6i28(i32, <6 x i28>)
declare <3 x i58> @llvm.colossus.SDAG.unary.v3i58.v6i29(i32, <6 x i29>)
declare <3 x i60> @llvm.colossus.SDAG.unary.v3i60.v6i30(i32, <6 x i30>)
declare <4 x i45> @llvm.colossus.SDAG.unary.v4i45.v6i30(i32, <6 x i30>)
declare <5 x i36> @llvm.colossus.SDAG.unary.v5i36.v6i30(i32, <6 x i30>)
declare <3 x i62> @llvm.colossus.SDAG.unary.v3i62.v6i31(i32, <6 x i31>)
declare <3 x i64> @llvm.colossus.SDAG.unary.v3i64.v6i32(i32, <6 x i32>)
declare <4 x i48> @llvm.colossus.SDAG.unary.v4i48.v6i32(i32, <6 x i32>)
declare <4 x i51> @llvm.colossus.SDAG.unary.v4i51.v6i34(i32, <6 x i34>)
declare <5 x i42> @llvm.colossus.SDAG.unary.v5i42.v6i35(i32, <6 x i35>)
declare <4 x i54> @llvm.colossus.SDAG.unary.v4i54.v6i36(i32, <6 x i36>)
declare <4 x i57> @llvm.colossus.SDAG.unary.v4i57.v6i38(i32, <6 x i38>)
declare <4 x i60> @llvm.colossus.SDAG.unary.v4i60.v6i40(i32, <6 x i40>)
declare <5 x i48> @llvm.colossus.SDAG.unary.v5i48.v6i40(i32, <6 x i40>)
declare <4 x i63> @llvm.colossus.SDAG.unary.v4i63.v6i42(i32, <6 x i42>)
declare <5 x i54> @llvm.colossus.SDAG.unary.v5i54.v6i45(i32, <6 x i45>)
declare <5 x i60> @llvm.colossus.SDAG.unary.v5i60.v6i50(i32, <6 x i50>)
declare <1 x i7> @llvm.colossus.SDAG.unary.v1i7.v7i1(i32, <7 x i1>)
declare <1 x i14> @llvm.colossus.SDAG.unary.v1i14.v7i2(i32, <7 x i2>)
declare <2 x i7> @llvm.colossus.SDAG.unary.v2i7.v7i2(i32, <7 x i2>)
declare <1 x i21> @llvm.colossus.SDAG.unary.v1i21.v7i3(i32, <7 x i3>)
declare <3 x i7> @llvm.colossus.SDAG.unary.v3i7.v7i3(i32, <7 x i3>)
declare <1 x i28> @llvm.colossus.SDAG.unary.v1i28.v7i4(i32, <7 x i4>)
declare <2 x i14> @llvm.colossus.SDAG.unary.v2i14.v7i4(i32, <7 x i4>)
declare <4 x i7> @llvm.colossus.SDAG.unary.v4i7.v7i4(i32, <7 x i4>)
declare <1 x i35> @llvm.colossus.SDAG.unary.v1i35.v7i5(i32, <7 x i5>)
declare <5 x i7> @llvm.colossus.SDAG.unary.v5i7.v7i5(i32, <7 x i5>)
declare <1 x i42> @llvm.colossus.SDAG.unary.v1i42.v7i6(i32, <7 x i6>)
declare <2 x i21> @llvm.colossus.SDAG.unary.v2i21.v7i6(i32, <7 x i6>)
declare <3 x i14> @llvm.colossus.SDAG.unary.v3i14.v7i6(i32, <7 x i6>)
declare <6 x i7> @llvm.colossus.SDAG.unary.v6i7.v7i6(i32, <7 x i6>)
declare <1 x i49> @llvm.colossus.SDAG.unary.v1i49.v7i7(i32, <7 x i7>)
declare <1 x i56> @llvm.colossus.SDAG.unary.v1i56.v7i8(i32, <7 x i8>)
declare <2 x i28> @llvm.colossus.SDAG.unary.v2i28.v7i8(i32, <7 x i8>)
declare <4 x i14> @llvm.colossus.SDAG.unary.v4i14.v7i8(i32, <7 x i8>)
declare <1 x i63> @llvm.colossus.SDAG.unary.v1i63.v7i9(i32, <7 x i9>)
declare <3 x i21> @llvm.colossus.SDAG.unary.v3i21.v7i9(i32, <7 x i9>)
declare <2 x i35> @llvm.colossus.SDAG.unary.v2i35.v7i10(i32, <7 x i10>)
declare <5 x i14> @llvm.colossus.SDAG.unary.v5i14.v7i10(i32, <7 x i10>)
declare <2 x i42> @llvm.colossus.SDAG.unary.v2i42.v7i12(i32, <7 x i12>)
declare <3 x i28> @llvm.colossus.SDAG.unary.v3i28.v7i12(i32, <7 x i12>)
declare <4 x i21> @llvm.colossus.SDAG.unary.v4i21.v7i12(i32, <7 x i12>)
declare <6 x i14> @llvm.colossus.SDAG.unary.v6i14.v7i12(i32, <7 x i12>)
declare <2 x i49> @llvm.colossus.SDAG.unary.v2i49.v7i14(i32, <7 x i14>)
declare <3 x i35> @llvm.colossus.SDAG.unary.v3i35.v7i15(i32, <7 x i15>)
declare <5 x i21> @llvm.colossus.SDAG.unary.v5i21.v7i15(i32, <7 x i15>)
declare <2 x i56> @llvm.colossus.SDAG.unary.v2i56.v7i16(i32, <7 x i16>)
declare <4 x i28> @llvm.colossus.SDAG.unary.v4i28.v7i16(i32, <7 x i16>)
declare <2 x i63> @llvm.colossus.SDAG.unary.v2i63.v7i18(i32, <7 x i18>)
declare <3 x i42> @llvm.colossus.SDAG.unary.v3i42.v7i18(i32, <7 x i18>)
declare <6 x i21> @llvm.colossus.SDAG.unary.v6i21.v7i18(i32, <7 x i18>)
declare <4 x i35> @llvm.colossus.SDAG.unary.v4i35.v7i20(i32, <7 x i20>)
declare <5 x i28> @llvm.colossus.SDAG.unary.v5i28.v7i20(i32, <7 x i20>)
declare <3 x i49> @llvm.colossus.SDAG.unary.v3i49.v7i21(i32, <7 x i21>)
declare <3 x i56> @llvm.colossus.SDAG.unary.v3i56.v7i24(i32, <7 x i24>)
declare <4 x i42> @llvm.colossus.SDAG.unary.v4i42.v7i24(i32, <7 x i24>)
declare <6 x i28> @llvm.colossus.SDAG.unary.v6i28.v7i24(i32, <7 x i24>)
declare <5 x i35> @llvm.colossus.SDAG.unary.v5i35.v7i25(i32, <7 x i25>)
declare <3 x i63> @llvm.colossus.SDAG.unary.v3i63.v7i27(i32, <7 x i27>)
declare <4 x i49> @llvm.colossus.SDAG.unary.v4i49.v7i28(i32, <7 x i28>)
declare <5 x i42> @llvm.colossus.SDAG.unary.v5i42.v7i30(i32, <7 x i30>)
declare <6 x i35> @llvm.colossus.SDAG.unary.v6i35.v7i30(i32, <7 x i30>)
declare <4 x i56> @llvm.colossus.SDAG.unary.v4i56.v7i32(i32, <7 x i32>)
declare <5 x i49> @llvm.colossus.SDAG.unary.v5i49.v7i35(i32, <7 x i35>)
declare <4 x i63> @llvm.colossus.SDAG.unary.v4i63.v7i36(i32, <7 x i36>)
declare <6 x i42> @llvm.colossus.SDAG.unary.v6i42.v7i36(i32, <7 x i36>)
declare <5 x i56> @llvm.colossus.SDAG.unary.v5i56.v7i40(i32, <7 x i40>)
declare <6 x i49> @llvm.colossus.SDAG.unary.v6i49.v7i42(i32, <7 x i42>)
declare <5 x i63> @llvm.colossus.SDAG.unary.v5i63.v7i45(i32, <7 x i45>)
declare <6 x i56> @llvm.colossus.SDAG.unary.v6i56.v7i48(i32, <7 x i48>)
declare <6 x i63> @llvm.colossus.SDAG.unary.v6i63.v7i54(i32, <7 x i54>)
declare <1 x i8> @llvm.colossus.SDAG.unary.v1i8.v8i1(i32, <8 x i1>)
declare <2 x i4> @llvm.colossus.SDAG.unary.v2i4.v8i1(i32, <8 x i1>)
declare <4 x i2> @llvm.colossus.SDAG.unary.v4i2.v8i1(i32, <8 x i1>)
declare <1 x i16> @llvm.colossus.SDAG.unary.v1i16.v8i2(i32, <8 x i2>)
declare <2 x i8> @llvm.colossus.SDAG.unary.v2i8.v8i2(i32, <8 x i2>)
declare <4 x i4> @llvm.colossus.SDAG.unary.v4i4.v8i2(i32, <8 x i2>)
declare <1 x i24> @llvm.colossus.SDAG.unary.v1i24.v8i3(i32, <8 x i3>)
declare <2 x i12> @llvm.colossus.SDAG.unary.v2i12.v8i3(i32, <8 x i3>)
declare <3 x i8> @llvm.colossus.SDAG.unary.v3i8.v8i3(i32, <8 x i3>)
declare <4 x i6> @llvm.colossus.SDAG.unary.v4i6.v8i3(i32, <8 x i3>)
declare <6 x i4> @llvm.colossus.SDAG.unary.v6i4.v8i3(i32, <8 x i3>)
declare <1 x i32> @llvm.colossus.SDAG.unary.v1i32.v8i4(i32, <8 x i4>)
declare <2 x i16> @llvm.colossus.SDAG.unary.v2i16.v8i4(i32, <8 x i4>)
declare <4 x i8> @llvm.colossus.SDAG.unary.v4i8.v8i4(i32, <8 x i4>)
declare <1 x i40> @llvm.colossus.SDAG.unary.v1i40.v8i5(i32, <8 x i5>)
declare <2 x i20> @llvm.colossus.SDAG.unary.v2i20.v8i5(i32, <8 x i5>)
declare <4 x i10> @llvm.colossus.SDAG.unary.v4i10.v8i5(i32, <8 x i5>)
declare <5 x i8> @llvm.colossus.SDAG.unary.v5i8.v8i5(i32, <8 x i5>)
declare <1 x i48> @llvm.colossus.SDAG.unary.v1i48.v8i6(i32, <8 x i6>)
declare <2 x i24> @llvm.colossus.SDAG.unary.v2i24.v8i6(i32, <8 x i6>)
declare <3 x i16> @llvm.colossus.SDAG.unary.v3i16.v8i6(i32, <8 x i6>)
declare <4 x i12> @llvm.colossus.SDAG.unary.v4i12.v8i6(i32, <8 x i6>)
declare <6 x i8> @llvm.colossus.SDAG.unary.v6i8.v8i6(i32, <8 x i6>)
declare <1 x i56> @llvm.colossus.SDAG.unary.v1i56.v8i7(i32, <8 x i7>)
declare <2 x i28> @llvm.colossus.SDAG.unary.v2i28.v8i7(i32, <8 x i7>)
declare <4 x i14> @llvm.colossus.SDAG.unary.v4i14.v8i7(i32, <8 x i7>)
declare <7 x i8> @llvm.colossus.SDAG.unary.v7i8.v8i7(i32, <8 x i7>)
declare <1 x i64> @llvm.colossus.SDAG.unary.v1i64.v8i8(i32, <8 x i8>)
declare <2 x i32> @llvm.colossus.SDAG.unary.v2i32.v8i8(i32, <8 x i8>)
declare <4 x i16> @llvm.colossus.SDAG.unary.v4i16.v8i8(i32, <8 x i8>)
declare <2 x i36> @llvm.colossus.SDAG.unary.v2i36.v8i9(i32, <8 x i9>)
declare <3 x i24> @llvm.colossus.SDAG.unary.v3i24.v8i9(i32, <8 x i9>)
declare <4 x i18> @llvm.colossus.SDAG.unary.v4i18.v8i9(i32, <8 x i9>)
declare <6 x i12> @llvm.colossus.SDAG.unary.v6i12.v8i9(i32, <8 x i9>)
declare <2 x i40> @llvm.colossus.SDAG.unary.v2i40.v8i10(i32, <8 x i10>)
declare <4 x i20> @llvm.colossus.SDAG.unary.v4i20.v8i10(i32, <8 x i10>)
declare <5 x i16> @llvm.colossus.SDAG.unary.v5i16.v8i10(i32, <8 x i10>)
declare <2 x i44> @llvm.colossus.SDAG.unary.v2i44.v8i11(i32, <8 x i11>)
declare <4 x i22> @llvm.colossus.SDAG.unary.v4i22.v8i11(i32, <8 x i11>)
declare <2 x i48> @llvm.colossus.SDAG.unary.v2i48.v8i12(i32, <8 x i12>)
declare <3 x i32> @llvm.colossus.SDAG.unary.v3i32.v8i12(i32, <8 x i12>)
declare <4 x i24> @llvm.colossus.SDAG.unary.v4i24.v8i12(i32, <8 x i12>)
declare <6 x i16> @llvm.colossus.SDAG.unary.v6i16.v8i12(i32, <8 x i12>)
declare <2 x i52> @llvm.colossus.SDAG.unary.v2i52.v8i13(i32, <8 x i13>)
declare <4 x i26> @llvm.colossus.SDAG.unary.v4i26.v8i13(i32, <8 x i13>)
declare <2 x i56> @llvm.colossus.SDAG.unary.v2i56.v8i14(i32, <8 x i14>)
declare <4 x i28> @llvm.colossus.SDAG.unary.v4i28.v8i14(i32, <8 x i14>)
declare <7 x i16> @llvm.colossus.SDAG.unary.v7i16.v8i14(i32, <8 x i14>)
declare <2 x i60> @llvm.colossus.SDAG.unary.v2i60.v8i15(i32, <8 x i15>)
declare <3 x i40> @llvm.colossus.SDAG.unary.v3i40.v8i15(i32, <8 x i15>)
declare <4 x i30> @llvm.colossus.SDAG.unary.v4i30.v8i15(i32, <8 x i15>)
declare <5 x i24> @llvm.colossus.SDAG.unary.v5i24.v8i15(i32, <8 x i15>)
declare <6 x i20> @llvm.colossus.SDAG.unary.v6i20.v8i15(i32, <8 x i15>)
declare <2 x i64> @llvm.colossus.SDAG.unary.v2i64.v8i16(i32, <8 x i16>)
declare <4 x i32> @llvm.colossus.SDAG.unary.v4i32.v8i16(i32, <8 x i16>)
declare <4 x i34> @llvm.colossus.SDAG.unary.v4i34.v8i17(i32, <8 x i17>)
declare <3 x i48> @llvm.colossus.SDAG.unary.v3i48.v8i18(i32, <8 x i18>)
declare <4 x i36> @llvm.colossus.SDAG.unary.v4i36.v8i18(i32, <8 x i18>)
declare <6 x i24> @llvm.colossus.SDAG.unary.v6i24.v8i18(i32, <8 x i18>)
declare <4 x i38> @llvm.colossus.SDAG.unary.v4i38.v8i19(i32, <8 x i19>)
declare <4 x i40> @llvm.colossus.SDAG.unary.v4i40.v8i20(i32, <8 x i20>)
declare <5 x i32> @llvm.colossus.SDAG.unary.v5i32.v8i20(i32, <8 x i20>)
declare <3 x i56> @llvm.colossus.SDAG.unary.v3i56.v8i21(i32, <8 x i21>)
declare <4 x i42> @llvm.colossus.SDAG.unary.v4i42.v8i21(i32, <8 x i21>)
declare <6 x i28> @llvm.colossus.SDAG.unary.v6i28.v8i21(i32, <8 x i21>)
declare <7 x i24> @llvm.colossus.SDAG.unary.v7i24.v8i21(i32, <8 x i21>)
declare <4 x i44> @llvm.colossus.SDAG.unary.v4i44.v8i22(i32, <8 x i22>)
declare <4 x i46> @llvm.colossus.SDAG.unary.v4i46.v8i23(i32, <8 x i23>)
declare <3 x i64> @llvm.colossus.SDAG.unary.v3i64.v8i24(i32, <8 x i24>)
declare <4 x i48> @llvm.colossus.SDAG.unary.v4i48.v8i24(i32, <8 x i24>)
declare <6 x i32> @llvm.colossus.SDAG.unary.v6i32.v8i24(i32, <8 x i24>)
declare <4 x i50> @llvm.colossus.SDAG.unary.v4i50.v8i25(i32, <8 x i25>)
declare <5 x i40> @llvm.colossus.SDAG.unary.v5i40.v8i25(i32, <8 x i25>)
declare <4 x i52> @llvm.colossus.SDAG.unary.v4i52.v8i26(i32, <8 x i26>)
declare <4 x i54> @llvm.colossus.SDAG.unary.v4i54.v8i27(i32, <8 x i27>)
declare <6 x i36> @llvm.colossus.SDAG.unary.v6i36.v8i27(i32, <8 x i27>)
declare <4 x i56> @llvm.colossus.SDAG.unary.v4i56.v8i28(i32, <8 x i28>)
declare <7 x i32> @llvm.colossus.SDAG.unary.v7i32.v8i28(i32, <8 x i28>)
declare <4 x i58> @llvm.colossus.SDAG.unary.v4i58.v8i29(i32, <8 x i29>)
declare <4 x i60> @llvm.colossus.SDAG.unary.v4i60.v8i30(i32, <8 x i30>)
declare <5 x i48> @llvm.colossus.SDAG.unary.v5i48.v8i30(i32, <8 x i30>)
declare <6 x i40> @llvm.colossus.SDAG.unary.v6i40.v8i30(i32, <8 x i30>)
declare <4 x i62> @llvm.colossus.SDAG.unary.v4i62.v8i31(i32, <8 x i31>)
declare <4 x i64> @llvm.colossus.SDAG.unary.v4i64.v8i32(i32, <8 x i32>)
declare <6 x i44> @llvm.colossus.SDAG.unary.v6i44.v8i33(i32, <8 x i33>)
declare <5 x i56> @llvm.colossus.SDAG.unary.v5i56.v8i35(i32, <8 x i35>)
declare <7 x i40> @llvm.colossus.SDAG.unary.v7i40.v8i35(i32, <8 x i35>)
declare <6 x i48> @llvm.colossus.SDAG.unary.v6i48.v8i36(i32, <8 x i36>)
declare <6 x i52> @llvm.colossus.SDAG.unary.v6i52.v8i39(i32, <8 x i39>)
declare <5 x i64> @llvm.colossus.SDAG.unary.v5i64.v8i40(i32, <8 x i40>)
declare <6 x i56> @llvm.colossus.SDAG.unary.v6i56.v8i42(i32, <8 x i42>)
declare <7 x i48> @llvm.colossus.SDAG.unary.v7i48.v8i42(i32, <8 x i42>)
declare <6 x i60> @llvm.colossus.SDAG.unary.v6i60.v8i45(i32, <8 x i45>)
declare <6 x i64> @llvm.colossus.SDAG.unary.v6i64.v8i48(i32, <8 x i48>)
declare <7 x i56> @llvm.colossus.SDAG.unary.v7i56.v8i49(i32, <8 x i49>)
declare <7 x i64> @llvm.colossus.SDAG.unary.v7i64.v8i56(i32, <8 x i56>)

define <1 x i2> @any_extend_v2i1_to_v1i2(<2 x i1> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <1 x i2> @llvm.colossus.SDAG.unary.v1i2.v2i1(i32 %id, <2 x i1> %x)
  ret <1 x i2> %res
}

define <1 x i4> @any_extend_v2i2_to_v1i4(<2 x i2> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <1 x i4> @llvm.colossus.SDAG.unary.v1i4.v2i2(i32 %id, <2 x i2> %x)
  ret <1 x i4> %res
}

define <1 x i6> @any_extend_v2i3_to_v1i6(<2 x i3> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <1 x i6> @llvm.colossus.SDAG.unary.v1i6.v2i3(i32 %id, <2 x i3> %x)
  ret <1 x i6> %res
}

define <1 x i8> @any_extend_v2i4_to_v1i8(<2 x i4> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <1 x i8> @llvm.colossus.SDAG.unary.v1i8.v2i4(i32 %id, <2 x i4> %x)
  ret <1 x i8> %res
}

define <1 x i10> @any_extend_v2i5_to_v1i10(<2 x i5> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <1 x i10> @llvm.colossus.SDAG.unary.v1i10.v2i5(i32 %id, <2 x i5> %x)
  ret <1 x i10> %res
}

define <1 x i12> @any_extend_v2i6_to_v1i12(<2 x i6> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <1 x i12> @llvm.colossus.SDAG.unary.v1i12.v2i6(i32 %id, <2 x i6> %x)
  ret <1 x i12> %res
}

define <1 x i14> @any_extend_v2i7_to_v1i14(<2 x i7> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <1 x i14> @llvm.colossus.SDAG.unary.v1i14.v2i7(i32 %id, <2 x i7> %x)
  ret <1 x i14> %res
}

define <1 x i16> @any_extend_v2i8_to_v1i16(<2 x i8> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <1 x i16> @llvm.colossus.SDAG.unary.v1i16.v2i8(i32 %id, <2 x i8> %x)
  ret <1 x i16> %res
}

define <1 x i18> @any_extend_v2i9_to_v1i18(<2 x i9> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <1 x i18> @llvm.colossus.SDAG.unary.v1i18.v2i9(i32 %id, <2 x i9> %x)
  ret <1 x i18> %res
}

define <1 x i20> @any_extend_v2i10_to_v1i20(<2 x i10> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <1 x i20> @llvm.colossus.SDAG.unary.v1i20.v2i10(i32 %id, <2 x i10> %x)
  ret <1 x i20> %res
}

define <1 x i22> @any_extend_v2i11_to_v1i22(<2 x i11> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <1 x i22> @llvm.colossus.SDAG.unary.v1i22.v2i11(i32 %id, <2 x i11> %x)
  ret <1 x i22> %res
}

define <1 x i24> @any_extend_v2i12_to_v1i24(<2 x i12> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <1 x i24> @llvm.colossus.SDAG.unary.v1i24.v2i12(i32 %id, <2 x i12> %x)
  ret <1 x i24> %res
}

define <1 x i26> @any_extend_v2i13_to_v1i26(<2 x i13> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <1 x i26> @llvm.colossus.SDAG.unary.v1i26.v2i13(i32 %id, <2 x i13> %x)
  ret <1 x i26> %res
}

define <1 x i28> @any_extend_v2i14_to_v1i28(<2 x i14> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <1 x i28> @llvm.colossus.SDAG.unary.v1i28.v2i14(i32 %id, <2 x i14> %x)
  ret <1 x i28> %res
}

define <1 x i30> @any_extend_v2i15_to_v1i30(<2 x i15> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <1 x i30> @llvm.colossus.SDAG.unary.v1i30.v2i15(i32 %id, <2 x i15> %x)
  ret <1 x i30> %res
}

define <1 x i32> @any_extend_v2i16_to_v1i32(<2 x i16> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <1 x i32> @llvm.colossus.SDAG.unary.v1i32.v2i16(i32 %id, <2 x i16> %x)
  ret <1 x i32> %res
}

define <1 x i34> @any_extend_v2i17_to_v1i34(<2 x i17> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <1 x i34> @llvm.colossus.SDAG.unary.v1i34.v2i17(i32 %id, <2 x i17> %x)
  ret <1 x i34> %res
}

define <1 x i36> @any_extend_v2i18_to_v1i36(<2 x i18> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <1 x i36> @llvm.colossus.SDAG.unary.v1i36.v2i18(i32 %id, <2 x i18> %x)
  ret <1 x i36> %res
}

define <1 x i38> @any_extend_v2i19_to_v1i38(<2 x i19> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <1 x i38> @llvm.colossus.SDAG.unary.v1i38.v2i19(i32 %id, <2 x i19> %x)
  ret <1 x i38> %res
}

define <1 x i40> @any_extend_v2i20_to_v1i40(<2 x i20> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <1 x i40> @llvm.colossus.SDAG.unary.v1i40.v2i20(i32 %id, <2 x i20> %x)
  ret <1 x i40> %res
}

define <1 x i42> @any_extend_v2i21_to_v1i42(<2 x i21> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <1 x i42> @llvm.colossus.SDAG.unary.v1i42.v2i21(i32 %id, <2 x i21> %x)
  ret <1 x i42> %res
}

define <1 x i44> @any_extend_v2i22_to_v1i44(<2 x i22> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <1 x i44> @llvm.colossus.SDAG.unary.v1i44.v2i22(i32 %id, <2 x i22> %x)
  ret <1 x i44> %res
}

define <1 x i46> @any_extend_v2i23_to_v1i46(<2 x i23> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <1 x i46> @llvm.colossus.SDAG.unary.v1i46.v2i23(i32 %id, <2 x i23> %x)
  ret <1 x i46> %res
}

define <1 x i48> @any_extend_v2i24_to_v1i48(<2 x i24> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <1 x i48> @llvm.colossus.SDAG.unary.v1i48.v2i24(i32 %id, <2 x i24> %x)
  ret <1 x i48> %res
}

define <1 x i50> @any_extend_v2i25_to_v1i50(<2 x i25> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <1 x i50> @llvm.colossus.SDAG.unary.v1i50.v2i25(i32 %id, <2 x i25> %x)
  ret <1 x i50> %res
}

define <1 x i52> @any_extend_v2i26_to_v1i52(<2 x i26> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <1 x i52> @llvm.colossus.SDAG.unary.v1i52.v2i26(i32 %id, <2 x i26> %x)
  ret <1 x i52> %res
}

define <1 x i54> @any_extend_v2i27_to_v1i54(<2 x i27> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <1 x i54> @llvm.colossus.SDAG.unary.v1i54.v2i27(i32 %id, <2 x i27> %x)
  ret <1 x i54> %res
}

define <1 x i56> @any_extend_v2i28_to_v1i56(<2 x i28> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <1 x i56> @llvm.colossus.SDAG.unary.v1i56.v2i28(i32 %id, <2 x i28> %x)
  ret <1 x i56> %res
}

define <1 x i58> @any_extend_v2i29_to_v1i58(<2 x i29> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <1 x i58> @llvm.colossus.SDAG.unary.v1i58.v2i29(i32 %id, <2 x i29> %x)
  ret <1 x i58> %res
}

define <1 x i60> @any_extend_v2i30_to_v1i60(<2 x i30> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <1 x i60> @llvm.colossus.SDAG.unary.v1i60.v2i30(i32 %id, <2 x i30> %x)
  ret <1 x i60> %res
}

define <1 x i62> @any_extend_v2i31_to_v1i62(<2 x i31> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <1 x i62> @llvm.colossus.SDAG.unary.v1i62.v2i31(i32 %id, <2 x i31> %x)
  ret <1 x i62> %res
}

define <1 x i64> @any_extend_v2i32_to_v1i64(<2 x i32> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <1 x i64> @llvm.colossus.SDAG.unary.v1i64.v2i32(i32 %id, <2 x i32> %x)
  ret <1 x i64> %res
}

define <1 x i3> @any_extend_v3i1_to_v1i3(<3 x i1> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <1 x i3> @llvm.colossus.SDAG.unary.v1i3.v3i1(i32 %id, <3 x i1> %x)
  ret <1 x i3> %res
}

define <1 x i6> @any_extend_v3i2_to_v1i6(<3 x i2> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <1 x i6> @llvm.colossus.SDAG.unary.v1i6.v3i2(i32 %id, <3 x i2> %x)
  ret <1 x i6> %res
}

define <2 x i3> @any_extend_v3i2_to_v2i3(<3 x i2> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i3> @llvm.colossus.SDAG.unary.v2i3.v3i2(i32 %id, <3 x i2> %x)
  ret <2 x i3> %res
}

define <1 x i9> @any_extend_v3i3_to_v1i9(<3 x i3> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <1 x i9> @llvm.colossus.SDAG.unary.v1i9.v3i3(i32 %id, <3 x i3> %x)
  ret <1 x i9> %res
}

define <1 x i12> @any_extend_v3i4_to_v1i12(<3 x i4> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <1 x i12> @llvm.colossus.SDAG.unary.v1i12.v3i4(i32 %id, <3 x i4> %x)
  ret <1 x i12> %res
}

define <2 x i6> @any_extend_v3i4_to_v2i6(<3 x i4> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i6> @llvm.colossus.SDAG.unary.v2i6.v3i4(i32 %id, <3 x i4> %x)
  ret <2 x i6> %res
}

define <1 x i15> @any_extend_v3i5_to_v1i15(<3 x i5> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <1 x i15> @llvm.colossus.SDAG.unary.v1i15.v3i5(i32 %id, <3 x i5> %x)
  ret <1 x i15> %res
}

define <1 x i18> @any_extend_v3i6_to_v1i18(<3 x i6> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <1 x i18> @llvm.colossus.SDAG.unary.v1i18.v3i6(i32 %id, <3 x i6> %x)
  ret <1 x i18> %res
}

define <2 x i9> @any_extend_v3i6_to_v2i9(<3 x i6> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i9> @llvm.colossus.SDAG.unary.v2i9.v3i6(i32 %id, <3 x i6> %x)
  ret <2 x i9> %res
}

define <1 x i21> @any_extend_v3i7_to_v1i21(<3 x i7> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <1 x i21> @llvm.colossus.SDAG.unary.v1i21.v3i7(i32 %id, <3 x i7> %x)
  ret <1 x i21> %res
}

define <1 x i24> @any_extend_v3i8_to_v1i24(<3 x i8> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <1 x i24> @llvm.colossus.SDAG.unary.v1i24.v3i8(i32 %id, <3 x i8> %x)
  ret <1 x i24> %res
}

define <2 x i12> @any_extend_v3i8_to_v2i12(<3 x i8> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i12> @llvm.colossus.SDAG.unary.v2i12.v3i8(i32 %id, <3 x i8> %x)
  ret <2 x i12> %res
}

define <1 x i27> @any_extend_v3i9_to_v1i27(<3 x i9> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <1 x i27> @llvm.colossus.SDAG.unary.v1i27.v3i9(i32 %id, <3 x i9> %x)
  ret <1 x i27> %res
}

define <1 x i30> @any_extend_v3i10_to_v1i30(<3 x i10> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <1 x i30> @llvm.colossus.SDAG.unary.v1i30.v3i10(i32 %id, <3 x i10> %x)
  ret <1 x i30> %res
}

define <2 x i15> @any_extend_v3i10_to_v2i15(<3 x i10> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i15> @llvm.colossus.SDAG.unary.v2i15.v3i10(i32 %id, <3 x i10> %x)
  ret <2 x i15> %res
}

define <1 x i33> @any_extend_v3i11_to_v1i33(<3 x i11> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <1 x i33> @llvm.colossus.SDAG.unary.v1i33.v3i11(i32 %id, <3 x i11> %x)
  ret <1 x i33> %res
}

define <1 x i36> @any_extend_v3i12_to_v1i36(<3 x i12> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <1 x i36> @llvm.colossus.SDAG.unary.v1i36.v3i12(i32 %id, <3 x i12> %x)
  ret <1 x i36> %res
}

define <2 x i18> @any_extend_v3i12_to_v2i18(<3 x i12> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i18> @llvm.colossus.SDAG.unary.v2i18.v3i12(i32 %id, <3 x i12> %x)
  ret <2 x i18> %res
}

define <1 x i39> @any_extend_v3i13_to_v1i39(<3 x i13> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <1 x i39> @llvm.colossus.SDAG.unary.v1i39.v3i13(i32 %id, <3 x i13> %x)
  ret <1 x i39> %res
}

define <1 x i42> @any_extend_v3i14_to_v1i42(<3 x i14> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <1 x i42> @llvm.colossus.SDAG.unary.v1i42.v3i14(i32 %id, <3 x i14> %x)
  ret <1 x i42> %res
}

define <2 x i21> @any_extend_v3i14_to_v2i21(<3 x i14> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i21> @llvm.colossus.SDAG.unary.v2i21.v3i14(i32 %id, <3 x i14> %x)
  ret <2 x i21> %res
}

define <1 x i45> @any_extend_v3i15_to_v1i45(<3 x i15> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <1 x i45> @llvm.colossus.SDAG.unary.v1i45.v3i15(i32 %id, <3 x i15> %x)
  ret <1 x i45> %res
}

define <1 x i48> @any_extend_v3i16_to_v1i48(<3 x i16> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <1 x i48> @llvm.colossus.SDAG.unary.v1i48.v3i16(i32 %id, <3 x i16> %x)
  ret <1 x i48> %res
}

define <2 x i24> @any_extend_v3i16_to_v2i24(<3 x i16> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i24> @llvm.colossus.SDAG.unary.v2i24.v3i16(i32 %id, <3 x i16> %x)
  ret <2 x i24> %res
}

define <1 x i51> @any_extend_v3i17_to_v1i51(<3 x i17> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <1 x i51> @llvm.colossus.SDAG.unary.v1i51.v3i17(i32 %id, <3 x i17> %x)
  ret <1 x i51> %res
}

define <1 x i54> @any_extend_v3i18_to_v1i54(<3 x i18> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <1 x i54> @llvm.colossus.SDAG.unary.v1i54.v3i18(i32 %id, <3 x i18> %x)
  ret <1 x i54> %res
}

define <2 x i27> @any_extend_v3i18_to_v2i27(<3 x i18> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i27> @llvm.colossus.SDAG.unary.v2i27.v3i18(i32 %id, <3 x i18> %x)
  ret <2 x i27> %res
}

define <1 x i57> @any_extend_v3i19_to_v1i57(<3 x i19> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <1 x i57> @llvm.colossus.SDAG.unary.v1i57.v3i19(i32 %id, <3 x i19> %x)
  ret <1 x i57> %res
}

define <1 x i60> @any_extend_v3i20_to_v1i60(<3 x i20> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <1 x i60> @llvm.colossus.SDAG.unary.v1i60.v3i20(i32 %id, <3 x i20> %x)
  ret <1 x i60> %res
}

define <2 x i30> @any_extend_v3i20_to_v2i30(<3 x i20> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i30> @llvm.colossus.SDAG.unary.v2i30.v3i20(i32 %id, <3 x i20> %x)
  ret <2 x i30> %res
}

define <1 x i63> @any_extend_v3i21_to_v1i63(<3 x i21> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <1 x i63> @llvm.colossus.SDAG.unary.v1i63.v3i21(i32 %id, <3 x i21> %x)
  ret <1 x i63> %res
}

define <2 x i33> @any_extend_v3i22_to_v2i33(<3 x i22> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i33> @llvm.colossus.SDAG.unary.v2i33.v3i22(i32 %id, <3 x i22> %x)
  ret <2 x i33> %res
}

define <2 x i36> @any_extend_v3i24_to_v2i36(<3 x i24> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i36> @llvm.colossus.SDAG.unary.v2i36.v3i24(i32 %id, <3 x i24> %x)
  ret <2 x i36> %res
}

define <2 x i39> @any_extend_v3i26_to_v2i39(<3 x i26> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i39> @llvm.colossus.SDAG.unary.v2i39.v3i26(i32 %id, <3 x i26> %x)
  ret <2 x i39> %res
}

define <2 x i42> @any_extend_v3i28_to_v2i42(<3 x i28> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i42> @llvm.colossus.SDAG.unary.v2i42.v3i28(i32 %id, <3 x i28> %x)
  ret <2 x i42> %res
}

define <2 x i45> @any_extend_v3i30_to_v2i45(<3 x i30> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i45> @llvm.colossus.SDAG.unary.v2i45.v3i30(i32 %id, <3 x i30> %x)
  ret <2 x i45> %res
}

define <2 x i48> @any_extend_v3i32_to_v2i48(<3 x i32> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i48> @llvm.colossus.SDAG.unary.v2i48.v3i32(i32 %id, <3 x i32> %x)
  ret <2 x i48> %res
}

define <2 x i51> @any_extend_v3i34_to_v2i51(<3 x i34> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i51> @llvm.colossus.SDAG.unary.v2i51.v3i34(i32 %id, <3 x i34> %x)
  ret <2 x i51> %res
}

define <2 x i54> @any_extend_v3i36_to_v2i54(<3 x i36> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i54> @llvm.colossus.SDAG.unary.v2i54.v3i36(i32 %id, <3 x i36> %x)
  ret <2 x i54> %res
}

define <2 x i57> @any_extend_v3i38_to_v2i57(<3 x i38> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i57> @llvm.colossus.SDAG.unary.v2i57.v3i38(i32 %id, <3 x i38> %x)
  ret <2 x i57> %res
}

define <2 x i60> @any_extend_v3i40_to_v2i60(<3 x i40> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i60> @llvm.colossus.SDAG.unary.v2i60.v3i40(i32 %id, <3 x i40> %x)
  ret <2 x i60> %res
}

define <2 x i63> @any_extend_v3i42_to_v2i63(<3 x i42> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i63> @llvm.colossus.SDAG.unary.v2i63.v3i42(i32 %id, <3 x i42> %x)
  ret <2 x i63> %res
}

define <1 x i4> @any_extend_v4i1_to_v1i4(<4 x i1> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <1 x i4> @llvm.colossus.SDAG.unary.v1i4.v4i1(i32 %id, <4 x i1> %x)
  ret <1 x i4> %res
}

define <2 x i2> @any_extend_v4i1_to_v2i2(<4 x i1> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i2> @llvm.colossus.SDAG.unary.v2i2.v4i1(i32 %id, <4 x i1> %x)
  ret <2 x i2> %res
}

define <1 x i8> @any_extend_v4i2_to_v1i8(<4 x i2> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <1 x i8> @llvm.colossus.SDAG.unary.v1i8.v4i2(i32 %id, <4 x i2> %x)
  ret <1 x i8> %res
}

define <2 x i4> @any_extend_v4i2_to_v2i4(<4 x i2> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i4> @llvm.colossus.SDAG.unary.v2i4.v4i2(i32 %id, <4 x i2> %x)
  ret <2 x i4> %res
}

define <1 x i12> @any_extend_v4i3_to_v1i12(<4 x i3> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <1 x i12> @llvm.colossus.SDAG.unary.v1i12.v4i3(i32 %id, <4 x i3> %x)
  ret <1 x i12> %res
}

define <2 x i6> @any_extend_v4i3_to_v2i6(<4 x i3> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i6> @llvm.colossus.SDAG.unary.v2i6.v4i3(i32 %id, <4 x i3> %x)
  ret <2 x i6> %res
}

define <3 x i4> @any_extend_v4i3_to_v3i4(<4 x i3> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <3 x i4> @llvm.colossus.SDAG.unary.v3i4.v4i3(i32 %id, <4 x i3> %x)
  ret <3 x i4> %res
}

define <1 x i16> @any_extend_v4i4_to_v1i16(<4 x i4> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <1 x i16> @llvm.colossus.SDAG.unary.v1i16.v4i4(i32 %id, <4 x i4> %x)
  ret <1 x i16> %res
}

define <2 x i8> @any_extend_v4i4_to_v2i8(<4 x i4> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i8> @llvm.colossus.SDAG.unary.v2i8.v4i4(i32 %id, <4 x i4> %x)
  ret <2 x i8> %res
}

define <1 x i20> @any_extend_v4i5_to_v1i20(<4 x i5> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <1 x i20> @llvm.colossus.SDAG.unary.v1i20.v4i5(i32 %id, <4 x i5> %x)
  ret <1 x i20> %res
}

define <2 x i10> @any_extend_v4i5_to_v2i10(<4 x i5> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i10> @llvm.colossus.SDAG.unary.v2i10.v4i5(i32 %id, <4 x i5> %x)
  ret <2 x i10> %res
}

define <1 x i24> @any_extend_v4i6_to_v1i24(<4 x i6> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <1 x i24> @llvm.colossus.SDAG.unary.v1i24.v4i6(i32 %id, <4 x i6> %x)
  ret <1 x i24> %res
}

define <2 x i12> @any_extend_v4i6_to_v2i12(<4 x i6> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i12> @llvm.colossus.SDAG.unary.v2i12.v4i6(i32 %id, <4 x i6> %x)
  ret <2 x i12> %res
}

define <3 x i8> @any_extend_v4i6_to_v3i8(<4 x i6> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <3 x i8> @llvm.colossus.SDAG.unary.v3i8.v4i6(i32 %id, <4 x i6> %x)
  ret <3 x i8> %res
}

define <1 x i28> @any_extend_v4i7_to_v1i28(<4 x i7> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <1 x i28> @llvm.colossus.SDAG.unary.v1i28.v4i7(i32 %id, <4 x i7> %x)
  ret <1 x i28> %res
}

define <2 x i14> @any_extend_v4i7_to_v2i14(<4 x i7> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i14> @llvm.colossus.SDAG.unary.v2i14.v4i7(i32 %id, <4 x i7> %x)
  ret <2 x i14> %res
}

define <1 x i32> @any_extend_v4i8_to_v1i32(<4 x i8> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <1 x i32> @llvm.colossus.SDAG.unary.v1i32.v4i8(i32 %id, <4 x i8> %x)
  ret <1 x i32> %res
}

define <2 x i16> @any_extend_v4i8_to_v2i16(<4 x i8> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i16> @llvm.colossus.SDAG.unary.v2i16.v4i8(i32 %id, <4 x i8> %x)
  ret <2 x i16> %res
}

define <1 x i36> @any_extend_v4i9_to_v1i36(<4 x i9> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <1 x i36> @llvm.colossus.SDAG.unary.v1i36.v4i9(i32 %id, <4 x i9> %x)
  ret <1 x i36> %res
}

define <2 x i18> @any_extend_v4i9_to_v2i18(<4 x i9> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i18> @llvm.colossus.SDAG.unary.v2i18.v4i9(i32 %id, <4 x i9> %x)
  ret <2 x i18> %res
}

define <3 x i12> @any_extend_v4i9_to_v3i12(<4 x i9> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <3 x i12> @llvm.colossus.SDAG.unary.v3i12.v4i9(i32 %id, <4 x i9> %x)
  ret <3 x i12> %res
}

define <1 x i40> @any_extend_v4i10_to_v1i40(<4 x i10> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <1 x i40> @llvm.colossus.SDAG.unary.v1i40.v4i10(i32 %id, <4 x i10> %x)
  ret <1 x i40> %res
}

define <2 x i20> @any_extend_v4i10_to_v2i20(<4 x i10> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i20> @llvm.colossus.SDAG.unary.v2i20.v4i10(i32 %id, <4 x i10> %x)
  ret <2 x i20> %res
}

define <1 x i44> @any_extend_v4i11_to_v1i44(<4 x i11> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <1 x i44> @llvm.colossus.SDAG.unary.v1i44.v4i11(i32 %id, <4 x i11> %x)
  ret <1 x i44> %res
}

define <2 x i22> @any_extend_v4i11_to_v2i22(<4 x i11> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i22> @llvm.colossus.SDAG.unary.v2i22.v4i11(i32 %id, <4 x i11> %x)
  ret <2 x i22> %res
}

define <1 x i48> @any_extend_v4i12_to_v1i48(<4 x i12> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <1 x i48> @llvm.colossus.SDAG.unary.v1i48.v4i12(i32 %id, <4 x i12> %x)
  ret <1 x i48> %res
}

define <2 x i24> @any_extend_v4i12_to_v2i24(<4 x i12> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i24> @llvm.colossus.SDAG.unary.v2i24.v4i12(i32 %id, <4 x i12> %x)
  ret <2 x i24> %res
}

define <3 x i16> @any_extend_v4i12_to_v3i16(<4 x i12> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <3 x i16> @llvm.colossus.SDAG.unary.v3i16.v4i12(i32 %id, <4 x i12> %x)
  ret <3 x i16> %res
}

define <1 x i52> @any_extend_v4i13_to_v1i52(<4 x i13> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <1 x i52> @llvm.colossus.SDAG.unary.v1i52.v4i13(i32 %id, <4 x i13> %x)
  ret <1 x i52> %res
}

define <2 x i26> @any_extend_v4i13_to_v2i26(<4 x i13> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i26> @llvm.colossus.SDAG.unary.v2i26.v4i13(i32 %id, <4 x i13> %x)
  ret <2 x i26> %res
}

define <1 x i56> @any_extend_v4i14_to_v1i56(<4 x i14> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <1 x i56> @llvm.colossus.SDAG.unary.v1i56.v4i14(i32 %id, <4 x i14> %x)
  ret <1 x i56> %res
}

define <2 x i28> @any_extend_v4i14_to_v2i28(<4 x i14> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i28> @llvm.colossus.SDAG.unary.v2i28.v4i14(i32 %id, <4 x i14> %x)
  ret <2 x i28> %res
}

define <1 x i60> @any_extend_v4i15_to_v1i60(<4 x i15> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <1 x i60> @llvm.colossus.SDAG.unary.v1i60.v4i15(i32 %id, <4 x i15> %x)
  ret <1 x i60> %res
}

define <2 x i30> @any_extend_v4i15_to_v2i30(<4 x i15> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i30> @llvm.colossus.SDAG.unary.v2i30.v4i15(i32 %id, <4 x i15> %x)
  ret <2 x i30> %res
}

define <3 x i20> @any_extend_v4i15_to_v3i20(<4 x i15> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <3 x i20> @llvm.colossus.SDAG.unary.v3i20.v4i15(i32 %id, <4 x i15> %x)
  ret <3 x i20> %res
}

define <1 x i64> @any_extend_v4i16_to_v1i64(<4 x i16> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <1 x i64> @llvm.colossus.SDAG.unary.v1i64.v4i16(i32 %id, <4 x i16> %x)
  ret <1 x i64> %res
}

define <2 x i32> @any_extend_v4i16_to_v2i32(<4 x i16> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i32> @llvm.colossus.SDAG.unary.v2i32.v4i16(i32 %id, <4 x i16> %x)
  ret <2 x i32> %res
}

define <2 x i34> @any_extend_v4i17_to_v2i34(<4 x i17> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i34> @llvm.colossus.SDAG.unary.v2i34.v4i17(i32 %id, <4 x i17> %x)
  ret <2 x i34> %res
}

define <2 x i36> @any_extend_v4i18_to_v2i36(<4 x i18> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i36> @llvm.colossus.SDAG.unary.v2i36.v4i18(i32 %id, <4 x i18> %x)
  ret <2 x i36> %res
}

define <3 x i24> @any_extend_v4i18_to_v3i24(<4 x i18> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <3 x i24> @llvm.colossus.SDAG.unary.v3i24.v4i18(i32 %id, <4 x i18> %x)
  ret <3 x i24> %res
}

define <2 x i38> @any_extend_v4i19_to_v2i38(<4 x i19> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i38> @llvm.colossus.SDAG.unary.v2i38.v4i19(i32 %id, <4 x i19> %x)
  ret <2 x i38> %res
}

define <2 x i40> @any_extend_v4i20_to_v2i40(<4 x i20> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i40> @llvm.colossus.SDAG.unary.v2i40.v4i20(i32 %id, <4 x i20> %x)
  ret <2 x i40> %res
}

define <2 x i42> @any_extend_v4i21_to_v2i42(<4 x i21> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i42> @llvm.colossus.SDAG.unary.v2i42.v4i21(i32 %id, <4 x i21> %x)
  ret <2 x i42> %res
}

define <3 x i28> @any_extend_v4i21_to_v3i28(<4 x i21> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <3 x i28> @llvm.colossus.SDAG.unary.v3i28.v4i21(i32 %id, <4 x i21> %x)
  ret <3 x i28> %res
}

define <2 x i44> @any_extend_v4i22_to_v2i44(<4 x i22> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i44> @llvm.colossus.SDAG.unary.v2i44.v4i22(i32 %id, <4 x i22> %x)
  ret <2 x i44> %res
}

define <2 x i46> @any_extend_v4i23_to_v2i46(<4 x i23> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i46> @llvm.colossus.SDAG.unary.v2i46.v4i23(i32 %id, <4 x i23> %x)
  ret <2 x i46> %res
}

define <2 x i48> @any_extend_v4i24_to_v2i48(<4 x i24> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i48> @llvm.colossus.SDAG.unary.v2i48.v4i24(i32 %id, <4 x i24> %x)
  ret <2 x i48> %res
}

define <3 x i32> @any_extend_v4i24_to_v3i32(<4 x i24> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <3 x i32> @llvm.colossus.SDAG.unary.v3i32.v4i24(i32 %id, <4 x i24> %x)
  ret <3 x i32> %res
}

define <2 x i50> @any_extend_v4i25_to_v2i50(<4 x i25> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i50> @llvm.colossus.SDAG.unary.v2i50.v4i25(i32 %id, <4 x i25> %x)
  ret <2 x i50> %res
}

define <2 x i52> @any_extend_v4i26_to_v2i52(<4 x i26> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i52> @llvm.colossus.SDAG.unary.v2i52.v4i26(i32 %id, <4 x i26> %x)
  ret <2 x i52> %res
}

define <2 x i54> @any_extend_v4i27_to_v2i54(<4 x i27> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i54> @llvm.colossus.SDAG.unary.v2i54.v4i27(i32 %id, <4 x i27> %x)
  ret <2 x i54> %res
}

define <3 x i36> @any_extend_v4i27_to_v3i36(<4 x i27> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <3 x i36> @llvm.colossus.SDAG.unary.v3i36.v4i27(i32 %id, <4 x i27> %x)
  ret <3 x i36> %res
}

define <2 x i56> @any_extend_v4i28_to_v2i56(<4 x i28> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i56> @llvm.colossus.SDAG.unary.v2i56.v4i28(i32 %id, <4 x i28> %x)
  ret <2 x i56> %res
}

define <2 x i58> @any_extend_v4i29_to_v2i58(<4 x i29> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i58> @llvm.colossus.SDAG.unary.v2i58.v4i29(i32 %id, <4 x i29> %x)
  ret <2 x i58> %res
}

define <2 x i60> @any_extend_v4i30_to_v2i60(<4 x i30> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i60> @llvm.colossus.SDAG.unary.v2i60.v4i30(i32 %id, <4 x i30> %x)
  ret <2 x i60> %res
}

define <3 x i40> @any_extend_v4i30_to_v3i40(<4 x i30> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <3 x i40> @llvm.colossus.SDAG.unary.v3i40.v4i30(i32 %id, <4 x i30> %x)
  ret <3 x i40> %res
}

define <2 x i62> @any_extend_v4i31_to_v2i62(<4 x i31> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i62> @llvm.colossus.SDAG.unary.v2i62.v4i31(i32 %id, <4 x i31> %x)
  ret <2 x i62> %res
}

define <2 x i64> @any_extend_v4i32_to_v2i64(<4 x i32> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i64> @llvm.colossus.SDAG.unary.v2i64.v4i32(i32 %id, <4 x i32> %x)
  ret <2 x i64> %res
}

define <3 x i44> @any_extend_v4i33_to_v3i44(<4 x i33> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <3 x i44> @llvm.colossus.SDAG.unary.v3i44.v4i33(i32 %id, <4 x i33> %x)
  ret <3 x i44> %res
}

define <3 x i48> @any_extend_v4i36_to_v3i48(<4 x i36> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <3 x i48> @llvm.colossus.SDAG.unary.v3i48.v4i36(i32 %id, <4 x i36> %x)
  ret <3 x i48> %res
}

define <3 x i52> @any_extend_v4i39_to_v3i52(<4 x i39> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <3 x i52> @llvm.colossus.SDAG.unary.v3i52.v4i39(i32 %id, <4 x i39> %x)
  ret <3 x i52> %res
}

define <3 x i56> @any_extend_v4i42_to_v3i56(<4 x i42> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <3 x i56> @llvm.colossus.SDAG.unary.v3i56.v4i42(i32 %id, <4 x i42> %x)
  ret <3 x i56> %res
}

define <3 x i60> @any_extend_v4i45_to_v3i60(<4 x i45> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <3 x i60> @llvm.colossus.SDAG.unary.v3i60.v4i45(i32 %id, <4 x i45> %x)
  ret <3 x i60> %res
}

define <3 x i64> @any_extend_v4i48_to_v3i64(<4 x i48> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <3 x i64> @llvm.colossus.SDAG.unary.v3i64.v4i48(i32 %id, <4 x i48> %x)
  ret <3 x i64> %res
}

define <1 x i5> @any_extend_v5i1_to_v1i5(<5 x i1> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <1 x i5> @llvm.colossus.SDAG.unary.v1i5.v5i1(i32 %id, <5 x i1> %x)
  ret <1 x i5> %res
}

define <1 x i10> @any_extend_v5i2_to_v1i10(<5 x i2> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <1 x i10> @llvm.colossus.SDAG.unary.v1i10.v5i2(i32 %id, <5 x i2> %x)
  ret <1 x i10> %res
}

define <2 x i5> @any_extend_v5i2_to_v2i5(<5 x i2> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i5> @llvm.colossus.SDAG.unary.v2i5.v5i2(i32 %id, <5 x i2> %x)
  ret <2 x i5> %res
}

define <1 x i15> @any_extend_v5i3_to_v1i15(<5 x i3> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <1 x i15> @llvm.colossus.SDAG.unary.v1i15.v5i3(i32 %id, <5 x i3> %x)
  ret <1 x i15> %res
}

define <3 x i5> @any_extend_v5i3_to_v3i5(<5 x i3> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <3 x i5> @llvm.colossus.SDAG.unary.v3i5.v5i3(i32 %id, <5 x i3> %x)
  ret <3 x i5> %res
}

define <1 x i20> @any_extend_v5i4_to_v1i20(<5 x i4> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <1 x i20> @llvm.colossus.SDAG.unary.v1i20.v5i4(i32 %id, <5 x i4> %x)
  ret <1 x i20> %res
}

define <2 x i10> @any_extend_v5i4_to_v2i10(<5 x i4> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i10> @llvm.colossus.SDAG.unary.v2i10.v5i4(i32 %id, <5 x i4> %x)
  ret <2 x i10> %res
}

define <4 x i5> @any_extend_v5i4_to_v4i5(<5 x i4> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <4 x i5> @llvm.colossus.SDAG.unary.v4i5.v5i4(i32 %id, <5 x i4> %x)
  ret <4 x i5> %res
}

define <1 x i25> @any_extend_v5i5_to_v1i25(<5 x i5> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <1 x i25> @llvm.colossus.SDAG.unary.v1i25.v5i5(i32 %id, <5 x i5> %x)
  ret <1 x i25> %res
}

define <1 x i30> @any_extend_v5i6_to_v1i30(<5 x i6> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <1 x i30> @llvm.colossus.SDAG.unary.v1i30.v5i6(i32 %id, <5 x i6> %x)
  ret <1 x i30> %res
}

define <2 x i15> @any_extend_v5i6_to_v2i15(<5 x i6> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i15> @llvm.colossus.SDAG.unary.v2i15.v5i6(i32 %id, <5 x i6> %x)
  ret <2 x i15> %res
}

define <3 x i10> @any_extend_v5i6_to_v3i10(<5 x i6> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <3 x i10> @llvm.colossus.SDAG.unary.v3i10.v5i6(i32 %id, <5 x i6> %x)
  ret <3 x i10> %res
}

define <1 x i35> @any_extend_v5i7_to_v1i35(<5 x i7> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <1 x i35> @llvm.colossus.SDAG.unary.v1i35.v5i7(i32 %id, <5 x i7> %x)
  ret <1 x i35> %res
}

define <1 x i40> @any_extend_v5i8_to_v1i40(<5 x i8> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <1 x i40> @llvm.colossus.SDAG.unary.v1i40.v5i8(i32 %id, <5 x i8> %x)
  ret <1 x i40> %res
}

define <2 x i20> @any_extend_v5i8_to_v2i20(<5 x i8> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i20> @llvm.colossus.SDAG.unary.v2i20.v5i8(i32 %id, <5 x i8> %x)
  ret <2 x i20> %res
}

define <4 x i10> @any_extend_v5i8_to_v4i10(<5 x i8> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <4 x i10> @llvm.colossus.SDAG.unary.v4i10.v5i8(i32 %id, <5 x i8> %x)
  ret <4 x i10> %res
}

define <1 x i45> @any_extend_v5i9_to_v1i45(<5 x i9> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <1 x i45> @llvm.colossus.SDAG.unary.v1i45.v5i9(i32 %id, <5 x i9> %x)
  ret <1 x i45> %res
}

define <3 x i15> @any_extend_v5i9_to_v3i15(<5 x i9> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <3 x i15> @llvm.colossus.SDAG.unary.v3i15.v5i9(i32 %id, <5 x i9> %x)
  ret <3 x i15> %res
}

define <1 x i50> @any_extend_v5i10_to_v1i50(<5 x i10> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <1 x i50> @llvm.colossus.SDAG.unary.v1i50.v5i10(i32 %id, <5 x i10> %x)
  ret <1 x i50> %res
}

define <2 x i25> @any_extend_v5i10_to_v2i25(<5 x i10> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i25> @llvm.colossus.SDAG.unary.v2i25.v5i10(i32 %id, <5 x i10> %x)
  ret <2 x i25> %res
}

define <1 x i55> @any_extend_v5i11_to_v1i55(<5 x i11> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <1 x i55> @llvm.colossus.SDAG.unary.v1i55.v5i11(i32 %id, <5 x i11> %x)
  ret <1 x i55> %res
}

define <1 x i60> @any_extend_v5i12_to_v1i60(<5 x i12> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <1 x i60> @llvm.colossus.SDAG.unary.v1i60.v5i12(i32 %id, <5 x i12> %x)
  ret <1 x i60> %res
}

define <2 x i30> @any_extend_v5i12_to_v2i30(<5 x i12> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i30> @llvm.colossus.SDAG.unary.v2i30.v5i12(i32 %id, <5 x i12> %x)
  ret <2 x i30> %res
}

define <3 x i20> @any_extend_v5i12_to_v3i20(<5 x i12> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <3 x i20> @llvm.colossus.SDAG.unary.v3i20.v5i12(i32 %id, <5 x i12> %x)
  ret <3 x i20> %res
}

define <4 x i15> @any_extend_v5i12_to_v4i15(<5 x i12> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <4 x i15> @llvm.colossus.SDAG.unary.v4i15.v5i12(i32 %id, <5 x i12> %x)
  ret <4 x i15> %res
}

define <2 x i35> @any_extend_v5i14_to_v2i35(<5 x i14> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i35> @llvm.colossus.SDAG.unary.v2i35.v5i14(i32 %id, <5 x i14> %x)
  ret <2 x i35> %res
}

define <3 x i25> @any_extend_v5i15_to_v3i25(<5 x i15> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <3 x i25> @llvm.colossus.SDAG.unary.v3i25.v5i15(i32 %id, <5 x i15> %x)
  ret <3 x i25> %res
}

define <2 x i40> @any_extend_v5i16_to_v2i40(<5 x i16> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i40> @llvm.colossus.SDAG.unary.v2i40.v5i16(i32 %id, <5 x i16> %x)
  ret <2 x i40> %res
}

define <4 x i20> @any_extend_v5i16_to_v4i20(<5 x i16> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <4 x i20> @llvm.colossus.SDAG.unary.v4i20.v5i16(i32 %id, <5 x i16> %x)
  ret <4 x i20> %res
}

define <2 x i45> @any_extend_v5i18_to_v2i45(<5 x i18> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i45> @llvm.colossus.SDAG.unary.v2i45.v5i18(i32 %id, <5 x i18> %x)
  ret <2 x i45> %res
}

define <3 x i30> @any_extend_v5i18_to_v3i30(<5 x i18> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <3 x i30> @llvm.colossus.SDAG.unary.v3i30.v5i18(i32 %id, <5 x i18> %x)
  ret <3 x i30> %res
}

define <2 x i50> @any_extend_v5i20_to_v2i50(<5 x i20> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i50> @llvm.colossus.SDAG.unary.v2i50.v5i20(i32 %id, <5 x i20> %x)
  ret <2 x i50> %res
}

define <4 x i25> @any_extend_v5i20_to_v4i25(<5 x i20> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <4 x i25> @llvm.colossus.SDAG.unary.v4i25.v5i20(i32 %id, <5 x i20> %x)
  ret <4 x i25> %res
}

define <3 x i35> @any_extend_v5i21_to_v3i35(<5 x i21> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <3 x i35> @llvm.colossus.SDAG.unary.v3i35.v5i21(i32 %id, <5 x i21> %x)
  ret <3 x i35> %res
}

define <2 x i55> @any_extend_v5i22_to_v2i55(<5 x i22> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i55> @llvm.colossus.SDAG.unary.v2i55.v5i22(i32 %id, <5 x i22> %x)
  ret <2 x i55> %res
}

define <2 x i60> @any_extend_v5i24_to_v2i60(<5 x i24> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i60> @llvm.colossus.SDAG.unary.v2i60.v5i24(i32 %id, <5 x i24> %x)
  ret <2 x i60> %res
}

define <3 x i40> @any_extend_v5i24_to_v3i40(<5 x i24> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <3 x i40> @llvm.colossus.SDAG.unary.v3i40.v5i24(i32 %id, <5 x i24> %x)
  ret <3 x i40> %res
}

define <4 x i30> @any_extend_v5i24_to_v4i30(<5 x i24> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <4 x i30> @llvm.colossus.SDAG.unary.v4i30.v5i24(i32 %id, <5 x i24> %x)
  ret <4 x i30> %res
}

define <3 x i45> @any_extend_v5i27_to_v3i45(<5 x i27> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <3 x i45> @llvm.colossus.SDAG.unary.v3i45.v5i27(i32 %id, <5 x i27> %x)
  ret <3 x i45> %res
}

define <4 x i35> @any_extend_v5i28_to_v4i35(<5 x i28> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <4 x i35> @llvm.colossus.SDAG.unary.v4i35.v5i28(i32 %id, <5 x i28> %x)
  ret <4 x i35> %res
}

define <3 x i50> @any_extend_v5i30_to_v3i50(<5 x i30> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <3 x i50> @llvm.colossus.SDAG.unary.v3i50.v5i30(i32 %id, <5 x i30> %x)
  ret <3 x i50> %res
}

define <4 x i40> @any_extend_v5i32_to_v4i40(<5 x i32> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <4 x i40> @llvm.colossus.SDAG.unary.v4i40.v5i32(i32 %id, <5 x i32> %x)
  ret <4 x i40> %res
}

define <3 x i55> @any_extend_v5i33_to_v3i55(<5 x i33> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <3 x i55> @llvm.colossus.SDAG.unary.v3i55.v5i33(i32 %id, <5 x i33> %x)
  ret <3 x i55> %res
}

define <3 x i60> @any_extend_v5i36_to_v3i60(<5 x i36> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <3 x i60> @llvm.colossus.SDAG.unary.v3i60.v5i36(i32 %id, <5 x i36> %x)
  ret <3 x i60> %res
}

define <4 x i45> @any_extend_v5i36_to_v4i45(<5 x i36> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <4 x i45> @llvm.colossus.SDAG.unary.v4i45.v5i36(i32 %id, <5 x i36> %x)
  ret <4 x i45> %res
}

define <4 x i50> @any_extend_v5i40_to_v4i50(<5 x i40> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <4 x i50> @llvm.colossus.SDAG.unary.v4i50.v5i40(i32 %id, <5 x i40> %x)
  ret <4 x i50> %res
}

define <4 x i55> @any_extend_v5i44_to_v4i55(<5 x i44> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <4 x i55> @llvm.colossus.SDAG.unary.v4i55.v5i44(i32 %id, <5 x i44> %x)
  ret <4 x i55> %res
}

define <4 x i60> @any_extend_v5i48_to_v4i60(<5 x i48> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <4 x i60> @llvm.colossus.SDAG.unary.v4i60.v5i48(i32 %id, <5 x i48> %x)
  ret <4 x i60> %res
}

define <1 x i6> @any_extend_v6i1_to_v1i6(<6 x i1> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <1 x i6> @llvm.colossus.SDAG.unary.v1i6.v6i1(i32 %id, <6 x i1> %x)
  ret <1 x i6> %res
}

define <2 x i3> @any_extend_v6i1_to_v2i3(<6 x i1> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i3> @llvm.colossus.SDAG.unary.v2i3.v6i1(i32 %id, <6 x i1> %x)
  ret <2 x i3> %res
}

define <3 x i2> @any_extend_v6i1_to_v3i2(<6 x i1> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <3 x i2> @llvm.colossus.SDAG.unary.v3i2.v6i1(i32 %id, <6 x i1> %x)
  ret <3 x i2> %res
}

define <1 x i12> @any_extend_v6i2_to_v1i12(<6 x i2> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <1 x i12> @llvm.colossus.SDAG.unary.v1i12.v6i2(i32 %id, <6 x i2> %x)
  ret <1 x i12> %res
}

define <2 x i6> @any_extend_v6i2_to_v2i6(<6 x i2> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i6> @llvm.colossus.SDAG.unary.v2i6.v6i2(i32 %id, <6 x i2> %x)
  ret <2 x i6> %res
}

define <3 x i4> @any_extend_v6i2_to_v3i4(<6 x i2> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <3 x i4> @llvm.colossus.SDAG.unary.v3i4.v6i2(i32 %id, <6 x i2> %x)
  ret <3 x i4> %res
}

define <4 x i3> @any_extend_v6i2_to_v4i3(<6 x i2> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <4 x i3> @llvm.colossus.SDAG.unary.v4i3.v6i2(i32 %id, <6 x i2> %x)
  ret <4 x i3> %res
}

define <1 x i18> @any_extend_v6i3_to_v1i18(<6 x i3> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <1 x i18> @llvm.colossus.SDAG.unary.v1i18.v6i3(i32 %id, <6 x i3> %x)
  ret <1 x i18> %res
}

define <2 x i9> @any_extend_v6i3_to_v2i9(<6 x i3> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i9> @llvm.colossus.SDAG.unary.v2i9.v6i3(i32 %id, <6 x i3> %x)
  ret <2 x i9> %res
}

define <3 x i6> @any_extend_v6i3_to_v3i6(<6 x i3> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <3 x i6> @llvm.colossus.SDAG.unary.v3i6.v6i3(i32 %id, <6 x i3> %x)
  ret <3 x i6> %res
}

define <1 x i24> @any_extend_v6i4_to_v1i24(<6 x i4> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <1 x i24> @llvm.colossus.SDAG.unary.v1i24.v6i4(i32 %id, <6 x i4> %x)
  ret <1 x i24> %res
}

define <2 x i12> @any_extend_v6i4_to_v2i12(<6 x i4> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i12> @llvm.colossus.SDAG.unary.v2i12.v6i4(i32 %id, <6 x i4> %x)
  ret <2 x i12> %res
}

define <3 x i8> @any_extend_v6i4_to_v3i8(<6 x i4> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <3 x i8> @llvm.colossus.SDAG.unary.v3i8.v6i4(i32 %id, <6 x i4> %x)
  ret <3 x i8> %res
}

define <4 x i6> @any_extend_v6i4_to_v4i6(<6 x i4> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <4 x i6> @llvm.colossus.SDAG.unary.v4i6.v6i4(i32 %id, <6 x i4> %x)
  ret <4 x i6> %res
}

define <1 x i30> @any_extend_v6i5_to_v1i30(<6 x i5> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <1 x i30> @llvm.colossus.SDAG.unary.v1i30.v6i5(i32 %id, <6 x i5> %x)
  ret <1 x i30> %res
}

define <2 x i15> @any_extend_v6i5_to_v2i15(<6 x i5> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i15> @llvm.colossus.SDAG.unary.v2i15.v6i5(i32 %id, <6 x i5> %x)
  ret <2 x i15> %res
}

define <3 x i10> @any_extend_v6i5_to_v3i10(<6 x i5> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <3 x i10> @llvm.colossus.SDAG.unary.v3i10.v6i5(i32 %id, <6 x i5> %x)
  ret <3 x i10> %res
}

define <5 x i6> @any_extend_v6i5_to_v5i6(<6 x i5> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <5 x i6> @llvm.colossus.SDAG.unary.v5i6.v6i5(i32 %id, <6 x i5> %x)
  ret <5 x i6> %res
}

define <1 x i36> @any_extend_v6i6_to_v1i36(<6 x i6> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <1 x i36> @llvm.colossus.SDAG.unary.v1i36.v6i6(i32 %id, <6 x i6> %x)
  ret <1 x i36> %res
}

define <2 x i18> @any_extend_v6i6_to_v2i18(<6 x i6> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i18> @llvm.colossus.SDAG.unary.v2i18.v6i6(i32 %id, <6 x i6> %x)
  ret <2 x i18> %res
}

define <3 x i12> @any_extend_v6i6_to_v3i12(<6 x i6> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <3 x i12> @llvm.colossus.SDAG.unary.v3i12.v6i6(i32 %id, <6 x i6> %x)
  ret <3 x i12> %res
}

define <4 x i9> @any_extend_v6i6_to_v4i9(<6 x i6> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <4 x i9> @llvm.colossus.SDAG.unary.v4i9.v6i6(i32 %id, <6 x i6> %x)
  ret <4 x i9> %res
}

define <1 x i42> @any_extend_v6i7_to_v1i42(<6 x i7> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <1 x i42> @llvm.colossus.SDAG.unary.v1i42.v6i7(i32 %id, <6 x i7> %x)
  ret <1 x i42> %res
}

define <2 x i21> @any_extend_v6i7_to_v2i21(<6 x i7> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i21> @llvm.colossus.SDAG.unary.v2i21.v6i7(i32 %id, <6 x i7> %x)
  ret <2 x i21> %res
}

define <3 x i14> @any_extend_v6i7_to_v3i14(<6 x i7> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <3 x i14> @llvm.colossus.SDAG.unary.v3i14.v6i7(i32 %id, <6 x i7> %x)
  ret <3 x i14> %res
}

define <1 x i48> @any_extend_v6i8_to_v1i48(<6 x i8> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <1 x i48> @llvm.colossus.SDAG.unary.v1i48.v6i8(i32 %id, <6 x i8> %x)
  ret <1 x i48> %res
}

define <2 x i24> @any_extend_v6i8_to_v2i24(<6 x i8> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i24> @llvm.colossus.SDAG.unary.v2i24.v6i8(i32 %id, <6 x i8> %x)
  ret <2 x i24> %res
}

define <3 x i16> @any_extend_v6i8_to_v3i16(<6 x i8> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <3 x i16> @llvm.colossus.SDAG.unary.v3i16.v6i8(i32 %id, <6 x i8> %x)
  ret <3 x i16> %res
}

define <4 x i12> @any_extend_v6i8_to_v4i12(<6 x i8> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <4 x i12> @llvm.colossus.SDAG.unary.v4i12.v6i8(i32 %id, <6 x i8> %x)
  ret <4 x i12> %res
}

define <1 x i54> @any_extend_v6i9_to_v1i54(<6 x i9> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <1 x i54> @llvm.colossus.SDAG.unary.v1i54.v6i9(i32 %id, <6 x i9> %x)
  ret <1 x i54> %res
}

define <2 x i27> @any_extend_v6i9_to_v2i27(<6 x i9> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i27> @llvm.colossus.SDAG.unary.v2i27.v6i9(i32 %id, <6 x i9> %x)
  ret <2 x i27> %res
}

define <3 x i18> @any_extend_v6i9_to_v3i18(<6 x i9> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <3 x i18> @llvm.colossus.SDAG.unary.v3i18.v6i9(i32 %id, <6 x i9> %x)
  ret <3 x i18> %res
}

define <1 x i60> @any_extend_v6i10_to_v1i60(<6 x i10> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <1 x i60> @llvm.colossus.SDAG.unary.v1i60.v6i10(i32 %id, <6 x i10> %x)
  ret <1 x i60> %res
}

define <2 x i30> @any_extend_v6i10_to_v2i30(<6 x i10> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i30> @llvm.colossus.SDAG.unary.v2i30.v6i10(i32 %id, <6 x i10> %x)
  ret <2 x i30> %res
}

define <3 x i20> @any_extend_v6i10_to_v3i20(<6 x i10> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <3 x i20> @llvm.colossus.SDAG.unary.v3i20.v6i10(i32 %id, <6 x i10> %x)
  ret <3 x i20> %res
}

define <4 x i15> @any_extend_v6i10_to_v4i15(<6 x i10> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <4 x i15> @llvm.colossus.SDAG.unary.v4i15.v6i10(i32 %id, <6 x i10> %x)
  ret <4 x i15> %res
}

define <5 x i12> @any_extend_v6i10_to_v5i12(<6 x i10> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <5 x i12> @llvm.colossus.SDAG.unary.v5i12.v6i10(i32 %id, <6 x i10> %x)
  ret <5 x i12> %res
}

define <2 x i33> @any_extend_v6i11_to_v2i33(<6 x i11> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i33> @llvm.colossus.SDAG.unary.v2i33.v6i11(i32 %id, <6 x i11> %x)
  ret <2 x i33> %res
}

define <3 x i22> @any_extend_v6i11_to_v3i22(<6 x i11> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <3 x i22> @llvm.colossus.SDAG.unary.v3i22.v6i11(i32 %id, <6 x i11> %x)
  ret <3 x i22> %res
}

define <2 x i36> @any_extend_v6i12_to_v2i36(<6 x i12> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i36> @llvm.colossus.SDAG.unary.v2i36.v6i12(i32 %id, <6 x i12> %x)
  ret <2 x i36> %res
}

define <3 x i24> @any_extend_v6i12_to_v3i24(<6 x i12> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <3 x i24> @llvm.colossus.SDAG.unary.v3i24.v6i12(i32 %id, <6 x i12> %x)
  ret <3 x i24> %res
}

define <4 x i18> @any_extend_v6i12_to_v4i18(<6 x i12> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <4 x i18> @llvm.colossus.SDAG.unary.v4i18.v6i12(i32 %id, <6 x i12> %x)
  ret <4 x i18> %res
}

define <2 x i39> @any_extend_v6i13_to_v2i39(<6 x i13> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i39> @llvm.colossus.SDAG.unary.v2i39.v6i13(i32 %id, <6 x i13> %x)
  ret <2 x i39> %res
}

define <3 x i26> @any_extend_v6i13_to_v3i26(<6 x i13> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <3 x i26> @llvm.colossus.SDAG.unary.v3i26.v6i13(i32 %id, <6 x i13> %x)
  ret <3 x i26> %res
}

define <2 x i42> @any_extend_v6i14_to_v2i42(<6 x i14> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i42> @llvm.colossus.SDAG.unary.v2i42.v6i14(i32 %id, <6 x i14> %x)
  ret <2 x i42> %res
}

define <3 x i28> @any_extend_v6i14_to_v3i28(<6 x i14> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <3 x i28> @llvm.colossus.SDAG.unary.v3i28.v6i14(i32 %id, <6 x i14> %x)
  ret <3 x i28> %res
}

define <4 x i21> @any_extend_v6i14_to_v4i21(<6 x i14> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <4 x i21> @llvm.colossus.SDAG.unary.v4i21.v6i14(i32 %id, <6 x i14> %x)
  ret <4 x i21> %res
}

define <2 x i45> @any_extend_v6i15_to_v2i45(<6 x i15> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i45> @llvm.colossus.SDAG.unary.v2i45.v6i15(i32 %id, <6 x i15> %x)
  ret <2 x i45> %res
}

define <3 x i30> @any_extend_v6i15_to_v3i30(<6 x i15> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <3 x i30> @llvm.colossus.SDAG.unary.v3i30.v6i15(i32 %id, <6 x i15> %x)
  ret <3 x i30> %res
}

define <5 x i18> @any_extend_v6i15_to_v5i18(<6 x i15> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <5 x i18> @llvm.colossus.SDAG.unary.v5i18.v6i15(i32 %id, <6 x i15> %x)
  ret <5 x i18> %res
}

define <2 x i48> @any_extend_v6i16_to_v2i48(<6 x i16> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i48> @llvm.colossus.SDAG.unary.v2i48.v6i16(i32 %id, <6 x i16> %x)
  ret <2 x i48> %res
}

define <3 x i32> @any_extend_v6i16_to_v3i32(<6 x i16> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <3 x i32> @llvm.colossus.SDAG.unary.v3i32.v6i16(i32 %id, <6 x i16> %x)
  ret <3 x i32> %res
}

define <4 x i24> @any_extend_v6i16_to_v4i24(<6 x i16> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <4 x i24> @llvm.colossus.SDAG.unary.v4i24.v6i16(i32 %id, <6 x i16> %x)
  ret <4 x i24> %res
}

define <2 x i51> @any_extend_v6i17_to_v2i51(<6 x i17> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i51> @llvm.colossus.SDAG.unary.v2i51.v6i17(i32 %id, <6 x i17> %x)
  ret <2 x i51> %res
}

define <3 x i34> @any_extend_v6i17_to_v3i34(<6 x i17> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <3 x i34> @llvm.colossus.SDAG.unary.v3i34.v6i17(i32 %id, <6 x i17> %x)
  ret <3 x i34> %res
}

define <2 x i54> @any_extend_v6i18_to_v2i54(<6 x i18> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i54> @llvm.colossus.SDAG.unary.v2i54.v6i18(i32 %id, <6 x i18> %x)
  ret <2 x i54> %res
}

define <3 x i36> @any_extend_v6i18_to_v3i36(<6 x i18> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <3 x i36> @llvm.colossus.SDAG.unary.v3i36.v6i18(i32 %id, <6 x i18> %x)
  ret <3 x i36> %res
}

define <4 x i27> @any_extend_v6i18_to_v4i27(<6 x i18> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <4 x i27> @llvm.colossus.SDAG.unary.v4i27.v6i18(i32 %id, <6 x i18> %x)
  ret <4 x i27> %res
}

define <2 x i57> @any_extend_v6i19_to_v2i57(<6 x i19> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i57> @llvm.colossus.SDAG.unary.v2i57.v6i19(i32 %id, <6 x i19> %x)
  ret <2 x i57> %res
}

define <3 x i38> @any_extend_v6i19_to_v3i38(<6 x i19> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <3 x i38> @llvm.colossus.SDAG.unary.v3i38.v6i19(i32 %id, <6 x i19> %x)
  ret <3 x i38> %res
}

define <2 x i60> @any_extend_v6i20_to_v2i60(<6 x i20> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i60> @llvm.colossus.SDAG.unary.v2i60.v6i20(i32 %id, <6 x i20> %x)
  ret <2 x i60> %res
}

define <3 x i40> @any_extend_v6i20_to_v3i40(<6 x i20> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <3 x i40> @llvm.colossus.SDAG.unary.v3i40.v6i20(i32 %id, <6 x i20> %x)
  ret <3 x i40> %res
}

define <4 x i30> @any_extend_v6i20_to_v4i30(<6 x i20> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <4 x i30> @llvm.colossus.SDAG.unary.v4i30.v6i20(i32 %id, <6 x i20> %x)
  ret <4 x i30> %res
}

define <5 x i24> @any_extend_v6i20_to_v5i24(<6 x i20> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <5 x i24> @llvm.colossus.SDAG.unary.v5i24.v6i20(i32 %id, <6 x i20> %x)
  ret <5 x i24> %res
}

define <2 x i63> @any_extend_v6i21_to_v2i63(<6 x i21> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i63> @llvm.colossus.SDAG.unary.v2i63.v6i21(i32 %id, <6 x i21> %x)
  ret <2 x i63> %res
}

define <3 x i42> @any_extend_v6i21_to_v3i42(<6 x i21> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <3 x i42> @llvm.colossus.SDAG.unary.v3i42.v6i21(i32 %id, <6 x i21> %x)
  ret <3 x i42> %res
}

define <3 x i44> @any_extend_v6i22_to_v3i44(<6 x i22> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <3 x i44> @llvm.colossus.SDAG.unary.v3i44.v6i22(i32 %id, <6 x i22> %x)
  ret <3 x i44> %res
}

define <4 x i33> @any_extend_v6i22_to_v4i33(<6 x i22> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <4 x i33> @llvm.colossus.SDAG.unary.v4i33.v6i22(i32 %id, <6 x i22> %x)
  ret <4 x i33> %res
}

define <3 x i46> @any_extend_v6i23_to_v3i46(<6 x i23> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <3 x i46> @llvm.colossus.SDAG.unary.v3i46.v6i23(i32 %id, <6 x i23> %x)
  ret <3 x i46> %res
}

define <3 x i48> @any_extend_v6i24_to_v3i48(<6 x i24> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <3 x i48> @llvm.colossus.SDAG.unary.v3i48.v6i24(i32 %id, <6 x i24> %x)
  ret <3 x i48> %res
}

define <4 x i36> @any_extend_v6i24_to_v4i36(<6 x i24> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <4 x i36> @llvm.colossus.SDAG.unary.v4i36.v6i24(i32 %id, <6 x i24> %x)
  ret <4 x i36> %res
}

define <3 x i50> @any_extend_v6i25_to_v3i50(<6 x i25> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <3 x i50> @llvm.colossus.SDAG.unary.v3i50.v6i25(i32 %id, <6 x i25> %x)
  ret <3 x i50> %res
}

define <5 x i30> @any_extend_v6i25_to_v5i30(<6 x i25> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <5 x i30> @llvm.colossus.SDAG.unary.v5i30.v6i25(i32 %id, <6 x i25> %x)
  ret <5 x i30> %res
}

define <3 x i52> @any_extend_v6i26_to_v3i52(<6 x i26> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <3 x i52> @llvm.colossus.SDAG.unary.v3i52.v6i26(i32 %id, <6 x i26> %x)
  ret <3 x i52> %res
}

define <4 x i39> @any_extend_v6i26_to_v4i39(<6 x i26> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <4 x i39> @llvm.colossus.SDAG.unary.v4i39.v6i26(i32 %id, <6 x i26> %x)
  ret <4 x i39> %res
}

define <3 x i54> @any_extend_v6i27_to_v3i54(<6 x i27> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <3 x i54> @llvm.colossus.SDAG.unary.v3i54.v6i27(i32 %id, <6 x i27> %x)
  ret <3 x i54> %res
}

define <3 x i56> @any_extend_v6i28_to_v3i56(<6 x i28> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <3 x i56> @llvm.colossus.SDAG.unary.v3i56.v6i28(i32 %id, <6 x i28> %x)
  ret <3 x i56> %res
}

define <4 x i42> @any_extend_v6i28_to_v4i42(<6 x i28> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <4 x i42> @llvm.colossus.SDAG.unary.v4i42.v6i28(i32 %id, <6 x i28> %x)
  ret <4 x i42> %res
}

define <3 x i58> @any_extend_v6i29_to_v3i58(<6 x i29> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <3 x i58> @llvm.colossus.SDAG.unary.v3i58.v6i29(i32 %id, <6 x i29> %x)
  ret <3 x i58> %res
}

define <3 x i60> @any_extend_v6i30_to_v3i60(<6 x i30> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <3 x i60> @llvm.colossus.SDAG.unary.v3i60.v6i30(i32 %id, <6 x i30> %x)
  ret <3 x i60> %res
}

define <4 x i45> @any_extend_v6i30_to_v4i45(<6 x i30> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <4 x i45> @llvm.colossus.SDAG.unary.v4i45.v6i30(i32 %id, <6 x i30> %x)
  ret <4 x i45> %res
}

define <5 x i36> @any_extend_v6i30_to_v5i36(<6 x i30> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <5 x i36> @llvm.colossus.SDAG.unary.v5i36.v6i30(i32 %id, <6 x i30> %x)
  ret <5 x i36> %res
}

define <3 x i62> @any_extend_v6i31_to_v3i62(<6 x i31> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <3 x i62> @llvm.colossus.SDAG.unary.v3i62.v6i31(i32 %id, <6 x i31> %x)
  ret <3 x i62> %res
}

define <3 x i64> @any_extend_v6i32_to_v3i64(<6 x i32> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <3 x i64> @llvm.colossus.SDAG.unary.v3i64.v6i32(i32 %id, <6 x i32> %x)
  ret <3 x i64> %res
}

define <4 x i48> @any_extend_v6i32_to_v4i48(<6 x i32> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <4 x i48> @llvm.colossus.SDAG.unary.v4i48.v6i32(i32 %id, <6 x i32> %x)
  ret <4 x i48> %res
}

define <4 x i51> @any_extend_v6i34_to_v4i51(<6 x i34> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <4 x i51> @llvm.colossus.SDAG.unary.v4i51.v6i34(i32 %id, <6 x i34> %x)
  ret <4 x i51> %res
}

define <5 x i42> @any_extend_v6i35_to_v5i42(<6 x i35> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <5 x i42> @llvm.colossus.SDAG.unary.v5i42.v6i35(i32 %id, <6 x i35> %x)
  ret <5 x i42> %res
}

define <4 x i54> @any_extend_v6i36_to_v4i54(<6 x i36> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <4 x i54> @llvm.colossus.SDAG.unary.v4i54.v6i36(i32 %id, <6 x i36> %x)
  ret <4 x i54> %res
}

define <4 x i57> @any_extend_v6i38_to_v4i57(<6 x i38> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <4 x i57> @llvm.colossus.SDAG.unary.v4i57.v6i38(i32 %id, <6 x i38> %x)
  ret <4 x i57> %res
}

define <4 x i60> @any_extend_v6i40_to_v4i60(<6 x i40> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <4 x i60> @llvm.colossus.SDAG.unary.v4i60.v6i40(i32 %id, <6 x i40> %x)
  ret <4 x i60> %res
}

define <5 x i48> @any_extend_v6i40_to_v5i48(<6 x i40> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <5 x i48> @llvm.colossus.SDAG.unary.v5i48.v6i40(i32 %id, <6 x i40> %x)
  ret <5 x i48> %res
}

define <4 x i63> @any_extend_v6i42_to_v4i63(<6 x i42> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <4 x i63> @llvm.colossus.SDAG.unary.v4i63.v6i42(i32 %id, <6 x i42> %x)
  ret <4 x i63> %res
}

define <5 x i54> @any_extend_v6i45_to_v5i54(<6 x i45> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <5 x i54> @llvm.colossus.SDAG.unary.v5i54.v6i45(i32 %id, <6 x i45> %x)
  ret <5 x i54> %res
}

define <5 x i60> @any_extend_v6i50_to_v5i60(<6 x i50> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <5 x i60> @llvm.colossus.SDAG.unary.v5i60.v6i50(i32 %id, <6 x i50> %x)
  ret <5 x i60> %res
}

define <1 x i7> @any_extend_v7i1_to_v1i7(<7 x i1> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <1 x i7> @llvm.colossus.SDAG.unary.v1i7.v7i1(i32 %id, <7 x i1> %x)
  ret <1 x i7> %res
}

define <1 x i14> @any_extend_v7i2_to_v1i14(<7 x i2> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <1 x i14> @llvm.colossus.SDAG.unary.v1i14.v7i2(i32 %id, <7 x i2> %x)
  ret <1 x i14> %res
}

define <2 x i7> @any_extend_v7i2_to_v2i7(<7 x i2> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i7> @llvm.colossus.SDAG.unary.v2i7.v7i2(i32 %id, <7 x i2> %x)
  ret <2 x i7> %res
}

define <1 x i21> @any_extend_v7i3_to_v1i21(<7 x i3> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <1 x i21> @llvm.colossus.SDAG.unary.v1i21.v7i3(i32 %id, <7 x i3> %x)
  ret <1 x i21> %res
}

define <3 x i7> @any_extend_v7i3_to_v3i7(<7 x i3> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <3 x i7> @llvm.colossus.SDAG.unary.v3i7.v7i3(i32 %id, <7 x i3> %x)
  ret <3 x i7> %res
}

define <1 x i28> @any_extend_v7i4_to_v1i28(<7 x i4> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <1 x i28> @llvm.colossus.SDAG.unary.v1i28.v7i4(i32 %id, <7 x i4> %x)
  ret <1 x i28> %res
}

define <2 x i14> @any_extend_v7i4_to_v2i14(<7 x i4> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i14> @llvm.colossus.SDAG.unary.v2i14.v7i4(i32 %id, <7 x i4> %x)
  ret <2 x i14> %res
}

define <4 x i7> @any_extend_v7i4_to_v4i7(<7 x i4> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <4 x i7> @llvm.colossus.SDAG.unary.v4i7.v7i4(i32 %id, <7 x i4> %x)
  ret <4 x i7> %res
}

define <1 x i35> @any_extend_v7i5_to_v1i35(<7 x i5> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <1 x i35> @llvm.colossus.SDAG.unary.v1i35.v7i5(i32 %id, <7 x i5> %x)
  ret <1 x i35> %res
}

define <5 x i7> @any_extend_v7i5_to_v5i7(<7 x i5> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <5 x i7> @llvm.colossus.SDAG.unary.v5i7.v7i5(i32 %id, <7 x i5> %x)
  ret <5 x i7> %res
}

define <1 x i42> @any_extend_v7i6_to_v1i42(<7 x i6> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <1 x i42> @llvm.colossus.SDAG.unary.v1i42.v7i6(i32 %id, <7 x i6> %x)
  ret <1 x i42> %res
}

define <2 x i21> @any_extend_v7i6_to_v2i21(<7 x i6> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i21> @llvm.colossus.SDAG.unary.v2i21.v7i6(i32 %id, <7 x i6> %x)
  ret <2 x i21> %res
}

define <3 x i14> @any_extend_v7i6_to_v3i14(<7 x i6> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <3 x i14> @llvm.colossus.SDAG.unary.v3i14.v7i6(i32 %id, <7 x i6> %x)
  ret <3 x i14> %res
}

define <6 x i7> @any_extend_v7i6_to_v6i7(<7 x i6> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <6 x i7> @llvm.colossus.SDAG.unary.v6i7.v7i6(i32 %id, <7 x i6> %x)
  ret <6 x i7> %res
}

define <1 x i49> @any_extend_v7i7_to_v1i49(<7 x i7> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <1 x i49> @llvm.colossus.SDAG.unary.v1i49.v7i7(i32 %id, <7 x i7> %x)
  ret <1 x i49> %res
}

define <1 x i56> @any_extend_v7i8_to_v1i56(<7 x i8> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <1 x i56> @llvm.colossus.SDAG.unary.v1i56.v7i8(i32 %id, <7 x i8> %x)
  ret <1 x i56> %res
}

define <2 x i28> @any_extend_v7i8_to_v2i28(<7 x i8> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i28> @llvm.colossus.SDAG.unary.v2i28.v7i8(i32 %id, <7 x i8> %x)
  ret <2 x i28> %res
}

define <4 x i14> @any_extend_v7i8_to_v4i14(<7 x i8> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <4 x i14> @llvm.colossus.SDAG.unary.v4i14.v7i8(i32 %id, <7 x i8> %x)
  ret <4 x i14> %res
}

define <1 x i63> @any_extend_v7i9_to_v1i63(<7 x i9> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <1 x i63> @llvm.colossus.SDAG.unary.v1i63.v7i9(i32 %id, <7 x i9> %x)
  ret <1 x i63> %res
}

define <3 x i21> @any_extend_v7i9_to_v3i21(<7 x i9> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <3 x i21> @llvm.colossus.SDAG.unary.v3i21.v7i9(i32 %id, <7 x i9> %x)
  ret <3 x i21> %res
}

define <2 x i35> @any_extend_v7i10_to_v2i35(<7 x i10> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i35> @llvm.colossus.SDAG.unary.v2i35.v7i10(i32 %id, <7 x i10> %x)
  ret <2 x i35> %res
}

define <5 x i14> @any_extend_v7i10_to_v5i14(<7 x i10> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <5 x i14> @llvm.colossus.SDAG.unary.v5i14.v7i10(i32 %id, <7 x i10> %x)
  ret <5 x i14> %res
}

define <2 x i42> @any_extend_v7i12_to_v2i42(<7 x i12> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i42> @llvm.colossus.SDAG.unary.v2i42.v7i12(i32 %id, <7 x i12> %x)
  ret <2 x i42> %res
}

define <3 x i28> @any_extend_v7i12_to_v3i28(<7 x i12> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <3 x i28> @llvm.colossus.SDAG.unary.v3i28.v7i12(i32 %id, <7 x i12> %x)
  ret <3 x i28> %res
}

define <4 x i21> @any_extend_v7i12_to_v4i21(<7 x i12> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <4 x i21> @llvm.colossus.SDAG.unary.v4i21.v7i12(i32 %id, <7 x i12> %x)
  ret <4 x i21> %res
}

define <6 x i14> @any_extend_v7i12_to_v6i14(<7 x i12> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <6 x i14> @llvm.colossus.SDAG.unary.v6i14.v7i12(i32 %id, <7 x i12> %x)
  ret <6 x i14> %res
}

define <2 x i49> @any_extend_v7i14_to_v2i49(<7 x i14> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i49> @llvm.colossus.SDAG.unary.v2i49.v7i14(i32 %id, <7 x i14> %x)
  ret <2 x i49> %res
}

define <3 x i35> @any_extend_v7i15_to_v3i35(<7 x i15> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <3 x i35> @llvm.colossus.SDAG.unary.v3i35.v7i15(i32 %id, <7 x i15> %x)
  ret <3 x i35> %res
}

define <5 x i21> @any_extend_v7i15_to_v5i21(<7 x i15> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <5 x i21> @llvm.colossus.SDAG.unary.v5i21.v7i15(i32 %id, <7 x i15> %x)
  ret <5 x i21> %res
}

define <2 x i56> @any_extend_v7i16_to_v2i56(<7 x i16> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i56> @llvm.colossus.SDAG.unary.v2i56.v7i16(i32 %id, <7 x i16> %x)
  ret <2 x i56> %res
}

define <4 x i28> @any_extend_v7i16_to_v4i28(<7 x i16> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <4 x i28> @llvm.colossus.SDAG.unary.v4i28.v7i16(i32 %id, <7 x i16> %x)
  ret <4 x i28> %res
}

define <2 x i63> @any_extend_v7i18_to_v2i63(<7 x i18> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i63> @llvm.colossus.SDAG.unary.v2i63.v7i18(i32 %id, <7 x i18> %x)
  ret <2 x i63> %res
}

define <3 x i42> @any_extend_v7i18_to_v3i42(<7 x i18> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <3 x i42> @llvm.colossus.SDAG.unary.v3i42.v7i18(i32 %id, <7 x i18> %x)
  ret <3 x i42> %res
}

define <6 x i21> @any_extend_v7i18_to_v6i21(<7 x i18> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <6 x i21> @llvm.colossus.SDAG.unary.v6i21.v7i18(i32 %id, <7 x i18> %x)
  ret <6 x i21> %res
}

define <4 x i35> @any_extend_v7i20_to_v4i35(<7 x i20> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <4 x i35> @llvm.colossus.SDAG.unary.v4i35.v7i20(i32 %id, <7 x i20> %x)
  ret <4 x i35> %res
}

define <5 x i28> @any_extend_v7i20_to_v5i28(<7 x i20> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <5 x i28> @llvm.colossus.SDAG.unary.v5i28.v7i20(i32 %id, <7 x i20> %x)
  ret <5 x i28> %res
}

define <3 x i49> @any_extend_v7i21_to_v3i49(<7 x i21> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <3 x i49> @llvm.colossus.SDAG.unary.v3i49.v7i21(i32 %id, <7 x i21> %x)
  ret <3 x i49> %res
}

define <3 x i56> @any_extend_v7i24_to_v3i56(<7 x i24> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <3 x i56> @llvm.colossus.SDAG.unary.v3i56.v7i24(i32 %id, <7 x i24> %x)
  ret <3 x i56> %res
}

define <4 x i42> @any_extend_v7i24_to_v4i42(<7 x i24> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <4 x i42> @llvm.colossus.SDAG.unary.v4i42.v7i24(i32 %id, <7 x i24> %x)
  ret <4 x i42> %res
}

define <6 x i28> @any_extend_v7i24_to_v6i28(<7 x i24> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <6 x i28> @llvm.colossus.SDAG.unary.v6i28.v7i24(i32 %id, <7 x i24> %x)
  ret <6 x i28> %res
}

define <5 x i35> @any_extend_v7i25_to_v5i35(<7 x i25> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <5 x i35> @llvm.colossus.SDAG.unary.v5i35.v7i25(i32 %id, <7 x i25> %x)
  ret <5 x i35> %res
}

define <3 x i63> @any_extend_v7i27_to_v3i63(<7 x i27> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <3 x i63> @llvm.colossus.SDAG.unary.v3i63.v7i27(i32 %id, <7 x i27> %x)
  ret <3 x i63> %res
}

define <4 x i49> @any_extend_v7i28_to_v4i49(<7 x i28> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <4 x i49> @llvm.colossus.SDAG.unary.v4i49.v7i28(i32 %id, <7 x i28> %x)
  ret <4 x i49> %res
}

define <5 x i42> @any_extend_v7i30_to_v5i42(<7 x i30> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <5 x i42> @llvm.colossus.SDAG.unary.v5i42.v7i30(i32 %id, <7 x i30> %x)
  ret <5 x i42> %res
}

define <6 x i35> @any_extend_v7i30_to_v6i35(<7 x i30> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <6 x i35> @llvm.colossus.SDAG.unary.v6i35.v7i30(i32 %id, <7 x i30> %x)
  ret <6 x i35> %res
}

define <4 x i56> @any_extend_v7i32_to_v4i56(<7 x i32> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <4 x i56> @llvm.colossus.SDAG.unary.v4i56.v7i32(i32 %id, <7 x i32> %x)
  ret <4 x i56> %res
}

define <5 x i49> @any_extend_v7i35_to_v5i49(<7 x i35> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <5 x i49> @llvm.colossus.SDAG.unary.v5i49.v7i35(i32 %id, <7 x i35> %x)
  ret <5 x i49> %res
}

define <4 x i63> @any_extend_v7i36_to_v4i63(<7 x i36> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <4 x i63> @llvm.colossus.SDAG.unary.v4i63.v7i36(i32 %id, <7 x i36> %x)
  ret <4 x i63> %res
}

define <6 x i42> @any_extend_v7i36_to_v6i42(<7 x i36> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <6 x i42> @llvm.colossus.SDAG.unary.v6i42.v7i36(i32 %id, <7 x i36> %x)
  ret <6 x i42> %res
}

define <5 x i56> @any_extend_v7i40_to_v5i56(<7 x i40> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <5 x i56> @llvm.colossus.SDAG.unary.v5i56.v7i40(i32 %id, <7 x i40> %x)
  ret <5 x i56> %res
}

define <6 x i49> @any_extend_v7i42_to_v6i49(<7 x i42> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <6 x i49> @llvm.colossus.SDAG.unary.v6i49.v7i42(i32 %id, <7 x i42> %x)
  ret <6 x i49> %res
}

define <5 x i63> @any_extend_v7i45_to_v5i63(<7 x i45> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <5 x i63> @llvm.colossus.SDAG.unary.v5i63.v7i45(i32 %id, <7 x i45> %x)
  ret <5 x i63> %res
}

define <6 x i56> @any_extend_v7i48_to_v6i56(<7 x i48> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <6 x i56> @llvm.colossus.SDAG.unary.v6i56.v7i48(i32 %id, <7 x i48> %x)
  ret <6 x i56> %res
}

define <6 x i63> @any_extend_v7i54_to_v6i63(<7 x i54> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <6 x i63> @llvm.colossus.SDAG.unary.v6i63.v7i54(i32 %id, <7 x i54> %x)
  ret <6 x i63> %res
}

define <1 x i8> @any_extend_v8i1_to_v1i8(<8 x i1> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <1 x i8> @llvm.colossus.SDAG.unary.v1i8.v8i1(i32 %id, <8 x i1> %x)
  ret <1 x i8> %res
}

define <2 x i4> @any_extend_v8i1_to_v2i4(<8 x i1> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i4> @llvm.colossus.SDAG.unary.v2i4.v8i1(i32 %id, <8 x i1> %x)
  ret <2 x i4> %res
}

define <4 x i2> @any_extend_v8i1_to_v4i2(<8 x i1> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <4 x i2> @llvm.colossus.SDAG.unary.v4i2.v8i1(i32 %id, <8 x i1> %x)
  ret <4 x i2> %res
}

define <1 x i16> @any_extend_v8i2_to_v1i16(<8 x i2> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <1 x i16> @llvm.colossus.SDAG.unary.v1i16.v8i2(i32 %id, <8 x i2> %x)
  ret <1 x i16> %res
}

define <2 x i8> @any_extend_v8i2_to_v2i8(<8 x i2> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i8> @llvm.colossus.SDAG.unary.v2i8.v8i2(i32 %id, <8 x i2> %x)
  ret <2 x i8> %res
}

define <4 x i4> @any_extend_v8i2_to_v4i4(<8 x i2> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <4 x i4> @llvm.colossus.SDAG.unary.v4i4.v8i2(i32 %id, <8 x i2> %x)
  ret <4 x i4> %res
}

define <1 x i24> @any_extend_v8i3_to_v1i24(<8 x i3> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <1 x i24> @llvm.colossus.SDAG.unary.v1i24.v8i3(i32 %id, <8 x i3> %x)
  ret <1 x i24> %res
}

define <2 x i12> @any_extend_v8i3_to_v2i12(<8 x i3> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i12> @llvm.colossus.SDAG.unary.v2i12.v8i3(i32 %id, <8 x i3> %x)
  ret <2 x i12> %res
}

define <3 x i8> @any_extend_v8i3_to_v3i8(<8 x i3> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <3 x i8> @llvm.colossus.SDAG.unary.v3i8.v8i3(i32 %id, <8 x i3> %x)
  ret <3 x i8> %res
}

define <4 x i6> @any_extend_v8i3_to_v4i6(<8 x i3> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <4 x i6> @llvm.colossus.SDAG.unary.v4i6.v8i3(i32 %id, <8 x i3> %x)
  ret <4 x i6> %res
}

define <6 x i4> @any_extend_v8i3_to_v6i4(<8 x i3> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <6 x i4> @llvm.colossus.SDAG.unary.v6i4.v8i3(i32 %id, <8 x i3> %x)
  ret <6 x i4> %res
}

define <1 x i32> @any_extend_v8i4_to_v1i32(<8 x i4> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <1 x i32> @llvm.colossus.SDAG.unary.v1i32.v8i4(i32 %id, <8 x i4> %x)
  ret <1 x i32> %res
}

define <2 x i16> @any_extend_v8i4_to_v2i16(<8 x i4> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i16> @llvm.colossus.SDAG.unary.v2i16.v8i4(i32 %id, <8 x i4> %x)
  ret <2 x i16> %res
}

define <4 x i8> @any_extend_v8i4_to_v4i8(<8 x i4> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <4 x i8> @llvm.colossus.SDAG.unary.v4i8.v8i4(i32 %id, <8 x i4> %x)
  ret <4 x i8> %res
}

define <1 x i40> @any_extend_v8i5_to_v1i40(<8 x i5> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <1 x i40> @llvm.colossus.SDAG.unary.v1i40.v8i5(i32 %id, <8 x i5> %x)
  ret <1 x i40> %res
}

define <2 x i20> @any_extend_v8i5_to_v2i20(<8 x i5> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i20> @llvm.colossus.SDAG.unary.v2i20.v8i5(i32 %id, <8 x i5> %x)
  ret <2 x i20> %res
}

define <4 x i10> @any_extend_v8i5_to_v4i10(<8 x i5> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <4 x i10> @llvm.colossus.SDAG.unary.v4i10.v8i5(i32 %id, <8 x i5> %x)
  ret <4 x i10> %res
}

define <5 x i8> @any_extend_v8i5_to_v5i8(<8 x i5> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <5 x i8> @llvm.colossus.SDAG.unary.v5i8.v8i5(i32 %id, <8 x i5> %x)
  ret <5 x i8> %res
}

define <1 x i48> @any_extend_v8i6_to_v1i48(<8 x i6> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <1 x i48> @llvm.colossus.SDAG.unary.v1i48.v8i6(i32 %id, <8 x i6> %x)
  ret <1 x i48> %res
}

define <2 x i24> @any_extend_v8i6_to_v2i24(<8 x i6> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i24> @llvm.colossus.SDAG.unary.v2i24.v8i6(i32 %id, <8 x i6> %x)
  ret <2 x i24> %res
}

define <3 x i16> @any_extend_v8i6_to_v3i16(<8 x i6> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <3 x i16> @llvm.colossus.SDAG.unary.v3i16.v8i6(i32 %id, <8 x i6> %x)
  ret <3 x i16> %res
}

define <4 x i12> @any_extend_v8i6_to_v4i12(<8 x i6> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <4 x i12> @llvm.colossus.SDAG.unary.v4i12.v8i6(i32 %id, <8 x i6> %x)
  ret <4 x i12> %res
}

define <6 x i8> @any_extend_v8i6_to_v6i8(<8 x i6> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <6 x i8> @llvm.colossus.SDAG.unary.v6i8.v8i6(i32 %id, <8 x i6> %x)
  ret <6 x i8> %res
}

define <1 x i56> @any_extend_v8i7_to_v1i56(<8 x i7> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <1 x i56> @llvm.colossus.SDAG.unary.v1i56.v8i7(i32 %id, <8 x i7> %x)
  ret <1 x i56> %res
}

define <2 x i28> @any_extend_v8i7_to_v2i28(<8 x i7> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i28> @llvm.colossus.SDAG.unary.v2i28.v8i7(i32 %id, <8 x i7> %x)
  ret <2 x i28> %res
}

define <4 x i14> @any_extend_v8i7_to_v4i14(<8 x i7> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <4 x i14> @llvm.colossus.SDAG.unary.v4i14.v8i7(i32 %id, <8 x i7> %x)
  ret <4 x i14> %res
}

define <7 x i8> @any_extend_v8i7_to_v7i8(<8 x i7> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <7 x i8> @llvm.colossus.SDAG.unary.v7i8.v8i7(i32 %id, <8 x i7> %x)
  ret <7 x i8> %res
}

define <1 x i64> @any_extend_v8i8_to_v1i64(<8 x i8> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <1 x i64> @llvm.colossus.SDAG.unary.v1i64.v8i8(i32 %id, <8 x i8> %x)
  ret <1 x i64> %res
}

define <2 x i32> @any_extend_v8i8_to_v2i32(<8 x i8> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i32> @llvm.colossus.SDAG.unary.v2i32.v8i8(i32 %id, <8 x i8> %x)
  ret <2 x i32> %res
}

define <4 x i16> @any_extend_v8i8_to_v4i16(<8 x i8> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <4 x i16> @llvm.colossus.SDAG.unary.v4i16.v8i8(i32 %id, <8 x i8> %x)
  ret <4 x i16> %res
}

define <2 x i36> @any_extend_v8i9_to_v2i36(<8 x i9> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i36> @llvm.colossus.SDAG.unary.v2i36.v8i9(i32 %id, <8 x i9> %x)
  ret <2 x i36> %res
}

define <3 x i24> @any_extend_v8i9_to_v3i24(<8 x i9> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <3 x i24> @llvm.colossus.SDAG.unary.v3i24.v8i9(i32 %id, <8 x i9> %x)
  ret <3 x i24> %res
}

define <4 x i18> @any_extend_v8i9_to_v4i18(<8 x i9> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <4 x i18> @llvm.colossus.SDAG.unary.v4i18.v8i9(i32 %id, <8 x i9> %x)
  ret <4 x i18> %res
}

define <6 x i12> @any_extend_v8i9_to_v6i12(<8 x i9> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <6 x i12> @llvm.colossus.SDAG.unary.v6i12.v8i9(i32 %id, <8 x i9> %x)
  ret <6 x i12> %res
}

define <2 x i40> @any_extend_v8i10_to_v2i40(<8 x i10> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i40> @llvm.colossus.SDAG.unary.v2i40.v8i10(i32 %id, <8 x i10> %x)
  ret <2 x i40> %res
}

define <4 x i20> @any_extend_v8i10_to_v4i20(<8 x i10> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <4 x i20> @llvm.colossus.SDAG.unary.v4i20.v8i10(i32 %id, <8 x i10> %x)
  ret <4 x i20> %res
}

define <5 x i16> @any_extend_v8i10_to_v5i16(<8 x i10> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <5 x i16> @llvm.colossus.SDAG.unary.v5i16.v8i10(i32 %id, <8 x i10> %x)
  ret <5 x i16> %res
}

define <2 x i44> @any_extend_v8i11_to_v2i44(<8 x i11> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i44> @llvm.colossus.SDAG.unary.v2i44.v8i11(i32 %id, <8 x i11> %x)
  ret <2 x i44> %res
}

define <4 x i22> @any_extend_v8i11_to_v4i22(<8 x i11> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <4 x i22> @llvm.colossus.SDAG.unary.v4i22.v8i11(i32 %id, <8 x i11> %x)
  ret <4 x i22> %res
}

define <2 x i48> @any_extend_v8i12_to_v2i48(<8 x i12> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i48> @llvm.colossus.SDAG.unary.v2i48.v8i12(i32 %id, <8 x i12> %x)
  ret <2 x i48> %res
}

define <3 x i32> @any_extend_v8i12_to_v3i32(<8 x i12> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <3 x i32> @llvm.colossus.SDAG.unary.v3i32.v8i12(i32 %id, <8 x i12> %x)
  ret <3 x i32> %res
}

define <4 x i24> @any_extend_v8i12_to_v4i24(<8 x i12> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <4 x i24> @llvm.colossus.SDAG.unary.v4i24.v8i12(i32 %id, <8 x i12> %x)
  ret <4 x i24> %res
}

define <6 x i16> @any_extend_v8i12_to_v6i16(<8 x i12> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <6 x i16> @llvm.colossus.SDAG.unary.v6i16.v8i12(i32 %id, <8 x i12> %x)
  ret <6 x i16> %res
}

define <2 x i52> @any_extend_v8i13_to_v2i52(<8 x i13> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i52> @llvm.colossus.SDAG.unary.v2i52.v8i13(i32 %id, <8 x i13> %x)
  ret <2 x i52> %res
}

define <4 x i26> @any_extend_v8i13_to_v4i26(<8 x i13> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <4 x i26> @llvm.colossus.SDAG.unary.v4i26.v8i13(i32 %id, <8 x i13> %x)
  ret <4 x i26> %res
}

define <2 x i56> @any_extend_v8i14_to_v2i56(<8 x i14> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i56> @llvm.colossus.SDAG.unary.v2i56.v8i14(i32 %id, <8 x i14> %x)
  ret <2 x i56> %res
}

define <4 x i28> @any_extend_v8i14_to_v4i28(<8 x i14> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <4 x i28> @llvm.colossus.SDAG.unary.v4i28.v8i14(i32 %id, <8 x i14> %x)
  ret <4 x i28> %res
}

define <7 x i16> @any_extend_v8i14_to_v7i16(<8 x i14> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <7 x i16> @llvm.colossus.SDAG.unary.v7i16.v8i14(i32 %id, <8 x i14> %x)
  ret <7 x i16> %res
}

define <2 x i60> @any_extend_v8i15_to_v2i60(<8 x i15> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i60> @llvm.colossus.SDAG.unary.v2i60.v8i15(i32 %id, <8 x i15> %x)
  ret <2 x i60> %res
}

define <3 x i40> @any_extend_v8i15_to_v3i40(<8 x i15> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <3 x i40> @llvm.colossus.SDAG.unary.v3i40.v8i15(i32 %id, <8 x i15> %x)
  ret <3 x i40> %res
}

define <4 x i30> @any_extend_v8i15_to_v4i30(<8 x i15> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <4 x i30> @llvm.colossus.SDAG.unary.v4i30.v8i15(i32 %id, <8 x i15> %x)
  ret <4 x i30> %res
}

define <5 x i24> @any_extend_v8i15_to_v5i24(<8 x i15> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <5 x i24> @llvm.colossus.SDAG.unary.v5i24.v8i15(i32 %id, <8 x i15> %x)
  ret <5 x i24> %res
}

define <6 x i20> @any_extend_v8i15_to_v6i20(<8 x i15> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <6 x i20> @llvm.colossus.SDAG.unary.v6i20.v8i15(i32 %id, <8 x i15> %x)
  ret <6 x i20> %res
}

define <2 x i64> @any_extend_v8i16_to_v2i64(<8 x i16> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <2 x i64> @llvm.colossus.SDAG.unary.v2i64.v8i16(i32 %id, <8 x i16> %x)
  ret <2 x i64> %res
}

define <4 x i32> @any_extend_v8i16_to_v4i32(<8 x i16> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <4 x i32> @llvm.colossus.SDAG.unary.v4i32.v8i16(i32 %id, <8 x i16> %x)
  ret <4 x i32> %res
}

define <4 x i34> @any_extend_v8i17_to_v4i34(<8 x i17> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <4 x i34> @llvm.colossus.SDAG.unary.v4i34.v8i17(i32 %id, <8 x i17> %x)
  ret <4 x i34> %res
}

define <3 x i48> @any_extend_v8i18_to_v3i48(<8 x i18> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <3 x i48> @llvm.colossus.SDAG.unary.v3i48.v8i18(i32 %id, <8 x i18> %x)
  ret <3 x i48> %res
}

define <4 x i36> @any_extend_v8i18_to_v4i36(<8 x i18> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <4 x i36> @llvm.colossus.SDAG.unary.v4i36.v8i18(i32 %id, <8 x i18> %x)
  ret <4 x i36> %res
}

define <6 x i24> @any_extend_v8i18_to_v6i24(<8 x i18> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <6 x i24> @llvm.colossus.SDAG.unary.v6i24.v8i18(i32 %id, <8 x i18> %x)
  ret <6 x i24> %res
}

define <4 x i38> @any_extend_v8i19_to_v4i38(<8 x i19> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <4 x i38> @llvm.colossus.SDAG.unary.v4i38.v8i19(i32 %id, <8 x i19> %x)
  ret <4 x i38> %res
}

define <4 x i40> @any_extend_v8i20_to_v4i40(<8 x i20> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <4 x i40> @llvm.colossus.SDAG.unary.v4i40.v8i20(i32 %id, <8 x i20> %x)
  ret <4 x i40> %res
}

define <5 x i32> @any_extend_v8i20_to_v5i32(<8 x i20> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <5 x i32> @llvm.colossus.SDAG.unary.v5i32.v8i20(i32 %id, <8 x i20> %x)
  ret <5 x i32> %res
}

define <3 x i56> @any_extend_v8i21_to_v3i56(<8 x i21> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <3 x i56> @llvm.colossus.SDAG.unary.v3i56.v8i21(i32 %id, <8 x i21> %x)
  ret <3 x i56> %res
}

define <4 x i42> @any_extend_v8i21_to_v4i42(<8 x i21> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <4 x i42> @llvm.colossus.SDAG.unary.v4i42.v8i21(i32 %id, <8 x i21> %x)
  ret <4 x i42> %res
}

define <6 x i28> @any_extend_v8i21_to_v6i28(<8 x i21> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <6 x i28> @llvm.colossus.SDAG.unary.v6i28.v8i21(i32 %id, <8 x i21> %x)
  ret <6 x i28> %res
}

define <7 x i24> @any_extend_v8i21_to_v7i24(<8 x i21> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <7 x i24> @llvm.colossus.SDAG.unary.v7i24.v8i21(i32 %id, <8 x i21> %x)
  ret <7 x i24> %res
}

define <4 x i44> @any_extend_v8i22_to_v4i44(<8 x i22> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <4 x i44> @llvm.colossus.SDAG.unary.v4i44.v8i22(i32 %id, <8 x i22> %x)
  ret <4 x i44> %res
}

define <4 x i46> @any_extend_v8i23_to_v4i46(<8 x i23> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <4 x i46> @llvm.colossus.SDAG.unary.v4i46.v8i23(i32 %id, <8 x i23> %x)
  ret <4 x i46> %res
}

define <3 x i64> @any_extend_v8i24_to_v3i64(<8 x i24> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <3 x i64> @llvm.colossus.SDAG.unary.v3i64.v8i24(i32 %id, <8 x i24> %x)
  ret <3 x i64> %res
}

define <4 x i48> @any_extend_v8i24_to_v4i48(<8 x i24> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <4 x i48> @llvm.colossus.SDAG.unary.v4i48.v8i24(i32 %id, <8 x i24> %x)
  ret <4 x i48> %res
}

define <6 x i32> @any_extend_v8i24_to_v6i32(<8 x i24> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <6 x i32> @llvm.colossus.SDAG.unary.v6i32.v8i24(i32 %id, <8 x i24> %x)
  ret <6 x i32> %res
}

define <4 x i50> @any_extend_v8i25_to_v4i50(<8 x i25> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <4 x i50> @llvm.colossus.SDAG.unary.v4i50.v8i25(i32 %id, <8 x i25> %x)
  ret <4 x i50> %res
}

define <5 x i40> @any_extend_v8i25_to_v5i40(<8 x i25> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <5 x i40> @llvm.colossus.SDAG.unary.v5i40.v8i25(i32 %id, <8 x i25> %x)
  ret <5 x i40> %res
}

define <4 x i52> @any_extend_v8i26_to_v4i52(<8 x i26> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <4 x i52> @llvm.colossus.SDAG.unary.v4i52.v8i26(i32 %id, <8 x i26> %x)
  ret <4 x i52> %res
}

define <4 x i54> @any_extend_v8i27_to_v4i54(<8 x i27> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <4 x i54> @llvm.colossus.SDAG.unary.v4i54.v8i27(i32 %id, <8 x i27> %x)
  ret <4 x i54> %res
}

define <6 x i36> @any_extend_v8i27_to_v6i36(<8 x i27> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <6 x i36> @llvm.colossus.SDAG.unary.v6i36.v8i27(i32 %id, <8 x i27> %x)
  ret <6 x i36> %res
}

define <4 x i56> @any_extend_v8i28_to_v4i56(<8 x i28> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <4 x i56> @llvm.colossus.SDAG.unary.v4i56.v8i28(i32 %id, <8 x i28> %x)
  ret <4 x i56> %res
}

define <7 x i32> @any_extend_v8i28_to_v7i32(<8 x i28> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <7 x i32> @llvm.colossus.SDAG.unary.v7i32.v8i28(i32 %id, <8 x i28> %x)
  ret <7 x i32> %res
}

define <4 x i58> @any_extend_v8i29_to_v4i58(<8 x i29> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <4 x i58> @llvm.colossus.SDAG.unary.v4i58.v8i29(i32 %id, <8 x i29> %x)
  ret <4 x i58> %res
}

define <4 x i60> @any_extend_v8i30_to_v4i60(<8 x i30> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <4 x i60> @llvm.colossus.SDAG.unary.v4i60.v8i30(i32 %id, <8 x i30> %x)
  ret <4 x i60> %res
}

define <5 x i48> @any_extend_v8i30_to_v5i48(<8 x i30> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <5 x i48> @llvm.colossus.SDAG.unary.v5i48.v8i30(i32 %id, <8 x i30> %x)
  ret <5 x i48> %res
}

define <6 x i40> @any_extend_v8i30_to_v6i40(<8 x i30> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <6 x i40> @llvm.colossus.SDAG.unary.v6i40.v8i30(i32 %id, <8 x i30> %x)
  ret <6 x i40> %res
}

define <4 x i62> @any_extend_v8i31_to_v4i62(<8 x i31> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <4 x i62> @llvm.colossus.SDAG.unary.v4i62.v8i31(i32 %id, <8 x i31> %x)
  ret <4 x i62> %res
}

define <4 x i64> @any_extend_v8i32_to_v4i64(<8 x i32> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <4 x i64> @llvm.colossus.SDAG.unary.v4i64.v8i32(i32 %id, <8 x i32> %x)
  ret <4 x i64> %res
}

define <6 x i44> @any_extend_v8i33_to_v6i44(<8 x i33> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <6 x i44> @llvm.colossus.SDAG.unary.v6i44.v8i33(i32 %id, <8 x i33> %x)
  ret <6 x i44> %res
}

define <5 x i56> @any_extend_v8i35_to_v5i56(<8 x i35> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <5 x i56> @llvm.colossus.SDAG.unary.v5i56.v8i35(i32 %id, <8 x i35> %x)
  ret <5 x i56> %res
}

define <7 x i40> @any_extend_v8i35_to_v7i40(<8 x i35> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <7 x i40> @llvm.colossus.SDAG.unary.v7i40.v8i35(i32 %id, <8 x i35> %x)
  ret <7 x i40> %res
}

define <6 x i48> @any_extend_v8i36_to_v6i48(<8 x i36> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <6 x i48> @llvm.colossus.SDAG.unary.v6i48.v8i36(i32 %id, <8 x i36> %x)
  ret <6 x i48> %res
}

define <6 x i52> @any_extend_v8i39_to_v6i52(<8 x i39> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <6 x i52> @llvm.colossus.SDAG.unary.v6i52.v8i39(i32 %id, <8 x i39> %x)
  ret <6 x i52> %res
}

define <5 x i64> @any_extend_v8i40_to_v5i64(<8 x i40> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <5 x i64> @llvm.colossus.SDAG.unary.v5i64.v8i40(i32 %id, <8 x i40> %x)
  ret <5 x i64> %res
}

define <6 x i56> @any_extend_v8i42_to_v6i56(<8 x i42> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <6 x i56> @llvm.colossus.SDAG.unary.v6i56.v8i42(i32 %id, <8 x i42> %x)
  ret <6 x i56> %res
}

define <7 x i48> @any_extend_v8i42_to_v7i48(<8 x i42> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <7 x i48> @llvm.colossus.SDAG.unary.v7i48.v8i42(i32 %id, <8 x i42> %x)
  ret <7 x i48> %res
}

define <6 x i60> @any_extend_v8i45_to_v6i60(<8 x i45> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <6 x i60> @llvm.colossus.SDAG.unary.v6i60.v8i45(i32 %id, <8 x i45> %x)
  ret <6 x i60> %res
}

define <6 x i64> @any_extend_v8i48_to_v6i64(<8 x i48> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <6 x i64> @llvm.colossus.SDAG.unary.v6i64.v8i48(i32 %id, <8 x i48> %x)
  ret <6 x i64> %res
}

define <7 x i56> @any_extend_v8i49_to_v7i56(<8 x i49> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <7 x i56> @llvm.colossus.SDAG.unary.v7i56.v8i49(i32 %id, <8 x i49> %x)
  ret <7 x i56> %res
}

define <7 x i64> @any_extend_v8i56_to_v7i64(<8 x i56> %x) {
  %id = load i32, i32* @ISD_ANY_EXTEND_VECTOR_INREG
  %res = call <7 x i64> @llvm.colossus.SDAG.unary.v7i64.v8i56(i32 %id, <8 x i56> %x)
  ret <7 x i64> %res
}

define <1 x i2> @sign_extend_v2i1_to_v1i2(<2 x i1> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <1 x i2> @llvm.colossus.SDAG.unary.v1i2.v2i1(i32 %id, <2 x i1> %x)
  ret <1 x i2> %res
}

define <1 x i4> @sign_extend_v2i2_to_v1i4(<2 x i2> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <1 x i4> @llvm.colossus.SDAG.unary.v1i4.v2i2(i32 %id, <2 x i2> %x)
  ret <1 x i4> %res
}

define <1 x i6> @sign_extend_v2i3_to_v1i6(<2 x i3> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <1 x i6> @llvm.colossus.SDAG.unary.v1i6.v2i3(i32 %id, <2 x i3> %x)
  ret <1 x i6> %res
}

define <1 x i8> @sign_extend_v2i4_to_v1i8(<2 x i4> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <1 x i8> @llvm.colossus.SDAG.unary.v1i8.v2i4(i32 %id, <2 x i4> %x)
  ret <1 x i8> %res
}

define <1 x i10> @sign_extend_v2i5_to_v1i10(<2 x i5> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <1 x i10> @llvm.colossus.SDAG.unary.v1i10.v2i5(i32 %id, <2 x i5> %x)
  ret <1 x i10> %res
}

define <1 x i12> @sign_extend_v2i6_to_v1i12(<2 x i6> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <1 x i12> @llvm.colossus.SDAG.unary.v1i12.v2i6(i32 %id, <2 x i6> %x)
  ret <1 x i12> %res
}

define <1 x i14> @sign_extend_v2i7_to_v1i14(<2 x i7> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <1 x i14> @llvm.colossus.SDAG.unary.v1i14.v2i7(i32 %id, <2 x i7> %x)
  ret <1 x i14> %res
}

define <1 x i16> @sign_extend_v2i8_to_v1i16(<2 x i8> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <1 x i16> @llvm.colossus.SDAG.unary.v1i16.v2i8(i32 %id, <2 x i8> %x)
  ret <1 x i16> %res
}

define <1 x i18> @sign_extend_v2i9_to_v1i18(<2 x i9> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <1 x i18> @llvm.colossus.SDAG.unary.v1i18.v2i9(i32 %id, <2 x i9> %x)
  ret <1 x i18> %res
}

define <1 x i20> @sign_extend_v2i10_to_v1i20(<2 x i10> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <1 x i20> @llvm.colossus.SDAG.unary.v1i20.v2i10(i32 %id, <2 x i10> %x)
  ret <1 x i20> %res
}

define <1 x i22> @sign_extend_v2i11_to_v1i22(<2 x i11> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <1 x i22> @llvm.colossus.SDAG.unary.v1i22.v2i11(i32 %id, <2 x i11> %x)
  ret <1 x i22> %res
}

define <1 x i24> @sign_extend_v2i12_to_v1i24(<2 x i12> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <1 x i24> @llvm.colossus.SDAG.unary.v1i24.v2i12(i32 %id, <2 x i12> %x)
  ret <1 x i24> %res
}

define <1 x i26> @sign_extend_v2i13_to_v1i26(<2 x i13> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <1 x i26> @llvm.colossus.SDAG.unary.v1i26.v2i13(i32 %id, <2 x i13> %x)
  ret <1 x i26> %res
}

define <1 x i28> @sign_extend_v2i14_to_v1i28(<2 x i14> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <1 x i28> @llvm.colossus.SDAG.unary.v1i28.v2i14(i32 %id, <2 x i14> %x)
  ret <1 x i28> %res
}

define <1 x i30> @sign_extend_v2i15_to_v1i30(<2 x i15> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <1 x i30> @llvm.colossus.SDAG.unary.v1i30.v2i15(i32 %id, <2 x i15> %x)
  ret <1 x i30> %res
}

define <1 x i32> @sign_extend_v2i16_to_v1i32(<2 x i16> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <1 x i32> @llvm.colossus.SDAG.unary.v1i32.v2i16(i32 %id, <2 x i16> %x)
  ret <1 x i32> %res
}

define <1 x i34> @sign_extend_v2i17_to_v1i34(<2 x i17> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <1 x i34> @llvm.colossus.SDAG.unary.v1i34.v2i17(i32 %id, <2 x i17> %x)
  ret <1 x i34> %res
}

define <1 x i36> @sign_extend_v2i18_to_v1i36(<2 x i18> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <1 x i36> @llvm.colossus.SDAG.unary.v1i36.v2i18(i32 %id, <2 x i18> %x)
  ret <1 x i36> %res
}

define <1 x i38> @sign_extend_v2i19_to_v1i38(<2 x i19> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <1 x i38> @llvm.colossus.SDAG.unary.v1i38.v2i19(i32 %id, <2 x i19> %x)
  ret <1 x i38> %res
}

define <1 x i40> @sign_extend_v2i20_to_v1i40(<2 x i20> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <1 x i40> @llvm.colossus.SDAG.unary.v1i40.v2i20(i32 %id, <2 x i20> %x)
  ret <1 x i40> %res
}

define <1 x i42> @sign_extend_v2i21_to_v1i42(<2 x i21> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <1 x i42> @llvm.colossus.SDAG.unary.v1i42.v2i21(i32 %id, <2 x i21> %x)
  ret <1 x i42> %res
}

define <1 x i44> @sign_extend_v2i22_to_v1i44(<2 x i22> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <1 x i44> @llvm.colossus.SDAG.unary.v1i44.v2i22(i32 %id, <2 x i22> %x)
  ret <1 x i44> %res
}

define <1 x i46> @sign_extend_v2i23_to_v1i46(<2 x i23> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <1 x i46> @llvm.colossus.SDAG.unary.v1i46.v2i23(i32 %id, <2 x i23> %x)
  ret <1 x i46> %res
}

define <1 x i48> @sign_extend_v2i24_to_v1i48(<2 x i24> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <1 x i48> @llvm.colossus.SDAG.unary.v1i48.v2i24(i32 %id, <2 x i24> %x)
  ret <1 x i48> %res
}

define <1 x i50> @sign_extend_v2i25_to_v1i50(<2 x i25> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <1 x i50> @llvm.colossus.SDAG.unary.v1i50.v2i25(i32 %id, <2 x i25> %x)
  ret <1 x i50> %res
}

define <1 x i52> @sign_extend_v2i26_to_v1i52(<2 x i26> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <1 x i52> @llvm.colossus.SDAG.unary.v1i52.v2i26(i32 %id, <2 x i26> %x)
  ret <1 x i52> %res
}

define <1 x i54> @sign_extend_v2i27_to_v1i54(<2 x i27> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <1 x i54> @llvm.colossus.SDAG.unary.v1i54.v2i27(i32 %id, <2 x i27> %x)
  ret <1 x i54> %res
}

define <1 x i56> @sign_extend_v2i28_to_v1i56(<2 x i28> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <1 x i56> @llvm.colossus.SDAG.unary.v1i56.v2i28(i32 %id, <2 x i28> %x)
  ret <1 x i56> %res
}

define <1 x i58> @sign_extend_v2i29_to_v1i58(<2 x i29> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <1 x i58> @llvm.colossus.SDAG.unary.v1i58.v2i29(i32 %id, <2 x i29> %x)
  ret <1 x i58> %res
}

define <1 x i60> @sign_extend_v2i30_to_v1i60(<2 x i30> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <1 x i60> @llvm.colossus.SDAG.unary.v1i60.v2i30(i32 %id, <2 x i30> %x)
  ret <1 x i60> %res
}

define <1 x i62> @sign_extend_v2i31_to_v1i62(<2 x i31> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <1 x i62> @llvm.colossus.SDAG.unary.v1i62.v2i31(i32 %id, <2 x i31> %x)
  ret <1 x i62> %res
}

define <1 x i64> @sign_extend_v2i32_to_v1i64(<2 x i32> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <1 x i64> @llvm.colossus.SDAG.unary.v1i64.v2i32(i32 %id, <2 x i32> %x)
  ret <1 x i64> %res
}

define <1 x i3> @sign_extend_v3i1_to_v1i3(<3 x i1> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <1 x i3> @llvm.colossus.SDAG.unary.v1i3.v3i1(i32 %id, <3 x i1> %x)
  ret <1 x i3> %res
}

define <1 x i6> @sign_extend_v3i2_to_v1i6(<3 x i2> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <1 x i6> @llvm.colossus.SDAG.unary.v1i6.v3i2(i32 %id, <3 x i2> %x)
  ret <1 x i6> %res
}

define <2 x i3> @sign_extend_v3i2_to_v2i3(<3 x i2> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i3> @llvm.colossus.SDAG.unary.v2i3.v3i2(i32 %id, <3 x i2> %x)
  ret <2 x i3> %res
}

define <1 x i9> @sign_extend_v3i3_to_v1i9(<3 x i3> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <1 x i9> @llvm.colossus.SDAG.unary.v1i9.v3i3(i32 %id, <3 x i3> %x)
  ret <1 x i9> %res
}

define <1 x i12> @sign_extend_v3i4_to_v1i12(<3 x i4> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <1 x i12> @llvm.colossus.SDAG.unary.v1i12.v3i4(i32 %id, <3 x i4> %x)
  ret <1 x i12> %res
}

define <2 x i6> @sign_extend_v3i4_to_v2i6(<3 x i4> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i6> @llvm.colossus.SDAG.unary.v2i6.v3i4(i32 %id, <3 x i4> %x)
  ret <2 x i6> %res
}

define <1 x i15> @sign_extend_v3i5_to_v1i15(<3 x i5> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <1 x i15> @llvm.colossus.SDAG.unary.v1i15.v3i5(i32 %id, <3 x i5> %x)
  ret <1 x i15> %res
}

define <1 x i18> @sign_extend_v3i6_to_v1i18(<3 x i6> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <1 x i18> @llvm.colossus.SDAG.unary.v1i18.v3i6(i32 %id, <3 x i6> %x)
  ret <1 x i18> %res
}

define <2 x i9> @sign_extend_v3i6_to_v2i9(<3 x i6> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i9> @llvm.colossus.SDAG.unary.v2i9.v3i6(i32 %id, <3 x i6> %x)
  ret <2 x i9> %res
}

define <1 x i21> @sign_extend_v3i7_to_v1i21(<3 x i7> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <1 x i21> @llvm.colossus.SDAG.unary.v1i21.v3i7(i32 %id, <3 x i7> %x)
  ret <1 x i21> %res
}

define <1 x i24> @sign_extend_v3i8_to_v1i24(<3 x i8> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <1 x i24> @llvm.colossus.SDAG.unary.v1i24.v3i8(i32 %id, <3 x i8> %x)
  ret <1 x i24> %res
}

define <2 x i12> @sign_extend_v3i8_to_v2i12(<3 x i8> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i12> @llvm.colossus.SDAG.unary.v2i12.v3i8(i32 %id, <3 x i8> %x)
  ret <2 x i12> %res
}

define <1 x i27> @sign_extend_v3i9_to_v1i27(<3 x i9> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <1 x i27> @llvm.colossus.SDAG.unary.v1i27.v3i9(i32 %id, <3 x i9> %x)
  ret <1 x i27> %res
}

define <1 x i30> @sign_extend_v3i10_to_v1i30(<3 x i10> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <1 x i30> @llvm.colossus.SDAG.unary.v1i30.v3i10(i32 %id, <3 x i10> %x)
  ret <1 x i30> %res
}

define <2 x i15> @sign_extend_v3i10_to_v2i15(<3 x i10> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i15> @llvm.colossus.SDAG.unary.v2i15.v3i10(i32 %id, <3 x i10> %x)
  ret <2 x i15> %res
}

define <1 x i33> @sign_extend_v3i11_to_v1i33(<3 x i11> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <1 x i33> @llvm.colossus.SDAG.unary.v1i33.v3i11(i32 %id, <3 x i11> %x)
  ret <1 x i33> %res
}

define <1 x i36> @sign_extend_v3i12_to_v1i36(<3 x i12> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <1 x i36> @llvm.colossus.SDAG.unary.v1i36.v3i12(i32 %id, <3 x i12> %x)
  ret <1 x i36> %res
}

define <2 x i18> @sign_extend_v3i12_to_v2i18(<3 x i12> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i18> @llvm.colossus.SDAG.unary.v2i18.v3i12(i32 %id, <3 x i12> %x)
  ret <2 x i18> %res
}

define <1 x i39> @sign_extend_v3i13_to_v1i39(<3 x i13> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <1 x i39> @llvm.colossus.SDAG.unary.v1i39.v3i13(i32 %id, <3 x i13> %x)
  ret <1 x i39> %res
}

define <1 x i42> @sign_extend_v3i14_to_v1i42(<3 x i14> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <1 x i42> @llvm.colossus.SDAG.unary.v1i42.v3i14(i32 %id, <3 x i14> %x)
  ret <1 x i42> %res
}

define <2 x i21> @sign_extend_v3i14_to_v2i21(<3 x i14> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i21> @llvm.colossus.SDAG.unary.v2i21.v3i14(i32 %id, <3 x i14> %x)
  ret <2 x i21> %res
}

define <1 x i45> @sign_extend_v3i15_to_v1i45(<3 x i15> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <1 x i45> @llvm.colossus.SDAG.unary.v1i45.v3i15(i32 %id, <3 x i15> %x)
  ret <1 x i45> %res
}

define <1 x i48> @sign_extend_v3i16_to_v1i48(<3 x i16> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <1 x i48> @llvm.colossus.SDAG.unary.v1i48.v3i16(i32 %id, <3 x i16> %x)
  ret <1 x i48> %res
}

define <2 x i24> @sign_extend_v3i16_to_v2i24(<3 x i16> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i24> @llvm.colossus.SDAG.unary.v2i24.v3i16(i32 %id, <3 x i16> %x)
  ret <2 x i24> %res
}

define <1 x i51> @sign_extend_v3i17_to_v1i51(<3 x i17> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <1 x i51> @llvm.colossus.SDAG.unary.v1i51.v3i17(i32 %id, <3 x i17> %x)
  ret <1 x i51> %res
}

define <1 x i54> @sign_extend_v3i18_to_v1i54(<3 x i18> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <1 x i54> @llvm.colossus.SDAG.unary.v1i54.v3i18(i32 %id, <3 x i18> %x)
  ret <1 x i54> %res
}

define <2 x i27> @sign_extend_v3i18_to_v2i27(<3 x i18> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i27> @llvm.colossus.SDAG.unary.v2i27.v3i18(i32 %id, <3 x i18> %x)
  ret <2 x i27> %res
}

define <1 x i57> @sign_extend_v3i19_to_v1i57(<3 x i19> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <1 x i57> @llvm.colossus.SDAG.unary.v1i57.v3i19(i32 %id, <3 x i19> %x)
  ret <1 x i57> %res
}

define <1 x i60> @sign_extend_v3i20_to_v1i60(<3 x i20> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <1 x i60> @llvm.colossus.SDAG.unary.v1i60.v3i20(i32 %id, <3 x i20> %x)
  ret <1 x i60> %res
}

define <2 x i30> @sign_extend_v3i20_to_v2i30(<3 x i20> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i30> @llvm.colossus.SDAG.unary.v2i30.v3i20(i32 %id, <3 x i20> %x)
  ret <2 x i30> %res
}

define <1 x i63> @sign_extend_v3i21_to_v1i63(<3 x i21> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <1 x i63> @llvm.colossus.SDAG.unary.v1i63.v3i21(i32 %id, <3 x i21> %x)
  ret <1 x i63> %res
}

define <2 x i33> @sign_extend_v3i22_to_v2i33(<3 x i22> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i33> @llvm.colossus.SDAG.unary.v2i33.v3i22(i32 %id, <3 x i22> %x)
  ret <2 x i33> %res
}

define <2 x i36> @sign_extend_v3i24_to_v2i36(<3 x i24> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i36> @llvm.colossus.SDAG.unary.v2i36.v3i24(i32 %id, <3 x i24> %x)
  ret <2 x i36> %res
}

define <2 x i39> @sign_extend_v3i26_to_v2i39(<3 x i26> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i39> @llvm.colossus.SDAG.unary.v2i39.v3i26(i32 %id, <3 x i26> %x)
  ret <2 x i39> %res
}

define <2 x i42> @sign_extend_v3i28_to_v2i42(<3 x i28> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i42> @llvm.colossus.SDAG.unary.v2i42.v3i28(i32 %id, <3 x i28> %x)
  ret <2 x i42> %res
}

define <2 x i45> @sign_extend_v3i30_to_v2i45(<3 x i30> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i45> @llvm.colossus.SDAG.unary.v2i45.v3i30(i32 %id, <3 x i30> %x)
  ret <2 x i45> %res
}

define <2 x i48> @sign_extend_v3i32_to_v2i48(<3 x i32> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i48> @llvm.colossus.SDAG.unary.v2i48.v3i32(i32 %id, <3 x i32> %x)
  ret <2 x i48> %res
}

define <2 x i51> @sign_extend_v3i34_to_v2i51(<3 x i34> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i51> @llvm.colossus.SDAG.unary.v2i51.v3i34(i32 %id, <3 x i34> %x)
  ret <2 x i51> %res
}

define <2 x i54> @sign_extend_v3i36_to_v2i54(<3 x i36> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i54> @llvm.colossus.SDAG.unary.v2i54.v3i36(i32 %id, <3 x i36> %x)
  ret <2 x i54> %res
}

define <2 x i57> @sign_extend_v3i38_to_v2i57(<3 x i38> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i57> @llvm.colossus.SDAG.unary.v2i57.v3i38(i32 %id, <3 x i38> %x)
  ret <2 x i57> %res
}

define <2 x i60> @sign_extend_v3i40_to_v2i60(<3 x i40> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i60> @llvm.colossus.SDAG.unary.v2i60.v3i40(i32 %id, <3 x i40> %x)
  ret <2 x i60> %res
}

define <2 x i63> @sign_extend_v3i42_to_v2i63(<3 x i42> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i63> @llvm.colossus.SDAG.unary.v2i63.v3i42(i32 %id, <3 x i42> %x)
  ret <2 x i63> %res
}

define <1 x i4> @sign_extend_v4i1_to_v1i4(<4 x i1> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <1 x i4> @llvm.colossus.SDAG.unary.v1i4.v4i1(i32 %id, <4 x i1> %x)
  ret <1 x i4> %res
}

define <2 x i2> @sign_extend_v4i1_to_v2i2(<4 x i1> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i2> @llvm.colossus.SDAG.unary.v2i2.v4i1(i32 %id, <4 x i1> %x)
  ret <2 x i2> %res
}

define <1 x i8> @sign_extend_v4i2_to_v1i8(<4 x i2> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <1 x i8> @llvm.colossus.SDAG.unary.v1i8.v4i2(i32 %id, <4 x i2> %x)
  ret <1 x i8> %res
}

define <2 x i4> @sign_extend_v4i2_to_v2i4(<4 x i2> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i4> @llvm.colossus.SDAG.unary.v2i4.v4i2(i32 %id, <4 x i2> %x)
  ret <2 x i4> %res
}

define <1 x i12> @sign_extend_v4i3_to_v1i12(<4 x i3> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <1 x i12> @llvm.colossus.SDAG.unary.v1i12.v4i3(i32 %id, <4 x i3> %x)
  ret <1 x i12> %res
}

define <2 x i6> @sign_extend_v4i3_to_v2i6(<4 x i3> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i6> @llvm.colossus.SDAG.unary.v2i6.v4i3(i32 %id, <4 x i3> %x)
  ret <2 x i6> %res
}

define <1 x i16> @sign_extend_v4i4_to_v1i16(<4 x i4> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <1 x i16> @llvm.colossus.SDAG.unary.v1i16.v4i4(i32 %id, <4 x i4> %x)
  ret <1 x i16> %res
}

define <2 x i8> @sign_extend_v4i4_to_v2i8(<4 x i4> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i8> @llvm.colossus.SDAG.unary.v2i8.v4i4(i32 %id, <4 x i4> %x)
  ret <2 x i8> %res
}

define <1 x i20> @sign_extend_v4i5_to_v1i20(<4 x i5> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <1 x i20> @llvm.colossus.SDAG.unary.v1i20.v4i5(i32 %id, <4 x i5> %x)
  ret <1 x i20> %res
}

define <2 x i10> @sign_extend_v4i5_to_v2i10(<4 x i5> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i10> @llvm.colossus.SDAG.unary.v2i10.v4i5(i32 %id, <4 x i5> %x)
  ret <2 x i10> %res
}

define <1 x i24> @sign_extend_v4i6_to_v1i24(<4 x i6> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <1 x i24> @llvm.colossus.SDAG.unary.v1i24.v4i6(i32 %id, <4 x i6> %x)
  ret <1 x i24> %res
}

define <2 x i12> @sign_extend_v4i6_to_v2i12(<4 x i6> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i12> @llvm.colossus.SDAG.unary.v2i12.v4i6(i32 %id, <4 x i6> %x)
  ret <2 x i12> %res
}

define <1 x i28> @sign_extend_v4i7_to_v1i28(<4 x i7> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <1 x i28> @llvm.colossus.SDAG.unary.v1i28.v4i7(i32 %id, <4 x i7> %x)
  ret <1 x i28> %res
}

define <2 x i14> @sign_extend_v4i7_to_v2i14(<4 x i7> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i14> @llvm.colossus.SDAG.unary.v2i14.v4i7(i32 %id, <4 x i7> %x)
  ret <2 x i14> %res
}

define <1 x i32> @sign_extend_v4i8_to_v1i32(<4 x i8> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <1 x i32> @llvm.colossus.SDAG.unary.v1i32.v4i8(i32 %id, <4 x i8> %x)
  ret <1 x i32> %res
}

define <2 x i16> @sign_extend_v4i8_to_v2i16(<4 x i8> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i16> @llvm.colossus.SDAG.unary.v2i16.v4i8(i32 %id, <4 x i8> %x)
  ret <2 x i16> %res
}

define <1 x i36> @sign_extend_v4i9_to_v1i36(<4 x i9> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <1 x i36> @llvm.colossus.SDAG.unary.v1i36.v4i9(i32 %id, <4 x i9> %x)
  ret <1 x i36> %res
}

define <2 x i18> @sign_extend_v4i9_to_v2i18(<4 x i9> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i18> @llvm.colossus.SDAG.unary.v2i18.v4i9(i32 %id, <4 x i9> %x)
  ret <2 x i18> %res
}

define <1 x i40> @sign_extend_v4i10_to_v1i40(<4 x i10> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <1 x i40> @llvm.colossus.SDAG.unary.v1i40.v4i10(i32 %id, <4 x i10> %x)
  ret <1 x i40> %res
}

define <2 x i20> @sign_extend_v4i10_to_v2i20(<4 x i10> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i20> @llvm.colossus.SDAG.unary.v2i20.v4i10(i32 %id, <4 x i10> %x)
  ret <2 x i20> %res
}

define <1 x i44> @sign_extend_v4i11_to_v1i44(<4 x i11> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <1 x i44> @llvm.colossus.SDAG.unary.v1i44.v4i11(i32 %id, <4 x i11> %x)
  ret <1 x i44> %res
}

define <2 x i22> @sign_extend_v4i11_to_v2i22(<4 x i11> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i22> @llvm.colossus.SDAG.unary.v2i22.v4i11(i32 %id, <4 x i11> %x)
  ret <2 x i22> %res
}

define <1 x i48> @sign_extend_v4i12_to_v1i48(<4 x i12> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <1 x i48> @llvm.colossus.SDAG.unary.v1i48.v4i12(i32 %id, <4 x i12> %x)
  ret <1 x i48> %res
}

define <2 x i24> @sign_extend_v4i12_to_v2i24(<4 x i12> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i24> @llvm.colossus.SDAG.unary.v2i24.v4i12(i32 %id, <4 x i12> %x)
  ret <2 x i24> %res
}

define <1 x i52> @sign_extend_v4i13_to_v1i52(<4 x i13> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <1 x i52> @llvm.colossus.SDAG.unary.v1i52.v4i13(i32 %id, <4 x i13> %x)
  ret <1 x i52> %res
}

define <2 x i26> @sign_extend_v4i13_to_v2i26(<4 x i13> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i26> @llvm.colossus.SDAG.unary.v2i26.v4i13(i32 %id, <4 x i13> %x)
  ret <2 x i26> %res
}

define <1 x i56> @sign_extend_v4i14_to_v1i56(<4 x i14> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <1 x i56> @llvm.colossus.SDAG.unary.v1i56.v4i14(i32 %id, <4 x i14> %x)
  ret <1 x i56> %res
}

define <2 x i28> @sign_extend_v4i14_to_v2i28(<4 x i14> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i28> @llvm.colossus.SDAG.unary.v2i28.v4i14(i32 %id, <4 x i14> %x)
  ret <2 x i28> %res
}

define <1 x i60> @sign_extend_v4i15_to_v1i60(<4 x i15> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <1 x i60> @llvm.colossus.SDAG.unary.v1i60.v4i15(i32 %id, <4 x i15> %x)
  ret <1 x i60> %res
}

define <2 x i30> @sign_extend_v4i15_to_v2i30(<4 x i15> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i30> @llvm.colossus.SDAG.unary.v2i30.v4i15(i32 %id, <4 x i15> %x)
  ret <2 x i30> %res
}

define <1 x i64> @sign_extend_v4i16_to_v1i64(<4 x i16> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <1 x i64> @llvm.colossus.SDAG.unary.v1i64.v4i16(i32 %id, <4 x i16> %x)
  ret <1 x i64> %res
}

define <2 x i32> @sign_extend_v4i16_to_v2i32(<4 x i16> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i32> @llvm.colossus.SDAG.unary.v2i32.v4i16(i32 %id, <4 x i16> %x)
  ret <2 x i32> %res
}

define <2 x i34> @sign_extend_v4i17_to_v2i34(<4 x i17> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i34> @llvm.colossus.SDAG.unary.v2i34.v4i17(i32 %id, <4 x i17> %x)
  ret <2 x i34> %res
}

define <2 x i36> @sign_extend_v4i18_to_v2i36(<4 x i18> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i36> @llvm.colossus.SDAG.unary.v2i36.v4i18(i32 %id, <4 x i18> %x)
  ret <2 x i36> %res
}

define <2 x i38> @sign_extend_v4i19_to_v2i38(<4 x i19> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i38> @llvm.colossus.SDAG.unary.v2i38.v4i19(i32 %id, <4 x i19> %x)
  ret <2 x i38> %res
}

define <2 x i40> @sign_extend_v4i20_to_v2i40(<4 x i20> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i40> @llvm.colossus.SDAG.unary.v2i40.v4i20(i32 %id, <4 x i20> %x)
  ret <2 x i40> %res
}

define <2 x i42> @sign_extend_v4i21_to_v2i42(<4 x i21> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i42> @llvm.colossus.SDAG.unary.v2i42.v4i21(i32 %id, <4 x i21> %x)
  ret <2 x i42> %res
}

define <2 x i44> @sign_extend_v4i22_to_v2i44(<4 x i22> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i44> @llvm.colossus.SDAG.unary.v2i44.v4i22(i32 %id, <4 x i22> %x)
  ret <2 x i44> %res
}

define <2 x i46> @sign_extend_v4i23_to_v2i46(<4 x i23> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i46> @llvm.colossus.SDAG.unary.v2i46.v4i23(i32 %id, <4 x i23> %x)
  ret <2 x i46> %res
}

define <2 x i48> @sign_extend_v4i24_to_v2i48(<4 x i24> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i48> @llvm.colossus.SDAG.unary.v2i48.v4i24(i32 %id, <4 x i24> %x)
  ret <2 x i48> %res
}

define <2 x i50> @sign_extend_v4i25_to_v2i50(<4 x i25> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i50> @llvm.colossus.SDAG.unary.v2i50.v4i25(i32 %id, <4 x i25> %x)
  ret <2 x i50> %res
}

define <2 x i52> @sign_extend_v4i26_to_v2i52(<4 x i26> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i52> @llvm.colossus.SDAG.unary.v2i52.v4i26(i32 %id, <4 x i26> %x)
  ret <2 x i52> %res
}

define <2 x i54> @sign_extend_v4i27_to_v2i54(<4 x i27> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i54> @llvm.colossus.SDAG.unary.v2i54.v4i27(i32 %id, <4 x i27> %x)
  ret <2 x i54> %res
}

define <2 x i56> @sign_extend_v4i28_to_v2i56(<4 x i28> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i56> @llvm.colossus.SDAG.unary.v2i56.v4i28(i32 %id, <4 x i28> %x)
  ret <2 x i56> %res
}

define <2 x i58> @sign_extend_v4i29_to_v2i58(<4 x i29> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i58> @llvm.colossus.SDAG.unary.v2i58.v4i29(i32 %id, <4 x i29> %x)
  ret <2 x i58> %res
}

define <2 x i60> @sign_extend_v4i30_to_v2i60(<4 x i30> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i60> @llvm.colossus.SDAG.unary.v2i60.v4i30(i32 %id, <4 x i30> %x)
  ret <2 x i60> %res
}

define <2 x i62> @sign_extend_v4i31_to_v2i62(<4 x i31> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i62> @llvm.colossus.SDAG.unary.v2i62.v4i31(i32 %id, <4 x i31> %x)
  ret <2 x i62> %res
}

define <2 x i64> @sign_extend_v4i32_to_v2i64(<4 x i32> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i64> @llvm.colossus.SDAG.unary.v2i64.v4i32(i32 %id, <4 x i32> %x)
  ret <2 x i64> %res
}

define <1 x i5> @sign_extend_v5i1_to_v1i5(<5 x i1> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <1 x i5> @llvm.colossus.SDAG.unary.v1i5.v5i1(i32 %id, <5 x i1> %x)
  ret <1 x i5> %res
}

define <1 x i10> @sign_extend_v5i2_to_v1i10(<5 x i2> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <1 x i10> @llvm.colossus.SDAG.unary.v1i10.v5i2(i32 %id, <5 x i2> %x)
  ret <1 x i10> %res
}

define <2 x i5> @sign_extend_v5i2_to_v2i5(<5 x i2> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i5> @llvm.colossus.SDAG.unary.v2i5.v5i2(i32 %id, <5 x i2> %x)
  ret <2 x i5> %res
}

define <1 x i15> @sign_extend_v5i3_to_v1i15(<5 x i3> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <1 x i15> @llvm.colossus.SDAG.unary.v1i15.v5i3(i32 %id, <5 x i3> %x)
  ret <1 x i15> %res
}

define <1 x i20> @sign_extend_v5i4_to_v1i20(<5 x i4> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <1 x i20> @llvm.colossus.SDAG.unary.v1i20.v5i4(i32 %id, <5 x i4> %x)
  ret <1 x i20> %res
}

define <2 x i10> @sign_extend_v5i4_to_v2i10(<5 x i4> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i10> @llvm.colossus.SDAG.unary.v2i10.v5i4(i32 %id, <5 x i4> %x)
  ret <2 x i10> %res
}

define <4 x i5> @sign_extend_v5i4_to_v4i5(<5 x i4> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <4 x i5> @llvm.colossus.SDAG.unary.v4i5.v5i4(i32 %id, <5 x i4> %x)
  ret <4 x i5> %res
}

define <1 x i25> @sign_extend_v5i5_to_v1i25(<5 x i5> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <1 x i25> @llvm.colossus.SDAG.unary.v1i25.v5i5(i32 %id, <5 x i5> %x)
  ret <1 x i25> %res
}

define <1 x i30> @sign_extend_v5i6_to_v1i30(<5 x i6> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <1 x i30> @llvm.colossus.SDAG.unary.v1i30.v5i6(i32 %id, <5 x i6> %x)
  ret <1 x i30> %res
}

define <2 x i15> @sign_extend_v5i6_to_v2i15(<5 x i6> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i15> @llvm.colossus.SDAG.unary.v2i15.v5i6(i32 %id, <5 x i6> %x)
  ret <2 x i15> %res
}

define <1 x i35> @sign_extend_v5i7_to_v1i35(<5 x i7> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <1 x i35> @llvm.colossus.SDAG.unary.v1i35.v5i7(i32 %id, <5 x i7> %x)
  ret <1 x i35> %res
}

define <1 x i40> @sign_extend_v5i8_to_v1i40(<5 x i8> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <1 x i40> @llvm.colossus.SDAG.unary.v1i40.v5i8(i32 %id, <5 x i8> %x)
  ret <1 x i40> %res
}

define <2 x i20> @sign_extend_v5i8_to_v2i20(<5 x i8> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i20> @llvm.colossus.SDAG.unary.v2i20.v5i8(i32 %id, <5 x i8> %x)
  ret <2 x i20> %res
}

define <4 x i10> @sign_extend_v5i8_to_v4i10(<5 x i8> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <4 x i10> @llvm.colossus.SDAG.unary.v4i10.v5i8(i32 %id, <5 x i8> %x)
  ret <4 x i10> %res
}

define <1 x i45> @sign_extend_v5i9_to_v1i45(<5 x i9> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <1 x i45> @llvm.colossus.SDAG.unary.v1i45.v5i9(i32 %id, <5 x i9> %x)
  ret <1 x i45> %res
}

define <1 x i50> @sign_extend_v5i10_to_v1i50(<5 x i10> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <1 x i50> @llvm.colossus.SDAG.unary.v1i50.v5i10(i32 %id, <5 x i10> %x)
  ret <1 x i50> %res
}

define <2 x i25> @sign_extend_v5i10_to_v2i25(<5 x i10> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i25> @llvm.colossus.SDAG.unary.v2i25.v5i10(i32 %id, <5 x i10> %x)
  ret <2 x i25> %res
}

define <1 x i55> @sign_extend_v5i11_to_v1i55(<5 x i11> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <1 x i55> @llvm.colossus.SDAG.unary.v1i55.v5i11(i32 %id, <5 x i11> %x)
  ret <1 x i55> %res
}

define <1 x i60> @sign_extend_v5i12_to_v1i60(<5 x i12> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <1 x i60> @llvm.colossus.SDAG.unary.v1i60.v5i12(i32 %id, <5 x i12> %x)
  ret <1 x i60> %res
}

define <2 x i30> @sign_extend_v5i12_to_v2i30(<5 x i12> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i30> @llvm.colossus.SDAG.unary.v2i30.v5i12(i32 %id, <5 x i12> %x)
  ret <2 x i30> %res
}

define <4 x i15> @sign_extend_v5i12_to_v4i15(<5 x i12> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <4 x i15> @llvm.colossus.SDAG.unary.v4i15.v5i12(i32 %id, <5 x i12> %x)
  ret <4 x i15> %res
}

define <2 x i35> @sign_extend_v5i14_to_v2i35(<5 x i14> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i35> @llvm.colossus.SDAG.unary.v2i35.v5i14(i32 %id, <5 x i14> %x)
  ret <2 x i35> %res
}

define <2 x i40> @sign_extend_v5i16_to_v2i40(<5 x i16> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i40> @llvm.colossus.SDAG.unary.v2i40.v5i16(i32 %id, <5 x i16> %x)
  ret <2 x i40> %res
}

define <4 x i20> @sign_extend_v5i16_to_v4i20(<5 x i16> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <4 x i20> @llvm.colossus.SDAG.unary.v4i20.v5i16(i32 %id, <5 x i16> %x)
  ret <4 x i20> %res
}

define <2 x i45> @sign_extend_v5i18_to_v2i45(<5 x i18> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i45> @llvm.colossus.SDAG.unary.v2i45.v5i18(i32 %id, <5 x i18> %x)
  ret <2 x i45> %res
}

define <2 x i50> @sign_extend_v5i20_to_v2i50(<5 x i20> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i50> @llvm.colossus.SDAG.unary.v2i50.v5i20(i32 %id, <5 x i20> %x)
  ret <2 x i50> %res
}

define <4 x i25> @sign_extend_v5i20_to_v4i25(<5 x i20> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <4 x i25> @llvm.colossus.SDAG.unary.v4i25.v5i20(i32 %id, <5 x i20> %x)
  ret <4 x i25> %res
}

define <2 x i55> @sign_extend_v5i22_to_v2i55(<5 x i22> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i55> @llvm.colossus.SDAG.unary.v2i55.v5i22(i32 %id, <5 x i22> %x)
  ret <2 x i55> %res
}

define <2 x i60> @sign_extend_v5i24_to_v2i60(<5 x i24> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i60> @llvm.colossus.SDAG.unary.v2i60.v5i24(i32 %id, <5 x i24> %x)
  ret <2 x i60> %res
}

define <4 x i30> @sign_extend_v5i24_to_v4i30(<5 x i24> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <4 x i30> @llvm.colossus.SDAG.unary.v4i30.v5i24(i32 %id, <5 x i24> %x)
  ret <4 x i30> %res
}

define <4 x i35> @sign_extend_v5i28_to_v4i35(<5 x i28> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <4 x i35> @llvm.colossus.SDAG.unary.v4i35.v5i28(i32 %id, <5 x i28> %x)
  ret <4 x i35> %res
}

define <4 x i40> @sign_extend_v5i32_to_v4i40(<5 x i32> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <4 x i40> @llvm.colossus.SDAG.unary.v4i40.v5i32(i32 %id, <5 x i32> %x)
  ret <4 x i40> %res
}

define <4 x i45> @sign_extend_v5i36_to_v4i45(<5 x i36> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <4 x i45> @llvm.colossus.SDAG.unary.v4i45.v5i36(i32 %id, <5 x i36> %x)
  ret <4 x i45> %res
}

define <4 x i50> @sign_extend_v5i40_to_v4i50(<5 x i40> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <4 x i50> @llvm.colossus.SDAG.unary.v4i50.v5i40(i32 %id, <5 x i40> %x)
  ret <4 x i50> %res
}

define <4 x i55> @sign_extend_v5i44_to_v4i55(<5 x i44> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <4 x i55> @llvm.colossus.SDAG.unary.v4i55.v5i44(i32 %id, <5 x i44> %x)
  ret <4 x i55> %res
}

define <4 x i60> @sign_extend_v5i48_to_v4i60(<5 x i48> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <4 x i60> @llvm.colossus.SDAG.unary.v4i60.v5i48(i32 %id, <5 x i48> %x)
  ret <4 x i60> %res
}

define <1 x i6> @sign_extend_v6i1_to_v1i6(<6 x i1> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <1 x i6> @llvm.colossus.SDAG.unary.v1i6.v6i1(i32 %id, <6 x i1> %x)
  ret <1 x i6> %res
}

define <2 x i3> @sign_extend_v6i1_to_v2i3(<6 x i1> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i3> @llvm.colossus.SDAG.unary.v2i3.v6i1(i32 %id, <6 x i1> %x)
  ret <2 x i3> %res
}

define <1 x i12> @sign_extend_v6i2_to_v1i12(<6 x i2> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <1 x i12> @llvm.colossus.SDAG.unary.v1i12.v6i2(i32 %id, <6 x i2> %x)
  ret <1 x i12> %res
}

define <2 x i6> @sign_extend_v6i2_to_v2i6(<6 x i2> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i6> @llvm.colossus.SDAG.unary.v2i6.v6i2(i32 %id, <6 x i2> %x)
  ret <2 x i6> %res
}

define <4 x i3> @sign_extend_v6i2_to_v4i3(<6 x i2> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <4 x i3> @llvm.colossus.SDAG.unary.v4i3.v6i2(i32 %id, <6 x i2> %x)
  ret <4 x i3> %res
}

define <1 x i18> @sign_extend_v6i3_to_v1i18(<6 x i3> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <1 x i18> @llvm.colossus.SDAG.unary.v1i18.v6i3(i32 %id, <6 x i3> %x)
  ret <1 x i18> %res
}

define <2 x i9> @sign_extend_v6i3_to_v2i9(<6 x i3> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i9> @llvm.colossus.SDAG.unary.v2i9.v6i3(i32 %id, <6 x i3> %x)
  ret <2 x i9> %res
}

define <1 x i24> @sign_extend_v6i4_to_v1i24(<6 x i4> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <1 x i24> @llvm.colossus.SDAG.unary.v1i24.v6i4(i32 %id, <6 x i4> %x)
  ret <1 x i24> %res
}

define <2 x i12> @sign_extend_v6i4_to_v2i12(<6 x i4> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i12> @llvm.colossus.SDAG.unary.v2i12.v6i4(i32 %id, <6 x i4> %x)
  ret <2 x i12> %res
}

define <4 x i6> @sign_extend_v6i4_to_v4i6(<6 x i4> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <4 x i6> @llvm.colossus.SDAG.unary.v4i6.v6i4(i32 %id, <6 x i4> %x)
  ret <4 x i6> %res
}

define <1 x i30> @sign_extend_v6i5_to_v1i30(<6 x i5> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <1 x i30> @llvm.colossus.SDAG.unary.v1i30.v6i5(i32 %id, <6 x i5> %x)
  ret <1 x i30> %res
}

define <2 x i15> @sign_extend_v6i5_to_v2i15(<6 x i5> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i15> @llvm.colossus.SDAG.unary.v2i15.v6i5(i32 %id, <6 x i5> %x)
  ret <2 x i15> %res
}

define <5 x i6> @sign_extend_v6i5_to_v5i6(<6 x i5> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <5 x i6> @llvm.colossus.SDAG.unary.v5i6.v6i5(i32 %id, <6 x i5> %x)
  ret <5 x i6> %res
}

define <1 x i36> @sign_extend_v6i6_to_v1i36(<6 x i6> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <1 x i36> @llvm.colossus.SDAG.unary.v1i36.v6i6(i32 %id, <6 x i6> %x)
  ret <1 x i36> %res
}

define <2 x i18> @sign_extend_v6i6_to_v2i18(<6 x i6> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i18> @llvm.colossus.SDAG.unary.v2i18.v6i6(i32 %id, <6 x i6> %x)
  ret <2 x i18> %res
}

define <4 x i9> @sign_extend_v6i6_to_v4i9(<6 x i6> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <4 x i9> @llvm.colossus.SDAG.unary.v4i9.v6i6(i32 %id, <6 x i6> %x)
  ret <4 x i9> %res
}

define <1 x i42> @sign_extend_v6i7_to_v1i42(<6 x i7> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <1 x i42> @llvm.colossus.SDAG.unary.v1i42.v6i7(i32 %id, <6 x i7> %x)
  ret <1 x i42> %res
}

define <2 x i21> @sign_extend_v6i7_to_v2i21(<6 x i7> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i21> @llvm.colossus.SDAG.unary.v2i21.v6i7(i32 %id, <6 x i7> %x)
  ret <2 x i21> %res
}

define <1 x i48> @sign_extend_v6i8_to_v1i48(<6 x i8> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <1 x i48> @llvm.colossus.SDAG.unary.v1i48.v6i8(i32 %id, <6 x i8> %x)
  ret <1 x i48> %res
}

define <2 x i24> @sign_extend_v6i8_to_v2i24(<6 x i8> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i24> @llvm.colossus.SDAG.unary.v2i24.v6i8(i32 %id, <6 x i8> %x)
  ret <2 x i24> %res
}

define <4 x i12> @sign_extend_v6i8_to_v4i12(<6 x i8> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <4 x i12> @llvm.colossus.SDAG.unary.v4i12.v6i8(i32 %id, <6 x i8> %x)
  ret <4 x i12> %res
}

define <1 x i54> @sign_extend_v6i9_to_v1i54(<6 x i9> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <1 x i54> @llvm.colossus.SDAG.unary.v1i54.v6i9(i32 %id, <6 x i9> %x)
  ret <1 x i54> %res
}

define <2 x i27> @sign_extend_v6i9_to_v2i27(<6 x i9> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i27> @llvm.colossus.SDAG.unary.v2i27.v6i9(i32 %id, <6 x i9> %x)
  ret <2 x i27> %res
}

define <1 x i60> @sign_extend_v6i10_to_v1i60(<6 x i10> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <1 x i60> @llvm.colossus.SDAG.unary.v1i60.v6i10(i32 %id, <6 x i10> %x)
  ret <1 x i60> %res
}

define <2 x i30> @sign_extend_v6i10_to_v2i30(<6 x i10> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i30> @llvm.colossus.SDAG.unary.v2i30.v6i10(i32 %id, <6 x i10> %x)
  ret <2 x i30> %res
}

define <4 x i15> @sign_extend_v6i10_to_v4i15(<6 x i10> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <4 x i15> @llvm.colossus.SDAG.unary.v4i15.v6i10(i32 %id, <6 x i10> %x)
  ret <4 x i15> %res
}

define <5 x i12> @sign_extend_v6i10_to_v5i12(<6 x i10> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <5 x i12> @llvm.colossus.SDAG.unary.v5i12.v6i10(i32 %id, <6 x i10> %x)
  ret <5 x i12> %res
}

define <2 x i33> @sign_extend_v6i11_to_v2i33(<6 x i11> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i33> @llvm.colossus.SDAG.unary.v2i33.v6i11(i32 %id, <6 x i11> %x)
  ret <2 x i33> %res
}

define <2 x i36> @sign_extend_v6i12_to_v2i36(<6 x i12> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i36> @llvm.colossus.SDAG.unary.v2i36.v6i12(i32 %id, <6 x i12> %x)
  ret <2 x i36> %res
}

define <4 x i18> @sign_extend_v6i12_to_v4i18(<6 x i12> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <4 x i18> @llvm.colossus.SDAG.unary.v4i18.v6i12(i32 %id, <6 x i12> %x)
  ret <4 x i18> %res
}

define <2 x i39> @sign_extend_v6i13_to_v2i39(<6 x i13> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i39> @llvm.colossus.SDAG.unary.v2i39.v6i13(i32 %id, <6 x i13> %x)
  ret <2 x i39> %res
}

define <2 x i42> @sign_extend_v6i14_to_v2i42(<6 x i14> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i42> @llvm.colossus.SDAG.unary.v2i42.v6i14(i32 %id, <6 x i14> %x)
  ret <2 x i42> %res
}

define <4 x i21> @sign_extend_v6i14_to_v4i21(<6 x i14> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <4 x i21> @llvm.colossus.SDAG.unary.v4i21.v6i14(i32 %id, <6 x i14> %x)
  ret <4 x i21> %res
}

define <2 x i45> @sign_extend_v6i15_to_v2i45(<6 x i15> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i45> @llvm.colossus.SDAG.unary.v2i45.v6i15(i32 %id, <6 x i15> %x)
  ret <2 x i45> %res
}

define <5 x i18> @sign_extend_v6i15_to_v5i18(<6 x i15> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <5 x i18> @llvm.colossus.SDAG.unary.v5i18.v6i15(i32 %id, <6 x i15> %x)
  ret <5 x i18> %res
}

define <2 x i48> @sign_extend_v6i16_to_v2i48(<6 x i16> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i48> @llvm.colossus.SDAG.unary.v2i48.v6i16(i32 %id, <6 x i16> %x)
  ret <2 x i48> %res
}

define <4 x i24> @sign_extend_v6i16_to_v4i24(<6 x i16> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <4 x i24> @llvm.colossus.SDAG.unary.v4i24.v6i16(i32 %id, <6 x i16> %x)
  ret <4 x i24> %res
}

define <2 x i51> @sign_extend_v6i17_to_v2i51(<6 x i17> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i51> @llvm.colossus.SDAG.unary.v2i51.v6i17(i32 %id, <6 x i17> %x)
  ret <2 x i51> %res
}

define <2 x i54> @sign_extend_v6i18_to_v2i54(<6 x i18> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i54> @llvm.colossus.SDAG.unary.v2i54.v6i18(i32 %id, <6 x i18> %x)
  ret <2 x i54> %res
}

define <4 x i27> @sign_extend_v6i18_to_v4i27(<6 x i18> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <4 x i27> @llvm.colossus.SDAG.unary.v4i27.v6i18(i32 %id, <6 x i18> %x)
  ret <4 x i27> %res
}

define <2 x i57> @sign_extend_v6i19_to_v2i57(<6 x i19> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i57> @llvm.colossus.SDAG.unary.v2i57.v6i19(i32 %id, <6 x i19> %x)
  ret <2 x i57> %res
}

define <2 x i60> @sign_extend_v6i20_to_v2i60(<6 x i20> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i60> @llvm.colossus.SDAG.unary.v2i60.v6i20(i32 %id, <6 x i20> %x)
  ret <2 x i60> %res
}

define <4 x i30> @sign_extend_v6i20_to_v4i30(<6 x i20> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <4 x i30> @llvm.colossus.SDAG.unary.v4i30.v6i20(i32 %id, <6 x i20> %x)
  ret <4 x i30> %res
}

define <5 x i24> @sign_extend_v6i20_to_v5i24(<6 x i20> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <5 x i24> @llvm.colossus.SDAG.unary.v5i24.v6i20(i32 %id, <6 x i20> %x)
  ret <5 x i24> %res
}

define <2 x i63> @sign_extend_v6i21_to_v2i63(<6 x i21> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i63> @llvm.colossus.SDAG.unary.v2i63.v6i21(i32 %id, <6 x i21> %x)
  ret <2 x i63> %res
}

define <4 x i33> @sign_extend_v6i22_to_v4i33(<6 x i22> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <4 x i33> @llvm.colossus.SDAG.unary.v4i33.v6i22(i32 %id, <6 x i22> %x)
  ret <4 x i33> %res
}

define <4 x i36> @sign_extend_v6i24_to_v4i36(<6 x i24> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <4 x i36> @llvm.colossus.SDAG.unary.v4i36.v6i24(i32 %id, <6 x i24> %x)
  ret <4 x i36> %res
}

define <5 x i30> @sign_extend_v6i25_to_v5i30(<6 x i25> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <5 x i30> @llvm.colossus.SDAG.unary.v5i30.v6i25(i32 %id, <6 x i25> %x)
  ret <5 x i30> %res
}

define <4 x i39> @sign_extend_v6i26_to_v4i39(<6 x i26> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <4 x i39> @llvm.colossus.SDAG.unary.v4i39.v6i26(i32 %id, <6 x i26> %x)
  ret <4 x i39> %res
}

define <4 x i42> @sign_extend_v6i28_to_v4i42(<6 x i28> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <4 x i42> @llvm.colossus.SDAG.unary.v4i42.v6i28(i32 %id, <6 x i28> %x)
  ret <4 x i42> %res
}

define <4 x i45> @sign_extend_v6i30_to_v4i45(<6 x i30> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <4 x i45> @llvm.colossus.SDAG.unary.v4i45.v6i30(i32 %id, <6 x i30> %x)
  ret <4 x i45> %res
}

define <5 x i36> @sign_extend_v6i30_to_v5i36(<6 x i30> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <5 x i36> @llvm.colossus.SDAG.unary.v5i36.v6i30(i32 %id, <6 x i30> %x)
  ret <5 x i36> %res
}

define <4 x i48> @sign_extend_v6i32_to_v4i48(<6 x i32> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <4 x i48> @llvm.colossus.SDAG.unary.v4i48.v6i32(i32 %id, <6 x i32> %x)
  ret <4 x i48> %res
}

define <4 x i51> @sign_extend_v6i34_to_v4i51(<6 x i34> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <4 x i51> @llvm.colossus.SDAG.unary.v4i51.v6i34(i32 %id, <6 x i34> %x)
  ret <4 x i51> %res
}

define <5 x i42> @sign_extend_v6i35_to_v5i42(<6 x i35> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <5 x i42> @llvm.colossus.SDAG.unary.v5i42.v6i35(i32 %id, <6 x i35> %x)
  ret <5 x i42> %res
}

define <4 x i54> @sign_extend_v6i36_to_v4i54(<6 x i36> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <4 x i54> @llvm.colossus.SDAG.unary.v4i54.v6i36(i32 %id, <6 x i36> %x)
  ret <4 x i54> %res
}

define <4 x i57> @sign_extend_v6i38_to_v4i57(<6 x i38> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <4 x i57> @llvm.colossus.SDAG.unary.v4i57.v6i38(i32 %id, <6 x i38> %x)
  ret <4 x i57> %res
}

define <4 x i60> @sign_extend_v6i40_to_v4i60(<6 x i40> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <4 x i60> @llvm.colossus.SDAG.unary.v4i60.v6i40(i32 %id, <6 x i40> %x)
  ret <4 x i60> %res
}

define <5 x i48> @sign_extend_v6i40_to_v5i48(<6 x i40> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <5 x i48> @llvm.colossus.SDAG.unary.v5i48.v6i40(i32 %id, <6 x i40> %x)
  ret <5 x i48> %res
}

define <4 x i63> @sign_extend_v6i42_to_v4i63(<6 x i42> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <4 x i63> @llvm.colossus.SDAG.unary.v4i63.v6i42(i32 %id, <6 x i42> %x)
  ret <4 x i63> %res
}

define <5 x i54> @sign_extend_v6i45_to_v5i54(<6 x i45> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <5 x i54> @llvm.colossus.SDAG.unary.v5i54.v6i45(i32 %id, <6 x i45> %x)
  ret <5 x i54> %res
}

define <5 x i60> @sign_extend_v6i50_to_v5i60(<6 x i50> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <5 x i60> @llvm.colossus.SDAG.unary.v5i60.v6i50(i32 %id, <6 x i50> %x)
  ret <5 x i60> %res
}

define <1 x i7> @sign_extend_v7i1_to_v1i7(<7 x i1> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <1 x i7> @llvm.colossus.SDAG.unary.v1i7.v7i1(i32 %id, <7 x i1> %x)
  ret <1 x i7> %res
}

define <1 x i14> @sign_extend_v7i2_to_v1i14(<7 x i2> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <1 x i14> @llvm.colossus.SDAG.unary.v1i14.v7i2(i32 %id, <7 x i2> %x)
  ret <1 x i14> %res
}

define <2 x i7> @sign_extend_v7i2_to_v2i7(<7 x i2> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i7> @llvm.colossus.SDAG.unary.v2i7.v7i2(i32 %id, <7 x i2> %x)
  ret <2 x i7> %res
}

define <1 x i21> @sign_extend_v7i3_to_v1i21(<7 x i3> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <1 x i21> @llvm.colossus.SDAG.unary.v1i21.v7i3(i32 %id, <7 x i3> %x)
  ret <1 x i21> %res
}

define <1 x i28> @sign_extend_v7i4_to_v1i28(<7 x i4> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <1 x i28> @llvm.colossus.SDAG.unary.v1i28.v7i4(i32 %id, <7 x i4> %x)
  ret <1 x i28> %res
}

define <2 x i14> @sign_extend_v7i4_to_v2i14(<7 x i4> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i14> @llvm.colossus.SDAG.unary.v2i14.v7i4(i32 %id, <7 x i4> %x)
  ret <2 x i14> %res
}

define <4 x i7> @sign_extend_v7i4_to_v4i7(<7 x i4> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <4 x i7> @llvm.colossus.SDAG.unary.v4i7.v7i4(i32 %id, <7 x i4> %x)
  ret <4 x i7> %res
}

define <1 x i35> @sign_extend_v7i5_to_v1i35(<7 x i5> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <1 x i35> @llvm.colossus.SDAG.unary.v1i35.v7i5(i32 %id, <7 x i5> %x)
  ret <1 x i35> %res
}

define <5 x i7> @sign_extend_v7i5_to_v5i7(<7 x i5> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <5 x i7> @llvm.colossus.SDAG.unary.v5i7.v7i5(i32 %id, <7 x i5> %x)
  ret <5 x i7> %res
}

define <1 x i42> @sign_extend_v7i6_to_v1i42(<7 x i6> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <1 x i42> @llvm.colossus.SDAG.unary.v1i42.v7i6(i32 %id, <7 x i6> %x)
  ret <1 x i42> %res
}

define <2 x i21> @sign_extend_v7i6_to_v2i21(<7 x i6> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i21> @llvm.colossus.SDAG.unary.v2i21.v7i6(i32 %id, <7 x i6> %x)
  ret <2 x i21> %res
}

define <6 x i7> @sign_extend_v7i6_to_v6i7(<7 x i6> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <6 x i7> @llvm.colossus.SDAG.unary.v6i7.v7i6(i32 %id, <7 x i6> %x)
  ret <6 x i7> %res
}

define <1 x i49> @sign_extend_v7i7_to_v1i49(<7 x i7> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <1 x i49> @llvm.colossus.SDAG.unary.v1i49.v7i7(i32 %id, <7 x i7> %x)
  ret <1 x i49> %res
}

define <1 x i56> @sign_extend_v7i8_to_v1i56(<7 x i8> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <1 x i56> @llvm.colossus.SDAG.unary.v1i56.v7i8(i32 %id, <7 x i8> %x)
  ret <1 x i56> %res
}

define <2 x i28> @sign_extend_v7i8_to_v2i28(<7 x i8> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i28> @llvm.colossus.SDAG.unary.v2i28.v7i8(i32 %id, <7 x i8> %x)
  ret <2 x i28> %res
}

define <4 x i14> @sign_extend_v7i8_to_v4i14(<7 x i8> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <4 x i14> @llvm.colossus.SDAG.unary.v4i14.v7i8(i32 %id, <7 x i8> %x)
  ret <4 x i14> %res
}

define <1 x i63> @sign_extend_v7i9_to_v1i63(<7 x i9> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <1 x i63> @llvm.colossus.SDAG.unary.v1i63.v7i9(i32 %id, <7 x i9> %x)
  ret <1 x i63> %res
}

define <2 x i35> @sign_extend_v7i10_to_v2i35(<7 x i10> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i35> @llvm.colossus.SDAG.unary.v2i35.v7i10(i32 %id, <7 x i10> %x)
  ret <2 x i35> %res
}

define <5 x i14> @sign_extend_v7i10_to_v5i14(<7 x i10> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <5 x i14> @llvm.colossus.SDAG.unary.v5i14.v7i10(i32 %id, <7 x i10> %x)
  ret <5 x i14> %res
}

define <2 x i42> @sign_extend_v7i12_to_v2i42(<7 x i12> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i42> @llvm.colossus.SDAG.unary.v2i42.v7i12(i32 %id, <7 x i12> %x)
  ret <2 x i42> %res
}

define <4 x i21> @sign_extend_v7i12_to_v4i21(<7 x i12> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <4 x i21> @llvm.colossus.SDAG.unary.v4i21.v7i12(i32 %id, <7 x i12> %x)
  ret <4 x i21> %res
}

define <6 x i14> @sign_extend_v7i12_to_v6i14(<7 x i12> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <6 x i14> @llvm.colossus.SDAG.unary.v6i14.v7i12(i32 %id, <7 x i12> %x)
  ret <6 x i14> %res
}

define <2 x i49> @sign_extend_v7i14_to_v2i49(<7 x i14> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i49> @llvm.colossus.SDAG.unary.v2i49.v7i14(i32 %id, <7 x i14> %x)
  ret <2 x i49> %res
}

define <5 x i21> @sign_extend_v7i15_to_v5i21(<7 x i15> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <5 x i21> @llvm.colossus.SDAG.unary.v5i21.v7i15(i32 %id, <7 x i15> %x)
  ret <5 x i21> %res
}

define <2 x i56> @sign_extend_v7i16_to_v2i56(<7 x i16> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i56> @llvm.colossus.SDAG.unary.v2i56.v7i16(i32 %id, <7 x i16> %x)
  ret <2 x i56> %res
}

define <4 x i28> @sign_extend_v7i16_to_v4i28(<7 x i16> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <4 x i28> @llvm.colossus.SDAG.unary.v4i28.v7i16(i32 %id, <7 x i16> %x)
  ret <4 x i28> %res
}

define <2 x i63> @sign_extend_v7i18_to_v2i63(<7 x i18> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i63> @llvm.colossus.SDAG.unary.v2i63.v7i18(i32 %id, <7 x i18> %x)
  ret <2 x i63> %res
}

define <6 x i21> @sign_extend_v7i18_to_v6i21(<7 x i18> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <6 x i21> @llvm.colossus.SDAG.unary.v6i21.v7i18(i32 %id, <7 x i18> %x)
  ret <6 x i21> %res
}

define <4 x i35> @sign_extend_v7i20_to_v4i35(<7 x i20> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <4 x i35> @llvm.colossus.SDAG.unary.v4i35.v7i20(i32 %id, <7 x i20> %x)
  ret <4 x i35> %res
}

define <5 x i28> @sign_extend_v7i20_to_v5i28(<7 x i20> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <5 x i28> @llvm.colossus.SDAG.unary.v5i28.v7i20(i32 %id, <7 x i20> %x)
  ret <5 x i28> %res
}

define <4 x i42> @sign_extend_v7i24_to_v4i42(<7 x i24> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <4 x i42> @llvm.colossus.SDAG.unary.v4i42.v7i24(i32 %id, <7 x i24> %x)
  ret <4 x i42> %res
}

define <6 x i28> @sign_extend_v7i24_to_v6i28(<7 x i24> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <6 x i28> @llvm.colossus.SDAG.unary.v6i28.v7i24(i32 %id, <7 x i24> %x)
  ret <6 x i28> %res
}

define <5 x i35> @sign_extend_v7i25_to_v5i35(<7 x i25> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <5 x i35> @llvm.colossus.SDAG.unary.v5i35.v7i25(i32 %id, <7 x i25> %x)
  ret <5 x i35> %res
}

define <4 x i49> @sign_extend_v7i28_to_v4i49(<7 x i28> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <4 x i49> @llvm.colossus.SDAG.unary.v4i49.v7i28(i32 %id, <7 x i28> %x)
  ret <4 x i49> %res
}

define <5 x i42> @sign_extend_v7i30_to_v5i42(<7 x i30> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <5 x i42> @llvm.colossus.SDAG.unary.v5i42.v7i30(i32 %id, <7 x i30> %x)
  ret <5 x i42> %res
}

define <6 x i35> @sign_extend_v7i30_to_v6i35(<7 x i30> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <6 x i35> @llvm.colossus.SDAG.unary.v6i35.v7i30(i32 %id, <7 x i30> %x)
  ret <6 x i35> %res
}

define <4 x i56> @sign_extend_v7i32_to_v4i56(<7 x i32> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <4 x i56> @llvm.colossus.SDAG.unary.v4i56.v7i32(i32 %id, <7 x i32> %x)
  ret <4 x i56> %res
}

define <5 x i49> @sign_extend_v7i35_to_v5i49(<7 x i35> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <5 x i49> @llvm.colossus.SDAG.unary.v5i49.v7i35(i32 %id, <7 x i35> %x)
  ret <5 x i49> %res
}

define <4 x i63> @sign_extend_v7i36_to_v4i63(<7 x i36> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <4 x i63> @llvm.colossus.SDAG.unary.v4i63.v7i36(i32 %id, <7 x i36> %x)
  ret <4 x i63> %res
}

define <6 x i42> @sign_extend_v7i36_to_v6i42(<7 x i36> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <6 x i42> @llvm.colossus.SDAG.unary.v6i42.v7i36(i32 %id, <7 x i36> %x)
  ret <6 x i42> %res
}

define <5 x i56> @sign_extend_v7i40_to_v5i56(<7 x i40> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <5 x i56> @llvm.colossus.SDAG.unary.v5i56.v7i40(i32 %id, <7 x i40> %x)
  ret <5 x i56> %res
}

define <6 x i49> @sign_extend_v7i42_to_v6i49(<7 x i42> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <6 x i49> @llvm.colossus.SDAG.unary.v6i49.v7i42(i32 %id, <7 x i42> %x)
  ret <6 x i49> %res
}

define <5 x i63> @sign_extend_v7i45_to_v5i63(<7 x i45> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <5 x i63> @llvm.colossus.SDAG.unary.v5i63.v7i45(i32 %id, <7 x i45> %x)
  ret <5 x i63> %res
}

define <6 x i56> @sign_extend_v7i48_to_v6i56(<7 x i48> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <6 x i56> @llvm.colossus.SDAG.unary.v6i56.v7i48(i32 %id, <7 x i48> %x)
  ret <6 x i56> %res
}

define <6 x i63> @sign_extend_v7i54_to_v6i63(<7 x i54> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <6 x i63> @llvm.colossus.SDAG.unary.v6i63.v7i54(i32 %id, <7 x i54> %x)
  ret <6 x i63> %res
}

define <1 x i8> @sign_extend_v8i1_to_v1i8(<8 x i1> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <1 x i8> @llvm.colossus.SDAG.unary.v1i8.v8i1(i32 %id, <8 x i1> %x)
  ret <1 x i8> %res
}

define <2 x i4> @sign_extend_v8i1_to_v2i4(<8 x i1> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i4> @llvm.colossus.SDAG.unary.v2i4.v8i1(i32 %id, <8 x i1> %x)
  ret <2 x i4> %res
}

define <4 x i2> @sign_extend_v8i1_to_v4i2(<8 x i1> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <4 x i2> @llvm.colossus.SDAG.unary.v4i2.v8i1(i32 %id, <8 x i1> %x)
  ret <4 x i2> %res
}

define <1 x i16> @sign_extend_v8i2_to_v1i16(<8 x i2> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <1 x i16> @llvm.colossus.SDAG.unary.v1i16.v8i2(i32 %id, <8 x i2> %x)
  ret <1 x i16> %res
}

define <2 x i8> @sign_extend_v8i2_to_v2i8(<8 x i2> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i8> @llvm.colossus.SDAG.unary.v2i8.v8i2(i32 %id, <8 x i2> %x)
  ret <2 x i8> %res
}

define <4 x i4> @sign_extend_v8i2_to_v4i4(<8 x i2> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <4 x i4> @llvm.colossus.SDAG.unary.v4i4.v8i2(i32 %id, <8 x i2> %x)
  ret <4 x i4> %res
}

define <1 x i24> @sign_extend_v8i3_to_v1i24(<8 x i3> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <1 x i24> @llvm.colossus.SDAG.unary.v1i24.v8i3(i32 %id, <8 x i3> %x)
  ret <1 x i24> %res
}

define <2 x i12> @sign_extend_v8i3_to_v2i12(<8 x i3> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i12> @llvm.colossus.SDAG.unary.v2i12.v8i3(i32 %id, <8 x i3> %x)
  ret <2 x i12> %res
}

define <4 x i6> @sign_extend_v8i3_to_v4i6(<8 x i3> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <4 x i6> @llvm.colossus.SDAG.unary.v4i6.v8i3(i32 %id, <8 x i3> %x)
  ret <4 x i6> %res
}

define <6 x i4> @sign_extend_v8i3_to_v6i4(<8 x i3> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <6 x i4> @llvm.colossus.SDAG.unary.v6i4.v8i3(i32 %id, <8 x i3> %x)
  ret <6 x i4> %res
}

define <1 x i32> @sign_extend_v8i4_to_v1i32(<8 x i4> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <1 x i32> @llvm.colossus.SDAG.unary.v1i32.v8i4(i32 %id, <8 x i4> %x)
  ret <1 x i32> %res
}

define <2 x i16> @sign_extend_v8i4_to_v2i16(<8 x i4> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i16> @llvm.colossus.SDAG.unary.v2i16.v8i4(i32 %id, <8 x i4> %x)
  ret <2 x i16> %res
}

define <4 x i8> @sign_extend_v8i4_to_v4i8(<8 x i4> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <4 x i8> @llvm.colossus.SDAG.unary.v4i8.v8i4(i32 %id, <8 x i4> %x)
  ret <4 x i8> %res
}

define <1 x i40> @sign_extend_v8i5_to_v1i40(<8 x i5> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <1 x i40> @llvm.colossus.SDAG.unary.v1i40.v8i5(i32 %id, <8 x i5> %x)
  ret <1 x i40> %res
}

define <2 x i20> @sign_extend_v8i5_to_v2i20(<8 x i5> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i20> @llvm.colossus.SDAG.unary.v2i20.v8i5(i32 %id, <8 x i5> %x)
  ret <2 x i20> %res
}

define <4 x i10> @sign_extend_v8i5_to_v4i10(<8 x i5> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <4 x i10> @llvm.colossus.SDAG.unary.v4i10.v8i5(i32 %id, <8 x i5> %x)
  ret <4 x i10> %res
}

define <5 x i8> @sign_extend_v8i5_to_v5i8(<8 x i5> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <5 x i8> @llvm.colossus.SDAG.unary.v5i8.v8i5(i32 %id, <8 x i5> %x)
  ret <5 x i8> %res
}

define <1 x i48> @sign_extend_v8i6_to_v1i48(<8 x i6> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <1 x i48> @llvm.colossus.SDAG.unary.v1i48.v8i6(i32 %id, <8 x i6> %x)
  ret <1 x i48> %res
}

define <2 x i24> @sign_extend_v8i6_to_v2i24(<8 x i6> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i24> @llvm.colossus.SDAG.unary.v2i24.v8i6(i32 %id, <8 x i6> %x)
  ret <2 x i24> %res
}

define <4 x i12> @sign_extend_v8i6_to_v4i12(<8 x i6> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <4 x i12> @llvm.colossus.SDAG.unary.v4i12.v8i6(i32 %id, <8 x i6> %x)
  ret <4 x i12> %res
}

define <6 x i8> @sign_extend_v8i6_to_v6i8(<8 x i6> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <6 x i8> @llvm.colossus.SDAG.unary.v6i8.v8i6(i32 %id, <8 x i6> %x)
  ret <6 x i8> %res
}

define <1 x i56> @sign_extend_v8i7_to_v1i56(<8 x i7> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <1 x i56> @llvm.colossus.SDAG.unary.v1i56.v8i7(i32 %id, <8 x i7> %x)
  ret <1 x i56> %res
}

define <2 x i28> @sign_extend_v8i7_to_v2i28(<8 x i7> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i28> @llvm.colossus.SDAG.unary.v2i28.v8i7(i32 %id, <8 x i7> %x)
  ret <2 x i28> %res
}

define <4 x i14> @sign_extend_v8i7_to_v4i14(<8 x i7> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <4 x i14> @llvm.colossus.SDAG.unary.v4i14.v8i7(i32 %id, <8 x i7> %x)
  ret <4 x i14> %res
}

define <7 x i8> @sign_extend_v8i7_to_v7i8(<8 x i7> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <7 x i8> @llvm.colossus.SDAG.unary.v7i8.v8i7(i32 %id, <8 x i7> %x)
  ret <7 x i8> %res
}

define <1 x i64> @sign_extend_v8i8_to_v1i64(<8 x i8> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <1 x i64> @llvm.colossus.SDAG.unary.v1i64.v8i8(i32 %id, <8 x i8> %x)
  ret <1 x i64> %res
}

define <2 x i32> @sign_extend_v8i8_to_v2i32(<8 x i8> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i32> @llvm.colossus.SDAG.unary.v2i32.v8i8(i32 %id, <8 x i8> %x)
  ret <2 x i32> %res
}

define <4 x i16> @sign_extend_v8i8_to_v4i16(<8 x i8> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <4 x i16> @llvm.colossus.SDAG.unary.v4i16.v8i8(i32 %id, <8 x i8> %x)
  ret <4 x i16> %res
}

define <2 x i36> @sign_extend_v8i9_to_v2i36(<8 x i9> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i36> @llvm.colossus.SDAG.unary.v2i36.v8i9(i32 %id, <8 x i9> %x)
  ret <2 x i36> %res
}

define <4 x i18> @sign_extend_v8i9_to_v4i18(<8 x i9> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <4 x i18> @llvm.colossus.SDAG.unary.v4i18.v8i9(i32 %id, <8 x i9> %x)
  ret <4 x i18> %res
}

define <6 x i12> @sign_extend_v8i9_to_v6i12(<8 x i9> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <6 x i12> @llvm.colossus.SDAG.unary.v6i12.v8i9(i32 %id, <8 x i9> %x)
  ret <6 x i12> %res
}

define <2 x i40> @sign_extend_v8i10_to_v2i40(<8 x i10> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i40> @llvm.colossus.SDAG.unary.v2i40.v8i10(i32 %id, <8 x i10> %x)
  ret <2 x i40> %res
}

define <4 x i20> @sign_extend_v8i10_to_v4i20(<8 x i10> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <4 x i20> @llvm.colossus.SDAG.unary.v4i20.v8i10(i32 %id, <8 x i10> %x)
  ret <4 x i20> %res
}

define <5 x i16> @sign_extend_v8i10_to_v5i16(<8 x i10> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <5 x i16> @llvm.colossus.SDAG.unary.v5i16.v8i10(i32 %id, <8 x i10> %x)
  ret <5 x i16> %res
}

define <2 x i44> @sign_extend_v8i11_to_v2i44(<8 x i11> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i44> @llvm.colossus.SDAG.unary.v2i44.v8i11(i32 %id, <8 x i11> %x)
  ret <2 x i44> %res
}

define <4 x i22> @sign_extend_v8i11_to_v4i22(<8 x i11> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <4 x i22> @llvm.colossus.SDAG.unary.v4i22.v8i11(i32 %id, <8 x i11> %x)
  ret <4 x i22> %res
}

define <2 x i48> @sign_extend_v8i12_to_v2i48(<8 x i12> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i48> @llvm.colossus.SDAG.unary.v2i48.v8i12(i32 %id, <8 x i12> %x)
  ret <2 x i48> %res
}

define <4 x i24> @sign_extend_v8i12_to_v4i24(<8 x i12> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <4 x i24> @llvm.colossus.SDAG.unary.v4i24.v8i12(i32 %id, <8 x i12> %x)
  ret <4 x i24> %res
}

define <6 x i16> @sign_extend_v8i12_to_v6i16(<8 x i12> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <6 x i16> @llvm.colossus.SDAG.unary.v6i16.v8i12(i32 %id, <8 x i12> %x)
  ret <6 x i16> %res
}

define <2 x i52> @sign_extend_v8i13_to_v2i52(<8 x i13> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i52> @llvm.colossus.SDAG.unary.v2i52.v8i13(i32 %id, <8 x i13> %x)
  ret <2 x i52> %res
}

define <4 x i26> @sign_extend_v8i13_to_v4i26(<8 x i13> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <4 x i26> @llvm.colossus.SDAG.unary.v4i26.v8i13(i32 %id, <8 x i13> %x)
  ret <4 x i26> %res
}

define <2 x i56> @sign_extend_v8i14_to_v2i56(<8 x i14> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i56> @llvm.colossus.SDAG.unary.v2i56.v8i14(i32 %id, <8 x i14> %x)
  ret <2 x i56> %res
}

define <4 x i28> @sign_extend_v8i14_to_v4i28(<8 x i14> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <4 x i28> @llvm.colossus.SDAG.unary.v4i28.v8i14(i32 %id, <8 x i14> %x)
  ret <4 x i28> %res
}

define <7 x i16> @sign_extend_v8i14_to_v7i16(<8 x i14> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <7 x i16> @llvm.colossus.SDAG.unary.v7i16.v8i14(i32 %id, <8 x i14> %x)
  ret <7 x i16> %res
}

define <2 x i60> @sign_extend_v8i15_to_v2i60(<8 x i15> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i60> @llvm.colossus.SDAG.unary.v2i60.v8i15(i32 %id, <8 x i15> %x)
  ret <2 x i60> %res
}

define <4 x i30> @sign_extend_v8i15_to_v4i30(<8 x i15> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <4 x i30> @llvm.colossus.SDAG.unary.v4i30.v8i15(i32 %id, <8 x i15> %x)
  ret <4 x i30> %res
}

define <5 x i24> @sign_extend_v8i15_to_v5i24(<8 x i15> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <5 x i24> @llvm.colossus.SDAG.unary.v5i24.v8i15(i32 %id, <8 x i15> %x)
  ret <5 x i24> %res
}

define <6 x i20> @sign_extend_v8i15_to_v6i20(<8 x i15> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <6 x i20> @llvm.colossus.SDAG.unary.v6i20.v8i15(i32 %id, <8 x i15> %x)
  ret <6 x i20> %res
}

define <2 x i64> @sign_extend_v8i16_to_v2i64(<8 x i16> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <2 x i64> @llvm.colossus.SDAG.unary.v2i64.v8i16(i32 %id, <8 x i16> %x)
  ret <2 x i64> %res
}

define <4 x i32> @sign_extend_v8i16_to_v4i32(<8 x i16> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <4 x i32> @llvm.colossus.SDAG.unary.v4i32.v8i16(i32 %id, <8 x i16> %x)
  ret <4 x i32> %res
}

define <4 x i34> @sign_extend_v8i17_to_v4i34(<8 x i17> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <4 x i34> @llvm.colossus.SDAG.unary.v4i34.v8i17(i32 %id, <8 x i17> %x)
  ret <4 x i34> %res
}

define <4 x i36> @sign_extend_v8i18_to_v4i36(<8 x i18> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <4 x i36> @llvm.colossus.SDAG.unary.v4i36.v8i18(i32 %id, <8 x i18> %x)
  ret <4 x i36> %res
}

define <6 x i24> @sign_extend_v8i18_to_v6i24(<8 x i18> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <6 x i24> @llvm.colossus.SDAG.unary.v6i24.v8i18(i32 %id, <8 x i18> %x)
  ret <6 x i24> %res
}

define <4 x i38> @sign_extend_v8i19_to_v4i38(<8 x i19> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <4 x i38> @llvm.colossus.SDAG.unary.v4i38.v8i19(i32 %id, <8 x i19> %x)
  ret <4 x i38> %res
}

define <4 x i40> @sign_extend_v8i20_to_v4i40(<8 x i20> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <4 x i40> @llvm.colossus.SDAG.unary.v4i40.v8i20(i32 %id, <8 x i20> %x)
  ret <4 x i40> %res
}

define <5 x i32> @sign_extend_v8i20_to_v5i32(<8 x i20> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <5 x i32> @llvm.colossus.SDAG.unary.v5i32.v8i20(i32 %id, <8 x i20> %x)
  ret <5 x i32> %res
}

define <4 x i42> @sign_extend_v8i21_to_v4i42(<8 x i21> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <4 x i42> @llvm.colossus.SDAG.unary.v4i42.v8i21(i32 %id, <8 x i21> %x)
  ret <4 x i42> %res
}

define <6 x i28> @sign_extend_v8i21_to_v6i28(<8 x i21> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <6 x i28> @llvm.colossus.SDAG.unary.v6i28.v8i21(i32 %id, <8 x i21> %x)
  ret <6 x i28> %res
}

define <7 x i24> @sign_extend_v8i21_to_v7i24(<8 x i21> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <7 x i24> @llvm.colossus.SDAG.unary.v7i24.v8i21(i32 %id, <8 x i21> %x)
  ret <7 x i24> %res
}

define <4 x i44> @sign_extend_v8i22_to_v4i44(<8 x i22> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <4 x i44> @llvm.colossus.SDAG.unary.v4i44.v8i22(i32 %id, <8 x i22> %x)
  ret <4 x i44> %res
}

define <4 x i46> @sign_extend_v8i23_to_v4i46(<8 x i23> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <4 x i46> @llvm.colossus.SDAG.unary.v4i46.v8i23(i32 %id, <8 x i23> %x)
  ret <4 x i46> %res
}

define <4 x i48> @sign_extend_v8i24_to_v4i48(<8 x i24> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <4 x i48> @llvm.colossus.SDAG.unary.v4i48.v8i24(i32 %id, <8 x i24> %x)
  ret <4 x i48> %res
}

define <6 x i32> @sign_extend_v8i24_to_v6i32(<8 x i24> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <6 x i32> @llvm.colossus.SDAG.unary.v6i32.v8i24(i32 %id, <8 x i24> %x)
  ret <6 x i32> %res
}

define <4 x i50> @sign_extend_v8i25_to_v4i50(<8 x i25> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <4 x i50> @llvm.colossus.SDAG.unary.v4i50.v8i25(i32 %id, <8 x i25> %x)
  ret <4 x i50> %res
}

define <5 x i40> @sign_extend_v8i25_to_v5i40(<8 x i25> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <5 x i40> @llvm.colossus.SDAG.unary.v5i40.v8i25(i32 %id, <8 x i25> %x)
  ret <5 x i40> %res
}

define <4 x i52> @sign_extend_v8i26_to_v4i52(<8 x i26> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <4 x i52> @llvm.colossus.SDAG.unary.v4i52.v8i26(i32 %id, <8 x i26> %x)
  ret <4 x i52> %res
}

define <4 x i54> @sign_extend_v8i27_to_v4i54(<8 x i27> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <4 x i54> @llvm.colossus.SDAG.unary.v4i54.v8i27(i32 %id, <8 x i27> %x)
  ret <4 x i54> %res
}

define <6 x i36> @sign_extend_v8i27_to_v6i36(<8 x i27> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <6 x i36> @llvm.colossus.SDAG.unary.v6i36.v8i27(i32 %id, <8 x i27> %x)
  ret <6 x i36> %res
}

define <4 x i56> @sign_extend_v8i28_to_v4i56(<8 x i28> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <4 x i56> @llvm.colossus.SDAG.unary.v4i56.v8i28(i32 %id, <8 x i28> %x)
  ret <4 x i56> %res
}

define <7 x i32> @sign_extend_v8i28_to_v7i32(<8 x i28> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <7 x i32> @llvm.colossus.SDAG.unary.v7i32.v8i28(i32 %id, <8 x i28> %x)
  ret <7 x i32> %res
}

define <4 x i58> @sign_extend_v8i29_to_v4i58(<8 x i29> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <4 x i58> @llvm.colossus.SDAG.unary.v4i58.v8i29(i32 %id, <8 x i29> %x)
  ret <4 x i58> %res
}

define <4 x i60> @sign_extend_v8i30_to_v4i60(<8 x i30> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <4 x i60> @llvm.colossus.SDAG.unary.v4i60.v8i30(i32 %id, <8 x i30> %x)
  ret <4 x i60> %res
}

define <5 x i48> @sign_extend_v8i30_to_v5i48(<8 x i30> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <5 x i48> @llvm.colossus.SDAG.unary.v5i48.v8i30(i32 %id, <8 x i30> %x)
  ret <5 x i48> %res
}

define <6 x i40> @sign_extend_v8i30_to_v6i40(<8 x i30> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <6 x i40> @llvm.colossus.SDAG.unary.v6i40.v8i30(i32 %id, <8 x i30> %x)
  ret <6 x i40> %res
}

define <4 x i62> @sign_extend_v8i31_to_v4i62(<8 x i31> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <4 x i62> @llvm.colossus.SDAG.unary.v4i62.v8i31(i32 %id, <8 x i31> %x)
  ret <4 x i62> %res
}

define <4 x i64> @sign_extend_v8i32_to_v4i64(<8 x i32> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <4 x i64> @llvm.colossus.SDAG.unary.v4i64.v8i32(i32 %id, <8 x i32> %x)
  ret <4 x i64> %res
}

define <6 x i44> @sign_extend_v8i33_to_v6i44(<8 x i33> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <6 x i44> @llvm.colossus.SDAG.unary.v6i44.v8i33(i32 %id, <8 x i33> %x)
  ret <6 x i44> %res
}

define <5 x i56> @sign_extend_v8i35_to_v5i56(<8 x i35> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <5 x i56> @llvm.colossus.SDAG.unary.v5i56.v8i35(i32 %id, <8 x i35> %x)
  ret <5 x i56> %res
}

define <7 x i40> @sign_extend_v8i35_to_v7i40(<8 x i35> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <7 x i40> @llvm.colossus.SDAG.unary.v7i40.v8i35(i32 %id, <8 x i35> %x)
  ret <7 x i40> %res
}

define <6 x i48> @sign_extend_v8i36_to_v6i48(<8 x i36> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <6 x i48> @llvm.colossus.SDAG.unary.v6i48.v8i36(i32 %id, <8 x i36> %x)
  ret <6 x i48> %res
}

define <6 x i52> @sign_extend_v8i39_to_v6i52(<8 x i39> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <6 x i52> @llvm.colossus.SDAG.unary.v6i52.v8i39(i32 %id, <8 x i39> %x)
  ret <6 x i52> %res
}

define <5 x i64> @sign_extend_v8i40_to_v5i64(<8 x i40> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <5 x i64> @llvm.colossus.SDAG.unary.v5i64.v8i40(i32 %id, <8 x i40> %x)
  ret <5 x i64> %res
}

define <6 x i56> @sign_extend_v8i42_to_v6i56(<8 x i42> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <6 x i56> @llvm.colossus.SDAG.unary.v6i56.v8i42(i32 %id, <8 x i42> %x)
  ret <6 x i56> %res
}

define <7 x i48> @sign_extend_v8i42_to_v7i48(<8 x i42> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <7 x i48> @llvm.colossus.SDAG.unary.v7i48.v8i42(i32 %id, <8 x i42> %x)
  ret <7 x i48> %res
}

define <6 x i60> @sign_extend_v8i45_to_v6i60(<8 x i45> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <6 x i60> @llvm.colossus.SDAG.unary.v6i60.v8i45(i32 %id, <8 x i45> %x)
  ret <6 x i60> %res
}

define <6 x i64> @sign_extend_v8i48_to_v6i64(<8 x i48> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <6 x i64> @llvm.colossus.SDAG.unary.v6i64.v8i48(i32 %id, <8 x i48> %x)
  ret <6 x i64> %res
}

define <7 x i56> @sign_extend_v8i49_to_v7i56(<8 x i49> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <7 x i56> @llvm.colossus.SDAG.unary.v7i56.v8i49(i32 %id, <8 x i49> %x)
  ret <7 x i56> %res
}

define <7 x i64> @sign_extend_v8i56_to_v7i64(<8 x i56> %x) {
  %id = load i32, i32* @ISD_SIGN_EXTEND_VECTOR_INREG
  %res = call <7 x i64> @llvm.colossus.SDAG.unary.v7i64.v8i56(i32 %id, <8 x i56> %x)
  ret <7 x i64> %res
}

define <1 x i2> @zero_extend_v2i1_to_v1i2(<2 x i1> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <1 x i2> @llvm.colossus.SDAG.unary.v1i2.v2i1(i32 %id, <2 x i1> %x)
  ret <1 x i2> %res
}

define <1 x i4> @zero_extend_v2i2_to_v1i4(<2 x i2> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <1 x i4> @llvm.colossus.SDAG.unary.v1i4.v2i2(i32 %id, <2 x i2> %x)
  ret <1 x i4> %res
}

define <1 x i6> @zero_extend_v2i3_to_v1i6(<2 x i3> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <1 x i6> @llvm.colossus.SDAG.unary.v1i6.v2i3(i32 %id, <2 x i3> %x)
  ret <1 x i6> %res
}

define <1 x i8> @zero_extend_v2i4_to_v1i8(<2 x i4> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <1 x i8> @llvm.colossus.SDAG.unary.v1i8.v2i4(i32 %id, <2 x i4> %x)
  ret <1 x i8> %res
}

define <1 x i10> @zero_extend_v2i5_to_v1i10(<2 x i5> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <1 x i10> @llvm.colossus.SDAG.unary.v1i10.v2i5(i32 %id, <2 x i5> %x)
  ret <1 x i10> %res
}

define <1 x i12> @zero_extend_v2i6_to_v1i12(<2 x i6> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <1 x i12> @llvm.colossus.SDAG.unary.v1i12.v2i6(i32 %id, <2 x i6> %x)
  ret <1 x i12> %res
}

define <1 x i14> @zero_extend_v2i7_to_v1i14(<2 x i7> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <1 x i14> @llvm.colossus.SDAG.unary.v1i14.v2i7(i32 %id, <2 x i7> %x)
  ret <1 x i14> %res
}

define <1 x i16> @zero_extend_v2i8_to_v1i16(<2 x i8> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <1 x i16> @llvm.colossus.SDAG.unary.v1i16.v2i8(i32 %id, <2 x i8> %x)
  ret <1 x i16> %res
}

define <1 x i18> @zero_extend_v2i9_to_v1i18(<2 x i9> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <1 x i18> @llvm.colossus.SDAG.unary.v1i18.v2i9(i32 %id, <2 x i9> %x)
  ret <1 x i18> %res
}

define <1 x i20> @zero_extend_v2i10_to_v1i20(<2 x i10> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <1 x i20> @llvm.colossus.SDAG.unary.v1i20.v2i10(i32 %id, <2 x i10> %x)
  ret <1 x i20> %res
}

define <1 x i22> @zero_extend_v2i11_to_v1i22(<2 x i11> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <1 x i22> @llvm.colossus.SDAG.unary.v1i22.v2i11(i32 %id, <2 x i11> %x)
  ret <1 x i22> %res
}

define <1 x i24> @zero_extend_v2i12_to_v1i24(<2 x i12> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <1 x i24> @llvm.colossus.SDAG.unary.v1i24.v2i12(i32 %id, <2 x i12> %x)
  ret <1 x i24> %res
}

define <1 x i26> @zero_extend_v2i13_to_v1i26(<2 x i13> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <1 x i26> @llvm.colossus.SDAG.unary.v1i26.v2i13(i32 %id, <2 x i13> %x)
  ret <1 x i26> %res
}

define <1 x i28> @zero_extend_v2i14_to_v1i28(<2 x i14> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <1 x i28> @llvm.colossus.SDAG.unary.v1i28.v2i14(i32 %id, <2 x i14> %x)
  ret <1 x i28> %res
}

define <1 x i30> @zero_extend_v2i15_to_v1i30(<2 x i15> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <1 x i30> @llvm.colossus.SDAG.unary.v1i30.v2i15(i32 %id, <2 x i15> %x)
  ret <1 x i30> %res
}

define <1 x i32> @zero_extend_v2i16_to_v1i32(<2 x i16> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <1 x i32> @llvm.colossus.SDAG.unary.v1i32.v2i16(i32 %id, <2 x i16> %x)
  ret <1 x i32> %res
}

define <1 x i34> @zero_extend_v2i17_to_v1i34(<2 x i17> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <1 x i34> @llvm.colossus.SDAG.unary.v1i34.v2i17(i32 %id, <2 x i17> %x)
  ret <1 x i34> %res
}

define <1 x i36> @zero_extend_v2i18_to_v1i36(<2 x i18> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <1 x i36> @llvm.colossus.SDAG.unary.v1i36.v2i18(i32 %id, <2 x i18> %x)
  ret <1 x i36> %res
}

define <1 x i38> @zero_extend_v2i19_to_v1i38(<2 x i19> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <1 x i38> @llvm.colossus.SDAG.unary.v1i38.v2i19(i32 %id, <2 x i19> %x)
  ret <1 x i38> %res
}

define <1 x i40> @zero_extend_v2i20_to_v1i40(<2 x i20> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <1 x i40> @llvm.colossus.SDAG.unary.v1i40.v2i20(i32 %id, <2 x i20> %x)
  ret <1 x i40> %res
}

define <1 x i42> @zero_extend_v2i21_to_v1i42(<2 x i21> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <1 x i42> @llvm.colossus.SDAG.unary.v1i42.v2i21(i32 %id, <2 x i21> %x)
  ret <1 x i42> %res
}

define <1 x i44> @zero_extend_v2i22_to_v1i44(<2 x i22> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <1 x i44> @llvm.colossus.SDAG.unary.v1i44.v2i22(i32 %id, <2 x i22> %x)
  ret <1 x i44> %res
}

define <1 x i46> @zero_extend_v2i23_to_v1i46(<2 x i23> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <1 x i46> @llvm.colossus.SDAG.unary.v1i46.v2i23(i32 %id, <2 x i23> %x)
  ret <1 x i46> %res
}

define <1 x i48> @zero_extend_v2i24_to_v1i48(<2 x i24> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <1 x i48> @llvm.colossus.SDAG.unary.v1i48.v2i24(i32 %id, <2 x i24> %x)
  ret <1 x i48> %res
}

define <1 x i50> @zero_extend_v2i25_to_v1i50(<2 x i25> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <1 x i50> @llvm.colossus.SDAG.unary.v1i50.v2i25(i32 %id, <2 x i25> %x)
  ret <1 x i50> %res
}

define <1 x i52> @zero_extend_v2i26_to_v1i52(<2 x i26> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <1 x i52> @llvm.colossus.SDAG.unary.v1i52.v2i26(i32 %id, <2 x i26> %x)
  ret <1 x i52> %res
}

define <1 x i54> @zero_extend_v2i27_to_v1i54(<2 x i27> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <1 x i54> @llvm.colossus.SDAG.unary.v1i54.v2i27(i32 %id, <2 x i27> %x)
  ret <1 x i54> %res
}

define <1 x i56> @zero_extend_v2i28_to_v1i56(<2 x i28> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <1 x i56> @llvm.colossus.SDAG.unary.v1i56.v2i28(i32 %id, <2 x i28> %x)
  ret <1 x i56> %res
}

define <1 x i58> @zero_extend_v2i29_to_v1i58(<2 x i29> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <1 x i58> @llvm.colossus.SDAG.unary.v1i58.v2i29(i32 %id, <2 x i29> %x)
  ret <1 x i58> %res
}

define <1 x i60> @zero_extend_v2i30_to_v1i60(<2 x i30> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <1 x i60> @llvm.colossus.SDAG.unary.v1i60.v2i30(i32 %id, <2 x i30> %x)
  ret <1 x i60> %res
}

define <1 x i62> @zero_extend_v2i31_to_v1i62(<2 x i31> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <1 x i62> @llvm.colossus.SDAG.unary.v1i62.v2i31(i32 %id, <2 x i31> %x)
  ret <1 x i62> %res
}

define <1 x i64> @zero_extend_v2i32_to_v1i64(<2 x i32> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <1 x i64> @llvm.colossus.SDAG.unary.v1i64.v2i32(i32 %id, <2 x i32> %x)
  ret <1 x i64> %res
}

define <1 x i3> @zero_extend_v3i1_to_v1i3(<3 x i1> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <1 x i3> @llvm.colossus.SDAG.unary.v1i3.v3i1(i32 %id, <3 x i1> %x)
  ret <1 x i3> %res
}

define <1 x i6> @zero_extend_v3i2_to_v1i6(<3 x i2> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <1 x i6> @llvm.colossus.SDAG.unary.v1i6.v3i2(i32 %id, <3 x i2> %x)
  ret <1 x i6> %res
}

define <2 x i3> @zero_extend_v3i2_to_v2i3(<3 x i2> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i3> @llvm.colossus.SDAG.unary.v2i3.v3i2(i32 %id, <3 x i2> %x)
  ret <2 x i3> %res
}

define <1 x i9> @zero_extend_v3i3_to_v1i9(<3 x i3> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <1 x i9> @llvm.colossus.SDAG.unary.v1i9.v3i3(i32 %id, <3 x i3> %x)
  ret <1 x i9> %res
}

define <1 x i12> @zero_extend_v3i4_to_v1i12(<3 x i4> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <1 x i12> @llvm.colossus.SDAG.unary.v1i12.v3i4(i32 %id, <3 x i4> %x)
  ret <1 x i12> %res
}

define <2 x i6> @zero_extend_v3i4_to_v2i6(<3 x i4> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i6> @llvm.colossus.SDAG.unary.v2i6.v3i4(i32 %id, <3 x i4> %x)
  ret <2 x i6> %res
}

define <1 x i15> @zero_extend_v3i5_to_v1i15(<3 x i5> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <1 x i15> @llvm.colossus.SDAG.unary.v1i15.v3i5(i32 %id, <3 x i5> %x)
  ret <1 x i15> %res
}

define <1 x i18> @zero_extend_v3i6_to_v1i18(<3 x i6> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <1 x i18> @llvm.colossus.SDAG.unary.v1i18.v3i6(i32 %id, <3 x i6> %x)
  ret <1 x i18> %res
}

define <2 x i9> @zero_extend_v3i6_to_v2i9(<3 x i6> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i9> @llvm.colossus.SDAG.unary.v2i9.v3i6(i32 %id, <3 x i6> %x)
  ret <2 x i9> %res
}

define <1 x i21> @zero_extend_v3i7_to_v1i21(<3 x i7> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <1 x i21> @llvm.colossus.SDAG.unary.v1i21.v3i7(i32 %id, <3 x i7> %x)
  ret <1 x i21> %res
}

define <1 x i24> @zero_extend_v3i8_to_v1i24(<3 x i8> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <1 x i24> @llvm.colossus.SDAG.unary.v1i24.v3i8(i32 %id, <3 x i8> %x)
  ret <1 x i24> %res
}

define <2 x i12> @zero_extend_v3i8_to_v2i12(<3 x i8> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i12> @llvm.colossus.SDAG.unary.v2i12.v3i8(i32 %id, <3 x i8> %x)
  ret <2 x i12> %res
}

define <1 x i27> @zero_extend_v3i9_to_v1i27(<3 x i9> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <1 x i27> @llvm.colossus.SDAG.unary.v1i27.v3i9(i32 %id, <3 x i9> %x)
  ret <1 x i27> %res
}

define <1 x i30> @zero_extend_v3i10_to_v1i30(<3 x i10> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <1 x i30> @llvm.colossus.SDAG.unary.v1i30.v3i10(i32 %id, <3 x i10> %x)
  ret <1 x i30> %res
}

define <2 x i15> @zero_extend_v3i10_to_v2i15(<3 x i10> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i15> @llvm.colossus.SDAG.unary.v2i15.v3i10(i32 %id, <3 x i10> %x)
  ret <2 x i15> %res
}

define <1 x i33> @zero_extend_v3i11_to_v1i33(<3 x i11> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <1 x i33> @llvm.colossus.SDAG.unary.v1i33.v3i11(i32 %id, <3 x i11> %x)
  ret <1 x i33> %res
}

define <1 x i36> @zero_extend_v3i12_to_v1i36(<3 x i12> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <1 x i36> @llvm.colossus.SDAG.unary.v1i36.v3i12(i32 %id, <3 x i12> %x)
  ret <1 x i36> %res
}

define <2 x i18> @zero_extend_v3i12_to_v2i18(<3 x i12> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i18> @llvm.colossus.SDAG.unary.v2i18.v3i12(i32 %id, <3 x i12> %x)
  ret <2 x i18> %res
}

define <1 x i39> @zero_extend_v3i13_to_v1i39(<3 x i13> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <1 x i39> @llvm.colossus.SDAG.unary.v1i39.v3i13(i32 %id, <3 x i13> %x)
  ret <1 x i39> %res
}

define <1 x i42> @zero_extend_v3i14_to_v1i42(<3 x i14> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <1 x i42> @llvm.colossus.SDAG.unary.v1i42.v3i14(i32 %id, <3 x i14> %x)
  ret <1 x i42> %res
}

define <2 x i21> @zero_extend_v3i14_to_v2i21(<3 x i14> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i21> @llvm.colossus.SDAG.unary.v2i21.v3i14(i32 %id, <3 x i14> %x)
  ret <2 x i21> %res
}

define <1 x i45> @zero_extend_v3i15_to_v1i45(<3 x i15> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <1 x i45> @llvm.colossus.SDAG.unary.v1i45.v3i15(i32 %id, <3 x i15> %x)
  ret <1 x i45> %res
}

define <1 x i48> @zero_extend_v3i16_to_v1i48(<3 x i16> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <1 x i48> @llvm.colossus.SDAG.unary.v1i48.v3i16(i32 %id, <3 x i16> %x)
  ret <1 x i48> %res
}

define <2 x i24> @zero_extend_v3i16_to_v2i24(<3 x i16> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i24> @llvm.colossus.SDAG.unary.v2i24.v3i16(i32 %id, <3 x i16> %x)
  ret <2 x i24> %res
}

define <1 x i51> @zero_extend_v3i17_to_v1i51(<3 x i17> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <1 x i51> @llvm.colossus.SDAG.unary.v1i51.v3i17(i32 %id, <3 x i17> %x)
  ret <1 x i51> %res
}

define <1 x i54> @zero_extend_v3i18_to_v1i54(<3 x i18> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <1 x i54> @llvm.colossus.SDAG.unary.v1i54.v3i18(i32 %id, <3 x i18> %x)
  ret <1 x i54> %res
}

define <2 x i27> @zero_extend_v3i18_to_v2i27(<3 x i18> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i27> @llvm.colossus.SDAG.unary.v2i27.v3i18(i32 %id, <3 x i18> %x)
  ret <2 x i27> %res
}

define <1 x i57> @zero_extend_v3i19_to_v1i57(<3 x i19> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <1 x i57> @llvm.colossus.SDAG.unary.v1i57.v3i19(i32 %id, <3 x i19> %x)
  ret <1 x i57> %res
}

define <1 x i60> @zero_extend_v3i20_to_v1i60(<3 x i20> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <1 x i60> @llvm.colossus.SDAG.unary.v1i60.v3i20(i32 %id, <3 x i20> %x)
  ret <1 x i60> %res
}

define <2 x i30> @zero_extend_v3i20_to_v2i30(<3 x i20> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i30> @llvm.colossus.SDAG.unary.v2i30.v3i20(i32 %id, <3 x i20> %x)
  ret <2 x i30> %res
}

define <1 x i63> @zero_extend_v3i21_to_v1i63(<3 x i21> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <1 x i63> @llvm.colossus.SDAG.unary.v1i63.v3i21(i32 %id, <3 x i21> %x)
  ret <1 x i63> %res
}

define <2 x i33> @zero_extend_v3i22_to_v2i33(<3 x i22> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i33> @llvm.colossus.SDAG.unary.v2i33.v3i22(i32 %id, <3 x i22> %x)
  ret <2 x i33> %res
}

define <2 x i36> @zero_extend_v3i24_to_v2i36(<3 x i24> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i36> @llvm.colossus.SDAG.unary.v2i36.v3i24(i32 %id, <3 x i24> %x)
  ret <2 x i36> %res
}

define <2 x i39> @zero_extend_v3i26_to_v2i39(<3 x i26> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i39> @llvm.colossus.SDAG.unary.v2i39.v3i26(i32 %id, <3 x i26> %x)
  ret <2 x i39> %res
}

define <2 x i42> @zero_extend_v3i28_to_v2i42(<3 x i28> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i42> @llvm.colossus.SDAG.unary.v2i42.v3i28(i32 %id, <3 x i28> %x)
  ret <2 x i42> %res
}

define <2 x i45> @zero_extend_v3i30_to_v2i45(<3 x i30> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i45> @llvm.colossus.SDAG.unary.v2i45.v3i30(i32 %id, <3 x i30> %x)
  ret <2 x i45> %res
}

define <2 x i48> @zero_extend_v3i32_to_v2i48(<3 x i32> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i48> @llvm.colossus.SDAG.unary.v2i48.v3i32(i32 %id, <3 x i32> %x)
  ret <2 x i48> %res
}

define <2 x i51> @zero_extend_v3i34_to_v2i51(<3 x i34> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i51> @llvm.colossus.SDAG.unary.v2i51.v3i34(i32 %id, <3 x i34> %x)
  ret <2 x i51> %res
}

define <2 x i54> @zero_extend_v3i36_to_v2i54(<3 x i36> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i54> @llvm.colossus.SDAG.unary.v2i54.v3i36(i32 %id, <3 x i36> %x)
  ret <2 x i54> %res
}

define <2 x i57> @zero_extend_v3i38_to_v2i57(<3 x i38> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i57> @llvm.colossus.SDAG.unary.v2i57.v3i38(i32 %id, <3 x i38> %x)
  ret <2 x i57> %res
}

define <2 x i60> @zero_extend_v3i40_to_v2i60(<3 x i40> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i60> @llvm.colossus.SDAG.unary.v2i60.v3i40(i32 %id, <3 x i40> %x)
  ret <2 x i60> %res
}

define <2 x i63> @zero_extend_v3i42_to_v2i63(<3 x i42> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i63> @llvm.colossus.SDAG.unary.v2i63.v3i42(i32 %id, <3 x i42> %x)
  ret <2 x i63> %res
}

define <1 x i4> @zero_extend_v4i1_to_v1i4(<4 x i1> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <1 x i4> @llvm.colossus.SDAG.unary.v1i4.v4i1(i32 %id, <4 x i1> %x)
  ret <1 x i4> %res
}

define <2 x i2> @zero_extend_v4i1_to_v2i2(<4 x i1> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i2> @llvm.colossus.SDAG.unary.v2i2.v4i1(i32 %id, <4 x i1> %x)
  ret <2 x i2> %res
}

define <1 x i8> @zero_extend_v4i2_to_v1i8(<4 x i2> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <1 x i8> @llvm.colossus.SDAG.unary.v1i8.v4i2(i32 %id, <4 x i2> %x)
  ret <1 x i8> %res
}

define <2 x i4> @zero_extend_v4i2_to_v2i4(<4 x i2> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i4> @llvm.colossus.SDAG.unary.v2i4.v4i2(i32 %id, <4 x i2> %x)
  ret <2 x i4> %res
}

define <1 x i12> @zero_extend_v4i3_to_v1i12(<4 x i3> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <1 x i12> @llvm.colossus.SDAG.unary.v1i12.v4i3(i32 %id, <4 x i3> %x)
  ret <1 x i12> %res
}

define <2 x i6> @zero_extend_v4i3_to_v2i6(<4 x i3> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i6> @llvm.colossus.SDAG.unary.v2i6.v4i3(i32 %id, <4 x i3> %x)
  ret <2 x i6> %res
}

define <3 x i4> @zero_extend_v4i3_to_v3i4(<4 x i3> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <3 x i4> @llvm.colossus.SDAG.unary.v3i4.v4i3(i32 %id, <4 x i3> %x)
  ret <3 x i4> %res
}

define <1 x i16> @zero_extend_v4i4_to_v1i16(<4 x i4> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <1 x i16> @llvm.colossus.SDAG.unary.v1i16.v4i4(i32 %id, <4 x i4> %x)
  ret <1 x i16> %res
}

define <2 x i8> @zero_extend_v4i4_to_v2i8(<4 x i4> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i8> @llvm.colossus.SDAG.unary.v2i8.v4i4(i32 %id, <4 x i4> %x)
  ret <2 x i8> %res
}

define <1 x i20> @zero_extend_v4i5_to_v1i20(<4 x i5> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <1 x i20> @llvm.colossus.SDAG.unary.v1i20.v4i5(i32 %id, <4 x i5> %x)
  ret <1 x i20> %res
}

define <2 x i10> @zero_extend_v4i5_to_v2i10(<4 x i5> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i10> @llvm.colossus.SDAG.unary.v2i10.v4i5(i32 %id, <4 x i5> %x)
  ret <2 x i10> %res
}

define <1 x i24> @zero_extend_v4i6_to_v1i24(<4 x i6> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <1 x i24> @llvm.colossus.SDAG.unary.v1i24.v4i6(i32 %id, <4 x i6> %x)
  ret <1 x i24> %res
}

define <2 x i12> @zero_extend_v4i6_to_v2i12(<4 x i6> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i12> @llvm.colossus.SDAG.unary.v2i12.v4i6(i32 %id, <4 x i6> %x)
  ret <2 x i12> %res
}

define <3 x i8> @zero_extend_v4i6_to_v3i8(<4 x i6> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <3 x i8> @llvm.colossus.SDAG.unary.v3i8.v4i6(i32 %id, <4 x i6> %x)
  ret <3 x i8> %res
}

define <1 x i28> @zero_extend_v4i7_to_v1i28(<4 x i7> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <1 x i28> @llvm.colossus.SDAG.unary.v1i28.v4i7(i32 %id, <4 x i7> %x)
  ret <1 x i28> %res
}

define <2 x i14> @zero_extend_v4i7_to_v2i14(<4 x i7> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i14> @llvm.colossus.SDAG.unary.v2i14.v4i7(i32 %id, <4 x i7> %x)
  ret <2 x i14> %res
}

define <1 x i32> @zero_extend_v4i8_to_v1i32(<4 x i8> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <1 x i32> @llvm.colossus.SDAG.unary.v1i32.v4i8(i32 %id, <4 x i8> %x)
  ret <1 x i32> %res
}

define <2 x i16> @zero_extend_v4i8_to_v2i16(<4 x i8> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i16> @llvm.colossus.SDAG.unary.v2i16.v4i8(i32 %id, <4 x i8> %x)
  ret <2 x i16> %res
}

define <1 x i36> @zero_extend_v4i9_to_v1i36(<4 x i9> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <1 x i36> @llvm.colossus.SDAG.unary.v1i36.v4i9(i32 %id, <4 x i9> %x)
  ret <1 x i36> %res
}

define <2 x i18> @zero_extend_v4i9_to_v2i18(<4 x i9> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i18> @llvm.colossus.SDAG.unary.v2i18.v4i9(i32 %id, <4 x i9> %x)
  ret <2 x i18> %res
}

define <3 x i12> @zero_extend_v4i9_to_v3i12(<4 x i9> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <3 x i12> @llvm.colossus.SDAG.unary.v3i12.v4i9(i32 %id, <4 x i9> %x)
  ret <3 x i12> %res
}

define <1 x i40> @zero_extend_v4i10_to_v1i40(<4 x i10> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <1 x i40> @llvm.colossus.SDAG.unary.v1i40.v4i10(i32 %id, <4 x i10> %x)
  ret <1 x i40> %res
}

define <2 x i20> @zero_extend_v4i10_to_v2i20(<4 x i10> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i20> @llvm.colossus.SDAG.unary.v2i20.v4i10(i32 %id, <4 x i10> %x)
  ret <2 x i20> %res
}

define <1 x i44> @zero_extend_v4i11_to_v1i44(<4 x i11> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <1 x i44> @llvm.colossus.SDAG.unary.v1i44.v4i11(i32 %id, <4 x i11> %x)
  ret <1 x i44> %res
}

define <2 x i22> @zero_extend_v4i11_to_v2i22(<4 x i11> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i22> @llvm.colossus.SDAG.unary.v2i22.v4i11(i32 %id, <4 x i11> %x)
  ret <2 x i22> %res
}

define <1 x i48> @zero_extend_v4i12_to_v1i48(<4 x i12> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <1 x i48> @llvm.colossus.SDAG.unary.v1i48.v4i12(i32 %id, <4 x i12> %x)
  ret <1 x i48> %res
}

define <2 x i24> @zero_extend_v4i12_to_v2i24(<4 x i12> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i24> @llvm.colossus.SDAG.unary.v2i24.v4i12(i32 %id, <4 x i12> %x)
  ret <2 x i24> %res
}

define <3 x i16> @zero_extend_v4i12_to_v3i16(<4 x i12> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <3 x i16> @llvm.colossus.SDAG.unary.v3i16.v4i12(i32 %id, <4 x i12> %x)
  ret <3 x i16> %res
}

define <1 x i52> @zero_extend_v4i13_to_v1i52(<4 x i13> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <1 x i52> @llvm.colossus.SDAG.unary.v1i52.v4i13(i32 %id, <4 x i13> %x)
  ret <1 x i52> %res
}

define <2 x i26> @zero_extend_v4i13_to_v2i26(<4 x i13> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i26> @llvm.colossus.SDAG.unary.v2i26.v4i13(i32 %id, <4 x i13> %x)
  ret <2 x i26> %res
}

define <1 x i56> @zero_extend_v4i14_to_v1i56(<4 x i14> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <1 x i56> @llvm.colossus.SDAG.unary.v1i56.v4i14(i32 %id, <4 x i14> %x)
  ret <1 x i56> %res
}

define <2 x i28> @zero_extend_v4i14_to_v2i28(<4 x i14> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i28> @llvm.colossus.SDAG.unary.v2i28.v4i14(i32 %id, <4 x i14> %x)
  ret <2 x i28> %res
}

define <1 x i60> @zero_extend_v4i15_to_v1i60(<4 x i15> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <1 x i60> @llvm.colossus.SDAG.unary.v1i60.v4i15(i32 %id, <4 x i15> %x)
  ret <1 x i60> %res
}

define <2 x i30> @zero_extend_v4i15_to_v2i30(<4 x i15> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i30> @llvm.colossus.SDAG.unary.v2i30.v4i15(i32 %id, <4 x i15> %x)
  ret <2 x i30> %res
}

define <3 x i20> @zero_extend_v4i15_to_v3i20(<4 x i15> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <3 x i20> @llvm.colossus.SDAG.unary.v3i20.v4i15(i32 %id, <4 x i15> %x)
  ret <3 x i20> %res
}

define <1 x i64> @zero_extend_v4i16_to_v1i64(<4 x i16> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <1 x i64> @llvm.colossus.SDAG.unary.v1i64.v4i16(i32 %id, <4 x i16> %x)
  ret <1 x i64> %res
}

define <2 x i32> @zero_extend_v4i16_to_v2i32(<4 x i16> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i32> @llvm.colossus.SDAG.unary.v2i32.v4i16(i32 %id, <4 x i16> %x)
  ret <2 x i32> %res
}

define <2 x i34> @zero_extend_v4i17_to_v2i34(<4 x i17> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i34> @llvm.colossus.SDAG.unary.v2i34.v4i17(i32 %id, <4 x i17> %x)
  ret <2 x i34> %res
}

define <2 x i36> @zero_extend_v4i18_to_v2i36(<4 x i18> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i36> @llvm.colossus.SDAG.unary.v2i36.v4i18(i32 %id, <4 x i18> %x)
  ret <2 x i36> %res
}

define <3 x i24> @zero_extend_v4i18_to_v3i24(<4 x i18> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <3 x i24> @llvm.colossus.SDAG.unary.v3i24.v4i18(i32 %id, <4 x i18> %x)
  ret <3 x i24> %res
}

define <2 x i38> @zero_extend_v4i19_to_v2i38(<4 x i19> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i38> @llvm.colossus.SDAG.unary.v2i38.v4i19(i32 %id, <4 x i19> %x)
  ret <2 x i38> %res
}

define <2 x i40> @zero_extend_v4i20_to_v2i40(<4 x i20> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i40> @llvm.colossus.SDAG.unary.v2i40.v4i20(i32 %id, <4 x i20> %x)
  ret <2 x i40> %res
}

define <2 x i42> @zero_extend_v4i21_to_v2i42(<4 x i21> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i42> @llvm.colossus.SDAG.unary.v2i42.v4i21(i32 %id, <4 x i21> %x)
  ret <2 x i42> %res
}

define <3 x i28> @zero_extend_v4i21_to_v3i28(<4 x i21> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <3 x i28> @llvm.colossus.SDAG.unary.v3i28.v4i21(i32 %id, <4 x i21> %x)
  ret <3 x i28> %res
}

define <2 x i44> @zero_extend_v4i22_to_v2i44(<4 x i22> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i44> @llvm.colossus.SDAG.unary.v2i44.v4i22(i32 %id, <4 x i22> %x)
  ret <2 x i44> %res
}

define <2 x i46> @zero_extend_v4i23_to_v2i46(<4 x i23> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i46> @llvm.colossus.SDAG.unary.v2i46.v4i23(i32 %id, <4 x i23> %x)
  ret <2 x i46> %res
}

define <2 x i48> @zero_extend_v4i24_to_v2i48(<4 x i24> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i48> @llvm.colossus.SDAG.unary.v2i48.v4i24(i32 %id, <4 x i24> %x)
  ret <2 x i48> %res
}

define <3 x i32> @zero_extend_v4i24_to_v3i32(<4 x i24> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <3 x i32> @llvm.colossus.SDAG.unary.v3i32.v4i24(i32 %id, <4 x i24> %x)
  ret <3 x i32> %res
}

define <2 x i50> @zero_extend_v4i25_to_v2i50(<4 x i25> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i50> @llvm.colossus.SDAG.unary.v2i50.v4i25(i32 %id, <4 x i25> %x)
  ret <2 x i50> %res
}

define <2 x i52> @zero_extend_v4i26_to_v2i52(<4 x i26> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i52> @llvm.colossus.SDAG.unary.v2i52.v4i26(i32 %id, <4 x i26> %x)
  ret <2 x i52> %res
}

define <2 x i54> @zero_extend_v4i27_to_v2i54(<4 x i27> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i54> @llvm.colossus.SDAG.unary.v2i54.v4i27(i32 %id, <4 x i27> %x)
  ret <2 x i54> %res
}

define <3 x i36> @zero_extend_v4i27_to_v3i36(<4 x i27> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <3 x i36> @llvm.colossus.SDAG.unary.v3i36.v4i27(i32 %id, <4 x i27> %x)
  ret <3 x i36> %res
}

define <2 x i56> @zero_extend_v4i28_to_v2i56(<4 x i28> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i56> @llvm.colossus.SDAG.unary.v2i56.v4i28(i32 %id, <4 x i28> %x)
  ret <2 x i56> %res
}

define <2 x i58> @zero_extend_v4i29_to_v2i58(<4 x i29> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i58> @llvm.colossus.SDAG.unary.v2i58.v4i29(i32 %id, <4 x i29> %x)
  ret <2 x i58> %res
}

define <2 x i60> @zero_extend_v4i30_to_v2i60(<4 x i30> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i60> @llvm.colossus.SDAG.unary.v2i60.v4i30(i32 %id, <4 x i30> %x)
  ret <2 x i60> %res
}

define <3 x i40> @zero_extend_v4i30_to_v3i40(<4 x i30> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <3 x i40> @llvm.colossus.SDAG.unary.v3i40.v4i30(i32 %id, <4 x i30> %x)
  ret <3 x i40> %res
}

define <2 x i62> @zero_extend_v4i31_to_v2i62(<4 x i31> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i62> @llvm.colossus.SDAG.unary.v2i62.v4i31(i32 %id, <4 x i31> %x)
  ret <2 x i62> %res
}

define <2 x i64> @zero_extend_v4i32_to_v2i64(<4 x i32> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i64> @llvm.colossus.SDAG.unary.v2i64.v4i32(i32 %id, <4 x i32> %x)
  ret <2 x i64> %res
}

define <3 x i44> @zero_extend_v4i33_to_v3i44(<4 x i33> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <3 x i44> @llvm.colossus.SDAG.unary.v3i44.v4i33(i32 %id, <4 x i33> %x)
  ret <3 x i44> %res
}

define <3 x i48> @zero_extend_v4i36_to_v3i48(<4 x i36> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <3 x i48> @llvm.colossus.SDAG.unary.v3i48.v4i36(i32 %id, <4 x i36> %x)
  ret <3 x i48> %res
}

define <3 x i52> @zero_extend_v4i39_to_v3i52(<4 x i39> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <3 x i52> @llvm.colossus.SDAG.unary.v3i52.v4i39(i32 %id, <4 x i39> %x)
  ret <3 x i52> %res
}

define <3 x i56> @zero_extend_v4i42_to_v3i56(<4 x i42> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <3 x i56> @llvm.colossus.SDAG.unary.v3i56.v4i42(i32 %id, <4 x i42> %x)
  ret <3 x i56> %res
}

define <3 x i60> @zero_extend_v4i45_to_v3i60(<4 x i45> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <3 x i60> @llvm.colossus.SDAG.unary.v3i60.v4i45(i32 %id, <4 x i45> %x)
  ret <3 x i60> %res
}

define <3 x i64> @zero_extend_v4i48_to_v3i64(<4 x i48> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <3 x i64> @llvm.colossus.SDAG.unary.v3i64.v4i48(i32 %id, <4 x i48> %x)
  ret <3 x i64> %res
}

define <1 x i5> @zero_extend_v5i1_to_v1i5(<5 x i1> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <1 x i5> @llvm.colossus.SDAG.unary.v1i5.v5i1(i32 %id, <5 x i1> %x)
  ret <1 x i5> %res
}

define <1 x i10> @zero_extend_v5i2_to_v1i10(<5 x i2> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <1 x i10> @llvm.colossus.SDAG.unary.v1i10.v5i2(i32 %id, <5 x i2> %x)
  ret <1 x i10> %res
}

define <2 x i5> @zero_extend_v5i2_to_v2i5(<5 x i2> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i5> @llvm.colossus.SDAG.unary.v2i5.v5i2(i32 %id, <5 x i2> %x)
  ret <2 x i5> %res
}

define <1 x i15> @zero_extend_v5i3_to_v1i15(<5 x i3> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <1 x i15> @llvm.colossus.SDAG.unary.v1i15.v5i3(i32 %id, <5 x i3> %x)
  ret <1 x i15> %res
}

define <3 x i5> @zero_extend_v5i3_to_v3i5(<5 x i3> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <3 x i5> @llvm.colossus.SDAG.unary.v3i5.v5i3(i32 %id, <5 x i3> %x)
  ret <3 x i5> %res
}

define <1 x i20> @zero_extend_v5i4_to_v1i20(<5 x i4> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <1 x i20> @llvm.colossus.SDAG.unary.v1i20.v5i4(i32 %id, <5 x i4> %x)
  ret <1 x i20> %res
}

define <2 x i10> @zero_extend_v5i4_to_v2i10(<5 x i4> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i10> @llvm.colossus.SDAG.unary.v2i10.v5i4(i32 %id, <5 x i4> %x)
  ret <2 x i10> %res
}

define <4 x i5> @zero_extend_v5i4_to_v4i5(<5 x i4> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <4 x i5> @llvm.colossus.SDAG.unary.v4i5.v5i4(i32 %id, <5 x i4> %x)
  ret <4 x i5> %res
}

define <1 x i25> @zero_extend_v5i5_to_v1i25(<5 x i5> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <1 x i25> @llvm.colossus.SDAG.unary.v1i25.v5i5(i32 %id, <5 x i5> %x)
  ret <1 x i25> %res
}

define <1 x i30> @zero_extend_v5i6_to_v1i30(<5 x i6> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <1 x i30> @llvm.colossus.SDAG.unary.v1i30.v5i6(i32 %id, <5 x i6> %x)
  ret <1 x i30> %res
}

define <2 x i15> @zero_extend_v5i6_to_v2i15(<5 x i6> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i15> @llvm.colossus.SDAG.unary.v2i15.v5i6(i32 %id, <5 x i6> %x)
  ret <2 x i15> %res
}

define <3 x i10> @zero_extend_v5i6_to_v3i10(<5 x i6> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <3 x i10> @llvm.colossus.SDAG.unary.v3i10.v5i6(i32 %id, <5 x i6> %x)
  ret <3 x i10> %res
}

define <1 x i35> @zero_extend_v5i7_to_v1i35(<5 x i7> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <1 x i35> @llvm.colossus.SDAG.unary.v1i35.v5i7(i32 %id, <5 x i7> %x)
  ret <1 x i35> %res
}

define <1 x i40> @zero_extend_v5i8_to_v1i40(<5 x i8> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <1 x i40> @llvm.colossus.SDAG.unary.v1i40.v5i8(i32 %id, <5 x i8> %x)
  ret <1 x i40> %res
}

define <2 x i20> @zero_extend_v5i8_to_v2i20(<5 x i8> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i20> @llvm.colossus.SDAG.unary.v2i20.v5i8(i32 %id, <5 x i8> %x)
  ret <2 x i20> %res
}

define <4 x i10> @zero_extend_v5i8_to_v4i10(<5 x i8> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <4 x i10> @llvm.colossus.SDAG.unary.v4i10.v5i8(i32 %id, <5 x i8> %x)
  ret <4 x i10> %res
}

define <1 x i45> @zero_extend_v5i9_to_v1i45(<5 x i9> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <1 x i45> @llvm.colossus.SDAG.unary.v1i45.v5i9(i32 %id, <5 x i9> %x)
  ret <1 x i45> %res
}

define <3 x i15> @zero_extend_v5i9_to_v3i15(<5 x i9> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <3 x i15> @llvm.colossus.SDAG.unary.v3i15.v5i9(i32 %id, <5 x i9> %x)
  ret <3 x i15> %res
}

define <1 x i50> @zero_extend_v5i10_to_v1i50(<5 x i10> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <1 x i50> @llvm.colossus.SDAG.unary.v1i50.v5i10(i32 %id, <5 x i10> %x)
  ret <1 x i50> %res
}

define <2 x i25> @zero_extend_v5i10_to_v2i25(<5 x i10> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i25> @llvm.colossus.SDAG.unary.v2i25.v5i10(i32 %id, <5 x i10> %x)
  ret <2 x i25> %res
}

define <1 x i55> @zero_extend_v5i11_to_v1i55(<5 x i11> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <1 x i55> @llvm.colossus.SDAG.unary.v1i55.v5i11(i32 %id, <5 x i11> %x)
  ret <1 x i55> %res
}

define <1 x i60> @zero_extend_v5i12_to_v1i60(<5 x i12> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <1 x i60> @llvm.colossus.SDAG.unary.v1i60.v5i12(i32 %id, <5 x i12> %x)
  ret <1 x i60> %res
}

define <2 x i30> @zero_extend_v5i12_to_v2i30(<5 x i12> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i30> @llvm.colossus.SDAG.unary.v2i30.v5i12(i32 %id, <5 x i12> %x)
  ret <2 x i30> %res
}

define <3 x i20> @zero_extend_v5i12_to_v3i20(<5 x i12> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <3 x i20> @llvm.colossus.SDAG.unary.v3i20.v5i12(i32 %id, <5 x i12> %x)
  ret <3 x i20> %res
}

define <4 x i15> @zero_extend_v5i12_to_v4i15(<5 x i12> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <4 x i15> @llvm.colossus.SDAG.unary.v4i15.v5i12(i32 %id, <5 x i12> %x)
  ret <4 x i15> %res
}

define <2 x i35> @zero_extend_v5i14_to_v2i35(<5 x i14> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i35> @llvm.colossus.SDAG.unary.v2i35.v5i14(i32 %id, <5 x i14> %x)
  ret <2 x i35> %res
}

define <3 x i25> @zero_extend_v5i15_to_v3i25(<5 x i15> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <3 x i25> @llvm.colossus.SDAG.unary.v3i25.v5i15(i32 %id, <5 x i15> %x)
  ret <3 x i25> %res
}

define <2 x i40> @zero_extend_v5i16_to_v2i40(<5 x i16> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i40> @llvm.colossus.SDAG.unary.v2i40.v5i16(i32 %id, <5 x i16> %x)
  ret <2 x i40> %res
}

define <4 x i20> @zero_extend_v5i16_to_v4i20(<5 x i16> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <4 x i20> @llvm.colossus.SDAG.unary.v4i20.v5i16(i32 %id, <5 x i16> %x)
  ret <4 x i20> %res
}

define <2 x i45> @zero_extend_v5i18_to_v2i45(<5 x i18> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i45> @llvm.colossus.SDAG.unary.v2i45.v5i18(i32 %id, <5 x i18> %x)
  ret <2 x i45> %res
}

define <3 x i30> @zero_extend_v5i18_to_v3i30(<5 x i18> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <3 x i30> @llvm.colossus.SDAG.unary.v3i30.v5i18(i32 %id, <5 x i18> %x)
  ret <3 x i30> %res
}

define <2 x i50> @zero_extend_v5i20_to_v2i50(<5 x i20> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i50> @llvm.colossus.SDAG.unary.v2i50.v5i20(i32 %id, <5 x i20> %x)
  ret <2 x i50> %res
}

define <4 x i25> @zero_extend_v5i20_to_v4i25(<5 x i20> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <4 x i25> @llvm.colossus.SDAG.unary.v4i25.v5i20(i32 %id, <5 x i20> %x)
  ret <4 x i25> %res
}

define <3 x i35> @zero_extend_v5i21_to_v3i35(<5 x i21> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <3 x i35> @llvm.colossus.SDAG.unary.v3i35.v5i21(i32 %id, <5 x i21> %x)
  ret <3 x i35> %res
}

define <2 x i55> @zero_extend_v5i22_to_v2i55(<5 x i22> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i55> @llvm.colossus.SDAG.unary.v2i55.v5i22(i32 %id, <5 x i22> %x)
  ret <2 x i55> %res
}

define <2 x i60> @zero_extend_v5i24_to_v2i60(<5 x i24> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i60> @llvm.colossus.SDAG.unary.v2i60.v5i24(i32 %id, <5 x i24> %x)
  ret <2 x i60> %res
}

define <3 x i40> @zero_extend_v5i24_to_v3i40(<5 x i24> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <3 x i40> @llvm.colossus.SDAG.unary.v3i40.v5i24(i32 %id, <5 x i24> %x)
  ret <3 x i40> %res
}

define <4 x i30> @zero_extend_v5i24_to_v4i30(<5 x i24> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <4 x i30> @llvm.colossus.SDAG.unary.v4i30.v5i24(i32 %id, <5 x i24> %x)
  ret <4 x i30> %res
}

define <3 x i45> @zero_extend_v5i27_to_v3i45(<5 x i27> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <3 x i45> @llvm.colossus.SDAG.unary.v3i45.v5i27(i32 %id, <5 x i27> %x)
  ret <3 x i45> %res
}

define <4 x i35> @zero_extend_v5i28_to_v4i35(<5 x i28> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <4 x i35> @llvm.colossus.SDAG.unary.v4i35.v5i28(i32 %id, <5 x i28> %x)
  ret <4 x i35> %res
}

define <3 x i50> @zero_extend_v5i30_to_v3i50(<5 x i30> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <3 x i50> @llvm.colossus.SDAG.unary.v3i50.v5i30(i32 %id, <5 x i30> %x)
  ret <3 x i50> %res
}

define <4 x i40> @zero_extend_v5i32_to_v4i40(<5 x i32> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <4 x i40> @llvm.colossus.SDAG.unary.v4i40.v5i32(i32 %id, <5 x i32> %x)
  ret <4 x i40> %res
}

define <3 x i55> @zero_extend_v5i33_to_v3i55(<5 x i33> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <3 x i55> @llvm.colossus.SDAG.unary.v3i55.v5i33(i32 %id, <5 x i33> %x)
  ret <3 x i55> %res
}

define <3 x i60> @zero_extend_v5i36_to_v3i60(<5 x i36> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <3 x i60> @llvm.colossus.SDAG.unary.v3i60.v5i36(i32 %id, <5 x i36> %x)
  ret <3 x i60> %res
}

define <4 x i45> @zero_extend_v5i36_to_v4i45(<5 x i36> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <4 x i45> @llvm.colossus.SDAG.unary.v4i45.v5i36(i32 %id, <5 x i36> %x)
  ret <4 x i45> %res
}

define <4 x i50> @zero_extend_v5i40_to_v4i50(<5 x i40> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <4 x i50> @llvm.colossus.SDAG.unary.v4i50.v5i40(i32 %id, <5 x i40> %x)
  ret <4 x i50> %res
}

define <4 x i55> @zero_extend_v5i44_to_v4i55(<5 x i44> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <4 x i55> @llvm.colossus.SDAG.unary.v4i55.v5i44(i32 %id, <5 x i44> %x)
  ret <4 x i55> %res
}

define <4 x i60> @zero_extend_v5i48_to_v4i60(<5 x i48> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <4 x i60> @llvm.colossus.SDAG.unary.v4i60.v5i48(i32 %id, <5 x i48> %x)
  ret <4 x i60> %res
}

define <1 x i6> @zero_extend_v6i1_to_v1i6(<6 x i1> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <1 x i6> @llvm.colossus.SDAG.unary.v1i6.v6i1(i32 %id, <6 x i1> %x)
  ret <1 x i6> %res
}

define <2 x i3> @zero_extend_v6i1_to_v2i3(<6 x i1> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i3> @llvm.colossus.SDAG.unary.v2i3.v6i1(i32 %id, <6 x i1> %x)
  ret <2 x i3> %res
}

define <3 x i2> @zero_extend_v6i1_to_v3i2(<6 x i1> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <3 x i2> @llvm.colossus.SDAG.unary.v3i2.v6i1(i32 %id, <6 x i1> %x)
  ret <3 x i2> %res
}

define <1 x i12> @zero_extend_v6i2_to_v1i12(<6 x i2> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <1 x i12> @llvm.colossus.SDAG.unary.v1i12.v6i2(i32 %id, <6 x i2> %x)
  ret <1 x i12> %res
}

define <2 x i6> @zero_extend_v6i2_to_v2i6(<6 x i2> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i6> @llvm.colossus.SDAG.unary.v2i6.v6i2(i32 %id, <6 x i2> %x)
  ret <2 x i6> %res
}

define <3 x i4> @zero_extend_v6i2_to_v3i4(<6 x i2> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <3 x i4> @llvm.colossus.SDAG.unary.v3i4.v6i2(i32 %id, <6 x i2> %x)
  ret <3 x i4> %res
}

define <4 x i3> @zero_extend_v6i2_to_v4i3(<6 x i2> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <4 x i3> @llvm.colossus.SDAG.unary.v4i3.v6i2(i32 %id, <6 x i2> %x)
  ret <4 x i3> %res
}

define <1 x i18> @zero_extend_v6i3_to_v1i18(<6 x i3> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <1 x i18> @llvm.colossus.SDAG.unary.v1i18.v6i3(i32 %id, <6 x i3> %x)
  ret <1 x i18> %res
}

define <2 x i9> @zero_extend_v6i3_to_v2i9(<6 x i3> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i9> @llvm.colossus.SDAG.unary.v2i9.v6i3(i32 %id, <6 x i3> %x)
  ret <2 x i9> %res
}

define <3 x i6> @zero_extend_v6i3_to_v3i6(<6 x i3> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <3 x i6> @llvm.colossus.SDAG.unary.v3i6.v6i3(i32 %id, <6 x i3> %x)
  ret <3 x i6> %res
}

define <1 x i24> @zero_extend_v6i4_to_v1i24(<6 x i4> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <1 x i24> @llvm.colossus.SDAG.unary.v1i24.v6i4(i32 %id, <6 x i4> %x)
  ret <1 x i24> %res
}

define <2 x i12> @zero_extend_v6i4_to_v2i12(<6 x i4> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i12> @llvm.colossus.SDAG.unary.v2i12.v6i4(i32 %id, <6 x i4> %x)
  ret <2 x i12> %res
}

define <3 x i8> @zero_extend_v6i4_to_v3i8(<6 x i4> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <3 x i8> @llvm.colossus.SDAG.unary.v3i8.v6i4(i32 %id, <6 x i4> %x)
  ret <3 x i8> %res
}

define <4 x i6> @zero_extend_v6i4_to_v4i6(<6 x i4> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <4 x i6> @llvm.colossus.SDAG.unary.v4i6.v6i4(i32 %id, <6 x i4> %x)
  ret <4 x i6> %res
}

define <1 x i30> @zero_extend_v6i5_to_v1i30(<6 x i5> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <1 x i30> @llvm.colossus.SDAG.unary.v1i30.v6i5(i32 %id, <6 x i5> %x)
  ret <1 x i30> %res
}

define <2 x i15> @zero_extend_v6i5_to_v2i15(<6 x i5> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i15> @llvm.colossus.SDAG.unary.v2i15.v6i5(i32 %id, <6 x i5> %x)
  ret <2 x i15> %res
}

define <3 x i10> @zero_extend_v6i5_to_v3i10(<6 x i5> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <3 x i10> @llvm.colossus.SDAG.unary.v3i10.v6i5(i32 %id, <6 x i5> %x)
  ret <3 x i10> %res
}

define <5 x i6> @zero_extend_v6i5_to_v5i6(<6 x i5> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <5 x i6> @llvm.colossus.SDAG.unary.v5i6.v6i5(i32 %id, <6 x i5> %x)
  ret <5 x i6> %res
}

define <1 x i36> @zero_extend_v6i6_to_v1i36(<6 x i6> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <1 x i36> @llvm.colossus.SDAG.unary.v1i36.v6i6(i32 %id, <6 x i6> %x)
  ret <1 x i36> %res
}

define <2 x i18> @zero_extend_v6i6_to_v2i18(<6 x i6> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i18> @llvm.colossus.SDAG.unary.v2i18.v6i6(i32 %id, <6 x i6> %x)
  ret <2 x i18> %res
}

define <3 x i12> @zero_extend_v6i6_to_v3i12(<6 x i6> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <3 x i12> @llvm.colossus.SDAG.unary.v3i12.v6i6(i32 %id, <6 x i6> %x)
  ret <3 x i12> %res
}

define <4 x i9> @zero_extend_v6i6_to_v4i9(<6 x i6> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <4 x i9> @llvm.colossus.SDAG.unary.v4i9.v6i6(i32 %id, <6 x i6> %x)
  ret <4 x i9> %res
}

define <1 x i42> @zero_extend_v6i7_to_v1i42(<6 x i7> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <1 x i42> @llvm.colossus.SDAG.unary.v1i42.v6i7(i32 %id, <6 x i7> %x)
  ret <1 x i42> %res
}

define <2 x i21> @zero_extend_v6i7_to_v2i21(<6 x i7> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i21> @llvm.colossus.SDAG.unary.v2i21.v6i7(i32 %id, <6 x i7> %x)
  ret <2 x i21> %res
}

define <3 x i14> @zero_extend_v6i7_to_v3i14(<6 x i7> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <3 x i14> @llvm.colossus.SDAG.unary.v3i14.v6i7(i32 %id, <6 x i7> %x)
  ret <3 x i14> %res
}

define <1 x i48> @zero_extend_v6i8_to_v1i48(<6 x i8> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <1 x i48> @llvm.colossus.SDAG.unary.v1i48.v6i8(i32 %id, <6 x i8> %x)
  ret <1 x i48> %res
}

define <2 x i24> @zero_extend_v6i8_to_v2i24(<6 x i8> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i24> @llvm.colossus.SDAG.unary.v2i24.v6i8(i32 %id, <6 x i8> %x)
  ret <2 x i24> %res
}

define <3 x i16> @zero_extend_v6i8_to_v3i16(<6 x i8> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <3 x i16> @llvm.colossus.SDAG.unary.v3i16.v6i8(i32 %id, <6 x i8> %x)
  ret <3 x i16> %res
}

define <4 x i12> @zero_extend_v6i8_to_v4i12(<6 x i8> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <4 x i12> @llvm.colossus.SDAG.unary.v4i12.v6i8(i32 %id, <6 x i8> %x)
  ret <4 x i12> %res
}

define <1 x i54> @zero_extend_v6i9_to_v1i54(<6 x i9> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <1 x i54> @llvm.colossus.SDAG.unary.v1i54.v6i9(i32 %id, <6 x i9> %x)
  ret <1 x i54> %res
}

define <2 x i27> @zero_extend_v6i9_to_v2i27(<6 x i9> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i27> @llvm.colossus.SDAG.unary.v2i27.v6i9(i32 %id, <6 x i9> %x)
  ret <2 x i27> %res
}

define <3 x i18> @zero_extend_v6i9_to_v3i18(<6 x i9> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <3 x i18> @llvm.colossus.SDAG.unary.v3i18.v6i9(i32 %id, <6 x i9> %x)
  ret <3 x i18> %res
}

define <1 x i60> @zero_extend_v6i10_to_v1i60(<6 x i10> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <1 x i60> @llvm.colossus.SDAG.unary.v1i60.v6i10(i32 %id, <6 x i10> %x)
  ret <1 x i60> %res
}

define <2 x i30> @zero_extend_v6i10_to_v2i30(<6 x i10> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i30> @llvm.colossus.SDAG.unary.v2i30.v6i10(i32 %id, <6 x i10> %x)
  ret <2 x i30> %res
}

define <3 x i20> @zero_extend_v6i10_to_v3i20(<6 x i10> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <3 x i20> @llvm.colossus.SDAG.unary.v3i20.v6i10(i32 %id, <6 x i10> %x)
  ret <3 x i20> %res
}

define <4 x i15> @zero_extend_v6i10_to_v4i15(<6 x i10> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <4 x i15> @llvm.colossus.SDAG.unary.v4i15.v6i10(i32 %id, <6 x i10> %x)
  ret <4 x i15> %res
}

define <5 x i12> @zero_extend_v6i10_to_v5i12(<6 x i10> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <5 x i12> @llvm.colossus.SDAG.unary.v5i12.v6i10(i32 %id, <6 x i10> %x)
  ret <5 x i12> %res
}

define <2 x i33> @zero_extend_v6i11_to_v2i33(<6 x i11> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i33> @llvm.colossus.SDAG.unary.v2i33.v6i11(i32 %id, <6 x i11> %x)
  ret <2 x i33> %res
}

define <3 x i22> @zero_extend_v6i11_to_v3i22(<6 x i11> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <3 x i22> @llvm.colossus.SDAG.unary.v3i22.v6i11(i32 %id, <6 x i11> %x)
  ret <3 x i22> %res
}

define <2 x i36> @zero_extend_v6i12_to_v2i36(<6 x i12> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i36> @llvm.colossus.SDAG.unary.v2i36.v6i12(i32 %id, <6 x i12> %x)
  ret <2 x i36> %res
}

define <3 x i24> @zero_extend_v6i12_to_v3i24(<6 x i12> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <3 x i24> @llvm.colossus.SDAG.unary.v3i24.v6i12(i32 %id, <6 x i12> %x)
  ret <3 x i24> %res
}

define <4 x i18> @zero_extend_v6i12_to_v4i18(<6 x i12> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <4 x i18> @llvm.colossus.SDAG.unary.v4i18.v6i12(i32 %id, <6 x i12> %x)
  ret <4 x i18> %res
}

define <2 x i39> @zero_extend_v6i13_to_v2i39(<6 x i13> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i39> @llvm.colossus.SDAG.unary.v2i39.v6i13(i32 %id, <6 x i13> %x)
  ret <2 x i39> %res
}

define <3 x i26> @zero_extend_v6i13_to_v3i26(<6 x i13> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <3 x i26> @llvm.colossus.SDAG.unary.v3i26.v6i13(i32 %id, <6 x i13> %x)
  ret <3 x i26> %res
}

define <2 x i42> @zero_extend_v6i14_to_v2i42(<6 x i14> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i42> @llvm.colossus.SDAG.unary.v2i42.v6i14(i32 %id, <6 x i14> %x)
  ret <2 x i42> %res
}

define <3 x i28> @zero_extend_v6i14_to_v3i28(<6 x i14> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <3 x i28> @llvm.colossus.SDAG.unary.v3i28.v6i14(i32 %id, <6 x i14> %x)
  ret <3 x i28> %res
}

define <4 x i21> @zero_extend_v6i14_to_v4i21(<6 x i14> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <4 x i21> @llvm.colossus.SDAG.unary.v4i21.v6i14(i32 %id, <6 x i14> %x)
  ret <4 x i21> %res
}

define <2 x i45> @zero_extend_v6i15_to_v2i45(<6 x i15> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i45> @llvm.colossus.SDAG.unary.v2i45.v6i15(i32 %id, <6 x i15> %x)
  ret <2 x i45> %res
}

define <3 x i30> @zero_extend_v6i15_to_v3i30(<6 x i15> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <3 x i30> @llvm.colossus.SDAG.unary.v3i30.v6i15(i32 %id, <6 x i15> %x)
  ret <3 x i30> %res
}

define <5 x i18> @zero_extend_v6i15_to_v5i18(<6 x i15> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <5 x i18> @llvm.colossus.SDAG.unary.v5i18.v6i15(i32 %id, <6 x i15> %x)
  ret <5 x i18> %res
}

define <2 x i48> @zero_extend_v6i16_to_v2i48(<6 x i16> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i48> @llvm.colossus.SDAG.unary.v2i48.v6i16(i32 %id, <6 x i16> %x)
  ret <2 x i48> %res
}

define <3 x i32> @zero_extend_v6i16_to_v3i32(<6 x i16> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <3 x i32> @llvm.colossus.SDAG.unary.v3i32.v6i16(i32 %id, <6 x i16> %x)
  ret <3 x i32> %res
}

define <4 x i24> @zero_extend_v6i16_to_v4i24(<6 x i16> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <4 x i24> @llvm.colossus.SDAG.unary.v4i24.v6i16(i32 %id, <6 x i16> %x)
  ret <4 x i24> %res
}

define <2 x i51> @zero_extend_v6i17_to_v2i51(<6 x i17> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i51> @llvm.colossus.SDAG.unary.v2i51.v6i17(i32 %id, <6 x i17> %x)
  ret <2 x i51> %res
}

define <3 x i34> @zero_extend_v6i17_to_v3i34(<6 x i17> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <3 x i34> @llvm.colossus.SDAG.unary.v3i34.v6i17(i32 %id, <6 x i17> %x)
  ret <3 x i34> %res
}

define <2 x i54> @zero_extend_v6i18_to_v2i54(<6 x i18> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i54> @llvm.colossus.SDAG.unary.v2i54.v6i18(i32 %id, <6 x i18> %x)
  ret <2 x i54> %res
}

define <3 x i36> @zero_extend_v6i18_to_v3i36(<6 x i18> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <3 x i36> @llvm.colossus.SDAG.unary.v3i36.v6i18(i32 %id, <6 x i18> %x)
  ret <3 x i36> %res
}

define <4 x i27> @zero_extend_v6i18_to_v4i27(<6 x i18> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <4 x i27> @llvm.colossus.SDAG.unary.v4i27.v6i18(i32 %id, <6 x i18> %x)
  ret <4 x i27> %res
}

define <2 x i57> @zero_extend_v6i19_to_v2i57(<6 x i19> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i57> @llvm.colossus.SDAG.unary.v2i57.v6i19(i32 %id, <6 x i19> %x)
  ret <2 x i57> %res
}

define <3 x i38> @zero_extend_v6i19_to_v3i38(<6 x i19> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <3 x i38> @llvm.colossus.SDAG.unary.v3i38.v6i19(i32 %id, <6 x i19> %x)
  ret <3 x i38> %res
}

define <2 x i60> @zero_extend_v6i20_to_v2i60(<6 x i20> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i60> @llvm.colossus.SDAG.unary.v2i60.v6i20(i32 %id, <6 x i20> %x)
  ret <2 x i60> %res
}

define <3 x i40> @zero_extend_v6i20_to_v3i40(<6 x i20> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <3 x i40> @llvm.colossus.SDAG.unary.v3i40.v6i20(i32 %id, <6 x i20> %x)
  ret <3 x i40> %res
}

define <4 x i30> @zero_extend_v6i20_to_v4i30(<6 x i20> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <4 x i30> @llvm.colossus.SDAG.unary.v4i30.v6i20(i32 %id, <6 x i20> %x)
  ret <4 x i30> %res
}

define <5 x i24> @zero_extend_v6i20_to_v5i24(<6 x i20> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <5 x i24> @llvm.colossus.SDAG.unary.v5i24.v6i20(i32 %id, <6 x i20> %x)
  ret <5 x i24> %res
}

define <2 x i63> @zero_extend_v6i21_to_v2i63(<6 x i21> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i63> @llvm.colossus.SDAG.unary.v2i63.v6i21(i32 %id, <6 x i21> %x)
  ret <2 x i63> %res
}

define <3 x i42> @zero_extend_v6i21_to_v3i42(<6 x i21> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <3 x i42> @llvm.colossus.SDAG.unary.v3i42.v6i21(i32 %id, <6 x i21> %x)
  ret <3 x i42> %res
}

define <3 x i44> @zero_extend_v6i22_to_v3i44(<6 x i22> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <3 x i44> @llvm.colossus.SDAG.unary.v3i44.v6i22(i32 %id, <6 x i22> %x)
  ret <3 x i44> %res
}

define <4 x i33> @zero_extend_v6i22_to_v4i33(<6 x i22> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <4 x i33> @llvm.colossus.SDAG.unary.v4i33.v6i22(i32 %id, <6 x i22> %x)
  ret <4 x i33> %res
}

define <3 x i46> @zero_extend_v6i23_to_v3i46(<6 x i23> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <3 x i46> @llvm.colossus.SDAG.unary.v3i46.v6i23(i32 %id, <6 x i23> %x)
  ret <3 x i46> %res
}

define <3 x i48> @zero_extend_v6i24_to_v3i48(<6 x i24> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <3 x i48> @llvm.colossus.SDAG.unary.v3i48.v6i24(i32 %id, <6 x i24> %x)
  ret <3 x i48> %res
}

define <4 x i36> @zero_extend_v6i24_to_v4i36(<6 x i24> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <4 x i36> @llvm.colossus.SDAG.unary.v4i36.v6i24(i32 %id, <6 x i24> %x)
  ret <4 x i36> %res
}

define <3 x i50> @zero_extend_v6i25_to_v3i50(<6 x i25> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <3 x i50> @llvm.colossus.SDAG.unary.v3i50.v6i25(i32 %id, <6 x i25> %x)
  ret <3 x i50> %res
}

define <5 x i30> @zero_extend_v6i25_to_v5i30(<6 x i25> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <5 x i30> @llvm.colossus.SDAG.unary.v5i30.v6i25(i32 %id, <6 x i25> %x)
  ret <5 x i30> %res
}

define <3 x i52> @zero_extend_v6i26_to_v3i52(<6 x i26> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <3 x i52> @llvm.colossus.SDAG.unary.v3i52.v6i26(i32 %id, <6 x i26> %x)
  ret <3 x i52> %res
}

define <4 x i39> @zero_extend_v6i26_to_v4i39(<6 x i26> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <4 x i39> @llvm.colossus.SDAG.unary.v4i39.v6i26(i32 %id, <6 x i26> %x)
  ret <4 x i39> %res
}

define <3 x i54> @zero_extend_v6i27_to_v3i54(<6 x i27> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <3 x i54> @llvm.colossus.SDAG.unary.v3i54.v6i27(i32 %id, <6 x i27> %x)
  ret <3 x i54> %res
}

define <3 x i56> @zero_extend_v6i28_to_v3i56(<6 x i28> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <3 x i56> @llvm.colossus.SDAG.unary.v3i56.v6i28(i32 %id, <6 x i28> %x)
  ret <3 x i56> %res
}

define <4 x i42> @zero_extend_v6i28_to_v4i42(<6 x i28> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <4 x i42> @llvm.colossus.SDAG.unary.v4i42.v6i28(i32 %id, <6 x i28> %x)
  ret <4 x i42> %res
}

define <3 x i58> @zero_extend_v6i29_to_v3i58(<6 x i29> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <3 x i58> @llvm.colossus.SDAG.unary.v3i58.v6i29(i32 %id, <6 x i29> %x)
  ret <3 x i58> %res
}

define <3 x i60> @zero_extend_v6i30_to_v3i60(<6 x i30> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <3 x i60> @llvm.colossus.SDAG.unary.v3i60.v6i30(i32 %id, <6 x i30> %x)
  ret <3 x i60> %res
}

define <4 x i45> @zero_extend_v6i30_to_v4i45(<6 x i30> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <4 x i45> @llvm.colossus.SDAG.unary.v4i45.v6i30(i32 %id, <6 x i30> %x)
  ret <4 x i45> %res
}

define <5 x i36> @zero_extend_v6i30_to_v5i36(<6 x i30> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <5 x i36> @llvm.colossus.SDAG.unary.v5i36.v6i30(i32 %id, <6 x i30> %x)
  ret <5 x i36> %res
}

define <3 x i62> @zero_extend_v6i31_to_v3i62(<6 x i31> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <3 x i62> @llvm.colossus.SDAG.unary.v3i62.v6i31(i32 %id, <6 x i31> %x)
  ret <3 x i62> %res
}

define <3 x i64> @zero_extend_v6i32_to_v3i64(<6 x i32> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <3 x i64> @llvm.colossus.SDAG.unary.v3i64.v6i32(i32 %id, <6 x i32> %x)
  ret <3 x i64> %res
}

define <4 x i48> @zero_extend_v6i32_to_v4i48(<6 x i32> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <4 x i48> @llvm.colossus.SDAG.unary.v4i48.v6i32(i32 %id, <6 x i32> %x)
  ret <4 x i48> %res
}

define <4 x i51> @zero_extend_v6i34_to_v4i51(<6 x i34> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <4 x i51> @llvm.colossus.SDAG.unary.v4i51.v6i34(i32 %id, <6 x i34> %x)
  ret <4 x i51> %res
}

define <5 x i42> @zero_extend_v6i35_to_v5i42(<6 x i35> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <5 x i42> @llvm.colossus.SDAG.unary.v5i42.v6i35(i32 %id, <6 x i35> %x)
  ret <5 x i42> %res
}

define <4 x i54> @zero_extend_v6i36_to_v4i54(<6 x i36> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <4 x i54> @llvm.colossus.SDAG.unary.v4i54.v6i36(i32 %id, <6 x i36> %x)
  ret <4 x i54> %res
}

define <4 x i57> @zero_extend_v6i38_to_v4i57(<6 x i38> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <4 x i57> @llvm.colossus.SDAG.unary.v4i57.v6i38(i32 %id, <6 x i38> %x)
  ret <4 x i57> %res
}

define <4 x i60> @zero_extend_v6i40_to_v4i60(<6 x i40> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <4 x i60> @llvm.colossus.SDAG.unary.v4i60.v6i40(i32 %id, <6 x i40> %x)
  ret <4 x i60> %res
}

define <5 x i48> @zero_extend_v6i40_to_v5i48(<6 x i40> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <5 x i48> @llvm.colossus.SDAG.unary.v5i48.v6i40(i32 %id, <6 x i40> %x)
  ret <5 x i48> %res
}

define <4 x i63> @zero_extend_v6i42_to_v4i63(<6 x i42> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <4 x i63> @llvm.colossus.SDAG.unary.v4i63.v6i42(i32 %id, <6 x i42> %x)
  ret <4 x i63> %res
}

define <5 x i54> @zero_extend_v6i45_to_v5i54(<6 x i45> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <5 x i54> @llvm.colossus.SDAG.unary.v5i54.v6i45(i32 %id, <6 x i45> %x)
  ret <5 x i54> %res
}

define <5 x i60> @zero_extend_v6i50_to_v5i60(<6 x i50> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <5 x i60> @llvm.colossus.SDAG.unary.v5i60.v6i50(i32 %id, <6 x i50> %x)
  ret <5 x i60> %res
}

define <1 x i7> @zero_extend_v7i1_to_v1i7(<7 x i1> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <1 x i7> @llvm.colossus.SDAG.unary.v1i7.v7i1(i32 %id, <7 x i1> %x)
  ret <1 x i7> %res
}

define <1 x i14> @zero_extend_v7i2_to_v1i14(<7 x i2> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <1 x i14> @llvm.colossus.SDAG.unary.v1i14.v7i2(i32 %id, <7 x i2> %x)
  ret <1 x i14> %res
}

define <2 x i7> @zero_extend_v7i2_to_v2i7(<7 x i2> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i7> @llvm.colossus.SDAG.unary.v2i7.v7i2(i32 %id, <7 x i2> %x)
  ret <2 x i7> %res
}

define <1 x i21> @zero_extend_v7i3_to_v1i21(<7 x i3> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <1 x i21> @llvm.colossus.SDAG.unary.v1i21.v7i3(i32 %id, <7 x i3> %x)
  ret <1 x i21> %res
}

define <3 x i7> @zero_extend_v7i3_to_v3i7(<7 x i3> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <3 x i7> @llvm.colossus.SDAG.unary.v3i7.v7i3(i32 %id, <7 x i3> %x)
  ret <3 x i7> %res
}

define <1 x i28> @zero_extend_v7i4_to_v1i28(<7 x i4> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <1 x i28> @llvm.colossus.SDAG.unary.v1i28.v7i4(i32 %id, <7 x i4> %x)
  ret <1 x i28> %res
}

define <2 x i14> @zero_extend_v7i4_to_v2i14(<7 x i4> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i14> @llvm.colossus.SDAG.unary.v2i14.v7i4(i32 %id, <7 x i4> %x)
  ret <2 x i14> %res
}

define <4 x i7> @zero_extend_v7i4_to_v4i7(<7 x i4> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <4 x i7> @llvm.colossus.SDAG.unary.v4i7.v7i4(i32 %id, <7 x i4> %x)
  ret <4 x i7> %res
}

define <1 x i35> @zero_extend_v7i5_to_v1i35(<7 x i5> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <1 x i35> @llvm.colossus.SDAG.unary.v1i35.v7i5(i32 %id, <7 x i5> %x)
  ret <1 x i35> %res
}

define <5 x i7> @zero_extend_v7i5_to_v5i7(<7 x i5> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <5 x i7> @llvm.colossus.SDAG.unary.v5i7.v7i5(i32 %id, <7 x i5> %x)
  ret <5 x i7> %res
}

define <1 x i42> @zero_extend_v7i6_to_v1i42(<7 x i6> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <1 x i42> @llvm.colossus.SDAG.unary.v1i42.v7i6(i32 %id, <7 x i6> %x)
  ret <1 x i42> %res
}

define <2 x i21> @zero_extend_v7i6_to_v2i21(<7 x i6> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i21> @llvm.colossus.SDAG.unary.v2i21.v7i6(i32 %id, <7 x i6> %x)
  ret <2 x i21> %res
}

define <3 x i14> @zero_extend_v7i6_to_v3i14(<7 x i6> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <3 x i14> @llvm.colossus.SDAG.unary.v3i14.v7i6(i32 %id, <7 x i6> %x)
  ret <3 x i14> %res
}

define <6 x i7> @zero_extend_v7i6_to_v6i7(<7 x i6> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <6 x i7> @llvm.colossus.SDAG.unary.v6i7.v7i6(i32 %id, <7 x i6> %x)
  ret <6 x i7> %res
}

define <1 x i49> @zero_extend_v7i7_to_v1i49(<7 x i7> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <1 x i49> @llvm.colossus.SDAG.unary.v1i49.v7i7(i32 %id, <7 x i7> %x)
  ret <1 x i49> %res
}

define <1 x i56> @zero_extend_v7i8_to_v1i56(<7 x i8> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <1 x i56> @llvm.colossus.SDAG.unary.v1i56.v7i8(i32 %id, <7 x i8> %x)
  ret <1 x i56> %res
}

define <2 x i28> @zero_extend_v7i8_to_v2i28(<7 x i8> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i28> @llvm.colossus.SDAG.unary.v2i28.v7i8(i32 %id, <7 x i8> %x)
  ret <2 x i28> %res
}

define <4 x i14> @zero_extend_v7i8_to_v4i14(<7 x i8> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <4 x i14> @llvm.colossus.SDAG.unary.v4i14.v7i8(i32 %id, <7 x i8> %x)
  ret <4 x i14> %res
}

define <1 x i63> @zero_extend_v7i9_to_v1i63(<7 x i9> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <1 x i63> @llvm.colossus.SDAG.unary.v1i63.v7i9(i32 %id, <7 x i9> %x)
  ret <1 x i63> %res
}

define <3 x i21> @zero_extend_v7i9_to_v3i21(<7 x i9> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <3 x i21> @llvm.colossus.SDAG.unary.v3i21.v7i9(i32 %id, <7 x i9> %x)
  ret <3 x i21> %res
}

define <2 x i35> @zero_extend_v7i10_to_v2i35(<7 x i10> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i35> @llvm.colossus.SDAG.unary.v2i35.v7i10(i32 %id, <7 x i10> %x)
  ret <2 x i35> %res
}

define <5 x i14> @zero_extend_v7i10_to_v5i14(<7 x i10> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <5 x i14> @llvm.colossus.SDAG.unary.v5i14.v7i10(i32 %id, <7 x i10> %x)
  ret <5 x i14> %res
}

define <2 x i42> @zero_extend_v7i12_to_v2i42(<7 x i12> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i42> @llvm.colossus.SDAG.unary.v2i42.v7i12(i32 %id, <7 x i12> %x)
  ret <2 x i42> %res
}

define <3 x i28> @zero_extend_v7i12_to_v3i28(<7 x i12> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <3 x i28> @llvm.colossus.SDAG.unary.v3i28.v7i12(i32 %id, <7 x i12> %x)
  ret <3 x i28> %res
}

define <4 x i21> @zero_extend_v7i12_to_v4i21(<7 x i12> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <4 x i21> @llvm.colossus.SDAG.unary.v4i21.v7i12(i32 %id, <7 x i12> %x)
  ret <4 x i21> %res
}

define <6 x i14> @zero_extend_v7i12_to_v6i14(<7 x i12> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <6 x i14> @llvm.colossus.SDAG.unary.v6i14.v7i12(i32 %id, <7 x i12> %x)
  ret <6 x i14> %res
}

define <2 x i49> @zero_extend_v7i14_to_v2i49(<7 x i14> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i49> @llvm.colossus.SDAG.unary.v2i49.v7i14(i32 %id, <7 x i14> %x)
  ret <2 x i49> %res
}

define <3 x i35> @zero_extend_v7i15_to_v3i35(<7 x i15> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <3 x i35> @llvm.colossus.SDAG.unary.v3i35.v7i15(i32 %id, <7 x i15> %x)
  ret <3 x i35> %res
}

define <5 x i21> @zero_extend_v7i15_to_v5i21(<7 x i15> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <5 x i21> @llvm.colossus.SDAG.unary.v5i21.v7i15(i32 %id, <7 x i15> %x)
  ret <5 x i21> %res
}

define <2 x i56> @zero_extend_v7i16_to_v2i56(<7 x i16> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i56> @llvm.colossus.SDAG.unary.v2i56.v7i16(i32 %id, <7 x i16> %x)
  ret <2 x i56> %res
}

define <4 x i28> @zero_extend_v7i16_to_v4i28(<7 x i16> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <4 x i28> @llvm.colossus.SDAG.unary.v4i28.v7i16(i32 %id, <7 x i16> %x)
  ret <4 x i28> %res
}

define <2 x i63> @zero_extend_v7i18_to_v2i63(<7 x i18> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i63> @llvm.colossus.SDAG.unary.v2i63.v7i18(i32 %id, <7 x i18> %x)
  ret <2 x i63> %res
}

define <3 x i42> @zero_extend_v7i18_to_v3i42(<7 x i18> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <3 x i42> @llvm.colossus.SDAG.unary.v3i42.v7i18(i32 %id, <7 x i18> %x)
  ret <3 x i42> %res
}

define <6 x i21> @zero_extend_v7i18_to_v6i21(<7 x i18> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <6 x i21> @llvm.colossus.SDAG.unary.v6i21.v7i18(i32 %id, <7 x i18> %x)
  ret <6 x i21> %res
}

define <4 x i35> @zero_extend_v7i20_to_v4i35(<7 x i20> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <4 x i35> @llvm.colossus.SDAG.unary.v4i35.v7i20(i32 %id, <7 x i20> %x)
  ret <4 x i35> %res
}

define <5 x i28> @zero_extend_v7i20_to_v5i28(<7 x i20> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <5 x i28> @llvm.colossus.SDAG.unary.v5i28.v7i20(i32 %id, <7 x i20> %x)
  ret <5 x i28> %res
}

define <3 x i49> @zero_extend_v7i21_to_v3i49(<7 x i21> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <3 x i49> @llvm.colossus.SDAG.unary.v3i49.v7i21(i32 %id, <7 x i21> %x)
  ret <3 x i49> %res
}

define <3 x i56> @zero_extend_v7i24_to_v3i56(<7 x i24> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <3 x i56> @llvm.colossus.SDAG.unary.v3i56.v7i24(i32 %id, <7 x i24> %x)
  ret <3 x i56> %res
}

define <4 x i42> @zero_extend_v7i24_to_v4i42(<7 x i24> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <4 x i42> @llvm.colossus.SDAG.unary.v4i42.v7i24(i32 %id, <7 x i24> %x)
  ret <4 x i42> %res
}

define <6 x i28> @zero_extend_v7i24_to_v6i28(<7 x i24> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <6 x i28> @llvm.colossus.SDAG.unary.v6i28.v7i24(i32 %id, <7 x i24> %x)
  ret <6 x i28> %res
}

define <5 x i35> @zero_extend_v7i25_to_v5i35(<7 x i25> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <5 x i35> @llvm.colossus.SDAG.unary.v5i35.v7i25(i32 %id, <7 x i25> %x)
  ret <5 x i35> %res
}

define <3 x i63> @zero_extend_v7i27_to_v3i63(<7 x i27> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <3 x i63> @llvm.colossus.SDAG.unary.v3i63.v7i27(i32 %id, <7 x i27> %x)
  ret <3 x i63> %res
}

define <4 x i49> @zero_extend_v7i28_to_v4i49(<7 x i28> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <4 x i49> @llvm.colossus.SDAG.unary.v4i49.v7i28(i32 %id, <7 x i28> %x)
  ret <4 x i49> %res
}

define <5 x i42> @zero_extend_v7i30_to_v5i42(<7 x i30> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <5 x i42> @llvm.colossus.SDAG.unary.v5i42.v7i30(i32 %id, <7 x i30> %x)
  ret <5 x i42> %res
}

define <6 x i35> @zero_extend_v7i30_to_v6i35(<7 x i30> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <6 x i35> @llvm.colossus.SDAG.unary.v6i35.v7i30(i32 %id, <7 x i30> %x)
  ret <6 x i35> %res
}

define <4 x i56> @zero_extend_v7i32_to_v4i56(<7 x i32> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <4 x i56> @llvm.colossus.SDAG.unary.v4i56.v7i32(i32 %id, <7 x i32> %x)
  ret <4 x i56> %res
}

define <5 x i49> @zero_extend_v7i35_to_v5i49(<7 x i35> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <5 x i49> @llvm.colossus.SDAG.unary.v5i49.v7i35(i32 %id, <7 x i35> %x)
  ret <5 x i49> %res
}

define <4 x i63> @zero_extend_v7i36_to_v4i63(<7 x i36> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <4 x i63> @llvm.colossus.SDAG.unary.v4i63.v7i36(i32 %id, <7 x i36> %x)
  ret <4 x i63> %res
}

define <6 x i42> @zero_extend_v7i36_to_v6i42(<7 x i36> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <6 x i42> @llvm.colossus.SDAG.unary.v6i42.v7i36(i32 %id, <7 x i36> %x)
  ret <6 x i42> %res
}

define <5 x i56> @zero_extend_v7i40_to_v5i56(<7 x i40> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <5 x i56> @llvm.colossus.SDAG.unary.v5i56.v7i40(i32 %id, <7 x i40> %x)
  ret <5 x i56> %res
}

define <6 x i49> @zero_extend_v7i42_to_v6i49(<7 x i42> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <6 x i49> @llvm.colossus.SDAG.unary.v6i49.v7i42(i32 %id, <7 x i42> %x)
  ret <6 x i49> %res
}

define <5 x i63> @zero_extend_v7i45_to_v5i63(<7 x i45> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <5 x i63> @llvm.colossus.SDAG.unary.v5i63.v7i45(i32 %id, <7 x i45> %x)
  ret <5 x i63> %res
}

define <6 x i56> @zero_extend_v7i48_to_v6i56(<7 x i48> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <6 x i56> @llvm.colossus.SDAG.unary.v6i56.v7i48(i32 %id, <7 x i48> %x)
  ret <6 x i56> %res
}

define <6 x i63> @zero_extend_v7i54_to_v6i63(<7 x i54> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <6 x i63> @llvm.colossus.SDAG.unary.v6i63.v7i54(i32 %id, <7 x i54> %x)
  ret <6 x i63> %res
}

define <1 x i8> @zero_extend_v8i1_to_v1i8(<8 x i1> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <1 x i8> @llvm.colossus.SDAG.unary.v1i8.v8i1(i32 %id, <8 x i1> %x)
  ret <1 x i8> %res
}

define <2 x i4> @zero_extend_v8i1_to_v2i4(<8 x i1> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i4> @llvm.colossus.SDAG.unary.v2i4.v8i1(i32 %id, <8 x i1> %x)
  ret <2 x i4> %res
}

define <4 x i2> @zero_extend_v8i1_to_v4i2(<8 x i1> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <4 x i2> @llvm.colossus.SDAG.unary.v4i2.v8i1(i32 %id, <8 x i1> %x)
  ret <4 x i2> %res
}

define <1 x i16> @zero_extend_v8i2_to_v1i16(<8 x i2> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <1 x i16> @llvm.colossus.SDAG.unary.v1i16.v8i2(i32 %id, <8 x i2> %x)
  ret <1 x i16> %res
}

define <2 x i8> @zero_extend_v8i2_to_v2i8(<8 x i2> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i8> @llvm.colossus.SDAG.unary.v2i8.v8i2(i32 %id, <8 x i2> %x)
  ret <2 x i8> %res
}

define <4 x i4> @zero_extend_v8i2_to_v4i4(<8 x i2> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <4 x i4> @llvm.colossus.SDAG.unary.v4i4.v8i2(i32 %id, <8 x i2> %x)
  ret <4 x i4> %res
}

define <1 x i24> @zero_extend_v8i3_to_v1i24(<8 x i3> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <1 x i24> @llvm.colossus.SDAG.unary.v1i24.v8i3(i32 %id, <8 x i3> %x)
  ret <1 x i24> %res
}

define <2 x i12> @zero_extend_v8i3_to_v2i12(<8 x i3> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i12> @llvm.colossus.SDAG.unary.v2i12.v8i3(i32 %id, <8 x i3> %x)
  ret <2 x i12> %res
}

define <3 x i8> @zero_extend_v8i3_to_v3i8(<8 x i3> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <3 x i8> @llvm.colossus.SDAG.unary.v3i8.v8i3(i32 %id, <8 x i3> %x)
  ret <3 x i8> %res
}

define <4 x i6> @zero_extend_v8i3_to_v4i6(<8 x i3> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <4 x i6> @llvm.colossus.SDAG.unary.v4i6.v8i3(i32 %id, <8 x i3> %x)
  ret <4 x i6> %res
}

define <6 x i4> @zero_extend_v8i3_to_v6i4(<8 x i3> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <6 x i4> @llvm.colossus.SDAG.unary.v6i4.v8i3(i32 %id, <8 x i3> %x)
  ret <6 x i4> %res
}

define <1 x i32> @zero_extend_v8i4_to_v1i32(<8 x i4> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <1 x i32> @llvm.colossus.SDAG.unary.v1i32.v8i4(i32 %id, <8 x i4> %x)
  ret <1 x i32> %res
}

define <2 x i16> @zero_extend_v8i4_to_v2i16(<8 x i4> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i16> @llvm.colossus.SDAG.unary.v2i16.v8i4(i32 %id, <8 x i4> %x)
  ret <2 x i16> %res
}

define <4 x i8> @zero_extend_v8i4_to_v4i8(<8 x i4> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <4 x i8> @llvm.colossus.SDAG.unary.v4i8.v8i4(i32 %id, <8 x i4> %x)
  ret <4 x i8> %res
}

define <1 x i40> @zero_extend_v8i5_to_v1i40(<8 x i5> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <1 x i40> @llvm.colossus.SDAG.unary.v1i40.v8i5(i32 %id, <8 x i5> %x)
  ret <1 x i40> %res
}

define <2 x i20> @zero_extend_v8i5_to_v2i20(<8 x i5> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i20> @llvm.colossus.SDAG.unary.v2i20.v8i5(i32 %id, <8 x i5> %x)
  ret <2 x i20> %res
}

define <4 x i10> @zero_extend_v8i5_to_v4i10(<8 x i5> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <4 x i10> @llvm.colossus.SDAG.unary.v4i10.v8i5(i32 %id, <8 x i5> %x)
  ret <4 x i10> %res
}

define <5 x i8> @zero_extend_v8i5_to_v5i8(<8 x i5> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <5 x i8> @llvm.colossus.SDAG.unary.v5i8.v8i5(i32 %id, <8 x i5> %x)
  ret <5 x i8> %res
}

define <1 x i48> @zero_extend_v8i6_to_v1i48(<8 x i6> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <1 x i48> @llvm.colossus.SDAG.unary.v1i48.v8i6(i32 %id, <8 x i6> %x)
  ret <1 x i48> %res
}

define <2 x i24> @zero_extend_v8i6_to_v2i24(<8 x i6> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i24> @llvm.colossus.SDAG.unary.v2i24.v8i6(i32 %id, <8 x i6> %x)
  ret <2 x i24> %res
}

define <3 x i16> @zero_extend_v8i6_to_v3i16(<8 x i6> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <3 x i16> @llvm.colossus.SDAG.unary.v3i16.v8i6(i32 %id, <8 x i6> %x)
  ret <3 x i16> %res
}

define <4 x i12> @zero_extend_v8i6_to_v4i12(<8 x i6> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <4 x i12> @llvm.colossus.SDAG.unary.v4i12.v8i6(i32 %id, <8 x i6> %x)
  ret <4 x i12> %res
}

define <6 x i8> @zero_extend_v8i6_to_v6i8(<8 x i6> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <6 x i8> @llvm.colossus.SDAG.unary.v6i8.v8i6(i32 %id, <8 x i6> %x)
  ret <6 x i8> %res
}

define <1 x i56> @zero_extend_v8i7_to_v1i56(<8 x i7> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <1 x i56> @llvm.colossus.SDAG.unary.v1i56.v8i7(i32 %id, <8 x i7> %x)
  ret <1 x i56> %res
}

define <2 x i28> @zero_extend_v8i7_to_v2i28(<8 x i7> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i28> @llvm.colossus.SDAG.unary.v2i28.v8i7(i32 %id, <8 x i7> %x)
  ret <2 x i28> %res
}

define <4 x i14> @zero_extend_v8i7_to_v4i14(<8 x i7> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <4 x i14> @llvm.colossus.SDAG.unary.v4i14.v8i7(i32 %id, <8 x i7> %x)
  ret <4 x i14> %res
}

define <7 x i8> @zero_extend_v8i7_to_v7i8(<8 x i7> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <7 x i8> @llvm.colossus.SDAG.unary.v7i8.v8i7(i32 %id, <8 x i7> %x)
  ret <7 x i8> %res
}

define <1 x i64> @zero_extend_v8i8_to_v1i64(<8 x i8> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <1 x i64> @llvm.colossus.SDAG.unary.v1i64.v8i8(i32 %id, <8 x i8> %x)
  ret <1 x i64> %res
}

define <2 x i32> @zero_extend_v8i8_to_v2i32(<8 x i8> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i32> @llvm.colossus.SDAG.unary.v2i32.v8i8(i32 %id, <8 x i8> %x)
  ret <2 x i32> %res
}

define <4 x i16> @zero_extend_v8i8_to_v4i16(<8 x i8> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <4 x i16> @llvm.colossus.SDAG.unary.v4i16.v8i8(i32 %id, <8 x i8> %x)
  ret <4 x i16> %res
}

define <2 x i36> @zero_extend_v8i9_to_v2i36(<8 x i9> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i36> @llvm.colossus.SDAG.unary.v2i36.v8i9(i32 %id, <8 x i9> %x)
  ret <2 x i36> %res
}

define <3 x i24> @zero_extend_v8i9_to_v3i24(<8 x i9> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <3 x i24> @llvm.colossus.SDAG.unary.v3i24.v8i9(i32 %id, <8 x i9> %x)
  ret <3 x i24> %res
}

define <4 x i18> @zero_extend_v8i9_to_v4i18(<8 x i9> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <4 x i18> @llvm.colossus.SDAG.unary.v4i18.v8i9(i32 %id, <8 x i9> %x)
  ret <4 x i18> %res
}

define <6 x i12> @zero_extend_v8i9_to_v6i12(<8 x i9> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <6 x i12> @llvm.colossus.SDAG.unary.v6i12.v8i9(i32 %id, <8 x i9> %x)
  ret <6 x i12> %res
}

define <2 x i40> @zero_extend_v8i10_to_v2i40(<8 x i10> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i40> @llvm.colossus.SDAG.unary.v2i40.v8i10(i32 %id, <8 x i10> %x)
  ret <2 x i40> %res
}

define <4 x i20> @zero_extend_v8i10_to_v4i20(<8 x i10> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <4 x i20> @llvm.colossus.SDAG.unary.v4i20.v8i10(i32 %id, <8 x i10> %x)
  ret <4 x i20> %res
}

define <5 x i16> @zero_extend_v8i10_to_v5i16(<8 x i10> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <5 x i16> @llvm.colossus.SDAG.unary.v5i16.v8i10(i32 %id, <8 x i10> %x)
  ret <5 x i16> %res
}

define <2 x i44> @zero_extend_v8i11_to_v2i44(<8 x i11> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i44> @llvm.colossus.SDAG.unary.v2i44.v8i11(i32 %id, <8 x i11> %x)
  ret <2 x i44> %res
}

define <4 x i22> @zero_extend_v8i11_to_v4i22(<8 x i11> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <4 x i22> @llvm.colossus.SDAG.unary.v4i22.v8i11(i32 %id, <8 x i11> %x)
  ret <4 x i22> %res
}

define <2 x i48> @zero_extend_v8i12_to_v2i48(<8 x i12> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i48> @llvm.colossus.SDAG.unary.v2i48.v8i12(i32 %id, <8 x i12> %x)
  ret <2 x i48> %res
}

define <3 x i32> @zero_extend_v8i12_to_v3i32(<8 x i12> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <3 x i32> @llvm.colossus.SDAG.unary.v3i32.v8i12(i32 %id, <8 x i12> %x)
  ret <3 x i32> %res
}

define <4 x i24> @zero_extend_v8i12_to_v4i24(<8 x i12> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <4 x i24> @llvm.colossus.SDAG.unary.v4i24.v8i12(i32 %id, <8 x i12> %x)
  ret <4 x i24> %res
}

define <6 x i16> @zero_extend_v8i12_to_v6i16(<8 x i12> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <6 x i16> @llvm.colossus.SDAG.unary.v6i16.v8i12(i32 %id, <8 x i12> %x)
  ret <6 x i16> %res
}

define <2 x i52> @zero_extend_v8i13_to_v2i52(<8 x i13> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i52> @llvm.colossus.SDAG.unary.v2i52.v8i13(i32 %id, <8 x i13> %x)
  ret <2 x i52> %res
}

define <4 x i26> @zero_extend_v8i13_to_v4i26(<8 x i13> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <4 x i26> @llvm.colossus.SDAG.unary.v4i26.v8i13(i32 %id, <8 x i13> %x)
  ret <4 x i26> %res
}

define <2 x i56> @zero_extend_v8i14_to_v2i56(<8 x i14> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i56> @llvm.colossus.SDAG.unary.v2i56.v8i14(i32 %id, <8 x i14> %x)
  ret <2 x i56> %res
}

define <4 x i28> @zero_extend_v8i14_to_v4i28(<8 x i14> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <4 x i28> @llvm.colossus.SDAG.unary.v4i28.v8i14(i32 %id, <8 x i14> %x)
  ret <4 x i28> %res
}

define <7 x i16> @zero_extend_v8i14_to_v7i16(<8 x i14> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <7 x i16> @llvm.colossus.SDAG.unary.v7i16.v8i14(i32 %id, <8 x i14> %x)
  ret <7 x i16> %res
}

define <2 x i60> @zero_extend_v8i15_to_v2i60(<8 x i15> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i60> @llvm.colossus.SDAG.unary.v2i60.v8i15(i32 %id, <8 x i15> %x)
  ret <2 x i60> %res
}

define <3 x i40> @zero_extend_v8i15_to_v3i40(<8 x i15> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <3 x i40> @llvm.colossus.SDAG.unary.v3i40.v8i15(i32 %id, <8 x i15> %x)
  ret <3 x i40> %res
}

define <4 x i30> @zero_extend_v8i15_to_v4i30(<8 x i15> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <4 x i30> @llvm.colossus.SDAG.unary.v4i30.v8i15(i32 %id, <8 x i15> %x)
  ret <4 x i30> %res
}

define <5 x i24> @zero_extend_v8i15_to_v5i24(<8 x i15> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <5 x i24> @llvm.colossus.SDAG.unary.v5i24.v8i15(i32 %id, <8 x i15> %x)
  ret <5 x i24> %res
}

define <6 x i20> @zero_extend_v8i15_to_v6i20(<8 x i15> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <6 x i20> @llvm.colossus.SDAG.unary.v6i20.v8i15(i32 %id, <8 x i15> %x)
  ret <6 x i20> %res
}

define <2 x i64> @zero_extend_v8i16_to_v2i64(<8 x i16> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <2 x i64> @llvm.colossus.SDAG.unary.v2i64.v8i16(i32 %id, <8 x i16> %x)
  ret <2 x i64> %res
}

define <4 x i32> @zero_extend_v8i16_to_v4i32(<8 x i16> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <4 x i32> @llvm.colossus.SDAG.unary.v4i32.v8i16(i32 %id, <8 x i16> %x)
  ret <4 x i32> %res
}

define <4 x i34> @zero_extend_v8i17_to_v4i34(<8 x i17> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <4 x i34> @llvm.colossus.SDAG.unary.v4i34.v8i17(i32 %id, <8 x i17> %x)
  ret <4 x i34> %res
}

define <3 x i48> @zero_extend_v8i18_to_v3i48(<8 x i18> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <3 x i48> @llvm.colossus.SDAG.unary.v3i48.v8i18(i32 %id, <8 x i18> %x)
  ret <3 x i48> %res
}

define <4 x i36> @zero_extend_v8i18_to_v4i36(<8 x i18> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <4 x i36> @llvm.colossus.SDAG.unary.v4i36.v8i18(i32 %id, <8 x i18> %x)
  ret <4 x i36> %res
}

define <6 x i24> @zero_extend_v8i18_to_v6i24(<8 x i18> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <6 x i24> @llvm.colossus.SDAG.unary.v6i24.v8i18(i32 %id, <8 x i18> %x)
  ret <6 x i24> %res
}

define <4 x i38> @zero_extend_v8i19_to_v4i38(<8 x i19> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <4 x i38> @llvm.colossus.SDAG.unary.v4i38.v8i19(i32 %id, <8 x i19> %x)
  ret <4 x i38> %res
}

define <4 x i40> @zero_extend_v8i20_to_v4i40(<8 x i20> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <4 x i40> @llvm.colossus.SDAG.unary.v4i40.v8i20(i32 %id, <8 x i20> %x)
  ret <4 x i40> %res
}

define <5 x i32> @zero_extend_v8i20_to_v5i32(<8 x i20> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <5 x i32> @llvm.colossus.SDAG.unary.v5i32.v8i20(i32 %id, <8 x i20> %x)
  ret <5 x i32> %res
}

define <3 x i56> @zero_extend_v8i21_to_v3i56(<8 x i21> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <3 x i56> @llvm.colossus.SDAG.unary.v3i56.v8i21(i32 %id, <8 x i21> %x)
  ret <3 x i56> %res
}

define <4 x i42> @zero_extend_v8i21_to_v4i42(<8 x i21> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <4 x i42> @llvm.colossus.SDAG.unary.v4i42.v8i21(i32 %id, <8 x i21> %x)
  ret <4 x i42> %res
}

define <6 x i28> @zero_extend_v8i21_to_v6i28(<8 x i21> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <6 x i28> @llvm.colossus.SDAG.unary.v6i28.v8i21(i32 %id, <8 x i21> %x)
  ret <6 x i28> %res
}

define <7 x i24> @zero_extend_v8i21_to_v7i24(<8 x i21> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <7 x i24> @llvm.colossus.SDAG.unary.v7i24.v8i21(i32 %id, <8 x i21> %x)
  ret <7 x i24> %res
}

define <4 x i44> @zero_extend_v8i22_to_v4i44(<8 x i22> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <4 x i44> @llvm.colossus.SDAG.unary.v4i44.v8i22(i32 %id, <8 x i22> %x)
  ret <4 x i44> %res
}

define <4 x i46> @zero_extend_v8i23_to_v4i46(<8 x i23> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <4 x i46> @llvm.colossus.SDAG.unary.v4i46.v8i23(i32 %id, <8 x i23> %x)
  ret <4 x i46> %res
}

define <3 x i64> @zero_extend_v8i24_to_v3i64(<8 x i24> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <3 x i64> @llvm.colossus.SDAG.unary.v3i64.v8i24(i32 %id, <8 x i24> %x)
  ret <3 x i64> %res
}

define <4 x i48> @zero_extend_v8i24_to_v4i48(<8 x i24> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <4 x i48> @llvm.colossus.SDAG.unary.v4i48.v8i24(i32 %id, <8 x i24> %x)
  ret <4 x i48> %res
}

define <6 x i32> @zero_extend_v8i24_to_v6i32(<8 x i24> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <6 x i32> @llvm.colossus.SDAG.unary.v6i32.v8i24(i32 %id, <8 x i24> %x)
  ret <6 x i32> %res
}

define <4 x i50> @zero_extend_v8i25_to_v4i50(<8 x i25> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <4 x i50> @llvm.colossus.SDAG.unary.v4i50.v8i25(i32 %id, <8 x i25> %x)
  ret <4 x i50> %res
}

define <5 x i40> @zero_extend_v8i25_to_v5i40(<8 x i25> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <5 x i40> @llvm.colossus.SDAG.unary.v5i40.v8i25(i32 %id, <8 x i25> %x)
  ret <5 x i40> %res
}

define <4 x i52> @zero_extend_v8i26_to_v4i52(<8 x i26> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <4 x i52> @llvm.colossus.SDAG.unary.v4i52.v8i26(i32 %id, <8 x i26> %x)
  ret <4 x i52> %res
}

define <4 x i54> @zero_extend_v8i27_to_v4i54(<8 x i27> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <4 x i54> @llvm.colossus.SDAG.unary.v4i54.v8i27(i32 %id, <8 x i27> %x)
  ret <4 x i54> %res
}

define <6 x i36> @zero_extend_v8i27_to_v6i36(<8 x i27> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <6 x i36> @llvm.colossus.SDAG.unary.v6i36.v8i27(i32 %id, <8 x i27> %x)
  ret <6 x i36> %res
}

define <4 x i56> @zero_extend_v8i28_to_v4i56(<8 x i28> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <4 x i56> @llvm.colossus.SDAG.unary.v4i56.v8i28(i32 %id, <8 x i28> %x)
  ret <4 x i56> %res
}

define <7 x i32> @zero_extend_v8i28_to_v7i32(<8 x i28> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <7 x i32> @llvm.colossus.SDAG.unary.v7i32.v8i28(i32 %id, <8 x i28> %x)
  ret <7 x i32> %res
}

define <4 x i58> @zero_extend_v8i29_to_v4i58(<8 x i29> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <4 x i58> @llvm.colossus.SDAG.unary.v4i58.v8i29(i32 %id, <8 x i29> %x)
  ret <4 x i58> %res
}

define <4 x i60> @zero_extend_v8i30_to_v4i60(<8 x i30> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <4 x i60> @llvm.colossus.SDAG.unary.v4i60.v8i30(i32 %id, <8 x i30> %x)
  ret <4 x i60> %res
}

define <5 x i48> @zero_extend_v8i30_to_v5i48(<8 x i30> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <5 x i48> @llvm.colossus.SDAG.unary.v5i48.v8i30(i32 %id, <8 x i30> %x)
  ret <5 x i48> %res
}

define <6 x i40> @zero_extend_v8i30_to_v6i40(<8 x i30> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <6 x i40> @llvm.colossus.SDAG.unary.v6i40.v8i30(i32 %id, <8 x i30> %x)
  ret <6 x i40> %res
}

define <4 x i62> @zero_extend_v8i31_to_v4i62(<8 x i31> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <4 x i62> @llvm.colossus.SDAG.unary.v4i62.v8i31(i32 %id, <8 x i31> %x)
  ret <4 x i62> %res
}

define <4 x i64> @zero_extend_v8i32_to_v4i64(<8 x i32> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <4 x i64> @llvm.colossus.SDAG.unary.v4i64.v8i32(i32 %id, <8 x i32> %x)
  ret <4 x i64> %res
}

define <6 x i44> @zero_extend_v8i33_to_v6i44(<8 x i33> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <6 x i44> @llvm.colossus.SDAG.unary.v6i44.v8i33(i32 %id, <8 x i33> %x)
  ret <6 x i44> %res
}

define <5 x i56> @zero_extend_v8i35_to_v5i56(<8 x i35> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <5 x i56> @llvm.colossus.SDAG.unary.v5i56.v8i35(i32 %id, <8 x i35> %x)
  ret <5 x i56> %res
}

define <7 x i40> @zero_extend_v8i35_to_v7i40(<8 x i35> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <7 x i40> @llvm.colossus.SDAG.unary.v7i40.v8i35(i32 %id, <8 x i35> %x)
  ret <7 x i40> %res
}

define <6 x i48> @zero_extend_v8i36_to_v6i48(<8 x i36> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <6 x i48> @llvm.colossus.SDAG.unary.v6i48.v8i36(i32 %id, <8 x i36> %x)
  ret <6 x i48> %res
}

define <6 x i52> @zero_extend_v8i39_to_v6i52(<8 x i39> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <6 x i52> @llvm.colossus.SDAG.unary.v6i52.v8i39(i32 %id, <8 x i39> %x)
  ret <6 x i52> %res
}

define <5 x i64> @zero_extend_v8i40_to_v5i64(<8 x i40> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <5 x i64> @llvm.colossus.SDAG.unary.v5i64.v8i40(i32 %id, <8 x i40> %x)
  ret <5 x i64> %res
}

define <6 x i56> @zero_extend_v8i42_to_v6i56(<8 x i42> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <6 x i56> @llvm.colossus.SDAG.unary.v6i56.v8i42(i32 %id, <8 x i42> %x)
  ret <6 x i56> %res
}

define <7 x i48> @zero_extend_v8i42_to_v7i48(<8 x i42> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <7 x i48> @llvm.colossus.SDAG.unary.v7i48.v8i42(i32 %id, <8 x i42> %x)
  ret <7 x i48> %res
}

define <6 x i60> @zero_extend_v8i45_to_v6i60(<8 x i45> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <6 x i60> @llvm.colossus.SDAG.unary.v6i60.v8i45(i32 %id, <8 x i45> %x)
  ret <6 x i60> %res
}

define <6 x i64> @zero_extend_v8i48_to_v6i64(<8 x i48> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <6 x i64> @llvm.colossus.SDAG.unary.v6i64.v8i48(i32 %id, <8 x i48> %x)
  ret <6 x i64> %res
}

define <7 x i56> @zero_extend_v8i49_to_v7i56(<8 x i49> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <7 x i56> @llvm.colossus.SDAG.unary.v7i56.v8i49(i32 %id, <8 x i49> %x)
  ret <7 x i56> %res
}

define <7 x i64> @zero_extend_v8i56_to_v7i64(<8 x i56> %x) {
  %id = load i32, i32* @ISD_ZERO_EXTEND_VECTOR_INREG
  %res = call <7 x i64> @llvm.colossus.SDAG.unary.v7i64.v8i56(i32 %id, <8 x i56> %x)
  ret <7 x i64> %res
}

