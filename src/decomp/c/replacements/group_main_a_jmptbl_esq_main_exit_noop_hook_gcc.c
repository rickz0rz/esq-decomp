#include "esq_types.h"

/*
 * Target 163 GCC trial function.
 * Jump-table stub forwarding to ESQ_MainExitNoOpHook.
 */
void ESQ_MainExitNoOpHook(void) __attribute__((noinline));

void GROUP_MAIN_A_JMPTBL_ESQ_MainExitNoOpHook(void) __attribute__((noinline, used));

void GROUP_MAIN_A_JMPTBL_ESQ_MainExitNoOpHook(void)
{
    ESQ_MainExitNoOpHook();
}
