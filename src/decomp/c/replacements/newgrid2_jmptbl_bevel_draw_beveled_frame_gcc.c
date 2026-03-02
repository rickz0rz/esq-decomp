#include "esq_types.h"

void BEVEL_DrawBeveledFrame(void) __attribute__((noinline));

void NEWGRID2_JMPTBL_BEVEL_DrawBeveledFrame(void) __attribute__((noinline, used));

void NEWGRID2_JMPTBL_BEVEL_DrawBeveledFrame(void)
{
    BEVEL_DrawBeveledFrame();
}
