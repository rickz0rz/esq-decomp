#include "esq_types.h"

/*
 * Target 213 GCC trial function.
 * Jump-table stub forwarding to NEWGRID_ShutdownGridResources.
 */
void NEWGRID_ShutdownGridResources(void) __attribute__((noinline));

void GROUP_AB_JMPTBL_NEWGRID_ShutdownGridResources(void) __attribute__((noinline, used));

void GROUP_AB_JMPTBL_NEWGRID_ShutdownGridResources(void)
{
    NEWGRID_ShutdownGridResources();
}
