/* RESTORES: _TLIBA3_DrawOuterFrameBorder
 * MODULE:   modules/groups/b/a/tliba3_p1.s
 * STATUS:   behavioural
 *
 * Sibling of tliba3_draw_inner_frame_border.c and, unlike that one, correctly
 * named: it traces the rectangle outline of the rastport's bitmap -- Move(0,0)
 * then Draw across the top, down the right, back along the bottom and up the
 * left to the origin. Five calls, four edges.
 *
 * Same two load-bearing source shapes as the sibling: `<< 3` rather than `* 8`,
 * and the leaf (non-volatile) library base. Same residual class, same size.
 *
 * LIBRARY BASE: esq-graphics-leaf.h, the NON-volatile base -- every call here is
 * a library call, so nothing can clobber A6 between them and the original's
 * single load is safe to reproduce. See esq-graphics-leaf.h; tools/a6_audit.py
 * enforces the precondition.
 *
 * SASC-MISMATCH: a6-callee-saved
 *   ref:     2f0b       MOVE.L A3,-(A7)     / 265f      MOVEA.L (A7)+,A3
 *   got:     48e70006   MOVEM.L A5-A6,-(A7) / 4cdf6000
 *   summary: the original allocates its register variable to A3 where 6.51 takes
 *            A5, and the original does not preserve A6 at all where SAS/C saves
 *            it whenever it uses it. Identical to the sibling; the measured
 *            breakdown is written up there.
 *   tried:   see tliba3_draw_inner_frame_border.c.
 *   scope:   whole-program; every A3-regvar restoration carries it.
 *   retest:  a compiler that reserves A5 as a frame pointer.
 */

#include "esq-graphics-leaf.h"

void TLIBA3_DrawOuterFrameBorder(struct RastPort *rp)
{
    Move(rp, 0L, 0L);
    Draw(rp, ((long)rp->BitMap->BytesPerRow << 3) - 1, 0L);
    Draw(rp, ((long)rp->BitMap->BytesPerRow << 3) - 1, (long)rp->BitMap->Rows - 1);
    Draw(rp, 0L, (long)rp->BitMap->Rows - 1);
    Draw(rp, 0L, 0L);
}
