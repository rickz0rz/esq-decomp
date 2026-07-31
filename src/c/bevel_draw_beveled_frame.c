/* RESTORES: BEVEL_DrawBeveledFrame
 * MODULE:   modules/groups/a/a/bevel_p0.s
 * STATUS:   behavioural
 *
 * Draws the bevel pair, then the single bevel, then a short pen-2 diagonal
 * from (x,y) to (x+3,y+3).
 *
 * Both bevel helpers take the SAME five arguments, which is why the original
 * pushes them once and then reuses the argument area (MOVE.L D4,(A7) followed
 * by four fresh pushes) rather than rebuilding it.
 *
 * THE VOLATILE GRAPHICS HEADER IS USED, and the cost is known. The original
 * loads the graphics base ONCE, after both BSRs, and keeps it across all three
 * library calls -- which is correct, because SetAPen, Move and Draw are library
 * calls and those do preserve A6. esq-graphics-leaf.h would reproduce that
 * exactly and save 12 bytes.
 *
 * It is NOT used, deliberately. AGENTS.md restricts the leaf header to
 * functions whose every call is a library call -- the `no-calls` bucket -- and
 * this function calls ESQ assembly twice. The restriction is what makes
 * tools/a6_audit.py's check meaningful: it draws the line at "an ESQ call
 * happened", and a file that opts out of that line on a case-by-case reading
 * is exactly the footgun the rule exists to prevent. 12 bytes is not worth
 * making the audit advisory.
 *
 * 100 ref vs 112 got, and the +12 is entirely the A6 question described above.
 * All five argument pushes, the argument-area reuse (2e84), the three LVO
 * offsets (feaa/ff10/ff0a), the ADDQ.L #3 pair and the LEA 36(A7),A7 cleanup
 * match exactly.
 *
 *   +12  the volatile base reloads before each of the three library calls
 *        (2c79 x3) where the original loads it once and keeps it across all
 *        three. 6 bytes at each of the two extra sites. This is the price of
 *        the rule, not a defect: see the header note above for why the leaf
 *        header is refused here.
 *
 * The class is written up program-wide in ed_draw_are_you_sure_prompt.c and
 * tliba3_clear_view_mode_rast_port.c; it is not duplicated as a
 * SASC-MISMATCH block here because a second copy would rot independently.
 */
#include "esq-graphics.h"

extern void BEVEL_DrawVerticalBevelPair(struct RastPort *rp, long a, long b,
                                        long c, long d);
extern void BEVEL_DrawVerticalBevel(struct RastPort *rp, long a, long b,
                                    long c, long d);

void BEVEL_DrawBeveledFrame(struct RastPort *rp, long x, long y, long c, long d)
{
    BEVEL_DrawVerticalBevelPair(rp, x, y, c, d);
    BEVEL_DrawVerticalBevel(rp, x, y, c, d);

    SetAPen(rp, 2L);
    Move(rp, x, y);
    Draw(rp, x + 3, y + 3);
}
