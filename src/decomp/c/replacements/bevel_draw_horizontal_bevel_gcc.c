#include "esq_types.h"

extern void *Global_REF_GRAPHICS_LIBRARY;

void _LVOSetDrMd(void *rastport, s32 mode) __attribute__((noinline));
void _LVOSetAPen(void *rastport, s32 pen) __attribute__((noinline));
void _LVOMove(void *rastport, s32 x, s32 y) __attribute__((noinline));
void _LVODraw(void *rastport, s32 x, s32 y) __attribute__((noinline));

void BEVEL_DrawHorizontalBevel(void *rastport, s32 left_x, s32 unused_top, s32 right_x, s32 y) __attribute__((noinline, used));

void BEVEL_DrawHorizontalBevel(void *rastport, s32 left_x, s32 unused_top, s32 right_x, s32 y)
{
    u8 *rp;

    (void)Global_REF_GRAPHICS_LIBRARY;
    (void)unused_top;
    rp = (u8 *)rastport;

    _LVOSetDrMd(rastport, 0);
    _LVOSetAPen(rastport, 2);

    *(u16 *)(rp + 34) = 0xFFFF;
    rp[33] |= 1;
    rp[30] = 15;
    _LVOMove(rastport, right_x, y);
    _LVODraw(rastport, left_x, y);

    _LVOMove(rastport, right_x, y - 1);
    _LVODraw(rastport, left_x + 1, y - 1);

    _LVOMove(rastport, right_x, y - 2);
    _LVODraw(rastport, left_x + 2, y - 2);

    _LVOMove(rastport, right_x, y - 3);
    _LVODraw(rastport, left_x + 3, y - 3);

    _LVOSetAPen(rastport, 6);
    _LVOMove(rastport, right_x, y);
    _LVODraw(rastport, right_x - 3, y - 3);
}
