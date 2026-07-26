/* RESTORES: DST_RebuildBannerPair
 * MODULE:   modules/groups/a/j/dst.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: argument-slot-reuse
 *   ref:     48e70110266f000c7e002f0b6100ff442e936100ff5a584f26804a8067142f2b00046100ff4a584f274000044a9367027e014a4766082f0b6100ff18584f20074cdf08804e75
 *   got:     48e701042a6f000c7e002f0d610000002e95610000002a80584f67142f2d0004610000002b400004584f4a9567027e0120074a4066082f0d61000000584f20074cdf20804e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
struct DstPair { void *a; void *b; };
extern void  DST_FreeBannerPair(struct DstPair *p);
extern void *DST_AllocateBannerStruct(void *old);
long DST_RebuildBannerPair(struct DstPair *p)
{
    long ok = 0;

    DST_FreeBannerPair(p);
    p->a = DST_AllocateBannerStruct(p->a);
    if (p->a != 0) {
        p->b = DST_AllocateBannerStruct(p->b);
        if (p->a != 0)
            ok = 1;
    }
    if ((short)ok == 0)
        DST_FreeBannerPair(p);
    return ok;
}
