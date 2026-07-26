/* RESTORES: ESQFUNC_ServiceUiTickIfRunning
 * MODULE:   modules/groups/a/n/esqfunc.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: dead-code-after-rts
 *   ref:     4a790000292e67046100fe8c4e754ebaead44a790000a2de67044eba0a9e4eba0adc4e75
 *   got:     3039000000006704610000004e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
extern short ESQ_MainLoopUiTickEnabledFlag;
extern void  ESQFUNC_ProcessUiFrameTick(void);
void ESQFUNC_ServiceUiTickIfRunning(void)
{
    if (ESQ_MainLoopUiTickEnabledFlag != 0)
        ESQFUNC_ProcessUiFrameTick();
}
