/* RESTORES: TEXTDISP_ResetSelectionAndRefresh
 * MODULE:   modules/groups/b/a/textdisp2.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: argument-slot-reuse
 *   ref:     487800034ebacea633fcffff0000c75842974eba0276584f4e75
 *   got:     487800036100000033fcffff00000000429761000000584f4e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
extern short TEXTDISP_CurrentMatchIndex;
extern void  SCRIPT_UpdateSerialShadowFromCtrlByte(long v);
extern void  ESQIFF_PlayNextExternalAssetFrame(long v);
void TEXTDISP_ResetSelectionAndRefresh(void)
{
    SCRIPT_UpdateSerialShadowFromCtrlByte(3);
    TEXTDISP_CurrentMatchIndex = -1;
    ESQIFF_PlayNextExternalAssetFrame(0);
}
