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
 *
 * CORRECTED 2026-07-27, and this class is why the whole-program C build
 * reset the machine. MATH_DivS32/MATH_DivU32/MATH_Mulu32 are REGISTER-argument
 * helpers: dividend in D0, divisor in D1, quotient back in D0 and REMAINDER in
 * D1. This file declared one as an ordinary C function and called it with stack
 * arguments the helper never reads, so it divided by whatever happened to be in
 * D1 -- a divide by zero away from an exception. Several of these also took the
 * QUOTIENT where the original uses the REMAINDER.
 *
 * Written with C operators instead. That costs the byte match (SAS/C calls its
 * own __CXD33) but it is the only correct form: the remainder cannot be reached
 * through a C return value at all.
 */
long DATETIME_IsLeapYear(long year)
{
    long leap;

    if (year < 0x76c)
        year += 0x76c;
    if ((year - (year / 4) * 4) != 0)
        leap = ((year - (year / 400) * 400) == 0);
    else if ((year - (year / 100) * 100) != 0)
        leap = 1;
    else
        leap = ((year - (year / 400) * 400) == 0);
    return leap;
}
