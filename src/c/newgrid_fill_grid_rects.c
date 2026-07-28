/* RESTORES: _NEWGRID_FillGridRects
 * MODULE:   modules/groups/b/a/newgrid_p3.s
 * STATUS:   behavioural
 *
 * Two adjacent filled bands across the grid, each in its own pen: the left band
 * from x=0 to ColumnStartXPx+35, the right one from ColumnStartXPx+36 to 695,
 * both from y=0 down to the caller's y2.
 *
 * The original keeps y2 in D3 across both RectFill calls -- RectFill takes its
 * arguments in D0-D3, and D3 is the same variable both times, so the second call
 * simply does not reload it. That falls out of writing the same local twice.
 *
 * ColumnStartXPx is zero-extended (MOVEQ #0,D0 / MOVE.W global,D0) so it is an
 * `unsigned short`, and the +35/+36 are materialised into a register first
 * (MOVEQ #35,D1 / ADD.L D1,D0) rather than added as immediates -- the constant
 * rule in docs/compiler-version.md, "Constant materialisation".
 *
 * LIBRARY BASE: esq-graphics-leaf.h, the NON-volatile base -- every call is a
 * library call. See esq-graphics-leaf.h; tools/a6_audit.py enforces it.
 *
 * 100 bytes against 100, in THREE regions, and this is a case where the equal
 * size is not the coincidence AGENTS.md rule 1 warns about: casm.py aligns the
 * two streams instruction-for-instruction and the only disagreements are which
 * address register holds the rastport and where it is loaded. Every arithmetic
 * instruction, both zero-extends, both constant materialisations and all four
 * library calls are byte-identical. It is as close as this compiler can get.
 *
 * SASC-MISMATCH: a3-vs-a5-regvar
 *   ref:     48e73710  MOVEM.L D2-D3/D5-D7/A3,-(A7)   / 4cdf08ec
 *            266f001c  MOVEA.L 28(A7),A3
 *   got:     48e73706  MOVEM.L D2-D3/D5-D7/A5-A6,-(A7) / 4cdf60ec
 *            2a6f0020  MOVEA.L 32(A7),A5
 *   summary: the original puts the rastport in A3 and does not preserve A6; 6.51
 *            takes A5 and saves A6 because it uses it. Net zero bytes -- the
 *            wider MOVEM mask is paid for by the later, cheaper A5 load. The
 *            third region is that load moving past a MOVE.L D0,D2.
 *   tried:   nothing source-side reaches register allocation.
 *   scope:   whole-program; docs/compiler-version.md, "The A3/A5 divergence has
 *            a single root cause".
 *   retest:  a compiler that reserves A5 as a frame pointer takes this to exact.
 */

#include "esq-graphics-leaf.h"

extern unsigned short NEWGRID_ColumnStartXPx;

void NEWGRID_FillGridRects(struct RastPort *rp, long leftPen, long rightPen, long y2)
{
    SetAPen(rp, leftPen);
    RectFill(rp, 0L, 0L, (long)NEWGRID_ColumnStartXPx + 35, y2);

    SetAPen(rp, rightPen);
    RectFill(rp, (long)NEWGRID_ColumnStartXPx + 36, 0L, 695L, y2);
}
