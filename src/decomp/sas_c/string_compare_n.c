#include <exec/types.h>
LONG STRING_CompareN(const char *a, const char *b, LONG maxLen)
{
    LONG diff;

    while (maxLen != 0 && *a != 0 && *b != 0) {
        diff = (LONG)(*a++) - (LONG)(*b++);
        if (diff != 0) {
            return diff;
        }
        maxLen--;
    }

    if (maxLen == 0) {
        return 0;
    }

    if (*a != 0) {
        return 1;
    }

    if (*b != 0) {
        return -1;
    }

    return 0;
}
