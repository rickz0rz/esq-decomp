#include "esq_types.h"

void BEVEL_DrawBeveledFrame(void *rastport, s32 left_x, s32 top_y, s32 right_x, s32 bottom_y) __attribute__((noinline));
void BEVEL_DrawHorizontalBevel(void *rastport, s32 left_x, s32 top_y_unused, s32 right_x, s32 bottom_y) __attribute__((noinline));

void BEVEL_DrawBevelFrameWithTopRight(void *rastport, s32 left_x, s32 top_y, s32 right_x, s32 bottom_y) __attribute__((noinline, used));

void BEVEL_DrawBevelFrameWithTopRight(void *rastport, s32 left_x, s32 top_y, s32 right_x, s32 bottom_y)
{
    BEVEL_DrawBeveledFrame(rastport, left_x, top_y, right_x, bottom_y);
    BEVEL_DrawHorizontalBevel(rastport, left_x, top_y, right_x, bottom_y);
}
