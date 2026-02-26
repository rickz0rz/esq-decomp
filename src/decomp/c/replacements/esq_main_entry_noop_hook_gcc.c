#include "esq_types.h"

/*
 * Target 078 GCC trial function.
 * Main-entry hook is currently a no-op.
 */
void ESQ_MainEntryNoOpHook(void) __attribute__((noinline, used));

void ESQ_MainEntryNoOpHook(void)
{
}
