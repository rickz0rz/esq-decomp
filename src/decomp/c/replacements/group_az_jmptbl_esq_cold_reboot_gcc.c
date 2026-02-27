#include "esq_types.h"

/*
 * Target 197 GCC trial function.
 * Jump-table stub forwarding to ESQ_ColdReboot.
 */
void ESQ_ColdReboot(void) __attribute__((noinline));

void GROUP_AZ_JMPTBL_ESQ_ColdReboot(void) __attribute__((noinline, used));

void GROUP_AZ_JMPTBL_ESQ_ColdReboot(void)
{
    ESQ_ColdReboot();
}
