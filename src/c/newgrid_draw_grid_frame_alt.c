/* RESTORES: NEWGRID_DrawGridFrameAlt
 * MODULE:   modules/groups/b/a/newgrid1b_p2_p1_2.s
 * STATUS:   behavioural
 *
 * Draws the alternate grid frame: up to two text rows, then a left and a right
 * bevel run whose STYLE is picked by two flags. HasMultipleLines chooses
 * between two pairs of bevel routines, and IsCurrentLineLast chooses within the
 * pair. Four combinations, four different bevel calls, same five arguments each
 * time.
 *
 * The two arms do not agree on the frame height. With multiple lines the height
 * is NEWGRID_RowHeightPx. Without, it is the row accumulator the draw loop left
 * behind -- the original simply does not reload the register on that path. The
 * value also becomes the stored header half-height, so the difference is
 * visible in the context, not only in the bevels.
 *
 * The row offset differs by arm in one place only: the default arm leaves out
 * the `- 4` that both other arms apply before halving. That is not a typo in
 * this file, it is what the original computes.
 *
 * The context is a RastPort at +60, so the font at +112 is that RastPort's own
 * Font field at RastPort+52. Reaching it as ctx->rp.Font rather than by a cast
 * is what keeps the offsets checkable.
 *
 * SASC-MISMATCH: a5-frame-and-call-width
 *   ref:     4e55ffe8                   LINK.W A5,#-24
 *   got:     9efc0010                   SUBA.W #16,A7
 *   summary: 682 bytes emitted against 682 in the original, over 38 regions.
 *            Equal size is NOT evidence of fidelity -- see AGENTS.md rule 1 --
 *            and the regions are the usual two classes: the A5 frame, and 4EBA
 *            against 6100 for the cross-unit calls.
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

extern void NEWGRID_DrawGridFrame(struct GridCtx *ctx, long a, long b, long c,
                                  long d);
extern long NEWGRID2_JMPTBL_DISPTEXT_HasMultipleLines(void);
extern long NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast(void);
extern long NEWGRID2_JMPTBL_DISPTEXT_IsLastLineSelected(void);
extern void NEWGRID2_JMPTBL_DISPTEXT_RenderCurrentLine(struct RastPort *rp,
                                                       long x, long y);
extern void NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight(
                struct RastPort *rp, long x0, long y0, long x1, long y1);
extern void NEWGRID2_JMPTBL_BEVEL_DrawBeveledFrame(
                struct RastPort *rp, long x0, long y0, long x1, long y1);
extern void NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTop(
                struct RastPort *rp, long x0, long y0, long x1, long y1);
extern void NEWGRID2_JMPTBL_BEVEL_DrawVerticalBevelPair(
                struct RastPort *rp, long x0, long y0, long x1, long y1);

extern unsigned short NEWGRID_RowHeightPx;
extern unsigned short NEWGRID_ColumnStartXPx;
extern long           DISPTEXT_ControlMarkerXOffsetPx;

long NEWGRID_DrawGridFrameAlt(struct GridCtx *ctx)
{
    long multiLine, last, row, top, y, x, height, baseline;

    NEWGRID_DrawGridFrame(ctx, 7L, 6L, 6L, (long)NEWGRID_RowHeightPx + 3);
    x = (long)NEWGRID_ColumnStartXPx + 42;
    multiLine = NEWGRID2_JMPTBL_DISPTEXT_HasMultipleLines();

    row = 0;
    top = 0;
    while (row < 2 && NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast() == 0) {
        baseline = ctx->rp.Font->tf_Baseline;
        y = top;
        if (row == 0 && multiLine != 0)
            y += ((long)NEWGRID_RowHeightPx / 2 - baseline - 4) / 2
                 + baseline + 3;
        else if (NEWGRID2_JMPTBL_DISPTEXT_IsLastLineSelected() != 0)
            y += ((long)NEWGRID_RowHeightPx / 2 - baseline - 4) / 2
                 + baseline - 1;
        else
            y += ((long)NEWGRID_RowHeightPx / 2 - baseline) / 2
                 + baseline - 1;

        NEWGRID2_JMPTBL_DISPTEXT_RenderCurrentLine(&ctx->rp, x, y);
        row++;
        top += (long)NEWGRID_RowHeightPx / 2 + DISPTEXT_ControlMarkerXOffsetPx;
    }

    last = NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast();
    if (multiLine != 0) {
        height = NEWGRID_RowHeightPx;
        if (last != 0) {
            NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight(&ctx->rp, 0L, 0L,
                (long)NEWGRID_ColumnStartXPx + 35, height - 1);
            NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight(&ctx->rp,
                (long)NEWGRID_ColumnStartXPx + 36, 0L, 695L, height - 1);
        } else {
            NEWGRID2_JMPTBL_BEVEL_DrawBeveledFrame(&ctx->rp, 0L, 0L,
                (long)NEWGRID_ColumnStartXPx + 35, height - 1);
            NEWGRID2_JMPTBL_BEVEL_DrawBeveledFrame(&ctx->rp,
                (long)NEWGRID_ColumnStartXPx + 36, 0L, 695L, height - 1);
        }
    } else {
        height = top;
        if (last != 0) {
            NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTop(&ctx->rp, 0L, 0L,
                (long)NEWGRID_ColumnStartXPx + 35, height - 1);
            NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTop(&ctx->rp,
                (long)NEWGRID_ColumnStartXPx + 36, 0L, 695L, height - 1);
        } else {
            NEWGRID2_JMPTBL_BEVEL_DrawVerticalBevelPair(&ctx->rp, 0L, 0L,
                (long)NEWGRID_ColumnStartXPx + 35, height - 1);
            NEWGRID2_JMPTBL_BEVEL_DrawVerticalBevelPair(&ctx->rp,
                (long)NEWGRID_ColumnStartXPx + 36, 0L, 695L, height - 1);
        }
    }

    ctx->headerHalf = (short)(height / 2);
    return last;
}
