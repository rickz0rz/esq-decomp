#include <exec/types.h>
enum {
    DATETIME_BASE_YEAR = 1900
};

LONG DATETIME_IsLeapYear(LONG year)
{
    if (year < DATETIME_BASE_YEAR) {
        year += DATETIME_BASE_YEAR;
    }

    if ((year % 4) != 0) {
        return 0;
    }

    if ((year % 100) != 0) {
        return 1;
    }

    if ((year % 400) == 0) {
        return 1;
    }

    return 0;
}
