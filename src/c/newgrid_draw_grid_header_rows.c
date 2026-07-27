/* RESTORES: NEWGRID_DrawGridHeaderRows
 * MODULE:   modules/groups/b/a/newgrid1b.s
 * STATUS:   behavioural
 *
 * 448 bytes in the original, 464 emitted, 18 differing regions.
 *
 * Reproduces: the leading DrawGridFrame with RowHeightPx+3, the two-row loop that
 * also breaks early on IsCurrentLineLast, the two near-identical vertical-centring
 * branches -- selected and unselected differ ONLY by an extra -4 before the second
 * signed halving -- the font pointer reached at ctx+112 and its tf_Baseline at
 * +26, the RenderCurrentLine call into ctx+60, the accumulated half-row advance,
 * and the four-way tail where IsCurrentLineLast picks between DrawBevelFrameWithTop
 * and DrawVerticalBevelPair for both the left and right spans.
 *
 * The return value is the second IsCurrentLineLast result, held in the frame
 * across the whole bevel tail and reloaded at the epilogue.
 *
 * SASC-MISMATCH: no-frame-for-locals
 *   ref:     4e55ffec                   LINK.W A5,#-20
 *   got:     9efc0010                   SUBA.W #16,A7
 *   summary: The A5-frame class.
 *
 * SASC-MISMATCH: external-call-width
 *   summary: 4EBA against 6100 for the nine cross-unit calls.
 */
#include <proto/graphics.h>

extern void NEWGRID_DrawGridFrame(unsigned char *ctx, long pen, long a, long b, long h);
extern long NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast(void);
extern long NEWGRID2_JMPTBL_DISPTEXT_IsLastLineSelected(void);
extern void NEWGRID2_JMPTBL_DISPTEXT_RenderCurrentLine(void *rp, long x, long y);
extern void NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTop(void *rp, long x0, long y0,
                                                        long x1, long y1);
extern void NEWGRID2_JMPTBL_BEVEL_DrawVerticalBevelPair(void *rp, long x0, long y0,
                                                        long x1, long y1);
extern short NEWGRID_RowHeightPx;
extern short NEWGRID_ColumnStartXPx;
extern long DISPTEXT_ControlMarkerXOffsetPx;

long NEWGRID_DrawGridHeaderRows(unsigned char *ctx, long a, long b)
{
    register long i;
    register long yAccum;
    long xBase;
    long rowY;
    long isLast;
    long v;
    struct TextFont *font;

    NEWGRID_DrawGridFrame(ctx, 7, a, b, NEWGRID_RowHeightPx + 3L);

    xBase = NEWGRID_ColumnStartXPx + 42L;
    yAccum = 0;
    for (i = 0; i < 2; i++) {
        if (NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast())
            break;
        rowY = yAccum;
        if (NEWGRID2_JMPTBL_DISPTEXT_IsLastLineSelected()) {
            v = NEWGRID_RowHeightPx / 2;
            font = *(struct TextFont **)(ctx + 112);
            v = (v - font->tf_Baseline - 4) / 2 + font->tf_Baseline - 1;
            rowY += v;
        } else {
            v = NEWGRID_RowHeightPx / 2;
            font = *(struct TextFont **)(ctx + 112);
            v = (v - font->tf_Baseline) / 2 + font->tf_Baseline - 1;
            rowY += v;
        }
        NEWGRID2_JMPTBL_DISPTEXT_RenderCurrentLine(ctx + 60, xBase, rowY);
        yAccum += NEWGRID_RowHeightPx / 2;
    }

    isLast = NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast();
    if (isLast) {
        yAccum += DISPTEXT_ControlMarkerXOffsetPx;
        NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTop(ctx + 60, 0, 0,
                                                    NEWGRID_ColumnStartXPx + 35L,
                                                    yAccum - 1);
        NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTop(ctx + 60,
                                                    NEWGRID_ColumnStartXPx + 36L, 0,
                                                    695L, yAccum - 1);
    } else {
        NEWGRID2_JMPTBL_BEVEL_DrawVerticalBevelPair(ctx + 60, 0, 0,
                                                    NEWGRID_ColumnStartXPx + 35L,
                                                    yAccum - 1);
        NEWGRID2_JMPTBL_BEVEL_DrawVerticalBevelPair(ctx + 60,
                                                    NEWGRID_ColumnStartXPx + 36L, 0,
                                                    695L, yAccum - 1);
    }

    *(short *)(ctx + 52) = (short)(yAccum / 2);
    return isLast;
}
