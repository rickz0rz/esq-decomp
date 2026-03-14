#include <exec/types.h>
extern LONG CLOCK_ConvertAmigaSecondsToClockData(LONG seconds, void *clockData);
extern void ESQ_CalcDayOfYearFromMonthDay(void *timePtr);
extern LONG CLOCK_CheckDateOrSecondsFromEpoch(void *clockData);
extern LONG BATTCLOCK_GetSecondsFromBatteryBackedClock(void);
extern LONG DATETIME_IsLeapYear(LONG year);
extern LONG BATTCLOCK_WriteSecondsToBatteryBackedClock(LONG seconds);
extern LONG CLOCK_SecondsFromEpoch(void *clockData);

LONG PARSEINI2_JMPTBL_CLOCK_ConvertAmigaSecondsToClockData(LONG seconds, void *clockData){return CLOCK_ConvertAmigaSecondsToClockData(seconds, clockData);}
void PARSEINI2_JMPTBL_ESQ_CalcDayOfYearFromMonthDay(void *timePtr){ESQ_CalcDayOfYearFromMonthDay(timePtr);}
LONG PARSEINI2_JMPTBL_CLOCK_CheckDateOrSecondsFromEpoch(void *clockData){return CLOCK_CheckDateOrSecondsFromEpoch(clockData);}
LONG PARSEINI2_JMPTBL_BATTCLOCK_GetSecondsFromBatteryBackedClock(void){return BATTCLOCK_GetSecondsFromBatteryBackedClock();}
LONG PARSEINI2_JMPTBL_DATETIME_IsLeapYear(LONG year){return DATETIME_IsLeapYear(year);}
LONG PARSEINI2_JMPTBL_BATTCLOCK_WriteSecondsToBatteryBackedClock(LONG seconds){return BATTCLOCK_WriteSecondsToBatteryBackedClock(seconds);}
LONG PARSEINI2_JMPTBL_CLOCK_SecondsFromEpoch(void *clockData){return CLOCK_SecondsFromEpoch(clockData);}
