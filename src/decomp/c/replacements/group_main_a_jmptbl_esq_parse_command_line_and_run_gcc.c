#include "esq_types.h"

/*
 * Target 166 GCC trial function.
 * Jump-table stub forwarding to ESQ_ParseCommandLineAndRun.
 */
void ESQ_ParseCommandLineAndRun(void) __attribute__((noinline));

void GROUP_MAIN_A_JMPTBL_ESQ_ParseCommandLineAndRun(void) __attribute__((noinline, used));

void GROUP_MAIN_A_JMPTBL_ESQ_ParseCommandLineAndRun(void)
{
    ESQ_ParseCommandLineAndRun();
}
