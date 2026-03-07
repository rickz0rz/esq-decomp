typedef signed long LONG;
typedef short WORD;

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
extern LONG PARSEINI2_JMPTBL_CLOCK_CheckDateOrSecondsFromEpoch(struct ClockData *clockData);
extern LONG PARSEINI2_JMPTBL_CLOCK_SecondsFromEpoch(struct ClockData *clockData);
extern void PARSEINI2_JMPTBL_BATTCLOCK_WriteSecondsToBatteryBackedClock(LONG seconds);

void PARSEINI_WriteRtcFromGlobals(void)
{
    const WORD PTR_NULL = 0;
    const WORD MONTH_BASE = 1;
    const LONG CHECK_VALID = 0;
    struct ClockData clockData;
    LONG seconds;

    if (Global_REF_UTILITY_LIBRARY == (void *)PTR_NULL) {
        return;
    }
    if (Global_REF_BATTCLOCK_RESOURCE == (void *)PTR_NULL) {
        return;
    }

    clockData.wday = CLOCK_DaySlotIndex;
    clockData.month = (WORD)(CLOCK_CacheMonthIndex0 + MONTH_BASE);
    clockData.mday = CLOCK_CacheDayIndex0;
    clockData.year = CLOCK_CacheYear;
    clockData.hour = (WORD)PARSEINI_AdjustHoursTo24HrFormat(CLOCK_CacheHour, CLOCK_CacheAmPmFlag);
    clockData.min = CLOCK_CacheMinuteOrSecond;
    clockData.sec = Global_REF_CLOCKDATA_STRUCT;

    if (PARSEINI2_JMPTBL_CLOCK_CheckDateOrSecondsFromEpoch(&clockData) == CHECK_VALID) {
        return;
    }

    seconds = PARSEINI2_JMPTBL_CLOCK_SecondsFromEpoch(&clockData);
    PARSEINI2_JMPTBL_BATTCLOCK_WriteSecondsToBatteryBackedClock(seconds);
}
