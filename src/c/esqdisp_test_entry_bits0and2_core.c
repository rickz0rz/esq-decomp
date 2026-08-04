/* RESTORES: ESQDISP_TestEntryBits0And2_Core
 * MODULE:   modules/groups/a/n/esqdispb_p0_esqdisp_testentrybits0and2_core.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: register-allocation-order
 *   ref:     48e70110266f000c7e00200b6718082b00000028670c082b0002002867047001600270002e0020074cdf08804e75
 *   got:     48e701042a6f000c7e00200d6716082d00000028670c082d0002002867047e0160027e0020074cdf20804e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
#ifndef ESQDISPENTRY_DEFINED
#define ESQDISPENTRY_DEFINED
struct EsqDispEntry {
    char pad[40];
    unsigned char flags;
};
#endif
long ESQDISP_TestEntryBits0And2_Core(struct EsqDispEntry *e)
{
    long r = 0;

    if (e != 0) {
        if ((e->flags & 1) && (e->flags & 4))
            r = 1;
        else
            r = 0;
    }
    return r;
}
