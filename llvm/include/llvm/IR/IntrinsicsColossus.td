//==- IntrinsicsColossus.td - Colossus intrinsics -----------*- tablegen -*-==//
//    Copyright (c) 2023 Graphcore Ltd. All Rights Reserved.
//     Licensed under the Apache License, Version 2.0 (the "License");
//     you may not use this file except in compliance with the License.
//     You may obtain a copy of the License at
//
//        http://www.apache.org/licenses/LICENSE-2.0
//
//     Unless required by applicable law or agreed to in writing, software
//     distributed under the License is distributed on an "AS IS" BASIS,
//     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//     See the License for the specific language governing permissions and
//     limitations under the License.
// --- LLVM Exceptions to the Apache 2.0 License ----
//
// As an exception, if, as a result of your compiling your source code, portions
// of this Software are embedded into an Object form of such source code, you
// may redistribute such embedded portions in such Object form without complying
// with the conditions of Sections 4(a), 4(b) and 4(d) of the License.
//
// In addition, if you combine or link compiled forms of this Software with
// software that is licensed under the GPLv2 ("Combined Software") and if a
// court of competent jurisdiction determines that the patent provision (Section
// 3), the indemnity provision (Section 9) or other Section of the License
// conflicts with the conditions of the GPLv2, you may retroactively and
// prospectively choose to deem waived or otherwise exclude such Section(s) of
// the License, but only in their entirety and only with respect to the Combined
// Software.
//
//===----------------------------------------------------------------------===//
//
// This file defines all of the Colossus-specific intrinsics.
//
//===----------------------------------------------------------------------===//

// All intrinsics start with "llvm.colossus.".
let TargetPrefix = "colossus" in {

  def int_colossus_get_scount_l :
    Intrinsic<[llvm_i32_ty]>,
    ClangBuiltin<"__builtin_ipu_get_scount_l">;

  def int_colossus_get_scount_u :
    Intrinsic<[llvm_i32_ty]>,
    ClangBuiltin<"__builtin_ipu_get_scount_u">;

  def int_colossus_get_vertex_base :
    Intrinsic<[llvm_ptr_ty],[],[IntrNoMem]>,
    ClangBuiltin<"__builtin_ipu_get_vertex_base">;

  def int_colossus_get_tile_id :
    Intrinsic<[llvm_i32_ty]>,
    ClangBuiltin<"__builtin_ipu_get_tile_id">;

  def int_colossus_tapack :
    Intrinsic<[llvm_v2i32_ty],
              [llvm_ptr_ty,llvm_ptr_ty,llvm_ptr_ty],
              [IntrNoMem]>,
    ClangBuiltin<"__builtin_ipu_tapack">;

  def int_colossus_urand32 :
    Intrinsic<[llvm_i32_ty],[],
              [IntrHasSideEffects, IntrNoDuplicate]>,
              ClangBuiltin<"__builtin_ipu_urand32">;
  def int_colossus_urand64 :
    Intrinsic<[llvm_i64_ty],[],
              [IntrHasSideEffects, IntrNoDuplicate]>,
              ClangBuiltin<"__builtin_ipu_urand64">;

  def int_colossus_urand_f16 :
    Intrinsic<[llvm_half_ty],[],
              [IntrHasSideEffects, IntrNoDuplicate]>,
              ClangBuiltin<"__builtin_ipu_urand_f16">;
  def int_colossus_urand_f32 :
    Intrinsic<[llvm_float_ty],[],
              [IntrHasSideEffects, IntrNoDuplicate]>,
              ClangBuiltin<"__builtin_ipu_urand_f32">;

  def int_colossus_is_worker_mode :
    Intrinsic<[llvm_i1_ty],[],[IntrNoMem]>,
    ClangBuiltin<"__builtin_ipu_is_worker_mode">;

  def int_colossus_get_worker_id :
    Intrinsic<[llvm_i32_ty]>,
    ClangBuiltin<"__builtin_ipu_get_worker_id">;

  // Stride is a signed i32
  // Type in {v2f32, f32, v4f16, v2f16, i32, v2i16}
  // ldstep also supports f16, i16, i8. ststep does not
  // v2i32, v4i16 is not well tested
  def int_colossus_ststep :
    Intrinsic<
      [LLVMPointerType<llvm_i8_ty>],      // return address + sizeof(ty) * stride
      [llvm_any_ty,                       // value
       LLVMPointerType<llvm_i8_ty>,       // address
       llvm_i32_ty],                      // stride
      [IntrWriteMem, IntrArgMemOnly]>;

  def int_colossus_ldstep :
    Intrinsic<
      [llvm_any_ty,                        // value
       LLVMPointerType<LLVMMatchType<0>>], // address + sizeof(ty) * stride
      [LLVMPointerType<LLVMMatchType<0>>,  // address
      llvm_i32_ty],                        // stride
    [IntrReadMem, IntrArgMemOnly]>;

  let IntrProperties = [IntrNoMem] in {
    def int_colossus_f16v2class : Intrinsic<[llvm_v2i16_ty], [llvm_v2f16_ty]>,
                                  ClangBuiltin<"__builtin_ipu_f16v2class">;
    def int_colossus_f16v4class : Intrinsic<[llvm_v4i16_ty], [llvm_v4f16_ty]>,
                                  ClangBuiltin<"__builtin_ipu_f16v4class">;
    def int_colossus_f32v2class : Intrinsic<[llvm_v2i16_ty], [llvm_v2f32_ty]>,
                                  ClangBuiltin<"__builtin_ipu_f32v2class">;
    def int_colossus_f32class   : Intrinsic<[llvm_i32_ty], [llvm_float_ty]>,
                                  ClangBuiltin<"__builtin_ipu_f32class">;

    def int_colossus_f32atan  : Intrinsic<[llvm_float_ty], [llvm_float_ty]>,
                                ClangBuiltin<"__builtin_ipu_f32atan">;

    def int_colossus_tanh : Intrinsic<[llvm_anyfloat_ty],
                                      [LLVMMatchType<0>]>;

    def int_colossus_rsqrt : Intrinsic<[llvm_anyfloat_ty],
                                       [LLVMMatchType<0>]>;

    def int_colossus_sigmoid : Intrinsic<[llvm_anyfloat_ty],
                                         [LLVMMatchType<0>]>;

    def int_colossus_f16v4rmask  : Intrinsic<[llvm_v4f16_ty],
                                   [llvm_v4f16_ty, llvm_float_ty]>,
                                   ClangBuiltin<"__builtin_ipu_f16v4rmask">;
    def int_colossus_f32v2rmask  : Intrinsic<[llvm_v2f32_ty],
                                   [llvm_v2f32_ty, llvm_float_ty]>,
                                   ClangBuiltin<"__builtin_ipu_f32v2rmask">;
    def int_colossus_f16v2sigm   : Intrinsic<[llvm_v2f16_ty], [llvm_v2f16_ty]>,
                                   ClangBuiltin<"__builtin_ipu_f16v2sigm">;
    def int_colossus_f32sigm     : Intrinsic<[llvm_float_ty], [llvm_float_ty]>,
                                   ClangBuiltin<"__builtin_ipu_f32sigm">;

    def int_colossus_f16v2sum    : Intrinsic<[llvm_float_ty], [llvm_v2f16_ty]>,
                                   ClangBuiltin<"__builtin_ipu_f16v2sum">;
    def int_colossus_f16v4sum    : Intrinsic<[llvm_v2f32_ty], [llvm_v4f16_ty]>,
                                   ClangBuiltin<"__builtin_ipu_f16v4sum">;

    def int_colossus_f16v2tanh   : Intrinsic<[llvm_v2f16_ty], [llvm_v2f16_ty]>,
                                   ClangBuiltin<"__builtin_ipu_f16v2tanh">;
  }

  def int_colossus_constrained_rsqrt : Intrinsic<[llvm_anyfloat_ty],
                                                 [LLVMMatchType<0>]>;

  def int_colossus_SDAG_unary :
    Intrinsic<[llvm_any_ty],
              [llvm_i32_ty, llvm_any_ty],
              [IntrNoMem]>;
  def int_colossus_SDAG_chained_unary :
    Intrinsic<[llvm_any_ty],
              [llvm_i32_ty, llvm_any_ty]>;
  def int_colossus_SDAG_binary :
    Intrinsic<[llvm_any_ty],
              [llvm_i32_ty, llvm_any_ty, llvm_any_ty],
              [IntrNoMem]>;
  def int_colossus_SDAG_binary_binary :
    Intrinsic<[llvm_any_ty, llvm_any_ty],
              [llvm_i32_ty, llvm_any_ty, llvm_any_ty],
              [IntrNoMem]>;

  def int_colossus_put    : Intrinsic<[], [llvm_i32_ty, llvm_any_ty],
                                      [IntrHasSideEffects, IntrNoDuplicate]>;
  def int_colossus_uput   : Intrinsic<[], [llvm_i32_ty, llvm_any_ty],
                                         [IntrHasSideEffects, IntrNoDuplicate]>;
  def int_colossus_uputf  : Intrinsic<[], [llvm_float_ty, llvm_any_ty],
                                         [IntrHasSideEffects, IntrNoDuplicate]>;
  def int_colossus_get    : Intrinsic<[llvm_i32_ty], [llvm_any_ty],
                                         [IntrHasSideEffects, IntrNoDuplicate]>;
  def int_colossus_uget   : Intrinsic<[llvm_i32_ty], [llvm_any_ty],
                                         [IntrHasSideEffects, IntrNoDuplicate]>;
  def int_colossus_ugetf  : Intrinsic<[llvm_float_ty], [llvm_any_ty],
                                         [IntrHasSideEffects, IntrNoDuplicate]>;

  def int_colossus_and_i32 : Intrinsic<[llvm_i32_ty],
                             [llvm_i32_ty, llvm_i32_ty],
                             [IntrNoMem]>, ClangBuiltin<"__builtin_ipu_and_i32">;
  def int_colossus_and_f32 : Intrinsic<[llvm_float_ty],
                             [llvm_float_ty, llvm_float_ty],
                             [IntrNoMem]>, ClangBuiltin<"__builtin_ipu_and_f32">;
  def int_colossus_and_v2f32 : Intrinsic<[llvm_v2f32_ty],
                               [llvm_v2f32_ty, llvm_v2f32_ty],
                               [IntrNoMem]>, ClangBuiltin<"__builtin_ipu_and_v2f32">;
  def int_colossus_andc_i32 : Intrinsic<[llvm_i32_ty],
                             [llvm_i32_ty, llvm_i32_ty],
                             [IntrNoMem]>, ClangBuiltin<"__builtin_ipu_andc_i32">;
  def int_colossus_andc_f32 : Intrinsic<[llvm_float_ty],
                             [llvm_float_ty, llvm_float_ty],
                             [IntrNoMem]>, ClangBuiltin<"__builtin_ipu_andc_f32">;
  def int_colossus_andc_v2f32 : Intrinsic<[llvm_v2f32_ty],
                               [llvm_v2f32_ty, llvm_v2f32_ty],
                               [IntrNoMem]>, ClangBuiltin<"__builtin_ipu_andc_v2f32">;
  def int_colossus_or_i32    : Intrinsic<[llvm_i32_ty],
                               [llvm_i32_ty, llvm_i32_ty],
                               [IntrNoMem]>, ClangBuiltin<"__builtin_ipu_or_i32">;
  def int_colossus_or_f32    : Intrinsic<[llvm_float_ty],
                               [llvm_float_ty, llvm_float_ty],
                               [IntrNoMem]>, ClangBuiltin<"__builtin_ipu_or_f32">;
  def int_colossus_or_v2f32  : Intrinsic<[llvm_v2f32_ty],
                               [llvm_v2f32_ty, llvm_v2f32_ty],
                               [IntrNoMem]>, ClangBuiltin<"__builtin_ipu_or_v2f32">;
  def int_colossus_not_f32   : Intrinsic<[llvm_float_ty], [llvm_float_ty],
                               [IntrNoMem]>, ClangBuiltin<"__builtin_ipu_not_f32">;
  def int_colossus_not_v2f32 : Intrinsic<[llvm_v2f32_ty], [llvm_v2f32_ty],
                               [IntrNoMem]>, ClangBuiltin<"__builtin_ipu_not_v2f32">;

  def int_colossus_bitrev8 : Intrinsic<[llvm_i32_ty], [llvm_i32_ty],
                             [IntrNoMem]>, ClangBuiltin<"__builtin_ipu_bitrev8">;
  def int_colossus_cms : Intrinsic<[llvm_i32_ty], [llvm_i32_ty],
                         [IntrNoMem]>, ClangBuiltin<"__builtin_ipu_cms">;
  def int_colossus_roll8l : Intrinsic<[llvm_i32_ty], [llvm_i32_ty, llvm_i32_ty],
                            [IntrNoMem]>, ClangBuiltin<"__builtin_ipu_roll8l">;
  def int_colossus_roll8r : Intrinsic<[llvm_i32_ty], [llvm_i32_ty, llvm_i32_ty],
                            [IntrNoMem]>, ClangBuiltin<"__builtin_ipu_roll8r">;

  def int_colossus_shuf8x8hi : Intrinsic<[llvm_i32_ty],
                               [llvm_i32_ty, llvm_i32_ty], [IntrNoMem]>,
                               ClangBuiltin<"__builtin_ipu_shuf8x8hi">;
  def int_colossus_shuf8x8lo : Intrinsic<[llvm_i32_ty],
                               [llvm_i32_ty, llvm_i32_ty], [IntrNoMem]>,
                               ClangBuiltin<"__builtin_ipu_shuf8x8lo">;
  def int_colossus_sort4x32hi : Intrinsic<[llvm_v2f32_ty],
                                [llvm_v2f32_ty, llvm_v2f32_ty], [IntrNoMem]>, 
                                ClangBuiltin<"__builtin_ipu_sort4x32hi">;
  def int_colossus_sort4x32lo : Intrinsic<[llvm_v2f32_ty],
                                [llvm_v2f32_ty, llvm_v2f32_ty], [IntrNoMem]>, 
                                ClangBuiltin<"__builtin_ipu_sort4x32lo">;
  def int_colossus_sort8x8hi : Intrinsic<[llvm_i32_ty],
                               [llvm_i32_ty, llvm_i32_ty], [IntrNoMem]>,
                               ClangBuiltin<"__builtin_ipu_sort8x8hi">;
  def int_colossus_sort8x8lo : Intrinsic<[llvm_i32_ty],
                               [llvm_i32_ty, llvm_i32_ty], [IntrNoMem]>,
                               ClangBuiltin<"__builtin_ipu_sort8x8lo">;
  def int_colossus_sort8     : Intrinsic<[llvm_i32_ty], [llvm_i32_ty], [IntrNoMem]>,
                               ClangBuiltin<"__builtin_ipu_sort8">;
  def int_colossus_swap8     : Intrinsic<[llvm_i32_ty], [llvm_i32_ty], [IntrNoMem]>,
                               ClangBuiltin<"__builtin_ipu_swap8">;

  class V2F16_Op_Intrinsic : 
        Intrinsic<[llvm_v2f16_ty], [llvm_v2f16_ty, llvm_v2f16_ty], [IntrNoMem]>;
  class V4F16_Op_Intrinsic : 
        Intrinsic<[llvm_v4f16_ty], [llvm_v4f16_ty, llvm_v4f16_ty], [IntrNoMem]>;
  class V2F32_Op_Intrinsic : 
        Intrinsic<[llvm_v2f32_ty], [llvm_v2f32_ty, llvm_v2f32_ty], [IntrNoMem]>;
  class F32_Op_Intrinsic : 
        Intrinsic<[llvm_float_ty], [llvm_float_ty, llvm_float_ty], [IntrNoMem]>;

  def int_colossus_roll32      : V2F32_Op_Intrinsic, 
                                 ClangBuiltin<"__builtin_ipu_roll32">;

  def int_colossus_f16v2absadd : V2F16_Op_Intrinsic,
                                 ClangBuiltin<"__builtin_ipu_f16v2absadd">;
  def int_colossus_f16v4absadd : V4F16_Op_Intrinsic,
                                 ClangBuiltin<"__builtin_ipu_f16v4absadd">;
  def int_colossus_f32v2absadd : V2F32_Op_Intrinsic,
                                 ClangBuiltin<"__builtin_ipu_f32v2absadd">;
  def int_colossus_f32absadd   : F32_Op_Intrinsic,
                                 ClangBuiltin<"__builtin_ipu_f32absadd">;

  def int_colossus_f16v2absmax : V2F16_Op_Intrinsic,
                                 ClangBuiltin<"__builtin_ipu_f16v2absmax">;
  def int_colossus_f16v4absmax : V4F16_Op_Intrinsic,
                                 ClangBuiltin<"__builtin_ipu_f16v4absmax">;
  def int_colossus_f32v2absmax : V2F32_Op_Intrinsic,
                                 ClangBuiltin<"__builtin_ipu_f32v2absmax">;
  def int_colossus_f32absmax   : F32_Op_Intrinsic,
                                 ClangBuiltin<"__builtin_ipu_f32absmax">;
  def int_colossus_f16v2max    : V2F16_Op_Intrinsic,
                                 ClangBuiltin<"__builtin_ipu_f16v2max">;
  def int_colossus_f16v4max    : V4F16_Op_Intrinsic,
                                 ClangBuiltin<"__builtin_ipu_f16v4max">;
  def int_colossus_f32v2max    : V2F32_Op_Intrinsic,
                                 ClangBuiltin<"__builtin_ipu_f32v2max">;
  def int_colossus_f32max      : F32_Op_Intrinsic,
                                 ClangBuiltin<"__builtin_ipu_f32max">;
  def int_colossus_f16v2maxc   : Intrinsic<[llvm_half_ty], [llvm_v2f16_ty],
                                 [IntrHasSideEffects]>,
                                 ClangBuiltin<"__builtin_ipu_f16v2maxc">;
  def int_colossus_f16v4maxc   : Intrinsic<[llvm_v2f16_ty], [llvm_v4f16_ty],
                                 [IntrHasSideEffects]>,
                                 ClangBuiltin<"__builtin_ipu_f16v4maxc">;
  def int_colossus_f16v2min    : V2F16_Op_Intrinsic,
                                 ClangBuiltin<"__builtin_ipu_f16v2min">;
  def int_colossus_f16v4min    : V4F16_Op_Intrinsic,
                                 ClangBuiltin<"__builtin_ipu_f16v4min">;
  def int_colossus_f32v2min    : V2F32_Op_Intrinsic,
                                 ClangBuiltin<"__builtin_ipu_f32v2min">;
  def int_colossus_f32min      : F32_Op_Intrinsic,
                                 ClangBuiltin<"__builtin_ipu_f32min">;

  def int_colossus_f16v2clamp  : V2F16_Op_Intrinsic,
                                 ClangBuiltin<"__builtin_ipu_f16v2clamp">;
  def int_colossus_f16v4clamp  : Intrinsic<[llvm_v4f16_ty],
                                 [llvm_v4f16_ty, llvm_v2f16_ty], [IntrNoMem]>,
                                 ClangBuiltin<"__builtin_ipu_f16v4clamp">;
  def int_colossus_f32v2clamp  : V2F32_Op_Intrinsic,
                                 ClangBuiltin<"__builtin_ipu_f32v2clamp">;
  def int_colossus_f32clamp    : Intrinsic<[llvm_float_ty],
                                 [llvm_float_ty, llvm_v2f32_ty], [IntrNoMem]>,
                                 ClangBuiltin<"__builtin_ipu_f32clamp">;

  def int_colossus_f16v2cmac   : Intrinsic<[], [llvm_v2f16_ty, llvm_v2f16_ty],
                                 [IntrHasSideEffects]>,
                                 ClangBuiltin<"__builtin_ipu_f16v2cmac">;
  def int_colossus_f16v4cmac   : Intrinsic<[], [llvm_v4f16_ty, llvm_v4f16_ty],
                                 [IntrHasSideEffects]>,
                                 ClangBuiltin<"__builtin_ipu_f16v4cmac">;

  def int_colossus_f16v2exp    : Intrinsic<[llvm_v2f16_ty], [llvm_v2f16_ty],
                                 [IntrNoMem]>,
                                 ClangBuiltin<"__builtin_ipu_f16v2exp">;
  def int_colossus_f16v2exp2   : Intrinsic<[llvm_v2f16_ty], [llvm_v2f16_ty],
                                 [IntrNoMem]>,
                                 ClangBuiltin<"__builtin_ipu_f16v2exp2">;
  def int_colossus_f16v2ln     : Intrinsic<[llvm_v2f16_ty], [llvm_v2f16_ty],
                                 [IntrNoMem]>,
                                 ClangBuiltin<"__builtin_ipu_f16v2ln">;
  def int_colossus_f16v2log2   : Intrinsic<[llvm_v2f16_ty], [llvm_v2f16_ty],
                                 [IntrNoMem]>,
                                 ClangBuiltin<"__builtin_ipu_f16v2log2">;

  def int_colossus_f32v2aop    : Intrinsic<[], [llvm_v2f32_ty, llvm_v2f32_ty,
                                            llvm_any_ty], [IntrHasSideEffects]>;
  def int_colossus_f32v2axpy   : V2F32_Op_Intrinsic,
                                 ClangBuiltin<"__builtin_ipu_f32v2axpy">;
  def int_colossus_f16v2gina   : Intrinsic<[llvm_v2f16_ty],
                                 [llvm_v2f16_ty, llvm_any_ty],
                                 [IntrHasSideEffects]>;
  def int_colossus_f32v2gina   : Intrinsic<[llvm_v2f32_ty],
                                 [llvm_v2f32_ty, llvm_any_ty],
                                 [IntrHasSideEffects]>;

  def int_colossus_f16v2grand  : Intrinsic<[llvm_v2f16_ty], [],
                                 [IntrHasSideEffects]>,
                                 ClangBuiltin<"__builtin_ipu_f16v2grand">;
  def int_colossus_f32v2grand  : Intrinsic<[llvm_v2f32_ty], [],
                                 [IntrHasSideEffects]>,
                                 ClangBuiltin<"__builtin_ipu_f32v2grand">;

  def int_colossus_f16v2cmpeq  : V2F16_Op_Intrinsic,
                                 ClangBuiltin<"__builtin_ipu_f16v2cmpeq">;
  def int_colossus_f16v4cmpeq  : V4F16_Op_Intrinsic,
                                 ClangBuiltin<"__builtin_ipu_f16v4cmpeq">;
  def int_colossus_f32v2cmpeq  : V2F32_Op_Intrinsic,
                                 ClangBuiltin<"__builtin_ipu_f32v2cmpeq">;
  def int_colossus_f32cmpeq    : F32_Op_Intrinsic,
                                 ClangBuiltin<"__builtin_ipu_f32cmpeq">;
  def int_colossus_f16v2cmpge  : V2F16_Op_Intrinsic,
                                 ClangBuiltin<"__builtin_ipu_f16v2cmpge">;
  def int_colossus_f16v4cmpge  : V4F16_Op_Intrinsic,
                                 ClangBuiltin<"__builtin_ipu_f16v4cmpge">;
  def int_colossus_f32v2cmpge  : V2F32_Op_Intrinsic,
                                 ClangBuiltin<"__builtin_ipu_f32v2cmpge">;
  def int_colossus_f32cmpge    : F32_Op_Intrinsic,
                                 ClangBuiltin<"__builtin_ipu_f32cmpge">;
  def int_colossus_f16v2cmpgt  : V2F16_Op_Intrinsic,
                                 ClangBuiltin<"__builtin_ipu_f16v2cmpgt">;
  def int_colossus_f16v4cmpgt  : V4F16_Op_Intrinsic,
                                 ClangBuiltin<"__builtin_ipu_f16v4cmpgt">;
  def int_colossus_f32v2cmpgt  : V2F32_Op_Intrinsic,
                                 ClangBuiltin<"__builtin_ipu_f32v2cmpgt">;
  def int_colossus_f32cmpgt    : F32_Op_Intrinsic,
                                 ClangBuiltin<"__builtin_ipu_f32cmpgt">;
  def int_colossus_f16v2cmple  : V2F16_Op_Intrinsic,
                                 ClangBuiltin<"__builtin_ipu_f16v2cmple">;
  def int_colossus_f16v4cmple  : V4F16_Op_Intrinsic,
                                 ClangBuiltin<"__builtin_ipu_f16v4cmple">;
  def int_colossus_f32v2cmple  : V2F32_Op_Intrinsic,
                                 ClangBuiltin<"__builtin_ipu_f32v2cmple">;
  def int_colossus_f32cmple    : F32_Op_Intrinsic,
                                 ClangBuiltin<"__builtin_ipu_f32cmple">;
  def int_colossus_f16v2cmplt  : V2F16_Op_Intrinsic,
                                 ClangBuiltin<"__builtin_ipu_f16v2cmplt">;
  def int_colossus_f16v4cmplt  : V4F16_Op_Intrinsic,
                                 ClangBuiltin<"__builtin_ipu_f16v4cmplt">;
  def int_colossus_f32v2cmplt  : V2F32_Op_Intrinsic,
                                 ClangBuiltin<"__builtin_ipu_f32v2cmplt">;
  def int_colossus_f32cmplt    : F32_Op_Intrinsic,
                                 ClangBuiltin<"__builtin_ipu_f32cmplt">;
  def int_colossus_f16v2cmpne  : V2F16_Op_Intrinsic,
                                 ClangBuiltin<"__builtin_ipu_f16v2cmpne">;
  def int_colossus_f16v4cmpne  : V4F16_Op_Intrinsic,
                                 ClangBuiltin<"__builtin_ipu_f16v4cmpne">;
  def int_colossus_f32v2cmpne  : V2F32_Op_Intrinsic,
                                 ClangBuiltin<"__builtin_ipu_f32v2cmpne">;
  def int_colossus_f32cmpne    : F32_Op_Intrinsic,
                                 ClangBuiltin<"__builtin_ipu_f32cmpne">;

  // Intrinsics for targeting hardware loops, introduced in
  // ColossusLoopConversion. The loop count is passed to cloop_begin
  // Return value of cloop_begin and of cloop_end passed to cloop_end via phi
  // This makes the i32 value an implicit induction variable
  // If lowering to brnzdec or brnz, this i32 value provides a register which is
  // used for an explicit induction variable
  // If lowering to rpt, this value is dropped and register pressure pessimised

  // The second i32 argument to each intrinsic is used to pass metadata to
  // the later transforms
  def int_colossus_cloop_begin :
    Intrinsic<[llvm_i32_ty],
              [llvm_i32_ty, llvm_i32_ty],
              [IntrHasSideEffects, IntrNoDuplicate]>;

  // returns induction variable, condition variable separately so they can be
  // lowered separately in ISel
  def int_colossus_cloop_end :
    Intrinsic<[llvm_i32_ty, llvm_i32_ty],
              [llvm_i32_ty, llvm_i32_ty],
              [IntrHasSideEffects, IntrNoDuplicate]>;
  
  // Intrinsic for checking if the counter value (first argument) is zero
  // Should only be generated if loop has been hinted as rpt
  // If lowered to rpt, then this instruction is removed, else if lowered to
  // brnzdec then will become a compare instr to check for 0
  // Returns true if counter is 0
  def int_colossus_cloop_guard :
    Intrinsic<[llvm_i32_ty],
              [llvm_i32_ty, llvm_i32_ty],
              [IntrHasSideEffects, IntrNoDuplicate]>;

}
