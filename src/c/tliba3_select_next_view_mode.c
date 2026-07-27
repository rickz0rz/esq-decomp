/* RESTORES: TLIBA3_SelectNextViewMode
 * MODULE:   modules/groups/b/a/tliba3.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: argument-push-order
 *   ref:     203900007824528072094eba2de223c1000078244878ffff42a72f016100fd5823c0000086fe2eb9000078246100fba24fef000c4e75
 *   got:     2f072039000000005280487800092f00610000002e0023c7000000004878ffff42a72f076100000023c0000000004878ffff42a72f3900000000610000004fef00202e1f4e75
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
extern long TLIBA1_CurrentViewModeIndex;
extern long WDISP_DisplayContextBase;
extern long TLIBA3_BuildDisplayContextForViewMode(long mode, long a, long b);
extern void TLIBA3_DrawViewModeOverlay(long mode, long a, long b);
void TLIBA3_SelectNextViewMode(void)
{
    long mode = (TLIBA1_CurrentViewModeIndex + 1) % 9;

    TLIBA1_CurrentViewModeIndex = mode;
    WDISP_DisplayContextBase = TLIBA3_BuildDisplayContextForViewMode(mode, 0, -1);
    TLIBA3_DrawViewModeOverlay(TLIBA1_CurrentViewModeIndex, 0, -1);
}
