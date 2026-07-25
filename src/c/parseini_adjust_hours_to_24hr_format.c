/* RESTORES: PARSEINI_AdjustHoursTo24HrFormat
 * MODULE:   modules/groups/b/a/parseini2.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: branch-shape
 *   ref:     48e703003e2f000e3c2f0012700cbe4066084a4666047e00600ebe406c0a72ffbc4166040647000c200748c04cdf00c04e75
 *   got:     48e703003c2f00123e2f000e700cbe4066084a4666047e00600ebe406c0a2206524166040647000c300748c04cdf00c04e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
long PARSEINI_AdjustHoursTo24HrFormat(short hour, short meridiem)
{
    if (hour == 12 && meridiem == 0)
        hour = 0;
    else if (hour < 12 && meridiem == -1)
        hour += 12;
    return hour;
}
