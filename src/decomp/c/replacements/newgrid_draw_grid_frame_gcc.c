#include "esq_types.h"

s32 NEWGRID_SetRowColor(void *grid_ctx, s32 mode, s32 pen, void *row_state) __attribute__((noinline));
void NEWGRID_FillGridRects(void *rastport, s32 first_pen, s32 second_pen, s32 y_max) __attribute__((noinline));

void NEWGRID_DrawGridFrame(void *grid_ctx, s32 unused1, s32 first_pen, s32 second_pen, s32 y_max) __attribute__((noinline, used));

void NEWGRID_DrawGridFrame(void *grid_ctx, s32 unused1, s32 first_pen, s32 second_pen, s32 y_max)
{
    s32 fill_pen_left;
    s32 fill_pen_right;

    (void)unused1;

    fill_pen_left = NEWGRID_SetRowColor(grid_ctx, -1, first_pen, (void *)((u8 *)grid_ctx + 60));
    fill_pen_right = NEWGRID_SetRowColor(grid_ctx, 0, second_pen, (void *)(u32)fill_pen_left);
    NEWGRID_FillGridRects(grid_ctx, fill_pen_left, fill_pen_right, y_max);
}
