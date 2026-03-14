#include <exec/types.h>
extern ULONG STRING_ToUpperChar(ULONG c);

LONG STRING_CompareNoCaseN(const char *a, const char *b, LONG maxLen)
{
    LONG diff;
    ULONG ua;
    ULONG ub;

    while (maxLen != 0 && *a != 0 && *b != 0) {
        ua = STRING_ToUpperChar((ULONG)(*a++));
        ub = STRING_ToUpperChar((ULONG)(*b++));

        diff = (LONG)ua - (LONG)ub;
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
