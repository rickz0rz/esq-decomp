extern short ESQ_GlobalTickCounter;
extern short ESQ_TickModulo60Counter;
extern short CLEANUP_PendingAlertFlag;
extern short LOCAVAIL_FilterCooldownTicks;
extern short Global_RefreshTickCounter;
extern short TEXTDISP_DeferredActionDelayTicks;
extern short TEXTDISP_DeferredActionArmed;
extern unsigned char *CLOCK_DaySlotIndexPtr;
extern unsigned char *CLOCK_CurrentDayOfWeekIndexPtr;
extern short WDISP_AccumulatorCaptureActive;
extern short WDISP_AccumulatorFlushPending;

extern short ACCUMULATOR_Row0_CaptureValue;
extern short ACCUMULATOR_Row0_Sum;
extern short ACCUMULATOR_Row0_SaturateFlag;
extern short ACCUMULATOR_Row1_CaptureValue;
extern short ACCUMULATOR_Row1_Sum;
extern short ACCUMULATOR_Row1_SaturateFlag;
extern short ACCUMULATOR_Row2_CaptureValue;
extern short ACCUMULATOR_Row2_Sum;
extern short ACCUMULATOR_Row2_SaturateFlag;
extern short ACCUMULATOR_Row3_CaptureValue;
extern short ACCUMULATOR_Row3_Sum;
extern short ACCUMULATOR_Row3_SaturateFlag;

extern void ESQ_ColdReboot(void);
extern void ESQSHARED4_TickCopperAndBannerTransitions(void);
extern void ESQIFF_ServicePendingCopperPaletteMoves(void);

void ESQ_TickGlobalCounters(void)
{
    short tick;
    short next;

    tick = (short)(ESQ_GlobalTickCounter + 1);
    if (tick == (short)0x5460) {
        ESQ_ColdReboot();
    }

    ESQ_GlobalTickCounter = tick;
    ESQSHARED4_TickCopperAndBannerTransitions();

    tick = (short)(ESQ_TickModulo60Counter + 1);
    if (tick == 60) {
        CLEANUP_PendingAlertFlag = tick;

        if (LOCAVAIL_FilterCooldownTicks >= 0) {
            LOCAVAIL_FilterCooldownTicks = (short)(LOCAVAIL_FilterCooldownTicks - 1);
        }

        if (Global_RefreshTickCounter >= 0) {
            Global_RefreshTickCounter = (short)(Global_RefreshTickCounter + 1);
        }

        if (TEXTDISP_DeferredActionDelayTicks > 0) {
            TEXTDISP_DeferredActionDelayTicks = (short)(TEXTDISP_DeferredActionDelayTicks - 1);
            if (TEXTDISP_DeferredActionDelayTicks == 0) {
                TEXTDISP_DeferredActionArmed = 1;
            }
        }

        *(short *)(CLOCK_DaySlotIndexPtr + 12) = (short)(*(short *)(CLOCK_DaySlotIndexPtr + 12) + 1);
        *(short *)(CLOCK_CurrentDayOfWeekIndexPtr + 12) = (short)(*(short *)(CLOCK_CurrentDayOfWeekIndexPtr + 12) + 1);
        tick = 0;
    }

    ESQ_TickModulo60Counter = tick;

    if (WDISP_AccumulatorCaptureActive != 0) {
        if (ACCUMULATOR_Row0_CaptureValue != 0) {
            next = (short)(ACCUMULATOR_Row0_Sum + ACCUMULATOR_Row0_CaptureValue);
            if (next >= (short)0x4000) {
                ACCUMULATOR_Row0_SaturateFlag = 1;
                next = 0;
            }
            ACCUMULATOR_Row0_Sum = next;
        }

        if (ACCUMULATOR_Row1_CaptureValue != 0) {
            next = (short)(ACCUMULATOR_Row1_Sum + ACCUMULATOR_Row1_CaptureValue);
            if (next >= (short)0x4000) {
                ACCUMULATOR_Row1_SaturateFlag = 1;
                next = 0;
            }
            ACCUMULATOR_Row1_Sum = next;
        }

        if (ACCUMULATOR_Row2_CaptureValue != 0) {
            next = (short)(ACCUMULATOR_Row2_Sum + ACCUMULATOR_Row2_CaptureValue);
            if (next >= (short)0x4000) {
                ACCUMULATOR_Row2_SaturateFlag = 1;
                next = 0;
            }
            ACCUMULATOR_Row2_Sum = next;
        }

        if (ACCUMULATOR_Row3_CaptureValue != 0) {
            next = (short)(ACCUMULATOR_Row3_Sum + ACCUMULATOR_Row3_CaptureValue);
            if (next >= (short)0x4000) {
                ACCUMULATOR_Row3_SaturateFlag = 1;
                next = 0;
            }
            ACCUMULATOR_Row3_Sum = next;
        }
    }

    if (WDISP_AccumulatorFlushPending != 0) {
        ESQIFF_ServicePendingCopperPaletteMoves();
    }
}
