/* RESTORES: NEWGRID_DrawGridFrameVariant3
 * MODULE:   modules/groups/b/a/newgrid1b_p2_p1.s
 * STATUS:   behavioural
 *
 * Fills the whole row band with the PPV showtimes pen, then draws up to two
 * text rows, then closes the block with a horizontal bevel when the current
 * line is the last one.
 *
 * This is a sibling of newgrid_draw_grid_frame_alt.c and shares its row-offset
 * arithmetic, including the asymmetry recorded there: the default arm leaves
 * out the `- 4` that both other arms apply before halving. It differs in three
 * ways. It calls HasMultipleLines INSIDE the loop rather than once up front, so
 * the arm can change between the two rows. On the multiple-line arm it draws a
 * vertical bevel every iteration. And its text column is the constant 42, not
 * NEWGRID_ColumnStartXPx + 42.
 *
 * The `TST.L`/`BPL`/`ADDQ #1`/`ASR.L #1` sequence at each halving is SAS/C's
 * signed divide by two, which rounds toward zero. Writing `/ 2` reproduces it.
 * The NOTES line in the disassembly calls this "rounding before ASR to keep
 * centering stable for negative values" -- it is the C operator, not a hand
 * optimization.
 *
 * The context is a RastPort at +60, so the font at +112 is that RastPort's own
 * Font field at RastPort+52. Reaching it as ctx->rp.Font rather than by a cast
 * is what keeps the offsets checkable.
 *
 * SASC-MISMATCH: a5-frame-and-call-width
 *   ref:     4e55ffec                   LINK.W A5,#-20
 *   got:     594f                       SUBQ.W #4,A7
 *   summary: 384 bytes emitted against 420. The usual two classes for this file
 *            family -- the A5 frame, and 4EBA against 6100 for the cross-unit
 *            calls -- plus the rastport-pointer class below.
 *   scope:   program-wide.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 *
 * SASC-MISMATCH: rastport-pointer-in-register
 *   ref:     2b48ffec / 2f2dffec        MOVE.L A0,-20(A5) / MOVE.L -20(A5),-(A7)
 *   got:     2f0a                       MOVE.L A2,-(A7)
 *   summary: both compute &ctx->rp ONCE, which is the structure that matters.
 *            The original spills it to a stack local and pushes from memory;
 *            SAS/C keeps it in a register and pushes from there, 2 bytes cheaper
 *            at each of the six call sites.
 *   tried:   NOT hoisting it. That form recomputes the address per use and lands
 *            at 412 of 420 -- closer on the byte count, and further from the
 *            original, because the original computes it once. AGENTS.md rule 1:
 *            a size-exact restoration can be less faithful than a size-divergent
 *            one, so the hoisted form is kept and the 36 bytes are accepted.
 *   scope:   any function holding a rastport across several calls.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 *
 * The address-computation proxy (AGENTS.md rule 2) reads 1 for the reference
 * and 0 here: the original emits one `LEA (d16,An),Am` and SAS/C emits none.
 * An EXCESS would mean recomputing addresses the original folded away, which is
 * the failure this check is for. A shortfall is not that.
 *
 * SASC-MISMATCH: graphics-base-reload
 *   ref:     the original loads GfxBase once and issues SetAPen then RectFill
 *            on it, with no call in between.
 *   got:     esq-graphics.h declares the base volatile, so SAS/C reloads it
 *            before RectFill. Costs 6 bytes.
 *   summary: esq-graphics-leaf.h would match here, because no ESQ call sits
 *            between the two library calls. It is NOT used: AGENTS.md limits
 *            the leaf header to functions whose every call is a library call,
 *            and this one calls NEWGRID_SetRowColor and six JMPTBL routines.
 *            Six bytes is not worth weakening that rule.
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
extern long DISPTEXT_HasMultipleLines(void);
extern long NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast(void);
extern long DISPTEXT_IsLastLineSelected(void);
extern void DISPTEXT_RenderCurrentLine(struct RastPort *rp,
                                                       long x, long y);
extern void BEVEL_DrawVerticalBevel(struct RastPort *rp,
                long x0, long y0, long x1, long y1);
extern void BEVEL_DrawHorizontalBevel(struct RastPort *rp,
                long x0, long y0, long x1, long y1);

extern unsigned short NEWGRID_RowHeightPx;
extern long           DISPTEXT_ControlMarkerXOffsetPx;
extern long           GCOMMAND_PpvShowtimesRowPen;

long NEWGRID_DrawGridFrameVariant3(struct GridCtx *ctx)
{
    struct RastPort *rp = &ctx->rp;
    long row, top, y, baseline;

    SetAPen(rp,
            NEWGRID_SetRowColor(ctx, 0L, GCOMMAND_PpvShowtimesRowPen));
    RectFill(rp, 0L, 0L, 695L, (long)NEWGRID_RowHeightPx + 3);

    row = 0;
    top = 0;
    while (row < 2 && NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast() == 0) {
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

        DISPTEXT_RenderCurrentLine(rp, 42L, y);
        row++;
        top += (long)NEWGRID_RowHeightPx / 2 + DISPTEXT_ControlMarkerXOffsetPx;
    }

    if (NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast() != 0)
        BEVEL_DrawHorizontalBevel(rp, 0L, 0L, 695L,
                                                  top - 1);

    ctx->headerHalf = (short)(top / 2);
    return NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast();
}
