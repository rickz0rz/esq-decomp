#include "esq_types.h"

/*
 * Target 608 GCC trial function.
 * Normalize a day-of-year value by subtracting whole years.
 */
s32 DATETIME_IsLeapYear(s32 year) __attribute__((noinline));

s32 DST_NormalizeDayOfYear(s16 day_of_year, s16 year) __attribute__((noinline, used));

s32 DST_NormalizeDayOfYear(s16 day_of_year, s16 year)
{
    s32 y = (s32)year;
    s32 day = (s32)day_of_year;
    s32 days_in_year;

    days_in_year = (DATETIME_IsLeapYear(y) != 0) ? 366 : 365;

    while (day > days_in_year) {
        day -= days_in_year;
        y += 1;
        days_in_year = (DATETIME_IsLeapYear(y) != 0) ? 366 : 365;
    }

    return day;
}
