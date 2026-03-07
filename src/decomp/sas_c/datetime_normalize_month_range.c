typedef signed long LONG;
typedef signed short WORD;
typedef unsigned char UBYTE;

enum {
    DATETIME_MONTH_OFFSET = 8,
    DATETIME_OVERFLOW_FLAG_OFFSET = 18,
    DATETIME_MONTH_MAX_INDEX = 11,
    DATETIME_MONTHS_PER_YEAR = 12
};

LONG DATETIME_NormalizeMonthRange(void *ctx)
{
    UBYTE *p = (UBYTE *)ctx;
    WORD month = *(WORD *)(p + DATETIME_MONTH_OFFSET);
    WORD overflow = (month > DATETIME_MONTH_MAX_INDEX) ? (WORD)-1 : (WORD)0;
    WORD rem;

    *(WORD *)(p + DATETIME_OVERFLOW_FLAG_OFFSET) = overflow;

    rem = (WORD)(month % DATETIME_MONTHS_PER_YEAR);
    *(WORD *)(p + DATETIME_MONTH_OFFSET) = rem;

    if (rem == 0) {
        *(WORD *)(p + DATETIME_MONTH_OFFSET) = DATETIME_MONTHS_PER_YEAR;
    }

    return (LONG)rem;
}
