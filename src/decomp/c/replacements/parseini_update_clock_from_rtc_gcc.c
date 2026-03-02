#include "esq_types.h"

extern void *Global_REF_UTILITY_LIBRARY;
extern void *Global_REF_BATTCLOCK_RESOURCE;
extern s16 CLOCK_DaySlotIndex;
extern s16 DST_PrimaryCountdown;
extern const void *PARSEINI_FallbackClockDataRecord;

s32 PARSEINI2_JMPTBL_BATTCLOCK_GetSecondsFromBatteryBackedClock(void) __attribute__((noinline));
void PARSEINI2_JMPTBL_CLOCK_ConvertAmigaSecondsToClockData(s32 seconds, void *clock_data) __attribute__((noinline));
s32 PARSEINI2_JMPTBL_CLOCK_CheckDateOrSecondsFromEpoch(void *clock_data) __attribute__((noinline));
s32 PARSEINI_NormalizeClockData(void *dst, const void *src) __attribute__((noinline));

typedef struct ClockDataRtc563 {
    u16 sec;
    u16 min;
    u16 hour;
    u16 mday;
    u16 month;
    u16 year;
    u16 wday;
} ClockDataRtc563;

typedef struct LocalClock563 {
    s16 wday;
    s16 month;
    s16 mday;
    s16 year;
    s16 hour;
    s16 min;
    s16 sec;
} LocalClock563;

s32 PARSEINI_UpdateClockFromRtc(void) __attribute__((noinline, used));

s32 PARSEINI_UpdateClockFromRtc(void)
{
    s32 seconds;
    ClockDataRtc563 clock_data;
    LocalClock563 local;
    s16 month_raw;
    s16 mday_raw;
    volatile s16 dst_countdown_shadow;

    if (Global_REF_UTILITY_LIBRARY == 0) {
        return 0;
    }
    if (Global_REF_BATTCLOCK_RESOURCE == 0) {
        return 0;
    }

    seconds = PARSEINI2_JMPTBL_BATTCLOCK_GetSecondsFromBatteryBackedClock();
    PARSEINI2_JMPTBL_CLOCK_ConvertAmigaSecondsToClockData(seconds, &clock_data);
    if (PARSEINI2_JMPTBL_CLOCK_CheckDateOrSecondsFromEpoch(&clock_data) == 0) {
        PARSEINI_NormalizeClockData(&CLOCK_DaySlotIndex, PARSEINI_FallbackClockDataRecord);
        return 0;
    }

    local.wday = (s16)clock_data.wday;
    month_raw = (s16)clock_data.month;
    local.month = (s16)(month_raw - 1);
    mday_raw = (s16)clock_data.mday;
    local.mday = (s16)(mday_raw - 1);
    local.year = (s16)clock_data.year;
    local.hour = (s16)clock_data.hour;
    local.min = (s16)clock_data.min;
    local.sec = (s16)clock_data.sec;

    dst_countdown_shadow = DST_PrimaryCountdown;
    (void)dst_countdown_shadow;

    if (local.wday < 0 || local.wday > 6 ||
        month_raw < 0 || month_raw > 11 ||
        mday_raw < 0 || mday_raw > 31 ||
        local.year < 0 || local.year > 9999 ||
        local.hour < 0 || local.hour > 23 ||
        local.min < 0 || local.min > 59 ||
        local.sec < 0 || local.sec > 59) {
        PARSEINI_NormalizeClockData(&CLOCK_DaySlotIndex, &local);
        return 0;
    }

    PARSEINI_NormalizeClockData(&CLOCK_DaySlotIndex, &local);
    return 0;
}
