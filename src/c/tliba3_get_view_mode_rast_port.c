/* RESTORES: TLIBA3_GetViewModeRastPort
 * MODULE:   modules/groups/b/a/tliba3.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: external-call-width
 *   ref:     2f072e2f00082007724dd2814eba306c41f90000cdbcd1c043e8000a20092e1f4e75
 *   got:     2f072e2f00084878009a2f076100000041f900000000d1c043e8000a504f20092e1f4e75
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
extern char TLIBA3_VmArrayRuntimeTable[];
char *TLIBA3_GetViewModeRastPort(long index)
{
    return TLIBA3_VmArrayRuntimeTable + index * 154 + 10;
}
