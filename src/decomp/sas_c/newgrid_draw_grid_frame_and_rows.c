typedef signed long LONG;
typedef signed short WORD;
typedef unsigned char UBYTE;

typedef struct NEWGRID_Font {
    UBYTE pad0[26];
    WORD ySize;
} NEWGRID_Font;

typedef struct NEWGRID_RastPort {
    UBYTE pad0[52];
    NEWGRID_Font *font;
} NEWGRID_RastPort;

typedef struct NEWGRID_Context {
    UBYTE pad0[52];
    WORD selectionCode;
    UBYTE pad1[6];
    NEWGRID_RastPort rastPort;
} NEWGRID_Context;

extern void *Global_REF_GRAPHICS_LIBRARY;
extern WORD NEWGRID_RowHeightPx;
extern LONG DISPTEXT_ControlMarkerXOffsetPx;

extern LONG NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast(void);
extern LONG NEWGRID_SetRowColor(char *gridCtx, WORD selector, LONG colorIndex);
extern LONG _LVOSetAPen(void *gfxBase, void *rp, LONG pen);
extern LONG _LVORectFill(void *gfxBase, void *rp, LONG minx, LONG miny, LONG maxx, LONG maxy);
extern LONG NEWGRID2_JMPTBL_DISPTEXT_GetTotalLineCount(void);
extern LONG NEWGRID2_JMPTBL_DISPTEXT_MeasureCurrentLineLength(void *rp);
extern LONG NEWGRID2_JMPTBL_DISPTEXT_HasMultipleLines(void);
extern LONG NEWGRID2_JMPTBL_DISPTEXT_IsLastLineSelected(void);
extern void NEWGRID2_JMPTBL_DISPTEXT_RenderCurrentLine(void *rp, LONG x, LONG y);
extern void NEWGRID2_JMPTBL_BEVEL_DrawVerticalBevel(void *rp, LONG x, LONG y, LONG maxx, LONG maxy);
extern void NEWGRID2_JMPTBL_BEVEL_DrawHorizontalBevel(void *rp, LONG x, LONG y, LONG maxx, LONG maxy);

static LONG asr1_round_toward_zero(LONG v)
{
    if (v < 0) {
        v += 1;
    }
    return v >> 1;
}

LONG NEWGRID_DrawGridFrameAndRows(char *ctx, LONG rowColorIndex)
{
    NEWGRID_Context *ctxView;
    NEWGRID_RastPort *rp;
    LONG x;
    LONG yBase;
    LONG row;
    LONG yDraw;
    LONG fontHeight;
    LONG rowHeight;
    LONG isLast;
    LONG hasMultiple;

    if (NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast() != 0) {
        return 0;
    }

    ctxView = (NEWGRID_Context *)ctx;
    rp = &ctxView->rastPort;
    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, rp, NEWGRID_SetRowColor(ctx, 0, rowColorIndex));
    rowHeight = (LONG)NEWGRID_RowHeightPx;
    _LVORectFill(Global_REF_GRAPHICS_LIBRARY, rp, 0, 0, 695, rowHeight + 3);

    x = 42;
    yBase = 0;

    if (NEWGRID2_JMPTBL_DISPTEXT_GetTotalLineCount() - 1 == 0) {
        LONG textWidth;
        LONG pad;

        textWidth = NEWGRID2_JMPTBL_DISPTEXT_MeasureCurrentLineLength(rp);
        pad = 612 - textWidth;
        x += asr1_round_toward_zero(pad);
        yBase = 4;
    }

    hasMultiple = NEWGRID2_JMPTBL_DISPTEXT_HasMultipleLines();
    row = 0;
    while (row < 2) {
        if (NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast() != 0) {
            break;
        }

        fontHeight = (LONG)rp->font->ySize;
        rowHeight = (LONG)NEWGRID_RowHeightPx;

        if (row == 0 && hasMultiple != 0) {
            yDraw = asr1_round_toward_zero(asr1_round_toward_zero(rowHeight) - fontHeight - 4) + fontHeight + 3;
        } else if (NEWGRID2_JMPTBL_DISPTEXT_IsLastLineSelected() != 0) {
            yDraw = asr1_round_toward_zero(asr1_round_toward_zero(rowHeight) - fontHeight - 4) + fontHeight + yBase - 1;
        } else {
            yDraw = asr1_round_toward_zero(asr1_round_toward_zero(rowHeight) - fontHeight) + fontHeight + yBase - 1;
        }

        NEWGRID2_JMPTBL_DISPTEXT_RenderCurrentLine(rp, x, yDraw);
        row += 1;
        yBase += asr1_round_toward_zero((LONG)NEWGRID_RowHeightPx) + DISPTEXT_ControlMarkerXOffsetPx;
    }

    isLast = NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast();
    if (hasMultiple != 0) {
        NEWGRID2_JMPTBL_BEVEL_DrawVerticalBevel(rp, 0, 0, 695, (LONG)NEWGRID_RowHeightPx + 3);
    }
    if (isLast != 0) {
        NEWGRID2_JMPTBL_BEVEL_DrawHorizontalBevel(rp, 0, yBase - 1, 695, 0);
    }

    ctxView->selectionCode = (WORD)asr1_round_toward_zero(yBase);
    return isLast;
}
