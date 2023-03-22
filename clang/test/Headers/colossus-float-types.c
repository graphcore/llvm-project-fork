// REQUIRES: colossus-registered-target

// Check compiling custom IPU float types works in supervisor mode.
// RUN: %clang -S -O0 -target colossus -msupervisor %s -o /dev/null

#include <ipudef.h>

struct foo {
  half h1;
  half2 h2;
  half4 h4;
  float2 f2;
  float4 f4;
};

__attribute__((target("worker")))
int worker(struct foo *);

int call_worker(struct foo *f) {
  return worker(f);
}
