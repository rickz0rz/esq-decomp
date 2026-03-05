typedef unsigned char UBYTE;
typedef unsigned short UWORD;
typedef long LONG;

extern UWORD NEWGRID_ColumnStartXPx;
extern UWORD NEWGRID_ColumnWidthPx;
extern LONG NEWGRID_MainRastPortPtr;
extern LONG Global_REF_GRAPHICS_LIBRARY;

void GROUP_AC_JMPTBL_GCOMMAND_UpdateBannerBounds(LONG a, LONG b, LONG c, LONG d);
LONG GROUP_AG_JMPTBL_MATH_Mulu32(LONG a, LONG b);
void BEVEL_DrawBevelFrameWithTopRight(void *rp, LONG x, LONG y, LONG w, LONG h);
void CLEANUP_FormatClockFormatEntry(LONG idx, char *dst);
void _LVOSetAPen(void);
void _LVORectFill(void);
void _LVOTextLength(void);
void _LVOMove(void);
void _LVOText(void);

static LONG cleanup_wrap_clock_idx(LONG base, LONG add)
{
    LONG v = base + add;
    if (v > 48) {
        v -= 48;
    }
    return v;
}

void CLEANUP_DrawClockFormatList(LONG start_idx)
{
    char text_buf[89];
    LONG row;

    GROUP_AC_JMPTBL_GCOMMAND_UpdateBannerBounds(0, 5, 6, 0);
    _LVOSetAPen();
    _LVORectFill();

    for (row = 0; row < 3; row++) {
        LONG idx = cleanup_wrap_clock_idx(start_idx, row);
        LONG col_start = (LONG)NEWGRID_ColumnStartXPx;
        LONG col_w = (LONG)NEWGRID_ColumnWidthPx;
        LONG row_x = col_start + GROUP_AG_JMPTBL_MATH_Mulu32(row, col_w);
        LONG right_x;
        LONG text_x;
        LONG text_y;
        LONG font_h;
        UBYTE *p;

        if (row < 2) {
            right_x = row_x + col_w + 35;
        } else {
            right_x = 695;
        }

        BEVEL_DrawBevelFrameWithTopRight((void *)NEWGRID_MainRastPortPtr, row_x + 36, 0, right_x, 33);
        CLEANUP_FormatClockFormatEntry(idx, text_buf);

        p = (UBYTE *)text_buf;
        while (*p != 0) {
            p++;
        }

        _LVOTextLength();

        text_x = row_x + (((col_w - (LONG)(p - (UBYTE *)text_buf) - 8) + 1) >> 1) + 42;
        font_h = (LONG)(*(UWORD *)(*(LONG *)(NEWGRID_MainRastPortPtr + 52) + 26));
        text_y = (((34 - font_h) + 1) >> 1) + font_h - 1;

        (void)text_x;
        (void)text_y;
        _LVOMove();
        _LVOSetAPen();
        _LVOText();
    }
}
