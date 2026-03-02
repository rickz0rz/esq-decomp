#include "esq_types.h"

/*
 * Target 265 GCC trial function.
 * Jump-table stub forwarding to TLIBA3_SelectNextViewMode.
 */
void TLIBA3_SelectNextViewMode(void) __attribute__((noinline));

void GROUP_AK_JMPTBL_TLIBA3_SelectNextViewMode(void) __attribute__((noinline, used));

void GROUP_AK_JMPTBL_TLIBA3_SelectNextViewMode(void)
{
    TLIBA3_SelectNextViewMode();
}
