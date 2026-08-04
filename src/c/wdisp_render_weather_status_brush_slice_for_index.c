/* RESTORES: WDISP_RenderWeatherStatusBrushSliceForIndex
 * MODULE:   modules/groups/b/a/wdisp_p1.s   (1 of its 2 blocks)
 * STATUS:   behavioural
 *
 * Looks up the weather brush named by the current status brush index and
 * renders one slice of it into the panel.
 *
 * THE DISASSEMBLY ALREADY CALLED IT DEAD -- `; Dead code.` -- and it carried no
 * label until 2026-08-04. Nothing reaches it by name or by fall-through.
 * Adding the label is byte-neutral. The name is OURS.
 *
 * THE VALID RANGE IS 2 THROUGH 6, AND THE FIRST TEST IS FOR EXACTLY 1. The
 * original does `SUBQ.B #1,D0 / BEQ` -- a test for the value 1, not a lower
 * bound -- and only then checks `<= 6` unsigned. So an index of 0 passes the
 * first test and is caught by neither, reaching the table at slot 0. Written
 * out as the same two tests rather than collapsed to a range check, because
 * collapsing it would change which indices reach the table.
 *
 * THE TABLE IS INDEXED FROM _ESQFUNC_STR_I5, WHICH IS A LAYOUT-COUPLED ANCHOR.
 * The assembly carries a comment saying so. It is an array of string pointers
 * and the index is scaled by 4, so the C indexes it as `char *[]` -- the same
 * addresses, without the shift written out.
 *
 * SASC-MISMATCH: unsigned-byte-compare
 *   ref:     CMP.B with BLS -- an unsigned test on the byte
 *   got:     the byte widened to a word and compared
 *   summary: SAS/C widens before comparing where the original compares in the
 *            byte. Same set of accepted indices, because the value is already
 *            zero-extended. A few bytes.
 *   scope:   program-wide.
 *   retest:  a compiler that compares in the byte.
 */
#ifndef GRIDPANEL_DEFINED
struct GridPanel;
#endif
#ifndef BRUSH4HEAD_DEFINED
struct Brush4Head;
#endif
#ifndef BRUSH4_DEFINED
struct Brush4;
#endif
#ifndef WEATHERBRUSH_DEFINED
struct WeatherBrush;
#endif

extern unsigned char WDISP_WeatherStatusBrushIndex;
extern char  *ESQFUNC_STR_I5[];
extern struct Brush4Head ESQFUNC_PwBrushListHead;

extern struct Brush4 *BRUSH_FindBrushByPredicate(char *want,
                                                 struct Brush4Head *h);
extern short ESQIFF_RenderWeatherStatusBrushSlice(struct GridPanel *panel,
                                                  struct WeatherBrush *brush);

long WDISP_RenderWeatherStatusBrushSliceForIndex(struct GridPanel *panel)
{
    unsigned char index = WDISP_WeatherStatusBrushIndex;
    struct Brush4 *brush;

    if (index == 1)
        return 0;
    if (WDISP_WeatherStatusBrushIndex > 6)
        return 0;

    brush = BRUSH_FindBrushByPredicate(ESQFUNC_STR_I5[WDISP_WeatherStatusBrushIndex],
                                       &ESQFUNC_PwBrushListHead);
    return ESQIFF_RenderWeatherStatusBrushSlice(panel,
                                                (struct WeatherBrush *)brush);
}
