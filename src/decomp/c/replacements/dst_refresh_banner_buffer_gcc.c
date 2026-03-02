#include "esq_types.h"

/*
 * Target 621 GCC trial function.
 * Refresh staging banner buffer from queue state and apply time offset.
 */
typedef struct DST_ClockState {
    u32 l0;
    u32 l4;
    u32 l8;
    u32 l12;
    u32 l16;
    u16 w20;
} DST_ClockState;

extern DST_ClockState CLOCK_DaySlotIndex;
extern DST_ClockState CLOCK_CurrentDayOfWeekIndex;
extern s16 DST_SecondaryCountdown;
extern s16 WDISP_BannerCharPhaseShift;
extern u8 CLOCK_FormatVariantCode;

void DST_TickBannerCounters(void) __attribute__((noinline));
void DST_AddTimeOffset(void *clock_state, s32 a, s32 b) __attribute__((noinline));

void DST_RefreshBannerBuffer(void) __attribute__((noinline, used));

void DST_RefreshBannerBuffer(void)
{
    s16 secondary;

    DST_TickBannerCounters();

    secondary = DST_SecondaryCountdown;
    CLOCK_CurrentDayOfWeekIndex = CLOCK_DaySlotIndex;
    DST_SecondaryCountdown = secondary;

    DST_AddTimeOffset(
        &CLOCK_CurrentDayOfWeekIndex,
        (s32)WDISP_BannerCharPhaseShift,
        (s32)CLOCK_FormatVariantCode
    );
}
