#include "esq_types.h"

/*
 * Target 079 GCC trial function.
 * Main-exit hook is currently a no-op.
 */
void ESQ_MainExitNoOpHook(void) __attribute__((noinline, used));

void ESQ_MainExitNoOpHook(void)
{
}
