/* RESTORES: LOCAVAIL_GetNodeDurationByIndex
 * MODULE:   modules/groups/a/y/locavail.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: epilogue-fragment
 *   ref:     20064cdf08c04e75
 *   got:     2f0d2a6f0008202d00062a5f4e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
struct LocAvailNode2 { char pad[6]; long duration; };
long LOCAVAIL_GetNodeDurationByIndex(struct LocAvailNode2 *n)
{
    return n->duration;
}
