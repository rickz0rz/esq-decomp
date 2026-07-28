/* RESTORES: _BEVEL_DrawVerticalBevel
 * MODULE:   modules/groups/a/a/bevel.s
 * STATUS:   behavioural
 *
 * Four stacked horizontal strokes in pen 1, each one row lower and one pixel
 * shorter on the right -- the falling counterpart to
 * bevel_draw_horizontal_bevel.c. (Both of these draw HORIZONTAL lines despite
 * the names; only bevel_draw_vertical_bevel_pair.c draws vertical ones. The
 * labels come from the disassembler and are not evidence about the original.)
 *
 * The pattern reset (LinePtrn = 0xFFFF, Flags |= FRST_DOT, linpatcnt = 15) is
 * repeated before EVERY stroke here, where bevel_draw_horizontal_bevel.c does it
 * once. That is the original's grouping and it is reproduced literally rather
 * than hoisted, because hoisting it changes the emitted sequence.
 *
 * Written unrolled because the original is unrolled. A C `for` loop over k would
 * emit a loop and match nothing.
 *
 * LIBRARY BASE: esq-graphics-leaf.h, the NON-volatile base -- every call is a
 * library call. See esq-graphics-leaf.h; tools/a6_audit.py enforces it.
 *
 * 252 bytes against 274, all 22 the A5 frame class: -8 prologue, -2 epilogue,
 * and three spill pairs at -4 each, exactly as in
 * bevel_draw_horizontal_bevel.c. All eight library calls and all four pattern
 * resets are byte-identical.
 *
 * SASC-MISMATCH: a5-frame-pointer
 *   ref:     4e55fffc LINK.W A5,#-4 ... 2f400010 / 222f0010  (x3)
 *   got:     (no frame)              ... 2200                (x3)
 *   summary: as bevel_draw_horizontal_bevel.c -- the original spills each
 *            computed Y to its frame slot, 6.51 keeps it in a register.
 *   tried:   nothing source-side.
 *   scope:   whole-program.
 *   retest:  a compiler that reserves A5 as the frame pointer.
 */

#include "esq-graphics-leaf.h"

void BEVEL_DrawVerticalBevel(struct RastPort *rp, long x, long y, long w)
{
    SetDrMd(rp, 0L);
    SetAPen(rp, 1L);

    rp->LinePtrn = 0xFFFF;
    rp->Flags |= 1;
    rp->linpatcnt = 15;
    Move(rp, x, y);
    Draw(rp, w - 1, y);

    rp->LinePtrn = 0xFFFF;
    rp->Flags |= 1;
    rp->linpatcnt = 15;
    Move(rp, x, y + 1);
    Draw(rp, w - 2, y + 1);

    rp->LinePtrn = 0xFFFF;
    rp->Flags |= 1;
    rp->linpatcnt = 15;
    Move(rp, x, y + 2);
    Draw(rp, w - 3, y + 2);

    rp->LinePtrn = 0xFFFF;
    rp->Flags |= 1;
    rp->linpatcnt = 15;
    Move(rp, x, y + 3);
    Draw(rp, w - 4, y + 3);
}
