typedef unsigned char UBYTE;
typedef unsigned short UWORD;
typedef long LONG;

typedef struct CLEANUP_Font {
    UBYTE pad0[26];
    UWORD height26;
} CLEANUP_Font;

typedef struct CLEANUP_RastPort {
    UBYTE pad0[4];
    void *bitmap4;
    UBYTE pad8[44];
    CLEANUP_Font *font52;
} CLEANUP_RastPort;

enum {
    CLOCK_FORMAT_WRAP_MAX = 48,
    CLOCK_FORMAT_COLUMN_COUNT = 3,
    CLOCK_FORMAT_FINAL_COLUMN_INDEX = 2,
    CLOCK_FORMAT_BEVEL_X_OFFSET = 36,
    CLOCK_FORMAT_BEVEL_EXTRA_WIDTH = 35,
    CLOCK_FORMAT_TEXT_PAD = 8,
    CLOCK_FORMAT_TEXT_X_OFFSET = 42,
    CLOCK_FORMAT_FONT_PTR_OFFSET = 52,
    CLOCK_FORMAT_FONT_HEIGHT_OFFSET = 26,
    CLOCK_FORMAT_TEXT_ROW_HEIGHT = 34
};

extern UWORD NEWGRID_ColumnStartXPx;
extern UWORD NEWGRID_ColumnWidthPx;
extern LONG NEWGRID_MainRastPortPtr;
extern LONG Global_REF_GRAPHICS_LIBRARY;

void GROUP_AC_JMPTBL_GCOMMAND_UpdateBannerBounds(LONG a, LONG b, LONG c, LONG d);
LONG GROUP_AG_JMPTBL_MATH_Mulu32(LONG a, LONG b);
void BEVEL_DrawBevelFrameWithTopRight(char *rp, LONG x, LONG y, LONG w, LONG h);
void CLEANUP_FormatClockFormatEntry(LONG idx, char *dst);
void _LVOSetAPen(void);
void _LVORectFill(void);
void _LVOTextLength(void);
void _LVOMove(void);
void _LVOText(void);

static LONG cleanup_wrap_clock_idx(LONG base, LONG add)
{
    LONG wrappedClockIndex = base + add;
    if (wrappedClockIndex > CLOCK_FORMAT_WRAP_MAX) {
        wrappedClockIndex -= CLOCK_FORMAT_WRAP_MAX;
    }
    return wrappedClockIndex;
}

void CLEANUP_DrawClockFormatList(LONG startIndex)
{
    CLEANUP_RastPort *rp;
    char textBuffer[89];
    LONG row;

    rp = (CLEANUP_RastPort *)NEWGRID_MainRastPortPtr;
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
        const char *textCursor;

        if (row < CLOCK_FORMAT_FINAL_COLUMN_INDEX) {
            rowRightX = rowStartX + columnWidth + CLOCK_FORMAT_BEVEL_EXTRA_WIDTH;
        } else {
            rowRightX = 695;
        }

        BEVEL_DrawBevelFrameWithTopRight(
            (char *)rp,
            rowStartX + CLOCK_FORMAT_BEVEL_X_OFFSET,
            0,
            rowRightX,
            33);
        CLEANUP_FormatClockFormatEntry(clockIndex, textBuffer);

        textCursor = textBuffer;
        while (*textCursor != 0) {
            textCursor++;
        }

        _LVOTextLength();

        textX = rowStartX +
                (((columnWidth - (LONG)(textCursor - textBuffer) - CLOCK_FORMAT_TEXT_PAD) + 1) >> 1) +
                CLOCK_FORMAT_TEXT_X_OFFSET;
        fontHeight = (LONG)rp->font52->height26;
        textY = (((CLOCK_FORMAT_TEXT_ROW_HEIGHT - fontHeight) + 1) >> 1) + fontHeight - 1;

        (void)textX;
        (void)textY;
        _LVOMove();
        _LVOSetAPen();
        _LVOText();
    }
}
