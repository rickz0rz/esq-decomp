typedef unsigned char UBYTE;
typedef unsigned short UWORD;
typedef long LONG;

enum {
    CLOCK_FORMAT_WRAP_MAX = 48,
    CLOCK_FORMAT_COLUMN_COUNT = 3,
    CLOCK_FORMAT_FINAL_COLUMN_INDEX = 2
};

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
    if (v > CLOCK_FORMAT_WRAP_MAX) {
        v -= CLOCK_FORMAT_WRAP_MAX;
    }
    return v;
}

void CLEANUP_DrawClockFormatList(LONG startIndex)
{
    char textBuffer[89];
    LONG row;

    GROUP_AC_JMPTBL_GCOMMAND_UpdateBannerBounds(0, 5, 6, 0);
    _LVOSetAPen();
    _LVORectFill();

    for (row = 0; row < CLOCK_FORMAT_COLUMN_COUNT; row++) {
        LONG clockIndex = cleanup_wrap_clock_idx(startIndex, row);
        LONG columnStartX = (LONG)NEWGRID_ColumnStartXPx;
        LONG columnWidth = (LONG)NEWGRID_ColumnWidthPx;
        LONG rowStartX = columnStartX + GROUP_AG_JMPTBL_MATH_Mulu32(row, columnWidth);
        LONG rowRightX;
        LONG textX;
        LONG textY;
        LONG fontHeight;
        UBYTE *textCursor;

        if (row < CLOCK_FORMAT_FINAL_COLUMN_INDEX) {
            rowRightX = rowStartX + columnWidth + 35;
        } else {
            rowRightX = 695;
        }

        BEVEL_DrawBevelFrameWithTopRight((void *)NEWGRID_MainRastPortPtr, rowStartX + 36, 0, rowRightX, 33);
        CLEANUP_FormatClockFormatEntry(clockIndex, textBuffer);

        textCursor = (UBYTE *)textBuffer;
        while (*textCursor != 0) {
            textCursor++;
        }

        _LVOTextLength();

        textX = rowStartX + (((columnWidth - (LONG)(textCursor - (UBYTE *)textBuffer) - 8) + 1) >> 1) + 42;
        fontHeight = (LONG)(*(UWORD *)(*(LONG *)(NEWGRID_MainRastPortPtr + 52) + 26));
        textY = (((34 - fontHeight) + 1) >> 1) + fontHeight - 1;

        (void)textX;
        (void)textY;
        _LVOMove();
        _LVOSetAPen();
        _LVOText();
    }
}
