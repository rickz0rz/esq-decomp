/* RESTORES: SET_A_PEN_1_B_PEN_6_DRMD_1_DRAW_LINE_OR_PAGE
 * MODULE:   modules/groups/a/l/ed3bb_p4.s
 * STATUS:   behavioural
 *
 * Draws "LINE" or "PAGE" at (40, 390) in pen 1 on background 6, then puts the
 * pens back. The label name in the disassembly is a description of the pen
 * sequence rather than a name, and it is kept because it is the exported
 * symbol.
 *
 * A non-zero Global_REF_BOOL_IS_LINE_OR_PAGE selects PAGE (BNE takes the
 * branch to the PAGE string), so the flag reads as "is page".
 *
 * The volatile graphics header is required -- DISPLIB_DisplayTextAtPosition is
 * ESQ assembly and does not preserve A6. The original loads the base once for
 * the opening SetAPen/SetBPen/SetDrMd run and once more for the closing pair,
 * which is exactly what the convention needs.
 *
 * 122 ref vs 148 got, and the +26 is ALL the A6 policy. Every LVO offset, both
 * string addresses, the PEA 390 / PEA 40 pair and the argument pushes match
 * exactly.
 *
 *   +18  the volatile base reloads before all FIVE library calls; the original
 *        loads it twice, once for the opening SetAPen/SetBPen/SetDrMd run and
 *        once for the closing SetBPen/SetDrMd pair. Three extra loads at 6
 *        bytes each.
 *   +4   6.51 saves A6 (48e70006 / 4cdf6000) where the original does not.
 *   +4   the original drops its argument frame with UNLK from a zero-sized
 *        LINK; 6.51 has no frame and pops with LEA 16(A7),A7.
 *
 * This function is the WORST CASE for the volatile header in the whole
 * restoration set so far -- five library calls with only one intervening ESQ
 * call. esq-graphics-leaf.h would emit the original TWO loads and close 18 of
 * the 26 bytes, and it is still refused: DISPLIB_DisplayTextAtPosition sits
 * between the two runs, it is ESQ assembly, and it does not preserve A6. The
 * leaf header would leave the closing SetBPen entering graphics at whatever
 * offset that call left behind. tools/a6_audit.py flags exactly this, which is
 * what makes the refusal checkable rather than a matter of taste.
 *
 * The class is written up program-wide in ed_draw_are_you_sure_prompt.c and
 * tliba3_clear_view_mode_rast_port.c and is not duplicated as a SASC-MISMATCH
 * block here, because a second copy of a program-wide finding rots
 * independently of the first.
 */
#include "esq-graphics.h"

extern void DISPLIB_DisplayTextAtPosition(struct RastPort *rp, long x, long y,
                                          char *text);
extern struct RastPort *Global_REF_RASTPORT_1;
extern long Global_REF_BOOL_IS_LINE_OR_PAGE;
extern char Global_STR_LINE[];
extern char Global_STR_PAGE[];

void SET_A_PEN_1_B_PEN_6_DRMD_1_DRAW_LINE_OR_PAGE(void)
{
    char *text;

    SetAPen(Global_REF_RASTPORT_1, 1L);
    SetBPen(Global_REF_RASTPORT_1, 6L);
    SetDrMd(Global_REF_RASTPORT_1, 1L);

    if (Global_REF_BOOL_IS_LINE_OR_PAGE)
        text = Global_STR_PAGE;
    else
        text = Global_STR_LINE;

    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 40L, 390L, text);

    SetBPen(Global_REF_RASTPORT_1, 2L);
    SetDrMd(Global_REF_RASTPORT_1, 0L);
}
