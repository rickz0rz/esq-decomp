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

extern WORD NEWGRID_RowHeightPx;
extern WORD NEWGRID_ColumnStartXPx;
extern LONG DISPTEXT_ControlMarkerXOffsetPx;

extern void NEWGRID_DrawGridFrame(char *ctx, LONG mode, LONG penA, LONG penB, LONG height);
extern LONG DISPTEXT_IsCurrentLineLast(void);
extern LONG DISPTEXT_IsLastLineSelected(void);
extern void DISPTEXT_RenderCurrentLine(char *rp, LONG x, LONG y);
extern void BEVEL_DrawBevelFrameWithTop(char *rp, LONG x, LONG y, LONG maxx, LONG maxy);
extern void BEVEL_DrawVerticalBevelPair(char *rp, LONG x, LONG y, LONG maxx, LONG maxy);

static LONG asr1_round_toward_zero(LONG v)
{
    if (v < 0) {
        v += 1;
    }
    return v >> 1;
}

LONG NEWGRID_DrawGridHeaderRows(char *ctx, LONG penA, LONG penB)
{
    NEWGRID_Context *ctxView;
    LONG rowHeight;
    LONG x;
    LONG row;
    LONG yBase;
    LONG yDraw;
    LONG fontHeight;
    LONG isLast;
    NEWGRID_RastPort *rp;

    ctxView = (NEWGRID_Context *)ctx;
    rowHeight = (LONG)NEWGRID_RowHeightPx;
    NEWGRID_DrawGridFrame(ctx, 7, penA, penB, rowHeight + 3);

    x = (LONG)NEWGRID_ColumnStartXPx + 42;
    row = 0;
    yBase = 0;

    while (row < 2) {
        if (DISPTEXT_IsCurrentLineLast() != 0) {
            break;
        }

        yDraw = yBase;
        fontHeight = (LONG)ctxView->rastPort.font->ySize;

        if (DISPTEXT_IsLastLineSelected() != 0) {
            yDraw += asr1_round_toward_zero(asr1_round_toward_zero(rowHeight) - fontHeight - 4) + fontHeight - 1;
        } else {
            yDraw += asr1_round_toward_zero(asr1_round_toward_zero(rowHeight) - fontHeight) + fontHeight - 1;
        }

        rp = &ctxView->rastPort;
        DISPTEXT_RenderCurrentLine((char *)rp, x, yDraw);
        row += 1;
        yBase += asr1_round_toward_zero(rowHeight);
    }

    isLast = DISPTEXT_IsCurrentLineLast();
    if (isLast != 0) {
        yBase += DISPTEXT_ControlMarkerXOffsetPx;
        BEVEL_DrawBevelFrameWithTop((char *)&ctxView->rastPort, (LONG)NEWGRID_ColumnStartXPx + 35, 0, (LONG)yBase - 1, 0);
        BEVEL_DrawBevelFrameWithTop((char *)&ctxView->rastPort, (LONG)NEWGRID_ColumnStartXPx + 36, 0, 695, (LONG)yBase - 1);
    } else {
        BEVEL_DrawVerticalBevelPair((char *)&ctxView->rastPort, (LONG)NEWGRID_ColumnStartXPx + 35, 0, (LONG)yBase - 1, 0);
        BEVEL_DrawVerticalBevelPair((char *)&ctxView->rastPort, (LONG)NEWGRID_ColumnStartXPx + 36, 0, 695, (LONG)yBase - 1);
    }

    ctxView->selectionCode = (WORD)asr1_round_toward_zero(yBase);
    return isLast;
}
