/* RESTORES: NEWGRID_DrawGridFrameVariant2
 * MODULE:   modules/groups/b/a/newgrid1b_p2_p1_2.s
 * STATUS:   behavioural
 *
 * The detail-view frame. It fills the header band with the row color, draws up
 * to two text rows, and closes the band with a horizontal bevel when the last
 * line has been reached.
 *
 * NEWGRID_SetRowColor RETURNS the pen it selected, and that return feeds SetAPen
 * directly. Reading the pen global a second time would give a different value.
 *
 * HasMultipleLines is called INSIDE the loop here, once per row, where the
 * sibling NEWGRID_DrawGridFrameAlt calls it once before the loop. The multi-line
 * arm also draws a vertical bevel every time it runs. Both differences are in
 * the original.
 *
 * As in the sibling, the default arm leaves out the `- 4` that the other two
 * arms apply before halving.
 *
 * The function ends by calling IsCurrentLineLast a THIRD time and leaving the
 * result in D0, so it returns that value even though the disassembly header
 * says it returns nothing.
 *
 * SASC-MISMATCH: a5-frame
 *   ref:     4e55ffec                   LINK.W A5,#-20
 *   got:     594f                       SUBQ.W #4,A7
 *   summary: 420 bytes in the original against 400 emitted, 20 SHORT over 16
 *            regions. The original spills the rastport pointer to the frame and
 *            reloads it at every use; 6.51 keeps it in A3. That is where the
 *            shortfall comes from. Not itemised further -- see AGENTS.md
 *            rule 3.
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
extern long DISPTEXT_IsCurrentLineLast(void);
extern long DISPTEXT_HasMultipleLines(void);
extern long DISPTEXT_IsLastLineSelected(void);
extern void DISPTEXT_RenderCurrentLine(struct RastPort *rp,
                                                       long x, long y);
extern void BEVEL_DrawVerticalBevel(struct RastPort *rp,
                            long x0, long y0, long x1, long y1);
extern void BEVEL_DrawHorizontalBevel(struct RastPort *rp,
                            long x0, long y0, long x1, long y1);

extern unsigned short NEWGRID_RowHeightPx;
extern long           DISPTEXT_ControlMarkerXOffsetPx;
extern long           GCOMMAND_MplexDetailRowPen;

long NEWGRID_DrawGridFrameVariant2(struct GridCtx *ctx)
{
    struct RastPort *rp;
    long row, top, y, x, baseline;

    rp = &ctx->rp;
    SetAPen(rp, NEWGRID_SetRowColor(ctx, 0L, GCOMMAND_MplexDetailRowPen));
    RectFill(rp, 0L, 0L, 695L, (long)NEWGRID_RowHeightPx + 3);

    x = 42;
    row = 0;
    top = 0;
    while (row < 2 && DISPTEXT_IsCurrentLineLast() == 0) {
        y = top;
        if (DISPTEXT_HasMultipleLines() != 0) {
            BEVEL_DrawVerticalBevel(rp, 0L, 0L, 695L,
                                        (long)NEWGRID_RowHeightPx - 1);
            baseline = ctx->rp.Font->tf_Baseline;
            y += ((long)NEWGRID_RowHeightPx / 2 - baseline - 4) / 2
                 + baseline + 3;
        } else if (DISPTEXT_IsLastLineSelected() != 0) {
            baseline = ctx->rp.Font->tf_Baseline;
            y += ((long)NEWGRID_RowHeightPx / 2 - baseline - 4) / 2
                 + baseline - 1;
        } else {
            baseline = ctx->rp.Font->tf_Baseline;
            y += ((long)NEWGRID_RowHeightPx / 2 - baseline) / 2
                 + baseline - 1;
        }

        DISPTEXT_RenderCurrentLine(rp, x, y);
        row++;
        top += (long)NEWGRID_RowHeightPx / 2 + DISPTEXT_ControlMarkerXOffsetPx;
    }

    if (DISPTEXT_IsCurrentLineLast() != 0)
        BEVEL_DrawHorizontalBevel(rp, 0L, 0L, 695L, top - 1);

    ctx->headerHalf = (short)(top / 2);
    return DISPTEXT_IsCurrentLineLast();
}
