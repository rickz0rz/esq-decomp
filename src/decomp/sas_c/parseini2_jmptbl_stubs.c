extern void CLOCK_ConvertAmigaSecondsToClockData(void);
extern void ESQ_CalcDayOfYearFromMonthDay(void);
extern void CLOCK_CheckDateOrSecondsFromEpoch(void);
extern void BATTCLOCK_GetSecondsFromBatteryBackedClock(void);
extern void DATETIME_IsLeapYear(void);
extern void BATTCLOCK_WriteSecondsToBatteryBackedClock(void);
extern void CLOCK_SecondsFromEpoch(void);

void PARSEINI2_JMPTBL_CLOCK_ConvertAmigaSecondsToClockData(void){CLOCK_ConvertAmigaSecondsToClockData();}
void PARSEINI2_JMPTBL_ESQ_CalcDayOfYearFromMonthDay(void){ESQ_CalcDayOfYearFromMonthDay();}
void PARSEINI2_JMPTBL_CLOCK_CheckDateOrSecondsFromEpoch(void){CLOCK_CheckDateOrSecondsFromEpoch();}
void PARSEINI2_JMPTBL_BATTCLOCK_GetSecondsFromBatteryBackedClock(void){BATTCLOCK_GetSecondsFromBatteryBackedClock();}
void PARSEINI2_JMPTBL_DATETIME_IsLeapYear(void){DATETIME_IsLeapYear();}
void PARSEINI2_JMPTBL_BATTCLOCK_WriteSecondsToBatteryBackedClock(void){BATTCLOCK_WriteSecondsToBatteryBackedClock();}
void PARSEINI2_JMPTBL_CLOCK_SecondsFromEpoch(void){CLOCK_SecondsFromEpoch();}
