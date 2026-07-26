/* RESTORES: TLIBA2_ResolveEntryWindowWithDefaultRange
 * MODULE:   modules/groups/b/a/tliba2.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: argument-push-order
 *   ref:     48e70130266f0010246f00142e2f001842a742a72f072f0a2f0b6100fe044fef00144cdf0c804e75
 *   got:     48e701142e2f0018266f00142a6f001070002f002f002f072f0b2f0d610000004fef00144cdf28804e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
extern void TLIBA2_ResolveEntryWindowAndSlotCount(void *a, void *b, long c, long d, long e);
void TLIBA2_ResolveEntryWindowWithDefaultRange(void *a, void *b, long c)
{
    TLIBA2_ResolveEntryWindowAndSlotCount(a, b, c, 0, 0);
}
