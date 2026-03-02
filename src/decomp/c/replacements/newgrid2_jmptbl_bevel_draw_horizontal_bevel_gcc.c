#include "esq_types.h"

void BEVEL_DrawHorizontalBevel(void) __attribute__((noinline));

void NEWGRID2_JMPTBL_BEVEL_DrawHorizontalBevel(void) __attribute__((noinline, used));

void NEWGRID2_JMPTBL_BEVEL_DrawHorizontalBevel(void)
{
    BEVEL_DrawHorizontalBevel();
}
