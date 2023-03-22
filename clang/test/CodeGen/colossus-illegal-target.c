// REQUIRES: colossus-registered-target
// RUN: not %clang -DWORKER_SUPERVISOR -S -emit-llvm -o /dev/null %s 2>&1 | FileCheck %s --check-prefix=WORKER_SUPERVISOR
// RUN: not %clang -DBOTH_WORKER -S -emit-llvm -o /dev/null %s 2>&1 | FileCheck %s --check-prefix=BOTH_WORKER
// RUN: not %clang -DBOTH_SUPERVISOR -S -emit-llvm -o /dev/null %s 2>&1 | FileCheck %s --check-prefix=BOTH_SUPERVISOR

#if defined(WORKER_SUPERVISOR)
// WORKER_SUPERVISOR: error: option '+worker' cannot be specified with '+supervisor'
__attribute__((target("worker,supervisor")))
void worker_and_supervisor() {}
#elif defined(BOTH_WORKER)
// BOTH_WORKER: error: option '+both' cannot be specified with '+worker'
__attribute__((target("both,worker")))
void worker_and_supervisor() {}
#elif defined(BOTH_SUPERVISOR)
// BOTH_SUPERVISOR: error: option '+both' cannot be specified with '+supervisor'
__attribute__((target("both,supervisor")))
void worker_and_supervisor() {}
#endif
