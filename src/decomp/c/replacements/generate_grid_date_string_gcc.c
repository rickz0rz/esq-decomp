#include "esq_types.h"

extern s16 CLOCK_CurrentDayOfWeekIndex;
extern s16 CLOCK_CurrentMonthIndex;
extern s16 CLOCK_CurrentDayOfMonth;
extern s16 CLOCK_CurrentYearValue;
extern u8 *Global_JMPTBL_DAYS_OF_WEEK[];
extern u8 *Global_JMPTBL_MONTHS[];
extern u8 Global_STR_GRID_DATE_FORMAT_STRING[];

void PARSEINI_JMPTBL_WDISP_SPrintf(u8 *out, const u8 *fmt, ...) __attribute__((noinline));

void GENERATE_GRID_DATE_STRING(u8 *out) __attribute__((noinline, used));

void GENERATE_GRID_DATE_STRING(u8 *out)
{
    PARSEINI_JMPTBL_WDISP_SPrintf(
        out,
        Global_STR_GRID_DATE_FORMAT_STRING,
        Global_JMPTBL_DAYS_OF_WEEK[(u16)CLOCK_CurrentDayOfWeekIndex],
        Global_JMPTBL_MONTHS[(u16)CLOCK_CurrentMonthIndex],
        (s32)CLOCK_CurrentDayOfMonth,
        (s32)CLOCK_CurrentYearValue
    );
}
