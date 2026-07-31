/* RESTORES: SET_A_PEN_1_B_PEN_6_DRMD_1_DRAW_TEXT_OR_CURSOR
 * MODULE:   modules/groups/a/l/ed3bb_p4.s
 * STATUS:   behavioural
 *
 * The sibling of ed_draw_line_or_page_label.c: same pen sequence, same two-way
 * string choice, drawn at (296, 390) instead of (40, 390).
 *
 * Two differences from the sibling and both are read off the bytes rather than
 * assumed. The selector is a PARAMETER here, not a global, and the test is
 * `== 1` exactly (MOVEQ #1 / CMP.L / BNE) rather than a plain non-zero test --
 * so 1 gives "TEXT" and everything else, including 2, gives "CURSOR".
 *
 * This one DOES clean its argument stack (LEA 16(A7),A7) because it has no A5
 * frame to drop it with; the sibling has LINK/UNLK and does not.
 *
 * The volatile graphics header is required for the same reason as the sibling.
 *
 * 126 ref vs 148 got, and the +22 is the same A6 accounting as the sibling
 * ed_draw_line_or_page_label.c: 18 bytes of extra volatile-base reloads across
 * five library calls, plus 4 for 6.51 saving A6. This one already pops its own
 * argument frame in the original, so it does not pay the extra 4 the sibling
 * does for the UNLK.
 *
 * Everything else matches exactly, including the MOVEQ #1 / CMP.L selector
 * test, both string addresses, the PEA 390 / PEA 296 pair and the
 * LEA 16(A7),A7 cleanup.
 *
 * See the sibling for why esq-graphics-leaf.h is refused here despite being
 * worth 18 bytes.
 */
#include "esq-graphics.h"

extern void DISPLIB_DisplayTextAtPosition(struct RastPort *rp, long x, long y,
                                          char *text);
extern struct RastPort *Global_REF_RASTPORT_1;
extern char Global_STR_TEXT[];
extern char Global_STR_CURSOR[];

void SET_A_PEN_1_B_PEN_6_DRMD_1_DRAW_TEXT_OR_CURSOR(long which)
{
    char *text;

    SetAPen(Global_REF_RASTPORT_1, 1L);
    SetBPen(Global_REF_RASTPORT_1, 6L);
    SetDrMd(Global_REF_RASTPORT_1, 1L);

    if (which == 1)
        text = Global_STR_TEXT;
    else
        text = Global_STR_CURSOR;

    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 296L, 390L, text);

    SetBPen(Global_REF_RASTPORT_1, 2L);
    SetDrMd(Global_REF_RASTPORT_1, 0L);
}
