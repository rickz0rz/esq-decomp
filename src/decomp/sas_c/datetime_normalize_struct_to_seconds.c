typedef long LONG;

#define W(ptr, off) (*(short *)((char *)(ptr) + (off)))

enum {
    DATETIME_BASE_YEAR = 1900,
    DATETIME_UNIX_EPOCH_YEAR = 1970,
    DATETIME_MAX_YEAR = 2038,
    DATETIME_LEAP_BASE_YEAR = 1968,
    DATETIME_DAYS_PER_YEAR = 365,
    DATETIME_DAYS_PER_LEAP_YEAR = 366,
    DATETIME_SECONDS_PER_DAY = 86400,
    DATETIME_SECONDS_PER_HOUR = 3600,
    DATETIME_SECONDS_PER_MINUTE = 60,
    DATETIME_HOURS_PER_DAY = 24,
    DATETIME_SECONDS_INVALID = -1
};

extern LONG DATETIME_AdjustMonthIndex(void *dt);
extern LONG DATETIME_IsLeapYear(LONG year);
extern LONG DATETIME_NormalizeMonthRange(void *dt);
extern LONG GROUP_AG_JMPTBL_MATH_Mulu32(LONG a, LONG b);

LONG DATETIME_NormalizeStructToSeconds(void *dt)
{
    LONG year;
    LONG daysInYear;
    LONG leapAdjust;
    LONG totalDays;
    LONG seconds;
    LONG carry;

    year = (LONG)W(dt, 6);
    if (year < DATETIME_BASE_YEAR) {
        W(dt, 6) = (short)(year + DATETIME_BASE_YEAR);
    }

    year = (LONG)W(dt, 6);
    if (year < DATETIME_UNIX_EPOCH_YEAR || year > DATETIME_MAX_YEAR) {
        return DATETIME_SECONDS_INVALID;
    }

    DATETIME_AdjustMonthIndex(dt);

    carry = (LONG)W(dt, 12) / DATETIME_SECONDS_PER_MINUTE;
    W(dt, 10) = (short)(W(dt, 10) + carry);
    W(dt, 12) = (short)((LONG)W(dt, 12) % DATETIME_SECONDS_PER_MINUTE);

    carry = (LONG)W(dt, 10) / DATETIME_SECONDS_PER_MINUTE;
    W(dt, 8) = (short)(W(dt, 8) + carry);
    W(dt, 10) = (short)((LONG)W(dt, 10) % DATETIME_SECONDS_PER_MINUTE);

    carry = (LONG)W(dt, 8) / DATETIME_HOURS_PER_DAY;
    W(dt, 4) = (short)(W(dt, 4) + carry);
    W(dt, 16) = (short)(W(dt, 16) + carry);
    W(dt, 8) = (short)((LONG)W(dt, 8) % DATETIME_HOURS_PER_DAY);

    daysInYear = (DATETIME_IsLeapYear((LONG)W(dt, 6)) != 0) ?
        DATETIME_DAYS_PER_LEAP_YEAR :
        DATETIME_DAYS_PER_YEAR;
    while ((LONG)W(dt, 16) > daysInYear) {
        W(dt, 16) = (short)((LONG)W(dt, 16) - daysInYear);
        W(dt, 6) = (short)(W(dt, 6) + 1);
        daysInYear = (DATETIME_IsLeapYear((LONG)W(dt, 6)) != 0) ?
            DATETIME_DAYS_PER_LEAP_YEAR :
            DATETIME_DAYS_PER_YEAR;
    }

    leapAdjust = (LONG)W(dt, 6) - DATETIME_LEAP_BASE_YEAR;
    if (leapAdjust < 0) {
        leapAdjust += 3;
    }
    leapAdjust >>= 2;
    if (DATETIME_IsLeapYear((LONG)W(dt, 6)) != 0) {
        leapAdjust -= 1;
    }

    totalDays = GROUP_AG_JMPTBL_MATH_Mulu32(
        (LONG)W(dt, 6) - DATETIME_UNIX_EPOCH_YEAR,
        DATETIME_DAYS_PER_YEAR
    );
    totalDays += leapAdjust;
    totalDays += (LONG)W(dt, 16);
    totalDays -= 1;

    seconds = GROUP_AG_JMPTBL_MATH_Mulu32(totalDays, DATETIME_SECONDS_PER_DAY);
    seconds += ((LONG)W(dt, 8) * DATETIME_SECONDS_PER_HOUR);
    seconds += ((LONG)W(dt, 10) * DATETIME_SECONDS_PER_MINUTE);
    seconds += (LONG)W(dt, 12);

    DATETIME_NormalizeMonthRange(dt);

    if (seconds <= 0) {
        return DATETIME_SECONDS_INVALID;
    }
    return seconds;
}
