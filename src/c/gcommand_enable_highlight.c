/* RESTORES: _GCOMMAND_EnableHighlight
 * MODULE:   modules/groups/a/u/gcommand3.s
 * STATUS:   exact
 *
 * Byte-exact against the original.
 */
extern short GCOMMAND_HighlightFlag;
extern void  GCOMMAND_ApplyHighlightFlag(void);
void GCOMMAND_EnableHighlight(void)
{
    GCOMMAND_HighlightFlag = 1;
    GCOMMAND_ApplyHighlightFlag();
}
