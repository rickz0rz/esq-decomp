#include "esq_types.h"

/*
 * Target 164 GCC trial function.
 * Jump-table stub forwarding to ESQ_MainEntryNoOpHook.
 */
void ESQ_MainEntryNoOpHook(void) __attribute__((noinline));

void GROUP_MAIN_A_JMPTBL_ESQ_MainEntryNoOpHook(void) __attribute__((noinline, used));

void GROUP_MAIN_A_JMPTBL_ESQ_MainEntryNoOpHook(void)
{
    ESQ_MainEntryNoOpHook();
}
