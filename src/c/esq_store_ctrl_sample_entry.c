/* RESTORES: ESQ_StoreCtrlSampleEntry
 * MODULE:   modules/groups/a/a/app2.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: scratch-register-locals
 *   ref:     48e7c0c041f90000b35820390000b3503200c3fc0005d0c143f9000000f010d966fc52807214b0816d02700023c00000b3504cdf03034e75
 *   got:     48e701142e3900000000200748c02200e581d28041f900000000d1c12a4847f900000000204d528d101b10804a0066f452877014be806d027e0023c7000000004cdf28804e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
extern char ED_StateRingTable[];
extern long ED_StateRingWriteIndex;
extern char CTRL_SampleEntryScratch[];
void ESQ_StoreCtrlSampleEntry(void)
{
    long  idx = ED_StateRingWriteIndex;
    char *d = ED_StateRingTable + (short)idx * 5;
    char *s = CTRL_SampleEntryScratch;

    while ((*d++ = *s++) != 0)
        ;
    idx++;
    if (idx >= 20)
        idx = 0;
    ED_StateRingWriteIndex = idx;
}
