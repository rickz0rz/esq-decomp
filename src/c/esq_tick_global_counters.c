/* RESTORES: ESQ_TickGlobalCounters
 * MODULE:   modules/groups/a/a/app2_p8_esq_tickglobalcounters.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: global-reload-per-store
 *   ref:     30390000c75452400c40546066046100017e33c00000c7544eb900019a1c3039000086ba5240723cb0416600007433c00000a2de30390000b3fc6b00000a534033c00000b3fc30390000bf186b00000a524033c00000bf1830390000a4986b00001a67000016534033c00000a4986600000a33fc0001000028fa41f9000000f822503229000c52413341000c41f9000000fc22503229000c52413341000c700033c0000086ba4a790000a8266700009a30390000010c671e323900000114d2400c4140006d0a33fc00010000011c720033c10000011430390000010e671e323900000116d2400c4140006d0a33fc00010000011e720033c100000116303900000110671e323900000118d2400c4140006d0a33fc000100000120720033c100000118303900000112671e32390000011ad2400c4140006d0a33fc000100000122720033c10000011a4a790000a828670000084eb90001563070004e75
 *   got:     48e707003039000000003e0052470c47546066046100000033c700000000610000003039000000003e005247703cbe406600008033c7000000003c39000000004a466b0a3006534033c0000000003c39000000004a466b0a3006524033c0000000003c39000000004a466b184a466714534633c6000000004a466608700133c0000000002079000000003028000c52402079000000003140000c2079000000003028000c52402079000000003140000c7e0033c700000000303900000000670000a23039000000006720323900000000d2402a010c4540006d0a700133c0000000007a0033c5000000003039000000006720323900000000d2402a010c4540006d0a700133c0000000007a0033c5000000003039000000006720323900000000d2402a010c4540006d0a700133c0000000007a0033c5000000003039000000006720323900000000d2402a010c4540006d0a33fc0001000000007a0033c50000000030390000000067046100000070004cdf00e04e754e71
 *   summary: 376 got vs 348 ref. 6.51 reloads each counter global before storing it back where the original keeps the value in D0 or D1 across the update, which costs six bytes at several of the sixteen sites. CLOCK_DaySlotIndexPtr and its sibling are declared as ARRAYS of pointers, not pointers: the original reaches them with LEA followed by an indirect load, which is the signature data_shape_audit.py uses to say the symbol IS the table. The 0x5460 reboot check, the modulo-60 gate, the three signed guards on the cooldown, refresh and deferred-action counters, both tick-node increments and all four accumulator saturation blocks match in kind and order.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
struct TickNode {
    char  pad0[12];
    short counter;              /* +12 */
};

extern short ESQ_GlobalTickCounter;
extern short ESQ_TickModulo60Counter;
extern short CLEANUP_PendingAlertFlag;
extern short LOCAVAIL_FilterCooldownTicks;
extern short Global_RefreshTickCounter;
extern short TEXTDISP_DeferredActionDelayTicks;
extern short TEXTDISP_DeferredActionArmed;
extern struct TickNode *CLOCK_DaySlotIndexPtr[];
extern struct TickNode *CLOCK_CurrentDayOfWeekIndexPtr[];
extern short WDISP_AccumulatorCaptureActive;
extern short WDISP_AccumulatorFlushPending;
extern short ACCUMULATOR_Row0_CaptureValue, ACCUMULATOR_Row0_Sum, ACCUMULATOR_Row0_SaturateFlag;
extern short ACCUMULATOR_Row1_CaptureValue, ACCUMULATOR_Row1_Sum, ACCUMULATOR_Row1_SaturateFlag;
extern short ACCUMULATOR_Row2_CaptureValue, ACCUMULATOR_Row2_Sum, ACCUMULATOR_Row2_SaturateFlag;
extern short ACCUMULATOR_Row3_CaptureValue, ACCUMULATOR_Row3_Sum, ACCUMULATOR_Row3_SaturateFlag;

extern void ESQ_ColdReboot(void);
extern void ESQSHARED4_TickCopperAndBannerTransitions(void);
extern void ESQIFF_ServicePendingCopperPaletteMoves(void);

long ESQ_TickGlobalCounters(void)
{
    short tick;
    short v;
    short sum;

    tick = ESQ_GlobalTickCounter + 1;
    if (tick == 0x5460)
        ESQ_ColdReboot();
    ESQ_GlobalTickCounter = tick;

    ESQSHARED4_TickCopperAndBannerTransitions();

    tick = ESQ_TickModulo60Counter + 1;
    if (tick == 60) {
        CLEANUP_PendingAlertFlag = tick;

        v = LOCAVAIL_FilterCooldownTicks;
        if (v >= 0)
            LOCAVAIL_FilterCooldownTicks = v - 1;

        v = Global_RefreshTickCounter;
        if (v >= 0)
            Global_RefreshTickCounter = v + 1;

        v = TEXTDISP_DeferredActionDelayTicks;
        if (v >= 0 && v != 0) {
            v--;
            TEXTDISP_DeferredActionDelayTicks = v;
            if (v == 0)
                TEXTDISP_DeferredActionArmed = 1;
        }

        CLOCK_DaySlotIndexPtr[0]->counter =
            CLOCK_DaySlotIndexPtr[0]->counter + 1;
        CLOCK_CurrentDayOfWeekIndexPtr[0]->counter =
            CLOCK_CurrentDayOfWeekIndexPtr[0]->counter + 1;

        tick = 0;
    }
    ESQ_TickModulo60Counter = tick;

    if (WDISP_AccumulatorCaptureActive != 0) {
        if (ACCUMULATOR_Row0_CaptureValue != 0) {
            sum = ACCUMULATOR_Row0_Sum + ACCUMULATOR_Row0_CaptureValue;
            if (sum >= 0x4000) {
                ACCUMULATOR_Row0_SaturateFlag = 1;
                sum = 0;
            }
            ACCUMULATOR_Row0_Sum = sum;
        }
        if (ACCUMULATOR_Row1_CaptureValue != 0) {
            sum = ACCUMULATOR_Row1_Sum + ACCUMULATOR_Row1_CaptureValue;
            if (sum >= 0x4000) {
                ACCUMULATOR_Row1_SaturateFlag = 1;
                sum = 0;
            }
            ACCUMULATOR_Row1_Sum = sum;
        }
        if (ACCUMULATOR_Row2_CaptureValue != 0) {
            sum = ACCUMULATOR_Row2_Sum + ACCUMULATOR_Row2_CaptureValue;
            if (sum >= 0x4000) {
                ACCUMULATOR_Row2_SaturateFlag = 1;
                sum = 0;
            }
            ACCUMULATOR_Row2_Sum = sum;
        }
        if (ACCUMULATOR_Row3_CaptureValue != 0) {
            sum = ACCUMULATOR_Row3_Sum + ACCUMULATOR_Row3_CaptureValue;
            if (sum >= 0x4000) {
                ACCUMULATOR_Row3_SaturateFlag = 1;
                sum = 0;
            }
            ACCUMULATOR_Row3_Sum = sum;
        }
    }

    if (WDISP_AccumulatorFlushPending != 0)
        ESQIFF_ServicePendingCopperPaletteMoves();
    return 0;
}
