#include "esq_types.h"

/*
 * Target 165 GCC trial function.
 * Jump-table stub forwarding to MEMLIST_FreeAll.
 */
void MEMLIST_FreeAll(void) __attribute__((noinline));

void GROUP_MAIN_A_JMPTBL_MEMLIST_FreeAll(void) __attribute__((noinline, used));

void GROUP_MAIN_A_JMPTBL_MEMLIST_FreeAll(void)
{
    MEMLIST_FreeAll();
}
