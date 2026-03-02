#include "esq_types.h"

extern void *NEWGRID_HeaderRastPortPtr;
extern void *Global_REF_GRAPHICS_LIBRARY;

void _LVOSetAPen(void *rastport, s32 pen) __attribute__((noinline));
void _LVORectFill(void *rastport, s32 x_min, s32 y_min, s32 x_max, s32 y_max) __attribute__((noinline));

void NEWGRID_DrawTopBorderLine(void) __attribute__((noinline, used));

void NEWGRID_DrawTopBorderLine(void)
{
    (void)Global_REF_GRAPHICS_LIBRARY;
    _LVOSetAPen(NEWGRID_HeaderRastPortPtr, 7);
    _LVORectFill(NEWGRID_HeaderRastPortPtr, 0, 0, 695, 1);
}
