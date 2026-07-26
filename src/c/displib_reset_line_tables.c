/* RESTORES: _DISPLIB_ResetLineTables
 * MODULE:   modules/groups/a/i/displib.s
 * STATUS:   exact
 *
 * Byte-exact against the original.
 */
extern short DISPTEXT_TargetLineIndex;
extern short DISPTEXT_CurrentLineIndex;
extern long  DISPTEXT_LineWidthPx;
extern long  DISPTEXT_ControlMarkerWidthPx;
extern long  DISPTEXT_LineTableLockFlag;
extern short DISPTEXT_ControlMarkersEnabledFlag;
extern long  DISPTEXT_LinePtrTable[];
extern short DISPTEXT_LineLengthTable[];
extern long  DISPTEXT_LinePenTable[];

void DISPLIB_ResetLineTables(void)
{
    long i;

    DISPTEXT_CurrentLineIndex = DISPTEXT_TargetLineIndex = 0;
    DISPTEXT_LineTableLockFlag = DISPTEXT_ControlMarkerWidthPx = DISPTEXT_LineWidthPx = 0;
    DISPTEXT_ControlMarkersEnabledFlag = 0;
    for (i = 0; i < 20; i++) {
        DISPTEXT_LinePtrTable[i] = 0;
        DISPTEXT_LineLengthTable[i] = 0;
        DISPTEXT_LinePenTable[i] = 1;
    }
}
