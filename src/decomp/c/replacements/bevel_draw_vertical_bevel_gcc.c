#include "esq_types.h"

extern void *Global_REF_GRAPHICS_LIBRARY;

void _LVOSetDrMd(void *rastport, s32 mode) __attribute__((noinline));
void _LVOSetAPen(void *rastport, s32 pen) __attribute__((noinline));
void _LVOMove(void *rastport, s32 x, s32 y) __attribute__((noinline));
void _LVODraw(void *rastport, s32 x, s32 y) __attribute__((noinline));

void BEVEL_DrawVerticalBevel(void *rastport, s32 x0, s32 y0, s32 x1) __attribute__((noinline, used));

void BEVEL_DrawVerticalBevel(void *rastport, s32 x0, s32 y0, s32 x1)
{
    u8 *rp;

    (void)Global_REF_GRAPHICS_LIBRARY;
    rp = (u8 *)rastport;

    _LVOSetDrMd(rastport, 0);
    _LVOSetAPen(rastport, 1);

    *(u16 *)(rp + 34) = 0xFFFF;
    rp[33] |= 1;
    rp[30] = 15;
    _LVOMove(rastport, x0, y0);
    _LVODraw(rastport, x1 - 1, y0);

    *(u16 *)(rp + 34) = 0xFFFF;
    rp[33] |= 1;
    rp[30] = 15;
    _LVOMove(rastport, x0, y0 + 1);
    _LVODraw(rastport, x1 - 2, y0 + 1);

    *(u16 *)(rp + 34) = 0xFFFF;
    rp[33] |= 1;
    rp[30] = 15;
    _LVOMove(rastport, x0, y0 + 2);
    _LVODraw(rastport, x1 - 3, y0 + 2);

    *(u16 *)(rp + 34) = 0xFFFF;
    rp[33] |= 1;
    rp[30] = 15;
    _LVOMove(rastport, x0, y0 + 3);
    _LVODraw(rastport, x1 - 4, y0 + 3);
}
