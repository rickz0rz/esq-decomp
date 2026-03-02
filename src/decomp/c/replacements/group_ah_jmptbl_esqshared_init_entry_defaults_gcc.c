#include "esq_types.h"

/*
 * Target 245 GCC trial function.
 * Jump-table stub forwarding to ESQSHARED_InitEntryDefaults.
 */
void ESQSHARED_InitEntryDefaults(void) __attribute__((noinline));

void GROUP_AH_JMPTBL_ESQSHARED_InitEntryDefaults(void) __attribute__((noinline, used));

void GROUP_AH_JMPTBL_ESQSHARED_InitEntryDefaults(void)
{
    ESQSHARED_InitEntryDefaults();
}
