#include <exec/types.h>

LONG __stdargs TESTFN(WORD hour, WORD amPmFlag)
{
    WORD result;

    result = hour;
    if (result == 12 && amPmFlag == 0) {
        result = 0;
    } else if (result < 12 && amPmFlag == (WORD)-1) {
        result = (WORD)(result + 12);
    }

    return (LONG)result;
}
