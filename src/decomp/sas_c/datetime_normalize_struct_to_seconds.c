typedef long LONG;

#define W(ptr, off) (*(short *)((char *)(ptr) + (off)))

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
    if (year < 1900) {
        W(dt, 6) = (short)(year + 1900);
    }

    year = (LONG)W(dt, 6);
    if (year < 1970 || year > 2038) {
        return -1;
    }

    DATETIME_AdjustMonthIndex(dt);

    carry = (LONG)W(dt, 12) / 60;
    W(dt, 10) = (short)(W(dt, 10) + carry);
    W(dt, 12) = (short)((LONG)W(dt, 12) % 60);

    carry = (LONG)W(dt, 10) / 60;
    W(dt, 8) = (short)(W(dt, 8) + carry);
    W(dt, 10) = (short)((LONG)W(dt, 10) % 60);

    carry = (LONG)W(dt, 8) / 24;
    W(dt, 4) = (short)(W(dt, 4) + carry);
    W(dt, 16) = (short)(W(dt, 16) + carry);
    W(dt, 8) = (short)((LONG)W(dt, 8) % 24);

    daysInYear = (DATETIME_IsLeapYear((LONG)W(dt, 6)) != 0) ? 366 : 365;
    while ((LONG)W(dt, 16) > daysInYear) {
        W(dt, 16) = (short)((LONG)W(dt, 16) - daysInYear);
        W(dt, 6) = (short)(W(dt, 6) + 1);
        daysInYear = (DATETIME_IsLeapYear((LONG)W(dt, 6)) != 0) ? 366 : 365;
    }

    leapAdjust = (LONG)W(dt, 6) - 1968;
    if (leapAdjust < 0) {
        leapAdjust += 3;
    }
    leapAdjust >>= 2;
    if (DATETIME_IsLeapYear((LONG)W(dt, 6)) != 0) {
        leapAdjust -= 1;
    }

    totalDays = GROUP_AG_JMPTBL_MATH_Mulu32((LONG)W(dt, 6) - 1970, 365);
    totalDays += leapAdjust;
    totalDays += (LONG)W(dt, 16);
    totalDays -= 1;

    seconds = GROUP_AG_JMPTBL_MATH_Mulu32(totalDays, 86400);
    seconds += ((LONG)W(dt, 8) * 3600);
    seconds += ((LONG)W(dt, 10) * 60);
    seconds += (LONG)W(dt, 12);

    DATETIME_NormalizeMonthRange(dt);

    if (seconds <= 0) {
        return -1;
    }
    return seconds;
}
