/* RESTORES: _SCRIPT_InitCtrlContext
 * MODULE:   modules/groups/b/a/script3.s
 * STATUS:   exact
 *
 * Byte-exact against the original.
 */
extern char SCRIPT_CTRL_CONTEXT[];
extern void SCRIPT_SetCtrlContextMode(char *ctx, long mode);
void SCRIPT_InitCtrlContext(void)
{
    SCRIPT_SetCtrlContextMode(SCRIPT_CTRL_CONTEXT, 1);
}
