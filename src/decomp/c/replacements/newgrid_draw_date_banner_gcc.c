#include "esq_types.h"

extern u16 NEWGRID_ColumnStartXPx;
extern u16 NEWGRID_ColumnWidthPx;
extern void *Global_REF_GRAPHICS_LIBRARY;

void NEWGRID_JMPTBL_GENERATE_GRID_DATE_STRING(u8 *out_text) __attribute__((noinline));
void _LVOSetDrMd(void *rastport, s32 mode) __attribute__((noinline));
s32 NEWGRID_SetRowColor(void *grid_ctx, s32 mode, s32 pen) __attribute__((noinline));
void _LVOSetAPen(void *rastport, s32 pen) __attribute__((noinline));
void _LVORectFill(void *rastport, s32 x1, s32 y1, s32 x2, s32 y2) __attribute__((noinline));
void NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight(void *rastport, s32 x1, s32 y1, s32 x2, s32 y2) __attribute__((noinline));
s32 _LVOTextLength(void *rastport, const u8 *text, s32 len) __attribute__((noinline));
void _LVOMove(void *rastport, s32 x, s32 y) __attribute__((noinline));
void _LVOText(void *rastport, const u8 *text, s32 len) __attribute__((noinline));

void NEWGRID_DrawDateBanner(void *grid_ctx) __attribute__((noinline, used));

void NEWGRID_DrawDateBanner(void *grid_ctx)
{
    u8 date_text[100];
    u8 *rast = (u8 *)grid_ctx + 60;
    const u8 *p;
    s32 date_len;
    s32 x_base;
    s32 x;
    s32 y;
    u16 font_h;

    (void)Global_REF_GRAPHICS_LIBRARY;

    NEWGRID_JMPTBL_GENERATE_GRID_DATE_STRING(date_text);

    _LVOSetDrMd(rast, 0);
    _LVOSetAPen(rast, NEWGRID_SetRowColor(grid_ctx, 0, 7));

    _LVORectFill(rast, 0, 0, 695, 33);

    x_base = (s32)(u16)NEWGRID_ColumnStartXPx;
    NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight(rast, 0, 0, x_base + 35, 33);
    NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight(rast, x_base + 36, 0, 695, 33);

    _LVOSetAPen(rast, 3);

    p = date_text;
    while (*p != 0) {
        ++p;
    }
    date_len = (s32)(p - date_text);

    x = ((s32)(u16)NEWGRID_ColumnWidthPx * 3) - _LVOTextLength(rast, date_text, date_len);
    if (x < 0) {
        x += 1;
    }
    x = x_base + (x >> 1) + 36;

    font_h = *(u16 *)(*(u8 **)(rast + 52) + 26);
    y = 34 - (s32)font_h;
    if (y < 0) {
        y += 1;
    }
    y = (y >> 1) + (s32)font_h - 1;

    _LVOMove(rast, x, y);
    _LVOText(rast, date_text, date_len);

    *(u16 *)((u8 *)grid_ctx + 52) = 17;
    *(u32 *)((u8 *)grid_ctx + 32) = 17;
}
