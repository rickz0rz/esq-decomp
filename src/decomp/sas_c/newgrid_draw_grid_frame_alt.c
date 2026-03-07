typedef signed long LONG;
typedef signed short WORD;
typedef unsigned char UBYTE;

extern WORD NEWGRID_RowHeightPx;
extern WORD NEWGRID_ColumnStartXPx;
extern LONG DISPTEXT_ControlMarkerXOffsetPx;

extern void NEWGRID_DrawGridFrame(UBYTE *rpCtx, LONG type, LONG penA, LONG penB, LONG height);
extern LONG NEWGRID2_JMPTBL_DISPTEXT_HasMultipleLines(void);
extern LONG NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast(void);
extern LONG NEWGRID2_JMPTBL_DISPTEXT_IsLastLineSelected(void);
extern void NEWGRID2_JMPTBL_DISPTEXT_RenderCurrentLine(void *rp, LONG x, LONG y);
extern void NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight(void *rp, LONG x, LONG y, LONG maxx, LONG maxy);
extern void NEWGRID2_JMPTBL_BEVEL_DrawBeveledFrame(void *rp, LONG x, LONG y, LONG maxx, LONG maxy);
extern void NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTop(void *rp, LONG x, LONG y, LONG maxx, LONG maxy);
extern void NEWGRID2_JMPTBL_BEVEL_DrawVerticalBevelPair(void *rp, LONG x, LONG y, LONG maxx, LONG maxy);

static LONG asr1_round_toward_zero(LONG v)
{
    if (v < 0) {
        v += 1;
    }
    return v >> 1;
}

LONG NEWGRID_DrawGridFrameAlt(UBYTE *ctx)
{
    LONG hasMultiple;
    LONG row;
    LONG yBase;
    LONG yDraw;
    LONG x;
    LONG rowHeight;
    LONG fontHeight;
    LONG isLast;
    UBYTE *rp;
    UBYTE *font;

    rowHeight = (LONG)NEWGRID_RowHeightPx;
    NEWGRID_DrawGridFrame(ctx, 7, 6, 6, rowHeight + 3);

    x = (LONG)NEWGRID_ColumnStartXPx + 42;
    hasMultiple = NEWGRID2_JMPTBL_DISPTEXT_HasMultipleLines();
    row = 0;
    yBase = 0;

    while (row < 2) {
        if (NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast() != 0) {
            break;
        }

        yDraw = yBase;
        font = *(UBYTE **)(ctx + 112);
        fontHeight = (LONG)*(WORD *)(font + 26);

        if (row == 0 && hasMultiple != 0) {
            yDraw += asr1_round_toward_zero(asr1_round_toward_zero(rowHeight) - fontHeight - 4) + fontHeight + 3;
        } else if (NEWGRID2_JMPTBL_DISPTEXT_IsLastLineSelected() != 0) {
            yDraw += asr1_round_toward_zero(asr1_round_toward_zero(rowHeight) - fontHeight - 4) + fontHeight - 1;
        } else {
            yDraw += asr1_round_toward_zero(asr1_round_toward_zero(rowHeight) - fontHeight) + fontHeight - 1;
        }

        rp = ctx + 60;
        NEWGRID2_JMPTBL_DISPTEXT_RenderCurrentLine(rp, x, yDraw);
        row += 1;
        yBase += asr1_round_toward_zero(rowHeight) + DISPTEXT_ControlMarkerXOffsetPx;
    }

    isLast = NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast();
    if (hasMultiple != 0) {
        yBase = rowHeight;
        if (isLast != 0) {
            NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight(ctx + 60, (LONG)NEWGRID_ColumnStartXPx + 35, 0, (LONG)yBase - 1, 0);
            NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight(ctx + 60, (LONG)NEWGRID_ColumnStartXPx + 36, 0, 695, (LONG)yBase - 1);
        } else {
            NEWGRID2_JMPTBL_BEVEL_DrawBeveledFrame(ctx + 60, (LONG)NEWGRID_ColumnStartXPx + 35, 0, (LONG)yBase - 1, 0);
            NEWGRID2_JMPTBL_BEVEL_DrawBeveledFrame(ctx + 60, (LONG)NEWGRID_ColumnStartXPx + 36, 0, 695, (LONG)yBase - 1);
        }
    } else {
        if (isLast != 0) {
            NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTop(ctx + 60, (LONG)NEWGRID_ColumnStartXPx + 35, 0, (LONG)yBase - 1, 0);
            NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTop(ctx + 60, (LONG)NEWGRID_ColumnStartXPx + 36, 0, 695, (LONG)yBase - 1);
        } else {
            NEWGRID2_JMPTBL_BEVEL_DrawVerticalBevelPair(ctx + 60, (LONG)NEWGRID_ColumnStartXPx + 35, 0, (LONG)yBase - 1, 0);
            NEWGRID2_JMPTBL_BEVEL_DrawVerticalBevelPair(ctx + 60, (LONG)NEWGRID_ColumnStartXPx + 36, 0, 695, (LONG)yBase - 1);
        }
    }

    *(WORD *)(ctx + 52) = (WORD)asr1_round_toward_zero(yBase);
    return isLast;
}
