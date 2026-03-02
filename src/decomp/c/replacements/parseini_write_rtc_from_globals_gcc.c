#include "esq_types.h"

extern void *Global_REF_UTILITY_LIBRARY;
extern void *Global_REF_BATTCLOCK_RESOURCE;
extern s16 CLOCK_DaySlotIndex;
extern s16 CLOCK_CacheMonthIndex0;
extern s16 CLOCK_CacheDayIndex0;
extern s16 CLOCK_CacheYear;
extern s16 CLOCK_CacheHour;
extern s16 CLOCK_CacheAmPmFlag;
extern s16 CLOCK_CacheMinuteOrSecond;
extern s16 Global_REF_CLOCKDATA_STRUCT;

s32 PARSEINI_AdjustHoursTo24HrFormat(s32 hour, s32 ampm_flag) __attribute__((noinline));
s32 PARSEINI2_JMPTBL_CLOCK_CheckDateOrSecondsFromEpoch(void *clock_data) __attribute__((noinline));
s32 PARSEINI2_JMPTBL_CLOCK_SecondsFromEpoch(void *clock_data) __attribute__((noinline));
void PARSEINI2_JMPTBL_BATTCLOCK_WriteSecondsToBatteryBackedClock(s32 seconds) __attribute__((noinline));

typedef struct ClockPack561 {
    u16 sec;
    u16 min;
    u16 hour;
    u16 mday;
    u16 month;
    u16 year;
    u16 wday;
} ClockPack561;

s32 PARSEINI_WriteRtcFromGlobals(void) __attribute__((noinline, used));

s32 PARSEINI_WriteRtcFromGlobals(void)
{
    ClockPack561 clock_data;
    s32 seconds;

    if (Global_REF_UTILITY_LIBRARY == 0) {
        return 0;
    }
    if (Global_REF_BATTCLOCK_RESOURCE == 0) {
        return 0;
    }

    clock_data.wday = (u16)CLOCK_DaySlotIndex;
    clock_data.month = (u16)(CLOCK_CacheMonthIndex0 + 1);
    clock_data.mday = (u16)CLOCK_CacheDayIndex0;
    clock_data.year = (u16)CLOCK_CacheYear;
    clock_data.hour = (u16)PARSEINI_AdjustHoursTo24HrFormat((s32)CLOCK_CacheHour, (s32)CLOCK_CacheAmPmFlag);
    clock_data.min = (u16)CLOCK_CacheMinuteOrSecond;
    clock_data.sec = (u16)Global_REF_CLOCKDATA_STRUCT;

    if (PARSEINI2_JMPTBL_CLOCK_CheckDateOrSecondsFromEpoch(&clock_data) == 0) {
        return 0;
    }

    seconds = PARSEINI2_JMPTBL_CLOCK_SecondsFromEpoch(&clock_data);
    PARSEINI2_JMPTBL_BATTCLOCK_WriteSecondsToBatteryBackedClock(seconds);
    return 0;
}
