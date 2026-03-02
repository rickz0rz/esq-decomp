#include "esq_types.h"

void CLEANUP_DrawClockBanner(void) __attribute__((noinline));

void NEWGRID_JMPTBL_CLEANUP_DrawClockBanner(void) __attribute__((noinline, used));

void NEWGRID_JMPTBL_CLEANUP_DrawClockBanner(void)
{
    CLEANUP_DrawClockBanner();
}
