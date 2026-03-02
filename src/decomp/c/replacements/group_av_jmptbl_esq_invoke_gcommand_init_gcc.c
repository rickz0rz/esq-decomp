#include "esq_types.h"

/*
 * Target 279 GCC trial function.
 * Jump-table stub forwarding to ESQ_InvokeGcommandInit.
 */
void ESQ_InvokeGcommandInit(void) __attribute__((noinline));

void GROUP_AV_JMPTBL_ESQ_InvokeGcommandInit(void) __attribute__((noinline, used));

void GROUP_AV_JMPTBL_ESQ_InvokeGcommandInit(void)
{
    ESQ_InvokeGcommandInit();
}
