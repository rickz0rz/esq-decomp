/* RESTORES: _BEVEL_DrawHorizontalBevel
 * MODULE:   modules/groups/a/a/bevel.s
 * STATUS:   behavioural
 *
 * Four stacked horizontal strokes in pen 2, each one row higher and one pixel
 * longer to the right, then a single pen-6 diagonal back from (x1,y) to
 * (x1-3,y-3). The rising right edge is what makes it a mitre rather than a slab.
 *
 * FIVE parameters, and the THIRD IS UNUSED -- the original reads 8/12/20/24(A5)
 * and never touches 16(A5). It has to stay in the signature or every later
 * argument lands at the wrong offset. Do not "clean it up".
 *
 * The pattern reset before the first stroke (LinePtrn = 0xFFFF, Flags |= FRST_DOT,
 * linpatcnt = 15) is graphics.library's own SetDrPt sequence written out. It
 * appears ONCE here, unlike bevel_draw_vertical_bevel.c which repeats it before
 * every stroke -- match the original's grouping, not the idiom in the abstract.
 *
 * LIBRARY BASE: esq-graphics-leaf.h, the NON-volatile base -- every call is a
 * library call. See esq-graphics-leaf.h; tools/a6_audit.py enforces it. Note the
 * leaf header reproduces the original's A6 behaviour EXACTLY here: both streams
 * load the base twice, once up front and once after the pattern-reset stores.
 * See the note in bevel_draw_vertical_bevel_pair.c on why.
 *
 * 208 bytes against 232. All 24 are the A5 frame class, itemised by casm.py:
 *   prologue/epilogue  LINK + MOVEM A3 vs MOVEM A5-A6         -6
 *   3 x spill pair     MOVE.L D0,16(A7) + MOVE.L 16(A7),D1
 *                      vs MOVE.L D0,D1                       -18
 * Every library call, both pens, all four strokes and the diagonal are identical.
 *
 * SASC-MISMATCH: a5-frame-pointer
 *   ref:     4e55fffc LINK.W A5,#-4 ... 2f400010 / 222f0010  (x3)
 *   got:     (no frame)              ... 2200                (x3)
 *   summary: the original routes each computed Y through the frame slot -4(A5);
 *            6.51 builds no frame and moves D0 to D1 directly. Same values, same
 *            order, fewer bytes.
 *   tried:   nothing source-side; see displib_display_text_at_position.c.
 *   scope:   whole-program, 364 LINK.W A5 frames against 0 A5-in-MOVEM.
 *   retest:  a compiler that reserves A5 as the frame pointer.
 */

#include "esq-graphics-leaf.h"

void BEVEL_DrawHorizontalBevel(struct RastPort *rp, long x2, long unused,
                               long x1, long y)
{
    SetDrMd(rp, 0L);
    SetAPen(rp, 2L);

    rp->LinePtrn = 0xFFFF;
    rp->Flags |= 1;
    rp->linpatcnt = 15;

    Move(rp, x1, y);
    Draw(rp, x2, y);

    Move(rp, x1, y - 1);
    Draw(rp, x2 + 1, y - 1);

    Move(rp, x1, y - 2);
    Draw(rp, x2 + 2, y - 2);

    Move(rp, x1, y - 3);
    Draw(rp, x2 + 3, y - 3);

    SetAPen(rp, 6L);
    Move(rp, x1, y);
    Draw(rp, x1 - 3, y - 3);
}
