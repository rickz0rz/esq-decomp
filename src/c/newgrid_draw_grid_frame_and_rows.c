/* RESTORES: NEWGRID_DrawGridFrameAndRows
 * MODULE:   modules/groups/b/a/newgrid1b_p1_2.s
 * STATUS:   behavioural
 *
 * The main grid frame: fill the header band, draw up to two text rows, then
 * close the band with a vertical bevel, a horizontal bevel, or both.
 *
 * A single-line entry is centered inside 612 pixels and starts 4 pixels lower.
 * Any other line count starts at the left margin with no extra offset.
 *
 * The three row-offset arms do not agree, and the disagreement is deliberate:
 * the first row of a multi-line entry ignores the running top offset, while
 * both other arms add it. The default arm also leaves out the `- 4`.
 *
 * READ THIS BEFORE TIDYING THE EARLY RETURN. When the first IsCurrentLineLast
 * test succeeds the original jumps straight to the epilogue and returns
 * whatever is in the local at -20(A5), which nothing has written yet. This file
 * keeps that shape -- `last` is only assigned inside the body -- because the
 * value the caller sees is part of the behaviour. Initialising it here would be
 * a change, not a cleanup.
 *
 * SASC-MISMATCH: a5-frame
 *   ref:     4e55ffe4                   LINK.W A5,#-28
 *   got:     9efc0010                   SUBA.W #16,A7
 *   summary: 520 bytes in the original against 480 emitted, 40 SHORT over 22
 *            regions. The original reloads the rastport pointer with LEA 60(A3)
 *            before every use, twelve times; 6.51 computes it once. Not
 *            itemised further -- see AGENTS.md rule 3.
 *   scope:   program-wide.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
#include "esq-graphics.h"

struct GridCtx {
    char            pad0[52];
    short           headerHalf;     /* 52 */
    char            pad1[6];
    struct RastPort rp;             /* 60, so rp.Font is ctx+112 */
};

extern long NEWGRID_SetRowColor(struct GridCtx *ctx, long a, long pen);
extern long NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast(void);
extern long NEWGRID2_JMPTBL_DISPTEXT_HasMultipleLines(void);
extern long NEWGRID2_JMPTBL_DISPTEXT_IsLastLineSelected(void);
extern long NEWGRID2_JMPTBL_DISPTEXT_GetTotalLineCount(void);
extern long NEWGRID2_JMPTBL_DISPTEXT_MeasureCurrentLineLength(
                                                       struct RastPort *rp);
extern void NEWGRID2_JMPTBL_DISPTEXT_RenderCurrentLine(struct RastPort *rp,
                                                       long x, long y);
extern void NEWGRID2_JMPTBL_BEVEL_DrawVerticalBevel(struct RastPort *rp,
                            long x0, long y0, long x1, long y1);
extern void NEWGRID2_JMPTBL_BEVEL_DrawHorizontalBevel(struct RastPort *rp,
                            long x0, long y0, long x1, long y1);

extern unsigned short NEWGRID_RowHeightPx;
extern long           DISPTEXT_ControlMarkerXOffsetPx;

long NEWGRID_DrawGridFrameAndRows(struct GridCtx *ctx, long pen)
{
    struct RastPort *rp;
    long last, x, y, top, row, multiLine, baseline;

    if (NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast() == 0) {
        rp = &ctx->rp;
        SetAPen(rp, NEWGRID_SetRowColor(ctx, 0L, pen));
        RectFill(rp, 0L, 0L, 695L, (long)NEWGRID_RowHeightPx + 3);

        x = 42;
        top = 0;
        if (NEWGRID2_JMPTBL_DISPTEXT_GetTotalLineCount() == 1) {
            x += (612 - NEWGRID2_JMPTBL_DISPTEXT_MeasureCurrentLineLength(rp))
                 / 2;
            top = 4;
        }

        multiLine = NEWGRID2_JMPTBL_DISPTEXT_HasMultipleLines();
        row = 0;
        while (row < 2 && NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast() == 0) {
            baseline = ctx->rp.Font->tf_Baseline;
            if (row == 0 && multiLine != 0)
                y = ((long)NEWGRID_RowHeightPx / 2 - baseline - 4) / 2
                    + baseline + 3;
            else if (NEWGRID2_JMPTBL_DISPTEXT_IsLastLineSelected() != 0)
                y = ((long)NEWGRID_RowHeightPx / 2 - baseline - 4) / 2
                    + baseline + top - 1;
            else
                y = top + ((long)NEWGRID_RowHeightPx / 2 - baseline) / 2
                    + baseline - 1;

            NEWGRID2_JMPTBL_DISPTEXT_RenderCurrentLine(rp, x, y);
            row++;
            top += (long)NEWGRID_RowHeightPx / 2
                   + DISPTEXT_ControlMarkerXOffsetPx;
        }

        last = NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast();
        if (multiLine != 0)
            NEWGRID2_JMPTBL_BEVEL_DrawVerticalBevel(rp, 0L, 0L, 695L,
                                        (long)NEWGRID_RowHeightPx + 3);
        if (last != 0)
            NEWGRID2_JMPTBL_BEVEL_DrawHorizontalBevel(rp, 0L, 0L, 695L,
                                                      top - 1);
        ctx->headerHalf = (short)(top / 2);
    }

    return last;
}
