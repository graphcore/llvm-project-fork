#RUN: not llvm-mc -filetype=obj -triple colossus-graphcore-elf -assemble %s  2>&1 | FileCheck --strict-whitespace %s

#CHECK: memri_invalid.s:6:16: error: Invalid post increment on operand
#CHECK-NEXT:      ld32 $m0, $m0, $m2+=, 1
#CHECK-NEXT: {{^}}               ^{{$}}
ld32 $m0, $m0, $m2+=, 1

#CHECK: memri_invalid.s:11:21: error: Operand is not a valid immediate
#CHECK-NEXT:      ld32 $m0, $m1, $m2, ABC
#CHECK-NEXT: {{^}}                    ^{{$}}
ld32 $m0, $m1, $m2, ABC

#CHECK: memri_invalid.s:16:21: error: Out of bound immediate
#CHECK-NEXT:      ld32 $m0, $m1, $m2, (1 << 12)
#CHECK-NEXT: {{^}}                    ^{{$}}
ld32 $m0, $m1, $m2, (1 << 12)

#CHECK: memri_invalid.s:21:21: error: Out of bound immediate
#CHECK-NEXT:      ld32 $m0, $m1, $m2, -1
#CHECK-NEXT: {{^}}                    ^{{$}}
ld32 $m0, $m1, $m2, -1

#CHECK: memri_invalid.s:26:16: error: Operand is not a valid immediate
#CHECK-NEXT:      ld32 $m0, $m1, ABC
#CHECK-NEXT: {{^}}               ^{{$}}
ld32 $m0, $m1, ABC

#CHECK: memri_invalid.s:31:16: error: Out of bound immediate
#CHECK-NEXT:      ld32 $m0, $m1, (1 << 12)
#CHECK-NEXT: {{^}}               ^{{$}}
ld32 $m0, $m1, (1 << 12)

#CHECK: memri_invalid.s:36:16: error: Out of bound immediate
#CHECK-NEXT:      ld32 $m0, $m1, -1
#CHECK-NEXT: {{^}}               ^{{$}}
ld32 $m0, $m1, -1

#CHECK: memri_invalid.s:41:16: error: Invalid post increment on operand
#CHECK-NEXT:      st32 $m0, $m0, $m2+=, 1
#CHECK-NEXT: {{^}}               ^{{$}}
st32 $m0, $m0, $m2+=, 1

#CHECK: memri_invalid.s:46:21: error: Operand is not a valid immediate
#CHECK-NEXT:      st32 $m0, $m1, $m2, ABC
#CHECK-NEXT: {{^}}                    ^{{$}}
st32 $m0, $m1, $m2, ABC

#CHECK: memri_invalid.s:51:21: error: Out of bound immediate
#CHECK-NEXT:      st32 $m0, $m1, $m2, (1 << 12)
#CHECK-NEXT: {{^}}                    ^{{$}}
st32 $m0, $m1, $m2, (1 << 12)

#CHECK: memri_invalid.s:56:21: error: Out of bound immediate
#CHECK-NEXT:      st32 $m0, $m1, $m2, -1
#CHECK-NEXT: {{^}}                    ^{{$}}
st32 $m0, $m1, $m2, -1

#CHECK: memri_invalid.s:61:16: error: Operand is not a valid immediate
#CHECK-NEXT:      st32 $m0, $m1, ABC
#CHECK-NEXT: {{^}}               ^{{$}}
st32 $m0, $m1, ABC

#CHECK: memri_invalid.s:66:16: error: Out of bound immediate
#CHECK-NEXT:      st32 $m0, $m1, (1 << 12)
#CHECK-NEXT: {{^}}               ^{{$}}
st32 $m0, $m1, (1 << 12)

#CHECK: memri_invalid.s:71:16: error: Out of bound immediate
#CHECK-NEXT:      st32 $m0, $m1, -1
#CHECK-NEXT: {{^}}               ^{{$}}
st32 $m0, $m1, -1
