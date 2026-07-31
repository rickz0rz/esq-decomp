/* RESTORES: DISKIO2_DisplayStatusLine
 * MODULE:   modules/groups/a/h/diskio2_p1_2.s
 * STATUS:   behavioural
 *
 * Blanks the status line by drawing 38 spaces over it, then draws the caller's
 * text at the same position. Both draws use x=40, y=120.
 *
 * The volatile graphics header is required here for the same reason as
 * ed_draw_are_you_sure_prompt.c: DISPLIB_DisplayTextAtPosition is ESQ assembly
 * and does not preserve A6. The original loads the base once for the adjacent
 * SetAPen/SetDrMd pair -- both library calls, which do preserve it -- and needs
 * no further load because it makes no library call after the ESQ ones.
 *
 * 88 ref vs 100 got, and the +12 is fully itemised. Both LVO offsets, both
 * PEA 120 / PEA 40 pairs, the MOVE.L text,(A7) argument-slot reuse and the
 * LEA 28(A7),A7 cleanup all match exactly.
 *
 *   +6  the volatile base reloads before SetDrMd as well as SetAPen, where the
 *       original keeps it across the adjacent pair. Same class as
 *       ed_draw_are_you_sure_prompt.c; the leaf header is not available here
 *       either, because DISPLIB_DisplayTextAtPosition is ESQ assembly.
 *   +4  6.51 saves A6 (48e70006 / 4cdf6000, 8 bytes) where the original saves
 *       only A3 (2f0b / 265f, 4 bytes) -- the A6-is-callee-saved class.
 *   +2  object alignment padding (4e71), not code.
 *
 * Both codegen items are recorded program-wide in
 * tliba3_clear_view_mode_rast_port.c and ed_draw_are_you_sure_prompt.c; they
 * are not duplicated here as SASC-MISMATCH blocks because a second copy would
 * rot independently of the first.
 */
#include "esq-graphics.h"

extern void DISPLIB_DisplayTextAtPosition(struct RastPort *rp, long x, long y,
                                          char *text);
extern struct RastPort *Global_REF_RASTPORT_1;
extern char Global_STR_38_SPACES[];

void DISKIO2_DisplayStatusLine(char *text)
{
    SetAPen(Global_REF_RASTPORT_1, 1L);
    SetDrMd(Global_REF_RASTPORT_1, 1L);

    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 40L, 120L,
                                  Global_STR_38_SPACES);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 40L, 120L, text);
}
