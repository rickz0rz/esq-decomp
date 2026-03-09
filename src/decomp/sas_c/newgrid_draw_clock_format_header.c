typedef signed long LONG;
typedef unsigned long ULONG;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

typedef struct NEWGRID_Font {
    UBYTE pad0[26];
    UWORD ySize;
} NEWGRID_Font;

typedef struct NEWGRID_RastPort {
    UBYTE pad0[52];
    NEWGRID_Font *font;
} NEWGRID_RastPort;

typedef struct NEWGRID_Context {
    UBYTE pad0[32];
    ULONG selectedState;
    UBYTE pad1[18];
    UWORD selectionCode;
    UBYTE pad2[6];
    NEWGRID_RastPort rastPort;
} NEWGRID_Context;

extern UWORD NEWGRID_ColumnStartXPx;
extern UWORD NEWGRID_ColumnWidthPx;
extern void *Global_REF_GRAPHICS_LIBRARY;

extern LONG NEWGRID_SetRowColor(void *grid_ctx, LONG mode, LONG pen);
extern void _LVOSetDrMd(void *rastport, LONG mode);
extern void _LVOSetAPen(void *rastport, LONG pen);
extern void _LVORectFill(void *rastport, LONG x1, LONG y1, LONG x2, LONG y2);
extern void NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight(void *rastport, LONG x1, LONG y1, LONG x2, LONG y2);
extern void NEWGRID2_JMPTBL_CLEANUP_FormatClockFormatEntry(LONG slot, UBYTE *out_text);
extern ULONG NEWGRID_JMPTBL_MATH_Mulu32(ULONG a, ULONG b);
extern LONG _LVOTextLength(void *rastport, UBYTE *text, LONG len);
extern void _LVOMove(void *rastport, LONG x, LONG y);
extern void _LVOText(void *rastport, UBYTE *text, LONG len);
extern void NEWGRID_ValidateSelectionCode(void *grid_ctx, LONG code);

void NEWGRID_DrawClockFormatHeader(void *grid_ctx, LONG start_slot)
{
    UBYTE label[97];
    NEWGRID_Context *ctx;
    NEWGRID_RastPort *rast;
    LONG left_x;
    LONG col;

    ctx = (NEWGRID_Context *)grid_ctx;
    rast = &ctx->rastPort;

    _LVOSetDrMd(rast, 0);
    _LVOSetAPen(rast, NEWGRID_SetRowColor(grid_ctx, 0, 0));
    _LVORectFill(rast, 0, 0, 695, 33);

    left_x = (LONG)(UWORD)NEWGRID_ColumnStartXPx;
    NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight(rast, 0, 0, left_x + 35, 33);

    for (col = 0; col < 3; ++col) {
        LONG slot;
        LONG col_w;
        LONG x;
        LONG right;
        UBYTE *p;
        LONG text_len;
        LONG text_w;
        LONG pad;
        LONG text_x;
        UWORD font_h;
        LONG text_y;

        slot = start_slot + col;
        if (slot > 48) {
            slot -= 48;
        }

        NEWGRID2_JMPTBL_CLEANUP_FormatClockFormatEntry(slot, label);

        col_w = (LONG)(UWORD)NEWGRID_ColumnWidthPx;
        x = left_x + (LONG)NEWGRID_JMPTBL_MATH_Mulu32((ULONG)col, (ULONG)col_w) + 36;
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
        text_len = (LONG)(p - label);
        text_w = _LVOTextLength(rast, label, text_len);

        pad = col_w - text_w;
        if (pad < 0) {
            pad += 1;
        }
        text_x = x + (pad >> 1) + 2;

        font_h = rast->font->ySize;
        text_y = 34 - (LONG)font_h;
        if (text_y < 0) {
            text_y += 1;
        }
        text_y = (text_y >> 1) + (LONG)font_h - 1;

        _LVOMove(rast, text_x, text_y);
        _LVOText(rast, label, text_len);
    }

    ctx->selectionCode = 17;
    NEWGRID_ValidateSelectionCode(grid_ctx, 64);
    ctx->selectedState = (ULONG)ctx->selectionCode;
}
