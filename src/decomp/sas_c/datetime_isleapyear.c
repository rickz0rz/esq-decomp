typedef signed long LONG;

LONG DATETIME_IsLeapYear(LONG year)
{
    if (year < 1900) {
        year += 1900;
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
