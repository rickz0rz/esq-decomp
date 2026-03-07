typedef signed long LONG;
typedef signed short WORD;
typedef unsigned char UBYTE;

enum {
    DATETIME_MONTH_OFFSET = 8,
    DATETIME_SIGNFLAG_OFFSET = 18,
    DATETIME_MONTHS_PER_YEAR = 12
};

LONG DATETIME_AdjustMonthIndex(void *ctx)
{
    UBYTE *p = (UBYTE *)ctx;
    LONG month = (LONG)(WORD)(*(WORD *)(p + DATETIME_MONTH_OFFSET));
    LONG rem = month % DATETIME_MONTHS_PER_YEAR;

    if (*(WORD *)(p + DATETIME_SIGNFLAG_OFFSET) != 0) {
        rem += DATETIME_MONTHS_PER_YEAR;
    }

    *(WORD *)(p + DATETIME_MONTH_OFFSET) = (WORD)rem;
    return rem;
}
