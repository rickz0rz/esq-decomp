#include "esq_types.h"

void NEWGRID_ResetRowTable(void) __attribute__((noinline));

void WDISP_JMPTBL_NEWGRID_ResetRowTable(void) __attribute__((noinline, used));

void WDISP_JMPTBL_NEWGRID_ResetRowTable(void)
{
    NEWGRID_ResetRowTable();
}
