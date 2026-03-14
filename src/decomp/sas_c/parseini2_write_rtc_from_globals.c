#include <exec/types.h>
struct ClockData {
    WORD sec;
    WORD min;
    WORD hour;
    WORD mday;
    WORD month;
    WORD year;
    WORD wday;
};

extern void *Global_REF_UTILITY_LIBRARY;
extern void *Global_REF_BATTCLOCK_RESOURCE;

extern WORD CLOCK_DaySlotIndex;
extern WORD CLOCK_CacheMonthIndex0;
extern WORD CLOCK_CacheDayIndex0;
extern WORD CLOCK_CacheYear;
extern WORD CLOCK_CacheHour;
extern WORD CLOCK_CacheAmPmFlag;
extern WORD CLOCK_CacheMinuteOrSecond;
extern WORD Global_REF_CLOCKDATA_STRUCT;

extern LONG PARSEINI_AdjustHoursTo24HrFormat(WORD hour, WORD amPmFlag);
extern LONG CLOCK_CheckDateOrSecondsFromEpoch(struct ClockData *clockData);
extern LONG CLOCK_SecondsFromEpoch(struct ClockData *clockData);
extern void BATTCLOCK_WriteSecondsToBatteryBackedClock(LONG seconds);

void PARSEINI_WriteRtcFromGlobals(void)
{
    struct ClockData clockData;
    LONG seconds;
    WORD month;

    if (Global_REF_UTILITY_LIBRARY == 0) {
        return;
    }
    if (Global_REF_BATTCLOCK_RESOURCE == 0) {
        return;
    }

    clockData.wday = CLOCK_DaySlotIndex;
    month = CLOCK_CacheMonthIndex0;
    ++month;
    clockData.month = month;
    clockData.mday = CLOCK_CacheDayIndex0;
    clockData.year = CLOCK_CacheYear;
    clockData.hour = (WORD)PARSEINI_AdjustHoursTo24HrFormat(CLOCK_CacheHour, CLOCK_CacheAmPmFlag);
    clockData.min = CLOCK_CacheMinuteOrSecond;
    clockData.sec = Global_REF_CLOCKDATA_STRUCT;

    if (CLOCK_CheckDateOrSecondsFromEpoch(&clockData) == 0) {
        return;
    }

    seconds = CLOCK_SecondsFromEpoch(&clockData);
    BATTCLOCK_WriteSecondsToBatteryBackedClock(seconds);
}
