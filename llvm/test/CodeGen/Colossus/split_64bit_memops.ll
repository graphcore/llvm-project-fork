; RUN: llc < %s -march=colossus -mattr=+ipu1 -O3 -print-after=finalize-isel -o /dev/null 2>&1 | FileCheck --check-prefix=V4I16-STORE %s
; RUN: llc < %s -march=colossus -mattr=+ipu2 -O3 -print-after=finalize-isel -o /dev/null 2>&1 | FileCheck --check-prefix=V4I16-STORE %s

; V4I16-STORE-LABEL: split_v4i16_store:
; V4I16-STORE-DAG: ST32_ZI {{([^,]+,){3} 1, 0 :: \(store \(s32\) into %[[:alnum:]_.]+ \+ 4\)}}
; V4I16-STORE-DAG: ST32_ZI {{([^,]+,){3} 0, 0 :: \(store \(s32\) into %[[:alnum:]_.]+, align 8\)}}
define dso_local void @split_v4i16_store(<4 x i16>* %ptr, <4 x i16> %val) local_unnamed_addr {
  store <4 x i16> %val, <4 x i16>* %ptr, align 8
  ret void
}

; RUN: llc < %s -march=colossus -O3 -print-after=finalize-isel -mattr=+ipu1 -o /dev/null 2>&1 | FileCheck --check-prefix=V2I32-STORE %s
; RUN: llc < %s -march=colossus -O3 -print-after=finalize-isel -mattr=+ipu2 -o /dev/null 2>&1 | FileCheck --check-prefix=V2I32-STORE %s


; V2I32-STORE-LABEL: split_v2i32_store:
; V2I32-STORE-DAG: ST32_ZI {{([^,]+,){3} 1, 0 :: \(store \(s32\) into %[[:alnum:]_.]+ \+ 4\)}}
; V2I32-STORE-DAG: ST32_ZI {{([^,]+,){3} 0, 0 :: \(store \(s32\) into %[[:alnum:]_.]+, align 8\)}}
define dso_local void @split_v2i32_store(<2 x i32>* %ptr, <2 x i32> %val) local_unnamed_addr {
  store <2 x i32> %val, <2 x i32>* %ptr, align 8
  ret void
}

; RUN: llc < %s -march=colossus -O3 -print-after=finalize-isel -mattr=+ipu1 -o /dev/null 2>&1 | FileCheck --check-prefix=V4I16-LOAD %s
; RUN: llc < %s -march=colossus -O3 -print-after=finalize-isel -mattr=+ipu2 -o /dev/null 2>&1 | FileCheck --check-prefix=V4I16-LOAD %s

; V4I16-LOAD-LABEL: split_v4i16_load:
; V4I16-LOAD-DAG: LD32_ZI {{([^,]+,){2} 1, 0 :: \(load \(s32\) from %[[:alnum:]_.]+ \+ 4\)}}
; V4I16-LOAD-DAG: LD32_ZI {{([^,]+,){2} 0, 0 :: \(load \(s32\) from %[[:alnum:]_.]+, align 8\)}}
define dso_local <4 x i16> @split_v4i16_load(<4 x i16>* %ptr, i32 %idx) local_unnamed_addr {
  %ptr1 = getelementptr <4 x i16>, <4 x i16>* %ptr, i32 %idx
  %1 = load <4 x i16>, <4 x i16>* %ptr1, align 8
  ret <4 x i16> %1
}

; RUN: llc < %s -march=colossus -O3 -print-after=finalize-isel -mattr=+ipu1 -o /dev/null 2>&1 | FileCheck --check-prefix=V2I32-LOAD %s
; RUN: llc < %s -march=colossus -O3 -print-after=finalize-isel -mattr=+ipu2 -o /dev/null 2>&1 | FileCheck --check-prefix=V2I32-LOAD %s

; V2I32-LOAD-LABEL: split_v4i16_load:
; V2I32-LOAD-DAG: LD32_ZI {{([^,]+,){2} 1, 0 :: \(load \(s32\) from %[[:alnum:]_.]+ \+ 4\)}}
; V2I32-LOAD-DAG: LD32_ZI {{([^,]+,){2} 0, 0 :: \(load \(s32\) from %[[:alnum:]_.]+, align 8\)}}
define dso_local <2 x i32> @split_v2i32_load(<2 x i32>* %ptr, i32 %idx) local_unnamed_addr {
  %ptr1 = getelementptr <2 x i32>, <2 x i32>* %ptr, i32 %idx
  %1 = load <2 x i32>, <2 x i32>* %ptr1, align 8
  ret <2 x i32> %1
}
