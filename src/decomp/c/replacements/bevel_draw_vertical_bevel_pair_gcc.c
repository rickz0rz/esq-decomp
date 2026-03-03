#include "esq_types.h"

extern void *Global_REF_GRAPHICS_LIBRARY;

void _LVOSetDrMd(void *rastport, s32 mode) __attribute__((noinline));
void _LVOSetAPen(void *rastport, s32 pen) __attribute__((noinline));
void _LVOMove(void *rastport, s32 x, s32 y) __attribute__((noinline));
void _LVODraw(void *rastport, s32 x, s32 y) __attribute__((noinline));

void BEVEL_DrawVerticalBevelPair(void *rastport, s32 left_x, s32 top_y, s32 right_x, s32 bottom_y) __attribute__((noinline, used));

void BEVEL_DrawVerticalBevelPair(void *rastport, s32 left_x, s32 top_y, s32 right_x, s32 bottom_y)
{
    u8 *rp;

    (void)Global_REF_GRAPHICS_LIBRARY;
    rp = (u8 *)rastport;

    _LVOSetDrMd(rastport, 0);
    _LVOSetAPen(rastport, 1);

    *(u16 *)(rp + 34) = 0xFFFF;
    rp[33] |= 1;
    rp[30] = 15;
    _LVOMove(rastport, left_x, top_y);
    _LVODraw(rastport, left_x, bottom_y);
    _LVOMove(rastport, left_x + 1, top_y);
    _LVODraw(rastport, left_x + 1, bottom_y);
    _LVOMove(rastport, left_x + 2, top_y);
    _LVODraw(rastport, left_x + 2, bottom_y);
    _LVOMove(rastport, left_x + 3, top_y);
    _LVODraw(rastport, left_x + 3, bottom_y);

    _LVOSetAPen(rastport, 2);
    *(u16 *)(rp + 34) = 0xFFFF;
    rp[33] |= 1;
    rp[30] = 15;
    _LVOMove(rastport, right_x, bottom_y);
    _LVODraw(rastport, right_x, top_y);
    _LVOMove(rastport, right_x - 1, bottom_y);
    _LVODraw(rastport, right_x - 1, top_y);
    _LVOMove(rastport, right_x - 2, bottom_y);
    _LVODraw(rastport, right_x - 2, top_y);
    _LVOMove(rastport, right_x - 3, bottom_y);
    _LVODraw(rastport, right_x - 3, top_y);
}
