/* RESTORES: _BEVEL_DrawVerticalBevelPair
 * MODULE:   modules/groups/a/a/bevel.s
 * STATUS:   behavioural
 *
 * Two four-pixel-wide vertical bevels: the left edge in pen 1 drawn downward at
 * xLeft..xLeft+3, the right edge in pen 2 drawn upward at xRight..xRight-3. The
 * stroke direction really does reverse between the two groups -- left goes
 * top-to-bottom, right goes bottom-to-top -- and that is visible in the operand
 * order, so it is reproduced rather than normalised.
 *
 * 292 BYTES AGAINST 292, IN FOUR REGIONS, AND ALL FOUR ARE THE SAME REGISTER
 * CHOICE. casm.py aligns the streams instruction-for-instruction: all sixteen
 * Move/Draw calls, both SetAPen calls, SetDrMd, both pattern-reset trios and both
 * A6 loads are byte-identical. The only disagreement is that the original holds
 * the rastport in A3 and does not preserve A6, while 6.51 holds it in A5 and
 * saves A6 -- and the wider MOVEM mask is exactly paid for by the cheaper later
 * A5 load, so the totals coincide.
 *
 * This is the strongest result in the graphics-leaf batch, and per AGENTS.md
 * rule 1 the equal size is NOT the coincidence to be suspicious of: it is backed
 * by verbatim instruction agreement across 292 bytes, not just a matching total.
 *
 * LIBRARY BASE: esq-graphics-leaf.h, the NON-volatile base -- every call is a
 * library call. WHY THIS IS THE FAITHFUL CHOICE, measured rather than assumed:
 * the original loads the base twice, once up front and once again after the
 * pattern-reset stores, and 6.51 under the leaf header does the same -- two
 * loads, same positions. Both compilers treat a store through the rastport
 * pointer as possibly aliasing the base and reload it. The volatile header would
 * have added a reload at every call site instead, and that is OUR artifact, not
 * the original's behaviour. tools/a6_audit.py enforces the precondition.
 *
 * SASC-MISMATCH: a3-vs-a5-regvar
 *   ref:     48e70f10 MOVEM.L D4-D7/A3,-(A7)   / 266f0018 MOVEA.L 24(A7),A3
 *   got:     48e70f06 MOVEM.L D4-D7/A5-A6,-(A7)/ 2a6f001c MOVEA.L 28(A7),A5
 *   summary: net zero bytes; see docs/compiler-version.md, "The A3/A5 divergence
 *            has a single root cause: A5 is a reserved frame pointer".
 *   tried:   nothing source-side reaches register allocation.
 *   scope:   whole-program.
 *   retest:  a compiler that reserves A5. It takes this function to EXACT.
 */

#include "esq-graphics-leaf.h"

void BEVEL_DrawVerticalBevelPair(struct RastPort *rp, long xLeft, long yTop,
                                 long xRight, long yBottom)
{
    SetDrMd(rp, 0L);
    SetAPen(rp, 1L);

    rp->LinePtrn = 0xFFFF;
    rp->Flags |= 1;
    rp->linpatcnt = 15;

    Move(rp, xLeft, yTop);
    Draw(rp, xLeft, yBottom);
    Move(rp, xLeft + 1, yTop);
    Draw(rp, xLeft + 1, yBottom);
    Move(rp, xLeft + 2, yTop);
    Draw(rp, xLeft + 2, yBottom);
    Move(rp, xLeft + 3, yTop);
    Draw(rp, xLeft + 3, yBottom);

    SetAPen(rp, 2L);

    rp->LinePtrn = 0xFFFF;
    rp->Flags |= 1;
    rp->linpatcnt = 15;

    Move(rp, xRight, yBottom);
    Draw(rp, xRight, yTop);
    Move(rp, xRight - 1, yBottom);
    Draw(rp, xRight - 1, yTop);
    Move(rp, xRight - 2, yBottom);
    Draw(rp, xRight - 2, yTop);
    Move(rp, xRight - 3, yBottom);
    Draw(rp, xRight - 3, yTop);
}
