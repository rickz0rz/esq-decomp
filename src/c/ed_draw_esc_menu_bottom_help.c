/* RESTORES: _ED_DrawESCMenuBottomHelp
 * MODULE:   modules/groups/a/l/ed3b.s
 * STATUS:   exact
 *
 * Byte-exact against the original.
 */
extern unsigned char ED_MenuStateId;
extern void ED_DrawBottomHelpBarBackground(void);
extern void ED_DrawESCMenuHelpText(void);
void ED_DrawESCMenuBottomHelp(void)
{
    ED_MenuStateId = 1;
    ED_DrawBottomHelpBarBackground();
    ED_DrawESCMenuHelpText();
}
