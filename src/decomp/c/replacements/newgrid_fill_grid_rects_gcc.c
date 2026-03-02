#include "esq_types.h"

extern s16 NEWGRID_ColumnStartXPx;
extern void *Global_REF_GRAPHICS_LIBRARY;

void _LVOSetAPen(void *rastport, s32 pen) __attribute__((noinline));
void _LVORectFill(void *rastport, s32 x_min, s32 y_min, s32 x_max, s32 y_max) __attribute__((noinline));

void NEWGRID_FillGridRects(void *rastport, s32 first_pen, s32 second_pen, s32 y_max) __attribute__((noinline, used));

void NEWGRID_FillGridRects(void *rastport, s32 first_pen, s32 second_pen, s32 y_max)
{
    s32 x_split;

    (void)Global_REF_GRAPHICS_LIBRARY;

    _LVOSetAPen(rastport, first_pen);

    x_split = (s32)NEWGRID_ColumnStartXPx + 35;
    _LVORectFill(rastport, 0, 0, x_split, y_max);

    _LVOSetAPen(rastport, second_pen);

    x_split = (s32)NEWGRID_ColumnStartXPx + 36;
    _LVORectFill(rastport, x_split, 0, 695, y_max);
}
