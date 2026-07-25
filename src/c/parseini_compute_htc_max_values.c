/* RESTORES: PARSEINI_ComputeHTCMaxValues
 * MODULE:   modules/groups/b/a/parseini3.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: branch-shape
 *   ref:     2f07700030390000a33a720032390000a33c90812e004a876a0606870000fa00700030390000a340b0876c08200733c00000a34020072e1f4e75
 *   got:     48e72100303900000000720032003039000000007400340092822e014a876a0606870000fa0030390000000072003200b2876c08200733c00000000020074cdf00844e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
extern short Global_WORD_H_VALUE;
extern short Global_WORD_T_VALUE;
extern short Global_WORD_MAX_VALUE;
long PARSEINI_ComputeHTCMaxValues(void)
{
    long delta = (long)(unsigned short)Global_WORD_H_VALUE
               - (long)(unsigned short)Global_WORD_T_VALUE;

    if (delta < 0)
        delta += 64000;
    if ((long)(unsigned short)Global_WORD_MAX_VALUE < delta)
        Global_WORD_MAX_VALUE = (short)delta;
    return delta;
}
