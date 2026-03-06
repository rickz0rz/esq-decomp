typedef unsigned char UBYTE;
typedef unsigned long ULONG;
typedef long LONG;

#define W(ptr, off) (*(short *)((char *)(ptr) + (off)))

extern LONG GROUP_AG_JMPTBL_MATH_DivS32(LONG a, LONG b);
extern ULONG GROUP_AJ_JMPTBL_MATH_DivU32(ULONG a, ULONG b);
extern LONG GROUP_AJ_JMPTBL_MATH_Mulu32(LONG a, LONG b);
extern LONG DATETIME_IsLeapYear(LONG year);
extern LONG DATETIME_NormalizeMonthRange(void *dt);
extern UBYTE DATETIME_MONTH_LENGTH_AND_DAY_OFFSET_TABLES[];

void *DATETIME_SecondsToStruct(LONG seconds, void *dt)
{
    LONG years4;
    LONG remHours;
    LONG yearHours;
    LONG dayAcc;
    LONG dayOfYear;
    LONG isLeap;
    LONG month;
    LONG monthLen;

    if (seconds < 0) {
        seconds = 0;
    }

    (void)GROUP_AG_JMPTBL_MATH_DivS32(seconds, 60);
    W(dt, 12) = (short)(seconds % 60);
    seconds /= 60;

    (void)GROUP_AG_JMPTBL_MATH_DivS32(seconds, 60);
    W(dt, 10) = (short)(seconds % 60);
    seconds /= 60;

    (void)GROUP_AG_JMPTBL_MATH_DivS32(seconds, 35112);
    years4 = seconds / 35112;
    W(dt, 6) = (short)(1970 + years4 * 4);
    dayAcc = GROUP_AJ_JMPTBL_MATH_Mulu32(years4, 1461);

    (void)GROUP_AG_JMPTBL_MATH_DivS32(seconds, 35112);
    remHours = seconds % 35112;

    for (;;) {
        yearHours = 8760;
        if (DATETIME_IsLeapYear((LONG)W(dt, 6)) != 0) {
            yearHours += 24;
        }
        if (remHours < yearHours) {
            break;
        }
        (void)GROUP_AG_JMPTBL_MATH_DivS32(yearHours, 24);
        dayAcc += (yearHours / 24);
        W(dt, 6) = (short)(W(dt, 6) + 1);
        remHours -= yearHours;
    }

    (void)GROUP_AG_JMPTBL_MATH_DivS32(remHours, 24);
    W(dt, 8) = (short)(remHours % 24);
    remHours /= 24;

    dayAcc += remHours + 4;
    (void)GROUP_AJ_JMPTBL_MATH_DivU32((ULONG)dayAcc, 7);
    W(dt, 0) = (short)((ULONG)dayAcc % 7);

    dayOfYear = remHours + 1;
    W(dt, 16) = (short)dayOfYear;

    isLeap = DATETIME_IsLeapYear((LONG)W(dt, 6));
    W(dt, 20) = (short)(isLeap != 0 ? -1 : 0);

    if (isLeap != 0) {
        if (dayOfYear > 60) {
            dayOfYear -= 1;
        } else if (dayOfYear == 60) {
            W(dt, 2) = 1;
            W(dt, 4) = 29;
            DATETIME_NormalizeMonthRange(dt);
            return dt;
        }
    }

    W(dt, 2) = 0;
    month = 0;
    while (month < 12) {
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
