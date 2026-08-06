/* RESTORES: ESQIFF2_ApplyIncomingStatusPacket
 * MODULE:   modules/groups/a/o/esqiff2.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: reserved-a5-frame
 *   ref:     48e72310266f00141c39000028e27e007014be406c1041f9000028d0d0c710b37000524760ea4ab900006acc661a1039000028e2bc00671030390000bf106708700123c0000075fe1039000028d97231b00165067248b001630813fc0036000028d94879000081604eba28ae584f4a8066044eba28d2487800014ebacf62584f1039000028d77209b00162067400b0026208740113c2000028d71039000028d8b00162067200b0016208720113c1000028d870001039000028d772001239000028d82f012f004eba27fe504f4a790000a07c67044eba9cfa4ab90000816a662a70001039000028d2723090812e007001be406d0e7208be416e0833c700005e84600833fc000400005e84
 *   got:     594f48e727042a6f001c1e39000000007a007014ba406c1241f900000000d0c5103550001080524560e84ab900000000661a103900000000b00767103039000000006708700123c0000000001c39000000007031bc00650e7048bc00630813fc00360000000048790000000061000000584f4a806604610000004878000161000000584f1c39000000007009bc00620e7200bc016208740113c2000000001c3900000000bc00620e7000bc006208700113c000000000700010390000000072001239000000002f012f0061000000504f3039000000006704610000004ab900000000662c7000103900000000723090813f4000167201b0416d0e7208b0416e0833c000000000600833fc0004000000004cdf20e4584f4e75
 *   summary: 280 got vs 266 ref. The original holds every temporary in a register; 6.51 opens SUBQ.W #4,A7 for one frame slot and spills the scroll-speed value to it before the range test (3f400016 / 7201 b041 where the original compares straight out of D7). The rest is register choice: the loop counter and the latched diagnostic character land in different data registers, which lengthens three short branches. The 20-byte packet copy, both clamp chains on the minute-event bytes, the three-term deferred-mode guard, the banner queue call with its zero test, and the 1..8 scroll-speed window with its 4 fallback all match in kind and order.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
extern unsigned char ED_DiagVinModeChar;
extern unsigned char ESQ_STR_B[];
extern unsigned char ESQ_STR_6;
extern unsigned char ESQ_STR_SATELLITE_DELIVERED_SCROLL_SPEED;
extern unsigned char CLOCK_MinuteEventBaseMinute;
extern unsigned char CLOCK_MinuteEventBaseOffset;
extern long  LOCAVAIL_FilterModeFlag;
extern short SCRIPT_RuntimeMode;
extern long  SCRIPT_RuntimeModeDeferredFlag;
extern short ED_DiagnosticsScreenActive;
extern long  ED_SavedScrollSpeedIndex;
extern short ESQPARS2_StateIndex;
extern char  DST_BannerWindowPrimary;

extern long DST_UpdateBannerQueue(char *window);
extern void DST_RefreshBannerBuffer(void);
extern void ESQDISP_DrawStatusBanner(long highlight);
extern void ESQ_SeedMinuteEventThresholds(long minute, long offset);
extern void ED_DrawDiagnosticModeText(void);

/* Set by this function's EPILOGUE in the original, and every 'C' group record
 * is discarded until it is 1. See the note at the end of the body. */
extern short ESQIFF_StatusPacketReadyFlag;

void ESQIFF2_ApplyIncomingStatusPacket(char *packet)
{
    unsigned char was;
    unsigned char c;
    short i;
    short speed;

    was = ED_DiagVinModeChar;
    for (i = 0; i < 20; i++)
        ESQ_STR_B[i] = packet[i];

    if (LOCAVAIL_FilterModeFlag == 0 && ED_DiagVinModeChar != was
        && SCRIPT_RuntimeMode != 0)
        SCRIPT_RuntimeModeDeferredFlag = 1;

    c = ESQ_STR_6;
    if (c >= 49 && c > 72)
        ESQ_STR_6 = '6';

    if (DST_UpdateBannerQueue(&DST_BannerWindowPrimary) == 0)
        DST_RefreshBannerBuffer();
    ESQDISP_DrawStatusBanner(1);

    c = CLOCK_MinuteEventBaseMinute;
    if (c <= 9 && !(c > 0))
        CLOCK_MinuteEventBaseMinute = 1;
    c = CLOCK_MinuteEventBaseOffset;
    if (c <= 9 && !(c > 0))
        CLOCK_MinuteEventBaseOffset = 1;

    ESQ_SeedMinuteEventThresholds(
        (long)CLOCK_MinuteEventBaseMinute, (long)CLOCK_MinuteEventBaseOffset);

    if (ED_DiagnosticsScreenActive != 0)
        ED_DrawDiagnosticModeText();

    if (ED_SavedScrollSpeedIndex == 0) {
        speed = ESQ_STR_SATELLITE_DELIVERED_SCROLL_SPEED - 48;
        if (speed >= 1 && speed <= 8)
            ESQPARS2_StateIndex = speed;
        else
            ESQPARS2_StateIndex = 4;
    }

    /* THE ORIGINAL'S SHARED EPILOGUE, AND IT IS NOT DECORATION. Every exit
     * from this function goes through ESQIFF2_ApplyIncomingStatusPacket_Return,
     * which is `MOVE.W #1,_ESQIFF_StatusPacketReadyFlag` followed by the MOVEM
     * and RTS -- two BRA/BNE sites plus the fall-through. The early return above
     * became an `if` so that both paths reach this line, exactly as both branch
     * targets reach the epilogue.
     *
     * WITHOUT THIS THE PROGRAM RECEIVES NO LISTINGS AT ALL. The dispatcher's
     * 'C' arm reads each group record and then drops it unless this flag is 1:
     *
     *     else if (ESQIFF_StatusPacketReadyFlag == 1)
     *         ESQIFF2_ParseGroupRecordAndRefresh(...);
     *
     * so the channel line-up is silently discarded, the 'P' program records
     * have no group to land in, and curday.dat is written with its 42-byte
     * header and nothing else. */
    ESQIFF_StatusPacketReadyFlag = 1;
}
