/* RESTORES: PARSEINI_UpdateCtrlHDeltaMax
 * MODULE:   modules/groups/b/a/parseini3.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: branch-shape
 *   ref:     2f07700030390000a32c720032390000a32e90812e004a876a060687000001f4700030390000a330b0876c08200733c00000a33020072e1f4e75
 *   got:     48e72100303900000000720032003039000000007400340092822e014a876a060687000001f430390000000072003200b2876c08200733c00000000020074cdf00844e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
extern short CTRL_H;
extern short CTRL_HPreviousSample;
extern short CTRL_HDeltaMax;
long PARSEINI_UpdateCtrlHDeltaMax(void)
{
    long delta = (long)(unsigned short)CTRL_H - (long)(unsigned short)CTRL_HPreviousSample;

    if (delta < 0)
        delta += 500;
    if ((long)(unsigned short)CTRL_HDeltaMax < delta)
        CTRL_HDeltaMax = (short)delta;
    return delta;
}
