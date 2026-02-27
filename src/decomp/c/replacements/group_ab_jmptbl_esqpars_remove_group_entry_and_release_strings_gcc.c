#include "esq_types.h"

/*
 * Target 208 GCC trial function.
 * Jump-table stub forwarding to ESQPARS_RemoveGroupEntryAndReleaseStrings.
 */
void ESQPARS_RemoveGroupEntryAndReleaseStrings(void) __attribute__((noinline));

void GROUP_AB_JMPTBL_ESQPARS_RemoveGroupEntryAndReleaseStrings(void) __attribute__((noinline, used));

void GROUP_AB_JMPTBL_ESQPARS_RemoveGroupEntryAndReleaseStrings(void)
{
    ESQPARS_RemoveGroupEntryAndReleaseStrings();
}
