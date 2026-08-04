/* RESTORES: CLEANUP_DrawClockFormatList
 * MODULE:   modules/groups/a/c/cleanup2_p1_2_cleanup_drawclockformatlist.s
 * STATUS:   behavioural
 *
 * Draws three bevelled cells across the top of the grid, each holding one
 * centred clock-format label. 716 bytes.
 *
 * THE THIRD CELL IS A COPY OF THE LOOP BODY, NOT A THIRD ITERATION. The original
 * runs the loop for i = 0 and 1, then falls into a duplicate of the whole body with
 * i fixed at 2 and one difference: the bevel's right edge is the literal 695 rather
 * than the computed column edge, so the last cell always runs to the screen edge.
 * The duplication is kept here because folding it into a three-pass loop would need
 * a conditional on the right edge that the original does not have, and would emit
 * one body where it emits two.
 *
 * THE SLOT INDEX WRAPS AT 48, not modulo 48: `if (start + i > 48) start + i - 48`.
 * So an input of exactly 48 does not wrap and 49 becomes 1. Transcribed as the
 * comparison rather than as `%`, which would differ at the boundary.
 *
 * The vertical position comes from the font's own baseline --
 * `rp->Font->tf_Baseline`, offset 26 in TextFont -- centred in the 34-pixel cell
 * and then biased by the baseline again. Naming the field is what keeps the 26 out
 * of the source.
 *
 * Both the measure and the draw call strlen on the same buffer, twice, because the
 * original scans it twice. Hoisting the length would be shorter and would not match.
 *
 * MEASURED: 784 emitted against 716 in the original, +68 over 27 regions.
 *
 * SASC-MISMATCH: register-argument-multiply
 *   ref:     4eba....              JSR MATH_Mulu32 with operands in D0/D1
 *   got:     the multiply inline
 *   summary: five index multiplies, all `column * width`. Not a C calling
 *            convention.
 *   scope:   program-wide wherever MATH_Mulu32 appears.
 *   retest:  a compiler whose multiply helper IS this routine.
 *
 * SASC-MISMATCH: cross-unit-call
 *   ref:     4eba....              JSR (d16,PC)
 *   got:     61000000              BSR.W
 *   summary: same size, different opcode; costs nothing.
 *   scope:   the whole cross-unit bucket.
 *   retest:  a compiler that picks the encoding per callee.
 *
 * SASC-MISMATCH: a5-frame
 *   ref:     4e55ff9c ... 4e5d     LINK.W A5,#-100 / UNLK A5
 *   got:     A7-relative locals
 *   scope:   program-wide; docs/compiler-version.md.
 *   retest:  a compiler that reserves A5.
 *
 * SASC-MISMATCH: unattributed-body-delta
 *   summary: NOT itemised. Recorded as a known-unknown per AGENTS.md rule 3.
 *   retest:  itemise again on a compiler that reserves A5.
 */
#include <exec/types.h>
#include <graphics/gfx.h>
#include <graphics/rastport.h>
#include <graphics/text.h>
#include <graphics/gfxbase.h>
#include <string.h>

#include "esq-graphics.h"

extern struct RastPort *NEWGRID_MainRastPortPtr;
extern short NEWGRID_ColumnStartXPx;
extern short NEWGRID_ColumnWidthPx;

extern void GCOMMAND_UpdateBannerBounds(long a, long b, long c,
                                                        long d);
extern void BEVEL_DrawBevelFrameWithTopRight(struct RastPort *rp, long x1,
                                             long y1, long x2, long y2);
extern void CLEANUP_FormatClockFormatEntry(long slot, char *out);

void CLEANUP_DrawClockFormatList(long startIndex)
{
    char  text[88];
    long  i;
    long  slot;
    long  base;
    long  left;
    long  right;
    long  x;
    long  y;
    long  baseline;

    GCOMMAND_UpdateBannerBounds(0L, 5L, 6L, 0L);

    SetAPen(NEWGRID_MainRastPortPtr, 7L);
    RectFill(NEWGRID_MainRastPortPtr, (long)NEWGRID_ColumnStartXPx + 36, 0L,
             695L, 33L);

    for (i = 0; i < 2; i++) {
        if (startIndex + i > 48)
            slot = startIndex + i - 48;
        else
            slot = startIndex + i;

        left = (long)NEWGRID_ColumnStartXPx + i * (long)NEWGRID_ColumnWidthPx +
               36;
        right = (long)NEWGRID_ColumnStartXPx + i * (long)NEWGRID_ColumnWidthPx +
                (long)NEWGRID_ColumnWidthPx + 35;
        BEVEL_DrawBevelFrameWithTopRight(NEWGRID_MainRastPortPtr, left, 0L,
                                        right, 33L);

        CLEANUP_FormatClockFormatEntry(slot, text);

        base = (long)NEWGRID_ColumnStartXPx + i * (long)NEWGRID_ColumnWidthPx;
        x = base + (((long)NEWGRID_ColumnWidthPx -
                     TextLength(NEWGRID_MainRastPortPtr, text, strlen(text)) -
                     8) / 2) + 42;

        baseline = NEWGRID_MainRastPortPtr->Font->tf_Baseline;
        y = ((34 - baseline) / 2) + baseline - 1;

        Move(NEWGRID_MainRastPortPtr, x, y);
        SetAPen(NEWGRID_MainRastPortPtr, 3L);
        Text(NEWGRID_MainRastPortPtr, text, strlen(text));
    }

    /* The third cell: same body, but the right edge is the screen edge. */
    i = 2;
    if (startIndex + i > 48)
        slot = startIndex + i - 48;
    else
        slot = startIndex + i;

    left = (long)NEWGRID_ColumnStartXPx + i * (long)NEWGRID_ColumnWidthPx + 36;
    BEVEL_DrawBevelFrameWithTopRight(NEWGRID_MainRastPortPtr, left, 0L, 695L,
                                    33L);

    CLEANUP_FormatClockFormatEntry(slot, text);

    base = (long)NEWGRID_ColumnStartXPx + i * (long)NEWGRID_ColumnWidthPx;
    x = base + (((long)NEWGRID_ColumnWidthPx -
                 TextLength(NEWGRID_MainRastPortPtr, text, strlen(text)) - 8) /
                2) + 42;

    baseline = NEWGRID_MainRastPortPtr->Font->tf_Baseline;
    y = ((34 - baseline) / 2) + baseline - 1;

    Move(NEWGRID_MainRastPortPtr, x, y);
    SetAPen(NEWGRID_MainRastPortPtr, 3L);
    Text(NEWGRID_MainRastPortPtr, text, strlen(text));
}
