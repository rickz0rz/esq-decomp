/* RESTORES: ED_RedrawRow
 * MODULE:   modules/groups/a/l/ed3bbbb_p1.s
 * STATUS:   behavioural
 *
 * Redraws one 40-character editor row by walking the shared cursor-offset
 * global across it, then restores the pens and the caller's cursor position.
 *
 * The cursor offset is a GLOBAL that the draw routine reads, so the loop drives
 * it rather than a local index. The original saves it on entry and writes it
 * back on exit, which is what makes the function safe to call from anywhere.
 *
 * The loop bound is recomputed EVERY iteration -- (row + 1) * 40 goes through
 * the multiply helper inside the loop, not before it. The C below matches that
 * by leaving the expression in the while condition.
 *
 * The volatile graphics header is required: ED_DrawCursorChar is ESQ assembly
 * and does not preserve A6, so the base must reload before SetAPen. The
 * original loads it once, after the loop, and keeps it across the adjacent
 * SetAPen/SetBPen pair -- both library calls, which do preserve it.
 *
 * 102 ref vs 112 got. Both multiplies, the loop compare, the draw call, the
 * ADDQ.L #1 on the global, both LVO offsets (feaa/fea4) and the save/restore
 * of the cursor offset all match in kind and size.
 *
 *   +6  the volatile base reloads before SetBPen as well as SetAPen, where the
 *       original keeps it across the adjacent pair. Same class as
 *       ed_draw_are_you_sure_prompt.c; the leaf header is not available because
 *       ED_DrawCursorChar is ESQ assembly.
 *   +4  6.51 adds A6 to the MOVEM save mask (48e70302 / 4cdf40c0) where the
 *       original does not (48e70300 / 4cdf00c0) -- the A6-is-callee-saved
 *       class recorded in tliba3_clear_view_mode_rast_port.c.
 *
 * Both are settled classes and are not repeated as SASC-MISMATCH blocks here,
 * because a second copy of a program-wide finding rots independently of the
 * first.
 */
#include "esq-graphics.h"

extern void ED_DrawCursorChar(void);
extern long ED_EditCursorOffset;
extern struct RastPort *Global_REF_RASTPORT_1;

void ED_RedrawRow(long row)
{
    long saved;

    saved = ED_EditCursorOffset;
    ED_EditCursorOffset = row * 40;

    while (ED_EditCursorOffset < (row + 1) * 40) {
        ED_DrawCursorChar();
        ED_EditCursorOffset++;
    }

    SetAPen(Global_REF_RASTPORT_1, 1L);
    SetBPen(Global_REF_RASTPORT_1, 2L);

    ED_EditCursorOffset = saved;
}
