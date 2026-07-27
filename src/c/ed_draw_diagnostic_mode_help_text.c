/* RESTORES: ED_DrawDiagnosticModeHelpText
 * MODULE:   modules/groups/a/l/ed3.s
 * STATUS:   behavioural
 *
 * 166 bytes in the original, 164 emitted, 8 differing regions.
 *
 * Reproduces: both RectFill panels with their exact bounds, the pen and draw-mode
 * changes between them, and the two help lines at y = 390 and 420.
 *
 * The second RectFill reloads only three of its four coordinates -- D2 still
 * holds 640 from the first call, so the original never rewrites it. Writing both
 * calls out in full in C produces the same effect because the compiler makes the
 * same observation, which is why this lands within two bytes.
 *
 * SASC-MISMATCH: a6-preserved-across-libcall
 *   ref:     ... 7002 2c79xxxxxxxx     pen argument set, then GfxBase loaded
 *   got:     ... 2c79xxxxxxxx 7002     GfxBase loaded, then pen argument set
 *   summary: The usual ordering half of this class -- SAS/C hoists the library
 *            base load above the argument setup. The MOVEM masks also differ by
 *            one register. Together that is the whole -2.
 *
 * SASC-MISMATCH: external-call-width
 *   summary: 4EBA against 6100 for the two cross-unit text calls.
 */
#include <proto/graphics.h>

extern void DISPLIB_DisplayTextAtPosition(void *rp, long x, long y, char *s);
extern struct RastPort *Global_REF_RASTPORT_1;
extern char Global_STR_PUSH_RETURN_TO_ENTER_SELECTION_3[];
extern char Global_STR_PUSH_ANY_KEY_TO_SELECT_2[];

void ED_DrawDiagnosticModeHelpText(void)
{
    SetAPen(Global_REF_RASTPORT_1, 2L);
    RectFill(Global_REF_RASTPORT_1, 40L, 68L, 640L, 327L);

    SetAPen(Global_REF_RASTPORT_1, 6L);
    RectFill(Global_REF_RASTPORT_1, 40L, 328L, 640L, 429L);

    SetDrMd(Global_REF_RASTPORT_1, 0L);
    SetAPen(Global_REF_RASTPORT_1, 1L);

    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 40, 390,
                                  Global_STR_PUSH_RETURN_TO_ENTER_SELECTION_3);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 40, 420,
                                  Global_STR_PUSH_ANY_KEY_TO_SELECT_2);
}
