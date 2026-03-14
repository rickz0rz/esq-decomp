#include <exec/types.h>
extern LONG DATETIME_IsLeapYear(LONG year);

LONG DST_NormalizeDayOfYear(WORD day_of_year, WORD year)
{
    LONG y = (LONG)year;
    LONG day = (LONG)day_of_year;
    LONG days_in_year;

    days_in_year = (DATETIME_IsLeapYear(y) != 0) ? 366 : 365;

    while (day > days_in_year) {
        day -= days_in_year;
        y += 1;
        days_in_year = (DATETIME_IsLeapYear(y) != 0) ? 366 : 365;
    }

    return day;
}
