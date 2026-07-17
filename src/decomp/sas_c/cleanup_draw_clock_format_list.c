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
extern void *Global_REF_GRAPHICS_LIBRARY;

void GCOMMAND_UpdateBannerBounds(LONG left, LONG top, LONG right, LONG bottom);
LONG MATH_Mulu32(LONG a, LONG b);
void BEVEL_DrawBevelFrameWithTopRight(char *rp, LONG x, LONG y, LONG w, LONG h);
void CLEANUP_FormatClockFormatEntry(LONG idx, char *dst);

/* base-first _LVO ABI (gfxBase).
   SetAPen(A1=rp, D0=pen); RectFill(A1=rp, D0=xMin, D1=yMin, D2=xMax, D3=yMax);
   TextLength(A1=rp, A0=string, D0=count)->D0 pixel width; Move(A1=rp, D0=x, D1=y);
   Text(A1=rp, A0=string, D0=count). */
void _LVOSetAPen(void *gfxBase, struct RastPort *rp, LONG pen);
void _LVORectFill(void *gfxBase, struct RastPort *rp, LONG xMin, LONG yMin, LONG xMax, LONG yMax);
LONG _LVOTextLength(void *gfxBase, struct RastPort *rp, const char *string, LONG count);
void _LVOMove(void *gfxBase, struct RastPort *rp, LONG x, LONG y);
void _LVOText(void *gfxBase, struct RastPort *rp, const char *string, LONG count);

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
    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, rp, 7);
    _LVORectFill(Global_REF_GRAPHICS_LIBRARY, rp,
                 (LONG)NEWGRID_ColumnStartXPx + CLOCK_FORMAT_BEVEL_X_OFFSET, 0, 695, 33);

    for (row = 0; row < CLOCK_FORMAT_COLUMN_COUNT; row++) {
        int _r0 = 1;
        LONG clockIndex = cleanup_wrap_clock_idx(startIndex, row);
        LONG columnStartX = (LONG)NEWGRID_ColumnStartXPx;
        LONG columnWidth = (LONG)NEWGRID_ColumnWidthPx;
        LONG rowStartX = columnStartX + MATH_Mulu32(row, columnWidth);
        LONG rowRightX;
        LONG textX;
        LONG textY;
        LONG fontHeight;
        LONG textWidthPx;
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

        /* Center on measured PIXEL width (TextLength return), round toward zero. */
        textWidthPx = _LVOTextLength(Global_REF_GRAPHICS_LIBRARY, rp,
                                     textBuffer, (LONG)(textCursor - textBuffer));

        textX = rowStartX +
                ((columnWidth - textWidthPx - CLOCK_FORMAT_TEXT_PAD) / 2) +
                CLOCK_FORMAT_TEXT_X_OFFSET;
        fontHeight = (LONG)rp->Font->tf_YSize;
        textY = ((CLOCK_FORMAT_TEXT_ROW_HEIGHT - fontHeight) / 2) + fontHeight - 1;

        _LVOMove(Global_REF_GRAPHICS_LIBRARY, rp, textX, textY);
        _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, rp, 3);
        _LVOText(Global_REF_GRAPHICS_LIBRARY, rp, textBuffer, (LONG)(textCursor - textBuffer));
    }
}
