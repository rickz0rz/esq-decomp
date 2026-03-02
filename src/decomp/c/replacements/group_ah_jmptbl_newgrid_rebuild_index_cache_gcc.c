#include "esq_types.h"

/*
 * Target 242 GCC trial function.
 * Jump-table stub forwarding to NEWGRID_RebuildIndexCache.
 */
void NEWGRID_RebuildIndexCache(void) __attribute__((noinline));

void GROUP_AH_JMPTBL_NEWGRID_RebuildIndexCache(void) __attribute__((noinline, used));

void GROUP_AH_JMPTBL_NEWGRID_RebuildIndexCache(void)
{
    NEWGRID_RebuildIndexCache();
}
