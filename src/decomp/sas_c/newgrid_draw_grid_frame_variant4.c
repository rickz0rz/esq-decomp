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

extern LONG NEWGRID_SetRowColor(char *gridCtx, WORD selector, LONG colorIndex);
extern LONG _LVOSetAPen(void *gfxBase, void *rp, LONG pen);
extern LONG _LVORectFill(void *gfxBase, void *rp, LONG minx, LONG miny, LONG maxx, LONG maxy);
extern LONG NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast(void);
extern LONG NEWGRID2_JMPTBL_DISPTEXT_HasMultipleLines(void);
extern void NEWGRID2_JMPTBL_BEVEL_DrawVerticalBevel(void *rp, LONG x, LONG y, LONG maxx, LONG maxy);
extern LONG NEWGRID2_JMPTBL_DISPTEXT_IsLastLineSelected(void);
extern void NEWGRID2_JMPTBL_DISPTEXT_RenderCurrentLine(void *rp, LONG x, LONG y);
extern void NEWGRID2_JMPTBL_BEVEL_DrawHorizontalBevel(void *rp, LONG x, LONG y, LONG maxx, LONG maxy);

static LONG asr1_round_toward_zero(LONG v)
{
    if (v < 0) {
        v += 1;
    }
    return v >> 1;
}

LONG NEWGRID_DrawGridFrameVariant4(char *ctx)
{
    NEWGRID_Context *ctxView;
    NEWGRID_RastPort *rp;
    LONG row;
    LONG yBase;
    LONG yDraw;
    LONG x;
    LONG rowHeight;
    LONG fontHeight;

    ctxView = (NEWGRID_Context *)ctx;
    rp = &ctxView->rastPort;
    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, rp, NEWGRID_SetRowColor(ctx, 0, 6));
    _LVORectFill(Global_REF_GRAPHICS_LIBRARY, rp, 0, 0, 695, (LONG)NEWGRID_RowHeightPx + 3);

    x = 42;
    row = 0;
    yBase = 0;

    while (row < 2) {
        if (NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast() != 0) {
            break;
        }

        yDraw = yBase;
        fontHeight = (LONG)rp->font->ySize;
        rowHeight = (LONG)NEWGRID_RowHeightPx;

        if (NEWGRID2_JMPTBL_DISPTEXT_HasMultipleLines() != 0) {
            NEWGRID2_JMPTBL_BEVEL_DrawVerticalBevel(rp, 0, 0, 695, rowHeight - 1);
            yDraw += asr1_round_toward_zero(asr1_round_toward_zero(rowHeight) - fontHeight - 4) + fontHeight + 3;
        } else if (NEWGRID2_JMPTBL_DISPTEXT_IsLastLineSelected() != 0) {
            yDraw += asr1_round_toward_zero(asr1_round_toward_zero(rowHeight) - fontHeight - 4) + fontHeight - 1;
        } else {
            yDraw += asr1_round_toward_zero(asr1_round_toward_zero(rowHeight) - fontHeight) + fontHeight - 1;
        }

        NEWGRID2_JMPTBL_DISPTEXT_RenderCurrentLine(rp, x, yDraw);
        row += 1;
        yBase += asr1_round_toward_zero((LONG)NEWGRID_RowHeightPx) + DISPTEXT_ControlMarkerXOffsetPx;
    }

    if (NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast() != 0) {
        NEWGRID2_JMPTBL_BEVEL_DrawHorizontalBevel(rp, 0, yBase - 1, 695, 0);
    }

    ctxView->selectionCode = (WORD)asr1_round_toward_zero(yBase);
    return NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast();
}
