# RUN: llvm-mc %s -filetype=obj | llvm-readobj -S --sd - | FileCheck %s

# Test for [T34: Debug information incorrect / corrupt.]

#CHECK:      Name: .test
#CHECK:      SectionData
#CHECK-NEXT: 0000: 04000000

.section	.test,"",@progbits
.start_test:
	.long .end_test - .start_test
.end_test:

