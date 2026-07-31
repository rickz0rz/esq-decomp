/* RESTORES: ED_DrawAreYouSurePrompt
 * MODULE:   modules/groups/a/l/ed3bb_p2.s
 * STATUS:   behavioural
 *
 * Draws the confirmation prompt: help panel 6, then the text in JAM1 with pen
 * 1, then the draw mode restored to 1.
 *
 * WHY THIS USES THE VOLATILE HEADER, not esq-graphics-leaf.h. Two of the calls
 * here are into ESQ assembly (ED_DrawHelpPanels and
 * DISPLIB_DisplayTextAtPosition), and ESQ assembly does not preserve A6. The
 * original agrees: it loads the graphics base before the first SetDrMd, keeps
 * it across the adjacent SetAPen -- a library call, which DOES preserve A6 --
 * and reloads it after DisplayTextAtPosition for the closing SetDrMd. Two
 * loads, in exactly the two places the convention requires.
 *
 * The volatile header gives three loads rather than two, because it reloads
 * before SetAPen as well. That costs 6 bytes and is the safe direction: the
 * leaf header would give one load and leave the closing SetDrMd running on an
 * A6 that DisplayTextAtPosition had already clobbered. tools/a6_audit.py flags
 * exactly that, which is what makes the choice checkable rather than a
 * judgement call.
 *
 * 86 ref vs 96 got, and the +10 is fully itemised -- both items are the A6
 * question and nothing else. The PEA 6, the three library LVO offsets
 * (fe9e/feaa/fe9e), the PEA 330 / PEA 40 argument pushes and the
 * LEA 20(A7),A7 cleanup all match exactly.
 *
 * SASC-MISMATCH: a6-reload-between-adjacent-library-calls
 *   ref:     2c79...2858 4eaefe9e 2279...8702 7001 4eaefeaa
 *            base loaded once, kept across SetDrMd -> SetAPen
 *   got:     2c79...     4eaefe9e 2279...     2c79...     7001 4eaefeaa
 *            base reloaded before SetAPen as well
 *   summary: the volatile base forces a reload before EVERY library call. The
 *            original reloads only where the convention requires it, so it
 *            keeps the base across the adjacent SetDrMd/SetAPen pair. Costs 6
 *            bytes at this one site.
 *   tried:   esq-graphics-leaf.h, which would emit a single load and match on
 *            this point. REJECTED, and not marginally: the closing SetDrMd runs
 *            AFTER DISPLIB_DisplayTextAtPosition, which is ESQ assembly and
 *            does not preserve A6. The leaf header would enter graphics at
 *            whatever offset that call left behind. a6_audit.py flags it, which
 *            is the machine check AGENTS.md relies on for this decision.
 *   scope:   every ESQ function with two adjacent library calls. 6 bytes each.
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 *
 * SASC-MISMATCH: a6-preserved-across-libcall
 *   ref:     (A6 not saved)
 *   got:     2f0e ... 2c5f          MOVE.L A6,-(A7) / MOVEA.L (A7)+,A6
 *   summary: 6.51 treats A6 as callee-saved and saves it; the original treats
 *            it as scratch and does not. 4 bytes, and the rest of the +10.
 *            Recorded program-wide in tliba3_clear_view_mode_rast_port.c;
 *            CONSTLIBBASE, NOCONSTLIBBASE, SAVEDS and NOSAVEDS all leave it.
 *   scope:   every OS-calling function in the program.
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
#include "esq-graphics.h"

extern void  ED_DrawHelpPanels(long which);
extern void  DISPLIB_DisplayTextAtPosition(struct RastPort *rp, long x, long y,
                                           char *text);
extern struct RastPort *Global_REF_RASTPORT_1;
extern char  Global_STR_ARE_YOU_SURE[];

void ED_DrawAreYouSurePrompt(void)
{
    ED_DrawHelpPanels(6L);

    SetDrMd(Global_REF_RASTPORT_1, 0L);
    SetAPen(Global_REF_RASTPORT_1, 1L);

    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 40L, 330L,
                                  Global_STR_ARE_YOU_SURE);

    SetDrMd(Global_REF_RASTPORT_1, 1L);
}
