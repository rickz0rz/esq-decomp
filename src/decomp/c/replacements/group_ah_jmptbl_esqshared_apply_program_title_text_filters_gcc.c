#include "esq_types.h"

/*
 * Target 243 GCC trial function.
 * Jump-table stub forwarding to ESQSHARED_ApplyProgramTitleTextFilters.
 */
void ESQSHARED_ApplyProgramTitleTextFilters(void) __attribute__((noinline));

void GROUP_AH_JMPTBL_ESQSHARED_ApplyProgramTitleTextFilters(void) __attribute__((noinline, used));

void GROUP_AH_JMPTBL_ESQSHARED_ApplyProgramTitleTextFilters(void)
{
    ESQSHARED_ApplyProgramTitleTextFilters();
}
