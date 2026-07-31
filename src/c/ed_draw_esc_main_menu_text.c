/* RESTORES: ED_DrawEscMainMenuText
 * MODULE:   modules/groups/a/l/ed3bb_p0.s
 * STATUS:   behavioural
 *
 * Draws the six ESC-menu entries at y = 90, 120, 150, 180, 210 and 240, all at
 * x = 40, with the selection highlight drawn first.
 *
 * The argument stack is popped in TWO batches, not one: LEA 68(A7),A7 after the
 * fourth line and LEA 32(A7),A7 after the sixth. The first batch also drops the
 * highlight call's own argument, which is why it is 68 and not 64. That is
 * SAS/C's own argument-area handling and needs nothing from the source.
 *
 * The pen is set once before the six lines and the draw mode restored once
 * after, the same open/close pattern as ed_draw_esc_menu_help_text.c -- which
 * is the function that calls this one.
 *
 * The volatile graphics header is required: the highlight drawer and
 * DISPLIB_DisplayTextAtPosition are ESQ assembly and neither preserves A6.
 *
 * 210 ref vs 220 got. All six string addresses, all six y coordinates
 * (90, 120, 150, 180, 210, 240), the PEA 40 on each, BOTH argument-pop batches
 * (LEA 68(A7),A7 and LEA 32(A7),A7 at exactly the right points) and the pen and
 * draw-mode calls match exactly.
 *
 *   +6  the volatile base reloads before SetDrMd as well as SetAPen, where the
 *       original keeps it across the adjacent pair.
 *   +4  6.51 saves A6 (2f0e / 2c5f) where the original does not.
 *
 * Both are the settled A6 classes, written up in ed_draw_are_you_sure_prompt.c
 * and tliba3_clear_view_mode_rast_port.c. The leaf header is refused for the
 * usual reason: seven ESQ calls sit between the two library runs.
 */
#include "esq-graphics.h"

extern void ED_DrawMenuSelectionHighlight(long which);
extern void DISPLIB_DisplayTextAtPosition(struct RastPort *rp, long x, long y,
                                          char *text);

extern struct RastPort *Global_REF_RASTPORT_1;
extern char Global_STR_EDIT_ADS[];
extern char Global_STR_EDIT_ATTRIBUTES[];
extern char Global_STR_CHANGE_SCROLL_SPEED[];
extern char Global_STR_DIAGNOSTIC_MODE[];
extern char Global_STR_SPECIAL_FUNCTIONS[];
extern char Global_STR_VERSIONS_SCREEN[];

void ED_DrawEscMainMenuText(void)
{
    ED_DrawMenuSelectionHighlight(6L);

    SetAPen(Global_REF_RASTPORT_1, 1L);
    SetDrMd(Global_REF_RASTPORT_1, 0L);

    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 40L,  90L,
                                  Global_STR_EDIT_ADS);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 40L, 120L,
                                  Global_STR_EDIT_ATTRIBUTES);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 40L, 150L,
                                  Global_STR_CHANGE_SCROLL_SPEED);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 40L, 180L,
                                  Global_STR_DIAGNOSTIC_MODE);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 40L, 210L,
                                  Global_STR_SPECIAL_FUNCTIONS);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 40L, 240L,
                                  Global_STR_VERSIONS_SCREEN);

    SetDrMd(Global_REF_RASTPORT_1, 1L);
}
