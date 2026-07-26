/* RESTORES: GCOMMAND_ResetBannerFadeState
 * MODULE:   modules/groups/a/u/gcommand3b.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: argument-push-order
 *   ref:     4a79000068fc67304279000068fc42a72f3c000080fe487800806100fefa4fef000c7040d08023c00000b30e06800000026423c00000b3164e75
 *   got:     2f07303900000000673042790000000042a72f3c000080fe48780080610000004fef000c7e40de8723c70000000006870000026423c7000000002e1f4e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
extern short GCOMMAND_BannerFadeResetPendingFlag;
extern long  ESQSHARED4_InterleaveCopyBaseOffset;
extern long  ESQSHARED4_InterleaveCopyTailOffsetReset;
extern void  GCOMMAND_BuildBannerTables(long a, long b, long c);
void GCOMMAND_ResetBannerFadeState(void)
{
    long base;

    if (GCOMMAND_BannerFadeResetPendingFlag == 0)
        return;
    GCOMMAND_BannerFadeResetPendingFlag = 0;
    GCOMMAND_BuildBannerTables(128, 0x80fe, 0);
    base = 64 + 64;
    ESQSHARED4_InterleaveCopyBaseOffset = base;
    base += 0x264;
    ESQSHARED4_InterleaveCopyTailOffsetReset = base;
}
