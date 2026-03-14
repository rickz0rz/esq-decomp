#include <exec/types.h>
extern UWORD CLOCK_CurrentDayOfWeekIndex;
extern UWORD CLOCK_CurrentMonthIndex;
extern UWORD CLOCK_CurrentDayOfMonth;
extern UWORD CLOCK_CurrentYearValue;
extern const char *Global_JMPTBL_DAYS_OF_WEEK[];
extern const char *Global_JMPTBL_MONTHS[];
extern const char Global_STR_GRID_DATE_FORMAT_STRING[];

extern LONG PARSEINI_JMPTBL_WDISP_SPrintf(char *dst, const char *fmt, const char *dayName, const char *monthName, LONG dayOfMonth, LONG yearValue);

void GENERATE_GRID_DATE_STRING(char *outBuffer)
{
    PARSEINI_JMPTBL_WDISP_SPrintf(
        outBuffer,
        Global_STR_GRID_DATE_FORMAT_STRING,
        Global_JMPTBL_DAYS_OF_WEEK[(LONG)CLOCK_CurrentDayOfWeekIndex],
        Global_JMPTBL_MONTHS[(LONG)CLOCK_CurrentMonthIndex],
        (LONG)CLOCK_CurrentDayOfMonth,
        (LONG)CLOCK_CurrentYearValue
    );
}
