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
 */
extern long TLIBA1_CurrentViewModeIndex;
extern long WDISP_DisplayContextBase;
extern long MATH_DivS32(long a, long b);
extern long TLIBA3_BuildDisplayContextForViewMode(long mode, long a, long b);
extern void TLIBA3_DrawViewModeOverlay(long mode, long a, long b);
void TLIBA3_SelectNextViewMode(void)
{
    long mode = MATH_DivS32(TLIBA1_CurrentViewModeIndex + 1, 9);

    TLIBA1_CurrentViewModeIndex = mode;
    WDISP_DisplayContextBase = TLIBA3_BuildDisplayContextForViewMode(mode, 0, -1);
    TLIBA3_DrawViewModeOverlay(TLIBA1_CurrentViewModeIndex, 0, -1);
}
