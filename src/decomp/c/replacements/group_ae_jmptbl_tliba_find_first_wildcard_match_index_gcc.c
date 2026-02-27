#include "esq_types.h"

/*
 * Target 231 GCC trial function.
 * Jump-table stub forwarding to TLIBA_FindFirstWildcardMatchIndex.
 */
void TLIBA_FindFirstWildcardMatchIndex(void) __attribute__((noinline));

void GROUP_AE_JMPTBL_TLIBA_FindFirstWildcardMatchIndex(void) __attribute__((noinline, used));

void GROUP_AE_JMPTBL_TLIBA_FindFirstWildcardMatchIndex(void)
{
    TLIBA_FindFirstWildcardMatchIndex();
}
