/* RESTORES: LOCAVAIL2_DisplayAlertDelayAndReboot
 * MODULE:   modules/groups/a/z/locavail2_locavail2_displayalertdelayandreboot.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: loop-shape
 *   ref:     4e55fffc48e7010849f9000080007e000c87000f42406c04528760f44eba000e70004cdf10804e5d4e75
 *   got:     2f077e000c87000f42406c04528760f46100000070002e1f4e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 *
 * DO NOT LINK. This restoration is valid as ANALYSIS and its byte comparison
 * stands, but it must never be substituted into a build: installed over intuition.library/DisplayAlert by SetFunction: library register convention.
 * A C function with an ordinary prologue is not a different encoding of that,
 * it is wrong. tools/gen_all_manifest.py excludes it automatically; this note
 * is here so the reason survives if the tooling changes.
 *
 * This class is what hung the machine on the first whole-program C run.
 */
extern void GROUP_AZ_JMPTBL_ESQ_ColdReboot(void);
long LOCAVAIL2_DisplayAlertDelayAndReboot(void)
{
    long i;

    for (i = 0; i < 1000000L; i++)
        ;
    GROUP_AZ_JMPTBL_ESQ_ColdReboot();
    return 0;
}
