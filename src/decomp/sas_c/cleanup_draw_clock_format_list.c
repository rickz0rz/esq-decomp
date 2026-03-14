#include <graphics/rastport.h>
#include <graphics/text.h>

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

void GCOMMAND_UpdateBannerBounds(LONG left, LONG top, LONG right, LONG bottom);
LONG MATH_Mulu32(LONG a, LONG b);
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
    struct RastPort *rp;
    char textBuffer[89];
    LONG row;

    rp = (struct RastPort *)NEWGRID_MainRastPortPtr;
    GCOMMAND_UpdateBannerBounds(0, 5, 6, 0);
    _LVOSetAPen();
    _LVORectFill();

    for (row = 0; row < CLOCK_FORMAT_COLUMN_COUNT; row++) {
        LONG clockIndex = cleanup_wrap_clock_idx(startIndex, row);
        LONG columnStartX = (LONG)NEWGRID_ColumnStartXPx;
        LONG columnWidth = (LONG)NEWGRID_ColumnWidthPx;
        LONG rowStartX = columnStartX + MATH_Mulu32(row, columnWidth);
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
        fontHeight = (LONG)rp->Font->tf_YSize;
        textY = (((CLOCK_FORMAT_TEXT_ROW_HEIGHT - fontHeight) + 1) >> 1) + fontHeight - 1;

        (void)textX;
        (void)textY;
        _LVOMove();
        _LVOSetAPen();
        _LVOText();
    }
}
