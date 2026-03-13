typedef signed long LONG;
typedef signed short WORD;
typedef unsigned char UBYTE;

enum {
    DATETIME_MONTH_OFFSET = 8,
    DATETIME_SIGNFLAG_OFFSET = 18,
    DATETIME_MONTHS_PER_YEAR = 12
};

static LONG DATETIME_ModByDivS32Helper(LONG dividend, LONG divisor)
{
    return dividend % divisor;
}

LONG DATETIME_AdjustMonthIndex(void *ctx)
{
    UBYTE *ctxBytes = (UBYTE *)ctx;
    LONG month = (LONG)(WORD)(*(WORD *)(ctxBytes + DATETIME_MONTH_OFFSET));
    LONG normalizedMonth = DATETIME_ModByDivS32Helper(month, DATETIME_MONTHS_PER_YEAR);

    if (*(WORD *)(ctxBytes + DATETIME_SIGNFLAG_OFFSET) != 0) {
        normalizedMonth += DATETIME_MONTHS_PER_YEAR;
    }

    *(WORD *)(ctxBytes + DATETIME_MONTH_OFFSET) = (WORD)normalizedMonth;
    return normalizedMonth;
}
