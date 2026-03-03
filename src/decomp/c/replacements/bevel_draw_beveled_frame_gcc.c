#include "esq_types.h"

extern void *Global_REF_GRAPHICS_LIBRARY;

void _LVOSetAPen(void *rastport, s32 pen) __attribute__((noinline));
void _LVOMove(void *rastport, s32 x, s32 y) __attribute__((noinline));
void _LVODraw(void *rastport, s32 x, s32 y) __attribute__((noinline));

void BEVEL_DrawVerticalBevelPair(void *rastport, s32 left_x, s32 top_y, s32 right_x, s32 bottom_y) __attribute__((noinline));
void BEVEL_DrawVerticalBevel(void *rastport, s32 left_x, s32 top_y, s32 right_x, s32 bottom_y) __attribute__((noinline));

void BEVEL_DrawBeveledFrame(void *rastport, s32 left_x, s32 top_y, s32 right_x, s32 bottom_y) __attribute__((noinline, used));

void BEVEL_DrawBeveledFrame(void *rastport, s32 left_x, s32 top_y, s32 right_x, s32 bottom_y)
{
    BEVEL_DrawVerticalBevelPair(rastport, left_x, top_y, right_x, bottom_y);
    BEVEL_DrawVerticalBevel(rastport, left_x, top_y, right_x, bottom_y);

    (void)Global_REF_GRAPHICS_LIBRARY;
    _LVOSetAPen(rastport, 2);
    _LVOMove(rastport, left_x, top_y);
    _LVODraw(rastport, left_x + 3, top_y + 3);
}
