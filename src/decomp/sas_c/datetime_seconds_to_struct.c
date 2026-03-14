#include <exec/types.h>
#define W(ptr, off) (*(short *)((char *)(ptr) + (off)))

enum {
    DATETIME_SECONDS_PER_MINUTE = 60,
    DATETIME_HOURS_PER_4YEAR_BLOCK = 35112,
    DATETIME_DAYS_PER_4YEAR_BLOCK = 1461,
    DATETIME_BASE_YEAR = 1970,
    DATETIME_HOURS_PER_YEAR = 8760,
    DATETIME_HOURS_PER_DAY = 24,
    DATETIME_DAYS_PER_WEEK = 7,
    DATETIME_WEEKDAY_EPOCH_OFFSET = 4,
    DATETIME_LEAP_DAY_OF_YEAR = 60,
    DATETIME_LEAP_MONTH_INDEX = 1,
    DATETIME_LEAP_DAY_OF_MONTH = 29,
    DATETIME_MONTHS_PER_YEAR = 12
};

extern LONG MATH_DivS32(LONG a, LONG b);
extern ULONG MATH_DivU32(ULONG a, ULONG b);
extern LONG MATH_Mulu32(LONG a, LONG b);
extern LONG DATETIME_IsLeapYear(LONG year);
extern LONG DATETIME_NormalizeMonthRange(void *dt);
extern UBYTE DATETIME_MONTH_LENGTH_AND_DAY_OFFSET_TABLES[];

void *DATETIME_SecondsToStruct(LONG seconds, void *dt)
{
    LONG years4;
    LONG remainingHours;
    LONG currentYearHours;
    LONG dayAcc;
    LONG dayOfYear;
    LONG isLeap;
    LONG month;
    LONG monthLen;

    if (seconds < 0) {
        seconds = 0;
    }

    (void)MATH_DivS32(seconds, DATETIME_SECONDS_PER_MINUTE);
    W(dt, 12) = (short)(seconds % DATETIME_SECONDS_PER_MINUTE);
    seconds /= DATETIME_SECONDS_PER_MINUTE;

    (void)MATH_DivS32(seconds, DATETIME_SECONDS_PER_MINUTE);
    W(dt, 10) = (short)(seconds % DATETIME_SECONDS_PER_MINUTE);
    seconds /= DATETIME_SECONDS_PER_MINUTE;

    (void)MATH_DivS32(seconds, DATETIME_HOURS_PER_4YEAR_BLOCK);
    years4 = seconds / DATETIME_HOURS_PER_4YEAR_BLOCK;
    W(dt, 6) = (short)(DATETIME_BASE_YEAR + years4 * 4);
    dayAcc = MATH_Mulu32(years4, DATETIME_DAYS_PER_4YEAR_BLOCK);

    (void)MATH_DivS32(seconds, DATETIME_HOURS_PER_4YEAR_BLOCK);
    remainingHours = seconds % DATETIME_HOURS_PER_4YEAR_BLOCK;

    for (;;) {
        currentYearHours = DATETIME_HOURS_PER_YEAR;
        if (DATETIME_IsLeapYear((LONG)W(dt, 6)) != 0) {
            currentYearHours += DATETIME_HOURS_PER_DAY;
        }
        if (remainingHours < currentYearHours) {
            break;
        }
        (void)MATH_DivS32(currentYearHours, DATETIME_HOURS_PER_DAY);
        dayAcc += (currentYearHours / DATETIME_HOURS_PER_DAY);
        W(dt, 6) = (short)(W(dt, 6) + 1);
        remainingHours -= currentYearHours;
    }

    (void)MATH_DivS32(remainingHours, DATETIME_HOURS_PER_DAY);
    W(dt, 8) = (short)(remainingHours % DATETIME_HOURS_PER_DAY);
    remainingHours /= DATETIME_HOURS_PER_DAY;

    dayAcc += remainingHours + DATETIME_WEEKDAY_EPOCH_OFFSET;
    (void)MATH_DivU32((ULONG)dayAcc, DATETIME_DAYS_PER_WEEK);
    W(dt, 0) = (short)((ULONG)dayAcc % DATETIME_DAYS_PER_WEEK);

    dayOfYear = remainingHours + 1;
    W(dt, 16) = (short)dayOfYear;

    isLeap = DATETIME_IsLeapYear((LONG)W(dt, 6));
    W(dt, 20) = (short)(isLeap != 0 ? -1 : 0);

    if (isLeap != 0) {
        if (dayOfYear > DATETIME_LEAP_DAY_OF_YEAR) {
            dayOfYear -= 1;
        } else if (dayOfYear == DATETIME_LEAP_DAY_OF_YEAR) {
            W(dt, 2) = DATETIME_LEAP_MONTH_INDEX;
            W(dt, 4) = DATETIME_LEAP_DAY_OF_MONTH;
            DATETIME_NormalizeMonthRange(dt);
            return dt;
        }
    }

    W(dt, 2) = 0;
    month = 0;
    while (month < DATETIME_MONTHS_PER_YEAR) {
        monthLen = (LONG)(UBYTE)DATETIME_MONTH_LENGTH_AND_DAY_OFFSET_TABLES[month];
        if (monthLen >= dayOfYear) {
            break;
        }
        dayOfYear -= monthLen;
        month += 1;
    }

    W(dt, 2) = (short)month;
    W(dt, 4) = (short)dayOfYear;
    DATETIME_NormalizeMonthRange(dt);
    return dt;
}
