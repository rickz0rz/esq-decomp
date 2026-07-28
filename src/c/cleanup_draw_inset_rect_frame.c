/* RESTORES: _CLEANUP_DrawInsetRectFrame
 * MODULE:   modules/groups/a/e/cleanup4_cleanup_drawinsetrectframe.s
 * STATUS:   behavioural
 *
 * Fill a rectangle in the caller's pen and draw a two-pixel inset bevel around
 * it: pen 1 for the top-left light edges, pen 2 for the bottom-right shadow,
 * each drawn twice at one- and two-pixel offsets. Then restore the rastport's
 * pen position and its original pen, so the caller sees no side effect.
 *
 * The rectangle is positioned RELATIVE TO THE CURRENT PEN POSITION and the
 * font, not from arguments: the origin is (cp_x - 2) horizontally, and
 * vertically cp_y + 2 - TxBaseline - 1, i.e. it brackets the text baseline the
 * caller was about to write at. That is why it saves cp_x / cp_y + 2 separately
 * and Moves back to them at the end.
 *
 * The saved pen is read SIGNED (MOVE.B 25(A3) / EXT.W / EXT.L), so FgPen is a
 * signed char here, and so is the pen argument (byte at 15(A5), the low byte of
 * its longword slot).
 *
 * Width and height are shorts held in frame slots and sign-extended at EVERY
 * use rather than once -- the original reloads -10(A5) / -12(A5) per call and
 * EXT.Ls each time. Declaring them short and letting each use promote is what
 * reproduces that; hoisting them into longs would not.
 *
 * LIBRARY BASE: esq-graphics-leaf.h, the NON-volatile base -- every call here is
 * a library call and the original loads the base exactly once for all sixteen.
 * See esq-graphics-leaf.h; tools/a6_audit.py enforces the precondition.
 *
 * NO SHORTINT, DELIBERATELY, AND THE BYTE COUNT ARGUES THE OTHER WAY. This is a
 * worked example of AGENTS.md rule 1 -- byte-closeness is not fidelity:
 *
 *     without SHORTINT   540 against 520   (+20)   EXT.L count 35 vs ref 34
 *     with SHORTINT      468 against 520   (-52)   EXT.L count 28 vs ref 34
 *
 * SHORTINT more than halves the delta and is WRONG. The original sign-extends
 * every short to a long and does the coordinate arithmetic long-wide -- 34
 * EXT.L instructions -- because the graphics calls take longs. With 16-bit ints
 * the arithmetic happens word-wide and six of those extensions vanish, so the
 * smaller number is bought by emitting different instructions. The
 * size-independent check (AGENTS.md rule 2, counting a specific instruction
 * form in both streams) settles it cleanly, which is exactly what it is for.
 *
 * SASC-MISMATCH: a5-frame-pointer
 *   summary: +20 over 520. The original holds the four derived coordinates in
 *            frame slots at -6/-8/-10/-12(A5) and reloads them per call; 6.51
 *            builds no frame and keeps them in registers, so it pays for the
 *            reloads elsewhere. Not itemised further: the sixteen near-identical
 *            call sites make casm.py's alignment unreliable past the first few.
 *   tried:   SHORTINT (468, rejected on the EXT.L evidence above).
 *   scope:   whole-program frame class.
 *   retest:  a compiler that reserves A5 as the frame pointer.
 */

#include "esq-graphics-leaf.h"

void CLEANUP_DrawInsetRectFrame(struct RastPort *rp, char pen, short w, short h)
{
    short saveX = rp->cp_x;
    short saveY = rp->cp_y + 2;
    short x     = rp->cp_x - 2;
    short y     = rp->cp_y + 2 - rp->TxBaseline - 1;
    long  savedPen = rp->FgPen;

    w += 2;

    SetAPen(rp, (long)pen);
    RectFill(rp, x, y, x + w, y + h);

    SetAPen(rp, 1L);
    Move(rp, x - 2, y + h + 2);
    Draw(rp, x - 2, y - 2);
    Draw(rp, x + w + 2, y - 2);
    Move(rp, x - 1, y + h + 1);
    Draw(rp, x - 1, y - 1);
    Draw(rp, x + w + 1, y - 1);

    SetAPen(rp, 2L);
    Move(rp, x + w + 2, y - 1);
    Draw(rp, x + w + 2, y + h + 2);
    Draw(rp, x - 1, y + h + 2);
    Move(rp, x + w + 1, y);
    Draw(rp, x + w + 1, y + h + 1);
    Draw(rp, x, y + h + 1);

    Move(rp, saveX, saveY);
    SetAPen(rp, savedPen);
}
