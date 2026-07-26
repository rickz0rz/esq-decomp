/* RESTORES: NEWGRID2_DispatchOperationDefault
 * MODULE:   modules/groups/b/a/newgrid2.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: argument-push-order
 *   ref:     70002f002f0042a72f006100feac4fef00104e75
 *   got:     70002f002f002f002f00610000004fef00104e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
extern void NEWGRID2_DispatchGridOperation(long a, long b, long c, long d);
void NEWGRID2_DispatchOperationDefault(void)
{
    NEWGRID2_DispatchGridOperation(0, 0, 0, 0);
}
