#include "esq_types.h"

/*
 * Target 201 GCC trial function.
 * Jump-table stub forwarding to NEWGRID_SetSelectionMarkers.
 */
void NEWGRID_SetSelectionMarkers(void) __attribute__((noinline));

void GROUP_AI_JMPTBL_NEWGRID_SetSelectionMarkers(void) __attribute__((noinline, used));

void GROUP_AI_JMPTBL_NEWGRID_SetSelectionMarkers(void)
{
    NEWGRID_SetSelectionMarkers();
}
