#include "esq_types.h"

extern u16 NEWGRID_RowHeightPx;
extern u8 *Global_PTR_STR_ER007_AWAITING_LISTINGS_DATA_TRANSMISSION;
extern void *Global_REF_GRAPHICS_LIBRARY;

void NEWGRID_DrawGridFrame(void *grid_ctx, s32 mode, s32 first_pen, s32 second_pen, s32 y_max) __attribute__((noinline));
void _LVOSetAPen(void *rastport, s32 pen) __attribute__((noinline));
s32 _LVOTextLength(void *rastport, const u8 *text, s32 len) __attribute__((noinline));
void NEWGRID_DrawWrappedText(void *rastport, s32 x, s32 y, s32 width, const u8 *text, s32 centered) __attribute__((noinline));
void NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight(void *rastport, s32 x1, s32 y1, s32 x2, s32 y2) __attribute__((noinline));

s32 NEWGRID_DrawAwaitingListingsMessage(void *grid_ctx) __attribute__((noinline, used));

s32 NEWGRID_DrawAwaitingListingsMessage(void *grid_ctx)
{
    u8 *rast = (u8 *)grid_ctx + 60;
    s32 row_h = (s32)(u16)NEWGRID_RowHeightPx;
    s32 y_max = row_h - 1;
    const u8 *msg = Global_PTR_STR_ER007_AWAITING_LISTINGS_DATA_TRANSMISSION;
    const u8 *p = msg;
    s32 msg_len = 0;
    s32 text_w;
    s32 x;
    s32 y;
    u16 font_h;
    s16 mid;

    (void)Global_REF_GRAPHICS_LIBRARY;

    NEWGRID_DrawGridFrame(grid_ctx, 7, 4, 4, y_max);

    _LVOSetAPen(rast, 1);

    while (*p != 0) {
        ++p;
    }
    msg_len = (s32)(p - msg);

    text_w = _LVOTextLength(rast, msg, msg_len);
    x = 624 - text_w;
    if (x < 0) {
        x += 1;
    }
    x = (x >> 1) + 36;

    font_h = *(u16 *)(*(u8 **)((u8 *)grid_ctx + 112) + 26);
    y = row_h - (s32)font_h;
    if (y < 0) {
        y += 1;
    }
    y = (y >> 1) + (s32)font_h - 1;

    NEWGRID_DrawWrappedText(rast, x, y, 612, msg, 1);
    NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight(rast, 0, 0, 695, y_max);

    mid = (s16)((u16)NEWGRID_RowHeightPx >> 1);
    *(u16 *)((u8 *)grid_ctx + 52) = (u16)mid;
    *(u32 *)((u8 *)grid_ctx + 32) = (u32)(u16)mid;

    return 0;
}
