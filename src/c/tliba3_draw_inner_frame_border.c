/* RESTORES: _TLIBA3_DrawInnerFrameBorder
 * MODULE:   modules/groups/b/a/tliba3_p1.s
 * STATUS:   behavioural
 *
 * NAME IS WRONG, and it came from the disassembler, not the original. This draws
 * no frame and no border: it strokes the two DIAGONALS of the rastport's bitmap,
 * (0,0)->(w-1,h-1) then (w-1,0)->(0,h-1). An X across the whole surface. The
 * four calls in the reference are unambiguous. The label is left as-is because
 * renaming it is a separate and wider change.
 *
 * Extents come from the rastport's own bitmap: width is BytesPerRow * 8 (the
 * ASL.L #3) and height is Rows, each less one for the inclusive endpoint.
 *
 * 98 bytes against 94 (100 in the object, the last 2 being longword padding), and
 * every one of the 4 is a compiler class with nothing
 * source-side left to try. Two source shapes were load-bearing to get here:
 *
 *   - `<< 3`, NOT `* 8`. Worth 28 bytes on its own. With `* 8` SAS/C widens the
 *     computation: it zero-extends via SWAP/CLR.W/SWAP (8 bytes where the
 *     original's MOVEQ #0 / MOVE.W is 4) and then spills an argument to a stack
 *     slot it has to allocate, giving the function a frame the original has
 *     none of. Writing the shift the original actually emits removes all of it.
 *   - the leaf library-base header (see below), worth 18.
 *
 * The original RELOADS rp->BitMap in all four blocks rather than hoisting it, so
 * this does too -- AGENTS.md, "table[i].field repeatedly, not hoisting".
 *
 * LIBRARY BASE: this file uses esq-graphics-leaf.h, the NON-volatile base. Every
 * call it makes is a library call, so no ESQ assembly can clobber A6 between
 * them and the original's own single load is safe to reproduce. Read
 * esq-graphics-leaf.h before copying this; tools/a6_audit.py enforces the
 * precondition mechanically.
 *
 * SASC-MISMATCH: a6-callee-saved
 *   ref:     2f0b                MOVE.L A3,-(A7)   / 265f     MOVEA.L (A7)+,A3
 *   got:     48e70006            MOVEM.L A5-A6,-(A7) / 4cdf6000
 *   summary: +4 total. Two things at once, and they are the two standing classes:
 *            the original allocates its register variable to A3 and 6.51 uses A5
 *            (docs/compiler-version.md, "The A3/A5 divergence"), and the original
 *            does NOT preserve A6 at all while SAS/C saves it whenever it uses
 *            it. The second is the convention esq-libbase.md describes and is
 *            not negotiable from C.
 *   tried:   `<< 3` vs `* 8` vs `(unsigned long)` casts vs no cast (measured:
 *            144, 144, 144, 116 bytes) -- the shift is what mattered, and it
 *            does not touch the prologue. Nothing reaches A3-vs-A5.
 *   scope:   whole-program; every A3-regvar restoration carries it.
 *   retest:  a compiler that reserves A5 as a frame pointer and hands out A3
 *            first. It would take this function to 94 exactly.
 */

#include "esq-graphics-leaf.h"

void TLIBA3_DrawInnerFrameBorder(struct RastPort *rp)
{
    Move(rp, 0L, 0L);
    Draw(rp, ((long)rp->BitMap->BytesPerRow << 3) - 1, (long)rp->BitMap->Rows - 1);

    Move(rp, ((long)rp->BitMap->BytesPerRow << 3) - 1, 0L);
    Draw(rp, 0L, (long)rp->BitMap->Rows - 1);
}
