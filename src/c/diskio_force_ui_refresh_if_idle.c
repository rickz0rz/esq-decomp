/* RESTORES: DISKIO_ForceUiRefreshIfIdle
 * MODULE:   modules/groups/a/g/diskio.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: branch-shape
 *   ref:     4a790000a2dc661433fc010000005e8e33fcffff0000bf184eba17624e75
 *   got:     303900000000661433fc01000000000033fcffff00000000610000004e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
extern short Global_UIBusyFlag;
extern short ESQPARS2_ReadModeFlags;
extern short Global_RefreshTickCounter;
extern void  TEXTDISP_ResetSelectionAndRefresh(void);
void DISKIO_ForceUiRefreshIfIdle(void)
{
    if (Global_UIBusyFlag != 0)
        return;
    ESQPARS2_ReadModeFlags = 0x100;
    Global_RefreshTickCounter = -1;
    TEXTDISP_ResetSelectionAndRefresh();
}
