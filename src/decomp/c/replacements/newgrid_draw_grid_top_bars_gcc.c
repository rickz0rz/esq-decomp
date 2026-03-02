#include "esq_types.h"

extern void *NEWGRID_HeaderRastPortPtr;

void NEWGRID_FillGridRects(void *rast, s32 x2, s32 y2, s32 fill_mode) __attribute__((noinline));

void NEWGRID_DrawGridTopBars(void) __attribute__((noinline, used));

void NEWGRID_DrawGridTopBars(void)
{
    NEWGRID_FillGridRects(NEWGRID_HeaderRastPortPtr, 6, 6, 1);
}
