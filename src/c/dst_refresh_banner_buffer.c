/* RESTORES: DST_RefreshBannerBuffer
 * MODULE:   modules/groups/a/j/dst2.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: dbf-loop
 *   ref:     2f076100feba3e390000a32041f900009aa243f90000a312700422d851c8fffc329033c70000a32030390000a2c448c072001239000028e348c12f012f0048790000a3126100feb84fef000c2e1f4e75
 *   got:     48e70300610000003e39000000007c007005bc406c1c48c62006e58041f900000000d1c043f900000000d3c02091524660de33f9000000140000001433c70000000030390000000048c072001239000000002f012f00487900000000610000004fef000c4cdf00c04e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
extern short DST_SecondaryCountdown, WDISP_BannerCharPhaseShift;
extern long  CLOCK_DaySlotIndex[], CLOCK_CurrentDayOfWeekIndex[];
extern unsigned char CLOCK_FormatVariantCode;
extern void  DST_TickBannerCounters(void);
extern void  DST_AddTimeOffset(long *rec, long a, long b);
void DST_RefreshBannerBuffer(void)
{
    short saved;
    short i;

    DST_TickBannerCounters();
    saved = DST_SecondaryCountdown;
    for (i = 0; i < 5; i++)
        CLOCK_CurrentDayOfWeekIndex[i] = CLOCK_DaySlotIndex[i];
    *(short *)&CLOCK_CurrentDayOfWeekIndex[5] = *(short *)&CLOCK_DaySlotIndex[5];
    DST_SecondaryCountdown = saved;
    DST_AddTimeOffset(CLOCK_CurrentDayOfWeekIndex,
                      (long)WDISP_BannerCharPhaseShift,
                      (long)CLOCK_FormatVariantCode);
}
