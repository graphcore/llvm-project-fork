// RUN: %clang -###  %s -o %t.o -Os 2>&1 |\
// RUN: FileCheck -check-prefix=CC1-OS %s
// CC1-OS: "-mllvm" "-max-nops-in-rpt=1"
// CC1-OS: "-mllvm" "-nop-threshold-in-rpt=0"

// RUN: %clang -###  %s -o %t.o -Os -mmax-nops-in-rpt=42 2>&1 |\
// RUN: FileCheck -check-prefix=CC1-OS-NOPS %s
// CC1-OS-NOPS: "-mllvm" "-max-nops-in-rpt=42"
// CC1-OS-NOPS: "-mllvm" "-nop-threshold-in-rpt=0"

// RUN: %clang -###  %s -o %t.o -Os -mnop-threshold-in-rpt=1 2>&1  |\
// RUN: FileCheck -check-prefix=CC1-OS-THRESHOLD %s
// CC1-OS-THRESHOLD: "-mllvm" "-max-nops-in-rpt=1"
// CC1-OS-THRESHOLD: "-mllvm" "-nop-threshold-in-rpt=1"

// RUN: %clang -###  %s -o %t.o -Os -mmax-nops-in-rpt=42 -mnop-threshold-in-rpt=1 2>&1 |\
// RUN: FileCheck -check-prefix=CC1-OS-NOPS-THRESHOLD %s
// CC1-OS-NOPS-THRESHOLD: "-mllvm" "-max-nops-in-rpt=42"
// CC1-OS-NOPS-THRESHOLD: "-mllvm" "-nop-threshold-in-rpt=1"

// RUN: %clang -###  %s -o %t.o -mmax-nops-in-rpt=42 2>&1 |\
// RUN: FileCheck -check-prefix=CC1-NOPS %s
// CC1-NOPS-NOT: -nop-threshold-in-rpt=
// CC1-NOPS: "-mllvm" "-max-nops-in-rpt=42"

// RUN: %clang -###  %s -o %t.o -mnop-threshold-in-rpt=1 2>&1 |\
// RUN: FileCheck -check-prefix=CC1-THRESHOLD %s
// CC1-THRESHOLD-NOT: -max-nops-in-rpt=
// CC1-THRESHOLD: "-mllvm" "-nop-threshold-in-rpt=1"

// RUN: %clang -###  %s -o %t.o -mmax-nops-in-rpt=42 -mnop-threshold-in-rpt=1 2>&1 |\
// RUN: FileCheck -check-prefix=CC1-NOPS-THRESHOLD %s
// CC1-NOPS-THRESHOLD: "-mllvm" "-max-nops-in-rpt=42"
// CC1-NOPS-THRESHOLD: "-mllvm" "-nop-threshold-in-rpt=1"

// RUN: %clang -###  %s -o %t.o 2>&1 |\
// RUN: FileCheck -check-prefix=DEFAULT %s
// DEFAULT-NOT: -nop-threshold-in-rpt=
// DEFAULT-NOT: -max-nops-in-rpt=