typedef signed long LONG;
typedef signed short WORD;
typedef unsigned char UBYTE;

extern WORD NEWGRID_RowHeightPx;
extern WORD NEWGRID_ColumnStartXPx;
extern LONG DISPTEXT_ControlMarkerXOffsetPx;

extern void NEWGRID_DrawGridFrame(UBYTE *ctx, LONG mode, LONG penA, LONG penB, LONG height);
extern LONG NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast(void);
extern LONG NEWGRID2_JMPTBL_DISPTEXT_IsLastLineSelected(void);
extern void NEWGRID2_JMPTBL_DISPTEXT_RenderCurrentLine(void *rp, LONG x, LONG y);
extern void NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTop(void *rp, LONG x, LONG y, LONG maxx, LONG maxy);
extern void NEWGRID2_JMPTBL_BEVEL_DrawVerticalBevelPair(void *rp, LONG x, LONG y, LONG maxx, LONG maxy);

static LONG asr1_round_toward_zero(LONG v)
{
    if (v < 0) {
        v += 1;
    }
    return v >> 1;
}

LONG NEWGRID_DrawGridHeaderRows(UBYTE *ctx, LONG penA, LONG penB)
{
    LONG rowHeight;
    LONG x;
    LONG row;
    LONG yBase;
    LONG yDraw;
    LONG fontHeight;
    LONG isLast;
    UBYTE *font;
    UBYTE *rp;

    rowHeight = (LONG)NEWGRID_RowHeightPx;
    NEWGRID_DrawGridFrame(ctx, 7, penA, penB, rowHeight + 3);

    x = (LONG)NEWGRID_ColumnStartXPx + 42;
    row = 0;
    yBase = 0;

    while (row < 2) {
        if (NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast() != 0) {
            break;
        }

        yDraw = yBase;
        font = *(UBYTE **)(ctx + 112);
        fontHeight = (LONG)*(WORD *)(font + 26);

        if (NEWGRID2_JMPTBL_DISPTEXT_IsLastLineSelected() != 0) {
            yDraw += asr1_round_toward_zero(asr1_round_toward_zero(rowHeight) - fontHeight - 4) + fontHeight - 1;
        } else {
            yDraw += asr1_round_toward_zero(asr1_round_toward_zero(rowHeight) - fontHeight) + fontHeight - 1;
        }

        rp = ctx + 60;
        NEWGRID2_JMPTBL_DISPTEXT_RenderCurrentLine(rp, x, yDraw);
        row += 1;
        yBase += asr1_round_toward_zero(rowHeight);
    }

    isLast = NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast();
    if (isLast != 0) {
        yBase += DISPTEXT_ControlMarkerXOffsetPx;
        NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTop(ctx + 60, (LONG)NEWGRID_ColumnStartXPx + 35, 0, (LONG)yBase - 1, 0);
        NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTop(ctx + 60, (LONG)NEWGRID_ColumnStartXPx + 36, 0, 695, (LONG)yBase - 1);
    } else {
        NEWGRID2_JMPTBL_BEVEL_DrawVerticalBevelPair(ctx + 60, (LONG)NEWGRID_ColumnStartXPx + 35, 0, (LONG)yBase - 1, 0);
        NEWGRID2_JMPTBL_BEVEL_DrawVerticalBevelPair(ctx + 60, (LONG)NEWGRID_ColumnStartXPx + 36, 0, 695, (LONG)yBase - 1);
    }

    *(WORD *)(ctx + 52) = (WORD)asr1_round_toward_zero(yBase);
    return isLast;
}
