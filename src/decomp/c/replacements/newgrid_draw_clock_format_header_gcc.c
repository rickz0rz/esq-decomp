#include "esq_types.h"

extern u16 NEWGRID_ColumnStartXPx;
extern u16 NEWGRID_ColumnWidthPx;
extern void *Global_REF_GRAPHICS_LIBRARY;

s32 NEWGRID_SetRowColor(void *grid_ctx, s32 mode, s32 pen) __attribute__((noinline));
void _LVOSetDrMd(void *rastport, s32 mode) __attribute__((noinline));
void _LVOSetAPen(void *rastport, s32 pen) __attribute__((noinline));
void _LVORectFill(void *rastport, s32 x1, s32 y1, s32 x2, s32 y2) __attribute__((noinline));
void NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight(void *rastport, s32 x1, s32 y1, s32 x2, s32 y2) __attribute__((noinline));
void NEWGRID2_JMPTBL_CLEANUP_FormatClockFormatEntry(s32 slot, u8 *out_text) __attribute__((noinline));
u32 NEWGRID_JMPTBL_MATH_Mulu32(u32 a, u32 b) __attribute__((noinline));
s32 _LVOTextLength(void *rastport, const u8 *text, s32 len) __attribute__((noinline));
void _LVOMove(void *rastport, s32 x, s32 y) __attribute__((noinline));
void _LVOText(void *rastport, const u8 *text, s32 len) __attribute__((noinline));
void NEWGRID_ValidateSelectionCode(void *grid_ctx, s32 code) __attribute__((noinline));

void NEWGRID_DrawClockFormatHeader(void *grid_ctx, s32 start_slot) __attribute__((noinline, used));

void NEWGRID_DrawClockFormatHeader(void *grid_ctx, s32 start_slot)
{
    u8 label[97];
    u8 *rast = (u8 *)grid_ctx + 60;
    s32 left_x;
    s32 col;

    (void)Global_REF_GRAPHICS_LIBRARY;

    _LVOSetDrMd(rast, 0);
    _LVOSetAPen(rast, NEWGRID_SetRowColor(grid_ctx, 0, 0));
    _LVORectFill(rast, 0, 0, 695, 33);

    left_x = (s32)(u16)NEWGRID_ColumnStartXPx;
    NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight(rast, 0, 0, left_x + 35, 33);

    for (col = 0; col < 3; ++col) {
        s32 slot = start_slot + col;
        s32 col_w = (s32)(u16)NEWGRID_ColumnWidthPx;
        s32 x;
        s32 right;
        const u8 *p;
        s32 text_len;
        s32 text_w;
        s32 pad;
        s32 text_x;
        u16 font_h;
        s32 text_y;

        if (slot > 48) {
            slot -= 48;
        }

        NEWGRID2_JMPTBL_CLEANUP_FormatClockFormatEntry(slot, label);

        x = left_x + (s32)NEWGRID_JMPTBL_MATH_Mulu32((u32)col, (u32)col_w) + 36;
        if (col == 2) {
            right = 695;
        } else {
            right = x + col_w - 1;
        }

        NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight(rast, x, 0, right, 33);

        _LVOSetAPen(rast, 3);

        p = label;
        while (*p != 0) {
            ++p;
        }
        text_len = (s32)(p - label);
        text_w = _LVOTextLength(rast, label, text_len);

        pad = col_w - text_w;
        if (pad < 0) {
            pad += 1;
        }
        text_x = x + (pad >> 1) + 2;

        font_h = *(u16 *)(*(u8 **)(rast + 52) + 26);
        text_y = 34 - (s32)font_h;
        if (text_y < 0) {
            text_y += 1;
        }
        text_y = (text_y >> 1) + (s32)font_h - 1;

        _LVOMove(rast, text_x, text_y);
        _LVOText(rast, label, text_len);
    }

    *(u16 *)((u8 *)grid_ctx + 52) = 17;
    NEWGRID_ValidateSelectionCode(grid_ctx, 64);
    *(u32 *)((u8 *)grid_ctx + 32) = (u32)*(u16 *)((u8 *)grid_ctx + 52);
}
