/* RESTORES: _DISPTEXT_SetCurrentLineIndex
 * MODULE:   modules/groups/a/i/disptext.s
 * STATUS:   exact
 *
 * Byte-exact against the original.
 */
extern long DISPTEXT_LineTableLockFlag;
extern void DISPLIB_CommitCurrentLinePenAndAdvance(long pen);
void DISPTEXT_SetCurrentLineIndex(long pen)
{
    if (DISPTEXT_LineTableLockFlag != 0)
        return;
    if (pen < 1)
        return;
    if (pen > 3)
        return;
    DISPLIB_CommitCurrentLinePenAndAdvance(pen);
}
