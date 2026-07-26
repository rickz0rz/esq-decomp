/* RESTORES: DST_FreeBannerPair
 * MODULE:   modules/groups/a/j/dst.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: argument-slot-reuse
 *   ref:     2f0b266f00082f13619442932eab0004618c584f42ab0004265f4e75
 *   got:     2f0d2a6f00082f156100000042952ead00046100000042ad0004584f2a5f4e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
struct DstBannerPair { void *a; void *b; };
extern void DST_FreeBannerStruct(void *p);
void DST_FreeBannerPair(struct DstBannerPair *pair)
{
    DST_FreeBannerStruct(pair->a);
    pair->a = 0;
    DST_FreeBannerStruct(pair->b);
    pair->b = 0;
}
