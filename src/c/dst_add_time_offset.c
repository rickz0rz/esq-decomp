/* RESTORES: DST_AddTimeOffset
 * MODULE:   modules/groups/a/j/dst2.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: argument-push-order
 *   ref:     48e70710266f00143e2f001a3c2f001e2f0b6100f1a8584f2a002007c1fc0e102206c3fc003cd081da802f0b2f056100f02e504f4cdf08e04e75
 *   got:     48e707043c2f001e3e2f001a2a6f00142f0d610000002a0048c72007e98090872200e9819280e98148c62006e9809086e580d280da812e8d2f0561000000504f4cdf20e04e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
struct DstRec { char pad; };
extern long DATETIME_NormalizeStructToSeconds(struct DstRec *d);
extern void DATETIME_SecondsToStruct(long secs, struct DstRec *d);
void DST_AddTimeOffset(struct DstRec *d, short hours, short minutes)
{
    long secs = DATETIME_NormalizeStructToSeconds(d);

    secs += (long)hours * 0xe10 + (long)minutes * 0x3c;
    DATETIME_SecondsToStruct(secs, d);
}
