/* RESTORES: DATETIME_IsLeapYear
 * MODULE:   modules/groups/a/j/dst2.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: branch-shape
 *   ref:     48e703002e2f000c0c870000076c6c0606870000076c200772044ebac3cc4a81660c200772644ebac3c04a8166142007223c000001904ebac3b04a8167047000600270012c0020064cdf00c04e75
 *   got:     48e703002e2f000c0c870000076c6c0606870000076c487800042f0761000000504f4a80671a487801902f0761000000504f4a8057c14401488148c12c01602c487800642f0761000000504f4a8067047c016018487801902f0761000000504f4a8057c14401488148c12c0120064cdf00c04e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
extern long GROUP_AG_JMPTBL_MATH_DivS32(long a, long b);
long DATETIME_IsLeapYear(long year)
{
    long leap;

    if (year < 0x76c)
        year += 0x76c;
    if (GROUP_AG_JMPTBL_MATH_DivS32(year, 4) != 0)
        leap = (GROUP_AG_JMPTBL_MATH_DivS32(year, 400) == 0);
    else if (GROUP_AG_JMPTBL_MATH_DivS32(year, 100) != 0)
        leap = 1;
    else
        leap = (GROUP_AG_JMPTBL_MATH_DivS32(year, 400) == 0);
    return leap;
}
