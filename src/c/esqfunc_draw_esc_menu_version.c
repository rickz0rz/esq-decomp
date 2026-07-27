/* RESTORES: ESQFUNC_DrawEscMenuVersion
 * MODULE:   modules/groups/a/n/esqfunc.s
 * STATUS:   behavioural
 *
 * Draws the version block on the ESC menu: the build number and id on one line,
 * the Kickstart version the program believes it is running under on the next, and
 * a "push any key" prompt in pen 3 below that. Leaves the RastPort back in pen 1.
 *
 * Clearing ED_DiagnosticsScreenActive on entry is not incidental -- drawing the
 * version block is how the diagnostics screen is dismissed.
 *
 * One buffer is reused for both formatted lines, which is why the first line has
 * to be drawn before the second is formatted.
 *
 * 218 bytes in the original, 220 emitted, itemised exactly by tools/casm.py as
 * +4 -12 +10. Everything here is the frame class and nothing else: same frame
 * SIZE (84 bytes, so the 81-byte line buffer is right), same call sequence, same
 * constants, same pen order.
 *
 * SASC-MISMATCH: no-frame-for-locals
 *   ref:     4e55ffac ... 4e5d     LINK.W A5,#-84 / UNLK A5
 *   got:     9efc0054 48e70006 ... 4fef002c 4cdf6000 defc0054
 *   summary: The A5-frame class, and this is the clearest example yet of the
 *            frame pointer PAYING for itself: the original's UNLK pops the last
 *            call's arguments as a side effect, so its epilogue is two bytes.
 *            6.51 needs LEA 44(A7),A7 before its MOVEM and ADDA.W, which is +10.
 *            With +4 in the prologue that is +14 of frame cost, and the only
 *            reason the function still lands within two bytes is the entry below.
 *   scope:   program-wide; see docs/compiler-version.md.
 *
 * SASC-MISMATCH: reload-vs-cache
 *   ref:     2c7900002858 (x3)    MOVEA.L GfxBase,A6 before each SetAPen
 *   got:     one load at the top  A6 kept live across all six library calls
 *   summary: The original reloads the library base before every SetAPen even
 *            though A6 is untouched in between; 6.51 loads it once. -12, three
 *            sites of 6 bytes less one 6-byte load hoisted to the top. Same class
 *            as gcommand_load_mplex_file.c, and by far its largest sighting.
 *            Note ed_draw_help_panels.c does NOT show it -- there the original
 *            loads the base once too, so this is not a blanket habit.
 */
#include "esq-graphics.h"

extern void GROUP_AM_JMPTBL_WDISP_SPrintf();   /* variadic: arg count differs per call */
extern void ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition(void *rp, long x, long y,
                                                         char *s);

extern struct RastPort *Global_REF_RASTPORT_1;
extern short ED_DiagnosticsScreenActive;
extern long Global_LONG_BUILD_NUMBER;
extern char *Global_PTR_STR_BUILD_ID;
extern long Global_LONG_ROM_VERSION_CHECK;
extern char Global_STR_BUILD_NUMBER_FORMATTED[];
extern char Global_STR_ROM_VERSION_FORMATTED[];
extern char Global_STR_ROM_VERSION_1_3[];
extern char Global_STR_ROM_VERSION_2_04[];
extern char Global_STR_PUSH_ANY_KEY_TO_CONTINUE_1[];

void ESQFUNC_DrawEscMenuVersion(void)
{
    char line[81];
    char *romName;

    ED_DiagnosticsScreenActive = 0;

    SetAPen(Global_REF_RASTPORT_1, 1L);
    SetDrMd(Global_REF_RASTPORT_1, 1L);

    GROUP_AM_JMPTBL_WDISP_SPrintf(line, Global_STR_BUILD_NUMBER_FORMATTED,
                                  Global_LONG_BUILD_NUMBER, Global_PTR_STR_BUILD_ID);
    ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 175L, 330L,
                                                 line);

    if (Global_LONG_ROM_VERSION_CHECK == 1)
        romName = Global_STR_ROM_VERSION_1_3;
    else
        romName = Global_STR_ROM_VERSION_2_04;

    GROUP_AM_JMPTBL_WDISP_SPrintf(line, Global_STR_ROM_VERSION_FORMATTED, romName);
    ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 175L, 360L,
                                                 line);

    SetAPen(Global_REF_RASTPORT_1, 3L);
    ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 175L, 390L,
                                                 Global_STR_PUSH_ANY_KEY_TO_CONTINUE_1);
    SetAPen(Global_REF_RASTPORT_1, 1L);
}
