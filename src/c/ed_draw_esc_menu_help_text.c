/* RESTORES: ED_DrawESCMenuHelpText
 * MODULE:   modules/groups/a/l/ed3bb_p0.s
 * STATUS:   behavioural
 *
 * Draws help panel 6 and three lines of ESC-menu help at y = 330, 360 and 390,
 * then resets the cursor offset and draws the menu itself.
 *
 * The draw mode is set to 0 before the text and back to 1 afterwards, with the
 * pen set once in between -- the same open/close pattern as
 * ed_draw_are_you_sure_prompt.c.
 *
 * The argument stack is never popped between calls: the original pushes the
 * panel number and all three sets of text arguments and drops the lot with a
 * single LEA 52(A7),A7 at the end. That is SAS/C's own argument-area handling
 * and needs nothing from the source.
 *
 * The volatile graphics header is required -- ED_DrawHelpPanels,
 * DISPLIB_DisplayTextAtPosition and ED_DrawEscMainMenuText are all ESQ assembly
 * and none preserves A6.
 *
 * 144 ref vs 156 got. All three string addresses, all three y coordinates
 * (330, 360, 390), the PEA 40 x coordinate on each, both SetDrMd calls, the
 * SetAPen, the CLR.L of the cursor offset and the single LEA 52(A7),A7 cleanup
 * match exactly.
 *
 *   +6  the volatile base reloads before SetAPen as well as the opening
 *       SetDrMd, where the original keeps it across the adjacent pair.
 *   +4  6.51 saves A6 (2f0e / 2c5f) where the original does not.
 *   +2  object alignment padding.
 *
 * Both codegen items are the settled A6 classes, written up in
 * ed_draw_are_you_sure_prompt.c and tliba3_clear_view_mode_rast_port.c. The
 * leaf header is refused here for the usual reason: three ESQ calls sit between
 * the two library runs.
 */
#include "esq-graphics.h"

extern void ED_DrawHelpPanels(long which);
extern void DISPLIB_DisplayTextAtPosition(struct RastPort *rp, long x, long y,
                                          char *text);
extern void ED_DrawEscMainMenuText(void);

extern struct RastPort *Global_REF_RASTPORT_1;
extern long ED_EditCursorOffset;
extern char Global_STR_PUSH_ESC_TO_RESUME[];
extern char Global_STR_PUSH_RETURN_TO_ENTER_SELECTION_1[];
extern char Global_STR_PUSH_ANY_KEY_TO_SELECT_1[];

void ED_DrawESCMenuHelpText(void)
{
    ED_DrawHelpPanels(6L);

    SetDrMd(Global_REF_RASTPORT_1, 0L);
    SetAPen(Global_REF_RASTPORT_1, 1L);

    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 40L, 330L,
                                  Global_STR_PUSH_ESC_TO_RESUME);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 40L, 360L,
                                  Global_STR_PUSH_RETURN_TO_ENTER_SELECTION_1);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 40L, 390L,
                                  Global_STR_PUSH_ANY_KEY_TO_SELECT_1);

    SetDrMd(Global_REF_RASTPORT_1, 1L);

    ED_EditCursorOffset = 0;
    ED_DrawEscMainMenuText();
}
