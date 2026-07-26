/* RESTORES: ESQFUNC_WaitForClockChangeAndServiceUi
 * MODULE:   modules/groups/a/n/esqfunc.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: loop-shape
 *   ref:     4eba0c8e4a406606610001d860f24e75
 *   got:     610000004a4066066100000060f24e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
extern short ESQFUNC_JMPTBL_PARSEINI_MonitorClockChange(void);
extern void  ESQFUNC_ServiceUiTickIfRunning(void);
void ESQFUNC_WaitForClockChangeAndServiceUi(void)
{
    while (ESQFUNC_JMPTBL_PARSEINI_MonitorClockChange() == 0)
        ESQFUNC_ServiceUiTickIfRunning();
}
