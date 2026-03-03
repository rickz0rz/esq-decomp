#include "esq_types.h"

extern s16 ESQ_GlobalTickCounter;
extern s16 ESQ_TickModulo60Counter;
extern s16 CLEANUP_PendingAlertFlag;
extern s16 LOCAVAIL_FilterCooldownTicks;
extern s16 Global_RefreshTickCounter;
extern s16 TEXTDISP_DeferredActionDelayTicks;
extern s16 TEXTDISP_DeferredActionArmed;
extern u8 *CLOCK_DaySlotIndexPtr;
extern u8 *CLOCK_CurrentDayOfWeekIndexPtr;
extern s16 WDISP_AccumulatorCaptureActive;
extern s16 WDISP_AccumulatorFlushPending;

extern s16 ACCUMULATOR_Row0_CaptureValue;
extern s16 ACCUMULATOR_Row0_Sum;
extern s16 ACCUMULATOR_Row0_SaturateFlag;
extern s16 ACCUMULATOR_Row1_CaptureValue;
extern s16 ACCUMULATOR_Row1_Sum;
extern s16 ACCUMULATOR_Row1_SaturateFlag;
extern s16 ACCUMULATOR_Row2_CaptureValue;
extern s16 ACCUMULATOR_Row2_Sum;
extern s16 ACCUMULATOR_Row2_SaturateFlag;
extern s16 ACCUMULATOR_Row3_CaptureValue;
extern s16 ACCUMULATOR_Row3_Sum;
extern s16 ACCUMULATOR_Row3_SaturateFlag;

void ESQ_ColdReboot(void) __attribute__((noinline));
void ESQSHARED4_TickCopperAndBannerTransitions(void) __attribute__((noinline));
void ESQIFF_ServicePendingCopperPaletteMoves(void) __attribute__((noinline));

static void ESQ_AccumulateRow(s16 value, s16 *sum, s16 *saturate_flag)
{
    s16 next;

    if (value == 0) {
        return;
    }

    next = (s16)(*sum + value);
    if (next >= (s16)0x4000) {
        *saturate_flag = 1;
        next = 0;
    }
    *sum = next;
}

void ESQ_TickGlobalCounters(void) __attribute__((noinline, used));

void ESQ_TickGlobalCounters(void)
{
    s16 tick;

    tick = (s16)(ESQ_GlobalTickCounter + 1);
    if (tick == (s16)0x5460) {
        ESQ_ColdReboot();
    }

    ESQ_GlobalTickCounter = tick;
    ESQSHARED4_TickCopperAndBannerTransitions();

    tick = (s16)(ESQ_TickModulo60Counter + 1);
    if (tick == 60) {
        CLEANUP_PendingAlertFlag = tick;

        if (LOCAVAIL_FilterCooldownTicks >= 0) {
            LOCAVAIL_FilterCooldownTicks = (s16)(LOCAVAIL_FilterCooldownTicks - 1);
        }

        if (Global_RefreshTickCounter >= 0) {
            Global_RefreshTickCounter = (s16)(Global_RefreshTickCounter + 1);
        }

        if (TEXTDISP_DeferredActionDelayTicks > 0) {
            TEXTDISP_DeferredActionDelayTicks = (s16)(TEXTDISP_DeferredActionDelayTicks - 1);
            if (TEXTDISP_DeferredActionDelayTicks == 0) {
                TEXTDISP_DeferredActionArmed = 1;
            }
        }

        *(s16 *)(CLOCK_DaySlotIndexPtr + 12) = (s16)(*(s16 *)(CLOCK_DaySlotIndexPtr + 12) + 1);
        *(s16 *)(CLOCK_CurrentDayOfWeekIndexPtr + 12) = (s16)(*(s16 *)(CLOCK_CurrentDayOfWeekIndexPtr + 12) + 1);
        tick = 0;
    }

    ESQ_TickModulo60Counter = tick;

    if (WDISP_AccumulatorCaptureActive != 0) {
        ESQ_AccumulateRow(ACCUMULATOR_Row0_CaptureValue, &ACCUMULATOR_Row0_Sum, &ACCUMULATOR_Row0_SaturateFlag);
        ESQ_AccumulateRow(ACCUMULATOR_Row1_CaptureValue, &ACCUMULATOR_Row1_Sum, &ACCUMULATOR_Row1_SaturateFlag);
        ESQ_AccumulateRow(ACCUMULATOR_Row2_CaptureValue, &ACCUMULATOR_Row2_Sum, &ACCUMULATOR_Row2_SaturateFlag);
        ESQ_AccumulateRow(ACCUMULATOR_Row3_CaptureValue, &ACCUMULATOR_Row3_Sum, &ACCUMULATOR_Row3_SaturateFlag);
    }

    if (WDISP_AccumulatorFlushPending != 0) {
        ESQIFF_ServicePendingCopperPaletteMoves();
    }
}
