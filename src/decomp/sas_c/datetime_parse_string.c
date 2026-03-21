#include <exec/types.h>

#define W(ptr, off) (*(WORD *)((UBYTE *)(ptr) + (off)))

enum {
    DATETIME_STRUCT_SIZE = 22,
    DATETIME_YEAR_DIVISOR = 1000,
    DATETIME_YEAR_DELTA_LIMIT = 1,
    DATETIME_MIN_DAY_OF_YEAR = 1,
    DATETIME_NONLEAP_DAY_LIMIT = 366,
    DATETIME_LEAP_EXTRA_DAY = 1,
    DATETIME_HOUR_LIMIT = 24,
    DATETIME_MINUTE_LIMIT = 60,
    DATETIME_HOUR_PARSE_OFFSET = 8,
    DATETIME_MINUTE_PARSE_OFFSET = 11,
    DATETIME_YEAR_DAY_COPY_LEN = 7,
    DATETIME_YEAR_DAY_BUF_SIZE = 8
};

extern char *STR_FindCharPtr(const char *text, LONG ch);
extern char *STRING_CopyPadNul(char *dst, const char *src, ULONG maxLen);
extern LONG PARSE_ReadSignedLongSkipClass3_Alt(const char *cursor);
extern LONG MATH_DivS32(LONG a, LONG b);
extern LONG DATETIME_IsLeapYear(LONG year);
extern LONG DATETIME_NormalizeMonthRange(void *dt);
extern LONG DATETIME_NormalizeStructToSeconds(void *dt);
extern void *DATETIME_SecondsToStruct(LONG seconds, void *dt);
extern WORD CLOCK_CacheYear;

LONG DATETIME_ParseString(void *outStruct, const char *text, LONG width)
{
    UBYTE *outBytes;
    char yearDayBuf[DATETIME_YEAR_DAY_BUF_SIZE];
    char *hit;
    LONG packedYearDay;
    LONG currentYear;
    LONG yearDelta;
    LONG leapAdjust;
    WORD parsedYear;
    WORD parsedDayOfYear;
    WORD parsedHour;
    WORD parsedMinute;
    WORD index;
    LONG success;

    success = 0;
    hit = STR_FindCharPtr(text, (UBYTE)width);
    if (hit == 0 || outStruct == 0) {
        goto parse_fail;
    }

    outBytes = (UBYTE *)outStruct;
    for (index = 0; index < DATETIME_STRUCT_SIZE; index++) {
        outBytes[index] = 0;
    }

    STRING_CopyPadNul(yearDayBuf, hit + 1, DATETIME_YEAR_DAY_COPY_LEN);
    yearDayBuf[DATETIME_YEAR_DAY_BUF_SIZE - 1] = 0;

    packedYearDay = PARSE_ReadSignedLongSkipClass3_Alt(yearDayBuf);
    (void)MATH_DivS32(packedYearDay, DATETIME_YEAR_DIVISOR);
    parsedYear = (WORD)(packedYearDay / DATETIME_YEAR_DIVISOR);
    W(outStruct, 6) = parsedYear;

    (void)MATH_DivS32(packedYearDay, DATETIME_YEAR_DIVISOR);
    parsedDayOfYear = (WORD)(packedYearDay % DATETIME_YEAR_DIVISOR);
    W(outStruct, 16) = parsedDayOfYear;

    currentYear = (LONG)CLOCK_CacheYear;
    yearDelta = (LONG)parsedYear - currentYear;
    if (yearDelta < 0) {
        yearDelta = -yearDelta;
    }
    if (yearDelta > DATETIME_YEAR_DELTA_LIMIT) {
        goto parse_fail;
    }
    if (parsedDayOfYear <= DATETIME_MIN_DAY_OF_YEAR) {
        goto parse_fail;
    }

    leapAdjust = (DATETIME_IsLeapYear((LONG)parsedYear) != 0) ? DATETIME_LEAP_EXTRA_DAY : 0;
    if ((LONG)parsedDayOfYear >= DATETIME_NONLEAP_DAY_LIMIT + leapAdjust) {
        goto parse_fail;
    }

    parsedHour = (WORD)PARSE_ReadSignedLongSkipClass3_Alt(hit + DATETIME_HOUR_PARSE_OFFSET);
    W(outStruct, 8) = parsedHour;
    if (parsedHour < 0 || parsedHour >= DATETIME_HOUR_LIMIT) {
        goto parse_fail;
    }

    parsedMinute = (WORD)PARSE_ReadSignedLongSkipClass3_Alt(hit + DATETIME_MINUTE_PARSE_OFFSET);
    W(outStruct, 10) = parsedMinute;
    if (parsedMinute < 0 || parsedMinute >= DATETIME_MINUTE_LIMIT) {
        goto parse_fail;
    }

    W(outStruct, 12) = 0;
    W(outStruct, 14) = 0;
    DATETIME_NormalizeMonthRange(outStruct);
    DATETIME_SecondsToStruct(DATETIME_NormalizeStructToSeconds(outStruct), outStruct);
    success = 1;

parse_fail:
    if (success == 0 && outStruct != 0) {
        outBytes = (UBYTE *)outStruct;
        for (index = 0; index < DATETIME_STRUCT_SIZE; index++) {
            outBytes[index] = 0;
        }
    }

    return success;
}
