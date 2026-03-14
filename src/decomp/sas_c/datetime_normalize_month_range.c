#include <exec/types.h>
enum {
    DATETIME_MONTH_OFFSET = 8,
    DATETIME_OVERFLOW_FLAG_OFFSET = 18,
    DATETIME_OVERFLOW_NEGATIVE_ONE = -1,
    DATETIME_OVERFLOW_ZERO = 0,
    DATETIME_MONTH_MAX_INDEX = 11,
    DATETIME_MONTHS_PER_YEAR = 12
};

LONG DATETIME_NormalizeMonthRange(void *ctx)
{
    UBYTE *ctxBytes = (UBYTE *)ctx;
    WORD month = *(WORD *)(ctxBytes + DATETIME_MONTH_OFFSET);
    WORD overflow = (month > DATETIME_MONTH_MAX_INDEX)
        ? (WORD)DATETIME_OVERFLOW_NEGATIVE_ONE
        : (WORD)DATETIME_OVERFLOW_ZERO;
    WORD normalizedMonth;

    *(WORD *)(ctxBytes + DATETIME_OVERFLOW_FLAG_OFFSET) = overflow;

    normalizedMonth = (WORD)(month % DATETIME_MONTHS_PER_YEAR);
    *(WORD *)(ctxBytes + DATETIME_MONTH_OFFSET) = normalizedMonth;

    if (normalizedMonth == 0) {
        *(WORD *)(ctxBytes + DATETIME_MONTH_OFFSET) = DATETIME_MONTHS_PER_YEAR;
    }

    return (LONG)normalizedMonth;
}
