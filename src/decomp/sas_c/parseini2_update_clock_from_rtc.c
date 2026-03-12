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

struct ClockNormData {
    WORD wday;
    WORD month;
    WORD mday;
    WORD year;
    WORD hour;
    WORD min;
    WORD sec;
    WORD dstCountdown;
    WORD pad0;
    WORD pad1;
    WORD pad2;
};

extern void *Global_REF_UTILITY_LIBRARY;
extern void *Global_REF_BATTCLOCK_RESOURCE;
extern WORD CLOCK_DaySlotIndex;
extern WORD DST_PrimaryCountdown;
extern struct ClockNormData PARSEINI_FallbackClockDataRecord;

extern LONG BATTCLOCK_GetSecondsFromBatteryBackedClock(void);
extern void CLOCK_ConvertAmigaSecondsToClockData(LONG seconds, struct ClockData *clockData);
extern LONG CLOCK_CheckDateOrSecondsFromEpoch(struct ClockData *clockData);
extern void PARSEINI_NormalizeClockData(struct ClockNormData *dstClockData, struct ClockNormData *srcClockData);

void PARSEINI_UpdateClockFromRtc(void)
{
    LONG seconds;
    struct ClockData clockData;
    struct ClockNormData localData;

    if (Global_REF_UTILITY_LIBRARY == (void *)0) {
        return;
    }
    if (Global_REF_BATTCLOCK_RESOURCE == (void *)0) {
        return;
    }

    seconds = BATTCLOCK_GetSecondsFromBatteryBackedClock();
    CLOCK_ConvertAmigaSecondsToClockData(seconds, &clockData);
    if (CLOCK_CheckDateOrSecondsFromEpoch(&clockData) == 0) {
        PARSEINI_NormalizeClockData((struct ClockNormData *)&CLOCK_DaySlotIndex, &PARSEINI_FallbackClockDataRecord);
        return;
    }

    localData.wday = clockData.wday;
    localData.month = (WORD)(clockData.month - 1);
    localData.mday = (WORD)(clockData.mday - 1);
    localData.year = clockData.year;
    localData.hour = clockData.hour;
    localData.min = clockData.min;
    localData.sec = clockData.sec;
    localData.dstCountdown = DST_PrimaryCountdown;
    localData.pad0 = 0;
    localData.pad1 = 0;
    localData.pad2 = 0;

    PARSEINI_NormalizeClockData((struct ClockNormData *)&CLOCK_DaySlotIndex, &localData);
}
