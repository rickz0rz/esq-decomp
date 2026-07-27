/* RESTORES: TLIBA3_GetViewModeHeight
 * MODULE:   modules/groups/b/a/tliba3.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: trailing-dead-bytes
 *   ref:     2f072e2f00082007724dd2814eba30e041f90000cdbcd1c0302800042e1f4e752f072e2f00082007724dd2814eba30c041f90000cdbcd1c0302800022e1f4e75
 *   got:     48e701042e2f000c4878009a2f076100000041f900000000d1c02a48302d000448c0504f4cdf20804e75
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
struct VmEntry { short a; short b; short h; };
extern char TLIBA3_VmArrayRuntimeTable[];
long TLIBA3_GetViewModeHeight(long mode)
{
    struct VmEntry *e = (struct VmEntry *)(TLIBA3_VmArrayRuntimeTable + mode * 154);
    return e->h;
}
