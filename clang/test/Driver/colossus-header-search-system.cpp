// UNSUPPORTED: system-windows

// General tests that the system header search paths detected by the driver
// and passed to CC1 are correct on Colossus platforms.

// Check system headers (everything below <installdir> and <resource-dir>).
//
// RUN: %clang -no-canonical-prefixes %s -### -fsyntax-only 2>&1 \
// RUN:     -target colossus \
// RUN:     -ccc-install-dir %S/Inputs/basic_colossus_toolchain_no_libcxx/usr/bin \
// RUN:     -resource-dir=%S/Inputs/resource_dir \
// RUN:   | FileCheck -DINSTALLDIR=%S/Inputs/basic_colossus_toolchain_no_libcxx/usr/bin \
// RUN:               -DRESOURCE=%S/Inputs/resource_dir \
// RUN:               --check-prefix=CHECK-SYSTEM %s
//
// CHECK-SYSTEM: "{{[^"]*}}clang{{[^"]*}}" "-cc1"
// CHECK-SYSTEM: "-internal-isystem" "[[INSTALLDIR]]/../colossus/include"
// CHECK-SYSTEM: "-internal-isystem" "[[RESOURCE]]/include"

// Make sure that using -nostdlibinc will drop <sysroot>/usr/local/include and
// <sysroot>/usr/include.
//
// RUN: %clang -no-canonical-prefixes %s -### -fsyntax-only 2>&1 \
// RUN:     -target colossus \
// RUN:     -ccc-install-dir %S/Inputs/basic_colossus_toolchain_no_libcxx/usr/bin \
// RUN:     -resource-dir=%S/Inputs/resource_dir \
// RUN:     -nostdlibinc \
// RUN:   | FileCheck -DINSTALLDIR=%S/Inputs/basic_colossus_toolchain_no_libcxx/usr/bin \
// RUN:               -DRESOURCE=%S/Inputs/resource_dir \
// RUN:               --check-prefix=CHECK-NOSTDLIBINC %s
// CHECK-NOSTDLIBINC: "{{[^"]*}}clang{{[^"]*}}" "-cc1"
// CHECK-NOSTDLIBINC-NOT: "-internal-isystem" "[[INSTALLDIR]]/../colossus/include"
// CHECK-NOSTDLIBINC: "-internal-isystem" "[[RESOURCE]]/include"

// Make sure that -nostdinc drops all the system include paths, including
// <resource>/include.
//
// RUN: %clang -no-canonical-prefixes %s -### -fsyntax-only 2>&1 \
// RUN:     -target colossus \
// RUN:     -ccc-install-dir %S/Inputs/basic_colossus_toolchain_no_libcxx/usr/bin \
// RUN:     -resource-dir=%S/Inputs/resource_dir \
// RUN:     -nostdinc \
// RUN:   | FileCheck -DINSTALLDIR=%S/Inputs/basic_colossus_toolchain_no_libcxx/usr/bin \
// RUN:               -DRESOURCE=%S/Inputs/resource_dir \
// RUN:               --check-prefix=CHECK-NOSTDINC %s
// CHECK-NOSTDINC: "{{[^"]*}}clang{{[^"]*}}" "-cc1"
// CHECK-NOSTDINC-NOT: "-internal-isystem" "[[INSTALLDIR]]/../colossus/include"
// CHECK-NOSTDINC-NOT: "-internal-isystem" "[[RESOURCE]]/include"
