# RUN: llvm-mc -mattr=+supervisor -arch=colossus  < %s \
# RUN:        -defsym SUPERVISOR=1 | FileCheck %s -check-prefix=CHECK-SUPERVISOR
# RUN: not llvm-mc -arch=colossus  < %s \
# RUN:        -defsym SUPERVISOR=1 2>&1 | FileCheck %s -check-prefix=CHECK-WORKER-FAIL
# RUN: not llvm-mc -mattr=+supervisor -arch=colossus  < %s \
# RUN:        -defsym WORKER=1 2>&1 | FileCheck %s -check-prefix=CHECK-SUPERVISOR-FAIL
# RUN: llvm-mc -arch=colossus  < %s \
# RUN:        -defsym WORKER=1 -defsym WORKERONLY=1 | FileCheck %s -check-prefix=CHECK-WORKER
# RUN: llvm-mc -arch=colossus  < %s -defsym NOERRORS=1 \
# RUN:        -defsym SUPERVISOR=1 | FileCheck %s -check-prefix=CHECK-SUPERVISOR
# RUN: llvm-mc -mattr=+supervisor -arch=colossus  < %s -defsym NOERRORS=1 \
# RUN:        -defsym WORKER=1 -defsym WORKERONLY=1 | FileCheck %s -check-prefix=CHECK-WORKER

put $PC, $m0
# CHECK-SUPERVISOR: put 0, $m0
# CHECK-WORKER: put 0, $m0

.ifdef NOERRORS
.allow_invalid_execution_mode
.endif

.ifdef SUPERVISOR

get $m0, $CWEI_0_2
# CHECK-SUPERVISOR: get $m0, 2
# CHECK-WORKER-FAIL: The CSR $CWEI_0_2 cannot be used in Worker mode.

put $CTXT_STS, $m0
# CHECK-SUPERVISOR: put 114, $m0
# CHECK-WORKER-FAIL: The CSR $CTXT_STS cannot be used in Worker mode.

.endif

.ifdef WORKER

put $PRNG_0_0, $m0
# CHECK-SUPERVISOR-FAIL: The CSR $PRNG_0_0 cannot be used in Supervisor mode.
# CHECK-WORKER: put 3, $m0

get $m0, $PRNG_SEED
# CHECK-SUPERVISOR-FAIL: The CSR $PRNG_SEED cannot be used in Supervisor mode.
# CHECK-WORKER: get $m0, 7

.endif

.ifdef WORKERONLY

put $PRNG_0_1, $a0
# CHECK-WORKER: put 4, $a0

get $a0, $PRNG_1_0
# CHECK-WORKER: get $a0, 5

uput $PRNG_0_1, $a0
# CHECK-WORKER: put 4, $a0

uget $a0, $PRNG_1_0
# CHECK-WORKER: get $a0, 5

.endif
