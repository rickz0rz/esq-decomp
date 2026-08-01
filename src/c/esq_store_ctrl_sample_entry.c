/* RESTORES: ESQ_StoreCtrlSampleEntry
 * MODULE:   modules/groups/a/a/app2_esq_storectrlsampleentry.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: scratch-register-locals
 *   ref:     48e7c0c041f90000b35820390000b3503200c3fc0005d0c143f9000000f010d966fc52807214b0816d02700023c00000b3504cdf03034e75
 *   got:     48e701142e3900000000200748c02200e581d28041f900000000d1c12a4847f900000000204d528d101b10804a0066f452877014be806d027e0023c7000000004cdf28804e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 *
 * LINKABLE SINCE 2026-08-01, and the header that used to sit here was wrong on
 * both of its counts.
 *
 * It said the function "takes its arguments in registers". It takes NO arguments
 * at all -- it is `void f(void)`. What the entry MOVEM does is PRESERVE D0/D1/A0/A1,
 * the scratch registers, as a courtesy to an ASSEMBLY caller that expected them
 * to survive. coverage.py screens that shape as `register-args` and here that is
 * a false positive.
 *
 * It also said the function runs in interrupt context, which is true and is not
 * a reason to keep it in assembly. Its ONLY caller is ESQ_CaptureCtrlBit3Stream,
 * which is already C and already running in that same interrupt path -- the one
 * remaining assembly link in the chain is ESQ_PollCtrlInput above it. A C caller
 * does not expect D0/D1/A0/A1 to survive a call, so the courtesy the MOVEM
 * provides is no longer needed by anybody. This function touches no library and
 * only copies bytes into a table, so it is safe where it runs.
 *
 * The general rule, again: a register-convention blocker describes the ORIGINAL's
 * contract with ITS callers, and it stops being a blocker when every one of them
 * becomes C.
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
